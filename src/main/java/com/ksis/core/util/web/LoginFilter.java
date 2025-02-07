package com.ksis.core.util.web;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ksis.basic.entity.User;

import com.opensymphony.xwork2.ActionContext;

public class LoginFilter extends HttpServlet implements Filter {

    private static final long serialVersionUID = 1L;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException,
                                                                                                     ServletException {

        HttpServletRequest req = (HttpServletRequest)request;
        HttpServletResponse res = (HttpServletResponse)response;
        String path = req.getContextPath();
        String basePath = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + path + "/";

        if (req.getRequestURI().indexOf("index") != -1 || req.getRequestURI().indexOf("login") != -1 ||
            req.getRequestURI().indexOf("register") != -1 ||
            (!req.getRequestURI().endsWith(".jsp") && !req.getRequestURI().endsWith(".action"))) {
            //do nothing
        } else {
            //check if logged in
            if (req.getSession().getAttribute("loggedUser") == null) {
                req.getSession().setAttribute("showLogin", "true");
                req.getSession().setAttribute("RequestedURL", req.getRequestURI());
                res.sendRedirect(basePath + "exam/index.action");
                return;
            }
        }

        chain.doFilter(request, response);

    }

    @Override
    public void init(FilterConfig arg0) throws ServletException {
        // TODO Auto-generated method stub

    }

}
