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
import sepoa.fw.util.SepoaStringTokenizer;



public class SR_003 extends SepoaService
{

    Message msg = null/*new Message("KO","STDPO")*/;

    private String ctrl_code    = info.getSession( "CTRL_CODE" );

    public SR_003(String opt,SepoaInfo info) throws SepoaServiceException
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
    
    public SepoaOut sgCheckItem(Map<String, Object> data){
        //Message msg = new Message(info.getSession( "LANGUAGE" ),"STDPO");
    	setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf=null;
		try {
			String bzz=(String) data.get("param");
			SepoaStringTokenizer st = new SepoaStringTokenizer((String)data.get("param"), ",", false);
			int row_cnt = st.countTokens();
			String[] value_data =new String[row_cnt];
			int count=0;
			for ( int j = 0 ; j < row_cnt ; j++ ) {
				Map<String, String> newMap = new HashMap<String, String>();
				value_data[j]=st.nextToken();
				newMap.put("item_code", value_data[j]);
				sxp = new SepoaXmlParser(this, "sgCheckItem");
				sxp.addVar("language", info.getSession("LANGUAGE"));
	        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	        	sf=new SepoaFormater(ssm.doSelect(newMap));
	        	String rtn="";
	        	if(sf != null  && sf.getRowCount() > 0){
	        		rtn=sf.getValue("cnt", 0);
	        		if(rtn.equals("1")){
	        			count++;
	        		}
	        	}
			}
			setValue(String.valueOf(count));
			
        	
		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }

    public SepoaOut setSgInsert(Map<String, Object> data) throws SepoaServiceException{
        //Message msg = new Message(info.getSession( "LANGUAGE" ),"STDPO");
    	setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf=null;
		try {
			String bzz=(String) data.get("param");
			SepoaStringTokenizer st = new SepoaStringTokenizer((String)data.get("param"), ",", false);
			int row_cnt = st.countTokens();
			String[] value_data =new String[row_cnt];
			//int count=0;
			for ( int j = 0 ; j < row_cnt ; j++ ) {
				Map<String, String> newMap = new HashMap<String, String>();
				value_data[j]=st.nextToken();
				newMap.put("item_code", value_data[j]);
				newMap.put("sg_refitem", (String)data.get("sg_refitem"));
				sxp = new SepoaXmlParser(this, "setSgUpdate");
				sxp.addVar("language", info.getSession("LANGUAGE"));
	        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	        	ssm.doUpdate(newMap);
	        	
	        	sxp = new SepoaXmlParser(this, "setSgInsert");
				sxp.addVar("language", info.getSession("LANGUAGE"));
	        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	        	ssm.doInsert(newMap);
			}
			
        	Commit();
		}catch (Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }
    
    public SepoaOut setSgDelete(Map<String, Object> data) throws Exception {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		try{
			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");

			Map<String, String> customHeader =  new HashMap<String, String>();	
			
			sxp = new SepoaXmlParser(this, "setSgDelete"); 
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


