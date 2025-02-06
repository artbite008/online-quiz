package com.ksis.core.util.web.struts2;

import java.io.PrintWriter;

import java.lang.reflect.InvocationTargetException;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.PropertyUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ksis.basic.entity.SortedExamDetail;

import com.opensymphony.xwork2.ActionSupport;

/**
 * Struts2中典型CRUD Action的抽象基类.
 *
 *
 * @param <T> - CRUDAction所管理的对象类型.
 *
 * @author Kanine
 */
public abstract class AjaxActionSupport extends ActionSupport {

    private static final long serialVersionUID = -1653204626115064950L;

    /** 进行增删改操作后,以redirect方式重新打开action默认页的result名.*/
    public static final String RELOAD = "reload";

    protected Logger logger = LoggerFactory.getLogger(getClass());

    public void renderJson(String jasonStr) {
        HttpServletResponse response = Struts2Utils.getResponse();
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain");

        try {
            PrintWriter out = response.getWriter();
            out.println(jasonStr);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public void setPropertyValue(Object bean, String name, String value) {
        try {
            PropertyUtils.setProperty(bean, name, value);
        } catch (IllegalAccessException e) {
            logger.error(e.toString());
        } catch (InvocationTargetException e) {
            logger.error(e.toString());
        } catch (NoSuchMethodException e) {
            logger.error(e.toString());
        }
    }
    
    public void setPropertyValue(Object bean, String name, Integer value) {
        try {
            PropertyUtils.setProperty(bean, name, value);
        } catch (IllegalAccessException e) {
            logger.error(e.toString());
        } catch (InvocationTargetException e) {
            logger.error(e.toString());
        } catch (NoSuchMethodException e) {
            logger.error(e.toString());
        }
    }    

}

