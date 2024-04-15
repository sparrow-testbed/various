package sepoa.svc.approval;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.io.Writer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

import mail.mail;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.IOUtils;

import com.tcApi.OT8602;
import com.tcComm.ONCNF;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
//import sepoa.svc.approval.madec.Madec;
import MarkAny.MaSaferJava.Madec;
import sms.SMS;
import wise.util.CEncrypt;
import wisecommon.SignResponseInfo;


public class Approval extends SepoaService{
	private String m_PO_PR_PROCEEDING_FLAG = "B";
    public Approval(String opt,SepoaInfo info) throws SepoaServiceException
    {
        super(opt,info);
        setVersion("1.0.0");
        Configuration configuration = null;

		try {
			configuration = new Configuration();
		} catch(ConfigurationException cfe) {
			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + cfe.getMessage());
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + e.getMessage());
		}
    }
    
    
    /*검수요청*/
	public SepoaOut Approval_1(SignResponseInfo inf) {

        String app_rtn = inf.getSignStatus();

        String[] re_doc_no = inf.getDocNo();
        String[] re_doc_seq = inf.getDocSeq();
        String sign_date = inf.getSignDate();
        String sign_user_id = inf.getSignUserId();
        String sign_flag = "";
        String doc_type = inf.getDocType();
        String[] re_shipper_type = inf.getShipperType();

        String doc_no = "";
        String doc_seq = "";
        String doc_count = "1";  // Fix
        String shipper_type = "";

        int rtn = 0;
        int rtn_sms= 0;

        ConnectionContext ctx = getConnectionContext();
        try {

            for( int i = 0; i < re_doc_no.length; i++ )
            {
                //StringTokenizer st = new StringTokenizer(re_doc_seq[i],"/");
                //doc_seq   = st.nextToken();
                //doc_count = st.nextToken();
                doc_no    = re_doc_no[i]; //문서번호
                shipper_type    = re_shipper_type[i];

                Logger.debug.println(info.getSession("ID"),this,"doc_no=============== >"+doc_no);
                Logger.debug.println(info.getSession("ID"),this,"doc_count=============== >"+doc_count);
                Logger.debug.println(info.getSession("ID"),this,"doc_type=============== >"+doc_type);

                //app_rtn : 완료 E, 반려:R, 취소:D
                 String tmp_doc_no = doc_no.substring(0,2);
                Logger.debug.println(info.getSession("ID"),this,"tmp_doc_no=============== >"+tmp_doc_no);

                rtn = setApproval_1( doc_no, sign_date, sign_user_id,app_rtn);
                Logger.debug.println(info.getSession("ID"),this,"############rtn=============== >"+rtn);

                /**
                 * 현재는 잠시 막아둠 : 2006.04.10 ,박은숙
                if(app_rtn.equals("E")) { // 완료일 경우에만 들어오게 끔 한다.
                    rtn_sms = setSMS(doc_no, doc_count);
                }
                **/
                //역경매자동발주생성
                //if( app_rtn.equals("E") )
                //    rtn = setRaPoCreate(doc_no,doc_count,shipper_type,sign_date,sign_user_id);
                if( rtn >= 1 ){
                    setStatus(1);
                }
                else
                    setStatus(0);
            }
        }
        catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,"Approval =="+e.getMessage());
            setStatus(0);
        }
        return getSepoaOut();
    }
	
	private int setApproval_1(String inv_no,
            String sign_date,
            String sign_user_id,
            String app_rtn ) throws Exception {
    	int rtn = -1;
    	try {
    		String house_code = info.getSession("HOUSE_CODE");
    		ConnectionContext ctx = getConnectionContext();
    		Map<String, String> data =  new HashMap<String, String>();
    		SepoaXmlParser wxp = new SepoaXmlParser(this,"et_setIVHD");
    		
			/*wxp.addVar("app_status", app_rtn);
			wxp.addVar("change_date", SepoaDate.getShortDateString());
			wxp.addVar("change_time", SepoaDate.getShortTimeString());
			wxp.addVar("id", sign_user_id);
			wxp.addVar("house_code", house_code);
			wxp.addVar("inv_no", inv_no);*/
    		data.put("app_status", app_rtn);
    		data.put("change_date", SepoaDate.getShortDateString());
    		data.put("change_time", SepoaDate.getShortTimeString());
    		data.put("id", sign_user_id);
    		data.put("house_code", house_code);
    		data.put("inv_no", inv_no);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn = sm.doUpdate(data);
    	}catch(Exception e) {
    		throw new Exception("setSIGN_STATUS:"+e.getMessage());
    	}
    	return rtn;
    }
	
	/**구매요청
     * 청구결재 - 결재모듈에서 호출한다.
     * <pre>
     * inf.getSignStatus() - D:반려
     * </pre>
     * @param inf
     * @return
     */
    public SepoaOut Approval_2(SignResponseInfo inf)
    {
    	try
        {
	        String  ans = inf.getSignStatus();
	        String sapType = "";

	        ConnectionContext ctx = getConnectionContext();

	        //Logger.debug.println(userid,this,"inf.getSignStatus()===============>"+inf.getSignStatus()+"-------");


	        String[] pr_no     = inf.getDocNo();
	        String signuserid  = inf.getSignUserId();
	        String signdate    = inf.getSignDate();
	        String ctrl_reason = inf.getSignRemark();

	        //for(int i=0; i<pr_no.length; i++)
	        //	Logger.debug.println(userid,this,"pr_no["+i+"]==>"+pr_no[i]);

	        if(!ctrl_reason.equals("")) {
	            ctrl_reason = "결재반려@"+ctrl_reason ;
	        }

	        String flag = "";
	        String dc_no = "";
	        String rtn_2 = "";
	        int res = -1;

	        if(inf.getSignStatus() == null)
	        	ans = "xxxxxxxx";


            //완료: E, 반려 : R 로 처리
            if(ans.equals("E")){
                flag = "E";
            }else if (ans.equals("R")){
                flag = "R";
            }


            String[][] all_pr_no = new String[pr_no.length][1];
            for (int i = 0; i < pr_no.length; i++) {
                String Data[] = {pr_no[i]};
                all_pr_no[i] = Data;
                Logger.debug.println(info.getSession("ID"), this, "all_pr_no["+i+"]==================>"+all_pr_no[i][0]);
            }


            //결재취소
            if(ans.equals("D")){
                res = et_setApping_return(all_pr_no);
            }
            else{
            	res = et_setApping(flag,all_pr_no,ctrl_reason,signuserid,signdate);
            }

            setStatus(1);
        }catch(Exception e) {
            Logger.err.println("setSignStatus: = " + e.getMessage());

            try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            setValue(e.getMessage().trim());
            setStatus(0);
            setMessage(e.getMessage().trim());
        }
        return getSepoaOut();
    }
    
    /**
     * 결재반려
     * <pre>
     * </pre>
     * @param all_pr_no
     * @return
     * @throws Exception
     */
    private int et_setApping_return(String[][] all_pr_no ) throws Exception
    {
        int rtn = -1;
        try {
          //String house_code = info.getSession("HOUSE_CODE");
          ConnectionContext ctx = getConnectionContext();
          for(int i=0;i<all_pr_no.length;i++){
        	  Map<String, String> data =  new HashMap<String, String>();
              
              data.put("pr_no", all_pr_no[i][0]);
              SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
              //wxp.addVar("house_code", house_code);
              //String[] type = {"S"};
              SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
              //rtn = sm.doUpdate(all_pr_no, type);
              rtn = sm.doUpdate(data);
          }
          
      }catch(Exception e) {
          throw new Exception("setSIGN_STATUS:"+e.getMessage());
      }
      return rtn;
    }
    
    /**
     * 결재완료.
     * <pre>
     * </pre>
     * @param flag
     * @param all_pr_no
     * @param ctrl_reason
     * @param signuserid
     * @param signdate
     * @return
     * @throws Exception
     */
    private int et_setApping(String flag,String[][] all_pr_no, String ctrl_reason,String signuserid,String signdate ) throws Exception
    {
        int rtn = -1;

        try {
            String house_code = info.getSession("HOUSE_CODE");

            ConnectionContext ctx = getConnectionContext();
            
            String rtnSel =  getusername(signuserid);
            SepoaFormater wf = new SepoaFormater(rtnSel);
            String signname = wf.getValue(0,0);
            
            	/*wxp.addVar("ctrl_reason", ctrl_reason);
            	wxp.addVar("flag", flag);
            	wxp.addVar("signdate", signdate);
            	wxp.addVar("signuserid", signuserid);
            	wxp.addVar("house_code", house_code);*/
            

            for(int i=0;i<all_pr_no.length;i++){
            	Map<String, String> data =  new HashMap<String, String>();
                data.put("pr_no", all_pr_no[i][0]);
                data.put("ctrl_reason", ctrl_reason);
                data.put("flag", flag);
                data.put("signdate", signdate);
                data.put("signuserid", signuserid);
                data.put("house_code", house_code);
                SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
                SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
                rtn = sm.doUpdate(data);
            }
            //String[] type = {"S"};
            
        }catch(Exception e) {
            throw new Exception("setSIGN_STATUS:"+e.getMessage());
        }

        return rtn;
    }
    
    private String getusername(String ls_id) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        Map<String, String> data =  new HashMap<String, String>();
        String house_code = info.getSession("HOUSE_CODE");
        String company = info.getSession("COMPANY_CODE");
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    	/*wxp.addVar("house_code", house_code);
    	wxp.addVar("company", company);
    	wxp.addVar("ls_id", ls_id);*/
        data.put("house_code", house_code);
        data.put("company", company);
        data.put("ls_id", ls_id);

        try{
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
            rtn = sm.doSelect(data);
        }catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
    
    
