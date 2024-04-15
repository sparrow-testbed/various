<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"%>
<%@ page import="java.sql.*"%>
<%@ page import="sepoa.fw.srv.SepoaService"%>
<%@ page import="sepoa.fw.db.*"%>
<%@ page import="sepoa.fw.log.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Vector"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@ page import="javax.naming.*"%>
<%@ page import="java.rmi.RemoteException"%>
<%@ page import="javax.rmi.PortableRemoteObject"%>
<%@ page import="java.rmi.Remote"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.*"%>
<%@ page import="oracle.sql.*"%>
<%@ page import="oracle.jdbc.*"%>

<%--@ page import="common.util.JNICipher" --%>
<%@ page import="MarkAny.MaSaferJava.Madec"%>
<!DOCTYPE html>
<html>
<head>
<%-- 
<link rel="stylesheet" href="../../css/common.css"/>
<link rel="stylesheet" href="../../css/layout.css"/>
<link rel="stylesheet" href="../../css/sec_admin.css" type="text/css">
--%>

<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<script language=javascript src="../../js/lib/sec.js"></script>
<!-- 폴더 위치 변경됨,파일 추가됨 -->

<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<script type="text/javascript" src="../../js/lib/jquery.form.min.js"></script>
<!-- form의 fileupload를 위해 필요 -->
<%
	String house_code   = "100";
	String user_id		= "guest";
	String user_os_lang = "";
	info = sepoa.fw.ses.SepoaSession.getAllValue(request);
	String language = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("language")));

	if(language.length() <= 0)
	{
		language = "KO";
	}
	
	
	
	
	if(info.getSession("ID").trim().length() <= 0)
	{
		//info = new SepoaInfo("100","ID=BULLETIN^@^LANGUAGE=" + language + "^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
		user_os_lang = (String)(session.getAttribute("USER_OS_LANGUAGE")) == null ? "KO" : (String)(session.getAttribute("USER_OS_LANGUAGE"));
		info = new SepoaInfo("100","ID=SUPPLIER^@^LANGUAGE=" + user_os_lang + "^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
	}

	
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("CO_007");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);
    
    
	
	if(info.getSession("ID") != null) {
        house_code      = info.getSession("HOUSE_CODE");
	    user_id		    = info.getSession("ID");
    } else {
	    info = new SepoaInfo(house_code, null);
	}
	
	String is_admin_user = info.getSession("IS_ADMIN_USER");
	String user_type = info.getSession("USER_TYPE");
%>
<%
	String WisehubNext ="";
%>
<%
	Config conf = new Configuration();

    String conf_filesize = CommonUtil.getConfig("sepoa.attach.maxsize");
	
	
     String buyer = "";
    if(info.getSession("COMPANY_CODE") == null ) buyer = "SYSTEM";
    else buyer = info.getSession("COMPANY_CODE");

    String userID = "";
    if(info.getSession("ID") == null ) userID = "SYSTEM";
    else userID = info.getSession("ID");

    String userName = "";
    if(info.getSession("NAME_LOC") == null ) userName = "SYSTEM";
    else userName = info.getSession("NAME_LOC");

    String userDept = "";
    if(info.getSession("DEPARTMENT") == null ) userDept = "SYSTEM";
    else userDept = info.getSession("DEPARTMENT");

    String userDeptName = "";
    if(info.getSession("DEPARTMENT_NAME_LOC") == null ) userDeptName = "SYSTEM";
    else userDeptName = info.getSession("DEPARTMENT_NAME_LOC");

    String userTel = "";
    if(info.getSession("TEL") == null ) userTel = "SYSTEM";
    else userTel = info.getSession("TEL"); 

    String View_type =  JSPUtil.CheckInjection(request.getParameter("view_type"));
    String pathtype =  JSPUtil.CheckInjection(request.getParameter("type"));

    if(View_type == null || View_type.length() == 0 ) View_type = "IN";

    //String G_file_size = conf.get("sepoa.file.attach.size");
    String G_file_size = CommonUtil.getConfig("sepoa.attach.maxsize");
    String G_not_file_type = CommonUtil.getConfig("sepoa.file.attach.type");
%>

