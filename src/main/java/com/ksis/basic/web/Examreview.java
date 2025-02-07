package com.ksis.basic.web;

import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

import com.ksis.core.util.web.struts2.AjaxActionSupport;

@Namespace("/exam")
@Results( { @Result(name = AjaxActionSupport.RELOAD, location = "examreview.action", type = "redirect") })
public class Examreview extends AjaxActionSupport {

    private static final long serialVersionUID = 1L;

}
