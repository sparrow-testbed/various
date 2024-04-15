package sepoa.svc.contract;

import java.text.DecimalFormat;
import java.util.StringTokenizer;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;

public class CT_020 extends SepoaService
{
	private String ID = info.getSession("ID");

	public CT_020(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		setVersion("1.0.0");
	}

	public String getConfig(String s)
	{
		try
		{
			Configuration configuration = new Configuration();
			s = configuration.get(s);

			return s;
		}
		catch (ConfigurationException configurationexception)
		{
			Logger.sys.println("getConfig error : " + configurationexception.getMessage());
		}
		catch (Exception exception)
		{
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}

		return null;
	}

	public SepoaOut getContractUpdateSelectInfo( String cont_no) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("      SELECT                             \n");
			sqlsb.append("           CONT_NO                       \n");
			sqlsb.append("      	,DP_PLAN_DATE                  \n");
			sqlsb.append("      	,DP_AMT                        \n");
			sqlsb.append("      	,DP_PAY_TERMS                  \n");
			sqlsb.append("      FROM SCPDP                         \n");
			sqlsb.append("      WHERE NVL(DEL_FLAG, 'N') = 'N'     \n");
			sqlsb.append(sm.addSelectString("     AND CONT_NO = ?  \n"));
			sm.addStringParameter(cont_no);
			sqlsb.append("      ORDER BY CONT_NO, DP_SEQ           \n");
			
			setValue(sm.doSelect(sqlsb.toString()));
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
		
	}

	public SepoaOut getContractCreateList( String from_date, String to_date, String ctrl_person_id, String cont_type, String ele_cont_flag, String assure_flag, String seller_code, String subject, String ct_flag, String cont_process_flag) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("      SELECT DISTINCT                                                                  \n");
			sqlsb.append("      	 GL.CONT_NO                                                                  \n");
			sqlsb.append("      	,GL.SUBJECT                                                                  \n");
			sqlsb.append("      	,GETCODETEXT2('M800', GL.CONT_TYPE,     'KO') AS CONT_TYPE                   \n");
			sqlsb.append("      	,GETCODETEXT2('M807', GL.ASSURE_FLAG,   'KO') AS ASSURE_FLAG                 \n");
			sqlsb.append("      	,GETCODETEXT2('M806', GL.ELE_CONT_FLAG, 'KO') AS ELE_CONT_FLAG_TEXT          \n");
			sqlsb.append("      	,GL.ELE_CONT_FLAG               											 \n");
			sqlsb.append("      	,GL.CONT_DATE                                                                \n");
			sqlsb.append("      	,SIGN_PERSON_NAME AS SIGN_PERSON_NAME    									 \n");
			sqlsb.append("      	,GL.SELLER_CODE                                                              \n");
			sqlsb.append("      	,GETCOMPANYNAMELOC(GL.SELLER_CODE, 'S')       AS SELLER_NAME                 \n");
			sqlsb.append("      	,GL.CONT_TYPE AS CONT                                                        \n");
			sqlsb.append("      	,GL.CT_FLAG                                                        			 \n");
			sqlsb.append("      	,GL.BD_NO                                                         			 \n");
			sqlsb.append("      	,GL.BD_COUNT                                                      			 \n");
			sqlsb.append("      	,GETCODETEXT2('M286', GL.CT_FLAG, 'KO') AS CT_FLAG_TEXT                      \n");
			sqlsb.append("          ,CONT_FORM_NO  -- 계약서식 번호		                                         \n");
			sqlsb.append("          ,SIGN_PERSON_ID  -- 계약담당자 아이디		                                     \n");			
			sqlsb.append("          ,CONT_AMT  -- 계약금액(원화)		                                             \n");
			sqlsb.append("          ,CONT_GL_SEQ   					                                             \n");
			sqlsb.append("          ,GETCODETEXT1('M809', GL.CONT_PROCESS_FLAG, 'KO') AS CONT_PROCESS_FLAG   	 \n");
			sqlsb.append("      FROM SCPGL GL		                                                             \n");
			sqlsb.append("      WHERE NVL(GL.DEL_FLAG, 'N') = 'N'                                                \n");
			sqlsb.append("        AND GL.CT_FLAG IN ('CT', 'CW', 'CE')                                           \n");
			sqlsb.append(sm.addSelectString("     AND SIGN_PERSON_ID = ?                                     	 \n"));
			//sm.addStringParameter(info.getSession("ID"));
			sm.addStringParameter(ctrl_person_id);
			
			sqlsb.append(sm.addSelectString("     AND GL.CONT_DATE BETWEEN ?                                     \n"));
			sm.addStringParameter(from_date);
			sqlsb.append(sm.addSelectString("     AND ?                                                          \n"));
			sm.addStringParameter(to_date);
			
			//sqlsb.append(sm.addSelectString("     AND GL.CTRL_PERSON_ID  = ?                                     \n"));
			//sm.addStringParameter(ctrl_person_id);
			//sqlsb.append(sm.addSelectString("     AND GL.CONT_TYPE = ?                                           \n"));
			//sm.addStringParameter(cont_type);
			
			sqlsb.append(sm.addSelectString("     AND GL.ELE_CONT_FLAG = ?                                       \n"));
			sm.addStringParameter(ele_cont_flag);
			
			//sqlsb.append(sm.addSelectString("     AND GL.ASSURE_FLAG = ?                                         \n"));
			//sm.addStringParameter(assure_flag);
			
			sqlsb.append(sm.addSelectString("     AND GL.SELLER_CODE = ?                                         \n"));
			sm.addStringParameter(seller_code);
			sqlsb.append(sm.addSelectString("     AND GL.SUBJECT LIKE '%' || ? || '%'                            \n"));
			sm.addStringParameter(subject);			
			
			sqlsb.append(sm.addSelectString("     AND GL.CT_FLAG  = ?                            				 \n"));
			sm.addStringParameter(ct_flag);				
			
			sqlsb.append(sm.addSelectString("     AND GL.CONT_PROCESS_FLAG  = ?                            		 \n"));
			sm.addStringParameter(cont_process_flag);
			
			sqlsb.append("      ORDER BY CONT_NO DESC                                                            \n");