<%!private void fnFileReName(String sfilename, String temp_path,
			String target_path) {
		// temp_Path   : "D:/bea/user_projects/domains/woori/applications/V1.0.0/wisedoc/attfiles/TEMP"
		// target_path : "D:/bea/user_projects/domains/woori/applications/V1.0.0/wisedoc/attfiles/RA"

		String value;

		try {
			File f = new File(temp_path + "/" + sfilename);
			File df = new File(target_path + "/" + sfilename);
			f.renameTo(df);

			Logger.sys.println("temp_path   = " + temp_path);
			Logger.sys.println("target_path = " + target_path);

			// 파일 암복호화(20100720 code by ihStone)
			//////////////////////////////////////////////////////////////////////////////
			// File Decription

			String OriFilePath = temp_path + "/" + sfilename;
			String NewFilePath = target_path + "/" + sfilename;

			Logger.sys.println("OriFilePath = " + OriFilePath);
			Logger.sys.println("NewFilePath = " + NewFilePath);

			OriFilePath = SepoaString.replace(OriFilePath, "/", "\\");
			NewFilePath = SepoaString.replace(NewFilePath, "/", "\\");

			Logger.sys.println("1111");
			int nRet2 = 1;
			// 				int nRet2   = JNICipher.DecipherFile(OriFilePath);
			Logger.sys.println("2222");
			// 				int nRet2_1 = JNICipher.DecipherFile(NewFilePath);
			int nRet2_1 = 2;
			Logger.sys.println("3333");
			// ret = 0  정상
			//       1  license 오류
			//       나머지는 기타오류

			Logger.sys.println("OriFilePath DecipherFile Return : " + nRet2);
			Logger.sys.println("NewFilePath DecipherFile Return : " + nRet2_1);
		} catch (Exception e) {
			//e.printStackTrace();
			value = "";
		}
	}

	private void fileCopy(String filename, String destfile) throws Exception {
		java.nio.channels.FileChannel in = null;
		java.nio.channels.FileChannel out = null;

		try {
			in = new java.io.RandomAccessFile(filename, "r").getChannel();
			out = new java.io.RandomAccessFile(destfile, "rw").getChannel();

			int maxCount = 1024 * 1024 * 200;
			long size = in.size();
			long position = 0;

			while (position < size) {
				position += in.transferTo(position, maxCount, out);
			}

			in.close();
			out.close();
		} catch (Exception e) {
			Logger.sys.println(e.getMessage());

			throw new Exception(e.getMessage());
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (Exception e) {
				}
			}

			if (out != null) {
				try {
					out.close();
				} catch (Exception e) {
				}
			}
		}
	}

	private void FileRename(String sfilename, String temp_path, String path,
			String Type) {
		String value;
		String twin_path = "";

		try {
			File f = new File(temp_path + "/" + sfilename);

			twin_path = CommonUtil.getConfig("sepoa.attach.path." + Type
					+ "_TWIN");
			if (f.exists() && twin_path != null
					&& twin_path.trim().length() > 0) {
				//	    	FileProcess.fileCopy(temp_path + "/" + sfilename, twin_path+ "/" + sfilename);
				FileProcess.copyFile(
						temp_path + "/" + sfilename.replaceAll("\\.\\./", ""),
						twin_path + "/" + sfilename);
			}

			File df = new File(path + "/" + sfilename);
			f.renameTo(df);

		} catch (Exception e) {

			value = "";
		}
	}

	private void FileDelete(String sfilename, String temp_path, String Type) {
		String value;
		String twin_path = "";
		try {

			File f = new File(temp_path + "/" + sfilename);
			if (f.exists()) {
				f.delete();
			}
			twin_path = CommonUtil.getConfig("sepoa.attach.path." + Type
					+ "_TWIN");
			File twin_f = new File(twin_path + "/" + sfilename);
			if (twin_f.exists())
				twin_f.delete();

		} catch (Exception e) {
			value = "";
		}
	}

	private Hashtable Attach_File_DataBase_Insert(Hashtable ht)
			throws Exception {
		Hashtable rtnht = new Hashtable();
		ConnectionResource resource = null;
		Connection conn = null;
		PreparedStatement Attach_pstmt = null;

		StringBuffer Attach_Sql = new StringBuffer();
		Attach_Sql.append("INSERT INTO sfile( ");
		Attach_Sql.append("                    DOC_NO,       ");
		Attach_Sql.append("                    DOC_SEQ,      ");
		Attach_Sql.append("                   TYPE,         ");
		Attach_Sql.append("                   DES_FILE_NAME,");
		Attach_Sql.append("                   SRC_FILE_NAME,");
		Attach_Sql.append("                   FILE_SIZE,    ");
		Attach_Sql.append("                   ADD_DATE,     ");
		Attach_Sql.append("                   ADD_TIME,     ");
		Attach_Sql.append("                   CHANGE_DATE,  ");
		Attach_Sql.append("                   CHANGE_TIME,  ");
		Attach_Sql.append("                   ADD_USER_ID ) ");
		//Attach_Sql.append( "                   ADD_USER_NAME ");
		Attach_Sql.append(" VALUES ( ");
		Attach_Sql.append("      '" + ht.get("ATTACH_KEY") + "',");
		Attach_Sql.append("      to_char('" + ht.get("ATTACH_SEQ")
				+ "','FM00000000') ,");
		//Attach_Sql.append( "      dbo.lpad('"+ht.get("ATTACH_SEQ")+"','8','0') ,");
		Attach_Sql.append("      '" + ht.get("TYPE") + "', ");
		Attach_Sql.append("      '" + ht.get("UNIQ_FILE_NAME") + "',");
		//Attach_Sql.append( "            '"+ht.get("FILE_NAME")+"',");
		Attach_Sql.append("            ?,");
		Attach_Sql.append("      " + ht.get("FILE_SIZE") + ",");

		//Attach_Sql.append( "      convert(varchar(8), getdate() , 112) , ");
		//Attach_Sql.append( "      convert(varchar(5), getdate() , 114) , ");
		//Attach_Sql.append( "      convert(varchar(8), getdate() , 112) , ");
		//Attach_Sql.append( "      convert(varchar(5), getdate() , 114) , ");

		//	    Attach_Sql.append( "      date_format( now() , '%Y%m%d') , ");
		//	    Attach_Sql.append( "      date_format( now() , '%H%i%S'), ");
		//	   	Attach_Sql.append( "      date_format( now() , '%Y%m%d') , ");
		//	    Attach_Sql.append( "      date_format( now() , '%H%i%S'), ");

		Attach_Sql.append("      TO_CHAR(SYSDATE,'yyyymmdd'), ");
		Attach_Sql.append("      TO_CHAR(SYSDATE,'hh24miss'), ");
		Attach_Sql.append("      TO_CHAR(SYSDATE,'yyyymmdd'), ");
		Attach_Sql.append("      TO_CHAR(SYSDATE,'hh24miss'), ");
		Attach_Sql.append("      '" + ht.get("USER_ID") + "' )");

		// Attach_Sql.append( "      '"+ht.get("USER_NAME")+"' )");

		try {
			String file_name = (String) ht.get("FILE_NAME");
			resource = new SepoaConnectionResource();
			conn = resource.getConnection();
			Attach_pstmt = conn.prepareStatement(Attach_Sql.toString());
			Attach_pstmt.setString(1, file_name);

			String filesize = (String) ht.get("FILE_SIZE");

			Attach_pstmt.executeUpdate();
			rtnht.put("SUCCESS", "true");
		} catch (Exception e) {
			rtnht.put("SUCCESS", "false");
			rtnht.put("MESSAGE", e.getMessage());

			throw new Exception(e.getMessage());
		} finally {
			try {
				if (Attach_pstmt != null)
					Attach_pstmt.close();
				if (conn != null)
					conn.close();
				if (resource != null)
					resource.release();

			} catch (Exception e) {
				rtnht.put("SUCCESS", "false");
				rtnht.put("MESSAGE", e.getMessage());

			}
		}

		return rtnht;
	}

	private Vector Attach_File_DataBase_Select(String Attach_Key) {
		Vector vt = new Vector();
		ConnectionResource resource = null;
		Connection conn = null;
		ResultSet rs = null;
		Statement stmt = null;
		String doc_seq = "1";

		StringBuffer Attach_Sql = new StringBuffer();
		Attach_Sql.append("SELECT * FROM sfile WHERE DOC_NO='" + Attach_Key
				+ "' ORDER BY DOC_NO,DOC_SEQ");
		try {
			resource = new SepoaConnectionResource();
			conn = resource.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(Attach_Sql.toString());
			//rs  = stmt.getResultSet();
			//System.out.println(Attach_Sql.toString());
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				ht.put("FILE_SIZE", rs.getString("FILE_SIZE"));
				ht.put("DOC_NO", rs.getString("DOC_NO"));
				ht.put("DOC_SEQ", rs.getString("DOC_SEQ"));
				ht.put("TYPE", rs.getString("TYPE"));
				ht.put("SRC_FILE_NAME", rs.getString("SRC_FILE_NAME"));
				ht.put("ADD_USER_ID", rs.getString("ADD_USER_ID"));
				ht.put("DES_FILE_NAME", rs.getString("DES_FILE_NAME"));
				vt.addElement(ht);
			}

			rs.close();

		} catch (Exception e) {

		} finally {
			//20070116 shy, ??d
			if (rs != null) {
				try {
					rs.close();
				} catch (Exception e) {
				}
			}
			if (stmt != null) {
				try {
					stmt.close();
				} catch (Exception e) {
				}
			}
			//if (conn != null){	try{ conn.close(); }catch (Exception e){} }
			try {
				resource.release();
			} catch (Exception e) {

			}

		}

		return vt;
	}

	private Hashtable Attach_File_DataBase_Delete(String[] arr) {
		Hashtable rtnht = new Hashtable();
		ConnectionResource resource = null;
		Connection conn = null;
		Statement stmt = null;

		StringBuffer Attach_Sql = new StringBuffer();

		try {
			Attach_Sql.append("delete FROM sfile WHERE DOC_NO='" + arr[0]
					+ "' and DOC_SEQ='" + arr[1] + "'");
			resource = new SepoaConnectionResource();
			conn = resource.getConnection();
			stmt = conn.createStatement();
			stmt.executeUpdate(Attach_Sql.toString());

			rtnht.put("SUCCESS", "true");
		} catch (Exception e) {
			//e.printStackTrace();
			rtnht.put("SUCCESS", "false");
			rtnht.put("MESSAGE", e.getMessage());

		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (conn != null)
					conn.close();
				if (resource != null)
					resource.release();

			} catch (Exception e) {
				//e.printStackTrace();
				rtnht.put("SUCCESS", "false");
				rtnht.put("MESSAGE", e.getMessage());

			}
		}

		return rtnht;
	}%>


