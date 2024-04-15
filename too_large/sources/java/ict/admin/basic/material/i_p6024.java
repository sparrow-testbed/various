package ict.admin.basic.material; 

import java.util.HashMap;
import java.util.Iterator;
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
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
 
public class I_p6024 extends SepoaService { 
    Message msg = null;  // message 처리를 위해 전역변수 선언 
 
    public I_p6024(String opt, SepoaInfo info) throws SepoaServiceException{ 
        super(opt, info); 
        setVersion("1.0.0"); 
        msg = new Message(info, "FW");
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

//	public SepoaOut mty_getMaintain(String[] args) { 
//        String user_id = info.getSession("ID"); 
//        String house_code = info.getSession("HOUSE_CODE"); 
// 
//        try { 
//            String rtn = null; 
//            rtn = et_mty_getMaintain(user_id, args, house_code); 
//            setValue(rtn); 
//            setStatus(1); 
//            setMessage(msg.getMessage("0000")); 
//        }catch(Exception e){ 
//            setStatus(0); 
//            setMessage(msg.getMessage("0001")); 
//            Logger.err.println(info.getSession("ID"), this, e.getMessage()); 
//        } 
//        return getSepoaOut(); 
//    } 
	
	public SepoaOut mty_getMaintain(Map<String, String> parma)  { 
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "et_mty_getMaintain");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			rtn    = ssm.doSelect(parma); // 조회
			
			setValue(rtn);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		
		return getSepoaOut();
    }
 
    public String et_mty_getMaintain(String user_id, String[] args, String house_code) throws Exception { 
        String result = null; 
 
        try { 
            ConnectionContext ctx = getConnectionContext(); 
 
            SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			
			/*
            sql.append(" select use_flag, code, text2, text1, text3, text4, text5, text6, text7   \n "); 
            sql.append(" from icomcode                         \n "); 
            sql.append(" <OPT=F,S> where type = ? </OPT>       \n "); 
            sql.append(" and house_code = '"+house_code+"'     \n "); 
            //sql.append(" and use_flag = 'Y'                  \n "); 
            sql.append(" and status != 'D'                     \n "); 
			 */
            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
            result = sm.doSelect(args); 
            if(result == null) throw new Exception("SQLManager is null"); 
        }catch(Exception ex) { 
            throw new Exception("et_mty_getMaintain()"+ ex.getMessage()); 
        } 
        return result; 
    }
 
    /* Jtable에다 Change하구... save 버튼을 누르면.. DB에 들어간다..   */ 
//    public SepoaOut mty_setUpdate(String[][] args) { 
//        int rtn = -1; 
//        String user_id = info.getSession("ID"); 
//        String house_code = info.getSession("HOUSE_CODE"); 
//        String change_date = SepoaDate.getShortDateString(); 
//        String change_time = SepoaDate.getShortTimeString(); 
// 
//        try { 
//            rtn = et_mty_setUpdate(user_id, args, change_date, change_time, house_code); 
//            setValue("Change_Row=" + rtn); 
//            setStatus(1); 
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */ 
//        }catch(Exception e) { 
//            System.out.println("Exception= " + e.getMessage()); 
//            setStatus(0); 
//            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */ 
//        } 
//        return getSepoaOut(); 
//    } 
    
    @SuppressWarnings("unchecked")
	public SepoaOut mty_setUpdate(Map<String, Object> param) throws Exception{ 
    	ConnectionContext         ctx      = null;
        SepoaXmlParser            sxp      = null;
		SepoaSQLManager           ssm      = null;
		List<Map<String, String>> grid     = null;
		Map<String, String>       gridInfo = null;
		String                    id       = info.getSession("ID");
		String                    houseCode   = info.getSession("HOUSE_CODE");
		String                    code        = null;
		String                    text        = null;
		boolean                  chkUseCount = false;
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			grid = (List<Map<String, String>>)param.get("gridData");
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
				code         = gridInfo.get("CODE");
				text         = gridInfo.get("TEXT2");
				chkUseCount = this.chkUseCount(id, code, houseCode);
				
				if(chkUseCount == false){
					throw new Exception("사용중인 코드 입니다. [" + text + "]");
				}
				else{
					sxp = new SepoaXmlParser(this, "et_mty_setUpdate");
	                ssm = new SepoaSQLManager(id, this, ctx, sxp);
	                
	                ssm.doUpdate(gridInfo);
				}
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		finally {}

		return getSepoaOut();
    }
 
    private int et_mty_setUpdate(String user_id, String[][] args, String change_date, String change_time, String house_code) throws Exception, DBOpenException { 
        int result = -1; 
        String[] settype = {"S","S","S","S","S","S","S","S","S","S"}; 
        ConnectionContext ctx = getConnectionContext(); 
 
        try { 
        	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("user_id", user_id);
			wxp.addVar("change_date", change_date);
			wxp.addVar("change_time", change_time);
			wxp.addVar("house_code", house_code);
            /*
			tSQL.append(" UPDATE ICOMCODE SET CHANGE_USER_ID = '"+user_id+"', "); 
            tSQL.append(" CHANGE_DATE = '"+change_date+"', CHANGE_TIME = '"+change_time+"', "); 
            tSQL.append(" USE_FLAG = ?, TEXT2 = ?, TEXT1 = ?, TEXT3 = ?, TEXT4 = ?, TEXT5 = ?, TEXT6 = ?, TEXT7 = ? "); 
            tSQL.append(" WHERE TYPE = ? AND CODE = ? AND HOUSE_CODE = '"+house_code+"' "); 
 			*/
            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
            result = sm.doUpdate(args,settype); 
            Commit(); 
        }catch(Exception e) { 
            Rollback(); 
            throw new Exception("et_mty_setUpdate: " + e.getMessage()); 
        } 
        return result; 
    }
    
    private boolean chkUseCount(String user_id, String code, String house_code) throws Exception{ 
    	ConnectionContext   ctx     = getConnectionContext();
    	SepoaXmlParser      wxp     = new SepoaXmlParser(this, "chkUseCount");
    	SepoaSQLManager     sm      = new SepoaSQLManager(user_id, this, ctx, wxp);
    	SepoaFormater       wf      = null; 
    	String              str     = null;
    	String              count   = null;
    	Map<String, String> dbParam = new HashMap<String, String>();
    	boolean             result  = false; 
        
        try{ 
        	dbParam.put("HOUSE_CODE", house_code);
        	dbParam.put("CODE",       code);
        	
        	str = sm.doSelect(dbParam);
        	
        	if(str == null){
            	throw new Exception("SQLManager is null"); 
            }
            
    		wf = new SepoaFormater(str);
    		
    		count = wf.getValue("cnt", 0);
            
            if(Integer.parseInt(count) == 0 ){
            	result = true;
            }
        }
        catch(Exception ex) { 
            throw new Exception("chkUseCount()" + ex.getMessage()); 
        }
        
        return result; 
    }
    
    private boolean chkUseCount2(String user_id, String code, String house_code) throws Exception{ 
    	ConnectionContext   ctx     = getConnectionContext();
    	SepoaXmlParser      wxp     = new SepoaXmlParser(this, "chkUseCount2");
    	SepoaSQLManager     sm      = new SepoaSQLManager(user_id, this, ctx, wxp);
    	SepoaFormater       wf      = null; 
    	String              str     = null;
    	String              count   = null;
    	Map<String, String> dbParam = new HashMap<String, String>();
    	boolean             result  = false; 
        
        try{ 
        	dbParam.put("HOUSE_CODE", house_code);
        	dbParam.put("CODE",       code);
        	
        	str = sm.doSelect(dbParam);
        	
        	if(str == null){
            	throw new Exception("SQLManager is null"); 
            }
            
    		wf = new SepoaFormater(str);
    		
    		count = wf.getValue("cnt", 0);
            
            if(Integer.parseInt(count) == 0 ){
            	result = true;
            }
        }
        catch(Exception ex) { 
            throw new Exception("chkUseCount2()" + ex.getMessage()); 
        }
        
        return result; 
    }
    
    /* 선택 박스에 체크된 Row를 삭제한다. */ 
//    public SepoaOut mty_setDelete(String[][] args) { 
//        try { 
//            int rtn = -1; 
//            String user_id = info.getSession("ID"); 
//            String house_code = info.getSession("HOUSE_CODE");
//            rtn = et_mty_setDelete(user_id, args, house_code); 
//            setValue("deleteRow ==  " + rtn); 
//            setStatus(rtn); 
//        }catch(Exception e) { 
//            Logger.err.println(info.getSession("ID"), this, "Exception= " + e.getMessage()); 
//            setStatus(0); 
//            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */ 
//        } 
//        return getSepoaOut(); 
//    } 
    
    @SuppressWarnings("unchecked")
	public SepoaOut mty_setDelete(Map<String, Object> param) throws Exception{ 
    	ConnectionContext         ctx          = null;
        SepoaXmlParser            sxp          = null;
		SepoaSQLManager           ssm          = null;
		List<Map<String, String>> grid         = null;
		Map<String, String>       gridInfo     = null;
		String                    id           = info.getSession("ID");
		String                    houseCode    = info.getSession("HOUSE_CODE");
		String                    code         = null;
		boolean                   chkCodeCount = false;
		boolean                   chkUseCount = false;
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			grid = (List<Map<String, String>>)param.get("gridData");
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo     = grid.get(i);
				code         = gridInfo.get("CODE");
				chkCodeCount = this.chkCodeCount(id, code, houseCode);
				
				chkUseCount = this.chkUseCount(id, code, houseCode);
				
				if(chkUseCount == false){
					throw new Exception("사용중인 코드 입니다.");
				}
				
				if(chkCodeCount == false){
					throw new Exception("하위코드가 존재합니다.");
				}

				sxp = new SepoaXmlParser(this, "et_mty_setDelete");
                ssm = new SepoaSQLManager(id, this, ctx, sxp);
                
                ssm.doUpdate(gridInfo);
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		finally {}

		return getSepoaOut();
    }
 
    private int et_mty_setDelete(String user_id, String[][] args, String house_code) throws Exception, DBOpenException { 
        int rtn = -1; 
        String[] settype = {"S","S"};  /*SQL 문의 ?의 타입이다.*/ 
        ConnectionContext ctx = getConnectionContext(); 
        try{ 
        	//하위코드가 있는지를 조회한다.        	
        	if(chkCodeCount(user_id, args[0][1], house_code)){
        		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
    			wxp.addVar("house_code", house_code);
    			/*
                tSQL.append(" DELETE FROM ICOMCODE "); 
                tSQL.append(" WHERE TYPE = ? AND CODE = ? AND HOUSE_CODE = '"+house_code+"' "); 
     			*/
                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                rtn = sm.doDelete(args,settype); 
                Commit();	
        	}else{
        		rtn = -9999;
        	}
        }catch(Exception e) { 
            Rollback(); 
            Logger.err.println(info.getSession("ID"), this, "Exception="+e.getMessage()); 
        } 
        return rtn; 
    }
    
    private boolean chkCodeCount(String user_id, String code, String house_code) throws Exception{ 
    	ConnectionContext   ctx     = getConnectionContext();
    	SepoaXmlParser      wxp     = new SepoaXmlParser(this, "chkCodeCount");
    	SepoaSQLManager     sm      = new SepoaSQLManager(user_id, this, ctx, wxp);
    	SepoaFormater       wf      = null; 
    	String              str     = null;
    	String              count   = null;
    	Map<String, String> dbParam = new HashMap<String, String>();
    	boolean             result  = false; 
        
        try{ 
        	dbParam.put("HOUSE_CODE", house_code);
        	dbParam.put("CODE",       code);
        	
        	str = sm.doSelect(dbParam);
        	
        	if(str == null){
            	throw new Exception("SQLManager is null"); 
            }
            
    		wf = new SepoaFormater(str);
    		
    		count = wf.getValue("cnt", 0);
            
            if(Integer.parseInt(count) == 0 ){
            	result = true;
            }
        }
        catch(Exception ex) { 
            throw new Exception("chkCodeCount()" + ex.getMessage()); 
        }
        
        return result; 
    }
    
