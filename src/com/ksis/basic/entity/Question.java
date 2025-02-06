package com.ksis.basic.entity;

import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;

@Entity
@Table(name = "QUESTION")
public class Question {

    private Integer questionId;
    private String content;
    private String correctAnswer;
    private Integer questionType;
    private Integer orderIndex;
    private Set<Choice> choices = new LinkedHashSet<Choice>();
    private SortedExamDetail exam;
    private String correctAnswerTitle;

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
    public Set<Choice> getChoices() {
        return choices;
    }

    public void setChoices(Set<Choice> choices) {
        this.choices = choices;
    }

    @Transient
    public String getCorrectAnswerTitle() {
        return correctAnswerTitle;
    }

    public void setCorrectAnswerTitle(String correctAnswerTitle) {
        this.correctAnswerTitle = correctAnswerTitle;
    }

    public void setOrderIndex(Integer orderIndex) {
        this.orderIndex = orderIndex;
    }

    @Column(name = "ORDERINDEX")
    public Integer getOrderIndex() {
        return orderIndex;
    }
}
