package ict.sepoa.svc.co;

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

public class I_CO_008 extends SepoaService {
	private Message msg;

    public I_CO_008(String opt, SepoaInfo info) throws SepoaServiceException {
        super(opt, info);
        
        setVersion("1.0.0");
        
        msg = new Message(info,"p10_pra");
    }

	public String getConfig(String s){
	    try{
	        Configuration configuration = new Configuration();
	        
	        s = configuration.get(s);
	        
	        return s;
	    }
	    catch(ConfigurationException configurationexception){
	        Logger.sys.println("getConfig error : " + configurationexception.getMessage());
	    }
	    catch(Exception exception){
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
	
	@SuppressWarnings("unused")
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
	
	@SuppressWarnings("unused")
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
	
	@SuppressWarnings("unused")
	private int delete(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		int             result = 0;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doDelete(param);
		
		return result;
	}
	
	private String nvl(String str, String defaultValue) throws Exception{
		String result = null;
		
		if(str == null){
			str = "";
		}
		
		if(str.equals("")){
			result = defaultValue;
		}
		else{
			result = str;
		}
		
		return result;
	}
	
	public SepoaOut selectUserList(Map<String, String> header){
		ConnectionContext ctx = null;
		String            rtn = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			rtn = this.select(ctx, "selectUserList", header);
			
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
	
	private String getMemberName(String selectedName, String originalName, String userId) throws Exception{
		String       result       = null;
		StringBuffer stringBuffer = new StringBuffer();
		
		result = this.nvl(selectedName, originalName);
		
		stringBuffer.append(result).append("(").append(userId).append(")");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	private StringBuffer getUserInfo(ConnectionContext ctx, StringBuffer stringBuffer, String managerNo, String managerName) throws Exception{
		Map<String, String> selectParam   = new HashMap<String, String>();
		String              houseCode     = info.getSession("HOUSE_CODE");
		String              companyCode   = info.getSession("COMPANY_CODE");
		String              selectResult  = null;
		String              userNameLoc   = null;
		SepoaFormater       sepoaFormater = null;
		int                 selectCount   = 0;
		
		selectParam.put("HOUSE_CODE",   houseCode);
		selectParam.put("COMPANY_CODE", companyCode);
		selectParam.put("USER_ID",      managerNo);
		
		selectResult = this.select(ctx, "selectUserList", selectParam);
		
		sepoaFormater = new SepoaFormater(selectResult);
    	
		selectCount = sepoaFormater.getRowCount();
		
		if(selectCount == 0){
			managerName = this.getMemberName("", managerName, managerNo);
		}
		else{
			userNameLoc = sepoaFormater.getValue("USER_NAME_LOC", 0);
			managerName = this.getMemberName(userNameLoc, managerName, managerNo);
		}
		
		stringBuffer.append("{");
		stringBuffer.append(	"managerNo:'").append(managerNo).append("',");
		stringBuffer.append(	"managerName:'").append(managerName).append("'");
		stringBuffer.append("}");
		
		return stringBuffer;
	}
	
	public SepoaOut selectDeviceUserJsonList(Map<String, String> param){
		ConnectionContext ctx                   = null;
		String            rtn                   = null;
		String            managerInfo           = null;
		String            managerArrayInfo      = null;
		String            managerNo             = null;
		String            managerName           = null;
		String            deviceUserInfo        = null;
		StringBuffer      stringBuffer          = new StringBuffer();
		String[]          deviceUserInfoArray   = null;
		String[]          managerArray          = null;
		String[]          managerArrayInfoArray = null;
		int               i                     = 0;
		int               managerArrayLength    = 0;
		
		try{
			setStatus(1);
			setFlag(true);
			
			stringBuffer.append("[");
			
			//deviceUserInfo = "3120644|0:19611796:직원명:과장:박용범3740_3:10,0:A6440019:직원명:차장:CHUNGJIHOON:10,";
			//deviceUserInfo = "3120644|0:19611796:직원명:과장:박용범3740_3:10,0:19116877:직원명:차장:CHUNGJIHOON:10,";
			//deviceUserInfo = "3120644|0:19611796:직원명:과장:박용범3740_3:10,";
			//deviceUserInfo = "3 정의된 Error Message가 없습니다.0";
			
			ctx                 = getConnectionContext();
			deviceUserInfo      = param.get("deviceUserInfo");
			deviceUserInfoArray = deviceUserInfo.split("\\|");
			managerInfo         = deviceUserInfoArray[1];
			managerArray        = managerInfo.split(",");
			managerArrayLength  = managerArray.length;
			managerArrayLength  = managerArrayLength - 1;
			
			for(i = 0; i < managerArrayLength; i++){
				managerArrayInfo      = managerArray[i];
				managerArrayInfoArray = managerArrayInfo.split(":");
				managerNo             = managerArrayInfoArray[1];
				managerName           = managerArrayInfoArray[4];
				stringBuffer          = this.getUserInfo(ctx, stringBuffer, managerNo, managerName);
				
				if(i != (managerArrayLength - 1)){
					stringBuffer.append(",");
				}
			}
			
			stringBuffer.append("]");
			
			rtn = stringBuffer.toString();
			
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
}