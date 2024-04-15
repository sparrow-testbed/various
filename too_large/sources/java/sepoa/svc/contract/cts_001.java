package sepoa.svc.contract;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sms.SMS;

public class CTS_001 extends SepoaService {

	private String ID = info.getSession("ID");
	private Message msg;

	public CTS_001(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		setVersion("1.0.0");
		msg = new Message(info, "PU_005_BEAN");
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
	//사용
	public SepoaOut getReceiveListSeller(Map< String, String > header){

		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		Map<String, String> customHeader =  new HashMap<String, String>();	
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			customHeader.put("company_code"  , info.getSession("COMPANY_CODE"));
			customHeader.put("language"      , info.getSession("LANGUAGE"));
			customHeader.put("from_cont_date", MapUtils.getString(header, "from_cont_date", "").replaceAll("/", ""));
			customHeader.put("to_cont_date"  , MapUtils.getString(header, "to_cont_date", "").replaceAll("/", ""));
			
			sxp = new SepoaXmlParser(this, "getReceiveListSeller");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	setValue(ssm.doSelect(header,customHeader));
		} 
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}


	
	//사용
	public SepoaOut getContractListSeller(Map< String, String > header){

		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		Map<String, String> customHeader =  new HashMap<String, String>();	
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			customHeader.put("company_code"  , info.getSession("COMPANY_CODE"));
			customHeader.put("language"      , info.getSession("LANGUAGE"));
			customHeader.put("from_cont_date", SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "from_cont_date", "") ) );
			customHeader.put("to_cont_date"  , SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "to_cont_date", "") ) );
			
			sxp = new SepoaXmlParser(this, "getContractListSeller");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	setValue(ssm.doSelect(header,customHeader));
		} 
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}

	/*
	 *  사용
	 */
	public SepoaOut setInsNoInsert( Map allData  ) throws Exception {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		try {
			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(allData, "gridData");
			Map<String, String> header = MapUtils.getMap(allData, "headerData");

        	sxp = new SepoaXmlParser(this, "setInsNoInsert");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	ssm.doUpdate(grid);
        	Commit();
		}catch (Exception e){
			try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            setValue(e.getMessage().trim());
            setStatus(0);
		}

		return getSepoaOut();
	}

	public SepoaOut setCEUpdate( Map allData ) throws Exception {

		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
		
		Map<String, String>         grid        = null;
        Map<String, String>         header      = null;
        List<Map<String, String>>   gridData    = null;
 
		try {
		    header                  = ( Map < String , String > ) MapUtils.getObject ( allData , "headerData" );
		    gridData                = (List<Map<String,String>>)MapUtils.getObject(allData, "gridData");
		    grid = (Map <String , String>) gridData.get(0);
		    
		    for ( Map < String , String > map : gridData ) {
	            ps.removeAllValue();
	            sqlsb.delete(0, sqlsb.length());    
	            sqlsb.append(" UPDATE SCTGL                         \n");
	            sqlsb.append("    SET  CT_FLAG              = 'CE'  \n");  
	            sqlsb.append("        , CONT_REJECT_REASON  = ?     \n"); ps.addStringParameter(MapUtils.getString(header, "reject_reason", ""));
	            sqlsb.append("  WHERE CONT_NUMBER           = ?     \n");
	            ps.addStringParameter(MapUtils.getString(map, "CONT_NO", ""));
	            sqlsb.append("    AND CONT_GL_SEQ           = ?     \n");
	            ps.addStringParameter(MapUtils.getString(map, "CONT_GL_SEQ", ""));
	            ps.doUpdate(sqlsb.toString());
            }
		    

			setStatus(1);
			setMessage(msg.getMessage("0001"));
	
			Commit();
		} catch (Exception e) {
			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}
	
			
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setFlag(false);
			setStatus(0);
			setMessage(e.getMessage());
		}
	
		return getSepoaOut();
	}
	
	public SepoaOut getContractDetailSelect( String cont_no, String cont_gl_seq ) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			 
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("					  SELECT CONTENT						\n ");
			sqlsb.append("					  FROM   SCPMT							\n ");
			sqlsb.append("					  WHERE  1 = 1							\n ");
			sqlsb.append(sm.addFixString("    AND    CONT_NO     		= ?			\n ")); sm.addStringParameter(cont_no);
			sqlsb.append(sm.addFixString("    AND    CONT_GL_SEQ        = ?			\n ")); sm.addStringParameter(cont_gl_seq);
			sqlsb.append("		  			  AND    NVL(DEL_FLAG, 'N') = 'N'	    \n ");  
			sqlsb.append("					  ORDER BY SEQ_SEQ 				    	\n ");
			setValue(sm.doSelect(sqlsb.toString()));

		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	public SepoaOut getContractTotalSelect( String cont_no, String cont_gl_seq, String flag ) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		String sign_user_code = info.getSession("ID");
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());

			
			
