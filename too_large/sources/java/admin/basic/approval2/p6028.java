package admin.basic.approval2; 

import java.util.HashMap;
import java.util.Map;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.DBOpenException;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaFormater;

public class p6028 extends SepoaService { 
	private Message msg; 
	
    public p6028(String opt, SepoaInfo info) throws SepoaServiceException{ 
        super(opt, info); 
        setVersion("1.0.0"); 
        msg = new Message(info,"p10_pra");
    }
	public String getConfig(String s)                                                               
	{                                                                                         
	    try                                                                                   
	    {                                                                                     
	        Configuration configuration = new Configuration();                                
	        s = configuration.get(s);                                                         
	        return s;                                                                         
	    }                                                                                     
	    catch(ConfigurationException configurationexception)                                  
	    {                                                                                     
	        Logger.sys.println("getConfig error : " + configurationexception.getMessage()); 
	    }                                                                                     
	    catch(Exception exception)                                                            
	    {                                                                                     
	        Logger.sys.println("getConfig error : " + exception.getMessage());              
	    }                                                                                     
	    return null;                                                                          
	}                                                                                         

/**
 * 결재 경로 관리 조회화면.
 * @param args
 * @return
 */
	
    public SepoaOut getMaintain(Map<String, String> header) { 
    	try{ 
            String rtn = et_getMaintain(header); 
            setValue(rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000"));  
        }catch(Exception e){ 
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
        } 
        return getSepoaOut(); 
    } 
 
    private String et_getMaintain(Map<String, String> header) throws Exception { 
        String rtn = ""; 
		ConnectionContext ctx =	getConnectionContext();  
		String id = info.getSession("USER_ID");
		//String cur_date_time = SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4);
		
		try	{  
			
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			//header.put("cur_date_time", cur_date_time);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			header.put("id", id);
			
			rtn	= sm.doSelect(header);  
  
			if(rtn == null)	throw new Exception("SQL Manager is	Null");  
		}catch(Exception e)	{  
			
		  throw	new	Exception("et_getItemList=========>"+e.getMessage());  
		} finally{  
		}  
		return rtn; 
    } 
    
    /* Line Insert를 하면 뜨는 팝업창에서 사용자 정보를 가져온다.(차기결재자 등록) */ 
    public SepoaOut getUserInfo(String[] args) { 
        try{ 
            String user_id = info.getSession("ID"); 
            String rtn = null; 
            rtn = et_getUserInfo(user_id,args); 
            setValue(rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */ 
        }catch(Exception e){ 
             
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            Logger.err.println(this, e.getMessage()); 
        } 
        return getSepoaOut(); 
    } 
 
    private String et_getUserInfo(String user_id,String[] args) throws Exception { 
        String result = null; 
        ConnectionContext ctx = getConnectionContext(); 
 
        String house_code = ""; 
        String company_code = ""; 
        String id = ""; 
        String name_loc = ""; 
        String dept = ""; 
 
        try { 
                house_code = args[0].trim(); 
                company_code = args[1].trim(); 
                id = args[2].trim(); 
                name_loc = args[3].trim(); 
                dept = args[4].trim(); 
                SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
                
                	wxp.addVar("house_code", house_code);
                	wxp.addVar("user_id", user_id);
                	wxp.addVar("name_loc", name_loc.length());
                	wxp.addVar("id", id.length());
                	wxp.addVar("name_loc", name_loc.length());
                	wxp.addVar("dept", dept.length());
                	
 
//                StringBuffer tSQL = new StringBuffer(); 
//                tSQL.append(" select company_code, user_name_loc, user_id, position, "); 
//                tSQL.append(" dept, name_loc, phone_no "); 
//                tSQL.append(" from user_popup_vw "); 
//                tSQL.append(" where house_code = '"+house_code+"' "); 
//                tSQL.append(" and user_id != '"+user_id+"' "); 
//                if(company_code.length() > 0) tSQL.append(" and company_code = '"+company_code+"' "); 
//                if ( id.length() > 0 ) tSQL.append(" and user_id = '"+id+"' "); 
//                if ( name_loc.length() > 0 ) tSQL.append(" and user_name_loc = '"+name_loc+"' "); 
//                if ( dept.length() > 0 ) tSQL.append(" and dept = '"+dept+"' "); 
 
                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                result = sm.doSelect((String[])null); 
                if(result == null) throw new Exception("SQLManager is null"); 
 
        }catch(Exception ex) { 
            throw new Exception("et_getUserInfo()=="+ ex.getMessage()); 
        } 
        return result; 
    } 
    
    /**
     * 차기결재자 등록 (Jtable에다 입력하구.. save 버튼을 누르면.. DB에 들어간다).
     * @param args
     * @return
     */
         public SepoaOut setInsert(String[][] args) { 
            int rtn = -1; 
            
            try { 
                rtn = et_setInsert(args); 
                if(rtn < 1)
    				throw new Exception("INSERT ICOMRULM ERROR");
    			Commit();
    			setStatus(1);
    			setMessage(msg.getMessage("0000"));

    		}catch(Exception e){
    			try 
                { 
                    Rollback(); 
                } 
                catch(Exception d) 
                { 
                    Logger.err.println(info.getSession("ID"),this,d.getMessage()); 
                } 
                setStatus(0); 
                setMessage(msg.getMessage("0003"));
    		} 
            return getSepoaOut(); 
        } 
     
        private int et_setInsert(String[][] args) throws Exception, DBOpenException { 
        	int rtn = -1; 
    		ConnectionContext ctx = getConnectionContext(); 
    		
    		String [][] this_args = new String[args.length][8];
    		int k = 0;
    		for ( int i = 0; i < args.length; i++ )
    		{
    			k = 0;
    			for ( int j = 0; j < args[i].length; j++ )
    			{
    				if ( j == 2 || j == 3) continue;
    				this_args[i][k++] = args[i][j];
    			}
    		} 
    		
    		for ( int i =0; i < args.length; i++) 
            { 
    			StringBuffer tSQL = new StringBuffer(); 
    			StringBuffer sql = new StringBuffer(); 
    			String house_code = args[i][2], user_id = args[i][3];	
    			SepoaFormater wf = null;
    			SepoaSQLManager wm = null;
    			String rtnSelect = null, sign_path_no = null;
    			
    			try 
    			{
    				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
    					wxp.addVar("house_code", house_code);
//    					wxp.addVar("user_id", user_id);
    					
//    				sql.append("   SELECT                                      														\n"); 
//    				sql.append("     ISNULL( MAX( CAST( ISNULL( NULLIF(SIGN_PATH_NO, ''), 0 ) AS INT ) ) + 1, 1) AS SIGN_PATH_NO  	\n"); 
//    				sql.append(" 	FROM ICOMRULM       												   	 				\n"); 
//    				sql.append(" 	WHERE HOUSE_CODE = '" + house_code + "'												  	\n"); 
//    				sql.append(" 	 AND  USER_ID = '" + user_id + "'   												  	\n"); 	
    				
    	            wm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() ); 
    	            rtnSelect = wm.doSelect((String[]) null ); 
    	 
    	            wf = new SepoaFormater( rtnSelect ); 
    	            if ( wf.getRowCount() > 0 )
    	            {
    		            sign_path_no = wf.getValue(0, 0); 
    	
    		           wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
    		            	wxp.addVar("sign_path_no", sign_path_no);
    		            
//    					tSQL.append(" INSERT INTO ICOMRULM  													\n");
//    					tSQL.append(" (  																		\n");
//    					tSQL.append(" 	HOUSE_CODE  															\n");
//    					tSQL.append(" , USER_ID  																\n");
//    					tSQL.append(" , SIGN_PATH_NO  															\n");
//    					tSQL.append(" , SIGN_PATH_NAME  														\n");
//    					tSQL.append(" , SIGN_REMARK  															\n");
//    					tSQL.append(" , ADD_DATE  																\n");
//    					tSQL.append(" , ADD_TIME  																\n");
//    					tSQL.append(" , CHANGE_DATE  															\n");
//    					tSQL.append(" , CHANGE_TIME  															\n");
//    					tSQL.append(" ) VALUES (   																\n");
//    					tSQL.append("   ?										  								\n");
//    					tSQL.append(" , ?  																		\n");
//    					tSQL.append(" , '" + sign_path_no + "'													\n");
//    					tSQL.append(" , ?  																		\n");
//    					tSQL.append(" , ?  																		\n");
//    					tSQL.append(" , ?  																		\n");
//    					tSQL.append(" , ?  																		\n");
//    					tSQL.append(" , ?  																		\n");
//    					tSQL.append(" , ?   																	\n");
//    					tSQL.append(" )   																		\n");
    					wm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 	 
    					String[] setType = {"S","S","S","S","S","S","S","S"}; 
    					
    					rtn = wm.doInsert(this_args, setType); 
    	            }
    			}
    			catch(Exception e) 
    			{ 
    				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
    				throw new Exception(e.getMessage()); 
    			}
            }
    		return rtn; 
    	}
// 
///* Line Insert를 하면 뜨는 팝업창에서 사용자 정보를 가져온다.(차기결재자 등록) */ 
//    public wise.srv.SepoaOut getUserInfo(String[] args) { 
//        try{ 
//            String user_id = info.getSession("ID"); 
//            String rtn = null; 
//            rtn = et_getUserInfo(user_id,args); 
//            setValue(rtn); 
//            setStatus(1); 
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */ 
//        }catch(Exception e){ 
//            System.out.println("Eception e = " + e.getMessage()); 
//            setStatus(0); 
//            setMessage(msg.getMessage("0001")); 
//            Logger.err.println(this, e.getMessage()); 
//        } 
//        return getSepoaOut(); 
//    } 
// 
//    private String et_getUserInfo(String user_id,String[] args) throws Exception { 
//        String result = null; 
//        ConnectionContext ctx = getConnectionContext(); 
// 
//        String house_code = ""; 
//        String company_code = ""; 
//        String id = ""; 
//        String name_loc = ""; 
//        String dept = ""; 
// 
//        try { 
//                house_code = args[0].trim(); 
//                company_code = args[1].trim(); 
//                id = args[2].trim(); 
//                name_loc = args[3].trim(); 
//                dept = args[4].trim(); 
// 
//                StringBuffer tSQL = new StringBuffer(); 
//                tSQL.append(" select company_code, user_name_loc, user_id, position, "); 
//                tSQL.append(" dept, name_loc, phone_no "); 
//                tSQL.append(" from user_popup_vw "); 
//                tSQL.append(" where house_code = '"+house_code+"' "); 
//                tSQL.append(" and user_id != '"+user_id+"' "); 
//                if(company_code.length() > 0) tSQL.append(" and company_code = '"+company_code+"' "); 
//                if ( id.length() > 0 ) tSQL.append(" and user_id = '"+id+"' "); 
//                if ( name_loc.length() > 0 ) tSQL.append(" and user_name_loc = '"+name_loc+"' "); 
//                if ( dept.length() > 0 ) tSQL.append(" and dept = '"+dept+"' "); 
// 
//                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString()); 
//                result = sm.doSelect(null); 
//                if(result == null) throw new Exception("SQLManager is null"); 
// 
//        }catch(Exception ex) { 
//            throw new Exception("et_getUserInfo()=="+ ex.getMessage()); 
//        } 
//        return result; 
//    } 
//  
///**
// * 차기결재자 등록 (Jtable에다 입력하구.. save 버튼을 누르면.. DB에 들어간다).
// * @param args
// * @return
// */
//     public SepoaOut setInsert(String[][] args) { 
//        int rtn = -1; 
//        
//        try { 
//            rtn = et_setInsert(args); 
//            if(rtn < 1)
//				throw new Exception("INSERT ICOMRULM ERROR");
//			Commit();
//			setStatus(1);
//			setMessage(msg.getMessage("0000"));
//
//		}catch(Exception e){
//			try 
//            { 
//                Rollback(); 
//            } 
//            catch(Exception d) 
//            { 
//                Logger.err.println(info.getSession("ID"),this,d.getMessage()); 
//            } 
//            setStatus(0); 
//            setMessage(msg.getMessage("0003"));
//		} 
//        return getSepoaOut(); 
//    } 
// 
//    private int et_setInsert(String[][] args) throws Exception, DBOpenException { 
//    	int rtn = -1; 
//		ConnectionContext ctx = getConnectionContext(); 
//		
//		String [][] this_args = new String[args.length][8];
//		int k = 0;
//		for ( int i = 0; i < args.length; i++ )
//		{
//			k = 0;
//			for ( int j = 0; j < args[i].length; j++ )
//			{
//				if ( j == 2 || j == 3) continue;
//				this_args[i][k++] = args[i][j];
//			}
//		} 
//		
//		for ( int i =0; i < args.length; i++) 
//        { 
//			StringBuffer tSQL = new StringBuffer(); 
//			StringBuffer sql = new StringBuffer(); 
//			String house_code = args[i][2], user_id = args[i][3];	
//			SepoaFormater wf = null;
//			SepoaSQLManager wm = null;
//			String rtnSelect = null, sign_path_no = null;
//			
//			try 
//			{
//				sql.append("   SELECT                                      														\n"); 
//				sql.append("     ISNULL( MAX( CAST( ISNULL( NULLIF(SIGN_PATH_NO, ''), 0 ) AS INT ) ) + 1, 1) AS SIGN_PATH_NO  	\n"); 
//				sql.append(" 	FROM ICOMRULM       												   	 				\n"); 
//				sql.append(" 	WHERE HOUSE_CODE = '" + house_code + "'												  	\n"); 
//				sql.append(" 	 AND  USER_ID = '" + user_id + "'   												  	\n"); 	
//				
//	            wm = new SepoaSQLManager( info.getSession("ID"), this, ctx, sql.toString() ); 
//	            rtnSelect = wm.doSelect( null ); 
//	 
//	            wf = new SepoaFormater( rtnSelect ); 
//	            if ( wf.getRowCount() > 0 )
//	            {
//		            sign_path_no = wf.getValue(0, 0); 
//	
//					tSQL.append(" INSERT INTO ICOMRULM  													\n");
//					tSQL.append(" (  																		\n");
//					tSQL.append(" 	HOUSE_CODE  															\n");
//					tSQL.append(" , USER_ID  																\n");
//					tSQL.append(" , SIGN_PATH_NO  															\n");
//					tSQL.append(" , SIGN_PATH_NAME  														\n");
//					tSQL.append(" , SIGN_REMARK  															\n");
//					tSQL.append(" , ADD_DATE  																\n");
//					tSQL.append(" , ADD_TIME  																\n");
//					tSQL.append(" , CHANGE_DATE  															\n");
//					tSQL.append(" , CHANGE_TIME  															\n");
//					tSQL.append(" ) VALUES (   																\n");
//					tSQL.append("   ?										  								\n");
//					tSQL.append(" , ?  																		\n");
//					tSQL.append(" , '" + sign_path_no + "'													\n");
//					tSQL.append(" , ?  																		\n");
//					tSQL.append(" , ?  																		\n");
//					tSQL.append(" , ?  																		\n");
//					tSQL.append(" , ?  																		\n");
//					tSQL.append(" , ?  																		\n");
//					tSQL.append(" , ?   																	\n");
//					tSQL.append(" )   																		\n");
//					wm = new SepoaSQLManager(info.getSession("ID"),this,ctx,tSQL.toString()); 	 
//					String[] setType = {"S","S","S","S","S","S","S","S"}; 
//					
//					rtn = wm.doInsert(this_args, setType); 
//	            }
//			}
//			catch(Exception e) 
//			{ 
//				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
//				throw new Exception(e.getMessage()); 
//			}
//        }
//		return rtn; 
//	}
// 
/**
 * 차기결재자 수정 (차기결재자 차수를 바꾸고 수정 버튼을 누른다).
 * @param args
 * @return
 */  
    public SepoaOut setUpdate(String[][] args) { 
        try { 
        	int rtn = et_setUpdate(args); 
        	if(rtn < 1)
				throw new Exception("UPDATE ICOMRULM ERROR");
			
			Commit();
			setStatus(1);
			setMessage(msg.getMessage("0000"));

		}catch(Exception e){
			try 
            { 
                Rollback(); 
            } 
            catch(Exception d) 
            { 
                Logger.err.println(info.getSession("ID"),this,d.getMessage()); 
            } 
            setStatus(0); 
            setMessage(msg.getMessage("0002"));
		}
        
        return getSepoaOut(); 
    } 
 
    private int et_setUpdate(String[][] args) throws Exception, DBOpenException { 
        int rtn = 0;
        ConnectionContext ctx = getConnectionContext();
        
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        
        
//        StringBuffer tSQL = new StringBuffer();
//        tSQL.append(" UPDATE ICOMRULM SET 		\n"); 
//        tSQL.append(" 	SIGN_PATH_NAME  = ? 	\n"); 
//        tSQL.append(" 	,SIGN_REMARK  = ? 		\n"); 
//        tSQL.append(" 	,CHANGE_DATE  = ? 		\n"); 
//        tSQL.append(" 	,CHANGE_TIME  = ? 		\n"); 
//        tSQL.append(" WHERE 					\n"); 
//        tSQL.append(" 	HOUSE_CODE = ? 			\n"); 
//        tSQL.append(" 	AND USER_ID = ? 		\n"); 
//        tSQL.append(" 	AND SIGN_PATH_NO = ? 	\n"); 
        
        try{
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[]   type = { "S","S","S","S","S","S","S"};

            rtn = sm.doUpdate(args,type);
        }catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
 
/**
 * 차기결재자 삭제. 
 * @param args
 * @return
 */ 
    public SepoaOut setDelete(String[][] args) { 
        try 
		{ 
			int rtn = et_setDelete(args); 
		 
			if(rtn < 1)
				throw new Exception("DELETE ICOMRULM ERROR");
				
			Commit();
			setStatus(1);
			setMessage(msg.getMessage("0000"));

		}catch(Exception e){
			try 
            { 
                Rollback(); 
            } 
            catch(Exception d) 
            { 
                Logger.err.println(info.getSession("ID"),this,d.getMessage()); 
            } 
            setStatus(0); 
            setMessage(msg.getMessage("0004"));
		}
        return getSepoaOut(); 
    } 
 
    private int et_setDelete(String[][] args) throws Exception, DBOpenException { 
    	int rtn = -1; 
		 
		ConnectionContext ctx = getConnectionContext(); 

//		StringBuffer tSQL = new StringBuffer(); 
		
		try {	 
			
			//ICOMRULP
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
//			tSQL = new StringBuffer();
//			tSQL.append(" DELETE FROM ICOMRULP 		\n"); 
//	        tSQL.append(" WHERE HOUSE_CODE = ? 		\n"); 
//	        tSQL.append(" 	AND USER_ID = ? 		\n"); 
//	        tSQL.append(" 	AND SIGN_PATH_NO = ? 	\n");
			
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] setType = {"S","S","S"};
			
			rtn = sm.doInsert(args, setType);  
			
			
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
						
//			tSQL.append(" DELETE FROM ICOMRULM 		\n"); 
//	        tSQL.append(" WHERE HOUSE_CODE = ? 		\n"); 
//	        tSQL.append(" 	AND USER_ID = ? 		\n"); 
//	        tSQL.append(" 	AND SIGN_PATH_NO = ? 	\n");
	        
			 sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 	 
			 rtn = sm.doInsert(args, setType);  

		}catch(Exception e) { 
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage()); 
		} 
		return rtn; 
    } 
 

    
/**
 * 상세 결재경로 조회(결재자 목록 조회).
 * @param args
 * @return
 */ 
    public SepoaOut getMaintainSignPath(Map<String, String> header) { 
        try{ 
            String rtn = et_getMaintainSignPath(header); 
            setValue(rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000"));  
        }catch(Exception e){ 
        	setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
        } 
        return getSepoaOut(); 
    }

    private String et_getMaintainSignPath(Map<String, String> header) throws Exception { 
        String rtn = null; 
        ConnectionContext ctx = getConnectionContext(); 
      
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
       
        try {	
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery()); 
            rtn = sm.doSelect(header); 
		}catch(Exception e) { 
            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
            throw new Exception(e.getMessage()); 
        } 
        return rtn; 
    } 
// 
///** 
// * 상세 결재경로 조회(결재자 목록 조회2) 
// */ 
//    public SepoaOut getMaintainSignPath2(String[] args) { 
//        try{ 
//            String rtn = et_getMaintainSignPath2(args); 
//            setValue(rtn); 
//            setStatus(1); 
//            setMessage(msg.getMessage("0000"));  
//        }catch(Exception e){ 
//        	setStatus(0); 
//            setMessage(msg.getMessage("0001")); 
//            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
//        } 
//        return getSepoaOut(); 
//    }
//    
//    private String et_getMaintainSignPath2(String[] args) throws Exception { 
//    	String rtn = null; 
//        ConnectionContext ctx = getConnectionContext(); 
//        StringBuffer tSQL = new StringBuffer(); 
//		
//        tSQL.append("   SELECT A.SIGN_PATH_SEQ,  B.USER_NAME_LOC, D.dept_NAME_LOC AS DEPT_NAME ,                                 \n"); 
//        tSQL.append("       CASE B.USER_TYPE                                                                                \n"); 
//        tSQL.append("           WHEN 'S' THEN " + "dbo"+  "."+ "GETICOMCODE2(B.HOUSE_CODE,'M106',B.POSITION)                           \n");
//        tSQL.append("           WHEN 'P' THEN " + "dbo"+  "."+ "GETICOMCODE2(B.HOUSE_CODE,'M106',B.POSITION)                           \n");
//        tSQL.append("           ELSE  " + "dbo"+  "."+ "GETICORCODE1(B.HOUSE_CODE,B.COMPANY_CODE,'C002',B.POSITION)                    \n");
//        tSQL.append("       END AS POSITION,                                                                                \n"); 
//        tSQL.append("       CASE B.USER_TYPE                                                                                \n"); 
//        tSQL.append("           WHEN 'S' THEN  " + "dbo"+  "."+ "GETICOMCODE2(B.HOUSE_CODE,'M107',B.MANAGER_POSITION)                  \n");
//        tSQL.append("           WHEN 'P' THEN  " + "dbo"+  "."+ "GETICOMCODE2(B.HOUSE_CODE,'M107',B.MANAGER_POSITION)                  \n");
//        tSQL.append("           ELSE  " + "dbo"+  "."+ "GETICORCODE1(B.HOUSE_CODE,B.COMPANY_CODE,'C001',B.MANAGER_POSITION)            \n");
//        tSQL.append("       END AS MANAGER_POSITION,                                                                        \n"); 
//        tSQL.append("                                                                                                       \n"); 
//        tSQL.append("       A.PROCEEDING_FLAG, A.SIGN_USER_ID,  A.SIGN_PATH_NO,  B.POSITION, B.MANAGER_POSITION             \n"); 
//        tSQL.append("       FROM ICOMRULP A, ICOMLUSR B ,ICOMOGDP D,                                                        \n"); 
//        tSQL.append(" (                                                                                                     \n"); 
//        tSQL.append("   SELECT HOUSE_CODE, MANAGER_POSITION FROM ICOMRLAM                                                   \n"); 
//        tSQL.append("   <OPT=F,S>WHERE HOUSE_CODE = ? </OPT>                                                               \n"); 
//        tSQL.append("   <OPT=F,S>AND COMPANY_CODE = ?  </OPT>                                                             \n"); 
//        tSQL.append("   <OPT=F,S> AND DOC_TYPE = ? </OPT>                                                                   \n"); 
//        tSQL.append("   AND AVAIL_PAY_AMT <= (SELECT AVAIL_PAY_AMT                                                          \n"); 
//        tSQL.append("                           FROM ICOMRLAM                                                               \n"); 
//        tSQL.append("                          <OPT=F,S>WHERE HOUSE_CODE = ?  </OPT>                                        \n"); 
//        tSQL.append("                            <OPT=F,S>AND COMPANY_CODE = ?  </OPT>                                    \n"); 
//        tSQL.append("                            <OPT=F,S>AND DOC_DETAIL_TYPE = ? </OPT>                               \n"); 
//        tSQL.append("                            <OPT=F,S>AND DOC_TYPE = ? </OPT>                                             \n"); 
//        tSQL.append("                            AND MANAGER_POSITION = (SELECT MANAGER_POSITION from (SELECT MANAGER_POSITION                      \n"); 
//        tSQL.append("                                                         FROM ICOMRLAM                                 \n"); 
//        tSQL.append("                                                        <OPT=F,S>WHERE HOUSE_CODE = ?  </OPT>          \n"); 
//        tSQL.append("                                                          <OPT=F,S>AND COMPANY_CODE = ?  </OPT>      \n"); 
//        tSQL.append("                                                          <OPT=F,S>AND DOC_TYPE = ? </OPT>              \n"); 
//        tSQL.append("                                                <OPT=F,S> AND AVAIL_PAY_AMT >= ? </OPT>                \n"); 
//        tSQL.append("                                                          <OPT=F,S>AND DOC_DETAIL_TYPE = ? </OPT> \n"); 
//        tSQL.append("                                                          AND SHIPPER_TYPE = 'D'                       \n"); 
//        tSQL.append("                                                        ORDER BY AVAIL_PAY_AMT) where rownum < 2 )                       \n"); 
//        tSQL.append("                         )                                                                             \n"); 
//        tSQL.append("   <OPT=F,S>AND DOC_DETAIL_TYPE = ? </OPT>                                                        \n"); 
//        tSQL.append("   AND SHIPPER_TYPE = 'D'                                                                              \n"); 
//        tSQL.append(" ) RLAM                                                                                                \n"); 
// 
//        tSQL.append(" WHERE A.HOUSE_CODE = B.HOUSE_CODE                                                                     \n"); 
//        tSQL.append(" AND A.SIGN_USER_ID = B.USER_ID                                                                        \n"); 
//        tSQL.append(" AND B.HOUSE_CODE(+) = D.HOUSE_CODE                                                                      \n"); 
//        tSQL.append(" AND B.COMPANY_CODE(+) = D.COMPANY_CODE                                                                  \n"); 
//        tSQL.append(" AND B.DEPT(+) = D.DEPT                                                                                  \n"); 
//        tSQL.append(" <OPT=F,S>AND A.HOUSE_CODE = ? </OPT>                                                                  \n"); 
//        tSQL.append(" <OPT=F,S>AND A.USER_ID = ? </OPT>                                                                        \n"); 
//        tSQL.append(" <OPT=S,S> AND A.SIGN_PATH_NO = ? </OPT>                                                               \n"); 
//        tSQL.append(" AND B.HOUSE_CODE = RLAM.HOUSE_CODE                                                                    \n"); 
//        tSQL.append(" AND B.MANAGER_POSITION = RLAM.MANAGER_POSITION                                                        \n"); 
//        tSQL.append(" ORDER BY to_number(A.SIGN_PATH_SEQ)                                                             \n"); 
// 
//        try {	
//    		SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,tSQL.toString()); 
//            rtn = sm.doSelect(args); 
//		}catch(Exception e) { 
//            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
//            throw new Exception(e.getMessage()); 
//        } 
//        return rtn; 
//    } 
// 
// 
// 
// 
// 
/**
 * 결재 경로(차기결재자 등록).
 * @param args
 * @return
 */ 
    public SepoaOut setInsertSignPath(String[][] args) { 
    	int rtn = -1; 
        
        try { 
            rtn = et_setInsertSignPath(args); 
            if(rtn < 1)
				throw new Exception("INSERT ICOMRULM ERROR");
			Commit();
			setStatus(1);
			setMessage( msg.getMessage("0000") );

		}catch(Exception e){
			try 
            { 
                Rollback(); 
            } 
            catch(Exception d) 
            { 
                Logger.err.println(info.getSession("ID"),this,d.getMessage()); 
            } 
            setStatus(0); 
            setMessage(msg.getMessage("0003"));
		}
        return getSepoaOut(); 
    } 
 
