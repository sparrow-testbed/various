<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="sepoa.fw.cfg.*"%>
<%@ page import="sepoa.fw.log.*"%>
<%@ page import="sepoa.fw.msg.*"%>
<%@ page import="sepoa.fw.srv.*"%>
<%@ page import="sepoa.fw.util.*"%>
<%@ page import="sepoa.fw.ses.*"%>
<%@ page import="sepoa.fw.srv.*" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.*"%>
<table cellSpacing="0" cellPadding="0" border="1" cellpadding="0" cellspacing="0">        
<%
try{
	      String  sessionid   = JSPUtil.nullChk(request.getParameter("sessionid"));	 
	      String  mode   = JSPUtil.nullChk(request.getParameter("mode"));
	      String  ckbFlag  = JSPUtil.nullChk(request.getParameter("ckbFlag"));
	      String  EVABD_NO = JSPUtil.nullChk(request.getParameter("EVABD_NO"));
		  String  EVABD_NM = JSPUtil.nullChk(request.getParameter("EVABD_NM"));
		  String  EVABD_USER_ID = JSPUtil.nullChk(request.getParameter("EVABD_USER_ID"));
		  String  EVABD_DEPT_CD = JSPUtil.nullChk(request.getParameter("EVABD_DEPT_CD"));
		  String  EVABD_USER_ID2 = JSPUtil.nullChk(request.getParameter("EVABD_USER_ID2"));
		  String  param = JSPUtil.nullChk(request.getParameter("param"));      
		  String  EVABD = JSPUtil.nullChk(request.getParameter("EVABD"));
		  
		  SepoaInfo info = new SepoaInfo("000","ID="+sessionid+"^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL");
		  
		  if("sEvabdcom".equals(mode)){
	
			   Object[] obj = { EVABD_NO,EVABD_NM,EVABD_USER_ID,EVABD_DEPT_CD,EVABD_USER_ID2,param,EVABD };		  
			   SepoaOut value = ServiceConnector.doService(info, "s2020", "TRANSACTION", "sEvabdcom", obj);
		    
				if(value.flag){
%>
					<script>alert("<%=value.message%>");</script>
<%				}else{                                                     %>
					<script>alert("<%=value.message%>");</script>
<%
		        }			
		  }
		  if("gEvabdcom".equals(mode)){
			   Object[] obj = { EVABD_NO,EVABD_NM,EVABD_USER_ID,EVABD_DEPT_CD,EVABD_USER_ID2,param,EVABD };		  
			   SepoaOut value = ServiceConnector.doService(info, "s2020", "CONNECTION", "gEvabdcom", obj);			   				
				if(value.flag){
					SepoaFormater wf1          = null;					   
					wf1 = new SepoaFormater(value.result[0]);
					int rCnt         = 0;
					rCnt = wf1.getRowCount();
				    int cCnt         = 0;
				    cCnt  = wf1.getColumnCount();				   
				    String[] cn = new String[cCnt];
				    cn = wf1.getColumnNames();				    
					for(int i = 0; i < rCnt; i++){	
						if(i == 0){
%>
							<tr>							
<%							
							 for(int j = 0; j < cCnt; j++){	
								   if("on".equals(ckbFlag)){
%>	
									<td align="center" width="100px"><%=cn[j]%></td>
<%                                  }else{                                                                 %>                                		 							 
									<td align="center" width="50px"><input type="text"  value="<%=cn[j]%>"  size=10  readOnly /></td>
<%						            }
					          }
%>
							</tr>
<%                    }                                                %>
						<tr>																		
<% 
                                for(int j = 0; j < cCnt; j++){		
                                	 if("on".equals(ckbFlag)){
%>						
									<td align="center" width="100px" ><%=wf1.getValue(i,j)%></td>					
<%                                   }else{                              %>                                		 
     								 <td align="center" width="50px"><input type="text"  value="<%=wf1.getValue(i,j)%>"  size=10  readOnly /></td>
<%                           		 }
                                }
%>							   						
   						</tr>														
<%              }                               %>
					<script>
						alert("<%=rCnt%>");
					</script>
<% 			     }else{                          %>
					<script>
						alert("<%=value.message%>");
					</script>
<%
		         }	
		  }
}catch(Exception e){
	//e.printStackTrace();
	%>
	<script>
		alert("오류가 발생되었습니다. 관리자에게 문의하세요.");		
	</script>	
	<% 	
}
%>	
</table>
