<%--
È­¸é¸í  : »ç¿ëÀÚ »ó¼¼Á¶È¸ (/kr/master/user/use_bd_dis2.jsp)
--%>
<%@ include file="/include/wisehub_common.jsp" %>
<%@ include file="/include/admin_common.jsp"%>
<%@ include file="/include/wisehub_session.jsp" %>
<%@ include file="/include/code_common.jsp"%>
<%
	String house_code = info.getSession("HOUSE_CODE");
	String i_user_id = JSPUtil.CheckInjection(request.getParameter("i_user_id"));
%>


<%
	String password                = "" ;
	String user_name_loc           = "" ;
	String user_name_eng           = "" ;
	String company_name_loc        = "" ;
	String dept_name_loc           = "" ;
	String resident_no             = "" ;
	String employee_no             = "" ;
	String phone_no                = "" ;
	String email                   = "" ;
	String mobile_no               = "" ;
	String fax_no                  = "" ;
	String position_name           = "" ;
	String language_name           = "" ;
	String time_zone               = "" ;
	String zip_code                = "" ;
	String dely_zip_code           = "" ;
	String country_name            = "" ;
	String city_name               = "" ;
	String state                   = "" ;
	String address_loc             = "" ;
	String dely_address_loc        = "" ;
	String address_eng             = "" ;
	String pr_location_name        = "" ;
	String dept                    = "" ;
	String position                = "" ;
	String city_code               = "" ;
	String pr_location             = "" ;
	String company_code            = "" ;
	String language                = "" ;
	String country                 = "" ;
	String menu_profile_code       = "" ;
	String menu_profile_name       = "" ;
	String manager_position        = "" ;
	String manager_position_name   = "" ;
	String user_type               = "" ;
	String text_user_type          = "" ;
	String work_type               = "" ;
	String text_work_type          = "" ;
	String ctrl_code               = "" ;
	String time_zone_name          = "" ;
	
	String[] args = {i_user_id};
	Object[] obj = {(Object[])args};
	
	WiseOut value = ServiceConnector.doService(info, "p0030", "CONNECTION","getDisplay", obj);
    
	if(value.status == 1) 
	{
		WiseFormater wf = new WiseFormater(value.result[0]);
		
		if ( wf.getRowCount() > 0 ) {
		
			password                = wf.getValue("PASSWORD"             , 0) ;
			user_name_loc           = wf.getValue("USER_NAME_LOC"        , 0) ;
			user_name_eng           = wf.getValue("USER_NAME_ENG"        , 0) ;
			company_name_loc        = wf.getValue("COMPANY_NAME_LOC"     , 0) ;
			dept_name_loc           = wf.getValue("DEPT_NAME_LOC"        , 0) ;
			resident_no             = wf.getValue("RESIDENT_NO"          , 0) ;
			employee_no             = wf.getValue("EMPLOYEE_NO"          , 0) ;
			phone_no                = wf.getValue("PHONE_NO"             , 0) ;
			email                   = wf.getValue("EMAIL"                , 0) ;
			mobile_no               = wf.getValue("MOBILE_NO"            , 0) ;
			fax_no                  = wf.getValue("FAX_NO"               , 0) ;
			position_name           = wf.getValue("POSITION_NAME"        , 0) ;
			language_name           = wf.getValue("LANGUAGE_NAME"        , 0) ;
			time_zone               = wf.getValue("TIME_ZONE"            , 0) ;
			country_name            = wf.getValue("COUNTRY_NAME"         , 0) ;
			city_name               = wf.getValue("CITY_NAME"            , 0) ;
			state                   = wf.getValue("STATE"                , 0) ;
			zip_code                = wf.getValue("ZIP_CODE"             , 0) ;
			address_loc             = wf.getValue("ADDRESS_LOC"          , 0) ;
			address_eng             = wf.getValue("ADDRESS_ENG"          , 0) ;
			dely_zip_code           = wf.getValue("DELY_ZIP_CODE"        , 0) ;
			dely_address_loc        = wf.getValue("DELY_ADDRESS_LOC"     , 0) ;
			pr_location_name        = wf.getValue("PR_LOCATION_NAME"     , 0) ;
			dept                    = wf.getValue("DEPT"                 , 0) ;
			position                = wf.getValue("POSITION"             , 0) ;
			city_code               = wf.getValue("CITY_CODE"            , 0) ;
			pr_location             = wf.getValue("PR_LOCATION"          , 0) ;
			company_code            = wf.getValue("COMPANY_CODE"         , 0) ;
			language                = wf.getValue("LANGUAGE"             , 0) ;
			country                 = wf.getValue("COUNTRY"              , 0) ;
			menu_profile_code       = wf.getValue("MENU_PROFILE_CODE"    , 0) ;
			menu_profile_name       = wf.getValue("MENU_PROFILE_NAME"    , 0) ;
			manager_position        = wf.getValue("MANAGER_POSITION"     , 0) ;
			manager_position_name   = wf.getValue("MANAGER_POSITION_NAME", 0) ;
			user_type               = wf.getValue("USER_TYPE"            , 0) ;
			text_user_type          = wf.getValue("TEXT_USER_TYPE"       , 0) ;
			work_type               = wf.getValue("WORK_TYPE"            , 0) ;
			text_work_type          = wf.getValue("TEXT_WORK_TYPE"       , 0) ;
			ctrl_code               = wf.getValue("CTRL_CODE"            , 0) ;
			time_zone_name          = wf.getValue("TIME_ZONE_NAME"       , 0) ;
		}
	}
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-kr">
<%@ include file="/include/wisehub_scripts.jsp" %>
</head>

