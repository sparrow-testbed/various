package sepoa.fw.mail;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Vector;

import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;

public class MailSendHistory {
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
		
		message.setRecipients(Message.RecipientType.TO, tos);
		message.setSubject(subject,	"UTF-8");
		message.setSentDate(new Date());
		
		messageBodyPart.setContent(content, "text/html;charset=UTF-8");
		
		multipart.addBodyPart(messageBodyPart);
		
		message.setContent(multipart);
		
		return message;
	}
	
	private String getInfNo(SepoaInfo info) throws Exception{
		SepoaOut wo     = DocumentUtil.getDocNumber(info, "RFC");
		String   result = wo.result[0];
		
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	private String mailAgentInsertInfInsert(MailSendVo vo, SepoaInfo info) throws Exception{
		SepoaOut            value         = null;
		Object[]            obj           = new Object[1];
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
		boolean             flag          = false;
		
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
		
		obj[0] = param;
		value  = ServiceConnector.doService(info, "mail", "TRANSACTION", "mailAgentInsertInfInsert", obj);
		flag   = value.flag;
		
		if(flag == false){
			throw new Exception();
		}
		
		return infNo;
	}
	
	private void mailAgentInsertInfUpdate(SepoaInfo info, Map<String, String> param){
		try{
			String              houseCode = info.getSession("HOUSE_CODE");
			String              status    = param.get("status");
			String              reason    = param.get("reason");
			String              infNo     = param.get("infNo");
			Map<String, String> infParam  = new HashMap<String, String>();
			Object[]            obj       = new Object[1];
			
			infParam.put("STATUS",         status);
			infParam.put("REASON",         reason);
			infParam.put("HOUSE_CODE",     houseCode);
			infParam.put("INF_NO",         infNo);
			infParam.put("INF_RECEIVE_NO", infNo);
			
			obj[0] = infParam;
			
			ServiceConnector.doService(info, "mail", "TRANSACTION", "mailAgentInsertInfUpdate", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
		
	}
	
	public void setMailSendHistory(MailSendVo vo){}
	
	public void setMailSendHistory(MailSendVo vo, SepoaInfo info){
    	Configuration configuration = null;
    	String              host          = null;
    	String              infNo         = null;
    	String              status        = null;
    	String              reason        = "";
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
				infNo     = this.mailAgentInsertInfInsert(vo, info);
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
		
		param.put("status", status);
		param.put("reason", reason);
		param.put("infNo",  infNo);
    	
    	this.mailAgentInsertInfUpdate(info, param);
    }
}
