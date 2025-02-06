$(function(){
    $('#fancy-input').keyup(function(){
        $('#questionList').highLight();
        if($(this).val() != '') {
                $('#questionList').highLight($(this).val());
        }
    });
    $('#link').toggle(function(event){
        $('#questionList').highLight();
        $('#questionList').highLight("mode");
        event.preventDefault();
    },function(event){
        $('#questionList').highLight();
        event.preventDefault();
    })    
});

function showRequest(){}

function showResponse(responseText, statusText, xhr, $form){	   
    $('#exam_shortName').attr("disabled","disabled");
    $('#exam_name').attr("disabled","disabled");
    $('#fisrtButton').hide();
    $('#addButton').show();
    
    var json = eval("(" + responseText + ")");
    if(json.examId){
        $('#hiddenExamId').attr("value",json.examId);
        addChoice(json.examId);
    }            
}



var tabDivIds = ['#basicInfo','#settingInfo','#shareInfo','#reviewInfo','#statisticsInfo'];
var tabDivLinkIds = ['#basicInfoLink','#settingInfoLink','#shareInfoLink','#reviewInfoLink','#statisticsInfoLink'];
function switchTab(tabIndex){
    if($(tabDivIds[tabIndex]).attr('class') == 'boxcontent3 active'){
        return;
    }else{
        $(tabDivIds[tabIndex]).attr('class','boxcontent3 active');
        if(0==tabIndex){
                $(tabDivLinkIds[tabIndex]).attr('style','margin-left:10px;border-bottom: 1px solid #FFFFFF;font-weight: bold;background:#FFF;');
        }else{
                $(tabDivLinkIds[tabIndex]).attr('style','border-bottom: 1px solid #FFFFFF;font-weight: bold;background:#FFF;');
        }                
    }
    for(var i=0; i<tabDivIds.length; i++){
         if(i!=tabIndex){
             if(i==0){
                     $(tabDivLinkIds[i]).attr('style','margin-left:10px;');
             }else{
                     $(tabDivLinkIds[i]).attr('style','');
             }
             $(tabDivIds[i]).attr('class','boxcontent3 inactive');                     
         }
    }
    
    if( tabIndex == 0){
        $('#baseInfoHeader').show();
        $('#tstart-toolbar-bottom').show();
        $('#vgap1').show();
        $('#vgap2').hide();
    }else{
        $('#baseInfoHeader').hide();
        $('#tstart-toolbar-bottom').hide();		
        $('#vgap1').hide();
        $('#vgap2').show();
    }
}

//鼠标移入提示是可以更改的状态，可以变背景色，也可以加形似输入框的样式
function overText(objId,className){
    $(objId).addClass(className);
}
function overTextSelfAndChildren(parentId,objId,childIdPrefix,className){
    $(objId).addClass(className);
        //alert($(parentId).find('div[id^='+childIdPrefix+']').size());
    $(parentId).find('div[id^='+childIdPrefix+']').addClass(className);
}	
//鼠标移出时，变为原来的样式
function outText(objId,className){
    $(objId).removeClass(className);
}	

function outTextSelfAndChildren(parentId,objId,childIdPrefix,className){
    $(objId).removeClass(className);
    $(parentId).find('div[id^='+childIdPrefix+']').removeClass(className);
}	

function backupValueAndSetBg(objId, c1, c2){
    var oldValue = $(objId).html();	
    oldValue = oldValue.replace('&nbsp;',' ');
    oldValue = $.trim(oldValue);
    $('#oldValueHolder').val(oldValue);
    
    $(objId).removeClass(c1);
    $(objId).addClass(c2);
}

function backupAnswerValueAndSetBg(objId, c1, c2){
    if($(objId).html().indexOf('输入参考答案') > 0 ){
            $(objId).html('');
    }
    
    backupValueAndSetBg(objId, c1, c2);
}

function hiddenHintAndShowInput(hintDivId, inputDivId, className){
    $(hintDivId).hide();
    overText(inputDivId,className);
    $(inputDivId).show();
    $(inputDivId).attr('contenteditable','true');
    $(inputDivId).focus();
}

//当鼠标焦点移出输入框时，保存值并更改到文本中
function saveExamProperty(objId, propertyName, hintDivId, className){
    var oldText = $('#oldValueHolder').val();
    var text = $(objId).html();
    text = text.replace('&nbsp;',' ');
    text = text.replace(/<[^>]+>/g,'');//去掉所有的html标记
    //text = text.replace('<br>','');
    text = $.trim(text);
    $(objId).html(text);
            
    if((oldText != text) && (text.length>0) ){//value has been changed
        var examId = $('#hiddenExamId').val();
        var reqData={examId: examId, propertyValue:text, propertyName:propertyName};
        ajaxUpdateSingleProperty('maintain!updateProperty.action',reqData);
    }
    
    if(text.length==0){
        $(hintDivId).show();
        $(objId).hide();
    }
    
    $(objId).removeClass(className);
}	


