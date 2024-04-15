<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
    String cskd_gb          = JSPUtil.nullToRef(request.getParameter("cskd_gb"),"01");

	Vector multilang_id = new Vector();
	multilang_id.addElement("EVC_"+ cskd_gb +"1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "EVC_"+ cskd_gb +"1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<!-- 폼작업만 했기때문에 틀을 제외한 함수 차후 변경 및 적용 -->
<%
    String user_id         	= info.getSession("ID");
	String company_code    	= info.getSession("COMPANY_CODE");
	String company_name    	= info.getSession("COMPANY_NAME");
	String house_code      	= info.getSession("HOUSE_CODE");
	String toDays          	= SepoaDate.getShortDateString();
	String toDays_1        	= SepoaDate.addSepoaDateMonth(toDays,-1);
	String user_name   	   	= info.getSession("NAME_LOC");
	String ctrl_code       	= info.getSession("CTRL_CODE");
	String to_date          = SepoaString.getDateSlashFormat(SepoaDate.getShortDateString());
	String from_date        = SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-3));

	String gate = JSPUtil.nullToRef(request.getParameter("gate"),"");
	
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_tax_pub_list"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
	

%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<script language="javascript">
<!--
	var	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.cs_ev_wait_list";
	
	var IDX_SEL;
	
	function setHeader() {
		var f0 = document.forms[0];

		// 그리드 헤더 설정
		

// 		GridObj.SetColCellBgColor("ITEM_QTY"		,G_COL1_OPT);
// 		GridObj.SetColCellBgColor("TAX_PRICE"		,G_COL1_ESS);

		// 그리드 포맷 설정
// 		GridObj.SetDateFormat("PAY_DATE"			,"yyyy/MM/dd");	
// 		GridObj.SetNumberFormat("ITEM_COUNT"	,"###,###.00");
// 		GridObj.SetNumberFormat("ITEM_QTY"	,"###,###.00");
// 		GridObj.SetNumberFormat("PAY_AMT"		,G_format_amt);

		// 그리드 위치 설정

		/*
		GridObj.SetColCellSortEnable("PO_CREATE_DATE"		,false);
		
		GridObj.SetDateFormat("PO_CREATE_DATE"	,"yyyy/MM/dd");
		GridObj.SetNumberFormat("PO_TTL_AMT"		,G_format_amt);
		*/
		
		// 그리드 인덱스 설정
		IDX_SEL					= GridObj.GetColHDIndex("SEL");
		doSelect();
	}

	function doSelect()
	{
		var f0 = document.forms[0];

		if(!checkDateCommon(del_Slash(f0.from_date.value))) {
			alert(" 검수일자(From)를 확인 하세요 ");
			f0.from_date.focus();
			return;
		}

		if(!checkDateCommon(del_Slash(f0.to_date.value))) {
			alert(" 검수일자(To)를 확인 하세요 ");
			f0.to_date.focus();
			return;
		}
		var grid_col_id = "<%=grid_col_id%>";
		var param = "mode=getCsEvList2&grid_col_id="+grid_col_id;
		param += dataOutput();
		var url = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.cs_ev_wait_list";
		GridObj.post(url, param);
		GridObj.clearAll(false);
	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5)
	{
		var po_no = "";
		var reject_reason_flag = "";
		
		if(msg1 == "doQuery"){
		}
		if(msg1 == "doData"){
			var mode  = GD_GetParam(GridObj,0);
			if(mode = "setTaxCheck"){

			}else{
				alert(GD_GetParam(GridObj,"0"));
				if(GridObj.GetStatus()==1) {
					doSelect();
				}				
			}
		}
		if(msg1 == "t_imagetext") {			
		}
	}
	
	//************************************************** Date Set *************************************

	function getVendorCode(setMethod) {
		popupvendor(setMethod);
	}
	
	function setVendorCode( code, desc1, desc2 , desc3) {
		document.forms[0].vendor_code.value = code;
		document.forms[0].vendor_code_name.value = desc1;
	}

	function popupvendor( fun )
	{
	    window.open("/common/CO_014.jsp?callback=setVendorCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
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
	
	//구매담당직무
	function getCtrlManager(code, text)
	{
		document.forms[0].ctrl_code.value = code;
		document.forms[0].ctrl_name.value = text;
	}
	
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SEL");

		if(grid_array.length == 0)
		{
			alert("삭제할 행을 선택하세요");
			return false;
		}

		if(grid_array.length != 1)
		{
			alert("삭제할 행을 하나만 선택하세요");
			return false;
		}
		
		return true;
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
    	<% if("01".equals(cskd_gb)){ %>
    		GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,천정(5),벽체(20),바닥(5),창호및유리(5),도장(5),공통(10),전체공정관리(10),민원방지 및 대관업무(10),성실도 및 대처능력(10),#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");    	
    	<% }else if("02".equals(cskd_gb)){ %>
    		GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,공조닥트(10),냉난방 공조배관(10),위생 급수배관(10),기기의 성능 및 설치상태(5),소방설비(5),위생기구(5),냉난방기 이설 설치(5),자재 정품 사용 및 시정명령준수(10),전체공정관리(10),민원관리 및 대관업무(10),성실도 및 대체능력(10),#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");    	
    	<% }else if("03".equals(cskd_gb)){ %>
    		GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,배관배선(10),조명기구(10),스위치 콘센트(10),분전반 내부결선 및 제작상태(10),감지기 유도등(10),자재정품 사용 및 시정명령준수(10),전체공정관리(10),민원관리 및 대관업무(10),성실도 및 대체능력(10),#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");    	
    	<% }else if("05".equals(cskd_gb)){ %>
    		GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,배관배선(10),랜아웃렛 전화콘덴서(10),전산단자함 전화단자함(10),전화교환기 전산기기(10),스피커 TV설비(10),자재정품 사용 및 시정명령준수(10),전체공정관리(10),민원관리 및 대관업무(10),성실도 및 대체능력(10),#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");    	
    	<% } %>
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
	
	var header_name = GridObj.getColumnId(cellInd);
	var url = '';
	var param = '';
	
	if( header_name == "EC_NO" ) {
		var url = "/kr/ev/cs_ev_dis.jsp";
		var param = "";
		param += "?popup_flag_header=true";
		param += "&ec_no="+SepoaGridGetCellValueId(GridObj, rowId, "EC_NO");
		PopupGeneral(url+param, "공사평가상세", "", "", "925", "1000");
	} else if( header_name == "INV_NO" ) {
		
		url = '/procure/invoice_detail.jsp';
		title  = '검수상세조회';
		param  = 'popup_flag_header=true';
		param += '&po_no=' + SepoaGridGetCellValueId(GridObj, rowId, "PO_NO");
		param += '&inv_no=' + SepoaGridGetCellValueId(GridObj, rowId, "INV_NO");
		popUpOpen01(url, title, "1000", "600", param);
		
	} else if( header_name == "COMPANY_NAME" ) {
		
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "COMPANY_CODE");
		
	    url = '/s_kr/admin/info/ven_bd_con.jsp';
// 	    url = '/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code='+vendor_code;
	    title  = "업체상세조회";
	    param  = 'popup=Y';
	    param += '&mode=irs_no';
	    param += '&vendor_code=' + vendor_code;
	    popUpOpen01(url, title, '900', '700', param);
		
	} else if( header_name == "ITEM_NO" ) {
		
		var itemNo	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ITEM_NO") ).getValue()); 

		url    = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO=" + itemNo + "&BUY=";
		title  = "품목상세조회";        
		param  = 'ITEM_NO=' + itemNo;
		param += '&BUY=';
		popUpOpen01(url, title, '750', '550', param);
		
	} else if(header_name == "PO_NO"){
		
		var url = "/procure/po_detail.jsp";
		var param = "";
		param += "?popup_flag_header=true";
		param += "&po_no="+SepoaGridGetCellValueId(GridObj, rowId, "PO_NO");
		PopupGeneral(url+param, "PoDetailPop", "", "", "1000", "600");
	}
	
	var grid_array = getGridChangedRows(GridObj, "SEL");
	var rowcount = grid_array.length;
	//GridObj.enableSmartRendering(false);

	for(var row = rowcount - 1; row >= 0; row--)
	{
		GridObj.cells(grid_array[row], GridObj.getColIndexById("SEL")).setValue(0);
		GridObj.cells(grid_array[row], GridObj.getColIndexById("SEL")).cell.wasChanged = false;
    }	
	
	
	GridObj.cells( rowId, GridObj.getColIndexById("SEL")).setValue(1);
	GridObj.cells( rowId, GridObj.getColIndexById("SEL")).cell.wasChanged = true;

    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.sepoaGrid,strColumnKey, nRow);

    
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
    	if(GridObj.getColIndexById("SEL") == cellInd){
			for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
				GridObj.cells(GridObj.getRowId(i), cellInd).setValue("0");			
			}
		}
    	GridObj.cells(rowId, cellInd).setValue("1");
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

 	alert(messsage);
    
    doSelect();
    
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
    // sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}

