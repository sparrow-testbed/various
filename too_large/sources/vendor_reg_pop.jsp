<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SU_102");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SU_102";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	

%>
<!-- 사용 언어 설정 -->
<% String WISEHUB_PROCESS_ID="SU_102";%>
<%
	//String to_date   = SepoaDate.getShortDateString();
	//String from_date = SepoaDate.addSepoaDateDay(to_date,-150);
	
	String status 		     = JSPUtil.nullToEmpty(request.getParameter("status"));
	String vendor_code 	     = JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
	String sg_refitem 	     = JSPUtil.nullToEmpty(request.getParameter("sg_refitem"));	
	String vendor_sg_refitem = JSPUtil.nullToEmpty(request.getParameter("vendor_sg_refitem"));	
	String EDIT_FLAG 	     = JSPUtil.nullToEmpty(request.getParameter("EDIT_FLAG"));

	/* String ret = null;
	SepoaFormater wf = null;
	SepoaRemote ws = null;
	String nickName= "p0070";
	String conType = "CONNECTION"; */

	//String MethodName = "getVendorInfo";
	
	
	Object[] obj = { vendor_code, sg_refitem };
	SepoaOut value = ServiceConnector.doService(info, "p0070", "CONNECTION", "getVendorInfo", obj);
	SepoaFormater wf = new SepoaFormater(value.result[0]);

	String creditGrade 		= "";
	String fromdate 		= "";
	String todate 			= "";
	String recommender 		= "";
	String recom_reason 	= "";
	String recommender_id 	= "";
	String CASH_GRADE 		= "";
	String APPROVAL_REASON	= "";
	String ATTACH_NO		= "";
	String ATTACH_CNT		= "0";
	String REJECT_DATE		= "";
	String REJECT_REASON	= "";
	String SCREENING_STATUS	= "";
	String CHECKLIST_STATUS	= "";
	String REGISTRY_FLAG	= ""; // 'Y':등록 , 'R':반려
	String APP_STATUS       = ""; //결재상태
	String SIGN_APP_STATUS  = ""; //결재상태
	 	
	if(wf.getRowCount() > 0) {
		creditGrade		= wf.getValue("CREDIT_GRADE"		, 0);
		fromdate 		= wf.getValue("CHECK_START_DATE"	, 0);
		todate 			= wf.getValue("CHECK_END_DATE"		, 0);
		recommender 	= wf.getValue("USER_NAME_LOC"		, 0);
		recom_reason	= wf.getValue("RECOMMEND_REASON"	, 0);
		recommender_id 	= wf.getValue("RECOMMENDER"			, 0);
		CASH_GRADE 		= wf.getValue("CASH_GRADE"			, 0);		
		APPROVAL_REASON	= wf.getValue("APPROVAL_REASON"		, 0);
		ATTACH_NO		= wf.getValue("ATTACH_NO"			, 0);
		ATTACH_CNT		= wf.getValue("ATTACH_CNT"			, 0);
		REJECT_DATE		= wf.getValue("REJECT_DATE"			, 0);
		REJECT_REASON	= wf.getValue("REJECT_REASON"		, 0);
		SCREENING_STATUS= wf.getValue("SCREENING_STATUS"	, 0);
		CHECKLIST_STATUS= wf.getValue("CHECKLIST_STATUS"	, 0);
		REGISTRY_FLAG	= wf.getValue("REGISTRY_FLAG"		, 0);
		APP_STATUS      = wf.getValue("STATUS"				, 0);
		SIGN_APP_STATUS = wf.getValue("SIGN_STATUS"			, 0);
	} 

%>

