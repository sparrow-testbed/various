package	ict.dt.rfq;  
 
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import mail.mail;

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
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import sms.SMS;
import ucMessage.UcMessage;
import wisecommon.SignRequestInfo;
import wisecommon.SignResponseInfo;
 



public class I_p1004 extends SepoaService 
{ 
	//private	Message	msg	= new Message(lang,"STDRFQ"); 
	
	
	private boolean bDebug = true;
	private Message msg;

	public I_p1004(String opt, SepoaInfo info) throws SepoaServiceException {
		 super(opt,info);
	        setVersion("1.0.0");
	        msg = new Message(info,"STDRFQ");

	        Configuration configuration = null;
	        
	        try {
				configuration = new Configuration();
			} catch(ConfigurationException cfe) {
				Logger.err.println(info.getSession("ID"), this, "getConfig error : " + cfe.getMessage());
			} catch(Exception e) {
				Logger.err.println(info.getSession("ID"), this, "getConfig error : " + e.getMessage());
			}
	}
	
	public String getConfig(String s)                                                               
	{                                                                                         
	    try                                                                                   
	    {                                                                                     
	        Configuration configuration = new Configuration();                                
	        s = configuration.get(s);                                                         
	        return s;                                                                         
	    }                                                                                     
	    catch(ConfigurationException configurationexception)                                  
	    {                                                                                     
	        Logger.sys.println("getConfig error : " + configurationexception.getMessage()); 
	    }                                                                                     
	    catch(Exception exception)                                                            
	    {                                                                                     
	        Logger.sys.println("getConfig error : " + exception.getMessage());              
	    }                                                                                     
	    return null;                                                                          
	}
	