//			System.out.println(sqlsb.toString());
			setValue(sm.doSelect(sqlsb.toString()));
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
		
	}
	
	public SepoaOut getContractCreateDelete(String[][] bean_args) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		String cont_no = "";
		SepoaOut wo = null;
		wo = DocumentUtil.getDocNumber(info, "CT");
		cont_no = wo.result[0];

		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			int cnt = 0;
			for (int i = 0; i < bean_args.length; i++)
			{
				String CONT_NO      = bean_args[i][0];
				String BD_NO        = bean_args[i][1];
				String BD_COUNT     = bean_args[i][2];
				String SELLER_CODE	= bean_args[i][3];
				String CONT_GL_SEQ	= bean_args[i][4];

				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("     UPDATE ICOYBDHD SET            				  \n");
				sqlsb.append("          CTRL_FLAG = 'N'          				  \n");
				sqlsb.append("     WHERE BID_NO	= (            					  \n");
				sqlsb.append("   				   SELECT  TEXT_NUMBER            \n");
				sqlsb.append("   				   FROM    SCPGL                  \n");
				sqlsb.append("   				   WHERE   CONT_NO      = ?       \n"); sm.addStringParameter(CONT_NO);
				sqlsb.append("   				   AND     CONT_GL_SEQ  = ?       \n"); sm.addStringParameter(CONT_GL_SEQ);
				sqlsb.append("   				  )					              \n");
				sm.doDelete(sqlsb.toString());
				
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("     DELETE FROM SCPGL                \n");
				sqlsb.append("     WHERE CONT_NO      = ?           \n");sm.addStringParameter(CONT_NO);
				sqlsb.append("     AND   CONT_GL_SEQ  = ?           \n");sm.addStringParameter(CONT_GL_SEQ);
				sm.doDelete(sqlsb.toString());

				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("     DELETE FROM SCPLN                \n");
				sqlsb.append("     WHERE CONT_NO      = ?           \n");sm.addStringParameter(CONT_NO);
				sqlsb.append("     AND   CONT_GL_SEQ  = ?           \n");sm.addStringParameter(CONT_GL_SEQ);
				sm.doDelete(sqlsb.toString());
				
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("     DELETE FROM SCPMT                \n");
				sqlsb.append("     WHERE CONT_NO      = ?           \n");sm.addStringParameter(CONT_NO);
				sqlsb.append("     AND   CONT_GL_SEQ  = ?           \n");sm.addStringParameter(CONT_GL_SEQ);
				sm.doDelete(sqlsb.toString());
				
			}
			Commit();
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}

	public SepoaOut getContractUpdateSelect( String cont_no, String cont_gl_seq ) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		String language = info.getSession("LANGUAGE");

		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("    SELECT                               \n");
			sqlsb.append("    	 A.CONT_NO                           \n");
			sqlsb.append("    	,A.CONT_GL_SEQ                       \n");
			sqlsb.append("    	,A.SUBJECT                           \n");
			sqlsb.append("    	,A.CONT_GUBUN                        \n");
			sqlsb.append("    	,A.PROPERTY_YN                       \n");
			sqlsb.append("    	,A.SELLER_CODE                       \n");
			sqlsb.append("    	,GETCOMPANYNAMELOC('"+info.getSession("HOUSE_CODE")+"', A.SELLER_CODE, 'S') AS SELLER_NAME	\n");
			sqlsb.append("    	,A.SIGN_PERSON_ID                    \n");
			sqlsb.append("    	,A.SIGN_PERSON_NAME                  \n");
			sqlsb.append("    	,A.CONT_FROM                         \n");
			sqlsb.append("    	,A.CONT_TO                           \n");
			sqlsb.append("    	,A.CONT_DATE                         \n");
			sqlsb.append("    	,A.CONT_ADD_DATE                     \n");
			sqlsb.append("    	,A.CONT_TYPE                         \n");
			sqlsb.append("    	,A.ELE_CONT_FLAG                     \n");
			sqlsb.append("    	,A.ASSURE_FLAG                       \n");
			sqlsb.append("    	,A.START_START_INS_FLAG              \n");
			sqlsb.append("    	,A.CONT_PROCESS_FLAG                 \n");
			sqlsb.append("    	,A.CONT_AMT                          \n");
			sqlsb.append("    	,A.CONT_ASSURE_PERCENT               \n");
			sqlsb.append("    	,A.CONT_ASSURE_AMT                   \n");
			sqlsb.append("    	,A.FAULT_INS_PERCENT                 \n");
			sqlsb.append("    	,A.FAULT_INS_AMT                     \n");
			sqlsb.append("    	,A.PAY_DIV_FLAG                      \n");
			sqlsb.append("    	,A.FAULT_INS_TERM                    \n");
			sqlsb.append("    	,A.BD_NO                             \n");
			sqlsb.append("    	,A.BD_COUNT                          \n");
			sqlsb.append("    	,A.AMT_GUBUN                         \n");
			sqlsb.append("    	,A.TEXT_NUMBER                       \n");
			sqlsb.append("    	,A.DELAY_CHARGE                      \n");
			sqlsb.append("    	,A.DELV_PLACE                        \n");
			sqlsb.append("    	,A.REMARK                            \n");
			sqlsb.append("    	,A.CTRL_DEMAND_DEPT                  \n");
			sqlsb.append("    	,GETCODETEXT2('M286', A.CT_FLAG, 'KO') AS CT_FLAG_TEXT 		\n");
			sqlsb.append("    	,A.CT_FLAG					 	   \n");			
			sqlsb.append("    	,A.CTRL_CODE                         \n");
			sqlsb.append("    	,A.COMPANY_CODE                      \n");
			sqlsb.append("    	,A.ACCOUNT_CODE                      \n");
			sqlsb.append("    	,A.ACCOUNT_NAME                      \n");
			sqlsb.append("    	,A.REJECT_REASON                      \n");
			sqlsb.append("    	,A.RFQ_TYPE                          \n");
			sqlsb.append("    	,A.CONT_TYPE1_TEXT                   \n");
			sqlsb.append("    	,A.CONT_TYPE2_TEXT                   \n");
			sqlsb.append("      ,(                                        \n ");
			sqlsb.append("         SELECT MAX( CONT_GL_SEQ )              \n ");
			sqlsb.append("         FROM   SCPGL                           \n ");
			sqlsb.append("         WHERE  CONT_NO            = A.CONT_NO  \n ");
			sqlsb.append("         AND    NVL(DEL_FLAG, 'N') = 'N'        \n ");
			sqlsb.append("       )      AS MAX_CONT_GL_SEQ				  \n ");
			sqlsb.append("    	,A.DELV_PLACE                             \n ");
			sqlsb.append("    	,A.SG_LEV1      	                      \n ");
			sqlsb.append("    	,A.SG_LEV2	                              \n ");
			sqlsb.append("    	,A.SG_LEV3  	                          \n ");
			sqlsb.append("    	,A.ADD_TAX_FLAG	                          \n ");
			sqlsb.append("    	,A.ITEM_TYPE	                          \n ");
			sqlsb.append("    	,A.RD_DATE	                          \n ");
			sqlsb.append("    	,A.CONT_TOTAL_GUBUN	                          \n ");
			sqlsb.append("    	,A.CONT_PRICE	                          \n ");
			sqlsb.append("    	,A.BEFORE_CONT_FROM	                          \n ");
			sqlsb.append("    	,A.BEFORE_CONT_TO	                          \n ");
			sqlsb.append("    	,A.BEFORE_CONT_AMT	                          \n ");
			sqlsb.append("    	,A.BEFORE_ITEM_TYPE	                          \n "); 
			sqlsb.append("    	,A.TTL_ITEM_QTY	                          \n "); 
			sqlsb.append("    	,A.EXEC_NO	                          \n "); 			
			sqlsb.append("    	,(SELECT DISTINCT SG_NAME FROM SSGGL WHERE LEVEL_COUNT = 1 AND NOTICE_FLAG='Y' AND NVL(DEL_FLAG, 'N')= 'N' AND USE_FLAG= 'Y' AND SG_REFITEM = A.SG_LEV1) AS SG_LEV1_TEXT            \n ");
			sqlsb.append("    	,(SELECT DISTINCT SG_NAME FROM SSGGL WHERE LEVEL_COUNT = 2 AND NOTICE_FLAG='Y' AND NVL(DEL_FLAG, 'N')= 'N' AND USE_FLAG= 'Y' AND SG_REFITEM = A.SG_LEV2) AS SG_LEV2_TEXT            \n ");
			sqlsb.append("    	,(SELECT DISTINCT SG_NAME FROM SSGGL WHERE LEVEL_COUNT = 3 AND NOTICE_FLAG='Y' AND NVL(DEL_FLAG, 'N')= 'N' AND USE_FLAG= 'Y' AND SG_REFITEM = A.SG_LEV3) AS SG_LEV3_TEXT            \n ");			
			sqlsb.append("    	,(SELECT TEXT2 FROM SCODE WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"' AND TYPE = 'M809' AND USE_FLAG = 'Y' AND CODE = A.CONT_PROCESS_FLAG)    AS CONT_PROCESS_FLAG_TEXT  \n "); 			
			sqlsb.append("    	,(SELECT TEXT2 FROM SCODE WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"' AND TYPE = 'M989' AND USE_FLAG = 'Y' AND CODE = A.CONT_TYPE1_TEXT)      AS CONT_TYPE1_TEXT_TEXT	\n "); 
			sqlsb.append("    	,(SELECT TEXT2 FROM SCODE WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"' AND TYPE = 'M930' AND USE_FLAG = 'Y' AND CODE = A.CONT_TYPE2_TEXT)      AS CONT_TYPE2_TEXT_TEXT    \n ");			
			sqlsb.append("    	,(SELECT TEXT2 FROM SCODE WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"' AND TYPE = 'M223' AND USE_FLAG = 'Y' AND CODE = A.ELE_CONT_FLAG)        AS ELE_CONT_FLAG_TEXT      \n "); 
			sqlsb.append("    	,(SELECT TEXT2 FROM SCODE WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"' AND TYPE = 'M899' AND USE_FLAG = 'Y' AND CODE = A.CONT_TYPE)            AS CONT_TYPE_TEXT          \n ");						
			sqlsb.append("    	,(SELECT TEXT2 FROM SCODE WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"' AND TYPE = 'M355' AND USE_FLAG = 'Y' AND CODE = A.ASSURE_FLAG)          AS ASSURE_FLAG_TEXT        \n "); 
			sqlsb.append("    	,(SELECT TEXT2 FROM SCODE WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"' AND TYPE = 'M204' AND USE_FLAG = 'Y' AND CODE = A.CONT_TOTAL_GUBUN)     AS CONT_TOTAL_GUBUN_TEXT   \n "); 					
			
			
			sqlsb.append("    	,DECODE(NVL(A.CHK_USER_ID,'0'),'0','0','1') AS CHK_FG	                               \n "); 			
			sqlsb.append("    	,TO_CHAR(TO_DATE(A.CHK_DATE,'YYYYMMDD'),'YYYY. MM. DD') AS  CHK_DATE	               \n "); 			
			sqlsb.append("    	,A.CHK_TIME	                                                                           \n "); 			
			sqlsb.append("    	,A.CHK_USER_ID	                                                                       \n "); 		
			sqlsb.append("    	,GETUSERNAMELOC('"+info.getSession("HOUSE_CODE")+"', A.CHK_USER_ID) AS CHK_USER_NAME   \n "); 		
			
			sqlsb.append("    	,A.SIGN_STATUS					 	   \n");						
			
			
			/*
			sqlsb.append("    	,A.REQ_DEPT \n ");
			sqlsb.append("    	,A.REQ_DEPT_NAME \n ");
			sqlsb.append("    	,A.APP_DATE \n ");
			sqlsb.append("    	,A.PREV_SIGN_PERSON_ID \n ");
			sqlsb.append("    	,A.PREV_SIGN_PERSON_NAME \n ");
			sqlsb.append("    	,A.APP_AMT \n ");
			sqlsb.append("    	,A.PR_DATE \n ");
			sqlsb.append("    	,A.BUDGET_AMT \n ");
			sqlsb.append("    	,A.PAY_DATE \n ");
			sqlsb.append("    	,A.IN_PRICE_AMT \n ");
			sqlsb.append("    	,A.BE_PRICE_AMT \n ");
			sqlsb.append("    	,A.APP_REMARK \n ");
			sqlsb.append("    	,A.AUTO_EXTEND_FLAG \n ");
			sqlsb.append("    	,A.ITEM_QTY \n ");
			sqlsb.append("    	,A.IN_ATTACH_NO \n ");
			sqlsb.append("    	,GETFILEATTCOUNT(A.IN_ATTACH_NO) AS IN_ATTACH_CNT \n ");
			*/
			
			/*sqlsb.append("		,(SELECT CONFIRM_USER_ID								\n");//�˼����� ���̵� �ҷ��1�
			sqlsb.append("		  FROM SPRGL											\n");
			sqlsb.append("		  WHERE NVL(DEL_FLAG, 'N') = 'N'						\n");
			sqlsb.append("		  AND PR_NUMBER = (SELECT PR_NO							\n");
			sqlsb.append("							 FROM SCPLN							\n");
			sqlsb.append("							 WHERE NVL(DEL_FLAG, 'N') = 'N'		\n");
			sqlsb.append(sm.addSelectString("		 AND CONT_NO = ?					\n"));
			sm.addStringParameter(cont_no);
			sqlsb.append("							 AND CONT_SEQ = '1')) CONFIRM_USER_ID  \n");
			sqlsb.append("		,(SELECT CONFIRM_USER_NAME								\n");//�˼����� �̸� �ҷ��1�
			sqlsb.append("		  FROM SPRGL											\n");
			sqlsb.append("		  WHERE NVL(DEL_FLAG,ㅊ 'N') = 'N'						\n");
			sqlsb.append("		  AND PR_NUMBER = (SELECT PR_NO							\n");
			sqlsb.append("							 FROM SCPLN							\n");
			sqlsb.append("							 WHERE NVL(DEL_FLAG, 'N') = 'N'		\n");
			sqlsb.append(sm.addSelectString("		 AND CONT_NO = ?					\n"));
			sm.addStringParameter(cont_no);
			sqlsb.append("							 AND CONT_SEQ = '1')) CONFIRM_USER_NAME  \n");*/
		
			sqlsb.append("    FROM SCPGL      A                     \n");
			sqlsb.append("    WHERE NVL(A.DEL_FLAG, 'N') = 'N'       \n");
			sqlsb.append(sm.addSelectString("     AND A.CONT_NO = ?                   \n"));
			sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString("     AND A.CONT_GL_SEQ = ?                   \n"));
			sm.addStringParameter(cont_gl_seq);			
			sqlsb.append("    ORDER BY A.CONT_NO DESC                                 \n");
			setValue(sm.doSelect(sqlsb.toString()));
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
		
	}
	
	//���۾��༭ �� ȭ�� �ε��Ҷ� �ѷ��ִ� d��
	public SepoaOut getContractInsertSelect( String pr_number) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		String language = info.getSession("LANGUAGE");

		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("    SELECT                               					\n");
			sqlsb.append("    	 ACCOUNTS_COURSES_CODE AS ACCOUNT_CODE             	\n");
			sqlsb.append("    	,ACCOUNTS_COURSES_LOC AS ACCOUNT_NAME             	\n");
			sqlsb.append("    	,CONFIRM_USER_ID					             	\n");
			sqlsb.append("    	,CONFIRM_USER_NAME					             	\n");
			sqlsb.append("    FROM SPRGL                           					\n");
			sqlsb.append("    WHERE NVL(DEL_FLAG, 'N') = 'N'       					\n");
			sqlsb.append(sm.addSelectString("     AND PR_NUMBER = ?                 \n"));
			sm.addStringParameter(pr_number);
			
			setValue(sm.doSelect(sqlsb.toString()));
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
		
	}
	
	//�����༭ �� ȭ�� �ε��Ҷ� �ѷ��ִ� d��
	public SepoaOut getQTAContractInsertSelect(String rfq_number) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		String language = info.getSession("LANGUAGE");

		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
							
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("	SELECT																\n");
			sqlsb.append("	ACCOUNTS_COURSES_CODE AS ACCOUNT_CODE								\n");
			sqlsb.append("	,ACCOUNTS_COURSES_LOC AS ACCOUNT_NAME								\n");
			sqlsb.append("	,CONFIRM_USER_ID													\n");
			sqlsb.append("	,CONFIRM_USER_NAME													\n");
			sqlsb.append("	FROM SPRGL															\n");
			sqlsb.append("	WHERE NVL(DEL_FLAG, 'N') = 'N' 										\n");
			sqlsb.append("	AND PR_NUMBER = (SELECT PR_NUMBER									\n");
			sqlsb.append("					 FROM SRQLN											\n");
			sqlsb.append("					 WHERE NVL(DEL_FLAG, 'N') = 'N' 					\n");
			sqlsb.append("					 AND RFQ_NUMBER = (SELECT RFQ_NUMBER				\n");
			sqlsb.append("									   FROM SQTGL						\n");
			sqlsb.append("									   WHERE NVL(DEL_FLAG, 'N') = 'N' 	\n");
			sqlsb.append(sm.addSelectString("				   AND QTA_NUMBER = ?)				\n"));
			sm.addStringParameter(rfq_number);
			sqlsb.append("					 AND RFQ_COUNT = '1'								\n");
			sqlsb.append("					 AND RFQ_SEQ = '000001')							\n");
			
			setValue(sm.doSelect(sqlsb.toString()));
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
		
	}
	
//	�����༭ �� ȭ�� �ε��Ҷ� �ѷ��ִ� d��
	public SepoaOut getVTContractInsertSelect(String rfq_number) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		String language = info.getSession("LANGUAGE");

		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("	SELECT																\n");
			sqlsb.append("	ACCOUNTS_COURSES_CODE AS ACCOUNT_CODE								\n");
			sqlsb.append("	,ACCOUNTS_COURSES_LOC AS ACCOUNT_NAME								\n");
			sqlsb.append("	,CONFIRM_USER_ID													\n");
			sqlsb.append("	,CONFIRM_USER_NAME													\n");
			sqlsb.append("	FROM SPRGL															\n");
			sqlsb.append("	WHERE NVL(DEL_FLAG, 'N') = 'N' 										\n");
			sqlsb.append("	AND PR_NUMBER = (SELECT PR_NUMBER									\n");
			sqlsb.append("					 FROM SEBLN											\n");
			sqlsb.append("					 WHERE NVL(DEL_FLAG, 'N') = 'N' 					\n");
			sqlsb.append("					 AND BD_NO = (SELECT BD_NO							\n");
			sqlsb.append("								  FROM SEBVO							\n");
			sqlsb.append("							      WHERE NVL(DEL_FLAG, 'N') = 'N' 		\n");
			sqlsb.append(sm.addSelectString("			  AND VOTE_NO = ?)						\n"));
			sm.addStringParameter(rfq_number);
			sqlsb.append("					 AND BD_COUNT = '1'									\n");
			sqlsb.append("					 AND BD_SEQ = '1')									\n");
			
			setValue(sm.doSelect(sqlsb.toString()));
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
		
	}

	public SepoaOut getContractCreateListUpdate(String cont_no, String cont_gl_seq) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		String language = info.getSession("LANGUAGE");
		String COMPANY_CODE = info.getSession("COMPANY_CODE");
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("    SELECT                  \n");
			sqlsb.append("    	 CONT_NO                      \n");
			sqlsb.append("            ,CONT_SEQ             \n");
			sqlsb.append("            ,DESCRIPTION_LOC as ANN_ITEM        \n"); // 입찰건명
			sqlsb.append("            ,ITEM_AMT as SUM_AMT            \n");
			sqlsb.append("            ,DELV_PLACE           \n");
			sqlsb.append("            ,PR_NO                \n");//���ſ�û��ȣ
			sqlsb.append("            ,RD_DATE  as  DLVRYDSREDATE 			\n");
			sqlsb.append("            ,COMPANY_CODE  as VENDOR_CODE 		\n");
			sqlsb.append("            ,CUR   		\n");
			sqlsb.append("            ,ESTIMATE_PRICE  as ASUMTNAMT 		\n");
			sqlsb.append("            ,MAKER  as VENDOR_NAME 		\n");

			sqlsb.append("    FROM SCPLN                      \n");
			sqlsb.append("    WHERE NVL(DEL_FLAG, 'N') = 'N'  \n");
			sqlsb.append(sm.addSelectString(" AND CONT_NO = ? \n"));
			sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString(" AND CONT_GL_SEQ = ? \n"));
			sm.addStringParameter(cont_gl_seq);			
			sqlsb.append("      ORDER BY CONT_NO DESC, CONT_SEQ, SELLER_CODE, PR_NO, PR_SEQ         \n");
			
			setValue(sm.doSelect(sqlsb.toString()));
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
		
	}

	public SepoaOut getContractUpdate(
			String subject, 			String sg_type1, 			String sg_type2, 				String sg_type3, 			
			String seller_code, 		String seller_name,
			String sign_person_id, 		String sign_person_name, 	String cont_from,				String cont_to, 			String cont_date,
			String cont_add_date, 		String cont_type, 			String ele_cont_flag, 			String assure_flag, 		
			String cont_process_flag, 	String cont_amt, 			String cont_assure_percent, 	String cont_assure_amt, 	String fault_ins_percent,
			String fault_ins_amt, 		String fault_ins_term, 			String bd_no, 				String bd_count,
			String amt_gubun, 			String text_number, 		String delay_charge, 			String remark,
			String cont_no,				String[][] bean_args,       String cont_gl_seq,             String cont_type1_text,
			String cont_type2_text,     String delv_place, 			String add_tax_flag,
			String item_type,			String rd_date,				String cont_total_gubun,		String cont_price,
			String before_cont_from,	String before_cont_to,		String before_cont_amt,			String before_item_type,
			String pay_div_flag,        String x_purchase_qty) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			Logger.sys.println("###################  ADD_TAX_FLAG 3 = " + add_tax_flag);
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("	UPDATE SCPGL SET            	  \n");
			sqlsb.append("		 SUBJECT				= ?   \n");sm.addStringParameter(subject);
			sqlsb.append("		,SG_LEV1				= ?   \n");sm.addStringParameter(sg_type1);
			sqlsb.append("		,SG_LEV2				= ?   \n");sm.addStringParameter(sg_type2);
			sqlsb.append("		,SG_LEV3				= ?   \n");sm.addStringParameter(sg_type3);
			sqlsb.append("		,ADD_TAX_FLAG			= ?   \n");sm.addStringParameter(add_tax_flag);
			sqlsb.append("		,SELLER_CODE			= ?   \n");sm.addStringParameter(seller_code);
			//sqlsb.append("		,SELLER_NAME			= ?   \n");sm.addStringParameter(seller_name);
			
			sqlsb.append("		,SIGN_PERSON_ID			= ?   \n");sm.addStringParameter(sign_person_id);
			sqlsb.append("		,SIGN_PERSON_NAME		= ?   \n");sm.addStringParameter(sign_person_name);
			sqlsb.append("		,CONT_FROM				= ?   \n");sm.addStringParameter(cont_from);
			sqlsb.append("		,CONT_TO				= ?   \n");sm.addStringParameter(cont_to);
			sqlsb.append("		,CONT_DATE				= ?   \n");sm.addStringParameter(cont_date);
			
			sqlsb.append("		,CONT_ADD_DATE			= ?   \n");sm.addStringParameter(cont_add_date);
			sqlsb.append("		,CONT_TYPE				= ?   \n");sm.addStringParameter(cont_type);
			sqlsb.append("		,ELE_CONT_FLAG			= ?   \n");sm.addStringParameter(ele_cont_flag);
			sqlsb.append("		,ASSURE_FLAG			= ?   \n");sm.addStringParameter(assure_flag);
			
			sqlsb.append("		,CONT_PROCESS_FLAG		= ?   \n");sm.addStringParameter(cont_process_flag);
			sqlsb.append("		,CONT_AMT				= ?   \n");sm.addStringParameter(cont_amt);
			sqlsb.append("		,CONT_ASSURE_PERCENT	= ?   \n");sm.addStringParameter(cont_assure_percent);
			sqlsb.append("		,CONT_ASSURE_AMT		= ?   \n");sm.addStringParameter(cont_assure_amt);
			sqlsb.append("		,FAULT_INS_PERCENT		= ?   \n");sm.addStringParameter(fault_ins_percent);
			
			sqlsb.append("		,FAULT_INS_AMT			= ?   \n");sm.addStringParameter(fault_ins_amt);
			sqlsb.append("		,FAULT_INS_TERM			= ?   \n");sm.addStringParameter(fault_ins_term);
			sqlsb.append("		,BD_NO					= ?   \n");sm.addStringParameter(bd_no);
			sqlsb.append("		,BD_COUNT				= ?   \n");sm.addStringParameter(bd_count);
			
			sqlsb.append("		,AMT_GUBUN				= ?   \n");sm.addStringParameter(amt_gubun);
			sqlsb.append("		,TEXT_NUMBER			= ?   \n");sm.addStringParameter(text_number);
			sqlsb.append("		,DELAY_CHARGE			= ?   \n");sm.addStringParameter(delay_charge);
			sqlsb.append("		,REMARK					= ?   \n");sm.addStringParameter(remark);
			
			sqlsb.append("		,CTRL_CODE				= ?   \n");sm.addStringParameter(info.getSession("CTRL_CODE"));
			sqlsb.append("		,COMPANY_CODE			= ?   \n");sm.addStringParameter(info.getSession("COMPANY_CODE"));
			sqlsb.append("		,DEL_FLAG				= ?   \n");sm.addStringParameter("N");
			//CTRL_DEMAND_DEPT   
			//CT_FLAG
			//RFQ_TYPE
			
			sqlsb.append("		,CHANGE_USER_ID			= ?   \n");sm.addStringParameter(info.getSession("ID"));
			sqlsb.append("		,CHANGE_DATE			= ?   \n");sm.addStringParameter(SepoaDate.getShortDateString());
			sqlsb.append("		,CHANGE_TIME			= ?   \n");sm.addStringParameter(SepoaDate.getShortTimeString());
			sqlsb.append("		,CONT_TYPE1_TEXT		= ?   \n");sm.addStringParameter(cont_type1_text);
			sqlsb.append("		,CONT_TYPE2_TEXT		= ?   \n");sm.addStringParameter(cont_type2_text);
			sqlsb.append("		,DELV_PLACE		        = ?   \n");sm.addStringParameter(delv_place);
			sqlsb.append("		,ITEM_TYPE		        = ?   \n");sm.addStringParameter(item_type);
			sqlsb.append("		,RD_DATE		        = ?   \n");sm.addStringParameter(rd_date);
			sqlsb.append("		,CONT_TOTAL_GUBUN       = ?   \n");sm.addStringParameter(cont_total_gubun);
			sqlsb.append("		,CONT_PRICE		        = ?   \n");sm.addStringParameter(cont_price);
			sqlsb.append("		,BEFORE_CONT_FROM		= ?   \n");sm.addStringParameter(before_cont_from);
			sqlsb.append("		,BEFORE_CONT_TO		    = ?   \n");sm.addStringParameter(before_cont_to);
			sqlsb.append("		,BEFORE_CONT_AMT		= ?   \n");sm.addStringParameter(before_cont_amt);
			sqlsb.append("		,BEFORE_ITEM_TYPE		= ?   \n");sm.addStringParameter(before_item_type);
			sqlsb.append("		,PAY_DIV_FLAG		= ?   \n");sm.addStringParameter(pay_div_flag);			
			sqlsb.append("		,TTL_ITEM_QTY		= ?   \n");sm.addNumberParameter(x_purchase_qty);

			
            sqlsb.append("	WHERE CONT_NO				= ?   \n");sm.addStringParameter(cont_no);
			sqlsb.append("	AND   CONT_GL_SEQ			= ?   \n");sm.addStringParameter(cont_gl_seq);
			sm.doInsert(sqlsb.toString());
			
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			
			/*//계정코드가 코드 M293 에 존재하면 자산으로 분류
			sqlsb.append("	UPDATE SCPGL SET		\n");
			sqlsb.append("		PROPERTY_YN = 'Y' 		\n");
			sqlsb.append("	WHERE CONT_NO	= ?	\n");sm.addStringParameter(cont_no);
			sqlsb.append("	  AND (SELECT COUNT(*) FROM SCODE WHERE TYPE='M293' AND CODE = '"+account_code+"' AND USE_FLAG='Y' ) = 1 \n");
			sm.doUpdate(sqlsb.toString());
			*/
				
			/**
			 * 상세 사용안함 by Kavez
			 * ==========================================================================================
			 */
