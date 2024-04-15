<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp" %>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_128");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String user_id = info.getSession("ID");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_name_eng = info.getSession("NAME_ENG");
	String user_dept = info.getSession("DEPARTMENT");
	String house_code = info.getSession("HOUSE_CODE");
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>


<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>

<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	String I_COMPANY_CODE   = request.getParameter("I_COMPANY_CODE");
	String I_DEPT           = request.getParameter("I_DEPT");
	String I_PR_LOCATION    = request.getParameter("I_PR_LOCATION");
	String DEPT_NAME_LOC    = request.getParameter("DEPT_NAME_LOC");

	String dept_name_loc           = "" ;
	String dept_name_eng           = "" ;
	String manager_name            = "" ;
	String manager_position        = "" ;
	String manager_position_name   = "" ;
	String pr_location             = "" ;
	String pr_location_name        = "" ;
	String menu_profile_code       = "" ;
	String menu_name               = "" ;
	String ctrl_dept_flag          = "" ;
	String phone_no                = "" ;
	String fax_no                  = "" ;
	String menu_type               = "" ;
	String sign_attach_no          = "" ;
	String sign_attach_no_count    = "0" ;

	String[] data = {I_COMPANY_CODE, I_DEPT, I_PR_LOCATION};
	Object[] obj = {(Object[])data};

	SepoaOut value = ServiceConnector.doService(info, "AD_126", "CONNECTION","getDis", obj);

	if(value.status == 1)
	{
		SepoaFormater wf = new SepoaFormater(value.result[0]);

		if ( wf.getRowCount() > 0 ) {
			dept_name_loc           = wf.getValue("DEPT_NAME_LOC"        , 0) ;
			dept_name_eng           = wf.getValue("DEPT_NAME_ENG"        , 0) ;
			manager_name            = wf.getValue("MANAGER_NAME"         , 0) ;
			manager_position        = wf.getValue("MANAGER_POSITION"     , 0) ;
			manager_position_name   = wf.getValue("MANAGER_POSITION_NAME", 0) ;
			pr_location             = wf.getValue("PR_LOCATION"          , 0) ;
			pr_location_name        = wf.getValue("PR_LOCATION_NAME"     , 0) ;
			menu_profile_code       = wf.getValue("MENU_PROFILE_CODE"    , 0) ;
			menu_name               = wf.getValue("MENU_NAME"            , 0) ;
			ctrl_dept_flag          = wf.getValue("CTRL_DEPT_FLAG"       , 0) ;
			phone_no                = wf.getValue("PHONE_NO"             , 0) ;
			fax_no                  = wf.getValue("FAX_NO"               , 0) ;
			menu_type               = wf.getValue("MENU_TYPE"            , 0) ;
			sign_attach_no          = wf.getValue("SIGN_ATTACH_NO"       , 0) ;
			sign_attach_no_count    = wf.getValue("SIGN_ATTACH_NO_COUNT" , 0) ;
		}
	}
%>

<Script language="javascript">
function Init()
{
	if(document.form.ctrl_dept_flag2.value == "Y") document.form.ctrl_dept_flag.checked = true;
}

function checkDulicate(flag, status)
{

	if(status == 'X')  {
		deptSave();

	}else {
		//alert("중복된 데이타입니다");
		alert("<%=text.get("AD_128.MSG_0100")%>");
		document.form.pr_location.focus();
		return false;
	}
}


function doUpdate()
{
	var FormName = document.forms[0];
	FormName.dept.value = FormName.dept.value.toUpperCase();
	dept                = FormName.dept.value;
	company_code        = FormName.company_code.value;
	pr_location         = FormName.pr_location.value;

	old_pr_location = FormName.old_pr_location.value;

	if(isEmpty(dept))
	{
		//alert("부서단위 코드를 넣어주세요.");
		alert("<%=text.get("AD_128.MSG_0101")%>");

		FormName.dept.focus();
		return;
	}
	if(isEmpty(pr_location))
	{
		//alert("청구지역을 넣어주세요.");
		alert("<%=text.get("AD_128.MSG_0102")%>");
		FormName.pr_location.focus();
		return;
	 }
	//pr_location이 안바뀌면 중복체크 로직 안태운다.
	if (pr_location == old_pr_location)
	{
		deptSave();
		return;
	}
	//parent.work.location.href = "post_unit_in_con.jsp?i_company_code="+company_code+"&i_dept="+dept+"&i_pr_location="+pr_location;
	checkDulicate('ok', 'X');
}


function deptSave()
{
	if(!checkData()) return;
	YN();

/* 	document.form.method = "POST";
	document.form.target = "work";
	document.form.action = "post_unit_update.jsp";
	document.form.submit(); */
	
	var jqa = new jQueryAjax();
	jqa.action = "post_unit_update.jsp";
	jqa.submit();
}