	/**
	 * 견적요청목록 조회
	 */
	public SepoaOut getRfqList(Map<String, String> header) { 
		
		ConnectionContext ctx                   = getConnectionContext();
		SepoaXmlParser    sxp                   = null;
		SepoaSQLManager   ssm                   = null;
		String            id                    = info.getSession("ID");
		String            rfq_status              = header.get("rfq_status");
		
		
		try{
//			System.out.println(header);
			sxp = new SepoaXmlParser(this, "getRfqList");
			sxp.addVar("language", info.getSession("LANGUAGE"));
			sxp.addVar("rfq_status", rfq_status);
			
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	setValue(ssm.doSelect(header));

		}catch (Exception e){
			
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
	
	public SepoaOut getRfqList2(Map<String, String> header) { 
		
		ConnectionContext ctx                   = getConnectionContext();
		SepoaXmlParser    sxp                   = null;
		SepoaSQLManager   ssm                   = null;
		String            id                    = info.getSession("ID");
		String            rfq_status              = header.get("rfq_status");
		
		
		try{
//			System.out.println(header);
			sxp = new SepoaXmlParser(this, "getRfqList2");
			sxp.addVar("language", info.getSession("LANGUAGE"));
			sxp.addVar("rfq_status", rfq_status);
			
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	setValue(ssm.doSelect(header));

		}catch (Exception e){
			
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
	
	public SepoaOut getRfqList3(Map<String, String> header) { 
		
		ConnectionContext ctx                   = getConnectionContext();
		SepoaXmlParser    sxp                   = null;
		SepoaSQLManager   ssm                   = null;
		String            id                    = info.getSession("ID");
		String            rfq_status              = header.get("rfq_status");
		
		
		try{
//			System.out.println(header);
			sxp = new SepoaXmlParser(this, "getRfqList3");
			sxp.addVar("language", info.getSession("LANGUAGE"));
			sxp.addVar("rfq_status", rfq_status);
			
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	setValue(ssm.doSelect(header));

		}catch (Exception e){
			
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
	
	public SepoaOut getRfqList4(Map<String, String> header) { 
		
		ConnectionContext ctx                   = getConnectionContext();
		SepoaXmlParser    sxp                   = null;
		SepoaSQLManager   ssm                   = null;
		String            id                    = info.getSession("ID");
		String            rfq_status              = header.get("rfq_status");
		
		
		try{
//			System.out.println(header);
			sxp = new SepoaXmlParser(this, "getRfqList4");
			sxp.addVar("language", info.getSession("LANGUAGE"));
			sxp.addVar("rfq_status", rfq_status);
			
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	setValue(ssm.doSelect(header));

		}catch (Exception e){
			
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
	
		//[R101807022454] [2018-11-30] [IT전자입찰시스템] 내외부 데이터 활용 표준 견적 DB 구축
		public SepoaOut getRfqHDDisplay(String rfq_no, String rfq_count)
		{ 
			try{ 
				String rtn = null; 
	            rtn        = et_getRfqHDDisplay(rfq_no, rfq_count); 
	            setValue(rtn);
                setStatus(1); 
				setMessage(msg.getMessage("0000")); 
				}catch(Exception e)	{ 
					
					Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				setStatus(0); 
				setMessage(msg.getMessage("0001")); 
				} 
			return getSepoaOut(); 
			
		} 	
		@SuppressWarnings("unchecked")
		private	 String et_getRfqHDDisplay(String rfq_no, String rfq_count) throws Exception 
		{ 
			String rtn     							= null;
	        //String uid      						= info.getSession("ID");
	        ConnectionContext ctx                   = getConnectionContext();
			SepoaXmlParser    sxp                   = null;
			SepoaSQLManager   ssm                   = null;
	        String house_code 						= info.getSession("HOUSE_CODE");
			try{ 
				sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				ssm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
				String[] data = {rfq_no, rfq_count};
				rtn	= ssm.doSelect(data); 
				//rtn	= ssm.doSelect((String[])null); 
			}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		}
		    
		    /* [R101807022454] [2018-11-30] [IT전자입찰시스템] 내외부 데이터 활용 표준 견적 DB 구축 */
			public SepoaOut getRfqDTDisplay(Map<String, Object> data) throws Exception
			{ 
				ConnectionContext ctx                   = getConnectionContext();
				SepoaXmlParser    sxp                   = null;
				SepoaSQLManager   ssm                   = null;
				//String            rtn                   = null;
				String            id                    = info.getSession("ID");
				Map<String, String> header              = null;
				Map<String, String> customHeader        = null;
				
				try{
					
					header       = MapUtils.getMap(data, "headerData"); // 조회 조건 조회
					customHeader = new HashMap<String, String>();	
					
					sxp = new SepoaXmlParser(this, "getRfqDT"+header.get("sel_item_no")+"Display");
					sxp.addVar("language", info.getSession("LANGUAGE"));
		        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
		        	
		        	setValue(ssm.doSelect(header, customHeader));

				}catch (Exception e){
					setStatus(0);
					setFlag(false);
					setMessage(e.getMessage());
					Logger.err.println(info.getSession("ID"), this, e.getMessage());
				}

				return getSepoaOut();
				
			} 
							
		
		
		private	int	et_setRfqHDChange(	ConnectionContext ctx, List<Map<String, String>> rqhddata)throws	Exception 
		{ 
			Map<String, String> rqhddataInfo = null;
			int	rtn	         = 0;
			int i            = 0;
			int rqhddataSize = rqhddata.size();

			try{
				for(i = 0; i < rqhddataSize; i++){
					SepoaXmlParser  wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					SepoaSQLManager sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
					
					rqhddataInfo = rqhddata.get(i);
					
					rtn	= rtn + sm.doUpdate(rqhddataInfo);
				}
			}
			catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage());
				
				throw new Exception(e.getMessage()); 
			}
			
			return rtn; 
		} 
		
		//[R101807022454] [2018-11-30] [IT전자입찰시스템] 내외부 데이터 활용 표준 견적 DB 구축
		@SuppressWarnings("unchecked")
		public SepoaOut setRfqDelete(Map<String, Object> param) throws Exception{ 
			
			ConnectionContext ctx = null;
			int rtn = 0;
			//List<Map<String, String>> paramList     = (List<Map<String, String>>)deletedata.get("paramList");
			Map<String, String>       header       = (Map<String, String>)param.get("header");
			
			setStatus(1);
			setFlag(true);
			
			if(	param == null)	{ 
				setStatus(0); 
				setMessage(msg.getMessage("STDRFQ.0005")); 
			}
			else { 
				try	{ 
					ctx =	getConnectionContext(); 
	 
					rtn = this.et_delRfqHDDelete(ctx, header);
					rtn	= this.et_delRfqOPDelete(ctx, header);
					rtn	= this.et_delRfqDTDelete(ctx, header);				
					
					
					setStatus(1); 
					setValue(String.valueOf(rtn)); 
					setMessage(msg.getMessage("STDRFQ.0000")); 
					Commit(); 
				} catch(Exception e) { 
					
					try	{ 
						Rollback(); 
					} catch(Exception d){ 
						Logger.err.println(info.getSession("ID"),this,d.getMessage()); 
					} 
					Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
					setStatus(0); 
					setMessage(msg.getMessage("STDRFQ.0003")); 
				} 
			} 
			return getSepoaOut(); 
		} 
				
	//[R101807022454] [2018-11-30] [IT전자입찰시스템] 내외부 데이터 활용 표준 견적 DB 구축
	@SuppressWarnings("unchecked")
	public SepoaOut setRfqChange(Map<String, Object> param) throws Exception{ 
		ConnectionContext         ctx          = null;
		String[]                  rtn          = null;
		String                    create_type  = (String)param.get("create_type");
		String                    rfq_type     = (String)param.get("rfq_type");
		String                    rfq_flag     = (String)param.get("rfq_flag");
		String                    rfq_no       = (String)param.get("rfq_no");
		String                    pflag        = (String)param.get("pflag");
		
		Map<String, String>       header       = (Map<String, String>)param.get("header");		
		List<Map<String, String>> rqhddata     = (List<Map<String, String>>)param.get("rqhddata");		
		List<Map<String, String>> rqopdata     = (List<Map<String, String>>)param.get("rqopdata");
		List<Map<String, String>> rqdtdata     = (List<Map<String, String>>)param.get("rqdtdata");
		
		List<Map<String, String>> rqepdata     = (List<Map<String, String>>)param.get("rqepdata");
		List<Map<String, String>> rqandata     = (List<Map<String, String>>)param.get("rqandata");
		int	                      rqhd         = 0;
				
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			
			rqhd = this.et_setRfqHDChange(ctx, rqhddata);
			
			this.et_delRfqOPDelete(ctx, header);
			this.et_delRfqDTDelete(ctx, header);				
			
			if(rqopdata != null) {
				this.et_setRfqOPCreate(ctx, rqopdata);
			}
			
			if(rqdtdata != null) {
				this.et_setRfqDTCreate(ctx, rqdtdata);
			}
			
			this.setRfqCreateSignRequestInfo(rfq_flag, rfq_no, pflag, rqhddata, rqdtdata);
			
			setStatus(1); 
			setValue(String.valueOf(rqhd));
			
			msg.setArg("RFQ_NO", rfq_no); 
			
			if(rfq_flag.equals("B")) {
				setMessage(msg.getMessage("STDRFQ.0044")); 
			}
			else if(rfq_flag.equals("C")) {
				setMessage(msg.getMessage("STDRFQ.0044")); 
			}
			else if(rfq_flag.equals("E")) {
				setMessage(msg.getMessage("STDRFQ.0044"));
				
//				setMessage("견적요청번호(" + rfq_no + ") 업체전송 되었습니다.");
				
				Map<String, String> smsParam = new HashMap<String, String>();
				
			    smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
			    smsParam.put("RFQ_NO",      rfq_no);
			    smsParam.put("RFQ_COUNT",   "1");
			    smsParam.put("SMS_MAP2",   "발송됨");
			    
			    new SMS("NONDBJOB", info).rptProcess_ICT(ctx, smsParam);				
			}
			else {
				setMessage(msg.getMessage("STDRFQ.0045")); 
			}
			Commit(); 
		}
		catch(Exception e){
//			e.printStackTrace();
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		finally {}

		return getSepoaOut();	
	}
			
	
    //[R101807022454] [2018-11-30] [IT전자입찰시스템] 내외부 데이터 활용 표준 견적 DB 구축
	@SuppressWarnings("unchecked")
	public SepoaOut setRfqCreate(Map<String, Object> param) throws Exception{ 
		ConnectionContext         ctx          = null;
		String[]                  rtn          = null;
		String                    create_type  = (String)param.get("create_type");
		String                    rfq_type     = (String)param.get("rfq_type");
		String                    rfq_flag     = (String)param.get("rfq_flag");
		String                    rfq_no       = (String)param.get("rfq_no");
		String                    pflag        = (String)param.get("pflag");
		
		List<Map<String, String>> rqhddata     = (List<Map<String, String>>)param.get("rqhddata");		
		List<Map<String, String>> rqopdata     = (List<Map<String, String>>)param.get("rqopdata");
		List<Map<String, String>> rqdtdata     = (List<Map<String, String>>)param.get("rqdtdata");
		
		List<Map<String, String>> rqepdata     = (List<Map<String, String>>)param.get("rqepdata");
		List<Map<String, String>> rqandata     = (List<Map<String, String>>)param.get("rqandata");
		int	                      rqhd         = 0;
				
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			
			rqhd = this.et_setRfqHDCreate(ctx, rqhddata);
			
			if(rqopdata != null) {
				this.et_setRfqOPCreate(ctx, rqopdata);
			}
			
			if(rqdtdata != null) {
				this.et_setRfqDTCreate(ctx, rqdtdata);
			}
			
			this.setRfqCreateSignRequestInfo(rfq_flag, rfq_no, pflag, rqhddata, rqdtdata);
			
			setStatus(1); 
			setValue(String.valueOf(rqhd));
			
			msg.setArg("RFQ_NO", rfq_no); 
			
			if(rfq_flag.equals("B")) {
				setMessage(msg.getMessage("STDRFQ.0044"));							
			}
			else if(rfq_flag.equals("C")) {
				setMessage(msg.getMessage("STDRFQ.0044"));							
			}
			else if(rfq_flag.equals("E")) {
				setMessage(msg.getMessage("STDRFQ.0044"));
				
//				setMessage("견적요청번호(" + rfq_no + ") 업체전송 되었습니다.");
				
				Map<String, String> smsParam = new HashMap<String, String>();
				
			    smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
			    smsParam.put("RFQ_NO",      rfq_no);
			    smsParam.put("RFQ_COUNT",   "1");
			    smsParam.put("SMS_MAP2",   "발송됨");
			    
			    
			    new SMS("NONDBJOB", info).rptProcess_ICT(ctx, smsParam);				
			}
			else {
				setMessage(msg.getMessage("STDRFQ.0045")); 
			}
			Commit(); 
		}
		catch(Exception e){
//			e.printStackTrace();
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		finally {}

		return getSepoaOut();
	}
	
	private	int et_setRfqHDCreate(ConnectionContext ctx, List<Map<String, String>> rqhddata) throws Exception { 
		Map<String, String> rqhddataInfo = null;
		int	rtn	         = 0;
		int i            = 0;
		int rqhddataSize = rqhddata.size();

		try{
			for(i = 0; i < rqhddataSize; i++){
				SepoaXmlParser  wxp = new SepoaXmlParser(this, "et_setRfqHDCreate");
				SepoaSQLManager sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
				
				rqhddataInfo = rqhddata.get(i);
				
				rtn	= rtn + sm.doInsert(rqhddataInfo);
			}
		}
		catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			
			throw new Exception(e.getMessage()); 
		}		
		return rtn; 
	}
	
	private	int	et_delRfqHDDelete(ConnectionContext ctx, Map<String, String>  header)throws	Exception 
	{ 
		int	rtn	= 0; 
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		
		try{ 
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp); 
			rtn	= sm.doDelete(header); 
		
		}catch(Exception e)	{ 
			throw new Exception(e.getMessage()); 
		} 
		return rtn; 
	} 
	
	private	int	et_delRfqOPDelete(ConnectionContext ctx, Map<String, String>  header)throws	Exception 
	{ 
		int	rtn	= 0; 
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		
		try{ 
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp); 
			rtn	= sm.doDelete(header); 
		
		}catch(Exception e)	{ 
			throw new Exception(e.getMessage()); 
		} 
		return rtn; 
	} 
	
	private	int et_setRfqOPCreate(ConnectionContext	ctx, List<Map<String, String>> rqopdata) throws Exception {
		Map<String, String> rqopdataInfo = null;
		int                 rtn          = 0;
		int                 rqopdataSize = rqopdata.size();
		int                 i            = 0;
		
		try{
			for(i = 0; i < rqopdataSize; i++){
				SepoaXmlParser  wxp = new SepoaXmlParser(this, "et_setRfqOPCreate");
				SepoaSQLManager sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp); 
				
				rqopdataInfo = rqopdata.get(i);
				rtn          = rtn + sm.doInsert(rqopdataInfo);
			}
		}
		catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			
			throw new Exception(e.getMessage()); 
		} 
		return rtn;
	}
	
	private	int	et_delRfqDTDelete(	ConnectionContext ctx, Map<String, String> header)throws	Exception 
	{ 
		int	rtn	= 0; 
		SepoaXmlParser wxp = new SepoaXmlParser(this, "et_setRfqDT"+ header.get("sel_item_no") +"Delete");
		
		try{ 
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp); 
			rtn	= sm.doDelete(header); 
		
		}catch(Exception e)	{ 
			throw new Exception(e.getMessage()); 
		} 
		return rtn; 
	} 
	