//			if(bean_args.length > 0) {
//				int cnt = 0;
//				for (int i = 0; i < bean_args.length; i++)
//				{
//					String ANN_ITEM            = bean_args[i][0];  //입찰건명
//					String DELV_PLACE        = bean_args[i][1]; // 납품장소
//					String BID_VENDOR_CNT               = bean_args[i][2];  //
//					String EE_VENDOR_CNT               = bean_args[i][3]; 
//					String JOIN_VENDOR_CNT               = bean_args[i][4]; 
//					String VENDOR_NAME               = bean_args[i][5]; //낙찰업체명
//					String ASUMTNAMT               = bean_args[i][6]; //예정가격
//					String ESTM_PRICE               = bean_args[i][7]; 
//					String FINAL_ESTM_PRICE_ENC               = bean_args[i][8]; 
//					String SUM_AMT               = bean_args[i][9]; //낙찰금액
//					String CUR               = bean_args[i][10]; //금액화폐단위
//					String VENDOR_CODE               = bean_args[i][11]; // 납품 업체 코드
//					String DLVRYDSREDATE               = bean_args[i][12];  //납품 요청일
//					String CONT_NO               = bean_args[i][13];  //
//					String CONT_SEQ               = bean_args[i][14];  //
//					String PR_NO               = bean_args[i][15];  // PR_NO
//					
////					if(SELLER_CODE.equals("")) {
////						SELLER_CODE = seller_code;
////					}
//
//
//					sm.removeAllValue();
//					sqlsb.delete(0, sqlsb.length());
//					sqlsb.append("     UPDATE SCPLN SET                \n");
//					sqlsb.append("            SELLER_CODE   =?       \n");sm.addStringParameter(seller_code);
//					sqlsb.append("            ,DESCRIPTION_LOC =?         \n");sm.addStringParameter(ANN_ITEM); // 입찰건명
//					
//					sqlsb.append("            ,ITEM_AMT    =?         \n");sm.addStringParameter(SUM_AMT);
//				//	sqlsb.append("            ,SUPPLY_AMT           \n");
//					
//				//	sqlsb.append("            ,SUPERTAX_AMT         \n");
//					sqlsb.append("            ,DELV_PLACE    =?       \n");sm.addStringParameter(DELV_PLACE);
//					
//					sqlsb.append("            ,CHANGE_USER_ID  = ?     \n");sm.addStringParameter(info.getSession("ID"));
//					sqlsb.append("            ,CHANGE_DATE     = ?     \n");sm.addStringParameter(SepoaDate.getShortDateString());
//					sqlsb.append("            ,CHANGE_TIME     = ?     \n");sm.addStringParameter(SepoaDate.getShortTimeString());
//					sqlsb.append("            ,DEL_FLAG       =?      \n");sm.addStringParameter("N");
//					
//					sqlsb.append("            ,PR_NO          =?      \n");sm.addStringParameter(PR_NO);
//					
//					sqlsb.append("            ,RD_DATE     		=?	\n");sm.addStringParameter(DLVRYDSREDATE);
//					sqlsb.append("            ,COMPANY_CODE   =?		\n");sm.addStringParameter(VENDOR_CODE);
//					sqlsb.append("            ,CUR   =?		\n");sm.addStringParameter(CUR);
//					sqlsb.append("            ,ESTIMATE_PRICE   =?		\n");sm.addStringParameter(ASUMTNAMT);
//					sqlsb.append("            ,MAKER   =?		\n");sm.addStringParameter(VENDOR_NAME);
//
//					
//					
//					sqlsb.append("     WHERE  CONT_NO         = ?     \n");sm.addStringParameter(CONT_NO);
//					sqlsb.append("       AND  CONT_SEQ        = ?     \n");sm.addStringParameter(CONT_SEQ);
//					sqlsb.append("       AND  SELLER_CODE     = ?     \n");sm.addStringParameter(VENDOR_CODE);
//					sm.doInsert(sqlsb.toString());
//				}
//			}
			
			/**
			 * ==========================================================================================
			 */
			