//			sqlsb.append("      (SELECT																																	\n");
//			sqlsb.append("      	 CONT_NO																															\n");
//			sqlsb.append("      	,SEQ																																\n");
//			sqlsb.append("      	,SEQ_SEQ																															\n");
//			sqlsb.append("      	,CONTENT																															\n");
//			sqlsb.append("      FROM SCPMT																																\n");
//			sqlsb.append("      WHERE NVL(DEL_FLAG, 'N') = 'N'																											\n");
//			sqlsb.append(sm.addSelectString("       AND CONT_NO = ?																										\n"));
//			sm.addStringParameter(cont_no);
			
			
			sqlsb.append("					  SELECT 									\n");
			sqlsb.append("					          '" + cont_no + "' AS CONT_NO		\n");
			sqlsb.append("					         ,SEQ				    			\n");
			sqlsb.append("					         ,SEQ_SEQ							\n");
			sqlsb.append("					         ,CONTENT					 		\n");
			sqlsb.append("					  FROM SCPMT							    \n");
			sqlsb.append("					  WHERE 1 = 1								\n");
			sqlsb.append(sm.addSelectString(" AND CONT_NO            = ?				\n")); sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString(" AND CONT_GL_SEQ        = ?				\n")); sm.addStringParameter(cont_gl_seq);
			sqlsb.append("		  			  AND NVL(DEL_FLAG, 'N') = 'N'				\n");
			setValue(sm.doSelect(sqlsb.toString()));
			
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());			
			sqlsb.append("      (SELECT																																	\n");
			sqlsb.append("      	 CONT_NO																															\n");
			sqlsb.append("      	,'88888' AS SEQ																														\n");
			sqlsb.append("      	,'88888888' AS SEQ_SEQ																												\n");
			sqlsb.append("      	,		CONT_NO				||	SUBJECT				||	CONT_GUBUN			||	PROPERTY_YN		||	SELLER_CODE				||		\n");
			sqlsb.append("      			SIGN_PERSON_ID		||	SIGN_PERSON_NAME	||	CONT_FROM			||	CONT_TO			||	CONT_DATE				||		\n");
			sqlsb.append("      			CONT_ADD_DATE		||	CONT_TYPE			||	ELE_CONT_FLAG		||	ASSURE_FLAG		||	START_START_INS_FLAG	||		\n");
			sqlsb.append("      			CONT_PROCESS_FLAG	||	CONT_AMT			||	CONT_ASSURE_PERCENT	||	CONT_ASSURE_AMT	||	FAULT_INS_PERCENT		||		\n");
			sqlsb.append("      			FAULT_INS_AMT		||	PAY_DIV_FLAG		||	FAULT_INS_TERM		||	BD_NO			||	BD_COUNT				||		\n");
			sqlsb.append("      			AMT_GUBUN			||	TEXT_NUMBER			||	DELAY_CHARGE		||	DELV_PLACE		||	REMARK					||		\n");
			sqlsb.append("      			CTRL_DEMAND_DEPT	||	CTRL_CODE			||	COMPANY_CODE		||	RFQ_TYPE		||	DEL_FLAG				||		\n");
			sqlsb.append("      			ATTACH_NO			||	SE_ATTACH_NO    AS CONTENT																							\n");
			sqlsb.append("      FROM SCPGL																																\n");
			sqlsb.append("      WHERE NVL(DEL_FLAG, 'N') = 'N'																											\n");
			sqlsb.append(sm.addSelectString("       AND CONT_NO      = ?																								\n"));
			sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString("       AND CONT_GL_SEQ  = ?																								\n")); 
			sm.addStringParameter(cont_gl_seq);
			sqlsb.append("      )																																		\n");
			
			//kave
