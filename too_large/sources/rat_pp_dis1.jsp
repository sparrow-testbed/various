<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AP_102");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AP_102";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 	

%>
<% String WISEHUB_LANG_TYPE="KR";%>
<%
    String ra_type1			= "";   //역경매타입1 (O:공개,C:지명)
    String start_date		= "";
    String start_time		= "";
    String end_date			= "";
    String end_time         = "";
    String limit_crit		= "";
    String prom_crit		= "";
    String DELY_PLACE		= "";
    String remark			= "";
    String RA_FLAG			= "";
    String RA_ETC			= "";
	String PROM_CRIT_TYPE_NAME = "";

    //변수선언
    String shipper_type            = "";
    String subject                 = "";
    String CHANGE_NAME_LOC         = "";
    String TEL                     = "";
    String EMAIL                   = "";
    String from_date               = "";
    String to_date                 = "";
    String pay_terms_text          = "";
    String dely_terms_text         = "";
	String CUR                     = "";
	String reserve_price           = "";
    String bid_dec_amt             = "";
    String vendor_count	           = "";
    String attach_count            = "";
    String attach_no               = "";
	String company_code            = "";

    String create_type             = "PR";
    String vendor_values           = "";  // 업체정보

    String Z_SMS_SEND_FLAG         = "";
    String Z_CODE1                 = "";

    String tel_no		= "";
    String email		= "";
    String price_down	= "";
    String sms			= "";
	String ANN_DATE		= "";

    //역경매현황에서 넘어오는 경우 파라미터로 받는 부분
    String doc_no	= JSPUtil.nullToEmpty(request.getParameter("doc_no"));
    String doc_seq	= JSPUtil.nullToEmpty(request.getParameter("doc_seq"));
    String ra_seq	= JSPUtil.nullToEmpty(request.getParameter("ra_seq"));
    String sign_path_seq	= JSPUtil.nullToEmpty(request.getParameter("sign_path_seq"));//결재순번
    String proceeding_flag	= JSPUtil.nullToEmpty(request.getParameter("proceeding_flag"));//결재요청상태(합의, 결재)

    if ("".equals(doc_no))  doc_no  = JSPUtil.nullToEmpty(request.getParameter("ra_no"));
    if ("".equals(doc_seq)) doc_seq = "1";
    if (ra_seq .equals("")) ra_seq  = "000001";

    String type         = JSPUtil.nullToEmpty(request.getParameter("type"));
    String doc_status   = JSPUtil.nullToEmpty(request.getParameter("doc_status"));
    String doc_type     = JSPUtil.nullToEmpty(request.getParameter("doc_type"));

	String[] args = { info.getSession("HOUSE_CODE"), doc_no, doc_seq};
	Object[] obj = {args};

	SepoaOut value = ServiceConnector.doService(info, "p1008", "CONNECTION","getRatBdCont", obj);
	SepoaFormater wf = new SepoaFormater(value.result[0]);

    int j=0;

	if(wf != null) {
		int n = 0;

		if(wf.getRowCount() > 0) {
			ra_type1      	= wf.getValue("RA_TYPE1", 		0);
			start_date		= wf.getValue("START_DATE",     0);
			start_time		= wf.getValue("START_TIME",     0);
			end_date		= wf.getValue("END_DATE",		0);
			end_time		= wf.getValue("END_TIME",		0);
			limit_crit		= wf.getValue("LIMIT_CRIT",		0);
			prom_crit		= wf.getValue("PROM_CRIT",		0);
			DELY_PLACE		= wf.getValue("DELY_PLACE",		0);
			remark			= wf.getValue("REMARK",			0);
			RA_FLAG			= wf.getValue("RA_FLAG",		0);

			subject			= wf.getValue("SUBJECT",      0);
			CHANGE_NAME_LOC	= wf.getValue("CHANGE_USER_NAME_LOC",      0);
			tel_no			= wf.getValue("TEL_NO",      0);
			email			= wf.getValue("EMAIL",      0);
			reserve_price	= wf.getValue("RESERVE_PRICE",      0);
			price_down		= wf.getValue("PRICE_DOWN",      0);
			vendor_count	= wf.getValue("VENDOR_COUNT",      0);
			attach_count	= wf.getValue("ATTACH_COUNT",      0);
			attach_no		= wf.getValue("ATTACH_NO",      0);
			sms				= wf.getValue("SMS",      0);
			CUR				= wf.getValue("CUR",      0);
			company_code	= wf.getValue("COMPANY_CODE",      0);
			ANN_DATE		= wf.getValue("ANN_DATE",      0);
			RA_ETC			= wf.getValue("RA_ETC",      0);
			PROM_CRIT_TYPE_NAME= wf.getValue("PROM_CRIT_TYPE_NAME",      0);

		} else if(wf.getRowCount() == 0) {
%>
			<script>
				alert( "조회된 내역이 없습니다." );
			</script>
<%
		}
	}

    String disp_ra_date  = start_date.substring(0, 4) + "년 " + start_date.substring(4, 6) + "월 " + start_date.substring(6, 8) + "일 "
                         + start_time.substring(0, 2) + "시 " + start_time.substring(2, 4) + "분 ~ "
                         + end_date.substring(0, 4) + "년 " + end_date.substring(4, 6) + "월 " + end_date.substring(6, 8) + "일 "
                         + end_time.substring(0, 2) + "시 " + end_time.substring(2, 4) + "분";


	wf = new SepoaFormater(value.result[1]); //VENDOR_CODE,NAME_LOC,'N'(flag)
	if(wf != null) {
		//업체(vendor_values)--Data format [vendor_code, vendor명, flag], ex (0000300007 @한국식품공업(주) @N @#...)
		for (int i = 0; i < wf.getRowCount(); i++) {
			vendor_values += wf.getValue(i, 0) + "@" + wf.getValue(i, 1) + "@" + wf.getValue(i, 2) + "@#";
		}
	}
