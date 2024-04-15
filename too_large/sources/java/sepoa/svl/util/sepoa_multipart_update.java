package sepoa.svl.util;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

public class Sepoa_Multipart_UPDATE extends HttpServlet {
	public void init(ServletConfig config) throws ServletException {
		Logger.debug.println();
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res)
			throws IOException, ServletException {
		doPost(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) {
		
		SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);
		if(info.getSession("ID").trim().length() <= 0)
		{
			info = new SepoaInfo("100","COMPANY_CODE=1000^@^ID=SUPPLIER^@^LANGUAGE=EN^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^USER_TYPE=S^@^");
		}
		
		String mode = req.getParameter("mode");
		if("XSADDLXSAD".equals(mode)){
			delete(req,res,info);	//삭제
		}else if("RTZPDWRTZP".equals(mode)){	//파일 다운로드
			Logger.debug.println();
			//download(req,res,info);			//file_download_2013.jsp 가 대신한다.
		}
	}
	public void delete(HttpServletRequest req, HttpServletResponse res, SepoaInfo info){
		
		//파일 삭제 상태
		int status = 2;
		// 1은 성공
		// 2는 실패
		// 3은 DB 삭제 실패
		// 4는 파일 삭제 실패
		// 5는 PrintWriter 오류
		
		//res.setContentType("application/json");
		res.setContentType("text/html;charset=UTF-8");
		res.setCharacterEncoding("UTF-8");
		
		JSONArray jArray = new JSONArray();
		JSONObject jValue = new JSONObject();
		
		String uploads = req.getParameter("uploads");
		
		
		String[] str = SepoaString.StrToArray(uploads,"__");
		// uploads : 1385085807275__1 
		// str[0] : 1385085807275
		// str[1] : 1
		
		
		try{
			//DB정보 가져오기(TYPE,DES_FILE_NAME,SRC_FILE_NAME), DB삭제하기 전에 가져온다.
			String[] dbResult = getSfileInfo(str,info);
			if(dbResult == null || dbResult[0] == null || dbResult[1] == null || dbResult[2] == null){
				status = 3;	//DB 오류
				throw new Exception("DB connection failure or sql problem.");
			}
			
			//DB삭제
			String result = Attach_File_DataBase_Delete(str,info);
        
        	Config conf = new Configuration();
        	String move_path = "";
        	if ("true".equals(result)) {
        		//DB삭제 성공 후 서버의 파일 삭제
        		move_path = conf.get("sepoa.attach.path."+dbResult[0]);				//TYPE (폴더명)
        		boolean resultOfFileDelete = FileDelete(dbResult[1],move_path);		//DES_FILE_NAME (변경된 파일 이름)
        		if(resultOfFileDelete == false){
        			// Java 파일 처리 오류
        			status = 4;
        			throw new Exception("During deleting file , there is a failure. Because of JDK.");
        		}
        		
        	}else {
        		//에러 메시지 추가
        		status = 3;	//DB 오류
    			throw new Exception("DB connection failure or sql problem.");
        	}
        	
        	Logger.sys.println("file delete success");
        	status = 1;
        }catch(Exception e){
        	//에러 메시지 추가
        	
        	Logger.sys.println("file delete fail");
        }finally{
        	PrintWriter out = null;
        	try {
				out = res.getWriter();
			} catch (IOException e) {
				status = 5;
				
			}
        	
        	
        	jValue.put("status", status);
        	jArray.add(jValue);
        	if(out != null){ out.println(jArray); }
/*
			json 데이터 양식 : 
			[{"status":"1"}]
*/
        }
		
	}
	