<%
	SepoaUpload sepoaUpload = null;
String fileFolder      = "";

// if(pathtype != null) fileFolder = conf.get("sepoa.attach.view."+pathtype);
if(pathtype != null) fileFolder = CommonUtil.getConfig("sepoa.attach.view."+pathtype);

long FileSize           = 0;
long CurFileSize        = 0;
String FileName         = "";
String UniqFileName     = "";
String Act              = "INSERT";
String attach_key       = "";
String Type             = "";
String rowId            = "";
String attch_file_type  = "";
String temp_Attach_Path = "";
String move_path        = "";
String ContentType      = request.getContentType();
String attach_seq       = "0";
String MESSAGE          = "";
String uploads          = "";
int TOT_FILE_SIZE       = 1024*1024 * Integer.parseInt(G_file_size);

Hashtable ht    = new Hashtable();
Hashtable rtnht = new Hashtable();
Vector vt       = new Vector();

if( ContentType == null )   ContentType="";

try {
	//temp_Attach_Path = conf.get("sepoa.attach.path.TEMP");
	temp_Attach_Path = CommonUtil.getConfig("sepoa.attach.path.TEMP");
	
	if ( ContentType.indexOf("multipart/form-data") >= 0 ){

		if(request.getContentLength() > TOT_FILE_SIZE){
	attach_key 	= request.getParameter("attach_key");
	Type 		= request.getParameter("type");
	
	String url 	= "location.href='/sepoafw/filelob/file_attach.jsp?attach_key="+attach_key+"&type="+Type +"';";
	//System.out.println("url : " + url);
	//out.print("<script>alert('파일용량이 초과되었습니다. (파일용량 : "+request.getContentLength()+", 최대용량 :  "+TOT_FILE_SIZE+")');"+url+"</script>");
	MESSAGE = "파일용량이 초과되었습니다. (파일용량 : " + request.getContentLength() + ", 최대용량 :  "+TOT_FILE_SIZE+")";
	//RequestDispatcher dispatcher = request.getRequestDispatcher("/include/error_msg.jsp?err_msg="+MESSAGE);
	//dispatcher.forward(request, response);
	//return;
	rtnht.put("SUCCESS","false");
		    rtnht.put("MESSAGE",MESSAGE);
		    throw new Exception(MESSAGE);
		}
		
    	sepoaUpload = new SepoaUpload(request, temp_Attach_Path ,buyer+"_"+String.valueOf(System.currentTimeMillis()) ,TOT_FILE_SIZE);

  	    attach_key         = sepoaUpload.getParameter("attach_key");
	    attach_seq         = (String)sepoaUpload.getParameter("attach_seq");	
    	Type               = sepoaUpload.getParameter("type");
		Act                = JSPUtil.CheckInjection(request.getParameter("act"));
		rowId              = JSPUtil.CheckInjection(request.getParameter("rowId"));
		attch_file_type    = JSPUtil.CheckInjection(request.getParameter("attch_file_type"));

		String server_attach_file_type = G_not_file_type.toUpperCase();	// 체크를 위한 허용가능 파일 확장자들
		String client_attach_file_type = attch_file_type.toUpperCase();	// 입력한 파일의 파일 확장자
		

		//==============================================================================================
		Logger.sys.println("#### ihstone : server_attach_file_type = " + server_attach_file_type);
		Logger.sys.println("#### ihstone : client_attach_file_type = " + client_attach_file_type);
		//==============================================================================================

		// 허용 가능 확장자에 포함이 되어 있지 않음 경우
		if (server_attach_file_type.lastIndexOf(client_attach_file_type) < 1 )
		{
	rtnht.put("SUCCESS","false");
		    rtnht.put("MESSAGE","첨부파일로 등록 불가능 파일입니다.");
		    throw new Exception("첨부파일로 등록 불가능 파일입니다.");
		}
		
  		//sepoaUpload         = new SepoaUpload(request, String.valueOf(System.currentTimeMillis()), TOT_FILE_SIZE);
		
 		//move_path = conf.get("sepoa.attach.path."+Type);
		move_path = CommonUtil.getConfig("sepoa.attach.path."+Type);
		
		Logger.sys.println("#### move_path = " + move_path);

		Enumeration  files = sepoaUpload.getFileNames();
		String Name        = ((String)files.nextElement()).replaceAll("\\.\\./", "");
		FileSize           = sepoaUpload.getFileSize(Name);
		
		FileName           = (String)sepoaUpload.getFilesystemName(Name);
		//FileName =WiseString.Iso8859ToEucKr(FileName);
		FileName           = SepoaString.UTF_8(FileName);
		UniqFileName       = (String)sepoaUpload.getUniqFileName(Name);
		
		//파일카피
		
		//System.out.println("temp_Attach_Path !!! : " + temp_Attach_Path);
		fileCopy( temp_Attach_Path + "/" + UniqFileName, move_path + "/" + UniqFileName );
		Logger.sys.println("#### attch_file_type = " + attch_file_type);

		ConnectionResource resource    = null;
		Connection conn                = null;
		PreparedStatement Attach_pstmt = null;
		ResultSet rs                   = null;
		Logger.sys.println("############## attach_key = " + attach_key);

		// CLOB
		if( "TXT사용안함".equals( attch_file_type.toUpperCase() ) ){
	Logger.sys.println("CLOB");
	StringBuffer Attach_Sql = new StringBuffer();
	
	Attach_Sql.append("INSERT INTO SFILE(                                         ");
	Attach_Sql.append("                    DOC_NO          		 				  ");
	Attach_Sql.append("                   ,DOC_SEQ          		 			  ");
	Attach_Sql.append("                   ,TYPE              		 			  ");
	Attach_Sql.append( "                  ,DES_FILE_NAME						  ");
	Attach_Sql.append( "                  ,SRC_FILE_NAME                          ");
	Attach_Sql.append( "                  ,FILE_SIZE    						  ");
	Attach_Sql.append( "                  ,ADD_DATE     						  ");
	Attach_Sql.append( "                  ,ADD_TIME     				          ");
	Attach_Sql.append( "                  ,CHANGE_DATE  						  ");
	Attach_Sql.append( "                  ,CHANGE_TIME                            ");
	Attach_Sql.append( "                  ,ADD_USER_ID                            ");
	Attach_Sql.append("                   ,DATA_TXT        		 				  ");
	Attach_Sql.append("           ) VALUES ( 			         				  ");
	Attach_Sql.append("                    '" + attach_key + "'	                  ");
	Attach_Sql.append("                  ,to_char('" + attach_seq +"','FM00000000')  ");
	Attach_Sql.append("                   ,'" + Type + "'	                      ");
	Attach_Sql.append("                   ,'" + UniqFileName + "'	              ");
	Attach_Sql.append("                   ,'" + FileName + "'	                  ");
	Attach_Sql.append("                   ,"  + FileSize + " 	                  ");
	Attach_Sql.append("                  ,TO_CHAR(SYSDATE,'yyyymmdd')             ");
	Attach_Sql.append("                  ,TO_CHAR(SYSDATE,'hh24miss')             ");
	Attach_Sql.append("                  ,TO_CHAR(SYSDATE,'yyyymmdd')             ");
	Attach_Sql.append("                  ,TO_CHAR(SYSDATE,'hh24miss')             ");
	Attach_Sql.append("                   ,'" + userID + "'	                      ");
	Attach_Sql.append("                   ,empty_clob()                           ");
	Attach_Sql.append("           )												  ");
		
	try {
		resource = new SepoaConnectionResource();
		conn     = resource.getConnection();
		conn.setAutoCommit(false);
	
		Attach_pstmt = conn.prepareStatement(Attach_Sql.toString());
		Attach_pstmt.executeUpdate();
		
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT DATA_TXT FROM SFILE WHERE DOC_NO = '" + attach_key + "' AND DOC_SEQ = to_char('" + attach_seq +"','FM00000000') FOR UPDATE");
	
		Attach_pstmt = conn.prepareStatement(sb.toString());
		rs           = Attach_pstmt.executeQuery();
		String userfile  = JSPUtil.nullToEmpty(request.getParameter("userfile"));
		String file_ext  = userfile.substring(userfile.lastIndexOf(".")+1).toUpperCase();
		StringBuffer sb1 = new StringBuffer();
	
		if( rs != null ){
			if( rs.next() ){
				java.sql.Clob cl = rs.getClob("DATA_TXT");  //웹로직
		 				//oracle.sql.CLOB cl = (oracle.sql.CLOB)(rs).getBlob("DATA_TXT"); //톰켓
				
				
				Writer writer          = null;
				FileInputStream  fi    = null;
				InputStreamReader isr  = null;
				BufferedReader bis     = null;
				
				try{
					//writer = ((weblogic.jdbc.common.OracleClob)cl).getCharacterOutputStream(); // 웹로직
					
					
					
		 					writer = cl.setCharacterStream(cl.length());
		 					
		 					
		 					//System.out.println("temp_Attach_Path 1 : " + temp_Attach_Path);
					Logger.sys.println("파일 암복화 START");
					fnFileReName(UniqFileName,temp_Attach_Path, move_path);
					Logger.sys.println("파일 암복화 END");
					File f = new File(temp_Attach_Path+"/"+UniqFileName);
					
					
					if( f.exists() ){
						fi  = new FileInputStream( f );
						isr = new InputStreamReader(fi, "UTF-8");
						bis = new BufferedReader( isr );
		
						int l      = 0;	 char[] buf = new char[1024];
		  				while( ( l = bis.read( buf ) ) != -1 ){
							writer.write( buf, 0, l );
						}
						writer.flush();
					}
				}catch(Exception e){
					//e.printStackTrace();
			        rtnht.put("SUCCESS","false");
			        rtnht.put("MESSAGE",e.getMessage());
			        			
				}finally{
			        try {
			            if (fi  != null)    fi.close();
						if (isr != null)    isr.close();
			            if (bis != null)    bis.close();
			            if (writer != null) writer.close();
			        } catch (Exception e) {
			            rtnht.put("SUCCESS","false");
			            rtnht.put("MESSAGE",e.getMessage());
			            
			        }
				}
			}
		}
	
		rtnht.put("SUCCESS","true");
		conn.commit();
		conn.setAutoCommit(true);
		
		//지워
	   //FileDelete(UniqFileName,temp_Attach_Path,Type);
	   //FileDelete(UniqFileName,move_path,Type);
	    	
	}catch(Exception e){
		//e.printStackTrace();
		try{
			if (conn != null) conn.rollback();
		}catch (Exception e1) {
			rtnht.put("SUCCESS","false");
		    rtnht.put("MESSAGE",e1.getMessage());
		    
		}finally{
			rtnht.put("SUCCESS","false");
			rtnht.put("MESSAGE",e.getMessage());
				
		}
	}finally{
		try {
			if (rs != null)           rs.close();
		    if (Attach_pstmt != null) Attach_pstmt.close();
		    if (conn != null)         conn.close();
		} catch (Exception e) {
			//e.printStackTrace();
		    rtnht.put("SUCCESS","false");
		    rtnht.put("MESSAGE",e.getMessage());
		    
		}
	}		
		}
		// BLOB
		else{
	Logger.sys.println("BLOB");
	StringBuffer Attach_Sql = new StringBuffer();
	
	Attach_Sql.append("INSERT INTO SFILE(                                         ");
	Attach_Sql.append("                    DOC_NO          		 				  ");
	Attach_Sql.append("                   ,DOC_SEQ          		 			  ");
	Attach_Sql.append("                   ,TYPE              		 			  ");
	Attach_Sql.append( "                  ,DES_FILE_NAME						  ");
	Attach_Sql.append( "                  ,SRC_FILE_NAME                          ");
	Attach_Sql.append( "                  ,FILE_SIZE    						  ");
	Attach_Sql.append( "                  ,ADD_DATE     						  ");
	Attach_Sql.append( "                  ,ADD_TIME     				          ");
	Attach_Sql.append( "                  ,CHANGE_DATE  						  ");
	Attach_Sql.append( "                  ,CHANGE_TIME                            ");
	Attach_Sql.append( "                  ,ADD_USER_ID                            ");
	Attach_Sql.append("                   ,DATA           		 				  ");
	Attach_Sql.append("           ) VALUES ( 			         				  ");
	Attach_Sql.append("                    '" + attach_key + "'	                  ");
	Attach_Sql.append("                  ,to_char('" + attach_seq +"','FM00000000')  ");
	Attach_Sql.append("                   ,'" + Type + "'	                      ");
	Attach_Sql.append("                   ,'" + UniqFileName + "'	              ");
	Attach_Sql.append("                   ,'" + FileName + "'	                  ");
	Attach_Sql.append("                   ,"  + FileSize + " 	                  ");
	Attach_Sql.append("                  ,TO_CHAR(SYSDATE,'yyyymmdd')             ");
	Attach_Sql.append("                  ,TO_CHAR(SYSDATE,'hh24miss')             ");
	Attach_Sql.append("                  ,TO_CHAR(SYSDATE,'yyyymmdd')             ");
	Attach_Sql.append("                  ,TO_CHAR(SYSDATE,'hh24miss')             ");
	Attach_Sql.append("                   ,'" + userID + "'	                      ");
	Attach_Sql.append("                   ,empty_blob()                           ");
	Attach_Sql.append("           )												  ");
		
	try {
		resource = new SepoaConnectionResource();
		conn     = resource.getConnection();
		conn.setAutoCommit(false);
	
		Attach_pstmt = conn.prepareStatement(Attach_Sql.toString());
		Attach_pstmt.executeUpdate();
		
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT DATA FROM SFILE WHERE DOC_NO = '" + attach_key + "' AND DOC_SEQ = to_char('" + attach_seq +"','FM00000000') FOR UPDATE");
	
		
		Attach_pstmt = conn.prepareStatement(sb.toString());
		rs           = Attach_pstmt.executeQuery();
		String userfile  = JSPUtil.nullToEmpty(request.getParameter("userfile"));
		String file_ext  = userfile.substring(userfile.lastIndexOf(".")+1).toUpperCase();
		StringBuffer sb1 = new StringBuffer();
	
		if( rs != null ){
			if( rs.next() ){
				java.sql.Blob cl = rs.getBlob("DATA");  //웹로직
		 				//oracle.sql.BLOB cl = (oracle.sql.BLOB)(rs).getBlob("DATA"); //톰켓			
				OutputStream writer     = null;
				FileInputStream  fi     = null;
				BufferedInputStream bis = null;
	
				try{
					//writer = ((weblogic.jdbc.vendor.oracle.OracleThinBlob)cl).getBinaryOutputStream(); //웹로직
					writer = cl.setBinaryStream(0);  //톰켓
	
		 					//System.out.println("temp_Attach_Path 2 : " + temp_Attach_Path);
					Logger.sys.println("파일 암복화 START");
					fnFileReName(UniqFileName,temp_Attach_Path, move_path);
					Logger.sys.println("파일 암복화 END");
					File f = new File(temp_Attach_Path+"/"+UniqFileName);
					
					if( f.exists() ){
						fi  = new FileInputStream(f);
						bis = new BufferedInputStream( fi );
						int l      = 0;	 byte[] buf = new byte[1024];
		  				while( ( l = bis.read( buf ) ) != -1 ){
							writer.write( buf, 0, l );
						}
						writer.flush();
					}
				}catch(Exception e){
					//e.printStackTrace();
			        rtnht.put("SUCCESS","false");
			        rtnht.put("MESSAGE",e.getMessage());
			        
				}finally{
			        try {
			            if (fi  != null)    fi.close();
			            if (bis != null)    bis.close();
			            if (writer != null) writer.close();
			        } catch (Exception e) {
			        	//e.printStackTrace();
			            rtnht.put("SUCCESS","false");
			            rtnht.put("MESSAGE",e.getMessage());
			            
			        }
				}
			}
		}
	
		rtnht.put("SUCCESS","true");
		conn.commit();
		conn.setAutoCommit(true);
		
		//지워
	   //FileDelete(UniqFileName,temp_Attach_Path,Type);
	   //FileDelete(UniqFileName,move_path,Type);
	    	
	}catch(Exception e){
		//e.printStackTrace();
		try{
			if (conn != null) conn.rollback();
		}catch (Exception e1) {
			//e1.printStackTrace();
			rtnht.put("SUCCESS","false");
		    rtnht.put("MESSAGE",e1.getMessage());
		    
		}finally{
			rtnht.put("SUCCESS","false");
			rtnht.put("MESSAGE",e.getMessage());
				
		}
	}finally{
		try {
			if (rs != null)           rs.close();
		    if (Attach_pstmt != null) Attach_pstmt.close();
		    if (conn != null)         conn.close();
	        if (resource != null) resource.release();

		} catch (Exception e) {
			//e.printStackTrace();
		    rtnht.put("SUCCESS","false");
		    rtnht.put("MESSAGE",e.getMessage());
		    
		}
	}
		}

    }else{
		Type = JSPUtil.CheckInjection(request.getParameter("type"));
		Act =  JSPUtil.CheckInjection(request.getParameter("act"));
		attach_key =  JSPUtil.CheckInjection(request.getParameter("attach_key"));
		uploads =  JSPUtil.CheckInjection(request.getParameter("uploads"));
		rowId = JSPUtil.CheckInjection(request.getParameter("rowId"));
		
        if( attach_key==null || attach_key.length() == 0 ){
      		attach_key = String.valueOf(System.currentTimeMillis());
        }
        if( Act == null ){
        	Act = "";
        }
        // 삭제
      	if( Act.equals("DELETE") ){
        	String[] str    = SepoaString.StrToArray(uploads,";");
        	rtnht           = Attach_File_DataBase_Delete(str);
        	String SUCCESS1 = (String)rtnht.get("SUCCESS");

	        if ( !SUCCESS1.equals("true") ) {
		MESSAGE =SepoaString.replace((String)rtnht.get("MESSAGE"),"\n","");
	        }
      	}else{
        	rtnht.put("SUCCESS","true");
      	}
    }

	vt =Attach_File_DataBase_Select(attach_key);
	
  	if( vt.size() > 0 ){
    	Hashtable ht2 = (Hashtable)vt.elementAt(vt.size()-1);
      	attach_seq    = (String)ht2.get("DOC_SEQ");
  	}

}catch(IOException err){
	//err.printStackTrace();
  	rtnht.put("SUCCESS","false");
  	rtnht.put("MESSAGE",err.getMessage());
  	MESSAGE = err.getMessage();
}catch(Exception e){
	//e.printStackTrace();
  	rtnht.put("SUCCESS","false");
  	rtnht.put("MESSAGE",e.getMessage());
  	MESSAGE = e.getMessage();
}finally{
	if(MESSAGE != null && !"".equals(MESSAGE) ){
		//response.sendRedirect("/include/error_msg.jsp?err_msg=ihstone");
		//System.out.println("오류 : " + MESSAGE);
		//RequestDispatcher dispatcher = request.getRequestDispatcher("/include/error_msg.jsp?err_msg="+MESSAGE);
		//dispatcher.forward(request, response);
	}
}
%>

