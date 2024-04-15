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
import sepoa.fw.util.SepoaFormater;

public class os_002 extends SepoaService {
	private Message msg;

    public os_002(String opt, SepoaInfo info) throws SepoaServiceException {
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
	
	public SepoaOut getOsList(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "getOsList");
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
	
	private void deleteSosValidStatus(ConnectionContext ctx, Map<String, String> param) throws Exception{
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		SepoaFormater     sf  = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		sxp = new SepoaXmlParser(this, "selectSosglInfoOsqStatus");
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		rtn = ssm.doSelect(param);
		
		sf = new SepoaFormater(rtn);
		
		rtn = sf.getValue("OSQ_FLAG", 0);
		
		if("T".equals(rtn) == false){
			throw new Exception("진행상태가 맞지 않아 삭제할 수 없습니다.");
		}
	}
	
	private void deleteSosUpdateIcoyprdt(ConnectionContext ctx, Map<String, String> param) throws Exception{
		String          id  = info.getSession("ID");
		SepoaXmlParser  sxp = new SepoaXmlParser(this, "updateIcoyprdtInfoDeleteSos");
		SepoaSQLManager ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
        ssm.doUpdate(param);
	}
	
	private void deleteSosse(ConnectionContext ctx, Map<String, String> param) throws Exception{
		String          id  = info.getSession("ID");
		SepoaXmlParser  sxp = new SepoaXmlParser(this, "deleteSosse");
		SepoaSQLManager ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
        ssm.doDelete(param);
	}
	
	private void deleteSosln(ConnectionContext ctx, Map<String, String> param) throws Exception{
		String          id  = info.getSession("ID");
		SepoaXmlParser  sxp = new SepoaXmlParser(this, "deleteSosln");
		SepoaSQLManager ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
        ssm.doDelete(param);
	}
	
	private void deleteSosgl(ConnectionContext ctx, Map<String, String> param) throws Exception{
		String          id  = info.getSession("ID");
		SepoaXmlParser  sxp = new SepoaXmlParser(this, "deleteSosgl");
		SepoaSQLManager ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
        ssm.doDelete(param);
	}
	 
	@SuppressWarnings("unchecked")
	public SepoaOut deleteSos(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx      = getConnectionContext();
		List<Map<String, String>> grid     = (List<Map<String, String>>)data.get("gridData");
		Map<String, String>       gridInfo = null;
		int                       gridSize = grid.size();
        
		try {
			setStatus(1);
			setFlag(true);
			
			for(int i = 0; i < gridSize; i++) {
				gridInfo = grid.get(i);
				
				this.deleteSosValidStatus(ctx, gridInfo);
				this.deleteSosUpdateIcoyprdt(ctx, gridInfo);
                this.deleteSosse(ctx, gridInfo);
                this.deleteSosln(ctx, gridInfo);
                this.deleteSosgl(ctx, gridInfo);
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
		
		return getSepoaOut();
    }
}