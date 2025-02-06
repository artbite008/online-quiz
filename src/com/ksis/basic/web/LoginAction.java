package com.ksis.basic.web;

import java.io.PrintWriter;

import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

import org.springframework.beans.factory.annotation.Autowired;

import com.ksis.basic.entity.ExamSummary;
import com.ksis.basic.entity.User;
import com.ksis.basic.service.KsisBaseManager;
import com.ksis.core.util.web.struts2.AjaxActionSupport;
import com.ksis.core.util.web.struts2.Struts2Utils;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

@Namespace("/exam")
@Results( { @Result(name = "home", location = "index.action", type = "redirect") })
public class LoginAction extends AjaxActionSupport {

    private String userName = "";
    private String password = "";

    @Autowired
    private KsisBaseManager baseManager;

    public String logoff() throws Exception {
        ActionContext context = ActionContext.getContext();
        Map session = context.getSession();
        session.clear();
        return "home";
    }

    public String clearRequestedURL() throws Exception {
        ActionContext context = ActionContext.getContext();
        Map session = context.getSession();
        session.remove("RequestedURL");

        return null;
    }

    public String submit() throws Exception {

        String jasonStr = "";

        if (userName != null && userName.trim().length() > 0) {
            User user = baseManager.getUserByName(userName.trim());
            if (user == null) {
                jasonStr = "{'status':-1}";
            } else if (!user.getPassword().trim().equals(password)) {
                jasonStr = "{'status':0}";
            } else {
                //登录成功
                Map session = Struts2Utils.getSession();

                jasonStr = "{'status':1, 'userName':'" + user.getUserName() + "'";
                if (session.get("RequestedURL") != null) {
                    jasonStr = jasonStr + ", 'requestedURL':'" + session.get("RequestedURL") + "'}";
                } else {
                    jasonStr = jasonStr + "}";
                }

                session.clear();
                session.put("loggedUser", user);
            }
        }

        super.renderJson(jasonStr);

        return null;

    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }


}
