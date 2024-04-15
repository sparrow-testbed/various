<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%-- TOBE 2017-07-01 점코드 글로벌 상수 --%>
<%@  page import="sepoa.svc.common.constants" %>
<%! String gam_jum_cd = constants.DEFAULT_GAM_JUMCD; %>
<%! String ict_jum_cd = constants.DEFAULT_ICT_JUMCD; %>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AR_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AR_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG = "";
	String G_IMG_ICON = "";
	String WISEHUB_PROCESS_ID="AR_001";
	

	String ANN_VERSION = "";
	
	Object[] obj = new Object[1]; 
	
	SepoaOut value = ServiceConnector.doService(info, "BD_001", "CONNECTION","getBdAnnVersion", obj);
	
	SepoaFormater wf = new SepoaFormater(value.result[0]);
	
	if(wf.getRowCount() > 0) {
		ANN_VERSION = wf.getValue("CODE", 0);
	}
	
	
	String HOUSE_CODE 		 = info.getSession("HOUSE_CODE");
	String COMPANY_CODE 	 = info.getSession("COMPANY_CODE");
	String PURCHASE_LOCATION = info.getSession("PURCHASE_LOCATION");
	String CTRL_CODE 		 = info.getSession("CTRL_CODE");
	String user_name   	     = info.getSession("NAME_LOC");
	String user_id           = info.getSession("ID");
	String REQ_TYPE			 = JSPUtil.nullToRef(request.getParameter("REQ_TYPE"),"P");
	String LB_CREATE_TYPE	 = ListBox(request, "SL9997",  HOUSE_CODE+"#M113#B#", "");
	String ctrl_code         = info.getSession("CTRL_CODE");	
	String purchaser_id      = "";
	String purchaser_nm      = "";
%> 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>		
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript" type="text/javascript">
var mode;
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_bd_lis1";
var INDEX_SELECTED    		;
var INDEX_PR_NO       		;
var INDEX_SUBJECT    		;
var INDEX_ADD_USER_ID 		;
var INDEX_ADD_DATE       	;
var INDEX_SOURCING_TYPE   	;
var INDEX_ITEM_NO			;
var INDEX_DESCRIPTION_LOC   ;
var INDEX_PR_QTY      		;
var INDEX_UNIT_PRICE        ;
var INDEX_PR_AMT    		;
var INDEX_CTRL_CODE  		;
var INDEX_PR_PROCEEDING_FLAG;
var INDEX_PR_PROCEEDING		;
var INDEX_REMARK			;
var INDEX_ATTACH_NO			;
var INDEX_PR_TOT_AMT		;
var INDEX_PR_TYPE			;
var INDEX_PO_VENDOR_CODE	;
var INDEX_CUSTOMER_PRICE	;
var INDEX_CUSTOMER_AMT		;
var INDEX_PURCHASER_NAME	;

function setHeader(){
	var wise = GridObj;

	INDEX_SELECTED    		= wise.GetColHDIndex("SELECTED"    			);
	INDEX_PR_NO       		= wise.GetColHDIndex("PR_NO"       			);
	INDEX_SUBJECT    		= wise.GetColHDIndex("SUBJECT"    			);
	INDEX_ADD_USER_ID 		= wise.GetColHDIndex("ADD_USER_ID" 			);
	INDEX_ADD_DATE       	= wise.GetColHDIndex("ADD_DATE"       		);
	INDEX_SOURCING_TYPE   	= wise.GetColHDIndex("SOURCING_TYPE"       	);
	INDEX_ITEM_NO			= wise.GetColHDIndex("ITEM_NO"				);
	INDEX_DESCRIPTION_LOC   = wise.GetColHDIndex("DESCRIPTION_LOC"      );
	INDEX_PR_QTY      		= wise.GetColHDIndex("PR_QTY"      			);
	INDEX_UNIT_PRICE        = wise.GetColHDIndex("UNIT_PRICE"      		);
	INDEX_PR_AMT    		= wise.GetColHDIndex("PR_AMT"    			);
	INDEX_CTRL_CODE  		= wise.GetColHDIndex("CTRL_CODE"  			);
	INDEX_PR_PROCEEDING_FLAG= wise.GetColHDIndex("PR_PROCEEDING_FLAG"  	);
	INDEX_PR_PROCEEDING		= wise.GetColHDIndex("PR_PROCEEDING"	  	);
	INDEX_REMARK			= wise.GetColHDIndex("REMARK"	  			);
	INDEX_ATTACH_NO			= wise.GetColHDIndex("ATTACH_NO"	  		);
	INDEX_PR_TOT_AMT		= wise.GetColHDIndex("PR_TOT_AMT"	  		);
	INDEX_PR_TYPE			= wise.GetColHDIndex("PR_TYPE"	  			);
	INDEX_GO_FLAG			= wise.GetColHDIndex("GO_FLAG"				);
	INDEX_PO_VENDOR_CODE	= wise.GetColHDIndex("PO_VENDOR_CODE"		);
	INDEX_PO_VENDOR_NAME	= wise.GetColHDIndex("PO_VENDOR_NAME"		);
	INDEX_CUSTOMER_PRICE	= wise.GetColHDIndex("CUSTOMER_PRICE"		);
	INDEX_CUSTOMER_AMT		= wise.GetColHDIndex("CUSTOMER_AMT"			);
	INDEX_PURCHASER_ID		= wise.GetColHDIndex("PURCHASER_ID"		);
	INDEX_PURCHASER_NAME	= wise.GetColHDIndex("PURCHASER_NAME"		);

	//doSelect();
}

function doSelect(){
	var wise = GridObj;
    var f = document.form;
	
    f.start_change_date.value = del_Slash(f.start_change_date.value);
	f.end_change_date.value   = del_Slash(f.end_change_date.value);
	
	var from_date			= LRTrim(f.start_change_date.value);
    var to_date	    		= LRTrim(f.end_change_date.value);
    var pr_no	    		= LRTrim(f.pr_no.value);
    var ctrl_person_id		= LRTrim(f.ctrl_person_id.value);
    var pr_proceeding_flag 	= LRTrim(f.pr_proceeding_flag.value);
    var sourcing_type    	= LRTrim(f.sourcing_type.value);
    var demand_dept    		= LRTrim(f.demand_dept.value);
    var pr_flag    			= LRTrim(f.pr_flag.value);
    var req_type			= LRTrim(f.req_type.value);
    var create_type 		= LRTrim(f.create_type.value);

    if(from_date == "" || to_date == "" ) {
	    alert("생성일자를 입력하셔야 합니다.");
	    
	    return;
    }
    
    if(!checkDate(from_date)) {
	    alert("생성일자를 확인하세요.");
	    f.start_change_date.select();
	    
	    return;
    }
    
    if(!checkDate(to_date)) {
	    alert("생성일자를 확인하세요.");
	    f.end_change_date.select();
	    
	    return;
    }

    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getWaitList";
    
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);
}


