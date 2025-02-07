package com.ksis.basic.web;

import java.io.PrintWriter;

import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

import org.springframework.beans.factory.annotation.Autowired;

import com.ksis.basic.entity.Choice;
import com.ksis.basic.entity.ExamDetail;
import com.ksis.basic.entity.SortedQuestion;
import com.ksis.basic.entity.SortedExamDetail;
import com.ksis.basic.entity.User;
import com.ksis.basic.service.KsisBaseManager;
import com.ksis.core.util.web.struts2.AjaxActionSupport;

import com.opensymphony.xwork2.ActionContext;

@Namespace("/exam")
@Results( { @Result(name = AjaxActionSupport.RELOAD, location = "choice.action", type = "redirect") })
public class ChoiceAction extends QuestionAction {

    private String indexId;
    private String jason_error;
    private String correctAnswer_error;

    private String[] choices = new String[10];
    //默认为新建问题的情况，前面四个答案显示
    private String[] divVisiableFlags =
    { "block", "block", "block", "block", "none", "none", "none", "none", "none", "none" };
    private String[] answerFlags = new String[10];

    private String choic1;
    private String choic2;
    private String choic3;
    private String choic4;
    private String choic5;
    private String choic6;
    private String choic7;
    private String choic8;
    private String choic9;
    private String choic10;

    private Integer choiceId;

    public String delete() throws Exception {
        Choice choice = baseManager.getChoiceById(choiceId);
        choice.getQuestion().getChoices().remove(choice);
        baseManager.deleteChoice(choice);
        return null;
    }

    @Override
    public String execute() throws Exception {
        if (questionId == null) {
            question = new SortedQuestion();
        } else {
            question = baseManager.getQuestionById(questionId);
            for (int i = 0; i < question.getChoices().size(); i++) {
                Choice choice = question.getChoices().get(i);
                String choiceKey = String.valueOf(choice.getChoiceKey());
                choices[i] = choice.getChoiceContent();
                answerFlags[i] = question.getCorrectAnswer().indexOf(choiceKey) != -1 ? "checked" : "";
                divVisiableFlags[i] = "block";
            }

            choic1 = choices[0];
            choic2 = choices[1];
            choic3 = choices[2];
            choic4 = choices[3];
            choic5 = choices[4];
            choic6 = choices[5];
            choic7 = choices[6];
            choic8 = choices[7];
            choic9 = choices[8];
            choic10 = choices[9];
        }

        return SUCCESS;
    }

    public boolean validateFrom() {
        jason_error = "{'status':";
        boolean flag = true;
        if (question.getContent() == null || question.getContent().length() < 1) {
            jason_error = jason_error + "-1, 'msg':'请填写题目内容.'}";
            flag = false;
        }
        if (question.getCorrectAnswer() == null || question.getCorrectAnswer().length() < 1) {
            jason_error = jason_error + "-2, 'msg':'请指定一个或多个正确答案.'}";
            flag = false;
        }

        return flag;
    }

