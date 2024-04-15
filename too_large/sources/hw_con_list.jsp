<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%-- <%@ page import="javax.servlet.RequestDispatcher"%> --%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("HW_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "HW_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
%>
<% String WISEHUB_PROCESS_ID="HW_001";%>
<%
/**
 *========================================================
 *Copyright(c) 2015 SepoaSoft
 *
 *@File       : sta_bd_lis45.jsp
 *
 *@FileName   : 간판설치현황
 *
 *Open Issues :
 *
 *Change history  :
 *@LastModifyDate : 2015. 02. 12
 *@LastModifier   : next1210
 *@LastVersion    : V 1.0.0
 *=========================================================
 */
 %>

<%
	String house_code   = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
	String department   = info.getSession("DEPARTMENT");//부서
	String vendor_code  = info.getSession("COMPANY_CODE");//회사코드(공급업체 사용자는 공급업체코드)
	
	String to_day 	 = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-30);
	String to_date 	 = to_day;	
	
	int checkVendor = 1;
	
	Config conf = new Configuration();
	
	if( !"WOORI".equals(vendor_code) ) {//공급업체만 체크
		
		Map<String, String> mapData = new HashMap<String, String>();
		mapData.put("vendor_code", vendor_code);
		
		Object[] obj = {mapData};
		SepoaOut so = ServiceConnector.doService(info, "p7009", "CONNECTION","checkVendor", obj);
		
		SepoaFormater wf = new SepoaFormater( so.result[0] );
		
		if(wf.getRowCount() > 0) {
			checkVendor = Integer.valueOf( wf.getValue("CNT", 0) );
		}
		
		Logger.debug.println(info.getSession("ID"), this, "#################### checkVendor : " + checkVendor);
		
// 		if( checkVendor > 0 ) { //jsp 페이지 이동
// 			RequestDispatcher rd = request.getRequestDispatcher("/common/index_seller.jsp");
//         	rd.forward(request, response);
// 		}
		
	}
	
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<Script language="javascript">
	var G_HOUSE_CODE   = "<%=house_code%>";
	var G_COMPANY_CODE = "<%=company_code%>";
	var GridObj = null;
	var G_PRE_CODE   = "B";
	var G_C_INDEX     = "MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:DELIVERY_IT:MAKER_NAME:MAKER_CODE:ITEM_GROUP:DELY_TO_ADDRESS:KTGRM";
	
	function setGridObj(arg) {
		GridObj = arg;
	}
	
	function init() {
		GridObj_setGridDraw();
		GridObj.setSizes();
		recal();
	}

	function setHeader() {

	}

	function EndGridQuery() {
		var status = GridObj.GetStatus();
		var mode   = GridObj.GetParam("mode");

		if (GridObj.GetStatus() == "false" ){
			alert(GridObj.GetMessage());
			return;
		}
	}

	function doSelect() {
		
		var con_kind     	= document.form1.con_kind.value;
		var own_kind     	= document.form1.own_kind.value;
		var dept     		= document.form1.dept.value;
		var con_name     	= document.form1.con_name.value;
		var pay_term     	= document.form1.pay_term.value;
		var con_from_date 	= del_Slash(document.form1.con_from_date.value);
		var con_to_date		= del_Slash(document.form1.con_to_date.value);
		
// 		if(!checkDateCommon(con_from_date)) {
// 			alert("조회기간의 시작일자를 확인 하세요 ");
// 			document.form1.con_from_date.focus();
// 			return;
// 		}
		
// 		if(!checkDateCommon(con_to_date)) {
// 			alert("조회기간의 종료일자를 확인 하세요 ");
// 			document.form1.con_to_date.focus();
// 			return;
// 		}
		 
		var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/statistics.hw_con_list";

		var cols_ids = "<%=grid_col_id%>";
        var params = "mode=getConList";
        params += "&cols_ids=" + cols_ids;
        params += dataOutput();
        GridObj.post( G_SERVLETURL, params );
        GridObj.clearAll(false); 
	}
	
	function doPrint() {
		var branches_from_code	= del_Slash(document.form1.branches_from_code.value);
		var branches_from_name	= del_Slash(document.form1.branches_from_name.value);
		var branches_to_code 		= del_Slash(document.form1.branches_to_code.value);
		var branches_to_name 		= del_Slash(document.form1.branches_to_name.value);
		var con_from_date		= del_Slash(document.form1.con_from_date.value);
		var con_to_date		= del_Slash(document.form1.con_to_date.value);
		var item_no     	= document.form1.item_no.value;
		var item_name    = document.form1.item_name.value;
		var install_store	= document.form1.install_store.value;
		var install_store_name	= document.form1.install_store_name.value;
		var signform		= document.form1.signform.value;
		var remove_flag		= document.form1.remove_flag.value;

		if(!checkDateCommon(con_from_date)) {
			alert("조회기간의 시작일자를 확인 하세요 ");
			document.form1.con_from_date.focus();
			return;
		}
		if(!checkDateCommon(con_to_date)) {
			alert("조회기간의 종료일자를 확인 하세요 ");
			document.form1.con_to_date.focus();
			return;
		}
		var param = "?mode=print";
		param += "&branches_from_code=" + branches_from_code;
		param += "&branches_from_name=" + branches_from_name;
		param += "&branches_to_code=" + branches_to_code;
		param += "&branches_to_name=" + branches_to_name;
		param += "&con_from_date=" + con_from_date;
		param += "&con_to_date=" + con_to_date;
		param += "&item_no=" + item_no;
		param += "&item_name=" + item_name;
		param += "&install_store=" + install_store;
		param += "&install_store_name=" + install_store_name;
		param += "&signform=" + signform;
		param += "&remove_flag=" + remove_flag;
		
		var url  = "../statistics/sta_bd_lis45_popup_print.jsp";
		url = url + param;
		
		window.open(url,"print_sign","left=0,top=0,width=1024,height=450,resizable=yes,scrollbars=yes, status=yes");
	}

