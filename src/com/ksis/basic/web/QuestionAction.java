package com.ksis.basic.web;

import java.util.Map;

import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

import org.springframework.beans.factory.annotation.Autowired;

import com.ksis.basic.entity.SortedExamDetail;
import com.ksis.basic.entity.SortedQuestion;
import com.ksis.basic.entity.User;
import com.ksis.basic.service.KsisBaseManager;
import com.ksis.core.util.web.struts2.AjaxActionSupport;

import com.opensymphony.xwork2.ActionContext;

import java.util.List;

@Namespace("/exam")
@Results( { @Result(name = AjaxActionSupport.RELOAD, location = "question.action", type = "redirect") })
public class QuestionAction extends AjaxActionSupport {
    protected Integer questionId;
    protected SortedQuestion question;
    protected Integer examId;
    private String propertyValue;
    private String propertyName;
    private String propertyType="string";

    @Autowired
    protected KsisBaseManager baseManager;

    public String delete() throws Exception {
        question = baseManager.getQuestionById(questionId);
        question.getExam().getQuestions().remove(question);
        baseManager.deleteQuestion(question);
        return null;
    }

    public String updateQuestionProperty() throws Exception {
        String jasonStr = "";

        SortedExamDetail exam = baseManager.getSortedExamById(examId);

        if (questionId == null) {
            SortedQuestion question = new SortedQuestion();
            question.setExam(exam);
            setPropertyValue(question, propertyName, propertyValue);

            question = baseManager.saveQuestion(question);
            jasonStr = "{'status':1,'questionId':" + question.getQuestionId() + "}";
        } else if (isQuestionAlreadyBound(exam.getQuestions(), questionId)) {
            question = baseManager.getQuestionById(questionId);
            setPropertyValue(question, propertyName, propertyValue);
            baseManager.saveQuestion(question);
            jasonStr = "{'status':0}";
        } else { // question is new question, not yet been bound to exam
            question = baseManager.getQuestionById(questionId);
            
            //string is the default value of propertyType 
            if(propertyType == null || propertyType.length()<1 || "string".equalsIgnoreCase(propertyType) ){
                setPropertyValue(question, propertyName, propertyValue);
            }else if("number".equalsIgnoreCase(propertyType)){
                Integer intValue = Integer.parseInt(propertyValue);
                setPropertyValue(question, propertyName, intValue);
            }
            
            question.setExam(exam);
            exam.getQuestions().add(question);
            baseManager.saveExam(exam);
        }

        super.renderJson(jasonStr);
        return null;
    }

    private boolean isQuestionAlreadyBound(List<SortedQuestion> questionList, Integer questionId) {
        boolean isBound = false;
        for (SortedQuestion question : questionList) {
            if (question.getQuestionId() == questionId) {
                return true;
            }
        }
        return isBound;
    }

    public Integer getQuestionId() {
        return questionId;
    }

    public void setQuestionId(Integer questionId) {
        this.questionId = questionId;
    }

    public SortedQuestion getQuestion() {
        return question;
    }

    public void setQuestion(SortedQuestion question) {
        this.question = question;
    }

    public Integer getExamId() {
        return examId;
    }

    public void setExamId(Integer examId) {
        this.examId = examId;
    }

    public String getPropertyValue() {
        return propertyValue;
    }

    public void setPropertyValue(String propertyValue) {
        this.propertyValue = propertyValue;
    }

    public String getPropertyName() {
        return propertyName;
    }

    public void setPropertyName(String propertyName) {
        this.propertyName = propertyName;
    }

    public void setPropertyType(String propertyType) {
        this.propertyType = propertyType;
    }

    public String getPropertyType() {
        return propertyType;
    }
}