function MATERIAL_TYPE_Changed()
{
    clearMATERIAL_CTRL_TYPE();
    clearMATERIAL_CLASS1();
    clearMATERIAL_CLASS2();
    setMATERIAL_CLASS1("전체", "");
    setMATERIAL_CLASS2("전체", "");
    var id = "SL0009";
    var code = "M041";
    var value = form1.material_type.value;
    target = "MATERIAL_TYPE";
    data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    xWork.location.href = data;
}
function MATERIAL_CTRL_TYPE_Changed()
{
    clearMATERIAL_CLASS1();
    clearMATERIAL_CLASS2();
    setMATERIAL_CLASS2("전체", "");
    var id = "SL0019";
    var code = "M042";
    var value = form1.material_ctrl_type.value;
    target = "MATERIAL_CTRL_TYPE";
    data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    xWork.location.href = data;
}

function MATERIAL_CLASS1_Changed()
{
    clearMATERIAL_CLASS2();
    var id = "SL0089";
    var code = "M122";
    var value = form1.material_class1.value;
    target = "MATERIAL_CLASS1";
    data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    xWork.location.href = data;
}

function clearMATERIAL_CTRL_TYPE() {
    if(form1.material_ctrl_type.length > 0) {
        for(i=form1.material_ctrl_type.length-1; i>=0;  i--) {
            form1.material_ctrl_type.options[i] = null;
        }
    }
}
function setMATERIAL_CTRL_TYPE(name, value) {
    var option1 = new Option(name, value, true);
    form1.material_ctrl_type.options[form1.material_ctrl_type.length] = option1;
}
function clearMATERIAL_CLASS1() {
    if(form1.material_class1.length > 0) {
        for(i=form1.material_class1.length-1; i>=0;  i--) {
            form1.material_class1.options[i] = null;
        }
    }
}
function setMATERIAL_CLASS1(name, value) {
    var option1 = new Option(name, value, true);
    form1.material_class1.options[form1.material_class1.length] = option1;
}
function clearMATERIAL_CLASS2() {
    if(form1.material_class2.length > 0) {
        for(i=form1.material_class2.length-1; i>=0;  i--) {
            form1.material_class2.options[i] = null;
        }
    }
}
function setMATERIAL_CLASS2(name, value) {
    var option1 = new Option(name, value, true);
    form1.material_class2.options[form1.material_class2.length] = option1;
}

