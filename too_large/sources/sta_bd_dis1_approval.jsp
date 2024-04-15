<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/kr/master/vendor/sta_bd_con.jsp -->
<!--
 Title:         신규공급업체등록품의서
 Description:
 Copyright:    Copyright (c)
 Company:      ICOMPIA <p>
 @author       SHYI<p>
 @version      1.0
 @Comment
-->

<!-- PROCESS ID 선언 -->
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	String user_id 			= info.getSession("ID");
	String user_name_loc 	= info.getSession("NAME_LOC");
	String user_name_eng 	= info.getSession("NAME_ENG");
	String user_dept 		= info.getSession("DEPARTMENT");
	String company_code 	= info.getSession("COMPANY_CODE");
	String house_code 		= info.getSession("HOUSE_CODE");
	String ctrl_code      	= info.getSession("CTRL_CODE");
	String VENDOR_CODE		= JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
	String sign_enable 		= JSPUtil.nullToEmpty(request.getParameter("sign_enable"));
	String doc_no   = VENDOR_CODE;
	String doc_type = "VM";
	String doc_seq          = JSPUtil.nullToEmpty(request.getParameter("doc_seq"));
	String sign_path_seq	= JSPUtil.nullToEmpty(request.getParameter("sign_path_seq"));//결재순번
	String proceeding_flag	= JSPUtil.nullToEmpty(request.getParameter("proceeding_flag"));//결재요청상태(합의, 결재)
	String doc_status		= JSPUtil.nullToEmpty(request.getParameter("doc_status"));
	String VENDOR_NAME		= "";
	String CEO_NAME_LOC   	= "";
	String CREDIT_RATING  	= "";
	String ADDRESS_LOC		= "";
	String SHIPPER_TYPE   	= "";
	String VENDOR_TYPE    	= "";
	String IRS_NO	    	= "";
	String CUSTOMER			= "";
    String REG_REMARK    	= "";
    String TECH_RISE	    = "";
    String INDUSTRY_TYPE    = "";
    String BUSINESS_TYPE    = "";
    String BIZ_CLASS4 = "";
    String[] args = {house_code,null,null,VENDOR_CODE,null,null,null};
    Object[] obj = {args};
    SepoaOut value = ServiceConnector.doService(info, "p0010", "CONNECTION", "getVendorList2", obj);

    SepoaFormater wf = new SepoaFormater(value.result[0]);
		if(wf.getRowCount() > 0) {
			VENDOR_CODE		    = wf.getValue("VENDOR_CODE"		, 0);
			VENDOR_NAME		    = wf.getValue("VENDOR_NAME"		, 0);
			CEO_NAME_LOC   	    = wf.getValue("CEO_NAME_LOC"   	, 0);
			CREDIT_RATING  	    = wf.getValue("CREDIT_RATING"  	, 0);
			ADDRESS_LOC		    = wf.getValue("ADDRESS_LOC"		, 0);
			SHIPPER_TYPE   	    = wf.getValue("SHIPPER_TYPE"   	, 0);
			VENDOR_TYPE    	    = wf.getValue("VENDOR_TYPE"    	, 0);
			IRS_NO	    	    = wf.getValue("IRS_NO"	    	, 0);
			CUSTOMER			= wf.getValue("CUSTOMER"		, 0);
			REG_REMARK    	    = wf.getValue("REG_REMARK"    	, 0);
			TECH_RISE	        = wf.getValue("TECH_RISE"	    , 0);
			INDUSTRY_TYPE       = wf.getValue("INDUSTRY_TYPE"	    , 0);
			BUSINESS_TYPE       = wf.getValue("BUSINESS_TYPE"	    , 0);
			BIZ_CLASS4       = wf.getValue("BIZ_CLASS4"        , 0);


		}
