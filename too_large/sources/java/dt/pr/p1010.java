package dt.pr;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

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
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import wisecommon.SignResponseInfo;

/*******************************************************************************
 *
 * 사용메소드 정리
 * ==========================================================================================
 * JSP SERVLET 프로그램설명 메소드 기능
 * ==========================================================================================
 * pr/pr3_bd_lis1.jsp pr3_bd_lis1 구매검토목록 prReqList 조회 pr/pr3_bd_lis2.jsp
 * pr3_bd_lis2 품목별진행현황 prProcessdingReceipt 조회
 * ==========================================================================================
 *
 ******************************************************************************/

public class p1010 extends SepoaService {

	private String HOUSE_CODE = info.getSession("HOUSE_CODE");
	private String lang = info.getSession("LANGUAGE");
	private Message msg = new Message(info, "STDPR");
	private String ctrl_code = info.getSession("CTRL_CODE");
	private String company_code   = info.getSession("COMPANY_CODE");

	public p1010(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		setVersion("1.0.0");
	}

	public String getConfig(String s) {
		try {
			Configuration configuration = new Configuration();
			s = configuration.get(s);
			return s;
		} catch (ConfigurationException configurationexception) {
			Logger.sys.println("getConfig error : "
					+ configurationexception.getMessage());
		} catch (Exception exception) {
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}
		return null;
	}

