<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>考试100</title>
    <script src="../js/jquery-1.9.1.js" type="text/javascript"></script>
    <script src="../js/jquery.form.min.js" type="text/javascript"></script>
    <script src="../js/jquery.highlight.js" type="text/javascript"></script>
    <script src="../js/ksis.js" type="text/javascript"></script>
    <script src="../ckeditor/ckeditor.js" type="text/javascript"></script>
    <script src="../js/linkedlist.js" type="text/javascript" charset="utf-8"></script>    
    <script src="../js/maintain.js" type="text/javascript" charset="utf-8"></script>    
    <link href="../css/style.css" type="text/css" rel="Stylesheet"/>
    <link href="../css/popup.css" type="text/css" rel="Stylesheet" />
    
    <script type="text/javascript">
        //创建双向链表，用于保存问题顺序的变化和对后台的实时更新
        var linkedList = new LinkedList();
        var displayIndex = 0;
        
        //把当前层的内容跟上一层的内容交换
        //把当前node跟上一node交换
        //同时交换orderIndex,并保存到数据库
        //如果上一层和当前层两个都不是Note,displayIndex也交换
        //如果有一个是note,displayIndex不交换
        //如果交换后的当前node是第一个，隐藏当前node的up按钮，显示下个node的up按钮
        function moveDivUp(questionId){
            var node = linkedList.getNodeByValue(questionId);
            var preNode = node.preNode;
            
            //把当前层的内容跟上一层的内容交换
            exchangeDivById('question_'+node.nodeValue, 'question_'+preNode.nodeValue);
            
            //同时交换orderIndex,并保存到数据库
            var tempOrderIndex = node.orderIndex;
            node.orderIndex = preNode.orderIndex;
            preNode.orderIndex = tempOrderIndex;
            //保存当前node的新orderIndex到数据库
            var examId = $('#hiddenExamId').val();
            var reqData1={examId: examId, questionId: node.nodeValue, propertyValue:node.orderIndex, propertyName:'orderIndex', propertyType:'number'};
            ajaxUpdateSingleProperty('question!updateQuestionProperty.action',reqData1);
            //保存前一个node的新orderIndex到数据库
            var reqData2={examId: examId, questionId: preNode.nodeValue, propertyValue:preNode.orderIndex, propertyName:'orderIndex', propertyType:'number'};
            ajaxUpdateSingleProperty('question!updateQuestionProperty.action',reqData2);       
            
            //如果上一层和当前层两个都不是Note,displayIndex也交换
            if(node.displayIndex != -1 && preNode.displayIndex != -1){
                var tempDisplayIndex = node.displayIndex;
                node.displayIndex = preNode.displayIndex;
                preNode.displayIndex = tempDisplayIndex;
                //更新页面上的displayIndex
                $('#displayIndex_'+node.nodeValue).html(node.displayIndex+'');
                $('#displayIndex_'+preNode.nodeValue).html(preNode.displayIndex+'');                
            }
            
            //把当前node跟上一node交换在链表中的位置
            var newNode = exchangeNode(linkedList, preNode, node);
            
            //如果交换后的后一个node是最后一个,把这2个node的上移下移链接都调换位置
            if(newNode.nextNode.nextNode == null){
                exchangeDivById('downLinkDiv_'+newNode.nodeValue,'upLinkDiv_'+newNode.nodeValue);     
                exchangeDivById('downLinkDiv_'+newNode.nextNode.nodeValue,'upLinkDiv_'+newNode.nextNode.nodeValue);  
                
                //倒数第二个div需要恢复down link的显示
                $('#downLinkDiv_'+newNode.nodeValue).css('visibility','visible');
            }          
            
            if(newNode.preNode == null){
                //隐藏当前选择div的up link 因为它已经是第一个问题
                $('#upLinkDiv_'+newNode.nodeValue).css('visibility','hidden');
                
                //第二个div需要恢复down link的显示
                $('#downLinkDiv_'+newNode.nextNode.nodeValue).css('visibility','visible');
            }
            
            //跳平滑转至2个接点中的前面一个，这样两个问题都能展示出来
            //location.hash = 'anchor_'+newNode.nodeValue;
            $('html,body').animate({scrollTop: $('#anchor_'+newNode.nodeValue).offset().top-250}, 500);//250px是顶部固定层的高度
        }        
        
        //把当前层跟下一层交换
        //把当前node跟下一node的内容交换
        //同时交换sortIndex,并保存到数据库
        //如果下一层和当前层有一个不是Note,displayIndex也交换
        //如果有一个是note,displayIndex不交换        
        //如果交换后的当前node是最后一个，隐藏前node的down按钮，显示上个node的down按钮
        function moveDivDown(questionId){
            var node = linkedList.getNodeByValue(questionId);
            var nextNode = node.nextNode;
            
            //把当前node跟下一node的内容交换
            exchangeDivById('question_'+node.nodeValue, 'question_'+nextNode.nodeValue);     
            
            //同时交换orderIndex,并保存到数据库
            var tempOrderIndex = node.orderIndex;
            node.orderIndex = nextNode.orderIndex;
            nextNode.orderIndex = tempOrderIndex;
            //保存当前node的新orderIndex到数据库
            var examId = $('#hiddenExamId').val();
            var reqData1={examId: examId, questionId: node.nodeValue, propertyValue:node.orderIndex, propertyName:'orderIndex', propertyType:'number' };
            ajaxUpdateSingleProperty('question!updateQuestionProperty.action',reqData1);
            //保存下一个node的新orderIndex到数据库
            var reqData2={examId: examId, questionId: nextNode.nodeValue, propertyValue:nextNode.orderIndex, propertyName:'orderIndex', propertyType:'number' };
            ajaxUpdateSingleProperty('question!updateQuestionProperty.action',reqData2);  
            
            //如果下一个和当前层两个都不是Note,displayIndex也交换
            if(node.displayIndex != -1 && nextNode.displayIndex != -1){
                var tempDisplayIndex = node.displayIndex;
                node.displayIndex = nextNode.displayIndex;
                nextNode.displayIndex = tempDisplayIndex;
                //更新页面上的displayIndex
                $('#displayIndex_'+node.nodeValue).html(node.displayIndex+'');
                $('#displayIndex_'+nextNode.nodeValue).html(nextNode.displayIndex+'');
            }                        
            
            //把当前node跟下一node交换在链表中的位置
            var newNode = exchangeNode(linkedList, node, nextNode).nextNode;
            
            //alert(linkedList.toString());
            
            //如果交换后的后一个node是最后一个,把这2个node的上移下移链接都调换位置
            if(newNode.nextNode == null){
                exchangeDivById('downLinkDiv_'+newNode.nodeValue,'upLinkDiv_'+newNode.nodeValue);     
                exchangeDivById('downLinkDiv_'+newNode.preNode.nodeValue,'upLinkDiv_'+newNode.preNode.nodeValue);
                
                //隐藏当前选择div的down link 因为它已经是最后一个问题
                $('#downLinkDiv_'+newNode.nodeValue).css('visibility','hidden');
            }  
            
            //如果交换后的前一个node是第一个,把第二个节点(原来的第一个节点)的uplink显示出来
            if(newNode.preNode.preNode == null){
                $('#upLinkDiv_'+newNode.nodeValue).css('visibility','visible');
            }
            
            //跳平滑转至2个接点中的前面一个，这样两个问题都能展示出来
            $('html,body').animate({scrollTop: $('#question_'+newNode.nodeValue).offset().top-250}, 500);//250px是顶部固定层的高度
        }
        
        function initPage(){
            var quesDivs = $("div[id^='quesCont_']");		
            var quesSize = $("div[id^='quesCont_']").length;
            var choiceDivs = $("div[id^='choiceCont_']");
            var choiceSize = $("div[id^='choiceCont_']").length;
            
            for(var i=0; i<quesSize; i++){			
                var quesDivId = quesDivs[i].getAttribute('id');
                var divContent = quesDivs[i].innerHTML;
                divContent = divContent.replace(/<[^>]+>/g,'');
                divContent = $.trim(divContent);
                var hintDivId = '#quesHint_'+quesDivId.replace('quesCont_','');
                if(divContent.length ==0 ){
                    quesDivs[i].style.display= 'none';				
                    $(hintDivId)[0].style.display= 'block';
                }else{
                    $(hintDivId)[0].style.display= 'none';	
                }			
            }    
            
            for(var j=0; j<choiceSize; j++){			
                var choiceDivId = choiceDivs[j].getAttribute('id');
                var choiceContent = choiceDivs[j].innerHTML;
                choiceContent = choiceContent.replace(/<[^>]+>/g,'');
                choiceContent = $.trim(choiceContent);
                var chintDivId = '#choiceHint_'+choiceDivId.replace('choiceCont_','');
                if(choiceContent.length == 0 ){
                    choiceDivs[j].style.display= 'none';				
                    $(chintDivId)[0].style.display= 'block';
                }else{
                    $(hintDivId)[0].style.display= 'none';	
                }			
            }
            
            //init the tooptip
            if('${exam.name}' == '新建考试试题'){
                ddrivetip($('#exam_name')[0],'请点击这里输入新的试题全称', 156);      
            }           
            
            //alert(linkedList.toString());
            
        }    
        
        function submitForm(){
            $('#examfr').ajaxSubmit({
                type: 'post',
                url:'${ctx}/exam/maintain!add.action',		
                beforeSubmit:  showRequest,  
                success: showResponse,
                error: function(XmlHttpRequest, textStatus, errorThrown){
                                 alert( "error");  
                }
            }); 
        }	
        
        function submitFormOnly(examId){
            $('#examfr').ajaxSubmit({
                type: 'post',
                url:'${ctx}/exam/maintain!update.action?examId='+examId			
            }); 
        }	  
        
        function addChoice(){
            document.getElementById('returnmessage3_LLapc').innerHTML="添加选择题";		
            var examId = $('#hiddenExamId').val(); 
            document.getElementById('showquestionframe').src = "${ctx}/exam/choice.action?examId="+examId;
            document.getElementById('showquestion_maindiv').style.height = '270px';
            document.getElementById('append_parent').style.display='';		
        }
        
        function updateChoice(questionId, indexId){
            document.getElementById('returnmessage3_LLapc').innerHTML="编辑选择题";		
            document.getElementById('showquestionframe').src = "${ctx}/exam/choice.action?questionId="+questionId+"&indexId="+indexId;
            document.getElementById('showquestion_maindiv').style.height = '270px';
            document.getElementById('append_parent').style.display='';		
        }
        
        function addCheckbox(){
            document.getElementById('returnmessage3_LLapc').innerHTML="添加判断题";		
            var examId = $('#hiddenExamId').val(); 
            document.getElementById('showquestionframe').src = "${ctx}/exam/checkbox.action?examId="+examId;
            document.getElementById('showquestion_maindiv').style.height = '165px';
            document.getElementById('append_parent').style.display='';		
        }
        
        function updateCheckbox(questionId,indexId){
            document.getElementById('returnmessage3_LLapc').innerHTML="编辑判断题";		
            document.getElementById('showquestionframe').src = "${ctx}/exam/checkbox.action?questionId="+questionId+"&indexId="+indexId;
            document.getElementById('showquestion_maindiv').style.height = '165px';
            document.getElementById('append_parent').style.display='';		
        }	
        
        function addEssay(){
            document.getElementById('returnmessage3_LLapc').innerHTML="添加问答题";		
            var examId = $('#hiddenExamId').val(); 
            document.getElementById('showquestionframe').src = "${ctx}/exam/essay.action?type=essay&examId="+examId;
            document.getElementById('showquestion_maindiv').style.height = '170px';
            document.getElementById('showquestion_maindiv').style.top = '250px';
            document.getElementById('append_parent').style.display='';		
        }
        
        function updateEssay(questionId,indexId){
            document.getElementById('returnmessage3_LLapc').innerHTML="编辑问答题";		
            document.getElementById('showquestionframe').src = "${ctx}/exam/essay.action?type=essay&questionId="+questionId+"&indexId="+indexId;
            document.getElementById('showquestion_maindiv').style.height = '180px';
            document.getElementById('showquestion_maindiv').style.top = '250px';
            document.getElementById('append_parent').style.display='';		
        }		
        
        
        function addNote(){
            document.getElementById('returnmessage3_LLapc').innerHTML="添加备注";		
            var examId = $('#hiddenExamId').val(); 
            document.getElementById('showquestionframe').src = "${ctx}/exam/essay.action?type=note&examId="+examId;
            document.getElementById('showquestion_maindiv').style.height = '130px';
            document.getElementById('showquestion_maindiv').style.top = '250px';
            document.getElementById('append_parent').style.display='';		
        }
        
        function updateNote(questionId,indexId){
            document.getElementById('returnmessage3_LLapc').innerHTML="编辑备注";		
            document.getElementById('showquestionframe').src = "${ctx}/exam/essay.action?type=note&questionId="+questionId+"&indexId="+indexId;
            document.getElementById('showquestion_maindiv').style.height = '130px';
            document.getElementById('showquestion_maindiv').style.top = '250px';
            document.getElementById('append_parent').style.display='';		
        }		
        
        function deleteQuestion(questionId){
            $("#question_"+questionId).remove();
            $("#maintainQues_"+questionId).remove();  
                
            $.ajax({
                type: 'POST',
                    url: "${ctx}/exam/choice!delete.action",
                    data: {questionId: questionId}
            });
        }
        
        function deleteQuestion(questionId){
            var divId = '#question_'+questionId;
            $(divId).remove();
                
            $.ajax({
                type: 'POST',
                    url: "${ctx}/exam/question!delete.action",
                    data: {questionId: questionId}
            });
        }
        
        function deleteChoice(questionId, choiceId){
            var tableRowId = '#choiceRow_' + questionId + '_' + choiceId;
            $(tableRowId).remove();
                
            $.ajax({
                type: 'POST',
                    url: "${ctx}/exam/choice!delete.action",
                    data: {choiceId: choiceId}
            });
        }
        
        function ajaxUpdateSingleProperty(actionName, reqData){
            $.ajax({
                type: 'POST',
                    url: '${ctx}/exam/'+actionName,
                    data: reqData,
                    success: function(responseText, statusText, xhr, $form){
                            var json = eval("(" + responseText + ")");
                            if(json.examId){
                                $('#hiddenExamId').attr("value",json.examId);
                            }
                    }
            });	 
        }	
    </script>