/*역경매 결재
 * 결재 완료후 결재모듈에서 호출하는 메소드
 */
     public SepoaOut Approval_3(SignResponseInfo inf) {

         String app_rtn = inf.getSignStatus();

         String[] re_doc_no = inf.getDocNo();
         String[] re_doc_seq = inf.getDocSeq();
         String sign_date = inf.getSignDate();
         String sign_user_id = inf.getSignUserId();
         String sign_flag = "";
         String[] re_shipper_type = inf.getShipperType();

         String doc_no = "";
         String doc_seq = "";
         String doc_count = "1";  // Fix
         String shipper_type = "";
         int rtn = 0;
         int rtn_sms= 0;

         try {

             for( int i = 0; i < re_doc_no.length; i++ )
             {
                 //StringTokenizer st = new StringTokenizer(re_doc_seq[i],"/");

                 //doc_seq   = st.nextToken();
                 //doc_count = st.nextToken();

                 doc_no     = re_doc_no[i]; //문서번호
                 doc_seq	= re_doc_seq[i];// seq 역경매 RA_COUNT
                 
                 shipper_type    = re_shipper_type[i];

                 Logger.debug.println(info.getSession("ID"),this,"doc_no=============== >"+doc_no);
                 Logger.debug.println(info.getSession("ID"),this,"doc_count=============== >"+doc_count);

                 //app_rtn : 완료 E, 반려:R, 취소:D
                 rtn = setApproval( doc_no,doc_seq,sign_date, sign_user_id,app_rtn );
                 
                 /**
                  * 현재는 잠시 막아둠 : 2006.04.10 ,박은숙
                 if(app_rtn.equals("E")) { // 완료일 경우에만 들어오게 끔 한다.
                     rtn_sms = setSMS(doc_no, doc_count);
                 }
                 **/
                 //역경매자동발주생성
                 //if( app_rtn.equals("E") )
                 //    rtn = setRaPoCreate(doc_no,doc_count,shipper_type,sign_date,sign_user_id);

                 if( rtn == 1 ){
                     setStatus(1);
                 }
                 else
                     setStatus(0);
             }


         }
         catch(Exception e) {
             Logger.err.println(info.getSession("ID"),this,"Approval =="+e.getMessage());
             setStatus(0);
         }
         return getSepoaOut();
     }
     
     /**
      * 결재완료 후 처리하는 메소드
      **/
         private int setApproval(String ra_no,
        		 				 String ra_count,
                                 String sign_date,
                                 String sign_user_id,
                                 String app_rtn ) throws Exception
         {

             ConnectionContext ctx = getConnectionContext();
             Map<String, String> data =  new HashMap<String, String>();
             SepoaSQLManager sm = null;
             String rtnString = "";
             int rtnIns = 0;
             String house_code = info.getSession("HOUSE_CODE");
             SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
             	/*wxp.addVar("house_code", house_code);
             	wxp.addVar("sign_date", sign_date);
             	wxp.addVar("sign_user_id", sign_user_id);
             	wxp.addVar("ra_no", ra_no);
             	wxp.addVar("ra_count", ra_count);
             	wxp.addVar("app_rtn", app_rtn);*/
             	
             try {

            	data.put("house_code", house_code);
            	data.put("sign_date", sign_date);
            	data.put("sign_user_id", sign_user_id);
            	data.put("ra_no", ra_no);
            	data.put("ra_count", ra_count);
            	// 결재완료시 강제로 바로 공고가 나가도록 추가
            	// 기존로직으로 복귀시 app-rtn = "C"; data.put("status", "R"); 삭제 쿼리에서 status부분 삭제하면됨.
            	app_rtn = "C";
            	data.put("app_rtn", app_rtn);
            	data.put("status", "R");
                sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
                rtnIns = sm.doInsert(data);
                 /**
                  * 현재는 잠시 막아둠 : 2006.04.10 ,박은숙
                 //업체메일전송
                 if( app_rtn.equals("E") )
                 {
                     Logger.debug.println(info.getSession("ID"),this,"Mail Enter ");
                     setMail(ra_no);
                 }
                 **/
				if ("E".equals(app_rtn) && rtnIns > 0) {
					data.put("APPROVAL_TYPE", "RA" );
					if(!approvalFileDecode(data)){
						rtnIns = 0;
						throw new Exception("파일 복호화중 에러가 발생하였습니다.\n시스템관리자에게 문의하세요.");
					}
				}
                 
            }
             catch(Exception e) {

                 rtnString = "ERROR";
                 Logger.debug.println(info.getSession("ID"),this,"et_setratppins_1 = " + e.getMessage());

             }

             return rtnIns;
         }
             
     /**
 	 * <b>품의정보의 결재를 승인한다.</b>
 	 * <pre>
 	 * et_Approval을 호출한다.
 	 * </pre>
 	 * @param inf
 	 * @return
 	 */
 	public SepoaOut Approval_4(SignResponseInfo inf)
 	{
 		String user_id		 = info.getSession("ID");
 		SepoaOut value = null;
 		
 		try
 		{
 			
 			Logger.debug.println(user_id, this, "start time = "+System.currentTimeMillis());
 			if("EX".equals(inf.getDocType())){			// 품의
 				value = et_Approval(inf);
 			}else if("TEX".equals(inf.getDocType())){	// 통합품의
 				value = et_ApprovalTEX(inf);
 			}
 			
 			Logger.debug.println(user_id, this, "end time = "+System.currentTimeMillis());
 			
 			Commit();
 		}
 		catch(Exception e)
 		{
 			Logger.debug.println(user_id, this, "end time = "+System.currentTimeMillis());
 			Logger.debug.println(user_id, this, "***************Exception***************");
 			Logger.debug.println(user_id, this, "Exception Message = "+e.getMessage());
 			Logger.debug.println(user_id, this, "***************Exception***************");
 			try
 			{
 				Rollback();
 			}
 			catch(Exception re)
 			{
 				Logger.debug.println(user_id, this, re.getMessage());
 			}
 		}
 		
 		return value;
 	}
 	
 	
 	/**
	 * 품의승인.
	 * <pre>
	 * <b> LOGIC 순서 </b>
	 * 1) ICOYCNHD UPDATE
	 * 2) ICOYCNHD.BID_TYPE, ICOYCNHD.CREATE_TYPE 조회
	 * 3) ICOYINFO, ICOYINDR 생성
	 * 4) ICOYINPR 생성(ICOYRQDT.PRICE_TYPE = 'P', 'Q' ) 인 경우
	 * 5) ICOYINFH(단가이력정보) 생성
	 * 6) GROUP BY 조회후 PO생성
	 * (GROUP BY 조건
	 *  HOUSE_CODE, COMPANY_CODE, VENDOR_CODE, RQOP.PURCHASE_LOCATION
	 *  PAY_TERMS, DELY_TERMS, ARRIVAL_PORT, DEPART_PORT, DOM_EXP_FLAG, STR_CODE, PR_LOCATION)
	 * 7) ICOYINDR.CUM_PO_QTY UPDATE
	 * <b>단가정보 : ICOYINFO, ICOYINDR, ICOYINPR</b>
	 * - 단가정보는 반드시 만들어야한다.
	 * - ICOYINFO, ICOYINDR은 필수적으로 만들어진다. et_del_ICOYINFO(), et_del_ICOYINDR()
	 * - ICOYINPR은 PRICE_TYPE : P,Q 일때 만들어진다.
	 * 
	 * 
	 * <b>업데이트 할것들 ICOYCNHD, ICOYPRDT</b>
	 * - ICOYPRDT는 매뉴얼(단가정보만 업데이트하는, ICOYCNHD.BID_TYPE=MA) 품의일때는 제외한다.
	 * 
	 * <b>호출되는 메서드</b>
	 * - et_getExecInfo(ICOYCNHD.BID_TYPE, ICOYCNHD.CREATE_TYPE, ICOYCNHD.SHIPPER_TYPE을 가져온다.)
	 * - setCnhdUpdate (ICOYCNHD의 정보를 업데이트한다. 결재관련 플래그)
	 * - delInfoData (레벨별로 단가정보를 삭제한다. ICOYINFO, ICOYINDR)
	 * - createInfoData(단가정보를 생성한다.ICOYINFO, ICOYINDR, ICOYINPR(단 PRICE_TYPE='P','Q'일때만 생성))
	 * - createInfhData(단자정보의 이력을 생성한다. ICOYINFH)
	 * - createPO(발주를 생성한다.ICOYPOHD, ICOYPODT)
	 * 
	 * <b>발주 생성</b>
	 * - 발주정보 생성 발주정보 : ICOYPOHD, ICOYPODT
	 * - 발주는 한업체로 한정된다.
	 * - 품의발주는 배분율이 큰 한업체에 나가게 되어 있다.
	 *  
	 * <b>발주가 안되는 예외사항</b>
	 * - 매뉴얼 품의, 매뉴얼 견적요청은 단가정보 생성만 한다.
	 * - ICOYCNHD.CREATE_TYPE  - MA(매뉴얼견적요청)
	 *
	 * <b>참조정보</b>
	 * CNHD.CREATE_TYPE
	 * MA, PR로 구분한다. PR인것만 발주가 나간다.
	 * 
	 * CNHD
	 * BID_TYPE :    = RQHD.BID_TYPE(RQ, EX, RQ)
	 * CREATE_TYPE : = RQHD.CREATE_TYPE(MA,PR-발주 생성)
	 * </pre>
	 * @param inf
	 * @return
	 * @throws Exception
	 */
	private SepoaOut et_Approval(SignResponseInfo inf) throws Exception
	{
		String user_id		 = info.getSession("ID");
		String house_code	 = info.getSession("HOUSE_CODE");
		String location_code = info.getSession("LOCATION_CODE");
		String department	 = info.getSession("DEPARTMENT");
		String name_loc		 = info.getSession("NAME_LOC");
		String name_eng		 = info.getSession("NAME_ENG");
		String language		 = info.getSession("LANGUAGE");
		String add_date     = SepoaDate.getShortDateString();
		String add_time     = SepoaDate.getShortTimeString();
		Logger.debug.println(user_id,this,"############## p2017.Approval Start ################");
		
		try
		{
			
			String sign_status	= inf.getSignStatus();
			String doc_type     = inf.getDocType(); // 품의에서 넘어	왔는지 계약금 쪽에서 넘어 왔는 Check.
			String sign_date	= inf.getSignDate();
			String sign_user_id	= inf.getSignUserId();
			
			String[] DOC_NO	      = inf.getDocNo();
			String[] DOC_SEQ	  = inf.getDocSeq();
			String[] SHIPPER_TYPE = inf.getShipperType();
			
			Logger.debug.println(user_id,this,"############## Approval SignStatus ==> " + sign_status);
			
			int	rtn_prdt = -1;
			int rtn_cnhd = -1;

			int iDocCount = DOC_NO.length;
			String[][] objCNHD	  =	new	String[iDocCount][];
			
			for(int	i=0;i <	DOC_NO.length;i++)
			{
				String[] TEMP_CNHD = {
					  sign_status
					, sign_date
					, sign_user_id
					, house_code
					, DOC_NO[i]
				};
				
				objCNHD[i] = TEMP_CNHD;
			}
			
			
            
			rtn_cnhd = setCnhdUpdate(objCNHD);
			
			setStatus(1);
			setMessage("");
			
			//반려이거나 취소일 경우 여기서 끝낸다.
			//if(sign_status!="E")
			if(!"E".equals(sign_status))
			{
				return getSepoaOut();
			}
			
			for(int	i=0;i <	DOC_NO.length;i++)
			{
				String[][] objPrdt = { {house_code, DOC_NO[i]} };
				String[][] objInfo = { 
						{
							house_code
							, DOC_NO[i]
						} 
				};
				String[][] objInfh = { 
						{
							house_code
							, DOC_NO[i]
						} 
				};
				
				String[] objExecInfo = {house_code, DOC_NO[i]};
				/*
				String[] ExecInfo    = et_getExecInfo(objExecInfo);				
				String bid_type     = ExecInfo[0];
				String create_type  = ExecInfo[1];
				String shipper_type = ExecInfo[2];
				*/
				String rtn_mtgl="";
				String rtn_prtype="";
				
				
				/**
				 * 품의결재 승인시에
				 * 품의생성시 소싱결과에 대해서 수정이 있는경우  
				 * 1.CNDT 기존 PR_NO, PR_SEQ : STATUS = 'D'   인것들은 ICOYPRDT테이블에도 STATUS = 'D' 로 업데이트 쳐주고, PR_PROCEEDING_FLAG = 'R' 로 업데이트
				 * 2.CNDT 에 새로 추가된 건들은 PR_NO, STATUS != 'D' 의 것들을 MAX(PR_SEQ_ +10 로 CNDT에 업데이트하고 PRDT에 인서트한다.
				 * 3.영업관리의 PR테이블에도 새로추가된 건들은 인서트 하고 STATUS = 'D' 인 것들은 REPEAT_YN = 'Y' 로 업데이트 쳐준다.
				 * 4-1.구매요청인 경우 추가된 TB_SCM_PR 테이블의 CONSULT_NO, CONSULT_DGR, CONSULT_SEQ 의 값을 ICOYPRDT의 ORDER_NO, ORDER_COUNT, ORDER_SEQ에 업데이트
				 * 4-2.사전지원요청인 경우 TB_SCM_BR에 PR_STATUS = '5' (완료)로 업데이트친다.
				 */
				
				//1. 수정사항이 있는지 체크 CNDT.STASUS = 'D' AND CNDT.PR_SEQ IS NULL 인것이 있는지 찾는다.
				Configuration conf = new Configuration();
				String exec_no = DOC_NO[i];				
				String rtn_modified = et_getModified(exec_no);
				SepoaFormater wf_modified = new SepoaFormater(rtn_modified);
                int STATUS_D_CNT 	= Integer.parseInt(wf_modified.getValue("STATUS_D_CNT", 0));
                int PR_SEQ_NULL_CNT = Integer.parseInt(wf_modified.getValue("PR_SEQ_NULL_CNT", 0));
                String REQ_TYPE		= wf_modified.getValue("REQ_TYPE", 0);
                String PREFERRED_BIDDER = wf_modified.getValue("PREFERRED_BIDDER", 0);
                if(STATUS_D_CNT != 0 && PR_SEQ_NULL_CNT != 0){
                	//2. ICOYPRDT 에 CNDT.STATUS = 'D' 인 PR_NO, PR_SEQ건에 대해서 PRDT.STATUS = 'D', PRDT.PR_PROCEEDING_FLAG = 'R' 로 업데이트
                	int rtn_updatePRDT = et_updatePRDT(exec_no);
                	//3. ICOYCNDT 에 CNDT.PR_SEQ 값을 MAX(PR_SEQ) + 10으로 업데이트한다.
                	int rtn_updateCNDT = et_updateCNDT(exec_no);
                	//4. ICOYPRDT 에 CNDT.STATUS != 'D' 가 아닌건들을 인서트한다.
                	int rtn_insertPRDT = et_insertPRDT(exec_no);
                	//5. 영업관리 인터페이스 IF_FLAG 가 'Y' 인경우에..                	                	
    	        	if(conf.getBoolean("sepoa.scms.if_flag")){
    	        		int rtn_interface = scms_interface(exec_no, REQ_TYPE);
    	        	}
                }
                
                //우선협상품의인 경우에도 품의수정이 가능하므로 수정건만 반영하고  구매접수현황으로 보낸다.
				if("Y".equals(PREFERRED_BIDDER)){
					Logger.debug.println("============================= 우선협상품의결재최종승인 ===============================");
					//우선협상품의 : PR_PROCEEDING_FLAG = 'P'
					m_PO_PR_PROCEEDING_FLAG = "P";
					rtn_prdt = setPRDT(objPrdt);
					continue;
				}
				
                //사전지원인경우에는 품의결재완료시 TB_SCM_BR.PR_STATUS = '5'(완료) 업데이트 쳐준다. 사전품의에서 변경된 예상단가, 예상금액을 넘겨준다.
                //TB_SCM_BR의 완료여부를 체크하여 모두 완료(BR.REPEAT_YN != 'Y' 가 아닌건들이 모두 PR_STATUS = '5'일때)되었을경우에 TB_SCM_BR_HEAD.BR_HEAD_STATUS = '5'
				if("B".equals(REQ_TYPE)){
					if(conf.getBoolean("sepoa.scms.if_flag")){
						int rtn_interface = scms_interface_complete_BR(exec_no);
					}
				}
				
				//구매품의완료시에 회계팀에 SMS 공지
				if("P".equals(REQ_TYPE)){
			        SepoaRemote ws_sms  	= null;
			        SepoaRemote ws_mail  = null;
			        
			        String[][] args = {{exec_no}};			        
					Object[] sms_args = {args};
					
			        String sms_type = "";
			        String mail_type = "";
			        
			        sms_type 	= "S00012";
			        mail_type 	= "";
			        
			        if(!"".equals(sms_type)){
			        	//2010.12.10 swlee modify
			        	//ServiceConnector.doService(info, "SMS", "TRANSACTION", sms_type, sms_args);
			        }
			        if(!"".equals(mail_type)){
			        }
				}
				
				// PRDT 업데이트 일반품의 : PR_PROCEEDING_FLAG = 'B',     우선협상품의 : PR_PROCEEDING_FLAG = 'P'
				Logger.debug.println("============================= 일반품의결재최종승인 ===============================");
				m_PO_PR_PROCEEDING_FLAG = "B";
				rtn_prdt = setPRDT(objPrdt);
                
				//ICOMMTGL이 존재하는 경우에만 단가를 생성한다// 건수가 0 인경우도 존재할수 있음
				//품의생성시 품의구분이 단가계약일때 단가를 생성한다.
                rtn_mtgl =checkMtglItem(DOC_NO[i]);
				
                SepoaFormater  wf =  new SepoaFormater(rtn_mtgl);
                
                int iRowCount = wf.getRowCount();
                if(iRowCount>0) {
                	rtn_mtgl = wf.getValue("CNT", 0);
                }
                
                // ICOMMTGL이 존재하는 경우에만 단가를 생성한다 if end
                //if(!rtn_mtgl.equals("0") && "P".equals(REQ_TYPE)){ // 사전지원단계의 정보는 가격정보로서 관리하지 않는다.
                if(!rtn_mtgl.equals("0")){ // 사전지원단계의 정보도 가격정보로서 관리한다. 20100716			
					//레벨별 단가삭제(DELETE ICOYINFO, ICOYINDR, ICOYINPR)
					delInfoData(objExecInfo);
					//새로운  단가생성(INSERT ICOYINFO, ICOYINDR)
					createInfoData(objInfo);
					//ICOYINFH(히스토리 테이블) 생성
					createInfhData(objInfh);
                }

			}
			
		}
		catch(Exception	e)
		{
			throw new Exception("et_Approval error"+e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	/**
	 * 품의 헤더정보에 결재정보를 update해준다.
	 * <pre>
	 * </pre>
	 * @param args
	 * @return
	 * @throws Exception
	 */
	private	int setCnhdUpdate(String[][] args) throws Exception
	{
		int rtn = -1;
		String user_id = info.getSession("ID");
		
		try
		{
			ConnectionContext ctx =	getConnectionContext();
			for(int i=0;i<args.length;i++){
				Map<String, String> data =  new HashMap<String, String>();
				data.put("sign_status",args[i][0] );
				data.put("sign_date",args[i][1] );
				data.put("sign_user_id",args[i][2] );
				data.put("house_code",args[i][3] );
				data.put("DOC_NO",args[i][4] );
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx, wxp.getQuery());
				
				//String[] type1 = {"S","S","S","S","S"};
				//rtn = sm.doUpdate(args, type1);
				rtn = sm.doUpdate(data);
			}
		}
		catch(Exception	e)
		{
			throw new Exception("setCnhdUpdate:"+e.getMessage());
		}
		
		return rtn;
	}
	
	private	String et_getModified(String exec_no) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		String[] args = null;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			/*wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("exec_no", exec_no);*/

		try {
			Map<String, String> data =  new HashMap<String, String>();
			data.put("exec_no", exec_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn = sm.doSelect(data);

		}catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	private int et_updatePRDT( String exec_no) throws Exception                    
  	{
  		String house_code   = info.getSession("HOUSE_CODE");                    				            	                              
		String user_id      = info.getSession("ID");

  		ConnectionContext ctx = getConnectionContext();
  		String rtn_value = "";
  		
		int rtn_1 = -1;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		/*wxp.addVar("house_code", house_code);
		wxp.addVar("exec_no", exec_no);*/
			
   	try {
   		Map<String, String> data =  new HashMap<String, String>();
   		data.put("exec_no", exec_no);
   		SepoaSQLManager sm = null;
        sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
		rtn_1 = sm.doUpdate(data);
		if(rtn_1 == 0){
			Logger.debug.println(user_id,this,"et_updatePRDT 에러");
           	throw new Exception("et_updatePRDT Error");
        }
  		}catch(Exception e) {

			throw new Exception("et_updatePRDT:"+e.getMessage());
  		} finally{

  		}
		return rtn_1;
	}
	
	private int et_updateCNDT( String exec_no) throws Exception                    
 	{
	   String house_code   = info.getSession("HOUSE_CODE");                    				            	                              
		String user_id      = info.getSession("ID");

 		ConnectionContext ctx = getConnectionContext();
 		String rtn_value = "";

		int rtn_1 = -1;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		/*wxp.addVar("house_code", house_code);
		wxp.addVar("exec_no", exec_no);*/
			
  	try {
  		Map<String, String> data =  new HashMap<String, String>();
   		data.put("exec_no", exec_no);
  		SepoaSQLManager sm = null;
        sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
		rtn_1 = sm.doUpdate(data);
		if(rtn_1 == 0){
			Logger.debug.println(user_id,this,"et_updateCNDT 에러");
          throw new Exception("et_updateCNDT Error");
        }
 		}catch(Exception e) {
  		
			throw new Exception("et_updateCNDT:"+e.getMessage());
 		} finally{

 		}
		return rtn_1;
	}
	
	private int et_insertPRDT( String exec_no) throws Exception                    
 	{
	   String house_code   = info.getSession("HOUSE_CODE");                    				            	                              
		String user_id      = info.getSession("ID");

 		ConnectionContext ctx = getConnectionContext();

 		String rtn_value = "";

		int rtn_1 = -1;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		/*wxp.addVar("house_code", house_code);
		wxp.addVar("exec_no", exec_no);*/
			
  	try {
  		Map<String, String> data =  new HashMap<String, String>();
   		data.put("exec_no", exec_no);
  		SepoaSQLManager sm = null;
	    sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
	    rtn_1 = sm.doInsert(data);
		if(rtn_1 == 0){
			Logger.debug.println(user_id,this,"et_insertPRDT 에러");
	      	throw new Exception("et_insertPRDT Error");
	    }
 		}catch(Exception e) {

			throw new Exception("et_insertPRDT:"+e.getMessage());
 		} finally{

 		}
		return rtn_1;
	}
             
	private int scms_interface( String exec_no, String REQ_TYPE) throws Exception                    
	{
	    String house_code   = info.getSession("HOUSE_CODE");                    				            	                              
		String user_id      = info.getSession("ID");

		ConnectionContext ctx = getConnectionContext();

		String rtn_value = "";
		SepoaSQLManager sm = null;
		SepoaXmlParser wxp = null;
		int rtn_1 = -1;
		try {
			Map<String, String> data =  new HashMap<String, String>();
	   		data.put("exec_no", exec_no);
			if("P".equals(REQ_TYPE)){
				// 1. ICOYPRDT.STATUS = 'D' 인 건에 대해서 TB_SCMS_PR.REPEAT_YN = 'Y' 으로 업데이트을 업데이트 한다.
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_updatePR");
				/*wxp.addVar("house_code", house_code);
				wxp.addVar("exec_no", exec_no);*/
				
				sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
				rtn_1 = sm.doUpdate(data);
				
				// 2. 수정되어 추가된 PR_NO, PR_SEQ를 인서트 한다.
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_insertPR");
				/*wxp.addVar("house_code", house_code);
				wxp.addVar("exec_no", exec_no);*/
				
				sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
				rtn_1 = sm.doInsert(data);
				
				// 3. 인서트되어진 TB_SCM_PR 의 CONSULT_SEQ 를 PRDT.ORDER_SEQ에 업데이트 한다.
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_updateORDER_SEQ");
				/*wxp.addVar("house_code", house_code);
				wxp.addVar("exec_no", exec_no);*/
				
				sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
				rtn_1 = sm.doUpdate(data);
			}else if("B".equals(REQ_TYPE)){
				// 1. ICOYPRDT.STATUS = 'D' 인 건에 대해서 TB_SCMS_BR.REPEAT_YN = 'Y' 으로 업데이트을 업데이트 한다.
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_updateBR");
				/*wxp.addVar("house_code", house_code);
				wxp.addVar("exec_no", exec_no);*/
				
				sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
				rtn_1 = sm.doUpdate(data);
				
				// 2. 수정되어 추가된 PR_NO, PR_SEQ를 인서트 한다.
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_insertBR");
				/*wxp.addVar("house_code", house_code);
				wxp.addVar("exec_no", exec_no);*/
				
				sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
				rtn_1 = sm.doInsert(data);
			}
			
			
         
		}catch(Exception e) {
 		
			throw new Exception("scms_interface:"+e.getMessage());
		} finally{

		}
		return rtn_1;
	}
	
	/**
	 * 매뉴얼 품의가 아닌 것에 한하여 ICOYPRDT.PR_PROCEEDING_FLAG에 UPDATE해준다.
	 * <pre>
	 * </pre>
	 * @param args
	 * @return
	 * @throws Exception
	 */
	private	int	setPRDT(String[][] args)	throws Exception
	{
		int	rtn	= -1;
		String user_id	  =	info.getSession("ID");
		String house_code =	info.getSession("HOUSE_CODE");

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		//wxp.addVar("m_PO_PR_PROCEEDING_FLAG", m_PO_PR_PROCEEDING_FLAG);

		try
		{
			ConnectionContext ctx =	getConnectionContext();

			SepoaSQLManager sm =	null;
			for(int i=0;i<args.length;i++){
				Map<String, String> data =  new HashMap<String, String>();
				data.put("house_code",args[i][0] );
				data.put("doc_no",args[i][1] );
				data.put("m_PO_PR_PROCEEDING_FLAG",m_PO_PR_PROCEEDING_FLAG );
				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());
				

				rtn = sm.doUpdate(data);
			}
			
			/*String[] type_pr = {"S","S"};

			sm.doUpdate(args, type_pr);*/
		}
		catch(Exception	e)
		{
			String serrMessage = e.getMessage();
			String sdbErrorCode	= serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);

			if(sdbErrorCode.equals("ORA-00001")	== true)
			{
				rtn	= -1;
			}
			else
			{
				throw new Exception("setPRDT:"+e.getMessage());
			}
		}
		finally
		{
		}
		return rtn;
	} 
	
	private int scms_interface_complete_BR( String exec_no) throws Exception                    
	{
	    String house_code   = info.getSession("HOUSE_CODE");                    				            	                              
		String user_id      = info.getSession("ID");

		ConnectionContext ctx = getConnectionContext();

		String rtn_value = "";
		SepoaSQLManager sm = null;
		SepoaXmlParser wxp = null;
		int rtn_1 = -1;
		try {
			Map<String, String> data =  new HashMap<String, String>();
			data.put("house_code", house_code);
			data.put("exec_no", exec_no);
			data.put("user_id", user_id);
			// 1. 사전지원요청은 품의결재가 승인될시에 완료된다. BR_STATUS = '5' , 단가, 금액업데이트			
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			
			
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
			rtn_1 = sm.doUpdate(data);
			
			// 2. BR건들이 모두 완료되면 TB_SCM_BR_HEAD.BR_HEAD_STATUS = '5' 로 업데이트
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_HEADER");
			/*wxp.addVar("house_code", house_code);
			wxp.addVar("exec_no", exec_no);
			wxp.addVar("user_id", user_id);*/
			
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
			rtn_1 = sm.doUpdate(data);
	
        
		}catch(Exception e) {
		
			throw new Exception("scms_interface:"+e.getMessage());
		} finally{

		}
		return rtn_1;
	}
	
	/*
	    *  ICOMMTGL이 존재하는 경우에만 단가를 생성한다
	    *
	    *
	    *
	    *
	    */
	         
	     private String checkMtglItem(String exec_no) throws Exception
		{
			String house_code =	info.getSession("HOUSE_CODE");
			String rtn = "";

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			/*wxp.addVar("house_code", house_code);
			wxp.addVar("exec_no", exec_no);*/
			
			try
			{
				Map<String, String> data =  new HashMap<String, String>();
				data.put("house_code", house_code);
				data.put("exec_no", exec_no);
				ConnectionContext ctx =	getConnectionContext();

				SepoaSQLManager sm =	null;
				
				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());
			 
			    rtn = sm.doSelect(data);			
			}
			catch(Exception	e)
			{
					throw new Exception("checkMtglItem:"+e.getMessage());
			}
			return rtn;
		} 
	     
	     /**
	 	 * 단가테이블 정보를 레벨별로 삭제한다.
	 	 * <pre>
	 	 * 
	 	 * DELETE ICOYINFO, ICOYINDR
	 	 * 레벨별 삭제 로직
	 	 * RQOP.PURCHASE_LEVEL
	 	 * '1'이라면 통합구매를 의미한다.
	 	 * 기존 ICOYINFO, ICOYINDR 에 해당하는 자재는 모두 삭제된다.
	 	 * '2'이라면 회사별 구매를 의미한다.
	 	 * 기존 ICOYINFO, ICOYINDR 의 레벨 1과 해당 회사의 레벨 2, 3에 해당하는 것들을 모두 지운다.
	 	 * '3'이라면 사업장별 구매를 의미한다.
	 	 * 기존 ICOYINFO, ICOYINDR 의 레벨 1과 해당 회사의 레벨2, 그리고 레벨3의 구매지역에 해당하는 것을 지운다.
	 	 * </pre>
	 	 * @param args
	 	 * @throws Exception
	 	 */
	 	 
	 	private	void delInfoData(String[] args) throws Exception
	 	{
	 		int	rtn	= -1;
	 		String user_id	  =	info.getSession("ID");
	 		String house_code =	info.getSession("HOUSE_CODE");
	 		ConnectionContext ctx =	getConnectionContext();

	 		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
	 		Map<String, String> data =  new HashMap<String, String>();				
	 		try
	 		{
	 			data.put("house_code", args[0]);
	 			data.put("exec_no", args[1]);
	 			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	 			String val = sm.doSelect(data);
	 			
	 			SepoaFormater wf	= new SepoaFormater(val);

	 			int iRowCount = wf.getRowCount();
	 			String item_no           = "";
	 			String company_code      = "";
	 			String vendor_code       = "";
	 			String purchase_location = "";
	 			String purchase_level    = "";
	 			String shipper_type      = "";
	 			String price_type        = "";

	 			if(iRowCount<1)
	 			{
	 				throw new Exception("해당 품의건이 없습니다.");
	 			}

	 			for(int i=0;i<iRowCount;i++)
	 			{
	 				Map<String, String> data_1 =  new HashMap<String, String>();	
	 				item_no           = wf.getValue("ITEM_NO",i);
	 				company_code      = wf.getValue("COMPANY_CODE",i);
	 				vendor_code       = wf.getValue("VENDOR_CODE",i);
	 				purchase_location = wf.getValue("PURCHASE_LOCATION",i);
	 				purchase_level    = wf.getValue("PURCHASE_LEVEL",i);
	 				shipper_type      = wf.getValue("SHIPPER_TYPE",i);
	 				price_type        = wf.getValue("PRICE_TYPE",i);
	 				
	 				Logger.debug.println(info.getSession("ID"), this, "item_no="+item_no);
	 				Logger.debug.println(info.getSession("ID"), this, "company_code="+company_code);
	 				Logger.debug.println(info.getSession("ID"), this, "vendor_code="+vendor_code);
	 				Logger.debug.println(info.getSession("ID"), this, "purchase_location="+purchase_location);
	 				Logger.debug.println(info.getSession("ID"), this, "purchase_level="+purchase_level);
	 				
	 				//INFO,INDR,INPR DELETE
	 				    StringBuffer INFO1 = new StringBuffer();
	 					StringBuffer INDR1 = new StringBuffer();
	 					StringBuffer INPR1 = new StringBuffer();
	 					data_1.put("company_code", company_code);
	 					data_1.put("vendor_code", vendor_code);
	 					data_1.put("purchase_location", purchase_location);
	 					SepoaXmlParser wxp2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
	 					/*wxp2.addVar("company_code", company_code);
	 					wxp2.addVar("vendor_code", vendor_code);
	 					wxp2.addVar("purchase_location", purchase_location);*/
	 					
	 					SepoaXmlParser wxp3 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
	 					/*wxp3.addVar("company_code", company_code);
	 					wxp3.addVar("vendor_code", vendor_code);
	 					wxp3.addVar("purchase_location", purchase_location);*/

	 					/*String[][] args1 = {
	 						{ house_code, item_no }
	 					};
	 					String[] type1 = {"S","S"};*/
	 					data_1.put("house_code", house_code);
	 					data_1.put("item_no", item_no);
	 					
	 					sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp2.getQuery());
	 					sm.doDelete(data_1);
	 					
	 					sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp3.getQuery());
	 					sm.doDelete(data_1);
	 					
	 			}
	 		}
	 		catch(Exception	e)
	 		{
	 			throw new Exception("delInfoData:"+e.getMessage());
	 		}
	 		
	 	}
	 	
	 	/**
		 * 단가정보를 생성한다.
		 * <pre>
		 * ICOYINFO, ICOYINDR을 생성한다.
		 * ICOYINDR.CUM_PO_QTY는 나중에 업데이트함에 유의한다.
		 * </pre>
		 * @param args
		 * @throws Exception
		 */
		private	void createInfoData(String[][] args) throws Exception
		{
			int	rtn	= -1;
			String user_id	  =	info.getSession("ID");
			String house_code =	info.getSession("HOUSE_CODE");
			ConnectionContext ctx =	getConnectionContext();
			
		
			String add_date     = SepoaDate.getShortDateString();
			String add_time     = SepoaDate.getShortTimeString();                               

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			SepoaXmlParser wxp2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			
			try
			{
				//String[] type1 = { "S","S"};
				for(int i=0;i<args.length;i++){
					Map<String, String> data =  new HashMap<String, String>();
					data.put("house_code",args[i][0] );
					data.put("doc_no",args[i][1] );
					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());
					rtn = sm.doInsert(data);
					if(rtn<1)
						throw new Exception("INSERT ICOYINFO ERROR");
					
					sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp2.getQuery());
					rtn = sm.doInsert(data);
					if(rtn<1)
						throw new Exception("INSERT ICOYINDR ERROR");
				}
			}
			catch(Exception e)
			{
				throw new Exception(e.getMessage());
			}
		}
		
		/**
		 * 단가정보에 대한 히스토리를 생성한다.
		 * @param args
		 * @throws Exception
		 */
		private	void createInfhData(String[][] args) throws Exception
		{
			ConnectionContext ctx =	getConnectionContext();
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			
			try
			{
				for(int i=0;i<args.length;i++){
					Map<String, String> data =  new HashMap<String, String>();
					data.put("house_code",args[i][0] );
					data.put("doc_no",args[i][1] );
					//String[] type1 = { "S","S" };
					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());
					sm.doInsert(data);
				}
				
			}
			catch(Exception e)
			{
				throw new Exception(e.getMessage());
			}

		}
		
		
		/*
		    * 	통합품의 결재시.
		    * */
		   private SepoaOut et_ApprovalTEX(SignResponseInfo inf) throws Exception
		   {	
			   	String user_id		 = info.getSession("ID");
				String house_code	 = info.getSession("HOUSE_CODE");
				String location_code = info.getSession("LOCATION_CODE");
				String department	 = info.getSession("DEPARTMENT");
				String name_loc		 = info.getSession("NAME_LOC");
				String name_eng		 = info.getSession("NAME_ENG");
				String language		 = info.getSession("LANGUAGE");
				String add_date     = SepoaDate.getShortDateString();
				String add_time     = SepoaDate.getShortTimeString();
				Logger.debug.println(user_id,this,"############## p2017.ApprovalTEX Start ################");
			   	try{
			   		String sign_status	= inf.getSignStatus();
					String doc_type     = inf.getDocType(); // 품의에서 넘어	왔는지 계약금 쪽에서 넘어 왔는 Check.
					String sign_date	= inf.getSignDate();
					String sign_user_id	= inf.getSignUserId();
					
					String[] DOC_NO	      = inf.getDocNo();
					String[] DOC_SEQ	  = inf.getDocSeq();
					String[] SHIPPER_TYPE = inf.getShipperType();
					
					
					Logger.debug.println(user_id,this,"############## ApprovalTEX SignStatus ==> " + sign_status);
					
					int rtn_tnhd = -1;

					int iDocCount = DOC_NO.length;
					String[][] objTNHD	  =	new	String[iDocCount][];
					
					for(int	i=0;i <	DOC_NO.length;i++)
					{
						String[] TEMP_TNHD = {
							  sign_status
							, sign_date
							, sign_user_id
							, house_code
							, DOC_NO[i]
						};
						
						objTNHD[i] = TEMP_TNHD;
					}
					
					
		            
					rtn_tnhd = setTnhdUpdate(objTNHD);
					
					setStatus(1);
					setMessage("");
					
					//반려이거나 취소일 경우 여기서 끝낸다.
					//if(sign_status!="E")
					if(!"E".equals(sign_status))
					{
						return getSepoaOut();
					}
					
					// 결재완료후에 할 일들...없당...

				}
				catch(Exception	e)
				{
					throw new Exception("et_ApprovalTEX error"+e.getMessage());
				}
				
				return getSepoaOut();
			}
		   
   /**
	 * 통합품의 헤더정보에 결재정보를 update해준다.
	 * <pre>
	 * </pre>
	 * @param args
	 * @return
	 * @throws Exception
	 */
	private	int setTnhdUpdate(String[][] args) throws Exception
	{
		int rtn = -1;
		String user_id = info.getSession("ID");
		
		try
		{
			ConnectionContext ctx =	getConnectionContext();

			for(int i=0;i<args.length;i++){
				Map<String, String> data =  new HashMap<String, String>();
				data.put("sign_status",args[i][0] );
				data.put("sign_date",args[i][1] );
				data.put("sign_user_id",args[i][2] );
				data.put("house_code",args[i][3] );
				data.put("doc_no",args[i][4] );
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				SepoaSQLManager sm =	new	SepoaSQLManager(user_id,this,ctx, wxp.getQuery());
				//String[] type1 = {"S","S","S","S","S"};
				rtn = sm.doUpdate(data);
			}

		}
		catch(Exception	e)
		{
			throw new Exception("setTnhdUpdate:"+e.getMessage());
		}
		
		return rtn;
	}
	
	
	/**계약서
	 * <b>계약 결재를 승인한다.</b>
	 * <pre>
	 * et_Approval을 호출한다.
	 * </pre>
	 * @param inf
	 * @return
	 */
	public SepoaOut Approval_5(SignResponseInfo inf)
	{
		String user_id		 = info.getSession("ID");
		SepoaOut value = null;
	
		try
		{
			
			Logger.debug.println(user_id, this, "start time = "+System.currentTimeMillis());
			if("CT".equals(inf.getDocType())){			// 계약결재 승인
				value = et_Approval_5(inf);
				
			}
			try{
				if(value != null && value.status == 0){
					Logger.debug.println(user_id, this, "end time = "+System.currentTimeMillis());
					
					//mail전송
					/*String[] DOC_NO	      = inf.getDocNo();
					String[] DOC_SEQ	  = inf.getDocSeq();
					
					for(int v1=0; v1 < DOC_NO.length; v1++){
						String[][] args = new String[1][2];
						args[0][0] = DOC_NO[v1];	// CONT_SEQ
						args[0][1] = DOC_SEQ[v1];	//CONT_COUNT
						ServiceConnector.doService(info, "mail", "CONNECTION", "M00009", new Object[]{args});
					}*/
				}
			}catch(NullPointerException ne){
				Logger.debug.println(user_id, this, ne.getMessage());
			}
		}
		catch(Exception e)
		{
			Logger.debug.println(user_id, this, "end time = "+System.currentTimeMillis());
			Logger.debug.println(user_id, this, "***************Exception***************");
			Logger.debug.println(user_id, this, "Exception Message = "+e.getMessage());
			Logger.debug.println(user_id, this, "***************Exception***************");
			try
			{
				Rollback();
			}
			catch(Exception re)
			{
				Logger.debug.println(user_id, this, re.getMessage());
			}
		}
		
		return value;
	}
	
	
	
	/**
	 * 결재완료 처리
	 * @param inf
	 * @return
	 * @throws Exception
	 */
	private SepoaOut et_Approval_5(SignResponseInfo inf) throws Exception
	{
		String user_id		 = info.getSession("ID");
		String house_code	 = info.getSession("HOUSE_CODE");
		String location_code = info.getSession("LOCATION_CODE");
		String department	 = info.getSession("DEPARTMENT");
		String name_loc		 = info.getSession("NAME_LOC");
		String name_eng		 = info.getSession("NAME_ENG");
		String language		 = info.getSession("LANGUAGE");
		String add_date     = SepoaDate.getShortDateString();
		String add_time     = SepoaDate.getShortTimeString();
		Logger.debug.println(user_id,this,"############## p1061.Approval Start ################");
		
		try
		{
            String user_dept      = info.getSession("DEPARTMENT");

			String sign_status	= inf.getSignStatus();
			String doc_type     = inf.getDocType(); // 품의에서 넘어	왔는지 계약금 쪽에서 넘어 왔는 Check.
			String sign_date	= inf.getSignDate();
			String sign_user_id	= inf.getSignUserId();
			
			String[] DOC_NO	      = inf.getDocNo();
			String[] DOC_SEQ	  = inf.getDocSeq();
			String[] SHIPPER_TYPE = inf.getShipperType();
			
			int	rtn_prdt = -1;
			int rtn_cnhd = -1;
			
			Logger.debug.println(user_id,this,"############## Approval SignStatus ==> " + sign_status);
			
			int rtn_ecct = -1;

			int iDocCount = DOC_NO.length;
			String[][] objECCT	  =	new	String[iDocCount][];
			
			/*
			 * 1) 결재 상태값 변경 처리.
			 */
			for(int	i=0;i <	DOC_NO.length;i++)
			{
				String[] TEMP_ECCT = {
					  sign_status
					, house_code
					, DOC_NO[i]
				    , DOC_SEQ[i]
				};
				
				objECCT[i] = TEMP_ECCT;
			}
			
			rtn_ecct = setECCTUpdate(objECCT);
			
			setStatus(1);
			setMessage("");
			
			//EXIT => 반려이거나 취소일 경우 여기서 끝낸다.
			//if(sign_status!="E")
			if(!"E".equals(sign_status))
			{
				return getSepoaOut();
			}
			
			
			String[] rtnExecStr = getExec_No(DOC_NO, DOC_SEQ);
			
			/*
			 * 2) 결재완료 후 처리.
			 */
			for(int	i=0;i <	rtnExecStr.length;i++)
			{
				String[][] objPrdt = { {house_code, rtnExecStr[i]} };
				String[][] objInfo = { 
						{
							house_code
							, rtnExecStr[i]
						} 
				};
				String[][] objInfh = { 
						{
							house_code
							, rtnExecStr[i]
						} 
				};
				
				String[] objExecInfo = {house_code, rtnExecStr[i]};
				
				String rtn_mtgl="";
				String rtn_prtype="";
				
				
				/**
				 * 품의결재 승인시에
				 * 품의생성시 소싱결과에 대해서 수정이 있는경우  
				 * 1.CNDT 기존 PR_NO, PR_SEQ : STATUS = 'D'   인것들은 ICOYPRDT테이블에도 STATUS = 'D' 로 업데이트 쳐주고, PR_PROCEEDING_FLAG = 'R' 로 업데이트
				 * 2.CNDT 에 새로 추가된 건들은 PR_NO, STATUS != 'D' 의 것들을 MAX(PR_SEQ_ +10 로 CNDT에 업데이트하고 PRDT에 인서트한다.
				 * 3.영업관리의 PR테이블에도 새로추가된 건들은 인서트 하고 STATUS = 'D' 인 것들은 REPEAT_YN = 'Y' 로 업데이트 쳐준다.
				 * 4-1.구매요청인 경우 추가된 TB_SCM_PR 테이블의 CONSULT_NO, CONSULT_DGR, CONSULT_SEQ 의 값을 ICOYPRDT의 ORDER_NO, ORDER_COUNT, ORDER_SEQ에 업데이트
				 * 4-2.사전지원요청인 경우 TB_SCM_BR에 PR_STATUS = '5' (완료)로 업데이트친다.
				 */
				
				//1. 수정사항이 있는지 체크 CNDT.STASUS = 'D' AND CNDT.PR_SEQ IS NULL 인것이 있는지 찾는다.
				Configuration conf = new Configuration();
				String exec_no = rtnExecStr[i];				
				String rtn_modified = et_getModified_5(exec_no);
				SepoaFormater wf_modified = new SepoaFormater(rtn_modified);
                int STATUS_D_CNT 	= Integer.parseInt(wf_modified.getValue("STATUS_D_CNT", 0));
                int PR_SEQ_NULL_CNT = Integer.parseInt(wf_modified.getValue("PR_SEQ_NULL_CNT", 0));
                String REQ_TYPE		= wf_modified.getValue("REQ_TYPE", 0);
                String PO_TYPE		= wf_modified.getValue("PO_TYPE", 0);
                String PREFERRED_BIDDER = wf_modified.getValue("PREFERRED_BIDDER", 0);
                if(STATUS_D_CNT != 0 && PR_SEQ_NULL_CNT != 0){
                	//2. ICOYPRDT 에 CNDT.STATUS = 'D' 인 PR_NO, PR_SEQ건에 대해서 PRDT.STATUS = 'D', PRDT.PR_PROCEEDING_FLAG = 'R' 로 업데이트
                	int rtn_updatePRDT = et_updatePRDT(exec_no);
                	//3. ICOYCNDT 에 CNDT.PR_SEQ 값을 MAX(PR_SEQ) + 10으로 업데이트한다.
                	int rtn_updateCNDT = et_updateCNDT(exec_no);
                	//4. ICOYPRDT 에 CNDT.STATUS != 'D' 가 아닌건들을 인서트한다.
                	int rtn_insertPRDT = et_insertPRDT(exec_no);
                	//5. 영업관리 인터페이스 IF_FLAG 가 'Y' 인경우에..                	                	
    	        	if(conf.getBoolean("sepoa.scms.if_flag")){
    	        		int rtn_interface = scms_interface(exec_no, REQ_TYPE);
    	        	}
                }
                
                //우선협상품의인 경우에도 품의수정이 가능하므로 수정건만 반영하고  구매접수현황으로 보낸다.
				if("Y".equals(PREFERRED_BIDDER)){
					Logger.debug.println("============================= 우선협상품의결재최종승인 ===============================");
					//우선협상품의 : PR_PROCEEDING_FLAG = 'P'
					m_PO_PR_PROCEEDING_FLAG = "P";
					rtn_prdt = setPRDT(objPrdt);
					continue;
				}
				
                //사전지원인경우에는 품의결재완료시 TB_SCM_BR.PR_STATUS = '5'(완료) 업데이트 쳐준다. 사전품의에서 변경된 예상단가, 예상금액을 넘겨준다.
                //TB_SCM_BR의 완료여부를 체크하여 모두 완료(BR.REPEAT_YN != 'Y' 가 아닌건들이 모두 PR_STATUS = '5'일때)되었을경우에 TB_SCM_BR_HEAD.BR_HEAD_STATUS = '5'
				if("B".equals(REQ_TYPE)){
					if(conf.getBoolean("sepoa.scms.if_flag")){
						int rtn_interface = scms_interface_complete_BR(exec_no);
					}
				}
				
				
				// PRDT 업데이트 일반품의 : PR_PROCEEDING_FLAG = 'B',     우선협상품의 : PR_PROCEEDING_FLAG = 'P'
				Logger.debug.println("============================= 일반품의결재최종승인 ===============================");
				m_PO_PR_PROCEEDING_FLAG = "B";
				rtn_prdt = setPRDT(objPrdt);
                
				//ICOMMTGL이 존재하는 경우에만 단가를 생성한다// 건수가 0 인경우도 존재할수 있음
				//품의생성시 품의구분이 단가계약일때 단가를 생성한다.
                rtn_mtgl =checkMtglItem(rtnExecStr[i]);
				
                SepoaFormater  wf =  new SepoaFormater(rtn_mtgl);
                
                int iRowCount = wf.getRowCount();
                if(iRowCount>0) {
                	rtn_mtgl = wf.getValue("CNT", 0);
                }
                
                // ICOMMTGL이 존재하는 경우에만 단가를 생성한다 if end
                //if(!rtn_mtgl.equals("0") && "P".equals(REQ_TYPE)){ // 사전지원단계의 정보는 가격정보로서 관리하지 않는다.
                if(!rtn_mtgl.equals("0")){ // 사전지원단계의 정보도 가격정보로서 관리한다. 20100716			
					//레벨별 단가삭제(DELETE ICOYINFO, ICOYINDR, ICOYINPR)
					delInfoData(objExecInfo);
					//새로운  단가생성(INSERT ICOYINFO, ICOYINDR)
					createInfoData(objInfo);
					//ICOYINFH(히스토리 테이블) 생성
					createInfhData(objInfh);
                }
                
                /*
                 * 3) 발주 생성 처리.
                 *   - 구매요청건만 발주처리 합니다.
                 *   - 연간단가 발주인 경우 PROPERTIES의 연간단가 발주 여부에 따라 발주처리를 합니다.
                 */
                if(REQ_TYPE.equals("P") && ( PO_TYPE.equals("N") || ( conf.getBoolean("sepoa.contract.po.yn") && PO_TYPE.equals("U")))){
	                String rtnVendorList = getVendorList(DOC_NO[i], DOC_SEQ[i]);
	                SepoaFormater wf_rtnVendorList = new SepoaFormater(rtnVendorList);
	                if(wf_rtnVendorList.getRowCount() < 1){
	                	Rollback();
	                	throw new Exception("발주 생성에 실패했습니다.");
	                }
	    			String[] erpPro_result = new String[2];
	    			String[] erpPJT_result = new String[2];
	    			String[] erpPo_result  = new String[2];
	                //기안번호 별로 발주 처리를 합니다.
	                for(int v1=0; v1 < wf_rtnVendorList.getRowCount(); v1++){
	                	
	                	String vendor_code = wf_rtnVendorList.getValue("VENDOR_CODE", v1);
//	                	SepoaOut wo = appcommon.getDocNumber(info, "POD");
	                	SepoaOut so = DocumentUtil.getDocNumber(info,"POD");  // 발주번호 생성.
//	    	            po_no = so.result[0];
	    	            String po_no = so.result[0];
	                	
	                	//PODT 생성.
	                	int rtn = insertICOYPODT(rtnExecStr[i], po_no, vendor_code);
	
	                	if(rtn < 1){
	                		throw new Exception();
	                	}
	                	
	                	//계약서에 PO_NO 업데이트
	        			rtn_ecct = setECCTUpdatePO(DOC_NO[i], DOC_SEQ[i], po_no);
	        			
	                	if(rtn_ecct < 1){
	                		throw new Exception();
	                	}        	
	                	
	                	//in_update_goods_group
	                	int rtn2 = in_update_goods_group(po_no);
	                	if(rtn2 == 0){
	                		Rollback();
	                		setStatus(0);
	                		//setMessage(msg.getMessage("9003"));
	                		return getSepoaOut();
	                	}
	                	
	                	//in_ICOYINDR
	                	int dr = in_ICOYINDR(po_no, vendor_code);
	                	
	                	//POHD생성
	                	int rtnPoHd = insertICOYPOHD(rtnExecStr[i], po_no, vendor_code);
	                
	                	//setPRDT
	        			int rtnPRDT = setPRDT(po_no);
	                    if(rtnPoHd == 0){
	                        Rollback();
	                        setStatus(0);
	                        //setMessage(msg.getMessage("4000"));
	                        return getSepoaOut();
	                    }
	                    
	                    // if를 만들어 sepoa.erp.if_flag=false 로 돌아 가지 않게 막음
	                    if(conf.getBoolean("sepoa.erp.if_flag")){
	                    	
			    			//ERPInterface erpIF = new ERPInterface("CONNECTION",info);
			    			// 품목 I / F (신규등록)
			    			//erpPro_result =  erpIF.erpProInsert(getERPProList(po_no));
			    			// 프로젝트 납품품목 I / F (신규등록)
			    			//erpPJT_result =  erpIF.erpPJTInsert(getERPPJTList(po_no));	
			    			// 발주 I / F (신규등록)
			    			//erpPo_result = erpIF.erpPOInsert(getERPPOList(po_no),"A");
	                    }
		    			if(/*!erpPro_result[0].equals("2") && 
		    			   !erpPJT_result[0].equals("2") &&
		    			   !erpPo_result[0].equals("2")*/ !conf.getBoolean("sepoa.erp.if_flag")){//원래 조건 대신 !conf.getBoolean("sepoa.erp.if_flag")를 추가하여 commit기능 하게함
		    				Commit();
		    				// 계약서 결제 완료 mail 전송
		    				String[][] args_ct = {{DOC_NO[i],DOC_SEQ[i]}};		    				
	  	                    //mail 전송 (계약서 완료시)
		                    //ServiceConnector.doService(info, "mail", "CONNECTION", "M00009", new Object[]{args_ct});
		    				
		                    String[] args = {po_no}; 
		                 
		                    //SMS 전송 (발주시)
		                   // ServiceConnector.doService(info, "SMS", "TRANSACTION", "S00008", new Object[]{args, "T"});
		                    
	  	                    //mail 전송 (발주시)
		                    //ServiceConnector.doService(info, "mail", "CONNECTION", "M00008", new Object[]{args, "T"});
		    			}else {
		    				Rollback();
		    				setStatus(0);
		    				if(conf.getBoolean("sepoa.erp.if_flag")){ //if를 추가하여 sepoa.erp.if_flag=false 로 돌아 가지 않게 막음
			    				if(erpPro_result[0].equals("2")){
			    					setMessage(erpPro_result[1]);
			    				}else if(erpPJT_result[0].equals("2")){
			    					setMessage(erpPJT_result[1]);
			    				}else{
			    					setMessage(erpPo_result[1]);
			    				}
		    				}
		    			}
	                }
                }     
			}	
		}
		catch(Exception	e)
		{
			Rollback();
			throw new Exception("et_Approval error"+e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	//계약서 결재완료처리
	private int setECCTUpdate(String[][] objECCT) throws Exception{
		int rtn = -1;
		String user_id = info.getSession("ID");
		
		try
		{
			ConnectionContext ctx =	getConnectionContext();
			for(int i=0;i<objECCT.length;i++){
				Map<String, String> data =  new HashMap<String, String>();
				data.put("sign_status",objECCT[i][0] );
				data.put("house_code",objECCT[i][1] );
				data.put("doc_no",objECCT[i][2] );
				data.put("doc_seq",objECCT[i][3] );
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				SepoaSQLManager sm =	new	SepoaSQLManager(user_id,this,ctx, wxp.getQuery());
			
				//String[] type1 = {"S","S","S","S"};
				rtn = sm.doUpdate(data);
			}

		}
		catch(Exception	e)
		{
			throw new Exception("setCnhdUpdate:"+e.getMessage());
		}
		
		return rtn;
	}
	
	private String[] getExec_No(String[] DOC_NO, String[] DOC_SEQ) throws Exception
	{
		ConnectionContext ctx = getConnectionContext();
		
		SepoaSQLManager sm = null;
		SepoaFormater wf = null;
		String[] ExecNo;
		
		String user_id    = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");
		
		try {
			Map<String, String> data =  new HashMap<String, String>();
			String strParam = ""; 
			for(int v1=0; v1 < DOC_NO.length; v1++){
				if(v1 !=0){
					strParam += " UNION ALL ";
				}
				 
				strParam += "SELECT '" + DOC_NO[v1] + "', '" + DOC_SEQ[v1] + "' FROM DUAL"; 
			}
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			/*wxp.addVar("HOUSE_CODE"	, house_code);
			wxp.addVar("strParam"	, strParam);*/
			data.put("house_code"	, house_code);
			data.put("strParam"	, strParam);
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp);
			
			String rtnSql = sm.doSelect(data);
			wf = new SepoaFormater(rtnSql);
			ExecNo = wf.getValue("EXEC_NO");
			
		}catch(Exception e) {
			throw new Exception("getExec_No:"+e.getMessage());
		}
		finally{
		}
		return ExecNo;
	}//setPRDT end
	
	private	String et_getModified_5(String exec_no) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		String[] args = null;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			/*wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("exec_no", exec_no);*/

		try {
			Map<String, String> data =  new HashMap<String, String>();
			data.put("house_code", info.getSession("HOUSE_CODE"));
			data.put("exec_no", exec_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn = sm.doSelect(data);

		}catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	/*
	 * 기안의 VENDOR_CODE 리스트를 가져와 업체별로 발주처리를 합니다. 
	 */
	private	String getVendorList(String cont_seq, String cont_count) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		String[] args = null;
		
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		/*wxp.addVar("HOUSE_CODE", info.getSession("HOUSE_CODE"));
		wxp.addVar("CONT_SEQ", cont_seq);
		wxp.addVar("CONT_COUNT", cont_count);
		wxp.addVar("USER_ID", info.getSession("ID"));*/
		
		try {
			Map<String, String> data =  new HashMap<String, String>();
			data.put("house_code", info.getSession("HOUSE_CODE"));
			data.put("cont_seq", cont_seq);
			data.put("cont_count", cont_count);
			data.put("user_id", info.getSession("ID"));
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn = sm.doSelect(data);
			
		}catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	/*
	 * 발주데이터 생성을 합니다.
	 * ICOYPODT 
	 */
	private	int insertICOYPODT(String exec_no, String po_no, String vendor_code) throws Exception {
		int rtn = -1;
		int rtn_cndt = -1;
		ConnectionContext ctx = getConnectionContext();
		String[] args = null;
		
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		/*wxp.addVar("HOUSE_CODE", info.getSession("HOUSE_CODE"));
		wxp.addVar("USER_ID", info.getSession("ID"));
		wxp.addVar("COMPANY_CODE", info.getSession("COMPANY_CODE"));
		wxp.addVar("EXEC_NO", exec_no);
		wxp.addVar("VENDOR_CODE", vendor_code);
		wxp.addVar("PO_NO", po_no);*/
		
		SepoaXmlParser wxp_cndt = new SepoaXmlParser(this, "updateCNDTPOSEQ");
		/*wxp_cndt.addVar("HOUSE_CODE", info.getSession("HOUSE_CODE"));
		wxp_cndt.addVar("EXEC_NO", exec_no);
		wxp_cndt.addVar("VENDOR_CODE", vendor_code);
		wxp_cndt.addVar("PO_NO", po_no);*/
		
		try {
			Map<String, String> data =  new HashMap<String, String>();
			data.put("house_code", info.getSession("HOUSE_CODE"));
			data.put("user_id", info.getSession("ID"));
			data.put("company_code", info.getSession("COMPANY_CODE"));
			data.put("exec_no", exec_no);
			data.put("vendor_code", vendor_code);
			data.put("po_no", po_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn = sm.doInsert(data);

			SepoaSQLManager sm_cndt = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp_cndt.getQuery());
			rtn_cndt = sm_cndt.doUpdate(data);
			
		}catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
//계약서에 PO_NO 업데이트
	private int setECCTUpdatePO(String cont_seq, String cont_count, String po_no) throws Exception{
		int rtn = -1;
		String user_id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");
		
		try
		{
			ConnectionContext ctx =	getConnectionContext();
			Map<String, String> data =  new HashMap<String, String>();
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("house_code", house_code);
			data.put("cont_seq", cont_seq);
			data.put("cont_count", cont_count);
			data.put("po_no", po_no);
			/*wxp.addVar("HOUSE_CODE", house_code);
			wxp.addVar("CONT_SEQ", cont_seq);
			wxp.addVar("CONT_COUNT", cont_count);
			wxp.addVar("PO_NO", po_no);*/
			SepoaSQLManager sm =	new	SepoaSQLManager(user_id,this,ctx, wxp.getQuery());
			
			rtn = sm.doUpdate(data);
			
		}
		catch(Exception	e)
		{
			throw new Exception("setCnhdUpdate:"+e.getMessage());
		}
		
		return rtn;
	}
	
	private int in_update_goods_group(String po_no) throws Exception{

    	int rtn = -1;
			ConnectionContext ctx = getConnectionContext();
		try
		{
			Map<String, String> data =  new HashMap<String, String>();
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
	        /*wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
	        wxp.addVar("po_no", po_no);*/
	        data.put("house_code", info.getSession("HOUSE_CODE"));
	        data.put("po_no", po_no);
	        SepoaSQLManager sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
			String rtnSelect = sm.doSelect( data );
			SepoaFormater wf = new SepoaFormater( rtnSelect );

			if ( wf.getRowCount() > 0 )
			{
				String goods_group = wf.getValue( 0, 0 );
				
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
				data.put("goods_group", goods_group);
				/*wxp.addVar("goods_group", goods_group);
				wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
				wxp.addVar("po_no", po_no);*/

				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				rtn = sm.doInsert(data);
			}
		}
		catch(Exception e)
		{
			throw new Exception("in_update_goods_group:"+e.getMessage());
		}
		finally
		{
		}
		return rtn;
	}
	
	/*
	 * 배분정보입력.
	 */
	private	int in_ICOYINDR(String po_no, String vendor_code) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		String[] args = null;
		Map<String, String> data =  new HashMap<String, String>();
		SepoaXmlParser wxpGet = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_List");
		data.put("house_code", info.getSession("HOUSE_CODE"));
		data.put("user_id", info.getSession("ID"));
		data.put("vendor_code", vendor_code);
		data.put("po_no", po_no);
		/*wxpGet.addVar("HOUSE_CODE", info.getSession("HOUSE_CODE"));
		wxpGet.addVar("USER_ID", info.getSession("ID"));
		wxpGet.addVar("VENDOR_CODE", vendor_code);
		wxpGet.addVar("PO_NO", po_no);*/
		
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		/*wxp.addVar("HOUSE_CODE", info.getSession("HOUSE_CODE"));
		wxp.addVar("VENDOR_CODE", vendor_code);
		wxp.addVar("PO_NO", po_no);*/
		
		try {
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxpGet.getQuery());
			String rtnStr = sm.doSelect(data);
			SepoaFormater wf = new SepoaFormater(rtnStr);
			
			String indrData[][] = new String[wf.getRowCount()][];  
			for(int v1=0; v1 < wf.getRowCount(); v1++){
				/*String indrTemp[] ={
						  wf.getValue("ITEM_QTY", v1),
						  wf.getValue("CHANGE_DATE", v1),
						  wf.getValue("CHANGE_TIME", v1),
						  wf.getValue("USER_ID", v1),
						  wf.getValue("HOUSE_CODE", v1),
						  wf.getValue("VENDOR_CODE", v1),
						  wf.getValue("ITEM_NO", v1)
				};
				indrData[v1] = indrTemp; */
				Map<String, String> data_1 =  new HashMap<String, String>();
				/*data_1.put("house_code", info.getSession("HOUSE_CODE"));
				data_1.put("vendor_code", vendor_code);
				data_1.put("po_no", po_no);*/
				data_1.put("item_qty",wf.getValue("ITEM_QTY", v1));
				data_1.put("change_date",wf.getValue("CHANGE_DATE", v1));
				data_1.put("change_time",wf.getValue("CHANGE_TIME", v1));
				data_1.put("user_id",wf.getValue("USER_ID", v1));
				data_1.put("house_code",wf.getValue("HOUSE_CODE", v1));
				data_1.put("vendor_code",wf.getValue("VENDOR_CODE", v1));
				data_1.put("item_no",wf.getValue("ITEM_NO", v1));
				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				rtn = sm.doUpdate(data_1);
			}
            
			
			
		}catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	/*
	 * 발주데이터 생성을 합니다.
	 * ICOYPOHD
	 */
	private	int insertICOYPOHD(String exec_no, String po_no, String vendor_code) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		String[] args = null;
		
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		/*wxp.addVar("HOUSE_CODE", info.getSession("HOUSE_CODE"));
		wxp.addVar("USER_ID", info.getSession("ID"));
		wxp.addVar("COMPANY_CODE", info.getSession("COMPANY_CODE"));
		wxp.addVar("EXEC_NO", exec_no);
		wxp.addVar("VENDOR_CODE", vendor_code);
		wxp.addVar("PO_NO", po_no);*/
		
		try {
			Map<String, String> data =  new HashMap<String, String>();
			data.put("house_code", info.getSession("HOUSE_CODE"));
			data.put("user_id", info.getSession("ID"));
			data.put("company_code", info.getSession("COMPANY_CODE"));
			data.put("exec_no", exec_no);
			data.put("vendor_code", vendor_code);
			data.put("po_no", po_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn = sm.doInsert(data);
			
		}catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	private int setPRDT(String po_no) throws Exception
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();

        SepoaSQLManager sm = null;
        SepoaFormater wf = null;

        String user_id    = info.getSession("ID");
        String house_code = info.getSession("HOUSE_CODE");

        try {

        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
        	Map<String, String> data =  new HashMap<String, String>();
			data.put("house_code", house_code);
			data.put("po_no", po_no);
        	/*wxp.addVar("house_code"	, house_code);
            wxp.addVar("po_no"		, po_no);*/
            sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
            String rtnSql = sm.doSelect(data);
            wf = new SepoaFormater(rtnSql);

                for( int i = 0 ; i < wf.getRowCount(); i++ )
                {
                	Map<String, String> data_1 =  new HashMap<String, String>();
                    String pr_no = wf.getValue( i,0 );
                    String pr_seq = wf.getValue( i,1 );

                    wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
                    data_1.put("house_code", house_code);
        			data_1.put("pr_no", pr_no);
        			data_1.put("pr_seq", pr_seq);
                    /*wxp.addVar("house_code"	, house_code);
                    wxp.addVar("pr_no"		, pr_no);
                    wxp.addVar("pr_seq"		, pr_seq);*/

                    sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
                    rtn = sm.doInsert(data_1);
                }

        }catch(Exception e) {
            throw new Exception("setPRDT:"+e.getMessage());
        }
        finally{
        }
        return rtn;
    }//setPRDT end
	
	private SepoaFormater getERPProList(String po_no) throws Exception {
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		SepoaFormater wf = null;
		try{
			ConnectionContext ctx =	getConnectionContext();
			//현재 문서아이템의 갯수 조회
			Map<String, String> data =  new HashMap<String, String>();
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("house_code", house_code);
			data.put("po_no", po_no);
			
			/*wxp.addVar("house_code", house_code);
			wxp.addVar("po_no", po_no);*/
			
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			wf = new SepoaFormater(sm.doSelect(data));	

		}catch (Exception e) {
			throw new Exception("getERPProList : " + e.getMessage());
		} finally {
		}
		return wf;
	}
	
	private SepoaFormater getERPPJTList(String po_no) throws Exception {
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		SepoaFormater wf = null;
		try{
			ConnectionContext ctx =	getConnectionContext();
			Map<String, String> data =  new HashMap<String, String>();
			//현재 문서아이템의 갯수 조회
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("house_code", house_code);
			data.put("po_no", po_no);
			/*wxp.addVar("house_code", house_code);
			wxp.addVar("po_no", po_no);*/
			
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			wf = new SepoaFormater(sm.doSelect(data));	

		}catch (Exception e) {
			throw new Exception("getERPPJTList : " + e.getMessage());
		} finally {
		}
		return wf;
	}
	
	private SepoaFormater getERPPOList(String po_no) throws Exception {
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		SepoaFormater wf = null;
		try{
			ConnectionContext ctx =	getConnectionContext();
			Map<String, String> data =  new HashMap<String, String>();
			//현재 문서아이템의 갯수 조회
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("house_code", house_code);
			data.put("po_no", po_no);
			
			/*wxp.addVar("house_code", house_code);
			wxp.addVar("po_no", po_no);*/
			
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			wf = new SepoaFormater(sm.doSelect(data));	

		}catch (Exception e) {
			throw new Exception("getERPPOList : " + e.getMessage());
		} finally {
		}
		return wf;
	}
	
	/*
	 * 업체거래정지 품의,신규공급업체등록품의
	*/
	public SepoaOut Approval_6(SignResponseInfo inf)
	{
		int rtnIns = 0;
		String rtn = "";
		String sepoaSecretCode = null;
		try
		{
			String ans           = inf.getSignStatus();
			String doc_type 	 = inf.getDocType();
			String[] doc_no      = inf.getDocNo();
			String[] com_code    = inf.getCompanyCode();
			String[] doc_seq     = inf.getDocSeq();

			String flag    = "";
			String reg_no  = "";
			ConnectionContext ctx = getConnectionContext();

			SepoaOut value = null;
			String PURCHASE_BLOCK_FLAG ="";

			String decryptPassword = com.icompia.util.CommonUtil.getRandomString(6, "NS");
	    	String encryptPassword = decryptPassword;

	    	String mail_type = "";
	    	String sms_type = "";
	    	String[] erpVendor_result = new String[2];
			
	    	//업체승인시
			if("VM".equals(doc_type)){
				for(int j = 0 ; j < doc_no.length; j++){
					String[][] param = {{doc_no[j]}};
					String[][] param_sgvn = {{doc_no[j]}};
					if(ans.equals("E")){
						rtnIns = setSIGN_STATUS(ctx, "E", param);
						rtn    = getIrsNo_RegNo(ctx, param);
						reg_no = (new SepoaFormater(rtn)).getValue("REG_NO", 0);

						boolean secret_code = false;
				    	try {
				    		Configuration conf = new Configuration();
				    		
				    		sepoaSecretCode = conf.get("sepoa.secret.code");
				    		
				    		if(sepoaSecretCode == null){
				    			sepoaSecretCode = "";
				    		}
				    		
				    		sepoaSecretCode = sepoaSecretCode.trim();
				    		
				    		if("true".equals(sepoaSecretCode)){
				    			secret_code = true;
				    		}
				    		else{
				    			secret_code = false;
				    		}
				    	} catch(Exception e) {
				    		throw e;
				    	}

				    	if(secret_code){
				    		//2011/11/23
				    		//비밀번호를 아이디와 동일하게 발급
				    		//CEncrypt encrypt = new CEncrypt("MD5", encryptPassword);
				    		CEncrypt encrypt = new CEncrypt("MD5", doc_no[j]);
				    		encryptPassword = encrypt.getEncryptData();
				    	}

						rtnIns = createUser(ctx, param, encryptPassword);
						rtnIns = createMaker(ctx, param);
						//rtnIns = insertFreeCP(ctx, param);
						rtnIns = setSGVN_STATUS(ctx,"Y",param_sgvn);
						
						//업체승인 후 업체코드 변환
						SepoaFormater new_vendor_sf= makeNewVendorCode(ctx);
				    	String old_vendor_code1 = new_vendor_sf.getValue(0, 0);
				    	String old_vendor_code2 = new_vendor_sf.getValue(0, 1);
				    	String new_vendor_code1 = "";
				    	String new_vendor_code2 = "";
				    	
				    	Logger.debug.println( info.getSession("ID"), this, "#################### 변환전 업체코드1 : " + old_vendor_code1 );
				    	Logger.debug.println( info.getSession("ID"), this, "#################### 변환전 업체코드2 : " + old_vendor_code2 );
				    	
				    	if("9999".equals(old_vendor_code2)) {
				    		if("A".equals(old_vendor_code1)) {
				    			new_vendor_code1 = "B";
				    		} else if("B".equals(old_vendor_code1)) {
				    			new_vendor_code1 = "C";
				    		} else if("C".equals(old_vendor_code1)) {
				    			new_vendor_code1 = "D";//업체코드가 C9999를 초과되어 생성되지 못할 것 같지만 에러가 날 수도 있기에 D로 변환되도록 처리함
				    		}
				    		new_vendor_code2 = "0001";
				    	} else {
				    		new_vendor_code1 = old_vendor_code1;
				    		new_vendor_code2 = SepoaString.getLpad( String.valueOf( Integer.valueOf( old_vendor_code2 ) + 1 ) , 4, "0" );
				    	}
				    	
				    	Logger.debug.println( info.getSession("ID"), this, "#################### 변환할 업체코드1 : " + new_vendor_code1 );
				    	Logger.debug.println( info.getSession("ID"), this, "#################### 변환할 업체코드2 : " + new_vendor_code2 );
						
				    	String new_vendor_code = new_vendor_code1 + new_vendor_code2;
				    	
						rtnIns = updateVendorCodeVNGL(ctx, param, new_vendor_code);//ICOMVNGL
						rtnIns = updateVendorCodeLUSR(ctx, param, new_vendor_code);//ICOMLUSR
						rtnIns = updateVendorCodeADDR(ctx, param, new_vendor_code);//ICOMADDR
						rtnIns = updateVendorCodeVNCP(ctx, param, new_vendor_code);//ICOMVNCP
						rtnIns = updateVendorCodeSGVN(ctx, param, new_vendor_code);//SSGVN
						rtnIns = updateVendorCodeVNPJ(ctx, param, new_vendor_code);//ICOMVNPJ : UPDATE 대상이 없어도 예외처리하지 않음
						rtnIns = updateVendorCodeVNIT(ctx, param, new_vendor_code);//ICOMVNIT : UPDATE 대상이 없어도 예외처리하지 않음
						
						/*승인 일 경우만 SMS&메일 전송*/
						//mail_type 	= "M00013";
						sms_type = "S00002";
						
						// 공급사정보 I / F
		    			// ERP로 넘기 데이터 가져오기 (신규등록)
						/*
						 * erp 작업 if 문 추가하여 막아놓음
						 */
//						Configuration conf = new Configuration();
//						if(conf.getBoolean("sepoa.erp.if_flag")){
//							
//			    			ERPInterface erpIF = new ERPInterface("CONNECTION",info);
//			    			erpVendor_result = erpIF.erpVendorInsert(getERPVendorList(reg_no));
//							
//			    			if(erpVendor_result[0].equals("2")){
//		 	    				break;
//			    			}	
//						}
					}else if(ans.equals("D")){
						rtnIns  = setSIGN_STATUS(ctx, "D", param);	// 취소
//						rtnIns  = setSGVN_REJECT(ctx, "R", param_sgvn);	// 반려
					}else {
						rtnIns  = setSIGN_STATUS(ctx, "R", param);	// 반려
					}
				}
    			if(!"2".equals(erpVendor_result[0])){
					Commit();
					setStatus(1);
    			}else{
    				Rollback();
    				setStatus(0);
    				setMessage(erpVendor_result[1]);
    			}
			}else{ //업체 거래정지일시

				if(ans.equals("E")){
					PURCHASE_BLOCK_FLAG = "Y"; // 구매정지/결재완료
					sms_type	= "S00004";
					mail_type 	= "M00004";
				} else{
					PURCHASE_BLOCK_FLAG = "N";	// 반려
					sms_type	= "S00003";
					mail_type 	= "M00003";
				}
				String[][] param = {{PURCHASE_BLOCK_FLAG, doc_no[0]}};

				value = setBlock(param);

				if(ans.equals("E")){
//	    			sendSMS_MAIL(ctx, ans, args );
				}
				Commit();
				setStatus(1);
			}

			/*업체승인 시*/
			//mail, sms 주석 처리
			/*if(!"".equals(mail_type)){
				ServiceConnector.doService(info, "mail", "CONNECTION", mail_type, new Object[]{doc_no});
			}
			
			// SMS 전송
			if(!"".equals(sms_type)){
				String[] args 			= {doc_no[0]};
				Object[] vmE_sms_args 	= {args, decryptPassword}; 	// 업체승인시

				ServiceConnector.doService(info, "SMS", "TRANSACTION", sms_type, vmE_sms_args);
			}*/

		}
		catch(Exception e)
		{
			Logger.err.println("setSignStatus: = " + e.getMessage());
			setStatus(0);
		}

		return getSepoaOut();
	}
	
	private int setSIGN_STATUS(ConnectionContext ctx, String JOB_STATUS, String[][] setData) throws Exception
	{
		int rtn = -1;

		try
		{

			String addSql	  = "";
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
            String cur_date   = SepoaDate.getShortDateString();
            String cur_time   = SepoaDate.getShortTimeString();
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            	/*wxp.addVar("JOB_STATUS", JOB_STATUS);
            	wxp.addVar("cur_date", cur_date);
            	wxp.addVar("user_id", user_id);
            	wxp.addVar("house_code", house_code);*/
            for(int i=0;i<setData.length;i++){
            	
            
            	
            	
            	if("E".equals(JOB_STATUS)){
            		addSql = "SIGN_STATUS = 'E', JOB_STATUS = 'E', CLASS_GRADE = 'D', SIGN_DATE = '"+cur_date+"', SIGN_PERSON_ID = '"+user_id+"' , ";
            	}
            	else if("R".equals(JOB_STATUS)){
            		addSql = "JOB_STATUS = 'R', SIGN_STATUS = 'R',";
            	}
            	else if("D".equals(JOB_STATUS)){
            		addSql = "JOB_STATUS = 'P', SIGN_STATUS = '',";
            	}
            		
            	
	            Map<String, String> data =  new HashMap<String, String>();
	            wxp.addVar("addSql", addSql);
	            
	            data.put("JOB_STATUS", JOB_STATUS);
	            data.put("cur_date", cur_date);
	            data.put("user_id", user_id);
	            data.put("house_code", house_code);
	            data.put("vendor_code", setData[i][0]);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				rtn = sm.doInsert(data);
				
				if("R".equals(JOB_STATUS)){
					Map<String, String> smsParam = new HashMap<String, String>();
					
		  	    	smsParam.put("HOUSE_CODE",  house_code);
		  	    	smsParam.put("VENDOR_CODE", setData[i][0]);
					
					new SMS("NONDBJOB", info).rg1Process(ctx, smsParam);
					new mail("NONDBJOB", info).rg1Process(ctx, smsParam);
				}
            }
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("setSIGN_STATUS:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	private String getIrsNo_RegNo(ConnectionContext ctx, String[][] pData) throws Exception {

	    String rtn = "";

	    try {

	    	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	    	/*wxp.addVar("vendor_code", pData[0][0]);
	    	wxp.addVar("house_code", info.getSession("HOUSE_CODE"));*/
	    	Map<String, String> data =  new HashMap<String, String>();
	    	data.put("vendor_code", pData[0][0]);
	    	data.put("house_code", info.getSession("HOUSE_CODE"));

	    	SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

	    	rtn = sm.doSelect(data);

	    }catch(Exception e) {
	        Logger.debug.println(info.getSession("ID"),this,"getIrsNo_RegNo = " + e.getMessage());
	    } finally{

	    }
	    return rtn;
	}
	
	
	/**
	 * 전자결재 > 업체승인 > 공급업체마스터 > 공급업체 코드 변경
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private int updateVendorCodeVNGL(ConnectionContext ctx, String[][] setData, String new_vendor_code) throws Exception
	{
		
		int rtn = -1;
		
		try
		{
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String cur_date   = SepoaDate.getShortDateString();
			String cur_time   = SepoaDate.getShortTimeString();
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			for(int i=0;i<setData.length;i++){
				Map<String, String> data =  new HashMap<String, String>();
				
				data.put("house_code", info.getSession("HOUSE_CODE"));
				data.put("user_id", user_id);
				data.put("vendor_code", setData[i][0]);
				data.put("new_vendor_code", new_vendor_code);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				
				//String[] type = { "S" };
				
				rtn = sm.doUpdate(data);
			}
			if(rtn == 0 || rtn == -1)
				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("updateVendorCodeVNGL:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	
	/**
	 * 전자결재 > 업체승인 > 사용자 > 공급업체 코드 변경
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private int updateVendorCodeLUSR(ConnectionContext ctx, String[][] setData, String new_vendor_code) throws Exception
	{
		
		int rtn = -1;

		try
		{
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
            String cur_date   = SepoaDate.getShortDateString();
            String cur_time   = SepoaDate.getShortTimeString();
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            for(int i=0;i<setData.length;i++){
            	Map<String, String> data =  new HashMap<String, String>();
	            
	            data.put("house_code", info.getSession("HOUSE_CODE"));
	            data.put("user_id", user_id);
	            data.put("vendor_code", setData[i][0]);
	            data.put("new_vendor_code", new_vendor_code);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	
				//String[] type = { "S" };
	
				rtn = sm.doUpdate(data);
            }
			if(rtn == 0 || rtn == -1)
 				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("updateVendorCodeLUSR:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	
	/**
	 * 전자결재 > 업체승인 > 주소 > 공급업체 코드 변경
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private int updateVendorCodeADDR(ConnectionContext ctx, String[][] setData, String new_vendor_code) throws Exception
	{
		
		int rtn = -1;
		
		try
		{
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String cur_date   = SepoaDate.getShortDateString();
			String cur_time   = SepoaDate.getShortTimeString();
			SepoaFormater sf =null;
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaXmlParser wxp2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			for(int i=0;i<setData.length;i++){
				Map<String, String> data =  new HashMap<String, String>();
				
				data.put("house_code", info.getSession("HOUSE_CODE"));
				data.put("user_id", user_id);
				data.put("vendor_code", setData[i][0]);
				data.put("new_vendor_code", new_vendor_code);
				
				SepoaSQLManager sm2 = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp2.getQuery());
				sf = new SepoaFormater(sm2.doSelect(data));
				String cnt=sf.getValue("cnt", 0);
				
				if(cnt.equals("0")){
					SepoaSQLManager sm1 = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp1.getQuery());
					rtn = sm1.doInsert(data);
				}
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				
				//String[] type = { "S" };
				
				rtn = sm.doUpdate(data);
			}
			if(rtn == 0 || rtn == -1)
				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("updateVendorCodeADDR:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	
	/**
	 * 전자결재 > 업체승인 > 공급업체 코드 변경
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private int updateVendorCodeVNCP(ConnectionContext ctx, String[][] setData, String new_vendor_code) throws Exception
	{
		
		int rtn = -1;
		
		try
		{
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String cur_date   = SepoaDate.getShortDateString();
			String cur_time   = SepoaDate.getShortTimeString();
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			for(int i=0;i<setData.length;i++){
				Map<String, String> data =  new HashMap<String, String>();
				
				data.put("house_code", info.getSession("HOUSE_CODE"));
				data.put("user_id", user_id);
				data.put("vendor_code", setData[i][0]);
				data.put("new_vendor_code", new_vendor_code);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				
				//String[] type = { "S" };
				
				rtn = sm.doUpdate(data);
			}
			if(rtn == 0 || rtn == -1)
				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("updateVendorCodeVNCP:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	
	/**
	 * 전자결재 > 업체승인 > 공급업체 코드 변경
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private int updateVendorCodeSGVN(ConnectionContext ctx, String[][] setData, String new_vendor_code) throws Exception
	{
		
		int rtn = -1;
		
		try
		{
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String cur_date   = SepoaDate.getShortDateString();
			String cur_time   = SepoaDate.getShortTimeString();
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			for(int i=0;i<setData.length;i++){
				Map<String, String> data =  new HashMap<String, String>();
				
				data.put("house_code", info.getSession("HOUSE_CODE"));
				data.put("user_id", user_id);
				data.put("vendor_code", setData[i][0]);
				data.put("new_vendor_code", new_vendor_code);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				
				//String[] type = { "S" };
				
				rtn = sm.doUpdate(data);
			}
			if(rtn == 0 || rtn == -1)
				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("updateVendorCodeSGVN:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	
	/**
	 * 전자결재 > 업체승인 > 공급업체 코드 변경
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private int updateVendorCodeVNPJ(ConnectionContext ctx, String[][] setData, String new_vendor_code) throws Exception
	{
		
		int rtn = -1;
		
		try
		{
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String cur_date   = SepoaDate.getShortDateString();
			String cur_time   = SepoaDate.getShortTimeString();
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			for(int i=0;i<setData.length;i++){
				Map<String, String> data =  new HashMap<String, String>();
				
				data.put("house_code", info.getSession("HOUSE_CODE"));
				data.put("user_id", user_id);
				data.put("vendor_code", setData[i][0]);
				data.put("new_vendor_code", new_vendor_code);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				
				//String[] type = { "S" };
				
				rtn = sm.doUpdate(data);
			}
//			if(rtn == 0 || rtn == -1)
//				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("updateVendorCodeVNPJ:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	
	/**
	 * 전자결재 > 업체승인 > 공급업체 코드 변경
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private int updateVendorCodeVNIT(ConnectionContext ctx, String[][] setData, String new_vendor_code) throws Exception
	{
		
		int rtn = -1;
		
		try
		{
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String cur_date   = SepoaDate.getShortDateString();
			String cur_time   = SepoaDate.getShortTimeString();
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			for(int i=0;i<setData.length;i++){
				Map<String, String> data =  new HashMap<String, String>();
				
				data.put("house_code", info.getSession("HOUSE_CODE"));
				data.put("user_id", user_id);
				data.put("vendor_code", setData[i][0]);
				data.put("new_vendor_code", new_vendor_code);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				
				//String[] type = { "S" };
				
				rtn = sm.doUpdate(data);
			}
//			if(rtn == 0 || rtn == -1)
//				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("updateVendorCodeVNIT:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	
	/**
	 * 전자결재 > 업체승인 > 공급업체코드 자동채번
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private SepoaFormater makeNewVendorCode(ConnectionContext ctx) throws Exception
	{
		
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		SepoaFormater wf = null;
		try{
			Map<String, String> data =  new HashMap<String, String>();
			//현재 문서아이템의 갯수 조회
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("house_code", house_code);
			
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			wf = new SepoaFormater(sm.doSelect(data));	

		}catch (Exception e) {
			throw new Exception("getERPPOList : " + e.getMessage());
		} finally {
		}
		return wf;
		
	}
	
	
	private int createUser(ConnectionContext ctx, String[][] setData, String passwd) throws Exception
	{
		
		
		
		int rtn = -1;

		try
		{
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
            String cur_date   = SepoaDate.getShortDateString();
            String cur_time   = SepoaDate.getShortTimeString();
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            for(int i=0;i<setData.length;i++){
            	Map<String, String> data =  new HashMap<String, String>();
	            /*wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
	        	wxp.addVar("user_id", user_id);
	        	wxp.addVar("passwd", passwd);
	        	wxp.addVar("login_yn", 'Y');*/
	            data.put("house_code", info.getSession("HOUSE_CODE"));
	            data.put("user_id", user_id);
	            data.put("passwd", passwd);
	            data.put("login_yn", "Y");
	            data.put("vendor_code", setData[i][0]);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	
				//String[] type = { "S" };
	
				rtn = sm.doInsert(data);
            }
			if(rtn == 0 || rtn == -1)
 				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("createUser:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	private int createMaker(ConnectionContext ctx, String[][] setData) throws Exception
	{
		int rtn = -1;

		try
		{

			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
            String cur_date   = SepoaDate.getShortDateString();
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            	/*wxp.addVar("house_code", house_code);
            	wxp.addVar("user_id", user_id);*/
            for(int i=0;i<setData.length;i++){
            	Map<String, String> data =  new HashMap<String, String>();
            	data.put("house_code", house_code);
            	data.put("user_id", user_id);
            	SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
            	data.put("vendor_code", setData[i][0]);
			//String[] type = { "S" };

				rtn = sm.doInsert(data);
            }
			if(rtn == 0 || rtn == -1)
 				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("createUser:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	private int setSGVN_STATUS(ConnectionContext ctx, String REG_FLAG, String[][] setData) throws Exception
	{
		int rtn = -1;

		try
		{
			String house_code = info.getSession("HOUSE_CODE");
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            for(int i=0;i<setData.length;i++){
            	Map<String, String> data =  new HashMap<String, String>();
            	data.put("REG_FLAG", REG_FLAG);
            	data.put("house_code", house_code);
            	data.put("vendor_code", setData[i][0]);
	            /*wxp.addVar("REG_FLAG", REG_FLAG);
	            wxp.addVar("house_code", house_code);*/
	
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	
				rtn = sm.doUpdate(data);
            }
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("setSIGN_STATUS:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	private SepoaFormater getERPVendorList(String vendor_code) throws Exception {
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		SepoaFormater wf = null;
		try{
			ConnectionContext ctx =	getConnectionContext();
			Map<String, String> data =  new HashMap<String, String>();
			//현재 문서아이템의 갯수 조회
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			/*wxp.addVar("house_code", house_code);
			wxp.addVar("vendor_code", vendor_code);*/
			data.put("house_code", house_code);
			data.put("vendor_code", vendor_code);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			wf = new SepoaFormater(sm.doSelect(data));	

		}catch (Exception e) {
			throw new Exception("getERPVendorList : " + e.getMessage());
		} finally {
		}
		return wf;
	}
	
	public SepoaOut setBlock(String[][] param){

    	String rtn[] = null;
    	try{

    		rtn = SR_setBlock(param);
    		setMessage( rtn[ 0 ] );
    		setValue( "update Row=" + rtn );
    		setStatus( 1 );

    		if ( rtn[ 1 ] != null ){
    		    setMessage( rtn[ 1 ] );
    		    setStatus( 0 );
    		}

    	} catch ( Exception e ) {
    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
    	    setStatus( 0 );
    	}
    	return getSepoaOut();
  	}
	
	/**
  	 *@description : 등록업체 목록 - 거래중지
  	 *@date : 2010-03-11
  	 *@author useonlyj
  	 * */

  	private String[] SR_setBlock(String[][] param) throws Exception{

    	String returnString[] = new String[ 2 ];
    	ConnectionContext ctx = getConnectionContext();
    	String house_code = info.getSession("HOUSE_CODE");
    	String user_id = info.getSession("ID");

    	int rtnIns = 0;
    	SepoaFormater wf = null;
    	SepoaSQLManager sm = null;

		try{

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			for(int i=0;i<param.length;i++){
            	Map<String, String> data =  new HashMap<String, String>();
            	data.put("house_code", house_code);
            	data.put("purchase_block_flag", param[i][0]);
            	data.put("vendor_code", param[i][1]);
            	//wxp.addVar("house_code", house_code);
            	sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery());//sql.toString() );
            	rtnIns = sm.doUpdate(data);
			}
  	    	Commit();

  	    } catch( Exception e ) {
    	    Rollback();
    	    returnString[ 1 ] = e.getMessage();
    	} finally { }

    	return returnString;
  	}
	
  	/*
  	 * 견적요청
  	 */
  	public SepoaOut Approval_7(SignResponseInfo inf) 
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
//			e.printStackTrace();
			try	{ 
				Rollback(); 
			} catch(Exception d) {
//				d.printStackTrace();
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
		Map<String, String> data =  new HashMap<String, String>();
		data.put("flag", flag);
		data.put("sign_user_id", sign_user_id);
		data.put("sign_date", sign_date);
		data.put("house_code", house_code);
		data.put("company_code", company_code);
		data.put("exec_no", exec_no);
		data.put("exec_seq", exec_seq);
		
 
		try	{ 
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
			rtn	= sm.doUpdate(data);
			data.put("APPROVAL_TYPE", "RFQ" );
			if(!approvalFileDecode(data)){
				rtn = 0;
				throw new Exception("파일 복호화중 에러가 발생하였습니다.\n시스템관리자에게 문의하세요.");
			}
			
			Map<String, String> smsParam = new HashMap<String, String>();
			
		    smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
		    smsParam.put("RFQ_NO",      exec_no);
		    smsParam.put("RFQ_COUNT",   exec_seq);
			
			new SMS("NONDBJOB", info).rq2Process(ctx, smsParam);
			new mail("NONDBJOB", info).rq2Process(ctx, smsParam);
		} catch(Exception e) { 
//			e.printStackTrace();
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
		Map<String, String> data =  new HashMap<String, String>();
		data.put("flag", flag);
		data.put("sign_user_id", sign_user_id);
		data.put("house_code", house_code);
		data.put("company", company_code);
		data.put("exec_no", exec_no);
		data.put("exec_seq", exec_seq);
			
 
		try	{ 
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
 
			rtn	= sm.doUpdate(data); 
		} catch(Exception e) { 
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			throw new Exception(e.getMessage()); 
		} 
		return rtn; 
	}
  	
  	
  	/**
  	 * 입찰
	 * <b>입찰공고의 결재를 승인한다.</b>
	 * <pre>
	 * et_Approval을 호출한다.
	 * </pre>
	 * @param inf
	 * @return
	 */
	public SepoaOut Approval_8(SignResponseInfo inf)
	{
		String user_id		 = info.getSession("ID");
		SepoaOut value = null;
		
		try
		{
			
			Logger.debug.println(user_id, this, "start time = "+System.currentTimeMillis());
			value = et_Approval_8(inf);
			Logger.debug.println(user_id, this, "end time = "+System.currentTimeMillis());
			
			Commit();
			
/*			//결재완료시 sms, mail 발송.
			String[] DOC_NO	      = inf.getDocNo();
			String[] DOC_SEQ	  = inf.getDocSeq();
			
			ConnectionContext ctx =	getConnectionContext();
			WiseXmlParser wxp = null;
			
			for(int v1=0; v1 < DOC_NO.length; v1++){
				//cont_type1( 계약형태 ) 값을 가져온다.
				wxp = new WiseXmlParser(this, "getContType1");
				wxp.addVar("HOUSE_CODE", info.getSession("HOUSE_CODE"));
				wxp.addVar("BID_NO", DOC_NO[v1]);
				wxp.addVar("BID_COUNT", DOC_SEQ[v1]);
	            WiseSQLManager sm = new WiseSQLManager(userid,this,ctx, wxp.getQuery());
	            String rtn = sm.doSelect(null);

	            WiseFormater wf = new WiseFormater(rtn);
	            String cont_type1 = wf.getValue("CONT_TYPE1", 0);
	            
				//지명경쟁일 경우에만 발송.
				if("NC".equals(cont_type1)){
					String[][] args = new String[1][2];
					args[0][0] = DOC_NO[v1];
					args[0][1] = DOC_SEQ[v1];
					
					Object[] sms_args = {args};
			        String sms_type = "";
			        String mail_type = "";
			        
			        sms_type 	= "S00006";
			        mail_type 	= "M00006";
			        
			        if(!"".equals(sms_type)){
			        	ServiceConnector.doService(info, "SMS", "TRANSACTION", sms_type, sms_args);
			        }
			        if(!"".equals(mail_type)){
			        	ServiceConnector.doService(info, "mail", "CONNECTION", mail_type, sms_args);
			        }
				}
			}*/
		}
		catch(Exception e)
		{
			Logger.debug.println(user_id, this, "end time = "+System.currentTimeMillis());
			Logger.debug.println(user_id, this, "***************Exception***************");
			Logger.debug.println(user_id, this, "Exception Message = "+e.getMessage());
			Logger.debug.println(user_id, this, "***************Exception***************");
			try {
				Rollback();
			} catch(Exception re) {
				Logger.debug.println(user_id, this, re.getMessage());
			}
		}
		
		return value;
	}
  	
	
	/**
	 * 입찰공고승인.
	 * <pre>
	 * <b> LOGIC 순서 </b>
	 * 1) ICOYBDHD UPDATE
	 * <b>참조정보</b>
	 * </pre>
	 * @param inf
	 * @return
	 * @throws Exception
	 */
	private SepoaOut et_Approval_8(SignResponseInfo inf) throws Exception
	{
		String              user_id       = info.getSession("ID");
		String              house_code    = info.getSession("HOUSE_CODE");
		String              location_code = info.getSession("LOCATION_CODE");
		String              department    = info.getSession("DEPARTMENT");
		String              name_loc      = info.getSession("NAME_LOC");
		String              name_eng      = info.getSession("NAME_ENG");
		String              language      = info.getSession("LANGUAGE");
		String              add_date      = SepoaDate.getShortDateString();
		String              add_time      = SepoaDate.getShortTimeString();
		Map<String, String> param         = null;
		ConnectionContext   ctx           =	null;
		
		Logger.debug.println(user_id,this,"############## p2017.Approval Start ################");
		
		try
		{
			String sign_status	= inf.getSignStatus();
			String doc_type     = inf.getDocType(); 
			String sign_date	= inf.getSignDate();
			String sign_user_id	= inf.getSignUserId();
			
			String[] DOC_NO	      = inf.getDocNo();
			String[] DOC_SEQ	  = inf.getDocSeq();
			String[] SHIPPER_TYPE = inf.getShipperType();
			
			Logger.debug.println(user_id,this,"############## Approval SignStatus ==> " + sign_status);
			
			int iDocCount = DOC_NO.length;
			String[][] objBDHD	  =	new	String[iDocCount][];
			
			if("P".equals(sign_status)){
				sign_status = "A";
			}
			
			for(int	i=0;i <	DOC_NO.length;i++)
			{
				String[] TEMP_CNHD = {
					  sign_status   // C 로 넘어오면 OK
					, sign_date
					, sign_user_id
					, sign_status
					, house_code
					, DOC_NO[i]
					, DOC_NO[i]
					, DOC_SEQ[i]
				};
				
				objBDHD[i] = TEMP_CNHD;
			}
            
			setBDHDUpdate(objBDHD);
			
			ctx = getConnectionContext();
			
			for(int	i=0;i <	DOC_NO.length;i++){
				param = new HashMap<String, String>();
				
				param.put("HOUSE_CODE", house_code);
				param.put("BID_NO",     DOC_NO[i]);
				param.put("BID_COUNT",  DOC_SEQ[i]);
				
				
				if("D".equals(sign_status)){ //TOBE 2017-07-01 결재상신-결재취소시 입찰공고SMS 발송 방지
				} else {
				   new SMS("NONDBJOB", info).bd1Process(ctx, param);
				}
			}
			
			setStatus(1);
			setMessage("");
			
			//반려이거나 취소일 경우 여기서 끝낸다.
			//if(sign_status!="E") {
			//if(!"E".equals(sign_status)){
			if(!"E".equals(sign_status)){
				return getSepoaOut();
			}

		} catch(Exception	e) {
			throw new Exception("et_Approval error"+e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	/**
	 * 입찰 헤더정보에 결재정보를 update해준다.
	 * <pre>
	 * </pre>
	 * @param args
	 * @return
	 * @throws Exception
	 */
	private	int setBDHDUpdate(String[][] args) throws Exception
	{
		int rtn = -1;
		String user_id = info.getSession("ID");
		
		try {
			ConnectionContext ctx =	getConnectionContext();

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm =	new	SepoaSQLManager(user_id,this,ctx, wxp.getQuery());
			for(int i=0;i<args.length;i++){
            	Map<String, String> data =  new HashMap<String, String>();
            	data.put("sign_status_1", args[i][0]);
            	data.put("sign_date", args[i][1]);
            	data.put("sign_user_id", args[i][2]);
            	data.put("sign_status_2", args[i][3]);
            	data.put("house_code", args[i][4]);
            	data.put("doc_no_1", args[i][5]);
            	data.put("doc_no_2", args[i][6]);
            	data.put("doc_seq", args[i][7]);
            	
    			data.put("APPROVAL_TYPE", "BD" );
    			if("E".equals(args[i][0])){
    				if (!approvalFileDecode(data) ) {
        				rtn = 0;
        				throw new Exception("파일 복호화중 에러가 발생하였습니다.\n시스템관리자에게 문의하세요.");
        			}
    			}
            	
            	//String[] type1 = {"S","S","S","S", "S","S", "S","S"};
            	rtn = sm.doUpdate(data);
			}
		} catch(Exception	e) {
			throw new Exception("setCnhdUpdate:"+e.getMessage());
		}
		
		return rtn;
	}

	/**
	 * 서비스요청문의
	 * @param inf
	 * @return
	 */
	public SepoaOut Approval_9(SignResponseInfo inf) 
	{ 
		int rtnIns = 0;
		try  
		{ 
			String ans           = inf.getSignStatus();
			String[] doc_no      = inf.getDocNo(); 

			String sign_status="";
			
			if(ans.equals("E")){
				sign_status = "Q"; // 서비스 결재완료					
			} else{
				sign_status = "R";	// 반려
			}
			String[][] param = {{sign_status, doc_no[0]}};
			
			rtnIns = setSignFlag(param);
			
			Commit();
			setStatus(1);
							
		} 
		catch(Exception e)  
		{ 
			Logger.err.println("setSignStatus: = " + e.getMessage());             
			setStatus(0); 
		}  
 
		return getSepoaOut(); 
	}
	
	private int setSignFlag(String[][] setData) throws Exception 
    { 
        int rtn = -1; 
        String user_id = info.getSession("ID");
        String house_code = info.getSession("HOUSE_CODE");
        
        try { 
        	
      	    SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
      	    //wxp.addVar("house_code", house_code);
            ConnectionContext ctx = getConnectionContext(); 
            Map<String, String> data =  new HashMap<String, String>();
            data.put("house_code", house_code);
        	data.put("sign_status", setData[0][0]);
        	data.put("doc_no", setData[0][1]);
            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery()); 
 
            //String[] type = {"S","S"}; 
 
            rtn = sm.doUpdate(data);             
             
        } 
        catch(Exception e) { 
                Rollback(); 
                throw new Exception("et_setServiceFix:"+e.getMessage()); 
        } finally{ 
            //Release(); 
        } 
        return rtn; 
    }
	
	/**퉁합품의
	 * <b>품의정보의 결재를 승인한다.</b>
	 * <pre>
	 * et_Approval을 호출한다.
	 * </pre>
	 * @param inf
	 * @return
	 */
	public SepoaOut Approval_10(SignResponseInfo inf)
	{
		String user_id		 = info.getSession("ID");
		SepoaOut value = null;
		
		try
		{
			
			Logger.debug.println(user_id, this, "start time = "+System.currentTimeMillis());
			if("EX".equals(inf.getDocType())){			// 품의
				value = et_Approval(inf);
			}else if("TEX".equals(inf.getDocType())){	// 통합품의
				value = et_ApprovalTEX(inf);
			}
			
			Logger.debug.println(user_id, this, "end time = "+System.currentTimeMillis());
			
			Commit();
		}
		catch(Exception e)
		{
			Logger.debug.println(user_id, this, "end time = "+System.currentTimeMillis());
			Logger.debug.println(user_id, this, "***************Exception***************");
			Logger.debug.println(user_id, this, "Exception Message = "+e.getMessage());
			Logger.debug.println(user_id, this, "***************Exception***************");
			try
			{
				Rollback();
			}
			catch(Exception re)
			{
				Logger.debug.println(user_id, this, re.getMessage());
			}
		}
		
		return value;
	}
	
	/**
	 * <b> 결재를 승인한다.</b>
	 * <pre>
	 * et_Approval을 호출한다.
	 * </pre>
	 * @param inf
	 * @return
	 */
	public SepoaOut Approval_11(SignResponseInfo inf)
	{
		String user_id		 = info.getSession("ID");
		SepoaOut value = null;
		
		try {
			//Logger.debug.println(user_id, this, "start time = "+System.currentTimeMillis());
			value = et_Approval_11(inf);
			//Logger.debug.println(user_id, this, "end time = "+System.currentTimeMillis());
			Commit();
		}
		catch(Exception e) {
			//Logger.debug.println(user_id, this, "end time = "+System.currentTimeMillis());
			//Logger.debug.println(user_id, this, "***************Exception***************");
			//Logger.debug.println(user_id, this, "Exception Message = "+e.getMessage());
			//Logger.debug.println(user_id, this, "***************Exception***************");
			try {
				Rollback();
			} catch(Exception re) {
				Logger.debug.println(user_id, this, re.getMessage());
			}
		}
		return value;
	}
	
	/**
	 * 승인.
	 * <pre>
	 * <b> LOGIC 순서 </b>
	 * 1) ICOYTRHD UPDATE
	 * <b>참조정보</b>
	 * </pre>
	 * @param inf
	 * @return
	 * @throws Exception
	 */
	private SepoaOut et_Approval_11(SignResponseInfo inf) throws Exception
	{
		String user_id		 	= info.getSession("ID");
		String house_code	 	= info.getSession("HOUSE_CODE");
		Logger.debug.println(user_id,this,"############## p2052.Approval Start ################");
		
		try {
			String sign_status	= inf.getSignStatus();
			String doc_type     = inf.getDocType(); 
			String sign_date	= inf.getSignDate();
			String sign_user_id	= inf.getSignUserId();
			
			String[] DOC_NO	      = inf.getDocNo();
			
			Logger.debug.println(user_id,this,"############## Approval SignStatus ==> " + sign_status);
			
			int iDocCount 		= DOC_NO.length;
			String[][] objHD	= new String[iDocCount][];
			String[][] objHD2	= new String[iDocCount][];
			
			for(int	i=0;i <	DOC_NO.length;i++)
			{
				String[] TEMP_HD_DATA = {
					  sign_status   // C 로 넘어오면 OK
					, sign_date
					, house_code
					, DOC_NO[i]
				};
				
				String[] TEMP_HD_DATA2 = {
						  sign_status   // C 로 넘어오면 OK
						, house_code
						, DOC_NO[i]
					};
				
				objHD[i] = TEMP_HD_DATA;
				objHD2[i] = TEMP_HD_DATA2;
			}
            
			int rtn_bdhd = setSignStatusUpdate(objHD, objHD2);
			
			setStatus(1);
			setMessage("");
			
			//반려이거나 취소일 경우 여기서 끝낸다.
			//if(sign_status != "E") {
			if(!"E".equals(sign_status)){
				return getSepoaOut();
			}

		} catch(Exception	e) {
			throw new Exception("et_Approval error"+e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	/**
	 * 결재정보를 update해준다.
	 * @param args
	 * @return
	 * @throws Exception
	 */
	private	int setSignStatusUpdate(String[][] args, String[][] args2) throws Exception
	{
		int rtn = -1;
		String user_id = info.getSession("ID");
		
		try {
			ConnectionContext ctx =	getConnectionContext();

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			SepoaSQLManager sm =	new	SepoaSQLManager(user_id,this,ctx, wxp.getQuery());

			//String[] type1 = {"S","S","S","S"};
			for(int i=0;i<args.length;i++){
				Map<String, String> data1 =  new HashMap<String, String>();
				data1.put("sign_status", args[i][0]);
				data1.put("sign_date", args[i][1]);
				data1.put("house_code", args[i][2]);
				data1.put("doc_no", args[i][3]);
				rtn = sm.doUpdate(data1);
			}
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			sm =	new	SepoaSQLManager(user_id,this,ctx, wxp.getQuery());

			//String[] type2 = {"S","S","S"};
			for(int i=0;i<args2.length;i++){
				Map<String, String> data2 =  new HashMap<String, String>();
				data2.put("sign_status", args2[i][0]);
				data2.put("house_code", args2[i][1]);
				data2.put("doc_no", args2[i][2]);
				rtn = sm.doUpdate(data2);
			}

		} catch(Exception	e) {
			throw new Exception("setSignStatusUpdate:"+e.getMessage());
		}
		
		return rtn;
	}
	
	
	/**
	 * <b> 결재를 승인한다.</b>
	 * <pre>
	 * et_Approval을 호출한다.
	 * </pre>
	 * @param inf
	 * @return
	 */
	public SepoaOut Approval_12(SignResponseInfo inf)
	{
		String user_id		 = info.getSession("ID");
		SepoaOut value = null;
		
		try {
			//Logger.debug.println(user_id, this, "start time = "+System.currentTimeMillis());
			value = et_Approval_12(inf);
			//Logger.debug.println(user_id, this, "end time = "+System.currentTimeMillis());
		}
		catch(Exception e) {
			//Logger.debug.println(user_id, this, "end time = "+System.currentTimeMillis());
			//Logger.debug.println(user_id, this, "***************Exception***************");
			//Logger.debug.println(user_id, this, "Exception Message = "+e.getMessage());
			//Logger.debug.println(user_id, this, "***************Exception***************");
			try {
				Rollback();
			} catch(Exception re) {
				Logger.debug.println(user_id, this, re.getMessage());
			}
		}
		return value;
	}
	
	private SepoaOut et_Approval_12(SignResponseInfo inf) throws Exception
	{
		String user_id		 	= info.getSession("ID");
		String house_code	 	= info.getSession("HOUSE_CODE");
		Logger.debug.println(user_id,this,"############## p2055.Approval Start ################");
		
		String sign_status	= inf.getSignStatus();
		String doc_type     = inf.getDocType(); 
		String sign_date	= inf.getSignDate();
		String sign_user_id	= inf.getSignUserId();
		String progress_code  = sign_status;
		
		String[] DOC_NO	      = inf.getDocNo();
		
		Logger.debug.println(user_id,this,"############## Approval SignStatus ==> " + sign_status);

		
		if(sign_status.equals("E")){  // 모든결제가 완료시에  상태 승인으로 변경 세팅
			progress_code = "C";	
		}else if(sign_status.equals("D")){ //상신결재 취소시에 sign_status 값이 'D' 이지만 다시 결재할수 있도록 'T' 변경
			sign_status = "T";
		}
		
		for(int	i=0;i <	DOC_NO.length;i++)
		{
			SepoaOut value 	= getSignTaxList(DOC_NO[i]);
			SepoaFormater wf 	= new SepoaFormater(value.result[0]);
			
			String[][] objHD	= new String[wf.getRowCount()][];
			String[][] objHD2	= new String[wf.getRowCount()][];
			
			for(int j = 0 ; j < wf.getRowCount(); j++){
				String tax_no = wf.getValue("TAX_NO", j);
				String[] TEMP_HD_DATA = {
						  sign_status   // C 로 넘어오면 OK
						, sign_date
						, house_code
						, tax_no
					};				
					
				String[] TEMP_HD_DATA2 = {
						progress_code
						,house_code
						, tax_no
					};
				
				objHD[j] = TEMP_HD_DATA;
				objHD2[j] = TEMP_HD_DATA2;
			}
			setSignStatusUpdate(objHD,objHD2,sign_status);

		}
        						
		setStatus(1);
		setMessage("");
		
		//반려이거나 취소일 경우 여기서 끝낸다.
		//if(sign_status != "E") {
		if(!"E".equals(sign_status)){
			return getSepoaOut();
		}else{
			for(int	i=0;i <	DOC_NO.length;i++)
			{     	
				String group_tax_no = DOC_NO[i];
				// 구매요청 상태 변경 
				// 구매요청현황 세금계산서 승인완료상태로 변경  -> X
    			String prev_pr_progress_flag = "V";
    			String pr_progress_flag = "X";
    			
    			
    			SepoaOut value 	= getSignTaxList(group_tax_no);
    			SepoaFormater wf 	= new SepoaFormater(value.result[0]);
    			
    			String[] erpTax_result = new String[2];
    			for(int j = 0 ; j < wf.getRowCount(); j++){
    				String tax_no = wf.getValue("TAX_NO", j);	    			 
	    			setPr_progress_flag(tax_no, prev_pr_progress_flag, pr_progress_flag);
					// 정산 I / F
	    			// ERP로 넘기 데이터 가져오기 (신규등록)
	    			
	    			// if를 만들어 sepoa.erp.if_flag=false 로 돌아 가지 않게 막음
	    			Configuration conf = new Configuration();
                    if(conf.getBoolean("sepoa.erp.if_flag")){
		    			//ERPInterface erpIF = new ERPInterface("CONNECTION",info);
		    			//erpTax_result = erpIF.erpTaxInsert(getERPTaxList(tax_no),"A");
		    			
		    			if(erpTax_result[0].equals("2")){
		 	    				break;
		 	    		}
	    			}
	    			
    			}
    			
    			if(!erpTax_result[0].equals("2")){
    				Commit();
    			}else{
    				Rollback();
    				setStatus(0);
    				setMessage(erpTax_result[1]);
    			}
			}
			
		}
		
		return getSepoaOut();
	}
	
	/*  결제대상 세금계산서 목록 조회 */
	public SepoaOut getSignTaxList(String group_tax_no) {
		try {
			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getSignTaxList(house_code, group_tax_no);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0){
				//setMessage(msg.getMessage("0000"));
			}else {
				//setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getSignTaxList(String house_code, String group_tax_no)
			throws Exception {
		
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			Map<String, String> data =  new HashMap<String, String>();
			data.put("house_code", house_code);
			data.put("group_tax_no", group_tax_no);
			//wxp.addVar("house_code", house_code);
			//wxp.addVar("group_tax_no", group_tax_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doSelect(data);
		} catch (Exception e) {
			throw new Exception("bl_getSignTaxList:" + e.getMessage());
		} finally {
		}
		return rtn;		
		
	}
	
	private int setPr_progress_flag(String doc_no, String prev_pr_progress_flag, String pr_progress_flag)throws Exception {
		int rtn = 0;
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		try {
			ConnectionContext ctx =	getConnectionContext();
			//현재 문서아이템의 갯수 조회
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			Map<String, String> data =  new HashMap<String, String>();
			data.put("house_code", house_code);
			data.put("user_id", user_id);
			data.put("doc_no", doc_no);
			data.put("prev_pr_progress_flag", prev_pr_progress_flag);
			data.put("pr_progress_flag", pr_progress_flag);
			/*wxp.addVar("house_code", house_code);
			wxp.addVar("user_id", user_id);
			wxp.addVar("doc_no", doc_no);
			wxp.addVar("prev_pr_progress_flag", prev_pr_progress_flag);
			wxp.addVar("pr_progress_flag", pr_progress_flag);*/
			
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			SepoaFormater wf1 = new SepoaFormater(sm.doSelect(data));
				
			//이전 문서아이템의 완료 갯수 조회
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			
			/*wxp.addVar("house_code", house_code);
			wxp.addVar("user_id", user_id);
			wxp.addVar("doc_no", doc_no);
			wxp.addVar("prev_pr_progress_flag", prev_pr_progress_flag);
			wxp.addVar("pr_progress_flag", pr_progress_flag);*/
			
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			SepoaFormater wf2 = new SepoaFormater(sm.doSelect(data));
			int tr_cnt = Integer.parseInt(wf1.getValue("TR_CNT", 0));
			int inv_cnt = Integer.parseInt(wf2.getValue("TX_CNT", 0));
			
			if( tr_cnt ==  inv_cnt ){
			
				// 이전 PR_PROGRESS_FLAG  유무 확인후 상태변경
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
				
				/*wxp.addVar("house_code", house_code);
				wxp.addVar("user_id", user_id);
				wxp.addVar("doc_no", doc_no);
				wxp.addVar("prev_pr_progress_flag", prev_pr_progress_flag);
				wxp.addVar("pr_progress_flag", pr_progress_flag);*/
				
				sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
				rtn = sm.doUpdate(data);
			}
			
		} catch (Exception e) {
			throw new Exception("setPr_progress_flag : " + e.getMessage());
		} finally {
		}		
		
		return rtn;
	}
	
	private SepoaFormater getERPTaxList(String tax_no) throws Exception {
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		SepoaFormater wf = null;
		try{
			ConnectionContext ctx =	getConnectionContext();
			//현재 문서아이템의 갯수 조회
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			/*wxp.addVar("house_code", house_code);
			wxp.addVar("tax_no", tax_no);*/
			Map<String, String> data =  new HashMap<String, String>();
			data.put("house_code", house_code);
			data.put("tax_no", tax_no);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			wf = new SepoaFormater(sm.doSelect(data));	

		}catch (Exception e) {
			throw new Exception("getERPTaxList : " + e.getMessage());
		} finally {
		}
		return wf;
	}
	
	private	int setSignStatusUpdate(String[][] args, String[][] args2, String sign_status) throws Exception
	{
		int rtn = -1;
		String user_id = info.getSession("ID");
		
		try {
			ConnectionContext ctx =	getConnectionContext();

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_12_1");
			SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx, wxp.getQuery());
				
			//String[] type1 = {"S","S","S","S"};
			for(int i=0;i<args.length;i++){
				Map<String, String> data1 =  new HashMap<String, String>();
				data1.put("sign_status", args[i][0]);
				data1.put("sign_date", args[i][1]);
				data1.put("house_code", args[i][2]);
				data1.put("tax_no", args[i][3]);
				rtn = sm.doUpdate(data1);
			}
			if(sign_status.equals("E") || sign_status.equals("R")){  // 모든결재 완료시나 반려시 승인상태값 변경 
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_12_2");
				sm =	new	SepoaSQLManager(user_id,this,ctx, wxp.getQuery());

				//String[] type2 = {"S","S","S"};
				for(int i=0;i<args2.length;i++){
					Map<String, String> data2 =  new HashMap<String, String>();
					data2.put("progress_code", args2[i][0]);
					data2.put("house_code", args2[i][1]);
					data2.put("tax_no", args2[i][2]);
					rtn = sm.doUpdate(data2);		
				}
			}

		} catch(Exception	e) {
			throw new Exception("setSignStatusUpdate:"+e.getMessage());
		}
		
		return rtn;
	}	
	
	// 직발주
	// ************************************************
    // **************** 결재처리 **********************
    // ************************************************
//    public SepoaOut Approval_13(SignResponseInfo inf)
//    {
//    	Logger.debug.println(info.getSession("ID"),this,"approval start !!!");
//    	String ans = inf.getSignStatus();
//    	String po_no = "";
//    	String id = "I034";
//    	String where = "";
//    	Logger.debug.println(info.getSession("ID"),this,"111111111111111111111111==============>");
//    	String[] doc_no = inf.getDocNo();
//    	String[] com_code = inf.getCompanyCode();
//    	String[] doc_seq = inf.getDocSeq();
//    	
//    	String setData[][]    = new String[doc_no.length][];
//    	String setDataII[][]    = new String[doc_no.length][];
//    	String flag    = "";
//    	Logger.debug.println(info.getSession("ID"),this,"doc_no - length==============>"+doc_no.length);
//    	for (int i = 0; i<doc_no.length; i++) {
//    		String Data[]    = { doc_no[i] };
//    		String DataII[]  = { com_code[i] , doc_no[i] };
//    		setData[i]   = Data;
//    		setDataII[i] = DataII;
//    	}
//    	where = "PO_NO IN ("+po_no+")";
//    	
//    	int res  = -1;
//    	int res1 = -1;
//    	int res2 = -1;
//    	int res3 = -1;
//    	
//    	try {
//    		Logger.debug.println(info.getSession("ID"),this,"try start ----------------==============>");
//    		if(ans.equals("E")) { // 완료
//    			flag = "E";
//    		} else if (ans.equals("R")) { // 반려
//    			flag = "R";
//    		} else if (ans.equals("D")) { // 취소
//    			//flag = "D";
//    			flag = "T";
//    		}
//    		Logger.debug.println(info.getSession("ID"),this,"setSIGN_STATUS start ==============>");
//    		res  = setSIGN_STATUS(flag, setData);
//    		
//    		if(ans.equals("E"))
//    		{
//    			Logger.debug.println(info.getSession("ID"),this,"doc_no==============>"+doc_no);
//    			
//    			//청구의 PROCEEDING_FLAG 수정
//    			res3 = setPRDT_13(setData);
//    			int cim_cnt = 0;
//    			String[] erpPro_result = new String[2];
//    			String[] erpPJT_result = new String[2];
//    			String[] erpPo_result  = new String[2];
//    			//PO의 RD_DATE 현재일보다 작은 것 현재일로 UPDATE
//    			//setPODT(setData);//
//    			// if를 만들어 sepoa.erp.if_flag=false 로 돌아 가지 않게 막음
//    			Configuration conf = new Configuration();
//                if(conf.getBoolean("sepoa.erp.if_flag")){
//	    			for (int index = 0; index <doc_no.length; index++) {
//		    			// 품목 I / F (신규등록)
//		    			//ERPInterface erpIF = new ERPInterface("CONNECTION",info);
//		    			//erpPro_result =  erpIF.erpProInsert(getERPProList_13(doc_no[index]));                
//		    			// 프로젝트 납품품목 I / F (신규등록)
//		    			//erpPJT_result = erpIF.erpPJTInsert(getERPPJTList(doc_no[index]));	    			
//		                // 발주 I / F (신규등록)
//		    			//erpPo_result = erpIF.erpPOInsert(getERPPOList(doc_no[index]),"A");
//		    			
//		    			if(erpPro_result[0].equals("2") || 
//		    			   erpPJT_result[0].equals("2") ||
//				    	   erpPo_result[0].equals("2")){
//		    				break;
//		    			}
//	    			}
//                }
//    			if(/*!erpPro_result[0].equals("2") && 
//		    	   !erpPJT_result[0].equals("2") &&
//		    	   !erpPo_result[0].equals("2")*/!conf.getBoolean("sepoa.erp.if_flag")){//원래 조건 대신 !conf.getBoolean("sepoa.erp.if_flag")를 추가하여 commit기능 하게함
//	    			//SMS,Mail발송
//	    			//setSMS(setData);
//	    			
//	    				setStatus(1);
//	    				Commit();
//
//    			}else{
//    				Rollback();
//    				setStatus(0);
//    				// if를 만들어 sepoa.erp.if_flag=false 로 돌아 가지 않게 막음
//    				if(conf.getBoolean("sepoa.erp.if_flag")){
//	    				if(erpPro_result[0].equals("2")){
//	    					setMessage(erpPro_result[1]);
//	    				}else if(erpPJT_result[0].equals("2")){
//	    					setMessage(erpPJT_result[1]);
//	    				}else{
//	    					setMessage(erpPo_result[1]);
//	    				}    
//    				}
//    			}
//    		} else {
//    			setStatus(1);
//    			Commit();
//    		}
//    	} catch(Exception e) {
//    		Logger.err.println("setSignStatus: = " + e.getMessage());
//    		setStatus(0);
//    	}
//    	return getSepoaOut();
//    }
	public SepoaOut Approval_13(SignResponseInfo inf) throws Exception 
    {
    	ConnectionContext ctx = getConnectionContext();
    	String ans = inf.getSignStatus();
    	String po_no = "";
    	String id = "I034";
    	String where = "";
    	String[] doc_no = inf.getDocNo();
    	String[] com_code = inf.getCompanyCode();
    	String[] doc_seq = inf.getDocSeq();
    	
    	String setData[][]    = new String[doc_no.length][];
    	String setDataII[][]    = new String[doc_no.length][];
    	String flag    = "";
    	for (int i = 0; i<doc_no.length; i++) {
    		String Data[]    = { doc_no[i] };
    		String DataII[]  = { com_code[i] , doc_no[i] };
    		setData[i]   = Data;
    		setDataII[i] = DataII;
    	}
    	where = "PO_NO IN ("+po_no+")";
    	
    	int res  = -1;
    	int res1 = -1;
    	int res2 = -1;
    	int res3 = -1;
    	
    	try {
    		if(ans.equals("E")) { // 완료
    			flag = "E";
    		} else if (ans.equals("R")) { // 반려
    			flag = "R";
    		} else if (ans.equals("D")) { // 취소
    			//flag = "D";
    			flag = "T";
    		}
    		res  = setSIGN_STATUS_13(ctx, flag, setData);
    		
    		if(res < 0) {
				throw new Exception();
    		}
    		
    		if(ans.equals("E"))
    		{    		
    			//청구의 PROCEEDING_FLAG 수정
    			res3 = setPRDT_13(ctx, setData);
    			    			
    			if(res3 > -1){
    				//SMS,Mail발송
    		    	//setSMS(setData);
    				
    				    				
    				for(int i=0;i<doc_no.length;i++){
    	            	Map<String, String> data =  new HashMap<String, String>();
//    	            	data.put("sign_status_1", ans);
//    	            	data.put("sign_date", inf.getSignDate());
//    	            	data.put("sign_user_id", inf.getSignUserId());
//    	            	data.put("sign_status_2", ans);
//    	            	data.put("house_code", inf.getHouseCode());
//    	            	data.put("doc_no_1", doc_no[i]);
//    	            	data.put("doc_no_2", doc_no[i]);
//    	            	data.put("doc_seq", "");
    	            	
    	            	data.put("doc_no", doc_no[i]);
    	    			data.put("APPROVAL_TYPE", "POD" );
    	    			if (!approvalFileDecode(data) ) {
	        				throw new Exception("파일 복호화중 에러가 발생하였습니다.\n시스템관리자에게 문의하세요.");
	        			}
    	            	
    				}
    				    			
    				setSMS_13(setData);
    				    	  	    	
    				setFlag(true);
    				setStatus(1);
    		    	Commit();

    	    	}else{
    	    		throw new Exception();
    	    	}
    			
    		} else {
    			setFlag(true);
				setStatus(1);
    			Commit();
    		}
    	} catch(Exception e) {
    		Rollback();
    		Logger.err.println("Approval_13: = " + e.getMessage());
    		setStatus(0);
    		setFlag(false);    				
    	}
    	return getSepoaOut();
    }

    
    private int setSIGN_STATUS_13(ConnectionContext ctx, String FLAG, String[][] setData) throws Exception
    {
    	int rtn = -1;
    	
    	String user_id    = info.getSession("ID");
    	String house_code = info.getSession("HOUSE_CODE");
    	
    	SepoaSQLManager sm = null;
    	SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
    	SepoaXmlParser wxp2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
    	
     	/*wxp1.addVar("FLAG", FLAG);
     	wxp1.addVar("user_id", user_id);
     	wxp1.addVar("house_code", house_code);*/
     	
     	try {
     		for(int i=0;i<setData.length;i++){
				Map<String, String> data =  new HashMap<String, String>();
				data.put("FLAG", FLAG);
				data.put("user_id", user_id);
				data.put("house_code", house_code);
				data.put("po_no",setData[i][0]);
	     		sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp1.getQuery());
	     		//String[] type = { "S" };
	     		rtn = sm.doInsert(data);

	         
	     		sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp2.getQuery());
	     		rtn = sm.doInsert(data);
     		}
     	} catch(Exception e) {
     		throw new Exception("######## setSIGN_STATUS ========> "+e.getMessage());
     	}
     	return rtn;
    }
    
    private int setPRDT_13(ConnectionContext ctx, String[][] setData) throws Exception
    {
        int rtn = -1;
        
        SepoaSQLManager sm = null;
        SepoaFormater wf = null;

        String user_id    = info.getSession("ID");
        String house_code = info.getSession("HOUSE_CODE");

        try {
        	SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
        	SepoaXmlParser wxp2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");

            for( int j = 0; j < setData.length ; j++ )
            {
            	Map<String, String> data1 =  new HashMap<String, String>();
                data1.put("house_code", house_code);
                data1.put("po_no", setData[j][0]);
                sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp1.getQuery());
                String rtnSql = sm.doSelect(data1);
                wf = new SepoaFormater(rtnSql);

                for( int i = 0 ; i < wf.getRowCount(); i++ )
                {
                	Map<String, String> data2 =  new HashMap<String, String>();
                    String pr_no = wf.getValue( i,0 );
                    String pr_seq = wf.getValue( i,1 );
                    data2.put("house_code", house_code);
                    data2.put("pr_no", pr_no);
                    data2.put("pr_seq", pr_seq);
                    sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp2.getQuery());
                    rtn = sm.doInsert(data2);
                }
            }

        }catch(Exception e) {
            throw new Exception("setPRDT:"+e.getMessage());
        }
        finally{
        }
        return rtn;
    }
    
    private int setSMS_13(String[][] setData) throws Exception
    {
    	 int rtn = -1;
         ConnectionContext ctx = getConnectionContext();

         SepoaSQLManager sm = null;
         SepoaFormater wf = null;

         String user_id    = info.getSession("ID");
         String house_code = info.getSession("HOUSE_CODE");

         try {
         	SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
         	
             for( int j = 0; j < setData.length ; j++ )
             {
             	Map<String, String> data1 =  new HashMap<String, String>();
                 data1.put("house_code", house_code);
                 data1.put("po_no", setData[j][0]);
                 sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp1.getQuery());
                 String rtnSql = sm.doSelect(data1);
                 wf = new SepoaFormater(rtnSql);

                 for( int i = 0 ; i < wf.getRowCount(); i++ )
                 {
                	 Map<String, String> smsParam = new HashMap<String, String>();
     				
                	 String vendor_code = wf.getValue( i,0 );
                     String subject = wf.getValue( i,1 );
                     
     	  	    	smsParam.put("HOUSE_CODE",  house_code);
     	  	    	smsParam.put("VENDOR_CODE", vendor_code);
     	  	    	smsParam.put("SUBJECT", subject);
     	  	    	
     	  	    	new SMS("NONDBJOB", info).po1Process(ctx, smsParam);
     				new mail("NONDBJOB", info).po1Process(ctx, smsParam);     				     		       
                 }
             }

         }catch(Exception e) {
             throw new Exception("setSMS_13:"+e.getMessage());
         }
         finally{
         }
         return rtn;
    }
    
    
    private SepoaFormater getERPProList_13(String po_no) throws Exception {
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		SepoaFormater wf = null;
		try{
			ConnectionContext ctx =	getConnectionContext();
			//현재 문서아이템의 갯수 조회
			Map<String, String> data =  new HashMap<String, String>();
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("house_code", house_code);
			data.put("po_no", po_no);
			
			/*wxp.addVar("house_code", house_code);
			wxp.addVar("po_no", po_no);*/
			
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			wf = new SepoaFormater(sm.doSelect(data));	

		}catch (Exception e) {
			throw new Exception("getERPProList : " + e.getMessage());
		} finally {
		}
		return wf;
	}
    
    private int setSMS(String[][] setData) throws Exception
    {
        int rtn = -1;
        try {
   			String[] args = new String[setData.length];
   			
   			for( int j = 0; j < setData.length ; j++ )
   	         {
   				args[j] = setData[j][0];	         
   	         }
   			
   			Object[] sms_args = {args, "T"};
   	        String sms_type = "";
   	        String mail_type = "";
   	        
   	        sms_type 	= "S00008";
   	        mail_type 	= "M00008";
   	        
   	        if(!"".equals(sms_type)){
   	        	ServiceConnector.doService(info, "SMS", "TRANSACTION", sms_type, sms_args);
   	        }
   	        if(!"".equals(mail_type)){
   	        	ServiceConnector.doService(info, "mail", "CONNECTION", mail_type, sms_args);
   	        }

   		} catch (Exception e) {
   			Logger.debug.println("mail error = " + e.getMessage());
   			
   		}
        return rtn;
    }
    
    /**
     * 경상비 결재
     * @param inf
     * @return
     */
    public SepoaOut Approval_14(SignResponseInfo inf)  throws Exception 
    {
    	String ans = inf.getSignStatus();
    	String id = "I034";
    	String where = "";

    	String[] doc_no = inf.getDocNo();
    	String[] com_code = inf.getCompanyCode();
    	String[] doc_seq = inf.getDocSeq();
    	String doc_type = inf.getDocType();
    	
    	ConnectionContext ctx = getConnectionContext();
    	SepoaXmlParser 	wxp1 = null;
    	SepoaSQLManager sm   = null;
    	
    	SepoaOut      value        = null;
    	int                rowCount  = 0;
    	int                iRtnCnt      = 0;     // 성공여부
	    boolean       isStatus     = false;
 	    SepoaFormater sf           = null;
	        	
    	try {
    		
    		Map<String, String> data = new HashMap<String, String>();
    		data.put("app_status_cd", ans);
    		data.put("pay_act_no"	, doc_no[0]);
    		
    		if(ans.equals("M")){
    			data.put("status_cd", "20");        		
    		}
    		
//    		Map<String, String> data2 = new HashMap<String, String>();
//    		data2.put("pay_act_no"	, doc_no[0]);
    		
			wxp1= new SepoaXmlParser(this, "setSpy2gl");
			sm 	= new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp1.getQuery());
			iRtnCnt = sm.doUpdate(data);
			if(iRtnCnt < 1) {
				throw new Exception();
    		}
			
			
//			if ("PAY".equals(doc_type)) {
//				
//				String user_trm_no    = inf.getUser_trm_no();
//				data.put("user_trm_no"	, user_trm_no);
//				
//				
//				Object[] obj = {data};
//		    	value    = ServiceConnector.doService(info, "TX_012", "CONNECTION","getSpy2List", obj);
//		    	isStatus = value.flag;			
//				if(isStatus){
//					//gdRes.setMessage(message.get("MESSAGE.0001").toString());
//					//gdRes.setStatus("false");
//					    		
//					sf= new SepoaFormater(value.result[0]);
//					rowCount = sf.getRowCount(); // 조회 row 수
//					
//					if(rowCount == 1){
//			    		
//			    		data.put("VENDOR_CODE"          ,  sf.getValue("VENDOR_CODE",0));
//			    		data.put("STD_DATE"             ,  SepoaString.getDateUnSlashFormat( sf.getValue("STD_DATE",0)) );
//			    		data.put("DEPOSITOR_NAME"       ,  sf.getValue("DEPOSITOR_NAME",0));
//			    		data.put("BANK_CODE"            ,	 sf.getValue("BANK_CODE",0));
//			    		data.put("BANK_ACCT"            ,  sf.getValue("BANK_ACCT",0));
//			    		data.put("SUPPLY_AMT"           ,  sf.getValue("SUPPLY_AMT",0));
//			    		data.put("TAX_AMT"              ,  sf.getValue("TAX_AMT",0));
//			    		data.put("TOT_AMT"              ,  sf.getValue("TOT_AMT",0));
//			    		data.put("BMSBMSYY"             ,  sf.getValue("BMSBMSYY",0));
//			    		data.put("BUGUMCD"              ,  sf.getValue("BUGUMCD",0));
//			    		data.put("ACT_DATE"             ,  SepoaString.getDateUnSlashFormat( sf.getValue("ACT_DATE",0)) );
//			    		data.put("EXPENSECD"            ,  sf.getValue("EXPENSECD",0));
//			    		data.put("SEMOKCD"              ,  sf.getValue("SEMOKCD",0));
//			    		data.put("SAUPCD"               ,	 sf.getValue("SAUPCD",0));
//			    		data.put("DOC_TYPE"             ,	 sf.getValue("DOC_TYPE",0));
//			    		data.put("PAY_TYPE"             ,	 sf.getValue("PAY_TYPE",0));
//			    		data.put("PAY_REASON"           ,  sf.getValue("PAY_REASON",0));
//			    		data.put("TAX_NO"               ,  sf.getValue("TAX_NO",0));
//			    		data.put("NTS_APP_NO"           ,  sf.getValue("NTS_APP_NO",0));
//			    		data.put("ACC_TAX_DATE"         ,  SepoaString.getDateUnSlashFormat( sf.getValue("ACC_TAX_DATE",0)) );
//			    		data.put("ACC_TAX_SEQ"          ,  sf.getValue("ACC_TAX_SEQ",0));
//			    		data.put("APP_STATUS_CD"        ,  sf.getValue("APP_STATUS_CD",0));
//			    		data.put("ADD_DATE"             ,  sf.getValue("ADD_DATE",0));
//			    		data.put("ADD_TIME"             ,  sf.getValue("ADD_TIME",0));
//			    		data.put("ADD_USER_ID"          ,  sf.getValue("ADD_USER_ID",0));
//			    		data.put("ISU_DT"               ,  sf.getValue("ISU_DT",0));
//			    		data.put("SEBUCD"               ,  sf.getValue("SEBUCD",0));
//			    		data.put("ZIPHANGCD"            ,  sf.getValue("ZIPHANGCD",0));
//			    		data.put("VENDOR_NAME"          ,  sf.getValue("VENDOR_NAME",0));
//			    		data.put("IRS_NO"               ,  sf.getValue("IRS_NO",0));
//			    		
//			    		String  rtn   = this.et_setOT8602(info, data);
//			    		
//			    		if(rtn.length() > 3 && !"ERR".equals(rtn.substring(0,3))){
//			    						    						    			
//			    			//data2.put("PYDTM_APV_NO", rtn);
//			    			data.put("PYDTM_APV_NO", rtn);
//			    			
//			    			wxp1 = new SepoaXmlParser(this, "setPydtmApvNoUpdate");
//			    			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp1);
//			    			//iRtnCnt = sm.doUpdate(data2);
//			    			iRtnCnt = sm.doUpdate(data);			    						    			
//			    			if(iRtnCnt < 1) {
//			        			throw new Exception();
//			        		}
//			    						    						    					    		
////			        		if(isStatus2) {
////			        			//gdResMessage = rtn+": 지급결의승인번호가 발급되었습니다.";
////			        			setStatus(1);
////			        		}
////			        		else {
////			        			Rollback();
////			        			throw new Exception();
////			        		}
//			    		}else{
//			    			//gdResMessage = rtn;
////			    			Rollback();
////			        		setStatus(0);
//			    			throw new Exception();
//			    		}
//			    		
//					}
//				}
//			
//			}
			
			setFlag(true);
			setStatus(1);
			Commit();
//			Rollback();
    	
    	} catch(Exception e) {
    		Rollback();
    		Logger.err.println("Approval_14: = " + e.getMessage());
    		setStatus(0);
    		setFlag(false);
			
    	}
    	return getSepoaOut();
    }   
 
    /**
     * 경비지급결의 
     * et_setOT8602
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2015-01-15
     * @modify 2015-01-15
     */
    private String et_setOT8602(SepoaInfo info, Map<String, String> header) throws Exception {
		
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
		
	   	
	   	if(header.get("user_trm_no").length() >= 9){
			BKCD       = header.get("user_trm_no").substring(0,  5);
			BRCD       = header.get("user_trm_no").substring(5,  6); 
			TRMBNO     = header.get("user_trm_no").substring(6,  9);
			USERTERMNO = header.get("user_trm_no").substring(9,  10);
			TERMNO9    = header.get("user_trm_no").substring(0,  9);
			addUserId  = header.get("user_trm_no").substring(10, 18);
		}
	   	
	   	
		OT8602 n02 = new OT8602();

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
        n02.SEND.bizHdr.UID           = addUserId;           //(8)  PDA조작자번호                                                                 

		
		
		try {
			int iret = n02.sendMessage("OT8602",send_ip,send_port);
			if(iret == ONCNF.D_OK) {
				n02.RECV.log(ONCNF.LOGNAME, "");	
				result = n02.RECV.PYDTM_APV_NO;
				
			}else if(iret == ONCNF.D_ECODE) {
//				System.out.println("ERRCODE = "+n02.RECV.bizHdr.ERRCODE+ONCNF.D_ERR);
//				System.out.println("ERR:["+n02.RECV.bizHdr.ERRCODE+"]"+n02.eRECV.MESSAGE);
				result = "ERR:["+n02.RECV.bizHdr.ERRCODE+"]"+n02.eRECV.MESSAGE; 
			}else {
//				System.out.println("sendMessage call error !!.." + iret);
				result = "ERR:sendMessage call error !!.." + iret;
			}
		}
		catch (Exception e) {
			result = "ERR:sendMessage call error !!..";
			//e.printStackTrace();
		}
		
    	return result;
	}
    
    /**
     * 계약 결재
     * @param inf
     * @return
     */
//    public SepoaOut Approval_CT(SignResponseInfo inf)
//    {
//    	String ans = inf.getSignStatus();
//    	String where = "";
//    	
//    	String[] doc_no = inf.getDocNo();
//    	String[] com_code = inf.getCompanyCode();
//    	String[] doc_seq = inf.getDocSeq();
//    	
//    	ConnectionContext ctx = getConnectionContext();
//    	
//    	try {
//    		Map<String, String> data = new HashMap<String, String>();
//    		data.put("sign_status"	, ans);
//    		data.put("cont_no"		, doc_no[0]);
//    		data.put("cont_gl_seq"	, doc_seq[0]);
//    		
//    		SepoaXmlParser 	wxp1= new SepoaXmlParser(this, "setCPGL");
//    		SepoaSQLManager sm 	= new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp1.getQuery());
//    		sm.doInsert(data);
//    		setStatus(1);
//    		Commit();
////			Rollback();
//    		
//    	} catch(Exception e) {
//    		Logger.err.println("Approval_14: = " + e.getMessage());
//    		setStatus(0);
//    	}
//    	return getSepoaOut();
//    }   
    public SepoaOut Approval_CT(SignResponseInfo inf)
    {
    	String ans = inf.getSignStatus();
    	String where = "";
    	
    	String[] doc_no = inf.getDocNo();
    	String[] com_code = inf.getCompanyCode();
    	String[] doc_seq = inf.getDocSeq();
    	
    	ConnectionContext ctx = getConnectionContext();
    	
    	try {
    		if("D".equals(ans) || "R".equals(ans)){
    			Map<String, String> data = new HashMap<String, String>();
	    		data.put("sign_status"	, ans);
	    		data.put("cont_no"		, doc_no[0]);
	    		data.put("cont_gl_seq"	, doc_seq[0]);
	    		
	    		SepoaXmlParser 	wxp1= new SepoaXmlParser(this, "setCPGL_D");
	    		SepoaSQLManager sm 	= new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp1.getQuery());
	    		sm.doUpdate(data);
	    		
	    		SepoaXmlParser 	wxp2= new SepoaXmlParser(this, "delCPGL_D");
	    		SepoaSQLManager sm2 	= new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp2.getQuery());
	    		sm2.doUpdate(data);
	    		
	    		setStatus(1);
	    		Commit();
    		}else{
    			Map<String, String> data = new HashMap<String, String>();
	    		data.put("sign_status"	, ans);
	    		data.put("cont_no"		, doc_no[0]);
	    		data.put("cont_gl_seq"	, doc_seq[0]);
	    		
	    		SepoaXmlParser 	wxp1= new SepoaXmlParser(this, "setCPGL");
	    		SepoaSQLManager sm 	= new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp1.getQuery());
	    		sm.doInsert(data);
	    		
	    		setStatus(1);
	    		Commit();
    		}    		
    	} catch(Exception e) {
    		Logger.err.println("Approval_14: = " + e.getMessage());
    		setStatus(0);
    	}
    	return getSepoaOut();
    }   

	private boolean approvalFileDecode(Map<String, String> map)
			throws Exception {
		ConnectionContext ctx = getConnectionContext();

		boolean returnFlag = false;
		ResultSet rs = null;
		Statement stmt = null;
		Statement stmtEmpty = null;
		SepoaFormater sf = null;
		InputStream blobrd = null;
		Reader clobrd = null;
		FileWriter fw = null;
		FileOutputStream fos = null;
		File f1 = null;
		File f2 = null;
		File f3 = null;
		File f4 = null;
		File f5 = null;
		Connection conn = ctx.getConnection();
		Configuration conf = new Configuration();
		String filePath1 = "";
		String filePath2 = "";
		String fileName1 = "";
		String fileName2 = "";
		String oriFilePath = "";
		String createDate = SepoaDate.getShortDateString()
				+ SepoaDate.getShortTimeString();
		conn.setAutoCommit(false);
		try {
			if ("RFQ".equals(MapUtils.getString(map, "APPROVAL_TYPE"))) {
				SepoaXmlParser sxp = new SepoaXmlParser(this,
						"approvalRfqAttach");
				SepoaSQLManager ssm = new SepoaSQLManager(
						info.getSession("ID"), this, ctx, sxp);
				sf = new SepoaFormater(ssm.doSelect(map));
			} else if ("BD".equals(MapUtils.getString(map, "APPROVAL_TYPE"))) {
				SepoaXmlParser sxp = new SepoaXmlParser(this,
						"approvalBdAttach");
				SepoaSQLManager ssm = new SepoaSQLManager(
						info.getSession("ID"), this, ctx, sxp);
				sf = new SepoaFormater(ssm.doSelect(map));
			} else if ("RA".equals(MapUtils.getString(map, "APPROVAL_TYPE"))) {
				SepoaXmlParser sxp = new SepoaXmlParser(this,
						"approvalRaAttach");
				SepoaSQLManager ssm = new SepoaSQLManager(
						info.getSession("ID"), this, ctx, sxp);
				sf = new SepoaFormater(ssm.doSelect(map));
			}  else if ("POD".equals(MapUtils.getString(map, "APPROVAL_TYPE"))) {
				SepoaXmlParser sxp = new SepoaXmlParser(this,
						"approvalPodAttach");
				SepoaSQLManager ssm = new SepoaSQLManager(
						info.getSession("ID"), this, ctx, sxp);
				sf = new SepoaFormater(ssm.doSelect(map));
			}
			if(sf != null){
				for (int i = 0; i < sf.getRowCount(); i++) {
					stmt = conn.createStatement();
					stmtEmpty = conn.createStatement();
	
					
					rs = stmt
							.executeQuery("SELECT DATA, DATA_TXT, TYPE, FILE_SIZE, DES_FILE_NAME, SRC_FILE_NAME FROM SFILE WHERE DOC_NO || DOC_SEQ ='"
									+ sf.getValue("DOC_NO", i)
									+ "' ORDER BY DOC_NO,DOC_SEQ");
					if (rs.next()) {
						oriFilePath = conf.getString("sepoa.attach.path."
								+ rs.getString("TYPE"))
								+ "/" + rs.getString("DES_FILE_NAME");
						f5 = new File(oriFilePath);
						
						// CLOB column????븳 ?ㅽ듃由쇱쓣 ?삳뒗??
						try {
							fileName1 = rs.getString("DES_FILE_NAME") + ".B"
									+ createDate;
							filePath1 = conf.getString("sepoa.attach.path."
									+ rs.getString("TYPE"))
									+ "/" + fileName1;
	
							byte[] byteBuffer = new byte[1024];
							char[] charBuffer = new char[1024];
							int l = 0;
	
							if (rs.getBlob("DATA") != null) {
	
								stmtEmpty.executeUpdate("UPDATE SFILE SET DATA = EMPTY_BLOB() WHERE DOC_NO || DOC_SEQ = '"+sf.getValue("DOC_NO", i)+"' ");
								
								blobrd = rs.getBlob("DATA").getBinaryStream();
	//							System.out.println(filePath1);
								f1 = new File(filePath1);
								fos = new FileOutputStream(f1);
	
								while ((l = blobrd.read(byteBuffer)) != -1) {
									fos.write(byteBuffer, 0, l);
								}
								fos.flush();
								if (fos != null)
									fos.close();
								if (blobrd != null)
									blobrd.close();
	
								if (getFileDec(filePath1, fileName1)) {
									if (!setFileDec(conn, filePath1,
											sf.getValue("DOC_NO", i), "BINARY")) {
										return false;
									}
								} else {
									return false;
								}
	//							System.out.println(filePath1 + "_DEC");
								f3 = new File(filePath1 + "_DEC");
								f1.delete();
								f3.delete();
							}
	
							l = 0;
							fileName2 = rs.getString("DES_FILE_NAME") + ".C"
									+ createDate;
							filePath2 = conf.getString("sepoa.attach.path."
									+ rs.getString("TYPE"))
									+ "/" + fileName2;
							if (rs.getClob("DATA_TXT") != null) {
								stmtEmpty.executeUpdate("UPDATE SFILE SET DATA_TXT = EMPTY_CLOB() WHERE DOC_NO || DOC_SEQ = '"+sf.getValue("DOC_NO", i)+"' ");
								clobrd = rs.getClob("DATA_TXT").getCharacterStream();
								
	//							System.out.println(filePath2);
								f2 = new File(filePath2);
								fw = new FileWriter(f2);
								l = 0;
	
								while ((l = clobrd.read(charBuffer)) != -1) {
									fw.write(charBuffer, 0, l);
								}
								fw.flush();
								if (clobrd != null)
									clobrd.close();
								if (fw != null)
									fw.close();
								if (getFileDec(filePath2, fileName2)) {
									if (!setFileDec(conn, filePath2,
											sf.getValue("DOC_NO", i), "TXT")) {
										return false;
									}
								} else {
									return false;
								}
	//							System.out.println(filePath2 + "_DEC");
								f4 = new File(filePath2 + "_DEC");
								f2.delete();
								f4.delete();
							}
						} catch (Exception e1) {
							Logger.debug.println(e1);
	//						e1.printStackTrace();
							return false;
						}
					} // end  if (rs.next()) {
					if(f5 != null){ f5.delete(); }
				} // end  for문 
				returnFlag = true;
			} // end  if(sf != null){
		} catch (Exception e) {
			Logger.debug.println(e);
			returnFlag = false;
//			e.printStackTrace();
			conn.rollback();
		} finally { if(fos != null){ IOUtils.closeQuietly(fos); } if(blobrd != null){ IOUtils.closeQuietly(blobrd); } if(clobrd != null){ IOUtils.closeQuietly(clobrd); } if(fw != null){ IOUtils.closeQuietly(fw); } }
		return returnFlag;
	}
    
	private boolean setFileDec(Connection conn, String filePath, String docNo,
			String type) throws Exception {
		PreparedStatement pstmt = null;
		File f = null;
		ResultSet rs = null;
        int rtn = 0;
		f = new File(filePath + "_DEC");

		StringBuffer sb = new StringBuffer();

		if ("BINARY".equals(type)) {

			sb.append("SELECT DATA FROM SFILE WHERE DOC_NO || DOC_SEQ = '"
					+ docNo + "' FOR UPDATE");

			pstmt = conn.prepareStatement(sb.toString());
			rs = pstmt.executeQuery();
			int l = 0;
			if (rs != null) {
				if (rs.next()) {
					java.sql.Blob bl = rs.getBlob("DATA");
					OutputStream writer = null;
					FileInputStream fi = null;
					BufferedInputStream bis = null;

					try {
						writer = bl.setBinaryStream(0);

						if (f.exists()) {
							fi = new FileInputStream(f);
							IOUtils.copy(fi, writer);
							writer.flush();
						}
					} catch (Exception e) {
			    		Logger.debug.println(e);
//						e.printStackTrace();
						return false;
					} finally {
						try {
							if (fi != null)
								fi.close();
							if (bis != null)
								bis.close();
							if (writer != null)
								writer.close();
						} catch (Exception e) {
//							e.printStackTrace();
							rtn = -1;
						}
					}
				}
			}
		} else if ("TXT".equals(type)) {

			sb.append("SELECT DATA_TXT FROM SFILE WHERE DOC_NO || DOC_SEQ = '"
					+ docNo + "' FOR UPDATE");

			pstmt = conn.prepareStatement(sb.toString());
			rs = pstmt.executeQuery();
			int l = 0;
			if (rs != null) {
				if (rs.next()) {
					java.sql.Clob cl = rs.getClob("DATA_TXT");
					Writer writer = null;
					FileInputStream fi = null;
					InputStreamReader isr = null;
					BufferedReader bis = null;

					try {
						writer = cl.setCharacterStream(0);

						if (f.exists()) {
							fi = new FileInputStream(f);
							IOUtils.copy(fi, writer);
							writer.flush();
						}
					} catch (Exception e) {
			    		Logger.debug.println(e);
//						e.printStackTrace();
						return false;

					} finally {
						try {
							if (fi != null)
								fi.close();
							if (bis != null)
								bis.close();
							if (writer != null)
								writer.close();
						} catch (Exception e) {
//							e.printStackTrace();
							rtn = -1;
						}
					}
				}
			}
		}
		return true;

	}
    	
    
	private boolean getFileDec(String filePath, String fileName)
			throws Exception {

		BufferedInputStream in = null;
		BufferedOutputStream out = null;
		Madec clMadec = null;
		long FileLength = 0;
		long OutFileLength = 0;
		File FileSample = new File(filePath);
		File FileOut = new File(filePath + "_DEC");
		String tempFileName = fileName+"_MAD";
		try {
			in = new BufferedInputStream(new FileInputStream(FileSample));
			out = new BufferedOutputStream(new FileOutputStream(FileOut));
			Configuration conf = new Configuration();
			
			clMadec = new Madec(conf.getString("sepoa.mad.dat.src"));
			Logger.debug.println("clMadec = " + conf.getString("sepoa.mad.dat.src"));
			
			FileLength = FileSample.length();

			long beforetime = System.currentTimeMillis();

			// only file
			OutFileLength = clMadec.lGetDecryptFileSize(tempFileName, FileLength,
					in);

//			System.out.println("OutFileLength = " + OutFileLength);

			if (OutFileLength > 0) {
//				System.out.println("Decryption !!!! Start !!!! \n ");
				String strRetCode = clMadec.strMadec(out);
//				System.out.println(strRetCode);
				Logger.debug.println("strRetCode = " + strRetCode);
			} else {
				String strErrorCode = clMadec.strGetErrorCode();
//				System.out.println("[ErrorCode] " + strErrorCode
//						+ " [ErrorDescription] "
//						+ clMadec.strGetErrorMessage(strErrorCode));
				Logger.debug.println("[ErrorCode] " + strErrorCode
						+ " [ErrorDescription] "
						+ clMadec.strGetErrorMessage(strErrorCode));
			}
		} catch (Exception e) {
    		Logger.debug.println(e);
//			e.printStackTrace();
			return false;
		} finally { if(in != null){ IOUtils.closeQuietly(in); } if(out != null){ IOUtils.closeQuietly(out); } } 
		return true;
	}
	
	/**
     * 자본예산지급 결재 
     * @param inf
     * @return
     */
    public SepoaOut Approval_PSB(SignResponseInfo inf)
    {
    	String ans = inf.getSignStatus();
    	String where = "";
    	
    	String[] doc_no = inf.getDocNo();
    	String[] com_code = inf.getCompanyCode();
    	String[] doc_seq = inf.getDocSeq();
    	
    	ConnectionContext ctx = getConnectionContext();
    	
    	try {
    		Map<String, String> data = new HashMap<String, String>();
    		data.put("sign_status"	, ans);
    		data.put("pay_send_no"  , doc_no[0]);    		
    		
    		SepoaXmlParser 	wxp1= new SepoaXmlParser(this, "setSpy1gl_sign_status");
    		SepoaSQLManager sm 	= new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp1.getQuery());
    		sm.doInsert(data);
    		setStatus(1);
    		Commit();
//			Rollback();
    		
    	} catch(Exception e) {
    		Logger.err.println("Approval_14: = " + e.getMessage());
    		setStatus(0);
    	}
    	return getSepoaOut();
    }
    
    
    /**
     * 계좌번호변경요청 결재 
     * @param inf
     * @return
     */
    public SepoaOut Approval_AR(SignResponseInfo inf)
    {
    	String ans = inf.getSignStatus();
    	String where = "";
    	
    	String[] doc_no = inf.getDocNo();
    	String[] com_code = inf.getCompanyCode();
    	String[] doc_seq = inf.getDocSeq();
    	
    	ConnectionContext ctx = getConnectionContext();

		
    	SepoaOut      value        = null;
    	int                rowCount  = 0;
    	int                iRtnCnt      = 0;     // 성공여부
	    boolean       isStatus     = false;
 	    SepoaFormater sf           = null;
    	
    	try {
    		String house_code = info.getSession("HOUSE_CODE");

    		Map<String, String> data = new HashMap<String, String>();
    		data.put("house_code"	, house_code);
    		data.put("sign_status"	, ans);
    		data.put("ar_no"  , doc_no[0]);
    		data.put("sign_person_id"  , info.getSession("ID"));    		    	
    		
    		SepoaXmlParser  wxp= new SepoaXmlParser(this, "setIcoyarhd_sign_status");
    		SepoaSQLManager sm 	= new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
    		sm.doUpdate(data);
    		
    		
    		if(ans.equals("E")){
    			    		
				Object[] obj = {data};
		    	value    = ServiceConnector.doService(info, "t0002", "CONNECTION","getIcoyarhdList", obj);
		    	isStatus = value.flag;			
				if(isStatus){
					//gdRes.setMessage(message.get("MESSAGE.0001").toString());
					//gdRes.setStatus("false");
					    		
					sf= new SepoaFormater(value.result[0]);
					rowCount = sf.getRowCount(); // 조회 row 수
					
					if(rowCount == 1){
			    		
			    		data.put("vendor_code"          ,  sf.getValue("VENDOR_CODE",0));
			    		data.put("P_BANK_CODE"             ,  SepoaString.getDateUnSlashFormat( sf.getValue("P_BANK_CODE",0)) );
			    		data.put("P_BANK_ACCT"       ,  sf.getValue("P_BANK_ACCT",0));
			    		data.put("P_DEPOSITOR_NAME"            ,	 sf.getValue("P_DEPOSITOR_NAME",0));
			    		
			    		SepoaXmlParser wxp2= new SepoaXmlParser(this, "setIcomvngl_acct");
			    		SepoaSQLManager sm2 	= new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp2.getQuery());
			    		sm2.doUpdate(data);
					}
				}
			
    		}
    		
    		
    		
    		setStatus(1);
    		Commit();
//			Rollback();
    		
    	} catch(Exception e) {
    		Logger.err.println("Approval_AR: = " + e.getMessage());
    		setStatus(0);
    	}
    	return getSepoaOut();
    }
}