<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("MA_006");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "MA_006";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;


	String WISEHUB_PROCESS_ID="MA_006";
	String WISEHUB_LANG_TYPE="KR";
    String house_code   = info.getSession("HOUSE_CODE");
    String company_code = info.getSession("COMPANY_CODE");
    String Attach_Index = "";
    String req_item_no = JSPUtil.CheckInjection(request.getParameter("REQ_ITEM_NO"));
    SepoaListBox lb = new SepoaListBox();
    String result = lb.Table_ListBox( request, "SL0200", house_code, "#", "@");
    String G_IMG_ICON = "/images/ico_zoom.gif";
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-kr">
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<%

    String[] args={ req_item_no};
	Object[] obj = {args};

	SepoaOut value = ServiceConnector.doService(info, "t0002", "CONNECTION","req_ins_getReqList", obj);
	SepoaFormater wf = new SepoaFormater(value.result[0]);
	String ITEM_GROUP					= "";
	String ITEM_NO						= "";
	String Z_PURCHASE_TYPE 		        = "";

    String MATERIAL_CLASS1      		= "";
    String MATERIAL_CLASS2      		= "";
    String MATERIAL_TYPE      			= "";
    String MATERIAL_CTRL_TYPE      		= "";
    String MATERIAL_CLASS2_NAME 		= "";
    String MATERIAL_CLASS1_NAME 		= "";
    String MATERIAL_CTRL_TYPE_NAME 		= "";
	String DESCRIPTION_LOC  	        = "";
	String SPECIFICATION				= "";
	String ITEM_ABBREVIATION            = "";
	String BASIC_UNIT 		            = "";
	String ATTACH_INDEX  		        = "";
	String IMAGE_FILE_PATH 	            = "";
	String IMAGE_FILE_NAME 	            = "";
	String MARKET_TYPE 		            = "";
	String DELIVERY_LT  		        = "";
	String APP_TAX_CODE 		        = "";
	String DRAWING_NO1  		        = "";
	String ITEM_BLOCK_FLAG			    = "";
	String MAKER_NAME		            = "";
	String MAKER_ITEM_NO 		        = "";
	String OLD_ITEM_NO   		        = "";
	String DO_FLAG 			            = "";
	String QI_FLAG					    = "";
	String PROXY_ITEM_NO	            = "";
	String Z_WORK_STAGE_FLAG            = "";
	String Z_DELIVERY_CONFIRM_FLAG		= "";
	String Z_ITEM_DESC					= "";
    String REQ_USER_ID          		= "";
    String REQ_DATE             		= "";
    String REQ_TYPE             		= "";
    String CONFIRM_STATUS       		= "";
    String DATA            				= "";
    String DATA_TYPE            		= "";
    String CONFIRM_DATE         		= "";
    String CONFIRM_USER_NAME    		= "";
	String RELEASE_FLAG					= "";
	String RELEASE_FLAG_NAME			= "";
	String INTEGRATED_BUY_NAME			= "";
	String REMARK						= "";
	String INTEGRATED_BUY_FLAG			= "";
	String COMPANY_CODE_NAME			= "";
	String MAKER_FLAG					= "";
	String MODEL_FLAG					= "";
	String MODEL_NO						= "";
    String MAKER_CODE 					="";
    String ATTACH_NO 					="";
    String ATTACH_CNT 					="";
    String MAKE_AMT_CODE				="";

    for ( int i = 0; i<wf.getRowCount(); i++) {

        ITEM_NO      		 			= wf.getValue("ITEM_NO"     			    ,   i);
        ITEM_GROUP						= wf.getValue("Z_ITEM_GROUP"				,	i);
        MATERIAL_CLASS1      			= wf.getValue("MATERIAL_CLASS1"     		,   i);
        MATERIAL_CLASS2      			= wf.getValue("MATERIAL_CLASS2"     		,   i);
        MATERIAL_TYPE      				= wf.getValue("MATERIAL_TYPE"     			,   i);
        MATERIAL_CTRL_TYPE      		= wf.getValue("MATERIAL_CTRL_TYPE"     		,   i);
        MATERIAL_CLASS2_NAME 			= wf.getValue("MATERIAL_CLASS2_NAME"		,   i);
        MATERIAL_CLASS1_NAME 			= wf.getValue("MATERIAL_CLASS1_NAME"		,   i);
        MATERIAL_CTRL_TYPE_NAME 		= wf.getValue("MATERIAL_CTRL_TYPE_NAME"		,   i);
        DESCRIPTION_LOC      			= wf.getValue("DESCRIPTION_LOC"     	    ,   i);
        SPECIFICATION      				= wf.getValue("SPECIFICATION"     	    	,   i);
        ITEM_ABBREVIATION				= wf.getValue("ITEM_ABBREVIATION"		    ,	i);
        BASIC_UNIT           			= wf.getValue("BASIC_UNIT"          	    ,   i);
        MAKER_NAME           			= wf.getValue("MAKER_NAME"          	    ,   i);
        RELEASE_FLAG         			= wf.getValue("RELEASE_FLAG"        	    ,   i);
        ATTACH_INDEX					= wf.getValue("ATTACH_INDEX"			    ,	i);
        MARKET_TYPE						= wf.getValue("MARKET_TYPE"					,   i);
        DELIVERY_LT						= wf.getValue("DELIVERY_LT"					,	i);
        APP_TAX_CODE					= wf.getValue("APP_TAX_CODE"			    ,   i);
        ITEM_BLOCK_FLAG					= wf.getValue("ITEM_BLOCK_FLAG"				,	i);
        MAKER_ITEM_NO					= wf.getValue("MAKER_ITEM_NO"			    ,	i);
        DO_FLAG 			   			= wf.getValue("DO_FLAG" 			        ,	i);
		QI_FLAG							= wf.getValue("QI_FLAG"						,	i);
		PROXY_ITEM_NO	       			= wf.getValue("PROXY_ITEM_NO"	            ,	i);
		Z_WORK_STAGE_FLAG      			= wf.getValue("Z_WORK_STAGE_FLAG"         	,	i);
		Z_DELIVERY_CONFIRM_FLAG			= wf.getValue("Z_DELIVERY_CONFIRM_FLAG"   	,	i);

        if(RELEASE_FLAG.equals("Y"))
            RELEASE_FLAG_NAME 			= "YES";
        else RELEASE_FLAG_NAME 			= "NO";
        INTEGRATED_BUY_FLAG  			= wf.getValue("INTEGRATED_BUY_FLAG" 	    ,   i);
        if(INTEGRATED_BUY_FLAG.equals("Y"))
            INTEGRATED_BUY_NAME 		= "통합구매";
        else {
            INTEGRATED_BUY_NAME 		= "자체구매";
            COMPANY_CODE_NAME    		= wf.getValue("COMPANY_CODE_NAME"   	    ,   i);
        }
        IMAGE_FILE_PATH      			= wf.getValue("IMAGE_FILE_PATH"     	    ,   i);
        IMAGE_FILE_NAME      			= wf.getValue("IMAGE_FILE_NAME"     	    ,   i);
        DRAWING_NO1       				= wf.getValue("DRAWING_NO1"      			,   i);
        OLD_ITEM_NO          			= wf.getValue("OLD_ITEM_NO"         	    ,   i);
        Z_ITEM_DESC          			= wf.getValue("Z_ITEM_DESC"         	    ,   i);
        REMARK    						= wf.getValue("REMARK"   				    ,   i);

        ITEM_GROUP						= wf.getValue("Z_ITEM_GROUP"   				,   i);
		Z_PURCHASE_TYPE 				= wf.getValue("Z_PURCHASE_TYPE"   			,   i);

        REQ_USER_ID          			= wf.getValue("REQ_USER_ID"         	    ,   i);
        REQ_DATE             			= wf.getValue("REQ_DATE"            	    ,   i);
        REQ_TYPE             			= wf.getValue("REQ_TYPE"            	    ,   i);
        CONFIRM_STATUS       			= wf.getValue("CONFIRM_STATUS"      	    ,   i);
        DATA                 			= wf.getValue("DATA"                	    ,   i);
        DATA_TYPE            			= wf.getValue("DATA_TYPE"           	    ,   i);
        CONFIRM_DATE         			= wf.getValue("CONFIRM_DATE"        	    ,   i);
        CONFIRM_USER_NAME    			= wf.getValue("CONFIRM_USER_NAME"   	    ,   i);

        REQ_DATE            			= SepoaString.dateStr(REQ_DATE);
		CONFIRM_DATE        			= SepoaString.dateStr(CONFIRM_DATE);

		ITEM_BLOCK_FLAG     			= wf.getValue("ITEM_BLOCK_FLAG"   		,   i) ;
	  	MAKER_FLAG						= wf.getValue("MAKER_FLAG"   			,   i).equals("Y")?"checked":"";
	  	MODEL_FLAG						= wf.getValue("MODEL_FLAG"   			,   i) ;
	  	MODEL_NO						= wf.getValue("MODEL_NO"   	    		,   i);
	  	MAKER_CODE						= wf.getValue("MAKER_CODE"   	    	,   i);
	  	ATTACH_NO						= wf.getValue("ATTACH_NO"   	    	,   i);
	  	ATTACH_CNT						= wf.getValue("ATTACH_CNT"   	    	,   i);
	  	MAKE_AMT_CODE					= wf.getValue("MAKE_AMT_CODE"   	  	,   i);

    }

    
  //단위결정기준
    String make_amt_codes = ListBox(request, "SL0018",  info.getSession("HOUSE_CODE")+"#M799", MAKE_AMT_CODE);

