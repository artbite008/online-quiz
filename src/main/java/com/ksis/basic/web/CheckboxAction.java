package com.ksis.basic.web;

import java.io.PrintWriter;

import java.util.ArrayList;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

import org.springframework.beans.factory.annotation.Autowired;

import com.ksis.basic.entity.Choice;
import com.ksis.basic.entity.Question;
import com.ksis.basic.entity.SortedExamDetail;
import com.ksis.basic.entity.SortedQuestion;
import com.ksis.basic.service.KsisBaseManager;
import com.ksis.core.util.web.struts2.AjaxActionSupport;

@Namespace("/exam")
@Results( { @Result(name = AjaxActionSupport.RELOAD, location = "checkbox.action", type = "redirect") })
public class CheckboxAction extends QuestionAction {

    private String questionContent;
    private String correctAnswer;
    private String indexId;

    @Override
    public String execute() throws Exception {
        if (questionId == null) {
            question = new SortedQuestion();
        } else {
            question = baseManager.getQuestionById(questionId);
        }

        return SUCCESS;
    }

    public String add() throws Exception {

        HttpServletResponse response = ServletActionContext.getResponse();
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();


        SortedExamDetail exam = baseManager.getSortedExamById(examId);
        question.setExam(exam);
        question.setQuestionType(3); //checkbox

        exam.getQuestions().add(question);
        baseManager.saveExam(exam);

        StringBuilder jason =
            new StringBuilder("{'status':1,'questionId':" + question.getQuestionId() + ",'newQuestionHtml':'");

        if (exam.getQuestions().size() % 2 == 1) {
            jason.append("<div style=\"padding-left:10px; text-valign=top;padding-top:5px;width:970px;float:left;\" id=\"question_" +
                         question.getQuestionId() + "\"> ");
        } else {
            jason.append("<div style=\"background-color: #fcfcfc;padding-left:10px; text-valign=top;padding-top:5px;width:970px;float:left;\" id=\"question_" +
                         question.getQuestionId() + "\"> ");
        }

        jason.append("<div style=\"width:905px;float:left;\">");
        jason.append("<b>" + (exam.getQuestions().size()) + ".</b>&nbsp;" + question.getContent() + "(判断题)");
        jason.append("<br/>&nbsp;&nbsp;&nbsp;&nbsp;答案:" + ("1".equals(question.getCorrectAnswer()) ? "正确" : "错误"));
        jason.append("</div>");


        jason.append("<div style=\"float:left; padding-left:5px; width:50px;height:auto;\" id=\"maintainQues_" +
                     question.getQuestionId() + "\">");
        jason.append("<li class=\"editbutton\"><a href=\"#\" onclick=\"updateCheckbox(" + question.getQuestionId() +
                     "," + (exam.getQuestions().size()) + ");\">编辑</a></li>");
        jason.append("<li class=\"deletebutton\"><a href=\"#\" onclick=\"deleteQuestion(" + question.getQuestionId() +
                     ");\">删除</a></li>");
        jason.append("</div></div>'}");

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

        String content = question.getContent();
        String correctAnswer = question.getCorrectAnswer();
        question = baseManager.getQuestionById(questionId);

        question.setQuestionType(3);
        question.setContent(content);
        question.setCorrectAnswer(correctAnswer);

        baseManager.saveQuestion(question);

        StringBuilder jason =
            new StringBuilder("{'status':2,'questionId':" + question.getQuestionId() + ",'newQuestionHtml':'");

        jason.append("<div style=\"width:905px;float:left;\">");
        jason.append("<b>" + indexId + ".</b>&nbsp;" + question.getContent() + "(判断题)");
        jason.append("<br/>&nbsp;&nbsp;&nbsp;&nbsp;答案:" + ("1".equals(question.getCorrectAnswer()) ? "正确" : "错误"));
        jason.append("</div>");


        jason.append("<div style=\"float:left; padding-left:5px; width:50px;height:auto;\" id=\"maintainQues_" +
                     question.getQuestionId() + "\">");
        jason.append("<li class=\"editbutton\"><a href=\"#\" onclick=\"updateCheckbox(" + question.getQuestionId() +
                     "," + indexId + ");\">编辑</a></li>");
        jason.append("<li class=\"deletebutton\"><a href=\"#\" onclick=\"deleteQuestion(" + question.getQuestionId() +
                     ");\">删除</a></li>");
        jason.append("</div>'}");

        JSONObject jsonObject = JSONObject.fromObject(jason.toString());
        out.write(jsonObject.toString());

        out.flush();
        out.close();

        return null;
    }


    public String getQuestionContent() {
        return questionContent;
    }

    public void setQuestionContent(String questionContent) {
        this.questionContent = questionContent;
    }

    public String getCorrectAnswer() {
        return correctAnswer;
    }

    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }

    public String getIndexId() {
        return indexId;
    }

    public void setIndexId(String indexId) {
        this.indexId = indexId;
    }
}
