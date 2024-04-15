<%@ page import="sepoa.fw.util.CommonUtil"%>
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
<%@ page import="sepoa.fw.log.*"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/filter_string_check.jsp"%>

<% // Session 없으면 사용불가로 수정 : 2015.09.23 %>

<%!
public Map getFileInfo(Connection conn, String doc_no) throws Exception {
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String sSql = "";

	Map res = new HashMap();
	try {
		
		sSql = "";
		sSql = sSql + " select DES_FILE_NAME, SRC_FILE_NAME, TYPE";
		sSql = sSql + "   from SFILE";
		sSql = sSql + "  where DOC_NO || DOC_SEQ = ?";
		sSql = sSql + " order by DOC_NO,DOC_SEQ";

		pstmt = conn.prepareStatement(sSql);
		pstmt.setString(1, doc_no);
		rs = pstmt.executeQuery();
		if(rs.next()) {
			String realfilename = rs.getString("SRC_FILE_NAME");
			String ext = realfilename.substring(realfilename.lastIndexOf(".")+1).toUpperCase();
			res.put("filename", rs.getString("DES_FILE_NAME"));
			res.put("realfilename", realfilename);
			res.put("type", rs.getString("TYPE"));
			res.put("ext", ext);
		}
	} catch (Exception e) {
	} finally {
		if(rs != null) {
			try {rs.close();} catch(Exception e){}
		}
		if(pstmt != null) {
			try {pstmt.close();} catch(Exception e){}
		}
	}
	
	return res;
}
%>

<%
InputStream rd             = null;
FileOutputStream outs      = null;
BufferedOutputStream bouts = null;

Reader rd1                 = null;
FileWriter outs1           = null;
BufferedWriter bouts1      = null;

File   f_chk        = null;
String move_path    = "";
String filename     = "";
String realfilename = "";
String size         = "";
String type         = "";
String doc_no       = "";
String ext          = "";
String Query        = "";

ConnectionResource resource = null;
Connection conn             = null;