//			검수확인자 업데이트 하는 부분
		/*	if(!confirm_user_id.equals("")){
				String PR_NUMBER                    = bean_args[0][10];
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("		UPDATE SPRGL SET			\n");
				sqlsb.append("			 CONFIRM_USER_ID 	= ?	\n");sm.addStringParameter(confirm_user_id);
				sqlsb.append("			,CONFIRM_USER_NAME	= ?	\n");sm.addStringParameter(confirm_user_name);
				sqlsb.append("		WHERE PR_NUMBER	= ?			\n");sm.addStringParameter(PR_NUMBER);
				sm.doUpdate(sqlsb.toString());
			}*/
			
			/*sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("	DELETE FROM SCPDP WHERE CONT_NO = ?       \n");
			sm.addStringParameter(cont_no);
			sm.doDelete(sqlsb.toString());*/
			
//			StringTokenizer st = new StringTokenizer(setTemp, "###");
//			int cnt = 0;
//			while (st.hasMoreTokens()) {
//				cnt++;
//				
//				sm.removeAllValue();
//				sqlsb.delete(0, sqlsb.length());
//				sqlsb.append("	INSERT INTO SCPDP (       \n");
//				sqlsb.append("		 CONT_NO              \n");
//				sqlsb.append("		,DP_SEQ               \n");
//				sqlsb.append("		,ADD_USER_ID          \n");
//				sqlsb.append("		,ADD_DATE             \n");
//				sqlsb.append("		,ADD_TIME             \n");
//				sqlsb.append("		,CHANGE_USER_ID       \n");
//				sqlsb.append("		,CHANGE_DATE          \n");
//				sqlsb.append("		,CHANGE_TIME          \n");
//				sqlsb.append("		,DP_PLAN_DATE         \n");
//				sqlsb.append("		,DP_AMT               \n");
//				sqlsb.append("		,DP_PAY_TERMS         \n");
//				sqlsb.append("		,DP_PERCENT           \n");
//				sqlsb.append("		,DP_TYPE              \n");
//				sqlsb.append("		,DP_COND              \n");
//				sqlsb.append("		,DEL_FLAG             \n");
//				sqlsb.append("	) VALUES (                \n");
//				sqlsb.append("		 ?                    \n");sm.addStringParameter(cont_no);
//				sqlsb.append("		,?                    \n");sm.addStringParameter(String.valueOf(cnt));
//				sqlsb.append("		,?                    \n");sm.addStringParameter(info.getSession("ID"));
//				sqlsb.append("		,?                    \n");sm.addStringParameter(SepoaDate.getShortDateString());
//				sqlsb.append("		,?                    \n");sm.addStringParameter(SepoaDate.getShortTimeString());
//				sqlsb.append("		,?                    \n");sm.addStringParameter(info.getSession("ID"));
//				sqlsb.append("		,?                    \n");sm.addStringParameter(SepoaDate.getShortDateString());
//				sqlsb.append("		,?                    \n");sm.addStringParameter(SepoaDate.getShortTimeString());
//				sqlsb.append("		,?                    \n");sm.addStringParameter(st.nextToken());
//
//				String temp = st.nextToken();
//				Double aaa;
//				if(cont_amt.equals("0")) {
//					aaa = Double.valueOf(temp) / 1;
//				} else {
//					aaa = Double.valueOf(temp) / Double.valueOf(cont_amt);
//				}
//				String pattern = "0.##";
//				DecimalFormat df = new DecimalFormat(pattern);
//				
//				sqlsb.append("		,?                    \n");sm.addStringParameter(temp);
//				sqlsb.append("		,?                    \n");sm.addStringParameter(st.nextToken());
//				sqlsb.append("		,?                    \n");sm.addStringParameter(String.valueOf(Double.valueOf(df.format(aaa)) * Double.valueOf("100")));
//				sqlsb.append("		,?                    \n");sm.addStringParameter(pay_div_flag);
//				sqlsb.append("		,?                    \n");sm.addStringParameter("M");
//				sqlsb.append("		,?                    \n");sm.addStringParameter("N");
//				sqlsb.append("	)	                      \n");
//				sm.doInsert(sqlsb.toString());
//			  }
			
			Commit();
			
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
		
	}
	
	
	public SepoaOut setContractConfirm( String CONT_NO, String cont_date, String cont_gl_seq )
	{
	
	ConnectionContext ctx = getConnectionContext();
	StringBuffer sqlsb = new StringBuffer();
	
	try {
		setStatus(1);
		setFlag(true);
		
		
		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
		
		sm.removeAllValue();
		sqlsb.delete(0, sqlsb.length());
		sqlsb.append("	UPDATE SCPGL SET            \n");
		sqlsb.append("		 CHANGE_USER_ID   = ?   \n");sm.addStringParameter(info.getSession("ID"));
		sqlsb.append("		,CHANGE_DATE      = ?   \n");sm.addStringParameter(SepoaDate.getShortDateString());
		sqlsb.append("		,CHANGE_TIME      = ?   \n");sm.addStringParameter(SepoaDate.getShortTimeString());
		sqlsb.append("		,CT_FLAG          = ?   \n");sm.addStringParameter("CW");
		sqlsb.append("	WHERE CONT_NO         = ?   \n");sm.addStringParameter(CONT_NO);
		sqlsb.append("	AND   CONT_GL_SEQ     = ?   \n");sm.addStringParameter(cont_gl_seq);
		sm.doInsert(sqlsb.toString());
		
		/*if(bean_args.length > 0) {
			int cnt = 0;
			for (int i = 0; i < bean_args.length; i++)
			{
				String PR_NO                    = bean_args[i][0];
				String PR_SEQ                   = bean_args[i][1];
				//PR������ ���� �������{scode_type=M157}
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("		UPDATE SPRLN SET			\n");
				sqlsb.append("			 PR_PROCEEDING_FLAG = ?	\n");sm.addStringParameter("CW");//Ȯd
				sqlsb.append("			,DEL_FLAG			= ?	\n");sm.addStringParameter("N");
				sqlsb.append("			,CHANGE_USER_ID		= ?	\n");sm.addStringParameter(info.getSession("ID"));
				sqlsb.append("			,CHANGE_DATE		= ?	\n");sm.addStringParameter(SepoaDate.getShortDateString());
				sqlsb.append("			,CHANGE_TIME		= ?	\n");sm.addStringParameter(SepoaDate.getShortTimeString());
				sqlsb.append("		WHERE PR_NUMBER	= ?			\n");sm.addStringParameter(PR_NO);
				sqlsb.append("		  AND PR_SEQ	= ?			\n");sm.addStringParameter(PR_SEQ);
				sm.doInsert(sqlsb.toString());
			}
		}*/
		
		Commit();
		
	} catch (Exception e) {
		setStatus(0);
		setFlag(false);
		setMessage(e.getMessage());
		Logger.err.println(info.getSession("ID"), this, e.getMessage());
	}
	
	return getSepoaOut();
	
	}
	
	public SepoaOut setChangeInsert(
			String subject, 			
			String seller_code, 		String seller_name,
			String sign_person_id, 		String sign_person_name, 	String cont_from,				String cont_to, 			String cont_date,
			String cont_add_date, 		String cont_type, 			String ele_cont_flag, 			String assure_flag, 		
			String cont_process_flag, 	String cont_amt, 			String cont_assure_percent, 	String cont_assure_amt, 	String fault_ins_percent,
			String fault_ins_amt, 		String fault_ins_term, 			String bd_no, 				String bd_count,
			String amt_gubun, 			String text_number, 		String delay_charge, 			String remark,
			String cont_no,				String[][] bean_args,       String ctrl_demand_dept,        String cont_gl_seq,
			String rfq_type,            String cont_type1_text,     String cont_type2_text,
			String delv_place, 			String item_type, 			String before_item_type, 
			String rd_date, 			String cont_total_gubun, 	String cont_price,
			String before_cont_from,	String before_cont_to,		String before_cont_amt, 	String ttl_item_qty,
			String sg_type1,			String sg_type2,			String sg_type3,			String before_rd_date,
			String exec_no,             String add_tax_flag) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		Logger.sys.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		Logger.sys.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		Logger.sys.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		Logger.sys.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("	INSERT INTO SCPGL (				            \n");
			sqlsb.append("					   CONT_NO					\n");
			sqlsb.append("      			  ,CONT_GL_SEQ              \n");
			sqlsb.append("					  ,SUBJECT             		\n");
			//sqlsb.append("					  ,CONT_GUBUN      			\n");
			sqlsb.append("					  ,SELLER_CODE      		\n");
			sqlsb.append("					  ,SIGN_PERSON_ID           \n");
			sqlsb.append("					  ,SIGN_PERSON_NAME         \n");
			sqlsb.append("					  ,CONT_FROM           		\n");
			sqlsb.append("					  ,CONT_TO           		\n");
			sqlsb.append("					  ,CONT_DATE            	\n");
			sqlsb.append("					  ,CONT_ADD_DATE       		\n");
			sqlsb.append("					  ,CONT_TYPE         		\n");
			sqlsb.append("					  ,ELE_CONT_FLAG    		\n");
			sqlsb.append("					  ,ASSURE_FLAG       		\n");
			sqlsb.append("					  ,CONT_PROCESS_FLAG       	\n");
			sqlsb.append("					  ,CONT_AMT      			\n");
			sqlsb.append("					  ,CONT_ASSURE_PERCENT		\n");
			sqlsb.append("					  ,CONT_ASSURE_AMT			\n");
			sqlsb.append("					  ,FAULT_INS_PERCENT		\n");
			sqlsb.append("					  ,FAULT_INS_AMT			\n");
			sqlsb.append("					  ,FAULT_INS_TERM         	\n");
			sqlsb.append("					  ,BD_NO         			\n");
			sqlsb.append("					  ,BD_COUNT         		\n");
			sqlsb.append("					  ,AMT_GUBUN         		\n");
			sqlsb.append("					  ,TEXT_NUMBER         		\n");
			sqlsb.append("					  ,DELAY_CHARGE         	\n");
			sqlsb.append("					  ,REMARK         			\n");
			sqlsb.append("					  ,CTRL_DEMAND_DEPT         \n");
			sqlsb.append("					  ,CT_FLAG             		\n");
			sqlsb.append("					  ,CTRL_CODE           		\n");
			sqlsb.append("					  ,COMPANY_CODE				\n");
			sqlsb.append("					  ,RFQ_TYPE					\n");
			sqlsb.append("					  ,ADD_USER_ID				\n");
			sqlsb.append("					  ,ADD_DATE            		\n");
			sqlsb.append("					  ,ADD_TIME            		\n");
			sqlsb.append("					  ,CHANGE_USER_ID      		\n");
			sqlsb.append("					  ,CHANGE_DATE         		\n");
			sqlsb.append("					  ,CHANGE_TIME         		\n");
			sqlsb.append("					  ,DEL_FLAG            		\n");
			sqlsb.append("					  ,CONT_TYPE1_TEXT          \n");
			sqlsb.append("					  ,CONT_TYPE2_TEXT          \n");
			sqlsb.append("					  ,DELV_PLACE          		\n");
			sqlsb.append("					  ,ITEM_TYPE          		\n");
			sqlsb.append("					  ,RD_DATE          		\n");
			sqlsb.append("					  ,CONT_PRICE          		\n");
			sqlsb.append("					  ,CONT_TOTAL_GUBUN         \n");
			sqlsb.append("					  ,BEFORE_CONT_FROM         \n");
			sqlsb.append("					  ,BEFORE_CONT_TO          	\n");
			sqlsb.append("					  ,BEFORE_CONT_AMT          \n");
			sqlsb.append("					  ,BEFORE_ITEM_TYPE         \n"); 
			sqlsb.append("					  ,TTL_ITEM_QTY		        \n"); 
			sqlsb.append("					  ,SG_LEV1		        \n"); 
			sqlsb.append("					  ,SG_LEV2		        \n"); 
			sqlsb.append("					  ,SG_LEV3		        \n"); 
			sqlsb.append("					  ,EXEC_NO		        \n"); 
			sqlsb.append("					  ,BEFORE_RD_DATE          		\n");
			sqlsb.append("		              ,ADD_TAX_FLAG			        \n");
			sqlsb.append("	                 ) VALUES (                 \n");
			sqlsb.append("				 	  ?                  		\n");sm.addStringParameter(cont_no);
			sqlsb.append("				 	 ,?                  		\n");sm.addStringParameter(cont_gl_seq);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(subject);
			//sqlsb.append("					 ,?                   		\n");sm.addStringParameter(cont_gubun);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(seller_code);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(sign_person_id);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(sign_person_name);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(cont_from);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(cont_to);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(cont_date);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(cont_add_date);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(cont_type);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(ele_cont_flag);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(assure_flag);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(cont_process_flag);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(cont_amt);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(cont_assure_percent);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(cont_assure_amt);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(fault_ins_percent);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(fault_ins_amt);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(fault_ins_term);
			sqlsb.append("					 ,?                  		\n");sm.addStringParameter(bd_no);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(bd_count);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(amt_gubun);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(text_number);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(delay_charge);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(remark);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(ctrl_demand_dept);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter("CT");
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(info.getSession("CTRL_CODE"));
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(info.getSession("COMPANY_CODE"));
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(rfq_type);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(info.getSession("ID"));
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(SepoaDate.getShortDateString());
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(SepoaDate.getShortTimeString());
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(info.getSession("ID"));
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(SepoaDate.getShortDateString());
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(SepoaDate.getShortTimeString());
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter("N");
			sqlsb.append("					 ,?        					\n");sm.addStringParameter(cont_type1_text);
			sqlsb.append("	                 ,?                        	\n");sm.addStringParameter(cont_type2_text);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(delv_place);
			sqlsb.append("					 ,?                   		\n");sm.addStringParameter(item_type);
			sqlsb.append("					 ,?   						\n");sm.addStringParameter(rd_date);
			sqlsb.append("					 ,?  						\n");sm.addStringParameter(cont_price);
			sqlsb.append("					 ,?							\n");sm.addStringParameter(cont_total_gubun);
			sqlsb.append("					 ,?   						\n");sm.addStringParameter(before_cont_from);
			sqlsb.append("					 ,?        					\n");sm.addStringParameter(before_cont_to);
			sqlsb.append("					 ,?        					\n");sm.addStringParameter(before_cont_amt);
			sqlsb.append("					 ,?        					\n");sm.addStringParameter(before_item_type);
			sqlsb.append("					 ,?        					\n");sm.addStringParameter(ttl_item_qty);
			sqlsb.append("					 ,?        					\n");sm.addStringParameter(sg_type1);
			sqlsb.append("					 ,?        					\n");sm.addStringParameter(sg_type2);
			sqlsb.append("					 ,?        					\n");sm.addStringParameter(sg_type3);
			sqlsb.append("					 ,?   						\n");sm.addStringParameter(exec_no);
			sqlsb.append("					 ,?   						\n");sm.addStringParameter(before_rd_date);
			sqlsb.append("					 ,?   						\n");sm.addStringParameter(add_tax_flag);
			sqlsb.append("					          					)\n"); 
 
			sm.doInsert(sqlsb.toString());

			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());

			
			/*kave
			if(bean_args.length > 0) {
				int cnt = 0;
				for (int i = 0; i < bean_args.length; i++)
				{
					String ANN_ITEM                 = bean_args[i][0];   // 입찰건명
					String DELV_PLACE               = bean_args[i][1];   // 납품장소
					String BID_VENDOR_CNT           = bean_args[i][2];  
					String EE_VENDOR_CNT            = bean_args[i][3]; 
					String JOIN_VENDOR_CNT          = bean_args[i][4]; 
					String VENDOR_NAME              = bean_args[i][5];   // 낙찰업체명
					String ASUMTNAMT                = bean_args[i][6];   // 예정가격
					String ESTM_PRICE               = bean_args[i][7]; 
					String FINAL_ESTM_PRICE_ENC     = bean_args[i][8]; 
					String SUM_AMT                  = bean_args[i][9];   // 낙찰금액
					String CUR                      = bean_args[i][10];  // 금액화폐단위
					String VENDOR_CODE              = bean_args[i][11];  // 납품 업체 코드
					String DLVRYDSREDATE            = bean_args[i][12];  // 납품 요청일
					String CONT_NO                  = bean_args[i][13];  
					String CONT_SEQ                 = bean_args[i][14];  
					String PR_NO                    = bean_args[i][15];  // PR_NO
					
					cnt++;
					
					sm.removeAllValue();
					sqlsb.delete(0, sqlsb.length());
					sqlsb.append("     INSERT INTO SCPLN (                    \n");
					sqlsb.append("                        CONT_NO             \n");
					sqlsb.append("                       ,CONT_GL_SEQ         \n");
					sqlsb.append("                       ,CONT_SEQ            \n");
					sqlsb.append("                       ,SELLER_CODE         \n");
					sqlsb.append("                       ,DESCRIPTION_LOC     \n"); 
					sqlsb.append("                       ,ITEM_AMT            \n");
					sqlsb.append("                       ,DELV_PLACE          \n");
					sqlsb.append("                       ,ADD_USER_ID         \n");
					sqlsb.append("                       ,ADD_DATE            \n");
					sqlsb.append("                       ,ADD_TIME            \n");
					sqlsb.append("                       ,CHANGE_USER_ID      \n");
					sqlsb.append("                       ,CHANGE_DATE         \n");
					sqlsb.append("                       ,CHANGE_TIME         \n");
					sqlsb.append("                       ,DEL_FLAG            \n");
					sqlsb.append("                       ,PR_NO               \n");
					sqlsb.append("                       ,RD_DATE     		  \n");
					sqlsb.append("                       ,COMPANY_CODE   	  \n");
					sqlsb.append("                       ,CUR   		      \n");
					sqlsb.append("                       ,ESTIMATE_PRICE   	  \n");
					sqlsb.append("                       ,MAKER   		      \n");
					sqlsb.append("             ) VALUES (                     \n");
					sqlsb.append("                       ?                    \n"); sm.addStringParameter(cont_no);
					sqlsb.append("		                ,TO_CHAR(?, 'FM000')  \n"); sm.addStringParameter(cont_gl_seq);
					sqlsb.append("                      ,Lpad(?,3,'0')        \n"); sm.addStringParameter(String.valueOf(cnt));
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(seller_code);
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(ANN_ITEM);  // 입찰건명
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(SUM_AMT);
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(DELV_PLACE);
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(info.getSession("ID"));
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(SepoaDate.getShortDateString());
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(SepoaDate.getShortTimeString());
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(info.getSession("ID"));
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(SepoaDate.getShortDateString());
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(SepoaDate.getShortTimeString());
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter("N");
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(PR_NO);
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(DLVRYDSREDATE);
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(VENDOR_CODE);
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(CUR);
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(ASUMTNAMT);   //예정가격
					sqlsb.append("                      ,?                    \n"); sm.addStringParameter(VENDOR_NAME); //낙찰업체
					sqlsb.append("                     )                      \n");
					sm.doInsert(sqlsb.toString());
				}
			}
			*/
			Commit();
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();
	}
	
	
