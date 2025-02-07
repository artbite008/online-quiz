<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<link href="../css/popup.css" type="text/css" rel="Stylesheet" />
	<script src="../js/jquery-1.9.1.js"></script>
	<script type="text/javascript">
	
	    // 以登录框登录
	    function doSubmit(){
		    var userName = $("#userName");
		    var password = $("#password");
		    var passwordConfirm = $("#passwordConfirm");
		    var email = $("#email");
		    var role  = $("#role");
		    
		    var nameerror = $("#nameerror");
		    var emailerror = $("#emailerror");
		    var passwordError = $("#passwordError");
		    var confirmPasswordError = $("#confirmPasswordError");
		    var roleError = $("#roleError");
				
	        if (userName.val() == "") {
	            nameerror.html("请输入用户名");
	            userName.focus();
	            return;
	        } else {
	            nameerror.html("");
	        }
	        
	        var mailPatten = new RegExp(/^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]+$/);   
	        if (email.val() == "") {
	        	emailerror.html("请输入邮箱地址"); 
	        	email.focus();
	            return;
	        } else if(!mailPatten.test(email.val())){	        	 
        		emailerror.html("邮箱地址格式不正确");
        		email.focus();
        		return;
	        }else{	        	
	        	emailerror.html("");
	        }
        
	        if (password.val() == "") {
	        	passwordError.html("请输入密码"); 
	            password.focus();
	            return;
	        } else {
	        	passwordError.html("");
	        }

	        if (passwordConfirm.val() == "") {
	        	confirmPasswordError.html("请再输一次密码");
	        	passwordConfirm.focus();
	            return;
	        } else if( password.val() != passwordConfirm.val() ){
	        	confirmPasswordError.html("两次输入的密码不一致");
	        	passwordConfirm.focus();
	            return;
	        }else{
	        	confirmPasswordError.html("");
	        }
	        
	        if (role.val() == "") {
	        	roleError.html("请选择您的角色"); 
	        	role.focus();
	            return;
	        } else {
	        	roleError.html("");
	        }
	
	        $.ajax({
	        	    type: 'POST',
	        		url: "${ctx}/exam/register!submit.action", 
	        		data: {userName: userName.val(), email:email.val(), password: password.val(), role:role.val() },
	        		success: callbackFun
	        });
	

	    }
	    
	    function callbackFun(data){	    
		    var userName = $("#userName");
		    var email = $("#email");
		    
		    var nameerror = $("#nameerror");
		    var emailerror = $("#emailerror");
		    
	    	var json = eval("(" + data + ")");
	        if (json.status == -1) {
	        	nameerror.html("用户名已经存在");
	        	userName.val("");
	        	userName.focus();
            }else if (json.status == -2) {
            	emailerror.html("邮箱地址已经存在");
            	email.val("");
            	email.focus();
            }else{
            	window.parent.document.getElementById('append_parent_reg').style.display='none';
            	window.parent.document.getElementById('login_info').style.display='';
            	window.parent.document.getElementById('logAlertInfo').innerHTML="注册成功！正在为您自动登陆，请稍候...";
            	
            	setTimeout("setLoggedUser('"+json.userName+"')", 2000);
            }
	    }
	    
	    function setLoggedUser(userName){
	    	window.parent.document.getElementById('login_info').style.display='none';
        	window.parent.document.getElementById('unloggedInfo').style.display='none';
        	window.parent.document.getElementById('loggedInfo').style.display='';
	    	window.parent.document.getElementById('loggedUser').innerHTML = userName;
	    }
	    
    </script>
</head>
<body style="margin: 0px; padding: 0px;">
	<div
		style="margin: 0px; padding: 0px; width: 500px; height: 500px; overflow: hidden"
		id="append_parent">
		<div id="div_login" class="m_c">
				<div style="height: 248px; overflow: hidden" class="c cl">
					<div style="height: 50px; overflow: hidden" class="trfm bw0" >
						<table>
							<tbody>
								<tr>
									<th><label for="userName"> 用户名:</label></th>
									<td><input type="text" onclick="javascript:this.focus()"
										maxlength="50" name="userName" id="userName" size="25"
										value="" tabindex="1" class="txt"
										onmousemove="document.onmousemove = null"></td>
								</tr>
								<tr>
									<td class="std"></td>
									<td class="std"><label id="nameerror" class="lblerror">
									</label></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div style="height: 50px; overflow: hidden" class="trfm bw0" >
						<table>
							<tbody>
								<tr>
									<th><label for="email"> 邮箱地址:</label></th>
									<td><input type="text" onclick="javascript:this.focus()"
										maxlength="50" name="email" id="email" size="25"
										value="" tabindex="1" class="txt"
										onmousemove="document.onmousemove = null"></td>
								</tr>
								<tr>
									<td class="std"></td>
									<td class="std"><label id="emailerror" class="lblerror">
									</label></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div style="height: 50px; overflow: hidden" class="trfm bw0" >
						<table>
							<tbody>
								<tr>
									<th><label for="password"> 密码:</label></th>
									<td><input type="password" onclick="javascript:this.focus()"
										maxlength="50" name="password" id="password" size="25"
										value="" tabindex="1" class="txt"
										onmousemove="document.onmousemove = null"></td>
								</tr>
								<tr>
									<td class="std"></td>
									<td class="std"><label id="passwordError" class="lblerror">
									</label></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div style="height: 50px; overflow: hidden" class="trfm bw0" >
						<table>
							<tbody>
								<tr>
									<th><label for="passwordConfirm"> 确认密码:</label></th>
									<td><input type="password" onclick="javascript:this.focus()"
										maxlength="50" name="passwordConfirm" id="passwordConfirm" size="25"
										value="" tabindex="1" class="txt"
										onmousemove="document.onmousemove = null"></td>
								</tr>
								<tr>
									<td class="std"></td>
									<td class="std"><label id="confirmPasswordError" class="lblerror">
									</label></td>
								</tr>
							</tbody>
						</table>
					</div>															
					<div style="height: 50px; overflow: hidden" class="trfm  bw0">
						<table>
							<tbody>
								<tr>
									<th><label for="role"> 您的角色:</label></th>
									<td><select name="role" id="role" >
											<option value=""></option>
											<option value="S">学生</option>
											<option value="T">教师</option>
										</select>
									</td>
								</tr>
								<tr>
									<td class="std"></td>
									<td class="std"><label id="roleError" class="lblerror"></label>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<p class="fsb">
					<span style="padding-left: 10em">
						<input type="button" id="btn_loginbtn" class="pn pnc" onclick="doSubmit();" 
							name="lostpwsubmit" value="注册并立即登陆"
							style="padding: 0px 5px" tabindex="100"/>&nbsp;&nbsp;&nbsp;
					</span>
				</p>
		</div>

	</div>


</body>
</html>