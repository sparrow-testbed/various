<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_241");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_241";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	
    request.setCharacterEncoding("utf-8");
	String HOUSE_CODE   = info.getSession("HOUSE_CODE");
	String COMPANY_CODE = info.getSession("COMPANY_CODE");

	String pr_type	 	= JSPUtil.nullToRef(request.getParameter("PR_TYPE"), "");
	String req_type 	= JSPUtil.nullToRef(request.getParameter("REQ_TYPE"), "");
	String create_type 	= JSPUtil.nullToRef(request.getParameter("CREATE_TYPE"), "");
	String shipper_type	= JSPUtil.nullToRef(request.getParameter("SHIPPER_TYPE"), "");
	String pr_name		= JSPUtil.nullToRef(request.getParameter("PR_NAME"), "");

	String PR_DATA     	= JSPUtil.nullToRef(request.getParameter("PR_DATA"), "");

	String re_pr_type  = pr_type;
	String SETTLE_TYPE = "DOC";

	if (pr_type.equals("S")) SETTLE_TYPE = "ITEM";
	if (pr_type.equals("S") && req_type.equals("P")) re_pr_type = "SS";

	String Subject = "";

    String LB_I_PAY_TERMS 	= ListBox(request, "SL0127", HOUSE_CODE+"#M010#"+shipper_type+"#", "");
	String LB_I_DELY_TERMS	= ListBox(request, "SL0018", HOUSE_CODE+"#M009", "");
	
	String PC_FLAG="";
	String pc_reason = "";
	
 	String WISEHUB_PROCESS_ID="RQ_241";
 	
	/**
	 * 전자결재 사용여부
	 */
// 	Config signConf = new Configuration();
	String sign_use_module = "";// 전자결재 사용모듈
	String pc_reasonDisable = "";
	boolean sign_use_yn = false;
	try {
		sign_use_module = CommonUtil.getConfig("wise.sign.use.module." + info.getSession("HOUSE_CODE")); //전자결재 사용모듈
	} catch(Exception e) {
		
		//out.println("에러 발생:" + e.getMessage() + "<br>");
		
		sign_use_module	= "";
	}
	StringTokenizer st = new StringTokenizer(sign_use_module, ";");
	while (st.hasMoreTokens()) {
		if ("RFQ".equals(st.nextToken())) {
			sign_use_yn = true;
		}
	}
	
	
	if(!PC_FLAG.equals("Y")){
		pc_reasonDisable = "disable";
	}

%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript" type="text/javascript">
var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
var eprow = 0;
var Arow = 0;

function replace_str(s){
	var arr = s.split("@#$");
	var r = "";

	for( i=0; i<arr.length;i++) {
		if( i != arr.length-1 ){
			r += arr[i]+"'";
		}
		else{
			r += arr[i];
		}
	}
	
	return r;
}

var mode									;
var explanation_modify_flag = "false"		;
var bid_Infor_modify_flag = "false"			;
var Current_Row								;
var poprow									;
var pc_reason                               ;
var pc_flag									;

var INDEX_SELECTED                 			;
var INDEX_ITEM_NO                			;
var INDEX_DESCRIPTION_LOC        			;
var INDEX_SPECIFICATION          			;
var INDEX_RFQ_QTY                			;
var INDEX_YEAR_QTY               			;
var INDEX_UNIT_MEASURE           			;
var INDEX_PURCHASE_PRE_PRICE     			;
var INDEX_RFQ_AMT                			;
var INDEX_RD_DATE                			;
var INDEX_ATTACH_NO              			;
var INDEX_ATTACH_NO_CNT            			;
var INDEX_VENDOR_SELECTED        			;
var INDEX_PRICE_DOC              			;
var INDEX_PLANT_CODE             			;
var INDEX_DELY_TO_LOCATION_NAME  			;
var INDEX_CHANGE_USER_NAME       			;
var INDEX_PR_NO                  			;
var INDEX_PR_SEQ                 			;
var INDEX_VENDOR_SELECTED_REASON 			;
var INDEX_COST_COUNT             			;
var INDEX_VENDOR_CNT             			;
var INDEX_DELY_TO_ADDRESS        			;
var INDEX_DELY_TO_LOCATION       			;
var INDEX_STR_FLAG               			;
var INDEX_PURCHASE_LOCATION      			;
var GB_CTRL_CODE = ""						;
var INDEX_Z_CODE1 							;
var INDEX_TECHNIQUE_GRADE    				;
var INDEX_TECHNIQUE_TYPE     				;
var INDEX_INPUT_FROM_DATE    				;
var INDEX_INPUT_TO_DATE  	 				;
var INDEX_HUMAN_VENDOR_CODE  	 			;
var INDEX_HUMAN_VENDOR_NAME 	 			;
var INDEX_MAKER_NAME 	 					;
var INDEX_PC_FLAG 	 						;
var INDEX_PC_REASON 	 					;	
	
