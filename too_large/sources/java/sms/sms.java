package sms;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import sepoa.fw.cfg.Configuration;
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
import sepoa.fw.util.SepoaFormater;
import ucMessage.UcMessage;

public class SMS extends SepoaService {
	private Configuration conf = null;
	@SuppressWarnings("unused")
	private Message       msg  = null;
	private String  KEY_NUMBER     = "0215885000";
	
	public SMS(String opt, SepoaInfo info) throws Exception {
		super(opt, info);
		setVersion("1.0.0");
		
		this.conf = new Configuration(); 
		this.msg  = new Message(info, "STDCOMM");
	}
	
	@SuppressWarnings("unused")
	private String nvl(String str) throws Exception{
		String result = null;
		
		result = this.nvl(str, "");
		
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
	
	private String getExceptionStackTrace(Exception e){
		Writer      writer      = null;
		PrintWriter printWriter = null;
		String      s           = null;
		
		writer      = new StringWriter();
		printWriter = new PrintWriter(writer);
		
		e.printStackTrace(printWriter);
		
		s = writer.toString();
		
		return s;
	}
	
	private void loggerExceptionStackTrace(Exception e){
		String trace = this.getExceptionStackTrace(e);
		
		Logger.err.println(trace);
	}
	
	@SuppressWarnings("rawtypes")
	private void loggerDebugMap(Map map) throws Exception{
	    Iterator value       = map.values().iterator();
	    Iterator key         = map.keySet().iterator();
	    Object   valueObject = null;
	              
	    Logger.debug.println();
	    
	    while(value.hasNext()){
	    	valueObject = value.next();
	    	
	    	if(valueObject != null){
	    		Logger.debug.println("map key : >" + key.next() + "<, value : >" + valueObject.toString() + "< value is String : >" + (valueObject instanceof String) + "<");  
	    	}
	    	else{
	    		Logger.debug.println("map key : >" + key.next() + "<, value : null");
	    	}
	    }
	    
	    Logger.debug.println();
	}
	
	private String getInfNo() throws Exception{
		SepoaOut wo     = DocumentUtil.getDocNumber(info, "RFC");
		String   result = wo.result[0];
		
		return result;
	}
	
	private String getStringMaxByte(String target, int maxLength){
    	byte[] targetByteArray       = target.getBytes();
    	int    targetByteArrayLength = targetByteArray.length;
    	int    targetLength          = 0;
    	
    	while(targetByteArrayLength > maxLength){
    		targetLength          = target.length();
    		targetLength          = targetLength - 1;
    		target                = target.substring(0, targetLength);
    		targetByteArray       = target.getBytes();
    		targetByteArrayLength = targetByteArray.length;
    	}
    	
    	return target;
    }
	
	@SuppressWarnings("unchecked")
	private void smsAgentInsertInfo(ConnectionContext connectionContext, Map<String, Object> smsParam, int i) throws Exception{
		Map<String, String> param         = new HashMap<String, String>();
		List<String>        destPhone     = (List<String>)smsParam.get("destPhone");
		String              destPhoneInfo = null;
		String              id            = info.getSession("ID");
		String              department    = info.getSession("DEPARTMENT");
		String              bizId1        = (String)smsParam.get("bizId1");
		String              bizId2        = (String)smsParam.get("bizId2");
		String              sendPhone     = (String)smsParam.get("sendPhone");
		String              msgBody       = (String)smsParam.get("msgBody");
		int                 rtn           = 0;
		String              ums_tmpl_cd   = (String)smsParam.get("UMS_TMPL_CD"); //TOBE 2017-07-01 추가 UMS 템플릿 코드
		String              mpng_1        = (String)smsParam.get("MPNG_1");      //TOBE 2017-07-01 추가 매핑_1
		String              mpng_2        = (String)smsParam.get("MPNG_2");      //TOBE 2017-07-01 추가 매핑_2
		String              mpng_3        = (String)smsParam.get("MPNG_3");      //TOBE 2017-07-01 추가 매핑_3
		
		
		destPhoneInfo = destPhone.get(i);
		
		if(destPhoneInfo == null){
			destPhoneInfo = "0";
		}
		
		if("0".equals(destPhoneInfo) == false){
			param.put("TR_USER_ID",  id);
			param.put("TR_PLACE",    department);
			param.put("TR_BIZ_ID1",  bizId1);
			param.put("TR_BIZ_ID2",  bizId2);
			param.put("TR_DESTADDR", destPhoneInfo);
			param.put("TR_CALLBACK", sendPhone);
			param.put("TR_MSG",      msgBody);
			
			//TOBE 2017-07-01 추가
			param.put("UMS_TMPL_CD", ums_tmpl_cd);
			param.put("MPNG_1",      mpng_1);
			param.put("MPNG_2",      mpng_2);
			param.put("MPNG_3",      mpng_3);
			
			this.loggerDebugMap(param);
			
			rtn = this.insert(connectionContext, "smsAgentInsert", param);
			
			if(rtn < 0){
				Logger.err.println("[SMS_DATA] 에 데이터가 입력되지 않았습니다.");
			}
		}
		else{
			Logger.err.println("대상 번호가 존재하지 않습니다.");
		}
	}
	
	@SuppressWarnings("unchecked")
	private String smsAgentInsertInfInsert(ConnectionContext connectionContext, Map<String, Object> smsParam, int i) throws Exception{
		Map<String, String> infParam      = new HashMap<String, String>();
		String              houseCode     = info.getSession("HOUSE_CODE");
		String              id            = info.getSession("ID");
		String              department    = info.getSession("DEPARTMENT");
		String              infNo         = this.getInfNo();
		String              infCode       = (String)smsParam.get("infCode");
		String              bizId1        = (String)smsParam.get("bizId1");
		String              bizId2        = (String)smsParam.get("bizId2");
		String              sendPhone     = (String)smsParam.get("sendPhone");
		String              msgBody       = (String)smsParam.get("msgBody");
		String              destPhoneInfo = null;
		List<String>        destPhone     = (List<String>)smsParam.get("destPhone");
		
		destPhoneInfo = destPhone.get(i);
		
		infParam.put("HOUSE_CODE", houseCode);
		infParam.put("INF_NO",     infNo);
		infParam.put("INF_TYPE",   "S");
		infParam.put("INF_CODE",   infCode);
		infParam.put("INF_SEND",   "S");
		infParam.put("INF_ID",     id);

		this.insert(connectionContext, "insertSinfhdInfo", infParam);
		
		infParam.clear();
		
		infParam.put("HOUSE_CODE", houseCode);
		infParam.put("INF_NO",     infNo);
		infParam.put("ID",         id);
		infParam.put("DEPARTMENT", department);
		infParam.put("BIZID1",     bizId1);
		infParam.put("BIZID2",     bizId2);
		infParam.put("DESTADDR",   destPhoneInfo);
		infParam.put("CALLBACK",   sendPhone);
		infParam.put("MSG",        msgBody);
		
		this.insert(connectionContext, "insertSinfsmsInfo", infParam);
		
		return infNo;
	}
	
	private void smsAgentInsertInfUpdate(ConnectionContext connectionContext, Map<String, String> param) throws Exception{
		String              status    = param.get("status");
		String              reason    = param.get("reason");
		String              infNo     = param.get("infNo");
		String              houseCode = info.getSession("HOUSE_CODE");
		Map<String, String> smsParam  = new HashMap<String, String>();
		
		smsParam.put("STATUS",         status);
		smsParam.put("REASON",         reason);
		smsParam.put("HOUSE_CODE",     houseCode);
		smsParam.put("INF_NO",         infNo);
		smsParam.put("INF_RECEIVE_NO", infNo);
		
		this.update(connectionContext, "updateSinfhdInfo", smsParam);
	}
	
	@SuppressWarnings("unchecked")
	private void smsAgentInsert(ConnectionContext connectionContext, Map<String, Object> smsParam) throws Exception{
		List<String>        destPhone         = (List<String>)smsParam.get("destPhone");
		String              infNo             = null;
		String              stackTrace        = null;
		Map<String, String> infParam          = new HashMap<String, String>();
		boolean             insertSms         = false;
		int                 destPhoneSize     = 0;
		int                 i                 = 0;
		
		if(destPhone != null){
			destPhoneSize = destPhone.size();
		}
		
		insertSms = conf.getBoolean("Sepoa.insert_sms");
		
		if(insertSms){
			for(i = 0 ; i < destPhoneSize; i++){
				try{
					infNo = this.smsAgentInsertInfInsert(connectionContext, smsParam, i);
					
					this.smsAgentInsertInfo(connectionContext, smsParam, i);
					
					infParam.clear();
					infParam.put("status", "Y");
					infParam.put("reason", "");
					infParam.put("infNo",  infNo);
					
					this.smsAgentInsertInfUpdate(connectionContext, infParam);
				}
				catch(Exception e){
					this.loggerExceptionStackTrace(e);
					
					stackTrace = this.getExceptionStackTrace(e);
					stackTrace = this.getStringMaxByte(stackTrace, 4000);
					
					infParam.clear();
					infParam.put("status", "N");
					infParam.put("reason", stackTrace);
					infParam.put("infNo",  infNo);
					
					try{
						this.smsAgentInsertInfUpdate(connectionContext, infParam);
					}
					catch(Exception e1){
						this.loggerExceptionStackTrace(e1);
					}
				}
				finally{
					Commit();
				}
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	private void tlkAgentInsert(ConnectionContext connectionContext, Map<String, Object> tlkParam) throws Exception{
		List<String>        destPhone         = (List<String>)tlkParam.get("destPhone");
		String              infNo             = null;
		String              stackTrace        = null;
		Map<String, String> infParam          = new HashMap<String, String>();
		boolean             insertSms         = false;
		int                 destPhoneSize     = 0;
		int                 i                 = 0;
		
		if(destPhone != null){
			destPhoneSize = destPhone.size();
		}
		
		insertSms = conf.getBoolean("Sepoa.insert_sms");
		
		if(insertSms){
			for(i = 0 ; i < destPhoneSize; i++){
				try{
					infNo = this.tlkAgentInsertInfInsert(connectionContext, tlkParam, i);
					
					this.tlkAgentInsertInfo(connectionContext, tlkParam, i);
					
					infParam.clear();
					infParam.put("status", "Y");
					infParam.put("reason", "");
					infParam.put("infNo",  infNo);
					
					this.tlkAgentInsertInfUpdate(connectionContext, infParam);
				}
				catch(Exception e){
					this.loggerExceptionStackTrace(e);
					
					stackTrace = this.getExceptionStackTrace(e);
					stackTrace = this.getStringMaxByte(stackTrace, 4000);
					
					infParam.clear();
					infParam.put("status", "N");
					infParam.put("reason", stackTrace);
					infParam.put("infNo",  infNo);
					
					try{
						this.tlkAgentInsertInfUpdate(connectionContext, infParam);
					}
					catch(Exception e1){
						this.loggerExceptionStackTrace(e1);
					}
				}
				finally{
					Commit();
				}
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	private String tlkAgentInsertInfInsert(ConnectionContext connectionContext, Map<String, Object> smsParam, int i) throws Exception{
		Map<String, String> infParam      = new HashMap<String, String>();
		String              houseCode     = info.getSession("HOUSE_CODE");
		String              id            = info.getSession("ID");
		String              department    = info.getSession("DEPARTMENT");
		String              infNo         = this.getInfNo();
		String              infCode       = (String)smsParam.get("infCode");
		String              bizId1        = (String)smsParam.get("bizId1");
		String              bizId2        = (String)smsParam.get("bizId2");
		String              sendPhone     = (String)smsParam.get("sendPhone");
		String              msgBody       = (String)smsParam.get("msgBody");
		String              destPhoneInfo = null;
		List<String>        destPhone     = (List<String>)smsParam.get("destPhone");
		
		destPhoneInfo = destPhone.get(i);
		
		infParam.put("HOUSE_CODE", houseCode);
		infParam.put("INF_NO",     infNo);
		infParam.put("INF_TYPE",   "B");
		infParam.put("INF_CODE",   infCode);
		infParam.put("INF_SEND",   "S");
		infParam.put("INF_ID",     id);

		this.insert(connectionContext, "insertSinfhdInfo", infParam);
		
		infParam.clear();
		
		infParam.put("HOUSE_CODE", houseCode);
		infParam.put("INF_NO",     infNo);
		infParam.put("ID",         id);
		infParam.put("DEPARTMENT", department);
		infParam.put("BIZID1",     bizId1);
		infParam.put("BIZID2",     bizId2);
		infParam.put("DESTADDR",   destPhoneInfo);
		infParam.put("CALLBACK",   sendPhone);
		infParam.put("MSG",        msgBody);
		
		this.insert(connectionContext, "insertSinftlkInfo", infParam);
		
		return infNo;
	}
	
	private void tlkAgentInsertInfUpdate(ConnectionContext connectionContext, Map<String, String> param) throws Exception{
		String              status    = param.get("status");
		String              reason    = param.get("reason");
		String              infNo     = param.get("infNo");
		String              houseCode = info.getSession("HOUSE_CODE");
		Map<String, String> smsParam  = new HashMap<String, String>();
		
		smsParam.put("STATUS",         status);
		smsParam.put("REASON",         reason);
		smsParam.put("HOUSE_CODE",     houseCode);
		smsParam.put("INF_NO",         infNo);
		smsParam.put("INF_RECEIVE_NO", infNo);
		
		this.update(connectionContext, "updateSinfhdInfo", smsParam);
	}
	
	@SuppressWarnings("unchecked")
	private void tlkAgentInsertInfo(ConnectionContext connectionContext, Map<String, Object> tlkParam, int i) throws Exception{
		Map<String, String> param         = new HashMap<String, String>();
		List<String>        destPhone     = (List<String>)tlkParam.get("destPhone");
		String              destPhoneInfo = null;
		String              id            = info.getSession("ID");
		String              department    = info.getSession("DEPARTMENT");
		String              bizId1        = (String)tlkParam.get("bizId1");
		String              bizId2        = (String)tlkParam.get("bizId2");
		String              sendPhone     = (String)tlkParam.get("sendPhone");
		String              msgBody       = (String)tlkParam.get("msgBody");
		int                 rtn           = 0;
		String              ums_tmpl_cd   = (String)tlkParam.get("UMS_TMPL_CD"); //TOBE 2017-07-01 추가 UMS 템플릿 코드
		String              mpng_1        = (String)tlkParam.get("MPNG_1");      //TOBE 2017-07-01 추가 매핑_1
		String              mpng_2        = (String)tlkParam.get("MPNG_2");      //TOBE 2017-07-01 추가 매핑_2
		String              mpng_3        = (String)tlkParam.get("MPNG_3");      //TOBE 2017-07-01 추가 매핑_3
		String              ums_sms_cnvsd_yn = (String)tlkParam.get("UMS_SMS_CNVSD_YN");   //TOBE 2018-11-01 UMSSMS전환발송여부
		                    
		
		destPhoneInfo = destPhone.get(i);
		
		if(destPhoneInfo == null){
			destPhoneInfo = "0";
		}
		
		if("0".equals(destPhoneInfo) == false){
			param.put("TR_USER_ID",  id);
			param.put("TR_PLACE",    department);
			param.put("TR_BIZ_ID1",  bizId1);
			param.put("TR_BIZ_ID2",  bizId2);
			param.put("TR_DESTADDR", destPhoneInfo);
			param.put("TR_CALLBACK", sendPhone);
			param.put("TR_MSG",      msgBody);
			
			//TOBE 2017-07-01 추가
			param.put("UMS_TMPL_CD", ums_tmpl_cd);
			param.put("MPNG_1",      mpng_1);
			param.put("MPNG_2",      mpng_2);
			param.put("MPNG_3",      mpng_3);
			
			//TOBE 2018-11-01 추가			
			param.put("UMS_SMS_CNVSD_YN",      ums_sms_cnvsd_yn);
			
			this.loggerDebugMap(param);
			
			rtn = this.insert(connectionContext, "tlkAgentInsert", param);
			
			if(rtn < 0){
				Logger.err.println("[SMS_DATA] 에 데이터가 입력되지 않았습니다.");
			}
		}
		else{
			Logger.err.println("대상 번호가 존재하지 않습니다.");
		}
	}
	
	public SepoaOut smsTest1(Map<String, String> param) throws Exception{
		String              smsMsg            = null;
		String              title             = param.get("title");
		String              content           = param.get("content");
		ConnectionContext   connectionContext = getConnectionContext();
		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, Object> smsParam          = new HashMap<String, Object>();
		SepoaFormater       sepoaFormater     = null;
		List<String>        destPhone         = new ArrayList<String>();
		
		msgParam.put("CODE", "T1");
		
		this.loggerDebugMap(msgParam);
		
		smsMsg = this.select(connectionContext, "selectSmsMsg", msgParam);
		
		sepoaFormater = new SepoaFormater(smsMsg);
		
		smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
		smsMsg = smsMsg.replace("${title}",   title);
		smsMsg = smsMsg.replace("${content}", content);
		
		destPhone.add("01049435524");
		destPhone.add("01049435524");
		
		smsParam.put("sendPhone", "01049435524");
		smsParam.put("msgBody",   smsMsg);
		smsParam.put("bizId1",    "GEN");
		smsParam.put("bizId2",    "ELBID");
		smsParam.put("destPhone", destPhone);
		smsParam.put("infCode",   "T1");
		
		//TOBE 2017-07-01 추가
		smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001601");
		smsParam.put("MPNG_1", title);
		smsParam.put("MPNG_2", content);
		smsParam.put("MPNG_3", "");
		
		this.smsAgentInsert(connectionContext, smsParam);
		
		return getSepoaOut();
	}
	
	public SepoaOut rqApplyE(Map<String, String> param){
		String              smsMsg            = null;
		String              destResult        = null;
		String              destPhoneInfo     = null;
		String              sourcingName      = null;
		ConnectionContext   connectionContext = null;
		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, Object> smsParam          = new HashMap<String, Object>();
		SepoaFormater       sepoaFormater     = null;
		List<String>        destPhone         = new ArrayList<String>();
		int                 destResultCount   = 0;
		int                 i                 = 0;
		
		try{
			connectionContext = getConnectionContext();
			
			msgParam.put("CODE", "RQ1");
			
			smsMsg = this.select(connectionContext, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg     = sepoaFormater.getValue("SMS_MSG", 0);
			destResult = this.select(connectionContext, "rqApplyE", param);
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < destResultCount; i++){
				destPhoneInfo = sepoaFormater.getValue("DEST_PHONE", i);
				
				if(i == 0){
					sourcingName = sepoaFormater.getValue("SOURCING_NAME", i);
				}
				
				destPhone.add(destPhoneInfo);
			}
			
			smsMsg = smsMsg.replace("${sourcingName}", sourcingName);
			
			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   "s00006");
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001602");
			smsParam.put("MPNG_1", sourcingName);
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(connectionContext, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
		
		return getSepoaOut();
	}
	
	/**
	 * 세금계산서 전송 알림 SMS
	 * @param ctx
	 * @param param
	 */
	public void tx1Process (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam        = new HashMap<String, String>();
		Map<String, Object> smsParam        = new HashMap<String, Object>();
		List<String>        destPhone       = new ArrayList<String>();
		String              smsMsg          = null;
		String              destResult      = null;
		String              contType1       = null;
		String              destPhoneInfo   = null;
		String              bidStatus       = null;
		String              msgParamCode    = null;
		String              poName          = null;
		String              taxNo           = null;
		SepoaFormater       sepoaFormater   = null;
		int                 destResultCount = 0;
		int                 i               = 0;
		
		try{
			taxNo          = param.get("TAX_NO");
			destPhoneInfo  = param.get("MOBILE_NO");
			
			destPhone.add(destPhoneInfo);
			
			msgParamCode = "TX1";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${taxNo}", taxNo);
			
			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001617");
			smsParam.put("MPNG_1", taxNo);
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}

	/**
	 * ICT 관련 SMS 전송 : ICT
	 * @param ctx
	 * @param param
	 */
	public void fnSMS_Send_ICT (ConnectionContext ctx, Map<String, String> param){

		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, String> msgParam2          = new HashMap<String, String>();
		Map<String, Object> tlkParam          = new HashMap<String, Object>();
		Map<String, Object> tlkParam2          = new HashMap<String, Object>();
		List<String>        destPhone         = new ArrayList<String>();
		
		String              smsKind           = null;
		String              QueryName         = null;
		String              smsMsg            = null;
		String              smsMsg2            = null;
		String              destResult        = null;
		String              contType1         = null;
		String              destPhoneInfo     = null;
		String              bidStatus         = null;
		String              bidNo             = null;
		
		String              ICT_SMS_06_flag   = null;
		String              ICT_SMS_12_1_rtn  = null;
		SepoaFormater       sepoaFormater     = null;
		int                 destResultCount   = 0;
		int                 i                 = 0;
		String              ums_tmpl_cd       = null;
		
		
		try{
			//SMS_KIND : ICT_SMS_01 = 공고문확정
			//           ICT_SMS_02 = 정정공고
			//           ICT_SMS_03 = 취소공고
			//           ICT_SMS_06 = 재입찰공고        
			//           ICT_SMS_07 = 유찰
			this.KEY_NUMBER = getICT_Sender(ctx);	// ICT센터 발송자 전화번호 가져오기.
			smsKind  = param.get("SMS_KIND");
			if (       "ICT_SMS_01".equals(smsKind)
					|| "ICT_SMS_02".equals(smsKind)
					|| "ICT_SMS_03".equals(smsKind) ) {
				QueryName = "ICT_BD_LIST01";
			}else if ("ICT_SMS_06".equals(smsKind)  ) {
				//재입찰
				//1. 1위 동률체크
				//2. 동률이 아니면 전체 재입찰통보
				//   동률이면 동률업체에게만 재입찰통보
				ICT_SMS_06_flag = this.select(ctx, "ICT_SMS_06_1", param);
				sepoaFormater = new SepoaFormater(ICT_SMS_06_flag);				
				ICT_SMS_06_flag = sepoaFormater.getValue("FLAG", 0);
				param.put("flag", ICT_SMS_06_flag);
				QueryName = smsKind;
			}else if ("ICT_SMS_12".equals(smsKind)  ) {
				//적격업체확인
				//1. 입찰시작일시 조회
				ICT_SMS_12_1_rtn = this.select(ctx, "ICT_SMS_12_1", param);
				sepoaFormater = new SepoaFormater(ICT_SMS_12_1_rtn);				
				param.put("BID_BEGIN_DATE", sepoaFormater.getValue("BID_BEGIN_DATE", 0));
				
				QueryName = smsKind;			
			}else{
				QueryName = smsKind;
			}


			//TOBE 2017-07-01 추가 
			if ("ICT_SMS_01".equals(smsKind)) {
				ums_tmpl_cd = "SMWMGSGF0001618";//"WBWMGSGF0120606";
			} else if ("ICT_SMS_02".equals(smsKind)) {
				ums_tmpl_cd = "SMWMGSGF0001619";//"WBWMGSGF0120607";
			} else if ("ICT_SMS_03".equals(smsKind)) {
				ums_tmpl_cd = "SMWMGSGF0001620";//"WBWMGSGF0120608";
			} else if ("ICT_SMS_06".equals(smsKind)) {
				ums_tmpl_cd = "SMWMGSGF0001622";//"WBWMGSGF0120610";
			} else if ("ICT_SMS_07".equals(smsKind)) {
				ums_tmpl_cd = "SMWMGSGF0001623";//"WBWMGSGF0120611";
			} else if ("ICT_SMS_12".equals(smsKind)) {
				ums_tmpl_cd = "SMWMGSGF0001633";//"WBWMGSGF0120617";
			} else {
				ums_tmpl_cd = smsKind;
			}
			
			
			
			
			// 문자 받을 번호 조회
			destResult = this.select(ctx, QueryName, param);
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destResultCount = sepoaFormater.getRowCount();

			contType1 = sepoaFormater.getValue("CONT_TYPE1", 0);
			bidStatus = sepoaFormater.getValue("BID_STATUS", 0);
			bidNo     = sepoaFormater.getValue("BID_NO", 0);
			
			for(i = 0; i < destResultCount; i++){
				destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", i);
				destPhone.add(destPhoneInfo);
			}

			// SMS문자열 가져오기

			if(smsKind != null){
				msgParam.put("CODE", smsKind);
				
				smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
				
				sepoaFormater = new SepoaFormater(smsMsg);
				
				smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
				smsMsg = smsMsg.replace("${bdNo}", bidNo);
				
				tlkParam.put("sendPhone", this.KEY_NUMBER);
				tlkParam.put("msgBody",   smsMsg);
				tlkParam.put("bizId1",    "GEN");
				tlkParam.put("bizId2",    "ELBID");
				tlkParam.put("destPhone", destPhone);
				tlkParam.put("infCode",   smsKind);				
								
				//TOBE 2017-07-01 추가
				tlkParam.put("UMS_TMPL_CD", ums_tmpl_cd);
				tlkParam.put("MPNG_1", bidNo);
				tlkParam.put("MPNG_2", "");
				tlkParam.put("MPNG_3", "");
				tlkParam.put("UMS_SMS_CNVSD_YN", "Y");
				
//				this.tlkAgentInsert(ctx, tlkParam);
				this.smsAgentInsert(ctx, tlkParam);
				
				// 재입찰공고 경우 추가 문자통보 - 입찰시간알림
				if("ICT_SMS_06".equals(smsKind)){
					msgParam2.put("CODE", "ICT_SMS_11");
					
					smsMsg2 = this.select(ctx, "selectSmsMsg", msgParam2);
					
					sepoaFormater = new SepoaFormater(smsMsg2);
					
					smsMsg2 = sepoaFormater.getValue("SMS_MSG", 0);
					smsMsg2 = smsMsg2.replace("${BID_BEGIN_TIME}", param.get("BID_BEGIN_TIME").substring(0, 2)+":"+param.get("BID_BEGIN_TIME").substring(2, 4));
					smsMsg2 = smsMsg2.replace("${BID_END_TIME}", param.get("BID_END_TIME").substring(0, 2)+":"+param.get("BID_END_TIME").substring(2, 4));
					
					//재입찰시간 : ${BID_BEGIN_TIME} ~ ${BID_END_TIME} 수신거부 0808151265
					
					tlkParam2.put("sendPhone", this.KEY_NUMBER);
					tlkParam2.put("msgBody",   smsMsg2);
					tlkParam2.put("bizId1",    "GEN");
					tlkParam2.put("bizId2",    "ELBID");
					tlkParam2.put("destPhone", destPhone);
					tlkParam2.put("infCode",   "ICT_SMS_11");				
									
					
					//TOBE 2017-07-01 추가
					tlkParam2.put("UMS_TMPL_CD", "SMWMGSGF0001605");
//					tlkParam2.put("UMS_TMPL_CD", "WBWMGSGF0120673");					
					tlkParam2.put("MPNG_1", param.get("BID_BEGIN_TIME").substring(0, 2)+":"+param.get("BID_BEGIN_TIME").substring(2, 4));
					tlkParam2.put("MPNG_2", param.get("BID_END_TIME").substring(0, 2)+":"+param.get("BID_END_TIME").substring(2, 4));
					tlkParam2.put("MPNG_3", "");
					tlkParam2.put("UMS_SMS_CNVSD_YN", "Y");
					this.smsAgentInsert(ctx, tlkParam2);
//					this.tlkAgentInsert(ctx, tlkParam2);	//param.get("SMS_KIND")			
				}
				
				// 적격업체승인 경우 추가 문자통보 - 입찰시간알림
				if("ICT_SMS_12".equals(smsKind)){
					msgParam2.put("CODE", "ICT_SMS_13");
					
					smsMsg2 = this.select(ctx, "selectSmsMsg", msgParam2);
					
					sepoaFormater = new SepoaFormater(smsMsg2);
					
					smsMsg2 = sepoaFormater.getValue("SMS_MSG", 0);
					smsMsg2 = smsMsg2.replace("${BID_BEGIN_DATE}", param.get("BID_BEGIN_DATE"));
					
					//재입찰시간 : ${BID_BEGIN_TIME} ~ ${BID_END_TIME} 수신거부 0808151265
					
					tlkParam2.put("sendPhone", this.KEY_NUMBER);
					tlkParam2.put("msgBody",   smsMsg2);
					tlkParam2.put("bizId1",    "GEN");
					tlkParam2.put("bizId2",    "ELBID");
					tlkParam2.put("destPhone", destPhone);
					tlkParam2.put("infCode",   "ICT_SMS_11");				
									
					//TOBE 2017-07-01 추가
					tlkParam2.put("UMS_TMPL_CD", "SMWMGSGF0001631");
					//tlkParam2.put("UMS_TMPL_CD", "WBWMGSGF0120615");
					tlkParam2.put("MPNG_1", param.get("BID_BEGIN_DATE"));
					tlkParam2.put("MPNG_2", "");
					tlkParam2.put("MPNG_3", "");
					tlkParam2.put("UMS_SMS_CNVSD_YN", "Y");
					this.smsAgentInsert(ctx, tlkParam2);
//					this.tlkAgentInsert(ctx, tlkParam2);	//param.get("SMS_KIND")			
				}
				
			}
			
			
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	/**
	 * ICT 관련 SMS 전송 (공고) : ICT2
	 * @param ctx
	 * @param param
	 */
	public void fnSMS_Send_ICT2 (ConnectionContext ctx, Map<String, String> param){

		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, Object> tlkParam          = new HashMap<String, Object>();
		List<String>        destPhone         = new ArrayList<String>();
		
		String              smsKind           = null;
		String              QueryName         = null;
		String              smsMsg            = null;
		String              destResult        = null;
		String              destPhoneInfo     = null;
		String              annNo             = null;
		String              finalFlag         = null;
		
		String              ICT_SMS_06_flag   = null;
		String              ICT_SMS_12_1_rtn  = null;
		SepoaFormater       sepoaFormater     = null;
		int                 destResultCount   = 0;
		int                 i                 = 0;
		String              ums_tmpl_cd       = null;
		
		
		try{
			//SMS_KIND : ICT_SMS_01 = 공고문확정
			//           ICT_SMS_02 = 정정공고
			//           ICT_SMS_03 = 취소공고
			//           ICT_SMS_06 = 재입찰공고        
			//           ICT_SMS_07 = 유찰
			this.KEY_NUMBER = getICT_Sender(ctx);	// ICT센터 발송자 전화번호 가져오기.
			smsKind  = param.get("SMS_KIND");
			if (       "ICT_SMS_14".equals(smsKind)
					|| "ICT_SMS_15".equals(smsKind) ) {
				QueryName = "ICT_BD2_LIST01";
			}else{
				QueryName = smsKind;
			}

			// 문자 받을 번호 조회
			destResult = this.select(ctx, QueryName, param);
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destResultCount = sepoaFormater.getRowCount();

			annNo     = sepoaFormater.getValue("ANN_NO", 0);
			
			for(i = 0; i < destResultCount; i++){
				destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", i);
				destPhone.add(destPhoneInfo);
			}

			// SMS문자열 가져오기

			if(smsKind != null){
				msgParam.put("CODE", smsKind);
				
				smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
				
				sepoaFormater = new SepoaFormater(smsMsg);
				
				smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
				smsMsg = smsMsg.replace("${annNo}", annNo);
				
				if("ICT_SMS_15".equals(smsKind)){			
					if("Y".equals(param.get("FINAL_FLAG"))){
						finalFlag = "적합";
					}else if("N".equals(param.get("FINAL_FLAG"))){
						finalFlag = "부적합";
					}else if("M".equals(param.get("FINAL_FLAG"))){
						finalFlag = "보완완료";
					}else if("U".equals(param.get("FINAL_FLAG"))){
						finalFlag = "보완요청";
					}
							
					smsMsg = smsMsg.replace("${finalFlag}", finalFlag);
				}
				
				
				tlkParam.put("sendPhone", this.KEY_NUMBER);
				tlkParam.put("msgBody",   smsMsg);
				tlkParam.put("bizId1",    "GEN");
				tlkParam.put("bizId2",    "ELBID");
				tlkParam.put("destPhone", destPhone);
				tlkParam.put("infCode",   smsKind);				
								
				//TOBE 2017-07-01 추가
				if("ICT_SMS_14".equals(smsKind)){		
					ums_tmpl_cd = "SMWMGSGF0001634";//"WBWMGSGF0120618";
				} else if("ICT_SMS_15".equals(smsKind)){
					ums_tmpl_cd = "SMWMGSGF0001635";//"WBWMGSGF0120619";
				} else {
					ums_tmpl_cd = smsKind;
				}
				tlkParam.put("UMS_TMPL_CD", ums_tmpl_cd);
				tlkParam.put("MPNG_1", annNo);
				tlkParam.put("MPNG_2", "");
				tlkParam.put("MPNG_3", "");
				tlkParam.put("UMS_SMS_CNVSD_YN", "Y");
				this.smsAgentInsert(ctx, tlkParam);
//				this.tlkAgentInsert(ctx, tlkParam);
			}
			
			
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}

	
	
	
	/**
	 * 전자계약서 알림 SMS 전송
	 * @param ctx
	 * @param param
	 */
	public void ct1Process(ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam        = new HashMap<String, String>();
		Map<String, Object> smsParam        = new HashMap<String, Object>();
		List<String>        destPhone       = new ArrayList<String>();
		String              smsMsg          = null;
		String              destResult      = null;
		String              contType1       = null;
		String              destPhoneInfo   = null;
		String              bidStatus       = null;
		String              msgParamCode    = null;
		String              poName          = null;
		String              contNo          = null;
		SepoaFormater       sepoaFormater   = null;
		int                 destResultCount = 0;
		int                 i               = 0;
		
		try{
			contNo          = param.get("CONT_NO");
			destPhoneInfo  = param.get("MOBILE_NO");
			
			destPhone.add(destPhoneInfo);
			
			msgParamCode = "CT1";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${contNo}", contNo);
			
			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001603");
			smsParam.put("MPNG_1", contNo);
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void bd1Process (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, Object> smsParam          = new HashMap<String, Object>();
		List<String>        destPhone         = new ArrayList<String>();
		String              smsMsg            = null;
		String              destResult        = null;
		String              contType1         = null;
		String              destPhoneInfo     = null;
		String              bidStatus         = null;
		String              bidNo             = null;
		String              msgParamCode      = null;
		SepoaFormater       sepoaFormater     = null;
		int                 destResultCount   = 0;
		int                 i                 = 0;
		String              ums_tmpl_cd       = null;
		
		try{
			destResult = this.select(ctx, "selectBd1List", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destResultCount = sepoaFormater.getRowCount();
			
			contType1 = sepoaFormater.getValue("CONT_TYPE1", 0);
			bidStatus = sepoaFormater.getValue("BID_STATUS", 0);
			bidNo     = sepoaFormater.getValue("BID_NO", 0);
			
			if("NC".equals(contType1)){ // 지명견적인 경우
				for(i = 0; i < destResultCount; i++){
					destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", i);
					
					destPhone.add(destPhoneInfo);
				}
			}
			
			if("AC".equals(bidStatus)){ // 입찰공고
				msgParamCode = "BD1";
				ums_tmpl_cd = "SMWMGSGF0001607";
			}
			else if("UC".equals(bidStatus)){ // 정정공고
				msgParamCode = "BD2";
				ums_tmpl_cd = "SMWMGSGF0001608";
			}
			else if("CC".equals(bidStatus)){ // 취소공고
				msgParamCode = "BD3";
				ums_tmpl_cd = "SMWMGSGF0001609";
			}
			
			if(msgParamCode != null){
				msgParam.put("CODE", msgParamCode);
				
				smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
				
				sepoaFormater = new SepoaFormater(smsMsg);
				
				smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
				smsMsg = smsMsg.replace("${bdNo}", bidNo);
				
				smsParam.put("sendPhone", this.KEY_NUMBER);
				smsParam.put("msgBody",   smsMsg);
				smsParam.put("bizId1",    "GEN");
				smsParam.put("bizId2",    "ELBID");
				smsParam.put("destPhone", destPhone);
				smsParam.put("infCode",   msgParamCode);
				
				//TOBE 2017-07-01 추가
				smsParam.put("UMS_TMPL_CD", ums_tmpl_cd);
				smsParam.put("MPNG_1", bidNo);
				smsParam.put("MPNG_2", "");
				smsParam.put("MPNG_3", "");
				
				this.smsAgentInsert(ctx, smsParam);
			}
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void bd1Process_ICT (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, Object> tlkParam          = new HashMap<String, Object>();
		List<String>        destPhone         = new ArrayList<String>();
		String              smsMsg            = null;
		String              destResult        = null;
		String              contType1         = null;
		String              destPhoneInfo     = null;
		String              bidStatus         = null;
		String              bidNo             = null;
		String              msgParamCode      = null;
		SepoaFormater       sepoaFormater     = null;
		int                 destResultCount   = 0;
		int                 i                 = 0;
		String              ums_tmpl_cd       = null;
		
		try{
			destResult = this.select(ctx, "selectBd1List_ICT", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destResultCount = sepoaFormater.getRowCount();
			
			contType1 = sepoaFormater.getValue("CONT_TYPE1", 0);
			bidStatus = sepoaFormater.getValue("BID_STATUS", 0);
			bidNo     = sepoaFormater.getValue("BID_NO", 0);
			
//			if("NC".equals(contType1)){ // 지명견적인 경우
				for(i = 0; i < destResultCount; i++){
					destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", i);
					
					destPhone.add(destPhoneInfo);
				}
//			}
			
			if("AC".equals(bidStatus)){ // 입찰공고
				msgParamCode = "ICT_SMS_01";
				ums_tmpl_cd = "SMWMGSGF0001618";//"WBWMGSGF0120606";
			}
			else if("UC".equals(bidStatus)){ // 정정공고
				msgParamCode = "ICT_SMS_02";
				ums_tmpl_cd = "SMWMGSGF0001619";//"WBWMGSGF0120607";
			}
			else if("CC".equals(bidStatus)){ // 취소공고
				msgParamCode = "ICT_SMS_03";
				ums_tmpl_cd = "SMWMGSGF0001620";//"WBWMGSGF0120608";
			}
			
			if(msgParamCode != null){
				msgParam.put("CODE", msgParamCode);
				
				smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
				
				sepoaFormater = new SepoaFormater(smsMsg);
				
				smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
				smsMsg = smsMsg.replace("${bdNo}", bidNo);
				
//				tlkParam.put("sendPhone", this.KEY_NUMBER);
				tlkParam.put("sendPhone", getICT_Sender(ctx));						
				tlkParam.put("msgBody",   smsMsg);
				tlkParam.put("bizId1",    "GEN");
				tlkParam.put("bizId2",    "ELBID");
				tlkParam.put("destPhone", destPhone);
				tlkParam.put("infCode",   msgParamCode);
				
				//TOBE 2017-07-01 추가
				tlkParam.put("UMS_TMPL_CD", ums_tmpl_cd);
				tlkParam.put("MPNG_1", bidNo);
				tlkParam.put("MPNG_2", "");
				tlkParam.put("MPNG_3", "");
				tlkParam.put("UMS_SMS_CNVSD_YN", "Y");
				this.smsAgentInsert(ctx, tlkParam);
//				this.tlkAgentInsert(ctx, tlkParam);
			}
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}

	

	
	public void bd4Process(ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, Object> smsParam          = new HashMap<String, Object>();
		List<String>        destPhone         = new ArrayList<String>();
		String              smsMsg            = null;
		String              destResult        = null;
		String              contType1         = null;
		String              destPhoneInfo     = null;
		String              bidStatus         = null;
		String              msgParamCode      = null;
		SepoaFormater       sepoaFormater     = null;
		int                 destResultCount   = 0;
		int                 i                 = 0;
		
		try{
			destResult = this.select(ctx, "selectBd4List", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < destResultCount; i++){
				destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", i);
				
				destPhone.add(destPhoneInfo);
			}
			
			msgParamCode = "BD4";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${bdNo}", param.get("BID_NO"));
			
			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001610");
			smsParam.put("MPNG_1", param.get("BID_NO"));
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void bd4Process_ICT(ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, Object> tlkParam          = new HashMap<String, Object>();
		List<String>        destPhone         = new ArrayList<String>();
		String              smsMsg            = null;
		String              destResult        = null;
		String              contType1         = null;
		String              destPhoneInfo     = null;
		String              bidStatus         = null;
		String              msgParamCode      = null;
		SepoaFormater       sepoaFormater     = null;
		int                 destResultCount   = 0;
		int                 i                 = 0;
		
		try{
			destResult = this.select(ctx, "selectBd4List_ICT", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < destResultCount; i++){
				destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", i);
				
				destPhone.add(destPhoneInfo);
			}
			
			msgParamCode = "BD4";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${bdNo}", param.get("BID_NO"));
			
//			smsParam.put("sendPhone", this.KEY_NUMBER);
			tlkParam.put("sendPhone", getICT_Sender(ctx));					
			tlkParam.put("msgBody",   smsMsg);
			tlkParam.put("bizId1",    "GEN");
			tlkParam.put("bizId2",    "ELBID");
			tlkParam.put("destPhone", destPhone);
			tlkParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			tlkParam.put("UMS_TMPL_CD", "SMWMGSGF0001610");
//			tlkParam.put("UMS_TMPL_CD", "WBWMGSGF0120656");
			tlkParam.put("MPNG_1", param.get("BID_NO"));
			tlkParam.put("MPNG_2", "");
			tlkParam.put("MPNG_3", "");
			tlkParam.put("UMS_SMS_CNVSD_YN", "Y");
			this.smsAgentInsert(ctx, tlkParam);
//			this.tlkAgentInsert(ctx, tlkParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void bd4Process_uc_ICT(ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, Object> smsParam          = new HashMap<String, Object>();
		String              smsMsg            = null;
		String              contType1         = null;
		String              bidStatus         = null;
		String              msgParamCode      = null;
		SepoaFormater       sepoaFormater     = null;
		int                 destResultCount   = 0;
		int                 i                 = 0;
		
		try{
			msgParamCode = "ICT_BD4";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${bdNo}", param.get("BID_NO"));
			
			//DirectSendMessage(param.get("USER_ID"), smsMsg);				
			UcMessage.DirectSendMessage(info.getSession("ID"), param.get("USER_ID"), smsMsg);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void bd5Process(ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, Object> smsParam          = new HashMap<String, Object>();
		List<String>        destPhone         = new ArrayList<String>();
		String              smsMsg            = null;
		String              destResult        = null;
		String              contType1         = null;
		String              destPhoneInfo     = null;
		String              bidStatus         = null;
		String              msgParamCode      = null;
		SepoaFormater       sepoaFormater     = null;
		int                 destResultCount   = 0;
		int                 i                 = 0;
		
		try{
			destResult = this.select(ctx, "selectBd5List", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < destResultCount; i++){
				destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", i);
				
				destPhone.add(destPhoneInfo);
			}
			
			msgParamCode = "BD5";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${bdNo}", param.get("BID_NO"));
			
			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001611");
			smsParam.put("MPNG_1", param.get("BID_NO"));
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
		
	public void bd6Process (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, Object> smsParam          = new HashMap<String, Object>();
		List<String>        destPhone         = new ArrayList<String>();
		String              smsMsg            = null;
		String              destResult        = null;
		String              contType1         = null;
		String              destPhoneInfo     = null;
		String              bidStatus         = null;
		String              msgParamCode      = null;
		SepoaFormater       sepoaFormater     = null;
		int                 destResultCount   = 0;
		int                 i                 = 0;
		
		try{
			destResult = this.select(ctx, "selectBd6List", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < destResultCount; i++){
				destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", i);
				
				destPhone.add(destPhoneInfo);
			}
			
			msgParamCode = "BD6";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${bdNo}", param.get("BID_NO"));
			
			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001612");
			smsParam.put("MPNG_1", param.get("BID_NO"));
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void bd7Process (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, Object> smsParam          = new HashMap<String, Object>();
		List<String>        destPhone         = new ArrayList<String>();
		String              smsMsg            = null;
		String              destResult        = null;
		String              contType1         = null;
		String              destPhoneInfo     = null;
		String              bidStatus         = null;
		String              msgParamCode      = null;
		SepoaFormater       sepoaFormater     = null;
		int                 destResultCount   = 0;
		int                 i                 = 0;
		
		try{
			destResult = this.select(ctx, "selectBd6List", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < destResultCount; i++){
				destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", i);
				
				destPhone.add(destPhoneInfo);
			}
			
			msgParamCode = "BD7";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${bdNo}", param.get("BID_NO"));
			
			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001613");
			smsParam.put("MPNG_1", param.get("BID_NO"));
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void rg1Process (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam        = new HashMap<String, String>();
		Map<String, Object> smsParam        = new HashMap<String, Object>();
		List<String>        destPhone       = new ArrayList<String>();
		String              smsMsg          = null;
		String              destResult      = null;
		String              contType1       = null;
		String              destPhoneInfo   = null;
		String              bidStatus       = null;
		String              msgParamCode    = null;
		String              vendorName      = null;
		SepoaFormater       sepoaFormater   = null;
		int                 destResultCount = 0;
		int                 i               = 0;
		
		try{
			destResult = this.select(ctx, "selectRg1List", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destPhoneInfo = sepoaFormater.getValue("PHONE_NO2",       0);
			vendorName    = sepoaFormater.getValue("VENDOR_NAME_LOC", 0);
				
			destPhone.add(destPhoneInfo);
			
			msgParamCode = "RG1";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${vendorName}", vendorName);
			
			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001604");
			smsParam.put("MPNG_1", vendorName);
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void rg2Process (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam        = new HashMap<String, String>();
		Map<String, Object> smsParam        = new HashMap<String, Object>();
		List<String>        destPhone       = new ArrayList<String>();
		String              smsMsg          = null;
		String              destResult      = null;
		String              contType1       = null;
		String              destPhoneInfo   = null;
		String              bidStatus       = null;
		String              msgParamCode    = null;
		String              vendorName      = null;
		SepoaFormater       sepoaFormater   = null;
		int                 destResultCount = 0;
		int                 i               = 0;
		
		try{
			destResult = this.select(ctx, "selectRg1List", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destPhoneInfo = sepoaFormater.getValue("PHONE_NO2",       0);
			vendorName    = sepoaFormater.getValue("VENDOR_NAME_LOC", 0);
				
			destPhone.add(destPhoneInfo);
			
			msgParamCode = "RG2";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${vendorName}", vendorName);
			
			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001616");
			smsParam.put("MPNG_1", vendorName);
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void rg2Process_ICT (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam        = new HashMap<String, String>();
		Map<String, Object> tlkParam        = new HashMap<String, Object>();
		List<String>        destPhone       = new ArrayList<String>();
		String              smsMsg          = null;
		String              destResult      = null;
		String              contType1       = null;
		String              destPhoneInfo   = null;
		String              destPhoneInfo2   = null;
		String              bidStatus       = null;
		String              msgParamCode    = null;
		String              vendorName      = null;
		SepoaFormater       sepoaFormater   = null;
		int                 destResultCount = 0;
		int                 i               = 0;
		
		try{
			destResult = this.select(ctx, "selectRg1List_ICT", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destPhoneInfo = sepoaFormater.getValue("PHONE_NO2",       0);
			destPhoneInfo2 = sepoaFormater.getValue("PHONE_NO2",       1);
			vendorName    = sepoaFormater.getValue("VENDOR_NAME_LOC", 0);
				
			destPhone.add(destPhoneInfo);
			destPhone.add(destPhoneInfo2);
			
			msgParamCode = "ICT_SMS_16";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${vendorName}", vendorName);
			
			tlkParam.put("sendPhone", this.KEY_NUMBER);
			tlkParam.put("msgBody",   smsMsg);
			tlkParam.put("bizId1",    "GEN");
			tlkParam.put("bizId2",    "ELBID");
			tlkParam.put("destPhone", destPhone);
			tlkParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			tlkParam.put("UMS_TMPL_CD", "SMWMGSGF0120464");
//			tlkParam.put("UMS_TMPL_CD", "WBWMGSGF0120633");
			tlkParam.put("MPNG_1", vendorName);
			tlkParam.put("MPNG_2", "");
			tlkParam.put("MPNG_3", "");
			tlkParam.put("UMS_SMS_CNVSD_YN", "Y");
			this.smsAgentInsert(ctx, tlkParam);
//			this.tlkAgentInsert(ctx, tlkParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void po1Process (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam        = new HashMap<String, String>();
		Map<String, Object> smsParam        = new HashMap<String, Object>();
		List<String>        destPhone       = new ArrayList<String>();
		String              smsMsg          = null;
		String              destResult      = null;
		String              contType1       = null;
		String              destPhoneInfo   = null;
		String              bidStatus       = null;
		String              msgParamCode    = null;
		String              poName          = null;
		SepoaFormater       sepoaFormater   = null;
		int                 destResultCount = 0;
		int                 i               = 0;
		
		try{
			poName     = param.get("SUBJECT");			
			if(poName.length() > 14){
				poName = poName.substring(0, 14);
			}
			
			destResult = this.select(ctx, "selectRg1List", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", 0);
				
			destPhone.add(destPhoneInfo);
			
			msgParamCode = "PO1";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${poName}", poName);
			
			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001615");
			smsParam.put("MPNG_1", poName);
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void so1Process (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam        = new HashMap<String, String>();
		Map<String, Object> smsParam        = new HashMap<String, Object>();
		List<String>        destPhone       = new ArrayList<String>();
		String              smsMsg          = null;
		String              destResult      = null;
		String              contType1       = null;
		String              destPhoneInfo   = null;
		String              bidStatus       = null;
		String              msgParamCode    = null;
		String              poName          = null;
		String              osqNo           = null;
		SepoaFormater       sepoaFormater   = null;
		int                 destResultCount = 0;
		int                 i               = 0;
		
		try{
			osqNo     = param.get("OSQ_NO");
//			poName     = param.get("SUBJECT");
			destResult = this.select(ctx, "selectRg1List", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", 0);
				
			destPhone.add(destPhoneInfo);
			
			msgParamCode = "SO1";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${osqNo}", osqNo);
//			smsMsg = smsMsg.replace("${poName}", poName);
			
			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001628");
			smsParam.put("MPNG_1", osqNo);
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void rq2Process (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, Object> smsParam          = new HashMap<String, Object>();
		List<String>        destPhone         = new ArrayList<String>();
		String              smsMsg            = null;
		String              destResult        = null;
		String              contType1         = null;
		String              destPhoneInfo     = null;
		String              bidStatus         = null;
		String              msgParamCode      = null;
		String              poName            = null;
		String              rfqNo             = null;
		String              rfqType           = null;
		SepoaFormater       sepoaFormater     = null;
		int                 destResultCount   = 0;
		int                 i                 = 0;
		
		try{
			
			destResult = this.select(ctx, "selectRq2List", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < destResultCount; i++){
				destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", i);
				
				if(i == 0){
					poName  = sepoaFormater.getValue("SUBJECT",  i);
					rfqNo  = sepoaFormater.getValue("RFQ_NO",  i);
					rfqType = sepoaFormater.getValue("RFQ_TYPE", i);
				}
				
				destPhone.add(destPhoneInfo);
			}
			
			if("MA".equals(rfqType) == false){
				msgParamCode = "RQ2";
				
				msgParam.put("CODE", msgParamCode);
				
				smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
				
				sepoaFormater = new SepoaFormater(smsMsg);
				
				smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
				smsMsg = smsMsg.replace("${rfqNo}", rfqNo);
//				smsMsg = smsMsg.replace("${poName}", poName);
				
				smsParam.put("sendPhone", this.KEY_NUMBER);
				smsParam.put("msgBody",   smsMsg);
//				smsParam.put("bizId1",    "BID");//TR_BIZ_ID1에 들어갈 내용 세팅
				smsParam.put("bizId1",    "GEN");//TR_BIZ_ID1에 들어갈 내용 세팅
//				smsParam.put("bizId2",    "ELBID");//TR_BIZ_ID2에 들어갈 내용 세팅
				smsParam.put("bizId2",    "ELBID");//TR_BIZ_ID2에 들어갈 내용 세팅
				smsParam.put("destPhone", destPhone);
				smsParam.put("infCode",   msgParamCode);
				
				//TOBE 2017-07-01 추가
				smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001606");
				smsParam.put("MPNG_1", rfqNo);
				smsParam.put("MPNG_2", "");
				smsParam.put("MPNG_3", "");
				
				this.smsAgentInsert(ctx, smsParam);
			}
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void iv1Process (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam        = new HashMap<String, String>();
		Map<String, Object> smsParam        = new HashMap<String, Object>();
		List<String>        destPhone       = new ArrayList<String>();
		String              smsMsg          = null;
		String              destResult      = null;
		String              contType1       = null;
		String              destPhoneInfo   = null;
		String              bidStatus       = null;
		String              msgParamCode    = null;
		String              ivName          = null;
		SepoaFormater       sepoaFormater   = null;
		int                 destResultCount = 0;
		int                 i               = 0;
		
		try{
			destResult = this.select(ctx, "selectIv2List", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", 0);
			ivName        = sepoaFormater.getValue("SUBJECT",   0);
				
			destPhone.add(destPhoneInfo);
			
			msgParamCode = "IV1";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${ivName}", ivName);
			
			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001614");
			smsParam.put("MPNG_1", ivName);
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void idFind (ConnectionContext ctx, String vendor_code, String phone_no){
		Map<String, String> msgParam        = new HashMap<String, String>();
		Map<String, Object> smsParam        = new HashMap<String, Object>();
		List<String>        destPhone       = new ArrayList<String>();
		String              smsMsg          = null;
		String              msgParamCode    = null;
		SepoaFormater       sepoaFormater   = null;
		
		try{
			msgParamCode = "ID01";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${id}", vendor_code);
			
			destPhone.add(phone_no);
			
			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001629");
			smsParam.put("MPNG_1", vendor_code);
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void pwReset (ConnectionContext ctx, String newPw, String phone_no, String user_gubun){
		Map<String, String> msgParam        = new HashMap<String, String>();
		Map<String, Object> smsParam        = new HashMap<String, Object>();
		List<String>        destPhone       = new ArrayList<String>();
		String              smsMsg          = null;
		String              msgParamCode    = null;
		SepoaFormater       sepoaFormater   = null;
		
		try{
			msgParamCode = "ID02";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${pw}", newPw);
			
			destPhone.add(phone_no);
			
			if ("ICT".equals(user_gubun)){
				smsParam.put("sendPhone", getICT_Sender(ctx));
			}else{
				smsParam.put("sendPhone", this.KEY_NUMBER);
			}
			
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001630");
			smsParam.put("MPNG_1", newPw);
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}

	
	/* ICT 발송을 위한 모듈*/
	public void rg1Process_ict (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam        = new HashMap<String, String>();
		Map<String, Object> smsParam        = new HashMap<String, Object>();
		List<String>        destPhone       = new ArrayList<String>();
		String              smsMsg          = null;
		String              destResult      = null;
		String              contType1       = null;
		String              destPhoneInfo   = null;
		String              bidStatus       = null;
		String              msgParamCode    = null;
		String              vendorName      = null;
		SepoaFormater       sepoaFormater   = null;
		int                 destResultCount = 0;
		int                 i               = 0;
		
		try{
			destResult = this.select(ctx, "selectRg1List_ict", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destPhoneInfo = sepoaFormater.getValue("PHONE_NO2",       0);
			vendorName    = sepoaFormater.getValue("VENDOR_NAME_LOC", 0);
				
			destPhone.add(destPhoneInfo);
			
			msgParamCode = "RG1";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${vendorName}", vendorName);
			
//			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("sendPhone", getICT_Sender(ctx));				
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001604");
			smsParam.put("MPNG_1", vendorName);
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}	
	
    /* ICT 사용 : Sender 정보 가져오기 */
    private String getICT_Sender(ConnectionContext ctx) throws Exception 
    {

    	Map<String, String> param         = new HashMap<String, String>();
    	String UserID = info.getSession("ID");
    	param.put("HOUSE_CODE", "000");
        String rtn = ""; 

        try { 
    		
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "getICT_SENDER");
			SepoaSQLManager ssm = new SepoaSQLManager(UserID, this, ctx, sxp); 

			rtn = ssm.doSelect(param);
            SepoaFormater wf = new SepoaFormater(rtn);
            rtn = wf.getValue(0,0);
    		
   		} catch(Exception e) {
    		Logger.err.println(UserID,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
	
	/* sms 발송 공통 Function(전화번호 알고 있는 경우) */
	public void sms_send_common(ConnectionContext ctx, String sms_code, String sending_str, String replace_str, String phone_no){
		//sms_code     : db에 저장된 Key code : 발송할 메시지 select 하기 위하여(scode table)
		//send_str_key : 전송될 String 
		//replace_str  : DB에 저장된 대치문자열(${vendorName})
		//phone_no     : 수신 Mobile No 
		//예) sms_send_common(ctx, "ICT_SMS_08", get_user_id, "${id}", get_mobile_NO);
		
		Map<String, String> msgParam        = new HashMap<String, String>();
		Map<String, Object> smsParam        = new HashMap<String, Object>();
		List<String>        destPhone       = new ArrayList<String>();
		String              smsMsg          = null;
		String              msgParamCode    = null;
		SepoaFormater       sepoaFormater   = null;
		
		try{
			msgParamCode = sms_code;
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace(replace_str, sending_str);
			
			destPhone.add(phone_no);
			
			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가 해당 모듈은 사용하는 곳이 없어 불필요 인듯함
			smsParam.put("UMS_TMPL_CD", "common:"+sms_code);
			smsParam.put("MPNG_1", sending_str);
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void sms_send_common2(ConnectionContext ctx, String sms_code, String sending_str, String replace_str, String phone_no, String user_gubun){
		//sms_code     : db에 저장된 Key code : 발송할 메시지 select 하기 위하여(scode table)
		//send_str_key : 전송될 String 
		//replace_str  : DB에 저장된 대치문자열(${vendorName})
		//phone_no     : 수신 Mobile No 
		//예) sms_send_common(ctx, "ICT_SMS_08", get_user_id, "${id}", get_mobile_NO);
		
		Map<String, String> msgParam        = new HashMap<String, String>();
		Map<String, Object> smsParam        = new HashMap<String, Object>();
		List<String>        destPhone       = new ArrayList<String>();
		String              smsMsg          = null;
		String              msgParamCode    = null;
		SepoaFormater       sepoaFormater   = null;
		String              ums_tmpl_cd     = null;
		
		try{
			msgParamCode = sms_code;
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace(replace_str, sending_str);
			
			destPhone.add(phone_no);
			
			if ("ICT".equals(user_gubun)){
				smsParam.put("sendPhone", getICT_Sender(ctx));
			}else{
				smsParam.put("sendPhone", this.KEY_NUMBER);
			}			
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			
			//TOBE 2017-07-01 추가
			if ("ICT_SMS_08".equals(sms_code)){
				ums_tmpl_cd = "SMWMGSGF0001624";
			} else if ("ICT_SMS_10".equals(sms_code)){
				ums_tmpl_cd = "SMWMGSGF0001626";
			} else {
				ums_tmpl_cd = "common2:" + sms_code;
			}
			smsParam.put("UMS_TMPL_CD", ums_tmpl_cd);
			smsParam.put("MPNG_1", sending_str);
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			//-----------------------------------------//
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void rptProcess (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, Object> smsParam          = new HashMap<String, Object>();
		List<String>        destPhone         = new ArrayList<String>();
		String              smsMsg            = null;
		String              destResult        = null;
		String              contType1         = null;
		String              destPhoneInfo     = null;
		String              bidStatus         = null;
		String              msgParamCode      = null;
		SepoaFormater       sepoaFormater     = null;
		int                 destResultCount   = 0;
		int                 i                 = 0;
		
		try{
			destResult = this.select(ctx, "selectRptList", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < destResultCount; i++){
				destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", i);
				
				destPhone.add(destPhoneInfo);
			}
			
			msgParamCode = "RPT1";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${vendorName}", param.get("DEPARTMENT_NAME_LOC"));
			
			smsParam.put("sendPhone", this.KEY_NUMBER);
			smsParam.put("msgBody",   smsMsg);
			smsParam.put("bizId1",    "GEN");
			smsParam.put("bizId2",    "ELBID");
			smsParam.put("destPhone", destPhone);
			smsParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			smsParam.put("UMS_TMPL_CD", "SMWMGSGF0001627");
			smsParam.put("MPNG_1", param.get("DEPARTMENT_NAME_LOC"));
			smsParam.put("MPNG_2", "");
			smsParam.put("MPNG_3", "");
			
			this.smsAgentInsert(ctx, smsParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	public void rptProcess_ICT (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, Object> tlkParam          = new HashMap<String, Object>();
		List<String>        destPhone         = new ArrayList<String>();
		String              smsMsg            = null;
		String              destResult        = null;
		String              contType1         = null;
		String              destPhoneInfo     = null;
		String              bidStatus         = null;
		String              msgParamCode      = null;
		SepoaFormater       sepoaFormater     = null;
		int                 destResultCount   = 0;
		int                 i                 = 0;
		try{
			destResult = this.select(ctx, "selectRptList_ICT", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < destResultCount; i++){
				destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", i);
				
				destPhone.add(destPhoneInfo);
			}
			
			msgParamCode = "ICT_SMS_17";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${RfqNo}", param.get("RFQ_NO"));
			smsMsg = smsMsg.replace("${SmsMap2}", param.get("SMS_MAP2"));
			
			tlkParam.put("sendPhone", this.KEY_NUMBER);
			tlkParam.put("msgBody",   smsMsg);
			tlkParam.put("bizId1",    "GEN");
			tlkParam.put("bizId2",    "ELBID");
			tlkParam.put("destPhone", destPhone);
			tlkParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			tlkParam.put("UMS_TMPL_CD", "SMWMGSGF0120466");
//			tlkParam.put("UMS_TMPL_CD", "WBWMGSGF0120635");
			tlkParam.put("MPNG_1", param.get("RFQ_NO"));
			tlkParam.put("MPNG_2", param.get("SMS_MAP2"));
			tlkParam.put("MPNG_3", "");
			tlkParam.put("UMS_SMS_CNVSD_YN", "Y");
			
			//-----------------------------------------//
			this.smsAgentInsert(ctx, tlkParam);
//			this.tlkAgentInsert(ctx, tlkParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	
	public void rptProcess2_ICT (ConnectionContext ctx, Map<String, String> param){
		Map<String, String> msgParam          = new HashMap<String, String>();
		Map<String, Object> tlkParam          = new HashMap<String, Object>();
		List<String>        destPhone         = new ArrayList<String>();
		String              smsMsg            = null;
		String              destResult        = null;
		String              contType1         = null;
		String              destPhoneInfo     = null;
		String              bidStatus         = null;
		String              msgParamCode      = null;
		SepoaFormater       sepoaFormater     = null;
		int                 destResultCount   = 0;
		int                 i                 = 0;
		
		try{
			destResult = this.select(ctx, "selectRptList2_ICT", param); // 문자 받는자 리스트 조회
			
			sepoaFormater = new SepoaFormater(destResult);
			
			destResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < destResultCount; i++){
				destPhoneInfo = sepoaFormater.getValue("PHONE_NO2", i);
				
				destPhone.add(destPhoneInfo);
			}
			
			msgParamCode = "ICT_SMS_18";
			
			msgParam.put("CODE", msgParamCode);
			
			smsMsg = this.select(ctx, "selectSmsMsg", msgParam);
			
			sepoaFormater = new SepoaFormater(smsMsg);
			
			smsMsg = sepoaFormater.getValue("SMS_MSG", 0);
			smsMsg = smsMsg.replace("${vendorName}", param.get("VENDOR_NAME"));
			smsMsg = smsMsg.replace("${RfqNo}", param.get("RFQ_NO"));
			smsMsg = smsMsg.replace("${SmsMap3}", param.get("SMS_MAP3"));
			
			tlkParam.put("sendPhone", this.KEY_NUMBER);
			tlkParam.put("msgBody",   smsMsg);
			tlkParam.put("bizId1",    "GEN");
			tlkParam.put("bizId2",    "ELBID");
			tlkParam.put("destPhone", destPhone);
			tlkParam.put("infCode",   msgParamCode);
			
			//TOBE 2017-07-01 추가
			tlkParam.put("UMS_TMPL_CD", "SMWMGSGF0120567");
//			tlkParam.put("UMS_TMPL_CD", "WBWMGSGF0120636");
			
			tlkParam.put("MPNG_1", param.get("VENDOR_NAME"));
			tlkParam.put("MPNG_2", param.get("RFQ_NO"));
			tlkParam.put("MPNG_3", param.get("SMS_MAP3"));
			tlkParam.put("UMS_SMS_CNVSD_YN", "Y");
			
			//-----------------------------------------//
			this.smsAgentInsert(ctx, tlkParam);
//			this.tlkAgentInsert(ctx, tlkParam);
		}
		catch(Exception e){
			Logger.err.println(e);
		}
	}
	
	
//	// 입찰총괄자(행번,회신번호)
//	static String bidChrId = "";
//	static String bidChrNmloc = "";
//	static String bidChrNmEng = "";
//	static String bidChrDept = "";
//	static String bidChrMobile = "";
//	static String trCallBack = "";
//
//	// SYSTEM 계정
//	static String sysId = "";
//	
//	static String adm1_mobile = "";
//	static String adm2_mobile = "";
//	static String adm3_mobile = "";
//	static String adm1_id = "";
//	static String adm2_id = "";
//	static String adm3_id = "";
//		
//	public void getBidChrAdmId(ConnectionContext ctx) throws Exception {
//		try {			
//			/*
//			SCODE
//			담당자 정보
//			
//			TYPE
//			B001 : 20150327 기준... 담당자 정보
//			
//			CODE
//			0001 : 담당자
//			
//			TEXT1 : 계정
//			TEXT2 : 이름(한글명)
//			TEXT3 : 이름(영문명)
//			TEXT4 : 부서코드
//			TEXT5 : 연락처(휴대폰)
//			TEXT6 : 연락처(회사/업체)
//			*/
//			Map<String, String> scodeMap = new HashMap<String, String>();
//			SepoaXmlParser sxp = null;
//			SepoaSQLManager ssm = null;
//			SepoaFormater sf = null;
//			
//			scodeMap.put("TYPE", "B001_ICT");//SCODE에서 조회할 TYPE을 저장
//			
//			sxp = new SepoaXmlParser( this, "getInfo" );
//			ssm = new SepoaSQLManager( info.getSession("ID"), this, ctx, sxp );
//			sf  = new SepoaFormater( ssm.doSelect( scodeMap ) );
//			
//			int exist_cnt = sf.getRowCount();
//			
//			if(exist_cnt < 1) {
//				throw new Exception("SCODE NOT FOUND ERROR");
//			}
//			
//			//조회한 건들 중에서 원하는 CODE를 찾아서 저장
//			for (int i = 0; i < exist_cnt; i++) {
//				
//				if( "0001".equals( sf.getValue( "CODE", i ) ) ) {//CODE가 0001이면... (이 분기가 SCODE에서 CODE로 관리하는 값이어야함)
//					
//					//담당자 정보 저장
//					bidChrId     = sf.getValue("TEXT1", i).trim();
//					bidChrNmloc  = sf.getValue("TEXT2", i).trim();
//					bidChrNmEng  = sf.getValue("TEXT3", i).trim();
//					bidChrDept   = sf.getValue("TEXT4", i).trim();
//					bidChrMobile = sf.getValue("TEXT5", i).trim();
//					trCallBack   = sf.getValue("TEXT6", i).trim();
//					
//				} else if( "0002".equals( sf.getValue( "CODE", i ) ) ) {
//					
//					//시스템 정보 저장
//					sysId = sf.getValue("TEXT1", i);
//					
//				} else if( "0003".equals( sf.getValue( "CODE", i ) ) ) {
//					
//					//관리자 정보 저장
//					adm1_id     = sf.getValue( "TEXT1", i );
//					adm1_mobile = sf.getValue( "TEXT5", i );
//					
//				} else if( "0004".equals( sf.getValue( "CODE", i ) ) ) {
//					
//					//관리자 정보 저장
//					adm2_id     = sf.getValue( "TEXT1", i );
//					adm2_mobile = sf.getValue( "TEXT5", i );
//					
//				} else if( "0005".equals( sf.getValue( "CODE", i ) ) ) {
//					
//					//관리자 정보 저장
//					adm3_id     = sf.getValue( "TEXT1", i );
//					adm3_mobile = sf.getValue( "TEXT5", i );
//					
//				}				
//			}						
//
//		} catch (Exception exception) {
//			Logger.info.println(info.getSession("ID"), this,"Error is occured.", exception);
//			System.out.println((new StringBuilder()).append("AutoBidBatchProcess() ERROR : ").append(exception.getMessage()).toString());
//		}
//	}
}