    /* 처음에 maintain 화면 뜨면서 데이타를 가져와서 보여준다. */ 
//    public SepoaOut mct_getMaintain(String[] args) { 
//        String user_id = info.getSession("ID"); 
//        String house_code = info.getSession("HOUSE_CODE"); 
// 
//        try { 
//            String rtn = null; 
//            rtn = et_mct_getMaintain(user_id, args, house_code); 
//            setValue(rtn); 
//            setStatus(1); 
//            setMessage(msg.getMessage("0000")); 
//        }catch(Exception e){ 
//            System.out.println("Eception e = " + e.getMessage()); 
//            setStatus(0); 
//            setMessage(msg.getMessage("0001")); 
//            Logger.err.println(info.getSession("ID"), this, e.getMessage()); 
//        } 
//        return getSepoaOut(); 
//    } 
    
    public SepoaOut mct_getMaintain(Map<String, String> param) { 
    	ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "et_mct_getMaintain");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			rtn    = ssm.doSelect(param); // 조회
			
			setValue(rtn);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		
		return getSepoaOut();
    }
 
    public String et_mct_getMaintain(String user_id, String[] args, String house_code) throws Exception { 
        String result = null; 
        ConnectionContext ctx = getConnectionContext(); 
        try { 
        	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
                /*
				sql.append(" SELECT														\n "); 
                sql.append("    	 USE_FLAG                           				\n ");
                sql.append("    	,TEXT3                            					\n "); 
                sql.append(" 		,CODE                               				\n "); 
                sql.append(" 		,TEXT2                               				\n "); 
                sql.append(" 		,TEXT1                               				\n "); 
                sql.append(" 		,TEXT4                               				\n "); 
                sql.append(" 		,TEXT5                               				\n "); 
                sql.append(" 		,dbo.GETICOMCODE1('100','M051',TEXT5) AS STA_NAME  		\n "); 
                sql.append(" 		,TEXT6                               				\n "); 
                sql.append(" 		,TEXT7                               				\n "); 
                sql.append(" FROM ICOMCODE                                 				\n "); 
                sql.append(" <OPT=F,S>WHERE TYPE = ? </OPT>                 			\n "); 
                sql.append(" AND HOUSE_CODE = '"+house_code+"'              			\n "); 
                //sql.append(" and use_flag = 'Y'                           			\n "); 
                sql.append(" AND STATUS != 'D'                              			\n "); 
 				*/
                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                result = sm.doSelect(args); 
                if(result == null) throw new Exception("SQLManager is null"); 
        }catch(Exception ex) { 
            throw new Exception("et_mct_getMaintain()"+ ex.getMessage()); 
        } 
        return result; 
    } 
    
    /* Jtable에다 Change하구... save 버튼을 누르면.. DB에 들어간다..   */ 
//    public SepoaOut mct_setUpdate(String[][] args) { 
//        int rtn = -1; 
//        String user_id = info.getSession("ID"); 
//        String house_code = info.getSession("HOUSE_CODE"); 
//        String change_date = SepoaDate.getShortDateString(); 
//        String change_time = SepoaDate.getShortTimeString(); 
// 
//        try { 
//            rtn = et_mct_setUpdate(user_id, args, change_date, change_time, house_code); 
//            setValue("Change_Row=" + rtn); 
//            setStatus(1); 
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */ 
//        }catch(Exception e) { 
//            System.out.println("Exception= " + e.getMessage()); 
//            setStatus(0); 
//            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */ 
//        } 
//        return getSepoaOut(); 
//    }
    
    @SuppressWarnings("unchecked")
	public SepoaOut mct_setUpdate(Map<String, String> param) throws Exception { 
    	ConnectionContext         ctx      = null;
        SepoaXmlParser            sxp      = null;
		SepoaSQLManager           ssm      = null;
		List<Map<String, String>> grid     = null;
		Map<String, String>       gridInfo = null;
		String                    id       = info.getSession("ID");
		String                    houseCode    = info.getSession("HOUSE_CODE");
		String                    code         = null;
		String                    text         = null;
		boolean                  chkUseCount = false;
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			grid = (List<Map<String, String>>)MapUtils.getObject(param, "gridData");
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
				code         = gridInfo.get("CODE");
				text         = gridInfo.get("TEXT2");
				chkUseCount = this.chkUseCount2(id, code, houseCode);				
				
				if(chkUseCount == false){
					throw new Exception("사용중인 코드 입니다. [" + text + "]");
				}
				else{
					sxp = new SepoaXmlParser(this, "et_mct_setUpdate");
	                ssm = new SepoaSQLManager(id, this, ctx, sxp);
	                
	                ssm.doUpdate(gridInfo);
				}
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		finally {}

		return getSepoaOut();
    } 
 
    private int et_mct_setUpdate(String user_id, String[][] args, String change_date, String change_time, String house_code) throws Exception, DBOpenException { 
        int result = -1; 
        String[] settype = {"S","S","S","S","S","S","S","S","S","S"}; 
        ConnectionContext ctx = getConnectionContext(); 
 
        try { 
        	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("user_id", user_id);
			wxp.addVar("change_date", change_date);
			wxp.addVar("change_time", change_time);
			wxp.addVar("house_code", house_code);
			/*
            tSQL.append(" UPDATE ICOMCODE SET CHANGE_USER_ID = '"+user_id+"', "); 
            tSQL.append(" CHANGE_DATE = '"+change_date+"', CHANGE_TIME = '"+change_time+"', "); 
            tSQL.append(" TEXT2 = ?, TEXT1 = ?, TEXT4 = ?, TEXT5 = ?, TEXT6 = ?, TEXT7 = ?, USE_FLAG = ? "); 
            tSQL.append(" WHERE TYPE = ? AND CODE = ? "); 
            tSQL.append(" AND TEXT3 = ? AND HOUSE_CODE = '"+house_code+"' "); 
 			*/
            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
            result = sm.doUpdate(args,settype); 
            Commit(); 
        }catch(Exception e) { 
            Rollback(); 
            throw new Exception("et_mct_setUpdate: " + e.getMessage()); 
        } 
        return result; 
    }
    
    /*******************************품목 CLASS*****************************************/ 
//    public SepoaOut mcl_getMainternace(String[] args) { 
//     
//            String user_id = info.getSession("ID"); 
//            String house_code = info.getSession("HOUSE_CODE"); 
//     
//            try { 
//                String rtn = null; 
//                rtn = et_mcl_getMainternace(user_id,args,house_code); 
//                setValue(rtn); 
//                setStatus(1); 
//                setMessage(msg.getMessage("0000")); 
//            }catch(Exception e){ 
//                System.out.println("Eception e = " + e.getMessage()); 
//                setStatus(0); 
//                setMessage(msg.getMessage("0001")); 
//                Logger.err.println(info.getSession("ID"), this, e.getMessage()); 
//            } 
//            return getSepoaOut(); 
//        } 
    
    public SepoaOut mcl_getMainternace(Map<String, String> param) { 
    	ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "et_mcl_getMainternace");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			rtn = ssm.doSelect(param); // 조회
			
			setValue(rtn);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		
		return getSepoaOut();
    } 
     
        public String et_mcl_getMainternace(String user_id, String[] args, String house_code) throws Exception { 
            String result = null; 
            ConnectionContext ctx = getConnectionContext(); 
            try { 
            	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
    			wxp.addVar("house_code", house_code); 
                /*
    			sql.append(" SELECT USE_FLAG, TEXT3, TEXT4, CODE, TEXT1, TEXT2, TEXT5, TEXT6, TEXT7 \n "); 
                sql.append(" FROM ICOMCODE                                     \n "); 
                sql.append(" <OPT=F,S> WHERE TEXT3  = ? </OPT>                 \n "); 
                sql.append(" <OPT=F,S> AND TEXT4  = ? </OPT>                   \n "); 
                sql.append(" AND HOUSE_CODE = '"+house_code +"'                \n "); 
                sql.append(" <OPT=F,S> AND TYPE = ? </OPT>                     \n ");   //M042 
                //sql.append(" and use_flag = 'Y'                              \n "); 
                sql.append(" AND STATUS != 'D'                                 \n "); 
     			*/
                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                result = sm.doSelect(args); 
                if(result == null) throw new Exception("SQLManager is null"); 
            }catch(Exception ex) { 
                throw new Exception("et_mcl_getMainternace()"+ ex.getMessage()); 
            } 
            return result; 
        } 
        
        
        /* Jtable에다 Change하구... save 버튼을 누르면.. DB에 들어간다..   */ 
//        public SepoaOut mcl_setUpdate(String[][] args) { 
//            int rtn = -1; 
//            String status = "R"; 
//            String user_id = info.getSession("ID"); 
//            String house_code = info.getSession("HOUSE_CODE"); 
//            String change_date = SepoaDate.getShortDateString(); 
//            String change_time = SepoaDate.getShortTimeString(); 
//     
//            try { 
//                rtn = et_mcl_setUpdate(user_id, args, status, change_date, change_time, house_code); 
//                setValue("Change_Row=" + rtn); 
//                setStatus(1); 
//                setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */ 
//            }catch(Exception e) { 
//                setStatus(0); 
//                setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */ 
//            } 
//            return getSepoaOut(); 
//        } 
        
        @SuppressWarnings("unchecked")
		public SepoaOut mcl_setUpdate(Map<String, String> args) throws Exception{ 
        	ConnectionContext         ctx      = null;
            SepoaXmlParser            sxp      = null;
    		SepoaSQLManager           ssm      = null;
    		List<Map<String, String>> grid     = null;
    		Map<String, String>       gridInfo = null;
    		String                    id       = info.getSession("ID");
            
        	setStatus(1);
    		setFlag(true);
    		
    		ctx = getConnectionContext();
    		
    		try {
    			grid = (List<Map<String, String>>)MapUtils.getObject(args, "gridData");
    			
    			for(int i = 0; i < grid.size(); i++) {
    				gridInfo = grid.get(i);
    				
                    sxp = new SepoaXmlParser(this, "et_mcl_setUpdate");
                    ssm = new SepoaSQLManager(id, this, ctx, sxp);
                    
                    gridInfo.put("HOUSE_CODE",   info.getSession("HOUSE_CODE"));
                    gridInfo.put("USER_ID",      info.getSession("ID"));
                    gridInfo.put("COMPANY_CODE", info.getSession("COMPANY_CODE"));
                    
                    ssm.doUpdate(gridInfo);
                }
    			
    			Commit();
    		}
    		catch(Exception e){
    			Rollback();
    			setStatus(0);
    			setFlag(false);
    			setMessage(e.getMessage());
    			Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		}
    		finally {}

    		return getSepoaOut();
        }
     
        private int et_mcl_setUpdate(String user_id, String[][] args, String status, String change_date, String change_time, String house_code) throws Exception, DBOpenException { 
            int result = -1; 
            String[] settype = {"S","S","S","S","S","S","S","S","S","S"}; 
            ConnectionContext ctx = getConnectionContext(); 
     
            try { 
            	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
            	wxp.addVar("user_id", user_id);
            	wxp.addVar("change_date", change_date);
            	wxp.addVar("change_time", change_time);
            	wxp.addVar("status", status);
            	wxp.addVar("house_code", house_code);
    			/*
                tSQL.append(" UPDATE ICOMCODE SET CHANGE_USER_ID = '"+user_id+"', CHANGE_DATE = '"+change_date+"', "); 
                tSQL.append(" CHANGE_TIME = '"+change_time+"', STATUS = '"+status+"', "); 
                tSQL.append(" USE_FLAG = ?, TEXT3 = ?, TEXT4 = ?, TEXT1 = ?, TEXT2 =?, TEXT5 = ?, TEXT6 = ?, TEXT7 = ?"); 
                tSQL.append(" WHERE TYPE = ? AND HOUSE_CODE = '"+house_code+"' "+" AND CODE = ? " ); 
    			 */
                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                result = sm.doUpdate(args,settype); 
                Commit(); 
            }catch(Exception e) { 
                Rollback(); 
                throw new Exception("et_mcl_setUpdate: " + e.getMessage()); 
            } 
            return result; 
        } 
        
        /*새로 생성한 데이타가 기존에 있는 데이타인지 체크해준다.(item_class) */ 
