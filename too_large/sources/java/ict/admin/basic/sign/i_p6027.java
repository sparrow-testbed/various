package ict.admin.basic.sign;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.tcApi2.BEB00730T02;
import com.tcComm2.ONCNF;

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
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import wisecommon.SignRequestInfo;


public class I_p6027 extends SepoaService {
	//Message msg = new Message("FW");  // message 처리를 위해 전역변수 선언
	private Message msg;
	
	public I_p6027(String opt, SepoaInfo info) throws SepoaServiceException{
		super(opt, info);
		setVersion("1.0.0");
		msg = new Message(info,"FW");
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
 * 각모듈의 service 에서 결재를 요청하면 수행되는 method 이다.
 * @param reqInfo
 * @return
 */
	public SepoaOut addSignRequest(SignRequestInfo reqInfo) {
		int rtn = -1;
		String user_id = info.getSession("ID");
		
		try {
			rtn = et_addSignRequest(user_id, reqInfo);
			Commit();
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}catch(Exception e) {
			try 
            { 
                Rollback(); 
            } 
            catch(Exception d) 
            { 
                Logger.err.println(info.getSession("ID"),this,d.getMessage()); 
            } 
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}

	/*결재상신*/
	private int et_addSignRequest(String user_id, SignRequestInfo reqInfo) throws Exception {
		String result = "";
		int result1 = -1;
		int result1_1 = -1;
		int result2 = -1;
		int result3 = -1; // 결재 순서관련
		int cnt = 0;

		SepoaFormater wf 		= null;
		SepoaSQLManager sm 		= null;
		Map<String, String> data = new HashMap<String, String>();

		ConnectionContext ctx = getConnectionContext();
		
		
		
		String house_code 		= reqInfo.getHouseCode();
		String company_code 	= reqInfo.getCompanyCode();
		String dept 			= reqInfo.getDept();
		String doc_type 		= reqInfo.getDocType();

		String doc_no 			= reqInfo.getDocNo();
		String doc_seq 			= reqInfo.getDocSeq();
		String req_user_id 		= reqInfo.getReqUserId();
		String shipper_type 	= reqInfo.getShipperType();
		String ctrl_code 		= reqInfo.getCtrlCode();

		int item_count 			= reqInfo.getItemCount();
		String cur 				= reqInfo.getCur();
		double amt 				= reqInfo.getTotalAmt();
		double amt_ex 			= reqInfo.getTotalAmtEx();
		String acc_code 		= reqInfo.getAccountCode();

		String req_date 		= reqInfo.getReqDate();
		String req_time 		= reqInfo.getReqTime();
		String auto_flag 		= reqInfo.getAutoManualFlag();
		String strategy 		= reqInfo.getStrategyType();
		String app_person 		= reqInfo.getSignUserID();

		String urgent 			= reqInfo.getUrgentFlag();
		String remark 			= reqInfo.getSignRemark();
		String sign_status 		= reqInfo.getSignStatus();
		String OperatingCode 	= reqInfo.getOperatingCode();	//INI 추가 사업장을 의미
		String doc_name 		= reqInfo.getDocName();	//CJ 결재명추가
		//2008-12-26 추가
		String attach_no        = reqInfo.getAttachFile();

		//새로 추가된 부분 6.7 : 결재 순서관련 데이타이다.
		String[][] sign_path_data =  reqInfo.getSign_Path();
		//String[] settype={"S","S","S","S","S","S"};

		String tmp_type = doc_type.substring(0,2);
	
		SepoaXmlParser wxp = null;
		
		
		SepoaOut      value        = null;
    	int                rowCount  = 0;
    	int                iRtnCnt      = 0;     // 성공여부
    	SepoaFormater sf           = null;
    	
    	
		try {

// 			data.put("house_code",       house_code); 
// 			data.put("company_code",     company_code);
 			data.put("doc_type",         doc_type);     
 			data.put("doc_no",           doc_no);         
 			data.put("doc_seq",          doc_seq);       
 //			wxp.addVar("tmp_type", tmp_type);     
			
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_1");
//			wxp.addVar("house_code", house_code);
//			wxp.addVar("company_code", company_code);
//			wxp.addVar("doc_type", doc_type);
//			wxp.addVar("doc_no", doc_no);
//			wxp.addVar("doc_seq", doc_seq);
//			wxp.addVar("tmp_type", tmp_type);


			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			
			result = sm.doSelect(data);
			wf = new SepoaFormater( result );
            cnt = Integer.parseInt( wf.getValue( 0, 0 ) );


            if(cnt > 0 )
            {

            	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_2");
//        		wxp.addVar("house_code", house_code);
//    			wxp.addVar("company_code", company_code);
//    			wxp.addVar("doc_type", doc_type);
//    			wxp.addVar("doc_no", doc_no);
//    			wxp.addVar("doc_seq", doc_seq);
//    			wxp.addVar("tmp_type", tmp_type);


                sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
                
    			
                result1 = sm.doDelete(data);

                wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_3");
//                wxp.addVar("house_code", house_code);
//    			wxp.addVar("company_code", company_code);
//    			wxp.addVar("doc_type", doc_type);
//    			wxp.addVar("doc_no", doc_no);
//    			wxp.addVar("doc_seq", doc_seq);
//    			wxp.addVar("tmp_type", tmp_type);

                sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
                
    			
                result1_1 = sm.doDelete(data);
            }

            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_4");

			data.put("req_user_id",  req_user_id);
			data.put("shipper_type", shipper_type);
			data.put("ctrl_code",    ctrl_code);
			data.put("item_count",   Integer.toString(item_count));
			data.put("cur",          cur);
			data.put("amt",          Double.toString(amt));
			data.put("amt_ex",       Double.toString(amt_ex));
			data.put("acc_code",     acc_code);
			data.put("req_date",     req_date);
			data.put("req_time",     req_time);
			data.put("sign_status",  sign_status);
			data.put("app_person",   app_person);
			data.put("auto_flag",    auto_flag);
			data.put("strategy",     strategy);
			data.put("urgent",       urgent);
			data.put("remark",       SepoaString.replace(remark,"'","''").replaceAll("crcn", "\r\n"));
			data.put("doc_name",     doc_name);
			data.put("attach_no",    attach_no);
			
			
			
//            wxp.addVar("house_code", house_code);
//			wxp.addVar("company_code", company_code);
//			wxp.addVar("doc_type", doc_type);
//			wxp.addVar("doc_no", doc_no);
//			wxp.addVar("doc_seq", doc_seq);
//			wxp.addVar("req_user_id", req_user_id);
//			wxp.addVar("shipper_type", shipper_type);
//			wxp.addVar("ctrl_code", ctrl_code);
//			wxp.addVar("item_count", item_count);
//			wxp.addVar("cur", cur);
//			wxp.addVar("amt", amt);
//			wxp.addVar("amt_ex", amt_ex);
//			wxp.addVar("acc_code", acc_code);
//			wxp.addVar("req_date", req_date);
//			wxp.addVar("req_time", req_time);
//			wxp.addVar("sign_status", sign_status);
//			wxp.addVar("app_person", app_person);
//			wxp.addVar("auto_flag", auto_flag);
//			wxp.addVar("strategy", strategy);
//			wxp.addVar("urgent", urgent);
//			//wxp.addVar("remark", SepoaString.replace(remark,"'","''"));
//			wxp.addVar("attach_no", attach_no);

			//String[] type = {"S"};
//			String[][] data = {{remark}};
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			
			
			result2 = sm.doInsert(data);
/*
*/
			//새로 추가된 부분 6.7 : 결재 순서관련 데이타 입력이다.
			if (sign_path_data != null)
			{

				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_5");
//				wxp.addVar("house_code", house_code);
//				wxp.addVar("company_code", company_code);
//				wxp.addVar("doc_type", doc_type);
//				wxp.addVar("doc_no", doc_no);
//				wxp.addVar("doc_seq", doc_seq);
				
				sm = new SepoaSQLManager(user_id, this, ctx, wxp);
				//result3 = sm.doInsert(sign_path_data);

				for( int i=0; i < sign_path_data.length; i++){
					data.put("sign_path_seq"        , sign_path_data[i][0] );
					data.put("sign_user_id"         , sign_path_data[i][1] );
					data.put("sign_position"        , sign_path_data[i][2] );
					data.put("sign_m_position"      , sign_path_data[i][3] );
					data.put("proceeding_flag"      , sign_path_data[i][4] );
					data.put("sign_check"           , sign_path_data[i][5] );

					result3 = sm.doInsert(data);
				}
			}
			
			

			/*
			  * 합의자는 순서없이 결재한다. *
			 기안시, 결재시 :   다음 PROCEEDING_FLAG = 'P' 의 SIGN_PATH_SEQ와의 차이가
			 								1이 아니면 중간에 PROCEEDING_FLAG = 'C' 협조자가 존재 차이만큼  SIGN_CHECK = 'Y' 업데이트 + 문자보내기
			 								1이면 SIGN_PATH_SEQ+1 에 							  (기존로직)SIGN_CHECK = 'Y' 업데이트 + 문자보내기
			 합의시			: 	다음 PROCEEDING_FLAG = 'P' 밑의 차수가
			     							모두 승인이 이루어 졌다면 			다음 PROCEEDING_FLAG = 'P' 의  SIGN_CHECK = 'Y' 업데이트 + 문자보내기
			     							하나라도 승인안된것이 있다면 		아무반응없다.
			 */
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_6");
			wxp.addVar("current_sign_path_seq", "0");	// 기안자
//			wxp.addVar("house_code", house_code);
//			wxp.addVar("company_code", company_code);
//			wxp.addVar("doc_type", doc_type);
//			wxp.addVar("doc_no", doc_no);
//			wxp.addVar("doc_seq", doc_seq);
			wxp.addVar("current_sign_path_seq", "0");	// 기안자
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			String str_6 = "";
			
			try{
				str_6 = sm.doSelect(data);				
			}
			catch(Exception e){
//				e.printStackTrace();
				
				
				
				throw e;
			}
			
			
			SepoaFormater wf_6 = new SepoaFormater(str_6);
			String GAP = wf_6.getValue("GAP", 0);

			if("".equals(GAP)){
				
				// 기안자 다음으로 모두 합의인경우, 모든 합의자 SIGN_CHECK = 'Y' 업데이트, 문자보내기 -- 그럴일은 없다.  마지막결재자인경우에는 결재완료 로직에서처리
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_7_1");
//				wxp.addVar("house_code", house_code);
//				wxp.addVar("company_code", company_code);
//				wxp.addVar("doc_type", doc_type);
//				wxp.addVar("doc_no", doc_no);
//				wxp.addVar("doc_seq", doc_seq);
				wxp.addVar("current_sign_path_seq", 0);	// 기안자
				sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
				
				
				int rtn_7_1 = 0;
				rtn_7_1 = sm.doUpdate(data);
				
				
				
				
				// 문자보내기

			}else if("1".equals(GAP)){

				// 문자보내기
			}else {
				// 기안자 다음으로 모두 합의인경우, 모든 합의자 SIGN_CHECK = 'Y' 업데이트, 문자보내기
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_7_2");
				//				wxp.addVar("house_code", house_code);
//				wxp.addVar("company_code", company_code);
//				wxp.addVar("doc_type", doc_type);
//				wxp.addVar("doc_no", doc_no);
//				wxp.addVar("doc_seq", doc_seq);
				wxp.addVar("current_sign_path_seq", 0);							// 기안자
				wxp.addVar("next_sign_path_seq_p", 0 + Integer.parseInt(GAP));	// 다음 결재자(PROCEEDING_FLAG = 'P')
				sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
				
				int rtn_7_1 = sm.doUpdate(data);

				// 문자보내기
			}

			
			if ("PAY".equals(doc_type)) {
				
				Map<String, String> data2 = new HashMap<String, String>();
				
				data2.put("pay_act_no"	, doc_no);				
				String user_trm_no = reqInfo.getUser_trm_no();				
				data2.put("user_trm_no"	, user_trm_no);
				
				
				wxp = new SepoaXmlParser(this, "bl_getSpy2List");
		    	sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());				
				result = sm.doSelect(data2);
				wf = new SepoaFormater( result );
				
				rowCount = wf.getRowCount(); // 조회 row 수
				
				if(rowCount == 1){
			    	
			    	data2.put("VENDOR_CODE"          ,  wf.getValue("VENDOR_CODE",0));
			    	data2.put("STD_DATE"             ,  SepoaString.getDateUnSlashFormat( wf.getValue("STD_DATE",0)) );
			    	data2.put("DEPOSITOR_NAME"       ,  wf.getValue("DEPOSITOR_NAME",0));
			    	data2.put("BANK_CODE"            ,	 wf.getValue("BANK_CODE",0));
			    	data2.put("BANK_ACCT"            ,  wf.getValue("BANK_ACCT",0));
			    	data2.put("SUPPLY_AMT"           ,  wf.getValue("SUPPLY_AMT",0));
			    	data2.put("TAX_AMT"              ,  wf.getValue("TAX_AMT",0));
			    	data2.put("TOT_AMT"              ,  wf.getValue("TOT_AMT",0));
			    	data2.put("BMSBMSYY"             ,  wf.getValue("BMSBMSYY",0));
			    	data2.put("BUGUMCD"              ,  wf.getValue("BUGUMCD",0));
			    	data2.put("ACT_DATE"             ,  SepoaString.getDateUnSlashFormat( wf.getValue("ACT_DATE",0)) );
			    	data2.put("EXPENSECD"            ,  wf.getValue("EXPENSECD",0));
			    	data2.put("SEMOKCD"              ,  wf.getValue("SEMOKCD",0));
			    	data2.put("SAUPCD"               ,	 wf.getValue("SAUPCD",0));
			    	data2.put("DOC_TYPE"             ,	 wf.getValue("DOC_TYPE",0));
			    	data2.put("PAY_TYPE"             ,	 wf.getValue("PAY_TYPE",0));
			    	data2.put("PAY_REASON"           ,  wf.getValue("PAY_REASON",0));
			    	data2.put("TAX_NO"               ,  wf.getValue("TAX_NO",0));
			    	data2.put("NTS_APP_NO"           ,  wf.getValue("NTS_APP_NO",0));
			    	data2.put("ACC_TAX_DATE"         ,  SepoaString.getDateUnSlashFormat( wf.getValue("ACC_TAX_DATE",0)) );
			    	data2.put("ACC_TAX_SEQ"          ,  wf.getValue("ACC_TAX_SEQ",0));
			    	data2.put("APP_STATUS_CD"        ,  wf.getValue("APP_STATUS_CD",0));
			    	data2.put("ADD_DATE"             ,  wf.getValue("ADD_DATE",0));
			    	data2.put("ADD_TIME"             ,  wf.getValue("ADD_TIME",0));
			    	data2.put("ADD_USER_ID"          ,  wf.getValue("ADD_USER_ID",0));
			    	data2.put("ISU_DT"               ,  wf.getValue("ISU_DT",0));
			    	data2.put("SEBUCD"               ,  wf.getValue("SEBUCD",0));
			    	data2.put("ZIPHANGCD"            ,  wf.getValue("ZIPHANGCD",0));
			    	data2.put("VENDOR_NAME"          ,  wf.getValue("VENDOR_NAME",0));
			    	data2.put("IRS_NO"               ,  wf.getValue("IRS_NO",0));
			    	
			    	String  rtn   = this.et_setBEB00730T02(info, data2);
			    	
			    	if(rtn.length() > 3 && !"ERR".equals(rtn.substring(0,3))){
			    					    						    			
			    		//data2.put("PYDTM_APV_NO", rtn);
			    		data2.put("PYDTM_APV_NO", rtn);
			    		
			    		wxp = new SepoaXmlParser(this, "setPydtmApvNoUpdate");
			    		sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			    		//iRtnCnt = sm.doUpdate(data2);
			    		iRtnCnt = sm.doUpdate(data2);			    						    			
			    		if(iRtnCnt < 1) {
			    			throw new Exception();
			    		}
			    					    						    					    		
//			    		if(isStatus2) {
//			    			//gdResMessage = rtn+": 지급결의승인번호가 발급되었습니다.";
//			    			setStatus(1);
//			    		}
//			    		else {
//			    			Rollback();
//			    			throw new Exception();
//			    		}
			    	}else{
			    		//gdResMessage = rtn;
//			    		Rollback();
//			    		setStatus(0);
			    		throw new Exception();
			    	}
			    	
				}
			}			
			
        }catch(Exception e) {
//        	e.printStackTrace();
			throw new Exception("et_addSignRequest: " + e.getMessage());
		}
		//Logger.debug.println(user_id, this, "result=="+result);
		return result2;
	}

	/**
     * 경비지급결의 
     * et_setBEB00730T02
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2015-01-15
     * @modify 2015-01-15
     */
    private String et_setBEB00730T02(SepoaInfo info, Map<String, String> header) throws Exception {
		
    	String result               = null;
		String data_tot_size       = null;
		
		String              BKCD         = null;
		String              BRCD         = null; 
		String              TRMBNO       = null;
		String              USERTERMNO   = null;
		String              TERMNO9      = null;
		String              addUserId    = null;
		
		Configuration conf       = new Configuration();
	   	String send_ip           = conf.get("sepoa.interface.tcpip.ip");
	   	int send_port            = Integer.parseInt(conf.get("sepoa.interface.tcpip.port"));
	   	ONCNF.LOGDIR             = conf.get("sepoa.logger.dir");
		
	   	
	   	
	   	/* ASIS 2017-07-01
	   	if(header.get("user_trm_no").length() >= 9){
			BKCD       = header.get("user_trm_no").substring(0,  5);
			BRCD       = header.get("user_trm_no").substring(5,  6); 
			TRMBNO     = header.get("user_trm_no").substring(6,  9);
			USERTERMNO = header.get("user_trm_no").substring(9,  10);
			TERMNO9    = header.get("user_trm_no").substring(0,  9);
			addUserId  = header.get("user_trm_no").substring(10, 18);
		}
	   	   	
		BEB00730T02 n02 = new BEB00730T02();

		data_tot_size    = String.format("%05d", n02.SEND.iTLen-20);		    					  //00433000000

		n02.SEND.IMHD = "<IM>";    	// C4    전문내용시작태그     	
		n02.SEND.IMFL       = data_tot_size;                                        // C11  FILLER    IM제외 전문길이(5) + '000000'	//"00041";                                        // C11  FILLER    IM제외 전문길이(5) + '000000'
		n02.SEND.TRDT       = "";//SepoaDate.getShortDateString();                       // 2.  C8    거래일자  "20141216"
		n02.SEND.MSG_DSCD         = "020";
		n02.SEND.MSG_UNQ_ID_NO    = header.get("pay_act_no");		        //"0202015000000004";
		n02.SEND.BGT_YR           = header.get("BMSBMSYY");			        // "2015";
		n02.SEND.BR_CD            = header.get("BUGUMCD");			        //"20644";
		n02.SEND.DTM_DT           = header.get("ACT_DATE");					//"20150114";
		n02.SEND.XPN_CD           = header.get("EXPENSECD");				//"211200";
		n02.SEND.TAITM_CD         = header.get("SEMOKCD");					//"211202";
//		n02.SEND.TAITM_CD         = header.get("SEMOKCD").length() == 0 ? header.get("EXPENSECD") : header.get("SEMOKCD");					//"211202";
		n02.SEND.BIZ_CD           = header.get("SAUPCD");					//"900";
		n02.SEND.DTM_DSCD         = "1";					                //"1";
		n02.SEND.CSHTF_DSCD       = header.get("PAY_TYPE");					//"2";
		n02.SEND.EXE_AM           = String.format("%013d",Integer.parseInt(header.get("TOT_AMT")));					//"0000002570454";
		n02.SEND.XPN_CRT_DSCD     = header.get("DOC_TYPE");					//"9";
		n02.SEND.XPN_ACT_RPSPE_NM = info.getSession("NAME_LOC");			//"장태준";
		n02.SEND.XPN_ACT_PE_CN    = "0000";									//"0000";
		n02.SEND.TXBIL_PT_GBN     = "2";									//"2";
		n02.SEND.XPN_DTL_CD       = header.get("SEBUCD");					//"2163010101";   //추가 XPN_CD = 20150114
		n02.SEND.XPN_PLC_CD       = header.get("ZIPHANGCD");				//"2000695";				//추가
		n02.SEND.PAY_RRCV_RSN_TXT = header.get("PAY_REASON");				//"테스트..";
		n02.SEND.MAKE_CN          = "01";									//"01";
		n02.SEND.SER_NO           = "001";									//"001";
		n02.SEND.PAY_AM           = String.format("%013d",Integer.parseInt(header.get("SUPPLY_AMT")));				//"0000002336778";
		n02.SEND.ADD_TAX          = String.format("%010d",Integer.parseInt(header.get("TAX_AMT")));					//"0000233676";
		n02.SEND.TRF_BK_CD        = header.get("BANK_CODE");				//"020";
		n02.SEND.TRF_ACNO_TXT     = header.get("BANK_ACCT");				//"1002467114810";
		n02.SEND.WCRT_ISU_DT	  = header.get("ISU_DT");					//"20131231"; //추가 ISU_DT
		n02.SEND.BIZ_NO           = header.get("IRS_NO");					//
		n02.SEND.BIZ_NM           = header.get("VENDOR_NAME");				//"테스트업체";
		n02.SEND.RCPCO_BIZ_NO	  = header.get("");					        //"";  //추가
		n02.SEND.RCPCO_NM	      = header.get("");					        //"";  //추가
		n02.SEND.RCP_RSN_TXT      = header.get("");					        //"";  //추가
		n02.SEND.RCPPE_NM         = header.get("");					        //"";
		n02.SEND.RGS_DT           = header.get("ACC_TAX_DATE");				//"20150106";		//"20131231" RGS_DT
		n02.SEND.RGS_SER_NO       = header.get("ACC_TAX_SEQ");				//"00206";		//"00703"
		n02.SEND.IMED             = "</IM>"; // C4    전문내용종료태그     	
		
		//n02.SEND.bizHdr.UID       = header.get("ADD_USER_ID");
		
		n02.SEND.bizHdr.BK_CD         = BKCD;                //(5)  C단말번호점코드(5)  +단말종류(1)  +부/점별단말SEQ(3)  ) "20644"                                               
        n02.SEND.bizHdr.BR_CD         = BRCD;                //(1)  WooriDevice.dll에서단말번호가져옴-> "C"                                                            
        n02.SEND.bizHdr.TRM_BNO       = TRMBNO;              //(3)  PDA의단말번호는'20481'->  "004"                                                                   
        n02.SEND.bizHdr.USER_TRM_NO   = USERTERMNO;          //(1)  사용자단말번호 "5"                                                                                
        n02.SEND.bizHdr.UID           = addUserId;           //(8)  PDA조작자번호 행번                                                              
        */
	   	
	   	
	   	Logger.sys.println("I_p6027 et_setBEB00730T02-2 user_trm_no : " +  header.get("user_trm_no"));
	   	
        /* TOBE 2017-07-01 */	   	
	   	if(header.get("user_trm_no").length() >= 12){
			BKCD       = header.get("user_trm_no").substring(0,  6);      //점코드
			USERTERMNO = header.get("user_trm_no").substring(0, 12);      //사용자단말번호
			addUserId  = header.get("user_trm_no").substring(12);         //조작자번호
		}
	   	
	   	Logger.sys.println("I_p6027 et_setBEB00730T02-2.5 addUserId : " + addUserId);
	   	
	   	
	   	BEB00730T02 n02 = new BEB00730T02();
 
	   	Logger.sys.println("I_p6027 et_setBEB00730T02-3 : " + header.get("user_trm_no"));
	   	
	   	data_tot_size    = String.format("%07d", n02.SEND.iTLen-10); // 데이터부 데이터길이 -10
		
		n02.SEND.DAT_KDCD   = "DTI";           //데이타헤더부 : (문자3)  데이터종류코드	      
		n02.SEND.DAT_LEN    = data_tot_size;   //데이타헤더부 : (숫자7)  데이터길이
		
		n02.SEND.TLM_DSCD               = "020";                        //1.   S3         전문구분코드                
		n02.SEND.TLM_UNQ_IDF_NO   	    = header.get("pay_act_no");     //2.   S16        전문고유식별번호            
		n02.SEND.BGT_YY                 = header.get("BMSBMSYY");       //3.   S4         예산년도                    
		n02.SEND.BGT_BRCD               = header.get("BUGUMCD");        //4.   S6         예산점코드                  
		n02.SEND.PAY_DTMN_DT            = header.get("ACT_DATE");       //5.   S8         지급결의일자                
		n02.SEND.BGT_XPN_CD             = header.get("EXPENSECD");      //6.   S6         예산경비코드                
		n02.SEND.BGT_ITTX_CD            = header.get("SEMOKCD");        //7.   S6         예산세목코드                
		n02.SEND.BGT_BZN_CD             = header.get("SAUPCD");         //8.   S3         예산사업코드                
		n02.SEND.BGT_DTMN_DSCD          = "1";                          //9.   S1         예산결의구분코드            
		n02.SEND.CSHTF_DSCD             = header.get("PAY_TYPE");       //10.  S1         현금대체구분코드            
		n02.SEND.EXU_AM                 = String.format("%015d",Integer.parseInt(header.get("TOT_AMT")));    //11.  D15        집행금액                    
		n02.SEND.EXPD_EVDC_DSCD         = header.get("DOC_TYPE");       //12.  S2         지출증빙구분코드 (2017-07-01 ASIS '9' -> TOBE '09')           
		n02.SEND.XPN_PAY_RSN_TXT        = header.get("PAY_REASON");     //13.  S100       경비지급사유내용            
		n02.SEND.ELT_TXBIL_PTPY_YN      = "N";                          //14.  S1         전자세금계산서분할지급여부 (2017-07-01 ASIS '2' -> TOBE 'N')  
		n02.SEND.XPN_BGT_DTLS_CD        = header.get("SEBUCD");         //15.  S10        경비예산세부코드            
		n02.SEND.EXU_TGT_PLC_CD         = header.get("ZIPHANGCD");      //16.  S7         집행대상장소코드            
		n02.SEND.GRID_ROW_CNT           = "00001";                      //17.  N5         그리드열건수                
		n02.SEND.BGT_PAY_DTMN_SRNO      = "001";                        //18.  N3         예산지급결의일련번호        
		n02.SEND.SPL_AM                 = String.format("%015d",Integer.parseInt(header.get("SUPPLY_AMT"))); //19.  D15        공급금액                    
		n02.SEND.VAT                    = String.format("%015d",Integer.parseInt(header.get("TAX_AMT")));	 //20.  D15        부가세                      
		n02.SEND.RCV_BKCD               = header.get("BANK_CODE");      //21.  S3         입금은행코드                
		n02.SEND.RCV_BKW_ACNO           = header.get("BANK_ACCT");      //22.  S20        입금전행계좌번호            
		n02.SEND.EVDCD_ISSU_DT          = header.get("ISU_DT");         //23.  S8         증빙서발행일자              
		n02.SEND.PYCO_BZNO              = header.get("IRS_NO");         //24.  S10        지급처사업자등록번호        
		n02.SEND.XPN_PYCO_NM            = header.get("VENDOR_NAME");    //25.  S100       경비지급처명                
		n02.SEND.RPTNL_BZNO             = header.get("");               //26.  S10        접대처사업자등록번호        
		n02.SEND.RPTNL_NM               = header.get("");               //27.  S40        접대처명                    
		n02.SEND.RPTN_RSN_TXT           = header.get("");               //28.  S100       접대사유내용                
		n02.SEND.ALL_RCVDP_TXT          = header.get("");               //29.  S4000      전체접대받는자내용          
		n02.SEND.RCVDP_CPE_CN           = header.get("");               //30.  N6         접대받는자인원수            
		n02.SEND.ALL_RCPPE_TXT          = info.getSession("NAME_LOC");  //31.  S4000      전체접대자내용              
		n02.SEND.RCPPE_CPE_CN           = "000000";                     //32.  N6         접대자인원수                
		n02.SEND.TXBIL_RGS_DT           = header.get("ACC_TAX_DATE");   //33.  S8         세금계산서등록일자          
		n02.SEND.TXBIL_RGS_SRNO         = header.get("ACC_TAX_SEQ");    //34.  N5         세금계산서등록일련번호   
		
		n02.SEND.trnHdr.TRM_BRNO      = BKCD;                //단말점번호    
		n02.SEND.trnHdr.TRN_TRM_NO    = USERTERMNO;          //단말번호
		n02.SEND.trnHdr.DL_BRCD       = BKCD;                //취급점번호    
        n02.SEND.trnHdr.OPR_NO        = addUserId;           //조작자번호
		

		Logger.sys.println("I_p6027 et_setBEB00730T02-4 : " + header.get("user_trm_no"));
		
		try {
			Logger.sys.println("I_p6027 et_setBEB00730T02-4.5 : " + header.get("user_trm_no"));
			
			int iret = n02.sendMessage("BEB00730T02",send_ip,send_port);
			
			Logger.sys.println("I_p6027 et_setBEB00730T02-5 : " + header.get("user_trm_no"));
			if(iret == ONCNF.D_OK) {
				n02.RECV.log(ONCNF.LOGNAME, "");	
				//ASIS 2017-07-01 result = n02.RECV.PYDTM_APV_NO;
				//TOBE 2017-07-01
				
				Logger.sys.println("I_p6027 et_setBEB00730T02-6 : " + header.get("user_trm_no"));
				result = n02.RECV.PAY_DTMN_APV_NO; //5. N7   지급결의승인번호
				
			}else if(iret == ONCNF.D_ECODE) {
//				System.out.println("ERRCODE = "+n02.RECV.bizHdr.ERRCODE+ONCNF.D_ERR);
//				System.out.println("ERR:["+n02.RECV.bizHdr.ERRCODE+"]"+n02.eRECV.MESSAGE);
				//ASIS 2017-07-01 result = "ERR:["+n02.RECV.bizHdr.ERRCODE+"]"+n02.eRECV.MESSAGE;
				//TOBE 2017-07-01
				
				Logger.sys.println("I_p6027 et_setBEB00730T02-7 : " + header.get("user_trm_no"));
				result = "ERR:["+n02.RECV.msgHdr.MSG_CD+"]"+n02.eRECV.MESSAGE;
			}else {
//				System.out.println("sendMessage call error !!.." + iret);
				
				Logger.sys.println("I_p6027 et_setBEB00730T02-8 : " + header.get("user_trm_no"));
				result = "ERR:sendMessage call error !!.." + iret;
			}
		}
		catch (Exception e) {
			Logger.sys.println("I_p6027 et_setBEB00730T02-9 : " + header.get("user_trm_no"));
			result = "ERR:sendMessage call error !!..";
			//e.printStackTrace();
		}
		
    	return result;
	}






}
