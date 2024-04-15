<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp" %>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>
<html>
<head>
<title>우리은행 전자구매시스템</title>

<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/sec.js"></script>


<%
	String screen_message = "";
	
	String cont_no 			= JSPUtil.nullToEmpty(request.getParameter("cont_no")); 
	String from 			= JSPUtil.nullToEmpty(request.getParameter("from"));
	String house_code 		= JSPUtil.nullToEmpty(request.getParameter("house_code"));
	String company_code 	= JSPUtil.nullToEmpty(request.getParameter("company_code"));
	String dept_code 		= JSPUtil.nullToEmpty(request.getParameter("dept_code"));
	String req_user_id 		= JSPUtil.nullToEmpty(request.getParameter("req_user_id"));
	String doc_type 		= JSPUtil.nullToEmpty(request.getParameter("doc_type"));
	String doc_detail_type 	= JSPUtil.nullToEmpty(request.getParameter("doc_detail_type"));
	String fnc_name 		= JSPUtil.nullToEmpty(request.getParameter("fnc_name"));
	

	System.out.println("///////app_approval.jsp//////");
	System.out.println("cont_no : "+cont_no); 
	System.out.println("from : "+from);
	System.out.println("house_code : "+house_code);
	System.out.println("company_code : "+company_code);
	System.out.println("dept_code : "+dept_code);
	System.out.println("req_user_id : "+req_user_id);
	System.out.println("doc_type : "+doc_type);
	System.out.println("fnc_name : "+fnc_name); 
	System.out.println("//////////////////////////////");
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("PU_129");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	HashMap text = MessageUtil.getMessage(info,multilang_id);

	//여기 로직은 아직 확인안해봤다..(무엇에 쓰이는지...)////////
	if( doc_detail_type == null || doc_detail_type.equals("")) 
		doc_detail_type = "X"; 
	///////////////////////////////////////////////////
	  
%>		   	
   	
	

<script language="javascript">
function Init(){

	var param = "";
	param += "cont_no="+"<%=cont_no%>"; 
	param += "&from="+"<%=from%>";
	param += "&doc_type="+"<%=doc_type%>";	
	param += "&req_user_id="+"<%=req_user_id%>";	
	param += "&dept_code="+"<%=dept_code%>";	
	param += "&company_code="+"<%=company_code%>";	
	param += "&house_code="+"<%=house_code%>";	
	param += "&fnc_name="+"<%=fnc_name%>";	 
	
	var url = "app_aproval_list4.jsp?"+param;
	
	CodeSearchCommon(url,'app_pop_up','','','650','550');
}
</script>
</head>
<s:header>
<body bgcolor="#FFFFFF" onLoad="Init()">
</body>
</s:header>
<s:footer/>
</html>
