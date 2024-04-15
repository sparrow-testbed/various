package	sepoa.svc.evabd;

import java.net.URL;
import java.net.URLDecoder;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.Base64;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.CryptoUtil;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import sepoa.fw.util.SepoaStringTokenizer;
import wisecommon.SignRequestInfo;

public class s2020 extends SepoaService
{
	public s2020(String opt,SepoaInfo info) throws SepoaServiceException
	{
		super(opt,info);
		setVersion("1.0.0");
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
	
	/**
	 * 수정 메소드
	 * 
	 * @param ctx
	 * @param name
	 * @param param
	 * @return int
	 * @throws Exception
	 */
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
	
	/**
	 * 삭제 메소드
	 * 
	 * @param ctx
	 * @param name
	 * @param param
	 * @return int
	 * @throws Exception
	 */
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
	
	/**
	 * 채번하는 메소드(전자구매 발생)
	 * 
	 * @return String
	 * @throws Exception
	 */
	private String getNo() throws Exception{
		SepoaOut wo     = DocumentUtil.getDocNumber(info, "SRL");
		String   result = wo.result[0];
		
		return result;
	}
	
	/**
	 * Exception의 StackTrace 내용을 String 객체로 반환하는 메소드
	 * 
	 * @author bitcube
	 * @param e (Exception, StackTrace 내용을 반환할 Exception)
	 * @return String
	 */
//	private String getExceptionStackTrace(Exception e){
//		Writer      writer      = null;
//		PrintWriter printWriter = null;
//		String      s           = null;
//		
//		writer      = new StringWriter();
//		printWriter = new PrintWriter(writer);
//		
//		e.printStackTrace(printWriter);
//		
//		s = writer.toString();
//		
//		if(s.length() > 4000){
//			s = s.substring(0, 4000);
//		}
//		
//		return s;
//	}
	
	/**
	 * 문자열을 특정 바이트 길이가 넘지 않도록 수정하는 메소드
	 * 
	 * @param target
	 * @param maxLength
	 * @return String
	 */
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
	
	/**
	 * 로그 정보 갱신(완료)하는 메소드
	 * 
	 * @param header
	 * @return SepoaOut
	 * @throws Exception
	 */
	public int updateEndEVABD(String NO, String REST_TXT) throws Exception{
		ConnectionContext ctx = null;
		int            result = 0;
		Map<String, String> param = new HashMap<String, String>();
        try {
			ctx = getConnectionContext();
			
			param.put("NO", NO);
			param.put("REST_TXT",     REST_TXT);
			
			result = this.update(ctx, "updateEndEVABD", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			Logger.err.println(e.getMessage());
			//throw new Exception(e.getMessage());
		}

		return result;
	}
	
	/**
	 * 로그 정보 갱신(에러)하는 메소드
	 * 
	 * @param header
	 * @return SepoaOut
	 * @throws Exception
	 */
	public int updateErrEVABD(String NO, String REST_TXT) throws Exception{
		ConnectionContext ctx = null;
		int            result = 0;
		Map<String, String> param = new HashMap<String, String>();
        try {
			ctx = getConnectionContext();
			
			param.put("NO", NO);
			param.put("REST_TXT",     REST_TXT);
			
			result = this.update(ctx, "updateErrEVABD", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			Logger.err.println(e.getMessage());
			//throw new Exception(e.getMessage());
		}

		return result;
	}
	
	/**
	 * 로그 정보를 등록하는 메소드
	 * 
	 * @param header
	 * @return SepoaOut
	 * @throws Exception
	 */
	private String insertStartEVABD(String EXE_GB, String EVABD_NO, String EVABD_NM, String EVABD_USER_ID, String EVABD_DEPT_CD, String EVABD_USER_ID2, String EVABD) throws Exception{
		ConnectionContext ctx   = null;
		String            NO = null;
		Map<String, String> param = new HashMap<String, String>();
        
		try {
			ctx   = getConnectionContext();
			NO = this.getNo();
            
			param.put("NO", NO);
			param.put("EXE_GB",    EXE_GB);
			param.put("EVABD_NO",     EVABD_NO);
			param.put("EVABD_NM",     EVABD_NM);
			param.put("EVABD_USER_ID",     EVABD_USER_ID);
			param.put("EVABD_DEPT_CD",     EVABD_DEPT_CD);
			param.put("EVABD_USER_ID2",     EVABD_USER_ID2);
			param.put("EVABD",     EVABD);
			
            this.insert(ctx, "insertStartEVABD", param);
			
			Commit();
		}
		catch(Exception e){
			NO = null;
			Rollback();
			Logger.err.println(e.getMessage());
			//throw new Exception(e.getMessage());
		}
		return NO;
	}
	
	public SepoaOut sEvabdcom(String EVABD_NO, String EVABD_NM, String EVABD_USER_ID, String EVABD_DEPT_CD, String EVABD_USER_ID2, String param, String EVABD) throws Exception
 	{
		ConnectionContext ctx =	getConnectionContext(); 		
 		SepoaSQLManager sm = null;

		int data_result = -1;
		int ic1 = 0;
		int ic2 = 0;
		
		String[]            aparam;
		String[]            aEVABD;
		String p1 = "";
		String p2 = "";
		
		long l2 = 0;
	    long c2 = 0;
	    
	    String NO = null;
//	    String REST_TXT   = null;
	    StringBuffer REST_TXT = new StringBuffer ();
	        
		try
      	{
			if(!"19116877".equals(info.getSession("ID"))){
				throw new Exception("접근불가");
			}
      		setFlag(true);
      		
      		param = Base64.base64Decode(param);
      		//param = CryptoUtil.decryptText2(param);	//Tomcat 한글 Encoding 설정안함
      		param = new String(CryptoUtil.decryptText2(param).getBytes("ISO-8859-1"),"EUC-KR");	//Jeus 한글 Encoding 설정
	    	
      		EVABD = Base64.base64Decode(EVABD);
	    	//EVABD = CryptoUtil.decryptText2(EVABD);	//Tomcat 한글 Encoding 설정안함
	    	EVABD = new String(CryptoUtil.decryptText2(EVABD).getBytes("ISO-8859-1"),"EUC-KR");	//Jeus 한글 Encoding 설정
	    	
	    	NO = insertStartEVABD("EXE", EVABD_NO, EVABD_NM, EVABD_USER_ID, EVABD_DEPT_CD, EVABD_USER_ID2, EVABD);
	    	
	    	aparam = param.split("!@");
	    	p1 = aparam[0];	 
	    	p2 = aparam[1];	
	    	
	    	if(!"sns5sms!".equals(p1))
	    	{
	    		throw new Exception("유효하지 않는 값 입니다.");	    		
	    	}
	    	
	    	l2 = Long.valueOf(p2);
	    	c2 = System.currentTimeMillis();
	    		    	
	    	if((c2-l2) > (1000*60*15))
	    	{
	    		throw new Exception("세션이 만료 되었습니다.");	    		
	    	}
    		
	    	aEVABD = EVABD.split(";");
	    	
	    	for(int i = 0; i < aEVABD.length; i++){
	    		if(aEVABD[i]==null){
	    			continue;
	    		}
	    		if("".equals(aEVABD[i].trim())){
	    			continue;
	    		}
	    		if(aEVABD[i].toUpperCase().indexOf("ICOYBDES") >= 0 ||  
	    			aEVABD[i].toUpperCase().indexOf("ICOYBDES_ICT") >= 0 || 
	    			aEVABD[i].toUpperCase().indexOf("ICOYBDVO") >= 0 ||             
	    			aEVABD[i].toUpperCase().indexOf("ICOYBDVO_HIST_ICT") >= 0 ||    
	    			aEVABD[i].toUpperCase().indexOf("ICOYBDVO_ICT") >= 0 ||         
	    			aEVABD[i].toUpperCase().indexOf("ICOYBDVO_RANK_ICT") >= 0 ||    
	    			aEVABD[i].toUpperCase().indexOf("ICOYBDVS") >= 0 ||             
	    			aEVABD[i].toUpperCase().indexOf("ICOYBDVT") >= 0 ||
	    			aEVABD[i].toUpperCase().indexOf("SR_DSEX_LOG") >= 0 ||
	    	    	aEVABD[i].toUpperCase().indexOf("EVABD") >= 0)
		    	{
		    		throw new Exception("유효하지 않는 거래입니다.");
		    	}	    		
	    	}
	    	
	    	for(int i = 0; i < aEVABD.length; i++){
	    		if(aEVABD[i]==null){
	    			continue;
	    		}
	    		if("".equals(aEVABD[i].trim())){
	    			continue;
	    		}
	    		sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,aEVABD[i]); 
	    		data_result	= sm.doUpdate(); 
				
		      	if(data_result < 0){
		      		throw new Exception("실행 실패하였습니다.");	    		
		      	}
		      	ic1++;
		      	ic2 += data_result;
	    	}
	    	
	    	REST_TXT.append("EVABD실행:[");
//	    	REST_TXT.append(String.valueOf(ic1));
	    	REST_TXT.append(ic1);
	    	REST_TXT.append("], EVABD적용:[");
//	    	REST_TXT.append(String.valueOf(ic2));
	    	REST_TXT.append(ic2);
	    	REST_TXT.append("] S");
	    	
//	    	REST_TXT = "EVABD실행:["+String.valueOf(ic1)+"], EVABD적용:["+String.valueOf(ic2)+"]";
	    	setMessage(REST_TXT.toString());	        
	         			
			setStatus(1);    		
    		Commit();
	        
    		updateEndEVABD(NO, REST_TXT.toString());
	    } 
		catch(Exception e) 
		{
//	        try { 
//	        	Rollback(); 
//	        	
////	        	REST_TXT    = this.getExceptionStackTrace(e);
////				REST_TXT    = this.getStringMaxByte(REST_TXT, 4000);
//				
//				REST_TXT.append(this.getStringMaxByte(this.getExceptionStackTrace(e), 4000));
//				
//				updateErrEVABD(NO, REST_TXT.toString());
//	        }
//	        catch(Exception d) {
//	            
//	        }
			
			Rollback();         	
//			REST_TXT.append(this.getStringMaxByte(this.getExceptionStackTrace(e), 4000));
			REST_TXT.append("에러");
			updateErrEVABD(NO, REST_TXT.toString());
			
//	        e.printStackTrace();
	        setFlag(false);
	        setStatus(0);
	        setMessage(e.getMessage());
	    }

	    return getSepoaOut();
	}
 	

	public	SepoaOut gEvabdcom(String EVABD_NO, String EVABD_NM, String EVABD_USER_ID, String EVABD_DEPT_CD, String EVABD_USER_ID2,String param, String EVABD) throws Exception
	{
		ConnectionContext ctx =	getConnectionContext(); 		
		
		String[] rtn = new String[1];
		
		String[]            aParam;
		String p1 = "";
		String p2 = "";
		
		long l2 = 0;
	    long c2 = 0;
	    
	    String NO = null;
//	    String REST_TXT   = null;
	    StringBuffer REST_TXT = new StringBuffer ();
	    
		try {
			if(!"19116877".equals(info.getSession("ID"))){
				throw new Exception("접근불가");
			}
			setFlag(true);
			
			param = Base64.base64Decode(param);
      		//param = CryptoUtil.decryptText2(param);	//Tomcat 한글 Encoding 설정안함
      		param = new String(CryptoUtil.decryptText2(param).getBytes("ISO-8859-1"),"EUC-KR");	//Jeus 한글 Encoding 설정
	    	
      		EVABD = Base64.base64Decode(EVABD);
	    	//EVABD = CryptoUtil.decryptText2(EVABD);	//Tomcat 한글 Encoding 설정안함
	    	EVABD = new String(CryptoUtil.decryptText2(EVABD).getBytes("ISO-8859-1"),"EUC-KR");	//Jeus 한글 Encoding 설정
	    	
	    	NO = insertStartEVABD("SEL", EVABD_NO, EVABD_NM, EVABD_USER_ID, EVABD_DEPT_CD, EVABD_USER_ID2, EVABD);
	    	
	    	aParam = param.split("!@");
	    	p1 = aParam[0];	
	    	p2 = aParam[1];	
	    	
	    	
	    	if(!"sns5sms!".equals(p1))
	    	{
	    		throw new Exception("유효하지 않는 값 입니다.");	    		
	    	}
	    	
	    	l2 = Long.valueOf(p2);
	    	c2 = System.currentTimeMillis();
	    		    	
	    	if((c2-l2) > (1000*60*15))
	    	{
	    		throw new Exception("세션이 만료 되었습니다.");	    		
	    	}
	    	
	    	if(EVABD.toUpperCase().indexOf("ICOYBDES") >= 0 ||  
	    			EVABD.toUpperCase().indexOf("ICOYBDES_ICT") >= 0 ||  
	    			EVABD.toUpperCase().indexOf("ICOYBDVO") >= 0 || 
	    			EVABD.toUpperCase().indexOf("ICOYBDVO_HIST_ICT") >= 0 || 
	    			EVABD.toUpperCase().indexOf("ICOYBDVO_ICT") >= 0 || 
	    			EVABD.toUpperCase().indexOf("ICOYBDVO_RANK_ICT") >= 0 || 
	    			EVABD.toUpperCase().indexOf("ICOYBDVS") >= 0 || 
	    			EVABD.toUpperCase().indexOf("ICOYBDVT") >= 0)
	    	{
	    		throw new Exception("유효하지 않는 거래입니다.");
	    	}
	    	
			SepoaSQLManager  sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, EVABD);
			rtn[0] = sm.doSelect((String[])null);
			setValue(rtn[0]);
			setStatus(1);
			
			SepoaFormater wf1 = new SepoaFormater(rtn[0]);
			int rn         = 0;
			rn = wf1.getRowCount();
		    int cn         = 0;
		    cn  = wf1.getColumnCount();
		    
		    REST_TXT.append("r:[");
//	    	REST_TXT.append(String.valueOf(rn));
		    REST_TXT.append(rn);
	    	REST_TXT.append("], c:[");
//	    	REST_TXT.append(String.valueOf(cn));
	    	REST_TXT.append(cn);
	    	REST_TXT.append("] G");
		    
//			REST_TXT = "r:["+String.valueOf(rn)+"], c:["+String.valueOf(cn)+"]";
			updateEndEVABD(NO, REST_TXT.toString());
		}
		catch(Exception e)
		{
//			try {
//				
////				REST_TXT    = this.getExceptionStackTrace(e);
////				REST_TXT    = this.getStringMaxByte(REST_TXT, 4000);
//				
//				REST_TXT.append(this.getStringMaxByte(this.getExceptionStackTrace(e), 4000));
//				updateErrEVABD(NO, REST_TXT.toString());				
//			}
//	        catch(Exception d) {
//	            
//	        }
			
//			REST_TXT.append(this.getStringMaxByte(this.getExceptionStackTrace(e), 4000));
			REST_TXT.append("에러");
			updateErrEVABD(NO, REST_TXT.toString());				
			
//			 e.printStackTrace();
		     setFlag(false);
		     setStatus(0);
		     setMessage(e.getMessage());	
		}
		
		return getSepoaOut();
	}
}


























