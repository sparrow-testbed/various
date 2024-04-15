package os;

import java.util.List;
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

public class os_004 extends SepoaService {
	@SuppressWarnings("unused")
	private Message msg;

    public os_004(String opt, SepoaInfo info) throws SepoaServiceException {
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
	
	private void updateOsUpdateSosglInfo(ConnectionContext ctx, Map<String, String> param) throws Exception{
		String          id  = info.getSession("ID");
		SepoaXmlParser  sxp = null;
		SepoaSQLManager ssm = null;
		
		sxp = new SepoaXmlParser(this, "updateSosglInfo");
        ssm = new SepoaSQLManager(id, this, ctx, sxp);
        
        ssm.doUpdate(param);
	}
	
	private void updateOsDeleteSosse(ConnectionContext ctx, Map<String, String> param) throws Exception{
		String          id  = info.getSession("ID");
		SepoaXmlParser  sxp = null;
		SepoaSQLManager ssm = null;
		
		sxp = new SepoaXmlParser(this, "deleteSosse");
        ssm = new SepoaSQLManager(id, this, ctx, sxp);
        
        ssm.doDelete(param);
	}
	
	private void updateOsDeleteSosln(ConnectionContext ctx, Map<String, String> param) throws Exception{
		String          id  = info.getSession("ID");
		SepoaXmlParser  sxp = null;
		SepoaSQLManager ssm = null;
		
		sxp = new SepoaXmlParser(this, "deleteSosln");
        ssm = new SepoaSQLManager(id, this, ctx, sxp);
        
        ssm.doDelete(param);
	}
	
	private void updateOsInsertSoslnInfo(ConnectionContext ctx, List<Map<String, String>> insertSosln) throws Exception{
		Map<String, String> insertSoslnInfo = null;
		String id = info.getSession("ID");
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		int insertSoslnSize = insertSosln.size();
		int i = 0;
		
		for(i = 0; i < insertSoslnSize; i++) {
			insertSoslnInfo = insertSosln.get(i);
			
            sxp = new SepoaXmlParser(this, "insertSoslnInfo");
            ssm = new SepoaSQLManager(id, this, ctx, sxp);
            
            ssm.doInsert(insertSoslnInfo);
        }
	}
	
	private void updateOsSetSosseCreate(ConnectionContext ctx, List<Map<String, String>> insertSosse) throws Exception{
		Map<String, String> insertSosseInfo = null;
		String              id              = info.getSession("ID");
		SepoaXmlParser      sxp             = null;
		SepoaSQLManager     ssm             = null;
		int                 insertSosseSize = insertSosse.size();
		int                 i               = 0;
		
		for(i = 0; i < insertSosseSize; i++) {
			insertSosseInfo = insertSosse.get(i);
			
            sxp = new SepoaXmlParser(this, "setSosseCreate");
            ssm = new SepoaSQLManager(id, this, ctx, sxp);
            
            ssm.doInsert(insertSosseInfo);
        }
	}
	
	private void updateOsSetPRComfirm(ConnectionContext ctx, List<Map<String, String>> updateIcoyprdt) throws Exception{
		Map<String, String> updateIcoyprdtInfo = null;
		String              id                 = info.getSession("ID");
		SepoaXmlParser      sxp                = null;
		SepoaSQLManager     ssm                = null;
		int                 updateIcoyprdtSize = updateIcoyprdt.size();
		int                 i                  = 0;
		
		for(i = 0; i < updateIcoyprdtSize; i++) {
			updateIcoyprdtInfo = updateIcoyprdt.get(i);
			
            sxp = new SepoaXmlParser(this, "setPRComfirm");
            ssm = new SepoaSQLManager(id, this, ctx, sxp);
            
            ssm.doUpdate(updateIcoyprdtInfo);
        }
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut updateOs(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx             = null;
		Map<String, String>       updateSosglInfo = (Map<String, String>)data.get("updateSosglInfo");
		Map<String, String>       deleteSoInfo    = (Map<String, String>)data.get("deleteSoInfo");
		List<Map<String, String>> insertSosln     = (List<Map<String, String>>)data.get("insertSosln");
		List<Map<String, String>> insertSosse     = (List<Map<String, String>>)data.get("insertSosse");
		List<Map<String, String>> updateIcoyprdt  = (List<Map<String, String>>)data.get("updateIcoyprdt");
		String                    id              = info.getSession("ID");
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			this.updateOsUpdateSosglInfo(ctx, updateSosglInfo);
			this.updateOsDeleteSosse(ctx, deleteSoInfo);
			this.updateOsDeleteSosln(ctx, deleteSoInfo);
			this.updateOsInsertSoslnInfo(ctx, insertSosln);
			this.updateOsSetSosseCreate(ctx, insertSosse);
			this.updateOsSetPRComfirm(ctx, updateIcoyprdt);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(id, this, e.getMessage());
		}

		return getSepoaOut();
    }
}