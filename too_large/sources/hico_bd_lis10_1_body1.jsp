<!-- 사용 언어 설정 -->
<% String WISEHUB_LANG_TYPE="KR";%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	String ret = null;
	
	SepoaFormater wf = null;	
	SepoaOut value = null; 
	SepoaRemote ws = null;	
	
	String vendor_code      = JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
	String sg_refitem       = JSPUtil.nullToEmpty(request.getParameter("sg_refitem"));
	String buyer_house_code = JSPUtil.nullToEmpty(request.getParameter("buyer_house_code"));
	
	//WiseInfo info = new WiseInfo(buyer_house_code,"HOUSE_CODE="+buyer_house_code+"^@^ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
	
	String popup       = JSPUtil.nullToEmpty(request.getParameter("popup"));
	
	String nickName= "p0070";
	String conType = "CONNECTION";
	String MethodName = "getVenScrRst";
	Object[] obj = { vendor_code, sg_refitem };
	
	String MAX_SCALE_COUNT = "";
	String s_template_refitem = "";
	
	try 
	{
		ws = new SepoaRemote(nickName, conType, info);
		value = ws.lookup(MethodName,obj);
		ret = value.result[0];
		wf =  new SepoaFormater(ret);
		MAX_SCALE_COUNT = wf.getValue("MAX_SCALE_COUNT", 0);
		s_template_refitem = wf.getValue("S_TEMPLATE_REFITEM", 0);
	}
	catch(SepoaServiceException wse) 
	{
		Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);	
		Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	}
	catch(Exception e) 
	{
	    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	    
	}
	finally
	{
		try
		{
			ws.Release();
		}
		catch(Exception e)
		{
		}
	}
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript">
	function NextPage()
	{
		parent.parent.up.MM_showHideLayers('m1','','show','m2','','hide','m3','','show','m4','','show','m5','','show','m6','','show','m7','','show','m11','','hide','m22','','show','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','hide');
		parent.parent.up.goPage('cp');
	}
	/*
	function BackPage()
	{
		parent.parent.up.MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','hide','m6','','show','m7','','show','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','show','m66','','hide','m77','','hide');
		parent.parent.up.goPage('pi');
	}
	*/
	function BackPage()
	{
		parent.parent.up.MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','hide','m5','','show','m6','','show','m7','','show','m11','','hide','m22','','hide','m33','','hide','m44','','show','m55','','hide','m66','','hide','m77','','hide');
		parent.parent.up.goPage('qr');
	}
	
	function doConfirm()
	{	
		if(!confirm("아이디신청 하시겠습니까?"))
			return;

		var f = document.form1;
	
		f.mode.value= "doConfirm";
		f.method 	= "post"
		f.action 	= "hico_scr_ins1.jsp";
    	f.submit();
    	
		
	}
	
	function setData(){
		  /*
		  	alert("업체등록평가평가 항목이 없습니다.");
		  	return;
		  */
		  // 소싱그룹 필수체크

		  var f = document.form1;
/* 		  var s_type1 = parent.parent.lis10_top.document.forms[0].s_type1.value; // 소싱대분류
		  var s_type2 = parent.parent.lis10_top.document.forms[0].s_type2.value; // 소싱중분류
		  var s_type3 = parent.parent.lis10_top.document.forms[0].s_type3.value; // 소싱소분류

		  if(s_type1 == "" || s_type2 == "" || s_type3 == ""){
		  	alert("소싱그룹 대분류,중분류,소분류를 모두 선택해주세요.");
		  	return;
		  }

		  document.forms[0].s_type1.value = s_type1;
		  document.forms[0].s_type2.value = s_type2;
		  document.forms[0].s_type3.value = s_type3; */
		  
// 		  alert(f.s_type1.value);

		  var value = confirm('저장하시겠습니까?');
			if(value){
				f.mode.value= "doModify";
				f.action = "hico_scr_ins1.jsp";
		    	f.submit();
			}

	}
	
	function checkData(cnt, value) {
	    <%if( wf.getRowCount()==1){%>
	    document.all.answered_seq.value = value;
	    <%}else{%>
	    document.getElementsByName("answered_seq")[cnt].value = value;
	    //document.all.answered_seq[cnt].value = value;
	    <%}%>
	}
	</script>

	
</head>

<body bgcolor="" text="#000000" leftmargin="0" topmargin="0">
<table border=0 cellpadding=0 cellspacing=0 width="100%">
<form id="form1" name="form1">
<input type="hidden" id="mode"					name="mode"				>
<input type="hidden" id="vendor_code" 			name="vendor_code" 			value="<%=vendor_code%>">
<input type="hidden" id="buyer_house_code"		name="buyer_house_code"		value="<%=buyer_house_code%>">
<input type="hidden" id="sg_refitem" 			name="sg_refitem" 			value="<%=sg_refitem%>">
<input type="hidden" id="s_template_refitem" 	name="s_template_refitem" 	value="<%=s_template_refitem%>">

	<tr>
		<td>
			<table border=0 cellpadding=0 cellspacing=0 width="100%"  style="display: none;">
			<input type="hidden" name="s_factor_refitem" value=""><!-- 문제번호-->
            <input type="hidden" name="answered_seq"><!--선택된 값이 담긴다.-->
			  <tr height=25>
				<td colspan="<%=MAX_SCALE_COUNT%>" class="c_title_1" width="100%">
					<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;<strong></strong></div>
					<input type="hidden" name="chk" value="1">
				</td>
			  </tr>
		</table>
		</td>
	</tr>
	<tr>
	
	<TD height="30" align="right">
<% 

	if(popup == null || popup.equals("") || popup.equals("T") ){ 
%>
		<TABLE cellspacing="0" cellpadding="0">
		<TR>
			<!-- 스크린닝 항목 저장 후 조회시-->
			<!--
			<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/btn_left.gif" width="10" height="25" /></TD>
			<TD background="/images/<%=info.getSession("HOUSE_CODE")%>/btn_bg.gif" class="btn" height="25"><a href="javascript:BackPage();" class="btn">이전</a></TD>
			<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>//btn_right.gif" width="10" height="25" /></TD>
			-->			
<%
		if(!popup.equals("T")){
%>			
			<!--
			<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/btn_left.gif" width="10" height="25" /></TD>
			<TD background="/images/<%=info.getSession("HOUSE_CODE")%>/btn_bg.gif" class="btn" height="25"><a href="javascript:doConfirm();" class="btn">아이디신청</a></TD>
			<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>//btn_right.gif" width="10" height="25" /></TD>
			-->
<!-- 			<TD><script language="javascript">btn("javascript:doConfirm()",21,"아이디신청")</script></TD> -->
			<TD><script language="javascript">btn("javascript:setData()","저 장")</script></TD>
<%
		}
%>
<%-- 		<TD><script language="javascript">btn("javascript:BackPage()","이 전")</script></TD> --%>
		</TR>
		</TABLE>
<%
	}
%>
	</TD>	
	</tr>
</table>
</form>
</body>
</html>