public SepoaOut getCleanContractCheckSelect( String cont_no, String cont_gl_seq ) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		String language = info.getSession("LANGUAGE");

		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("    SELECT                                     \n");
			sqlsb.append("    	 A.COMPANY_CODE                          \n");
			sqlsb.append("    	,A.CONT_NO                               \n");
			sqlsb.append("    	,A.CONT_GL_SEQ                           \n");
			sqlsb.append("    	,A.CHK_SEQ                               \n");
			sqlsb.append("    	,A.CHK_COMMENT                           \n");
			sqlsb.append("    	,A.CHK_FLAG                              \n");
			sqlsb.append("    FROM SCCHK      A                          \n");
			sqlsb.append("    WHERE 1 = 1                                \n");
			sqlsb.append(sm.addSelectString("     AND A.COMPANY_CODE = ? \n"));sm.addStringParameter(info.getSession("COMPANY_CODE"));
			sqlsb.append(sm.addSelectString("     AND A.CONT_NO = ?      \n"));sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString("     AND A.CONT_GL_SEQ = ?  \n"));sm.addStringParameter(cont_gl_seq);			
			sqlsb.append("    ORDER BY A.CHK_SEQ                         \n");
			setValue(sm.doSelect(sqlsb.toString()));
					
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
		
	}
}