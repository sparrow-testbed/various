package dt.pr;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import wisecommon.SignRequestInfo;
import wisecommon.SignResponseInfo;

/*****************************************************************************************

 사용메소드 정리
 ==========================================================================================
 JSP                   SERVLET            프로그램설명        메소드             기능
 ==========================================================================================
 pr/pr1_bd_dis1.jsp    pr1_bd_lis1        청구상세조회(상세)  prDTQueryDisplay   조회
 pr/pr1_bd_dis1.jsp    pr1_bd_lis1        청구상세조회(헤더)  prHDQueryDisplay   조회
 pr/pr3_bd_lis1.jsp    pr3_bd_lis1        구매검토목록        prReqList          조회
 pr/pr3_bd_ins1.jsp    pr3_bd_lis1        배분수량발주        DiviSionList       조회
 pr/pr3_bd_lis1.jsp    pr3_bd_lis1        구매검토목록        charge_transfer    이관
 pr/pr3_bd_lis1.jsp    pr3_bd_lis1        구매검토목록        reject             반송
 pr/pr3_bd_lis1.jsp    pr3_bd_lis1        구매검토목록        taxCodeId          TAX_CODE_ID 수정
 pr/pr3_bd_lis1.jsp    pr3_bd_lis1        구매검토목록        setPrRdDate        자재소요일 수정
 ==========================================================================================

 ******************************************************************************************/

/**
 * <code>
 * 청구관련 서비스
 * 
 * <pre>
 * (#)dt/pr/p1001.java  01/06/27
 * Copyright 2001-2002 ICOMPIA Co., Ltd. All Rights Reserved.
 * This software is the proprietary information of ICOMPIA Co., Ltd.
 * 
 * @version 1.0
 * @author 김태영
 * 
 *         사용함수 리스트
 * 
 *         [ prDTQueryDisplay ].......................청구상세보기 DT [
 *         prHDQueryDisplay ].......................청구상세보기 HD
 * 
 *         [ getAccountList ].......................Requirement > 청구관리 > 청구 >
 *         청구생성 ==> 계정번호 [ getplantcode ].......................Requirement >
 *         청구관리 > 청구 > 청구생성 ==> 공장/창고코드(Plant Code가져오기) [ getstrcode
 *         ].......................Requirement > 청구관리 > 청구 > 청구생성 ==>
 *         공장/창고코드(창고코드조회) [ setPrCreate_req ].......................Requirement
 *         > 청구관리 > 청구 > 청구생성(Request) ==> 저장 [ getExchamt
 *         ].......................Requirement > 청구관리 > 청구 > 청구생성 ==> 환율가져오기
 * 
 *         [ controlRegList ].......................Requirement > 청구관리 > 청구통제 >
 *         통제요청목록 => 조회 [ setControl ]...........................Requirement >
 *         청구관리 > 청구통제 > 통제요청목록 ==> 승인/반송 [ controlQueryList
 *         ]....................Requirement > 청구관리 > 청구통제 > 통제결과목록 ==> 조회
 * 
 *         [ prQueryList ]..........................Requirement > 청구관리 > 청구 >
 *         청구현황 ==> 조회
 * 
 *         [ charge_transfer ]......................Dynamic Trading > 구매관리 >
 *         구매접수 > 구매검토목록 => 이관 [ getPriceHistory ]......................Dynamic
 *         Trading > 구매관리 > 구매접수 > 구매검토목록 ==> 종가 / 품번별 가격이력 (단가정보) [ prReqList
 *         ]............................Dynamic Trading > 구매관리 > 구매접수 > 구매검토목록
 *         ==> 조회 [ reject ].................................Dynamic Trading >
 *         구매관리 > 구매접수 > 구매검토목록 ==> 반송 [ setPoExport
 *         ]........................Dynamic Trading > 구매관리 > 구매접수 > 구매검토목록 ==>
 *         외자발주 [ getDeptName ].... ....................Requirement > 청구관리 > 청구
 *         > 청구생성 ==> 계정번호 ==> 부서명조회
 * 
 *         </code></pre>
 */
public class p1001 extends SepoaService {
	@SuppressWarnings("rawtypes")
	private HashMap msg;

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public p1001(String opt, SepoaInfo info) throws Exception {
		super(opt, info);
		setVersion("1.0.0");
		Vector multilang_id = new Vector();
		multilang_id.addElement("p10_pra");
		multilang_id.addElement("STDCOMM");
		multilang_id.addElement("STDPR");
		msg = MessageUtil.getMessage(info, multilang_id);
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

	public SepoaOut prQueryList(Map<String, String> header) {
		ConnectionContext ctx = null;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		String rtn = null;
		String cur = null;
		String houseCode = info.getSession("HOUSE_CODE");
		String companyCode = info.getSession("COMPANY_CODE");

		try {
			setStatus(1);
			setFlag(true);

			ctx = getConnectionContext();

			sxp = new SepoaXmlParser(this, "et_prQueryList");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);

			header.put("house_code", houseCode);
			header.put("company_code", companyCode);

			rtn = ssm.doSelect(header);

			setValue(rtn);
			setValue(cur);
			setMessage((String) msg.get("0000"));
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("p10_pra.0001").toString());
		}