//			sqlsb.append("      UNION ALL                                                                                                                             	\n");
//			sqlsb.append("      (SELECT                                                                                                                                 \n");
//			sqlsb.append("      	 CONT_NO                                                                                                                            \n");
//			sqlsb.append("      	,'99999' AS SEQ                                                                                                                     \n");
//			sqlsb.append("      	,'99999999' AS SEQ_SEQ                                                                                                              \n");
//			sqlsb.append("      	,               CONT_SEQ || SELLER_CODE          || COMPANY_CODE       || PR_NO                   || PR_SEQ ||                      \n");
//			sqlsb.append("      	                  RFQ_NO || RFQ_COUNT            || RFQ_SEQ            || QTA_NO                  || QTA_SEQ ||                     \n");
//			sqlsb.append("      	             MATERIAL_NO || DESCRIPTION_LOC      || DESCRIPTION_ENG    || SPECIFICATION           || UNIT_MEASURE ||                \n");
//			sqlsb.append("      	                 RD_DATE || UNIT_PRICE           || CUR                || SETTLE_TYPE             || SETTLE_FLAG ||                 \n");
//			sqlsb.append("      	              SETTLE_QTY || CONTRACT_FLAG        || QUOTA_PERCENT      || DP_NO                   || DP_SEQ ||                      \n");
//			sqlsb.append("      	            MANAGE_PRICE || RESULT_PRICE         || ESTIMATE_PRICE     || YEAR_QTY                || PURCHASE_LOCATION ||           \n");
//			sqlsb.append("      	            AUTO_PO_FLAG || CTR_NO               || VALID_FROM_DATE    || VALID_TO_DATE           || MOLDING_CHARGE ||              \n");
//			sqlsb.append("      	         PREV_UNIT_PRICE || ITEM_AMT             || ITEM_AMT_USD       || PURCHASE_CONV_RATE      || PURCHASE_CONV_QTY ||           \n");
//			sqlsb.append("      	             DELIVERY_LT || DO_FLAG              || Z_WORK_STAGE_FLAG  || Z_DELIVERY_CONFIRM_FLAG || PO_NO ||                       \n");
//			sqlsb.append("      	                  PO_SEQ || DEL_FLAG             || DELV_PLACE         || ECO_ITEM                || MINOR_ITEM  ||                 \n");
//			sqlsb.append("      	              CERTI_ITEM || SUPPLY_AMT           || SUPERTAX_AMT       || MAKER                   || YEAR_OF_MANUFACTURE ||         \n");
//			sqlsb.append("      	   ACCOUNTS_COURSES_CODE || ACCOUNTS_COURSES_LOC || ASSET_NUMBER       || COMPANY_TYPE            || WOMEN_COMPANIES_FLAG ||        \n");
//			sqlsb.append("      	 DISABLED_COMPANIES_FLAG || RECYCLING_FLAG       || PR_USER_ID         || CTRL_PERSON_ID          || DEMAND_DEPT AS CONTENT         \n");
//			sqlsb.append("      FROM SCPLN                                                                                                                              \n");
//			sqlsb.append("      WHERE NVL(DEL_FLAG, 'N') = 'N'                                                                                                          \n");
//			sqlsb.append(sm.addSelectString("       AND CONT_NO = ?                           																			\n"));
//			sm.addStringParameter(cont_no);
//			sqlsb.append(sm.addSelectString("       AND CONT_GL_SEQ  = ?																								\n")); 
//			sm.addStringParameter(cont_gl_seq);			
//			sqlsb.append("      )                                                                                                                                       \n");
			
			
			
			
			sqlsb.append("      ORDER BY 1,2,3,4                                                                                                                        \n");
			
			setValue(sm.doSelect(sqlsb.toString()));
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("		SELECT SIGN_HASH ,SELLER_SIGN  FROM SSIGN						\n");
			sqlsb.append("		 WHERE NVL(DEL_FLAG, 'N') = 'N'					\n");
			sqlsb.append(sm.addSelectString("       AND CONT_NO = ?				\n"));
			sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString("       AND CONT_COUNT = ?				\n"));
			sm.addStringParameter(cont_gl_seq);
			sqlsb.append(sm.addSelectString("       AND SIGN_HASH = ?				\n"));
			sm.addStringParameter(flag);
			setValue(sm.doSelect(sqlsb.toString()));
			
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
		
	}
	
	public SepoaOut getContractApproval( String id ) {  //�낆껜�뺣낫�먯꽌 �몄쬆�쒗궎媛� �몄쬆�쒕컻湲됯린愿�媛�졇�ㅺ린
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		String sign_user_code = info.getSession("ID");
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());

			
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("		SELECT 									\n");
			sqlsb.append("			SIGN_VALUE,							\n");
			sqlsb.append("			SIGN_NAME							\n");
			sqlsb.append("		FROM ICOMVNGL						\n");
			sqlsb.append("		 WHERE 1=1					\n");
			sqlsb.append(sm.addSelectString("       AND VENDOR_CODE = ?				\n"));
			sm.addStringParameter(id);
			setValue(sm.doSelect(sqlsb.toString()));
			
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
		
	}
	
	//추가수정_20171127
	public SepoaOut getContractSign(String cont_no, String sign_key, String sign_name, 
			String sign_encode, String save_flag, String ct_flag,
			String cont_dd_flag, String fault_dd_flag,
			String vendor_in_attach_no, String cont_gl_seq,
			String stamp_tax_no, String stamp_tax_amt,
			String aPlain, String aPlainHex, String aSubjectRDN, String aPolicy, String aCertificate, String aResult, String aIssuser			
			){
			
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		int rtn = 0;

		String sign_user_code = info.getSession("ID");

		try {
			setStatus(1);
			setFlag(true);

			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
	
			//// 업체일반정보테이블
			//sm.removeAllValue();
			//sb.delete(0, sb.length());
			//sb.append("     SELECT                                          \n");
			//sb.append("     	 SELLER_CODE                                \n");
			//sb.append("     	,SIGN_VALUE                                 \n");
			//sb.append("     	,SIGN_NAME                                  \n");
			//sb.append("     FROM SSUGL                                      \n");
			//sb.append("     WHERE NVL(DEL_FLAG, 'N') = 'N'                  \n");
			//sb.append(sm.addSelectString("	AND SELLER_CODE = ?		\n"));
			//sm.addStringParameter(info.getSession("COMPANY_CODE"));
			//
			//
			//String result = sm.doSelect(sb.toString());
			//
			//SepoaFormater wf = new SepoaFormater(result);
			//
			//if(wf.getRowCount() > 0){
			//if(sign_hash.equals(wf.getValue("SIGN_VALUE", 0)) && sign_value.equals(wf.getValue("SIGN_NAME", 0)))
			//{
			// 계약헤더테이블 CT_FLAG = "CC" 로 변경 업체인증
			sm.removeAllValue();
			sb.delete(0, sb.length());
			if(ct_flag.equals("CC")){
				sb.append("  UPDATE SCPGL SET         	   \n");
				sb.append("     CT_FLAG        		= ?    \n");sm.addStringParameter(ct_flag);
				sb.append("    ,SE_ATTACH_NO        = ?    \n");sm.addStringParameter(vendor_in_attach_no);
				sb.append("    ,SELLER_CONFRIM_DATE = ?    \n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("    ,CHANGE_USER_ID 		= ?    \n");sm.addStringParameter(info.getSession("ID"));
				sb.append("    ,CHANGE_DATE    		= ?    \n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("    ,CHANGE_TIME    		= ?    \n");sm.addStringParameter(SepoaDate.getShortTimeString());
				sb.append("  WHERE CONT_NO     		= ?    \n");sm.addStringParameter(cont_no);
				sb.append("  AND   CONT_GL_SEQ 		= ?    \n");sm.addStringParameter(cont_gl_seq);
			}else{ //CT_FLAG = "CV" 계약폐기
				sb.append("  UPDATE SCPGL SET         	   \n");
				sb.append("     CT_FLAG        		= ?    \n");sm.addStringParameter(ct_flag);
//				sb.append("    ,SE_ATTACH_NO        = ?    \n");sm.addStringParameter(vendor_in_attach_no);
				sb.append("    ,SELLER_CONFRIM_DATE = ?    \n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("    ,CHANGE_USER_ID 		= ?    \n");sm.addStringParameter(info.getSession("ID"));
				sb.append("    ,CHANGE_DATE    		= ?    \n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("    ,CHANGE_TIME    		= ?    \n");sm.addStringParameter(SepoaDate.getShortTimeString());
//				sb.append("    ,CONT_DD_FLAG    	= ?    \n");sm.addStringParameter(cont_dd_flag);
//				sb.append("    ,FAULT_DD_FLAG    	= ?    \n");sm.addStringParameter(fault_dd_flag);
				sb.append("  WHERE CONT_NO     		= ?    \n");sm.addStringParameter(cont_no);
				sb.append("  AND   CONT_GL_SEQ 		= ?    \n");sm.addStringParameter(cont_gl_seq);
			}
			rtn = sm.doUpdate(sb.toString());
			
			if(rtn <= 0) {
				Rollback();
				setStatus(0);
				setMessage("서명중 오류발생");
				setFlag(false);
				return getSepoaOut();

			}
	
			// 전자인증정보테이블
//			sm.removeAllValue();
//			sb.delete(0, sb.length());
//			sb.append("  DELETE FROM SSIGN        \n");
//			sb.append("  WHERE CONT_NO     = ?    \n");sm.addStringParameter(cont_no);
//			rtn = sm.doUpdate(sb.toString());
	
			Logger.sys.println("★★★★★★★★★★★ cont_no     = " + cont_no);
			Logger.sys.println("★★★★★★★★★★★ sign_encode = " + sign_encode);
			Logger.sys.println("★★★★★★★★★★★ sign_value  = " + sign_name);
			Logger.sys.println("★★★★★★★★★★★ sign_hash   = " + sign_key);
			Logger.sys.println("★★★★★★★★★★★ seller_sign   = " + aResult); //추가수정_20171127
	
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("		INSERT INTO SSIGN	(	\n");
			sb.append("			 CONT_NO			\n");
			sb.append("			,CONT_COUNT			\n");
			sb.append("			,SIGN_HASH			\n");
			sb.append("			,SIGN_VALUE			\n");
			sb.append("			,ADD_USER_ID		\n");
			sb.append("			,ADD_DATE			\n");
			sb.append("			,ADD_TIME			\n");
			sb.append("			,CHANGE_USER_ID		\n");
			sb.append("			,CHANGE_DATE		\n");
			sb.append("			,CHANGE_TIME		\n");
			sb.append("			,DEL_FLAG			\n");
			sb.append("			,SIGN_KEY			\n");			
			
			sb.append("			,SELLER_SIGN              			\n");
			sb.append("			,CONTENT                  			\n");
			sb.append("			,CONTENT_HEX              			\n");
			sb.append("			,SELLER_SIGNER_CERTIFICATE			\n");
			sb.append("			,SELLER_POLICY            			\n");
			sb.append("			,SELLER_ISSUER            			\n");
			sb.append("			,SELLER_DN                			\n");						
			
			sb.append("		) VALUES (				\n");
			sb.append("			 ?					\n");sm.addStringParameter(cont_no);
//			sb.append("			,?                  \n");sm.addStringParameter("1");
			sb.append("			,?                  \n");sm.addStringParameter(cont_gl_seq);
			sb.append("			,?					\n");sm.addStringParameter(sign_encode);
			sb.append("			,?					\n");sm.addStringParameter(sign_name); //  인증서 발행기간명
			sb.append("			,?					\n");sm.addStringParameter(info.getSession("ID"));
			sb.append("			,?					\n");sm.addStringParameter(SepoaDate.getShortDateString());
			sb.append("			,?					\n");sm.addStringParameter(SepoaDate.getShortTimeString());
			sb.append("			,?					\n");sm.addStringParameter(info.getSession("ID"));
			sb.append("			,?					\n");sm.addStringParameter(SepoaDate.getShortDateString());
			sb.append("			,?					\n");sm.addStringParameter(SepoaDate.getShortTimeString());
			sb.append("			,?					\n");sm.addStringParameter("N");
			sb.append("			,?					\n");sm.addStringParameter(sign_key);  // 인증서 키 
			sb.append("			,?					\n");sm.addStringParameter(aResult); //추가수정_20171127
			sb.append("			,?					\n");sm.addStringParameter(aPlain); //추가수정_20171127
			sb.append("			,?					\n");sm.addStringParameter(aPlainHex); //추가수정_20171127
			sb.append("			,?					\n");sm.addStringParameter(aCertificate); //추가수정_20171127
			sb.append("			,?					\n");sm.addStringParameter(aPolicy); //추가수정_20171127
			sb.append("			,?					\n");sm.addStringParameter(aIssuser); //추가수정_20171127
			sb.append("			,?					\n");sm.addStringParameter(aSubjectRDN); //추가수정_20171127
			sb.append("		)						\n");
			rtn = sm.doUpdate(sb.toString());
			
			if(rtn <= 0) {
				Rollback();
				setStatus(0);
				setMessage("서명중 오류발생");
				setFlag(false);
				return getSepoaOut();

			}
								
//			sm.removeAllValue();
//			sb.delete(0, sb.length());
//			sb.append("  DELETE FROM SCOTX        \n");
//			sb.append("  WHERE CONT_NO     = ?    \n");sm.addStringParameter(cont_no);
//			rtn = sm.doUpdate(sb.toString());
			
			if(ct_flag.equals("CC")){
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("		INSERT INTO SCOTX	(	\n");
				sb.append("			 CONT_NO			\n");
				sb.append("			,CONT_COUNT			\n");
				sb.append("			,STAMP_TAX_NO 		\n");
				sb.append("			,STAMP_TAX_AMT		\n");
				sb.append("			,ADD_USER_ID		\n");
				sb.append("			,ADD_DATE			\n");
				sb.append("			,ADD_TIME			\n");
				sb.append("			,CHANGE_USER_ID		\n");
				sb.append("			,CHANGE_DATE		\n");
				sb.append("			,CHANGE_TIME		\n");
				sb.append("		) VALUES (				\n");
				sb.append("			 ?					\n");sm.addStringParameter(cont_no);
	//			sb.append("			,?                  \n");sm.addStringParameter("1");
				sb.append("			,?                  \n");sm.addStringParameter(cont_gl_seq);
				sb.append("			,?					\n");sm.addStringParameter(stamp_tax_no);
				sb.append("			,?					\n");sm.addStringParameter(stamp_tax_amt); //  인증서 발행기간명
				sb.append("			,?					\n");sm.addStringParameter(info.getSession("ID"));
				sb.append("			,?					\n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("			,?					\n");sm.addStringParameter(SepoaDate.getShortTimeString());
				sb.append("			,?					\n");sm.addStringParameter(info.getSession("ID"));
				sb.append("			,?					\n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("			,?					\n");sm.addStringParameter(SepoaDate.getShortTimeString());
				sb.append("		)						\n");
				rtn = sm.doUpdate(sb.toString());
			}
			//계약상세정보						
			//sm.removeAllValue();
			//sb.delete(0, sb.length());
			//sb.append("	SELECT							\n");
			//sb.append("		 PR_NO						\n");
			//sb.append("		,PR_SEQ						\n");
			//sb.append("	FROM SCPLN						\n");
			//sb.append("	WHERE NVL(DEL_FLAG, 'N') = 'N'	\n");
			//sb.append(sm.addSelectString("	  AND CONT_NO = ?	\n"));
			//sm.addStringParameter(cont_no);
			//SepoaFormater wwf = new SepoaFormater(sm.doSelect(sb.toString()));
			//
			//if(wwf.getRowCount() > 0) {
			//	for(int i=0; i<wwf.getRowCount(); i++) {
			//		//PR������ ���� �������{scode_type=M157}
			//		구매의뢰 상세정보테이블					
			//		sm.removeAllValue();
			//		sb.delete(0, sb.length());
			//		sb.append("		UPDATE SPRLN SET			\n");
			//		sb.append("			 PR_PROCEEDING_FLAG = ?	\n");sm.addStringParameter("CC");//��ü����
			//		sb.append("			,DEL_FLAG			= ?	\n");sm.addStringParameter("N");
			//		sb.append("			,CHANGE_USER_ID		= ?	\n");sm.addStringParameter(info.getSession("ID"));
			//		sb.append("			,CHANGE_DATE		= ?	\n");sm.addStringParameter(SepoaDate.getShortDateString());
			//		sb.append("			,CHANGE_TIME		= ?	\n");sm.addStringParameter(SepoaDate.getShortTimeString());
			//		sb.append("		WHERE PR_NUMBER	= ?			\n");sm.addStringParameter(wwf.getValue("PR_NO", i));
			//		sb.append("		  AND PR_SEQ	= ?			\n");sm.addStringParameter(wwf.getValue("PR_SEQ", i));
			//		sm.doUpdate(sb.toString());
			//	}
			//}
			
			if(rtn <= 0) {
				Rollback();
				setStatus(0);
				setMessage("서명중 오류발생");
				setFlag(false);
				return getSepoaOut();

			} else {
				setStatus(1);
				Commit();
			}
			//}else{
			//Rollback();
			//setStatus(0);
			//setMessage("��ϵ� ����� �ٸ��ϴ�.");
			//return getSepoaOut();
			//}
			//}else{
			//setStatus(0);
			//setMessage("��ϵ� ����� ��4ϴ�.");
			//return getSepoaOut();
			//}
		} catch (Exception e) {
			try {
				Rollback();
				setStatus(0);
				setMessage("서명중 오류발생");
				setFlag(false);

			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}
	
//			e.printStackTrace();
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();
	}
	
	public SepoaOut getContractDelete(SepoaInfo info, String[][] bean_info, String delete_confirm)
	{
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		int rtn = 0;
		
		try {
			setStatus(1);
			setFlag(true);

			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for (int i = 0; i < bean_info.length; i++)
			{
				String cont_no     = bean_info[i][0];
				String cont_gl_seq = bean_info[i][1];
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" UPDATE SCPGL SET			\n");
				sb.append(" 	CT_FLAG        = ?,	    \n");sm.addStringParameter("CE");
				sb.append("		CHANGE_USER_ID = ?,		\n");sm.addStringParameter(info.getSession("ID"));
				sb.append("		CHANGE_DATE    = ?,		\n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("		CHANGE_TIME    = ?,		\n");sm.addStringParameter(SepoaDate.getShortTimeString());
				sb.append("		REJECT_DATE    = ?,		\n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("		REJECT_REASON    = ?		\n");sm.addStringParameter(delete_confirm);
				
				sb.append(" WHERE CONT_NO      = ?		\n");sm.addStringParameter(cont_no);
				sb.append(" AND   CONT_GL_SEQ  = ?		\n");sm.addStringParameter(cont_gl_seq);
				rtn = sm.doDelete(sb.toString());
		
			}
			
			Commit();
				
		} catch (Exception e) {
			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}
			
//			e.printStackTrace();
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	

	public SepoaOut getContractSignBuyer( String cont_no,  String cont_gl_seq, String stamp_tax_no, String stamp_tax_amt, String signedData, String aMDN1 )
	{
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		int rtn = 0;
		
		String sign_user_code = info.getSession("ID");
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("  UPDATE SCPGL SET         \n");
			sb.append("     CT_FLAG        = ?    \n");sm.addStringParameter("CD");
			sb.append("    ,CONT_ADD_DATE  = ( CASE WHEN ele_cont_flag = 'Y' THEN '"+SepoaDate.getShortDateString()+"' ELSE CONT_ADD_DATE END )   \n");
			sb.append("    ,KSD_CONFRIM_DATE        = ?    \n");sm.addStringParameter(SepoaDate.getShortDateString());
			sb.append("    ,CHANGE_USER_ID = ?    \n");sm.addStringParameter(info.getSession("ID"));
			sb.append("    ,CHANGE_DATE    = ?    \n");sm.addStringParameter(SepoaDate.getShortDateString());
			sb.append("    ,CHANGE_TIME    = ?    \n");sm.addStringParameter(SepoaDate.getShortTimeString());
			sb.append("  WHERE CONT_NO     = ?    \n");sm.addStringParameter(cont_no);
			sb.append("  AND   CONT_GL_SEQ = ?    \n");sm.addStringParameter(cont_gl_seq);
			
			rtn = sm.doUpdate(sb.toString());
			
			//추가수정_20171127
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("  UPDATE SSIGN SET         \n");
			sb.append("     BUYER_SIGN   = ?      \n");sm.addStringParameter(signedData);
			sb.append("    ,BUYER_DN     = ?      \n");sm.addStringParameter(aMDN1);
			sb.append("  WHERE CONT_NO     = ?    \n");sm.addStringParameter(cont_no);
			sb.append("  AND   CONT_COUNT  = ?    \n");sm.addStringParameter(cont_gl_seq);
			sb.append("  AND   CONT_COUNT  = ?    \n");sm.addStringParameter(cont_gl_seq);
			sb.append("  AND   SIGN_HASH  = 'C'    \n");
			
			
			rtn = sm.doUpdate(sb.toString());
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("  UPDATE SCOTX SET         \n");
			sb.append("     STAMP_TAX_NO   = ?    \n");sm.addStringParameter(stamp_tax_no);
			sb.append("    ,STAMP_TAX_AMT  = ?    \n");sm.addStringParameter(stamp_tax_amt);
			sb.append("    ,CHANGE_USER_ID = ?    \n");sm.addStringParameter(info.getSession("ID"));
			sb.append("    ,CHANGE_DATE    = ?    \n");sm.addStringParameter(SepoaDate.getShortDateString());
			sb.append("    ,CHANGE_TIME    = ?    \n");sm.addStringParameter(SepoaDate.getShortTimeString());
			sb.append("  WHERE CONT_NO     = ?    \n");sm.addStringParameter(cont_no);
			sb.append("    AND CONT_COUNT  = ?    \n");sm.addStringParameter(cont_gl_seq);
			
			rtn = sm.doUpdate(sb.toString());
				
//			sm.removeAllValue();
//			sb.delete(0, sb.length());
//			sb.append("	SELECT							\n");
//			sb.append("		 PR_NO						\n");
//			sb.append("		,PR_SEQ						\n");
//			sb.append("	FROM SCPLN						\n");
//			sb.append("	WHERE NVL(DEL_FLAG, 'N') = 'N'	\n");
//			sb.append(sm.addSelectString("	  AND CONT_NO = ?	\n"));
//			sm.addStringParameter(cont_no);
//			SepoaFormater wwf = new SepoaFormater(sm.doSelect(sb.toString()));
//			
//			if(wwf.getRowCount() > 0) {
//				for(int i=0; i<wwf.getRowCount(); i++) {
//					//PR������ ���� �������{scode_type=M157}
//					sm.removeAllValue();
//					sb.delete(0, sb.length());
//					sb.append("		UPDATE SPRLN SET			\n");
//					sb.append("			 PR_PROCEEDING_FLAG = ?	\n");sm.addStringParameter("CD");//��ü����
//					sb.append("			,DEL_FLAG			= ?	\n");sm.addStringParameter("N");
//					sb.append("			,CHANGE_USER_ID		= ?	\n");sm.addStringParameter(info.getSession("ID"));
//					sb.append("			,CHANGE_DATE		= ?	\n");sm.addStringParameter(SepoaDate.getShortDateString());
//					sb.append("			,CHANGE_TIME		= ?	\n");sm.addStringParameter(SepoaDate.getShortTimeString());
//					sb.append("		WHERE PR_NUMBER	= ?			\n");sm.addStringParameter(wwf.getValue("PR_NO", i));
//					sb.append("		  AND PR_SEQ	= ?			\n");sm.addStringParameter(wwf.getValue("PR_SEQ", i));
//					sm.doUpdate(sb.toString());
//				}
//			}
	
			setStatus(1);
			Commit();
			
			
			
			//전자계약서 알림 SMS 전송
			//공급자 모바일번호 조회
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("                 SELECT                                                          \n");
			sb.append("                  PHONE_NO2 AS MOBILE_NO                                         \n");
			sb.append("                 FROM ICOMADDR                                                   \n");
			sb.append("                 WHERE 1 = 1                                                     \n");
			sb.append("                 AND CODE_TYPE = '3'                                             \n");//회사나 업체가 아니라 담당자에게 가야하므로 CODE_TYPE을 3으로 조회
			sb.append(sm.addFixString(" AND CODE_NO = (SELECT SELLER_CODE FROM SCPGL WHERE CONT_NO = ?) \n"));sm.addStringParameter(cont_no);
			
			SepoaFormater sf1 = new SepoaFormater( sm.doSelect( sb.toString() ) );
			
			int exist_cnt1 = sf1.getRowCount();
			
			if( exist_cnt1 > 0 ) {
				
				Map<String, String> param = new HashMap<String, String>();
				
				param.put("HOUSE_CODE", info.getSession("HOUSE_CODE") );//하우스코드
				param.put("CONT_NO",    cont_no);//세금계산서번호
				param.put("MOBILE_NO",  sf1.getValue("MOBILE_NO", 0) );//공급자 모바일번호
				
				new SMS("NONDBJOB", info).ct1Process(ctx, param);
				
			}
			
			
		}
					
		  catch (Exception e) {
//			  	e.printStackTrace();
				setMessage(e.getMessage());
			try {
				
				Rollback();
			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}
			
//			e.printStackTrace();
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	public SepoaOut getContractAbolSignBuyer( String cont_no,  String cont_gl_seq, String stamp_tax_no, String stamp_tax_amt, String signedData, String aMDN1 )
	{
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		int rtn = 0;
		
		String sign_user_code = info.getSession("ID");
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("  UPDATE SCPGL SET         \n");
			sb.append("     CT_FLAG        = ?    \n");sm.addStringParameter("CL");
			sb.append("    ,CHANGE_USER_ID = ?    \n");sm.addStringParameter(info.getSession("ID"));
			sb.append("    ,CHANGE_DATE    = ?    \n");sm.addStringParameter(SepoaDate.getShortDateString());
			sb.append("    ,CHANGE_TIME    = ?    \n");sm.addStringParameter(SepoaDate.getShortTimeString());
			sb.append("  WHERE CONT_NO     = ?    \n");sm.addStringParameter(cont_no);
			sb.append("  AND   CONT_GL_SEQ = ?    \n");sm.addStringParameter(cont_gl_seq);
			
			rtn = sm.doUpdate(sb.toString());
			
			//추가수정_20171127
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("  UPDATE SSIGN SET         \n");
			sb.append("     BUYER_SIGN   = ?      \n");sm.addStringParameter(signedData);
			sb.append("    ,BUYER_DN     = ?      \n");sm.addStringParameter(aMDN1);
			sb.append("  WHERE CONT_NO     = ?    \n");sm.addStringParameter(cont_no);
			sb.append("  AND   CONT_COUNT  = ?    \n");sm.addStringParameter(cont_gl_seq);
			sb.append("  AND   CONT_COUNT  = ?    \n");sm.addStringParameter(cont_gl_seq);
			sb.append("  AND   SIGN_HASH  = 'D'    \n");
			
			
			rtn = sm.doUpdate(sb.toString());
			
				
//			sm.removeAllValue();
//			sb.delete(0, sb.length());
//			sb.append("	SELECT							\n");
//			sb.append("		 PR_NO						\n");
//			sb.append("		,PR_SEQ						\n");
//			sb.append("	FROM SCPLN						\n");
//			sb.append("	WHERE NVL(DEL_FLAG, 'N') = 'N'	\n");
//			sb.append(sm.addSelectString("	  AND CONT_NO = ?	\n"));
//			sm.addStringParameter(cont_no);
//			SepoaFormater wwf = new SepoaFormater(sm.doSelect(sb.toString()));
//			
//			if(wwf.getRowCount() > 0) {
//				for(int i=0; i<wwf.getRowCount(); i++) {
//					//PR������ ���� �������{scode_type=M157}
//					sm.removeAllValue();
//					sb.delete(0, sb.length());
//					sb.append("		UPDATE SPRLN SET			\n");
//					sb.append("			 PR_PROCEEDING_FLAG = ?	\n");sm.addStringParameter("CD");//��ü����
//					sb.append("			,DEL_FLAG			= ?	\n");sm.addStringParameter("N");
//					sb.append("			,CHANGE_USER_ID		= ?	\n");sm.addStringParameter(info.getSession("ID"));
//					sb.append("			,CHANGE_DATE		= ?	\n");sm.addStringParameter(SepoaDate.getShortDateString());
//					sb.append("			,CHANGE_TIME		= ?	\n");sm.addStringParameter(SepoaDate.getShortTimeString());
//					sb.append("		WHERE PR_NUMBER	= ?			\n");sm.addStringParameter(wwf.getValue("PR_NO", i));
//					sb.append("		  AND PR_SEQ	= ?			\n");sm.addStringParameter(wwf.getValue("PR_SEQ", i));
//					sm.doUpdate(sb.toString());
//				}
//			}
	
			setStatus(1);
			Commit();
			
			
//			//전자계약서 알림 SMS 전송
//			//공급자 모바일번호 조회
//			sm.removeAllValue();
//			sb.delete(0, sb.length());
//			sb.append("                 SELECT                                                          \n");
//			sb.append("                  PHONE_NO2 AS MOBILE_NO                                         \n");
//			sb.append("                 FROM ICOMADDR                                                   \n");
//			sb.append("                 WHERE 1 = 1                                                     \n");
//			sb.append("                 AND CODE_TYPE = '3'                                             \n");//회사나 업체가 아니라 담당자에게 가야하므로 CODE_TYPE을 3으로 조회
//			sb.append(sm.addFixString(" AND CODE_NO = (SELECT SELLER_CODE FROM SCPGL WHERE CONT_NO = ?) \n"));sm.addStringParameter(cont_no);
//			
//			SepoaFormater sf1 = new SepoaFormater( sm.doSelect( sb.toString() ) );
//			
//			int exist_cnt1 = sf1.getRowCount();
//			
//			if( exist_cnt1 > 0 ) {
//				
//				Map<String, String> param = new HashMap<String, String>();
//				
//				param.put("HOUSE_CODE", info.getSession("HOUSE_CODE") );//하우스코드
//				param.put("CONT_NO",    cont_no);//세금계산서번호
//				param.put("MOBILE_NO",  sf1.getValue("MOBILE_NO", 0) );//공급자 모바일번호
//				
//				new SMS("NONDBJOB", info).ct1Process(ctx, param);
//				
//			}
			
			
		}
					
		  catch (Exception e) {
//			  	e.printStackTrace();
				setMessage(e.getMessage());
			try {
				
				Rollback();
			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}
			
//			e.printStackTrace();
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
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
	public SepoaOut createInfoData(Map<String, String> params) {
		
 		int	rtn	= -1;
 		ConnectionContext ctx =	getConnectionContext();
 		
 		SepoaXmlParser wxp0 	= new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_0");
 		SepoaXmlParser wxp_del1	= new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_del1");
 		SepoaXmlParser wxp_del2	= new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_del2");
 		SepoaXmlParser wxp1 	= new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
 		SepoaXmlParser wxp2 	= new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
 		SepoaSQLManager sm 		= null;
 		
 		try
 		{
 			setStatus(1);
 			setFlag(true);
 			
 			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp0.getQuery());
 			SepoaFormater sf = new SepoaFormater(sm.doSelect(params));
 			
 			if( sf.getRowCount() > 0){
 				params.put("COMPANY_CODE"		, sf.getValue("COMPANY_CODE", 0));
 				params.put("PURCHASE_LOCATION"	, sf.getValue("PURCHASE_LOCATION", 0));
 				params.put("ITEM_NO"			, sf.getValue("ITEM_NO", 0));
 				params.put("VENDOR_CODE"		, sf.getValue("VENDOR_CODE", 0));
 				
 				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp_del1.getQuery());
 				rtn = sm.doDelete(params);
 				
 				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp_del2.getQuery());
 				rtn = sm.doDelete(params);
 			}
 			
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp1.getQuery());
			rtn = sm.doInsert(params);
 				
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp2.getQuery());
			rtn = sm.doInsert(params);
 			
 			setStatus(1);
 			Commit();
 		}
 		catch(Exception e)
 		{
// 			e.printStackTrace();
 			rtn	= -1;
 		}
 		return getSepoaOut();
 	}	
	
	public SepoaOut setCollection(String cont_no, String cont_gl_seq) throws Exception {
		try {
				String flag  = bl_SCPGL_CNT(cont_no, cont_gl_seq);

				Logger.debug.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
				Logger.debug.println("flag");
				Logger.debug.println(flag);
				Logger.debug.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
				
				// C : 업체인증 AND 결재요청전
				// D : 업체폐기승인
				if (!"C".equals(flag) && !"D".equals(flag)){
					setFlag(false);
					setStatus(0);
					setMessage("(업체인증이고 결재요청전) 또는 업체폐기승인시만 회수 가능합니다.");
					return getSepoaOut();
				}
				
				int rtn = in_SCPGL_update(cont_no, cont_gl_seq);

				if(rtn==0) {
					Rollback();
					setFlag(false);
					setStatus(0);
					setMessage(msg.getMessage("9003"));

					return getSepoaOut();
				}
				
				in_SSIGN_delete(cont_no, cont_gl_seq, flag);
				
				//  (C : 업체인증 AND 결재요청전) 회수시 수입인지내역 삭제
				if ("C".equals(flag)){
					in_SCOTX_delete(cont_no, cont_gl_seq);
				}
				setFlag(true);
				setMessage("회수처리가 완료 되었습니다.");

				Commit();
				setStatus(1);
				setValue("");
			}
		catch (Exception e){
			try {
					Rollback();
				} 
			catch(Exception d) {
				Logger.err.println(userid,this,d.getMessage());
			}
			setValue(e.getMessage().trim());
			setStatus(0);
			setMessage(e.getMessage().trim());
		}
		return getSepoaOut();
	}

	private String bl_SCPGL_CNT(String cont_no, String cont_gl_seq) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args      = { cont_no, cont_gl_seq, cont_no, cont_gl_seq, cont_no, cont_gl_seq };
			SepoaFormater wf   = new SepoaFormater(sm.doSelect(args));
			rtn = wf.getValue(0,0);
		} catch (Exception e) {
			throw new Exception("bl_SCPGL_CNT:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	private int in_SCPGL_update(String cont_no, String cont_gl_seq) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("cont_no"	 , cont_no);
				wxp.addVar("cont_gl_seq" , cont_gl_seq);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

				rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_SCPGL_update:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}

	private int in_SSIGN_delete(String cont_no, String cont_gl_seq, String flag) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("cont_no"	 , cont_no);
				wxp.addVar("cont_gl_seq" , cont_gl_seq);
				wxp.addVar("flag" , flag);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

				rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_SSIGN_delete:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}

	private int in_SCOTX_delete(String cont_no, String cont_gl_seq) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("cont_no"	 , cont_no);
				wxp.addVar("cont_gl_seq" , cont_gl_seq);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

				rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_SCOTX_delete:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}
}