    private int et_setInsertSignPath(String[][] args) throws Exception { 
    	int rtn = -1; 
		ConnectionContext ctx = getConnectionContext(); 
		for ( int i =0; i < args.length; i++){ 
//            StringBuffer tSQL = new StringBuffer(); 
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			
 
/*            tSQL.append(" INSERT INTO ICOMRULP  						\n");
    		tSQL.append(" (  											\n");
    		tSQL.append(" 	HOUSE_CODE  								\n");
    		tSQL.append(" , USER_ID  									\n");
    		tSQL.append(" , SIGN_PATH_NO  								\n");
    		tSQL.append(" , SIGN_PATH_SEQ  								\n");
    		tSQL.append(" , SIGN_USER_ID  								\n");
    		tSQL.append(" , PROCEEDING_FLAG  							\n");
    		tSQL.append(" , ADD_DATE  									\n");
    		tSQL.append(" , ADD_TIME  									\n");
    		tSQL.append(" ) VALUES (   									\n");
    		tSQL.append("   ?  											\n");
    		tSQL.append(" , ?  											\n");
    		tSQL.append(" , ?  											\n");
            tSQL.append(" , (                                           \n") ; 
    		tSQL.append("     SELECT                                    \n") ; 
            tSQL.append("     	ISNULL(MAX(TO_NUMBER(ISNULL(SIGN_PATH_SEQ,0)))+1, 1) AS SIGN_PATH_SEQ  \n") ; 
            tSQL.append(" 	  FROM ICOMRULP                             \n") ; 
            tSQL.append(" 	  WHERE HOUSE_CODE = ?       				\n") ; 
            tSQL.append(" 	  	AND USER_ID = ?      					\n") ; 
            tSQL.append("   	AND SIGN_PATH_NO = ?                    \n") ; 
            tSQL.append("   )  											\n");
            tSQL.append(" , ?  											\n");
    		tSQL.append(" , ?  											\n");
    		tSQL.append(" , ?  											\n");
    		tSQL.append(" , ?  											\n");
    		tSQL.append(" )   											\n");
*/
//    		tSQL.append(" INSERT INTO ICOMRULP  						\n");
//    		tSQL.append(" (  											\n");
//    		tSQL.append(" 	HOUSE_CODE  								\n");
//    		tSQL.append(" , USER_ID  									\n");
//    		tSQL.append(" , SIGN_PATH_NO  								\n");
//    		tSQL.append(" , SIGN_PATH_SEQ  								\n");
//    		tSQL.append(" , SIGN_USER_ID  								\n");
//    		tSQL.append(" , PROCEEDING_FLAG  							\n");
//    		tSQL.append(" , ADD_DATE  									\n");
//    		tSQL.append(" , ADD_TIME  									\n");
//    		tSQL.append(" )    											\n");
//    		tSQL.append(" SELECT    									\n");
//    		tSQL.append("   ?  											\n");
//    		tSQL.append(" , ?  											\n");
//    		tSQL.append(" , ?  											\n");
//    		tSQL.append(" , (                                           \n") ; 
//    		tSQL.append("     SELECT                                    \n") ; 
//    		tSQL.append("     	ISNULL(MAX(SIGN_PATH_SEQ), 0) + 1 AS SIGN_PATH_SEQ  \n") ; 
//    		tSQL.append(" 	  	FROM ICOMRULP                             			\n") ; 
//    		tSQL.append(" 	  	WHERE HOUSE_CODE = ?       							\n") ; 
//    		tSQL.append(" 	  		AND USER_ID = ?      							\n") ; 
//    		tSQL.append("   		AND SIGN_PATH_NO = ?                    		\n") ; 
//    		tSQL.append("   )  											\n");
//    		tSQL.append(" , ?  											\n");
//    		tSQL.append(" , ?  											\n");
//    		tSQL.append(" , ?  											\n");
//    		tSQL.append(" , ?  											\n");
//    		tSQL.append("    											\n");
    		
        	try { 
    			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 	 
    			String[] setType = {"S","S","S","S","S","S","S","S","S"}; 
    				
    			rtn = sm.doInsert(args, setType); 
    		}catch(Exception e) { 
    			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
    			throw new Exception(e.getMessage()); 
    		}
        }
        return rtn; 
    } 
 
 
 
///***************************************************************************************************/ 
///************************************* 결재자 변경화면에서의 조회 **************************************************/ 
///***************************************************************************************************/ 
// 
///* 처음에 maintain 화면 뜨고 쿼리하면 데이타를 가져와서 보여준다.(차기결재자 등록) */ 
//    public wise.srv.SepoaOut DisplayUsedChangeUser(String[] args) { 
//        try{ 
// 
//            String rtn = null; 
//            rtn = et_DisplayUsedChangeUser(args); 
//            setValue(rtn); 
//            setStatus(1); 
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */ 
//        }catch(Exception e){ 
//            System.out.println("Eception e = " + e.getMessage()); 
//            setStatus(0); 
//            setMessage(msg.getMessage("0001")); 
//            Logger.err.println(this, e.getMessage()); 
//        } 
//        return getSepoaOut(); 
//    } 
// 
// 
//    private String et_DisplayUsedChangeUser(String[] args) throws Exception { 
//        String result = null; 
//        ConnectionContext ctx = getConnectionContext(); 
//        String user_id = info.getSession("ID"); 
//        String house_code = info.getSession("HOUSE_CODE"); 
// 
//        try { 
//                StringBuffer tSQL = new StringBuffer(); 
// 
//                tSQL.append(" select decode(a.shipper_type,'D','내자','O','외자',''),  \n"); 
//                tSQL.append(" geticomcode1(a.house_code,'M999',decode(instr(doc_type,'^'),'0',a.doc_type,substr(doc_type,1,instr(doc_type,'^')-1))), \n"); 
//                tSQL.append(" a.doc_no, decode(substr(doc_seq,8,2),'AD','계약금','JD','중도금','RD','잔금', \n"); 
//                tSQL.append(" '00','계획결재','01','결과결재',doc_seq),      \n"); 
//                tSQL.append(" a.ttl_amt,                                    \n"); 
//                tSQL.append(" b.user_name_loc,  a.add_date, a.sign_remark,  \n"); 
//                tSQL.append(" a.doc_seq,  a.doc_type,  a.company_code       \n"); 
// 
//                tSQL.append(" from icomsctm a , icomlusr b                  \n"); 
//                tSQL.append(" where a.house_code = '"+house_code+"'         \n"); 
//                tSQL.append(" and a.app_status = 'P'                        \n"); 
//                tSQL.append(" <OPT=S,S> and decode(instr(doc_type,'^'),'0',a.doc_type,substr(doc_type,1,instr(doc_type,'^')-1)) = ? </OPT> "); 
//                tSQL.append(" <OPT=S,S> and a.next_sign_user_id = ? </OPT>  \n"); 
//                tSQL.append(" <OPT=S,S> and a.doc_no = ?  </OPT>            \n"); 
//                tSQL.append(" <OPT=S,S> and a.add_date between ? </OPT>     \n"); 
//                tSQL.append(" <OPT=S,S> and ? </OPT>                        \n"); 
//                tSQL.append(" and a.house_code = b.house_code(+)            \n"); 
// 
//                tSQL.append(" and a.add_user_id = b.user_id(+)              \n"); 
// 
//                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString()); 
//                result = sm.doSelect(args); 
//                if(result == null) throw new Exception("SQLManager is null"); 
// 
//        }catch(Exception ex) { 
//            throw new Exception("et_getMaintain()=="+ ex.getMessage()); 
//        } 
//        return result; 
//    } 
// 
// 
// 
//    private String getnoSignPath(String house_code, String user_id, String sign_path_no)  throws Exception 
//    { 
//        String rtn = new String(); 
//        String[][] str = new String[1][1]; 
// 
//        try 
//        { 
//            ConnectionContext ctx = getConnectionContext(); 
// 
//            StringBuffer sql = new StringBuffer(); 
//            sql.append(" select                                                                         \n") ; 
//            sql.append("     isnull(max(convert(numeric,isnull(sign_path_seq,0)))+1, 1) as sign_path_seq  \n") ; 
//            sql.append(" from icomrulp                                                                  \n") ; 
//            sql.append(" where  house_code = '" + house_code + "' and  user_id = '" + user_id + "'      \n") ; 
//            sql.append("   and  sign_path_no = '" + sign_path_no + "'                                   \n") ; 
////## 2005.07.28.(신병곤) 이전소스 
////            sql.append(" select count(*)+1 "); 
////            sql.append(" from  icomrulp "); 
////            sql.append(" where  house_code = '"+house_code+"' and  user_id = '"+user_id+"' "); 
////            sql.append(" and  sign_path_no = '"+sign_path_no+"' "); 
// 
//            SepoaSQLManager sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, sql.toString() ); 
//            rtn = sm.doSelect( null ); 
// 
//            SepoaFormater wf = new SepoaFormater(rtn); 
//            str = wf.getValue(); 
// 
//            if(rtn == null) { 
//                throw new Exception("SQL Manager is Null"); 
//            } 
//        } 
//        catch(Exception e) { 
//            // 아예 데이타 하나도 없을때 
//            str[0][0] = "1"; 
//            Logger.debug.println(info.getSession("ID"),this,"11111rtn = 11111"+rtn); 
//        } 
//        finally {} 
// 
//        return str[0][0]; 
// 
//    }   //end of getpid 
// 
// 
/**
 * 결재자 목록 수정(차기결재자).
 * @param args
 * @return
 */ 
    public SepoaOut setUpdateSignPath(String[][] args) { 
    	try { 
        	int rtn = et_setUpdateSignPath(args); 
        	if(rtn < 1)
				throw new Exception("UPDATE ICOMRULM ERROR");
			
			Commit();
			setStatus(1);
			setMessage(msg.getMessage("0000"));

		}catch(Exception e){
			try 
            { 
                Rollback(); 
            } 
            catch(Exception d) 
            { 
                Logger.err.println(info.getSession("ID"),this,d.getMessage()); 
            } 
            setStatus(0); 
            setMessage(msg.getMessage("0002"));
		}
    	return getSepoaOut(); 
    }
    