try
{
// 	filename    = "WOORI_1416535501714_01.xlsx";
// 	realfilename= "AS_IS평가테이블정의서.xlsx";
// 	size        = "37127";
// 	type        = "FILE";
// 	doc_no      = "1416535494677";
// 	ext         = "xlsx";
//	filename    = request.getParameter("filename");
//	realfilename= request.getParameter("realfilename");
//	size        = request.getParameter("size");
//	type        = request.getParameter("type");
	doc_no      = request.getParameter("doc_no");
//	ext         = request.getParameter("ext");
	
	

	// 보안강화를 위하여 doc_no의 문자열 점검(2015.12.24 : ihStone)
	String rtn = "";
	try{
    	// filter_string_check.jsp : fsFilter_String_Check
		rtn = fsFilter_String_Check("00",doc_no);
    	if(!"".equals(rtn)) throw new Exception(rtn);
    	
    }
    catch(Exception e){
    	RequestDispatcher dispatcher = request.getRequestDispatcher("/include/error_msg.jsp?err_msg="+e.getMessage());
    	dispatcher.forward(request, response);
    }
    finally{
    }

	
	resource = new SepoaConnectionResource();
	conn     = resource.getConnection();
	
	Map fileInfoMap = getFileInfo(conn, doc_no);
	filename = ((String)fileInfoMap.get("filename")).replaceAll("\\.\\./", "");
	realfilename = ((String)fileInfoMap.get("realfilename")).replaceAll("\\.\\./", "");
	type = ((String)fileInfoMap.get("type")).replaceAll("\\.\\./", "");
	ext = ((String)fileInfoMap.get("ext")).replaceAll("\\.\\./", "");
		
	if( !ext.equals("") )  ext = ext.toUpperCase();

    ResultSet rs                = null;
    Statement stmt              = null;

    
// 	move_path = conf.get("sepoa.attach.path."+type);
	move_path = CommonUtil.getConfig("sepoa.attach.path."+type);
	
//	Logger.sys.println("filename    = " + filename);
//	Logger.sys.println("realfilename= " + realfilename);
//	Logger.sys.println("size        = " + size);
//	Logger.sys.println("type        = " + type);
//	Logger.sys.println("move_path   = " + move_path);
//	Logger.sys.println("doc_no      = " + doc_no);
//	Logger.sys.println("ext         = " + ext);
    
	
	
    File f = new File(move_path+"/"+filename);
    if( f.exists() ){
    	f.delete();	
    }
    
    Logger.sys.println( f.exists() );
    //if( !f.exists() ){
//**********************************************************************************************    
	    if( "TXT사용안함".equals( ext ) ){
	    	Logger.sys.println("CLOB");
	
		    try
			{
				stmt  = conn.createStatement();
			
				Query = "";
				Query = Query + " select DATA_TXT";
				Query = Query + "   from SFILE";
				Query = Query + "  where DOC_NO || DOC_SEQ = '" + doc_no + "'";
				Query = Query + "  order by DOC_NO,DOC_SEQ";
				rs = stmt.executeQuery(Query);
				//Logger.sys.println("SELECT DATA_TXT FROM SFILE WHERE DOC_NO || DOC_SEQ ='"+doc_no+"' ORDER BY DOC_NO,DOC_SEQ");
				
				if( rs.next() ){
					// CLOB column에 대한 스트림을 얻는다.
					try{
						rd1    = rs.getClob("DATA_TXT").getCharacterStream();
						outs1  = new FileWriter( f );
		
						int l      = 0;	
						char[] buf = new char[1024];				
						
						while( ( l = rd1.read( buf ) ) != -1 ){
							outs1.write( buf, 0, l );
						}
						outs1.flush();
						Logger.sys.println("end!!!!!!!!!!");
					}catch( Exception e1 ){
						
					}finally{
				    	try{
				            if( rd1 != null )     rd1.close();
				            if( outs1 != null )   outs1.close();
				        }catch (Exception e) {
				        	
				        }
				    }
				}
		
			} catch (Exception e) {
/* 			    e.printStackTrace(); */
			} finally {
			     try {
			        if(rs != null) rs.close();
			        if(stmt != null) stmt.close();
			    } catch (Exception e) {
			      
			    }
			}      	
	    }
	    else{
	    	Logger.sys.println("BLOB");
	   	    	
		    try
			{
				stmt  = conn.createStatement();

				Query = "";
				Query = Query + " select DATA";
				Query = Query + "   from SFILE";
				Query = Query + "  where DOC_NO || DOC_SEQ = '" + doc_no + "'";
				Query = Query + "  order by DOC_NO,DOC_SEQ";
				
				rs = stmt.executeQuery(Query);
				//Logger.sys.println("SELECT DATA FROM SFILE WHERE DOC_NO || DOC_SEQ ='"+doc_no+"' ORDER BY DOC_NO,DOC_SEQ");

				if( rs.next() ){
					// BLOB column에 대한 스트림을 얻는다.
					try{
						rd    = rs.getBlob("DATA").getBinaryStream();
						outs  = new FileOutputStream( f );
		
						int l      = 0;	
						byte[] buf = new byte[1024];				
						
						while( ( l = rd.read( buf ) ) != -1 ){
							outs.write( buf, 0, l );
						}
						outs.flush();
						Logger.sys.println("end");
					}catch( Exception e1 ){
						Logger.sys.println("??????1" + e1.getMessage());
						
					}finally{
				    	try{
				            if( rd != null )     rd.close();
				            if( outs != null )   outs.close();
				        }catch (Exception e) {
							Logger.sys.println("??????2" + e.getMessage());
				        	
				        }
				    }
				}
			} catch (Exception e) {
			    
			} finally {
			     try {
			        if(rs != null)   rs.close();
			        if(stmt != null) stmt.close();
			    } catch (Exception e) {
			      
			    }
			}    	
	    }
//**********************************************************************************************		    
	//} !f.exists() END
	
} catch(Exception e) {
  	Logger.sys.println("3" + e.getMessage());
  	response.sendRedirect("/errorPage/system_error.jsp");		
} finally {
	f_chk = new File(move_path+"/"+filename);
	if(conn != null) {
		try {
	        conn.close();
		} catch (Exception e) {}
	}
}

 InputStream in = null;
 OutputStream os = null;
 try
 {    
	//String file_name2 = URLDecoder.decode(realfilename);
	String file_name2 = realfilename;
	
	//System.out.println("filename : "+filename);
	//System.out.println("realfilename : "+realfilename);

	//String filename2 = new String(file_name2.getBytes(),"ISO8859_1");
	//String filename2 = new String(file_name2.getBytes("utf-8"),"ISO8859_1");
	String filename2 = URLEncoder.encode(realfilename, "utf-8").replaceAll("\\+", " ");
	
	//String filename = file_name;
	File file = new File(move_path+"/"+filename);

		
	in = new FileInputStream(file);
	response.reset() ;
	response.setHeader ("Content-Type", "application/smnet; charset=utf-8");
	//response.setHeader ("Content-Disposition", "attachment; filename="+realfilename+"\"" );
	response.setHeader ("Content-Disposition", "attachment; filename="+filename2+"\"" );
	response.setHeader ("Content-Transfer-Encoding", "binary");
	response.setHeader ("Content-Length", ""+file.length() );
	os = response.getOutputStream();

	byte b[] = new byte[(int)file.length()];
	int leng = 0;
	while( (leng = in.read(b)) > 0 ){
	 os.write(b,0,leng);
	}

} catch(Exception e) {
	//out.println(e);
	RequestDispatcher dispatcher = request.getRequestDispatcher("/include/error_msg.jsp?err_msg="+e.getMessage());
	dispatcher.forward(request, response);
}finally{
	if(in !=null)try{in.close();}catch(Exception e){}
	if(os !=null)try{os.close();}catch(Exception e){}
}
%>