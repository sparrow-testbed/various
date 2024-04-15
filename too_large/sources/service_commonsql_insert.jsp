<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_038");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String language = info.getSession("LANGUAGE");

    String to_day = SepoaDate.getShortDateString();
	/* String from_date = WiseDate.addWiseDateDay(to_day,-30); */
	String from_date = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-3);
	String to_date = to_day;

	String house_code = info.getSession("HOUSE_CODE");
	String com_code = info.getSession("COMPANY_CODE");
	String user_id = info.getSession("ID");
	String department = info.getSession("DEPARTMENT");
	String name_loc = info.getSession("NAME_LOC");
	String name_eng = info.getSession("NAME_ENG");

%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>



<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>


<Script language="javascript">

	
	function init() {
		
	    document.form1.use_flag2.checked = true;
	    document.form1.auto_select_flag2.checked = true;
	    
	}
	
	function initAjax(){
		doRequestUsingPOST( 'SL5003', 'M013' ,'language', 'KO' );
		
	}
	function processId() {

	    var type = document.form1.type.value;
	    if(type!=""){

	      	//hIframe.location.href = "/dpos/admin/buy_admin_commonsqlpop7_mgt.jsp?type="+type;
	      	hIframe.location.href = "service_getcode_hidden.jsp?type="+type;
	       	document.form1.auto_flag.value = "Y";//자동 채번이다.
	    } else {

	        document.form1.id.value="";
	    }
	}

	function Save() {
		if(!checkData()) return;
		if(!check_code_flag()) return;

		if (confirm("<%=text.get("MESSAGE.1014")%>")){
			if(document.form1.use_flag2.checked == true) {
				document.form1.use_flag.value = "Y";
			} else {
		        document.form1.use_flag.value = "N";
		    }

			if(document.form1.auto_select_flag2.checked == true) {
				document.form1.auto_select_flag.value = "Y";
			} else {
		        document.form1.auto_select_flag.value = "N";
		    }


		    document.form1.id.value = document.form1.id.value.toUpperCase();
		    document.form1.Title.value = document.form1.Title.value.toUpperCase();
		    document.form1.type.value = document.form1.type.value.toUpperCase();
		    document.form1.Description.value = document.form1.Description.value.toUpperCase();
		    document.form1.List_Item.value = document.form1.List_Item.value.toUpperCase();
		    document.form1.SQL.value = document.form1.SQL.value.toUpperCase();

/* 		    document.form1.method = "POST";
		    document.form1.target = "hIframe";
		    //document.form1.action = "/dpos/admin/buy_admin_commonsqlpop5_mgt.jsp";
		    document.form1.action = "service_queryset_hidden.jsp";
		    document.form1.submit(); */
		    
			var jqa = new jQueryAjax();
			jqa.action = "service_queryset_hidden.jsp";
			jqa.submit();

		    document.form1.duplicate_flag.value = "ng";
		    document.form1.verify_flag.value = "ng";
		}
	}

	function review(){
		if(!checkData()) return;
		if(document.form1.use_flag2.checked == true) {
			document.form1.use_flag.value = "Y";
		} else {
	        document.form1.use_flag.value = "N";
	    }

		if(document.form1.auto_select_flag2.checked == true) {
			document.form1.auto_select_flag.value = "Y";
		} else {
	        document.form1.auto_select_flag.value = "N";
	    }

		document.form1.id.value = document.form1.id.value.toUpperCase();
		document.form1.Title.value = document.form1.Title.value.toUpperCase();
		document.form1.type.value = document.form1.type.value.toUpperCase();
		document.form1.Description.value = document.form1.Description.value.toUpperCase();
		document.form1.List_Item.value = document.form1.List_Item.value.toUpperCase();
		document.form1.SQL.value = document.form1.SQL.value.toUpperCase();

		// pop_wk_rev1.jsp페이지 없음..?
 	 	document.form1.method = "POST";
	    document.form1.target = "work";
	    document.form1.action = "pop_wk_rev1.jsp";
	    document.form1.submit();
	}

	function openreview() {
	    /*type = document.form1.type.value;
	    if (type == "SL" || type == "ML")
	    url = "/kr/admin/wisepopup/cod_pp_lis1.jsp?code=REVIEW";
	    else url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=REVIEW&function=&values=";

	    var left = 50;
	    var top = 100;
	    var width = 750;
	    var height = 500;
	    var toolbar = 'no';
	    var menubar = 'no';
	    var status = 'no';
	    var scrollbars = 'no';
	    var resizable = 'no';
	    var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	    doc.focus();*/
	}

	function checkData() {
	 	id = document.form1.id.value;
	 	Title = document.form1.Title.value;
	 	type = document.form1.type.value;
	 	Description = document.form1.Description.value;
	 	List_Item =document.form1.List_Item.value;
	 	SQL = document.form1.SQL.value;
	 	if(isEmpty(id)){
		 	alert("<%=text.get("AD_038.MSG_0101")%>");
		 	document.form1.id.focus();
		 	return false;
		 }
	 	if(isEmpty(Title)){
		 	alert("<%=text.get("AD_038.MSG_0102")%>");
		 	document.form1.Title.focus();
		 	return false;
		 }
		 if (type == "") {
		 	alert("<%=text.get("AD_038.MSG_0103")%>");
		 	document.form1.type.focus();
		 	return false;
		 }

		 if ((type == "SP") || (type == "MP")) {
		 	if(isEmpty(List_Item)){
		 		alert("<%=text.get("AD_038.MSG_0104")%>");
		 		document.form1.List_Item.focus();
		 		return false;
		 	}
	 	 }
	 	 if(isEmpty(SQL)){
		 	alert("<%=text.get("AD_038.MSG_0105")%>");
		 	document.form1.SQL.focus();
		 	return false;
		 }

	    //if (document.form1.auto_flag.value == "N") //수동입력시 중복체크를 한다.
	    	//if(!check_Dulicate_flag()) return;
	    if(!check_verify_flag()) return;
	    return true;
	}

	function checkverify(flag) {
		document.form1.verify_flag.value = flag;
	    if(flag == "ng") {
	        document.form1.SQL.select();
	    }
	}

	function entKeyDown() {
	    if(event.keyCode==13) {
	        document.form1.SQL.value = document.form1.SQL.value +" ";
	    }
	}

	function checkDulicate(flag) {
		document.form1.duplicate_flag.value = flag;
		if(document.form1.duplicate_flag.value == "ng") {
		  document.form1.id.select();
		  return false;
		}
		if(document.form1.duplicate_flag.value == "ok") {
		  return true;
		}
	}

	function check_Dulicate() {
		document.form1.id.value = document.form1.id.value.toUpperCase();
		id = document.form1.id.value;
		parent.work.location.href = "pop_wk_ins2.jsp?id="+id;
	}

	function check_Dulicate_flag() {
		flag = document.form1.duplicate_flag.value;
		if(flag == "ng") {
		  alert("<%=text.get("AD_038.MSG_0106")%>");
		  return false;
		}
		return true;
	}

	function check_verify_flag() {
		flag = document.form1.verify_flag.value;
		if(flag == "ng") {
		  alert("<%=text.get("AD_038.MSG_0107")%>");
		  return false;
		}
		return true;
	}

	//ID가 형식에 맞게 들어갔는지를 체크한다.
	function CheckID() {
		var id = document.form1.id.value;
		var idtype = id.substring(0,2);
		var idnum = id.substring(2,id.length);
		if (id != "") {
			if ( (idtype != 'SP' && idtype != 'MP' && idtype != 'SL' && idtype != 'ML' )
	                || (IsNumber2(idnum) == false) || (idnum.length !=4)) {
				alert("<%=text.get("AD_038.MSG_0108")%>");
				document.form1.id.value = "";
				return;
			}
			document.form1.type.value = idtype;
			document.form1.auto_flag.value ="N";//수동입력시 중복체크를 한다.
			check_Dulicate();
		}
	}

	//Sql 검증하기
	function verify() {
		document.form1.SQL.value = document.form1.SQL.value.toUpperCase();
		SQL = document.form1.SQL.value;
		if(isEmpty(SQL)){
		 	alert("<%=text.get("AD_038.MSG_0105")%>");
		 	document.form1.SQL.focus();
		 	return;
		}

		//document.form1.action = "/dpos/admin/buy_admin_commonsqlpop4_mgt.jsp";
/* 		document.form1.action = "service_query_check.jsp";
		document.form1.method = "post";
		document.form1.target = "hIframe";
		document.form1.submit(); */
		
		var jqa = new jQueryAjax();
		jqa.action = "service_query_check.jsp";
		jqa.submit();
		
	}

	function IsNumber2(num) {
	    var i;
	    if(num.length <= 0) {
	        return false;
	    }
	    for(i=0;i<num.length;i++) {
	        if((num.charAt(i) < '0' || num.charAt(i) > '9') )
	        return false;
	    }
	    return true;
	}

	function isEmpty(a) {
	    if (Trim(a) == '') return true;
	    return false;
	}

	function Trim(a) {
	    return(LTrim(RTrim(a)));
	}

	function LTrim(a) {
	 var i;
	 i = 0;
	 while (a.substring(i, i+1) == ' ') i = i + 1;
	 return a.substring(i);
	}

	function RTrim(a) {
	    var b;
	    var i = a.length - 1;
	    while (i >= 0 && a.substring(i, i+1) == ' ') i = i - 1;
	    return a.substring(0, i+1);
	}

	function chkKorea(chkstr) {
	   var j, lng = 0;
	   for (j=0; j<chkstr.length; j++) {
	     if (chkstr.charCodeAt(j) > 255) {
	       ++lng;
	      }
	     ++lng;
	   }
	    return lng;
	}

	function h_check(a) {
	    var intErr
	    var strValue = a;
	    var retCode = 0
	    var intErr = 0

	    for (i = 0; i < strValue.length; i++) {
	        var retCode = strValue.charCodeAt(i)
	        var retChar = strValue.substr(i, 1).toUpperCase()
	        retCode = parseInt(retCode)
	        if ((retChar < "0" || retChar > "9")
	               && (retChar < "A" || retChar > "Z")
	               &&((retCode  > 255) || (retCode <  0) || (retCode == 32 ))) {
	          intErr = -1;
	            break;
	        }
	    }
	    return (intErr);
	}

	function check_code_Dulicate()
	{
		var FormName = document.forms[0];
		var id = FormName.id.value;
		var type = FormName.type.value;
		var language = FormName.language.value;

		if(isEmpty(id)){
			//alert("회사 코드를 넣어주세요.");
			//alert("<%=text.get("AD_038.MSG_0109")%>");
			alert("<%=text.get("AD_038.MSG_0111")%>"); //모듈 ID를 숫자 4자로 넣어주세요
			FormName.id.focus();
			return;
		}else if(!IsNumber1(id)){
			alert("<%=text.get("AD_038.MSG_0112")%>"); //모듈 ID에는 숫자만 입력가능 합니다
		}else if(LRTrim(id).length != 4){
			alert("<%=text.get("AD_038.MSG_0113")%>");	//모듈 ID에 숫자 4자리로 입력하세요.
		} else{
			/* parent.hIframe.location.href = "service_commonsql_codechk.jsp?id="+id+"&type="+type+"&language=" + language; */
			
			var jqa = new jQueryAjax();
			jqa.action = "service_commonsql_codechk.jsp";
			jqa.data = "id="+id+"&type="+type+"&language=" + language;
			jqa.submit(false);//form데이터는 가져가지 않는다.
		}
	}

	function checkCodeDulicate(flag)
	{
		var FormName = document.forms[0];
		FormName.code_flag.value = flag;

		if(FormName.code_flag.value == "ng")
		{
			FormName.id.select();
			return false;
		}
		if(FormName.code_flag.value == "ok")
		{
			return true;
		}
	}

	function check_code_flag()
	{
		var FormName = document.forms[0];
		flag = FormName.code_flag.value;
		if(flag == "ng")
		{
			//alert("입력하신 모듈 ID 코드의  중복여부를 확인하세요.");
			alert("<%=text.get("AD_038.MSG_0114")%>");
			return false;
		}
		return true;
	}


