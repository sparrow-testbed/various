/**
*
* Copyright 2001-2001 ICOMPIA Co., Ltd. All Rights Reserved.
* This software is the proprietary information of ICOMPIA Co., Ltd.
* @version        1.0
*                                발주 상세조회/수정 (내외자발주)
*                                                                 Andy Shin ...
*/

package sepoa.svc.procure;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

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
import sepoa.svl.util.SepoaStream;
import wisecommon.SignRequestInfo;
import wisecommon.SignResponseInfo;

public class IV_002 extends SepoaService {
        private Message msg = new Message(info,"IV_002");

    public IV_002(String opt,SepoaInfo info) throws SepoaServiceException {

        super(opt,info);
        setVersion("1.0.0");
    } /** *Mainternace */
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

                rtn = setApproval( doc_no, sign_date, sign_user_id,app_rtn);
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

    private int setApproval(String inv_no,
            String sign_date,
            String sign_user_id,
            String app_rtn ) throws Exception {
    	int rtn = -1;
    	try {
    		String house_code = info.getSession("HOUSE_CODE");
    		ConnectionContext ctx = getConnectionContext();

    		SepoaXmlParser wxp = new SepoaXmlParser(this,"et_setIVHD");
			wxp.addVar("app_status", app_rtn);
			wxp.addVar("change_date", SepoaDate.getShortDateString());
			wxp.addVar("change_time", SepoaDate.getShortTimeString());
			wxp.addVar("id", sign_user_id);
			wxp.addVar("house_code", house_code);
			wxp.addVar("inv_no", inv_no);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn = sm.doUpdate();
    	}catch(Exception e) {
    		throw new Exception("setSIGN_STATUS:"+e.getMessage());
    	}
    	return rtn;
    }

    /**
     * 검수요청정보 HEADER
     * @param po_no
     * @param exec_no
     * @param dp_seq
     * @param inv_no
     * @param sign_status
     * @param dp_div
     * @return
     */
    public SepoaOut getIVHeader( String po_no,String exec_no, String dp_seq, String inv_no, String sign_status, String dp_div)
	{
	    try {
	        String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = "";
			if(sign_status.equals("R")){ //반려
				rtnHD = bl_getCNIVHeader(house_code, inv_no);
			}else{
				rtnHD = bl_getCNIVHeader(house_code, po_no, exec_no, dp_seq, dp_div);
			}
			SepoaFormater wf = new SepoaFormater(rtnHD);
			if(wf.getRowCount() == 0) setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

	        setStatus(1);
	        setValue(rtnHD);

	    }catch(Exception e) {
	        Logger.err.println(userid,this,e.getMessage());
	        setStatus(0);
	    }
	    return getSepoaOut();
	}

	/**
	 * 검수요청정보 HEADER_검수요청시
	 * @param house_code
	 * @param po_no
	 * @param exec_no
	 * @param dp_seq
	 * @param dp_div
	 * @return
	 * @throws Exception
	 */
	private String bl_getCNIVHeader( String house_code, String po_no, String exec_no, String dp_seq, String dp_div) throws Exception
	{
	    String rtn = "";
	    ConnectionContext ctx = getConnectionContext();
	    try {
		    //********검수요청시 기성등록정보 사용여부 시작**********************************************
			//2011.09.15 HMCHOI
		    //기성정보를 사용하지 않을 경우 : 검수요청은 수주수량을 기준으로 잔량에서 검수요청을 진행한다.
		    Configuration Sepoa_conf = new Configuration();
		    boolean ivso_use_flag = false;
		    try {
		    	ivso_use_flag = Sepoa_conf.getBoolean("Sepoa.ivso.use."+house_code); //기성정보 사용여부
		    } catch (Exception e) {
		    	ivso_use_flag = false;
		    }
		    //********검수요청시 기성등록정보 사용여부 종료**********************************************

	    	SepoaXmlParser wxp = null;
	    	if (ivso_use_flag) {// 기성등록정보 활용
	    		wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
	    	} else { // 기성등록정보 미활용
	    		wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	    	}
	    	wxp.addVar("house_code", house_code);
	    	wxp.addVar("po_no", po_no);
	    	wxp.addVar("dp_div", dp_div);
	        
	    	SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	        String[] args = null;
	    	if (ivso_use_flag) { // 기성등록정보 활용
	    		args = new String[2];
	    		args[0] = exec_no;
	    		args[1] = dp_seq;
	    	}
	    	rtn = sm.doSelect(args);
	    }
	    catch(Exception e) {
	        throw new Exception("bl_getCNIVHeader:"+e.getMessage());
	    }
	    finally {
	    }
	    return rtn;
	}
	
	/**
	 * 검수요청정보 HEADER_검수반려시
	 * @param house_code
	 * @param inv_no
	 * @return
	 * @throws Exception
	 */
	private String bl_getCNIVHeader( String house_code, String inv_no) throws Exception
	{

	    String rtn = "";
	    ConnectionContext ctx = getConnectionContext();
	    try {
	    	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
	    	wxp.addVar("house_code", house_code);
	        SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	        String[] args = {house_code,inv_no};
	        rtn = sm.doSelect(args);

	    }catch(Exception e) {
	        throw new Exception("bl_getCNIVHeader:"+e.getMessage());
	    } finally {
	    }
	    return rtn;
	}