%>
<script language="javascript">
function goSubmit() {
	document.form1.method="post";
	document.form1.action = "req_bd_lis1.jsp";
	document.form1.submit();
}

function doRemove() {
var makerFlag = document.getElementById("MAKER_FLAG");
	
	if (makerFlag.checked == true) {
		$("#IMG_SEARCH").hide();
		
		document.getElementById("MAKER_CODE").value = '';
		document.getElementById("MAKER_NAME").value = '';
	}
	else {
		$("#IMG_SEARCH").show();
	}
}

var approval_str_value = "";
var sign_status = "P";

function Change() {
	var descriptionLoc = document.getElementById("DESCRIPTION_LOC").value;
	var remark         = document.getElementById("REMARK").value;
	var makerCode      = document.getElementById("MAKER_CODE").value;
	var makerFlag      = "N";
	
	if("" == descriptionLoc){
		 alert("품목명은 필수 입력 입니다.");
		 
		 return;
	}
	
	if("" == remark){
		alert("요청내역은 필수 입력 입니다.");
		return;
	}
	
	if(document.getElementById("MAKER_FLAG").checked){
		makerFlag = "Y";
	}
	else{
		makerFlag = "N";
	}
	
	if(makerCode != '' && makerFlag == "Y"){
		alert('메이커 선택시 해당없음 항목 체크를 해제해 주세요.');
		
		return;
	}

	if(!confirm("수정 하시겠습니까?")) {
			return;
	}
	else{
		//document.attachFrame.setData();	//startUpload
		$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/master.new_material.req_pp_upd0",
			{
				DESCRIPTION_LOC   : descriptionLoc,
		    	SPECIFICATION     : document.getElementById("SPECIFICATION").value,
		    	MAKER_FLAG        : makerFlag,
		    	MAKER_CODE        : makerCode,
		    	MAKER_NAME        : document.getElementById("MAKER_NAME").value,
		    	Z_ITEM_DESC       : document.getElementById("Z_ITEM_DESC").value,
		    	REMARK            : remark,
		    	ITEM_ABBREVIATION : document.getElementById("ITEM_ABBREVIATION").value,
		    	BASIC_UNIT        : document.getElementById("BASIC_UNIT").value,
		    	APP_TAX_CODE      : document.getElementById("APP_TAX_CODE").value,
		    	ITEM_BLOCK_FLAG   : document.getElementById("ITEM_BLOCK_FLAG").value,
		    	MODEL_FLAG        : "<%=MODEL_FLAG%>",
		    	MODEL_NO          : document.getElementById("MODEL_NO").value,
		    	ATTACH_NO         : document.getElementById("sign_attach_no").value,
		    	REQ_ITEM_NO       : document.getElementById("REQ_ITEM_NO").value,
		    	MAKE_AMT_CODE     : document.getElementById("MAKE_AMT_CODE").value,
		    	mode              : "doData"
			},
			function(arg){
				doSave(arg, "");
			}
		);
	}
}


