<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>

	<!-- 登陆 成功跳转-->
	<div id="login_info"
		style="position: absolute; z-index: 9998; left: 563.5px; top: 258px;display:none">
            <table cellspacing="0" cellpadding="0"
                    style="empty-cells: show; border-collapse: collapse;" canmove="true"
                    class="fwin">
                <tbody>
                    <tr>
                        <td canmove="true" style="cursor: move" class="t_l"></td>
                        <td>
                                <div canmove="true" class="t_c" style="cursor: move"></div>
                        </td>
                        <td canmove="true" style="cursor: move" class="t_r"></td>
                    </tr>
                    <tr>
                        <td canmove="true" class="m_l" style="cursor: move">&nbsp;&nbsp;</td>
                        <td fwin="login" style="background: #fff" class="m_c"
                                id="fwin_content_login"><div fwin="login"
                                        id="main_messaqge_LLapc">
                                        <div fwin="login" id="layer_lostpw_LLapc">
                                                <h3 class="flb">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                        <label id="logAlertInfo">登录成功, 正在跳转...</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                </h3></td>
                        <td class="m_r" canmove="true" style="cursor: move"></td>
                    </tr>
                    <tr>
                        <td canmove="true" style="cursor: move" class="b_l"></td>
                        <td class="b_c" canmove="true" style="cursor: move"></td>
                        <td canmove="true" style="cursor: move" class="b_r"></td>
                    </tr>
                </tbody>
            </table>
	</div>

    <!-- 登陆 -->
	<%
		if(session.getAttribute("showLogin")!=null && "true".equalsIgnoreCase(session.getAttribute("showLogin").toString())){
	%>
		<div id="append_parent" style="position: absolute; z-index: 9999; left: 563.5px; top: 258px; ">
	<%
		}else{
	%>
		<div id="append_parent" style="position: absolute; z-index: 9999; left: 563.5px; top: 258px; display:none">
	<%
		}
	%>	
		<table cellspacing="0" cellpadding="0"
			style="empty-cells: show; border-collapse: collapse;" canmove="true"
			class="fwin">
			<tbody>
				<tr>
					<td canmove="true" style="cursor: move" class="t_l"></td>
					<td><div canmove="true" class="t_c" style="cursor: move"></div></td>
					<td canmove="true" style="cursor: move" class="t_r"></td>
				</tr>
				<tr>
					<td canmove="true" class="m_l" style="cursor: move">&nbsp;&nbsp;</td>
					<td fwin="login" style="background: #fff" class="m_c"
						id="fwin_content_login"><div fwin="login"
							id="main_messaqge_LLapc">
							<div fwin="login" id="layer_lostpw_LLapc">
								<h3 class="flb">
									<em fwin="login" id="returnmessage3_LLapc">会员登录</em><span><a
										id="btn_cloase_div" class="flbc"
										href="#" onclick="document.getElementById('append_parent').style.display='none';"
										title="关闭">关闭</a></span><span class="reglink"> &nbsp;&nbsp;
										还没有账号? &nbsp; <a 
										href="#" onclick="document.getElementById('append_parent').style.display='none';document.getElementById('append_parent_reg').style.display='block';">立即注册</a>
									</span>
								</h3>								

								<div id="showdialog_maindiv" style="height:160px; width:440px; overflow:hidden" class="c cl">
									<iframe width="440" scrolling="no" height="160" frameborder="0" src="${ctx}/exam/login.action" id="showdialogframe"></iframe>
								</div>

							</div>
						</div></td>
					<td class="m_r" canmove="true" style="cursor: move"></td>
				</tr>
				<tr>
					<td canmove="true" style="cursor: move" class="b_l"></td>
					<td class="b_c" canmove="true" style="cursor: move"></td>
					<td canmove="true" style="cursor: move" class="b_r"></td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<!-- 注册 -->
	<div id="append_parent_reg" style="position: absolute; z-index: 9999; left: 563.5px; top: 180px; display:none">
			<table cellspacing="0" cellpadding="0"
			style="empty-cells: show; border-collapse: collapse;" canmove="true"
			class="fwin">
			<tbody>
				<tr>
					<td canmove="true" style="cursor: move" class="t_l"></td>
					<td><div canmove="true" class="t_c" style="cursor: move"></div></td>
					<td canmove="true" style="cursor: move" class="t_r"></td>
				</tr>
				<tr>
					<td canmove="true" class="m_l" style="cursor: move">&nbsp;&nbsp;</td>
					<td fwin="login" style="background: #fff" class="m_c"
						id="fwin_content_login"><div fwin="login"
							id="main_messaqge_LLapc">
							<div fwin="login" id="layer_lostpw_LLapc">
								<h3 class="flb">
									<em fwin="login" id="returnmessage3_LLapc">会员注册</em><span><a
										id="btn_cloase_div" class="flbc"
										href="#" onclick="document.getElementById('append_parent_reg').style.display='none';"
										title="关闭">关闭</a></span>
									</span>
								</h3>								

								<div id="showdialog_maindiv" style="height:300px; width:440px; overflow:hidden" class="c cl">
									<iframe width="440" scrolling="no" height="300" frameborder="0" src="${ctx}/exam/register.action" id="showdialogframe"></iframe>
								</div>

							</div>
						</div></td>
					<td class="m_r" canmove="true" style="cursor: move"></td>
				</tr>
				<tr>
					<td canmove="true" style="cursor: move" class="b_l"></td>
					<td class="b_c" canmove="true" style="cursor: move"></td>
					<td canmove="true" style="cursor: move" class="b_r"></td>
				</tr>
			</tbody>
		</table>
	</div>
  
      <div class="headermo">
        <div class="header">
          <div style="POSITION: relative" class="logo fl">
            <a href="http://www.kaoshi100.com" target="_blank">
              <img  src="../images/logo.png"></img></a>
          </div>
          <div class="searchbar fr">
            <div class="divkey">
              <form id="frm_searchpaper" method="post" action="vip2013/search" target="_blank"></form>
              <input onblur="if(this.value=='')this.value='输入关键字搜索试题'"
                     class="inp"
                     onclick="if(this.value=='输入题号或题目搜索试题')this.value='';"
                     value="输入关键字搜索试题"
                     type="text"
                     name="keyword"></input>
               
              <a class="searchbtn mypngbg" href="javascript:submitsearch()"></a>
            </div>
          </div>
        </div>
        <% 
        	if(session.getAttribute("loggedUser")==null){
        %>
        
        <div class="infobar" id="unloggedInfo">
          <a href="http://user.jxedt.com/">游客 您好, 欢迎进入考试100!</a>
           &nbsp;&nbsp; 
          <a href="#" onclick="document.getElementById('append_parent').style.display='';">[请登录]</a>
           &nbsp;&nbsp; 
          <a href="#" onclick="document.getElementById('append_parent_reg').style.display='';">[快速注册]</a>
        </div>
        <div class="logged_infobar" style="display:none" id="loggedInfo">        	
                 欢迎您回来，<label id="loggedUser"></label> &nbsp;&nbsp;
           | &nbsp;&nbsp;
          <a href="/ksis/exam/list.action">用户中心</a>&nbsp;&nbsp;
           | &nbsp;&nbsp;
          <a href="${ctx}/exam/login!logoff.action">退出</a>
        </div>          
        <%
        	}else{ 
        %>
        <div class="infobar" id="unloggedInfo" style="display:none">
          <a href="http://user.jxedt.com/">游客 您好, 欢迎进入考试100!</a>
           &nbsp;&nbsp; 
          <a href="#" onclick="document.getElementById('append_parent').style.display='';">[请登录]</a>
           &nbsp;&nbsp; 
          <a href="http://user.jxedt.com/loginout?returnurl=http://vip.jxedt.com">[快速注册]</a>
        </div>        
        <div class="logged_infobar"  id="loggedInfo">
        	
                 下午好，<label id="loggedUser"><s:property value='#session.loggedUser.userName'/></label> &nbsp;&nbsp;
           | &nbsp;&nbsp;
          <a href="/ksis/exam/list.action">用户中心</a>&nbsp;&nbsp;
           | &nbsp;&nbsp;
          <a href="${ctx}/exam/login!logoff.action">退出</a>
        </div>  
        <%	
        	}
        %>      
      </div>