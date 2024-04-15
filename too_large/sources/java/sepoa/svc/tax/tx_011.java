package sepoa.svc.tax;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.tcApi.OT870100;
import com.tcComm.ONCNF;

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
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

public class TX_011 extends SepoaService {
	Message msg = new Message(info, "TX_011");  // message 처리를 위해 전역변수 선언

	@SuppressWarnings("unused")
	public TX_011(String opt, SepoaInfo info) throws SepoaServiceException {
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
	
	public SepoaOut selectSpy1List(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
		String            rtn = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			rtn = this.select(ctx, "selectSpy1List", param);
			
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

	
	@SuppressWarnings("unchecked")
	public SepoaOut updateSpy1glBSNum(Map<String, String> data) throws Exception{
        ConnectionContext   ctx        = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx  = getConnectionContext();
		   this.update(ctx, "updateSpy1glBSNum", data);
            
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
	public SepoaOut updateSpy1glTcpState(Map<String, String> data) throws Exception{
        ConnectionContext   ctx        = null;
        SepoaOut            sepoaOut   = null;
        SepoaFormater       sf         = null;
        String              statusCd   = null;
        String              signerFlag = null;
		try {
			setStatus(1);
			setFlag(true);
			
			ctx  = getConnectionContext();
			
			//상태 조회
			sepoaOut = this.selectSpy1List(data);
			
			sf = new SepoaFormater(sepoaOut.result[0]);
			
			statusCd   = sf.getValue("STATUS_CD",   0);
			signerFlag = sf.getValue("SIGNER_FLAG", 0);
			
			if("01".equals(statusCd)){
				statusCd = "05";
			}
			else if("04".equals(statusCd)){
				if("Y".equals(signerFlag)){
					statusCd = "02";
				}
				else{
					statusCd = "06";
				}
			}
			data.put("status_cd", statusCd);
			this.update(ctx, "updateSpy1glTcpState", data);
            
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
	
	/**
	 * 인터페이스 헤더 정보를 등록하는 메소드
	 * 
	 * @param header
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfhdInfo(Map<String, String> header) throws Exception{
		ConnectionContext ctx   = null;
		String            infNo = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx   = getConnectionContext();
			infNo = this.getInfNo();
            
            header.put("INF_NO", infNo);
            
            this.insert(ctx, "insertSinfhdInfo", header);
			
			Commit();
			
			setValue(infNo);
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * 인터페이스 번호를 채번하는 메소드
	 * 
	 * @return String
	 * @throws Exception
	 */
	private String getInfNo() throws Exception{
		SepoaOut wo     = DocumentUtil.getDocNumber(info, "RFC");
		String   result = wo.result[0];
		
		return result;
	}
	
	/**
	 * 등록 메소드
	 * 
	 * @param ctx
	 * @param name
	 * @param param
	 * @return int
	 * @throws Exception
	 */
	private int insert(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		int             result = 0;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doInsert(param);
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut updateSpy1glExeTryDt(Map<String, String> data) throws Exception{
        ConnectionContext   ctx        = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx  = getConnectionContext();
		   this.update(ctx, "updateSpy1glExeTryDt", data);
            
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
	public SepoaOut updateSpy1glCcltTryDt(Map<String, String> data) throws Exception{
        ConnectionContext   ctx        = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx  = getConnectionContext();
		   this.update(ctx, "updateSpy1glCcltTryDt", data);
            
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
