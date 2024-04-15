<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
// 2011.08.18 HMCHOI
// 협력업체 신규회원 가입시에만 ID 및 기타 세션을 DUMP 세션으로 대치한다.
//info = new WiseInfo(info.getSession("HOUSE_CODE"),"ID=IF^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");

	Vector multilang_id = new Vector();
	multilang_id.addElement("SU_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SU_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
 Title:        vendor icomvncp 담당자 생성
 Description:
 Copyright:    Copyright (c)
 Company:      ICOMPIA <p>
 @author       eun pyo ,Lee<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
--%>

<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID="SU_001";%>
<!-- 사용 언어 설정 -->
<% String WISEHUB_LANG_TYPE="KR";%>
<%
	String user_id 			= JSPUtil.nullToEmpty(info.getSession("ID"));
	String user_name_loc 	= JSPUtil.nullToEmpty(info.getSession("NAME_LOC"));
	String user_name_eng 	= JSPUtil.nullToEmpty(info.getSession("NAME_ENG"));
	String user_dept 		= JSPUtil.nullToEmpty(info.getSession("DEPARTMENT"));
	String house_code 		= JSPUtil.nullToEmpty(info.getSession("HOUSE_CODE"));

	String vendor_code      = JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
	String company_code     = JSPUtil.nullToEmpty(request.getParameter("company_code"));
	String flag                = JSPUtil.nullToEmpty(request.getParameter("flag"));
	String buyer_house_code = request.getParameter("buyer_house_code")==null?"100":request.getParameter("buyer_house_code");

	String mode        = request.getParameter("mode")==null?"":request.getParameter("mode");
  	String sg_refitem  = request.getParameter("sg_refitem")==null?"":request.getParameter("sg_refitem"); //소싱 그룹 구분키
  	String irs_no      = request.getParameter("irs_no")==null?"":request.getParameter("irs_no");
  	String status      = request.getParameter("status")==null?"":request.getParameter("status");

	String popup             = JSPUtil.nullToEmpty(request.getParameter("popup"));
// 	SepoaListBoxOver LB = new SepoaListBoxOver();
	SepoaListBox LB = new SepoaListBox();
	String COMBO_M000 = LB.Table_ListBox(request, "SL0022", house_code+"#M174#", "&" , "#"); 	//최종직위
// 	String COMBO_M000 = LB.Table_ListBox(info, "SL0022", house_code+"#M174#", "&" , "#"); 	//최종직위
	//Logger.err.println(COMBO_M000);
	
    
	if("".equals(sg_refitem) || sg_refitem == null)
		sg_refitem = "0";

	//WiseInfo info = new WiseInfo(buyer_house_code,"HOUSE_CODE="+buyer_house_code+"^@^ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
	SepoaFormater wf        = null;
	SepoaFormater wf_sub    = null;
	SepoaOut value = null;
	SepoaRemote remote      = null;

	int count 	= 0;
	String IS_EXIST= "";
	String nickName= "s6006";
	String conType = "CONNECTION";
	String MethodName = "isSgExist2";
	String[] param = {vendor_code};

	try {
		remote = new SepoaRemote(nickName, conType, info);
	    value = remote.lookup(MethodName, param);

	    if(value.status == 1) {
	      	wf = new SepoaFormater(value.result[0]);
	      	count = Integer.parseInt(wf.getValue("count", 0));
	    }
	}catch(SepoaServiceException wse) {
		
		Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
		Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
		Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	}catch(Exception e) {
// 		e.printStackTrace();
		Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	}finally{
	    try{
	      remote.Release();
	    } catch(Exception e){
				    	
	    }
	}
%>

<html>
<head>
<title>
	<%=text.get("MESSAGE.MSG_9999")%>
</title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript" type="text/javascript">
<!--
var G_SERVLETURL         = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.admin.info.ven_bd_ins6";
var G_QUERY_VENDOR_CODE  = "<%=vendor_code%>";
var G_QUERY_COMPANY_CODE = "<%=company_code%>";
var G_HOUSE_CODE         = "<%=house_code%>";
var G_FLAG               = "<%=flag%>";
var G_MODE				 = "";
var INDEX_SELECTED      ;
var INDEX_USER_NAME     ;
var INDEX_DIVISION      ;
var INDEX_TEXT_POSITION ;
var INDEX_POP1          ;
var INDEX_PHONE_NO      ;
var INDEX_EMAIL         ;
var INDEX_MOBILE_NO     ;
var INDEX_FAX_NO        ;
var INDEX_POSITION      ;
var INDEX_HOUSE_CODE    ;
var INDEX_COMPANY_CODE  ;
var INDEX_VENDOR_CODE   ;
var INDEX_SEQ           ;
var INDEX_FLAG          ;
var WIDTH_SELECTED = "30";
function disableAll(wise)
{
	for(var i=0;i<GridObj.GetRowCount();i++)
	{
		for(var j=0;j<GridObj.GetColCount();j++)
		{
			GD_SetCellActivation(GridObj,i,j,false);
		}
	}
}
function setHeader()
{
    var colbg_m = "255|255|0";//jtable bgcolor
    var colbg_o = "245|245|205";//jtable bgcolor
    var wise = GridObj;

	if(G_FLAG == "D")
    {
    	WIDTH_SELECTED = "0"
    }

// 	GridObj.AddHeader("POP1"			,""				,"t_imagetext"	,3000	,0				,false);

	INDEX_SELECTED         = GridObj.GetColHDIndex("SELECTED");
    INDEX_USER_NAME        = GridObj.GetColHDIndex("USER_NAME");
    INDEX_DIVISION         = GridObj.GetColHDIndex("DIVISION");
    INDEX_TEXT_POSITION    = GridObj.GetColHDIndex("TEXT_POSITION");
    INDEX_POP1             = GridObj.GetColHDIndex("POP1");
    INDEX_PHONE_NO         = GridObj.GetColHDIndex("PHONE_NO");
    INDEX_EMAIL            = GridObj.GetColHDIndex("EMAIL");
    INDEX_MOBILE_NO        = GridObj.GetColHDIndex("MOBILE_NO");
    INDEX_FAX_NO           = GridObj.GetColHDIndex("FAX_NO");
    INDEX_POSITION         = GridObj.GetColHDIndex("POSITION");
    INDEX_HOUSE_CODE       = GridObj.GetColHDIndex("HOUSE_CODE");
    INDEX_COMPANY_CODE     = GridObj.GetColHDIndex("COMPANY_CODE");
    INDEX_VENDOR_CODE      = GridObj.GetColHDIndex("VENDOR_CODE");
    INDEX_SEQ              = GridObj.GetColHDIndex("SEQ");
    INDEX_FLAG             = GridObj.GetColHDIndex("FLAG");

	doSelect();  //  업체코드,회사단위  참조시에는 참조 데이타가 들어감
}

// 헤더의 버튼이 눌려지면 참조시일 경우 참조 데이타가 뿌려진다.
function doSelect()
{
	
	
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=getMainternace_icomvncp";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	GridObj.post( G_SERVLETURL, params );
	GridObj.clearAll(false);	
	
// 	var wise = GridObj;
//     GridObj.SetParam("company_code"	,G_QUERY_COMPANY_CODE);
// 	GridObj.SetParam("vendor_code"	,G_QUERY_VENDOR_CODE);
// 	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
// 	GridObj.SendData(G_SERVLETURL);
// 	GridObj.strHDClickAction="sortmulti";

}

//Line Insert
function setLineInsert()
{
	var wise = GridObj;
// 	GridObj.addRow();
	
	var newId = (new Date()).valueOf();
	GridObj.addRow(newId,"");
	var row = GridObj.GetRowCount();
	GridObj.cells(GridObj.getRowId(row-1), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	GridObj.cells(GridObj.getRowId(row-1), GridObj.getColIndexById("SELECTED")).setValue("1");
	GridObj.cells(GridObj.getRowId(row-1), GridObj.getColIndexById("FLAG")).setValue("I");
	
// 	GD_SetCellValueIndex(GridObj,row,INDEX_SELECTED,"1")			//ChekcBox "True"로 Set
// 	GD_SetCellValueIndex(GridObj,row,INDEX_POP1, "/kr/images/button/query.gif&null&null","&");
// 	GD_SetCellValueIndex(GridObj,row,INDEX_FLAG,"I");
<%-- 	GD_SetCellValueIndex(GridObj,row, INDEX_TEXT_POSITION 	,"<%=COMBO_M000%>", "&","#"); --%>
}

//Data Save
function setSave()
{
	var wise = GridObj;
	var selectedRow = 0;
	var re=/^[0-9a-z]([-_\.]?[0-9a-z])*@[0-9a-z]([-_\.]?[0-9a-z])*\.[a-z]{2,3}$/i;
	var nre=[0-9];
	var num=0;
	for(var i=0;i<GridObj.GetRowCount();i++)
	{
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED)==true)
		{
			if(GD_GetCellValueIndex(GridObj,i,INDEX_USER_NAME) == "")
			{
				alert("담당자명을 입력해 주십시오.");
				return;
			}

		    if(GD_GetCellValueIndex(GridObj,i, INDEX_EMAIL) == "" || !re.test(GD_GetCellValueIndex(GridObj,i, INDEX_EMAIL))) {
				alert("EMAIL을 양식에 맞게 입력해 주십시오.");
	            return;
		    }
		    
		    if(GD_GetCellValueIndex(GridObj,i, INDEX_PHONE_NO) == "" || !IsNumber1(GD_GetCellValueIndex(GridObj,i, INDEX_PHONE_NO))){
		    	alert("전화번호는 숫자만 입력가능합니다.");
	            return;
		    }
		    
		    if(GD_GetCellValueIndex(GridObj,i, INDEX_MOBILE_NO) == "" || !IsNumber1(GD_GetCellValueIndex(GridObj,i, INDEX_MOBILE_NO))){
		    	alert("핸드폰번호는 숫자만 입력가능합니다.");
	            return;
		    }

			selectedRow++;
		}
	}
	if(selectedRow == 0){
		alert("선택된 항목이 없습니다.");
		return;
	}
	if(!confirm("저장하시겠습니까?"))return;
	
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	params = "?mode=setSave_icomvncp";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	myDataProcessor = new dataProcessor( G_SERVLETURL+params);
	//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
}


