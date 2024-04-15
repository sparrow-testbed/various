package sepoa.svc.procure;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.Session;

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



public class SR_023 extends SepoaService
{

    Message msg = null/*new Message("KO","STDPO")*/;

    private String ctrl_code    = info.getSession( "CTRL_CODE" );

    public SR_023(String opt,SepoaInfo info) throws SepoaServiceException
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
    
    public SepoaOut getEvaDetailList(String data){
        //Message msg = new Message(info.getSession( "LANGUAGE" ),"STDPO");
    	setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf=null;
		try {
			Map<String, String> newMap = new HashMap<String, String>();
			newMap.put("eval_refitem", data);
			sxp = new SepoaXmlParser(this, "getEvaDetailList");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	//sf= new SepoaFormater();
        	setValue(ssm.doSelect(newMap));
        	
		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }
    
    public SepoaOut getEvaList(Map<String, Object> data){
        //Message msg = new Message(info.getSession( "LANGUAGE" ),"STDPO");
    	setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf=null;
		try {
			Map<String, String> newMap = new HashMap<String, String>();
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			sxp = new SepoaXmlParser(this, "getEvaList");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	setValue(ssm.doSelect(header));
        	
		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }
    
	public SepoaOut getEvabdupd2(String eval_item_refitem)
	{
		String rtn = null;

		try
		{
			rtn = et_getEvabdupd2(eval_item_refitem);
			setValue(rtn);
			setStatus(1);
		}catch(Exception e){
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("ExpandTree faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();

	}
    		
	private String et_getEvabdupd2(String eval_item_refitem) throws Exception
	{
   		String rtn = null;
   		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
				
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("company_code", company_code);
		wxp.addVar("eval_item_refitem", eval_item_refitem);
		             
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
                     
		rtn = sm.doSelect((String[])null);
		return rtn;
	}    		
}


