<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<link href="../css/style.css" type="text/css" rel="Stylesheet"/>
	<script src="../js/jquery-1.9.1.js"></script>
	<script type="text/javascript">
    </script>
</head>
<body style="margin: 0px; padding: 0px;">
<br/>
	<b>参数设置</b><br/>
		<input type="checkbox" name='answerFlag1' value='checked'/>对所有人公开试题&nbsp;<br/>
		<input type="checkbox" name='answerFlag1' value='checked'/>只对注册用户公开试题&nbsp;<br/>
		<input type="checkbox" name='answerFlag1' value='checked'/>只对指定注册用户公开试题&nbsp;<br/>
		<input type="checkbox" name='answerFlag1' value='checked'/>只允许使用邀请链接的用户公开&nbsp;<br/>
		<input type="checkbox" name='answerFlag1' value='checked'/>需要试题邀请码并需要输入考试者姓名&nbsp;<br/><br/>
	
	<b>试题格式</b><br/>
		<input type="checkbox" name='answerFlag1' value='checked'/>保持试题有序/随机出题（默认随机）&nbsp;<br/>
		每次出题目数量&nbsp;<input type="text" name='answerFlag1' value='50' size="3"/>&nbsp;<br/>
		<input type="checkbox" name='answerFlag1' value='checked'/>需要试题邀请码并需要输入考试者姓名&nbsp;<br/><br/>
		
	<b>提交设置</b><br/>
		<input type="checkbox" name='answerFlag1' value='checked'/>只允许提交一次&nbsp;<br/>
		时间限制&nbsp;<input type="text" name='answerFlag1' value='50' size="3"/>秒 - （输入0表示无时间限制）&nbsp;<br/><br/>
	
	<b>成绩设置</b><br/>
		<input type="checkbox" name='answerFlag1' value='checked'/>提交后马上显示分数和通过与否&nbsp;<br/>
		<input type="checkbox" name='answerFlag1' value='checked'/>提交后马上显示所有题目正确与否&nbsp;<br/>
		<input type="checkbox" name='answerFlag1' value='checked'/>简答题阅卷后发送站内消息和邮件通知用户考试结果&nbsp;<br/>
		及格分数&nbsp;<input type="text" name='answerFlag1' value='50' size="3"/><br/>
	
</body>
</html>