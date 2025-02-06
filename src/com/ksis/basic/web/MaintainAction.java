package com.ksis.basic.web;

import java.io.PrintWriter;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

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
import com.ksis.core.util.ServiceException;
import com.ksis.core.util.web.struts2.AjaxActionSupport;

import com.opensymphony.xwork2.ActionContext;

@Namespace("/exam")
@Results( { @Result(name = AjaxActionSupport.RELOAD, location = "maintain.action", type = "redirect"),
            @Result(name = "EXAM_LIST", location = "list.action", type = "redirect") })
public class MaintainAction extends AjaxActionSupport {
    private Integer examId;
    private SortedExamDetail exam;
    private String propertyValue;
    private String propertyName;

    @Autowired
    private KsisBaseManager baseManager;


    @Override
    public String execute() throws Exception {

        if (examId != null && examId != -1) {
            exam = baseManager.getSortedExamById(examId);

            //如果第一个题目不是备注，添加一个空的备注到第一个位置
            boolean hasNote = false;
            for (SortedQuestion q : exam.getQuestions()) {
                if (5 == q.getQuestionType()) {
                    hasNote = true;
                    break;
                }
            }
            if (exam.getQuestions().size() > 0 && !hasNote) { //如果有题目但是没有备注
                SortedQuestion note = new SortedQuestion();
                note.setQuestionType(5);
                note = baseManager.saveQuestion(note);
                note.setHint("点击这里编辑试题备注");
                note.setIsBlank(true);
                exam.getQuestions().add(0, note);
            }
        } else if (examId != null && examId == -1) { //新建试题
            exam = new SortedExamDetail();
            exam.setName("新建考试试题");
            exam.setShortName("试题编号");

            ActionContext context = ActionContext.getContext();
            Map session = context.getSession();

            exam.setCreatorId(((User)session.get("loggedUser")).getUserId());
            exam.setQuestions(new ArrayList<SortedQuestion>());

            exam = baseManager.saveExam(exam);
            examId = exam.getExamId();
        } else { //既不是更新操作，也不是添加造作
            exam = null;
        }

        if (exam != null && exam.getQuestions().size() == 0) {
            //创建5个不同的空的题目
            SortedQuestion singleChoice = new SortedQuestion();
            singleChoice.setQuestionType(1);
            Choice choice1 = new Choice();
            choice1.setChoiceKey(1);
            choice1.setBlank(true);
            choice1.setHint("点击这里编辑单选题选项1");
            Choice choice2 = new Choice();
            choice2.setChoiceKey(2);
            choice2.setBlank(true);
            choice2.setHint("点击这里编辑单选题选项2");
            Choice choice3 = new Choice();
            choice3.setChoiceKey(3);
            choice3.setBlank(true);
            choice3.setHint("点击这里编辑单选题选项3");
            Choice choice4 = new Choice();
            choice4.setChoiceKey(4);
            choice4.setBlank(true);
            choice4.setHint("点击这里编辑单选题选项4");
            singleChoice.getChoices().add(choice1);
            singleChoice.getChoices().add(choice2);
            singleChoice.getChoices().add(choice3);
            singleChoice.getChoices().add(choice4);
            singleChoice = baseManager.saveQuestion(singleChoice);
            singleChoice.setIsBlank(true);
            singleChoice.setHint("点击这里编辑单选题题目内容");

            SortedQuestion multiChoice = new SortedQuestion();
            multiChoice.setQuestionType(2);
            Choice choice5 = new Choice();
            choice5.setChoiceKey(1);
            choice5.setBlank(true);
            choice5.setHint("点击这里编辑多选题选项1");
            Choice choice6 = new Choice();
            choice6.setChoiceKey(2);
            choice6.setBlank(true);
            choice6.setHint("点击这里编辑多选题选项2");
            Choice choice7 = new Choice();
            choice7.setChoiceKey(3);
            choice7.setBlank(true);
            choice7.setHint("点击这里编辑多选题选项3");
            Choice choice8 = new Choice();
            choice8.setChoiceKey(4);
            choice8.setBlank(true);
            choice8.setHint("点击这里编辑多选题选项4");
            multiChoice.getChoices().add(choice5);
            multiChoice.getChoices().add(choice6);
            multiChoice.getChoices().add(choice7);
            multiChoice.getChoices().add(choice8);
            multiChoice = baseManager.saveQuestion(multiChoice);
            multiChoice.setIsBlank(true);
            multiChoice.setHint("点击这里编辑多选题题目内容");

            SortedQuestion yesOrNo = new SortedQuestion();
            yesOrNo.setQuestionType(3);
            yesOrNo = baseManager.saveQuestion(yesOrNo);
            yesOrNo.setIsBlank(true);
            yesOrNo.setHint("点击这里编辑判断题题目内容");

            SortedQuestion fillText = new SortedQuestion();
            fillText.setQuestionType(4);
            fillText = baseManager.saveQuestion(fillText);
            fillText.setIsBlank(true);
            fillText.setHint("点击这里编辑填空题题目内容");

            SortedQuestion note = new SortedQuestion();
            note.setQuestionType(5);
            note = baseManager.saveQuestion(note);
            note.setHint("点击这里编辑试题备注");
            note.setIsBlank(true);

            exam.getQuestions().add(note);
            exam.getQuestions().add(singleChoice);
            exam.getQuestions().add(multiChoice);
            exam.getQuestions().add(yesOrNo);
            exam.getQuestions().add(fillText);
        }

        //更新操作，或者是添加造作
        if (exam != null) {
            return SUCCESS;
        } else {
            //既不是更新操作，也不是添加造作
            return "EXAM_LIST";
        }

    }

    public String add() throws Exception {
        ActionContext context = ActionContext.getContext();
        Map session = context.getSession();

        String jasonStr = "";

        exam.setCreatorId(((User)session.get("loggedUser")).getUserId());
        exam.setQuestions(new ArrayList<SortedQuestion>());

        try {
            baseManager.saveExam(exam);
            jasonStr = "{'status':0,'examId':" + exam.getExamId() + "}";
        } catch (ServiceException se) {
            addActionMessage(se.getMessage());
            jasonStr = "{'status':-1}";
        }

        super.renderJson(jasonStr);
        return null;
    }

    public String update() throws Exception {
        String name = exam.getName();
        String shortName = exam.getShortName();
        exam = baseManager.getSortedExamById(examId);
        exam.setName(name);
        exam.setShortName(shortName);
        baseManager.saveExam(exam);
        return null;
    }

    public String delete() throws Exception {
        exam = baseManager.getSortedExamById(examId);
        baseManager.deleteExam(exam);
        return null;
    }

    public String updateProperty() throws Exception {
        String jasonStr = "";

        if (examId == null) {
            exam = new SortedExamDetail();

            ActionContext context = ActionContext.getContext();
            Map session = context.getSession();
            exam.setCreatorId(((User)session.get("loggedUser")).getUserId());
            setPropertyValue(exam, propertyName, propertyValue);

            exam = baseManager.saveExam(exam);
            jasonStr = "{'status':1,'examId':" + exam.getExamId() + "}";
        } else {
            exam = baseManager.getSortedExamById(examId);
            setPropertyValue(exam, propertyName, propertyValue);
            baseManager.saveExam(exam);
            jasonStr = "{'status':0}";
        }

        super.renderJson(jasonStr);
        return null;
    }


    public SortedExamDetail getExam() {
        return exam;
    }

    public void setExam(SortedExamDetail exam) {
        this.exam = exam;
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


}