function rMateFileAttach(att_mode, view_type, file_type, att_no) {
	var f = document.forms[0];

	f.att_mode.value   = att_mode;
	f.view_type.value  = view_type;
	f.file_type.value  = file_type;
	f.tmp_att_no.value = att_no;

	if (att_mode == "S") {
		f.method = "POST";
		f.target = "attachFrame";
		f.action = "/rMateFM/rMate_file_attach.jsp";
		f.submit();
	}
}

function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
	var attach_key   = att_no;
	var attach_count = att_cnt;

	var f = document.forms[0];
	f.ATTACH_NO.value    = attach_key;

	document.forms[0].MAKER_FLAG.value = (true == document.forms[0].MAKER_FLAG.checked)?"Y":"N";
	form1.method = "POST";
	form1.target = "childFrame";
	form1.action = "req_wk_ins2.jsp";
	form1.submit();
}

function doSave(message, v_status){
	alert(message);
	
	opener.getQuery();
	
	window.close();
}

function setAttach(attach_key, arrAttrach, attach_count) {
	var f = document.forms[0];
	
	f.ATTACH_NO.value = attach_key;
	f.ATTACH_COUNT.value = attach_count;
}

function SP9053_Popup() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0278&function=selectCode&values=<%=info.getSession("HOUSE_CODE")%>&values=M199&values=&values=/&desc=코드&desc=이름";
	//var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	CodeSearchCommon(url, 'doc', left, top, width, height);
}