</head>
<body style="overflow-y:scroll;" onload="initPage();">
    <input type=hidden value="" id="oldValueHolder" />
    <input type="hidden" name="hiddenExamId" id="hiddenExamId" value="${examId}" />	
    <div style="width:970px;height:239px;background-color:white;padding-top:-10px;display: block;" id="vgap1"></div>
    <div style="width:970px;height:134px;background-color:white;padding-top:-10px;display: none;" id="vgap2"></div>
    
    <!-- 头部固定区域 开始-->
    <div id="tstart-toolbar-top">
        <div class="tstart-middle2">
            <div class="logged_infobar_gap"></div>
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
                <div class="logged_infobar_nogap"  id="loggedInfo">
                        
                         下午好，<label id="loggedUser"><s:property value='#session.loggedUser.userName'/></label> &nbsp;&nbsp;
                   | &nbsp;&nbsp;
                  <a href="${ctx}/exam/login!logoff.action" >退出</a>
                </div>  
            </div>          
            <div class="vip mw">
                <div class="boxtitle"></div>
                <div class="clear"></div>
                <div class="boxcontent2">
                    <div class="titleinner1">
                            <s:if test="%{examId>0}">	
                            &nbsp;&nbsp;<a href="/ksis/index.action" class="a1">考试100</a> > <a class="a1" href="/ksis/exam/list.action">用户中心</a>  > <a class="a1" href="/ksis/exam/list.action">我创建的试题</a>  > 试题管理 
                    </s:if>
                    <s:else>
                            &nbsp;&nbsp;<a href="#" class="a1">考试100</a> > <a class="a1" href="#">用户中心</a>  > 创建新试题
                    </s:else>
                    </div>
                 </div>
                 <div class="boxtitle2"></div>                            
                 <div class="clear"></div>
                             
                 <div>
                    <ul id="tab_nav">
                        <li style="margin-left:10px;border-bottom: 1px solid #FFFFFF;font-weight: bold;background:#FFF;" id="basicInfoLink"><a href="#" onclick="switchTab(0);">考题内容</a></li>
                        <li id="settingInfoLink" ><a href="#" onclick="switchTab(1);">参数设置</a></li>
                        <li id="shareInfoLink"><a href="#" onclick="switchTab(2);">分享设置</a></li>
                        <li id="reviewInfoLink"><a href="#" onclick="switchTab(3);">主观题批改</a></li>
                        <li id="statisticsInfoLink"><a href="#" onclick="switchTab(4);" >成绩统计排行</a></li>
                    </ul>
                </div>    
                            
                <div class="boxcontent4 active" id="baseInfoHeader">
                    <div style="position:relative;border-bottom:1px #a4c9ee solid ; border-top:none; border-left: none;border-right:none;height:55px;margin-top:10px">	
                        <table  align="left">	
                            <tr>
                               <td align="right" height="25px" style="padding=left:8px;margin-top:1px">
                                    <div class="inputDiv">试题编号:</div>
                                </td>
                                <td align="left" height="25px" >
                                    <div id="hint_shortName" class="hintDiv" 
                                                 onmouseover="overText('#hint_shortName','hintDiv_on')" 
                                                 onmouseout="outText('#hint_shortName','hintDiv_on')" 
                                                 onclick="hiddenHintAndShowInput('#hint_shortName','#exam_shortName','inputDiv_selected')" 
                                         style="margin-top:-7px;width: 850px;display: <s:if test="%{examId>0}">none</s:if><s:else>block</s:else>;">输入试题编号或简称</div>
                                    <div contenteditable="true"
                                             class="inputDiv" 
                                         id="exam_shortName" 
                                         onblur="saveExamProperty('#exam_shortName','shortName','#hint_shortName','inputDiv_selected')" 
                                         onclick="backupValueAndSetBg('#exam_shortName','inputDiv_on','inputDiv_selected')"
                                         onmouseover="overText('#exam_shortName','inputDiv_on')" 
                                         style="margin-top:-7px;width: 850px;display: <s:if test="%{examId>0}">block</s:if><s:else>none</s:else>;" 
                                         onmouseout="outText('#exam_shortName','inputDiv_on');"><s:if test="%{examId>0}"><c:out value="${exam.shortName}" escapeXml="false"/></s:if><s:else>&nbsp;</s:else></div>
                                </td>
                                <td>&nbsp;</td>
                            </tr>			
                            <tr>
                                <td align="right" height="25px" style="padding-left:8px;margin-top:1px"><div class="inputDiv">试题全称:</div></td>
                                <td  align="left" height="25px" >
                                    <div id="hint_name"  class="hintDiv"
                                                 onmouseover="overText('#hint_name','hintDiv_on')" 
                                                 onmouseout="outText('#hint_name','hintDiv_on')" 
                                                 onclick="hiddenHintAndShowInput('#hint_name','#exam_name','inputDiv_selected')" 
                                         style="margin-top:-5px;width: 850px;display: <s:if test="%{examId>0}">none</s:if><s:else>block</s:else>;">输入试题全名</div>
                                    <div contenteditable="true" 
                                          onmouseover="overText('#exam_name','inputDiv_on');" 
                                          onmouseout="outText('#exam_name','inputDiv_on');"
                                          onblur="saveExamProperty('#exam_name','name','#hint_name','inputDiv_selected')" 
                                          onclick="backupValueAndSetBg('#exam_name','inputDiv_on','inputDiv_selected');hideddrivetip()"
                                          class="inputDiv" 
                                          style="margin-top:-5px;width: 850px;display: <s:if test="%{examId>0}">block</s:if><s:else>none</s:else>;" 
                                          id="exam_name" ><s:if test="%{examId>0}"><c:out value="${exam.name}" escapeXml="false"/></s:if><s:else>&nbsp;</s:else></div>
                                </td>
                                <td>&nbsp;&nbsp; &nbsp;</td>
                            </tr>				
                        </table>
                    </div>	
                </div>
            </div>  
                
            <div id="topToolBar" style="border-right:1px solid #A4C9EE;border-bottom:1px solid #A4C9EE;border-left:1px solid #A4C9EE;margin-top:-1px">
                    <!-- This div will handle all toolbars -->
            </div>                
        </div>			
    </div>	
    <!-- 头部固定区域 结束 -->
    
    <!-- 中间可滚动区域 开始 -->
    <div class="vip mw">	
        <div class="boxcontent3 active"  id="basicInfo">
            <div id="questionList" style="margin-top:0px;" >
                <!-- 遍历问题 开始-->
                <s:iterator value="exam.questions" id="ques" status="status">
                    <div id="question_${ques.questionId}" class="quesDiv" name="question_${status.count}"
                         style="padding-left:10px; text-valign=top;padding-top:5px;width:970px;float:left;"
                         onmouseover="overText('#question_${ques.questionId}','quesDiv_on');
                                      overTextSelfAndChildren('#question_${ques.questionId}','#quesCont_${ques.questionId}','choiceCont_${ques.questionId}','inputDiv2_oo');
                                      showActionButtons(linkedList, '${ques.questionId}');" 
                         onmouseout="outText('#question_${ques.questionId}','quesDiv_on'); 
                                     outTextSelfAndChildren('#question_${ques.questionId}','#quesCont_${ques.questionId}','choiceCont_${ques.questionId}','inputDiv2_oo');
                                     hideActionButtons('${ques.questionId}');" 
                         onblur="outText('#question_${ques.questionId}','quesDiv_on');" >                              
                        
                        <div style="width:950px;float:left;">
                            <table width="100%" cellpadding="5px">
                                <tr>
                                    <td valign='top' width="2%" class="ques_num_td">
                                        <!-- 如果是备注-->
                                        <s:if test="%{#ques.questionType==5}">	
                                            &nbsp;
                                            <script type="text/javascript">
                                                linkedList.append('${ques.questionId}','${ques.orderIndex}');
                                            </script>                                            
                                        </s:if>
                                        <s:else>
                                            <b><span id="displayIndex_${ques.questionId}">
                                            <script type="text/javascript">
                                                displayIndex++;
                                                document.write(displayIndex);                                                
                                                linkedList.append('${ques.questionId}','${ques.orderIndex}',displayIndex);
                                            </script>        
                                            </span>.</b>
                                        </s:else>
                                    </td>
                                    <td colspan="2" >
                                        <div id="quesHint_${ques.questionId}"  class="hintDiv2" 
                                             onmouseover="overText('#quesHint_${ques.questionId}','hintDiv2_on')" 
                                             onmouseout="outText('#quesHint_${ques.questionId}','hintDiv2_on')" 
                                             onclick="hiddenHintAndShowInput('#quesHint_${ques.questionId}','#quesCont_${ques.questionId}','inputDiv2_selected')" 
                                             style="width: 890px;float:left"
                                        ><s:if test='%{#ques.isBlank}'>
                                                    ${ques.hint}
                                             </s:if><s:else>
                                                    <s:if test="%{#ques.questionType==5}">输入试题备注</s:if><s:else>输入题目内容</s:else>
                                             </s:else>
                                        </div>								 				
                                        <div contenteditable="true"
                                             style="width: 890px;float:left;"
                                             id="quesCont_${ques.questionId}" 
                                             class="inputDiv2" 
                                             onmouseover="overText('#quesCont_${ques.questionId}','inputDiv2_on');" 
                                             onmouseout="outText('#quesCont_${ques.questionId}','inputDiv2_on');" 
                                             title='<s:if test="%{#ques.questionType==5}">点击编辑试题备注</s:if><s:else>点击编辑题目</s:else>' 
                                             onblur="saveQuestionProperty('${ques.questionId}','content','inputDiv2_selected')" 
                                             onclick="backupValueAndSetBg('#quesCont_${ques.questionId}','inputDiv2_on','inputDiv2_selected')"						 				    	 
                                        ><c:out value="${ques.content}" escapeXml="false"/>
                                        </div>	
                                        <div id="delIcon_${ques.questionId}" class="deleteIcon" >
                                            <a href="#" onclick="deleteQuestion('${ques.questionId}');" title='<s:if test="%{#ques.questionType==5}">删除试题备注</s:if><s:else>删除题目</s:else>'>
                                                <img style="margin-left:10px" src="../images/icon_delete.png"
                                                     onmouseover="this.src='../images/icon_delete_on.png'"
                                                     onmouseout="this.src='../images/icon_delete.png'"/>
                                             </a>
                                        </div>							 				
                                    </td>
                                </tr>
                                
                                <!-- 单选题 or 多选题-->
                                <s:if test="%{#ques.questionType==1 || #ques.questionType==2 }">									 			
                                <s:iterator value="#ques.choices" id="chos" status="stas">
                                <tr id="choiceRow_${ques.questionId}_${chos.choiceId}"
                                        onmouseover="overText('#choiceCont_${ques.questionId}_${chos.choiceId}','inputDiv2_on');
                                                     overText('#choiceHint_${ques.questionId}_${chos.choiceId}','hintDiv2_on');
                                                     showDeleteIcon('#delIcon_${ques.questionId}_${chos.choiceId}');"
                                        onmouseout="outText('#choiceCont_${ques.questionId}_${chos.choiceId}','inputDiv2_on');
                                                    outText('#choiceHint_${ques.questionId}_${chos.choiceId}','hintDiv2_on');
                                                    hideDeleteIcon('#delIcon_${ques.questionId}_${chos.choiceId}');">
                                    <td width="2%" style="padding-top:6px;">&nbsp;&nbsp;</td>
                                    <td width="4%" valign="top" style="padding-top:6px;">
                                            <s:if test="%{#ques.questionType==1 }">	
                                                <input 
                                                 type="radio" 
                                                 id="choiceAnsw__${chos.choiceKey}"
                                                 name="choiceAnsw__${ques.questionId}"
                                                 onclick="saveSingleChoiceAnswer(${ques.questionId},${chos.choiceKey});" 
                                                 <s:if test="%{#chos.isCorrect}">checked</s:if> 
                                                 value=<s:property value='#chos.choiceKey'/>
                                                /> 
                                            </s:if>	
                                            <s:if test="%{#ques.questionType==2 }">	
                                                <input 
                                                        type="checkbox" 
                                                        id="choiceAnsw__${ques.questionId}_${chos.choiceKey}"
                                                        name="choiceAnsw__${ques.questionId}_${chos.choiceKey}"
                                                        onclick="saveMultiChoiceAnswer('choiceAnsw__${ques.questionId}','${ques.questionId}');" 
                                                        <s:if test="%{#chos.isCorrect}">checked</s:if> 
                                                        value='${chos.choiceKey}'
                                                />
                                            </s:if>														
                                            &nbsp;&nbsp;<s:property value="#stas.count" />.
                                    </td>
                                    <td align='left' width="94%">
                                        <div id="choiceHint_${ques.questionId}_${chos.choiceId}"  
                                             class="hintDiv2"
                                             onclick="hiddenHintAndShowInput('#choiceHint_${ques.questionId}_${chos.choiceId}',
                                                                             '#choiceCont_${ques.questionId}_${chos.choiceId}',
                                                                             'inputDiv2_selected')" 
                                             style="width: 850px;display: none;float:left;"
                                        ><s:if test='%{#ques.isBlank}'>
                                                ${chos.hint}
                                             </s:if><s:else>
                                                输入选项内容
                                             </s:else>
                                        </div>									 				
                                        <div  class='inputDiv2' 
                                              id="choiceCont_${ques.questionId}_${chos.choiceId}" 
                                              contenteditable="true"
                                              title="点击编辑答案" 
                                              style="float:left;width:850px;margin-top: 0 auto;"
                                              onblur="saveChoiceProperty('${ques.questionId}','${chos.choiceId}','choiceContent','inputDiv2_selected')" 
                                              onclick="backupValueAndSetBg('#choiceCont_${ques.questionId}_${chos.choiceId}','inputDiv2_on','inputDiv2_selected')"		
                                        ><c:out value="${chos.choiceContent}" escapeXml="false"/>
                                        </div>
                                        <div id="delIcon_${ques.questionId}_${chos.choiceId}" class="deleteIcon" >
                                            <a href="#" onclick="deleteChoice('${ques.questionId}','${chos.choiceId}');" title="删除答案">
                                                    <img style="margin-left:10px" src="../images/icon_delete.png"
                                                         onmouseover="this.src='../images/icon_delete_on.png'"
                                                         onmouseout="this.src='../images/icon_delete.png'"/>
                                             </a>
                                        </div>									 					
                                    </td>
                                </tr>						
                                </s:iterator>	
                                </s:if>	 	
                                        
                                <!-- 判断题 -->
                                <s:elseif test="%{#ques.questionType==3}">	
                                <tr>
                                    <td width="2%">&nbsp;&nbsp;</td>
                                    <td valign="top" style="padding-top:6px;" width="2%">
                                            <input 
                                                    type="radio" 
                                                    id='choice<s:property value='#status.count'/>' 
                                                    name=choice<s:property value='#status.count'/>  
                                                    <s:if test="%{#ques.correctAnswer==1}">checked</s:if> 
                                                    onclick="saveSingleChoiceAnswer(${ques.questionId},'1');"
                                                    value='1'/>
                                    </td>
                                    <td align='left' width="96%" height="25px"><div style="width:850px">正确</div></td>
                                </tr>			
                                <tr>
                                    <td width="2%">&nbsp;&nbsp;</td>
                                    <td valign='top' style="padding-top:3px;padding-bottom:3px;" width="2%">
                                        <input length="5px"
                                                type="radio" 
                                                id='choice<s:property value='#status.count'/>' 
                                                name=choice<s:property value='#status.count'/>  
                                                <s:if test="%{#ques.correctAnswer==0}">checked</s:if> 
                                                onclick="saveSingleChoiceAnswer(${ques.questionId},'0');"
                                                value='0'/>
                                    </td>
                                    <td align='left' width="96%" height="25px"><div style="width:850px">错误</div></td>
                                </tr>														
                                </s:elseif>	 					
                                
                                <!-- 问答题 -->
                                <s:elseif test="%{#ques.questionType==4}">
                                    <tr>
                                        <td width="2%">&nbsp;&nbsp;</td>
                                        <td colspan="2" width="98%" style="padding-bottom:6px">
                                            <div contenteditable="true" 
                                                 style="width:890px" 
                                                 id="correctAnswer_${ques.questionId}" 
                                             class="textareaDiv"
                                                 onmouseover="overText('#correctAnswer_${ques.questionId}','textareaDiv_on');" 
                                                 onmouseout="outText('#correctAnswer_${ques.questionId}','textareaDiv_on');"									 				    	 
                                                 onblur="saveEssayAnswer('${ques.questionId}', '#correctAnswer_${ques.questionId}','textareaDiv_selected','textareaDiv')" 
                                                 onclick="backupAnswerValueAndSetBg('#correctAnswer_${ques.questionId}','textareaDiv','textareaDiv_selected')"						 				    	 
                                            ><s:if test="#ques.correctAnswer.length()>0">
                                                    <s:property value="#ques.correctAnswer" />
                                                </s:if><s:else>
                                                    <font color=#cccccc>输入参考答案</font>
                                                </s:else>
                                            </div>		
                                        </td>
                                    </tr>													
                                </s:elseif>	
                                
                                    <!-- 每个问题底部的设置部分 包括标签,分数设置,添加选项,上移和下移等-->
                                    <tr>
                                        <td width="2%" height="20px" valign="bottom" style="padding-top:4px">&nbsp;&nbsp;</td>
                                        <td width="98%" colspan="2" align="right" style="padding-top:4px">
                                           <div class="tagContainerDiv"  >
                                                标签1
                                           </div>
                                           
                                           <div class="upDownIconDiv" id="upLinkDiv_${ques.questionId}" name="upLinkDiv_${ques.questionId}">                                                   
                                                <a href="#">
                                                    <span class="updown_link_button" id="uplink_${ques.questionId}"    
                                                          onclick="moveDivUp('${ques.questionId}');"
                                                          onmouseover="overText('#uplink_${ques.questionId}','updown_link_button_on');" 
                                                          onmouseout="outText('#uplink_${ques.questionId}','updown_link_button_on');"
                                                          >上移↑</span>
                                                 </a>     
                                                 
                                           </div>
                                           
                                           <div class="upDownIconDiv" id="downLinkDiv_${ques.questionId}" name="downLinkDiv_${ques.questionId}">                                                 
                                                 <a href="#">
                                                    <span class="updown_link_button" id="downlink_${ques.questionId}"
                                                          onclick="moveDivDown('${ques.questionId}');"
                                                          onmouseout="outText('#downlink_${ques.questionId}','updown_link_button_on');"
                                                          onmouseover="overText('#downlink_${ques.questionId}','updown_link_button_on');">下移↓</span>
                                                 </a>
                                           </div>     
                                           <s:if test="%{#status.count == exam.questions.size}">
                                              <script type="text/javascript">
                                                  exchangeDivById('downLinkDiv_${ques.questionId}','upLinkDiv_${ques.questionId}');
                                              </script>                                                      
                                           </s:if>                                           
                                        </td>                      
                                    </tr>
                                    
                                </table>
                             </div>	                                                                                                                        
                        </div>							
                    <div class="clear"></div>
                </s:iterator>
                <!-- 遍历问题 结束-->
                <div style="width:970px;height:25px;background-color:white;" ></div>
            </div>
        </div>
        <div class="boxcontent3 inactive" id="settingInfo">
        <div style="padding-left:10px">
            <iframe scrolling="no"  frameborder="0" height="370px" width="950px" src="${ctx}/exam/examsettings.action" id="settingframe"></iframe>
        </div>
        </div>
        <div class="boxcontent3 inactive"  id="shareInfo">
        <div style="padding-left:10px">
            <iframe scrolling="no"  frameborder="0" height="370px" width="950px" src="${ctx}/exam/examshare.action" id="settingframe"></iframe>
        </div>				   
        </div>
        <div class="boxcontent3 inactive" id="reviewInfo">
        <div style="padding-left:10px">
            <iframe scrolling="no"  frameborder="0" height="370px" width="950px" src="${ctx}/exam/examreview.action" id="settingframe"></iframe>
        </div>				  	
        </div>	
        <div class="boxcontent3 inactive" id="statisticsInfo">
        <div style="padding-left:10px">
            <iframe scrolling="no"  frameborder="0" height="370px" width="950px" src="${ctx}/exam/examsttcs.action" id="settingframe"></iframe>
        </div>				  	
        </div>	
    </div>
            <!-- 中间可滚动区域 结束 -->
            
    <div style="clear:both; display:block"></div>
                    
    <div id="tstart-toolbar-bottom">
        <div class="tstart-middle">
            <table width="100%" >
                <tr>
                     <td width=5px> &nbsp; </td>
                     <td align="center"><li class="addchoicebutton"><a href="#" onclick="addChoice();" />添加选择题</a></li></td>
                     <td align="center"><li class="addcheckboxbutton"><a href="#" onclick="addCheckbox();" />添加判断题</a></li></td>
                     <td align="center"><li class="addessaybutton"><a href="#" onclick="addEssay();" />添加问答题</a></li></td>
                     <td align="center"><li class="addnotebutton"><a href="#" onclick="addNote();" />添加备注</a></li></td>
                     <td align="center"><li class="saveclosebutton"><a href="#" onclick="window.opener.location.reload();window.opener=null;window.open('','_self');window.close();" >返回</a></li></td>
                 </tr>
             </table>		        	
        </div>
    </div>	

    <script type="text/javascript">
        // Turn off automatic editor creation first.
        CKEDITOR.disableAutoInline = true;

        var quesDivs = $("div[id^='quesCont_']");		
        var quesSize = $("div[id^='quesCont_']").length;
        var choiceDivs = $("div[id^='choiceCont_']");
        var choiceSize = $("div[id^='choiceCont_']").length;

        for(var i=0; i<quesSize; i++){
            var quesDivId = quesDivs[i].getAttribute('id');
            CKEDITOR.inline(quesDivId , {
                extraPlugins: 'sharedspace',
                removePlugins: 'floatingspace,resize',
                sharedSpaces: {
                    top: 'topToolBar'
                }
            });
        }
        
        for(var i=0; i<choiceSize; i++){
            CKEDITOR.inline( choiceDivs[i].getAttribute('id'), {
                extraPlugins: 'sharedspace',
                removePlugins: 'floatingspace,resize',
                sharedSpaces: {
                    top: 'topToolBar'
                }
            });
        }				
    </script>    
    <script src="../js/tooltip.js" type="text/javascript"></script>
</body>
</html>