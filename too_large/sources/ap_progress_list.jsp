<%@ page contentType = "text/html; charset=UTF-8" %> 
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AP_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AP_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	isRowsMergeable = true;
	
%>
<%-- <%@ include file="/include/wisehub_session.jsp" %>
<%@ include file="/include/wisehub_common.jsp"%>
<% String WISEHUB_PROCESS_ID="AP_003";%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/wisetable_scripts.jsp"%>
<%@ include file="/include/wisehub_scripts.jsp"%> --%>

<!-- Session 정보 && Parameter 정보 -->
<%
	String house_code 	= JSPUtil.nullToEmpty(info.getSession("HOUSE_CODE"));
	String company_code = JSPUtil.nullToEmpty(info.getSession("COMPANY_CODE"));
	String user_id 		= JSPUtil.nullToEmpty(info.getSession("ID"));
	String dept 		= JSPUtil.nullToEmpty(info.getSession("DEPARTMENT"));
	
    String sign_mode	= JSPUtil.nullToEmpty(request.getParameter("sign_mode"));

	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간

    String TITLE = "";
    if(sign_mode.equals("N")){
    	TITLE = "결재할문서";
    }else if (sign_mode.equals("P")){
    	TITLE = "진행중문서";
    }else if (sign_mode.equals("E")){
    	TITLE = "완료문서함";
    }else{
    	TITLE = "결재함";
    }
%>

<html>
	<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
		<script language="javascript">

//<!--

<%-- var G_SERVLETURL = "<%=getWiseServletPath("admin.basic.approval2.ap2_bd_lis2")%>"; --%>

var current_date = "<%=current_date%>";
var current_time = "<%=current_time%>";

var INDEX_SELECTED		    = "";
var INDEX_APP_STATUS	    = "";
var INDEX_APP_STATUS_TESXT  = "";
var INDEX_DOC_TYPE_TEXT     = "";
var INDEX_DOC_TYPE	        = "";
var INDEX_DOC_NO	        = "";
var INDEX_DOC_SEQ	        = "";
var INDEX_ITEM_COUNT		= "";
var INDEX_ADD_USER_NAME     = "";
var INDEX_ADD_USER_ID	    = "";
var INDEX_SIGN_REMARK	    = "";
var INDEX_ADD_DATE	        = "";
var INDEX_CUR	        	= "";
var INDEX_TTL_AMT	        = "";
var INDEX_SIGN_PATH	        = "";
var INDEX_ACCOUNT_CODE	    = "";
var INDEX_SHIPPER_TYPE_TEXT = "";
var INDEX_SHIPPER_TYPE		= "";
var INDEX_ARGENT_FLAG		= "";
var INDEX_COMPANY_CODE		= "";
var INDEX_NEXT_SIGN_USER_ID	= "";
var INDEX_STRATEGY_TYPE		= "";
var INDEX_APP_STAGE			= "";
var INDEX_SUBJECT			= "";
var INDEX_ATTACH_NO			= "";
var INDEX_PERSON_APP_STATUS = "";
var INDEX_SIGN_PATH_SEQ 	= "";
var INDEX_CAN_APPROVAL		= "";
var INDEX_PROCEEDING_FLAG	= "";

var winpopup = "";

function Init()
{
setGridDraw();
setHeader();
    Query();
}

function setHeader()
{
	
	
	//GridObj.AddHeader("NEXT_SIGN_USER_NAME",	"차기결재자","t_text",10,60,false);

	/* GridObj.SetNumberFormat("ITEM_COUNT",	G_format_etc);
	GridObj.SetDateFormat("ADD_DATE",		"yyyy/MM/dd");
	GridObj.SetDateFormat("SIGN_DATE",	"yyyy/MM/dd");
	GridObj.SetNumberFormat("TTL_AMT",	G_format_qty); */


	INDEX_SELECTED		    = GridObj.GetColHDIndex("SELECTED");
	INDEX_APP_STATUS	    = GridObj.GetColHDIndex("APP_STATUS");
	INDEX_APP_STATUS_TEXT   = GridObj.GetColHDIndex("APP_STATUS_TEXT");
	INDEX_PERSON_APP_STATUS = GridObj.GetColHDIndex("PERSON_APP_STATUS");
	INDEX_DOC_TYPE_TEXT     = GridObj.GetColHDIndex("DOC_TYPE_TEXT");
	INDEX_DOC_TYPE	        = GridObj.GetColHDIndex("DOC_TYPE");
	INDEX_DOC_NO	        = GridObj.GetColHDIndex("DOC_NO");
	INDEX_SUBJECT	        = GridObj.GetColHDIndex("SUBJECT");
	INDEX_DOC_SEQ	        = GridObj.GetColHDIndex("DOC_SEQ");
	INDEX_ITEM_COUNT		= GridObj.GetColHDIndex("ITEM_COUNT");
	INDEX_ADD_USER_NAME     = GridObj.GetColHDIndex("ADD_USER_NAME");
	INDEX_ADD_USER_ID     	= GridObj.GetColHDIndex("ADD_USER_ID");
	INDEX_SIGN_REMARK	    = GridObj.GetColHDIndex("SIGN_REMARK");
	INDEX_ADD_DATE	        = GridObj.GetColHDIndex("ADD_DATE");
	INDEX_CUR	        	= GridObj.GetColHDIndex("CUR");
	INDEX_TTL_AMT	        = GridObj.GetColHDIndex("TTL_AMT");
	INDEX_SIGN_PATH	        = GridObj.GetColHDIndex("SIGN_PATH");
	INDEX_ACCOUNT_CODE	    = GridObj.GetColHDIndex("ACCOUNT_CODE");
	INDEX_SHIPPER_TYPE_TEXT = GridObj.GetColHDIndex("SHIPPER_TYPE_TEXT");
	INDEX_SHIPPER_TYPE		= GridObj.GetColHDIndex("SHIPPER_TYPE");
	INDEX_ARGENT_FLAG		= GridObj.GetColHDIndex("ARGENT_FLAG");
	INDEX_COMPANY_CODE		= GridObj.GetColHDIndex("COMPANY_CODE");
	INDEX_NEXT_SIGN_USER_ID	= GridObj.GetColHDIndex("NEXT_SIGN_USER_ID");
	INDEX_STRATEGY_TYPE		= GridObj.GetColHDIndex("STRATEGY_TYPE");
	INDEX_APP_STAGE			= GridObj.GetColHDIndex("APP_STAGE");
	INDEX_ATTACH_NO			= GridObj.GetColHDIndex("ATTACH_NO"		);
	INDEX_SIGN_PATH_SEQ		= GridObj.GetColHDIndex("SIGN_PATH_SEQ"		);
	INDEX_CAN_APPROVAL		= GridObj.GetColHDIndex("CAN_APPROVAL"		);
	INDEX_PROCEEDING_FLAG	= GridObj.GetColHDIndex("PROCEEDING_FLAG"		);

}

