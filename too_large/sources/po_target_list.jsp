<%@page import="sepoa.svl.util.SepoaServlet"%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PO_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PO_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<%-- <%@ include file="/include/sepoa_common.jsp"%> --%>
<!-- 2011-03-08 solarb -->
<!-- 그리드 기안번호 컬럼 클릭시 ArrayIndexOutOfBoundException -->
<!-- LSW로 로그인시 정상적으로 수행 -->
<% String WISEHUB_PROCESS_ID="PO_001";%>

<%-- <%@ include file="/include/sepoa_session.jsp" %> --%>

<%
	String house_code = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
	String ctrl_code = info.getSession("CTRL_CODE");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_id = info.getSession("ID");
	
	String G_IMG_ICON = "/images/ico_zoom.gif";

	String to_date   = SepoaDate.getShortDateString(); // 현재 시스템 날짜
	String from_date = SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(to_date,-3)); // 오늘을 기준으로 1달전
	to_date = SepoaString.getDateSlashFormat(to_date);
	
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_po_target_list"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
	
%>
<%-- <!--	WisTable 관련된 정보를 정의 WiseTable를 사용하는 부분 반드시 선언. -->
<%@ include file="/include/wisetable_scripts.jsp"%>
<!-- Wisehub Common Scripts -->
<%@ include file="/include/wisehub_scripts.jsp"%>
<!-- Wisehub Code Common -->
<%@ include file="/include/code_common.jsp"%> --%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>


<Script language="javascript">
//<!--
var house_code = "<%=info.getSession("HOUSE_CODE")%>";
<%-- var	servletUrl = "<%=getWiseServletPath("procure.po_target_list")%>"; --%>

var IDX_SEL		 			;
var IDX_VENDOR_CODE			;
var IDX_VENDOR_NAME			;
var IDX_ITEM_NO				;
var IDX_DESCRIPTION_LOC		;
var IDX_ITEM_QTY			;
var IDX_UNIT_PRICE		    ;
var IDX_ITEM_AMT			;
var IDX_PR_NO			    ;
var IDX_PR_TYPE			    ;
var IDX_REQ_TYPE			;
var IDX_EXEC_NO				;
var IDX_SIGN_DATE			;
var IDX_DP_DIV				;
var IDX_CONTRACT_PERCENT	;
var IDX_PR_TYPE_CODE	;
var IDX_CTRL_CODE	;
//var IDX_YR_UNIT_PR_ORD_GB;

var mode;
var chkrow;


function Init() {
	setGridDraw();
	setHeader();
	doQuery();
}

function setHeader()
{
	/* GD_setProperty(GridObj); */
	GridObj.bHDMoving 			= false;
	GridObj.bHDSwapping 			= false;
	GridObj.bRowSelectorVisible 	= false;
	GridObj.strRowBorderStyle 	= "none";
	GridObj.nRowSpacing 			= 0 ;
	GridObj.strHDClickAction 		= "select";

	//발주생성을 위한 정보


	//보증정보

	//공급업체담당자정보


	/* GridObj.SetNumberFormat("ITEM_QTY"		,G_format_qty);
	GridObj.SetNumberFormat("UNIT_PRICE"		,G_format_unit);
	GridObj.SetNumberFormat("ITEM_AMT"		,G_format_amt); */

	GridObj.SetDateFormat("SIGN_DATE"		,"yyyy/MM/dd");


	IDX_SEL		 			= GridObj.GetColHDIndex("SEL"		 		);
	IDX_VENDOR_CODE			= GridObj.GetColHDIndex("VENDOR_CODE"		);
	IDX_VENDOR_NAME			= GridObj.GetColHDIndex("VENDOR_NAME"		);
	IDX_ITEM_NO				= GridObj.GetColHDIndex("ITEM_NO"			);
	IDX_DESCRIPTION_LOC		= GridObj.GetColHDIndex("DESCRIPTION_LOC"	);
	IDX_ITEM_QTY			= GridObj.GetColHDIndex("ITEM_QTY"		);
	IDX_UNIT_PRICE		    = GridObj.GetColHDIndex("UNIT_PRICE"		);
	IDX_ITEM_AMT			= GridObj.GetColHDIndex("ITEM_AMT"		);
	IDX_PR_NO			    = GridObj.GetColHDIndex("PR_NO"			);
	IDX_PR_TYPE			    = GridObj.GetColHDIndex("PR_TYPE"			);
	IDX_EXEC_NO				= GridObj.GetColHDIndex("EXEC_NO"			);
	IDX_REQ_TYPE			= GridObj.GetColHDIndex("REQ_TYPE"			);
	IDX_SIGN_DATE			= GridObj.GetColHDIndex("SIGN_DATE"		);
	IDX_DP_DIV				= GridObj.GetColHDIndex("DP_DIV"		);
	IDX_CONTRACT_PERCENT	= GridObj.GetColHDIndex("CONTRACT_PERCENT");
	IDX_CTRL_CODE			= GridObj.GetColHDIndex("CTRL_CODE");
//	IDX_YR_UNIT_PR_ORD_GB	= GridObj.GetColHDIndex("YR_UNIT_PR_ORD_GB");
}

