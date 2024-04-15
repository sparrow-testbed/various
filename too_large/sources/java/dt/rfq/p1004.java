package	dt.rfq;  
 
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
 



public class p1004 extends SepoaService 
{ 
 
/************************************************************** 
---------------------------------------------------------------------------------------------------- 
FUNCTION					  DESC												PATH 
---------------------------------------------------------------------------------------------------- 
setRfqCreate				 견적서요청 생성							   DT>견적관리>견적요청생성 
---------------------------------------------------------------------------------------------------- 
**************************************************************/
	//private	String lang	= info.getSession("LANGUAGE"); 
	//private	Message	msg	= new Message(lang,"STDRFQ"); 
	
	
	private boolean bDebug = true;
	private Message msg;

	public p1004(String opt, SepoaInfo info) throws SepoaServiceException {
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
	
	
	public SepoaOut getRfqVedorList2(Map<String, String> param) throws Exception{ 
		ConnectionContext ctx       = null;
		SepoaXmlParser    sxp       = null;
		SepoaSQLManager   ssm       = null;
		String            rtn       = null;
		String            id        = info.getSession("ID");
		String            houseCode = info.getSession("HOUSE_CODE");
		String            message   = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "et_getRfqVedorList2");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			param.put("houseCode", houseCode);
			
			rtn = ssm.doSelect(param); // 조회
			
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
			
			
			
			
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		
		return getSepoaOut(); 
	} 
	