function setHeader() {
	/* GridObj.SetDateFormat("INPUT_FROM_DATE",    "yyyy/MM/dd");
	GridObj.SetDateFormat("INPUT_TO_DATE",    "yyyy/MM/dd"); */
	
<%-- SetColHide javascript 에러 발생하여 주석처리
	if(document.form1.SHIPPER_TYPE.value == "O"){
		GridObj.SetColHide("EXCHANGE_RATE", false);
    	GridObj.SetColHide("RFQ_KRW_AMT", false);
    }
	else{
		GridObj.SetColHide("EXCHANGE_RATE", true);
		GridObj.SetColHide("RFQ_KRW_AMT", true);
	}
<%
	if(re_pr_type.equals("SS")){
%>
	GridObj.SetColHide("VENDOR_SELECTED", true);
<%
	}
%>
--%>

	INDEX_SELECTED                 	= GridObj.GetColHDIndex("SELECTED"			);
	INDEX_ITEM_NO                  	= GridObj.GetColHDIndex("ITEM_NO"				);
	INDEX_DESCRIPTION_LOC          	= GridObj.GetColHDIndex("DESCRIPTION_LOC"		);
	INDEX_SPECIFICATION            	= GridObj.GetColHDIndex("SPECIFICATION"		);
	INDEX_MAKER_NAME            	= GridObj.GetColHDIndex("MAKER_NAME"		);
	INDEX_RFQ_QTY                  	= GridObj.GetColHDIndex("RFQ_QTY"				);

	INDEX_CUR                  		= GridObj.GetColHDIndex("CUR"					);
	INDEX_REC_VENDOR_NAME          	= GridObj.GetColHDIndex("REC_VENDOR_NAME"		);

	INDEX_YEAR_QTY                 	= GridObj.GetColHDIndex("YEAR_QTY"			);
	INDEX_UNIT_MEASURE             	= GridObj.GetColHDIndex("UNIT_MEASURE"		);
	INDEX_PURCHASE_PRE_PRICE       	= GridObj.GetColHDIndex("PURCHASE_PRE_PRICE"	);
	INDEX_RFQ_AMT                  	= GridObj.GetColHDIndex("RFQ_AMT"				);
	INDEX_RD_DATE                  	= GridObj.GetColHDIndex("RD_DATE"				);

	INDEX_ATTACH_NO                	= GridObj.GetColHDIndex("ATTACH_NO"			);
	INDEX_ATTACH_NO_CNT            	= GridObj.GetColHDIndex("ATTACH_NO_CNT"		);
	INDEX_VENDOR_SELECTED          	= GridObj.GetColHDIndex("VENDOR_SELECTED"		);
	INDEX_PRICE_DOC                	= GridObj.GetColHDIndex("PRICE_DOC"			);
	INDEX_PLANT_CODE               	= GridObj.GetColHDIndex("PLANT_CODE"			);
	INDEX_GISUL_RFQ				 	= GridObj.GetColHDIndex("GISUL_RFQ"				);
	INDEX_DELY_TO_LOCATION_NAME    	= GridObj.GetColHDIndex("DELY_TO_LOCATION_NAME"	);

	INDEX_CHANGE_USER_NAME         	= GridObj.GetColHDIndex("CHANGE_USER_NAME"		);
	INDEX_PR_NO                    	= GridObj.GetColHDIndex("PR_NO"					);
	INDEX_PR_SEQ                  	= GridObj.GetColHDIndex("PR_SEQ"					);
	INDEX_VENDOR_SELECTED_REASON   	= GridObj.GetColHDIndex("VENDOR_SELECTED_REASON"	);
	INDEX_COST_COUNT               	= GridObj.GetColHDIndex("COST_COUNT"				);

	INDEX_VENDOR_CNT               	= GridObj.GetColHDIndex("VENDOR_CNT"				);
	INDEX_DELY_TO_ADDRESS          	= GridObj.GetColHDIndex("DELY_TO_ADDRESS"			);
	INDEX_DELY_TO_LOCATION         	= GridObj.GetColHDIndex("DELY_TO_LOCATION"		);
	INDEX_STR_FLAG		         	= GridObj.GetColHDIndex("STR_FLAG"				);
	INDEX_PURCHASE_LOCATION   	 	= GridObj.GetColHDIndex("PURCHASE_LOCATION"		);
	INDEX_Z_CODE1		         	= GridObj.GetColHDIndex("Z_CODE1"				);
	INDEX_SG_REFITEM				= GridObj.GetColHDIndex("SG_REFITEM"			);
	INDEX_TECHNIQUE_GRADE			= GridObj.GetColHDIndex("TECHNIQUE_GRADE"		);
	INDEX_TECHNIQUE_TYPE			= GridObj.GetColHDIndex("TECHNIQUE_TYPE"		);
	INDEX_HUMAN_NO  				= GridObj.GetColHDIndex("HUMAN_NO"			);
	INDEX_HUMAN_VENDOR_CODE 		= GridObj.GetColHDIndex("HUMAN_VENDOR_CODE"	);
	INDEX_HUMAN_VENDOR_NAME 		= GridObj.GetColHDIndex("HUMAN_VENDOR_NAME"	);
	INDEX_TECHNIQUE_GRADE 			= GridObj.GetColHDIndex("TECHNIQUE_GRADE"		);
	INDEX_TECHNIQUE_FLAG 			= GridObj.GetColHDIndex("TECHNIQUE_FLAG"		);
	INDEX_TECHNIQUE_TYPE 			= GridObj.GetColHDIndex("TECHNIQUE_TYPE"		);
	INDEX_INPUT_FROM_DATE			= GridObj.GetColHDIndex("INPUT_FROM_DATE"		);
	INDEX_INPUT_TO_DATE				= GridObj.GetColHDIndex("INPUT_TO_DATE"		);
	INDEX_RFQ_KRW_AMT				= GridObj.GetColHDIndex("RFQ_KRW_AMT"		);
	INDEX_PC_FLAG					= GridObj.GetColHDIndex("PC_FLAG"		);
	INDEX_PC_REASON					= GridObj.GetColHDIndex("PC_REASON"		);
	

	pre_Insert();

	doSelect();

	GridObj.strHDClickAction="sortmulti";
}

function doSelect() {
	var cols_ids = "<%=grid_col_id%>";
	var params   = "mode=prDTQuerySourcing";
	
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	GridObj.post( "/servlets/dt.rfq.rfq_bd_ins1", params );
	
	GridObj.clearAll(false);
}

//삭제 (wisetable상에서 row 감추기)
function doDelete() {
	rowcount = GridObj.GetRowCount();
	
	if(rowcount == 0){
		return;
	}

	rowcount = GridObj.GetRowCount()-1;
	checked_count = 0;
	confirm_flag = true;

	for(row=rowcount; row>=0; row--) {
		if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
			checked_count++;

			if(true == confirm_flag) {
				if(confirm("삭제 하시겠습니까?") != 1) {
					return;
				}
				confirm_flag = false;
			}
			
			GridObj.DeleteRow(row);
		}
	}

	if(checked_count == 0)  {
		alert(G_MSS1_SELECT);
		
		return;
	}

	rowcount = GridObj.GetRowCount()-1;
	
	if(rowcount < 1){
		return;
	}

	checked_count = 0;
	confirm_flag = true;
}

function checkData() {
	rowcount = GridObj.GetRowCount();
	checked_count = 0;
	
	return true;
}