function checkData()
{

	dept = document.form.dept.value;
	dept_name_loc = document.form.dept_name_loc.value;
	pr_location = document.form.pr_location.value;

	if(isEmpty(dept)){
		//alert("부서단위 코드를 넣어주세요.");
		alert("<%=text.get("AD_128.MSG_0103")%>");
		document.form.dept.focus();
		return false;
	 }
	if(isEmpty(dept_name_loc)){
		//alert("부서명(한글)을 넣어주세요.");
		alert("<%=text.get("AD_128.MSG_0104")%>");
		document.form.dept_name_loc.focus();
		return false;
	}
	if(isEmpty(pr_location)){
		//alert("청구지역을 넣어주세요.");
		alert("<%=text.get("AD_128.MSG_0105")%>");
		document.form.pr_location.focus();
		return false;
	}

	return true;
}

function YN()
{
	if(document.form.ctrl_dept_flag.checked == true)
	{
		document.form.ctrl_dept_flag2.value = "Y";
	}else document.form.ctrl_dept_flag2.value = "N";
}



function doList()
{
	parent.body.location.href="post_unit.jsp";
}


function getmanager_position(code,text)
{
	document.form.manager_position.value = code;
	document.form.text_manager_position.value = text;
}

function popup(code)
{
	var company_code = document.form.company_code.value;

	if (code == "manager_position")
	url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0029&function=getmanager_position&values="+company_code+"&values=C001";

	//var left = 50;
	//var top = 100;
	//var width = 750;
	//var height = 500;
	//var toolbar = 'no';
	//var menubar = 'no';
	//var status = 'no';
	//var scrollbars = 'no';
	//var resizable = 'no';
	//var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable, popup_flag=true );
	//doc.focus();

	popupcode("C001", "getmanager_position");
}

function Trim(a)
{
	return(LTrim(RTrim(a)));
}


function h_check(a)
{
	var intErr
	var strValue = a;
	var retCode = 0
	var intErr = 0

	for (i = 0; i <  strValue.length; i++)
	{
		var retCode = strValue.charCodeAt(i)
		var retChar = strValue.substr(i,1).toUpperCase()
		retCode = parseInt(retCode)
		if ((retChar <  "0" || retChar  > "9") && (retChar <  "A" || retChar  > "Z") && ((retCode  > 255) || (retCode <  0) || (retCode == 32 ))) {
			intErr = -1;
			break;
		}
	}
	return (intErr);
}

function Setprofile(code,name) {
	document.forms[0].menu_profile_code.value = code;
	document.forms[0].menu_name.value = name;
}

function getprofile() {
	var dim = new Array(2);

	dim = ToCenter('600','800');
	var top = dim[0];
	var left = dim[1];
	var url = "/kr/admin/system/mu1_bd_ins3.jsp?flag=Y";

	window.open(url,"BKWin","top="+top+",left="+left+",width=800,height=600,resizable=yes,status=yes,scrollbars = yes");
}

function goAttach(attach_no){
	attach_file(attach_no,"IMAGE");
}

function setAttach(attach_key, arrAttrach, attach_count) {
	document.form.sign_attach_no.value = attach_key;
	document.form.sign_attach_no_count.value = attach_count;
}
</Script>

</head>