//        public SepoaOut mty_checkItem(String[] args) { 
//            String user_id = info.getSession("ID"); 
//            String house_code = info.getSession("HOUSE_CODE"); 
//     
//            try { 
//                String rtn = null; 
//                rtn = et_mty_checkItem(user_id,args,house_code); 
//                setValue(rtn); 
//                setStatus(1); 
//                setMessage(msg.getMessage("0000")); 
//            }catch(Exception e){ 
//                System.out.println("Eception e = " + e.getMessage()); 
//                setStatus(0); 
//                setMessage(msg.getMessage("0001")); 
//                Logger.err.println(info.getSession("ID"), this, e.getMessage()); 
//            } 
//            return getSepoaOut(); 
//        } 
        
        public SepoaOut mty_checkItem(Map<String, String> param) throws Exception{ 
        	ConnectionContext ctx = null;
    		SepoaXmlParser    sxp = null;
    		SepoaSQLManager   ssm = null;
    		String            rtn = null;
    		String            id  = info.getSession("ID");
    		
    		try{
    			setStatus(1);
    			setFlag(true);
    			
    			ctx = getConnectionContext();
    			
    			sxp = new SepoaXmlParser(this, "et_mty_checkItem");
    			ssm = new SepoaSQLManager(id, this, ctx, sxp);
    			
    			rtn = ssm.doSelect(param); // 조회
    			
    			setValue(rtn);
    			setMessage(msg.getMessage("0000"));
    		}
    		catch(Exception e) {
    			Logger.err.println(userid, this, e.getMessage());
    			setStatus(0);
    			setMessage(msg.getMessage("0001"));
    		}
    		
    		return getSepoaOut();
        }
     
        public String et_mty_checkItem(String user_id, String[] args, String house_code) throws Exception { 
     
            String result = null; 
     
            try { 
                ConnectionContext ctx = getConnectionContext(); 
     
                SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
    			wxp.addVar("house_code", house_code);
    			/*
                sql.append(" select count(*) "); 
                sql.append(" from icomcode "); 
                sql.append(" where house_code = '"+house_code +"' "); 
                sql.append(" <OPT=F,S> and type = ? </OPT> "); 
                sql.append(" and status != 'D' "); 
                sql.append(" <OPT=F,S> and code  = ? </OPT> "); 
     			*/
                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                result = sm.doSelect(args); 
                if(result == null) throw new Exception("SQLManager is null"); 
            }catch(Exception ex) { 
                throw new Exception("et_mty_checkItem()"+ ex.getMessage()); 
            } 
            return result; 
        } 
        
        
        /* 생성버튼을 누르면 테이블에 입력했던 값들을 DB에 넣어준다. */ 
//        public SepoaOut mty_setInsert(String[][] args) { 
//            int rtn = -1; 
//     
//            try { 
//     
//                String user_id = info.getSession("ID"); 
//                String house_code = info.getSession("HOUSE_CODE"); 
//                String add_date = SepoaDate.getShortDateString(); 
//                String add_time = SepoaDate.getShortTimeString(); 
//     
//                rtn = et_mty_setInsert(args, user_id, add_date, add_time, house_code); 
//                setValue("insertRow ==  " + rtn); 
//                setStatus(1); 
//                setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */ 
//            }catch(Exception e) { 
//                Logger.err.println(info.getSession("ID"), this, "Exception= " + e.getMessage()); 
//                setStatus(0); 
//                setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */ 
//            } 
//            return getSepoaOut(); 
//        } 
        
        
        
        @SuppressWarnings("unchecked")
		public SepoaOut mty_setInsert(Map<String, Object> param) throws Exception{ 
        	ConnectionContext         ctx      = null;
            SepoaXmlParser            sxp      = null;
    		SepoaSQLManager           ssm      = null;
    		List<Map<String, String>> grid     = (List<Map<String, String>>)param.get("gridData");
    		Map<String, String>       gridInfo = null;
    		String                    id       = info.getSession("ID");
            
        	setStatus(1);
    		setFlag(true);
    		
    		ctx = getConnectionContext();
    		
    		try {
    			for(int i = 0; i < grid.size(); i++) {
    				gridInfo = grid.get(i);
    				
                    sxp = new SepoaXmlParser(this, "et_mty_setInsert");
                    ssm = new SepoaSQLManager(id, this, ctx, sxp);
                    
                    ssm.doInsert(gridInfo);
                }
    			
    			Commit();
    		}
    		catch(Exception e){
    			Rollback();
    			setStatus(0);
    			setFlag(false);
    			setMessage(e.getMessage());
    			Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		}
    		finally {}

    		return getSepoaOut(); 
        }
     
        private int et_mty_setInsert(String[][] args, String user_id, String add_date, String add_time, String house_code) throws Exception, DBOpenException { 
            int result =-1; 
            String[] settype={"S","S","S","S","S","S","S","S","S","S"}; 
            ConnectionContext ctx = getConnectionContext(); 
     
            try { 
            	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
    			wxp.addVar("user_id", user_id);
    			wxp.addVar("add_date", add_date);
    			wxp.addVar("add_time", add_time);
    			wxp.addVar("house_code", house_code);
    			/*
                tSQL.append(" INSERT INTO ICOMCODE ("); 
                tSQL.append(" CODE, STATUS, TEXT2, TEXT1,TEXT3,TEXT4,TEXT5,TEXT6,TEXT7, USE_FLAG, TYPE, ADD_USER_ID, ADD_DATE, ADD_TIME, "); 
                tSQL.append(" CHANGE_USER_ID, CHANGE_DATE, CHANGE_TIME, HOUSE_CODE) "); 
                tSQL.append(" VALUES(?, 'C', ?, ?, ?, ?, ?, ?, ?, ?, ?,'"+user_id+"', '"+add_date+"', '"+add_time+"', "); 
                tSQL.append(" '"+user_id+"', '"+add_date+"', '"+add_time+"', '"+house_code+"') "); 
     			*/
                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                result = sm.doInsert(args,settype); 
                Commit(); 
            }catch(Exception e) { 
                Rollback(); 
                throw new Exception("et_mty_setInsert: " + e.getMessage()); 
            } 
            return result; 
        }
        
        
        /* 하위 코드가 있는지 조회해본다.*/ 
        public SepoaOut getCount(String[] args) { 
            String user_id = info.getSession("ID"); 
            String house_code = info.getSession("HOUSE_CODE"); 
     
            try { 
                String rtn = null; 
                rtn = et_getCount(user_id, args, house_code); 
                setValue(rtn); 
                setStatus(1); 
                setMessage(msg.getMessage("0000")); 
            }catch(Exception e){ 
                 
                setStatus(0); 
                setMessage(msg.getMessage("0001")); 
                Logger.err.println(info.getSession("ID"), this, e.getMessage()); 
            } 
            return getSepoaOut(); 
        } 
     
        public String et_getCount(String user_id, String[] args, String house_code) throws Exception { 
            String result = null; 
            ConnectionContext ctx = getConnectionContext(); 
            try { 
            	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
    			wxp.addVar("house_code", house_code);
    			/*	
                    sql.append(" select count(*) from icomcode "); 
                    sql.append(" where house_code = '"+house_code+"' "); 
                    sql.append(" <OPT=F,S> and type = ? </OPT> "); 
                    sql.append(" <OPT=F,S> and text3 = ? </OPT> "); 
                    sql.append(" <OPT=S,S> and text4 = ? </OPT> "); 
     			*/
                 SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                 result = sm.doSelect(args); 
                 if(result == null) throw new Exception("SQLManager is null"); 
            }catch(Exception ex) { 
                throw new Exception("et_getCount()"+ ex.getMessage()); 
            } 
            return result; 
        }
        
        
//        public SepoaOut mct_checkItem(String[] args) { 
//            String user_id = info.getSession("ID"); 
//            String house_code = info.getSession("HOUSE_CODE"); 
//     
//            try { 
//                String rtn = null; 
//                rtn = et_mct_checkItem(user_id,args,house_code); 
//                setValue(rtn); 
//                setStatus(1); 
//                setMessage(msg.getMessage("0000")); 
//            }catch(Exception e){ 
//                System.out.println("Eception e = " + e.getMessage()); 
//                setStatus(0); 
//                setMessage(msg.getMessage("0001")); 
//                Logger.err.println(info.getSession("ID"), this, e.getMessage()); 
//            } 
//            return getSepoaOut(); 
//        }
        
        public SepoaOut mct_checkItem(Map<String, String> args) { 
        	ConnectionContext ctx = null;
    		SepoaXmlParser    sxp = null;
    		SepoaSQLManager   ssm = null;
    		String            rtn = null;
    		String            id  = info.getSession("ID");
    		
    		try{
    			setStatus(1);
    			setFlag(true);
    			
    			ctx = getConnectionContext();
    			
    			sxp = new SepoaXmlParser(this, "et_mct_checkItem");
    			ssm = new SepoaSQLManager(id, this, ctx, sxp);
    			
    			rtn = ssm.doSelect(args); // 조회
    			
    			setValue(rtn);
    			setMessage(msg.getMessage("0000"));
    		}
    		catch(Exception e) {
    			Logger.err.println(userid, this, e.getMessage());
    			setStatus(0);
    			setMessage(msg.getMessage("0001"));
    		}
    		
    		return getSepoaOut();
        } 
     
        public String et_mct_checkItem(String user_id, String[] args, String house_code) throws Exception { 
            String result = null; 
            ConnectionContext ctx = getConnectionContext(); 
            try { 
            	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
    			wxp.addVar("house_code", house_code);
    			/*
                    sql.append(" SELECT ISNULL(TEXT3,'X') ");
                    sql.append(" FROM ICOMCODE "); 
                    sql.append(" WHERE HOUSE_CODE = '"+house_code +"' "); 
                    sql.append(" <OPT=F,S> AND TYPE = ? </OPT> "); 
                    sql.append(" AND STATUS != 'D' "); 
                    sql.append(" <OPT=F,S> AND CODE  = ? </OPT> "); 
     			*/
                    SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                    result = sm.doSelect(args); 
                    if(result == null) throw new Exception("SQLManager is null"); 
            }catch(Exception ex) { 
                throw new Exception("et_mct_checkItem()"+ ex.getMessage()); 
            } 
            return result; 
        }
        
        
        /* 생성버튼을 누르면 테이블에 입력했던 값들을 DB에 넣어준다. */ 
