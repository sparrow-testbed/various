package sepoa.svc.approval;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;


public class AP_006 extends SepoaService{
	
    public AP_006(String opt,SepoaInfo info) throws SepoaServiceException
    {
        super(opt,info);
        setVersion("1.0.0");
        Configuration configuration = null;

		try {
			configuration = new Configuration();
		} catch(ConfigurationException cfe) {
			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + cfe.getMessage());
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + e.getMessage());
		}
    }
    
    
	public SepoaOut getChannelList(Map<String, Object> data)
	{
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {
			
			
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			
			
			
			sxp = new SepoaXmlParser(this, "getChannelList");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	setValue(ssm.doSelect(header));
		}catch(Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();

	}
	
	public SepoaOut setChannelInsert(Map<String, Object> data) throws Exception {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		String sign_path_no = null;
		try{
			List<Map<String,String>>grid=(List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			//for(int i = 0; i < grid.size(); i++) {
	        	//Map<String, String> header = MapUtils.getMap(data, "headerData");
	        	//Map<String, String> data1 = new HashMap();
	        	
        	sxp = new SepoaXmlParser(this, "setChannelInsert_1");
        	sxp.addVar("language", info.getSession("LANGUAGE"));
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			sf=new SepoaFormater(ssm.doSelect(new HashMap()));
			if ( sf.getRowCount() > 0 )
            {
	            sign_path_no = sf.getValue(0, 0); 
            }
			//data.put("sign_path_no", sign_path_no);
			grid.get(0).put("sign_path_no", sign_path_no);
			sxp = new SepoaXmlParser(this, "setChannelInsert_2");
        	sxp.addVar("language", info.getSession("LANGUAGE"));
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doInsert(grid.get(0));
			
			Commit();
		}catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();
	}
	
	public SepoaOut setChannelUpdate(Map<String, Object> data) throws Exception {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		String sign_path_no = null;
		try{
			List<Map<String,String>>grid=(List<Map<String, String>>)MapUtils.getObject(data, "gridData");
	        
			sxp = new SepoaXmlParser(this, "setChannelUpdate");
        	sxp.addVar("language", info.getSession("LANGUAGE"));
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doInsert(grid.get(0));
			
			Commit();
		}catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();
	}
	
	public SepoaOut setChannelDelete(Map<String, Object> data) throws Exception {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		String sign_path_no = null;
		try{
			List<Map<String,String>>grid=(List<Map<String, String>>)MapUtils.getObject(data, "gridData");
	        
			sxp = new SepoaXmlParser(this, "setChannelDelete_1");
        	sxp.addVar("language", info.getSession("LANGUAGE"));
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doDelete(grid);
			
			sxp = new SepoaXmlParser(this, "setChannelDelete_2");
        	sxp.addVar("language", info.getSession("LANGUAGE"));
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doDelete(grid);
			
			Commit();
		}catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();
	}
}