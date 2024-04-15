<!--사용자 상세조회-->
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<!-- PROCESS ID 선언 -->

<!-- PROCESS ID = MASTER.사용자관리 = p0030 -->
<% String WISEHUB_PROCESS_ID= "p0030"; %>


<!-- Session 정보 //Parameter 정보 -->
<%

	String house_code  = info.getSession("HOUSE_CODE");	
	String vendor_code = info.getSession("COMPANY_CODE");
	String user_id     = JSPUtil.nullToEmpty(request.getParameter("user_id"));
%>


<%
	String PASSWORD         = "";
	String USER_TYPE        = "";
	String USER_NAME_LOC    = "";
	String USER_NAME_ENG    = "";
	String DEPT             = "";
	String EMPLOYEE_NO      = "";
	String EMAIL            = "";
	String PHONE_NO1        = "";
	String PHONE_NO2        = "";
	String POSITION         = "";
	String MANAGER_POSITION = "";
	String FAX_NO           = "";
	String ZIP_CODE         = "";
	String ADDRESS_LOC      = "";
	String ADDRESS_ENG      = "";
	String LANGUAGE         = "";
	String TIME_ZONE        = "";
	String COUNTRY          = "";
	String CITY_CODE        = "";


if( user_id != "" )  {
	
	String[] args = {house_code, user_id};
	Object[] obj = {(Object[])args};

	SepoaOut value = ServiceConnector.doService(info, "s6030", "CONNECTION","getDisplay_ict", obj);
	if(value.status == 1)
	{
		SepoaFormater wf = new SepoaFormater(value.result[0]);
		if ( wf.getRowCount() > 0 ){
			
			PASSWORD         = wf.getValue("PASSWORD", 0);
			USER_TYPE        = wf.getValue("USER_TYPE", 0);
			                 
			USER_NAME_LOC    = wf.getValue("USER_NAME_LOC", 0);
			USER_NAME_ENG    = wf.getValue("USER_NAME_ENG", 0);
			DEPT             = wf.getValue("DEPT", 0);
			EMPLOYEE_NO      = wf.getValue("EMPLOYEE_NO", 0);
			EMAIL            = wf.getValue("EMAIL", 0);
			PHONE_NO1        = wf.getValue("PHONE_NO1", 0);
			PHONE_NO2        = wf.getValue("PHONE_NO2", 0);
			POSITION         = wf.getValue("POSITION", 0);
			MANAGER_POSITION = wf.getValue("MANAGER_POSITION", 0);
			FAX_NO           = wf.getValue("FAX_NO", 0);
			ZIP_CODE         = wf.getValue("ZIP_CODE", 0);
			ADDRESS_LOC      = wf.getValue("ADDRESS_LOC", 0);
			ADDRESS_ENG      = wf.getValue("ADDRESS_ENG", 0);
			LANGUAGE         = wf.getValue("LANGUAGE", 0);
			TIME_ZONE        = wf.getValue("TIME_ZONE", 0);
			COUNTRY          = wf.getValue("COUNTRY", 0);
			CITY_CODE        = wf.getValue("CITY_CODE", 0);
		}
	}
}

	
%>

<html>

<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ include file="/include/include_css.jsp"%>

<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" align="left" class="title_page" vAlign="bottom">
	  	사용자 상세조회
	  	</td>
	</tr>
</table>

<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
  
 <%--  <script language="javascript">rdtable_top1()</script> --%>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <form name="form" method="post">
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 사용자 구분</td>
      <td class="data_td" width="35%" >Supplier
        <input type="hidden" name="user_type" value="S" class="input_data2" readonly  >
      </td>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업무권한</td>
      <td class="data_td">
       	<input type="text" name="work_type" class="input_data2" readonly value="<%=USER_TYPE%>" >
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 회사코드</td>
      <td class="data_td" colspan="3">
        <input type="text" name="company_code" value="<%=vendor_code%>" class="input_data2" readonly  >
      </td>
    </tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>		
  
<%-- <script language="javascript">rdtable_bot1()</script>   --%>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td height="30" align="right">
			<TABLE cellpadding="0" cellspacing="0">
				<TR>
					<TD><script language="javascript">btn("javascript:parent.window.close()","닫 기")</script></TD>
				</TR>
			</TABLE>
  		</td>
	</tr>
</table>