function Create(){
	gw_bind_close();
	gw_bind_close2();
	
	if (!checkUser()){
		return;
	}
	
	var f = document.forms[0];
	var wbs_no = "";
	var pr_no = "";
	var preferred_bidder = "";
	var checkedCnt = 0;
	var pr_data = "";
	var po_vendor_code = "";
	var pre_cont_seq = "";
	var pre_cont_count = "";
	var gwStatusColIndex = GridObj.getColIndexById("GW_STATUS2");
	var gwStatusColValue = null;
	var isSoloProcess    = false;
	var sourcingTypeColIndex = GridObj.getColIndexById("SOURCING_TYPE");
	var sourcingTypeColValue = null;
	
	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			checkedCnt++;
			if(checkedCnt == 1){
				pr_no 			= GridObj.GetCellValue("PR_NO", i);
				wbs_no 			= GridObj.GetCellValue("WBS_NO", i);
				preferred_bidder= GridObj.GetCellValue("PREFERRED_BIDDER", i);
				po_vendor_code  = GridObj.GetCellValue("PO_VENDOR_CODE", i);
				pre_cont_seq    = GridObj.GetCellValue("PRE_CONT_SEQ", i);
				pre_cont_count  = GridObj.GetCellValue("PRE_CONT_COUNT", i);
			}

			rfq_type         = GridObj.GetCellValue("RFQ_TYPE", i);

			if(rfq_type == "CL"){
				alert("견적(예가산정)건은 기안생성이 안됩니다.");
				return;
			}
			/*
			if(wbs_no != GridObj.GetCellValue("WBS_NO", i)){
				alert("기안생성은 동일한 프로젝트만 가능합니다.");
				return;
			}
			*/
			//if(pr_no != GridObj.GetCellValue("PR_NO", i)){
			//	alert("기안생성은 동일한 구매요청만 가능합니다.");
			//	return;
			//}
			
			if(po_vendor_code != GridObj.GetCellValue("PO_VENDOR_CODE", i)){
				alert("기안생성은 동일한 업체만 가능합니다.");
				return;
			}
			
			if(preferred_bidder != GridObj.GetCellValue("PREFERRED_BIDDER", i)){
				alert("기안생성은 우선협상이 동일한 건만 가능합니다.");
				return;
			}
			
			sourcingTypeColValue = GD_GetCellValueIndex(GridObj, i, sourcingTypeColIndex);
			
			if(sourcingTypeColValue == "BID" || sourcingTypeColValue == "RFQ"){
				if("E" != GridObj.GetCellValue("PR_PROCEEDING_FLAG", i)){
					alert("기안생성은 진행상황이 기안대기 상태여야 합니다.");
					return;
				}
				
				if( document.forms[0].req_type.value == "P" ) {
					gwStatusColValue = GD_GetCellValueIndex(GridObj, i, gwStatusColIndex);
					
	 				if("E" != gwStatusColValue){
	 					
	 					alert("그룹웨어 품의 대상이 있습니다.");
	 					return;
	 				}
				}
			}
			
			if(GridObj.GetCellValue("MATERIAL_CLASS2", i) == "010200600060"){
				isSoloProcess = true;
			}
			
			pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i) + ",";
		}
	}
	if(checkedCnt == 0){
		alert("선택하신 항목이 없습니다.");
		return;
	}
	else{
		if((checkedCnt > 1) && isSoloProcess){
			alert("수입인지는 한건만 처리가 가능합니다.");
			
			return;
		}
	}

	var reqMsg = "기안생성 하시겠습니까?";
	if( document.forms[0].req_type.value == "B" ) {
		reqMsg = "완료 처리하시겠습니까?";
	} 	
	if(!confirm(reqMsg)){
		return;
	}


	f.pr_data.value = pr_data.substring(0, pr_data.length-1);

