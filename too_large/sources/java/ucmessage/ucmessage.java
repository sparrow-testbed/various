package ucMessage;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.SepoaFormater;

public class UcMessage {
	public static void DirectSendMessage(String userId, String rcvId, String msg){
		Properties    prop         = null;
		String        paramString  = null;
		String        isSendString = null;
		URL           url          = null;
		URLConnection conn         = null;
		boolean       isSend       = false;
		
		String        ucline       = null;
		String[]      aMsg         = null;
		StringBuffer  sbMsg        = new StringBuffer();
		
		
		
		
		SepoaFormater       sf     = null;
	    SepoaOut            value  = null;
	    SepoaFormater       sf2     = null;
	    SepoaOut            value2  = null;
	    //Map<String, String> map    = null;
	    HashMap map                = new HashMap();
	    String       ucYn          = "Y";
	    String       ucTobeAsisYn  = "Y";
	    String       UC_ASIS_URL   = "";
		String       UC_TOBE_URL   = "";
		
	    
		
		try{
			//전체 UC쪽지 수신여부
			isSendString = CommonUtil.getConfig("sepoa.ucmessage.flag");
			isSend       = Boolean.parseBoolean(isSendString);
			
			//UC쪽지 개행구분문자
			ucline = CommonUtil.getConfig("sepoa.ucmessage.line");
			
			if(isSend){
				
				//사용자별 UC쪽지 수신여부 (Y OR NULL:수신 , N:미수신)///////////////////////////////////////////////////
				SepoaInfo info = new SepoaInfo("000",	"COMPANY_CODE=1000^@^ID=BATCH^@^LANGUAGE=KO^@^NAME_LOC=BATCH^@^NAME_ENG=BATCH^@^DEPARTMENT=BATCH^@^DEPARTMENT_NAME_LOC=BATCH^@^");
				String[] args = {"000",rcvId};
				Object[] obj = {(Object[])args};
		    	value = ServiceConnector.doService(info, "s6030", "CONNECTION", "getUcYn", obj);
		    	if(value.status == 1)
		    	{
		    		SepoaFormater wf = new SepoaFormater(value.result[0]);
		    		if ( wf.getRowCount() > 0 ){
		    			ucYn           = wf.getValue("UC_YN"      , 0) ;
		    		}
		    	}
		    	///////////////////////////////////////////////////////////////////////////////////////////////
		    	
		    	//UC쪽지 TO-IS(Y),AS-IS(N) 구분///////////////////////////////////////////////////
		    	String[] args2 = {"000"};
				Object[] obj2 = {(Object[])args2};
				value2 = ServiceConnector.doService(info, "s6030", "CONNECTION", "getUcTobeAsisYn", obj2);
		    	if(value.status == 1)
		    	{
		    		SepoaFormater wf2 = new SepoaFormater(value2.result[0]);
		    		if ( wf2.getRowCount() > 0 ){
		    			ucTobeAsisYn           = wf2.getValue("CODE"      , 0) ;
		    			UC_ASIS_URL            = wf2.getValue("TEXT2"      , 0) ;
		    			UC_TOBE_URL            = wf2.getValue("TEXT3"      , 0) ;
		    		}
		    	}
		    	///////////////////////////////////////////////////////////////////////////////////////////////
		    	
				if("Y".equals(ucYn)){
					//UC쪽지 개행처리 "<div><span>.....</span></div>"
					aMsg = msg.split(ucline);
			    	for(int i = 0; i < aMsg.length; i++){		    		
			    		if(aMsg[i]==null){
			    			continue;
			    		}
			    		sbMsg.append("<div><span>");
			    		sbMsg.append(aMsg[i]);
			    		sbMsg.append("</span></div>");
			    	}
					
					prop = new Properties();
					
//					if(Integer.parseInt(sepoa.fw.util.SepoaDate.getShortDateString()) < 20210104  || "N".equals(ucTobeAsisYn)){
					if("N".equals(ucTobeAsisYn)){ 			
						prop.setProperty("userId",  userId);
						prop.setProperty("rcvId",   rcvId);
		//				prop.setProperty("msg",     msg);
						if(aMsg.length == 0){
							prop.setProperty("msg",     msg);
				    	}else{
				    		prop.setProperty("msg",     sbMsg.toString());
				    	}				
						prop.setProperty("msgType", "1");
						prop.setProperty("sTYPE",   "UCS");
		
						paramString = UcMessage.encodeString(prop);
						paramString = UC_ASIS_URL + "?" + paramString;
					}else{					
						prop.setProperty("userID",  userId);
						prop.setProperty("rcvId",   rcvId);	
						if(aMsg.length == 0){
							prop.setProperty("Msg",     msg);
				    	}else{
				    		prop.setProperty("Msg",     sbMsg.toString());
				    	}				
						prop.setProperty("msgType", "1");
						prop.setProperty("sTYPE",   "SGF");
						prop.setProperty("screenID",   "None");
						
						paramString = UcMessage.encodeString(prop);
						paramString = UC_TOBE_URL + "?" + paramString;
					}
					url = new URL(paramString);
					
					conn = url.openConnection();
					
					conn.setUseCaches(false);
					conn.getInputStream();
				}
				
			}
			
		}
		catch(Exception e){
			Logger.err.print(e.toString());
		}
	}
	
	private static String encodeString(Properties params) throws UnsupportedEncodingException{
   		StringBuffer sb     = new StringBuffer(256);
   		String       name   = null;
   		String       value  = null;
   		String       result = null;
   		Enumeration  names  = params.propertyNames();
   		
   		while(names.hasMoreElements()){
   			name  = (String)names.nextElement();
   			name  = URLEncoder.encode(name);
   			value = params.getProperty(name);
   			value = URLEncoder.encode(value,"UTF-8");
   			
   			sb.append(name).append("=").append(value);
			
   			if(names.hasMoreElements()){
   				sb.append("&");	
   			}
   		}	
   		
   		result = sb.toString();
   		
   		return result;
   	}
}
