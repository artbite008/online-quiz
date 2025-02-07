package com.ksis.basic.web;

import java.util.List;
import java.util.Map;

import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

import org.springframework.beans.factory.annotation.Autowired;

import com.ksis.basic.entity.ExamSummary;
import com.ksis.basic.entity.Favorite;
import com.ksis.basic.entity.User;
import com.ksis.basic.service.KsisBaseManager;
import com.ksis.core.util.web.struts2.AjaxActionSupport;

import com.opensymphony.xwork2.ActionContext;

@Namespace("/exam")
@Results( { @Result(name = AjaxActionSupport.RELOAD, location = "list.action", type = "redirect") })
public class ListAction extends AjaxActionSupport {

    @Autowired
    private KsisBaseManager baseManager;

    private Integer userId;
    private List<ExamSummary> examList;
    private List<Favorite> favoriteList;

    @Override
    public String execute() throws Exception {
        ActionContext context = ActionContext.getContext();
        Map session = context.getSession();
        if (session.get("loggedUser") != null) {
            userId = ((User)session.get("loggedUser")).getUserId();
        }

        if (userId != null) {
            examList = baseManager.getCreatedExamList(userId);
            favoriteList = baseManager.getFavoriteListByUserId(userId);
        }

        return SUCCESS;
    }

    @Override
    public String input() throws Exception {
        // TODO Auto-generated method stub
        return null;
    }


    public List<ExamSummary> getExamList() {
        return examList;
    }

    public void setExamList(List<ExamSummary> examList) {
        this.examList = examList;
    }

    public List<Favorite> getFavoriteList() {
        return favoriteList;
    }

    public void setFavoriteList(List<Favorite> favoriteList) {
        this.favoriteList = favoriteList;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

}