function Query(type){

 if(type == "close")
 {
    winpopup.close();
 }
	var wise = GridObj;
	var F = document.forms[0];

	var doc_type 		= F.doc_type.value.toUpperCase();
	var shipper_type 	= F.shipper_type.value;
	var app_status 		= F.app_status.value;
	var doc_no 			= F.DOC_NO.value;
	var ctrl_person_id 	= F.ctrl_person_id.value;
	var from_date 		= F.from_date.value;
	var to_date 		= F.to_date.value;
	var sign_from_date 	= F.sign_from_date.value;
	var sign_to_date 	= F.sign_to_date.value;
	var ctrl_type 		= F.ctrl_type.value;
	var used_flag_doc 	= F.used_flag_doc.value;
	var used_flag_ctrl 	= F.used_flag_ctrl.value;
    var person_app_status = F.person_app_status.value;
    var subject 		= F.subject.value;
    var add_user_name 	= F.add_user_name.value;

	if(doc_type == "") F.text_doc_type.value = "";
	if(ctrl_person_id == "") F.text_ctrl_person_id.value = "";

	if (used_flag_doc == "off" && ctrl_person_id == "" && doc_type != "") { //alert("doc_type 만 손으로 입력됨");
		//getDiscription(doc_type, "", "", "1");
	}else if (used_flag_ctrl == "off" && ctrl_person_id != "" && ctrl_type != "" && doc_type != "" ) { //alert("ctrl만 손으로 입력됨 ");
		//getDiscription("", ctrl_type, ctrl_person_id, "2");
	}else if(used_flag_doc == "off" && used_flag_ctrl == "off" && ctrl_person_id != "" && ctrl_type == "" && doc_type != "") { //alert("둘다 손으로 입력됨");
		//getDiscription(doc_type, ctrl_type, ctrl_person_id, "3");
	}

	/* GridObj.SetParam("mode",			"ApprovalList");
	GridObj.SetParam("doc_type",		doc_type);
	GridObj.SetParam("doc_no",			doc_no);
	GridObj.SetParam("shipper_type",	shipper_type);
	GridObj.SetParam("app_status",		app_status);
	GridObj.SetParam("ctrl_person_id",	ctrl_person_id);
	GridObj.SetParam("from_date",		from_date);
	GridObj.SetParam("to_date",		to_date);
	GridObj.SetParam("sign_from_date",	sign_from_date);
	GridObj.SetParam("sign_to_date",		sign_to_date);	
	GridObj.SetParam("person_app_status",	person_app_status);
	GridObj.SetParam("proceeding_flag","P");
	GridObj.SetParam("subject",subject);
	GridObj.SetParam("add_user_name",add_user_name);

	

	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(G_SERVLETURL);
	GridObj.strHDClickAction="sortmulti"; */
	F.used_flag_doc.value = "off";
	F.used_flag_ctrl.value = "off";
	
	var param ="mode=getProgressList&grid_col_id="+grid_col_id;
	param +="&proceeding_flag=P"
	var url	= "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.approval.ap_progress_list";
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


// 차기결제자 , 결제 승인 하기
function Confirm(app_type,app_person) {
	var app_person = app_person;
	var remark = "";//5.25 remark를 넣을수 있는 html을 사용안함

	if(app_type == 'N') {
		if(app_person == "") {
			alert("차기결재자를 지정해야 합니다.");
			return;
		}
	}

	var servletUrl = "/servlet/admin.basic.approval.app_upd1";
	GridObj.SetParam("app_person",app_person);
	GridObj.SetParam("remark",remark);
	GridObj.SetParam("app_type",app_type);
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
	GridObj.strHDClickAction="sortmulti";
}

/*차기 결재 버튼을 눌렀을때.. (선택된 문서의 번호, 타입, 차수는 jsp에서 파라미터로 넘겨준다.)*/
function NextApp1(next_sign_user_id) {
	var wise = GridObj;
	var app_type = "N";   /* 결재 타입:차기결재  */
	var doc_no = "";
	var doc_type = "";
	var doc_seq = "";
	var doc_seq_h = "";
	var app_person = next_sign_user_id;
	var app_stage = "";
	var urgent = "";
	var shipper_type = "";
	var sel_row = "";
	var temp_type = "";
	var company_code_h = "";
	var temp_type_count = 0;
	var checkedrowcount = 0; // 5.27 체크한 줄이 20개가 넘으면 결재 처리 안되도록 한다.

	for(var i=0; i<GridObj.GetRowCount();i++){
		var temp = GD_GetCellValueIndex(GridObj,i,0);
		if(temp == "true") {
			sel_row += i + "&";

			if(temp_type_count == 0) {
				temp_type = wise.getValue(i,GridObj.GetColHDIndex("doc_type_h"));
				temp_type_count = 1;
			} else if(temp_type != wise.getValue(i,GridObj.GetColHDIndex("doc_type_h"))){
				alert("문서형태가 같아야합니다.");
				return;
			}

			if(wise.getValue(i,GridObj.GetColHDIndex("status_h")) != 'P') {
				alert("문서의 결재상태를 확인해주세요");
				return;
			}

			if (checkedrowcount >= 20 )
			{
				alert("20건 까지 한번에 결재할 수 있습니다.");
				return;
			}
			checkedrowcount++;
		}
	}

	if(sel_row == "") {
		alert("항목을 선택해주세요");
		return;
	}

	//5.25 결재양이 많다는 요청으로 수정이 가해짐.
	//차기 결재자 선택후 바로 차기결재 프로세스를 돌림.
	winobj = window.open("/kr/admin/basic/approval2/ap2_pp_lis4.jsp?app_type="+app_type+"&app_person="+app_person, "pop_up1", "status=yes, resizable=yes width=500 height=480");
	winobj.focus();

	//Confirm(app_type,app_person);
}

/* 승인 버튼을 눌렀을때.. (선택된 문서의 번호, 타입, 차수는 jsp에서 파라미터로 넘겨준다.)*/
function EndApp(){
	var wise = GridObj;

	var temp_type = "";
	var temp_type_count = 0;
	var strategy = "";
	var doc_no = "";
	var doc_type = "";
	var text_doc_type = "";
	var doc_seq = "";
	var shipper_type = "";
	var company_code ="";
	var checkedrowcount = 0; // 5.27 체크한 줄이 20개가 넘으면 결재 처리 안되도록 한다.
	var next_sign_user_id = "";
    var tax_cnt = 0;
	for(var i=0; i<GridObj.GetRowCount();i++){
		var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);
		if(temp == "true") {
			next_sign_user_id = GD_GetCellValueIndex(GridObj,i,INDEX_NEXT_SIGN_USER_ID);

			if (next_sign_user_id == "") //차기 결재자가 없는것 = 결재 완료 인것
			{
				if(temp_type_count == 0) {
					temp_type = GD_GetCellValueIndex(GridObj,i,INDEX_DOC_TYPE);
					temp_type_count = 1;
				} else if(temp_type != GD_GetCellValueIndex(GridObj,i,INDEX_DOC_TYPE)){
					alert("문서형태가 같아야합니다.");
					return;
				}
				if(GD_GetCellValueIndex(GridObj,i,INDEX_APP_STATUS) != 'P') {
					alert("문서의 결재상태를 확인해주세요");
					return;
				}
				if(GD_GetCellValueIndex(GridObj,i,INDEX_PERSON_APP_STATUS) == '완료') {
					alert("이미 결재하신건입니다.");
					return;
				}

				if (checkedrowcount >= 20 ){
					alert("20건 까지 한번에 결재할 수 있습니다.");
					return;
				}
				checkedrowcount++;
				if(GD_GetCellValueIndex(GridObj,i,INDEX_STRATEGY_TYPE)== "" )
				    strategy += "";
				else
				    strategy += GD_GetCellValueIndex(GridObj,i,INDEX_STRATEGY_TYPE) + " $";

				doc_no += GD_GetCellValueIndex(GridObj,i,INDEX_DOC_NO) + " $";
				doc_type += GD_GetCellValueIndex(GridObj,i,INDEX_DOC_TYPE) + " $";
				text_doc_type += GD_GetCellValueIndex(GridObj,i,INDEX_DOC_TYPE_TEXT ) + " $";
				doc_seq += GD_GetCellValueIndex(GridObj,i,INDEX_DOC_SEQ) + " $";

				if(GD_GetCellValueIndex(GridObj,i,INDEX_SHIPPER_TYPE) == "")
					shipper_type += "X" + " $";
				else
					shipper_type += GD_GetCellValueIndex(GridObj,i,INDEX_SHIPPER_TYPE) + " $";
				company_code += GD_GetCellValueIndex(GridObj,i,INDEX_COMPANY_CODE) + " $";

				//세금계산서의 경우 한건씩만 결재가능토록한다.
				if(GD_GetCellValueIndex(GridObj,i,INDEX_DOC_TYPE) == 'TAX') {
					tax_cnt++;
				}
            }
		}
	}

    if (tax_cnt > 1)
    {
    	alert("세금계산서 문서의 경우 SAP연계 특성상 한건씩 결재가능합니다.");
		return;
	}


	var row_idx = checkedDataRow(INDEX_SELECTED);
	if (row_idx < 1) return;
	if(LRTrim(strategy) != "" && checkedrowcount != 0 )
	{ EndApp3();///////////////////////////////
//	    parent.work.location.href = "/kr/admin/basic/approval/ap1_wk_flg1.jsp?strategy="+strategy+"&doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&text_doc_type="+text_doc_type+"&company_code="+company_code+"&dom_exp_flag="+shipper_type;
	}
	else
	{
	    EndApp3();
	}
}

