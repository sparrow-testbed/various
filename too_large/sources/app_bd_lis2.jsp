<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AR_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AR_002";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON = "";
	String G_IMG = "";

%>
<%--
	기안현황
--%>
<%
	String HOUSE_CODE 		= info.getSession("HOUSE_CODE");
	String COMPANY_CODE 	= info.getSession("COMPANY_CODE");
	String PURCHASE_LOCATION= info.getSession("PURCHASE_LOCATION");
	String CTRL_CODE 		= info.getSession("CTRL_CODE");
	String user_name   	    = info.getSession("NAME_LOC");
	String user_id          = info.getSession("ID");
	String LB_SIGN_STATUS   = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M100", "");
	String REQ_TYPE			= JSPUtil.nullToRef(request.getParameter("REQ_TYPE"),"B");
	String purchaser_id = "";
	String purchaser_name = "";
	
  	String parseCtrlCode = "";
  	if(info.getSession("CTRL_CODE") != null){

  		StringTokenizer st = new StringTokenizer(info.getSession("CTRL_CODE"),"&");
  		String addComma = "','";
  		int tokenCount = st.countTokens();
  		for(int i = 0 ; i < tokenCount ; i++){
  			if(i == tokenCount-1)
  				addComma = "";
  			parseCtrlCode += st.nextToken()+addComma;
  		}
  	}
	
%>
 <% String WISEHUB_PROCESS_ID="AR_002";%> 
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<Script language="javascript" type="text/javascript">
<!--
var mode;
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_bd_lis2";
var INDEX_SELECTED            ;
var INDEX_SIGN_STATUS         ;
var INDEX_SIGN_STATUS_TEXT    ;
var INDEX_EXEC_NO             ;
var INDEX_SUBJECT             ;
var INDEX_EXEC_FLAG           ;
var INDEX_EXEC_FLAG_TEXT      ;
var INDEX_CHANGE_DATE         ;
var INDEX_SIGN_DATE           ;
var INDEX_SETTLE_VENDOR_COUNT ;
var INDEX_CUR                 ;
var INDEX_EXEC_AMT_KRW        ;
var INDEX_ITEM_COUNT          ;
var INDEX_TTL_ITEM_QTY        ;
var INDEX_SIGN_PERSON_ID      ;
var INDEX_CTRL_CODE           ;
var INDEX_CTRL_NAME           ;
var INDEX_BID_TYPE            ;
var INDEX_BID_TYPE_TEXT       ;
var INDEX_ATTACH_NO       	  ;
var INDEX_REMARK       		  ;
var INDEX_PO_TYPE             ;
var INDEX_PO_TYPE_TEXT        ;
var INDEX_EXCHANGE_EXEC_FLAG  ;
var INDEX_BF_EXEC_NO          ;
var INDEX_PURCHASER_NAME	;

