package ict.sepoa.svc.co;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaFormater;

public class I_CO_017 extends SepoaService {
	private Message msg;

    public I_CO_017(String opt, SepoaInfo info) throws SepoaServiceException {
        super(opt, info);
        
        setVersion("1.0.0");
        
        msg = new Message(info,"p10_pra");
    }

	public String getConfig(String s){
	    try{
	        Configuration configuration = new Configuration();
	        
	        s = configuration.get(s);
	        
	        return s;
	    }
	    catch(ConfigurationException configurationexception){
	        Logger.sys.println("getConfig error : " + configurationexception.getMessage());
	    }
	    catch(Exception exception){
	        Logger.sys.println("getConfig error : " + exception.getMessage());
	    }
	    
	    return null;
	}

	private String select(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          result = null;
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doSelect(param); // 조회
		
		return result;
	}
	
	@SuppressWarnings("unused")
	private int insert(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		int             result = 0;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doInsert(param);
		
		return result;
	}
	
	@SuppressWarnings("unused")
	private int update(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		int             result = 0;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doUpdate(param);
		
		return result;
	}
	
	@SuppressWarnings("unused")
	private int delete(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		int             result = 0;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doDelete(param);
		
		return result;
	}
	
	private String nvl(String str, String defaultValue) throws Exception{
		String result = null;
		
		if(str == null){
			str = "";
		}
		
		if(str.equals("")){
			result = defaultValue;
		}
		else{
			result = str;
		}
		
		return result;
	}
	
	public SepoaOut selectBizList(Map<String, String> header){
		ConnectionContext ctx = null;
		String            rtn = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			rtn = this.select(ctx, "selectBizList", header);
			
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
	
	public SepoaOut getBottomSupiList(String rfq_no, String rfq_count) {

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sqlsb = new StringBuffer();
         
        Map<String, String> map = new HashMap<String, String>();
        
        try { 
        	
            setStatus(1);
            setFlag(true);

            map.put("RFQ_NUMBER"	, rfq_no);        
			map.put("RFQ_COUNT"		, rfq_count);  
			
			SepoaXmlParser sxp = new SepoaXmlParser();                                                                
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            setValue(ssm.doSelect(map));


        } catch (Exception e) {
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
    }

}