    public String add() throws Exception {

        HttpServletResponse response = ServletActionContext.getResponse();
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        if (!validateFrom()) {
            JSONObject jsonObject = JSONObject.fromObject(jason_error);
            out.write(jsonObject.toString());
            out.flush();
            out.close();
            return null;
        }

        SortedExamDetail exam = baseManager.getSortedExamById(examId);
        question.setExam(exam);
        question.setChoices(new ArrayList<Choice>());
        if (question.getCorrectAnswer().contains(",")) {
            question.setQuestionType(2); //multi select
        } else {
            question.setQuestionType(1); //single select
        }

        choices[0] = choic1;
        choices[1] = choic2;
        choices[2] = choic3;
        choices[3] = choic4;
        choices[4] = choic5;
        choices[5] = choic6;
        choices[6] = choic7;
        choices[7] = choic8;
        choices[8] = choic9;
        choices[9] = choic10;

        String[] correctAnswers = question.getCorrectAnswer().split(",");
        for (int i = 0; i < choices.length; i++) {
            if (choices[i] != null && choices[i].length() > 0) {
                Choice ch = new Choice();
                ch.setChoiceContent(choices[i]);
                ch.setChoiceKey(i + 1);
                ch.setQuestion(question);
                for (String correctKey : correctAnswers) {
                    if (correctKey.equals(String.valueOf(ch.getChoiceKey()))) {
                        ch.setCorrect(true);
                        break;
                    }
                }
                question.getChoices().add(ch);
            }
        }

        exam.getQuestions().add(question);
        baseManager.saveExam(exam);

        StringBuilder jason = new StringBuilder("{'status':1,'newQuestionHtml':'");

        if (exam.getQuestions().size() % 2 == 1) {
            jason.append("<div style=\"padding-left:10px; text-valign=top;padding-top:5px;width:970px;float:left;\" id=\"question_" +
                         question.getQuestionId() + "\"> ");
        } else {
            jason.append("<div style=\"background-color: #fcfcfc;padding-left:10px; text-valign=top;padding-top:5px;width:970px;float:left;\" id=\"question_" +
                         question.getQuestionId() + "\"> ");
        }
        jason.append("<div style=\"width:905px;float:left;\">");
        jason.append("<b>" + (exam.getQuestions().size()) + ".</b>&nbsp;" + question.getContent());
        if (question.getQuestionType() == 1) {
            jason.append("(单选题)");
        } else {
            jason.append("(多选题)");
        }
        jason.append("<br/><table border=0 cellpadding=0 spacepadding=0>");
        for (int i = 0; i < question.getChoices().size(); i++) {
            jason.append("<tr>");
            if (question.getChoices().get(i).getIsCorrect()) {
                jason.append("<td><img src=\"../images/correct_flag.png\"/></td>");
            } else {
                jason.append("<td>&nbsp;</td>");
            }
            jason.append("<td>" + (i + 1) + ".&nbsp;" + question.getChoices().get(i).getChoiceContent() +
                         "</td></tr>");
        }
        jason.append("</table></div>");

        jason.append("<div style=\"float:left; padding-left:5px; width:50px;height:auto;\" id=\"maintainQues_" +
                     question.getQuestionId() + "\">");
        jason.append("<li class=\"editbutton\"><a href=\"#\" onclick=\"updateChoice(" + question.getQuestionId() +
                     "," + (exam.getQuestions().size()) + ");\">编辑</a></li>");
        jason.append("<li class=\"deletebutton\"><a href=\"#\" onclick=\"deleteChoice(" + question.getQuestionId() +
                     ");\">删除</a></li>");
        jason.append("</div></div><div class=\"clear\"></div>'}");

        JSONObject jsonObject = JSONObject.fromObject(jason.toString());
        out.write(jsonObject.toString());

        out.flush();
        out.close();

        return null;
    }


    public String update() throws Exception {
        HttpServletResponse response = ServletActionContext.getResponse();
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        if (!validateFrom()) {
            JSONObject jsonObject = JSONObject.fromObject(jason_error);
            out.write(jsonObject.toString());
            out.flush();
            out.close();
            return null;
        }

        String content = question.getContent();
        String correctAnswer = question.getCorrectAnswer();
        question = baseManager.getQuestionById(questionId);

        if (correctAnswer.contains(",")) {
            question.setQuestionType(2);
        } else {
            question.setQuestionType(1);
        }
        question.setContent(content);
        question.setCorrectAnswer(correctAnswer);

        choices[0] = choic1;
        choices[1] = choic2;
        choices[2] = choic3;
        choices[3] = choic4;
        choices[4] = choic5;
        choices[5] = choic6;
        choices[6] = choic7;
        choices[7] = choic8;
        choices[8] = choic9;
        choices[9] = choic10;

        String[] correctAnswers = question.getCorrectAnswer().split(",");
        for (int i = 0; i < choices.length; i++) {
            if (choices[i] != null && choices[i].length() > 0) {
                if (question.getChoices().size() > i) {
                    question.getChoices().get(i).setChoiceContent(choices[i]);
                    Choice ch = question.getChoices().get(i);
                    for (String correctKey : correctAnswers) {
                        if (correctKey.equals(String.valueOf(ch.getChoiceKey()))) {
                            ch.setCorrect(true);
                            break;
                        }
                    }
                } else {
                    Choice ch = new Choice();
                    ch.setChoiceContent(choices[i]);
                    ch.setChoiceKey(i + 1);
                    ch.setQuestion(question);
                    for (String correctKey : correctAnswers) {
                        if (correctKey.equals(String.valueOf(ch.getChoiceKey()))) {
                            ch.setCorrect(true);
                            break;
                        }
                    }
                    question.getChoices().add(ch);
                }
            }
        }

        baseManager.saveQuestion(question);

        StringBuilder jason =
            new StringBuilder("{'status':2,'questionId':" + question.getQuestionId() + ",'newQuestionHtml':'");

        jason.append("<div style=\"width:905px;float:left;\">");
        jason.append("<b>" + indexId + ".</b>&nbsp;" + question.getContent());
        if (question.getQuestionType() == 1) {
            jason.append("(单选题)");
        } else {
            jason.append("(多选题)");
        }
        jason.append("<br/><table border=0 cellpadding=0 spacepadding=0>");
        for (int i = 0; i < question.getChoices().size(); i++) {
            jason.append("<tr>");
            if (question.getChoices().get(i).getIsCorrect()) {
                jason.append("<td><img src=\"../images/correct_flag.png\"/></td>");
            } else {
                jason.append("<td>&nbsp;</td>");
            }
            jason.append("<td>" + (i + 1) + ".&nbsp;" + question.getChoices().get(i).getChoiceContent() +
                         "</td></tr>");
        }
        jason.append("</table></div>");

        jason.append("<div style=\"float:left; padding-left:5px; width:50px;height:auto;\" id=\"maintainQues_" +
                     question.getQuestionId() + "\">");
        jason.append("<li class=\"editbutton\"><a href=\"#\" onclick=\"updateChoice(" + question.getQuestionId() +
                     "," + indexId + ");\">编辑</a></li>");
        jason.append("<li class=\"deletebutton\"><a href=\"#\" onclick=\"deleteChoice(" + question.getQuestionId() +
                     ");\">删除</a></li>");
        jason.append("</div>'}");

        JSONObject jsonObject = JSONObject.fromObject(jason.toString());
        out.write(jsonObject.toString());

        out.flush();
        out.close();

        return null;
    }