<%-- 
<link rel="stylesheet" href="../../css/common.css"/>
<link rel="stylesheet" href="../../css/layout.css"/>
<link rel="stylesheet" href="../../css/sec_admin.css" type="text/css">
--%>
<Script language="javascript">
function Init()
{
	var err =<%=rtnht.get("SUCCESS")%>;
	var err2 =<%=rtnht.get("NOT")%>;
	var errMsg ="<%=MESSAGE%>";
  	if (err2) {
  	} else if (!err) {
    	alert(errMsg);
    	window.close();
  	}
}

function openIT()
{
    if (document.forms[0].userfile.value.length==0){
    	//alert("파일을 먼저 선택해주세요");
		alert("<%=text.get("CO_007.MSG_12")%>");
		return;
    }

    var not_file_type = "<%=G_not_file_type%>".toUpperCase();
    var user_file = document.forms[0].userfile.value;


    var attch_file_type = user_file.substring(user_file.lastIndexOf(".")+1, user_file.length).toUpperCase();

    var checkNum = not_file_type.split(";");


    var open_flag = 0;

	for(var i=0;i<checkNum.length;i++) {
        if(attch_file_type == checkNum[i]) {

        	open_flag = open_flag + 1;

        }
    }
	
    if(open_flag < 1){
    	alert("허용되지 않은 파일 종류 입니다.");
       	return;
    }
	
    /*theurl="file_add_loading.htm"
    wname ="CHROMELESSWIN"
    W=212;
    H=82;
    windowCERRARa     = ""
    windowCERRARd     = ""
    windowCERRARo     = ""
    windowTIT         = ""
    windowBORDERCOLOR     = ""
    windowBORDERCOLORsel  = ""
    windowTITBGCOLOR      = ""
    windowTITBGCOLORsel   = "" */
    //openchromeless(theurl, wname, W, H, windowCERRARa, windowCERRARd, windowCERRARo, windowTIT, windowBORDERCOLOR, windowBORDERCOLORsel, windowTITBGCOLOR, windowTITBGCOLORsel)
    
    var url = "/sepoafw/filelob/file_attach.jsp?userfile="+user_file+"&rowId="+"<%=rowId%>"+"&attch_file_type="+attch_file_type+"&attach_key=<%=attach_key%>&type=<%=Type%>";
	document.forms[0].action = url;
    document.forms[0].submit(); 

}

