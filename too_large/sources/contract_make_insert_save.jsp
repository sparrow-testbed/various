<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

 
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_012");
	multilang_id.addElement("MESSAGE");
    HashMap text		= MessageUtil.getMessage(info,multilang_id);

	String cont_no			= JSPUtil.nullToEmpty(request.getParameter("cont_no"));
	String cont_gl_seq      = JSPUtil.nullToEmpty(request.getParameter("cont_gl_seq"));
	String in_attach_no		= JSPUtil.nullToEmpty(request.getParameter("in_attach_no"));
   	String ele_cont_flag    = JSPUtil.nullToEmpty(request.getParameter("ele_cont_flag")); // 전자계약서작성여부 ( Y : 전자계약 , N : 오프라인계약 )
   	String cont_form_no		= JSPUtil.nullToEmpty(request.getParameter("cont_form_no"));
	
	Object[] obj   = {cont_no, in_attach_no,ele_cont_flag, cont_gl_seq , "" ,cont_form_no};
	SepoaOut value = ServiceConnector.doService(info, "CT_021", "TRANSACTION","setContractMakeSave", obj);   

%> 
<html>
<head>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<%@ include file="/include/sepoa_scripts.jsp"%>


<Script language="javascript">

function Init()
{
	if("<%=value.status%>" == "1")
	{
		alert("<%=text.get("MESSAGE.0001")%>");
		location.href = "contract_list.jsp";
	}else alert("error");
}
</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>