    private int et_setUpdateSignPath(String[][] args) throws Exception, DBOpenException { 
    	int rtn = 0;
        ConnectionContext ctx = getConnectionContext();
//        StringBuffer tSQL = new StringBuffer();
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//        tSQL.append(" UPDATE ICOMRULP SET 		\n"); 
//        tSQL.append(" 	  SIGN_USER_ID  = ? 	\n"); 
//        tSQL.append(" 	, PROCEEDING_FLAG  = ? 	\n"); 
//        tSQL.append(" WHERE 					\n"); 
//        tSQL.append(" 	HOUSE_CODE = ? 			\n"); 
//        tSQL.append(" 	AND USER_ID = ? 		\n"); 
//        tSQL.append(" 	AND SIGN_PATH_NO = ? 	\n"); 
//        tSQL.append(" 	AND SIGN_PATH_SEQ = ? 	\n"); 
        
        try{
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[]   type = { "S","S","S","S","S","S"};

            rtn = sm.doUpdate(args,type);
        }catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn; 
    } 
 
/**
 * 결재자 목록 삭제(차기 결재자).
 * @param args
 * @return
 */ 
    public SepoaOut setDeleteSignPath(String[][] args) { 
    	try 
		{ 
			int rtn = et_setDeleteSignPath(args); 
		 
			if(rtn < 1)
				throw new Exception("DELETE ICOMRULM ERROR");
				
			Commit();
			setStatus(1);
			setMessage(msg.getMessage("0000"));

		}catch(Exception e){
			try 
            { 
                Rollback(); 
            } 
            catch(Exception d) 
            { 
                Logger.err.println(info.getSession("ID"),this,d.getMessage()); 
            } 
            setStatus(0); 
            setMessage(msg.getMessage("0004"));
		}
        return getSepoaOut(); 
    } 
 