%>
<html>
<head>
<title>
	우리은행 전자구매시스템
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript" type="text/javascript">

	function credit_query(){
		window.open("http://clip.nice.co.kr/rep_nclip/rep_DLink/rep_Link_CJSystems.jsp?bz_ins_no=<%=IRS_NO%>",'subpop','width=850,height=660,left=40,top=20,resizable=yes')
	}
	function approvalSign(){
		childframe.location.href='/kr/admin/basic/approval/approval.jsp?house_code=<%=info.getSession("HOUSE_CODE")%>&company_code=<%=info.getSession("COMPANY_CODE")%>&dept_code=<%=info.getSession("DEPARTMENT")%>&req_user_id=<%=info.getSession("ID")%>&doc_type=VM&fnc_name=getApproval';
	}

	function approval(){
        if(!confirm("결재요청 하시겠습니까?")) return;
	        approvalSign();
	}


	function getApproval(str){
	    if(str == '') return;

	    var sign_flag = "";
	    saveRock = true;

	    if(str=="SAVE")
	        sign_flag = "T";   // 작성중
	    else
	        sign_flag = "P";   // 결재중(결재상신)

	    document.forms[0].SIGN_FLAG.value	= sign_flag			;
	    document.forms[0].APPROVAL.value	= str				;
		document.forms[0].CTRL_CODE.value	= "<%=ctrl_code%>"	;

		document.forms[0].method = "POST";
	    document.forms[0].action = "sta_wk_ins1.jsp"
	    document.forms[0].target = "childframe"
	    document.forms[0].submit();
	}
	function Saved(message, v_status){
		alert(message);
		location.href = "sta_bd_lis1.jsp"
	}
	function descVendor(){
		window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code=<%=VENDOR_CODE%>","ven_bd_con","left=0,top=0,width=900,height=600,resizable=yes,scrollbars=yes");
	}

	function sign_popup(){
		var sign_url = "/kr/admin/basic/approval2/ap2_pp_lis7.jsp?company_code=<%=info.getSession("COMPANY_CODE")%>&doc_type=VM&doc_no=<%=doc_no%>&doc_seq=<%=doc_seq%>";
		//var sign_popup = window.open(sign_url, "BKWin", "left=1200, top=0, width=400, height=400", "toolbar=no", "menubar=no", "status=yes", "scrollbars=no", "resizable=no");
	}

	// 결재선변경
	function changeApprovalLine(doc_type ,doc_no ,doc_seq, sign_path_seq){
		if("<%=proceeding_flag%>" != "P"){
			alert("결재선추가는 결재자만 가능합니다.");
			return;
		}
		CodeSearchCommon("/kr/admin/basic/approval2/ap2_pp_upd3.jsp?doc_type="+doc_type+"&doc_no="+doc_no+"&doc_seq="+doc_seq+ "&sign_path_seq="+sign_path_seq+"&issue_type=&fnc_name=getApproval","pop_up","","","700","320");
	}
</script>

</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" onLoad="sign_popup();">
<form name="form" method="post" action="">
	<input type="hidden" name="partner_code">
  <style type="text/css">
<!--
.style1 {
	color: #000000;
	font-size: 18px;
	font-weight: bold;
}
-->
</style>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td  height="20"></td>
   </tr>
   <tr>
     <td align="center" class="style1">
		신규협력업체 등록품의
     </td>
   </tr>
   <tr>
     <td  height="20">&nbsp;</td>
   </tr>
 </table>
<input type="hidden" name="SIGN_FLAG" value="">
<input type="hidden" name="APPROVAL" value="">
<input type="hidden" name="CTRL_CODE" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<!-- 결재라인 시작 -->
    	<table border="0" cellspacing="1" cellpadding="0" bgcolor="#000000" align="right">
      		<tr bgcolor="#FFFFFF">
        		<td width="32" align="center" bgcolor="#CCCCCC" class="title_td" >결<br>재</td>
