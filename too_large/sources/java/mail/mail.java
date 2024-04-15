package mail;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Vector;

import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.mail.MailSendVo;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaFormater;

public class mail extends SepoaService {
	@SuppressWarnings("unused")
	private javax.mail.Message   msg       = null;
	@SuppressWarnings("unused")
	private Message              Sepoamsg  = null;
	@SuppressWarnings("unused")
	private Configuration        conf      = null;
	private final String KEY_EMAIL = "woori@woori.com";
	
	public mail(String opt, SepoaInfo sinfo) throws Exception {
		super(opt, sinfo);
		setVersion("1.0.0");
		
		conf     = new Configuration();
		Sepoamsg = new Message(sinfo, "STDCOMM");
	}
	
	private String getInfNo(SepoaInfo info) throws Exception{
		SepoaOut wo     = DocumentUtil.getDocNumber(info, "RFC");
		String   result = wo.result[0];
		
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
	
	private String getExceptionStackTrace(Exception e){
		Writer      writer      = new StringWriter();
		PrintWriter printWriter = new PrintWriter(writer);
		String      s           = null;
		
		e.printStackTrace(printWriter);
		
		s = writer.toString();
		
		return s;
	}
	
	private void loggerExceptionStackTrace(Exception e){
		String trace = this.getExceptionStackTrace(e);
		
		Logger.err.println(trace);
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
	
	private Session setMailSendHistorySession() throws Exception{
		Session    session = null;
		Properties prop    = System.getProperties();
		
		prop.put("mail.trasport.protocol", "smtp");
		prop.put("mail.smtp.port",         "25");
		
		session = Session.getInstance(prop, null);
		
		return session;
	}
	
	@SuppressWarnings("rawtypes")
	private InternetAddress[] setMailSendHistoryTos(MailSendVo vo) throws Exception{
		InternetAddress[]   tos             = null;
		InternetAddress     internetAddress = null;
		Vector              mToValues       = vo.getM_to_values();
		String              toEmail         = null;
		int                 mToValuesSize   = mToValues.size();
		int                 i               = 0;
		
		tos = new InternetAddress[mToValuesSize];
		
		for(i = 0; i < mToValuesSize; i++){
			toEmail = (String)mToValues.elementAt(i);
			
			internetAddress = new InternetAddress(toEmail);
			
			tos[i] = internetAddress;
		}
		
		return tos;
	}
	
	private MimeMessage setMailSendHistoryMimeMessage(Session session, MailSendVo vo) throws Exception{
		MimeMessage       message         = new MimeMessage(session);
		Multipart         multipart       = new MimeMultipart();
		MimeBodyPart      messageBodyPart = new MimeBodyPart();
		String            senderAddr      = vo.getSender_addr();
		String            subject         = vo.getSubject();
		String            content         = vo.getContents();
		InternetAddress[] tos             = this.setMailSendHistoryTos(vo);
		InternetAddress   internetAddress = new InternetAddress(senderAddr);
		
		message.setFrom(internetAddress);
		
		message.setRecipients(javax.mail.Message.RecipientType.TO, tos);
		message.setSubject(subject,	"UTF-8");
		message.setSentDate(new Date());
		
		messageBodyPart.setContent(content, "text/html;charset=UTF-8");
		
		multipart.addBodyPart(messageBodyPart);
		
		message.setContent(multipart);
		
		return message;
	}
	
	@SuppressWarnings("rawtypes")
	private String mailAgentInsertInfInsert(ConnectionContext ctx, MailSendVo vo, SepoaInfo info) throws Exception{
		Map<String, String> param         = new HashMap<String, String>();
		String              houseCode     = info.getSession("HOUSE_CODE");
		String              id            = info.getSession("ID");
		String              infNo         = this.getInfNo(info);
		String              docType       = vo.getDoc_type();
		String              senderAddr    = vo.getSender_addr();
		String              subject       = vo.getSubject();
		String              content       = vo.getContents();
		String              toEmail       = null;
		StringBuffer        stringBuffer  = new StringBuffer();
		Vector              mToValues     = vo.getM_to_values();
		int                 mToValuesSize = mToValues.size();
		int                 i             = 0;
		
		subject = this.getStringMaxByte(subject, 4000);
		content = this.getStringMaxByte(content, 4000);
		
		for(i = 0; i < mToValuesSize; i++){
			toEmail = (String)mToValues.elementAt(i);
			
			stringBuffer.append(toEmail);
			
			if(i != (mToValuesSize - 1)){
				stringBuffer.append(",");
			}
		}
		
		toEmail = stringBuffer.toString();
		toEmail = this.getStringMaxByte(toEmail, 4000);
		
		param.put("HOUSE_CODE",     houseCode);
		param.put("INF_NO",         infNo);
		param.put("INF_TYPE",       "E");
		param.put("INF_CODE",       docType);
		param.put("INF_SEND",       "S");
		param.put("SENDERADDR",     senderAddr);
		param.put("SUBJECT",        subject);
		param.put("CONTENT",        content);
		param.put("RECIPIENTSADDR", toEmail);
		param.put("INF_ID",         id);
		
		this.insert(ctx, "insertSinfhdInfo",   param);
		this.insert(ctx, "insertSinfmailInfo", param);
		
		return infNo;
	}
	
	private void setMailSendHistory(ConnectionContext ctx, MailSendVo vo, SepoaInfo info){
    	Configuration configuration = null;
    	String              host          = null;
    	String              infNo         = null;
    	String              status        = null;
    	String              reason        = "";
    	String              houseCode     = info.getSession("HOUSE_CODE");
		Session             session       = null;
		MimeMessage         message       = null;
		Transport           transport     = null;
		Map<String, String> param         = new HashMap<String, String>();
		boolean             smtpSendFlag  = false;
			
		try {	
			configuration = new Configuration();
			host          = configuration.get("sepoa.smtp.server");
			smtpSendFlag  = configuration.getBoolean("sepoa.smtp.send.flag");
			
			if(smtpSendFlag){
				infNo     = this.mailAgentInsertInfInsert(ctx, vo, info);
				session   = this.setMailSendHistorySession();
				message   = this.setMailSendHistoryMimeMessage(session, vo);
	    		transport = session.getTransport("smtp");
	    		
	    		transport.connect(host, "userid", "password");
	    		transport.sendMessage(message, message.getAllRecipients());
	    		transport.close();
	    		
	    		status = "Y";
			}
    	}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
			
			status = "N";
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
		}
		
		try{
			param.put("STATUS",         status);
			param.put("REASON",         reason);
			param.put("HOUSE_CODE",     houseCode);
			param.put("INF_NO",         infNo);
			param.put("INF_RECEIVE_NO", infNo);
			
			this.update(ctx, "updateSinfhdInfo", param);
			
			Commit();
		}
		catch(Exception e){
			try {
				Rollback();
			}
			catch (SepoaServiceException e1) {
				this.loggerExceptionStackTrace(e1);
			}
			
			this.loggerExceptionStackTrace(e);
		}
    }
	
	@SuppressWarnings("rawtypes")
	private MailSendVo rqApplyEMailListVo(Vector reciveMailVector, Vector recieveMailName, String senderAddr) throws Exception{
		MailSendVo vo        = new MailSendVo();
		String     mailTitle = "전자구매시스템으로부터 구매요청이 수신되었습니다.";
		String     contents  = "<html><head></head><body>전자구매시스템으로부터 구매요청이 수신되었습니다.</body></html>";
		
		vo.setContents(contents);
    	vo.setDoc_type("type");
    	vo.setM_to_values(reciveMailVector);
    	vo.setM_to_name_values(recieveMailName);
    	vo.setSender_addr(senderAddr);
    	vo.setSubject(mailTitle);
    	
    	return vo;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private List<MailSendVo> rqApplyEMailList(ConnectionContext ctx, Map<String, String> param) throws Exception{
		List<MailSendVo>    mailList                      = new ArrayList<MailSendVo>();
		String              purchaserEmailListResult      = null;
		String              purchaserEmail                = null;
		String              vendorName                    = null;
		String              vendorEmail                   = null;
		String              senderAddr                    = null;
		SepoaFormater       sepoaFormater                 = null;
		Vector              reciveMailVector              = null;
		Vector              recieveMailName               = null;
		MailSendVo          vo                            = null;
		int                 purchaserEmailListResultCount = 0;
		int                 i                             = 0;
		
		purchaserEmailListResult = this.select(ctx, "selectIcoyrqdtPurchaserEmailVendorNameEmailList", param);
		
		sepoaFormater = new SepoaFormater(purchaserEmailListResult);
		
		purchaserEmailListResultCount = sepoaFormater.getRowCount();
		
		for(i = 0; i < purchaserEmailListResultCount; i++){
			purchaserEmail = sepoaFormater.getValue("EMAIL",        i);
			vendorName     = sepoaFormater.getValue("VENDOR_NAME",  i);
			vendorEmail    = sepoaFormater.getValue("VENDOR_EMAIL", i);
			purchaserEmail = this.nvl(purchaserEmail, this.KEY_EMAIL);
			
			if(senderAddr == null){
				reciveMailVector = new Vector();
				recieveMailName  = new Vector();
				
				senderAddr = purchaserEmail;
			}
			
			if(senderAddr.equals(purchaserEmail) == false){
				vo = this.rqApplyEMailListVo(reciveMailVector, recieveMailName, senderAddr);
				
		    	mailList.add(vo);
				
				reciveMailVector = new Vector();
				recieveMailName  = new Vector();
				
				senderAddr = purchaserEmail;
			}
			
			if(reciveMailVector != null){ reciveMailVector.addElement(vendorEmail); }
			if(recieveMailName != null){ recieveMailName.addElement(vendorName); }
		}
		
		if(senderAddr != null){
			vo = this.rqApplyEMailListVo(reciveMailVector, recieveMailName, senderAddr);
	    	
	    	mailList.add(vo);
		}
		
		return mailList;
	}
	
	public SepoaOut rqApplyE(Map<String, String> param){
    	MailSendVo        vo           = null;
    	ConnectionContext ctx          = null;
		List<MailSendVo>  mailList     = null;
		int               i            = 0;
		int               mailListSize = 0;
		
		try{
			ctx       = getConnectionContext();
			mailList  = this.rqApplyEMailList(ctx, param);
			
			mailListSize = mailList.size();
			
			for(i = 0; i < mailListSize; i++){
				vo = mailList.get(i);
				
				this.setMailSendHistory(ctx, vo, info);
			}
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
		
		return getSepoaOut();
	}
	
	public void rg1Process (ConnectionContext ctx, Map<String, String> param){
		MailSendVo    vo                       = null;
		String        selectRg1ListResult      = null;
		String        vendorName               = null;
		String        vendorEmail              = null;
		String        mailTitle                = null;
		String        contents                 = null;
		SepoaFormater sepoaFormater            = null;
		Vector        reciveMailVector         = null;
		Vector        recieveMailName          = null;
		int           i                        = 0;
		int           selectRg1ListResultCount = 0;
		
		try{
			selectRg1ListResult = this.select(ctx, "selectRg1List", param);
			
			sepoaFormater = new SepoaFormater(selectRg1ListResult);
			
			selectRg1ListResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < selectRg1ListResultCount; i++){
				reciveMailVector = new Vector();
				recieveMailName  = new Vector();
				vo               = new MailSendVo();
				
				vendorName  = sepoaFormater.getValue("VENDOR_NAME_LOC",  i);
				vendorEmail = sepoaFormater.getValue("EMAIL",            i);
				vendorEmail = this.nvl(vendorEmail, "");
				
				if("".equals(vendorEmail) == false){
					mailTitle = "[업체:" + vendorName + "] 우리은행 협력사 등록이 반려되었습니다.";
					contents  = "<html><head></head><body>" + mailTitle + "</body></html>";
					
					reciveMailVector.addElement(vendorEmail);
					recieveMailName.addElement(vendorName);
					
					vo.setContents(contents);
			    	vo.setDoc_type("RG1");
			    	vo.setM_to_values(reciveMailVector);
			    	vo.setM_to_name_values(recieveMailName);
			    	vo.setSender_addr(this.KEY_EMAIL);
			    	vo.setSubject(mailTitle);
					
					this.setMailSendHistory(ctx, vo, info);
				}
			}
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	public void rg2Process (ConnectionContext ctx, Map<String, String> param){
		MailSendVo    vo                       = null;
		String        selectRg1ListResult      = null;
		String        vendorName               = null;
		String        vendorEmail              = null;
		String        mailTitle                = null;
		String        contents                 = null;
		SepoaFormater sepoaFormater            = null;
		Vector        reciveMailVector         = null;
		Vector        recieveMailName          = null;
		int           i                        = 0;
		int           selectRg1ListResultCount = 0;
		
		try{
			selectRg1ListResult = this.select(ctx, "selectRg1List", param);
			
			sepoaFormater = new SepoaFormater(selectRg1ListResult);
			
			selectRg1ListResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < selectRg1ListResultCount; i++){
				reciveMailVector = new Vector();
				recieveMailName  = new Vector();
				vo               = new MailSendVo();
				
				vendorName  = sepoaFormater.getValue("VENDOR_NAME_LOC",  i);
				vendorEmail = sepoaFormater.getValue("EMAIL",            i);
				vendorEmail = this.nvl(vendorEmail, "");
				
				if("".equals(vendorEmail) == false){
					mailTitle   = "협력사 기본 정보가 변경되었습니다. [업체:" + vendorName + "]";
					contents    = "<html><head></head><body>" + mailTitle + "</body></html>";
					
					reciveMailVector.addElement(vendorEmail);
					recieveMailName.addElement(vendorName);
					
					vo.setContents(contents);
			    	vo.setDoc_type("RG2");
			    	vo.setM_to_values(reciveMailVector);
			    	vo.setM_to_name_values(recieveMailName);
			    	vo.setSender_addr(this.KEY_EMAIL);
			    	vo.setSubject(mailTitle);
					
					this.setMailSendHistory(ctx, vo, info);
				}
			}
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	public void po1Process (ConnectionContext ctx, Map<String, String> param){
		MailSendVo    vo                       = null;
		String        selectRg1ListResult      = null;
		String        vendorName               = null;
		String        vendorEmail              = null;
		String        mailTitle                = null;
		String        contents                 = null;
		String        poName                   = null;
		SepoaFormater sepoaFormater            = null;
		Vector        reciveMailVector         = null;
		Vector        recieveMailName          = null;
		int           i                        = 0;
		int           selectRg1ListResultCount = 0;
		
		try{
			poName              = param.get("SUBJECT");
			selectRg1ListResult = this.select(ctx, "selectRg1List", param);
			
			sepoaFormater = new SepoaFormater(selectRg1ListResult);
			
			selectRg1ListResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < selectRg1ListResultCount; i++){
				reciveMailVector = new Vector();
				recieveMailName  = new Vector();
				vo               = new MailSendVo();
				
				vendorName  = sepoaFormater.getValue("VENDOR_NAME_LOC",  i);
				vendorEmail = sepoaFormater.getValue("EMAIL",            i);
				vendorEmail = this.nvl(vendorEmail, "");
				
				if("".equals(vendorEmail) == false){
					mailTitle   = "우리은행으로부터 [발주명:" + poName + "] 발주서가 발송되었습니다.";
					contents    = "<html><head></head><body>" + mailTitle + "</body></html>";
					
					reciveMailVector.addElement(vendorEmail);
					recieveMailName.addElement(vendorName);
					
					vo.setContents(contents);
			    	vo.setDoc_type("PO1");
			    	vo.setM_to_values(reciveMailVector);
			    	vo.setM_to_name_values(recieveMailName);
			    	vo.setSender_addr(this.KEY_EMAIL);
			    	vo.setSubject(mailTitle);
					
					this.setMailSendHistory(ctx, vo, info);
				}
			}
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	public void iv1Process (ConnectionContext ctx, Map<String, String> param){
		MailSendVo    vo                       = null;
		String        selectIv1ListResult      = null;
		String        vendorName               = null;
		String        vendorEmail              = null;
		String        mailTitle                = null;
		String        contents                 = null;
		String        subject                  = null;
		SepoaFormater sepoaFormater            = null;
		Vector        reciveMailVector         = null;
		Vector        recieveMailName          = null;
		int           i                        = 0;
		int           selectRg1ListResultCount = 0;
		
		try{
			selectIv1ListResult = this.select(ctx, "selectIv1List", param);
			
			sepoaFormater = new SepoaFormater(selectIv1ListResult);
			
			selectRg1ListResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < selectRg1ListResultCount; i++){
				reciveMailVector = new Vector();
				recieveMailName  = new Vector();
				vo               = new MailSendVo();
				
				vendorName  = sepoaFormater.getValue("VENDOR_NAME_LOC",  i);
				vendorEmail = sepoaFormater.getValue("EMAIL",            i);
				subject     = sepoaFormater.getValue("SUBJECT",          i);
				vendorEmail = this.nvl(vendorEmail, "");
				
				if("".equals(vendorEmail) == false){
					mailTitle   = "[발주명:" + subject + "] 검수 요청이 반려되었습니다.";
					contents    = "<html><head></head><body>" + mailTitle + "</body></html>";
					
					reciveMailVector.addElement(vendorEmail);
					recieveMailName.addElement(vendorName);
					
					vo.setContents(contents);
			    	vo.setDoc_type("IV1");
			    	vo.setM_to_values(reciveMailVector);
			    	vo.setM_to_name_values(recieveMailName);
			    	vo.setSender_addr(this.KEY_EMAIL);
			    	vo.setSubject(mailTitle);
					
					this.setMailSendHistory(ctx, vo, info);
				}
			}
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	public void so1Process(ConnectionContext ctx, Map<String, String> param){
		MailSendVo    vo                       = null;
		String        selectIv1ListResult      = null;
		String        vendorName               = null;
		String        vendorEmail              = null;
		String        mailTitle                = null;
		String        contents                 = null;
		String        subject                  = null;
		SepoaFormater sepoaFormater            = null;
		Vector        reciveMailVector         = null;
		Vector        recieveMailName          = null;
		int           i                        = 0;
		int           selectRg1ListResultCount = 0;
		
		try{
			subject             = param.get("SUBJECT");
			selectIv1ListResult = this.select(ctx, "selectRg1List", param);
			
			sepoaFormater = new SepoaFormater(selectIv1ListResult);
			
			selectRg1ListResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < selectRg1ListResultCount; i++){
				reciveMailVector = new Vector();
				recieveMailName  = new Vector();
				vo               = new MailSendVo();
				
				vendorName  = sepoaFormater.getValue("VENDOR_NAME_LOC",  i);
				vendorEmail = sepoaFormater.getValue("EMAIL",            i);
				vendorEmail = this.nvl(vendorEmail, "");
				
				if("".equals(vendorEmail) == false){
					mailTitle   = "우리은행으로부터 [발주명:" + subject + "] 실사요청서가 발송되었습니다.";
					contents    = "<html><head></head><body>" + mailTitle + "</body></html>";
					
					reciveMailVector.addElement(vendorEmail);
					recieveMailName.addElement(vendorName);
					
					vo.setContents(contents);
			    	vo.setDoc_type("SO1");
			    	vo.setM_to_values(reciveMailVector);
			    	vo.setM_to_name_values(recieveMailName);
			    	vo.setSender_addr(this.KEY_EMAIL);
			    	vo.setSubject(mailTitle);
					
					this.setMailSendHistory(ctx, vo, info);
				}
			}
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	public void rq2Process(ConnectionContext ctx, Map<String, String> param){
		MailSendVo    vo                       = null;
		String        selectIv1ListResult      = null;
		String        vendorName               = null;
		String        vendorEmail              = null;
		String        mailTitle                = null;
		String        contents                 = null;
		String        subject                  = null;
		String        rfqType                  = null;
		SepoaFormater sepoaFormater            = null;
		Vector        reciveMailVector         = null;
		Vector        recieveMailName          = null;
		int           i                        = 0;
		int           selectRg1ListResultCount = 0;
		
		try{
			selectIv1ListResult = this.select(ctx, "selectRq2List", param);
			
			sepoaFormater = new SepoaFormater(selectIv1ListResult);
			
			selectRg1ListResultCount = sepoaFormater.getRowCount();
			
			for(i = 0; i < selectRg1ListResultCount; i++){
				reciveMailVector = new Vector();
				recieveMailName  = new Vector();
				vo               = new MailSendVo();
				
				vendorName  = sepoaFormater.getValue("VENDOR_NAME_LOC", i);
				vendorEmail = sepoaFormater.getValue("EMAIL",           i);
				vendorEmail = this.nvl(vendorEmail, "");
				
				if("".equals(vendorEmail) == false){
					subject     = sepoaFormater.getValue("SUBJECT",         i);
					rfqType     = sepoaFormater.getValue("RFQ_TYPE",        i);
					
					if("MA".equals(rfqType) == false){
						mailTitle   = "우리은행으로부터 [발주명:" + subject + "] 견적요청서가 발송되었습니다.";
						contents    = "<html><head></head><body>" + mailTitle + "</body></html>";
						
						reciveMailVector.addElement(vendorEmail);
						recieveMailName.addElement(vendorName);
						
						vo.setContents(contents);
				    	vo.setDoc_type("RQ2");
				    	vo.setM_to_values(reciveMailVector);
				    	vo.setM_to_name_values(recieveMailName);
				    	vo.setSender_addr(this.KEY_EMAIL);
				    	vo.setSubject(mailTitle);
						
						this.setMailSendHistory(ctx, vo, info);
					}
				}
			}
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
}