<%-- <script language="javascript">rdtable_top1()</script> --%>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 사용자 ID<br>
      </td>
	<td class="data_td" width="35%" colspan="3">
		<table cellpadding="0">
			<tr>
				<td>
					<input type="text" name="user_id" size="15" maxlength="10" class="input_data2" value="<%=user_id%>" readonly>
				</td>        
				
			</tr>
		</table>
		<input type="hidden" name="duplicate" value="F">
	</td>      
    </tr>

	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 사용자명(국문)</td>
      <td class="data_td" colspan="3">
        <input type="text" name="user_name_loc" size="20" maxlength="40" class="input_data2" readonly value="<%=USER_NAME_LOC%>">
      </td>
      <td class="title_td" style="display:none">
      	&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 사용자명(영문)
      </td>
      <td class="data_td" style="display:none">
        <input type="text" name="user_name_eng" size="20" maxlength="40" class="input_data2" readonly value="<%=USER_NAME_ENG%>">
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 회사코드 </td>
      <td class="data_td" colspan="3">
         <input type="text" name="text_company_code2" size="20"  value="<%=vendor_code%>" class="input_data2" readonly  >
      </td>
      <td class="title_td" style="display:none">
      	&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 부서명
      </td>
      <td class="data_td" style="display:none">
        <input type="text" name="dept"  size="20" maxlength="100" class="input_data2" readonly value="<%=DEPT%>" >
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
    <tr style="display:none">
      <td class="title_td" width="15%">
      	&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 사원번호
      </td>
      <td class="data_td" colspan="3" width="85%">
        <input type="text" name="employee_no" size="20" maxlength="20" class="input_data2" readonly value="<%=EMPLOYEE_NO%>">       
      </td>
    </tr>
	<tr style="display:none">
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 전화번호</td>
      <td class="data_td">
        <input type="text" name="phone_no" size="20" maxlength="20" class="input_data2" readonly value="<%=PHONE_NO1%>">
      </td>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 이메일</td>
      <td class="data_td">
        <input type="text" name="email" size="30" maxlength="50" class="input_data2" readonly value="<%=EMAIL%>">
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 휴대폰</td>
      <td class="data_td" colspan="3">
        <input type="text" name="phone_no2" size="20" maxlength="20" class="input_data2" readonly value="<%=PHONE_NO2%>">
      </td>
      <td class="title_td" style="display:none">
      	&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
      	&nbsp;&nbsp; 팩스번호
      </td>
      <td class="data_td" style="display:none">
        <input type="text" name="fax_no" size="20" maxlength="20" class="input_data2" readonly value="<%=FAX_NO%>">
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr style="display:none">
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 직위</td>
      <td class="data_td" width="35%">

        <input type="text" name="position" value="<%=POSITION%>" size="5" maxlength="10" class="input_data2" readonly>
       
      </td>
        <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 직책</td>
     	<td class="data_td">
        <input type="text" name="manager_position" value="<%=MANAGER_POSITION%>" size="5" maxlength="10" class="input_data2" readonly >
        
       </td>
    </tr>
	<tr style="display:none">
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr style="display:none">
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 사용언어</td>
      <td class="data_td" colspan="3">
        <input type="text" name="language" value="<%=LANGUAGE%>" size="5" class="input_data2" readonly >
    </tr>
	<tr style="display:none">
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr style="display:none">
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 우편번호</td>
      <td class="data_td">
        <input type="text" name="zip_code" size="20" maxlength="10" class="input_data2" readonly value="<%=ZIP_CODE%>">
      </td>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 시간대역</td>
      <td class="data_td" width="35%">
        <input type="text" name="time_zone" value="<%=TIME_ZONE%>" size="5" class="input_data2" readonly >
      </td>
    </tr>
	<tr style="display:none">
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
     <tr style="display:none">
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 국가</td>
      <td class="data_td" width="35%">
        <input type="text" name="country" value="<%=COUNTRY%>" size="5" class="input_data2" readonly >
	<input type="text" name="text_country" value="한국" size="15" maxlength="15" class="input_data2" readOnly >
      </td>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 도시</td>
      <td class="data_td" width="35%">
        <input type="text" name="city_code" value="<%=CITY_CODE%>" size="5" maxlength="10" class="input_data2" readonly>
      </td>
    </tr>
	<tr style="display:none">
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 주소(한글)</td>
      <td class="data_td" colspan="3">
        <input type="text" name="address_loc" size="90" maxlength="200" class="input_data2" readonly value="<%=ADDRESS_LOC%>">
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr style="display:none">
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 주소(영문)</td>
      <td class="data_td" colspan="3">
        <input type="text" name="address_eng" size="90" maxlength="200" class="input_data2" readonly value="<%=ADDRESS_ENG%>">
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
      <td>
      <input type="hidden" name="duplicate2" value="F">
      <input type="hidden" name="edit" value="Y">
      </td>
    </tr>
  </table>
  </form>
</body>
</html>
