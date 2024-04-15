<%@ page contentType = "text/html; charset=UTF-8" %> 
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AP_008");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AP_008";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%-- <%@ include file="/include/wisehub_session.jsp" %>
<%@ include file="/include/wisehub_common.jsp"%>
<% String WISEHUB_PROCESS_ID="AP_008";%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/wisetable_scripts.jsp"%>
<%@ include file="/include/wisehub_scripts.jsp"%> --%>

<!-- Session 정보 && Parameter 정보 -->
<%
	String house_code 	= JSPUtil.nullToEmpty(info.getSession("HOUSE_CODE"));
	String company_code = JSPUtil.nullToEmpty(info.getSession("COMPANY_CODE"));
	String user_id 		= JSPUtil.nullToEmpty(info.getSession("ID"));
	String dept 		= JSPUtil.nullToEmpty(info.getSession("DEPARTMENT"));

	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
	String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간
	String return_flag = JSPUtil.nullToEmpty(request.getParameter("return_flag"));
	if( return_flag.equals("") ) {
		return_flag = "P";
	}
	String TITLE = "결재요청목록";

%>

<html>
	<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

		<script language="javascript">
//<!--

<%-- var G_SERVLETURL = "<%=getWiseServletPath("admin.basic.approval2.ap2_bd_lis3")%>"; --%>

var current_date = "<%=current_date%>";
var current_time = "<%=current_time%>";

var INDEX_SELECTED		    	= "";
var INDEX_APP_STATUS_TEXT	    = "";
var INDEX_APP_STATUS	        = "";
var INDEX_DOC_TYPE_TEXT       	= "";
var INDEX_DOC_TYPE	        	= "";
var INDEX_DOC_NO	            = "";
var INDEX_DOC_SEQ	            = "";
var INDEX_SUBJECT	            = "";
var INDEX_ITEM_COUNT		    = "";
var INDEX_SIGN_USER_NAME      	= "";
var INDEX_SCTM_SIGN_REMARK		= "";
var INDEX_SCTP_SIGN_REMARK		= "";
var INDEX_ADD_DATE	        	= "";
var INDEX_CUR	        	    = "";
var INDEX_TTL_AMT	            = "";
var INDEX_SIGN_PATH	        	= "";
var INDEX_SHIPPER_TYPE_TEXT   	= "";
var INDEX_SHIPPER_TYPE   	    = "";
var INDEX_ARGENT_FLAG   	    = "";
//var INDEX_ACCOUNT_CODE	    	= "";
var INDEX_APP_STAGE   			= "";
var INDEX_COMPANY_CODE 			= "";
var INDEX_ATTACH_NO			= "";

function Init(){
	document.forms[0].app_status.value = "<%=return_flag%>";
setGridDraw();
setHeader();
	Query();
}

function setHeader(){


	
	//GridObj.AddHeader("ACCOUNT_CODE",		"계정번호",		"t_text",80,90,false);

	//GridObj.SetNumberFormat("ITEM_COUNT",	G_format_etc);
	GridObj.SetDateFormat("ADD_DATE",		"yyyy/MM/dd");
	GridObj.SetDateFormat("SIGN_DATE",	"yyyy/MM/dd");
	//GridObj.SetNumberFormat("TTL_AMT",	G_format_qty);


	INDEX_SELECTED		    = GridObj.GetColHDIndex("SELECTED");
	INDEX_APP_STATUS_TEXT	= GridObj.GetColHDIndex("APP_STATUS_TEXT");
	INDEX_APP_STATUS	    = GridObj.GetColHDIndex("APP_STATUS");
	INDEX_DOC_TYPE_TEXT     = GridObj.GetColHDIndex("DOC_TYPE_TEXT");
	INDEX_DOC_TYPE	        = GridObj.GetColHDIndex("DOC_TYPE");
	INDEX_DOC_NO	        = GridObj.GetColHDIndex("DOC_NO");
	INDEX_DOC_SEQ	        = GridObj.GetColHDIndex("DOC_SEQ");
	INDEX_SUBJECT	        = GridObj.GetColHDIndex("SUBJECT");
	INDEX_ITEM_COUNT		= GridObj.GetColHDIndex("ITEM_COUNT");
	//INDEX_SIGN_USER_NAME    = GridObj.GetColHDIndex("SIGN_USER_NAME");
	//INDEX_SIGN_USER_ID    	= GridObj.GetColHDIndex("SIGN_USER_ID");
	INDEX_SCTM_SIGN_REMARK	= GridObj.GetColHDIndex("SCTM_SIGN_REMARK");
	INDEX_SCTP_SIGN_REMARK	= GridObj.GetColHDIndex("SCTP_SIGN_REMARK");
	INDEX_ADD_DATE	        = GridObj.GetColHDIndex("ADD_DATE");
	INDEX_CUR	        	= GridObj.GetColHDIndex("CUR");
	INDEX_TTL_AMT	        = GridObj.GetColHDIndex("TTL_AMT");
	INDEX_SIGN_PATH	        = GridObj.GetColHDIndex("SIGN_PATH");
	INDEX_SHIPPER_TYPE_TEXT = GridObj.GetColHDIndex("SHIPPER_TYPE_TEXT");
	INDEX_SHIPPER_TYPE   	= GridObj.GetColHDIndex("SHIPPER_TYPE");
	INDEX_ARGENT_FLAG   	= GridObj.GetColHDIndex("ARGENT_FLAG");
	//INDEX_ACCOUNT_CODE	    = GridObj.GetColHDIndex("ACCOUNT_CODE");
	INDEX_APP_STAGE   		= GridObj.GetColHDIndex("APP_STAGE");
	INDEX_COMPANY_CODE   	= GridObj.GetColHDIndex("COMPANY_CODE");
	INDEX_ATTACH_NO		= GridObj.GetColHDIndex("ATTACH_NO"		);

}