function setHeader()
{
    // 2011.09.07 HMCHOI
    // 기안구분코드는 기존과 동일하게 사용하고, 기안구분명은 [일반기안/변경기안]로 구분한다.

// 	GridObj.SetColCellSortEnable(	"SELECTED"		,false);
// 	GridObj.SetDateFormat(		"CHANGE_DATE"	,"yyyy/MM/dd");
// 	GridObj.SetDateFormat(		"SIGN_DATE"		,"yyyy/MM/dd");
// 	GridObj.SetColCellSortEnable(	"CUR"			,false);
// 	GridObj.SetNumberFormat(		"EXEC_AMT_KRW"	,G_format_amt);
// 	GridObj.SetColCellSortEnable(	"TTL_ITEM_QTY"	,false);
// 	GridObj.SetColCellSortEnable(	"CTRL_CODE"		,false);

	

    INDEX_SELECTED             = GridObj.GetColHDIndex("SELECTED");
	INDEX_SIGN_STATUS          = GridObj.GetColHDIndex("SIGN_STATUS");
	INDEX_SIGN_STATUS_TEXT     = GridObj.GetColHDIndex("SIGN_STATUS_TEXT");
	INDEX_EXEC_NO              = GridObj.GetColHDIndex("EXEC_NO");
	INDEX_SUBJECT              = GridObj.GetColHDIndex("SUBJECT");
	INDEX_EXEC_FLAG            = GridObj.GetColHDIndex("EXEC_FLAG");
	INDEX_EXEC_FLAG_TEXT       = GridObj.GetColHDIndex("EXEC_FLAG_TEXT");
	INDEX_CHANGE_DATE          = GridObj.GetColHDIndex("CHANGE_DATE");
	INDEX_SIGN_DATE            = GridObj.GetColHDIndex("SIGN_DATE");
	INDEX_SETTLE_VENDOR_COUNT  = GridObj.GetColHDIndex("SETTLE_VENDOR_COUNT");
	INDEX_CUR                  = GridObj.GetColHDIndex("CUR");
	INDEX_EXEC_AMT_KRW         = GridObj.GetColHDIndex("EXEC_AMT_KRW");
	INDEX_ITEM_COUNT           = GridObj.GetColHDIndex("ITEM_COUNT");
	INDEX_TTL_ITEM_QTY         = GridObj.GetColHDIndex("TTL_ITEM_QTY");
	INDEX_SIGN_PERSON_ID       = GridObj.GetColHDIndex("SIGN_PERSON_ID");
	INDEX_CTRL_CODE            = GridObj.GetColHDIndex("CTRL_CODE");
	INDEX_CTRL_NAME            = GridObj.GetColHDIndex("CTRL_NAME");
	INDEX_BID_TYPE             = GridObj.GetColHDIndex("BID_TYPE");
	INDEX_BID_TYPE_TEXT        = GridObj.GetColHDIndex("BID_TYPE_TEXT");
    INDEX_ATTACH_NO            = GridObj.GetColHDIndex("ATTACH_NO");
    INDEX_REMARK               = GridObj.GetColHDIndex("REMARK");
    INDEX_PO_TYPE              = GridObj.GetColHDIndex("PO_TYPE");
    INDEX_PO_TYPE_TEXT         = GridObj.GetColHDIndex("PO_TYPE_TEXT");
    INDEX_EXCHANGE_EXEC_FLAG   = GridObj.GetColHDIndex("EXCHANGE_EXEC_FLAG");
    INDEX_BF_EXEC_NO           = GridObj.GetColHDIndex("BF_EXEC_NO");
    INDEX_PURCHASER_ID		   = GridObj.GetColHDIndex("PURCHASER_ID");
	INDEX_PURCHASER_NAME	   = GridObj.GetColHDIndex("PURCHASER_NAME");
	
    doSelect();
}

function doSelect()
{
    var f = document.forms[0];
    var wise = GridObj;
    
    f.from_date.value = del_Slash(f.from_date.value);
    f.to_date.value = del_Slash(f.to_date.value);

    var from_date = LRTrim(f.from_date.value);
    var to_date   = LRTrim(f.to_date.value);
    var ctrl_code = LRTrim(f.ctrl_code.value.toUpperCase());
    var sign_status = f.sign_status.options[f.sign_status.selectedIndex].value;
    var exec_no = LRTrim(f.exec_no.value.toUpperCase());
    var subject   = LRTrim(f.subject.value);
    var req_type	= LRTrim(f.req_type.value);
    if(from_date == "" || to_date == "")
    {
        alert("생성일자는 필수조회조건입니다.");
        return;
    }

    //checkDateCommon(str):날짜형식체크
    if(!checkDateCommon(from_date)||!checkDateCommon(to_date)){
        alert("생성일자가 형식이 맞지 않습니다.\n\n올바른 예:20020930");
        return;
    }

    if(from_date > to_date){
        alert("생성일자의 기간이 잘못 설정되었습니다.");
        return;
    }

    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getEXList";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);
}

/**
 * 기안서 수정
 */