/* 결재전략을 체크한뒤에 호출되어지는 종료결재*/
function EndApp2(result, message) {
	if(result == "true"){
	    //alert("EndApp2에서  EndApp3 호출");
	    EndApp3();
	}
	else
	    alert(message);
}

function sign_Close(doc_no,type)
{
	row = GridObj.GetRowCount();

	for(var i=0;i<row;i++)
	{
    	GD_SetCellValueIndex(GridObj,i, "0", "false&", "&");

        if(doc_no == GridObj.getValue(i,GridObj.GetColHDIndex("DOC_NO")))
    	    GD_SetCellValueIndex(GridObj,i, "0", "true&", "&");
    }

    if(type == "E")
        EndApp3();
    else
        RefundApp();
}

function sign_Close_RFQ(doc_no,doc_seq, type)
{
	row = GridObj.GetRowCount();

	for(var i=0;i<row;i++)
	{
    	GD_SetCellValueIndex(GridObj,i, "0", "false&", "&");

        if(doc_no == GridObj.getValue(i,GridObj.GetColHDIndex("doc_no")) && doc_seq == GridObj.getValue(i,GridObj.GetColHDIndex("doc_seq")) )
    	    GD_SetCellValueIndex(GridObj,i, "0", "true&", "&");
    }

    if(type == "E")
        EndApp3();
    else
        RefundApp();
}

/*ICOMSCTM에 종료결재 처리를 하는 실제 종료결재*/
function EndApp3()
{
	var app_type = "E";   /* 결재 타입: 결재,차기 결재  */
	var url = "/kr/admin/basic/approval2/ap2_pp_lis4.jsp?app_type="+app_type
	CodeSearchCommon(url,'pop_up2','800','400','800','400');
}

