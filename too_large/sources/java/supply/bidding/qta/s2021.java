package supply.bidding.qta;  
  
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

 
  
  
/**  
* <code>  
* 품목을 생성한다.  
* <pre>   
* (#)master/s0001.java    01/08/07  
* Copyright 2001-2001 ICOMPIA Co., Ltd. All Rights Reserved.  
* This software is the proprietary information of ICOMPIA Co., Ltd.  
* @version        1.0  
* @author         임석재  
* </code></pre>  
*/  
  
////////////////////////  
/*  
getQuery_Cre_Qta_Header : 견적서생성 HD조회(qta_bd_ins1.jsp, qta_bd_ins1.java)  
getQuery_Cre_Qta_Detail : 견적서생성 DT조회(qta_bd_ins1.jsp, qta_bd_ins1.java)  
setInsert_Qta_Cre       : 견적서 생성(qta_bd_ins1.jsp, qta_bd_ins1.java)  
  
getQuery_Upd_Qta_Header : 견적서수정 HD조회(qta_bd_upd1.jsp, qta_bd_upd1.java)  
getQuery_Upd_Qta_Detail_Qta : 견적서수정 DT조회(qta_bd_upd1.jsp, qta_bd_upd1.java)-- QtaNO를 가지고 조회했을경우  
getQuery_Upd_Qta_Detail_Rfq : 견적서수정 DT조회(qta_bd_upd1.jsp, qta_bd_upd1.java)-- RfqNO를 가지고 조회했을경우  
getQuery_QTEP               : 견적서수정 DT조회(원가내역서 조회)  
getQuery_QTCH               : 견적서수정 DT조회(CHARGE 조회)  
setUpdate_Qta_Upd       : 견적서 수정(qta_bd_upd1.jsp, qta_bd_upd1.java)  
  
getCurrentQtaList       : 견적서 진행현황 조회(qta_bd_lis1.jsp, qta_bd_lis1.java)  
setQtDelete             : 견적서 삭제(qta_bd_lis1.jsp, qta_bd_lis1.java)  
  
getCompanyQtaList       : 업체현황조회(qta_bd_lis2.jsp, qta_bd_lis2.java)  
  
getRfqEP_qta            : 원가내역서 팝업(qta_pp_ins7.jsp)  
  
getCharge               : CHARGE 조회  
  
  
*/  
////////////////////////  
  
public class s2021 extends SepoaService  
{  
    //Session 정보를 담기위한 변수  

    String lang                  = "KO";  
    private Message msg = null;  
  
