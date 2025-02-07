package com.ksis.basic.entity;

import javax.persistence.*;

@Entity
@Table(name = "FAVORITE")
public class Favorite {

    private Integer id;
    private User user;
    private ExamSummary exam;

    @Id
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @ManyToOne
    @JoinColumn(name = "USERID")
    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "EXAMID")
    public ExamSummary getExam() {
        return exam;
    }

    public void setExam(ExamSummary exam) {
        this.exam = exam;
    }
}