//        public SepoaOut mct_setInsert(String[][] args) { 
//            int rtn = -1; 
//            String user_id = info.getSession("ID"); 
//            String house_code = info.getSession("HOUSE_CODE"); 
//            String add_date = SepoaDate.getShortDateString(); 
//            String add_time = SepoaDate.getShortTimeString(); 
//     
//            try { 
//                rtn = et_mct_setInsert(args, user_id, add_date, add_time, house_code); 
//                setValue("insertRow ==  " + rtn); 
//                setStatus(1); 
//                setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */ 
//            }catch(Exception e) { 
//                System.out.println("Exception= " + e.getMessage()); 
//                setStatus(0); 
//                setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */ 
//            } 
//            return getSepoaOut(); 
//        }
        
        @SuppressWarnings("unchecked")
		public SepoaOut mct_setInsert(Map<String, Object> param) throws Exception { 
        	ConnectionContext         ctx      = null;
            SepoaXmlParser            sxp      = null;
    		SepoaSQLManager           ssm      = null;
    		List<Map<String, String>> grid     = null;
    		Map<String, String>       gridInfo = null;
    		String                    id       = info.getSession("ID");
            
        	setStatus(1);
    		setFlag(true);
    		
    		ctx = getConnectionContext();
    		
    		try {
    			grid = (List<Map<String, String>>)MapUtils.getObject(param, "gridData");
    			
    			for(int i = 0; i < grid.size(); i++) {
    				gridInfo = grid.get(i);
    				
                    sxp = new SepoaXmlParser(this, "et_mct_setInsert");
                    ssm = new SepoaSQLManager(id, this, ctx, sxp);
                    
                    ssm.doInsert(gridInfo);
                }
    			
    			Commit();
    		}
    		catch(Exception e){
    			Rollback();
    			setStatus(0);
    			setFlag(false);
    			setMessage(e.getMessage());
    			Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		}
    		finally {}

    		return getSepoaOut();
        } 
     
        private int et_mct_setInsert(String[][] args, String user_id, String add_date, String add_time, String house_code) throws Exception, DBOpenException { 
            int result =-1; 
            String[] settype={"S","S","S","S","S","S","S","S","S","S"}; 
            ConnectionContext ctx = getConnectionContext(); 
     
            try { 
            	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
    			wxp.addVar("user_id", user_id);
    			wxp.addVar("add_date", add_date);
    			wxp.addVar("add_time", add_time);
    			wxp.addVar("house_code", house_code);
    			/*
                tSQL.append(" INSERT INTO ICOMCODE ("); 
                tSQL.append(" TEXT3, CODE, STATUS, TEXT2, TEXT1, TEXT4, TEXT5, TEXT6, TEXT7, USE_FLAG, TYPE, ADD_USER_ID, ADD_DATE, ADD_TIME, "); 
                tSQL.append(" CHANGE_USER_ID, CHANGE_DATE, CHANGE_TIME, HOUSE_CODE) "); 
                tSQL.append(" VALUES(?, ?,'C', ?, ?, ?, ?, ?, ?, ?, ?,'"+user_id+"', '"+add_date+"', '"+add_time+"', "); 
                tSQL.append(" '"+user_id+"', '"+add_date+"', '"+add_time+"', '"+house_code+"') "); 
     			*/
                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                result = sm.doInsert(args,settype); 
                Commit(); 
            }catch(Exception e) { 
                Rollback(); 
                throw new Exception("et_mct_setInsert: " + e.getMessage()); 
            } 
            return result; 
        }
        
        
        /* 선택 박스에 체크된 Row를 삭제한다. */ 
//        public SepoaOut mct_setDelete(String[][] args) { 
//            try { 
//                int rtn = -1; 
//                String user_id = info.getSession("ID"); 
//                String house_code = info.getSession("HOUSE_CODE"); 
//                rtn = et_mct_setDelete(user_id, args, house_code); 
//                
//                setValue("deleteRow ==  " + rtn); 
//                setStatus(rtn);
//                 
//            }catch(Exception e) { 
//                System.out.println("Exception= " + e.getMessage()); 
//                setStatus(0); 
//                setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */ 
//            } 
//            return getSepoaOut(); 
//        }
        
        @SuppressWarnings("unchecked")
		public SepoaOut mct_setDelete(Map<String, Object> param) throws Exception { 
        	ConnectionContext         ctx              = null;
            SepoaXmlParser            sxp              = null;
    		SepoaSQLManager           ssm              = null;
    		List<Map<String, String>> grid             = null;
    		Map<String, String>       gridInfo         = null;
    		String                    id               = info.getSession("ID");
    		String                    code             = null;
    		String                    houseCode        = info.getSession("HOUSE_CODE");
    		boolean                   isCheckCodeCount = false;
    		boolean                  chkUseCount = false;
            
    		
    		
        	setStatus(1);
    		setFlag(true);
    		
    		ctx = getConnectionContext();
    		
    		try {
    			grid = (List<Map<String, String>>)MapUtils.getObject(param, "gridData");
    			
    			for(int i = 0; i < grid.size(); i++) {
    				gridInfo = grid.get(i);
    				code     = gridInfo.get("CODE");
    				
    				chkUseCount = this.chkUseCount2(id, code, houseCode);
    				if(chkUseCount == false){
    					throw new Exception("사용중인 코드 입니다.");
    				}
    				
    				isCheckCodeCount = this.chkCodeCount(id, code, houseCode);
    				if(isCheckCodeCount == false){
    					throw new Exception("하위코드가 존재합니다.");
    				}
    				
    				sxp = new SepoaXmlParser(this, "et_mct_setDelete");
                    ssm = new SepoaSQLManager(id, this, ctx, sxp);
                    
                    ssm.doUpdate(gridInfo);
                }
    			
    			Commit();
    		}
    		catch(Exception e){
    			Rollback();
    			setStatus(0);
    			setFlag(false);
    			setMessage(e.getMessage());
    			Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		}
    		finally {}

    		return getSepoaOut();
        } 
     
        private int et_mct_setDelete(String user_id, String[][] args, String house_code) throws Exception, DBOpenException { 
            int rtn = -1; 
            String[] settype = {"S","S","S"};  /*SQL 문의 ?의 타입이다.*/ 
            ConnectionContext ctx = getConnectionContext(); 
            try{ 
            	
            	if(chkCodeCount(user_id, args[0][1], house_code)){
            		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
        			wxp.addVar("house_code", house_code);
        			/*
                    tSQL.append(" DELETE FROM ICOMCODE "); 
                    tSQL.append(" WHERE TYPE = ? AND CODE = ? "); 
                    tSQL.append(" AND TEXT3 = ? AND HOUSE_CODE = '"+house_code+"' "); 
         			*/
                    SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                    rtn = sm.doDelete(args,settype); 
                    Commit();	
            	}else{
            		rtn = -9999;
            	}
            	 
            }catch(Exception e) { 
                Rollback(); 
                Logger.err.println(info.getSession("ID"), this, "Exception="+e.getMessage()); 
            } 
            return rtn; 
        }
        
        
//        public SepoaOut getMaxClass(String type,String item_code) { 
//            String user_id = info.getSession("ID"); 
//            String house_code = info.getSession("HOUSE_CODE"); 
//            String company_code = info.getSession("COMPANY_CODE"); 
//             
//            try { 
//                String rtn = null; 
//                rtn = et_getMaxClass(house_code, user_id, type,item_code); 
//                setValue(rtn); 
//                setStatus(1); 
//                setMessage(msg.getMessage("0000")); 
//            }catch(Exception e){ 
//                System.out.println("Eception e = " + e.getMessage()); 
//                setStatus(0); 
//                setMessage(msg.getMessage("0001")); 
//                Logger.err.println(info.getSession("ID"), this, e.getMessage()); 
//            } 
//             
//            return getSepoaOut(); 
//        } 
        
        public SepoaOut getMaxClass(Map<String, String> param) { 
        	ConnectionContext ctx = null;
    		SepoaXmlParser    sxp = null;
    		SepoaSQLManager   ssm = null;
    		String            rtn = null;
    		String            id  = info.getSession("ID");
    		
    		try{
    			setStatus(1);
    			setFlag(true);
    			
    			ctx = getConnectionContext();
    			
    			sxp = new SepoaXmlParser(this, "et_getMaxClass");
    			ssm = new SepoaSQLManager(id, this, ctx, sxp);
    			
    			rtn = ssm.doSelect(param); // 조회
    			
    			setValue(rtn);
    			setMessage(msg.getMessage("0000"));
    		}
    		catch(Exception e) {
    			Logger.err.println(userid, this, e.getMessage());
    			setStatus(0);
    			setMessage(msg.getMessage("0001"));
    		}
    		
    		return getSepoaOut();
        }
         
        private String et_getMaxClass(String house_code, String user_id, String type, String item_code)  
        	throws Exception { 
            String result = null; 
            ConnectionContext ctx = getConnectionContext(); 
             
            try { 

            	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
            	wxp.addVar("getConfig", getConfig("Sepoa.generator.db.selfuser"));
            	wxp.addVar("house_code", house_code);
            	wxp.addVar("type", type);
            	wxp.addVar("item_code", item_code);
            	wxp.addVar("item_length", item_code.length());
            	
            	/*
                    sql.append(" SELECT " +getConfig("Sepoa.generator.db.selfuser") +  "."+ "getCharSeq(MAX(CONVERT(DECIMAL,ISNULL(CODE,'000'))) + 1,3) AS CLASS 	\n");  
     				sql.append("   FROM ICOMCODE																	\n"); 
    				sql.append("  WHERE HOUSE_CODE = '" + house_code + "'                  							\n");  
    				sql.append("    AND TYPE = '" + type + "'                                 						\n");  
                    sql.append("    AND STATUS != 'D'                                      							\n"); 
                */     
                    SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                    result = sm.doSelect((String[])null); 
                    if(result == null) throw new Exception("SQLManager is null"); 
            }catch(Exception ex) { 
                throw new Exception("et_getMaxClass()"+ ex.getMessage()); 
            } 
            return result; 
        }
        
        
        /*새로 생성한 데이타가 기존에 있는 데이타인지 체크해준다.(item_class) */ 
//        public SepoaOut mcl_checkItem(String[] args) { 
//                String user_id = info.getSession("ID"); 
//                String house_code = info.getSession("HOUSE_CODE"); 
//         
//                try { 
//                    String rtn = null; 
//                    rtn = et_mcl_checkItem(user_id,args,house_code); 
//                    setValue(rtn); 
//                    setStatus(1); 
//                    setMessage(msg.getMessage("0000")); 
//                }catch(Exception e){ 
//                    System.out.println("Eception e = " + e.getMessage()); 
//                    setStatus(0); 
//                    setMessage(msg.getMessage("0001")); 
//                    Logger.err.println(info.getSession("ID"), this, e.getMessage()); 
//                } 
//                return getSepoaOut(); 
//            }
        
        public SepoaOut mcl_checkItem(Map<String, String> args) { 
        	ConnectionContext ctx = null;
    		SepoaXmlParser    sxp = null;
    		SepoaSQLManager   ssm = null;
    		String            rtn = null;
    		String            id  = info.getSession("ID");
    		
    		try{
    			setStatus(1);
    			setFlag(true);
    			
    			ctx = getConnectionContext();
    			
    			sxp = new SepoaXmlParser(this, "et_mcl_checkItem");
    			ssm = new SepoaSQLManager(id, this, ctx, sxp);
    			
    			rtn = ssm.doSelect(args); // 조회
    			
    			setValue(rtn);
    			setMessage(msg.getMessage("0000"));
    		}
    		catch(Exception e) {
    			Logger.err.println(userid, this, e.getMessage());
    			setStatus(0);
    			setMessage(msg.getMessage("0001"));
    		}
    		
    		return getSepoaOut(); 
        } 
         
            public String et_mcl_checkItem(String user_id, String[] args, String house_code) throws Exception { 
                String result = null; 
                ConnectionContext ctx = getConnectionContext(); 
                try { 

                	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
                	wxp.addVar("house_code", house_code);
                    /*    
                	sql.append(" select ISNULL(TEXT3,'X'), ISNULL(TEXT4,'X') ");
                    sql.append(" FROM ICOMCODE "); 
                    sql.append(" WHERE HOUSE_CODE = '"+house_code +"' "); 
//                  sql.append(" AND TYPE = 'M042' "); 
                    sql.append(" <OPT=F,S> AND TYPE = ? </OPT> "); 
                    sql.append(" AND STATUS != 'D' "); 
                    sql.append(" <OPT=F,S> AND CODE  = ? </OPT> "); 
         			*/
                    SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                    result = sm.doSelect(args); 
                    if(result == null) throw new Exception("SQLManager is null"); 
                }catch(Exception ex) { 
                    throw new Exception("et_mcl_checkItem()"+ ex.getMessage()); 
                } 
                return result; 
            }
            
            
            /* 생성버튼을 누르면 테이블에 입력했던 값들을 DB에 넣어준다. */ 
