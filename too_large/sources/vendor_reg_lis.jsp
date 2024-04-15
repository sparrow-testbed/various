<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SU_101");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SU_101";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
	
%>
<% String WISEHUB_PROCESS_ID="SU_101";%>
<!--
 Title:        	SU_101  <p>
 Description:  	업체등록관리/등록업체목록<p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	chan-gon Moon<p>
 @version      	1.0.0<p>
 @Comment       업체등록관리/등록업체목록<p>
-->

<%
	String company_code = info.getSession("COMPANY_CODE");
%>
<html>
<head>
<!-- META TAG 정의  -->
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript" type="text/javascript">
//<!--

	var INDEX_SELECTED;
	var INDEX_NUM;
	var INDEX_NAME_LOC;
	var INDEX_SG_NAME;
	var INDEX_REQUEST_DATE;

	var INDEX_PROGRESS_STATUS;
	var INDEX_SCREENING_STATUS;
	var INDEX_CHECKLIST_STATUS;
	var INDEX_VENDOR_CODE;
	var INDEX_PROGRESS_STATUS_NAME;

	var INDEX_SG_REFITEM;
	var INDEX_VENDOR_SG_REFITEM;
	var mode = "";

	function Init(){
		setGridDraw();
		setHeader();
		doSelect();
	}
	
	function setHeader() {

		
	/* 	GridObj.AddHeader("vendor_code",		"","t_text",1100,0,false);
		GridObj.AddHeader("progress_status1",	"","t_text",1100,0,false);
		
		GridObj.AddHeader("sg_refitem",		"","t_text",1100,0,false);
		GridObj.AddHeader("vendor_sg_refitem","","t_text",1010,0,true);		
		GridObj.AddHeader("IRS_NO",	    	"","t_text",1010,0,false);		 */
		
		
		//GridObj.AddHeader("REGISTRY_FLAG"		,	"REGISTRY_FLAG","t_text",		20,0,false);
		//GridObj.AddHeader("vendor_code",			"업체코드",		"t_text",		20,0,false);
		
		//GridObj.AddHeader("BUSINESS_TYPE",		"업태",			"t_text",		200,0,false);
		//GridObj.AddHeader("INDUSTRY_TYPE",		"업종",			"t_text",		200,0,false);
		//GridObj.AddHeader("USER_NAME",			"영업담당",		"t_text",		200,0,false);
		//GridObj.AddHeader("PHONE_NO",				"전화번호",		"t_text",		90,	0,false);
		//GridObj.AddHeader("EMAIL",				"e-mail",		"t_text",		100,0,false);

		//GridObj.AddHeader(		"progress_status1",	"","t_text",1100,0,false);
		//GridObj.AddHeader(		"sg_refitem",		"","t_text",1100,0,false);
		//GridObj.AddHeader(		"vendor_sg_refitem","","t_text",1010,0,true);
		//GridObj.AddHeader(		"IRS_NO",	    	"","t_text",1010,0,false);
		//GridObj.AddHeader(		"CREDIT_RATING"		,"신용등급","t_text",1010,0,false);

		//GridObj.AddHeader(		"SIGN_STATUS"		,"결재상태","t_text",1010,0,false);

		GridObj.SetDateFormat("request_date","yyyy/MM/dd");

		//GridObj.SetColCellAlign("vendor_code","center");
		//GridObj.SetColCellAlign("USER_NAME","center");

		INDEX_SELECTED         = GridObj.GetColHDIndex("SELECTED");
		INDEX_NUM              = GridObj.GetColHDIndex("NUM");
		INDEX_NAME_LOC         = GridObj.GetColHDIndex("NAME_LOC");
		INDEX_SG_NAME          = GridObj.GetColHDIndex("SG_NAME");
		INDEX_REQUEST_DATE     = GridObj.GetColHDIndex("REQUEST_DATE");

		INDEX_PROGRESS_STATUS  = GridObj.GetColHDIndex("PROGRESS_STATUS");
		INDEX_SCREENING_STATUS = GridObj.GetColHDIndex("SCREENING_STATUS");
		INDEX_CHECKLIST_STATUS = GridObj.GetColHDIndex("CHECKLIST_STATUS");
		INDEX_VENDOR_CODE      = GridObj.GetColHDIndex("VENDOR_CODE");
		INDEX_PROGRESS_STATUS_NAME = GridObj.GetColHDIndex("PROGRESS_STATUS_NAME");

		INDEX_SG_REFITEM        = GridObj.GetColHDIndex("SG_REFITEM");
		INDEX_VENDOR_SG_REFITEM = GridObj.GetColHDIndex("VENDOR_SG_REFITEM");

		
	}

	//Data Query해서 가져오기
	function doSelect() {
		var vendor_name      = document.form.vendor_name.value;
		var progress_status  = document.form.progress_status.value;
		var screening_status = document.form.screening_status.value;
		var checklist_status = document.form.checklist_status.value;
		var company_code = "<%= company_code %>";

		var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/master.register.vendor_reg_lis";
		
		//GridObj.SetParam("sole_proprietor_flag",form.sole_proprietor_flag.value);
		//GridObj.SetParam("vendor_code",form.vendor_code.value);
		
		/* GridObj.SetParam("vendor_name",vendor_name);
		GridObj.SetParam("progress_status",progress_status );
		GridObj.SetParam("screening_status",screening_status);
		GridObj.SetParam("checklist_status",checklist_status);		
		GridObj.SetParam("company_code",company_code);		
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
		GridObj.strHDClickAction="sortmulti"; */
		
		var cols_ids = "<%=grid_col_id%>";
		var params = "mode=getVendorSgLst";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( G_SERVLETURL, params );
		GridObj.clearAll(false);
		
	}

	function progress_Changed() {

		f= document.form;
		f.progress_status.value = f.progress_sel.options[f.progress_sel.selectedIndex].value;

	}

	function screening_Changed() {
		f= document.form;
		f.screening_status.value = f.screening_sel.options[f.screening_sel.selectedIndex].value;

	}

	function checklist_Changed() {
		f= document.form;
		f.checklist_status.value = f.checklist_sel.options[f.checklist_sel.selectedIndex].value;
	}

	function popup(url, flag) {
		var left = 0;
		var top = 0;
		var width = 800;
		var height = 230;

		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'yes';
		var resizable = 'yes';

		if(flag == 2){
			width = 700;
			height = 230;
			scrollbars = 'yes';
			resizable = 'yes';
		}

		var doc = window.open( url, 'doc', 'left=250, top=50, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	//enter를 눌렀을때 event발생
	function entKeyDown(){
  		if(event.keyCode==13) {
   			window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
   			doSelect();
  		}
  	}


  	//1 - 이벤트종류, 2-행의 인덱스 3-열의인덱스, 4-이벤트 지정셀의 이전값, 5-현재값(변경된)
  	function JavaCall(msg1,msg2,msg3,msg4,msg5){
		 for(var i=0;i<GridObj.GetRowCount();i++) {
			if(i%2 == 1){
				for (var j = 0;	j<GridObj.GetColCount(); j++){
					////GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
				}
			}
		}
		<%-- //내용보기
		if(msg3 == INDEX_name_loc){
			var vendor_code = GD_GetCellValueIndex(GridObj,msg2,INDEX_vendor_code);
			//var url = "/kr/master/vendor/ven_pp_dis1.jsp?vendor_code=" + vendor_code+"&flag=popup";
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&CompanyCode=<%=company_code%>&vendor_code="+vendor_code+"&user_type=<%=info.getSession("COMPANY_CODE")%>","ven_bd_con","left=0,top=0,width=950,height=700,resizable=yes,scrollbars=yes");
		} else if(msg3 == INDEX_progress_status) {
			var vendor_code = GD_GetCellValueIndex(GridObj,msg2,INDEX_vendor_code);
			var status = GD_GetCellValueIndex(GridObj,msg2,INDEX_progress_status1);

			var sg_refitem = GD_GetCellValueIndex(GridObj,msg2,INDEX_sg_refitem);
			var vendor_sg_refitem = GD_GetCellValueIndex(GridObj,msg2,INDEX_vendor_sg_refitem);

			if(status == '4') {
				var url = "vendor_reg_pop1.jsp?sg_refitem=" + sg_refitem + "&status=" + status + "&vendor_code=" + vendor_code + "&vendor_sg_refitem=" + vendor_sg_refitem;
				popup(url, 2);
			} else if(status == '5') {
				var url = "vendor_reg_pop1.jsp?sg_refitem=" + sg_refitem + "&status=" + status + "&vendor_code=" + vendor_code + "&vendor_sg_refitem=" + vendor_sg_refitem;
				popup(url, 2);
			} else {
				var url = "vendor_reg_pop.jsp?sg_refitem=" + sg_refitem + "&status=" + status + "&vendor_code=" + vendor_code;
				popup(url, 2);
			}
		} --%>

		if(msg1 == "doData")
		{
			var status= GD_GetParam(GridObj,1);

			if(GridObj.GetStatus() == "1"){
				alert("작업이 정상적으로 수행되었습니다.\n\n[시스템관리>사용자관리>사용자현황]에서 접속가능여부 수정후 접속 가능합니다.");
				doSelect();
			}
			else{
				alert("처리 중 에러가 발생 하였습니다.");
			}
			return;

		}
	}

	function onRefresh() {
setGridDraw();
setHeader();
	}

	function check_sign(){
		var sel_row = 0;
		for(var i=0;i<GridObj.GetRowCount();i++) {
			var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);
			if(temp == "true") {
				sel_row++;

				if(GridObj.GetCellValue("REGISTRY_FLAG", i) != "P"){
					alert("신청현황이 '승인대기'가 아닙니다.");
					return false;
				}
			}
		}

		if(sel_row == 0) {
			alert("항목을 선택해주세요.");
			return false;
		}

		return true;
	}

	function deleteVendor() {

		var wise =  GridObj;
		var sel_row = 0;
		var cnt = 0;
		var vendor_sg_refitem = "";
		var vendor_code = "";

		for(var i=0;i<GridObj.GetRowCount();i++) {
			var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);
			if(temp == "true") {
				sel_row++;
				vendor_sg_refitem = vendor_sg_refitem + "," + GD_GetCellValueIndex(GridObj,i,INDEX_VENDOR_SG_REFITEM);
				if(sel_row == 1){
					vendor_code = GridObj.GetCellValue("VENDOR_CODE", i);
				}
				else{
					vendor_code = vendor_code + "','" + GridObj.GetCellValue("VENDOR_CODE", i);
				}

				if(wise.GetCellValue("SIGN_STATUS", i) == "P"){
					alert("업체승인 결재가 진행중입니다.");
					return;
				}
			}
		}

		if(sel_row == 0) {
			alert("항목을 선택해주세요.");
			return;
		}

		vendor_sg_refitem = vendor_sg_refitem.substring(1);

		//var value = confirm('해당소싱그룹의 사전평가정보가 모두 삭제됩니다. 계속하시겠습니까?');
		var value = confirm('해당정보가 모두 삭제됩니다. 계속하시겠습니까?');
		if(value){
			this.hiddenframe.location.href = "vendor_reg_ins.jsp?mode=delete&vendor_sg_refitem=" + vendor_sg_refitem+"&vendor_code="+vendor_code;
		}
	}

    function Vendor_Search()
	{
    	window.open("/common/CO_014.jsp?callback=getCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}

    function getCode(v0,v1,v2)
	{
		document.forms[0].vendor_code.value = v0;
	}

	function approval(sign_status){
		mode = sign_status;
		if(!check_sign()) return;

		var value = "";
		if(sign_status == "E"){
			value = confirm('승인 하시겠습니까?');
		}
		else{
			value = confirm('반려 하시겠습니까?');
		}

		if(!value){
			return;
		}

	    servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.admin.info.ven_bd_ins6";
	    
	}

//-->

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


function approvalPop(){
	var rowCnt = 0;
	var rowId = -1;
	
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
		if("1" == GridObj.cells(GridObj.getRowId(i), INDEX_SELECTED).getValue()){
			rowCnt++;
		}
	}
	
	if(rowCnt == 0){
		alert("선택된 행이 없습니다.");
		return;
	}else if(rowCnt > 1){
		alert("하나의 행만 선택해주세요.");
		return;		
	}
	
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
		if("1" == GridObj.cells(GridObj.getRowId(i), INDEX_SELECTED).getValue()){
			rowId = GridObj.getRowId(i);
		}
	}
	
	//선택된 행의 그리드컬럼의 값 가져오기
// 	GridObj.cells(rowId, GridObj.GetColHDIndex("REGISTRY_FLAG_NAME")).getValue();

	if(GridObj.cells(rowId, GridObj.GetColHDIndex("REGISTRY_FLAG_NAME")).getValue() != "대기") {
		alert("대기 건만 승인할 수 있습니다.");
		return;
	}
	
	doOnRowSelected(rowId, INDEX_PROGRESS_STATUS_NAME);
}

