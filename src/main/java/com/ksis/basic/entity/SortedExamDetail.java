package com.ksis.basic.entity;


import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;

@Entity
@Table(name = "EXAM")
public class SortedExamDetail {

    private List<SortedQuestion> questions = new ArrayList<SortedQuestion>();
    private Integer examId;
    private String shortName;
    private String name;
    private Integer creatorId;
    private Timestamp createTime;
    private Timestamp lastUpdateTime;

    @Id
    @Column(name = "EXAMID")
    @GeneratedValue(strategy = GenerationType.AUTO)
    public Integer getExamId() {
        return examId;
    }

    public void setExamId(Integer examId) {
        this.examId = examId;
    }

    @Column(name = "SHORTNAME", length = 40)
    public String getShortName() {
        return shortName;
    }

    public void setShortName(String shortName) {
        this.shortName = shortName;
    }

    @Column(name = "NAME", length = 2000)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Column(name = "CREATORID")
    public Integer getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(Integer creatorId) {
        this.creatorId = creatorId;
    }

    @Column(name = "CREATEDTIME")
    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    @Column(name = "LASTUPDATEDTIME")
    public Timestamp getLastUpdateTime() {
        return lastUpdateTime;
    }

    public void setLastUpdateTime(Timestamp lastUpdateTime) {
        this.lastUpdateTime = lastUpdateTime;
    }

    @OneToMany(cascade = { CascadeType.ALL }, fetch = FetchType.EAGER, mappedBy = "exam")
    @JoinColumn(name = "QUESTION_CATEGORY_ID")
    @OrderBy(value = "orderIndex asc")
    public List<SortedQuestion> getQuestions() {
        return questions;
    }

    public void setQuestions(List<SortedQuestion> questions) {
        this.questions = questions;
    }


}