function setData() {
    var arrAttrach = new Array();
    var exitSeqCnt = <%=vt.size()%>;

<%for (int cnt=0;cnt<vt.size();++cnt) {

        Hashtable ht1 =(Hashtable)vt.elementAt(cnt);%>
        arrAttrach[<%=cnt%>] = new Array("<%=JSPUtil.CheckInjection3((String)ht1.get("DOC_NO"))%>",          
                                        "<%=JSPUtil.CheckInjection3((String)ht1.get("DOC_SEQ"))%>",          
                                        "<%=JSPUtil.CheckInjection3((String)ht1.get("TYPE"))%>",             
                                        "<%=JSPUtil.CheckInjection3((String)ht1.get("DES_FILE_NAME"))%>",
                                        "<%=JSPUtil.CheckInjection3((String)ht1.get("SRC_FILE_NAME"))%>",    
                                        "<%=JSPUtil.CheckInjection3((String)ht1.get("FILE_SIZE"))%>",        
                                        "<%=JSPUtil.CheckInjection3((String)ht1.get("ADD_USER_ID"))%>");
<%} // for%>

    var attach_key_value = "<%=attach_key%>";
    if (arrAttrach.length == 0) {
        attach_key_value = "";
    }
    
    var rowId = "<%=rowId%>";
    opener.setAttach(attach_key_value, arrAttrach, rowId, <%=vt.size()%>);
    window.close();
}