function Query()
{

	var wise = GridObj;
	var F = document.form1;

	var doc_type 		= F.doc_type.value.toUpperCase();
	var app_status 		= F.app_status.value;
	var doc_no 			= F.DOC_NO.value;
	var ctrl_person_id 	= F.ctrl_person_id.value;
	var from_date 		= F.from_date.value;
	var to_date 		= F.to_date.value;
	var ctrl_type 		= F.ctrl_type.value;
	var used_flag_doc 	= F.used_flag_doc.value;
	var used_flag_ctrl 	= F.used_flag_ctrl.value;
	var subject 		= F.subject.value;
	var sign_from_date 	= F.sign_from_date.value;
	var sign_to_date 	= F.sign_to_date.value;

	if(doc_type == "") F.text_doc_type.value = "";
	if(ctrl_person_id == "") F.text_ctrl_person_id.value = "";

	if (used_flag_doc == "off" && ctrl_person_id == "" && doc_type != "") { //alert("doc_type 만 손으로 입력됨");
		//getDiscription(doc_type, "", "", "1");
	}else if (used_flag_ctrl == "off" && ctrl_person_id != "" && ctrl_type != "" && doc_type != "" ) { //alert("ctrl만 손으로 입력됨 ");
		//getDiscription("", ctrl_type, ctrl_person_id, "2");
	}else if(used_flag_doc == "off" && used_flag_ctrl == "off" && ctrl_person_id != "" && ctrl_type == "" && doc_type != "") { //alert("둘다 손으로 입력됨");
		//getDiscription(doc_type, ctrl_type, ctrl_person_id, "3");
	}

	/* GridObj.SetParam("mode",			"RequestList");
	GridObj.SetParam("doc_type",		doc_type);
	GridObj.SetParam("doc_no",			doc_no);
	GridObj.SetParam("app_status",		app_status);
	GridObj.SetParam("ctrl_person_id",	ctrl_person_id);
	GridObj.SetParam("from_date",		from_date);
	GridObj.SetParam("to_date",		to_date);
	//GridObj.SetParam("proceeding_flag","P");
	GridObj.SetParam("subject",subject);
	GridObj.SetParam("sign_from_date",    sign_from_date);
	GridObj.SetParam("sign_to_date",		sign_to_date); */	

	F.used_flag_doc.value = "off";
	F.used_flag_ctrl.value = "off";

	/* GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
	GridObj.SendData(G_SERVLETURL);
	GridObj.strHDClickAction="sortmulti"; */
	var param ="mode=getReportList&grid_col_id="+grid_col_id;
	var url	= "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.approval.ap_report_list";
	param += dataOutput();
	GridObj.post(url, param);
 	GridObj.clearAll(false);
}

//팝업 버튼 누르지 않고 손으로 입력했을때
function getDiscription(doc_type, ctrl_type, ctrl_code, flag) {
	parent.work.location.href = "/kr/admin/basic/approval/ap1_wk_lis1.jsp?doc_type="+doc_type+"&ctrl_type="+ctrl_type+"&ctrl_code="+ctrl_code+"&flag="+flag;
}

function setDocDesc(doc_type_name, ctrl_type) {//ap1_wk_lis1.jsp 에서 호출
	document.forms[0].text_doc_type.value = doc_type_name;
	document.forms[0].ctrl_type.value = ctrl_type;
}

function setCtrlDesc(ctrl_name) {//ap1_wk_lis1.jsp 에서 호출
	document.forms[0].text_ctrl_person_id.value = ctrl_name;
}

function setBothDesc(doc_name, ctrl_name) {//ap1_wk_lis1.jsp 에서 호출
	document.forms[0].text_doc_type.value = doc_name;
	document.forms[0].text_ctrl_person_id.value = ctrl_name;
}

function Cancel()
{
	var wise = GridObj;
	//var row_idx = checkedDataRow(INDEX_SELECTED);
	//if (row_idx == -1) return;
	var pre_doc_type = "";

    var iCheckedCount = 0;
	// 지울 항목이 선택되어져 있지 않은지 체크한다.
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	/* if(grid_array>1){
		alert("한건만 선택하세요.");
		return;
	}
	if(grid_array<1){
		alert("선택된 건이 없습니다.");
		return;
	} */
	for(var i = 0; i < grid_array.length; i++)
	{
		
		//화면ID는 필수 입력으로 처리한다.
		//if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("DOC_TYPE")).getValue()) == "BID" || LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("DOC_TYPE")).getValue()) == "RA")
		//{
		//	alert("입찰공고, 역경매는 결재취소 하실 수 없습니다.");
		//	return;
		//}
		if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("APP_STATUS")).getValue()) != "P")
		{
			alert("문서의 결재상태를 확인해주세요");
			return;
		}
		if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("APP_STAGE")).getValue()) != "0")
		{
			alert("문서의 결재자목록을 확인해주세요");
			return;
		}
		iCheckedCount++;
	}
	/* for(var i=0; i<GridObj.GetRowCount();i++){
		
		var temp = GD_GetCellValueIndex(GridObj,i,"SELECTED");
        if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == "false")
            continue;
		
		var doc_type 	= "";
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == "true"){
			if(i == 0){
				pre_doc_type = GridObj.GetCellValue("DOC_TYPE", i);
			}
			else{
				if(pre_doc_type != GridObj.GetCellValue("DOC_TYPE", i)){
					alert("같은 문서형태만 가능합니다.");
					return;
				}
			}
			doc_type = GridObj.GetCellValue("DOC_TYPE", i);
			if(doc_type == "BID" || doc_type == "RA"){
				alert("입찰공고, 역경매는 결재취소 하실 수 없습니다.");
				return;
			}

			if(GD_GetCellValueIndex(GridObj,i,INDEX_APP_STATUS) != 'P'){
				alert("문서의 결재상태를 확인해주세요");
				return;
			}
			if(GD_GetCellValueIndex(GridObj,i,INDEX_APP_STAGE) != '0'){
				alert("문서의 결재자목록을 확인해주세요");
				return;
			}
		}
		iCheckedCount++;
	} */
    if(iCheckedCount < 1) {
        alert("선택된 건이 없습니다.");
        return;
    }
    if(iCheckedCount > 1) {
        alert("한건만 선택하세요.");
        return;
    }
	
	var anw = confirm("결재 취소 하시겠습니까?");
	if(anw == false) return;
	
	/* GridObj.SetParam("mode", "setCancel");
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
	GridObj.SendData(G_SERVLETURL, "ALL", "ALL"); */
	var params ="mode=setReportCancel&cols_ids="+grid_col_id;
	params+=dataOutput();
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.approval.ap_report_list",params);
    sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
	
    Query();
}

