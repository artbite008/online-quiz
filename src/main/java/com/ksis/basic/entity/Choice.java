package com.ksis.basic.entity;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

@Entity
@Table(name = "QUESTION_CHOICE")
public class Choice {
    private Integer choiceId;
    private String choiceContent;
    private Integer choiceKey;
    private SortedQuestion question;
    private String choiceTitle;
    private boolean isCorrect = false;
    private boolean isBlank = false;
    private String hint;

    public Choice(String content) {
        this.choiceContent = content;
    }

    public Choice() {
    }

    @Id
    @Column(name = "CHOICE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO)
    public Integer getChoiceId() {
        return choiceId;
    }

    public void setChoiceId(Integer choiceId) {
        this.choiceId = choiceId;
    }

    @Column(name = "CHOICE_CONTENT", length = 4000)
    public String getChoiceContent() {
        return choiceContent;
    }

    public void setChoiceContent(String choiceContent) {
        this.choiceContent = choiceContent;
    }

    @Column(name = "CHOICE_KEY")
    public Integer getChoiceKey() {
        return choiceKey;
    }

    public void setChoiceKey(Integer choiceKey) {
        this.choiceKey = choiceKey;
    }

    @ManyToOne(cascade = { CascadeType.PERSIST, CascadeType.MERGE })
    @JoinColumn(name = "QUESTION_ID")
    public SortedQuestion getQuestion() {
        return question;
    }

    public void setQuestion(SortedQuestion question) {
        this.question = question;
    }

    @Transient
    public String getChoiceTitle() {
        return choiceTitle;
    }

    public void setChoiceTitle(String choiceTitle) {
        this.choiceTitle = choiceTitle;
    }

    @Transient
    public boolean getIsCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean isCorrect) {
        this.isCorrect = isCorrect;
    }

    public void setBlank(boolean isBlank) {
        this.isBlank = isBlank;
    }

    @Transient
    public boolean getIsBlank() {
        return isBlank;
    }

    public void setHint(String hint) {
        this.hint = hint;
    }

    @Transient
    public String getHint() {
        return hint;
    }
}
