package com.ksis.basic.web;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

import com.ksis.basic.entity.SortedExamDetail;
import com.ksis.basic.entity.SortedQuestion;
import com.ksis.core.util.web.struts2.AjaxActionSupport;

@Namespace("/exam")
@Results( { @Result(name = AjaxActionSupport.RELOAD, location = "questionEssay.action", type = "redirect") })
public class EssayAction extends QuestionAction {

    private String content;
    private String type = "essay";
    private String answerLength;
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
        question.setQuestionType("essay".equalsIgnoreCase(type) ? 4 : 5);

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
        if ("essay".equalsIgnoreCase(type)) {
            jason.append("<b>" + (exam.getQuestions().size()) + ".</b>&nbsp;" + question.getContent() + "(简答题)");
            jason.append("<br/>&nbsp;&nbsp;&nbsp;&nbsp;答案最大字数:" + question.getAnswerLength());
        } else {
            jason.append("<b>" + (exam.getQuestions().size()) + ".</b>&nbsp;" + question.getContent() + "(备注)");
            jason.append("<br/>&nbsp;&nbsp;&nbsp;&nbsp;");
        }
        jason.append("</div>");


        jason.append("<div style=\"float:left; padding-left:5px; width:50px;height:auto;\" id=\"maintainQues_" +
                     question.getQuestionId() + "\">");
        if ("essay".equalsIgnoreCase(type)) {
            jason.append("<li class=\"editbutton\"><a href=\"#\" onclick=\"updateEssay(" + question.getQuestionId() +
                         "," + (exam.getQuestions().size()) + ");\">编辑</a></li>");
        } else {
            jason.append("<li class=\"editbutton\"><a href=\"#\" onclick=\"updateNote(" + question.getQuestionId() +
                         "," + (exam.getQuestions().size()) + ");\">编辑</a></li>");
        }
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
        String answerLength = question.getAnswerLength();
        question = baseManager.getQuestionById(questionId);

        question.setContent(content);
        question.setAnswerLength(answerLength);
        question.setQuestionType("essay".equalsIgnoreCase(type) ? 4 : 5);

        baseManager.saveQuestion(question);

        StringBuilder jason =
            new StringBuilder("{'status':2,'questionId':" + question.getQuestionId() + ",'newQuestionHtml':'");

        jason.append("<div style=\"width:905px;float:left;\">");
        if ("essay".equalsIgnoreCase(type)) {
            jason.append("<b>" + indexId + ".</b>&nbsp;" + question.getContent() + "(简答题)");
            jason.append("<br/>&nbsp;&nbsp;&nbsp;&nbsp;答案最大字数:&nbsp;" + question.getAnswerLength());
        } else {
            jason.append("<b>" + indexId + ".</b>&nbsp;" + question.getContent() + "(备注)");
            jason.append("<br/>&nbsp;&nbsp;&nbsp;&nbsp;");
        }
        jason.append("</div>");


        jason.append("<div style=\"float:left; padding-left:5px; width:50px;height:auto;\" id=\"maintainQues_" +
                     question.getQuestionId() + "\">");
        if ("essay".equalsIgnoreCase(type)) {
            jason.append("<li class=\"editbutton\"><a href=\"#\" onclick=\"updateEssay(" + question.getQuestionId() +
                         "," + indexId + ");\">编辑</a></li>");
        } else {
            jason.append("<li class=\"editbutton\"><a href=\"#\" onclick=\"updateNote(" + question.getQuestionId() +
                         "," + indexId + ");\">编辑</a></li>");
        }
        jason.append("<li class=\"deletebutton\"><a href=\"#\" onclick=\"deleteQuestion(" + question.getQuestionId() +
                     ");\">删除</a></li>");
        jason.append("</div>'}");

        JSONObject jsonObject = JSONObject.fromObject(jason.toString());
        out.write(jsonObject.toString());

        out.flush();
        out.close();

        return null;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getAnswerLength() {
        return answerLength;
    }

    public void setAnswerLength(String answerLength) {
        this.answerLength = answerLength;
    }

    public String getIndexId() {
        return indexId;
    }

    public void setIndexId(String indexId) {
        this.indexId = indexId;
    }

}