	private String Attach_File_DataBase_Delete(String[] arr, SepoaInfo info){ 

		String result = "false";
		String userID = "";
		if(info.getSession("ID") == null ) {userID = "SYSTEM";}
		else {userID = info.getSession("ID");}
		
		SepoaService ss = null;
        ConnectionContext ctx =  null;
        try{
        	ss = new SepoaService("TRANSACTION", info) {};
        	ctx = ss.getConnectionContext();
        	
	    	StringBuffer Attach_Sql = new StringBuffer();
	    	ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
	    	sm.removeAllValue();
	    	Attach_Sql.append(" DELETE FROM sfile \n");
	    	Attach_Sql.append(" WHERE 1=1 ");
	    	Attach_Sql.append(" AND DOC_NO = ?  \n");sm.addStringParameter(arr[0]);
	    	if ("ORACLE".equals(ss.SEPOA_DB_VENDOR)){
            	Attach_Sql.append(" AND DOC_SEQ = lpad(?,'8','0') ");sm.addStringParameter(arr[1]);
            }else if ("MSSQL".equals(ss.SEPOA_DB_VENDOR)){
            	//Attach_Sql.append(" AND DOC_SEQ = dbo.lpad(?,'8','0') ");sm.addStringParameter(arr[1]);
            	//오토에버의 dbo.lpad함수를 풀어서 사용함.
            	Attach_Sql.append(" AND DOC_SEQ = CASE WHEN LEN(?) >= 8  ");sm.addStringParameter(arr[1]);
    			Attach_Sql.append(" THEN SUBSTRING(?, 1, 8) ");sm.addStringParameter(arr[1]);
				Attach_Sql.append(" ELSE SUBSTRING(REPLICATE('0', 8), 1, 8 - LEN(?)) + ? END ");
				sm.addStringParameter(arr[1]);
				sm.addStringParameter(arr[1]);
            }
	    	//Attach_Sql.append(" AND ADD_USER_ID = ? ");sm.addStringParameter(userID);
	    	sm.doDelete(Attach_Sql.toString());
	    	
	    	ss.Commit();
	    	result = "true";
	    }catch(Exception e){
        	try {
				if(ss != null){ ss.Rollback(); }
			} catch (SepoaServiceException e1) {
				Logger.debug.println();
			}
            Logger.debug.println(info.getSession("ID"), this, e.getMessage());
        	
        }finally{
        	if(ss != null){ ss.Release(); }	
        	//보통은 doService를 이용하여 doService안에서 자동으로 db release가 일어나지만
        	//여기서는 doService는 이용하지 않고, 단지 connection만 사용하기에 별도로 release 작업이 필요하다. 
        }
		
		return result;
	}
	
	private String[] getSfileInfo(String[] arr, SepoaInfo info){
		
		String[] result = new String[3];
		SepoaService ss = null;
        sepoa.fw.db.ConnectionContext ctx =  null;

        try{
        	ss = new SepoaService("CONNECTION", info) {};
        	ctx =  ss.getConnectionContext();
        	
        	StringBuffer Attach_Sql = new StringBuffer();
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
            sm.removeAllValue();
			Attach_Sql.append(" SELECT TYPE \n");
			Attach_Sql.append("		,DES_FILE_NAME \n");
			Attach_Sql.append("		,SRC_FILE_NAME \n");
			Attach_Sql.append(" FROM sfile \n");
			Attach_Sql.append(" WHERE 1=1 \n ");
			Attach_Sql.append(sm.addFixString(" AND DOC_NO = ? \n"));sm.addStringParameter(arr[0]);
	    	if ("ORACLE".equals(ss.SEPOA_DB_VENDOR)){
            	Attach_Sql.append(sm.addFixString(" AND DOC_SEQ = lpad(?,'8','0') "));sm.addStringParameter(arr[1]);
            }else if ("MSSQL".equals(ss.SEPOA_DB_VENDOR)){
            	//Attach_Sql.append(sm.addFixString(" AND DOC_SEQ = dbo.lpad(?,'8','0') "));sm.addStringParameter(arr[1]);
            	//오토에버의 dbo.lpad함수를 풀어서 사용함.
            	Attach_Sql.append(sm.addFixString(" AND DOC_SEQ = CASE WHEN LEN(?) >= 8  "));sm.addStringParameter(arr[1]);
    			Attach_Sql.append(sm.addFixString(" THEN SUBSTRING(?, 1, 8) "));sm.addStringParameter(arr[1]);
				Attach_Sql.append(sm.addFixString(" ELSE SUBSTRING(REPLICATE('0', 8), 1, 8 - LEN(?)) "));sm.addStringParameter(arr[1]);
				Attach_Sql.append(sm.addFixString(" + ? END "));sm.addStringParameter(arr[1]);
            }
			String rtn = sm.doSelect(Attach_Sql.toString());
			
			SepoaFormater sf = new SepoaFormater(rtn);

			result[0] = sf.getValue("TYPE",0);			// TYPE
			result[1] = sf.getValue("DES_FILE_NAME",0);	// DES_FILE_NAME
			result[2] = sf.getValue("SRC_FILE_NAME",0);	// SRC_FILE_NAME
			
        }catch(Exception e){
            Logger.debug.println(info.getSession("ID"), this, e.getMessage());
        	
        }finally{
        	if(ss != null){ ss.Release(); }	
        	//보통은 doService를 이용하여 doService안에서 자동으로 db release가 일어나지만
        	//여기서는 doService는 이용하지 않고, 단지 connection만 사용하기에 별도로 release 작업이 필요하다. 
        }
		return result;
	}
	