    private int et_setDeleteSignPath(String[][] args) throws Exception, DBOpenException { 
    	int rtn = -1; 
		 
//		StringBuffer tSQL = new StringBuffer(); 
		ConnectionContext ctx = getConnectionContext(); 
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
//		tSQL.append(" DELETE FROM ICOMRULP 		\n"); 
//        tSQL.append(" WHERE HOUSE_CODE = ? 		\n"); 
//        tSQL.append(" 	AND USER_ID = ? 		\n"); 
//        tSQL.append(" 	AND SIGN_PATH_NO = ? 	\n"); 
//        tSQL.append(" 	AND SIGN_PATH_SEQ = ? 	\n"); 
        try {	 
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 	 
			String[] setType = {"S","S","S","S"}; 
			rtn = sm.doInsert(args, setType);
			Commit();
			Logger.debug.println("rtn ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ : " + rtn);
			if(rtn!=1){
			String[] sign_path_seq = getsign_path_seq(args[0][0],args[0][1], args[0][2]); 
            for ( int i =0; i < sign_path_seq.length; i++) 
            { 
//                StringBuffer tSQL2 = new StringBuffer(); 
 
            	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
		        	wxp.addVar("i",(i+1));	
		        	wxp.addVar("args0",args[0][0]);
	        		wxp.addVar("args1",args[0][1]);
            		wxp.addVar("args2",args[0][2]);
            		wxp.addVar("sign_path_seq", sign_path_seq[i]);
//                tSQL2.append(" UPDATE ICOMRULP SET 							\n"); 
//                tSQL2.append(" 		SIGN_PATH_SEQ = '"+(i+1)+"'  			\n"); 
//                tSQL2.append(" WHERE  										\n"); 
//                tSQL2.append(" 		HOUSE_CODE = '"+args[0][0]+"' 			\n"); 
//                tSQL2.append(" 	AND USER_ID = '"+args[0][1]+"'  			\n"); 
//                tSQL2.append(" 	AND SIGN_PATH_NO = '"+args[0][2]+"'   		\n"); 
//                tSQL2.append(" 	AND SIGN_PATH_SEQ = '"+sign_path_seq[i]+"' 	\n"); 
                
                SepoaSQLManager sm2 = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 	 
    			
                sm2.doUpdate((String[][])null,(String[])null); 
 
            }
		 

            Commit();
		}// for ----- end 
		}catch(Exception e) { 
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage()); 
		} 
		return rtn; 
		
    } 