<%
	/* SepoaFormater wf1 = null;
	SepoaOut value1 = null;
	SepoaRemote ws1 = null;
	String nickName1 = "p0070";
	String conType1 = "CONNECTION";

	String MethodName1 = "getJobStatus"; */
	
	Object[] obj1 = { vendor_code };
	SepoaOut value1 = ServiceConnector.doService(info, "p0070", "CONNECTION", "getJobStatus", obj1);
	SepoaFormater wf1 = new SepoaFormater(value1.result[0]);


	/* try {
		ws1 = new SepoaRemote(nickName1, conType1, info);
		value1 = ws1.lookup(MethodName1,obj1);
		wf1 =  new SepoaFormater(value1.result[0]);
	}catch(SepoaServiceException wse) {
		Logger.debug.println(info.getSession("ID"),request,"message = " + value1.message);
		Logger.debug.println(info.getSession("ID"),request,"status = " + value1.status);
	}catch(Exception e) {
	    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	    e.printStackTrace();
	}finally{
		try{
			ws1.Release();
		}catch(Exception e){}
	} */
		
	String job_status = "";
	
	if(wf1.getRowCount() > 0) {
		job_status 	= wf1.getValue("JOB_STATUS", 0);
	}
	
	
	/* int count 	= -1;
	String eval_score = "";
	nickName= "s6006";
	conType = "CONNECTION";
	MethodName = "getEvalScore"; */
	String eval_score = "";
	Object[] obj2 = {vendor_code, sg_refitem};
	SepoaOut value2 = ServiceConnector.doService(info, "s6006", "CONNECTION", "getEvalScore", obj2);
	SepoaFormater wf2 = new SepoaFormater(value2.result[0]);
	
	if(wf2.getRowCount() > 0) {
		eval_score = wf2.getValue("EVAL_SCORE",0);
	}
	
	
	/* try {
		ws1 = new SepoaRemote(nickName, conType, info);
	    value = ws1.lookup(MethodName, param);

	    if(value.status == 1) {
	      wf = new SepoaFormater(value.result[0]);
	      eval_score = wf.getValue("EVAL_SCORE",0);
	    }
	}catch(SepoaServiceException wse) {
		    Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
		    Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
		    Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	}catch(Exception e) {
		    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
		    e.printStackTrace();
	}finally{
		    try{
		    	ws1.Release();
		    } catch(Exception e){}
	} */
	
	
%>



