<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_session.jsp" %>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<table cellSpacing="0" cellPadding="0" border="1" cellpadding="0" cellspacing="0">        

<%
// 현행화테스트
try{
	      String  mode   = JSPUtil.nullChk(request.getParameter("mode"));
	      String  param1 = JSPUtil.nullChk(request.getParameter("CONTENT"));
	      
		  
		  if(mode.equals("doSend")){
	
			   Object[] obj = { param1};		  
			   SepoaOut value = ServiceConnector.doService(info, "t1001", "TRANSACTION", "doSend", obj);
		    

%>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			 	 	 <td colspan='2' >
			 	 	 <textarea name="CONTENT2" id="CONTENT2"  style="width:1890px;height:480px" ><%=value.message%></textarea>
			 	 	 </td>
			 	</tr>	  			  			    
         </table>
<%
       }
		  
		  
}catch(Exception e){ mode   = JSPUtil.nullChk(request.getParameter("mode"));
	//e.printStackTrace();
	%>
	<script>
		alert("실행중 오류입니다.");		
	</script>	
	<% 	
}finally {
	
}
%>	
</table>