/* 선택한 항목을 지운다. */
function Delete()
{
	var wise = GridObj;
	var rowCount = wise.GetRowCount();
	var selectedRow = 0;
	for( i = 0 ; i < rowCount ; i++){
		if(1 == wise.GetCellValue("SELECTED",i)){
			selectedRow++;
		}
	}

	if(selectedRow == 0){
		alert("선택된 항목이 없습니다.");
		return;
	}
	if(!confirm("정말로 삭제하시겠습니까?"))
		return;

	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	params = "?mode=setDelete_icomvncp";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	myDataProcessor = new dataProcessor( G_SERVLETURL+params);
	//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
}
var nextFlag = false;
function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
	if(msg1 == "doQuery")
	{
		if(G_FLAG == "D")
		{
			disableAll(GridObj);
		}
		var wise = GridObj;
		var rowCount = wise.GetRowCount();

		if(rowCount == 0){
			nextFlag = false;
		}else{
			nextFlag = true;
		}
	}
	if(msg1 == "doData")
	{
		rtn = GD_GetParam(GridObj,0);
	   	//alert(rtn);
	   	alert(GridObj.GetMessage());
		<%--
	   	if(G_MODE == "doConfirm"){
	   		window.close();
	   	}
	   	doSelect();
		--%>
	   	if(rtn == "doConfirm"){
	   		parent.window.close();
	   	}
	   	doSelect();
		return;
	}
	max_row = GridObj.GetRowCount();
	if(msg1 == "t_imagetext" )
	{
		document.forms[0].srow.value = msg2;
		if (msg3 == INDEX_POP1)
		{
			PopupCommon2("SP9053","getPosition",G_HOUSE_CODE,"M106","","");
		}
	}
}

