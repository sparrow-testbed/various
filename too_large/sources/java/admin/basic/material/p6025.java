package admin.basic.material; 

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
 
public class p6025 extends SepoaService { 
    Message msg = null;  // message 처리를 위해 전역변수 선언 
 
    public p6025(String opt, SepoaInfo info) throws SepoaServiceException{ 
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
    
    @SuppressWarnings("unchecked")
	public SepoaOut mty_setUpdate(Map<String, Object> param) throws Exception{ 
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
			grid = (List<Map<String, String>>)param.get("gridData");
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
                sxp = new SepoaXmlParser(this, "et_mty_setUpdate");
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
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			grid = (List<Map<String, String>>)param.get("gridData");
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo     = grid.get(i);
				code         = gridInfo.get("CODE");
				chkCodeCount = this.chkCodeCount(id, code, houseCode);
				
				if(chkCodeCount == false){
					throw new Exception("하위코드가 존재합니다.");
				}
				else{
					sxp = new SepoaXmlParser(this, "et_mty_setDelete");
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
    
    private boolean chkCodeCount2(String user_id, String code, String house_code) throws Exception{ 
    	ConnectionContext   ctx     = getConnectionContext();
    	SepoaXmlParser      wxp     = new SepoaXmlParser(this, "chkCodeCount2");
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
            throw new Exception("chkCodeCount2()" + ex.getMessage()); 
        }
        
        return result; 
    }
    
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
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			grid = (List<Map<String, String>>)MapUtils.getObject(param, "gridData");
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				code     = gridInfo.get("CODE");
				
				isCheckCodeCount = this.chkCodeCount2(id, code, houseCode);
				
				if(isCheckCodeCount){
					sxp = new SepoaXmlParser(this, "et_mct_setDelete");
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
    
    public SepoaOut mbb_getVendorList(Map<String, String> parma)  { 
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		String slevel     = "";
		
		try{
			setStatus(1);
			setFlag(true);
			
			slevel = parma.get("level");
      		if(!slevel.equals("1") && !slevel.equals("2") && !slevel.equals("3"))
      			slevel = "4";
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "et_mbb_getVendorList");
			sxp.addVar("slevel", 		slevel);
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
    
    public SepoaOut mbb_checkItem(Map<String, String> param) throws Exception{ 
    	ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "et_mbb_checkItem");
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
    
    @SuppressWarnings("unchecked")
   	public SepoaOut mbb_setInsert(Map<String, Object> param) throws Exception{ 
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
   				
                   sxp = new SepoaXmlParser(this, "et_mbb_setInsert");
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
} 