    public String updateChoiceProperty() throws Exception {
        String jasonStr = "";

        if (choiceId == null) {
            //to do						
        } else {
            Choice choice = baseManager.getChoiceById(choiceId);
            setPropertyValue(choice, this.getPropertyName(), this.getPropertyValue());
            baseManager.saveChoice(choice);
            jasonStr = "{'status':0}";
        }

        super.renderJson(jasonStr);
        return null;
    }


    public String getContent_error() {
        return jason_error;
    }

    public void setContent_error(String content_error) {
        this.jason_error = content_error;
    }

    public String getCorrectAnswer_error() {
        return correctAnswer_error;
    }

    public void setCorrectAnswer_error(String correctAnswer_error) {
        this.correctAnswer_error = correctAnswer_error;
    }

    public String[] getChoices() {
        return choices;
    }

    public void setChoices(String[] choices) {
        this.choices = choices;
    }

    public String[] getDivVisiableFlags() {
        return divVisiableFlags;
    }

    public void setDivVisiableFlags(String[] divVisiableFlags) {
        this.divVisiableFlags = divVisiableFlags;
    }

    public String[] getAnswerFlags() {
        return answerFlags;
    }

    public void setAnswerFlags(String[] answerFlags) {
        this.answerFlags = answerFlags;
    }

    public String getChoic1() {
        return choic1;
    }

    public void setChoic1(String choic1) {
        this.choic1 = choic1;
    }

    public String getChoic2() {
        return choic2;
    }

    public void setChoic2(String choic2) {
        this.choic2 = choic2;
    }

    public String getChoic3() {
        return choic3;
    }

    public void setChoic3(String choic3) {
        this.choic3 = choic3;
    }

    public String getChoic4() {
        return choic4;
    }

    public void setChoic4(String choic4) {
        this.choic4 = choic4;
    }

    public String getChoic5() {
        return choic5;
    }

    public void setChoic5(String choic5) {
        this.choic5 = choic5;
    }

    public String getChoic6() {
        return choic6;
    }

    public void setChoic6(String choic6) {
        this.choic6 = choic6;
    }

    public String getChoic7() {
        return choic7;
    }

    public void setChoic7(String choic7) {
        this.choic7 = choic7;
    }

    public String getChoic8() {
        return choic8;
    }

    public void setChoic8(String choic8) {
        this.choic8 = choic8;
    }

    public String getChoic9() {
        return choic9;
    }

    public void setChoic9(String choic9) {
        this.choic9 = choic9;
    }

    public String getChoic10() {
        return choic10;
    }

    public void setChoic10(String choic10) {
        this.choic10 = choic10;
    }

    public String getIndexId() {
        return indexId;
    }

    public void setIndexId(String indexId) {
        this.indexId = indexId;
    }

    public Integer getChoiceId() {
        return choiceId;
    }

    public void setChoiceId(Integer choiceId) {
        this.choiceId = choiceId;
    }


}