//전송(P),저장(N)
function doSave(rfq_flag) {
	
	form1.rfq_flag.value = rfq_flag;

	var rfq_close_date = del_Slash(form1.rfq_close_date.value);
	
	if(GridObj.GetRowCount() == 0){
		return;
	}
	
	if(checkData() == false){
		return;
	}

	if(LRTrim(form1.subject.value) == "") {
		alert("견적요청명을 입력하셔야 합니다. ");
			
		return;
	}
	
	if(LRTrim(rfq_close_date) == "") {
		alert("견적마감일을 입력하셔야 합니다. ");
		
		return;
	}
	
	if(LRTrim(form1.RFQ_TYPE.value) == "") {
		alert("견적요청형태를 입력하셔야 합니다. ");
		
		return;
	}
	
	var close_date = parseInt(LRTrim(rfq_close_date)+LRTrim(form1.szTime.value)+LRTrim(form1.szMin.value));
	var today_date_str = "<%= SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4)%>";
	var today_date = parseInt(today_date_str);

	if( close_date <= today_date ){
		alert("견적마감일은 현재 시간 이후 시 등록가능합니다.");
		
		return;
	}

	if(eval(LRTrim(rfq_close_date)) == eval("<%=SepoaDate.getShortDateString()%>")) {
		var TIME = <%=SepoaDate.getShortTimeString().substring(0,4)%>;
		var fHour = LRTrim(form1.szTime.value);
		var fMin = LRTrim(form1.szTime.value);
			
		if (Number(form1.szMin.value) < 10){
			fMin = "0" + fMin.toString();
		}
		
		if(!IsNumber(IsTrimStr(form1.szMin.value)) || IsTrimStr(form1.szMin.value).length != 2) {
			alert("견적마감일이 유효하지 않습니다. ");
			
			form1.szMin.select();
			
			return;
		}
		
		if(parseInt(form1.szMin.value) > 59) {
			alert("견적마감일이 유효하지 않습니다. ");
			
			form1.szMin.select();
			
			return;
		}
	}

	if(!IsNumber(IsTrimStr(form1.szMin.value))  || IsTrimStr(form1.szMin.value).length != 2) {
		alert("견적마감일이 유효하지 않습니다. ");
		
		form1.szMin.select();
		
		return;
	}

	if(parseInt(form1.szMin.value) > 59) {
		alert("견적마감일이 유효하지 않습니다. ");
		
		form1.szMin.select();
		
		return;
	}
	
	/* if(form1.RFQ_TYPE.value=="PC"&&form1.pc_reason.value==""){
		alert("수의계약 사유를 작성 해 주십시오.");
		
		form1.pc_reason.select();
		
		return;
	} */
	
	if(LRTrim(form1.DELY_TERMS.value) == "") {
		alert("인도조건을 선택하셔야 합니다. ");
		
		return;
	}
	
	if(LRTrim(form1.PAY_TERMS.value) == "") {
		alert("지급조건을 선택하셔야 합니다. ");
		
		form1.PAY_TERMS.focus();
		
		return;
	}

	//사양설명회를 입력한경우
	var end_time = form1.end_time.value;//제안설명회 시분
	var szdate = form1.szdate.value
	var sz_date = szdate +""+end_time;
	var rfq_close_date = form1.rfq_close_date.value;
	var szTime = form1.szTime.value;
	var szMin = form1.szMin.value;
	var rfq_date = rfq_close_date.replace("/","") + "" + szTime + "" + szMin;
	rfq_date = rfq_date.replace("/","");
		
	if("true" == explanation_modify_flag) {
		
		if((rfq_date/sz_date)<1) {
			alert("제안설명회의 개최일은 견적마감일 이전이어야 합니다.");			
			return;
		}
		
	}
	
	var totUnitAmt = 0;
	var tempVendor = "";

	checked_count = 0;
	
	for(row=GridObj.GetRowCount()-1; row>=0; row--) {
		if( true == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)){
			checked_count++;

<%
	if(pr_type.equals("I")){
%>
			if("" == GD_GetCellValueIndex(GridObj,row, INDEX_RD_DATE)){
				alert("납기일자는 반드시 존재하여야 합니다..");
				
				return;
			}
			
			var rdDate = GD_GetCellValueIndex(GridObj,row, INDEX_RD_DATE);
			
			rdDate = rdDate.substr(0, 4) + "" + rdDate.substr(5, 2) + "" + rdDate.substr(8, 2);
			
			if( LRTrim(rfq_close_date) >= rdDate){
				alert("납기일자는 반드시 견적마감일 이후여야 합니다.");
				
				return;
			}
<%
	}
	else{
%>
			if(GD_GetCellValueIndex(GridObj,row, INDEX_INPUT_FROM_DATE) == ""){
				alert("투입시작일은 반드시 존재하여야 합니다..");
				
				return;
			}
			
			if(GD_GetCellValueIndex(GridObj,row, INDEX_INPUT_TO_DATE) == ""){
				alert("투입종료일은 반드시 존재하여야 합니다..");
				
				return;
			}
			
			if( eval(LRTrim(GD_GetCellValueIndex(GridObj,row, INDEX_INPUT_FROM_DATE))) >= eval(LRTrim(GD_GetCellValueIndex(GridObj,row, INDEX_INPUT_TO_DATE))) ){
				alert("투입종료일은 투입시작일 이후여야 합니다.");
				
				return;
			}
<%
	}
%>
			if(form1.RFQ_TYPE.value != "OP"){
				if("N" == GD_GetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED)){
					alert("업체선정을 반드시 해야합니다.");
					
					return;
				}
				
				if("" == GD_GetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED)) {
					alert("업체선정을 반드시 해야합니다.");
					
					return;
				}
				
				if(0 >= parseInt(GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_VENDOR_SELECTED),row))){
					alert("업체선정을 반드시 해야합니다.");
					
					return;
				}

				//견적건별일 경우 견적대상업체가 모두 동일해야 함
				if( form1.SETTLE_TYPE.value == "DOC" ){
					if( checked_count == 1 ){
						tempVendor = GD_GetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED_REASON);
					}
					else if( checked_count > 1 ){
						tempVendor2 = GD_GetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED_REASON);
						
						if( tempVendor != tempVendor2 ){
							alert("견적건별일 경우 견적대상업체가 모두 동일해야 합니다.");
							
							return;
						}
					}
				}
			}
			
			rfqQty = GD_GetCellValueIndex(GridObj,row, INDEX_RFQ_QTY);
			
			if(rfqQty == ""){
				alert("견적요청수량이 입력되지 않았습니다");
				
				return;
			}
<%
	if (req_type.equals("P")) { // 구매요청시 ( --> 사전지원인 경우는 수량 0 허용)
%>
			var irfqQty = eval(rfqQty);
			
			if(irfqQty <= 0){
				alert("견적요청수량이 0이거나 적습니다");
				
				return;
			}
<%
	}
%>
			rfqAmt = GD_GetCellValueIndex(GridObj,row, INDEX_RFQ_AMT);

			totUnitAmt += eval(rfqAmt);
		}
	}

	if(checked_count == 0)  {
		alert(G_MSS1_SELECT);
		
		return;
	}

	Approval(rfq_flag);
}


function Approval(sign_status) { // 결재요청='P'
	if (checkData() == false){
		return;
	}
	
	if (sign_status == "P") {
		document.forms[0].target = "childframe";
		document.forms[0].action = "/kr/admin/basic/approval/approval.jsp";
		document.forms[0].method = "POST";
		document.forms[0].submit();
	}
	else {
		getApproval(sign_status);
		
		return;
	}
}

function getApproval(approval_str) {
	if (approval_str == "") {
		alert("결재자를 지정해 주세요");
		
		return;
	}
	
	var rfq_flag = form1.rfq_flag.value;
	var Message = "";
	
	if(rfq_flag == "T"){
		Message = "임시저장 하시겠습니까?";
	}
	else if(rfq_flag == "P"){
		Message = "결재요청 하시겠습니까?";
	}
	else if(rfq_flag == "E"){
		Message = "업체에 견적요청 하시겠습니까?";
	}
		
	if(confirm(Message) != 1) {
		return;
	}

	form1.approval_str.value = approval_str;
	//document.attachFrame.setData();	//startUpload
	getApprovalSend(approval_str);
}

/**
 * Form 에 Input Name과 Value를 Hidden Type으로 세팅하여 되돌려줌
 * @param frm 
 * @param inputName
 * @param inputValue
 * @returns
 */
function fnFormInputSet(frm, inputName, inputValue) {
	var input = document.createElement("input");
	
	input.type  = "hidden";
	input.name  = inputName;
	input.id    = inputName;
	input.value = inputValue;
	
	//frm.appendChild(input);
	
	//return frm;
	return input;
}

/**
 * 동적 form을 생성하여 반환하는 메소드
 *
 * @param url
 * @param param
 * @param target
 * @return form
 */
function fnGetDynamicForm(url, param, target){
	var form           = document.createElement("form");
	var paramArray     = param.split("&");
	var i              = 0;
	var paramInfoArray = null;

	if((target == null) || (target == "")){
		target = "_self";
	}

	for(i = 0; i < paramArray.length; i++){
		paramInfoArray = paramArray[i].split("=");
		
		var input = fnFormInputSet(form, paramInfoArray[0], paramInfoArray[1]);

		form.appendChild(input);
	}

	form.action = url;
	form.target = target;
	form.method = "post";

	return form;
}