//            public SepoaOut mcl_setInsert(String[][] args) { 
//                int rtn = -1; 
//                String status = "C"; 
//                String user_id = info.getSession("ID"); 
//                String house_code = info.getSession("HOUSE_CODE"); 
//                String add_date = SepoaDate.getShortDateString(); 
//                String add_time = SepoaDate.getShortTimeString(); 
//         
//                try { 
//                    rtn = et_mcl_setInsert(args, status, user_id, add_date, add_time, house_code); 
//                    setValue("insertRow ==  " + rtn); 
//                    setStatus(1); 
//                    setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */ 
//                }catch(Exception e) { 
//                    System.out.println("Exception= " + e.getMessage()); 
//                    setStatus(0); 
//                    setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */ 
//                } 
//                return getSepoaOut(); 
//            }  
            
            @SuppressWarnings("unchecked")
			public SepoaOut mcl_setInsert(Map<String, String> args) throws Exception { 
            	ConnectionContext         ctx      = null;
                SepoaXmlParser            sxp      = null;
        		SepoaSQLManager           ssm      = null;
        		List<Map<String, String>> grid     = null;
        		Map<String, String>       gridInfo = null;
        		String                    id       = info.getSession("ID");
                
            	setStatus(1);
        		setFlag(true);
        		
        		ctx = getConnectionContext();
        		
        		try {
        			grid = (List<Map<String, String>>)MapUtils.getObject(args, "gridData");
        			
        			for(int i = 0; i < grid.size(); i++) {
        				gridInfo = grid.get(i);
        				
                        sxp = new SepoaXmlParser(this, "et_mcl_setInsert");
                        ssm = new SepoaSQLManager(id, this, ctx, sxp);
                        
                        ssm.doUpdate(gridInfo);
                    }
        			
        			Commit();
        		}
        		catch(Exception e){
        			Rollback();
        			setStatus(0);
        			setFlag(false);
        			setMessage(e.getMessage());
        			Logger.err.println(info.getSession("ID"), this, e.getMessage());
        		}
        		finally {}

        		return getSepoaOut();
            }
         
            private int et_mcl_setInsert(String[][] args, String status, String user_id, String add_date, String add_time, String house_code) throws Exception, DBOpenException { 
                int result =-1; 
                String[] settype={"S","S","S","S","S","S","S","S","S","S"}; 
                ConnectionContext ctx = getConnectionContext(); 
         
                try { 

                	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
                	wxp.addVar("status", status);
                	wxp.addVar("user_id", user_id);
                	wxp.addVar("add_date", add_date);
                	wxp.addVar("add_time", add_time);
                	wxp.addVar("house_code", house_code);
                	
                	/*			
                    tSQL.append(" INSERT INTO ICOMCODE ("); 
                    tSQL.append(" TYPE, USE_FLAG,TEXT3, TEXT4, CODE, TEXT1, TEXT2, TEXT5, TEXT6, TEXT7, STATUS, ADD_USER_ID, "); 
                    tSQL.append(" ADD_DATE, ADD_TIME, CHANGE_USER_ID, CHANGE_DATE, CHANGE_TIME, HOUSE_CODE) "); 
                    tSQL.append(" VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, '"+status+"', '"+user_id+"', '"+add_date+"', "); 
//                    tSQL.append(" VALUES('M042', ?, ?, ?, ?, ?, ?,  '"+status+"', '"+user_id+"', '"+add_date+"', "); 
                    tSQL.append(" '"+add_time+"', '"+user_id+"', '"+add_date+"', '"+add_time+"', '"+house_code+"') "); 
         			*/
                    SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                    result = sm.doInsert(args,settype); 
                    Commit(); 
                }catch(Exception e) { 
                    Rollback(); 
                    throw new Exception("et_mcl_setInsert: " + e.getMessage()); 
                } 
                return result; 
            }
            
            
//            /* 선택 박스에 체크된 Row를 삭제한다. */ 
//            public SepoaOut mcl_setDelete(String[][] args) { 
//                try { 
//                    int rtn = -1; 
//                    String user_id = info.getSession("ID"); 
//                    String house_code = info.getSession("HOUSE_CODE"); 
//                    rtn = et_mcl_setDelete(user_id, args, house_code); 
//                    setValue("deleteRow ==  " + rtn); 
//                    setStatus(rtn); 
//                }catch(Exception e) { 
//                    System.out.println("Exception= " + e.getMessage()); 
//                    setStatus(0); 
//                    setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */ 
//                } 
//                return getSepoaOut(); 
//            } 
            
            @SuppressWarnings("unchecked")
			public SepoaOut mcl_setDelete(Map<String, Object> args) throws Exception { 
            	ConnectionContext         ctx          = null;
                SepoaXmlParser            sxp          = null;
        		SepoaSQLManager           ssm          = null;
        		List<Map<String, String>> grid         = null;
        		Map<String, String>       gridInfo     = null;
        		String                    id           = info.getSession("ID");
        		String                    houseCode    = info.getSession("HOUSE_CODE");
        		String                    code         = null;
        		boolean                   chkCodeCount = false;
                
            	setStatus(1);
        		setFlag(true);
        		
        		ctx = getConnectionContext();
        		
        		try {
        			grid = (List<Map<String, String>>)MapUtils.getObject(args, "gridData");
        			
        			for(int i = 0; i < grid.size(); i++) {
        				gridInfo     = grid.get(i);
        				code         = gridInfo.get("CODE");
        				chkCodeCount = this.chkCodeCount(id, code, houseCode);
        				
        				if(chkCodeCount){
        					sxp = new SepoaXmlParser(this, "et_mcl_setDelete");
                            ssm = new SepoaSQLManager(id, this, ctx, sxp);
                            
                            ssm.doUpdate(gridInfo);
        				}
        				else{
        					throw new Exception("하위코드가 존재합니다.");
        				}
                    }
        			
        			Commit();
        		}
        		catch(Exception e){
        			Rollback();
        			setStatus(0);
        			setFlag(false);
        			setMessage(e.getMessage());
        			Logger.err.println(info.getSession("ID"), this, e.getMessage());
        		}
        		finally {}

        		return getSepoaOut(); 
            }
         
            private int et_mcl_setDelete(String user_id, String[][] args, String house_code) throws Exception, DBOpenException { 
                int rtn = -1; 
                String[] settype = {"S","S"};  /*SQL 문의 ?의 타입이다.*/ 
                ConnectionContext ctx = getConnectionContext(); 
                try{ 
                	if(chkCodeCount(user_id, args[0][1], house_code)){
                		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
            			wxp.addVar("house_code", house_code);
            			
            			/*
                        tSQL.append(" DELETE FROM ICOMCODE "); 
//                        tSQL.append(" WHERE TYPE = 'M042' AND CODE = ? AND HOUSE_CODE = '"+house_code+"' "); 
                        tSQL.append(" WHERE TYPE = ? AND CODE = ? AND HOUSE_CODE = '"+house_code+"' "); 
             			*/
                        SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                        rtn = sm.doDelete(args,settype); 
                        Commit();	
                	}else{
                		rtn = -9999;
                	}
                }catch(Exception e) { 
                    Rollback(); 
                    Logger.err.println(info.getSession("ID"), this, "Exception="+e.getMessage()); 
                } 
                return rtn; 
            }
            
            /* 하위 코드가 있는지 조회해본다.*/ 
            public SepoaOut delClssCount(String[] args) { 
                String user_id = info.getSession("ID"); 
                String house_code = info.getSession("HOUSE_CODE"); 
         
                try { 
                    String rtn = null; 
                    rtn = et_delClssCount(user_id, args, house_code); 
                    setValue(rtn); 
                    setStatus(1); 
                    setMessage(msg.getMessage("0000")); 
                }catch(Exception e){ 
                     
                    setStatus(0); 
                    setMessage(msg.getMessage("0001")); 
                    Logger.err.println(info.getSession("ID"), this, e.getMessage()); 
                } 
                return getSepoaOut(); 
            } 
         
            public String et_delClssCount(String user_id, String[] args, String house_code) throws Exception { 
                String result = null; 
                ConnectionContext ctx = getConnectionContext(); 
                try { 
                	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
        			wxp.addVar("house_code", house_code);
        			/*
                        sql.append(" SELECT COUNT(*) FROM ICOMMCPM "); 
                        sql.append(" WHERE HOUSE_CODE = '"+house_code+"' "); 
                        sql.append(" <OPT=F,S> AND MATERIAL_CLASS1 = ? </OPT> "); 
         			*/
                        SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                        result = sm.doSelect(args); 
                        if(result == null) throw new Exception("SQLManager is null"); 
                }catch(Exception ex) { 
                    throw new Exception("et_delClssCount()"+ ex.getMessage()); 
                } 
                return result; 
            }
            
            /******************************Material_class와 구매지역 연결**********************************************/ 
            /* 품목에 대한 정보를 입력하면 그에 연결된 구매지역과 직무코드를 보여준다. */ 
//                public SepoaOut getPurArea(String[] args) { 
//                    String user_id = info.getSession("ID"); 
//             
//                    try { 
//                        String rtn = null; 
//                        rtn = et_getPurArea(user_id, args); 
//                        setValue(rtn); 
//                        setStatus(1); 
//                        setMessage(msg.getMessage("0000")); 
//                    }catch(Exception e){ 
//                        System.out.println("Eception e = " + e.getMessage()); 
//                        setStatus(0); 
//                        setMessage(msg.getMessage("0001")); 
//                        Logger.err.println(info.getSession("ID"), this, e.getMessage()); 
//                    } 
//                    return getSepoaOut(); 
//                }
                
                public SepoaOut getPurArea(Map<String, String> args) { 
                	ConnectionContext ctx = null;
            		SepoaXmlParser    sxp = null;
            		SepoaSQLManager   ssm = null;
            		String            rtn = null;
            		String            id  = info.getSession("ID");
            		
            		try{
            			setStatus(1);
            			setFlag(true);
            			
            			ctx = getConnectionContext();
            			
            			sxp = new SepoaXmlParser(this, "et_getPurArea");
            			ssm = new SepoaSQLManager(id, this, ctx, sxp);
            			
            			rtn    = ssm.doSelect(args); // 조회
            			
            			setValue(rtn);
            			setMessage(msg.getMessage("0000"));
            		}
            		catch(Exception e) {
            			Logger.err.println(userid, this, e.getMessage());
            			setStatus(0);
            			setMessage(msg.getMessage("0001"));
            		}
            		
            		return getSepoaOut();
                } 
             
                public String et_getPurArea(String user_id, String[] args) throws Exception { 
                    String result = null; 
                    ConnectionContext ctx = getConnectionContext(); 
                    try { 
                    	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
            			
                            
                            /* sql.append(" select m.purchase_location, c.text2, m.ctrl_code, "); 
                            sql.append(" m.ctrl_type, m.company_code, p.ctrl_person_name_loc "); 
                            sql.append(" from icomcode c, icombacp p, icommcpm m "); 
                            sql.append(" <OPT=F,S> where m.house_code = ? </OPT>"); 
                            sql.append(" and c.house_code = m.house_code "); 
                            sql.append(" and p.house_code = m.house_code "); 
                            sql.append(" <OPT=F,S> and m.material_class1 = ? </OPT>"); 
                            sql.append(" <OPT=F,S> and m.ctrl_type = ? </OPT> "); 
                            sql.append(" and c.type = 'M039' "); 
                            sql.append(" and c.code = m.purchase_location "); 
                            sql.append(" and p.ctrl_code = m.ctrl_code ");  */ 
                        /*   
                            sql.append(" SELECT M.PURCHASE_LOCATION as area_code,                                          \n"); 
                            sql.append(" dbo.GETICOMCODE2(M.HOUSE_CODE,'M039',M.PURCHASE_LOCATION) AS area_name, \n");
                            sql.append(" M.CTRL_CODE as ctrl_code,                                                         \n"); 
                            sql.append(" M.CTRL_TYPE as ctrl_type,                                                         \n");
                            sql.append(" M.COMPANY_CODE as company_code,                                                      \n");
                            sql.append(" P.CTRL_NAME_LOC											               \n");
                            sql.append(" FROM ICOMBACO P, ICOMMCPM M                                          \n"); 
                            sql.append(" <OPT=F,S> WHERE M.HOUSE_CODE = ? </OPT>                              \n"); 
                            sql.append(" AND P.HOUSE_CODE = M.HOUSE_CODE                                      \n"); 
                            sql.append(" <OPT=F,S> AND M.MATERIAL_CLASS1 = ? </OPT>                           \n"); 
                            sql.append(" <OPT=F,S> AND P.CTRL_TYPE = ? </OPT>                                 \n"); 
                            sql.append(" AND P.CTRL_CODE = M.CTRL_CODE                                        \n"); 
                            sql.append(" AND P.COMPANY_CODE = M.COMPANY_CODE                                  \n"); 
             			*/
                            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                            result = sm.doSelect(args); 
                            if(result == null) throw new Exception("SQLManager is null"); 
                    }catch(Exception ex) { 
                        throw new Exception("et_getPurArea()"+ ex.getMessage()); 
                    } 
                    return result; 
                }
                
                
                /* 있는직무코드인지 아닌지 확인한다.*/ 