function goChange()
{
	if (!checkUser()) return;
	
	var wise = GridObj;
	var f = document.forms[0];
	var iRowCount = GridObj.GetRowCount();
	var iCheckedCount = 0;
	var iSelectedRow  = -1;
	var pr_type = "";
	for(var i=0;i<iRowCount;i++)
	{
		
		
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == true)
		{
			iCheckedCount++;
			iSelectedRow = i;
			pr_type = GridObj.GetCellValue("PR_TYPE",i);
		}
	}

	if(iCheckedCount < 1)
	{
		alert(G_MSS1_SELECT);
		return;
	}

    if(iCheckedCount > 1)
	{
		alert("하나의 항목만 선택해주세요");
		return;
	}

	var sign_status 		= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_SIGN_STATUS);
	var exec_no 			= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_EXEC_NO);
	var subject 			= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_SUBJECT);
	var ctrl_code 			= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_CTRL_CODE);
	var exec_amt_krw 		= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_EXEC_AMT_KRW);
	var remark 				= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_REMARK);
	var attach_no			= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_ATTACH_NO);
	var exec_flag       	= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_EXEC_FLAG);
	var po_type        		= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_PO_TYPE);
	var del_flag  			= GridObj.GetCellValue("DEL_FLAG",iSelectedRow);
	var pre_cont_seq  		= GridObj.GetCellValue("PRE_CONT_SEQ",iSelectedRow);
	var pre_cont_count  	= GridObj.GetCellValue("PRE_CONT_COUNT",iSelectedRow);
	
	if( sign_status == "P") {
    	alert("이미 결재진행 중 입니다.");
        return;
    }
	// 작성중(T), 결재반려(R)인 경우에만 수정이 가능하다.
	if(sign_status != "T" && sign_status != "R" && sign_status != "D") {
       	alert("수정할 수 없는 기안번호입니다.");
        return;
    }
	// 발주종결여부 : 발주서가 생성되었으면, Y/N 값을 갖는다.
	if(del_flag != '') {
		alert("발주가 이미 생성된 기안번호 입니다.");
        return;
	}
	
	f.exec_no.value = exec_no;
	f.pr_type.value	= pr_type;

	window.open("","execUpdate","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
	f.method              = "POST";
	f.target			  = "execUpdate";
	f.action              = "/kr/dt/app/app_bd_ins1.jsp?pre_cont_seq="+pre_cont_seq+"&pre_cont_count="+pre_cont_count;
    f.submit();
}

/**
 * 변경기안서 작성
 */
function goCreate()
{
	if (!checkUser()) return;
	
	var wise = GridObj;
	var f = document.forms[0];
	var iRowCount = GridObj.GetRowCount();
	var iCheckedCount = 0;
	var iSelectedRow  = -1;
	var pr_type = "";
	for(var i=0;i<iRowCount;i++)
	{
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == "true")
		{
			iCheckedCount++;
			iSelectedRow = i;
			pr_type = GridObj.GetCellValue("PR_TYPE",i);
		}
	}

	if(iCheckedCount < 1)
	{
		alert(G_MSS1_SELECT);
		return;
	}

    if(iCheckedCount > 1)
	{
		alert("하나의 항목만 선택해주세요");
		return;
	}

	var sign_status 		= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_SIGN_STATUS);
	var exec_no 			= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_EXEC_NO);
	var subject 			= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_SUBJECT);
	var ctrl_code 			= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_CTRL_CODE);
	var exec_amt_krw 		= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_EXEC_AMT_KRW);
	var remark 				= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_REMARK);
	var attach_no			= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_ATTACH_NO);
	var exec_flag       	= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_EXEC_FLAG);
	var po_type         	= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_PO_TYPE);
	var del_flag  			= GridObj.GetCellValue("DEL_FLAG",iSelectedRow);
	// 변경기안서 결재상태
	var exchange_exec_flag 	= GD_GetCellValueIndex(GridObj,iSelectedRow, INDEX_EXCHANGE_EXEC_FLAG);
	
	if( sign_status != "E") {
    	alert("결재완료가 되지 않은 기안건은 변경기안를 진행할 수 없습니다.");
        return;
    }
	// 발주종결여부: 발주종결이 완료된 건에 대해 변경기안서를 작성한다.
    if(del_flag != 'Y') {
   		alert("발주종결이 되지 않는 기안건은 변경기안를 진행할 수 없습니다.");
        return;
    }
	// 변경기안서 상태가 작성중, 결재중, 결재반려, 결재완료인 경우 또 다른 변경기안서를 작성할 수 없다.
    if(exchange_exec_flag == 'T') {
   		alert("선택한 기안번호에 대해 [작성중]인 변경 기안건이 존재합니다.");
        return;
    } else if (exchange_exec_flag == 'P') {
   		alert("선택한 기안번호에 대해 [결재중]인 변경 기안건이 존재합니다.");
        return;
    } else if (exchange_exec_flag == 'R') {
   		alert("선택한 기안번호에 대해 [결재반려]된 변경 기안건이 존재합니다.");
        return;
    } else if (exchange_exec_flag == 'E') {
   		alert("선택한 기안번호에 대해 [결재완료]된 변경 기안건이 존재합니다.");
        return;
    }
	f.exec_no.value = exec_no;
	f.pr_type.value	= pr_type;
	f.screenMode.value = "E";

	window.open("","execUpdate","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
	f.method              = "POST";
	f.target			  = "execUpdate";
	f.action              = "/kr/dt/app/app_bd_ins1.jsp";
    f.submit();
}

