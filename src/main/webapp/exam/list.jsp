<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>考试100</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta>
	<script src="../js/jquery-1.9.1.js"></script>
	<script src="../js/jquery.form.min.js"></script>    
    <link href="../css/style.css" type="text/css" rel="Stylesheet"/>
    <link href="../css/popup.css" type="text/css" rel="Stylesheet" />
    <script type="text/javascript">
		function deleteExam(examId){
			$("#exam_tr_"+examId).remove();  
			
	        $.ajax({
	    	    type: 'POST',
	    		url: "${ctx}/exam/maintain!delete.action",
	    		data: {examId: examId}
	    	});
		}
    </script>	
  </head>
  <body>
  	<jsp:include page="../common/header.jsp" />
      
      <div class="vip mw">
        <div class="leftmo">
          <div class="leftmob">
            <ul class="leftmenu mypngbg">
              <li class="menuhome ">
                <a href="${ctx}/exam/index.action">首页</a>
              </li>
               
              <li class="menucourse on">
                <a href="#">我的题库</a>
              </li>
               
              <li class="menulist ">
                <a href="/list/">我的帐户</a>
              </li>
               
              <li class="menuwrong ">
                <a href="/wrong/">我的错题</a>
              </li>
               
              <li class="menuscores ">
                <a href="/scores/">历史成绩</a>
              </li>
               
              <li class="mobile">
                <a href="http://m.jxedt.com/about/" target="_blank">手机版</a>
              </li>
            </ul>
          </div>
        </div>
        <div class="right">
          <div style="DISPLAY: none; BACKGROUND: #fff; HEIGHT: 0px; OVERFLOW: hidden" id="vipmessage">
            <div class="mytoolstips">
              <div class="clear"></div>
            </div>
          </div>

          
          <div class="boxcontent2">
            <div class="titleinner">
            	<table border=0 cellspacing=0 cellpadding=0 width="700px">
            		<tr>
            			<td width=90% >我创建的试题 </td>
            			<td width=10%><a href="${ctx}/exam/maintain.action?examId=-1" target="_blank"><span class="rbtn_title"><b>创建新试题</b></span></a> </td>
            		</tr>
            	</table>
            
            </div>
            <div class="clear"></div>
			<div class="headerContent1">
						<table border=0 cellspacing=0 cellpadding=0 width=100%>

							<s:if test="%{examList.size == 0}">
								<tr><td>暂无记录</td></tr>
							</s:if>								
							
							<s:iterator value="examList" id="exa">
				                <tr id="exam_tr_${examId}">
				                	<td width=80%>				                
				                	    <a   href="#"
				                     			target="_blank">${shortName} - ${name}&nbsp;</a>   
				                     </td><td width=10%>
				                			&nbsp;<a href="${ctx}/exam/maintain.action?examId=${examId}" target="_blank"><span class="rbtn">管理试题</span></a>  
				                	</td><td width=10%>
				                			&nbsp;<a href="#" onclick="deleteExam(${examId});"><span class="rbtn">删除试题</span></a>  
				                	</td>
				                </tr>								
							</s:iterator>
							
							</table>
                 
						</div>                                
          </div>
          
             <div class="boxcontent2">
            <div class="titleinner">我收藏的试题           
            </div>
            <div class="clear"></div>
			<div class="headerContent1">
			             	<table border=0 cellspacing=0 cellpadding=0 width=100%>           	
			             								
										
								<s:if test="%{favoriteList.size == 0}">
									<tr><td>暂无记录</td></tr>
								</s:if>					
								
			                 	<s:iterator value="favoriteList" id="fav">
							        <tr>
							         <td width=80%>	
			                	    <a   href="#"
			                     			target="_blank">${exam.shortName} - ${exam.name}&nbsp;</a>   
			                		</td>       
			                		<td width=10%>
			                			&nbsp;<a  href="${ctx}/exam/exam.action?examId=${exam.examId}" target="_blank"><span class="rbtn">开始考试</span></a>
			                			</td>
			    
			                		<td width=10%>
			                			&nbsp;<a  href="#" target="_blank"><span class="rbtn">删除记录</span></a>
			    
			                		</td>     
			                      </tr>
			                      
								</s:iterator>      
			                
			                	</table> 
                 
						</div>                                
          </div>
          
					
          
          </div>
          
          <jsp:include page="../common/bottom.jsp" />

    </div>
  </body>
</html>