//                public SepoaOut getCtrlperson(String[] args) { 
//                    String user_id = info.getSession("ID"); 
//             
//                    try { 
//                        String rtn = null; 
//                        rtn = et_getCtrlperson(user_id, args); 
//                        setValue(rtn); 
//                        setStatus(1); 
//                        setMessage(msg.getMessage("0000")); 
//                    }catch(Exception e){ 
//                        System.out.println("Eception e = " + e.getMessage()); 
//                        setStatus(0); 
//                        setMessage(msg.getMessage("0001")); 
//                        Logger.err.println(info.getSession("ID"), this, e.getMessage()); 
//                    } 
//                    return getSepoaOut(); 
//                } 
                
                public SepoaOut getCtrlperson(Map<String, String> args) { 
                	ConnectionContext ctx = null;
            		SepoaXmlParser    sxp = null;
            		SepoaSQLManager   ssm = null;
            		String            rtn = null;
            		String            id  = info.getSession("ID");
            		SepoaFormater     wf  = null;
            		int               cnt = 0;
            		
            		try{
            			setStatus(1);
            			setFlag(true);
            			
            			ctx = getConnectionContext();
            			
            			sxp = new SepoaXmlParser(this, "et_getCtrlperson_1");
            			ssm = new SepoaSQLManager(id, this, ctx, sxp);
            			
            			rtn = ssm.doSelect(args);
            			
            			wf = new SepoaFormater(rtn);
            			
            			cnt = Integer.parseInt(wf.getValue(0, 0));
            			
            			if(cnt > 0){
            				sxp = new SepoaXmlParser(this, "et_getCtrlperson_2");
                			ssm = new SepoaSQLManager(id, this, ctx, sxp);
                			
                			rtn = ssm.doSelect(args);
                			
                			setValue(rtn);
                			setMessage(msg.getMessage("0000"));
            			}
            			else{
            				setMessage("NOTBE");
            			}
            		}
            		catch(Exception e) {
            			Logger.err.println(userid, this, e.getMessage());
            			setStatus(0);
            			setMessage(msg.getMessage("0001"));
            		}
            		
            		return getSepoaOut();
                }
             
                public String et_getCtrlperson(String user_id, String[] args) throws Exception { 
                    String result = null; 
                    String count = null; 
                    String house_code = info.getSession("HOUSE_CODE"); 
                    SepoaSQLManager sm  = null;  
                    ConnectionContext ctx = getConnectionContext(); 
                    String company_code = ""; 
                    String ctrl_code = ""; 
             
                    try { 
                            company_code = args[0]; 
                            ctrl_code = args[1]; 
             
                            SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_1");
                			wxp.addVar("house_code", house_code);
                			wxp.addVar("company_code", company_code); 
                			wxp.addVar("ctrl_code", ctrl_code); 
                            /*sql.append(" select count(*) from icombaco "); 
                            sql.append(" where house_code = '"+house_code+"' "); 
                            sql.append(" <OPT=F,S> and company_code = ? </OPT> "); 
                            sql.append(" <OPT=F,S> and ctrl_code = ? </OPT> ");    */ 
                			/*	
                            sql.append(" SELECT COUNT(*) FROM ICOMBACO "); 
                            sql.append(" WHERE HOUSE_CODE = '"+house_code+"' "); 
                            sql.append(" AND COMPANY_CODE = '"+company_code+"' "); 
                            sql.append(" AND CTRL_CODE = '"+ctrl_code+"' "); 
             				*/
                            sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                            count = sm.doSelect((String[])null); 
                            Logger.debug.println(info.getSession("ID"), this, "count============="+count); 
                            if(count == null) throw new Exception("SQLManager is null"); 
             
                            SepoaFormater wf = new SepoaFormater( count ); 
                            int cnt = Integer.parseInt( wf.getValue( 0, 0 ) ); 
             
                            if(cnt > 0) { 
                                /*sql.append(" select ctrl_person_name_loc from icombacp "); 
                                sql.append(" where house_code = '"+house_code+"' "); 
                                sql.append(" <OPT=F,S> and company_code = ? </OPT> "); 
                                sql.append(" and ctrl_type = 'P' "); 
                                sql.append(" <OPT=F,S> and ctrl_code = ? </OPT> ");    */ 
                            	
                            	wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_2");
                    			wxp.addVar("house_code", house_code);
                    			wxp.addVar("company_code", company_code); 
                    			wxp.addVar("ctrl_code", ctrl_code); 
                    			
                    			/* 
                                sql.append(" SELECT CTRL_PERSON_ID FROM ICOMBACP "); 
                                sql.append(" where house_code = '"+house_code+"' "); 
                                sql.append(" and company_code = '"+company_code+"' "); 
                                sql.append(" and ctrl_type = 'P' "); 
                                sql.append(" and ctrl_code = '"+ctrl_code+"' "); 
             					*/
                                sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                                result = sm.doSelect((String[])null); 
                            }else result = "NOTBE"; 
             
                            Logger.debug.println(info.getSession("ID"), this, "result============="+result); 
                            if(result == null) throw new Exception("SQLManager is null"); 
                    }catch(Exception ex) { 
                        throw new Exception("et_getCtrlperson()"+ ex.getMessage()); 
                    } 
                    return result; 
                }
                
                
                /* 생성버튼을 누르면 테이블에 입력했던 값들을 DB에 넣어준다. */ 
//                public SepoaOut Area_setInsert(String[][] args) { 
//                    int rtn = -1; 
//                    String user_id = info.getSession("ID"); 
//                    String add_date = SepoaDate.getShortDateString(); 
//                    String add_time = SepoaDate.getShortTimeString(); 
//             
//                    try { 
//                        rtn = et_Area_setInsert(args, user_id, add_date, add_time); 
//                        setValue("insertRow ==  " + rtn); 
//                        setStatus(1); 
//                        setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */ 
//                    }catch(Exception e) { 
//                        System.out.println("Exception= " + e.getMessage()); 
//                        setStatus(0); 
//                        setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */ 
//                    } 
//                    return getSepoaOut(); 
//                } 
                @SuppressWarnings("unchecked")
				public SepoaOut Area_setInsert(Map<String, Object> args) throws Exception { 
                	ConnectionContext         ctx      = null;
                    SepoaXmlParser            sxp      = null;
            		SepoaSQLManager           ssm      = null;
            		List<Map<String, String>> grid     = null;
            		Map<String, String>       gridInfo = null;
            		String                    id       = info.getSession("ID");
                    
                	setStatus(1);
            		setFlag(true);
            		
            		ctx = getConnectionContext();
            		
            		try {
            			grid = (List<Map<String, String>>)MapUtils.getObject(args, "gridData");
            			
            			for(int i = 0; i < grid.size(); i++) {
            				gridInfo = grid.get(i);
            				
                            sxp = new SepoaXmlParser(this, "et_Area_setInsert");
                            ssm = new SepoaSQLManager(id, this, ctx, sxp);
                            
                            ssm.doUpdate(gridInfo);
                        }
            			
            			Commit();
            		}
            		catch(Exception e){
            			Rollback();
            			setStatus(0);
            			setFlag(false);
            			setMessage(e.getMessage());
            			Logger.err.println(info.getSession("ID"), this, e.getMessage());
            		}
            		finally {}

            		return getSepoaOut();
                }
             
                private int et_Area_setInsert(String[][] args, String user_id, String add_date, String add_time) throws Exception, DBOpenException { 
                    int result =-1; 
                    String[] settype={"S","S","S","S","S","S"}; 
                    ConnectionContext ctx = getConnectionContext(); 
             
                    try { 
                    	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
            			wxp.addVar("user_id", user_id);
            			wxp.addVar("add_date", add_date);
            			wxp.addVar("add_time", add_time);
            			
            			
            			/*
                        tSQL.append(" INSERT INTO ICOMMCPM ("); 
                        tSQL.append(" MATERIAL_CLASS1, PURCHASE_LOCATION, CTRL_TYPE, CTRL_CODE ,COMPANY_CODE, ADD_USER_ID, "); 
                        tSQL.append(" ADD_DATE, ADD_TIME, CHANGE_USER_ID, CHANGE_DATE, CHANGE_TIME, HOUSE_CODE) "); 
                        tSQL.append(" VALUES(?, ?, ?, ?, ?, '"+user_id+"', '"+add_date+"', '"+add_time+"', "); 
                        tSQL.append(" '"+user_id+"', '"+add_date+"', '"+add_time+"', ? ) "); 
             			*/
                        SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                        result = sm.doInsert(args,settype); 
                        Commit(); 
                        
                    }catch(Exception e) { 
                        Rollback(); 
                        throw new Exception("et_Area_setInsert: " + e.getMessage()); 
                    } 
                    return result; 
                }
                
                
                /* 선택 박스에 체크된 Row를 삭제한다. */ 
