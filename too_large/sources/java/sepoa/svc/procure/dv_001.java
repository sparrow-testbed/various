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
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

public class DV_001 extends SepoaService {

    public DV_001(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
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
   
    public String getConfig(String s)
   	{
   		try
   		{
   			Configuration configuration = new Configuration();
   			s = configuration.get(s);

   			return s;
   		}
   		catch (ConfigurationException configurationexception)
   		{
   			Logger.sys.println("getConfig error : " + configurationexception.getMessage());
   		}
   		catch (Exception exception)
   		{
   			Logger.sys.println("getConfig error : " + exception.getMessage());
   		}

   		return null;
   	}

	public SepoaOut getStateList(Map<String, Object> data) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null; 
		SepoaSQLManager ssm = null;
		
		try {
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			Map<String, String> customHeader =  new HashMap<String, String>();	//�좉퇋媛앹껜
			
			
			customHeader.put( "po_to_date   ".trim(), SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "po_to_date   ".trim(), "" ) ) );
			customHeader.put( "po_from_date ".trim(), SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "po_from_date ".trim(), "" ) ) );
			
			sxp = new SepoaXmlParser(this, "getStateList");
			sxp.addVar("language", info.getSession("LANGUAGE"));
		
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);

        	setValue(ssm.doSelect(header,customHeader));

		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
	
	public SepoaOut setTempDelete(Map<String, Object> data) throws Exception {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		Message msg = null;
		
		try {
			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");

			
			
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);	
			ssm.doDelete(grid, true);
					
			Commit();
			
		} catch (Exception e) {
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		} finally {
		}

		return getSepoaOut();
	}
	
	
	
	
}