//직무권한 체크
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

function from_date(year,month,day,week)
{
    document.form1.from_date.value=year+month+day;
}

function to_date(year,month,day,week)
{
    document.form1.to_date.value=year+month+day;
}


function JavaCall(msg1,msg2,msg3,msg4,msg5)
{
    //구매담당자 이름 뿌려주기...
    if(msg1 == "doQuery") {
    	//GridObj.bCellFontBold = true; 
        if(mode =="goQuery") {
//             document.forms[0].user_name.value = GD_GetParam(GridObj,1);
        }
    }
    if(msg1 == "t_imagetext")
    {//이렇게 감싸줘야 header click 시에 error 안 난다.
        if(msg3 == INDEX_EXEC_NO){//기안번호
            var exec_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_EXEC_NO);
            var pr_type = GridObj.GetCellValue("PR_TYPE",msg2);
            var sign_status = "E";
            var edit = "N";
            window.open("app_bd_ins1.jsp?exec_no="+exec_no+ "&pr_type=" + pr_type + "&editable=N&req_type=<%=REQ_TYPE%>","execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
	   }
	   if(msg3 == INDEX_BF_EXEC_NO){//변경기안번호
	       var exec_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_BF_EXEC_NO);
	       var pr_type = GridObj.GetCellValue("PR_TYPE",msg2);
	       var sign_status = "E";
	       var edit = "N";
	       window.open("app_bd_ins1.jsp?exec_no="+exec_no+ "&pr_type=" + pr_type + "&editable=N&req_type=<%=REQ_TYPE%>","execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
		}
	}
    if( msg1 == "doData")
    {
		alert(GridObj.GetMessage());
		var status = GD_GetParam(GridObj,1);
		if(status != "0")
		{
			doSelect();
		}
	}
}

function goMail(){
    var exec_no  = "";
    var rfq_type = "";
    var chkcnt   = "";

    var row = GridObj.GetRowCount();
    for(var i = 0;i < row;i++){
        var check = GD_GetCellValueIndex(GridObj,i,INDEX_CHECK);
        if(check == "false") continue;
        sign_status = GD_GetCellValueIndex(GridObj,i,INDEX_SIGN_STATUS);

        if( sign_status != "E" ) {
            alert( "진행상황이 기안완료인 경우 메일전송이 가능합니다." );
            return;
        }

        if( chkcnt == 0 ) {
            exec_no     += GD_GetCellValueIndex(GridObj,i,INDEX_EXEC_NO);
            rfq_type    += GD_GetCellValueIndex(GridObj,i,INDEX_RFQ_TYPE);
        } else  {
            exec_no     += ","+GD_GetCellValueIndex(GridObj,i,INDEX_EXEC_NO);
            rfq_type    += ","+GD_GetCellValueIndex(GridObj,i,INDEX_RFQ_TYPE);
        }
        chkcnt++;
    }

    if (chkcnt == 0 ) {
        alert("선택된 로우가 없습니다.");
        return;
    }

    if (chkcnt != 1 ) {
        alert("한 개의 로우만 선택하십시요.");
        return;
    }
    window.open("mail_pp_ins1.jsp?doc_no="+exec_no+"&rfq_type="+rfq_type,"mailwin","left=0,top=0,width=600,height=200,status=yes,resizable=yes,scrollbars=no");
 }

