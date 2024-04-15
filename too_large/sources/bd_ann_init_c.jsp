<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%


	Vector multilang_id = new Vector();
	multilang_id.addElement("VR_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "VR_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String BID_TYPE		= request.getParameter("BID_TYPE");
	String GUBUN		= request.getParameter("GUBUN");
	String M_TYPE		= "VR002";
	String ANN_VERSION     = "";
	
		Object[] args = new Object[1];
		
		SepoaOut value = null;
		SepoaRemote wr = null;
		String nickName = "BD_001";
		String MethodName = "";
		String conType = "CONNECTION";
		SepoaFormater wf = null;
		 
		//다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
		try {
			MethodName = "getBdAnnVersion";
			wr = new SepoaRemote(nickName,conType,info);
			value = wr.lookup(MethodName,args);
			wf = new SepoaFormater(value.result[0]);  
			ANN_VERSION	= wf.getValue("CODE" ,0); 
			 
		}catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,"e = " + e.getMessage());
			Logger.dev.println(e.getMessage());
		}finally{
			wr.Release();
		} // finally 끝
		 
%> 
<html>
<head>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script>
	function init()
	{ 
// 		document.form.method = "POST";
<%-- 		document.form.action = "/sourcing/bd_ann_<%=ANN_VERSION%>.jsp?SCR_FLAG=C&BID_STATUS=AR&BID_TYPE=C&popup_flag=false"; --%>
// 		//document.form.target = "body"; 
// 		document.form.submit();
		$("#getBdAnn").attr("src", "/sourcing/bd_ann_<%=ANN_VERSION%>.jsp?SCR_FLAG=V&BID_STATUS=AR&BID_TYPE=C&ANN_VERSION=<%=ANN_VERSION%>");
	}
</script>
</head>
<body onload="init();">
<s:header>
<form id="form" name="form">
<%-- <input type="hidden" name="BID_TYPE" value="<%=BID_TYPE%>">  --%>
<!-- <input type="hidden" name="SCR_FLAG" value="C">  -->
<%-- <input type="hidden" name="ANN_VERSION" value="<%=ANN_VERSION %>">   --%>
</form>
<iframe id="getBdAnn" name="getBdAnn" frameborder="0px" style="width: 100%; height: 780px;"></iframe>
</s:header>
<s:footer/>
</body>
</html>