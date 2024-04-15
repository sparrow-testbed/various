/**
 *
 * Copyright 2001-2001 ICOMPIA Co., Ltd. All Rights Reserved.
 * This software is the proprietary information of ICOMPIA Co., Ltd.
 * @version        1.0
 *                                발주 상세조회/수정 (내외자발주)
 *                                                                 Andy Shin ...
 */

package order.ivdp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sms.SMS;
import wisecommon.appcommon;
//import erp.ERPInterface;
import xlib.cmc.GridData;

public class p2050 extends SepoaService
{
	private Message msg = new Message(info, "STDPO");
	private String lang = info.getSession("LANGUAGE");
	private Message msg_pr = new Message(info, "STDPR");

	public p2050(String opt, SepoaInfo info) throws SepoaServiceException {

		super(opt, info);
		setVersion("1.0.0");
	}

	/**
	 * @param house_code
	 * @param vendor_code
	 * @param smartbill_email
	 * @return
	 */
	public SepoaOut setSmartBillEmail(String house_code, String vendor_code, String smartbill_email) 
	{
		try {

			int row_cnt = svc_setSmartBillEmail(house_code, vendor_code, smartbill_email);
			setValue("update Row=" + row_cnt);

			Commit();
			setStatus(1);
			setMessage("수정되었습니다.");
		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("에러가 발생하였습니다. " + e.getMessage());
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	/**
	 * @param house_code
	 * @param vendor_code
	 * @param smartbill_email
	 * @return
	 * @throws Exception
	 */
	private int svc_setSmartBillEmail(String house_code, String vendor_code, String smartbill_email) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		String user_id = info.getSession("ID");
		String dept = info.getSession("DEPARTMENT");
		
		try {
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			String[][] array = {{smartbill_email, house_code, vendor_code}};
			String[] type = {"S", "S", "S"};
			rtn = sm.doUpdate(array, type);
		} catch (Exception e) {
			throw new Exception("in_setIvdp:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/**
	 * Mainternace
	 * @Method Name : getConfig
	 * @작성일       : 2008. 11. 10
	 * @작성자       : wooman.choi
	 * @변경이력     :
	 * @Method 설명  :
	 * @param s
	 * @return
	 */
	public String getConfig(String s) {
		try {
			Configuration configuration = new Configuration();
			s = configuration.get(s);
			return s;
		} catch (ConfigurationException configurationexception) {
			Logger.sys.println("getConfig error : " + configurationexception.getMessage());
		} catch (Exception exception) {
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}
		return null;
	}

	/**
	 * @param vendor_code
	 * @return
	 */
	public SepoaOut getSmartBillEmail(String vendor_code) {
		try {
			String rtnHD = bl_getSmartBillEmail(vendor_code);
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

	private String bl_getSmartBillEmail(String vendor_code) throws Exception 
	{
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this,ctx, wxp.getQuery());
			String[] args = { info.getSession("HOUSE_CODE"),vendor_code };
			rtn = sm.doSelect(args);
		} catch (Exception e) {
			throw new Exception("bl_getSmartBillEmail:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	/**
	 *
	 * @Method Name : getIvdpList
	 * @작성일       : 2008. 11. 10
	 * @작성자       : wooman.choi
	 * @변경이력     :
	 * @Method 설명  :
	 * @param from_date
	 * @param to_date
	 * @param po_no
	 * @param ctrl_code
	 * @param dept
	 * @param ivdp_flag
	 * @return
	 */
	public SepoaOut getIvdpList(String from_date, String to_date, String po_no,
			String ctrl_code, String dept, String ivdp_flag) {
		try {

			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getIvdpList(house_code, from_date, to_date,
					po_no, ctrl_code, dept, ivdp_flag);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

			setStatus(1);
			setValue(rtnHD);

		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

	/**
	 *
	 * @Method Name : bl_getIvdpList
	 * @작성일       : 2008. 11. 10
	 * @작성자       : wooman.choi
	 * @변경이력     :
	 * @Method 설명  :
	 * @param house_code
	 * @param from_date
	 * @param to_date
	 * @param po_no
	 * @param ctrl_code
	 * @param dept
	 * @param ivdp_flag
	 * @return
	 * @throws Exception
	 */
	private String bl_getIvdpList(String house_code, String from_date,
			String to_date, String po_no, String ctrl_code, String dept,
			String ivdp_flag) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("ctrl_code", ctrl_code);
	        
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this,ctx, wxp.getQuery());
			String[] args = { house_code, from_date, to_date, po_no, dept, ivdp_flag };
			rtn = sm.doSelect(args);
		}
		catch (Exception e) {
			throw new Exception("bl_getIvdpList:" + e.getMessage());
		}
		finally {
		}
		return rtn;
	}

	public SepoaOut getCndpList(String po_no) {
		try {

			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getCndpList(house_code, po_no);
			String rtnPAY = bl_getPayTerms();
			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

			setStatus(1);
			setValue(rtnHD);
			setValue(rtnPAY);

		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

	private String bl_getCndpList(String house_code, String po_no) throws Exception
	{
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args = { house_code, po_no };
			rtn = sm.doSelect(args);
		}
		catch (Exception e) {
			throw new Exception("bl_getIvdpList:" + e.getMessage());
		}
		finally {
		}
		return rtn;
	}

	private String bl_getPayTerms() throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

	        SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doSelect((String[])null);
		} catch (Exception e) {
			throw new Exception("bl_getIvdpList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	public SepoaOut setIvdp(String po_no,
			   String[][] setData,
			   String iv_no_exist,
			   String[][] setcndpData,
			   String exec_not_exist,
			   String doc_no,
			   String person_id) {
		try {
			//if (iv_no_exist.equals("false"))
			//	del_setIvdp(po_no);
			int insrow = in_setIvdp(setData);
			setValue("Insert Row=" + insrow);
			if (exec_not_exist.equals("true"))
				in_setCndp(setcndpData);

			//건수담당자 수정
			setPersonId( doc_no,  person_id);

			Commit();
			setStatus(1);
			setMessage("매입계산서번호 " + setData[0][1] + "가 생성 되었습니다.");
		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("에러가 발생하였습니다.");
		}
		return getSepoaOut();
	}

	private int in_setIvdp(String[][] setData) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		String user_id = info.getSession("ID");

		try {
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			// 넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
			String[] type = { "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S" };
			rtn = sm.doInsert(setData, type);
		} catch (Exception e) {
			throw new Exception("in_setIvdp:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	private int in_setCndp(String[][] setData) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		String user_id = info.getSession("ID");
		String user_dept = info.getSession("DEPARTMENT");
		String house_code = info.getSession("HOUSE_CODE");
		try {
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("house_code", house_code);
	        wxp.addVar("user_id", user_id);
	        wxp.addVar("user_dept", user_dept);

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			// 넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
			String[] type = { "S", "S", "S", "S", "S", "S", "S"  };
			rtn = sm.doInsert(setData, type);
		} catch (Exception e) {
			throw new Exception("in_setCndp:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 검수자 변경하기
	 * PO, INV 둘중 하나는 update 된다.
	 * INV가 만들어 진건에 대해서는 INV쪽에 Update 아니면 PO쪽에 Update 된다.
	 * @param doc_no
	 * @param person_id
	 * @return
	 * @throws Exception
	 */
	private int setPersonId(String doc_no, String person_id) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		String user_id = info.getSession("ID");
		String user_dept = info.getSession("DEPARTMENT");
		String house_code = info.getSession("HOUSE_CODE");

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
        wxp.addVar("person_id", person_id);
        wxp.addVar("house_code", house_code);
        wxp.addVar("doc_no", doc_no);

//		tSQL.append("		update icoypodt set pr_user_id = '"+person_id+"'        \n");
//		tSQL.append("		where house_code = '"+house_code+"'    		    		\n");
//		tSQL.append("		and po_no = '"+doc_no+"' 							    \n");
		SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
		rtn = sm.doInsert((String[][])null, null);

		wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
        wxp.addVar("person_id", person_id);
        wxp.addVar("house_code", house_code);
        wxp.addVar("doc_no", doc_no);
//		tSQL.append("		update icoyivhd set inv_person_id = '"+person_id+"'        \n");
//		tSQL.append("		where house_code = '"+house_code+"'    		    		\n");
//		tSQL.append("		and inv_no = '"+doc_no+"' 							    \n");
		sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
		rtn = sm.doInsert((String[][])null, null);

		return rtn;
	}

	public SepoaOut getIvdpDesc(String po_no) {
		try {

			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getIvdpDesc(house_code, po_no);
			String rtnPAY = bl_getPayTerms();
			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
			setValue(rtnPAY);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

	private String bl_getIvdpDesc(String house_code, String po_no) throws Exception
	{

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//			tSQL.append("			SELECT IV_NO 	               		  									\n");
//			tSQL.append("					,IV_SEQ	            		  									\n");
//			tSQL.append("					,DP_TEXT            		  									\n");
//			tSQL.append("					,DP_PAY_TERMS AS DP_PAY_TERMS_CODE      		  				\n");
//			tSQL.append("					,dbo.GETICOMCODE1(HOUSE_CODE,'M010',DP_PAY_TERMS) AS DP_PAY_TERMS	\n");
//			tSQL.append("					,DP_PAY_TERMS_TEXT  		  									\n");
//			tSQL.append("					,DP_PERCENT         		  									\n");
//			tSQL.append("					,DP_AMT             		  									\n");
//			tSQL.append("					,DP_PLAN_DATE       		  									\n");
//			tSQL.append("					,DP_TYPE            		  									\n");
//			tSQL.append("					,DP_FLAG            		  									\n");
//			tSQL.append("					,FIRST_DEPOSIT													\n");
//			tSQL.append("					,FIRST_PERCENT													\n");
//			tSQL.append("					,CONTRACT_DEPOSIT												\n");
//			tSQL.append("					,CONTRACT_PERCENT												\n");
//			tSQL.append("					,MENGEL_DEPOSIT													\n");
//			tSQL.append("					,MENGEL_PERCENT													\n");
//			tSQL.append("			FROM ICOYIVDP               		  									\n");
//			tSQL.append("<OPT=S,S>	WHERE HOUSE_CODE = ?        	</OPT>									\n");
//			tSQL.append("<OPT=S,S>	AND   PO_NO 	 = ?			</OPT>									\n");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args = { house_code, po_no };
			rtn = sm.doSelect(args);

		} catch (Exception e) {
			throw new Exception("bl_getIvdpDesc:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	public SepoaOut delIvdp(String po_no) {
		try {

			int insrow = in_delIvdp(po_no);
			setValue("delete Row=" + insrow);

			Commit();
			setStatus(1);
			setMessage("삭제되었습니다.");
		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("에러가 발생하였습니다.");
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	private int in_delIvdp(String po_no) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		String user_id = info.getSession("ID");
		String dept = info.getSession("DEPARTMENT");
		String house_code = info.getSession("HOUSE_CODE");
		try {
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("user_id", user_id);
	        wxp.addVar("dept"	, dept);
	        wxp.addVar("house_code", house_code);
	        wxp.addVar("po_no"	, po_no);
//			tSQL.append("	UPDATE ICOYIVDP	SET										\n");
//			tSQL.append("		 CHANGE_DATE 		= CONVERT(VARCHAR, GETDATE(), 112)	\n");
//			tSQL.append("		,CHANGE_TIME 		= SUBSTRING(REPLACE(CONVERT(VARCHAR, GETDATE(), 108), ':', ''), 1, 6)	\n");
//			tSQL.append("		,CHANGE_USER_ID 	= '" + user_id + "'					\n");
//			tSQL.append("		,CHANGE_USER_DEPT 	= '" + dept + "'					\n");
//			tSQL.append("		,STATUS 		    = 'D'							\n");
//			tSQL.append("	WHERE HOUSE_CODE = '" + house_code + "' 					\n");
//			tSQL.append("	AND   PO_NO		 = '" + po_no + "'							\n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

//			String[] type = { "S", "S" };
//			rtn = sm.doUpdate(null, type);

			rtn = sm.doUpdate((String[][])null, null);

		} catch (Exception e) {
			throw new Exception("in_setIvdp:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	public SepoaOut getDoIvdpList(String from_date, String to_date,
			String po_no, String iv_no, String pay_flag, String vendor_code,
			String ctrl_code, String dept) {
		try {

			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getDoIvdpList(house_code, from_date, to_date,
					po_no, iv_no, pay_flag, vendor_code, ctrl_code, dept);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

			setStatus(1);
			setValue(rtnHD);

		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

	private String bl_getDoIvdpList(String house_code, String from_date,
			String to_date, String po_no, String iv_no, String pay_flag,
			String vendor_code, String ctrl_code, String dept) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("ctrl_code", ctrl_code);

//			tSQL.append("			SELECT 	PH.PO_NO                                                             				\n");
//			tSQL.append("					, PH.SUBJECT                                                     				\n");
//			tSQL.append("					, PH.VENDOR_CODE                                                     				\n");
//			tSQL.append("					, dbo.GETVENDORNAME(PH.HOUSE_CODE, PH.VENDOR_CODE) AS VENDOR_NAME        				\n");
//			tSQL.append("					, PH.PO_CREATE_DATE                                                  				\n");
//			tSQL.append("					, PH.PO_TTL_AMT                                                      				\n");
//			tSQL.append("					, IV.IV_NO      	                                                  				\n");
//			tSQL.append("					, IV.DP_TEXT                                                         				\n");
//			tSQL.append("					, dbo.GETICOMCODE1(IV.HOUSE_CODE,'M010' ,IV.DP_PAY_TERMS) AS DP_PAY_TERMS    			\n");
//			tSQL.append("					, IV.IV_SEQ                                                          				\n");
//			tSQL.append("					, IV.DP_PERCENT                                                      				\n");
//			tSQL.append("					, IV.DP_AMT                                                          				\n");
//			tSQL.append("					, IV.DP_PLAN_DATE                                                    				\n");
//			tSQL.append("					, IV.DP_DATE	                                                    				\n");
//			tSQL.append("					, (CASE                                                              				\n");
//			tSQL.append("							WHEN IV.DP_FLAG = 'Y'  														\n");
//			tSQL.append("							THEN '지급'                                                  				\n");
//			tSQL.append("							ELSE '미지급'                                                				\n");
//			tSQL.append("					  END) AS PAY_FLAG                                                    				\n");
//			tSQL.append("					,CUR                                                                                \n");
//			tSQL.append("					,(SELECT MAX(EXCHANGE_RATE)                                                         \n");
//			tSQL.append("					  FROM ICOYPODT                                                                     \n");
//			tSQL.append("					  WHERE HOUSE_CODE = PH.HOUSE_CODE                                                  \n");
//			tSQL.append("					    AND PO_NO      = PH.PO_NO) AS EXCHANGE_RATE										\n");
//			tSQL.append("			FROM ICOYPOHD PH, ICOYIVDP IV                                                				\n");
//			tSQL.append("			WHERE PH.HOUSE_CODE = IV.HOUSE_CODE                                          				\n");
//			tSQL.append("			AND   PH.PO_NO 		= IV.PO_NO                                          					\n");
//			tSQL.append("			AND   PH.STATUS 	!= 'D'      	                                    					\n");
//			tSQL.append("			AND   IV.STATUS 	!= 'D'		                                          					\n");
//			tSQL.append("<OPT=S,S>	AND   PH.HOUSE_CODE = ?               				                           		  </OPT>\n");
//			tSQL.append("<OPT=S,S>  AND   IV.DP_PLAN_DATE BETWEEN ? </OPT><OPT=S,S>AND ?                                  </OPT>\n");
//			tSQL.append("<OPT=S,S>  AND   PH.PO_NO 				= ?                                                       </OPT>\n");
//			tSQL.append("<OPT=S,S>  AND   IV.IV_NO 				= ?                                                       </OPT>\n");
//			tSQL.append("<OPT=S,S>  AND   IV.DP_FLAG 			= ?                                                       </OPT>\n");
//			tSQL.append("<OPT=S,S>  AND   PH.VENDOR_CODE		= ?                                                       </OPT>\n");
//			tSQL.append("<OPT=S,S>  AND   dbo.getDeptCodeByID(PH.HOUSE_CODE,PH.COMPANY_CODE,PH.ADD_USER_ID) = ?            	  </OPT>\n");
//			tSQL.append("		    AND   PH.CTRL_CODE		  IN ('" + ctrl_code + "')                                              \n");
//			tSQL.append("			ORDER BY 1 DESC																				\n");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args = { house_code, from_date, to_date, po_no, iv_no,
					pay_flag, vendor_code, dept };
			rtn = sm.doSelect(args);

		} catch (Exception e) {
			throw new Exception("bl_getIvdpList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	public SepoaOut getIvdpDesc_ivno(String iv_no, String iv_seq) {
		try {

			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getIvdpDesc_ivno(house_code, iv_no, iv_seq);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

			setStatus(1);
			setValue(rtnHD);

		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

	private String bl_getIvdpDesc_ivno(String house_code, String iv_no,
			String iv_seq) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//			tSQL.append("			SELECT IV_SEQ               		  									\n");
//			tSQL.append("					,DP_TEXT            		  									\n");
//			tSQL.append("					,DP_PAY_TERMS AS DP_PAY_TERMS_CODE      		  				\n");
//			tSQL.append("					,dbo.GETICOMCODE1(HOUSE_CODE,'M010',DP_PAY_TERMS) AS DP_PAY_TERMS	\n");
//			tSQL.append("					,DP_PAY_TERMS_TEXT  		  									\n");
//			tSQL.append("					,DP_PERCENT         		  									\n");
//			tSQL.append("					,DP_AMT             		  									\n");
//			tSQL.append("					,DP_PLAN_DATE       		  									\n");
//			tSQL.append("					,DP_TYPE            		  									\n");
//			tSQL.append("			FROM ICOYIVDP               		  									\n");
//			tSQL.append("<OPT=S,S>	WHERE HOUSE_CODE = ?        	</OPT>									\n");
//			tSQL.append("<OPT=S,S>	AND   IV_NO 	 = ?			</OPT>									\n");
//			tSQL.append("<OPT=S,S>	AND   IV_SEQ 	 = ?			</OPT>									\n");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args = { house_code, iv_no, iv_seq };
			rtn = sm.doSelect(args);

		} catch (Exception e) {
			throw new Exception("bl_getIvdpDesc:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 매입처리 > 검수요청현황 조회
	 * @Method Name : getInvList
	 * @Method 설명  :
	 * @param from_date
	 * @param to_date
	 * @param inv_from_date
	 * @param inv_to_date
	 * @param ctrl_person_id
	 * @param sign_status
	 * @param pay_flag
	 * @param vendor_code
	 * @param inv_person_id
	 * @param po_no
	 * @param order_no
	 * @param dept
	 * @param mode
	 * @return
	 */
	public SepoaOut getInvList(String from_date, String to_date,
			String inv_from_date, String inv_to_date, String ctrl_person_id,
			String sign_status, String pay_flag, String vendor_code,
			String inv_person_id, String po_no, String order_no, String dept,
			String mode,
			String pay_create_flag,
			String app_status) {
		try {

			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getInvList(house_code, from_date, to_date,
					inv_from_date, inv_to_date, ctrl_person_id, sign_status,
					//pay_flag,
					vendor_code, inv_person_id, po_no, order_no,
					dept, mode, pay_create_flag, app_status);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

			setStatus(1);
			setValue(rtnHD);

		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

	private String bl_getInvList(String house_code, String from_date,
			String to_date, String inv_from_date, String inv_to_date,
			String ctrl_person_id, String sign_status,
			//String pay_flag,
			String vendor_code, String inv_person_id, String po_no,
			String order_no, String dept, String mode,
			String pay_create_flag,
			String app_status) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("house_code", house_code);
	        wxp.addVar("mode", mode);
	        wxp.addVar("pay_create_flag", pay_create_flag);
	        wxp.addVar("app_status", app_status);
			//2008-12-12
			//물류비 ,통신비껀에 대해 거래명세서를 안 만들고 바로 전표처리를 할수 있다.
			//물류비 ,통신비껀에 대해 Y 마크를 한다.
			//검수요청현황은 iv header별 화면이다.
			//즉 header별로 GR을 잡는다. DT는 같은 같은 GR로 따진다.
//			tSQL.append("			SELECT   MAX(VD.PO_NO) AS PO_NO                                                             \n");
//			tSQL.append("					,HD.SUBJECT    AS PO_SUBJECT                                                         \n");
//			tSQL.append("					,VH.PO_CREATE_DATE                                                                  \n");
//			tSQL.append("					,VH.VENDOR_CODE                                                                     \n");
//			tSQL.append("					,dbo.GETVENDORNAME(VH.HOUSE_CODE, VH.VENDOR_CODE) AS VENDOR_NAME                        \n");
//			tSQL.append("					,VH.PO_TTL_AMT                                                                      \n");
//			tSQL.append("					,dbo.GETUSERNAMELOC(VH.HOUSE_CODE,VH.INV_PERSON_ID) AS INV_PERSON_NAME                  \n");
//			tSQL.append("					,VH.INV_PERSON_ID                                                                   \n");
//			tSQL.append("					,dbo.GETUSERNAMELOC(VH.HOUSE_CODE,VH.PURCHASE_ID) AS ADD_USER_NAME                      \n");
//			tSQL.append("					,VH.PURCHASE_ID AS ADD_USER_ID                                                      \n");
//			tSQL.append("					,MAX(VD.IV_NO) AS IV_NO                                                             \n");
//			tSQL.append("					,VH.DP_TEXT                                                                         \n");
//			tSQL.append("					,dbo.GETICOMCODE1(VH.HOUSE_CODE,'M010',VH.DP_PAY_TERMS) AS DP_PAY_TERMS                 \n");
//			tSQL.append("					,VH.IV_SEQ                                                                          \n");
//			tSQL.append("					,VH.DP_PERCENT                                                                      \n");
//			tSQL.append("					,VH.DP_AMT                                                                          \n");
//			tSQL.append("					,VH.INV_DATE                                                                        \n");
//			tSQL.append("					,'' AS CONFIRM_DATE                                        \n");
//			tSQL.append("					,dbo.GETICOMCODE1(VH.HOUSE_CODE,'M994',VH.SIGN_STATUS) AS SIGN_STATUS_DESC              \n");
//			tSQL.append("					,VH.SIGN_STATUS                   													\n");
//			tSQL.append("					,VH.SIGN_REMARK                                                                     \n");
//			tSQL.append("					,IV.DP_FLAG                                                                         \n");
//			tSQL.append("					,VH.INV_NO                                                                         	\n");
//			tSQL.append("					,VH.SUBJECT  AS INV_SUBJECT                                                         \n");
//			tSQL.append("					,HD.ORDER_NO			                                                            \n");
//			tSQL.append("					,VH.ATTACH_NO			                                                            \n");
//			tSQL.append("					, case VH.ATTACH_NO when '' then 0 else 1 end AS ATTACH_POP                                          \n");
//			tSQL.append("					,MAX(VD.INV_QTY) AS INV_QTY                                                         \n");
//			tSQL.append("					,(SELECT  case COUNT(*) when 0 then 'Y' else 'N' end                                                 \n");
//			tSQL.append("					  FROM ICOBTXHD                                                                     \n");
//			tSQL.append("					  WHERE HOUSE_CODE = VH.HOUSE_CODE                                                  \n");
//			tSQL.append("					    AND PAY_NO     = VH.INV_NO                                                      \n");
//			tSQL.append("					    AND JOB_STATUS != 'NAF'                                                         \n");
//			tSQL.append("					    AND STATUS     != 'D') AS DEL_FLAG 												\n");
//			tSQL.append("					,VH.PAY_NO, vd.gr_date                                                              \n");
//			tSQL.append("					,VH.IV_NO H_IV_NO			                                                            \n");
//			tSQL.append("					,VH.IV_CANCEL_NO			                                                            \n");
//			tSQL.append("					,VH.IV_CLEAR_NO			                                                            \n");
//			tSQL.append("			, CASE MAX(MTGL.MATERIAL_CLASS1)			\n");
//			tSQL.append("			 WHEN '6004004' THEN 'Y'              \n");
//			tSQL.append("			 WHEN '5001001' THEN 'Y'              \n");
//			tSQL.append("			 WHEN '5001002' THEN 'Y'              \n");
//			tSQL.append("			 WHEN '5001003' THEN 'Y'              \n");
//			tSQL.append("			 WHEN '5001004' THEN 'Y'              \n");
//			tSQL.append("			 WHEN '5001005' THEN 'Y'              \n");
//			tSQL.append("			 WHEN '5001006' THEN 'Y'              \n");
//			tSQL.append("			 WHEN '5001007' THEN 'Y'              \n");
//			tSQL.append("			 WHEN '5001008' THEN 'Y'              \n");
//			tSQL.append("			 WHEN '5001009' THEN 'Y'              \n");
//			tSQL.append("			 WHEN '5001099' THEN 'Y'              \n");
//			tSQL.append("			 ELSE 'N' END GUBUN,                   \n");
//			tSQL.append("	DBO.GETICOMCODE1('"+house_code+"', 'M042' , MAX(MTGL.MATERIAL_CLASS1) ) MATERIAL_CLASS1_TEXT        \n");
//			tSQL.append("			,MAX(VD.GR_NO) GR_NO			                                                            \n");
//			tSQL.append("			,DBO.GETICOMCODE1(VH.HOUSE_CODE,'P013',ISNULL(VH.APP_STATUS,'T')) APP_STATUS_NAME             \n");
//			tSQL.append("			,ISNULL(VH.APP_STATUS,'T') APP_STATUS            											\n");
//			tSQL.append("			FROM ICOYIVHD VH, ICOYIVDT VD, ICOYIVDP IV ,ICOYPOHD HD, ICOMMTGL MTGl                      \n");
//			tSQL.append("			WHERE VH.HOUSE_CODE 	= VD.HOUSE_CODE                                                     \n");
//			tSQL.append("			AND   VH.INV_NO			= VD.INV_NO                                                         \n");
//			tSQL.append("			AND   VD.HOUSE_CODE 	= IV.HOUSE_CODE                                                     \n");
//			tSQL.append("			AND   VD.IV_NO			= IV.IV_NO                                                          \n");
//			tSQL.append("			AND   VD.HOUSE_CODE		= HD.HOUSE_CODE														\n");
//			tSQL.append("			AND   VD.PO_NO			= HD.PO_NO															\n");
//			tSQL.append("			AND   VD.HOUSE_CODE = MTGl.HOUSE_CODE													    \n");
//			tSQL.append("			AND   VD.ITEM_NO = MTGl.ITEM_NO															    \n");
//			tSQL.append("			AND   VH.STATUS			!= 'D'																\n");
//			tSQL.append("			AND   VD.STATUS			!= 'D'																\n");
//			tSQL.append("			AND   IV.STATUS			!= 'D'																\n");
//			tSQL.append("			AND   HD.STATUS			!= 'D'																\n");
//			tSQL.append("<OPT=S,S>	AND   VH.HOUSE_CODE 	= ? 			                                              </OPT>\n");
//			tSQL.append("<OPT=S,S>  AND   VH.PURCHASE_ID 	= ?                                                           </OPT>\n");
//			tSQL.append("<OPT=S,S>  AND   VH.SIGN_STATUS  	= ?                                                           </OPT>\n");
//			tSQL.append("<OPT=S,S>  AND   IV.DP_FLAG	  	= ?                                                           </OPT>\n");
//			tSQL.append("<OPT=S,S>  AND   VH.VENDOR_CODE  	= ?                                                           </OPT>\n");
//			tSQL.append("<OPT=S,S>	AND   VH.INV_PERSON_ID	= ?                                                           </OPT>\n");
//			tSQL.append("<OPT=S,S>  AND   VD.PO_NO			= ?                                                           </OPT>\n");
//			tSQL.append("<OPT=S,S>  AND   VH.PO_CREATE_DATE BETWEEN ? </OPT><OPT=S,S>AND ?                                </OPT>\n");
//			tSQL.append("<OPT=S,S>  AND   VH.INV_DATE 		BETWEEN ? </OPT><OPT=S,S>AND ?								  </OPT>\n");
//			tSQL.append("<OPT=S,S>  AND   HD.ORDER_NO		= ?															  </OPT>\n");
//			if (mode.equals("inv_person"))
//				tSQL.append("<OPT=S,S>  AND   dbo.getDeptCodeByID(VH.HOUSE_CODE,VH.COMPANY_CODE,VH.INV_PERSON_ID)	= ?		  </OPT>\n");
//			else
//				tSQL.append("<OPT=S,S>  AND   dbo.getDeptCodeByID(VH.HOUSE_CODE,VH.COMPANY_CODE,VH.PURCHASE_ID)	= ?			  </OPT>\n");
//
//			if (pay_create_flag.equals("Y"))
//				tSQL.append("			AND   VH.PAY_NO			IS NOT NULL											\n");
//			else if (pay_create_flag.equals("N"))
//				tSQL.append("			AND   VH.PAY_NO			IS NULL											\n");
//
//			tSQL.append("			GROUP BY VH.PO_CREATE_DATE                                                                  \n");
//			tSQL.append("					,VH.VENDOR_CODE                                                                     \n");
//			tSQL.append("					,VH.HOUSE_CODE                                                                      \n");
//			tSQL.append("					,VH.PO_TTL_AMT                                                                      \n");
//			tSQL.append("					,VH.INV_PERSON_ID                                                                   \n");
//			tSQL.append("					,VH.ADD_USER_ID                                                                     \n");
//			tSQL.append("					,VH.DP_TEXT                                                                         \n");
//			tSQL.append("					,VH.DP_PAY_TERMS                                                                    \n");
//			tSQL.append("					,VH.IV_SEQ                                                                          \n");
//			tSQL.append("					,VH.DP_PERCENT                                                                      \n");
//			tSQL.append("					,VH.DP_AMT                                                                          \n");
//			tSQL.append("					,VH.INV_DATE                                                                        \n");
//			tSQL.append("					,VH.SIGN_STATUS                                                                     \n");
//			tSQL.append("					,VH.SIGN_REMARK                                                                     \n");
//			tSQL.append("					,VH.INV_NO                                                                          \n");
//			tSQL.append("					,VH.SUBJECT 																		\n");
//			tSQL.append("					,VH.PURCHASE_ID																		\n");
//			tSQL.append("					,IV.DP_FLAG																			\n");
//			tSQL.append("					,HD.SUBJECT 																		\n");
//			tSQL.append("					,HD.ORDER_NO			                                                            \n");
//			tSQL.append("					,VH.ATTACH_NO			                                                            \n");
//			tSQL.append("					,VH.PAY_NO, vd.gr_date		                                                            \n");
//			tSQL.append("					,VH.IV_NO			                                                            \n");
//			tSQL.append("					,VH.IV_CANCEL_NO			                                                            \n");
//			tSQL.append("					,VH.IV_CLEAR_NO			                                                            \n");
//			tSQL.append("					,VH.APP_STATUS			                                                            \n");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args = { house_code, ctrl_person_id, sign_status,
					//pay_flag,
					vendor_code, inv_person_id, po_no, from_date,
					to_date, inv_from_date, inv_to_date, order_no, dept };
			rtn = sm.doSelect(args);
		} catch (Exception e) {
			throw new Exception("bl_getInvList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 매입처리 > 검수요청 처리현황 조회
	 * @Method Name : getInvList
	 * @Method 설명  :
	 * @param from_date
	 * @param to_date
	 * @param inv_from_date
	 * @param inv_to_date
	 * @param ctrl_person_id
	 * @param sign_status
	 * @param pay_flag
	 * @param vendor_code
	 * @param inv_person_id
	 * @param po_no
	 * @param order_no
	 * @param dept
	 * @param mode
	 * @return
	 */
	public SepoaOut getInvCompList(String from_date, String to_date,
			String inv_from_date, String inv_to_date, String ctrl_person_id,
			String sign_status, String pay_flag, String vendor_code,
			String inv_person_id, String po_no, String order_no, String dept,
			String mode,
			String pay_create_flag,
			String app_status) {
		try {

			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getInvCompList(house_code, from_date, to_date,
					inv_from_date, inv_to_date, ctrl_person_id, sign_status,
					vendor_code, inv_person_id, po_no, order_no,
					dept, mode, pay_create_flag, app_status);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

			setStatus(1);
			setValue(rtnHD);

		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

	private String bl_getInvCompList(String house_code, String from_date,
			String to_date, String inv_from_date, String inv_to_date,
			String ctrl_person_id, String sign_status,
			String vendor_code, String inv_person_id, String po_no,
			String order_no, String dept, String mode,
			String pay_create_flag,
			String app_status) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("house_code", house_code);
	        wxp.addVar("mode", mode);
	        wxp.addVar("pay_create_flag", pay_create_flag);
	        wxp.addVar("app_status", app_status);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args = { house_code, ctrl_person_id, sign_status,
					//pay_flag,
					vendor_code, inv_person_id, po_no, from_date,
					to_date, inv_from_date, inv_to_date, order_no, dept };
			rtn = sm.doSelect(args);
		} catch (Exception e) {
			throw new Exception("bl_getInvList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	public SepoaOut getInvDisplay(String inv_no) {
		try {

			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = et_getInvDisplay(house_code, inv_no);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

			setStatus(1);
			setValue(rtnHD);

		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

	private String et_getInvDisplay(String house_code, String inv_no) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			Map<String, String> data = new HashMap<String, String>();
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        data.put("house_code", house_code);
	        data.put("inv_no", inv_no);

//			tSQL.append("    SELECT top 1  \n");
//			tSQL.append("           vd.po_no AS po_no11, (SELECT  top 1 subject FROM icoypohd WHERE po_no = pd.po_no) AS po_name12,  \n");
//			tSQL.append("           pd.wbs_sub_no + ' / ' + pd.wbs_txt AS project_name21,  \n");
//			tSQL.append("           vd.iv_no AS iv_no31, vd.inv_no AS inv_no32,  \n");
//			tSQL.append("      convert(varchar, (select count(distinct c.inv_no)  \n");
//			tSQL.append("    from icoyivhd c, icoyivdt b  \n");
//			tSQL.append("    where b.house_code = vd.house_code  \n");
//			tSQL.append("    and b.po_no = vd.po_no  \n");
//			tSQL.append("    and b.status <> 'D'  \n");
//			tSQL.append("    and c.house_code = b.house_code  \n");
//			tSQL.append("    and c.inv_no = b.inv_no  \n");
//			tSQL.append("    and c.status <> 'D'))+'차'+' ('+  \n");
//			tSQL.append("    '검수자 : ' + dbo.getusernameloc (vh.house_code, vh.inv_person_id)+')'  AS inv_seq41,  \n");
//			tSQL.append("           substring (vh.inv_date, 1, 4)  + '/' + substring (vh.inv_date, 5, 2)  + '/' + substring (vh.inv_date, 7, 2)  AS app_status42, \n");
//			tSQL.append("           replace(convert(varchar(18), cast(round(vh.po_ttl_amt, 0) as money),1), '.00', '') AS po_ttl_amt51,  \n");
//			tSQL.append("           replace(convert(varchar(18), cast(round( \n");
//			tSQL.append("           (select max(c.po_ttl_amt)- \n");
//			tSQL.append("                   sum((case when c.sign_status = 'E2' then b.gr_qty \n");
//			tSQL.append("                             else b.inv_qty \n");
//			tSQL.append("                         end) * b.unit_price) as amt1 \n");
//			tSQL.append("              from icoyivhd c, icoyivdt b \n");
//			tSQL.append("             where b.house_code = vd.house_code \n");
//			tSQL.append("               and b.po_no = vd.po_no \n");
//			tSQL.append("               and b.status <> 'D' \n");
//			tSQL.append("               and c.house_code = b.house_code \n");
//			tSQL.append("               and c.inv_no = b.inv_no \n");
//			tSQL.append("               and c.status <> 'D') \n");
//			tSQL.append("           , 0) as money),1), '.00', '') as inv_amt52,        \n");
//			tSQL.append("           dbo.getvendorname (vh.house_code, vh.vendor_code) AS vendor_name61,  \n");
//			tSQL.append("           (SELECT   vendor_cp_name + ' (' + vendor_mobile_no + ' )'  \n");
//			tSQL.append("              FROM icoypohd  \n");
//			tSQL.append("             WHERE po_no = pd.po_no) AS vendor_cp_name62,  \n");
//			tSQL.append("           (SELECT  top 1 '선급금보증 ' + CONVERT (VARCHAR, CONVERT (DEC (22), first_percent)) + '%, 계약이행보증 ' + CONVERT (VARCHAR, CONVERT (DEC (22), contract_percent)) + '%, 하자이행보증 ' + CONVERT (VARCHAR, CONVERT (DEC (22), mengel_percent)) + '%'  \n");
//			tSQL.append("              FROM icoycndp  \n");
//			tSQL.append("             WHERE exec_no = pd.exec_no) AS bb71,  \n");
//			tSQL.append("           vh.attach_no AS attach_no81,  \n");
//			tSQL.append("           '검수일 : ' + substring (vh.inv_date, 1, 4)  + '/' + substring (vh.inv_date, 5, 2)  + '/' + substring (vh.inv_date, 7, 2) AS inv_date98,  \n");
//			tSQL.append("           '검수자 : ' + dbo.getusernameloc (vh.house_code, vh.inv_person_id) AS inv_person_name99  \n");
//			tSQL.append("      FROM icoyivhd vh, icoyivdt vd, icoypodt pd  \n");
//			tSQL.append("     WHERE vh.house_code = vd.house_code  \n");
//			tSQL.append("<OPT=S,S>	AND   VH.HOUSE_CODE	= ?			                                             	  </OPT>\n");
//			tSQL.append("<OPT=S,S>	AND   VH.INV_NO		= ?			                                             	  </OPT>\n");
//			tSQL.append("       AND vh.inv_no = vd.inv_no  \n");
//			tSQL.append("       AND vd.po_no = pd.po_no \n");
//			tSQL.append("       and vh.status <> 'D' \n");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(data);
		} catch (Exception e) {
			throw new Exception("bl_getIvdpList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 검수요청상세조회 Detail
	 * @Method Name : getItemList
	 * @변경이력     :
	 * @Method 설명  :
	 * @param inv_no
	 * @return
	 */
	public SepoaOut getGrConfirmList(String inv_no, String po_no, String gridFlag) {
		try {

			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = "";
			if(gridFlag.equals("TOP")) {
				rtnHD = et_getGrConfirmListTop(house_code, inv_no);
			} else {
				rtnHD = et_getGrConfirmListBottom(house_code, inv_no, po_no);
			}

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

			setStatus(1);
			setValue(rtnHD);

		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

	private String et_getGrConfirmListTop(String house_code, String inv_no)
	throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//			tSQL.append("       SELECT  row_number() over(order by vh.CONFIRM_DATE2 desc) as SEQ      \n");
//			tSQL.append("    			       ,VD.ITEM_NO   \n");
//			tSQL.append("    				   ,VD.DESCRIPTION_LOC    \n");
//			tSQL.append("    				   ,VD.UNIT_MEASURE     \n");
//			tSQL.append("                       ,convert(numeric(22,5), (CASE WHEN VH.SIGN_STATUS = 'E2' THEN VD.GR_QTY  \n");
//			tSQL.append("                              ELSE VD.INV_QTY END)) AS ITEM_QTY											  \n");
//			tSQL.append("    				   ,VD.UNIT_PRICE  \n");
//			tSQL.append("                       ,convert(numeric(22,5), (CASE WHEN VH.SIGN_STATUS = 'E2' THEN VD.GR_QTY  \n");
//			tSQL.append("                              ELSE VD.INV_QTY END) * VD.UNIT_PRICE) AS EXPECT_AMT   \n");
//			tSQL.append("    			FROM ICOYIVDT VD, icoyivhd vh   \n");
//			tSQL.append("<OPT=S,S>	WHERE VD.HOUSE_CODE = ? 				              		  					  </OPT>\n");
//			tSQL.append("<OPT=S,S>	AND   VD.INV_NO 	= ?     					      		  					  </OPT>\n");
//			tSQL.append("                 AND VD.STATUS 	!= 'D'  \n");
//			tSQL.append("    	         AND vd.INV_NO = vh.INV_NO	  \n");
//			tSQL.append("    	         AND vd.house_code = vh.house_code  \n");
//			tSQL.append("                 AND VH.STATUS <> 'D'  \n");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this,
					ctx, wxp.getQuery());
			String[] args = { house_code,inv_no };
			rtn = sm.doSelect(args);

		} catch (Exception e) {
			throw new Exception("bl_getItemList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	private String et_getGrConfirmListBottom(String house_code, String inv_no, String po_no)
	throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//			tSQL.append("   SELECT row_number() over(order by IVHD.CONFIRM_DATE2 desc) as seq ,	  \n");
//			tSQL.append("   	      IVHD.CONFIRM_DATE2 as date,	  \n");
//			tSQL.append("   	      convert(dec(22,5), sum(ISNULL((CASE WHEN IVHD.SIGN_STATUS = 'E2' THEN IVDT.GR_QTY  \n");
//			tSQL.append("                             ELSE IVDT.INV_QTY END) * IVDT.UNIT_PRICE,0))) AS AMT,	  \n");
//			tSQL.append("             IVHD.INV_DATE AS flag,  \n");
//			tSQL.append("   	      (SELECT BLDAT FROM ICOBTXHD 	  \n");
//			tSQL.append("   	       WHERE HOUSE_CODE = IVHD.HOUSE_CODE	  \n");
//			tSQL.append("   	          AND PAY_NO = IVHD.PAY_NO) AS date2	  \n");
//			tSQL.append("   	  FROM ICOYIVDT IVDT, ICOYIVHD IVHD	  \n");
//			tSQL.append("   	 WHERE IVDT.HOUSE_CODE = IVHD.HOUSE_CODE   \n");
//			tSQL.append("	<OPT=S,S>   AND IVDT.HOUSE_CODE = ?	</OPT>	\n");
//			tSQL.append("	<OPT=S,S>   and IVDT.inv_no     <> ?	</OPT> \n");
//			tSQL.append("	<OPT=S,S>   AND IVDT.PO_NO = (select top 1 po_no from icoyivdt where inv_no = ? )</OPT>	 \n");
//			tSQL.append("          AND IVDT.STATUS <> 'D' 	  \n");
//			tSQL.append("   	   AND IVDT.INV_NO = IVHD.INV_NO	  \n");
//			tSQL.append("          AND IVHD.STATUS <> 'D'  \n");
//			tSQL.append("   	   AND IVHD.SIGN_STATUS IN ('E1','E2')	  \n");
//			tSQL.append("   	 GROUP BY IVHD.HOUSE_CODE, IVHD.CONFIRM_DATE2, IVHD.PAY_NO, IVHD.inv_no,IVDT.PO_NO,IVHD.INV_DATE  \n");


			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this,
					ctx, wxp.getQuery());
			String[] args = { house_code, inv_no, inv_no};
			rtn = sm.doSelect(args);

		} catch (Exception e) {
			throw new Exception("et_getGrConfirmListBottom:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 검수요청상세조회 Detail
	 * @Method Name : getItemList
	 * @변경이력     :
	 * @Method 설명  :
	 * @param inv_no
	 * @return
	 */
	public SepoaOut getItemList(String inv_no) {
		try {

			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getItemList(house_code, inv_no);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

			setStatus(1);
			setValue(rtnHD);

		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

	private String bl_getItemList(String house_code, String po_no)
	throws Exception {

	String rtn = "";
	ConnectionContext ctx = getConnectionContext();
		try {

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//			tSQL.append("			SELECT  VD.ITEM_NO                    													\n");
//			tSQL.append("				   ,VD.DESCRIPTION_LOC            													\n");
//			tSQL.append("				   ,VD.SPECIFICATION            													\n");
//			tSQL.append("				   ,VD.MAKER_NAME            														\n");
//			tSQL.append("				   ,VD.MAKER_CODE            														\n");
//			tSQL.append("				   ,VD.RD_DATE                 														\n");
//			tSQL.append("				   ,dbo.GETTECHNIQUE_GRADE(VD.HOUSE_CODE, VD.PO_NO, VD.PO_SEQ) AS TECHNIQUE_GRADE       \n");
//			tSQL.append("				   ,VD.UNIT_MEASURE            														\n");
//			tSQL.append("				   ,VD.ITEM_QTY                														\n");
//			tSQL.append("				   ,VD.UNIT_PRICE              														\n");
//			tSQL.append("				   ,VD.ITEM_AMT                   													\n");
//			tSQL.append("				   ,VD.INV_SEQ                   													\n");
//			tSQL.append("           	   ,dbo.GETGRQTY(VD.HOUSE_CODE, VD.PO_NO, VD.PO_SEQ) AS GR_QTY    						\n");
//			tSQL.append("           	   ,VD.INV_QTY    																	\n");
//			tSQL.append("           	   ,convert(numeric(22,5), INV_QTY*UNIT_PRICE) AS INV_AMT    												\n");
//			tSQL.append("           	   ,convert(numeric(22,5),dbo.GETGRQTY(VD.HOUSE_CODE, VD.PO_NO, VD.PO_SEQ)*UNIT_PRICE, 4) \n");
//			tSQL.append("           	   ,VD.INPUT_FROM_DATE    															\n");
//			tSQL.append("           	   ,VD.INPUT_TO_DATE    															\n");
//			tSQL.append("				   ,(SELECT PR_TYPE                                                                 \n");
//			tSQL.append("				     FROM ICOYPRHD                                                                  \n");
//			tSQL.append("				     WHERE HOUSE_CODE = VD.HOUSE_CODE                                               \n");
//			tSQL.append("				       AND PR_NO	  = (SELECT PD.PR_NO                                            \n");
//			tSQL.append("				       				  	 FROM ICOYPODT PD                                           \n");
//			tSQL.append("				       				  	 WHERE PD.HOUSE_CODE = VD.HOUSE_CODE                        \n");
//			tSQL.append("				       				  	   AND PD.PO_NO	  = VD.PO_NO                                \n");
//			tSQL.append("				       				  	   AND PD.PO_SEQ     = VD.PO_SEQ)) AS PR_TYPE 				\n");
//			tSQL.append("			FROM ICOYIVDT VD       				                	   								\n");
//			tSQL.append("<OPT=S,S>	WHERE VD.HOUSE_CODE = ? 				              		  					  </OPT>\n");
//			tSQL.append("<OPT=S,S>	AND   VD.INV_NO 	= ?     					      		  					  </OPT>\n");
//			tSQL.append("	AND   VD.STATUS 	!= 'D'\n");
//			tSQL.append("	AND   VD.gr_cancel_no is null	\n");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this,
					ctx, wxp.getQuery());
			String[] args = { house_code, po_no };
			rtn = sm.doSelect(args);

		} catch (Exception e) {
			throw new Exception("bl_getItemList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/**
	 * 
	 * 검수취소 process
	 * @version 2012. 7. 30.
	 * @author Administrator
	 * @param paramMap
	 * @return
	 */
	public SepoaOut cancelInv(HashMap<String,String> paramMap){
		try{
			ConnectionContext ctx = getConnectionContext();
			
			int insrow = ex_cancelInv(ctx, paramMap);
			
		}catch(Exception e){
			try {
				Rollback();
			} catch(Exception d) {
	            Logger.err.println(userid,this,d.getMessage());
	        }
			setStatus(0);
			setMessage(e.getMessage());
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}
	
	private int ex_cancelInv(ConnectionContext ctx, HashMap<String,String> paramMap) throws Exception{
		int rtn = 0;
		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");
		try {
	        // 1.검수수량(ICOYIVDT) 변경.
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_ICOYIVDT");
	        wxp.addVar("house_code", paramMap.get("house_code"));
	        wxp.addVar("inv_no", paramMap.get("inv_no"));
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			rtn = sm.doUpdate((String[][])null, null);
			
	        // 2.검수상태수정 (ICOYIVHD)
	        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_ICOYIVHD");
	        wxp.addVar("house_code", paramMap.get("house_code"));
	        wxp.addVar("inv_no", paramMap.get("inv_no"));
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			rtn = sm.doUpdate((String[][])null, null);
			
			// 3. 발주수량수정(ICOYPODT)
	        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_ICOYPODT1");
	        wxp.addVar("house_code", paramMap.get("house_code"));
	        wxp.addVar("inv_no", paramMap.get("inv_no"));
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			rtn = sm.doUpdate((String[][])null, null);
			
			// 4. 발주 완료 처리 수정(ICOYPODT)
	        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_ICOYPODT2");
	        wxp.addVar("house_code", paramMap.get("house_code"));
	        wxp.addVar("inv_no", paramMap.get("inv_no"));
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			rtn = sm.doUpdate((String[][])null, null);			
			
			// 5. 발주 완료 처리 수정(ICOYPOHD)
	        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_ICOYPOHD");
	        wxp.addVar("house_code", paramMap.get("house_code"));
	        wxp.addVar("inv_no", paramMap.get("inv_no"));
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			rtn = sm.doUpdate((String[][])null, null);
			
			 String[] erpINV_result  = new String[2];
			// 검수 I / F (신규등록)
//			ERPInterface erpIF = new ERPInterface("CONNECTION",info);
//			erpINV_result = erpIF.erpINVInsert(getERPINVList(paramMap.get("inv_no")),"D");
			
//			if(!erpINV_result[0].equals("2")){
//				Commit();				
//				setStatus(1);
//				setMessage("정상적으로 처리되었습니다.");
//				setValue(paramMap.get("inv_no"));				
//			}else{
//				Rollback();
//				setStatus(0);
//				setMessage(erpINV_result[1]);				
//			}
			Commit();				
			setStatus(1);
			setMessage("정상적으로 처리되었습니다.");
			setValue(paramMap.get("inv_no"));

		}
		catch (Exception e) {
			throw new Exception("ex_cancelInv:" + e.getMessage());
		}
		finally {}
		
		return rtn;
	}
	
	/**
	 * 검수요청 승인/반려 process
	 * @Method Name : setApproval
	 * @Method 설명  :
	 * @param inv_no
	 * @param sign_status
	 * @param sign_remark
	 * @return
	 */
	public SepoaOut setApproval(Map<String, Object> allData) {
		try {
			ConnectionContext         ctx          = getConnectionContext();
			Map<String, String>	      header       = MapUtils.getMap(allData, SepoaDataMapper.KEY_HEADER_DATA);
			String                    sign_status  = "E";
			String                    inv_no       = header.get("inv_no");
			String                    pay_no       = null;
			
			String                    itemNo       = null;
			String                    invSeq       = null;
			String                    invQty       = null;
			String                    grQty        = null;
			int                       insrow       = in_setApproval(ctx, allData); // 검수완료
			SepoaOut                  wo           = DocumentUtil.getDocNumber(info, "DCL"); // 거래명세서 p2052.java 에서 필요부분 copy
			List<Map<String, String>> grid         = (List<Map<String, String>>)MapUtils.getObject(allData, "gridData");
			Map<String, String>       gridInfo     = null;
			int                       gridSize     = grid.size();
			int                       i            = 0;
			boolean                   isSms        = false;
			double                    invQtyDouble = 0.0;
			double                    grQtyDouble  = 0.0;
			
			pay_no = wo.result[0];
			
			if(sign_status.equals("E")){ // 구매요청 상태 변경
				String prev_pr_progress_flag = "F";
				String pr_progress_flag      = "V";
				
				setPr_progress_flag(ctx, pay_no, prev_pr_progress_flag, pr_progress_flag, inv_no); //검수완료 상태값을 찍기 위해서 INV_NO를 넘긴다.
			}
			
			for(i = 0; i < gridSize; i++){
				gridInfo     = grid.get(i);
				itemNo       = gridInfo.get("ITEM_NO");		
				invSeq       = gridInfo.get("INV_SEQ");						
				invQty       = gridInfo.get("INV_QTY");
				grQty        = gridInfo.get("GR_QTY");
				invQtyDouble = Double.parseDouble(invQty);
				grQtyDouble  = Double.parseDouble(grQty);
				
				if(invQtyDouble != grQtyDouble){
					isSms = true;
				}
				
				
				String house_code = info.getSession("HOUSE_CODE");
				String rtnHD = getMaterialCtrlType(house_code, itemNo);

				SepoaFormater wf = new SepoaFormater(rtnHD);
				if (wf.getRowCount() > 0){
					String material_ctrl_type = wf.getValue(0, 0);
					// 안내장,e-홍보물 인경우만	                
					if("03091".equals(material_ctrl_type) || "03092".equals(material_ctrl_type)){
						this.setPBHD(ctx, inv_no, invSeq, itemNo, grQty);
					}					
				}
			}
			
			if(isSms){
				Map<String, String> smsParam = new HashMap<String, String>();
				
	  	    	smsParam.put("HOUSE_CODE", info.getSession("HOUSE_CODE"));
	  	    	smsParam.put("INV_NO",     inv_no);
				
				new SMS("NONDBJOB", info).iv1Process(ctx, smsParam);
				new mail("NONDBJOB", info).iv1Process(ctx, smsParam);
			}
			
			if(insrow == 6){
				Commit();
				setStatus(1);
				setMessage("정상적으로 처리되었습니다.");
				setValue(inv_no);
			}
			else{
				Rollback();
				setStatus(0);	
			}
		}
		catch (Exception e) {
			try {
				Rollback();
				setFlag(false);
			}
			catch(Exception d) {
	            Logger.err.println(userid,this,d.getMessage());
	        }
			
			setStatus(0);
			setMessage(e.getMessage());
			Logger.err.println(this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	private String getMaterialCtrlType(String house_code, String item_no)
	throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			
			Map<String, String> data = new HashMap<String, String>();
			data.put("house_code", house_code);
			data.put("item_no", item_no);

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this,ctx, wxp.getQuery());
			String[] type = { "S", "S"};

			//String[] args = { house_code, item_no };
			rtn = sm.doSelect(data);

		} catch (Exception e) {
			throw new Exception("getMaterialCtrlType:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	
	private int setPBHD(ConnectionContext ctx, String invNo, String invSeq, String itemNo, String grQty)throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			data.put("inv_no", invNo);
			data.put("inv_seq", invSeq);
			data.put("item_no", itemNo);
			data.put("gr_qty", grQty);
			//부점의 소유품목 유무조회
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			SepoaFormater wf1 = new SepoaFormater(sm.doSelect(data));
				
			int i_cnt = Integer.parseInt(wf1.getValue("CNT", 0));
			
			if( i_cnt ==  0 ){			
				// 소유품목으로 인식
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
				sm = new SepoaSQLManager(user_id, this, ctx, wxp);
				sm.doUpdate(data);
				rtn++;
			}
			else{
				// 소유품목 갱신
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
				sm = new SepoaSQLManager(user_id, this, ctx, wxp);
				sm.doUpdate(data);
				rtn++;
			}
			
		} catch (Exception e) {
			throw new Exception("setPBHD : " + e.getMessage());
		} finally {
		}		
		
		return rtn;
	}
	
	private int in_setApprovalHD(ConnectionContext ctx, String inv_no, String pay_no, String sign_status) throws Exception {
		int rtn = 0;
		String ctrl_code[] = info.getSession("CTRL_CODE").split("&");
		String job_status = "";
		String user_id = info.getSession("ID");
		if(sign_status.equals("E")){
			job_status = "V";
		}else {
			job_status = "N";
		}
		
		try {
			Map<String, String> data = new HashMap<String, String>();
			// 1. 거래명세서 헤더(ICOYTRHD) 등록
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("inv_no", inv_no);
			data.put("pay_no", pay_no);
			data.put("sign_status", sign_status);
			data.put("job_status", job_status);			
			data.put("ctrl_code", ctrl_code[0]);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			sm.doUpdate(data);
			rtn++; 
		} catch (Exception e) {
			throw new Exception("in_setApproval:" + e.getMessage());
		} finally {
		}

		return rtn;
	}
	
	
	private int in_setApprovalDT(ConnectionContext ctx, String inv_no, String pay_no) throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			// 1. 거래명세서 상세(ICOYTRDT) 등록
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("inv_no", inv_no);
			data.put("pay_no", pay_no);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			sm.doUpdate(data);
			rtn++;
		} catch (Exception e) {
			throw new Exception("in_setApproval:" + e.getMessage());
		} finally {
		}

		return rtn;
	}
	
	private int up_setApprovalHD(ConnectionContext ctx, String inv_no,
			String pay_no, String sign_status) throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			// 1. 거래명세서 상세(ICOYTRDT) 등록
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("inv_no", inv_no);
			data.put("pay_no", pay_no);
			data.put("sign_status", sign_status);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			sm.doUpdate(data);
			rtn++;
		} catch (Exception e) {
			throw new Exception("in_setApproval:" + e.getMessage());
		} finally {
		}

		return rtn;
	}
	
	private int setPr_progress_flag(ConnectionContext ctx, String doc_no,String prev_pr_progress_flag, String pr_progress_flag, String inv_no)throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			data.put("doc_no", doc_no);
			data.put("prev_pr_progress_flag", prev_pr_progress_flag);
			data.put("pr_progress_flag", pr_progress_flag);
			data.put("inv_no", inv_no);	//ICOYPRDT의 상태값을 변경하기위해 ICOYIVDT의 키값인 inv_no를 받는다.
			//현재 문서아이템의 갯수 조회
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			SepoaFormater wf1 = new SepoaFormater(sm.doSelect(data));
				
			//이전 문서아이템의 완료 갯수 조회
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			SepoaFormater wf2 = new SepoaFormater(sm.doSelect(data));
			int tr_cnt = Integer.parseInt(wf1.getValue("TRDT_CNT", 0));
			int inv_cnt = Integer.parseInt(wf2.getValue("INV_CNT", 0));
			
			if( tr_cnt ==  inv_cnt ){
			
				// 이전 PR_PROGRESS_FLAG  유무 확인후 상태변경
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
				sm = new SepoaSQLManager(user_id, this, ctx, wxp);
				sm.doUpdate(data);
				rtn++;
			}
			else{
				
			}
			
		} catch (Exception e) {
			throw new Exception("setPr_progress_flag : " + e.getMessage());
		} finally {
		}		
		
		return rtn;
	}
	
	
	private SepoaFormater getERPINVList(String inv_no) throws Exception {
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		SepoaFormater wf = null;
		try{
			ConnectionContext ctx =	getConnectionContext();
			//현재 문서아이템의 갯수 조회
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("inv_no", inv_no);
			
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			wf = new SepoaFormater(sm.doSelect((String[])null));	

		}catch (Exception e) {
			throw new Exception("getERPINVList : " + e.getMessage());
		} finally {
		}
		return wf;
	}
	
	public SepoaOut setApproval2(String inv_no, String sign_remark) {
		try {
			ConnectionContext ctx = getConnectionContext();
			
			int insrow = in_setApproval2(ctx, inv_no, sign_remark);
			insrow = in_setInvQty2(inv_no);
			Commit();

			Logger.debug.println(info.getSession("ID"), this, "!!!!!!!!!!!!!OK!!!!!!!!!!!!!");
			setStatus(1);
			setMessage("반려 되었습니다.");
			setValue(inv_no);

		} catch (Exception e) {
			try {
	              Rollback();
	          } catch(Exception d) {
	              Logger.err.println(userid,this,d.getMessage());
	        }

			Logger.err.println("Exception e =" + e.getMessage());
			Logger.debug.println(info.getSession("ID"), this, "[setApproval2][sign_status]::"+inv_no+"!!!!!!!!!!!!!ERROR!!!!!!!!!!!!!");
			setStatus(0);
			setMessage(e.getMessage());
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

   /**
	* 최종검수요청일 경우 반려시 평가정보 삭제
    */
	private int del_setEvalData(ConnectionContext ctx, String eval_refitem) throws Exception {
		int rtn = -1;

		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");

		 SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
		 SepoaXmlParser wxp2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
		 SepoaXmlParser wxp3 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");

		try {
	        wxp1.addVar("eval_status", "D");
	        wxp1.addVar("house_code", house_code);
	        wxp1.addVar("eval_refitem", eval_refitem);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp1.getQuery());
			rtn = sm.doUpdate();

			wxp2.addVar("eval_status", "D");
	        wxp2.addVar("house_code", house_code);
		    wxp2.addVar("eval_refitem", eval_refitem);
			sm = new SepoaSQLManager(user_id, this, ctx, wxp2.getQuery());
			rtn = sm.doUpdate();

			wxp3.addVar("eval_status", "D");
	        wxp3.addVar("house_code", house_code);
		    wxp3.addVar("eval_refitem", eval_refitem);
			sm = new SepoaSQLManager(user_id, this, ctx, wxp3.getQuery());
			rtn = sm.doUpdate();


		} catch (Exception e) {
			throw new Exception("del_setEvalData:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

   /**
	* 검수요청 승인시 PIS시스템에 검수 승인정보 I/F
    */
	private int in_setPISGR(String inv_no) throws Exception {
		if(getConfig("Sepoa.scms.if_flag").equals("false"))
		{
			return 1;
		}

		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();

		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");

		try {
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("house_code", house_code);
	        wxp.addVar("inv_no", inv_no);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			rtn = sm.doUpdate();

		} catch (Exception e) {
			throw new Exception("in_setPISGR:" + e.getMessage());
		} finally {
		}
		return rtn;
	}


	/**
	 * 검수요청 승인/반려
	 * @Method Name : in_setApproval
	 * @작성일       : 2008. 11. 10
	 * @작성자       : wooman.choi
	 * @변경이력     :
	 * @Method 설명  :
	 * @param inv_no
	 * @param sign_status
	 * @param sign_remark
	 * @return
	 * @throws Exception
	 */
	private int in_setApproval(ConnectionContext ctx, Map<String, Object>alldata) throws Exception
	{
		int rtn = 0;
		List<Map<String, String>> gridData = (List<Map<String, String>>) MapUtils.getObject(alldata, SepoaDataMapper.KEY_GRID_DATA);
		Map<String, String> headerdata = MapUtils.getMap(alldata, SepoaDataMapper.KEY_HEADER_DATA);
		headerdata.put("confirm_date1", SepoaString.getDateUnSlashFormat(headerdata.get("confirm_date1")));
		String user_id = info.getSession("ID");
		try {
	        // 1. 검수요청상세(ICOYIVDT) 수정
	        SepoaXmlParser wxp = new SepoaXmlParser(this, "in_setApproval_ICOYIVDT");
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			String[] type1 = {"S","S","S","S","S","S","S"};
			sm.doUpdate(gridData, headerdata);
			rtn++;
	        // 2. 검수요청헤더(ICOYIVHD) 수정
			wxp = new SepoaXmlParser(this, "in_setApproval_ICOYIVHD");
			sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			String[] type2 = {"S","S","S","S","S","S","S","S","S"};
			sm.doUpdate(headerdata);
			rtn++;
	        // 3. 발주상세(ICOYPODT) 수정
			wxp = new SepoaXmlParser(this, "in_setApproval_ICOYPODT");
			sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			String[] type3 = {"S","S","S","S","S"};
			sm.doUpdate(gridData, headerdata);
			rtn++;
	        // 4. 발주상세(ICOYPODT) 완료여부 수정
			wxp = new SepoaXmlParser(this, "in_setApproval_ICOYPODT_COMP");
			sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			String[] type4 = {"S","S","S","S","S"};
			sm.doUpdate(gridData, headerdata);
			rtn++;
			/*
	        // 5. 발주헤더(ICOYPOHD) 수정
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_ICOYPOHD");
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(Ivhd, null);
			*/
	        // 5. 발주헤더(ICOYPOHD) 완료여부 수정
			wxp = new SepoaXmlParser(this, "in_setApproval_ICOYPOHD_COMP");
			sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			sm.doUpdate(headerdata);
			rtn++;
	        // 6. 검수요청 마지막 차수 검수 완료 후 잔여 검수량을 잔금으로 생성 시킨다.(ICOYCNDP)
			wxp = new SepoaXmlParser(this, "in_setApproval_ICOYCNDP_COMP");
			sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			sm.doInsert(headerdata);
			rtn++;
		}
		catch (Exception e) {
			throw new Exception("in_setApproval:" + e.getMessage());
		}
		finally {}
		
		return rtn;
	}
	
	/**
	 * 파일추가
	 * @Method Name : attachFile
	 * @Method 설명  :
	 * @return
	 */
	public SepoaOut attachFile(Map<String, Object> allData) {
		try {
			ConnectionContext         ctx          = getConnectionContext();
			Map<String, String>	      header       = MapUtils.getMap(allData, SepoaDataMapper.KEY_HEADER_DATA);
			String                    sign_status  = "E";
			String                    inv_no       = header.get("inv_no");
			String                    pay_no       = null;
			String                    invQty       = null;
			String                    grQty        = null;
//			int                       insrow       = in_attachFile(ctx, allData); // 검수완료
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, "in_attachFile_ICOYIVHD");
			SepoaSQLManager sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp);
			String[] type2 = {"S","S","S","S","S","S","S","S","S"};
			int insrow = sm.doUpdate(header);
						
			if(insrow == 1){
				Commit();
				setStatus(1);
				setMessage("정상적으로 처리되었습니다.");
				setValue(inv_no);
			}
			else{
				Rollback();
				setStatus(0);	
			}
		}
		catch (Exception e) {
			try {
				Rollback();
				setFlag(false);
			}
			catch(Exception d) {
	            Logger.err.println(userid,this,d.getMessage());
	        }
			
			setStatus(0);
			setMessage(e.getMessage());
			Logger.err.println(this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	/**
	 * 파일추가
	 * @Method Name : SepoaXmlParser 
	 * @작성일       : 2016. 03. 02
	 * @작성자       : 
	 * @변경이력     :
	 * @Method 설명  :
	 * @param inv_no
	 * @param sign_status
	 * @param sign_remark
	 * @return
	 * @throws Exception
	 */
	private int in_attachFile(ConnectionContext ctx, Map<String, Object>alldata) throws Exception
	{
		int rtn = 0;
		List<Map<String, String>> gridData = (List<Map<String, String>>) MapUtils.getObject(alldata, SepoaDataMapper.KEY_GRID_DATA);
		Map<String, String> headerdata = MapUtils.getMap(alldata, SepoaDataMapper.KEY_HEADER_DATA);
		headerdata.put("confirm_date1", SepoaString.getDateUnSlashFormat(headerdata.get("confirm_date1")));
		String user_id = info.getSession("ID");
		try {
	        SepoaXmlParser wxp = new SepoaXmlParser(this, "in_attachFile_ICOYIVHD");
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			String[] type2 = {"S","S","S","S","S","S","S","S","S"};
			sm.doUpdate(headerdata);
			rtn++;	        
		}
		catch (Exception e) {
			throw new Exception("in_attachFile_ICOYIVHD:" + e.getMessage());
		}
		finally {}
		
		return rtn;
	}
	
	/**
	 * 검수요청 반려
	 * @Method Name : in_setApproval
	 * @작성일       : 2011. 11. 24
	 * @작성자       : wooman.choi
	 * @변경이력     :
	 * @Method 설명  :
	 * @param inv_no
	 * @param po_no
	 * @param 
	 * @return
	 * @throws Exception
	 */
	private int in_setApproval2(ConnectionContext ctx, String inv_no, String sign_remark) throws Exception {
		int rtn = -1;

		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		String dept = info.getSession("DEPARTMENT");

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
	        wxp.addVar("house_code", house_code);
	        wxp.addVar("inv_no", inv_no);
	        wxp.addVar("user_id", user_id);
	        wxp.addVar("dept", dept);
	        wxp.addVar("sign_remark", sign_remark);
	        SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			rtn = sm.doUpdate();

			/*검수수량과 발주수량이 같으면 완료처리 ICOYPOHD*/
	        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
	        wxp.addVar("house_code", house_code);
	        wxp.addVar("inv_no", inv_no);
	        wxp.addVar("user_id", user_id);
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			rtn = sm.doUpdate();

		} catch (Exception e) {
			throw new Exception("in_setApproval:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/**
	 * 검수요청승인시 검수요청수량을 검수완료수량으로 update
	 * @Method Name : in_setInvQty
	 * @작성일       : 2008. 11. 10
	 * @작성자       : wooman.choi
	 * @변경이력     :
	 * @Method 설명  :
	 * @param inv_no
	 * @return
	 * @throws Exception
	 */
	private int in_setInvQty2(String inv_no) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();

		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		String dept = info.getSession("DEPARTMENT");
		String[] type2 = { "S", "S", "S","S", "S" };
		try {
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
	        wxp.addVar("user_id", user_id);
	        wxp.addVar("house_code", house_code);
	        wxp.addVar("inv_no", inv_no);

	        SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			rtn = sm.doUpdate();

		} catch (Exception e) {
			throw new Exception("in_setInvQty:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 검수요청승인시 검수요청수량을 검수완료수량으로 update
	 * @Method Name : in_setInvQty
	 * @작성일       : 2008. 11. 10
	 * @작성자       : wooman.choi
	 * @변경이력     :
	 * @Method 설명  :
	 * @param inv_no
	 * @return
	 * @throws Exception
	 */
	private int in_setInvQty(String inv_no, String confirmDate, String grDate) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();

		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		String dept = info.getSession("DEPARTMENT");
		String[][] setDataHd = { { user_id, dept, confirmDate, house_code, inv_no } };
		String[][] setDataDt = { { user_id, dept, grDate, house_code, inv_no } };
		String[] type2 = { "S", "S", "S","S", "S" };
		try {
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");

//			tSQL.append("	UPDATE ICOYIVDT											  \n");
//			tSQL.append("	SET	CHANGE_DATE			= convert(varchar, getdate(), 112)     	\n");
//			tSQL.append("		,CHANGE_TIME        = substring(replace(convert(varchar, getdate(), 108), ':', ''), 1, 4)		\n");
//			tSQL.append("		,CHANGE_USER_ID     = ?   							  \n");
//			tSQL.append("		,CHANGE_USER_DEPT   = ?   							  \n");
//			tSQL.append("		,GR_DATE            = ?								  \n");
//			tSQL.append("		,GR_QTY        		= INV_QTY   					  \n");
//			tSQL.append("	WHERE HOUSE_CODE = ?            						  \n");
//			tSQL.append("	AND   INV_NO	 = ?		    						  \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			// 넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
			rtn = sm.doUpdate(setDataDt, type2);
	        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");

//			tSQL.append("	UPDATE ICOYIVHD 									  	\n");
//			tSQL.append("	SET	CHANGE_DATE			= convert(varchar, getdate(), 112)     	\n");
//			tSQL.append("		,CHANGE_TIME        = substring(replace(convert(varchar, getdate(), 108), ':', ''), 1, 4)		\n");
//			tSQL.append("		,CHANGE_USER_ID     = ?   							\n");
//			tSQL.append("		,CHANGE_USER_DEPT   = ?   							\n");
//			tSQL.append("		,CONFIRM_DATE2      = ?   							\n");
//			tSQL.append("		,INV_AMT			 = DP_AMT					\n");
//			tSQL.append("	WHERE HOUSE_CODE   = ?            						\n");
//			tSQL.append("	AND   INV_NO	 	= ?		    						\n");

			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(setDataHd, type2);

	        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
	        wxp.addVar("user_id", user_id);
	        wxp.addVar("house_code", house_code);
	        wxp.addVar("inv_no", inv_no);
//			tSQL.append("	UPDATE ICOYPODT											            \n");
//			tSQL.append("	SET	CHANGE_DATE			= convert(varchar, getdate(), 112)     	\n");
//			tSQL.append("		,CHANGE_TIME        = substring(replace(convert(varchar, getdate(), 108), ':', ''), 1, 4)		\n");
//			tSQL.append("		,CHANGE_USER_ID     = '" + user_id + "'   							\n");
//			tSQL.append("		,GR_QTY        		= dbo.GETGRQTY(HOUSE_CODE,PO_NO,PO_SEQ)   		\n");
//			tSQL.append("	WHERE HOUSE_CODE = '" + house_code + "'            						\n");
//			tSQL.append("	AND   PO_NO	 	 = (SELECT MAX(PO_NO)                               \n");
//			tSQL.append("						FROM ICOYIVDT                                   \n");
//			tSQL.append("						WHERE HOUSE_CODE = '" + house_code + "'             \n");
//			tSQL.append("						  AND INV_NO     = '" + inv_no + "')				\n");
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			rtn = sm.doUpdate();

			/*검수수량과 발주수량이 같으면 완료처리 ICOYPODT*/
	        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_4");
	        wxp.addVar("user_id", user_id);
	        wxp.addVar("house_code", house_code);
	        wxp.addVar("inv_no", inv_no);
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			rtn = sm.doUpdate();

			/*검수수량과 발주수량이 같으면 완료처리 ICOYPOHD*/
	        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_5");
	        wxp.addVar("user_id", user_id);
	        wxp.addVar("house_code", house_code);
	        wxp.addVar("inv_no", inv_no);
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			rtn = sm.doUpdate();
		} catch (Exception e) {
			throw new Exception("in_setInvQty:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	public SepoaOut CallNONDBJOB(	ConnectionContext ctx, String serviceId, String MethodName, Object[] obj )
	{

		String conType = "NONDBJOB";					//conType :	CONNECTION/TRANSACTION/NONDBJOB

		sepoa.fw.srv.SepoaOut value = null;
		sepoa.fw.util.SepoaRemote wr	= null;

		//다음은 실행할	class을	loading하고	Method호출수 결과를	return하는 부분이다.
		try
		{

			wr = new sepoa.fw.util.SepoaRemote( serviceId, conType, info	);
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
	 * 검수 담당자 변경
	 * @param Transfer_person_id
	 * @param inv_no
	 * @return
	 */
	public SepoaOut charge_transfer( Map<String, Object> data ) {
		try {
			
			List<Map<String, String>> grid          = null;
			Map<String, String>       gridInfo      = null;
			Map<String, String> 	  header		= null;
			header = MapUtils.getMap(data, "headerData");
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			
			String Transfer_person_id = header.get("Transfer_person_id");
			String[] inv_no = new String[grid.size()];
			
			for(int i = 0 ; i < grid.size() ; i++ ){
				inv_no[i] = grid.get(i).get("INV_NO");
			}

			Logger.debug.println(info.getSession("ID"), this, " Transfer_person_id ::" + Transfer_person_id);
			int rtn = et_charge_transfer_doc(  Transfer_person_id,   inv_no);

			setStatus(1);
			setValue(String.valueOf(rtn));
			
			Logger.debug.println(info.getSession("ID"), this, " Transfer_person_id ::" + Transfer_person_id);
			int rtn_eval = et_charge_transfer_eval(  Transfer_person_id,   inv_no);
			
			setStatus(1);
			setValue(String.valueOf(rtn));

			setMessage("성공적으로 변경되었습니다.");
			Commit();
		} catch (Exception e) {
			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0002"));
		}
		return getSepoaOut();
	}

	private int et_charge_transfer_doc( String Transfer_person_id, String[] inv_no) throws Exception {

		ConnectionContext ctx = getConnectionContext();
		int rtn = 0;
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		SepoaSQLManager sm = null;
		SepoaFormater wf = null;
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

		try {
			Logger.debug.println(info.getSession("ID"), this, "   inv_no.length  === > " + inv_no.length);
			String[][] data = new String[inv_no.length][];

            for(int	i =	0 ;	i <	inv_no.length;	i++	) {
            	String[] tmp = {Transfer_person_id, house_code, inv_no[i]};
            	data [i] = tmp;
			}

//			sql.append("UPDATE ICOYIVHD                     \n");
//			sql.append("SET  INV_PERSON_ID = ?              \n");
//			sql.append("WHERE HOUSE_CODE = ?              \n");
//			sql.append("AND INV_NO   = ?                 \n");

			String[] type = { "S", "S", "S"  };

				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(data, type);


		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	private int et_charge_transfer_eval( String Transfer_person_id, String[] inv_no) throws Exception {
		
		ConnectionContext ctx = getConnectionContext();
		int rtn = 0;
		String house_code = info.getSession("HOUSE_CODE");
		SepoaSQLManager sm = null;
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("inv_no", inv_no);
		wxp.addVar("Transfer_person_id", Transfer_person_id);
		
		try {
			
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doUpdate( );
			
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	public SepoaOut getInvHeader(String inv_no) {
		try {

			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getInvHeader(house_code, inv_no);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

			setStatus(1);
			setValue(rtnHD);

		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

	private String bl_getInvHeader(String house_code, String inv_no)
	throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//			tSQL.append("			SELECT  top 1                                                            			\n");
//			tSQL.append("				    VD.IV_NO                                                            			\n");
//			tSQL.append("				   ,VD.PO_NO                                                            			\n");
//			tSQL.append("				   ,VH.SUBJECT                                                          			\n");
//			tSQL.append("				   ,dbo.GETICOMCODE1(VH.HOUSE_CODE,'M134',VH.DP_TYPE) AS DP_TYPE_DESC       			\n");
//			tSQL.append("				   ,VH.DP_TYPE                                                          			\n");
//			tSQL.append("				   ,dbo.GETICOMCODE1(VH.HOUSE_CODE,'M010',VH.DP_PAY_TERMS) AS DP_PAY_TERMS_DESC			\n");
//			tSQL.append("				   ,VH.DP_PAY_TERMS                                                     			\n");
//			tSQL.append("				   ,VH.IV_SEQ                                                            			\n");
//			tSQL.append("				   ,VH.DP_AMT                                                           			\n");
//			tSQL.append("				   ,VH.PO_TTL_AMT                                                       			\n");
//			tSQL.append("				   ,dbo.GETUSERNAMELOC(VH.HOUSE_CODE, VH.PURCHASE_ID) AS USER_NAME         				\n");
//			tSQL.append("				   ,VH.INV_PERSON_ID                                                    			\n");
//			tSQL.append("				   ,VH.INV_DATE                                                         			\n");
//			tSQL.append("				   ,VH.REMARK                                                           			\n");
//			tSQL.append("				   ,VH.DP_PAY_TERMS_TEXT                                                			\n");
//			tSQL.append("				   ,VH.PO_CREATE_DATE                                                   			\n");
//			tSQL.append("				   ,VH.DP_TEXT                                                          			\n");
//			tSQL.append("				   ,VH.DP_PERCENT                                                       			\n");
//			tSQL.append("				   ,VH.ATTACH_NO                                                        			\n");
//			tSQL.append("				   ,(case vh.attach_no when '' then 0 else 1 end) as attach_count       			\n");
//			tSQL.append("				   ,dbo.GETINVAMT(VD.HOUSE_CODE, VD.PO_NO) AS INV_AMT                       			\n");
//			tSQL.append("				   ,(SELECT PR_TYPE                                                                 \n");
//			tSQL.append("					 FROM ICOYPOHD                                                                  \n");
//			tSQL.append("					 WHERE HOUSE_CODE 	= VD.HOUSE_CODE                                             \n");
//			tSQL.append("					   AND PO_NO		= VD.PO_NO                                                  \n");
//			tSQL.append("					   AND PO_SEQ	 	= VD.PO_SEQ) AS PR_TYPE										\n");
//			tSQL.append("			FROM ICOYIVHD VH, ICOYIVDT VD                                               			\n");
//			tSQL.append("			WHERE VH.HOUSE_CODE = VD.HOUSE_CODE                                         			\n");
//			tSQL.append("<OPT=S,S>	AND   VH.HOUSE_CODE	= ?			                                             	  </OPT>\n");
//			tSQL.append("<OPT=S,S>	AND   VH.INV_NO		= ?			                                             	  </OPT>\n");
//			tSQL.append("			AND   VH.INV_NO     = VD.INV_NO															\n");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this,
					ctx, wxp.getQuery());
			String[] args = { house_code, inv_no };
			rtn = sm.doSelect(args);

		} catch (Exception e) {
			throw new Exception("bl_getIvdpList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * inv_seq별로 GR을 취소한다.
	 * @param inv_no
	 * @param sign_status
	 * @param sign_remark
	 * @param confirmDate
	 * @param grDate
	 * @return
	 */
	public SepoaOut setGRCancel(String inv_no, String[] inv_seq) {
		try {
			ConnectionContext ctx = getConnectionContext();


			//Object[] obj = {inv_no, inv_seq};
      		//SepoaOut value = CallNONDBJOB( ctx,  "GRCancel", "sendSCI", obj);
      		//if(value.status == 0)
      		//	throw new Exception(value.message);

      		int insrow = in_setGRCancel(ctx, inv_no, inv_seq);
			setValue("Insert Row=" + insrow);

			Commit();

			Logger.debug.println(info.getSession("ID"), this, "!!!!!!!!!!!!!OK!!!!!!!!!!!!!");
			setStatus(1);
			String mes =  "삭제";
			setMessage(mes + "되었습니다.");
		} catch (Exception e) {
			try {
	              Rollback();
	          } catch(Exception d) {
	              Logger.err.println(userid,this,d.getMessage());
	        }

			Logger.err.println("Exception e =" + e.getMessage());
			Logger.debug.println(info.getSession("ID"), this, "!!!!!!!!!!!!!ERROR!!!!!!!!!!!!!");
			setStatus(0);
			setMessage(e.getMessage());
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	private int in_setGRCancel(ConnectionContext ctx, String inv_no, String[] inv_seq) throws Exception {
		int rtn = -1;
		int rtnDt = -1;
		int cnt = 0;
		String rtnDtData = "";

		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		String dept = info.getSession("DEPARTMENT");
		String[][] RmData = {{ inv_no }};

		try {

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
	        wxp.addVar("inv_no", inv_no);

//				tSQL.append("SELECT                                            \n");
//				tSQL.append("       COUNT(*) CNT                                  \n");
//				tSQL.append("  FROM ICOYIVDT                  \n");
//				tSQL.append("  WHERE GR_CANCEL_NO IS NOT NULL        \n");
//				tSQL.append("  AND INV_NO      = '"+inv_no+"'        \n");

			    SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
			    String rtnSel = sm.doSelect();
			    SepoaFormater wf = new SepoaFormater(rtnSel);
				String CNT	= wf.getValue("CNT", 0);
				Logger.debug.println(info.getSession("ID"), this, "!!!!!!!!!!!!!CNT!!!!!!!!!!!!!"+ CNT);

		        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
		        wxp.addVar("inv_no", inv_no);

//				tSQL.append("SELECT                                            \n");
//				tSQL.append("       COUNT(*) CNT                                  \n");
//				tSQL.append("  FROM ICOYIVDT                  \n");
//				tSQL.append("  WHERE INV_NO      = '"+inv_no+"'        \n");

			    sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
			    rtnSel = sm.doSelect();
			    wf = new SepoaFormater(rtnSel);
				String CNT1	= wf.getValue("CNT", 0);
				Logger.debug.println(info.getSession("ID"), this, "!!!!!!!!!!!!!CNT1!!!!!!!!!!!!!"+ CNT1);

				if (CNT.equals(CNT1))
				{
			        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
			        wxp.addVar("user_id", user_id);
			        wxp.addVar("dept", dept);
			        wxp.addVar("house_code", house_code);
//					tSQL.append("	UPDATE ICOYIVHD											  	\n");
//					tSQL.append("	SET	CHANGE_DATE			= convert(varchar, getdate(), 112)     	\n");
//					tSQL.append("		,CHANGE_TIME        = substring(replace(convert(varchar, getdate(), 108), ':', ''), 1, 4)		\n");
//					tSQL.append("		,CHANGE_USER_ID     = '"+user_id+"'   								\n");
//					tSQL.append("		,CHANGE_USER_DEPT   = '"+dept+"'   								\n");
//					tSQL.append("		,SIGN_STATUS        = 'D'   								\n");
//					tSQL.append("		,SIGN_REMARK        = ''   								\n");
//					tSQL.append("		,STATUS  		= 'D'								\n");
//					tSQL.append("	WHERE HOUSE_CODE 		= '"+house_code+"'       							\n");
//					tSQL.append("	AND   INV_NO	 		= ?	    							\n");

					sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

					// 넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
					String[] type = { "S"};
					rtn = sm.doUpdate(RmData, type);
				}

		} catch (Exception e) {
			throw new Exception("in_setGRCancel:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 통신비, 프리랜서 전표 결재상세화면조회
	 * @param inv_no
	 * @return
	 */
	public SepoaOut getInvAppDis(String inv_no) {
		try {

			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getInvAppDis(house_code, inv_no);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}

			setStatus(1);
			setValue(rtnHD);

		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

	private String bl_getInvAppDis(String house_code, String inv_no)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {

//			StringBuffer tSQL = new StringBuffer();

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//			tSQL.append("SELECT \n");
//			tSQL.append("            MAX(VH.SUBJECT) SUBJECT \n");
//			tSQL.append("            ,MAX(DBO.GETVENDORNAME(VH.HOUSE_CODE, VH.VENDOR_CODE))  VENDOR_NAME \n");
//			tSQL.append("            ,MAX(VD.DESCRIPTION_LOC) DESCRIPTION_LOC \n");
//			tSQL.append("            ,    CAST(( SELECT \n");
//			tSQL.append("            SUM(case mwskz when 'V2' then  0 \n");
//			tSQL.append("            when 'V3' then 0 \n");
//			tSQL.append("            when 'Z0' then 0 \n");
//			tSQL.append("            else FLOOR(vd.GR_QTY * vd.UNIT_PRICE * 0.1) \n");
//			tSQL.append("            end) \n");
//			tSQL.append("            from icoypodt podt, icoyivdt vd \n");
//			tSQL.append("            where podt.house_code     = vd.house_code \n");
//			tSQL.append("            AND podt.po_no     = vd.po_no \n");
//			tSQL.append("            AND  podt.po_SEQ     = vd.po_SEQ \n");
//			tSQL.append("            and vd.house_code  = VH.house_code \n");
//			tSQL.append("            and vd.inv_no       = VH.inv_no   ) AS DEC(22) ) TAX_AMT \n");
//			tSQL.append("            ,  SUM(CAST(FLOOR(VD.GR_QTY * VD.UNIT_PRICE) AS DEC(22) ))  ITEM_AMT \n");
//			tSQL.append("            ,     ( SELECT \n");
//			tSQL.append("                MAX(case mwskz when 'V2' then  ' ' \n");
//			tSQL.append("                when 'V3' then ' ' \n");
//			tSQL.append("                when 'Z0' then '' \n");
//			tSQL.append("                else 'VAT' \n");
//			tSQL.append("                end) \n");
//			tSQL.append("                from icoypodt podt, icoyivdt vd \n");
//			tSQL.append("                where podt.house_code     = vd.house_code \n");
//			tSQL.append("                AND podt.po_no     = vd.po_no \n");
//			tSQL.append("                AND  podt.po_SEQ     = vd.po_SEQ \n");
//			tSQL.append("                and vd.house_code  = VH.house_code \n");
//			tSQL.append("                and vd.inv_no       = VH.inv_no      ) VAT \n");
//			tSQL.append("/* \n");
//			tSQL.append("            ,    CAST(( SELECT \n");
//			tSQL.append("            SUM(case mwskz when 'V2' then  FLOOR(vd.GR_QTY * vd.UNIT_PRICE) \n");
//			tSQL.append("            when 'V3' then FLOOR(vd.GR_QTY * vd.UNIT_PRICE) \n");
//			tSQL.append("            when 'Z0' then FLOOR(vd.GR_QTY * vd.UNIT_PRICE) \n");
//			tSQL.append("            else FLOOR(vd.GR_QTY * vd.UNIT_PRICE * 1.1) \n");
//			tSQL.append("            end) \n");
//			tSQL.append("            from icoypodt podt, icoyivdt vd \n");
//			tSQL.append("            where podt.house_code     = vd.house_code \n");
//			tSQL.append("            AND podt.po_no     = vd.po_no \n");
//			tSQL.append("            AND  podt.po_SEQ     = vd.po_SEQ \n");
//			tSQL.append("            and vd.house_code  = VH.house_code \n");
//			tSQL.append("            and vd.inv_no       = VH.inv_no   ) AS DEC(22) ) TAX_TOTAL \n");
//			tSQL.append("*/ \n");
//			tSQL.append("            ,    floor(CAST(( SELECT \n");
//			tSQL.append("            SUM(case mwskz when 'V2' then  FLOOR(vd.GR_QTY * vd.UNIT_PRICE) \n");
//			tSQL.append("            when 'V3' then FLOOR(vd.GR_QTY * vd.UNIT_PRICE) \n");
//			tSQL.append("            when 'Z0' then FLOOR(vd.GR_QTY * vd.UNIT_PRICE) \n");
//			tSQL.append("            else FLOOR(vd.GR_QTY * vd.UNIT_PRICE * 1.1) \n");
//			tSQL.append("            end) \n");
//			tSQL.append("            from icoypodt podt, icoyivdt vd \n");
//			tSQL.append("            where podt.house_code     = vd.house_code \n");
//			tSQL.append("            AND podt.po_no     = vd.po_no \n");
//			tSQL.append("            AND  podt.po_SEQ     = vd.po_SEQ \n");
//			tSQL.append("            and vd.house_code  = VH.house_code \n");
//			tSQL.append("            and vd.inv_no       = VH.inv_no   ) AS DEC(22) ) / 10) * 10 as TAX_TOTAL \n");
//
//			tSQL.append("		FROM ICOYIVHD VH, ICOYIVDT VD                                               \n");
//			tSQL.append("		WHERE VH.HOUSE_CODE = VD.HOUSE_CODE                                         \n");
//			tSQL.append("<OPT=S,S>	AND   VH.HOUSE_CODE	= ?			                                             	  </OPT>\n");
//			tSQL.append("<OPT=S,S>	AND   VH.INV_NO		= ?			                                             	  </OPT>\n");
//			tSQL.append("		AND   VH.INV_NO     = VD.INV_NO															                \n");
//			tSQL.append("		GROUP BY VH.HOUSE_CODE, VH.INV_NO                                           \n");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args = { house_code, inv_no };
			rtn = sm.doSelect(args);

		} catch (Exception e) {
			throw new Exception("bl_getIvdpList:" + e.getMessage());
		} finally {
		}
		return rtn;
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
	
	public SepoaOut selectIcoyivHdDtSeList(Map<String, String> header){
		ConnectionContext ctx = null;
		String            rtn = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx    = getConnectionContext();
			rtn    = this.select(ctx, "selectIcoyivHdDtSeList", header);
			
			setValue(rtn);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		
		return getSepoaOut();
	}
	
	//public SepoaOut Tly_Cancel(String inv_no,String inv_seq,String pr_no,String pr_seq){
	public SepoaOut Tly_Cancel(String inv_no){
		try {
				String house_code = info.getSession("HOUSE_CODE");
				String rtnvalue01 = bl_getICOYIVHD_CHK01(house_code, inv_no);

	            if (rtnvalue01.equals("0")){
	            	setFlag(false);
	                setStatus(0);
	                setMessage("검수취소가 불가합니다.");
	                return getSepoaOut();
	            }

				String rtnvalue02  = bl_getICOYIVHD_CHK02(house_code, inv_no);

	            Logger.debug.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
	            Logger.debug.println("rtnvalue02");
	            Logger.debug.println(rtnvalue02);
				Logger.debug.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
				
	            if (!rtnvalue02.equals("E1") & !rtnvalue02.equals("RE")){
	            	setFlag(false);
	                setStatus(0);
	                setMessage("검수취소가 불가합니다.");
	                return getSepoaOut();
	            }
	            
	            String rtnvalue02_1 = bl_getICOYECHD_FLAG(house_code, inv_no);

	            Logger.debug.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
	            Logger.debug.println("rtnvalue02_1");
	            Logger.debug.println(rtnvalue02_1);
				Logger.debug.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");


				if (!rtnvalue02_1.equals("0")){
	            	setFlag(false);
	            	setStatus(0);
	                setMessage("해당 검수완료건은 공사평가완료 되어 검수취소 불가상태입니다.\r\n공사평가 삭제후 진행주세요. ");
	                return getSepoaOut();
	            }
	            
	            //String rtnIVDT = bl_getICOYIVDT_STATUS(house_code, inv_no, inv_seq);

	            //if (rtnIVDT.equals("D")){
	            //	setFlag(false);
	            //	setStatus(0);
	            //    setMessage("검수취소가 불가합니다(DT).");
	            //    return getSepoaOut();
	            //}

	            String rtnvalue03 = bl_getICOYPRDT_FLAG(house_code, inv_no);

	            Logger.debug.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
	            Logger.debug.println("rtnvalue03");
	            Logger.debug.println(rtnvalue03);
				Logger.debug.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");


				if (!rtnvalue03.equals("0")){
	            	setFlag(false);
	            	setStatus(0);
	                setMessage("해당 검수완료건은 검수취소 불가상태입니다.");
	                return getSepoaOut();
	            }

	            String rtnvalue04 = bl_getICOYIVDT_CNT(house_code, inv_no);

				Logger.debug.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
				Logger.debug.println("rtnvalue04");
				Logger.debug.println(rtnvalue04);
				Logger.debug.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");

				if(rtnvalue04.equals("1")){
					int rtn1 = in_tly_cancel01(inv_no);
					int rtn2 = in_tly_cancel02(inv_no);

					if(rtn1==0 || rtn2==0) {
						Rollback();
		            	setFlag(false);
						setStatus(0);
			            setMessage(msg.getMessage("9003"));

			            return getSepoaOut();
					}
				}				

				int rtn3 = in_tly_cancel03(inv_no);
				int rtn4 = in_tly_cancel04(inv_no);
				int rtn5 = in_tly_cancel05(inv_no);
				int rtn6 = in_tly_cancel06(inv_no);
				int rtn7 = in_tly_cancel07(inv_no);
				int rtn8 = delPBHD(inv_no);

				if(rtn3==0 || rtn4==0 || rtn5==0 || rtn6==0 || rtn7==0 || rtn8 < 0) {
					Rollback();
	            	setFlag(false);
					setStatus(0);
		            setMessage(msg.getMessage("9003"));

		            return getSepoaOut();
				}
				
            	setFlag(true);
				setMessage("검수 취소처리가 완료 되었습니다.");

				Commit();
				setStatus(1);
				setValue("");
			}catch (Exception e){
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
	
//	private int delPBHD2(ConnectionContext ctx, String invNo, String invSeq, String itemNo, String grQty)throws Exception {
//		int rtn = 0;
//		String user_id = info.getSession("ID");
//		try {
//			Map<String, String> data = new HashMap<String, String>();
//			data.put("inv_no", invNo);
//			data.put("inv_seq", invSeq);
//			data.put("item_no", itemNo);
//			data.put("gr_qty", grQty);
//			//부점의 소유품목 유무조회
//			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
//			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
//			SepoaFormater wf1 = new SepoaFormater(sm.doSelect(data));
//				
//			int i_cnt = Integer.parseInt(wf1.getValue("CNT", 0));
//			
//			if( i_cnt ==  0 ){			
//				// 소유품목으로 인식
//				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
//				sm = new SepoaSQLManager(user_id, this, ctx, wxp);
//				sm.doUpdate(data);
//				rtn++;
//			}
//			else{
//				// 소유품목 갱신
//				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
//				sm = new SepoaSQLManager(user_id, this, ctx, wxp);
//				sm.doUpdate(data);
//				rtn++;
//			}
//			
//		} catch (Exception e) {
//			throw new Exception("setPBHD : " + e.getMessage());
//		} finally {
//		}		
//		
//		return rtn;
//	}

	
	private int delPBHD(String invNo) throws Exception
    {
        int rtn = 0;
        ConnectionContext ctx = getConnectionContext();

        SepoaSQLManager sm = null;
        SepoaFormater wf = null;
        SepoaFormater wf2 = null;
        Map<String, String> data = null;
        
        
        String user_id    = info.getSession("ID");
        String house_code = info.getSession("HOUSE_CODE");

        try {
        	
        	data = new HashMap<String, String>();
			data.put("house_code", house_code);
			data.put("inv_no", invNo);
			
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
            sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp);
            String rtnSql = sm.doSelect(data);
            wf = new SepoaFormater(rtnSql);

            for( int i = 0 ; i < wf.getRowCount(); i++ )
            {
            	//INV_NO,INV_SEQ,ITEM_NO,GR_QTY,PO_NO,PO_SEQ
            	
                String inv_no = wf.getValue(i, 0);
                String inv_seq = wf.getValue( i,1 );
                String gr_qty = wf.getValue( i,2);
                String item_no = wf.getValue( i,3 );
                String material_ctrl_type = wf.getValue( i,4 );
                
                // 안내장,e-홍보물 인경우만
                if("03091".equals(material_ctrl_type) || "03092".equals(material_ctrl_type)){
                	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
                	data.put("inv_seq", inv_seq);
                	data.put("item_no", item_no);
        			
                    sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp);
                    String rtnSql2 = sm.doSelect(data);
                    wf2 = new SepoaFormater(rtnSql2);
                    
                    if(wf2.getRowCount() > 0){
                    	String dept = wf2.getValue(0, 0);
                        String stk_qty = wf2.getValue(0,1 );
                        
                        //검수취소수량과 홍보물현황의 보유수량이 같다면
                        if(gr_qty.equals(stk_qty)){
                        	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
                        	data.put("dept_cd", dept);
                        	
                            sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp);
                            rtn = sm.doDelete(data);
                            if(rtn < 0){
                            	throw new Exception("검수취소중 에러발생");
                            }
                        }else{
                        	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_4");
                        	data.put("dept_cd", dept);
                        	data.put("gr_qty", gr_qty);
                        	                                                 
                            sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp);
                            rtn = sm.doUpdate(data);
                            if(rtn < 0){
                            	throw new Exception("검수취소중 에러발생");
                            }
                        }
                        
                    }
                    
                  
                	
                }                
            }

        }catch(Exception e) {
            throw new Exception("delPBHD:"+e.getMessage());
        }
        finally{
        }
        return rtn;
    }//delPBHD end
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	private String bl_getICOYIVHD_CHK01(String house_code, String inv_no) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args      = { house_code, inv_no };
			SepoaFormater wf   = new SepoaFormater(sm.doSelect(args));
			rtn = wf.getValue(0,0);
		} catch (Exception e) {
			throw new Exception("bl_getICOYIVHD_CHK01:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	private String bl_getICOYIVHD_CHK02(String house_code, String inv_no) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args      = { house_code, inv_no };
			SepoaFormater wf   = new SepoaFormater(sm.doSelect(args));
			rtn = wf.getValue(0,0);
		} catch (Exception e) {
			throw new Exception("bl_getICOYIVHD_CHK02:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
/*	
	private String bl_getICOYIVDT_STATUS(String house_code, String inv_no, String inv_inq) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args = { house_code, inv_no, inv_inq };
			SepoaFormater wf   = new SepoaFormater(sm.doSelect(args));
			rtn = wf.getValue(0,0);
		} catch (Exception e) {
			throw new Exception("bl_getICOYIVDT_STATUS:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
*/
	private String bl_getICOYPRDT_FLAG(String house_code, String inv_no) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args = { house_code, house_code, inv_no, house_code, house_code, inv_no };
			SepoaFormater wf   = new SepoaFormater(sm.doSelect(args));
			rtn = wf.getValue(0,0);
		} catch (Exception e) {
			throw new Exception("bl_getICOYPRDT_FLAG:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	private String bl_getICOYECHD_FLAG(String house_code, String inv_no) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args = { house_code, inv_no };
			SepoaFormater wf   = new SepoaFormater(sm.doSelect(args));
			rtn = wf.getValue(0,0);
		} catch (Exception e) {
			throw new Exception("bl_getICOYECHD_FLAG:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	private String bl_getICOYIVDT_CNT(String house_code, String inv_no) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args = { house_code, inv_no };
			SepoaFormater wf   = new SepoaFormater(sm.doSelect(args));
			rtn = wf.getValue(0,0);
		} catch (Exception e) {
			throw new Exception("bl_getICOYIVDT_CNT:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	private int in_tly_cancel01(String inv_no) throws Exception  {
		int rtn1 = -1;
		ConnectionContext ctx1 = getConnectionContext();
		try {
				SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp1.addVar("house_code" , info.getSession("HOUSE_CODE"));
				wxp1.addVar("inv_no"	 , inv_no);
				SepoaSQLManager sm1 = new SepoaSQLManager(info.getSession("ID"),this,ctx1,wxp1.getQuery());

				rtn1 = sm1.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_tly_cancel01:"+e.getMessage());
		} 
		finally{
		}
		return rtn1;
 	}

	private int in_tly_cancel02(String inv_no) throws Exception  {
		int rtn1 = -1;
		ConnectionContext ctx1 = getConnectionContext();
		try {
				SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp1.addVar("house_code" , info.getSession("HOUSE_CODE"));
				wxp1.addVar("inv_no"	 , inv_no);
				SepoaSQLManager sm1 = new SepoaSQLManager(info.getSession("ID"),this,ctx1,wxp1.getQuery());

				rtn1 = sm1.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_tly_cancel02:"+e.getMessage());
		} 
		finally{
		}
		return rtn1;
 	}

	private int in_tly_cancel03(String inv_no) throws Exception  {
		int rtn1 = -1;
		ConnectionContext ctx1 = getConnectionContext();
		try {
				SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp1.addVar("house_code" , info.getSession("HOUSE_CODE"));
				wxp1.addVar("inv_no"	 , inv_no);
				SepoaSQLManager sm1 = new SepoaSQLManager(info.getSession("ID"),this,ctx1,wxp1.getQuery());

				rtn1 = sm1.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_tly_cancel03:"+e.getMessage());
		} 
		finally{
		}
		return rtn1;
 	}
	
	private int in_tly_cancel04(String inv_no) throws Exception  {
		int rtn1 = -1;
		ConnectionContext ctx1 = getConnectionContext();
		try {
				SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp1.addVar("house_code" , info.getSession("HOUSE_CODE"));
				wxp1.addVar("inv_no"	 , inv_no);
				SepoaSQLManager sm1 = new SepoaSQLManager(info.getSession("ID"),this,ctx1,wxp1.getQuery());

				rtn1 = sm1.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_tly_cancel04:"+e.getMessage());
		} 
		finally{
		}
		return rtn1;
 	}
	
	private int in_tly_cancel05(String inv_no) throws Exception  {
		int rtn1 = -1;
		ConnectionContext ctx1 = getConnectionContext();
		try {
				SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp1.addVar("house_code" , info.getSession("HOUSE_CODE"));
				wxp1.addVar("inv_no"	 , inv_no);
				SepoaSQLManager sm1 = new SepoaSQLManager(info.getSession("ID"),this,ctx1,wxp1.getQuery());

				rtn1 = sm1.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_tly_cancel05:"+e.getMessage());
		} 
		finally{
		}
		return rtn1;
 	}

	private int in_tly_cancel06(String inv_no) throws Exception  {
		int rtn1 = -1;
		ConnectionContext ctx1 = getConnectionContext();
		try {
				SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp1.addVar("house_code" , info.getSession("HOUSE_CODE"));
				wxp1.addVar("inv_no"	 , inv_no);
				SepoaSQLManager sm1 = new SepoaSQLManager(info.getSession("ID"),this,ctx1,wxp1.getQuery());

				rtn1 = sm1.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_tly_cancel06:"+e.getMessage());
		} 
		finally{
		}
		return rtn1;
 	}

	private int in_tly_cancel07(String inv_no) throws Exception  {
		int rtn1 = -1;
		ConnectionContext ctx1 = getConnectionContext();
		try {
				SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp1.addVar("house_code" , info.getSession("HOUSE_CODE"));
				wxp1.addVar("inv_no"	 , inv_no);
				SepoaSQLManager sm1 = new SepoaSQLManager(info.getSession("ID"),this,ctx1,wxp1.getQuery());

				rtn1 = sm1.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_tly_cancel07:"+e.getMessage());
		} 
		finally{
		}
		return rtn1;
 	}
} // END