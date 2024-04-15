<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%-- <%@ page import="javax.servlet.RequestDispatcher"%> --%>


<%-- TOBE 2017-07-01 점코드 글로벌 상수 --%>
<%@  page import="sepoa.svc.common.constants" %>
<%! String gam_jum_cd = constants.DEFAULT_GAM_JUMCD; %>
<%! String ict_jum_cd = constants.DEFAULT_ICT_JUMCD; %>


<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("ST_011");
	multilang_id.addElement("CT_031");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "ST_011";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
%>
<% String WISEHUB_PROCESS_ID="ST_011";%>
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
	String  signform_list	= ListBox(request, "SL0018",  house_code+"#M659#", "");
	
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


<%
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_sta_bd_lis45"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
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
	var GridObj2 = null;
	var G_PRE_CODE   = "B";
	var G_C_INDEX     = "MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:DELIVERY_IT:MAKER_NAME:MAKER_CODE:ITEM_GROUP:DELY_TO_ADDRESS:KTGRM";
	
	function setGridObj(arg) {
		GridObj = arg;
	}
	
	function init() {
			
		if( <%=checkVendor%> < 1 ) {// 품목카테고리가 재산관리 > 간판류 혹은 싸인유지보수인 품목을 가진 업체가 아니면 페이지 이동
			alert('[ 재산관리 > 간판류 ] 혹은 [ 싸인유지보수 ]\n품목카테고리의 업체만 해당 메뉴를 사용할 수 있습니다.');
			location.href = '/common/index_seller.jsp';
		}
		
		GridObj_setGridDraw();
		GridObj2_setGridDraw();
		GridObj.setSizes();
		GridObj2.setSizes();
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
		var branches_from_code	= del_Slash(document.form1.branches_from_code.value);
		var branches_to_code 		= del_Slash(document.form1.branches_to_code.value);
		var confirm_from_date		= del_Slash(document.form1.confirm_from_date.value);
		var confirm_to_date		= del_Slash(document.form1.confirm_to_date.value);
		var item_no     	= document.form1.item_no.value;
		var install_store	= document.form1.install_store.value;
		var signform		= document.form1.signform.value;
		
		/* 
		if(!checkDateCommon(confirm_from_date)) {
			alert("조회기간의 시작일자를 확인 하세요 ");
			document.form1.confirm_from_date.focus();
			return;
		}
		
		if(!checkDateCommon(confirm_to_date)) {
			alert("조회기간의 종료일자를 확인 하세요 ");
			document.form1.confirm_to_date.focus();
			return;
		}
		*/
		 
		document.form1.confirm_from_date.value = del_Slash( document.form1.confirm_from_date.value );
		document.form1.confirm_to_date.value   = del_Slash( document.form1.confirm_to_date.value   );
		 
		var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/statistics.sta_bd_lis45";

		var cols_ids = "<%=grid_col_id%>";
        var params = "mode=getSmaglList";
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
		var confirm_from_date		= del_Slash(document.form1.confirm_from_date.value);
		var confirm_to_date		= del_Slash(document.form1.confirm_to_date.value);
		var item_no     	= document.form1.item_no.value;
		var item_name    = document.form1.item_name.value;
		var install_store	= document.form1.install_store.value;
		var install_store_name	= document.form1.install_store_name.value;
		var signform		= document.form1.signform.value;
		var remove_flag		= document.form1.remove_flag.value;

		if(!checkDateCommon(confirm_from_date)) {
			alert("조회기간의 시작일자를 확인 하세요 ");
			document.form1.confirm_from_date.focus();
			return;
		}
		if(!checkDateCommon(confirm_to_date)) {
			alert("조회기간의 종료일자를 확인 하세요 ");
			document.form1.confirm_to_date.focus();
			return;
		}
		var param = "?mode=print";
		param += "&branches_from_code=" + branches_from_code;
		param += "&branches_from_name=" + branches_from_name;
		param += "&branches_to_code=" + branches_to_code;
		param += "&branches_to_name=" + branches_to_name;
		param += "&confirm_from_date=" + confirm_from_date;
		param += "&confirm_to_date=" + confirm_to_date;
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
var GridObj2 = null;
var MenuObj = null;
var myDataProcessor = null;

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd) {
	var header_name = GridObj.getColumnId(cellInd);
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
    		//F.content.value = GD_GetCellValueIndex(GridObj,msg2,INDEX_SCTM_SIGN_REMARK);
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
	var url  = "../statistics/sta_bd_lis45_popup.jsp";
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
		var key_no = "";
		var branches_code = "";
		var item_no = "";
		var io_number = "";
		for(var i = 0; i < grid_array.length; i++) {
			house_code 		= GridObj.cells(grid_array[i], GridObj.getColIndexById("HOUSE_CODE")).getValue();
			key_no 			= GridObj.cells(grid_array[i], GridObj.getColIndexById("KEY_NO")).getValue();
			branches_code 	= GridObj.cells(grid_array[i], GridObj.getColIndexById("BRANCHES_CODE")).getValue();
			item_no 		= GridObj.cells(grid_array[i], GridObj.getColIndexById("ITEM_CODE")).getValue();
			io_number 		= GridObj.cells(grid_array[i], GridObj.getColIndexById("IO_NUMBER")).getValue();
		}
		
		var param = "?mode=update";
		param += "&house_code=" + house_code;
		param += "&key_no=" + key_no;
		param += "&branches_code=" + branches_code;
		param += "&item_no=" + item_no;
		param += "&io_number=" + io_number;
		
		url = url + param;
	}
	window.open(url,"sign_control","left=0,top=0,width=1024,height=450,resizable=yes,scrollbars=yes, status=yes");
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
 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/statistics.sta_bd_lis45",params);
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
    
	document.form1.confirm_from_date.value = add_Slash( document.form1.confirm_from_date.value );
	document.form1.confirm_to_date.value   = add_Slash( document.form1.confirm_to_date.value   );
	
	GridObj2_setGridDraw();
	GridObj2.setSizes();
	recal();
    return true;
}

