package	dt.ebd;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import org.apache.commons.collections.MapUtils;

import com.woorifg.barcode.webservice.EPS_007_WSStub;
import com.woorifg.barcode.webservice.EPS_007_WSStub.ArrayOfString;
import com.woorifg.barcode.webservice.EPS_007_WSStub.EPS0029;
import com.woorifg.barcode.webservice.EPS_007_WSStub.EPS0029Response;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaStringTokenizer;
import ucMessage.UcMessage;
import wisecommon.SignRequestInfo;
import wisecommon.SignResponseInfo;




/**
 * <pre>
 *
 * <code>
 * (#)dt/pr/p1009.java	01/06/27
 * Copyright 2001-2001 ICOMPIA Co.,	Ltd. All Rights	Reserved.
 * This	software is	the	proprietary	information	of ICOMPIA Co.,	Ltd.
 * @version		   1.0
 * @author		   tykim
 *
 * </code></pre>
 */
public class p1015 extends SepoaService
{
	private HashMap<String,String> msg = null;
	
	public p1015(String	opt,SepoaInfo info) throws Exception
	{
		super(opt,info);
		setVersion("1.0.0");
        Vector multilang_id = new Vector();
    	multilang_id.addElement("STDRFQ");
    	multilang_id.addElement("STDCOMM");
    	multilang_id.addElement("STDPR");
    	multilang_id.addElement("p10_pra");
        msg = MessageUtil.getMessage(info,multilang_id);
	}

	//private	Message	msg	= new Message(info.getSession("LANGUAGE"),"STDRFQ");

	public SepoaOut setApprovalCreate(
			  String sign_status
			, String approval_str
			, String ttl_amt
    		, String[][] data_dt
			, Object[] args
			) throws Exception
	{
		String add_user_id     =  info.getSession("ID");
        String house_code      =  info.getSession("HOUSE_CODE");
        String company         =  info.getSession("COMPANY_CODE");
        String add_user_dept   =  info.getSession("DEPARTMENT");
        String lang            =  info.getSession("LANGUAGE");

		ConnectionContext ctx =	getConnectionContext();

		String[] RFQ_NO 		= (String[])args[0];
		String[] RFQ_COUNT 		= (String[])args[1];
		String[] QTA_NO 		= (String[])args[2];
		String[] SUBJECT 		= (String[])args[3];
        try
        {
            //Bidding Approval 사용여부
            String bd_approval = CommonUtil.getConfig("Sepoa.bd_approval.use");
            Logger.err.println(info.getSession("ID"),this,"======================"+bd_approval);
            Logger.err.println(info.getSession("ID"),this,"======================"+sign_status);
            // Approval 사용할때.
            if(sign_status.equals("P")&& bd_approval.equals("true"))
            {
				//for(int i=0;i<QTA_NO.length;i++)
				//{
		                SignRequestInfo sri = new SignRequestInfo();
		                sri.setHouseCode(house_code);
		                sri.setCompanyCode(company);
		                sri.setDept(add_user_dept);
		                sri.setReqUserId(add_user_id);
		                sri.setDocType("BS");
	        			sri.setDocNo(RFQ_NO[0]);
            			sri.setDocName(SUBJECT[0]);
		                sri.setDocSeq(RFQ_COUNT[0]);
		                sri.setItemCount(data_dt.length);
		                sri.setSignStatus(sign_status);
		                sri.setTotalAmt(Double.parseDouble(ttl_amt));

		                sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
		                int rtn = CreateApproval(info,sri);    //밑에 함수 실행
		                if(rtn == 0)
		                {
		                    throw new Exception(msg.get("STDRFQ.0030"));
		                }
		                int signup = temp_Approval(ctx, RFQ_NO[0], RFQ_COUNT[0],	"P");

		                setStatus(1);
		                setValue(RFQ_NO[0]);
		                msg.put("RFQ_NO",RFQ_NO[0]);
		                setMessage(msg.get("STDRFQ.0048"));
		          //}
            }
            Commit();
        }
        catch(Exception e)
        {
            try
            {
                Rollback();
            }
            catch(Exception d)
            {
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            Logger.err.println(info.getSession("ID"),this,"Rollback error"+e.getMessage());
            setStatus(0);
            setMessage(msg.get("STDRFQ.0003"));
        }

        return getSepoaOut();
	}
	/**
	 * 결재 정보를 요청한다.
	 * @param info
	 * @param sri
	 * @return
	 */
	private int CreateApproval(SepoaInfo info,SignRequestInfo sri) throws Exception  // 결재모듈에 필요한 생성부분
    {                                                                                // 그대로 갖다 쓴다.

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
            Logger.err.println("approval: = " + e.getMessage());
        }
        return wo.status ;
    }

    public SepoaOut Approval(SignResponseInfo inf) {

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
                    if(tmp_doc_no.equals("PR")) rtn = setReqApproval( doc_no, sign_date, sign_user_id,app_rtn);
                	else rtn = setApproval( doc_no, sign_date, sign_user_id,app_rtn);
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


/**
 * 결재완료 후 처리하는 메소드
 **/
    private int setApproval(String rfq_no,
                            String sign_date,
                            String sign_user_id,
                            String app_rtn ) throws Exception
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

        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;

        StringBuffer sql = null;

		String rtn_mtgl="";
        String rtnString = "";
		String rtn = "";
		int rtnIns = 0;
		String addSql = "";

        try {
//            sql = new StringBuffer();
        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            	//wxp.addVar("app_rtn", app_rtn);
            	if("E".equals(app_rtn)){
            		addSql = "SET    SIGN_STATUS    = 'E',"; 
            	}else if("R".equals(app_rtn)){
            		addSql = "SET SIGN_STATUS    = 'R', RFQ_FLAG     = 'N',";
            	}else if("D".equals(app_rtn)){
            		addSql = "SET SIGN_STATUS    = 'D', RFQ_FLAG        = 'N',";
            	}
            	wxp.addVar("addSql", addSql);
        		wxp.addVar("sign_date", sign_date);
        		wxp.addVar("sign_user_id", sign_user_id);
            	wxp.addVar("house_code", house_code);
            	wxp.addVar("rfq_no", rfq_no);            	
            	
            	

//            sql.append( "UPDATE    ICOYRQHD                                         \n" );
//
//            if( app_rtn.equals("E") )
//            {
//                sql.append( " SET    SIGN_STATUS    = 'E',                          \n" );
//            }
//            else if( app_rtn.equals("R") ){
//                sql.append( " SET       SIGN_STATUS    = 'R',                       \n" );
//                sql.append( "           RFQ_FLAG     = 'N',                          \n" );// RFQ_FLAG : N 이면 임시저장
//            }
//            else if( app_rtn.equals("D") ){                      // 취소
//                sql.append( " SET   SIGN_STATUS    = 'D',                           \n" );
//                sql.append( "        RFQ_FLAG        = 'N',                          \n" );
//            }
//            sql.append( "        SIGN_DATE    = '"+sign_date+"',                    \n" );
//            sql.append( "        SIGN_PERSON_ID    = '"+sign_user_id+"'             \n" );
//            sql.append( "WHERE    HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'  \n" );
//            sql.append( "  AND    RFQ_NO = '"+rfq_no+"'                               \n" );

            // sql이 null로 선언돼있어서, 객체에 접근할수 없음.
            sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,(String)null);
            //sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
            rtnIns = sm.doInsert();
//
//            sql = new StringBuffer();
//			sql.append("SELECT DISTINCT PRHD.CREATE_TYPE FROM ICOYPRHD PRHD, ICOYRQDT RQDT      \n" );
//			sql.append("WHERE PRHD.HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'  			\n" );
//			sql.append("AND PRHD.HOUSE_CODE = RQDT.HOUSE_CODE             						\n" );
//			sql.append("AND PRHD.PR_NO = RQDT.PR_NO             								\n" );
//			sql.append("AND RQDT.RFQ_NO =  '"+rfq_no+"'                               			\n" );
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
		    rtn = sm.doSelect((String[])null);
			SepoaFormater wf	= new SepoaFormater(rtn);

            if( app_rtn.equals("E") && (wf.getValue(0, 0).equals("AC")) )
            {
				//ICOMMTGL이 존재하는 경우에만 단가를 생성한다// 건수가 0 인경우도 존재할수 있음
	            rtn_mtgl =checkMtglItem(rfq_no);
		  	    wf =  new SepoaFormater(rtn_mtgl);

		  		int iRowCount = wf.getRowCount();
		  		if(iRowCount>0) {
		  			rtn_mtgl = wf.getValue("CNT", 0);
		  		}

	              //if(!rtn_mtgl.equals("0")){
	  					String[] objExecInfo = {house_code, rfq_no};
						String[][] objInfo = {
								{
									add_date
									, add_time
									, user_id
									, add_date
									, add_time
									, user_id
									, house_code
									, rfq_no
								}
						};
						String[][] objInfh = {
								{
									house_code
									, rfq_no
								}
					};
	  			//레벨별 단가삭제(DELETE ICOYINFO, ICOYINDR)
	  			 delInfoData(objExecInfo);

	  			//새로운  단가생성(INSERT ICOYINFO, ICOYINDR)
	  			 createInfoData(objInfo);

	  			//ICOYINFH(히스토리 테이블) 생성
	  			 createInfhData(objInfh);

	              //}// ICOMMTGL이 존재하는 경우에만 단가를 생성한다 if end

			}
            /**
             * 현재는 잠시 막아둠 : 2006.04.10 ,박은숙
            //업체메일전송
            if( app_rtn.equals("E") )
            {
                Logger.debug.println(info.getSession("ID"),this,"Mail Enter ");
                setMail(ra_no);
            }
            **/

       }
        catch(Exception e) {

            rtnString = "ERROR";
            Logger.debug.println(info.getSession("ID"),this,"et_setratppins_1 = " + e.getMessage());

        }

        return rtnIns;
    }

    private int setReqApproval(String pr_no,
                            String sign_date,
                            String sign_user_id,
                            String app_rtn ) throws Exception
    {
        int rtn = -1;

        try {
            String house_code = info.getSession("HOUSE_CODE");

            ConnectionContext ctx = getConnectionContext();
//
            String rtnSel =  getusername(sign_user_id);
            SepoaFormater wf = new SepoaFormater(rtnSel);
            String signname = wf.getValue(0,0);
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            	wxp.addVar("app_rtn", app_rtn);
            	wxp.addVar("sign_date", sign_date);
            	wxp.addVar("sign_user_id", sign_user_id);
            	wxp.addVar("house_code", house_code);
            	wxp.addVar("pr_no", pr_no);
//            StringBuffer sql = new StringBuffer();
//            sql.append(" UPDATE ICOYPRHD SET                        									\n");
//            sql.append("        SIGN_STATUS = '"+app_rtn+"',           									\n");
//    		sql.append("        SIGN_DATE = '"+sign_date+"',         									\n");
//            sql.append("        SIGN_PERSON_ID = '"+sign_user_id+"',  									\n");
//            sql.append("        SIGN_PERSON_NAME = dbo.GETUSERNAME(HOUSE_CODE, '"+sign_user_id+"', 'LOC')   \n");
//            sql.append(" WHERE HOUSE_CODE = '"+house_code+"'        									\n");
//            sql.append(" AND   STATUS != 'D'                        									\n");
//            sql.append(" AND   PR_NO = '"+pr_no+"'                            							\n");

            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
            rtn = sm.doUpdate();
        }catch(Exception e) {
            throw new Exception("setSIGN_STATUS:"+e.getMessage());
        }

        return rtn;
    }

     private String checkMtglItem(String rfq_no) throws Exception
	{
		String user_id	  =	info.getSession("ID");
		String house_code =	info.getSession("HOUSE_CODE");
		String rtn = "";

//		StringBuffer sql = new StringBuffer();
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("rfq_no", rfq_no);

//		sql.append(" select count(*) as CNT                                              	\n");
//		sql.append("   from ICOMMTGL MTGL                                                  	\n");
//		sql.append(" WHERE MTGL.HOUSE_CODE = '"+house_code+"'                              	\n");
//		sql.append(" AND MTGL.ITEM_NO IN (SELECT DISTINCT  QTDT.ITEM_NO                     \n");
//		sql.append("                        FROM ICOYQTHD QTHD, ICOYQTDT QTDT               \n");
//		sql.append("                        WHERE QTHD.HOUSE_CODE = MTGL.HOUSE_CODE    		\n");
//		sql.append("                        AND QTHD.RFQ_NO = '"+rfq_no+"'     				\n");
//		sql.append("                        AND QTDT.HOUSE_CODE = QTHD.HOUSE_CODE     		\n");
//		sql.append("                        AND QTHD.QTA_NO = QTDT.QTA_NO    				\n");
//		sql.append("                        AND QTHD.RFQ_NO = QTDT.RFQ_NO     				\n");
//		sql.append("                        AND QTHD.RFQ_COUNT = QTDT.RFQ_COUNT   )         \n");


		try
		{
			ConnectionContext ctx =	getConnectionContext();

			SepoaSQLManager sm =	null;

			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

		    rtn = sm.doSelect((String[])null);
		}
		catch(Exception	e)
		{
				throw new Exception("checkMtglItem:"+e.getMessage());
		}
		return rtn;
	}


	public SepoaOut getBidBiddingList(String[] args)
	{
		String lang = info.getSession("LANGUAGE");

		try
		{
			String rtn = et_getBidBiddingList(args);
			setValue(rtn);

			setStatus(1);
			setMessage(msg.get("STDCOMM.0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDCOMM.0001"));
		}
		return getSepoaOut();
	}

 	private	String et_getBidBiddingList(String[] args) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");
//		tSQL.append(" SELECT      DISTINCT																								\n");
//		tSQL.append(" 	 QTDT.VENDOR_CODE                                                       										\n");
//		tSQL.append("   , dbo.GETVENDORNAME(QTDT.HOUSE_CODE, QTDT.VENDOR_CODE) AS VENDOR_NAME       										\n");
//		tSQL.append(" 	, QTDT.QTA_NO                                                           										\n");
//		tSQL.append(" 	, isnull(RQHD.BID_TECHNIQUE_EVAL  ,0) AS BID_TECHNIQUE_EVAL                                        				\n");
// 		tSQL.append(" 	, isnull(RQHD.BID_PRICE_EVAL  ,0) AS BID_PRICE_EVAL                                        						\n");
// 		tSQL.append(" 	, ROUND(dbo.getTechnique_Price_Eval(QTDT.HOUSE_CODE, QTDT.RFQ_NO, QTDT.RFQ_COUNT, RQHD.BID_TECHNIQUE_EVAL			\n");
//		tSQL.append(" 								,(SELECT SUM(SCORE) AS SCORE FROM ICOYTBSE											\n");
// 	 	tSQL.append(" 	   								WHERE HOUSE_CODE = QTDT.HOUSE_CODE AND DOC_NO = QTDT.RFQ_NO 					\n");
// 	    tSQL.append(" 	   								AND DOC_SEQ = QTDT.RFQ_COUNT AND VENDOR_CODE = QTDT.VENDOR_CODE )				\n");
// 	    //tSQL.append(" 	   								/ (SELECT COUNT(*) FROM ICOYTBUS		\n");
//        //tSQL.append(" 	   								                WHERE HOUSE_CODE = QTHD.HOUSE_CODE		\n");
//        //tSQL.append(" 	   								                 AND DOC_NO = QTHD.RFQ_NO AND DOC_SEQ = QTHD.RFQ_COUNT)		\n");
//
// 	    /* getTechnique_Price_Eval의 마지막 파라미터 '' 대신 vendor_code로 대체..*/
// 	    //tSQL.append(" 	  							, 'T', ''),1) AS SCORE_EVAL																\n");
//		tSQL.append(" 	  							, 'T', QTHD.VENDOR_CODE),1) AS SCORE_EVAL																\n");
//		//tSQL.append(" 	, ROUND(dbo.getTechnique_Price_Eval(QTDT.HOUSE_CODE, QTDT.RFQ_NO, QTDT.RFQ_COUNT, RQHD.BID_PRICE_EVAL,QTHD.TTL_AMT, 'P', ''),1) AS PRICE_EVAL	\n");
//		tSQL.append(" 	, ROUND(dbo.getTechnique_Price_Eval(QTDT.HOUSE_CODE, QTDT.RFQ_NO, QTDT.RFQ_COUNT, RQHD.BID_PRICE_EVAL,QTHD.TTL_AMT, 'P', QTHD.VENDOR_CODE),1) AS PRICE_EVAL	\n");
//
//		tSQL.append(" 	, (SELECT COUNT(*) FROM ICOYTBUS WHERE HOUSE_CODE = QTHD.HOUSE_CODE AND DOC_NO = QTHD.RFQ_NO AND DOC_SEQ = QTHD.RFQ_COUNT) AS EVAL_USER	\n");
//		tSQL.append(" 	, RQDT.CUR                                                              				\n");
//		tSQL.append(" 	, QTHD.TTL_AMT                                                          				\n");
//		tSQL.append(" 	, QTDT.SETTLE_FLAG                                                      				\n");
//		tSQL.append(" 	, QTDT.SETTLE_REMARK                                                    				\n");
//		tSQL.append(" FROM ICOYQTHD QTHD,ICOYQTDT QTDT, ICOYRQDT RQDT, ICOYRQHD RQHD            				\n");
//		tSQL.append(" <OPT=F,S> WHERE QTDT.HOUSE_CODE = ? </OPT>                                				\n");
//		tSQL.append(" <OPT=F,S> AND QTDT.RFQ_NO    = ?    </OPT>                                				\n");
//		tSQL.append(" <OPT=F,S> AND QTDT.RFQ_COUNT = ?    </OPT>                                				\n");
//		tSQL.append(" AND QTHD.HOUSE_CODE = QTDT.HOUSE_CODE                                     				\n");
//		tSQL.append(" AND QTHD.VENDOR_CODE = QTDT.VENDOR_CODE                                   				\n");
//		tSQL.append(" AND QTHD.QTA_NO = QTDT.QTA_NO                                             				\n");
//		tSQL.append(" AND QTDT.RFQ_NO = QTDT.RFQ_NO                                             				\n");
//		tSQL.append(" AND QTHD.RFQ_COUNT = QTDT.RFQ_COUNT                                       				\n");
//		tSQL.append(" AND QTDT.HOUSE_CODE = RQDT.HOUSE_CODE                                     				\n");
//		tSQL.append(" AND QTDT.RFQ_NO = RQDT.RFQ_NO                                             				\n");
//		tSQL.append(" AND QTDT.RFQ_COUNT = RQDT.RFQ_COUNT                                       				\n");
//		tSQL.append(" AND QTDT.RFQ_SEQ = RQDT.RFQ_SEQ                                           				\n");
//		tSQL.append(" AND RQDT.HOUSE_CODE = RQHD.HOUSE_CODE                                     				\n");
//		tSQL.append(" AND RQDT.RFQ_NO = RQHD.RFQ_NO                                             				\n");
//		tSQL.append(" AND RQDT.RFQ_COUNT = RQHD.RFQ_COUNT                                       				\n");
//		//tSQL.append(" AND RQHD.RFQ_FLAG ='C'                                                    				\n");
//		tSQL.append(" AND RQHD.BID_TYPE = 'EX'                                                  				\n");
//		tSQL.append(" AND QTHD.STATUS != 'D'                                                    				\n");
//		tSQL.append(" AND QTDT.STATUS != 'D'                                                    				\n");
//		tSQL.append(" AND RQDT.STATUS != 'D'                                                    				\n");
//		tSQL.append(" AND RQHD.STATUS != 'D'                                                    				\n");

		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn	= sm.doSelect(args);
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
//
	public SepoaOut getBidList(
				String server_date
				, String  house_code
				, String from_date
				, String to_date
				, String ctrl_code
				, String tmpServerDate
				, String bid_status
				, String bid_req_type
				, String add_user_id
				, String subject
				, String sign_status  ) {
		String lang = info.getSession("LANGUAGE");

		try	{
			// bid_flag	(P:결재진행, R:결재반려, P1:진행, P2:예정, C:종료, AL:전체)
			String rtn = et_getBidList(server_date
				,  house_code
				, from_date
				, to_date
				, ctrl_code
				, tmpServerDate
				, bid_status
				, bid_req_type
				, add_user_id
				, subject
				, sign_status  );
			setValue(rtn);
			setStatus(1);
			setMessage(msg.get("STDRFQ.0000"));
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDRFQ.0001"));
		}
		return getSepoaOut();
	}

	private	String et_getBidList(
				String server_date
				, String  house_code
				, String from_date
				, String to_date
				, String ctrl_code
				, String tmpServerDate
				, String bid_status
				, String bid_req_type
				, String add_user_id
				, String subject
				, String sign_status   ) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
		//String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");
		String DBOwner = "dbo";

		ctrl_code = DoWorkWithCtrl_code(ctrl_code);

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("DBOwner", "dbo");
		wxp.addVar("ctrl_code", ctrl_code);
//		StringBuffer tSQL = new StringBuffer();
//		tSQL.append(" SELECT    DISTINCT            																																				\n");
//		tSQL.append("    HD.RFQ_NO                                                                                       																		    \n");
//		tSQL.append("  , HD.RFQ_COUNT                                                                                    																		    \n");
//		tSQL.append("  , "+DBOwner+".GETICOMCODE2(HD.HOUSE_CODE,'M208', HD.BID_REQ_TYPE) AS BID_REQ_TYPE            																			    \n");
//		tSQL.append("  , HD.SUBJECT            																																					    \n");
//		tSQL.append("  , HD.RFQ_DATE            																																				    \n");
//		tSQL.append("  , HD.RFQ_CLOSE_DATE            																																			    \n");
//		tSQL.append("  , dbo.GETUSERNAMELOC (HD.HOUSE_CODE, HD.ADD_USER_ID) AS ADD_USER_NAME             																							    \n");
//		tSQL.append("  , HD.CTRL_CODE                                                                                    																		    \n");
//		tSQL.append("  <OPT=F,S> , "+DBOwner+".getrfqflag(HD.HOUSE_CODE,HD.RFQ_NO,HD.RFQ_COUNT, ? ,HD.BID_TYPE,'B','') AS BID_STATUS </OPT>           											    \n");
//		tSQL.append("  <OPT=F,S> , "+DBOwner+".GETICOMCODE2(HD.HOUSE_CODE,'M137',"+DBOwner+".getrfqflag(HD.HOUSE_CODE,HD.RFQ_NO,HD.RFQ_COUNT, ? ,HD.BID_TYPE,'B','')) AS BID_STATUS_TEXT  </OPT>	\n");
//		tSQL.append("  , (SELECT COUNT(*) FROM ICOYRQSE                     																											    \n");
//		tSQL.append("   WHERE HOUSE_CODE = DT.HOUSE_CODE                     																													    \n");
//		tSQL.append("   AND   RFQ_NO	  = DT.RFQ_NO                     																														    \n");
//		tSQL.append("   AND   RFQ_COUNT  = DT.RFQ_COUNT                     																													    \n");
//		tSQL.append("   AND   RFQ_SEQ	  = DT.RFQ_SEQ)  AS VENDOR_COUNT     																													    \n");
//		tSQL.append("  , HD.BID_COUNT                                                                                    																		    \n");
//		tSQL.append("  <OPT=F,S> , "+DBOwner+".getBidStatusText(HD.HOUSE_CODE,HD.RFQ_NO,HD.RFQ_COUNT, ? ,HD.BID_TYPE  ) AS SIGN_STATUS_TEXT	 </OPT>   											    \n");
//		tSQL.append("  , HD.SIGN_STATUS                                                                                    																		    \n");
//		tSQL.append(" FROM ICOYRQHD HD , ICOYRQDT DT                                                                     															    \n");
//		tSQL.append(" <OPT=F,S> WHERE HD.HOUSE_CODE = ? </OPT>                                                           																		    \n");
//		tSQL.append(" <OPT=F,S> AND HD.RFQ_DATE BETWEEN ? </OPT>                                                      																			    \n");
//		tSQL.append(" <OPT=F,S> AND ?                  </OPT>                                                         																			    \n");
//
//		tSQL.append(" AND HD.CTRL_CODE IN ( '"+ctrl_code+"' )                                                      																				    \n");
//		tSQL.append(" <OPT=S,S> AND "+DBOwner+".getrfqflag(HD.HOUSE_CODE,HD.RFQ_NO,HD.RFQ_COUNT, ? </OPT> <OPT=S,S> ,HD.BID_TYPE,'B','') = ? </OPT>  											    \n");
//		tSQL.append(" <OPT=S,S> AND HD.BID_REQ_TYPE   =  ?  </OPT>                                       				  																		    \n");
//		tSQL.append(" <OPT=S,S> AND HD.ADD_USER_ID   =  ?  </OPT>                                       				  																		    \n");
//		tSQL.append(" <OPT=S,S> AND HD.SUBJECT  LIKE '%'+?+'%' </OPT>                                       				  																		    \n");
//		tSQL.append(" <OPT=S,S> AND HD.SIGN_STATUS = ?  </OPT>                                                                             														    \n");
//		tSQL.append(" AND HD.RFQ_FLAG ='P'                                                                               																		    \n");
//		tSQL.append(" AND HD.BID_TYPE = 'EX' --전자입찰                                                                                                                                       	    \n");
//		tSQL.append(" AND HD.STATUS != 'D'                                                                               																		    \n");
//		tSQL.append(" AND HD.HOUSE_CODE = DT.HOUSE_CODE                                                                             															    \n");
//		tSQL.append(" AND HD.RFQ_NO = DT.RFQ_NO                                                                             																	    \n");
//		tSQL.append(" AND HD.RFQ_COUNT = DT.RFQ_COUNT                                                                           																    \n");
//
//		tSQL.append(" UNION ALL                                                                                       																			    \n");
//		tSQL.append(" SELECT          DISTINCT                                                                                																	    \n");
//		tSQL.append("    HD.RFQ_NO                                                                                       																		    \n");
//		tSQL.append("  , HD.RFQ_COUNT                                                                                    																		    \n");
//		tSQL.append("  , "+DBOwner+".GETICOMCODE2(HD.HOUSE_CODE,'M208', HD.BID_REQ_TYPE) AS BID_REQ_TYPE            																			    \n");
//		tSQL.append("  , HD.SUBJECT            																																					    \n");
//		tSQL.append("  , HD.RFQ_DATE            																																				    \n");
//		tSQL.append("  , HD.RFQ_CLOSE_DATE            																																			    \n");
//		tSQL.append("  , dbo.GETUSERNAMELOC (HD.HOUSE_CODE, HD.ADD_USER_ID) AS ADD_USER_NAME             																							    \n");
//		tSQL.append("  , HD.CTRL_CODE                                                                                    																		    \n");
//		tSQL.append("  <OPT=F,S> , "+DBOwner+".getrfqflag(HD.HOUSE_CODE,HD.RFQ_NO,HD.RFQ_COUNT, ? ,HD.BID_TYPE,'B','') AS BID_STATUS </OPT>           											    \n");
//		tSQL.append("  <OPT=F,S> , "+DBOwner+".GETICOMCODE2(HD.HOUSE_CODE,'M137',"+DBOwner+".getrfqflag(HD.HOUSE_CODE,HD.RFQ_NO,HD.RFQ_COUNT, ? ,HD.BID_TYPE,'B','')) AS BID_STATUS_TEXT  </OPT>    \n");
//		tSQL.append("  , (SELECT COUNT(*) FROM ICOYRQSE                     																											    \n");
//		tSQL.append("   WHERE HOUSE_CODE = DT.HOUSE_CODE                     																													    \n");
//		tSQL.append("   AND   RFQ_NO	  = DT.RFQ_NO                     																														    \n");
//		tSQL.append("   AND   RFQ_COUNT  = DT.RFQ_COUNT                     																													    \n");
//		tSQL.append("   AND   RFQ_SEQ	  = DT.RFQ_SEQ)  AS VENDOR_COUNT     																													    \n");
//		tSQL.append("  , HD.BID_COUNT                                                                                    																		    \n");
//		tSQL.append("  <OPT=F,S> , "+DBOwner+".getBidStatusText(HD.HOUSE_CODE,HD.RFQ_NO,HD.RFQ_COUNT, ? ,HD.BID_TYPE  ) AS SIGN_STATUS_TEXT	 </OPT>   											    \n");
//		tSQL.append("  , HD.SIGN_STATUS                                                                                    																		    \n");
//		tSQL.append(" FROM ICOYRQHD HD , ICOYRQDT DT                                                                 																    \n");
//		tSQL.append(" <OPT=F,S> WHERE HD.HOUSE_CODE = ? </OPT>                                                           																		    \n");
//		tSQL.append(" <OPT=F,S> AND HD.RFQ_DATE BETWEEN ? </OPT>                                                      																			    \n");
//		tSQL.append(" <OPT=F,S> AND ?                  </OPT>                                                         																			    \n");
//
//		tSQL.append(" AND HD.CTRL_CODE IN ( '"+ctrl_code+"' )                                                      																				    \n");
//		tSQL.append(" <OPT=S,S> AND "+DBOwner+".getrfqflag(HD.HOUSE_CODE,HD.RFQ_NO,HD.RFQ_COUNT, ? </OPT> <OPT=S,S> ,HD.BID_TYPE,'B','') = ? </OPT>  											    \n");
//		tSQL.append(" <OPT=S,S> AND HD.BID_REQ_TYPE   =  ?  </OPT>                                       				  																		    \n");
//		tSQL.append(" <OPT=S,S> AND HD.ADD_USER_ID   =  ?  </OPT>                                       				  																		    \n");
//		tSQL.append(" <OPT=S,S> AND HD.SIGN_STATUS = ?  </OPT>                                                                             														    \n");
//		tSQL.append(" AND HD.RFQ_COUNT = '1'                                                                             																		    \n");
//		tSQL.append(" AND HD.RFQ_FLAG = 'N'                                                                              																		    \n");
//		tSQL.append(" AND HD.BID_TYPE = 'EX'                                                                             																		    \n");
//		tSQL.append(" AND HD.STATUS != 'D'                                                                               																		    \n");
//		tSQL.append(" AND HD.HOUSE_CODE = DT.HOUSE_CODE                                                                             															    \n");
//		tSQL.append(" AND HD.RFQ_NO = DT.RFQ_NO                                                                             																	    \n");
//		tSQL.append(" AND HD.RFQ_COUNT = DT.RFQ_COUNT                                                                           																    \n");

		try	{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			String[] data =	{server_date
				, server_date
				, server_date
				,  house_code
				, from_date
				, to_date
				, tmpServerDate
				, bid_status
				, bid_req_type
				, add_user_id
				, subject
				, sign_status

				, server_date
				, server_date
				, server_date
			    , house_code
				, from_date
				, to_date
				, tmpServerDate
				, bid_status
				, bid_req_type
				, add_user_id
				, sign_status };
			rtn	= sm.doSelect(data);
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
//
	public SepoaOut getBidResult(
				String server_date
				, String house_code
				, String from_date
				, String to_date
				, String ctrl_code
				, String tmpServerDate
				, String bid_status
				, String bid_req_type
				, String add_user_id
				, String subject)
	{
		String lang = info.getSession("LANGUAGE");

		try	{
			String rtn = et_getBidResult(
				server_date
				, house_code
				, from_date
				, to_date
				, ctrl_code
				, tmpServerDate
				, bid_status
				, bid_req_type
				, add_user_id
				, subject);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.get("STDRFQ.0000"));
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDRFQ.0001"));
		}
		return getSepoaOut();
	}

	private	String et_getBidResult(
				String server_date
				, String house_code
				, String from_date
				, String to_date
				, String ctrl_code
				, String tmpServerDate
				, String bid_status
				, String bid_req_type
				, String add_user_id
				, String subject) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
		//String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");
		String DBOwner = "dbo";

		ctrl_code = DoWorkWithCtrl_code(ctrl_code);


		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("DBOwner", "dbo");
		wxp.addVar("ctrl_code", ctrl_code);
//		StringBuffer tSQL = new StringBuffer();
//		tSQL.append(" SELECT    DISTINCT                                                                            								\n");
//		tSQL.append("    HD.RFQ_NO                                                                                  								\n");
//		tSQL.append("  , HD.RFQ_COUNT                                                                               								\n");
//		tSQL.append("  , "+DBOwner+".GETICOMCODE2(HD.HOUSE_CODE,'M138', HD.BID_REQ_TYPE) AS BID_REQ_TYPE            								\n");
//		tSQL.append("  , HD.SUBJECT            																										\n");
//		tSQL.append("  , HD.RFQ_DATE            																									\n");
//		tSQL.append("  , HD.RFQ_CLOSE_DATE            																								\n");
//		tSQL.append("  , dbo.GETUSERNAMELOC (HD.HOUSE_CODE, HD.ADD_USER_ID) AS ADD_USER_NAME             												\n");
//		tSQL.append("  , HD.CTRL_CODE                                                                               								\n");
//		tSQL.append("  <OPT=F,S> , "+DBOwner+".getrfqflag(HD.HOUSE_CODE,HD.RFQ_NO,HD.RFQ_COUNT, ? ,HD.BID_TYPE,'B','') AS BID_STATUS </OPT>         \n");
//		tSQL.append("  <OPT=F,S> , "+DBOwner+".GETICOMCODE2(HD.HOUSE_CODE,'M137',"+DBOwner+".getrfqflag(HD.HOUSE_CODE,HD.RFQ_NO,HD.RFQ_COUNT, ? ,HD.BID_TYPE,'B','')) AS BID_STATUS_TEXT  </OPT>  \n");
//		tSQL.append("  , (SELECT COUNT(*) FROM ICOYRQSE                     																\n");
//		tSQL.append("   WHERE HOUSE_CODE = DT.HOUSE_CODE                     																		\n");
//		tSQL.append("   AND   RFQ_NO	  = DT.RFQ_NO                     																			\n");
//		tSQL.append("   AND   RFQ_COUNT  = DT.RFQ_COUNT                     																		\n");
//		tSQL.append("   AND   RFQ_SEQ	  = DT.RFQ_SEQ)  AS VENDOR_COUNT     																		\n");
//		tSQL.append("  , HD.BID_COUNT                                                                               								\n");
//		tSQL.append("  , ISNULL(HD.BID_TECHNIQUE_EVAL,0) AS BID_TECHNIQUE_EVAL        																	\n");
//		tSQL.append("  , (CASE (SELECT COUNT(*) FROM ICOYTBEV WHERE HOUSE_CODE = DT.HOUSE_CODE														\n");
//		tSQL.append("    				AND DOC_NO = DT.RFQ_NO AND DOC_SEQ = DT.RFQ_COUNT) 															\n");
//		tSQL.append("       WHEN 0 THEN 'X' 																										\n");
//		tSQL.append("       ELSE  'Y' END) 	AS TBSE_COUNT																							\n");
//		tSQL.append("    , (CASE (SELECT COUNT(*) FROM ICOYTBEV WHERE HOUSE_CODE = DT.HOUSE_CODE													\n");
//		tSQL.append("      				AND DOC_NO = DT.RFQ_NO AND DOC_SEQ = DT.RFQ_COUNT)															\n");
//		tSQL.append("         WHEN 0 THEN 'X'																										\n");
//		tSQL.append("         ELSE																													\n");
//		tSQL.append("      CASE WHEN																												\n");
//		tSQL.append("      (SELECT COUNT(*) FROM ICOYTBUS WHERE HOUSE_CODE = DT.HOUSE_CODE															\n");
//		tSQL.append("    		AND DOC_NO = DT.RFQ_NO AND DOC_SEQ = DT.RFQ_COUNT AND TBS_YN = 'N'													\n");
//		tSQL.append("    		GROUP BY HOUSE_CODE, DOC_NO, DOC_SEQ) > 0  THEN 'N'																	\n");
//		tSQL.append("      ELSE 'Y' END  END) AS TBSE_YN																							\n");
//		tSQL.append("	,(select count(*) from icoytbus where doc_no = DT.RFQ_NO and doc_seq = DT.RFQ_COUNT) AS USER_CNT							\n");
//		tSQL.append(" FROM ICOYRQHD HD , ICOYRQDT DT                                                                								\n");
//		tSQL.append(" <OPT=F,S> WHERE HD.HOUSE_CODE = ? </OPT>                                                          							\n");
//		tSQL.append(" <OPT=F,S> AND HD.RFQ_DATE BETWEEN ? </OPT>                                                      								\n");
//		tSQL.append(" <OPT=F,S> AND ?                  </OPT>                                                         								\n");
//		//tSQL.append(" <OPT=S,S> AND HD.CTRL_CODE IN ( ? ) </OPT>                                                        							\n");
//		tSQL.append(" AND HD.CTRL_CODE IN ( '"+ctrl_code+"' )                                               										\n");
//		tSQL.append(" <OPT=S,S> AND "+DBOwner+".getrfqflag(HD.HOUSE_CODE,HD.RFQ_NO,HD.RFQ_COUNT, ? </OPT> <OPT=S,S> ,HD.BID_TYPE,'B','') = ? </OPT>	\n");
//		tSQL.append(" <OPT=S,S> AND HD.BID_REQ_TYPE   =  ?  </OPT>                                       				  							\n");
//		tSQL.append(" <OPT=S,S> AND HD.ADD_USER_ID   =  ?  </OPT>                                       				  							\n");
//		tSQL.append(" <OPT=S,S> AND HD.SUBJECT LIKE '%'+?+'%' </OPT>                                       				  							\n");
//		//tSQL.append(" AND HD.RFQ_FLAG IN ('C','R','B')                                                                               				\n");
//		tSQL.append(" AND HD.BID_TYPE = 'EX' --전자입찰                                                                                             \n");
//		tSQL.append(" AND dt.set_flag is null --우선선정협상여부 한번이상 선정은 안보이게...  \n");////////////////
//		tSQL.append(" AND HD.STATUS != 'D'                                                                               							\n");
//		tSQL.append(" AND HD.HOUSE_CODE = DT.HOUSE_CODE                                                                             				\n");
//		tSQL.append(" AND HD.RFQ_NO = DT.RFQ_NO                                                                             						\n");
//		tSQL.append(" AND HD.RFQ_COUNT = DT.RFQ_COUNT                                                                           					\n");
//		tSQL.append(" ORDER BY 1 DESC                                                                         										\n");
		try	{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] data =	{
				server_date
				, server_date
				, house_code
				, from_date
				, to_date
				, tmpServerDate
				, bid_status
				, bid_req_type
				, add_user_id
				, subject};
			rtn	= sm.doSelect(data);
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	public SepoaOut getBidHDDisplayChange(String[] args1, String[] args2)
	{
		String lang = info.getSession("LANGUAGE");

		try	{
			String rtn = et_getBidHDDisplayChange(args1);
			if(rtn == null)
				throw new Exception("doing select et_getBidHDDisplayChange");
			setValue(rtn);

			rtn = et_getBidCountInfo(args2);
			if(rtn == null)
				throw new Exception("doing select et_getBidCountInfo");
			setValue(rtn);

			//rtn = et_getBidQuota(args1);
			//if(rtn == null)
			//	throw new Exception("doing select et_getBidQuota");
			//setValue(rtn);

			rtn = et_getBidVendorSelect(args1);
			if(rtn == null)
				throw new Exception("doing select et_getBidVendorSelect");
			setValue(rtn);

 			setStatus(1);
			setMessage(msg.get("STDCOMM.0000"));
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDCOMM.0001"));
		}
		return getSepoaOut();
	}

	private	String et_getBidHDDisplayChange(String[] args) throws Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
		String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");
//		StringBuffer tSQL = new StringBuffer();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//		tSQL.append(" SELECT                                                                                  	\n");
//		tSQL.append(" 	  HD.HOUSE_CODE                                                                         \n");
//		tSQL.append(" 	, HD.RFQ_NO                                                                             \n");
//		tSQL.append(" 	, HD.RFQ_COUNT                                                                          \n");
//		tSQL.append(" 	, HD.SUBJECT                                                                            \n");
//		tSQL.append(" 	, HD.BID_RFQ_TYPE                                                                       \n");
//		tSQL.append(" 	, HD.BID_REQ_TYPE                                                                       \n");
//		tSQL.append(" 	, HD.START_DATE   AS RFQ_DATE                                                           \n");
//		tSQL.append(" 	, HD.START_TIME   AS RFQ_TIME                                                           \n");
//		tSQL.append(" 	, HD.ATTACH_NO                                                                          \n");
//		tSQL.append(" 	, (SELECT COUNT(*) FROM ICOMATCH WHERE DOC_NO = HD.ATTACH_NO) AS ATTACH_COUNT 			\n");
//		tSQL.append(" 	, HD.RFQ_CLOSE_DATE                                                                     \n");
//		tSQL.append(" 	, HD.RFQ_CLOSE_TIME                                                                     \n");
//		tSQL.append(" 	, HD.BID_TECHNIQUE_EVAL                                                                 \n");
//		tSQL.append(" 	, HD.BID_PRICE_EVAL                                                                     \n");
//		tSQL.append(" 	, HD.REMARK                                                                             \n");
//		tSQL.append(" 	, HD.RFQ_TYPE                                                                           \n");
//		tSQL.append(" 	, HD.SETTLE_TYPE                                                                        \n");
//		tSQL.append(" 	, HD.BID_TYPE                                                                           \n");
//		tSQL.append(" 	, HD.RFQ_FLAG                                                                           \n");
//		tSQL.append(" 	, HD.CTRL_CODE                                                                          \n");
//		tSQL.append("   , HD.BD_TYPE                                                                            \n");
//		tSQL.append("   , HD.CREATE_TYPE                                                                        \n");
//		tSQL.append("   , DT.Z_REMARK                                                                        	\n");
//		tSQL.append("   ,(SELECT COUNT(*)                                                                  		\n");
//		tSQL.append("    FROM   ICOYRQAN                                                                   		\n");
//		tSQL.append("    WHERE  HOUSE_CODE = HD.HOUSE_CODE                                                  	\n");
//		tSQL.append("    AND    RFQ_NO     = HD.RFQ_NO                                                      	\n");
//		tSQL.append("    AND    RFQ_COUNT  = HD.RFQ_COUNT                                                   	\n");
//		tSQL.append("    ) AS   RQAN_CNT                                                                   		\n");
//		tSQL.append("   ,(SELECT COUNT(*)                                                                  		\n");
//		tSQL.append("    FROM   ICOYTBEV                                                                   		\n");
//		tSQL.append("    WHERE  HOUSE_CODE = HD.HOUSE_CODE                                                  	\n");
//		tSQL.append("    AND    DOC_NO     = HD.RFQ_NO                                                      	\n");
//		tSQL.append("    AND    DOC_SEQ    = HD.RFQ_COUNT                                                   	\n");
//		tSQL.append("    ) AS   TBEV_CNT                                                                   		\n");
//		tSQL.append("    , dbo.Getusernameloc(HD.HOUSE_CODE, HD.ADD_USER_ID) AS ADD_USER_NAME                 	\n");
//		tSQL.append("    ,DT.VALID_FROM_DATE                 													\n");
//		tSQL.append("    ,DT.VALID_TO_DATE                 														\n");
//		tSQL.append(" FROM ICOYRQHD HD, ICOYRQDT DT             												\n");
//		tSQL.append(" <OPT=F,S> WHERE HD.HOUSE_CODE = ? </OPT>                                                	\n");
//		tSQL.append(" <OPT=F,S> AND HD.RFQ_NO =  ?      </OPT>                                                	\n");
//		tSQL.append(" <OPT=F,S> AND HD.RFQ_COUNT = ?    </OPT>                                                	\n");
//		tSQL.append(" AND HD.STATUS != 'D'                                                                    	\n");
//		tSQL.append(" AND DT.HOUSE_CODE = HD.HOUSE_CODE                                                       	\n");
//		tSQL.append(" AND DT.RFQ_NO = HD.RFQ_NO                                                               	\n");
//		tSQL.append(" AND DT.RFQ_COUNT = HD.RFQ_COUNT                                                         	\n");
//		tSQL.append(" AND DT.STATUS != 'D'                                                                    	\n");

		try	{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn	= sm.doSelect(args);
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

  	private	String et_getBidCountInfo(String[] args) throws Exception
  	{
  		String rtn = null;
  		ConnectionContext ctx =	getConnectionContext();


  		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//  		StringBuffer tSQL = new StringBuffer();

//  		tSQL.append(" SELECT   MAX(RFQ_COUNT)+1                                          \n");
//  		tSQL.append(" FROM ICOYRQHD                                                      \n");
//  		tSQL.append(" <OPT=F,S> WHERE HOUSE_CODE = ? </OPT>                              \n");
//  		tSQL.append(" <OPT=F,S> AND RFQ_NO = ? </OPT>                                    \n");
//  		tSQL.append(" AND BID_TYPE = 'EX'                                                \n");
//  		tSQL.append(" AND STATUS != 'D'                                                  \n");


  		try	{
  			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

  			rtn	= sm.doSelect(args);
  		} catch(Exception e) {
  			Logger.err.println(info.getSession("ID"),this,e.getMessage());
  			throw new Exception(e.getMessage());
  		}
  		return rtn;
  	}

	private	String et_getBidVendorSelect(String[] args) throws Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();


		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer tSQL = new StringBuffer();

//		tSQL.append(" SELECT   VENDOR_CODE                                                     \n");
//		tSQL.append("        , dbo.getCompanyNameLoc(HOUSE_CODE, VENDOR_CODE, 'S') AS VENDOR_NAME  \n");
//		tSQL.append("        , '' AS PERSON                                                    \n");
//		tSQL.append(" FROM ICOYRQSE                                                            \n");
//		tSQL.append(" <OPT=F,S> WHERE HOUSE_CODE = ? </OPT>                                    \n");
//		tSQL.append(" <OPT=F,S> AND RFQ_NO = ? </OPT>                                          \n");
//		tSQL.append(" <OPT=F,S> AND RFQ_COUNT = ? </OPT>                                       \n");
//		tSQL.append(" AND RFQ_SEQ = dbo.getMinRFQ_SEQ(HOUSE_CODE, RFQ_NO, RFQ_COUNT)               \n");
//		tSQL.append(" AND STATUS != 'D'                                                        \n");

		try	{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn	= sm.doSelect(args);
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
//
	public SepoaOut getBidDTDisplayChange(String[] args)
	{
		String lang = info.getSession("LANGUAGE");
		try	{
			String rtn	= et_getBidDTDisplayChange(args);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.get("STDRFQ.0000"));
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDRFQ.0001"));
		}
		return getSepoaOut();
	}

	private	String et_getBidDTDisplayChange(String[] args) throws Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
		String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");


		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer tSQL = new StringBuffer();

//		tSQL.append(" SELECT                                        												\n");
//		tSQL.append("  	DT.RFQ_SEQ                                   												\n");
//		tSQL.append(" 	, DT.ITEM_NO                                  												\n");
//		tSQL.append(" 	, PD.DESCRIPTION_LOC 																		\n");
//		tSQL.append(" 	, DT.SPECIFICATION 																			\n");
//		tSQL.append(" 	, DT.MAKER_NAME 																			\n");
//		tSQL.append(" 	, ''MAKER_CODE 																				\n");
//		tSQL.append(" 	, DT.UNIT_MEASURE                             												\n");
//		tSQL.append(" 	, DT.PURCHASE_PRE_PRICE AS UNIT_PRICE         												\n");
//		tSQL.append(" 	, DT.RFQ_QTY                                  												\n");
//		tSQL.append(" 	, DT.RFQ_AMT                                  												\n");
//		tSQL.append(" 	, DT.CUR                                      												\n");
//		tSQL.append(" 	, DT.PR_NO                                    												\n");
//		tSQL.append(" 	, DT.PR_SEQ                                   												\n");
//		tSQL.append(" 	, DT.Z_REMARK                                   											\n");
//		tSQL.append(" 	, DT.ATTACH_NO                                												\n");
//		tSQL.append(" 	, (SELECT COUNT(*) FROM ICOMATCH   WHERE DOC_NO = DT.ATTACH_NO)	AS ATTACH_COUNT				\n");
//		tSQL.append("   , dbo.GETSELRQSE(DT.HOUSE_CODE, DT.RFQ_NO, DT.RFQ_COUNT, DT.RFQ_SEQ) AS VENDOR_SELECTED_REASON 	\n");
//		tSQL.append("   , (CASE                                            										    \n");
//		tSQL.append(" 		HD.RFQ_NO                                       										\n");
//		tSQL.append(" 		WHEN 'OP' THEN ''                              											\n");
//		tSQL.append(" 		ELSE                                           											\n");
//		tSQL.append(" 			(SELECT COUNT(*) FROM ICOYRQSE    											\n");
//		tSQL.append(" 			 WHERE HOUSE_CODE = DT.HOUSE_CODE          											\n");
//		tSQL.append(" 			 AND   RFQ_NO	  = DT.RFQ_NO              											\n");
//		tSQL.append(" 			 AND   RFQ_COUNT  = DT.RFQ_COUNT           											\n");
//		tSQL.append(" 			 AND   RFQ_SEQ	  = DT.RFQ_SEQ)            										 	\n");
//		tSQL.append("      END                                             										    \n");
//		tSQL.append("      ) AS VENDOR_CNT                                 										    \n");
//		tSQL.append(" 	, PD.REC_VENDOR_NAME                                										\n");
//		tSQL.append(" 	, DT.PLANT_CODE                                            									\n");
//		tSQL.append("   , DT.DELY_TO_LOCATION                                     									\n");
//		tSQL.append("   , (SELECT PURCHASE_LOCATION FROM ICOYPRDT              										\n");
//		tSQL.append("   		 WHERE  HOUSE_CODE = DT.HOUSE_CODE                      							\n");
//		tSQL.append("   		 AND    PR_NO      = DT.PR_NO                           							\n");
//		tSQL.append("   		 AND    PR_SEQ     = DT.PR_SEQ) AS PURCHASE_LOCATION    							\n");
//		tSQL.append("   , HD.CTRL_CODE                                          									\n");
//		tSQL.append("   , DT.DELY_TO_ADDRESS                                      									\n");
//		tSQL.append("   ,(CASE                                                 										\n");
//		tSQL.append("     	 		 WHEN DT.STR_FLAG = 'S' THEN dbo.GETSTORAGENAME(DT.HOUSE_CODE, DT.COMPANY_CODE, DT.PLANT_CODE, DT.DELY_TO_LOCATION, 'LOC' ) \n");
//		tSQL.append("     	 		 WHEN DT.STR_FLAG = 'D' THEN dbo.GETDEPTNAME(DT.HOUSE_CODE, DT.COMPANY_CODE, DT.DELY_TO_LOCATION, 'LOC' ) \n");
//		tSQL.append("     	 		 ELSE DT.DELY_TO_LOCATION                       								\n");
//		tSQL.append("	      END                                                  									\n");
//		tSQL.append(" 	  ) AS DELY_TO_LOCATION_NAME                           										\n");
//		tSQL.append(" 	, DT.TECHNIQUE_GRADE                                        									\n");
//		tSQL.append(" 	, DT.TECHNIQUE_TYPE                                         									\n");
//		tSQL.append(" 	, DT.INPUT_FROM_DATE                                        									\n");
//		tSQL.append(" 	, DT.INPUT_TO_DATE                                          									\n");
//		tSQL.append(" 	, (SELECT COUNT(*)  FROM   ICOYRQAN																					\n");
//		tSQL.append(" 		WHERE  HOUSE_CODE = DT.HOUSE_CODE  AND RFQ_NO = DT.RFQ_NO  AND RFQ_COUNT  = DT.RFQ_COUNT  ) AS EXPL_SELECTED	\n");
//		tSQL.append(" 	, (SELECT COUNT(*) FROM ICOYTBEV                 												\n");
//		tSQL.append(" 		WHERE HOUSE_CODE = DT.HOUSE_CODE AND DOC_NO = DT.RFQ_NO AND DOC_SEQ = DT.RFQ_COUNT) AS EVAL_SELECTED			\n");
//		tSQL.append(" FROM ICOYRQDT DT, ICOYRQHD HD, ICOYPRDT PD    												\n");
//		tSQL.append(" <OPT=F,S> WHERE DT.HOUSE_CODE = ? </OPT>      												\n");
//		tSQL.append(" <OPT=F,S> AND DT.RFQ_NO = ?       </OPT>      												\n");
//		tSQL.append(" <OPT=F,S> AND DT.RFQ_COUNT = ?    </OPT>      												\n");
//		tSQL.append(" AND PD.HOUSE_CODE = DT.HOUSE_CODE             												\n");
//		tSQL.append(" AND PD.PR_NO = DT.PR_NO                       												\n");
//		tSQL.append(" AND PD.PR_SEQ = DT.PR_SEQ                     												\n");
//		tSQL.append(" AND PD.STATUS IN ('C','R')                    												\n");
//		tSQL.append(" AND DT.STATUS != 'D'                          												\n");
//		tSQL.append(" AND HD.RFQ_NO = DT.RFQ_NO                     												\n");
//		tSQL.append(" AND HD.RFQ_COUNT = DT.RFQ_COUNT               												\n");
//		tSQL.append(" AND HD.STATUS != 'D'                          												\n");

		try	{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn	= sm.doSelect(args);
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
//
	/*
    public SepoaOut setReqBidCreate(
    		String[][] data_hd,
    		String[][] data_dt,
    		String[][] args_prbr,
    		String pr_no,
    		String sign_status,
    		String cur,
    		String pr_tot_amt,
    		String approval_str,String pre_pjt_code)
    {
    	String add_user_id     =  info.getSession("ID");
        String house_code      =  info.getSession("HOUSE_CODE");
        String company         =  info.getSession("COMPANY_CODE");
        String add_user_dept   =  info.getSession("DEPARTMENT");
        String dept_name       =  info.getSession("DEPARTMENT_NAME_LOC");
        String name_eng        =  info.getSession("NAME_ENG");
        String name_loc        =  info.getSession("NAME_LOC");
        String lang            =  info.getSession("LANGUAGE");

    	//2010.12.08 swlee modify
    	String req_type = data_hd[0][25];
    	Logger.debug.println(this, "###################################### req_type ::"+ req_type);
    	String strDocFlag = "";
		if("P".equals(req_type)){
			strDocFlag = "PR";
		}else if("B".equals(strDocFlag)){
			strDocFlag = "BR";
		}
        try
        {
            int hd_rtn = et_setPrHDCreate(data_hd);
            if(hd_rtn<1)
            	throw new Exception(msg.get("STDPR.0003"));
            int dt_rtn = (data_dt);
            if(dt_rtn<1)
            	throw new Exception(msg.get("STDPR.0003"));
        
            if(!"".equals(pre_pjt_code) ){
	        	int prbr_rtn = et_setPrBrCreate(args_prbr);
	            if(prbr_rtn<1)
	            	throw new Exception(msg.get("STDPR.0003"));
            }
            msg.put("PR_NO",pr_no);
            setMessage(msg.get("STDPR.0015"));


            if(sign_status.equals("P"))
            {
                SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                //2010.12.08 swlee modify
                //sri.setDocType("BR");
                sri.setDocType(strDocFlag);
                sri.setDocNo(pr_no);
                sri.setDocSeq("0");
                sri.setDocName(data_hd[0][14]);
                sri.setItemCount(data_dt.length);
                sri.setSignStatus(sign_status);
                sri.setCur(cur);
                sri.setTotalAmt(Double.parseDouble(pr_tot_amt));

                sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
                int rtn = CreateApproval(info,sri);    //밑에 함수 실행
                if(rtn == 0)
                {
                    try
                    {
                        Rollback();
                    }
                    catch(Exception d)
                    {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.get("STDPR.0030"));
                    return getSepoaOut();
                }

                msg.put("PR_NO",pr_no);
                setMessage("요청번호 "+pr_no+"번으로 전송되었습니다.");
            }

            setStatus(1);
            setValue(pr_no);
            msg.put("PR_NO",pr_no);

            //2010.12.08 swlee modify
            String strMsgTemp = "";
            if("P".equals(req_type)){
            	strMsgTemp = "구매요청번호";
            }else{
            	strMsgTemp = "사전지원요청번호";
            }

            if("T".equals(sign_status)){
            	setMessage(strMsgTemp + " "+pr_no+"번으로 저장 되었습니다.");
            }else if("E".equals(sign_status)){
            	setMessage(strMsgTemp + " "+pr_no+"번으로 요청 되었습니다.");
            }

            Commit();
        }
        catch(Exception e)
        {
            try
            {
                Rollback();
            }
            catch(Exception d)
            {
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            Logger.err.println(info.getSession("ID"),this,"XXXXXXXXXXXXXXXXX"+e.getMessage());
            setStatus(0);
            setMessage(msg.get("STDPR.0003"));
        }

        return getSepoaOut();
    }//End of setPrCreate()
    */
	
	
	private List<Map<String, String>> getPrbrList(String prNo, String pre_pjt_code) throws Exception{
		List<Map<String, String>> result     = new ArrayList<Map<String, String>>();
		SepoaStringTokenizer      st_row     = new SepoaStringTokenizer(pre_pjt_code, ":", false);
        String[]                  m_rowData  = new String[st_row.countTokens()];
        Map<String, String>       resultInfo = null;
        int                       row        = 0;
   
        while(st_row.hasMoreElements()) {
            m_rowData[row] = st_row.nextToken().trim();
            
            row++;
        }
        
        for (int i = 0; i < m_rowData.length; i++) {
        	resultInfo = new HashMap<String, String>();
        	
        	resultInfo.put("HOUSE_CODE", info.getSession("HOUSE_CODE"));
        	resultInfo.put("PR_NO",      prNo);
        	resultInfo.put("BR_NO",      m_rowData[i]);
        	resultInfo.put("STATUS",     "C");
        	
        	result.add(resultInfo);
        }
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut setReqBidCreate(Map<String, Object> param) throws Exception{
		String                    add_user_id       =  info.getSession("ID");
        String                    house_code        =  info.getSession("HOUSE_CODE");
        String                    company           =  info.getSession("COMPANY_CODE");
        String                    add_user_dept     =  info.getSession("DEPARTMENT");
        String                    req_type          = null;
        String                    strDocFlag        = "";
        String                    pre_pjt_code      = null;
        String                    prNo              = null;
        String                    sign_status       = null;
        String                    subject           = null;
        String                    pr_tot_amt        = null;
        String                    approval_str      = null;
        String                    strMsgTemp        = null;
        Map<String, String>       header            = MapUtils.getMap(param, "headerData"); // 조회 조건 조회
        Map<String, String>       prHdCreateParam   = null;
        Map<String, String>       prDtCreateParam   = null;
        Map<String, String>       gridInfo          = null;
        List<Map<String, String>> grid              = (List<Map<String, String>>)MapUtils.getObject(param, "gridData");
        List<Map<String, String>> prBrParamList     = null;
        int                       hd_rtn            = 0;
        int                       dt_rtn            = 0;
        int                       gridSize          = grid.size();
        int                       i                 = 0;
        int                       prbr_rtn          = 0;
        int                       prBrParamListSize = 0;

//       this.sysoutMapInfo(header, "header");
//		
//		for(Map<String, String> gridInfo : grid){
//			this.sysoutMapInfo(gridInfo, "gridInfo");
//		}
		
    	req_type     = header.get("pr_gubun");
    	prNo         = header.get("prNo");
    	sign_status  = header.get("sign_status");
    	subject      = header.get("subject");
    	pr_tot_amt   = header.get("pr_tot_amt");
    	approval_str = header.get("approval_str");
    	
		if("P".equals(req_type)){
			strDocFlag = "PR";
		}
		else if("B".equals(strDocFlag)){
			strDocFlag = "BR";
		}
		
        try{
        	prHdCreateParam = this.prHdCreateParam(header);
            hd_rtn          = this.et_setPrHDCreate(prHdCreateParam);
            
            if(hd_rtn < 1){
            	throw new Exception(msg.get("STDPR.0003"));
            }
            
            for(i = 0; i < gridSize; i++){
            	gridInfo        = grid.get(i);
            	prDtCreateParam = this.prDtCreateParam(header, gridInfo);
                dt_rtn          = this.et_setPrDTCreate(prDtCreateParam);
                
                if(dt_rtn < 1){
                	throw new Exception(msg.get("STDPR.0003"));
                }
            }
            
            pre_pjt_code = header.get("pre_pjt_code");
          
            if("".equals(pre_pjt_code) == false ){
            	prBrParamList     = this.getPrbrList(prNo, pre_pjt_code);
            	prBrParamListSize = prBrParamList.size();
            	
            	for(i = 0; i < prBrParamListSize; i++){
            		prbr_rtn = this.et_setPrBrCreate(prBrParamList.get(i));
            		
            		if(prbr_rtn<1){
    	            	throw new Exception(msg.get("STDPR.0003"));
    	            }
            	}
            }
            
            msg.put("PR_NO",prNo);
            setMessage(msg.get("STDPR.0015"));


            if(sign_status.equals("P")){
                SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType(strDocFlag);
                sri.setDocNo(prNo);
                sri.setDocSeq("0");
                sri.setDocName(subject);
                sri.setItemCount(gridSize);
                sri.setSignStatus(sign_status);
                sri.setCur(grid.get(0).get("CUR"));
                sri.setTotalAmt(Double.parseDouble(pr_tot_amt));

                sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
                int rtn = CreateApproval(info,sri);    //밑에 함수 실행
                if(rtn == 0)
                {
                    try
                    {
                        Rollback();
                    }
                    catch(Exception d)
                    {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.get("STDPR.0030"));
                    return getSepoaOut();
                }

                msg.put("PR_NO", prNo);
                setMessage("요청번호 " + prNo + "번으로 전송되었습니다.");
            }

            setStatus(1);
            setValue(prNo);
            msg.put("PR_NO", prNo);

            if("P".equals(req_type)){
            	strMsgTemp = "구매요청번호";
            }
            else{
            	strMsgTemp = "사전지원요청번호";
            }

            if("T".equals(sign_status)){
            	setMessage(strMsgTemp + " "+prNo+"번으로 저장 되었습니다.");
            }
            else if("E".equals(sign_status)){
            	setMessage(strMsgTemp + " "+prNo+"번으로 요청 되었습니다.");	
            }

            Commit();
        }
        catch(Exception e){
            try{
                Rollback();
            }
            catch(Exception d){
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            
            Logger.err.println(info.getSession("ID"),this,"XXXXXXXXXXXXXXXXX"+e.getMessage());
            setStatus(0);
            setMessage(msg.get("STDPR.0003"));
        }

        return getSepoaOut();
	}
	
	private int deleteSprcartInfo(Map<String, String> param) throws Exception{
		ConnectionContext ctx = getConnectionContext();
    	SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "deleteSprcartInfo");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                            
            rtn = ssm.doInsert(param);
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut setUserCart(Map<String, Object> param) throws Exception{
		
		String                    add_user_id       =  info.getSession("ID");
        String                    house_code        =  info.getSession("HOUSE_CODE");
        String                    company           =  info.getSession("COMPANY_CODE");
        String                    add_user_dept     =  info.getSession("DEPARTMENT");
        String                    req_type          = null;
        String                    strDocFlag        = "";
        String                    pre_pjt_code      = null;
        String                    prNo              = null;
        String                    sign_status       = null;
        String                    subject           = null;
        String                    pr_tot_amt        = null;
        String                    approval_str      = null;
        String                    strMsgTemp        = null;
        Map<String, String>       header            = MapUtils.getMap(param, "headerData"); // 조회 조건 조회
        Map<String, String>       prHdCreateParam   = null;
        Map<String, String>       prDtCreateParam   = null;
        Map<String, String>       gridInfo          = null;
        List<Map<String, String>> grid              = (List<Map<String, String>>)MapUtils.getObject(param, "gridData");
        List<Map<String, String>> prBrParamList     = null;
        int                       hd_rtn            = 0;
        int                       dt_rtn            = 0;
        int                       gridSize          = grid.size();
        int                       i                 = 0;
        int                       prbr_rtn          = 0;
        int                       prBrParamListSize = 0;

    	req_type     = header.get("pr_gubun");
    	prNo         = header.get("prNo");
    	sign_status  = header.get("sign_status");
    	subject      = header.get("subject");
    	pr_tot_amt   = header.get("pr_tot_amt");
    	approval_str = header.get("approval_str");
    	
		if("P".equals(req_type)){
			strDocFlag = "PR";
		}
		else if("B".equals(strDocFlag)){
			strDocFlag = "BR";
		}
		
        try{
        	prHdCreateParam = this.prHdCreateParam(header);
            hd_rtn          = this.et_setPrHDCreate(prHdCreateParam);
            
            if(hd_rtn < 1){
            	throw new Exception(msg.get("STDPR.0003"));
            }
            
            for(i = 0; i < gridSize; i++){
            	gridInfo        = grid.get(i);
            	prDtCreateParam = this.prDtCreateParam(header, gridInfo);
                dt_rtn          = this.et_setPrDTCreate(prDtCreateParam);
                
                if(dt_rtn < 1){
                	throw new Exception(msg.get("STDPR.0003"));
                }

                dt_rtn = this.deleteSprcartInfo(gridInfo);
                
                if(dt_rtn < 1){
                	throw new Exception(msg.get("STDPR.0003"));
                }
            }
            
            pre_pjt_code = header.get("pre_pjt_code");
          
            if("".equals(pre_pjt_code) == false ){
            	prBrParamList     = this.getPrbrList(prNo, pre_pjt_code);
            	prBrParamListSize = prBrParamList.size();
            	
            	for(i = 0; i < prBrParamListSize; i++){
            		prbr_rtn = this.et_setPrBrCreate(prBrParamList.get(i));
            		
            		if(prbr_rtn<1){
    	            	throw new Exception(msg.get("STDPR.0003"));
    	            }
            	}
            }
            
            msg.put("PR_NO",prNo);
            setMessage(msg.get("STDPR.0015"));

            if(sign_status.equals("P")){
                SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType(strDocFlag);
                sri.setDocNo(prNo);
                sri.setDocSeq("0");
                sri.setDocName(subject);
                sri.setItemCount(gridSize);
                sri.setSignStatus(sign_status);
                sri.setCur(grid.get(0).get("CUR"));
                sri.setTotalAmt(Double.parseDouble(pr_tot_amt));

                sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
                sri.setSignRemark(java.net.URLDecoder.decode(sri.getSignRemark(),"UTF-8"));
                
                int rtn = CreateApproval(info,sri);    //밑에 함수 실행
                if(rtn == 0)
                {
                    try
                    {
                        Rollback();
                    }
                    catch(Exception d)
                    {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.get("STDPR.0030"));
                    return getSepoaOut();
                }

                msg.put("PR_NO", prNo);
                setMessage("요청번호 " + prNo + "번으로 전송되었습니다.");
            }

            setStatus(1);
            setValue(prNo);
            msg.put("PR_NO", prNo);

            if("P".equals(req_type)){
            	strMsgTemp = "구매요청번호";
            }
            else{
            	strMsgTemp = "사전지원요청번호";
            }

            if("T".equals(sign_status)){
            	setMessage(strMsgTemp + " "+prNo+"번으로 저장 되었습니다.");
            }
            else if("E".equals(sign_status)){
            	setMessage(strMsgTemp + " "+prNo+"번으로 요청 되었습니다.");
            }

            Commit();
        }
        catch(Exception e){
        	
        	
        	
            try{
                Rollback();
            }
            catch(Exception d){
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
                
            }
//            e.printStackTrace();
            Logger.err.println(info.getSession("ID"),this,"XXXXXXXXXXXXXXXXX"+e.getMessage());
            setStatus(0);
            setMessage(msg.get("STDPR.0003"));
            setFlag(false);
        }

        return getSepoaOut();
	}
	
	//불출요청(2015.02.09 next1210)
	@SuppressWarnings("unchecked")
	public SepoaOut setUserCart_NonApp(Map<String, Object> param) throws Exception{
		
		ConnectionContext ctx = getConnectionContext();
		
		String                    house_code        =  info.getSession("HOUSE_CODE");
		String                    company           =  info.getSession("COMPANY_CODE");
		
		String io_number = null;
		Map<String, String>       header            = MapUtils.getMap(param, "headerData"); // 조회 조건 조회
		String user_id = header.get("user_id");
		String insert_date = header.get("insert_date");
		String insert_time = header.get("insert_time");
		String status = header.get("status");
		String dept_code = header.get("dept_code");
		String dept_name = header.get("dept_name");
		
		Map<String, String>       prIOCreateParam   = null;
		Map<String, String>       gridInfo          = null;
		List<Map<String, String>> grid              = (List<Map<String, String>>)MapUtils.getObject(param, "gridData");
		int                       io_rtn            = 0;
		int                       gridSize          = grid.size();
		int                       i                 = 0;
		
		try{
			
			//WebService 호출 준비
			int webservice_cnt = gridSize;
			String[] mode = new String[webservice_cnt];
			String[] bsDeptCd = new String[webservice_cnt];
			String[] bsNdseQt = new String[webservice_cnt];
			String[] mloBsmCd = new String[webservice_cnt];
			String[] requAmnt = new String[webservice_cnt];
			String requDate = "";
			String requIdnt = "";
			for(i = 0; i < gridSize; i++){
				gridInfo        = grid.get(i);
				String item_no = gridInfo.get("ITEM_NO");
				String req_i_qty = gridInfo.get("PR_QTY");
//				System.out.println("req_i_qty============"+i+"=========="+req_i_qty);
				//채번가져오기
				Map map = new HashMap();
				map.put("house_code"    , house_code); 
				map.put("item_no"		, item_no); 
				map.put("dept_code"		, dept_code);
				SepoaXmlParser sxp = new SepoaXmlParser(this, "getIoNumber");
				SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				SepoaFormater sf_io = new SepoaFormater(ssm.doSelect(map));
				
				io_number = "";
				if(sf_io.getRowCount() > 0) {
					io_number = sf_io.getValue("IO_NUMBER_NEW", 0);
				}
				
				header.put("io_number", io_number);
				
				prIOCreateParam = this.prIOCreateParam(header, gridInfo);
				io_rtn          = this.et_setPrIOCreate(prIOCreateParam);
				
				if(io_rtn < 1){
					throw new Exception(msg.get("STDPR.0003"));
				}
				
				io_rtn = this.deleteSprcartInfo(gridInfo);
				
//				int webservice_cnt = gridSize;
//				SepoaInfo info = null;
				

				
				//각 불출신청 건수마다 1차원 배열에 넣는다.
				mode[i] = "C";
				bsDeptCd[i] = dept_code;
				bsNdseQt[i] = io_number;
				mloBsmCd[i] = item_no;
				requAmnt[i] = req_i_qty;
			}
			setMessage(msg.get("STDPR.0015"));
			//신청일자와 신청자 사번을 넣는다.
			requDate = SepoaDate.getShortDateString();
			requIdnt = user_id;
			
//			System.out.println("========WebService Start======");
			String[] result = webServiceEps0029(info, mode, bsDeptCd, bsNdseQt, mloBsmCd, requAmnt, requDate, requIdnt);
			
//			System.out.println("result=============="+result.length);
			
//			for(int a = 0; a < result.length; a++) {
//				System.out.println("result======="+a+"======="+result[a]);
//			}
			
			if(!"200".equals(result[0])) {
				throw new Exception(result[1]);
			}
			
			
//			SepoaInfo info,     String[] mode,     String[] bsDeptCd, String[] bsNdseQt, String[] mloBsmCd,
//			String[]  requAmnt, String   requDate, String   requIdnt
//			webServiceEps0029()
			
			setStatus(1);
			setValue("Y");
			
			Commit();
		}
		catch(Exception e){
			
			try{
				Rollback();
			}
			catch(Exception d){
				Logger.err.println(info.getSession("ID"),this,d.getMessage());
				
			}
//			e.printStackTrace();
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(e.getMessage());
			setFlag(false);
		}
		
		return getSepoaOut();
	}
	
	/**
	 * et_setPrHDCreate 메소드를 수행하기 위한 파라미터 맵을 구성하여 반환하는 메소드
	 * 
	 * @param header
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> prHdCreateParam(Map<String, String> header) throws Exception{
		Map<String, String> result = new HashMap<String, String>();
		
		result.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
		result.put("PR_NO",               header.get("prNo"));
		result.put("STATUS",              header.get("prHeadStatus"));
		result.put("COMPANY_CODE",        info.getSession("COMPANY_CODE"));
		result.put("PLANT_CODE",          info.getSession("DEPARTMENT"));
		result.put("PR_TOT_AMT",          header.get("pr_tot_amt"));
		result.put("PR_TYPE",             header.get("pr_type"));
		result.put("DEMAND_DEPT",         header.get("demand_dept"));
		result.put("SIGN_STATUS",         header.get("sign_status"));
		result.put("SIGN_DATE",           header.get("sign_date"));
		result.put("SIGN_PERSON_ID",      header.get("sign_person_id"));
		result.put("SIGN_PERSON_NAME",    header.get("sign_person_name"));
		result.put("DEMAND_DEPT_NAME",    header.get("demand_dept_name"));
		result.put("REMARK",              header.get("REMARK"));
		result.put("SUBJECT",             header.get("subject"));
		result.put("PR_LOCATION",         info.getSession("LOCATION_CODE"));
		result.put("ORDER_NO",            header.get("order_no"));
		result.put("SALES_USER_DEPT",     header.get("sales_dept"));
		result.put("SALES_USER_ID",       header.get("sales_user_id"));
		result.put("CONTRACT_HOPE_DAY",   header.get("contract_hope_day"));
		result.put("CUST_CODE",           header.get("cust_code"));
		result.put("CUST_NAME",           header.get("cust_name"));
		result.put("EXPECT_AMT",          header.get("expect_amt"));
		result.put("SALES_TYPE",          header.get("sales_type"));
		result.put("ORDER_NAME",          header.get("order_name"));
		result.put("REQ_TYPE",            header.get("pr_gubun"));
		result.put("RETURN_HOPE_DAY",     header.get("return_hope_day"));
		result.put("ATTACH_NO",           header.get("attach_no"));
		result.put("HARD_MAINTANCE_TERM", header.get("hard_maintance_term"));
		result.put("SOFT_MAINTANCE_TERM", header.get("soft_maintance_term"));
		result.put("CREATE_TYPE",         header.get("create_type"));
		result.put("ADD_USER_ID",         header.get("add_user_id"));
		result.put("CHANGE_USER_ID",      header.get("add_user_id"));
		result.put("BSART",               header.get("bsart"));
		result.put("CUST_TYPE",           header.get("cust_type"));
		result.put("ADD_DATE",            header.get("add_date"));
		result.put("AHEAD_FLAG",          header.get("ahead_flag"));
		result.put("CONTRACT_FROM_DATE",  header.get("contract_from_date"));
		result.put("CONTRACT_TO_DATE",    header.get("contract_to_date"));
		result.put("SALES_AMT",           header.get("sales_amt"));
		result.put("PROJECT_PM",          header.get("project_pm"));
		result.put("ORDER_COUNT",         header.get("order_count"));
		result.put("WBS",                 header.get("pjt_seq"));
		result.put("WBS_NAME",            header.get("pjt_name"));
		result.put("DELY_TO_LOCATION",    header.get("dely_location"));
		result.put("DELY_TO_ADDRESS",     header.get("dely_to_address"));
		result.put("DELY_TO_USER",        header.get("dely_to_user"));
		result.put("DELY_TO_PHONE",       header.get("dely_to_phone"));
		result.put("PC_FLAG",             header.get("pc_flag"));
		result.put("PC_REASON",           header.get("pc_reason")); 	
		
		return result;
	}
	
	/**
	 * et_setPrHDCreate 메소드를 수행하기 위한 파라미터 맵을 구성하여 반환하는 메소드
	 * 
	 * @param header
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> prHdCreateParam_NonApp(Map<String, String> header) throws Exception{
		Map<String, String> result = new HashMap<String, String>();
		
		result.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
		result.put("PR_NO",               header.get("prNo"));
		result.put("STATUS",              header.get("prHeadStatus"));
		result.put("COMPANY_CODE",        info.getSession("COMPANY_CODE"));
		result.put("PLANT_CODE",          info.getSession("DEPARTMENT"));
		result.put("PR_TOT_AMT",          header.get("pr_tot_amt"));
		result.put("PR_TYPE",             header.get("pr_type"));
		result.put("DEMAND_DEPT",         header.get("demand_dept"));
		result.put("SIGN_STATUS",         header.get("sign_status"));
		result.put("SIGN_DATE",           header.get("sign_date"));
		result.put("SIGN_PERSON_ID",      header.get("sign_person_id"));
		result.put("SIGN_PERSON_NAME",    header.get("sign_person_name"));
		result.put("DEMAND_DEPT_NAME",    header.get("demand_dept_name"));
		result.put("REMARK",              header.get("REMARK"));
		result.put("SUBJECT",             header.get("subject"));
		result.put("PR_LOCATION",         info.getSession("LOCATION_CODE"));
		result.put("ORDER_NO",            header.get("order_no"));
		result.put("SALES_USER_DEPT",     header.get("sales_dept"));
		result.put("SALES_USER_ID",       header.get("sales_user_id"));
		result.put("CONTRACT_HOPE_DAY",   header.get("contract_hope_day"));
		result.put("CUST_CODE",           header.get("cust_code"));
		result.put("CUST_NAME",           header.get("cust_name"));
		result.put("EXPECT_AMT",          header.get("expect_amt"));
		result.put("SALES_TYPE",          header.get("sales_type"));
		result.put("ORDER_NAME",          header.get("order_name"));
		result.put("REQ_TYPE",            header.get("pr_gubun"));
		result.put("RETURN_HOPE_DAY",     header.get("return_hope_day"));
		result.put("ATTACH_NO",           header.get("attach_no"));
		result.put("HARD_MAINTANCE_TERM", header.get("hard_maintance_term"));
		result.put("SOFT_MAINTANCE_TERM", header.get("soft_maintance_term"));
		result.put("CREATE_TYPE",         header.get("create_type"));
		result.put("ADD_USER_ID",         header.get("add_user_id"));
		result.put("CHANGE_USER_ID",      header.get("add_user_id"));
		result.put("BSART",               header.get("bsart"));
		result.put("CUST_TYPE",           header.get("cust_type"));
		result.put("ADD_DATE",            header.get("add_date"));
		result.put("AHEAD_FLAG",          header.get("ahead_flag"));
		result.put("CONTRACT_FROM_DATE",  header.get("contract_from_date"));
		result.put("CONTRACT_TO_DATE",    header.get("contract_to_date"));
		result.put("SALES_AMT",           header.get("sales_amt"));
		result.put("PROJECT_PM",          header.get("project_pm"));
		result.put("ORDER_COUNT",         header.get("order_count"));
		result.put("WBS",                 header.get("pjt_seq"));
		result.put("WBS_NAME",            header.get("pjt_name"));
		result.put("DELY_TO_LOCATION",    header.get("dely_location"));
		result.put("DELY_TO_ADDRESS",     header.get("dely_to_address"));
		result.put("DELY_TO_USER",        header.get("dely_to_user"));
		result.put("DELY_TO_PHONE",       header.get("dely_to_phone"));
		result.put("PC_FLAG",             header.get("pc_flag"));
		result.put("PC_REASON",           header.get("pc_reason")); 	
		
		return result;
	}
	
	/**
	 * <pre>
	 * 
	 * param 구조
			$S{HOUSE_CODE},
			$S{PR_NO},
			$S{STATUS},
			$S{COMPANY_CODE},
			$S{PLANT_CODE},
			$N{PR_TOT_AMT},
			$S{PR_TYPE},
			$S{DEMAND_DEPT},
			$S{SIGN_STATUS},
			$S{SIGN_DATE},
			$S{SIGN_PERSON_ID},
			$S{SIGN_PERSON_NAME},
			$S{DEMAND_DEPT_NAME},
			$S{REMARK},
			$S{SUBJECT},
			$S{PR_LOCATION},
			$S{ORDER_NO},
			$S{SALES_USER_DEPT},
			$S{SALES_USER_ID},
			$S{CONTRACT_HOPE_DAY},
			$S{CUST_CODE},
			$S{CUST_NAME},
			$S{EXPECT_AMT},
			$S{SALES_TYPE},
			$S{ORDER_NAME},
			$S{REQ_TYPE},
			$S{RETURN_HOPE_DAY},
			$S{ATTACH_NO},
			$S{HARD_MAINTANCE_TERM},
			$S{SOFT_MAINTANCE_TERM},
			$S{CREATE_TYPE},
			$S{ADD_USER_ID},
			$S{CHANGE_USER_ID},
			$S{BSART},
			$S{CUST_TYPE},
			$S{ADD_DATE},
			$S{AHEAD_FLAG},
			$S{CONTRACT_FROM_DATE},
			$S{CONTRACT_TO_DATE},
			$S{SALES_AMT},
			$S{PROJECT_PM},
			$S{ORDER_COUNT},
			$S{WBS},
			$S{WBS_NAME},
			$S{DELY_TO_LOCATION},
			$S{DELY_TO_ADDRESS},
			$S{DELY_TO_USER},
			$S{DELY_TO_PHONE},
			$S{PC_FLAG},
			$S{PC_REASON} 	
	 * </pre>
	 * @param param
	 * @return int
	 * @throws Exception
	 */
	private int et_setPrHDCreate(Map<String, String> param) throws Exception{
    	ConnectionContext ctx = getConnectionContext();
    	SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "et_setPrHDCreate");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                            
            rtn = ssm.doInsert(param);
            
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
    }
	
	/**
	 * et_setPrDTCreate 메소드를 수행하기 위한 파라미터 맵을 구성하여 반환하는 메소드
	 * 
	 * @param head
	 * @return
	 * @throws Exception
	 */
	private Map<String, String> prDtCreateParam(Map<String, String> header, Map<String, String> gridInfo) throws Exception{
		Map<String, String> result = new HashMap<String, String>();
		String              rdDate = gridInfo.get("RD_DATE");
		
		rdDate = rdDate.replace("/", "");
		
		result.put("HOUSE_CODE",         info.getSession("HOUSE_CODE"));
		result.put("PR_NO",              header.get("prNo"));
		result.put("PR_SEQ",             gridInfo.get("PR_SEQ"));
		result.put("STATUS",             gridInfo.get("STATUS"));
		result.put("COMPANY_CODE",       info.getSession("COMPANY_CODE"));
		result.put("PLANT_CODE",         header.get("plan_code"));
		result.put("ITEM_NO",            gridInfo.get("ITEM_NO"));
		result.put("PR_PROCEEDING_FLAG", gridInfo.get("PR_PROCEEDING_FLAG"));
		result.put("CTRL_CODE",          gridInfo.get("CTRL_CODE"));
		result.put("UNIT_MEASURE",       gridInfo.get("UNIT_MEASURE"));
		result.put("PR_QTY",             gridInfo.get("PR_QTY"));
		result.put("CUR",                gridInfo.get("CUR"));
		result.put("UNIT_PRICE",         gridInfo.get("UNIT_PRICE"));
		result.put("PR_AMT",             gridInfo.get("PR_AMT"));
		result.put("RD_DATE",            rdDate);
		result.put("ATTACH_NO",          gridInfo.get("ATTACH_NO"));
		result.put("REC_VENDOR_CODE",    gridInfo.get("REC_VENDOR_CODE"));
		result.put("DELY_TO_LOCATION",   header.get("dely_to_location"));
		result.put("REC_VENDOR_NAME",    gridInfo.get("REC_VENDOR_NAME"));
		result.put("DESCRIPTION_LOC",    gridInfo.get("DESCRIPTION_LOC"));
		result.put("SPECIFICATION",      gridInfo.get("SPECIFICATION"));
		result.put("MAKER_NAME",         gridInfo.get("MAKER_NAME"));
		result.put("MAKER_CODE",         gridInfo.get("MAKER_CODE"));
		result.put("REMARK",             gridInfo.get("REMARK"));
		result.put("PURCHASE_LOCATION",  gridInfo.get("PURCHASE_LOCATION"));
		result.put("PURCHASER_ID",       gridInfo.get("PURCHASER_ID"));
		result.put("PURCHASER_NAME",     gridInfo.get("PURCHASER_NAME"));
		result.put("PURCHASE_DEPT",      gridInfo.get("PURCHASE_DEPT"));
		result.put("PURCHASE_DEPT_NAME", gridInfo.get("PURCHASE_DEPT_NAME"));
		result.put("TECHNIQUE_GRADE",    gridInfo.get("TECHNIQUE_GRADE"));
		result.put("TECHNIQUE_TYPE",     gridInfo.get("TECHNIQUE_TYPE"));
		result.put("INPUT_FROM_DATE",    gridInfo.get("INPUT_FROM_DATE"));
		result.put("INPUT_TO_DATE",      gridInfo.get("INPUT_TO_DATE"));
		result.put("ADD_USER_ID",        header.get("add_user_id"));
		result.put("CHANGE_USER_ID",     header.get("add_user_id"));
		result.put("KNTTP",              header.get("knttp"));
		result.put("ZEXKN",              header.get("zexkn"));
		result.put("ORDER_NO",           header.get("order_no"));
		result.put("ORDER_SEQ",          gridInfo.get("ORDER_SEQ"));
		result.put("BS_NO",              gridInfo.get("WBS_NO"));
		result.put("WBS_SUB_NO",         gridInfo.get("WBS_SUB_NO"));
		result.put("WBS_TXT",            gridInfo.get("WBS_TXT"));
		result.put("CONTRACT_DIV",       gridInfo.get("CONTRACT_DIV"));
		result.put("DELY_TO_ADDRESS",    gridInfo.get("DELY_TO_ADDRESS"));
		result.put("WARRANTY",           gridInfo.get("WARRANTY"));
		result.put("EXCHANGE_RATE",      gridInfo.get("EXCHANGE_RATE"));
	    result.put("WBS_NAME",           gridInfo.get("WBS_NAME"));
	    result.put("ORDER_COUNT",        header.get("order_count"));
	    result.put("PRE_TYPE",           gridInfo.get("PRE_TYPE"));
	    result.put("PRE_PO_NO",          gridInfo.get("PRE_PO_NO")); 
	    result.put("PRE_PO_SEQ",         gridInfo.get("PRE_PO_SEQ"));
	    result.put("ACCOUNT_TYPE",       gridInfo.get("ACCOUNT_TYPE"));
	    result.put("ASSET_TYPE",         gridInfo.get("ASSET_TYPE"));
	    result.put("DELY_TO_ADDRESS_CD", gridInfo.get("DELY_TO_ADDRESS_CD"));
	    result.put("P_ITEM_NO",          gridInfo.get("P_ITEM_NO"));
	    result.put("ASSET_TYPE",         gridInfo.get("ASSET_TYPE"));
	    result.put("APP_DIV",            gridInfo.get("APP_DIV"));
	    result.put("KTEXT",              gridInfo.get("KTEXT"));
	    result.put("KAMT",               gridInfo.get("KAMT"));
	    result.put("DEMAND_DEPT",         header.get("demand_dept"));
	    
		return result;
	}
	
	/**
	 * prIOCreateParam 메소드를 수행하기 위한 파라미터 맵을 구성하여 반환하는 메소드
	 * 
	 * @param head
	 * @return
	 * @throws Exception
	 */
	private Map<String, String> prIOCreateParam(Map<String, String> header, Map<String, String> gridInfo) throws Exception{
		Map<String, String> result = new HashMap<String, String>();
		
//		String user_id = header.get("pr_gubun");
//		String insert_date = header.get("insert_date");
//		String insert_time = header.get("insert_time");
//		String status = header.get("status");
//		String dept_code = header.get("dept_code");
//		String dept_name = header.get("dept_name");
		
		result.put("HOUSE_CODE",        info.getSession("HOUSE_CODE"));
		result.put("DEPT_CODE",         header.get("dept_code"));
		result.put("IO_NUMBER",         header.get("io_number"));
		result.put("ITEM_NO",           gridInfo.get("ITEM_NO"));
		result.put("REQ_I_QTY",         gridInfo.get("PR_QTY"));
		result.put("REQ_I_DATE",        header.get("insert_date"));
		result.put("REQ_I_TIME",        header.get("insert_time"));
		result.put("REQ_I_USER_ID",		header.get("user_id"));
		result.put("REQ_O_QTY",         "0");
		result.put("REQ_O_DATE",        "");
		result.put("REQ_O_TIME",        "");
		result.put("REQ_O_USER_ID",     "");
		result.put("STATUS",      		header.get("status"));
		result.put("ADD_DATE",       	SepoaDate.getShortDateString());
		result.put("ADD_TIME",          SepoaDate.getShortTimeString());
		result.put("ADD_USER_ID",       info.getSession("ID"));
		result.put("CHANGE_DATE",    	SepoaDate.getShortDateString());
		result.put("CHANGE_TIME",       SepoaDate.getShortTimeString());
		result.put("CHANGE_USER_ID",    info.getSession("ID"));
		
		return result;
	}
	
	/**
	 * <pre>
			$S{HOUSE_CODE},
			$S{PR_NO},
			$S{PR_SEQ},
			$S{STATUS},
			$S{COMPANY_CODE},
			$S{PLANT_CODE},
			$S{ITEM_NO},
			$S{PR_PROCEEDING_FLAG},
			$S{CTRL_CODE},
			$S{UNIT_MEASURE},
			$N{PR_QTY},
			$S{CUR},
			$N{UNIT_PRICE},
			$N{PR_AMT},
			$N{RD_DATE},
			$S{ATTACH_NO},
			$S{REC_VENDOR_CODE},
			$S{DELY_TO_LOCATION},
			$S{REC_VENDOR_NAME},
			$S{DESCRIPTION_LOC},
			$S{SPECIFICATION},
			$S{MAKER_NAME},
			$S{MAKER_CODE},
			$S{REMARK},
			$S{PURCHASE_LOCATION},
			$S{PURCHASER_ID},
			$S{PURCHASER_NAME},
			$S{PURCHASE_DEPT},
			$S{PURCHASE_DEPT_NAME},
			$S{TECHNIQUE_GRADE},
			$S{TECHNIQUE_TYPE},
			$S{INPUT_FROM_DATE},
			$S{INPUT_TO_DATE},
			$S{ADD_USER_ID},
			$S{CHANGE_USER_ID},
			$S{KNTTP},
			$S{ZEXKN},
			$S{ORDER_NO},
			$S{ORDER_SEQ},
			${WBS_NO},
			$S{WBS_SUB_NO},
			$S{WBS_TXT},
			$S{CONTRACT_DIV},
			$S{DELY_TO_ADDRESS},
			$S{WARRANTY},
			$S{EXCHANGE_RATE},
		    $S{WBS_NAME},
		    $S{ORDER_COUNT},
		    $S{PRE_TYPE},
		    $S{PRE_PO_NO}, 
		    $S{PRE_PO_SEQ},
		    $S{ACCOUNT_TYPE},
		    $S{ASSET_TYPE},
		    ${session.DEPARTMENT},
		    ${P_ITEM_NO},
		    ${APP_DIV},
		    ${DEMAND_DEPT}
	 * </pre>
	 * @param param
	 * @return int
	 * @throws Exception
	 */
	private int et_setPrDTCreate(Map<String, String> param) throws Exception{
		ConnectionContext ctx = getConnectionContext();
    	SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "et_setPrDTCreate");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            
            rtn = ssm.doInsert(param);
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
    }
	
	private int et_setPrIOCreate(Map<String, String> param) throws Exception{
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		int               rtn = 0;
		
		try{
			sxp = new SepoaXmlParser(this, "et_setPrIOCreate");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			
			rtn = ssm.doInsert(param);
		}
		catch(Exception e){
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		
		return rtn;
	}
	
	/**
	 * <pre>
			  ${HOUSE_CODE},
			  ${PR_NO},
			  ${BR_NO},
			  ${STATUS},
		</pre>
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	private int et_setPrBrCreate(Map<String, String> param) throws Exception{
		ConnectionContext ctx = getConnectionContext();
    	SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "et_setPrBrCreate");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                            
            rtn = ssm.doInsert(param);
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
    }//End of et_setPrBrCreate()
	
    
//    public SepoaOut setReqBidCreate1(
//    		String[][] data_hd,
//    		String[][] data_dt,
//    		String pr_no,
//    		String sign_status,
//    		String cur,
//    		String pr_tot_amt,
//    		String approval_str)
//    {
//    	String add_user_id     =  info.getSession("ID");
//        String house_code      =  info.getSession("HOUSE_CODE");
//        String company         =  info.getSession("COMPANY_CODE");
//        String add_user_dept   =  info.getSession("DEPARTMENT");
//        String dept_name       =  info.getSession("DEPARTMENT_NAME_LOC");
//        String name_eng        =  info.getSession("NAME_ENG");
//        String name_loc        =  info.getSession("NAME_LOC");
//        String lang            =  info.getSession("LANGUAGE");
//
//    	//2010.12.08 swlee modify
//    	String req_type = data_hd[0][25];
//    	Logger.debug.println(this, "###################################### req_type ::"+ req_type);
//    	String strDocFlag = "";
//		if("P".equals(req_type)){
//			strDocFlag = "PR";
//		}else if("B".equals(strDocFlag)){
//			strDocFlag = "BR";
//		}
//        try
//        {
//            int hd_rtn = et_setPrHDCreate1(data_hd);
//            if(hd_rtn<1)
//            	throw new Exception(msg.get("STDPR.0003"));
//            int dt_rtn = et_setPrDTCreate1(data_dt);
//            if(dt_rtn<1)
//            	throw new Exception(msg.get("STDPR.0003"));
//            
//            msg.put("PR_NO",pr_no);
//            setMessage(msg.get("STDPR.0015"));
//
//
//            if(sign_status.equals("P"))
//            {
//                SignRequestInfo sri = new SignRequestInfo();
//                sri.setHouseCode(house_code);
//                sri.setCompanyCode(company);
//                sri.setDept(add_user_dept);
//                sri.setReqUserId(add_user_id);
//                //2010.12.08 swlee modify
//                //sri.setDocType("BR");
//                sri.setDocType(strDocFlag);
//                sri.setDocNo(pr_no);
//                sri.setDocSeq("0");
//                sri.setDocName(data_hd[0][14]);
//                sri.setItemCount(data_dt.length);
//                sri.setSignStatus(sign_status);
//                sri.setCur(cur);
//                sri.setTotalAmt(Double.parseDouble(pr_tot_amt));
//
//                sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
//                int rtn = CreateApproval(info,sri);    //밑에 함수 실행
//                if(rtn == 0)
//                {
//                    try
//                    {
//                        Rollback();
//                    }
//                    catch(Exception d)
//                    {
//                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
//                    }
//                    setStatus(0);
//                    setMessage(msg.get("STDPR.0030"));
//                    return getSepoaOut();
//                }
//
//                msg.put("PR_NO",pr_no);
//                setMessage("요청번호 "+pr_no+"번으로 전송되었습니다.");
//            }
//
//            setStatus(1);
//            setValue(pr_no);
//            msg.put("PR_NO",pr_no);
//
//            //2010.12.08 swlee modify
//            String strMsgTemp = "";
//            if("P".equals(req_type)){
//            	strMsgTemp = "구매요청번호";
//            }else{
//            	strMsgTemp = "사전지원요청번호";
//            }
//
//            if("T".equals(sign_status)){
//            	setMessage(strMsgTemp + " "+pr_no+"번으로 저장 되었습니다.");
//            }else if("E".equals(sign_status)){
//            	setMessage(strMsgTemp + " "+pr_no+"번으로 요청 되었습니다.");
//            }
//
//            Commit();
//        }
//        catch(Exception e)
//        {
//            try
//            {
//                Rollback();
//            }
//            catch(Exception d)
//            {
//                Logger.err.println(info.getSession("ID"),this,d.getMessage());
//            }
//            Logger.err.println(info.getSession("ID"),this,"XXXXXXXXXXXXXXXXX"+e.getMessage());
//            setStatus(0);
//            setMessage(msg.get("STDPR.0003"));
//        }
//
//        return getSepoaOut();
//    }//End of setPrCreate()
    
    @SuppressWarnings("unchecked")
	public SepoaOut setReqBidCreate1(Map<String, Object> param){
    	List<Map<String, String>> argsHd        = (List<Map<String, String>>)param.get("args_hd");
    	List<Map<String, String>> argsDt        = (List<Map<String, String>>)param.get("args_dt");
        Map<String, String>       argsHdInfo    = argsHd.get(0);
        Map<String, String>       argsDtInfo    = null;
        ConnectionContext         ctx           = null;
        SepoaXmlParser            sxp           = null;
		SepoaSQLManager           ssm           = null;
		String                    add_user_id   = info.getSession("ID");
        String                    house_code    = info.getSession("HOUSE_CODE");
        String                    company       = info.getSession("COMPANY_CODE");
        String                    add_user_dept = info.getSession("DEPARTMENT");
        String                    req_type      = argsHdInfo.get("REQ_TYPE");
    	String                    strDocFlag    = "";
    	String                    prNo          = (String)param.get("pr_no");
    	String                    signStatus    = (String)param.get("sign_status");
    	String                    cur           = (String)param.get("CUR");
    	String                    prTotAmt      = (String)param.get("pr_tot_amt");
    	String                    approvalStr   = (String)param.get("approval_str");
    	String                    strMsgTemp    = null;
    	int                       hd_rtn        = 0;
    	int                       argsDtSize    = argsDt.size();
    	int                       i             = 0;
    	int                       dt_rtn        = 0;
		
		setFlag(true);
		
		ctx = getConnectionContext();
    	
		if("P".equals(req_type)){
			strDocFlag = "PR";
		}
		else if("B".equals(req_type)){
			strDocFlag = "BR";
		}
		
        try{
        	sxp = new SepoaXmlParser(this, "et_setPrHDCreate1");
            ssm = new SepoaSQLManager(add_user_id, this, ctx, sxp);
        	
            hd_rtn = ssm.doInsert(argsHdInfo);
        	
            if(hd_rtn < 1){
            	throw new Exception(msg.get("STDPR.0003"));
            }
            
            for(i = 0; i < argsDtSize; i++){
            	sxp = new SepoaXmlParser(this, "et_setPrDTCreate1");
                ssm = new SepoaSQLManager(add_user_id, this, ctx, sxp);
                
                
            	
//                System.out.println("argsDtInfo========"+argsDtInfo.toString());
                dt_rtn = ssm.doInsert(argsDtInfo);
            	
                if(dt_rtn < 1){
                	throw new Exception(msg.get("STDPR.0003"));
                }
            }
            
            msg.put("PR_NO", prNo);
            setMessage(msg.get("STDPR.0015"));


            if(signStatus.equals("P")){
                SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                //2010.12.08 swlee modify
                //sri.setDocType("BR");
                sri.setDocType(strDocFlag);
                sri.setDocNo(prNo);
                sri.setDocSeq("0");
                sri.setDocName(argsHdInfo.get("SUBJECT")); 
                sri.setItemCount(argsDtSize);
                sri.setSignStatus(signStatus);
                sri.setCur(cur);
                sri.setTotalAmt(Double.parseDouble(prTotAmt));

                sri.setSignString(approvalStr); // AddParameter 에서 넘어온 정보
                
                int rtn = CreateApproval(info,sri);    //밑에 함수 실행
                
                if(rtn == 0){
                    try{
                        Rollback();
                    }
                    catch(Exception d){
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    
                    setStatus(0);
                    setMessage(msg.get("STDPR.0030"));
                    
                    return getSepoaOut();
                }

                msg.put("PR_NO", prNo);
                setMessage("요청번호 " + prNo + "번으로 전송되었습니다.");
            }

            setStatus(1);
            setValue(prNo);
            msg.put("PR_NO", prNo);

            if("P".equals(req_type)){
            	strMsgTemp = "구매요청번호";
            }
            else{
            	strMsgTemp = "사전지원요청번호";
            }

            if("T".equals(signStatus)){
            	setMessage(strMsgTemp + " "+prNo+"번으로 저장 되었습니다.");
            }else if("E".equals(signStatus)){
            	setMessage(strMsgTemp + " "+prNo+"번으로 요청 되었습니다.");
            }

            Commit();
        }
        catch(Exception e){
        	
        	
            try{
                Rollback();
            }
            catch(Exception d){
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            
            Logger.err.println(info.getSession("ID"),this,"XXXXXXXXXXXXXXXXX"+e.getMessage());
            
            setStatus(0);
            setMessage(msg.get("STDPR.0003"));
        }

        return getSepoaOut();
    }//End of setPrCreate()
    
    private int et_setPrHDCreate1( String[][] data_hd ) throws Exception
    {

    	int rtn = 0;

        ConnectionContext ctx = getConnectionContext();
        String add_user_id  = info.getSession("ID");

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(add_user_id,this,ctx, wxp.getQuery());
            String[] setType = {
            		"S","S","S","S","S",
            		"N","S","S","S",
            		"S","S","S",
            		"S",
                    "S","S","S","S","S",
                    "S","S","S","S","N",
                    "S","S","S","S","S",
                    "S","S","S","S","S",
                    "S","S","S"
                    , "S","S","S","S","S"
                    , "S","S","S"
                    , "S","S","S"
            };
            rtn = sm.doInsert(data_hd,setType);
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
    

    
    

    
    
    /*
     * 변경계약 구매요청시 ICOYPRHD생성.
     */
    private int et_setChPrHDCreate( String[][] data_hd ) throws Exception
    {

    	int rtn = 0;

        ConnectionContext ctx = getConnectionContext();
        String add_user_id  = info.getSession("ID");

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(add_user_id,this,ctx, wxp.getQuery());
            String[] setType = {
            		"S","S","S","S","S",
            		"N","S","S","S",
            		"S","S","S",
            		"S",
                    "S","S","S","S","S",
                    "S","S","S","S","N",
                    "S","S","S","S","S",
                    "S","S","S","S","S",
                    "S","S","S"
                    , "S","S","S","S","S"
                    , "S","S","S"
                    , "S","S","S","S","S","S"
                    , "S","S"
            };
            rtn = sm.doInsert(data_hd,setType);
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
    
    private int et_setPrDTCreate1(String[][] data_dt ) throws Exception
    {
        int rtn = 0;
        ConnectionContext ctx = getConnectionContext();

        String DBOwner      = CommonUtil.getConfig("Sepoa.generator.db.selfuser");
        String add_user_id  = info.getSession("ID");

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

        try
        {
        	String[] type = {"S","S","S","S","S","S","S","S","S","S",
                             "N","S","N","N","S","S","S","S","S","S",
                             "S","S","S","S","S","S","S","S","S","S",
                             "S","S","S","S","S","S","S","S","S","S",
                             "S","S","S","S","S","S","S"
                            };

            SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx, wxp.getQuery());
            rtn = sm.doInsert(data_dt,type);
        }
        catch(Exception e)
        {
        	Logger.debug.println(info.getSession("ID"),this, wxp.getQuery());
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }//End of et_setPrDTCreate()
    
    

	public SepoaOut getReqBidList(Map<String, String> header) {
		String lang = info.getSession("LANGUAGE");

		try	{

			String rtn = et_getReqBidList(header);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.get("STDRFQ.0000"));
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDRFQ.0001"));
		}
		return getSepoaOut();
	}

	private	String et_getReqBidList(Map<String, String> header ) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
		
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("pr_status", header.get("pr_status"));
		
		try	{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());
			header.put("house_code", info.getSession("HOUSE_CODE"));
			rtn	= sm.doSelect(header);
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
//	public SepoaOut PrBrDisplay(String[] args){
//        try{
//            String rtnHD = et_PrBrDisplay(args);
//            setStatus(1);
//            setValue(rtnHD);
//            setMessage(msg.get("STDCOMM.0000"));
//        }
//        catch(Exception e)
//        {
//            Logger.err.println(info.getSession("ID"),this,e.getMessage());
//            setStatus(0);
//
//            String lang            =  info.getSession("LANGUAGE");
//
//            setMessage(msg.get("p10_pra.0001"));
//        }
//        return getSepoaOut();
//    }

    private String et_PrBrDisplay(String[] args) throws Exception
    {

        String rtn = null;

        try
        {
            String user_id         =  info.getSession("ID");
            String house_code      =  info.getSession("HOUSE_CODE");
            String company_code    =  info.getSession("COMPANY_CODE");
            ConnectionContext ctx  = getConnectionContext();

            String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("company_code", company_code);

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this, ctx, wxp.getQuery());
            rtn = sm.doSelect(args);
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }//End of et_prQueryDisplayHD()
    
    public SepoaOut PrBrDisplay(Map<String, String> args){
    	ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		String            cur = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "et_PrBrDisplay");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			rtn = ssm.doSelect(args); // 조회
			
			setValue(rtn);
			setValue(cur);
			setMessage(msg.get("0000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("0001"));
		}
		
		return getSepoaOut();
    }

    public SepoaOut ReqBidHDQueryDisplay(String[] args)
    {
        try
        {
            String lang            =  info.getSession("LANGUAGE");

            String rtnHD = et_reqBidHDQueryDisplay(args);
            setStatus(1);
            setValue(rtnHD);
            setMessage(msg.get("STDCOMM.0000"));
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            setStatus(0);

            String lang            =  info.getSession("LANGUAGE");

            setMessage(msg.get("p10_pra.0001"));
        }
        return getSepoaOut();
    }//End of prHDQueryDisplay()

    private String et_reqBidHDQueryDisplay(String[] args) throws Exception
    {

        String rtn = null;

        try
        {
            String user_id         =  info.getSession("ID");
            String house_code      =  info.getSession("HOUSE_CODE");
            String company_code      =  info.getSession("COMPANY_CODE");
            ConnectionContext ctx = getConnectionContext();

            String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("company_code", company_code);
			wxp.addVar("house_code", house_code);

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this, ctx, wxp.getQuery());
            rtn = sm.doSelect(args);
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }//End of et_prQueryDisplayHD()
    

//    public SepoaOut ReqBidDTQueryDisplay_Change(String[] args)
//    {
//        try
//        {
//            String lang            =  info.getSession("LANGUAGE");
//
//            String rtnDT = et_reqBidDTQueryDisplay_Change(args);
//            setStatus(1);
//            setValue(rtnDT);
//            setMessage(msg.get("STDCOMM.0000"));
//        }
//        catch(Exception e)
//        {
//            Logger.err.println(info.getSession("ID"),this,e.getMessage());
//            setStatus(0);
//
//            String lang            =  info.getSession("LANGUAGE");
//
//            setMessage(msg.get("p10_pra.0001"));
//        }
//
//        return getSepoaOut();
//    }//End of prDTQueryDisplay_Change()
    
    public SepoaOut ReqBidDTQueryDisplay_Change(Map<String, String> args){
    	ConnectionContext   ctx         = null;
		SepoaXmlParser      sxp         = null;
		SepoaSQLManager     ssm         = null;
		String              rtn         = null;
		String              id          = info.getSession("ID");
		String              houseCode   = info.getSession("HOUSE_CODE");
        String              companyCode = info.getSession("COMPANY_CODE");
        String              prNo        = args.get("prNo");
        Map<String, String> sqlParam    = new HashMap<String, String>();
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "et_reqBidDTQueryDisplay_Change");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			sqlParam.put("HOUSE_CODE",   houseCode);
			sqlParam.put("COMPANY_CODE", companyCode);
			sqlParam.put("PR_NO",        prNo);
			
			rtn = ssm.doSelect(sqlParam); // 조회
			
			setValue(rtn);
			setMessage(msg.get("0000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("0001"));
		}
		
		return getSepoaOut();
    }//End of prDTQueryDisplay_Change()

    private String et_reqBidDTQueryDisplay_Change(String[] args) throws Exception
    {

        String rtn = null;
        String user_id         =  info.getSession("ID");
        String company_code    =  info.getSession("COMPANY_CODE");

        ConnectionContext ctx = getConnectionContext();

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("company_code", company_code);

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx, wxp.getQuery());
            rtn = sm.doSelect(args);
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }//End of et_prQueryDisplayDT_Change()


    public SepoaOut setReqBidChange(
    		String pr_no
    		, String[][] args_hd
    		, String[][] args_dt
    		, String sign_status
    		, String cur
    		, String pr_tot_amt
    		, String approval_str
    		, String doc_type         )
    {
    	String add_user_id     =  info.getSession("ID");
        String house_code      =  info.getSession("HOUSE_CODE");
        String company         =  info.getSession("COMPANY_CODE");
        String add_user_dept   =  info.getSession("DEPARTMENT");
        String lang            =  info.getSession("LANGUAGE");

        try
        {
            int hd_rtn   = et_setPrHDChange(args_hd);
            int dt_rtn   = et_deletePrdtAll(pr_no);
            
            Logger.debug.println(info.getSession("ID"), this, "doc_type==================>"+doc_type);
            
            if(doc_type.equals("PR")){
//            	dt_rtn       = et_setPrDTCreate(args_dt); //  변환 작업 중 임시 주석
            }else{
            	dt_rtn       = et_setPrDTCreate1(args_dt);
            }

            if(dt_rtn<1)
            	throw new Exception("NO DATA ICOYPRDT");

                Logger.debug.println(info.getSession("ID"), this, "doc_type==================>"+doc_type);
            if(sign_status.equals("P"))
            {
                SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType("PR");
                sri.setDocNo(pr_no);
                sri.setDocSeq("0");
                sri.setItemCount(args_dt.length);
                sri.setSignStatus(sign_status);
                sri.setDocName(args_hd[0][9]);
                sri.setCur(cur);
                sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
                sri.setTotalAmt(Double.parseDouble(pr_tot_amt));
                int rtn = CreateApproval(info,sri);    //밑에 함수 실행
                if(rtn == 0)
                {
                    try
                    {
                        Rollback();
                    }
                    catch(Exception d)
                    {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.get("STDPR.0030"));
                    return getSepoaOut();
                }
                setStatus(1);
            	msg.put("PR_NO",pr_no);
            	setMessage("요청번호 "+pr_no+"가 결재요청되었습니다.");
            }else{

                setStatus(1);
            	msg.put("PR_NO",pr_no);
            	if("T".equals(sign_status)){
                	setMessage("요청번호 "+pr_no+"번으로 저장 되었습니다.");
                }else if("E".equals(sign_status)){
                	setMessage("요청번호 "+pr_no+"번으로 요청 되었습니다.");
                }
            }
            Commit();
        }
        catch(Exception e)
        {
            try
            {
                Rollback();
            }
            catch(Exception d)
            {
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            setStatus(0);
            setMessage(msg.get("STDPR.0003"));
        }

        return getSepoaOut();
    }//End of setPrChange()

    /*
    public SepoaOut setReqBidChangePur(
    		String pr_no
    		, String[][] args_hd
    		, String[][] args_dt
    		, String[][] args_prbr
    		, String sign_status
    		, String cur
    		, String pr_tot_amt
    		, String approval_str
    		, String doc_type  
    		, String pre_pjt_code
    		, String pre_cont_seq)
    {
    	
    	String add_user_id     =  info.getSession("ID");
        String house_code      =  info.getSession("HOUSE_CODE");
        String company         =  info.getSession("COMPANY_CODE");
        String add_user_dept   =  info.getSession("DEPARTMENT");
        String lang            =  info.getSession("LANGUAGE");

        try
        {
            int hd_rtn   = et_setPrHDChangePur(args_hd);
           
            int dt_rtn   = et_deletePrdtAll(pr_no);
//            dt_rtn       = et_setPrDTCreate(args_dt); //  변환 작업 중 임시 주석
            
            if(!"".equals(pre_pjt_code) ){
            	  dt_rtn     = et_deletePrdtAllPrBr(pr_no);
	        	//int prbr_rtn = et_setPrBrCreate(args_prbr); // 변환 작업 중 임시 주석
//	            if(prbr_rtn<1)// 변환 작업 중 임시 주석
//	            	throw new Exception(msg.get("STDPR.0003"));// 변환 작업 중 임시 주석
            }

            if(dt_rtn<1)
            	throw new Exception("NO DATA ICOYPRDT");

                Logger.debug.println(info.getSession("ID"), this, "doc_type==================>"+doc_type);
            if(sign_status.equals("P"))
            {
                SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType("PR");
                sri.setDocNo(pr_no);
                sri.setDocSeq("0");
                sri.setItemCount(args_dt.length);
                sri.setSignStatus(sign_status);
                sri.setDocName(args_hd[0][9]);
                sri.setCur(cur);
                sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
                sri.setTotalAmt(Double.parseDouble(pr_tot_amt));
                int rtn = CreateApproval(info,sri);    //밑에 함수 실행
                if(rtn == 0)
                {
                    try
                    {
                        Rollback();
                    }
                    catch(Exception d)
                    {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.get("STDPR.0030"));
                    return getSepoaOut();
                }
                setStatus(1);
            	msg.put("PR_NO",pr_no);
            	setMessage("요청번호 "+pr_no+"가 결재요청되었습니다.");
            }else if(sign_status.equals("E") && !pre_cont_seq.equals("")){	//변경계약일 경우 견적자동완료 처리한 후 기안대기현황으로 이동합니다.
            	et_setRfqComplete(pr_no);
            	setStatus(1);
            }else{

                setStatus(1);
            	msg.put("PR_NO",pr_no);
            	if("T".equals(sign_status)){
                	setMessage("요청번호 "+pr_no+"번으로 저장 되었습니다.");
                }else if("E".equals(sign_status)){
                	setMessage("요청번호 "+pr_no+"번으로 요청 되었습니다.");
                }
            }
            Commit();
        }
        catch(Exception e)
        {
            try
            {
                Rollback();
            }
            catch(Exception d)
            {
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            setStatus(0);
            setMessage(msg.get("STDPR.0003"));
        }

        return getSepoaOut();
    }//End of setPrChange()
    */
    @SuppressWarnings({ "unchecked", "unused" })
	public SepoaOut setReqBidChangePur(Map<String, Object> data){
    	String                    add_user_id       = info.getSession("ID");
        String                    house_code        = info.getSession("HOUSE_CODE");
        String                    company           = info.getSession("COMPANY_CODE");
        String                    add_user_dept     = info.getSession("DEPARTMENT");
        String                    prNo              = null;
        String                    pre_pjt_code      = null;
        String                    sign_status       = null;
        String                    order_no          = null;
        String                    cur               = null;
        String                    approval_str      = null;
        String                    pr_tot_amt        = null;
        String                    pre_cont_seq      = null;
        Map<String, String>       header            = MapUtils.getMap(data, "headerData"); // 조회 조건 조회
        Map<String, String>       param             = new HashMap<String, String>();
        Map<String, String>       gridInfo          = null;
		List<Map<String, String>> grid              = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
		List<Map<String, String>> prBrParamList     = null;
		int                       hd_rtn            = 0;
		int                       dt_rtn            = 0;
		int                       gridSize          = grid.size();
		int                       i                 = 0;
		int                       prbr_rtn          = 0;
		int                       prBrParamListSize = 0;
		
//		prNo         = grid.get(0).get("PR_NO");
		prNo         = header.get("rfq_no");
		cur          = grid.get(0).get("CUR");
		pre_pjt_code = header.get("pre_pjt_code");
		sign_status  = header.get("sign_status");
		order_no     = header.get("order_no");
		approval_str = header.get("approval_str");
		pr_tot_amt   = header.get("pr_tot_amt");
		pre_cont_seq = header.get("pre_cont_seq");

        try{
        	param  = this.etSetPrHDChangePurParam(header, prNo);
            hd_rtn = et_setPrHDChangePur(param);
            dt_rtn = et_deletePrdtAll(prNo);
            
            for(i = 0; i < gridSize; i++){
            	gridInfo = grid.get(i);
            	param    = this.etSetPrDTCreateParam(header, gridInfo);
    		    dt_rtn   = et_setPrDTCreate(param);
            }
            
            if("".equals(pre_pjt_code) == false){
            	dt_rtn   = et_deletePrdtAllPrBr(prNo);
            	prBrParamList     = this.getPrbrList(prNo, pre_pjt_code);
            	prBrParamListSize = prBrParamList.size();
            	
            	for(i = 0; i < prBrParamListSize; i++){
            		prbr_rtn = this.et_setPrBrCreate(prBrParamList.get(i));
            		
            		if(prbr_rtn<1){
    	            	throw new Exception(msg.get("STDPR.0003"));
    	            }
            	}
            }

            if(dt_rtn < 1){
            	throw new Exception("NO DATA ICOYPRDT");
            }
            
            if(sign_status.equals("P")){
                SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType("PR");
                sri.setDocNo(prNo);
                sri.setDocSeq("0");
                sri.setItemCount(gridSize);
                sri.setSignStatus(sign_status);
                sri.setDocName(order_no);
                sri.setCur(cur);
                sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
                sri.setTotalAmt(Double.parseDouble(pr_tot_amt));
                int rtn = CreateApproval(info,sri);    //밑에 함수 실행
                if(rtn == 0)
                {
                    try
                    {
                        Rollback();
                    }
                    catch(Exception d)
                    {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.get("STDPR.0030"));
                    return getSepoaOut();
                }
                setStatus(1);
            	msg.put("PR_NO",prNo);
            	setMessage("요청번호 "+prNo+"가 결재요청되었습니다.");
            }else if(sign_status.equals("E") && !pre_cont_seq.equals("")){	//변경계약일 경우 견적자동완료 처리한 후 기안대기현황으로 이동합니다.
            	et_setRfqComplete(prNo);
            	setStatus(1);
            }else{

                setStatus(1);
            	msg.put("PR_NO",prNo);
            	if("T".equals(sign_status)){
                	setMessage("요청번호 "+prNo+"번으로 저장 되었습니다.");
                }else if("E".equals(sign_status)){
                	setMessage("요청번호 "+prNo+"번으로 요청 되었습니다.");
                }
            }
            Commit();
        }
        catch(Exception e){
        	
        	try
            {
                Rollback();
            }
            catch(Exception d)
            {
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            setStatus(0);
            setMessage(msg.get("STDPR.0003"));
        }

        return getSepoaOut();
    }//End of setPrChange()
    
    
    
    /**
	 * 빈 문자열 처리
	 * 
	 * @param str
	 * @return String
	 * @throws Exception
	 */
	private String nvl(String str) throws Exception{
		String result = null;
		
		result = this.nvl(str, "");
		
		return result;
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
	
    private Map<String, String> etSetPrHDChangePurParam(Map<String, String> header, String prNo) throws Exception{
    	Map<String, String> result      = new HashMap<String, String>();
    	String              add_user_id = info.getSession("ID");
        String              house_code  = info.getSession("HOUSE_CODE");
        String              company     = info.getSession("COMPANY_CODE");
        String              pcFlag      = header.get("pc_flag");
        
        pcFlag = this.nvl(pcFlag);
        
        if(pcFlag.equals("true")){
        	pcFlag = "Y";
        }
        else{
        	pcFlag = "N";
        }
    	
    	result.put("pr_tot_amt",        header.get("pr_tot_amt"));
    	result.put("demand_dept",       header.get("demand_dept"));
    	result.put("demand_dept_name",  header.get("demand_dept_name"));
    	result.put("sign_status",       header.get("sign_status"));
    	result.put("sign_date",         header.get("sign_date"));
    	result.put("sign_person_id",    header.get("sign_person_id"));
    	result.put("sign_person_name",  header.get("sign_person_name"));
    	result.put("sign_person_name",  header.get("sign_person_name"));
    	result.put("remark_hd",         header.get("REMARK"));
    	result.put("subject",           header.get("subject"));
    	result.put("order_no",          header.get("order_no"));
    	result.put("sales_dept",        header.get("sales_dept"));
    	result.put("sales_user_id",     header.get("sales_user_id"));
    	result.put("contract_hope_day", header.get("contract_hope_day"));
    	result.put("cust_code",         header.get("cust_code"));
    	result.put("cust_name",         header.get("cust_name"));
    	result.put("expect_amt",        header.get("expect_amt"));
    	result.put("sales_type",        header.get("sales_type"));
    	result.put("order_name",        header.get("order_name"));
    	result.put("attach_no",         header.get("attach_no"));
    	result.put("cust_type",         header.get("cust_type"));
    	result.put("add_date",          header.get("add_date"));
    	result.put("user_id",           add_user_id);
    	result.put("pjt_seq",           header.get("pjt_seq"));
    	result.put("pjt_name",          header.get("pjt_name"));
    	result.put("dely_location",     header.get("dely_location"));
    	result.put("dely_to_address",   header.get("dely_to_address"));
    	result.put("pc_flag",           pcFlag);
    	result.put("pc_reason",         header.get("pc_reason"));
    	result.put("house_code",        house_code);
    	result.put("company_code",      company);
    	result.put("strPR_NO",          prNo);
    	
    	return result;
    }
    
    private Map<String, String> etSetPrDTCreateParam(Map<String, String> header, Map<String, String> gridInfo) throws Exception{
    	Map<String, String> result = new HashMap<String, String>();
    	
        result.put("HOUSE_CODE",         gridInfo.get("HOUSE_CODE"));
		result.put("PR_NO",              header.get("rfq_no"));
		result.put("PR_SEQ",             gridInfo.get("PR_SEQ"));
		result.put("STATUS",             gridInfo.get("STATUS"));
		result.put("COMPANY_CODE",       gridInfo.get("COMPANY_CODE"));
		result.put("PLANT_CODE",         gridInfo.get("PLANT_CODE"));
		result.put("ITEM_NO",            gridInfo.get("ITEM_NO"));
		result.put("PR_PROCEEDING_FLAG", gridInfo.get("PR_PROCEEDING_FLAG"));
		result.put("CTRL_CODE",          this.nvl(gridInfo.get("CTRL_CODE"), "P01"));
		result.put("UNIT_MEASURE",       gridInfo.get("UNIT_MEASURE"));
		result.put("PR_QTY",             gridInfo.get("PR_QTY"));
		result.put("CUR",                gridInfo.get("CUR"));
		result.put("UNIT_PRICE",         gridInfo.get("UNIT_PRICE"));
		result.put("PR_AMT",             gridInfo.get("PR_AMT"));
		result.put("RD_DATE",            gridInfo.get("RD_DATE"));
		result.put("ATTACH_NO",          gridInfo.get("ATTACH_NO"));
		result.put("REC_VENDOR_CODE",    gridInfo.get("REC_VENDOR_CODE"));
		result.put("DELY_TO_LOCATION",   header.get("dely_to_location"));
		result.put("REC_VENDOR_NAME",    gridInfo.get("REC_VENDOR_NAME"));
		result.put("DESCRIPTION_LOC",    gridInfo.get("DESCRIPTION_LOC"));
		result.put("SPECIFICATION",      gridInfo.get("SPECIFICATION"));
		result.put("MAKER_NAME",         gridInfo.get("MAKER_NAME"));
		result.put("MAKER_CODE",         gridInfo.get("MAKER_CODE"));
		result.put("REMARK",             gridInfo.get("REMARK"));
		result.put("PURCHASE_LOCATION",  gridInfo.get("PURCHASE_LOCATION"));
		result.put("PURCHASER_ID",       gridInfo.get("PURCHASER_ID"));
		result.put("PURCHASER_NAME",     gridInfo.get("PURCHASER_NAME"));
		result.put("PURCHASE_DEPT",      gridInfo.get("PURCHASE_DEPT"));
		result.put("PURCHASE_DEPT_NAME", gridInfo.get("PURCHASE_DEPT_NAME"));
		result.put("TECHNIQUE_GRADE",    gridInfo.get("TECHNIQUE_GRADE"));
		result.put("TECHNIQUE_TYPE",     gridInfo.get("TECHNIQUE_TYPE"));
		result.put("INPUT_FROM_DATE",    gridInfo.get("INPUT_FROM_DATE"));
		result.put("INPUT_TO_DATE",      gridInfo.get("INPUT_TO_DATE"));
		result.put("ADD_USER_ID",        gridInfo.get("add_user_id"));
		result.put("CHANGE_USER_ID",     gridInfo.get("add_user_id"));
		result.put("KNTTP",              gridInfo.get("knttp"));
		result.put("ZEXKN",              gridInfo.get("zexkn"));
		result.put("ORDER_NO",           gridInfo.get("order_no"));
		result.put("ORDER_SEQ",          gridInfo.get("ORDER_SEQ"));
		result.put("WBS_NO",             gridInfo.get("WBS_NO"));
		result.put("WBS_SUB_NO",         gridInfo.get("WBS_SUB_NO"));
		result.put("WBS_TXT",            gridInfo.get("WBS_TXT"));
		result.put("CONTRACT_DIV",       gridInfo.get("CONTRACT_DIV"));
		result.put("DELY_TO_ADDRESS",    gridInfo.get("DELY_TO_ADDRESS"));
		result.put("WARRANTY",           gridInfo.get("WARRANTY"));
		result.put("EXCHANGE_RATE",      gridInfo.get("EXCHANGE_RATE"));
	    result.put("WBS_NAME",           gridInfo.get("WBS_TXT"));
	    result.put("ORDER_COUNT",        gridInfo.get("order_count"));
	    result.put("PRE_TYPE",           gridInfo.get("PRE_TYPE"));
	    result.put("PRE_PO_NO",          gridInfo.get("PRE_PO_NO")); 
	    result.put("PRE_PO_SEQ",         gridInfo.get("PRE_PO_SEQ"));
	    result.put("ACCOUNT_TYPE",       gridInfo.get("ACCOUNT_TYPE"));
	    result.put("ASSET_TYPE",         gridInfo.get("ASSET_TYPE"));
	    result.put("DELY_TO_ADDRESS_CD",  gridInfo.get("DELY_TO_ADDRESS_CD"));
	    result.put("P_ITEM_NO",  gridInfo.get("P_ITEM_NO"));
	    result.put("DEMAND_DEPT",  header.get("demand_dept"));
	    
    	return result;
    }
    
    
    
    /*
    private int et_setPrHDChangePur( String[][] args  ) throws Exception
    {
        int rtn = 0;
        ConnectionContext ctx = getConnectionContext();
        String user_id        =  info.getSession("ID");

        try
        {

        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("user_id", user_id);


            String[] setType = {
            		"N","S","S","S",
            		"S","S","S","S","S",
            		"S","S","S","S","S",
            		"S","N","S","S", 
            		"S","S","S",
            		"S","S","S","S",
            		"S","S","S","S","S"
            };
            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
            rtn = sm.doUpdate(args,setType);
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
    */
    private int et_setPrHDChangePur(Map<String, String> param) throws Exception{
    	ConnectionContext ctx = getConnectionContext();
    	SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "et_setPrHDChangePur");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                            
            rtn = ssm.doUpdate(param);
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
    }
    
    private int et_setPrHDChange( String[][] args  ) throws Exception
    {
        int rtn = 0;
        ConnectionContext ctx = getConnectionContext();
        String user_id        =  info.getSession("ID");

        try
        {

        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("user_id", user_id);


            String[] setType = {
            		"N","S","S","S","S",
            		"S","S","S",
            		"S","S","S","S","S",
            		"S","S","S","N","S","S","S", "S","S","S","S","S",
            		"S","S","S","S","S","S"
            		,"S","S","S","S"
            };
            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
            rtn = sm.doUpdate(args,setType);
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

    private int et_deletePrdtAllPrBr(String pr_no) throws Exception{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE");
        String add_user_id  = info.getSession("ID");
        Map<String, String> param = new HashMap<String, String>();
        int rtn = 0;

        try{
        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx, wxp);
            
            param.put("house_code", house_code);
            param.put("pr_no",      pr_no);
            
            rtn = sm.doDelete(param);
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
    
    private int et_deletePrdtAll(String pr_no) throws Exception{
    	ConnectionContext   ctx   = getConnectionContext();
    	SepoaXmlParser      sxp   = null;
		SepoaSQLManager     ssm   = null;
		Map<String, String> param = new HashMap<String, String>();
        int                 rtn   = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "et_deletePrdtAll");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            
            param.put("house_code", info.getSession("HOUSE_CODE"));
            param.put("pr_no",      pr_no);
                            
            rtn = ssm.doDelete(param);
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
    }
    
	public SepoaOut getReqBidItemList(Map<String, String> header) {
		String lang = info.getSession("LANGUAGE");

		try	{

			String rtn = et_getReqBidItemList(header );
			setValue(rtn);
			setStatus(1);
			setMessage(msg.get("STDRFQ.0000"));
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDRFQ.0001"));
		}
		return getSepoaOut();
	}

	private	String et_getReqBidItemList(Map<String, String> header ) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
		String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");
        String house_code = info.getSession("HOUSE_CODE");

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));


		try	{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn	= sm.doSelect(header);
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	public SepoaOut getBidEvaluation(String rfq_no,String rfq_count)
	{
		String lang = info.getSession("LANGUAGE");
		try{
			String rtn = et_getBidEvaluation(rfq_no,rfq_count);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.get("STDRFQ.0000"));
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDRFQ.0001"));
		}
		return getSepoaOut();
	}

	private	String et_getBidEvaluation( String rfq_no, String rfq_count) throws Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append("     SELECT                                          \n");
//		sql.append("         DOC_NO,                                     \n");
//		sql.append("         DOC_SEQ,                                    \n");
//		sql.append("         TBE_FIELD,                                  \n");
//		sql.append("         TBE_SEQ,                                    \n");
//		sql.append("         WEIGHT                                      \n");
//		sql.append("     FROM    ICOYTBEV                                \n");
//		sql.append("     WHERE   STATUS IN ('C','R')                     \n");
//		sql.append(" <OPT=S,S>    AND     HOUSE_CODE  = ?  </OPT>        \n");
//		sql.append(" <OPT=S,S>    AND     DOC_NO      = ?  </OPT>        \n");
//		sql.append(" <OPT=S,S>    AND     DOC_SEQ   = ?  </OPT>          \n");

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

	public SepoaOut setBidCreate(String pflag,
								String create_type,
								String rfq_flag,
								String rfq_type,
								String rfq_no,
								String rfq_count,
								String[][] chkdata,
								String[][] prhddata,
								String[][] prdtdata,
								String[][] rqhddata,
								String[][] rqdtdata,
								String[][] rqsedata,
								String[][] rqopdata,
								String[][] rqandata,
								String[][] tbevdata,
								String[][] tbusdata,
								String[][] prcfmdata,
								String bd_tot_amt
								)
	{
	    	String add_user_id     =  info.getSession("ID");
	        String house_code      =  info.getSession("HOUSE_CODE");
	        String company         =  info.getSession("COMPANY_CODE");
	        String add_user_dept   =  info.getSession("DEPARTMENT");
	        String dept_name       =  info.getSession("DEPARTMENT_NAME_LOC");
	        String name_eng        =  info.getSession("NAME_ENG");
	        String name_loc        =  info.getSession("NAME_LOC");
            String lang            =  info.getSession("LANGUAGE");

        try {
    		if(rqdtdata	== null || rqdtdata.length == 0	) {
    			setStatus(0);
    			setMessage(msg.get("STDRFQ.0005"));
    			return getSepoaOut();
    		}

            Logger.debug.println(info.getSession("ID"), this, "##### pflag       ===> " + pflag);
            Logger.debug.println(info.getSession("ID"), this, "##### create_type ===> " + create_type);
            Logger.debug.println(info.getSession("ID"), this, "##### rfq_flag    ===> " + rfq_flag);

			ConnectionContext ctx =	getConnectionContext();


			/***************************************************************************
				1. 입찰요청가능여부	체크
			****************************************************************************/
			//String[] rtn = et_getRfqCount(ctx, chkdata);
			//if (!rtn[0].equals("0")) { //아이템이 견적중임.....
			//	setStatus(0);
			//	msg.setArg("ITEM_NO",rtn[1]);
			//	setMessage(msg.getMessage("0043"));
			//	return getSepoaOut();
			//}

			/***************************************************************************
				3. 입찰 Header (ICOYRQHD) 생성
			****************************************************************************/
			int rqhd 		= et_setRfqHDCreate(ctx,
												rqhddata
										  		);

			/***************************************************************************
				4. 입찰 Detail (ICOYRQDT) 생성
			****************************************************************************/

			int	rqdt =	et_setRfqDTCreate(	ctx,
											rqdtdata
											);

			/***************************************************************************
				5. 입찰 Operating (ICOYRQOP)	생성, ICOYRQSE 생성
			****************************************************************************/
			//여기는 지명입찰입니다. OP는	공개입찰
			if(!rfq_type.equals("OP"))
			{
				int rqop = et_setRfqOPCreate(ctx,rqopdata);
				int rqse = et_setRfqSECreate(ctx,rqsedata);
			}

			/***********************************************************************************************
				6. 사양설명회(ICOYRQAN) 생성
			************************************************************************************************/

			if(rqandata.length > 0) {
				int rqan = et_setRfqANCreate(ctx,rqandata);
			}

				if(tbevdata.length > 0) {
					int tbev = et_setRfqTbCreate(ctx,tbevdata);
				}

				if(tbusdata.length > 0) {
					int tbus = et_setRfqTbusCreate(ctx,tbusdata);
				}

//Logger.debug.println(info.getSession("ID"),this,"7. RFQ 생성시	청구(ICOYPRDT) 확정(UPDATE : PROCEEDING_FLAG = 'C')	---------------------======");
/***************************************************************************
				7. 입찰 생성시 청구(ICOYPRDT) 확정(UPDATE : PROCEEDING_FLAG = 'C')
****************************************************************************/
			//if (create_type.equals("PR")) {
				int prcfm = et_setPRComfirm(ctx, prcfmdata);
			//}

			if(rfq_flag.equals("P")) // 전송 일 경우.
			{
/***************************************************************************
				8. 입찰 생성후 결재요청
****************************************************************************/
                SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType("BD");
                sri.setDocNo(rfq_no);
                sri.setDocSeq(rfq_count);
                sri.setItemCount(rqdtdata.length);
                sri.setSignStatus(rfq_flag);
                sri.setTotalAmt(Double.parseDouble(bd_tot_amt));

                sri.setSignString(pflag); // AddParameter 에서 넘어온 정보
                int rtn = CreateApproval(info,sri);    //밑에 함수 실행
                if(rtn == 0)
                {
                    try
                    {
                        Rollback();
                    }
                    catch(Exception d)
                    {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.get("STDRFQ.0030"));
                    return getSepoaOut();
                }
				int signup = temp_Approval(ctx, rfq_no, "1",	"P");
			}
			else
			{
				int signup = temp_Approval(ctx, rfq_no, "1",	"W");
			}

/***************************************************************************
	9. 입찰 생성후 icoyprdt.sourcing_type 업데이트
****************************************************************************/
  			int signup = et_prdtSourcingTypeUpd(ctx, rfq_no, "1" );

			setStatus(1);
			setValue(String.valueOf(rqdt));
			msg.put("RFQ_NO",rfq_no);

			if(rfq_flag.equals("P"))
				setMessage(msg.get("STDRFQ.0048"));
			else
				setMessage(msg.get("STDRFQ.0045"));

			Commit();


		} catch(Exception e) {
			try	{
				Rollback();
			} catch(Exception d) {
				Logger.err.println(info.getSession("ID"),this,d.getMessage());
			}
			setStatus(0);
		}
		return getSepoaOut();

	}
	//setBidCreate Method End
//
//	private	String[] et_getRfqCount(ConnectionContext ctx,String[][] chkdata) throws Exception
//	{
//		String[] val = new String[2];
//		StringBuffer sql = new StringBuffer();
//		String house_code = info.getSession("HOUSE_CODE");
//
//		 sql.append(" SELECT                                                          \n");
//	     sql.append("     COUNT(*)   AS  RFQ_CNT                                      \n");
//	     sql.append(" FROM   ICOYPRDT                                                 \n");
//	     sql.append(" WHERE  HOUSE_CODE         =   '"+house_code+"'                  \n");
//	     sql.append(" <OPT=S,S> AND  ITEM_NO   =   ?      </OPT>                 	  \n");
//	     sql.append("   AND  STATUS      		IN  ('C','R')                      	  \n");
//	     sql.append("   AND  PR_PROCEEDING_FLAG	IN  ('C','A')                      	  \n");
//
//
//		try{
//			int	j =	0;
//			val[1] = "";
//
//			for( int i = 0;	i <	chkdata.length; i++ )
//			{
//				String tmp = chkdata[i][0];
//				if(tmp.length() > 0) {
//					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
//					String sel_rtn = sm.doSelect(chkdata[i]);
//					SepoaFormater wf	= new SepoaFormater(sel_rtn);
//
//					int	k= Integer.parseInt( wf.getValue("RFQ_CNT", 0) );
//					if(	k != 0 ){
//						j++;
//						val[1] += (	chkdata[i][0]+" ");
//					}
//				}
//			}
//			val[0] = String.valueOf(j);
//
//		}catch(Exception e)	{
//			Logger.debug.println(info.getSession("ID"),this,e.getMessage());
//			throw new Exception(e.getMessage());
//		}
//		return val;
//	}
//
	private	int et_setRfqHDCreate(	ConnectionContext ctx,
										String[][] rqhddata) throws	Exception
	{
		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

 Logger.debug.println(info.getSession("ID"),this,"--------------------------------------"+rqhddata[0].length);
//		sql.append(" INSERT INTO ICOYRQHD (        \n");
//		sql.append(" 		 HOUSE_CODE            \n");
//		sql.append(" 		,RFQ_NO                \n");
//		sql.append(" 		,RFQ_COUNT             \n");
//		sql.append(" 		,STATUS                \n");
//		sql.append(" 		,COMPANY_CODE          \n");
//		sql.append(" 		,RFQ_DATE              \n");
//		sql.append(" 		,RFQ_CLOSE_DATE        \n");
//		sql.append(" 		,RFQ_CLOSE_TIME        \n");
//		sql.append(" 		,RFQ_TYPE              \n");
//		sql.append(" 		,SETTLE_TYPE           \n");
//		sql.append(" 		,BID_TYPE              \n");
//		sql.append(" 		,RFQ_FLAG              \n");
//		sql.append(" 		,TERM_CHANGE_FLAG      \n");
//		sql.append(" 		,CREATE_TYPE           \n");
//		sql.append(" 		,BID_COUNT             \n");
//		sql.append(" 		,CTRL_CODE             \n");
//		sql.append(" 		,ADD_USER_ID           \n");
//		sql.append(" 		,ADD_DATE              \n");
//		sql.append(" 		,ADD_TIME              \n");
//		sql.append(" 		,CHANGE_DATE           \n");
//		sql.append(" 		,CHANGE_TIME           \n");
//		sql.append(" 		,CHANGE_USER_ID        \n");
//		sql.append(" 		,SUBJECT               \n");
//		sql.append(" 		,REMARK                \n");
//		sql.append(" 		,DOM_EXP_FLAG          \n");
//		sql.append(" 		,ARRIVAL_PORT          \n");
//		sql.append(" 		,USANCE_DAYS           \n");
//		sql.append(" 		,SHIPPING_METHOD       \n");
//		sql.append(" 		,PAY_TERMS             \n");
//		sql.append(" 		,ARRIVAL_PORT_NAME     \n");
//		sql.append(" 		,DELY_TERMS            \n");
//		sql.append(" 		,PRICE_TYPE            \n");
//		sql.append(" 		,SETTLE_COUNT          \n");
//		sql.append(" 		,RESERVE_PRICE         \n");
//		sql.append(" 		,CURRENT_PRICE         \n");
//		sql.append(" 		,BID_DEC_AMT           \n");
//		sql.append(" 		,TEL_NO                \n");
//		sql.append(" 		,EMAIL                 \n");
//		sql.append(" 		,BD_TYPE               \n");
//		sql.append(" 		,CUR                   \n");
//		sql.append(" 		,START_DATE            \n");
//		sql.append(" 		,START_TIME            \n");
//		sql.append(" 		,Z_SMS_SEND_FLAG       \n");
//		sql.append(" 		,Z_RESULT_OPEN_FLAG    \n");
//		sql.append(" 		,bid_rfq_type    		\n");
//		sql.append(" 		,bid_req_type    		\n");
//		sql.append(" 		,attach_no    			\n");
//		sql.append(" 		,bid_technique_eval    	\n");
//		sql.append(" 		,bid_price_eval    		\n");
//		sql.append(" 		,RFQ_TIME    			\n");
//		sql.append(" ) VALUES (                    \n");
//		sql.append(" 		 ?                     \n");  // HOUSE_CODE
//		sql.append(" 		,?                     \n");  // RFQ_NO
//		sql.append(" 		,?                     \n");  // RFQ_COUNT
//		sql.append(" 		,?                     \n");  // STATUS
//		sql.append(" 		,?                     \n");  // COMPANY_CODE
//		sql.append(" 		,?                     \n");  // RFQ_DATE
//		sql.append(" 		,?                     \n");  // RFQ_CLOSE_DATE
//		sql.append(" 		,?                     \n");  // RFQ_CLOSE_TIME
//		sql.append(" 		,?                     \n");  // RFQ_TYPE
//		sql.append(" 		,?                     \n");  // SETTLE_TYPE
//		sql.append(" 		,?                     \n");  // BID_TYPE
//		sql.append(" 		,?                     \n");  // RFQ_FLAG
//		sql.append(" 		,?                     \n");  // TERM_CHANGE_FLAG
//		sql.append(" 		,?                     \n");  // CREATE_TYPE
//		sql.append(" 		,?                     \n");  // BID_COUNT
//		sql.append(" 		,?                     \n");  // CTRL_CODE
//		sql.append(" 		,?                     \n");  // ADD_USER_ID
//		sql.append(" 		,?                     \n");  // ADD_DATE
//		sql.append(" 		,?                     \n");  // ADD_TIME
//		sql.append(" 		,?                     \n");  // CHANGE_DATE
//		sql.append(" 		,?                     \n");  // CHANGE_TIME
//		sql.append(" 		,?                     \n");  // CHANGE_USER_ID
//		sql.append(" 		,?                     \n");  // SUBJECT
//		sql.append(" 		,?                     \n");  // REMARK
//		sql.append(" 		,?                     \n");  // DOM_EXP_FLAG
//		sql.append(" 		,?                     \n");  // ARRIVAL_PORT
//		sql.append(" 		,?                     \n");  // USANCE_DAYS
//		sql.append(" 		,?                     \n");  // SHIPPING_METHOD
//		sql.append(" 		,?                     \n");  // PAY_TERMS
//		sql.append(" 		,dbo.GETICOMCODE2(?, 'M005', ?)   \n");  // ARRIVAL_PORT_NAME
//		sql.append(" 		,?                     \n");  // DELY_TERMS
//		sql.append(" 		,?                     \n");  // PRICE_TYPE
//		sql.append(" 		,?                     \n");  // SETTLE_COUNT
//		sql.append(" 		,?                     \n");  // RESERVE_PRICE
//		sql.append(" 		,?                     \n");  // CURRENT_PRICE
//		sql.append(" 		,?                     \n");  // BID_DEC_AMT
//		sql.append(" 		,?                     \n");  // TEL_NO
//		sql.append(" 		,?                     \n");  // EMAIL
//		sql.append(" 		,?                     \n");  // BD_TYPE
//		sql.append(" 		,?                     \n");  // CUR
//		sql.append(" 		,?                     \n");  // START_DATE
//		sql.append(" 		,?                     \n");  // START_TIME
//		sql.append(" 		,?                     \n");  // Z_SMS_SEND_FLAG
//		sql.append(" 		,?                     \n");  // Z_RESULT_OPEN_FLAG
//		sql.append(" 		,?                     \n");  // Z_RESULT_OPEN_FLAG
//		sql.append(" 		,?                     \n");  // Z_RESULT_OPEN_FLAG
//		sql.append(" 		,?                     \n");  // Z_RESULT_OPEN_FLAG
//		sql.append(" 		,?                     \n");  // Z_RESULT_OPEN_FLAG
//		sql.append(" 		,?                     \n");  // Z_RESULT_OPEN_FLAG
//		sql.append(" 		,?                     \n");  // RFQ_TIME
//		sql.append(" )                             \n");

		try{

			String[] type =	{ "S","S","N","S","S"
							, "S","S","S","S","S"
							, "S","S","S","S","S"
							, "S","S","S","S","S"
							, "S","S","S","S","S"
							, "S","N","S","S","S"
							, "S","S","S","N","N"
							, "N","N","S","S","S"
							, "S","S","S","S","S"
							, "S","S","S","S","S"
							,"S"
							};

			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doInsert(rqhddata,type);

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
//
	private	int	et_setRfqDTCreate(ConnectionContext	ctx,
									String[][] rqdtdata) throws	Exception
	{

		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" INSERT INTO ICOYRQDT (         \n");
//		sql.append(" 		 HOUSE_CODE             \n");
//		sql.append(" 		,RFQ_NO                 \n");
//		sql.append(" 		,RFQ_COUNT              \n");
//		sql.append(" 		,RFQ_SEQ                \n");
//		sql.append(" 		,STATUS                 \n");
//
//		sql.append(" 		,COMPANY_CODE           \n");
//		sql.append(" 		,PLANT_CODE             \n");
//		sql.append(" 		,RFQ_PROCEEDING_FLAG    \n");
//		sql.append(" 		,ADD_DATE               \n");
//		sql.append(" 		,ADD_TIME               \n");
//
//		sql.append(" 		,ADD_USER_ID            \n");
//		sql.append(" 		,CHANGE_DATE            \n");
//		sql.append(" 		,CHANGE_TIME            \n");
//		sql.append(" 		,CHANGE_USER_ID         \n");
//		sql.append(" 		,ITEM_NO                \n");
//
//		sql.append(" 		,UNIT_MEASURE           \n");
//		sql.append(" 		,RD_DATE                \n");
//		sql.append(" 		,VALID_FROM_DATE        \n");
//		sql.append(" 		,VALID_TO_DATE          \n");
//		sql.append(" 		,PURCHASE_PRE_PRICE     \n");
//
//		sql.append(" 		,RFQ_QTY                \n");
//		sql.append(" 		,RFQ_AMT                \n");
//		sql.append(" 		,BID_COUNT              \n");
//		sql.append(" 		,CUR                    \n");
//		sql.append(" 		,PR_NO                  \n");
//
//		sql.append(" 		,PR_SEQ                 \n");
//		sql.append(" 		,SETTLE_FLAG            \n");
//		sql.append(" 		,SETTLE_QTY             \n");
//		sql.append(" 		,TBE_FLAG               \n");
//		sql.append(" 		,TBE_DEPT               \n");
//
//		sql.append(" 		,PRICE_TYPE             \n");
//		sql.append(" 		,TBE_PROCEEDING_FLAG    \n");
//		sql.append(" 		,SAMPLE_FLAG            \n");
//		sql.append(" 		,DELY_TO_LOCATION       \n");
//		sql.append(" 		,ATTACH_NO              \n");
//
//		sql.append(" 		,SHIPPER_TYPE           \n");
//		sql.append(" 		,CONTRACT_FLAG          \n");
//		sql.append(" 		,COST_COUNT             \n");
//		sql.append(" 		,YEAR_QTY               \n");
//		sql.append(" 		,DELY_TO_ADDRESS        \n");
//
//		sql.append(" 		,MIN_PRICE              \n");
//		sql.append(" 		,MAX_PRICE              \n");
//		sql.append(" 		,STR_FLAG               \n");
//		sql.append(" 		,TBE_NO               	\n");	      //기술견적 평가 추가 2007.4.13
//		sql.append("		,Z_REMARK				\n");
//		sql.append("		, TECHNIQUE_GRADE		\n");
//		sql.append("		, TECHNIQUE_TYPE 		\n");
//		sql.append("		, INPUT_FROM_DATE		\n");
//		sql.append("		, INPUT_TO_DATE 		\n");
//		sql.append("		, SPECIFICATION 		\n");
//		sql.append("		, MAKER_NAME 			\n");
//
//		sql.append(" ) VALUES (                     \n");
//		sql.append(" 		 ?                      \n");//  HOUSE_CODE
//		sql.append(" 		,?                      \n");//  RFQ_NO
//		sql.append(" 		,?                      \n");//  RFQ_COUNT
//		sql.append(" 		,dbo.lpad(?, 6, '0') \n");//  RFQ_SEQ
//		sql.append(" 		,?                      \n");//  STATUS
//
//		sql.append(" 		,?                      \n");//  COMPANY_CODE
//		sql.append(" 		,?                      \n");//  PLANT_CODE
//		sql.append(" 		,?                      \n");//  RFQ_PROCEEDING_FLAG
//		sql.append(" 		,?                      \n");//  ADD_DATE
//		sql.append(" 		,?                      \n");//  ADD_TIME
//
//		sql.append(" 		,?                      \n");//  ADD_USER_ID
//		sql.append(" 		,?                      \n");//  CHANGE_DATE
//		sql.append(" 		,?                      \n");//  CHANGE_TIME
//		sql.append(" 		,?                      \n");//  CHANGE_USER_ID
//		sql.append(" 		,?                      \n");//  ITEM_NO
//
//		sql.append(" 		,?                      \n");//  UNIT_MEASURE
//		sql.append(" 		,?                      \n");//  RD_DATE
//		sql.append(" 		,?                      \n");//  VALID_FROM_DATE
//		sql.append(" 		,?                      \n");//  VALID_TO_DATE
//		sql.append(" 		,?                      \n");//  PURCHASE_PRE_PRICE
//
//		sql.append(" 		,?                      \n");//  RFQ_QTY
//		sql.append(" 		,?                      \n");//  RFQ_AMT
//		sql.append(" 		,?                      \n");//  BID_COUNT
//		sql.append(" 		,?                      \n");//  CUR
//		sql.append(" 		,?                      \n");//  PR_NO
//
//		sql.append(" 		,dbo.lpad(?, 5, '0') \n");//  PR_SEQ
//		sql.append(" 		,?                      \n");//  SETTLE_FLAG
//		sql.append(" 		,?                      \n");//  SETTLE_QTY
//		sql.append(" 		,?                      \n");//  TBE_FLAG
//		sql.append(" 		,?                      \n");//  TBE_DEPT
//
//		sql.append(" 		,?                      \n");//  PRICE_TYPE
//		sql.append(" 		,?                      \n");//  TBE_PROCEEDING_FLAG
//		sql.append(" 		,?                      \n");//  SAMPLE_FLAG
//		sql.append(" 		,?                      \n");//  DELY_TO_LOCATION
//		sql.append(" 		,?                      \n");//  ATTACH_NO
//
//		sql.append(" 		,?                      \n");//  SHIPPER_TYPE
//		sql.append(" 		,?                      \n");//  CONTRACT_FLAG
//		sql.append(" 		,?                      \n");//  COST_COUNT
//		sql.append(" 		,?                      \n");//  YEAR_QTY
//		sql.append(" 		,?                      \n");//  DELY_TO_ADDRESS
//
//		sql.append(" 		,?                      \n");//  MIN_PRICE
//		sql.append(" 		,?                      \n");//  MAX_PRICE
//		sql.append(" 		,?                      \n");//  STR_FLAG
//		sql.append(" 		,?                      \n");//  TBE_NO
//		sql.append(" 		,?                      \n");//
//		sql.append("		,? 						\n");//TECHNIQUE_GRADE
//		sql.append("		,? 						\n");//TECHNIQUE_TYPE
//		sql.append("		,? 						\n");//INPUT_FROM_DATE
//		sql.append("		,? 						\n");//INPUT_TO_DATE
//		sql.append("		,? 						\n");//SPECIFICATION
//		sql.append("		,? 						\n");//MAKER_NAME
//		sql.append(" )                              \n");

		try{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			String[] type =	{"S","S","N","S","S"
							,"S","S","S","S","S"
							,"S","S","S","S","S"
							,"S","S","S","S","N"
							,"N","N","N","S","S"
							,"S","S","N","S","S"
							,"S","S","S","S","S"
							,"S","S","N","N","S"
							,"N","N","S","S","S"
							,"S","S","S","S","S"
							,"S"
							};
			rtn	= sm.doInsert(rqdtdata,type);

		}catch(Exception e)	{
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private	int	et_setRfqOPCreate(ConnectionContext	ctx,
									String[][] rqopdata) throws Exception
	{

		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//		sql.append(" INSERT INTO ICOYRQOP (       \n");
//		sql.append(" 		 HOUSE_CODE           \n");
//		sql.append(" 		,RFQ_NO               \n");
//		sql.append(" 		,RFQ_COUNT            \n");
//		sql.append(" 		,RFQ_SEQ              \n");
//		sql.append(" 		,PURCHASE_LOCATION    \n");
//		sql.append(" 		,VENDOR_CODE          \n");
//		sql.append(" 		,STATUS               \n");
//		sql.append(" 		,ADD_USER_ID          \n");
//		sql.append(" 		,ADD_DATE             \n");
//		sql.append(" 		,ADD_TIME             \n");
//		sql.append(" 		,CHANGE_DATE          \n");
//		sql.append(" 		,CHANGE_TIME          \n");
//		sql.append(" 		,CHANGE_USER_ID       \n");
//		sql.append(" ) VALUES (                   \n");
//		sql.append(" 		 ?                    \n");      // HOUSE_CODE
//		sql.append(" 		,?                    \n");      // RFQ_NO
//		sql.append(" 		,?                    \n");      // RFQ_COUNT
//		sql.append(" 		,dbo.lpad(?, 6, '0') \n");      // RFQ_SEQ
//		sql.append(" 		,?                    \n");      // PURCHASE_LOCATION
//		sql.append(" 		,?                    \n");      // VENDOR_CODE
//		sql.append(" 		,?                    \n");      // STATUS
//		sql.append(" 		,?                    \n");      // ADD_USER_ID
//		sql.append(" 		,?                    \n");      // ADD_DATE
//		sql.append(" 		,?                    \n");      // ADD_TIME
//		sql.append(" 		,?                    \n");      // CHANGE_DATE
//		sql.append(" 		,?                    \n");      // CHANGE_TIME
//		sql.append(" 		,?                    \n");      // CHANGE_USER_ID
//		sql.append(" )                            \n");

		try	{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type =	{"S","S","N","S","S"
							,"S","S","S","S","S"
							,"S","S","S"};
			rtn	= sm.doInsert(rqopdata,type);
			Logger.debug.println(info.getSession("ID"),this, "rtn==//"+rtn+"//");
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private	int	et_setRfqSECreate(ConnectionContext	ctx,
									String[][]	rqsedata
								  ) throws Exception
	{

		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" INSERT INTO ICOYRQSE (      \n");
//		sql.append(" 		 HOUSE_CODE          \n");
//		sql.append(" 		,VENDOR_CODE         \n");
//		sql.append(" 		,RFQ_NO              \n");
//		sql.append(" 		,RFQ_COUNT           \n");
//		sql.append(" 		,RFQ_SEQ             \n");
//		sql.append(" 		,STATUS              \n");
//		sql.append(" 		,COMPANY_CODE        \n");
//		sql.append(" 		,CONFIRM_FLAG        \n");
//		sql.append(" 		,CONFIRM_DATE        \n");
//		sql.append(" 		,CONFIRM_USER_ID     \n");
//		sql.append(" 		,BID_FLAG            \n");
//		sql.append(" 		,ADD_DATE            \n");
//		sql.append(" 		,ADD_USER_ID         \n");
//		sql.append(" 		,ADD_TIME            \n");
//		sql.append(" 		,CHANGE_DATE         \n");
//		sql.append(" 		,CHANGE_USER_ID      \n");
//		sql.append(" 		,CHANGE_TIME         \n");
//		sql.append(" 		,CONFIRM_TIME        \n");
//		sql.append(" ) VALUES (                  \n");
//		sql.append(" 		 ?                   \n");   // HOUSE_CODE
//		sql.append(" 		,?                   \n");   // VENDOR_CODE
//		sql.append(" 		,?                   \n");   // RFQ_NO
//		sql.append(" 		,?                   \n");   // RFQ_COUNT
//		sql.append(" 		,dbo.lpad(?, 6, '0') \n");   // RFQ_SEQ
//		sql.append(" 		,?                   \n");   // STATUS
//		sql.append(" 		,?                   \n");   // COMPANY_CODE
//		sql.append(" 		,?                   \n");   // CONFIRM_FLAG
//		sql.append(" 		,?                   \n");   // CONFIRM_DATE
//		sql.append(" 		,?                   \n");   // CONFIRM_USER_ID
//		sql.append(" 		,?                   \n");   // BID_FLAG
//		sql.append(" 		,?                   \n");   // ADD_DATE
//		sql.append(" 		,?                   \n");   // ADD_USER_ID
//		sql.append(" 		,?                   \n");   // ADD_TIME
//		sql.append(" 		,?                   \n");   // CHANGE_DATE
//		sql.append(" 		,?                   \n");   // CHANGE_USER_ID
//		sql.append(" 		,?                   \n");   // CHANGE_TIME
//		sql.append(" 		,?                   \n");   // CONFIRM_TIME
//		sql.append(" )                           \n");

		try{

			String[] type =	{"S","S","S","N","S"
							,"S","S","S","S","S"
							,"S","S","S","S","S"
							,"S","S","S"
							};
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doInsert(rqsedata,type);
		}catch(Exception e)	{
			Logger.err.println("AAAAAAAAAAAAAAAAAAA"+info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private	int et_setRfqANCreate(ConnectionContext	ctx,
								String[][] rqandata
								) throws Exception
	{

		int rtn = 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" INSERT INTO ICOYRQAN (      \n");
//		sql.append(" 		 HOUSE_CODE          \n");
//		sql.append(" 		,RFQ_NO              \n");
//		sql.append(" 		,RFQ_COUNT           \n");
//		sql.append(" 		,STATUS              \n");
//		sql.append(" 		,COMPANY_CODE        \n");
//		sql.append(" 		,ANNOUNCE_DATE       \n");
//		sql.append(" 		,ANNOUNCE_TIME_FROM  \n");
//		sql.append(" 		,ANNOUNCE_TIME_TO    \n");
//		sql.append(" 		,ANNOUNCE_HOST       \n");
//		sql.append(" 		,ANNOUNCE_AREA       \n");
//		sql.append(" 		,ANNOUNCE_PLACE      \n");
//		sql.append(" 		,ANNOUNCE_NOTIFIER   \n");
//		sql.append(" 		,ANNOUNCE_RESP       \n");
//		sql.append(" 		,DOC_FRW_DATE        \n");
//		sql.append(" 		,ADD_USER_ID         \n");
//		sql.append(" 		,ADD_DATE            \n");
//		sql.append(" 		,ADD_TIME            \n");
//		sql.append(" 		,CHANGE_USER_ID      \n");
//		sql.append(" 		,CHANGE_DATE         \n");
//		sql.append(" 		,CHANGE_TIME         \n");
//		sql.append(" 		,ANNOUNCE_COMMENT    \n");
//		sql.append(" ) VALUES (                  \n");
//		sql.append(" 		 ?                   \n");  //  HOUSE_CODE
//		sql.append(" 		,?                   \n");  //  RFQ_NO
//		sql.append(" 		,?                   \n");  //  RFQ_COUNT
//		sql.append(" 		,?                   \n");  //  STATUS
//		sql.append(" 		,?                   \n");  //  COMPANY_CODE
//		sql.append(" 		,?                   \n");  //  ANNOUNCE_DATE
//		sql.append(" 		,?                   \n");  //  ANNOUNCE_TIME_FROM
//		sql.append(" 		,?                   \n");  //  ANNOUNCE_TIME_TO
//		sql.append(" 		,?                   \n");  //  ANNOUNCE_HOST
//		sql.append(" 		,?                   \n");  //  ANNOUNCE_AREA
//		sql.append(" 		,?                   \n");  //  ANNOUNCE_PLACE
//		sql.append(" 		,?                   \n");  //  ANNOUNCE_NOTIFIER
//		sql.append(" 		,?                   \n");  //  ANNOUNCE_RESP
//		sql.append(" 		,?                   \n");  //  DOC_FRW_DATE
//		sql.append(" 		,?                   \n");  //  ADD_USER_ID
//		sql.append(" 		,?                   \n");  //  ADD_DATE
//		sql.append(" 		,?                   \n");  //  ADD_TIME
//		sql.append(" 		,?                   \n");  //  CHANGE_USER_ID
//		sql.append(" 		,?                   \n");  //  CHANGE_DATE
//		sql.append(" 		,?                   \n");  //  CHANGE_TIME
//		sql.append(" 		,?                   \n");  //  ANNOUNCE_COMMENT
//		sql.append(" )                           \n");

		try{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type =	{"S","S","N","S","S"
							,"S","S","S","S","S"
							,"S","S","S","S","S"
							,"S","S","S","S","S"
							,"S"
							};

			rtn = sm.doInsert(rqandata,type);
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}

		return rtn;
	}

	private	int et_setRfqTbCreate(ConnectionContext	ctx,
								String[][] tbevdata
								) throws Exception
	{

		int rtn = 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" INSERT INTO ICOYTBEV (    			\n");
//		sql.append(" 		 HOUSE_CODE        			\n");
//		sql.append(" 		,DOC_NO       				\n");
//		sql.append(" 		,DOC_SEQ            		\n");
//		sql.append(" 		,TBE_FIELD          		\n");
//		sql.append(" 		,WEIGHT      				\n");
//		sql.append(" 		,TBE_SEQ   					\n");
//		sql.append(" 		,STATUS            			\n");
//		sql.append(" 		,ADD_USER_ID       			\n");
//		sql.append(" 		,ADD_DATE          			\n");
//		sql.append(" 		,ADD_TIME          			\n");
//		sql.append(" ) VALUES (                			\n");
//		sql.append(" 		 ?                 			\n");   // HOUSE_CODE
//		sql.append(" 		,?       					\n");
//		sql.append(" 		,?            				\n");
//		sql.append(" 		,?          				\n");
//		sql.append(" 		,?      					\n");
//		sql.append(" 		,dbo.lpad(?, 6, '0') \n");  // RFQ_SEQ
//		sql.append(" 		,?                 			\n");   // STATUS
//		sql.append(" 		,?                 			\n");   // ADD_USER_ID
//		sql.append(" 		,?                 			\n");   // ADD_DATE
//		sql.append(" 		,?                 			\n");   // ADD_TIME
//		sql.append(" )                         			\n");

		try{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type =	{"S","S","S","S","S"
							,"N","S","S","S","S"
							};

			rtn = sm.doInsert(tbevdata,type);
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}

		return rtn;
	}

	private	int et_setRfqTbusCreate(ConnectionContext	ctx,
								String[][] tbusdata
								) throws Exception
	{

		int rtn = 0;


		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" INSERT INTO ICOYTBUS (    			\n");
//		sql.append(" 		 HOUSE_CODE        			\n");
//		sql.append(" 		,DOC_NO       				\n");
//		sql.append(" 		,DOC_SEQ            		\n");
//		sql.append(" 		,TBS_ID          			\n");
//		sql.append(" 		,TBS_NAME          			\n");
//		sql.append(" 		,TBS_DEPT      				\n");
//		sql.append(" 		,TBS_COMPANY   				\n");
//		sql.append(" 		,TBS_YN  					\n");
//		sql.append(" 		,STATUS            			\n");
//		sql.append(" 		,ADD_USER_ID       			\n");
//		sql.append(" 		,ADD_DATE          			\n");
//		sql.append(" 		,ADD_TIME          			\n");
//		sql.append(" ) VALUES (                			\n");
//		sql.append(" 		 ?                 			\n");   // HOUSE_CODE
//		sql.append(" 		,?       					\n");   // DOC_NO
//		sql.append(" 		,?            				\n");   // DOC_SEQ
//		sql.append(" 		,?      					\n");   // TBS_ID
//		sql.append(" 		,?      					\n");   // TBS_NAME
//		sql.append(" 		,?      					\n");   // TBS_DEPT
//		sql.append(" 		,?      					\n");   // TBS_COMPANY
//		sql.append("        ,'N'						\n");
//		sql.append(" 		,?      					\n");   // STATUS
//		sql.append(" 		,?                 			\n");   // ADD_USER_ID
//		sql.append(" 		,?                 			\n");   // ADD_DATE
//		sql.append(" 		,?                 			\n");   // ADD_TIME
//		sql.append(" )                         			\n");
//
		try{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type =	{"S","S","S","S","S"
							,"S","S","S","S","S"
							,"S" };

			rtn = sm.doInsert(tbusdata,type);
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}

		return rtn;
	}
//
	private	int	et_setPRComfirm(ConnectionContext ctx, String[][] prcfmdata) throws	Exception
	{

		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" UPDATE	ICOYPRDT SET				    		\n");
//		sql.append("		 CONFIRM_QTY		= ?	        		\n");
//		sql.append("		,PR_PROCEEDING_FLAG	= 'C'				\n");
//		sql.append(" WHERE	HOUSE_CODE 	= ?  						\n");
//		sql.append(" AND	PR_NO 		= ?					   		\n");
//		sql.append(" AND	PR_SEQ 		= dbo.lpad(?, 5, '0') 	\n");

		try	{
			String[] type =	{"S","S","S","S"};
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn	= sm.doUpdate(prcfmdata,type);
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private	int	temp_Approval(ConnectionContext	ctx, String	rfq_no,	String rfq_count, String flag) throws Exception
	{
		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" UPDATE	ICOYRQHD						\n");
//		sql.append("   SET  SIGN_STATUS		= ?				\n");
//		sql.append("	   ,SIGN_PERSON_ID	= ?			    \n");
//		sql.append("	   ,SIGN_DATE		= ?				\n");
// 		sql.append(" WHERE HOUSE_CODE		= ?	            \n");
//		sql.append("   AND RFQ_NO			= ?				\n");
//		sql.append("   AND RFQ_COUNT		= ?				\n");
//		sql.append("   AND STATUS			IN ('C', 'R')	\n");

		try	{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type = {"S", "S", "S", "S", "S"
							,"N"};

			String[][] signUpdata = {{flag, info.getSession("ID"), SepoaDate.getShortDateString(), info.getSession("HOUSE_CODE"), rfq_no,
									rfq_count	}};

			rtn	= sm.doUpdate(signUpdata, type);

		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
//
	public SepoaOut setBidChange(String pflag,
								String create_type,
								String rfq_flag,
								String rfq_type,
								String rfq_no,
								String rfq_count,
								String onlyheader,
								String[][] delrqdtdata,
								String[][] delrqsedata,
								String[][] delrqopdata,
								String[][] deltbevdata,
								String[][] deltbusdata,
								String[][] delrqandata,
								String[][] delprhddata,
								String[][] delprdtdata,
								String[][] prhddata,
								String[][] prdtdata,
								String[][] rqhddata,
								String[][] rqdtdata,
								String[][] rqsedata,
								String[][] rqopdata,
								String[][] tbevdata,
								String[][] tbusdata,
								String[][] rqandata,
								String bd_tot_amt
								)
	{
        try {
		Logger.debug.println("AAAAAAAAAAAAA"+rqhddata.length+"AAA");
			ConnectionContext ctx =	getConnectionContext();

	    	String add_user_id     =  info.getSession("ID");
	        String house_code      =  info.getSession("HOUSE_CODE");
	        String company         =  info.getSession("COMPANY_CODE");
	        String add_user_dept   =  info.getSession("DEPARTMENT");
	        String dept_name       =  info.getSession("DEPARTMENT_NAME_LOC");
	        String name_eng        =  info.getSession("NAME_ENG");
	        String name_loc        =  info.getSession("NAME_LOC");
            String lang            =  info.getSession("LANGUAGE");
			/***************************************************************************
				1. 견적변경가능여부	체크
			****************************************************************************/
			int chkrtn = et_ChkBidCount(ctx, rfq_no, rfq_count);
			if(chkrtn > 0) { // 입찰자가 있음.
				setStatus(0);
				msg.put("RFQ_NO", rfq_no);
				setMessage(msg.get("STDRFQ.0046"));
				return getSepoaOut();
			}

			//if(onlyheader.equals("N")) {

				int delrqdt = et_delRQDT(ctx, delrqdtdata);
				int delrqse = et_delRQSE(ctx, delrqsedata);
				int delrqop = et_delRQOP(ctx, delrqopdata);

				if(deltbevdata.length > 0) {
					int deltbev = et_delTBEV(ctx, deltbevdata);
				}
				if(deltbusdata.length > 0) {
					int deltbus = et_delTBUS(ctx, deltbusdata);
				}

				if(delrqandata.length > 0) {
					int delrqan = et_delRQAN(ctx, delrqandata);
				}

				if(create_type.equals("MA")) {
					int delprhd = et_delPRHD(ctx, delprhddata);
					int delprdt = et_delPRDT(ctx, delprdtdata);
//					int prhd	= et_setPrHDCreate( prhddata); // 변환 작업 중 임시 주석
//					int	prdt	= et_setPrDTCreate(	prdtdata); // 변환 작업 중 임시 주석
				}

				int	rqdt =	et_setRfqDTCreate(	ctx,
												rqdtdata
												);

				if(!rfq_type.equals("OP"))
				{
					int rqop = et_setRfqOPCreate(ctx,rqopdata);
					int rqse = et_setRfqSECreate(ctx,rqsedata);
				}

				if(tbevdata.length > 0) {
					int tbev = et_setRfqTbCreate(ctx,tbevdata);
				}

				if(tbusdata.length > 0) {
					int tbse = et_setRfqTbusCreate(ctx,tbusdata);
				}

				if(rqandata.length > 0) {
					int rqan = et_setRfqANCreate(ctx,rqandata);
				}
			//}

			int rtn = et_setRfqHDChange(ctx, rqhddata);
			if(pflag.equals("N")){
				msg.put("RFQ_NO",rfq_no);
				setMessage(msg.get("STDRFQ.0070"));
			}else{
				//msg.setArg("RFQ_NO",rfq_no);
				//setMessage(msg.getMessage("0044"));
                SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType("BD");
                sri.setDocNo(rfq_no);
                sri.setDocSeq(rfq_count);
                sri.setItemCount(rqdtdata.length);
                sri.setSignStatus(rfq_flag);
                sri.setTotalAmt(Double.parseDouble(bd_tot_amt));

                sri.setSignString(pflag); // AddParameter 에서 넘어온 정보
                rtn = CreateApproval(info,sri);    //밑에 함수 실행
                if(rtn == 0)
                {
                    try
                    {
                        Rollback();
                    }
                    catch(Exception d)
                    {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.get("STDRFQ.0030"));
                    return getSepoaOut();
                }else{
					msg.put("RFQ_NO",rfq_no);
					setMessage(msg.get("STDRFQ.0048"));
                }
				int signup = temp_Approval(ctx, rfq_no, "1",	"P");
			}
			setStatus(1);
			setValue(String.valueOf(rtn));

			Commit();


		} catch(Exception e) {
			try	{
				Rollback();
			} catch(Exception d) {
				Logger.err.println(info.getSession("ID"),this,d.getMessage());
			}
			setStatus(0);
		}
		return getSepoaOut();

	}

	private	int et_ChkBidCount(ConnectionContext ctx, String rfq_no, String rfq_count) throws Exception
	{
		int res = 0;
		String rtn = null;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" SELECT BID_COUNT					     \n");
//		sql.append(" FROM   ICOYRQHD                         \n");
//		sql.append(" WHERE  STATUS IN ('C', 'R')             \n");
//		sql.append(" <OPT=S,S> AND    HOUSE_CODE = ? </OPT>  \n");
//		sql.append(" <OPT=S,S> AND    RFQ_NO     = ? </OPT>  \n");
//		sql.append(" <OPT=S,N> AND    RFQ_COUNT  = ? </OPT>  \n");

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

	private	int	et_setRfqHDChange(	ConnectionContext ctx,
									String[][] rqhddata)throws	Exception
	{
		int	rtn	= 0;

		Logger.debug.println("AAAAAAAAAAAAA"+rqhddata.length+"AAA");
		Logger.debug.println("AAAAAAAAAAAAA"+rqhddata[0].length+"AAA");

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" UPDATE ICOYRQHD                 							\n");
//		sql.append(" SET                             							\n");
//		sql.append(" 	 STATUS              = ?     							\n");
//		sql.append(" 	,RFQ_DATE            = ?     							\n");
//		sql.append(" 	,RFQ_CLOSE_DATE      = ?     							\n");
//		sql.append(" 	,RFQ_CLOSE_TIME      = ?     							\n");
//		sql.append(" 	,RFQ_TYPE            = ?     							\n");
//		sql.append(" 	,SETTLE_TYPE         = ?     							\n");
//		sql.append(" 	,RFQ_FLAG            = ?     							\n");
//		sql.append(" 	,TERM_CHANGE_FLAG    = ?     							\n");
//		sql.append(" 	,CHANGE_DATE         = ?     							\n");
//		sql.append(" 	,CHANGE_TIME         = ?     							\n");
//		sql.append(" 	,CHANGE_USER_ID      = ?     							\n");
//		sql.append(" 	,SUBJECT             = ?     							\n");
//		sql.append(" 	,REMARK              = ?     							\n");
//		sql.append(" 	,DOM_EXP_FLAG        = ?     							\n");
//		sql.append(" 	,ARRIVAL_PORT        = ?     							\n");
//		sql.append(" 	,USANCE_DAYS         = ?     							\n");
//		sql.append(" 	,SHIPPING_METHOD     = ?     							\n");
//		sql.append(" 	,PAY_TERMS           = ?     							\n");
//		sql.append(" 	,ARRIVAL_PORT_NAME   = dbo.GETICOMCODE2(?, 'M005', ?)     	\n");
//		sql.append(" 	,DELY_TERMS          = ?     							\n");
//		sql.append(" 	,PRICE_TYPE          = ?     							\n");
//		sql.append(" 	,CUR                 = ?     							\n");
//		sql.append(" 	,Z_SMS_SEND_FLAG     	= ?     						\n");
//		sql.append(" 	,Z_RESULT_OPEN_FLAG  	= ?     						\n");
//		sql.append(" 	,ATTACH_NO              = ?     						\n");
//		sql.append(" WHERE HOUSE_CODE = ?            							\n");
//		sql.append(" AND   RFQ_NO     = ?            							\n");
//		sql.append(" AND   RFQ_COUNT  = ?            							\n");

		try{

			String[] type =	{ "S","S","S","S","S"
							, "S","S","S","S","S"
							, "S","S","S","S","S"
							, "N","S","S","S","S"
							, "S","S","S","S","S"
							, "S","S","S","N"
							};
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doUpdate(rqhddata, type);

		}catch(Exception e)	{
			Logger.debug.println("LLLLLLLLLLLLLLLLLLLLLLLLLL"+ e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private	int	et_delRQDT(	ConnectionContext ctx,
							String[][] delrqdtdata)throws	Exception
	{
		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" DELETE FROM ICOYRQDT            \n");
//		sql.append(" WHERE HOUSE_CODE = ?            \n");
//		sql.append(" AND   RFQ_NO     = ?            \n");
//		sql.append(" AND   RFQ_COUNT  = ?            \n");

		try{

			String[] type =	{ "S","S","N" };
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doInsert(delrqdtdata, type);

		}catch(Exception e)	{
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private	int	et_delRQSE(	ConnectionContext ctx,
							String[][] delrqsedata)throws	Exception
	{
		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" DELETE FROM ICOYRQSE            \n");
//		sql.append(" WHERE HOUSE_CODE = ?            \n");
//		sql.append(" AND   RFQ_NO     = ?            \n");
//		sql.append(" AND   RFQ_COUNT  = ?            \n");

		try{

			String[] type =	{ "S","S","N" };
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doInsert(delrqsedata, type);

		}catch(Exception e)	{
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private	int	et_delRQOP(	ConnectionContext ctx,
							String[][] delrqopdata)throws	Exception
	{
		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" DELETE FROM ICOYRQOP            \n");
//		sql.append(" WHERE HOUSE_CODE = ?            \n");
//		sql.append(" AND   RFQ_NO     = ?            \n");
//		sql.append(" AND   RFQ_COUNT  = ?            \n");

		try{

			String[] type =	{ "S","S","N" };
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doInsert(delrqopdata, type);

		}catch(Exception e)	{
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private	int	et_delTBEV(	ConnectionContext ctx,
							String[][] deltbevdata)throws	Exception
	{
		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" DELETE FROM ICOYTBEV            \n");
//		sql.append(" WHERE HOUSE_CODE = ?            \n");
//		sql.append(" AND   DOC_NO     = ?            \n");
//		sql.append(" AND   DOC_SEQ  = ?            	 \n");

		try{

			String[] type =	{ "S","S","N" };
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doInsert(deltbevdata, type);

		}catch(Exception e)	{
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private	int	et_delTBUS(	ConnectionContext ctx,
							String[][] deltbusdata)throws	Exception
	{
		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" DELETE FROM ICOYTBUS            \n");
//		sql.append(" WHERE HOUSE_CODE = ?            \n");
//		sql.append(" AND   DOC_NO     = ?            \n");
//		sql.append(" AND   DOC_SEQ  = ?            	 \n");

		try{

			String[] type =	{ "S","S","N" };
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doInsert(deltbusdata, type);

		}catch(Exception e)	{
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private	int	et_delRQAN(	ConnectionContext ctx,
							String[][] delrqandata)throws	Exception
	{
		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" DELETE FROM ICOYRQAN            \n");
//		sql.append(" WHERE HOUSE_CODE = ?            \n");
//		sql.append(" AND   RFQ_NO     = ?            \n");
//		sql.append(" AND   RFQ_COUNT  = ?            \n");

		try{

			String[] type =	{ "S","S","N" };
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doInsert(delrqandata, type);

		}catch(Exception e)	{
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private	int	et_delPRHD(	ConnectionContext ctx,
							String[][] delprhddata)throws	Exception
	{
		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" DELETE FROM ICOYPRHD            \n");
//		sql.append(" WHERE HOUSE_CODE = ?            \n");
//		sql.append(" AND   PR_NO      = ?            \n");

		try{

			String[] type =	{ "S","S"};
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doInsert(delprhddata, type);

		}catch(Exception e)	{
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private	int	et_delPRDT(	ConnectionContext ctx,
							String[][] delprdtdata)throws	Exception
	{
		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append(" DELETE FROM ICOYPRDT            \n");
//		sql.append(" WHERE HOUSE_CODE = ?            \n");
//		sql.append(" AND   PR_NO      = ?            \n");

		try{

			String[] type =	{ "S","S"};
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doInsert(delprdtdata, type);

		}catch(Exception e)	{
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	public SepoaOut getEvalVendorSelect(String flag, String[] args )
	{
		String lang = info.getSession("LANGUAGE");

		try	{
			String rtn =  et_getEvalVendorSelect( flag, args );

			if(rtn == null)
				throw new Exception("doing select et_getEvalVendorSelect");
			setValue(rtn);

 			setStatus(1);
			setMessage(msg.get("STDCOMM.0000"));
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDCOMM.0001"));
		}
		return getSepoaOut();
	}

	private	String et_getEvalVendorSelect(String flag, String[] args ) throws Exception
	{
		String rtn = null;
		SepoaSQLManager sm =	null;
		ConnectionContext ctx =	getConnectionContext();

		try	{

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("flag", flag.length() > 0);
			wxp.addVar("flag1", flag.length() > 0);
//			StringBuffer tSQL = new StringBuffer();
//			tSQL.append(" SELECT   VENDOR_CODE                                                     \n");
//			tSQL.append("        , dbo.getCompanyNameLoc(HOUSE_CODE, VENDOR_CODE, 'S') AS VENDOR_NAME  \n");
//			tSQL.append("        , ''SCORE  													   \n");
//			if(flag.length() > 0 ) tSQL.append(" FROM ICOYRQSE                                     \n");
//			else tSQL.append(" FROM ICOYQTHD                                                       \n");
//			tSQL.append(" <OPT=F,S> WHERE HOUSE_CODE = ? </OPT>                                    \n");
//			tSQL.append(" <OPT=F,S> AND RFQ_NO = ? </OPT>                                          \n");
//			tSQL.append(" <OPT=F,S> AND RFQ_COUNT = ? </OPT>                                       \n");
//			tSQL.append(" AND STATUS != 'D'                                                        \n");
//			if(flag.length() > 0 ) tSQL.append(" GROUP BY    HOUSE_CODE, VENDOR_CODE               \n");
//			tSQL.append(" ORDER BY 1          													   \n");

			sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect(args);

		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
//
	public SepoaOut getBidEvaluationList(String rfq_no,String rfq_count, String eval_user, String vendor_code)
	{
		String lang = info.getSession("LANGUAGE");
		try{
			String rtn = et_getBidEvaluationList(rfq_no,rfq_count,  eval_user, vendor_code);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.get("STDRFQ.0000"));
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDRFQ.0001"));
		}
		return getSepoaOut();
	}

	private	String et_getBidEvaluationList( String rfq_no, String rfq_count, String eval_user, String vendor_code) throws Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		try{

			if(eval_user.length() > 0 ) {
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
//				sql.append(" SELECT   VENDOR_CODE                                                     	\n");
//				sql.append("        , dbo.getCompanyNameLoc(HOUSE_CODE, VENDOR_CODE, 'S') AS VENDOR_NAME  	\n");
//				sql.append("          ,  SCORE  														\n");
//				sql.append(" FROM  ICOYTBSE           													\n");
//				sql.append(" WHERE   STATUS IN ('C','R')                     							\n");
//				sql.append(" <OPT=S,S>    AND     HOUSE_CODE  = ?  </OPT>        						\n");
//				sql.append(" <OPT=S,S>    AND     DOC_NO      = ?  </OPT>        						\n");
//				sql.append(" <OPT=S,S>    AND     DOC_SEQ   = ?  </OPT>          						\n");
//				sql.append(" <OPT=S,S>    AND TBS_ID  = ?  </OPT>      									\n");
//				sql.append(" ORDER BY  TBE_SEQ  											\n");

				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count, eval_user };
				rtn	= sm.doSelect(data);

	          }else{

	        	  SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
	        	  wxp.addVar("vendor_code", vendor_code.length() > 0 );
//	          	if(vendor_code.length() > 0 ) {
//					sql.append(" SELECT                                          			\n");
//					sql.append("             EV.TBE_FIELD,                             		\n");
//					sql.append("             EV.TBE_SEQ,                                	\n");
//					sql.append("			 EV.WEIGHT                             			\n");
//					sql.append(" FROM    ICOYTBEV EV          								\n");
//					sql.append(" WHERE   EV.STATUS IN ('C','R')                     		\n");
//					sql.append(" <OPT=S,S>    AND     EV.HOUSE_CODE  = ?  </OPT>        	\n");
//					sql.append(" <OPT=S,S>    AND     EV.DOC_NO      = ?  </OPT>        	\n");
//					sql.append(" <OPT=S,S>    AND     EV.DOC_SEQ   = ?  </OPT>          	\n");
//					sql.append(" ORDER BY EV.TBE_SEQ      									\n");
//
//					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
//					String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count };
//					rtn	= sm.doSelect(data);
//	          	}else{
//
//	          		wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
//
//					sql.append(" SELECT                                          					\n");
//					sql.append("    EV.DOC_NO,                                         				\n");
//					sql.append("             EV.DOC_SEQ,                               				\n");
//					sql.append("             EV.TBE_FIELD,                             				\n");
//					sql.append("             EV.TBE_SEQ,                               				\n");
//					sql.append("             EV.WEIGHT                                 				\n");
//					sql.append(" FROM    ICOYTBEV EV, ICOYTBUS US           						\n");
//					sql.append(" WHERE   EV.STATUS IN ('C','R')                     				\n");
//					sql.append(" <OPT=S,S>    AND     EV.HOUSE_CODE  = ?  </OPT>        			\n");
//					sql.append(" <OPT=S,S>    AND     EV.DOC_NO      = ?  </OPT>        			\n");
//					sql.append(" <OPT=S,S>    AND     EV.DOC_SEQ   = ?  </OPT>          			\n");
//					sql.append(" AND EV.HOUSE_CODE = US.HOUSE_CODE   								\n");
//					sql.append(" AND EV.DOC_NO = US.DOC_NO   										\n");
//					sql.append(" AND EV.DOC_SEQ = US.DOC_SEQ    									\n");
//					sql.append(" GROUP BY EV.DOC_NO,EV.DOC_SEQ,EV.TBE_FIELD, EV.TBE_SEQ, EV.WEIGHT	\n");
//					sql.append(" ORDER BY EV.TBE_SEQ      											\n");

					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
					String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count };
					rtn	= sm.doSelect(data);
				}
//		}
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
//
	public SepoaOut getBidEvaluationUserList(String rfq_no,String rfq_count, String re_flag, String vendor_code )
	{
		String lang = info.getSession("LANGUAGE");
		try{
			String rtn = et_getBidEvaluationUserList(rfq_no,rfq_count, re_flag,   vendor_code );
			setValue(rtn);
			setStatus(1);
			setMessage(msg.get("STDRFQ.0000"));
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDRFQ.0001"));
		}
		return getSepoaOut();
	}

	private	String et_getBidEvaluationUserList( String rfq_no, String rfq_count, String re_flag, String vendor_code ) throws Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
	    SepoaSQLManager sm = null;

		try{

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			wxp.addVar("re_flag", re_flag);
		if(re_flag.equals("result")){
//			sql.append("     SELECT                                          		\n");
//			sql.append("                 US.TBS_ID                              	\n");
//			sql.append("                 ,US.TBS_NAME                               \n");
//			sql.append("                 ,SE.SCORE                                	\n");
//			sql.append("     FROM    ICOYTBUS US, ICOYTBSE SE                       \n");
//			sql.append("     WHERE   US.STATUS IN ('C','R')                     	\n");
//			sql.append(" <OPT=S,S>    AND     US.HOUSE_CODE  = ?  </OPT>        	\n");
//			sql.append(" <OPT=S,S>    AND     US.DOC_NO      = ?  </OPT>        	\n");
//			sql.append(" <OPT=S,S>    AND     US.DOC_SEQ   = ?  </OPT>          	\n");
//			sql.append(" <OPT=S,S>    AND     SE.VENDOR_CODE   = ?  </OPT>         	\n");
//			sql.append(" AND US.DOC_NO = SE.DOC_NO      							\n");
//			sql.append(" AND US.DOC_SEQ = SE.DOC_SEQ      							\n");
//			sql.append(" AND US.TBS_ID = SE.TBS_ID      							\n");
//			sql.append(" ORDER BY US.DOC_NO, US.DOC_SEQ, SE.TBE_SEQ, US.TBS_ID  	\n");
			  sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count, vendor_code };
			rtn	= sm.doSelect(data);
		}else
		    wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			wxp.addVar("re_flag", re_flag);
			if(re_flag.equals("view")){
//			sql.append("     SELECT                                          		\n");
//			sql.append("                 US.TBS_ID                              	\n");
//			sql.append("                 ,US.TBS_NAME                               \n");
//			sql.append("                 ,US.TBS_DEPT                               \n");
//			sql.append("                 ,US.TBS_COMPANY                            \n");
//			sql.append("     FROM    ICOYTBUS US                     				\n");
//			sql.append("     WHERE   US.STATUS IN ('C','R')                     	\n");
//			sql.append(" <OPT=S,S>    AND     US.HOUSE_CODE  = ?  </OPT>        	\n");
//			sql.append(" <OPT=S,S>    AND     US.DOC_NO      = ?  </OPT>        	\n");
//			sql.append(" <OPT=S,S>    AND     US.DOC_SEQ   = ?  </OPT>          	\n");
			  sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count };
			rtn	= sm.doSelect(data);
		}else{

			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
//			sql.append("     SELECT                                          		\n");
//			sql.append("                 US.TBS_ID                              	\n");
//			sql.append("                 ,US.TBS_NAME                               \n");
//			sql.append("     FROM    ICOYTBUS US                     				\n");
//			sql.append("     WHERE   US.STATUS IN ('C','R')                     	\n");
//			sql.append(" <OPT=S,S>    AND     US.HOUSE_CODE  = ?  </OPT>        	\n");
//			sql.append(" <OPT=S,S>    AND     US.DOC_NO      = ?  </OPT>        	\n");
//			sql.append(" <OPT=S,S>    AND     US.DOC_SEQ   = ?  </OPT>          	\n");
			  sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count };
			rtn	= sm.doSelect(data);
		 }
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	//public SepoaOut setEvaluation(String rfq_no, String rfq_count, String[][] del_tbevdata, String[][] ins_tbevdata, String[][] upd_tbevdata)
	public SepoaOut setEvaluation(String[][] del_tbevdata, String[][] ins_tbevdata )
	{
		String lang = info.getSession("LANGUAGE");
		try{
			//int rtn = et_setEvaluation( del_tbevdata, ins_tbevdata, upd_tbevdata);
			int rtn = et_setEvaluation(del_tbevdata, ins_tbevdata );

			setValue(String.valueOf(rtn));
			setStatus(1);
			setMessage(msg.get("STDRFQ.0000"));
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDRFQ.0001"));
		}
		return getSepoaOut();
	}

	//private	int et_setEvaluation(String[][] del_tbevdata,  String[][] ins_tbevdata, String[][] upd_tbevdata) throws Exception
	private	int et_setEvaluation( String[][] del_tbevdata, String[][] ins_tbevdata ) throws Exception
	{
		int	rtn	= 0;
      	SepoaSQLManager sm =	null;

   		String user_id        = info.getSession("ID");
		String house_code     = info.getSession("HOUSE_CODE");
		String user_name_loc  = info.getSession("NAME_LOC");
		String user_name_eng  = info.getSession("NAME_ENG");
		String user_dept      = info.getSession("DEPARTMENT");

		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
//			StringBuffer sql = new StringBuffer();
//			sql.append("  DELETE FROM ICOYTBSE   							\n");
//			sql.append("  WHERE   HOUSE_CODE  	= ?                 		\n");
//			sql.append("  AND     DOC_NO      	= ?                  		\n");
//			sql.append("  AND     DOC_SEQ   	= ?                      	\n");
//			sql.append("  AND     VENDOR_CODE   = ?           				\n");
//			sql.append("  AND     TBS_ID   		= ?           				\n");
//
//			StringBuffer ins_sql = new StringBuffer();
//			ins_sql.append("     INSERT INTO ICOYTBSE (                	\n");
//			ins_sql.append("         HOUSE_CODE                         \n");
//			ins_sql.append("         , DOC_NO                           \n");
//			ins_sql.append("         , DOC_SEQ                        	\n");
//			ins_sql.append("         , TBE_SEQ                        	\n");
//			ins_sql.append("         , VENDOR_CODE                    	\n");
//			ins_sql.append("         , SCORE                        	\n");
//			ins_sql.append("         , TBS_ID                        	\n");
//			ins_sql.append("         , STATUS                        	\n");
//            ins_sql.append("         , ADD_USER_ID                      \n");
//            ins_sql.append("         , ADD_DATE                         \n");
//            ins_sql.append("         , ADD_TIME                         \n");
//			ins_sql.append("    ) VALUES ( 								\n");
//			ins_sql.append("    	?                          			\n");
//			ins_sql.append("    	, ?                            		\n");
//			ins_sql.append("    	, ?                           		\n");
//			ins_sql.append("    	, ?                       			\n");
//			ins_sql.append("    	, ?                           		\n");
//			ins_sql.append("    	, ?                                 \n");
//			ins_sql.append("    	, ?                                 \n");
//			ins_sql.append("    	, 'C'                               \n");
//            ins_sql.append("        , '"+user_id+"'                     \n");  // ADD_USER_ID
//            ins_sql.append("        , convert(varchar, getdate(), 112)      \n");  // ADD_DATE
//            ins_sql.append("        , replace(convert(varchar, getdate(), 108), ':', '')    )  \n");  // ADD_TIME
//            //ins_sql.append("        , TO_CHAR(SYSDATE, 'YYYYMMDD')      \n");  // ADD_DATE
//            //ins_sql.append("        , TO_CHAR(SYSDATE, 'HH24MISS')    )  \n");  // ADD_TIME
//
//			StringBuffer upd_sql = new StringBuffer();
//			upd_sql.append("    UPDATE ICOYTBUS SET                   	\n");
//			upd_sql.append("            TBS_YN		=      'Y'          \n");
//			upd_sql.append("    WHERE   HOUSE_CODE	= ?         		\n");
//			upd_sql.append("    AND     DOC_NO      = ?         		\n");
//			upd_sql.append("    AND     DOC_SEQ   	= ?           		\n");
//			upd_sql.append("    AND     TBS_ID 		= ?               	\n");

		try{

					sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
					String[] type_sql =	{"S", "S", "S", "S", "S" };
					int sel_rtn	= sm.doDelete(del_tbevdata, type_sql );

					 wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
					wxp.addVar("user_id", user_id);
					sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
					String[] type_ins =	{"S","S","N","S","S","S","S"};
					rtn = sm.doInsert(ins_tbevdata,type_ins);

					String[][] up_data  = new String[1][4];

			    	up_data[0][0] = del_tbevdata[0][0];
			    	up_data[0][1] = del_tbevdata[0][1];
			    	up_data[0][2] = del_tbevdata[0][2];
			    	up_data[0][3] = del_tbevdata[0][4];

			    	 wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
					sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
					String[] type_upd =	{"S", "S", "S", "S" };
					rtn = sm.doUpdate(up_data,type_upd);

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	public SepoaOut getBidBiddingRlt(String[] args)
	{
		String lang = info.getSession("LANGUAGE");

		try
		{
			String rtn = et_getBidBiddingRlt(args);
			setValue(rtn);

			setStatus(1);
			setMessage(msg.get("STDRFQ.0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDRFQ.0001"));
		}
		return getSepoaOut();
	}

 	private	String et_getBidBiddingRlt(String[] args) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();


		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer tSQL = new StringBuffer();
		String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");
//		tSQL.append(" SELECT  DISTINCT																	\n");
//		tSQL.append("	RQHD.RFQ_NO                                                             		\n");
//		tSQL.append("	, RQHD.RFQ_COUNT                                                        		\n");
//		tSQL.append("	, RQHD.SUBJECT                                                          		\n");
//		tSQL.append("	, RQHD.RFQ_DATE                                                         		\n");
//		tSQL.append("	, (SELECT MAX(ADD_DATE) FROM ICOYTBSE WHERE HOUSE_CODE = RQHD.HOUSE_CODE 		\n");
//		tSQL.append("			AND DOC_NO = RQHD.RFQ_NO AND DOC_SEQ = RQHD.RFQ_COUNT ) AS EVAL_DATE	\n");
//		tSQL.append("	, QTDT.VENDOR_CODE                                                      		\n");
//		tSQL.append(" 	, dbo.GETVENDORNAME(QTDT.HOUSE_CODE, QTDT.VENDOR_CODE) AS VENDOR_NAME       	\n");
//		tSQL.append(" 	, CASE WHEN QTDT.SETTLE_FLAG = 'Y' THEN 'Y' ELSE 'N' END AS SETTLE_FLAG  		\n");
//		tSQL.append(" 	, QTDT.SETTLE_REMARK                                                    		\n");
//		tSQL.append(" 	, QTDT.QTA_NO                                                           		\n");
//		tSQL.append(" 	, RQHD.BID_TECHNIQUE_EVAL                                               		\n");
//		tSQL.append(" 	, RQHD.BID_PRICE_EVAL                                                   		\n");
//		tSQL.append(" 	, CASE WHEN RQHD.BID_TECHNIQUE_EVAL = 0 THEN 0               		            \n");
// 		tSQL.append(" 	ELSE ROUND(dbo.getTechnique_Price_Eval(QTDT.HOUSE_CODE, QTDT.RFQ_NO, QTDT.RFQ_COUNT, RQHD.BID_TECHNIQUE_EVAL			\n");
//		tSQL.append(" 								,(SELECT SUM(SCORE) AS SCORE FROM ICOYTBSE											\n");
// 	 	tSQL.append(" 	   								WHERE HOUSE_CODE = QTDT.HOUSE_CODE AND DOC_NO = QTDT.RFQ_NO 					\n");
// 	    tSQL.append(" 	   								AND DOC_SEQ = QTDT.RFQ_COUNT AND VENDOR_CODE = QTDT.VENDOR_CODE )				\n");
//		tSQL.append(" 	   								/ (SELECT COUNT(*) FROM ICOYTBUS		\n");
//        tSQL.append(" 	   								                WHERE HOUSE_CODE = QTHD.HOUSE_CODE		\n");
//        tSQL.append(" 	   								                 AND DOC_NO = QTHD.RFQ_NO AND DOC_SEQ = QTHD.RFQ_COUNT)		\n");
//		tSQL.append(" 	  							, 'T', QTDT.VENDOR_CODE),1) END AS SCORE_EVAL														\n");
//		tSQL.append(" 	, ROUND(dbo.getTechnique_Price_Eval(QTDT.HOUSE_CODE, QTDT.RFQ_NO, QTDT.RFQ_COUNT, RQHD.BID_PRICE_EVAL,QTHD.TTL_AMT, 'P',QTDT.VENDOR_CODE),1) AS PRICE_EVAL	\n");
//		tSQL.append(" 	, RQDT.CUR                                                              		\n");
//		tSQL.append(" 	, CAST(ROUND(QTHD.TTL_AMT,1) AS DEC(22,0) )      AS TTL_AMT                     \n");
//		tSQL.append(" 	, RQHD.SIGN_STATUS                                                      		\n");
//		tSQL.append(" 	, dbo.GETICOMCODE2(RQHD.HOUSE_CODE,'M100', RQHD.SIGN_STATUS) AS SIGN_STATUS_TEXT	\n");
//		tSQL.append(" 	, RQDT.AUTO_PO_FLAG																\n");
//		tSQL.append(" 	, RQDT.CONTRACT_FLAG															\n");
//		tSQL.append(" 	, dbo.GETPURCHASELOCATIONINFO(RQDT.HOUSE_CODE, RQDT.RFQ_NO, RQDT.RFQ_COUNT, RQDT.RFQ_SEQ, QTHD.VENDOR_CODE) AS PURCHASE_LOCATION	\n");
//		tSQL.append(" 	, ''MOLDING_TYPE																\n");
//		tSQL.append("   , RQDT.PR_NO																	\n");
//		tSQL.append(" FROM ICOYQTHD QTHD,ICOYQTDT QTDT, ICOYRQDT RQDT, ICOYRQHD RQHD            		\n");
//		tSQL.append(" <OPT=F,S> WHERE QTDT.HOUSE_CODE = ? </OPT>                                		\n");
//		tSQL.append(" <OPT=F,S> AND RQHD.RFQ_DATE BETWEEN ? </OPT>                                      \n");
//		tSQL.append(" <OPT=F,S> AND ?                  </OPT>                                           \n");
//		tSQL.append(" <OPT=S,S> AND RQHD.ADD_USER_ID   =  ?  </OPT>                                     \n");
//		tSQL.append(" <OPT=S,S> AND QTDT.RFQ_NO    = ?    </OPT>                                		\n");
//		tSQL.append(" <OPT=S,S> AND RQHD.SUBJECT LIKE '%'+?+'%' </OPT>                             		\n");
//		tSQL.append(" <OPT=S,S> AND (CASE WHEN QTDT.SETTLE_FLAG = 'Y' THEN 'Y' ELSE 'N' END)   =  ?  </OPT>            \n");
//		tSQL.append(" <OPT=S,S> AND RQHD.SIGN_STATUS   =  ?  </OPT>                                     \n");
//		tSQL.append(" AND QTHD.HOUSE_CODE = QTDT.HOUSE_CODE                                     		\n");
//		tSQL.append(" AND QTHD.VENDOR_CODE = QTDT.VENDOR_CODE                                   		\n");
//		tSQL.append(" AND QTHD.QTA_NO = QTDT.QTA_NO                                             		\n");
//		tSQL.append(" AND QTDT.RFQ_NO = QTDT.RFQ_NO                                             		\n");
//		tSQL.append(" AND QTHD.RFQ_COUNT = QTDT.RFQ_COUNT                                       		\n");
//		tSQL.append(" AND QTDT.HOUSE_CODE = RQDT.HOUSE_CODE                                     		\n");
//		tSQL.append(" AND QTDT.RFQ_NO = RQDT.RFQ_NO                                             		\n");
//		tSQL.append(" AND QTDT.RFQ_COUNT = RQDT.RFQ_COUNT                                       		\n");
//		tSQL.append(" AND QTDT.RFQ_SEQ = RQDT.RFQ_SEQ                                           		\n");
//		tSQL.append(" AND RQDT.HOUSE_CODE = RQHD.HOUSE_CODE                                     		\n");
//		tSQL.append(" AND RQDT.RFQ_NO = RQHD.RFQ_NO                                             		\n");
//		tSQL.append(" AND RQDT.RFQ_COUNT = RQHD.RFQ_COUNT                                       		\n");
//		//tSQL.append(" AND RQHD.RFQ_FLAG ='C'                                                    		\n");
//		tSQL.append(" AND RQHD.BID_TYPE = 'EX'                                                  		\n");
//		tSQL.append(" AND QTHD.STATUS != 'D'                                                    		\n");
//		tSQL.append(" AND QTDT.STATUS != 'D'                                                    		\n");
//		tSQL.append(" AND RQDT.STATUS != 'D'                                                    		\n");
//		tSQL.append(" AND RQHD.STATUS != 'D'                                                    		\n");
//		tSQL.append(" ORDER BY 1  DESC                                                 					\n");

		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn	= sm.doSelect(args);
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
//
	public SepoaOut setBidDocTotalSave( String[][] rqdtData
									, String[][] rqdtData_res
									, String[][] delrqopdata
									, String[][] rqopdata
									, String[][] qtdtData
									, String     rfq_no
									, String     rfq_count
									)
	{
		String lang	  =	info.getSession("LANGUAGE");
		try
		{
			int	rtn	= 0;
			ConnectionContext ctx =	getConnectionContext();

			et_setItemDetail_RQDT(ctx, rqdtData, rqdtData_res);
			//et_delRQOP_bid(ctx, delrqopdata);
			//et_setRfqOPCreate_bid(ctx, rqopdata);

			et_setItemDetail_QTDT(ctx, qtdtData);
			et_setItemRQHD_FlagUPDATE(ctx, rfq_no, rfq_count);

			//2010-03-19  입찰요청 업체선정시 품의대기 현황에 보일수 있도록 수정
			updatePR_PROCEEDING_FLAG(rfq_no);

			setStatus(1);
			setValue(String.valueOf(rtn));
			setMessage(msg.get("STDQTA.0009"));

			Commit();
			//Rollback();
		} catch(Exception e) {
			try{
			    Rollback();
			} catch (Exception d) {
			    //Logger.err.println(info.getSession("ID"),this,"ERROR========>"+stackTrace(d));
				Logger.err.println(info.getSession("ID"),this,d.getMessage());
			}

			setStatus(0);
			setMessage(msg.get("STDQTA.0010"));
		}
		return getSepoaOut();

	}

	private void updatePR_PROCEEDING_FLAG(String rfq_no) throws Exception
    {
    	int rtn = 0;
        ConnectionContext ctx 	= getConnectionContext();
        String lang            	=  info.getSession("LANGUAGE");

        String add_user_id  = info.getSession("ID");

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("rfq_no", rfq_no);
        /*
        StringBuffer tSQL = new StringBuffer();
        tSQL.append("		UPDATE ICOYPRDT SET      							  							           	\n");
        tSQL.append("		CHANGE_DATE = CONVERT(VARCHAR, GETDATE(),112)    	                \n");
        tSQL.append("		, CHANGE_TIME = REPLACE(CONVERT(CHAR(8),GETDATE(),108),':','')    \n");
        tSQL.append("		, PR_PROCEEDING_FLAG = 'E' 						                            \n");
        tSQL.append("		WHERE (HOUSE_CODE + PR_NO + PR_SEQ )                              \n");
        tSQL.append("		IN          					                                            \n");
        tSQL.append("		( SELECT HOUSE_CODE + PR_NO + PR_SEQ                              \n");
        tSQL.append("		FROM ICOYRQDT WHERE RFQ_NO = '"+rfq_no+"'	)	                      \n");
        */

    	SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx, wxp.getQuery());
        rtn = sm.doDelete();

        if(rtn<1)
        	throw new Exception(msg.get("STDRFQ.0004"));


    }

//
	private	int	et_setItemDetail_RQDT(	ConnectionContext ctx,
							            String[][] rqdtData,
							            String[][] rqdtData_res)throws	Exception
	{
		int	rtn	= 0;

		try{

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
//			StringBuffer sql = new StringBuffer();

//			sql.append(" UPDATE	ICOYRQDT						\n");
//			sql.append(" SET AUTO_PO_FLAG			= ?,	    \n");
//			sql.append("	 CONTRACT_FLAG		    = ?,	    \n");
//			sql.append("	 SETTLE_FLAG		    = 'Y',		\n");
//			sql.append("	 SET_FLAG		    = 'Y',		\n");//우선협상선정여
//			sql.append("	 RFQ_PROCEEDING_FLAG	= 'Y'		\n");
//			sql.append(" WHERE	HOUSE_CODE = ?                  \n");
//			sql.append(" AND	RFQ_NO	   = ?                  \n");
//			sql.append(" AND	RFQ_COUNT  = ?                  \n");

			String[] type =	{ "S", "S", "S", "S", "N"};
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doInsert(rqdtData, type);

			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
//			sql = new StringBuffer();

//			sql.append(" UPDATE ICOYRQDT					\n");
//			sql.append(" SET    SETTLE_FLAG         = 'D',	\n");
//			sql.append("        RFQ_PROCEEDING_FLAG = 'D'	\n");
//			sql.append(" WHERE  HOUSE_CODE  = ?             \n");
//			sql.append(" AND    RFQ_NO      = ?             \n");
//			sql.append(" AND    RFQ_COUNT   = ?             \n");
//			sql.append(" AND    SETTLE_FLAG = 'N'			\n");

			String[] type_res =	{ "S", "S", "N"};
			sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doInsert(rqdtData_res, type_res);

		}catch(Exception e)	{
			//Logger.err.println(info.getSession("ID"),this,stackTrace(e));
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
//
//	private	int	et_delRQOP_bid(	ConnectionContext ctx,
//							String[][] delrqopdata)throws	Exception
//	{
//		int	rtn	= 0;
//
//		StringBuffer sql = new StringBuffer();
//
//		sql.append(" DELETE FROM ICOYRQOP               \n");
//		sql.append(" WHERE HOUSE_CODE    = ?            \n");
//		sql.append(" AND   RFQ_NO        = ?            \n");
//		sql.append(" AND   RFQ_COUNT     = ?            \n");
//		sql.append(" AND   VENDOR_CODE	 = ?            \n");
//
//		try{
//
//			String[] type =	{ "S","S","N", "S" };
//			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
//			rtn	= sm.doInsert(delrqopdata, type);
//
//		}catch(Exception e)	{
//			//Logger.err.println(info.getSession("ID"),this,stackTrace(e));
//			throw new Exception(e.getMessage());
//		}
//		return rtn;
//	}
//
//	private	int	et_setRfqOPCreate_bid(ConnectionContext	ctx,
//									String[][] rqopdata) throws Exception
//	{
//
//		int	rtn	= 0;
//		String house_code = info.getSession("HOUSE_CODE");
//		StringBuffer sql = new StringBuffer();
//
//		sql.append(" INSERT INTO ICOYRQOP (       \n");
//		sql.append(" 		 HOUSE_CODE           \n");
//		sql.append(" 		,RFQ_NO               \n");
//		sql.append(" 		,RFQ_COUNT            \n");
//		sql.append(" 		,RFQ_SEQ              \n");
//		sql.append(" 		,PURCHASE_LOCATION    \n");
//		sql.append(" 		,PURCHASE_LEVEL       \n");
//		sql.append(" 		,VENDOR_CODE          \n");
//		sql.append(" 		,STATUS               \n");
//		sql.append(" 		,ADD_USER_ID          \n");
//		sql.append(" 		,ADD_DATE             \n");
//		sql.append(" 		,ADD_TIME             \n");
//		sql.append(" 		,CHANGE_DATE          \n");
//		sql.append(" 		,CHANGE_TIME          \n");
//		sql.append(" 		,CHANGE_USER_ID       \n");
//		sql.append(" ) VALUES (                   \n");
//		sql.append(" 		 ?                    \n");      		// HOUSE_CODE
//		sql.append(" 		,?                    \n");      		// RFQ_NO
//		sql.append(" 		,?                    \n");      		// RFQ_COUNT
//		sql.append(" 		,TO_CHAR(?,'FM000000')    		\n");      	// RFQ_SEQ
//		sql.append(" 		,?                    			\n");      		// PURCHASE_LOCATION
//		sql.append(" , GETPURCHASELEVEL('"+house_code+"',?)	\n");	//PURCHASE_LEVEL
//    	sql.append(" 		,?                    \n");      // VENDOR_CODE
//		sql.append(" 		,?                    \n");      // STATUS
//		sql.append(" 		,?                    \n");      // ADD_USER_ID
//		sql.append(" 		,?                    \n");      // ADD_DATE
//		sql.append(" 		,?                    \n");      // ADD_TIME
//		sql.append(" 		,?                    \n");      // CHANGE_DATE
//		sql.append(" 		,?                    \n");      // CHANGE_TIME
//		sql.append(" 		,?                    \n");      // CHANGE_USER_ID
//		sql.append(" )                            \n");
//
//		try	{
//			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
//			String[] type =	{"S","S","N","S","S"
//							,"S","S","S","S","S"
//							,"S","S","S","S"};
//			rtn	= sm.doInsert(rqopdata,type);
//			Logger.debug.println(info.getSession("ID"),this, "rtn==//"+rtn+"//");
//		} catch(Exception e) {
//			Logger.err.println(info.getSession("ID"),this,e.getMessage());
//			throw new Exception(e.getMessage());
//		}
//		return rtn;
//	}
//
	private	int	et_setItemDetail_QTDT(	ConnectionContext ctx,
							            String[][] qtdtData)throws	Exception
	{
		int	rtn	= 0;


		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//		sql.append(" UPDATE	ICOYQTDT                                   	\n");
//		sql.append(" SET     QUOTA_PERCENT	= ?                        	\n");
//		sql.append("	    ,SETTLE_QTY		= ITEM_QTY * (? / 100)     	\n");
//		sql.append("	    ,SETTLE_DATE    = ?                        	\n");
//		sql.append("	    ,SETTLE_FLAG    = ?                      	\n");
//		sql.append("	    ,MOLDING_TYPE   = ?                        	\n");
//		sql.append("        ,SETTLE_REMARK = ?                      	\n");
//		sql.append(" WHERE	HOUSE_CODE	= ? 							\n");
//		sql.append(" AND	RFQ_NO		= ? 							\n");
//		sql.append(" AND	RFQ_COUNT	= ? 							\n");
//		sql.append(" AND	VENDOR_CODE	= ? 							\n");

		try{

			String[] type =	{ "N", "N", "S", "S", "S", "S",
							  "N", "S", "S", "S"  };
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doInsert(qtdtData, type);

		}catch(Exception e)	{
			//Logger.err.println(info.getSession("ID"),this,stackTrace(e));
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
//
	private	int	et_setItemRQHD_FlagUPDATE(	ConnectionContext ctx,
											String rfq_no,
											String rfq_count)	throws Exception
	{
		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer sql = new StringBuffer();

//		sql.append("	UPDATE ICOYRQHD	                                    \n");
//		sql.append("	SET	  RFQ_FLAG   = 'C'								\n");
//		sql.append("	WHERE HOUSE_CODE = ?                                \n");
//		sql.append("	 AND  RFQ_NO     = ?                                \n");
//		sql.append("	 AND  RFQ_COUNT	 = ?                                \n");
//		sql.append("	 AND  (	SELECT										\n");
//		sql.append("				COUNT(*)								\n");
//		sql.append("			FROM ICOYRQDT								\n");
//		sql.append("			WHERE	 HOUSE_CODE	  =	 ?                  \n");
//		sql.append("				AND	 SETTLE_FLAG  NOT IN  ('D','Y')		\n");
//		sql.append("				AND	 RFQ_NO		  =	 ?                  \n");
//		sql.append("				AND	 RFQ_COUNT	  =	 ?                  \n");
//		sql.append("		  )	 =	0						                \n");

		try{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			String[][] setData = {{info.getSession("ID"), info.getSession("HOUSE_CODE"), rfq_no, rfq_count,
								  info.getSession("HOUSE_CODE"), rfq_no, rfq_count}};

			String[] type =	{ "S", "S", "S", "N", "S", "S",
							  "N" };

			rtn	= sm.doUpdate(setData, type);

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,"ERROR==========>"+e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

//	//청구복구(DOC ALL)
//	public SepoaOut setReturnToPR_DOC_ALL(String[][]	rqdtData
//										, String[][] rqhdData
//										, String[][] prdt_data)
//	{
//		String lang	  =	info.getSession("LANGUAGE");
//		Message msg = new Message("STDQTA");
//		try
//		{
//			int	rtn	= et_setReturnToPR_DOC_ALL(rqdtData, rqhdData, prdt_data);
//			setStatus(1);
//			setValue(String.valueOf(rtn));
//			setMessage(msg.getMessage("0013"));
//			Commit();
//
//		}catch(Exception e)	{
//			try{Rollback();}catch(Exception	d){Logger.err.println(info.getSession("ID"),this,d.getMessage());}
//			Logger.err.println(info.getSession("ID"),this,e.getMessage());
//			setStatus(0);
//			setMessage(msg.getMessage("0012"));
//		}
//		return getSepoaOut();
//	}
//
//	private	int	et_setReturnToPR_DOC_ALL(String[][]	rqdtData
//										, String[][] rqhdData
//										, String[][] prdt_data) throws Exception
//	{
//
//		int	rtn	= 0;
//
//		ConnectionContext ctx =	getConnectionContext();
//
//		StringBuffer sqldt = new StringBuffer();
//
//		sqldt.append(" UPDATE ICOYRQDT                          \n");
//		sqldt.append(" SET  SETTLE_FLAG            = 'D',       \n");
//		sqldt.append("      RFQ_PROCEEDING_FLAG    = 'D'        \n");
//		sqldt.append(" WHERE    HOUSE_CODE = ?                  \n");
//		sqldt.append(" AND      RFQ_NO     = ?                  \n");
//		sqldt.append(" AND      RFQ_COUNT  = ?                  \n");
//
//		StringBuffer sqlhd = new StringBuffer();
//
//		sqlhd.append("     UPDATE ICOYRQHD             \n");
//		sqlhd.append("     SET    RFQ_FLAG    = 'C'    \n");
//		sqlhd.append("     WHERE  HOUSE_CODE  = ?      \n");
//		sqlhd.append("     AND    RFQ_NO      = ?      \n");
//		sqlhd.append("     AND    RFQ_COUNT   = ?      \n");
//
//		StringBuffer sqlpr = new StringBuffer();
//
//		sqlpr.append(" UPDATE ICOYPRDT                       \n");
//		sqlpr.append(" SET    PR_PROCEEDING_FLAG  = 'P'      \n");
//		sqlpr.append(" WHERE  HOUSE_CODE  = ?                \n");
//		sqlpr.append(" AND    PR_NO       = ?                \n");
//
//		try{
//			SepoaSQLManager smdt	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sqldt.toString());
//			String[] type_rqdt = {"S", "S", "N"};
//			rtn	= smdt.doUpdate(rqdtData, type_rqdt);
//
//			SepoaSQLManager smhd	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sqlhd.toString());
//			String[] type_rqhd = {"S", "S", "N"};
//			rtn	= smhd.doUpdate(rqhdData, type_rqhd);
//
//			SepoaSQLManager smpr	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sqlpr.toString());
//			String[] type_prdt =	{"S","S" };
//			rtn	= smpr.doUpdate(prdt_data, type_prdt);
//		}catch(Exception e)	{
//			Logger.err.println(info.getSession("ID"),this,e.getMessage());
//			throw new Exception(e.getMessage());
//		}
//		return rtn;
//	}
//
//	//청구복구(DOC ALL)
	public SepoaOut setReturnToSettle(String[][]	rqdtData, String[][] qtdtData )
	{
		String lang	  =	info.getSession("LANGUAGE");
		try
		{
			int	rtn	= et_setReturnToSettle(rqdtData,qtdtData);
			et_setReturnToSettle_pr(rqdtData);
			setStatus(1);
			setValue(String.valueOf(rtn));
			setMessage(msg.get("STDQTA.0013"));
			Commit();

		}catch(Exception e)	{
			try{Rollback();}catch(Exception	d){Logger.err.println(info.getSession("ID"),this,d.getMessage());}
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDQTA.0012"));
		}
		return getSepoaOut();
	}

	private	int	et_setReturnToSettle(String[][]	rqdtData, String[][] qtdtData) throws Exception
	{

		int	rtn	= 0;

		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
//		StringBuffer sqldt = new StringBuffer();

//		sqldt.append(" UPDATE ICOYRQDT                          \n");
//		sqldt.append(" SET  SETTLE_FLAG            = 'D',       \n");
//		sqldt.append(" 		SET_FLAG               = NULL,      \n");
//		sqldt.append("      RFQ_PROCEEDING_FLAG    = 'D'        \n");
//		sqldt.append(" WHERE    HOUSE_CODE = ?                  \n");
//		sqldt.append(" AND      RFQ_NO     = ?                  \n");
//		sqldt.append(" AND      RFQ_COUNT  = ?                  \n");


//		StringBuffer sqlqt = new StringBuffer();

//		sqlqt.append(" UPDATE ICOYQTDT                          \n");
//		sqlqt.append(" SET  SETTLE_FLAG            = NULL        \n");
//		sqlqt.append(" WHERE    HOUSE_CODE = ?                  \n");
//		sqlqt.append(" AND      QTA_NO     = ?                  \n");

		try{
			SepoaSQLManager smdt	= new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type_rqdt = {"S", "S", "N"};
			rtn	= smdt.doUpdate(rqdtData, type_rqdt);
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			smdt	= new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type_qtdt = {"S", "S" };
			rtn	= smdt.doUpdate(qtdtData, type_qtdt);

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}


	/**
	 * 2010.03.19
	 * PR_PROCEEDING_FLAG를 원래상태로 돌려 놓아 품의대기현황에서 안보이게 한다.
	 */
	private void et_setReturnToSettle_pr(String[][]	rqdtData) throws Exception
    {
    	int rtn = 0;
        ConnectionContext ctx 	= getConnectionContext();
        String lang            	=  info.getSession("LANGUAGE");

        String add_user_id  = info.getSession("ID");
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        /*
        StringBuffer tSQL = new StringBuffer();

        tSQL.append("		UPDATE ICOYPRDT SET      							  							           	\n");
        tSQL.append("		CHANGE_DATE = CONVERT(VARCHAR, GETDATE(),112)    	                \n");
        tSQL.append("		, CHANGE_TIME = REPLACE(CONVERT(CHAR(8),GETDATE(),108),':','')    \n");
        tSQL.append("		, PR_PROCEEDING_FLAG = 'C' 						                            \n");
        tSQL.append("		WHERE (HOUSE_CODE + PR_NO + PR_SEQ )                              \n");
        tSQL.append("		IN          					                                            \n");
        tSQL.append("		( SELECT HOUSE_CODE + PR_NO + PR_SEQ                              \n");
        tSQL.append("		FROM ICOYRQDT                        \n");
        tSQL.append(" WHERE    HOUSE_CODE = ?                  \n");
        tSQL.append(" AND      RFQ_NO     = ?                  \n");
        tSQL.append(" AND      RFQ_COUNT  = ?       )           \n");
        */

    	SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx, wxp.getQuery());
        String[] type_rqdt = {"S", "S", "N"};
		rtn	= sm.doUpdate(rqdtData, type_rqdt);
        if(rtn<1)
        	throw new Exception(msg.get("STDRFQ.0004"));


    }

	public SepoaOut getReqBidRlt(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		
        try{
        	setStatus(1);
			setFlag(true);
			
        	ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "et_getReqBidRlt");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);

        	rtn = ssm.doSelect(header);
        	
            setValue(rtn);
            setMessage(msg.get("0000"));
        }
        catch(Exception e){
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.get("0001"));
        }

        return getSepoaOut();
	}
	
	public SepoaOut getReqIORlt(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "et_getReqIORlt");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			
			rtn = ssm.doSelect(header);
			
			setValue(rtn);
			setMessage(msg.get("0000"));
		}
		catch(Exception e){
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.get("0001"));
		}
		
		return getSepoaOut();
	}

    public SepoaOut getQuery_Dis_Qta_Detail(String[] args)
    {
        String rtn = "";

		String lang = info.getSession("LANGUAGE");

        ConnectionContext ctx = getConnectionContext();

        try {

            StringBuffer sql = new StringBuffer();

			sql.append(" SELECT                                        													\n");
			sql.append("  	DT.RFQ_SEQ                                   												\n");
			sql.append(" 	, DT.ITEM_NO                                  												\n");
			sql.append(" 	, CASE WHEN DT.ITEM_NO IS NULL																\n");
			sql.append(" 	THEN (SELECT DESCRIPTION_LOC FROM ICOYPRDT WHERE HOUSE_CODE = DT.HOUSE_CODE AND PR_NO = DT.PR_NO AND PR_SEQ = DT.PR_SEQ)			\n");
			sql.append(" 	ELSE dbo.getItemDesc(DT.HOUSE_CODE, DT.ITEM_NO) END AS DESCRIPTION_LOC							\n");
			sql.append("    , (SELECT SPECIFICATION FROM ICOYPRDT WHERE HOUSE_CODE = DT.HOUSE_CODE AND PR_NO = DT.PR_NO AND PR_SEQ = DT.PR_SEQ) AS SPECIFICATION	\n");
			sql.append("    , (SELECT MAKER_NAME FROM ICOYPRDT WHERE HOUSE_CODE = DT.HOUSE_CODE AND PR_NO = DT.PR_NO AND PR_SEQ = DT.PR_SEQ) AS MAKER_NAME	\n");
			sql.append(" 	, DT.UNIT_MEASURE                             												\n");
			sql.append(" 	, QT.UNIT_PRICE         																	\n");
			sql.append(" 	, DT.RFQ_QTY                                  												\n");
			sql.append(" 	, DT.RFQ_AMT                                  												\n");
			sql.append(" 	, DT.CUR                                      												\n");
			sql.append(" 	, DT.PR_NO                                    												\n");
			sql.append(" 	, DT.PR_SEQ                                   												\n");
			sql.append(" 	, DT.Z_REMARK                                   											\n");
			sql.append(" 	, DT.ATTACH_NO AS RFQ_ATTACH_NO                               								\n");
			sql.append(" 	, (SELECT COUNT(*) FROM ICOMATCH   WHERE DOC_NO = DT.ATTACH_NO)	AS RFQ_ATTACH_COUNT			\n");
			sql.append(" 	, DT.PLANT_CODE                                            									\n");
			sql.append("    , DT.DELY_TO_LOCATION                                     									\n");
			sql.append("    , (SELECT PURCHASE_LOCATION FROM ICOYPRDT              										\n");
			sql.append("   		 WHERE  HOUSE_CODE = DT.HOUSE_CODE                      								\n");
			sql.append("   		 AND    PR_NO      = DT.PR_NO                           								\n");
			sql.append("   		 AND    PR_SEQ     = DT.PR_SEQ) AS PURCHASE_LOCATION    								\n");
			sql.append("    , HD.CTRL_CODE                                          									\n");
			sql.append("    , DT.DELY_TO_ADDRESS                                      									\n");
			sql.append("    ,(CASE                                                 										\n");
			sql.append("     	 		 WHEN DT.STR_FLAG = 'S' THEN dbo.GETSTORAGENAME(DT.HOUSE_CODE, DT.COMPANY_CODE, DT.PLANT_CODE, DT.DELY_TO_LOCATION, 'LOC' ) \n");
			sql.append("     	 		 WHEN DT.STR_FLAG = 'D' THEN dbo.GETDEPTNAME(DT.HOUSE_CODE, DT.COMPANY_CODE, DT.DELY_TO_LOCATION, 'LOC' ) 					\n");
			sql.append("     	 		 ELSE DT.DELY_TO_LOCATION                       								\n");
			sql.append("	      END                                                  									\n");
			sql.append(" 	  ) AS DELY_TO_LOCATION_NAME                           										\n");
			sql.append("    , QT.CUSTOMER_PRICE	 																		\n");
			sql.append("    , QT.DISCOUNT	 																			\n");
			sql.append("    , QT.ATTACH_NO               AS QTA_ATTACH_NO	 											\n");
			sql.append("    , (SELECT COUNT(*) FROM ICOMATCH   WHERE DOC_NO = QT.ATTACH_NO)	AS QTA_ATTACH_COUNT	 		\n");
			sql.append("    , QT.QTA_NO	 																				\n");
			sql.append("    , QT.QTA_SEQ	 																			\n");
			sql.append("    , (SELECT COUNT(*) FROM ICOYQTEP WHERE HOUSE_CODE = QT.HOUSE_CODE AND QTA_NO = QT.QTA_NO AND QTA_SEQ = QT.QTA_SEQ		\n");
			sql.append("        AND VENDOR_CODE = RS.VENDOR_CODE) AS QTEP_CNT											\n");
			sql.append(" FROM ICOYQTDT QT, ICOYRQSE RS, ICOYRQDT DT, ICOYRQHD HD  								 		\n");
			sql.append(" <OPT=F,S> WHERE QT.HOUSE_CODE = ? </OPT>      													\n");
			sql.append(" <OPT=F,S> AND QT.RFQ_NO = ?       </OPT>      													\n");
			sql.append(" <OPT=F,S> AND QT.RFQ_COUNT = ?    </OPT>      													\n");
			sql.append(" <OPT=F,S> AND QT.VENDOR_CODE =   ?    </OPT>      	      			 							\n");
			sql.append(" AND QT.HOUSE_CODE =  RS.HOUSE_CODE																\n");
			sql.append(" AND QT.RFQ_NO = RS.RFQ_NO    																	\n");
			sql.append(" AND QT.RFQ_COUNT =  RS.RFQ_COUNT																\n");
			sql.append(" AND QT.RFQ_SEQ = RS.RFQ_SEQ																	\n");
			sql.append(" AND QT.VENDOR_CODE = RS.VENDOR_CODE															\n");
			sql.append(" AND RS.HOUSE_CODE =  DT.HOUSE_CODE																\n");
			sql.append(" AND RS.RFQ_NO = DT.RFQ_NO    																	\n");
			sql.append(" AND RS.RFQ_COUNT =  DT.RFQ_COUNT																\n");
			sql.append(" AND RS.RFQ_SEQ = DT.RFQ_SEQ																	\n");
			sql.append(" AND DT.STATUS != 'D'                          													\n");
			sql.append(" AND HD.RFQ_NO = DT.RFQ_NO                     													\n");
			sql.append(" AND HD.RFQ_COUNT = DT.RFQ_COUNT               													\n");
			sql.append(" AND HD.STATUS != 'D'                          													\n");

            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());

            rtn = sm.doSelect(args);

            setValue(rtn);
            setStatus(1);
			SepoaFormater wf = new SepoaFormater(rtn);
			if(wf.getRowCount() == 0) setMessage(msg.get("STDCOMM.0008"));
			else {
				setMessage(msg.get("STDCOMM.0000"));
			}
        }catch (Exception e){
           // Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + stackTrace(e));
            setStatus(0);
        }
        return getSepoaOut();
    }

	/**
	 * 단가테이블 정보를 레벨별로 삭제한다.
	 * <pre>
	 *
	 * DELETE ICOYINFO, ICOYINDR
	 * 레벨별 삭제 로직
	 * RQOP.PURCHASE_LEVEL
	 * '1'이라면 통합구매를 의미한다.
	 * 기존 ICOYINFO 에 해당하는 자재는 모두 삭제된다.
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
//		StringBuffer sql = new StringBuffer();
		/* sql.append(" SELECT                                      	\n");
		sql.append(" 	  QTDT.ITEM_NO                           	\n");
		sql.append(" 	, QTDT.COMPANY_CODE                      	\n");
		sql.append(" 	, QTDT.VENDOR_CODE                       	\n");
		//sql.append(" 	, nvl(QTDT.PURCHASE_LOCATION,rqop.PURCHASE_LOCATION)as PURCHASE_LOCATION                 \n");
		//sql.append(" 	, (SELECT TEXT4 FROM ICOMCODE WHERE HOUSE_CODE='100' AND type='M039' AND CODE=nvl(CNDT.PURCHASE_LOCATION,rqop.PURCHASE_LOCATION))as  PURCHASE_LEVEL   \n");
		sql.append("    , rqop.PURCHASE_LOCATION          			\n");
		sql.append("    , rqop.PURCHASE_LEVEL          				\n");
		sql.append(" 	, RQDT.SHIPPER_TYPE                      	\n");
		sql.append(" 	, RQHD.PRICE_TYPE                        	\n");
		sql.append(" FROM ICOYQTHD QTHD                          	\n");
		sql.append(" , ICOYQTDT QTDT                             	\n");
		sql.append(" , ICOYRQHD RQHD                             	\n");
		sql.append(" , ICOYRQDT RQDT                             	\n");
		sql.append(" , ICOYRQOP RQOP                             	\n");
		sql.append(" <OPT=F,S> WHERE QTHD.HOUSE_CODE = ? </OPT>  	\n");
		sql.append(" <OPT=F,S> AND QTHD.RFQ_NO = ?      </OPT>  	\n");
		sql.append(" AND QTHD.HOUSE_CODE = QTDT.HOUSE_CODE       	\n");
		sql.append(" AND QTHD.VENDOR_CODE    = QTDT.VENDOR_CODE     \n");
		sql.append(" AND QTHD.QTA_NO    = QTDT.QTA_NO          		\n");
		sql.append(" AND QTHD.STATUS IN ('C','R')                	\n");
		sql.append(" AND RQHD.HOUSE_CODE(+) = QTDT.HOUSE_CODE       \n");
		sql.append(" AND RQHD.RFQ_NO(+) = QTDT.RFQ_NO               \n");
		sql.append(" AND RQHD.RFQ_COUNT(+) = QTDT.RFQ_COUNT         \n");
		sql.append(" AND RQHD.STATUS(+) <>'D'                		\n");
		sql.append(" AND RQDT.HOUSE_CODE(+) = QTDT.HOUSE_CODE       \n");
		sql.append(" AND RQDT.RFQ_NO(+) = QTDT.RFQ_NO               \n");
		sql.append(" AND RQDT.RFQ_COUNT(+) = QTDT.RFQ_COUNT         \n");
		sql.append(" AND RQDT.RFQ_SEQ(+) = QTDT.RFQ_SEQ             \n");
		sql.append(" AND RQDT.STATUS(+) <> 'D'                		\n");
		sql.append(" AND RQOP.HOUSE_CODE(+) = QTDT.HOUSE_CODE       \n");
		sql.append(" AND RQOP.RFQ_NO(+) = QTDT.RFQ_NO               \n");
		sql.append(" AND RQOP.RFQ_COUNT(+) = QTDT.RFQ_COUNT         \n");
		sql.append(" AND RQOP.RFQ_SEQ(+) = QTDT.RFQ_SEQ             \n");
		sql.append(" AND RQOP.STATUS(+) <> 'D'                		\n");
		sql.append(" AND QTDT.SETTLE_FLAG = 'Y'               		\n"); */

//		sql.append(" SELECT                                             \n");
//		sql.append(" 	  QTDT.ITEM_NO                           	    \n");
//		sql.append(" 	, QTDT.COMPANY_CODE                      	    \n");
//		sql.append(" 	, QTDT.VENDOR_CODE                       	    \n");
//		sql.append("     , rqop.PURCHASE_LOCATION          			    \n");
//		sql.append("     , rqop.PURCHASE_LEVEL          				\n");
//		sql.append(" 	, RQDT.SHIPPER_TYPE                      	    \n");
//		sql.append(" 	, RQHD.PRICE_TYPE                        	    \n");
//		sql.append(" FROM ICOYQTHD QTHD                                 \n");
//		sql.append(" , ICOYQTDT QTDT                                    \n");
//		sql.append(" LEFT OUTER JOIN ICOYRQHD RQHD                      \n");
//		sql.append(" ON QTDT.HOUSE_CODE = RQHD.HOUSE_CODE               \n");
//		sql.append(" AND QTDT.RFQ_NO = RQHD.RFQ_NO                      \n");
//		sql.append(" AND QTDT.RFQ_COUNT = RQHD.RFQ_COUNT                \n");
//		sql.append(" LEFT OUTER JOIN ICOYRQDT RQDT                      \n");
//		sql.append(" ON QTDT.HOUSE_CODE = RQDT.HOUSE_CODE               \n");
//		sql.append(" AND QTDT.RFQ_NO = RQDT.RFQ_NO                      \n");
//		sql.append(" AND QTDT.RFQ_COUNT = RQDT.RFQ_COUNT                \n");
//		sql.append(" AND QTDT.RFQ_SEQ = RQDT.RFQ_SEQ                    \n");
//		sql.append(" LEFT OUTER JOIN ICOYRQOP RQOP                      \n");
//		sql.append(" ON QTDT.HOUSE_CODE = RQOP.HOUSE_CODE               \n");
//		sql.append(" AND QTDT.RFQ_NO = RQOP.RFQ_NO                      \n");
//		sql.append(" AND QTDT.RFQ_COUNT = RQOP.RFQ_COUNT                \n");
//		sql.append(" AND QTDT.RFQ_SEQ = RQOP.RFQ_SEQ                    \n");
//		sql.append(" <OPT=F,S> WHERE QTHD.HOUSE_CODE = ? </OPT>  	    \n");
//		sql.append(" <OPT=F,S> AND QTHD.RFQ_NO = ?      </OPT>          \n");
//		sql.append(" AND QTHD.HOUSE_CODE = QTDT.HOUSE_CODE       	    \n");
//		sql.append(" AND QTHD.VENDOR_CODE    = QTDT.VENDOR_CODE         \n");
//		sql.append(" AND QTHD.QTA_NO    = QTDT.QTA_NO                   \n");
//		sql.append(" AND QTHD.STATUS IN ('C','R')                       \n");
//		sql.append(" AND RQHD.STATUS <>'D'                              \n");
//		sql.append(" AND RQDT.STATUS <> 'D'                             \n");
//		sql.append(" AND RQOP.STATUS <> 'D'                             \n");
//		sql.append(" AND QTDT.SETTLE_FLAG = 'Y' 	                    \n");

		try
		{
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String val = sm.doSelect(args);

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
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
					wxp.addVar("company_code", company_code);
					wxp.addVar("vendor_code", vendor_code);
					wxp.addVar("purchase_location", purchase_location);

//				    StringBuffer INFO1 = new StringBuffer();

//					INFO1.append(" DELETE FROM ICOYINFO                           \n");
//					INFO1.append(" WHERE HOUSE_CODE = ?                           \n");
//					INFO1.append(" AND ITEM_NO = ?                                \n");
//					INFO1.append(" AND COMPANY_CODE = '"+company_code+"'          \n");
//					INFO1.append(" AND VENDOR_CODE = '"+vendor_code+"'            \n");
//					INFO1.append(" AND PURCHASE_LOCATION = '"+purchase_location+"'\n");


					String[][] args1 = {
						{ house_code, item_no }
					};
					String[] type1 = {"S","S"};

					sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
					sm.doDelete(args1, type1);


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
	 * ICOYINFO 을 생성한다.
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

//		StringBuffer tSQL = new StringBuffer();

		String add_date     = SepoaDate.getShortDateString();
		String add_time     = SepoaDate.getShortTimeString();
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//		tSQL.append(" INSERT INTO ICOYINFO                                                          \n");
//		tSQL.append(" (                                                                             \n");
//		tSQL.append("     HOUSE_CODE                                                                \n");
//		tSQL.append("   , COMPANY_CODE                                                              \n");
//		tSQL.append("   , PURCHASE_LOCATION                                                         \n");
//		tSQL.append("   , ITEM_NO                                                                   \n");
//		tSQL.append("   , VENDOR_CODE                                                               \n");
//		tSQL.append("   , STATUS                                                                    \n");
//		tSQL.append("   , ADD_DATE                                                                  \n");
//		tSQL.append("   , ADD_TIME                                                                  \n");
//		tSQL.append("   , ADD_USER_ID                                                               \n");
//		tSQL.append("   , CHANGE_DATE                                                               \n");
//		tSQL.append("   , CHANGE_TIME                                                               \n");
//		tSQL.append("   , CHANGE_USER_ID                                                            \n");
//		tSQL.append("   , SHIPPER_TYPE                                                              \n");
//		tSQL.append("   , VENDOR_ITEM_NO                                                            \n");
//		tSQL.append("   , MAKER_CODE                                                                \n");
//		tSQL.append("   , MAKER_NAME                                                                \n");
//		tSQL.append("   , BASIC_UNIT                                                                \n");
//		tSQL.append("   , DELIVERY_LT                                                               \n");
//		tSQL.append("   , VALID_FROM_DATE                                                           \n");
//		tSQL.append("   , VALID_TO_DATE                                                             \n");
//		tSQL.append("   , DELY_TERMS                                                                \n");
//		tSQL.append("   , DELY_TEXT                                                                 \n");
//		tSQL.append("   , PAY_TERMS                                                                 \n");
//		tSQL.append("   , PAY_TEXT                                                                  \n");
//		tSQL.append("   , PRICE_TYPE                                                                \n");
//		tSQL.append("   , EXEC_NO                                                                   \n");
//		tSQL.append("   , EXEC_QTY                                                                  \n");
//		tSQL.append("   , EXEC_SEQ                                                                  \n");
//		tSQL.append("   , TTL_CHARGE                                                                \n");
//		tSQL.append("   , NET_AMT                                                                   \n");
//		tSQL.append("   , EXEC_TTL_AMT                                                              \n");
//		tSQL.append("   , PURCHASE_HOLD_FLAG                                                        \n");
//		tSQL.append("   , CHARGE_FLAG                                                               \n");
//		tSQL.append("   , GR_BASE_FLAG                                                              \n");
//		tSQL.append("   , UNIT_PRICE                                                                \n");
//		tSQL.append("   , CUR                                                                       \n");
//		tSQL.append("   , MOLDING_CHARGE                                                            \n");
//		tSQL.append("   , AUTO_PO_FLAG                                                              \n");
//		tSQL.append("   , PURCHASE_LEVEL                                                            \n");
//		tSQL.append("   , PURCHASE_UNIT                                                             \n");
//		tSQL.append("   , PURCHASE_CONV_RATE                                                        \n");
//		tSQL.append("   , PURCHASE_CONV_QTY                                                         \n");
//		tSQL.append("   , FOB_CHARGE                                                                \n");
//		tSQL.append("   , TRANS_CHARGE                                                              \n");
//		tSQL.append("   , MOLDING_QTY                                                               \n");
//		tSQL.append("   , CTRL_CODE                                                                 \n");
//		tSQL.append("   , APP_TAX_CODE                                                              \n");
//		tSQL.append("   , ARRIVAL_PORT                                                              \n");
//		tSQL.append("   , ARRIVAL_PORT_NAME                                                         \n");
//		tSQL.append("   , DEPART_PORT                                                               \n");
//		tSQL.append("   , DEPART_PORT_NAME                                                          \n");
//		tSQL.append("   , TOD_1                                                                     \n");
//		tSQL.append("   , TOD_2                                                                     \n");
//		tSQL.append("   , TOD_3                                                                     \n");
//		tSQL.append("   , SHIPPING_METHOD                                                           \n");
//		tSQL.append("   , NOTIFY                                                                    \n");
//		tSQL.append("   , TARIFF_TAX_RATE                                                           \n");
//		tSQL.append("   , YEAR_QTY                                                                  \n");
//		tSQL.append("   , CUSTOMER_PRICE           													\n");
//		tSQL.append(" ) (                                                                           \n");
//		tSQL.append(" SELECT                                                                        \n");
//		tSQL.append("     QD.HOUSE_CODE                      -- HOUSE_CODE                          \n");
//		tSQL.append("   , QD.COMPANY_CODE                    -- COMPANY_CODE                        \n");
//		tSQL.append("   , RO.PURCHASE_LOCATION                    -- PURCHASE_LOCATION              \n");
//		tSQL.append("   , QD.ITEM_NO                         -- ITEM_NO                             \n");
//		tSQL.append("   , QD.VENDOR_CODE                     -- VENDOR_CODE                         \n");
//		tSQL.append("   , 'C'                                -- STATUS                              \n");
//		tSQL.append("   , ?                     -- ADD_DATE                                         \n");
//		tSQL.append("   , ?                     -- ADD_TIME                                         \n");
//		tSQL.append("   , ?                      -- ADD_USER_ID                                     \n");
//		tSQL.append("   , ?                     -- CHANGE_DATE                                      \n");
//		tSQL.append("   , ?                     -- CHANGE_TIME                                      \n");
//		tSQL.append("   , ?                      -- CHANGE_USER_ID                                  \n");
//		tSQL.append("   , RD.SHIPPER_TYPE                    -- SHIPPER_TYPE                        \n");
//		tSQL.append("   , ''                  -- VENDOR_ITEM_NO                      				\n");
//		tSQL.append("   , ''                      -- MAKER_CODE                          			\n");
//		tSQL.append("   , ''                      -- MAKER_NAME                          			\n");
//		tSQL.append("   , QD.UNIT_MEASURE                    -- BASIC_UNIT                          \n");
//		tSQL.append("   , QD.DELIVERY_LT                     -- DELIVERY_LT                         \n");
//		tSQL.append("   , RD.VALID_FROM_DATE                 -- VALID_FROM_DATE                     \n");
//		tSQL.append("   , RD.VALID_TO_DATE                   -- VALID_TO_DATE                       \n");
//		tSQL.append("   , ''                                    -- DELY_TERMS            			\n");
//		tSQL.append("   , '' --GETICOMCODE2(CH.HOUSE_CODE,'M009',CH.DELY_TERMS) -- DELY_TEXT        \n");
//		tSQL.append("   , QH.PAY_TERMS                                     -- PAY_TERMS             \n");
//		tSQL.append("   , dbo.GETICOMCODE2(QH.HOUSE_CODE,'M010',QH.PAY_TERMS)  -- PAY_TEXT              \n");
//		tSQL.append("   , RD.PRICE_TYPE                      -- PRICE_TYPE                          \n");
//		tSQL.append("   , QH.RFQ_NO                         -- EXEC_NO                             	\n");
//		tSQL.append("   , QD.SETTLE_QTY                      -- EXEC_QTY                            \n");
//		tSQL.append("   , DBO.LPAD(ISNULL((SELECT MAX(EXEC_SEQ)                                         \n");
//		tSQL.append("        FROM ICOYINFO                                                   		\n");
//		tSQL.append("        WHERE HOUSE_CODE = QD.HOUSE_CODE                               		\n");
//		tSQL.append("        AND COMPANY_CODE = QD.COMPANY_CODE                             		\n");
//		tSQL.append("        AND PURCHASE_LOCATION = RO.PURCHASE_LOCATION                   		\n");
//		tSQL.append("        AND ITEM_NO = QD.ITEM_NO                                       		\n");
//		tSQL.append("        AND VENDOR_CODE = QD.VENDOR_CODE),0) + 1, 6, '0') -- , QH.QTA_SEQ   --EXEC_SEQ    \n");
//		tSQL.append("   , 0                                 -- TTL_CHARGE                          \n");
//		tSQL.append("   , QD.ITEM_AMT                        -- NET_AMT                             \n");
//		tSQL.append("   , QH.TTL_AMT                    -- EXEC_TTL_AMT                        		\n");
//		tSQL.append("   , 'N'                                -- PURCHASE_HOLD_FLAG                  \n");
//		tSQL.append("   , ''                                 -- CHARGE_FLAG                         \n");
//		tSQL.append("   , 'N' --(SELECT NVL(GR_BASE_FLAG,'N')                                       \n");
//		tSQL.append("   , QD.UNIT_PRICE                      -- UNIT_PRICE                          \n");
//		tSQL.append("   , QH.CUR                             -- CUR                                 \n");
//		tSQL.append("   , 0                  -- MOLDING_CHARGE                      				\n");
//		tSQL.append("   , RD.AUTO_PO_FLAG                    -- AUTO_PO_FLAG                        \n");
//		tSQL.append("   , ''  --(SELECT TEXT4 FROM ICOMCODE WHERE HOUSE_CODE='100' AND type='M039' AND CODE=CD.PURCHASE_LOCATION)                  -- PURCHASE_LEVEL                      \n");
//		tSQL.append("   , RD.UNIT_MEASURE                      -- PURCHASE_UNIT                     \n");
//		tSQL.append("   , 0              -- PURCHASE_CONV_RATE                  					\n");
//		tSQL.append("   , 0               -- PURCHASE_CONV_QTY                   					\n");
//		tSQL.append("   , 0                                 -- FOB_CHARGE                          \n");
//		tSQL.append("   , 0                                 -- TRANS_CHARGE                        \n");
//		tSQL.append("   , 0                      -- MOLDING_QTY                         			\n");
//		tSQL.append("   , ''                       -- CTRL_CODE                           			\n");
//		tSQL.append("   , ''                                 -- APP_TAX_CODE                        \n");
//		tSQL.append("   , ''                    -- ARRIVAL_PORT                        				\n");
//		tSQL.append("   , ''               -- ARRIVAL_PORT_NAME                   					\n");
//		tSQL.append("   , ''                     -- DEPART_PORT                         			\n");
//		tSQL.append("   , ''                -- DEPART_PORT_NAME                    					\n");
//		tSQL.append("   , ''                                 -- TOD_1                               \n");
//		tSQL.append("   , ''                                 -- TOD_2                               \n");
//		tSQL.append("   , ''                                 -- TOD_3                               \n");
//		tSQL.append("   , ''                 -- SHIPPING_METHOD                     				\n");
//		tSQL.append("   , ''                                 -- NOTIFY                              \n");
//		tSQL.append("   , 0                                 -- TARIFF_TAX_RATE                     \n");
//		tSQL.append("   , RD.YEAR_QTY                        -- YEAR_QTY                            \n");
//		tSQL.append("   , QD.CUSTOMER_PRICE           												\n");
//		tSQL.append(" FROM   ICOYQTHD QH                                                            \n");
//		tSQL.append(" , ICOYQTDT QD                                                                 \n");
//		tSQL.append(" , ICOYRQDT RD                                                                 \n");
//		tSQL.append(" , ICOYRQOP RO                                                                 \n");
//		tSQL.append(" WHERE QH.HOUSE_CODE = ?                                                       \n");
//		tSQL.append(" AND QH.RFQ_NO      = ?                                                       	\n");
//		tSQL.append(" AND QH.STATUS IN ('C','R')                                                    \n");
//		tSQL.append(" AND QH.HOUSE_CODE = QD.HOUSE_CODE												\n");
//		tSQL.append(" AND QH.VENDOR_CODE = QD.VENDOR_CODE                                           \n");
//		tSQL.append(" AND QH.QTA_NO = QD.QTA_NO                                                		\n");
//		tSQL.append(" AND QH.RFQ_NO = QD.RFQ_NO                                                     \n");
//		tSQL.append(" AND QH.RFQ_COUNT = QD.RFQ_COUNT                                               \n");
//		tSQL.append(" AND QD.HOUSE_CODE = RD.HOUSE_CODE                                             \n");
//		tSQL.append(" AND QD.RFQ_NO = RD.RFQ_NO                                                     \n");
//		tSQL.append(" AND QD.RFQ_COUNT = RD.RFQ_COUNT                                               \n");
//		tSQL.append(" AND QD.RFQ_SEQ = RD.RFQ_SEQ                                                   \n");
//		tSQL.append(" AND RD.HOUSE_CODE = RO.HOUSE_CODE                                             \n");
//		tSQL.append(" AND RD.RFQ_NO = RO.RFQ_NO                                                     \n");
//		tSQL.append(" AND RD.RFQ_COUNT = RO.RFQ_COUNT                                               \n");
//		tSQL.append(" AND RD.RFQ_SEQ = RO.RFQ_SEQ                                                   \n");
//		tSQL.append(" AND RO.VENDOR_CODE = QD.VENDOR_CODE                                           \n");
//		tSQL.append(" AND QD.SETTLE_FLAG = 'Y'                                                      \n");
//		tSQL.append(" AND QH.STATUS IN ('C','R')                                                    \n");
//		tSQL.append(" AND QD.STATUS IN ('C','R')                                                    \n");
//		tSQL.append(" AND RD.STATUS IN ('C','R')                                                    \n");
//		tSQL.append(" AND RO.STATUS IN ('C','R')                                                    \n");
//		tSQL.append(" AND DBO.getInfoItemCount(QD.HOUSE_CODE, QD.ITEM_NO) = 'F'                     \n");
//		tSQL.append(" )                                                                             \n");

		try
		{
			String[] type1 = { "S","S","S", "S","S","S", "S","S"  };
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn = sm.doInsert(args, type1);
			if(rtn<1)
				throw new Exception("INSERT ICOYINFO ERROR");

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
		int	rtn	= -1;
		String user_id	  =	info.getSession("ID");
		String house_code =	info.getSession("HOUSE_CODE");
		ConnectionContext ctx =	getConnectionContext();
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		StringBuffer tSQL = new StringBuffer();
//		tSQL.append(" INSERT INTO ICOYINFH                                                   \n");
//		tSQL.append(" (                                                                      \n");
//		tSQL.append("   HOUSE_CODE                                                           \n");
//		tSQL.append(" , COMPANY_CODE                                                         \n");
//		tSQL.append(" , PURCHASE_LOCATION                                                    \n");
//		tSQL.append(" , ITEM_NO                                                              \n");
//		tSQL.append(" , VENDOR_CODE                                                          \n");
//		tSQL.append(" , SEQ                                                                  \n");
//		tSQL.append(" , STATUS                                                               \n");
//		tSQL.append(" , ADD_DATE                                                             \n");
//		tSQL.append(" , ADD_TIME                                                             \n");
//		tSQL.append(" , ADD_USER_ID                                                          \n");
//		tSQL.append(" , CHANGE_DATE                                                          \n");
//		tSQL.append(" , CHANGE_TIME                                                          \n");
//		tSQL.append(" , CHANGE_USER_ID                                                       \n");
//		tSQL.append(" , SHIPPER_TYPE                                                         \n");
//		tSQL.append(" , VENDOR_ITEM_NO                                                       \n");
//		tSQL.append(" , MAKER_CODE                                                           \n");
//		tSQL.append(" , MAKER_NAME                                                           \n");
//		tSQL.append(" , BASIC_UNIT                                                           \n");
//		tSQL.append(" , DELIVERY_LT                                                          \n");
//		tSQL.append(" , VALID_FROM_DATE                                                      \n");
//		tSQL.append(" , VALID_TO_DATE                                                        \n");
//		tSQL.append(" , DELY_TERMS                                                           \n");
//		tSQL.append(" , DELY_TEXT                                                            \n");
//		tSQL.append(" , PAY_TERMS                                                            \n");
//		tSQL.append(" , PAY_TEXT                                                             \n");
//		tSQL.append(" , PRICE_TYPE                                                           \n");
//		tSQL.append(" , EXEC_NO                                                              \n");
//		tSQL.append(" , EXEC_QTY                                                             \n");
//		tSQL.append(" , EXEC_SEQ                                                             \n");
//		tSQL.append(" , TTL_CHARGE                                                           \n");
//		tSQL.append(" , NET_AMT                                                              \n");
//		tSQL.append(" , EXEC_TTL_AMT                                                         \n");
//		tSQL.append(" , PURCHASE_HOLD_FLAG                                                   \n");
//		tSQL.append(" , CHARGE_FLAG                                                          \n");
//		tSQL.append(" , GR_BASE_FLAG                                                         \n");
//		tSQL.append(" , UNIT_PRICE                                                           \n");
//		tSQL.append(" , CUR                                                                  \n");
//		tSQL.append(" , YEAR_QTY                                                     		 \n");
//		tSQL.append(" , MOLDING_CHARGE                                                       \n");
//		tSQL.append(" , AUTO_PO_FLAG                                                         \n");
//		tSQL.append(" , PURCHASE_UNIT                                                        \n");
//		tSQL.append(" , PURCHASE_CONV_RATE                                                   \n");
//		tSQL.append(" , PURCHASE_CONV_QTY                                                    \n");
//		tSQL.append(" , FOB_CHARGE                                                           \n");
//		tSQL.append(" , TRANS_CHARGE                                                         \n");
//		tSQL.append(" , MOLDING_QTY                                                          \n");
//		tSQL.append(" , CTRL_CODE                                                            \n");
//
//		tSQL.append(" , APP_TAX_CODE                                                         \n");
//		tSQL.append(" , ARRIVAL_PORT                                                         \n");
//		tSQL.append(" , ARRIVAL_PORT_NAME                                                    \n");
//		tSQL.append(" , DEPART_PORT                                                          \n");
//		tSQL.append(" , DEPART_PORT_NAME                                                     \n");
//		tSQL.append(" , TOD_1                                                                \n");
//		tSQL.append(" , TOD_2                                                                \n");
//		tSQL.append(" , TOD_3                                                                \n");
//		tSQL.append(" , SHIPPING_METHOD                                                      \n");
//		tSQL.append(" , NOTIFY                                                               \n");
//		tSQL.append(" , TARIFF_TAX_RATE                                                      \n");
//		tSQL.append(" ) (                                                                    \n");
//		tSQL.append(" SELECT                                                                 \n");
//		tSQL.append("   HOUSE_CODE                      -- HOUSE_CODE                        \n");
//		tSQL.append(" , COMPANY_CODE                    -- COMPANY_CODE                      \n");
//		tSQL.append(" , PURCHASE_LOCATION               -- PURCHASE_LOCATION                 \n");
//		tSQL.append(" , ITEM_NO                         -- ITEM_NO                           \n");
//		tSQL.append(" , VENDOR_CODE                     -- VENDOR_CODE                       \n");
//		tSQL.append(" , DBO.LPAD(ISNULL((SELECT MAX(EXEC_SEQ)                                    \n");
//		tSQL.append("        FROM ICOYINFH                                                   \n");
//		tSQL.append("        WHERE HOUSE_CODE = IFO.HOUSE_CODE                               \n");
//		tSQL.append("        AND COMPANY_CODE = IFO.COMPANY_CODE                             \n");
//		tSQL.append("        AND PURCHASE_LOCATION = IFO.PURCHASE_LOCATION                   \n");
//		tSQL.append("        AND ITEM_NO = IFO.ITEM_NO                                       \n");
//		tSQL.append("        AND VENDOR_CODE = IFO.VENDOR_CODE),0) + 1, 6, '0') -- SEQ   \n");
//		tSQL.append(" , STATUS                          -- STATUS                            \n");
//		tSQL.append(" , ADD_DATE                        -- ADD_DATE                          \n");
//		tSQL.append(" , ADD_TIME                        -- ADD_TIME                          \n");
//		tSQL.append(" , ADD_USER_ID                     -- ADD_USER_ID                       \n");
//		tSQL.append(" , CHANGE_DATE                     -- CHANGE_DATE                       \n");
//		tSQL.append(" , CHANGE_TIME                     -- CHANGE_TIME                       \n");
//		tSQL.append(" , CHANGE_USER_ID                  -- CHANGE_USER_ID                    \n");
//		tSQL.append(" , SHIPPER_TYPE                    -- SHIPPER_TYPE                      \n");
//		tSQL.append(" , VENDOR_ITEM_NO                  -- VENDOR_ITEM_NO                    \n");
//		tSQL.append(" , MAKER_CODE                      -- MAKER_CODE                        \n");
//		tSQL.append(" , MAKER_NAME                      -- MAKER_NAME                        \n");
//		tSQL.append(" , BASIC_UNIT                      -- BASIC_UNIT                        \n");
//		tSQL.append(" , DELIVERY_LT                     -- DELIVERY_LT                       \n");
//		tSQL.append(" , VALID_FROM_DATE                 -- VALID_FROM_DATE                   \n");
//		tSQL.append(" , VALID_TO_DATE                   -- VALID_TO_DATE                     \n");
//		tSQL.append(" , DELY_TERMS                      -- DELY_TERMS                        \n");
//		tSQL.append(" , DELY_TEXT                       -- DELY_TEXT                         \n");
//		tSQL.append(" , PAY_TERMS                       -- PAY_TERMS                         \n");
//		tSQL.append(" , PAY_TEXT                        -- PAY_TEXT                          \n");
//		tSQL.append(" , PRICE_TYPE                      -- PRICE_TYPE                        \n");
//		tSQL.append(" , EXEC_NO                         -- EXEC_NO                           \n");
//		tSQL.append(" , EXEC_QTY                        -- EXEC_QTY                          \n");
//		tSQL.append(" , EXEC_SEQ                        -- EXEC_SEQ                          \n");
//		tSQL.append(" , TTL_CHARGE                      -- TTL_CHARGE                        \n");
//		tSQL.append(" , NET_AMT                         -- NET_AMT                           \n");
//		tSQL.append(" , EXEC_TTL_AMT                    -- EXEC_TTL_AMT                      \n");
//		tSQL.append(" , PURCHASE_HOLD_FLAG              -- PURCHASE_HOLD_FLAG                \n");
//		tSQL.append(" , CHARGE_FLAG                     -- CHARGE_FLAG                       \n");
//		tSQL.append(" , GR_BASE_FLAG                    -- GR_BASE_FLAG                      \n");
//		tSQL.append(" , UNIT_PRICE                      -- UNIT_PRICE                        \n");
//		tSQL.append(" , CUR                             -- CUR                               \n");
//		tSQL.append(" , YEAR_QTY                        -- YEAR_TTL_REQ_QTY                  \n");
//		tSQL.append(" , MOLDING_CHARGE                  -- MOLDING_CHARGE                    \n");
//		tSQL.append(" , AUTO_PO_FLAG                    -- AUTO_PO_FLAG                      \n");
//		tSQL.append(" , PURCHASE_UNIT                   -- PURCHASE_UNIT                     \n");
//		tSQL.append(" , PURCHASE_CONV_RATE              -- PURCHASE_CONV_RATE                \n");
//		tSQL.append(" , PURCHASE_CONV_QTY               -- PURCHASE_CONV_QTY                 \n");
//		tSQL.append(" , FOB_CHARGE                      -- FOB_CHARGE                        \n");
//		tSQL.append(" , TRANS_CHARGE                    -- TRANS_CHARGE                      \n");
//		tSQL.append(" , MOLDING_QTY                     -- MOLDING_QTY                       \n");
//		tSQL.append(" , CTRL_CODE                       -- CTRL_CODE                         \n");
//		tSQL.append(" , APP_TAX_CODE                    -- APP_TAX_CODE                      \n");
//		tSQL.append(" , ARRIVAL_PORT                    -- ARRIVAL_PORT                      \n");
//		tSQL.append(" , ARRIVAL_PORT_NAME               -- ARRIVAL_PORT_NAME                 \n");
//		tSQL.append(" , DEPART_PORT                     -- DEPART_PORT                       \n");
//		tSQL.append(" , DEPART_PORT_NAME                -- DEPART_PORT_NAME                  \n");
//		tSQL.append(" , TOD_1                           -- TOD_1                             \n");
//		tSQL.append(" , TOD_2                           -- TOD_2                             \n");
//		tSQL.append(" , TOD_3                           -- TOD_3                             \n");
//		tSQL.append(" , SHIPPING_METHOD                 -- SHIPPING_METHOD                   \n");
//		tSQL.append(" , NOTIFY                          -- NOTIFY                            \n");
//		tSQL.append(" , TARIFF_TAX_RATE                 -- TARIFF_TAX_RATE                   \n");
//		tSQL.append(" FROM ICOYINFO IFO                                                      \n");
//		tSQL.append(" WHERE HOUSE_CODE = ?                                                   \n");
//		tSQL.append(" AND EXEC_NO = ?                                                        \n");
//		tSQL.append(" )                                                                      \n");

		try
		{
			String[] type1 = { "S","S" };
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			sm.doInsert(args, type1);

		}
		catch(Exception e)
		{
			throw new Exception(e.getMessage());
		}

	}


	public SepoaOut setRFQClose(String[][] setData)
	{
		int	rtn	= 0;
		try	{

			rtn	= et_setRFQClose(setData);

			setMessage("입찰마감 되었습니다.");	// 견적마감	되었습니다.
			setValue(Integer.toString(rtn));
			setStatus(1);

			Commit();

		}catch(Exception e){
			try{Rollback();}catch(Exception	e1){ Logger.err.println("Exception e	=" + e1.getMessage()); }
			Logger.err.println("Exception e	=" + e.getMessage());

			setMessage(msg.get("STDRFQ.0039"));	// 견적마감에 실패했습니다.
			setStatus(0);
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}


	private	int	et_setRFQClose(String[][] setData) throws Exception
	{
		int	rtn	= -1;
		ConnectionContext ctx =	getConnectionContext();

		try	{
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//			StringBuffer sql = new StringBuffer();
//
//			sql.append(" UPDATE	ICOYRQHD				\n");
//			sql.append(" SET	RFQ_FLAG = 'P',			\n");
//			sql.append("		RFQ_CLOSE_DATE = ?,		\n");
// 			sql.append("		RFQ_CLOSE_TIME = ?		\n");
// 			sql.append(" WHERE	HOUSE_CODE = ?			\n");
//			sql.append(" AND	RFQ_NO	   = ?			\n");
//			sql.append(" AND	RFQ_COUNT  = ?			\n");

			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type =	{"S", "S", "S", "S", "N"};
			rtn	= sm.doUpdate(setData,type);

		}catch(Exception e)	{
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
//
//
//	public SepoaOut setBidDelete( String[][]	deletedata )
//	{
//		 String lang	= info.getSession("LANGUAGE");
//		 Message	msg	= new Message(lang,"STDRFQ");
//
//		if(	deletedata == null)	{
//			setStatus(0);
//			setMessage(msg.getMessage("0005"));
//		}
//		else {
//			try	{
//				ConnectionContext ctx =	getConnectionContext();
//
//				int	rtn	= et_setBidHDChange_delete(ctx,deletedata);
//				et_setBidDTDelete(ctx,deletedata);
//				et_setBidANDelete(ctx,deletedata);
//				et_setBidSEDelete(ctx,deletedata);
//				et_setBidEVDelete(ctx,deletedata);
//				et_setBidOPDelete(ctx,deletedata);
//
//				for(int	i =	0 ;	i <	deletedata.length ;	i++) {
//					et_setBidDelete_return(ctx, deletedata[i][1], deletedata[i][2]);
//				}
//
//				setStatus(1);
//				setValue(String.valueOf(rtn));
//				setMessage(msg.getMessage("0000"));
//				Commit();
//			} catch(Exception e) {
//				try	{
//					Rollback();
//				} catch(Exception d){
//					Logger.err.println(info.getSession("ID"),this,d.getMessage());
//				}
//				Logger.err.println(info.getSession("ID"),this,e.getMessage());
//				setStatus(0);
//				setMessage(msg.getMessage("0003"));
//			}
//		}
//		return getSepoaOut();
//	}
//
//	private	int	et_setBidHDChange_delete(ConnectionContext ctx,String[][] deletedata) throws Exception
//	{
//		int	rtn	= 0;
//		StringBuffer sql = new StringBuffer();
//		sql.append(" UPDATE	ICOYRQHD SET STATUS	= 'D'       \n");
//		sql.append(" WHERE	HOUSE_CODE  = ?                 \n");
//		sql.append(" AND	RFQ_NO	    = ?	                \n");
//		sql.append(" AND	RFQ_COUNT   = ?                 \n");
//
//		try	{
//			String[] type =	{"S","S","N"};
//			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
//
//			rtn	= sm.doUpdate(deletedata,type);
//		} catch(Exception e) {
//			Logger.err.println(info.getSession("ID"),this,e.getMessage());
//			throw new Exception(e.getMessage());
//		}
//		return rtn;
//	}
//
//	private	int	et_setBidDTDelete(ConnectionContext	ctx,String[][] deletedata) throws Exception
//	{
//		int	rtn	= 0;
//		StringBuffer sql = new StringBuffer();
//		sql.append(" UPDATE	ICOYRQDT SET STATUS	= 'D'       \n");
//		sql.append(" WHERE	HOUSE_CODE  = ?                 \n");
//		sql.append(" AND	RFQ_NO      = ?	                \n");
//		sql.append(" AND	RFQ_COUNT   = ?                 \n");
//
//		try	{
//			String[] type =	{"S","S","N"};
//			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
//
//			rtn	= sm.doUpdate(deletedata,type);
//		} catch(Exception e) {
//			Logger.err.println(info.getSession("ID"),this,e.getMessage());
//			throw new Exception(e.getMessage());
//		}
//		return rtn;
//	}
//
//	private	int	et_setBidANDelete(ConnectionContext ctx,String[][] deletedata) throws Exception
//	{
//		int	rtn	= 0;
//		StringBuffer sql = new StringBuffer();
//		sql.append(" UPDATE	ICOYRQAN SET STATUS	= 'D'       \n");
//		sql.append(" WHERE	HOUSE_CODE  = ?                 \n");
//		sql.append(" AND	RFQ_NO      = ?	                \n");
//		sql.append(" AND	RFQ_COUNT   = ?                 \n");
//
//		try	{
//			String[] type =	{"S","S","N"};
//			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
//
//			rtn	= sm.doUpdate(deletedata,type);
//		} catch(Exception e) {
//			Logger.err.println(info.getSession("ID"),this,e.getMessage());
//			throw new Exception(e.getMessage());
//		}
//		return rtn;
//	}
//
//	private	int	et_setBidEVDelete(ConnectionContext ctx,String[][] deletedata) throws Exception
//	{
//		int	rtn	= 0;
//		StringBuffer sql = new StringBuffer();
//		sql.append(" DELETE	FROM ICOYTBEV      				\n");
//		sql.append(" WHERE	HOUSE_CODE  = ?                 \n");
//		sql.append(" AND	DOC_NO      = ?	                \n");
//		sql.append(" AND	DOC_SEQ   = ?                 	\n");
//
//		try	{
//			String[] type =	{"S","S","N"};
//			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
//
//			rtn	= sm.doUpdate(deletedata,type);
//		} catch(Exception e) {
//			Logger.err.println(info.getSession("ID"),this,e.getMessage());
//			throw new Exception(e.getMessage());
//		}
//		return rtn;
//	}
//
//	private	int	et_setBidSEDelete(ConnectionContext ctx,String[][] deletedata) throws Exception
//	{
//		int	rtn	= 0;
//		StringBuffer sql = new StringBuffer();
//		sql.append(" UPDATE	ICOYRQSE SET STATUS	= 'D'       \n");
//		sql.append(" WHERE	HOUSE_CODE  = ?                 \n");
//		sql.append(" AND	RFQ_NO      = ?	                \n");
//		sql.append(" AND	RFQ_COUNT   = ?                 \n");
//
//		try	{
//			String[] type =	{"S","S","N"};
//			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
//
//			rtn	= sm.doUpdate(deletedata,type);
//		} catch(Exception e) {
//			Logger.err.println(info.getSession("ID"),this,e.getMessage());
//			throw new Exception(e.getMessage());
//		}
//		return rtn;
//	}
//
//	private	int	et_setBidOPDelete(ConnectionContext ctx,String[][] deletedata) throws Exception
//	{
//		int	rtn	= 0;
//		StringBuffer sql = new StringBuffer();
//		sql.append(" UPDATE	ICOYRQOP SET STATUS	= 'D'       \n");
//		sql.append(" WHERE	HOUSE_CODE  = ?                 \n");
//		sql.append(" AND	RFQ_NO      = ?	                \n");
//		sql.append(" AND	RFQ_COUNT   = ?                 \n");
//
//		try	{
//			String[] type =	{"S","S","N"};
//			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
//
//			rtn	= sm.doUpdate(deletedata,type);
//		} catch(Exception e) {
//			Logger.err.println(info.getSession("ID"),this,e.getMessage());
//			throw new Exception(e.getMessage());
//		}
//		return rtn;
//	}
//
//	private	int	et_setBidDelete_return(ConnectionContext ctx, String rfq_no, String	rfq_count )	throws Exception
//	{
//		String house_code =	info.getSession("HOUSE_CODE");
//
//		int	rtn	= 0;
//		String value = "";
//		String[][] return_value	= null;
//
//		StringBuffer sql = new StringBuffer();
//		sql.append(" SELECT	HOUSE_CODE, PR_NO,PR_SEQ FROM ICOYRQDT          \n");
//		sql.append(" <OPT=F,S> WHERE    HOUSE_CODE = ?  </OPT>  			\n");
//		sql.append(" <OPT=S,S> AND  RFQ_NO         = ?  </OPT>  			\n");
//		sql.append(" <OPT=S,N> AND  RFQ_COUNT      = ?  </OPT>  			\n");
//
//		StringBuffer sql1 =	new	StringBuffer();
//		sql1.append(" UPDATE  ICOYPRDT	SET	PR_PROCEEDING_FLAG	= 'P'  	\n");
//		sql1.append(" WHERE		HOUSE_CODE = ?      					\n");
//		sql1.append(" AND		PR_NO  = ?                         		\n");
//		sql1.append(" AND		PR_SEQ	= ?	                       		\n");
//
//		try	{
//			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
//            String[] data = {house_code, rfq_no, rfq_count};
//			value =	sm.doSelect(data);
//			SepoaFormater wf	= new SepoaFormater(value);
//
//			if(wf.getRowCount()>0) {
//				return_value = wf.getValue();
//				sm = new SepoaSQLManager(userid,this,ctx,sql1.toString());
//				String[] type =	{"S","S","S"};
//
//				rtn	= sm.doUpdate(return_value,type);
//			}
//		} catch(Exception e) {
//			Logger.err.println(info.getSession("ID"),this,e.getMessage());
//			throw new Exception(e.getMessage());
//		}
//
//		return rtn;
//	}
//
	
//	public SepoaOut setReqBidDelete( String[][]	deletedata )
//	{
//		 String lang	= info.getSession("LANGUAGE");
//
//		if(	deletedata == null)	{
//			setStatus(0);
//			setMessage(msg.get("STDRFQ.0005"));
//		}
//		else {
//			try	{
//				ConnectionContext ctx =	getConnectionContext();
//
//				int	rtn	= et_setReqBidHDDelete(ctx,deletedata);
//				et_setReqBidDTDelete(ctx,deletedata);
//
//				setStatus(1);
//				setValue(String.valueOf(rtn));
//				setMessage(msg.get("STDRFQ.0000"));
//				Commit();
//			} catch(Exception e) {
//				try	{
//					Rollback();
//				} catch(Exception d){
//					Logger.err.println(info.getSession("ID"),this,d.getMessage());
//				}
//				Logger.err.println(info.getSession("ID"),this,e.getMessage());
//				setStatus(0);
//				setMessage(msg.get("STDRFQ.0003"));
//			}
//		}
//		return getSepoaOut();
//	}

	private	int	et_setReqBidHDDelete(ConnectionContext ctx,String[][] deletedata) throws Exception
	{
		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//		sql.append(" UPDATE	ICOYPRHD SET STATUS	= 'D'       \n");
//		sql.append(" WHERE	HOUSE_CODE  = ?                 \n");
//		sql.append(" AND	PR_NO	    = ?	                \n");

		try	{
			String[] type =	{"S","S"};
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());

			rtn	= sm.doUpdate(deletedata,type);
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private	int	et_setReqBidDTDelete(ConnectionContext ctx,String[][] deletedata) throws Exception
	{
		int	rtn	= 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//		sql.append(" UPDATE	ICOYPRDT SET STATUS	= 'D'       \n");
//		sql.append(" WHERE	HOUSE_CODE  = ?                 \n");
//		sql.append(" AND	PR_NO	    = ?	                \n");

		try	{
			String[] type =	{"S","S"};
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

			rtn	= sm.doUpdate(deletedata,type);
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	public SepoaOut setReqBidDelete(Map<String, Object> deletedata) throws Exception{
		ConnectionContext         ctx      = null;
        SepoaXmlParser            sxp      = null;
		SepoaSQLManager           ssm      = null;
		List<Map<String, String>> deleteParamList = null;
		Map<String, String>       gridInfo = null;
		String                    id       = info.getSession("ID");
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			deleteParamList = (List<Map<String, String>>)MapUtils.getObject(deletedata, "deleteParamList");
			
			for(int i = 0; i < deleteParamList.size(); i++) {
				gridInfo = deleteParamList.get(i);
				
                sxp = new SepoaXmlParser(this, "et_setReqBidHDDelete");
                ssm = new SepoaSQLManager(id, this, ctx, sxp);
                
                ssm.doUpdate(gridInfo);
            }
			
			for(int i = 0; i < deleteParamList.size(); i++) {
				gridInfo = deleteParamList.get(i);
				
                sxp = new SepoaXmlParser(this, "et_setReqBidDTDelete");
                ssm = new SepoaSQLManager(id, this, ctx, sxp);
                
                ssm.doUpdate(gridInfo);
            }
			
			setMessage("삭제되었습니다.");
			
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

	private	int	et_prdtSourcingTypeUpd(ConnectionContext	ctx, String	rfq_no,	String rfq_count ) throws Exception
	{
		int	rtn	= 0;
		String pr_no = "";
		String pr_seq = "";

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
		wxp.addVar("rfq_no", rfq_no);
//		StringBuffer sql = new StringBuffer();

//		sql.append(" SELECT																		\n");
//		sql.append("   PR_NO																	\n");
//		sql.append("   ,PR_SEQ																	\n");
//		sql.append(" FROM ICOYRQDT 																\n");
// 		sql.append(" WHERE HOUSE_CODE		= '"+info.getSession("HOUSE_CODE")+"'	            \n");
//		sql.append("   AND RFQ_NO			= '"+rfq_no+"'										\n");

//		StringBuffer upd_sql = new StringBuffer();

//		upd_sql.append(" UPDATE	ICOYPRDT														\n");
//		upd_sql.append("   SET  SOURCING_TYPE	= 'BID'											\n");
// 		upd_sql.append(" WHERE HOUSE_CODE		= '"+info.getSession("HOUSE_CODE")+"'	 	    \n");
//		upd_sql.append("   AND PR_NO			= ?												\n");
//		upd_sql.append("   AND PR_SEQ		= ?													\n");
//		upd_sql.append("   AND STATUS			IN ('C', 'R')									\n");

		try	{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String rtnSel =	sm.doSelect((String[])null);

			SepoaFormater wf	= new SepoaFormater(rtnSel);

            String recvdata[][] = new String[wf.getRowCount()][];
				for( int i=0; i<wf.getRowCount(); i++ )
				{
					  String Data[]	= {wf.getValue("PR_NO",i)
					  , wf.getValue("PR_SEQ",i)  };
					 recvdata[i]		= Data;
				}
			  wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			  wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			  sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type = {"S", "S" };

			rtn	= sm.doUpdate(recvdata, type);

		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
//
//	public SepoaOut getQTEP(String[] args ) {
//		String lang = info.getSession("LANGUAGE");
//		Message msg = new Message(lang, "STDRFQ");
//
//		try	{
//			String rtn = et_getQTEP(args );
//			setValue(rtn);
//			setStatus(1);
//			setMessage(msg.getMessage("0000"));
//		}catch(Exception e)	{
//			Logger.err.println(info.getSession("ID"),this,e.getMessage());
//			setStatus(0);
//			setMessage(msg.getMessage("0001"));
//		}
//		return getSepoaOut();
//	}
//
//	private	String et_getQTEP(String[] args ) throws	Exception
//	{
//		String rtn = null;
//		ConnectionContext ctx =	getConnectionContext();
//		String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");
//
//		StringBuffer tSQL = new StringBuffer();
//		tSQL.append(" SELECT                                          							\n");
//		tSQL.append("    ITEM_NO                                              					\n");
//		tSQL.append("  , DBO.getItemDesc(HOUSE_CODE, ITEM_NO) AS DESCRIPTION_LOC  					\n");
//		tSQL.append("  , UNIT_PRICE            													\n");
//		tSQL.append("  , PRICE_SEQ            													\n");
//		tSQL.append(" FROM ICOYQTEP                                          					\n");
//		tSQL.append(" <OPT=F,S> WHERE  HOUSE_CODE = ? </OPT>                    				\n");
//		tSQL.append(" <OPT=F,S> AND QTA_NO =  ? </OPT>                           				\n");
//		tSQL.append(" <OPT=F,S> AND QTA_SEQ = ?                  </OPT>           				\n");
//		tSQL.append(" AND  STATUS != 'D'                                    					\n");
//
//		try	{
//			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,tSQL.toString());
//
//			rtn	= sm.doSelect(args);
//		} catch(Exception e) {
//			Logger.err.println(info.getSession("ID"),this,e.getMessage());
//			throw new Exception(e.getMessage());
//		}
//		return rtn;
//	}
//
//    public SepoaOut setCreateQTEP(  String[][] delqtepData
//									, String[][] qtepData )
//    {
//		String lang = info.getSession("LANGUAGE");
//		Message msg = new Message(lang, "STDRFQ");
//        int rtn = 0;
//
//        ConnectionContext ctx = getConnectionContext();
//
//        try {
//        		rtn = setDelQTEP(ctx, delqtepData);
//        		rtn = setInsQTEP(ctx, qtepData);
//
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));
//            Commit();
//
//        }catch(Exception e){
//            try{
//                Rollback();
//            }catch(Exception e1){}
//            //Logger.err.println("Exception e =" + stackTrace(e));
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//           //// Logger.err.println(this,stackTrace(e));
//        }
//
//        return getSepoaOut();
//    }
//
//    public SepoaOut setDeleteQTEP(  String[][] delqtepData )
//    {
//		String lang = info.getSession("LANGUAGE");
//		Message msg = new Message(lang, "STDRFQ");
//        int rtn = 0;
//
//        ConnectionContext ctx = getConnectionContext();
//
//        try {
//				StringBuffer sql = new StringBuffer();
//
//				sql.append(" DELETE FROM ICOYQTEP              \n");
//				sql.append(" WHERE HOUSE_CODE   = ?            \n");
//				sql.append(" AND   QTA_NO       = ?            \n");
//				sql.append(" AND   PRICE_SEQ       = ?         \n");
//				sql.append(" AND   VENDOR_CODE  = ?            \n");
//
//				String[] type =	{ "S","S","S","S" };
//				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
//				rtn	= sm.doInsert(delqtepData, type);
//
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));
//            Commit();
//
//        }catch(Exception e){
//            try{
//                Rollback();
//            }catch(Exception e1){}
//            //Logger.err.println("Exception e =" + stackTrace(e));
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//           //// Logger.err.println(this,stackTrace(e));
//        }
//
//        return getSepoaOut();
//    }
//
//	private	int	setDelQTEP(	ConnectionContext ctx,
//							String[][] delqtepData)throws	Exception
//	{
//		int	rtn	= 0;
//
//		StringBuffer sql = new StringBuffer();
//
//		sql.append(" DELETE FROM ICOYQTEP              \n");
//		sql.append(" WHERE HOUSE_CODE   = ?            \n");
//		sql.append(" AND   QTA_NO       = ?            \n");
//		sql.append(" AND   QTA_SEQ       = ?           \n");
//		sql.append(" AND   VENDOR_CODE  = ?            \n");
//
//		try{
//
//			String[] type =	{ "S","S","S","S" };
//			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
//			rtn	= sm.doInsert(delqtepData, type);
//
//		}catch(Exception e)	{
//			//Logger.err.println(info.getSession("ID"),this,stackTrace(e));
//			throw new Exception(e.getMessage());
//		}
//		return rtn;
//	}
//
//    private int setInsQTEP(ConnectionContext ctx,
//                           String[][] qtepData
//                           ) throws Exception
//    {
//        int rtn = -1;
//
//        SepoaSQLManager sm = null;
//
//        try {
//            StringBuffer sql = new StringBuffer();
//
//            sql.append(" INSERT INTO ICOYQTEP (           \n");
//            sql.append("           HOUSE_CODE             \n");
//            sql.append("          ,QTA_NO                 \n");
//            sql.append("          ,QTA_SEQ                \n");
//            sql.append("          ,PRICE_SEQ              \n");
//            sql.append("          ,COMPANY_CODE           \n");
//            sql.append("          ,VENDOR_CODE            \n");
//            sql.append("          ,STATUS                 \n");
//            sql.append("          ,RFQ_NO                 \n");
//            sql.append("          ,RFQ_COUNT              \n");
//            sql.append("          ,RFQ_SEQ                \n");
//            sql.append("          ,UNIT_PRICE             \n");
//            sql.append("          ,ADD_DATE               \n");
//            sql.append("          ,ADD_TIME               \n");
//            sql.append("          ,ADD_USER_ID            \n");
//            sql.append("          ,CHANGE_DATE            \n");
//            sql.append("          ,CHANGE_TIME            \n");
//            sql.append("          ,CHANGE_USER_ID         \n");
//            sql.append("          ,ITEM_NO         		  \n");
//            sql.append(" ) VALUES (                       \n");
//            sql.append("           ?                      \n");      // HOUSE_CODE
//            sql.append("          ,?                      \n");      // QTA_NO
//            sql.append("          ,?					  \n");      // QTA_SEQ
//            //sql.append("          ,TO_CHAR(?, 'FM000000') \n");      // PRICE_SEQ
//            sql.append("          ,dbo.lpad(?, 6, '0') \n");      // PRICE_SEQ
//            sql.append("          ,?                      \n");      // COMPANY_CODE
//            sql.append("          ,?                      \n");      // VENDOR_CODE
//            sql.append("          ,?                      \n");      // STATUS
//            sql.append("          ,?                      \n");      // RFQ_NO
//            sql.append("          ,?                      \n");      // RFQ_COUNT
//            sql.append("          ,?                      \n");      // RFQ_SEQ
//            sql.append("          ,?                      \n");      // UNIT_PRICE
//            sql.append("          ,?                      \n");      // ADD_DATE
//            sql.append("          ,?                      \n");      // ADD_TIME
//            sql.append("          ,?                      \n");      // ADD_USER_ID
//            sql.append("          ,?                      \n");      // CHANGE_DATE
//            sql.append("          ,?                      \n");      // CHANGE_TIME
//            sql.append("          ,?                      \n");      // CHANGE_USER_ID
//            sql.append("          ,?                      \n");      // ITEM_NO
//            sql.append(" )                                \n");
//
//            sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
//
//            String[] type = {"S", "S", "S", "S", "S"
//            				,"S", "S", "S", "N", "S"
//            				,"N", "S", "S", "S", "S"
//            				,"S", "S" , "S"
//        					};
//            rtn = sm.doInsert(qtepData, type);
//
//        }catch(Exception e) {
//         // Logger.err.println(info.getSession("ID"),this,stackTrace(e));
//          throw new Exception(e.getMessage());
//        }
//        return rtn;
//    }
//
    private String getusername(String ls_id) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        String house_code = info.getSession("HOUSE_CODE");
        String company = info.getSession("COMPANY_CODE");

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	wxp.addVar("house_code", house_code);
        	wxp.addVar("company", company);
        	wxp.addVar("ls_id", ls_id);

//        StringBuffer sql = new StringBuffer();
//        sql.append(" select user_name_loc from icomlusr     \n");
//        sql.append(" where house_code = '"+house_code+"'    \n");
//        sql.append(" and   company_code ='"+company+"'      \n");
//        sql.append(" and   user_id = '"+ls_id+"'            \n");

        try{
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
            rtn = sm.doSelect((String[])null);
        }catch(Exception e) {
        	
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
//
//    /**
//     * 결재반려
//     * <pre>
//     * </pre>
//     * @param all_pr_no
//     * @return
//     * @throws Exception
//     */
//    private int et_setApping_return(String[][] all_pr_no ) throws Exception
//    {
//        int rtn = -1;
//        try {
//          String house_code = info.getSession("HOUSE_CODE");
//
//          ConnectionContext ctx = getConnectionContext();
//
//          StringBuffer sql = new StringBuffer();
//          sql.append(" UPDATE ICOYPRHD SET                 \n");
//          sql.append("        CTRL_REASON = '',            \n");
//          sql.append("        SIGN_STATUS = 'D',           \n");
//          sql.append("        SIGN_DATE = '',              \n");
//          sql.append("        SIGN_PERSON_ID = '',         \n");
//          sql.append("        SIGN_PERSON_NAME = ''        \n");
//          sql.append(" WHERE HOUSE_CODE = '"+house_code+"' \n");
//          sql.append(" AND   STATUS != 'D'                 \n");
//          sql.append(" AND   PR_NO = ?                     \n");
//          String[] type = {"S"};
//          SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
//          rtn = sm.doUpdate(all_pr_no, type);
//      }catch(Exception e) {
//          throw new Exception("setSIGN_STATUS:"+e.getMessage());
//      }
//      return rtn;
//  }
//
    public SepoaOut getBidHistory (String[] args){
		String lang = info.getSession("LANGUAGE");

        try{
        	String rtn = et_getBidHistory(args);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.get("STDRFQ.0000"));
        }catch(Exception e){
            setStatus(0);
            setMessage(msg.get("STDRFQ.0001"));
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
        }
        return getSepoaOut();
    }

	private	String et_getBidHistory(String[] args) throws Exception
	{
    	String rtn = null;
		String ctrl_code	= info.getSession("CTRL_CODE");
		String purchaserUser_seperate="";

			StringTokenizer	st1	= new StringTokenizer(ctrl_code,"&",false);
			int	count1 =  st1.countTokens();

			for( int i =0; i< count1; i++ )
			{
				String tmp_ctrl_code = st1.nextToken();

				if(	i == 0 )
					purchaserUser_seperate = tmp_ctrl_code;
				else
					purchaserUser_seperate += "','"+tmp_ctrl_code;

			}
        ConnectionContext ctx = getConnectionContext();

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("purchaserUser_seperate", purchaserUser_seperate);
//        StringBuffer sql = new StringBuffer();

//		sql.append(" SELECT DISTINCT  RQHD.RFQ_NO,                                                      \n");
//        sql.append("       RQHD.RFQ_COUNT,                                                            	\n");
//        sql.append("       RQHD.SUBJECT,                                                              	\n");
//        sql.append("       RQSE.VENDOR_CODE,                                                          	\n");
//        sql.append("       dbo.GETCOMPANYNAMELOC(RQSE.HOUSE_CODE,RQSE.VENDOR_CODE,'S') AS VENDOR_NAME,    	\n");
//        sql.append("       CASE RQSE.BID_FLAG WHEN 'N' THEN '입찰포기' ELSE QTHD.QTA_NO END AS QTA_NO,  \n");
//        sql.append("       QTHD.CHANGE_DATE,                                                          	\n");
//        sql.append("       dbo.dateFormat( RQHD.RFQ_CLOSE_DATE + RQHD.RFQ_CLOSE_TIME , 'YYYY/MM/DD HH24:MI:SS') AS CLOSE_DATE, \n");
//        sql.append("       RQHD.CHANGE_USER_ID,                                                       \n");
//        sql.append("       dbo.Getusernameloc(RQHD.HOUSE_CODE, RQHD.CHANGE_USER_ID) AS CHANGE_USER_NAME,  \n");
//        sql.append("       RQSE.CONFIRM_DATE,                                                         \n");
//        sql.append("       RQHD.CTRL_CODE,                                                            \n");
//        sql.append("       RQHD.RFQ_CLOSE_DATE + RQHD.RFQ_CLOSE_TIME AS CLOSE_DATA,                    \n");
//        sql.append("	   QTHD.QTA_VAL_DATE                   										  \n");
//        sql.append("	  , dbo.GETICOMCODE2(RQHD.HOUSE_CODE,'M208', RQHD.BID_REQ_TYPE) AS BID_REQ_TYPE		\n");
//        sql.append(" FROM                                                                             \n");
//        sql.append(" 	ICOYRQHD RQHD                                                                 \n");
//        sql.append(" 	,ICOYRQSE RQSE LEFT OUTER JOIN                                                \n");
//        sql.append(" 	ICOYQTHD QTHD                                                                 \n");
//        sql.append("   ON  RQSE.HOUSE_CODE = QTHD.HOUSE_CODE                                            \n");
//        sql.append("   AND RQSE.VENDOR_CODE = QTHD.VENDOR_CODE                                          \n");
//        sql.append("   AND RQSE.RFQ_NO = QTHD.RFQ_NO                                                    \n");
//        sql.append("   AND RQSE.RFQ_COUNT = QTHD.RFQ_COUNT                                              \n");
//        sql.append("   <OPT=F,S> WHERE RQHD.HOUSE_CODE = ?			</OPT>                            \n");
//        sql.append("   AND RQHD.HOUSE_CODE = RQSE.HOUSE_CODE                                          \n");
//        sql.append("   AND RQHD.RFQ_NO = RQSE.RFQ_NO                                                  \n");
//        sql.append("   AND RQHD.RFQ_COUNT = RQSE.RFQ_COUNT                                            \n");
//        sql.append("                                                                                  \n");
//        sql.append("                                                                                  \n");
//        sql.append("   <OPT=F,S> AND RQHD.RFQ_CLOSE_DATE BETWEEN ? 	</OPT>                            \n");
//        sql.append("   <OPT=F,S> AND ?								</OPT>                            \n");
//        sql.append("	AND RQHD.CTRL_CODE IN ('"+purchaserUser_seperate+"')                          \n");
//        sql.append("   <OPT=S,S> AND RQHD.CHANGE_USER_ID LIKE ? 		</OPT>                        \n");
//        sql.append("   <OPT=S,S> AND QTHD.VENDOR_CODE LIKE ? 		</OPT>                            \n");
//        sql.append("   <OPT=S,S> AND RQHD.RFQ_NO LIKE ? 			</OPT>                            \n");
//        sql.append("   <OPT=S,S> AND RQHD.SUBJECT LIKE '%'+?+'%'	</OPT>                            \n");
//        sql.append("   AND RQHD.RFQ_FLAG IN ('P','C')                                                 \n");
//        sql.append("   AND RQHD.RFQ_TYPE <> 'MA'                                                      \n");
//        sql.append("   AND RQHD.BID_TYPE = 'EX'                                                       \n");
//        sql.append("   AND RQSE.BID_FLAG is not null                                  				  \n");
//        sql.append("   AND RQHD.STATUS IN ('C','R')                                                   \n");
//        sql.append("   AND RQSE.STATUS IN ('C','R')                                                   \n");
//        sql.append(" ORDER BY RQHD.RFQ_NO DESC 														  \n");
//        sql.append(" 		, RQHD.RFQ_COUNT DESC 													  \n");
//        sql.append(" 		, RQSE.VENDOR_CODE 														  \n");

 		try{
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
            rtn = sm.doSelect(args);
        }catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

	private	String DoWorkWithCtrl_code(String purchaserUser)
	{
		String ctrl_code	= info.getSession("CTRL_CODE");
		///////////////////////	직무 코드 관련 처리
		//입력된 직무코드 가 세션상의 직무 코드에 속하면 where 절에	세션사의 직무 코드가 들어가며 그렇지 않으면	입력된 직무코드가 들어간다.
		boolean	flag = false;

		StringTokenizer	st = new StringTokenizer(ctrl_code,"&",false);
		int	count =	 st.countTokens();

		for( int i =0; i< count; i++ )
		{
			String tmp_ctrl_code = st.nextToken();
			if(	purchaserUser.equals(tmp_ctrl_code)	){
				flag = true;

				Logger.debug.println(info.getSession("ID"),this,"============================same ctrl_code");
				break;
			}
			else
				Logger.debug.println(info.getSession("ID"),this,"==============================	not	same ctrl_code");

		}


		String purchaserUser_seperate="";

		if(	flag ==	true )
		{
			StringTokenizer	st1	= new StringTokenizer(ctrl_code,"&",false);
			int	count1 =  st1.countTokens();

			for( int i =0; i< count1; i++ )
			{
				String tmp_ctrl_code = st1.nextToken();

				if(	i == 0 )
					purchaserUser_seperate = tmp_ctrl_code;
				else
					purchaserUser_seperate += "','"+tmp_ctrl_code;

			}
				Logger.debug.println(info.getSession("ID"),this,"==============================	purchaserUser_seperate=="+purchaserUser_seperate);
		}
		else
		{
			purchaserUser_seperate = purchaserUser;
		}
		////////////////////////직무 코드	관련 처리 끝

		return purchaserUser_seperate;

	}

    public SepoaOut getRQHDDisplay(String[] args)
    {
        try
        {
            String lang            =  info.getSession("LANGUAGE");

            String rtnHD = et_getRQHDDisplay(args);
            setStatus(1);
            setValue(rtnHD);
            setMessage(msg.get("STDCOMM.0000"));
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            setStatus(0);

            String lang            =  info.getSession("LANGUAGE");

            setMessage(msg.get("p10_pra.0001"));
        }
        return getSepoaOut();
    }//End of prHDQueryDisplay()

    private String et_getRQHDDisplay(String[] args) throws Exception
    {

        String rtn = null;

        try
        {
            String user_id         =  info.getSession("ID");
            String house_code      =  info.getSession("HOUSE_CODE");
            ConnectionContext ctx = getConnectionContext();

//            StringBuffer sql = new StringBuffer();
            String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//			sql.append("SELECT DISTINCT RQHD.SUBJECT															\n");
//			sql.append("	, RQHD.RFQ_NO         																\n");
//			sql.append("	, RQHD.RFQ_COUNT         															\n");
//			sql.append("	, (SELECT COUNT(*) FROM ICOYTBUS WHERE DOC_NO = RQHD.RFQ_NO AND DOC_SEQ = RQHD.RFQ_COUNT) AS USER_CNT         	\n");
//			sql.append("	, dbo.Getusernameloc(RQHD.HOUSE_CODE,RQHD.CHANGE_USER_ID) AS CHANGE_USER_NAME         	\n");
//			sql.append("	, dbo.dateFormat(RQHD.CHANGE_DATE , 'YYYY/MM/DD') AS  CHANGE_DATE                       \n");
//			sql.append("	, (SELECT   TEXT1                                                                   \n");
//			sql.append("		FROM ICOMCODE                                                                   \n");
//			sql.append("		WHERE TYPE = 'M999'                                                             \n");
//			sql.append("		AND HOUSE_CODE = RQHD.HOUSE_CODE                                                \n");
//			sql.append("  <OPT=F,S> AND CODE = ? </OPT>                                                        	\n");
//			sql.append("		AND USE_FLAG = 'Y'                                                              \n");
//			sql.append("		AND FLAG = 'S'                                                                  \n");
//			sql.append("		AND STATUS IN('C','R')  ) AS DOC_NAME                                           \n");
//			sql.append("	, dbo.GETDEPTNAME(PRHD.HOUSE_CODE,PRHD.COMPANY_CODE,PRHD.DEMAND_DEPT,'') AS DEMAND_DEPT_NAME   \n");
//			sql.append("	, dbo.Getusernameloc(PRHD.HOUSE_CODE,PRHD.CHANGE_USER_ID) AS PR_ADD_USER_NAME           \n");
//			sql.append("	, PRHD.CUST_NAME                                                                    \n");
//			sql.append("	, PRHD.ORDER_NO                                                                     \n");
//			sql.append("	, PRHD.ORDER_NAME                                                                   \n");
//			sql.append("	, RQHD.BID_REQ_TYPE               													\n");
//			sql.append("	, dbo.GETICOMCODE2(RQHD.HOUSE_CODE, 'M138', RQHD.BID_REQ_TYPE) AS BID_REQ_TYPE_NAME     \n");
//			sql.append("	, dbo.GETICOMCODE2(RQHD.HOUSE_CODE, 'M112',RQHD.RFQ_TYPE ) AS RFQ_TYPE               	\n");
////			sql.append("	, dbo.dateFormat( RQHD.RFQ_CLOSE_DATE+RQHD.RFQ_CLOSE_TIME , 'YYYY/MM/DD HH24:MI:SS') AS CLOSE_DATE	\n");
//			sql.append("	, dbo.dateFormat( dbo.convert_date(RQHD.RFQ_CLOSE_DATE) + ' ' + dbo.convert_time(RQHD.RFQ_CLOSE_TIME + '00') , 'YYYY/MM/DD HH24:MI') AS CLOSE_DATE	\n");
//			sql.append("	, dbo.dateFormat( dbo.convert_date(RQHD.START_DATE) + ' ' + dbo.convert_time(RQHD.START_TIME + '00') , 'YYYY/MM/DD HH24:MI') AS START_DATE	\n");
//			sql.append("	, RQHD.BID_TECHNIQUE_EVAL               														\n");
//			sql.append("	, RQHD.BID_PRICE_EVAL               															\n");
//			sql.append("	, (SELECT  dbo.dateFormat(ANNOUNCE_DATE , 'YYYY/MM/DD') +' '+ dbo.dateFormat(dbo.convert_time(ANNOUNCE_TIME_FROM + '00') ,'HH24:MI') + '~'+ dbo.dateFormat(dbo.convert_time(ANNOUNCE_TIME_TO + '00') ,'HH24:MI')			\n");
//			sql.append("		FROM ICOYRQAN WHERE HOUSE_CODE = RQHD.HOUSE_CODE AND RFQ_NO = RQHD.RFQ_NO AND RFQ_COUNT = RQHD.RFQ_COUNT)	AS ANNOUNCE_DATE		\n");
//			sql.append("	, RQHD.ATTACH_NO               																		\n");
//        	sql.append(" 	, dbo.GETFILEATTCOUNT(RQHD.ATTACH_NO) AS ATTACH_COUNT                   								\n");
//        	sql.append(" 	, dbo.GETICOMCODE2(PRHD.HOUSE_CODE, 'M165', PRHD.HARD_MAINTANCE_TERM) AS HARD_MAINTANCE_TERM			\n");
//        	sql.append(" 	, dbo.GETICOMCODE2(PRHD.HOUSE_CODE, 'M165', PRHD.SOFT_MAINTANCE_TERM) AS SOFT_MAINTANCE_TERM			\n");
//        	sql.append("	, PRHD.EXPECT_AMT																	\n");
//        	sql.append("    ,RQDT.VALID_FROM_DATE                 													\n");
//        	sql.append("    ,RQDT.VALID_TO_DATE                 														\n");
//        	sql.append(" 	, RQHD.START_DATE   AS RFQ_DATE                                                           \n");
//        	sql.append("   ,(SELECT COUNT(*)                                                                  		\n");
//        	sql.append("    FROM   ICOYRQAN                                                                   		\n");
//        	sql.append("    WHERE  HOUSE_CODE = RQHD.HOUSE_CODE                                                  	\n");
//        	sql.append("    AND    RFQ_NO     = RQHD.RFQ_NO                                                      	\n");
//        	sql.append("    AND    RFQ_COUNT  = RQHD.RFQ_COUNT                                                   	\n");
//        	sql.append("    ) AS   RQAN_CNT                                                                   		\n");
//        	sql.append("   ,(SELECT COUNT(*)                                                                  		\n");
//        	sql.append("    FROM   ICOYTBEV                                                                   		\n");
//        	sql.append("    WHERE  HOUSE_CODE = RQHD.HOUSE_CODE                                                  	\n");
//        	sql.append("    AND    DOC_NO     = RQHD.RFQ_NO                                                      	\n");
//        	sql.append("    AND    DOC_SEQ    = RQHD.RFQ_COUNT                                                   	\n");
//        	sql.append("    ) AS   TBEV_CNT                                                                   		\n");
//        	sql.append("   , RQHD.BD_TYPE                                                                            \n");
//        	sql.append("   , PRHD.PR_NO                                                                            \n");
//        	sql.append("   , (SELECT DISTINCT WBS_TXT FROM ICOYPRDT  WHERE HOUSE_CODE = PRHD.HOUSE_CODE AND PR_NO = PRHD.PR_NO) AS  WBS_TXT   \n");
//        	sql.append("FROM ICOYRQHD RQHD, ICOYRQDT RQDT, ICOYPRHD PRHD                                        \n");
//			sql.append("  <OPT=F,S> WHERE RQHD.HOUSE_CODE = ? </OPT>                                       		\n");
//			sql.append("  <OPT=F,S> AND RQHD.RFQ_NO = ? </OPT>                                       			\n");
//			sql.append("  <OPT=F,S> AND RQHD.RFQ_COUNT = ? </OPT>                                       		\n");
//			sql.append("AND RQHD.HOUSE_CODE = RQDT.HOUSE_CODE                                           		\n");
//			sql.append("AND RQHD.COMPANY_CODE = RQDT.COMPANY_CODE                                               \n");
//			sql.append("AND RQHD.RFQ_NO = RQDT.RFQ_NO                                                           \n");
//			sql.append("AND RQHD.RFQ_COUNT = RQDT.RFQ_COUNT                                                     \n");
//			sql.append("AND RQDT.HOUSE_CODE = PRHD.HOUSE_CODE                                                   \n");
//			sql.append("AND RQDT.PR_NO = PRHD.PR_NO                                                             \n");
//			sql.append("AND RQHD.BID_TYPE = 'EX'                                                                \n");
//			sql.append("AND RQHD.STATUS IN ('C','R')                                                            \n");
//			sql.append("AND PRHD.STATUS IN ('C','R')                                                            \n");

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn = sm.doSelect(args);
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }//End of et_rqHDDisplay()
//
    public SepoaOut getRQDTDisplay(String[] args)
    {
        try
        {
            String lang            =  info.getSession("LANGUAGE");

            String rtnHD = et_getRQDTDisplay(args);
            setStatus(1);
            setValue(rtnHD);
            setMessage(msg.get("STDCOMM.0000"));
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            setStatus(0);

            String lang            =  info.getSession("LANGUAGE");

            setMessage(msg.get("p10_pra.0001"));
        }
        return getSepoaOut();
    }//End of getRQDTDisplay()

    private String et_getRQDTDisplay(String[] args) throws Exception
    {

        String rtn = null;

        try
        {
            String user_id         =  info.getSession("ID");
            String house_code      =  info.getSession("HOUSE_CODE");
            ConnectionContext ctx = getConnectionContext();

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//            StringBuffer sql = new StringBuffer();
            String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");
//			sql.append("SELECT VENDOR_NAME,  VENDOR_CODE, SCORE_EVAL, PRICE_EVAL,   TTL_AMT , ITEM_NO			\n");
//			sql.append("	,DESCRIPTION_LOC, MAKER_NAME, UNIT_MEASURE,  DISCOUNT  , QTA_NO						\n");
//			sql.append("FROM (																					\n");
//			sql.append("	SELECT		DISTINCT																													\n");
//			sql.append("		dbo.getCompanyNameLoc(HD.HOUSE_CODE, QT.VENDOR_CODE, 'S') AS VENDOR_NAME                                                        \n");
//			sql.append("		, QT.VENDOR_CODE                                                                                                             \n");
//			sql.append("		, ROUND(dbo.getTechnique_Price_Eval(HD.HOUSE_CODE, HD.RFQ_NO, HD.RFQ_COUNT, HD.BID_TECHNIQUE_EVAL                               \n");
//			sql.append("		   ,(SELECT SUM(SCORE) AS SCORE FROM ICOYTBSE                                                                                  \n");
//			sql.append("			WHERE HOUSE_CODE = QT.HOUSE_CODE AND DOC_NO = QT.RFQ_NO                                                                 \n");
//			sql.append("			AND DOC_SEQ = QT.RFQ_COUNT AND VENDOR_CODE = QT.VENDOR_CODE ), 'T', qt.vendor_code),1) AS SCORE_EVAL                                    \n");
//			sql.append("		, ROUND(dbo.getTechnique_Price_Eval(QT.HOUSE_CODE, QT.RFQ_NO, QT.RFQ_COUNT, HD.BID_PRICE_EVAL,QH.TTL_AMT, 'P', qt.vendor_code),1) AS PRICE_EVAL \n");
//			sql.append("		, QH.TTL_AMT                                                                                                             \n");
//			sql.append("		, QT.ITEM_NO                                                                                                                \n");
//			sql.append("		, dbo.getItemDesc(QT.HOUSE_CODE, QT.ITEM_NO) AS DESCRIPTION_LOC                                                                 \n");
//			sql.append("		, (SELECT MAKER_NAME FROM ICOYPRDT WHERE HOUSE_CODE = DT.HOUSE_CODE AND PR_NO = DT.PR_NO AND PR_SEQ = DT.PR_SEQ) AS MAKER_NAME            \n");
//			sql.append("		, DT.UNIT_MEASURE                                                                                                           \n");
//			sql.append("		, DT.RFQ_QTY                                                                                                                \n");
//			sql.append("		, QT.DISCOUNT                                                                                                               \n");
//			sql.append("		, QT.QTA_NO                                                                                                                 \n");
//			sql.append("	FROM  ICOYRQHD HD, ICOYRQDT DT, ICOYRQSE RS, ICOYQTHD QH, ICOYQTDT QT                                                           \n");
//			sql.append("	  <OPT=F,S> WHERE HD.HOUSE_CODE = ? </OPT>                                       		\n");
//			sql.append("	  <OPT=F,S> AND HD.RFQ_NO = ? </OPT>                                       				\n");
//			sql.append("	  <OPT=F,S> AND HD.RFQ_COUNT = ? </OPT>                                       			\n");
//			sql.append("	  AND HD.HOUSE_CODE = DT.HOUSE_CODE																								\n");
//			sql.append("	  AND HD.RFQ_NO = DT.RFQ_NO                                                                                                     \n");
//			sql.append("	  AND HD.RFQ_COUNT = DT.RFQ_COUNT                                                                                               \n");
//			sql.append("	  AND DT.HOUSE_CODE = RS.HOUSE_CODE                                                                                             \n");
//			sql.append("	  AND DT.RFQ_NO = RS.RFQ_NO                                                                                                     \n");
//			sql.append("	  AND DT.RFQ_COUNT = RS.RFQ_COUNT                                                                                               \n");
//			sql.append("	  AND DT.RFQ_SEQ = RS.RFQ_SEQ                                                                                                   \n");
//			sql.append("	  AND RS.HOUSE_CODE = QH.HOUSE_CODE                                                                                             \n");
//			sql.append("	  AND RS.VENDOR_CODE = QH.VENDOR_CODE                                                                                           \n");
//			sql.append("	  AND RS.RFQ_NO = QH.RFQ_NO                                                                                                     \n");
//			sql.append("	  AND RS.RFQ_COUNT = QH.RFQ_COUNT                                                                                               \n");
//			sql.append("	  AND QH.HOUSE_CODE = QT.HOUSE_CODE                                                                                             \n");
//			sql.append("	  AND QH.VENDOR_CODE = QT.VENDOR_CODE                                                                                           \n");
//			sql.append("	  AND QH.QTA_NO = QT.QTA_NO                                                                                                     \n");
//			sql.append("	  AND QT.QTA_SEQ = QT.QTA_SEQ                                                                                                   \n");
//			//sql.append("	  AND QT.SETTLE_FLAG =  'Y'                                                                                                     \n");
//			sql.append("	  AND HD.STATUS != 'D'                                                                                                          \n");
//			sql.append("	  AND DT.STATUS != 'D'                                                                                                          \n");
//			sql.append("	  AND RS.STATUS != 'D'                                                                                                          \n");
//			sql.append("	  AND QH.STATUS != 'D'                                                                                                          \n");
//			sql.append("	  AND QT.STATUS != 'D'                                                                                                          \n");
//			sql.append(") as a GROUP BY VENDOR_NAME,  VENDOR_CODE, SCORE_EVAL, PRICE_EVAL,  TTL_AMT ,  ITEM_NO                                 \n");
//			sql.append("	,DESCRIPTION_LOC, MAKER_NAME, UNIT_MEASURE,  DISCOUNT  , QTA_NO                                                             \n");
// 			sql.append("  ORDER BY 1                                                         \n");
            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn = sm.doSelect(args);
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }//End of et_rqDTDisplay()

    public SepoaOut getSettleInfoDisplay(String[] args)
    {
        try
        {
            String lang            =  info.getSession("LANGUAGE");

            String rtnHD = et_getSettleInfoDisplay(args);
            setStatus(1);
            setValue(rtnHD);
            setMessage(msg.get("STDCOMM.0000"));
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            setStatus(0);

            String lang            =  info.getSession("LANGUAGE");

            setMessage(msg.get("p10_pra.0001"));
        }
        return getSepoaOut();
    }//End of prHDQueryDisplay()

    private String et_getSettleInfoDisplay(String[] args) throws Exception
    {

        String rtn = null;

        try
        {
            String user_id         =  info.getSession("ID");
            String house_code      =  info.getSession("HOUSE_CODE");
            ConnectionContext ctx = getConnectionContext();

//            StringBuffer sql = new StringBuffer();
            String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//            sql.append("SELECT SETTLE_VENDOR_NAME,  sum(SETTLE_AMT) AS SETTLE_AMT,  SCORE_EVAL, PRICE_EVAL, SETTLE_REMARK, SCORE_EVAL + PRICE_EVAL as score FROM (							\n");
//			sql.append("	SELECT	DISTINCT																												\n");
//			sql.append("		dbo.getCompanyNameLoc(HD.HOUSE_CODE, QT.VENDOR_CODE, 'S') AS SETTLE_VENDOR_NAME													\n");
//			sql.append("		, QT.ITEM_QTY                                                                                                               \n");
//			sql.append("		, QT.ITEM_QTY * QT.UNIT_PRICE  AS SETTLE_AMT                                                                                \n");
//			sql.append("		, ROUND(dbo.getTechnique_Price_Eval(HD.HOUSE_CODE, HD.RFQ_NO, HD.RFQ_COUNT, HD.BID_TECHNIQUE_EVAL                               \n");
//			sql.append("		,(SELECT SUM(SCORE) AS SCORE FROM ICOYTBSE                                                                                  \n");
//			sql.append("			WHERE HOUSE_CODE = QT.HOUSE_CODE AND DOC_NO = QT.RFQ_NO                                                                 \n");
//			sql.append("	   		AND DOC_SEQ = QT.RFQ_COUNT AND VENDOR_CODE = QT.VENDOR_CODE ), 'T', QT.VENDOR_CODE),1) AS SCORE_EVAL                                    \n");
//			sql.append("		, ROUND(dbo.getTechnique_Price_Eval(QT.HOUSE_CODE, QT.RFQ_NO, QT.RFQ_COUNT, HD.BID_PRICE_EVAL,QH.TTL_AMT, 'P', QT.VENDOR_CODE),1) AS PRICE_EVAL \n");
//			sql.append("		, QT.SETTLE_REMARK                                                                                                          \n");
//			sql.append("	FROM  ICOYRQHD HD, ICOYRQDT DT, ICOYRQSE RS, ICOYQTHD QH, ICOYQTDT QT                                                           \n");
//			sql.append("	  <OPT=F,S> WHERE HD.HOUSE_CODE = ? </OPT>                                       												\n");
//			sql.append("	  <OPT=F,S> AND HD.RFQ_NO = ? </OPT>                                       														\n");
//			sql.append("	  <OPT=F,S> AND HD.RFQ_COUNT = ? </OPT>                                       													\n");
//			sql.append("	  AND HD.HOUSE_CODE = DT.HOUSE_CODE                                                                                             \n");
//			sql.append("	  AND HD.RFQ_NO = DT.RFQ_NO                                                                                                     \n");
//			sql.append("	  AND HD.RFQ_COUNT = DT.RFQ_COUNT                                                                                               \n");
//			sql.append("	  AND DT.HOUSE_CODE = RS.HOUSE_CODE                                                                                             \n");
//			sql.append("	  AND DT.RFQ_NO = RS.RFQ_NO                                                                                                     \n");
//			sql.append("	  AND DT.RFQ_COUNT = RS.RFQ_COUNT                                                                                               \n");
//			sql.append("	  AND DT.RFQ_SEQ = RS.RFQ_SEQ                                                                                                   \n");
//			sql.append("	  AND RS.HOUSE_CODE = QH.HOUSE_CODE                                                                                             \n");
//			sql.append("	  AND RS.VENDOR_CODE = QH.VENDOR_CODE                                                                                           \n");
//			sql.append("	  AND RS.RFQ_NO = QH.RFQ_NO                                                                                                     \n");
//			sql.append("	  AND RS.RFQ_COUNT = QH.RFQ_COUNT                                                                                               \n");
//			sql.append("	  AND QH.HOUSE_CODE = QT.HOUSE_CODE                                                                                             \n");
//			sql.append("	  AND QH.VENDOR_CODE = QT.VENDOR_CODE                                                                                           \n");
//			sql.append("	  AND QH.QTA_NO = QT.QTA_NO                                                                                                     \n");
//			sql.append("	  AND QT.QTA_SEQ = QT.QTA_SEQ                                                                                                   \n");
//			sql.append("	  AND QT.SETTLE_FLAG =  'Y'                                                                                                     \n");
//			sql.append("	  AND HD.STATUS != 'D'                                                                                                          \n");
//			sql.append("	  AND DT.STATUS != 'D'                                                                                                          \n");
//			sql.append("	  AND RS.STATUS != 'D'                                                                                                          \n");
//			sql.append("	  AND QH.STATUS != 'D'                                                                                                          \n");
//			sql.append("	  AND QT.STATUS != 'D'    ) as a group by SETTLE_VENDOR_NAME,  SCORE_EVAL,  PRICE_EVAL,  SETTLE_REMARK                        \n");

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn = sm.doSelect(args);

        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }//End of et_rqHDDisplay()

    public SepoaOut ReqBidHD11QueryDisplay(String[] args)
    {
        try
        {
            String lang            =  info.getSession("LANGUAGE");

            String rtnHD = et_reqBidHD11QueryDisplay(args);
            setStatus(1);
            setValue(rtnHD);
            setMessage(msg.get("STDCOMM.0000"));
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            setStatus(0);

            String lang            =  info.getSession("LANGUAGE");

            setMessage(msg.get("p10_pra.0001"));
        }
        return getSepoaOut();
    }//End of prHDQueryDisplay()

    private String et_reqBidHD11QueryDisplay(String[] args) throws Exception
    {

        String rtn = null;

        try
        {
            String user_id         =  info.getSession("ID");
            String house_code      =  info.getSession("HOUSE_CODE");
            String company_code      =  info.getSession("COMPANY_CODE");
            ConnectionContext ctx = getConnectionContext();

//            StringBuffer sql = new StringBuffer();
            String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            	wxp.addVar("house_code",house_code);
            	wxp.addVar("company_code", company_code);

//            sql.append(" SELECT                                                                             \n");
//            sql.append("   H.PR_NO                                                                     		\n");
//            sql.append("      , H.SUBJECT                                                                   \n");
//            sql.append("      , H.ORDER_NO                                                                  \n");
//            sql.append("      , H.ORDER_NAME                                                                \n");
//            sql.append("      , H.ADD_DATE                                                                  \n");
//            sql.append("      , dbo.getDeptNameLoc('" + house_code + "','"+company_code+"', H.DEMAND_DEPT) AS DEMAND_DEPT_NAME  \n");
//            sql.append("      , H.DEMAND_DEPT                                                               \n");
//            sql.append("      , H.ADD_USER_ID                                                               \n");
//            sql.append("      , dbo.Getusernameloc('" + house_code + "', H.ADD_USER_ID) AS ADD_USER_NAME    \n");
//            sql.append("      , H.PR_TYPE                                                                   \n");
//            sql.append("      , H.REMARK                                                                    \n");
//            sql.append("	  , H.RETURN_HOPE_DAY                                     						\n");
//            sql.append("	  , H.ATTACH_NO                                     							\n");
//        	sql.append(" 	  , dbo.GETFILEATTCOUNT(H.ATTACH_NO) AS ATT_COUNT                   			\n");
//        	sql.append("	  , H.PROJECT_FLAG                                     							\n");
//        	sql.append("	  , H.PROJECT_DEPT                                     							\n");
//        	sql.append("	  , H.PROJECT_PM                                     							\n");
//        	sql.append("	  , H.CONTRACT_HOPE_DAY                                     					\n");
//        	sql.append("	  , CONVERT(FLOAT,CONVERT(NUMERIC(22,5),H.ORDER_POSSIBLE_AMT)) AS   ORDER_POSSIBLE_AMT                                  					\n");
//        	sql.append("	  , H.DELIVERY_PLACE                                   						\n");
//        	sql.append("	  , H.DELIVERY_PLACE_INFO                                     					\n");
//        	sql.append("	  , H.USAGE                                     								\n");
//            sql.append("	  , H.CREATE_TYPE                                     							\n");
//            sql.append("	  , H.PR_TOT_AMT                                     							\n");
//            sql.append("      , dbo.convert_date(H.ADD_DATE) AS ADD_DATE_VIEW                               \n");
//            sql.append("      , dbo.convert_date(H.RETURN_HOPE_DAY) AS RETURN_HOPE_DAY_VIEW                 \n");
//            sql.append(" FROM ICOYPRHD H                                                                    \n");
//            sql.append(" WHERE    H.HOUSE_CODE    =   '" + house_code + "'                                  \n");
//            sql.append(" AND  H.STATUS        !=  'D'                                                       \n");
//            sql.append(" <OPT=F,S> AND  H.PR_NO         =   ? </OPT>                                        \n");

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn = sm.doSelect(args);
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }//End of et_prQueryDisplayHD()


    public SepoaOut ReqGetProjectInfo(String[] args)
    {
        try
        {
            String lang            =  info.getSession("LANGUAGE");

            String rtnHD = et_getProjectInfo(args);
            setStatus(1);
            setValue(rtnHD);
            setMessage(msg.get("STDCOMM.0000"));
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            setStatus(0);

            String lang            =  info.getSession("LANGUAGE");

            setMessage(msg.get("p10_pra.0001"));
        }
        return getSepoaOut();
    }//End of prHDQueryDisplay()

    private String et_getProjectInfo(String[] args) throws Exception
    {
        String rtn = null;

        try
        {
            String user_id         =  info.getSession("ID");
            String house_code      =  info.getSession("HOUSE_CODE");
            String company_code      =  info.getSession("COMPANY_CODE");
            ConnectionContext ctx = getConnectionContext();

//            StringBuffer sql = new StringBuffer();
            String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");

            SepoaXmlParser wxp = new SepoaXmlParser (this, new Exception().getStackTrace()[0].getMethodName());
            	wxp.addVar("house_code", house_code);
//            sql = new StringBuffer();
//          	sql.append( " SELECT ITEM_NO, DESCRIPTION_LOC, SPECIFICATION		\n " );
//          	sql.append( " FROM ICOMMTGL											\n " );
//          	sql.append( " WHERE HOUSE_CODE = '"+house_code+"'                   \n " );
//          	sql.append( " AND ITEM_NO = 'PJ00000001'                         	\n " );

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn = sm.doSelect((String[])null);
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

    /*
     * 변경계약시 구매요청 화면
     */
    public SepoaOut chContPrBrDisplay(String[] args)
    {
    	try
    	{
    		String lang            =  info.getSession("LANGUAGE");
    		
    		String rtnHD = et_chContPrBrDisplay(args);
    		setStatus(1);
    		setValue(rtnHD);
    		setMessage(msg.get("STDCOMM.0000"));
    	}
    	catch(Exception e)
    	{
    		Logger.err.println(info.getSession("ID"),this,e.getMessage());
    		setStatus(0);
    		
    		String lang            =  info.getSession("LANGUAGE");
    		
    		setMessage(msg.get("p10_pra.0001"));
    	}
    	return getSepoaOut();
    }//End of prHDQueryDisplay()
    
    private String et_chContPrBrDisplay(String[] args) throws Exception
    {
    	
    	String rtn = null;
    	
    	try
    	{
    		String user_id         =  info.getSession("ID");
    		String house_code      =  info.getSession("HOUSE_CODE");
    		String company_code    =  info.getSession("COMPANY_CODE");
    		ConnectionContext ctx  = getConnectionContext();
    		

    		String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");
    		
    		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    		wxp.addVar("house_code", house_code);
    		wxp.addVar("company_code", company_code);
    		wxp.addVar("PO_NO", args[0]);
    		
    		SepoaSQLManager sm = new SepoaSQLManager(user_id,this, ctx, wxp.getQuery());
    		rtn = sm.doSelect((String[])null);
    	}
    	catch(Exception e)
    	{
    		Logger.err.println(info.getSession("ID"),this,e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	return rtn;
    }//End of et_prQueryDisplayHD()
    
    public SepoaOut chContReqBidHDQueryDisplay(String[] args)
    {
    	try
    	{
    		String lang            =  info.getSession("LANGUAGE");
    		
    		String rtnHD = et_chContreqBidHDQueryDisplay(args);
    		setStatus(1);
    		setValue(rtnHD);
    		setMessage(msg.get("STDCOMM.0000"));
    	}
    	catch(Exception e)
    	{
    		Logger.err.println(info.getSession("ID"),this,e.getMessage());
    		setStatus(0);
    		
    		String lang            =  info.getSession("LANGUAGE");
    		
    		setMessage(msg.get("p10_pra.0001"));
    	}
    	return getSepoaOut();
    }//End of prHDQueryDisplay()
    
    private String et_chContreqBidHDQueryDisplay(String[] args) throws Exception
    {
    	
    	String rtn = null;
    	
    	try
    	{
    		String user_id         =  info.getSession("ID");
    		String house_code      =  info.getSession("HOUSE_CODE");
    		String company_code      =  info.getSession("COMPANY_CODE");
    		ConnectionContext ctx = getConnectionContext();
    		

    		String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");
    		
    		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    		wxp.addVar("house_code", house_code);
    		wxp.addVar("company_code", company_code);
    		wxp.addVar("house_code", house_code);
    		wxp.addVar("PO_NO", args[0]);
    		
    		SepoaSQLManager sm = new SepoaSQLManager(user_id,this, ctx, wxp.getQuery());
    		rtn = sm.doSelect((String[])null);
    	}
    	catch(Exception e)
    	{
    		Logger.err.println(info.getSession("ID"),this,e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	return rtn;
    }//End of et_prQueryDisplayHD()
    
    public SepoaOut ChContReqBidDTQueryDisplay_Change(String[] args)
    {
        try
        {
            String lang            =  info.getSession("LANGUAGE");

            String rtnDT = et_ChContreqBidDTQueryDisplay_Change(args);
            setStatus(1);
            setValue(rtnDT);
            setMessage(msg.get("STDCOMM.0000"));
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            setStatus(0);

            String lang            =  info.getSession("LANGUAGE");

            setMessage(msg.get("p10_pra.0001"));
        }

        return getSepoaOut();
    }//End of prDTQueryDisplay_Change()

    private String et_ChContreqBidDTQueryDisplay_Change(String[] args) throws Exception
    {

        String rtn = null;
        String user_id         =  info.getSession("ID");
        String company_code    =  info.getSession("COMPANY_CODE");
        String house_code    =  info.getSession("HOUSE_CODE");

        ConnectionContext ctx = getConnectionContext();

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("company_code", company_code);
		wxp.addVar("house_code", house_code);
		wxp.addVar("po_no", args[1]);

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx, wxp.getQuery());
            rtn = sm.doSelect((String[])null);
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }//End of et_prQueryDisplayDT_Change()
    
    
    /*
     * 계약변경시 prhd, prdt insert
     */
    public SepoaOut setChContReqBidChangePur(
    		String pr_no
    		, String[][] args_hd
    		, String[][] args_dt
    		, String[][] args_prbr
    		, String sign_status
    		, String cur
    		, String pr_tot_amt
    		, String approval_str
    		, String doc_type  
    		, String pre_pjt_code
    		, HashMap<String, String> paramMap)
    {
    	
    	String add_user_id     =  info.getSession("ID");
        String house_code      =  info.getSession("HOUSE_CODE");
        String company         =  info.getSession("COMPANY_CODE");
        String add_user_dept   =  info.getSession("DEPARTMENT");
        String lang            =  info.getSession("LANGUAGE");

        try
        {
            int hd_rtn = et_setChPrHDCreate(args_hd);
            if(hd_rtn<1)
            	throw new Exception(msg.get("STDPR.0003"));
           
//            int dt_rtn       = et_setPrDTCreate(args_dt);//  변환 작업 중 임시 주석
            
            if(!"".equals(pre_pjt_code) ){
//            	  dt_rtn     = et_deletePrdtAllPrBr(pr_no); // 변환 작업 중 임시 주석
//	        	int prbr_rtn = et_setPrBrCreate(args_prbr); // 변환 작업 중 임시 주석
//	            if(prbr_rtn<1)// 변환 작업 중 임시 주석
//	            	throw new Exception(msg.get("STDPR.0003"));// 변환 작업 중 임시 주석
            }
            
/*            if(dt_rtn<1)
            	throw new Exception("NO DATA ICOYPRDT");*/
            
            /*
             * 발주 중도종결
             */
            String po_no      = paramMap.get("po_no");
            String cont_seq   = paramMap.get("cont_seq");
            String cont_count = paramMap.get("cont_count");
            int po_rtn = et_setPoIngStop(po_no, "변경계약/계약번호:"+cont_seq+",계약차수:"+cont_count);
            
            /*
             * 기존 계약서 강제 종결처리
             */
            int cont_rtn = et_setContStop(cont_seq, cont_count);
            if(cont_rtn < 1)
            	throw new Exception("기존계약서 종결처리 실패.");

                Logger.debug.println(info.getSession("ID"), this, "doc_type==================>"+doc_type);
                
            /*
             * 견적자동완료 처리.    
             */
            if(sign_status.equals("E"))
            {
            	int rfq_rtn = et_setRfqComplete(pr_no);
            	setStatus(1);
            	if(rfq_rtn < 0)
            		throw new Exception("견적자동완료 처리 오류.");
            }else{

                setStatus(1);
            	msg.put("PR_NO",pr_no);
            	if("T".equals(sign_status)){
                	setMessage("요청번호 "+pr_no+"번으로 저장 되었습니다.");
                }else if("E".equals(sign_status)){
                	setMessage("요청번호 "+pr_no+"번으로 요청 되었습니다.");
                }
            }
            
            Commit();
        }
        catch(Exception e)
        {
            try
            {
                Rollback();
            }
            catch(Exception d)
            {
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            setStatus(0);
            setMessage(msg.get("STDPR.0003"));
        }

        return getSepoaOut();
    }//End of setPrChange()

    /*
     * 1. 견적요청&견적서작성 처리 및 자동완료 하도록 합니다.
     *   - 1) ICOYRQHD
     *   - 2) ICOYRQDT
     *   - 3) ICOYRQOP
     *   - 4) ICOYRQSE
     *   - 5) ICOYPRDT
     *   - 6) ICOYPRHD
     *   - 7) ICOYQTHD
     *   - 8) ICOYQTDT
     */
    private int et_setRfqComplete(String pr_no) throws Exception
	{
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			// ICOYRQHD insert
			//SepoaOut wo2 = appcommon.getDocNumber(info, "RQ");// RFQ 번호 생성
			SepoaOut wo2 = DocumentUtil.getDocNumber(info,"RQ");
			String rfq_no = wo2.result[0];
			
			// ICOYQTHD insert
			//wo2 = appcommon.getDocNumber(info, "QT");// QTA 번호 생성
			wo2 = DocumentUtil.getDocNumber(info,"QT");
			String qta_no = wo2.result[0];
			
			// 1. ICOYRQHD 
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_ICOYRQHD");
			wxp.addVar("PR_NO"		, pr_no);
			wxp.addVar("RFQ_NO"		, rfq_no);
			wxp.addVar("HOUSE_CODE"	, info.getSession("HOUSE_CODE"));
			wxp.addVar("USER_ID"	, info.getSession("ID"));

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doInsert();

			// 2. ICOYRQDT
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_ICOYRQDT");
			wxp.addVar("PR_NO"		, pr_no);
			wxp.addVar("RFQ_NO"		, rfq_no);
			wxp.addVar("HOUSE_CODE"	, info.getSession("HOUSE_CODE"));
			wxp.addVar("USER_ID"	, info.getSession("ID"));

			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doInsert();
			
			// 3. ICOYRQOP
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_ICOYRQOP");
			wxp.addVar("PR_NO"		, pr_no);
			wxp.addVar("RFQ_NO"		, rfq_no);
			wxp.addVar("HOUSE_CODE"	, info.getSession("HOUSE_CODE"));
			wxp.addVar("USER_ID"	, info.getSession("ID"));
			
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			
			rtn = sm.doInsert();
			
			// 4. ICOYRQSE
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_ICOYRQSE");
			wxp.addVar("PR_NO"		, pr_no);
			wxp.addVar("RFQ_NO"		, rfq_no);
			wxp.addVar("HOUSE_CODE"	, info.getSession("HOUSE_CODE"));
			wxp.addVar("USER_ID"	, info.getSession("ID"));
			
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			
			rtn = sm.doInsert();
			
			// 5. ICOYPRDT
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_ICOYPRDT");
			wxp.addVar("PR_NO"		, pr_no);
			wxp.addVar("RFQ_NO"		, rfq_no);
			wxp.addVar("HOUSE_CODE"	, info.getSession("HOUSE_CODE"));
			wxp.addVar("USER_ID"	, info.getSession("ID"));
			
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			
			rtn = sm.doUpdate();
			
			// 6. ICOYPRHD
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_ICOYPRHD");
			wxp.addVar("PR_NO"		, pr_no);
			wxp.addVar("RFQ_NO"		, rfq_no);
			wxp.addVar("HOUSE_CODE"	, info.getSession("HOUSE_CODE"));
			wxp.addVar("USER_ID"	, info.getSession("ID"));
			
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			
			rtn = sm.doUpdate();
			
			// 7. ICOYQTHD
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_ICOYQTHD");
			wxp.addVar("PR_NO"		, pr_no);
			wxp.addVar("QTA_NO"		, qta_no);
			wxp.addVar("RFQ_NO"		, rfq_no);
			wxp.addVar("HOUSE_CODE"	, info.getSession("HOUSE_CODE"));
			wxp.addVar("USER_ID"	, info.getSession("ID"));
			
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			
			rtn = sm.doInsert();
			
			// 8. ICOYQTDT
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_ICOYQTDT");
			wxp.addVar("PR_NO"		, pr_no);
			wxp.addVar("QTA_NO"		, qta_no);
			wxp.addVar("RFQ_NO"		, rfq_no);
			wxp.addVar("HOUSE_CODE"	, info.getSession("HOUSE_CODE"));
			wxp.addVar("USER_ID"	, info.getSession("ID"));
			
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			
			rtn = sm.doInsert();
			
			setMessage("요청번호 "+pr_no+"번으로 요청되었습니다.\n견적번호 "+rfq_no+"번으로 처리가 완료되었습니다.\n\n기안대기에서 확인해주세요.");
			
		} catch(Exception e) {
			throw new Exception("et_setPoIngStop:"+e.getMessage());
		} finally{
		}
		return rtn;
	}
    
    //발주중도 종결
    private int et_setPoIngStop(String po_no, String end_remark) throws Exception
	{
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("po_no"		, po_no);
			wxp.addVar("house_code"		, info.getSession("HOUSE_CODE"));
			wxp.addVar("id"		, info.getSession("ID"));
			wxp.addVar("end_remark"		, end_remark);
			wxp.addVar("add_date"		, SepoaDate.getShortDateString());
			wxp.addVar("add_time"		, SepoaDate.getShortTimeString());

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();

			/*검수요청건이 있을때 발주중도처리를 할 경우 반려 처리*/
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_setIvhd");
			wxp.addVar("po_no"		, po_no);
			wxp.addVar("house_code"		, info.getSession("HOUSE_CODE"));
			wxp.addVar("id"		, info.getSession("ID"));
			wxp.addVar("add_date"		, SepoaDate.getShortDateString());
			wxp.addVar("add_time"		, SepoaDate.getShortTimeString());

			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();
		} catch(Exception e) {
			throw new Exception("et_setPoIngStop:"+e.getMessage());
		} finally{
		}
		return rtn;
	}
    
    //기존계약서 강제종결 처리.
    private int et_setContStop(String cont_seq, String cont_count) throws Exception
    {
    	int rtn = -1;
    	ConnectionContext ctx = getConnectionContext();
    	try {
    		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    		wxp.addVar("cont_seq"		, cont_seq);
    		wxp.addVar("cont_count"		, cont_count);
    		wxp.addVar("house_code"	, info.getSession("HOUSE_CODE"));
    		
    		SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
    		
    		rtn = sm.doUpdate();
    	} catch(Exception e) {
    		throw new Exception("et_setPoIngStop:"+e.getMessage());
    	} finally{
    	}
    	return rtn;
    }
    
    public SepoaOut selectPrUserList(Map<String, String> header){
		ConnectionContext ctx = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			rtn = this.select(ctx, "selectPrUserList", header);
			
			setValue(rtn);
			setMessage(msg.get("0000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("0001"));
		}
		
		return getSepoaOut();
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
    
    private boolean insertSprcartSelectSprCartInfo(ConnectionContext ctx, Map<String, String> header) throws Exception{
    	String        rtn    = null;
    	String        cnt    = null;
    	SepoaFormater sf     = null;
    	boolean       result = false;
    	
    	rtn = this.select(ctx, "selectSprCartInfo", header);
    	
    	sf = new SepoaFormater(rtn);
    	
    	cnt = sf.getValue("CNT", 0);
    	
    	if("0".equals(cnt)){
    		result = true;
    	}
    	else{
    		result = false;
    	}
    	
    	return result;
    }
    
	public SepoaOut insertSprcart(Map<String, String> data) throws Exception{
		try {
	        ConnectionContext ctx      = getConnectionContext();
			boolean           isInsert = this.insertSprcartSelectSprCartInfo(ctx, data);
		
			setStatus(1);
			setFlag(true);
			
			if(isInsert){
				this.insert(ctx, "insertSprcartInfo", data);
			}
			else{
				this.update(ctx, "updateSprcartInfo", data);
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

		return getSepoaOut();
    }
	
	public SepoaOut insertSprcartList(Map<String, Object> param) throws Exception{
		List<Map<String, String>> listData     = (List<Map<String, String>>)param.get("listData");
		Map<String, String>       listDataInfo = null;
		int                       listDataSize = listData.size();
		int                       i            = 0;
		
		for(i = 0; i < listDataSize; i++){
			listDataInfo = listData.get(i);
			
			this.insertSprcart(listDataInfo);
		}
		
    	return getSepoaOut();
    }
	
	/**
	 * 이미지보기
	 * @param header
	 * @return
	 */
	public SepoaOut getImageFile(Map<String, Object> data){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		Map<String, String>       map             = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			map = MapUtils.getMap(data, "headerData");
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser();
			
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			
			rtn = ssm.doSelect(map); // 조회
			
			setValue(rtn);
			setMessage(msg.get("0000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("0001"));
		}
		
		return getSepoaOut();
	}
	
	
	public SepoaOut selectSprcartList(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "selectSprcartList");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			rtn = ssm.doSelect(header); // 조회
			
			setValue(rtn);
			setMessage(msg.get("0000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("0001"));
		}
		
		return getSepoaOut();
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut deleteSprcartInfo(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx      = null;
        SepoaXmlParser            sxp      = null;
		SepoaSQLManager           ssm      = null;
		List<Map<String, String>> grid     = null;
		Map<String, String>       gridInfo = null;
		String                    id       = info.getSession("ID");
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
                sxp = new SepoaXmlParser(this, "deleteSprcartInfo");
                ssm = new SepoaSQLManager(id, this, ctx, sxp);
                
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
	
	public SepoaOut selectSmallCategoryList(Map<String, String> header){
		ConnectionContext ctx = null;
		String            rtn = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			rtn = this.select(ctx, "selectSmallCategoryList", header);
			
			setValue(rtn);
			setMessage(msg.get("0000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("0001"));
		}
		
		return getSepoaOut();
	}
	
	public SepoaOut selectVerySmallCategoryList(Map<String, String> header){
		ConnectionContext ctx = null;
		String            rtn = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			rtn = this.select(ctx, "selectVerySmallCategoryList", header);
			
			setValue(rtn);
			setMessage(msg.get("0000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("0001"));
		}
		
		return getSepoaOut();
	}
	
	////////////////////////////////////////////////////Web Service///////////////////////////////////////////////////

	/**
	 * 배열의 길이를 리턴하는 메소드
	 * 
	 * @param target
	 * @return int
	 * @throws Exception
	 */
	private int getArrayLength(String[] target) throws Exception{
		int result = 0;
		
		if(target != null){
			result = target.length;
		}
		
		return result;
	}
	
	/**
	 * 문자열 유효성을 검사하는 메소드
	 * 
	 * @param target (검사할 문자열)
	 * @param isRequired (필수값 여부, true : 필수, false : 필수아님)
	 * @param maxLength (최대길이값, -1 : 무한)
	 * @throws Exception
	 */
	private void stringValid(String target, boolean isRequired, int maxLength) throws Exception{
		byte[] targetByteArray       = null;
		int    targetByteArrayLength = 0;
		
		target = this.nvl(target);
		
		if(isRequired && ("".equals(target))){
			throw new Exception();
		}
		
		if(maxLength > -1){
			targetByteArray       = target.getBytes();
			targetByteArrayLength = targetByteArray.length;
			
			if(targetByteArrayLength >  maxLength){
				throw new Exception();
			}
		}
	}
	
	/**
	 * 예외 정보를 로그로 출력하는 메소드
	 * 
	 * @param e
	 */
	private void loggerExceptionStackTrace(Exception e){
		String trace = this.getExceptionStackTrace(e);
		
		Logger.err.println(trace);
	}
	
	/**
	 * 예외 정보를 문자열로 반환하는 메소드
	 * 
	 * @param e
	 * @return
	 */
	private String getExceptionStackTrace(Exception e){
		Writer      writer      = null;
		PrintWriter printWriter = null;
		String      s           = null;
		
		writer      = new StringWriter();
		printWriter = new PrintWriter(writer);
		
		e.printStackTrace(printWriter);
		
		s = writer.toString();
		
		return s;
	}
	
	/**
	 * 웹서비스 마스터 정보를 등록하는 메소드
	 * 
	 * @param info
	 * @param infCode
	 * @param infSend
	 * @return
	 * @throws Exception
	 */
	private String insertSinfhdInfo(SepoaInfo info, String infCode, String infSend) throws Exception{
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		SepoaOut            value     = null;
		String              infNo     = null;
		String              houseCode = info.getSession("HOUSE_CODE");
		String              id        = this.getWebserviceId(info);
		boolean             flag      = false;
		
		param.put("HOUSE_CODE",     houseCode);
		param.put("INF_TYPE",       "W");
		param.put("INF_CODE",       infCode);
		param.put("INF_SEND",       infSend);
		param.put("INF_ID",         id);
		
		obj[0] = param;
		value  = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfhdInfo", obj);
		flag   = value.flag;
		
		if(flag == false){
			throw new Exception();
		}
		else{
			infNo = value.result[0];
		}
		
		return infNo;
	}
	
	/**
	 * 웹서비스 호출 아이디를 반환하는 메소드
	 * 
	 * @param info
	 * @return
	 * @throws Exception
	 */
	private String getWebserviceId(SepoaInfo info) throws Exception{
		String id = info.getSession("ID");
		
		if("ADMIN".equals(id)){
			id = "EPROADM";
		}
		
		return id;
	}
	
	/**
	 * 문자열을 특정 바이트 수를 넘지 않게 처리후 리턴
	 * @param target
	 * @param maxLength
	 * @return
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
	
	///////////////////////////////////////////////Web Service 시작//////////////////////////////////////////
	
	/**
	 * webServiceEps0029 메소드 파라미터를 웹서비스 파라미터 객체로 변환하는 메소드
	 * 
	 * @param mode
	 * @param bsDeptCd
	 * @param bsNdseQt
	 * @param mloBsmCd
	 * @param requAmnt
	 * @param requDate
	 * @param requIdnt
	 * @param infNo
	 * @return EPS0029
	 * @throws Exception
	 */
	private EPS0029 getEps0029Param(
		String[] mode,     String[] bsDeptCd, String[] bsNdseQt, String[] mloBsmCd, String[] requAmnt,
		String   requDate, String   requIdnt, String   infNo
	) throws Exception{
		EPS0029       eps0029        = new EPS0029();
		ArrayOfString modeArray      = new ArrayOfString(); 
		ArrayOfString bsDeptCdArray  = new ArrayOfString();
		ArrayOfString bsNdseQtArray  = new ArrayOfString();
		ArrayOfString mlObsmCdArray  = new ArrayOfString();
		ArrayOfString requAmntArray  = new ArrayOfString();
		String        modeInfo       = null;
		String        bsDeptCdInfo   = null;
		String        bsNdseQtInfo   = null;
		String        mloBsmCdInfo   = null;
		String        requAmntInfo   = null;
		int           modeLength     = this.getArrayLength(mode);
		int           bsDeptCdLength = this.getArrayLength(bsDeptCd);
		int           bsNdseQtLength = this.getArrayLength(bsNdseQt);
		int           mloBsmCdLength = this.getArrayLength(mloBsmCd);
		int           requAmntLength = this.getArrayLength(requAmnt);
		int           i              = 0;
		
		if(
			(modeLength == 0) ||
			(modeLength != bsDeptCdLength) ||
			(modeLength != bsNdseQtLength) ||
			(modeLength != mloBsmCdLength) ||
			(modeLength != requAmntLength)
		){
			throw new Exception();
		}
		
		for(i = 0; i < modeLength; i++){
			modeInfo     = mode[i];
			bsDeptCdInfo = bsDeptCd[i];
			bsNdseQtInfo = bsNdseQt[i];
			mloBsmCdInfo = mloBsmCd[i];
			requAmntInfo = requAmnt[i];
//			System.out.println("modeInfo=========="+i+"=========="+modeInfo);
//			System.out.println("bsDeptCdInfo=========="+i+"=========="+bsDeptCdInfo);
//			System.out.println("bsNdseQtInfo=========="+i+"=========="+bsNdseQtInfo);
//			System.out.println("mloBsmCdInfo=========="+i+"=========="+mloBsmCdInfo);
//			System.out.println("requAmntInfo=========="+i+"=========="+requAmntInfo);
			this.stringValid(modeInfo,     true, 1);
			this.stringValid(bsDeptCdInfo, true, 6);    // TOBE 2017-07-01 길이 5->6 변경
			this.stringValid(bsNdseQtInfo, true, 12);
			this.stringValid(mloBsmCdInfo, true, 10);
			this.stringValid(requAmntInfo, true, 15);
			
//			if(
//				("C".equals(modeInfo)) ||
//				("U".equals(modeInfo)) ||
//				("D".equals(modeInfo))
//			){
//				throw new Exception();
//			}
			if(
					(!"C".equals(modeInfo)) &&
					(!"U".equals(modeInfo)) &&
					(!"D".equals(modeInfo))
					){
				throw new Exception();
			}
			
			modeArray.addString(modeInfo);
			bsDeptCdArray.addString(bsDeptCdInfo);
			bsNdseQtArray.addString(bsNdseQtInfo);
			mlObsmCdArray.addString(mloBsmCdInfo);
			requAmntArray.addString(requAmntInfo);
		}
		
		this.stringValid(requDate, true, 8);
		this.stringValid(requIdnt, true, 8);
		this.stringValid(infNo,    true, 15);
		
		eps0029.setMODE(modeArray);
		eps0029.setBSDEPTCD(bsDeptCdArray);
		eps0029.setBSNDSEQT(bsNdseQtArray);
		eps0029.setMLOBSMCD(mlObsmCdArray);
		eps0029.setREQUAMNT(requAmntArray);
		eps0029.setREQUDATE(requDate);
		eps0029.setREQUIDNT(requIdnt);
		eps0029.setINF_REF_NO(infNo);
		
		return eps0029;
	}
	
	/**
	 * 웹서비스 헤더 로그 정보를 반환하는 메소드
	 * 
	 * @param info
	 * @param eps0029
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> insertSinfep0029Header(SepoaInfo info, EPS0029 eps0029) throws Exception{
		Map<String, String> result    = new HashMap<String, String>();
		String              houseCode = info.getSession("HOUSE_CODE");
		String              infNo     = eps0029.getINF_REF_NO();
		String              requDate  = eps0029.getREQUDATE();
		String              requIdnt  = eps0029.getREQUIDNT();
		
		result.put("HOUSE_CODE", houseCode);
		result.put("INF_NO",     infNo);
		result.put("REQUDATE",   requDate);
		result.put("REQUIDNT",   requIdnt);
		
		return result;
	}
	
	/**
	 * 웹서비스 리스트 로그 정보를 반환하는 메소드
	 * @param info
	 * @param eps0029
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, String>> insertSinfep0029List(SepoaInfo info, EPS0029 eps0029) throws Exception{
		List<Map<String, String>> result          = new ArrayList<Map<String, String>>();
		String[]                  modeArray       = eps0029.getMODE().getString(); 
		String[]                  bsDeptCdArray   = eps0029.getBSDEPTCD().getString();
		String[]                  bsNdseQtArray   = eps0029.getBSNDSEQT().getString();
		String[]                  mlObsmCdArray   = eps0029.getMLOBSMCD().getString();
		String[]                  requAmntArray   = eps0029.getREQUAMNT().getString();
		String                    houseCode       = info.getSession("HOUSE_CODE");
		String                    infNo           = eps0029.getINF_REF_NO();
		Map<String, String>       resultInfo      = null;
		int                       modeArrayLenght = modeArray.length;
		int                       i               = 0;
		
		for(i = 0; i < modeArrayLenght; i++){
			resultInfo = new HashMap<String, String>();
			
			resultInfo.put("HOUSE_CODE", houseCode);
			resultInfo.put("INF_NO",     infNo);
			resultInfo.put("SEQ",        Integer.toString(i));
			resultInfo.put("INF_MODE",   modeArray[i]);
			resultInfo.put("BSDEPTCD",   bsDeptCdArray[i]);
			resultInfo.put("MLOBSMCD",   mlObsmCdArray[i]);
			resultInfo.put("REQUAMNT",   requAmntArray[i]);
			resultInfo.put("BDNDSEQT",   bsNdseQtArray[i]);
			
			
			result.add(resultInfo);
		}
		
		return result;
	}
	
	/**
	 * 웹서비스 파라미터 로그를 등록하는 메소드
	 * 
	 * @param info
	 * @param eps0029
	 * @throws Exception
	 */
	private void insertSinfep0029(SepoaInfo info, EPS0029 eps0029) throws Exception{
		Object[]                  svcObject     = new Object[1];
		Map<String, Object>       svcObjectInfo = new HashMap<String, Object>();
		Map<String, String>       header        = this.insertSinfep0029Header(info, eps0029);
		List<Map<String, String>> list          = this.insertSinfep0029List(info, eps0029);
		SepoaOut                  value         = null;
		boolean                   flag          = false;
		
		svcObjectInfo.put("header", header);
		svcObjectInfo.put("list",   list);
		
		svcObject[0] = svcObjectInfo;
		
		value  = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0029", svcObject);
		flag   = value.flag;
		
		if(flag == false){
			throw new Exception();
		}
	}
	
	/**
	 * 웹서비스를 호출하고 그 결과를 반환하는 메소드
	 * @param eps0029
	 * @return
	 * @throws Exception
	 */
	private String[] callWebServiceEps0029(EPS0029  eps0029) throws Exception{
		String[]         result                       = null;
		EPS_007_WSStub   eps007Wsstub                 = new EPS_007_WSStub();
		EPS0029Response  eps0029Response              = null;
		ArrayOfString    eps0029ResponseArrayOfString = null;
		
		eps0029Response              = eps007Wsstub.ePS0029(eps0029);
		eps0029ResponseArrayOfString = eps0029Response.getEPS0029Result();
		result                       = eps0029ResponseArrayOfString.getString();
		
		return result;
	}
	
	/**
	 * 웹서비스 마스터 정보를 수정하는 메소드
	 * @param info
	 * @param infNo
	 * @param status
	 * @param reason
	 * @param infReceiveNo
	 */
	private void updateSinfhdInfo(SepoaInfo info, String infNo, String status, String reason, String infReceiveNo){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		
		try{
			param.put("STATUS",         status);
			param.put("REASON",         reason);
			param.put("HOUSE_CODE",     houseCode);
			param.put("INF_NO",         infNo);
			param.put("INF_RECEIVE_NO", infReceiveNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfhdInfo", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	/**
	 * 웹서비스 호출 결과를 저장하는 메소드
	 * 
	 * @param info
	 * @param infNo
	 * @param response
	 */
	private void updateSinfep0029Info(SepoaInfo info, String infNo, String[] response){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		String              code      = response[0];
		String              return1   = response[1];
		String              return2   = response[2];
		String              return3   = response[3];
		
		try{
			param.put("RETURN1",    code);
			param.put("RETURN2",    return1);
			param.put("RETURN3",    return2);
			param.put("RETURN4",    return3);
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0029Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	/**
	 * eps0029 웹서비스 호출하여 그 결과를 리턴하는 메소드
	 * @param info
	 * @param mode
	 * @param bsDeptCd
	 * @param bsNdseQt
	 * @param mloBsmCd
	 * @param requAmnt
	 * @param requDate
	 * @param requIdnt
	 * @return String[]
	 * @throws Exception
	 */
	private String[] webServiceEps0029(
		SepoaInfo info,     String[] mode,     String[] bsDeptCd, String[] bsNdseQt, String[] mloBsmCd,
		String[]  requAmnt, String   requDate, String   requIdnt
	) throws Exception{
		String[] result       = null;
		EPS0029  eps0029      = null;        
		String   infNo        = null;
		String   status       = null;
    	String   reason       = null;
    	String   infReceiveNo = null;
    	String   code         = null;
		
		try{
			infNo   = this.insertSinfhdInfo(info, "EPS0029", "S");
			eps0029 = this.getEps0029Param(mode, bsDeptCd, bsNdseQt, mloBsmCd, requAmnt, requDate, requIdnt, infNo);
			
			this.insertSinfep0029(info, eps0029);
			
			result       = this.callWebServiceEps0029(eps0029);
			code         = result[0];
    		infReceiveNo = result[3];
    		
    		if("200".equals(code)){
    			status = "Y";
				reason = "";
    		}
    		else{
    			status = "N";
				reason = result[1];
    		}
    		
//    		System.out.println("code==========="+code);
    		
		}
		catch(Exception e){
			result = new String[4];
    		
	    	status       = "N";
			reason       = this.getExceptionStackTrace(e);
			reason       = this.getStringMaxByte(reason, 4000);
			infReceiveNo = "";
			
			result[0] = "901";
			result[1] = reason;
			result[2] = reason;
			result[3] = reason;
			
			this.loggerExceptionStackTrace(e);
		}
		
		this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
		this.updateSinfep0029Info(info, infNo, result);
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut setPrCreate2(Map<String, Object> param) throws Exception{
		
		String                    add_user_id       =  info.getSession("ID");
        String                    house_code        =  info.getSession("HOUSE_CODE");
        String                    company           =  info.getSession("COMPANY_CODE");
        String                    add_user_dept     =  info.getSession("DEPARTMENT");
        String                    req_type          = null;
        String                    strDocFlag        = "";
        String                    pre_pjt_code      = null;
        String                    prNo              = null;
        String                    sign_status       = null;
        String                    subject           = null;
        String                    pr_tot_amt        = null;
        String                    approval_str      = null;
        String                    strMsgTemp        = null;
        Map<String, String>       header            = MapUtils.getMap(param, "headerData"); // 조회 조건 조회
        Map<String, String>       prHdCreateParam   = null;
        Map<String, String>       prDtCreateParam   = null;
        Map<String, String>       gridInfo          = null;
        List<Map<String, String>> grid              = (List<Map<String, String>>)MapUtils.getObject(param, "gridData");
        List<Map<String, String>> prBrParamList     = null;
        int                       hd_rtn            = 0;
        int                       dt_rtn            = 0;
        int                       gridSize          = grid.size();
        int                       i                 = 0;
        int                       prbr_rtn          = 0;
        int                       prBrParamListSize = 0;

    	req_type     = header.get("pr_gubun");
    	prNo         = header.get("prNo");
    	sign_status  = header.get("sign_status");
    	subject      = header.get("subject");
    	pr_tot_amt   = header.get("pr_tot_amt");
    	approval_str = header.get("approval_str");
    	
		if("P".equals(req_type)){
			strDocFlag = "PR";
		}
		else if("B".equals(strDocFlag)){
			strDocFlag = "BR";
		}
		
        try{
        	prHdCreateParam = this.prHdCreateParam(header);
            hd_rtn          = this.et_setPrHDCreate(prHdCreateParam);
            
            if(hd_rtn < 1){
            	throw new Exception(msg.get("STDPR.0003"));
            }
            
            for(i = 0; i < gridSize; i++){
            	gridInfo        = grid.get(i);
            	prDtCreateParam = this.prDtCreateParam(header, gridInfo);
                dt_rtn          = this.et_setPrDTCreate(prDtCreateParam);
                
                if(dt_rtn < 1){
                	throw new Exception(msg.get("STDPR.0003"));
                }

//                dt_rtn = this.deleteSprcartInfo(gridInfo);
//                
//                if(dt_rtn < 1){
//                	throw new Exception(msg.get("STDPR.0003"));
//                }
            }
            
//            pre_pjt_code = header.get("pre_pjt_code");
//          
//            if("".equals(pre_pjt_code) == false ){
//            	prBrParamList     = this.getPrbrList(prNo, pre_pjt_code);
//            	prBrParamListSize = prBrParamList.size();
//            	
//            	for(i = 0; i < prBrParamListSize; i++){
//            		prbr_rtn = this.et_setPrBrCreate(prBrParamList.get(i));
//            		
//            		if(prbr_rtn<1){
//    	            	throw new Exception(msg.get("STDPR.0003"));
//    	            }
//            	}
//            }
            
            msg.put("PR_NO",prNo);
            setMessage(msg.get("STDPR.0015"));

            if(sign_status.equals("P")){
                SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType(strDocFlag);
                sri.setDocNo(prNo);
                sri.setDocSeq("0");
                sri.setDocName(subject);
                sri.setItemCount(gridSize);
                sri.setSignStatus(sign_status);
                sri.setCur(grid.get(0).get("CUR"));
                sri.setTotalAmt(Double.parseDouble(pr_tot_amt));

                sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
                sri.setSignRemark(java.net.URLDecoder.decode(sri.getSignRemark(),"UTF-8"));
                
                int rtn = CreateApproval(info,sri);    //밑에 함수 실행
                if(rtn == 0)
                {
                    try
                    {
                        Rollback();
                    }
                    catch(Exception d)
                    {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.get("STDPR.0030"));
                    return getSepoaOut();
                }

                msg.put("PR_NO", prNo);
                setMessage("요청번호 " + prNo + "번으로 전송되었습니다.");
            }

            setStatus(1);
            setValue(prNo);
            msg.put("PR_NO", prNo);

            if("P".equals(req_type)){
            	strMsgTemp = "구매요청번호";
            }
            else{
            	strMsgTemp = "사전지원요청번호";
            }

            if("T".equals(sign_status)){
            	setMessage(strMsgTemp + " "+prNo+"번으로 저장 되었습니다.");
            }
            else if("E".equals(sign_status)){
            	setMessage(strMsgTemp + " "+prNo+"번으로 요청 되었습니다.");
            }
            
            Commit();
        }
        catch(Exception e){
        	
        	
        	
            try{
                Rollback();
            }
            catch(Exception d){
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
                
            }
//            e.printStackTrace();
            Logger.err.println(info.getSession("ID"),this,"XXXXXXXXXXXXXXXXX"+e.getMessage());
            setStatus(0);
            setMessage(msg.get("STDPR.0003"));
            setFlag(false);
        }

        return getSepoaOut();
	}
	
	public SepoaOut getApprvalId(String dept) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		String house_code     =  info.getSession("HOUSE_CODE");
		String company_code   =  info.getSession("COMPANY_CODE");
		String dept_code      =  info.getSession("DEPARTMENT");
		String jumjumgb       =  info.getSession("JUMJUMGB");
		String mojmojcd       =  info.getSession("MOJMOJCD");
		
		if("020002".equals(dept_code) || "020156".equals(dept_code) || "020157".equals(dept_code) || "020155".equals(dept_code)){
//			020002    여신관리부 부산지역팀
//			020156    여신관리부 대구지역팀
//			020157    여신관리부 대전지역팀
//			020155    여신관리부 광주지역팀
			dept_code = "020714"; // 지역팀 모점(여신관리부)
		}else if("020440".equals(dept_code) || "020658".equals(dept_code) || "020392".equals(dept_code) || "020868".equals(dept_code)
				 || "020657".equals(dept_code) || "020778".equals(dept_code) || "020361".equals(dept_code) || "020659".equals(dept_code)
				 || "020762".equals(dept_code) ){
//			020440    광주지원센터
//			020658    부산지원센터
//			020392    대전지원센터
//			020868    수원지원센터
//			020657    인천지원센터
//			020778    창원지원센터
//			020361    포항지원센터
//			020659    대구지원센터
//			020762    울산지원센터
			dept_code = "020265"; // 지원센터 모점(수신업무센타)
		}else if("4".equals(jumjumgb)){
			//ICOMOGIL.JUMJUMGB = 4:출장소
			dept_code = mojmojcd; // 출장소의 모점
		}
			
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		try {
			HashMap<String, String> no = new HashMap<String, String>();
			no.put("house_code", house_code);
			no.put("company_code", company_code);
			no.put("dept_code", dept_code);
			
			sxp = new SepoaXmlParser(this, "getApprvalId");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	setValue(ssm.doSelect(no));

		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
}