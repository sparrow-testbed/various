<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-30);
	String to_date = to_day;
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("CTS_004");
	multilang_id.addElement("BUTTON"); 
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	boolean isSelectScreen = false;
	
	String init_flag     = JSPUtil.paramCheck(request.getParameter("init_flag"));
	
	if(init_flag.equals("true")) {
		from_date = SepoaString.getDateUnDashFormat(JSPUtil.paramCheck(request.getParameter("from_date")));
		to_date   = SepoaString.getDateUnDashFormat(JSPUtil.paramCheck(request.getParameter("to_date")));
	}
	String delete_confirm     = JSPUtil.paramCheck(request.getParameter("delete_confirm"));
	
	Configuration conf = new Configuration();
	String domain = conf.getString("sepoa.system.domain.name");
	String screen_id = "CTS_004";
%>


<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<%@ include file="/include/sepoa_scripts.jsp"%>

<Script language="javascript">

var delete_confirm = "<%=delete_confirm%>";
	function doConfirm(){
	
		var delete_confirm = document.form.delete_confirm.value;
		if(delete_confirm.length == 0){
		
			alert("사유를 작성 하십시오.");
			return;
		}
		opener.focus();
		opener.doDelete_confirm(delete_confirm);
	}

	function confirm_focus(){
	
		if(delete_confirm == "") document.form.delete_confirm.focus();
	}
	
	function help(){
		var url = "<%=domain%>/help/<%=screen_id%>.htm";
		var toolbar = 'no';
        var menubar = 'no';
        var status = 'yes';
        var scrollbars = 'yes';
        var resizable = 'yes';
        var title = "Help";
        var left = "100";
        var top = "100";
        var width = "800";
        var height = "600";
        var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
        code_search.focus();

	}
</script>
</head>

<body leftmargin="15" topmargin="6" onload="confirm_focus();">
	<form name="form">
<%
	String title        = "계약서변경요청 사유";
	thisWindowPopupFlag = "true"; 
	thisWindowPopupScreenName = title; 
%>

<%@ include file="/include/sepoa_milestone.jsp"%>
    
<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr style="padding:5 5 5 0" align="right">
		<td>
			<%if(info.getSession("USER_TYPE").equals("S")){ %>
		<script language="javascript">btn("javascript:doConfirm()","확인")</script>
			<%} %>
		</td>
	</tr> 
</table>
</br>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="100%" valign="top">
			<table width="100%" class="board-search" border="0" cellpadding="0" cellspacing="0">
				<colgroup>
                	<col width="20%" />
                	<col width="80%" />
              	</colgroup>
				<tr>
        			<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        				사유
        			</td> 
					<td class="data_td" style="height: 100px;"> 
						<%if(delete_confirm.equals("")) {%>
				        <textarea rows="5" style="width: 98%;" id="delete_confirm" name="delete_confirm" onKeyUp="return chkMaxByte(4000, this, '사유');"></textarea>
						<%}else{  
						out.println(delete_confirm);
						}  %>
					</td>
				</tr>
			</table>
	</table>
</td>
</tr>
</table>
</td>
</tr>
</table>		
		
		
	
		
	</form>
</body>
</html>