//	window.open("","execCreate","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
	if(document.forms[0].req_type.value == "B"){
		window.open("/kr/dt/app/app_bd_ins2.jsp?pre_cont_seq="+pre_cont_seq+"&pre_cont_count="+pre_cont_count+"&pr_data="+pr_data+"&req_type=" + $("#req_type").val(),"execCreate1","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
	}else{
		window.open("/kr/dt/app/app_bd_ins1.jsp?pre_cont_seq="+pre_cont_seq+"&pre_cont_count="+pre_cont_count+"&pr_data="+pr_data+"&req_type=" + $("#req_type").val(),"execCreate1","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
	}
// 	f.method              = "POST";
// 	f.target			  = "execCreate";
// 	f.action              = "/kr/dt/app/app_bd_ins1.jsp?pre_cont_seq="+pre_cont_seq+"&pre_cont_count="+pre_cont_count;    //?pr_no="+pr_no+"&remark="+remark+"&attach_no="+attach_no+"&pr_tot_amt="+pr_tot_amt+"&subject="+subject+"&pr_type="+pr_type+"&ctrl_code="+ctrl_code;
// 	f.submit();
}

/*
* 세션에 일을 처리할 권한이 있는지 체크!!
*/
// 직무권한 체크
function checkUser() {
	var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	var flag = true;

	for(var row=0; row<GridObj.GetRowCount(); row++) {
		if("true" == GD_GetCellValueIndex(GridObj,row,INDEX_SELECTED)) {
			for( i=0; i<ctrl_code.length; i++ )
			{
				if(ctrl_code[i] == GD_GetCellValueIndex(GridObj,row,INDEX_CTRL_CODE)) {
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

// 기안중단
function doReturn(flag) {
	gw_bind_close();
	gw_bind_close2();
	
	checked_count = 0;
	var email;
	var pr_name;
	rowcount = GridObj.GetRowCount();
	
	for(row=rowcount-1; row>=0; row--) {
		if( true == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
			email 	= " ";//GD_GetCellValueIndex(GridObj,row, INDEX_EMAIL);
			pr_name = GD_GetCellValueIndex(GridObj,row, INDEX_ADD_USER_ID);

			checked_count++;
		}
	}

	if(checked_count == 0)  {
		alert("선택하신 항목이 없습니다.");
		
		return;
	}
	
	mode = "reject";
	pMode = "doReturn_doc";
	msg = "기안중단 하시겠습니까?";
	
	if( !confirm(msg) ){
		return;
	}

	window.open('/kr/dt/pr/pr_pp_ins1.jsp?pMode='+pMode+'&email='+email+'&pr_name='+pr_name,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=580,height=340,left=0,top=0");
}//doReturn End

function setReason(memo,pReturn,reason_code,email,pr_name) {
	mode="reject";
	
	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.pr.pr5_bd_lis2";

	if(pReturn	== "doReturnO") {                       //외자반려
		GridObj.SetParam("mode", "reject");
		GridObj.SetParam("flag", "O");
		GridObj.SetParam("pTitle_Memo", memo);
		GridObj.SetParam("reason_code", reason_code);
		GridObj.SetParam("email", email);
		GridObj.SetParam("pr_name", pr_name);
		GridObj.SetParam("req_type", "P");
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
	}
	else if(pReturn	== "doReturn_doc") {                //반송
		document.getElementById("req_type").value    = "R";
		document.getElementById("pr_name").value     = pr_name;
		document.getElementById("email").value       = email;
		document.getElementById("reason_code").value = reason_code;
		document.getElementById("pTitle_Memo").value = memo;
		document.getElementById("flag").value        = "D";
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		
		params = "?mode=reject";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		
		myDataProcessor = new dataProcessor(servletUrl + params);
		
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
	}
	else if(pReturn	== "doDefer"){
		document.getElementById("req_type").value    = "Z";
		document.getElementById("pr_name").value     = pr_name;
		document.getElementById("email").value       = email;
		document.getElementById("reason_code").value = reason_code;
		document.getElementById("pTitle_Memo").value = memo;
		document.getElementById("flag").value        = "D";
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		params = "?mode=reject";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();

		myDataProcessor = new dataProcessor(servletUrl + params);

		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
	}
}//setReason End

/*
	1. t_imagetext - INDEX_RFQ_NO
	BID_TYPE에 따라 각각의 공통 상세 현황팝업을  띄워준다.

	2. t_insert - INDEX_SELECTED
	- 내부적으로 selectCond(wise, selectedRow)호출

*/
function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
	var wise = GridObj;
	for(var i=0;i<GridObj.GetRowCount();i++) {
		if(i%2 == 1){
			for (var j = 0;	j<GridObj.GetColCount(); j++){
				//GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
			}
		}
	}

	if(msg1 == "t_imagetext")
	{
		//구매요청번호
        if (msg3 == INDEX_PR_NO) {
      		pr_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_PR_NO);
      		window.open('/kr/dt/pr/pr1_bd_dis1.jsp?pr_no='+pr_no ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
		}
		if(msg3 == INDEX_ITEM_NO){
			var pr_type = wise.GetCellValue("PR_TYPE",msg2);
			//if(pr_type=="I")
				window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+msg4,"real_pp_lis1","left=0,top=0,width=750,height=550,resizable=yes,scrollbars=yes");
			//else
			//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+msg4,"real_pp_lis1","left=0,top=0,width=750,height=550,resizable=yes,scrollbars=yes");
		}
		if(msg3 == INDEX_DESCRIPTION_LOC){
			var item_no = wise.GetCellValue("ITEM_NO",msg2);
			var pr_type = wise.GetCellValue("PR_TYPE",msg2);
			//if(pr_type=="I")
				window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+item_no,"real_pp_lis1","left=0,top=0,width=750,height=550,resizable=yes,scrollbars=yes");
			//else
			//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+item_no,"real_pp_lis1","left=0,top=0,width=750,height=550,resizable=yes,scrollbars=yes");
		}
		if(msg3 == INDEX_PO_VENDOR_CODE){
			if(msg4==""){
				alert("업체가 없습니다.");
				return;
			}
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+msg4,"ven_bd_con","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
		}
		if(msg3 == INDEX_PO_VENDOR_NAME){
			var vendor_code  = GridObj.GetCellValue("PO_VENDOR_CODE",msg2);
			if(msg4==""){
				alert("업체가 없습니다.");
				return;
			}
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&CompanyCode=<%=COMPANY_CODE%>&vendor_code="+vendor_code+"&user_type=1000","ven_bd_con","left=0,top=0,width=950,height=700,resizable=yes,scrollbars=yes");
		}
	}
	if(msg1 == "t_insert")
	{
		if(msg3 == INDEX_SELECTED)
		{
			//selectCond(wise, msg2);
			var cont_seq  = GridObj.GetCellValue("PRE_CONT_SEQ",msg2);
			var pr_no     = GridObj.GetCellValue("PR_NO",msg2);
			if(cont_seq!=""){
				for(var v1=0; v1<GridObj.GetRowCount(); v1++){
					if(GridObj.GetCellValue("PRE_CONT_SEQ",v1) == cont_seq && GridObj.GetCellValue("PR_NO",v1) == pr_no){
						GridObj.SetCellValue("SELECTED", v1,msg5);
					}else{
						GridObj.SetCellValue("SELECTED", v1,0);
					}
				}
			}
		}
	}
	if(msg1 == "doData")
	{
		alert(wise.GetMessage());
		if(mode=="setCancelVendorSelect")
    		doSelect();
	}
	if(msg1 == "doQuery")
	{
        var maxRow = GridObj.GetRowCount();
		var customer_unitPrice = 0;
		var itemQty = 0;
        for(i=0; i<maxRow; i++) {
			customer_unitPrice = GD_GetCellValueIndex(GridObj,i, INDEX_CUSTOMER_PRICE);

			itemQty = GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY);
            var tmp_amt = eval(customer_unitPrice) * eval(itemQty);
            
            GridObj.cells(i + 1, GridObj.getColIndexById("CUSTOMER_AMT")).setValue(setAmt(tmp_amt));
            //GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("CUSTOMER_AMT")).setValue(setAmt(tmp_amt));
            //GD_SetCellValueIndex(GridObj,i, INDEX_CUSTOMER_AMT, setAmt(tmp_amt));
        }
	}
}

function setAmt(value) {
	rlt = 0;
	if(value == "" || value == 0) return 0;

	rlt = Math.floor(new Number(value) * 1) / 1;

	return rlt;
}

/*
	SETTLE_TYPE이
	1. 문서별일때
	동일 문서 번호를 같이 선택한다.
	2. 아이템별일때
	동일 문서번호, 동일 차수, 동일 항번을 같이 선택한다.
*/
function selectCond(wise, selectedRow)
{
	var wise = GridObj;
	var cur_pr_no  = GD_GetCellValueIndex(wise,selectedRow, INDEX_PR_NO);
	var cur_vendor_cd  = GD_GetCellValueIndex(wise,selectedRow, INDEX_PO_VENDOR_CODE);

	var iRowCount   = wise.GetRowCount();
	for(var i=0;i<iRowCount;i++)
	{
		if(i==selectedRow)
			continue;

		if(cur_vendor_cd != ""){
			if(cur_pr_no == GD_GetCellValueIndex(wise,i,INDEX_PR_NO) && cur_vendor_cd == GD_GetCellValueIndex(wise,i,INDEX_PO_VENDOR_CODE))
			{
				var flag = "true";
				if(GD_GetCellValueIndex(wise,i,INDEX_SELECTED) == "true")
					flag = "false";

				GD_SetCellValueIndex(wise,i,INDEX_SELECTED,flag + "&","&");

			}else{
				var flag = "false";
				GD_SetCellValueIndex(wise,i,INDEX_SELECTED,flag + "&","&");
			}
		}else{
			if(cur_pr_no == GD_GetCellValueIndex(wise,i,INDEX_PR_NO))
			{
				var flag = "true";
				if(GD_GetCellValueIndex(wise,i,INDEX_SELECTED) == "true")
					flag = "false";

				GD_SetCellValueIndex(wise,i,INDEX_SELECTED,flag + "&","&");

			}else{
				var flag = "false";
				GD_SetCellValueIndex(wise,i,INDEX_SELECTED,flag + "&","&");
			}
		}
	}
}

function SP1001_Popup() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP1001&function=SP1001_Popup_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=&values=/&desc=프로젝트&desc=프로젝트명";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function SP1001_Popup_getCode(z_code1, project_name) {
	document.form.z_code1.value = z_code1;
	document.form.project_name.value = project_name;
}
function TestPararell()
{
	var wise = GridObj;
	var wise = wise;
	wise.SetParam("mode", "TestPararell");
	wise.SetParam("WISETABLE_DOQUERY_DODATA","1");
	wise.SendData(G_SERVLETURL, "ALL", "ALL");
}
//담당자
function SP0071_Popup() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0071&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=P";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function  SP0071_getCode(ls_ctrl_code, ls_ctrl_name, ls_ctrl_person_id, ls_ctrl_person_name) {

	document.forms[0].ctrl_code.value = ls_ctrl_code;
	document.forms[0].ctrl_name.value = ls_ctrl_name;
	document.forms[0].ctrl_person_id.value = ls_ctrl_person_id;
	document.forms[0].ctrl_person_name.value = ls_ctrl_person_name;

}
function start_change_date(year,month,day,week) {
	var f0 = document.forms[0];
	f0.start_change_date.value=year+month+day;
}
function end_change_date(year,month,day,week) {
	var f0 = document.forms[0];
	f0.end_change_date.value=year+month+day;
}
function PopupManager(part)
{
	var url = "";
	var f = document.forms[0];

	if(part == "DEMAND_DEPT")
	{
		window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "ADD_USER_ID")
	{
		window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	//구매담당자
	else if(part == "CTRL_CODE")
	{
		PopupCommon2("SP0216","getCtrlManager","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","직무코드","직무명");
	}
	else if(part == "PURCHASER_ID")
	{
		window.open("/common/CO_008.jsp?callback=getPurUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
}

//구매담당자
function getCtrlManager(code, text)
{
	document.forms[0].ctrl_code.value = code;
	document.forms[0].ctrl_name.value = text;
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

function getPurUser(code, text)
{
	document.forms[0].purchaser_name.value = text;
	document.forms[0].purchaser_id.value = code;
}

function fncDeCode(param){
    var sb  = '';
    var pos = 0;
    var flg = true;

    if(param != null){
        if(param.length>1){
            while(flg){
                var sLen = param.substring(pos,++pos);
                var nLen = 0;

                try{
                    nLen = parseInt(sLen);
                }
                catch(e){
                    nLen = 0;
                }

                var code = '';

                if((pos+nLen)>param.length){
                	code = param.substring(pos);
                }
                else{
                	code = param.substring(pos,(pos+nLen));
                }

                pos  += nLen;
                sb += String.fromCharCode(code);

                if(pos >= param.length){
                	flg = false;
                }
            }
        }
    }

    return sb;
}

function OpenDraftSystem() {
	gw_bind_close();
	gw_bind_close2();
	
	var rowCount             = GridObj.GetRowCount();
	var i                    = 0;
	var selectedColIndex     = GridObj.getColIndexById("SELECTED");
	var prNoColIndex         = GridObj.getColIndexById("PR_NO");
	var prSeqColIndex        = GridObj.getColIndexById("PR_SEQ");
	var gwStatusColIndex     = GridObj.getColIndexById("GW_STATUS");
	var sourcingTypeColIndex = GridObj.getColIndexById("SOURCING_TYPE");
	var rfqTypeColIndex      = GridObj.getColIndexById("RFQ_TYPE");
	var selectedColValue     = null;
	var prNoColValue         = null;
	var prSeqColValue        = null;
	var gwStatusColValue     = null;
	var sourcingTypeColValue = null;
	var rfqTypeColValue      = null;
	var prNoArray            = new Array();
	var prSeqArray           = new Array();
	var prNoArrayLength      = 0;
	var prNoValue            = "";
	var prSeqValue           = "";
	var prNoArrayLastIndex   = 0;
	
	for(i = 0; i < rowCount; i++){
		selectedColValue = GD_GetCellValueIndex(GridObj, i, selectedColIndex);
		
		if(selectedColValue == true){
			prNoColValue         = GD_GetCellValueIndex(GridObj, i, prNoColIndex);
			prSeqColValue        = GD_GetCellValueIndex(GridObj, i, prSeqColIndex);
			gwStatusColValue     = GD_GetCellValueIndex(GridObj, i, gwStatusColIndex);
			sourcingTypeColValue = GD_GetCellValueIndex(GridObj, i, sourcingTypeColIndex);
			rfqTypeColValue      = GD_GetCellValueIndex(GridObj, i, rfqTypeColIndex);
			
			if(
				(gwStatusColValue == "P") ||
				(gwStatusColValue == "E")
			){
				alert("품의중인 데이터가 있습니다.");
				
				return;
			}

			if(sourcingTypeColValue != "RFQ"){
				alert("견적(예가산정)을 선택하여 주십시오.");
				
				return;
			}
			
			if(!(rfqTypeColValue == "CL" || rfqTypeColValue == "MA")){
				alert("견적(예가산정)을 선택하여 주십시오.");
				
				return;
			}
			
			prNoArray[prNoArray.length]   = prNoColValue;
			prSeqArray[prSeqArray.length] = prSeqColValue;
		}
	}
	
	prNoArrayLength    = prNoArray.length;
	prNoArrayLastIndex = prNoArrayLength - 1;
	
	if(prNoArrayLength == 0){
		alert("품의 대상을 선택하여 주십시오.");
	}
	else{
		for(i = 0; i < prNoArrayLength; i++){
			prNoValue  = prNoValue + prNoArray[i];
			prSeqValue = prSeqValue + prSeqArray[i];
			
			if(i != prNoArrayLastIndex){
				prNoValue  = prNoValue + ",";
				prSeqValue = prSeqValue + ",";
			}
		}
		
		$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_bd_lis1",
			{
				mode:"gwDraft",
				prNo:prNoValue,
				prSeq:prSeqValue,
				kind:"A"
			},
			function(arg){
				var result = eval('(' + arg + ')');
				
				OpenDraftSystemCallback(result);
			}
		);
	}
}

function OpenDraftSystemCallback(result){
	var resultCode  = result.code;
	var bodyContext = document.getElementById("BODY_CONTEXT");
	var frmlink5    = document.getElementById("frmlink5");
	var strSysKey   = document.getElementById("strSysKey");
	var x           = 900;
	var y           = window.screen.height - 90;
	var status      = "toolbar=no, directories=no, scrollbars=no, resizable=no, status=no, memubar=no, width=" + x + ", height=" + y + ", top=0, left=20";
	
	if(resultCode == "200"){
		bodyContext.value = fncDeCode(result.bodyContextValue);
		strSysKey.value   = result.infNo;
		
		window.open("", "전자구매시스템", status);
		
	    frmlink5.target = "전자구매시스템";
	    frmlink5.submit();
	    
	    bodyContext.value = "";
	    
	    doSelect();
	}
	else{
		alert(result.message);
	}
}

function OpenDraftSystem2(){
	gw_bind_close();
	gw_bind_close2();
	
	var rowCount             = GridObj.GetRowCount();
	var i                    = 0;
	var selectedColIndex     = GridObj.getColIndexById("SELECTED");
	var prNoColIndex         = GridObj.getColIndexById("PR_NO");
	var prSeqColIndex        = GridObj.getColIndexById("PR_SEQ");
	var gwStatusColIndex     = GridObj.getColIndexById("GW_STATUS2");
	var sourcingTypeColIndex = GridObj.getColIndexById("SOURCING_TYPE");
	var rfqTypeColIndex      = GridObj.getColIndexById("RFQ_TYPE");
	var selectedColValue     = null;
	var prNoColValue         = null;
	var prSeqColValue        = null;
	var gwStatusColValue     = null;
	var sourcingTypeColValue = null;
	var rfqTypeColValue      = null;
	var prNoArray            = new Array();
	var prSeqArray           = new Array();
	var prNoArrayLength      = 0;
	var prNoValue            = "";
	var prSeqValue           = "";
	var prNoArrayLastIndex   = 0;
	
	for(i = 0; i < rowCount; i++){
		selectedColValue = GD_GetCellValueIndex(GridObj, i, selectedColIndex);
		
		if(selectedColValue == true){
			prNoColValue         = GD_GetCellValueIndex(GridObj, i, prNoColIndex);
			prSeqColValue        = GD_GetCellValueIndex(GridObj, i, prSeqColIndex);
			gwStatusColValue     = GD_GetCellValueIndex(GridObj, i, gwStatusColIndex);
			sourcingTypeColValue = GD_GetCellValueIndex(GridObj, i, sourcingTypeColIndex);
			rfqTypeColValue      = GD_GetCellValueIndex(GridObj, i, rfqTypeColIndex);
			
			if(
				(gwStatusColValue == "P") ||
				(gwStatusColValue == "E")
			){
				alert("품의중인 데이터가 있습니다.");
				
				return;
			}
			
			if(sourcingTypeColValue != "RFQ" && sourcingTypeColValue != "BID"){
				alert("입찰 또는 견적(수의, 입력대행)을 선택하여 주십시오.");
				
				return;
			}
			
			if(
				(sourcingTypeColValue == "RFQ") &&
				(rfqTypeColValue != "PC") &&
				(rfqTypeColValue != "MA")
			){
				alert("견적(수의, 입력대행)을 선택하여 주십시오.");
				
				return;
			}
			
			prNoArray[prNoArray.length]   = prNoColValue;
			prSeqArray[prSeqArray.length] = prSeqColValue;
		}
	}
	
	prNoArrayLength    = prNoArray.length;
	prNoArrayLastIndex = prNoArrayLength - 1;
	
	if(prNoArrayLength == 0){
		alert("품의 대상을 선택하여 주십시오.");
	}
	else{
		for(i = 0; i < prNoArrayLength; i++){
			prNoValue  = prNoValue + prNoArray[i];
			prSeqValue = prSeqValue + prSeqArray[i];
			
			if(i != prNoArrayLastIndex){
				prNoValue  = prNoValue + ",";
				prSeqValue = prSeqValue + ",";
			}
		}
		
		$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_bd_lis1",
			{
				mode:"gwDraft2",
				prNo:prNoValue,
				prSeq:prSeqValue,
				kind:"B"
			},
			function(arg){
				var result = eval('(' + arg + ')');
				
				OpenDraftSystemCallback2(result);
			}
		);
	}
}

function OpenDraftSystemCallback2(result){
	var resultCode  = result.code;
	var bodyContext = document.getElementById("BODY_CONTEXT");
	var frmlink5    = document.getElementById("frmlink5");
	var strSysKey   = document.getElementById("strSysKey");
	var x           = 900;
	var y           = window.screen.height - 90;
	var status      = "toolbar=no, directories=no, scrollbars=no, resizable=no, status=no, memubar=no, width=" + x + ", height=" + y + ", top=0, left=20";
	
	if(resultCode == "200"){
		bodyContext.value = fncDeCode(result.bodyContextValue);
		strSysKey.value   = result.infNo;
		
		window.open("", "전자구매시스템", status);
		
	    frmlink5.target = "전자구매시스템";
	    frmlink5.submit();
	    
	    bodyContext.value = "";
	    
	    doSelect();
	}
	else{
		alert(result.message);
	}
}

function CallGwBind() {
	var rowCount             = GridObj.GetRowCount();
	var i                    = 0;
	var selectedColIndex     = GridObj.getColIndexById("SELECTED");
	var prNoColIndex         = GridObj.getColIndexById("PR_NO");
	var prSeqColIndex        = GridObj.getColIndexById("PR_SEQ");
	var gwStatusColIndex     = GridObj.getColIndexById("GW_STATUS");
	var sourcingTypeColIndex = GridObj.getColIndexById("SOURCING_TYPE");
	var rfqTypeColIndex      = GridObj.getColIndexById("RFQ_TYPE");
	var selectedColValue     = null;
	var prNoColValue         = null;
	var prSeqColValue        = null;
	var gwStatusColValue     = null;
	var sourcingTypeColValue = null;
	var rfqTypeColValue      = null;
	var prNoArray            = new Array();
	var prSeqArray           = new Array();
	var prNoArrayLength      = 0;
	var prNoValue            = "";
	var prSeqValue           = "";
	var prNoArrayLastIndex   = 0;
	
	for(i = 0; i < rowCount; i++){
		selectedColValue = GD_GetCellValueIndex(GridObj, i, selectedColIndex);
		
		if(selectedColValue == true){
			prNoColValue         = GD_GetCellValueIndex(GridObj, i, prNoColIndex);
			prSeqColValue        = GD_GetCellValueIndex(GridObj, i, prSeqColIndex);
			gwStatusColValue     = GD_GetCellValueIndex(GridObj, i, gwStatusColIndex);
			sourcingTypeColValue = GD_GetCellValueIndex(GridObj, i, sourcingTypeColIndex);
			rfqTypeColValue      = GD_GetCellValueIndex(GridObj, i, rfqTypeColIndex);
			
			if(
				(gwStatusColValue == "P") ||
				(gwStatusColValue == "E")
			){
				alert("품의중인 데이터가 있습니다.");
				
				return;
			}

			if(sourcingTypeColValue != "RFQ"){
				alert("견적(예가산정)을 선택하여 주십시오.");
				
				return;
			}
			
			if(!(rfqTypeColValue == "CL" || rfqTypeColValue == "MA")){
				alert("견적(예가산정)을 선택하여 주십시오.");
				
				return;
			}
			
			prNoArray[prNoArray.length]   = prNoColValue;
			prSeqArray[prSeqArray.length] = prSeqColValue;
		}
	}
	
	prNoArrayLength    = prNoArray.length;
	prNoArrayLastIndex = prNoArrayLength - 1;
	
	if(prNoArrayLength == 0){
		alert("품의 대상을 선택하여 주십시오.");
	}
	else{
		if(!confirm("G/W 사전품의 연결 하시겠습니까?\r\n\r\n품의연결시 취소불가")){
			return;
		}	
		
		for(i = 0; i < prNoArrayLength; i++){
			prNoValue  = prNoValue + prNoArray[i];
			prSeqValue = prSeqValue + prSeqArray[i];
			
			if(i != prNoArrayLastIndex){
				prNoValue  = prNoValue + ",";
				prSeqValue = prSeqValue + ",";
			}
		}
		
		$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/dt.pr.pr5_bd_lis2",
			{
				mode:"gwBind",
				prNo:prNoValue,
				prSeq:prSeqValue,
				kind:"A",
				gwDocNo:document.getElementById("gwDocNo").value,
				gwEndDate:document.getElementById("gwEndDate").value	
			},
			function(arg){
				var result = eval('(' + arg + ')');
				
				var resultCode  = result.code;
				if(resultCode == "200"){					
					alert(result.message);
					document.getElementById("gwDocNo").value = "";
					document.getElementById("gwEndDate").value = "";
					document.getElementById('divGW').style.visibility = 'hidden';
				    doSelect();
				}
				else{
					alert(result.message);
				}
			}
		);
	}
}

//전자입찰
function gw_bind_open()
{
   alert("품의연결시 취소불가하오니 신중히 사용하세요.");
   gw_bind_close2();
   var width = 320;
   var height = 200;
// var dim = new Array(2);

   dim = ToCenter(height,width);
   var top = dim[0];
   var left = dim[1];
// style="POSITION:absolute; WIDTH:320px; HEIGHT:200px; VISIBILITY:hidden; TOP:200px; LEFT:320px"

// var top = event.clientY;
// var left = event.clientX;
   
   document.getElementById("divGW").style.width = width+"px";
   document.getElementById("divGW").style.height = height+"px";
   document.getElementById("divGW").style.top = top+"px";
   document.getElementById("divGW").style.left = left+"px";
   document.getElementById("divGW").style.visibility = "visible";
   
//	MM_openBrWindow("common/idpwd.jsp", "login_idpwd", "440", "380");
	
}
function gw_bind_close()
{
	document.getElementById("gwDocNo").value = "";
	document.getElementById("gwEndDate").value = "";
	document.getElementById('divGW').style.visibility = 'hidden';
}

function CallGwBind2() {
	var rowCount             = GridObj.GetRowCount();
	var i                    = 0;
	var selectedColIndex     = GridObj.getColIndexById("SELECTED");
	var prNoColIndex         = GridObj.getColIndexById("PR_NO");
	var prSeqColIndex        = GridObj.getColIndexById("PR_SEQ");
	var gwStatusColIndex     = GridObj.getColIndexById("GW_STATUS2");
	var sourcingTypeColIndex = GridObj.getColIndexById("SOURCING_TYPE");
	var rfqTypeColIndex      = GridObj.getColIndexById("RFQ_TYPE");
	var selectedColValue     = null;
	var prNoColValue         = null;
	var prSeqColValue        = null;
	var gwStatusColValue     = null;
	var sourcingTypeColValue = null;
	var rfqTypeColValue      = null;
	var prNoArray            = new Array();
	var prSeqArray           = new Array();
	var prNoArrayLength      = 0;
	var prNoValue            = "";
	var prSeqValue           = "";
	var prNoArrayLastIndex   = 0;
	
	for(i = 0; i < rowCount; i++){
		selectedColValue = GD_GetCellValueIndex(GridObj, i, selectedColIndex);
		
		if(selectedColValue == true){
			prNoColValue         = GD_GetCellValueIndex(GridObj, i, prNoColIndex);
			prSeqColValue        = GD_GetCellValueIndex(GridObj, i, prSeqColIndex);
			gwStatusColValue     = GD_GetCellValueIndex(GridObj, i, gwStatusColIndex);
			sourcingTypeColValue = GD_GetCellValueIndex(GridObj, i, sourcingTypeColIndex);
			rfqTypeColValue      = GD_GetCellValueIndex(GridObj, i, rfqTypeColIndex);
			
			if(
				(gwStatusColValue == "P") ||
				(gwStatusColValue == "E")
			){
				alert("품의중인 데이터가 있습니다.");
				
				return;
			}
			
			if(sourcingTypeColValue != "RFQ" && sourcingTypeColValue != "BID"){
				alert("입찰 또는 견적(수의, 입력대행)을 선택하여 주십시오.");
				
				return;
			}
			
			if(
				(sourcingTypeColValue == "RFQ") &&
				(rfqTypeColValue != "PC") &&
				(rfqTypeColValue != "MA")
			){
				alert("견적(수의, 입력대행)을 선택하여 주십시오.");
				
				return;
			}
			
			prNoArray[prNoArray.length]   = prNoColValue;
			prSeqArray[prSeqArray.length] = prSeqColValue;
		}
	}
	
	prNoArrayLength    = prNoArray.length;
	prNoArrayLastIndex = prNoArrayLength - 1;
	
	if(prNoArrayLength == 0){
		alert("품의 대상을 선택하여 주십시오.");
	}
	else{
		if(!confirm("G/W 계약품의 연결 하시겠습니까?\r\n\r\n품의연결시 취소불가")){
			return;
		}
		for(i = 0; i < prNoArrayLength; i++){
			prNoValue  = prNoValue + prNoArray[i];
			prSeqValue = prSeqValue + prSeqArray[i];
			
			if(i != prNoArrayLastIndex){
				prNoValue  = prNoValue + ",";
				prSeqValue = prSeqValue + ",";
			}
		}
		
		$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/dt.pr.pr5_bd_lis2",
			{
				mode:"gwBind",
				prNo:prNoValue,
				prSeq:prSeqValue,
				kind:"B",
				gwDocNo:document.getElementById("gwDocNo2").value,
				gwEndDate:document.getElementById("gwEndDate2").value	
			},
			function(arg){
                var result = eval('(' + arg + ')');
				
				var resultCode  = result.code;
				if(resultCode == "200"){					
					alert(result.message);
					document.getElementById("gwDocNo2").value = "";
					document.getElementById("gwEndDate2").value = "";
					document.getElementById('divGW2').style.visibility = 'hidden';
				    doSelect();
				}
				else{
					alert(result.message);
				}
			}
		);
	}
}


function gw_bind_open2()
{
   alert("품의연결시 취소불가하오니 신중히 사용하세요.");
   gw_bind_close();
   var width = 320;
   var height = 200;
// var dim = new Array(2);

   dim = ToCenter(height,width);
   var top = dim[0];
   var left = dim[1];
// style="POSITION:absolute; WIDTH:320px; HEIGHT:200px; VISIBILITY:hidden; TOP:200px; LEFT:320px"

// var top = event.clientY;
// var left = event.clientX;
   
   document.getElementById("divGW2").style.width = width+"px";
   document.getElementById("divGW2").style.height = height+"px";
   document.getElementById("divGW2").style.top = top+"px";
   document.getElementById("divGW2").style.left = left+"px";
   document.getElementById("divGW2").style.visibility = "visible";
   
//	MM_openBrWindow("common/idpwd.jsp", "login_idpwd", "440", "380");
	
}
function gw_bind_close2()
{
	document.getElementById("gwDocNo2").value = "";
	document.getElementById("gwEndDate2").value = "";
	document.getElementById('divGW2').style.visibility = 'hidden';
}

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
function doOnRowSelected(rowId,cellInd){

	var rowIndex = GridObj.getRowIndex(rowId);
	if(cellInd == GridObj.getColIndexById("PR_NO")) {
		var prNo = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_PR_NO);
		var page = "";
<%
	if("B".equals(REQ_TYPE)){
%>
		page = "/kr/dt/ebd/ebd_pp_dis6I.jsp";
<%
	}
	else{
%>
		page = "/kr/dt/pr/pr1_bd_dis1I.jsp";
<%
	}
%>	
		window.open(page + '?pr_no=' + prNo ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
	}
	
	if(cellInd == GridObj.getColIndexById("GW_STATUS_NM")) {
		var gwStatusColIndex = GridObj.getColIndexById("GW_STATUS");
		var prNoColIndex     = GridObj.getColIndexById("PR_NO");
		var prSeqColIndex    = GridObj.getColIndexById("PR_SEQ");
		var gwStatusColValue = GD_GetCellValueIndex(GridObj, rowIndex, gwStatusColIndex);
		var prNoValue        = GD_GetCellValueIndex(GridObj, rowIndex, prNoColIndex);
		var prSeqValue       = GD_GetCellValueIndex(GridObj, rowIndex, prSeqColIndex);
		var x                = 900;
		var y                = window.screen.height - 90;
		var status           = "toolbar=no, directories=no, scrollbars=no, resizable=no, status=no, memubar=no, width=" + x + ", height=" + y + ", top=0, left=20";

		if("E" == gwStatusColValue){
			$.post(
				"<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_bd_lis1",
				{
					mode  : "gwPop",
					prNo  : prNoValue,
					prSeq : prSeqValue,
					type  : "P"
				},
				function(arg){
					var result     = eval('(' + arg + ')');
					var resultCode = result.code;
					var gwPopUrl   = null;
					
					if(resultCode == "200"){
						gwPopUrl = result.gwPopUrl;
						gwPopUrl = fncDeCode(gwPopUrl);
						
						window.open(gwPopUrl, "gwPop", status);
					}
					else{
						alert(result.message);
					}
				}
			);
		}
		
		var bdGwStatusColIndex = GridObj.getColIndexById("BD_GW_STATUS");
		var bdPrNoColIndex     = GridObj.getColIndexById("BD_PR_NO");
		var bdPrSeqColIndex    = GridObj.getColIndexById("BD_PR_SEQ");
		var bdGwStatusColValue = GD_GetCellValueIndex(GridObj, rowIndex, bdGwStatusColIndex);
		var bdPrNoValue        = GD_GetCellValueIndex(GridObj, rowIndex, bdPrNoColIndex);
		var bdPrSeqValue       = GD_GetCellValueIndex(GridObj, rowIndex, bdPrSeqColIndex);
		
		if("E" == bdGwStatusColValue){
			$.post(
				"<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_bd_lis1",
				{
					mode  : "gwPop",
					prNo  : bdPrNoValue,
					prSeq : bdPrSeqValue,
					type  : "P"
				},
				function(arg){
					var result     = eval('(' + arg + ')');
					var resultCode = result.code;
					var gwPopUrl   = null;
					
					if(resultCode == "200"){
						gwPopUrl = result.gwPopUrl;
						gwPopUrl = fncDeCode(gwPopUrl);
						window.open(gwPopUrl, "gwPop", status);
					}
					else{
						alert(result.message);
					}
				}
			);
		}
	}
	if(cellInd == GridObj.getColIndexById("GW_STATUS_NM2")) {
		var gwStatusColIndex = GridObj.getColIndexById("GW_STATUS2");
		var prNoColIndex     = GridObj.getColIndexById("PR_NO");
		var prSeqColIndex    = GridObj.getColIndexById("PR_SEQ");
		var gwStatusColValue = GD_GetCellValueIndex(GridObj, rowIndex, gwStatusColIndex);
		var prNoValue        = GD_GetCellValueIndex(GridObj, rowIndex, prNoColIndex);
		var prSeqValue       = GD_GetCellValueIndex(GridObj, rowIndex, prSeqColIndex);
		var x                = 900;
		var y                = window.screen.height - 90;
		var status           = "toolbar=no, directories=no, scrollbars=no, resizable=no, status=no, memubar=no, width=" + x + ", height=" + y + ", top=0, left=20";

		if("E" == gwStatusColValue){
			$.post(
				"<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_bd_lis1",
				{
					mode  : "gwPop",
					prNo  : prNoValue,
					prSeq : prSeqValue,
					type  : "G"
				},
				function(arg){
					var result     = eval('(' + arg + ')');
					var resultCode = result.code;
					var gwPopUrl   = null;
					
					if(resultCode == "200"){
						gwPopUrl = result.gwPopUrl;
						gwPopUrl = fncDeCode(gwPopUrl);
						
						window.open(gwPopUrl, "gwPop", status);
					}
					else{
						alert(result.message);
					}
				}
			);
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
        document.getElementById("req_type").value = "P";
        doSelect();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	//JavaCall("doData");
    	JavaCall("doQuery");
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
    
    document.form.start_change_date.value = add_Slash(document.form.start_change_date.value);
    document.form.end_change_date.value = add_Slash(document.form.end_change_date.value);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}


function doBidding_to_be(){
	gw_bind_close();
	gw_bind_close2();
	
	var checkCnt         = 0;
	var cur              = "";
	var rfq_type         = "";
	var pr_data          = "";
	var gwStatusColIndex = GridObj.getColIndexById("GW_STATUS");
	var gwStatusColValue = null;

	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			checkCnt ++;
			cur                          = GridObj.GetCellValue("CUR", i);
			rfq_type                     = GridObj.GetCellValue("RFQ_TYPE", i);
			
				
			if(rfq_type != "CL" && rfq_type != "MA"){
				alert("견적(예가산정),견적(입력대행)건만 처리 가능합니다.");
				return;
			}
			
			if(cur != "KRW"){
				alert("원화만 입찰요청을 하실 수 있습니다.");
				
				return;
			}
			
			gwStatusColValue = GD_GetCellValueIndex(GridObj, i, gwStatusColIndex);
			
			if("E" != gwStatusColValue){
				alert("그룹웨어 품의 대상이 있습니다.");
				
				return;
			}

			if(i == GridObj.GetRowCount()-1){
				pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i);
			}
			else {
				pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i) + ",";
			}
		}
	}

	if(checkCnt == 0){
		alert("선택한 항목이 없습니다.");
		
		return;
	}

	if(!confirm("입찰요청 하시겠습니까?")){
		return;
	}

	document.form2.PR_DATA.value 		= pr_data;

	var url  = "/sourcing/bd_ann_<%=ANN_VERSION%>.jsp?SCR_FLAG=I&BID_STATUS=AR&BID_TYPE=D&GUBUN=W&ANN_VERSION=<%=ANN_VERSION%>";
	
	var pop_focus = window.open("","doBidding","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	
	document.form2.method = "POST";
	document.form2.action = url;
	document.form2.target = "doBidding";
	document.form2.submit();
	pop_focus.focus();
}
function doBidding_to_be2(){
		
	var checkCnt                     = 0;
	var cur                          = "";
	var rfq_type                     = "";
	var pr_data                      = "";

	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			checkCnt ++;
			rfq_type                     = GridObj.GetCellValue("RFQ_TYPE", i);
			cur                          = GridObj.GetCellValue("CUR", i);

			if(rfq_type != "CL" && rfq_type != "MA"){
				alert("견적(예가산정),견적(입력대행)건만 처리 가능합니다.");
				return;
			}
			
			if(cur != "KRW"){
				alert("원화만 입찰요청을 하실 수 있습니다.");
				
				return;
			}

			if(i == GridObj.GetRowCount()-1){
				pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i);
			}
			else {
				pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i) + ",";
			}
		}
	}

	if(checkCnt == 0){
		alert("선택한 항목이 없습니다.");
		
		return;
	}

	if(!confirm("입찰요청 하시겠습니까?")){
		return;
	}

	document.form2.PR_DATA.value 		= pr_data;

	var url  = "/sourcing/bd_ann_<%=ANN_VERSION%>.jsp?SCR_FLAG=I&BID_STATUS=AR&BID_TYPE=C&GUBUN=W&ANN_VERSION=<%=ANN_VERSION%>";
	
	var pop_focus = window.open("","doBidding","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	
	document.form2.method = "POST";
	document.form2.action = url;
	document.form2.target = "doBidding";
	document.form2.submit();
	pop_focus.focus();
}


