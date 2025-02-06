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
function star_onmouse_over($objName,$index){    
    $obj=document.getElementsByName($objName);
    $count=$obj.length;
    var $i;
    for ($i=0;$i<$count;$i++ )
    {
        $obj[$i].className=$i<$index?"click_on":"no_click_on";    
    }
}

function star_onmouse_out($objName,$id){     
    $id = 'difficultLevel' + $id;
    $obj=document.getElementsByName($objName);
    $count=$obj.length;
    $star_val=document.getElementById($id).value;
    if($star_val==0){
        for ($i=0;$i<$count;$i++ )
        {
        $obj[$i].className="no_click_on";
        
        }
    }else{  
        star_onmouse_over($objName,$star_val);
    }
}

function star_onclick($objName,$id,$index){
 $obj=document.getElementsByName($objName);
 $obj_target = 'difficultLevel' + $id; 
 if($index==1){
     if(document.getElementById('firstDifficultLevel'+$id).value=='0'){
         $obj[0].className = 'click_on';
         document.getElementById('firstDifficultLevel'+$id).value = '1';
     }else{
        document.getElementById('firstDifficultLevel'+$id).value = '0';
        $index = 0;
        $obj[0].className = 'no_click_on';
     }
 }	 
 document.getElementById($obj_target).value=$index;
}



function setLinkStatus(index){
    var choiceRadios = document.getElementsByName('choice' + index);
    var answered = false;
    for ( var i = 0; i < choiceRadios.length; i++) {
            if (choiceRadios[i].checked) {
                    answered = true;
                    break;
            }
    }
    if(answered){
            document.getElementById('quesLink'+index).style.backgroundColor='#a4c9ee';
    }else{
            document.getElementById('quesLink'+index).style.backgroundColor='#ffffff';
    }
}

function setLinkColorBlue(id){
        document.getElementById(id).style.color='blue'; 
}

function setLinkColorRed(id){
        document.getElementById(id).style.color='red'; 
}	

function hiddenUncompletedInfo(index){
        hiddenDIV('uncompletedInfo'+index);
}
function showUncompletedInfo(index){
        showDIV('uncompletedInfo'+index);
}	
function hiddenDIV(divId){
        document.getElementById(divId).style.display='none'; 
}
function showDIV(divId){
        document.getElementById(divId).style.display='block'; 
}	

var timerText;
var timerValue=0;
function timedCount(){
        timerText = document.getElementById('timer_count');
        var m = getminute(timerValue);
    var s = getsecond(timerValue,m);
    timerText.innerHTML=m+":"+s;
    timerValue=timerValue+1;
    t=setTimeout("timedCount()",1000);	
        return false;
}
function getminute(c){
    var m = parseInt(c/60);
    m = checkTime(m);
    return m;
}
function getsecond(c,m){
    var s = c - m*60;
    s =checkTime(s);
    return s;
}
function checkTime(i){
    if (i<10) 
    {
        i = "0" + i;
    }
    return i
}

function hiddenAnswer(questionSize) {
    var selectnum = questionSize - 0;		
    for ( var i = 0; i < selectnum; i++) {
            var answerDiv = document.getElementById('correctAnswer'+ (i + 1));
            if(answerDiv){
                answerDiv.style.display = "none";
            }
    }
    hiddenDIV('hiddenCorrectAnswerDiv');
    showDIV('showCorrectAnswerDiv');
}

function showAnswer(questionSize){
    var selectnum = questionSize - 0;		
    for ( var i = 0; i < selectnum; i++) {
            var answerDiv = document.getElementById('correctAnswer'+ (i + 1));
            if(answerDiv){
                answerDiv.style.display = "block";
            }
    }
    showDIV('hiddenCorrectAnswerDiv');
    hiddenDIV('showCorrectAnswerDiv');
}

