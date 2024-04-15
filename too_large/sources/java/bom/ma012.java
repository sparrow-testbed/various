package bom;

import java.util.Iterator;
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

public class MA012 extends SepoaService {
	private Message msg;

    public MA012(String opt, SepoaInfo info) throws SepoaServiceException {
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
	
	public SepoaOut ma012DoSelect(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "ma012DoSelect");
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
	
	@SuppressWarnings("unchecked")
	public SepoaOut ma012DoInsert(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx      = getConnectionContext();
        SepoaXmlParser            sxp      = null;
		SepoaSQLManager           ssm      = null;
		SepoaFormater             sf       = null;
		List<Map<String, String>> grid     = (List<Map<String, String>>)data.get("gridData");
		Map<String, String>       gridInfo = null;
		Map<String, String>       header   = (Map<String, String>)data.get("header");
		String                    id       = info.getSession("ID");
		String                    rtn      = null;
		String                    seq      = null;
        
    	setStatus(1);
		setFlag(true);
		
		try { 
			sxp = new SepoaXmlParser(this, "ma012DoInsertSeq");
            ssm = new SepoaSQLManager(id, this, ctx, sxp);
            
            rtn = ssm.doSelect(header);
            
            sf = new SepoaFormater(rtn);
            
            seq = sf.getValue("SEQ", 0);
            
            header.put("SEQ", seq);
            
            sxp = new SepoaXmlParser(this, "ma012InsertGl");
            ssm = new SepoaSQLManager(id, this, ctx, sxp);
            
            ssm.doInsert(header);
            
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
				gridInfo.put("SEQ", seq);
				
                sxp = new SepoaXmlParser(this, "ma012InsertLn");
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
	public SepoaOut ma012DoUpdate(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx      = getConnectionContext();
        SepoaXmlParser            sxp      = null;
		SepoaSQLManager           ssm      = null;
		List<Map<String, String>> grid     = (List<Map<String, String>>)data.get("gridData");
		Map<String, String>       gridInfo = null;
		Map<String, String>       header   = (Map<String, String>)data.get("header");
		String                    id       = info.getSession("ID");
        
    	setStatus(1);
		setFlag(true);
		
		try { 
			sxp = new SepoaXmlParser(this, "ma012UpdateGl");
            ssm = new SepoaSQLManager(id, this, ctx, sxp);
            
            ssm.doUpdate(header);
            
            sxp = new SepoaXmlParser(this, "ma012DeleteLn");
            ssm = new SepoaSQLManager(id, this, ctx, sxp);
            
            ssm.doDelete(header);
            
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
                sxp = new SepoaXmlParser(this, "ma012InsertLn");
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
	
	public SepoaOut ma012selectGl(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "ma012selectGl");
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
	
	public SepoaOut ma012SelectGlList(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "ma012SelectGlList");
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
	
	public SepoaOut ma012SelectLnList(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "ma012SelectLnList");
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
	
	public SepoaOut  ma012SelectSoslnList(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "ma012SelectSoslnList");
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