//팝업화면
function SP0129_getCode(code, text1, text3)
{
	document.forms[0].doc_type.value 		= code;
	document.forms[0].text_doc_type.value 	= text1;
	document.forms[0].ctrl_type.value 		= text3;
	document.forms[0].used_flag_doc.value 	= "on";
}

function SP0130_getCode(code, name, type)
{
	document.forms[0].ctrl_person_id.value 		= code;
	document.forms[0].text_ctrl_person_id.value = name;
	document.forms[0].used_flag_ctrl.value 		= "on";
}

function searchProfile(fc)
{
	var url = "";
	var doc_type = document.forms[0].doc_type.value;
	if(fc == "ctrl_code")
	{
		if(doc_type == "") {
			alert("문서타입을 넣어주세요");
			return;
		}else {
			var ctrl_type = document.forms[0].ctrl_type.value;
			url="/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0130&function=D&values=<%=house_code%>&values=<%=company_code%>&values="+ctrl_type;
		}
	}else
		url="/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0129&function=D&values=<%=house_code%>";
	Code_Search(url,'','','','','');
}

function JavaCall(msg1,msg2, msg3, msg4,msg5)
{
//    	alert("msg1=" +msg1+"msg2="+msg2+"msg3="+msg3+"msg4="+msg4+"msg5="+msg5);
	var wise = GridObj;

    for(var i=0;i<GridObj.GetRowCount();i++) {
           if(i%2 == 1){
		    for (var j = 0;	j<GridObj.GetColCount(); j++){
		        //GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
	        }
           }
	}

	if( msg1 == "doQuery" ){
		var row	= GridObj.GetRowCount();
		var col	= GridObj.GetColCount();

		for(var i=0;i<row;i++){
			var flag  = GD_GetCellValueIndex(GridObj,i,INDEX_ARGENT_FLAG);

			if(flag == "T"){
				for (var j = 0;	j<col; j++){
					wise.setCellbgColor( GridObj.GetColHDKey(j),i, G_ARGENT);
				}
			}
		}
	}

	if(msg1=="doData"){
		if(GD_GetParam(GridObj,0) == "1") {
			alert(GD_GetParam(GridObj,1));
			Query();
		}else {
			alert(GD_GetParam(GridObj,1));
		}
	}

	if(msg1 == "t_imagetext" && msg3 == INDEX_SCTM_SIGN_REMARK && GD_GetCellValueIndex(GridObj,msg2,msg3) != "") {
		var F=document.forms[0];
		F.subject.value = "상신의견"
		F.content.value = GD_GetCellValueIndex(GridObj,msg2,INDEX_SCTM_SIGN_REMARK);
		F.method = "POST";
		CodeSearchCommon('about:blank','pop_up3','','','620','300');
    	F.target = "pop_up3";
    	F.action = "/kr/admin/basic/approval/app_pop.jsp";
    	F.submit();

	}

	if(msg1 == "t_imagetext" && msg3 == INDEX_DOC_NO){
		var called_rtn 		= "";
		var doc_status  = "N";
		var doc_type = GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE);
		var doc_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_NO);
		var doc_seq = GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_SEQ);
		var company_code = GD_GetCellValueIndex(GridObj,msg2,INDEX_COMPANY_CODE);
		var s_doc_status = GD_GetCellValueIndex(GridObj,msg2,INDEX_APP_STATUS);
        var attach_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_ATTACH_NO);

		var add_user_name = GridObj.GetCellValue("ADD_USER_NAME", msg2);
		var add_date = GridObj.GetCellValue("ADD_DATE", msg2);
		var subject = GridObj.GetCellValue("SUBJECT", msg2);
