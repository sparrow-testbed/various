<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%

    String to_day    = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date   = to_day;

/*  넘어온 파라미터 값 셋팅  START */
	String ev_no	 	 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("ev_no")));
	String ev_year	 	 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("ev_year")));	
	String sheet_name	 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("sheet_name")));
	String seller_code	 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("seller_code")));
	String seller_name	 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("seller_name")));
	String invest_date	 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("invest_date")));
	String irs_no	 	 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("irs_no")));
	String address_loc	 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("address_loc")));
	String phone_no	 	 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("phone_no")));
	String plant_address = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("plant_address")));
	String phone_no1	 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("phone_no1")));
	String est_desc	 	 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("est_desc")));
	String in_attach_no	 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("in_attach_no")));
	String in_attach_cnt = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("in_attach_cnt")));
/*  넘어온 파라미터 값 셋팅  END */

	HashMap	header = new HashMap();		
  	header.clear();           	
  	header.put("ev_no"         , ev_no);
  	header.put("ev_year"       , ev_year);
	header.put("sheet_name"    , sheet_name);
	header.put("seller_code"   , seller_code);
	header.put("seller_name"   , seller_name);
	header.put("invest_date"   , invest_date.replaceAll("/",""));
	header.put("irs_no"        , irs_no);
	header.put("address_loc"   , address_loc);
	header.put("phone_no"      , phone_no);
	header.put("plant_address" , plant_address);
	header.put("phone_no1"     , phone_no1);
	header.put("est_desc"      , est_desc);
	header.put("in_attach_no"  , in_attach_no);
	header.put("in_attach_cnt" , in_attach_cnt);		
	
	Object[] obj = { header };
	SepoaOut value = ServiceConnector.doService(info, "WO_031", "TRANSACTION","srgvn_tbl_insert", obj);


%>
<html>
<head>
<script language="javascript">
function init(){
	<%if( value.flag ){%>
		//alert( "<%=value.result[0]%>"+"이 완료되었습니다." );
		//document.frm.action            = "ev_sheet_runing_pop.jsp";
	   	//document.frm.target            = "_self";
	   	//document.frm.submit();	
	   	parent.reCall("<%=value.result[0]%>");
	<%}else{%>
		parent.location.href = "/errorPage/errorPage.jsp";
	<%}%>
}
</script>
</head>
<body onload = "init();">
<form name="frm" method="post">
<input type="hidden" name="ev_no"        value="<%=ev_no%>">
<input type="hidden" name="ev_year"      value="<%=ev_year%>">
<input type="hidden" name="sheet_name"   value="<%=sheet_name%>">
<input type="hidden" name="seller_code"  value="<%=seller_code%>">
<input type="hidden" name="seller_name"  value="<%=seller_name%>">
<input type="hidden" name="invest_date"  value="<%=invest_date%>">
<input type="hidden" name="irs_no"       value="<%=irs_no%>">

</form>
</body>
</html>