//当鼠标焦点移出输入框时，保存值并更改到文本中
function saveQuestionProperty(questionId, propertyName, className){
    var objId = '#quesCont_' + questionId;
    var hintDivId = '#quesHint_' + questionId;
    
    var oldText = $('#oldValueHolder').val();
    var text = $(objId).html();
    text = text.replace('&nbsp;',' ');
    //text = text.replace('<br>','');
    text = $.trim(text);
    
    if((oldText != text) && (text.length>0) ){//value has been changed
        var examId = $('#hiddenExamId').val();
        var reqData={examId: examId, questionId: questionId, propertyValue:text, propertyName:propertyName};
        ajaxUpdateSingleProperty('question!updateQuestionProperty.action',reqData);
    }
    
    var textAfterRemoveTag = text.replace(/<[^>]+>/g,'');//去掉所有的html标记
    textAfterRemoveTag = $.trim(textAfterRemoveTag);
    if(textAfterRemoveTag.length==0){
        $(hintDivId).show();
        $(objId).hide();
    }
    
    $(objId).removeClass(className);		
}	

//当鼠标焦点移出输入框时，保存值并更改到文本中
function saveChoiceProperty(questionId, choiceId, propertyName, className){
            var objId = '#choiceCont_' + questionId + '_' + choiceId;
            var hintDivId = '#choiceHint_' + questionId + '_' + choiceId;
    var oldText = $('#oldValueHolder').val();
    var text = $(objId).html();
    text = text.replace('&nbsp;',' ');
    text = text.replace('<br>','');
    text = $.trim(text);
                                            
    if((oldText != text) && (text.length>0) ){//value has been changed
        var reqData={questionId: questionId, choiceId: choiceId, propertyValue:text, propertyName:propertyName};
        ajaxUpdateSingleProperty('choice!updateChoiceProperty.action',reqData);
    }
    
    var textAfterRemoveTag = text.replace(/<[^>]+>/g,'');//去掉所有的html标记
    textAfterRemoveTag = $.trim(textAfterRemoveTag);
    if(textAfterRemoveTag.length==0){
            $(hintDivId).show();
            $(objId).hide();
    }
    
    $(objId).removeClass(className);
}	

function saveEssayAnswer(questionId, objId, c1, c2){
    var oldText = $('#oldValueHolder').val();
    var text = $(objId).html();
    text = text.replace('&nbsp;',' ');
    text = text.replace('<br>','');
    text = $.trim(text);
                                            
    if((oldText != text) && (text.length>0) ){//value has been changed
        var examId = $('#hiddenExamId').val();
        var reqData={examId: examId, questionId: questionId, propertyValue:text, propertyName:'correctAnswer'};
        ajaxUpdateSingleProperty('question!updateQuestionProperty.action',reqData);
    }
    
    if(text.length==0){
        $(objId).html("<font color='#cccccc'>输入参考答案</font>");
    }
    
    $(objId).removeClass(c1);
    $(objId).addClass(c2);
}

function saveSingleChoiceAnswer(questionId, choiceKey){
    var examId = $('#hiddenExamId').val();
    var reqData={examId: examId, questionId: questionId, propertyValue:choiceKey, propertyName:'correctAnswer'};
    ajaxUpdateSingleProperty('question!updateQuestionProperty.action',reqData);
}

function saveMultiChoiceAnswer(leadingId, questionId){
    var elements = $("input[id^=" + leadingId + "]");
    var answers = '';
    for(var i=0; i<elements.length; i++){
        if(elements[i].checked){
            if(i==(elements.length-1)){
                answers = answers + elements[i].value;
            }else{
                answers = answers + elements[i].value + ',';
            }
        }
    }    
    
    var examId = $('#hiddenExamId').val();
    var reqData={examId: examId, questionId: questionId, propertyValue:answers, propertyName:'correctAnswer'};
    ajaxUpdateSingleProperty('question!updateQuestionProperty.action',reqData);
}

function showDeleteIcon(divId){
    $(divId).show();
}
                
function hideDeleteIcon(divId){
    $(divId).hide();
}

function showActionButtons(linkedList, questionId){
    var button1 = '#delIcon_'+questionId;
    $(button1).show();
    
    var button2 = '#downLinkDiv_' +  questionId;    
    var button3 = '#upLinkDiv_' + questionId;
    
    var node = linkedList.getNodeByValue(questionId);
    if(node.preNode != null){//不是头节点
        $(button3).css('visibility','visible');
    }
    if(node.nextNode != null){//不是尾节点
        $(button2).css('visibility','visible');
    }
}
                
function hideActionButtons(questionId){
    var button1 = '#delIcon_'+questionId;
    var button2 = '#downLinkDiv_' +  questionId;    
    var button3 = '#upLinkDiv_' + questionId;
    $(button1).hide();
    $(button2).css('visibility','hidden');//要占着位置
    $(button3).css('visibility','hidden');//要占着位置
}

function exchangeDivByName(divName1, divName2){
    var div1 = $("div[name='"+divName1+"']");
    var div2 = $("div[name='"+divName2+"']");
    exchangeDiv(div1,div2);     
}

function exchangeDivById(id1, id2){
    var div1 = $('#'+id1);
    var div2 = $('#'+id2);
    exchangeDiv(div1,div2);  
}

function exchangeDiv(div1, div2){
    var tdiv1 = div1.clone();
    var tdiv2 = div2.clone();
    div1.replaceWith(tdiv2);
    div2.replaceWith(tdiv1);    
}