/*
		//var br_url = "/kr/dt/ebd/ebd_pp_dis6.jsp?pr_no="+doc_no+"&doc_status="+doc_status;
		var br_url = "/kr/dt/ebd/ebd_pp_dis6_approval.jsp?pr_no="+doc_no+"&doc_status="+doc_status+"&doc_type="+doc_type+"&sign_enable=X"+"&attach_no="+attach_no;
		var dr_url = "/kr/dt/ebd/ebd_pp_dis11.jsp?pr_no="+doc_no+"&doc_status="+doc_status;
		//var ex_url = "/kr/dt/app/app_pp_approval.jsp?doc_no="+doc_no+"&doc_status="+doc_status;
		var ex_url = "/kr/dt/app/app_pp_dis4.jsp?exec_no="+doc_no+"&doc_status="+doc_status;
		var rfq_url = "/kr/dt/rfq/rfq_bd_dis1.jsp?rfq_no="+doc_no+"&rfq_count="+doc_seq+"&doc_status="+doc_status;
		//var pr_url = "/kr/dt/pr/pr1_bd_dis4.jsp?pr_no="+doc_no;
		var pr_url = "/kr/dt/pr/pr1_bd_dis4_approval.jsp?pr_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=X"+"&attach_no="+attach_no;
		//var bd_url = "/kr/dt/ebd/ebd_pp_dis9.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type;
		var bd_url = "/kr/dt/ebd/ebd_pp_dis9_approval.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=X"+"&attach_no="+attach_no;
		//var bs_url = "/kr/dt/ebd/ebd_pp_dis10.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type;
		var bs_url = "/kr/dt/ebd/ebd_pp_dis10_approval.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=X"+"&attach_no="+attach_no;
		var po_url = "/kr/order/bpo/po1_pp_dis1.jsp?po_no="+doc_no;
		var tax_url = "/asp/tax/tx2_bd_approval1.jsp?tax_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=X"+"&attach_no="+attach_no;
		var lc_url = "/kr/order/bpo/lc1_pp_dis1.jsp?lc_no="+doc_no;
		//var vn_url = "/kr/master/vendor/sta_bd_dis1.jsp?vendor_code="+doc_no;
		var ec_url = '/kr/ctr/Main.jsp?_action=HANDLE&_param=CONTRACT_READ_HANDLER&_page=CONTRACT_READ_POPUP&cont_seq='+doc_no;
		var ecf_url = '/kr/ctr/Main.jsp?_action=HANDLE&_param=CONTRACT_FORM_READ_HANDLER&_page=CONTRACT_FORM_READ_POPUP&form_seq='+doc_no;
		var inv_url = "/kr/order/ivdp/inv1_bd_dis1_approval.jsp?doc_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=X"+"&attach_no="+attach_no;
*/

		/*검수요청*/
		var inv_url = "/kr/dt/app/inv1_bd_dis1_approval.jsp?inv_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&add_user_name="+add_user_name+"&add_date="+add_date+"&subject="+subject;
		/*구매요청*/
		var pr_url = "/kr/dt/app/pr1_bd_dis4_approval.jsp?pr_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status;
		// 역경매
		var ra_url = "/kr/dt/rat/rat_pp_dis1.jsp?doc_no="+doc_no+"&doc_status="+doc_status+"&doc_type="+doc_type+"&doc_seq="+doc_seq;
		// 품의
		var ex_url_1 = "/kr/dt/app/app_pp_dis4_approval.jsp?exec_no="+doc_no+"&doc_status="+doc_status+"&sign_enable=X"+"&attach_no="+attach_no+"&doc_no="+doc_no+"&doc_type="+doc_type+"&doc_seq="+doc_seq;
		// 계약서
		var ct_url_1 = "/kr/dt/app/app_pp_dis6_approval.jsp?cont_seq="+doc_no+"&doc_status="+doc_status+"&doc_no="+doc_no+"&doc_type="+doc_type+"&doc_seq="+doc_seq;
		// 업체거래정지품의
		var vn_url_2 = "/kr/master/vendor/sta_bd_dis2_approval.jsp?vendor_code="+doc_no+"&sign_enable=X"+"&doc_no="+doc_no+"&doc_type="+doc_type+"&doc_seq="+doc_seq;
		// 견적요청
		var rfq_url = "/kr/dt/rfq/rfq_bd_approval.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=X"+"&attach_no="+attach_no + "&doc_status="+doc_status;
		// 입찰
		var bid_url = "/kr/dt/bidd/bid_approval.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=X"+"&attach_no="+attach_no + "&doc_status="+doc_status;
		// 신규공급업체등록품의
		var vn_url_1 = "/kr/master/vendor/sta_bd_dis1_approval.jsp?vendor_code="+doc_no+"&sign_enable=X"+"&doc_no="+doc_no+"&doc_type="+doc_type+"&doc_seq="+doc_seq;
		//서비스요청문의
		var sr_url = "/kr/admin/system/sr_bd_ins1_approval.jsp?sr_no="+doc_no+"&sign_enable=X&doc_status="+doc_status +"&doc_no="+doc_no+"&doc_type="+doc_type+"&doc_seq="+doc_seq;
		// 발주 
		var po_url = "/kr/dt/app/app_pp_dis7_approval.jsp?po_no="+doc_no+"&doc_status="+doc_status+"&doc_no="+doc_no+"&doc_type="+doc_type+"&doc_seq="+doc_seq;
		// 세금계산서
		var tax_url = "/kr/order/ivtx/tx1_bd_dis2.jsp?tax_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&doc_seq="+doc_seq; // 세금계산서 결재

		if(s_doc_status == "P")
              doc_status = "Y";
    	if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "BR") {
    		//CodeSearchCommon(br_url,'BDWin','','','1024','650');
    		window.open(br_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
		} else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "RA") {
			//CodeSearchCommon(ra_url,'BDWin','','','1000','490');
    		window.open(ra_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "EX") {
    		//CodeSearchCommon(ex_url,'BDWin','','','1000','650');
    		//window.open(ex_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
            window.open(ex_url_1 ,"doExplanationM1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1000,height=768,left=0,top=0");
		} else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "CT") {
    		//CodeSearchCommon(ex_url,'BDWin','','','1000','650');
    		//window.open(ex_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
            winpopup = window.open(ct_url_1 ,"doExplanationM1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
		}else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "RQ") {
			//CodeSearchCommon(rfq_url,'BDWin','','','1000','550');
    		window.open(rfq_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "PR") {
    		//CodeSearchCommon(pr_url,'BDWin','','','1000','600');
    		window.open(pr_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "BID") {
    		//CodeSearchCommon(bd_url,'BDWin','','','1024','650');
    		window.open(bid_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "DR") {
    		//CodeSearchCommon(dr_url,'BDWin','','','1000','600');
    		window.open(dr_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "BS") {
    		//CodeSearchCommon(bs_url,'BDWin','','','1024','650');
    		window.open(bs_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (doc_type == "POD") {
    		
    		//CodeSearchCommon(po_url,'BDWin','','','1000','600');
    		window.open(po_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (doc_type == "TAX") {
    		//CodeSearchCommon(tax_url,'BDWin','','','1000','800');
    		window.open(tax_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=650,left=0,top=0");
    	} else if (doc_type == "LC") {
    		//CodeSearchCommon(lc_url,'BDWin','','','1000','600');
    		window.open(lc_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	}  else if (doc_type == "VM") {
    		//CodeSearchCommon(vn_url,'BDWin','','','1000','600');
    		//window.open(vn_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    		window.open(vn_url_1 ,"doExplanationMvd","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=950,height=768,left=0,top=0");
    	}  else if (doc_type == "VN" ) {
    		//CodeSearchCommon(vn_url,'BDWin','','','1000','600');
    		//window.open(vn_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    		window.open(vn_url_2 ,"doExplanationMvd","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=950,height=768,left=0,top=0");
    	}	else if (doc_type == "EC") {
    		//CodeSearchCommon(vn_url,'BDWin','','','1000','600');
    		window.open(ec_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=750,height=768,left=0,top=0");
    	} 	else if (doc_type == "ECF") {
    		//CodeSearchCommon(vn_url,'BDWin','','','1000','600');
    		window.open(ecf_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (doc_type == "INV") {
    		window.open(inv_url ,"doExplanationM6","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	}else if(doc_type == "SR"){
    		winpopup = window.open(sr_url ,"doExplanationM1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
    	}
    	else {
    		childFrame.location.href = "/kr/admin/basic/approval/ap1_wk_dis1.jsp?doc_type="+doc_type+"&doc_no="+doc_no+"&doc_seq="+doc_seq+"&company_code="+company_code+"&divCnt=1&where=appconfirm";
		}
		/*
		var sign_url = "/kr/admin/basic/approval2/ap2_pp_lis7.jsp?company_code="+company_code+"&doc_type="+doc_type+"&doc_no="+doc_no+"&doc_seq="+doc_seq;
		var sign_popup = window.open(sign_url, "BKWin", "left=1200, top=0, width=400, height=400", "toolbar=no", "menubar=no", "status=yes", "scrollbars=no", "resizable=no");
		sign_popup.focus();
		*/

	}

	//결재의견 상세조회
	if(msg1 == "t_imagetext" && msg3 == INDEX_SCTP_SIGN_REMARK && GD_GetCellValueIndex(GridObj,msg2,msg3) != ""){
		company_code 	= GD_GetCellValueIndex(GridObj,msg2, INDEX_COMPANY_CODE);
		doc_type 		= GD_GetCellValueIndex(GridObj,msg2, INDEX_DOC_TYPE);
		doc_no 			= GD_GetCellValueIndex(GridObj,msg2, INDEX_DOC_NO);
		doc_seq 		= GD_GetCellValueIndex(GridObj,msg2, INDEX_DOC_SEQ);

		var url = "/kr/admin/basic/approval2/ap2_pp_lis5.jsp?company_code="+company_code+"&doc_type="+doc_type+"&doc_no="+doc_no+"&doc_seq="+doc_seq;
		CodeSearchCommon(url,'BKWin','550','800','700','400');
	}

	//결재자 목록
	/* if(msg1 == "t_imagetext" && msg3 == INDEX_SIGN_PATH){
		company_code 	= GD_GetCellValueIndex(GridObj,msg2, INDEX_COMPANY_CODE);
		doc_type 		= GD_GetCellValueIndex(GridObj,msg2, INDEX_DOC_TYPE);
		doc_no 			= GD_GetCellValueIndex(GridObj,msg2, INDEX_DOC_NO);
		doc_seq 		= GD_GetCellValueIndex(GridObj,msg2, INDEX_DOC_SEQ);

		var url = "/kr/admin/basic/approval2/ap2_pp_lis5.jsp?company_code="+company_code+"&doc_type="+doc_type+"&doc_no="+doc_no+"&doc_seq="+doc_seq;
		CodeSearchCommon(url,'BKWin','550','800','700','450');
	} */

	/* //첨부파일
	if(msg1 == "t_imagetext" && msg3 == INDEX_ATTACH_NO){
		var attach_no = GridObj.GetCellHiddenValue("ATTACH_NO",msg2);
		if("" == attach_no) {
			alert("첨부파일이 없습니다.");
			return;
		} else {
//			FileAttachChange('AV', attach_no,'VI');
			var doc_type = GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE );
			rMateFileAttach('P','R',doc_type,attach_no);
		}
	} */

}

function st_from_date(year,month,day,week){
	document.forms[0].from_date.value=year+month+day;
}
function st_to_date(year,month,day,week){
	document.forms[0].to_date.value=year+month+day;
}
function sign_st_from_date(year,month,day,week){
	document.forms[0].sign_from_date.value=year+month+day;
}
function sign_st_to_date(year,month,day,week){
	document.forms[0].sign_to_date.value=year+month+day;
}

function btnApprovalAll(div,divCnt,doc_no,doc_seq)
{
	var wise = GridObj;
	var row  = GridObj.GetRowCount();
	var chkCnt = 0;

	if(row>0)
	{
		for(var i=0;i<row;i++)
			GD_SetCellValueIndex(GridObj,i,0,"false&","&");
		for(var i=0;i<row;i++)
			if(doc_no == wise.getValue(i,GridObj.GetColHDIndex("doc_no")) && doc_seq == wise.getValue(i,GridObj.GetColHDIndex("doc_seq_h")))
			{
				GD_SetCellValueIndex(GridObj,i,0,"true&","&");
				chkCnt++;
			}
	} else {
		alert("Document No가 존재하지 않습니다.");
		return;
	}
	if(chkCnt==0){
		alert("Document No가 존재하지 않습니다.");
		return;
	}

	if(divCnt==1){
		if(div==1) NextApp1();
		if(div==2) EndApp();
		if(div==3) RefundApp();
	} else if(divCnt==2){
		if(div==4) Cancel();
	}
}

	function rMateFileAttach(att_mode, view_type, file_type, att_no) {
		var f = document.forms[0];

		f.att_mode.value   = att_mode;
		f.view_type.value  = view_type;
		
		if ( file_type == "CT") {
			file_type = "EX";
		}
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

//-->
</script>



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
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
	var setrow="0";
	var setcol="0";
	 var called_rtn  	= "approval";
     var doc_status  	= "N";
	
	var header_name = GridObj.getColumnId(cellInd);
	
	if(header_name=="ATTACH_NO_IMG"){
    	if(GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO")).getValue()==""){
    		alert("첨부파일이 없습니다");
    	}else{
//     		FileAttach('NOT',GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO")).getValue(),'VI', false);
			fnFiledown(GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO")).getValue());			
    	}
    }
    if(header_name=="SCTM_SIGN_REMARK_IMG"){
    	if(GridObj.cells(rowId, GridObj.getColIndexById("SCTM_SIGN_REMARK")).getValue()!=""){
    		var F=document.forms[0];
    		F.subject_1.value = "상신의견"
    		F.sctm_sign_remark.value=GridObj.cells(rowId, GridObj.getColIndexById("SCTM_SIGN_REMARK")).getValue();
    		//F.content.value = GD_GetCellValueIndex(GridObj,msg2,INDEX_SCTM_SIGN_REMARK);
    		//alert(GridObj.cells(rowId, GridObj.getColIndexById("SCTM_SIGN_REMARK")).getValue());
    		F.method = "POST";
    		CodeSearchCommon('about:blank','pop_up3','','','620','300');
        	F.target = "pop_up3";
        	F.action = "/approval/ap_pop.jsp";
        	F.submit();
    	}
    }
    if(header_name=="SCTP_SIGN_REMARK_IMG"){
    	if(GridObj.cells(rowId, GridObj.getColIndexById("SCTP_SIGN_REMARK")).getValue()!="0"){
			company_code 	= GridObj.cells(rowId, GridObj.getColIndexById("COMPANY_CODE")).getValue();
			doc_type 		= GridObj.cells(rowId, GridObj.getColIndexById("DOC_TYPE")).getValue();
			doc_no 			= GridObj.cells(rowId, GridObj.getColIndexById("DOC_NO")).getValue();
			doc_seq 		= GridObj.cells(rowId, GridObj.getColIndexById("DOC_SEQ")).getValue();
	
			var url = "/approval/ap_opinion.jsp?company_code="+company_code+"&doc_type="+doc_type+"&doc_no="+doc_no+"&doc_seq="+doc_seq;
			CodeSearchCommon(url,'BKWin','550','800','700','400');
    	}
	}
    if(header_name=="SIGN_PATH_IMG"){
    	company_code = GridObj.cells(rowId, GridObj.getColIndexById("COMPANY_CODE")).getValue();
		doc_type = GridObj.cells(rowId, GridObj.getColIndexById("DOC_TYPE")).getValue();
		doc_no = GridObj.cells(rowId, GridObj.getColIndexById("DOC_NO")).getValue();
		doc_seq = GridObj.cells(rowId, GridObj.getColIndexById("DOC_SEQ")).getValue();
		var url = "/approval/ap_user_list.jsp?company_code="+company_code+"&doc_type="+doc_type+"&doc_no="+doc_no+"&doc_seq="+doc_seq;
		CodeSearchCommon(url,'BKWin','550','800','450','400');
    }
	
    /* if(header_name=="SIGN_PATH_IMG"){
			company_code 	= GridObj.cells(rowId, GridObj.getColIndexById("COMPANY_CODE")).getValue();
			doc_type 		= GridObj.cells(rowId, GridObj.getColIndexById("DOC_TYPE")).getValue();
			doc_no 			= GridObj.cells(rowId, GridObj.getColIndexById("DOC_NO")).getValue();
			doc_seq 		= GridObj.cells(rowId, GridObj.getColIndexById("DOC_SEQ")).getValue();
	
			var url = "/approval/ap_opinion.jsp?company_code="+company_code+"&doc_type="+doc_type+"&doc_no="+doc_no+"&doc_seq="+doc_seq;
			CodeSearchCommon(url,'BKWin','550','800','700','450');
    } */
    if(header_name == "DOC_NO") {

    	
    	var doc_no = GridObj.cells(rowId, GridObj.getColIndexById("DOC_NO")).getValue();
    	var attach_no = GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO")).getValue();	
    	var proceeding_flag = GridObj.cells(rowId, GridObj.getColIndexById("PROCEEDING_FLAG")).getValue();	
    	var doc_seq = GridObj.cells(rowId, GridObj.getColIndexById("DOC_SEQ")).getValue();
    	var sign_path_seq = GridObj.cells(rowId, GridObj.getColIndexById("SIGN_PATH_SEQ")).getValue();	
    	var doc_type = GridObj.cells(rowId, GridObj.getColIndexById("DOC_TYPE")).getValue();
    	var add_user_name = GridObj.cells(rowId, GridObj.getColIndexById("ADD_USER_NAME")).getValue();	
    	var add_date = GridObj.cells(rowId, GridObj.getColIndexById("ADD_DATE")).getValue();	
    	var subject = GridObj.cells(rowId, GridObj.getColIndexById("SUBJECT")).getValue();	
    	var can_approval = GridObj.cells(rowId, GridObj.getColIndexById("CAN_APPROVAL")).getValue();	
    	
    	
    	/* 
    	if(can_approval == "Y"){
    	doc_status = "N";
    	}
    	
    		window.open("approval_detail.jsp?doc_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+
    				"&doc_status="+doc_status+/* "&proceeding_flag="+proceeding_flag+ "&doc_seq="+doc_seq+
    				 "&sign_path_seq="+sign_path_seq+ "&add_user_name="+add_user_name+"&add_date="+add_date+
    				"&subject="+subject, "_blank", "width=800, height=800, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );
    	 */
    	 
    /* 	 var doc_no = GridObj.cells(rowId, GridObj.getColIndexById("DOC_NO")).getValue();
 		var attach_no = GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO")).getValue();	
 		var proceeding_flag = GridObj.cells(rowId, GridObj.getColIndexById("PROCEEDING_FLAG")).getValue();	
 		var doc_seq = GridObj.cells(rowId, GridObj.getColIndexById("DOC_SEQ")).getValue();
 		var sign_path_seq = GridObj.cells(rowId, GridObj.getColIndexById("SIGN_PATH_SEQ")).getValue();	
 		var doc_type = GridObj.cells(rowId, GridObj.getColIndexById("DOC_TYPE")).getValue();
 		var add_user_name = GridObj.cells(rowId, GridObj.getColIndexById("ADD_USER_NAME")).getValue();	
 		var add_date = GridObj.cells(rowId, GridObj.getColIndexById("ADD_DATE")).getValue();	
 		var subject = GridObj.cells(rowId, GridObj.getColIndexById("SUBJECT")).getValue();	
 		var can_approval = GridObj.cells(rowId, GridObj.getColIndexById("CAN_APPROVAL")).getValue();	
 		var next_sign_user_id = GridObj.cells(rowId, GridObj.getColIndexById("NEXT_SIGN_USER_ID")).getValue();	 */
 		
 		if(can_approval == "Y"){
 			doc_status = "Y";
 		}
 		
 		if(doc_type == 'PR'){
 			var pr_url = "/kr/dt/app/pr1_bd_dis4_approval.jsp?pr_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq;
 			winpopup = window.open(pr_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
 		}
 		
 		else if(doc_type == 'VM'){
 			var vm_url = "/kr/master/vendor/sta_bd_dis1_approval.jsp?vendor_code="+doc_no+"&sign_enable=T&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag;
 			winpopup = window.open(vm_url ,"doExplanationMvd","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");			
 		}
 		
 		else if(doc_type == 'RA'){
 			var ra_url = "/kr/dt/rat/rat_pp_dis1.jsp?doc_no="+doc_no+"&doc_status="+doc_status+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_path_seq="+sign_path_seq+"&proceeding_flag="+proceeding_flag;
 			winpopup = window.open(ra_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
 		}
 		
 		else if(doc_type == 'INV'){
 			var inv_url = "/kr/order/ivdp/inv1_bd_dis1_approval.jsp?inv_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&add_user_name="+add_user_name+"&add_date="+add_date+"&subject="+subject+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq;
 			winpopup = window.open(inv_url ,"doExplanationM6","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
 		}
 		
 		else if(doc_type == 'RQ'){
 			var default_url = "approval_rfq.jsp?doc_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq+"&add_user_name="+add_user_name+"&add_date="+add_date+"&subject="+subject;
 			winpopup = window.open(default_url, "_blank", "width=800, height=800, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );			
 		}
 		
 		else if(doc_type == 'BID'){
 			var default_url = "approval_bid.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq+"&add_user_name="+add_user_name+"&add_date="+add_date+"&subject="+subject;
 			winpopup = window.open(default_url, "_blank", "width=800, height=800, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );			
 		}
 		
 		else if(doc_type == 'PAY'){
 			var default_url = "approval_pay.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq+"&add_user_name="+add_user_name+"&add_date="+add_date+"&subject="+subject;
 			winpopup = window.open(default_url, "_blank", "width=950, height=750, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );			
 		}
 		
 		else if(doc_type == 'CT'){
			var default_url = "approval_ct.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq+"&add_user_name="+add_user_name+"&add_date="+add_date+"&subject="+subject;
			winpopup = window.open(default_url, "_blank", "width=1050, height=950, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );			
		}

		else if(doc_type == 'POD'){
			var default_url = "approval_po.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq+"&add_user_name="+add_user_name+"&add_date="+add_date+"&subject="+subject;
			winpopup = window.open(default_url, "_blank", "width=1050, height=850, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );			
		}
 		
 		else if(doc_type == 'PSB'){
 			var default_url = "approval_psb.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq+"&add_user_name="+add_user_name+"&add_date="+add_date+"&subject="+subject;
 			winpopup = window.open(default_url, "_blank", "width=950, height=750, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );			
 		}
 		
 		else if(doc_type == 'AR'){
			var default_url = "approval_ar.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq+"&add_user_name="+add_user_name+"&add_date="+add_date+"&subject="+subject;
			winpopup = window.open(default_url, "_blank", "width=800, height=800, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );					
		}
 		
 		else{
 			var default_url = "approval_detail.jsp?doc_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq+"&add_user_name="+add_user_name+"&add_date="+add_date+"&subject="+subject;
 			winpopup = window.open(default_url, "_blank", "width=800, height=800, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );			
 		}
//  		else if(doc_type == 'BID'){
//  			var bid_url = "/kr/dt/bidd/bid_approval.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no + "&doc_status="+doc_status+"&sign_path_seq="+sign_path_seq+"&proceeding_flag="+proceeding_flag;
//  			winpopup = window.open(bid_url ,"doExplanationM1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
//  		}
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
        Query();
    } else {
        alert(messsage);
    }
/*     if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    }  */

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

function fnFiledown(attach_no){
	var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
	var b = "fileDown";
	var c = "300";
	var d = "100";
	 
	window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        Query();
    }
}
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header>
<!--내용시작-->

<%@ include file="/include/sepoa_milestone.jsp" %>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
<form name="form1" method="post" action="">
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<input type="hidden" name="att_mode" id="att_mode"  value="">
	<input type="hidden" name="view_type" id="view_type"  value="">
	<input type="hidden" name="file_type" id="file_type"  value="">
	<input type="hidden" name="tmp_att_no" id="tmp_att_no" value="">
	<!--  팝업과 손으로 입력했을때 필요한 값들...  -->
	<input type ="hidden" name="row" id="row" value="">
	<input type ="hidden" name="ctrl_type" id="ctrl_type" value="">
	<input type ="hidden" name="used_flag_doc" id="used_flag_doc" value="off">
	<input type ="hidden" name="used_flag_ctrl" id="used_flag_ctrl" value="off">
	<input type="hidden" name="ctrl_person_id" id="ctrl_person_id" value="" >
    <input type="hidden" name="text_ctrl_person_id" id="text_ctrl_person_id" value="" >
	<input type="hidden" name="subject_1" id="subject_1" value="" >

	<input type="hidden" name="sctm_sign_remark" id="sctm_sign_remark" value="">
	<!--  SCTP_SIGN_REMARK 여러줄일 경우에 대비.. -->
	<input type="hidden" name="content" id="content" value="" >
	    <tr>
			<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;상신일자</td>
			<td class="data_td" width="35%">
				<s:calendar id_to="to_date"  default_to="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString())%>" id_from="from_date" default_from="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1))%>" format="%Y/%m/%d"/>
			</td>
			<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;최종결재일자</td>
			<td class="data_td" width="35%">
			<s:calendar id_to="sign_to_date"  default_to="" id_from="sign_from_date" default_from="" format="%Y/%m/%d"/>
			</td>
	    </tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>	    
	    <tr>
			<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;결재상태</td>
			<td class="data_td" width="35%">
				<select name="app_status" id="app_status" class="inputsubmit">
					<option value=''>전체</option>
					<%
					String lb_cm_2 = ListBox(request, "SL0007", house_code + "#M109#", "P");
					out.println(lb_cm_2);
					%>
				</select>

			</td>
			<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;문서명</td>
      		<td class="data_td" width="35%">
        		<input type="text" style="width:98%" value="" name="subject" id="subject" class="inputsubmit" onkeydown='entKeyDown()'>
        	</td>
		</tr>

		<tr style="display:none;">
			<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;문서형태</td>
			<td class="data_td" width="35%" colspan="3">
				<input type="text" size="12" value="" name="" class="inputsubmit">
				<a href="javascript:searchProfile( 'doc_type' )"><img src="" align="absmiddle" border="0"></a>
				<input type="text" size="20" value="" name="text_doc_type" id="text_doc_type" class="input_data2" readOnly></td>
		</tr>

		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;문서번호</td>
			<td class="data_td" width="35%">
				<input type="text" style="width:35%;ime-mode:inactive" value="" name="DOC_NO" id="DOC_NO" class="inputsubmit" onkeydown='entKeyDown()'>
			</td>
			<!-- 2011.3.25 정민석 문서형태 입찰공고, 서비스요청, 업체승인, 업체거래중지 항목 주석처리후
   				 구매요청품의, 검수요청품의 추가 -->
  			<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;문서형태</td>
      		<td class="data_td" width="35%" colspan="3">
      			<select name="doc_type" id="doc_type" class="inputsubmit">
      				<option value="">전체</option>
      				<option value="PR">구매요청</option>
      				<option value="RQ">견적의뢰</option>
      				<option value="BID">입찰공고</option>
      				<option value="CT">전자계약</option>
      				<option value="POD">발주</option>      				
      			<!--<option value="RA">역경매</option> -->
      				<option value="PAY">경상비</option>
      			<!--<option value="VM">업체승인</option> -->
      				<option value="PSB">자본예산지급</option>
      				<option value="AR">계좌번호변경</option>      		      				
				<!--<option value="EX">구매기안</option> -->
				<!--<option value="CT">계약번호</option> -->				    
				<!--<option value="INV">검수요청기안</option> -->
				<!--<option value="TAX">세금계산서</option> -->
    			<!--<option value="SR">서비스요청</option> -->
    			<!--<option value="VN">업체거래정지</option> -->
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
				<TABLE cellpadding="2" cellspacing="0">
		      		<TR>
	   					<TD><script language="javascript">btn("javascript:Query()","조 회")</script></TD>
	   					<TD><script language="javascript">btn("javascript:Cancel()","결재취소")</script></TD>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
	<%-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
 		<tr>
			<td height="1" class="cell"></td>
		<!-- wisegrid 상단 bar -->
		</tr>
		<tr>
			<td align="center">
				<%=WiseTable_Scripts("100%","300")%>
			</td>
		</tr>
	</table> --%>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
			</td>
		</tr>
	</table>
</form>
<iframe name = "childFrame" WIDTH="0" Height="0" border="0" scrolling="no" frameborder="0"></iframe>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="AP_008" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


