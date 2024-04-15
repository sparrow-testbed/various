package sepoa.svc.tax;
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

public class TX_016 extends SepoaService {
	Message msg = new Message(info, "TX_014");  // message 처리를 위해 전역변수 선언

	public TX_016(String opt, SepoaInfo info) throws SepoaServiceException {
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
			Logger.sys.println("getConfig error : " + configurationexception.getMessage());
		}
		catch (Exception exception) {
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}
		
		return null;
	}

	public SepoaOut getPayAuditList(Map<String, String> header) {
		try {
			String house_code = info.getSession("HOUSE_CODE");
			
			header.put("house_code", house_code);
			
			String rtnHD = bl_getPayAuditList(header);

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
		catch (Exception e){
			Logger.err.println(userid, this, e.getMessage());
			
			setStatus(0);
		}
		
		return getSepoaOut();
	}
	
	public SepoaOut getPayCostList(Map<String, String> header) {
		try {
			String house_code = info.getSession("HOUSE_CODE");
			
			header.put("house_code", house_code);
			
			String rtnHD = bl_getPayCostList(header);
			
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
		catch (Exception e){
			Logger.err.println(userid, this, e.getMessage());
			
			setStatus(0);
		}
		
		return getSepoaOut();
	}
	
	public SepoaOut getPayAuditListPop(Map<String, String> header) {
		try {
			String house_code = info.getSession("HOUSE_CODE");
			
			header.put("house_code", house_code);
			
			String rtnHD = bl_getPayAuditListPop(header);

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
		catch (Exception e){
			Logger.err.println(userid, this, e.getMessage());
			
			setStatus(0);
		}
		
		return getSepoaOut();
	}
	
	private String bl_getPayAuditList(Map<String, String> header) throws Exception {
		String            rtn = "";
		ConnectionContext ctx = getConnectionContext();
		
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			
			rtn = sm.doSelect(header);
		}
		catch (Exception e) {
			throw new Exception("bl_getPayAuditList:" + e.getMessage());
		}
		finally {}
		
		return rtn;
	}
	
	private String bl_getPayAuditListPop(Map<String, String> header) throws Exception {
		String            rtn = "";
		ConnectionContext ctx = getConnectionContext();
		
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			
			rtn = sm.doSelect(header);
		}
		catch (Exception e) {
			throw new Exception("bl_getPayAuditListPop:" + e.getMessage());
		}
		finally {}
		
		return rtn;
	}
	
	private String bl_getPayCostList(Map<String, String> header) throws Exception {
		String            rtn = "";
		ConnectionContext ctx = getConnectionContext();
		
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			
			rtn = sm.doSelect(header);
		}
		catch (Exception e) {
			throw new Exception("bl_getPayAuditList:" + e.getMessage());
		}
		finally {}
		
		return rtn;
	}
	
	public SepoaOut doAudit(Map<String, Object> data) {
		
		SepoaXmlParser			  	wxp 		= null;
		Map<String, String> 	  	header		= null;
        Map<String, String> 	 	gridInfo	= null;
        List<Map<String, String>> 	grid        = null;
        
        ConnectionContext 		  	ctx 		= getConnectionContext();
        SepoaSQLManager 		  	sm 			= null;
		
		try {
			
			header = MapUtils.getMap(data, "headerData");
			
			String house_code = info.getSession("HOUSE_CODE");
			header.put("house_code", house_code);
			
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			
			if(grid != null && grid.size() > 0){
				for(int i = 0 ; i < grid.size() ; i++){
					gridInfo = grid.get(i);
					
					if("S".equals( gridInfo.get("PAY_TYPE"))){
						wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_PY1LN");
					}else if("A".equals( gridInfo.get("PAY_TYPE"))){
						wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_PY2LN");
					}
					
					sm = new SepoaSQLManager(userid,this,ctx,(wxp != null)?wxp.getQuery():"");
					sm.doInsert(gridInfo);
				}
			}
			Commit();
			setStatus(1);
		}
		catch (Exception e){
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	public SepoaOut doCost(Map<String, Object> data) {
		
		SepoaXmlParser			  	wxp 		= null;
		Map<String, String> 	  	header		= null;
		Map<String, String> 	 	gridInfo	= null;
		List<Map<String, String>> 	grid        = null;
		
		ConnectionContext 		  	ctx 		= getConnectionContext();
		SepoaSQLManager 		  	sm 			= null;
		
		try {
			
			header = MapUtils.getMap(data, "headerData");
			
			String house_code = info.getSession("HOUSE_CODE");
			header.put("house_code", house_code);
			
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			
			if(grid != null && grid.size() > 0){
				for(int i = 0 ; i < grid.size() ; i++){
					gridInfo = grid.get(i);
					
					wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
					sm.doInsert(gridInfo);
				}
			}
			Commit();
			setStatus(1);
		}
		catch (Exception e){
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
} // END