    public s2021(String opt,SepoaInfo info) throws SepoaServiceException  
    {  
        super(opt, info);  
        setVersion("1.0.0");  
  
        //Session 정보 조회  
        msg = new Message(info,"STDSUPQTA");  
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
     * 조회전 조회 조건 셋팅
     * @method setRFQExtends
     * @since  2014-09-03
     * @modify 2014-09-30
     * @param header
     * @return Map
     * @throws Exception
     */
    public SepoaOut getQuery_Upd_Qta_Header(String RFQ_NO,String RFQ_COUNT,String VENDOR_CODE, String QTA_NO)  
    {  
        try {  
            String rtn = "";  
  
            rtn = et_getQuery_Upd_Qta_Header_qt(VENDOR_CODE, QTA_NO);  
  
            setValue(rtn);  
            setStatus(1);  
        }catch (Exception e){  
           // Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + stackTrace(e));  
            setStatus(0);  
        }  
        return getSepoaOut();  
    }  
  
    private String  et_getQuery_Upd_Qta_Header_qt(String VENDOR_CODE, String QTA_NO) throws Exception  
    {  

        String rtn = "";  
        ConnectionContext ctx = getConnectionContext();  
        try {  
        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	wxp.addVar("VENDOR_CODE", info.getSession("COMPANY_CODE"));
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
  
            String[] args = {QTA_NO, VENDOR_CODE, info.getSession("HOUSE_CODE")};  
            rtn = sm.doSelect(args);  
  
            if(rtn == null) throw new Exception("SQL Manager is Null");  
        }catch(Exception e) {  
            throw new Exception("et_getQuery_Upd_Qta_Header_qt=========>"+e.getMessage());  
        } finally{  
        }  
        return rtn;  
    }
    
    
    /**
     * 견적서 수정 품목 조회
     * @method getQuery_Cre_Qta_Detail
     * @since  2014-10-08
     * @modify 2014-10-08
     * @param header
     * @return Map
     * @throws Exception
     */
    public SepoaOut getQuery_Upd_Qta_Detail_Qta(Map<String, String> header) throws Exception  
    {  
    	ConnectionContext ctx                   = getConnectionContext();
		SepoaXmlParser    sxp                   = null;
		SepoaSQLManager   ssm                   = null;
		String            rtn                   = null;
		String            id                    = info.getSession("ID");
		
		try{
//System.out.println("debug:s2021:166"+header);			
			setStatus(1);
			setFlag(true);
			
			sxp = new SepoaXmlParser(this, "getQuery_Upd_Qta_Detail_Qta");
			sxp.addVar("language", info.getSession("LANGUAGE"));
			sxp.addVar("GROUP_YN", header.get("st_group_yn"));
        	
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
        	rtn = ssm.doSelect(header);
        	
        	setValue(rtn);
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		
		return getSepoaOut();
    }
    
    
    /**
     * 견적서 등록 품목 조회
     * @method getQuery_Cre_Qta_Detail
     * @since  2014-10-08
     * @modify 2014-10-08
     * @param header
     * @return Map
     * @throws Exception
     */
    public SepoaOut getQuery_Cre_Qta_Detail(Map<String, String> header) throws Exception  
    {  
    	ConnectionContext ctx                   = getConnectionContext();
		SepoaXmlParser    sxp                   = null;
		SepoaSQLManager   ssm                   = null;
		String            rtn                   = null;
		String            id                    = info.getSession("ID");
		//Map<String, String> header              = null;
		Map<String, String> customHeader        = null;
		
		try{
			
			setStatus(1);
			setFlag(true);
			
			//header       = MapUtils.getMap(data, "headerData"); // 조회 조건 조회
			//customHeader = new HashMap<String, String>();	
			
			sxp = new SepoaXmlParser(this, "getQuery_Cre_Qta_Detail");
			sxp.addVar("language", info.getSession("LANGUAGE"));
			sxp.addVar("st_vendor_code", header.get("st_vendor_code"));		//공개견적일때 자료 조회
			sxp.addVar("st_group_yn", header.get("st_group_yn"));
			
        	ssm = new SepoaSQLManager(id, this, ctx, sxp);
        	//System.out.println("서비스ㅡ998ㅡㅡㅡ"+header);
        	rtn = ssm.doSelect(header);
        	
        	setValue(rtn);
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		
		return getSepoaOut();
    }
    
    /**
     * 견적서 등록
     * @method setInsert_Qta_Cre
     * @since  2014-10-08
     * @modify 2014-10-08
     * @param header
     * @return Map
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
	public SepoaOut setInsert_Qta_Cre(Map<String, Object> param) throws Exception{  
		/*
		  String send_flag
		 	, String RFQ_NO
			, String RFQ_COUNT
			, String QTA_NO
			, String[][] chkCreateData
			, String[][] qthdData
			, String[][] qtdtData
			, String[][] rqdtData
			, String[][] rqseData
			, String[][] qtepData
			, String[][] rqepData
			, String[][] qtpfData
    	*/
    	
    	
    	
    	
		String send_flag                       = (String) param.get("SEND_FLAG");
    	String add_user_id                     =  info.getSession("ID");
        String house_code                      =  info.getSession("HOUSE_CODE");
        String company_code                    =  info.getSession("COMPANY_CODE");

        String rfq_no						   = (String) param.get("RFQ_NO");
        String rfq_count					   = (String) param.get("RFQ_COUNT");
        String seq_qta_no					   = (String) param.get("seqQtaNo");
        
        List<Map<String, String>> chkCreateData= (List<Map<String, String>>)param.get("chkCreateData");
//        Map<String, String> chkCreateData      = (Map<String, String>)param.get("chkCreateData");
        List<Map<String, String>> qthdData     = (List<Map<String, String>>)param.get("qthdData");
        List<Map<String, String>> qtdtData     = (List<Map<String, String>>)param.get("qtdtData");
        List<Map<String, String>> rqdtData     = (List<Map<String, String>>)param.get("rqdtData");
        List<Map<String, String>> rqseData     = (List<Map<String, String>>)param.get("rqseData");
        List<Map<String, String>> qtepData     = (List<Map<String, String>>)param.get("qtepData");
        List<Map<String, String>> rqepData     = (List<Map<String, String>>)param.get("rqepData");
        List<Map<String, String>> qtpfData     = (List<Map<String, String>>)param.get("qtpfData");
		
        ConnectionContext         ctx          = null;
    	int                       rtn          = 0;  
		
			
		try {  
			
			ctx = getConnectionContext();  
			
			String yn = et_getYN(rfq_no, rfq_count);  
			
			SepoaFormater wf = new SepoaFormater(yn);  
			String tmp = wf.getValue(0,0); // 견적마감일 체크 

				
			
			//견적마감일자가 맞지 않으면 return WORK 필요 임시주석
			/*if(Integer.parseInt(tmp) == 0) {  
				setMessage(msg.getMessage("0005"));  
				setStatus(3);  
				return getSepoaOut();  
			}*/  
			
			
			Map<String, String> chkCreateInfo = null;
			
			
			for(int i = 0 ; i < chkCreateData.size() ; i++) {
				
				
				chkCreateInfo     = chkCreateData.get(i);
				
				
				String createFlag = et_getCreateFlag(chkCreateInfo.get("rfq_no")
				    	                            ,chkCreateInfo.get("rfq_count")
				    	                            ,chkCreateInfo.get("rfq_seq"));
				
				
				
				wf = new SepoaFormater(createFlag);
				
				
				
				int qt_cnt = Integer.parseInt(wf.getValue(0,0));
				int rq_cnt = Integer.parseInt(wf.getValue(1,0));
				
				
				
				//체크로직 자료 입력때문 임시 주석 WORK 필요 
				/*if(!( qt_cnt == 0 && rq_cnt == 0)) {
				    setMessage(msg.getMessage("0009"));  
				    setStatus(3);  
				    return getSepoaOut();
				}*/
			}
						
				
			
			rtn = setInsert_qtHD(ctx, qthdData);												//견적서 마스터 정보 입력
			rtn = setInsert_qtDT(ctx, qtdtData);												//견적서 상세 정보 입력
			
			
			
			if (send_flag.equals("Y")) {
				rtn = setUpdate_rqhd_bid(ctx,info.getSession("HOUSE_CODE"),rfq_no,rfq_count);
				rtn = setUpdate_rqdt_bid(ctx, rqdtData);  
			}
			
			
			
			// 업체 일반경쟁인경우 인서트, 지명경쟁인경우 업데이트		
			//rtn = setUpdate_rqse_con_new(ctx, qthdData[0][4], rqseData);                     
			rtn = setUpdate_rqse_con_new(ctx, info.getSession("VENDOR_CODE"), rqseData);                      
			
			if(qtepData.size() > 0) { 
				Logger.debug.println(info.getSession("ID"),this,"qtepData==============>" + qtepData.size());  
				rtn = set_qtEP_01(ctx, qtepData);  
			}
				
			
			if(rqepData.size() > 0) {
				Logger.debug.println(info.getSession("ID"),this,"rqepData==============>" + rqepData.size());  
				ep_setCostUpdate(ctx, rqepData);
			}
				
			//ICOYQTPF 테이블이 없음. WORK 필요
			/*if(qtpfData.size() > 0) {
				Logger.debug.println(info.getSession("ID"),this,"qtpfData==============>" + qtpfData.size());  
				rtn = setProfile(ctx, qtpfData);
			}*/
	
	
			setStatus(1);  
	//		msg.setArg("QTA_NO", QTA_NO);
	//		setMessage(msg.getMessage("0010"));
				
			String send_msg = "견적서 번호 " + seq_qta_no + " 가 작성되었습니다.";
			if (send_flag.equals("Y")) {
				send_msg = "견적서 번호 " + seq_qta_no + " 가 제출되었습니다.";
			}
			setMessage(send_msg);
				
			Commit();  
		}catch(Exception e) {  
			
			try{  
				Rollback();  
			}catch(Exception e1){ setStatus(0); }  
			//Logger.err.println("Exception e =" + stackTrace(e));  
//			e.printStackTrace();
			setStatus(0);  
			setMessage(msg.getMessage("0012"));  
			//Logger.err.println(this,stackTrace(e));  
		}  
			
		return getSepoaOut();  
    }

    /**
     *견적의뢰대상업체정보 업데이트
     * @method setUpdate_rqse_con_new
     * @since  2014-10-08
     * @modify 2014-10-08
     * @param header
     * @return Map
     * @throws Exception
     */
    private int setUpdate_rqse_con_new(ConnectionContext ctx, String company_code, List<Map<String, String>> rqseData) throws Exception {

    	int rtn = -1;  
		SepoaSQLManager sm = null;  
		
		try {  
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("company_code", company_code);
			for(int i=0;i<rqseData.size();i++){
				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
				rtn = sm.doInsert(rqseData.get(i));  
			}
		
		}catch(Exception e) {  
		// Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		}  
			return rtn;  
	}

	/**
     * ICOYQTPF 정보가 없음.
     * @method setProfile
     * @since  2014-10-08
     * @modify 2014-10-08
     * @param header
     * @return Map
     * @throws Exception
     */
    private int setProfile(ConnectionContext ctx, List<Map<String, String>> qtpfData) throws Exception{  
    		int rtn = -1;  
    		
    		try {  
    			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
    			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
    			
    			/*String[] type =	{ "S","S","S","S","S"
    							, "S","S","S","S","S"
    							, "S","S","S","S","S"
    							, "S","S","S","S","S" 
    						};  */
    			
    			rtn = sm.doInsert(qtpfData);  
     		}catch(Exception e) {  
    		// Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
    			throw new Exception(e.getMessage());  
    		}  
    			return rtn;  
    	}
    	
	/**
     * ICOYRQEP
     * @method ep_setCostUpdate
     * @since  2014-10-08
     * @modify 2014-10-08
     * @param header
     * @return Map
     * @throws Exception
     */
    private void ep_setCostUpdate(ConnectionContext ctx, List<Map<String, String>> rqepData)throws Exception{  
	
		
		try{  
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			/*String[] type = {"S","S","S","N","S"
						,"S","S"};*/
			sm.doUpdate(rqepData);  
		
		}catch(Exception e) {  
		    
			Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		
		}  
	}
	 

	/**
     * ICOYQTEP
     * @method set_qtEP_01
     * @since  2014-10-08
     * @modify 2014-10-08
     * @param header
     * @return Map
     * @throws Exception
     */
    private int set_qtEP_01(ConnectionContext ctx,
			List<Map<String, String>> qtepData) throws Exception {
		int rtn = -1;  
		
		SepoaSQLManager sm = null;  
		
		try {  
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			
			/*String[] type = {"S", "S", "S", "S", "S"
							,"S", "S", "S", "N", "S"
							,"N", "N", "S", "S", "N"
							,"S", "S", "S", "S", "S"
							,"S"
							};*/
			rtn = sm.doInsert(qtepData);  
		
		}catch(Exception e) {  
		// Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		}  
			return rtn;  
	}

	/**
     * 견적서 수정
     * @method setUpdate_Qta_Upd
     * @since  2014-10-08
     * @modify 2014-10-08
     * @param header
     * @return SepoaOut
     * @throws Exception
     */
    public SepoaOut setUpdate_Qta_Upd(Map<String, Object> param) throws Exception{ 
	    	
    	ConnectionContext         ctx          = null;
    	int                       rtn          = 0;  
		String                    RFQ_NO       = (String)param.get("RFQ_NO");
		String                    RFQ_COUNT    = (String)param.get("RFQ_COUNT");
		
		String                    QTA_NO       = (String)param.get("QTA_NO");
		String                    PRE_SEND_FLAG= (String)param.get("PRE_SEND_FLAG");
		String                    send_flag    = (String)param.get("SEND_FLAG");

//		System.out.println("debug:    QTA_NO:"     +param.get("QTA_NO"));       
//		System.out.println("debug:    qthdData"    +(List<Map<String, String>>)param.get("qthdData"));         
//		System.out.println("debug:    qtdtData"    +(List<Map<String, String>>)param.get("qtdtData"));            
//		System.out.println("debug:    rqdtData"    +(List<Map<String, String>>)param.get("rqdtData"));          
//		System.out.println("debug:    delQtdtData" +(List<Map<String, String>>)param.get("delQtdtData"));           
//		System.out.println("debug:    delQtepData" +(List<Map<String, String>>)param.get("delQtepData"));          
//		System.out.println("debug:    delQtpfData" +(List<Map<String, String>>)param.get("delQtpfData"));        
//		System.out.println("debug:    rqseData"    +(List<Map<String, String>>)param.get("rqseData"));        
//		System.out.println("debug:    qtepData"    +(List<Map<String, String>>)param.get("qtepData"));           
//		System.out.println("debug:    rqepData"    +(List<Map<String, String>>)param.get("rqepData"));               
//		System.out.println("debug:    rqpfData"    +(List<Map<String, String>>)param.get("rqpfData"));
		
		
		List<Map<String, String>> qthdData     = (List<Map<String, String>>)param.get("qthdData");
		List<Map<String, String>> qtdtData     = (List<Map<String, String>>)param.get("qtdtData");
		List<Map<String, String>> rqdtData     = (List<Map<String, String>>)param.get("rqdtData");
		List<Map<String, String>> delQtdtData  = (List<Map<String, String>>)param.get("delQtdtData");
		List<Map<String, String>> delQtepData  = (List<Map<String, String>>)param.get("delQtepData");
		List<Map<String, String>> delQtpfData  = (List<Map<String, String>>)param.get("delQtpfData");
		List<Map<String, String>> rqseData     = (List<Map<String, String>>)param.get("rqseData");
		List<Map<String, String>> qtepData     = (List<Map<String, String>>)param.get("qtepData");
		List<Map<String, String>> rqepData     = (List<Map<String, String>>)param.get("rqepData");
		List<Map<String, String>> rqpfData     = (List<Map<String, String>>)param.get("rqpfData");
		

		int	                      rqdt         = 0;
		
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
    	
		try {  
		
			String yn = et_getYN(RFQ_NO, RFQ_COUNT);		//견적 마감일 체크
		
			SepoaFormater wf = new SepoaFormater(yn);  
			String tmp = wf.getValue(0,0); // 견적마감일 체크 
		
//마감 조건이 맞지 않음. 체크필요 
			/*if(Integer.parseInt(tmp) == 0) {  
				setMessage(msg.getMessage("0005"));  
				setStatus(3);  
				return getSepoaOut();	  
			}  */

			
			rtn = setUpdate_qtHD_UP(ctx, qthdData);  
			rtn = setDelQTDT(ctx, delQtdtData);
			rtn = setInsert_qtDT(ctx, qtdtData);
			rtn = setDelQTEP(ctx, delQtepData);
			
			if (JSPUtil.nullToRef(PRE_SEND_FLAG,"").equals("N") && send_flag.equals("Y")) {
				
				rtn = setUpdate_rqhd_bid(ctx,info.getSession("HOUSE_CODE"),RFQ_NO,RFQ_COUNT);
				rtn = setUpdate_rqdt_bid(ctx, rqdtData);  
				rtn = setUpdate_rqse_con_new(ctx, info.getSession("COMPANY_CODE"), rqseData);  		//WORK 필요
			}
			if(qtepData.size() > 0) {
				rtn = set_qtEP_01(ctx, qtepData);  
			}
			
			
			if(rqepData.size() > 0) {
				Logger.debug.println(info.getSession("ID"),this,"rqepData==============>" + rqepData.size());  
				ep_setCostUpdate(ctx, rqepData);
			}
			
			
			//ICOYQTPF 테이블 없음
			//System.out.println("debug:s2021:704"+qtpfData.size()+"||"+delQtpfData.size());
			/*if(qtpfData.size() > 0) {
				Logger.debug.println(info.getSession("ID"),this,"delQtpfData==============>" + delQtpfData.size());  
				rtn = setDelQTPF(ctx, delQtpfData);
				Logger.debug.println(info.getSession("ID"),this,"qtpfData==============>" + qtpfData.size());  
				rtn = setProfile(ctx, qtpfData);
			}*/
			
			setStatus(1);  
//			msg.setArg("QTA_NO", QTA_NO);  
//			setMessage(msg.getMessage("0002"));  

			String send_msg = "견적서 번호 " + QTA_NO + " 가 작성되었습니다.";
			if (send_flag.equals("Y")) {
				send_msg = "견적서 번호 " + QTA_NO + " 가 제출되었습니다.";
			}
			setMessage(send_msg);

			Commit();  
		
		} catch(Exception e) {  
			try{  
				Rollback();  
			}catch(Exception e1){ setFlag(false); setStatus(0); }  
			setFlag(false);
			setStatus(0);  
			setMessage(msg.getMessage("0012")); 
		}  
	
		return getSepoaOut();  
	}
      
    
    private int setDelQTEP(ConnectionContext ctx,
			List<Map<String, String>> delQtepData)throws Exception { 
    	
    	int	rtn	= 0; 
    		
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		
		try{ 
		
			/*String[] type =	{ "S","S","S" }; */
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
			rtn	= sm.doInsert(delQtepData); 
		
		}catch(Exception e)	{ 
		//Logger.err.println(info.getSession("ID"),this,stackTrace(e)); 
			throw new Exception(e.getMessage()); 
		} 
		return rtn; 
    	
	}

	private String et_getYN(String RFQ_NO, String RFQ_COUNT) throws Exception  
    {  
        String rtn = "";  
        ConnectionContext ctx = getConnectionContext();  
        Map<String, String> param = new HashMap<String, String>();
        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
        try{  
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
//            String[] data = {info.getSession("HOUSE_CODE"), RFQ_NO, RFQ_COUNT};
            param.put("RFQ_NO"    , RFQ_NO);
            param.put("RFQ_COUNT" , RFQ_COUNT);
            rtn = sm.doSelect(param);  
        }catch(Exception e) {  
           //Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
            throw new Exception(e.getMessage());  
        }  
        return rtn;  
    }
    
    //ICOYQTDT
    private String et_getCreateFlag(String RFQ_NO, String RFQ_COUNT, String RFQ_SEQ) throws Exception  
    {  
        String rtn = "";  
        ConnectionContext ctx = getConnectionContext();  
        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
        Map<String, String> param = new HashMap<String, String>();
   	  	 
        try{  
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
            
//            String[] data = {info.getSession("HOUSE_CODE")
//            				, RFQ_NO
//            				, RFQ_SEQ
//            				, RFQ_COUNT
//            				, info.getSession("COMPANY_CODE")
//            				, info.getSession("HOUSE_CODE")
//            				, RFQ_NO
//            				, RFQ_COUNT};
            param.put("RFQ_NO"   , RFQ_NO);
            param.put("RFQ_SEQ"  , RFQ_SEQ);
            param.put("RFQ_COUNT", RFQ_COUNT);
            param.put("VENDOR_CODE", info.getSession("COMPANY_CODE"));
            
            rtn = sm.doSelect(param);  
        }catch(Exception e) {  
            //Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
            throw new Exception(e.getMessage());  
        }  
        return rtn;  
    }
 
    /**
     * 견적서 마스터 정보 입력(ICOYQTHD)
     * @method setInsert_qtHD
     * @since  2014-10-08
     * @modify 2014-10-08
     * @param header
     * @return Map
     * @throws Exception
     */
	 private int setInsert_qtHD(ConnectionContext ctx, List<Map<String, String>> qthdData) throws Exception{  
		
		SepoaXmlParser      wxp          = null;
		SepoaSQLManager     sm           = null;
		Map<String, String> qthdDataInfo = null;
		int	                rtn          = 0; 
		int                 i            = 0;
		int                 qthdDataSize = qthdData.size();

		try{  
		
			
			
			for(i = 0; i < qthdDataSize; i++){
				
				wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()); 
				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
				
				qthdDataInfo = qthdData.get(i);
				rtn          = sm.doInsert(qthdDataInfo);
			}
			
		}catch(Exception e) {  
			
			Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		}  
		return rtn;  
	}
	 
	   /**
	     * 견적서 상세 정보 입력(ICOYQTDT)
	     * @method setInsert_qtDT
	     * @since  2014-10-08
	     * @modify 2014-10-08
	     * @param header
	     * @return Map
	     * @throws Exception
	     */
		@SuppressWarnings("deprecation")
		private int setInsert_qtDT(ConnectionContext ctx, List<Map<String, String>> qtdtData) throws Exception{  

			SepoaXmlParser      wxp          = null;
			SepoaSQLManager     sm           = null;
			Map<String, String> qtdtDataInfo = null;
			int	                rtn          = 0; 
			int                 i            = 0;
			int                 qtdtDataSize = qtdtData.size();
			

			try{  
			
				wxp =  new SepoaXmlParser(this,new Exception( ).getStackTrace()[0].getMethodName()); 

				for(i = 0; i < qtdtDataSize; i++){
					sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
					qtdtDataInfo = qtdtData.get(i);
					
					rtn          = sm.doInsert(qtdtDataInfo);
				}
			
			} catch(Exception e) {  
				
				Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
				throw new Exception(e.getMessage());  
			}  
			return rtn;  
		}
    

		/**
	     * 견적서 마스터 수정(ICOYRQHD)
	     * @method setUpdate_rqhd_bid
	     * @since  2014-10-08
	     * @modify 2014-10-08
	     * @param header
	     * @return Map
	     * @throws Exception
	     */		
		 private int setUpdate_rqhd_bid (ConnectionContext ctx,  
							             String HOUSE_CODE,  
							             String RFQ_NO,  
							             String RFQ_COUNT)  throws Exception {  
			int rtn = -1;  
			
			SepoaXmlParser wxp = null; 
			SepoaSQLManager sm = null;  
			Map<String, String> param = new HashMap<String, String>();
			
			try {  
				
				wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());

				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
				//String[][] setData = {{info.getSession("HOUSE_CODE"), RFQ_NO, RFQ_COUNT}};
				//String[] type = {"S", "S", "S"};
				param.put("RFQ_NO"    , RFQ_NO);
				param.put("RFQ_COUNT" , RFQ_COUNT);
				rtn = sm.doUpdate(param);  
			
			}catch(Exception e) {  
			//Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
				throw new Exception(e.getMessage());  
			}  
				return rtn;  
		}
		
		 /**
	     * 견적서 상세 수정(ICOYRQDT)
	     * @method setUpdate_rqdt_bid
	     * @since  2014-10-08
	     * @modify 2014-10-08
	     * @param header
	     * @return Map
	     * @throws Exception
	     */		
			private int setUpdate_rqdt_bid (ConnectionContext ctx, List<Map<String, String>> rqdtData)  throws Exception{  
				
				int rtn                          = -1;  
				SepoaXmlParser wxp               = null;
				SepoaSQLManager sm               = null;
				
				Map<String, String> rqdtDataInfo = null;
				
				
				
				try {  
					
					for(int i = 0; i < rqdtData.size() ; i++){
						wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
						sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
						
						
						rqdtDataInfo = rqdtData.get(i);
						rtn	= sm.doUpdate(rqdtDataInfo);
					}
					
					//String[] type = {"S", "S", "N", "S"};
					//rtn = sm.doUpdate(rqdtData);  
				}catch(Exception e) {  
					
					//Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
					throw new Exception(e.getMessage());  
				}  
				return rtn;  
			}				
		
			/**
		     * 
		     * @method setUpdate_qtHD_UP
		     * @since  2014-10-08
		     * @modify 2014-10-08
		     * @param header
		     * @return Map
		     * @throws Exception
		     */	
		    private	int	setUpdate_qtHD_UP(	ConnectionContext ctx, 
					List<Map<String, String>> qthdData)throws	Exception{ 
				int	rtn	= 0; 
				
				
				try{ 
				
					SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
					rtn	= sm.doUpdate(qthdData); 
					
					}catch(Exception e)	{ 
						Logger.err.println(info.getSession("ID"),this,stackTrace(e)); 
						throw new Exception(e.getMessage()); 
					} 
					
					return rtn; 
				}

		    /**
		     * 
		     * @method setDelQTDT
		     * @since  2014-10-08
		     * @modify 2014-10-08
		     * @param header
		     * @return Map
		     * @throws Exception
		     */   
		private	int	setDelQTDT(	ConnectionContext ctx, List<Map<String, String>> delQtdtData)throws Exception{ 
			
			int	rtn	= 0; 

			SepoaXmlParser wxp               = null;
			SepoaSQLManager sm               = null;
			
			Map<String, String> qtdtDataInfo = null;
			
			try{ 
				for(int i = 0; i < delQtdtData.size() ; i++){
					wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
					sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
					
					
					qtdtDataInfo = delQtdtData.get(i);
					rtn	= sm.doUpdate(qtdtDataInfo);
				}
			
			}catch(Exception e)	{ 
				//Logger.err.println(info.getSession("ID"),this,stackTrace(e)); 
				throw new Exception(e.getMessage()); 
			} 
				return rtn; 
		}
		
			
		/**
	     * ICOYQTPF 테이블 없음.
	     * @method setDelQTPF
	     * @since  2014-10-08
	     * @modify 2014-10-08
	     * @param header
	     * @return Map
	     * @throws Exception
	     */
		private	int	setDelQTPF(	ConnectionContext ctx, List<Map<String, String>> delQtpfData)throws Exception{ 
			int	rtn	= 0; 
						
			SepoaXmlParser wxp               = null;
			SepoaSQLManager sm               = null;
			
			Map<String, String> qtpfDataInfo = null;
			
			try{ 
				for(int i = 0; i < delQtpfData.size() ; i++){
					wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
					sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
					
					
					qtpfDataInfo = delQtpfData.get(i);
					rtn	= sm.doDelete(qtpfDataInfo);
				}
			}catch(Exception e)	{ 
			//Logger.err.println(info.getSession("ID"),this,stackTrace(e)); 
				throw new Exception(e.getMessage()); 
			} 
				return rtn; 
		}


		
		/**
	     * 견적서 진행현황 조회
	     * @method getCurrentQtaList
	     * @since  2014-10-08
	     * @modify 2014-10-08
	     * @param start_date, end_date, status, settle_type, subject, bid_rfq_type
	     * @return Map
	     * @throws Exception
	     */
	    public SepoaOut getCurrentQtaList(Map<String, String> header) {  
	    	try	{  
				String rtn = "";  
	  
				//Query 수행부분 Call  
	            //create_type 에 상관없이 조회 
				rtn	= et_getCurrentQtaList(header);  
					
				setValue(rtn);  
				setStatus(1);  
	  
			}catch (Exception e){  
				Logger.err.println(info.getSession("ID"),this,"Exception e ==============>"	+ e.getMessage());  
				setMessage(msg.getMessage("0001"));  
				setStatus(0);  
			}  
			return getSepoaOut();  
	    	
	    }  
	  
	    /**
	     * 견적서 진행현황 조회
	     * @method et_getCurrentQtaList
	     * @since  2014-10-08
	     * @modify 2014-10-08
	     * @param header
	     * @return Map
	     * @throws Exception
	     */
	    private String et_getCurrentQtaList(Map<String, String> header) throws Exception  
	    {  
	    	
			
			String rtn = "";  
			ConnectionContext ctx =	getConnectionContext();  
			String cur_date_time = SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4);
			
			try	{  
				
				SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("status", header.get("status"));
				header.put("cur_date_time", cur_date_time);
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
				
				rtn	= sm.doSelect(header);  
	  
				if(rtn == null)	throw new Exception("SQL Manager is	Null");  
			}catch(Exception e)	{  
			  throw	new	Exception("et_getQuery_New_Rfq_List=========>"+e.getMessage());  
			} finally{  
			}  
			return rtn; 
	    	
	    	
	    }
	    

	    
	    /**
	     * 견적서 결과현황 조회
	     * @method getCompanyQtaList
	     * @since  2014-10-08
	     * @modify 2014-10-08
	     * @param header
	     * @return Map
	     * @throws Exception
	     */ 
	  		public SepoaOut getCompanyQtaList(Map<String, String> data) {  
		        try {  
		            String rtn = "";  
		  
		            //Query 수행부분 Call  
		            //create_type 에 상관없이 조회 
		            rtn = et_getCompanyQtaList(data);  
		  
					SepoaFormater wf = new SepoaFormater(rtn);
					if(wf.getRowCount() == 0) setMessage(msg.getMessage("0011"));
					else {
						setMessage(msg.getMessage("0003"));
					}
		              
		            setValue(rtn);  
		            setStatus(1);  
		        }catch (Exception e){  
		            //Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + stackTrace(e));  
		            setMessage(msg.getMessage("0004"));  
		            setStatus(0);  
		        }  
		        return getSepoaOut();  
	  		}
	  	 
	  		/**
		     * 견적서 결과현황 쿼리
		     * @method et_getCompanyQtaList
		     * @since  2014-10-08
		     * @modify 2014-10-08
		     * @param header
		     * @return Map
		     * @throws Exception
		     */  
	  		private	String et_getCompanyQtaList(Map<String, String> data) throws Exception  
		    {  
		    	String rtn = "";  
				ConnectionContext ctx =	getConnectionContext();  
				String cur_date_time = SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4);
		        
		        try {  
		        	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		        	//wxp.addVar("status", status);
		        	data.put("cur_date_time", cur_date_time);
		        	
		        	
		            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
		            rtn	= sm.doSelect(data); 
					
		            if(rtn == null) throw new Exception("SQL Manager is Null");  
		        }catch(Exception e) {  
		            throw new Exception("et_getCurrentQtaList=========>"+e.getMessage());  
		        } finally{  
		        }  
		        return rtn;  
	  		}
	  		
	  		
	  		//견적서 결과팝업조회  
	  	    public SepoaOut getCompanyQtaListPopup(String vendor_code, String rfq_no, String rfq_count) {  
	  	        try {  
	  	            String rtn = "";  

	  	            rtn = et_getCompanyQtaListPopup(vendor_code, rfq_no, rfq_count);  
	  	            
	  				SepoaFormater wf = new SepoaFormater(rtn);
	  				if(wf.getRowCount() == 0) setMessage(msg.getMessage("0011"));
	  				else {
	  					setMessage(msg.getMessage("0003"));
	  				}
	  	            setValue(rtn);  
	  	            setStatus(1);  
	  	        }catch (Exception e){  
	  	          //  Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + stackTrace(e));  
	  	            setMessage(msg.getMessage("0004"));  
	  	            setStatus(0);  
	  	        }  
	  	        return getSepoaOut();  
	  	    }  
	  	  
