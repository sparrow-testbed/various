<!--
 Title:        Duplicate Checking
-->

<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID= "p0030"; %>

<!-- 사용 언어 설정 -->
<% String WISEHUB_LANG_TYPE= "KR"; %>

<% 
	String house_code = info.getSession("HOUSE_CODE");
	Logger.debug.println(info.getSession("ID"),request,"message = " + house_code);
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>

<!-- META TAG 정의  -->
<!-- Wisehub Common Scripts -->
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<meta http-equiv="Content-Type" content="text/html; charset=EUC-kr">

<%   		
    		String[] args = new String[2];
	    	args[0] = house_code;
	    	args[1] = JSPUtil.nullToEmpty(request.getParameter("user_id"));
	    	if (args[1].equals(""))
	    		args[1] = JSPUtil.nullToEmpty(request.getParameter("USER_ID"));

	    	Object[] obj = {args};
	    	String nickName= "s6030";
	    	String conType = "CONNECTION";
	    	String MethodName = "getDuplicate_ict";
	        SepoaOut value = null; 
		    SepoaRemote remote = null;
		    String count =  "";

	        try {
				 	remote = new SepoaRemote(nickName, conType, info);
				 	value = remote.lookup(MethodName, obj);
				 	if(value.status == 1)
					{

						//Count값을 가져온다. 
						SepoaFormater wf = new SepoaFormater(value.result[0]);
						count = wf.getValue("COUNT",0);
			   			Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);	
   						Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
			   		}
	        }catch(SepoaServiceException wse) {
			    Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
				Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);	
	   			Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	        }catch(Exception e) {
	            Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	    	}finally{
	    		try{
					remote.Release();
				}catch(Exception e){}
			}
%>							   	

<Script language="javascript">
<!-- 

function Init()
{
   if("<%=value.status%>" == "1")
    {
    	var count = document.form.count.value;
    	if(count != 0) 
	    {
	    		alert("입력하신 ID는 이미 존재합니다.");
	    		parent.checkDulicate('F');
	    }
	    else 
	    {
		    	alert("등록 가능한 ID 입니다.");
		    	parent.checkDulicate('T');
	    }
    }
    else alert("조회가 실패하였습니다.");
}


//-->
</Script>
</head>

<body bgcolor="#FFFFFF" text="#000000" onLoad="Init()">
<form name="form">
<input type="hidden" name="count" value="<%=count%>"> 
</form>
</body>
</html>