function doQuery()
{
	document.form1.exec_no.value = document.form1.exec_no.value.toUpperCase();
	document.form1.pr_no.value = document.form1.pr_no.value.toUpperCase();
	var from_date  = del_Slash(document.form1.from_date.value);
	var to_date    = del_Slash(document.form1.to_date.value);
	var exec_no = document.form1.exec_no.value;
	var pr_no = document.form1.pr_no.value;

	
	//from_date.replaceAll("-","");
	//to_date.replaceAll("-","");
	if(!checkDateCommon(from_date)) {
		alert(" 기안일자(From)를 확인 하세요 ");
		document.form1.from_date.select();
		return;
	}

	if(!checkDateCommon(to_date)) {
		alert(" 기안일자(To)를 확인 하세요 ");
		document.form1.to_date.select();
		return;
	}
	
	var param ="mode=getPoTargetList&grid_col_id="+grid_col_id;
	var url	= "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.po_target_list";
	param += dataOutput();
	GridObj.post(url, param);
 	GridObj.clearAll(false);
	<%-- mode = "getPoTargetList";
	GridObj.SetParam("mode", mode);
	GridObj.SetParam("from_date",from_date);
	GridObj.SetParam("to_date",to_date);
	GridObj.SetParam("exec_no",exec_no);
	GridObj.SetParam("pr_no",pr_no);
	GridObj.SetParam("ctrl_code"	,document.form1.ctrl_code.value	);
	GridObj.SetParam("purchaser_id"	,document.form1.ctrl_person_id.value	);
    GridObj.SetParam("dept"		,document.form1.demand_dept.value);
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
	GridObj.SendData("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa/svl/procure/po_target_list");
	GridObj.strHDClickAction="sortmulti"; --%>
}