<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="cell_title1" width="78%" align="left">&nbsp;
	  	<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" align="absmiddle" width="12" height="12">
	  	&nbsp;»ç¿ëÀÚ »ó¼¼Á¶È¸
	  	</td>
	</tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="760" height="2" bgcolor="#0072bc"></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
<form name="form" method="post" target="work" action="/kr/master/user/use_wk_upd2.jsp">
	<tr>
	  <td class="c_title_1"  width="20%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> »ç¿ëÀÚ ±¸ºÐ</td>
	  <td class="c_data_1_p" width="30%">
		<input type="text" name="text_user_type" class="input_data1"  value="<%=text_user_type%>" readonly  >
		<input type="hidden" name="user_type"  value="<%=user_type%>"  >
	  </td>
	  <td class="c_title_1"  width="20%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> È¸»çÄÚµå</td>
	  <td class="c_data_1_p" width="30%">
		<input type="hidden" name="company_code" value="<%=company_code%>">
		<input type="text" name="text_company_code" class="input_data1"  value="<%=company_name_loc%>" size="30" readonly>
	  </td>
	</tr>
	<tr>
	  <td class="c_title_1" ><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ¾÷¹«±ÇÇÑ</td>
	  <td class="c_data_1_p" colspan="3">
		<input type="text" name="text_work_type" class="input_data1"  value="<%=text_work_type%>" readonly  >
		<input type="hidden" name="work_type"  value="<%=work_type%>"  >
	  </td>
	</tr>
</table>

<br>

<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
	<tr>
	  <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> »ç¿ëÀÚ ID </td>
	  <td class="c_data_1_p" colspan="3"><%=i_user_id%></td>
	</tr>
	<tr>
	  <td class="c_title_1"  width="20%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> »ç¿ëÀÚ¸í(±¹¹®)</td>
	  <td class="c_data_1_p" width="30%"><%=user_name_loc%></td>
	  <td class="c_title_1"  width="20%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> »ç¿ëÀÚ¸í(¿µ¹®)</td>
	  <td class="c_data_1_p" width="30%"><%=user_name_eng%></td>
	</tr>
	<tr>
	  <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ºÎ¼­ÄÚµå</td>
	  <td class="c_data_1_p"><%=dept%></td>
	  <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> »ç¿ø¹øÈ£</td>
	  <td class="c_data_1_p"><%=employee_no%></td>
	</tr>
	<tr>
	  <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> Á÷À§</td>
	  <td class="c_data_1_p" colspan="3"><%=position_name%></td>
	  <!--
	  <td class="c_title_1"><img src="/images/<//%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> Á÷Ã¥</td>
	  <td class="c_data_1_p"><//%=manager_position_name%></td>
	  -->
	</tr>
</table>

<br>

<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
	 <tr>
	  <td class="c_title_1"  width="20%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ±¹°¡</td>
	  <td class="c_data_1_p" width="30%"><%=country_name%></td>
	  <td class="c_title_1"  width="20%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> µµ½Ã</td>
	  <td class="c_data_1_p" width="30%"><%=city_name%></td>
	</tr>
	<tr>
	  <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> Ã»±¸Áö¿ª</td>
	  <td class="c_data_1_p"><%=pr_location_name%></td>
	  <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> Áö¿ª(only U.S.A)</td>
  	  <td class="c_data_1_p"><%=state%></td>
	</tr>
	<tr>
	  <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ½Ã°£´ë¿ª</td>
	  <td class="c_data_1_p"><%=time_zone_name%></td>
	  <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> »ç¿ë¾ð¾î</td>
	  <td class="c_data_1_p"><%=language_name%></td>
	 </tr>
</table>

<br>

<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
	<tr>
	  <td class="c_title_1"  width="20%" colspan="2"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ÀüÈ­¹øÈ£</td>
	  <td class="c_data_1_p" width="30%"><%=phone_no%></td>
	  <td class="c_title_1"  width="20%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ÆÑ½º¹øÈ£</td>
	  <td class="c_data_1_p" width="30%"><%=fax_no%></td>
	</tr>
	<tr>
	  <td class="c_title_1" colspan="2"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ÈÞ´ëÆù</td>
	  <td class="c_data_1_p"><%=mobile_no%></td>
	  <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ÀÌ¸ÞÀÏ</td>
	  <td class="c_data_1_p"><%=email%></td>
	</tr>
	<tr>
	  <td class="c_title_1" rowspan="2"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ÁÖ ¼Ò</td>
	  <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ±âº»ÁÖ¼Ò</td>
	  <td class="c_data_1_p" colspan="3"><%=zip_code%><br><%=address_loc%></td>
	</tr>
	<tr>
	  <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ¹è¼ÛÁöÁÖ¼Ò</td>
	  <td class="c_data_1_p" colspan="3"><%=dely_zip_code%><br><%=dely_address_loc%></td>
	</tr>
	<!--
	<tr>
	  <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ÇÁ·ÎÆÄÀÏÄÚµå</td>
	  <td class="c_data_1_p" colspan="3"><%=menu_profile_name%> &nbsp;&nbsp;<%=menu_profile_code%></td>
	</tr>
	-->
  </table>
  
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	 	<tr>
	   		<td height="30" align="right">
		<TABLE cellpadding="0">
	     		<TR>
					<TD><script language="javascript">btn("javascript:window.close()",36,"´Ý ±â")</script></TD>
	  	  		</TR>
	   			</TABLE>
	   		</td>
	 	</tr>
	</table>   
</form>
</body>
</html>
