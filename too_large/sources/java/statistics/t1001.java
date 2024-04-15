package	statistics;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.Base64;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.CryptoUtil;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import sepoa.fw.util.SepoaStringTokenizer;
import wisecommon.SignRequestInfo;

import com.tcTest2.tst_1; 

/* 현행화테스트 */

public class t1001 extends SepoaService
{
	public t1001(String opt,SepoaInfo info) throws SepoaServiceException
	{
		super(opt,info);
		setVersion("1.0.0");
	}
	
	public SepoaOut doSend(String param1) throws Exception
 	{				   
		try
      	{
      		setFlag(true);
      		
      		tst_1 t1 = new tst_1();
	    	setMessage(t1.sendMessage(param1));	        
	    		
			setStatus(1);    		
	        	    	
	    } catch(Exception e) {
	        try { Rollback(); }
	        catch(Exception d) {
	        	setFlag(false);
	        	setStatus(0);
	        }
//	        e.printStackTrace();
	        setFlag(false);
	        setStatus(0);
	        setMessage(e.getMessage());
	    }

	    return getSepoaOut();
	}
}


