function getPosition(code,name) {

	var row = document.forms[0].srow.value;

	GD_SetCellValueIndex(GridObj,row,INDEX_TEXT_POSITION,name);
	GD_SetCellValueIndex(GridObj,row,INDEX_POSITION,code);
}
//Data Save
function doConfirm()
{
	var sgCnt = '<%=count%>';
	if(!nextFlag){
		alert("담당자 정보는 적어도 한건 이상 필수입력 입니다.");
		return;
	}
	
	if(sgCnt < 1){
		alert("기본정보, 영업담당, 소싱정보등록은 필수입력사항입니다.\n(로그인아이디 신청 실패)");
		return;
	}
	
	if(!confirm("업체등록을 신청하시겠습니까?"))
		return;
	
	$.post(
		G_SERVLETURL,
	 	{ mode : "doConfirm", vendor_code : "<%=vendor_code%>"},
	 	function(arg){
	 		alert("아이디 신청이 완료되었습니다.");
	 	}
	);
	
// 	var grid_array = getGridChangedRows(GridObj, "SELECTED");
<%-- 	var cols_ids = "<%=grid_col_id%>"; --%>
// 	var params;
// 	params = "?mode=doConfirm";
// 	params += "&cols_ids=" + cols_ids;
// 	params += dataOutput();
// 	myDataProcessor = new dataProcessor( G_SERVLETURL+params);
// 	//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
// 	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);	
}
function BackPage()
{
	parent.up.MM_showHideLayers('m1','','hide','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m11','','show','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide');
	parent.up.goPage('gl');
}
function NextPage()
{
	if(!nextFlag){
		alert("담당자 정보는 적어도 한건 이상 필수입력 입니다.");
		return;
	}

	parent.up.MM_showHideLayers('m1','','show','m2','','show','m3','','hide','m4','','show','m5','','show','m6','','show','m11','','hide','m22','','hide','m33','','show','m44','','hide','m55','','hide','m66','','hide');
	parent.up.goPage('pj');
}
//-->
</Script>
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
    var header_name = GridObj.getColumnId(cellInd);
    var nre=[0-9];
	var num=0;
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
    	/* 
    	if(header_name=="PHONE_NO"){
    		if(!IsNumber1(GridObj.cells(rowId, GridObj.getColIndexById("PHONE_NO")).getValue())){
    	    	alert("전화번호는 숫자만 입력가능합니다.");
                return false;
    	    } 
    	}
    	if(header_name=="MOBILE_NO"){
    		if(!IsNumber1(GridObj.cells(rowId, GridObj.getColIndexById("MOBILE_NO")).getValue())){
    	    	alert("핸드폰번호는 숫자만 입력가능합니다.");
                return false;
    	    }
    	}
    	 */
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
//     if("undefined" != typeof JavaCall) {
//     	JavaCall("doData");
//     } 

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
<body onload="setGridDraw();setHeader();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  style="margin-top: 20px;margin-left: 20px;">