%>

<html>
<head>

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<script language="javascript">
//<!--
    var j=0;

	var	INDEX_BUYER_ITEM_NO		;
	var	INDEX_DESCRIPTION_LOC	;
	var	INDEX_UNIT_MEASURE		;
	var	INDEX_CONFIRM_QTY		;
	var	INDEX_DELY_TO_ADDRESS	;

	var	INDEX_RD_DATE			;
//--------------------------------------------
//  업체지정
//--------------------------------------------
    function VendorList() {

        var ses_comp = "<%=info.getSession("COMPANY_CODE")%>";

        if("<%=company_code%>" != ses_comp) {
            alert("조회할 수 없습니다.");
            return;
        }

        ra_no       = "<%=doc_no%>";
        ra_count    = "<%=doc_seq%>";
        ra_seq      = "<%=ra_seq%>";

        url  = "/s_kr/bidding/rat/rat_pp_lis3.jsp?";
        url += "ra_no="+ra_no;
        url += "&ra_count="+ra_count;
        url += "&ra_seq="+ra_seq;

        window.open(url,"rat_pp_lis3","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=500,height=300,left=0,top=0");
    }

    function doClose() {
        window.close();
        //parent.opener.doSelect();
    }

//승인
    function EndApp3()
    {
        var doc_no = "<%=doc_no%>";

        //opener.sign_Close(doc_no,"E");
        window.opener.btnApprovalAll('2','1','<%=doc_no%>','<%=doc_seq%>');

        //window.close();
    }