</script>

<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd) {
	var url  = "../statistics/hw_con_popup.jsp";
	var header_name = GridObj.getColumnId(cellInd);
	
	
	if( header_name == "CON_NUMBER")
	{		
		var	con_number      = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CON_NUMBER")).getValue());	
		
		if(con_number != '') {
			var url  = "/kr/statistics/hw_con_popup_view.jsp";
			var con_number 		= GridObj.cells(rowId, GridObj.getColIndexById("CON_NUMBER")).getValue();
				
			url = url + "?con_number="+con_number;
			window.open(url,"hw_con_popup","left=0,top=0,width=1024,height=700,resizable=yes,scrollbars=yes, status=yes");
			
			/* var param = "?mode=update";
			param += "&house_code=" + "000";
			param += "&con_number=" + con_number;
		 	
			url = url + param;
			
			window.open(url,"hw_con_popup","left=0,top=0,width=1024,height=700,resizable=yes,scrollbars=yes, status=yes"); */ 
		}
	}else if( header_name == "VENDOR_CODE1_TEXT" ) {//WGW
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE1");
		
		if(vendor_code != null && vendor_code != "") {
		
			var url    = '/s_kr/admin/info/ven_bd_con.jsp';
			var title  = '업체상세조회';
			var param  = 'popup=Y';
			param     += '&mode=irs_no';
			param     += '&vendor_code=' + vendor_code;
			popUpOpen01(url, title, '900', '700', param);
			
		}
	}else if( header_name == "VENDOR_CODE2_TEXT" ) {//WGW
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE2");
		
		if(vendor_code != null && vendor_code != "") {
		
			var url    = '/s_kr/admin/info/ven_bd_con.jsp';
			var title  = '업체상세조회';
			var param  = 'popup=Y';
			param     += '&mode=irs_no';
			param     += '&vendor_code=' + vendor_code;
			popUpOpen01(url, title, '900', '700', param);
			
		}
	}else if( header_name == "VENDOR_CODE3_TEXT" ) {//WGW
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE3");
		
		if(vendor_code != null && vendor_code != "") {
		
			var url    = '/s_kr/admin/info/ven_bd_con.jsp';
			var title  = '업체상세조회';
			var param  = 'popup=Y';
			param     += '&mode=irs_no';
			param     += '&vendor_code=' + vendor_code;
			popUpOpen01(url, title, '900', '700', param);
			
		}
	}else if( header_name == "VENDOR_CODE4_TEXT" ) {//WGW
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE4");
		
		if(vendor_code != null && vendor_code != "") {
		
			var url    = '/s_kr/admin/info/ven_bd_con.jsp';
			var title  = '업체상세조회';
			var param  = 'popup=Y';
			param     += '&mode=irs_no';
			param     += '&vendor_code=' + vendor_code;
			popUpOpen01(url, title, '900', '700', param);
			
		}
	}else if( header_name == "VENDOR_CODE5_TEXT" ) {//WGW
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE5");
		
		if(vendor_code != null && vendor_code != "") {
		
			var url    = '/s_kr/admin/info/ven_bd_con.jsp';
			var title  = '업체상세조회';
			var param  = 'popup=Y';
			param     += '&mode=irs_no';
			param     += '&vendor_code=' + vendor_code;
			popUpOpen01(url, title, '900', '700', param);
			
		}
	}else if( header_name == "VENDOR_CODE6_TEXT" ) {//WGW
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE6");
		
		if(vendor_code != null && vendor_code != "") {
		
			var url    = '/s_kr/admin/info/ven_bd_con.jsp';
			var title  = '업체상세조회';
			var param  = 'popup=Y';
			param     += '&mode=irs_no';
			param     += '&vendor_code=' + vendor_code;
			popUpOpen01(url, title, '900', '700', param);
			
		}
	}else if( header_name == "VENDOR_CODE7_TEXT" ) {//WGW
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE7");
		
		if(vendor_code != null && vendor_code != "") {
		
			var url    = '/s_kr/admin/info/ven_bd_con.jsp';
			var title  = '업체상세조회';
			var param  = 'popup=Y';
			param     += '&mode=irs_no';
			param     += '&vendor_code=' + vendor_code;
			popUpOpen01(url, title, '900', '700', param);
			
		}
	}
	
	/*
	if(header_name == "IMAGE") {
		if(GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO")).getValue()==""){
    		alert("첨부파일이 없습니다");
    	}else{
			fnFiledown(GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO")).getValue());			
    	}
	} else if(header_name == "REMARK_IMAGE") {
		if(GridObj.cells(rowId, GridObj.getColIndexById("REMARK")).getValue()!=""){
    		var F=document.forms[0];
    		F.subject_1.value = "특이사항"
    		F.sctm_sign_remark.value=GridObj.cells(rowId, GridObj.getColIndexById("REMARK")).getValue();
    		F.method = "POST";
    		CodeSearchCommon('about:blank','pop_up3','','','620','300');
        	F.target = "pop_up3";
        	F.action = "/approval/ap_pop.jsp";
        	F.submit();
    	} else {
    		alert("특이사항이 없습니다.");
    		return;
    	}
	} else if(header_name == "ITEM_CODE") {
		var itemNo     = GridObj.cells(rowId, GridObj.getColIndexById("ITEM_CODE")).getValue();
		
		var url        = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO=" + itemNo + "&BUY=";
		var PoDisWin   = window.open(url, 'agentCodeWin', 'left=0, top=0, width=750, height=550, toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes');
		
		PoDisWin.focus();
	} else {
		var house_code 		= SepoaGridGetCellValueId(GridObj, rowId, "HOUSE_CODE");
		var key_no 			= SepoaGridGetCellValueId(GridObj, rowId, "KEY_NO");
		var branches_code 	= SepoaGridGetCellValueId(GridObj, rowId, "BRANCHES_CODE");
		var item_no 			= SepoaGridGetCellValueId(GridObj, rowId, "ITEM_CODE");
		var io_number 		= SepoaGridGetCellValueId(GridObj, rowId, "IO_NUMBER");
		doquery2(house_code, key_no, branches_code, item_no, io_number);
	}
	*/
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

function doSave(temp) {
	var url  = "../statistics/hw_con_popup.jsp";
	if(temp == "insert") {
		var param = "?mode=insert";
		url = url + param;
	} else if(temp == "update") {
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		if(grid_array.length > 1) {
			alert("1개의 데이터만 수정할 수 있습니다.");
			return;
		}
		if(grid_array.length == 0) {
			alert("선택된 항목이 없습니다.");
			return;
		}
		
		var house_code = "";
		var con_number = "";
		for(var i = 0; i < grid_array.length; i++) {
			con_number 		= GridObj.cells(grid_array[i], GridObj.getColIndexById("CON_NUMBER")).getValue();
		}
		
		if(con_number.length < 1) {
			alert("계약번호가 존재하지 않습니다.");
			return;
		}
		
		var param = "?mode=update";
		param += "&house_code=" + "000";
		param += "&con_number=" + con_number;
		
		
		
		url = url + param;
	}
	window.open(url,"hw_con_popup","left=0,top=0,width=1024,height=700,resizable=yes,scrollbars=yes, status=yes");
}

function doDelete() {
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cnt=0;
	
	if(grid_array.length > 1) {
		alert("1개의 데이터만 삭제할 수 있습니다.");
		return;
	}
	if(grid_array.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	var anw = confirm("삭제하시겠습니까?");
	if(anw == false) return;
	var params ="mode=doDelete&cols_ids="+grid_col_id;
	params+=dataOutput();
 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/statistics.hw_con_list",params);
    sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
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

    return false;
}


function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");
    
    
    //if(status == "false") alert(msg);
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
        
	document.form1.con_from_date.value = add_Slash( document.form1.con_from_date.value );
	document.form1.con_to_date.value   = add_Slash( document.form1.con_to_date.value   );
	
	//GridObj_setGridDraw();
	//GridObj.setSizes();
	//recal();
    return true;
}

//팝업호출 공통
function PopupManager(part)
{
	var url = "";
	var f = document.forms[0];

	if(part == "DEPT"){	//영업점
		window.open("/common/CO_009.jsp?callback=return_dept", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
}

function return_dept(code,text){
    document.forms[0].dept.value	= code;
	document.forms[0].dept_text.value 	= text;
}

function fnFiledown(attach_no){
	var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
	var b = "fileDown";
	var c = "300";
	var d = "100";
	 
	window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
}

//지우기
function doRemove( type ){
    if( type == "DEPT" ) {
    	document.forms[0].dept.value = "";
        document.forms[0].dept_text.value = "";
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
<body onload="init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">
<s:header>
<!--내용시작-->
<%@ include file="/include/sepoa_milestone.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="760" height="2" bgcolor="#0072bc"></td>
	</tr>
</table>
<form name="form1">
<input type="hidden" name="sctm_sign_remark" id="sctm_sign_remark" value="">
<input type="hidden" name="subject_1" id="subject_1" value="">
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
					<tr>
						<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공사구분
						</td>
						<td width="35%" class="data_td">
							<select name="con_kind" id="con_kind" class="inputsubmit">
								<option value="">전체</option>
								<%
	                              String listbox1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#H001", "");
	                              out.println(listbox1);
	                            %>
						    </select>
						</td>
						<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소유구분
						</td>
						<td width="35%" class="data_td">
							<input type="text" name="own_kind" id="own_kind" value="" onkeydown='entKeyDown()' >
						</td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#dedede"></td>
					</tr>
					<tr>
						<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;영업점
						</td>
						<td width="35%" class="data_td">
							<input type="text" name="dept" id="dept" style="ime-mode:inactive" size="16" class="inputsubmit" value='' onkeydown='entKeyDown()' >
							<a href="javascript:PopupManager('DEPT');">
								<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
							</a>
							<a href="javascript:doRemove('DEPT')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
							<input type="text" name="dept_text" id="dept_text" onkeydown='entKeyDown()'  size="25" class="input_data2" readonly value='' readOnly>
						</td>
						<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공사명
						</td>
						<td width="35%" class="data_td">
							<input type="text" name="con_name" id="con_name" value="" onkeydown='entKeyDown()' >
						</td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#dedede"></td>
					</tr>
					<tr>
						<td width="10%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급방법
						</td>
						<td width="40%" class="data_td">
							<input type="text" name="pay_term" id="pay_term" value="" onkeydown='entKeyDown()' >
						</td>
						<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약일자
						</td>
						<td width="35%" class="data_td">
							<s:calendar id="con_from_date" format="%Y/%m/%d"  default_value="<%=SepoaString.getDateSlashFormat(from_date)%>"/>
							~
							<s:calendar id="con_to_date" format="%Y/%m/%d"  default_value="<%=SepoaString.getDateSlashFormat(to_date)%>"/>
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
		<table cellpadding="0">                                                                                                                                                   
		<tr>	                                                                                                                                                                              
			<td><script language="javascript">btn("javascript:doSelect()","조회")</script></td>
			<td><script language="javascript">btn("javascript:doSave('insert')","등록")</script></td>
			<td><script language="javascript">btn("javascript:doSave('update')","수정")</script></td>
			<td><script language="javascript">btn("javascript:doDelete()","삭제")</script></td>
<%-- 			<td><script language="javascript">btn("javascript:doPrint()","출력")</script></td> --%>
		</tr>                                                                                                                                                                               
		</table>                                                                                                                                                                              
	</td>
</tr>
</table>                                                                                                                                                                                 
</form>
</s:header>
<%-- <s:grid screen_id="HW_001" grid_obj="GridObj" grid_box="gridbox" height="60"/> --%>
<%-- <s:grid screen_id="HW_001_2" grid_obj="GridObj2" grid_box="gridbox2" grid_cnt="2" height="40"/> --%>
<!-- <div id="gridbox_1" name="gridbox_1" width="100%" style="background-color:white;"></div> -->
	<s:grid screen_id="HW_001" height="60"/>
<s:footer/>
</body>
</html>



