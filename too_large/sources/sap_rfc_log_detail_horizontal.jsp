<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%!
	public String convertDate(String dataData){
		String convert_year="";
		String convert_month ="";
		String convert_day="";
		if(dataData != null && dataData.length() ==8){
			convert_year = dataData.substring(0,4);
			convert_month = dataData.substring(4,6);
			convert_day = dataData.substring(6,8);
			dataData = convert_year+"/"+convert_month+"/"+convert_day;
		}
		return dataData;
	}

	public String convertTime(String dataData){
		String convert_hh="";
		String convert_mm ="";
		String convert_ss="";
		if(dataData != null && dataData.length() ==6){
			convert_hh = dataData.substring(0,2);
			convert_mm = dataData.substring(2,4);
			convert_ss = dataData.substring(4,6);
			dataData = convert_hh+":"+convert_mm+":"+convert_ss;
		}
		return dataData;
	}
 %>
<%
	String if_number = JSPUtil.nullToEmpty(request.getParameter("if_number"));
    Object[] obj = {if_number};
    SepoaOut value = ServiceConnector.doService(info, "AD_137", "CONNECTION", "getInterfaceInfoDetail", obj);
	SepoaFormater sf = new SepoaFormater(value.result[0]);
 %>
<html>
<head>



<style type="text/css">
td{font-size:10px}
.style1 {
	font-size: 14px;
	font-weight: bold;
}
.style2 {
	font-size: 12px;
	color: red;
}
</style>
</head>

<body style="font-family:verdana,tahoma;">
<s:header popup="true">
<TABLE border="1" cellpadding="5" cellspacing="0" bordercolorlight="158cb5" bordercolordark="ffffff">
<TR>
	<TD align="left">
   <table width="100%" border="0" cellpadding="0" cellspacing="0">

   <tr>
      <td height="5" bgcolor="DEE2E3"></td>
   </tr>
   <tr>
      <td height="60" colspan="2" align="left"><b style="font-size:16px;">SAP R/3 RFC Log</b></td>
   </tr>
   </table>

   <span class="style1"><img src="../images/blt_srch.gif" width="7" height="7" hspace="5" align="absmiddle"> RFC General Information</span><br>
   <br>
   <table border="1" cellpadding="2" cellspacing="0" bordercolor="158cb5" bordercolorlight="158cb5" bordercolordark="ffffff" style="font-family:Arial;font-size:10pt;">
     <tr>
       <td width="11%" align="center" valign="middle" bgcolor="dbe8ed"><b style="font-size:12px;color:2C728A">Interface Number</b></td>
       <td width="11%" height="25" align="center" valign="middle" bgcolor="dbe8ed"><b style="font-size:12px;color:2C728A">Interface Date</b></td>
       <td width="11%" height="25" align="center" valign="middle" bgcolor="dbe8ed"><b style="font-size:12px;color:2C728A">RFC Name</b></td>
       <td width="11%" height="25" align="center" valign="middle" bgcolor="dbe8ed"><b style="font-size:12px;color:2C728A">SAP Host IP</b></td>
       <td width="11%" height="25" align="center" valign="middle" bgcolor="dbe8ed"><b style="font-size:12px;color:2C728A">SAP Client No</b></td>
       <td width="11%" align="center" valign="middle" bgcolor="dbe8ed"><b style="font-size:12px;color:2C728A">SAP System No</b></td>
       <td width="11%" height="25" align="center" valign="middle" bgcolor="dbe8ed"><b style="font-size:12px;color:2C728A">SAP Language</b></td>
       </tr>
     <tr>
       <td align="center" valign="middle" bgcolor="#F1F1F1"><%=sf.getValue("if_number", 0) %>&nbsp;</td>
       <td height="20" align="center" valign="middle" bgcolor="#F1F1F1"><%=convertDate(sf.getValue("if_date", 0)) + " " + convertTime(sf.getValue("if_time", 0)) %>&nbsp;</td>
       <td align="center" valign="middle" bgcolor="#F1F1F1"><%=sf.getValue("rfc_name", 0) %>&nbsp;</td>
       <td align="center" valign="middle" bgcolor="#F1F1F1"><%=sf.getValue("sap_host_ip", 0) %>&nbsp;</td>
       <td align="center" valign="middle" bgcolor="#F1F1F1"><%=sf.getValue("sap_client_no", 0) %>&nbsp;</td>
       <td align="center" valign="middle" bgcolor="#F1F1F1"><%=sf.getValue("sap_system_no", 0) %>&nbsp;</td>
       <td align="center" valign="middle" bgcolor="#F1F1F1"><%=sf.getValue("sap_language", 0) %>&nbsp;</td>
       </tr>
   </table>   </TD>