	/*
	public SepoaOut getIVHeader( String po_no,String iv_no,String inv_no, String sign_status)
	{
	    try {

	        String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = "";
			if(sign_status.equals("R")){
				rtnHD = bl_getIVHeader(house_code, inv_no);
			}else{
				rtnHD = bl_getIVHeader(house_code, po_no, iv_no);
			}
			SepoaFormater wf = new SepoaFormater(rtnHD);
			if(wf.getRowCount() == 0) setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

	        setStatus(1);
	        setValue(rtnHD);

	    }catch(Exception e) {
	        Logger.err.println(userid,this,e.getMessage());
	        setStatus(0);
	    }
	    return getSepoaOut();
	}

	private String bl_getIVHeader( String house_code, String po_no,String iv_no) throws Exception
	{

	    String rtn = "";
	    ConnectionContext ctx = getConnectionContext();
	    try {

	    	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");

	    		wxp.addVar("house_code", house_code);
	    		wxp.addVar("po_no", po_no);
//	        StringBuffer tSQL = new StringBuffer();
//			tSQL.append("			SELECT  IV.IV_NO                                                               	  \n");
//			tSQL.append("				   ,PH.PO_NO                                                               	  \n");
//			tSQL.append("				   ,PH.SUBJECT                                                             	  \n");
//			tSQL.append("				   ,dbo.GETICOMCODE1(PH.HOUSE_CODE,'M134',IV.DP_TYPE) AS DP_TYPE_DESC          	  \n");
//			tSQL.append("				   ,IV.DP_TYPE                                                             	  \n");
//			tSQL.append("				   ,dbo.GETICOMCODE1(PH.HOUSE_CODE,'M010',PH.PAY_TERMS) AS DP_PAY_TERMS_DESC	  \n");
//			tSQL.append("				   ,PH.PAY_TERMS DP_PAY_TERMS                                                        	  \n");
//			tSQL.append("				   ,IV.IV_SEQ                                                              	  \n");
//			tSQL.append("				   ,IV.DP_AMT                                                              	  \n");
//			tSQL.append("				   ,PH.PO_TTL_AMT                                                          	  \n");
//			tSQL.append("				   ,dbo.GETUSERNAMELOC(PH.HOUSE_CODE, PH.ADD_USER_ID) AS USER_NAME             	  \n");
//			tSQL.append("				   ,PH.ADD_USER_ID                                                         	  \n");
//			tSQL.append("				   ,convert(varchar, getdate(), 112) AS INV_DATE                               	  \n");
//			tSQL.append("				   ,PH.REMARK                                                              	  \n");
//			tSQL.append("				   ,IV.DP_PAY_TERMS_TEXT                                                   	  \n");
//			tSQL.append("				   ,PH.PO_CREATE_DATE                                                      	  \n");
//			tSQL.append("				   ,IV.DP_TEXT                                                             	  \n");
//			tSQL.append("				   ,IV.DP_PERCENT                                                          	  \n");
//			tSQL.append("				   ,dbo.GETINVAMT(PH.HOUSE_CODE, PH.PO_NO) AS INV_AMT                          	  \n");
//			tSQL.append("				   ,PH.PR_TYPE                                                             	  \n");
//			tSQL.append("				   ,PH.CTRL_CODE                                                           	  \n");
//			tSQL.append("				   ,PH.CONTRACT_NO                                                         	  \n");
//			tSQL.append("				   ,PH.CONTRACT_FLAG                                                       	  \n");
//			tSQL.append("				   ,PH.CUR                                        			               	  \n");
//			tSQL.append("				   ,(SELECT  MAX(EXCHANGE_RATE)												  \n");
//			tSQL.append("					 FROM ICOYPODT                                                            \n");
//			tSQL.append("					 WHERE HOUSE_CODE = PH.HOUSE_CODE                                         \n");
//			tSQL.append("					   AND PO_NO      = PH.PO_NO) AS EXCHANGE_RATE                      	  \n");
//			tSQL.append("				   ,PH.PO_AMT_KRW                                                       	  \n");
//			tSQL.append("				   ,ECA.AMT_INSU_NUM                                                       	  \n");
//			tSQL.append("				   ,ECA.CONT_INSU_NUM                                                         \n");
//			tSQL.append("				   ,ECA.AS_INSU_NUM                                                       	  \n");
//			tSQL.append("			FROM ICOYIVDP IV, ICOYPOHD PH left outer join (SELECT   EC.CONT_SEQ                                           \n");
//			tSQL.append("													,EC.AMT_INSU_NUM                                       \n");
//	   		tSQL.append("													,EC.CONT_INSU_NUM                                      \n");
//	   		tSQL.append("													,EC.AS_INSU_NUM                                        \n");
//			tSQL.append("											FROM EC_CONTRACT EC                                            \n");
//			tSQL.append("											WHERE EC.CONT_SEQ = (SELECT HD.CONTRACT_NO                     \n");
//			tSQL.append("																 FROM ICOYPOHD HD                          \n");
//			tSQL.append("																 WHERE HD.HOUSE_CODE = '"+house_code+"'    \n");
//			tSQL.append("																   AND HD.PO_NO      = '"+po_no+"')    	   \n");
//			tSQL.append("											  AND EC.INC_CONT_SEQ = (SELECT MAX(INC_CONT_SEQ)              \n");
//			tSQL.append("																	 FROM EC_CONTRACT                      \n");
//			tSQL.append("								   									 WHERE CONT_SEQ = EC.CONT_SEQ)) ECA    \n");
//			tSQL.append("		    on   PH.CONTRACT_NO= ECA.CONT_SEQ                                         	  \n");
//			tSQL.append("			WHERE PH.HOUSE_CODE = IV.HOUSE_CODE                                            	  \n");
//			tSQL.append("		    AND   PH.PO_NO		= IV.PO_NO                                                    \n");
//			tSQL.append("<OPT=S,S>  AND   PH.HOUSE_CODE = ?                               	                    </OPT>\n");
//	 		tSQL.append("<OPT=S,S>  AND   PH.PO_NO		= ?               				                        </OPT>\n");
//	 		tSQL.append("<OPT=S,S>  AND   IV.IV_NO		= ?				                                        </OPT>\n");




	        SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	        String[] args = {house_code ,po_no ,iv_no};
	        rtn = sm.doSelect(args);

	    }catch(Exception e) {
	        throw new Exception("bl_getIVHeader:"+e.getMessage());
	    } finally {
	    }
	    return rtn;
	}

	private String bl_getIVHeader( String house_code,String inv_no) throws Exception
	{

	    String rtn = "";
	    ConnectionContext ctx = getConnectionContext();
	    try {

	    	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");


//	        StringBuffer tSQL = new StringBuffer();
//	        tSQL.append("			SELECT  MAX(VD.IV_NO) AS IV_NO                                                      \n");
//			tSQL.append("				   ,MAX(VD.PO_NO) AS PO_NO                                                      \n");
//			tSQL.append("				   ,VH.SUBJECT                                                                  \n");
//			tSQL.append("				   ,dbo.GETICOMCODE1(VH.HOUSE_CODE,'M134',VH.DP_TYPE) AS DP_TYPE_DESC               \n");
//			tSQL.append("				   ,VH.DP_TYPE                                                                  \n");
//			tSQL.append("				   ,dbo.GETICOMCODE1(VH.HOUSE_CODE,'M101',VH.DP_PAY_TERMS) AS DP_PAY_TERMS_DESC     \n");
//			tSQL.append("				   ,VH.DP_PAY_TERMS                                                             \n");
//			tSQL.append("				   ,VH.IV_SEQ                                                                   \n");
//			tSQL.append("				   ,VH.DP_AMT                                                                   \n");
//			tSQL.append("				   ,VH.PO_TTL_AMT                                                               \n");
//			tSQL.append("				   ,dbo.GETUSERNAMELOC(PH.HOUSE_CODE, PH.ADD_USER_ID) AS USER_NAME                  \n");
//			tSQL.append("				   ,PH.ADD_USER_ID                                                              \n");
//			tSQL.append("				   ,VH.INV_DATE                                                                 \n");
//			tSQL.append("				   ,VH.REMARK                                                                   \n");
//			tSQL.append("				   ,VH.DP_PAY_TERMS_TEXT                                                        \n");
//			tSQL.append("				   ,VH.PO_CREATE_DATE                                                           \n");
//			tSQL.append("				   ,VH.DP_TEXT                                                                  \n");
//			tSQL.append("				   ,VH.DP_PERCENT                                                               \n");
//			tSQL.append("				   ,VH.INV_AMT                                                                  \n");
//			tSQL.append("				   ,PH.PR_TYPE                                                                  \n");
//			tSQL.append("				   ,PH.CONTRACT_NO                                                              \n");
//			tSQL.append("				   ,PH.CONTRACT_FLAG                                                            \n");
//			tSQL.append("			FROM ICOYPOHD PH, ICOYIVHD VH, ICOYIVDT VD                                          \n");
//			tSQL.append("			WHERE PH.HOUSE_CODE = VD.HOUSE_CODE                                                 \n");
//			tSQL.append("			AND   PH.PO_NO		= VD.PO_NO                                                      \n");
//			tSQL.append("			AND   VH.HOUSE_CODE = VD.HOUSE_CODE                                                 \n");
//			tSQL.append("			AND   VH.INV_NO		= VD.INV_NO                                                     \n");
//			tSQL.append("<OPT=S,S>  AND   VH.HOUSE_CODE = ?	                                                      </OPT>\n");
//			tSQL.append("<OPT=S,S>  AND   VH.INV_NO		= ?  	                                                  </OPT>\n");
//			tSQL.append("			GROUP BY  VH.SUBJECT                                                                \n");
//			tSQL.append("				   	 ,VH.HOUSE_CODE                                                             \n");
//			tSQL.append("				   	 ,VH.DP_TYPE                                                                \n");
//			tSQL.append("				   	 ,VH.DP_PAY_TERMS                                                           \n");
//			tSQL.append("				   	 ,VH.IV_SEQ                                                                 \n");
//			tSQL.append("				   	 ,VH.DP_AMT                                                                 \n");
//			tSQL.append("				   	 ,VH.PO_TTL_AMT                                                             \n");
//			tSQL.append("				   	 ,PH.ADD_USER_ID                                                            \n");
//			tSQL.append("				   	 ,VH.INV_DATE                                                               \n");
//			tSQL.append("				   	 ,VH.REMARK                                                                 \n");
//			tSQL.append("				   	 ,VH.DP_PAY_TERMS_TEXT                                                      \n");
//			tSQL.append("				   	 ,VH.PO_CREATE_DATE                                                         \n");
//			tSQL.append("				   	 ,VH.DP_TEXT                                                                \n");
//			tSQL.append("				   	 ,VH.DP_PERCENT                                                             \n");
//			tSQL.append("				   	 ,VH.INV_AMT                                                                \n");
//			tSQL.append("				   	 ,PH.PR_TYPE                                                                \n");
//			tSQL.append("				   	 ,PH.HOUSE_CODE																\n");
//			tSQL.append("				   	 ,PH.CONTRACT_NO															\n");
//			tSQL.append("				   	 ,PH.CONTRACT_FLAG      													\n");


	        SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	        String[] args = {house_code,inv_no};
	        rtn = sm.doSelect(args);

	    }catch(Exception e) {
	        throw new Exception("bl_getIVHeader:"+e.getMessage());
	    } finally {
	    }
	    return rtn;
	}
	*/
	
public SepoaOut getInvoiceTargetList(Map<String, Object> data) {
		
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		
		try {
			String house_code = info.getSession("HOUSE_CODE");
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
        	
        	//********검수요청시 기성등록정보 사용여부 시작**********************************************
			//2011.09.15 HMCHOI
		    //기성정보를 사용하지 않을 경우 : 검수요청은 수주수량을 기준으로 잔량에서 검수요청을 진행한다.
		    Configuration Sepoa_conf = new Configuration();
		    boolean ivso_use_flag = false;
		    try {
		    	ivso_use_flag = Sepoa_conf.getBoolean("Sepoa.ivso.use."+house_code); //기성정보 사용여부
		    } catch (Exception e) {
		    	ivso_use_flag = false;
		    }
		    //********검수요청시 기성등록정보 사용여부 종료**********************************************
		    
			if (ivso_use_flag) {
				sxp = new SepoaXmlParser(this, "getInvoiceTargetList");
				sxp.addVar("language", info.getSession("LANGUAGE"));
	        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	        	setValue(ssm.doSelect(header, customHeader));
			} // 기성등록정보를 사용하지 않을 경우
			else {
				sxp = new SepoaXmlParser(this, "getInvoiceTargetList2");
				sxp.addVar("language", info.getSession("LANGUAGE"));
	        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	        	setValue(ssm.doSelect(header, customHeader));
			}
		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	public SepoaOut getDoIvdpList(String from_date, String to_date, String vendor_code
			,String ctrl_person_id, String subject, String sign_status)
	{
		try {
			String house_code = info.getSession("HOUSE_CODE");
			
		    //********검수요청시 기성등록정보 사용여부 시작**********************************************
			//2011.09.15 HMCHOI
		    //기성정보를 사용하지 않을 경우 : 검수요청은 수주수량을 기준으로 잔량에서 검수요청을 진행한다.
		    Configuration Sepoa_conf = new Configuration();
		    boolean ivso_use_flag = false;
		    try {
		    	ivso_use_flag = Sepoa_conf.getBoolean("Sepoa.ivso.use."+house_code); //기성정보 사용여부
		    } catch (Exception e) {
		    	ivso_use_flag = false;
		    }
		    //********검수요청시 기성등록정보 사용여부 종료**********************************************
		    
		    String rtnHD = "";
			if (ivso_use_flag) {
				rtnHD = bl_getDoIvdpList( house_code
						,from_date
						,to_date
						,vendor_code
						,ctrl_person_id
				        ,subject
				        ,sign_status
				);
			} // 기성등록정보를 사용하지 않을 경우
			else {
				rtnHD = bl_getDoIvdpList2( house_code
						,from_date
						,to_date
						,vendor_code
						,ctrl_person_id
				        ,subject
				        ,sign_status
				);
			}

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if(wf.getRowCount() == 0) setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

			setStatus(1);
			setValue(rtnHD);

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	/**
	 * 기성등록정보를 활용한 검수요청현황
	 * @param house_code
	 * @param from_date
	 * @param to_date
	 * @param vendor_code
	 * @param ctrl_person_id
	 * @param subject
	 * @param sign_status
	 * @return
	 * @throws Exception
	 */
	private String bl_getDoIvdpList( String house_code
			,String from_date
			,String to_date
			,String vendor_code
			,String ctrl_person_id
			,String subject
			,String sign_status) throws Exception {
		
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try
		{
		    SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			// 기성등록정보를 사용할 경우
			String[] args = {house_code ,from_date ,to_date ,vendor_code
					, house_code ,from_date ,to_date ,vendor_code
					, house_code ,from_date ,to_date ,vendor_code
					, ctrl_person_id, subject, sign_status
					};
			rtn = sm.doSelect(args);
		}
		catch(Exception e) {
			throw new Exception("bl_getIvdpList:"+e.getMessage());
		}
		finally {
		}
		return rtn;
	}
	
	/**
	 * 기성등록정보를 활용하지 않은 검수요청현황
	 * @param house_code
	 * @param from_date
	 * @param to_date
	 * @param vendor_code
	 * @param ctrl_person_id
	 * @param subject
	 * @param sign_status
	 * @return
	 * @throws Exception
	 */
	private String bl_getDoIvdpList2( String house_code, String from_date, String to_date
			,String vendor_code, String ctrl_person_id, String subject,String sign_status)
		throws Exception {
		
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try
		{
		    SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			// 기성등록정보를 사용할 경우
			String[] args = {house_code, from_date, to_date, vendor_code
							,ctrl_person_id, subject, sign_status
							};
			rtn = sm.doSelect(args);
		}
		catch(Exception e) {
			throw new Exception("bl_getIvdpList2:"+e.getMessage());
		}
		finally {
		}
		return rtn;
	}

	/**
	 * 기성정보를 활용하지 않는 검수요청 처리현황
	 * @param from_date
	 * @param to_date
	 * @param vendor_code
	 * @param ctrl_person_id
	 * @param subject
	 * @param sign_status
	 * @return
	 */
	public SepoaOut getIvdpList(String from_date, String to_date, String vendor_code
			,String ctrl_person_id, String subject, String sign_status)
	{
		try {
			String house_code = info.getSession("HOUSE_CODE");
			
		    String rtnHD = "";
			rtnHD = bl_getIvdpList( house_code
					,from_date
					,to_date
					,vendor_code
					,ctrl_person_id
			        ,subject
			        ,sign_status
			);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if(wf.getRowCount() == 0) setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

			setStatus(1);
			setValue(rtnHD);

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	/**
	 * 기성등록정보를 활용하지 않은 검수요청 처리현황
	 * @param house_code
	 * @param from_date
	 * @param to_date
	 * @param vendor_code
	 * @param ctrl_person_id
	 * @param subject
	 * @param sign_status
	 * @return
	 * @throws Exception
	 */
	private String bl_getIvdpList( String house_code, String from_date, String to_date
			,String vendor_code, String ctrl_person_id, String subject,String sign_status)
		throws Exception {
		
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try
		{
		    SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			// 기성등록정보를 사용할 경우
			String[] args = {house_code, from_date, to_date, vendor_code
							,ctrl_person_id, subject, sign_status
							};
			rtn = sm.doSelect(args);
		}
		catch(Exception e) {
			throw new Exception("bl_getIvdpList:"+e.getMessage());
		}
		finally {
		}
		return rtn;
	}
	
	public SepoaOut getItemList(String po_no, String po_seq, String inv_no, String dp_type)
	{
		try {

			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = "";
			if(inv_no.equals("")){
				rtnHD = bl_getItemList( house_code, po_no, po_seq, dp_type);
			}else{
				rtnHD = bl_getItemList(inv_no);
			}

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if(wf.getRowCount() == 0) setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

			setStatus(1);
			setValue(rtnHD);

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

	private String bl_getItemList( String house_code, String po_no, String po_seq, String dp_type) throws Exception
	{

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {

			SepoaXmlParser wxp = new SepoaXmlParser (this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] args = {house_code ,po_no, po_seq, dp_type};
			rtn = sm.doSelect(args);

		}catch(Exception e) {
			throw new Exception("bl_getIvdpDesc:"+e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 검수요청 현황 DT - 조회
	 **/

	private String bl_getItemList(String inv_no) throws Exception
	{

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] args = {house_code ,inv_no};
			rtn = sm.doSelect(args);

		}catch(Exception e) {
			throw new Exception("bl_getIvdpDesc:"+e.getMessage());
		} finally {
		}
		return rtn;
	}
	/**
	 *  검수 요청 현황 DT - 검수 요청
	 * @param setHDData
	 * @param setDTData
	 * @return
	 * @throws SepoaServiceException
	 */
	public SepoaOut setInv(String[][] setHDData, String[][] setDTData, String[][] setcndpData) throws SepoaServiceException
	{
	    try {
            int hdrow = in_setIvhd(setHDData);
            Logger.debug.println(this, "[setInv][in_setIvhd]*********************************************************  Return::"+hdrow);
            int dtrow = in_setIvdt(setDTData);
            Logger.debug.println(this, "[setInv][in_setIvdt]*********************************************************  Return::"+dtrow);
            int cndprow=0;
            if(setcndpData==null){
            }else{
            	cndprow = in_setCndp(setcndpData);
            	Logger.debug.println(this, "[setInv][in_setCndp]*****************************************************  Return::"+cndprow);
            }

            //평가 정보 등록
            //int ieval = setEvalInsert(setDTData[0][1], setDTData[0][4], setHDData[0][2],setHDData[0][25], setHDData[0][26]);

            setValue("Insert Row="+dtrow);

            Commit();
            setStatus(1);
            setMessage("검수요청번호 "+setHDData[0][1]+"가 생성 되었습니다.");
        }catch(Exception e)
        {
        	Logger.err.println("Exception e =" + e.getMessage());
        	Rollback();
            setStatus(0);
            setMessage("에러가 발생하였습니다.");
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
	}

    private int in_setIvhd(String[][] setData) throws Exception
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        String user_id        = info.getSession("ID");
        Configuration con = new Configuration();
        String company_code = con.get("Sepoa.company.code");
        try {

        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	wxp.addVar("company_code", company_code);
            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

            //넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
            String[] type = {"S","S","S","S","S",
            				 "S","S","S","S","N",
            				 "S","S","N","S","N",
            				 "S","S","S","S","S",
            				 "N","S","S","S","S",
            				 "S","S"};
            rtn = sm.doInsert(setData, type);
        }catch(Exception e) {
                throw new Exception("in_setIvdp:"+e.getMessage());
            } finally{
        }
        return rtn;
    }

    private int in_setIvdt(String[][] setData) throws Exception
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        String user_id        = info.getSession("ID");

        try {

        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

            //넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
            String[] type = {"S","S","S","S","S",
            				 "S","S","S","S","S",
            				 "S","S","S","S","S",
            				 "S","S","S","S","S",
            				 "S","S","S","S","S"};
            rtn = sm.doInsert(setData, type);
        }catch(Exception e) {
                throw new Exception("in_setIvdt:"+e.getMessage());
            } finally{
        }
        return rtn;
    }

    private int in_setCndp(String[][] setData) throws Exception
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        String user_id        = info.getSession("ID");

        try {

        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

            //넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
            String[] type = {"S","S","S","S","S",
            				 "S","S","S","S","S",
            				 "S","S","S","S","S"};

            rtn = sm.doInsert(setData, type);

        }catch(Exception e) {
        	Rollback();
                throw new Exception("in_setCndp:"+e.getMessage());
            } finally{
        }
        return rtn;
    }

    public SepoaOut updateInv(String[][] setDTData, String[][] setCNDPData, String attach_no, String po_no, String subject, String dp_percent, String start_date, String to_date)
	{
	    try {
            int dtrow = in_updateIvdt(setDTData, attach_no, dp_percent);
            int cndprow=0;

            if(setCNDPData[0]==null){
            }else{
            	cndprow = in_setCndp(setCNDPData);
            	Logger.debug.println(this, "[updateInv][in_setCndp]*****************************************************  Return::"+cndprow);
            }

            //평가 정보 등록
            int ieval = setEvalInsert(setDTData[0][7], po_no, subject, start_date, to_date);

            if(dtrow > 0){
            	Commit();
            	setStatus(1);
            	setMessage("검수요청번호 "+setDTData[0][7]+"로 요청 하였습니다.");
        	}else{
        		Rollback();
            	setStatus(0);
            	setMessage("검수요청에 실패하였습니다.");
        	}
        }catch(Exception e)
        {
        	Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            setMessage("에러가 발생하였습니다.");
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
	}

    private int in_updateIvdt(String[][] setData, String attach_no, String dp_percent) throws Exception
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        String user_id        = info.getSession("ID");
        String house_code	  =info.getSession("house_code");
        try {

        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");

        	 String[] type = {"S","S","S","S","S",
            				 "S","S","S","S"};
            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
        	rtn = sm.doInsert(setData, type);

            float fDpAmt = 0;
            for(int i=0;i<setData.length;i++){
            	fDpAmt += Float.valueOf( setData[i][5]);
            }

            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");

            Logger.debug.println(this,"DP_AMT::"+fDpAmt);

		        wxp.addVar("setData3", setData[0][3]);
		        wxp.addVar("setData4", setData[0][4]);
		        wxp.addVar("house_code", house_code);
		        wxp.addVar("attach_no", attach_no);
		        wxp.addVar("setData6", setData[0][7]);
		        wxp.addVar("dp_amt", String.valueOf(fDpAmt));
		        wxp.addVar("dp_percent", dp_percent);

			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

            rtn = sm.doInsert();
        }catch(Exception e) {
                throw new Exception("in_setIvdp:"+e.getMessage());
            } finally{
        }
        return rtn;
    }


	/**
	 * 최종검수여부 조회
	 **/
	private String bl_getLastInvFlag(String inv_no, String po_no) throws Exception
	{

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("inv_no", inv_no);
			wxp.addVar("po_no", po_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn = sm.doSelect();

		}catch(Exception e) {
			throw new Exception(this+"bl_getLastInvFlag:"+e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 수행평가 번호 가져오기
	 **/
	private String bl_getEvalCode(String inv_no) throws Exception
	{

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("inv_no", inv_no);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn = sm.doSelect();

		}catch(Exception e) {
			throw new Exception(this+"bl_getEvalCode:"+e.getMessage());
		} finally {
		}
		return rtn;
	}



	/*
	 * 평가 템플릿 코드 가져오기
	 * 2010.07.
	 */
	public String getEvalTemplate(Integer eval_id){
		String rtn = null;
		try{
			rtn = et_getEvalTemplate(eval_id);

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0005"));
		}
		return rtn;
	}


	private	String et_getEvalTemplate(Integer eval_id) throws Exception
	{


		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try{
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("code", eval_id.toString());
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect();
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}


	/*
	 * 평가 대상업체 가져오기
	 * 2010.07.
	 */
	public String getEvalCompany(String doc_no, String doc_count){
		String rtn = null;
		try{
			rtn = et_getEvalCompany(doc_no, doc_count);

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0005"));
		}
		return rtn;
	}


	private	String et_getEvalCompany(String doc_no, String doc_count) throws Exception
	{


		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try{
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("doc_no", doc_no);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect();
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	/*
	 * 평가 대상 정보 가져오기
	 * 2010.07.
	 */
	public String getEvalInfo(String doc_no, String doc_count){
		String rtn = null;
		try{
			rtn = et_getEvalInfo(doc_no, doc_count);
			
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0005"));
		}
		return rtn;
	}
	
	
	private	String et_getEvalInfo(String doc_no, String doc_count) throws Exception
	{
		
		
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
		
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try{
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("doc_no", doc_no);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect();
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}


	/*
	 * 평가 대상업체, 개발자 가져오기
	 * 2010.07.
	 */
	public String getEvalCompanyHuman(String doc_no, String doc_count){
		String rtn = null;
		try{
			rtn = et_getEvalCompanyHuman(doc_no, doc_count);

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0005"));
		}
		return rtn;
	}
	
	/*
	 * 평가 대상업체, 개발자 가져오기
	 * 2010.07.
	 */
	public ArrayList<HashMap<String,String>> getEvalCompanyHuman_1(String pjt_code, String start_date, String end_date){
		String rtn = null;
		ArrayList<HashMap<String,String>> result = null;
		try{
			//PmsView pms = new PmsView("CONNECTION", info);
			 //result = pms.getDevView(pjt_code, start_date, end_date);
			
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0005"));
		}
		return result;
	}


	private	String et_getEvalCompanyHuman(String doc_no, String doc_count) throws Exception
	{


		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try{
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("doc_no", doc_no);

			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect();
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	/*
	 * 평가 담당자  가져오기
	 * 2010.07.
	 */
	public String getEvalUser(String doc_no, String doc_count){
		String rtn = null;
		try{
			rtn = et_getEvalUser(doc_no, doc_count);

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0005"));
		}
		return rtn;
	}


	private	String et_getEvalUser(String doc_no, String doc_count) throws Exception
	{


		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try{
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("doc_no", doc_no);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect();
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	/*
	 * 평가 여부  및 평가 생성
	 * 2010.07.
	 */
	public int setEvalInert(String doc_no, String doc_count, String eval_name, String eval_flag, String template_id,  String eval_id, String from_date, String to_date){
		int rtn = 0;

		try{
			rtn = et_setEvalInert(doc_no, doc_count, eval_name, eval_flag, template_id, eval_id, from_date, to_date);

			setValue(String.valueOf(rtn));
			if(rtn==0){
				Rollback();
				setStatus(0);
				setMessage("평가정보 처리중 오류가 발생하였습니다.");
			}else{
				Commit();
				setStatus(1);
				setMessage("평가정보가 정상적으로 처리되었습니다.");
			}

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage("평가정보 처리중 오류가 발생하였습니다.");
		}
		return rtn;
	}


	private	int et_setEvalInert(String doc_no, String doc_count, String eval_name, String eval_flag, String template_id, String eval_id, String from_date, String to_date) throws Exception
	{
		int rtn =  0;
		ConnectionContext ctx =	getConnectionContext();
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [doc_no]::"+doc_no);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [doc_count]::"+doc_count);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_name]::"+eval_name);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_flag]::"+eval_flag);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [template_id]::"+template_id);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_id]::"+eval_id);

		try{
			Integer eval_refitem = 0;
			if(!"N".equals(eval_flag)){	//평가제외가 아닐 경우 평가 생성.
				Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 START");
				//1) 업체평가 입력
				String rtn1 =  et_setEvalInsert(doc_no, doc_count, eval_name, template_id, eval_id, from_date, to_date);

		        if("".equals(rtn1)){
		            Rollback();
		            setStatus(0);
		            setMessage(msg.getMessage("9003"));
		            return 0;
		        }

		        eval_refitem = Integer.valueOf(rtn1);
		        
		        //2) 개발자 평가 입력
		        if(from_date != null && !from_date.equals("")){
			        template_id = getConfig("Sepoa.eval.human");
					Logger.debug.println(info.getSession("ID"),this, "=========================개발자 평가 생성 START");
					rtn1 =  et_setEvalInsert(doc_no, doc_count, eval_name, template_id, eval_id, from_date, to_date);

			        if("".equals(rtn1)){
			            Rollback();
			            setStatus(0);
			            setMessage(msg.getMessage("9003"));
			            return 0;
			        }
		        }
			}
			Logger.debug.println(info.getSession("ID"),this, "=========================평가 상태 등록");

			wxp.addVar("eval_flag", eval_flag);
			wxp.addVar("eval_refitem", eval_refitem);
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("doc_no", doc_no);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doUpdate();
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}


	private String et_setEvalInsert(String doc_no, String doc_count, String eval_name, String template_id, String eval_id, String eval_from_date, String eval_to_date) throws Exception
	{
		String returnString = "";
		ConnectionContext ctx = getConnectionContext();

		String user_id 		= info.getSession("ID");
		String house_code 	= info.getSession("HOUSE_CODE");

		int rtnIns = 0;
		SepoaFormater wf = null;
		SepoaSQLManager sm = null;

		try
		{
			String auto = "N";
			String evaltemp_num	= template_id;
			
   	     	String from_date  	= SepoaDate.getShortDateString();
			String to_date  	= SepoaDate.addSepoaDateDay(from_date, 5);

			String flag			= "2"; 	//eval_status[2]

			Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 템플릿코드::"+evaltemp_num);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[doc_no]::"+doc_no);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[doc_count]::"+doc_count);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[from_date]::"+from_date);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[to_date]::"+to_date);

			//평가자 조회
			String rtn2 = getEvalUser(doc_no, doc_count);
			wf =  new SepoaFormater(rtn2);
			String[] eval_user_id = new String[wf.getRowCount()];
			String[] eval_user_dept = new String[wf.getRowCount()];
			for(int	i=0; i<wf.getRowCount(); i++) {
				eval_user_id[i] = wf.getValue("PROJECT_PM", i);
				eval_user_dept[i] = wf.getValue("PROJECT_DEPT", i);
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자::"+eval_user_id[i]);
			}

			String eval = getConfig("Sepoa.eval.human");

			String setData[][] = null;
			String rtn3 = "";
			if(eval.equals(template_id)){
				//평가업체, 개발자 조회
				rtn3 = getEvalInfo(doc_no, doc_count);
				wf =  new SepoaFormater(rtn3);
				
				/* to_do
				 * 개발자리스트를 PMS VIEW를 통해 조회한다.
				 */
				ArrayList<HashMap<String,String>> result = getEvalCompanyHuman_1(wf.getValue("PMS_ID", 0), eval_from_date, eval_to_date);
                if(result == null || eval_user_id == null){ throw new Exception("null");  }
				setData = new String[result.size() * eval_user_id.length][];
				int kk=0;
				for(int	i=0; i<result.size(); i++) {
					HashMap<String, String> lsMap = result.get(i);
					for(int j=0; j<eval_user_id.length; j++){
						Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가업체::"+wf.getValue("VENDOR_CODE", 0) + ",개발자::"+lsMap.get("HUMAN_NO"));
						String Data[] = { wf.getValue("VENDOR_CODE", 0), "N", "0", eval_user_id[j], eval_user_dept[j], lsMap.get("HUMAN_NO"), lsMap.get("INPUT_FROM_DATE"), lsMap.get("INPUT_TO_DATE")};
						setData[kk] = Data;
						kk++;
					}
				}
				// to_do TEMPLATE값을 변경합니다.
				//evaltemp_num = wf.getValue("E_TEMPLATE_ID", i);
			}else{
				//평가업체 조회
				rtn3 = getEvalCompany(doc_no, doc_count);
				wf =  new SepoaFormater(rtn3);

				setData = new String[wf.getRowCount()*eval_user_id.length][];
				int kk=0;
				for(int	i=0; i<wf.getRowCount(); i++) {
					for(int j=0; j<eval_user_id.length; j++){
						Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가업체::"+wf.getValue("VENDOR_CODE", i));
						String Data[] = { wf.getValue("VENDOR_CODE", i), "N", "0", eval_user_id[j], eval_user_dept[j], "", "", ""};
						setData[kk] = Data;
						kk++;
					}
				}
			}

			if(setData.length == 0){
				Logger.warn.println(info.getSession("ID"), this, "=========평가정보 생성에 실패하였습니다. template_id="+template_id);
				Logger.warn.println(info.getSession("ID"), this, "=========평가구분="+ (eval.equals(template_id) ? "개발자평가" : "업체평가"));
				returnString = "false";
			}
			
			//평가마스터 일련번호 조회
    		SepoaXmlParser wxp =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_0");
			wxp.addVar("house_code", house_code);
			sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
  	    	String rtn = sm.doSelect();
  	    	wf =  new SepoaFormater(rtn);

  	    	String max_eval_refitem = "";
	    	if(wf != null && wf.getRowCount() > 0) {
	    		max_eval_refitem = wf.getValue("MAX_EVAL_REFITEM", 0);
			}

			//평가테이블 생성 - ADD( 견적[RQ]/입찰[BD]/역경매[RA] 구분, 문서번호, 문서SEQ 등록)
	    	SepoaXmlParser wxp_1 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_1");
	    	wxp_1.addVar("house_code", house_code);
	    	wxp_1.addVar("max_eval_refitem", max_eval_refitem);
	    	wxp_1.addVar("evalname", eval_name);
	    	wxp_1.addVar("flag", flag);
	    	wxp_1.addVar("evaltemp_num", evaltemp_num);
	    	wxp_1.addVar("fromdate", from_date);
	    	wxp_1.addVar("todate", to_date);
	    	wxp_1.addVar("auto", auto);
	    	wxp_1.addVar("user_id", user_id);
	    	wxp_1.addVar("DOC_TYPE", "IV");	//검수
	    	wxp_1.addVar("DOC_NO", doc_no);
	    	wxp_1.addVar("DOC_COUNT", doc_count);
			sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_1.getQuery() );
			rtnIns = sm.doInsert(  );
			Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가마스터 정보 저장 끝");

			String i_sg_refitem = "";
			String i_vendor_code = "";
			String i_value_id = "";
			String i_value_dept = "";
			String i_human_no = "";
			String i_input_from_date = "";
			String i_input_to_date = "";

			//평가대상업체 테이블 생성
			SepoaXmlParser wxp_2 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_2_2");

			//평가대상업체 평가자 테이블 생성
			SepoaXmlParser wxp_3 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_3");
				
			for ( int i = 0; i < setData.length; i++ )
			{
				i_sg_refitem 	= setData[i][2];
				i_vendor_code 	= setData[i][0];
				i_value_id 		= setData[i][3];
				i_value_dept 	= setData[i][4];
				i_human_no 		= setData[i][5];
				i_input_from_date = setData[i][6];
				i_input_to_date   = setData[i][7];

				//평가대상업체 테이블 생성
				wxp_2.addVar("house_code", house_code);
				wxp_2.addVar("i_sg_refitem", i_sg_refitem);
				wxp_2.addVar("i_vendor_code", i_vendor_code);
				wxp_2.addVar("max_eval_refitem", max_eval_refitem);
				wxp_2.addVar("i_human_no", i_human_no);
				wxp_2.addVar("input_from_date", i_input_from_date);
				wxp_2.addVar("input_to_date", i_input_to_date);

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_2.getQuery() );
				rtnIns = sm.doInsert(  );
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가대상업체 정보 저장 끝");

				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자 ::"+i_value_id);
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자 부서 ::"+i_value_dept);

				String i_dept = "";
				String i_id = "";

				//평가대상업체 평가자 테이블 생성
				wxp_3.addVar("house_code", house_code);
				wxp_3.addVar("i_dept", i_value_dept);
				wxp_3.addVar("i_id", i_value_id);
				wxp_3.addVar("getCurrVal", getCurrVal("icomvevd", "eval_item_refitem"));

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_3.getQuery() );
				rtnIns = sm.doInsert(  );
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가 평가자 정보 저장 끝");

				//평가일련번호를 리턴해 줌.
				returnString = max_eval_refitem;
			}

			//Commit();
		} catch( Exception e ) {
			Rollback();
			Logger.err.println(this, "Error ::"+e.getMessage());
			returnString = "";
		} finally { }

		return returnString;
	}

	 public double getCurrVal(String tableName, String columnName){
	    	double currVal = 0;
	  	    SepoaOut wo = currvalForMssql(tableName, columnName);
	  	    try{
		  	    SepoaFormater wf2 = new SepoaFormater(wo.result[0]);
		  	    currVal = Double.parseDouble((wf2.getValue("CURRVAL",0)));
	  	    } catch(Exception e){
	  	    	currVal = 0;
	  	    }
	    	return currVal;
	 }

	 public SepoaOut currvalForMssql(String tableName, String columnName){

         try{
              String rtn = "";
      		ConnectionContext ctx = getConnectionContext();
      		String house_code = info.getSession("HOUSE_CODE");
      		String user_id = info.getSession("ID");

  			SepoaXmlParser wxp =  new SepoaXmlParser("master/evaluation/p0080","currvalForMssql");
			wxp.addVar("columnName", columnName);
			wxp.addVar("tableName", tableName);
			wxp.addVar("house_code", house_code);

  			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
  			rtn = sm.doSelect();

              setValue(rtn);
              setStatus(1);

          } catch(Exception e) {

              Logger.err.println("Exception e =" + e.getMessage());
              setStatus(0);
              Logger.err.println(this,e.getMessage());
          }
          return getSepoaOut();
      }

	private int setEvalInsert(String inv_no, String po_no, String eval_name, String from_date, String to_date){
		int irow = 0;
		try{

			 // 최종 검수요청여부 조회.
	        Logger.debug.println(this, "[setInv][bl_getLastInvFlag]**************************************************  ORIGINAL PO_NO::"+po_no);
	        String rtnInv = bl_getLastInvFlag(inv_no, po_no);

	        SepoaFormater wf = new SepoaFormater(rtnInv);
	        int iRowCount = 0;
	        String evalLastFlag = "";
			if(!(0 == wf.getRowCount())){
				iRowCount = wf.getRowCount();
				for(int i=0; i<iRowCount; i++){
					Logger.debug.println(this, "[setInv][bl_getLastInvFlag]****************** PO_NO ::"+wf.getValue("PO_NO"			, i));
					Logger.debug.println(this, "[setInv][bl_getLastInvFlag]****************** PO_ITEM_QTY ::"+wf.getValue("PO_ITEM_QTY"	, i));
					Logger.debug.println(this, "[setInv][bl_getLastInvFlag]****************** PO_ITEM_AMT ::"+wf.getValue("PO_ITEM_AMT"	, i));
					Logger.debug.println(this, "[setInv][bl_getLastInvFlag]****************** INV_ITEM_QTY ::"+wf.getValue("INV_ITEM_QTY"	, i));
					Logger.debug.println(this, "[setInv][bl_getLastInvFlag]****************** INV_ITEM_AMT ::"+wf.getValue("INV_ITEM_AMT"	, i));
					Logger.debug.println(this, "[setInv][bl_getLastInvFlag]****************** GR_QTY ::"+wf.getValue("GR_QTY"		, i));
					Logger.debug.println(this, "[setInv][bl_getLastInvFlag]****************** INV_QTY ::"+wf.getValue("INV_QTY"		, i));
					evalLastFlag = wf.getValue("EVAL_LAST_FLAG"		, i);
				}
			}
			Logger.debug.println(this, "[setInv][bl_getLastInvFlag]****************** EVAL_LAST_FLAG ::"+evalLastFlag);

			String rtnEvlCode = "";
			String sEvalCode = "";
			String sEvalId = "";
			String sInv_No = inv_no;
			Logger.debug.println(this, "[setInv][bl_getEvalCode]****************** INV_NO ::"+sInv_No);
			Logger.debug.println(this, "[setInv][bl_getEvalCode]****************** SUBJECT ::"+eval_name);
			//if("Y".equals(evalLastFlag)){	//최종검수일경우 평가생성.
				rtnEvlCode = bl_getEvalCode(sInv_No);
				SepoaFormater wfevl = new SepoaFormater(rtnEvlCode);
				if(!(0 == wfevl.getRowCount())){
					sEvalCode = wfevl.getValue("TEMPLATE_ITEM", 0);	//수행평가 템플릿코드
					sEvalId = wfevl.getValue("EVAL_ID", 0);		//선정평가 코드
					Logger.debug.println(this, "[setInv][bl_getEvalCode]****************** TEMPLATE_ITEM ::"+sEvalCode);
					irow = setEvalInert(sInv_No, "", eval_name, "T", sEvalCode, sEvalId, from_date, to_date);
				}else{
					throw new Exception("평가템플릿을 가져올 수 없습니다.");
				}
			//}
		 } catch(Exception e) {

             Logger.err.println("Exception e =" + e.getMessage());
             setStatus(0);
             Logger.err.println(this,e.getMessage());
         }
		 return irow;
	}


    /* 
     * public SepoaOut setAppInv(SepoaStream ws)
    {
    	String add_user_id     =  info.getSession("ID");
        String house_code      =  info.getSession("HOUSE_CODE");
        String company         =  info.getSession("COMPANY_CODE");
        String add_user_dept   =  info.getSession("DEPARTMENT");
        String dept_name       =  info.getSession("DEPARTMENT_NAME_LOC");
        String name_eng        =  info.getSession("NAME_ENG");
        String name_loc        =  info.getSession("NAME_LOC");
        String lang            =  info.getSession("LANGUAGE");
    	Message msg            =  new Message(info,"");

        try
        {
            int hd_rtn = et_setIVHD(ws);
            if(hd_rtn<1)
            	throw new Exception(msg.getMessage("0003"));

            if("P".equals(ws.getParam("sign_status")))
            {
                Sepoacommon.SignRequestInfo sri = new Sepoacommon.SignRequestInfo();
                SepoaFormater wf = ws.getSepoaFormater();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType("INV");
                sri.setDocNo(ws.getParam("inv_no"));
                sri.setDocSeq("0");
                sri.setDocName(ws.getParam("subject"));
                sri.setItemCount(wf.getRowCount());
                sri.setSignStatus(ws.getParam("sign_status"));
                sri.setCur("KRW");
                sri.setTotalAmt(Double.parseDouble(ws.getParam("tot_amt")));

                sri.setSignString(ws.getParam("approval_str")); // AddParameter 에서 넘어온 정보
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
                    setMessage(msg.getMessage("0030"));
                    return getSepoaOut();
                }
            }
            else{
            	Rollback();
            	setStatus(0);
            	setMessage("결재상태 확인(시스템 담당자 확인)");
            	return getSepoaOut();
            }

            setStatus(1);
            setValue(ws.getParam("inv_no"));
            msg.setArg("inv_no",ws.getParam("inv_no"));

            //2010.12.08 swlee modify

            setMessage("검수요청번호" + " "+ws.getParam("inv_no")+"번으로 요청 되었습니다.");

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
            setMessage(msg.getMessage("0003"));
        }

        return getSepoaOut();
    }//End of setPrCreate()
*/
	private	int et_setIVHD(SepoaStream ws) throws Exception
	{
		int rtn =  0;
		ConnectionContext ctx =	getConnectionContext();
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

		try{
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("id", info.getSession("ID"));
			wxp.addVar("change_date", SepoaDate.getShortDateString());
			wxp.addVar("change_time", SepoaDate.getShortTimeString());
			wxp.addVar("app_status", "P");
			wxp.addVar("inv_no", ws.getParam("inv_no"));

			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doUpdate();
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	// 검수요청 철회
    public SepoaOut setDeleteInv(String inv_no, String status ) {
    	int rtn = 0;
    	try {
    		rtn += et_setDeleteInvHD(inv_no, status);
    		rtn += et_setDeleteInvDT(inv_no, status);    		
    		rtn += et_setDeleteVEV(inv_no,status);
    		if(rtn >= 3){
    			  
    			Commit();
    			setStatus(1);
    			setMessage("검수요청이 철회 되었습니다.");
    		}else{   			
    			Rollback();
    		}

    	}catch(Exception e) {

            Logger.err.println("setInvdoCancel e =" + e.getMessage());
            setStatus(0);
            Logger.err.println(this,e.getMessage());
        }
		 return getSepoaOut();
    }
    
    private int et_setDeleteInvHD(String inv_no, String status ) throws Exception {
    	int rtn = 0;
    	try {
    		String house_code = info.getSession("HOUSE_CODE");
    		String user_id     =  info.getSession("ID");
    		ConnectionContext ctx = getConnectionContext();

    		SepoaXmlParser wxp = new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());

			wxp.addVar("house_code", house_code);
			wxp.addVar("inv_no", inv_no);
			wxp.addVar("user_id", user_id);
			wxp.addVar("status", status);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn = sm.doUpdate();
			
    	}catch(Exception e) {
    		throw new Exception("et_setDelteInvHD:"+e.getMessage());
    	}
    	return rtn;
    } 
    
    private int et_setDeleteInvDT(String inv_no, String status ) throws Exception {
    	int rtn = 0;
    	try {
    		String house_code = info.getSession("HOUSE_CODE");
    		String user_id     =  info.getSession("ID");
    		ConnectionContext ctx = getConnectionContext();

    		SepoaXmlParser wxp = new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());

			wxp.addVar("house_code", house_code);
			wxp.addVar("inv_no", inv_no);
			wxp.addVar("user_id", user_id);
			wxp.addVar("status", status);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn = sm.doUpdate();
    	}catch(Exception e) {
    		throw new Exception("et_setDelteInvDT:"+e.getMessage());
    	}
    	return rtn;
    }    
    
    private int et_setDeleteVEV(String inv_no, String status ) throws Exception {
    	int rtn = 0;
    	try {
    		String house_code = info.getSession("HOUSE_CODE");
    		String user_id     =  info.getSession("ID");
    		ConnectionContext ctx = getConnectionContext();

    		//ICOMVEVH(수행하는 평가의 마스터 정보)  해당 건 삭제로 변경
    		SepoaXmlParser wxp = new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+ "_1");
			wxp.addVar("house_code", house_code);
			wxp.addVar("inv_no", inv_no);
			wxp.addVar("user_id", user_id);
			wxp.addVar("status", status);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn += sm.doUpdate();
			
			//ICOMVEVD(수행하는 평가의 마스터 정보) 해당 건 삭제로 변경
			wxp = new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+ "_2");
			wxp.addVar("house_code", house_code);
			wxp.addVar("inv_no", inv_no);
			wxp.addVar("user_id", user_id);
			wxp.addVar("status", status);
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn += sm.doUpdate();
			
			//ICOMVEVL(평가를 수행(정성평가)할 평가자 정보) 해당 건 삭제로 변경
			wxp = new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+ "_3");
			wxp.addVar("house_code", house_code);
			wxp.addVar("inv_no", inv_no);
			wxp.addVar("user_id", user_id);
			wxp.addVar("status", status);
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn += sm.doUpdate();
			
			if(rtn >= 3){
				rtn = 1;
			}else{
				rtn = 0;
			}
			
    	}catch(Exception e) {
    		throw new Exception("et_setDeleteVEV:"+e.getMessage());
    	}
    	return rtn;
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
} // END
