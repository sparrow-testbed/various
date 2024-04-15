package os;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import mail.mail;
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
import sms.SMS;

public class os_000 extends SepoaService {
	private Message msg;

    public os_000(String opt, SepoaInfo info) throws SepoaServiceException {
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
	
	@SuppressWarnings("unchecked")
	public SepoaOut createOs(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx           = null;
        SepoaXmlParser            sxp           = null;
		SepoaSQLManager           ssm           = null;
		List<Map<String, String>> grid          = (List<Map<String, String>>)data.get("gridData");
		List<Map<String, String>> prConfirmData = (List<Map<String, String>>)data.get("prConfirmData");
		List<Map<String, String>> sosseData     = (List<Map<String, String>>)data.get("sosseData");
		Map<String, String>       gridInfo      = null;
		Map<String, String>       header        = (Map<String, String>)data.get("header");
		String                    id            = info.getSession("ID");
		String                    vendorCode    = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "insertSosglInfo");
            ssm = new SepoaSQLManager(id, this, ctx, sxp);
            
            ssm.doInsert(header);
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
                sxp = new SepoaXmlParser(this, "insertSoslnInfo");
                ssm = new SepoaSQLManager(id, this, ctx, sxp);
                
                ssm.doInsert(gridInfo);
            }
			
//			for(int i = 0; i < prConfirmData.size(); i++) {
//				gridInfo = prConfirmData.get(i);
//				
//                sxp = new SepoaXmlParser(this, "setPRComfirm");
//                ssm = new SepoaSQLManager(id, this, ctx, sxp);
//                
//                ssm.doUpdate(gridInfo);
//            }
			
			for(int i = 0; i < sosseData.size(); i++) {
				gridInfo   = sosseData.get(i);
				
				if(i == 0){
					vendorCode = gridInfo.get("VENDOR_CODE");
				}
				
                sxp = new SepoaXmlParser(this, "setSosseCreate");
                ssm = new SepoaSQLManager(id, this, ctx, sxp);
                
                ssm.doUpdate(gridInfo);
            }
			
			Map<String, String> smsParam = new HashMap<String, String>();
			
		    smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
		    smsParam.put("VENDOR_CODE", vendorCode);
		    smsParam.put("SUBJECT",     header.get("SUBJECT"));
		    smsParam.put("OSQ_NO",      header.get("OSQ_NO"));
			
			new SMS("NONDBJOB", info).so1Process(ctx, smsParam);
			new mail("NONDBJOB", info).so1Process(ctx, smsParam);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }
}