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
	var showquestionMaindivDivHeight = 270; 
	function showNextChoice(index) {
		var nextIndex = index + 1;	
		document.getElementById('choice'+nextIndex).style.display='block';
		document.getElementById('moreLink'+index).style.display='none';
		//document.getElementById('divVisiableFlag'+nextIndex).value='block';
		if(nextIndex < 10){
			showquestionMaindivDivHeight = showquestionMaindivDivHeight + 24;
			parent.document.getElementById('showquestion_maindiv').style.height = showquestionMaindivDivHeight + "px";
		}
		if(nextIndex == 10){
			showquestionMaindivDivHeight = showquestionMaindivDivHeight + 7;
			parent.document.getElementById('showquestion_maindiv').style.height = showquestionMaindivDivHeight + "px";			
		}
	}
	
	function calculateCorrectAnswer(){
		var correctAnswerStr = "";
		for(var i=1; i<11; i++){
			var elementName= "answerFlag"+i;
			var element = document.getElementsByName(elementName);
			if(element[0].checked){
				if(correctAnswerStr.length == 0){
					correctAnswerStr =  i;
				}else{
					correctAnswerStr = correctAnswerStr + "," + i;
				}
				
			}		
		}
		
		document.getElementsByName('question.correctAnswer')[0].value=correctAnswerStr;
	}
	
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
	
	function onload(){
		var divVisiableFlag2 = '<s:property value="divVisiableFlags[1]"/>';
		var divVisiableFlag3 = '<s:property value="divVisiableFlags[2]"/>';
		var divVisiableFlag4 = '<s:property value="divVisiableFlags[3]"/>';
		var divVisiableFlag5 = '<s:property value="divVisiableFlags[4]"/>';
		var divVisiableFlag6 = '<s:property value="divVisiableFlags[5]"/>';
		var divVisiableFlag7 = '<s:property value="divVisiableFlags[6]"/>';
		var divVisiableFlag8 = '<s:property value="divVisiableFlags[7]"/>';
		var divVisiableFlag9 = '<s:property value="divVisiableFlags[8]"/>';
		var divVisiableFlag10 = '<s:property value="divVisiableFlags[9]"/>';
		
		if(divVisiableFlag2=='block'){
			document.getElementById('moreLink1').style.display = "none";
		}
		
		if(divVisiableFlag3=='block'){
			document.getElementById('moreLink2').style.display = "none";
		}
		
		if(divVisiableFlag4=='block'){
			document.getElementById('moreLink3').style.display = "none";
		}
		
		if(divVisiableFlag5=='block'){
			document.getElementById('moreLink4').style.display = "none";
			showquestionMaindivDivHeight = showquestionMaindivDivHeight + 24;
			parent.document.getElementById('showquestion_maindiv').style.height = showquestionMaindivDivHeight + "px";	
		}
		
		if(divVisiableFlag6=='block'){
			document.getElementById('moreLink5').style.display = "none";
			showquestionMaindivDivHeight = showquestionMaindivDivHeight + 24;
			parent.document.getElementById('showquestion_maindiv').style.height = showquestionMaindivDivHeight + "px";				
		}
		
		if(divVisiableFlag7=='block'){
			document.getElementById('moreLink6').style.display = "none";
			showquestionMaindivDivHeight = showquestionMaindivDivHeight + 24;
			parent.document.getElementById('showquestion_maindiv').style.height = showquestionMaindivDivHeight + "px";				
		}
		
		if(divVisiableFlag8=='block'){
			document.getElementById('moreLink7').style.display = "none";
			showquestionMaindivDivHeight = showquestionMaindivDivHeight + 24;
			parent.document.getElementById('showquestion_maindiv').style.height = showquestionMaindivDivHeight + "px";				
		}
		
		if(divVisiableFlag9=='block'){
			document.getElementById('moreLink8').style.display = "none";
			showquestionMaindivDivHeight = showquestionMaindivDivHeight + 24;
			parent.document.getElementById('showquestion_maindiv').style.height = showquestionMaindivDivHeight + "px";				
		}		
		
		if(divVisiableFlag10=='block'){
			document.getElementById('moreLink9').style.display = "none";
			showquestionMaindivDivHeight = showquestionMaindivDivHeight + 7;
			parent.document.getElementById('showquestion_maindiv').style.height = showquestionMaindivDivHeight + "px";				
		}	
		
		document.getElementById('examId').value = '<s:property value="examId"/>';
		
	}
	
	function showRequest(){}
	
	function submitForm(actionType){
		$('#questionForm').ajaxSubmit({
			type: 'post',
			url:'${ctx}/exam/choice!'+actionType+'.action',			
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
	<body onload="onload();">
		<br/>
		<form method="post" id="questionForm">	
			<s:hidden name="examId"/>
			<s:hidden name="indexId"/>
			<s:hidden name="questionId"/>
			<s:hidden name="divVisiableFlags"/>
			<s:hidden name="answerFlags"/>
		    
			<table  align="left" border="0">
				<tr>
					<td align="right"><font color=red>*</font> 题目:</td>
					<td>						
						<s:textarea label="Question Content" name="question.content"  cols="50" rows="5" theme="simple"/>
						<font color="red"><label id="error_msg1"></label></font>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align="right"><font color=red>*</font> 正确答案:</td>
					<td>						
						<s:textfield  name="question.correctAnswer" readonly="true" theme="simple" ></s:textfield>
						<font color="red"><label id="error_msg2"></label></font>
					</td>
					<td>标注为正确答案</td>
				</tr>										
				<tr>
					<td align="right" valign="top" width="10%">答案1:</td>
					<td>						
						
						<s:textfield name="choic1" labelposition="top" size="85" theme="simple" ></s:textfield>
						
						<div id="moreLink1"><a href="#" style="text-decoration:none;color:gray" onclick="showNextChoice(1);" alt="显示更多答案选项">更多答案...</a></div>
					</td>
					<td valign="top" width="20%">
						<input type="checkbox" name='answerFlag1' value='checked' onclick="return checkAnswerConent(1);"  <s:property value="answerFlags[0]" />/>Yes - A&nbsp;
					</td>						
				</tr>						
			</table>

			
			<div style="display:<s:property value="divVisiableFlags[1]"/>" id="choice2" >
			<table  align="left" border="0">
				<tr>
					<td align="right" valign="top" width="10%">答案2:</td>
					<td>						
						<s:textfield name="choic2" labelposition="top" size="85" theme="simple" ></s:textfield>
						<div id="moreLink2"><a href="#" style="text-decoration:none;color:gray" onclick="showNextChoice(2);" alt="显示更多答案选项">更多答案...</a></div>
					</td>
					<td valign="top" width="20%">
						<input type="checkbox" name='answerFlag2' value='checked' onclick="return checkAnswerConent(2);"  <s:property value="answerFlags[1]" />/>Yes - B&nbsp;
					</td>						
				</tr>		
			</table>
			</div>
			
			<div style="display:<s:property value="divVisiableFlags[2]"/>" id="choice3" >
			<table  align="left" border="0">
				<tr>
					<td align="right" valign="top" width="10%">答案3:</td>
					<td>						
						<s:textfield name="choic3" labelposition="top" size="85" theme="simple" ></s:textfield>
						<div id="moreLink3"><a href="#" style="text-decoration:none;color:gray" onclick="showNextChoice(3);" alt="显示更多答案选项">更多答案...</a></div>
					</td>
					<td valign="top" width="20%">
						<input type="checkbox" name='answerFlag3' value='checked' onclick="return checkAnswerConent(3);"  <s:property value="answerFlags[2]" />/>Yes - C&nbsp;
					</td>						
				</tr>		
			</table>
			</div>
			
			<div style="display:<s:property value="divVisiableFlags[3]"/>" id="choice4" >
			<table  align="left" border="0">
				<tr>
					<td align="right" valign="top" width="10%">答案4:</td>
					<td>						
						<s:textfield name="choic4" labelposition="top" size="85" theme="simple" ></s:textfield>
						<div id="moreLink4"><a href="#" style="text-decoration:none;color:gray" onclick="showNextChoice(4);" alt="显示更多答案选项">更多答案...</a></div>
					</td>
					<td valign="top" width="20%">
						<input type="checkbox" name='answerFlag4' value='checked' onclick="return checkAnswerConent(4);"  <s:property value="answerFlags[3]" />/>Yes - D&nbsp;
					</td>						
				</tr>		
			</table>
			</div>
			
			<div style="display:<s:property value="divVisiableFlags[4]"/>" id="choice5" >
			<table  align="left" border="0">
				<tr>
					<td align="right" valign="top" width="10%">答案5:</td>
					<td>						
						<s:textfield name="choic5" labelposition="top" size="85" theme="simple" ></s:textfield>
						<div id="moreLink5"><a href="#" style="text-decoration:none;color:gray" onclick="showNextChoice(5);" alt="显示更多答案选项">更多答案...</a></div>
					</td>
					<td valign="top" width="20%">
						<input type="checkbox" name='answerFlag5' value='checked' onclick="return checkAnswerConent(5);"  <s:property value="answerFlags[4]" />/>Yes - E&nbsp;
					</td>						
				</tr>		
			</table>
			</div>
			
			<div style="display:<s:property value="divVisiableFlags[5]"/>" id="choice6" >
			<table  align="left" border="0">
				<tr>
					<td align="right" valign="top" width="10%">答案6:</td>
					<td>						
						<s:textfield name="choic6" labelposition="top" size="85" theme="simple" ></s:textfield>
						<div id="moreLink6"><a href="#" style="text-decoration:none;color:gray" onclick="showNextChoice(6);" alt="显示更多答案选项">更多答案...</a></div>
					</td>
					<td valign="top" width="20%">
						<input type="checkbox" name='answerFlag6' value='checked' onclick="return checkAnswerConent(6);"  <s:property value="answerFlags[5]" />/>Yes - F&nbsp;
					</td>						
				</tr>		
			</table>
			</div>

			<div style="display:<s:property value="divVisiableFlags[6]"/>" id="choice7" >
			<table  align="left" border="0">
				<tr>
					<td align="right" valign="top" width="10%">答案7:</td>
					<td>						
						<s:textfield name="choic7" labelposition="top" size="85" theme="simple" ></s:textfield>
						<div id="moreLink7"><a href="#" style="text-decoration:none;color:gray" onclick="showNextChoice(7);" alt="显示更多答案选项">更多答案...</a></div>
					</td>
					<td valign="top" width="20%">
						<input type="checkbox" name='answerFlag7' value='checked' onclick="return checkAnswerConent(7);"  <s:property value="answerFlags[6]" />/>Yes - G&nbsp;
					</td>						
				</tr>		
			</table>
			</div>
			
			<div style="display:<s:property value="divVisiableFlags[7]"/>" id="choice8" >
			<table  align="left" border="0">
				<tr>
					<td align="right" valign="top" width="10%">答案8:</td>
					<td>						
						<s:textfield name="choic8" labelposition="top" size="85" theme="simple" ></s:textfield>
						<div id="moreLink8"><a href="#" style="text-decoration:none;color:gray" onclick="showNextChoice(8);" alt="显示更多答案选项">更多答案...</a></div>
					</td>
					<td valign="top" width="20%">
						<input type="checkbox" name='answerFlag8' value='checked' onclick="return checkAnswerConent(8);"  <s:property value="answerFlags[7]" />/>Yes - H&nbsp;
					</td>						
				</tr>		
			</table>
			</div>
			
			<div style="display:<s:property value="divVisiableFlags[8]"/>" id="choice9" >
			<table  align="left" border="0" >
				<tr>
					<td align="right" valign="top" width="10%">答案9:</td>
					<td>						
						<s:textfield name="choic9" labelposition="top" size="85" theme="simple" ></s:textfield>
						<div id="moreLink9"><a href="#" style="text-decoration:none;color:gray" onclick="showNextChoice(9);" alt="显示更多答案选项">更多答案...</a></div>
					</td>
					<td valign="top" width="20%">
						<input type="checkbox" name='answerFlag9' value='checked' onclick="return checkAnswerConent(9);"  <s:property value="answerFlags[8]" />/>Yes - I&nbsp;
					</td>						
				</tr>		
			</table>
			</div>							
								
			<div style="display:<s:property value="divVisiableFlags[9]"/>" id="choice10" >
			<table  align="left" border="0">
				<tr>
					<td align="right" width="10%">答案10:</td>
					<td>						
						<s:textfield name="choic10" labelposition="top" size="85" theme="simple" ></s:textfield>
					</td>
					<td width="20%">
						<input type="checkbox" name='answerFlag10' value='checked' onclick="return checkAnswerConent(10);"  <s:property value="answerFlags[9]" />/>Yes - J&nbsp;
					</td>						
				</tr>		
			</table>
			</div>		
				
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