function getApprovalSend(approval_str){
	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_bd_ins1";
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var params     = getApprovalSendParam(approval_str);
	
	myDataProcessor = new dataProcessor(servletUrl, params);
	sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
// 	myDataProcessor = new dataProcessor(servletUrl + "?" + params);
// 	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
}

function getApprovalSendParam(approvalStr){
	var inputParam = "I_CREATE_TYPE=<%=create_type%>";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = "<%=grid_col_id%>";
	var params;

	inputParam = inputParam + "&I_RFQ_FLAG=" + document.getElementById("rfq_flag").value;
	inputParam = inputParam + "&I_PFLAG=" + approvalStr;
	inputParam = inputParam + "&I_SUBJECT=" + document.getElementById("subject").value;
	inputParam = inputParam + "&I_RFQ_CLOSE_DATE=" + document.getElementById("rfq_close_date").value;
	inputParam = inputParam + "&I_RFQ_CLOSE_TIME=" + document.getElementById("szTime").value + document.getElementById("szMin").value;
	inputParam = inputParam + "&I_PAY_TERMS=" + document.getElementById("PAY_TERMS").value;
	inputParam = inputParam + "&I_DELY_TERMS=" + document.getElementById("DELY_TERMS").value;
	inputParam = inputParam + "&I_SETTLE_TYPE=" + document.getElementById("SETTLE_TYPE").value;
	inputParam = inputParam + "&I_RFQ_TYPE=" + document.getElementById("RFQ_TYPE").value;
	inputParam = inputParam + "&I_PC_REASON=" + document.getElementById("pc_reason").value;
	inputParam = inputParam + "&I_REMARK=" + urlEncode(document.getElementById("remark").value);
	inputParam = inputParam + "&I_CTRL_CODE=" + ctrl_code[0];
	inputParam = inputParam + "&I_SZDATE=" + document.getElementById("szdate").value;
	inputParam = inputParam + "&I_START_TIME=" + document.getElementById("start_time").value;
	inputParam = inputParam + "&I_END_TIME=" + document.getElementById("end_time").value;
	inputParam = inputParam + "&I_HOST=" + document.getElementById("host").value;
	inputParam = inputParam + "&I_AREA=" + document.getElementById("area").value;
	inputParam = inputParam + "&I_PLACE=" + document.getElementById("place").value;
	inputParam = inputParam + "&I_NOTIFIER=" + document.getElementById("notifier").value;
	inputParam = inputParam + "&I_DOC_FRW_DATE=" + document.getElementById("doc_frw_date").value;
	inputParam = inputParam + "&I_RESP=" + document.getElementById("resp").value;
	inputParam = inputParam + "&I_COMMENT=" + document.getElementById("comment").value;
	inputParam = inputParam + "&I_SHIPPER_TYPE=" + document.getElementById("SHIPPER_TYPE").value;
	inputParam = inputParam + "&I_PR_TYPE=<%=pr_type%>";
	inputParam = inputParam + "&I_ATTACH_NO=" + document.getElementById("attach_no").value;
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=setRfqCreate";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	params += inputParam;
	
	body.removeChild(form);
	
	return params;
}

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
 */
/* function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
	var attach_key   = att_no;
	var attach_count = att_cnt;

	if (document.form1.attach_gubun.value == "wise"){
		GD_SetCellValueIndex(GridObj,Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");

		document.form1.attach_gubun.value="body";
	} else {
		var f = document.forms[0];
	    f.attach_no.value    = attach_key;
	    f.attach_count.value = attach_count;

	    var approval_str = f.approval_str.value;
	    getApprovalSend(approval_str);
	}
}
 */

 function pre_Insert() {
	document.form1.attach_count.value = '';
}
 
function valid_from_date(year,month,day,week) {
	document.form1.VALID_FROM_DATE.value=year+month+day;
}

function valid_to_date(year,month,day,week) {
	document.form1.VALID_TO_DATE.value=year+month+day;
}

function setT_rfq_no(tRfqNo) {
	var space = "";
	
	if (tRfqNo.length > 2) {
		space = "Y";
	}
	
	GD_SetCellValueIndex(GridObj,poprow, INDEX_GISUL_RFQ, G_IMG_ICON + "&"+space+"&"+tRfqNo+"", "&");
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

//업체선택 (화면맨아래)
function vendor_Select() {
	if(GridObj.GetRowCount() == 0){
		return;
	}
	
	rowselected=0;
	var cnt = 0;
	
	if(form1.RFQ_TYPE.value == "OP") {
		alert("공개견적에선 업체를 선정할 수 없습니다.");
		
		return;
	}
	
	for(row=0; row<GridObj.GetRowCount(); row++) {
		if(1 ==GridObj.GetCellValue(GridObj.GetColHDKey(INDEX_SELECTED),row)) {
			rowselected++;
			
			if(0 < parseInt(GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_VENDOR_SELECTED),row))) {
				cnt++;
			}
		}
	}

	if(rowselected < 1)	{
		alert(G_MSS1_SELECT);
		
		return;
	}
	
	if(cnt == 0) {
		openPopup("-1", "E",'');
	}
	else if(cnt > 0) {
		openPopup("-1", "A",'');
	}
}

function changeSETTLE_TYPE() {
		if(1 == form1.SETTLE_TYPE.selectedIndex) { //Doc
		}
}

function rfq_type_Changed() {
	if(form1.RFQ_TYPE.value == "OP") {
		alert("공개견적에서는 견적건별만 가능합니다.");
		form1.SETTLE_TYPE.selectedIndex = 1;
	}
	
	if(form1.RFQ_TYPE.value =="MA"){
		document.all.RFQ_TEXT.value ="선택시 내부 담당자가 견적서를 오프라인으로 받아서 담당자가 작성한다";
	}
	else{
		document.all.RFQ_TEXT.value ="선택시 업체가 견적서를 작성한다";
	}
}

function getCompany(szRow) {
	if("Y" == GD_GetCellValueIndex(GridObj,szRow, INDEX_VENDOR_SELECTED)) {
		return com_data = GD_GetCellValueIndex(GridObj,szRow, INDEX_VENDOR_SELECTED_REASON);
	}

	return;
}


function getAllCompany() {
	if(GridObj.GetRowCount() == 0){
		return;
	}

	var rowselected = 0;
	var value = "";
	var com_data = "";

	if(GridObj.GetRowCount() > 0) {
		for(row=0; row<GridObj.GetRowCount(); row++) {
			if(true == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) { // 선택한 아이템중에서
				rowselected++;

				if("" != GD_GetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED)) { // 업체가 선택된넘 중에서
					if(GD_GetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED) == value) {
						return;
					}
					else {
						value += GD_GetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED_REASON);
					}
				}
			}
		}
		
		var m_values = value.split("#"); // ex) BS57@우석정보@N@#BS58@바보정보@N@#BS59@등신정보@N@#BS58@바보정보@N@#
		var temp ="";

		for(i=0; i<m_values.length; i++) {
			if(m_values[i] != ""){
				var m_data_f = m_values[i].split("@");
				
				F_VENDOR_CODE = m_data_f[0];

				for(j=i+1; j<m_values.length; j++) {
					var m_data_s = m_values[j].split("@");
					
					S_VENDOR_CODE = m_data_s[0];

					if(LRTrim(F_VENDOR_CODE) == LRTrim(S_VENDOR_CODE)){
						m_values[j] = "";
					}
				}
			}
		}

		for(i=0; i<m_values.length; i++) {
			if(m_values[i] != ""){
				temp = temp + m_values[i] + "#";
			}
		}
		return temp;
	}
}