function selectCode( maker_code, maker_name) {
	document.form1.MAKER_NAME.value 	= maker_name;
	document.form1.MAKER_CODE.value 	= maker_code;
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
function doOnRowSelected(rowId,cellInd){}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    }
    else if(stage==1) {
    	return false;
    }
    else if(stage==2) {
        return true;
    }
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

    if(status == "true") {
        alert(messsage);
        doQuery();
    }
    else {
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
    if(status == "0"){
    	alert(msg);
    }
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    }
    
    return true;
}
</script>
</head>
<body onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<table width="99%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td class='title_page' height="20" align="left" valign="bottom">
				<span class='location_end'>품목요청 수정</span>
			</td>
		</tr>
	</table>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>

	<form name="form1" method="post" action="">
		<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD--%>
		<input type="hidden" name="house_code" 				value="<%=info.getSession("HOUSE_CODE")%>">
		<input type="hidden" name="company_code" 			value="<%=info.getSession("COMPANY_CODE")%>">
		<input type="hidden" name="dept_code" 				value="<%=info.getSession("DEPARTMENT")%>">
		<input type="hidden" name="REQ_USER_ID" 			value="<%=info.getSession("ID")%>">
		<input type="hidden" name="doc_type" 				value="PR">
		<input type="hidden" name="fnc_name" 				value="getApproval">
		<input type="hidden" name="ctrl_dept" 				value="">
		<input type="hidden" name="ctrl_flag" 				value="">
	    <input type="hidden" name="REQ_ITEM_NO" id="REQ_ITEM_NO" 			value="<%=req_item_no%>">
		<input type="hidden" name="MATERIAL_TYPE"          	value="<%=MATERIAL_TYPE%>">
		<input type="hidden" name="MATERIAL_CTRL_TYPE"		value="<%=MATERIAL_CTRL_TYPE%>">
		<input type="hidden" name="MATERIAL_CLASS1"   		value="<%=MATERIAL_CLASS1%>">
		<input type="hidden" name="MATERIAL_CLASS2"    		value="<%=MATERIAL_CLASS2%>">
		<input type="hidden" name="PR_FLAG"                	value="">
		<input type="hidden" name="MATERIAL_CLASS2_NAME" 	value="<%=MATERIAL_CLASS2_NAME%>">
		<input type="hidden" name="BASIC_UNIT" id="BASIC_UNIT"  			value="<%=BASIC_UNIT%>">
		<input type="hidden" name="ITEM_ABBREVIATION" id="ITEM_ABBREVIATION"  		value="<%=ITEM_ABBREVIATION%>" >
		<input type="hidden" name="APP_TAX_CODE" id="APP_TAX_CODE" 			value="<%=APP_TAX_CODE%>" >
		<input type="hidden" name="ITEM_BLOCK_FLAG" id="ITEM_BLOCK_FLAG" 		value="<%=ITEM_BLOCK_FLAG%>" >
	    <input type="hidden" name="MODEL_NO" id="MODEL_NO"  				value="<%=MODEL_NO%>">
		<input type="hidden" name="ATTACH_NO" 		value="<%=ATTACH_NO%>">
	
		<input type="hidden" name="att_mode"   value="">
		<input type="hidden" name="view_type"  value="">
		<input type="hidden" name="file_type"  value="">
		<input type="hidden" name="tmp_att_no" value="">

		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목명</td>
										<td class="data_td">
                   							<input type="text" name="DESCRIPTION_LOC" id="DESCRIPTION_LOC" value="<%=DESCRIPTION_LOC%>" style="width:90%;" class="inputsubmit" maxlength="500" onKeyUp="return chkMaxByte(500, this, '품목명');">
               							</td>
            						</tr>
            						<tr>
										<td colspan="2" height="1" bgcolor="#dedede"></td>
									</tr>
            						<tr>
            							<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사양</td>
      									<td  class="data_td">
        									<input type="text" name="SPECIFICATION" id="SPECIFICATION"  value="<%=SPECIFICATION%>"  style="width:90%;" class="inputsubmit" maxlength="256" onKeyUp="return chkMaxByte(256, this, '사양');">
      									</td>
    								</tr>
    								<tr>
										<td colspan="2" height="1" bgcolor="#dedede"></td>
									</tr>
    								<tr style="display: none;">
    									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;단위결정기준</td>
										<td  class="data_td">
											<select name = "MAKE_AMT_CODE" id="MAKE_AMT_CODE" class="inputsubmit" >
												<%=make_amt_codes%>
			    							</select>
										</td>
									</tr>
									<tr style="display: none;">
										<td colspan="2" height="1" bgcolor="#dedede"></td>
									</tr>
		    						<tr style="display: none;">
		    							<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제조사</td>
										<td class="data_td">
											<input type="checkbox" name="MAKER_FLAG" id="MAKER_FLAG" <%=MAKER_FLAG%> onclick="doRemove();">해당없음
											<input type="text" name="MAKER_CODE" id="MAKER_CODE" value="<%=MAKER_CODE%>"  size="13" maxlength="10" class="inputsubmit" readOnly>
											<a href="javascript:SP9053_Popup()">
												<img src="<%=G_IMG_ICON%>" id="IMG_SEARCH" align="absmiddle" border="0">
											</a>
											<input type="text" name="MAKER_NAME" id="MAKER_NAME"   value="<%=MAKER_NAME%>"  size="20" maxlength="50" class="inputsubmit" readOnly>
										</td>
									</tr>
									<tr style="display: none;">
										<td colspan="2" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목설명</td>
										<td class="data_td">
											<textarea name="Z_ITEM_DESC" id="Z_ITEM_DESC" class="inputsubmit" style = "overflow=hidden;width: 98%;height: 95px" maxlength="3000" onKeyUp="return chkMaxByte(3000, this, '품목설명');"><%=Z_ITEM_DESC%></textarea>
										</td>
									</tr>
									<tr>
										<td colspan="2" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청내역</td>
										<td class="data_td">
											<textarea name="REMARK" id="REMARK"   style = "overflow=hidden;width: 98%;height: 95px" maxlength="500" onKeyUp="return chkMaxByte(500, this, '요청내역');"><%=REMARK%></textarea>
										</td>
									</tr>
									<tr>
										<td colspan="2" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
										<td  class="data_td">
											<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="15%">
<script language="javascript">
function setAttach(attach_key, arrAttrach, rowid, attach_count) {
	document.getElementById("sign_attach_no").value = attach_key;
	document.getElementById("sign_attach_no_count").value = attach_count;
}

btn("javascript:attach_file(document.getElementById('sign_attach_no').value, 'TEMP');", "파일등록");
</script>
													</td>
													<td>
														<input type="text" size="3" readOnly class="input_empty" value="<%=ATTACH_CNT %>" name="sign_attach_no_count" id="sign_attach_no_count"/>
														<input type="hidden" value="<%=ATTACH_NO %>" name="sign_attach_no" id="sign_attach_no">
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
			<TR>
				<TD height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
<script language="javascript">
	btn("javascript:Change('R')", "수 정");
</script>
							</TD>
							<TD>
<script language="javascript">
	btn("javascript:parent.close()", "닫 기");
</script>
							</TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>
		<br>
	</form>
	<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</s:header>
<s:footer/>
</body>
</html>