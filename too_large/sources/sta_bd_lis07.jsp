<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("ST_010");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "ST_010";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="ST_010";%>
<%
/**
 *========================================================
 *Copyright(c) 2010 ICOMPIA
 *
 *@File       : sta_bd_lis07.jsp
 *
 *@FileName   : 占썩����占썲����占쏙옙占썲��몌옙占쏙옙占쎌������ *
 *Open Issues :
 *
 *Change history  :
 *@LastModifyDate : 2010. 06. 02
 *@LastModifier   : ICOMPIA
 *@LastVersion    : V 1.0.0
 *=========================================================
 */
 %>
<%@ page contentType="text/html; charset=euc-kr" %>
<%@ include file="/include/wisehub_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/wisehub_scripts.jsp"%>
<%@ include file="/include/wisehub_session.jsp"%>
<%@include file="/include/wisetable_scripts.jsp" %>

<%
	String house_code   = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%/*WiseGrid��������옙��옙 ������占쏙옙�몄���옙���������占쎈���옙占쎌���������������*/%>
<script language="javascript" src="/include/wisegrid_setting.js"></script>

<%/* WiseGrid�띰옙���占쎌���������� ���占썸������옙%>




<Script language="javascript">
<!--
	var G_HOUSE_CODE   = "<%=house_code%>";
	var G_COMPANY_CODE = "<%=company_code%>";
	var GridObj = null;

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
		
		GridObj.bHDMoving 			= false 
		GridObj.bHDSwapping 			= false 
		GridObj.strRowBorderStyle 	= 'none' 
		GridObj.nRowSpacing 			= 0 
		GridObj.strHDClickAction 		= 'select' 
		GridObj.bRowSelectorVisible 	= false
	

	}

	function setAlign() {
	}

	function setFormat() {
		GridObj.SetNumberFormat("ITEM_AMT"			,G_format_amt);
	}

	function EndGridQuery() {
		var status = GridObj.GetStatus();
		var mode   = GridObj.GetParam("mode");
		
		if(mode == "getStaProCustomerList"){
			GridObj.AddSummaryBar('SUMMARY1', '���占썲�占� 'summaryall', 'sum', 'ITEM_AMT');
			GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
		}
		if (GridObj.GetStatus() == "false" ){
			alert(GridObj.GetMessage());
			return;
		}
	}

	function doSelect() {
		var from_date   		= document.form1.FROM_DATE.value;
		var to_date     		= document.form1.TO_DATE.value;
		var cust_code     		= document.form1.CUST_CODE.value;
		var subject			    = document.form1.SUBJECT.value;
		var material_type		= document.form1.MATERIAL_TYPE.value;
		var material_ctrl_type  = document.form1.MATERIAL_CTRL_TYPE.value;
		var material_class1     = document.form1.MATERIAL_CLASS1.value;
		var description_loc		= document.form1.DESCRIPTION_LOC.value;

		if(LRTrim(from_date) == "" || LRTrim(to_date) == "") {
			alert("�リ옇占썲���������������������������옙紐�������);
			return;
		}

		if(!checkDateCommon(from_date)) {
			alert("�브�占썲��몃Ь�⑨옙���������������占쎄���옙占쎌�������占썲����������占�;
			document.form1.FROM_DATE.focus();
			return;
		}

		if(!checkDateCommon(to_date)) {
			alert("�브�占썲��몃Ь�⑨옙������占썬�������占쎄���옙占쎌�������占썲����������占�;
			document.form1.TO_DATE.focus();
			return;
		}

		var servlet_url ="/servlets/statistics.sta_bd_lis07";

		GridObj.SetParam("mode", 				"getStaProCustomerList");
		GridObj.SetParam("from_date",			from_date);
		GridObj.SetParam("to_date",				to_date);
		GridObj.SetParam("cust_code",			cust_code);
		GridObj.SetParam("subject",				subject);
		GridObj.SetParam("material_type",		material_type);
		GridObj.SetParam("material_ctrl_type",	material_ctrl_type);
		GridObj.SetParam("material_class1",		material_class1);
		GridObj.SetParam("description_loc",		description_loc);

		GridObj.DoQuery(servlet_url, null, true, false);
	}

	function from_date(year,month,day,week) {
		document.form1.FROM_DATE.value = year+month+day;
	}

	function to_date(year,month,day,week) {
		document.form1.TO_DATE.value = year+month+day;
	}

	function searchCust() {
		url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0120F&function=scms_getCust&values=&values=/&desc=占썩�������占썲������옙esc=占썩�������占썲�占�
		Code_Search(url,'','','','','');
	}

	function scms_getCust(code, text, div) {  
		document.form1.CUST_TYPE.value = div;
		document.form1.CUST_CODE.value = code;
		document.form1.CUST_NAME.value = text;
	}

	function MATERIAL_TYPE_Changed() {
    	clearMATERIAL_CTRL_TYPE();
    	clearMATERIAL_CLASS1();

    	setMATERIAL_CLASS1("������占� "");

    	var id = "SL0009";
   		var code = "M041";
    	var value = form1.MATERIAL_TYPE.value;
    	target = "MATERIAL_TYPE";
    	data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    	work_frame.location.href = data;
	}
	
	function MATERIAL_CTRL_TYPE_Changed() {
		clearMATERIAL_CLASS1();

		var id = "SL0019";
		var code = "M042";
		var value = form1.MATERIAL_CTRL_TYPE.value;
		target = "MATERIAL_CTRL_TYPE";
		data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
		work_frame.location.href = data;
	}

	function setMATERIAL_CTRL_TYPE(name, value) {
		var option1 = new Option(name, value, true);
		form1.MATERIAL_CTRL_TYPE.options[form1.MATERIAL_CTRL_TYPE.length] = option1;
	}

	function setMATERIAL_CLASS1(name, value) {
		var option1 = new Option(name, value, true);
		form1.MATERIAL_CLASS1.options[form1.MATERIAL_CLASS1.length] = option1;
	}

	function clearMATERIAL_CTRL_TYPE() {
		if(form1.MATERIAL_CTRL_TYPE.length > 0) {
			for(i=form1.MATERIAL_CTRL_TYPE.length-1; i>=0;  i--) {
				form1.MATERIAL_CTRL_TYPE.options[i] = null;
			}
		}
	}

	function clearMATERIAL_CLASS1() {
		if(form1.MATERIAL_CLASS1.length > 0) {
			for(i=form1.MATERIAL_CLASS1.length-1; i>=0;  i--) {
				form1.MATERIAL_CLASS1.options[i] = null;
			}
		}
	}
	
	function setCal(div){
		var startDay = "<%=SepoaDate.getShortDateString()%>";
		var endDay = "";
		var curStartDay = document.form1.FROM_DATE.value;
		var setDay = "";
		
		var curYear = curStartDay.substring(0,4);
		
		var february = ((0 == curYear % 4) && (0 != (curYear % 100))) || (0 == curYear % 400) ? 29 : 28;
		var arrLastDate = new Array(31, february, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);//���占썲���������嶺�옙�����옙�����		
		var lastdate = arrLastDate[parseInt(curStartDay.substring(4,6),10)-1];
		
		if(div == 'y'){
			setDay = curStartDay.substring(0,4)+"0101";
			endDay = curStartDay.substring(0,4)+"1231";
		}else if(div == 'q'){
			var mon = curStartDay.substring(4,6);
			if(parseInt(mon,10) < 7){
				setDay = curStartDay.substring(0,4)+"0101";
				endDay = curStartDay.substring(0,4)+"0630";
			}else{
				setDay = curStartDay.substring(0,4)+"0701";
				endDay = curStartDay.substring(0,4)+"1231";
			}
		}else if(div == 'm'){
			setDay = curStartDay.substring(0,6)+"01";
			endDay = curStartDay.substring(0,6)+lastdate;
		}
		document.form1.FROM_DATE.value = setDay;
		document.form1.TO_DATE.value = endDay;
	}

//-->
</script>


<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid�����SP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox�����SP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// ��갭占쏙옙占쎌������옙占쏙옙 ���占썸���������������������옙��옙���占썲������옙rowId �����������옙ID���占쏙옙 cellInd �띰옙���占쏙옙占쏙옙�����占썲�������占썲����嶺�옙��/ ���占썸�����������⑼옙�����옙占쏙옙���占쎌�占썩���������������� 嶺����옙占쎌��������э옙占쏙옙GridObj.getColIndexById("selected") == cellInd ���占썲��뀐옙�������⑼옙��������옙�����옙紐�������function doOnRowSelected(rowId,cellInd)
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

// ��갭占쏙옙占쎌�������占�angeEvent ���������������占쎌� ���占썲������옙// stage = 0 �������������� 1 = ���������占쏙옙��������옙 2 = ������������������ true ������������������������������占�alse ��������������옙占쎌��띰옙����몄�������������占썲������옙function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 �������������� 1 = ���������占쏙옙��������옙 2 = ������������������ true ������������������������������占�alse ��������������옙占쎌��띰옙����몄�������������占썲������옙    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    
    return false;
}

// �������뱄옙占쎄낀����쎌����占썲�����⑨옙��������占썹�占쎌�������占썹�占쎌�������占썹�節��占쏙옙占썬���������������占썲�占썲������옙���占썸������������������// �������뱄옙占쎄낀������message, status, mode �띰옙���占썲�����������э옙 �띰옙���占썲���옙�����옙�������
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

// ������占썲������������������������占썲����������占썲������������� �곤옙占썲�����������낀������占쏙옙萸ｅ���옙��옙doExcelUpload ���占썲������������������/ �곤옙占썲����������占쎌����占썲�占썲�諛몌옙占쏙옙������ Load ���占썲������옙// !!!! ���占쎌�,���������占쏙옙���������占쎌�占쎄�����э옙�������쏙옙��������옙�����������������옙占쎄�占쏙옙占쎌������������옙�����옙占썰벧占쎌���������옙���������������占�ExcelUpload ���占썲������������� ��옙���占�function doExcelUpload() {
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
    // Wise��갭占쏙옙占쎌������������옙���占썲��쇽옙���������status�������������옙���������.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="init();;GD_setProperty(document.WiseGrid);" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">

<s:header>
<!--���占썲���������->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		<%@ include file="/include/sepoa_milestone.jsp" %>
	</td>
</tr>
</table> 

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<form name="form1">
<tr>
	<td width="10%" class="c_title_1">
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> �リ옇占썲�占�</td>
	<td width="40%" class="c_data_1">
	<TABLE cellpadding="0">
		<TR>
			<td>
				<input type="text" name="FROM_DATE" size="10" maxlength="8" class="input_re" value='<%=SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1)%>'>
<!-- 				<a href="javascript:Calendar_Open('from_date');"><img src="../../images/button/butt_calender.gif"  width="22" height="19" align="absmiddle" border="0" alt=""></a> -->
				~
				<input type="text" name="TO_DATE" size="10" maxlength="8" class="input_re" value='<%=SepoaDate.getShortDateString()%>'>
<!-- 				<a href="javascript:Calendar_Open('to_date');"><img src="../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0" alt=""></a> -->
			</td>
			<TD><script language="javascript">btn("javascript:setCal('y')",2,"�����    </script></TD>
			<TD><script language="javascript">btn("javascript:setCal('q')",2,"��옙���占�    </script></TD>
			<TD><script language="javascript">btn("javascript:setCal('m')",2,"�����    </script></TD>
		</TR>
	</TABLE>
	</td>
	<td width="15%" class="c_title_1">
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 占썩���������옙</td>
	<td width="35%" class="c_data_1">
		<input type="hidden" name="CUST_TYPE">
		<input type="text" name="CUST_CODE" size="10" class="inputsubmit" value='' >
		<a href="javascript:searchCust();"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" ></a>
		<input type="text" name="CUST_NAME" size="26" class="input_data2" value='' style="border:0" readonly>
	</td>
</tr>
<tr>
	<td width="15%" class="c_title_1">
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ��옙���占쏙옙��옙</td>
	<td width="35%" class="c_data_1">
		<input type="text" name="SUBJECT" size="30" class="inputsubmit" value=''>
	</td>
	<td width="15%" class="c_title_1">
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> �������뱄옙��옙</td>
	<td width="35%" class="c_data_1">
        <select name="MATERIAL_TYPE" class="inputsubmit" onChange="javacsript:MATERIAL_TYPE_Changed();">
        <option value="">������占�option>
        <%
        String listbox1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M040", "");
        out.println(listbox1);
        %>
        </select>
	</td>
</tr>
<tr>
	<td width="15%" class="c_title_1">
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 繞�우����占썲�占�/td>
	<td width="35%" class="c_data_1">
        <select name="MATERIAL_CTRL_TYPE" class="inputsubmit" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();">
        <option value=''>������占�option>
        </select>
	</td>
	<td width="15%" class="c_title_1">
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> �������뱄옙��옙</td>
	<td width="35%" class="c_data_1">
        <select name="MATERIAL_CLASS1" class="inputsubmit">
        <option value=''>������占�option>
        </select>
	</td>
</tr>
<tr>
	<td width="15%" class="c_title_1">
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> �����옙占쏙옙��옙</td>
	<td width="35%" class="c_data_1" colspan="3">
		<input type="text" name="DESCRIPTION_LOC" size="30" class="inputsubmit" value=''>
	</td>
</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                                                              
<tr>                                                                                                                                                                                    
	<td height="30" align="right">                                                                                                                                            
		<TABLE cellpadding="0">                                                                                                                                                   
		<TR>	                                                                                                                                                                              
			<TD><script language="javascript">btn("javascript:doSelect()",2,"�브�占썲�占�</script></TD>
		</TR>                                                                                                                                                                               
		</TABLE>                                                                                                                                                                              
	</td>
</tr>
</table>                                                                                                                                                                                 

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td height="1" class="cell"></td>
	<!-- wisegrid ������占�ar -->
</tr>
<tr>
	<td>
	</td>
</tr>
</table>

</form>
<iframe name = "work_frame" src=""  width="0" height="0" border="no" frameborder="no"></iframe>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>

</s:header>
<s:grid screen_id="ST_010" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>