function doReverseAuction(){

	var checkCnt=0;
	var cur 	="";
	var rfq_type = "";
	var pr_data ="";
	var pr_no ="";
	var gw_status = "";
	
	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			checkCnt ++;

			rfq_type         = GridObj.GetCellValue("RFQ_TYPE", i);
			cur              = GridObj.GetCellValue("CUR", i);
			gw_status        = GridObj.GetCellValue("GW_STATUS", i);
			
			if(gw_status != "E"){
				alert("그룹웨어 품의완료건만 역경매가 가능합니다.");
				return;
			}
			
			if(rfq_type != "CL" && rfq_type != "MA"){
				alert("견적(예가산정),견적(입력대행)건만 처리 가능합니다.");
				return;
			}
			if(cur != "KRW"){
				alert("원화만 역경매요청을 하실 수 있습니다.");
				
				return;
			}

			if(i == GridObj.GetRowCount()-1){
				pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i);
			}
			else {
				pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i) + ",";
			}
		}
	}

	if(checkCnt == 0){
		alert("선택하신 항목이 없습니다.");
		
		return;
	}
	
	if(checkCnt > 1){
		alert("역경매는 하나의 품목만 선택 가능합니다.");
		return;
	}
	
	if(!confirm("역경매요청 하시겠습니까?")){
		return;
	}

	
	document.form2.PR_DATA.value 		= pr_data;

	var url  = "/kr/dt/rat/rat_bd_ins1.jsp";
	
	var pop_focus = window.open("","doReverseAuction","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	
	document.form2.method = "POST";
	document.form2.action = url;
	document.form2.target = "doReverseAuction";
	document.form2.submit();
	pop_focus.focus();
}
//지우기
function doRemove( type ){
    if( type == "purchaser_id" ) {
    	document.forms[0].purchaser_id.value = "";
        document.forms[0].purchaser_name.value = "";
    }  
    if( type == "demand_dept" ) {
    	document.forms[0].demand_dept.value = "";
        document.forms[0].demand_dept_name.value = "";
    }
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}
</script>
</head>
<body onload="setGridDraw();setHeader();doSelect();" bgcolor="#FFFFFF" text="#000000" >
<s:header>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" align="left" class="title_page" vAlign="bottom">
<%
	if("P".equals(REQ_TYPE)){
%>
			구매관리 > 기안관리 > 기안대기 현황 
<%
	}
	else{
%>
			구매관리 > 사전지원완료 > 사전지원완료 대기현황
<%
	}
