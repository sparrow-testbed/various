<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_127");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);
    
	String user_id = info.getSession("ID");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_name_eng = info.getSession("NAME_ENG");
	String user_dept = info.getSession("DEPARTMENT");
	String house_code = info.getSession("HOUSE_CODE");
	String i_company_code = request.getParameter("I_COMPANY_CODE");
%>
<html>
<head>


<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>

<Script language="javascript">
function doInsert()
{
	if(!checkData()) return;
	YN();
/* 	document.form.method = "POST";
	document.form.target = "childFrame";
	document.form.action = "post_unit_in_save.jsp";
	document.form.submit(); */
	
	var jqa = new jQueryAjax();
	jqa.action = "post_unit_in_save.jsp";
	jqa.submit();
	
}

function checkData()
{
	dept			= document.form.dept.value;
	dept_name_loc	= document.form.dept_name_loc.value;
	pr_location		= document.form.pr_location.value;

	if(isEmpty(dept)){
		//alert("부서단위 코드를 넣어주세요.");
		alert("<%=text.get("AD_127.MSG_0100")%>");
		document.form.dept.focus();
		return false;
	}
	if(isEmpty(dept_name_loc)){
		//alert("부서명(한글)을 넣어주세요.");
		alert("<%=text.get("AD_127.MSG_0101")%>");
		document.form.dept_name_loc.focus();
		return false;
	}
	if(isEmpty(pr_location)){
		//alert("청구지역을 넣어주세요.");
		alert("<%=text.get("AD_127.MSG_0102")%>");
		document.form.pr_location.focus();
		return false;
	}

	if(!check_Dulicate_flag()) return false;

	return true;
}

function YN()
{
	document.form.ctrl_dept_flag2.value = "N";
	if(document.form.ctrl_dept_flag.checked == true)
	{
		document.form.ctrl_dept_flag2.value = "Y";
	}
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
	{
		url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0029&function=getmanager_position&values=C001&values=";
		var url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0029&function=getmanager_position&values=C001&values=&values=";
		//Code_Search(url,'','','','','');
		
		//var vArr = new Array("C001");
		//PopupCommonArr("SP0029", "getmanager_position", vArr, "");
		popupcode("C001", "getmanager_position");
	}
}

function doList()
{
	/* parent.body.location.href="post_unit.jsp"; */
	location.href="post_unit.jsp";
}

function checkDulicate(flag, status)
{
	document.form.duplicate_flag.value = flag;

	if(status == 'X')  {
		//alert("사용가능한 코드입니다.");
		alert("<%=text.get("AD_127.MSG_0103")%>");
		return ;
	}else {
		//alert("중복된 데이타입니다");
		alert("<%=text.get("AD_127.MSG_0104")%>");
		document.form.dept.focus();
		return ;
	}
}

function check_Dulicate()
{
	document.form.dept.value = document.form.dept.value.toUpperCase();
	dept = document.form.dept.value;
	company_code = document.form.company_code.value;
	pr_location = document.form.pr_location.value;

	if(isEmpty(dept)){
		//alert("부서단위 코드를 넣어주세요.");
		alert("<%=text.get("AD_127.MSG_0105")%>");
		document.form.dept.focus();
		return;
	}

	if(isEmpty(pr_location)){
		//alert("청구지역을 넣어주세요.");
		alert("<%=text.get("AD_127.MSG_0106")%>");
		document.form.pr_location.focus();
		return;
	}
	//parent.work.location.href = "post_unit_in_con.jsp?i_company_code="+company_code+"&i_dept="+dept+"&i_pr_location="+pr_location;
	
	var jqa = new jQueryAjax();
	jqa.action = "post_unit_in_con.jsp";
	jqa.data = "i_company_code="+company_code+"&i_dept="+dept+"&i_pr_location="+pr_location;
	jqa.submit(false);
}
	