function SP9113_Popup( type ) {
	if( type == "eval_user_id" ) {
		window.open("/common/CO_008.jsp?callback=eval_callback", "SP9114", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}else if( type == "inv_user_id" ) {
		window.open("/common/CO_008.jsp?callback=inv_callback", "SP9115", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}else if( type == "purchase_id" ) {
		window.open("/common/CO_008.jsp?callback=SP9113_getCode", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
}

function  inv_callback(id, name) {
	form1.inv_user_id.value     = id;
	form1.inv_user_name.value   = name;
}

function  eval_callback(id, name) {
	form1.eval_user_id.value     = id;
	form1.eval_user_name.value   = name;
}

function  SP9113_getCode(id, name) {
	form1.purchase_id.value		= id;
	form1.purchase_name.value   = name;
}

//지우기
function doRemove( type ){
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_code_name.value = "";
    }
    if( type == "eval_user_id" ) {
    	document.forms[0].eval_user_id.value = "";
        document.forms[0].eval_user_name.value = "";
    }
    if( type == "inv_user_id" ) {
    	document.forms[0].inv_user_id.value = "";
        document.forms[0].inv_user_name.value = "";
    }
    if( type == "purchase_id" ) {
    	document.forms[0].purchase_id.value = "";
        document.forms[0].purchase_name.value = "";
    }
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}

function cskd_gb_Changed(){
	
	document.form1.action = "/kr/ev/cs_ev_list2.jsp";
	document.form1.method = "POST";
	document.form1.target = "_self";
	document.form1.submit();
	
}


<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData,approvalCnt) {
	var sRptData = "";
	var rf = "<%=CommonUtil.getConfig("clipreport4.separator.field")%>";
	var rl = "<%=CommonUtil.getConfig("clipreport4.separator.line")%>";
	var rd = "<%=CommonUtil.getConfig("clipreport4.separator.data")%>";
	
	sRptData += document.form1.from_date.value;	//검수일자 from
	sRptData += " ~ ";
	sRptData += document.form1.to_date.value;	//검수일자 to
	sRptData += rf;
	sRptData += document.form1.vendor_code.value;	//업체코드1
	sRptData += rf;
	sRptData += document.form1.vendor_code_name.value;	//업체코드2
	sRptData += rf;
	sRptData += document.form1.purchase_id.value;	//구매담당자 1
	sRptData += rf;
	sRptData += document.form1.purchase_name.value;	//구매담당자 2
	sRptData += rf;
	sRptData += document.form1.material_type.options[document.form1.material_type.selectedIndex].text;	//대분류
	sRptData += rf;
	sRptData += document.form1.material_ctrl_type.options[document.form1.material_ctrl_type.selectedIndex].text; //중분류
	sRptData += rf;
	sRptData += document.form1.material_class1.options[document.form1.material_class1.selectedIndex].text;	//소분류
	sRptData += rf;
	sRptData += document.form1.material_class2.options[document.form1.material_class2.selectedIndex].text;	//세분류
	sRptData += rd;
			
	for(var i = 0; i < GridObj.GetRowCount(); i++){
		sRptData += GridObj.GetCellValue("INV_NO",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("GR_DATE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("INV_PERSON_ID",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("COMPANY_CODE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("COMPANY_NAME",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("ITEM_NO",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("DESCRIPTION_LOC",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("ITEM_QTY",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("ITEM_AMT",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("PURCHASE_NAME",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("SUBJECT",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("PO_NO",i);
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
<body onload="javascript:setGridDraw();javascript:setHeader()" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >

<s:header>
<!--내용시작-->
<%if("".equals(gate)){%>
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
<%
}
%>


<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<form name="form1" >
	<%--ClipReport4 hidden 태그 시작--%>
	<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
	<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
	<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="Y">
	<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
	<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
	<input type="hidden" name="rptAprv" id="rptAprv">		
	<%--ClipReport4 hidden 태그 끝--%>
	<input type="hidden" id="kind" name="kind">
	<input type="hidden" id="type_tmp" name="type_tmp" value="">
	<input type="hidden" id="att_mode"   name="att_mode"  value="">
	<input type="hidden" id="view_type"  name="view_type"  value="">
	<input type="hidden" id="file_type"  name="file_type"  value="">
	<input type="hidden" id="tmp_att_no" name="tmp_att_no" value="">
	<input type="hidden" id="demand_dept" name="demand_dept">
	<input type="hidden" id="yn" name="yn">
	<tr>
  		<td width="12%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공종</td>      	
		<td width="30%" class="data_td">
				<select name="cskd_gb" id="cskd_gb" class="inputsubmit"  onChange="javacsript:cskd_gb_Changed();">							
	<%
		String listbox9 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M903", cskd_gb);
		out.println(listbox9);
	%>
				</select>
		 </td>      	       
	    <td width="10%" class="title_td">&nbsp;</td>      
	    <td width="30%" class="data_td">&nbsp;</td>
	    <td width="10%" class="title_td">&nbsp;</td>      	
		<td  width="8%" class="data_td" >&nbsp;</td>           
    </tr>
    <tr>
		<td colspan="6" height="1" bgcolor="#dedede"></td>
	</tr>  	
    <tr>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 평가일자</td>
      <td class="data_td">
        <s:calendar id_from="from_date" default_from="<%=from_date %>" default_to="<%=to_date %>" id_to="to_date" format="%Y/%m/%d" />
      </td>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공사평가자</td>      	
      <td class="data_td" >
	        <b><input type="text" name="eval_user_id" id="eval_user_id" style="ime-mode:inactive" value='<%=("MUP210200001".equals(info.getSession("MENU_PROFILE_CODE")))?"":info.getSession("ID")%>'  size="15" class="inputsubmit" onkeydown='entKeyDown()'>
	        <a href="javascript:SP9113_Popup('eval_user_id');"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
	        <a href="javascript:doRemove('eval_user_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
	        <input type="text" name="eval_user_name" id="eval_user_name" size="20" value='<%=("MUP210200001".equals(info.getSession("MENU_PROFILE_CODE")))?"":info.getSession("NAME_LOC")%>' readOnly onkeydown='entKeyDown()'></b>
	  </td>	    	    
	  <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공사평가번호</td>      	
	  <td class="data_td"><input type="text" name="ec_no" id="ec_no" size="15" onkeydown='entKeyDown()'></td>        	
    </tr>
    <tr>
		<td colspan="6" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
    	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업체코드</td>      
	    <td class="data_td">
	      	<input type="text" name="vendor_code" id="vendor_code" style="ime-mode:inactive"  size="15" class="inputsubmit" maxlength="10" onkeydown='entKeyDown()'>
	        <a href="javascript:getVendorCode('setVendorCode')"><img src="/images/ico_zoom.gif" width="19" height="19" align="absmiddle" border="0"></a>
	        <a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
	        <input type="text" name="vendor_code_name" id="vendor_code_name" size="20" onkeydown='entKeyDown()'>
	    </td>
    	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수자</td>      	
	    <td class="data_td"  >
		        <b><input type="text" name="inv_user_id" id="inv_user_id" style="ime-mode:inactive" value=""  size="15" class="inputsubmit" onkeydown='entKeyDown()'>
		        <a href="javascript:SP9113_Popup('inv_user_id');"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
		        <a href="javascript:doRemove('inv_user_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
		        <input type="text" name="inv_user_name" id="inv_user_name" size="20" value="" readOnly onkeydown='entKeyDown()'></b>
		</td>
	     <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수번호</td>      	
		<td class="data_td" ><input type="text" name="inv_no" id="inv_no" size="15" onkeydown='entKeyDown()'></td>           
    </tr>	
	<tr style="display:none">
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
	<tr style="display:none">
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 대분류</td>
		<td class="data_td">
			<select name="material_type" id="material_type" class="inputsubmit" onChange="javacsript:MATERIAL_TYPE_Changed();">
				<option value="" selected="selected">전체</option>
<%
	String listbox1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M040", "");
	out.println(listbox1);
%>
			</select>
		</td>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 중분류</td>
		<td class="data_td">
			<select name="material_ctrl_type" id="material_ctrl_type" class="inputsubmit" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();">
				<option value=''>전체</option>
			</select>
		</td>
	</tr>
	<tr style="display:none">
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr style="display:none">
    	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 소분류</td>
    	<td class="data_td">
    		<select name="material_class1" id="material_class1" class="inputsubmit" onChange="javacsript:MATERIAL_CLASS1_Changed();">
    			<option value=''>전체</option>
    		</select>
    	</td>
    	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 세분류</td>
    	<td class="data_td">
    		<select name="material_class2" id="material_class2" class="inputsubmit">
    			<option value=''>전체</option>
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
<!--     	    <td height="10" align="left"> -->
<!--     			<TABLE cellpadding="0"> -->
<!--     				<TR> -->
<!--     					<TD> -->
<!-- 		      				<input type="radio" name="publish" value="P" checked="checked" style="border: 0">정발행 -->
<!-- 		      				<input type="radio" name="publish" value="RP" style="border: 0">역발행 -->
<!-- 		      			</TD> -->
<!-- 		      		</TR> -->
<!-- 		      	</TABLE> -->
<!--        		</td> -->
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
	    	  			<TD><script language="javascript">btn("javascript:doSelect()","조 회")</script></TD>
	    	  			<%--<TD><script language="javascript">btn("javascript:clipPrint()","출 력")		</script></TD>--%>	    	  				  			
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
<s:footer/>
</body>
</html>