%>
			</td>
		</tr>
	</table>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	
	<form name="form" method="post" action="app_bd_ins4.jsp">
		<input type="hidden" id="nextpage_dt_data" 	name="nextpage_dt_data" >
		<input type="hidden" id="nextpage_hd_data" 	name="nextpage_hd_data" >
		<input type="hidden" id="subject" 			name="subject" >
		<input type="hidden" id="pr_seq" 			name="pr_seq" >
		<input type="hidden" id="req_type" 			name="req_type" value="<%=REQ_TYPE%>">
		<input type="hidden" id="pr_data" 			name="pr_data">
		<input type="hidden" id="pr_type" 			name="pr_type" value="I">
		<input type="hidden" id="pre_cont_seq" 		name="pre_cont_seq" value="">
		<input type="hidden" id="pr_name"			name="pr_name"  value="">
		<input type="hidden" id="email"				name="email"  value="">
		<input type="hidden" id="reason_code"		name="reason_code"  value="">
		<input type="hidden" id="pTitle_Memo"		name="pTitle_Memo"  value="">
		<input type="hidden" id="flag"				name="flag"  value="">

		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
			        					<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 생성일자</td>
			        					<td width="20%" height="24" class="data_td">
			      							<s:calendar id="start_change_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1))%>" 	format="%Y/%m/%d"/>~
			      							<s:calendar id="end_change_date"   default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString())%>" 									format="%Y/%m/%d"/>
			        					</td>					
										<td width="19%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