function Del(){
	var form          = document.forms[1];
	var len           = form.uploads.length;
	var count         = 0;
	var value         = "";
	var selectedIndex = 0;

	if(form.uploads.length < 1){
		alert("삭제할 파일이 존재하지 않습니다.");
		
		return;
	}
	
	for(cnt = 0;cnt < len; ++cnt){
		if(form.uploads.options[cnt].selected){
			value         = form.uploads.options[cnt].value;
			selectedIndex = cnt;
		}
      
	}
	
	if(value=="NO" || value == "") {
		alert("삭제할 파일이 존재하지 않습니다.");
		
		return;
	}
	//return;
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svc.common.FileServlet",
		{
			mode:"delete",
			doc:value
		},
		function(arg){
			var result     = eval('(' + arg + ')');
			var resultCode = result.code;
			
			if(resultCode == "1"){
// 				doReset();
				location.href="/sepoafw/filelob/file_attach.jsp?attach_key=<%=attach_key%>&type=<%=Type%>";
			}
			else{
				alert("삭제에 실패하였습니다.");
			}
		}
	);
}

function doReset(){
	document.form1.method="post";
	document.form1.action="file_attach.jsp";
	document.form1.submit();	
}

function view()
{
  var cnt = 0;
  var source = "";

  for (var i = 0;i < document.forms[1].uploads.length;i++) {
    if(document.forms[1].uploads[i].selected == true && i != 0) {
      cnt++;
      source = document.forms[1].uploads[i].value;
    }
  }

  if(cnt == 0) {
    alert("<%=text.get("CO_007.MSG_05")%>"); //alert("??????? ?????? ??4??.");
    return;
  }
  if(cnt > 1) {
    alert("<%=text.get("CO_007.MSG_06")%>"); //alert("????? ????; ???????y?.");
    return;
  }

  var src = source.split("&&");

 // var filepath = "<%=fileFolder%>";
 // var viewloc = filepath+"/"+src[3];
<%String down_root =  CommonUtil.getConfig("sepoa.attach.path.download");%>
  var viewloc = "<%=down_root%>../" + filepath +"/"+src[3];

  window.open(viewloc,"fileview",'left=20,top=20, width=700, height=400,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes');

}