function doit(questionSize) {
    var score = 0;
    var selectnum = questionSize - 0;
    var unfinishedIdStr = "";
    for ( var j = 0; j < selectnum; j++) {
        var selectAnswer = "";			
        var choiceRadios = document.getElementsByName('choice' + (j + 1));
        var correctAnswer = document.getElementById('answer' + (j + 1)).value;
        var qusType = document.getElementById('qusType' + (j + 1)).value;
        
        //single select
        if(qusType == 1){
            var questionFinished = false;
            var isAnswerCorrect = false;
            for ( var i = 0; i < choiceRadios.length; i++) {
                    if (choiceRadios[i].checked) {
                            selectAnswer = choiceRadios[i].value;
                            questionFinished = true;
                            break;
                    }
            }
            
            if(correctAnswer == selectAnswer){
                    isAnswerCorrect = true;
            }
            
            if(!questionFinished){
                    unfinishedIdStr = unfinishedIdStr + (j+1) + ",";
            }else{
                    if(isAnswerCorrect){
                            score = score + 1;
                            //document.getElementById('questionContent' + (j + 1)).style.width='920px';
                            showDIV('correctReuslt'+(j+1));
                            //showDIV('addToHardList'+(j+1));
                            hiddenDIV('wrongResult'+(j+1));
                            setLinkColorBlue('quesLinkText'+(j+1));
                    }else{
                            //document.getElementById('questionContent' + (j + 1)).style.width='920px';
                            showDIV('wrongResult'+(j+1));
                            //hiddenDIV('addToHardList'+(j+1));
                            hiddenDIV('correctReuslt'+(j+1));
                            setLinkColorRed('quesLinkText'+(j+1));
                    }
            }
                        
        }
        
        //muti select
        if(qusType == 2){
            var isAnswerCorrect = true;
            var questionFinished = false;
            var correctAnswerArray = correctAnswer.split(",");
            for ( var i = 0; i < choiceRadios.length; i++) {
                if (choiceRadios[i].checked) {
                        selectAnswer = selectAnswer + choiceRadios[i].value + ",";
                        questionFinished = true;
                }
            }
            var selectAnswerArray = selectAnswer.split(",");
            if(selectAnswerArray.length == correctAnswerArray.length){
                for(var i=0;i<selectAnswerArray.length-1;i++){ 
                    var foundAnswer = false;
                    for(var k=0;k<correctAnswerArray.length;k++){ 
                        if(correctAnswerArray[k]==selectAnswerArray[i]){
                            foundAnswer = true;
                            break;
                        }
                    }
                    if(!foundAnswer){
                        isAnswerCorrect = false;
                        break;
                    }
                } 									

            }else{
                isAnswerCorrect = false;
            }
            
            if(!questionFinished){
                unfinishedIdStr = unfinishedIdStr + (j+1) + ",";
            }else{
                if(isAnswerCorrect){
                    score = score + 1;
                    //document.getElementById('questionContent' + (j + 1)).style.width='920px';
                    showDIV('correctReuslt'+(j+1));
                    hiddenDIV('wrongResult'+(j+1));
                    setLinkColorBlue('quesLinkText'+(j+1));
                }else{
                    //document.getElementById('questionContent' + (j + 1)).style.width='920px';
                    showDIV('wrongResult'+(j+1));
                    hiddenDIV('correctReuslt'+(j+1));
                    setLinkColorRed('quesLinkText'+(j+1));
                }
            }

        }    
    }
    
    //there is some question not finished
    if(unfinishedIdStr.length>0){	
        if(window.confirm('本次考试还有未答的题目，您确定现在要交卷吗?')){ 
                var unfinishedIdArray = unfinishedIdStr.split(",");
                window.location.hash = 'anchor'+unfinishedIdArray[0]; 
                for(var k=0; k<unfinishedIdArray.length-1;k++){
                        showUncompletedInfo(unfinishedIdArray[k]);
                }
                
                showDIV('redoDiv');
                showDIV('showCorrectAnswerDiv');
                hiddenDIV('submitDiv');
                
                //var button2 = document.getElementById('submit');
                //button2.style.border="";
                //button2.style.backgroundColor="";
                
                //alert("Your score is "+ score);		
                hiddenDIV('timer');
                document.getElementById('exam_score').innerHTML=score;
                showDIV('exam_result');
        }else{ 
                //do nothing
        } 	
    }else{
        showDIV('redoDiv');
        showDIV('showCorrectAnswerDiv');
        hiddenDIV('submitDiv');
        
        //alert("Your score is "+ score);		
        hiddenDIV('timer');
        document.getElementById('exam_score').innerHTML=score;
        showDIV('exam_result');
    }                
}