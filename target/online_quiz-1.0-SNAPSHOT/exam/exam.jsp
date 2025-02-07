<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>考试100</title>
    <script src="../js/jquery-1.9.1.js"></script>
    <script src="../js/jquery.form.min.js"></script>
    <script src="../js/jquery.highlight.js"></script>   
    <script src="../js/ksis.js" type="text/javascript"></script>
    <script src="../js/exam.js"></script>   
    
    <link href="../css/style.css" type="text/css" rel="Stylesheet"/>
    <link href="../css/exam.css" type="text/css" rel="Stylesheet"/>
    
    <script language="javascript" type="text/javascript">
        var displayIndex = 0;
    </script>
</head>

<body onload="timedCount();">
    <jsp:include page="../common/header_exam.jsp" />	
    <form method="post" name="form">   	
        <div class="examvip mw">
            <div class="boxtitle"></div>          
            <div class="clear"></div>
            <div class="boxcontent2">
                <div class="titleinner1">
                    <font size="3"><b>试题名称:</b> <c:out value="${exam.name}" escapeXml="false"/> &nbsp;&nbsp;&nbsp;&nbsp;<b>编号:</b><c:out value="${exam.shortName}" escapeXml="false"/></font> <br /><br/>
                </div>
            </div>
            <div class="boxtitle2"></div>
            <div class="boxcontent3">		
		<div id="questionList" style="margin-top:-6px;float:left;" >
                    <s:iterator value="exam.questions" id="ques" status="status" >	
                        <div id="questionContent${status.count}" 
                              <s:if test="%{#ques.questionType == 5 }">
                                style="font-weight:bold" 
                              </s:if>
                              <s:if test="%{#status.count%2==0}">					
                                    class="questionContentDiv_odd" 
                              </s:if>
                              <s:else>
                                    class="questionContentDiv_even" 
                              </s:else>	  
                        >
                        <div style="width:920px;float:left;">
                            <table width="100%">
                                <tr>
                                    <td width="2%" valign="top">
                                        <s:if test="%{#ques.questionType != 5 }">
                                          <b><span>
                                            <script type="text/javascript">
                                                displayIndex++;
                                                document.write(displayIndex);                                            
                                            </script>        
                                            </span>.</b>&nbsp;
                                        </s:if>                                    
                                        <s:else>
                                            &nbsp;&nbsp;&nbsp;
                                        </s:else>
                                    </td>
                                    <td width="98%" colspan="2" align='left'>
                                        <div><c:out value="${ques.content}" escapeXml="false"/></div>
                                        <a id="anchor${status.count}" ></a>	
                                        <input type="hidden" id="answer${status.count}" value="${ques.correctAnswer}" />
                                        <input type="hidden" id="qusType${status.count}" value="${ques.questionType}" />
                                    </td>
                                </tr>
                                <s:if test="%{#ques.questionType==2 || #ques.questionType==1 }">
                                        <!-- Multi Select Type or Single Select Type -->
                                        <s:iterator value="#ques.choices" id="choice" >
                                            <tr>
                                                <td width="2%" style="padding-top:6px;">&nbsp;&nbsp;</td>
                                                <td width="4%" valign="top" style="padding-top:6px;">
                                                    <input 
                                                        <s:if test="%{#ques.questionType==1}">
                                                        type="radio" 
                                                        </s:if>
                                                        <s:elseif test="%{#ques.questionType==2}">
                                                        type="checkbox" 
                                                        </s:elseif>
                                                        id="choice${status.count}${choice.choiceTitle}" 
                                                        name="choice${status.count}"
                                                        onclick="hiddenUncompletedInfo(${status.count});setLinkStatus(${status.count});"
                                                        value="${choice.choiceKey}"
                                                    />&nbsp;&nbsp;${choice.choiceTitle}.</td>
                                                <td align='left' width="94%" style="padding-top:6px;">
                                                    <div><c:out value="${choice.choiceContent}" escapeXml="false"/></div>
                                                </td>
                                            </tr>
                                        </s:iterator>
                                </s:if>
                                <!-- checkbox -->
                                <s:elseif test="%{#ques.questionType==3}">
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td colspan="2" align='left'>
                                            <s:radio list="#{'1':'正确','0':'错误'}" name="checkbox<s:property value='#status.count'/>"   theme="simple"/>
                                        </td>
                                    </tr>
                                </s:elseif>
                                <!-- short answer -->
                                <s:elseif test="%{#ques.questionType==4}">
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td colspan="2">
                                            <s:textarea label="Question Content" name="checkbox<s:property value='#status.count'/>"  cols="100" rows="3" theme="simple" />
                                        </td>
                                    </tr>
                                </s:elseif>
                                <!-- note -->
                                <s:elseif test="%{#ques.questionType==5}">
                                </s:elseif>		
                                </table>								
                                </div>
                                <!-- 只有备注不需要难度星星,正确答案等信息 -->
                                <s:if test="%{#ques.questionType != 5 }">
                                    <div style="width:50px;float:left;margin:auto">											
                                            <div id="correctReuslt${status.count}" style="width:34px;display:none;float:left;margin-left:-100px"><font size=24px color=blue>√</font></div>
                                            <div id="wrongResult${status.count}" style="width:34px;display:none;float:left;margin-left:-100px"><font size=24px color=red>✗</font></div>			
                                            <div id="difficultLevel${status.count}" style="width:16px;float:left;padding-left:10px" >
                                                <a class="no_click_on" name="star${status.count}[]" title="较低难度" onmouseover="star_onmouse_over(this.name,1)" onmouseout="star_onmouse_out(this.name,${status.count})" onclick="star_onclick(this.name,${status.count},1)">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a><br/>
                                                <a class="no_click_on" name="star${status.count}[]" title="中等难度" onmouseover="star_onmouse_over(this.name,2)" onmouseout="star_onmouse_out(this.name,${status.count})" onclick="star_onclick(this.name,${status.count},2)">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a><br/>
                                                <a class="no_click_on" name="star${status.count}[]" title="最高难度" onmouseover="star_onmouse_over(this.name,3)" onmouseout="star_onmouse_out(this.name,${status.count})" onclick="star_onclick(this.name,${status.count},3)">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a><br/>
                                                <input id="difficultLevel${status.count}" type="hidden" value="0"/>
                                                <input id="firstDifficultLevel${status.count}"  type="hidden" value="0"/>					      	
                                            </div>												
                                    </div>
                                    <div class="clear"></div> 
                                    <div style="display:none" id="uncompletedInfo${status.count}" >
                                            <font color=blue><b>*</b> 请选择答案.</font>
                                    </div>
                                    <div style="display:none" id="correctAnswer${status.count}" >
                                            <font color=blue><b>*</b> 正确答案是: <b><c:out value="${ques.correctAnswerTitle}" escapeXml="false"/></b></font>
                                    </div>	
                                </s:if>
                            </div>
                            <div class="clear"></div> 
                        </s:iterator>            
                        <div style="width:970px;height:90px;float:left;padding:5px 5px 5px 5px;border:1px;border-color:#f5f5f5;border-style:solid;" >
                    </div>
                </div>
	
            </div>
	 </div>	

		
        <div id="tstart-toolbar-bottom">
            <div class="tstart-left">
        	<div id="statusList" style="margin:8px;float:left;">
                   <table cellspacing="0" cellpadding="2" border="0"  bgcolor="#FFFFFF"  id="idboxs" class="idbox" style="BORDER-COLLAPSE: collapse; valign:middle">
                        <tbody>
                            <tr bgcolor="#FFFFFF" align="center">                                        
                            <s:iterator value="indexs" id="index" status="status" >                                        
                            <s:if test="%{#status.count>1 && #status.count%40==1}">
                                </tr>
                                <tr bgcolor="#FFFFFF" align="center">							
                            </s:if>                                             
                            <s:if test="%{#index>0}">
                                <td onclick="scroller('#anchor${status.count}');" 
                                    style="cursor:pointer;" 
                                    class="mytd" 
                                    id="quesLink${status.count}">									
                                    <a id="quesLinkText${status.count}" href="#" title="快速跳转至试题${status.count}">${status.count}</a>
                                </td>
                            </s:if>
                            <s:else>
                                <td  id="quesLink${status.count}" class="mytd_blank" >&nbsp;</td>
                            </s:else>
                            </s:iterator>
                            </tr>
                            <tr bgcolor="#FFFFFF" align="center">
                            </tr>
                                <tr align="center" bgcolor="#FFFFFF">
                                    <td width="16px" >
                                        <div class="answeredQuestion"> </div>
                                    </td>
                                    <td colspan="3"  style="padding-top:3px">&nbsp;已答题</td>
                                    <td width="5px" &nbsp;</td>
                                    <td width="16px">
                                        <div class="unAnsweredQuestion"> </div>
                                    </td>
                                    <td colspan="3"  style="padding-top:3px">&nbsp;未答题</td>
                                </tr>				        
                        </tbody>
                    </table>
                </div>
		
                <div id="hintinfo" style="margin:5px;float:right;padding-top:20px;">
                    <div id="timer" style="height:45px;padding-right:65px">
                        考试已用时间：<label style="font-weight:bold; " id="timer_count">07:22</label>
                    </div>
                    <div id="exam_result" style="height:45px;padding-left:30px;display:none">
                        您的得分：<label style="font-weight:bold; color:red;" id="exam_score">100</label>
                    </div>				
                    <div class="clear"></div>
                    <div id="buttons" >
                        <div style="display:none;float:right;position: relative; padding-right:5px;" id="showCorrectAnswerDiv">
                            <a href="#" onclick="showAnswer(<s:property value='exam.questions.size'/>);" ><span class="rbtn_title_longer"><b>显示正确答案</b></span></a>					 
                        </div> 
                        <div style="display:none;float:right;position: relative; " id="hiddenCorrectAnswerDiv">
                            <a href="#" onclick="hiddenAnswer(<s:property value='exam.questions.size'/>);" ><span class="rbtn_title_longer"><b>隐藏正确答案</b></span></a>					 
                        </div>             
                        <div style="display:block;float:right;position: relative; padding-right:100px;" id="submitDiv">
                        <a href="#" onclick="doit(<s:property value='exam.questions.size'/>);" ><span class="rbtn_title"><b>交&nbsp;&nbsp;&nbsp;&nbsp;卷</b></span></a>					
                        </div>             
                        <div style="display:none;float:right;position: relative; padding-right:5px;" id="redoDiv">
                        <a href="#" onclick="window.location.reload();" ><span class="rbtn_title"><b>重新出题</b></span></a>					 
                        </div> 			
                    </div>
                </div>
            </div>
         </div>
    </form>	
</body>
</html>