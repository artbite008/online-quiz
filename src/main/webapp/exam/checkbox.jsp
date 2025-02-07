<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../css/style.css" type="text/css" rel="Stylesheet"/>
<link href="../css/popup.css" type="text/css" rel="Stylesheet" />

<script src="../js/jquery-1.9.1.js"></script>
<script src="../js/jquery.form.min.js"></script>
<script src="../js/jquery-1.9.1.js"></script>
<script src="../js/jquery.form.min.js"></script>
<script type="text/javascript">
	
	function checkAnswerConent(index){
		var element = document.getElementById('choic'+index);
		if(element.value.length<1){
			alert('选项答案内容不能为空，请填写第'+index+'个选项。');
			return false;
		}else{
			calculateCorrectAnswer();
			return true;
		}
	}
		
	function showRequest(){}
	
	function submitForm(actionType){
		$('#questionForm').ajaxSubmit({
			type: 'post',
			url:'${ctx}/exam/checkbox!'+actionType+'.action',			
			beforeSubmit:  showRequest,  
			success: showResponse,
			error: function(XmlHttpRequest, textStatus, errorThrown){
					 alert("error");  
			}
		}); 
	}	
	
	function showResponse(responseText, statusText, xhr, $form){	
		var json = eval("(" + responseText + ")");	
		if(json.status == -1 ){//validation failed case1
			$("#error_msg1").html(json.msg);
			$("#error_msg2").html('');
		}		
		if(json.status == -2 ){//validation failed case2
			$("#error_msg2").html(json.msg);
			$("#error_msg1").html('');
		}			
		if(json.status == 1 ){//return from add action
			parent.document.getElementById("questionList").innerHTML = 
				parent.document.getElementById("questionList").innerHTML + json.newQuestionHtml;
		    //alert(json.newQuestionHtml);
			$("#append_parent", parent.document).toggle();
		}
		if(json.status == 2 ){//return from update action
			var quesId = json.questionId;
			parent.document.getElementById('question_'+quesId).innerHTML = json.newQuestionHtml;
			$("#append_parent", parent.document).toggle();
		}
	}
	
</script>		

</head>
	<body >
		<br/>
		<form method="post" id="questionForm">	
			<s:hidden name="examId"/>
			<s:hidden name="questionId"/>
			<s:hidden name="indexId"/>
		    
			<table  align="left" border="0">
				<tr>
					<td align="right" width="20%"><font color=red>*</font> 题目:</td>
					<td width="60%">						
						<s:textarea label="Question Content" name="question.content"  cols="50" rows="3" theme="simple"/>
						<font color="red"><label id="error_msg1"></label></font>
					</td>
					<td width="10%">&nbsp;</td>
				</tr>
				<tr>
					<td width="20%" colspan="3">&nbsp;</td>
				</tr>				
				<tr>
					<td align="right" width="20%" valign="middle"><font color=red>*</font> 正确答案:</td>
					<td width="60%">						
						<s:if test="%{questionId>0}">
							<s:radio list="#{'1':'正确','0':'错误'}" name="question.correctAnswer"  theme="simple"/>
						</s:if>
						<s:else>	
							<s:radio list="#{'1':'正确','0':'错误'}" name="question.correctAnswer" value=""  theme="simple"/>	
						</s:else>				
						<font color="red"><label id="error_msg2"></label></font>
					</td>
					<td width="20%">&nbsp;</td>
				</tr>			
				<tr>
					<td width="20%" colspan="3">&nbsp;</td>
				</tr>										
			</table>

		</form>
		
		<div id="append_parent2" >
			<div class="m_c">
			<p class="fsb">
				<span style="padding-left: 19em">
					<s:if test="%{questionId>0}">
						<input type=button value="保存并关闭" onclick="submitForm('update');" class="pn pnc" style="padding: 0px 5px"/>
					</s:if>
					<s:else>
						<input type=button value="保存并关闭" onclick="submitForm('add');" class="pn pnc" style="padding: 0px 5px"/>
					</s:else>		
					<input type="button"
						onclick="window.parent.document.getElementById('append_parent').style.display='none';"
						class="pn pnc" value="返回" style="padding: 0px 5px"
						tabindex="100"/>
				</span>
			</p>
			</div>
		</div>
	</body>
</html>