<%
	if("P".equals(REQ_TYPE)){
%>
											구매요청번호 
<%
	}
	else{
%>
											사전지원요청번호 
<%
	}
%>										</td>
										<td width="21%" height="24" class="data_td">
											<input type="text" id="pr_no" name="pr_no" style="width:95%;ime-mode:inactive" maxlength="20" class="inputsubmit" onkeydown='entKeyDown()' >
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>				
									<tr>
										<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 구매담당자</td>
				    					<td width="20%" height="24" class="data_td">
				        					<input type="text" id="purchaser_id" name="purchaser_id" style="ime-mode:inactive" size="15" value="<%=info.getSession("ID")%>" class="inputsubmit"  onkeydown='entKeyDown()' >
				        					<a href="javascript:PopupManager('PURCHASER_ID')">
				        						<img src="/images/ico_zoom.gif" align="absmiddle" border="0">
				        					</a>
				        					<a href="javascript:doRemove('purchaser_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
				        					<input type="text" id="purchaser_name" name="purchaser_name" size="10" value="<%=info.getSession("NAME_LOC")%>" readOnly onkeydown='entKeyDown()' >
			        					</td>
			        					
			        					<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 요청부서</td>
										<td width="20%" height="24" class="data_td">
											<input type="text" id="demand_dept" name="demand_dept" size="15" maxlength="10" style="ime-mode:inactive" class="inputsubmit" value='' onkeydown='entKeyDown()' >
											<a href="javascript:PopupManager('DEMAND_DEPT');">
												<img src="/images/ico_zoom.gif" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('demand_dept')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" id="demand_dept_name" name="demand_dept_name" size="15" class="input_data2" readonly value='' onkeydown='entKeyDown()' >
										</td>
			        					
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>				
									<tr>
										<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 구매유형</td>
