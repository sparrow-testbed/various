package sepoa.svc.approval;

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
import sepoa.fw.util.SepoaString;


public class AP_024 extends SepoaService{
	
    public AP_024(String opt,SepoaInfo info) throws SepoaServiceException
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
    
    
	public SepoaOut getOpinion(Map<String, Object> data)
	{
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			header.put("company_code", MapUtils.getString(data, "company_code"));
			header.put("doc_type", MapUtils.getString(data, "doc_type"));
			header.put("doc_no", MapUtils.getString(data, "doc_no"));
			header.put("doc_seq", MapUtils.getString(data, "doc_seq"));
			
			sxp = new SepoaXmlParser(this, "getOpinion");
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
}