<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="Init();">
<s:header>
<form name="form" >
<input type="hidden" value="<%=I_PR_LOCATION %>" name="old_pr_location" id="old_pr_location">
<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>
	<%@ include file="/include/include_top.jsp"%>
	<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		      <tr>
        		<td width="20%" height="24" class="se_cell_title"><%=text.get("AD_128.TEXT_0100")%></td>
				<td width="80%" height="24" class="se_cell_data" colspan="3">
					<input type="text" name="company_code" id="company_code" value="<%=I_COMPANY_CODE%>" size="20" class="input_data0" readOnly>
				</td>	
			  </tr>
			</table>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					    <TR>
			      			<TD><script language="javascript">btn("javascript:doUpdate()", "<%=text.get("BUTTON.update")%>")</script></TD>
	    	  			<%-- <TD><script language="javascript">btn("javascript:doList()", "<%=text.get("BUTTON.confirm")%>")</script></TD>--%>
		    	  		</TR>
		    	  		</TABLE>
				  </td>
			    </TR>
			  </TABLE>
		</td>
	</tr>
	</table>  
	<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="DBDBDB">
	<tr>
	  <td width="20%" class="div_input_re" height="32" align="center"><%=text.get("AD_128.TEXT_0101")%></td>
	  <td class="div_data" colspan="3">
		<input type="text" value="<%=I_DEPT%>" name="dept" id="dept" size="15" maxlength="10" class="input_re" readOnly>
	  </td>
	</tr>
	<tr>
	  <td width="20%" class="div_input_re" align="center"><%=text.get("AD_128.TEXT_0102")%></td>
	  <td colspan="3" class="div_data">
		<input type="text" name="dept_name_loc" id="dept_name_loc" value="<%=dept_name_loc %>" size="30" maxlength="50" class="input_re">
		</td>
	</tr>
	<tr>
	  <td width="20%" class="div_input" align="center"><%=text.get("AD_128.TEXT_0103")%></td>
	  <td colspan="3" class="div_data">
		<input type="text" name="dept_name_eng" id="dept_name_eng" value="<%=dept_name_eng %>" size="30" maxlength="50" class="inputsubmit">
		</td>
	</tr>
	<tr>
	  <td width="20%" class="div_input" align="center"><%=text.get("AD_128.TEXT_0104")%></td>
	  <td width="30%" class="div_data">
		<input type="text" name="manager_name" id="manager_name" value="<%=manager_name %>" size="30" maxlength="50" class="inputsubmit">
	  </td>
	  <td width="20%" class="div_input" align="center"><%=text.get("AD_128.TEXT_0105")%></td>
	  <td width="30%" class="div_data">
		<input type="text" name="text_manager_position" id="text_manager_position" value="<%=manager_position_name %>" maxlength="10" class="input_data3" size="10">
		<a href="javascript:popup('text_manager_position')"><img src="<%=POASRM_CONTEXT_NAME%>/images/button/query.gif" align="absmiddle" border="0"></a>
		<input type="text" size="10" name="manager_position" id="manager_position" value="<%=manager_position %>" class="input_empty">
		</b> </td>
	</tr>
	<tr>
	  <td width="20%" class="div_input" align="center"><%=text.get("AD_128.TEXT_0106")%></td>
	  <td colspan="3" class="div_data">
		<input type="text" name="menu_type" id="menu_type" size="2" value="<%= menu_type %>"  class="inputsubmit" maxlength="2">
	  </td>
	</tr>
	<tr>
	  <td width="20%" class="div_input_re" align="center"><div align="center"><%=text.get("AD_128.TEXT_0107")%></div></td>
	  <td colspan="3" class="div_data"> <b>

		<select name="pr_location" id="pr_location" class="input_re">
		 <%
		 String pr_location_data = ListBox(request, "SL0018" , "#M062#", pr_location);
		 out.println(pr_location_data);
		 %>
		</select>
		</b></td>
	 </tr>
	<tr>
	  <td width="20%" class="div_input" align="center"><div><%=text.get("AD_128.TEXT_0108")%></div></td>
	  <td colspan="3" class="div_data"> <b>
		<input type="checkbox" name="ctrl_dept_flag" id="ctrl_dept_flag" class="radio" value="">
		<input type="hidden" name="ctrl_dept_flag2" id="ctrl_dept_flag2" value="<%=ctrl_dept_flag%>">
		</b></td>
	</tr>
	<tr>
	  <td width="20%" class="div_input" align="center"><%=text.get("AD_128.TEXT_0109")%></td>
	  <td colspan="3" class="div_data"> <b>
		<input type="text" name="phone_no" id="phone_no" value="<%=phone_no%>" size="20" maxlength="20" class="inputsubmit">
		</b></td>
	</tr>
	<tr>
	  <td width="20%" class="div_input" align="center"><%=text.get("AD_128.TEXT_0110")%></td>
	  <td colspan="3" class="div_data"> <b>
		<input type="text" name="fax_no" id="fax_no" value="<%=fax_no%>" size="20" maxlength="20" class="inputsubmit">
		</b>
	  </td>
	</tr>
	<tr>
      <td class="div_input" align="center"><%=text.get("AD_128.TEXT_0111")%><!-- 사인 첨부파일 --></td>
      <td class="div_data" colspan="3">
		<table cellpadding="0">
		  <tr>
			<td><script language="javascript">btn("javascript:goAttach(document.forms[0].sign_attach_no.value)", "<%=text.get("AD_128.button_file")%>")</script></td>
			<td>&nbsp;<input type="text" size="3" readOnly class="input_empty" value="<%=sign_attach_no_count %>" name="sign_attach_no_count" id="sign_attach_no_count"><%=text.get("AD_128.file_count")%>
				<br><%-- * Image Size 는 가로 117 픽셀, 세로 75 픽셀 크기의 파일을 첨부해야 합니다. --%>
				<font style="font-size:10px" color="blue"><%=text.get("AD_128.TEXT_0112")%></font>
				<input type="hidden" value="<%=sign_attach_no %>" name="sign_attach_no" id="sign_attach_no">
			</td>
		  </tr>
		</table>
      </td>
    </tr>
  </table>
 </form>
<!-- <iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe> -->
</s:header>
<s:footer/>
</body>
</html>