<%
	if("P".equals(REQ_TYPE)){
%>										
										<td width="20%" height="24" class="data_td">
<%
	} else {
%>
										<td width="20%" height="24" class="data_td">
<%
	}
%>
										
											<select id="sourcing_type" name="sourcing_type" class="inputsubmit">
												<option value="">전체</option>
<%
	if("B".equals(REQ_TYPE)){
%>
												<option value="RFQ">견적</option>
												<option value="BID">입찰</option>
												<!-- <option value="RAT">역경매</option> -->
<%
	}
	else{
		String listbox2 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M995", "");
		
		out.println(listbox2); 
	}
%>
											</select>
										</td>
      									<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰구분</td>
      									<td width="20%" height="24" class="data_td">
									        <select id="bid_type_c" name="bid_type_c">
		        								<option value="">전체</option>
		        								<option value="D">구매입찰</option>
		        								<option value="C">공사입찰</option>
		        							</select>
		        						</td>
										<%-- 
										<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 진행상태</td>
										<td width="20%" height="24" class="data_td">
											<select id="pr_proceeding_flag" name="pr_proceeding_flag" class="inputsubmit">
												<option value="">전체</option>
<%
	if("P".equals(REQ_TYPE)){
%>
												<option value="P">구매대기</option>
												<option value="C">구매진행</option>
												<option value="E" selected>기안대기</option>
<%
	}
	else{
%>
												<option value="C">사전지원진행</option>
												<option value="E" selected>완료대기</option>
<%
	}
%>
											</select>
										</td>
										 --%>
										<input type="hidden" id="pr_proceeding_flag" name="pr_proceeding_flag" value="E"><%--진행상태 DEFAULT : 기안대기(E)--%>
										
									</tr>
									<tr style="display:none;">
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 요청구분</td>
										<td width="35%" class="data_td" colspan="3">
											<select id="pr_flag" name="pr_flag" class="inputsubmit">
												<option value="">전체</option>
<%
	String listbox3 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M138", "");

	out.println(listbox3);
%>
											</select>
										</td>
									</tr>
									<tr <%if("B".equals(REQ_TYPE)){%> <%}else{%> style="display:none;" <%}%> >
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>	
									<tr <%if("B".equals(REQ_TYPE)){%> <%}else{%> style="display:none;" <%}%> >
										<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 요청구분</td>
										<td width="20%" height="24" class="data_td" colspan="3">
											<select id="create_type" name="create_type" class="inputsubmit">
												<option value="">전체</option>
												<%=LB_CREATE_TYPE%>
											</select>
										</td>
									</tr>
									<tr style="display: none">
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 구매담당자      </td>
										<td class="data_td" width="35%">
											<input type="text" id="ctrl_code" name="ctrl_code" size="10" value="<%=info.getSession("CTRL_CODE")%>" class="inputsubmit" onkeydown='entKeyDown()'  >
											<a href="javascript:PopupManager('CTRL_CODE')">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
											</a>
											<input type="text"   id="ctrl_name" name="ctrl_name" size="10" class="input_data2" value="" readOnly onkeydown='entKeyDown()' >
											<input type="hidden" id="ctrl_person_id" name="ctrl_person_id" size="5" maxlength="5" class="inputsubmit" readOnly value="<%=user_id%>">
											<input type="hidden" id="ctrl_person_name" name="ctrl_person_name" size="25" class="input_data2" readOnly value="<%=user_name%>">
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
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="30" align="right">
				<TABLE cellpadding="0">
					<TR>
						<TD>
