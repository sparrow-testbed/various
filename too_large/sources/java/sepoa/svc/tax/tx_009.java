package sepoa.svc.tax; 

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

public class TX_009 extends SepoaService {
	Message msg = new Message(info, "TX_009");  // message 처리를 위해 전역변수 선언

	@SuppressWarnings("unused")
	public TX_009(String opt, SepoaInfo info) throws SepoaServiceException {
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
		catch(ConfigurationException configurationexception) {
			Logger.sys.println("getConfig error : " + configurationexception.getMessage());
		}
		catch (Exception exception) {
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}
		
		return null;
	}
	
	private String select(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          result = null;
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doSelect(param);
		
		return result;
	}
	
	private int update(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		int             result = 0;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doUpdate(param);
		
		return result;
	}
	
	/*  거래명세서 목록 조회 */
	public SepoaOut getPayBugetGiveList(Map<String, String> header) {
		try {
			ConnectionContext ctx = getConnectionContext();
			String house_code = info.getSession("HOUSE_CODE");
			
			header.put("house_code", house_code);
			
			String rtnHD = this.select(ctx, "bl_getPayBugetGiveList", header);
			
			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
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
	
	public SepoaOut selectSpy1glInfo(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
		String            rtn = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			rtn = this.select(ctx, "selectSpy1glInfo", param);
			
			setValue(rtn);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		
		return getSepoaOut();
	}
	
	public SepoaOut selectSpy1lnList(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
		String            rtn = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			rtn = this.select(ctx, "selectSpy1lnList", param);
			
			setValue(rtn);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		
		return getSepoaOut();
	}
	
	private void updateSpy1glManualAccountKindUpdateIcoytxdtSpycheck(ConnectionContext ctx, SepoaFormater sf, int j) throws Exception{
		String              houseCode      = sf.getValue("HOUSE_CODE", j);
		String              taxNo          = sf.getValue("TAX_NO",     j);
		String              taxSeq         = sf.getValue("TAX_SEQ",    j);
		String              spyCheckResult = null;
		String              id             = info.getSession("ID");
		Map<String, String> dbParam        = new HashMap<String, String>();
		SepoaFormater       sf2            = null;
		int                 rowCount2      = 0;
    	
    	dbParam.put("SPY_CHECK",  "Y");
    	dbParam.put("HOUSE_CODE", houseCode);
    	dbParam.put("TAX_NO",     taxNo);
    	dbParam.put("TAX_SEQ",    taxSeq);
    	
    	this.update(ctx, "updateIcoytxdtSpycheck", dbParam);
    	
    	dbParam.clear();
    	dbParam.put("HOUSE_CODE", houseCode);
    	dbParam.put("TAX_NO",     taxNo);
    	
    	spyCheckResult = this.select(ctx, "selectIcoytxdtSpyCheckList", dbParam);
    	
    	sf2 = new SepoaFormater(spyCheckResult);
    	
    	rowCount2 = sf2.getRowCount();
    	
    	if(rowCount2 == 1){
    		dbParam.clear();
    		dbParam.put("CHANGE_USER_ID", id);
    		dbParam.put("PROGRESS_CODE",  "E");
        	dbParam.put("HOUSE_CODE",     houseCode);
        	dbParam.put("TAX_NO",         taxNo);
        	
        	this.update(ctx, "updateIcoytxhdProgressCodes", dbParam);
    	}
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut updateSpy1glManualAccountKind(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx        = null;
		List<Map<String, String>> grid       = null;
		Map<String, String>       gridInfo   = null;
		Map<String, String>       dbParam    = null;
		String                    paySendNo  = null;
		String                    listResult = null;
		SepoaFormater             sf         = null;
		int                       gridSize   = 0;
		int                       rowCount   = 0;
		int                       i          = 0;
		int                       j          = 0;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx      = getConnectionContext();
			grid     = (List<Map<String, String>>)data.get("gridData");
			gridSize = grid.size();
			
			for(i = 0; i < gridSize; i++) {
				dbParam = new HashMap<String, String>();
				
				gridInfo  = grid.get(i);
				paySendNo = gridInfo.get("PAY_SEND_NO");
				
                this.update(ctx, "updateSpy1glManualAccountKind", gridInfo);
                
                dbParam.put("PAY_SEND_NO", paySendNo);
                
                listResult = this.select(ctx, "selectSpy1List", dbParam);
                
                sf = new SepoaFormater(listResult);
                
                rowCount = sf.getRowCount();
                
                for(j = 0; j < rowCount; j++){
                	this.updateSpy1glManualAccountKindUpdateIcoytxdtSpycheck(ctx, sf, j);
                }
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }
	
	@SuppressWarnings("unchecked")
	public SepoaOut updateSpy1glStatusCd03(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx      = null;
		List<Map<String, String>> grid     = null;
		Map<String, String>       gridInfo = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx  = getConnectionContext();
			grid = (List<Map<String, String>>)data.get("gridData");
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
                this.update(ctx, "updateSpy1glStatusCd03", gridInfo);
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }
	
	public SepoaOut updateSpy1glManualAccountKindCancle(Map<String, String> data) throws Exception{
        ConnectionContext ctx = null;
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			this.update(ctx, "updateSpy1glManualAccountKindCancle", data);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }
	
	@SuppressWarnings("unchecked")
	public SepoaOut updateSpy1glRtnSignerNo(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx      = null;
		List<Map<String, String>> grid     = null;
		Map<String, String>       gridInfo = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx  = getConnectionContext();
			grid = (List<Map<String, String>>)data.get("gridData");
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
                this.update(ctx, "updateSpy1glRtnSignerNo", gridInfo);
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }
	
	@SuppressWarnings("unchecked")
	public SepoaOut updateSpy1gInfoBeforeSign(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx      = null;
		List<Map<String, String>> grid     = null;
		Map<String, String>       gridInfo = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx  = getConnectionContext();
			grid = (List<Map<String, String>>)data.get("gridData");
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
                this.update(ctx, "updateSpy1gInfoBeforeSign", gridInfo);
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }
	
	@SuppressWarnings("unchecked")
	public SepoaOut updateSpy1gInfoBeforeSignReject(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx      = null;
		List<Map<String, String>> grid     = null;
		Map<String, String>       gridInfo = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx  = getConnectionContext();
			grid = (List<Map<String, String>>)data.get("gridData");
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
                this.update(ctx, "updateSpy1gInfoBeforeSignReject", gridInfo);
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }
} // END