function check_Dulicate_flag()
{
	flag = document.form.duplicate_flag.value;
	if(flag == "ng")
	{
	  //alert("입력하신 코드의 중복여부를 확인하세요.");
	  alert("<%=text.get("AD_127.MSG_0107")%>");
	  return false;
	}
	return true;
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

	for (i = 0; i <  strValue.length; i++) {
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

function getprofile() 
{
	var dim = new Array(2);

	dim = ToCenter('600','800');
	var top = dim[0];
	var left = dim[1];
	var url = "post_unit_in_profile.jsp?flag=Y";

	window.open(url,"BKWin","top="+top+",left="+left+",width=800,height=600,resizable=yes,status=yes,scrollbars = yes, popup_flag=true ");
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

<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0">
<s:header>
<form name="form" method="post" action="">
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
        		<td width="20%" height="24" class="se_cell_title"><%=text.get("AD_127.TEXT_0100")%></td>
				<td width="80%" height="24" class="se_cell_data" colspan="3">
					<input type="text" name="company_code" value="<%=i_company_code%>" size="20" class="input_data0" readOnly>
				</td>	
			  </tr>
			</table>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					    <TR>
			      			<td><script language="javascript">btn("javascript:doInsert()","<%=text.get("BUTTON.save")%>")</script></td>
							<td><script language="javascript">btn("javascript:doList()","<%=text.get("BUTTON.confirm")%>")</script></td>
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
	  <td width="20%" class="div_input_re" align="center"><%=text.get("AD_127.TEXT_0101")%></td>
	  <td class="div_data" colspan="3">	  
		<table cellpadding="0">
		<tr>
			<td><input type="text" name="dept" size="15" maxlength="5" class="input_re"></td>        
			<td><script language="javascript">btn("javascript:check_Dulicate()","<%=text.get("BUTTON.dulicate")%>")</script></td>
		</tr>
		</table>
	  </td>
			<input type="hidden" name="duplicate_flag" value="ng">
	  </td>
	</tr>
	<tr>
	  <td  width="20%" class="div_input_re" align="center"><%=text.get("AD_127.TEXT_0102")%></td>
	  <td colspan="3" class="div_data"><input type="text" name="dept_name_loc" size="30" maxlength="50" class="input_re"></td>
	</tr>
	<tr>
	  <td width="20%" class="div_input" align="center"><%=text.get("AD_127.TEXT_0103")%></td>
	  <td colspan="3" class="div_data"><input type="text" name="dept_name_eng" size="30" maxlength="50" class="inputsubmit"></td>
	</tr>
	<tr>
	  <td width="20%" class="div_input" align="center"><%=text.get("AD_127.TEXT_0104")%></td>
	  <td width="30%" class="div_data"><input type="text" name="manager_name" size="30" maxlength="40" class="inputsubmit"></td>
	  <td width="20%" class="div_input" align="center"><%=text.get("AD_127.TEXT_0105")%></td>
	  <td width="30%" class="div_data"><input type="text" name="text_manager_position" value="" maxlength="10" class="inputsubmit" readonly size="10">
		<input type="hidden" name="manager_position" value="">
		<a href="javascript:popup('manager_position')"><img src="<%=POASRM_CONTEXT_NAME%>/images/button/query.gif" align="absmiddle" border="0"></a>
	  </td>
	</tr>
	 <tr>
	  <td width="20%" class="div_input" align="center"><%=text.get("AD_127.TEXT_0106")%></td>
	  <td colspan="3" class="div_data"><input type="text" name="menu_type" size="2" class="inputsubmit" maxlength="2"></td>
	 </tr>
	 <tr>
	  <td width="20%" class="div_input_re" align="center"><%=text.get("AD_127.TEXT_0107")%></td>
	  <td colspan="3" class="div_data">
		<select name="pr_location" class="input_re">
		 <%
			 String pr_location = ListBox(request, "SL0018" , "#M062#", "");
			 out.println(pr_location);
		 %>
		</select>
	   </td>
	</tr>
	<tr>
	  <td width="20%" class="div_input" align="center"><%=text.get("AD_127.TEXT_0108")%></td>
	  <td class="div_data" colspan="3">
		<input type="checkbox" name="ctrl_dept_flag" class="radio" value="checkbox">
		<input type="hidden" name="ctrl_dept_flag2" value="">
		</td>
	</tr>
	<tr>
	  <td width="20%" class="div_input" align="center"><%=text.get("AD_127.TEXT_0109")%></td>
	  <td class="div_data" colspan="3">
		<input type="text" name="phone_no" size="20" maxlength="20" class="inputsubmit">
		</td>
	</tr>
	<tr>
	  <td width="20%" class="div_input" align="center"><%=text.get("AD_127.TEXT_0110")%></td>
	  <td class="div_data" colspan="3">
		<input type="text" name="fax_no" size="20" maxlength="20" class="inputsubmit">
	  </td>
	</tr>
	<tr>
      <td class="div_input" align="center"><%=text.get("AD_127.TEXT_0111")%><!-- 사인 첨부파일 --></td>
      <td class="div_data" colspan="3">
		<table cellpadding="0">
		  <tr>
			<td><script language="javascript">btn("javascript:goAttach(document.forms[0].sign_attach_no.value)", "<%=text.get("AD_127.button_file")%>")</script></td>
			<td>&nbsp;<input type="text" size="3" readOnly class="input_empty" value="0" name="sign_attach_no_count"><%=text.get("AD_127.file_count")%>
				<br><%-- * Image Size 는 가로 117 픽셀, 세로 75 픽셀 크기의 파일을 첨부해야 합니다. --%>
				<font style="font-size:10px" color="blue"><%=text.get("AD_127.TEXT_0112")%></font>
				<input type="hidden" value="" name="sign_attach_no">
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