		return getSepoaOut();
	}

	@SuppressWarnings("unused")
	public SepoaOut prHDQueryDisplay(String[] args) {
		try {
			String lang = info.getSession("LANGUAGE");
			String rtnHD = et_prQueryDisplayHD(args);

			setStatus(1);
			setValue(rtnHD);

			setMessage(msg.get("STDCOMM.0000").toString());
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setStatus(0);

			String lang = info.getSession("LANGUAGE");

			setMessage(msg.get("p10_pra.0001").toString());
		}

		return getSepoaOut();
	}

	@SuppressWarnings("deprecation")
	private String et_prQueryDisplayHD(String[] args) throws Exception {
		String rtn = null;

		try {
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			ConnectionContext ctx = getConnectionContext();

			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("user_id", user_id);

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx,
					wxp.getQuery());
			rtn = sm.doSelect(args);
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());

			throw new Exception(e.getMessage());
		}

		return rtn;
	}

	public SepoaOut prDTQueryDisplay(String pr_no) {
		try {
			String rtnDT = et_prQueryDisplayDT(pr_no);
			setStatus(1);
			setValue(rtnDT);
			setMessage(msg.get("p10_pra.0000").toString());
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("p10_pra.0001").toString());
		}

		return getSepoaOut();
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private String et_prQueryDisplayDT(String pr_no) throws Exception {
		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

		try {
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, wxp.getQuery());

			String[] args = { pr_no };

			rtn = sm.doSelect(args);

		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}

		return rtn;
	}

	// public SepoaOut prItemsList(String[] args)
	// {
	// try
	// {
	// String rtn = et_prItemsList(args);
	// setStatus(1);
	// setValue(rtn);
	//
	// setMessage(msg.get("p10_pra.0000").toString());
	//
	// }catch(Exception e) {
	// Logger.err.println(userid,this,e.getMessage());
	// setStatus(0);
	// setMessage(msg.get("p10_pra.0001").toString());
	// }
	// return getSepoaOut();
	// }

	public SepoaOut prItemsList(Map<String, String> args) {
		ConnectionContext ctx = null;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		String rtn = null;
		String id = info.getSession("ID");

		try {
			setStatus(1);
			setFlag(true);

			ctx = getConnectionContext();

			sxp = new SepoaXmlParser(this, "et_prItemsList");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);

			rtn = ssm.doSelect(args); // 조회

			setValue(rtn);
			setMessage((String) msg.get("0000"));
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage((String) msg.get("0001"));
		}

		return getSepoaOut();
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private String et_prItemsList(String[] args) throws Exception {
		String DBOwner = getConfig("Sepoa.generator.db.selfuser");

		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
		StringBuffer tSQL = new StringBuffer();
		String house_code = info.getSession("HOUSE_CODE");
		String dept = info.getSession("DEPARTMENT");

		try {
			SepoaSQLManager sm = new SepoaSQLManager(userid, this, ctx,
					wxp.getQuery());
			rtn = sm.doSelect(args);

		} catch (Exception e) {
			Logger.debug.println(userid, this, e.getMessage());
			Logger.debug.println(userid, this, tSQL.toString());
			throw new Exception(e.getMessage());
		}

		return rtn;
	}

	// public SepoaOut prProceedingList(String[] args )
	// {
	// try
	// {
	// String rtn = et_prProceedingList(args );
	// setStatus(1);
	// setValue(rtn);
	//
	// setMessage(msg.get("p10_pra.0000").toString());
	//
	// }catch(Exception e) {
	// Logger.err.println(userid,this,e.getMessage());
	// setStatus(0);
	// setMessage(msg.get("p10_pra.0001").toString());
	// }
	// return getSepoaOut();
	// }

	public SepoaOut prProceedingList(Map<String, String> header) {
		ConnectionContext ctx = null;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		String rtn = null;
		String id = info.getSession("ID");
		String houseCode = info.getSession("HOUSE_CODE");

		try {
			setStatus(1);
			setFlag(true);

			ctx = getConnectionContext();

			sxp = new SepoaXmlParser(this, "et_prProceedingList");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);

			header.put("house_code", houseCode);

			rtn = ssm.doSelect(header); // 조회

			setValue(rtn);
			setMessage((String) msg.get("0000"));
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage((String) msg.get("0001"));
		}

		return getSepoaOut();
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private String et_prProceedingList(String[] args) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		StringBuffer tSQL = new StringBuffer();
		String house_code = info.getSession("HOUSE_CODE");
		String dept = info.getSession("DEPARTMENT");
		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

		try {
			SepoaSQLManager sm = new SepoaSQLManager(userid, this, ctx,
					wxp.getQuery());

			rtn = sm.doSelect(args);

		} catch (Exception e) {
			Logger.debug.println(userid, this, e.getMessage());
			Logger.debug.println(userid, this, tSQL.toString());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	// public SepoaOut prDTQueryDisplay_Change(String[] args)
	// {
	// try
	// {
	// String lang = info.getSession("LANGUAGE");
	//
	// String rtnDT = et_prQueryDisplayDT_Change(args);
	// setStatus(1);
	// setValue(rtnDT);
	// setMessage(msg.get("STDCOMM.0000").toString());
	// }
	// catch(Exception e)
	// {
	// Logger.err.println(info.getSession("ID"),this,e.getMessage());
	// setStatus(0);
	//
	// String lang = info.getSession("LANGUAGE");
	//
	// setMessage(msg.get("p10_pra.0001").toString());
	// }
	//
	// return getSepoaOut();
	// }//End of prDTQueryDisplay_Change()

	public SepoaOut prDTQueryDisplay_Change(Map<String, Object> param)
			throws Exception {
		ConnectionContext ctx = null;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		String rtn = null;
		String id = info.getSession("ID");
		String houseCode = info.getSession("HOUSE_CODE");
		String companyCode = info.getSession("COMPANY_CODE");
		String prNo = (String) param.get("prNo");
		String prProceedingFlag = (String) param.get("prProceedingFlag");
		Map<String, String> sqlParam = new HashMap<String, String>();

		try {
			setStatus(1);
			setFlag(true);

			ctx = getConnectionContext();

			sxp = new SepoaXmlParser(this, "et_prQueryDisplayDT_Change");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);

			sqlParam.put("HOUSE_CODE", houseCode);
//			sqlParam.put("COMPANY_CODE", companyCode);
			sqlParam.put("PR_NO", prNo);
			sqlParam.put("PR_PROCEEDING_FLAG", prProceedingFlag);

			rtn = ssm.doSelect(sqlParam); // 조회

			setValue(rtn);
			setMessage((String) msg.get("0000"));
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage((String) msg.get("0001"));
		}

		return getSepoaOut();
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private String et_prQueryDisplayDT_Change(String[] args) throws Exception {
		String rtn = null;
		String user_id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");

		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("company_code", company_code);

		try {
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx,
					wxp.getQuery());
			rtn = sm.doSelect(args);
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}

		return rtn;
	}

	@SuppressWarnings("unused")
	public SepoaOut prDTQueryDisplay_Create(String[] args) {
		try {
			String lang = info.getSession("LANGUAGE");

			String rtnDT = et_prQueryDisplayDT_Create(args);
			setStatus(1);
			setValue(rtnDT);
			setMessage(msg.get("STDCOMM.0000").toString());
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setStatus(0);

			String lang = info.getSession("LANGUAGE");

			setMessage(msg.get("p10_pra.0001").toString());
		}

		return getSepoaOut();
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private String et_prQueryDisplayDT_Create(String[] args) throws Exception {
		String rtn = null;
		String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");

		String user_id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		String rd_date = SepoaDate.addSepoaDateDay(
				SepoaDate.getShortDateString(), 7);

		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("rd_date", rd_date);
		wxp.addVar("house_code", house_code);
		wxp.addVar("company_code", company_code);

		// tSQL.append(" SELECT                                                        					\n");
		// tSQL.append("   D.ITEM_NO                                                   					\n");
		// tSQL.append(" , D.DESCRIPTION_LOC                                           					\n");
		// tSQL.append(" , D.SPECIFICATION                                           						\n");
		// tSQL.append(" , D.MAKER_NAME                                           							\n");
		// tSQL.append(" , D.MAKER_CODE                                           							\n");
		// tSQL.append(" , D.UNIT_MEASURE                                              					\n");
		// tSQL.append(" , D.PR_QTY                                                    					\n");
		// tSQL.append(" , D.CUR                                                       					\n");
		// tSQL.append(" , D.UNIT_PRICE                                                					\n");
		// tSQL.append(" , D.EXCHANGE_RATE                                             					\n");
		// tSQL.append(" , CAST(ROUND(QTDT.ITEM_AMT,1) AS DEC(22,0) ) AS PR_AMT                                                    		\n");
		// tSQL.append(" , CAST(ROUND(QTDT.ITEM_AMT,1) AS DEC(22,0) ) AS PR_KRW_AMT                                                		\n");
		// tSQL.append(" , '"+rd_date+"' AS RD_DATE                                          \n");
		// tSQL.append(" , ISNULL(D.ATTACH_NO, 'N') AS ATTACH_NO                     					\n");
		// tSQL.append(" , DBO.GETFILEATTCOUNT(D.ATTACH_NO) AS ATT_COUNT                   					\n");
		// tSQL.append(" , QTDT.VENDOR_CODE  AS REC_VENDOR_CODE                                           	\n");
		// tSQL.append(" , DBO.getCompanyNameLoc(QTDT.HOUSE_CODE, QTDT.VENDOR_CODE, 'S') AS REC_VENDOR_NAME	\n");
		// tSQL.append(" , D.DELY_TO_LOCATION                                          					\n");
		// tSQL.append(" , D.DELY_TO_ADDRESS                                           					\n");
		// tSQL.append(" , D.REMARK        		                                    					\n");
		// tSQL.append(" , D.PURCHASE_LOCATION                                         					\n");
		// tSQL.append(" , D.PURCHASER_ID                                              					\n");
		// tSQL.append(" , D.PURCHASER_NAME                                            					\n");
		// tSQL.append(" , D.PURCHASE_DEPT_NAME                                        					\n");
		// tSQL.append(" , D.PURCHASE_DEPT                                             					\n");
		// tSQL.append(" , D.PR_NO                                                     					\n");
		// tSQL.append(" , D.PR_SEQ                                                    					\n");
		// tSQL.append(" , D.TECHNIQUE_GRADE                                  								\n");
		// tSQL.append(" , D.TECHNIQUE_FLAG  	                                  							\n");
		// tSQL.append(" , D.TECHNIQUE_TYPE  	                                  							\n");
		// tSQL.append(" , D.INPUT_FROM_DATE  	                                  							\n");
		// tSQL.append(" , D.INPUT_TO_DATE  	                                  							\n");
		// tSQL.append(" , H.PR_TYPE  	                                  									\n");
		//
		// tSQL.append(" , D.WBS_NO  	                                  									\n");
		// tSQL.append(" , D.WBS_SUB_NO  	                                  								\n");
		// tSQL.append(" , D.WBS_TXT  	                                  									\n");
		// tSQL.append(" , D.ORDER_SEQ  	                                  								\n");
		// tSQL.append(" , MTGL.ITEM_GROUP  	                                  							\n");
		// tSQL.append(" , DBO.GETINFOITEMCOUNT(D.HOUSE_CODE, D.ITEM_NO) AS ITEM_FLAG  	                \n");
		//
		// tSQL.append(" FROM ICOYPRHD H  ,  ICOYPRDT D , ICOYRQDT RQDT , ICOYQTDT QTDT , ICOYRQHD RQHD, ICOMMTGL MTGL	\n");
		// tSQL.append(" WHERE H.HOUSE_CODE = '"+house_code+"'                         					\n");
		// tSQL.append(" AND H.COMPANY_CODE = '"+company_code+"'                       					\n");
		// tSQL.append(" <OPT=F,S> AND H.PR_NO = ? </OPT>                              					\n");
		// tSQL.append(" AND H.HOUSE_CODE = D.HOUSE_CODE                        							\n");
		// tSQL.append(" AND H.PR_NO = D.PR_NO                       										\n");
		// tSQL.append(" AND D.PR_PROCEEDING_FLAG IN ( 'C'	, 'E' )											\n");
		// tSQL.append(" AND D.HOUSE_CODE = RQDT.HOUSE_CODE												\n");
		// tSQL.append(" AND D.PR_NO = RQDT.PR_NO															\n");
		// tSQL.append(" AND D.PR_SEQ = RQDT.PR_SEQ														\n");
		// tSQL.append(" AND D.ITEM_NO = RQDT.ITEM_NO														\n");
		// tSQL.append(" AND RQDT.HOUSE_CODE = QTDT.HOUSE_CODE												\n");
		// tSQL.append(" AND RQDT.RFQ_NO = QTDT.RFQ_NO														\n");
		// tSQL.append(" AND RQDT.RFQ_COUNT = QTDT.RFQ_COUNT												\n");
		// tSQL.append(" AND RQDT.RFQ_SEQ = QTDT.RFQ_SEQ													\n");
		// tSQL.append(" AND RQDT.ITEM_NO = QTDT.ITEM_NO													\n");
		// tSQL.append(" AND QTDT.HOUSE_CODE = RQHD.HOUSE_CODE												\n");
		// tSQL.append(" AND QTDT.RFQ_NO = RQHD.RFQ_NO														\n");
		// tSQL.append(" AND QTDT.RFQ_COUNT = RQHD.RFQ_COUNT												\n");
		// tSQL.append(" AND QTDT.SETTLE_FLAG = 'Y'                              							\n");
		// tSQL.append(" AND H.STATUS != 'D'                      											\n");
		// tSQL.append(" AND D.STATUS != 'D'                       										\n");
		// tSQL.append(" AND RQDT.STATUS != 'D'															\n");
		// tSQL.append(" AND QTDT.STATUS != 'D'															\n");
		// tSQL.append(" AND RQHD.STATUS != 'D'															\n");
		// tSQL.append(" AND D.ITEM_NO = MTGL.ITEM_NO														\n");

		try {
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx,
					wxp.getQuery());
			rtn = sm.doSelect(args);
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}// End of et_prQueryDisplayDT_Create()

	public SepoaOut getQuery_PRNO2(String[] args) {
		try {
			String rtn = et_getQuery_PRNO2(args);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.get("p10_pra.0000").toString());
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("p10_pra.0001").toString());
		}

		return getSepoaOut();
	}

	@SuppressWarnings("deprecation")
	private String et_getQuery_PRNO2(String[] args) throws Exception {
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		String rtn = null;
		String cur_date_time = SepoaDate.getShortDateString()
				+ SepoaDate.getShortTimeString().substring(0, 4);

		String pr_no = args[0];

		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("cur_date_time", cur_date_time);
		wxp.addVar("user_id", user_id);
		wxp.addVar("pr_no", pr_no);
		/*
		 * StringBuffer sql = new StringBuffer(); sql.append(
		 * " SELECT                                                                                 	\n"
		 * ); sql.append(
		 * "          D.PR_NO                                                              				\n"
		 * ); sql.append(
		 * "          ,MAX(H.SUBJECT)  AS SUBJECT  , MAX(PH.PR_TYPE) AS PR_TYPE               			\n"
		 * ); sql.append(
		 * "		  ,MAX(H.BID_RFQ_TYPE ) AS BID_RFQ_TYPE                                            	\n"
		 * ); sql.append(
		 * "		  ,MAX(PH.SALES_TYPE ) AS BID_SALES_TYPE                                            \n"
		 * ); sql.append(
		 * "		  ,MAX(PH.BSART ) AS BID_BSART                                            			\n"
		 * ); sql.append(
		 * "		  ,MAX(PH.ORDER_NO ) AS BID_ORDER_NO                                            	\n"
		 * ); sql.append(
		 * "   FROM    ICOYRQHD H , ICOYRQDT D,  ICOYQTDT T, ICOYPRDT P  , ICOYPRHD PH                  \n"
		 * ); sql.append("   WHERE   H.HOUSE_CODE    = '"+house_code+
		 * "'                                  				\n");
		 * sql.append("   AND CAST('"+cur_date_time+
		 * "' AS NUMERIC) >= CAST(H.RFQ_CLOSE_DATE + H.RFQ_CLOSE_TIME AS NUMERIC) \n"
		 * ); sql.append(
		 * "   AND H.HOUSE_CODE = D.HOUSE_CODE                                                     		\n"
		 * ); sql.append(
		 * "   AND H.RFQ_NO = D.RFQ_NO                                                             		\n"
		 * ); sql.append(
		 * "   AND H.RFQ_COUNT = D.RFQ_COUNT                                                       		\n"
		 * ); sql.append(
		 * "   AND D.HOUSE_CODE = T.HOUSE_CODE                                                     		\n"
		 * ); sql.append(
		 * "   AND D.RFQ_NO = T.RFQ_NO                                                             		\n"
		 * ); sql.append(
		 * "   AND D.RFQ_COUNT = T.RFQ_COUNT                                                       		\n"
		 * ); sql.append(
		 * "   AND D.RFQ_SEQ = T.RFQ_SEQ                                                           		\n"
		 * ); sql.append(
		 * "   AND D.HOUSE_CODE = P.HOUSE_CODE                                                     		\n"
		 * ); sql.append(
		 * "   AND D.PR_NO = P.PR_NO                                                               		\n"
		 * ); sql.append(
		 * "   AND D.PR_SEQ = P.PR_SEQ                                                             		\n"
		 * ); sql.append(
		 * "   AND D.HOUSE_CODE = PH.HOUSE_CODE                                                     	\n"
		 * ); sql.append(
		 * "   AND D.PR_NO = PH.PR_NO                                                               	\n"
		 * ); sql.append("   AND PH.ADD_USER_ID = '"+user_id+
		 * "'                                         \n"); sql.append(
		 * "   AND PH.REQ_TYPE = 'B'                                                                	\n"
		 * ); sql.append(
		 * "   AND T.SETTLE_FLAG = 'Y'                                                                	\n"
		 * ); sql.append(
		 * "   AND H.STATUS != 'D'                                                                 		\n"
		 * ); sql.append(
		 * "   AND H.STATUS != 'D'                                                                 		\n"
		 * ); sql.append(
		 * "   AND D.STATUS != 'D'                                                                 		\n"
		 * ); sql.append(
		 * "   AND T.STATUS != 'D'                                                                 		\n"
		 * ); sql.append(
		 * "   AND P.STATUS != 'D'                                                                 		\n"
		 * ); sql.append("   AND D.PR_NO = '"+pr_no+"'																\n");
		 * sql.append(
		 * "   GROUP BY     D.PR_NO                                                                		\n"
		 * ); sql.append(
		 * "   ORDER BY     MAX(H.ADD_DATE)                                                         	\n"
		 * );
		 */
		try {
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, wxp.getQuery());
			rtn = sm.doSelect((String[]) null);
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	@SuppressWarnings("unused")
	public SepoaOut getBidPrNoByPRDT(String[] args) {
		try {
			String lang = info.getSession("LANGUAGE");

			String rtnDT = et_getBidPrNoByPRDT(args);
			setStatus(1);
			setValue(rtnDT);
			setMessage(msg.get("STDCOMM.0000").toString());
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setStatus(0);

			String lang = info.getSession("LANGUAGE");

			setMessage(msg.get("p10_pra.0001").toString());
		}

		return getSepoaOut();
	}// End of prDTQueryDisplay_Change()

	@SuppressWarnings({ "unused", "deprecation" })
	private String et_getBidPrNoByPRDT(String[] args) throws Exception {

		String rtn = null;
		String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");

		String user_id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");

		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("company_code", company_code);
		// tSQL.append(" SELECT  																			\n");
		// tSQL.append(" 	QTPF.HUMAN_NO AS ITEM_NO                                                      	\n");
		// tSQL.append(" 	 , QTPF.NAME_LOC AS DESCRIPTION_LOC                                           	\n");
		// tSQL.append(" 	 , PRDT.SPECIFICATION                                                         	\n");
		// tSQL.append(" 	 , PRDT.MAKER_NAME                                                          	\n");
		// tSQL.append(" 	 , PRDT.MAKER_CODE                                                          	\n");
		// tSQL.append(" 	 , PRDT.UNIT_MEASURE                                                          	\n");
		// tSQL.append(" 	 , PRDT.PR_QTY                                                                	\n");
		// tSQL.append(" 	 , PRDT.CUR                                                                   	\n");
		// tSQL.append(" 	 , QTPF.UNIT_PRICE                                                            	\n");
		// tSQL.append(" 	 , PRDT.EXCHANGE_RATE                                                         	\n");
		// tSQL.append(" 	 , CAST(ROUND(convert(numeric(22,5),convert(float,(PRDT.PR_QTY * QTPF.UNIT_PRICE ))),1) AS DEC(22,0) ) AS PR_AMT                                 	\n");
		// tSQL.append(" 	 , CAST(ROUND(convert(numeric(22,5),convert(float,(PRDT.PR_QTY * QTPF.UNIT_PRICE ))),1) AS DEC(22,0) ) AS PR_KRW_AMT                             	\n");
		// tSQL.append(" 	 , PRDT.RD_DATE                                                               	\n");
		// tSQL.append(" 	 , dbo.CNV_NULL(PRDT.ATTACH_NO, 'N') AS ATTACH_NO                                 	\n");
		// tSQL.append(" 	 , dbo.GETFILEATTCOUNT(PRDT.ATTACH_NO) AS ATT_COUNT                               	\n");
		// tSQL.append(" 	 , QTPF.VENDOR_CODE AS REC_VENDOR_CODE                                        	\n");
		// tSQL.append(" 	 , dbo.getCompanyNameLoc(QTDT.HOUSE_CODE, QTPF.VENDOR_CODE, 'S') AS REC_VENDOR_NAME	\n");
		// tSQL.append(" 	 , PRDT.DELY_TO_LOCATION                                                      	\n");
		// tSQL.append(" 	 , PRDT.DELY_TO_ADDRESS                                                       	\n");
		// tSQL.append(" 	 , PRDT.REMARK                                                                	\n");
		// tSQL.append(" 	 , PRDT.PURCHASE_LOCATION                                                     	\n");
		// tSQL.append(" 	 , PRDT.PURCHASER_ID                                                          	\n");
		// tSQL.append(" 	 , PRDT.PURCHASER_NAME                                                        	\n");
		// tSQL.append(" 	 , PRDT.PURCHASE_DEPT_NAME                                                    	\n");
		// tSQL.append(" 	 , PRDT.PURCHASE_DEPT                                                         	\n");
		// tSQL.append(" 	 , PRDT.PR_NO                                                                 	\n");
		// tSQL.append(" 	 , PRDT.PR_SEQ                                                                	\n");
		// tSQL.append(" 	 , (SELECT ASSOCIATION_GRADE FROM ICOMHUMT WHERE HOUSE_CODE = '"+house_code+"' AND VENDOR_CODE = QTPF.VENDOR_CODE AND HUMAN_NO = QTPF.HUMAN_NO) AS TECHNIQUE_GRADE	\n");
		// tSQL.append(" 	 , PRDT.TECHNIQUE_FLAG                                                        	\n");
		// tSQL.append(" 	 , PRDT.TECHNIQUE_TYPE                                                        	\n");
		// tSQL.append(" 	 , PRDT.INPUT_FROM_DATE                                                       	\n");
		// tSQL.append(" 	 , PRDT.INPUT_TO_DATE                                                         	\n");
		// tSQL.append(" 	 , PRHD.PR_TYPE                                                               	\n");
		// tSQL.append(" 	 , PRDT.CTRL_CODE                                                         		\n");
		//
		// tSQL.append(" 	 , PRDT.WBS_NO                                                         			\n");
		// tSQL.append(" 	 , PRDT.WBS_SUB_NO                                                         		\n");
		// tSQL.append(" 	 , PRDT.WBS_TXT                                                         		\n");
		// tSQL.append(" 	 , PRDT.ORDER_SEQ                                                         		\n");
		//
		// tSQL.append(" FROM ICOYPRHD PRHD, ICOYPRDT PRDT, ICOYRQDT RQDT, ICOYRQSE RQSE, ICOYQTDT QTDT, ICOYQTPF QTPF            \n");
		// tSQL.append(" WHERE PRHD.HOUSE_CODE = '"+house_code+"'                         					\n");
		// tSQL.append(" AND PRHD.COMPANY_CODE = '"+company_code+"'                       					\n");
		// tSQL.append(" <OPT=F,S> AND PRHD.PR_NO = ? </OPT>                              					\n");
		// tSQL.append(" AND PRDT.HOUSE_CODE = PRHD.HOUSE_CODE												\n");
		// tSQL.append(" AND PRHD.PR_NO = PRDT.PR_NO                                       				\n");
		// tSQL.append(" AND PRDT.HOUSE_CODE = RQDT.HOUSE_CODE                             				\n");
		// tSQL.append(" AND PRDT.PR_NO = RQDT.PR_NO                                       				\n");
		// tSQL.append(" AND PRDT.PR_SEQ = RQDT.PR_SEQ                                     				\n");
		// tSQL.append(" AND RQDT.HOUSE_CODE = RQSE.HOUSE_CODE                             				\n");
		// tSQL.append(" AND RQDT.RFQ_NO = RQSE.RFQ_NO                                     				\n");
		// tSQL.append(" AND RQDT.RFQ_COUNT = RQSE.RFQ_COUNT                               				\n");
		// tSQL.append(" AND RQDT.RFQ_SEQ = RQSE.RFQ_SEQ                                   				\n");
		// tSQL.append(" AND RQSE.HOUSE_CODE = QTDT.HOUSE_CODE                             				\n");
		// tSQL.append(" AND RQSE.RFQ_NO = QTDT.RFQ_NO                                     				\n");
		// tSQL.append(" AND RQSE.RFQ_COUNT = QTDT.RFQ_COUNT                               				\n");
		// tSQL.append(" AND RQSE.RFQ_SEQ = QTDT.RFQ_SEQ                                   				\n");
		// tSQL.append(" AND RQSE.VENDOR_CODE = QTDT.VENDOR_CODE                           				\n");
		// tSQL.append(" AND QTDT.HOUSE_CODE = QTPF.HOUSE_CODE                             				\n");
		// tSQL.append(" AND QTDT.VENDOR_CODE = QTPF.VENDOR_CODE                           				\n");
		// tSQL.append(" AND QTDT.QTA_NO = QTPF.QTA_NO                                     				\n");
		// tSQL.append(" AND QTDT.QTA_SEQ = QTPF.QTA_SEQ                                   				\n");
		// tSQL.append(" AND QTDT.RFQ_NO = QTPF.RFQ_NO                                     				\n");
		// tSQL.append(" AND QTDT.RFQ_COUNT = QTPF.RFQ_COUNT                               				\n");
		// tSQL.append(" AND QTDT.RFQ_SEQ = QTPF.RFQ_SEQ                                   				\n");
		// //tSQL.append(" AND QTDT.SETTLE_FLAG = 'Y'                                      				\n");
		// tSQL.append(" AND PRHD.STATUS != 'D'                                            				\n");
		// tSQL.append(" AND PRDT.STATUS != 'D'                                            				\n");
		// tSQL.append(" AND RQDT.STATUS != 'D'                                            				\n");
		// tSQL.append(" AND RQSE.STATUS != 'D'                                            				\n");
		// tSQL.append(" AND QTDT.STATUS != 'D'                                            				\n");
		// tSQL.append(" AND QTPF.STATUS != 'D'                                            				\n");

		try {
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx,
					wxp.getQuery());
			rtn = sm.doSelect(args);
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}// End of et_prQueryDisplayDT_Change()

	@SuppressWarnings({ "unused", "unchecked" })
	public SepoaOut setPrCreate(String[][] data_hd, String[][] data_dt,
			String[][] info_dt, String pr_no, String sign_status,
			String account_code, String shipper_type, String cur,
			String pr_tot_amt, String approval_str) {
		String add_user_id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");
		String company = info.getSession("COMPANY_CODE");
		String add_user_dept = info.getSession("DEPARTMENT");
		String dept_name = info.getSession("DEPARTMENT_NAME_LOC");
		String name_eng = info.getSession("NAME_ENG");
		String name_loc = info.getSession("NAME_LOC");
		String lang = info.getSession("LANGUAGE");

		try {
			int hd_rtn = et_setPrHDCreate(data_hd);
			if (hd_rtn < 1)
				throw new Exception(msg.get("STDPR.0003").toString());
			int dt_rtn = et_setPrDTCreate(data_dt);
			if (dt_rtn < 1)
				throw new Exception(msg.get("STDPR.0003").toString());

			if (info_dt.length > 0) {
				int if_rtn = et_setInfoCreate(info_dt);
			}

			msg.put("PR_NO", pr_no);
			setMessage(msg.get("STDPR.0015").toString());

			if (sign_status.equals("P")) {
				SignRequestInfo sri = new SignRequestInfo();
				sri.setHouseCode(house_code);
				sri.setCompanyCode(company);
				sri.setDept(add_user_dept);
				sri.setReqUserId(add_user_id);
				sri.setDocType("PR");
				sri.setDocNo(pr_no);
				sri.setDocSeq("0");
				sri.setAccountCode(account_code);
				sri.setItemCount(data_dt.length);
				sri.setSignStatus(sign_status);
				sri.setShipperType(shipper_type);
				sri.setCur(cur);
				sri.setTotalAmt(Double.parseDouble(pr_tot_amt));

				sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
				int rtn = CreateApproval(info, sri); // 밑에 함수 실행
				if (rtn == 0) {
					try {
						Rollback();
					} catch (Exception d) {
						Logger.err.println(info.getSession("ID"), this,
								d.getMessage());
					}
					setStatus(0);
					setMessage(msg.get("STDPR.0030").toString());
					return getSepoaOut();
				}
				msg.put("PR_NO", pr_no);
				setMessage(msg.get("STDPR.0046").toString());
			}

			setStatus(1);
			setValue(pr_no);

			Commit();
		} catch (Exception e) {
			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}
			Logger.err.println(info.getSession("ID"), this, "XXXXXXXXXXXXXXXXX"
					+ e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDPR.0003").toString());
		}

		return getSepoaOut();
	}// End of setPrCreate()

	@SuppressWarnings({ "unused", "deprecation" })
	private int et_setPrDTCreate(String[][] data_dt) throws Exception {
		int rtn = 0;
		ConnectionContext ctx = getConnectionContext();

		String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");
		// String add_user_id = info.getSession("ID");

		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		// StringBuffer tSQL = new StringBuffer();
		// tSQL.append(" INSERT INTO ICOYPRDT                         	\n");
		// tSQL.append(" (                                            	\n");
		// tSQL.append(" 	 HOUSE_CODE                                	\n");
		// tSQL.append(" 	, PR_NO                                    	\n");
		// tSQL.append(" 	, PR_SEQ                                   	\n");
		// tSQL.append(" 	, STATUS                                   	\n");
		// tSQL.append(" 	, COMPANY_CODE                             	\n");
		// tSQL.append(" 	, PLANT_CODE                               	\n");
		// tSQL.append(" 	, ITEM_NO                                  	\n");
		// tSQL.append(" 	, SHIPPER_TYPE                             	\n");
		// tSQL.append(" 	, PR_PROCEEDING_FLAG                       	\n");
		// tSQL.append(" 	, CTRL_CODE                                	\n");
		// tSQL.append(" 	, UNIT_MEASURE                             	\n");
		// tSQL.append(" 	, PR_QTY                                   	\n");
		// tSQL.append(" 	, CUR                                      	\n");
		// tSQL.append(" 	, UNIT_PRICE                               	\n");
		// tSQL.append(" 	, PR_AMT                                   	\n");
		// tSQL.append(" 	, RD_DATE                                  	\n");
		// tSQL.append(" 	, ATTACH_NO                                	\n");
		// tSQL.append(" 	, REC_VENDOR_CODE                          	\n");
		// tSQL.append(" 	, DELY_TO_LOCATION                         	\n");
		// tSQL.append(" 	, REC_VENDOR_NAME                          	\n");
		// tSQL.append(" 	, DELY_TO_ADDRESS                          	\n");
		// tSQL.append(" 	, DESCRIPTION_LOC                          	\n");
		// tSQL.append(" 	, SPECIFICATION                          	\n");
		// tSQL.append(" 	, MAKER_NAME                          		\n");
		// tSQL.append(" 	, MAKER_CODE                          		\n");
		// tSQL.append(" 	, REMARK                                   	\n");
		// tSQL.append(" 	, SAMPLE_FLAG                              	\n");
		// tSQL.append(" 	, PR_KRW_AMT                               	\n");
		// tSQL.append(" 	, EXCHANGE_RATE                            	\n");
		// tSQL.append(" 	, TBE_FLAG                                 	\n");
		// tSQL.append(" 	, PURCHASE_LOCATION                         \n");
		// tSQL.append(" 	, PURCHASER_ID                              \n");
		// tSQL.append(" 	, PURCHASER_NAME                            \n");
		// tSQL.append(" 	, PURCHASE_DEPT                             \n");
		// tSQL.append(" 	, PURCHASE_DEPT_NAME                        \n");
		// tSQL.append(" 	, ADD_DATE                                 	\n");
		// tSQL.append(" 	, ADD_TIME                                 	\n");
		// tSQL.append(" 	, ADD_USER_ID                              	\n");
		// tSQL.append(" 	, CHANGE_DATE                               \n");
		// tSQL.append(" 	, CHANGE_TIME                               \n");
		// tSQL.append(" 	, CHANGE_USER_ID                            \n");
		// tSQL.append("   , TECHNIQUE_GRADE  	                        \n");
		// tSQL.append("   , TECHNIQUE_FLAG  	                        \n");
		// tSQL.append("   , TECHNIQUE_TYPE  	                        \n");
		// tSQL.append("   , INPUT_FROM_DATE                           \n");
		// tSQL.append("   , INPUT_TO_DATE  	                        \n");
		// /*추가항목(20081128)*/
		// tSQL.append("   , KNTTP  	                        		\n");
		// tSQL.append("   , ZEXKN  	                        		\n");
		// tSQL.append("   , ORDER_NO  	                        	\n");
		// tSQL.append("   , ORDER_SEQ  	                        	\n");
		// tSQL.append("   , WBS_NO  	                        		\n");
		// tSQL.append("   , WBS_SUB_NO  	                        	\n");
		// tSQL.append("   , WBS_TXT  	                        		\n");
		// tSQL.append("   , PRCRT  	                        		\n");
		// tSQL.append("   , KTEXT  	                        		\n");
		// /*****************/
		// tSQL.append(" ) VALUES (                                   	\n");
		// tSQL.append(" 	 ?		--HOUSE_CODE                            \n");
		// tSQL.append(" 	, ?		--PR_NO                                 \n");
		// tSQL.append("   , dbo.lpad(?, 5, '0')  --PR_SEQ         		\n");
		// tSQL.append(" 	, ? 	--STATUS                                \n");
		// tSQL.append(" 	, ? 	--COMPANY_CODE                          \n");
		// tSQL.append(" 	, ? 	--PLANT_CODE                            \n");
		// tSQL.append(" 	, ? 	--ITEM_NO                               \n");
		// tSQL.append(" 	, ? 	--SHIPPER_TYPE                          \n");
		// tSQL.append(" 	, ? 	--PR_PROCEEDING_FLAG                    \n");
		// tSQL.append(" 	, ? 	--CTRL_CODE                             \n");
		// tSQL.append(" 	, ? 	--UNIT_MEASURE                          \n");
		// tSQL.append(" 	, ISNULL(?,0) --PR_QTY             	\n");
		// tSQL.append(" 	, ? 	--CUR                                   \n");
		// tSQL.append(" 	, ISNULL(?,0) --UNIT_PRICE         	\n");
		// tSQL.append(" 	, ISNULL(?,0) --PR_AMT             	\n");
		// tSQL.append(" 	, ? 	--RD_DATE                               \n");
		// tSQL.append(" 	, ? 	--ATTACH_NO                             \n");
		// tSQL.append(" 	, ? 	--REC_VENDOR_CODE                       \n");
		// tSQL.append(" 	, ? 	--DELY_TO_LOCATION                      \n");
		// tSQL.append(" 	, ? 	--REC_VENDOR_NAME                       \n");
		// tSQL.append(" 	, ? 	--DELY_TO_ADDRESS                       \n");
		// tSQL.append(" 	, ? 	--DESCRIPTION_LOC                       \n");
		// tSQL.append(" 	, ?		--SPECIFICATION                         \n");
		// tSQL.append(" 	, ?		--MAKER_NAME                          	\n");
		// tSQL.append(" 	, ?		--MAKER_CODE                          	\n");
		// tSQL.append(" 	, ? 	--REMARK                                \n");
		// tSQL.append(" 	, 'N' 	--SAMPLE_FLAG                           \n");
		// tSQL.append(" 	, ISNULL(?,0) --PR_KRW_AMT         	\n");
		// tSQL.append(" 	, ISNULL(?,0) --EXCHANGE_RATE      	\n");
		// tSQL.append(" 	, 'N' 	--TBE_FLAG                              \n");
		// tSQL.append(" 	, ?		--PURCHASE_LOCATION                     \n");
		// tSQL.append(" 	, ?		--PURCHASER_ID                          \n");
		// tSQL.append(" 	, ?		--PURCHASER_NAME                        \n");
		// tSQL.append(" 	, ?		--PURCHASE_DEPT                         \n");
		// tSQL.append(" 	, ?		--PURCHASE_DEPT_NAME                    \n");
		// tSQL.append("   , CONVERT(VARCHAR(8),GETDATE(),112)               	\n");
		// tSQL.append("   , REPLACE(CONVERT(VARCHAR(8),GETDATE(),108), ':', '')               	\n");
		// tSQL.append("   , ?                         					\n");
		// tSQL.append("   , CONVERT(VARCHAR(8),GETDATE(),112)               	\n");
		// tSQL.append("   , REPLACE(CONVERT(VARCHAR(8),GETDATE(),108), ':', '')               	\n");
		// tSQL.append("   , ?                         					\n");
		// tSQL.append("   , ?						                      	\n");
		// tSQL.append("   , ?						                      	\n");
		// tSQL.append("   , ?						                      	\n");
		// tSQL.append("   , ?						                      	\n");
		// tSQL.append("   , ?						                      	\n");
		//
		// tSQL.append("   , ?						                      	\n");
		// tSQL.append("   , ?						                      	\n");
		// tSQL.append("   , ?						                      	\n");
		// tSQL.append("   , ?						                      	\n");
		// tSQL.append("   , SUBSTRING(?,1,8)						        \n");
		// tSQL.append("   , ?						                      	\n");
		// tSQL.append("   , ?						                      	\n");
		// tSQL.append("   , ?						                      	\n");
		// tSQL.append("   , ?						                      	\n");
		// tSQL.append("   )						                      	\n");

		try {
			String[] type = { "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "N", "S", "N", "N", "S", "S", "S", "S", "S", "S", "S",
					"S", "S", "S", "S", "N", "N", "S", "S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "S", "S" };

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, wxp.getQuery());
			rtn = sm.doInsert(data_dt, type);
		} catch (Exception e) {
			Logger.debug.println(info.getSession("ID"), this, wxp.getQuery());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}// End of et_setPrDTCreate()

	@SuppressWarnings("deprecation")
	private int et_setPrHDCreate(String[][] data_hd) throws Exception {

		int rtn = 0;

		ConnectionContext ctx = getConnectionContext();
		String add_user_id = info.getSession("ID");

		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("add_user_id", info.getSession("ID"));
		wxp.addVar("id", info.getSession("ID"));

		// tSQL.append(" INSERT INTO ICOYPRHD                          \n");
		// tSQL.append(" (                                             \n");
		// tSQL.append("   HOUSE_CODE                                  \n");
		// tSQL.append("   , PR_NO                                     \n");
		// tSQL.append("   , STATUS                                    \n");
		// tSQL.append("   , COMPANY_CODE                              \n");
		// tSQL.append("   , PLANT_CODE                                \n");
		// tSQL.append("   , PR_TOT_AMT                                \n");
		// tSQL.append("   , PR_TYPE                                   \n");
		// tSQL.append("   , DEMAND_DEPT                               \n");
		// tSQL.append("   , SIGN_STATUS                               \n");
		// tSQL.append("   , DEMAND_DEPT_NAME                          \n");
		// tSQL.append("   , TEL_NO                                    \n");
		// tSQL.append("   , REMARK                                    \n");
		// tSQL.append("   , SUBJECT                                   \n");
		// tSQL.append("   , PR_LOCATION                               \n");
		// tSQL.append("   , RECEIVE_TERM                              \n");
		// tSQL.append("   , ORDER_NO                                  \n");
		// tSQL.append("   , SALES_USER_DEPT                           \n");
		// tSQL.append("   , SALES_USER_ID                             \n");
		// tSQL.append("   , CONTRACT_HOPE_DAY                         \n");
		// tSQL.append("   , TAKE_USER_NAME                            \n");
		// tSQL.append("   , TAKE_TEL                                  \n");
		// tSQL.append("   , REC_REASON                                \n");
		// tSQL.append("   , AHEAD_FLAG                                \n");
		// tSQL.append("   , CONTRACT_FROM_DATE                        \n");
		// tSQL.append("   , CONTRACT_TO_DATE                          \n");
		// tSQL.append("   , SHIPPER_TYPE       						\n");
		// tSQL.append("   , HARD_MAINTANCE_TERM                       \n");
		// tSQL.append("   , SOFT_MAINTANCE_TERM                       \n");
		// tSQL.append("   , DELY_TO_CONDITION                         \n");
		// tSQL.append("   , COMPUTE_REASON                            \n");
		// tSQL.append("   , CUST_CODE                                 \n");
		// tSQL.append("   , CUST_NAME                                 \n");
		// tSQL.append("   , SALES_AMT                                 \n");
		// tSQL.append("   , SALES_TYPE                                \n");
		// tSQL.append("   , ORDER_NAME                                \n");
		// tSQL.append("   , REQ_TYPE                            		\n");
		// tSQL.append("   , BID_PR_NO                            		\n");
		// tSQL.append("   , ATTACH_NO                            		\n");
		// tSQL.append("   , BSART                            			\n");
		// tSQL.append("	, CREATE_TYPE								\n");
		// tSQL.append("   , ADD_DATE                                  \n");
		// tSQL.append("   , ADD_TIME                                  \n");
		// tSQL.append("   , ADD_USER_ID                               \n");
		// tSQL.append("   , CHANGE_DATE                               \n");
		// tSQL.append("   , CHANGE_TIME                               \n");
		// tSQL.append("   , CHANGE_USER_ID                            \n");
		// tSQL.append(" ) VALUES (                                   	\n");
		// tSQL.append("   ? 		--HOUSE_CODE                            \n");
		// tSQL.append("   , ? 	--PR_NO                                 \n");
		// tSQL.append("   , ? 	--STATUS                                \n");
		// tSQL.append("   , ? 	--COMPANY_CODE                          \n");
		// tSQL.append("   , ? 	--PLANT_CODE                            \n");
		// tSQL.append("   , ? 	--PR_TOT_AMT                            \n");
		// tSQL.append("   , ? 	--PR_TYPE                               \n");
		// tSQL.append("   , ? 	--DEMAND_DEPT                           \n");
		// tSQL.append("   , ? 	--SIGN_STATUS                           \n");
		// tSQL.append("   , ? 	--DEMAND_DEPT_NAME                      \n");
		// tSQL.append("   , ? 	--TEL_NO                                \n");
		// tSQL.append("   , ? 	--REMARK                                \n");
		// tSQL.append("   , ? 	--SUBJECT                               \n");
		// tSQL.append("   , ? 	--PR_LOCATION                           \n");
		// tSQL.append("   , ? 	--RECEIVE_TERM                          \n");
		// tSQL.append("   , ? 	--ORDER_NO                              \n");
		// tSQL.append("   , ? 	--SALES_USER_DEPT                       \n");
		// tSQL.append("   , ? 	--SALES_USER_ID                         \n");
		// tSQL.append("   , ? 	--CONTRACT_HOPE_DAY                     \n");
		// tSQL.append("   , ? 	--TAKE_USER_NAME                        \n");
		// tSQL.append("   , ? 	--TAKE_TEL                              \n");
		// tSQL.append("   , ? 	--REC_REASON                            \n");
		// tSQL.append("   , ? 	--AHEAD_FLAG                            \n");
		// tSQL.append("   , ? 	--CONTRACT_FROM_DATE                    \n");
		// tSQL.append("   , ? 	--CONTRACT_TO_DATE                      \n");
		// tSQL.append("   , ? 	--SHIPPER_TYPE       					\n");
		// tSQL.append("   , ?		--HARD_MAINTANCE_TERM                   \n");
		// tSQL.append("   , ?		--SOFT_MAINTANCE_TERM                   \n");
		// tSQL.append("   , ? 	--DELY_TO_CONDITION                     \n");
		// tSQL.append("   , ? 	--COMPUTE_REASON                        \n");
		// tSQL.append("   , ? 	--CUST_CODE                             \n");
		// tSQL.append("   , ? 	--CUST_NAME                             \n");
		// tSQL.append("   , ? 	--SALES_AMT                             \n");
		// tSQL.append("   , ? 	--SALES_TYPE                            \n");
		// tSQL.append("   , ? 	--ORDER_NAME                            \n");
		// tSQL.append("   , ? 	--REQ_TYPE                            	\n");
		// tSQL.append("   , ?     --BID_PR_NO                            	\n");
		// tSQL.append("   , ?		--ATTACH_NO                            	\n");
		// tSQL.append("   , ?		--BSART                            		\n");
		// tSQL.append("	, 'PR'  --CREATE_TYPE							\n");
		// tSQL.append("   , CONVERT(VARCHAR(8),GETDATE(),112)               	\n");
		// tSQL.append("   , REPLACE(CONVERT(VARCHAR(8),GETDATE(),108), ':', '')               	\n");
		// tSQL.append("   , '"+add_user_id+"'                         	\n");
		// tSQL.append("   , CONVERT(VARCHAR(8),GETDATE(),112)               	\n");
		// tSQL.append("   , REPLACE(CONVERT(VARCHAR(8),GETDATE(),108), ':', '')               	\n");
		// tSQL.append("   , '"+add_user_id+"'                         	\n");
		// tSQL.append(" )                                             	\n");

		try {
			SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx,
					wxp.getQuery());
			String[] setType = { "S", "S", "S", "S", "S", "N", "S", "S", "S",
					"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "N",
					"S", "S", "S", "S", "S", "S" };
			rtn = sm.doInsert(data_hd, setType);
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private int et_setInfoCreate(String[][] info_dt) throws Exception {
		int rtn = 0;
		ConnectionContext ctx = getConnectionContext();

		String DBOwner = CommonUtil.getConfig("Sepoa.generator.db.selfuser");
		// String add_user_id = info.getSession("ID");
		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());

		// StringBuffer tSQL = new StringBuffer();
		// tSQL.append(" INSERT INTO ICOYINFO                         	\n");
		// tSQL.append(" (                                            	\n");
		// tSQL.append(" 	 HOUSE_CODE                                	\n");
		// tSQL.append(" 	, COMPANY_CODE                              \n");
		// tSQL.append(" 	, PURCHASE_LOCATION                         \n");
		// tSQL.append(" 	, ITEM_NO                                   \n");
		// tSQL.append(" 	, VENDOR_CODE                             	\n");
		// tSQL.append(" 	, STATUS                               		\n");
		// tSQL.append(" 	, ADD_DATE                                  \n");
		// tSQL.append(" 	, ADD_TIME                             		\n");
		// tSQL.append(" 	, ADD_USER_ID                       		\n");
		// tSQL.append(" 	, CHANGE_DATE                               \n");
		// tSQL.append(" 	, CHANGE_TIME                             	\n");
		// tSQL.append(" 	, CHANGE_USER_ID                            \n");
		// tSQL.append(" 	, SHIPPER_TYPE                              \n");
		// tSQL.append(" 	, BASIC_UNIT                               	\n");
		// tSQL.append(" 	, VALID_FROM_DATE                           \n");
		// tSQL.append(" 	, VALID_TO_DATE                             \n");
		// tSQL.append(" 	, EXEC_NO                                	\n");
		// tSQL.append(" 	, EXEC_QTY                          		\n");
		// tSQL.append(" 	, EXEC_SEQ                         			\n");
		// tSQL.append(" 	, TTL_CHARGE                          		\n");
		// tSQL.append(" 	, NET_AMT                          			\n");
		// tSQL.append(" 	, EXEC_TTL_AMT                          	\n");
		// tSQL.append(" 	, PURCHASE_HOLD_FLAG                        \n");
		// tSQL.append(" 	, GR_BASE_FLAG                          	\n");
		// tSQL.append(" 	, UNIT_PRICE                          		\n");
		// tSQL.append(" 	, MOLDING_CHARGE                            \n");
		// tSQL.append(" 	, PURCHASE_UNIT                             \n");
		// tSQL.append(" 	, PURCHASE_CONV_RATE                        \n");
		// tSQL.append(" 	, PURCHASE_CONV_QTY                         \n");
		// tSQL.append(" 	, FOB_CHARGE                                \n");
		// tSQL.append(" 	, TRANS_CHARGE                         		\n");
		// tSQL.append(" 	, MOLDING_QTY                              	\n");
		// tSQL.append(" 	, TARIFF_TAX_RATE                           \n");
		// tSQL.append(" 	, YEAR_QTY                             		\n");
		// tSQL.append(" 	, CUSTOMER_PRICE                        	\n");
		//
		// tSQL.append(" ) VALUES (                                   	\n");
		// tSQL.append(" 	 ?		--HOUSE_CODE                        \n");
		// tSQL.append(" 	, ?		--COMPANY_CODE                      \n");
		// tSQL.append(" 	, ?		--PURCHASE_LOCATION                 \n");
		// tSQL.append(" 	, ? 	--ITEM_NO                           \n");
		// tSQL.append(" 	, ? 	--VENDOR_CODE                       \n");
		// tSQL.append(" 	, ? 	--STATUS                            \n");
		// tSQL.append(" 	, CONVERT(VARCHAR(8),GETDATE(),112) 	--ADD_DATE                          \n");
		// tSQL.append(" 	, REPLACE(CONVERT(VARCHAR(8),GETDATE(),108), ':', '') 	--ADD_TIME          \n");
		// tSQL.append(" 	, ? 	--ADD_USER_ID                    	\n");
		// tSQL.append(" 	, CONVERT(VARCHAR(8),GETDATE(),112) 	--CHANGE_DATE                       \n");
		// tSQL.append(" 	, REPLACE(CONVERT(VARCHAR(8),GETDATE(),108), ':', '') 	--CHANGE_TIME       \n");
		// tSQL.append(" 	, ? 	--CHANGE_USER_ID                    \n");
		// tSQL.append(" 	, ? 	--SHIPPER_TYPE                      \n");
		// tSQL.append(" 	, ? 	--BASIC_UNIT                        \n");
		// tSQL.append(" 	, CONVERT(VARCHAR(8),GETDATE(),112) 		--VALID_FROM_DATE               \n");
		// tSQL.append(" 	, CONVERT(VARCHAR(8),GETDATE() + 30,112) 	--VALID_TO_DATE                 \n");
		// tSQL.append(" 	, ? 	--EXEC_NO                       	\n");
		// tSQL.append(" 	, 0 	--EXEC_QTY                       	\n");
		// tSQL.append(" 	, ? 	--EXEC_SEQ                       	\n");
		// tSQL.append(" 	, 0		--TTL_CHARGE                        \n");
		// tSQL.append(" 	, ?		--NET_AMT                          	\n");
		// tSQL.append(" 	, ?		--EXEC_TTL_AMT                      \n");
		// tSQL.append(" 	, 'N' 	--PURCHASE_HOLD_FLAG                \n");
		// tSQL.append(" 	, 'N' 	--GR_BASE_FLAG                      \n");
		// tSQL.append(" 	, ? 	--UNIT_PRICE                        \n");
		// tSQL.append(" 	, 0		--MOLDING_CHARGE                    \n");
		// tSQL.append(" 	, ?		--PURCHASE_UNIT                     \n");
		// tSQL.append(" 	, 0		--PURCHASE_CONV_RATE                \n");
		// tSQL.append(" 	, 0		--PURCHASE_CONV_QTY                 \n");
		// tSQL.append(" 	, 0		--FOB_CHARGE                    	\n");
		// tSQL.append(" 	, 0		--TRANS_CHARGE                    	\n");
		// tSQL.append(" 	, 0		--MOLDING_QTY                    	\n");
		// tSQL.append(" 	, 0		--TARIFF_TAX_RATE                   \n");
		// tSQL.append(" 	, 0		--YEAR_QTY                    		\n");
		// tSQL.append(" 	, ?		--CUSTOMER_PRICE                    \n");
		// tSQL.append("   )						                    \n");

		try {
			String[] type = { "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "S", "N", "N", "N", "S", "N" };

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, wxp.getQuery());
			rtn = sm.doInsert(info_dt, type);
		} catch (Exception e) {

			Logger.debug.println(info.getSession("ID"), this, wxp.getQuery());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}// End of et_setPrDTCreate()

	private int CreateApproval(SepoaInfo info, SignRequestInfo sri)
			throws Exception // 결재모듈에 필요한 생성부분
	{

		Logger.debug.println(info.getSession("ID"), this,
				"##### CreateApproval #####");

		SepoaOut wo = new SepoaOut();
		SepoaRemote ws;
		String nickName = "p6027";
		String conType = "NONDBJOB";
		String MethodName1 = "setConnectionContext";
		ConnectionContext ctx = getConnectionContext();

		try {
			Object[] obj1 = { ctx };
			String MethodName2 = "addSignRequest";
			Object[] obj2 = { sri };

			ws = new SepoaRemote(nickName, conType, info);
			ws.lookup(MethodName1, obj1);
			wo = ws.lookup(MethodName2, obj2);
		} catch (Exception e) {
			Logger.err.println("approval: = " + e.getMessage());
		}
		return wo.status;
	}

	public SepoaOut getQuery_PRNO(String[] args) {
		try {
			String rtn = et_getQuery_PRNO(args);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.get("p10_pra.0000").toString());
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("p10_pra.0001").toString());
		}
		return getSepoaOut();
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private String et_getQuery_PRNO(String[] args) throws Exception {

		String house_code = info.getSession("HOUSE_CODE");
		String ctrl_code = info.getSession("CTRL_CODE");

		// ///////////////////// 직무 코드 관련 처리
		// 입력된 직무코드 가 세션상의 직무 코드에 속하면 where 절에 세션사의 직무 코드가 들어가며 그렇지 않으면 입력된
		// 직무코드가 들어간다.

		// boolean flag = false;
		//
		// StringTokenizer st = new StringTokenizer(ctrl_code,"&",false);
		// int count = st.countTokens();
		// for( int i =0; i< count; i++ ){
		// String tmp_ctrl_code = st.nextToken();
		// if( change_user.equals(tmp_ctrl_code) ){
		// flag = true;
		// Logger.debug.println(info.getSession("ID"),this,"============================same ctrl_code");
		// break;
		// }
		// else
		// Logger.debug.println(info.getSession("ID"),this,"==============================	not	same ctrl_code");
		// }
		//
		// String purchaserUser_seperate="";
		// if( flag == true ){
		// StringTokenizer st1 = new StringTokenizer(ctrl_code,"&",false);
		// int count1 = st1.countTokens();
		//
		// for( int i =0; i< count1; i++ ){
		// String tmp_ctrl_code = st1.nextToken();
		//
		// if( i == 0 )
		// purchaserUser_seperate = tmp_ctrl_code;
		// else
		// purchaserUser_seperate += "','"+tmp_ctrl_code;
		// }
		// }
		// else{
		// purchaserUser_seperate = change_user;
		// }

		// ////////////////////////직무 코드 관련 처리 끝

		String rtn = null;
		String cur_date_time = SepoaDate.getShortDateString()
				+ SepoaDate.getShortTimeString().substring(0, 4);

		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("id", info.getSession("ID"));
		wxp.addVar("cur_date_time", cur_date_time);

		// sql.append(" SELECT                                                                                 	\n");
		// sql.append("          D.PR_NO                                                              				\n");
		// sql.append("          ,MAX(H.SUBJECT)  AS SUBJECT  , MAX(PH.PR_TYPE) AS PR_TYPE               			\n");
		// sql.append("		  ,MAX(H.BID_RFQ_TYPE ) AS BID_RFQ_TYPE                                            	\n");
		// sql.append("		  ,MAX(PH.SALES_TYPE ) AS BID_SALES_TYPE                                            \n");
		// sql.append("		  ,MAX(PH.BSART ) AS BID_BSART                                            			\n");
		// sql.append("		  ,MAX(PH.ORDER_NO ) AS BID_ORDER_NO                                            	\n");
		// sql.append("   FROM    ICOYRQHD H , ICOYRQDT D,  ICOYQTDT T, ICOYPRDT P  , ICOYPRHD PH                  \n");
		// sql.append("   WHERE   H.HOUSE_CODE    = '"+house_code+"'                                  				\n");
		// //sql.append("   AND H.CTRL_CODE    IN ('"+ctrl_code+"' )                                        			\n");
		// sql.append("   AND CAST('"+cur_date_time+"' AS NUMERIC) >= CAST(H.RFQ_CLOSE_DATE + H.RFQ_CLOSE_TIME AS NUMERIC) \n");
		// sql.append("   AND H.HOUSE_CODE = D.HOUSE_CODE                                                     		\n");
		// sql.append("   AND H.RFQ_NO = D.RFQ_NO                                                             		\n");
		// sql.append("   AND H.RFQ_COUNT = D.RFQ_COUNT                                                       		\n");
		// sql.append("   AND D.HOUSE_CODE = T.HOUSE_CODE                                                     		\n");
		// sql.append("   AND D.RFQ_NO = T.RFQ_NO                                                             		\n");
		// sql.append("   AND D.RFQ_COUNT = T.RFQ_COUNT                                                       		\n");
		// sql.append("   AND D.RFQ_SEQ = T.RFQ_SEQ                                                           		\n");
		// sql.append("   AND D.HOUSE_CODE = P.HOUSE_CODE                                                     		\n");
		// sql.append("   AND D.PR_NO = P.PR_NO                                                               		\n");
		// sql.append("   AND D.PR_SEQ = P.PR_SEQ                                                             		\n");
		// sql.append("   AND D.HOUSE_CODE = PH.HOUSE_CODE                                                     	\n");
		// sql.append("   AND D.PR_NO = PH.PR_NO                                                               	\n");
		// sql.append("   AND PH.ADD_USER_ID = '"+info.getSession("ID")+"'                                         \n");
		// sql.append("   AND PH.REQ_TYPE = 'B'                                                                	\n");
		// sql.append("   AND T.SETTLE_FLAG = 'Y'                                                                	\n");
		// sql.append("	<OPT=S,S> AND   H.ADD_DATE  BETWEEN ? </OPT>                                     		\n");
		// sql.append("	<OPT=S,S> AND   ?                      </OPT>                                  			\n");
		// sql.append("	<OPT=S,S> AND   H.SUBJECT  LIKE '%' || ? || '%'              </OPT>              		\n");
		// sql.append("   AND H.STATUS != 'D'                                                                 		\n");
		// sql.append("   AND H.STATUS != 'D'                                                                 		\n");
		// sql.append("   AND D.STATUS != 'D'                                                                 		\n");
		// sql.append("   AND T.STATUS != 'D'                                                                 		\n");
		// sql.append("   AND P.STATUS != 'D'                                                                 		\n");
		// sql.append("   GROUP BY     D.PR_NO                                                                		\n");
		// sql.append("   ORDER BY     MAX(H.ADD_DATE)                                                         	\n");

		try {
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, wxp.getQuery());

			rtn = sm.doSelect(args);
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	@SuppressWarnings({ "unused", "unchecked" })
	public SepoaOut setPrChange(String pr_no, String[][] args_hd,
			String[][] args_dt, String[][] info_dt, String sign_status,
			String account_code, String shipper_type, String cur,
			String pr_tot_amt, String approval_str, String[] IU_FLAG,
			String[][] args_dt_update, String[][] args_dt_insert,
			String deledtePrData, String req_type, String ORDER_NO,
			String ORDER_COUNT) {
		String add_user_id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");
		String company = info.getSession("COMPANY_CODE");
		String add_user_dept = info.getSession("DEPARTMENT");
		String lang = info.getSession("LANGUAGE");

		int rtn = -1;
		int rtn_scms = -1;
		ConnectionContext ctx = getConnectionContext();
		try {

			// int hd_rtn = et_setPrHDChange(args_hd); IBKS 헤더단(영업관리에서 넘어온자료)은
			// 수정하지 않는다.
			// int dt_rtn = et_deletePrdtAll(pr_no);
			// int if_rtn = et_deleteinfoAll(pr_no);
			// dt_rtn = et_setPrDTCreate(args_dt);
			// if_rtn = et_setInfoCreate(info_dt);

			// 1. 품목에 대한 INSERT, UPDATE
			for (int i = 0; i < IU_FLAG.length; i++) {

				if ("I".equals(IU_FLAG[i])) { // INSERT 건 인서트시 맥스값 +1 로 PR_SEQ
												// 채번
					rtn = et_setPrChange(ctx, args_dt_insert[i], IU_FLAG[i]);
				} else if ("U".equals(IU_FLAG[i])) { // UPDATE 건
					rtn = et_setPrChange(ctx, args_dt_update[i], IU_FLAG[i]);
				}

			}

			// 2. 품목에 대한 DELETE
			if (!"".equals(deledtePrData)) {
				rtn = et_setPrDelete(ctx, deledtePrData);
			}

			// 3. 영업관리 TB_SCM_PR 테이블에 수정결과를 반영한다.
			/*
			 * Configuration conf = new Configuration();
			 * if(conf.getBoolean("Sepoa.scms.if_flag")){ rtn_scms =
			 * scms_interface(ctx, pr_no, req_type); }
			 */

			msg.put("PR_NO", pr_no);
			setMessage("수정이 완료되었습니다.");
			setValue(pr_no);

			if (sign_status.equals("P")) {
				SignRequestInfo sri = new SignRequestInfo();
				sri.setHouseCode(house_code);
				sri.setCompanyCode(company);
				sri.setDept(add_user_dept);
				sri.setReqUserId(add_user_id);
				sri.setDocType("PR");
				sri.setDocNo(pr_no);
				sri.setDocSeq("0");
				sri.setAccountCode(account_code);
				sri.setItemCount(args_dt.length);
				sri.setSignStatus(sign_status);
				sri.setShipperType(shipper_type);
				sri.setCur(cur);
				sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
				sri.setTotalAmt(Double.parseDouble(pr_tot_amt));
				rtn = CreateApproval(info, sri); // 밑에 함수 실행
				if (rtn == 0) {
					try {
						Rollback();
					} catch (Exception d) {
						Logger.err.println(info.getSession("ID"), this,
								d.getMessage());
					}
					setStatus(0);
					setMessage(msg.get("p10_pra.0030").toString());
					return getSepoaOut();
				}
				setStatus(1);

				msg.put("PR_NO", pr_no);
				setMessage(msg.get("STDPR.0046").toString());
			}

			Commit();
		} catch (Exception e) {
			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}
			Logger.err.println(info.getSession("ID"), this, e.getMessage());

			if (rtn == -1) {
				setMessage("수정이 실패하였습니다.");
			}

			if (rtn_scms == -1) {
				setMessage("수정[인터페이스]이 실패하였습니다.");
			}

			setStatus(0);
		}

		return getSepoaOut();
	}// End of setPrChange()

	@SuppressWarnings({ "unused", "deprecation" })
	private int et_setPrHDChange(String[][] args) throws Exception {
		int rtn = 0;
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		String user_id = info.getSession("ID");
		String add_date = SepoaDate.getShortDateString();
		String add_time = SepoaDate.getShortTimeString();

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("user_id", info.getSession("ID"));

			// tSQL.append(" UPDATE  ICOYPRHD  SET                              \n");
			// tSQL.append("       STATUS                 = 'R'                 \n");
			// tSQL.append("     , PR_TOT_AMT             = ?                   \n");
			// tSQL.append("     , PR_TYPE                = ?                   \n");
			// tSQL.append("     , DEMAND_DEPT            = ?                   \n");
			// tSQL.append("     , SIGN_STATUS            = ?                   \n");
			// tSQL.append("     , DEMAND_DEPT_NAME       = ?                   \n");
			// tSQL.append("     , TEL_NO                 = ?                   \n");
			// tSQL.append("     , REMARK                 = ?                   \n");
			// tSQL.append("     , SUBJECT                = ?                   \n");
			// tSQL.append("     , PR_LOCATION            = ?                   \n");
			// tSQL.append("     , RECEIVE_TERM           = ?                   \n");
			// tSQL.append("     , ORDER_NO               = ?                   \n");
			// tSQL.append("     , SALES_USER_DEPT        = ?                   \n");
			// tSQL.append("     , SALES_USER_ID          = ?                   \n");
			// tSQL.append("     , CONTRACT_HOPE_DAY      = ?                   \n");
			// tSQL.append("     , TAKE_USER_NAME         = ?                   \n");
			// tSQL.append("     , TAKE_TEL               = ?                   \n");
			// tSQL.append("     , REC_REASON             = ?                   \n");
			// tSQL.append("     , AHEAD_FLAG             = ?                   \n");
			// tSQL.append("     , CONTRACT_FROM_DATE     = ?                   \n");
			// tSQL.append("     , CONTRACT_TO_DATE       = ?                   \n");
			// tSQL.append("     , SHIPPER_TYPE           = ?                   \n");
			// tSQL.append("     , HARD_MAINTANCE_TERM    = ?                   \n");
			// tSQL.append("     , SOFT_MAINTANCE_TERM    = ?                   \n");
			// tSQL.append("     , DELY_TO_CONDITION      = ?                   \n");
			// tSQL.append("     , COMPUTE_REASON         = ?                   \n");
			// tSQL.append("     , CUST_CODE              = ?                   \n");
			// tSQL.append("     , CUST_NAME              = ?                   \n");
			// tSQL.append("     , SALES_AMT              = ?                   \n");
			// tSQL.append("     , SALES_TYPE             = ?                   \n");
			// tSQL.append("     , ORDER_NAME             = ?                   \n");
			// tSQL.append("     , BID_PR_NO              = ?                   \n");
			// tSQL.append("     , ATTACH_NO              = ?                   \n");
			// tSQL.append("     , CHANGE_DATE            = CONVERT(VARCHAR(8),GETDATE(),112)                   \n");
			// tSQL.append("     , CHANGE_TIME            = REPLACE(CONVERT(VARCHAR(8),GETDATE(),108), ':', '')                  \n");
			// tSQL.append("     , CHANGE_USER_ID         = '"+user_id+"'                   \n");
			// tSQL.append(" WHERE    HOUSE_CODE    =   ?                       \n");
			// tSQL.append("     AND  COMPANY_CODE  =   ?                       \n");
			// tSQL.append("     AND  STATUS        !=  'D'                     \n");
			// tSQL.append("     AND  PR_NO         =   ?                       \n");

			String[] setType = { "N", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "S" };
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx,
					wxp.getQuery());
			rtn = sm.doUpdate(args, setType);
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private int et_deletePrdtAll(String pr_no) throws Exception {
		int rtn = 0;
		ConnectionContext ctx = getConnectionContext();

		String add_date = SepoaDate.getShortDateString();
		String add_time = SepoaDate.getShortTimeString();
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		String add_user_id = info.getSession("ID");

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("pr_no", pr_no);

			// tSQL.append(" DELETE FROM ICOYPRDT                  \n");
			// tSQL.append(" WHERE HOUSE_CODE = '"+house_code+"'   \n");
			// tSQL.append(" AND PR_NO  = '"+pr_no+"'              \n");

			SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx,
					wxp.getQuery());
			rtn = sm.doUpdate();
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	/*
	 * PR_NO에 해당하는 ICOYINFO 전체를 삭제한다.
	 */
	@SuppressWarnings({ "unused", "deprecation" })
	private int et_deleteinfoAll(String pr_no) throws Exception {
		int rtn = 0;
		ConnectionContext ctx = getConnectionContext();

		String add_date = SepoaDate.getShortDateString();
		String add_time = SepoaDate.getShortTimeString();
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		String add_user_id = info.getSession("ID");

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("pr_no", pr_no);

			// tSQL.append(" DELETE FROM ICOYINFO                  \n");
			// tSQL.append(" WHERE HOUSE_CODE = '"+house_code+"'   \n");
			// tSQL.append(" AND EXEC_NO  = '"+pr_no+"'            \n");

			SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx,
					wxp.getQuery());
			rtn = sm.doUpdate();
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	@SuppressWarnings("unused")
	public SepoaOut deletePrdt(String pr_no, String[][] data_dt) {

		String add_user_id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");
		String company = info.getSession("COMPANY_CODE");
		String add_user_dept = info.getSession("DEPARTMENT");
		String dept_name = info.getSession("DEPARTMENT_NAME_LOC");
		String name_eng = info.getSession("NAME_ENG");
		String name_loc = info.getSession("NAME_LOC");
		String lang = info.getSession("LANGUAGE");

		try {
			int dt_rtn = et_deletePrdt(data_dt);

			dt_rtn = et_updatePRHD(pr_no);

			if (dt_rtn < 1) {
				throw new Exception(msg.get("STDPR.0004").toString());
			}
			setStatus(1);
			setValue(String.valueOf(dt_rtn));
			setMessage(msg.get("STDPR.0000").toString());
			Commit();
		} catch (Exception e) {
			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}
			Logger.err.println(info.getSession("ID"), this, "XXXXXXXXXXXXXXXXX"
					+ e.getMessage());
			setStatus(0);
			setMessage(msg.get("STDPR.0004").toString());
		}

		return getSepoaOut();
	}

	/**
	 * 구매요청 수정에서 아이템을 삭제한다.
	 * 
	 * <pre>
	 * 
	 * </pre>
	 * 
	 * @param args
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unused", "deprecation" })
	private int et_deletePrdt(String[][] args) throws Exception {
		int rtn = 0;
		ConnectionContext ctx = getConnectionContext();

		String add_date = SepoaDate.getShortDateString();
		String add_time = SepoaDate.getShortTimeString();
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		String add_user_id = info.getSession("ID");

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

			// tSQL.append(" DELETE FROM ICOYPRDT                  \n");
			// tSQL.append(" WHERE HOUSE_CODE = '"+house_code+"'   \n");
			// tSQL.append(" AND PR_NO  = ?                        \n");
			// tSQL.append(" AND PR_SEQ = ?                        \n");

			String[] setType = { "S", "S" };

			SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx,
					wxp.getQuery());
			rtn = sm.doUpdate(args, setType);
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private int et_updatePRHD(String pr_no) throws Exception {
		int rtn = 0;
		ConnectionContext ctx = getConnectionContext();

		String add_date = SepoaDate.getShortDateString();
		String add_time = SepoaDate.getShortTimeString();
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		String add_user_id = info.getSession("ID");
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			// tSQL.append(" UPDATE ICOYPRHD SET                                 \n");
			// tSQL.append("   PR_TOT_AMT = (SELECT SUM(PR_AMT) FROM ICOYPRDT    \n");
			// tSQL.append("                 WHERE PR_NO = HD.PR_NO              \n");
			// tSQL.append("                 AND STATUS != 'D')                  \n");
			// tSQL.append(" FROM  ICOYPRHD HD                                   \n");
			// tSQL.append(" WHERE HD.HOUSE_CODE = ?                             \n");
			// tSQL.append(" AND 	HD.PR_NO = ?                                  \n");

			String[][] args = { { house_code, pr_no } };
			String[] type1 = { "S", "S" };
			SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx,
					wxp.getQuery());
			rtn = sm.doUpdate(args, type1);
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	// public SepoaOut prInfoVendorList(String[] args)
	// {
	// try
	// {
	// String rtn = et_prInfoVendorList(args);
	// setStatus(1);
	// setValue(rtn);
	//
	// setMessage(msg.get("p10_pra.0000").toString());
	//
	// }catch(Exception e) {
	// Logger.err.println(userid,this,e.getMessage());
	// setStatus(0);
	// setMessage(msg.get("p10_pra.0001").toString());
	// }
	// return getSepoaOut();
	// }

	public SepoaOut prInfoVendorList(Map<String, String> header) {
		ConnectionContext ctx = null;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		String rtn = null;
		String id = info.getSession("ID");
		String houseCode = info.getSession("HOUSE_CODE");
		String companyCode = info.getSession("COMPANY_CODE");

		try {
			setStatus(1);
			setFlag(true);

			ctx = getConnectionContext();

			sxp = new SepoaXmlParser(this, "et_prInfoVendorList");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);

			header.put("HOUSE_CODE", houseCode);
			header.put("COMPANY_CODE", companyCode);

			rtn = ssm.doSelect(header); // 조회

			setValue(rtn);
			setMessage((String) msg.get("0000"));
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage((String) msg.get("0001"));
		}

		return getSepoaOut();
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private String et_prInfoVendorList(String[] args) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code = info.getSession("HOUSE_CODE");
		String dept = info.getSession("DEPARTMENT");

		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("HOUSE_CODE", info.getSession("HOUSE_CODE"));
		wxp.addVar("COMPANY_CODE", info.getSession("COMPANY_CODE"));

		try {

			SepoaSQLManager sm = new SepoaSQLManager(userid, this, ctx,
					wxp.getQuery());
			rtn = sm.doSelect(args);

		} catch (Exception e) {
			Logger.debug.println(userid, this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	public SepoaOut prBidVendorList(String bid_pr_no, String pr_no,
			String item_no, String pr_type) {
		try {
			String rtn = et_prBidVendorList(bid_pr_no, pr_no, item_no, pr_type);
			setStatus(1);
			setValue(rtn);

			setMessage(msg.get("p10_pra.0000").toString());

		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("p10_pra.0001").toString());
		}
		return getSepoaOut();
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private String et_prBidVendorList(String bid_pr_no, String pr_no,
			String item_no, String pr_type) throws Exception {
		String DBOwner = getConfig("Sepoa.generator.db.selfuser");

		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		StringBuffer tSQL = new StringBuffer();
		String house_code = info.getSession("HOUSE_CODE");
		String dept = info.getSession("DEPARTMENT");
		SepoaSQLManager sm = null;

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName() + "_1");
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("bid_pr_no", bid_pr_no);
			wxp.addVar("item_no", item_no);
			wxp.addVar("pr_type", pr_type.equals("I"));
			if (pr_type.equals("I")) {

				// //카탈로그에 등록된 품목인경우
				// tSQL.append(" SELECT  SE.VENDOR_CODE                                                        	\n");
				// tSQL.append("  , DBO.getCompanyNameLoc( SE.HOUSE_CODE,  SE.VENDOR_CODE , 'S') AS VENDOR_NAME        \n");
				// tSQL.append("  , EP.UNIT_PRICE                                                                  \n");
				// tSQL.append(" FROM ICOYRQDT DT, ICOYRQSE SE, ICOYQTDT EP                                        \n");
				// tSQL.append(" WHERE DT.HOUSE_CODE = '"+house_code+"'                                            \n");
				// tSQL.append(" AND DT.HOUSE_CODE = SE.HOUSE_CODE                                                 \n");
				// tSQL.append(" AND DT.RFQ_NO = SE.RFQ_NO                                                         \n");
				// tSQL.append(" AND DT.RFQ_COUNT = SE.RFQ_COUNT                                                   \n");
				// tSQL.append(" AND DT.RFQ_SEQ = SE.RFQ_SEQ                                                       \n");
				// tSQL.append(" AND DT.PR_NO  = '"+bid_pr_no+"' 													\n");
				// tSQL.append(" AND EP.ITEM_NO  =  '"+item_no+"'													\n");
				// tSQL.append(" AND DT.STATUS != 'D'                                                              \n");
				// tSQL.append(" AND SE.STATUS !='D'                                                               \n");
				// tSQL.append(" AND SE.BID_FLAG = 'Y'                                                             \n");
				// tSQL.append(" AND SE.CONFIRM_FLAG = 'Y'                                                         \n");
				// tSQL.append(" AND EP.SETTLE_FLAG = 'Y'                           \n");
				// tSQL.append(" AND SE.HOUSE_CODE = EP.HOUSE_CODE                                                 \n");
				// tSQL.append(" AND SE.VENDOR_CODE = EP.VENDOR_CODE                                               \n");
				// tSQL.append(" AND SE.RFQ_NO = EP.RFQ_NO                                                         \n");
				// tSQL.append(" AND SE.RFQ_COUNT = EP.RFQ_COUNT                                                   \n");
				// tSQL.append(" AND SE.RFQ_SEQ = EP.RFQ_SEQ                                                       \n");
				// tSQL.append(" AND EP.STATUS ! = 'D'                                                             \n");
				// tSQL.append(" group by SE.HOUSE_CODE, SE.RFQ_NO,  SE.VENDOR_CODE     , EP.UNIT_PRICE            \n");
				//
				// //신규등록 품목인경우
				// tSQL_1.append(" SELECT  SE.VENDOR_CODE                                                        	  \n");
				// tSQL_1.append("  , DBO.getCompanyNameLoc( SE.HOUSE_CODE,  SE.VENDOR_CODE , 'S') AS VENDOR_NAME        \n");
				// tSQL_1.append("  , EP.UNIT_PRICE                                                                  \n");
				// tSQL_1.append(" FROM ICOYRQDT DT, ICOYRQSE SE, ICOYQTEP EP                                        \n");
				// tSQL_1.append(" WHERE DT.HOUSE_CODE = '"+house_code+"'                                            \n");
				// tSQL_1.append(" AND DT.HOUSE_CODE = SE.HOUSE_CODE                                                 \n");
				// tSQL_1.append(" AND DT.RFQ_NO = SE.RFQ_NO                                                         \n");
				// tSQL_1.append(" AND DT.RFQ_COUNT = SE.RFQ_COUNT                                                   \n");
				// tSQL_1.append(" AND DT.RFQ_SEQ = SE.RFQ_SEQ                                                       \n");
				// tSQL_1.append(" AND DT.PR_NO  = '"+bid_pr_no+"' 												  \n");
				// tSQL_1.append(" AND EP.ITEM_NO  =  '"+item_no+"'												  \n");
				// tSQL_1.append(" AND DT.STATUS != 'D'                                                              \n");
				// tSQL_1.append(" AND SE.STATUS !='D'                                                               \n");
				// tSQL_1.append(" AND SE.BID_FLAG = 'Y'                                                             \n");
				// tSQL_1.append(" AND SE.CONFIRM_FLAG = 'Y'                                                         \n");
				// tSQL_1.append(" AND SE.HOUSE_CODE = EP.HOUSE_CODE                                                 \n");
				// tSQL_1.append(" AND SE.VENDOR_CODE = EP.VENDOR_CODE                                               \n");
				// tSQL_1.append(" AND SE.RFQ_NO = EP.RFQ_NO                                                         \n");
				// tSQL_1.append(" AND SE.RFQ_COUNT = EP.RFQ_COUNT                                                   \n");
				// tSQL_1.append(" AND SE.RFQ_SEQ = EP.RFQ_SEQ                                                       \n");
				// tSQL_1.append(" AND EP.STATUS ! = 'D'                                                             \n");
				// tSQL_1.append(" group by SE.HOUSE_CODE, SE.RFQ_NO,  SE.VENDOR_CODE     , EP.UNIT_PRICE            \n");
				//
				// }else{
				// tSQL.append(" SELECT PRDT.ITEM_NO , PRDT.DESCRIPTION_LOC                                    	\n");
				// tSQL.append(" ,MT.VENDOR_CODE                                                                   \n");
				// tSQL.append(" , DBO.getCompanyNameLoc( PRDT.HOUSE_CODE,MT.VENDOR_CODE   , 'S') AS VENDOR_NAME     	\n");
				// tSQL.append(" , PRDT.UNIT_PRICE                                                                 \n");
				// tSQL.append(" FROM ICOYPRDT PRDT   , ICOMHUMT MT                                                \n");
				// tSQL.append(" WHERE PRDT.HOUSE_CODE = '"+house_code+"'                                          \n");
				// tSQL.append(" AND PRDT.PR_NO =  '"+pr_no+"'														\n");
				// tSQL.append(" AND PRDT.ITEM_NO = '"+item_no+"' 													\n");
				// tSQL.append(" AND PRDT.STATUS ! = 'D'                                  							\n");
				// tSQL.append(" AND PRDT.HOUSE_CODE = MT.HOUSE_CODE                   							\n");
				// tSQL.append(" AND PRDT.ITEM_NO = MT.HUMAN_NO                     								\n");
				// tSQL.append(" AND MT.STATUS ! = 'D'                     										\n");
			}

			sm = new SepoaSQLManager(userid, this, ctx, wxp.getQuery());
			rtn = sm.doSelect((String[]) null);

			SepoaFormater wf = new SepoaFormater(rtn);
			if (wf.getRowCount() == 0) {
				wxp = new SepoaXmlParser(this,
						new Exception().getStackTrace()[0].getMethodName()
								+ "_2");
				wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
				wxp.addVar("bid_pr_no", bid_pr_no);
				wxp.addVar("item_no", item_no);
				sm = new SepoaSQLManager(userid, this, ctx, wxp.getQuery());
				rtn = sm.doSelect((String[]) null);
			}

		} catch (Exception e) {
			Logger.debug.println(userid, this, e.getMessage());
			Logger.debug.println(userid, this, tSQL.toString());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	// public SepoaOut setSendPo( String[][] pr )
	// {
	// try{
	//
	// int rtn = et_setSendPo(pr );
	//
	// if( rtn == -1 )
	// {
	// setStatus(0);
	// setMessage("품의상신이 되지 않았습니다.");
	// }
	// else
	// {
	// setStatus(1);
	// setValue(rtn+"");
	// setMessage("품의상신이 완료되었습니다.\n품의대기현황에서 품의를 생성하십시요.");
	// Commit();
	// }
	// }catch(Exception e) {
	// Logger.err.println(info.getSession("ID"),this,e.getMessage());
	// setStatus(0);
	// setMessage(msg.get("p10_pra.0001").toString());
	// }
	//
	// return getSepoaOut();
	// }
	
//	public SepoaOut setSendPo(Map<String, Object> param) throws Exception {
//		ConnectionContext ctx = null;
//		SepoaXmlParser sxp = null;
//		SepoaSQLManager ssm = null;
//		String id = info.getSession("ID");
//		String houseCode = info.getSession("HOUSE_CODE");
//		List<Map<String, String>> recvdata = (List<Map<String, String>>) param.get("recvdata");
//		Map<String, String> recvdataInfo = null;
//		int recvdataSize = recvdata.size();
//		int i = 0;
//		int rtn = 0;
//
//		setStatus(1);
//		setFlag(true);
//
//		ctx = getConnectionContext();
//		
//		Map<String, String> cnhdMap = null; 
//
//		try {
//			
//			// 기안헤더 강제생성
//			SepoaOut wo = DocumentUtil.getDocNumber(info,"EX");
//			String exec_no = wo.result[0];
//			
//			cnhdMap = new HashMap<String, String>();
//			
//			cnhdMap.put("PR_NO"		, recvdata.get(0).get("PR_NO"));
//			cnhdMap.put("EXEC_NO"	, exec_no);
//			
//			sxp = new SepoaXmlParser(this, "et_setCNHD");
//			ssm = new SepoaSQLManager(id, this, ctx, sxp);
//			rtn = ssm.doInsert(cnhdMap);
//			
//			String prData = "";
//			
//			for (i = 0; i < recvdataSize; i++) {
//				sxp = new SepoaXmlParser(this, "et_setSendPo");
//				ssm = new SepoaSQLManager(id, this, ctx, sxp);
//
//				recvdataInfo = recvdata.get(i);
//
//				recvdataInfo.put("HOUSE_CODE", houseCode);
//
//				rtn = ssm.doUpdate(recvdataInfo);
//
//				// 기안상세 강제생성
//				recvdataInfo.put("EXEC_NO", exec_no);
//				sxp = new SepoaXmlParser(this, "et_setCNDT");
//				ssm = new SepoaSQLManager(id, this, ctx, sxp);
//				rtn = ssm.doInsert(recvdataInfo);	
//				
//				prData += ",'" + recvdataInfo.get("PR_NO") + recvdataInfo.get("PR_SEQ") + "'";
//			}
//			
//			sxp = new SepoaXmlParser(this, "et_setCNDP");
//			sxp.addVar("prData", prData.substring(1));
//			ssm = new SepoaSQLManager(id, this, ctx, sxp.getQuery());
//			rtn = ssm.doInsert(recvdataInfo);
//			
//			if (rtn == -1) {
//				// throw new Exception("품의상신이 되지 않았습니다.");
//				throw new Exception("발주요청이 되지 않았습니다.");
//			} else {
//				// setMessage("품의상신이 완료되었습니다.\n품의대기현황에서 품의를 생성하십시요.");
//				setMessage("발주요청이 완료되었습니다.\n발주대기현황에서 발주를 생성하십시요.");
//			}
//
//			Commit();
//		} catch (Exception e) {
//			Rollback();
//			setStatus(0);
//			setFlag(false);
//			setMessage(e.getMessage());
//			Logger.err.println(info.getSession("ID"), this, e.getMessage());
//		} finally {
//		}
//
//		return getSepoaOut();
//	}
	@SuppressWarnings("unchecked")
	public SepoaOut setSendPo(Map<String, Object> param) throws Exception {
		ConnectionContext ctx = null;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		String id = info.getSession("ID");
		String houseCode = info.getSession("HOUSE_CODE");
		List<Map<String, String>> recvdata = (List<Map<String, String>>) param.get("recvdata");
		Map<String, String> recvdataInfo = null;
		int recvdataSize = recvdata.size();
		int i = 0;
		int rtn = 0;

		SepoaOut wo = null;
		String exec_no = null;
		String prData = "";
					
		setStatus(1);
		setFlag(true);

		ctx = getConnectionContext();
		
		Map<String, String> cnhdMap = null; 

		try {
			
			
			for (i = 0; i < recvdataSize; i++) {
				// 기안헤더 강제생성
				wo = DocumentUtil.getDocNumber(info,"EX");
				exec_no = wo.result[0];
				
				sxp = new SepoaXmlParser(this, "et_setSendPo");
				ssm = new SepoaSQLManager(id, this, ctx, sxp);
				recvdataInfo = recvdata.get(i);
				recvdataInfo.put("HOUSE_CODE", houseCode);
				rtn = ssm.doUpdate(recvdataInfo);
				if (rtn < 0) {
					throw new Exception("발주요청이 되지 않았습니다.");
				} 
				
				//prData += "'" + recvdataInfo.get("PR_NO") + recvdataInfo.get("PR_SEQ") + "'";
				
				cnhdMap = new HashMap<String, String>();
				cnhdMap.put("PR_NO"		, recvdata.get(i).get("PR_NO"));
				cnhdMap.put("PR_SEQ"		, recvdata.get(i).get("PR_SEQ"));
				cnhdMap.put("EXEC_NO"	, exec_no);				
				sxp = new SepoaXmlParser(this, "et_setCNHD");
				//sxp.addVar("prData", prData);
				ssm = new SepoaSQLManager(id, this, ctx, sxp);				
				rtn = ssm.doInsert(cnhdMap);				
				if (rtn < 0) {
					throw new Exception("발주요청이 되지 않았습니다.");
				} 
				
				
				// 기안상세 강제생성
				recvdataInfo.put("EXEC_NO", exec_no);
				sxp = new SepoaXmlParser(this, "et_setCNDT");
				ssm = new SepoaSQLManager(id, this, ctx, sxp);
				rtn = ssm.doInsert(recvdataInfo);	
				if (rtn < 0) {
					throw new Exception("발주요청이 되지 않았습니다.");
				} 
				
				
				
				sxp = new SepoaXmlParser(this, "et_setCNDP");
				//sxp.addVar("prData", prData);
 				ssm = new SepoaSQLManager(id, this, ctx, sxp.getQuery());
 				rtn = ssm.doInsert(recvdataInfo);	
				if (rtn < 0) {
					throw new Exception("발주요청이 되지 않았습니다.");
				} 
			}
			
						
			if (rtn < 0) {
				// throw new Exception("품의상신이 되지 않았습니다.");
				throw new Exception("발주요청이 되지 않았습니다.");
			} else {
				// setMessage("품의상신이 완료되었습니다.\n품의대기현황에서 품의를 생성하십시요.");
				setMessage("발주요청이 완료되었습니다.\n발주대기현황에서 발주를 생성하십시요.");
			}

			Commit();
		} catch (Exception e) {
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		} finally {
		}

		return getSepoaOut();
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut setSendPo2(Map<String, Object> param) throws Exception {
		ConnectionContext ctx = null;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		String id = info.getSession("ID");
		String houseCode = info.getSession("HOUSE_CODE");
		List<Map<String, String>> recvdata = (List<Map<String, String>>) param.get("recvdata");
		Map<String, String> recvdataInfo = null;
		int recvdataSize = recvdata.size();
		int i = 0;
		int rtn = 0;

		SepoaOut wo = null;
		String exec_no = null;
		String prData = "";
					
		setStatus(1);
		setFlag(true);

		ctx = getConnectionContext();
		
		Map<String, String> cnhdMap = null; 

		try {
			
			
			for (i = 0; i < recvdataSize; i++) {				
				// 기안헤더 강제생성
				if(exec_no == null){
					wo = DocumentUtil.getDocNumber(info,"EX");
					exec_no = wo.result[0];
				}
				
				sxp = new SepoaXmlParser(this, "et_setSendPo");
				ssm = new SepoaSQLManager(id, this, ctx, sxp);
				recvdataInfo = recvdata.get(i);
				recvdataInfo.put("HOUSE_CODE", houseCode);
				rtn = ssm.doUpdate(recvdataInfo);
				if (rtn < 0) {
					throw new Exception("발주요청이 되지 않았습니다.");
				} 
				
				//prData += "'" + recvdataInfo.get("PR_NO") + recvdataInfo.get("PR_SEQ") + "'";
				
				cnhdMap = new HashMap<String, String>();
				cnhdMap.put("PR_NO"		, recvdata.get(i).get("PR_NO"));
				cnhdMap.put("PR_SEQ"		, recvdata.get(i).get("PR_SEQ"));
				cnhdMap.put("EXEC_NO"	, exec_no);
				if(i == 0){
					sxp = new SepoaXmlParser(this, "et_setCNHD");
				}else{
					sxp = new SepoaXmlParser(this, "et_setCNHD2");
				}
				//sxp.addVar("prData", prData);
				ssm = new SepoaSQLManager(id, this, ctx, sxp);				
				rtn = ssm.doInsert(cnhdMap);				
				if (rtn < 0) {
					throw new Exception("발주요청이 되지 않았습니다.");
				} 
				
				
				// 기안상세 강제생성
				recvdataInfo.put("EXEC_NO", exec_no);
				sxp = new SepoaXmlParser(this, "et_setCNDT");
				ssm = new SepoaSQLManager(id, this, ctx, sxp);
				rtn = ssm.doInsert(recvdataInfo);	
				if (rtn < 0) {
					throw new Exception("발주요청이 되지 않았습니다.");
				} 
				
				
				if(i == 0){
					sxp = new SepoaXmlParser(this, "et_setCNDP");
				}else{
					sxp = new SepoaXmlParser(this, "et_setCNDP2");
				}
				//sxp.addVar("prData", prData);
 				ssm = new SepoaSQLManager(id, this, ctx, sxp.getQuery());
 				rtn = ssm.doInsert(recvdataInfo);	
				if (rtn < 0) {
					throw new Exception("발주요청이 되지 않았습니다.");
				} 
			}
			
						
			if (rtn < 0) {
				// throw new Exception("품의상신이 되지 않았습니다.");
				throw new Exception("발주요청이 되지 않았습니다.");
			} else {
				// setMessage("품의상신이 완료되었습니다.\n품의대기현황에서 품의를 생성하십시요.");
				setMessage("발주요청이 완료되었습니다.\n발주대기현황에서 발주를 생성하십시요.");
			}

			Commit();
		} catch (Exception e) {
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		} finally {
		}

		return getSepoaOut();
	}
	
	// //////////////////////
	@SuppressWarnings({ "unused", "deprecation" })
	private int et_setSendPo(String[][] pr) throws Exception {
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		int rtn = 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

		try {
			String[] type = { "S", "N", "S", "S" };
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(pr, type);

		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	public SepoaOut setDirectPo(String[][] pr) {
		try {

			int rtn = et_setDirectPo(pr);

			if (rtn == -1) {
				setStatus(0);
				setMessage("직발주 처리 되지 않았습니다.");
			} else {
				setStatus(1);
				setValue(rtn + "");
				setMessage("직발주 처리가 완료되었습니다.\n직발주대상조회에서 발주하십시요.");
				Commit();
			}
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("p10_pra.0001").toString());
		}

		return getSepoaOut();
	}

	// //////////////////////
	@SuppressWarnings({ "unused", "deprecation" })
	private int et_setDirectPo(String[][] pr) throws Exception {
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		int rtn = 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

		try {
			String[] type = { "S", "N", "S", "S" };
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(pr, type);

		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	/**
	 * 청구결재 - 결재모듈에서 호출한다.
	 * 
	 * <pre>
	 * inf.getSignStatus() - D:반려
	 * </pre>
	 * 
	 * @param inf
	 * @return
	 */
	@SuppressWarnings("unused")
	public SepoaOut Approval(SignResponseInfo inf) {
		try {
			String ans = inf.getSignStatus();
			String sapType = "";

			ConnectionContext ctx = getConnectionContext();

			// Logger.debug.println(userid,this,"inf.getSignStatus()===============>"+inf.getSignStatus()+"-------");

			String[] pr_no = inf.getDocNo();
			String signuserid = inf.getSignUserId();
			String signdate = inf.getSignDate();
			String ctrl_reason = inf.getSignRemark();

			// for(int i=0; i<pr_no.length; i++)
			// Logger.debug.println(userid,this,"pr_no["+i+"]==>"+pr_no[i]);

			if (!ctrl_reason.equals("")) {
				ctrl_reason = "결재반려@" + ctrl_reason;
			}

			String flag = "";
			String dc_no = "";
			String rtn_2 = "";
			int res = -1;

			if (inf.getSignStatus() == null)
				ans = "xxxxxxxx";

			// 완료: E, 반려 : R 로 처리
			if (ans.equals("E")) {
				flag = "E";
			} else if (ans.equals("R")) {
				flag = "R";
			}

			String[][] all_pr_no = new String[pr_no.length][1];
			for (int i = 0; i < pr_no.length; i++) {
				String Data[] = { pr_no[i] };
				all_pr_no[i] = Data;
				Logger.debug.println(info.getSession("ID"), this, "all_pr_no["
						+ i + "]==================>" + all_pr_no[i][0]);
			}

			// 결재취소
			if (ans.equals("D")) {
				res = et_setApping_return(all_pr_no);
			} else {
				res = et_setApping(flag, all_pr_no, ctrl_reason, signuserid,
						signdate);
				/*
				 * if(ans.equals("E")){ int rtn =
				 * PoAutoCreate(all_pr_no,signuserid,signdate); }
				 */
			}

			/*
			 * if(flag.equals("E")){ sapType = "I"; }else{ sapType = "D"; }
			 * 
			 * if(sapType.equals("I")){
			 * 
			 * for (int i = 0; i < pr_no.length; i++) {
			 * 
			 * if(et_setKnttp(pr_no[i]) > - 1){
			 * 
			 * Object[] obj = {sapType, pr_no[i]};
			 * 
			 * SepoaOut value = CallNONDBJOB( ctx, "PRTrans", "sendSCI", obj);
			 * 
			 * if(value.status == 0) throw new Exception(value.message);
			 * 
			 * } } }
			 */

			setStatus(1);
		} catch (Exception e) {
			Logger.err.println("setSignStatus: = " + e.getMessage());

			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(userid, this, d.getMessage());
			}
			setValue(e.getMessage().trim());
			setStatus(0);
			setMessage(e.getMessage().trim());
		}
		return getSepoaOut();
	}

	/**
	 * 결재반려
	 * 
	 * <pre>
	 * </pre>
	 * 
	 * @param all_pr_no
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	private int et_setApping_return(String[][] all_pr_no) throws Exception {
		int rtn = -1;
		try {
			String house_code = info.getSession("HOUSE_CODE");

			ConnectionContext ctx = getConnectionContext();

			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			// StringBuffer sql = new StringBuffer();
			// sql.append(" UPDATE ICOYPRHD SET                 \n");
			// sql.append("        CTRL_REASON = '',            \n");
			// sql.append("        SIGN_STATUS = 'D',           \n");
			// sql.append("        SIGN_DATE = '',              \n");
			// sql.append("        SIGN_PERSON_ID = '',         \n");
			// sql.append("        SIGN_PERSON_NAME = ''        \n");
			// sql.append(" WHERE HOUSE_CODE = '"+house_code+"' \n");
			// sql.append(" AND   STATUS != 'D'                 \n");
			// sql.append(" AND   PR_NO = ?                     \n");
			String[] type = { "S" };
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(all_pr_no, type);
		} catch (Exception e) {
			throw new Exception("setSIGN_STATUS:" + e.getMessage());
		}
		return rtn;
	}

	/**
	 * 결재완료.
	 * 
	 * <pre>
	 * </pre>
	 * 
	 * @param flag
	 * @param all_pr_no
	 * @param ctrl_reason
	 * @param signuserid
	 * @param signdate
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unused", "deprecation" })
	private int et_setApping(String flag, String[][] all_pr_no,
			String ctrl_reason, String signuserid, String signdate)
			throws Exception {
		int rtn = -1;

		try {
			String house_code = info.getSession("HOUSE_CODE");

			ConnectionContext ctx = getConnectionContext();

			String rtnSel = getusername(signuserid);
			SepoaFormater wf = new SepoaFormater(rtnSel);
			String signname = wf.getValue(0, 0);
			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("ctrl_reason", ctrl_reason);
			wxp.addVar("flag", flag);
			wxp.addVar("signdate", signdate);
			wxp.addVar("signuserid", signuserid);
			wxp.addVar("house_code", house_code);

			// StringBuffer sql = new StringBuffer();
			// sql.append(" UPDATE ICOYPRHD SET                        \n");
			// sql.append("        CTRL_REASON = '"+ctrl_reason+"',    \n");
			// sql.append("        SIGN_STATUS = '"+flag+"',           \n");
			// sql.append("        SIGN_DATE = '"+signdate+"',         \n");
			// sql.append("        SIGN_PERSON_ID = '"+signuserid+"',  \n");
			// sql.append("        SIGN_PERSON_NAME = dbo.GETUSERNAME(HOUSE_CODE, '"+signuserid+"', 'LOC')   \n");
			// sql.append(" WHERE HOUSE_CODE = '"+house_code+"'        \n");
			// sql.append(" AND   STATUS != 'D'                        \n");
			// sql.append(" AND   PR_NO = ?                            \n");

			String[] type = { "S" };
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(all_pr_no, type);
		} catch (Exception e) {
			throw new Exception("setSIGN_STATUS:" + e.getMessage());
		}

		return rtn;
	}

	@SuppressWarnings("deprecation")
	private String getusername(String ls_id) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		String company = info.getSession("COMPANY_CODE");
		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("company", company);
		wxp.addVar("ls_id", ls_id);

		// StringBuffer sql = new StringBuffer();
		// sql.append(" select user_name_loc from icomlusr     \n");
		// sql.append(" where house_code = '"+house_code+"'    \n");
		// sql.append(" and   company_code ='"+company+"'      \n");
		// sql.append(" and   user_id = '"+ls_id+"'            \n");

		try {
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, wxp.getQuery());
			rtn = sm.doSelect((String[]) null);
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private int PoAutoCreate(String[][] AllPrNo, String sign_user_id,
			String sign_date) throws Exception {

		int rtn = 0;
		int trtn = 0;
		String tmp = "";
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		String user_id = info.getSession("ID");
		String user_dept = info.getSession("DEPARTMENT");
		SepoaSQLManager sm = null;
		SepoaFormater wf = null;
		SepoaFormater owf = null;

		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName() + "_1");

		try {

			// sql.delete(0, sql.length());
			// sql.append(" SELECT Z_AUTO_PO_TYPE					\n");
			// sql.append(" FROM ICOMCMGL							\n");
			// sql.append(" <OPT=F,S>WHERE HOUSE_CODE = ?	</OPT>	\n");
			// sql.append(" <OPT=F,S>AND COMPANY_CODE = ?	</OPT>	\n");

			String[] cargs = { house_code, company_code };
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,
					wxp.getQuery());
			String ctmp = sm.doSelect(cargs);
			wf = new SepoaFormater(ctmp);
			String z_auto_po_type = wf.getValue(0, 0);

			String[] hdtype = { "S", "S" };
			for (int i = 0; i < AllPrNo.length; i++) {
				// String PR_SEQ = String.valueOf(i);
				String PR_NO = AllPrNo[i][0];

				/*
				 * sql.delete(0, sql.length());
				 * sql.append(" SELECT NVL(I.AUTO_PO_FLAG,'N')					\n");
				 * sql.append(" FROM ICOYPRDT P, ICOYINFO I					\n");
				 * sql.append(" <OPT=F,S>WHERE P.HOUSE_CODE = ?	</OPT>		\n");
				 * sql.append(" AND P.HOUSE_CODE = I.HOUSE_CODE				\n");
				 * sql.append(" AND P.COMPANY_CODE = I.COMPANY_CODE			\n");
				 * sql.append
				 * (" AND P.PURCHASE_LOCATION = I.PURCHASE_LOCATION	\n");
				 * sql.append(" AND P.ITEM_NO = I.ITEM_NO						\n");
				 * sql.append(" <OPT=F,S>AND P.PR_NO = ?	</OPT>				\n");
				 * //sql.append(" GROUP BY P.PR_NO, P.PR_SEQ					\n"); if(
				 * z_auto_po_type.equals("INFO") ){
				 * sql.append(" AND I.AUTO_PO_FLAG = 'Y'					\n"); }
				 * 
				 * String[] iargs = {house_code, PR_NO}; sm = new
				 * SepoaSQLManager
				 * (info.getSession("ID"),this,ctx,sql.toString()); String itmp
				 * = sm.doSelect(iargs); owf = new SepoaFormater(itmp); String
				 * infoFlag = ""; if( owf.getRowCount() > 0 ){ infoFlag =
				 * owf.getValue(0,0); }else{ trtn = 0; return trtn; }
				 * 
				 * //직발주형태가 'PR'이고 INFO가 존재하면 직발주 생성 //직발주형태가 'INFO'이고 INFO의
				 * 직발주여부가 'Y'이면 직발주 생성 // 그 이외의 경우 return if(
				 * z_auto_po_type.equals("PR") && infoFlag.equals("") ){ trtn =
				 * 0; return trtn; } if( z_auto_po_type.equals("INFO") && (
				 * infoFlag.equals("") || infoFlag.equals("N") ) ){ trtn = 0;
				 * return trtn; }
				 */

				wxp = new SepoaXmlParser(this,
						new Exception().getStackTrace()[0].getMethodName()
								+ "_2");
				wxp.addVar("z_auto_po_type", z_auto_po_type);
				// 1. 발주번호 채번
				String po_no = "";
				// SepoaOut wo = appcommon.getDocNumber(info,"POD","H");
				SepoaOut wo = DocumentUtil.getDocNumber(info, "POD");
				if (wo.status == 1)// 성공
				{
					po_no = wo.result[0];
					Logger.debug.println(info.getSession("ID"), this,
							"채번번호====>" + po_no);
				} else {// 실패
					Logger.debug.println(info.getSession("ID"), this,
							"Message====>" + wo.message);
					trtn = 0;
					return trtn;
				}

				// 직발주형태가 'PR'이고 INFO가 존재하면 직발주 생성
				// 직발주형태가 'INFO'이고 INFO의 직발주여부가 'Y'이면 직발주 생성

				// 지금은 MAX(VENDOR_CODE)를 가져오지만
				// 향후 INFO에 VENDOR_CODE가 복수개가 존재하면 직발주 생성하지 않게 바꾸자.
				// sql.delete(0, sql.length());
				// sql.append(" SELECT P.PR_SEQ, MAX(I.VENDOR_CODE) AS VENDOR, \n");
				// sql.append("	MAX(I.UNIT_PRICE) AS UNIT					\n");
				// sql.append(" FROM ICOYPRDT P, ICOYINFO I					\n");
				// sql.append(" <OPT=F,S>WHERE P.HOUSE_CODE = ?	</OPT>		\n");
				// sql.append(" AND P.HOUSE_CODE = I.HOUSE_CODE				\n");
				// sql.append(" AND P.COMPANY_CODE = I.COMPANY_CODE			\n");
				// sql.append(" AND P.PURCHASE_LOCATION = I.PURCHASE_LOCATION	\n");
				// sql.append(" AND P.ITEM_NO = I.ITEM_NO						\n");
				// sql.append(" <OPT=F,S>AND P.PR_NO = ?	</OPT>				\n");
				// if( z_auto_po_type.equals("INFO") ){
				// sql.append(" AND I.AUTO_PO_FLAG = 'Y'					\n");
				// }
				// sql.append(" AND P.STATUS <> 'D'     						\n");
				// sql.append(" AND I.STATUS <> 'D'     						\n");
				// sql.append(" GROUP BY P.PR_NO, P.PR_SEQ						\n");

				String[] args = { house_code, PR_NO };
				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,
						wxp.getQuery());
				tmp = sm.doSelect(args);

				wf = new SepoaFormater(tmp);

				for (int j = 0; j < wf.getRowCount(); j++) {
					String PR_SEQ = wf.getValue("PR_SEQ", j);
					String VENDOR_CODE = wf.getValue("VENDOR", j);
					String UNIT_PRICE = wf.getValue("UNIT", j);
					String PO_SEQ = String.valueOf(j);

					// ICOYPODT Create
					insert_ICOYPODT(po_no, PO_SEQ, UNIT_PRICE, VENDOR_CODE,
							PR_NO, PR_SEQ, z_auto_po_type);
				}

				if (wf.getRowCount() > 0) {
					wxp = new SepoaXmlParser(this,
							new Exception().getStackTrace()[0].getMethodName()
									+ "_3");
					wxp.addVar("z_auto_po_type", z_auto_po_type);
					// ICOYPOHD Create
					// sql2.delete(0, sql2.length()); app2.delete(0,
					// app2.length());
					// sql2.append(" INSERT INTO ICOYPOHD (\n");
					// app2.append(" SELECT                                            \n");
					// sql2.append("   HOUSE_CODE          \n");
					// app2.append("   POD.HOUSE_CODE                     				\n");
					// sql2.append(" , PO_NO               \n");
					// app2.append(" , POD.PO_NO                               		\n");
					// sql2.append(" , STATUS              \n");
					// app2.append(" , 'C'                                   	 		\n");
					// sql2.append(" , ADD_DATE            \n");
					// app2.append(" , POD.ADD_DATE                         			\n");
					// sql2.append(" , ADD_TIME            \n");
					// app2.append(" , POD.ADD_TIME                         			\n");
					// sql2.append(" , ADD_USER_ID         \n");
					// app2.append(" , POD.ADD_USER_ID                   				\n");
					// sql2.append(" , CHANGE_DATE         \n");
					// app2.append(" , POD.CHANGE_DATE                   				\n");
					// sql2.append(" , CHANGE_TIME         \n");
					// app2.append(" , POD.CHANGE_TIME                   				\n");
					// sql2.append(" , CHANGE_USER_ID      \n");
					// app2.append(" , POD.CHANGE_USER_ID             					\n");
					// sql2.append(" , CONFIRM_DATE        \n");
					// app2.append(" , '' -- CONFIRM_DATE                              \n");
					// sql2.append(" , CONFIRM_TIME        \n");
					// app2.append(" , '' -- CONFIRM_TIME                              \n");
					// sql2.append(" , CONFIRM_USER_ID     \n");
					// app2.append(" , '' -- CONFIRM_USER_ID                           \n");
					// sql2.append(" , COMPANY_CODE        \n");
					// app2.append(" , POD.COMPANY_CODE                 				\n");
					// sql2.append(" , PLANT_CODE          \n");
					// app2.append(" , POD.PLANT_CODE                     				\n");
					// sql2.append(" , PO_CREATE_DATE      \n");
					// app2.append(" , POD.ADD_DATE     -- PO_CREATE_DATE              \n");
					// sql2.append(" , VENDOR_CODE         \n");
					// app2.append(" , POD.VENDOR_CODE                   				\n");
					// sql2.append(" , ACCOUNT_TYPE        \n");
					// app2.append(" , '' -- ACCOUNT_TYPE                              \n");
					// sql2.append(" , PROCESS_TYPE        \n");
					// app2.append(" , '' -- PROCESS_TYPE                              \n");
					// sql2.append(" , SHIPPER_TYPE        \n");
					// app2.append(" , PD.SHIPPER_TYPE                  				\n");
					// sql2.append(" , PAY_TERMS           \n");
					// app2.append(" , IF.PAY_TERMS                                    \n");
					// sql2.append(" , DELY_TERMS          \n");
					// app2.append(" , IF.DELY_TERMS                                   \n");
					// sql2.append(" , CUR                 \n");
					// app2.append(" , PD.CUR -- CUR                                   \n");
					// sql2.append(" , PO_TTL_AMT          \n");
					// app2.append(" , (SELECT SUM(ITEM_AMT) FROM ICOYPODT             \n");
					// app2.append("     WHERE HOUSE_CODE	= POD.HOUSE_CODE            \n");
					// app2.append("       AND PO_NO = POD.PO_NO ) -- PO_TTL_AMT       \n");
					// sql2.append(" , CTRL_CODE           \n");
					// app2.append(" , PD.CTRL_CODE                        			\n");
					// sql2.append(" , PURCHASER_ID        \n");
					// app2.append(" , PD.PURCHASER_ID                  				\n");
					// sql2.append(" , PURCHASER_NAME      \n");
					// app2.append(" , PD.PURCHASER_NAME 								\n");
					// sql2.append(" , EMAIL_FLAG          \n");
					// app2.append(" , 'N' -- EMAIL_FLAG                               \n");
					// sql2.append(" , COMPLETE_MARK       \n");
					// app2.append(" , 'N' -- COMPLETE_MARK                            \n");
					// sql2.append(" , PO_TYPE             \n");
					// app2.append(" , 'B' -- PO_TYPE                                  \n");
					// sql2.append(" , SIGN_STATUS         \n");
					// app2.append(" , 'E'                                    			\n");
					// //-- SIGN_STATUS
					// sql2.append(" , SIGN_DATE           \n");
					// app2.append(" , POD.ADD_DATE -- SIGN_DATE                       \n");
					// sql2.append(" , SIGN_PERSON_ID      \n");
					// app2.append(" , '' -- SIGN_PERSON_ID                            \n");
					// sql2.append(" , ATTACH_NO           \n");
					// app2.append(" , '' -- ATTACH_NO                                 \n");
					// sql2.append(" , GR_BASE_FLAG        \n");
					// app2.append(" , (SELECT GR_BASE_FLAG FROM ICOMVNPU              \n");
					// app2.append("    WHERE HOUSE_CODE = POD.HOUSE_CODE              \n");
					// app2.append("    AND COMPANY_CODE = POD.COMPANY_CODE            \n");
					// app2.append("    AND VENDOR_CODE = POD.VENDOR_CODE)             \n");//--
					// GR_BASE_FLAG
					// sql2.append(" , ACCOUNT_CODE        \n");
					// app2.append(" , PD.ACCOUNT_CODE                  				\n");
					// sql2.append(" , BANK_CTRL_CODE      \n");
					// app2.append(" , '' -- BANK_CTRL_CODE                            \n");
					// sql2.append(" , FUND_FLAG           \n");
					// app2.append(" , '' -- FUND_FLAG                                 \n");
					// sql2.append(" , MAIL_SEND_NO        \n");
					// app2.append(" , '' -- MAIL_SEND_NO                              \n");
					// sql2.append(" , MAIL_SEND_DATE      \n");
					// app2.append(" , '' -- MAIL_SEND_DATE                            \n");
					// sql2.append(" , MAIL_SEND_TIME      \n");
					// app2.append(" , '' -- MAIL_SEND_TIME                            \n");
					// sql2.append(" , DELY_TO_LOCATION    \n");
					// app2.append(" , PD.DELY_TO_LOCATION-- DELY_TO_LOCATION          \n");
					// sql2.append(" , DELY_TO_ADDRESS     \n");
					// app2.append(" , PD.DELY_TO_ADDRESS-- DELY_TO_ADDRESS            \n");
					// sql2.append(" , PAY_TEXT            \n");
					// app2.append(" , GETICOMCODE2(IF.HOUSE_CODE,'M010',IF.PAY_TERMS)	\n");//PAY_TEXT
					// sql2.append(" ) (                   \n");
					// app2.append(" FROM ICOYPODT POD                                 \n");
					// app2.append("    , ICOYPRDT PD, ICOYINFO IF                     \n");
					// app2.append(" WHERE POD.HOUSE_CODE	= ?            				\n");
					// app2.append("   AND POD.PO_NO		= ?            				\n");
					// app2.append("   AND POD.PO_SEQ		= '000001'     				\n");
					// app2.append("   AND POD.STATUS 		IN ('C','R')   				\n");
					// app2.append("   AND POD.HOUSE_CODE	= PD.HOUSE_CODE				\n");
					// app2.append("   AND POD.PR_NO		= PD.PR_NO     				\n");
					// app2.append("   AND POD.PR_SEQ		= PD.PR_SEQ    				\n");
					// app2.append("   AND PD.STATUS 		IN ('C','R')   				\n");
					// app2.append("   AND POD.HOUSE_CODE	= IF.HOUSE_CODE             \n");
					// app2.append("   AND POD.COMPANY_CODE= IF.COMPANY_CODE           \n");
					// app2.append("   AND POD.PURCHASE_LOCATION= IF.PURCHASE_LOCATION \n");
					// app2.append("   AND POD.ITEM_NO		= IF.ITEM_NO		        \n");
					// app2.append("   AND POD.VENDOR_CODE	= IF.VENDOR_CODE	        \n");
					// if( z_auto_po_type.equals("INFO") ){
					// app2.append(" 	AND IF.AUTO_PO_FLAG = 'Y'						\n");
					// }
					// app2.append(" )                                    				\n");
					// sql2.append(app2.toString());

					sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,
							wxp.getQuery());
					String[][] hdargs = { { house_code, po_no } };
					trtn = sm.doInsert(hdargs, hdtype);

				}// end of - if( prhd Create )

			}// end of - for( AllPrNo )

			// Commit();

		} catch (Exception exception) {
			trtn = -1;
			// Rollback();
			Logger.debug.println(info.getSession("ID"), this,
					"Exception==========" + exception.getMessage());
		} finally {
		}
		return trtn;
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private void insert_ICOYPODT(String po_no, String PO_SEQ,
			String UNIT_PRICE, String VENDOR_CODE, String PR_NO, String PR_SEQ,
			String z_auto_po_type) throws Exception {
		int rtn = -1;
		String user_id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");

		ConnectionContext ctx = getConnectionContext();
		SepoaSQLManager sm = null;
		// StringBuffer sql = new StringBuffer();
		// StringBuffer app = new StringBuffer();
		// StringBuffer tsql = new StringBuffer();

		String[] type = { "S", "S", "S", "S", "S", "S", "S", "S", "S", "S" };
		String[] type1 = { "S", "S", "S", "S", "S" };

		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("z_auto_po_type", z_auto_po_type);
		try {
			// sql.delete(0, sql.length()); app.delete(0, app.length());
			// sql.append( "INSERT INTO ICOYPODT(      	 \n");
			// app.append(" 	( SELECT                            \n");
			// sql.append(" 	  HOUSE_CODE                 \n");
			// app.append(" 	P.HOUSE_CODE						\n");
			// sql.append(" 	, PO_NO                      \n");
			// app.append(" 	,?              					\n");
			// sql.append(" 	, PO_SEQ                     \n");
			// app.append(" 	,?     								\n");
			// sql.append(" 	, STATUS                     \n");
			// app.append(" 	,'C'           						\n");
			// sql.append(" 	, ADD_DATE                   \n");
			// app.append(" 	,TO_CHAR(SYSDATE,'YYYYMMDD')		\n");
			// sql.append(" 	, ADD_TIME                   \n");
			// app.append(" 	,TO_CHAR(SYSDATE,'HH24MISS')        \n");
			// sql.append(" 	, ADD_USER_ID                \n");
			// app.append(" 	,?        							\n");
			// sql.append(" 	, CHANGE_DATE                \n");
			// app.append(" 	,TO_CHAR(SYSDATE,'YYYYMMDD')		\n");
			// sql.append(" 	, CHANGE_TIME                \n");
			// app.append(" 	,TO_CHAR(SYSDATE,'HH24MISS')		\n");
			// sql.append(" 	, CHANGE_USER_ID             \n");
			// app.append(" 	,?       							\n");
			// sql.append(" 	, COMPANY_CODE               \n");
			// app.append(" 	,P.COMPANY_CODE      				\n");
			// sql.append(" 	, PLANT_CODE                 \n");
			// app.append(" 	,P.PLANT_CODE						\n");
			// sql.append(" 	, VENDOR_CODE                \n");
			// app.append(" 	,IF.VENDOR_CODE     				\n");
			// sql.append(" 	, ITEM_NO                    \n");
			// app.append(" 	,P.ITEM_NO    						\n");
			// sql.append(" 	, PURCHASE_LOCATION          \n");
			// app.append(" 	,P.PURCHASE_LOCATION  				\n");
			// sql.append(" 	, MAKER_CODE                 \n");
			// app.append(" 	,P.PO_VENDOR_CODE      				\n");
			// sql.append(" 	, MAKER_NAME                 \n");
			// app.append(" 	,GETVENDORNAME(P.HOUSE_CODE, P.PO_VENDOR_CODE)\n");
			// sql.append(" 	, UNIT_MEASURE               \n");
			// app.append(" 	,P.UNIT_MEASURE      				\n");
			// sql.append(" 	, ITEM_QTY                   \n");
			// app.append(" 	,P.PR_QTY       					\n");
			// sql.append(" 	, UNIT_PRICE                 \n");
			// app.append(" 	,? 									\n");
			// sql.append(" 	, ITEM_AMT                   \n");
			// app.append(" 	,TRUNC((? * P.PR_QTY),0)			\n");
			// sql.append(" 	, RD_DATE                    \n");
			// app.append(" 	,P.RD_DATE     						\n");
			// sql.append(" 	, VENDOR_ITEM_NO             \n");
			// app.append(" 	,M.MAKER_ITEM_NO     				\n");
			// sql.append(" 	, COMPLETE_MARK              \n");
			// app.append(" 	,'N'								\n");
			// sql.append(" 	, PR_NO                      \n");
			// app.append(" 	,P.PR_NO    						\n");
			// sql.append(" 	, PR_SEQ                     \n");
			// app.append(" 	,P.PR_SEQ       					\n");
			// sql.append(" 	, INVEST_NO                  \n");
			// app.append(" 	,P.INVEST_NO						\n");
			// sql.append(" 	, INSPECT_TYPE               \n");
			// app.append(" 	,M.INSPECT_TYPE						\n");
			// sql.append(" 	, PREV_UNIT_PRICE            \n");
			// app.append(" 	,P.PREV_UNIT_PRICE					\n");
			// sql.append(" 	, DO_FLAG                    \n");
			// app.append(" 	,P.DO_FLAG             				\n");
			// sql.append(" 	, PR_DEPT                    \n");
			// app.append(" 	,GETDEPTCODEBYID(P.HOUSE_CODE, P.COMPANY_CODE,P.CHANGE_USER_ID)	\n");
			// sql.append(" 	, PR_USER_ID                 \n");
			// app.append(" 	,P.CHANGE_USER_ID					\n");
			// sql.append(" 	, INV_COMPLETE_FLAG          \n");
			// app.append(" 	,'N'       							\n");
			// sql.append(" 	, COMPLETE_GR_MARK           \n");
			// app.append(" 	,'N'  								\n");
			// sql.append(" 	, REPAIR_FLAG                \n");
			// app.append(" 	,'N'            					\n");
			// sql.append(" 	, ACCOUNT_CODE               \n");
			// app.append(" 	,P.ACCOUNT_CODE       				\n");
			// sql.append(" 	, DELY_TO_ADDRESS            \n");
			// app.append(" 	,P.DELY_TO_ADDRESS					\n");
			// sql.append(" 	, DESCRIPTION_ENG            \n");
			// app.append(" 	,P.DESCRIPTION_ENG					\n");
			// sql.append(" 	, DESCRIPTION_LOC            \n");
			// app.append(" 	,P.DESCRIPTION_LOC					\n");
			// sql.append(" 	, SPECIFICATION              \n");
			// app.append(" 	,P.SPECIFICATION					\n");
			// sql.append(" 	, DELY_TO_LOCATION           \n");
			// app.append(" 	,P.DELY_TO_LOCATION 		      	\n");
			// sql.append("	, STR_FLAG                   \n");
			// app.append("   ,P.STR_FLAG     						\n");
			// sql.append("	, SHIPPER_TYPE               \n");
			// app.append("   ,P.SHIPPER_TYPE         				\n");
			// sql.append("    , Z_WORK_STAGE_FLAG          \n");
			// app.append("   ,P.Z_WORK_STAGE_FLAG               	\n");
			// sql.append("    , Z_DELIVERY_CONFIRM_FLAG    \n");
			// app.append("   ,P.Z_DELIVERY_CONFIRM_FLAG         	\n");
			// sql.append("    , Z_CODE1                    \n");
			// app.append("   ,P.Z_CODE1                 	        	\n");
			// sql.append("    , Z_CODE2                    \n");
			// app.append("   ,P.Z_CODE2                 	        	\n");
			// sql.append("    , Z_CODE3                    \n");
			// app.append("   ,P.Z_CODE3                 	        	\n");
			// sql.append("    , Z_CODE4                    \n");
			// app.append("   ,P.Z_CODE4                 	        	\n");
			// sql.append("    , Z_LOI_FLAG		         \n");
			// app.append("   ,'Y'		              					\n");
			// sql.append("    , QI_FLAG		             \n");
			// app.append("   ,M.QI_FLAG		           	       		\n");
			// sql.append(" )								 \n");
			// app.append("	FROM ICOYPRDT P,ICOMMTGL M, ICOYINFO IF	\n");
			// app.append("   	WHERE P.HOUSE_CODE	= M.HOUSE_CODE  	\n");
			// app.append("   	AND P.ITEM_NO		= M.ITEM_NO     	\n");
			// app.append("   	AND P.HOUSE_CODE	= IF.HOUSE_CODE     \n");
			// app.append("   	AND P.COMPANY_CODE= IF.COMPANY_CODE     \n");
			// app.append("   	AND P.PURCHASE_LOCATION= IF.PURCHASE_LOCATION \n");
			// app.append("   	AND P.ITEM_NO		= IF.ITEM_NO		\n");
			// app.append("   	AND IF.VENDOR_CODE = ?					\n");
			// app.append("   	AND P.HOUSE_CODE	= ?             	\n");
			// app.append("   	AND P.STATUS IN ('C','R')         		\n");
			// app.append("   	AND P.PR_NO			= ?             	\n");
			// app.append("   	AND P.PR_SEQ		= ?             	\n");
			// if( z_auto_po_type.equals("INFO") ){
			// app.append(" 	AND IF.AUTO_PO_FLAG = 'Y'				\n");
			// }
			// app.append("   )                                   		\n");
			// sql.append(app.toString());

			String[][] dtargs = { { po_no, PO_SEQ, user_id, user_id,
					UNIT_PRICE, UNIT_PRICE, VENDOR_CODE, house_code, PR_NO,
					PR_SEQ } };

			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,
					wxp.getQuery());
			rtn = sm.doInsert(dtargs, type);

			// tsql.delete(0, tsql.length());
			// tsql.append( " UPDATE ICOYPRDT						\n");
			// tsql.append( "    SET PO_VENDOR_CODE     = ?    	\n");
			// tsql.append( "       ,PO_UNIT_PRICE    = ?      	\n");
			// tsql.append( "       ,PR_PROCEEDING_FLAG = 'B'   	\n");
			// tsql.append( " WHERE  HOUSE_CODE	    = ?     	\n");
			// tsql.append( " AND	  PR_NO		        = ?     	\n");
			// tsql.append( " AND	  PR_SEQ		    = ?     	\n");
			// tsql.append( " AND	  STATUS <> 'D'     			\n");
			//
			// String[][] prargs = { {
			// VENDOR_CODE, UNIT_PRICE, house_code, PR_NO, PR_SEQ }
			// };
			//
			// sm = new SepoaSQLManager(user_id,this,ctx,tsql.toString());
			// rtn = sm.doUpdate(prargs, type1);

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

	}

	@SuppressWarnings({ "unused", "deprecation" })
	private int et_setKnttp(String pr_no) {

		int result = -1;
		try {
			String rtn = "";

			String house_code = "";
			String doc_no = "";

			SepoaSQLManager sm = null;

			ConnectionContext ctx = getConnectionContext();
			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("pr_no", pr_no);
			// StringBuffer tSQL1 = new StringBuffer();

			// tSQL1.append(" SELECT	ISNULL(SALES_TYPE,'') AS SALES_TYPE 							\n");
			// tSQL1.append(" FROM ICOYPRHD 								\n");
			// tSQL1.append(" WHERE HOUSE_CODE	= '100'						\n");
			// tSQL1.append(" 	AND PR_NO = '"+pr_no+"'						\n");

			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,
					wxp.getQuery());

			rtn = sm.doSelect((String[]) null);
			SepoaFormater wf1 = new SepoaFormater(rtn);
			String sales_type = wf1.getValue(0, 0);

			if (!sales_type.equals("A")) {
				result = 100;
			}

		} catch (Exception e) {
			result = -1;
			setMessage(e.getMessage());
		}
		return result;
	}

	@SuppressWarnings("null")
	public SepoaOut CallNONDBJOB(ConnectionContext ctx, String serviceId,
			String MethodName, Object[] obj) {

		String conType = "NONDBJOB"; // conType :
										// CONNECTION/TRANSACTION/NONDBJOB

		SepoaOut value = null;
		SepoaRemote wr = null;

		// 다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
		try {

			wr = new SepoaRemote(serviceId, conType, info);
			wr.setConnection(ctx);

			value = wr.lookup(MethodName, obj);

		} catch (SepoaServiceException wse) {
//			try {
				Logger.err.println("wse	= " + wse.getMessage());
//				Logger.err.println("message	= " + value.message);
//				Logger.err.println("status = " + value.status);
//			} catch (NullPointerException ne) {
//
//			}
		} catch (Exception e) {
//			try {
				Logger.err.println("err	= " + e.getMessage());
//				Logger.err.println("message	= " + value.message);
//				Logger.err.println("status = " + value.status);
//			} catch (NullPointerException ne) {
//
//			}
		}

		return value;
	}

	public SepoaOut getPrDTDisplay_VAT(Map<String, String> header) {
		String rtnData = null;
		try {
			rtnData = et_getPrDTDisplay_VAT(header);

			setStatus(1);
			setValue(rtnData);
			setMessage(msg.get("p10_pra.0000").toString());
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("p10_pra.0001").toString());
		}
		return getSepoaOut();
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private String et_getPrDTDisplay_VAT(Map<String, String> header)
			throws Exception {

		String REQ_PR_SEQ = header.get("REQ_PR_SEQ");
		String ITEM_FIND = header.get("ITEM_FIND");
		String pr_no = header.get("PR_NO");
		String addStrSql = "";

		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		String query = "AND (";
		StringBuffer sql = new StringBuffer();

		try {
			if (REQ_PR_SEQ == null || REQ_PR_SEQ.equals("")) {
				addStrSql = "AND   HD.PR_NO      = '" + pr_no + "'    ";
			} else {
				String pr_no_values = "";
				String pr_seq_values = "";
				StringTokenizer st1 = new StringTokenizer(REQ_PR_SEQ, ",");
				Logger.debug.println(info.getSession("ID"), this,
						"REQ_PR_SEQ==>" + REQ_PR_SEQ);

				int count1 = st1.countTokens();
				Logger.debug.println(info.getSession("ID"), this, "count1==>"
						+ count1);

				String[] REQ_PR_SEQ_ARRAY1 = new String[count1];
				for (int j = 0; j < count1; j++) {
					REQ_PR_SEQ_ARRAY1[j] = st1.nextToken();
					StringTokenizer st2 = new StringTokenizer(
							REQ_PR_SEQ_ARRAY1[j], "-");
					String[][] REQ_PR_SEQ_ARRAY2 = new String[count1][2];
					for (int i = 0; i < 2; i++) {
						REQ_PR_SEQ_ARRAY2[j][i] = st2.nextToken();
					}
					if (j < count1 - 1) {
						query += " DT.PR_NO ='" + REQ_PR_SEQ_ARRAY2[j][0]
								+ "' AND DT.PR_SEQ = '"
								+ REQ_PR_SEQ_ARRAY2[j][1] + "' OR";
					} else {
						query += " DT.PR_NO ='" + REQ_PR_SEQ_ARRAY2[j][0]
								+ "' AND DT.PR_SEQ = '"
								+ REQ_PR_SEQ_ARRAY2[j][1] + "') \n";
					}
				}
				addStrSql = query;
				addStrSql += "	AND   HD.HOUSE_CODE = DT.HOUSE_CODE \n";
				addStrSql += "	AND   HD.PR_NO      = DT.PR_NO ";

				// sql.append(query);
				// sql.append(" AND   HD.HOUSE_CODE = DT.HOUSE_CODE                                                              \n");
				// sql.append(" AND   HD.PR_NO      = DT.PR_NO                                                                   \n");
				if (ITEM_FIND == null || ITEM_FIND.equals("")) {
					// sql.append(" AND   DT.BID_STATUS IN ('PR', 'CC', 'NB')                                                                   \n");
				}
			}

			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("addStrSql", addStrSql);

			SepoaSQLManager sm = new SepoaSQLManager(userid, this, ctx,
					wxp.getQuery());

			rtn = sm.doSelect((String[]) null);
		} catch (Exception e) {

			Logger.err.println(userid, this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	// 사전지원요청 접수
	public SepoaOut doConfirm(String[][] pr) {
		try {

			int rtn = et_doConfirm(pr);

			if (rtn == -1) {
				setStatus(0);
				setMessage("접수가 실패하였습니다.");
			} else {
				setStatus(1);
				setValue(rtn + "");
				setMessage("접수가 완료되었습니다.");
				Commit();
			}
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("p10_pra.0001").toString());
		}

		return getSepoaOut();
	}

	// //////////////////////
	@SuppressWarnings("deprecation")
	private int et_doConfirm(String[][] pr) throws Exception {
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		int rtn = 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("user_id", user_id);

		try {
			String[] type = { "S", "S" };
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(pr, type);

		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	// 구매요청 수정시 품목에 대한 INSERT, UPDATE
	@SuppressWarnings({ "unused", "deprecation" })
	private int et_setPrChange(ConnectionContext ctx, String[] pr_dt,
			String IU_FLAG) throws Exception {
		int rtn = 0;

		String add_date = SepoaDate.getShortDateString();
		String add_time = SepoaDate.getShortTimeString();
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		String add_user_id = info.getSession("ID");

		try {
			SepoaXmlParser wxp = null;
			SepoaSQLManager sm = null;
			Logger.debug.println("정상현 IU_FLAG : " + IU_FLAG);
			if ("I".equals(IU_FLAG)) { // INSERT 건 인서트시 맥스값 +1 로 PR_SEQ 채번
				wxp = new SepoaXmlParser(this,
						new Exception().getStackTrace()[0].getMethodName()
								+ "_insert");
				wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
				wxp.addVar("user_id", info.getSession("ID"));
				sm = new SepoaSQLManager(add_user_id, this, ctx, wxp.getQuery());
				String[] type = { "S", "S", "S", "S", "S", "S", "S", "S", "S",
						"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
						"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
						"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
						"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S" }; // 53
				String[][] args = { pr_dt };
				rtn = sm.doUpdate(args, type);
			} else if ("U".equals(IU_FLAG)) {
				wxp = new SepoaXmlParser(this,
						new Exception().getStackTrace()[0].getMethodName()
								+ "_update");
				wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
				wxp.addVar("user_id", info.getSession("ID"));
				sm = new SepoaSQLManager(add_user_id, this, ctx, wxp.getQuery());
				String[] type = { "S", "S", "S", "S", "S", "S", "S", "S", "S",
						"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
						"S" };// 19
				String[][] args = { pr_dt };
				rtn = sm.doUpdate(args, type);
			}

		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	// 구매요청 수정시 품목에 대한 DELETE
	@SuppressWarnings({ "unused", "deprecation" })
	private int et_setPrDelete(ConnectionContext ctx, String deledtePrData)
			throws Exception {
		Logger.debug.println("정상현 deledtePrData ; " + deledtePrData);
		int rtn = 0;

		String add_date = SepoaDate.getShortDateString();
		String add_time = SepoaDate.getShortTimeString();
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		String add_user_id = info.getSession("ID");

		String where = "";
		// pr_data 화면 그리드에 있는 PR_NO-PR_SEQ,PR_NO-PR_SEQ

		String[] row = deledtePrData.split(",");
		for (int i = 0; i < row.length; i++) {
			String[] pr_data = row[i].split("-");
			if (i == row.length - 1) {
				where += " PR_NO = '" + pr_data[0] + "' AND PR_SEQ = '"
						+ pr_data[1] + "'    ";
			} else {
				where += " PR_NO = '" + pr_data[0] + "' AND PR_SEQ = '"
						+ pr_data[1] + "'  OR";
			}

		}

		where = "\n AND (" + where + ")";

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

			SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx,
					wxp.getQuery() + where);
			rtn = sm.doUpdate();
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	// 영업관리 구매요청 수정 후 결과 인터페이스
	@SuppressWarnings({ "unused", "deprecation" })
	private int scms_interface(ConnectionContext ctx, String pr_no,
			String req_type) throws Exception {
		String house_code = info.getSession("HOUSE_CODE");
		int rtn = 0;
		String str = "";
		SepoaFormater wf = null;
		try {
			SepoaXmlParser wxp = null;
			SepoaSQLManager sm = null;

			if ("B".equals(req_type)) {

				// TB_SCM_BR.REPEAT_YN 조회
				wxp = new SepoaXmlParser(this,
						new Exception().getStackTrace()[0].getMethodName()
								+ "_TB_SCM_BR_SELECT");
				wxp.addVar("pr_no", pr_no);
				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,
						wxp.getQuery());
				str = sm.doSelect((String[]) null);
				wf = new SepoaFormater(str);

				// TB_SCM_BR 삭제
				wxp = new SepoaXmlParser(this,
						new Exception().getStackTrace()[0].getMethodName()
								+ "_TB_SCM_BR_DELETE");
				wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
				wxp.addVar("pr_no", pr_no);
				wxp.addVar("req_type", req_type);
				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,
						wxp.getQuery());
				rtn = sm.doUpdate();

				// TB_SCM_BR 인서트
				wxp = new SepoaXmlParser(this,
						new Exception().getStackTrace()[0].getMethodName()
								+ "_TB_SCM_BR_INSERT");
				wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
				wxp.addVar("pr_no", pr_no);
				wxp.addVar("req_type", req_type);
				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,
						wxp.getQuery());
				rtn = sm.doUpdate();

				// TB_SCM_BR 업데이트(REPEAT_YN = 'Y' 인경인경우, ICOYPRDT에는 REPEAT_YN 가
				// 없기 때문에 삭제 후 인서트하면 값이 사라진다.)
				if (wf.getRowCount() > 0) {
					wxp = new SepoaXmlParser(this,
							new Exception().getStackTrace()[0].getMethodName()
									+ "_TB_SCM_BR_UPDATE");
					sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,
							wxp.getQuery());
					String[][] data = new String[wf.getRowCount()][];
					for (int i = 0; i < data.length; i++) {
						String[] temp_data = { wf.getValue("BR_NO", i),
								wf.getValue("BR_SEQ", i) };
						data[i] = temp_data;
					}
					String[] type = { "S", "S" };
					rtn = sm.doUpdate(data, type);
				}

			} else if ("P".equals(req_type)) {

				// TB_SCM_PR.REPEAT_YN 조회
				wxp = new SepoaXmlParser(this,
						new Exception().getStackTrace()[0].getMethodName()
								+ "_TB_SCM_PR_SELECT");
				wxp.addVar("pr_no", pr_no);
				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,
						wxp.getQuery());
				str = sm.doSelect((String[]) null);
				wf = new SepoaFormater(str);

				// TB_SCM_PR 삭제
				wxp = new SepoaXmlParser(this,
						new Exception().getStackTrace()[0].getMethodName()
								+ "_TB_SCM_PR_DELETE");
				wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
				wxp.addVar("pr_no", pr_no);
				wxp.addVar("req_type", req_type);
				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,
						wxp.getQuery());
				rtn = sm.doUpdate();

				// TB_SCM_PR 인서트
				wxp = new SepoaXmlParser(this,
						new Exception().getStackTrace()[0].getMethodName()
								+ "_TB_SCM_PR_INSERT");
				wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
				wxp.addVar("pr_no", pr_no);
				wxp.addVar("req_type", req_type);
				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,
						wxp.getQuery());
				rtn = sm.doUpdate();

				// TB_SCM_PR 업데이트(REPEAT_YN = 'Y' 인경인경우, ICOYPRDT에는 REPEAT_YN 가
				// 없기 때문에 삭제 후 인서트하면 값이 사라진다.)
				if (wf.getRowCount() > 0) {
					wxp = new SepoaXmlParser(this,
							new Exception().getStackTrace()[0].getMethodName()
									+ "_TB_SCM_PR_UPDATE");
					sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,
							wxp.getQuery());
					String[][] data = new String[wf.getRowCount()][];
					for (int i = 0; i < data.length; i++) {
						String[] temp_data = { wf.getValue("PR_NO", i),
								wf.getValue("PR_SEQ", i) };
						data[i] = temp_data;
					}
					String[] type = { "S", "S" };
					rtn = sm.doUpdate(data, type);
				}
			}

		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	public SepoaOut getSCMSOrderSeq(String[] args) {
		try {

			String rtn = et_getSCMSOrderSeq(args);

			setStatus(1);
			setValue(rtn);
			setMessage(msg.get("p10_pra.0000").toString());
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("p10_pra.0001").toString());
		}

		return getSepoaOut();
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private String et_getSCMSOrderSeq(String[] args) throws Exception {

		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");

		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
		wxp.addVar("company_code", info.getSession("COMPANY_CODE"));

		try {
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, wxp.getQuery());

			rtn = sm.doSelect(args);
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	// Sourcint 요청 작성시 선택된 PR 조회정보
	// public SepoaOut prDTQuerySourcing(String PR_NO_SEQ) {
	// try {
	//
	// String rtn = et_prDTQuerySourcing(PR_NO_SEQ);
	//
	// setValue(rtn);
	// setStatus(1);
	// setMessage(msg.get("p10_pra.0000").toString());
	//
	// } catch(Exception e) {
	// Logger.err.println(info.getSession("ID"),this,e.getMessage());
	// setStatus(0);
	// setMessage(msg.get("p10_pra.0001").toString());
	// }
	// return getSepoaOut();
	// }

	@SuppressWarnings("deprecation")
	public SepoaOut prDTQuerySourcing(Map<String, String> pararm) {
		ConnectionContext ctx = null;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		String rtn = null;
		String id = info.getSession("ID");
		String houseCode = info.getSession("HOUSE_CODE");
		String prNoSeq = pararm.get("prNoSeq");

		try {
			setStatus(1);
			setFlag(true);

			ctx = getConnectionContext();

			sxp = new SepoaXmlParser(this, "et_prDTQuerySourcing");

			sxp.addVar("house_code", houseCode);
			sxp.addVar("prNoSeq", prNoSeq);

			ssm = new SepoaSQLManager(id, this, ctx, sxp.getQuery());

			rtn = ssm.doSelect((String[]) null); // 조회

			setValue(rtn);
			setMessage((String) msg.get("0000"));
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage((String) msg.get("0001"));
		}

		return getSepoaOut();
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private String et_prDTQuerySourcing(String PR_NO_SEQ) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
		wxp.addVar("pr_no_seq", PR_NO_SEQ);

		try {
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, wxp.getQuery());

			rtn = sm.doSelect((String[]) null);

		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}

		return rtn;
	}

	// 업체선정 히스토리
	// public SepoaOut vendor_settle_history(String[] args) {
	// try {
	// String PR_NO = args[0];
	// String PR_SEQ = args[1];
	// String rtn = et_vendor_settle_history(PR_NO, PR_SEQ);
	//
	// setValue(rtn);
	// setStatus(1);
	// setMessage(msg.get("p10_pra.0000").toString());
	//
	// } catch(Exception e) {
	// Logger.err.println(info.getSession("ID"),this,e.getMessage());
	// setStatus(0);
	// setMessage(msg.get("p10_pra.0001").toString());
	// }
	// return getSepoaOut();
	// }

	public SepoaOut vendor_settle_history(Map<String, String> args) {
		ConnectionContext ctx = null;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		String rtn = null;
		String id = info.getSession("ID");

		try {
			setStatus(1);
			setFlag(true);

			ctx = getConnectionContext();

			sxp = new SepoaXmlParser(this, "et_vendor_settle_history");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);

			rtn = ssm.doSelect(args); // 조회

			setValue(rtn);
			setMessage((String) msg.get("0000"));
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage((String) msg.get("0001"));
		}

		return getSepoaOut();
	}

	@SuppressWarnings({ "unused", "deprecation" })
	private String et_vendor_settle_history(String PR_NO, String PR_SEQ)
			throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("HOUSE_CODE", info.getSession("HOUSE_CODE"));
		wxp.addVar("PR_NO", PR_NO);
		wxp.addVar("PR_SEQ", PR_SEQ);

		try {
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, wxp.getQuery());

			rtn = sm.doSelect((String[]) null);

		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}

		return rtn;
	}

	@SuppressWarnings("unused")
	public SepoaOut totalPrProcessing(String[] args) {
		try {
			String lang = info.getSession("LANGUAGE");

			String rtnHD = et_totalPrProcessing(args);
			setStatus(1);
			setValue(rtnHD);
			setMessage(msg.get("STDCOMM.0000").toString());
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setStatus(0);

			String lang = info.getSession("LANGUAGE");

			setMessage(msg.get("p10_pra.0001").toString());
		}
		return getSepoaOut();
	}

	@SuppressWarnings("deprecation")
	private String et_totalPrProcessing(String[] args) throws Exception {

		String rtn = null;

		try {
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			ConnectionContext ctx = getConnectionContext();

			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx,
					wxp.getQuery());
			rtn = sm.doSelect(args);
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	@SuppressWarnings("unused")
	public SepoaOut totalPrProcessingSave(String[][] args) {
		try {
			int rtnHD = et_totalPrProcessingSave(args);
			setStatus(1);
			setMessage(msg.get("p10_pra.0000").toString());
			Commit();
		} catch (Exception e) {
			try {
				Rollback();
			} catch (Exception ee) {
				Logger.err.println(info.getSession("ID"), this, ee.getMessage());
			}
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("p10_pra.0001").toString());
		}
		return getSepoaOut();
	}

	@SuppressWarnings("deprecation")
	private int et_totalPrProcessingSave(String[][] args) throws Exception {
		int rtn = 0;
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser wxp = new SepoaXmlParser(this,
				new Exception().getStackTrace()[0].getMethodName());

		try {
			String[] type = { "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "S", "S" };

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, wxp.getQuery());
			rtn = sm.doInsert(args, type);
		} catch (Exception e) {

			Logger.debug.println(info.getSession("ID"), this, wxp.getQuery());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private int update(ConnectionContext ctx, String name,
			Map<String, String> param) throws Exception {
		String id = info.getSession("ID");
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		int result = 0;

		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);

		result = ssm.doUpdate(param);

		return result;
	}
	
	public SepoaOut selectIcoyprdtGwList(Map<String, String> header){
		ConnectionContext ctx       = null;
		SepoaXmlParser    sxp       = null;
		SepoaSQLManager   ssm       = null;
		String            rtn       = null;
		String            id        = info.getSession("ID");
		String            houseCode = header.get("HOUSE_CODE");
		String            prNoSeq   = header.get("prNoSeq");

		try {
			setStatus(1);
			setFlag(true);

			ctx = getConnectionContext();

			sxp = new SepoaXmlParser(this, "selectIcoyprdtGwList");

			sxp.addVar("HOUSE_CODE", houseCode);
			sxp.addVar("prNoSeq",    prNoSeq);

			ssm = new SepoaSQLManager(id, this, ctx, sxp);

			rtn = ssm.doSelect(header);

			setValue(rtn);
			setMessage((String) msg.get("0000"));
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage((String) msg.get("0001"));
		}

		return getSepoaOut();
	}
}