<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<%@ include file="/include/include_css.jsp"%>
	<%-- Dhtmlx SepoaGrid용 JSP--%>
	<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
	<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
	<%-- Ajax SelectBox용 JSP--%>
	<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
	
	<script language="javascript">
	<!--

	/*  SetCookie("EK", "MjMwMTE");
	 SetCookie("NK", "MzU5NDc");
	 SetCookie("EID","WJT"); */
	 
	 var functionName = "";
	 function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}

	function setProgress(status) {		//실사통보
		var msg;
		if(status == "2") {
			var chk = confirm('신용평가 요청을 하시겠습니까?');
			if(chk){
				hiddenframe.location.href="vendor_reg_ins.jsp?vendor_code=<%=vendor_code%>&sg_refitem=<%=sg_refitem%>&status="+status;
			}
		}else if(status == "3") {
			f = document.form1;
			var value = confirm("신용평가를 완료하시겠습니까?");
			if(f.creditGrade.value == "") {
				alert("신용등급을 입력해주세요.");
				f.creditGrade.focus();
				return;
			}
			if(value) {
				
				f.mode.value = "";
				f.status.value = status;
				f.target="hiddenframe";
				f.action = "vendor_reg_ins.jsp";
				f.submit();
			}
		}else if(status == "4") {

			f = document.form1;

/*
			if(f.creditGrade.value == "") {
				alert("신용등급을 확인후에 입력해주세요.");
				f.creditGrade.focus();
				return;
			}
*/
			if(f.fromdate.value == "" || f.todate.value == "") {
				alert("실사일을 입력해주세요.");
				return;
			}
			
			if(f.fromdate.value < eval("<%=SepoaDate.getShortDateString()%>"))
			{
			  alert("실사시작일은 오늘 이후여야 합니다.");
			  return ;
			}
			
			if(f.fromdate.value > f.todate.value)
			{
			  alert("실사종료일은 실사시작일 이후여야 합니다.");
			  return ;
			}

			
			var chk = confirm('실사통보요청을 하시겠습니까?');
			if(chk){
				///functionName = "end_setProgress('" + status+ "')";
				//document.attachFrame.setData();	//startUpload
				
				end_setProgress(status);
			}
		}

	}
	
	// 신용평가, 실사통보
	function end_setProgress(status) {
		f = document.form1;
		f.mode.value = "";
		f.status.value = status;
		f.target="hiddenframe";
		f.action = "vendor_reg_ins.jsp";
		f.submit();
	}

	<%if(status.equals("2")) {%>
	function getCredit(){
		MM_openBrWindow('about:blank','subpop','width=716,height=400,left=40,top=20,resizable=yes');
		GotoUrl('https://www.ecredit.co.kr/embedded/pri/p_index.asp?bizno=<%=vendor_code%>&EID=WJT','subpop');
	}
	<%}%>

	function doSave(){
		f = document.form1;
/*
		if(f.creditGrade.value == "") {
			alert("신용등급을 확인후에 저장해주세요.");
			f.creditGrade.focus();
			return;
		}
*/
		//if(f.fromdate.value == "" || f.todate.value == "") {
		//	alert("실사일을 입력해주세요.");
		//	return;
		//}
		
		var chk = confirm('저장하시겠습니까?');
		if(chk){
			//functionName = "end_doSave()";
			//document.attachFrame.setData();	//startUpload
			end_doSave();
			
			/*
			f.mode.value = "save";
			f.target="hiddenframe";
			f.action = "vendor_reg_ins.jsp";
			f.submit();
			*/
		}

	}
	
	function end_doSave(){			//저장
		f = document.form1;
		f.mode.value = "doSave";
		f.target="hiddenframe";
		f.action = "vendor_reg_ins.jsp";
		f.submit();
	}
	
	function doRegister(flag){
		/*
		SCREENING_STATUS : P(통과), F(탈락)
		CHECKLIST_STATUS : P(통과), F(탈락)
			scereening통과	checklist(실사완료)		  등록			  반려
			
				O				O					바로승인		반려사유
				O				X					승인사유		반려사유
				X				O					승인사유		반려사유
				X				X					승인사유		반려사유			
		
		*/
		
		var msg_text ="";
		if(flag == "P"){		//결재요청
			msg_text = "결재하시겠습니까?";
		}else if(flag=="Y"){
			msg_text = "저장하시겠습니까?";
		}else{
			msg_text = "반려하시겠습니까?";
		}
		
		var SCREENING_STATUS = "<%=SCREENING_STATUS%>";
		var CHECKLIST_STATUS = "<%=CHECKLIST_STATUS%>";
		
		f = document.form1;
		var msg;
		if(flag =="Y") 
			msg = "등록";
		else
			msg = "반려";
		
		if(flag =="Y" || flag == "P"){
			if(!(SCREENING_STATUS == "P" && CHECKLIST_STATUS == "P")){	// 스크린닝, 실사 둘다 통과하지 못한경우			
				if(f.approval_reason.value == ""){
					alert("등록사유를 입력하여주세요.");
					f.approval_reason.focus();
					return;
				}
			}
		}
		
		
/*		
		if(f.creditGrade.value == "") {
			alert("신용등급을 확인후에 입력해주세요.");
			f.creditGrade.focus();
			return;
		}

		if(f.fromdate.value == "" || f.todate.value == "") {
			alert("실사일을 입력해주세요.");
			return;
		}
*/		
		if(flag == 'P'){ // 결재
			
			var sepoa = GridObj;
			var f = document.forms[0];
		
	    	if(!confirm(msg_text)){return;}
			approvalSign();
			
		}else if(flag == 'Y'){
			var chk = confirm(msg_text);
			if(!chk) {
				return;
			}
			
			
			//functionName = "end_doRegister('" + flag+ "')";
			//document.attachFrame.setData();	//startUpload
							
			f.mode.value = "register";
			f.flag.value = flag;
		
			f.target="hiddenframe";
			f.action = "vendor_reg_ins.jsp";
			f.submit();
			
		}else {		//반려 return setREJECT_REASON(); 'R'
			var url = "/kr/master/register/vendor_rej_pop.jsp?";
			var left = 150;
			var top = 150;
			var width = 600;
			var height = 300;
			var toolbar = 'no';
			var menubar = 'no';
			var status = 'yes';
			var scrollbars = 'yes';
			var resizable = 'no';
			var Win = window.open( url, 'REJECT_REASON', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
			Win.focus();
			return;
		}
	}
	
	function approvalSign(){	//결재요청
		
		hiddenframe.location.href='/kr/admin/basic/approval/approval.jsp?house_code=<%=info.getSession("HOUSE_CODE")%>&company_code=<%=info.getSession("COMPANY_CODE")%>&dept_code=<%=info.getSession("DEPARTMENT")%>&req_user_id=<%=info.getSession("ID")%>&doc_type=VM&fnc_name=getApproval';
	}
	
	function getApproval(str){
		
		//if(!confirm("결재하시겠습니까?")) return;
		
		if(str == '') return;

	    var sign_flag = "";
	    var flag = "";
	    saveRock = true;
		    
	    sign_flag = "P";   // 결재중(결재상신)
	    flag = "N";
	    document.forms[0].sign_flag.value	= sign_flag			;
	    document.forms[0].approval.value	= str				;
		
		//functionName = "approval_doRegister('" + str+ "','" + flag+ "')";
		functionName = "approval_doRegister('','" + flag+ "')";
		//document.attachFrame.setData();	//startUpload
		
		approval_doRegister('',flag);
	} 

	function approval_doRegister(str, flag){
		f = document.form1;
		f.mode.value = "approval";
		f.flag.value = flag;
		f.target="hiddenframe";
		f.action = "vendor_reg_ins.jsp";
		f.submit();
	}
	
	function end_doRegister(flag){
		f = document.form1;
		f.mode.value = "register";
		f.flag.value = flag;
		
		f.target="hiddenframe";
		f.action = "vendor_reg_ins.jsp";
		f.submit();
		
	}
	
	function goRef(){
		//opener.onRefresh();
		opener.doSelect();
		window.close();
	}

	function searchRecom() {
		var left = 0;
		var top = 0;
		var width = 520;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "vendor_recom_pop.jsp";
		var win = window.open( url, 'win', 'left=250, top=250, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function s_select(user_id, user_name) {
		f = document.form1;
		f.recommender_id.value = user_id;
		f.recommender.value = user_name;

	}
	
	function from_date(year,month,day,week) {
   		document.form1.fromdate.value=year+month+day;
	}

	function to_date(year,month,day,week) {
   		document.form1.todate.value=year+month+day;
	}

	function addAttach(){
		alert("준비중입니다.");
		return;
	}
	/* 반려 */
	function setREJECT_REASON(reject_reason){		
		document.form1.reject_reason.value = reject_reason;
		
		end_doRegister('R');
		
		
		//functionName = "end_doRegister('R')";
		
		//document.attachFrame.setData();	//startUpload
		/*
		f.mode.value = "register";
		f.flag.value = 'R';		
		f.target="hiddenframe";
		f.action = "vendor_reg_ins.jsp";
		f.submit();
		*/					
	}
	-->
	</script>


	

	


<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
	
    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    
    return false;
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj)
{
    var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode");
    var status   = obj.getAttribute("status");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }

    if(status == "true") {
        alert(messsage);
        doQuery();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    } 

    return false;
}

