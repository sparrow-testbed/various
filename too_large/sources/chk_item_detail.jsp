<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_012");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_012";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>


<%
	int checkVal = 0;
	String title = "";
	String readOnly = "";
	String checkListItemName = "";
	
	String ret = null;
	SepoaFormater wf = null;
	SepoaOut value = null; 
	SepoaRemote ws = null;
	
	String mode = JSPUtil.CheckInjection(request.getParameter("mode"))==null?"":JSPUtil.CheckInjection(request.getParameter("mode"));
	String c_factor_refitem = JSPUtil.CheckInjection(request.getParameter("c_factor_refitem"))==null?"":JSPUtil.CheckInjection(request.getParameter("c_factor_refitem"));
	
	if(mode.equals("update") || mode.equals("view")) {
	
		String nickName= "SR_012";
		String conType = "CONNECTION";
		String MethodName = "chkUpdateChkItem";
		Object[] obj = { c_factor_refitem };
		
		try {
			
			if(mode.equals("update")) {
				ws = new SepoaRemote(nickName, conType, info);
				value = ws.lookup(MethodName,obj);
				ret = value.result[0];
				wf =  new SepoaFormater(ret);
				checkVal = wf.getRowCount();
				title = "체크리스트 항목수정";
			}
			
			MethodName = "getChkDetail";
			ws = new SepoaRemote(nickName, conType, info);
			value = ws.lookup(MethodName,obj);
			ret = value.result[0];
			wf =  new SepoaFormater(ret);
		}catch(SepoaServiceException wse) {
			Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);	
			Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
		}catch(Exception e) {
		    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
		    
		}finally{
			try{
				ws.Release();
			}catch(Exception e){}
		}
		if(checkVal > 0){
			mode = "view";	
		}
		
		if(mode.equals("view")) {
			readOnly = "readonly";
			title = "체크리스트 항목조회";
			
		}
		
		if((mode.equals("update") || mode.equals("view")) && wf != null && wf.getRowCount() > 0) {
			checkListItemName = wf.getValue("FACTOR_NAME", 0);
		}
	}else{
		title = "체크리스트 신규항목 추가";
	}
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>