<s:header popup="true">
<!--내용시작-->
<form id="form" name="form" method="post" action="">
<input type="hidden" id="house_code" 		name="house_code" 			value="<%=house_code%>">
<input type="hidden" id="vendor_code" 		name="vendor_code" 			value="<%=vendor_code%>">
<input type="hidden" id="company_code" 		name="company_code" 		value="<%=company_code%>">
<input type="hidden" id="sg_refitem" 		name="sg_refitem" 			value="<%=sg_refitem%>">
<input type="hidden" id="mode" 				name="mode" 				value="<%=mode%>">
<input type="hidden" id="irs_no" 			name="irs_no" 				value="<%=irs_no%>">
<input type="hidden" id="status" 			name="status" 				value="<%=status%>">
<input type="hidden" id="flag" 				name="flag" 				value="<%=flag%>">
<input type="hidden" id="buyer_house_code" 	name="buyer_house_code" 	value="<%=buyer_house_code%>">
<input type="hidden" id="srow"				name="srow"					value="" ><%-- 팝업 로우를 기억하기 위함 --%>

<!-- 공백 : 회원가입, U : 관리자수정, Y : 상세정보보기, T : 협력업체에서 정보보기 -->
<%if (popup==null||"".equals(popup)||popup.equals("U")||popup.equals("T")) {%>
	<font color='red'>
		※ 정확히 입력하여 주십시오. -> 행삽입 후 영업담당 정보를 입력하고 등록하십시오.
	</font>
	<table width="98%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td align="right">
				<TABLE cellpadding="0">
		      		<TR>
	    	  			<td><script language="javascript">btn("javascript:setLineInsert()","행삽입")</script></td>
<%-- 						<TD><script language="javascript">btn("javascript:doSelect()","저 장")</script></TD> --%>
						<TD><script language="javascript">btn("javascript:setSave()","저 장")</script></TD>
		      			<TD><script language="javascript">btn("javascript:Delete()","삭 제")</script></TD>
		      			<TD><script language="javascript">btn("javascript:BackPage()","이 전")</script></TD>
						<TD><script language="javascript">btn("javascript:NextPage()","다 음")</script></TD>
						<%-- 
		      			<%if(!popup.equals("Y")&&!popup.equals("U")&&!popup.equals("T")){%>
		      			<TD><script language="javascript">btn("javascript:doConfirm()","로그인 아이디 신청")</script></TD>
		      			<%}%>
		      			--%>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
<%}%>


</form>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="SU_001" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