/* 반려 버튼을 눌렀을때..(선택된 문서의 번호, 타입, 차수는 jsp에서 파라미터로 넘겨준다.) */
function RefundApp()
{
	var wise = GridObj;
	var app_type = "R";   /* 결재 타입:반려  */
	var doc_no = "";
	var doc_type = "";
	var doc_seq = "";
	var doc_seq_h = "";
	var app_person = "";
	var app_stage = "";
	var urgent = "";
	var shipper_type = "";
	var sel_row = "";
	var temp_type = "";
	var company_code_h = "";
	var temp_type_count = 0;
	var checkedrowcount = 0; // 5.27 체크한 줄이 20개가 넘으면 결재 처리 안되도록 한다.

	for(var i=0; i<GridObj.GetRowCount();i++){
		var temp = GD_GetCellValueIndex(GridObj,i,0);
		if(temp == "true") {
			sel_row += i + "&";

			if(temp_type_count == 0) {
				temp_type = GD_GetCellValueIndex(GridObj,i,INDEX_DOC_TYPE);
				temp_type_count = 1;
			} else if(temp_type != GD_GetCellValueIndex(GridObj,i,INDEX_DOC_TYPE)){
				alert("문서형태가 같아야합니다.");
				return;
			}
			if(GD_GetCellValueIndex(GridObj,i,INDEX_APP_STATUS) != 'P') {
				alert("문서의 결재상태를 확인해주세요");
				return;
			}
			if (checkedrowcount >= 20 ){
				alert("20건 까지 한번에 결재할 수 있습니다.");
				return;
			}

			checkedrowcount++;
		}
	}

	if(sel_row == "") {
		alert("항목을 선택해주세요");
		return;
	}
	var url = "/kr/admin/basic/approval2/ap2_pp_lis4.jsp?app_type="+app_type
	CodeSearchCommon(url,'pop_up3','650','800','800','400');
}

//팝업화면
function SP0129_getCode(code, text1, text3) {
	document.forms[0].doc_type.value = code;
	document.forms[0].text_doc_type.value = text1;
	document.forms[0].ctrl_type.value = text3;
	document.forms[0].used_flag_doc.value = "on";
}

function SP0130_getCode(code, name, type) {
	document.forms[0].ctrl_person_id.value = code;
	document.forms[0].text_ctrl_person_id.value = name;
	document.forms[0].used_flag_ctrl.value = "on";
}