function openPopup(szRow, mode,SG_REFITEM) {
	if(GridObj.GetRowCount() == 0){
		return;
	}
	var shipper_type = document.forms[0].SHIPPER_TYPE.value;
	var url = "rfq_pp_ins2.jsp?mode=" + mode + "&szRow=" + szRow + "&shipper_type="+shipper_type+"&SG_REFITEM="+SG_REFITEM;
	window.open(url, "rfq_pp_ins2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=580,left=0,top=0");
}

function vendorInsert(szRow, VANDOR_SELECTED, SELECTED_COUNT) {
	var rowCount = GridObj.GetRowCount();
	var selected = null;
	
	if(szRow == "-1") {
		for(var row = 0; row < rowCount; row++) {
			selected = GD_GetCellValueIndex(GridObj, row, INDEX_SELECTED);
			
			if(true == selected) {
				GD_SetCellValueIndex(GridObj, row, INDEX_VENDOR_SELECTED,        SELECTED_COUNT + ""); 
				GD_SetCellValueIndex(GridObj, row, INDEX_VENDOR_SELECTED_REASON, VANDOR_SELECTED);
				GD_SetCellValueIndex(GridObj, row, INDEX_VENDOR_CNT,             SELECTED_COUNT + ""); 
			}
		}
	}
	else {
		GD_SetCellValueIndex(GridObj,szRow, INDEX_VENDOR_SELECTED,        SELECTED_COUNT + "");
		GD_SetCellValueIndex(GridObj,szRow, INDEX_VENDOR_SELECTED_REASON, VANDOR_SELECTED);
		GD_SetCellValueIndex(GridObj,szRow, INDEX_VENDOR_CNT,             SELECTED_COUNT + "");
	}
}

function getExplanation() {
	mode= "I";
	
	if("true" == explanation_modify_flag){
		mode= "IM";
	}
	
	cnt = GridObj.GetRowCount();

	if(cnt == 0 ) {
		alert("선택된 품목이 없습니다.");
			
		return;
	}

	if("I" == mode) {
		subject = form1.subject.value;
		
		if(cnt > 0){
			window.open('rfq_pp_ins1.jsp?mode=' + mode + '&subject=' + subject ,"rfq_pp_ins1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=720,height=400,left=0,top=0");
		}
	}
	else if("IM" == mode) {
		RFQ_NO = form1.rfq_no.value;
		SUBJECT = form1.subject.value;
		RFQ_COUNT = form1.rfq_count.value;
		SZDATE = form1.szdate.value;
		START_TIME = form1.start_time.value;

		END_TIME = form1.end_time.value;
		HOST = form1.host.value;
		AREA = form1.area.value;
		PLACE = form1.place.value;
		notifier = form1.notifier.value;

		doc_frw_date = form1.doc_frw_date.value;
		resp = form1.resp.value;
		comment = form1.comment.value;

		szurl = 'rfq_pp_ins1.jsp?mode=' + mode + '&RFQ_NO=' + RFQ_NO + '&SUBJECT=' + SUBJECT;
		szurl += '&RFQ_COUNT=' + RFQ_COUNT + '&SZDATE=' + SZDATE;
		szurl += '&START_TIME=' + START_TIME + '&END_TIME=' + END_TIME + '&HOST=' + HOST;
		szurl += '&AREA=' + AREA + '&PLACE=' + PLACE + '&notifier=' + notifier;
		szurl += '&doc_frw_date=' + doc_frw_date + '&resp=' + resp + '&comment=' + comment;

		if(cnt > 0){
			window.open(szurl,"rfq_pp_ins1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=720,height=400,left=0,top=0");
		}
	}
}

//사양설명회 POPUP(rfq_pp_ins1.jsp)에서 호출
function setExplanation(rfq_no, subject, rfq_count, szdate, start_time, end_time, host, area, place, notifier, doc_frw_date, resp, comment) {
	form1.rfq_no.value		 	= rfq_no;
	form1.subject.value		 	= subject;
	form1.rfq_count.value		= rfq_count;
	form1.szdate.value		 	= szdate;
	form1.start_time.value 		= start_time;

	form1.end_time.value	 	= end_time;
	form1.host.value			= host;
	form1.area.value 			= area;
	form1.place.value 		  	= place;
	form1.notifier.value 		= notifier;

	form1.doc_frw_date.value	= doc_frw_date;
	form1.resp.value 			= resp;
	form1.comment.value 		= comment;

	if(szdate == "") { // 사양설명회 삭제된 경우.
		explanation_modify_flag     = "false";
	} else {
		explanation_modify_flag     = "true";
	}
}

//청구검토목록 popup
function openPopup3() {
	window.open('rfq_pp_dis2.jsp' ,"windowopen3","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=800,height=500,left=0,top=0");
}

//원가내역서
function getPriceDoc(row) {
	eprow = row;
	epvalue = GD_GetCellValueIndex(GridObj,row, INDEX_PRICE_DOC);
	window.open('rfq_pp_ins5.jsp?value='+ epvalue ,"windowopen5","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=500,height=380,left=0,top=0");
}

//원가내?ぜ? SETTING
function setep(recvdata, cnt) {
	GD_SetCellValueIndex(GridObj,eprow, INDEX_PRICE_DOC, G_IMG_ICON + "&"+cnt+"&"+recvdata, "&");
	GD_SetCellValueIndex(GridObj,eprow, INDEX_COST_COUNT, cnt);
}

function rfq_close_date(year,month,day,week) {
	document.form1.rfq_close_date.value=year+month+day;
}

//인도조건, 결제조건 popup
function searchProfile(fc) {
	var shipper_type = document.forms[0].SHIPPER_TYPE.value;
	
	if (fc == 'pay_method' ) {
		var arrv = new Array("<%=info.getSession("HOUSE_CODE")%>", shipper_type);
		
		PopupCommonArr("SP9134", "getpay_method", arrv, "" );
	}
	else if(fc == "dely_terms" ) {
		var arrv = new Array("<%=info.getSession("HOUSE_CODE")%>", shipper_type);
		
		PopupCommonArr("SP0232", "getdely_terms", arrv, "" );
	}
}

function getpay_method(code, text2) {
	document.forms[0].PAY_TERMS.value = code;
	document.forms[0].TXT_PAY_TERMS.value = text2;
}

function getdely_terms(code, text2) {
	document.forms[0].DELY_TERMS.value = code;
	document.forms[0].TXT_DELY_TERMS.value = text2;
}

function checkMin(sFilter) {
	var sKey = String.fromCharCode(event.keyCode);
	var re = new RegExp(sFilter);

	// Enter는 키검사를 하지 않는다.
	if(sKey != "\r" && !re.test(sKey)) {
		event.returnValue = false;
	}

	if (form1.szMin.value.length == 0) {
		if (parseInt(sKey) > 5){
			event.returnValue = false;
		}
	}
}

