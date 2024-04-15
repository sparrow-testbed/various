package sepoa.svc.admin; 

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import wise.util.WiseApproval;
import wisecommon.SignResponseInfo;

public class IF_001 extends SepoaService
{
	private String ID = info.getSession("ID");

	public IF_001(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		setVersion("1.0.0");
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


	public SepoaOut insert_if_msg(Map<String, String> map) throws Exception
	{
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		Message msg = null;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try{
			int rtn = -1;

			
			sxp = new SepoaXmlParser(this, "insert_if_msg"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			
			rtn = ssm.doDelete(map);
			
			
			if(rtn<1){
				setStatus(0);
				Rollback();
				throw new Exception("UPDATE ICOMSCTM ERROR");
			}else{
				setStatus(1);
				Commit();
			}
			
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