//발주생성
function poCreate() {
	if (!checkUser()) return;
	
	var wise = GridObj;
	var rowCount = wise.GetRowCount();
	var vendor_code = "";
	var exec_no = "";
	var exec_seq = "";
	var item_seq = "";
	var dp_div = "";
	var cont_percent = "";
	var t_row =0;
	var t_check =0;
	var exec_amt_krw =0;
	var po_check	= 0;
	var po_div_flag = "";
	var purchaser_flag = "";
	var exec_number = "";
	var chk_own_go = 0;
	var grid_array = getGridChangedRows(GridObj, "SEL");
	var iCheckedCount = 0;
	
	
	if(grid_array.length == 0){ // 선택된 로우가 없을 경우
		alert(G_MSS1_SELECT);
		return;
    }
	
	for(var z = 0; z < grid_array.length; z++) {
		
		if(chk_own_go == 0 && GridObj.cells(grid_array[z], GridObj.getColIndexById("PURCHASER_ID")).getValue() != "<%=user_id%>") {
			if(!confirm("구매담당자가 본인이 아닙니다. 진행하시겠습니까?")) {
				return;
			}else{
				chk_own_go = 1;	
			}
		}
		
		
		exec_no	= GridObj.cells(grid_array[z], GridObj.getColIndexById("EXEC_NO")).getValue();
		exec_seq = GridObj.cells(grid_array[z], GridObj.getColIndexById("EXEC_SEQ")).getValue();
		item_seq = GridObj.cells(grid_array[z], GridObj.getColIndexById("ITEM_SEQ")).getValue();
		
		exec_number  += "'" + exec_no + exec_seq + item_seq + "',";
		exec_amt_krw += parseInt(GridObj.cells(grid_array[z], GridObj.getColIndexById("EXEC_AMT_KRW")).getValue());
		
		
		if(z==0){
			vendor_code = GridObj.cells(grid_array[z], GridObj.getColIndexById("VENDOR_CODE")).getValue();
			po_div_flag = GridObj.cells(grid_array[z], GridObj.getColIndexById("DP_DIV")).getValue();
			vendor_code_bf = vendor_code;
			exec_no_bf = GridObj.cells(grid_array[z], GridObj.getColIndexById("EXEC_NO")).getValue();
		}
		
		if(z>0){
 			if(vendor_code_bf == GridObj.cells(grid_array[z], GridObj.getColIndexById("VENDOR_CODE")).getValue() 
					&& exec_no_bf == GridObj.cells(grid_array[z], GridObj.getColIndexById("EXEC_NO")).getValue()){
			}else{
				alert("기안번호가 같고 업체가 동일한 경우에만 발주를 생성하실 수 있습니다.");
				return;
			}
 			vendor_code_bf = GridObj.cells(grid_array[z], GridObj.getColIndexById("VENDOR_CODE")).getValue();
			exec_no_bf = GridObj.cells(grid_array[z], GridObj.getColIndexById("EXEC_NO")).getValue();
				
		}
		
	}
	 
	/*기안 item 처리 마지막 콤마 제거*/
	exec_seq = exec_seq.substring(0,exec_seq.length-1);
	exec_number = exec_number.substring(0,exec_number.length-1);
	/*
	if(t_row==-1){
		alert("항목을 선택해 주세요.");
		return;
	}

	if(po_check >= 1){
		if(!confirm("상품과 용역을 묶어서 발주를 생성하시겠습니까?")){
			return;
		}
	}
	*/
	/*
	document.main.VENDOR_NAME.value = wise.GetCellValue("VENDOR_NAME", t_row);
	document.main.SUBJECT.value = wise.GetCellValue("SUBJECT", t_row);
	document.main.CTRL_CODE.value = wise.GetCellValue("CTRL_CODE", t_row);
	document.main.PAY_TERMS.value = wise.GetCellValue("PAY_TERMS", t_row);
	document.main.PAY_TERMS_DESC.value = wise.GetCellValue("PAY_TERMS_DESC", t_row);
	document.main.PR_TYPE.value = wise.GetCellValue("PR_TYPE", t_row);
	document.main.PR_TYPE_CODE.value = wise.GetCellValue("PR_TYPE_CODE", t_row);
	document.main.ORDER_NO.value = wise.GetCellValue("ORDER_NO", t_row);
	document.main.ORDER_NAME.value = wise.GetCellValue("ORDER_NAME", t_row);
	document.main.TAKE_USER_NAME.value = wise.GetCellValue("TAKE_USER_NAME", t_row);
	document.main.TAKE_USER_ID.value = wise.GetCellValue("TAKE_USER_ID", t_row);
	document.main.CTR_DATE.value = wise.GetCellValue("CTR_DATE", t_row);
	document.main.TAKE_TEL.value = wise.GetCellValue("TAKE_TEL", t_row);
	document.main.REMARK.value = wise.GetCellValue("REMARK", t_row);
	document.main.CTR_NO.value = wise.GetCellValue("CTR_NO", t_row);
	document.main.CONTRACT_FROM_DATE.value = wise.GetCellValue("CONTRACT_FROM_DATE",t_row);
	document.main.CONTRACT_TO_DATE.value = wise.GetCellValue("CONTRACT_TO_DATE",t_row);
	document.main.SIGN_PERSON_ID.value = wise.GetCellValue("SIGN_PERSON_ID", t_row);
	document.main.PO_TYPE.value = wise.GetCellValue("PO_TYPE", t_row);
	document.main.SHIPPER_TYPE.value = wise.GetCellValue("SHIPPER_TYPE", t_row);
	document.main.DP_PAY_TERMS.value = wise.GetCellValue("DP_PAY_TERMS", t_row);
	document.main.vncp_user_name.value = wise.GetCellValue("vncp_user_name", t_row);
	document.main.vncp_mobile_no.value = wise.GetCellValue("vncp_mobile_no", t_row);
	document.main.vncp_email.value = wise.GetCellValue("vncp_email", t_row);
	document.main.ADD_USER_ID.value = wise.GetCellValue("ADD_USER_ID", t_row);
	document.main.ADD_USER_NAME.value = wise.GetCellValue("ADD_USER_NAME", t_row);
	document.main.PURCHASER_ID.value = wise.GetCellValue("PURCHASER_ID", t_row);
	document.main.PURCHASER_NAME.value = wise.GetCellValue("PURCHASER_NAME", t_row);
	*/
	document.main.VENDOR_NAME.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("VENDOR_NAME")).getValue();
	document.main.SUBJECT.value 	= GridObj.cells(grid_array[0], GridObj.getColIndexById("SUBJECT")).getValue();
	document.main.CTRL_CODE.value 	= GridObj.cells(grid_array[0], GridObj.getColIndexById("CTRL_CODE")).getValue();
	document.main.PAY_TERMS.value 	= GridObj.cells(grid_array[0], GridObj.getColIndexById("PAY_TERMS")).getValue();
	document.main.PAY_TERMS_DESC.value 	= GridObj.cells(grid_array[0], GridObj.getColIndexById("PAY_TERMS_DESC")).getValue();
	document.main.PR_TYPE.value 		= GridObj.cells(grid_array[0], GridObj.getColIndexById("PR_TYPE")).getValue();
	document.main.PR_TYPE_CODE.value 	= GridObj.cells(grid_array[0], GridObj.getColIndexById("PR_TYPE_CODE")).getValue();
	document.main.ORDER_NO.value 		= GridObj.cells(grid_array[0], GridObj.getColIndexById("ORDER_NO")).getValue();
	document.main.ORDER_NAME.value 		= GridObj.cells(grid_array[0], GridObj.getColIndexById("ORDER_NAME")).getValue();
	document.main.TAKE_USER_NAME.value 	= GridObj.cells(grid_array[0], GridObj.getColIndexById("TAKE_USER_NAME")).getValue();
	document.main.TAKE_USER_ID.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("TAKE_USER_ID")).getValue();
	document.main.CTR_DATE.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("CTR_DATE")).getValue();
	document.main.TAKE_TEL.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("TAKE_TEL")).getValue();
	document.main.REMARK.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("REMARK")).getValue();
	document.main.CTR_NO.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("CTR_NO")).getValue();
	document.main.CONTRACT_FROM_DATE.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("CONTRACT_FROM_DATE")).getValue();
	document.main.CONTRACT_TO_DATE.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("CONTRACT_TO_DATE")).getValue();
	document.main.SIGN_PERSON_ID.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("SIGN_PERSON_ID")).getValue();
	document.main.PO_TYPE.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("PO_TYPE")).getValue();
	document.main.SHIPPER_TYPE.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("SHIPPER_TYPE")).getValue();
	document.main.DP_PAY_TERMS.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("DP_PAY_TERMS")).getValue();
	document.main.vncp_user_name.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("vncp_user_name")).getValue();
	document.main.vncp_mobile_no.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("vncp_mobile_no")).getValue();
	document.main.vncp_email.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("vncp_email")).getValue();
	document.main.ADD_USER_ID.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("ADD_USER_ID")).getValue();
	document.main.ADD_USER_NAME.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("ADD_USER_NAME")).getValue();
	document.main.PURCHASER_ID.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("PURCHASER_ID")).getValue();
	document.main.PURCHASER_NAME.value = GridObj.cells(grid_array[0], GridObj.getColIndexById("PURCHASER_NAME")).getValue();

	document.main.VENDOR_CODE.value = vendor_code;
	document.main.CUR.value = wise.GetCellValue("CUR", t_row);
	document.main.EXEC_AMT_KRW.value = exec_amt_krw;
	document.main.EXEC_NO.value = exec_no;
	document.main.PO_DIV_FLAG.value = po_div_flag;
	document.main.EXEC_SEQ.value =exec_seq;
	document.main.POPUP_FLAG.value ="N";
	document.main.EXEC_NUMBER.value = exec_number;
	document.main.action = "po_insert.jsp";
	document.main.submit();
}