function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	if(msg1 == "doQuery"){
		pc_reason=GridObj.GetCellValue("PC_REASON",0);
		pc_flag=GridObj.GetCellValue("PC_FLAG",0);
		
		if(pc_flag=="Y"){
			for(var i = 0 ; i < form1.RFQ_TYPE.length ; i++){
				if(form1.RFQ_TYPE.options[i].value == 'PC'){
					form1.RFQ_TYPE.options[i].selected = true ;
				}
			}
			
			form1.pc_reason.value = pc_reason;
			form1.pc_reason.disabled = false;
		}
		
		//전체 선택
		selectAll();
		
	}
	
	if(msg1 == "t_imagetext") {
		if(msg3 == INDEX_VENDOR_SELECTED) { //업체선택
			
			alert(GridObj.GetRowCount());
			if(GridObj.GetRowCount() == 0){
				return;
			}
		
			if(form1.RFQ_TYPE.value == "OP") {
				alert("공개견적에선 업체를 선정할 수 없습니다.");
				
				return;
			}

			var settleType = form1.SETTLE_TYPE.value;
			
			if(settleType == "DOC"){   //견적건별이라면 모든품목에 대해 동일한 업체가 선택되어야 한다.
				vendor_Select();
			}
			else{
				openPopup(msg2, "I", GridObj.GetCellValue("SG_REFITEM",msg2));
			}
		}
		else if(msg3 == INDEX_PRICE_DOC) { // 원가내역서
			if(form1.RFQ_TYPE.value == "OP") {
				alert("공개견적에서는 원가내역을 입력할 수 없습니다.");
				
				return;
			}
		
			getPriceDoc(msg2);

		}
		else if(msg3 == INDEX_ITEM_NO) { //품목
			var BUYER_ITEM_NO = GD_GetCellValueIndex(GridObj,msg2, INDEX_ITEM_NO);
			var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2, INDEX_ITEM_NO);
			
			if ( BUYER_ITEM_NO != "") {
				POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+ITEM_NO, "mat_pp_ger1", '0', '0', '800', '700');
			}
		} //file
		else if(msg3 == INDEX_ATTACH_NO){
			var ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ATTACH_NO));
			
			Arow = msg2;
			
			document.form1.attach_gubun.value = "wise";

			//rMateFileAttach('P','C','RFQ',ATTACH_NO_VALUE);
		}
		else if(msg3 == INDEX_GISUL_RFQ) { //기술견적내역
			openPopup7(msg2);
		}
	}
	else if(msg1 == "doData") { // 전송/저장시 Row삭제
		opener.doSelect();
		window.close();
		
		/*
		if("1" == GridObj.GetStatus()) {
			for(row=GridObj.GetRowCount()-1; row>=0; row--) {
				if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
					GridObj.DeleteRow(row);
				}
			}
			
			opener.doSelect();
			window.close();
		}
		*/
	}
	else if(msg1 == "t_insert") { //
		if(msg3 == INDEX_RD_DATE) {
			se_rd_date  = GD_GetCellValueIndex(GridObj,msg2, INDEX_RD_DATE);
			
			var  rfq_close_date_val = form1.rfq_close_date.value;
			
			if(rfq_close_date_val == "") {
				alert("견적마감일을 먼저 입력하세요");
				
				return;
			}
			
			if(!checkDateCommon(form1.rfq_close_date.value)){
				document.forms[0].rfq_close_date.select();
				
				alert("견적마감일을 확인하세요.");
				
				return;
			}

			if(se_rd_date <= rfq_close_date_val ) {
				alert("납기요청일은 견적마감일 이후여야 합니다."  );
				
				GD_SetCellValueIndex(GridObj,msg2, INDEX_RD_DATE, msg4);
			}
		}
	
		if(msg3 == INDEX_PURCHASE_PRE_PRICE || msg3 == INDEX_RFQ_QTY) {
			alert("1182");
			for(var x=0; x<GridObj.GetRowCount(); x++) {
				var tmp_amt = GD_GetCellValueIndex(GridObj,x, INDEX_PURCHASE_PRE_PRICE);
				var tmp_qty = GD_GetCellValueIndex(GridObj,x, INDEX_RFQ_QTY);

				if(isNull(tmp_amt)){
					tmp_amt = 0;
				}
				
				if(isNull(tmp_qty)){
					tmp_qty = 0;
				}
                    
				GD_SetCellValueIndex(GridObj,x, INDEX_RFQ_AMT, setAmt( (eval(tmp_amt) * eval(tmp_qty)) + '' ));
			}
		}
	}
	else if(msg1 == "t_header") {
		if(msg3 == INDEX_RD_DATE) {
			copyCell(GridObj, INDEX_RD_DATE, "t_date");
		}
	}
}



function openPopup7(row) {
	poprow =row
	var tRfq_no = GD_GetCellValueIndex(GridObj,row, INDEX_GISUL_RFQ);
	window.open('rfq_pp_ins8.jsp?tRfq_no='+tRfq_no ,"windowopen7","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=500,height=380,left=0,top=0");
}
	
function reason(obj){
	if(obj.value != "PC"){ // 수의계약이 아닐 경우
		document.forms[0].pc_reason.value = "";
		document.forms[0].pc_reason.disabled = true;
	}
	else{
		document.forms[0].pc_reason.value = pc_reason;
		document.forms[0].pc_reason.disabled = false;
	}
}	

function cal_length(obj){
	document.forms[0].TWIT_LEN.value = obj.value.length ;

	if( obj.value.length > 140) {
		alert("트위터 등록은 140 BYTE를 초과 할 수 없습니다");
		
		document.forms[0].TWIT.value = obj.value.substring(0,138);
	}
}

function setTwit(tmsg){
	var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
	
	xmlHTTP.open("POST", "/kr/dt/bidd/twitter.jsp?TWIT=" + tmsg, false);

	xmlHTTP.send();

	if (xmlHTTP.status == 200 && xmlHTTP.responseXml.text == "1"){}
	else{
		return xmlHTTP.responseText;
	}
}

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
    var INDEX_RFQ_QTY            = GridObj.getColIndexById("RFQ_QTY");				//파일첨부
    var INDEX_PURCHASE_PRE_PRICE = GridObj.getColIndexById("PURCHASE_PRE_PRICE");	//업체선택
    
    if(cellInd == INDEX_VENDOR_SELECTED){		//견적업체

		if(GridObj.GetRowCount() == 0) return;
			if(form1.RFQ_TYPE.value == "OP") {
				alert("공개견적에선 업체를 선정할 수 없습니다.");
				return;
		}

	    var settleType = form1.SETTLE_TYPE.value;
	    if(settleType == "DOC"){   //견적건별이라면 모든품목에 대해 동일한 업체가 선택되어야 한다.
	        vendor_Select();
	    }else{
	    	openPopup(msg2, "I", GridObj.GetCellValue("SG_REFITEM",msg2));
		}

	} else if(cellInd == INDEX_PRICE_DOC) { // 원가내역서
		if(form1.rfq_type.value == "OP") {
			alert("공개견적에서는 원가내역을 입력할 수 없습니다.");
			return;
		}

		//getPriceDoc(msg2);
	} else if(cellInd == INDEX_ITEM_NO) { //품목
		var ITEM_NO = GridObj.cells(rowId, cellInd).getValue();	

		POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+ITEM_NO, "품목_일반정보", '0', '0', '800', '700');
	} else if(cellInd == INDEX_ATTACH_NO_CNT) {	//파일 첨부

		var ATTACH_NO_VALUE = GridObj.cells(rowId, INDEX_ATTACH_NO).getValue();			//LRTrim(GD_GetCellValueIndex(GridObj,rowId, INDEX_ATTACH_NO));
		//alert(ATTACH_NO_VALUE);
		Arow = rowId;
		document.form1.attach_gubun.value = "wise";

		goAttach(ATTACH_NO_VALUE);

/*
		if("" == ATTACH_NO_VALUE || "N" == ATTACH_NO_VALUE) {
			FileAttach('RFQ','','');
		} else {
			FileAttachChange('RFQ', ATTACH_NO_VALUE);
		}
*/
		//rMateFileAttach('P','C','RFQ',ATTACH_NO_VALUE);
	}
    