</Script>
</head>

<body leftmargin="15" topmargin="6" onLoad="init();initAjax();">
<s:header popup="true">
<form name="form1" method="post" action="">
<input type="hidden" name="code_flag" id="code_flag" value="ng">
<input type="hidden" name="duplicate_flag" id="duplicate_flag" value="ng">
<input type="hidden" name="verify_flag" id="verify_flag" value="ng">
<input type="hidden" name="auto_flag" id="auto_flag" value="N">
<%
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>

<%@ include file="/include/sepoa_milestone.jsp"%>

	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">
	    <table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
		<tr>
		<td width="100%">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DBDBDB">
			<tr>
        		<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_038.LB_0101")%></td>
        		<td width="80%" height="24" class="data_td" colspan="3">
					<input name="Title" id="Title" type="text" class="input_re" size="30" maxlength="100">        		
        		</td>
			</tr>	
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr>
        		<td width="20%" height="24"  class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_038.LB_0104")%>/<%=text.get("AD_038.LB_0102")%>
				</td>
        		<td width="30%" height="24" class="data_td" colspan="2">
                	<select name="language" id="language" class="inputsubmit">
					</select>
					<select name="type" id="type" class="input_re" ><%--onChange='processId()'--%>
						<option value="SP"><%=text.get("AD_038.CLB_0101")%></option>
						<option value="SL"><%=text.get("AD_038.CLB_0102")%></option> 
					</select><br>
					<input name="id" id="id" type="text" size="4" maxlength="4">&nbsp;&nbsp;<b> *숫자 4자리 입력</b>	
                </td>
        		<td width="20%" height="24" align="left" class="data_td"><script language="javascript">btn("javascript:check_code_Dulicate()","<%=text.get("BUTTON.dulicate")%>")
        		</script>
				</td>
        		
             </tr>
             <tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr>
		        <td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_038.LB_0103")%></td><%--사용유무--%>
				<td width="30%" height="24" class="data_td">
						<input name="use_flag2" id="use_flag2" type="checkbox" value="" class="input_empty" checked>
						<input type="hidden" name="use_flag" id="use_flag" value="">
				</td>
		        <td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_038.LB_0105")%></td><%--설명 --%>
				<td width="30%" height="24" class="data_td">
						<input name="Description" id="Description" type="text" size="35" maxlength="300">
				</td>	
			</tr>	
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>			  
			<tr>
		        <td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_038.LB_0106")%></td><%--자동조회여부--%>
				<td width="30%" height="24" class="data_td">
						<input name="auto_select_flag2" id="auto_select_flag2" type="checkbox" class="radio" value="" checked>
						<input type="hidden" name="auto_select_flag" id="auto_select_flag" value="">
				</td>
		        <td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_038.LB_0107")%></td><%--조회결과컬럼 --%>
				<td width="30%" height="24" class="data_td">
						<input name="List_Item" id="List_Item" type="text" size="35" maxlength="300">
				</td>			  
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>

			<tr>
				<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_038.LB_0108")%> </td> <%--SQL--%>
				<td width="80%" height="24" class="data_td" colspan="3">
					<textarea name="SQL" id="SQL" rows="6"  style="width:96%"></textarea>
				</td>
			</tr>
			  </td>
		</tr>
		</table>
		</table>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					  <TR>
					  	  	<td><script language="javascript">btn("verify()","<%=text.get("AD_038.BTN_0101")%>")</script></td>
                        	<td><script language="javascript">btn("Save()","<%=text.get("BUTTON.insert")%>")</script></td>
                        	<td><script language="javascript">btn("javascript:window.close();","<%=text.get("BUTTON.close")%>")</script></td>
					  </TR>
				    </TABLE>
				  </td>
			    </TR>
			  </TABLE>
            
			</td>
		  </tr>
		</table>
	</form>
</body>

<!-- <iframe name="hIframe" width="0" height="0" border="0"> -->
</s:header>
<s:footer/>
</iframe>
</html>