//일괄발주(개별)
function poCreateAll() {
	if (!checkUser()) return;
	
	var wise = GridObj;
	var rowCount = wise.GetRowCount();
	var vendor_code = "";
	var exec_no = "";
	var exec_seq = "";
	var item_seq = "";
	var dp_div = "";
	var cont_percent = "";
	var t_row =0;
	var t_check =0;
	var exec_amt_krw =0;
	var po_check	= 0;
	var po_div_flag = "";
	var purchaser_flag = "";
	var exec_number = "";
	var chk_own_go = 0;
	var grid_array = getGridChangedRows(GridObj, "SEL");
	var iCheckedCount = 0;
	
	
	if(grid_array.length == 0){ // 선택된 로우가 없을 경우
		alert(G_MSS1_SELECT);
		return;
    }

	if(!confirm("일괄발주(개별) 하시겠습니까?")) return;
    
	var params ="mode=setPoInsertAll&cols_ids="+grid_col_id;
	params+=dataOutput();	
 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.po_insert",params);
    sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
}

// 직무권한 체크
function checkUser() {

	var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	var flag = true;

	for(var row=0; row<GridObj.GetRowCount(); row++) {
		if("true" == GD_GetCellValueIndex(GridObj,row, IDX_SEL)) {
			for( i=0; i<ctrl_code.length; i++ )
			{
				if(ctrl_code[i] == GD_GetCellValueIndex(GridObj,row, IDX_CTRL_CODE)) {
					flag = true;
					break;
				} else
					flag = false;
			}
		}
	}

	if (!flag)
		alert("작업을 수행할 권한이 없습니다.");
	return flag;
}

function checkRows()
{
	var grid_array = getGridChangedRows(GridObj, "SEL");

	if(grid_array.length > 0)
	{
		return true;
	}

	alert("선택된 행이 없습니다.");
	return false;
}

//발주취소(연단가)
function yrpoCancel() {
	/*
	var iCheckedRow = Number(checkedOneRow('SEL'))-1;
    if(iCheckedRow < 0)
        return;
    */
	    
	var grid_array  = getGridChangedRows(GridObj, "SEL");
	if(grid_array.length == 0){ // 선택된 로우가 없을 경우
		alert(G_MSS1_SELECT);
		return;
    }
    for(var i = 0; i < grid_array.length; i++)
	{
    	if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("YR_UNIT_PR_ORD_GB")).getValue()) != "Y"){
    		alert("연단가발주 대상이 아닙니다.\r\n\r\n기안번호 : "+LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EXEC_NO")).getValue())+"\r\n기안번명 : "+LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SUBJECT")).getValue()));
    		return;SUBJECT
    	}
   	}  
    /*
	if(wise.GetCellValue("YR_UNIT_PR_ORD_GB",iCheckedRow) != "Y"){
		alert("연단가발주 대상이 아닙니다.");
		return;
	}
	*/	
	if(!confirm("발주취소(연단가) 처리를 하시겠습니까?")) return;

	var params ="mode=setPoCancel&cols_ids="+grid_col_id;
	 	params+=dataOutput();	
	 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.po_insert",params);
	    sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
}

