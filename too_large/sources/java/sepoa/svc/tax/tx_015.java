package sepoa.svc.tax;

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
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import wisecommon.SignRequestInfo;
import wisecommon.SignResponseInfo;
//import erp.ERPInterface;

public class TX_015 extends SepoaService {
	Message msg = new Message(info, "TX_015");  // message 처리를 위해 전역변수 선언

	public TX_015(String opt, SepoaInfo info) throws SepoaServiceException {
    	super(opt, info);
    	
		setVersion("1.0.0");
		
		Configuration configuration = null;

		try {
			configuration = new Configuration();
		}
		catch(ConfigurationException cfe) {
			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + cfe.getMessage());
		}
		catch(Exception e) {
			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + e.getMessage());
		}
    }

	/**
	 * @Method Name : getConfig
	 * @작성일 : 2011. 12. 10
	 * @작성자 :
	 * @변경이력 :
	 * @Method 설명 :
	 * @param s
	 * @return
	 */
	public String getConfig(String s) {
		try {
			Configuration configuration = new Configuration();
			
			s = configuration.get(s);
			
			return s;
		}
		catch (ConfigurationException configurationexception) {
			Logger.sys.println("getConfig error : "
					+ configurationexception.getMessage());
		}
		catch (Exception exception) {
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}
		
		return null;
	}

	
	/*  거래명세서 목록 조회 */
	public SepoaOut getPayList(Map<String, String> header) {
		try {
			String house_code = info.getSession("HOUSE_CODE");
			
			header.put("house_code", house_code);
			
			String rtnHD = bl_getPayList(header);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			
			if (wf.getRowCount() == 0){
				setMessage(msg.getMessage("0000"));
			}
			else {
				setMessage(msg.getMessage("7000"));
			}
			
			setStatus(1);
			setValue(rtnHD);
		}
		catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			
			setStatus(0);
		}
		
		return getSepoaOut();
	}
	
	private String bl_getPayList(Map<String, String> header) throws Exception {
		String            rtn = "";
		ConnectionContext ctx = getConnectionContext();
		
		try {
			SepoaXmlParser  wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			
			rtn = sm.doSelect(header);
		}
		catch (Exception e) {
			throw new Exception("bl_getPayList:" + e.getMessage());
		}
		finally {}
		
		return rtn;
	}
} // END