/**
 * call by et_setDeleteSignPath()  sign_path_seq값을 구한다.
 * @param house_code
 * @param user_id
 * @param sign_path_no
 * @return
 * @throws Exception
 */    
    private String[] getsign_path_seq(String house_code, String user_id, String sign_path_no)  throws Exception 
    { 
        String rtn = ""; 
        String[][] str = null; 
        String[] result = null; 
        ConnectionContext ctx = getConnectionContext(); 
        try 
        { 
        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        		wxp.addVar("house_code", house_code);
        		wxp.addVar("user_id", user_id);
        		wxp.addVar("sign_path_no", sign_path_no);
        		
//            StringBuffer sql = new StringBuffer(); 
//            sql.append(" SELECT  									\n"); 
//            sql.append(" 	SIGN_PATH_SEQ 							\n"); 
//            sql.append(" FROM ICOMRULP 								\n"); 
//            sql.append(" WHERE 										\n"); 
//            sql.append(" 	HOUSE_CODE = '"+house_code+"'  			\n"); 
//            sql.append(" 	AND USER_ID = '"+user_id+"' 			\n"); 
//            sql.append(" 	AND SIGN_PATH_NO = '"+sign_path_no+"' 	\n"); 
//            sql.append(" ORDER BY SIGN_PATH_SEQ 					\n"); 
            
            SepoaSQLManager sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery()); 
            rtn = sm.doSelect((String[]) null ); 
 
            SepoaFormater wf = new SepoaFormater(rtn); 
 
            str = new String[wf.getRowCount()][1]; 
            str = wf.getValue(); 
 
            result = new String[wf.getRowCount()]; 
 
            for (int i =0; i < str.length; i++){ 
                result[i] = str[i][0]; 
            } 
            if(rtn == null)  
                throw new Exception("SQL Manager is Null"); 
 
        }catch(Exception e) { 
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage()); 
		}return result; 
 
    }   
 

