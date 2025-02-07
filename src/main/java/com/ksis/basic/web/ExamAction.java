package com.ksis.basic.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

import org.springframework.beans.factory.annotation.Autowired;

import com.ksis.basic.entity.Choice;
import com.ksis.basic.entity.ExamDetail;
import com.ksis.basic.entity.ExamSummary;
import com.ksis.basic.entity.Question;
import com.ksis.basic.entity.SortedQuestion;
import com.ksis.basic.entity.User;
import com.ksis.basic.service.KsisBaseManager;
import com.ksis.core.util.Constants;
import com.ksis.core.util.web.struts2.AjaxActionSupport;

@Namespace("/exam")
@Results( { @Result(name = AjaxActionSupport.RELOAD, location = "exam.action", type = "redirect") })
public class ExamAction extends AjaxActionSupport {

    private Integer examId;
    private ExamDetail exam;
    private List<Integer> indexs;

    @Autowired
    private KsisBaseManager baseManager;


    @Override
    public String execute() throws Exception {
        if (examId != null) {
            exam = baseManager.getExamById(examId);
        } else {
            exam = new ExamDetail();
        }

        //设置indexs
        int totalCount = exam.getQuestions().size();
        indexs = new ArrayList<Integer>();
        for (int index = 1; index <= totalCount; index++) {
            indexs.add(index);
        }
        int gapCount = 10 - totalCount % 10;
        if (totalCount == 0)
            gapCount = 0;
        while (gapCount > 0) {
            indexs.add(0);
            gapCount--;
        }

        Iterator<Question> questionIterator = exam.getQuestions().iterator();
        while (questionIterator.hasNext()) {
            Question ques = questionIterator.next();

            Set<Integer> correctAnswerSet = new HashSet<Integer>();
            List<String> correctAnswerTitleList = new ArrayList<String>();
            String[] correctAnswers = null;
            if (1 == ques.getQuestionType() || 2 == ques.getQuestionType()) {
                correctAnswers = ques.getCorrectAnswer().split(",");
                for (String s : correctAnswers) {
                    correctAnswerSet.add(Integer.parseInt(s));
                }
            }

            Iterator<Choice> choicesIterator = ques.getChoices().iterator();
            int j = 0;
            while (choicesIterator.hasNext()) {
                Choice choice = choicesIterator.next();
                choice.setChoiceTitle(Constants.choiceTitleArray[j]);
                if (correctAnswerSet.contains(choice.getChoiceKey())) {
                    correctAnswerTitleList.add(Constants.choiceTitleArray[j]);
                }
                j++;
            }
            //			for(int j=0; j<ques.getChoices().size(); j++){
            //				Choice choice = ques.getChoices().get(j);
            //				choice.setChoiceTitle(Constants.choiceTitleArray[j]);
            //				if(correctAnswerSet.contains(choice.getChoiceKey())){
            //					correctAnswerTitleList.add(Constants.choiceTitleArray[j]);
            //				}
            //			}

            Collections.sort(correctAnswerTitleList);
            String correctAnswerTitle = "";
            for (String s : correctAnswerTitleList) {
                correctAnswerTitle = correctAnswerTitle + s + ",";
            }
            if (correctAnswerTitle.endsWith(",")) {
                correctAnswerTitle = correctAnswerTitle.substring(0, correctAnswerTitle.length() - 1);
            }
            ques.setCorrectAnswerTitle(correctAnswerTitle);
        }

        return SUCCESS;
    }

    public Integer getExamId() {
        return examId;
    }

    public void setExamId(Integer examId) {
        this.examId = examId;
    }

    public ExamDetail getExam() {
        return exam;
    }

    public void setExam(ExamDetail exam) {
        this.exam = exam;
    }

    public List<Integer> getIndexs() {
        return indexs;
    }

    public void setIndexs(List<Integer> indexs) {
        this.indexs = indexs;
    }

}