	/**
	 * 견적요청목록 조회
	 * @param Map<String, Object> data
	 * @return SepoaOut
	 * @since  2014-09-03
	 * @modify 2014-09-30
	 */
	public SepoaOut getRfqList(Map<String, String> header) { 
		
		ConnectionContext ctx                   = getConnectionContext();
		SepoaXmlParser    sxp                   = null;
		SepoaSQLManager   ssm                   = null;
		String            id                    = info.getSession("ID");
		String            rfq_flag              = header.get("rfq_flag");
		
		
		try{
//			System.out.println(header);
			sxp = new SepoaXmlParser(this, "getRfqList");
			sxp.addVar("language", info.getSession("LANGUAGE"));
			sxp.addVar("rfq_flag", rfq_flag);
			
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
		
	

		/**
		 * 조회전 조회 조건 셋팅
		 * 
		 * @param header
		 * @return Map
		 */
		private Map<String, String> getRfqListHeader(Map<String, String> header){
			String userId          = info.getSession("ID");
			String houseCode       = info.getSession("HOUSE_CODE");
			String companyCode     = info.getSession("COMPANY_CODE");
			String location        = info.getSession("LOCATION_CODE");
			String plantCode       = info.getSession("PLANT_CODE");
			String plantCodeIn     = "";
			//String buyerItemNo     = header.get("BUYER_ITEM_NO");
			//String description     = header.get("DESCRIPTION");
			//String descriptionText = header.get("DESCRIPTION_TEXT");
			//String descriptionKey  = null;
			
			if(plantCode.indexOf("&") > 0 ){
				plantCodeIn = SepoaString.str2in(plantCode, "&");
			}
			
			//if("LOC".equals(description)){
			//	descriptionKey = "description_loc";
			//}
			//else{
			//	descriptionKey = "description_eng";
			//}
			
			header.put("house_code",    houseCode);
			header.put("company_code",  companyCode);
			header.put("location",      location);
			header.put("plant_code",    plantCode);
			header.put("plant_code_in", plantCodeIn);
			header.put("user_id",       userId);
			//header.put("item_no",       buyerItemNo);
			//header.put(descriptionKey,  descriptionText);
			
			return header;
		}
		/*
		// 견적요청현황
		private String et_getRfqList(String start_date, String end_date,
		String rfq_no, String subject, String purchaserUser,
		String rfq_flag, String rfq_type) throws Exception {
		String ctrl_code = info.getSession("CTRL_CODE");
		
		// ///////////////////// 직무 코드 관련 처리
		// 입력된 직무코드 가 세션상의 직무 코드에 속하면 where 절에 세션사의 직무 코드가 들어가며 그렇지 않으면 입력된
		// 직무코드가 들어간다.
		
		boolean flag = false;
		
		StringTokenizer st = new StringTokenizer(ctrl_code, "&", false);
		int count = st.countTokens();
		for (int i = 0; i < count; i++) {
		String tmp_ctrl_code = st.nextToken();
		if (purchaserUser.equals(tmp_ctrl_code)) {
		flag = true;
		Logger.debug.println(info.getSession("ID"), this, "============================same ctrl_code");
		break;
		} else
		Logger.debug.println(info.getSession("ID"), this, "==============================	not	same ctrl_code");
		}
		
		String purchaserUser_seperate = "";
		if (flag == true) {
		StringTokenizer st1 = new StringTokenizer(ctrl_code, "&", false);
		int count1 = st1.countTokens();
		
		for (int i = 0; i < count1; i++) {
		String tmp_ctrl_code = st1.nextToken();
		
		if (i == 0)
			purchaserUser_seperate = tmp_ctrl_code;
		else
			purchaserUser_seperate += "','" + tmp_ctrl_code;
		}
		} else {
			purchaserUser_seperate = purchaserUser;
		}
		
		// ////////////////////////직무 코드 관련 처리 끝
		
		String rtn = null;
		
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("rfq_typeIsNull", (rfq_type == null || rfq_type.equals("")));
		wxp.addVar("rfq_type", rfq_type);
		wxp.addVar("rfq_flag", rfq_flag);
		wxp.addVar("flag", flag);
		wxp.addVar("purchaserUser", purchaserUser);
		wxp.addVar("purchaserUser_seperate", purchaserUser_seperate);
		
		try {
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
		String[] data = { info.getSession("HOUSE_CODE"), start_date, end_date, rfq_no, subject, purchaserUser };
		rtn = sm.doSelect(data);
		} catch (Exception e) {
		Logger.err.println(info.getSession("ID"), this, e.getMessage());
		throw new Exception(e.getMessage());
		}
		return rtn;
		} 

		*/
		
		/**
		 * 견적요청 일반정보 조회
		 * @since  2014-09-30
		 * @modify 2014-09-30
		 * @param header
		 * @return Map
		 * @throws Exception
		 */
		public SepoaOut getRfqHDDisplay(String rfq_no, String rfq_count)
		{ 
			try{ 
				String rtn = null; 
	            rtn        = et_getRfqHDDisplay(rfq_no, rfq_count); 
	            setValue(rtn);
				
				String rtn2 = et_getRfqCountInfo(rfq_no, rfq_count);
				  
				if(rtn2 == null){
				            throw new Exception("doing select et_getRfqHDDisplay");
				}
				setValue(rtn2);
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
		private	String et_getRfqHDDisplay(String rfq_no, String rfq_count) throws Exception 
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
				String[] data = {house_code, rfq_no, rfq_count};
				rtn	= ssm.doSelect(data); 
				//rtn	= ssm.doSelect((String[])null); 
			}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		}
		
		private String et_getRfqCountInfo(String rfq_no, String rfq_count) throws Exception 
	    {
			   
			    ConnectionContext ctx                   = getConnectionContext();
				SepoaXmlParser    sxp                   = null;
				SepoaSQLManager   ssm                   = null;
				String            id                    = info.getSession("ID");
				String house_code 						= info.getSession("HOUSE_CODE");
				String            rtn                   = "";
				
			        try
			        {
			        	sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
			            String data[] = {house_code, rfq_no };
			            rtn = ssm.doSelect(data);
			        }
			        catch(Exception exception)
			        {
			            Logger.err.println(id, this, exception.getMessage());
			            throw new Exception(exception.getMessage());
			        }
			        return rtn;	
				
	    }    
		/**
		 * 견적요청 품목수량 조회
		 * @param String rfq_no
		 * @param String rfq_count
		 * @return Map
		 * @since  2014-09-30
		 * @modify 2014-09-30
		*/
		   public SepoaOut getHumtCnt(String rfq_no, String rfq_count)
		    {
			   String s2 = null;
			   
			   try
		        {
		            s2 = et_getHumtCnt(rfq_no, rfq_count);
		            setValue(s2);
		            setStatus(1);
		            setMessage(msg.getMessage("STDRFQ.0000"));
		        }
		        catch(Exception exception)
		        {
		            Logger.err.println(info.getSession("ID"), this, exception.getMessage());
		            setStatus(0);
		            setMessage(msg.getMessage("STDRFQ.0001"));
		        }
		        return getSepoaOut();
		    }

		    private String et_getHumtCnt(String rfq_no, String rfq_count) throws Exception
		    {
		    	
		    	 String rtn = null;
			     String house_code = info.getSession("HOUSE_CODE");
			     
		    	 ConnectionContext ctx = getConnectionContext();
			     SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

			     try
			        {
			        	
			            SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			            String as[] = {house_code, rfq_no, rfq_count};
			            rtn = ssm.doSelect(as);
			        }
			        catch(Exception exception)
			        {
			            Logger.err.println(info.getSession("ID"), this, exception.getMessage());
			            throw new Exception(exception.getMessage());
			        }
			        return rtn;
		    }
		    
		    
		    /**
		     * 견적요청 품목현황 
		     * getRfqDTDisplay
		     * @param  Map<String, Object> data
		     * @return SepoaOut
		     * @throws Exception
		     * @since  2014-09-03
		     * @modify 2014-09-30
		     */
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
					
					
					/*customHeader.put("start_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "start_date", "")));
					customHeader.put("end_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "end_date", "")));
					customHeader.put("add_user_id", MapUtils.getString(header, "add_user_id", ""));
					*/
					
					sxp = new SepoaXmlParser(this, "getRfqDTDisplay");
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
			
			
			/**
			 * 견적요청 수정팝업 업체전송 
			 * @method setRfqChange
			 * @since  2014-10-01
			 * @modify 2014-10-01
			 * @param  Map
			 * @return SepoaOut
			 * @throws Exception
			 */	
			@SuppressWarnings("unchecked")
			public SepoaOut setRfqChange(Map<String, Object> param) throws Exception{ 
				
				
				ConnectionContext         ctx          = null;
				
				String add_user_id                     =  info.getSession("ID");
		        String house_code                      =  info.getSession("HOUSE_CODE");
		        String company                         =  info.getSession("COMPANY_CODE");
		        String add_user_dept                   =  info.getSession("DEPARTMENT");
		        				
				String                    create_type  = (String)param.get("create_type");
				String                    rfq_type     = (String)param.get("rfq_type");
				String                    rfq_flag     = (String)param.get("rfq_flag");
				String                    rfq_no       = (String)param.get("rfq_no");
				String                    rfq_count    = (String)param.get("rfq_count");
				String                    pflag        = (String)param.get("pflag");
				String                    onlyheader   = (String)param.get("onlyheader");
				
				List<Map<String, String>> rqdtdata     = (List<Map<String, String>>)param.get("rqdtdata");
				List<Map<String, String>> chkdata      = (List<Map<String, String>>)param.get("chkdata");
				List<Map<String, String>> prhddata     = (List<Map<String, String>>)param.get("prhddata");
				List<Map<String, String>> prdtdata     = (List<Map<String, String>>)param.get("prdtdata");
				List<Map<String, String>> rqhddata     = (List<Map<String, String>>)param.get("rqhddata");
				List<Map<String, String>> rqopdata     = (List<Map<String, String>>)param.get("rqopdata");
				List<Map<String, String>> rqepdata     = (List<Map<String, String>>)param.get("rqepdata");
				List<Map<String, String>> rqandata     = (List<Map<String, String>>)param.get("rqandata");
				List<Map<String, String>> prcfmdata    = (List<Map<String, String>>)param.get("prcfmdata");
				List<Map<String, String>> rqsedata     = (List<Map<String, String>>)param.get("rqsedata");
				
				Map<String, String> delrqdtdata     = (Map<String, String>)param.get("delrqdtdata");
				Map<String, String> delrqsedata     = (Map<String, String>)param.get("delrqsedata");
				Map<String, String> delrqopdata     = (Map<String, String>)param.get("delrqopdata");
				Map<String, String> delrqepdata     = (Map<String, String>)param.get("delrqdtdata");
				Map<String, String> delrqandata     = (Map<String, String>)param.get("delrqandata");
				Map<String, String> delprhddata     = (Map<String, String>)param.get("delprhddata");
				Map<String, String> delprdtdata     = (Map<String, String>)param.get("delprdtdata");
				
				int	                      rqdt         = 0;
				
		    	setStatus(1);
				setFlag(true);
				
				try {
					ctx = getConnectionContext();
					//*************************************************************************** 
					//* 1. 견적변경가능여부	체크 
					//**************************************************************************** 
					int chkrtn = et_ChkBidCount(ctx, rfq_no, rfq_count); 
					if(chkrtn > 0) { // 입찰자가 있음. 
						setStatus(0); 
						msg.setArg("RFQ_NO", rfq_no); 
						setMessage(msg.getMessage("STDRFQ.0046")); 
						return getSepoaOut(); 
					}  
						
					if(onlyheader.equals("N")) {		//그리드 수정이 있을 경우
						int delrqdt = et_delRQDT(ctx, delrqdtdata);
						int delrqse = et_delRQSE(ctx, delrqsedata);
						int delrqop = et_delRQOP(ctx, delrqopdata);
						int delrqep = et_delRQEP(ctx, delrqepdata);
						
						
						if(delrqandata.size() > 0) {
							int delrqan = et_delRQAN(ctx, delrqandata);
						}
						
						if(create_type.equals("MA")) {		//PR:구매검토목록에서 넘어온 경우, MA:직접입력 PC: ??
							int delprhd = et_delPRHD(ctx, delprhddata);
							int delprdt = et_delPRDT(ctx, delprdtdata);
							int prhd	= et_setPrHDCreate(ctx, prhddata); 
							int	prdt	= et_setPrDTCreate(ctx,	prdtdata); 
						}
						
						
						rqdt =	et_setRfqDTCreate(ctx, rqdtdata); 		//견적의뢰 상세정보 ICOYRQDT 
						
						
						
						if(!rfq_type.equals("OP")){       					//공개견적:OP 지명견적:CL 입력대행:MA 수의계약:PC
							int rqop = et_setRfqOPCreate(ctx,rqopdata); 	//견적의뢰 단가 구매지역 정보 ICOYRQOP  
							int rqse = et_setRfqSECreate(ctx,rqsedata);		//견적의뢰 대상업체정보 ICOYRQSE 
						} 
						
						if(rqepdata.size() > 0) {
							int rqep = et_setRfqEPCreate(ctx,rqepdata);		//견적단가 ICOYQTEP 
						}
						
						if(rqandata.size() > 0) {
							int rqan = et_setRfqANCreate(ctx,rqandata);		//견적의뢰 사양설명서 ICOYRQAN 
						}
					}
					int rtn = et_setRfqHDChange(ctx, rqhddata);				//견적의뢰 일반(MASTER) 정보 ICOYRQHD
					
					this.et_setPRComfirm(ctx, prcfmdata); 					// 구매요청 진행 상태 수정 ICOYPRDT 
					
					this.setRfqCreateSignRequestInfo(rfq_flag, rfq_no, pflag, rqhddata, rqdtdata);
					
					setStatus(1); 
					setValue(String.valueOf(rqdt));
					
					//*************************************************************************** 
					//* 8. RFQ 생성후 결재요청
					//**************************************************************************** 
					// 견적요청에서 RFQ_FLAG = B(결재중)
					
					 /*if(rfq_flag.equals("B"))
						{
			                wisecommon.SignRequestInfo sri = new wisecommon.SignRequestInfo();
			                sri.setHouseCode(house_code);
			                sri.setCompanyCode(company);
			                sri.setDept(add_user_dept);
			                sri.setReqUserId(add_user_id);
			                sri.setDocType("RQ");
			                sri.setDocNo(rfq_no);
			                sri.setDocSeq(rfq_count);
			                sri.setDocName(rqhddata[0][11]);
			                sri.setItemCount(rqdtdata.length);
			                sri.setSignStatus("P");
			                sri.setCur("KRW");
			                sri.setTotalAmt(Double.parseDouble("0"));
			                
			                sri.setSignString(pflag); // AddParameter 에서 넘어온 정보
			                int signRtn = CreateApproval(info,sri);    //밑에 함수 실행
			                if(signRtn == 0) {
			                    try {
			                        Rollback();
			                    } catch(Exception d) {
			                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
			                    }
			                    setStatus(0);
			                    setMessage(msg.getMessage("0030"));
			                    return getSepoaOut();
			                }
						} 
				        
						setStatus(1); 
						setValue(String.valueOf(rtn)); 
						msg.setArg("RFQ_NO",rfq_no); 
						
					*/
					
					
					
					if(rfq_flag.equals("B")) {				//// 견적요청에서 RFQ_FLAG = B(결재중)

						/*wisecommon.SignRequestInfo sri = new wisecommon.SignRequestInfo();
		                sri.setHouseCode(house_code);
		                sri.setCompanyCode(company);
		                sri.setDept(add_user_dept);
		                sri.setReqUserId(add_user_id);
		                sri.setDocType("RQ");
		                sri.setDocNo(rfq_no);
		                sri.setDocSeq(rfq_count);
		                sri.setDocName(rqhddata[0][11]);
		                sri.setItemCount(rqdtdata.length);
		                sri.setSignStatus("P");
		                sri.setCur("KRW");
		                sri.setTotalAmt(Double.parseDouble("0"));
		                
		                sri.setSignString(pflag); // AddParameter 에서 넘어온 정보
		                int signRtn = CreateApproval(info,sri);    //밑에 함수 실행
		                if(signRtn == 0) {
		                    try {
		                        Rollback();
		                    } catch(Exception d) {
		                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
		                    }
		                    setStatus(0);
		                    setMessage(msg.getMessage("0030"));
		                    return getSepoaOut();
		                }
					} 
			        
					setStatus(1); 
					setValue(String.valueOf(rtn)); 
					msg.setArg("RFQ_NO",rfq_no); */
						
						
						setMessage(msg.getMessage("STDRFQ.0044")); 
					}
					else if(rfq_flag.equals("P")) {
						setMessage("견적요청번호 " + rfq_no + " 로 업체전송 되었습니다.");
					}
					else {
						setMessage(msg.getMessage("STDRFQ.0045")); 
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
			
				
			/*public SepoaOut setRfqChange(String pflag, 
					String create_type, 
					String rfq_flag,
					String rfq_type,
					String rfq_no,
					String rfq_count,
					String onlyheader,
					String[][] delrqdtdata,
					String[][] delrqsedata,
					String[][] delrqopdata,
					String[][] delrqepdata,
					String[][] delrqandata,
					String[][] delprhddata,
					String[][] delprdtdata,
					String[][] prhddata, 
					String[][] prdtdata, 
					String[][] rqhddata, 
					String[][] rqdtdata, 
					String[][] rqsedata, 
					String[][] rqopdata, 
					String[][] rqepdata, 
					String[][] rqandata
					) 
		{ 
		try {  
		
			ConnectionContext ctx =	getConnectionContext(); 
		
			*//*************************************************************************** 
				1. 견적변경가능여부	체크 
			****************************************************************************//* 
			int chkrtn = et_ChkBidCount(ctx, rfq_no, rfq_count); 
			if(chkrtn > 0) { // 입찰자가 있음. 
				setStatus(0); 
				msg.setArg("RFQ_NO", rfq_no); 
				setMessage(msg.getMessage("STDRFQ.0046")); 
				return getSepoaOut(); 
			}  
			
			if(onlyheader.equals("N")) {
			
				int delrqdt = et_delRQDT(ctx, delrqdtdata);
				int delrqse = et_delRQSE(ctx, delrqsedata);
				int delrqop = et_delRQOP(ctx, delrqopdata);
				int delrqep = et_delRQEP(ctx, delrqepdata);
		
				if(delrqandata.length > 0) {
					int delrqan = et_delRQAN(ctx, delrqandata);
				}
				
				if(create_type.equals("MA")) {
					int delprhd = et_delPRHD(ctx, delprhddata);
					int delprdt = et_delPRDT(ctx, delprdtdata);
//					int prhd	= et_setPrHDCreate(ctx, prhddata); // tytolee 파라미터 변경되어 주석처리 
//					int	prdt	= et_setPrDTCreate(ctx,	prdtdata);  // tytolee 파라미터 변경되어 주석처리
				}
		
//				int	rqdt =	et_setRfqDTCreate(	ctx,rqdtdata);  // tytolee 파라미터 변경되어 주석처리 
		
				if(!rfq_type.equals("OP"))
				{       
//					int rqop = et_setRfqOPCreate(ctx,rqopdata); // tytolee 파라미터 변경되어 주석처리 
//					int rqse = et_setRfqSECreate(ctx,rqsedata); // tytolee 파라미터 변경되어 주석처리
				} 
				
				if(rqepdata.length > 0) {
//					int rqep = et_setRfqEPCreate(ctx,rqepdata); // tytolee 파라미터 변경되어 주석처리
				}
				
				if(rqandata.length > 0) {
//					int rqan = et_setRfqANCreate(ctx,rqandata); // tytolee 파라미터 변경되어 주석처리
				}
			}
			int rtn = et_setRfqHDChange(ctx, rqhddata);
			
			*//*************************************************************************** 
			 * 8. RFQ 생성후 결재요청
			 ****************************************************************************//* 
	    	String add_user_id     =  info.getSession("ID");
	        String house_code      =  info.getSession("HOUSE_CODE");
	        String company         =  info.getSession("COMPANY_CODE");
	        String add_user_dept   =  info.getSession("DEPARTMENT");
	        // 견적요청에서 RFQ_FLAG = B(결재중)
	        if(rfq_flag.equals("B"))
			{
                wisecommon.SignRequestInfo sri = new wisecommon.SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType("RQ");
                sri.setDocNo(rfq_no);
                sri.setDocSeq(rfq_count);
                sri.setDocName(rqhddata[0][11]);
                sri.setItemCount(rqdtdata.length);
                sri.setSignStatus("P");
                sri.setCur("KRW");
                sri.setTotalAmt(Double.parseDouble("0"));
                
                sri.setSignString(pflag); // AddParameter 에서 넘어온 정보
                int signRtn = CreateApproval(info,sri);    //밑에 함수 실행
                if(signRtn == 0) {
                    try {
                        Rollback();
                    } catch(Exception d) {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.getMessage("STDRFQ.0030"));
                    return getSepoaOut();
                }
			} 
	        
			setStatus(1); 
			setValue(String.valueOf(rtn)); 
			msg.setArg("RFQ_NO",rfq_no); 
			
			if(rfq_flag.equals("B")) {
				setMessage(msg.getMessage("STDRFQ.0044")); 
			} else if(rfq_flag.equals("P")) {
				setMessage("견적요청번호 " + rfq_no + " 로 업체전송 되었습니다.");
			} else {
				setMessage(msg.getMessage("STDRFQ.0022")); 
			}
			Commit(); 
		} catch(Exception e) { 
			try	{ 
				Rollback(); 
			} catch(Exception d) {  
			} 
			setStatus(0); 
		} 
		return getSepoaOut();  
	}*/
			
				
				
	private	int et_ChkBidCount(ConnectionContext ctx, String rfq_no, String rfq_count) throws Exception 
	{ 
					int res = 0; 
					String rtn = null; 
					
					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

			 		try{ 
						SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
						
						String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count};
						rtn	= sm.doSelect(data); 
						
						SepoaFormater wf	= new SepoaFormater(rtn); 
						if(wf.getRowCount() > 0) {
							res = Integer.parseInt(wf.getValue("BID_COUNT", 0));
						}
						
					}catch(Exception e)	{ 
						Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
						throw new Exception(e.getMessage()); 
					} 
					return res; 
				} 
				
		private	int	et_delRQDT(	ConnectionContext ctx, Map<String, String> delrqdtdata)throws	Exception 
			{ 
				int	rtn	= 0; 
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				
		
//				sql.append(" DELETE FROM ICOYRQDT            \n");
//				sql.append(" WHERE HOUSE_CODE = ?            \n");
//				sql.append(" AND   RFQ_NO     = ?            \n");
//				sql.append(" AND   RFQ_COUNT  = ?            \n");
			
				try{ 
			
//					String[] type =	{ "S","S","N" }; 
					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
					rtn	= sm.doInsert(delrqdtdata); 
				
				}catch(Exception e)	{ 
					throw new Exception(e.getMessage()); 
				} 
				return rtn; 
			} 

		private	int	et_delRQSE(	ConnectionContext ctx, Map<String, String> delrqsedata)throws	Exception 
		{ 
			int	rtn	= 0; 
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		
//			sql.append(" DELETE FROM ICOYRQSE            \n");
//			sql.append(" WHERE HOUSE_CODE = ?            \n");
//			sql.append(" AND   RFQ_NO     = ?            \n");
//			sql.append(" AND   RFQ_COUNT  = ?            \n");
		
			try{ 
		
				//String[] type =	{ "S","S","N" }; 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				rtn	= sm.doInsert(delrqsedata); 
			
			}catch(Exception e)	{ 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		} 
		
		private	int	et_delRQOP(	ConnectionContext ctx, Map<String, String> delrqopdata)throws	Exception 
		{ 
			int	rtn	= 0; 
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		
//			sql.append(" DELETE FROM ICOYRQOP            \n");
//			sql.append(" WHERE HOUSE_CODE = ?            \n");
//			sql.append(" AND   RFQ_NO     = ?            \n");
//			sql.append(" AND   RFQ_COUNT  = ?            \n");
		
			try{ 
		
//				String[] type =	{ "S","S","N" }; 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				rtn	= sm.doInsert(delrqopdata); 
			
			}catch(Exception e)	{ 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		} 
		
		private	int	et_delRQEP(	ConnectionContext ctx, Map<String, String> delrqepdata)throws	Exception 
		{ 
			int	rtn	= 0; 
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		
//			sql.append(" DELETE FROM ICOYRQEP            \n");
//			sql.append(" WHERE HOUSE_CODE = ?            \n");
//			sql.append(" AND   RFQ_NO     = ?            \n");
//			sql.append(" AND   RFQ_COUNT  = ?            \n");
		
			try{ 
		
//				String[] type =	{ "S","S","N" }; 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				rtn	= sm.doInsert(delrqepdata); 
			
			}catch(Exception e)	{ 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		} 
		
		private	int	et_delRQAN(	ConnectionContext ctx, Map<String, String> delrqandata)throws	Exception 
		{ 
			int	rtn	= 0; 
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		
//			sql.append(" DELETE FROM ICOYRQAN            \n");
//			sql.append(" WHERE HOUSE_CODE = ?            \n");
//			sql.append(" AND   RFQ_NO     = ?            \n");
//			sql.append(" AND   RFQ_COUNT  = ?            \n");
		
			try{ 
		
//				String[] type =	{ "S","S","N" }; 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				rtn	= sm.doInsert(delrqandata); 
			
			}catch(Exception e)	{ 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		} 
		
		private	int	et_delPRHD(	ConnectionContext ctx, Map<String, String> delprhddata)throws	Exception 
		{ 
			int	rtn	= 0; 
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		
//			sql.append(" DELETE FROM ICOYPRHD            \n");
//			sql.append(" WHERE HOUSE_CODE = ?            \n");
//			sql.append(" AND   PR_NO      = ?            \n");
		
			try{ 
		
//				String[] type =	{ "S","S"}; 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				rtn	= sm.doInsert(delprhddata); 
			
			}catch(Exception e)	{ 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		} 
		
		private	int	et_delPRDT(	ConnectionContext ctx, Map<String, String> delprdtdata)throws	Exception 
		{ 
			int	rtn	= 0; 
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		
//			sql.append(" DELETE FROM ICOYPRDT            \n");
//			sql.append(" WHERE HOUSE_CODE = ?            \n");
//			sql.append(" AND   PR_NO      = ?            \n");
		
			try{ 
		
//				String[] type =	{ "S","S"}; 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				rtn	= sm.doInsert(delprdtdata); 
			
			}catch(Exception e)	{ 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		} 
		
//		private	int et_setPrHDCreate(ConnectionContext ctx, String[][] prhddata) throws Exception 
//		{ 
//			int	rtn	= 0; 
//			
//			try	{ 
//				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
////				StringBuffer sql = new StringBuffer();
//				
////				sql.append(" INSERT INTO ICOYPRHD (       \n");
////				sql.append(" 	 HOUSE_CODE               \n");
////				sql.append(" 	,PR_NO                    \n");
////				sql.append(" 	,STATUS                   \n");
////				sql.append(" 	,COMPANY_CODE             \n");
////				sql.append(" 	,PLANT_CODE               \n");
////				sql.append(" 	,PR_TYPE                  \n");
////				sql.append(" 	,SIGN_STATUS              \n");
////				sql.append(" 	,SIGN_DATE                \n");
////				sql.append(" 	,SIGN_PERSON_ID           \n");
////				sql.append(" 	,SIGN_PERSON_NAME         \n");
////				sql.append(" 	,TEL_NO                   \n");
////				sql.append(" 	,SUBJECT                  \n");
////				sql.append(" 	,ADD_DATE                 \n");
////				sql.append(" 	,ADD_TIME                 \n");
////				sql.append(" 	,ADD_USER_ID              \n");
////				sql.append(" 	,CHANGE_DATE              \n");
////				sql.append(" 	,CHANGE_TIME              \n");
////				sql.append(" 	,CHANGE_USER_ID           \n");
////				sql.append(" ) VALUES (                   \n");
////				sql.append(" 	 ?                        \n");      // HOUSE_CODE         
////				sql.append(" 	,?                        \n");      // PR_NO              
////				sql.append(" 	,?                        \n");      // STATUS             
////				sql.append(" 	,?                        \n");      // COMPANY_CODE       
////				sql.append(" 	,?                        \n");      // PLANT_CODE         
////				sql.append(" 	,?                        \n");      // PR_TYPE            
////				sql.append(" 	,?                        \n");      // SIGN_STATUS        
////				sql.append(" 	,?                        \n");      // SIGN_DATE          
////				sql.append(" 	,?                        \n");      // SIGN_PERSON_ID     
////				sql.append(" 	,?                        \n");      // SIGN_PERSON_NAME   
////				sql.append(" 	,?                        \n");      // TEL_NO             
////				sql.append(" 	,?                        \n");      // SUBJECT            
////				sql.append(" 	,?                        \n");      // ADD_DATE           
////				sql.append(" 	,?                        \n");      // ADD_TIME           
////				sql.append(" 	,?                        \n");      // ADD_USER_ID        
////				sql.append(" 	,?                        \n");      // CHANGE_DATE        
////				sql.append(" 	,?                        \n");      // CHANGE_TIME        
////				sql.append(" 	,?                        \n");      // CHANGE_USER_ID     
////				sql.append(" )                            \n");                            
//	 
//				Logger.debug.println(info.getSession("ID"),this,wxp.getQuery()); 
//				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
//				String[] type = {"S","S","S","S","S"
//								,"S","S","S","S","S"
//								,"S","S","S","S","S"
//								,"S","S","S","S","S"
//								,"S","S"
//								};
//				rtn	= sm.doInsert(prhddata, type); 
//	 
//			} catch(Exception e) { 
//				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
//				throw new Exception(e.getMessage()); 
//			} 
//	 
//			return rtn; 
//		}//et_setPrHDCreate	END
		
	private	int et_setPrHDCreate(ConnectionContext ctx, List<Map<String, String>> prhddata) throws Exception { 
		SepoaXmlParser  wxp = null;
		SepoaSQLManager sm  = null;
		Map<String, String> prhddataInfo = null;
		int	            rtn = 0; 
		int             i   = 0;
		int             prhddataSize = prhddata.size();
			
		try	{ 
			for(i = 0; i < prhddataSize; i++){
				wxp = new SepoaXmlParser(this, "et_setPrHDCreate");
				sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
				
				prhddataInfo = prhddata.get(i);
				rtn          = rtn + sm.doInsert(prhddataInfo);
			}
		}
		catch(Exception e) { 
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			
			throw new Exception(e.getMessage()); 
		} 
	 
		return rtn; 
	} 
	 
//		private	 int et_setPrDTCreate(ConnectionContext ctx, 
//									String[][] prdtdata) throws	Exception 
//		{ 
//	 
//			int	rtn	= 0; 
//	 
//			try	{ 
//				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//			    
////			    sql.append(" INSERT INTO ICOYPRDT (          \n");                         
////			    sql.append(" 		 HOUSE_CODE              \n");                         
////			    sql.append(" 		,PR_NO                   \n");                         
////			    sql.append(" 		,PR_SEQ                  \n");                         
////			    sql.append(" 		,STATUS                  \n");                         
////			    sql.append(" 		,COMPANY_CODE            \n");                         
////			    sql.append(" 		,PLANT_CODE              \n");                         
////			    sql.append(" 		,ITEM_NO                 \n");                         
////			    sql.append(" 		,SHIPPER_TYPE            \n");                         
////			    sql.append(" 		,PR_PROCEEDING_FLAG      \n");                         
////			    sql.append(" 		,PURCHASE_LOCATION       \n");                         
////			    sql.append(" 		,CTRL_CODE               \n");                         
////			    sql.append(" 		,UNIT_MEASURE            \n");                         
////			    sql.append(" 		,PR_QTY                  \n");                         
////			    sql.append(" 		,CONFIRM_QTY             \n");                         
////			    sql.append(" 		,CUR                     \n");                         
////			    sql.append(" 		,LIST_PRICE              \n");                         
////			    sql.append(" 		,UNIT_PRICE              \n");                         
////			    sql.append(" 		,PR_AMT                  \n");                         
////			    sql.append(" 		,RD_DATE                 \n");                         
////			    sql.append(" 		,PURCHASER_ID            \n");                         
////			    sql.append(" 		,PURCHASER_NAME          \n");                         
////			    sql.append(" 		,ATTACH_NO               \n");                         
////			    sql.append(" 		,YEAR_QTY                \n");                         
////			    sql.append(" 		,PURCHASE_DEPT           \n");                         
////			    sql.append(" 		,PURCHASE_DEPT_NAME      \n");                         
////			    sql.append(" 		,ADD_DATE                \n");                         
////			    sql.append(" 		,ADD_USER_ID             \n");                         
////			    sql.append(" 		,ADD_TIME                \n");                         
////			    sql.append(" 		,CHANGE_DATE             \n");                         
////			    sql.append(" 		,CHANGE_USER_ID          \n");                         
////			    sql.append(" 		,CHANGE_TIME             \n");                         
////			    sql.append(" 		,DESCRIPTION_LOC         \n");                         
////			    sql.append(" 		,SPECIFICATION           \n");                         
////			    sql.append(" ) VALUES (                      \n");                         
////			    sql.append(" 		 ?                       \n");  // HOUSE_CODE          
////			    sql.append(" 		,?                       \n");  // PR_NO               
//////			    sql.append(" 		,TO_CHAR(?, 'FM000000')  \n");  // PR_SEQ              
////			    sql.append(" 		,dbo.lpad(?, 5, '0')  \n");  // PR_SEQ              
////			    sql.append(" 		,?                       \n");  // STATUS              
////			    sql.append(" 		,?                       \n");  // COMPANY_CODE        
////			    sql.append(" 		,?                       \n");  // PLANT_CODE          
////			    sql.append(" 		,?                       \n");  // ITEM_NO             
////			    sql.append(" 		,?                       \n");  // SHIPPER_TYPE        
////			    sql.append(" 		,?                       \n");  // PR_PROCEEDING_FLAG  
////			    sql.append(" 		,?                       \n");  // PURCHASE_LOCATION   
////			    sql.append(" 		,?                       \n");  // CTRL_CODE           
////			    sql.append(" 		,?                       \n");  // UNIT_MEASURE        
////			    sql.append(" 		,?                       \n");  // PR_QTY              
////			    sql.append(" 		,?                       \n");  // CONFIRM_QTY         
////			    sql.append(" 		,?                       \n");  // CUR                 
////			    sql.append(" 		,?                       \n");  // LIST_PRICE          
////			    sql.append(" 		,?                       \n");  // UNIT_PRICE          
////			    sql.append(" 		,?                       \n");  // PR_AMT              
////			    sql.append(" 		,?                       \n");  // RD_DATE             
////			    sql.append(" 		,?                       \n");  // PURCHASER_ID        
////			    sql.append(" 		,?                       \n");  // PURCHASER_NAME      
////			    sql.append(" 		,?                       \n");  // ATTACH_NO           
////			    sql.append(" 		,?                       \n");  // YEAR_QTY            
////			    sql.append(" 		,?                       \n");  // PURCHASE_DEPT       
////			    sql.append(" 		,?                       \n");  // PURCHASE_DEPT_NAME  
////			    sql.append(" 		,?                       \n");  // ADD_DATE            
////			    sql.append(" 		,?                       \n");  // ADD_USER_ID         
////			    sql.append(" 		,?                       \n");  // ADD_TIME            
////			    sql.append(" 		,?                       \n");  // CHANGE_DATE         
////			    sql.append(" 		,?                       \n");  // CHANGE_USER_ID      
////			    sql.append(" 		,?                       \n");  // CHANGE_TIME         
////			    sql.append(" 		,?                       \n");  // DESCRIPTION_LOC     
////			    sql.append(" 		,?                       \n");  // SPECIFICATION       
////			    sql.append(" )                               \n");                          
//
//				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
//			    String[] type =	{"S","S","S","S","S"
//								,"S","S","S","S","S"
//								,"S","S","N","N","S"
//								,"N","N","N","S","S"
//								,"S","S","N","S","S"
//								,"S","S","S","S","S"
//								,"S","S","S","S","S"
//								,"S"
//				                }; 
//	 
//				rtn	= sm.doInsert(prdtdata,type); 
//	 
//			} catch(Exception e) { 
//				throw new Exception(e.getMessage()); 
//			} 
//			return rtn; 
//	 
//		}//et_setPrDTCreate	END
		
	private	 int et_setPrDTCreate(ConnectionContext ctx, List<Map<String, String>> prdtdata) throws Exception { 
		Map<String, String> prdtdataInfo = null;
		int	                rtn          = 0;
		int                 prdtdataSize = prdtdata.size();
		int                 i            = 0;

		try	{ 
			for(i = 0; i < prdtdataSize; i++){
				SepoaXmlParser  wxp = new SepoaXmlParser(this, "et_setPrDTCreate");
				SepoaSQLManager sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
				
				prdtdataInfo = prdtdata.get(i);
				
				rtn	= rtn + sm.doInsert(prdtdataInfo);
			}
		}
		catch(Exception e) { 
			throw new Exception(e.getMessage()); 
		} 
		
		return rtn; 
	} 
		
//		private	int et_setRfqHDCreate(	ConnectionContext ctx, 
//											String[][] rqhddata) throws	Exception 
//		{ 
//			int	rtn	= 0; 
//			
//			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//	 
//	 Logger.debug.println(info.getSession("ID"),this,"--------------------------------------"+rqhddata[0].length); 
////			sql.append(" INSERT INTO ICOYRQHD (        \n");                       
////			sql.append(" 		 HOUSE_CODE            \n");                       
////			sql.append(" 		,RFQ_NO                \n");                       
////			sql.append(" 		,RFQ_COUNT             \n");                       
////			sql.append(" 		,STATUS                \n");                       
////			sql.append(" 		,COMPANY_CODE          \n");                       
////			sql.append(" 		,RFQ_DATE              \n");                       
////			sql.append(" 		,RFQ_CLOSE_DATE        \n");                       
////			sql.append(" 		,RFQ_CLOSE_TIME        \n");                       
////			sql.append(" 		,RFQ_TYPE              \n");                       
////			sql.append(" 		,SETTLE_TYPE           \n");                       
////			sql.append(" 		,BID_TYPE              \n");                       
////			sql.append(" 		,RFQ_FLAG              \n");                       
////			sql.append(" 		,TERM_CHANGE_FLAG      \n");                       
////			sql.append(" 		,CREATE_TYPE           \n");                       
////			sql.append(" 		,BID_COUNT             \n");                       
////			sql.append(" 		,CTRL_CODE             \n");                       
////			sql.append(" 		,ADD_USER_ID           \n");                       
////			sql.append(" 		,ADD_DATE              \n");                       
////			sql.append(" 		,ADD_TIME              \n");                       
////			sql.append(" 		,CHANGE_DATE           \n");                       
////			sql.append(" 		,CHANGE_TIME           \n");                       
////			sql.append(" 		,CHANGE_USER_ID        \n");                       
////			sql.append(" 		,SUBJECT               \n");                       
////			sql.append(" 		,REMARK                \n");                       
////			sql.append(" 		,DOM_EXP_FLAG          \n");                       
////			sql.append(" 		,ARRIVAL_PORT          \n");                       
////			sql.append(" 		,USANCE_DAYS           \n");                       
////			sql.append(" 		,SHIPPING_METHOD       \n");                       
////			sql.append(" 		,PAY_TERMS             \n");                       
////			sql.append(" 		,ARRIVAL_PORT_NAME     \n");                       
////			sql.append(" 		,DELY_TERMS            \n");                       
////			sql.append(" 		,PRICE_TYPE            \n");                       
////			sql.append(" 		,SETTLE_COUNT          \n");                       
////			sql.append(" 		,RESERVE_PRICE         \n");                       
////			sql.append(" 		,CURRENT_PRICE         \n");                       
////			sql.append(" 		,BID_DEC_AMT           \n");                       
////			sql.append(" 		,TEL_NO                \n");                       
////			sql.append(" 		,EMAIL                 \n");                       
////			sql.append(" 		,BD_TYPE               \n");                       
////			sql.append(" 		,CUR                   \n");                       
////			sql.append(" 		,START_DATE            \n");                       
////			sql.append(" 		,START_TIME            \n");
////			sql.append(" 		,Z_SMS_SEND_FLAG       \n");
////			sql.append(" 		,Z_RESULT_OPEN_FLAG    \n");
////			sql.append(" 		,BID_REQ_TYPE          \n");
////			sql.append(" 		,BID_RFQ_TYPE          \n");
////			sql.append(" 		,ATTACH_NO             \n");
////			sql.append(" 		,SIGN_STATUS             \n");
////			sql.append(" ) VALUES (                \n");                       
////			sql.append(" 		 ?                     \n");  // HOUSE_CODE        
////			sql.append(" 		,?                     \n");  // RFQ_NO            
////			sql.append(" 		,?                     \n");  // RFQ_COUNT         
////			sql.append(" 		,?                     \n");  // STATUS            
////			sql.append(" 		,?                     \n");  // COMPANY_CODE    
////			
////			sql.append(" 		,?                     \n");  // RFQ_DATE          
////			sql.append(" 		,?                     \n");  // RFQ_CLOSE_DATE    
////			sql.append(" 		,?                     \n");  // RFQ_CLOSE_TIME    
////			sql.append(" 		,?                     \n");  // RFQ_TYPE          
////			sql.append(" 		,?                     \n");  // SETTLE_TYPE
////			
////			sql.append(" 		,?                     \n");  // BID_TYPE          
////			sql.append(" 		,?                     \n");  // RFQ_FLAG          
////			sql.append(" 		,?                     \n");  // TERM_CHANGE_FLAG  
////			sql.append(" 		,?                     \n");  // CREATE_TYPE       
////			sql.append(" 		,?                     \n");  // BID_COUNT
////			
////			sql.append(" 		,?                     \n");  // CTRL_CODE         
////			sql.append(" 		,?                     \n");  // ADD_USER_ID       
////			sql.append(" 		,?                     \n");  // ADD_DATE          
////			sql.append(" 		,?                     \n");  // ADD_TIME          
////			sql.append(" 		,?                     \n");  // CHANGE_DATE
////			
////			sql.append(" 		,?                     \n");  // CHANGE_TIME       
////			sql.append(" 		,?                     \n");  // CHANGE_USER_ID    
////			sql.append(" 		,?                     \n");  // SUBJECT           
////			sql.append(" 		,?                     \n");  // REMARK            
////			sql.append(" 		,?                     \n");  // DOM_EXP_FLAG
////			
////			sql.append(" 		,?                     \n");  // ARRIVAL_PORT      
////			sql.append(" 		,?                     \n");  // USANCE_DAYS       
////			sql.append(" 		,?                     \n");  // SHIPPING_METHOD   
////			sql.append(" 		,?                     \n");  // PAY_TERMS         
////			sql.append(" 		,dbo.GETICOMCODE2(?, 'M005', ?)   \n");  // ARRIVAL_PORT_NAME
////			
////			sql.append(" 		,?                     \n");  // DELY_TERMS        
////			sql.append(" 		,?                     \n");  // PRICE_TYPE        
////			sql.append(" 		,?                     \n");  // SETTLE_COUNT
////			sql.append(" 		,?                     \n");  // RESERVE_PRICE
////			sql.append(" 		,?                     \n");  // CURRENT_PRICE
////			
////			sql.append(" 		,?                     \n");  // BID_DEC_AMT       
////			sql.append(" 		,?                     \n");  // TEL_NO            
////			sql.append(" 		,?                     \n");  // EMAIL             
////			sql.append(" 		,?                     \n");  // BD_TYPE           
////			sql.append(" 		,?                     \n");  // CUR          
////			
////			sql.append(" 		,?                     \n");  // START_DATE        
////			sql.append(" 		,?                     \n");  // START_TIME        
////			sql.append(" 		,?                     \n");  // Z_SMS_SEND_FLAG        
////			sql.append(" 		,?                     \n");  // Z_RESULT_OPEN_FLAG        
////			sql.append(" 		,?                     \n");  // BID_REQ_TYPE
////			
////			sql.append(" 		,?                     \n");  // 
////			sql.append(" 		,?                     \n");  // 
////			sql.append(" 		,?                     \n");  // SIGN_STATUS
////			sql.append(" )                         \n");                       
//	 
//	 
//			try{ 
//				String[] type =	{ "S","S","N","S","S"
//								, "S","S","S","S","S"
//								, "S","S","S","S","S"
//								, "S","S","S","S","S"
//								, "S","S","S","S","S"
//								, "S","S","N","S","S"
//								, "S","S","S","S","N"
//								, "N","N","N","S","S"
//								, "S","S","S","S","S"
//								, "S","S","S","S","S"
//								}; 
//	 
//				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
//				rtn	= sm.doInsert(rqhddata,type); 
//	 
//			}catch(Exception e)	{ 
//				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
//				throw new Exception(e.getMessage()); 
//			} 
//			return rtn; 
//		}
		
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
	
//		private	int	et_setRfqDTCreate(ConnectionContext	ctx, 
//										String[][] rqdtdata) throws	Exception 
//		{ 
//	 
//			int	rtn	= 0; 
//			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//
////			sql.append(" INSERT INTO ICOYRQDT (         \n");
////			sql.append(" 		 HOUSE_CODE             \n");
////			sql.append(" 		,RFQ_NO                 \n");
////			sql.append(" 		,RFQ_COUNT              \n");
////			sql.append(" 		,RFQ_SEQ                \n");
////			sql.append(" 		,STATUS                 \n");
////			
////			sql.append(" 		,COMPANY_CODE           \n");
////			sql.append(" 		,PLANT_CODE             \n");
////			sql.append(" 		,RFQ_PROCEEDING_FLAG    \n");
////			sql.append(" 		,ADD_DATE               \n");
////			sql.append(" 		,ADD_TIME               \n");
////			
////			sql.append(" 		,ADD_USER_ID            \n");
////			sql.append(" 		,CHANGE_DATE            \n");
////			sql.append(" 		,CHANGE_TIME            \n");
////			sql.append(" 		,CHANGE_USER_ID         \n");
////			sql.append(" 		,ITEM_NO                \n");
////			
////			sql.append(" 		,UNIT_MEASURE           \n");
////			sql.append(" 		,RD_DATE                \n");
////			sql.append(" 		,VALID_FROM_DATE        \n");
////			sql.append(" 		,VALID_TO_DATE          \n");
////			sql.append(" 		,PURCHASE_PRE_PRICE     \n");
////			
////			sql.append(" 		,RFQ_QTY                \n");
////			sql.append(" 		,RFQ_AMT                \n");
////			sql.append(" 		,BID_COUNT              \n");
////			sql.append(" 		,CUR                    \n");
////			sql.append(" 		,PR_NO                  \n");
////			
////			sql.append(" 		,PR_SEQ                 \n");
////			sql.append(" 		,SETTLE_FLAG            \n");
////			sql.append(" 		,SETTLE_QTY             \n");
////			sql.append(" 		,TBE_FLAG               \n");
////			sql.append(" 		,TBE_DEPT               \n");
////			
////			sql.append(" 		,PRICE_TYPE             \n");
////			sql.append(" 		,TBE_PROCEEDING_FLAG    \n");
////			sql.append(" 		,SAMPLE_FLAG            \n");
////			sql.append(" 		,DELY_TO_LOCATION       \n");
////			sql.append(" 		,ATTACH_NO              \n");
////			
////			sql.append(" 		,SHIPPER_TYPE           \n");
////			sql.append(" 		,CONTRACT_FLAG          \n");
////			sql.append(" 		,COST_COUNT             \n");
////			sql.append(" 		,YEAR_QTY               \n");
////			sql.append(" 		,DELY_TO_ADDRESS        \n");
////			
////			sql.append(" 		,MIN_PRICE              \n");
////			sql.append(" 		,MAX_PRICE              \n");
////			sql.append(" 		,STR_FLAG               \n");	
////			sql.append(" 		,TBE_NO                 \n");	      //기술견적 평가 추가 2007.4.13
////
////	    sql.append("		,Z_REMARK               \n");
////	    sql.append("		,TECHNIQUE_GRADE        \n");
////	    sql.append("		,TECHNIQUE_TYPE         \n");
////	    sql.append("		,INPUT_FROM_DATE        \n");
////	    sql.append("		,INPUT_TO_DATE          \n");
////	    sql.append("		,TECHNIQUE_FLAG         \n");
////	    sql.append("		,SPECIFICATION          \n");
////	    sql.append("		,MAKER_NAME             \n");
////
////			sql.append(" ) VALUES (                     \n");
////			sql.append(" 		 ?                      \n");//  HOUSE_CODE           
////			sql.append(" 		,?                      \n");//  RFQ_NO               
////			sql.append(" 		,?                      \n");//  RFQ_COUNT            
////			sql.append(" 		,dbo.lpad(?, 6, '0') \n");//  RFQ_SEQ              
////			sql.append(" 		,?                      \n");//  STATUS               
////			
////			sql.append(" 		,?                      \n");//  COMPANY_CODE         
////			sql.append(" 		,?                      \n");//  PLANT_CODE           
////			sql.append(" 		,?                      \n");//  RFQ_PROCEEDING_FLAG  
////			sql.append(" 		,?                      \n");//  ADD_DATE             
////			sql.append(" 		,?                      \n");//  ADD_TIME             
////			
////			sql.append(" 		,?                      \n");//  ADD_USER_ID          
////			sql.append(" 		,?                      \n");//  CHANGE_DATE          
////			sql.append(" 		,?                      \n");//  CHANGE_TIME          
////			sql.append(" 		,?                      \n");//  CHANGE_USER_ID       
////			sql.append(" 		,?                      \n");//  ITEM_NO              
////			
////			sql.append(" 		,?                      \n");//  UNIT_MEASURE         
////			sql.append(" 		,?                      \n");//  RD_DATE              
////			sql.append(" 		,?                      \n");//  VALID_FROM_DATE      
////			sql.append(" 		,?                      \n");//  VALID_TO_DATE        
////			sql.append(" 		,?                      \n");//  PURCHASE_PRE_PRICE   
////			
////			sql.append(" 		,?                      \n");//  RFQ_QTY              
////			sql.append(" 		,?                      \n");//  RFQ_AMT              
////			sql.append(" 		,?                      \n");//  BID_COUNT            
////			sql.append(" 		,?                      \n");//  CUR                  
////			sql.append(" 		,?                      \n");//  PR_NO                
////			
////			sql.append(" 		, dbo.lpad(?, 5, '0')   \n");//  PR_SEQ               
////			sql.append(" 		,?                      \n");//  SETTLE_FLAG          
////			sql.append(" 		,?                      \n");//  SETTLE_QTY           
////			sql.append(" 		,?                      \n");//  TBE_FLAG             
////			sql.append(" 		,?                      \n");//  TBE_DEPT             
////			
////			sql.append(" 		,?                      \n");//  PRICE_TYPE           
////			sql.append(" 		,?                      \n");//  TBE_PROCEEDING_FLAG  
////			sql.append(" 		,?                      \n");//  SAMPLE_FLAG          
////			sql.append(" 		,?                      \n");//  DELY_TO_LOCATION     
////			sql.append(" 		,?                      \n");//  ATTACH_NO            
////			
////			sql.append(" 		,?                      \n");//  SHIPPER_TYPE         
////			sql.append(" 		,?                      \n");//  CONTRACT_FLAG        
////			sql.append(" 		,?                      \n");//  COST_COUNT           
////			sql.append(" 		,?                      \n");//  YEAR_QTY             
////			sql.append(" 		,?                      \n");//  DELY_TO_ADDRESS      
////			
////			sql.append(" 		,?                      \n");//  MIN_PRICE            
////			sql.append(" 		,?                      \n");//  MAX_PRICE            
////			sql.append(" 		,?                      \n");//  STR_FLAG
////			sql.append(" 		,?                      \n");//  TBE_NO
////
////			sql.append(" 		,?                      \n");  
////			sql.append(" 		,?                      \n");  
////			sql.append(" 		,?                      \n");  
////			sql.append(" 		,?                      \n");  
////			sql.append(" 		,?                      \n");  
////			sql.append(" 		,?                      \n");  
////			sql.append(" 		,?                      \n");  
////			sql.append(" 		,?                      \n");  
////			sql.append(" )                              \n");    
//
//			try{ 
//				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery()); 
//	 
//				String[] type =	{"S","S","N","S","S"
//								,"S","S","S","S","S"
//								,"S","S","S","S","S"
//								,"S","S","S","S","N"
//								,"N","N","N","S","S"
//								,"S","S","N","S","S"
//								,"S","S","S","S","S"
//								,"S","S","N","N","S"
//								,"N","N","S","S","S"
//								,"S","S","S","S","S"
//								,"S","S"
//								}; 
//				rtn	= sm.doInsert(rqdtdata,type); 
//	 
//			}catch(Exception e)	{ 
//				throw new Exception(e.getMessage()); 
//			} 
//			return rtn; 
//		}
		
	private	int	et_setRfqDTCreate(ConnectionContext	ctx, List<Map<String, String>> rqdtdata) throws Exception {
		Map<String, String> rqdtdataInfo = null;
		String              rdDate       = null;
		int	                rtn	         = 0; 
		int                 i            = 0;
		int                 rqdtdataSize = rqdtdata.size();
		
		try{
			for(i = 0; i < rqdtdataSize; i++){
				SepoaXmlParser wxp = new SepoaXmlParser(this, "et_setRfqDTCreate");
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp); 
				
				rqdtdataInfo = rqdtdata.get(i);
				rdDate       = rqdtdataInfo.get("RD_DATE");
				rdDate       = rdDate.replaceAll("/", "").replaceAll("-", "");
				
				rqdtdataInfo.put("RD_DATE", rdDate);
				
				rtn	= rtn + sm.doInsert(rqdtdataInfo);
			}
			 
		}
		catch(Exception e)	{ 
			throw new Exception(e.getMessage()); 
		}
		
		return rtn; 
	} 
		
//		private	int	et_setRfqOPCreate(ConnectionContext	ctx, 
//										String[][] rqopdata) throws Exception 
//		{ 
//	 
//			int	rtn	= 0; 	
//			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//			StringBuffer sql = new StringBuffer(); 
//			
//			sql.append(" INSERT INTO ICOYRQOP (       \n");
//			sql.append(" 		 HOUSE_CODE           \n");
//			sql.append(" 		,RFQ_NO               \n");
//			sql.append(" 		,RFQ_COUNT            \n");
//			sql.append(" 		,RFQ_SEQ              \n");
//			sql.append(" 		,PURCHASE_LOCATION    \n");
//			sql.append(" 		,VENDOR_CODE          \n");
//			sql.append(" 		,STATUS               \n");
//			sql.append(" 		,ADD_USER_ID          \n");
//			sql.append(" 		,ADD_DATE             \n");
//			sql.append(" 		,ADD_TIME             \n");
//			sql.append(" 		,CHANGE_DATE          \n");
//			sql.append(" 		,CHANGE_TIME          \n");
//			sql.append(" 		,CHANGE_USER_ID       \n");
//			sql.append(" ) VALUES (                   \n");
//			sql.append(" 		 ?                    \n");      // HOUSE_CODE
//			sql.append(" 		,?                    \n");      // RFQ_NO
//			sql.append(" 		,?                    \n");      // RFQ_COUNT
//			sql.append(" 		,dbo.lpad(?, 6, '0')  \n");      // RFQ_SEQ
//			sql.append(" 		,?                    \n");      // PURCHASE_LOCATION
//			sql.append(" 		,?                    \n");      // VENDOR_CODE
//			sql.append(" 		,?                    \n");      // STATUS
//			sql.append(" 		,?                    \n");      // ADD_USER_ID
//			sql.append(" 		,?                    \n");      // ADD_DATE
//			sql.append(" 		,?                    \n");      // ADD_TIME
//			sql.append(" 		,?                    \n");      // CHANGE_DATE
//			sql.append(" 		,?                    \n");      // CHANGE_TIME
//			sql.append(" 		,?                    \n");      // CHANGE_USER_ID
//			sql.append(" )                            \n");
//
//			try	{ 
//				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
//				String[] type =	{"S","S","N","S","S"
//								,"S","S","S","S","S"
//								,"S","S","S"}; 
//				rtn	= sm.doInsert(rqopdata,type); 
//			} catch(Exception e) { 
//				Logger.err.println(info.getSession("ID"),this,e.getMessage());
//				throw new Exception(e.getMessage()); 
//			} 
//			return rtn; 
//		}
		
	private	int	et_setRfqOPCreate(ConnectionContext	ctx, List<Map<String, String>> rqopdata) throws Exception { 
		Map<String, String> rqopdataInfo = null;
		int	                rtn	         = 0;
		int                 i            = 0;
		int                 rqopdataSize = rqopdata.size();

		try	{
			for(i = 0; i< rqopdataSize; i++){
				SepoaXmlParser wxp = new SepoaXmlParser(this, "et_setRfqOPCreate");
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
				
				rqopdataInfo = rqopdata.get(i);
				
				rtn	= rtn + sm.doInsert(rqopdataInfo);
			}
			 
		}
		catch(Exception e) { 
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			
			throw new Exception(e.getMessage()); 
		}
		
		return rtn; 
	} 
		
//		private	int	et_setRfqSECreate(ConnectionContext	ctx,
//										String[][]	rqsedata 
//									  ) throws Exception 
//		{ 
//	 
//			int	rtn	= 0; 
//			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//
////			sql.append(" INSERT INTO ICOYRQSE (      \n");
////			sql.append(" 		 HOUSE_CODE          \n");
////			sql.append(" 		,VENDOR_CODE         \n");
////			sql.append(" 		,RFQ_NO              \n");
////			sql.append(" 		,RFQ_COUNT           \n");
////			sql.append(" 		,RFQ_SEQ             \n");
////			sql.append(" 		,STATUS              \n");
////			sql.append(" 		,COMPANY_CODE        \n");
////			sql.append(" 		,CONFIRM_FLAG        \n");
////			sql.append(" 		,CONFIRM_DATE        \n");
////			sql.append(" 		,CONFIRM_USER_ID     \n");
////			sql.append(" 		,BID_FLAG            \n");
////			sql.append(" 		,ADD_DATE            \n");
////			sql.append(" 		,ADD_USER_ID         \n");
////			sql.append(" 		,ADD_TIME            \n");
////			sql.append(" 		,CHANGE_DATE         \n");
////			sql.append(" 		,CHANGE_USER_ID      \n");
////			sql.append(" 		,CHANGE_TIME         \n");
////			sql.append(" 		,CONFIRM_TIME        \n");
////			sql.append(" ) VALUES (                  \n");
////			sql.append(" 		 ?                   \n");   // HOUSE_CODE
////			sql.append(" 		,?                   \n");   // VENDOR_CODE
////			sql.append(" 		,?                   \n");   // RFQ_NO
////			sql.append(" 		,?                   \n");   // RFQ_COUNT
////			sql.append(" 		,dbo.lpad(?, 6, '0')   \n");   // RFQ_SEQ
////			sql.append(" 		,?                   \n");   // STATUS
////			sql.append(" 		,?                   \n");   // COMPANY_CODE
////			sql.append(" 		,?                   \n");   // CONFIRM_FLAG
////			sql.append(" 		,?                   \n");   // CONFIRM_DATE
////			sql.append(" 		,?                   \n");   // CONFIRM_USER_ID
////			sql.append(" 		,?                   \n");   // BID_FLAG
////			sql.append(" 		,?                   \n");   // ADD_DATE
////			sql.append(" 		,?                   \n");   // ADD_USER_ID
////			sql.append(" 		,?                   \n");   // ADD_TIME
////			sql.append(" 		,?                   \n");   // CHANGE_DATE
////			sql.append(" 		,?                   \n");   // CHANGE_USER_ID
////			sql.append(" 		,?                   \n");   // CHANGE_TIME
////			sql.append(" 		,?                   \n");   // CONFIRM_TIME
////			sql.append(" )                           \n");                          
//	 
//			try{ 
//	 
//				String[] type =	{"S","S","S","N","S"
//								,"S","S","S","S","S"
//								,"S","S","S","S","S"
//								,"S","S","S"
//								}; 
//				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
//				rtn	= sm.doInsert(rqsedata,type); 
//			}catch(Exception e)	{ 
//				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
//				throw new Exception(e.getMessage()); 
//			} 
//			return rtn; 
//		} 
		
	private	int	et_setRfqSECreate(ConnectionContext	ctx, List<Map<String, String>> rqsedata) throws Exception {
		Map<String, String> rqsedataInfo = null;
		int	                rtn	         = 0;
		int                 i            = 0;
		int                 rqsedataSize = rqsedata.size();
		
		try{
			for(i = 0; i < rqsedataSize; i++){
				SepoaXmlParser  wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				SepoaSQLManager sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
				
				rqsedataInfo = rqsedata.get(i);
				
				rtn	= sm.doInsert(rqsedataInfo);
			}
			 
		}
		catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			
			throw new Exception(e.getMessage()); 
		}
		
		return rtn; 
	} 
		
//		private	int et_setRfqEPCreate(ConnectionContext	ctx, 
//									String[][] rqepdata 
//									) throws Exception 
//		{ 
//	 
//			int rtn = 0;
//			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//			
////			sql.append(" INSERT INTO ICOYRQEP (    \n");
////			sql.append(" 		 HOUSE_CODE        \n");
////			sql.append(" 		,VENDOR_CODE       \n");
////			sql.append(" 		,RFQ_NO            \n");
////			sql.append(" 		,RFQ_COUNT         \n");
////			sql.append(" 		,RFQ_SEQ           \n");
////			sql.append(" 		,COST_SEQ          \n");
////			sql.append(" 		,STATUS            \n");
////			sql.append(" 		,COMPANY_CODE      \n");
////			sql.append(" 		,COST_PRICE_NAME   \n");
////			sql.append(" 		,COST_PRICE_VALUE  \n");
////			sql.append(" 		,ADD_DATE          \n");
////			sql.append(" 		,ADD_TIME          \n");
////			sql.append(" 		,ADD_USER_ID       \n");
////			sql.append(" 		,CHANGE_DATE       \n");
////			sql.append(" 		,CHANGE_TIME       \n");
////			sql.append(" 		,CHANGE_USER_ID    \n");
////			sql.append(" ) VALUES (                \n");
////			sql.append(" 		 ?                 \n");   // HOUSE_CODE
////			sql.append(" 		,?                 \n");   // VENDOR_CODE
////			sql.append(" 		,?                 \n");   // RFQ_NO
////			sql.append(" 		,?                 \n");   // RFQ_COUNT
//////			sql.append(" 		,TO_CHAR(?, 'FM000000') \n");   // RFQ_SEQ
//////			sql.append(" 		,TO_CHAR(?, 'FM000000') \n");   // COST_SEQ
////	    sql.append(" 		,dbo.lpad(?, 6, '0')  \n");  // RFQ_SEQ              
////			sql.append(" 		,dbo.lpad(?, 6, '0')  \n");  // COST_SEQ              
////
////			sql.append(" 		,?                 \n");   // STATUS
////			sql.append(" 		,?                 \n");   // COMPANY_CODE
////			sql.append(" 		,?                 \n");   // COST_PRICE_NAME
////			sql.append(" 		,?                 \n");   // COST_PRICE_VALUE
////			sql.append(" 		,?                 \n");   // ADD_DATE
////			sql.append(" 		,?                 \n");   // ADD_TIME
////			sql.append(" 		,?                 \n");   // ADD_USER_ID
////			sql.append(" 		,?                 \n");   // CHANGE_DATE
////			sql.append(" 		,?                 \n");   // CHANGE_TIME
////			sql.append(" 		,?                 \n");   // CHANGE_USER_ID
////			sql.append(" )                         \n");
//	 
//			try{ 
//				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
//				String[] type =	{"S","S","S","N","S"
//								,"S","S","S","S","S"
//								,"S","S","S","S","S"
//								,"S"
//								}; 
//				
//				rtn = sm.doInsert(rqepdata,type); 
//			}catch(Exception e)	{ 
//				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
//				throw new Exception(e.getMessage()); 
//			} 
//			
//			return rtn;
//		} 
		
	private	int et_setRfqEPCreate(ConnectionContext	ctx, List<Map<String, String>> rqepdata) throws Exception {
		Map<String, String> rqepdataInfo = null;
		int                 rtn          = 0;
		int                 rqepdataSize = rqepdata.size();
		int                 i            = 0;
		
		try{
			for(i = 0; i < rqepdataSize; i++){
				SepoaXmlParser  wxp = new SepoaXmlParser(this, "et_setRfqEPCreate");
				SepoaSQLManager sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp); 
				
				rqepdataInfo = rqepdata.get(i);
				rtn          = rtn + sm.doInsert(rqepdataInfo);
			}
		}
		catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			
			throw new Exception(e.getMessage()); 
		} 

		return rtn;
	}
		
//		private	int et_setRfqANCreate(ConnectionContext	ctx, 
//									String[][] rqandata 
//									) throws Exception 
//		{ 
//	 
//			int rtn = 0;
//			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//			StringBuffer sql = new StringBuffer();
//			
//			sql.append(" INSERT INTO ICOYRQAN (      \n");
//			sql.append(" 		 HOUSE_CODE          \n");
//			sql.append(" 		,RFQ_NO              \n");
//			sql.append(" 		,RFQ_COUNT           \n");
//			sql.append(" 		,STATUS              \n");
//			sql.append(" 		,COMPANY_CODE        \n");
//			sql.append(" 		,ANNOUNCE_DATE       \n");
//			sql.append(" 		,ANNOUNCE_TIME_FROM  \n");
//			sql.append(" 		,ANNOUNCE_TIME_TO    \n");
//			sql.append(" 		,ANNOUNCE_HOST       \n");
//			sql.append(" 		,ANNOUNCE_AREA       \n");
//			sql.append(" 		,ANNOUNCE_PLACE      \n");
//			sql.append(" 		,ANNOUNCE_NOTIFIER   \n");
//			sql.append(" 		,ANNOUNCE_RESP       \n");
//			sql.append(" 		,DOC_FRW_DATE        \n");
//			sql.append(" 		,ADD_USER_ID         \n");
//			sql.append(" 		,ADD_DATE            \n");
//			sql.append(" 		,ADD_TIME            \n");
//			sql.append(" 		,CHANGE_USER_ID      \n");
//			sql.append(" 		,CHANGE_DATE         \n");
//			sql.append(" 		,CHANGE_TIME         \n");
//			sql.append(" 		,ANNOUNCE_COMMENT    \n");
//			sql.append(" ) VALUES (                  \n");
//			sql.append(" 		 ?                   \n");  //  HOUSE_CODE
//			sql.append(" 		,?                   \n");  //  RFQ_NO
//			sql.append(" 		,?                   \n");  //  RFQ_COUNT
//			sql.append(" 		,?                   \n");  //  STATUS
//			sql.append(" 		,?                   \n");  //  COMPANY_CODE
//			sql.append(" 		,?                   \n");  //  ANNOUNCE_DATE
//			sql.append(" 		,?                   \n");  //  ANNOUNCE_TIME_FROM
//			sql.append(" 		,?                   \n");  //  ANNOUNCE_TIME_TO
//			sql.append(" 		,?                   \n");  //  ANNOUNCE_HOST
//			sql.append(" 		,?                   \n");  //  ANNOUNCE_AREA
//			sql.append(" 		,?                   \n");  //  ANNOUNCE_PLACE
//			sql.append(" 		,?                   \n");  //  ANNOUNCE_NOTIFIER
//			sql.append(" 		,?                   \n");  //  ANNOUNCE_RESP
//			sql.append(" 		,?                   \n");  //  DOC_FRW_DATE
//			sql.append(" 		,?                   \n");  //  ADD_USER_ID
//			sql.append(" 		,?                   \n");  //  ADD_DATE
//			sql.append(" 		,?                   \n");  //  ADD_TIME
//			sql.append(" 		,?                   \n");  //  CHANGE_USER_ID
//			sql.append(" 		,?                   \n");  //  CHANGE_DATE
//			sql.append(" 		,?                   \n");  //  CHANGE_TIME
//			sql.append(" 		,?                   \n");  //  ANNOUNCE_COMMENT
//			sql.append(" )                           \n");
//	 
//			try{ 
//				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
//				String[] type =	{"S","S","N","S","S"
//								,"S","S","S","S","S"
//								,"S","S","S","S","S"
//								,"S","S","S","S","S"
//								,"S"
//								}; 
//				
//				rtn = sm.doInsert(rqandata,type); 
//			}catch(Exception e)	{ 
//				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
//				throw new Exception(e.getMessage()); 
//			} 
//			
//			return rtn;
//		}
		
	private	int et_setRfqANCreate(ConnectionContext	ctx, List<Map<String, String>> rqandata) throws Exception { 
		int rtn = 0;
		
		try{
			SepoaXmlParser  wxp = new SepoaXmlParser(this, "et_setRfqANCreate");
			SepoaSQLManager sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp); 
			 

			rtn = sm.doInsert(rqandata); 
		}
		catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			
			throw new Exception(e.getMessage()); 
		} 

		return rtn;
	} 
		
		private	int	et_setRfqHDChange(	ConnectionContext ctx, 
				List<Map<String, String>> rqhddata)throws	Exception 
		{ 
		int	rtn	= 0; 
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	
		try{ 
		
//		String[] type =	{ "S","S","S","S","S"
//				, "S","S","S","S","S"
//				, "S","S","S","S","S"
//				, "N","S","S","S","S"
//				, "S","S","S","S","S"
//				, "S","S","S","S","N"
//				}; 
		SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
		rtn	= sm.doUpdate(rqhddata); 
		
		}catch(Exception e)	{ 
		throw new Exception(e.getMessage()); 
		} 
		return rtn; 
		} 

		/**
		 * 견적요청정보 삭제
		 * @method setRfqDelete
		 * @param  header
		 * @return Map
		 * @throws Exception
		 * @desc   ICOYRQDT
		 * @since  2014-10-20
		 * @modify 2014-10-20
		 */
		public SepoaOut setRfqDelete(Map<String, Object> deletedata) throws Exception{ 
			
			int rtn = 0;
			//List<Map<String, String>> paramList     = (List<Map<String, String>>)deletedata.get("paramList");
			
			
			if(	deletedata == null)	{ 
				setStatus(0); 
				setMessage(msg.getMessage("STDRFQ.0005")); 
			}
			else { 
				try	{ 
	
					ConnectionContext ctx =	getConnectionContext(); 
	 
					rtn	= et_setRfqHDChange_delete(ctx,deletedata); 
					
					rtn	= et_setRfqDTDelete(ctx,deletedata); 
					
					rtn	= et_setRfqANDelete(ctx,deletedata); 
					
					rtn	= et_setRfqEPDelete(ctx,deletedata); 
					
					rtn	= et_setRfqOPChange_delete(ctx,deletedata); 
					
					rtn	= et_setRfqDelete_return(ctx, deletedata); 
					
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
		
		/**
		 * 견적요청정보 삭제 (견적의뢰 일반정보, ICOYRQHD)
		 * @method et_setRfqHDChange_delete
		 * @param  header
		 * @return Map
		 * @throws Exception
		 * @desc   ICOYRQDT
		 * @since  2014-10-20
		 * @modify 2014-10-20
		 */
		@SuppressWarnings("unchecked")
		private	int	et_setRfqHDChange_delete(ConnectionContext ctx, Map<String, Object> deletedata) throws Exception 
		{ 

			//List<Map<String, String>> grid     = (List<Map<String, String>>)deletedata.get("paramList");
			
	        SepoaXmlParser            sxp      = null;
			SepoaSQLManager           ssm      = null;
			List<Map<String, String>> grid     = (List<Map<String, String>>)deletedata.get("paramList");
			Map<String, String>       gridInfo = null;
			String                    id       = info.getSession("ID");
	        
	    	setStatus(1);
			setFlag(true);
			
			int	rtn	= 0; 
			
			try {
				//grid = (List<Map<String, String>>)MapUtils.getObject(deletedata, "gridData");
				
				for(int i = 0; i < grid.size(); i++) {
					gridInfo = grid.get(i);
					
	                sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	                ssm = new SepoaSQLManager(id, this, ctx, sxp);
	                
	                gridInfo.put("USER_ID",      info.getSession("ID"));
	                
	                rtn += ssm.doUpdate(gridInfo);
	            }
				
				//Commit();
			
			}
			catch(Exception e){
				Rollback();
				setStatus(0);
				setFlag(false);
				setMessage(e.getMessage());
				Logger.err.println(info.getSession("ID"), this, e.getMessage());
			}
			finally {}

			return rtn;
		}
		
		/**
		 * 견적요청 상세정보 삭제 (견적의뢰 일반정보, ICOYRQDT)
		 * @method et_setRfqDTDelete
		 * @param  header
		 * @return Map
		 * @throws Exception
		 * @desc   ICOYRQDT
		 * @since  2014-10-20
		 * @modify 2014-10-20
		 */
		private	int	et_setRfqDTDelete(ConnectionContext	ctx,Map<String, Object> deletedata) throws Exception 
		{ 
			SepoaXmlParser            sxp      = null;
			SepoaSQLManager           ssm      = null;
			List<Map<String, String>> grid     = (List<Map<String, String>>)deletedata.get("paramList");
			Map<String, String>       gridInfo = null;
			String                    id       = info.getSession("ID");
	        
	    	setStatus(1);
			setFlag(true);
			
			int	rtn	= 0; 
			
			try {
				//grid = (List<Map<String, String>>)MapUtils.getObject(deletedata, "gridData");
				
				for(int i = 0; i < grid.size(); i++) {
					gridInfo = grid.get(i);
					
	                sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	                ssm = new SepoaSQLManager(id, this, ctx, sxp);
	                
	                gridInfo.put("USER_ID",      info.getSession("ID"));
	                
	                rtn += ssm.doUpdate(gridInfo);
	            }
				
				//Commit();
			
			}
			catch(Exception e){
				Rollback();
				setStatus(0);
				setFlag(false);
				setMessage(e.getMessage());
				Logger.err.println(info.getSession("ID"), this, e.getMessage());
			}
			finally {}

			return rtn;
		} 
		
		/**
		 * 견적요청 상세정보 삭제 (제안설명회정보, ICOYRQAN)
		 * @method et_setRfqANDelete
		 * @param  header
		 * @return Map
		 * @throws Exception
		 * @desc   ICOYRQDT
		 * @since  2014-10-20
		 * @modify 2014-10-20
		 */
		private	int	et_setRfqANDelete(ConnectionContext ctx,Map<String, Object> deletedata) throws Exception 
		{ 
			SepoaXmlParser            sxp      = null;
			SepoaSQLManager           ssm      = null;
			List<Map<String, String>> grid     = (List<Map<String, String>>)deletedata.get("paramList");
			Map<String, String>       gridInfo = null;
			String                    id       = info.getSession("ID");
	        
	    	setStatus(1);
			setFlag(true);
			
			int	rtn	= 0; 
			
			try {
				//grid = (List<Map<String, String>>)MapUtils.getObject(deletedata, "gridData");
				
				for(int i = 0; i < grid.size(); i++) {
					gridInfo = grid.get(i);
					
	                sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	                ssm = new SepoaSQLManager(id, this, ctx, sxp);
	                
	                gridInfo.put("USER_ID",      info.getSession("ID"));
	                
	                rtn += ssm.doUpdate(gridInfo);
	            }
				
				//Commit();
			
			}
			catch(Exception e){
				Rollback();
				setStatus(0);
				setFlag(false);
				setMessage(e.getMessage());
				Logger.err.println(info.getSession("ID"), this, e.getMessage());
			}
			finally {}

			return rtn; 
		} 
		
		/**
		 * 견적요청 상세정보 삭제 (견적의뢰상세원가정보, ICOYRQEP)
		 * @method et_setRfqEPDelete
		 * @param  header
		 * @return Map
		 * @throws Exception
		 * @desc   ICOYRQDT
		 * @since  2014-10-20
		 * @modify 2014-10-20
		 */
		private	int	et_setRfqEPDelete(ConnectionContext ctx,Map<String, Object> deletedata) throws Exception 
		{ 
			SepoaXmlParser            sxp      = null;
			SepoaSQLManager           ssm      = null;
			List<Map<String, String>> grid     = (List<Map<String, String>>)deletedata.get("paramList");
			Map<String, String>       gridInfo = null;
			String                    id       = info.getSession("ID");
	        
	    	setStatus(1);
			setFlag(true);
			
			int	rtn	= 0; 
			
			try {
				//grid = (List<Map<String, String>>)MapUtils.getObject(deletedata, "gridData");
				
				for(int i = 0; i < grid.size(); i++) {
					gridInfo = grid.get(i);
					
	                sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	                ssm = new SepoaSQLManager(id, this, ctx, sxp);
	                
	                gridInfo.put("USER_ID",      info.getSession("ID"));
	                
	                rtn += ssm.doUpdate(gridInfo);
	            }
				
				//Commit();
			
			}
			catch(Exception e){
				Rollback();
				setStatus(0);
				setFlag(false);
				setMessage(e.getMessage());
				Logger.err.println(info.getSession("ID"), this, e.getMessage());
			}
			finally {}

			return rtn; 
		} 
		
		/**
		 * 견적요청 상세정보 삭제 (견적의뢰단가구매지역정보, ICOYRQOP)
		 * @method et_setRfqOPChange_delete
		 * @param  header
		 * @return Map
		 * @throws Exception
		 * @desc   ICOYRQDT
		 * @since  2014-10-20
		 * @modify 2014-10-20
		 */
		private	int	et_setRfqOPChange_delete(ConnectionContext ctx,Map<String, Object> deletedata) throws Exception 
		{ 
			SepoaXmlParser            sxp      = null;
			SepoaSQLManager           ssm      = null;
			List<Map<String, String>> grid     = (List<Map<String, String>>)deletedata.get("paramList");
			Map<String, String>       gridInfo = null;
			String                    id       = info.getSession("ID");
	        
	    	setStatus(1);
			setFlag(true);
			
			int	rtn	= 0; 
			
			try {
				//grid = (List<Map<String, String>>)MapUtils.getObject(deletedata, "gridData");
				
				for(int i = 0; i < grid.size(); i++) {
					gridInfo = grid.get(i);
					
	                sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	                ssm = new SepoaSQLManager(id, this, ctx, sxp);
	                
	                gridInfo.put("USER_ID",      info.getSession("ID"));
	                
	                rtn += ssm.doUpdate(gridInfo);
	            }
				
				//Commit();
			
			}
			catch(Exception e){
				Rollback();
				setStatus(0);
				setFlag(false);
				setMessage(e.getMessage());
				Logger.err.println(info.getSession("ID"), this, e.getMessage());
			}
			finally {}

			return rtn; 
		} 
		
		
		 
		/**
		 * 삭제 후	______청구검토목록으로.	견적요청 현황  (견적의뢰단가구매지역정보, ICOYRQDT)
		 * @method et_setRfqDelete_return
		 * @param  header
		 * @return Map
		 * @throws Exception
		 * @desc   ICOYRQDT
		 * @since  2014-10-20
		 * @modify 2014-10-20
		 */
		@SuppressWarnings("deprecation")
		private	int	et_setRfqDelete_return(ConnectionContext ctx, Map<String, Object> deletedata)	throws Exception 
		{ 
			SepoaXmlParser            sxp      = null;
			SepoaSQLManager           ssm      = null;
			List<Map<String, String>> grid     = (List<Map<String, String>>)deletedata.get("paramList");
			Map<String, String>       gridInfo = null;
			String                    id       = info.getSession("ID");
			
			setStatus(1);
			setFlag(true);
			
			int	rtn	= 0; 
			
			String value                       = ""; 
			Map<String, String> return_value   = new HashMap<String ,String>(); 
	    	
			
			try {
				//grid = (List<Map<String, String>>)MapUtils.getObject(deletedata, "gridData");
				
				for(int i = 0; i < grid.size(); i++) {
					gridInfo = grid.get(i);
					
	                sxp = new SepoaXmlParser(this, "et_setRfqDelete_return");
	                ssm = new SepoaSQLManager(id, this, ctx, sxp);
	                
	                gridInfo.put("USER_ID",      info.getSession("ID"));
	                
	                value =	ssm.doSelect(gridInfo); 
					SepoaFormater wf	= new SepoaFormater(value); 
		 
					if(wf.getRowCount()>0) { 
						
						for(int j=0; j < wf.getRowCount();j++){

							sxp = new SepoaXmlParser(this, "et_setRfqDelete_return_2");
							return_value.put("pr_no"    , wf.getValue("PR_NO",j));
							return_value.put("pr_seq"   , wf.getValue("PR_SEQ",j));
							ssm = new SepoaSQLManager(id, this, ctx, sxp);
				               
							//String[] type =	{"S","S","S"}; 
							rtn	= ssm.doUpdate(return_value);

						}
					}
	            }
				
				//Commit();
			
			}catch(Exception e){
				Rollback();
				setStatus(0);
				setFlag(false);
				setMessage(e.getMessage());
				Logger.err.println(info.getSession("ID"), this, e.getMessage());
			}
			finally {}
		
			/*String house_code =	info.getSession("HOUSE_CODE"); 
	 
			int	rtn	= 0; 
			String value = ""; 
			String[][] return_value	= null; 
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	 
//			StringBuffer sql = new StringBuffer(); 
//			sql.append(" SELECT	HOUSE_CODE, PR_NO,PR_SEQ FROM ICOYRQDT          \n"); 
//			sql.append(" <OPT=F,S> WHERE    HOUSE_CODE = ?  </OPT>  \n"); 
//			sql.append(" <OPT=S,S> AND  RFQ_NO         = ?  </OPT>  \n"); 
//			sql.append(" <OPT=S,N> AND  RFQ_COUNT      = ?  </OPT>  \n"); 
	 
			 
//			StringBuffer sql1 =	new	StringBuffer(); 
//			sql1.append(" UPDATE  ICOYPRDT	SET	PR_PROCEEDING_FLAG	= 'P'  \n");
//			sql1.append(" WHERE		HOUSE_CODE = ?      \n");
//			sql1.append(" AND		PR_NO  = ?                         \n");
//			sql1.append(" AND		PR_SEQ	= ?	                       \n");
	 
			try	{ 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
	            String[] data = {house_code, rfq_no, rfq_count};
				value =	sm.doSelect(data); 
				SepoaFormater wf	= new SepoaFormater(value); 
	 
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
				if(wf.getRowCount()>0) { 
					return_value = wf.getValue(); 
					sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery()); 
					String[] type =	{"S","S","S"}; 
	 
					rtn	= sm.doUpdate(return_value,type); 
				} 
			} catch(Exception e) { 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
			} */
	 
			return rtn; 
		} 
		/*public SepoaOut setRfqDelete(String[][]	deletedata ) 
		{ 
	 
			if(	deletedata == null)	{ 
				setStatus(0); 
				setMessage(msg.getMessage("STDRFQ.0005")); 
			}
			else { 
				try	{ 
					ConnectionContext ctx =	getConnectionContext(); 
	 
					int	rtn	= et_setRfqHDChange_delete(ctx,deletedata); 
					et_setRfqDTDelete(ctx,deletedata); 
					et_setRfqANDelete(ctx,deletedata); 
					et_setRfqEPDelete(ctx,deletedata); 
					et_setRfqOPChange_delete(ctx,deletedata); 
	 
					for(int	i =	0 ;	i <	deletedata.length ;	i++) { 
						et_setRfqDelete_return(ctx, deletedata[i][1], deletedata[i][2]); 
					} 
	 
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
		} */
	 
		/*private	int	et_setRfqHDChange_delete(ConnectionContext ctx,String[][] deletedata) throws Exception 
		{ 
			int	rtn	= 0; 
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//			StringBuffer sql = new StringBuffer(); 
//			sql.append(" UPDATE	ICOYRQHD SET STATUS	= 'D'       \n"); 
//			sql.append(" WHERE	HOUSE_CODE  = ?                 \n"); 
//			sql.append(" AND	RFQ_NO	    = ?	                \n"); 
//			sql.append(" AND	RFQ_COUNT   = ?                 \n"); 
	 
			try	{ 
				String[] type =	{"S","S","N"}; 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
	 
				rtn	= sm.doUpdate(deletedata,type); 
			} catch(Exception e) { 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		} */
	 
		/*private	int	et_setRfqDTDelete(ConnectionContext	ctx,String[][] deletedata) throws Exception 
		{ 
			int	rtn	= 0; 
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			
//			StringBuffer sql = new StringBuffer(); 
//			sql.append(" UPDATE	ICOYRQDT SET STATUS	= 'D'       \n"); 
//			sql.append(" WHERE	HOUSE_CODE  = ?                 \n"); 
//			sql.append(" AND	RFQ_NO      = ?	                \n"); 
//			sql.append(" AND	RFQ_COUNT   = ?                 \n"); 
	 
			try	{ 
				String[] type =	{"S","S","N"}; 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
	 
				rtn	= sm.doUpdate(deletedata,type); 
			} catch(Exception e) { 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		} */

		/*private	int	et_setRfqANDelete(ConnectionContext ctx,String[][] deletedata) throws Exception 
		{ 
			int	rtn	= 0; 
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//			StringBuffer sql = new StringBuffer(); 
//			sql.append(" UPDATE	ICOYRQAN SET STATUS	= 'D'       \n"); 
//			sql.append(" WHERE	HOUSE_CODE  = ?                 \n"); 
//			sql.append(" AND	RFQ_NO      = ?	                \n"); 
//			sql.append(" AND	RFQ_COUNT   = ?                 \n"); 
	 
			try	{ 
				String[] type =	{"S","S","N"}; 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
	 
				rtn	= sm.doUpdate(deletedata,type); 
			} catch(Exception e) { 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		} */

		/*private	int	et_setRfqEPDelete(ConnectionContext ctx,String[][] deletedata) throws Exception 
		{ 
			int	rtn	= 0; 
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//			StringBuffer sql = new StringBuffer(); 
//			sql.append(" UPDATE	ICOYRQEP SET STATUS	= 'D'       \n"); 
//			sql.append(" WHERE	HOUSE_CODE  = ?                 \n"); 
//			sql.append(" AND	RFQ_NO      = ?	                \n"); 
//			sql.append(" AND	RFQ_COUNT   = ?                 \n"); 
	 
			try	{ 
				String[] type =	{"S","S","N"}; 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
	 
				rtn	= sm.doUpdate(deletedata,type); 
			} catch(Exception e) { 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		} */

		private	int	et_setRfqOPChange_delete(ConnectionContext ctx,String[][] deletedata) throws Exception 
		{ 
			int	rtn	= 0; 
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//			StringBuffer sql = new StringBuffer(); 
//			sql.append(" UPDATE	ICOYRQOP SET STATUS	= 'D'       \n"); 
//			sql.append(" WHERE	HOUSE_CODE  = ?                 \n"); 
//			sql.append(" AND	RFQ_NO      = ?	                \n"); 
//			sql.append(" AND	RFQ_COUNT   = ?                 \n"); 
	 
			try	{ 
				String[] type =	{"S","S","N"}; 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
	 
				rtn	= sm.doUpdate(deletedata,type); 
			} catch(Exception e) { 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		} 
	 
	 /* //삭제 후	______청구검토목록으로.	견적요청 현황 
		private	int	et_setRfqDelete_return(ConnectionContext ctx, String rfq_no, String	rfq_count )	throws Exception 
		{ 
			String house_code =	info.getSession("HOUSE_CODE"); 
	 
			int	rtn	= 0; 
			String value = ""; 
			String[][] return_value	= null; 
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	 
//			StringBuffer sql = new StringBuffer(); 
//			sql.append(" SELECT	HOUSE_CODE, PR_NO,PR_SEQ FROM ICOYRQDT          \n"); 
//			sql.append(" <OPT=F,S> WHERE    HOUSE_CODE = ?  </OPT>  \n"); 
//			sql.append(" <OPT=S,S> AND  RFQ_NO         = ?  </OPT>  \n"); 
//			sql.append(" <OPT=S,N> AND  RFQ_COUNT      = ?  </OPT>  \n"); 
	 
			 
//			StringBuffer sql1 =	new	StringBuffer(); 
//			sql1.append(" UPDATE  ICOYPRDT	SET	PR_PROCEEDING_FLAG	= 'P'  \n");
//			sql1.append(" WHERE		HOUSE_CODE = ?      \n");
//			sql1.append(" AND		PR_NO  = ?                         \n");
//			sql1.append(" AND		PR_SEQ	= ?	                       \n");
	 
			try	{ 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
	            String[] data = {house_code, rfq_no, rfq_count};
				value =	sm.doSelect(data); 
				SepoaFormater wf	= new SepoaFormater(value); 
	 
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
				if(wf.getRowCount()>0) { 
					return_value = wf.getValue(); 
					sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery()); 
					String[] type =	{"S","S","S"}; 
	 
					rtn	= sm.doUpdate(return_value,type); 
				} 
			} catch(Exception e) { 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
			} 
	 
			return rtn; 
		} */

	    public SepoaOut re_getRfqDTDisplay(Map<String, String> header) {  
	    	try	{  
				String rtn = "";  
	  
				//Query 수행부분 Call  
	            //create_type 에 상관없이 조회 
				rtn	= et_re_getRfqDTDisplay(header);  
					
				setValue(rtn);  
				setStatus(1);  
	  
			}catch (Exception e){  
				Logger.err.println(info.getSession("ID"),this,"Exception e ==============>"	+ e.getMessage());  
				setMessage(msg.getMessage("STDRFQ.0001"));  
				setStatus(0);  
			}  
			return getSepoaOut();  
	    	
	    }  		
	    
	    private String et_re_getRfqDTDisplay(Map<String, String> header) throws Exception{  
	    	
			
			String rtn = "";  
			ConnectionContext ctx =	getConnectionContext();  
			//String cur_date_time = SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4);
			
			try	{  
				
				SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
				//header.put("cur_date_time", cur_date_time);
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
				
				rtn	= sm.doSelect(header);  
	  
				if(rtn == null)	throw new Exception("SQL Manager is	Null");  
			}catch(Exception e)	{  
				
			  throw	new	Exception("et_getItemList=========>"+e.getMessage());  
			} finally{  
			}  
			return rtn; 
	    	
	    	
	    }

	       /*견적결과조회
		    * getRfqResultList
		    * @param info
		    * @return SepoaOut
		    * @throws Exception
		    */
		    public SepoaOut getRfqResultList(Map<String, String> header) throws Exception {
		    	ConnectionContext ctx                   = getConnectionContext();
				SepoaXmlParser    sxp                   = null;
				SepoaSQLManager   ssm                   = null;
				String            rtn                   = null;
				String            id                    = info.getSession("ID");
				
				
				try{
					
					//header       = MapUtils.getMap(data, "headerData"); // 조회 조건 조회
					sxp = new SepoaXmlParser(this, "getRfqResultList");
//					sxp.addVar("s1", s1);
					//sxp.addVar("s3", s3);
//					sxp.addVar("s4", s4);
					
					sxp.addVar("language", info.getSession("LANGUAGE"));
		        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
		        	rtn = ssm.doSelect(header);
		        	setValue(rtn);

				}catch (Exception e){
					setStatus(0);
					setFlag(false);
					setMessage(e.getMessage());
					Logger.err.println(info.getSession("ID"), this, e.getMessage());
				}

				return getSepoaOut();
		    }
		    
	    
		   
		    
		    public SepoaOut getRfqVedorList(String vendor_code, String vendor_name_loc, String search_key, String sg_refitem, String flag)
			{ 
				try	{

					String rtn = et_getRfqVedorList(vendor_code, vendor_name_loc, search_key, sg_refitem, flag);

					setValue(rtn); 
					setStatus(1); 
					setMessage(msg.getMessage("STDRFQ.0000")); 

				} catch(Exception e) { 
					Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
					setStatus(0); 
					setMessage(msg.getMessage("STDRFQ.0001")); 
				} 
				return getSepoaOut(); 
			} 
			
			private	String et_getRfqVedorList(String vendor_code, String vendor_name_loc, String search_key, String sg_refitem, String flag) throws Exception 
			{ 
				String rtn = null; 
				ConnectionContext ctx =	getConnectionContext(); 
				String SG_REFITEMS = "";
				
				Logger.debug.println(info.getSession("ID"),this,"========================");
				Logger.debug.println(info.getSession("ID"),this,"sg_refitem : "+sg_refitem); 
				Logger.debug.println(info.getSession("ID"),this,"========================");
				

		 		if(sg_refitem == null || sg_refitem.equals("")){
		 			 SG_REFITEMS="''";
		 		} else {
		 			java.util.StringTokenizer st = new java.util.StringTokenizer(sg_refitem,"::");
					int cnt = st.countTokens();
					while(st.hasMoreTokens()){
						SG_REFITEMS =SG_REFITEMS+ ",'"+st.nextToken()+"'";
					}
					SG_REFITEMS=SG_REFITEMS.substring(1);
				}

				Logger.debug.println(info.getSession("ID"),this,"==========================");
				Logger.debug.println(info.getSession("ID"),this,"SG_REFITEMS : "+SG_REFITEMS); 
				Logger.debug.println(info.getSession("ID"),this,"==========================");
				
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("flag", flag);
				wxp.addVar("SG_REFITEMS", SG_REFITEMS);
				


					try{

						SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
						String[] data = {info.getSession("HOUSE_CODE"), vendor_code, vendor_name_loc, search_key};
						rtn	= sm.doSelect(data);

					} catch(Exception e)	{ 
						Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
						throw new Exception(e.getMessage()); 
					}

					return rtn;

				}
			
//			public SepoaOut setRfqCreate(String pflag, 
//					String create_type, 
//					String rfq_flag,
//					String rfq_type,
//					String rfq_no,
//					String[][] chkdata, 
//					String[][] prhddata, 
//					String[][] prdtdata, 
//					String[][] rqhddata, 
//					String[][] rqdtdata, 
//					String[][] rqsedata, 
//					String[][] rqopdata, 
//					String[][] rqepdata, 
//					String[][] rqandata,
//					String[][] prcfmdata
//					) 
//				{ 
//				int rfq_count = 0;
//				if(rqdtdata !=null){
//					rfq_count = Integer.parseInt(rqdtdata[0][3]);
//				}
//				try {  
//					if(rqdtdata	== null || rqdtdata.length == 0	) { 
//						setStatus(0); 
//						setMessage(msg.getMessage("STDRFQ.0005")); 
//						return getSepoaOut(); 
//					} 
//					
//					Logger.debug.println(info.getSession("ID"), this, "##### pflag       ===> " + pflag); 
//					Logger.debug.println(info.getSession("ID"), this, "##### create_type ===> " + create_type);
//					Logger.debug.println(info.getSession("ID"), this, "##### rfq_flag    ===> " + rfq_flag);
//					
//					ConnectionContext ctx =	getConnectionContext(); 
//					
//					/*************************************************************************** 
//						1. 견적요청가능여부	체크 
//					****************************************************************************/ 
//					String[] rtn = et_getRfqCount(ctx, chkdata); 
//					if (!rtn[0].equals("0")) { //아이템이 견적중임..... 
//						setStatus(0); 
//						msg.setArg("ITEM_NO",rtn[1]); 
//						setMessage(msg.getMessage("STDRFQ.0043")); 
//						return getSepoaOut(); 
//					}  
//					
//					/*************************************************************************** 
//						2. 메뉴얼 견적요청시 구매요청 데이타를 강제로 생성 
//					****************************************************************************/ 
//					if ( create_type.equals("MA") ) {
//						int prhd	= et_setPrHDCreate(ctx, prhddata); 
//						int	prdt	= et_setPrDTCreate(ctx,	prdtdata); 
//					} 
//					
//					/*************************************************************************** 
//						3. RFQ Header (ICOYRQHD) 생성 
//					****************************************************************************/ 
//					int rqhd = et_setRfqHDCreate(ctx, rqhddata); 
//					
//					/*************************************************************************** 
//						4. RFQ Detail (ICOYRQDT) 생성 
//					****************************************************************************/ 
//					int	rqdt = et_setRfqDTCreate(ctx, rqdtdata); 
//					
//					/*************************************************************************** 
//						5. RFQ Operating (ICOYRQOP)	생성, ICOYRQSE 생성 
//					****************************************************************************/
//					//여기는 지명입찰입니다. OP는	공개입찰
//					if(!rfq_type.equals("OP")) {
//						int rqop = et_setRfqOPCreate(ctx,rqopdata); 
//						int rqse = et_setRfqSECreate(ctx,rqsedata);
//					} 
//					
//					/*********************************************************************************************** 
//						6. 원가정보(ICOYRQEP) 생성 
//					************************************************************************************************/ 
//					if(rqepdata.length > 0) {
//						int rqep = et_setRfqEPCreate(ctx,rqepdata);
//					}
//					
//					if(rqandata.length > 0) {
//						int rqan = et_setRfqANCreate(ctx,rqandata);
//					}
//					
//					Logger.debug.println(info.getSession("ID"),this,"7. RFQ 생성시	청구(ICOYPRDT) 확정(UPDATE : PROCEEDING_FLAG = 'C')	---------------------======"); 
//					/*************************************************************************** 
//						7. RFQ 생성시 청구(ICOYPRDT) 확정(UPDATE : PROCEEDING_FLAG = 'C') 
//					****************************************************************************/ 
//					//if (create_type.equals("PR")) { 
//					int prcfm = et_setPRComfirm(ctx, prcfmdata); 
//					//}
//					
//					/*************************************************************************** 
//					 * 8. RFQ 생성후 결재요청
//					 ****************************************************************************/ 
//			    	String add_user_id     =  info.getSession("ID");
//			        String house_code      =  info.getSession("HOUSE_CODE");
//			        String company         =  info.getSession("COMPANY_CODE");
//			        String add_user_dept   =  info.getSession("DEPARTMENT");
//			        if(rfq_flag.equals("B"))
//					{
//		                wisecommon.SignRequestInfo sri = new wisecommon.SignRequestInfo();
//		                sri.setHouseCode(house_code);
//		                sri.setCompanyCode(company);
//		                sri.setDept(add_user_dept);
//		                sri.setReqUserId(add_user_id);
//		                sri.setDocType("RQ");
//		                sri.setDocNo(rfq_no);
//		                sri.setDocSeq("1");
//		                sri.setDocName(rqhddata[0][22]);
//		                sri.setItemCount(rqdtdata.length);
//		                sri.setSignStatus("P");
//		                sri.setCur("KRW");
//		                sri.setTotalAmt(Double.parseDouble("0"));
//		                
//		                sri.setSignString(pflag); // AddParameter 에서 넘어온 정보
//		                int signRtn = CreateApproval(info,sri);    //밑에 함수 실행
//		                if(signRtn == 0) {
//		                    try {
//		                        Rollback();
//		                    } catch(Exception d) {
//		                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
//		                    }
//		                    setStatus(0);
//		                    setMessage(msg.getMessage("STDRFQ.0030"));
//		                    return getSepoaOut();
//		                }
//					} 
//					
//					setStatus(1); 
//					setValue(String.valueOf(rqdt)); 
//					msg.setArg("RFQ_NO", rfq_no); 
//					
//					if(rfq_flag.equals("B")) {
//						setMessage(msg.getMessage("STDRFQ.0044")); 
//					} else if(rfq_flag.equals("P")) {
//						setMessage("견적요청번호 " + rfq_no + " 로 업체전송 되었습니다.");
//					} else {
//						setMessage(msg.getMessage("STDRFQ.0045")); 
//					}
//					Commit(); 
//				}
//				catch(Exception e) { 
//					try	{ 
//						Rollback(); 
//					} catch(Exception d) {  
//					} 
//					setStatus(0); 
//				}
//				return getSepoaOut();  
//			}
			
	@SuppressWarnings("unchecked")
	public SepoaOut setRfqCreate(Map<String, Object> param) throws Exception{ 
		ConnectionContext         ctx          = null;
		String[]                  rtn          = null;
		String                    create_type  = (String)param.get("create_type");
		String                    rfq_type     = (String)param.get("rfq_type");
		String                    rfq_flag     = (String)param.get("rfq_flag");
		String                    rfq_no       = (String)param.get("rfq_no");
		String                    pflag        = (String)param.get("pflag");
		String                    poName       = null;
		List<Map<String, String>> rqdtdata     = (List<Map<String, String>>)param.get("rqdtdata");
		List<Map<String, String>> chkdata      = (List<Map<String, String>>)param.get("chkdata");
		List<Map<String, String>> prhddata     = (List<Map<String, String>>)param.get("prhddata");
		List<Map<String, String>> prdtdata     = (List<Map<String, String>>)param.get("prdtdata");
		List<Map<String, String>> rqhddata     = (List<Map<String, String>>)param.get("rqhddata");
		List<Map<String, String>> rqopdata     = (List<Map<String, String>>)param.get("rqopdata");
		List<Map<String, String>> rqepdata     = (List<Map<String, String>>)param.get("rqepdata");
		List<Map<String, String>> rqandata     = (List<Map<String, String>>)param.get("rqandata");
		List<Map<String, String>> prcfmdata    = (List<Map<String, String>>)param.get("prcfmdata");
		List<Map<String, String>> rqsedata     = (List<Map<String, String>>)param.get("rqsedata");
		int	                      rqdt         = 0;
		String	 				  getPrCnt	   = "";
		
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			
			//PR - Dup Validation
			
//			this.setRfqCreateRfqCount(rqdtdata);
			this.setRfqCreateIsRqdtdata(rqdtdata); 
			
			String addVal = "";
			
			if(rqdtdata.size() > 0){
				for(int i = 0 ; i < rqdtdata.size() ; i++){
					addVal += ",'" + rqdtdata.get(i).get("PR_NO") + rqdtdata.get(i).get("PR_SEQ") + "'";
				}
			}
			
			getPrCnt = this.et_getPrCount(ctx, addVal.substring(1));
			
			SepoaFormater sf = new SepoaFormater(getPrCnt);
			
			if(Integer.parseInt(sf.getValue("CNT",0)) > 0 ){
				throw new Exception("해당 구매요청건으로 이미 견적이 생성되었습니다.\n확인후 견적요청 하여 주십시오.");
			}
			
			rtn = this.et_getRfqCount(ctx, chkdata);
			
			if("0".equals(rtn[0]) == false){
				throw new Exception(msg.getMessage("STDRFQ.0043"));
			}
			
			if("MA".equals(create_type)){					//견적요청형태
				this.et_setPrHDCreate(ctx, prhddata);
				this.et_setPrDTCreate(ctx, prdtdata); 
			}
			
			this.et_setRfqHDCreate(ctx, rqhddata);
			rqdt = this.et_setRfqDTCreate(ctx, rqdtdata); 
			
			if("OP".equals(rfq_type)  == false) {			//공개견적
				this.et_setRfqOPCreate(ctx, rqopdata); 
				this.et_setRfqSECreate(ctx, rqsedata);
			} 
			
			if(rqepdata != null) {
				this.et_setRfqEPCreate(ctx, rqepdata);
			}
			
			if(rqandata != null) {
				this.et_setRfqANCreate(ctx, rqandata);
			}
			
			this.et_setPRComfirm(ctx, prcfmdata); 
			this.setRfqCreateSignRequestInfo(rfq_flag, rfq_no, pflag, rqhddata, rqdtdata);
			
			setStatus(1); 
			setValue(String.valueOf(rqdt));
			
			msg.setArg("RFQ_NO", rfq_no); 
			
			if(rfq_flag.equals("B")) {
				setMessage(msg.getMessage("STDRFQ.0044")); 
			}
			else if(rfq_flag.equals("C")) {
				setMessage("견적요청번호 " + rfq_no + " 로 업체전송 되었습니다.");
				
				Map<String, String> smsParam = new HashMap<String, String>();
				
			    smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
			    smsParam.put("RFQ_NO",      rfq_no);
			    smsParam.put("RFQ_COUNT",   "1");
				
				new SMS("NONDBJOB", info).rq2Process(ctx, smsParam);
				new mail("NONDBJOB", info).rq2Process(ctx, smsParam);
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
                
//                try{
//                	String[] pFlagArray           = pflag.split("$");
//            		String[] pFlagArrayFirstArray = pFlagArray[0].split("#");
//            		String   fistUserId           = pFlagArrayFirstArray[1].trim();
//            		
//            		UcMessage.DirectSendMessage(info.getSession("ID"), fistUserId, "전자구매시스템에 견적서 요청 결재 바랍니다.");
//                }
//                catch(Exception e){}
    		} 			
		} catch (Exception e) {
//			e.printStackTrace();
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
		}
	}
	
	private void setRfqCreateIsRqdtdata(List<Map<String, String>> rqdtdata) throws Exception{
		if(rqdtdata == null){
			throw new Exception(msg.getMessage("STDRFQ.0005"));
		}
		
		if(rqdtdata.size() == 0){
			throw new Exception(msg.getMessage("STDRFQ.0005"));
		}
	}
	
	private int setRfqCreateRfqCount(List<Map<String, String>> rqdtdata) throws Exception{
		Map<String, String> rqdtdataInfo = null;
		String              rfqCount     = null;
		int                 result       = 0;
		
		if(rqdtdata != null){
			rqdtdataInfo = rqdtdata.get(0);
			rfqCount     = rqdtdataInfo.get("RFQ_COUNT");
			
			try{
				result = Integer.parseInt(rfqCount);
			}
			catch(Exception e){
				result = 0;
			}
			
		}
		
		return result;
	}
			 
			
//	private	String[] et_getRfqCount(ConnectionContext ctx,String[][] chkdata) throws Exception { 
//		String[] val = new String[2]; 
//				
//		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		
//		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
//		
//		try{ 
//			int	j =	0; 
//			val[1] = ""; 
//		 
//			for( int i = 0;	i <	chkdata.length; i++ ) { 
//				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
//						
//				if (chkdata[i][0]==null || chkdata[i][0].equals("")){
//						chkdata[i][0] = "Z%Z%Z%Z%Z%Z%Z%Z%Z%";
//				}
//				
//				String sel_rtn = sm.doSelect(chkdata[i]); 
//				SepoaFormater wf	= new SepoaFormater(sel_rtn); 
//		 
//				int	k= Integer.parseInt( wf.getValue("RFQ_CNT", 0) );
//				
//				if(	k != 0 ){ 
//					j++;
//					
//					val[1] += (	chkdata[i][0]+" "); 
//				} 
//			}
//			
//			val[0] = String.valueOf(j); 
//		}
//		catch(Exception e)	{ 
//			Logger.debug.println(info.getSession("ID"),this,e.getMessage());
//			
//			throw new Exception(e.getMessage()); 
//		}
//		
//		return val; 
//	} 
	//품목별 구매요청 건수 조회
	private	String[] et_getRfqCount(ConnectionContext ctx, List<Map<String, String>> chkdata) throws Exception { 
		String[]            val         = new String[2];
		String              dtItemNo    = null;
		String              selRtn      = null;
		String              rfqCnt      = null;
		SepoaFormater       wf          = null;
		Map<String, String> chkdataInfo = null;
		Map<String, String> daoParam    = new HashMap<String, String>();
		int i                           = 0;
		int	j                           = 0; 
		int	k                           = 0;
		
		try{
			val[1] = ""; 
		 
			for(i = 0;	i <	chkdata.size(); i++ ) {
				SepoaXmlParser wxp = new SepoaXmlParser(this, "et_getRfqCount");
				
				wxp.addVar("HOUSE_CODE", info.getSession("HOUSE_CODE"));
				
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
				
				chkdataInfo = chkdata.get(i);
				dtItemNo    = chkdataInfo.get("DT_ITEM_NO");
				dtItemNo    = this.nvl(dtItemNo, "Z%Z%Z%Z%Z%Z%Z%Z%Z%");

				daoParam.clear();
				daoParam.put("RFQ_NO", dtItemNo);
				
				selRtn = sm.doSelect(daoParam);
				
				wf	= new SepoaFormater(selRtn); 
				
				rfqCnt = wf.getValue("RFQ_CNT", 0);
		 		k      = Integer.parseInt(rfqCnt);
				
				if(k != 0){ 
					j++;
					
					val[1] += dtItemNo + " "; 
				} 
			}
			
			val[0] = String.valueOf(j); 
		}
		catch(Exception e)	{ 
			Logger.debug.println(info.getSession("ID"),this,e.getMessage());
			
			throw new Exception(e.getMessage()); 
		}
		
		return val; 
	}
	
	private	String et_getPrCount(ConnectionContext ctx, String addVal) throws Exception { 
		String              selRtn      = null;
		
		try{
			SepoaXmlParser wxp = new SepoaXmlParser(this, "et_getPrCount");
			wxp.addVar("addVal", addVal);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			selRtn = sm.doSelect();
		}
		catch(Exception e)	{ 
			Logger.debug.println(info.getSession("ID"),this,e.getMessage());
			
			throw new Exception(e.getMessage()); 
		}
		
		return selRtn; 
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
	
			
//			private	int	et_setPRComfirm(ConnectionContext ctx, String[][] prcfmdata) throws	Exception 
//			{ 
//		 
//				int	rtn	= 0; 
//				 
//				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//				
////				sql.append(" UPDATE	ICOYPRDT SET				    		\n"); 
////				sql.append("		 CONFIRM_QTY		= ?	        		\n"); 
////				sql.append("		,PR_PROCEEDING_FLAG	= 'C'				\n"); 
////				sql.append(" WHERE	HOUSE_CODE 	= ?  						\n"); 
////				sql.append(" AND	PR_NO 		= ?					   		\n"); 
////				sql.append(" AND	PR_SEQ 		= dbo.lpad(?, 6, '0') 	\n"); 
//		 
//				try	{ 
//					String[] type =	{"S","S","S","S"}; 
//					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
//		 
//					rtn	= sm.doUpdate(prcfmdata,type); 
//				} catch(Exception e) { 
//					Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
//					throw new Exception(e.getMessage()); 
//				} 
//				return rtn; 
//			}
			
	private	int	et_setPRComfirm(ConnectionContext ctx, List<Map<String, String>> prcfmdata) throws	Exception {
		Map<String, String> prcfmdataInfo = null;
		int	rtn	          = 0; 
		int i             = 0;
		int prcfmdataSize = prcfmdata.size();
				  
		try	{ 
			for(i = 0; i < prcfmdataSize; i++){
				SepoaXmlParser  wxp = new SepoaXmlParser(this, "et_setPRComfirm");
				SepoaSQLManager sm  = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp);
				
				prcfmdataInfo = prcfmdata.get(i);
			 
				rtn	= rtn + sm.doUpdate(prcfmdataInfo);	
			}
		}
		catch(Exception e) { 
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			
			throw new Exception(e.getMessage()); 
		}
		
		return rtn; 
	} 
			
			private	int	temp_Approval(ConnectionContext	ctx, String	rfq_no,	String rfq_count, String flag) throws Exception 
			{ 
				int	rtn	= 0; 
		 
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				
//				sql.append(" UPDATE	ICOYRQHD						\n");
//				sql.append("   SET  SIGN_STATUS		= ?				\n");			
//				sql.append("	   ,SIGN_PERSON_ID	= ?			    \n");
//				sql.append("	   ,SIGN_DATE		= ?				\n");	
//		 		sql.append(" WHERE HOUSE_CODE		= ?	            \n");
//				sql.append("   AND RFQ_NO			= ?				\n");			
//				sql.append("   AND RFQ_COUNT		= ?				\n");		
//				sql.append("   AND STATUS			IN ('C', 'R')	\n");						
		 
				try	{ 
					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
					String[] type = {"S", "S", "S", "S", "S","N"};
					String[][] signUpdata = {{flag, info.getSession("ID"), SepoaDate.getShortDateString(), info.getSession("HOUSE_CODE"), rfq_no, rfq_count}};
					rtn	= sm.doUpdate(signUpdata, type); 
				} catch(Exception e) { 
					Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
					throw new Exception(e.getMessage()); 
				} 
				return rtn; 
			} 
			
			public SepoaOut getRfqAnnounce(String rfq_no,String rfq_count) 
			{ 
				try{ 
					String rtn = et_getRfqAnnounce(rfq_no,rfq_count); 
					setValue(rtn); 
					setStatus(1); 
					setMessage(msg.getMessage("STDRFQ.0000")); 
				}catch(Exception e)	{ 
					Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
					setStatus(0); 
					setMessage(msg.getMessage("STDRFQ.0001")); 
				} 
				return getSepoaOut(); 
			} 
			
			private	String et_getRfqAnnounce( String rfq_no, String rfq_count) throws Exception 
			{ 
				String rtn = null; 
				ConnectionContext ctx =	getConnectionContext(); 
				
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

				try{ 
					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
					String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count};
					rtn	= sm.doSelect(data); 
				}catch(Exception e)	{ 
					Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
					throw new Exception(e.getMessage()); 
				} 
				return rtn; 
			} 
			
			public SepoaOut getVendorCode(String rfq_no, String rfq_count) 
			{ 
				String rtn = null;
				String id  = info.getSession("ID");
				
				try{ 
					rtn = et_getVendorCode(rfq_no, rfq_count); 
					setValue(rtn); 
					setStatus(1); 
					setMessage(msg.getMessage("STDRFQ.0000")); 
				}catch(Exception e)	{ 
					Logger.err.println(id,this,e.getMessage()); 
					setStatus(0); 
					setMessage(msg.getMessage("STDRFQ.0001")); 
				} 
				return getSepoaOut(); 
			} 
			private	String et_getVendorCode( String rfq_no, String rfq_count) throws Exception 
			{ 
		 
				String rtn = null; 
				String house_code = info.getSession("HOUSE_CODE");
				ConnectionContext ctx =	getConnectionContext(); 
				
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				
				try{ 
					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
					String[] data = {house_code, rfq_no, rfq_count};
					rtn	= sm.doSelect(data); 
				}catch(Exception e)	{ 
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
					try{Rollback();}catch(Exception	e1){ Logger.err.println("Exception e1	=" + e1.getMessage());  } 
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
				/*int	rtn	= -1; 
				ConnectionContext ctx =	getConnectionContext(); 
				
				try	{ 
					
					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
					//String[] type =	{"S", "S", "S", "S", "N"}; 
					rtn	= sm.doUpdate(recvData); 
		 
				}catch(Exception e)	{ 
					Logger.err.println(userid,this,e.getMessage()); 
					throw new Exception(e.getMessage()); 
				} 
				return rtn; */
			} 

			/**
			 * 견적기간 연장
			 * @method setRFQExtends
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   ICOYRQDT
			 * @since  2014-10-07
			 * @modify 2014-10-07
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
				/*int	rtn	= 0; 
				try	{ 
		 
					rtn	= et_setRFQExtends(setData);
					setMessage(msg.getMessage("STDRFQ.0071"));	//  견적기간이 연장되었습니다. 
					setValue(Integer.toString(rtn)); 
					setStatus(1); 
					
					if(rtn == 0){
						setMessage(msg.getMessage("STDRFQ.0073"));	//  견적이 이미 마감되어 견적기간을 연장할 수 없습니다.
					}
							 
					Commit(); 
		  
				}catch(Exception e){ 
					try{Rollback();}catch(Exception	e1){} 
					Logger.err.println("Exception e	=" + e.getMessage()); 
		 
					setMessage(msg.getMessage("STDRFQ.0072"));	// 견적기간연장에 실패했습니다. 
					setStatus(0); 
					Logger.err.println(this,e.getMessage()); 
				} 
				return getSepoaOut(); */
			} 
		 
		 
			/*private	int	et_setRFQExtends(String[][] setData) throws Exception 
			{ 
				int	rtn	= -1; 
				ConnectionContext ctx =	getConnectionContext(); 
		 
				try	{ 
					
					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
					String[] type =	{"S", "S", "S", "S", "N"}; 
					rtn	= sm.doUpdate(setData,type); 
		 
				}catch(Exception e)	{ 
					Logger.err.println(userid,this,e.getMessage()); 
					throw new Exception(e.getMessage()); 
				} 
				return rtn; 
			} */

			public SepoaOut getVendorDisplay(String rfq_no,String rfq_count,String rfq_seq) 
			{ 
				try{ 
					String rtn = et_getVendorDisplay(rfq_no,rfq_count,rfq_seq); 
					setValue(rtn); 
					setStatus(1); 
					setMessage(msg.getMessage("STDRFQ.0000")); 
				}catch(Exception e)	{ 
					Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
					setStatus(0); 
					setMessage(msg.getMessage("STDRFQ.0001")); 
				} 
				return getSepoaOut(); 
			} 

			private	String et_getVendorDisplay(	String rfq_no,String rfq_count,String rfq_seq) throws Exception 
			{ 
				String rtn = null; 
				ConnectionContext ctx =	getConnectionContext(); 
				//StringBuffer sql = new StringBuffer(); 

				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

				try{ 
					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
					String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count, rfq_seq};
					rtn	= sm.doSelect(data); 
				}catch(Exception e)	{ 
					Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
					throw new Exception(e.getMessage()); 
				} 
				return rtn; 
			}
			
			/**
			 * 견적요청상세 견적업체 조회팅
			 * @method getVendorDisplay2
			 * @param  param
			 * @return SepoaOut
			 * @throws Exception
			 * @since  2014-10-06
			 * @modify 2014-10-06
			 */
			public SepoaOut getVendorDisplay2(Map<String, String> param) throws Exception{ 
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
					
					sxp = new SepoaXmlParser(this, "et_getVendorDisplay2");
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
				
//				StringBuffer sql = new StringBuffer(); 
//				sql.append(" UPDATE	ICOYRQHD										\n"); 
//				sql.append("   SET SIGN_STATUS		= '"+flag+"',					\n"); 
//				sql.append("	   SIGN_PERSON_ID	= '"+sign_user_id+"',			\n"); 
//				sql.append("	   SIGN_DATE		= '"+sign_date+"'				\n"); 
//				sql.append(" WHERE HOUSE_CODE		= '"+info.getSession("HOUSE_CODE")+"'	\n"); 
//				sql.append("   AND COMPANY_CODE		= '"+info.getSession("COMPANY_CODE")+"'	\n"); 
//				sql.append("   AND RFQ_NO			= '"+exec_no+"'					\n"); 
//				sql.append("   AND RFQ_COUNT		= '"+exec_seq+"'				\n"); 
//				sql.append("   AND STATUS			!= 'D'							\n"); 
		 
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
			
			public int setMail(	String RFQ_NO, String RFQ_COUNT	 ) 
			{ 
				String HOUSE_CODE =	info.getSession("HOUSE_CODE"); 
				int	rtn	= 0; 
				try{ 
					ConnectionContext ctx =	getConnectionContext(); 
					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					
					wxp.addVar("HOUSE_CODE", HOUSE_CODE);
					wxp.addVar("RFQ_NO", RFQ_NO);
					wxp.addVar("RFQ_COUNT", RFQ_COUNT);
						
//					StringBuffer sql = new StringBuffer(); 
//		 
//		            sql.append( " SELECT MIN(LUSR.EMAIL)                  AS EMAIL,                \n" ); 
//		            sql.append( "        MIN(RQSE.CHANGE_USER_NAME_LOC)   AS CHANGE_USER_NAME_LOC, \n" ); 
//		            sql.append( "        MIN(VNGL.EMAIL)                  AS EMAIL1,               \n" );  
//		            sql.append( "        MIN(VNGL.NAME_LOC)               AS NAME_LOC,             \n" ); 
//		            sql.append( "        MIN(LUSR.PHONE_NO)               AS PHONE_NO              \n" ); 
//		            sql.append( "  FROM ICOYRQSE RQSE                                              \n" ); 
//		            sql.append( "        LEFT OUTER JOIN ICOMLUSR LUSR                             \n" ); 
//		            sql.append( "            ON RQSE.HOUSE_CODE = LUSR.HOUSE_CODE                  \n" ); 
//		            sql.append( "            AND RQSE.CHANGE_USER_ID = LUSR.USER_ID                \n" ); 
//		            sql.append( "        LEFT OUTER JOIN ICOMVNGL VNGL                             \n" ); 
//		            sql.append( "            ON RQSE.HOUSE_CODE = VNGL.HOUSE_CODE                  \n" ); 
//		            sql.append( "            AND RQSE.VENDOR_CODE = VNGL.VENDOR_CODE               \n" ); 
//		            sql.append( "  WHERE RQSE.HOUSE_CODE = '"+HOUSE_CODE+"'                        \n" ); 
//		            sql.append( "    AND RQSE.RFQ_NO = '"+RFQ_NO+"'	                               \n" ); 
//		            sql.append( "    AND RQSE.RFQ_COUNT = "+RFQ_COUNT+"                            \n" ); 
//		            sql.append( "    AND RQSE.STATUS <> 'D'                                        \n" ); 
//		            sql.append( "  GROUP BY RQSE.VENDOR_CODE                                       \n" ); 
		 
					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
					String rtnSel =	sm.doSelect(); 
		 
					SepoaFormater wf	= new SepoaFormater(rtnSel); 
		 
					for( int i=0; i<wf.getRowCount(); i++ ) 
					{ 
						String SenderMail	= wf.getValue(i,0); 
						String SenderName	= wf.getValue(i,1); 
						String ReceiverMail	= wf.getValue(i,2); 
						String ReceiverName	= wf.getValue(i,3); 
						String PhoneNo		= wf.getValue(i,4); 
		 
						Logger.debug.println(info.getSession("ID"),this,"SenderMail====================="+SenderMail); 
						Logger.debug.println(info.getSession("ID"),this,"SenderName====================="+SenderName); 
						Logger.debug.println(info.getSession("ID"),this,"ReceiverMail====================="+ReceiverMail); 
						Logger.debug.println(info.getSession("ID"),this,"ReceiverName====================="+ReceiverName); 
						Logger.debug.println(info.getSession("ID"),this,"PhoneNo====================="+PhoneNo); 
		 
						String [] args =  {RFQ_NO, "RFQ", "견적요청", SenderMail,SenderName,ReceiverMail,ReceiverName, PhoneNo,	"","" }; 
		 
						if(	ReceiverMail.equals("")	){ 
							Logger.debug.println(info.getSession("ID"),this,"ReceiverMail이	없어서 리턴합니다.===================="); 
							return rtn; 
						} 
						Logger.debug.println(info.getSession("ID"),this,"ReceiverMail이	있어서 계속	진행합니다..===================="); 
						String serviceId = "SendMail"; 
						Object[] obj = { args }; 
						String conType = "NONDBJOB";					//conType :	CONNECTION/TRANSACTION/NONDBJOB 
						String MethodName =	"mailDomestic";				//NickName으로 연결된 Class에 정의된 Method	Name 
		 
						SepoaOut value = null; 
						SepoaRemote wr	= null; 
		 
						//다음은 실행할	class을	loading하고	Method호출수 결과를	return하는 부분이다. 
						try 
						{ 
		 
							wr = new SepoaRemote( serviceId, conType, info	); 
							wr.setConnection(ctx); 
		 
							value =	wr.lookup( MethodName, obj ); 
							//Logger.debug.println(info.getSession("ID"),this,"value.status====================="+value.status); 
		 
							rtn	= value.status; 
		 
						}catch(	SepoaServiceException wse ) { 
//							try{
								Logger.err.println("wse	= "	+ wse.getMessage()); 
//								Logger.err.println("message	= "	+ value.message); 
//								Logger.err.println("status = " + value.status); 								
//							}catch(NullPointerException ne){
//				        		
//				        	}
						}catch(Exception e)	{ 
//							try{
								Logger.err.println("err	= "	+ e.getMessage()); 
//								Logger.err.println("message	= "	+ value.message); 
//								Logger.err.println("status = " + value.status); 								
//							}catch(NullPointerException ne){
//				    			
//				    		}
						} 
//						finally{ 
//		 
//						} 
					}		// End of Mail service 

				}catch(Exception ee	) 
				{ 
					Logger.err.println("err	= "	+ ee.getMessage()); 
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
					
//				StringBuffer sql = new StringBuffer(); 
//				sql.append(" UPDATE	ICOYRQHD										\n"); 
//				sql.append("   SET SIGN_STATUS		= '"+flag+"',					\n"); 
//				sql.append("	   SIGN_PERSON_ID	= '"+sign_user_id+"'			\n"); 
//				sql.append(" WHERE HOUSE_CODE		= '"+info.getSession("HOUSE_CODE")+"'	\n"); 
//				sql.append("   AND COMPANY_CODE		= '"+info.getSession("COMPANY_CODE")+"'	\n"); 
//				sql.append("   AND RFQ_NO			= '"+exec_no+"'					\n"); 
//				sql.append("   AND RFQ_COUNT		= '"+exec_seq+"'				\n"); 
//				sql.append("   AND STATUS			!= 'D'							\n"); 
		 
				try	{ 
					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
		 
					rtn	= sm.doUpdate(); 
				} catch(Exception e) { 
					Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
					throw new Exception(e.getMessage()); 
				} 
				return rtn; 
			}
			
			
			public SepoaOut getInterViewHum(  String house_code, String rfq_no, String rfq_count		)
			{
				try {

					String rtnHD  = et_getInterViewHum( house_code, rfq_no, rfq_count);  
							                  
					SepoaFormater wf = new SepoaFormater(rtnHD);
					if(wf.getRowCount() == 0) setMessage(msg.getMessage("STDRFQ.0000"));
					else {
						setMessage(msg.getMessage("STDRFQ.7000"));
					}

					setStatus(1);
					setValue(rtnHD);
				}catch(Exception e) {
					Logger.err.println(userid,this,e.getMessage());
					setStatus(0);
				}
				return getSepoaOut();
			}

			private String et_getInterViewHum(   String house_code, String rfq_no, String rfq_count ) throws Exception

			{

				String rtn = "";
				ConnectionContext ctx = getConnectionContext();
				try {
					String company_code = info.getSession("COMPANY_CODE");
					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					wxp.addVar("house_code", house_code);
					wxp.addVar("rfq_no", rfq_no);
					wxp.addVar("rfq_count", rfq_count);
					wxp.addVar("company_code", company_code);

					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
    
					rtn = sm.doSelect();

					}catch(Exception e) {
						throw new Exception("et_getInterViewHum:"+e.getMessage());
					} finally {
		
					}
					return rtn;
				}
			
			
			/*
			 * 인터뷰인력에서 오프라인으로 대상자들을 상대로 인터뷰 후 결과를 등록
			 */
			
			
			public SepoaOut insertInterViewResult(  String [][] data, String rfq_no, String rfq_count, String eval_flag )
			{
				try {
					String house_code = info.getSession("HOUSE_CODE");
					int rtn  = et_insertInterViewResult( house_code, data, rfq_no, rfq_count, eval_flag);  
					
					if (rtn < 0) { //오류 발생
		                //setMessage(msg.getMessage("STDRFQ.0036"));
		                setStatus(0);
		                Rollback();
		            } else {
		            	setMessage("인력을 선정하였습니다.");
		            	//setMessage(msg.getMessage("STDRFQ.0037"));
		                setStatus(1);
		                setValue(String.valueOf(rtn));
		                
		            }
					Commit();
				}catch(Exception e) {
					Logger.err.println(userid,this,e.getMessage());
					setStatus(0);
				}
				return getSepoaOut();
			}

			private int et_insertInterViewResult( String house_code, String [][] data, String rfq_no, String rfq_count, String eval_flag) throws Exception

			{

				int rtn = -1;
				
				ConnectionContext ctx = getConnectionContext();
				try {
					
					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					wxp.addVar("house_code", house_code);

					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
    
					String [] type = {"S", "S", "S", "S", "S"};
					rtn = sm.doUpdate(data, type);

					SepoaXmlParser wxp_1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
					wxp_1.addVar("house_code", house_code);
					wxp_1.addVar("rfq_no", rfq_no);
					wxp_1.addVar("rfq_count", rfq_count);
					wxp_1.addVar("eval_flag", eval_flag);
				
					sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp_1.getQuery()); 
					rtn	= sm.doUpdate(); 
					
					}catch(Exception e) {
						throw new Exception("et_insertInterViewResult:"+e.getMessage());
					} finally {
		
					}
					return rtn;
				}
			
			
			/*
			 * 인터뷰대상자에게 메일을 보내고 INTERVIEW_FLAG Y OR N 으로 업데이트
			 */
			
			
			public SepoaOut insertInterView(  String [][] data , String interDate, String interTime)
			{
				try {
					String house_code = info.getSession("HOUSE_CODE");
					int rtn  = et_insertInterView( house_code, data, interDate, interTime);  
					
					if (rtn < 0) { //오류 발생
		                //setMessage(msg.getMessage("STDRFQ.0036"));
		                setStatus(0);
		                Rollback();
		            } else {
		            	setMessage("메일을 보냈습니다.");
		            	//setMessage(msg.getMessage("STDRFQ.0037"));
		                setStatus(1);
		                setValue(String.valueOf(rtn));
		                
		            }
					Commit();
				}catch(Exception e) {
					Logger.err.println(userid,this,e.getMessage());
					setStatus(0);
				}
				return getSepoaOut();
			}

			private int et_insertInterView( String house_code, String [][] data, String interDate, String interTime) throws Exception

			{

				int rtn = -1;
				
				ConnectionContext ctx = getConnectionContext();
				try {
					
					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					wxp.addVar("house_code", house_code);
					wxp.addVar("interDate", interDate);
					wxp.addVar("interTime", interTime);

					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
    
					String [] type = {"S", "S", "S", "S"};
					rtn = sm.doUpdate(data, type);

					}catch(Exception e) {
						throw new Exception("et_insertInterView:"+e.getMessage());
					} finally {
		
					}
					return rtn;
				}
			
			

			
			public SepoaOut getRfqInterList(String start_date, 
					  String end_date, 
					  String rfq_no, 
					  String subject,
					  String pm_id
					  ) 
			{ 
					try{  
					String rtn = et_getRfqInterList(start_date,end_date,rfq_no,subject,pm_id); 
					setValue(rtn); 
					setStatus(1); 
					setMessage(msg.getMessage("STDRFQ.0000")); 
					}catch(Exception e)	{ 
					Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
					setStatus(0); 
					setMessage(msg.getMessage("STDRFQ.0001")); 
					} 
					return getSepoaOut(); 
			} 
					
					// PM의 견적 인력 인터뷰상황
			private String et_getRfqInterList(String start_date, String end_date,
					String rfq_no, String subject, String pm_id
					) throws Exception 
			{
					
					String rtn = null;
					
					ConnectionContext ctx = getConnectionContext();
					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					wxp.addVar("pm_id", pm_id);
					
					try {
					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
					String[] data = { info.getSession("HOUSE_CODE"), start_date, end_date, rfq_no, subject};
					rtn = sm.doSelect(data);
					} catch (Exception e) {
					Logger.err.println(info.getSession("ID"), this, e.getMessage());
					throw new Exception(e.getMessage());
					}
					return rtn;
			}
			
			public SepoaOut getRfqPriceHeader(String rfq_no, String rfq_count) throws Exception{ 
				ConnectionContext ctx       = null;
				SepoaXmlParser    sxp       = null;
				SepoaSQLManager   ssm       = null;
				String            rtn       = null;
				String            id        = info.getSession("ID");
				String            houseCode = info.getSession("HOUSE_CODE");
				String            message   = null;
				
				Map<String, String> param = new HashMap<String, String>();
				
				try{
					setStatus(1);
					setFlag(true);
					
					ctx = getConnectionContext();
					
					sxp = new SepoaXmlParser(this, "et_getRfqPriceHeader");
					ssm = new SepoaSQLManager(id, this, ctx, sxp);
					
					param.put("rfq_no"		, rfq_no);
					param.put("rfq_count"	, rfq_count);
					
					rtn = ssm.doSelect(param); // 조회
					
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
					Logger.err.println(userid, this, e.getMessage());
					setStatus(0);
					setMessage(msg.getMessage("0001"));
				}
				return getSepoaOut(); 
			} 			
			
			public SepoaOut getRfqPriceList(String rfq_no, String rfq_count) throws Exception{ 
				ConnectionContext ctx       = null;
				SepoaXmlParser    sxp       = null;
				SepoaSQLManager   ssm       = null;
				String            rtn       = null;
				String            id        = info.getSession("ID");
				String            houseCode = info.getSession("HOUSE_CODE");
				String            message   = null;
				
				Map<String, String> param = new HashMap<String, String>();
				
				try{
					setStatus(1);
					setFlag(true);
					
					ctx = getConnectionContext();
					
					sxp = new SepoaXmlParser(this, "et_getRfqPriceList");
					ssm = new SepoaSQLManager(id, this, ctx, sxp);
					
					param.put("rfq_no"		, rfq_no);
					param.put("rfq_count"	, rfq_count);
					
					rtn = ssm.doSelect(param); // 조회
					
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
					Logger.err.println(userid, this, e.getMessage());
					setStatus(0);
					setMessage(msg.getMessage("0001"));
				}
				return getSepoaOut(); 
			} 			
			
			/*
			// 소싱그룹 및 업체유형 조건 추가한 메소드(2010.3.21) - 견적업체 선택.
			public SepoaOut getRfqVedorList2(String vendor_code, String vendor_name_loc, String materialType, String materialCtrlType, String materialClass1, String vendorType, String creditRating)
			{ 
				try	{

					String rtn = et_getRfqVedorList2(vendor_code, vendor_name_loc, materialType, materialCtrlType, materialClass1, vendorType, creditRating);

					setValue(rtn); 
					setStatus(1); 
					setMessage(msg.getMessage("STDRFQ.0000")); 

				} catch(Exception e) { 
					Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
					setStatus(0); 
					setMessage(msg.getMessage("STDRFQ.0001")); 
				} 
				return getSepoaOut(); 
			} 

			private	String et_getRfqVedorList2(String vendor_code, String vendor_name_loc, String materialType, String materialCtrlType, String materialClass1, String vendorType, String creditRating) throws Exception 
			{ 
				String rtn = null; 
				ConnectionContext ctx =	getConnectionContext(); 
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				
				StringBuffer sql = new StringBuffer();

				
				try{

					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
					String[] data = {info.getSession("HOUSE_CODE"), 
									info.getSession("HOUSE_CODE"), 
									vendor_code, 
									vendor_name_loc, 
									materialType, 
									materialCtrlType, 
									materialClass1, 
									vendorType, 
									creditRating};
					rtn	= sm.doSelect(data); 

				} catch(Exception e)	{ 
					Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
					throw new Exception(e.getMessage()); 
				}

				return rtn;
			}*/
			
			
			
			
			
} 
 
 
