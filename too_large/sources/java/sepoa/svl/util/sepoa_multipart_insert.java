package sepoa.svl.util;
/*
 * 가정 : 파일 업로드는 1회(서블릿 처리)에 하나의 파일만 가능하다는 가정하에 진행한다.
 * 
 */
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Vector;
import java.util.zip.ZipOutputStream;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.msg.MessageUtil;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

public class Sepoa_Multipart_INSERT extends HttpServlet {
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
    	fileUpload(req, res, info);
	}

	public void fileUpload(HttpServletRequest req, HttpServletResponse res, SepoaInfo info) {
		// response에 대한 정의 - jQuery ajax post 방식으로 request를 전달받았다. 
		// response는 json 방식으로 return 하기 위해 JSON관련 jar 파일이 필요하다. json-simple-1.1.1.jar
		//res.setContentType("application/json");
		res.setContentType("text/html;charset=UTF-8");
		res.setCharacterEncoding("UTF-8");

		/**
		 * 반환할 json 객체 설정
		 * */
		JSONArray jArray = new JSONArray();
		JSONObject jValue = new JSONObject(); 
		
		// status : 업로드 상태값
		// 1은 성공
		// 2는 실패(일반적인 오류들... ex 업로드 용량 초과, DB접속 실패,,,)
		// 3은 잘못된 확장자 사용시 실패오류(jsp단에서 막을테지만, 다시 한번 더 체크)
		// 4는 파일 이름 변경 실패(서버 PC의 java 문제)
		// 5는 DB 저장 오류
		// 6은 마지막 PrintWriter 오류
		int status = 2;
		String temp_Attach_Path="";
		String move_path="";
		String message="";

		int maxSize = 0; 
		Hashtable<String,String> insertDB = new Hashtable<String,String>();
		String resultOfDB = "";	
		Vector vt = new Vector();
		
	    String buyer = "";
	    if(info.getSession("COMPANY_CODE") == null ) { buyer = "SYSTEM";}
	    else {buyer = info.getSession("COMPANY_CODE");}

	    String userID = "";
	    if(info.getSession("ID") == null ) {userID = "SYSTEM";}
	    else {userID = info.getSession("ID");}

	    String userName = "";
	    if(info.getSession("NAME_LOC") == null ) {userName = "SYSTEM";}
	    else { userName = info.getSession("NAME_LOC");}

	    String userDept = "";
	    if(info.getSession("DEPARTMENT") == null ) {userDept = "SYSTEM";}
	    else { userDept = info.getSession("DEPARTMENT");}

	    String userDeptName = "";
	    if(info.getSession("DEPARTMENT_NAME_LOC") == null ) {userDeptName = "SYSTEM";}
	    else { userDeptName = info.getSession("DEPARTMENT_NAME_LOC");}

	    String userTel = "";
	    if(info.getSession("TEL") == null ) {userTel = "SYSTEM";}
	    else {userTel = info.getSession("TEL");}

		try {
			
			Vector multilang_id = new Vector();
			multilang_id.addElement("CO_007");
			HashMap text = MessageUtil.getMessage(info,multilang_id);
			
			Config conf = new Configuration();
			//파일 저장될 주소(우선 TEMP에 저장하고나서, 유효성 검사를 마친후 원하는 폴더로 이동시킨다.)
		    temp_Attach_Path = conf.get("sepoa.attach.path.TEMP");				// C:/apache-tomcat-6.0.16-hysco-auc-test-ie10/Poa-SRM/V1.0.0/attachments/TEMP
		    
		    //파일크기
			String G_file_size = conf.get("sepoa.attach.maxsize");				// 15
			maxSize = 1024*1024 * Integer.parseInt(G_file_size);				// 15M - 용량 초과하면 java.io.IOException 발생
			//파일확장자
		    String G_file_type = conf.get("sepoa.file.attach.type");			// zip;ppt;gul;jpg;doc;xls;gif;bmp;txt;hwp;pdf;docx;xlsx;pptx;png
		    
		    /**
		     * 파일 업로드 작업 - MultipartRequest 생성자 함수에서 자동으로 이루어짐.
		     * */
			//ServletContext scontext = req.getServletContext();
			//realFolder = scontext.getRealPath(savefile); // 예) 이클립스 폴더 내에
		    // 파일이 저장될 경로
			//realFolder = "d:\\imgs"; // 위치 강제 지정
		    MultipartRequest multi = new MultipartRequest(req, temp_Attach_Path,
					maxSize, "utf-8", new DefaultFileRenamePolicy());	
		    //new DefaultFileRenamePolicy() : 중복된 파일 이름의 경우 이름 뒤에 1,2,3,,, 붙여주는 기본 정책 
			
		    /**
		     * 파일 업로드 후, 생성된 인스턴스(multi)를 통해 form의 parameter를 꺼내올 수 있다.
		     * */
		    // form 데이터 출력
		    String type = multi.getParameter("type");;					// 폴더명(CATALOG, NOT,,,)
		    if(type == null || "".equals(type)){
		    	
		    	type = "TEMP";	//기본값
		    }
		    String attach_key = multi.getParameter("attach_key");;		// 1234567890123
		    if(attach_key == null){
		    	
		    	attach_key = String.valueOf(System.currentTimeMillis());
		    }
		    String attach_seq = multi.getParameter("attach_seq");;		// 1,2,3,4,,,,
		    if(attach_seq == null || "".equals(attach_seq)){
		    	
		    	attach_seq = "1";	//기본값
		    }
		    
		    /**
		     * 파일 업로드 후, 생성된 인스턴스(multi)를 통해 업로드된 파일의 정보를 받아올 수 있다.
		     * */
			// 파일 이름 출력
			Enumeration<String> files = multi.getFileNames();
			File file1 = null;
			File file2 = null;
			move_path = conf.get("sepoa.attach.path."+type);					// C:/apache-tomcat-6.0.16-hysco-auc-test-ie10/Poa-SRM/V1.0.0/attachments/CATALOG
			File dir = new File(move_path);
			if(!dir.exists()){	dir.mkdir(); }
			String fileName = "";
			boolean renameResult = false;
			
			//while 이지만 실상 파일은 1개 이므로 1회 loop를 돈다.
			while (files.hasMoreElements()) {
				fileName = (String) files.nextElement();
				file1 = multi.getFile(fileName);
				file2 = new File(move_path + "/" + buyer+"_"+String.valueOf(System.currentTimeMillis())); // 변경할 파일 이름
				
				// fileName : userfile			//form-input-file의 name 속성값
				// file1.getName() : AAA.jpg
				
				/**
				 * 파일 확장자 검사
				 * */
  				//1.파일이름이 잘못된 확장자를 포함하는 경우 삭제하고, 중지한다.
				String[] file_type = G_file_type.split(";");
		        boolean flag = false;
		        for(int i = 0; i < file_type.length; i++ ) {
		            if(file1.getName().toLowerCase().endsWith("." + file_type[i])) {
		            	flag = true;	//fileName이 첨부 가능 확장자 목록에 포함되어 있을시
		            	break;
		            }
		        }
		        
		        if(!flag) {
	        		//MESSAGE = "파일첨부가 제한된 확장자입니다.\n" + G_file_type + " 가능합니다.";
	        		//파일 삭제하기
	        		
	        		if(!file1.delete()){	//파일 삭제 실패시
	        			status = 4;
		        		throw new Exception("filename(" + file1.getName() + ") is not a proper name. So try delete file in temp. But file cannot be deleted. because of JDK  , status="+status);
	        		}
	        		//throw new Exception(MESSAGE);
	        		//경고메시지 주기
	        		status = 3;
	        		throw new Exception("filename(" + file1.getName() + ") is not a proper name. Check name extention. ex) .jpg, .gif , status="+status);
		        }
		        
		        /**
		         * 파일명 수정(파일 주소 이동)
		         * */
		        // 파일명 수정
				// renameTo() 메소드는 플랫폼 의존적 메소드이므로 제대로 동작이 되는지 반드시 확인해야 한다.
				// 만약 false가 반환된다면 복사 방식으로 구현해야 한다.(퍼미션 관련)
				
				
				//파일 주소 및 이름 변경
				renameResult = file1.renameTo(file2);
				
				if(!renameResult){
					// renameTo함수가 동작하지 않을시 파일을 복사한다.
					
					status = 4;
					throw new Exception("During renaming file name, there is a failure. Because of JDK.");
					//try - catch 실패하면 중단!
				}
				
				/**
				 * DB sfile에 insert
				 * */
				//2.DB sfile에 저장한다.
		        insertDB.put("FILE_NAME",file1.getName());
		        insertDB.put("UNIQ_FILE_NAME",file2.getName());
		        insertDB.put("TYPE",type);
		        insertDB.put("ATTACH_KEY",attach_key);
		        insertDB.put("ATTACH_SEQ",attach_seq);
		        insertDB.put("COM_CODE",buyer);
		        insertDB.put("USER_ID",userID);
		        insertDB.put("USER_NAME",userName);
		        insertDB.put("FILE_SIZE",String.valueOf(file2.length()));
		        resultOfDB = Attach_File_DataBase_Insert(insertDB,info);
		        
		        // DB 실패시 오류 발생.....
		        if("false".equals(resultOfDB)){
		        	status = 5;
		        	throw new Exception("DB connection failure or sql problem.");
		        }else{
		        	//성공시
		        	jValue.put("value",insertDB);
		        }
		        
		        //멀티 첨부의 경우 attach_seq가 모두 같은 값으로 들어온다.그렇기에 while이 돌면서 1씩 증가시켜준다.
		        attach_seq = Integer.parseInt(attach_seq) + 1 +"";
			}
			
			Logger.sys.println("file upload success");
			status = 1;	//마지막까지 성공할시
		} catch (Exception e) {
				//status 기본값이 2 이므로 마지막까지 성공하지 않았으면 자동으로 status는 2이다.
		        jValue.put("value",null);
		        // 오류중에서 구분할 수 없는 오류는 status:2로 두고 있다. 이 중에서 에러 message를 통해 용량 초과 오류를 구분할 수 있다.
		        // 용량 초과인 경우 이와 같은 에러 메시지가 나온다. >> Posted content length of 127608084 exceeds limit of 15728640
		        message = e.getMessage();	
		        
		        Logger.err.println(info.getSession("ID"), this, e.getMessage());
		} finally{
			PrintWriter out = null;
			try {
				out = res.getWriter();
			} catch (IOException e) {
				status = 6;
				
				Logger.err.println(info.getSession("ID"), this, e.getMessage());
			}
			
			
			jValue.put("status",status);
			jValue.put("message",message);
			jArray.add(0,jValue);	// 더 넣을려면, 1,2,3,4,,,
			if(out != null){
				out.println(jArray);
				out.flush(); }
/* json 데이터 형태이다
			[{
		 		"status":"1",
				 "value":{"FILE_NAME":"1 - 복사본.jpg",
						"ATTACH_KEY":"1385019752721",
						"UNIQ_FILE_NAME":"1000_1385019756996",
						"COM_CODE":"1000",
						"USER_ID":"CAPTEST",
						"USER_NAME":"CAP TEST",
						"ATTACH_SEQ":"1",
						"FILE_SIZE":"4277",
						"TYPE":"CATALOG"},
				"message":""   <----------- status=2 인 경우 e.getMessage()의 내용이 들어감
		 	}]
*/
		}
	}

	private String Attach_File_DataBase_Insert(Hashtable ht, SepoaInfo info)
			throws Exception {
		String result = "false";
		//보통은 SepoaService를 상속해서 사용하지만, 이미 다른 클래스를 상속받아 사용하고 있다.(서블릿이므로)
		//그래서 추상클래스인 SepoaService를 생성해서 사용하기로 한다. 추상이므로 inner class 와 같은 형태로 나타난다. {}... 
		SepoaService ss = new SepoaService("TRANSACTION", info) {};	
        sepoa.fw.db.ConnectionContext ctx =  ss.getConnectionContext();
        StringBuffer Attach_Sql = new StringBuffer();
        try
        {
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
            sm.removeAllValue();
            Attach_Sql.append("INSERT INTO sfile( 				\n");
            Attach_Sql.append("                    DOC_NO,       \n");
            Attach_Sql.append("                   TYPE,          \n");
            Attach_Sql.append("                   DES_FILE_NAME, \n");
            Attach_Sql.append("                   SRC_FILE_NAME, \n");
            Attach_Sql.append("                   FILE_SIZE,     \n");
            Attach_Sql.append("                    DOC_SEQ,      \n");
            Attach_Sql.append("                   ADD_DATE,      \n");
            Attach_Sql.append("                   ADD_TIME,      \n");
            Attach_Sql.append("                   CHANGE_DATE,   \n");
            Attach_Sql.append("                   CHANGE_TIME,   \n");
            Attach_Sql.append("                   ADD_USER_ID )  \n");
            // Attach_Sql.append( "                   ADD_USER_NAME \n");
            Attach_Sql.append(" VALUES ( ");
            Attach_Sql.append("      ? ,");sm.addStringParameter((String)ht.get("ATTACH_KEY"));
            // Attach_Sql.append(
            // "      to_char(?,'FM00000000') ,");sm.addStringParameter((String)ht.get("ATTACH_SEQ")); //oracle
            // Attach_Sql.append(
            //Attach_Sql.append("      CONVERT(?,'FM00000000') ,");sm.addStringParameter((String)ht.get("ATTACH_SEQ")); //mssql
            Attach_Sql.append("      ?, ");sm.addStringParameter((String)ht.get("TYPE"));
            Attach_Sql.append("      ?,");sm.addStringParameter((String)ht.get("UNIQ_FILE_NAME"));
            Attach_Sql.append("      ?,");sm.addStringParameter((String)ht.get("FILE_NAME"));
            Attach_Sql.append("      ?,");sm.addNumberParameter((String)ht.get("FILE_SIZE"));
            if ("ORACLE".equals(ss.SEPOA_DB_VENDOR)){
            	Attach_Sql.append("      lpad(?,'8','0') ,");sm.addStringParameter((String)ht.get("ATTACH_SEQ"));
            	Attach_Sql.append("      TO_CHAR(SYSDATE,'yyyymmdd'), ");
                Attach_Sql.append("      TO_CHAR(SYSDATE,'hh24miss'), ");
                Attach_Sql.append("      TO_CHAR(SYSDATE,'yyyymmdd'), ");
                Attach_Sql.append("      TO_CHAR(SYSDATE,'hh24miss'), ");
            }else if ("MSSQL".equals(ss.SEPOA_DB_VENDOR)){
            	//Attach_Sql.append("      dbo.lpad(?,'8','0') ,");sm.addStringParameter((String)ht.get("ATTACH_SEQ"));
            	//오토에버의 dbo.lpad함수를 풀어서 사용함.
            	Attach_Sql.append(" CASE WHEN LEN(?) >= 8  ");sm.addStringParameter((String)ht.get("ATTACH_SEQ"));
    			Attach_Sql.append(" THEN SUBSTRING(?, 1, 8) ");sm.addStringParameter((String)ht.get("ATTACH_SEQ"));
				Attach_Sql.append(" ELSE SUBSTRING(REPLICATE('0', 8), 1, 8 - LEN(?)) + ? END, ");
				sm.addStringParameter((String)ht.get("ATTACH_SEQ"));
				sm.addStringParameter((String)ht.get("ATTACH_SEQ"));
            	
            	Attach_Sql.append(" 	 convert(varchar(8), getdate() , 112) , ");//20130101
        		Attach_Sql.append(" 	 convert(varchar(5), getdate() , 114) , ");//12:45
        		Attach_Sql.append(" 	 convert(varchar(8), getdate() , 112) , ");
        		Attach_Sql.append(" 	 convert(varchar(5), getdate() , 114) , "); 
            }else if("MYSQL".equals(ss.SEPOA_DB_VENDOR)){
            	Logger.debug.println();
            }
            
            /*
             * //mssql Attach_Sql.append(
             * "      convert(varchar(8), getdate() , 112) , "); Attach_Sql.append(
             * "      convert(varchar(5), getdate() , 114) , "); Attach_Sql.append(
             * "      convert(varchar(8), getdate() , 112) , "); Attach_Sql.append(
             * "      convert(varchar(5), getdate() , 114) , "); //mysql
             * Attach_Sql.append( "      date_format( now() , '%Y%m%d') , ");
             * Attach_Sql.append( "      date_format( now() , '%H%i%S'), ");
             * Attach_Sql.append( "      date_format( now() , '%Y%m%d') , ");
             * Attach_Sql.append( "      date_format( now() , '%H%i%S'), ");
             */
            Attach_Sql.append("      ? )");sm.addStringParameter((String)ht.get("USER_ID"));
            sm.doInsert(Attach_Sql.toString());
            
            ss.Commit();
            result = "true";
        }catch(Exception e){
        	ss.Rollback();
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        	
        }finally{
        	ss.Release();	
        	//보통은 doService를 이용하여 doService안에서 자동으로 db release가 일어나지만
        	//여기서는 doService는 이용하지 않고, 단지 connection만 사용하기에 별도로 release 작업이 필요하다. 
        }
		return result;
	}
}