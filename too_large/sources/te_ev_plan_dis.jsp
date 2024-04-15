<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("EV_007_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "EV_007_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String WISEHUB_PROCESS_ID="EV_007_1";
    String USER_ID      = info.getSession("ID");
    String HOUSE_CODE   = info.getSession("HOUSE_CODE") ;
    String USER_TYPE	= info.getSession("USER_TYPE") ;

	String ETPL_NO        = JSPUtil.nullToEmpty(request.getParameter("etpl_no"));
    
	String EVAL_YY                 	= "";
	String ETPL_NM                 	= "";
	String ADD_USER_ID             	= "";
	String ADD_USER_NAME_LOC       	= "";
	String ADD_DATE                	= "";
	String CHANGE_USER_ID          	= "";
	String CHANGE_USER_NAME_LOC    	= "";
	String CHANGE_DATE             	= "";
	String IMPL_USER_ID            	= "";
	String IMPL_USER_NAME_LOC      	= "";
	String IMPL_DATE               	= "";
	String END_USER_ID             	= "";
	String END_USER_NAME_LOC       	= "";
	String END_DATE                	= "";
	String STATUS                  	= "";
	String STATUS_TXT		  	    = "";
	String PRG_STS                 	= "";
	String PRG_STS_TXT	      	    = "";
	
	
	Map<String, String> svcParam = new HashMap<String, String>();
	
	svcParam.put("house_code", HOUSE_CODE);
	svcParam.put("etpl_no", ETPL_NO);
	
	Object[] args = {svcParam};
    SepoaOut value = ServiceConnector.doService(info, "EV_002", "CONNECTION","getEtplOne", args);

    SepoaFormater wf = new SepoaFormater(value.result[0]);
    int iRowCount = wf.getRowCount();
    
    if(iRowCount>0)
    {
    	EVAL_YY             	= wf.getValue("EVAL_YY",0);
    	ETPL_NM             	= wf.getValue("ETPL_NM",0);
    	ADD_USER_ID         	= wf.getValue("ADD_USER_ID",0);
    	ADD_USER_NAME_LOC   	= wf.getValue("ADD_USER_NAME_LOC",0);
    	ADD_DATE            	= wf.getValue("ADD_DATE",0);
    	CHANGE_USER_ID      	= wf.getValue("CHANGE_USER_ID",0);
    	CHANGE_USER_NAME_LOC	= wf.getValue("CHANGE_USER_NAME_LOC",0);
    	CHANGE_DATE         	= wf.getValue("CHANGE_DATE",0);
    	IMPL_USER_ID        	= wf.getValue("IMPL_USER_ID",0);
    	IMPL_USER_NAME_LOC  	= wf.getValue("IMPL_USER_NAME_LOC",0);
    	IMPL_DATE           	= wf.getValue("IMPL_DATE",0);
    	END_USER_ID         	= wf.getValue("END_USER_ID",0);
    	END_USER_NAME_LOC   	= wf.getValue("END_USER_NAME_LOC",0);
    	END_DATE            	= wf.getValue("END_DATE",0);
    	STATUS              	= wf.getValue("STATUS",0);
    	STATUS_TXT		  	    = wf.getValue("STATUS_TXT	  ",0);
    	PRG_STS             	= wf.getValue("PRG_STS",0);
    	PRG_STS_TXT	      	    = wf.getValue("PRG_STS_TXT",0);
    }
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>
<Script language="javascript" type="text/javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.te_ev_wait_list";
var G_CUR_ROW;//팝업 관련해서 씀..

function init(){
	setGridDraw();
	setHeader();
}

function setHeader(){
	GridObj.strHDClickAction="select";
	doSelect();
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

function getSearchParam(){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var params     = "";
	
	inputParam = "etpl_no=<%=ETPL_NO%>";
	inputParam = inputParam + "&prProceedingFlag=";
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=getEtplDtList2";
	params = params + "&cols_ids=<%=grid_col_id%>";
	params = params + dataOutput();
	
	body.removeChild(form);
	
	return params;
}

function doSelect(){
	var params = getSearchParam();
	GridObj.post( G_SERVLETURL, params );
	
	GridObj.clearAll(false);
}


function JavaCall(msg1, msg2, msg3, msg4, msg5){
	var wise = GridObj;
	var f = document.forms[0];

	if(msg1 == "t_imagetext"){
		
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
	if(msg1 == "doQuery"){
    	
    	
		//if(summaryCnt == 0) {
		//	GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'PR_QTY,PR_AMT');
		//	GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
		//	summaryCnt++;
		//}
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
	var header_name = GridObj.getColumnId(cellInd);
	var url = '';
	var param = '';
	
	if( header_name == "ES_CD" ) {
		var url = "/kr/ev/ts_sheet_view.jsp";
		var param = "";
		param += "?popup_flag_header=true";
		param += "&es_cd="+SepoaGridGetCellValueId(GridObj, rowId, "ES_CD");
		param += "&es_ver="+SepoaGridGetCellValueId(GridObj, rowId, "ES_VER");
		PopupGeneral(url+param, "평가표", "", "", "925", "800");
	}   
}

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
        doSelect();
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
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" align="center" vAlign="bottom" style="font-weight:bold;font-size:22px;">
			기술평가계획
		</td>
	</tr>
	</table>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form1" action="">
	 	<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">									
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기술평가계획번호</td>
										<td width="35%" class="data_td" ><%=ETPL_NO%></td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기술평가계획명</td>
										<td width="35%" class="data_td" ><%=ETPL_NM%></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;평가년도</td>
										<td width="35%" class="data_td" ><%=EVAL_YY%></td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;진행상태</td>
										<td width="35%" class="data_td" ><%=PRG_STS_TXT%></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;평가실시자</td>
										<td width="35%" class="data_td" ><%=IMPL_USER_NAME_LOC%> (<%=IMPL_USER_ID%>)</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;평가실시일</td>
										<td width="35%" class="data_td" ><%=IMPL_DATE%></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;평가마감자</td>
										<td width="35%" class="data_td" ><%=END_USER_NAME_LOC%> (<%=END_USER_ID%>)</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;평가마감일</td>
										<td width="35%" class="data_td" ><%=END_DATE%></td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<table width="99%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5">&nbsp;</td>
			</tr>
		</table>
	</table>
	</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="EV_007_1" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>