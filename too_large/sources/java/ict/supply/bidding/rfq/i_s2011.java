package	ict.supply.bidding.rfq;  
 
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


public class I_s2011 extends SepoaService 
{ 	
	private boolean bDebug = true;
	private Message msg;

	public I_s2011(String opt, SepoaInfo info) throws SepoaServiceException {
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
	
	public SepoaOut getQtaProList(Map<String, String> header) { 
		
		ConnectionContext ctx                   = getConnectionContext();
		SepoaXmlParser    sxp                   = null;
		SepoaSQLManager   ssm                   = null;
		String            id                    = info.getSession("ID");
		String            rfq_status              = header.get("rfq_status");
		
		
		try{
//			System.out.println(header);
			sxp = new SepoaXmlParser(this, "getQtaProList");
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
		public SepoaOut getRfqHDDisplay(String rfq_no, String rfq_count, String rfq_seq)
		{ 
			try{ 
				String rtn = null; 
	            rtn        = et_getRfqHDDisplay(rfq_no, rfq_count, rfq_seq); 
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
		private	 String et_getRfqHDDisplay(String rfq_no, String rfq_count, String rfq_seq) throws Exception 
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
				String[] data = {rfq_no, rfq_count, rfq_seq};
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
									
		//[R101807022454] [2018-11-30] [IT전자입찰시스템] 내외부 데이터 활용 표준 견적 DB 구축
		@SuppressWarnings("unchecked")
		public SepoaOut setRfqSubmit(Map<String, Object> param) throws Exception{ 
			
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
	 

                    rtn	= this.et_setRfqOPSubmit(ctx, header);				
					
					
					setStatus(1); 
					setValue(String.valueOf(rtn)); 
					setMessage(msg.getMessage("STDRFQ.0000")); 
					
					Map<String, String> smsParam = new HashMap<String, String>();					
				    smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
				    smsParam.put("RFQ_NO",      header.get("rfq_no"));
				    smsParam.put("RFQ_COUNT",   header.get("rfq_count"));
				    smsParam.put("VENDOR_NAME",    header.get("vendor_name"));				    
				    smsParam.put("SMS_MAP3",    "제출함");				    
				    new SMS("NONDBJOB", info).rptProcess2_ICT(ctx, smsParam);	
					
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
		
		private	int	et_setRfqOPSubmit(	ConnectionContext ctx, Map<String, String> header)throws	Exception 
		{ 
			int	rtn	         = 0;
			
			try{
				SepoaXmlParser  wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				SepoaSQLManager sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
				
				rtn	= rtn + sm.doUpdate(header);
			}
			catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage());
				
				throw new Exception(e.getMessage()); 
			}
			
			return rtn; 
		} 
		
		@SuppressWarnings("unchecked")
		public SepoaOut setRfqSubmit2(Map<String, Object> param) throws Exception{ 
			
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
	 

                    rtn	= this.et_setRfqOPSubmit2(ctx, header);				
					
					
					setStatus(1); 
					setValue(String.valueOf(rtn)); 
					setMessage(msg.getMessage("STDRFQ.0000")); 
					
					
					
					Map<String, String> smsParam = new HashMap<String, String>();					
				    smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
				    smsParam.put("RFQ_NO",      header.get("rfq_no"));
				    smsParam.put("RFQ_COUNT",   header.get("rfq_count"));
				    smsParam.put("VENDOR_NAME",    header.get("vendor_name"));				    
				    smsParam.put("SMS_MAP3",    "다시 제출함");				    
				    new SMS("NONDBJOB", info).rptProcess2_ICT(ctx, smsParam);		
				    
					
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
		
		private	int	et_setRfqOPSubmit2(	ConnectionContext ctx, Map<String, String> header)throws	Exception 
		{ 
			int	rtn	         = 0;
			
			try{
				SepoaXmlParser  wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				SepoaSQLManager sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
				
				rtn	= rtn + sm.doUpdate(header);
			}
			catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage());
				
				throw new Exception(e.getMessage()); 
			}
			
			return rtn; 
		}
		
		@SuppressWarnings("unchecked")
		public SepoaOut setRfqGiveUp(Map<String, Object> param) throws Exception{ 
			
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
	 

                    rtn	= this.et_setRfqGiveUp(ctx, header);				
					
					
					setStatus(1); 
					setValue(String.valueOf(rtn)); 
					setMessage(msg.getMessage("STDRFQ.0000")); 
					
					Map<String, String> smsParam = new HashMap<String, String>();					
				    smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
				    smsParam.put("RFQ_NO",      header.get("rfq_no"));
				    smsParam.put("RFQ_COUNT",   header.get("rfq_count"));
				    smsParam.put("VENDOR_NAME",    header.get("vendor_name"));				    
				    smsParam.put("SMS_MAP3",    "제출 포기함");				    
				    new SMS("NONDBJOB", info).rptProcess2_ICT(ctx, smsParam);	
					
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
		
		private	int	et_setRfqGiveUp(	ConnectionContext ctx, Map<String, String> header)throws	Exception 
		{ 
			int	rtn	         = 0;
			
			try{
				SepoaXmlParser  wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				SepoaSQLManager sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
				
				rtn	= rtn + sm.doUpdate(header);
			}
			catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage());
				
				throw new Exception(e.getMessage()); 
			}
			
			return rtn; 
		} 
		
		
		@SuppressWarnings("unchecked")
		public SepoaOut setRfqGiveUp2(Map<String, Object> param) throws Exception{ 
			
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
	 

                    rtn	= this.et_setRfqGiveUp2(ctx, header);				
					
					
					setStatus(1); 
					setValue(String.valueOf(rtn)); 
					setMessage(msg.getMessage("STDRFQ.0000")); 
					
					Map<String, String> smsParam = new HashMap<String, String>();					
				    smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
				    smsParam.put("RFQ_NO",      header.get("rfq_no"));
				    smsParam.put("RFQ_COUNT",   header.get("rfq_count"));
				    smsParam.put("VENDOR_NAME",    header.get("vendor_name"));				    
				    smsParam.put("SMS_MAP3",    "제출 포기함");				    
				    new SMS("NONDBJOB", info).rptProcess2_ICT(ctx, smsParam);	
				    
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
		
		private	int	et_setRfqGiveUp2(	ConnectionContext ctx, Map<String, String> header)throws	Exception 
		{ 
			int	rtn	         = 0;
			
			try{
				SepoaXmlParser  wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				SepoaSQLManager sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
				
				rtn	= rtn + sm.doUpdate(header);
			}
			catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage());
				
				throw new Exception(e.getMessage()); 
			}
			
			return rtn; 
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
} 
 
 