	private boolean FileDelete(String sfilename,String path)
	{
		boolean result = false;
	    try {
		    File f = new File(path + "/" + sfilename);
		    
		    result = f.delete();
	    }catch(Exception e) {
	    	Logger.debug.println();
	    }
	    return result;
	}
	
	// file_download.jsp 의 내용이다.
	/*	public void download(HttpServletRequest req, HttpServletResponse res, SepoaInfo info){
	String uploads = req.getParameter("uploads");
	System.out.println("uploads="+uploads);
	
	String[] str =SepoaString.StrToArray(uploads,"__");
	// uploads : 1385085807275__1 
	// str[0] : 1385085807275
	// str[1] : 1

	System.out.println("str="+Arrays.toString(str));
	
	//DB정보 가져오기(TYPE,DES_FILE_NAME,SRC_FILE_NAME), DB삭제하기 전에 가져온다.
	String[] dbResult = getSfileInfo(str);
	
	System.out.println("type="+dbResult[0]);
	System.out.println("des="+dbResult[1]);
	System.out.println("src="+dbResult[2]);
	InputStream in = null;
	OutputStream os = null;

	 try
	 {
	   	Config conf = new Configuration();
	   	String down_root = conf.get("sepoa.attach.path.download");
		String att_file  = "";
	   	String filename  = "";
	   	
	    
	    try
		{
	            String type = dbResult[0]; 								//TYPE
	            String desFileName = dbResult[1];						//DES_FILE_NAME
	            filename  = URLEncoder.encode(dbResult[2], "UTF-8");	//SRC_FILE_NAME

		        att_file  = conf.get("sepoa.attach.view."+type) + "/" + desFileName;
		        System.out.println("att_file="+att_file);
	            
	    } catch (Exception e) {
	        e.printStackTrace();
	        throw new Exception("Error is occured in Processing.");
	    } finally {
	    }
	   	
	   	File file = new File(down_root + att_file);
	   	System.out.println("file="+file.getAbsolutePath());
	   	in = new FileInputStream(file);
	   	
	   	res.reset() ;
	    res.setContentType("application/smnet");
	   	res.setHeader ("Content-Type", "application/smnet; charset=UTF-8");
	   	res.setHeader ("Content-Disposition", "attachment; filename="+filename+"\"" );
	   	res.setHeader ("Content-Transfer-Encoding", "binary"); 
	   	res.setHeader ("Content-Length", ""+file.length());
	   	
	   	os = res.getOutputStream();
	  
	    byte b[] = new byte[(int)file.length()];
	    int leng = 0;
	    while( (leng = in.read(b)) > 0 ) {
	     	os.write(b,0,leng);
	     	os.flush();
	    }

	 } catch(Exception e) {
	  	System.out.println(e.getMessage());
	  	try {
			res.sendRedirect("/poasrm/errorPage/system_error.jsp");
		} catch (IOException e1) {
			e1.printStackTrace();
		}		
	 } finally {
		if(in !=null)try{in.close();}catch(Exception e){}
		if(os !=null)try{os.close();}catch(Exception e){}
	 }		
}	*/	
}