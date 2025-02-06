package com.ksis.basic.entity;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.Transient;

@Entity
@Table(name = "QUESTION")
public class SortedQuestion {

    private Integer questionId;
    private String content;
    private String correctAnswer;
    private Integer questionType;
    private Integer orderIndex;
    private List<Choice> choices = new ArrayList<Choice>();
    private SortedExamDetail exam;
    private String correctAnswerTitle;
    private String answerLength;
    private boolean isBlank = false;
    private String hint;


    @Transient
    public String getHint() {
        return hint;
    }

    public void setHint(String hint) {
        this.hint = hint;
    }

    @Transient
    public boolean getIsBlank() {
        return isBlank;
    }

    public void setIsBlank(boolean isBlank) {
        this.isBlank = isBlank;
    }

    @Id
    @Column(name = "QUESTION_ID")
    @GeneratedValue(strategy = GenerationType.AUTO)
    public Integer getQuestionId() {
        return questionId;
    }

    public void setQuestionId(Integer questionId) {
        this.questionId = questionId;
    }

    @Column(name = "CONTENT", length = 4000)
    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    @Column(name = "CORRECT_ANSWER", length = 40)
    public String getCorrectAnswer() {
        return correctAnswer;
    }

    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }

    @Column(name = "QUESTION_TYPE_ID")
    public Integer getQuestionType() {
        return questionType;
    }

    public void setQuestionType(Integer questionType) {
        this.questionType = questionType;
    }

    @ManyToOne(cascade = { CascadeType.PERSIST, CascadeType.MERGE })
    @JoinColumn(name = "QUESTION_CATEGORY_ID")
    public SortedExamDetail getExam() {
        return exam;
    }

    public void setExam(SortedExamDetail exam) {
        this.exam = exam;
    }

    @OneToMany(cascade = { CascadeType.ALL })
    @JoinColumn(name = "QUESTION_ID")
    @OrderBy(value = "choiceKey asc")
    public List<Choice> getChoices() {
        return choices;
    }

    public void setChoices(List<Choice> choices) {
        this.choices = choices;
    }

    @Transient
    public String getCorrectAnswerTitle() {
        return correctAnswerTitle;
    }

    public void setCorrectAnswerTitle(String correctAnswerTitle) {
        this.correctAnswerTitle = correctAnswerTitle;
    }

    @Column(name = "ANSWER_LENGTH")
    public String getAnswerLength() {
        return answerLength;
    }

    public void setAnswerLength(String answerLength) {
        this.answerLength = answerLength;
    }

    public void setOrderIndex(Integer orderIndex) {
        this.orderIndex = orderIndex;
    }

    @Column(name = "ORDERINDEX")
    public Integer getOrderIndex() {
        return orderIndex;
    }
}