	private	int et_setRfqDTCreate(ConnectionContext ctx, List<Map<String, String>> rqdtdata) throws Exception {
		Map<String, String> rqdtdataInfo = null;
		int                 rtn          = 0;
		int                 rqdtdataSize = rqdtdata.size();
		int                 i            = 0;
		
		try{
			for(i = 0; i < rqdtdataSize; i++){
				rqdtdataInfo = rqdtdata.get(i);
				
				SepoaXmlParser  wxp = new SepoaXmlParser(this, "et_setRfqDT"+ rqdtdataInfo.get("ITEM_NO") +"Create");				
				SepoaSQLManager sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp); 
				
				rtn          = rtn + sm.doInsert(rqdtdataInfo);
			}
		}
		catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			
			throw new Exception(e.getMessage()); 
		} 

		return rtn;
	}
	
	private void setRfqCreateSignRequestInfo(String rfq_flag, String rfq_no, String pflag, List<Map<String, String>> rqhddata, List<Map<String, String>> rqdtdata) throws Exception{
		String              add_user_id       =  info.getSession("ID");
        String              house_code        =  info.getSession("HOUSE_CODE");
        String              company           =  info.getSession("COMPANY_CODE");
        String              add_user_dept     =  info.getSession("DEPARTMENT");
        String              subject           = null;
        Map<String, String> rqhddataFirstInfo = rqhddata.get(0);
        int                 rqdtdataSize      = rqdtdata.size();
        int                 rqhddataSize      = rqhddata.size();
        int                 signRtn           = 0;
        
        subject = rqhddataFirstInfo.get("SUBJECT");
        
        try {
            if(rfq_flag.equals("B")){
                
            	SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType("RQ");
                sri.setDocNo(rfq_no);
                sri.setDocSeq("1");
                sri.setDocName(subject);
                sri.setItemCount(rqdtdataSize);
                sri.setSignStatus("P");
                sri.setCur("KRW");
                sri.setTotalAmt(Double.parseDouble("0"));
                sri.setSignString(pflag); // AddParameter 에서 넘어온 정보
                sri.setSignRemark(java.net.URLDecoder.decode(sri.getSignRemark(),"UTF-8"));

                signRtn = CreateApproval(info,sri);    //밑에 함수 실행
                
                if(signRtn == 0) {
                    try {
                        Rollback();
                    } catch(Exception d) {
//                    	d.printStackTrace();
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    
                    throw new Exception(msg.getMessage("STDRFQ.0030"));
                }
                
                try{
                	String[] pFlagArray           = pflag.split("$");
            		String[] pFlagArrayFirstArray = pFlagArray[0].split("#");
            		String   fistUserId           = pFlagArrayFirstArray[1].trim();
            		
            		UcMessage.DirectSendMessage(info.getSession("ID"), fistUserId, "전자구매시스템에 견적서 요청 결재 바랍니다.");
                }
                catch(Exception e){ Logger.err.println(info.getSession("ID"),this,e.getMessage()); }
    		} 			
		} catch (Exception e) {
//			e.printStackTrace();
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
		}
	}
	
	
	/**
	 * 빈문자열 처리
	 * 
	 * @param str
	 * @param defaultValue
	 * @return String
	 * @throws Exception
	 */
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
	
	/**
	 * 견적요청 회수
	 * @method setRFQCancel
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-10-07
	 * @modify 2014-10-07
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut setRFQCancel(Map<String, Object> param) throws Exception
	{ 
		ConnectionContext         ctx      = null;
		List<Map<String, String>> recvData     = (List<Map<String, String>>)param.get("recvData");

		int	rtn	= 0; 
		
		try	{ 
			
			
			ctx      = getConnectionContext();
			rtn	= et_setRFQCancel(ctx, recvData); 
 
			setMessage(msg.getMessage("STDRFQ.0038"));	// 견적마감	되었습니다. 
			setValue(Integer.toString(rtn)); 
			setStatus(1); 
			
			
			Map<String, String> recvDataInfo = null;
			int             i   = 0;
			int             recvDataSize = recvData.size();
			
			for(i = 0; i < recvDataSize; i++){
				recvDataInfo = recvData.get(i);
				
				Map<String, String> smsParam = new HashMap<String, String>();
				
			    smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
			    smsParam.put("RFQ_NO",     (String)recvDataInfo.get("rfq_no"));
			    smsParam.put("RFQ_COUNT",   (String)recvDataInfo.get("rfq_count"));
			    smsParam.put("SMS_MAP2",   "회수됨");
			    
			    new SMS("NONDBJOB", info).rptProcess_ICT(ctx, smsParam);		
			}
			
			Commit(); 
  
		}catch(Exception e){ 
			try{Rollback();}catch(Exception	e1){ Logger.err.println(this,e1.getMessage());  } 
			Logger.err.println("Exception e	=" + e.getMessage()); 
 
			setMessage(msg.getMessage("STDRFQ.0039"));	// 견적마감에 실패했습니다. 
			setStatus(0); 
			Logger.err.println(this,e.getMessage()); 
		} 
		return getSepoaOut(); 
	} 
 
	/**
	 * 견적요청 회수
	 * @method et_setRFQCancel
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-10-07
	 * @modify 2014-10-07
	 */
	private	int	et_setRFQCancel(ConnectionContext ctx, List<Map<String, String>> recvData) throws Exception 
	{ 
		
		SepoaXmlParser  wxp = null;
		SepoaSQLManager sm  = null;
		Map<String, String> recvDataInfo = null;
		int	            rtn = 0; 
		int             i   = 0;
		int             recvDataSize = recvData.size();
			
		try	{ 
			for(i = 0; i < recvDataSize; i++){
				wxp = new SepoaXmlParser(this, "et_setRFQCancel");
				sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
				
				recvDataInfo = recvData.get(i);
				rtn          = rtn + sm.doUpdate(recvDataInfo);
			}
		}
		catch(Exception e) { 
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			
			throw new Exception(e.getMessage()); 
		} 
	 
		return rtn; 
		
	} 
	
	
	
	
	
	
				
			/**
			 * 견적기간 마감
			 * @method setRFQClose
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   ICOYRQDT
			 * @since  2014-10-07
			 * @modify 2014-10-07
			 */
			@SuppressWarnings("unchecked")
			public SepoaOut setRFQClose(Map<String, Object> param) throws Exception
			{ 
				ConnectionContext         ctx      = null;
				List<Map<String, String>> recvData     = (List<Map<String, String>>)param.get("recvData");

				int	rtn	= 0; 
				try	{ 
					
					
					ctx      = getConnectionContext();
					rtn	= et_setRFQClose(ctx, recvData); 
		 
					setMessage(msg.getMessage("STDRFQ.0038"));	// 견적마감	되었습니다. 
					setValue(Integer.toString(rtn)); 
					setStatus(1); 
		 
					Commit(); 
		  
				}catch(Exception e){ 
					try{Rollback();}catch(Exception	e1){ Logger.err.println(this,e1.getMessage()); } 
					Logger.err.println("Exception e	=" + e.getMessage()); 
		 
					setMessage(msg.getMessage("STDRFQ.0039"));	// 견적마감에 실패했습니다. 
					setStatus(0); 
					Logger.err.println(this,e.getMessage()); 
				} 
				return getSepoaOut(); 
			} 
		 
			/**
			 * 견적기간 마감 쿼리
			 * @method et_setRFQClose
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   ICOYRQDT
			 * @since  2014-10-07
			 * @modify 2014-10-07
			 */
			private	int	et_setRFQClose(ConnectionContext ctx, List<Map<String, String>> recvData) throws Exception 
			{ 
				
				SepoaXmlParser  wxp = null;
				SepoaSQLManager sm  = null;
				Map<String, String> recvDataInfo = null;
				int	            rtn = 0; 
				int             i   = 0;
				int             recvDataSize = recvData.size();
					
				try	{ 
					for(i = 0; i < recvDataSize; i++){
						wxp = new SepoaXmlParser(this, "et_setRFQClose");
						sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
						
						recvDataInfo = recvData.get(i);
						rtn          = rtn + sm.doUpdate(recvDataInfo);
					}
				}
				catch(Exception e) { 
					Logger.err.println(info.getSession("ID"),this,e.getMessage());
					
					throw new Exception(e.getMessage()); 
				} 
			 
				return rtn; 
				
			} 
			
			/**
			 * 견적기간 마감취소
			 * @method setRFQClose
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   ICOYRQDT
			 * @since  2014-10-07
			 * @modify 2014-10-07
			 */
			@SuppressWarnings("unchecked")
			public SepoaOut setRFQCloseCancel(Map<String, Object> param) throws Exception
			{ 
				ConnectionContext         ctx      = null;
				List<Map<String, String>> recvData     = (List<Map<String, String>>)param.get("recvData");

				int	rtn	= 0; 
				try	{ 
					
					
					ctx      = getConnectionContext();
					rtn	= et_setRFQCloseCancel(ctx, recvData); 
		 
					setMessage(msg.getMessage("STDRFQ.0038"));	// 견적마감	되었습니다. 
					setValue(Integer.toString(rtn)); 
					setStatus(1); 
		 
					Commit(); 
		  
				}catch(Exception e){ 
					try{Rollback();}catch(Exception	e1){ Logger.err.println(this,e1.getMessage()); } 
					Logger.err.println("Exception e	=" + e.getMessage()); 
		 
					setMessage(msg.getMessage("STDRFQ.0039"));	// 견적마감에 실패했습니다. 
					setStatus(0); 
					Logger.err.println(this,e.getMessage()); 
				} 
				return getSepoaOut(); 
			} 
		 
			/**
			 * 견적기간 마감취소 쿼리
			 * @method et_setRFQCloseCancel
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   ICOYRQDT
			 * @since  2014-10-07
			 * @modify 2014-10-07
			 */
			private	int	et_setRFQCloseCancel(ConnectionContext ctx, List<Map<String, String>> recvData) throws Exception 
			{ 
				
				SepoaXmlParser  wxp = null;
				SepoaSQLManager sm  = null;
				Map<String, String> recvDataInfo = null;
				int	            rtn = 0; 
				int             i   = 0;
				int             recvDataSize = recvData.size();
					
				try	{ 
					for(i = 0; i < recvDataSize; i++){
						wxp = new SepoaXmlParser(this, "et_setRFQCloseCancel");
						sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
						
						recvDataInfo = recvData.get(i);
						rtn          = rtn + sm.doUpdate(recvDataInfo);
					}
				}
				catch(Exception e) { 
					Logger.err.println(info.getSession("ID"),this,e.getMessage());
					
					throw new Exception(e.getMessage()); 
				} 
			 
				return rtn; 
				
			} 
			
			
			/**
			 * 견적기간 연장
			 */
			@SuppressWarnings("unchecked")
			public SepoaOut setRFQExtends(Map<String, Object> data) throws Exception{ 
				
				ConnectionContext         ctx      = null;
				SepoaXmlParser            sxp      = null;
				SepoaSQLManager           ssm      = null;
				List<Map<String, String>> grid     = null;
				Map<String, String>       gridInfo = null;
				String                    id       = info.getSession("ID");
				
				setStatus(1);
				setFlag(true);
				

					try {
						ctx = getConnectionContext();
//						header     = MapUtils.getMap(allData, "headerData"); // 헤더 정보 조회
						grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
						
						for(int i = 0; i < grid.size(); i++) {
							gridInfo = grid.get(i);
							
							
							
							setMessage(msg.getMessage("STDRFQ.0000")); 
							
							
							
							sxp = new SepoaXmlParser(this, "et_getRFQStatus");
							ssm = new SepoaSQLManager(id, this, ctx, sxp.getQuery());
							
								Logger.debug.println("rfq_no=="+gridInfo.get("RFQ_NO"));
							Logger.debug.println("RFQ_COUNT=="+gridInfo.get("RFQ_COUNT"));
							
							
							String[] args = { gridInfo.get("RFQ_NO"), gridInfo.get("RFQ_COUNT") };
							String rtnSel	= ssm.doSelect(args); 
							
							SepoaFormater sf = new  SepoaFormater(rtnSel);
							if( sf.getRowCount() > 0 )
							{
								String rfq_status = sf.getValue(0,0);
								if( !"N".equals(rfq_status) )
								{
									setStatus(0);
									setFlag(false);
									setMessage("[ "+gridInfo.get("RFQ_NO") + "] 번호는 견적기간연장대상이 아닙니다.");
									
								}
							}
							
			                sxp = new SepoaXmlParser(this, "et_setRFQExtends");
			                ssm = new SepoaSQLManager(id, this, ctx, sxp);
			                
			                gridInfo.put("RFQ_EXTENDS_DATE", SepoaString.getDateUnSlashFormat(gridInfo.get("RFQ_EXTENDS_DATE")));
			                
			                
			                ssm.doUpdate(gridInfo);
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
					finally {}

					return getSepoaOut();
				
			} 
		 
			/**
			 * 결재 정보를 요청한다.
			 * @param info
			 * @param sri
			 * @return
			 */
			private int CreateApproval(SepoaInfo info,SignRequestInfo sri) throws Exception
		    {
		        Logger.debug.println(info.getSession("ID"),this,"##### CreateApproval #####");
		        
		        SepoaOut wo     = new SepoaOut();
		        SepoaRemote ws  ;
		        String nickName= "p6027";
		        String conType = "NONDBJOB";
		        String MethodName1 = "setConnectionContext";
		        ConnectionContext ctx = getConnectionContext();

		        try
		        {
		            Object[] obj1 = {ctx};
		            String MethodName2 = "addSignRequest";
		            Object[] obj2 = {sri};

		            ws = new SepoaRemote(nickName,conType,info);
		            ws.lookup(MethodName1,obj1);
		            wo = ws.lookup(MethodName2,obj2);
		        }catch(Exception e) {
//		        	e.printStackTrace();
		            Logger.err.println("approval: = " + e.getMessage());
		        }
		        return wo.status ;
		    }
			
			public SepoaOut Approval(SignResponseInfo inf) 
			{ 
				String ans = inf.getSignStatus(); 
				String[] doc_no	= inf.getDocNo(); 
				String[] doc_seq = inf.getDocSeq(); 
				String sign_user_id	= inf.getSignUserId(); 
				String sign_date = inf.getSignDate(); 
		 
				String flag	= ""; 
				String exec_no = ""; 
				String exec_seq	= ""; 
		 
				int	rtn	= -1; 
				int	j =	0; 
		 
				try	{ 
					ConnectionContext ctx =	getConnectionContext(); 
		 
					if(ans.equals("E"))	{  // 완료 
						for(j=0;j <	doc_no.length;j++) { 
							flag = "E"; 
							exec_no	= doc_no[j]; 
							exec_seq = doc_seq[j]; 
		 
							rtn	= et_Approval(ctx, flag, exec_no, exec_seq,	sign_user_id, sign_date	); 
						} 
					} else if(ans.equals("R") || ans.equals("D")) {//반려 OR 취소 
						for(j=0;j <	doc_no.length;j++) { 
		 
							if(ans.equals("R")){  flag = "R";	 } 
							else if(ans.equals("D")){  flag	= "C";	 }	 //효성	TFT요구로 R	==>	C 로 변경(2004/03/26) 
							exec_no	= doc_no[j]; 
							exec_seq = doc_seq[j]; 
		 
							rtn	= et_Reject(ctx, flag, exec_no,	exec_seq, sign_user_id); 
						} 
					} 
		 
					if(	rtn	== 0 ) 
						setStatus(0); 
					else 
						setStatus(1); 
		 
				}catch(Exception e){ 
					try	{ 
						Rollback(); 
					} catch(Exception d) { 
						Logger.err.println(info.getSession("ID"),this,d.getMessage()); 
					} 
					Logger.err.println(this,e.getMessage()); 
					setStatus(0); 
				} 
				return getSepoaOut(); 
			}
			
			private	int	et_Approval(ConnectionContext ctx, String flag,	String exec_no,	String exec_seq, String	sign_user_id, String sign_date)	throws Exception 
			{ 
				String  house_code = info.getSession("HOUSE_CODE");
				String  company_code = info.getSession("COMPANY_CODE");
				
				int	rtn	= 0; 
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("flag", flag);
				wxp.addVar("sign_user_id", sign_user_id);
				wxp.addVar("sign_date", sign_date);
				wxp.addVar("house_code", house_code);
				wxp.addVar("company_code", company_code);
				wxp.addVar("exec_no", exec_no);
				wxp.addVar("exec_seq", exec_seq);
						 
				try	{ 
					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
					rtn	= sm.doUpdate(); 
					
					//업체 메일	전송 
					//setMail(exec_no, exec_seq); 
				} catch(Exception e) { 
					Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
					throw new Exception(e.getMessage()); 
				} 
				return rtn; 
			}
			
						
			private	int	et_Reject(ConnectionContext	ctx, String	flag, String exec_no, String exec_seq, String sign_user_id)	throws Exception 
			{ 
				String house_code = info.getSession("HOUSE_CODE");
				String company_code = info.getSession("COMPANY_CODE");
				
				int	rtn	= 0; 
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					wxp.addVar("flag", flag);
					wxp.addVar("sign_user_id", sign_user_id);
					wxp.addVar("house_code", house_code);
					wxp.addVar("company", company_code);
					wxp.addVar("exec_no", exec_no);
					wxp.addVar("exec_seq", exec_seq);
							 
				try	{ 
					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
		 
					rtn	= sm.doUpdate(); 
				} catch(Exception e) { 
					Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
					throw new Exception(e.getMessage()); 
				} 
				return rtn; 
			}
			
			public SepoaOut getVendorDisplay(Map<String, String> param) throws Exception{ 
				ConnectionContext ctx       = null;
				SepoaXmlParser    sxp       = null;
				SepoaSQLManager   ssm       = null;
				String            rtn       = null;
				String            id        = info.getSession("ID");
				String            houseCode = info.getSession("HOUSE_CODE");
				String            message   = null;
				Map<String, String> header  = null;
				
				try{
					setStatus(1);
					setFlag(true);
					
					ctx = getConnectionContext();
					header     = MapUtils.getMap(param, "headerData"); // 헤더 정보 조회
					
					sxp = new SepoaXmlParser(this, "et_getVendorDisplay");
					ssm = new SepoaSQLManager(id, this, ctx, sxp);
					
					rtn = ssm.doSelect(header); // 조회
					
					try{
						message = msg.getMessage("0000");
					}
					catch(Exception ex){ Logger.err.println(userid, this, ex.getMessage()); }
					
					if(message == null){
						message = "";
					}
					
					setValue(rtn);
					setMessage(message);
				}
				catch(Exception e) {
					//e.printStackTrace();
					Logger.err.println(userid, this, e.getMessage());
					setStatus(0);
					setMessage(msg.getMessage("0001"));
				}
				
				return getSepoaOut(); 
			} 
			
			/* ICT 사용 : 적격업체 업체리스트 가져오기 */
			public SepoaOut getRfqConfirmDetail(Map< String, String > headerData)
			{
		        ConnectionContext ctx = getConnectionContext();
		        String house_code   = info.getSession("HOUSE_CODE"); 
		        String company_code   = info.getSession("COMPANY_CODE"); 

				SepoaXmlParser sxp = null;
				SepoaSQLManager ssm = null;
		        try {

					sxp = new SepoaXmlParser(this, "getRfqConfirmDetail");
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  

		            headerData.put("HOUSE_CODE", house_code);   
		            
		            setValue(ssm.doSelect(headerData));
		 
		            setStatus(1);
		        }catch (Exception e){
		            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
		            setMessage("");
		            setStatus(0);
		        }
		        return getSepoaOut();
		    }
			
			public SepoaOut doConfirm( Map< String, Object > allData ) throws Exception {

		        SepoaOut    so  = null;
		        int rtn = 0;
		        int	intGridRowData  = 0;

		        Map< String, String >           headerData  = null;
		        Map< String, String >           gridRowData = null;
		        List< Map< String, String > >   gridData    = null;
		        try {

		            setFlag( true );
		            setStatus( 1 );

		            headerData  = MapUtils.getMap( allData, "headerData" ); 
		            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );
		 
		            int rtnBDAP = 0;
					//int rtn = et_setBidStatus(ctx, recvData);

		            //Logger.err.println("==gridData.size()==="+gridData.size());
		            if( gridData != null && gridData.size() > 0 ) {// 참가신청 업체가 0일수도 있음으로...
					    rtnBDAP = et_setRQOP(allData);
		            }
		 		            		          
		            setMessage("성공적으로 작업을 수행했습니다.");
		            setStatus(1);
		            setValue("");
		            Commit();	
		           		         
		        }catch (Exception e){
		        	
		        	try	{ 
						Rollback(); 
					} catch(Exception d){ 
						Logger.err.println(info.getSession("ID"),this,d.getMessage()); 
					} 
		        	
		            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
		            setMessage("");
		            setStatus(0);
		        }
		        return getSepoaOut();
		    }
			
			private int et_setRQOP( Map< String, Object > allData ) throws Exception 
		    {
		        ConnectionContext ctx = getConnectionContext();
		        Map< String, String >           headerData  = null;
		        Map< String, String >           gridRowData = null;
		        List< Map< String, String > >   gridData    = null;
		        
		        int rtn = 0;
		        int	intGridRowData  = 0;
		    	try {
		            headerData  = MapUtils.getMap( allData, "headerData", null );
		            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );
		            
		    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setRQOP");
					SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

		            if( gridData != null && gridData.size() > 0 ) {

		                intGridRowData  = gridData.size(); 
		                // 그리드의 데이터 만큼 돌린다.
		                for( int i = 0; i < intGridRowData; i++ ) {
		                    gridRowData = gridData.get( i );
		                    
		                    String confirm_flag = gridRowData.get("CONFIRM_FLAG");
		                    //적합업체인 경우 사유컬럼 지운다
		                    if( "Y".equals(confirm_flag)){
		                    	gridRowData.put("CONFIRM_REASON", "");
		                    }
		                    		                
		            		gridRowData.put("CONFIRM_USER_ID",  info.getSession("ID"));
		            		gridRowData.put("CONFIRM_USER_NAME",  info.getSession("NAME_LOC"));
		                	
		            		rtn = ssm.doInsert(gridRowData);
		                }
		                
		                
		                Map<String, String> smsParam;
		                
		                for( int j = 0; j < intGridRowData; j++ ) {
		                    gridRowData = gridData.get( j );
		                    
		                    if( "N".equals(gridRowData.get("CONFIRM_FLAG"))){
		            			smsParam = new HashMap<String, String>();								
							    smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
							    smsParam.put("RFQ_NO",      gridRowData.get("RFQ_NO"));
							    smsParam.put("RFQ_COUNT",   gridRowData.get("RFQ_COUNT"));
							    smsParam.put("RFQ_SEQ",     gridRowData.get("RFQ_SEQ"));
							    smsParam.put("SMS_MAP2",    "부적합 처리됨");							    
							    new SMS("NONDBJOB", info).rptProcess_ICT(ctx, smsParam);			            			
		            		}else if( "R".equals(gridRowData.get("CONFIRM_FLAG"))){		            			
		            			smsParam = new HashMap<String, String>();								
							    smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
							    smsParam.put("RFQ_NO",      gridRowData.get("RFQ_NO"));
							    smsParam.put("RFQ_COUNT",   gridRowData.get("RFQ_COUNT"));
							    smsParam.put("RFQ_SEQ",     gridRowData.get("RFQ_SEQ"));
							    smsParam.put("SMS_MAP2",    "보완요청 바람");							  
							    new SMS("NONDBJOB", info).rptProcess_ICT(ctx, smsParam);				                    				     
		            		}		            				            				            				           
		                }			                		                      		      
		            }
		            		            		            		         		    
		   		} catch(Exception e) {
		    		Logger.err.println(userid,this,e.getMessage());
		    		throw new Exception(e.getMessage());
		   		}
		   		return rtn;
		    }
			
} 
 
 