function doReject(){
	
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

function setREJECT_REASON(reject_reason){
	
	alert(reject_reason);
	
	f = document.form;
	f.mode.value = "register";
	f.flag.value = "R";
	
	f.target="hiddenframe";
	f.action = "vendor_reg_ins.jsp";
	f.submit();
}



function doOnRowSelected(rowId,cellInd)
{
    
	if(cellInd == INDEX_NAME_LOC){
		var vendor_code = GridObj.cells(rowId, INDEX_VENDOR_CODE).getValue();	
		//var url = "/kr/master/vendor/ven_pp_dis1.jsp?vendor_code=" + vendor_code+"&flag=popup";
		window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&CompanyCode=<%=company_code%>&vendor_code="+vendor_code+"&user_type=<%=info.getSession("COMPANY_CODE")%>","ven_bd_con","left=0,top=0,width=950,height=700,resizable=yes,scrollbars=yes");
	} else if(cellInd == INDEX_PROGRESS_STATUS_NAME) {
		var vendor_code       = GridObj.cells(rowId, INDEX_VENDOR_CODE).getValue();	        
		var status            = GridObj.cells(rowId, INDEX_PROGRESS_STATUS).getValue();

		var sg_refitem        = GridObj.cells(rowId, INDEX_SG_REFITEM).getValue();	
		var vendor_sg_refitem = GridObj.cells(rowId, INDEX_VENDOR_SG_REFITEM).getValue();
		
		if(status == '4') {	//실사통보
			var url = "vendor_reg_pop1.jsp?sg_refitem=" + sg_refitem + "&status=" + status + "&vendor_code=" + vendor_code + "&vendor_sg_refitem=" + vendor_sg_refitem;
			popup(url, 2);
		} else if(status == '5') {	//실사완료
			var url = "vendor_reg_pop1.jsp?sg_refitem=" + sg_refitem + "&status=" + status + "&vendor_code=" + vendor_code + "&vendor_sg_refitem=" + vendor_sg_refitem;
			popup(url, 2);
		} else {			//업체등록평가
			var url = "vendor_reg_pop.jsp?sg_refitem=" + sg_refitem + "&status=" + status + "&vendor_code=" + vendor_code;
			popup(url, 2);
		}
	}
    
<%--    
		GD_CellClick(document.WiseGrid,strColumnKey, nRow);

    
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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->
<%@ include file="/include/sepoa_milestone.jsp" %>
<form name="form" method="post" action="">
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<input type="hidden" name="mode"   id="mode">  
	<input type="hidden" name="flag"   id="flag">  
	<input type="hidden" name="reject_reason"   id="reject_reason">  
	<input type="hidden" name="progress_status"   id="progress_status">  
	<input type="hidden" name="screening_status"  id="screening_status"> 
	<input type="hidden" name="checklist_status"  id="checklist_status"> 


	<tr>
		<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체명
		</td>
		<td class="data_td" width="85%">
			<input type="text" size="30" value="" name="vendor_name" id="vendor_name" class="inputsubmit" onkeydown='entKeyDown()'>
		</td>
<!-- 		<td class="title_td" width="15%"> -->
<!-- 			 진행상태 -->
<!-- 			<br> -->
<!-- 		</td> -->
<!-- 		<td class="data_td" width="35%"> -->
<%-- 			<select name="progress_sel" id="progress_sel" class="inputsubmit" onChange="javascript:progress_Changed();"> --%>
<!-- 				<option value=""> -->
<!-- 					전체 -->
<!-- 				</option> -->
<%-- 							<% --%>
<!-- //         String tRfqFlag = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#"+"M120", ""); -->
<!-- //         out.println(tRfqFlag); -->
<%-- %> --%>
<%-- 		</select> --%>
<!-- 	</td> -->
</tr>
<!-- <tr> -->
	
<!-- <td class="title_td" width="15%"> -->
<!-- 	 실사결과 -->
<!-- 	<br> -->
<!-- </td> -->
<!-- <td class="data_td" width="35%" colspan="3"> -->
<%-- 	<select name="checklist_sel" id="checklist_sel" class="inputsubmit" onChange="javascript:checklist_Changed();"> --%>
<!-- 		<option value=""> -->
<!-- 			전체 -->
<!-- 		</option> -->
<%-- 							<% --%>
<!-- // 		        String Flag2 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#"+"M121", ""); -->
<!-- // 		        out.println(Flag2); -->
<%-- 			%> --%>
<%-- 			</select> --%>
<!-- 		</td> -->
<!-- 	</tr> -->

<!--
	<tr >
		<td class="title_td" width="15%">
			 업체명
			<br>
		</td>
		<td class="data_td" width="35%">
			<input type="text" size="30" value="" name="vendor_name" class="inputsubmit" onkeydown='entKeyDown()'>
		</td>
		<td class="title_td" width="15%">
			 업체코드
			<br>
		</td>
		<td class="data_td" width="35%">
			<input type="text" name="vendor_code" maxlength="10" size="14" class="inputsubmit" >
			<a href="javascript:Vendor_Search()">
				<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
			</a>
	</td>
</tr>


	<tr >
		<td class="title_td" width="15%">
			 등록형태			<br>
		</td>
		<td class="data_td" width="35%" colspan="3">
			<select name="sole_proprietor_flag" class="input_re">
				<option value="1" selected>법인사업자</option>
				<option value="2">개인사업자</option>
				
			</select>
	</td>
</tr>
-->
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
</form>

<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
<TR>
	<TD height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
  			<TD><script language="javascript">btn("javascript:doSelect()","조 회")</script></TD>
<%--   			<TD><script language="javascript">btn("javascript:approval('E')","승 인")</script></TD> --%>
<%--   			<TD><script language="javascript">btn("javascript:approval('R')","반 려")</script></TD> --%>

  			<TD><script language="javascript">btn("javascript:approvalPop()","승 인")</script></TD>

<%--   			<TD><script language="javascript">btn("javascript:doReject()","반 려")</script></TD> --%>
  			<!--  
  			
  			<TD><script language="javascript">btn("javascript:deleteVendor()","삭 제")</script></TD>
  			-->
		</TR>
		</TABLE>
</TR>
</TABLE>


<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="20%">
			<div align="left">
			</div>
		</td>
	</tr>
</table>

<iframe name="hiddenframe" src="scr_item_ins.jsp" width="0" height="0"></iframe>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="SU_101" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


