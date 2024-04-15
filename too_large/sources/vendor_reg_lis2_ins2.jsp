<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SU_103_01");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SU_103_01";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<% String WISEHUB_PROCESS_ID="SU_103_01";%>
<%
	String user_id          		= info.getSession("ID");
	String user_name_loc    		= info.getSession("NAME_LOC");
	String user_name_eng    		= info.getSession("NAME_ENG");
	String user_dept        		= info.getSession("DEPARTMENT");
	String company_code     		= info.getSession("COMPANY_CODE");
	String house_code       		= info.getSession("HOUSE_CODE");
	 
	String HOUSE_CODE			= house_code;
	String VENDOR_CODE			= JSPUtil.nullToEmpty(request.getParameter("vendor_code")			  );
	String CREDIT_RATING		= JSPUtil.nullToEmpty(request.getParameter("credit_rating")			  );	

	String ATTACH_NO            = JSPUtil.nullToEmpty(request.getParameter("attach_no")			);

       	String HeaderData[][] = new String[1][];
        String Data[]        ={  CREDIT_RATING       
								,ATTACH_NO		    
								 }; 
	        
	    HeaderData[0]   = Data;
	       
		String Z_STR_BIN = "";
		String ITEM_NO = "";
		String MODE = "";
		String DETAIL_FLAG ="Y";
		String SIGN_STATUS ="P";
		 
		Object[] obj =  {VENDOR_CODE, HeaderData};

	SepoaOut value = ServiceConnector.doService(info, "t0002", "TRANSACTION", "real_setUpdate_vngl", obj);
 %>


<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="../../../css/<%=info.getSession("HOUSE_CODE")%>/body_create.css" type="text/css">

<Script language="javascript">

function Init()
{
	parent.doSave("<%=value.message%>", "<%=value.status%>");
}

</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>