<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript" src="../../global/common.js"></script>
<script language="javascript" src="../../global/vmmenu.js"></script>
<script language="javascript" src="../../jscomm/common.js"></script>
<script language="javascript" src="../../jscomm/menu.js"></script>
<script language="javascript">
	
	function addChkItem() {
		var obj = document.form1;
		
		var scale = 0;
		var itemChk;
		var itemPnt = 0;
		
		if(obj.checkListItemName.value == "") {
			alert("체크리스트 항목명을 입력해 주십시요.");
			obj.checkListItemName.focus();
			return;
		}
		
		for(var i=0; i<obj.itemName.length;i++){
			if(obj.itemName[i].value != ""){
				itemChk = true;
				obj.itemScore[i].value = 0;
				scale++;
			}
		}
		
		if(!itemChk) {
			alert("선택항목 내용을 입력하여 주십시요.");
			obj.itemName[0].focus();
			return;
		}
		
		obj.mode.value = "insert";
		obj.scale.value = scale;
		obj.action="chk_item_ins.jsp";
		obj.target="hiddenframe";
		obj.submit();
		
		
	}
	<%if(mode.equals("update")) {%>
	function updateChkItem() {
		var obj = document.form1;
		var scale = 0;
		var itemChk;
		
		if(obj.checkListItemName.value == "") {
			alert("체크리스트 항목명을 입력해 주십시요.");
			obj.checkListItemName.focus();
			return;
		}
		
		for(var i = 0; i < obj.itemName.length; i++){
			if(obj.itemName[i].value != ""){
				itemChk = true;
				obj.itemScore[i].value = 0;
				scale++;
			}
		}
		
		if(!itemChk) {
			alert("선택항목 내용을 입력하여 주십시요.");
			obj.itemName[0].focus();
			return;
		}
		
		obj.c_factor_refitem.value = <%=c_factor_refitem%>;	
		obj.mode.value = "update";
		obj.scale.value = scale;
		obj.action="chk_item_ins.jsp";
		obj.target="hiddenframe";
		obj.submit();
	}
	<%}%>
	
	function goRef(){
		opener.onRefresh(); 
		window.close();
	}
	
	function init() {
		alert('이미 사용된 항목으로 수정할수 없습니다.');
		return;
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
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
	
    
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
</script>
</head>
<BODY TOPMARGIN="0"  LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" BGCOLOR="#FFFFFF" TEXT="#000000" <%if(checkVal > 0){%>onload="javascript:init();"<%}%>>


<!--내용시작-->

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/icon/icon_ti.gif" width="12" height="12" align="absmiddle">
		&nbsp;<%=title%>
	</td>
</tr>
</table> 

<table width="98%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<form name="form1" >
	<input type="hidden" name="c_factor_refitem">
	<input type="hidden" name="scale" >
	<input type="hidden" name="mode" >


<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<%--
<tr height=15>
	<td width=100 class="c_title_1">
		<div align="left">항목타입</div>
	</td>
	<td width=120 class="c_data_1">
		<div align="left">체크리스트 항목</div>
	</td>
</tr>
--%>
<tr height=15>
	<td width="20%"  class="c_title_1"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 항목명</td>
	<td width="80%" class="c_data_1">
<%
	if(mode.equals("update") || mode.equals("view")) {
%>
		<input type="text" class="input_data2" style="width:95%" value="<%=checkListItemName%>" name="checkListItemName"  maxlength="50" <%=readOnly%>>
<%
	} else {
%>
		<input type="text" class="text" style="width:95%" value="" name="checkListItemName"  maxlength="50">
<%
	}
%>
	</td>
</tr>
</table>

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
<%
		if(mode.equals("update")) {
%>
	    	<td><script language="javascript">btn("javascript:updateChkItem()","수 정")</script></td>
<%
		} else if(!mode.equals("view")) {
%>
	    	<td><script language="javascript">btn("javascript:addChkItem()","등 록")</script></td>
<%
		}
%>
			<td><script language="javascript">btn("javascript:self.close()","닫 기")</script></td>
		</TR>
		</TABLE>
	</td>
</tr>
</table>

		<table width="98%" border="1" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
		<tr>
			<td align="center" width="20%" class="c_title_1_p_c">Scale</td>
			<td align="center" width="80%" class="c_title_1_p_c">선택항목</td>				    
		</tr>
<%
if(mode.equals("update") || mode.equals("view")) {
	for(int i=0; i < wf.getRowCount(); i++) {
%>
		<tr>					
			<td align="center" class="c_data_1_p_c"><%=wf.getValue(i, 3)%>점</td>
<%
		if(mode.equals("update")) {
%>
			<td class="c_data_1_p"><input type="text" name="itemName" class="text" style="width:95%" value="<%=wf.getValue(i, 2)%>" maxlength="30" <%=readOnly%>></td>
<%
		} else {
%>
			<td class="c_data_1_p"><input type="text" name="itemName" class="input_data1" style="width:95%" value="<%=wf.getValue(i, 2)%>" maxlength="30" <%=readOnly%>></td>
<%
		}
%>	
				<input type="hidden" name="itemScore" class="text" value="<%=wf.getValue(i, 4)%>" style="width:40" <%=readOnly%>>
		</tr>
<%
	}
%>
<%
	} else {
%>
		<tr>
			<td align="center" class="c_data_1_p_c">1점</td>
			<td class="c_data_1_p"><input type="text" name="itemName" class="text" style="width:95%" value="" maxlength="30"></td>
				<input type="hidden" name="itemScore" class="text" value="" style="width:40">
		</tr>
		<tr>
			<td align="center" class="c_data_1_p_c">2점</td>
			<td class="c_data_1_p">
				<input type="text" name="itemName" class="text" style="width:95%" value="" maxlength="30">
			</td>
			<input type="hidden" name="itemScore" class="text" value="" style="width:40">
		</tr>
		<tr>
			<td align="center" class="c_data_1_p_c">3점</td>
			<td class="c_data_1_p">
				<input type="text" name="itemName" class="text" style="width:95%" value="" maxlength="30">
			</td>
				<input type="hidden" name="itemScore" class="text" value="" style="width:40">
		</tr>
		<tr>
			<td align="center" class="c_data_1_p_c">4점</td>
			<td class="c_data_1_p">
				<input type="text" name="itemName" class="text" style="width:95%" value="" maxlength="30">
			</td>
				<input type="hidden" name="itemScore" class="text" value="" style="width:40">
		</tr>
		<tr>
			<td align="center" class="c_data_1_p_c">5점</td>
			<td class="c_data_1_p">
				<input type="text" name="itemName" class="text" style="width:95%" value="" maxlength="30">
			</td>
				<input type="hidden" name="itemScore" class="text" value="" style="width:40">
		</tr>
		<tr>
			<td align="center" class="c_data_1_p_c">6점</td>
			<td class="c_data_1_p">
				<input type="text" name="itemName" class="text" style="width:95%" value="" maxlength="30">
			</td>
				<input type="hidden" name="itemScore" class="text" value="" style="width:40">
		</tr>
		<tr>
			<td align="center" class="c_data_1_p_c">7점</td>
			<td class="c_data_1_p">
				<input type="text" name="itemName" class="text" style="width:95%" value="" maxlength="30">
			</td>
				<input type="hidden" name="itemScore" class="text" value="" style="width:40">
		</tr>
<%
	}
%>	
		</table>

<iframe name="hiddenframe" src="chk_item_ins.jsp" width="0" height="0"></iframe>
</form>


</BODY> 

</HTML>


