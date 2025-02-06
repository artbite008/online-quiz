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
		    var nameerror = $("#nameerror");
		    var pwderror = $("#pwderror");
				
	        if (userName[0].value == "") {
	            nameerror[0].innerHTML = "请输入用户名";
	            userName[0].focus();
	            return;
	        } else {
	            nameerror[0].innerHTML = "";
	        }
	        if (password[0].value == "") {
	            pwderror[0].innerHTML = "请输入密码"; 
	            password[0].focus();
	            return;
	        } else {
	            pwderror[0].innerHTML = "";
	        }
	
	        $.ajax({
	        	    type: 'POST',
	        		url: "${ctx}/exam/login!submit.action", 
	        		data: {userName: userName[0].value, password: password[0].value },
	        		success: callbackFun
	        });
	

	    }
	    
	    function callbackFun(data){	    
		    var userName = $("#userName");
		    var password = $("#password");
		    var nameerror = $("#nameerror");
		    var pwderror = $("#pwderror");
		    
	    	var json = eval("(" + data + ")");
	        if (json.status == 0) {
                nameerror.innerHTML = "";
                pwderror[0].innerHTML = "密码不正确";
                password[0].value = "";
                password[0].focus();
            }else if (json.status == -1) {
            	nameerror[0].innerHTML = "用户名不存在";
            	userName[0].value = "";
                password[0].value = "";
                userName[0].focus();
            }else{
            	window.parent.document.getElementById('append_parent').style.display='none';
            	window.parent.document.getElementById('login_info').style.display='';
            	if(json.requestedURL){
            		setTimeout("gotoRequestedPage('"+json.requestedURL+"')", 1000);
            	}else{
            		setTimeout("setLoggedUser('"+json.userName+"')", 1000);
            	}            	
            }
	    }
	    
	    function setLoggedUser(userName){
	    	window.parent.document.getElementById('login_info').style.display='none';
        	window.parent.document.getElementById('unloggedInfo').style.display='none';
        	window.parent.document.getElementById('loggedInfo').style.display='';
	    	window.parent.document.getElementById('loggedUser').innerHTML = userName;
	    }
	    
	    function gotoRequestedPage(requestedUrl){
	    	window.parent.location.href = requestedUrl; 
	    	$.ajax({type: 'POST', url:'${ctx}/exam/login!clearRequestedURL.action'});	    	
	    }

    </script>
</head>
<body style="margin: 0px; padding: 0px;">
	<div
		style="margin: 0px; padding: 0px; width: 500px; height: 500px; overflow: hidden"
		id="append_parent">
		<div id="div_login" class="m_c">
				<div style="height: 105px; overflow: hidden" class="c cl">
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
					<div style="height: 50px; overflow: hidden" class="trfm  bw0">
						<table>
							<tbody>
								<tr>
									<th><label for="lostpw_email"> 密码:</label></th>
									<td><input type="password"
										onclick="javascript:this.focus()" maxlength="50"
										name="password" id="password" size="25" value="" tabindex="1"
										class="txt" onmousemove="document.onmousemove = null">
									</td>
								</tr>
								<tr>
									<td class="std"></td>
									<td class="std"><label id="pwderror" class="lblerror"></label>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<p class="fsb">
					<span style="padding-left: 10em">
						<input type="button" id="btn_loginbtn" class="pn pnc" onclick="doSubmit();" 
							name="lostpwsubmit" value="登录"
							style="padding: 0px 5px" tabindex="100"/>&nbsp;&nbsp;&nbsp;
						<input type="button"
							onclick="window.parent.document.getElementById('append_parent').style.display='none';"
							class="pn pnc" value="取消" style="padding: 0px 5px"
							tabindex="100"/>
					</span>
				</p>
		</div>

	</div>


</body>
</html>