function download()
{
    var cnt = 0;
    var source = "";

    for (var i = 0;i < document.forms[1].uploads.length;i++) {
        if(document.forms[1].uploads[i].selected == true && i != 0) {
            cnt++;
            source = document.forms[1].uploads[i].value;
        }
    }

    if(cnt == 0) {
        //alert("<%=text.get("CO_007.MSG_05")%>");
        alert("다운로드할 파일을 선택하여 주십시오.");
        return;
    }

    if(cnt > 1) {
        //alert("<%=text.get("CO_007.MSG_06")%>");
        alert("하나의 파일만 선택하여 주십시오.");
        return;
    }

    var src  = source.split("&&");
	var ext  = src[3].split(".");
	var form = document.forms[0];
	
	//alert(" filename = " + src[5] + " , realfilename = " + src[3] + " , size = " + src[4] + ", type = " + src[2] + ", ext = " + ext[1] + " , doc_no = " + src[0] + src[1]);
	//var param  = "?filename="      + src[5];
	//	param += "&realfilename="  + src[3];
	//	param += "&size="          + src[4];
	//	param += "&type="          + src[2];
	//	param += "&ext="           + ext[1];
	//	param += "&doc_no="        + src[0] + src[1];
	var param  = "?doc_no="        + src[0] + src[1];

	location.href = "file_download.jsp" + param; 
}