//반려
    function RefundApp()
    {
        var doc_no = "<%=doc_no%>";

        window.opener.sign_Close(doc_no,"R");
        window.close();
    }

    function Init()
    {
setGridDraw();
setHeader();
    }

	//WiseTable Header 초기화
	function setHeader()
	{


// 		GridObj.SetColCellSortEnable("UNIT_MEASURE"		   ,false);
// 		GridObj.SetDateFormat("RD_DATE" ,"yyyy/MM/dd");
// 		GridObj.SetColCellSortEnable("RD_DATE"		    ,false);
// 		GridObj.SetColCellSortEnable("DELY_TO_LOCATION_NAME",false);
// 		GridObj.SetColCellSortEnable("PR_NO"				,false);
// 		GridObj.SetColCellSortEnable("PR_SEQ"				,false);
// 		GridObj.SetColCellSortEnable("PURCHASE_LOCATION"	,false);
// 		GridObj.SetColCellSortEnable("DELY_TO_LOCATION"	,false);


		GridObj.strHDClickAction="sortmulti";

		INDEX_Z_CODE1		        = GridObj.GetColHDIndex("Z_CODE1");
		INDEX_BUYER_ITEM_NO			= GridObj.GetColHDIndex("BUYER_ITEM_NO");
		INDEX_DESCRIPTION_LOC		= GridObj.GetColHDIndex("DESCRIPTION_LOC");
		INDEX_SPECIFICATION			= GridObj.GetColHDIndex("SPECIFICATION");
		INDEX_UNIT_MEASURE			= GridObj.GetColHDIndex("UNIT_MEASURE");
		INDEX_RD_DATE				= GridObj.GetColHDIndex("RD_DATE");
		INDEX_DELY_TO_LOCATION_NAME	= GridObj.GetColHDIndex("DELY_TO_LOCATION_NAME");
		INDEX_PR_NO					= GridObj.GetColHDIndex("PR_NO");
		INDEX_PR_SEQ				= GridObj.GetColHDIndex("PR_SEQ");
		INDEX_PURCHASE_LOCATION		= GridObj.GetColHDIndex("PURCHASE_LOCATION");
		INDEX_DELY_TO_LOCATION		= GridObj.GetColHDIndex("DELY_TO_LOCATION");

		doSelect();

	}

	function doSelect(){
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_pp_dis1";

		var cols_ids = "<%=grid_col_id%>";
		var params = "mode=getratbddis1_1";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( servletUrl, params );
		GridObj.clearAll(false);		
		

// 		mode = "getratbddis1_1";
		

// 		GridObj.SetParam("mode", mode);
<%-- 		GridObj.SetParam("RA_NO", "<%=doc_no%>"); --%>
<%-- 		GridObj.SetParam("RA_COUNT", "<%=doc_seq%>"); --%>
// 		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
// 		GridObj.SendData(servletUrl);
// 		GridObj.strHDClickAction="sortmulti";
	}

	function POPUP_Open(url, title, left, top, width, height) {
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'yes';
		var resizable = 'no';
		var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		code_search.focus();
	}

	function JavaCall(msg1,msg2,msg3,msg4,msg5){
		if(msg1 == "doQuery"){
			var sign_url = "/kr/admin/basic/approval2/ap2_pp_lis7.jsp?company_code=<%=company_code%>&doc_type=<%=doc_type%>&doc_no=<%=doc_no%>&doc_seq=<%=doc_seq%>";
			//var sign_popup = window.open(sign_url, "BKWin", "left=1200, top=0, width=400, height=400", "toolbar=no", "menubar=no", "status=yes", "scrollbars=no", "resizable=no");
   			//sign_popup.focus();
		}


		if(msg1 == "t_imagetext") {
			/*
			if(msg3 == INDEX_BUYER_ITEM_NO) { //품목
                var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2, INDEX_BUYER_ITEM_NO);
				if ( ITEM_NO != "") {
					POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+ITEM_NO, "mat_pp_ger1", '0', '0', '800', '700');
				}
			}else if(msg3 == INDEX_PR_NO){
				pr_no = GridObj.GetCellValue(GridObj.GetColHDKey( msg3),msg2);
				window.open('/kr/dt/ebd/ebd_pp_dis6.jsp?pr_no='+pr_no ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
			}
			*/
		}
	}

	function rMateFileAttach(att_mode, view_type, file_type, att_no) {
		var f = document.forms[0];

		f.att_mode.value   = att_mode;
		f.view_type.value  = view_type;
		f.file_type.value  = file_type;
		f.tmp_att_no.value = att_no;

		if (att_mode == "S") {
			f.method = "POST";
			f.target = "attachFrame";
			f.action = "/rMateFM/rMate_file_attach.jsp";
			f.submit();
		}
	}

	// 결재선변경
	function changeApprovalLine(doc_type ,doc_no ,doc_seq, sign_path_seq){
		if("<%=proceeding_flag%>" != "P"){
			alert("결재선변경은 결재자만 가능합니다.");
			return;
		}
		CodeSearchCommon("/kr/admin/basic/approval2/ap2_pp_upd3.jsp?doc_type="+doc_type+"&doc_no="+doc_no+"&doc_seq="+doc_seq+ "&sign_path_seq="+sign_path_seq+"&issue_type=&fnc_name=getApproval","pop_up","","","700","320");
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
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
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
<body onload="Init();" bgcolor="#FFFFFF" text="#000000" topmargin="0">

<s:header popup="true">
<!--내용시작-->
<style type="text/css">
<!--
.style1 {
	color: #000000;
	font-size: 18px;
	font-weight: bold;
}
-->
</style>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td  height="20"></td>
   </tr>
   <tr>
     <td align="center" class="style1">
		역 경 매 <%="D".equals(RA_FLAG) ? "  취 소 " : ""%>공 고
     </td>
   </tr>
   <tr>
     <td  height="20">&nbsp;</td>
   </tr>
 </table>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" >
  <tr>
    <td width="29%" valign="top" ><table width="90%" height="92" border="0" cellpadding="0" cellspacing="0">
	  <tr>
        <td class="title">공&nbsp;고&nbsp;번&nbsp;호&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=doc_no%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
      <tr>
        <td class="title">공&nbsp;고&nbsp;일&nbsp;자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=ANN_DATE%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
      <tr>
        <td class="title">역&nbsp;경&nbsp;매&nbsp;건&nbsp;명&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=subject%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
      <tr>
        <td class="title">공&nbsp;&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=CHANGE_NAME_LOC%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
    </table>
    </td>
    <td width="*" colspan="2" align="right" >
<!-- 결재라인 시작 -->
    	<table border="0" cellspacing="1" cellpadding="0" bgcolor="#000000" align="right">
      		<tr bgcolor="#FFFFFF">
        		<td width="32" align="center" bgcolor="#CCCCCC" class="title_td" >결<br>재</td>
<%
    Object[] obj_sign = {doc_no,doc_type,doc_seq};	//기안자 + 결재자
    SepoaOut value_sign = ServiceConnector.doService(info,"p6029","CONNECTION","getSignPath2",obj_sign);
    SepoaFormater wf_sign = new SepoaFormater(value_sign.result[0]);

    Object[] obj_agree = {doc_no,doc_type,doc_seq}; //합의자
    SepoaOut value_agree = ServiceConnector.doService(info,"p6029","CONNECTION","getSignAgree2",obj_agree);
    SepoaFormater wf_agree = new SepoaFormater(value_agree.result[0]);

    int approvalCnt = wf_sign.getRowCount()-wf_agree.getRowCount() > 0 ?  wf_sign.getRowCount() : wf_sign.getRowCount()-wf_agree.getRowCount() == 0 ? wf_sign.getRowCount() :  wf_agree.getRowCount();   //결재라인수

 	String POSITION_TEXT = "";
 	String USER_NAME_LOC = "";
 	String SIGN_DATE = "";
 	String SIGN_TIME = "";
 	String APP_STATUS = "";

    for(int i = 0 ; i<approvalCnt; i++) {
		if(i < wf_sign.getRowCount()) {
			POSITION_TEXT 	= wf_sign.getValue("POSITION_TEXT"		, i);
			USER_NAME_LOC 	= wf_sign.getValue("USER_NAME_LOC"		, i);
			SIGN_DATE 	    = wf_sign.getValue("SIGN_DATE"			, i);
			SIGN_TIME 	    = wf_sign.getValue("SIGN_TIME"			, i);
			APP_STATUS 	    = wf_sign.getValue("APP_STATUS"			, i);
%>
	        <td width="110">
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center"><%=USER_NAME_LOC%></td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">
    	<%
       		if(APP_STATUS.equals("A")) { //기안
    	%>
              				기 안<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_2.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else if(APP_STATUS.equals("E")) { // 승인 %>
              				승 인<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_1.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else if(APP_STATUS.equals("R")) { // 반려%>
              				반 려<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_3.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else { %>
              &nbsp;
    	<% } %>
              			</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="20" class="input_data2" align="center"><%=SIGN_DATE%></td>
            		</tr>
        		</table>
        	</td>
<%
		}else {
%>
			 <td width="110">
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
        		</table>
        	</td>
<%
		}// end of if
	}//end of for
%>
      </tr>
	  <tr bgcolor="#FFFFFF" style="display:none">
      	<td width="32" align="center" bgcolor="#CCCCCC" class="title_td" >합<br>의</td>
<%

 	POSITION_TEXT = "";
 	USER_NAME_LOC = "";
 	SIGN_DATE = "";
 	SIGN_TIME = "";
 	APP_STATUS = "";

    for(int i = 0 ; i<approvalCnt; i++) {
		if(i < wf_agree.getRowCount()){
			POSITION_TEXT 	= wf_agree.getValue("POSITION_TEXT"		, i);
			USER_NAME_LOC 	= wf_agree.getValue("USER_NAME_LOC"		, i);
			SIGN_DATE 	    = wf_agree.getValue("SIGN_DATE"			, i);
			SIGN_TIME 	    = wf_agree.getValue("SIGN_TIME"			, i);
			APP_STATUS 	    = wf_agree.getValue("APP_STATUS"		, i);
%>
	        <td width="110">
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center"><%=POSITION_TEXT%></td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">
    	<%
       		if(APP_STATUS.equals("A")) { //기안
    	%>
              				기 안<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_2.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else if(APP_STATUS.equals("E")) { // 승인 %>
              				승 인<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_1.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else if(APP_STATUS.equals("R")) { // 반려%>
              				반 려<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_3.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else { %>
              &nbsp;
    	<% } %>
              			</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="20" class="input_data2" align="center"><%=SIGN_DATE%></td>
            		</tr>
        		</table>
        	</td>
<%
		}else {
%>
			 <td width="110">
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
        		</table>
        	</td>
<%
		}// end of if
	}//end of for
%>
      </tr>
	</table>
<!-- 결재라인 끝-->
</td>
</tr>
</table>

<br>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
<%  if ("Y".equals(doc_status)) {   %>
						<TD><script language="javascript">btn("javascript:opener.btnApprovalAll('2','1','<%=doc_no%>','<%=doc_seq%>')","승 인")   </script></TD>
		      			<TD><script language="javascript">btn("javascript:opener.btnApprovalAll('3','1','<%=doc_no%>','<%=doc_seq%>')","반 려")</script></TD>
		      			<TD><script language="javascript">btn("javascript:changeApprovalLine('<%=doc_type%>','<%=doc_no%>','<%=doc_seq%>','<%=sign_path_seq%>')","결재선변경")</script></TD>
<%  }   %>
		      			<TD><script language="javascript">btn("javascript:doClose()","닫 기")</script></TD>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>

 <table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#ccd5de">
 <form id="form1" name="form1" method="post">
<%-- 	<input type="hidden" id="attach_no"			name="attach_no"		value="<%=attach_no%>"> --%>
	<input type="hidden" id="ra_flag">                
	<input type="hidden" id="vendor_select"   	name="vendor_select"    value="<%=vendor_values%>">
	<input type="hidden" id="shipper_type"		name="shipper_type"		value="<%=shipper_type%>">
	<input type="hidden" id="create_type"		name="create_type"		value="<%=create_type%>">
	<input type="hidden" id="company_code" 		name="company_code" 	value="<%=company_code%>">
	<input type="hidden" id="ra_seq"			name="ra_seq"			value="<%=ra_seq%>">
                                                                       
	<input type="hidden" id="att_mode"   		name="att_mode"   		value="">
	<input type="hidden" id="view_type"  		name="view_type"  		value="">
	<input type="hidden" id="file_type"  		name="file_type"  		value="">
	<input type="hidden" id="tmp_att_no" 		name="tmp_att_no" 		value="">

	<input type="hidden" id="RA_NO" 		name="RA_NO" 		value="<%=doc_no%>">
	<input type="hidden" id="RA_SEQ" 		name="RA_SEQ" 		value="<%=doc_seq%>">
	
	

    <tr>
    <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 역경매방법</td>
      <td class="data_td" colspan="3">
      	<div align="left">&nbsp;<%=(("GC".equals(ra_type1))? "일반경쟁" : "지명경쟁")%></div>
       <input type="hidden" id="ra_no" name="ra_no"  size="20" class="input_data2" value="<%=doc_no%>" readonly >
      </td>
    </tr>
    <tr>
      <td class="title_td" width="0">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 역경매일시</td>
      <td class="data_td" colspan="3">
      	<div align="left">&nbsp;<%=disp_ra_date%></div>
        <input type="hidden" size="50" name="subject" readonly class="input_data2" value="<%=subject%>">
      </td>
    </tr>
    <tr>
      <td class="title_td" width="0">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 시작가(VAT별도)</td>
      <td class="data_td" width="0"><%=CUR%>&nbsp;&nbsp;
        <input type="text" size="20" name="reserve_price" readonly class="input_data2" value="<%=("".equals(reserve_price))?"":SepoaString.formatNum(Long.parseLong(reserve_price))%>">
      </td>
      <td class="title_td" width="0">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 투찰단위금액</td>
      <td class="data_td" width="0"><%=CUR%>&nbsp;&nbsp;
        <input type="text" size="20" name="bid_dec_amt" readonly class="input_data2" value="<%=("".equals(price_down))?"":SepoaString.formatNum(Long.parseLong(price_down))%>">
      </td>
    </tr>
    <tr>
      <td class="title_td" width="0">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰참가자격</td>
      <td class="data_td" colspan="3">
      <textarea cols="95" class="inputsubmit" rows="3" readonly><%=limit_crit%></textarea>
      </td>
    </tr>
    <tr>
      <td class="title_td" width="0">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 낙찰자선정</td>
      <td class="data_td" colspan="3">
      	<div align="left"><%=PROM_CRIT_TYPE_NAME%>&nbsp;&nbsp;&nbsp;&nbsp;<%=prom_crit.replaceAll("\"", "&quot")%></div>
      </td>
    </tr>
    <tr>
      <td class="title_td" width="0">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 납기장소</td>
      <td class="data_td" colspan="3">
      	<div align="left">&nbsp;<%=DELY_PLACE%></div>
      </td>
    </tr>
    <tr>
      <td class="title_td" width="0">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 기타사항</td>
      <td class="data_td" colspan="3">
      <textarea cols="95" class="inputsubmit" rows="10" readonly><%=remark%></textarea>
      </td>
    </tr>
    <tr>
      <td class="title_td" width="0">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 보고사항</td>
      <td class="data_td" colspan="3">
      <textarea cols="95" class="inputsubmit" rows="10" readonly><%=RA_ETC%></textarea>
      </td>
    </tr>

    <tr style="display:none;">
      <td class="title_td" width="0">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업체지정</td>
      <td class="data_td">
        <a href="javascript:VendorList()"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"></a>
        <input type="text" name="vendor_count" value="<%=vendor_count%>" class="input_data3" readonly >
      </td>
		<td class="title_td" width="0">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; SMS선택여부
		</td>
		<td class="data_td" colspan="3">
			<%=sms%>
		</td>
	</tr>
    <tr style="display:none;">
      <td class="title_td" width="0">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 구매담당</td>
      <td class="data_td" >
        <input type="text" size="20" name="user_name" value="<%=CHANGE_NAME_LOC%>" class="input_data2" readonly>
      </td>
    </tr>
    <tr style="display:none;">
      <td class="title_td" width="0">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 전화번호</td>
      <td class="data_td" >
        <input type="text" size="40" name="tel" value="<%=tel_no%>"  class="input_data3" readonly>
      </td>
      <td class="title_td" width="0">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; Email</td>
      <td class="data_td" >
        <input type="text" size="40" name="email" value="<%=email%>" class="input_data3" readonly>
      </td>
    </tr>
  </table>
  	<table><tr><td></td></tr></table>
<!-- 	<table width="100%" border="0" cellspacing="0" cellpadding="0"> -->
<!--     	<tr> -->
<!-- 			<td height="1" class="cell"></td> -->
<!-- 			<!-- wisegrid 상단 bar -->
<!-- 		</tr> -->
<!-- 		<tr> -->
<!-- 		    <td align="center"> -->
<%-- 		  		<%=WiseTable_Scripts("100%","150")%> --%>
<!-- 			</td> -->
<!--     	</tr> -->
<!--   	</table> -->
  	  	<table><tr><td></td></tr></table>
  	<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#ccd5de">
  	<tr>
   		<td width="" class="data_td" colspan="3" >
			<input type="hidden" name="attach_no" id="attach_no" value="<%=attach_no%>">
			<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=attach_no%>&view_type=VI" style="width: 98%;height: 115px; border: 0px;" frameborder="0" ></iframe>  	
		</td>
      
<%--       <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 첨부파일</td> --%>
<!--       <td class="data_td" colspan="3"> -->
<!-- 		<iframe name="attachFrame" width="620" height="150" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe> -->
<!-- 		<br>&nbsp; -->
<!--       </td> -->
      
      
      
    </tr>
  	</table>
	<s:grid screen_id="AP_102" grid_obj="GridObj" grid_box="gridbox"/>  	
  	<table><tr><td></td></tr></table>
  	<%-- 결재자 의견 --%>
	<jsp:include page="/include/approvalOpinion.jsp" >
	<jsp:param name="doc_no" 	value="<%=doc_no%>"/>
	<jsp:param name="doc_seq" 	value="<%=doc_seq%>"/>
	<jsp:param name="doc_type" 	value="<%=doc_type%>"/>
	</jsp:include>
    </form>
</s:header>
<s:footer/>
</body>
</html>


