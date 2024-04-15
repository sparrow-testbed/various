<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_020");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_020";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>



<%

	int checkVal = 0;
	String ret = null;
	String title = "";
	int template_type = 0;
	
	SepoaFormater wf = null;	
	SepoaOut value = null; 
	SepoaRemote ws = null;	
	
	String e_template_refitem = JSPUtil.nullToEmpty(request.getParameter("e_template_refitem"));
	
	String nickName= "SR_020";
	String conType = "CONNECTION";
	String MethodName = "getEvaTempDetail";
	Object[] obj = { e_template_refitem };
	
	try {
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

	
	String evaTempName = "";
	if(wf != null && wf.getRowCount() > 0) {
		evaTempName = wf.getValue(0, 9);
		template_type = Integer.parseInt(wf.getValue(0, 12));
	}
	
	
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
	
	<script language="javascript" src="../../global/common.js"></script>
	<script language="javascript" src="../../global/vmmenu.js"></script>
	<script language="javascript" src="../../jscomm/common.js"></script>
	<script language="javascript" src="../../jscomm/menu.js"></script>

                

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>

<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>


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
<body onload="" TOPMARGIN="0"  LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" BGCOLOR="#FFFFFF" TEXT="#000000">


<!--내용시작-->

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/icon/icon_ti.gif" width="12" height="12" align="absmiddle">
		&nbsp;템플릿조회
	</td>
</tr>
</table> 

<table width="98%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<form name="form1" > 
	<input type="hidden" name="e_template_refitem" id="e_template_refitem">
	<input type="hidden" name="factor_param" >
	<input type="hidden" name="mode" >
	<input type="hidden" name="weight_param" >
			        
<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr>
	<td width="10%" class="c_title_1"><div align="left"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 항목명</div></td>
	<td width="35%" class="c_data_1" colspan="3">
		<input type="text" class="input_data0" style="width:250" value="<%=evaTempName%>" name="evaTempName"  maxlength="50" readonly >
	</td>
</tr>
<tr style="display:none;">
	<td width="10%" class="c_title_1"><div align="left"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 항목타입</div></td>
	<td width="35%" class="c_data_1" colspan="3">
		<input type="radio" name="template_type_chk" value="1" <%if(template_type == 1){%>checked<%}%> disabled > 일반&nbsp;&nbsp;
		<input type="radio" name="template_type_chk" value="2" <%if(template_type == 2){%>checked<%}%> disabled > 공동
	</td>
</tr>
</table>

<br>
<TABLE width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<TR class="c_title_1"> 
	<TD width=240 class=head align="center" >항목내용</TD>
	<TD width=80  class=head  align="center" >1</TD>
	<TD width=80  class=head  align="center" >2</TD>
	<TD width=80  class=head  align="center" >3</TD>
	<TD width=80  class=head  align="center" >4</TD>
	<TD width=80  class=head  align="center" >5</TD>
	<TD width=80  class=head  align="center" >가중치</TD>
</TR>
<%
	int i=0;
	int scale = 0;
	
	for(; i < wf.getRowCount(); i++) {
		try{
			scale = Integer.parseInt(wf.getValue(i, 5));
		}catch(Exception e) {
			scale = 5;
		}
		
		int e_factor_ref = Integer.parseInt(wf.getValue(i, 0));
		String qnt = wf.getValue(i, 6);
		//if(qnt.equals("Y")) {
		//	break;
		//}
%>
<TR>
	<TD class="c_data_1"  align="center"><%=wf.getValue(i, 1)%></TD>
<%
		for(int j=0; j < 5; j++){
		String temp_value = scale<=j ? "-" : wf.getValue(i + j, 3);
			
%>	
			<TD class="c_data_1"  align="center"><%=temp_value%></TD>
<%
		}

		i = i + (scale-1);
%>
	<TD class="c_data_1"  align="center">
		<input type="text" name="weight" value="<%=wf.getValue(i, 10)%>" class="text" style="width:30px" readonly >%
	</TD>
</TR>
<%
	}

	//정량평가항목
	for(; i < wf.getRowCount(); i++) {
		scale = 5;
		int e_factor_ref = Integer.parseInt(wf.getValue(i, 0));
%>
<TR>
	<TD class="c_data_1"  width="240" align="center">
		<%=wf.getValue(i, 1)%>
		<input type="hidden" name="factor_num" value="<%=e_factor_ref%>">
	</TD>
	<TD class="c_data_1"  align="center"><%=wf.getValue(i, 7)%></TD>
<%
		for(int j=0; j < scale; j++){
%>	
			<TD class="c_data_1"  width="57" align="center">-</TD>
<%
		}
%>
	<TD class="c_data_1"  width="80" align="center">
		<input type="text"  name="weight" value="<%=wf.getValue(i, 10)%>" class="text" style="width:40" readonly >%
	</TD>
</TR>
<%
	}
%> 
</TABLE>

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30">
		<TABLE cellpadding="0" align="right">
		<TR>
			<TD><script language="javascript">btn("javascript:self.close()","닫 기")  </script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table>

</form>	

<iframe name="hiddenframe" src="" width="0" height="0"></iframe>


</BODY> 

</HTML>