</Script>
</head>
<body leftmargin="30px" topmargin="0" marginwidth="0" marginheight="0"
	onload="Init();">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data" target="_self">
		<input type="hidden" name="attach_key" value="<%=attach_key%>">
		<input type="hidden" name="act" value="<%=Act%>"> <input
			type="hidden" name="type" value="<%=Type%>"> <input
			type="hidden" name="view_type" value="<%=View_type%>"> <input
			type="hidden" name="CurFileSize" value="<%=CurFileSize%>"> <input
			type="hidden" name="attach_seq"
			value="<%=(Integer.parseInt(attach_seq)+1)%>">

		<table width="99%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class='title_page' height="20" align="left" valign="bottom">
					<%
						String pageMainTitle = null;

						if(View_type.equals("VI") == false){
							pageMainTitle = (String)text.get("CO_007.TXT_01");
						}
						else{
							pageMainTitle = (String)text.get("CO_007.TXT_13");
						}
					%> <span class='location_end'><%=pageMainTitle%></span>
				</td>
			</tr>
		</table>
		<table width="99%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5">&nbsp;</td>
			</tr>
		</table>
		<%
			if(View_type.equals("VI") == false){
		%>
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0"
						bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="50%" class="title_td"><img
											src="/images/dot_orange.gif" width="23" height="11"
											align="absmiddle"><%=text.get("CO_007.TXT_02")%></td>
										<td width="50%" class="title_td"><img
											src="/images/dot_orange.gif" width="23" height="11"
											align="absmiddle"><%=text.get("CO_007.TXT_07")%></td>
									</tr>
									<tr>
										<td colspan="2" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="50%" class="data_td"
											style="line-height: 18px; padding: 5px 5px 5px 5px;">
											<ul>
												<li>&nbsp;&nbsp;<img src="/images/blt_2depth.gif"
													width="4" height="5" align="absmiddle">&nbsp;<%=text.get("CO_007.TXT_03")%></li>
												<li>&nbsp;&nbsp;<img src="/images/blt_2depth.gif"
													width="4" height="5" align="absmiddle">&nbsp;<%=text.get("CO_007.TXT_04")%>
													<%=text.get("CO_007.TXT_05")%></li>
												<li>&nbsp;&nbsp;<img src="/images/blt_2depth.gif"
													width="4" height="5" align="absmiddle">&nbsp;<%=text.get("CO_007.TXT_06")%></li>
												<li>&nbsp;&nbsp;<img src="/images/blt_2depth.gif"
													width="4" height="5" align="absmiddle">&nbsp;<%=text.get("CO_007.TXT_11")%>
													<%=conf_filesize%><%=text.get("CO_007.TXT_12")%></li>
											</ul>
										</td>
										<td width="50%" class="data_td"
											style="line-height: 18px; padding: 5px 5px 5px 5px;">
											<ul>
												<li>&nbsp;&nbsp;<img src="/images/blt_2depth.gif"
													width="4" height="5" align="absmiddle">&nbsp;<%=text.get("CO_007.TXT_08")%>
													<%=text.get("CO_007.TXT_09")%></li>
												<li>&nbsp;&nbsp;<img src="/images/blt_2depth.gif"
													width="4" height="5" align="absmiddle">&nbsp;<%=text.get("CO_007.TXT_10")%></li>
												<br />
												<br />
											</ul>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br />
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0"
						bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img
											src="/images/blt_srch.gif" width="7" height="7"
											align="absmiddle">&nbsp;&nbsp;<%=text.get("CO_007.file_select")%></td>
										<td class="data_td">
											<table width="90%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="10">&nbsp;</td>
													<td align="left"><input type="file" id="userfile"
														name="userfile" size="30" maxlength="60"></td>
													<td align="left"><script language="javascript">
														btn("javascript:openIT();","<%=text.get("BUTTON.add")%>");
													</script></td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<%
			}
		%>
	</form>
	<br />
	<form name="form2" method="post" target="_self"
		action="<%=request.getRequestURI()%>">
		<input type="hidden" name="attach_key" value="<%=attach_key%>">
		<input type="hidden" name="type" value="<%=Type%>"> <input
			type="hidden" name="act" value="<%=Act%>"> <input
			type="hidden" name="CurFileSize" value="<%=CurFileSize%>"> <input
			type="hidden" name="attach_seq"
			value="<%=(Integer.parseInt(attach_seq)+1)%>"> <input
			type="hidden" name="rowId" value="<%=rowId%>">

		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0"
						bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img
											src="/images/blt_srch.gif" width="7" height="7"
											align="absmiddle">&nbsp;&nbsp;<%=text.get("CO_007.file_add_list")%></td>
										<td class="data_td">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0">
												<tr>
													<td width="10">&nbsp;</td>
													<td valign="top"><select name="uploads" id="uploads"
														size="5" style="height: 120px;">
															<option VALUE="NO">----------------------------<%=text.get("CO_007.file_add_name")%>----------------------------
															</option>
															<%
																long size=0;
																												String Ssize="0";
																												String strPrnStr= "";
																												
																												for(int cnt=0;cnt<vt.size();++cnt) {
																													strPrnStr= "";
																													Hashtable ht1 =(Hashtable)vt.elementAt(cnt);
																													Ssize =(String)ht1.get("FILE_SIZE");
																													
																													if (Ssize==null){
																														Ssize="0";
																													}
																											                          
																													size = Long.parseLong(Ssize);
																													
																													if ((size/1024)< Integer.parseInt(G_file_size)){
																														Ssize = size+"B";
																													}
																													else{
																														Ssize = (size/1024)+"KB";
																													}
																											
																													// 2015-12-21 : 소스스캔에서 취약점(XSS)으로 발견되었으나, 사용자의 정보를 사용하지 않으므로 대상제외.
																													//&& : delimeter
																													strPrnStr = strPrnStr + "<OPTION VALUE=\"" + JSPUtil.CheckInjection3((String)ht1.get("DOC_NO")) + "&&" + JSPUtil.CheckInjection3((String)ht1.get("DOC_SEQ")) + "&&" + JSPUtil.CheckInjection3((String)ht1.get("TYPE")) + "&&" + JSPUtil.CheckInjection3((String)ht1.get("SRC_FILE_NAME")) + "&&" + JSPUtil.CheckInjection3((String)ht1.get("FILE_SIZE")) + "&&" + JSPUtil.CheckInjection3((String)ht1.get("DES_FILE_NAME")) + "\">";
																													strPrnStr = strPrnStr + ht1.get("SRC_FILE_NAME") + "(" + Ssize + ")</OPTION>\n";
																													out.println(strPrnStr);
																													//out.println("<OPTION VALUE=\""+ht1.get("DOC_NO")+"&&"+ht1.get("DOC_SEQ")+"&&"+ht1.get("TYPE")+"&&"+ht1.get("SRC_FILE_NAME")+"&&"+ht1.get("FILE_SIZE")+"&&"+ht1.get("DES_FILE_NAME")+"\">");
																													//out.println(ht1.get("SRC_FILE_NAME")+"("+Ssize+")</OPTION>\n");
																												}
															%>
													</select></td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<%
					if(View_type.equals("VI") == false){
				%>
				<TABLE cellpadding="0" align="right">
					<TR>
						<TD><script language="javascript">btn("javascript:Del()","<%=text.get("BUTTON.deleted")%>")</script></TD>
						<TD><script language="javascript">btn("javascript:setData()","<%=text.get("BUTTON.confirm")%>")</script></TD>
						<TD style="display: none"><script language="javascript">btn("javascript:download()","<%=text.get("BUTTON.download")%>")</script>
						</TD>
						<TD><script language="javascript">btn("javascript:window.close()","<%=text.get("BUTTON.close")%>")</script></TD>
					</TR>
				</TABLE> <%
 	}
 	else{
 %>
				<TABLE cellpadding="0" align="right">
					<TR>
						<TD><script language="javascript">btn("javascript:download()","<%=text.get("BUTTON.download")%>")</script>
						</TD>
						<TD><script language="javascript">btn("javascript:window.close()","<%=text.get("BUTTON.close")%>
							")
						</script></TD>
					</TR>
				</TABLE> <%
 	}
 %>
			</td>
		</tr>
	</table>
</body>
</html>