	/**
	 * 미결목록
	 * @Method Name : getUnsettledList
	 * @작성일       : 2008. 11. 12
	 * @작성자       : wooman.choi
	 * @변경이력     :
	 * @Method 설명  :
	 * @param sign_date_start
	 * @param sign_date_end
	 * @param ctrl_code
	 * @param operating_code
	 * @param pr_location
	 * @return
	 */
//	public SepoaOut charge_transfer_doc(String Transfer_id,
//			String Transfer_name, String Transfer_person_id,
//			String Transfer_person_name, String[][] prdata) {
//		try {
//			int rtn = et_charge_transfer_doc(Transfer_id, Transfer_name,
//					Transfer_person_id, Transfer_person_name, prdata);
//
//			setStatus(1);
//			setValue(String.valueOf(rtn));
//
//			setMessage(msg.getMessage("0045"));
//			Commit();
//		} catch (Exception e) {
//			try {
//				Rollback();
//			} catch (Exception d) {
//				Logger.err.println(info.getSession("ID"), this, d.getMessage());
//			}
//			Logger.err.println(info.getSession("ID"), this, e.getMessage());
//			setStatus(0);
//			setMessage(msg.getMessage("0002"));
//		}
//		return getSepoaOut();
//	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut charge_transfer_doc(Map<String, Object> param) throws Exception{
		ConnectionContext         ctx                = null;
        SepoaXmlParser            sxp                = null;
		SepoaSQLManager           ssm                = null;
		SepoaOut                  sepoaOut           = null;
		String                    id                 = info.getSession("ID");
		String                    companyCode        = info.getSession("COMPANY_CODE");
		String                    TransferId         = (String)param.get("Transfer_id");
		String                    TransferPersonId   = (String)param.get("Transfer_person_id");
		String                    TransferPersonName = (String)param.get("Transfer_person_name");
		String                    prNo               = null;
		List<Map<String, String>> prDataList         = (List<Map<String, String>>)param.get("prdata");
		Map<String, String>       prDataInfo         = null;
		Map<String, Object>       doConfirmParam     = new HashMap<String, Object>();
		int                       prDateListSize     = prDataList.size();
		int                       i                  = 0;
		
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			for(i = 0; i < prDateListSize; i++){
		        prDataInfo = prDataList.get(i);
		        
		        prDataInfo.put("house_code", info.getSession("HOUSE_CODE"));
		        prDataInfo.put("pr_no",      prDataInfo.get("PR_NO"));
		        prDataInfo.put("pr_seq",     prDataInfo.get("PR_SEQ"));
		        
		        prDataInfo = this.charge_transfer_docHeader(ctx, prDataInfo);
		        
		        prDataInfo.put("company_code",         companyCode);
		        prDataInfo.put("Transfer_id",          TransferId);
		        prDataInfo.put("Transfer_person_id",   TransferPersonId);
		        prDataInfo.put("Transfer_person_name", TransferPersonName);
		        
		        sxp = new SepoaXmlParser(this, "et_charge_transfer_doc_2");
	            ssm = new SepoaSQLManager(id, this, ctx, sxp);
	                
	            ssm.doUpdate(prDataInfo);
	            
	            if(i == 0){
	            	prNo = prDataInfo.get("PR_NO");
	            }
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
		
		doConfirmParam.put("recvdata", prDataList);
		
		sepoaOut = this.doConfirm(doConfirmParam);

		return sepoaOut;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	private Map<String, String> charge_transfer_docHeader(ConnectionContext ctx, Map<String, String> gridInfo) throws Exception{
		SepoaXmlParser      sxp               = null;
		SepoaSQLManager     ssm               = null;
		SepoaFormater       wf                = null;
		String              id                = info.getSession("ID");
		String              rtn               = null;
		String              purchaserId       = null;
		String              purchaserName     = null;
		String              purchaserCtrlCode = null;
		int                 rowCount          = 0;
		
		sxp = new SepoaXmlParser(this, "et_charge_transfer_doc_1");
        ssm = new SepoaSQLManager(id, this, ctx, sxp);
            
        rtn = ssm.doSelect(gridInfo);
        
        wf = new SepoaFormater(rtn);
        
        rowCount = wf.getRowCount();
        
        if(rowCount > 0) {
			purchaserId       = wf.getValue("PURCHASER_ID", 0);
			purchaserName     = wf.getValue("PURCHASER_NAME", 0);
			purchaserCtrlCode = wf.getValue("CTRL_CODE", 0);
		}
        else{
        	purchaserId       = "";
			purchaserName     = "";
			purchaserCtrlCode = "";
        }
        
        gridInfo.put("purchaser_id",        purchaserId);
        gridInfo.put("purchaser_name",      purchaserName);
        gridInfo.put("purchaser_ctrl_code", purchaserCtrlCode);
        
		return gridInfo;
	}

	private int et_charge_transfer_doc(String Transfer_id,
			String Transfer_name, String Transfer_person_id,
			String Transfer_person_name, String[][] prdata) throws Exception {

		ConnectionContext ctx = getConnectionContext();
		int rtn = 0;
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		SepoaSQLManager sm = null;
		SepoaFormater wf = null;

		StringBuffer sql = new StringBuffer();

		try {

			String purchaser_id = "";
			String purchaser_name = "";
			String purchaser_ctrl_code = "";
			for (int i = 0; i < prdata.length; i++) {
				String pr_no = prdata[i][0];
				String pr_seq = prdata[i][1];

				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
		        wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

				sql = new StringBuffer();

				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
				String[] data = { pr_no, pr_seq };
				String rString = sm.doSelect(data);
				wf = new SepoaFormater(rString);

				if (wf.getRowCount() > 0) {
					purchaser_id = wf.getValue("PURCHASER_ID", 0);
					purchaser_name = wf.getValue("PURCHASER_NAME", 0);
					purchaser_ctrl_code = wf.getValue("CTRL_CODE", 0);
				}

				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
		        wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

				sql = new StringBuffer();

				String[] type = { "S", "S", "S", "S", "S", "S", "S", "S", "S",
						"S", "S", "S", "S", "S", "S", "S", "S" };

				String[][] dataPrdt = { { Transfer_id, Transfer_person_id,
						Transfer_person_name, house_code, company_code,
						Transfer_person_id, house_code, company_code,
						house_code, company_code, Transfer_person_id,
						purchaser_id, purchaser_name, purchaser_ctrl_code,
						house_code, pr_no, pr_seq } };

				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
				rtn = sm.doUpdate(dataPrdt, type);

			}
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

//	public SepoaOut reject_doc(String reason, String[][] pr, String flag,
//			String reason_code, String email, String pr_name, String req_type) {
//		int rtn 	= -1;
//		int rtn_scms= -1;
//		try {
//
//			ConnectionContext ctx = getConnectionContext();
//
//			rtn 	= et_reject_doc(ctx, reason, pr, flag, reason_code, email,pr_name,req_type);
//
//			Configuration conf = new Configuration();
//			if(conf.getBoolean("Sepoa.scms.if_flag")){
//				if("B".equals(req_type)){
//					// 영업관리 시노님 TB_SCM_BR 업데이트
//					rtn_scms = scms_interface_br(ctx, pr, "R");
//				}else if("P".equals(req_type)){
//					// 영업관리 시노님 TB_SCM_PR 업데이트
//					rtn_scms = scms_interface_pr(ctx, pr, "R");
//				}
//			}
//
//			setStatus(1);
//			setValue(rtn + "");
//			setMessage("반려가 완료되었습니다.");
//
//			Commit();
//
//			// SMS 전송, MAIL 전송
//	        Object[] sms_args = {pr};
//	        String sms_type = "";
//	        String mail_type = "";
//
//	        sms_type 	= "S00005";
//	        mail_type 	= "M00005";
//
//	        if(!"".equals(sms_type)){
//	        	ServiceConnector.doService(info, "SMS", "TRANSACTION", sms_type, sms_args);
//	        }
//	        if(!"".equals(mail_type)){
//	        	ServiceConnector.doService(info, "mail", "CONNECTION", mail_type, sms_args);
//	        }
//
//		} catch (Exception e) {
//			Logger.err.println(info.getSession("ID"), this, e.getMessage());
//			try {
//                Rollback();
//            } catch(Exception d) {
//                Logger.err.println(userid,this,d.getMessage());
//            }
//            if(rtn == -1){
//            	setMessage("반려가 실패하였습니다.");
//            }
//
//            if(rtn_scms == -1){
//            	setMessage("반려[인터페이스]가 실패하였습니다.");
//            }
//            setValue(e.getMessage().trim());
//            setStatus(0);
//		}
//
//		return getSepoaOut();
//	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut reject_doc(Map<String, Object> param) throws Exception{
		ConnectionContext         ctx          = null;
		String                    sms_type     = "";
        String                    mail_type    = "";
		List<Map<String, String>> recvdata     = (List<Map<String, String>>)param.get("recvdata");
		Map<String, String>       recvdataInfo = null;
		Map<String, Object>       sendParam    = new HashMap<String, Object>();
		int                       recvdateSize = recvdata.size();
		int                       i            = 0;
		String 					  rtnMsg	   = "";
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			for(i = 0; i < recvdateSize; i++){
				recvdataInfo = recvdata.get(i);
				
				this.reject_docDoUpdate(ctx, param, recvdataInfo);
			}
			
			if("R".equals(param.get("req_type").toString())){
				setMessage("반려가 완료되었습니다.");
			}
			else if("Z".equals(param.get("req_type").toString())){
				setMessage("보류가 완료되었습니다.");
			}
			else if("P".equals(param.get("req_type").toString())){
				setMessage("재진행 상태 변경이 완료되었습니다.");
			}
			
			Commit();
			
			sendParam.put("recvdata", recvdata);
			
			Object[] sms_args = {sendParam};
			
			if("".equals(sms_type) == false){
				ServiceConnector.doService(info, "SMS", "TRANSACTION", "S00005", sms_args);
			}
			
			if(!"".equals(mail_type)){
				ServiceConnector.doService(info, "mail", "CONNECTION", "M00005", sms_args);
			}
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
	
	private void reject_docDoUpdate(ConnectionContext ctx, Map<String, Object> param, Map<String, String> recvdataInfo) throws Exception{
		Map<String, String> sqlParam  = null;
		String              date      = SepoaDate.getShortDateString();
		String              id        = info.getSession("ID");
		String              houseCode = info.getSession("HOUSE_CODE");
		SepoaXmlParser      sxp       = null;
		SepoaSQLManager     ssm       = null;
		
		sqlParam = new HashMap<String, String>();
		
		sqlParam.put("reason_code", (String)param.get("reason_code"));
		sqlParam.put("reason",      (String)param.get("pTitle_Memo"));
		sqlParam.put("date",        date);
		sqlParam.put("user_id",     id);
		sqlParam.put("house_code",  houseCode);
		sqlParam.put("pr_no",       recvdataInfo.get("PR_NO"));
		sqlParam.put("pr_seq",      recvdataInfo.get("PR_SEQ"));
		sqlParam.put("req_type",    param.get("req_type").toString());

		sxp = new SepoaXmlParser(this, "et_reject_doc");
        ssm = new SepoaSQLManager(id, this, ctx, sxp);
        
        ssm.doUpdate(sqlParam);
	}

	private int et_reject_doc(ConnectionContext ctx, String reason, String[][] pr, String flag,
			String reason_code, String email, String pr_name, String req_type) throws Exception {

		String house_code = info.getSession("HOUSE_CODE");
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
		wxp.addVar("reason_code",reason_code);
		wxp.addVar("reason",reason);
		wxp.addVar("date",SepoaDate.getShortDateString());
		wxp.addVar("user_id",info.getSession("ID"));

		int rtn = 0;

		String[][] pr_args = pr;
		try {
			String[] type = { "S", "S" };
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(pr_args, type);
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private int et_setKnttp(String pr_no){

			int	result =-1;
	 		try	{
				String rtn = "";

				String house_code =	"";
				String doc_no =	"";

				SepoaSQLManager sm =	null;

				ConnectionContext ctx =	getConnectionContext();
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("pr_no", pr_no);

	//			tSQL1.append(" SELECT	ISNULL(SALES_TYPE,'') AS SALES_TYPE 							\n");
	//			tSQL1.append(" FROM ICOYPRHD 								\n");
	//			tSQL1.append(" WHERE HOUSE_CODE	= '100'						\n");
	//			tSQL1.append(" 	AND PR_NO = '"+pr_no+"'						\n");

				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,	wxp.getQuery());

				rtn	= sm.doSelect((String[])null);
				SepoaFormater wf1 = new SepoaFormater( rtn );
				String sales_type = wf1.getValue( 0, 0	);

				if(!sales_type.equals("A"))
				{
					result = 100;
				}

			}catch(Exception e)	{
				result = -1;
				setMessage(e.getMessage());
			}
			return result;
		}

	public SepoaOut CallNONDBJOB(	ConnectionContext ctx, String serviceId, String MethodName, Object[] obj )
	{

		String conType = "NONDBJOB";					//conType :	CONNECTION/TRANSACTION/NONDBJOB

		SepoaOut value = null;
		SepoaRemote wr	= null;

		//다음은 실행할	class을	loading하고	Method호출수 결과를	return하는 부분이다.
		try
		{

			wr = new SepoaRemote( serviceId, conType, info	);
			wr.setConnection(ctx);

			value =	wr.lookup( MethodName, obj );

		}catch(	SepoaServiceException wse ) {
//			try{
				Logger.err.println("wse	= "	+ wse.getMessage());
//				Logger.err.println("message	= "	+ value.message);
//				Logger.err.println("status = " + value.status);				
//			}catch(NullPointerException ne){
//        		
//        	}
		}catch(Exception e)	{
//			try{
				Logger.err.println("err	= "	+ e.getMessage());
//				Logger.err.println("message	= "	+ value.message);
//				Logger.err.println("status = " + value.status);				
//			}catch(NullPointerException ne){
//        		
//        	}
		}

		return value;
	}

	/**
	 * 결재처리
	 * @Method Name : Approval
	 * @작성일       : 2008. 11. 12
	 * @작성자       : wooman.choi
	 * @변경이력     :
	 * @Method 설명  :
	 * @param inf
	 * @return
	 */
	public SepoaOut Approval(SignResponseInfo inf) {
		ConnectionContext ctx = getConnectionContext();
		String ans = inf.getSignStatus();
		String[] doc_no = inf.getDocNo();
		String[] com_code = inf.getCompanyCode();
		String[] doc_seq = inf.getDocSeq();
		String house_code = info.getSession("HOUSE_CODE");
		String[][] setData = new String[doc_no.length][3];
		String flag = "";
		int res = 0;

		try {
			if (ans.equals("E")) { // 완료
				flag = "E";
			} else if (ans.equals("R")) { // 반려
				flag = "R";
			} else if (ans.equals("D")) { // 취소
				flag = "T";
			}
			for (int i = 0; i < doc_no.length; i++) {
				setData[i][0] = flag;
				setData[i][1] = house_code;
				setData[i][2] = doc_no[i];
			}
			res = setSIGN_STATUS(setData);
			if (res != -1) {
				Commit();
				setStatus(1);
			}
		} catch (Exception e) {
			Logger.err.println("setSignStatus: = " + e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

	private int setSIGN_STATUS(String[][] setData) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
//		StringBuffer sql = new StringBuffer();

		String user_id = info.getSession("ID");
		SepoaSQLManager sm = null;
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("user_id", user_id);
		try {

//			sql.append(" UPDATE ICOYPRHD                                                    \n");
//			sql.append(" SET CTRL_FLAG      	= ? ,		                                 \n");
//			sql.append("     CTRL_DATE      	= SYSDATE,      							 \n");
//			sql.append("     CTRL_PERSON_ID 	='" + user_id + "'                               \n");
//			sql.append(" WHERE HOUSE_CODE 		= ?                                			 \n");
//			sql.append("   AND PR_NO = ?                                                    \n");

			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] type = { "S", "S", "S" };
			rtn = sm.doInsert(setData, type);
		} catch (Exception e) {
			throw new Exception("######## setSIGN_STATUS ========> "
					+ e.getMessage());
		}

		return rtn;
	}

	public SepoaOut prReqListItem(
            String START_SIGN_DATE,
            String END_SIGN_DATE,
            String PR_USER_NAME,
            String S_CTRL_CODE,
            String PR_TYPE,
            String PR_NO,
            String ITEM_NAME
            ,String ITEM_FLAG)
    {
        try{

            String rtn = et_prReqListItem(
                                START_SIGN_DATE,
                                END_SIGN_DATE,
                                PR_USER_NAME,
                                S_CTRL_CODE,
                                PR_TYPE,
                                PR_NO,
                                ITEM_NAME
                                ,ITEM_FLAG)  ;

            setStatus(1);
            setValue(rtn);

            setMessage(msg.getMessage("0000"));

        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }

        return getSepoaOut();
    }


	private String et_prReqListItem(
            String START_SIGN_DATE,
            String END_SIGN_DATE,
            String PR_USER_NAME,
            String S_CTRL_CODE,
            String PR_TYPE,
            String PR_NO,
            String ITEM_NAME
            ,String ITEM_FLAG) throws Exception
{
    HOUSE_CODE       = info.getSession("HOUSE_CODE");
    lang             = info.getSession("LANGUAGE");
    ctrl_code        = info.getSession("CTRL_CODE");

    String rtn = null;
    ConnectionContext ctx = getConnectionContext();
    StringTokenizer st = new StringTokenizer(ctrl_code,"&",false);
    int count =  st.countTokens();

    String purchaserUser_seperate="";

    StringTokenizer st1 = new StringTokenizer(ctrl_code,"&",false);
    int count1 =  st1.countTokens();

    for( int i =0; i< count1; i++ )
    {
    	String tmp_ctrl_code = st1.nextToken();

    if( i == 0 )
    	purchaserUser_seperate = "'"+tmp_ctrl_code+"'";
    else if( i == count1-1 )
    	purchaserUser_seperate += ",'"+tmp_ctrl_code+"'";
    else
    	purchaserUser_seperate += ",'"+tmp_ctrl_code+"'";
    }

    Logger.debug.println(info.getSession("ID"),this,"purchaserUser_seperate========================================="+purchaserUser_seperate);

    StringBuffer sql = new StringBuffer();

    sql.append(" SELECT                                                                                                                             \n");
    sql.append("    PRHD.PR_NO,PRDT.ITEM_NO                                                                                                         \n");
    sql.append("	, (SELECT DEPT_NAME_LOC FROM ICOMOGDP WHERE DEPT = PRDT.DEMAND_DEPT) AS DEMAND_DEPT												\n");
//    sql.append("	 ,DECODE(PR_TYPE,'E',GETPRREQSTATUS(PRDT.HOUSE_CODE, PRDT.ITEM_NO, PRDT.PURCHASE_LOCATION, PRDT.SHIPPER_TYPE, PRDT.PLANT_CODE),'신규^A^') AS PR_STATUS	\n");
    sql.append("	 ,DECODE(PR_TYPE,'E',GETPRREQSTATUS(PRDT.HOUSE_CODE, PRDT.ITEM_NO, PRDT.PURCHASE_LOCATION, PRDT.SHIPPER_TYPE),'신규^A^') AS PR_STATUS	\n");
    sql.append("    , GETICOMCODE2(PRHD.HOUSE_CODE, 'M025', PRHD.INTROMTHD) AS SHIPPER_TYPE_TEXT                                                    \n");
    sql.append("    , PRDT.PR_SEQ AS SEQ                                                                                                            \n");
    sql.append("    , PRDT.GDSNM AS ITEM_NAME                                                                                                       \n");
    sql.append("    , PRHD.REGDATE   AS PR_DATE                                                                                                     \n");
    sql.append("    , PRHD.REQDEPT   AS PR_DEPT_NAME                                                                           \n");
    sql.append("    , PRHD.REGPAYNM AS PR_USER_NAME                                                                                                 \n");
    sql.append("    , PRDT.RD_DATE DLVRYDSREDATE                                                                           									\n");
    sql.append("    , GETCTRLCODENAME(PRDT.HOUSE_CODE,PRDT.COMPANY_CODE,'P',PRDT.CTRL_CODE ) CONPRNNM                                                                                                                 \n");
    sql.append("    , PRDT.BID_STATUS                                                                                                               \n");
    sql.append("    , GETICOMCODE2(PRDT.HOUSE_CODE, 'M962', PRDT.BID_STATUS) AS BID_STATUS_TEXT                                                     \n");
    sql.append("    , PRHD.INTROMTHD AS SHIPPER_TYPE                                                                                                \n");
    sql.append("    , PRDT.CONPRNNO                                                                                                                 \n");
    sql.append("    , (SELECT SUM(CTLAMT) FROM ICOYPRAC                                                                                             \n");
    sql.append("        WHERE HOUSE_CODE = PRHD.HOUSE_CODE                                                                                          \n");
    sql.append("        AND   PR_NO      = PRHD.PR_NO) AS CTRL_AMT                                                                                  \n");
    sql.append("    , PRDT.ASUMTNAMT                                                                                                                      \n");
    sql.append("    , (SELECT USER_ID FROM ICOMLUSR WHERE HOUSE_CODE='100' AND EMPLOYEE_NO = PRDT.CONPRNNO) AS USER_ID                              \n");
    sql.append("    , NVL(PRDT.CCY, 'KRW') AS CCY  ,getIcomcode2(PRHD.HOUSE_CODE,'M146',PRHD.pr_type) PR_TYPE_TEXT,PRDT.SPECIFICATION,PRDT.PR_QTY,PRDT.UNIT_MEASURE    \n");

    sql.append("    , NVL((SELECT Z_WORK_STAGE_FLAG FROM ICOMMTGL MTGL                                                                                            \n");
    sql.append("        WHERE HOUSE_CODE = PRDT.HOUSE_CODE                                                                                          \n");
    sql.append("        AND   ITEM_NO      = PRDT.ITEM_NO),'N') AS Z_WORK_STAGE_FLAG                                                                                  \n");
    sql.append("    , PRDT.PLANT_CODE AS PLANT_CODE                                                                                                            \n");
    sql.append("    , PRDT.ARGENT_FLAG 	                                                                                                           \n");

    sql.append(" FROM ICOYPRHD PRHD                                                                                                                 \n");
    sql.append(" , ICOYPRDT PRDT                                                                                                                    \n");
    sql.append(" WHERE PRHD.HOUSE_CODE = '"+HOUSE_CODE+"'                                                                                           \n");
    sql.append("   AND PRHD.COMPANY_CODE = '"+company_code+"'                                                                                            \n");
    sql.append("   AND PRDT.HOUSE_CODE = '"+HOUSE_CODE+"'                                                                                           \n");
//      sql.append("   --AND PRDT.BID_STATUS  IN ('PR', 'NB', 'CC')                                                                                       \n");
    if(ITEM_FLAG.equals("D")){
//    	sql.append("   AND PRHD.INTROMTHD  = 'D'                                                                                       \n");
    }else if(ITEM_FLAG.equals("O")){
//        sql.append("   AND PRHD.INTROMTHD  = 'O'                                                                                       \n");
    }
    sql.append(" <OPT=F,S> AND   PRHD.ADD_DATE BETWEEN ? </OPT>                                                                                      \n");
    sql.append(" <OPT=F,S> AND   ?  </OPT>                                                                                                          \n");
    sql.append(" <OPT=S,S> AND   PRDT.BID_STATUS = ?     </OPT>                                                                                     \n");
    sql.append(" <OPT=S,S> AND   PRHD.PR_NO LIKE '%' || ? || '%'     </OPT>                                                                         \n");
    sql.append(" <OPT=S,S> AND   PRHD.REGPAYNM LIKE '%' || ? || '%'  </OPT>                                                                         \n");

    sql.append(" <OPT=S,S> AND   PRDT.CTRL_CODE = ?  </OPT>                                                                         \n");
    sql.append(" <OPT=S,S> AND   PRDT.GDSNM LIKE '%' || ? || '%'  </OPT>                                                                            \n");
    //sql.append("   AND PRHD.HOUSE_CODE = PRDT.HOUSE_CODE     AND PRDT.SHIPPER_TYPE = 'D' \n");
    sql.append("   AND PRHD.HOUSE_CODE = PRDT.HOUSE_CODE     							   \n");
    sql.append("   AND PRHD.PR_NO = PRDT.PR_NO      \n");
    sql.append("   AND PRDT.PR_PROCEEDING_FLAG ='P' AND PRHD.SIGN_STATUS ='E' AND PRHD.CTRL_SIGN_STATUS ='E'              \n");
    sql.append(" ORDER BY PRHD.REGDATE DESC, PRHD.PR_NO, PRDT.PR_SEQ                                                                                \n");

    Logger.debug.println(info.getSession("ID"), this, sql.toString());

    try{
        SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());


        String[] data ={START_SIGN_DATE,
                END_SIGN_DATE,
                PR_TYPE,
                PR_NO,
                PR_USER_NAME,
                S_CTRL_CODE,
                ITEM_NAME
                };

        rtn = sm.doSelect(data);

    }catch(Exception e) {
    	Logger.err.println(userid,this,e.getMessage());
        throw new Exception(e.getMessage());
    }
    return rtn;
}


	// 사전지원요청 접수(req_type : B) , 구매요청 접수(req_type : P)
//	public SepoaOut doConfirm( String[][] pr, String req_type)
//    {
//		int rtn		 = -1;
//		int rtn_scms = -1;
//        try{
//        	ConnectionContext ctx = getConnectionContext();
//            rtn = et_doConfirm(ctx, pr,req_type );
//
//            Configuration conf = new Configuration();
//            if(conf.getBoolean("Sepoa.scms.if_flag")){
//            	if("B".equals(req_type)){
//    				// 영업관리 시노님 TB_SCM_BR 업데이트
//    				rtn_scms = scms_interface_br(ctx, pr, "A");
//    			}else if("P".equals(req_type)){
//    				// 영업관리 시노님 TB_SCM_PR 업데이트
//    				rtn_scms = scms_interface_pr(ctx, pr, "A");
//    			}
//            }
//
//
//            setStatus(1);
//            setValue(rtn+"");
//            setMessage("접수가 완료되었습니다.");
//			Commit();
//
//        }catch(Exception e) {
//        	Logger.err.println(info.getSession("ID"), this, e.getMessage());
//			try {
//                Rollback();
//            } catch(Exception d) {
//                Logger.err.println(userid,this,d.getMessage());
//            }
//            if(rtn == -1){
//            	setMessage("접수가 실패하였습니다.");
//            }
//
//            if(rtn_scms == -1){
//            	setMessage("접수[인터페이스]가 실패하였습니다.");
//            }
//            setValue(e.getMessage().trim());
//            setStatus(0);
//        }
//
//        return getSepoaOut();
//    }
	
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
	
	@SuppressWarnings("unchecked")
	public SepoaOut doConfirm(Map<String, Object> param) throws Exception{
		ConnectionContext         ctx                            = null;
		List<Map<String, String>> recvdata                       = (List<Map<String, String>>)param.get("recvdata");
		Map<String, String>       recvdataInfo                   = null;
		String                    selectIcoyprhdPcflagInfoResult = null;
		String                    pcFlag                         = null;
		String                    userId                         = info.getSession("ID");
		String                    houseCode                      = info.getSession("HOUSE_CODE");
		SepoaFormater             sf                             = null;
		int                       recvdataSize                   = recvdata.size();
		int                       i                              = 0;
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			for(i = 0; i < recvdataSize; i++){
                recvdataInfo = recvdata.get(i);
                
                recvdataInfo.put("USER_ID",    userId);
                recvdataInfo.put("HOUSE_CODE", houseCode);
                
                this.update(ctx, "et_doConfirm", recvdataInfo);
                
                selectIcoyprhdPcflagInfoResult = this.select(ctx, "selectIcoyprhdPcflagInfo", recvdataInfo);
                
                sf = new SepoaFormater(selectIcoyprhdPcflagInfoResult);
                
                pcFlag = sf.getValue("PC_FLAG", 0);
                
                if("Y".equals(pcFlag)){
                	this.update(ctx, "updateIcoyprdtPcFlagInfo", recvdataInfo);
                }
			}
			
//			정지훈 부장님 확인 후 주석처리 start!
//			Configuration conf = new Configuration();
//			if(conf.getBoolean("Sepoa.scms.if_flag")){
//          	if("B".equals(req_type)){
//  				// 영업관리 시노님 TB_SCM_BR 업데이트
//  				rtn_scms = scms_interface_br(ctx, pr, "A");
//  			}else if("P".equals(req_type)){
//  				// 영업관리 시노님 TB_SCM_PR 업데이트
//  				rtn_scms = scms_interface_pr(ctx, pr, "A");
//  			}
//          }
//			정지훈 부장님 확인 후 주석처리 end!
            
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
    ////////////////////////
    private int et_doConfirm(ConnectionContext ctx, String[][] pr, String req_type ) throws Exception
    {
            String house_code 	= info.getSession("HOUSE_CODE");
            String user_id 		= info.getSession("ID");
            int rtn = 0;

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code",house_code);
			wxp.addVar("user_id", 	user_id);


            try{
                String[] type = {"S","S"};
                SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
                rtn = sm.doUpdate(pr,type);

            }catch(Exception e) {
                    Logger.err.println(info.getSession("ID"),this,e.getMessage());
                    throw new Exception(e.getMessage());
            }
            return rtn;
    }

	// 영업관리 사전지원요청 결과 인터페이스
	private int scms_interface_br(ConnectionContext ctx, String[][] pr, String flag)throws Exception {
		String house_code = info.getSession("HOUSE_CODE");
		int rtn = 0;
		try {

			String[] type = { "S", "S" };
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_TB_SCM_BR_HEAD");
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(pr, type);

			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_TB_SCM_BR");
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("flag", flag);

			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(pr, type);

		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	// 영업관리 구매요청 결과 인터페이스
	private int scms_interface_pr(ConnectionContext ctx, String[][] pr, String flag)throws Exception {
		String house_code = info.getSession("HOUSE_CODE");
		int rtn = 0;
		try {

			String[] type = { "S", "S" };
			/*
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_TB_SCM_PR_HEAD");
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(pr, type);
			*/

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_TB_SCM_PR");
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("flag", flag);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(pr, type);

		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}




}
