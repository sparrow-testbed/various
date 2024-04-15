<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_014");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_014";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>


<%
	String ret = null;
	int checkVal = 0;
	String title = "";
	String readOnly = "";
	
	SepoaFormater wf = null;	
	SepoaOut value = null; 
	SepoaRemote ws = null;	
	
	String mode = JSPUtil.CheckInjection(request.getParameter("mode"))==null?"insert":JSPUtil.CheckInjection(request.getParameter("mode"));
	String c_template_refitem = JSPUtil.CheckInjection(request.getParameter("c_template_refitem"))==null?"":JSPUtil.CheckInjection(request.getParameter("c_template_refitem"));
	
	String nickName= "SR_014";
	String conType = "CONNECTION";
	String MethodName = "";
	Object[] obj = { };
	
	if(mode.equals("insert")) {	
	
		MethodName = "getChkTempFactorList";
		title = "체크리스트 신규템플릿 추가";
		
	}else if(mode.equals("update") || mode.equals("view")) {
		
		MethodName = "getTempDetail";
		obj = new Object[1];
		obj[0] = c_template_refitem;
		
	}	
	
	try {
				
		if(mode.equals("update")) {
		
			MethodName = "chkUpdateChkTemp";
			ws = new SepoaRemote(nickName, conType, info);
			value = ws.lookup(MethodName,obj);
			ret = value.result[0];
			wf =  new SepoaFormater(ret);
			checkVal = wf.getRowCount();
			MethodName = "getChkTemp";
			title = "체크리스트 템플릿 수정";
			
		}
				
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
	
	if(checkVal > 0) {
		mode = "view";
	}
	
	if(mode.equals("view")) {
		readOnly = "readonly";
		title = "체크리스트 템플릿 조회";
	}
	
	String chkTempName = "";
	if(mode.equals("update") && mode.equals("view") && wf != null && wf.getRowCount() > 0) {
		chkTempName = wf.getValue("TEMPLATE_NAME", 0);
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
		
		var factor_param = "";
		var sel_param = "";
		var tempChk;
		
		if(obj.chkTempName.value == "") {
			alert("체크리스트 템플릿명을 입력해 주십시요.");
			obj.chkTempName.focus();
			return;
		}
		
		if(obj.require_score.value == "") {
			alert("템플릿 기준점수를 입력해 주십시요.");
			obj.require_score.focus();
			return;
		}
		
		var pnt = parseInt(obj.require_score.value);
		if(pnt > 7 || pnt < 1) {
			alert("템플릿 기준점수범위는 1 ~ 7점 사이입니다.");
			obj.require_score.focus();
			return;
		}
		
		if(obj.factor_chk.length == null){
			if(obj.factor_chk.checked){
				tempChk = true;
				factor_param = factor_param + "," + obj.factor_num.value;
			}		
		}else {
			for(var i=0; i<obj.factor_chk.length;i++){
				if(obj.factor_chk[i].checked){
					tempChk = true;
					factor_param = factor_param + "," + obj.factor_num[i].value;
				}
			}
		}
		

		if(!tempChk) {
			alert("템플릿에 저장될 항목을 체크해주세요.");
			return;
		}

		factor_param = factor_param.substring(1);

		obj.factor_param.value = factor_param;
		
		obj.mode.value = "insert";
		obj.action="chk_template_ins.jsp";
		obj.target="hiddenframe";
		obj.submit();
		
	}
	<%if(mode.equals("update")) {%>
	function updateChkItem() {
		var obj = document.form1;
		var factor_param = "";
		
		if(obj.chkTempName.value == "") {
			alert("체크리스트 템플릿명을 입력해 주십시요.");
			obj.chkTempName.focus();
			return;
		}
		if(obj.require_score.value == "") {
			alert("템플릿 기준점수를 입력해 주십시요.");
			obj.require_score.focus();
			return;
		}
		
		var pnt = parseInt(obj.require_score.value);
		if(pnt > 7 || pnt < 1) {
			alert("템플릿 기준점수범위는 1 ~ 7점 사이입니다.");
			obj.require_score.focus();
			return;
		}
				
		obj.c_template_refitem.value = <%=c_template_refitem%>;			
		obj.mode.value = "update";
		obj.action="chk_template_ins.jsp";
		obj.target="hiddenframe";
		obj.submit();
	}
	<%}%>
	
	function goRef(){
		opener.onRefresh(); 
		window.close();
	}
	
	function init() {
		alert('이미 사용된 템플릿으로 수정할수 없습니다.');
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
	<input type="hidden" name="c_template_refitem">
	<input type="hidden" name="factor_param" >
	<input type="hidden" name="mode" >
    
	<script language="javascript">rdtable_top1()</script>
	<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
	<tr>
		<td width="15%" class="c_title_1"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 템플릿명</td>
<%
	if(mode.equals("update") || mode.equals("view")) {
%>
		<td width="35%" class="c_data_1">
<%
		if(mode.equals("update")) {
%>
			<input type="text" class="text" style="width:95%" value="<%=wf.getValue(0, 5)%>" name="chkTempName"  maxlength="50" <%=readOnly%>>
<%
		} else {
%>
			<input type="text" class="input_data2" style="width:95%" value="<%=wf.getValue(0, 5)%>" name="chkTempName"  maxlength="50" <%=readOnly%>>
<%
		}
%>
		</td>
		<td width="15%" class="c_title_1"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 기준점수</td>
		<td width="35%" class="c_data_1">
<%
		if(mode.equals("update")) {
%>
			<input type="text" class="text" style="width:95%" name="require_score"  maxlength="50" value="<%=wf.getValue(0, 6)%>"<%=readOnly%>>
<%
		} else {
%>
			<input type="text" class="input_data2" style="width:95%" name="require_score"  maxlength="50" value="<%=wf.getValue(0, 6)%>"<%=readOnly%>>
<%
		}
%>
		</td>
<%
	} else {
%>
		<td width="35%" class="c_data_1">
			<input type="text" class="text" style="width:95%" value="" name="chkTempName"  maxlength="50">
		</td>
		<td width="15%" class="c_title_1">기준점수</td>
		<td width="35%" class="c_data_1">
			<input type="text" class="text" style="width:95%" name="require_score"  maxlength="50">
		</td>
<%
	}
%>
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
 
	<TABLE width="98%" border="1" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
	<TR> 
		<TD width="5%"  class="c_title_1_p_c"  align="center" ></TD>
		<TD width="32%" class="c_title_1_p_c"  align="center" >항목내용</TD>
		<TD width="9%"  class="c_title_1_p_c"  align="center" >1</TD>
		<TD width="9%"  class="c_title_1_p_c"  align="center" >2</TD>
		<TD width="9%"  class="c_title_1_p_c"  align="center" >3</TD>
		<TD width="9%"  class="c_title_1_p_c"  align="center" >4</TD>
		<TD width="9%"  class="c_title_1_p_c"  align="center" >5</TD>
		<TD width="9%"  class="c_title_1_p_c"  align="center" >6</TD>
		<TD width="9%"  class="c_title_1_p_c"  align="center" >7</TD>
	</TR>		
<%
	for(int i=0; i < wf.getRowCount(); i++) {
		int c_factor_ref = Integer.parseInt(wf.getValue(i, 0));
%>
	<TR>
		<TD class="c_data_1_p_c" align="center"><input type="checkbox" name="factor_chk" <%if(!mode.equals("insert")) {%> disabled  <%}%>>
			<input type="hidden" name="factor_num" value="<%=c_factor_ref%>">
		</TD>
		<TD class="c_data_1_p_c"  align="left"><%=wf.getValue(i, 1)%></TD>
<%
		for(int j=0; j < 7; j++){
			if(j == 0) {
%>
				<TD class="c_data_1_p_c"  align="center"><%=wf.getValue(i, 3)%></TD>
<%
			} else {
				int front = -1;
				if (i < wf.getRowCount() - 1) {
					front = Integer.parseInt(wf.getValue(i+1, 0));
				}
				
				if (c_factor_ref == front) {
					i++;
%>
					<TD class="c_data_1_p_c" align="center"><%=wf.getValue(i, 3)%></TD>
<%
				} else {
%>
					<TD class="c_data_1_p_c" align="center">&nbsp;</TD>
<%
				}
			}
		}
%>
	</TR>
<%
	}
%>    
	</TABLE>

<iframe name="hiddenframe" src="chk_template_ins.jsp" width="0" height="0"></iframe>
</form>

</BODY> 

</HTML>