//구매담당
function SP0216_Popup()
{
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0216&function=SP0216_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function SP0216_getCode(ls_ctrl_code, ls_ctrl_name)
{
	document.form1.ctrl_code.value = ls_ctrl_code;
	document.form1.user_name.value = ls_ctrl_name;
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
function doDelete(){
	var wise 		= GridObj;
	var rowCount 	= wise.GetRowCount();
	var selectedRow = -1;
	var is_po_no = "";
	var is_ct_no = "";
	var sign_status = "";

	for( i = 0 ; i < rowCount ; i++)
	{
		if("1"==wise.GetCellValue("SELECTED",i))
		{
			if(selectedRow == i)
			{
				alert("한개의 기안번호만 선택해 주세요.");
				return;
			}else{
				selectedRow = i;
				sign_status = wise.GetCellValue("SIGN_STATUS",i);
				is_ct_no = wise.GetCellValue("IS_CT_NO",i);
				is_po_no = wise.GetCellValue("IS_PO_NO",i);
			}
		}
	}
	if(sign_status != "R" && sign_status != "T"){
		if(is_ct_no == 'Y' || is_po_no == 'Y'){  //계약, 발주 생성이 안된건만 취소가능
			alert("반려중이거나 작성중인 건만 삭제 가능합니다.");
			return;
		}	
	}
	if(selectedRow == -1){
		alert("기안번호를 선택해주세요.")
		return;
	}

	if(!confirm("삭제하시겠습니까?")){
		return;
	}
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	params = "?mode=setDeleteEx";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
	//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);	

// 	GridObj.SetParam("mode","setDeleteEx");
// 	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
// 	GridObj.SendData(G_SERVLETURL,"ALL","ALL");
// 	GridObj.strHDClickAction="sortmulti";

}
function PopupManager(part)
{
	var url = "";
	var f = document.forms[0];

	if(part == "DEMAND_DEPT")
	{
		window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "PURCHASER_ID")
	{
		window.open("/common/CO_008.jsp?callback=getPurUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "VENDOR_CODE"){
		PopupCommon2("SP0087","getVendor","<%=info.getSession("HOUSE_CODE")%>", "","업체코드","업체명");
	}
	else if(part == "CUST_CODE"){
		PopupCommon2("SP0120F","getCust","","","고객사코드","고객사명");
	}
	else if(part == "CTRL_PERSON_ID"){
		PopupCommon2("SP0023","getCtrlPerson","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","ID","담당자명");
	}
	else if(part == "PROJECT_CODE"){
		PopupCommon2("SP0280","getProject","", "","코드","프로젝트명");
	}
	//구매담당자
	if(part == "CTRL_CODE")
	{
		PopupCommon2("SP0216","getCtrlManager","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","직무코드","직무명");
	}
}

//구매담당자
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

function getPurchaser(ctrl_name, ctrl_code, code, text){
	document.forms[0].purchaser_name.value = text;
	document.forms[0].purchaser_id.value = code;
}

function getVendor(code, text){
	document.forms[0].vendor_code.value = code;
	document.forms[0].vendor_name.value = text;
}

function getCust(code, text, div) {
  	 document.forms[0].cust_type.value = div;
	 document.forms[0].cust_code.value = code;
	 document.forms[0].cust_name.value = text;
}

function getPurUser(code, text)
{
	document.forms[0].purchaser_name.value = text;
	document.forms[0].purchaser_id.value = code;
}
// 직무코드 선택
function getCtrlPerson(USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION){

	/* document.forms[0].ctrl_name.value = ctrl_name;
	document.forms[0].ctrl_code.value = ctrl_code; */
	document.forms[0].ctrl_person_id.value = USER_ID;
	document.forms[0].ctrl_person_name.value = USER_NAME_LOC;
}

function getProject(pjt_code, pjt_name){
	document.forms[0].project_code.value = pjt_code;
	document.forms[0].project_name.value = pjt_name;
}

//-->
</Script>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
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

	JavaCall("t_imagetext", GridObj.getRowIndex(rowId), cellInd);
	
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
        doSelect();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	//JavaCall("doData");
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
    
    document.forms[0].from_date.value = add_Slash( document.forms[0].from_date.value );
    document.forms[0].to_date.value   = add_Slash( document.forms[0].to_date.value   );
    
    return true;
}

//지우기
function doRemove( type ){
    if( type == "ctrl_person_id" ) {
    	document.forms[0].ctrl_person_id.value = "";
        document.forms[0].ctrl_person_name.value = "";
    }  
    if( type == "ctrl_code" ) {
    	document.forms[0].ctrl_code.value = "";
        document.forms[0].ctrl_name.value = "";
    }
    if( type == "purchaser_id" ) {
    	document.forms[0].purchaser_id.value = "";
        document.forms[0].purchaser_name.value = "";
    }  
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_name.value = "";
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
<body onload="setGridDraw();setHeader();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->
<!-- <table width="100%" border="0" cellspacing="0" cellpadding="0"> -->
<!-- <tr> -->
<%-- 	<td align="left" class="cell_title1"> <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle"> --%>
<%-- 		<%@ include file="/include/sepoa_milestone.jsp" %> --%>
<!-- 	</td> -->
<!-- </tr> -->
<!-- </table> -->
<%@ include file="/include/include_top.jsp"%>
<%@ include file="/include/sepoa_milestone.jsp"%>
<form id="form1" name="form1" action="">
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
	<input type="hidden" id="st_shipper_type" 	name="st_shipper_type" 	value="">
<%-- 	<input type="hidden" id="req_type" 			name="req_type" 		value="<%=REQ_TYPE%>"> --%>
	<input type="hidden" id="req_type" 			name="req_type" 		value="P">
	<input type="hidden" id="pr_type"  			name="pr_type"  		value="">
	<input type="hidden" id="screenMode" 		name="screenMode" 		value="">

<tr>
	<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기안일자</td>
    <td height="24" class="data_td">
		<s:calendar id="from_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1))%>" 	format="%Y/%m/%d"/>~
  		<s:calendar id="to_date"   default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString())%>" 									format="%Y/%m/%d"/>
    </td>
	<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기안담당자</td>
	<td height="24" class="data_td">
		<b><input type="text" id="ctrl_person_id" name="ctrl_person_id" style="ime-mode:inactive" size="10" class="inputsubmit" value="<%=user_id%>" onkeydown='entKeyDown()' >
		<a href="javascript:PopupManager('CTRL_PERSON_ID')"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
		<a href="javascript:doRemove('ctrl_person_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
		<input type="text" id="ctrl_person_name" name="ctrl_person_name" size="10" readOnly  value="<%=user_name%>" onkeydown='entKeyDown()' ></b>
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
<tr>
	<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;진행상태</td>
	<td height="24" class="data_td">
		<select id="sign_status" name="sign_status" class="inputsubmit">
			<option value="">
				전체
			</option>			
<%-- 			<%=LB_SIGN_STATUS%>			 --%>
			<option value="T">작성중</option>
			<option value="P">진행중</option>
			<option value="D">취소</option>
			<option value="E">완료</option>
			<option value="R">반려</option>
		</select>
	</td>
	<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기안번호</td>
	<td height="24" class="data_td">
		<input type="text" id="exec_no" name="exec_no" class="inputsubmit" style="width:38%;ime-mode:inactive" value="" onkeydown='entKeyDown()' >
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
<tr>
	<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청부서</td>
	<td height="24" class="data_td">
		<input type="text" id="demand_dept" name="demand_dept" style="ime-mode:inactive" size="10" maxlength="6" class="inputsubmit" value='' onkeydown='entKeyDown()' >
		<a href="javascript:PopupManager('DEMAND_DEPT');">
			<img src="/images/ico_zoom.gif" align="absmiddle" border="0">
		</a>
		<a href="javascript:doRemove('demand_dept')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
		<input type="text" id="demand_dept_name" name="demand_dept_name" size="15" value="" readOnly onkeydown='entKeyDown()' >
	</td>
	<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기안명</td>
	<td height="24" class="data_td">
		<input type="text" id="subject" name="subject" style="width:95%" class="inputsubmit" onkeydown='entKeyDown()' >
	</td>
</tr>
<tr style="display: none">
	<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매담당자</td>
	<td height="24" class="data_td">
		<input type="text" id="ctrl_code" name="ctrl_code" size="15" value="<%=parseCtrlCode%>" class="inputsubmit" onkeydown='entKeyDown()' >
		<a href="javascript:PopupManager('CTRL_CODE')"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
		<a href="javascript:doRemove('ctrl_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
		<input type="text" id="ctrl_name" name="ctrl_name" size="15" value="" readOnly onkeydown='entKeyDown()' >
<!-- 		<input type="hidden" name="purchaser_id" value=""> -->
<!-- 		<input type="hidden" name="purchaser_name" value=""> -->
	</td>
</tr>	
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
<tr>
	<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매담당자</td>
    <td height="24" class="data_td">
        <input type="text" id="purchaser_id" name="purchaser_id" style="ime-mode:inactive" size="20" value="<%=info.getSession("ID")%>" class="inputsubmit" onkeydown='entKeyDown()' >
        <a href="javascript:PopupManager('PURCHASER_ID')"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
        <a href="javascript:doRemove('purchaser_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
        <input type="text" id="purchaser_name" name="purchaser_name" size="15" value="<%=info.getSession("NAME_LOC")%>" readOnly onkeydown='entKeyDown()' >
    </td>
	<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체코드</td>
	<td height="24" class="data_td">
		<input type="text" id="vendor_code" name="vendor_code" style="ime-mode:inactive" size="10" maxlength="10" class="inputsubmit" onkeydown='entKeyDown()' >
		<a href="javascript:PopupManager('VENDOR_CODE');">
			<img src="/images/ico_zoom.gif" align="absmiddle" border="0">
		</a>
		<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
		<input type="text" id="vendor_name" name="vendor_name" size="30" onkeydown='entKeyDown()' >
	</td>
</tr>
<tr style="display: none">
	<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;고객사</td>
	<td height="24" class="data_td">
		<input type="text" id="cust_code" name="cust_code" size="10"  class="inputsubmit" value='' onkeydown='entKeyDown()' >
        <a href="javascript:PopupManager('CUST_CODE');">
			<img src="/images/ico_zoom.gif" align="absmiddle" border="0">
		</a>
		<input type="text"   id="cust_name" name="cust_name" size="30" value='' style="border:0" readonly onkeydown='entKeyDown()' >
		<input type="hidden" id="cust_type" name="cust_type" size="30" value='' style="border:0" readonly>
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>

<%
	if("P".equals(REQ_TYPE)){
%>
<tr>
	<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매요청번호</td>
	<td height="24" class="data_td" colspan="3">
		<input type="text" id="pr_no" k"pr_no" class="inputsubmit" style="width:38%" value="" onkeydown='entKeyDown()' >
		<input type="hidden" id="maker_name" name="maker_name" style="width:38%" class="inputsubmit">
	</td>
<!-- 	<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제조사</td> -->
<!-- 	<td height="24" class="data_td"> -->
<!-- 		<input type="text" id="maker_name" name="maker_name" style="width:38%" class="inputsubmit" onkeydown='entKeyDown()' > -->
<!-- 	</td> -->
</tr>
<tr style="display:none;">
	<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;프로젝트</td>
	<td height="24" class="data_td">
		<input type="text" id="project_code" name="project_code" size="10"  class="inputsubmit" value='' onkeydown='entKeyDown()' >
        <input type="text" id="project_name" name="project_name" size="30" value='' style="border:0" readonly onkeydown='entKeyDown()' >
	</td>
</tr>
<%
	}else if("B".equals(REQ_TYPE)){
%>
<tr>
	<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사전지원요청번호</td>
	<td height="24" class="data_td" colspan="3" >
		<input type="hidden" id="project_code" name="project_code" size="10"  class="inputsubmit" value=''>
		<input type="text"   id="pr_no" 		 name="pr_no" 		 class="inputsubmit" style="width:35%" value="" onkeydown='entKeyDown()' >
	</td>
</tr>
<%
}
%>
</table>

</td>
</tr>
</table>
</td>
</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<!--
	<td height="30" align="left">
	<TABLE cellpadding="0">
	<TR>
		<TD><script language="javascript">btn("javascript:goCreate()",12,"변경기안생성")   </script></TD>
	</TR>
	</TABLE>
	</td>
	-->
	<td height="30" align="right">
	<TABLE cellpadding="0">
	<TR>
		<TD><script language="javascript">btn("javascript:doSelect()","조 회")    </script></TD>
<%if(!"MUP110300005".equals(info.getSession("MENU_TYPE"))){ %>
		<%-- 
		<TD><script language="javascript">btn("javascript:goChange()","수 정")   </script></TD>
		<TD><script language="javascript">btn("javascript:doDelete()","삭 제")   </script></TD>
		--%>
<%} %>
	</TR>
	</TABLE>
	</td>
</tr>
</table>
</form>


</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="AR_002" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>


