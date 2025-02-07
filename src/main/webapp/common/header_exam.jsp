<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>

      <div class="headermo">
        <div class="header">
          <div style="POSITION: relative" class="logo fl">
            <a href="http://www.kaoshi100.com" target="_blank">
              <img  src="../images/logo.png"></img></a>
          </div>
          <div class="searchbar fr">
            <div class="divkey">
              <form id="frm_searchpaper" method="post" action="vip2013/search" target="_blank"></form>
              <input onblur="if(this.value=='')this.value='输入关键字在当前试题搜索题目'"
                     class="inp" id='fancy-input'
                     onclick="if(this.value=='输入关键字在当前试题搜索题目')this.value='';"
                     value="输入关键字在当前试题搜索题目"
                     type="text"
                     name="keyword"></input>
                           </div>
          </div>
        </div>
       
        <div class="logged_infobar"  id="loggedInfo">
        	
                 下午好，<label id="loggedUser"><s:property value='#session.loggedUser.userName'/></label> &nbsp;&nbsp;
           | &nbsp;&nbsp;
          <a href="${ctx}/exam/login!logoff.action">退出</a>
        </div>  
      </div>