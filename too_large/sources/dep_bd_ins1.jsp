<%--
화면명  : 부서단위 > (부서단위)등록 (/kr/admin/organization/depart/dep_bd_ins1.jsp)
내  용  : 저장/확인 처리
작성자  : 신병곤
작성일  : 2006.01.19.
비  고  :
--%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	String user_id = info.getSession("ID");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_name_eng = info.getSession("NAME_ENG");
	String user_dept = info.getSession("DEPARTMENT");
	String house_code = info.getSession("HOUSE_CODE");
	String i_company_code = request.getParameter("I_COMPANY_CODE");
	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
%>
<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript">
function doInsert()
{
	if(!checkData()) return;
	YN();
	document.form.method = "POST";
	document.form.target = "childFrame";
	document.form.action = "dep_wk_ins1.jsp";
	document.form.submit();
}

function checkData()
{
	dept			= document.form.dept.value;
	dept_name_loc	= document.form.dept_name_loc.value;
	pr_location		= document.form.pr_location.value;

	if(isEmpty(dept)){
		alert("부서단위 코드를 넣어주세요.");
		document.form.dept.focus();
		return false;
	}
	if(isEmpty(dept_name_loc)){
		alert("부서명(한글)을 넣어주세요.");
		document.form.dept_name_loc.focus();
		return false;
	}
	if(isEmpty(pr_location)){
		alert("청구지역을 넣어주세요.");
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
		var vArr = new Array("<%=house_code%>",company_code,"C001");
		PopupCommonArr("SP0029","getmanager_position",vArr,"");
	}
}

function doList()
{
	parent.body.location.href="dep_bd_lis1.jsp";
}

function checkDulicate(flag, status)
{
	document.form.duplicate_flag.value = flag;

	if(status == 'X')  {
		alert("사용가능한 코드입니다.");
		return ;
	}else {
		alert("중복된 데이타입니다");
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
		alert("부서단위 코드를 넣어주세요.");
		document.form.dept.focus();
		return;
	}

	if(isEmpty(pr_location)){
		alert("청구지역을 넣어주세요.");
		document.form.pr_location.focus();
		return;
	}
	childFrame.location.href = "dep_wk_ins2.jsp?i_company_code="+company_code+"&i_dept="+dept+"&i_pr_location="+pr_location;
}

function searchProfile(part){

	if(part == "high_dept"){
		PopupCommon2("SP0022", "getDept","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>", "코드","부서명");
	}
}		

function getDept(code, text) {
	document.forms[0].high_dept.value = code;
	document.forms[0].high_dept_text.value = text;
}

