<% // 소스 사용처 없음. 검색을 통한 확인 %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.lang.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="sepoa.fw.cfg.*"%>
<%@ page import="sepoa.fw.db.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="sepoa.fw.util.JSPUtil" %>
<%@ include file="/include/sepoa_session.jsp"%>

<%
// Session 없으면 사용불가로 수정 : 2015.09.23

 InputStream in = null;
 OutputStream os = null;
 String POASRM_CONTEXT_NAME = "";

 try
 {
   	Config conf = new Configuration();
   	String down_root = conf.get("sepoa.attach.path.download");
   	String sub_root      = "";
	String doc_no        = JSPUtil.CheckInjection(request.getParameter("doc_no"));
	String des_file_name = "";
	String type          = "";
	String src_file_name = "";
   	POASRM_CONTEXT_NAME = conf.get("sepoa.context.name");
   	
   	ConnectionResource resource = null;
    Connection conn=null;
    ResultSet rs = null;
    Statement stmt = null;
    
    try
	{
		resource = new SepoaConnectionResource();
		conn = resource.getConnection();
		stmt = conn.createStatement();
	
		stmt.executeQuery("SELECT DES_FILE_NAME, SRC_FILE_NAME, TYPE FROM SFILE WHERE DOC_NO || DOC_SEQ ='"+doc_no+"' ORDER BY DOC_NO,DOC_SEQ");
	
		rs  = stmt.getResultSet();

		if(rs.next()) {
		    src_file_name = URLEncoder.encode(rs.getString("SRC_FILE_NAME"), "UTF-8");
		    des_file_name = rs.getString("DES_FILE_NAME");
		    type          = rs.getString ("TYPE"         );
		    sub_root      = conf.get("sepoa.attach.view."+type);
		}
		down_root += sub_root + "/" + des_file_name.replaceAll("\\.\\./", "");
    } catch (Exception e) {
    	
    } finally {
         try {
            if(rs != null) rs.close();
            if(stmt != null) stmt.close();
            if(conn != null) conn.close();
        } catch (Exception e) {
          
        }
    }
   	
    
   	File file = new File(down_root);
   	in = new FileInputStream(file);
   	
   	response.reset() ;
    response.setContentType("application/smnet");
   	response.setHeader ("Content-Type", "application/smnet; charset=UTF-8");
   	response.setHeader ("Content-Disposition", "attachment; filename="+src_file_name+"\"" );
   	response.setHeader ("Content-Transfer-Encoding", "binary"); 
   	response.setHeader ("Content-Length", ""+file.length());

   	out.clear();
    pageContext.pushBody();
   	os = response.getOutputStream();
    byte b[] = new byte[(int)file.length()];
    int leng = 0;
    while( (leng = in.read(b)) > 0 ) {
     	os.write(b,0,leng);
     	os.flush();
    }

 } catch(Exception e) {
  	
  	response.sendRedirect(POASRM_CONTEXT_NAME + "/errorPage/system_error.jsp");		
 } finally {
	if(in !=null)try{in.close();}catch(Exception e){}
	if(os !=null)try{os.close();}catch(Exception e){}
 }
 %>