function searchProfile(fc) {
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
	var wise = GridObj;
    var row	= GridObj.GetRowCount();

	if( msg1 == "doQuery" )
	{
    	var col	= GridObj.GetColCount();

		for(var i=0;i<GridObj.GetRowCount();i++)
		{
            var flag  = GD_GetCellValueIndex(GridObj,i,INDEX_ARGENT_FLAG);

            if(flag == "T"){
			    for (var j = 0;	j<col; j++){
			        GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, G_ARGENT);
		        }
            }
		}
		/* if(row == 0){
			document.all.HTML_SHOW.style.display = "inline" ;
			document.all.GRID_SHOW.style.display = "none" 	;
		}else{
			document.all.HTML_SHOW.style.display = "none" ;
			document.all.GRID_SHOW.style.display = "inline";
		} */
	}

	if(msg1=="doData")
	{
		if(GD_GetParam(GridObj,0) == "1") {
			if(GD_GetParam(GridObj,1) == "E") alert("결재가 처리되었습니다.");
			else if(GD_GetParam(GridObj,1) == "N") alert("결재가 처리되었습니다.");
		}else {
			if(GD_GetParam(GridObj,1) == "E") alert("결재처리가 실패되었습니다."+GD_GetParam(GridObj,2));
			else if(GD_GetParam(GridObj,1) == "N") alert("결재처리가 실패되었습니다."+GD_GetParam(GridObj,2));
		}
	    Query();
	}

	if(msg1 == "t_imagetext" && msg3 == INDEX_DOC_NO)
	{
        var called_rtn  	= "approval";
        var doc_status  	= "N";
		var doc_type 		= GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE);
		var doc_no 			= GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_NO);
		var doc_seq 		= GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_SEQ);
		var company_code 	= GD_GetCellValueIndex(GridObj,msg2,INDEX_COMPANY_CODE);
		var s_doc_status 	= GD_GetCellValueIndex(GridObj,msg2,INDEX_APP_STATUS);
		var attach_no 		= GD_GetCellValueIndex(GridObj,msg2,INDEX_ATTACH_NO);
		var sign_path_seq 	= GD_GetCellValueIndex(GridObj,msg2,INDEX_SIGN_PATH_SEQ);
		var can_approval	= GD_GetCellValueIndex(GridObj,msg2,INDEX_CAN_APPROVAL);
		var proceeding_flag = GD_GetCellValueIndex(GridObj,msg2,INDEX_PROCEEDING_FLAG);

		var add_user_name = GridObj.GetCellValue("ADD_USER_NAME", msg2);
		var add_date = GridObj.GetCellValue("ADD_DATE", msg2);
		var subject = GridObj.GetCellValue("SUBJECT", msg2);
		//if(s_doc_status == "P"){
		if(can_approval == "Y"){
			doc_status = "Y";
		}
		/*
		//var br_url = "/kr/dt/ebd/ebd_pp_dis6.jsp?pr_no="+doc_no+"&doc_status="+doc_status;
		var br_url = "/kr/dt/ebd/ebd_pp_dis6_approval.jsp?pr_no="+doc_no+"&doc_status="+doc_status+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no; // 정식입찰의회 요청
		var dr_url = "/kr/dt/ebd/ebd_pp_dis11.jsp?pr_no="+doc_no+"&doc_status="+doc_status; // 입찰요청 상세현황
		var ra_url = "/kr/dt/rat/rat_pp_dis1.jsp?doc_no="+doc_no+"&doc_status="+doc_status+"&doc_seq="+doc_seq+"&doc_type="+doc_type; // 역경매 결재
		//var ex_url = "/kr/dt/app/app_pp_approval.jsp?doc_no="+doc_no+"&doc_status="+doc_status;
		var ex_url = "/kr/dt/app/app_pp_dis4.jsp?exec_no="+doc_no+"&doc_status="+doc_status; // 품의 상세 화면
		var ex_url_1 = "/kr/dt/app/app_pp_dis4_approval.jsp?exec_no="+doc_no+"&doc_status="+doc_status+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no; // 구매품의서
		var rfq_url = "/kr/dt/rfq/rfq_bd_dis1.jsp?rfq_no="+doc_no+"&rfq_count="+doc_seq+"&doc_status="+doc_status; // 견적요청 상세조회
		//var pr_url = "/kr/dt/pr/pr1_bd_dis4.jsp?pr_no="+doc_no;
		var pr_url = "/kr/dt/pr/pr1_bd_dis4_approval.jsp?pr_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no; // 구매요청 요청
		//var bd_url = "/kr/dt/ebd/ebd_pp_dis9.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type;
		var bd_url = "/kr/dt/ebd/ebd_pp_dis9_approval.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no; //정식입찰진행품의
		//var bs_url = "/kr/dt/ebd/ebd_pp_dis10.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type;
		var bs_url = "/kr/dt/ebd/ebd_pp_dis10_approval.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no; //우선협상대상선정품의
		var po_url = "/kr/order/bpo/po1_pp_dis1.jsp?po_no="+doc_no; // 발주생성화면(외자)
		var tax_url = "/asp/tax/tx2_bd_approval1.jsp?tax_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no; // 전사세금계산서 발행
		var lc_url = "/kr/order/bpo/lc1_pp_dis1.jsp?lc_no="+doc_no; // L / C 상세화면
		//var vn_url = "/kr/master/vendor/sta_bd_dis1.jsp?vendor_code="+doc_no;
		var vm_url = "/kr/master/vendor/sta_bd_dis1_approval.jsp?vendor_code="+doc_no+"&sign_enable=T"; // 신규공급업체등록품의
		var vn_url = "/kr/master/vendor/sta_bd_dis2_approval.jsp?vendor_code="+doc_no+"&sign_enable=T&doc_status="+doc_status; // 업체거래정지 품의
		var ec_url = '/kr/ctr/Main.jsp?_action=HANDLE&_param=CONTRACT_READ_HANDLER&_page=CONTRACT_READ_POPUP&cont_seq='+doc_no;
		var ecf_url = '/kr/ctr/Main.jsp?_action=HANDLE&_param=CONTRACT_FORM_READ_HANDLER&_page=CONTRACT_FORM_READ_POPUP&form_seq='+doc_no;
		var inv_url = "/kr/order/ivdp/inv1_bd_dis1_approval.jsp?doc_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no;	// 매입 일반(지로,프리랜서) 전표
		var bid_url = "/kr/dt/bidd/bid_approval.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no + "&doc_status="+doc_status;	// 입찰
		*/
		/*검수요청*/
		var inv_url = "/kr/order/ivdp/inv1_bd_dis1_approval.jsp?inv_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&add_user_name="+add_user_name+"&add_date="+add_date+"&subject="+subject+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq;
		/*구매요청*/
		var pr_url = "/kr/dt/app/pr1_bd_dis4_approval.jsp?pr_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq;
		// 역경매 결재 --
		var ra_url = "/kr/dt/rat/rat_pp_dis1.jsp?doc_no="+doc_no+"&doc_status="+doc_status+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_path_seq="+sign_path_seq+"&proceeding_flag="+proceeding_flag;
		// 구매품의서 --
		var ex_url_1 = "/kr/dt/app/app_pp_dis4_approval.jsp?exec_no="+doc_no+"&doc_status="+doc_status+"&doc_no="+doc_no+"&doc_type="+doc_type+"&doc_seq="+doc_seq+"&sign_enable=T"+"&attach_no="+attach_no+"&sign_path_seq="+sign_path_seq+"&proceeding_flag="+proceeding_flag;
		// 계약서
		var ct_url_1 = "/kr/dt/app/app_pp_dis6_approval.jsp?cont_seq="+doc_no+"&doc_status="+doc_status+"&doc_no="+doc_no+"&doc_type="+doc_type+"&doc_seq="+doc_seq+"&sign_enable=T"+"&attach_no="+attach_no+"&sign_path_seq="+sign_path_seq+"&proceeding_flag="+proceeding_flag;
		// 업체거래정지 품의 --
		var vn_url = "/kr/master/vendor/sta_bd_dis2_approval.jsp?vendor_code="+doc_no+"&sign_enable=T&doc_status="+doc_status+"&doc_type="+doc_type+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq+"&proceeding_flag="+proceeding_flag;
		// 견적요청 --
		var rfq_url = "/kr/dt/rfq/rfq_bd_approval.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no + "&doc_status="+doc_status+"&sign_path_seq="+sign_path_seq+"&proceeding_flag="+proceeding_flag;
		// 입찰 --
		var bid_url = "/kr/dt/bidd/bid_approval.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no + "&doc_status="+doc_status+"&sign_path_seq="+sign_path_seq+"&proceeding_flag="+proceeding_flag;
		// 신규공급업체등록품의 --
		var vm_url = "/kr/master/vendor/sta_bd_dis1_approval.jsp?vendor_code="+doc_no+"&sign_enable=T&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag;
		// 서비스요청문의
		var sr_url = "/kr/admin/system/sr_bd_ins1_approval.jsp?sr_no="+doc_no+"&sign_enable=T&doc_status="+doc_status+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_path_seq="+sign_path_seq+"&proceeding_flag="+proceeding_flag;
		// 예정가격 품의
		var es_url = "/kr/dt/bidd/ebd_bd_ins9_pop.jsp?DOC_NO="+doc_no+"&BID_COUNT="+doc_seq+"&SIGN_PATH_SEQ="+sign_path_seq+"&DOC_STATUS="+doc_status+"&PROCEEDING_FLAG="+proceeding_flag ;
		// 퉁합품의
		var tex_url = "/kr/dt/app/app_pp_dis5_approval.jsp?texec_no="+doc_no+"&doc_status="+doc_status+"&doc_no="+doc_no+"&doc_type="+doc_type+"&doc_seq="+doc_seq+"&sign_enable=T"+"&attach_no="+attach_no+"&sign_path_seq="+sign_path_seq+"&proceeding_flag="+proceeding_flag;
		/*직발주*/
		//var po_url = "/kr/order/bpo/po1_pp_dis1.jsp?po_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq; // 직발주생성화면(외자)
		var po_url = "/kr/dt/app/app_pp_dis7_approval.jsp?po_no="+doc_no+"&doc_status="+doc_status+"&doc_no="+doc_no+"&doc_type="+doc_type+"&doc_seq="+doc_seq+"&sign_enable=T"+"&attach_no="+attach_no+"&sign_path_seq="+sign_path_seq+"&proceeding_flag="+proceeding_flag;
		
		var dcl_url = "/kr/order/ivtr/tr1_bd_dis3.jsp?pay_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq; // 거래명세서 결재

		var tax_url = "/kr/order/ivtx/tx1_bd_dis2.jsp?tax_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq; // 세금계산서 결재

		///kr/admin/system/sr_bd_ins1.jsp

		/* 결재자 목록 */
		var sign_url = "/kr/admin/basic/approval2/ap2_pp_lis7.jsp?company_code="+company_code+"&doc_type="+doc_type+"&doc_no="+doc_no+"&doc_seq="+doc_seq;

		/* 결재자 목록 팝업 -- 문서번호를 클릭시에 결재문서와 결재자 목록이 팝업으로 동시에 나타남 */
		//var sign_popup = window.open(sign_url, "BKWin", "left=1200, top=0, width=400, height=400", "toolbar=no", "menubar=no", "status=yes", "scrollbars=no", "resizable=no");
   		//sign_popup.focus();

    	if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "BR") {
    		//CodeSearchCommon(br_url,'BDWin','','','1024','650');
    		winpopup = window.open(br_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
		} else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "RA") {
			//CodeSearchCommon(ra_url,'BDWin','','','1000','490');
    		winpopup = window.open(ra_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "EX") {
    		//CodeSearchCommon(ex_url,'BDWin','','','1000','650');
    		//window.open(ex_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
            winpopup = window.open(ex_url_1 ,"doExplanationM1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
		} else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "CT") {
    		//CodeSearchCommon(ex_url,'BDWin','','','1000','650');
    		//window.open(ex_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
            winpopup = window.open(ct_url_1 ,"doExplanationM1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
		} else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "RQ") {
			//CodeSearchCommon(rfq_url,'BDWin','','','1000','550');
    		winpopup = window.open(rfq_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "PR") {
    		//CodeSearchCommon(pr_url,'BDWin','','','1000','600');
    		winpopup = window.open(pr_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "BD") {
    		//CodeSearchCommon(bd_url,'BDWin','','','1024','650');
    		winpopup = window.open(bd_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "DR") {
    		//CodeSearchCommon(dr_url,'BDWin','','','1000','600');
    		winpopup = window.open(dr_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE) == "BS") {
    		//CodeSearchCommon(bs_url,'BDWin','','','1024','650');
    		winpopup = window.open(bs_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (doc_type == "PO") {
    		//CodeSearchCommon(po_url,'BDWin','','','1000','600');
    		winpopup = window.open(bs_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (doc_type == "POD") {
    		//CodeSearchCommon(po_url,'BDWin','','','1000','600');
    		winpopup = window.open(po_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (doc_type == "DCL") {
    		//CodeSearchCommon(po_url,'BDWin','','','1000','600');
    		winpopup = window.open(dcl_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (doc_type == "TAX") {
    		//CodeSearchCommon(tax_url,'BDWin','','','1000','800');
    		winpopup = window.open(tax_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=650,left=0,top=0");
    	} else if (doc_type == "LC") {
    		//CodeSearchCommon(lc_url,'BDWin','','','1000','600');
    		winpopup = window.open(lc_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	}  else if (doc_type == "VM") {
    		//CodeSearchCommon(vn_url,'BDWin','','','1000','600');
    		//window.open(vn_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=650,left=0,top=0");
    		winpopup = window.open(vm_url ,"doExplanationMvd","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
    	}  else if (doc_type == "VN") {
    		//CodeSearchCommon(vn_url,'BDWin','','','1000','600');
    		//window.open(vn_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=650,left=0,top=0");
    		winpopup = window.open(vn_url ,"doExplanationMvd","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
    	}  else if (doc_type == "EC") {
    		//CodeSearchCommon(vn_url,'BDWin','','','1000','600');
    		winpopup = window.open(ec_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
    	} 	else if (doc_type == "ECF") {
    		//CodeSearchCommon(vn_url,'BDWin','','','1000','600');
    		winpopup = window.open(ecf_url ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if (doc_type == "INV") {
    		winpopup = window.open(inv_url ,"doExplanationM6","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1024,height=768,left=0,top=0");
    	} else if(doc_type == "BID"){
    		winpopup = window.open(bid_url ,"doExplanationM1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
    	}else if(doc_type == "SR"){
    		winpopup = window.open(sr_url ,"doExplanationM1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
    	}else if(doc_type == "ES"){
    		winpopup = window.open(es_url ,"doExplanationM1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
    	}else if(doc_type == "TEX"){
    		winpopup = window.open(tex_url ,"doExplanationM1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
    	}else {
    		childFrame.location.href = "/kr/admin/basic/approval/ap1_wk_dis1.jsp?doc_type="+doc_type+"&doc_no="+doc_no+"&doc_seq="+doc_seq+"&company_code="+company_code+"&divCnt=1&where=appconfirm";
		}

	}

	if(msg1 == "t_imagetext" && msg3 == INDEX_SIGN_REMARK && GD_GetCellValueIndex(GridObj,msg2,msg3) != "") {
		var F=document.forms[0];
		F.subject.value = "상신의견";
		F.content.value = GD_GetCellValueIndex(GridObj,msg2,INDEX_SIGN_REMARK);
		F.method = "POST";
		CodeSearchCommon('about:blank','pop_up','','','620','300');
    	F.target = "pop_up";
    	F.action = "/kr/admin/basic/approval/app_pop.jsp";
    	F.submit();
	}

	if(msg1 == "t_imagetext" && msg3 == INDEX_SIGN_PATH){
		company_code = GD_GetCellValueIndex(GridObj,msg2,INDEX_COMPANY_CODE);
		doc_type = GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_TYPE );
		doc_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_NO );
		doc_seq = GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_SEQ );
		var url = "/kr/admin/basic/approval2/ap2_pp_lis7.jsp?company_code="+company_code+"&doc_type="+doc_type+"&doc_no="+doc_no+"&doc_seq="+doc_seq;
		CodeSearchCommon(url,'BKWin','550','800','450','400');
	}

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
	}

	//이원화 발주일때 doc_seq_h자리에 동일한 값이 들어 있다.
	//이것은 이들을 같이 선택되도록 만드는 스크립트이다.
	if (msg1 != "t_header" && msg3 == INDEX_SELECTED)
	{
		//0 , 1 이 아닐때
		if (GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_SEQ) != "0" && GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_SEQ) != "1" )
		{
			if (msg5 == "true") SetCheckOnSameDocNoseq();
			else SetUnCheckOnSameDocNoseq(msg2);
		}
	}
}

function SetUnCheckOnSameDocNoseq(msg2)
{
	var max_row = GridObj.GetRowCount();
	var wise = GridObj;
	var NEW = "";
	var OLD = "";

	NEW = GD_GetCellValueIndex(GridObj,msg2,INDEX_DOC_SEQ);
	GD_SetCellValueIndex(GridObj,msg2,INDEX_SELECTED,"false", "&");

	for(var i=0;i<max_row;i++)
	{

		NEW_CHECK = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);

		if(NEW_CHECK == "true") //체크된것 중에서
		{
			OLD = GD_GetCellValueIndex(GridObj,i,INDEX_DOC_SEQ);
			if(NEW == OLD)
			GD_SetCellValueIndex(GridObj,i,INDEX_SELECTED,"false", "&");
		}
	}
}

function SetCheckOnSameDocNoseq()
{
	var max_row = GridObj.GetRowCount();
	var wise = GridObj;
	var herecomcount = 0;
	var A = "";
	var NEW = "";
	for(var i=0;i<max_row;i++)
	{
		NEW = GD_GetCellValueIndex(GridObj,i,INDEX_DOC_SEQ);
		NEW_CHECK = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);

		//새로들어온것과 기존것을 비교해서 다른것만 진행시킨다.

		if (A != "" && NEW == A)
			continue;

    	//alert("NEW"+NEW);
		if(NEW_CHECK == "true") //체크된것 중에서
		{
            //alert("1 i"+i);
			A = GD_GetCellValueIndex(GridObj,i,INDEX_DOC_SEQ);

			//새로 나타난 doc_seq_h
			for(var j = 0 ; j <max_row; j++)
			{
				//자기자신은 비교 않한다.
				if (i == j) continue;

            	//alert("2 j"+j);
				//이미 체크가 되있는것도 비교 않한다.
				B_CHECK = GD_GetCellValueIndex(GridObj,j,INDEX_SELECTED);
				if (B_CHECK == "true") continue;

				//이원화 건이 아니면 비교 안한다.
				if (GD_GetCellValueIndex(GridObj,j,INDEX_DOC_SEQ) == '0' || GD_GetCellValueIndex(GridObj,j,INDEX_DOC_SEQ) == '1' )
					continue;

				B = GD_GetCellValueIndex(GridObj,j,INDEX_DOC_SEQ);

        		//alert("B"+B);

				//같으면 체크한다.
				if(A == B)
				{
					GD_SetCellValueIndex(GridObj,j,INDEX_SELECTED,"true", "&");
				    //alert("3");
				}
			}
		}
	}
}

function st_from_date(year,month,day,week) {
   	document.forms[0].from_date.value=year+month+day;
}

function st_to_date(year,month,day,week) {
	document.forms[0].to_date.value=year+month+day;
}
function sign_st_from_date(year,month,day,week) {
   	document.forms[0].sign_from_date.value=year+month+day;
}

function sign_st_to_date(year,month,day,week) {
	document.forms[0].sign_to_date.value=year+month+day;
}

function btnApprovalAll(div,divCnt,doc_no,doc_seq){
	var wise = GridObj;
    var row  = GridObj.GetRowCount();
    var chkCnt = 0;

    if(row>0){
    	for(var i=0;i<row;i++) GD_SetCellValueIndex(GridObj,i,0,"false&","&");
       	for(var i=0;i<row;i++)
        	if(doc_no == GD_GetCellValueIndex(GridObj,i,INDEX_DOC_NO )){
        	    if(doc_seq == "" || (doc_seq != "" && doc_seq == GD_GetCellValueIndex(GridObj,i,INDEX_DOC_SEQ ))) {
         			GD_SetCellValueIndex(GridObj,i,0,"true&","&");
         			chkCnt++;
         		}
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
    		fnFiledown(GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO")).getValue());
    	}
    }
	
	
    if(header_name=="SIGN_REMARK_IMG"){
    	if(GridObj.cells(rowId, GridObj.getColIndexById("SIGN_REMARK")).getValue()!=""){
    		var F=document.forms[0];
    		F.subject_1.value = "요청의견"
    		F.sctm_sign_remark.value=GridObj.cells(rowId, GridObj.getColIndexById("SIGN_REMARK")).getValue();
    		//F.content.value = GD_GetCellValueIndex(GridObj,msg2,INDEX_SCTM_SIGN_REMARK);
    		//alert(GridObj.cells(rowId, GridObj.getColIndexById("SCTM_SIGN_REMARK")).getValue());
    		F.method = "POST";
    		CodeSearchCommon('about:blank','pop_up3','','','620','300');
        	F.target = "pop_up3";
        	F.action = "/approval/ap_pop.jsp";
        	F.submit();
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
    
    
    var gg = getGridSelectedRows(GridObj, "SELECTED");
	if(gg !=0){
		GridObj.cells(gg, GridObj.getColIndexById("SELECTED")).setValue(0);
		GridObj.cells(gg, GridObj.getColIndexById("SELECTED")).cell.wasChanged = false;
	}
	GridObj.cells(rowId, GridObj.getColIndexById("SELECTED")).setValue(1);
	GridObj.cells(rowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	
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
		
		else if(doc_type == 'CT'){
			var default_url = "approval_ct.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq+"&add_user_name="+add_user_name+"&add_date="+add_date+"&subject="+subject;
			winpopup = window.open(default_url, "_blank", "width=1050, height=950, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );			
		}

		else if(doc_type == 'POD'){
			var default_url = "approval_po.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq+"&add_user_name="+add_user_name+"&add_date="+add_date+"&subject="+subject;
			winpopup = window.open(default_url, "_blank", "width=1050, height=850, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );			
		}
		
		else if(doc_type == 'PAY'){
			var default_url = "approval_pay.jsp?doc_no="+doc_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+"&sign_path_seq="+sign_path_seq+"&add_user_name="+add_user_name+"&add_date="+add_date+"&subject="+subject;
			winpopup = window.open(default_url, "_blank", "width=950, height=750, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );			
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
	
// 		window.open("approval_detail.jsp?doc_no="+doc_no+"&doc_type="+doc_type+"&sign_enable=T"+"&attach_no="+attach_no+
// 				"&doc_status="+doc_status+"&proceeding_flag="+proceeding_flag+"&doc_seq="+doc_seq+
// 				"&sign_path_seq="+sign_path_seq+"&add_user_name="+add_user_name+"&add_date="+add_date+
// 				"&subject="+subject, "_blank", "width=800, height=800, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );
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

<form name="form1" method="post" action="">
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
	<input type="hidden" name="att_mode" id="att_mode"  value="">
	<input type="hidden" name="view_type" id="view_type" value="">
	<input type="hidden" name="file_type" id="file_type" value="">
	<input type="hidden" name="tmp_att_no" id="tmp_att_no" value="">
	<input type="hidden" name="sctm_sign_remark" id="sctm_sign_remark" value="">
	<input type="hidden" name="subject_1" id="subject_1" value="">
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
  			<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;문서명</td>
      		<td class="data_td" width="35%" >
        		<input type="text" style="width:200" value="" name="subject" id="subject" class="inputsubmit" onkeydown='entKeyDown()'>
        	</td>
        	<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;문서번호</td>
	      	<td class="data_td" width="35%">
	        	<input type="text" style="width:35%;ime-mode:inactive" value="" name="DOC_NO" id="DOC_NO" class="inputsubmit" onkeydown='entKeyDown()'>
	        </td>
  </tr>
  <tr style="display:none;">
        	<td class="title_td" width="15%" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;문서별 결재상태</td>
      		<td class="data_td" width="85%"  colspan="3" >
      			<select name="app_status" id="app_status" class="inputsubmit" disabled="disabled">
      			<%-- <% if(sign_mode.equals("")){%>
                    <option value=''>전체</option>
                <% }else if(sign_mode.equals("N")){ %>   
                    <option value="N" selected>결재할문서</option>
                <% }else if(sign_mode.equals("P")){ %> --%>
                    <option value="P" selected>진행중문서</option>
                <%-- <% }else if(sign_mode.equals("E")){ %>
                    <option value="E" selected>완료문서함</option>
                <% }  %>
                <%  --%>
//                    String lb_cm_2 = ListBox(request, "SL0007", house_code + "#M109#", "N");
//                     out.println(lb_cm_2);
                 %>
                </select>

      		</td>
  </tr>
 	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
   <tr>
   			<!-- 2011.3.25 정민석 문서형태 입찰공고, 통합구매품의, 서비스요청, 업체승인, 업체거래중지 항목 주석처리후
   				 구매요청품의, 검수요청품의 추가 -->
  			<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;문서형태</td>
      		<td class="data_td" width="35%">
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
		    <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기안자</td>
      		<td class="data_td" width="35%">
        		<input type="text" style="width:35%" value="" name="add_user_name" id="add_user_name" class="inputsubmit" onkeydown='entKeyDown()'>
        	</td>
  </tr>
  <tr style="display:none;">
        	<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;결재여부</td>
      		<td class="data_td" width="35%" colspan="3">
        	    <select name="person_app_status" id="person_app_status" class="inputsubmit">
        	    <OPTION VALUE="">전체</OPTION>
				<OPTION VALUE="Y">완료</OPTION>
				<OPTION VALUE="N">미결</OPTION>
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

<table width="100%" border="0" cellspacing="0" cellpadding="0" >
  <tr>
    		<td height="30" align="right">
			<TABLE cellpadding="0">
	      		<TR>
    	  			<td><script language="javascript">btn("javascript:Query()","조 회")</script></td>
    	  			<!--
					<TD><script language="javascript">btn("javascript:EndApp()",13,"승 인")</script></TD>
	      			<TD><script language="javascript">btn("javascript:RefundApp()",1,"반 려")</script></TD>
	      			-->
    	  		</TR>
     			</TABLE>
     		</td>
   	</tr>
 	</table>
 	
	<%-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td height="1" class="cell"></td>
	</tr>
   	<tr id="GRID_SHOW" style="display:inline">
	    <td align="center">
	  		<%=WiseTable_Scripts("100%","310")%>
		</td>
   	</tr>
   	<tr id="HTML_SHOW" style="display:none">
   		<td>
   			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td height="1" colspan="4" class="cell"></td>
			  </tr>
			</table>
   			<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#ccd5de">
   				<tr align="center" height="20" cellspacing="1">
   					<td bgcolor="#F3F8FC"><font style="font-weight: bold;color:#1F528B;">문서번호</font></td>
					<td bgcolor="#F3F8FC"><font style="font-weight: bold;color:#1F528B;">결재상태</font></td>
					<td bgcolor="#F3F8FC"><font style="font-weight: bold;color:#1F528B;">문서형태</font></td>
					<td bgcolor="#F3F8FC"><font style="font-weight: bold;color:#1F528B;">문서명</font></td>
					<td bgcolor="#F3F8FC"><font style="font-weight: bold;color:#1F528B;">품목건수</font></td>
					<td bgcolor="#F3F8FC"><font style="font-weight: bold;color:#1F528B;">요청자명</font></td>
					<td bgcolor="#F3F8FC"><font style="font-weight: bold;color:#1F528B;">요청의견</font></td>
					<td bgcolor="#F3F8FC"><font style="font-weight: bold;color:#1F528B;">요청일자</font></td>
					<td bgcolor="#F3F8FC"><font style="font-weight: bold;color:#1F528B;">최종결재일</font></td>
					<!--
					<td bgcolor="#F3F8FC"><font style="font-weight: bold;color:#1F528B;">통화</font></td>
					<td bgcolor="#F3F8FC"><font style="font-weight: bold;color:#1F528B;">총금액</font></td>
					-->
					<td bgcolor="#F3F8FC"><font style="font-weight: bold;color:#1F528B;">결재자목록</font></td>
					<td bgcolor="#F3F8FC"><font style="font-weight: bold;color:#1F528B;">결재단계</font></td>
					<td bgcolor="#F3F8FC"><font style="font-weight: bold;color:#1F528B;">첨부파일</font></td>
   				</tr>
   				<tr>
   					<td align="center" colspan="14" bgcolor="#FFFFFF" height="25"><font color="red">결재내역이 없습니다.</font></td>
   				</tr>
   			</table>
   		</td>
   	</tr>
 	</table> --%>
 	<table width="98%" border="0" cellspacing="0" cellpadding="0">
    <tr>
     		<td>
     			<!--  SCTP_SIGN_REMARK 여러줄일 경우에 대비.. -->
			<input type="hidden" name="content" id="content" value="" >
      			<input type="hidden" name="shipper_type" id="shipper_type" >
      			<input type="hidden" name="ctrl_person_id" id="ctrl_person_id" value="" >
      			<input type="hidden" name="text_ctrl_person_id" id="text_ctrl_person_id" value="" >
			<input type="hidden" size="12" value="" name="text_doc_type" id="text_doc_type" class="inputsubmit">
     		</td>
   	</tr>
 	</table>

	<input type ="hidden" name="ctrl_type" id="ctrl_type" value="">
	<input type ="hidden" name="used_flag_doc" id="used_flag_doc" value="off">
	<input type ="hidden" name="used_flag_ctrl" id="used_flag_ctrl" value="off">
</form>


<iframe name="childFrame" WIDTH="0" Height="0" border="0" scrolling="no" frameborder="0"></iframe>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="AP_003" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