//                public SepoaOut Area_setDelete(String[][] args) { 
//                    try { 
//                        int rtn = -1; 
//                        String user_id = info.getSession("ID");
//                        String house_code = info.getSession("HOUSE_CODE");
//                        rtn = et_Area_setDelete(user_id, args, house_code); 
//                        setValue("deleteRow ==  " + rtn); 
//                        setStatus(rtn); 
//                    }catch(Exception e) { 
//                        System.out.println("Exception= " + e.getMessage()); 
//                        setStatus(0); 
//                        setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */ 
//                    } 
//                    return getSepoaOut(); 
//                } 
                
                @SuppressWarnings("unchecked")
				public SepoaOut Area_setDelete(Map<String, Object> args) throws Exception { 
                	ConnectionContext         ctx      = null;
                    SepoaXmlParser            sxp      = null;
            		SepoaSQLManager           ssm      = null;
            		List<Map<String, String>> grid     = null;
            		Map<String, String>       gridInfo = null;
            		String                    id       = info.getSession("ID");
                    
                	setStatus(1);
            		setFlag(true);
            		
            		ctx = getConnectionContext();
            		
            		try {
            			grid = (List<Map<String, String>>)MapUtils.getObject(args, "gridData");
            			
            			for(int i = 0; i < grid.size(); i++) {
            				gridInfo = grid.get(i);
            				
                            sxp = new SepoaXmlParser(this, "et_Area_setDelete");
                            ssm = new SepoaSQLManager(id, this, ctx, sxp);
                            
                            ssm.doUpdate(gridInfo);
                        }
            			
            			Commit();
            		}
            		catch(Exception e){
            			Rollback();
            			setStatus(0);
            			setFlag(false);
            			setMessage(e.getMessage());
            			Logger.err.println(info.getSession("ID"), this, e.getMessage());
            		}
            		finally {}

            		return getSepoaOut();
                }
             
                private int et_Area_setDelete(String user_id, String[][] args, String house_code) throws Exception, DBOpenException { 
                    int rtn = -1; 
                    String[] settype = {"S","S","S"};  /*SQL 문의 ?의 타입이다.*/ 
                    ConnectionContext ctx = getConnectionContext(); 
                    try{ 
                    	if(chkCodeCount(user_id, args[0][1], house_code)){
                    		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
	                    	
                        	/*
                            tSQL.append(" DELETE FROM ICOMMCPM "); 
                            tSQL.append(" WHERE MATERIAL_CLASS1 = ? "); 
                            tSQL.append(" AND PURCHASE_LOCATION = ? "); 
                            tSQL.append(" AND HOUSE_CODE = ? "); 
                 			*/
                            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                            rtn = sm.doDelete(args,settype); 
                            Commit();	
                    	}else{
                    		rtn = -9999;
                    	}
                    }catch(Exception e) { 
                        Rollback(); 
                        Logger.err.println(info.getSession("ID"), this, "Exception="+e.getMessage()); 
                    } 
                    return rtn; 
                } 
             
   
                
                /*******************************품목 CLASS*****************************************/
                public SepoaOut msp_getMainternace(String[] args) 
                {
                    String user_id = info.getSession("ID");
                    String house_code = info.getSession("HOUSE_CODE");

                    try {
                        String rtn = null;
                        rtn = et_msp_getMainternace(user_id,args,house_code);
                        setValue(rtn);
                        setStatus(1);
                        setMessage(msg.getMessage("0000"));
                    }catch(Exception e){
                        
                        setStatus(0);
                        setMessage(msg.getMessage("0001"));
                        Logger.err.println(this, e.getMessage());
                    }
                    return getSepoaOut();
                }

                
                public String et_msp_getMainternace(String user_id, String[] args, String house_code) throws Exception 
                {
                    String result = null;
                    ConnectionContext ctx = getConnectionContext();

                    try 
                    {
                        //StringBuffer tSQL = new StringBuffer();
                    	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
            			wxp.addVar("house_code", house_code);
            			

//                        tSQL.append("select 	'' as pr_type,			\n");																							
//                        tSQL.append("a.text3 as code3,				\n");																					
//                        tSQL.append("(select text2 from icomcode where house_code='"+house_code+"' and type = 'M040' and code = a.text3) as text3,	\n");	
//                        tSQL.append("a.text4 as code4,	\n");																								
//                        tSQL.append("(select text2 from icomcode where house_code='"+house_code+"' and type = 'M041' and code = a.text4) as text4,	\n");	
//                        tSQL.append("a.code as code5,	\n");																								
//                        tSQL.append("(select text2 from icomcode where house_code='"+house_code+"' and type = 'M042' and code = a.code) as text5,	\n");	
//                        tSQL.append("a.code,	\n");				
//                        tSQL.append("a.text2,	\n");			
//                        tSQL.append("a.text1,	\n");			
//                        tSQL.append("a.use_flag,	\n");			
//                        tSQL.append("a.sort_seq	\n");			
//                        tSQL.append("from		icomcode a	\n");			
//                        tSQL.append("where		a.house_code = '"+house_code+"'	\n");	
//                        tSQL.append("and		a.type = 'M042'	\n");	
//                        tSQL.append(" <OPT=S,S> and text3  = ?                                                                </OPT>\n");
//                        tSQL.append(" <OPT=S,S> and text4  = ?                                                                </OPT>\n");
//                        tSQL.append(" <OPT=S,S> and code  = ?                                                                </OPT>\n");
//                        tSQL.append(" <OPT=S,S> and text2  like '%' + ?  + '%'                                                   </OPT>\n");
//                        tSQL.append(" <OPT=S,S> and upper(text1)  like upper('%' + ? + '%')                                                  </OPT>\n");            
//                        tSQL.append("and		a.status <> 'D'	\n");																		
//                        tSQL.append("order by cast(a.code as int)	\n");
            /*            
                        tSQL.append("select 	'' as pr_type,																									\n");
                        tSQL.append("			a.text3 as code3,																								\n");
                        tSQL.append("			(select text2 from icomcode where house_code='"+house_code+"' and type = 'M040' and code = a.text3) as text3,	\n");
                        tSQL.append("			a.text4 as code4,																								\n");
                        tSQL.append("			(select text2 from icomcode where house_code='"+house_code+"' and type = 'M041' and code = a.text4) as text4,	\n");
                        tSQL.append("			a.text5 as code5,																								\n");
                        tSQL.append("			(select text2 from icomcode where house_code='"+house_code+"' and type = 'M042' and code = a.code) as text5,	\n");
                        tSQL.append("			a.code,				\n");
                        tSQL.append("			a.text2,			\n");
                        tSQL.append("			a.text1,			\n");
                        tSQL.append("			a.use_flag,			\n");
                        tSQL.append("			a.sort_seq			\n");
                        tSQL.append("  from		icomcode a			\n");
                        tSQL.append(" where		a.house_code = '"+house_code+"'	\n");
                        tSQL.append("   and		a.type = 'M042'					\n"); 
                        tSQL.append(" <OPT=S,S> and text3  = ?                                                                </OPT>\n");
                        tSQL.append(" <OPT=S,S> and text4  = ?                                                                </OPT>\n");
                        tSQL.append(" <OPT=S,S> and code  = ?                                                                </OPT>\n");
                        tSQL.append(" <OPT=S,S> and text2  like '%' + ?  + '%'                                                   </OPT>\n");
                        tSQL.append(" <OPT=S,S> and upper(text1)  like upper('%' + ? + '%')                                                  </OPT>\n");
                        tSQL.append("   and		a.status <> 'D'																		\n");
                        tSQL.append(" order by cast(a.sort_seq as int)                          										\n");
            */            
            /*
                        tSQL.append("select  b.pr_type,a.code3, b.text3, a.code4,c.text4, a.code5,d.text5,a.code, a.text2, a.text1, a.use_flag, a.sort_seq \n");
                        tSQL.append("from(select text3 code3, text4 code4, text5 code5, code, text2, text1,use_flag, sort_seq from icomcode   \n");
                        tSQL.append("        where type = 'M119' and house_code = '"+house_code+"' and status !='D'                            \n");
                        tSQL.append(" <OPT=S,S> and text3  = ?                                                                </OPT>\n");
                        tSQL.append(" <OPT=S,S> and text4  = ?                                                                </OPT>\n");
                        tSQL.append(" <OPT=S,S> and text5  = ?                                                                </OPT>\n");
                        tSQL.append(" <OPT=S,S> and text2  like '%'||?||'%'                                                                </OPT>\n");
                        tSQL.append("            ) a,                                                                               \n");
                        tSQL.append("    (select code, text2 as text3,pr_type, sort_seq  from icomcode                                     \n");
                        tSQL.append("        where type = 'M040' and house_code = '"+house_code+"' and status !='D') b,                        \n");
                        tSQL.append("    (select code, text2 as text4 , sort_seq from icomcode   where type = 'M041'                \n");
                        tSQL.append("        and house_code = '"+house_code+"' and status !='D') c,                                            \n");
                        tSQL.append("    (select code, text2 as text5 , sort_seq from icomcode    where type = 'M042'               \n");
                        tSQL.append("       and house_code = '"+house_code+"' and status !='D') d                                              \n");
                        tSQL.append("    where a.code3 = b.code                                                                     \n");
                        tSQL.append("    and a.code4 = c.code                                                                       \n");
                        tSQL.append("    and a.code5 = d.code                                                                       \n");
                        tSQL.append("    order by b.sort_seq,c.sort_seq,                          \n");
                        tSQL.append("    d.sort_seq, a.sort_seq, a.text1                          \n");
            */
                        SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
                        result = sm.doSelect(args);
                        if(result == null) throw new Exception("SQLManager is null");
                    }catch(Exception ex) {
                        throw new Exception("et_mcl_getMainternace()"+ ex.getMessage());
                    }
                    return result;
                }
                
                
      //세분류 조회          
//                public SepoaOut mcl_getMainternace2(String[] args) { 
//                	 
//                    String user_id = info.getSession("ID"); 
//                    String house_code = info.getSession("HOUSE_CODE"); 
//                    String company_code = info.getSession("COMPANY_CODE"); 
//             
//                    try { 
//                        String rtn = null; 
//                        rtn = et_mcl_getMainternace2(user_id,args,house_code, company_code); 
//                        setValue(rtn); 
//                        setStatus(1); 
//                        setMessage(msg.getMessage("0000")); 
//                    }catch(Exception e){ 
//                        System.out.println("Eception e = " + e.getMessage()); 
//                        setStatus(0); 
//                        setMessage(msg.getMessage("0001")); 
//                        Logger.err.println(info.getSession("ID"), this, e.getMessage()); 
//                    } 
//                    return getSepoaOut(); 
//                }
                
                public SepoaOut mcl_getMainternace2(Map<String, String> args) { 
                	ConnectionContext ctx = null;
            		SepoaXmlParser    sxp = null;
            		SepoaSQLManager   ssm = null;
            		String            rtn = null;
            		String            id  = info.getSession("ID");
            		
            		try{
            			setStatus(1);
            			setFlag(true);
            			
            			ctx = getConnectionContext();
            			
            			sxp = new SepoaXmlParser(this, "et_mcl_getMainternace2");
            			ssm = new SepoaSQLManager(id, this, ctx, sxp);
            			
            			rtn = ssm.doSelect(args); // 조회
            			
            			setValue(rtn);
            			setMessage(msg.getMessage("0000"));
            		}
            		catch(Exception e) {
            			Logger.err.println(userid, this, e.getMessage());
            			setStatus(0);
            			setMessage(msg.getMessage("0001"));
            		}
            		
            		return getSepoaOut();
                } 
             
                private String et_mcl_getMainternace2(String user_id, String[] args, String house_code, String company_code) throws Exception { 
                    String result = null; 
                    ConnectionContext ctx = getConnectionContext(); 
                    try { 
                    		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
                    		wxp.addVar("house_code", house_code);
            			
                             /*
                            sql.append(" select use_flag, text3, text4, text5, code, text1, text2, text6, text7 "); 
                            sql.append(" from icomcode "); 
                            sql.append(" <OPT=F,S> where text3  = ? </OPT> "); 
                            sql.append(" <OPT=F,S> and text4  = ? </OPT> "); 
                            sql.append(" <OPT=F,S> and text5  = ? </OPT> "); 
                            sql.append(" and house_code = '"+house_code +"' "); 
             
//                            sql.append(" and type = 'M140' "); 
                            sql.append(" <OPT=F,S> and type = ? </OPT> "); 
                            //sql.append(" and use_flag = 'Y' "); 
                            sql.append(" and status != 'D' "); 
             				*/
                            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                            result = sm.doSelect(args); 
                            if(result == null) throw new Exception("SQLManager is null"); 
                    }catch(Exception ex) { 
                        throw new Exception("et_mcl_getMainternace()"+ ex.getMessage()); 
                    } 
                    return result; 
                }
                
                
       // 세분류 중복체크
//                public SepoaOut mcl_checkItem2(String[] args) { 
//                    String user_id = info.getSession("ID"); 
//                    String house_code = info.getSession("HOUSE_CODE"); 
//                    String company_code = info.getSession("COMPANY_CODE"); 
//                    try { 
//                        String rtn = null; 
//                        rtn = et_mcl_checkItem2(user_id,args,house_code,company_code); 
//                        setValue(rtn); 
//                        setStatus(1); 
//                        setMessage(msg.getMessage("0000")); 
//                    }catch(Exception e){ 
//                        System.out.println("Eception e = " + e.getMessage()); 
//                        setStatus(0); 
//                        setMessage(msg.getMessage("0001")); 
//                        Logger.err.println(info.getSession("ID"), this, e.getMessage()); 
//                    } 
//                    return getSepoaOut(); 
//                } 
                
                public SepoaOut mcl_checkItem2(Map<String, String> args) { 
                	ConnectionContext ctx = null;
            		SepoaXmlParser    sxp = null;
            		SepoaSQLManager   ssm = null;
            		String            rtn = null;
            		String            id  = info.getSession("ID");
            		
            		try{
            			setStatus(1);
            			setFlag(true);
            			
            			ctx = getConnectionContext();
            			
            			sxp = new SepoaXmlParser(this, "et_mcl_checkItem2");
            			ssm = new SepoaSQLManager(id, this, ctx, sxp);
            			
            			rtn = ssm.doSelect(args); // 조회
            			
            			setValue(rtn);
            			setMessage(msg.getMessage("0000"));
            		}
            		catch(Exception e) {
            			Logger.err.println(userid, this, e.getMessage());
            			setStatus(0);
            			setMessage(msg.getMessage("0001"));
            		}
            		
            		return getSepoaOut();
                }
             
                public String et_mcl_checkItem2(String user_id, String[] args, String house_code, String company_code) throws Exception { 
                    String result = null; 
                    ConnectionContext ctx = getConnectionContext(); 
                    try { 
                            
                    		SepoaXmlParser wxp = new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
                    		wxp.addVar("house_code", house_code);
                    		
                    		/* 
                            sql.append(" select ISNULL(text3,'X'), ISNULL(text4,'X'), ISNULL(text5,'X') ");
                            sql.append(" from icomcode "); 
                            sql.append(" where house_code = '"+house_code +"' "); 
//                            sql.append(" and type = 'M140' "); 
                            sql.append(" <OPT=F,S> and type = ? </OPT> "); 
                            sql.append(" and status != 'D' "); 
                            sql.append(" <OPT=F,S> and code  = ? </OPT> "); 
                    		 */
                            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                            result = sm.doSelect(args); 
                            if(result == null) throw new Exception("SQLManager is null"); 
                    }catch(Exception ex) { 
                        throw new Exception("et_mcl_checkItem()"+ ex.getMessage()); 
                    } 
                    return result; 
                }
                
                
                /* 세분류 등록 */ 