//발주취소(기안생성)
function expoCancel() {

	if (!checkUser()) return;

	var grid_array  = getGridChangedRows(GridObj, "SEL");
	var wise 		= GridObj;

	var iCheckedRow = Number(checkedOneRow('SEL'))-1;
    if(iCheckedRow < 0)
        return;
    
	if(wise.GetCellValue("YR_UNIT_PR_ORD_GB",iCheckedRow) == "Y"){
		alert("기안생성 발주건에 대해 취소 가능합니다.");
		return;
	}
		
	if(!confirm("발주취소(기안생성) 처리를 하시겠습니까?")) return;

	var params ="mode=setExPoCancel&cols_ids="+grid_col_id;
	 	params+=dataOutput();	
	 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.po_insert",params);
	    sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
}
		
function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
	if(msg1 == "doQuery") {
		/* GridObj.SetGroupMerge("VENDOR_CODE,VENDOR_NAME,PR_NO,EXEC_NO,SUBJECT,SIGN_DATE,CTR_NO"); */
	}

	if(msg1 == "doData")
	{

	}
	if(msg1 == "t_insert") {
		if(msg3 == IDX_SEL)
		{
			selectCond(GridObj, msg2);
		}
	}

	if(msg1 == "t_imagetext") {
		if(msg3==IDX_VENDOR_CODE) {
			if(msg4==""){
				alert("업체가 없습니다.");
				return;
			}
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+msg4,"ven_bd_con","left=0,top=0,width=900,height=700,resizable=yes,scrollbars=yes");
	    }else if(msg3==IDX_VENDOR_NAME) {
			if(msg4==""){
				alert("업체가 없습니다.");
				return;
			}
			var vendor_code = GridObj.GetCellValue("VENDOR_CODE",msg2);
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+vendor_code,"ven_bd_con","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
	    }else if(msg3 == IDX_ITEM_NO){
			var pr_type = GridObj.GetCellValue("PR_TYPE",msg2);
			//if(pr_type=="상품")
				window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			//else
			//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
		}else if(msg3 == IDX_DESCRIPTION_LOC){
			var pr_type = GridObj.GetCellValue("PR_TYPE",msg2);
			var item_no = GridObj.GetCellValue("ITEM_NO",msg2);
			//if(pr_type=="상품")
				window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			//else
			//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
		}else if(msg3 == IDX_EXEC_NO) {
			var pr_type_code = GridObj.GetCellValue("PR_TYPE_CODE",msg2);
			//window.open("/kr/dt/app/app_pp_dis2.jsp?exec_no="+msg5,"execwin","left=0,top=0,width=1024,height=650,resizable=yes,scrollbars=yes, status=yes");
			//window.open("/kr/dt/app/app_bd_ins1.jsp?exec_no="+msg5+"&pr_type="+pr_type_code+"&editable=N&req_type=P","execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
			window.open("/kr/dt/app/app_bd_ins1.jsp?exec_no="+msg5+"&pr_type=I&editable=N&req_type=P","execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
		}else if(msg3 == IDX_PR_NO){
			window.open("/kr/dt/pr/pr1_bd_dis1.jsp?pr_no="+msg4,"pr1_bd_dis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
		}
	}

}
function selectCond(wise, selectedRow)
{
	var wise = GridObj;
	var cur_vendor_code  = GD_GetCellValueIndex(wise,selectedRow, IDX_VENDOR_CODE);
	var cur_exec_no  	 = GD_GetCellValueIndex(wise,selectedRow, IDX_EXEC_NO);
	var cur_dp_div  	 = GD_GetCellValueIndex(wise,selectedRow, IDX_DP_DIV);
	var iRowCount   	 = wise.GetRowCount();
	for(var i=0;i<iRowCount;i++)
	{
		if(i==selectedRow)
			continue;
		if(cur_exec_no == GD_GetCellValueIndex(wise,i,IDX_EXEC_NO)&&cur_vendor_code == GD_GetCellValueIndex(wise,i,IDX_VENDOR_CODE))
		{
			var flag = "true";

			if(GD_GetCellValueIndex(wise,i,IDX_SEL) == "true")
				flag = "false";
				if(cur_dp_div != GD_GetCellValueIndex(wise,i,IDX_DP_DIV)){
				 	GD_SetCellValueIndex(wise,i,IDX_SEL, "true" + "&","&");
				}else{
					GD_SetCellValueIndex(wise,i,IDX_SEL,flag + "&","&");
				}

		}else{
			var flag = "false";
			GD_SetCellValueIndex(wise,i,IDX_SEL,flag + "&","&");
		}
	}
}
function add_from_date(year,month,day,week)
{
	document.form1.from_date.value=year+month+day;
}
function add_to_date(year,month,day,week)
{
	document.form1.to_date.value=year+month+day;
}
function PopupManager(part)
{
	var url = "";
	var f = document.forms[0];

	if(part == "DEMAND_DEPT")
	{
		window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	
	if(part == "ADD_USER_ID")
	{
		window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	//구매담당직무
	if(part == "CTRL_CODE")
	{
		PopupCommon2("SP0216","getCtrlManager","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","직무코드","직무명");
	}
	
	if(part == "CTRL_PERSON")
	{
		var arrValue = new Array();
		arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
		arrValue[1] = "<%=info.getSession("COMPANY_CODE")%>";
		arrValue[2] = "P";

		PopupCommonArr("SP0071","getCtrlPerson",arrValue,"");
	}
	
	if(part == "ctrl_person_id") {
		window.open("/common/CO_008.jsp?callback=getCtrlUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
}

function getCtrlUser(code, text) {
	document.form1.ctrl_person_id.value = code;
	document.form1.ctrl_person_name.value = text;
}

//구매담당직무
function getCtrlManager(code, text)
{
	document.form1.ctrl_code.value = code;
	document.form1.ctrl_name.value = text;
}
function getDemand(code, text)
{
	document.forms[0].demand_dept_name.value = text;
	document.forms[0].demand_dept.value = code;
}

function getAddUser(code, text)
{
	document.forms[0].add_user_name.value = text;
	document.forms[0].add_user_id.value = code;
}


function getCtrlPerson(ls_ctrl_code, ls_ctrl_name, ls_ctrl_person_id, ls_ctrl_person_name)
{
	document.forms[0].ctrl_code.value = ls_ctrl_code;
	document.forms[0].ctrl_name.value = ls_ctrl_name;
	document.forms[0].ctrl_person_id.value = ls_ctrl_person_id;
	document.forms[0].ctrl_person_name.value = ls_ctrl_person_name;
}
//담당자
<%-- function SP0071_Popup() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0071&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=P";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
} --%>

function  SP0071_getCode(ls_ctrl_code, ls_ctrl_name, ls_ctrl_person_id, ls_ctrl_person_name) {

	document.forms[0].ctrl_code.value = ls_ctrl_code;
	document.forms[0].ctrl_name.value = ls_ctrl_name;
	document.forms[0].ctrl_person_id.value = ls_ctrl_person_id;
	document.forms[0].ctrl_person_name.value = ls_ctrl_person_name;
}

//***** Enter Key를 눌렀을때 Event발생 *****//
function entKeyDown()
{
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        doQuery();
    }
}

//-->
</Script>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	<%=grid_obj %>_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
	var header_name = GridObj.getColumnId(cellInd);
		
	if(header_name=="EXEC_NO") {
		var exec_no	    = LRTrim(GridObj.cells(rowId, IDX_EXEC_NO).getValue());  
		var pr_type	    = LRTrim(GridObj.cells(rowId, IDX_PR_TYPE).getValue());	
		var req_type	= "P";	//LRTrim(GridObj.cells(rowId, IDX_REQ_TYPE).getValue());	
		var sign_status = "E";
		var edit = "N";
		var aurl  = "/kr/dt/app/app_bd_ins1.jsp?exec_no="+exec_no+ "&pr_type=" + pr_type + "&editable=N&req_type="+req_type;
		window.open(aurl,"execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
	}
	
	if(header_name=="ITEM_NO") {
		var itemNo	= LRTrim(GridObj.cells(rowId, IDX_ITEM_NO).getValue()); 

		var burl        = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO=" + itemNo + "&BUY=";
		var PoDisWin   = window.open(burl, 'agentCodeWin', 'left=0, top=0, width=750, height=550, toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes');
		
		PoDisWin.focus();
	}
	
	if( header_name == "VENDOR_NAME" ) {//업체상세
		
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
		
		if(vendor_code != null && vendor_code != "") {
		
			var url    = '/s_kr/admin/info/ven_bd_con.jsp';
			var title  = '업체상세조회';
			var param  = 'popup=Y';
			param     += '&mode=irs_no';
			param     += '&vendor_code=' + vendor_code;
			popUpOpen01(url, title, '900', '700', param);
			
	  	}
		
	}

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
    
//     document.form1.from_date.value = add_Slash( document.form1.from_date.value );
//     document.form1.to_date.value   = add_Slash( document.form1.to_date.value   );
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}

//지우기
function doRemove( type ){
    if( type == "ctrl_person_id" ) {
    	document.forms[0].ctrl_person_id.value = "";
        document.forms[0].ctrl_person_name.value = "";
    }  
}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData,approvalCnt) {
	
	var wise                  = GridObj;
	var iRowCount             = wise.GetRowCount();
	var iCheckedCount         = 0;
	
	var sRptData = "";
	var rf = "<%=CommonUtil.getConfig("clipreport4.separator.field")%>";
	var rl = "<%=CommonUtil.getConfig("clipreport4.separator.line")%>";
	var rd = "<%=CommonUtil.getConfig("clipreport4.separator.data")%>";
	sRptData += document.form1.from_date.value;	//기안일자 from
	sRptData += " ~ ";
	sRptData += document.form1.to_date.value;	//기안일자 to
	sRptData += rf;
	sRptData += document.form1.exec_no.value;	//기안번호
	sRptData += rf;
	sRptData += document.form1.pr_no.value;	    //구매요청번호
	sRptData += rf;
	sRptData += document.form1.ctrl_person_name.value;	//구매담당자 2
	sRptData += " (";
	sRptData += document.form1.ctrl_person_id.value;	//구매담당자 1
	sRptData += ")";
	sRptData += rf;
	sRptData += document.form1.bid_type_c.options[document.form1.bid_type_c.selectedIndex].text;	//입찰구분
	sRptData += rd;
	for(var i = 0; i < iRowCount; i++){
		if(true == GD_GetCellValueIndex(wise, i, wise.getColIndexById("SEL"))){
			sRptData += GD_GetCellValueIndex(wise,i,wise.getColIndexById("VENDOR_NAME"));
			sRptData += rf;		
			sRptData += GD_GetCellValueIndex(wise,i,wise.getColIndexById("SUBJECT"));
			sRptData += rf;		
			sRptData += GD_GetCellValueIndex(wise,i,wise.getColIndexById("ITEM_NO"));
			sRptData += rf;		
			sRptData += GD_GetCellValueIndex(wise,i,wise.getColIndexById("DESCRIPTION_LOC"));
			sRptData += rf;		
			sRptData += GD_GetCellValueIndex(wise,i,wise.getColIndexById("ITEM_QTY"));
			sRptData += rf;		
			sRptData += GD_GetCellValueIndex(wise,i,wise.getColIndexById("UNIT_PRICE"));
			sRptData += rf;
			sRptData += GD_GetCellValueIndex(wise,i,wise.getColIndexById("ITEM_AMT"));
			sRptData += rf;
			sRptData += GD_GetCellValueIndex(wise,i,wise.getColIndexById("BR_NAME"));
			sRptData += rl;				
			iCheckedCount++;
		}
	}
	if(iCheckedCount<1) {
		alert("출력대상을 선택해 주세요.");		
		return;
	}
	
    document.form1.rptData.value = sRptData;
	
	if(typeof(rptAprvData) != "undefined"){
		document.form1.rptAprvUsed.value = "Y";
		document.form1.rptAprvCnt.value = approvalCnt;
		document.form1.rptAprv.value = rptAprvData;
    }
    var url = "/ClipReport4/ClipViewer.jsp";
	//url = url + "?BID_TYPE=" + bid_type;	
    var cwin = window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form1.method = "POST";
	document.form1.action = url;
	document.form1.target = "ClipReport4";
	document.form1.submit();
	cwin.focus();
}
</script>
</head>
<body onload="Init()" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">
<s:header>
	<%@ include file="/include/sepoa_milestone.jsp" %>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form1">
		<%--ClipReport4 hidden 태그 시작--%>
		<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
		<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
		<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="Y">
		<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
		<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
		<input type="hidden" name="rptAprv" id="rptAprv">		
		<%--ClipReport4 hidden 태그 끝--%>
		<input type="hidden" name="company_code" id="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr style="display:none;">
										<td width="15%" class="c_title_1">
											<img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 담당부서
										</td>
										<td class="c_data_1" width="35%" colspan="3">
											<input type="text" name="demand_dept" id="demand_dept" size="15" maxlength="6" class="inputsubmit" value=''  onkeydown="entKeyDown();">
											<a href="javascript:PopupManager('DEMAND_DEPT');"></a>
											<input type="text" name="demand_dept_name" id="demand_dept_name" size="20" class="input_data2" readonly value='' onkeydown="entKeyDown();">
										</td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기안일자</td>
										<td width="35%" class="data_td">
											<s:calendar id_to="to_date"  default_to="<%=to_date %>" id_from="from_date" default_from="<%=from_date %>" format="%Y/%m/%d"/>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기안번호</td>
										<td width="35%" class="data_td">
											<input type="text" name="exec_no" id="exec_no" style="width:95%;ime-mode:inactive" maxlength="20" onkeydown="entKeyDown();">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매요청번호</td>
										<td width="35%" class="data_td">
											<input type="text" name="pr_no" id="pr_no" style="width:95%;ime-mode:inactive" maxlength="20" class="inputsubmit" onkeydown="entKeyDown();">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매담당자</td>
										<td width="35%" class="data_td">
											<b>
												<input type="text" name="ctrl_person_id" id="ctrl_person_id" size="20" style="ime-mode:inactive"  value="<%=user_id%>" class="inputsubmit"  onkeydown='entKeyDown()' >
												<a href="javascript:PopupManager('ctrl_person_id')">
													<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
												</a>
												<a href="javascript:doRemove('ctrl_person_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
												<input type="text" name="ctrl_person_name" id="ctrl_person_name" size="20" class="input_data2" value="<%=info.getSession("NAME_LOC")%>"  onkeydown='entKeyDown()'  readOnly>
												<%-- 
												<input type="text" name="ctrl_person_id" id="ctrl_person_id" style="ime-mode:inactive" size="15" class="inputsubmit" value="<%=user_id%>"  onkeydown="entKeyDown();">
												<a href="javascript:PopupManager('CTRL_PERSON');">
													<img src="/images/ico_zoom.gif" align="absmiddle" border="0">
												</a>
												<a href="javascript:doRemove('ctrl_person_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
												<input type="text" name="ctrl_person_name" id="ctrl_person_name" size="20" class="input_data2" readOnly  value="<%=info.getSession("NAME_LOC")%>" onkeydown="entKeyDown();">
												--%>
											</b>
											<input type="hidden" name="ctrl_code" id="ctrl_code" size="5" maxlength="5" class="inputsubmit" readOnly value="">
											<input type="hidden" name="ctrl_name" id="ctrl_name" size="25" class="input_data2" readOnly >
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰구분</td>
      									<td width="20%" height="24" class="data_td" colspan="3">
									        <select id="bid_type_c" name="bid_type_c">
		        								<option value="">전체</option>
		        								<option value="D">구매입찰</option>
		        								<option value="C">공사입찰</option>
		        							</select>
		        						</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
    		<tr>
    			<td height="30" align="right">
            		<TABLE cellpadding="0">
                		<TR>
                        	<td><script language="javascript">btn("javascript:doQuery()", "조 회");</script></TD>
                        	<TD><script language="javascript">btn("javascript:clipPrint()","출 력");</script></TD>
							<TD><script language="javascript">btn("javascript:poCreate()", "발주생성");</script></TD>
							<TD><script language="javascript">btn("javascript:poCreateAll()", "일괄발주(개별)");</script></TD>
							<TD><script language="javascript">btn("javascript:yrpoCancel()", "발주취소(연단가)");</script></TD>
							<TD><script language="javascript">btn("javascript:expoCancel()", "발주취소(기안생성)");</script></TD>							
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
	<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="PO_001" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<!-- 발주서 작성 페이지 이동 -->
<form name="main" method="post">
	<input type="hidden" name="POPUP_FLAG" id="POPUP_FLAG" value="">
	<input type="text" name="VENDOR_CODE" id="VENDOR_CODE" value="">
	<input type="hidden" name="VENDOR_NAME" id="VENDOR_NAME" value="">
	<input type="hidden" name="SUBJECT" id="SUBJECT" value="">
	<input type="hidden" name="CTRL_CODE" id="CTRL_CODE" value="">
	<input type="hidden" name="PAY_TERMS" id="PAY_TERMS" value="">
	<input type="hidden" name="PAY_TERMS_DESC" id="PAY_TERMS_DESC" value="">
	<input type="hidden" name="PR_TYPE" id="PR_TYPE" value="">
	<input type="hidden" name="PR_TYPE_CODE" id="PR_TYPE_CODE" value="">
	<input type="hidden" name="ORDER_NO" id="ORDER_NO" value="">
	<input type="hidden" name="ORDER_NAME" id="ORDER_NAME" value="">
	<input type="hidden" name="CUR" id="CUR" value="">
	<input type="hidden" name="EXEC_AMT_KRW" id="EXEC_AMT_KRW" value="">
	<input type="hidden" name="TAKE_USER_NAME" id="TAKE_USER_NAME" value="">
	<input type="hidden" name="TAKE_USER_ID" id="TAKE_USER_ID" value="">
	<input type="hidden" name="CTR_DATE" id="CTR_DATE" value="">
	<input type="hidden" name="TAKE_TEL" id="TAKE_TEL" value="">
	<input type="hidden" name="REMARK" id="REMARK" value="">
	<input type="hidden" name="CTR_NO" id="CTR_NO" value="">
	<input type="hidden" name="CONTRACT_FROM_DATE" id="CONTRACT_FROM_DATE" value="">
	<input type="hidden" name="CONTRACT_TO_DATE" id="CONTRACT_TO_DATE" value=""> <input type="hidden" name="SIGN_PERSON_ID" id="SIGN_PERSON_ID" value=""> <input type="hidden" name="PO_TYPE" id="PO_TYPE" value="">
	<input type="hidden" name="SHIPPER_TYPE" id="SHIPPER_TYPE" value="">
	<input type="hidden" name="DP_PAY_TERMS" id="DP_PAY_TERMS" value="">
	<input type="hidden" name="vncp_user_name" id="vncp_user_name" value="">
	<input type="hidden" name="vncp_mobile_no" id="vncp_mobile_no" value="">
	<input type="hidden" name="vncp_email" id="vncp_email" value="">
	<input type="hidden" name="ADD_USER_ID" id="ADD_USER_ID" value="">
	<input type="hidden" name="ADD_USER_NAME" id="ADD_USER_NAME" value="">
	<input type="hidden" name="EXEC_NO" id="EXEC_NO" value="">
	<input type="hidden" name="PO_DIV_FLAG" id="PO_DIV_FLAG" value="">
	<input type="hidden" name="EXEC_SEQ" id="EXEC_SEQ" value="">
	<input type="hidden" name=PURCHASER_ID id="PURCHASER_ID" value="">
	<input type="hidden" name=PURCHASER_NAME id="PURCHASER_NAME" value="">
	<input type="text" name=EXEC_NUMBER id="EXEC_NUMBER" value="">
	
</form>
</body>
</html>