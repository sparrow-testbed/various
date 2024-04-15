<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>우리은행 전자구매시스템</title>

<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<!-- JSP내용 추가 start _____________________________________________________________________________________________ -->
<!-- ______________________________________________________________________________________________________________ -->
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<style type='text/css'>
/* div{
	border:1px solid red;
	margin:1 1 1 1;
} */
/* li, ul{
	border:1px solid green;
	margin:1 1 1 1;
} */
</style>
<Script type='text/javascript'>
$(document).ready(function(){
	$('#btnSearch').click(function(){
		alert("조회");
	});
	$('#btnNew').click(function(){
		alert("신규");
	});
	$('#btnSave').click(function(){
		alert("저장");
	});
});
</Script>
</head>
<body>
<s:header>

<!--타이틀시작--> 
<div id="title">
  <h3>테스트</h3>
  <div class="location">테스트 &gt; <span>가나다</span></div>
</div>
<a href='#' onclick='divTest();'>divTestAB</a>
<script>
function divTest(){
	$.ajax({
		type:"POST",
		url:"../sample/multi_language_sample2.jsp",
		dataType:"html",
		//data:"id="+id,
		success:function(result){	
			var wrap_cont = document.getElementById("wrap_cont");
			wrap_cont.innerHTML = result;
			alert(result);
		},
		error:function(x,y,z){	
			// alert("error="+x+","+y+","+z);
			alert("처리중 오류가 발생하였습니다.");
		}
	}); 
}
</script>
<!--//타이틀끝--> 

<!--내용시작-->
<div class="wrap_cont" id="wrap_cont">

  <!-- 버튼영역 -->
  <div class="btn_area">
    <p class="pad_bottom10 floatR">
        <a class="btn_big" href="#" id="btnSearch"><span>조회</span></a> 
        <a class="btn_big" href="#" id="btnNew"><span>신규</span></a> 
        <a class="btn_big" href="#" id="btnSave"><span>저장</span></a>
    </p>
  </div>

  <!-- 버튼영역 -->
  
  <!--게시물검색 시작-->
  <!--게시물검색 끝-->
main.jsp
</br>
</br>
<%
	if("S".equals(info.getSession("USER_TYPE"))){ //공급사일경우
%>
		
		<h2>견적관리</h2>
		<br />
		<ol>
		<li><a href='/s_kr/bidding/rfq/rfq_bd_lis1.jsp'>견적요청접수현황</a></li>
		<li><a href='/s_kr/bidding/qta/qta_bd_lis1.jsp'>견적진행현황</a></li>
		<li><a href='/s_kr/bidding/qta/qta_bd_lis2.jsp'>견적진행결과</a></li>
		</ol>
		<br />
		<br />
		<br />
		
		
		<h2>역경매관리</h2><br />
		<ol>
		<li><a href='/s_kr/bidding/rat/rat_bd_lis1.jsp'>공급사 - 역경매현황</a></li>
		<li><a href='/s_kr/bidding/rat/rat_bd_lis2.jsp'>공급사 - 역경매결과</a></li>
		</ol>	
<%		
	}else{
%>
		<a href='../procure/po_list.jsp'>po_list.jsp</a>
		</br>
		<a href='../procure/po_list1.html'>po_list1.html</a>
		</br>
<%		
	}
%>

</div>

  <!-- Body End--> 
  <!-- Footer Start-->
</s:header>
<s:footer/>
  <!-- Footer End--> 
</body>

</html>