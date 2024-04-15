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

public class TX_010 extends SepoaService {
	Message msg = new Message(info, "TX_010");  // message 처리를 위해 전역변수 선언

	@SuppressWarnings("unused")
	public TX_010(String opt, SepoaInfo info) throws SepoaServiceException {
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
		} catch (ConfigurationException configurationexception) {
			Logger.sys.println("getConfig error : "
					+ configurationexception.getMessage());
		} catch (Exception exception) {
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
		
		result = ssm.doSelect(param); // 조회
		
		return result;
	}
	
	/*  거래명세서 목록 조회 (요약) */
	public SepoaOut getPayBugetExpense(Map<String, String> header) {
		try {
			String            house_code = info.getSession("HOUSE_CODE");
			String            rtnHD      = null;
			ConnectionContext ctx        = getConnectionContext();
			SepoaFormater     wf         = null;
			
			header.put("house_code", house_code);
			
			rtnHD = this.select(ctx, "bl_getPayBugetExpense", header);
			
			wf = new SepoaFormater(rtnHD);
			
			if(wf.getRowCount() == 0){
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

	/*  거래명세서 목록 조회 */
	public SepoaOut getPayBugetExpenseList(Map<String, String> header) {
		try {
			String            house_code = info.getSession("HOUSE_CODE");
			String            rtnHD      = null;
			ConnectionContext ctx        = getConnectionContext();
			SepoaFormater     wf         = null;
			
			header.put("house_code", house_code);
			
			rtnHD = this.select(ctx, "bl_getPayBugetExpenseList", header);
			
			wf = new SepoaFormater(rtnHD);
			
			if(wf.getRowCount() == 0){
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
	
	public SepoaOut updateSpy1glDelYn(Map<String, String> data) throws Exception{
        ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			this.update(ctx, "updateSpy1glDelYn", data);
			
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
	
	public SepoaOut updateSpy1glWebState(Map<String, String> data) throws Exception{
        ConnectionContext   ctx        = null;
        String              houseCode  = null;
        String              paySendNo  = null;
        Map<String, String> dbParam    = null;
        String                    id                               = info.getSession("ID");
        
		try {
			dbParam = new HashMap<String, String>();
			
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			houseCode = data.get("HOUSE_CODE");
			paySendNo = data.get("PAY_SEND_NO");
			
			dbParam.put("STATUS_CD",   "30");			
			dbParam.put("CHANGE_USER_ID",   id);			// 대금집행자 
			dbParam.put("HOUSE_CODE",  houseCode);
			dbParam.put("PAY_SEND_NO", paySendNo);
			
			//this.update(ctx, "updateSpy1glWebState", dbParam);
			this.update(ctx, "updateSpy1glWebStateVer2", dbParam);
			
			
			
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
	
	public SepoaOut updateSpy1glWebStateR(Map<String, String> data) throws Exception{
        ConnectionContext   ctx        = null;
        String              houseCode  = null;
        String              paySendNo  = null;
        Map<String, String> dbParam    = null;
        
		try {
			dbParam = new HashMap<String, String>();
			
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			houseCode = data.get("HOUSE_CODE");
			paySendNo = data.get("PAY_SEND_NO");
			
			dbParam.put("STATUS_CD",   "70");
			dbParam.put("HOUSE_CODE",  houseCode);
			dbParam.put("PAY_SEND_NO", paySendNo);
			
			this.update(ctx, "updateSpy1glWebStateR", dbParam);
			
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
	public SepoaOut updateSpy1glCancelback(Map<String, String> data) throws Exception{
        ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			this.update(ctx, "updateSpy1glCancelback", data);
			
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
	public SepoaOut updateIcoytxdtSpycheck(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx                              = null;
        Map<String, String>       header                           = null;
        Map<String, String>       dbParam                          = new HashMap<String, String>();
        Map<String, String>       spy1ListInfo                     = null;
        List<Map<String, String>> spy1List                         = null;
        String                    houseCode                        = null;
        String                    taxNo                            = null;
        String                    taxSeq                           = null;
        String                    selectIcoytxdtSpyCheckListResult = null;
        String                    id                               = info.getSession("ID");
        SepoaFormater             sf                               = null;
        int                       spy1ListSize                     = 0;
        int                       i                                = 0;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx          = getConnectionContext();
			header       = (Map<String, String>)data.get("header");
			spy1List     = (List<Map<String, String>>)data.get("spy1List");
			spy1ListSize = spy1List.size();
			
			for(i = 0; i < spy1ListSize; i++){
				spy1ListInfo = spy1List.get(i);
				houseCode    = spy1ListInfo.get("HOUSE_CODE");
				taxNo        = spy1ListInfo.get("TAX_NO");
				taxSeq       = spy1ListInfo.get("TAX_SEQ");
				
				dbParam.clear();
				dbParam.put("SPY_CHECK",  "Y");
				dbParam.put("HOUSE_CODE", houseCode);
				dbParam.put("TAX_NO",     taxNo);
				dbParam.put("TAX_SEQ",    taxSeq);
				
				this.update(ctx, "updateIcoytxdtSpycheck", dbParam);
				
				dbParam.clear();
				dbParam.put("HOUSE_CODE", houseCode);
				dbParam.put("TAX_NO",     taxNo);
				
				selectIcoytxdtSpyCheckListResult = this.select(ctx, "selectIcoytxdtSpyCheckList", dbParam);
			
				sf = new SepoaFormater(selectIcoytxdtSpyCheckListResult);
				
				if(sf.getRowCount() == 1){
					dbParam.clear();
					dbParam.put("CHANGE_USER_ID", id);
					dbParam.put("PROGRESS_CODE",  "E");
					dbParam.put("HOUSE_CODE",     houseCode);
					dbParam.put("TAX_NO",         taxNo);
					
					this.update(ctx, "updateIcoytxhdProgressCodes", dbParam);
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
}