function check_Dulicate_flag()
{
	flag = document.form.duplicate_flag.value;
	if(flag == "ng")
	{
	  alert("입력하신 코드의 중복여부를 확인하세요.");
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
	var url = "/kr/admin/system/mu1_bd_ins3.jsp?flag=Y";

	window.open(url,"BKWin","top="+top+",left="+left+",width=800,height=600,resizable=yes,status=yes,scrollbars = yes");
}
</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<s:header>
<form id="form" name="form" >
<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr >
	   <td class="cell_title1" width="78%" ><%@ include file="/include/sepoa_milestone.jsp" %></td>
	</tr>
	<tr >
		<td height="10" bgcolor="FFFFFF"></td>
	</tr>	
</table>
  <table width="98%" border="0" cellspacing="1" cellpadding="1" bgcolor="#407bbc" style="border-collapse:collapse;">
	<tr>
	  <td class="c_title_1" width="20%">
	  <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;회사코드</td>
	  <td class="c_data_1" width="80%">
		<input type="text" name="company_code" value="<%=i_company_code%>" size="25" class="input_data2" readOnly>
	  </td>
	</tr>
  </table>
<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td height="30" align="right">
			<TABLE cellpadding="0">
	      		<TR>
	      			<TD><script language="javascript">btn("javascript:doInsert()","저 장")</script></TD>
	      			<TD><script language="javascript">btn("javascript:history.back(-1)","취 소")</script></TD>
    	  		</TR>
  			</TABLE>
  		</td>
	</tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="1" bgcolor="#407bbc" style="border-collapse:collapse;">
	<tr>
	  <td width="20%" class="c_title_1" height="32">
	  <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;부서코드
	  </td>
	  <td class="c_data_1" width="80%" colspan="3">	  
		<table cellpadding="0">
		<tr>
		<td>
		<input type="text" name="dept" size="30" maxlength="5" class="input_re">
		</td>        
		<td>        
		<script language="javascript">btn("javascript:check_Dulicate()","중복확인")</script>
		</td>
		</tr>
		</table>
	  </td>
		<input type="hidden" name="duplicate_flag" value="ng">
		</td>
	</tr>
	<tr>
	  <td  width="20%" class="c_title_1">
	  <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;부서명(한글)
	  </td>
	  <td colspan="3" class="c_data_1">
		<input type="text" name="dept_name_loc" size="30" maxlength="50" class="input_re">
	  </td>
	</tr>
	<tr>
	  <td width="20%" class="c_title_1">
	  <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;부서명(영문)
	  </td>
	  <td colspan="3" class="c_data_1">
		<input type="text" name="dept_name_eng" size="30" maxlength="50" class="inputsubmit">
		</td>
	</tr>
	 <tr>
	  <td width="20%" class="c_title_1">
	  <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;부서장명
	  </td>
	  <td width="30%" class="c_data_1">
		<input type="text" name="manager_name" size="30" maxlength="40" class="inputsubmit">
		</b></td>
	  <td width="20%" class="c_title_1">
	  <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;부서장직책</td>
	  <td width="30%" class="c_data_1">
		<input type="text" name="text_manager_position" value="" maxlength="10" class="inputsubmit" readonly size="20">
		<input type="hidden" name="manager_position" value="">
		<a href="javascript:popup('manager_position')"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"></a>
		</td>
	</tr>
	 <tr>
	  <td width="20%" class="c_title_1">
	  <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;메뉴형태
	  </td>
	  <td colspan="3" class="c_data_1">
		<input type="text" name="menu_type" size="10" class="inputsubmit" maxlength="2">
	  </td>
	 </tr>
	<tr>
	  <td width="20%" class="c_title_1">
	  <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;프로파일코드</td>
	  <td width="40%" class="c_data_1" colspan="3">
		<input type="text" name="menu_profile_code" value="" size="25" maxlength="20" class="inputsubmit" readonly >
		 <a href="javascript:getprofile()"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"></a>
		 <input type="text" name="menu_name" value="" size="20" class="input_data2" readonly >
		</td>
	</tr>
	 <tr>
	  <td width="20%" class="c_title_1">
	  <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;청구지역코드
	  </td>
	  <td colspan="3" class="c_data_1">
		<select name="pr_location" class="input_re">
		 <%
		 String pr_location = ListBox(request, "SL0018" ,house_code+"#M062#", "");
		 out.println(pr_location);
		 %>
		</select>
	   </td>
	</tr>
	<tr>
	  <td width="20%" class="c_title_1">
	  <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;통제부서 여부
	  </td>
	  <td class="c_data_1" colspan="3">
		<input type="checkbox" name="ctrl_dept_flag" value="checkbox">
		<input type="hidden" name="ctrl_dept_flag2" value="">
		</td>
	</tr>
	<tr>
	  <td width="20%" class="c_title_1">
	  <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;전화번호</td>
	  <td class="c_data_1" colspan="3">
		<input type="text" name="phone_no" size="25" maxlength="20" class="inputsubmit">
		</td>
	</tr>
	<tr>
	  <td width="20%" class="c_title_1">
	  <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;팩스번호</td>
	  <td class="c_data_1" colspan="3">
		<input type="text" name="fax_no" size="25" maxlength="20" class="inputsubmit">
	  </td>
	</tr>
   	<tr>
	  <td width="20%" class="c_title_1">
	  	<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 상위부서</td>
	  <td class="c_data_1" colspan="3">
	    <input type="text" name="high_dept" value="" size="10" class="inputsubmit" readonly>
		<a href="javascript:searchProfile('high_dept')"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="" /></a>
		<input type="text" name="high_dept_text" value="" size="20" class="inputsubmit" readOnly>
		<input type="hidden" name="text_company_code2" value="">
	  </td>
	</tr>
 	<tr>
	  <td width="20%" class="c_title_1">
	  	<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> Level
	  </td>
	  <td class="c_data_1" colspan="3">
		<input type="text" value="" name="dept_level" size="30" maxlength="10" class="inputsubmit" />
	  </td>
	</tr>
  </table>
 </form>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</s:header>
<s:footer/>
</body>
</html>
