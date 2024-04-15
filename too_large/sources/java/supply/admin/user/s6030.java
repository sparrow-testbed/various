package supply.admin.user; 

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.DBOpenException;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.Base64;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
 
 
public class s6030 extends SepoaService 
{ 
 
    String house_code; 
    //String company_code ; 
    //String id; 
    //String depart; 
    //String name_loc; 
    //String name_eng; 
    String language; 
 
 
    public s6030(String opt,SepoaInfo info) throws SepoaServiceException 
    { 
        super(opt,info); 
        setVersion("1.0.0");  
 
        this.house_code        = info.getSession("HOUSE_CODE"); 
        //this.company_code     = info.getSession("COMPANY_CODE"); 
        //this.id               = info.getSession("ID"); 
        //this.depart           = info.getSession("DEPARTMENT"); 
        //this.name_loc         = info.getSession("NAME_LOC");  
        //this.name_eng         = info.getSession("NAME_ENG"); 
        this.language           = info.getSession("LANGUAGE"); 
 
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
 
    Message msg = new Message(info, "FW"); 
 

    /** 중복체크 
     *  이부분은 Session이 없는 바깥쪽도 건드린다. 
     회사정보관리 > 사용자관리 > 사용자등록 - 중복확인 버튼 (N13)*/ 
    public SepoaOut getDuplicate(String[] args){ 
        try 
        { 
 
            String rtn = null; 
            // Isvalue(); .... 
            rtn = Check_Duplicate(args, info.getSession("ID")); 
            //Logger.debug.println("JHYOON",this,"duplicate-result= ===>"+rtn); 
            setValue(rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000")); 
        }catch(Exception e) 
        { 
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            //Logger.err.println("JHYOON",this,"Exception e =" + e.getMessage()); 
        } 
          return getSepoaOut(); 
    } 
 
 
    private String Check_Duplicate(String[] args, String user_id) 
    throws Exception 
    { 
        String rtn = null; 
        ConnectionContext ctx = getConnectionContext(); 
        try { 
        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	
//        	StringBuffer tSQL = new StringBuffer(); 
//            tSQL.append( " select "); 
//            tSQL.append( " count(*) as COUNT "); 
//            tSQL.append( " from icomlusr "); 
//            tSQL.append( " <OPT=F,S> where house_code = ? </OPT> "); 
//            tSQL.append( " <OPT=F,S> and user_id = ? </OPT> "); 

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
            rtn = sm.doSelect(args); 
            if(rtn == null) throw new Exception("SQL Manager is Null"); 
            }catch(Exception e) { 
                throw new Exception("Check_Duplicate:"+e.getMessage()); 
            } finally{ 
 
        } 
        return rtn; 
    }
    
    /** 중복체크 
     *  이부분은 Session이 없는 바깥쪽도 건드린다. 
     회사정보관리 > 사용자관리 > 사용자등록 - 중복확인 버튼 (N13)*/ 
    public SepoaOut getDuplicate_ict(String[] args){ 
        try 
        { 
 
            String rtn = null; 
            // Isvalue(); .... 
            rtn = Check_Duplicate_ict(args, info.getSession("ID")); 
            //Logger.debug.println("JHYOON",this,"duplicate-result= ===>"+rtn); 
            setValue(rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000")); 
        }catch(Exception e) 
        { 
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            //Logger.err.println("JHYOON",this,"Exception e =" + e.getMessage()); 
        } 
          return getSepoaOut(); 
    }
    
    private String Check_Duplicate_ict(String[] args, String user_id) 
    throws Exception 
    { 
        String rtn = null; 
        ConnectionContext ctx = getConnectionContext(); 
        try { 
        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	
//    	        	StringBuffer tSQL = new StringBuffer(); 
//    	            tSQL.append( " select "); 
//    	            tSQL.append( " count(*) as COUNT "); 
//    	            tSQL.append( " from icomlusr "); 
//    	            tSQL.append( " <OPT=F,S> where house_code = ? </OPT> "); 
//    	            tSQL.append( " <OPT=F,S> and user_id = ? </OPT> "); 

   		SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
           rtn = sm.doSelect(args); 
           if(rtn == null) throw new Exception("SQL Manager is Null"); 
           }catch(Exception e) { 
               throw new Exception("Check_Duplicate_ict:"+e.getMessage()); 
           } finally{ 
   
       } 
       return rtn; 
   }
    
    
    
    
    /* Method Name : setInsert
    작업내용:  Seller > Admin > 사용자관리 > 사용자등록 
    기타 : '이부분은 바같족에서도 불리기에 Session정보가 없을 수도 있습니다' 가 아니기 때문에 session을 다 받았습니다. 
    사용자등록 - 등록 버튼 (N13) 2010.03.11 xml쿼리작업 (박규현)
    */ 
 
    public SepoaOut setInsert(String[] args, String[] args2){ 
 
        try 
        { 
            String[][] str = new String[1][]; 
            str[0] = args; 
            String[][] str2 = new String[1][]; 
            str2[0] = args2; 
            
            int rtn = et_setInsert(str, str2); 
            setValue("Insert Row=" + rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000")); 
        }catch(Exception e) 
        { 
            Logger.err.println("Exception e =" + e.getMessage()); 
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            Logger.err.println(this,e.getMessage()); 
            //log err 
        } 
        return getSepoaOut(); 
    } 

//   사용자등록 - 등록 버튼 (N13) 2010.03.11 xml쿼리작업 (박규현)    
    private int et_setInsert(String[][] str , String[][] str2) 
                             throws Exception, DBOpenException { 
        int rtn = -1; 
        ConnectionContext ctx = getConnectionContext(); 
 
//        String house_code   = info.getSession("HOUSE_CODE"); 
//        String companyCode  = info.getSession("COMPANY_CODE"); 
//        String userId       = info.getSession("ID"); 
//        String dept         = info.getSession("DEPARTMENT"); 
//        String nameLoc      = info.getSession("NAME_LOC"); 
//        String nameEng      = info.getSession("NAME_ENG"); 
//        String language     = info.getSession("LANGUAGE"); 
//        String status       = "C"; 
//        String add_date     = SepoaDate.getShortDateString(); 
//        String add_time     = SepoaDate.getShortTimeString(); 
 
        try { 
		
		 
		SepoaSQLManager sm = null;
		
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_01");
		wxp.addVar("house_code", house_code);
		wxp.addVar("userId", info.getSession("ID"));
		wxp.addVar("status", "C");
		wxp.addVar("add_date", SepoaDate.getShortDateString());
		wxp.addVar("add_time",SepoaDate.getShortTimeString());
		wxp.addVar("str_0_4",str[0][4]);
		
//		Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>>>> ICOMLUSR");
//		StringBuffer tSQL = new StringBuffer();
//		tSQL.append(" INSERT INTO ICOMLUSR                           \n");
//		tSQL.append(" (                                              \n");
//		tSQL.append("   HOUSE_CODE                                   \n");		
//		tSQL.append(" , USER_ID                                      \n");      
//		tSQL.append(" , PASSWORD                                     \n");      
//		tSQL.append(" , USER_NAME_LOC                                \n");    
//		tSQL.append(" , USER_NAME_ENG                                \n");    
//		
//		tSQL.append(" , COMPANY_CODE                                 \n");    
//		tSQL.append(" , DEPT                                         \n");     
//		tSQL.append(" , RESIDENT_NO                                  \n");    
//		tSQL.append(" , EMPLOYEE_NO                                  \n");    
//		tSQL.append(" , EMAIL                                        \n");    
//		
//		tSQL.append(" , POSITION                                     \n");    
//		tSQL.append(" , LANGUAGE                                     \n");    
//		tSQL.append(" , TIME_ZONE                                    \n");    
//		tSQL.append(" , COUNTRY                                      \n");    
//		tSQL.append(" , CITY_CODE                                    \n");    
//		
//		tSQL.append(" , PR_LOCATION                                  \n");    
//		tSQL.append(" , MANAGER_POSITION                             \n");      
//		tSQL.append(" , USER_TYPE                                    \n");    
//		tSQL.append(" , WORK_TYPE                                    \n");    
//		tSQL.append(" , STATUS                                       \n");    
//		
//		tSQL.append(" , SIGN_STATUS                                  \n");    
//		tSQL.append(" , ADD_DATE                                     \n");    
//		tSQL.append(" , ADD_TIME                                     \n");    
//		tSQL.append(" , ADD_USER_ID                                  \n");    
//		tSQL.append(" , CHANGE_USER_ID                               \n");    
//		
//		tSQL.append(" , MENU_PROFILE_CODE             			\n"); 
//		tSQL.append(" ) VALUES (                            	\n");           
//		tSQL.append("   '"+houseCode+"'                  		\n");             
//		tSQL.append(" , ?                                   	\n");              
//		tSQL.append(" , ?	                         	    	\n");           
//		tSQL.append(" , ?                                   	\n");      
//		tSQL.append(" , ?                                   	\n");      
//		                                                    	         	
//		tSQL.append(" , ?                                   	\n");
//		tSQL.append(" , ?                                   	\n");
//		tSQL.append(" , ?                                   	\n");
//		tSQL.append(" , ?                                   	\n");
//		tSQL.append(" , ?                                   	\n");
//		                                                    	         	
//		tSQL.append(" , ?                                   	\n");
//		tSQL.append(" , ?                                   	\n");
//		tSQL.append(" , ?                                   	\n");
//		tSQL.append(" , ?                                   	\n");
//		tSQL.append(" , ?                                   	\n");
//		                                                    	         	
//		tSQL.append(" , ?                                   	\n");
//		tSQL.append(" , ?                                   	\n");
//		tSQL.append(" , ?                                   	\n");
//		tSQL.append(" , ?                                   	\n");
//		tSQL.append(" , '"+status+"'                        	\n");
//		
//		tSQL.append(" , 'R'                                     \n");
//		tSQL.append(" , '"+add_date+"'                          \n");
//		tSQL.append(" , '"+add_time+"'                          \n");
//		tSQL.append(" , '"+userId+"'                            \n");
//		tSQL.append(" , '"+userId+"'                            \n");
//		
//		tSQL.append(" , dbo.GET_MENU_PROFILE_NM('"+houseCode+"','"+str[0][4]+"') \n");
//		tSQL.append(" )                                         			     \n");
		
		sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
		
		//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
		String[] setType = {	"S","S","S","S","S",
		                        "S","S","S","S","S",
		                        "S","S","S","S","S",
		                        "S","S","S" 		};
		
		rtn = sm.doInsert(str, setType);
		
		SepoaXmlParser wxp2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_02");
		wxp2.addVar("house_code", info.getSession("HOUSE_CODE"));		
		
		if(rtn < 1) throw new Exception("ICOMLUSR INSERT ERROR");
		
//		Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>>>> ICOMADDR");
//		StringBuffer tSQL = new StringBuffer();
//		tSQL.append(" INSERT INTO ICOMADDR                \n");
//		tSQL.append(" (                                   \n");
//		tSQL.append("   HOUSE_CODE                        \n");
//		tSQL.append(" , CODE_NO                           \n");
//		tSQL.append(" , CODE_TYPE                         \n");
//		tSQL.append(" , ZIP_CODE                          \n");					//ZIP_CODE,
//		tSQL.append(" , PHONE_NO1                         \n");               //PHONE_NO,
//		tSQL.append(" , FAX_NO                            \n");               //FAX_NO,
//		tSQL.append(" , HOMEPAGE                          \n");
//		tSQL.append(" , ADDRESS_LOC                       \n");				//ADDRESS_LOC,
//		tSQL.append(" , ADDRESS_ENG                       \n");				//ADDRESS_ENG,
//		tSQL.append(" , CEO_NAME_LOC                      \n");				 
//		tSQL.append(" , CEO_NAME_ENG                      \n");
//		tSQL.append(" , EMAIL                             \n");
//		tSQL.append(" , ZIP_BOX_NO                        \n");
//		tSQL.append(" , PHONE_NO2                         \n");					//MOBILE_NO,
//		tSQL.append(" ) VALUES (                          \n");
//		tSQL.append("   '"+house_code+"'               	  \n");
//		tSQL.append(" , ?   --user_id                     \n");
//		tSQL.append(" , ?   --code_type                   \n");
//		tSQL.append(" , ?   --ZIP_CODE                    \n");
//		tSQL.append(" , ?   --PHONE_NO1                   \n");
//		tSQL.append(" , ?   --FAX_NO                      \n");
//		tSQL.append(" , ?   --HOMEPAGE                    \n");
//		tSQL.append(" , ?   --ADDRESS_LOC                 \n");
//		tSQL.append(" , ?   --ADDRESS_ENG                 \n");
//		tSQL.append(" , ?   --CEO_NAME_LOC                \n");
//		tSQL.append(" , ?   --CEO_NAME_ENG                \n");
//		tSQL.append(" , ?   --EMAIL                       \n");
//		tSQL.append(" , ?   --ZIP_BOX_NO                  \n");
//		tSQL.append(" , ?   --PHONE_NO2                   \n");
//		tSQL.append(" )                                   \n");
		
		sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp2.getQuery());
		String[] setType2 = {
		            		"S","S","S","S","S",
		                    "S","S","S","S","S",
		                    "S","S","S" 		};
		rtn = sm.doInsert(str2, setType2);
		
		if(rtn < 1)	throw new Exception("ICOMADDR INSERT ERROR");
		else Commit(); 
        
        }catch(DBOpenException e) { 
            Rollback(); 
            throw new Exception("et_setInsert:"+e.getMessage()); 
        } 
        
        return rtn; 
    }     
    
  
    /* ICT 사용 : 공급사 사용자 등록*/
    public SepoaOut setInsert_ict(String[] args, String[] args2){ 
    	 
        try 
        { 
            String[][] str = new String[1][]; 
            str[0] = args; 
            String[][] str2 = new String[1][]; 
            str2[0] = args2; 
            
            int rtn = et_setInsert_ict(str, str2); 
            setValue("Insert Row=" + rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000")); 
        }catch(Exception e) 
        { 
            Logger.err.println("Exception e =" + e.getMessage()); 
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            Logger.err.println(this,e.getMessage()); 
            //log err 
        } 
        return getSepoaOut(); 
    } 

    /* ICT 사용 : 공급사 사용자 등록*/  
    private int et_setInsert_ict(String[][] str , String[][] str2) 
                             throws Exception, DBOpenException { 
        int rtn = -1; 
        ConnectionContext ctx = getConnectionContext(); 
 
        try { 
		 
			SepoaSQLManager sm = null;
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, "et_setInsert_ict_01");
			wxp.addVar("house_code", house_code);
			wxp.addVar("userId", info.getSession("ID"));
			wxp.addVar("status", "C");
			wxp.addVar("add_date", SepoaDate.getShortDateString());
			wxp.addVar("add_time",SepoaDate.getShortTimeString());
			wxp.addVar("str_0_4",str[0][4]);
			
	
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			
			//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
			String[] setType = {	"S","S","S","S","S",
			                        "S","S","S","S","S",
			                        "S","S","S","S","S",
			                        "S","S","S" 		};
			
			rtn = sm.doInsert(str, setType);
			
			SepoaXmlParser wxp2 = new SepoaXmlParser(this, "et_setInsert_ict_02");
			wxp2.addVar("house_code", info.getSession("HOUSE_CODE"));		
			
			if(rtn < 1) throw new Exception("ICOMLUSR_ICT INSERT ERROR");
		
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp2.getQuery());
			String[] setType2 = {
			            		"S","S","S","S","S",
			                    "S","S","S","S","S",
			                    "S","S","S" 		};
			rtn = sm.doInsert(str2, setType2);
		
			if(rtn < 1)	throw new Exception("ICOMADDR_ICT INSERT ERROR");
			else Commit(); 
        
        }catch(DBOpenException e) { 
            Rollback(); 
            throw new Exception("et_setInsert:"+e.getMessage()); 
        } 
        
        return rtn; 
    }         
    

    
    /* Mainternace : 사용자현황-조회 (A76) */ 
    public SepoaOut getMainternace(Map<String, String> header){ 
 
        try 
        { 
 
            String user_id = info.getSession("ID"); 
 
            String rtn = ""; 
            //String str[] = {args[1], args[2], args[3], args[4], args[5], args[6], args[7] }; 
 
            // Isvalue(); .... 
            rtn = et_getMainternace(header);
            setValue(rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000")); 
 
        }catch(Exception e) 
        { 
            Logger.err.println("Exception e =" + e.getMessage()); 
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            Logger.err.println(this,e.getMessage()); 
        } 
        return getSepoaOut(); 
    } 
 
    //사용자현황-조회 (A76) 
    private String et_getMainternace(Map<String, String> header) throws Exception 
    { 
        String rtn = ""; 
        ConnectionContext ctx = getConnectionContext(); 
 
        // 사용자 ID, 사용자명, 부서코드, 직급, 전화번호, 메뉴명 
        try { 
	        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        	
	    		//wxp.addVar("sign_status", sign_status);
        		
//                StringBuffer tSQL = new StringBuffer(); 
//                tSQL.append( " SELECT HOUSE_CODE, USER_ID, USER_NAME_LOC, COMPANY_NAME , TEXT_WORK_TYPE , "); 
//                tSQL.append( " DEPT, MANAGER_POSITION ,PHONE_NO, MENU_NAME, MENU_PROFILE_CODE, SIGN_STATUS "); 
//                tSQL.append( " FROM  USER_LIST_VW "); 
//                tSQL.append( " <OPT=F,S> WHERE HOUSE_CODE = ? </OPT>"); 
//                tSQL.append( " <OPT=S,S> AND USER_ID LIKE '%' + ? + '%' </OPT>"); 
//                tSQL.append( " <OPT=S,S> AND USER_NAME_LOC LIKE UPPER(?) </OPT> "); 
//                tSQL.append( " <OPT=S,S> AND COMPANY_CODE = ? </OPT> "); 
//                tSQL.append( " <OPT=S,S> AND DEPT = ?  </OPT> "); 
//                tSQL.append( " <OPT=S,S> AND USER_TYPE = ?  </OPT> "); 
//                tSQL.append( " <OPT=S,S> AND WORK_TYPE = ?  </OPT> "); 
 
//                if(sign_status.equals("R")) tSQL.append( " AND SIGN_STATUS = 'R'");     //R : 등록  A:승인 
//                else tSQL.append( " AND SIGN_STATUS = 'A'");        //R : 등록  A:승인 
 
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
            rtn = sm.doSelect(header); 
 
            if(rtn == null) throw new Exception("SQL Manager is Null"); 
            }catch(Exception e) { 
                throw new Exception("et_getMainternace:"+e.getMessage()); 
            } finally{ 
            //Release(); 
        } 
        return rtn; 
    } 

    /* ICT 사용 : Mainternace : 사용자현황-조회 (A76) */ 
    public SepoaOut getMainternace_ict(Map<String, String> header){ 
 
        try 
        { 
 
            String user_id = info.getSession("ID"); 
 
            String rtn = ""; 
            //String str[] = {args[1], args[2], args[3], args[4], args[5], args[6], args[7] }; 
 
            // Isvalue(); .... 
            rtn = et_getMainternace_ict(header);
            setValue(rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000")); 
 
        }catch(Exception e) 
        { 
            Logger.err.println("Exception e =" + e.getMessage()); 
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            Logger.err.println(this,e.getMessage()); 
        } 
        return getSepoaOut(); 
    } 
 
    // ICT 사용 : 사용자현황-조회 (A76) 
    private String et_getMainternace_ict(Map<String, String> header) throws Exception 
    { 
        String rtn = ""; 
        ConnectionContext ctx = getConnectionContext(); 
 
        // 사용자 ID, 사용자명, 부서코드, 직급, 전화번호, 메뉴명 
        try { 
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        	
 
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
            rtn = sm.doSelect(header); 
 
            if(rtn == null) throw new Exception("SQL Manager is Null"); 
            }catch(Exception e) { 
                throw new Exception("et_getMainternace:"+e.getMessage()); 
            } finally{ 
            //Release(); 
        } 
        return rtn; 
    }     
    
    
    /* 사용자 계정 타입 (A76) */ 
     public SepoaOut getWokrType(String[] args){ 
  
         try 
         { 
             String rtn = ""; 
             rtn = et_getWokrType(args); 
             setValue(rtn); 
             setStatus(1); 
             setMessage(msg.getMessage("0000")); 
  
         }catch(Exception e) 
         { 
             Logger.err.println("Exception e =" + e.getMessage()); 
             setStatus(0); 
             setMessage(msg.getMessage("0001")); 
             Logger.err.println(this,e.getMessage()); 
         } 
         return getSepoaOut(); 
     } 
  
     //사용자 계정 타입-조회 (A76) 
     private String et_getWokrType(String[] args) throws Exception 
     { 
         String rtn = ""; 
         ConnectionContext ctx = getConnectionContext(); 
  
         try { 
        	 SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
  
             SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
             rtn = sm.doSelect(args); 
  
             if(rtn == null) throw new Exception("SQL Manager is Null"); 
             }catch(Exception e) { 
                 throw new Exception("et_getMainternace:"+e.getMessage()); 
             } finally{ 
             //Release(); 
         } 
         return rtn; 
     }
 
     /* ICT 사용 : 사용자 계정 타입 (A76) */ 
     public SepoaOut getWokrType_ict(String[] args){ 
  
         try 
         { 
             String rtn = ""; 
             rtn = et_getWokrType_ict(args); 
             setValue(rtn); 
             setStatus(1); 
             setMessage(msg.getMessage("0000")); 
  
         }catch(Exception e) 
         { 
             Logger.err.println("Exception e =" + e.getMessage()); 
             setStatus(0); 
             setMessage(msg.getMessage("0001")); 
             Logger.err.println(this,e.getMessage()); 
         } 
         return getSepoaOut(); 
     } 
  
     // ICT 사용 : 사용자 계정 타입-조회 (A76) 
     private String et_getWokrType_ict(String[] args) throws Exception 
     { 
         String rtn = ""; 
         ConnectionContext ctx = getConnectionContext(); 
  
         try { 
        	 SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
  
             SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
             rtn = sm.doSelect(args); 
  
             if(rtn == null) throw new Exception("SQL Manager is Null"); 
             }catch(Exception e) { 
                 throw new Exception("et_getMainternace:"+e.getMessage()); 
             } finally{ 
             //Release(); 
         } 
         return rtn; 
     }
 

 

 
 
    
    
    
	//수정화면, 상세조회화면에서 기존에 데이타를 보여주는 쿼리문.
	//사용자현황-수정(A76) 수정화면에 뿌려줄 데이터 조회
    public SepoaOut getDisplay(String[] args) { 
        String user_id 	= info.getSession("ID"); 
        String house_code = info.getSession("HOUSE_CODE"); 
 
        try { 
            Logger.debug.println(user_id, this, "user_id====>" + user_id); 
            String rtn = null; 
            rtn = et_getDisplay(user_id, house_code, args); 
            setValue(rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000")); 
        }catch(Exception e){ 
             
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            Logger.err.println(user_id,this, e.getMessage()); 
        } 
        return getSepoaOut(); 
    } 
    
    //사용자현황-수정(A76) 
    public String et_getDisplay(String user_id, String house_code, String[] args) throws Exception { 
        String result = null; 
        ConnectionContext ctx = getConnectionContext(); 
        try { 
        		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//                StringBuffer tSQL = new StringBuffer(); 
//                tSQL.append("    SELECT L.HOUSE_CODE, "); 
//                tSQL.append("           L.PASSWORD, ");
//                tSQL.append("           L.USER_ID, "); 
//                tSQL.append("           L.USER_NAME_LOC, "); 
//                tSQL.append("           L.USER_NAME_ENG, "); 
//                tSQL.append("           L.COMPANY_CODE, "); 
//                tSQL.append("           L.DEPT, "); 
//                tSQL.append("           L.RESIDENT_NO, "); 
//                tSQL.append("           L.EMPLOYEE_NO, "); 
//                tSQL.append("           L.EMAIL, "); 
//                tSQL.append("           L.POSITION, "); 
//                tSQL.append("           L.LANGUAGE, "); 
//                tSQL.append("           L.TIME_ZONE, "); 
//                tSQL.append("           L.COUNTRY, "); 
//                tSQL.append("           L.CITY_CODE, "); 
//                tSQL.append("           L.PR_LOCATION, "); 
//                tSQL.append("           L.MANAGER_POSITION, "); 
//                tSQL.append("           GETICOMCODE1(L.HOUSE_CODE, 'M104', L.WORK_TYPE) AS USER_TYPE, "); 
//                tSQL.append("           A.CODE_TYPE, "); 
//                tSQL.append("           A.CODE_TYPE, "); 
//                tSQL.append("           A.ZIP_CODE, "); 
//                tSQL.append("           A.PHONE_NO1, "); 
//                tSQL.append("           A.FAX_NO, "); 
//                tSQL.append("           A.HOMEPAGE, "); 
//                tSQL.append("           A.ADDRESS_LOC, "); 
//                tSQL.append("           A.ADDRESS_ENG, "); 
//                tSQL.append("           A.CEO_NAME_LOC, "); 
//                tSQL.append("           A.CEO_NAME_ENG, "); 
//                tSQL.append("           A.EMAIL, "); 
//                tSQL.append("           A.ZIP_BOX_NO, "); 
//                tSQL.append("           A.PHONE_NO2 "); 
//                tSQL.append("      FROM ICOMLUSR L, "); 
//                tSQL.append("           ICOMADDR A "); 
//                tSQL.append("     WHERE L.COMPANY_CODE = A.CODE_NO ");
//                tSQL.append("       AND L.HOUSE_CODE = A.HOUSE_CODE ");
//                tSQL.append(" <OPT=F,S> and L.user_id = ? </OPT> "); 

                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                result = sm.doSelect(args); 
                if(result == null) throw new Exception("SQLManager is null"); 
        }catch(Exception ex) { 
            throw new Exception("et_getDisplay()"+ ex.getMessage()); 
        } 
        return result; 
    } 

	// ICT 수정 : 수정화면, 상세조회화면에서 기존에 데이타를 보여주는 쿼리문.
	// ICT 수정 : 사용자현황-수정(A76) 수정화면에 뿌려줄 데이터 조회
    public SepoaOut getDisplay_ict(String[] args) { 
        String user_id 	= info.getSession("ID"); 
        String house_code = info.getSession("HOUSE_CODE"); 
 
        try { 
            Logger.debug.println(user_id, this, "user_id====>" + user_id); 
            String rtn = null; 
            rtn = et_getDisplay_ict(user_id, house_code, args); 
            setValue(rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000")); 
        }catch(Exception e){ 
             
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            Logger.err.println(user_id,this, e.getMessage()); 
        } 
        return getSepoaOut(); 
    } 
	// ICT 수정 : 사용자현황-수정(A76) 
    public String et_getDisplay_ict(String user_id, String house_code, String[] args) throws Exception { 
        String result = null; 
        ConnectionContext ctx = getConnectionContext(); 
        try { 
        		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                result = sm.doSelect(args); 
                if(result == null) throw new Exception("SQLManager is null"); 
        }catch(Exception ex) { 
            throw new Exception("et_getDisplay()"+ ex.getMessage()); 
        } 
        return result; 
    }     
    
/*수정한 항목들을 DB에 Update 해준다.*/
//    사용자현황-수정() ---> 사용자수정(팝업)-수정 A77
    public SepoaOut setUpdate(String[] args, String[] args2){      
 		
        try 
        { 
            String[][] str = new String[1][]; 
            str[0] = args; 
            String[][] str2 = new String[1][]; 
            str2[0] = args2; 
            
            int rtn = et_setUpdate(str, str2); 
            setValue("update Row=" + rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000")); 
        }catch(Exception e) 
        { 
            Logger.err.println("Exception e =" + e.getMessage()); 
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            Logger.err.println(this,e.getMessage()); 
            //log err 
        } 
        return getSepoaOut(); 
    }
    
    /* ICT 사용 : 사용자현황-수정() ---> 사용자수정(팝업)-수정 A77 */
    public SepoaOut setUpdate_ict(String[] args, String[] args2){      
		
      try 
      { 
          String[][] str = new String[1][]; 
          str[0] = args; 
          String[][] str2 = new String[1][]; 
          str2[0] = args2; 
          
          int rtn = et_setUpdate_ict(str, str2); 
          setValue("update Row=" + rtn); 
          setStatus(1); 
          setMessage(msg.getMessage("0000")); 
      }catch(Exception e) 
      { 
          Logger.err.println("Exception e =" + e.getMessage()); 
          setStatus(0); 
          setMessage(msg.getMessage("0001")); 
          Logger.err.println(this,e.getMessage()); 
          //log err 
      } 
      return getSepoaOut(); 
	}
    
    private String getSHA256(String str) throws Exception{
		String rtnSHA = "";
		
		try{
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			md.update(str.getBytes());
			byte byteData[] = md.digest();
			StringBuffer sb = new StringBuffer();
			
			for(int i=0;i<byteData.length;i++){
				sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
			}
			
			rtnSHA = Base64.base64Encode(sb.toString());
			
		}catch(NoSuchAlgorithmException e){
			Logger.err.println("Exception e =" + e.getMessage());
			//e.printStackTrace();
			rtnSHA = null;
		}
		
		return rtnSHA;
	}
    
    //  사용자현황-수정() ---> 사용자수정(팝업)-수정 A77    
    private int et_setUpdate(String[][] str , String[][] str2) 
                             throws Exception, DBOpenException { 
        int rtn = -1; 
        ConnectionContext ctx = getConnectionContext(); 
        Map<String, String> param = new HashMap<String, String>();
        Map<String, String> param2 = new HashMap<String, String>();
        Map<String, String> param3 = new HashMap<String, String>();
        try { 
		
		
		SepoaSQLManager sm = null;
		SepoaSQLManager sm2 = null;
		Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>>>> ICOMLUSR");
		
		SepoaXmlParser wxp = new SepoaXmlParser(this, "et_setUpdate_01");
		wxp.addVar("houseCode", info.getSession("HOUSE_CODE"));
		wxp.addVar("status", "R");
		wxp.addVar("add_date", SepoaDate.getShortDateString());
		wxp.addVar("add_time", SepoaDate.getShortTimeString());
		wxp.addVar("userId", info.getSession("ID"));
		wxp.addVar("passwd", str[0][0]);
		wxp.addVar("verifier_key", str[0][16]);
		wxp.addVar("old_password", str[0][18]);
		
		param3.put("house_code",  info.getSession("HOUSE_CODE"));
		param3.put("user_id"   ,  info.getSession("ID"));
		param3.put("password"  ,  str[0][0]);
		
		param.put("str1", str[0][0]);
		param.put("str2", str[0][1]);
		param.put("str3", str[0][2]);
		param.put("str4", info.getSession("COMPANY_CODE"));//param.put("str4", str[0][3]);
		param.put("str5", str[0][4]);
		param.put("str6", str[0][5]);
		param.put("str7", str[0][6]);
		param.put("str8", str[0][7]);
		param.put("str9", str[0][8]);
		param.put("str10", str[0][9]);
		param.put("str11", str[0][10]);
		param.put("str12", str[0][11]);
		param.put("str13", str[0][12]);
		param.put("str14", str[0][13]);
		param.put("str15", str[0][14]);
		param.put("str16", str[0][15]);
		param.put("str17", str[0][16]);
		param.put("str18", str[0][17]);
		param.put("str19", str[0][18]);
		param.put("str20", str[0][19]);
//		StringBuffer tSQL = new StringBuffer(); 
//		tSQL.append(" UPDATE ICOMLUSR SET                                \n");		
//		tSQL.append("   HOUSE_CODE      	=   '"+houseCode+"'          \n");			
//		tSQL.append(" , PASSWORD            = ?                          \n");      
//		tSQL.append(" , USER_NAME_LOC       = ?                          \n");    
//		tSQL.append(" , USER_NAME_ENG       = ?                          \n");    
//		tSQL.append(" , COMPANY_CODE        = ?                          \n");    
//		tSQL.append(" , DEPT                = ?                          \n");     
//		tSQL.append(" , RESIDENT_NO         = ?                          \n");    
//		tSQL.append(" , EMPLOYEE_NO         = ?                          \n");    
//		tSQL.append(" , EMAIL               = ?                          \n");    
//		tSQL.append(" , POSITION            = ?                          \n");    
//		tSQL.append(" , LANGUAGE            = ?                          \n");    
//		tSQL.append(" , TIME_ZONE           = ?                          \n");    
//		tSQL.append(" , COUNTRY             = ?                          \n");    
//		tSQL.append(" , CITY_CODE           = ?                          \n");    
//		tSQL.append(" , PR_LOCATION         = ?                          \n");    
//		tSQL.append(" , MANAGER_POSITION    = ?                          \n");      
//		tSQL.append(" , USER_TYPE           = ?                          \n");    
//		tSQL.append(" , STATUS              =     '"+status+"'           \n");    
//		tSQL.append(" , SIGN_STATUS         =      'A'                   \n");
//		tSQL.append(" , ADD_DATE            =      '"+add_date+"'        \n");    
//		tSQL.append(" , ADD_TIME            =      '"+add_time+"'        \n");    
//		tSQL.append(" , ADD_USER_ID         =      '"+userId+"'          \n");    
//		tSQL.append(" , CHANGE_USER_ID      =      '"+userId+"'          \n");    
//		tSQL.append("   where house_code = '"+house_code+"' and user_id = ?  \n");   
		
		sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
		
		//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
		String[] setType = {	"S","S","S","S","S",
		                        "S","S","S","S","S",
		                        "S","S","S","S","S",
		                        "S","S","S","S"	};
//		String[] setType = {	"S","S","S","S","S",
//								"S","S","S","S","S",
//								"S","S","S","S","S",
//								"S","S","S","S"	};
		
		rtn = sm.doUpdate(param);
		if(rtn < 1)	throw new Exception("ICOMLUSR UPDATE ERROR");
		
		SepoaXmlParser wxp2 = new SepoaXmlParser(this, "et_setUpdate_02");
		wxp2.addVar("house_code", info.getSession("HOUSE_CODE"));		
		wxp2.addVar("code_type", str2[0][0]);
//		Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>>>> ICOMADDR");
//		tSQL = new StringBuffer();
//		tSQL.append(" UPDATE ICOMADDR SET                 	  \n");		
//		tSQL.append("   HOUSE_CODE      =   '"+house_code+"'   \n");		
//		tSQL.append(" , CODE_TYPE       = ?                   \n");
//		tSQL.append(" , ZIP_CODE        = ?                   \n");				//ZIP_CODE,
//		tSQL.append(" , PHONE_NO1       = ?                   \n");             //PHONE_NO,
//		tSQL.append(" , FAX_NO          = ?                   \n");             //FAX_NO,
//		tSQL.append(" , HOMEPAGE        = ?                   \n");
//		tSQL.append(" , ADDRESS_LOC     = ?                   \n");				//ADDRESS_LOC,
//		tSQL.append(" , ADDRESS_ENG     = ?                   \n");				//ADDRESS_ENG,
//		tSQL.append(" , CEO_NAME_LOC    = ?                   \n");				 
//		tSQL.append(" , CEO_NAME_ENG    = ?                   \n");
//		tSQL.append(" , EMAIL           = ?                   \n");
//		tSQL.append(" , ZIP_BOX_NO      = ?                   \n");
//		tSQL.append(" , PHONE_NO2       = ?                   \n");					//MOBILE_NO,
//		tSQL.append("   where house_code = '"+house_code+"' and CODE_NO = dbo.lpad(?, 10, '0')  \n");   
		
		sm2 = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp2.getQuery());
		String[] setType2 = {
		            		"S","S","S","S","S",
		                    "S","S","S","S","S"
		                    //"S","S","S"
		                    };
		param2.put("str1", str2[0][0]);
		param2.put("str2", str2[0][1]);
		param2.put("str3", str2[0][2]);
		param2.put("str4", str2[0][3]);
		param2.put("str5", str2[0][4]);
		param2.put("str6", str2[0][5]);
		param2.put("str7", str2[0][6]);
		param2.put("str8", str2[0][7]);
		param2.put("str9", str2[0][8]);
		param2.put("str10", str2[0][9]);
		rtn = sm2.doUpdate(param2);
		
		if(rtn < 1)	throw new Exception("ICOMADDR UPDATE ERROR");
		else{
			if(str[0][0]!= null && !"".equals(str[0][0])){
			SepoaXmlParser sxp  = new SepoaXmlParser(this, "setLogin_Pwd_History");
            SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            ssm.doInsert(param3);
			}
			Commit(); 
		}
        
        }catch(DBOpenException e) { 
                    Rollback(); 
                    throw new Exception("et_setUpdate:"+e.getMessage()); 
        } 
        return rtn; 
    } 
    
    
    //  ICT 수정 : 사용자현황-수정() ---> 사용자수정(팝업)-수정 A77    
    private int et_setUpdate_ict(String[][] str , String[][] str2) 
                             throws Exception, DBOpenException { 
        int rtn = -1; 
        ConnectionContext ctx = getConnectionContext(); 
        Map<String, String> param = new HashMap<String, String>();
        Map<String, String> param2 = new HashMap<String, String>();
        Map<String, String> param3 = new HashMap<String, String>();
        try { 
		
		
		SepoaSQLManager sm = null;
		SepoaSQLManager sm2 = null;
		Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>>>> ICOMLUSR_ICT");
		
		SepoaXmlParser wxp = new SepoaXmlParser(this, "et_setUpdate_ict_01");
		wxp.addVar("houseCode", info.getSession("HOUSE_CODE"));
		wxp.addVar("status", "R");
		wxp.addVar("add_date", SepoaDate.getShortDateString());
		wxp.addVar("add_time", SepoaDate.getShortTimeString());
		wxp.addVar("userId", info.getSession("ID"));
		wxp.addVar("passwd", str[0][0]);
		wxp.addVar("verifier_key", str[0][16]);
		wxp.addVar("old_password", str[0][18]);
		
		param3.put("house_code",  info.getSession("HOUSE_CODE"));
		param3.put("user_id"   ,  info.getSession("ID"));
		param3.put("password"  ,  str[0][0]);
		
		param.put("str1", str[0][0]);
		param.put("str2", str[0][1]);
		param.put("str3", str[0][2]);
		//param.put("str4", str[0][3]);
		param.put("str4", info.getSession("COMPANY_CODE"));
		param.put("str5", str[0][4]);
		param.put("str6", str[0][5]);
		param.put("str7", str[0][6]);
		param.put("str8", str[0][7]);
		param.put("str9", str[0][8]);
		param.put("str10", str[0][9]);
		param.put("str11", str[0][10]);
		param.put("str12", str[0][11]);
		param.put("str13", str[0][12]);
		param.put("str14", str[0][13]);
		param.put("str15", str[0][14]);
		param.put("str16", str[0][15]);
		param.put("str17", str[0][16]);
		param.put("str18", str[0][17]);
		param.put("str19", str[0][18]);

		
		sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
		
		//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
		String[] setType = {	"S","S","S","S","S",
		                        "S","S","S","S","S",
		                        "S","S","S","S","S",
		                        "S","S","S"	};
		
		rtn = sm.doUpdate(param);
		if(rtn < 1)	throw new Exception("ICOMLUSR UPDATE ERROR");
		
		SepoaXmlParser wxp2 = new SepoaXmlParser(this, "et_setUpdate_ict_02");
		wxp2.addVar("house_code", info.getSession("HOUSE_CODE"));		
		wxp2.addVar("code_type", str2[0][0]);
		
		sm2 = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp2.getQuery());
		String[] setType2 = {
		            		"S","S","S","S","S",
		                    "S","S","S","S","S"
		                    };

		param2.put("str1", str2[0][0]);
		param2.put("str2", str2[0][1]);
		param2.put("str3", str2[0][2]);
		param2.put("str4", str2[0][3]);
		param2.put("str5", str2[0][4]);
		param2.put("str6", str2[0][5]);
		param2.put("str7", str2[0][6]);
		param2.put("str8", str2[0][7]);
		param2.put("str9", str2[0][8]);
		param2.put("str10", str2[0][9]);
		rtn = sm2.doUpdate(param2);
		
		if(rtn < 1)	throw new Exception("ICOMADDR_ICT UPDATE ERROR");
		else{
			if(str[0][0] != null && !"".equals(str[0][0])){
			SepoaXmlParser sxp  = new SepoaXmlParser(this, "setLogin_Pwd_History");
            SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            ssm.doInsert(param3);
			}
			Commit(); 
		}
        
        }catch(DBOpenException e) { 
                    Rollback(); 
                    throw new Exception("et_setUpdate:"+e.getMessage()); 
        } 
        return rtn; 
    } 

    
    
    
    
    
    
    
    /**
	 * 삭제 - 신규 사용자 승인에서의 삭제  사용자현황-삭제 A77
	 * @method setDelete
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-10-28
	 * @modify 2014-10-28
	 */
     public SepoaOut setDelete(Map<String, Object> param){ 
  
         try 
         { 
             int rtn = et_setDelete(param); 
             setValue("Delete Row=" + rtn); 
             setStatus(1); 
             //setMessage(msg.getMessage("0000")); 
             setMessage("성공적으로 삭제되었습니다."); 
         }catch(Exception e) 
         { 
             Logger.err.println("Exception e =" + e.getMessage()); 
             setStatus(0); 
             setMessage(e.getMessage().trim()); 
             //setMessage(msg.getMessage("0001")); 
             Logger.err.println(this,e.getMessage()); 
             //log err 
         } 
         return getSepoaOut(); 
     } 

     /**
 	 * 서플라이어 사용자현황& 승인-삭제 A77    사용자현황-삭제 A77
 	 * @method et_setDelete
 	 * @param  header
 	 * @return Map
 	 * @throws Exception
 	 * @desc   ICOYRQDT
 	 * @since  2014-10-28
 	 * @modify 2014-10-28
 	 */
     @SuppressWarnings("unchecked")
	private int et_setDelete(Map<String, Object> param) throws Exception, DBOpenException { 
         int rtn = -1; 
         ConnectionContext ctx           = getConnectionContext();
         String   id                     = info.getSession("ID"); 
          
         List<Map<String, String>> grid  = (List<Map<String, String>>)param.get("gridData");
         Map<String, String> gridInfo    = null;

         SepoaSQLManager ssm             = null;
         SepoaXmlParser sxp              = null;
         
         try {         	 	
        	 	
//        	 	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//        	 	wxp.addVar("add_date", add_date);
//     			wxp.addVar("add_time", add_time);
//     			wxp.addVar("id"      , id);
//                SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
  
                 //넘기는 데이타의 type : String S, Number N(int, double 모두 포함.) 
//                 String[] setType = {"S","S"}; 
//                 rtn = sm.doDelete(args, setType); 
                 
                for(int i = 0; i< grid.size() ; i++){
               	 	gridInfo = grid.get(i);
               	
               	 	sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	                ssm = new SepoaSQLManager(id, this, ctx, sxp);
	                
	                gridInfo.put("change_user_id",                 id);
	                
	                
	                rtn = ssm.doUpdate(gridInfo);
	                
                }
                
                 
                 if(rtn == -1) throw new Exception("SQL Manager is Null"); 
                 else Commit(); 
             }catch(DBOpenException e) { 
                     Rollback(); 
                     throw new Exception("et_setDelete:"+e.getMessage()); 
             } 
         return rtn; 
     } 

     /* ICT 사용 : 삭제 - 신규 사용자 승인에서의 삭제  사용자현황-삭제 A77 */
     public SepoaOut setDelete_ict(Map<String, Object> param){ 
  
         try 
         { 
             int rtn = et_setDelete_ict(param); 
             setValue("Delete Row=" + rtn); 
             setStatus(1); 
             //setMessage(msg.getMessage("0000")); 
             setMessage("성공적으로 삭제되었습니다."); 
         }catch(Exception e) 
         { 
             Logger.err.println("Exception e =" + e.getMessage()); 
             setStatus(0); 
             setMessage(e.getMessage().trim()); 
             //setMessage(msg.getMessage("0001")); 
             Logger.err.println(this,e.getMessage()); 
             //log err 
         } 
         return getSepoaOut(); 
     } 

     /* ICT 사용 : 서플라이어 사용자현황& 승인-삭제 A77    사용자현황-삭제 A77 */
     @SuppressWarnings("unchecked")
	private int et_setDelete_ict(Map<String, Object> param) throws Exception, DBOpenException { 
         int rtn = -1; 
         ConnectionContext ctx           = getConnectionContext();
         String   id                     = info.getSession("ID"); 
          
         List<Map<String, String>> grid  = (List<Map<String, String>>)param.get("gridData");
         Map<String, String> gridInfo    = null;

         SepoaSQLManager ssm             = null;
         SepoaXmlParser sxp              = null;
         
         try {         	 	
        	 	
  
                 //넘기는 데이타의 type : String S, Number N(int, double 모두 포함.) 
                for(int i = 0; i< grid.size() ; i++){
               	 	gridInfo = grid.get(i);
               	
               	 	sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	                ssm = new SepoaSQLManager(id, this, ctx, sxp);
	                
	                gridInfo.put("change_user_id",                 id);
	                
	                
	                rtn = ssm.doUpdate(gridInfo);
	                
                }
                
                 
                 if(rtn == -1) throw new Exception("SQL Manager is Null"); 
                 else Commit(); 
             }catch(DBOpenException e) { 
                     Rollback(); 
                     throw new Exception("et_setDelete:"+e.getMessage()); 
             } 
         return rtn; 
     }

     
     /** 사용자 현황 조회에서의 삭제는 status ='D'로 하는 것이다. 
 //  사용자현황-삭제 A77 */ 
     public SepoaOut setStatusD(String[][] args){ 
  
         try 
         { 
  
             //Header Insert 
             String add_date = SepoaDate.getShortDateString(); 
             String add_time = SepoaDate.getShortTimeString(); 
  
             int rtn = et_setStatusD(args,add_date, add_time); 
             setValue("Update Row=" + rtn); 
             setStatus(1); 
             //setMessage(msg.getMessage("0000")); 
             setMessage("성공적으로 삭제되었습니다."); 
         }catch(Exception e) { 
             Logger.err.println("Exception e =" + e.getMessage()); 
             setStatus(0); 
             setMessage(e.getMessage().trim()); 
             //setMessage(msg.getMessage("0001")); 
             Logger.err.println(this,e.getMessage()); 
         } 
         return getSepoaOut(); 
     } 
//  사용자현황-삭제 A77  
     private int et_setStatusD(String[][] args, String add_date, String add_time) 
                              throws Exception, DBOpenException { 
         int rtn = -1; 
         ConnectionContext ctx = getConnectionContext(); 
         String depart       = info.getSession("DEPARTMENT"); 
         String user_id      = info.getSession("ID"); 
         String name_loc     = info.getSession("NAME_LOC"); 
         String name_eng     = info.getSession("NAME_ENG"); 
  
     try { 
    	 	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_01");
 			wxp.addVar("add_date", add_date);
 			wxp.addVar("add_time", add_time);
 			wxp.addVar("add_time", user_id);
 			
//                 StringBuffer tSQL = new StringBuffer(); 
//                 StringBuffer tSQL1 = new StringBuffer(); 
//                 StringBuffer tSQL2 = new StringBuffer(); 
  
//                 tSQL.append( " UPDATE ICOMLUSR "); 
//                 tSQL.append( " SET STATUS = 'D', "); 
//                 tSQL.append( "  CHANGE_DATE = '"+add_date+"',  "); 
//                 tSQL.append( "  CHANGE_TIME = '"+add_time+"',  "); 
//                 tSQL.append( "  CHANGE_USER_ID = '"+user_id+"'  ");                
//                 tSQL.append( " WHERE HOUSE_CODE = ? "); 
//                 tSQL.append( " AND USER_ID = ? "); 
  
                 SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
  
                 //넘기는 데이타의 type : String S, Number N(int, double 모두 포함.) 
                 String[] setType = {"S","S"}; 
  
                 rtn = sm.doUpdate(args, setType); 
  
  
  /*
         	 	SepoaXmlParser wxp2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_02");
  
//                 tSQL1.append( " DELETE FROM ICOMRULR "); 
//                 tSQL1.append( " WHERE HOUSE_CODE = ? "); 
//                 tSQL1.append( " AND USER_ID = ? "); 
  
                 SepoaSQLManager sm1 = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp2.getQuery());
                 sm1.doDelete(args, setType); 
  
                 
          	 	SepoaXmlParser wxp3 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_03");                 
//                 tSQL2.append( " DELETE FROM ICOMRULR "); 
//                 tSQL2.append( " WHERE HOUSE_CODE = ? "); 
//                 tSQL2.append( " AND NEXT_SIGN_USER_ID = ? "); 
  
                 SepoaSQLManager sm2 = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp3.getQuery()); 
                 sm2.doDelete(args, setType); 
  */
  
                 Commit(); 
         }catch(Exception e) { 
                 Rollback(); 
                 throw new Exception("et_setStatusD:"+e.getMessage()); 
         } finally{} 
         return rtn; 
     }     
  
     
     
     
     
     
     

     /////////////////////////////////////////////////////////////////////////////// 
         /** 
         *승인 
         */ 
         public SepoaOut setApproval(Map<String, Object> param){ 
      
             try 
             { 
                 //Header Insert 
                 String add_date = SepoaDate.getShortDateString(); 
                 String add_time = SepoaDate.getShortTimeString(); 
      
                 int rtn = et_setApproval(param, add_date, add_time); 
                 setValue("Update Row=" + rtn); 
                 setStatus(1); 
                 //setMessage(msg.getMessage("0000")); 
                 setMessage("성공적으로 승인되었습니다."); 
             }catch(Exception e) { 
                 Logger.err.println("Exception e =" + e.getMessage()); 
                 setStatus(0); 
                 setMessage(e.getMessage().trim()); 
      
                 //setMessage(msg.getMessage("0001")); 
                 Logger.err.println(this,e.getMessage()); 
             } 
             return getSepoaOut(); 
         } 
      
         @SuppressWarnings("unchecked")
		private int et_setApproval(Map<String, Object> param, String add_date, String add_time) 
                                  throws Exception, DBOpenException { 
             int rtn = -1; 
             ConnectionContext ctx           = getConnectionContext(); 
             String depart                   = info.getSession("DEPARTMENT"); 
             String id                       = info.getSession("ID"); 
             String name_loc                 = info.getSession("NAME_LOC"); 
             String name_eng                 = info.getSession("NAME_ENG"); 
                                             
//             List<Map<String, String>> grid  = (List<Map<String, String>>)MapUtils.getObject(param, "gridData");
             List<Map<String, String>> grid  = (List<Map<String, String>>)param.get("gridData");
             Map<String, String> gridInfo    = null;

             SepoaSQLManager ssm             = null;
             SepoaXmlParser sxp              = null;
            		 
         try { 
//  			 sxp.addVar("add_date", add_date);
//  			 sxp.addVar("add_time", add_time);
//  			 sxp.addVar("user_id", user_id); 

                     //넘기는 데이타의 type : String S, Number N(int, double 모두 포함.) 
                     //String[] setType = {"S","S","S"}; 
      
                     
                     for(int i = 0; i< grid.size() ; i++){
                    	 gridInfo = grid.get(i);
                    	
                    	sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
     	                ssm = new SepoaSQLManager(id, this, ctx, sxp);
     	                
     	                gridInfo.put("add_date",           add_date);
     	                gridInfo.put("add_time",           add_time);
     	                gridInfo.put("id",                 id);
     	                gridInfo.put("menu_profile_code",  "MUP141000002");
     	                
     	                
     	                rtn = ssm.doUpdate(gridInfo);
     	                
                     }

                     //rtn = sm.doUpdate(param); 
      
                     Commit(); 
             }catch(Exception e) { 
                     Rollback(); 
                     throw new Exception("et_setApproval:"+e.getMessage()); 
             } finally{} 
             return rtn; 
         } 
 //////////////////////////////////////////////////////////////////////////////      
     
     
// 
////수정화면(POP UP)에서 ID와 PASSWORD를 체크하는 쿼리문. 
//    public Sepoa.srv.SepoaOut getCheck(String[] args) { 
//        String user_id = info.getSession("ID"); 
//        String house_code = info.getSession("HOUSE_CODE"); 
//        Logger.debug.println("LEPPLE", this, "service++++++++++++++++++++++++++"); 
// 
//        try { 
//            String rtn = null; 
//            rtn = et_getCheck(user_id, house_code, args); 
//            setValue(rtn); 
//            setStatus(1); 
//            setMessage(msg.getMessage("0000")); 
//        }catch(Exception e){ 
//            System.out.println("Eception e = " + e.getMessage()); 
//            setStatus(0); 
//            setMessage(msg.getMessage("0001")); 
//            Logger.err.println(user_id,this, e.getMessage()); 
//        } 
//        return getSepoaOut(); 
//    } 
// 
//    public String et_getCheck(String user_id, String house_code, String[] args) throws Exception { 
//        String result = null; 
//        String count = ""; 
//        String[][] str = new String[1][2]; 
//        ConnectionContext ctx = getConnectionContext(); 
// 
//        try { 
//                StringBuffer tSQL = new StringBuffer(); 
//                tSQL.append(" select count(*) "); 
//                tSQL.append(" from icomlusr "); 
//                tSQL.append(" where house_code = '"+house_code+"' "); 
//                tSQL.append(" <OPT=F,S> and user_id = ? </OPT> "); 
//                tSQL.append(" <OPT=F,S> and password = ? </OPT> "); 
// 
//                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString()); 
//                result = sm.doSelect(args); 
// 
//                SepoaFormater wf = new SepoaFormater(result); 
//                str = wf.getValue(); 
//                count = str[0][0]; 
// 
//            if(result == null) throw new Exception("SQL Manager is Null"); 
//        }catch(Exception ex) { 
//            throw new Exception("et_getCheck()"+ ex.getMessage()); 
//        } 
//        return count; 
//    } 
// 
// 
    public SepoaOut getMenuobject(String[] args) 
    { 
 
        try 
        { 
            String user_id = info.getSession("ID"); 
 
            String sub_rtn = getMenuobject(args,user_id); 
            SepoaFormater sub_wf = new SepoaFormater(sub_rtn); 
            String menu_object = ""; 
 
            for(int j = 0 ; j < sub_wf.getRowCount() ; j++) 
                    menu_object +=  sub_wf.getValue(j,0) + "<"; 
 
            setValue(menu_object); 
 
            setStatus(1); 
        }catch(Exception e) 
        { 
            Logger.err.println("Exception e =" + e.getMessage()); 
            setStatus(0); 
            setMessage("FindMUPD Failed"); 
            Logger.err.println(this,e.getMessage()); 
 
        } 
        return getSepoaOut(); 
 
 
    } 
 
 
    private String getMenuobject(String[] args,String user_id) throws Exception 
    { 
 
        String rtn = null; 
        ConnectionContext ctx = getConnectionContext(); 
 
        StringBuffer tSQL = new StringBuffer(); 
 
        tSQL.append( " SELECT MENU_OBJECT_CODE "); 
        tSQL.append( " FROM   ICOMMUPD "); 
        tSQL.append( " <OPT=F,S> WHERE  HOUSE_CODE = ? </OPT> " ); 
        tSQL.append( " <OPT=F,S> AND    MENU_PROFILE_CODE =  ? </OPT> " ); 
 
 
        SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString()); 
        rtn = sm.doSelect(args); 
        return rtn; 
 
    }
    
    /* UC쪽지 수신여부 */ 
    public SepoaOut getUcYn(String[] args){ 
 
        try 
        { 
            String rtn = ""; 
            rtn = et_getUcYn(args); 
            setValue(rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000")); 
 
        }catch(Exception e) 
        { 
            Logger.err.println("Exception e =" + e.getMessage()); 
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            Logger.err.println(this,e.getMessage()); 
        } 
        return getSepoaOut(); 
    } 
 
    // UC쪽지 수신여부
    private String et_getUcYn(String[] args) throws Exception 
    { 
        String rtn = ""; 
        ConnectionContext ctx = getConnectionContext(); 
 
        try { 
       	 SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
            rtn = sm.doSelect(args); 
 
            if(rtn == null) throw new Exception("SQL Manager is Null"); 
            }catch(Exception e) { 
                throw new Exception("et_getUcYn:"+e.getMessage()); 
            } finally{ 
            //Release(); 
        } 
        return rtn; 
    }
    
    /* UC쪽지 TO-IS(Y),AS-IS(N) 구분 */ 
    public SepoaOut getUcTobeAsisYn(String[] args){ 
 
        try 
        { 
            String rtn = ""; 
            rtn = et_getUcTobeAsisYn(args); 
            setValue(rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000")); 
 
        }catch(Exception e) 
        { 
            Logger.err.println("Exception e =" + e.getMessage()); 
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            Logger.err.println(this,e.getMessage()); 
        } 
        return getSepoaOut(); 
    } 
 
    //UC쪽지 TO-IS(Y),AS-IS(N) 구분
    private String et_getUcTobeAsisYn(String[] args) throws Exception 
    { 
        String rtn = ""; 
        ConnectionContext ctx = getConnectionContext(); 
 
        try { 
       	 SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
            rtn = sm.doSelect(args); 
 
            if(rtn == null) throw new Exception("SQL Manager is Null"); 
            }catch(Exception e) { 
                throw new Exception("et_getUcTobeAsisYn:"+e.getMessage()); 
            } finally{ 
            //Release(); 
        } 
        return rtn; 
    }
    
    /* Edag가이드Div창 보임 (Y) , Edag가이드Div창 안보임(N) */ 
    public SepoaOut getEdagGuidYn(String[] args){ 
 
        try 
        { 
            String rtn = ""; 
            rtn = et_getEdagGuidYn(args); 
            setValue(rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0000")); 
 
        }catch(Exception e) 
        { 
            Logger.err.println("Exception e =" + e.getMessage()); 
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            Logger.err.println(this,e.getMessage()); 
        } 
        return getSepoaOut(); 
    } 
 
    /* Edag가이드Div창 보임 (Y) , Edag가이드Div창 안보임(N) */
    private String et_getEdagGuidYn(String[] args) throws Exception 
    { 
        String rtn = ""; 
        ConnectionContext ctx = getConnectionContext(); 
 
        try { 
       	 SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
            rtn = sm.doSelect(args); 
 
            if(rtn == null) throw new Exception("SQL Manager is Null"); 
            }catch(Exception e) { 
                throw new Exception("et_getEdagGuidYn:"+e.getMessage()); 
            } finally{ 
            //Release(); 
        } 
        return rtn; 
    } 
} 
 