// 엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
// 복사한 데이터가 그리드에 Load 됩니다.
// !!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function doExcelUpload() {
    var bufferData = window.clipboardData.getData("Text");
    if(bufferData.length > 0) {
        GridObj.clearAll();
        GridObj.setCSVDelimiter("\t");
        GridObj.loadCSVString(bufferData);
    }
    return;
}

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}



/* 파일 업로드 */
function goAttach(attach_no){
	attach_file(attach_no,"TEMP");
}

function setAttach(attach_key, arrAttrach, rowId, attach_count) {
	document.form1.attach_no.value = attach_key;
	document.form1.attach_no_count.value = attach_count;
}

//첨부파일 로드
function fileLoad() {
	//첨부파일을 등록한 경우 해당 파일을 조회하도록 처리
	document.form1.attach_no.value = '<%=ATTACH_NO%>';
	document.form1.attach_no_count.value = '<%=ATTACH_CNT%>';
}

</script>
</head>
<BODY TOPMARGIN="0"  LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" BGCOLOR="#FFFFFF" TEXT="#000000" onload="fileLoad()">

<s:header popup="true"> 
<!--내용시작-->

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="20" align="left" class="title_page" vAlign="bottom">
		등록사유
	</td>
</tr>
</table> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="15"></td>
</tr>
</table>

