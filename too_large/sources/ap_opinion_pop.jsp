<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AP_025");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AP_025";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<%
System.out.println(request.getParameter("SIGN_REMARK"));

	String SIGN_REMARK    	= JSPUtil.nullToEmpty(request.getParameter("SIGN_REMARK"));
	String GUBUN  			= JSPUtil.nullToEmpty(request.getParameter("GUBUN"));
	String ROW  			= JSPUtil.nullToEmpty(request.getParameter("ROW"));
	String CON_TITLE		= "";
	
	String TITLE = "결재상신 화면";
	String readonly = "";
	if (GUBUN.equals("") || GUBUN.equals("M") ) { 
		readonly = "";
	}else{
		readonly="readonly";
	}
	
	if (GUBUN.equals("") || GUBUN.equals("O") || GUBUN.equals("M")) {
		CON_TITLE = "상신의견";
	}else{
		CON_TITLE = "결재의견";
	}
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<script language="javascript">

function init() {
	var row = "<%=ROW%>";
	var SIGN_REMARK  = opener.GridObj.GetColHDIndex("SIGN_REMARK");
	document.forms[0].remark.value = opener.parent.body.GridObj.GD_GetCellValueIndex(GridObj,row, SIGN_REMARK);
}

function doInsert() {
	var remark = document.forms[0].remark.value;

<% 
	if ( GUBUN.equals("M") ) { 
%>
	var row = "<%=ROW%>";
	var SIGN_REMARK  = opener.GridObj.GetColHDIndex("SIGN_REMARK");
	opener.GridObj.SetCellValueIndex("SIGN_REMARK_IMG",row,"/images/icon/icon_data_a.gif");		
	//opener.GridObj.SetCellImage("SIGN_REMARK",row,0);
	opener.GridObj.SetCellValueIndex("SIGN_REMARK",row,remark);
<% 
	} else { 
%>
	var row = "<%=ROW%>";
	var SIGN_REMARK_IMG  = opener.GridObj.GetColHDIndex("SIGN_REMARK_IMG");
	var SIGN_REMARK  = opener.GridObj.GetColHDIndex("SIGN_REMARK");
	//alert( "SIGN_REMARK: " + SIGN_REMARK + "SIGN_REMARK_HIDDEN: " + SIGN_REMARK_HIDDEN );
	opener.GridObj.SetCellValueIndex("SIGN_REMARK_IMG",row,"/images/icon/icon_data_a.gif");	
	//opener.GridObj.SetCellImage("SIGN_REMARK",row,0);
	opener.GridObj.SetCellValueIndex(SIGN_REMARK,row,remark);
	opener.GridObj.SetCellValueIndex(SIGN_REMARK,row,remark);
<% 	 
	}   
%>
	window.close();
}
</script>
	

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>

<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

</head>
<body onload="" bgcolor="#FFFFFF" text="#000000" topmargin="0">

<!--내용시작-->
<form name="form1">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class='title_page' width="78%" align="left">
			<% 
	  		if (GUBUN.equals("") || GUBUN.equals("O") || GUBUN.equals("M")) { 
	  		%>
	  			상신의견
	  		<% 
	  		} else { 
	  		%>
			 결재의견조회
			<% 
	  		} 
	  		%>

  		</td>
	</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="760" height="2" bgcolor="#0072bc"></td>
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
	   		<td width="15%" class="title_td" >
	  		<% 
	  		if (GUBUN.equals("") || GUBUN.equals("O") || GUBUN.equals("M")) { 
	  		%>
	  			상신의견
	  		<% 
	  		} else { 
	  		%>
		 		결재의견
		 	<% 
	  		} 
	  		%>

	  		</td>
	   		<td class="data_td" colspan="3">
	  			<textarea name="remark" id="remark" class="inputsubmit" style="padding:5px 5px 5px 5px; width: 96%; height: 80px" value="" cols="70" rows="5" onKeyUp="return chkMaxByte(500, this, '<%=CON_TITLE %>');" <%=readonly %>><%=SIGN_REMARK%></textarea>
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
		      		<% 
					if (GUBUN.equals("") || GUBUN.equals("M") ) { 
					%>
						<TD><script language="javascript">btn("javascript:doInsert()","확 인")   </script></TD>
					<% 
					} 
					%>
		      			<TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
 </form>

<s:footer/>
</body>
</html>