/**
 * 수동결재인지 자동결재인지 여부를 체크해준다 (회사단위 결재정의).
 * @param args
 * @return
 */

    public SepoaOut CheckSign_Type (String[] args){ 
        try{ 
        	String rtn = et_CheckSign_Type(args); 
            setValue(rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000"));  
        }catch(Exception e){ 
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
        } 
        return getSepoaOut(); 
    }
    
    private String et_CheckSign_Type(String[] args) throws Exception { 
    	String rtn = null; 
        ConnectionContext ctx = getConnectionContext(); 
        Map<String, String> param = new HashMap<String, String>();
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//        tSQL.append(" SELECT SIGN_TYPE                      \n "); 
//        tSQL.append(" FROM ICOMRLCM                         \n "); 
//        tSQL.append(" WHERE STATUS != 'D'                   \n "); 
//        tSQL.append(" <OPT=F,S> AND HOUSE_CODE = ? </OPT>   \n "); 
//        tSQL.append(" <OPT=F,S> AND COMPANY_CODE = ? </OPT> \n "); 
//        tSQL.append(" <OPT=F,S> AND DOC_TYPE = ? </OPT>     \n "); 
        
        try{ 
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
            param.put("HOUSE_CODE",   args[0]);
            param.put("COMPANY_CODE", args[1]);
            param.put("DOC_TYPE",     args[2]);
            rtn = sm.doSelect(param); 
        }catch(Exception e) { 
        	
            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
            throw new Exception(e.getMessage()); 
        } 
        return rtn; 
    } 
 
    // 전결규정관리 조회 //
    public SepoaOut getDecision(String house_code, String doc_type, String doc_kind, String dept)
    {
    	try {
    		String rtn = et_getDecision(house_code, doc_type, doc_kind, dept);
    		setValue(rtn);
    		setStatus(1);
    		setMessage(this.msg.getMessage("0000"));
    	} catch (Exception e) {
    		setStatus(0);
    		setMessage(this.msg.getMessage("0001"));
    		Logger.err.println(this.info.getSession("ID"), this, e.getMessage());
    	}
    	return getSepoaOut();
    }

    private String et_getDecision(String house_code, String doc_type, String doc_kind, String dept) throws Exception {
    	String rtn = null;
    	ConnectionContext ctx = getConnectionContext();
    	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    		wxp.addVar("house_code", house_code);
    		wxp.addVar("doc_type", doc_type);
    		wxp.addVar("doc_kind", doc_kind);
    		wxp.addVar("dept", dept);
    		
//    	StringBuffer tSQL = new StringBuffer();
//
//    	tSQL.append(" SELECT B.DOC_TYPE, B.DOC_KIND, B.DOC_KIND_NAME AS DOC_KIND_NAME_HD,\n");
//    	tSQL.append(" B.DOC_KIND_NAME, B.DEPT,\n");
//    	tSQL.append(" (CASE\n");
//    	tSQL.append("     WHEN A.USER_TYPE = 'S'\n");
//    	tSQL.append("        THEN DBO.GETICOMCODE2(B.HOUSE_CODE, 'M105', B.DEPT)\n");
//    	tSQL.append("     ELSE DBO.GETDEPTNAMELOC(B.HOUSE_CODE, B.COMPANY_CODE, B.DEPT)\n");
//    	tSQL.append("  END\n");
//    	tSQL.append(" ) AS DEPT_NAME, B.APP_TYPE, B.APP_TYPE_NAME, B.SIGN_PATH_SEQ,\n");
//    	tSQL.append(" B.SIGN_USER_ID, A.USER_NAME_LOC AS SIGN_USER_NAME,\n");
//    	tSQL.append(" dbo.GETICOMCODE2(B.HOUSE_CODE,'M106',A.POSITION) AS SIGN_USER_POS,\n");
//    	tSQL.append(" B.PROCEEDING_FLAG, B.SIGN_REMARK\n");
//    	tSQL.append(" FROM ICOMLUSR A, ICOMSCAL B\n");
//    	tSQL.append(" WHERE B.HOUSE_CODE = '" + house_code + "'\n");
//    	tSQL.append(" AND A.HOUSE_CODE = B.HOUSE_CODE\n");
//    	tSQL.append(" AND A.COMPANY_CODE = B.COMPANY_CODE\n");
//    	tSQL.append(" AND A.USER_ID = B.SIGN_USER_ID\n");
//    	if (!(doc_type.equals("")))
//    		tSQL.append(" AND B.DOC_TYPE = '" + doc_type + "'\n");
//    	if (!(doc_kind.equals("")))
//    		tSQL.append(" AND B.DOC_KIND = '" + doc_kind + "'\n");
//    	if (!(dept.equals("")))
//    		tSQL.append(" AND B.DEPT = '" + dept + "'\n");
//    	tSQL.append(" AND B.STATUS != 'D'\n");
    	try
    	{
    		SepoaSQLManager sm = new SepoaSQLManager(this.info.getSession("ID"), this, ctx, wxp.getQuery());
    		rtn = sm.doSelect((String[])null);
    	} catch (Exception e) {
    		Logger.err.println(this.info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	return rtn;
    }


    
    
    
    /******************전결규정 관리 ***************/
    public SepoaOut insertDecision(String[][] args) {
        int rtn = -1;
        try
        {
          rtn = et_insertDecision(args);
          if (rtn < 1)
            throw new Exception("INSERT ICOMSCAL ERROR");
          Commit();
          setStatus(1);
          setMessage(this.msg.getMessage("0000"));
        }
        catch (Exception e)
        {
          try {
            Rollback();
          }
          catch (Exception d)
          {
            Logger.err.println(this.info.getSession("ID"), this, d.getMessage());
          }
          setStatus(0);
          setMessage(this.msg.getMessage("0003"));
        }
        return getSepoaOut();
      }

      private int et_insertDecision(String[][] args) throws Exception, DBOpenException {
        int result = -1;
        ConnectionContext ctx = getConnectionContext();
        try
        {
        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	
//          StringBuffer tSQL = new StringBuffer();
//          tSQL.append(" INSERT INTO ICOMSCAL (");
//          tSQL.append(" HOUSE_CODE            ");
//          tSQL.append(" , COMPANY_CODE        ");
//          tSQL.append(" , DOC_TYPE            ");
//          tSQL.append(" , DOC_KIND");
//          tSQL.append(" , DOC_KIND_NAME       ");
//          tSQL.append(" , DEPT       ");
//          tSQL.append(" , APP_TYPE     ");
//          tSQL.append(" , APP_TYPE_NAME    ");
//          tSQL.append(" , SIGN_PATH_SEQ    ");
//          tSQL.append(" , SIGN_USER_ID     ");
//          tSQL.append(" , PROCEEDING_FLAG ");
//          tSQL.append(" , STATUS         ");
//          tSQL.append(" , SIGN_REMARK )");
//          tSQL.append(" values( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, '', ?) ");

          SepoaSQLManager sm = new SepoaSQLManager(this.info.getSession("ID"), this, ctx, wxp.getQuery());
          String[] settype = { "S", "S", "S", "S", "S", "S", "S", "S", "N", "S", "S", "S" };
          result = sm.doInsert(args, settype);
          Commit();
        } catch (Exception e) {
          Rollback();
          throw new Exception("et_setInsert: " + e.getMessage());
        }
        return result;
      }
      
      public SepoaOut updateDecision(String[][] args) {
    	  try {
    		  int rtn = et_updateDecision(args);
    		  if (rtn < 1) {
    			  throw new Exception("UPDATE ICOMSCAL ERROR");
    		  }
    		  Commit();
    		  setStatus(1);
    		  setMessage(this.msg.getMessage("0000"));
    	  }
    	  catch (Exception e)
    	  {
    		  try {
    			  Rollback();
    		  }
    		  catch (Exception d)
    		  {
    			  Logger.err.println(this.info.getSession("ID"), this, d.getMessage());
    		  }
    		  setStatus(0);
    		  setMessage(this.msg.getMessage("0002"));
    	  }
    	  return getSepoaOut();
      }

      private int et_updateDecision(String[][] args) throws Exception, DBOpenException {
    	  int rtn = 0;
    	  ConnectionContext ctx = getConnectionContext();
    	  SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    	  	
//    	  StringBuffer tSQL = new StringBuffer();
//
//    	  tSQL.append(" UPDATE ICOMSCAL SET \n");
//    	  tSQL.append("   SIGN_USER_ID  = ? \n");
//    	  tSQL.append(" , PROCEEDING_FLAG  = ? \n");
//    	  tSQL.append(" , SIGN_REMARK  = ?\n");
//    	  tSQL.append(" WHERE \n");
//    	  tSQL.append(" HOUSE_CODE = ? \n");
//    	  tSQL.append(" AND COMPANY_CODE = ?\n");
//    	  tSQL.append(" AND DOC_TYPE = ? \n");
//    	  tSQL.append(" AND DOC_KIND = ? \n");
//    	  tSQL.append(" AND DEPT = ?\n");
//    	  tSQL.append(" AND APP_TYPE = ?\n");
//    	  tSQL.append(" AND SIGN_PATH_SEQ = ? \n");
    	  try
    	  {
    		  SepoaSQLManager sm = new SepoaSQLManager(this.info.getSession("ID"), this, ctx, wxp.getQuery());
    		  String[] type = { "S", "S", "S", "S", "S", "S", "S", "S", "S", "N" };

    		  rtn = sm.doUpdate(args, type);
    	  } catch (Exception e) {
    		  Logger.err.println(this.info.getSession("ID"), this, e.getMessage());
    		  throw new Exception(e.getMessage());
    	  }
    	  return rtn;
      }

      public SepoaOut deleteDecision(String[][] args) {
    	  try {
    		  int rtn = et_deleteDecision(args);
    		  if (rtn < 1) {
    			  throw new Exception("DELETE ICOMSCAL ERROR");
    		  }
    		  Commit();
    		  setStatus(1);
    		  setMessage(this.msg.getMessage("0000"));
    	  }
    	  catch (Exception e)
    	  {
    		  try {
    			  Rollback();
    		  }
    		  catch (Exception d)
    		  {
    			  Logger.err.println(this.info.getSession("ID"), this, d.getMessage());
    		  }
    		  setStatus(0);
    		  setMessage(this.msg.getMessage("0002"));
    	  }
    	  return getSepoaOut();
      }

      private int et_deleteDecision(String[][] args) throws Exception, DBOpenException {
    	  int rtn = 0;
    	  ConnectionContext ctx = getConnectionContext();
    	  SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    	  
    	  
//    	  StringBuffer tSQL = new StringBuffer();
//
//    	  tSQL.append(" UPDATE ICOMSCAL SET STATUS  = 'D' \n");
//    	  tSQL.append(" WHERE\n");
//    	  tSQL.append(" HOUSE_CODE = ? \n");
//    	  tSQL.append(" AND COMPANY_CODE = ?\n");
//    	  tSQL.append(" AND DOC_TYPE = ?\n");
//    	  tSQL.append(" AND DOC_KIND = ?\n");
//    	  tSQL.append(" AND DEPT = ?\n");
//    	  tSQL.append(" AND APP_TYPE = ?\n");
//    	  tSQL.append(" AND SIGN_PATH_SEQ = ?\n");
    	  try
    	  {
    		  SepoaSQLManager sm = new SepoaSQLManager(this.info.getSession("ID"), this, ctx, wxp.getQuery());
    		  String[] type = { "S", "S", "S", "S", "S", "S", "N" };

    		  rtn = sm.doUpdate(args, type);
    	  } catch (Exception e) {
    		  Logger.err.println(this.info.getSession("ID"), this, e.getMessage());
    		  throw new Exception(e.getMessage());
    	  }
    	  return rtn;
      }
}
