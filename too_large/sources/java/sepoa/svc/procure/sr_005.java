
package sepoa.svc.procure;

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


public class SR_005  extends SepoaService{
	
	public SR_005(String opt,SepoaInfo info) throws SepoaServiceException
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

	public SepoaOut getSgVnLinkList(Map<String, Object> data)
	{
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			sxp = new SepoaXmlParser(this, "getSgVnLinkList");
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
	
	public SepoaOut setSgVnLinkInsert(Map<String, Object> data) throws Exception {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		try{
			List<Map<String,String>>grid=(List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			for(int i = 0; i < grid.size(); i++) {
	        	Map<String, String> header = MapUtils.getMap(data, "headerData");
	        	Map<String, String> data1 = new HashMap();
	        	data1.put("type3_code",grid.get(i).get("type3_code"));
	        	data1.put("vendor_code",grid.get(i).get("vendor_code"));
	        	data1.put("house_code", info.getSession("HOUSE_CODE"));
	        	sxp = new SepoaXmlParser(this, "setSgVnLinkInsert_1");
	        	sxp.addVar("language", info.getSession("LANGUAGE"));
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				sf=new SepoaFormater(ssm.doSelect(data1));

				if(Integer.parseInt(sf.getValue(0,0 )) == 0 )
				{
					sxp = new SepoaXmlParser(this, "setSgVnLinkInsert_2");
		        	//sxp.addVar("language", info.getSession("LANGUAGE"));
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
					ssm.doInsert(data1);
				}else{
					sxp = new SepoaXmlParser(this, "setSgVnLinkInsert_3");
		        	sxp.addVar("language", info.getSession("LANGUAGE"));
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
					ssm.doUpdate(data1);
				}
        	}
			
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
	
	public SepoaOut setSgVnLinkDelete(Map<String, Object> data) throws Exception {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		try{
			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");

			Map<String, String> customHeader =  new HashMap<String, String>();	
			
			sxp = new SepoaXmlParser(this, "setSgVnLinkDelete"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doUpdate(grid, true);
			
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