<%--    
		GD_CellClick(document.SepoaGrid,strColumnKey, nRow);

    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
	
}

function changeMoney(mon)
{
	var money = del_comma(mon);

	if(money == 0){
		alert("값을 입력하세요");
		return false;
	}
	if(isNaN(Number(del_comma(mon)))){
		alert("숫자로 입력하세요");
		
		return false;
	}
	if(money.length>13){
		alert("가용한 금액의 크기를 넘었습니다.");		
		return false;
	}
	if(money.indexOf(".")>=0){
		alert("정수로 입력하십시오");
		return false;
	}
	if(money.indexOf("-")>=0){
		alert("양수로 입력하십시오");
		return false;
	}
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
	var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
    	var INDEX_RFQ_QTY            = GridObj.getColIndexById("RFQ_QTY");				//요청수량
    	var INDEX_PURCHASE_PRE_PRICE = GridObj.getColIndexById("PURCHASE_PRE_PRICE");	//요청단가
    	var INDEX_RFQ_AMT            = GridObj.getColIndexById("RFQ_AMT");				//요청금액
    	
    	var rowIndex                 = GridObj.getRowIndex(GridObj.getSelectedId());
    	
		var header_name = GridObj.getColumnId(cellInd);
		
		if(header_name == "RFQ_QTY" || header_name == "PURCHASE_PRE_PRICE")   { 
    		if(changeMoney(GridObj.cells(rowId, cellInd).getValue() + "") == false){
	    		GridObj.cells(rowId, cellInd).setValue("");
				return true;
			}
    	}
            	
        if((cellInd == INDEX_RFQ_QTY) || (cellInd == INDEX_PURCHASE_PRE_PRICE)){
    		calculate_grid_amt(GridObj, rowIndex, INDEX_RFQ_QTY, INDEX_PURCHASE_PRE_PRICE, "1", "RFQ_AMT");
    	}
    	return true;
    }
    
    return false;
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj){
    var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode");
    var status   = obj.getAttribute("status");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }

    alert(messsage);
    
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
    if(status == "0"){
    	alert(msg);
    }
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    }
    
    return true;
}

/* 파일 업로드 */
/* function goAttach(attach_no){
	attach_file(attach_no,"RFQ");
} */
/* function setAttach(attach_key, arrAttrach, attach_count) {
	document.form1.attach_no.value = attach_key;
	document.form1.attach_no_count.value = attach_count;
}
 */
/* 
function setAttach(attach_key, arrAttrach, attach_count) {

	if(document.form1.attach_gubun.value == "wise"){
		//alert(Arow+"|"+attach_key+"|"+attach_count);
		GridObj.cells(Arow, INDEX_ATTACH_NO).setValue(attach_key);
		GridObj.cells(Arow, INDEX_ATTACH_NO_CNT).setValue(attach_count);
		
//		GD_SetCellValueIndex(document.WiseGrid,Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");
		//GD_SetCellValueIndex(GridObj, Arow, INDEX_ATTACH_NO, attach_key);
		//GD_SetCellValueIndex(GridObj, Arow, INDEX_ATTACH_NO_CNT, attach_count);
		
	} else {
		var f = document.forms[0];
	    f.attach_no.value    = attach_key;
	    f.attach_count.value = attach_count;
	}
	document.form1.attach_gubun.value="body";

} */
 
 var selectAllFlag = 0;
	<%
	/**
	 * @메소드명 : selectAll()
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 전체선택 > 전체선택되어 있는 경우 클릭하면 전체선택 해제
	 */
	%>
 function selectAll(){
		if(selectAllFlag == 0)
		{
			for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
			{
				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("1"); 
			}
			selectAllFlag = 1;
		}
		else
		{
			for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
			{
				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("0");
			}
		}
	}
 	function setApprovalButton(attach_count){
 		try{
			if(attach_count>0){
				document.getElementById("approvalButton1").style.display = "";
				document.getElementById("approvalButton2").style.display = "none";
			}else{
				document.getElementById("approvalButton1").style.display = "none";     
				document.getElementById("approvalButton2").style.display = "";
			}
 		}catch(e){
 			
 		}
 	}
 	
 	/*
 	첫번째 행의 납기가능일 모든 행에 일괄적용
 	*/
 	function setDeliveryData() {
 		
 		var RD_DATE = '';
 		
 		var iRowCount = GridObj.GetRowCount();
 		
 		for(var i = 0; i < iRowCount; i++) {
 			if(i == 0) {
 				RD_DATE = GD_GetCellValueIndex(GridObj, i, INDEX_RD_DATE);
 				
 			} else {
 				if(isEmpty(RD_DATE)){
 					alert('첫번째 행의 납기일자를 입력하십시오.');
 					return;
 				} else {
 					GD_SetCellValueIndex(GridObj,i, INDEX_RD_DATE, RD_DATE);				
 				}
 			}
 		}
 		
 	}
