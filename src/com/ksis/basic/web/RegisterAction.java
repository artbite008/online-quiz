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
public class RegisterAction extends AjaxActionSupport {

    private String userName = "";
    private String email = "";
    private String password = "";
    private String passwordConfirm = "";
    private String role = "";

    @Autowired
    private KsisBaseManager baseManager;

    public String submit() throws Exception {
        boolean validatedFlag = true;
        String jasonStr = "";

        if (userName != null && userName.trim().length() > 0) {
            User user = baseManager.getUserByName(userName.trim());
            if (user != null) {
                jasonStr = "{'status':-1}";
                validatedFlag = false;
            }
        }
        if (email != null && email.trim().length() > 0) {
            User user = baseManager.getUserByEmail(email.trim());
            if (user != null) {
                jasonStr = "{'status':-2}";
                validatedFlag = false;
            }
        }

        if (validatedFlag) {
            User user = new User();
            user.setUserName(userName);
            user.setEmail(email);
            user.setPassword(password);
            user.setUserType(role);

            baseManager.saveUser(user);

            jasonStr = "{'status':1, 'userName':'" + user.getUserName() + "'}";

            //自动为新注册用户登录
            Map session = Struts2Utils.getSession();
            session.clear();
            session.put("loggedUser", user);
        }

        if (jasonStr.length() > 0) {
            super.renderJson(jasonStr);
        } else {
            super.renderJson("{'status':0}"); //位置错误
        }


        return null;
    }

    public String clearRequestedURL() throws Exception {
        ActionContext context = ActionContext.getContext();
        Map session = context.getSession();
        session.remove("RequestedURL");

        return null;
    }

    public String submitmy() throws Exception {

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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordConfirm() {
        return passwordConfirm;
    }

    public void setPasswordConfirm(String passwordConfirm) {
        this.passwordConfirm = passwordConfirm;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

}