<!-- 	<div id="frame1"> -->
<%-- 	<iframe src="vendor_reg_pop_frame.jsp?vendor_code=<%=vendor_code%>&sg_refitem=<%=sg_refitem%>" width="660" height="250" frameborder="0"></iframe> --%>
<!-- 	</div> -->

<!-- 	<br> -->

<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">	
		<form name="form1" method="post">
		<input type="hidden" name="vendor_code"     id="vendor_code"        value="<%=vendor_code%>">
		<input type="hidden" name="sg_refitem"      id="sg_refitem"         value="<%=sg_refitem%>">
		<input type="hidden" name="status"          id="status"             >
		<input type="hidden" name="mode"            id="mode"               >
		<input type="hidden" name="flag"            id="flag"               >
		<input type="hidden" name="recommender_id"  id="recommender_id"     value="<%=recommender_id%>">
		<input type="hidden" name="sign_flag"       id="sign_flag"          value="">
		<input type="hidden" name="approval"        id="approval"           value="">
		<input type="hidden" name="ctrl_code"       id="ctrl_code"          value="">
		<textarea            name="reject_reason"   id="reject_reason"      style="display:none;"><%=REJECT_REASON%></textarea>
		<tr style="display: none;">
			<td width="18%" class="title_td">
				<div align="left"> 평가점수</div>
			</td>
			<td class="data_td" colspan="3">
				<%=eval_score%>
			</td>			
		</tr>
		<tr style="display: none;">
			<td width="18%" class="title_td">
				<div align="left"> 신용평가등급</div>
			</td>
			<td class="data_td">
				<input name="credit_grade" id="credit_grade" type="text" value="<%=creditGrade%>" class="input_data2" size="20" readOnly>
			</td>
			<td width="18%" class="title_td">
				<div align="left"> 현금흐름등급</div>
			</td>
			<td class="data_td">
				<input name="cash_grade" id="cash_grade" type="text" value="<%=CASH_GRADE%>" class="input_data2" size="20" readOnly>
			</td>
		</tr>

