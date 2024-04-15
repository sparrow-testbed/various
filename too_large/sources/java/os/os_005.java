package os;

import java.util.Map;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;

public class os_005 extends SepoaService {
	private Message msg;

    public os_005(String opt, SepoaInfo info) throws SepoaServiceException {
        super(opt, info);
        
        setVersion("1.0.0");
        
        msg = new Message(info, "MA012");
    }
    
	public String getConfig(String s){
		Configuration configuration = null;
		
	    try{
	        configuration = new Configuration();
	        
	        s = configuration.get(s);
	    }
	    catch(Exception exception){
	        Logger.sys.println("getConfig error : " + exception.getMessage());
	        
	        s = null;
	    }
	    
	    return s;
	}
	
	public SepoaOut selectVendorList(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "selectVendorList");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			rtn = ssm.doSelect(header);
			
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
	
	public SepoaOut selectUnitPrice(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "selectUnitPrice");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			rtn = ssm.doSelect(header);
			
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
}