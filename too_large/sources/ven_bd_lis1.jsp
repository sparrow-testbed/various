<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SU_110");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SU_110";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%
/**
 *========================================================
 *Copyright(c) 2010 ICOMPIA
 *
 *@File       : ven_bd_lis1.jsp
 *
 *@FileName   : 신용평가현황
 *
 *Open Issues :
 *
 *Change history  :
 *@LastModifyDate : 2010. 06. 24
 *@LastModifier   : ICOMPIA
 *@LastVersion    : V 1.0.0
 *=========================================================
 */
 %>

<% String WISEHUB_PROCESS_ID="SU_110";%>
<%
	String house_code	= info.getSession("HOUSE_CODE"); 
	String vendor_code	= info.getSession("COMPANY_CODE"); 
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<Script language="javascript">
	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.admin.info.ven_bd_lis1";
	function setGridObj(arg) {
		GridObj = arg;
	}
	
	function init() {
		setGridObj(GridObj);
		setGridDraw();
		setHeader();
		setAlign();
		setFormat();
	}

	function setHeader() {
		//GD_setProperty(GridObj);
	}

	function setAlign() {
	}

	function setFormat() {
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
		var mode = "getVendorEvalList";
// 		GridObj.SetParam("mode"				,mode);
<%-- 		GridObj.SetParam("vendor_code"		,"<%=vendor_code%>"); --%>
// 		GridObj.SetParam("from_date"		,document.forms[0].FROM_DATE.value);
// 		GridObj.SetParam("to_date"			,document.forms[0].TO_DATE.value);
// 		GridObj.SetParam("vendor_name_loc"	,document.forms[0].VENDOR_NAME_LOC.value);
		
// 		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
// 		GridObj.SendData(servletUrl);
// 		GridObj.strHDClickAction="sortmulti";
		
		var cols_ids = "<%=grid_col_id%>";
		var params = "mode=" + mode;
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( servletUrl, params );
		GridObj.clearAll(false);
	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5)	{
		if(msg1 == "doData") {
		
		} else if(msg1 == "t_imagetext"){
		} else if(msg1 == "t_insert") {
		}
	}
	
	function from_date(year,month,day,week) {
		document.form1.FROM_DATE.value = year+month+day;
	}

	function to_date(year,month,day,week) {
		document.form1.TO_DATE.value = year+month+day;
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
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		//GridCellClick(strColumnKey,nRow)

    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
}

function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    
    return false;
}

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

    if(status == "0") alert(msg);
    
    document.form1.FROM_DATE.value = add_Slash( document.form1.FROM_DATE.value );
    document.form1.TO_DATE.value   = add_Slash( document.form1.TO_DATE.value   );
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">

<s:header>
<form name="form1" >
<%@ include file="/include/sepoa_milestone.jsp"%>
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
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기간</td>
	<td width="35%" class="data_td">
		<s:calendar id="FROM_DATE" default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1) )%>" format="%Y/%m/%d"/>
		~
		<s:calendar id="TO_DATE" default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.getShortDateString() )%>" format="%Y/%m/%d"/>
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체명</td>
	<td width="35%" class="data_td">
		<input type="text" name="VENDOR_NAME_LOC" size="30" class="inputsubmit" value=''>
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
			<TABLE cellpadding="0">
			<TR>
				<TD><script language="javascript">btn("javascript:doSelect()","조회")</script></TD>
			</TR>
			</TABLE>
		</td>
	</tr>
</table>

</form>
<!-- <iframe name = "work_frame" src=""  width="0" height="0" border="no" frameborder="no"></iframe> -->

</s:header>
<s:grid screen_id="SU_110" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