<script language="javascript">
btn("javascript:doSelect()","조 회");
</script>
						</TD>
						<%-- 
						<TD>
							<script language="javascript">
								btn("javascript:doBidding_to_be2()","공사입찰");
							</script>
						</TD>
						--%>
						<%-- 
						<TD>
							<script language="javascript">
								btn("javascript:doReverseAuction()","역경매");
							</script>
						</TD>
						--%>
<%
	if("P".equals(REQ_TYPE)){
%>
                        <TD>
<script language="javascript">
btn("javascript:OpenDraftSystem();","G/W 사전품의");
</script>
						</TD>
						<TD>
							<script language="javascript">
								btn("javascript:doBidding_to_be()","구매입찰");
							</script>
						</TD>											
						<TD>
<script language="javascript">
btn("javascript:OpenDraftSystem2();","G/W 계약품의");
</script>
						</TD>
						<TD>
<script language="javascript">
btn("javascript:Create()","계약생성");
</script>
						</TD>														
<%
	}
	else{
%>
						<TD>
<script language="javascript">
btn("javascript:Create()","완 료");
</script>
						</TD>
<%
	}
%>
						<TD>
<script language="javascript">
btn("javascript:doReturn('D');","기안중단");
</script>
						</TD>
					</TR>
				</TABLE>
			</td>
		</tr>
	</table>		
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<% /* MUP150200001 내부 - 총무부장 , MUP210200001 내부 - 총무팀장 ,  MUP141000001 내부관리자 , MUP150400001 WFIS관리자 */
   if( "MUP150200001".equals(info.getSession("MENU_PROFILE_CODE")) || 
	   "MUP210200001".equals(info.getSession("MENU_PROFILE_CODE")) || 
	   "MUP141000001".equals(info.getSession("MENU_PROFILE_CODE")) ||
	   "MUP150400001".equals(info.getSession("MENU_PROFILE_CODE"))	  ){ 
%>
<TABLE border="0" cellpadding="1" cellspacing="1" align="right">
	<tr>
		<td>
			<script language="javascript">
				btn("javascript:gw_bind_open();","G/W 사전품의연결");
			</script>
		</td>
		<td>
			<script language="javascript">
				btn("javascript:gw_bind_open2();","G/W 계약품의연결");
			</script>
		</td>						
	</tr>
</table>
<% } %>
<s:footer/>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>
<form name="frmlink5" id="frmlink5" method="post" action="<%=CommonUtil.getConfig("sepoa.grurl")%>">
	<input type="hidden" name="fmpf"                     value="WF_WRBANK_086"/>
	<input type="hidden" name="hhdUserId_en"             value="<%=info.getSession("ID") %>" />
	<input type="hidden" name="hhdUserId"                value="<%=CryptoUtil.encryptText(info.getSession("ID"))%>" />
	<input type="hidden" name="strSysKey" id="strSysKey" value="" />
	<textarea id="BODY_CONTEXT" name="BODY_CONTEXT" cols="10" rows="10" style="width :800px; height :400px; display : none;"></textarea>
</form>


	<form name="form2" action="/kr/dt/rfq/rfq_bd_ins1.jsp" method="post">
		<input type="hidden" name="PR_DATA" id="PR_DATA">
	</form>
	
	<div id="divGW" style="POSITION:absolute; WIDTH:380px; HEIGHT:200px; VISIBILITY:hidden; TOP:200px; LEFT:380px">
		<table style="BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BACKGROUND-COLOR: #ffffff; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid">
			<tr>
				<td colspan="4" width="380px">
					&nbsp;
				</td>
			</tr>
			<tr>
				<td align="middle">
			    	&nbsp;
				</td>	
				<td colspan="2" align="middle">
					<span style="font-size:18px; font-weight:bold; color:black">G/W 사전품의 연결</span>
				</td>
				<td align="middle">
			    	&nbsp;
				</td>	
			</tr>
			<tr>
				<td colspan="4">
					&nbsp;
				</td>
			</tr>		
			<tr>
			    <td align="middle">
			    	&nbsp;
				</td>		    			
				<td align="middle">
					<span style="font-size:12px; font-weight:bold; color:black">G/W품의 문서번호</span>
				</td>				
				<td align="left">
					<input type="text" name="gwDocNo" id="gwDocNo" style="width:75%" maxlength="20" class="inputsubmit">
				</td>
				<td align="middle">
			    	&nbsp;
				</td>	
			</tr>
			<tr>
			    <td align="middle">
			    	&nbsp;
				</td>		    			
				<td align="middle">
					<span style="font-size:12px; font-weight:bold; color:black">G/W품의 완료일자</span>					
				</td>				
				<td align="left">
					<input type="text" name="gwEndDate" id="gwEndDate" style="width:45%" maxlength="20" class="inputsubmit"><br/>
					<b>입력양식 : YYYY-MM-DD</b>
				</td>
				<td align="middle">
			    	&nbsp;
				</td>	
			</tr>
			<tr>
				<td colspan="4">
					&nbsp;
				</td>
			</tr>		
			<tr>
				<td align="middle">
			    	&nbsp;
				</td>	
				<td align="right">
					<script language="javascript">btn("javascript:CallGwBind();"		, "연 결")	</script>				
				</td>
				<td align="left">
					<script language="javascript">btn("javascript:gw_bind_close();"		, "닫 기")	</script>				
				</td>	
				<td align="middle">
			    	&nbsp;
				</td>			
			</tr>
			<tr>
				<td colspan="4">
					&nbsp;
				</td>
			</tr>
			<tr>
				<td colspan="4">
					&nbsp;
				</td>
			</tr>	
		</table>
	</div>
	<div id="divGW2" style="POSITION:absolute; WIDTH:380px; HEIGHT:200px; VISIBILITY:hidden; TOP:200px; LEFT:380px">
		<table style="BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BACKGROUND-COLOR: #ffffff; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid">
			<tr>
				<td colspan="4" width="380px">
					&nbsp;
				</td>
			</tr>
			<tr>
				<td align="middle">
			    	&nbsp;
				</td>	
				<td colspan="2" align="middle">
					<span style="font-size:18px; font-weight:bold; color:black">G/W품의 연결</span>
				</td>
				<td align="middle">
			    	&nbsp;
				</td>	
			</tr>
			<tr>
				<td colspan="4">
					&nbsp;
				</td>
			</tr>		
			<tr>
			    <td align="middle">
			    	&nbsp;
				</td>		    			
				<td align="middle">
					<span style="font-size:12px; font-weight:bold; color:black">G/W품의 문서번호</span>
				</td>				
				<td align="left">
					<input type="text" name="gwDocNo" id="gwDocNo2" style="width:75%" maxlength="20" class="inputsubmit">
				</td>
				<td align="middle">
			    	&nbsp;
				</td>	
			</tr>
			<tr>
			    <td align="middle">
			    	&nbsp;
				</td>		    			
				<td align="middle">
					<span style="font-size:12px; font-weight:bold; color:black">G/W계약품의 완료일자</span>					
				</td>				
				<td align="left">
					<input type="text" name="gwEndDate" id="gwEndDate2" style="width:45%" maxlength="20" class="inputsubmit"><br/>
					<b>입력양식 : YYYY-MM-DD</b>
				</td>
				<td align="middle">
			    	&nbsp;
				</td>	
			</tr>
			<tr>
				<td colspan="4">
					&nbsp;
				</td>
			</tr>		
			<tr>
				<td align="middle">
			    	&nbsp;
				</td>	
				<td align="right">
					<script language="javascript">btn("javascript:CallGwBind2();"		, "연 결")	</script>				
				</td>
				<td align="left">
					<script language="javascript">btn("javascript:gw_bind_close2();"		, "닫 기")	</script>				
				</td>	
				<td align="middle">
			    	&nbsp;
				</td>			
			</tr>
			<tr>
				<td colspan="4">
					&nbsp;
				</td>
			</tr>
			<tr>
				<td colspan="4">
					&nbsp;
				</td>
			</tr>	
		</table>
	</div>
</body>
</html>