<!-- 		<tr> -->
<!-- 			<td class="title_td"> -->
<!-- 				<div align="left"> 실사일정</div> -->
<!-- 			</td> -->
<!-- 			<td class="data_td" colspan="3"> -->
<%-- 			      <input name="fromdate" type="text" value="<%=fromdate%>" 	class="inputsubmit" size="8" maxlength="8" style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]');">
<%-- 			      <a href="javascript:Calendar_Open('from_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> --%>
<%-- 			      <input name="todate" type="text" value="<%=todate%>" 		class="inputsubmit" size="8" maxlength="8" style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]');"> --%>
<%-- 			      <a href="javascript:Calendar_Open('to_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> --%> 
<%-- 			      <s:calendar id="fromdate" default_value="" format="%Y/%m/%d"/> --%>
<!-- 				~ -->
<%-- 				<s:calendar id="todate" default_value="" format="%Y/%m/%d"/> --%>
<!-- 			</td> -->
<!-- 		</tr> -->

		<tr style="display: none;">		
			<td class="title_td">
				<div align="left"> 추천인</div>
			</td>
			<td class="data_td" colspan="3">
			<input name="recommender" id="recommender" type="text" value="<%=recommender%>" class="inputsubmit" style="width:70" readOnly>
			<a href="javascript:searchRecom();"><img src="/images/button/bt_search.gif" border="0" align="absmiddle"></a>
			</td>
		</tr>

		<tr style="display: none;">
			<td class="title_td">
				<div align="left"> 추천사유</div>
			</td>
		
			<td class="data_td" colspan="3">
			<textarea name="recom_reason" id="recom_reason"  cols="50%" rows="3" class="inputsubmit" style="width:98%" onKeyUp="return chkMaxByte(500, this, '추천사유');"><%=recom_reason%></textarea>
			</td>
		</tr>

		<tr>
			<td class="title_td">
				<div align="left"> 등록사유</div>
			</td>
		
			<td class="data_td" colspan="3">
			<textarea name="approval_reason"  id="approval_reason"  cols="50%" rows="3" class="inputsubmit" style="width:98%" onKeyUp="return chkMaxByte(500, this, '등록사유');"><%=APPROVAL_REASON%></textarea>
			</td>
		</tr>
		
		<tr>
			<td class="title_td"> 첨부파일</td>
			<td class="data_td" colspan="3" height="20">
				<table>
					<tr>
						<td>
							<script language="javascript">btn("javascript:goAttach(document.getElementById('attach_no').value);", "파일등록");</script>
						</td>
						<td>
							<input type="text" size="3" class="input_empty" value="<%=ATTACH_CNT%>" name="attach_no_count" id="attach_no_count" readOnly />
							<input type="hidden" value="" name="attach_no" id="attach_no" value="<%=ATTACH_NO%>">
								<!-- <iframe name="attachFrame" id="attachFrame" width="100%" height="20" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe> -->
						</td>
					</tr>
				</table>
			
			
			</td>
		</tr>
  </table> 
</td>
</tr>
</table>
</td>
</tr>
</table>
	
	
	
	
	<br>

	<table border=0 cellpadding=0 cellspacing=0 width="99%">

			<tr class="bgline2">
				<td colspan=2><img src="../../../images//emro/blank.gif" width="1" height="1"></td>
			</tr>
	</table>

<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
<TR>
	<TD height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
<%
		if(status.equals("1")) {
%>
			<%--
			<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/btn_left.gif" width="10" height="25" /></TD>
			<TD background="/images/<%=info.getSession("HOUSE_CODE")%>/btn_bg.gif" class="btn" height="25"><a href="javascript:setProgress('2');" class="btn">신용평가요청</a></TD>
			<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>//btn_right.gif" width="10" height="25" /></TD>
			--%>
<%
		}else if(status.equals("2")) {
%>
			<%--
			<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/btn_left.gif" width="10" height="25" /></TD>
			<TD background="/images/<%=info.getSession("HOUSE_CODE")%>/btn_bg.gif" class="btn" height="25"><a href="javascript:getCredit();" class="btn">신용평가조회</a></TD>
			<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>//btn_right.gif" width="10" height="25" /></TD>
			<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/btn_left.gif" width="10" height="25" /></TD>
			<TD background="/images/<%=info.getSession("HOUSE_CODE")%>/btn_bg.gif" class="btn" height="25"><a href="javascript:setProgress('3');" class="btn">신용평가완료</a></TD>
			<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>//btn_right.gif" width="10" height="25" /></TD>
			--%>
<%
		}
%>

 
<%
System.out.println("@@@@@ REGISTRY_FLAG : " + REGISTRY_FLAG);
System.out.println("@@@@@ EDIT_FLAG : " + EDIT_FLAG);
System.out.println("@@@@@ SIGN_APP_STATUS : " + SIGN_APP_STATUS);
System.out.println("@@@@@ job_status : " + job_status);
%>