//팝업호출 공통
function PopupManager(part)
{
	var url = "";
	var f = document.forms[0];

	if(part == "BRANCHES_FROM"){	//소속점from
		window.open("/common/CO_009.jsp?callback=return_branches_from", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}else if(part == "BRANCHES_TO"){	//소속점to
	    window.open("/common/CO_009.jsp?callback=return_branches_to", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}else if(part == "STORE"){	//설치업체
		window.open("/common/CO_014.jsp?callback=return_vendor", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}else if(part == "ITEM"){	//품목
		setCatalogIndex(G_C_INDEX);
		
		url = "/kr/catalog/cat_pp_lis_main.jsp?INDEX=" + getAllCatalogIndex() ;
		
		CodeSearchCommon(url,"INVEST_NO",0,0,"950","530");
	}
}

function return_branches_from(code,text){
    document.forms[0].branches_from_code.value	= code;
	document.forms[0].branches_from_name.value 	= text;
}

function return_branches_to(code,text){
    document.forms[0].branches_to_code.value 	= code;
	document.forms[0].branches_to_name.value = text;
}

function return_vendor(code, desc1, desc2 , desc3) {
	document.forms[0].install_store.value = code;
	document.forms[0].install_store_name.value = desc1;
}

function setCatalog(itemNo, descriptionLoc, specification, makerCode, ctrlCode, qty, itemGroup, delyToAddress, unitPrice, ktgrm, makerName, basicUnit, materialType){
	document.forms[0].item_no.value 	= itemNo;
	document.forms[0].item_name.value = descriptionLoc;
}

function fnFiledown(attach_no){
	var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
	var b = "fileDown";
	var c = "300";
	var d = "100";
	 
	window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
}

/////////////////////////////////////////////
var rowId2 = null;

function GridObj2_doOnRowSelected(rowId2,cellInd2) {
	var header_name = GridObj2.getColumnId(cellInd2);
	if(header_name == "IMAGE") {
		if(GridObj.cells(rowId2, GridObj2.getColIndexById("ATTACH_NO")).getValue()==""){
    		alert("첨부파일이 없습니다");
    	}else{
			fnFiledown(GridObj2.cells(rowId2, GridObj2.getColIndexById("ATTACH_NO")).getValue());			
    	}
	} else if(header_name == "REMARK_IMAGE") {
		if(GridObj2.cells(rowId2, GridObj2.getColIndexById("REMARK")).getValue()!=""){
    		var F=document.forms[0];
    		F.subject_1.value = "특이사항"
    		F.sctm_sign_remark.value=GridObj2.cells(rowId2, GridObj2.getColIndexById("REMARK")).getValue();
    		//F.content.value = GD_GetCellValueIndex(GridObj,msg2,INDEX_SCTM_SIGN_REMARK);
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
    	var itemNo     = GridObj2.cells(rowId2, GridObj2.getColIndexById("ITEM_CODE")).getValue();
      	
      	var url        = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO=" + itemNo + "&BUY=";
      	var PoDisWin   = window.open(url, 'agentCodeWin', 'left=0, top=0, width=750, height=550, toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes');
      		
      	PoDisWin.focus();
	}
}

function doquery2(house_code, key_no, branches_code, item_no, io_number) {
	
	var params = "mode=getSmaglListHistory";
	params += "&house_code=" + house_code
	params += "&key_no=" + key_no
	params += "&branches_code=" + branches_code
	params += "&item_no=" + item_no
	params += "&io_number=" + io_number
	
	var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/statistics.sta_bd_lis45";

	var cols_ids = "<%=grid_col_id%>";
//     var params = "mode=getSmaglList";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj2.post( G_SERVLETURL, params );
    GridObj2.clearAll(false); 
	
}

function GridObj2_doQueryEnd() {
	var msg        = GridObj2.getUserData("", "message");
	var status     = GridObj2.getUserData("", "status");

	if(status == "false") alert(msg);
	return true;
}
// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
function GridObj2_doOnCellChange(stage,rowId,cellInd) {
	var max_value = GridObj2.cells(rowId, cellInd).getValue();
	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
	if(stage==0) {
		return true;
	} else if(stage==1) {
	} else if(stage==2) {
	    return true;
	}
	
	return false;    
}

//지우기
function doRemove( type ){
    if( type == "branches_from_code" ) {
    	document.forms[0].branches_from_code.value = "";
        document.forms[0].branches_from_name.value = "";
    }  
    if( type == "branches_to_code" ) {
        document.forms[0].branches_to_code.value = "";
   	 	document.forms[0].branches_to_name.value = "";
    }
    if( type == "item_no" ) {
    	document.forms[0].item_no.value      = "";
    	document.forms[0].item_name.value = "";
    }
    if( type == "install_store" ) {
    	document.forms[0].install_store.value      = "";
    	document.forms[0].install_store_name.value = "";
    }
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData,approvalCnt) {
	var sRptData = "";
	var rf = "<%=CommonUtil.getConfig("clipreport4.separator.field")%>";
	var rl = "<%=CommonUtil.getConfig("clipreport4.separator.line")%>";
	var rd = "<%=CommonUtil.getConfig("clipreport4.separator.data")%>";
	
	sRptData += document.form1.branches_from_code.value;	//소속점 from
	sRptData += rf;
	sRptData += document.form1.branches_from_name.value;	//소속점 from name
	sRptData += rf;
	sRptData += document.form1.branches_to_code.value;	//소속점 to
	sRptData += rf;
	sRptData += document.form1.branches_to_name.value;	//소속점 to name
	sRptData += rf;
	sRptData += document.form1.confirm_from_date.value;	//허가시작일
	sRptData += rf;
	sRptData += document.form1.confirm_to_date.value;	//허가만기일
	sRptData += rf;
	sRptData += document.form1.item_no.value;	//품목
	sRptData += rf;
	sRptData += document.form1.item_name.value;	//품목 이름
	sRptData += rf;
	sRptData += document.form1.signform.options[document.form1.signform.selectedIndex].text;	//간판형태
	sRptData += rf;
	sRptData += document.form1.install_store.value;	//관리업체
	sRptData += rf;
	sRptData += document.form1.install_store_name.value;	//관리업체 이름
	sRptData += rf;
	sRptData += document.form1.remove_flag.options[document.form1.remove_flag.selectedIndex].text;	//철거여부
	sRptData += rd;
			
	for(var i = 0; i < GridObj.GetRowCount(); i++){
		sRptData += GridObj.GetCellValue("NO",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("KEY_NO",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("BRANCHES_NAME",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("ITEM_NAME",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("ITEM_CODE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("SPECIFICATION",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("INSTALL_DATE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("CONFIRM_DATE_FROM",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("CONFIRM_DATE_TO",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("INSTALL_STORE_NAME",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("STICK_LOCATION",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("SIGNFORM_NAME",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("REMOVE_FLAG_TEXT",i);
		sRptData += rl;				
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
<form id="form1" name="form1" action="">
<%--ClipReport4 hidden 태그 시작--%>
<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="Y">
<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
<input type="hidden" name="rptAprv" id="rptAprv">		
<%--ClipReport4 hidden 태그 끝--%>	
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
						<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소속점(From)
						</td>
						<td width="35%" class="data_td">
							<input type="text" name="branches_from_code" id="branches_from_code" style="ime-mode:inactive" size="16" class="inputsubmit" value='' onkeydown='entKeyDown()' >
							<a href="javascript:PopupManager('BRANCHES_FROM');">
								<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
							</a>
							<a href="javascript:doRemove('branches_from_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
							<input type="text" name="branches_from_name" id="branches_from_name" onkeydown='entKeyDown()'  size="25" class="input_data2" readonly value='' readOnly>
						</td>
						<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소속점(To)
						</td>
						<td width="35%" class="data_td">
							<input type="text" name="branches_to_code" id="branches_to_code" onkeydown='entKeyDown()'  style="ime-mode:inactive" size="16" class="inputsubmit" value='' >
							<a href="javascript:PopupManager('BRANCHES_TO');">
								<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
							</a>
							<a href="javascript:doRemove('branches_to_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
							<input type="text" name="branches_to_name" id="branches_to_name" onkeydown='entKeyDown()'  size="20" class="input_data2" readonly value='' readOnly>
						</td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#dedede"></td>
					</tr>
					<tr>
						<td width="10%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;허가기간
						</td>
						<td width="40%" class="data_td">
							<s:calendar id="confirm_from_date"  format="%Y/%m/%d"/>
							~
							<s:calendar id="confirm_to_date"  format="%Y/%m/%d"/>
						</td>
						<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목
						</td>
						<td width="35%" class="data_td">
							<input type="text" name="item_no" id="item_no" style="ime-mode:inactive" onkeydown='entKeyDown()'  size="16" class="inputsubmit" value='' >
							<a href="javascript:PopupManager('ITEM');">
								<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
							</a>
							<a href="javascript:doRemove('item_no')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
							<input type="text" name="item_name" id="item_name" size="20" class="input_data2" onkeydown='entKeyDown()'  readonly value='' readOnly>
						</td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#dedede"></td>
					</tr>
					<tr>
						<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;간판형태
						</td>
						<td width="35%" class="data_td">
							<select name="signform" id="signform" class="inputsubmit">
							<option>전체</option>
							<%=signform_list %>
						    </select>
						</td>
						<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;관리업체
						</td>
						<td class="data_td" width="35%">
<!-- 							<input type="text" name="install_store" id="install_store" style="width:95%" class="inputsubmit" maxlength="100"> -->
							<input type="text" name="install_store" id="install_store" onkeydown='entKeyDown()'  style="ime-mode:inactive" size="16" class="inputsubmit" value='' >
							<a href="javascript:PopupManager('STORE');">
								<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
							</a>
							<a href="javascript:doRemove('install_store')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
							<input type="text" name="install_store_name" id="install_store_name" onkeydown='entKeyDown()'  size="20" class="input_data2" readonly value='' readOnly>
						</td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#dedede"></td>
					</tr>
					<tr>
						<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;간판상태
						</td>
						<td width="35%" class="data_td" colspan="3">
							<select name="remove_flag" id="remove_flag" class="inputsubmit">
								<option>전체</option>
								<option value="Y">설치중</option>
								<option value="N">철거완료</option>
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
		<table cellpadding="0">                                                                                                                                                   
		<tr>	                                                                                                                                                                              
			<td><script language="javascript">btn("javascript:doSelect()"	,"조 회")</script></td>
			<td><script language="javascript">btn("javascript:clipPrint()"	,"출 력")		</script></td>
			<td><script language="javascript">btn("javascript:doSave('insert')","등 록")</script></td>
			<td><script language="javascript">btn("javascript:doSave('update')","수 정")</script></td>
			
			<%-- ASIS 2017-07-01 <%if( "20644".equals( department ) ) { %> --%> 
			
			<%-- TOBE 2017-07-01 --%>
			<%if(gam_jum_cd.equals( department ) ) { %>
			
			<td><script language="javascript">btn("javascript:doDelete()","삭제")</script></td>
			<%} %>
			<!-- <td><script language="javascript">btn("javascript:doPrint()","출력")</script></td>-->
		</tr>                                                                                                                                                                               
		</table>                                                                                                                                                                              
	</td>
</tr>
</table>                                                                                                                                                                                 
</form>
</s:header>
<%-- <s:grid screen_id="ST_011" grid_obj="GridObj" grid_box="gridbox" height="60"/> --%>
<%-- <s:grid screen_id="ST_011_2" grid_obj="GridObj2" grid_box="gridbox2" grid_cnt="2" height="40"/> --%>
<!-- <div id="gridbox_1" name="gridbox_1" width="100%" style="background-color:white;"></div> -->
	<s:grid screen_id="ST_011" height="60"/>
	<s:grid screen_id="ST_011_2" grid_obj="GridObj2" grid_box="gridbox2" grid_cnt="2" height="10"/>
<s:footer/>
</body>
</html>