<%
    Object[] obj_sign = {doc_no,doc_type,doc_seq};	//기안자 + 결재자
    SepoaOut value_sign = ServiceConnector.doService(info,"p6029","CONNECTION","getSignPath2",obj_sign);
    SepoaFormater wf_sign = new SepoaFormater(value_sign.result[0]);

    Object[] obj_agree = {doc_no,doc_type,doc_seq}; //합의자
    SepoaOut value_agree = ServiceConnector.doService(info,"p6029","CONNECTION","getSignAgree2",obj_agree);
    SepoaFormater wf_agree = new SepoaFormater(value_agree.result[0]);

    int approvalCnt = wf_sign.getRowCount()-wf_agree.getRowCount() > 0 ?  wf_sign.getRowCount() : wf_sign.getRowCount()-wf_agree.getRowCount() == 0 ? wf_sign.getRowCount() :  wf_agree.getRowCount();   //결재라인수

 	String app_attach_no = "";
 	String POSITION_TEXT = "";
 	String USER_NAME_LOC = "";
 	String SIGN_DATE     = "";
 	String SIGN_TIME     = "";
 	String APP_STATUS    = "";

    for(int i = 0 ; i<approvalCnt; i++) {
		if (i == 0) {
			app_attach_no = wf_sign.getValue("ATTACH_NO"		, i);
		}

		if(i < wf_sign.getRowCount()){
			POSITION_TEXT 	=	wf_sign.getValue("POSITION_TEXT"		, i);
			USER_NAME_LOC 	=	wf_sign.getValue("USER_NAME_LOC"		, i);
			SIGN_DATE 	    =	wf_sign.getValue("SIGN_DATE"			, i);
			SIGN_TIME 	    =	wf_sign.getValue("SIGN_TIME"			, i);
			APP_STATUS 	    =	wf_sign.getValue("APP_STATUS"			, i);

%>
	        <td width="110">
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center"><%=USER_NAME_LOC%></td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">
    	<%
       		if(APP_STATUS.equals("A")) { //기안
    	%>
              				기 안<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_2.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else if(APP_STATUS.equals("E")) { // 승인 %>
              				승 인<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_1.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else if(APP_STATUS.equals("R")) { // 반려%>
              				반려<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_3.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else { %>
              &nbsp;
    	<% } %>
              			</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="20" class="input_data2" align="center"><%=SIGN_DATE%></td>
            		</tr>
        		</table>
        	</td>
<%
		}else {
%>
			 <td width="110">
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
        		</table>
        	</td>
<%
		}// end of if
	}//end of for
%>
      </tr>
	  <tr bgcolor="#FFFFFF" style="display:none">
      	<td width="32" align="center" bgcolor="#CCCCCC" class="title_td" >합<br>의</td>
<%

 	POSITION_TEXT = "";
 	USER_NAME_LOC = "";
 	SIGN_DATE = "";
 	SIGN_TIME = "";
 	APP_STATUS = "";

    for(int i = 0 ; i<approvalCnt; i++)
	{
		if(i < wf_agree.getRowCount()){
			POSITION_TEXT 	=	wf_agree.getValue("POSITION_TEXT"			, i);
			USER_NAME_LOC 	=	wf_agree.getValue("USER_NAME_LOC"			, i);
			SIGN_DATE 	    =	wf_agree.getValue("SIGN_DATE"			, i);
			SIGN_TIME 	    =	wf_agree.getValue("SIGN_TIME"			, i);
			APP_STATUS 	    =	wf_agree.getValue("APP_STATUS"			, i);

%>
	        <td width="110">
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center"><%=POSITION_TEXT%></td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">
    	<%
       		if(APP_STATUS.equals("A")) { //기안
    	%>
              				기 안<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_2.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else if(APP_STATUS.equals("E")) { // 승인 %>
              				승 인<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_1.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else if(APP_STATUS.equals("R")) { // 반려%>
              				반 려<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_3.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else { %>
              &nbsp;
    	<% } %>
              			</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="20" class="input_data2" align="center"><%=SIGN_DATE%></td>
            		</tr>
        		</table>
        	</td>
<%
		}else {
%>
			 <td width="110">
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
        		</table>
        	</td>
<%
		}// end of if
	}//end of for
%>
      </tr>
	</table>
<!-- 결재라인 끝-->
</td>
</tr>
</table>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td align="left" class="cell_title1">&nbsp;◆ 협력업체 내역</td>
   </tr>
 </table>

<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr >
    <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업체명</td>
    <td width="20%" class="data_td"><input type="text" name="VENDOR_NAME" style="width:92%" maxlength="500" value="<%=VENDOR_NAME%>" readOnly>
        		<input type="hidden" name="VENDOR_CODE" size="30" class="input_data2" maxlength="50" value="<%=VENDOR_CODE%>" readOnly></td>
    <td width="15%" class="title_td" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 주소</td>
    <td class="data_td"><input type="text" name="ADDRESS_LOC" style="width:92%" maxlength="500" value="<%=ADDRESS_LOC%>" readOnly></td>
  </tr>
  <tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
  </tr>  
  <tr>
    <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 대표자명&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td width="20%" class="data_td"><input type="text" name="CEO_NAME_LOC" style="width:92%" maxlength="8" value="<%=CEO_NAME_LOC%>" readOnly></td>
    <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 거래구분&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td class="data_td"><%=BIZ_CLASS4%></td>
  </tr>
  <tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
  </tr>  
  <tr>
    <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업태</td>
    <td width="20%" class="data_td"><%=INDUSTRY_TYPE%></td>
    <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업종</td>
    <td class="data_td"><%=BUSINESS_TYPE%></td>
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
     <td height="3"></td>
   </tr>
   <tr>
     <td align="left" class="cell_title1">&nbsp;◆ 평가결과</td>
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
    <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 등록사유</td>
    <!--<td class="data_td">
    	<input type="text" name="REG_REMARK" style="width:92%" class="input_data2" maxlength="500" value="<%--=REG_REMARK--%>" readOnly >
    </td>-->
    <td class="data_td"><%=REG_REMARK.replaceAll("\\n","<br>")%></td>
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
	      		<% if ("Y".equals(doc_status)) { %>
	      			<TD><script language="javascript">btn("javascript:opener.btnApprovalAll('2','1','<%=doc_no%>','')","승 인")</script></TD>
		      		<TD><script language="javascript">btn("javascript:opener.btnApprovalAll('3','1','<%=doc_no%>','')","반 려")</script></TD>
<%-- 		      		<TD><script language="javascript">btn("javascript:changeApprovalLine('<%=doc_type%>','<%=doc_no%>','<%=doc_seq%>','<%=sign_path_seq%>')","결재선추가")</script></TD> --%>
		      	<% } %>
	      			<TD><script language="javascript">btn("javascript:window.close()","닫 기")   </script></TD>
	      		</TR>
  			</TABLE>
  		</td>
	</tr>
</table>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td height="3"></td>
   </tr>
   <tr>
     <td align="left" class="cell_title1">&nbsp;◆ 협력업체 상세내역</td>
   </tr>
   <tr>
     <td height="10"></td>
   </tr>
 </table>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td height="3"></td>
   </tr>
   <tr>
     <td align="center">
<iframe src="/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code=<%=VENDOR_CODE%>" name="childFrame" WIDTH="95%" Height="850" border="0" scrolling="no" frameborder="0"></iframe>
</td>
   </tr>
   <tr>
     <td height="10"></td>
   </tr>
 </table>
 <table><tr><td></td></tr></table>
<%-- 결재자 의견 --%>
	<jsp:include page="/include/approvalOpinion.jsp" >
	<jsp:param name="doc_no" 	value="<%=doc_no%>"/>
	<jsp:param name="doc_seq" 	value="<%=doc_seq%>"/>
	<jsp:param name="doc_type" 	value="<%=doc_type%>"/>
	</jsp:include>

</form>
<IFRAME NAME="childframe" STYLE="display : none;"></IFRAME>

	</body>
</html>