	  	    private String et_getCompanyQtaListPopup(String vendor_code, String rfq_no, String rfq_count) throws Exception  
	  	    {  
	  	        String rtn = "";  
	  	        ConnectionContext ctx = getConnectionContext();  
	  	  
	  	        try {  
	  	        	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
	  	            
	  	        	
	  	           /* sql.append(" SELECT                                                              \n");
	  	            sql.append("          QT.ITEM_NO                                                 \n");
	  	            sql.append("         ,GETITEMDESC(QT.HOUSE_CODE, QT.ITEM_NO) AS DESCRIPTION_LOC  \n");                
	  	            sql.append("         ,GETITEMSPEC(QT.HOUSE_CODE, QT.ITEM_NO) AS SPECIFICATION    \n");
	  	            sql.append("         ,QT.UNIT_MEASURE                                            \n");
	  	            sql.append("         ,QT.SETTLE_QTY                                              \n");
	  	            sql.append("         ,QT.QUOTA_PERCENT                                           \n");
	  	            sql.append("         ,QT.UNIT_PRICE                                              \n");
	  	            sql.append("         ,QT.ITEM_AMT                                                \n");
	  	            sql.append(" FROM   ICOYRQDT RQ, ICOYQTDT QT                                     \n");
	  	            sql.append(" WHERE  QT.HOUSE_CODE  = RQ.HOUSE_CODE                               \n");
	  	            sql.append(" AND    QT.RFQ_NO      = RQ.RFQ_NO                                   \n");
	  	            sql.append(" AND    QT.RFQ_SEQ     = RQ.RFQ_SEQ                                  \n");
	  	            sql.append(" AND    QT.RFQ_COUNT   = RQ.RFQ_COUNT                                \n");
	  	            sql.append(" <OPT=S,S> AND    RQ.HOUSE_CODE  = ? </OPT>                          \n");
	  	            sql.append(" <OPT=S,S> AND    RQ.RFQ_NO      = ? </OPT>                          \n");
	  	            sql.append(" <OPT=S,N> AND    RQ.RFQ_COUNT   = ? </OPT>                          \n");
	  	            sql.append(" <OPT=S,S> AND    QT.VENDOR_CODE = ? </OPT>                          \n");
	  	            sql.append(" AND    RQ.STATUS IN ('C', 'R')                                      \n");
	  	            sql.append(" AND    QT.STATUS IN ('C', 'R')                                      \n");
	  	            sql.append(" AND    QT.SETTLE_DATE IS NOT NULL                                   \n");
	  	  */
	  	  			
	  	            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	  	            String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count, vendor_code};
	  	            rtn = sm.doSelect(data);  
	  	  
	  	            if(rtn == null) throw new Exception("SQL Manager is Null");  
	  	        }catch(Exception e) {  
	  	            throw new Exception("et_getCompanyQtaListPopup=========>"+e.getMessage());  
	  	        } finally{  
	  	        }  
	  	        return rtn;  
	  	    }  	    
	    
	  	    
	  	  /**
		     * 견적서 생성 HD 조회
		     * @method getQuery_Cre_Qta_Header
		     * @since  2014-10-08
		     * @modify 2014-10-08
		     * @param header
		     * @return Map
		     * @throws Exception
		     */  
	  	  public SepoaOut getQuery_Cre_Qta_Header(String RFQ_NO,String RFQ_COUNT,String VENDOR_CODE)  
	      {  
	          try {  
	              String rtn = "";  
	    
	              rtn = et_getQuery_Cre_Qta_Header(RFQ_NO, RFQ_COUNT, VENDOR_CODE);  
	    
	              setValue(rtn);  
	              setStatus(1);  
	          }catch (Exception e){  
	              //Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + stackTrace(e));  
	              setStatus(0);  
	          }  
	          return getSepoaOut();  
	      }  
	    
	      private String et_getQuery_Cre_Qta_Header(String RFQ_NO,String RFQ_COUNT,String VENDOR_CODE) throws Exception  
	      {  

	          String rtn = "";  
	    
	          ConnectionContext ctx = getConnectionContext();  
	          try {  
	          		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
	          		wxp.addVar("VENDOR_CODE", info.getSession("COMPANY_CODE"));
	                  SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
	    
	                  String[] args = {VENDOR_CODE, info.getSession("HOUSE_CODE"), RFQ_NO, RFQ_COUNT};  
	                  rtn = sm.doSelect(args);  
	    
	                  if(rtn == null) throw new Exception("SQL Manager is Null");  
	              }catch(Exception e) {  
	                  throw new Exception("et_getQuery_Cre_Qta_Header=========>"+e.getMessage());  
	              } finally{  
	          }  
	          return rtn;  
	      }	    
	    
	    
	    
	    
	/*
    //견적서 현황조회  
    public SepoaOut getCurrentQtaList(String start_date
    								, String end_date 
    								, String status
    								, String settle_type
    								, String subject
    								, String bid_rfq_type
    								, String create_type) {  
        try {  
            String rtn = new String();  
  
            //Query 수행부분 Call  
            //create_type 에 상관없이 조회 
            rtn = et_getCurrentQtaList(start_date, end_date, status, settle_type, subject, bid_rfq_type, "");  
  
			SepoaFormater wf = new SepoaFormater(rtn);
			if(wf.getRowCount() == 0) setMessage(msg.getMessage("0011"));
			else {
				setMessage(msg.getMessage("0003"));
			}
              
            setValue(rtn);  
            setStatus(1);  
        }catch (Exception e){  
            //Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + stackTrace(e));  
            setMessage(msg.getMessage("0004"));  
            setStatus(0);  
        }  
        return getSepoaOut();  
    }  
  
    private String et_getCurrentQtaList(String start_date
										, String end_date 
										, String status
										, String settle_type
										, String subject
										, String bid_rfq_type
    									, String create_type) throws Exception  
    {  
        String rtn = new String();  
        ConnectionContext ctx = getConnectionContext();  

        String cur_date_time        = SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4);
        
        try {  
        	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
        	wxp.addVar("status", status);
        	
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
  
            if(status.equals("N")) {
	            String[] args = {cur_date_time, cur_date_time, info.getSession("HOUSE_CODE"), info.getSession("COMPANY_CODE")
	            				,create_type , start_date, end_date,  settle_type, subject, bid_rfq_type};  
	            rtn = sm.doSelect(args);  
            } else if(status.equals("P")) {
            	String[] args = {cur_date_time, cur_date_time, info.getSession("HOUSE_CODE"), info.getSession("COMPANY_CODE")
        						,create_type , start_date, end_date,  settle_type, subject, cur_date_time, bid_rfq_type};  
            	rtn = sm.doSelect(args);  
            } else if(status.equals("C")) {
            	String[] args = {cur_date_time, cur_date_time, info.getSession("HOUSE_CODE"), info.getSession("COMPANY_CODE")
        						,create_type , start_date, end_date,  settle_type, subject, cur_date_time, bid_rfq_type};  
            	rtn = sm.doSelect(args);            	
            } else {
            	String[] args = {cur_date_time, cur_date_time, info.getSession("HOUSE_CODE"), info.getSession("COMPANY_CODE")
            					,create_type , start_date, end_date,  settle_type, subject, bid_rfq_type};  
            	rtn = sm.doSelect(args);  
            }
            if(rtn == null) throw new Exception("SQL Manager is Null");  
        }catch(Exception e) {  
            throw new Exception("et_getCurrentQtaList=========>"+e.getMessage());  
        } finally{  
        }  
        return rtn;  
    }
    
    
    
    
    public SepoaOut getQuery_Upd_Qta_Detail_Qta(String VENDOR_CODE, String QTA_NO,String GROUP_YN)  
    {  
        String rtn = new String();  
  
        ConnectionContext ctx = getConnectionContext();  
  
        try {  
        	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
        	wxp.addVar("GROUP_YN", GROUP_YN);
        	
        	
            if ("Y".equals(GROUP_YN)) {
            	sql.append(" SELECT                                                   \n");
            	sql.append("  ITEM_NO                                                 \n");
            	sql.append(" ,SPECIFICATION           SPECIFICATION              	  \n");
            	sql.append(" ,DESCRIPTION_LOC       DESCRIPTION_LOC            		  \n");
            	sql.append(" ,SUM(RFQ_QTY                ) RFQ_QTY                    \n");
            	sql.append(" ,SUM(ITEM_QTY               ) ITEM_QTY                   \n");
            	sql.append(" ,MAX(VENDOR_ITEM_NO         ) VENDOR_ITEM_NO             \n");
            	sql.append(" ,MAX(UNIT_MEASURE           ) UNIT_MEASURE               \n");
            	sql.append(" ,MAX(CUSTOMER_PRICE         ) CUSTOMER_PRICE             \n");
            	sql.append(" ,MAX(UNIT_PRICE             ) UNIT_PRICE                 \n");
            	sql.append(" ,MAX(UNIT_PRICE_IMG         ) UNIT_PRICE_IMG             \n");
            	sql.append(" ,MAX(BEFORE_PRICE           ) BEFORE_PRICE               \n");
            	sql.append(" ,SUM(ITEM_AMT               ) ITEM_AMT                   \n");
            	sql.append(" ,MAX(DELIVERY_LT            ) DELIVERY_LT                \n");
            	sql.append(" ,MAX(RD_DATE                ) RD_DATE                    \n");
            	sql.append(" ,MAX(DELY_TO_LOCATION_NAME  ) DELY_TO_LOCATION_NAME      \n");
            	sql.append(" ,MAX(YEAR_QTY               ) YEAR_QTY                   \n");
            	sql.append(" ,MAX(QTA_ATTACH_NO          ) QTA_ATTACH_NO              \n");
            	sql.append(" ,MAX(QTA_ATTACH_CNT         ) QTA_ATTACH_CNT             \n"); 
            	sql.append(" ,MAX(RFQ_ATTACH_NO          ) RFQ_ATTACH_NO              \n");
            	sql.append(" ,MAX(RFQ_ATTACH_CNT         ) RFQ_ATTACH_CNT             \n");  
            	sql.append(" ,MAX(PURCHASER              ) PURCHASER                  \n");
            	sql.append(" ,MAX(PURCHASER_PHONE        ) PURCHASER_PHONE            \n");
            	sql.append(" ,MAX(SHIPPER_TYPE           ) SHIPPER_TYPE               \n");
            	sql.append(" ,MAX(MOLDING_CHARGE         ) MOLDING_CHARGE             \n");
            	sql.append(" ,MAX(COST_COUNT             ) COST_COUNT                 \n");
            	sql.append(" ,MAX(MOLDING_FLAG           ) MOLDING_FLAG               \n");
            	sql.append(" ,MAX(EP_FROM_DATE           ) EP_FROM_DATE               \n");
            	sql.append(" ,MAX(EP_TO_DATE             ) EP_TO_DATE                 \n");
            	sql.append(" ,MAX(EP_FROM_QTY            ) EP_FROM_QTY                \n");
            	sql.append(" ,MAX(EP_TO_QTY              ) EP_TO_QTY                  \n");
            	sql.append(" ,MAX(EP_UNIT_PRICE          ) EP_UNIT_PRICE              \n");
            	sql.append(" ,MAX(QTA_NO                 ) QTA_NO                     \n");
            	sql.append(" ,MAX(QTA_SEQ                ) QTA_SEQ                    \n");
            	sql.append(" ,MAX(MAKER_CODE             ) MAKER_CODE                 \n");
            	sql.append(" ,MAX(MAKER_NAME             ) MAKER_NAME                 \n");
            	sql.append(" ,MAX(DELY_TO_LOCATION       ) DELY_TO_LOCATION           \n");
           		sql.append(" ,MAX(RFQ_NO                 ) RFQ_NO                     \n");
            	sql.append(" ,MAX(RFQ_COUNT              ) RFQ_COUNT                  \n");
            	sql.append(" ,MAX(RFQ_SEQ                ) RFQ_SEQ                    \n"); 
            	sql.append(" ,MAX(MOLDING_PROSPECTIVE_QTY) MOLDING_PROSPECTIVE_QTY    \n");
            	sql.append(" ,MAX(CUR) CUR    										  \n");
            	sql.append(" ,MAX(CUSTOMER_PRICE) CUSTOMER_PRICE    				  \n");
            	sql.append(" ,MAX(TECHNIQUE_GRADE)	 TECHNIQUE_GRADE	  			  \n");     
            	sql.append(" ,MAX(TECHNIQUE_FLAG) 	 TECHNIQUE_FLAG 	  			  \n");      
            	sql.append(" ,MAX(TECHNIQUE_TYPE) 	 TECHNIQUE_TYPE 	  			  \n");     
            	sql.append(" ,MAX(INPUT_FROM_DATE)	 INPUT_FROM_DATE	  			  \n");     
            	sql.append(" ,MAX(INPUT_TO_DATE )	 INPUT_TO_DATE 	  				  \n");     
				sql.append(" ,MAX(REMARK )	 REMARK 	  							  \n");      
	            sql.append(" ,MAX(HUMAN_NAME_LOC       )  HUMAN_NAME_LOC              \n");  
	            sql.append(" ,MAX(DISCOUNT) DISCOUNT       							  \n");  

            	sql.append(" FROM ( ");
            }
            
            sql.append("  SELECT \n");
            sql.append("        DBO.CNV_NULL(QD.ITEM_NO,RD.ITEM_NO) AS ITEM_NO,                                                          \n");
            sql.append(" 		 CASE WHEN RD.ITEM_NO IS NULL THEN      									\n");
			sql.append(" 				(SELECT DESCRIPTION_LOC FROM ICOYPRDT      							\n");
			sql.append(" 		 		  WHERE HOUSE_CODE = RD.HOUSE_CODE      							\n");
			sql.append(" 		 		  AND PR_NO = RD.PR_NO AND PR_SEQ = RD.PR_SEQ )      				\n");
			sql.append(" 		  ELSE (SELECT DESCRIPTION_LOC FROM ICOMMTGL      							\n");
			sql.append(" 		 		  WHERE HOUSE_CODE = RD.HOUSE_CODE      							\n");
			sql.append(" 		 		  AND   ITEM_NO    = RD.ITEM_NO) END AS DESCRIPTION_LOC,      		\n");
            //sql.append("        DBO.CNV_NULL(GETITEMSPEC(QD.HOUSE_CODE, QD.ITEM_NO),GETITEMSPEC(RD.HOUSE_CODE, RD.ITEM_NO)) AS SPECIFICATION,                     \n"); 
            sql.append("		RD.SPECIFICATION AS SPECIFICATION,   										\n");
            sql.append("        RD.RFQ_QTY                                                AS RFQ_QTY,                                                         \n");
            sql.append("        DBO.CNV_NULL(QD.ITEM_QTY,RD.RFQ_QTY)                          AS ITEM_QTY,                                                        \n");
            sql.append("        DBO.CNV_NULL(QD.VENDOR_ITEM_NO,'')                            AS VENDOR_ITEM_NO,                                                  \n");
            sql.append("        DBO.CNV_NULL(QD.UNIT_MEASURE,RD.UNIT_MEASURE)                 AS UNIT_MEASURE,                                                    \n");
            sql.append("        DBO.CNV_NULL(QD.CUSTOMER_PRICE,'')                            AS CUSTOMER_PRICE,                                                      \n");
            sql.append("        DBO.CNV_NULL(QD.UNIT_PRICE,'')                                AS UNIT_PRICE,                                                      \n");
            sql.append("       (CASE                                                                                                                          \n");
            sql.append(" 		   WHEN DBO.CNV_NULL(RH.PRICE_TYPE,'N') = 'N' THEN 'N'                                                                             \n");
            sql.append(" 		   ELSE RH.PRICE_TYPE                                                                                                          \n");
            sql.append("        END                                                                                                                           \n");
            sql.append("        )                                                          AS UNIT_PRICE_IMG,                                                  \n");
            sql.append("        DBO.GETBEFOREQTADATA(RD.HOUSE_CODE, RD.RFQ_NO, RH.RFQ_COUNT, RD.RFQ_SEQ, RS.VENDOR_CODE, 'UNIT_PRICE')  AS BEFORE_PRICE,          \n");
            sql.append("        QD.ITEM_AMT                                               AS ITEM_AMT,                                                        \n");
            sql.append("        DBO.CNV_NULL(QD.DELIVERY_LT,'')                               AS DELIVERY_LT,                                                     \n");
            sql.append("        RD.RD_DATE                                                AS RD_DATE,                                                         \n");
            sql.append("       (CASE                                                                                                                          \n");
            sql.append("             WHEN RD.STR_FLAG = 'S' THEN DBO.GETSTORAGENAME(RD.HOUSE_CODE, RD.COMPANY_CODE, RD.PLANT_CODE, RD.DELY_TO_LOCATION, 'LOC' )   \n");
            sql.append("             WHEN RD.STR_FLAG = 'D' THEN DBO.GETDEPTNAME(RD.HOUSE_CODE, RD.COMPANY_CODE, RD.DELY_TO_LOCATION, 'LOC' )                     \n");
            sql.append("             ELSE RD.DELY_TO_LOCATION                                                                                                 \n");
            sql.append("        END                                                                                                                           \n");
            sql.append("        )                                                         AS DELY_TO_LOCATION_NAME,                                           \n");
            sql.append("        DBO.CNV_NULL(RD.YEAR_QTY,'')                                  AS YEAR_QTY,                                                        \n");
            sql.append("       (CASE                                                                                                                          \n");
            sql.append(" 		   WHEN DBO.CNV_NULL(QD.ATTACH_NO,'N') = 'N' THEN 'N'                                                                             \n");
            sql.append(" 		   ELSE QD.ATTACH_NO                                                                                                          \n");
            sql.append("        END                                                                                                                           \n");
            sql.append("        )                                                          AS QTA_ATTACH_NO,                                                  \n");
            sql.append("       (CASE                                                                                                                          \n");
            sql.append(" 		   WHEN DBO.CNV_NULL(QD.ATTACH_NO,'N') = 'N' THEN '0'                                                                             \n");
            sql.append(" 		   ELSE CAST((SELECT COUNT(*) FROM ICOMATCH WHERE DOC_NO = QD.ATTACH_NO) AS VARCHAR)                                                 \n");
            sql.append("        END                                                                                                                           \n");
            sql.append("        )                                                          AS QTA_ATTACH_CNT,                                                 \n");
            sql.append("       (CASE                                                                                                                          \n");
            sql.append(" 		   WHEN DBO.CNV_NULL(RD.ATTACH_NO,'N') = 'N' THEN 'N'                                                                             \n");
            sql.append(" 		   ELSE RD.ATTACH_NO                                                                                                          \n");
            sql.append("        END                                                                                                                           \n");
            sql.append("        )                                                          AS RFQ_ATTACH_NO,                                                  \n");
            sql.append("       (CASE                                                                                                                          \n");
            sql.append(" 		   WHEN DBO.CNV_NULL(RD.ATTACH_NO,'N') = 'N' THEN '0'                                                                             \n");
            sql.append(" 		   ELSE CAST((SELECT COUNT(*) FROM ICOMATCH WHERE DOC_NO = RD.ATTACH_NO) AS VARCHAR)                                                  \n");
            sql.append("        END                                                                                                                           \n");
            sql.append("        )                                                     AS RFQ_ATTACH_CNT,                                                      \n");
            sql.append("        DBO.GETUSERNAME(RD.HOUSE_CODE, RD.CHANGE_USER_ID, 'LOC')  AS PURCHASER,                                                           \n");
            sql.append("        DBO.GETADDRATTR(RD.HOUSE_CODE, RD.CHANGE_USER_ID, '3', 'PHONE_NO1') AS PURCHASER_PHONE,                                           \n");
            sql.append("        RD.SHIPPER_TYPE                                       AS SHIPPER_TYPE,                                                        \n");
            sql.append("        DBO.CNV_NULL(QD.MOLDING_CHARGE,'')                        AS MOLDING_CHARGE,                                                      \n");
            sql.append("        RD.COST_COUNT                                         AS COST_COUNT,                                                          \n");
            sql.append("        QD.MOLDING_FLAG                                       AS MOLDING_FLAG,                                                        \n");
            sql.append("        DBO.GETRQEPDATADISP(QD.HOUSE_CODE, QD.QTA_NO, QD.QTA_SEQ, QD.VENDOR_CODE, 'F_DATE')  AS EP_FROM_DATE,                             \n");
            sql.append("        DBO.GETRQEPDATADISP(QD.HOUSE_CODE, QD.QTA_NO, QD.QTA_SEQ, QD.VENDOR_CODE, 'T_DATE')  AS EP_TO_DATE,                               \n");
            sql.append("        DBO.GETRQEPDATADISP(QD.HOUSE_CODE, QD.QTA_NO, QD.QTA_SEQ, QD.VENDOR_CODE, 'F_QTY')  AS EP_FROM_QTY,                               \n");
            sql.append("        DBO.GETRQEPDATADISP(QD.HOUSE_CODE, QD.QTA_NO, QD.QTA_SEQ, QD.VENDOR_CODE, 'T_QTY')  AS EP_TO_QTY,                                 \n");
            sql.append("        DBO.GETRQEPDATADISP(QD.HOUSE_CODE, QD.QTA_NO, QD.QTA_SEQ, QD.VENDOR_CODE, 'UNIT_PRICE')  AS EP_UNIT_PRICE,                        \n");
            sql.append("        CASE DBO.CNV_NULL(QD.QTA_NO,'') WHEN '' THEN '' ELSE QD.QTA_NO end        AS QTA_NO,                                                              \n");
            sql.append("        CASE DBO.CNV_NULL(QD.QTA_SEQ,'') WHEN '' THEN '' ELSE QD.QTA_SEQ end     AS QTA_SEQ,                                                             \n");
            sql.append("        ''                                          		AS MAKER_CODE,                                                          \n");
            sql.append("        RD.MAKER_NAME                                         AS MAKER_NAME,                                                          \n");
            sql.append("        RD.DELY_TO_LOCATION                                   AS DELY_TO_LOCATION,                                                              \n");
            sql.append("        RD.RFQ_NO                                             AS RFQ_NO,                                                              \n");
            sql.append("        RD.RFQ_COUNT                                          AS RFQ_COUNT,                                                           \n");
            sql.append("        RD.RFQ_SEQ                                            AS RFQ_SEQ ,                                                            \n");
            sql.append("        QD.MOLDING_QTY                                        AS MOLDING_PROSPECTIVE_QTY,                                                              \n");            
            sql.append("        RH.CUR                                        		AS CUR      ,                                                        \n");            
            sql.append("        RD.TECHNIQUE_GRADE	                                          AS TECHNIQUE_GRADE	 ,                                                            \n");
            sql.append("        RD.TECHNIQUE_FLAG 	                                          AS TECHNIQUE_FLAG 	 ,                                                            \n");
            sql.append("        RD.TECHNIQUE_TYPE 	                                          AS TECHNIQUE_TYPE 	 ,                                                            \n");
            sql.append("        RD.INPUT_FROM_DATE	                                          AS INPUT_FROM_DATE	 ,                                                            \n");
            sql.append("        RD.INPUT_TO_DATE 	                                          AS INPUT_TO_DATE 	  ,                                                           \n");
            sql.append("        QD.REMARK 	                                          AS REMARK ,	                                                             \n");
			sql.append("    	 (SELECT NAME_LOC FROM ICOMHUMT WHERE HOUSE_CODE = RD.HOUSE_CODE AND HUMAN_NO = RD.ITEM_NO AND STATUS != 'D') AS HUMAN_NAME_LOC	\n");
            sql.append("        ,DBO.CNV_NULL(QD.DISCOUNT,0) 	                                          AS DISCOUNT 	                                                             \n");
			
            sql.append("  FROM ICOYRQDT RD, ICOYPRDT PD, ICOYRQHD RH, ICOYQTHD QH, ICOYPRHD PH, ICOYQTDT QD RIGHT OUTER JOIN ICOYRQSE RS                                      \n");
            sql.append("  on RS.HOUSE_CODE   = QD.HOUSE_CODE                                                                                              \n");
            sql.append("  AND RS.RFQ_NO       = QD.RFQ_NO                                                                                                  \n");
            sql.append("  AND RS.RFQ_COUNT    = QD.RFQ_COUNT                                                                                               \n");
            sql.append("  AND RS.RFQ_SEQ      = QD.RFQ_SEQ                                                                                                 \n");
            sql.append("  AND RS.VENDOR_CODE  = QD.VENDOR_CODE   \n");
            sql.append("  and qd.status <> 'D' \n");
            sql.append("  WHERE  RH.STATUS  IN ('C', 'R')                                                                                                     \n");
            sql.append("  <OPT=S,S> AND QH.HOUSE_CODE   = ? </OPT>                                                                                            \n");
            sql.append("  <OPT=S,S> AND QH.QTA_NO       = ? </OPT>                                                                                            \n");
            sql.append("  <OPT=S,S> AND QH.VENDOR_CODE  = ? </OPT>                                                                                            \n");
            sql.append("  <OPT=S,S> AND RS.VENDOR_CODE  = ? </OPT>                                                                                            \n");
            sql.append("  AND QH.HOUSE_CODE   = RH.HOUSE_CODE                                                                                                 \n");
            sql.append("  AND QH.RFQ_NO       = RH.RFQ_NO                                                                                                     \n");
            sql.append("  AND QH.RFQ_COUNT    = RH.RFQ_COUNT                                                                                                  \n");
            sql.append("  AND QH.RFQ_COUNT    = RH.RFQ_COUNT                                                                                                  \n");
            sql.append("  AND RD.HOUSE_CODE   = RS.HOUSE_CODE                                                                                                 \n");
            sql.append("  AND RH.HOUSE_CODE   = RD.HOUSE_CODE                                                                                                 \n");
            sql.append("  AND RD.RFQ_NO       = RS.RFQ_NO                                                                                                     \n");
            sql.append("  AND RH.RFQ_NO       = RD.RFQ_NO                                                                                                     \n");
            sql.append("  AND RD.RFQ_COUNT    = RS.RFQ_COUNT                                                                                                  \n");
            sql.append("  AND RH.RFQ_COUNT    = RD.RFQ_COUNT                                                                                                  \n");
            sql.append("  AND RD.RFQ_SEQ      = RS.RFQ_SEQ                                                                                                    \n");
            sql.append("  AND RD.HOUSE_CODE   = PD.HOUSE_CODE                                                                                                 \n");
            sql.append("  AND RD.PR_NO        = PD.PR_NO                                                                                                      \n");
            sql.append("  AND RD.PR_SEQ       = PD.PR_SEQ                                                                                                     \n");
            
            sql.append("  AND PH.HOUSE_CODE   = PD.HOUSE_CODE                                                                                                 \n");
            sql.append("  AND PH.PR_NO        = PD.PR_NO                                                                                                      \n");
            //sql.append("  AND QD.STATUS(+) <> 'D'                                                                                                             \n");
            sql.append("  AND RH.RFQ_TYPE IN ('CL', 'OP')                                                                                                     \n");
            //sql.append("  AND RH.SIGN_STATUS  = 'E'                                                                                                           \n");
            sql.append("  AND RH.BID_TYPE     = 'RQ'                                                                                                          \n");
            //sql.append("  AND RH.CREATE_TYPE  IN ('PR','PC')                                                                                                    \n");
            sql.append("  AND DBO.CNV_NULL(RTRIM(LTRIM(RS.BID_FLAG)), 'Y') <> 'N'                                                                                         \n");
            sql.append("  AND RS.STATUS  IN ('C', 'R')                                                                                                        \n");
            sql.append("  AND RD.STATUS  IN ('C', 'R')                                                                                                        \n");
  
            
            if ("Y".equals(GROUP_YN)) {
            	sql.append(") GROUP BY ITEM_NO, SPECIFICATION , DESCRIPTION_LOC");
            }
            
            
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
            Logger.err.println(info.getSession("ID"),this,wxp.getQuery());  
  
            String[] args = {info.getSession("HOUSE_CODE"), QTA_NO, VENDOR_CODE, VENDOR_CODE};  
            rtn = sm.doSelect(args);  
  
            setValue(rtn);  
            setStatus(1);  
        }catch (Exception e){  
           // Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + stackTrace(e));  
            setStatus(0);  
        }  
        return getSepoaOut();  
    }
    
    
    public SepoaOut setUpdate_Qta_Upd(
    		  String pre_send_flag
    		, String send_flag
    		, String RFQ_NO
			, String RFQ_COUNT
			, String QTA_NO
			, String[][] qthdData
			, String[][] qtdtData
			, String[][] delQtdtData
			, String[][] delQtepData
			, String[][] delQtpfData
			, String[][] rqdtData
			, String[][] rqseData
			, String[][] qtepData
			, String[][] rqepData
			, String[][] qtpfData)  
	{ 
		int rtn = 0;  
		
		ConnectionContext ctx = getConnectionContext();  
	
		try {  
		
			String yn = et_getYN(RFQ_NO, RFQ_COUNT);
		
			SepoaFormater wf = new SepoaFormater(yn);  
			String tmp = wf.getValue(0,0); // 견적마감일 체크 
		
			if(Integer.parseInt(tmp) == 0) {  
				setMessage(msg.getMessage("0005"));  
				setStatus(3);  
				return getSepoaOut();	  
			}  
//ssjj 2
			rtn = setUpdate_qtHD_UP(ctx, qthdData);  
			rtn = setDelQTDT(ctx, delQtdtData);
			rtn = setInsert_qtDT(ctx, qtdtData);
			rtn = setDelQTEP(ctx, delQtepData);
		
			if ((pre_send_flag.equals("N")) && (send_flag.equals("Y"))) {
				rtn = setUpdate_rqhd_bid(ctx,info.getSession("HOUSE_CODE"),RFQ_NO,RFQ_COUNT);
				rtn = setUpdate_rqdt_bid(ctx, rqdtData);  
//				rtn = setUpdate_rqse_con(ctx, rqseData); 
				rtn = setUpdate_rqse_con_new(ctx, qthdData[0][4], rqseData);  
			}
	
			if(qtepData.length > 0) {
				rtn = set_qtEP_01(ctx, qtepData);  
			}

			if(rqepData.length > 0) {
				ep_setCostUpdate(ctx, rqepData);
			}
		
			if(qtpfData.length > 0) {
				rtn = setDelQTPF(ctx, delQtpfData);
				rtn = setProfile(ctx, qtpfData);
			}
		
			setStatus(1);  
//			msg.setArg("QTA_NO", QTA_NO);  
//			setMessage(msg.getMessage("0002"));  

			String send_msg = "견적서 번호 " + QTA_NO + " 가 작성되었습니다.";
			if (send_flag.equals("Y")) {
				send_msg = "견적서 번호 " + QTA_NO + " 가 제출되었습니다.";
			}
			setMessage(send_msg);

			Commit();  
		
		} catch(Exception e) {  
			try{  
				Rollback();  
			}catch(Exception e1){}  
		
			setStatus(0);  
			setMessage(msg.getMessage("0012")); 
		}  
	
		return getSepoaOut();  
	}
    
    
    private String et_getYN(String RFQ_NO, String RFQ_COUNT) throws Exception  
    {  
        String rtn = "";  
        ConnectionContext ctx = getConnectionContext();  
        
        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
        try{  
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
            String[] data = {info.getSession("HOUSE_CODE"), RFQ_NO, RFQ_COUNT};
            rtn = sm.doSelect(data);  
        }catch(Exception e) {  
           //Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
            throw new Exception(e.getMessage());  
        }  
        return rtn;  
    }
    
    
    private	int	setUpdate_qtHD_UP(	ConnectionContext ctx, 
			String[][] qthdData)throws	Exception 
			{ 
		int	rtn	= 0; 
		
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		
		try{ 
		
		String[] type =	{ "S","S","N","N","S"
			, "S","S","S","N","S"
			, "S","S","S","N","S"
			, "S","S","S","S","S"
			, "S","S","S","S","S"
			, "S"
			}; 
		
		SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
		rtn	= sm.doUpdate(qthdData, type); 
		
		}catch(Exception e)	{ 
		//Logger.err.println(info.getSession("ID"),this,stackTrace(e)); 
			throw new Exception(e.getMessage()); 
		} 
		
			return rtn; 
		}
    
    	
    
	private	int	setDelQTDT(	ConnectionContext ctx, 
			String[][] delQtdtData)throws	Exception 
			{ 
		int	rtn	= 0; 

		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		
		try{ 	

			String[] type =	{ "S","S","S" }; 
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
			rtn	= sm.doInsert(delQtdtData, type); 

		}catch(Exception e)	{ 
			//Logger.err.println(info.getSession("ID"),this,stackTrace(e)); 
			throw new Exception(e.getMessage()); 
		} 
			return rtn; 
		}
	
	
	private	int	setDelQTEP(	ConnectionContext ctx, 
			String[][] delQtepData)throws	Exception 
	{ 
		int	rtn	= 0; 
		
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		
		try{ 
		
			String[] type =	{ "S","S","S" }; 
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
			rtn	= sm.doInsert(delQtepData, type); 
		
		}catch(Exception e)	{ 
		//Logger.err.println(info.getSession("ID"),this,stackTrace(e)); 
			throw new Exception(e.getMessage()); 
		} 
			return rtn; 
	}
	
	
	private int setInsert_qtDT(  ConnectionContext ctx,  
            String[][] qtdtData 
           ) throws Exception  
    {  

		int rtn = 0;  
		
		try {  
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
		
			String[] type = {"S", "S", "S", "S", "S"
							,"S", "S", "N", "S", "S"
							,"S", "S", "N", "N", "N"
							,"N", "S", "S", "S", "N"
							,"S", "S", "S", "S", "S"
							,"S", "S", "S", "N", "S"
							,"N", "S", "S", "S", "S"
							,"S", "S"};
			rtn = sm.doInsert(qtdtData,type);  
		
		} catch(Exception e) {  
			Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		}  
		return rtn;  
	}
	
	
	private int setUpdate_rqdt_bid (ConnectionContext ctx,  
            String[][] setData  
           )  throws Exception  
    {  
		int rtn = -1;  
		
		SepoaSQLManager sm = null;  
		
		try {  
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			
			String[] type = {"S", "S", "N", "S"};
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			rtn = sm.doUpdate(setData, type);  
		}catch(Exception e) {  
			//Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		}  
		return rtn;  
	}
	
	
	private int setUpdate_rqse_con (ConnectionContext ctx,  
            String[][] setData
           )  throws Exception  
    {  
		int rtn = -1;  
		
		SepoaSQLManager sm = null;  
		
		try {  
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			
			
			sql.append("    UPDATE ICOYRQSE                                         \n");
			sql.append("    SET CONFIRM_FLAG        = 'Y',                          \n");
			sql.append("        BID_FLAG            = 'Y',                          \n");
			sql.append("        CONFIRM_DATE        = CONVERT(VARCHAR(8),GETDATE(),112),  \n");
			sql.append("        CONFIRM_TIME        = REPLACE(CONVERT(VARCHAR(8),GETDATE(),108), ':', ''),  \n");
			sql.append("        CONFIRM_USER_ID     = ?                             \n");
			sql.append("    WHERE HOUSE_CODE    = ?                                 \n");
			sql.append("    AND VENDOR_CODE     = ?                                 \n");
			sql.append("    AND RFQ_NO          = ?                                 \n");
			sql.append("    AND RFQ_COUNT       = ?                                 \n");
			sql.append("    AND RFQ_SEQ         = ?                                 \n");
			
			
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type = {"S", "S", "S", "S", "N", "S"};
			rtn = sm.doUpdate(setData, type);  
		
		}catch(Exception e) {  
		// Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		}  
			return rtn;  
	}
	

	private int setUpdate_rqse_con_new (ConnectionContext ctx,  
            String company_code, String[][] setData
           )  throws Exception  
    {  
		int rtn = -1;  
		
		SepoaSQLManager sm = null;  
		
		try {  
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
	       	wxp.addVar("confirm_user_id", setData[0][0]);
	       	wxp.addVar("house_code",      setData[0][1]);
	       	wxp.addVar("vendor_code",     setData[0][2]);
	       	wxp.addVar("rfq_no",          setData[0][3]);
	       	wxp.addVar("rfq_count",       setData[0][4]);
	       	wxp.addVar("company_code",    company_code);

	       	String [][] rqseData = new String [setData.length][3];
	       	for (int i = 0; i < setData.length; i++) {
		       	for (int j = 0; j < 3; j++) {
		       		rqseData[i][j] = setData[i][5];
		       	}
	       	}
	       	
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type = {"S", "S", "S"};
			rtn = sm.doUpdate(rqseData, type);  
		
		}catch(Exception e) {  
			throw new Exception(e.getMessage());  
		}  
			return rtn;  
	}
	
	private int set_qtEP_01(ConnectionContext ctx,  
            String[][] qtepData  
            ) throws Exception  
    {  
		int rtn = -1;  
		
		SepoaSQLManager sm = null;  
		
		try {  
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			
			
			sql.append(" INSERT INTO ICOYQTEP (           \n");
			sql.append("           HOUSE_CODE             \n");
			sql.append("          ,QTA_NO                 \n");
			sql.append("          ,QTA_SEQ                \n");
			sql.append("          ,PRICE_SEQ              \n");
			sql.append("          ,COMPANY_CODE           \n");
			sql.append("          ,VENDOR_CODE            \n");
			sql.append("          ,STATUS                 \n");
			sql.append("          ,RFQ_NO                 \n");
			sql.append("          ,RFQ_COUNT              \n");
			sql.append("          ,RFQ_SEQ                \n");
			sql.append("          ,FROM_QTY               \n");
			sql.append("          ,TO_QTY                 \n");
			sql.append("          ,FROM_DATE              \n");
			sql.append("          ,TO_DATE                \n");
			sql.append("          ,UNIT_PRICE             \n");
			sql.append("          ,ADD_DATE               \n");
			sql.append("          ,ADD_TIME               \n");
			sql.append("          ,ADD_USER_ID            \n");
			sql.append("          ,CHANGE_DATE            \n");
			sql.append("          ,CHANGE_TIME            \n");
			sql.append("          ,CHANGE_USER_ID         \n");
			sql.append(" ) VALUES (                       \n");
			sql.append("           ?                      \n");      // HOUSE_CODE
			sql.append("          ,?                      \n");      // QTA_NO
			sql.append("          ,DBO.LPAD(?, 6, '0') \n");      // QTA_SEQ
			sql.append("          ,DBO.LPAD(?, 6, '0') \n");      // PRICE_SEQ
			sql.append("          ,?                      \n");      // COMPANY_CODE
			sql.append("          ,?                      \n");      // VENDOR_CODE
			sql.append("          ,?                      \n");      // STATUS
			sql.append("          ,?                      \n");      // RFQ_NO
			sql.append("          ,?                      \n");      // RFQ_COUNT
			sql.append("          ,?                      \n");      // RFQ_SEQ
			sql.append("          ,?                      \n");      // FROM_QTY
			sql.append("          ,?                      \n");      // TO_QTY
			sql.append("          ,?                      \n");      // FROM_DATE
			sql.append("          ,?                      \n");      // TO_DATE
			sql.append("          ,?                      \n");      // UNIT_PRICE
			sql.append("          ,?                      \n");      // ADD_DATE
			sql.append("          ,?                      \n");      // ADD_TIME
			sql.append("          ,?                      \n");      // ADD_USER_ID
			sql.append("          ,?                      \n");      // CHANGE_DATE
			sql.append("          ,?                      \n");      // CHANGE_TIME
			sql.append("          ,?                      \n");      // CHANGE_USER_ID
			sql.append(" )                                \n");
			
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			
			String[] type = {"S", "S", "S", "S", "S"
							,"S", "S", "S", "N", "S"
							,"N", "N", "S", "S", "N"
							,"S", "S", "S", "S", "S"
							,"S"
							};
			rtn = sm.doInsert(qtepData, type);  
		
		}catch(Exception e) {  
		// Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		}  
			return rtn;  
	}
	
	
	private	int	setDelQTPF(	ConnectionContext ctx, 
			String[][] delQtpfData)throws	Exception 
	{ 
		int	rtn	= 0; 
		
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		
		
		sql.append(" DELETE FROM ICOYQTPF              \n");
		sql.append(" WHERE HOUSE_CODE   = ?            \n");
		sql.append(" AND   QTA_NO       = ?            \n");
		sql.append(" AND   VENDOR_CODE  = ?            \n");
		
		
		try{ 
		
			String[] type =	{ "S","S","S" }; 
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
			rtn	= sm.doInsert(delQtpfData, type); 
		
		}catch(Exception e)	{ 
		//Logger.err.println(info.getSession("ID"),this,stackTrace(e)); 
			throw new Exception(e.getMessage()); 
		} 
			return rtn; 
	}
	
	
	private int setProfile(ConnectionContext ctx,  
            String[][] qtpfData  
            ) throws Exception  
    {  
		int rtn = -1;  
		
		try {  
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			
			
			sql.append(" INSERT INTO ICOYQTPF (           \n");
			sql.append("           HOUSE_CODE             \n");
			sql.append("          ,VENDOR_CODE            \n");
			sql.append("          ,QTA_NO                 \n");
			sql.append("          ,QTA_SEQ                \n"); 
			sql.append("          ,RFQ_NO                 \n");
			sql.append("          ,RFQ_COUNT              \n");
			sql.append("          ,RFQ_SEQ                \n");
			sql.append("          ,PROFILE_SEQ            \n");
			sql.append("          ,HUMAN_NO	           	  \n");
			sql.append("          ,NAME_LOC	           	  \n");
			sql.append("          ,POSITION	           	  \n");
			sql.append("          ,QTY	          		  \n");
			sql.append("          ,UNIT_PRICE	          \n");
			sql.append("          ,STATUS                 \n");
			sql.append("          ,ADD_USER_ID            \n");
			sql.append("          ,ADD_DATE               \n");
			sql.append("          ,ADD_TIME               \n");
			sql.append("          ,CHANGE_USER_ID         \n");
			sql.append("          ,CHANGE_DATE            \n");
			sql.append("          ,CHANGE_TIME            \n");
			sql.append(" ) VALUES (                       \n");
			sql.append("           ?                      \n");      //   HOUSE_CODE       
			sql.append("          ,?                      \n");      //  ,VENDOR_CODE      
			sql.append("          ,? 					  \n");      //  ,QTA_NO           
			sql.append("          ,DBO.LPAD(?, 6, '0') \n");      //  ,QTA_SEQ          
			sql.append("          ,?                      \n");      //  ,RFQ_NO           
			sql.append("          ,?                      \n");      //  ,RFQ_COUNT        
			sql.append("          ,?                      \n");      //  ,RFQ_SEQ          
			sql.append("          ,DBO.LPAD(?, 6, '0') \n");      //  ,PROFILE_SEQ  
			sql.append("          ,?           			  \n");    // HUMAN_NO	
			sql.append("          ,?                      \n");      //  ,NAME_LOC	       
			sql.append("          ,?                      \n");      //  ,POSITION	         
			sql.append("          ,?                      \n");      //  ,QTY	             
			sql.append("          ,?                      \n");      //  ,UNIT_PRICE	   
			sql.append("          ,?                      \n");      //  ,STATUS       
			sql.append("          ,?                      \n");      //  ,ADD_USER_ID           
			sql.append("          ,?                      \n");      //  ,ADD_DATE         
			sql.append("          ,?                      \n");      //  ,ADD_TIME     
			sql.append("          ,?                      \n");      //  ,CHANGE_USER_ID        
			sql.append("          ,?                      \n");      //  ,CHANGE_DATE      
			sql.append("          ,?                      \n");      //  ,CHANGE_TIME   
			sql.append(" )                                \n");
			
			
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			
			
			String[] type =	{ "S","S","S","S","S"
							, "S","S","S","S","S"
							, "S","S","S","S","S"
							, "S","S","S","S","S" 
						};  
			
			rtn = sm.doInsert(qtpfData, type);  
			
					Logger.err.println(info.getSession("ID"),this,"rtn==============>" + rtn);  
		}catch(Exception e) {  
		// Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		}  
			return rtn;  
	}
	
	
	public SepoaOut getQuery_Cre_Qta_Detail(String VENDOR_CODE, String RFQ_NO, String RFQ_COUNT,String group_yn)  
    {  
        String rtn = new String();  
  
        ConnectionContext ctx = getConnectionContext();  
  
        try {  
  
        	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
        	wxp.addVar("group_yn", group_yn);
        	wxp.addVar("vendor_code", VENDOR_CODE);
        	
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
            Logger.err.println(info.getSession("ID"),this,wxp.getQuery());  
  
            String[] args = {info.getSession("HOUSE_CODE"), RFQ_NO, RFQ_COUNT, VENDOR_CODE};  
            rtn = sm.doSelect(args);  
  
            setValue(rtn);  
            setStatus(1);  
			SepoaFormater wf = new SepoaFormater(rtn);
			if(wf.getRowCount() == 0) setMessage(msg.getMessage("0004"));
			else {
				setMessage(msg.getMessage("0003"));
			}            
        }catch (Exception e){  
           // Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + stackTrace(e));  
            setStatus(0);  
        }  
        return getSepoaOut();  
    }
	
	 public SepoaOut setInsert_Qta_Cre( 
			 	  String send_flag
			 	, String RFQ_NO
				, String RFQ_COUNT
				, String QTA_NO
				, String[][] chkCreateData
				, String[][] qthdData
				, String[][] qtdtData
				, String[][] rqdtData
				, String[][] rqseData
				, String[][] qtepData
				, String[][] rqepData
				, String[][] qtpfData)  
	{ 
		int rtn = 0;  
			
		ConnectionContext ctx = getConnectionContext();  
			
		try {  
			
			String yn = et_getYN(RFQ_NO, RFQ_COUNT);  
				
			SepoaFormater wf = new SepoaFormater(yn);  
			String tmp = wf.getValue(0,0); // 견적마감일 체크 
				
			if(Integer.parseInt(tmp) == 0) {  
				setMessage(msg.getMessage("0005"));  
				setStatus(3);  
				return getSepoaOut();  
			}  
			
			for(int i = 0 ; i < chkCreateData.length ; i++) {
				String createFlag = et_getCreateFlag(chkCreateData[i][0]
				    	                            ,chkCreateData[i][1]
				    	                            ,chkCreateData[i][2]);
				
				wf = new SepoaFormater(createFlag);
				
				int qt_cnt = Integer.parseInt(wf.getValue(0,0));
				int rq_cnt = Integer.parseInt(wf.getValue(1,0));
				
				if(!( qt_cnt == 0 && rq_cnt == 0)) {
				    setMessage(msg.getMessage("0009"));  
				    setStatus(3);  
				    return getSepoaOut();
				}
			}
//ssjj 1
			rtn = setInsert_qtHD(ctx, qthdData);
			rtn = setInsert_qtDT(ctx, qtdtData);
			
			if (send_flag.equals("Y")) {
				rtn = setUpdate_rqhd_bid(ctx,info.getSession("HOUSE_CODE"),RFQ_NO,RFQ_COUNT);
				rtn = setUpdate_rqdt_bid(ctx, rqdtData);  
//				rtn = setUpdate_rqse_con(ctx, rqseData); 				  
			}
			
			// 업체 일반경쟁인경우 인서트, 지명경쟁인경우 업데이트
			rtn = setUpdate_rqse_con_new(ctx, qthdData[0][4], rqseData);
			
			if(qtepData.length > 0) { 
				Logger.debug.println(info.getSession("ID"),this,"qtepData==============>" + qtepData.length);  
				rtn = set_qtEP_01(ctx, qtepData);  
			}
				
			if(rqepData.length > 0) {
				Logger.debug.println(info.getSession("ID"),this,"rqepData==============>" + rqepData.length);  
				ep_setCostUpdate(ctx, rqepData);
			}
				
			if(qtpfData.length > 0) {
				Logger.debug.println(info.getSession("ID"),this,"qtpfData==============>" + qtpfData.length);  
				rtn = setProfile(ctx, qtpfData);
			}

			Logger.debug.println(info.getSession("ID"),this,"rtn==============>" + rtn);  

			setStatus(1);  
//			msg.setArg("QTA_NO", QTA_NO);
//			setMessage(msg.getMessage("0010"));
				
			String send_msg = "견적서 번호 " + QTA_NO + " 가 작성되었습니다.";
			if (send_flag.equals("Y")) {
				send_msg = "견적서 번호 " + QTA_NO + " 가 제출되었습니다.";
			}
			setMessage(send_msg);
				
			Commit();  
		}catch(Exception e) {  
			try{  
				Rollback();  
			}catch(Exception e1){}  
			//Logger.err.println("Exception e =" + stackTrace(e));  
			setStatus(0);  
			setMessage(msg.getMessage("0012"));  
			//Logger.err.println(this,stackTrace(e));  
		}  
			
		return getSepoaOut();  
	}
	 
	 
	 private String et_getCreateFlag(String RFQ_NO, String RFQ_COUNT, String RFQ_SEQ) throws Exception  
	    {  
	        String rtn = "";  
	        ConnectionContext ctx = getConnectionContext();  
	        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
	   	  	
	        
	   	  	
	        sql.append("     SELECT COUNT(*)                                                                                                                          \n");
	        sql.append("     FROM    ICOYQTDT                                                                                                                         \n");
	        sql.append("    <OPT=S,S> WHERE HOUSE_CODE   = ?   </OPT>                                                                                                 \n");
	        sql.append("    <OPT=S,S>   AND RFQ_NO       = ?   </OPT>                                                                                                 \n");
	        sql.append("    <OPT=S,S>   AND RFQ_SEQ      = ?   </OPT>                                                                                                 \n");
	        sql.append("    <OPT=S,N>   AND RFQ_COUNT    = ?   </OPT>                                                                                                 \n");
	        sql.append("    <OPT=S,S>   AND VENDOR_CODE  = ?   </OPT>                                                                                                 \n");
	        sql.append("     UNION ALL                                                                                                                                \n");
	        sql.append("     SELECT COUNT(*)                                                                                                                          \n");
	        sql.append("     FROM    ICOYRQHD                  </OPT>                                                                                                 \n");
	        sql.append("    <OPT=S,S> WHERE HOUSE_CODE   = ?   </OPT>                                                                                                 \n");
	        sql.append("    <OPT=S,S>   AND RFQ_NO       = ?   </OPT>                                                                                                 \n");
	        sql.append("    <OPT=S,N>   AND RFQ_COUNT    = ?   </OPT>                                                                                                 \n");
	        sql.append("       AND SIGN_STATUS  = 'E'                                                                                                                 \n");
	        sql.append("       AND ( RFQ_FLAG   = 'C' OR    RFQ_CLOSE_DATE+RFQ_CLOSE_TIME < CONVERT(VARCHAR(8),GETDATE(),112) + SUBSTRING(REPLACE(CONVERT(VARCHAR(8),GETDATE(),108), ':', ''), 1, 4) )  \n");
	        
	        
	        try{  
	            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	            String[] data = {info.getSession("HOUSE_CODE")
	            				, RFQ_NO
	            				, RFQ_SEQ
	            				, RFQ_COUNT
	            				, info.getSession("COMPANY_CODE")
	            				
	            				, info.getSession("HOUSE_CODE")
	            				, RFQ_NO
	            				, RFQ_COUNT};
	            rtn = sm.doSelect(data);  
	        }catch(Exception e) {  
	            //Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
	            throw new Exception(e.getMessage());  
	        }  
	        return rtn;  
	    }
	 
	 
	 private int setInsert_qtHD(ConnectionContext ctx,  
             String[][] qthdData
            ) throws Exception  
     {  
		int rtn = 0;  
		
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()); 

		try{  
		
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
		String[] types_hd = {"S","S","S","S","S"  
		            ,"S","N","N","S","S" 
		            ,"S","S","S","S","S"
		            ,"N","S","S","S","S"
		            ,"N","S","S","S","S"
		            ,"S","S","S","S","S"
		            ,"N","S"};  
		
		rtn = sm.doInsert(qthdData, types_hd);  
		
		}catch(Exception e) {  
		//Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		}  
		return rtn;  
	}
	 
	 
	 private int setUpdate_rqhd_bid (ConnectionContext ctx,  
             String HOUSE_CODE,  
             String RFQ_NO,  
             String RFQ_COUNT  
             )  throws Exception  
     {  
		int rtn = -1;  
		
		SepoaSQLManager sm = null;  
		
		try {  
			
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			
			
			sql.append(" UPDATE ICOYRQHD                  \n");
			sql.append(" SET BID_COUNT = (BID_COUNT + 1)  \n");
			sql.append(" WHERE HOUSE_CODE = ?             \n");
			sql.append(" AND RFQ_NO       = ?             \n");         
			sql.append(" AND RFQ_COUNT    = ?             \n"); 
			sql.append(" AND SIGN_STATUS  IN( 'T' , 'E')          \n");
			
			
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			String[][] setData = {{info.getSession("HOUSE_CODE"), RFQ_NO, RFQ_COUNT}};
			String[] type = {"S", "S", "N"};
			rtn = sm.doUpdate(setData, type);  
		
		}catch(Exception e) {  
		//Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		}  
			return rtn;  
	}
	
	
	 private void ep_setCostUpdate(ConnectionContext ctx,  
             String[][] rqepData) throws Exception  
     {  
		 SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()); 
		
		 
		sql.append("    UPDATE ICOYRQEP                   \n");                                      
		sql.append("    SET                               \n");                                      
		sql.append("           COST_PRICE_VALUE  = ?      \n");         
		sql.append("    WHERE HOUSE_CODE   = ?            \n");
		sql.append("    AND   RFQ_NO       = ?            \n");
		sql.append("    AND   RFQ_COUNT    = ?            \n");
		sql.append("    AND   RFQ_SEQ      = ?            \n");
		sql.append("    AND   VENDOR_CODE  = ?            \n");
		sql.append("    AND   COST_SEQ     = ?            \n");
		
		
		try{  
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			String[] type = {"S","S","S","N","S"
						,"S","S"};
			sm.doUpdate(rqepData, type);  
		
		}catch(Exception e) {  
		// Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		
		}  
	}
	 
	 
	 
	//견적서 결과현황조회   
		public SepoaOut getCompanyQtaList(String[] args  ) 
		{ 
			try{ 
				String rtn = et_getCompanyQtaList(args); 
				setValue(rtn); 
				setStatus(1); 
				setMessage(msg.getMessage("0003")); 
			}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				setStatus(0); 
				setMessage(msg.getMessage("0004")); 
			} 
			return getSepoaOut(); 
		} 
	 
		//견적요청현황 
		private	String et_getCompanyQtaList(String[] args  )	throws Exception 
		{ 
	 
			String rtn = null;
			String cur_date_time = SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4);
			
			ConnectionContext ctx =	getConnectionContext(); 
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("cur_date_time", cur_date_time); 
	 
			try{ 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				 
				rtn	= sm.doSelect(args); 
			}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		}
		
		
		//견적서 결과팝업조회  
	    public SepoaOut getCompanyQtaListPopup(String vendor_code, String rfq_no, String rfq_count) {  
	        try {  
	            String rtn = new String();  

	            rtn = et_getCompanyQtaListPopup(vendor_code, rfq_no, rfq_count);  
	            
				SepoaFormater wf = new SepoaFormater(rtn);
				if(wf.getRowCount() == 0) setMessage(msg.getMessage("0011"));
				else {
					setMessage(msg.getMessage("0003"));
				}
	            setValue(rtn);  
	            setStatus(1);  
	        }catch (Exception e){  
	          //  Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + stackTrace(e));  
	            setMessage(msg.getMessage("0004"));  
	            setStatus(0);  
	        }  
	        return getSepoaOut();  
	    }  
	  
	    private String et_getCompanyQtaListPopup(String vendor_code, String rfq_no, String rfq_count) throws Exception  
	    {  
	        String rtn = new String();  
	        ConnectionContext ctx = getConnectionContext();  
	  
	        try {  
	        	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
	            
	        	
	            sql.append(" SELECT                                                              \n");
	            sql.append("          QT.ITEM_NO                                                 \n");
	            sql.append("         ,GETITEMDESC(QT.HOUSE_CODE, QT.ITEM_NO) AS DESCRIPTION_LOC  \n");                
	            sql.append("         ,GETITEMSPEC(QT.HOUSE_CODE, QT.ITEM_NO) AS SPECIFICATION    \n");
	            sql.append("         ,QT.UNIT_MEASURE                                            \n");
	            sql.append("         ,QT.SETTLE_QTY                                              \n");
	            sql.append("         ,QT.QUOTA_PERCENT                                           \n");
	            sql.append("         ,QT.UNIT_PRICE                                              \n");
	            sql.append("         ,QT.ITEM_AMT                                                \n");
	            sql.append(" FROM   ICOYRQDT RQ, ICOYQTDT QT                                     \n");
	            sql.append(" WHERE  QT.HOUSE_CODE  = RQ.HOUSE_CODE                               \n");
	            sql.append(" AND    QT.RFQ_NO      = RQ.RFQ_NO                                   \n");
	            sql.append(" AND    QT.RFQ_SEQ     = RQ.RFQ_SEQ                                  \n");
	            sql.append(" AND    QT.RFQ_COUNT   = RQ.RFQ_COUNT                                \n");
	            sql.append(" <OPT=S,S> AND    RQ.HOUSE_CODE  = ? </OPT>                          \n");
	            sql.append(" <OPT=S,S> AND    RQ.RFQ_NO      = ? </OPT>                          \n");
	            sql.append(" <OPT=S,N> AND    RQ.RFQ_COUNT   = ? </OPT>                          \n");
	            sql.append(" <OPT=S,S> AND    QT.VENDOR_CODE = ? </OPT>                          \n");
	            sql.append(" AND    RQ.STATUS IN ('C', 'R')                                      \n");
	            sql.append(" AND    QT.STATUS IN ('C', 'R')                                      \n");
	            sql.append(" AND    QT.SETTLE_DATE IS NOT NULL                                   \n");
	  
	  			
	            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	            String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count, vendor_code};
	            rtn = sm.doSelect(data);  
	  
	            if(rtn == null) throw new Exception("SQL Manager is Null");  
	        }catch(Exception e) {  
	            throw new Exception("et_getCompanyQtaListPopup=========>"+e.getMessage());  
	        } finally{  
	        }  
	        return rtn;  
	    }  
*/
}  
  