</script>
</head>
<body onload="javascript:setGridDraw();setHeader();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">
<s:header popup="true">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="left" class="title_page">견적요청생성</td>
		</tr>
	</table>
	
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>	

	<form name="form1" id="form1" action="">
		<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 시작--%>
		<input type="hidden" name="house_code" id="house_code" value="<%=info.getSession("HOUSE_CODE")%>">
		<input type="hidden" name="company_code" id="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
		<input type="hidden" name="dept_code" id="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
		<input type="hidden" name="req_user_id" id="req_user_id" value="<%=info.getSession("ID")%>">
		<input type="hidden" name="doc_type" id="doc_type" value="RQ">
		<input type="hidden" name="fnc_name" id="fnc_name" value="getApproval">
		<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 종료--%>
	
		<input type="hidden" name="rfq_no" id="rfq_no">
		<input type="hidden" name="rfq_count" id="rfq_count">
		<input type="hidden" name="szdate" id="szdate">
		<input type="hidden" name="start_time" id="start_time">
		<input type="hidden" name="end_time" id="end_time">
		<input type="hidden" name="host" id="host">
		<input type="hidden" name="area" id="area">
		<input type="hidden" name="place" id="place">
		<input type="hidden" name="notifier" id="notifier">
		<input type="hidden" name="doc_frw_date" id="doc_frw_date">
		<input type="hidden" name="resp" id="resp">
		<input type="hidden" name="comment" id="comment">
		<input type="hidden" name="dely_text" id="dely_text">
		<input type="hidden" name="attach_gubun" id="attach_gubun" value="body">
		<input type="hidden" name="rfq_flag" id="rfq_flag" value="">
		
		<input type="hidden" name="SHIPPER_TYPE" id="SHIPPER_TYPE" value="<%=shipper_type%>">
	
		<input type="hidden" name="att_mode" id="att_mode"  value="">
		<input type="hidden" name="view_type" id="view_type"  value="">
		<input type="hidden" name="file_type" id="file_type"  value="">
		<input type="hidden" name="tmp_att_no" id="tmp_att_no" value="">
		<input type="hidden" name="attach_count" id="attach_count" value="">
		<input type="hidden" name="approval_str" id="approval_str" value="">
		<input type="hidden" name="PR_DATA" id="PR_DATA" value="<%=PR_DATA%>"/>
		
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
	<td width="100%">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr style="display:none;">
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청번호</td>
				<td width="35%"  class="data_td">
					<input type="text" name="rfq_no" id="rfq_no" style="width:95%" class="input_data2" readonly>
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;차수</td>
				<td width="35%"  class="data_td"><input type="text" name="rfq_count" id="rfq_count" size="10" class="input_data2" readonly>
				</td>
			</tr>
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청명<font style="color: red;">*</font></td>
				<td width="35%" class="data_td">
					<input type="text" name="subject" id="subject" style="width:95%" class="input_re" value="<%=pr_name%>" onKeyUp="return chkMaxByte(500, this, '견적요청명');">
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적마감일</td>
				<td width="35%" class="data_td">
					<s:calendar id="rfq_close_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(), 1))%>" format="%Y/%m/%d"/>
					<select name="szTime" id="szTime" class="inputsubmit">
						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option>
						<option value="06">06</option>
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
						<option value="13">13</option>
						<option value="14">14</option>
						<option value="15">15</option>
						<option value="16">16</option>
						<option value="17">17</option>
						<option value="18">18</option>
						<option value="19">19</option>
						<option value="20">20</option>
						<option value="21">21</option>
						<option value="22">22</option>
						<option value="23" selected>23</option>
					</select>
					시
					<input type="text" name="szMin" id="szMin" size="2" maxLength="2" value="00" style="ime-mode:disabled" onKeyPress="checkMin('[0-9]')">
					분
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>			
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청형태<font style="color: red;">*</font></td>
				<td class="data_td" colspan="3">
					<table>
						<tr>
							<td>
								<select name="RFQ_TYPE" id="RFQ_TYPE" class="inputsubmit" onchange="reason(this)">
									<option value="">선택</option>
<%
	String  lb_rfq_type = ListBox(request, "SL0018",info.getSession("HOUSE_CODE") + "#" + "M112", "");
	out.println(lb_rfq_type);
%>
								</select>
							</td>
							<td height="10"><!-- &nbsp;사유 :  --><input type="hidden" name="pc_reason" id="pc_reason" size="100" class="input_data" value="" disabled="<%=pc_reasonDisable%>"/>
							</td>	
						</tr>
						<tr>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급조건<font style="color: red;">*</font></td>
				<td width="35%" class="data_td">
					<select name="PAY_TERMS" id="PAY_TERMS" class="input_re">
						<%=LB_I_PAY_TERMS %>
					</select>
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;인도조건<font style="color: red;">*</font></td>
				<td width="35%" class="data_td">
					<select name="DELY_TERMS" id="DELY_TERMS" class="input_re">
						<%=LB_I_DELY_TERMS %>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr style="display:none">	

				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;비교방식</td> 
				<td width="35%" class="data_td" colspan="3">
					<select name="SETTLE_TYPE" id="SETTLE_TYPE" class="inputsubmit"  ><!--onChange="javascript:changeSETTLE_TYPE();"  -->
<% 
	String settle = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#"+"M149", SETTLE_TYPE);

	out.println(settle);
%> 
					</select>
				</td> 
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;특기사항</td>
				<td class="data_td" colspan="3" height="150px">
					<table width="98%" >
						<tr>
							<td>
								<textarea name="remark" id="remark" class="inputsubmit" style="width: 98%; height: 140px" rows="5" onKeyUp="return chkMaxByte(4000, this, '특기사항');"></textarea>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
				<td class="data_td" colspan="3">
					<table><tr></tr><td>
					<script language="javascript">
					function setAttach(attach_key, arrAttrach, rowId, attach_count) {
						setApprovalButton(attach_count);
						document.getElementById("attach_no").value            = attach_key;
						document.getElementById("attach_no_count").value      = attach_count;
					}
						btn("javascript:attach_file(document.getElementById('attach_no').value, 'TEMP');", "파일등록");
					</script>
					</td><td>
					<input type="text" size="3" readOnly class="input_empty" value="0" name="attach_no_count" id="attach_no_count"/>
					<input type="hidden" value="" name="attach_no" id="attach_no">
					</td></table>
				</td>
			</tr>
			<tr id="TWIT_YN" style="display:none">
				<td width="15%" class="title_td">트위터 공고<br>(140 BYTE)
					<br><br>
					현재 : <input type="text" name="TWIT_LEN" id="TWIT_LEN" style="text-align:right" readOnly size="4" /> BYTE
				</td>
				<td class="data_td" colspan="3" height="200">
					<textarea name="TWIT" id="TWIT" style="ime-mode:active" rows="5" cols="95" rows="2" class="inputsubmit" onKeyUp="cal_length(this)"></textarea>
				</td>
			</tr>			
		</table>
	</td>
</tr>
</table>
</td>
</tr>
</table>
		
		
		
	</form>
	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		    <td height="30" align="left">
						<TABLE cellpadding="0" border="0">
							<TR>
								<TD><script language="javascript">
btn("javascript:setDeliveryData()", "납기일자 일괄적용");
</script></TD>
								<TD><font color="red" style="font-size: 10px">&nbsp;*
										납기일자<br>&nbsp;&nbsp;&nbsp;&nbsp;첫번째 행 기준으로
										일괄적용합니다.
								</font></TD>
							</TR>
						</TABLE>
					</td>
			<td height="30" align="right">
				<TABLE cellpadding="0">
					<TR>				
						<TD>
							<script language="javascript">
								btn("javascript:getExplanation()", "제안설명회");
							</script>
						</TD>
<%
	if(!re_pr_type.equals("SS")){
%>
						<TD>
							<script language="javascript">
								btn("javascript:vendor_Select()", "견적업체");
							</script>
						</TD>
<%
	}
%>
						<TD>
							<script language="javascript">
								btn("javascript:doSave('T')", "임시저장");
							</script>
						</TD>
<%
	if (sign_use_yn) {
%>
						<TD id="approvalButton1" style="display: none;">
							<script language="javascript">
								btn("javascript:doSave('P')", "결재요청");
							</script>
						</TD>
						
						<TD id="approvalButton2">
							<script language="javascript">
								btn("javascript:doSave('E')", "업체전송");
							</script>
						</TD>
<%
	}
	else{
%>
						<TD>
							<script language="javascript">
								btn("javascript:doSave('E')", "업체전송");
							</script>
						</TD>
<%
	}
%>
						<TD>
							<script language="javascript">
								btn("javascript:doDelete()", "행삭제");
							</script>
						</TD>
						<TD>
							<script language="javascript">
								btn("javascript:window.close()", "닫 기");
							</script>
						</TD>
					</TR>
				</TABLE>
			</td>
		</tr>
	</table>
	<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="RQ_241" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>