<%
        if(!"R".equals(REGISTRY_FLAG) && !"N".equals(EDIT_FLAG) && !"R".equals(SIGN_APP_STATUS)  && !"P".equals(SIGN_APP_STATUS)){
%>		
<%-- 			<TD><script language="javascript">btn("javascript:setProgress('4')","실사통보")</script></TD> --%>
			
			<!-- 
				JOB_STATUS = 'P'  -- 최초등록일 경우 결재 요청을 통해 업체 승인을 한다.  
			 	P 이후 결재가 난후 부터는 JOB_STATUS 가 E로 업데이트 되고 그 뒤부터는 소싱 등록만 가능~
			 -->
<%				
			if("P".equals(job_status) && "".equals(SIGN_APP_STATUS)  ) {										// 아이디 최초등록시
%>		
			
			<TD style="display:none;"><script language="javascript">btn("javascript:doSave()","저 장")</script></TD>
			<TD><script language="javascript">btn("javascript:doRegister('R')","반 려")</script></TD>
			<TD><script language="javascript">btn("javascript:doRegister('Y')","승 인")</script></TD>
<%-- 			<TD><script language="javascript">btn("javascript:doRegister('P')","결재요청")</script></TD> --%>
<%
			}else if("E".equals(job_status)){																	// 업체 등록 승인 후 소싱추가 요청시
%>			
			<TD><script language="javascript">btn("javascript:doSave()","저 장")</script></TD>
			<TD><script language="javascript">btn("javascript:doRegister('R')","반 려")</script></TD>
			<TD><script language="javascript">btn("javascript:doRegister('Y')","등 록")</script></TD>
<%
			}
%>			
<%
        }
%>	
			<TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>
		</TR>
		</TABLE>
	</TD>
</TR>
</TABLE>
	
<input type="hidden" name="attach_gubun"  id="attach_gubun" value="body"> 
<input type="hidden" name="att_mode"      id="att_mode"     value="">
<input type="hidden" name="view_type"     id="view_type"    value="">
<input type="hidden" name="file_type"     id="file_type"    value="">
<input type="hidden" name="tmp_att_no"    id="tmp_att_no"   value="">	
</form>	
<iframe name="hiddenframe" src="" width="0" height="0" border="0"></iframe>

</s:header>
<%-- <s:grid screen_id="SU_102" grid_obj="GridObj" grid_box="gridbox"/> --%>
<s:footer/>
</BODY>
</HTML>

<script>
	/* function rMateFileAttach(att_mode, view_type, file_type, att_no) {
		var f = document.forms[0];
	
		f.att_mode.value   = att_mode;
		f.view_type.value  = view_type;
		f.file_type.value  = file_type;
		f.tmp_att_no.value = att_no;

		if (att_mode == "P") {
			var protocol = location.protocol;
			var host     = location.host;
			var addr     = protocol +"//" +host;

			var win = window.open("","fileattach",'left=0,top=0, width=620, height=300,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');

			f.method = "POST";
			f.target = "fileattach";
			f.action = addr + "/rMateFM/rMate_file_attach_pop.jsp";
			f.submit();
		} else if (att_mode == "S") {
			f.method = "POST";
			f.target = "attachFrame";
			f.action = "/rMateFM/rMate_file_attach.jsp";
			f.submit();
		}
	}
	
	function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
		var attach_key   = att_no;
		var attach_count = att_cnt;
		
		if (document.form1.attach_gubun.value == "sepoa"){
			GD_SetCellValueIndex(GridObj,Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");

			document.form1.attach_gubun.value="body";
		} else {
			var f = document.forms[0];
		    f.attach_no.value    = attach_key;
		    f.attach_count.value = attach_count;

		    eval(functionName);
		}
	}
	 */

</script>

<%
   // if(!"R".equals(REGISTRY_FLAG) && !"N".equals(EDIT_FLAG)){
%>	

	<%-- <script language="javascript">rMateFileAttach('S','C','VNGL',form1.attach_no.value);</script> --%>
<%
	//}else {
%>
	<%-- <script language="javascript">rMateFileAttach('S','R','VNGL',form1.attach_no.value);</script> --%>
<%
	//}
%>