</TR>
<%
	sf = new SepoaFormater(value.result[1]);

	if(sf.getRowCount() > 0)
	{	%>
	<TR>
	  <TD align="left"><span class="style1"><img src="../images/blt_srch.gif" width="7" height="7" hspace="5" align="absmiddle"> Parameter Information</span><br>
	    <br>
	    <table width="600" border="1" cellpadding="2" cellspacing="0" bordercolor="158cb5" bordercolorlight="158cb5" bordercolordark="ffffff" style="font-family:Arial;font-size:10pt;">
	      <tr>
	        <td width="50%" height="25" align="center" valign="middle" bgcolor="dbe8ed"><b style="font-size:12px;color:2C728A">Parameter Name</b></td>
	        <td width="50%" height="25" align="center" valign="middle" bgcolor="dbe8ed"><b style="font-size:12px;color:2C728A">Parameter Value</b></td>
	      </tr>
	<%	for(int i = 0; i < sf.getRowCount(); i++)
		{ %>

	      <tr>
	        <td width="50%" height="20" align="center" valign="middle" bgcolor="#F1F1F1"><%=sf.getValue("parameter_name", i) %>&nbsp;</td>
	        <td width="50%" height="20" align="center" valign="middle" bgcolor="#F1F1F1"><%=sf.getValue("parameter_value", i) %>&nbsp;</td>
	      </tr>
	<%	} %>
	    </table></TD>
	</TR>
<%	} %>
<TR>
  <TD align="left"><span class="style1"><img src="../images/blt_srch.gif" width="7" height="7" hspace="5" align="absmiddle"> Data Information</span><br>
<%
	sf = new SepoaFormater(value.result[2]);
	SepoaFormater sf_data = null;
	int row_number = 0;
	int col = 0;

	for(int i = 0; i < sf.getRowCount(); i++)
	{
		row_number = Integer.parseInt(sf.getValue("row_number", i));
	%>
	    <br>
	    <span class="style2">&nbsp;&nbsp;&nbsp; Table Name : <%=sf.getValue("table_name", i) %>,&nbsp;&nbsp; Type : <%=sf.getValue("if_type", i) %></span><br>
	      <table  border="1" cellpadding="2" cellspacing="0" bordercolor="158cb5" bordercolorlight="158cb5" bordercolordark="ffffff" style="font-family:Arial;font-size:10pt;">
	<%
		Object[] obj1 = {if_number, sf.getValue("table_name", i), sf.getValue("if_type", i)};
	    SepoaOut value1 = ServiceConnector.doService(info, "AD_137", "CONNECTION", "getInterfaceInfoColumnName", obj1);
		sf_data = new SepoaFormater(value1.result[0]);
	%>
        <tr>
			<td align="center" valign="middle" bgcolor="dbe8ed"><b style="font-size:11px;color:2C728A">No.&nbsp;</b></td>
	<%	for(int y = 0; y < sf_data.getRowCount(); y++)
	   	{ %>
	        <td align="center" valign="middle" bgcolor="dbe8ed"><b style="font-size:11px;color:2C728A"><%=sf_data.getValue("COLUMN_NAME", y) %>&nbsp;</b></td>
	<%	} %>
	      </tr>
	<%	SepoaFormater sf_data2 = new SepoaFormater(value1.result[1]);

		for(int data = 0; data < row_number; data++)
		{
	 %>
			<tr>
			<td align="center" valign="middle" bgcolor="#F1F1F1"><%=(data + 1)%>&nbsp;</td>
		<%	for(int y = 0; y < sf_data.getRowCount(); y++)
		   	{
		   		col = y + (data * sf_data.getRowCount());
		   		%>
					<td align="center" valign="middle" bgcolor="#F1F1F1"><%=sf_data2.getValue("data_value", col)%>&nbsp;</td>
		<%	} %>
			</tr>
	<%	} %>
	    </table>
<% 	}	%>
	</TD>
</TR>
</TABLE>

</s:header>
<s:footer/>
</body>
</html>