//                public SepoaOut mcl_setInsert2(String[][] args) { 
//                    int rtn = -1; 
//                    String status = "C"; 
//                    String user_id = info.getSession("ID"); 
//                    String house_code = info.getSession("HOUSE_CODE"); 
//                    String company_code = info.getSession("COMPANY_CODE"); 
//             
//                    String add_date = SepoaDate.getShortDateString(); 
//                    String add_time = SepoaDate.getShortTimeString(); 
//             
//                    try { 
//                        rtn = et_mcl_setInsert2(args, status, user_id, add_date, add_time, house_code,company_code); 
//                        setValue("insertRow ==  " + rtn); 
//                        setStatus(1); 
//                        setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */ 
//                    }catch(Exception e) { 
//                        setStatus(0); 
//                        setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */ 
//                    } 
//                    return getSepoaOut(); 
//                }
                
                @SuppressWarnings("unchecked")
				public SepoaOut mcl_setInsert2(Map<String, Object> args) throws Exception{ 
                	ConnectionContext         ctx      = null;
                    SepoaXmlParser            sxp      = null;
            		SepoaSQLManager           ssm      = null;
            		List<Map<String, String>> grid     = null;
            		Map<String, String>       gridInfo = null;
            		String                    id       = info.getSession("ID");
                    
                	setStatus(1);
            		setFlag(true);
            		
            		ctx = getConnectionContext();
            		
            		try {
            			grid = (List<Map<String, String>>)MapUtils.getObject(args, "gridData");
            			
            			for(int i = 0; i < grid.size(); i++) {
            				gridInfo = grid.get(i);
            				
                            sxp = new SepoaXmlParser(this, "et_mcl_setInsert2");
                            ssm = new SepoaSQLManager(id, this, ctx, sxp);
                            
                            gridInfo.put("HOUSE_CODE",   info.getSession("HOUSE_CODE"));
                            gridInfo.put("USER_ID",      info.getSession("ID"));
                            gridInfo.put("COMPANY_CODE", info.getSession("COMPANY_CODE"));
                            
                            ssm.doUpdate(gridInfo);
                        }
            			
            			Commit();
            		}
            		catch(Exception e){
            			Rollback();
            			setStatus(0);
            			setFlag(false);
            			setMessage(e.getMessage());
            			Logger.err.println(info.getSession("ID"), this, e.getMessage());
            		}
            		finally {}

            		return getSepoaOut(); 
                } 
             
                private int et_mcl_setInsert2(String[][] args, String status, String user_id, String add_date, String add_time, String house_code, String company_code) throws Exception, DBOpenException { 
                    int result =-1; 
                    String[] settype={"S","S","S","S","S","S","S","S","S","S"}; 
                    ConnectionContext ctx = getConnectionContext(); 
             
                    try { 
                        SepoaXmlParser wxp = new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
                    	wxp.addVar("status", status);
                    	wxp.addVar("user_id", user_id);
                    	wxp.addVar("add_date", add_date);
                    	wxp.addVar("add_time", add_time);
                    	wxp.addVar("house_code", house_code);
                    	/*
                    	tSQL.append(" insert into icomcode ("); 
                        tSQL.append(" type, use_flag,text3, text4,text5, code, text1, text2,  text6, text7, status, add_user_id, "); 
                        tSQL.append(" add_date, add_time, change_user_id, change_date, change_time, house_code) "); 
                        tSQL.append(" values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, '"+status+"', '"+user_id+"', '"+add_date+"', "); 
                        tSQL.append(" '"+add_time+"', '"+user_id+"', '"+add_date+"', '"+add_time+"', '"+house_code+"' ) "); 
             			*/
                        SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                        result = sm.doInsert(args,settype); 
                        Commit(); 
                    }catch(Exception e) { 
                        Rollback(); 
                        throw new Exception("et_mcl_setInsert: " + e.getMessage()); 
                    } 
                    return result; 
                }
                
                
                /* 세분류 수정   */ 
//                public SepoaOut mcl_setUpdate2(String[][] args) { 
//                    int rtn = -1; 
//                    String status = "R"; 
//                    String user_id = info.getSession("ID"); 
//                    String house_code = info.getSession("HOUSE_CODE"); 
//                    String company_code = info.getSession("COMPANY_CODE"); 
//                    String change_date = SepoaDate.getShortDateString(); 
//                    String change_time = SepoaDate.getShortTimeString(); 
//             
//                    try { 
//                        rtn = et_mcl_setUpdate2(user_id, args, status, change_date, change_time, house_code, company_code); 
//                        setValue("Change_Row=" + rtn); 
//                        setStatus(1); 
//                        setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */ 
//                    }catch(Exception e) { 
//                        setStatus(0); 
//                        setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */ 
//                    } 
//                    return getSepoaOut(); 
//                } 
                
                @SuppressWarnings("unchecked")
				public SepoaOut mcl_setUpdate2(Map<String, String> args) throws Exception { 
                	ConnectionContext         ctx      = null;
                    SepoaXmlParser            sxp      = null;
            		SepoaSQLManager           ssm      = null;
            		List<Map<String, String>> grid     = null;
            		Map<String, String>       gridInfo = null;
            		String                    id       = info.getSession("ID");
                    
                	setStatus(1);
            		setFlag(true);
            		
            		ctx = getConnectionContext();
            		
            		try {
            			grid = (List<Map<String, String>>)MapUtils.getObject(args, "gridData");
            			
            			for(int i = 0; i < grid.size(); i++) {
            				gridInfo = grid.get(i);
            				
                            sxp = new SepoaXmlParser(this, "et_mcl_setUpdate2");
                            ssm = new SepoaSQLManager(id, this, ctx, sxp);
                            
                            gridInfo.put("HOUSE_CODE",   info.getSession("HOUSE_CODE"));
                            gridInfo.put("USER_ID",      info.getSession("ID"));
                            gridInfo.put("COMPANY_CODE", info.getSession("COMPANY_CODE"));
                            
                            ssm.doUpdate(gridInfo);
                        }
            			
            			Commit();
            		}
            		catch(Exception e){
            			Rollback();
            			setStatus(0);
            			setFlag(false);
            			setMessage(e.getMessage());
            			Logger.err.println(info.getSession("ID"), this, e.getMessage());
            		}
            		finally {}

            		return getSepoaOut(); 
                }
             
                private int et_mcl_setUpdate2(String user_id, String[][] args, String status, String change_date, String change_time, String house_code, String company_code) throws Exception, DBOpenException { 
                    int result = -1; 
                    String[] settype = {"S","S","S","S","S","S","S","S","S","S"}; 
                    ConnectionContext ctx = getConnectionContext(); 
             
                    try { 
                    	SepoaXmlParser wxp = new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
                    	wxp.addVar("user_id", user_id);
                    	wxp.addVar("change_date", change_date);
                    	wxp.addVar("change_time", change_time);
                    	wxp.addVar("status", status);
                    	wxp.addVar("house_code", house_code);
                        
                    	/*
                        tSQL.append(" update icomcode set change_user_id = '"+user_id+"', change_date = '"+change_date+"', "); 
                        tSQL.append(" change_time = '"+change_time+"', status = '"+status+"', "); 
                        tSQL.append(" use_flag = ?, text3 = ?, text4 = ?, text5 = ? , text1 = ?, text2 =?, text6 = ?, text7 = ?  "); 
                        tSQL.append(" where type = ? and house_code = '"+house_code+"' and code = ? " ); 
             			*/
                        
                    	SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                        result = sm.doUpdate(args,settype); 
                        Commit(); 
                    }catch(Exception e) { 
                        Rollback(); 
                        throw new Exception("et_mcl_setUpdate: " + e.getMessage()); 
                    } 
                    return result; 
                }
                
                /* 선택 박스에 체크된 Row를 삭제한다. */ 
//                public SepoaOut mcl_setDelete2(String[][] args) { 
//                    try { 
//                        int rtn = -1; 
//                        String user_id = info.getSession("ID"); 
//                        String house_code = info.getSession("HOUSE_CODE"); 
//                        String company_code = info.getSession("COMPANY_CODE"); 
//             
//                        rtn = et_mcl_setDelete2(user_id, args, house_code,company_code); 
//                        setValue("deleteRow ==  " + rtn); 
//                        setStatus(rtn); 
//                    }catch(Exception e) { 
//                        System.out.println("Exception= " + e.getMessage()); 
//                        setStatus(0); 
//                        setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */ 
//                    } 
//                    return getSepoaOut(); 
//                } 
                
                @SuppressWarnings("unchecked")
				public SepoaOut mcl_setDelete2(Map<String, Object> args) throws Exception { 
                	ConnectionContext         ctx            = null;
                    SepoaXmlParser            sxp            = null;
            		SepoaSQLManager           ssm            = null;
            		List<Map<String, String>> grid           = null;
            		Map<String, String>       gridInfo       = null;
            		String                    id             = info.getSession("ID");
            		String                    houseCode      = info.getSession("HOUSE_CODE");
            		String                    code           = null;
            		boolean                   isChkCodeCount = false;
                    
                	setStatus(1);
            		setFlag(true);
            		
            		ctx = getConnectionContext();
            		
            		try {
            			grid = (List<Map<String, String>>)MapUtils.getObject(args, "gridData");
            			
            			for(int i = 0; i < grid.size(); i++) {
            				gridInfo       = grid.get(i);
            				code           = gridInfo.get("code");
            				isChkCodeCount = this.chkCodeCount(id, code, houseCode);
            				
            				if(isChkCodeCount == false){
            					throw new Exception("하위코드가 존재합니다.");
            				}
            				
                            sxp = new SepoaXmlParser(this, "et_mcl_setDelete2");
                            ssm = new SepoaSQLManager(id, this, ctx, sxp);
                            
                            ssm.doUpdate(gridInfo);
                        }
            			
            			Commit();
            		}
            		catch(Exception e){
            			Rollback();
            			setStatus(0);
            			setFlag(false);
            			setMessage(e.getMessage());
            			Logger.err.println(info.getSession("ID"), this, e.getMessage());
            		}
            		finally {}

            		return getSepoaOut();
                }
             
                private int et_mcl_setDelete2(String user_id, String[][] args, String house_code, String company_code) throws Exception, DBOpenException { 
                    int rtn = -1; 
                    String[] settype = {"S","S" };  /*SQL 문의 ?의 타입이다.*/ 
                    ConnectionContext ctx = getConnectionContext(); 
                    try{ 
                    	if(chkCodeCount(user_id, args[0][1], house_code)){
                    		SepoaXmlParser wxp = new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
                        	wxp.addVar("house_code", house_code);
                        	/*
                            tSQL.append(" delete from icomcode "); 
                            tSQL.append(" where type = 'M140' and code = ? and house_code = '"+house_code+"' "); 
                            tSQL.append(" where type = ? and code = ? and house_code = '"+house_code+"' "); 
                 			*/
                            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery()); 
                            rtn = sm.doDelete(args,settype); 
                            Commit();	
                    	}else{
                    		rtn = -9999;
                    	}
                    }catch(Exception e) { 
                        Rollback(); 
                    } 
                    return rtn; 
                } 
} 
