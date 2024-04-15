package sepoa.svc.contract;

import java.util.Vector;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.CommonUtil; 


public class CT_021 extends SepoaService
{
	private String ID = info.getSession("ID");

	public CT_021(String opt, SepoaInfo info) throws SepoaServiceException
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
	
    private String getSubString(String str, int start, int end)
    {
        int rSize = 0;
        int len = 0;

        int ll = 0;
        StringBuffer ss = new StringBuffer();

        for (; rSize < str.length(); rSize++)
        {
            if (str.charAt(rSize) > 0x007F)
            {
                len += 2;
            }
            else
            {
                len++;
            }

            if ((len > start) && (len <= end))
            {
                ss.append(str.charAt(rSize));
            }
        }

        return ss.toString();
    }

    public int getLengthb(String str)
    {
        int rSize = 0;
        int len = 0;
        int ll = 0;

        for (; rSize < str.length(); rSize++)
        {
            if (str.charAt(rSize) > 0x007F)
            {
                len += 2;
            }
            else
            {
                len++;
            }
        }

        return len;
    }

    private Vector getSplitString(String t1, int length)
    {
        Vector rt = new Vector();
        String ui = t1;

        int le = getLengthb(ui); //ui�� ��byte���� �˾Ƴ�

        while (le > 0) //0byte���� ũ�ٸ�
        {
            rt.addElement(getSubString(ui, 0, length)); //
            ui = getSubString(ui, length, le);
            le = getLengthb(ui);
        }

        return rt;
    } 

    public SepoaOut getContractList(SepoaInfo info, String cont) {

		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			
			sqlsb.append("		SELECT                    \n");
			sqlsb.append("			 CONT_FORM_NO         \n");
			sqlsb.append("			,CONT_FORM_NAME       \n");
			sqlsb.append("			,CONT_DESC            \n");
			sqlsb.append("			,GETCODETEXT2('M800', CONT_TYPE, '" + info.getSession("LANGUAGE") + "' ) AS CONT_TYPE            \n");
			sqlsb.append("			,OFFLINE_FLAG         \n");
			sqlsb.append("			,getUserName('"+info.getSession("HOUSE_CODE")+"', ADD_USER_ID,'KO')  AS ADD_USER_NAME          \n");
			sqlsb.append("			,ADD_DATE             \n");
			sqlsb.append("			,ADD_TIME             \n");
			sqlsb.append("			,CHANGE_USER_ID       \n");
			sqlsb.append("			,CHANGE_DATE          \n");
			sqlsb.append("			,CHANGE_TIME          \n");
			sqlsb.append("			,GETCODETEXT2('M799', USE_FLAG, 'KO' ) AS USE_FLAG             \n");
			sqlsb.append("			,DECODE(CONT_PRIVATE_FLAG,'PV','임의서식',DECODE(CONT_PRIVATE_FLAG,'PU','표준서식','')) AS CONT_PRIVATE_FLAG             \n");
			sqlsb.append("		FROM SCTMT                \n");
			sqlsb.append("		WHERE 1 = 1               \n");
			sqlsb.append("		AND   NVL(DEL_FLAG,'N') = 'N'      \n");
			sqlsb.append("		AND   NVL(USE_FLAG,'Y') = 'Y'      \n");
			sqlsb.append(sm.addSelectString(" AND CONT_TYPE         = ?      \n"));	sm.addStringParameter(cont);
//			sqlsb.append(sm.addSelectString(" AND CONT_USER_ID      = ?      \n"));	sm.addStringParameter(info.getSession("ID"));
//			sqlsb.append(sm.addSelectString(" AND USE_FLAG          = ?      \n"));	sm.addStringParameter("N");
			//sqlsb.append(sm.addSelectString(" AND CONT_PRIVATE_FLAG = ?      \n"));	sm.addStringParameter("PV");
			sqlsb.append(sm.addSelectString(" AND CONT_STATUS       = ?      \n"));	sm.addStringParameter("C");
			sqlsb.append("		ORDER BY CONT_FORM_NO DESC	\n");
			
			setValue(sm.doSelect(sqlsb.toString()));
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
	
	public SepoaOut getContractFormSelect( String cont_no, String cont_gl_seq ) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			Logger.sys.println("cont_no: " + cont_no);
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			SepoaFormater sf = null;
			String content ="";
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			
			sqlsb.append("		              SELECT CONTENT					 \n");
			sqlsb.append("		              FROM SCPMT						 \n");
			sqlsb.append("		              WHERE 1 = 1						 \n");
			sqlsb.append(sm.addSelectString(" AND   CONT_NO     = ?			     \n"));	sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString(" AND   CONT_GL_SEQ = ?			     \n"));	sm.addStringParameter(cont_gl_seq);
			sqlsb.append("		  			  AND NVL(DEL_FLAG, 'N') = 'N'		 \n");
			sqlsb.append("					  ORDER BY SEQ_SEQ					 \n");
			
			sf = new SepoaFormater(sm.doSelect(sqlsb.toString()));
			for (int i = 0; i < sf.getRowCount(); i++)
			{
				content += sf.getValue("CONTENT", i);
			}
			setValue(content);
			

		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	public SepoaOut getContractContNoSelect(String cont_no, String cont_gl_seq) {

		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();

		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			
			sqlsb.append("    SELECT																																							\n");
			sqlsb.append("    	 A.CONT_NO																														AS IN_VAL_CONT_NO				\n");
			sqlsb.append("    	,SUBJECT																														AS IN_VAL_SUBJECT				\n");
			sqlsb.append("    	,GETCODETEXT2('M811', CONT_GUBUN, 'KO')																							AS IN_VAL_CONT_GUBUN			\n");
			sqlsb.append("    	,GETCODETEXT2('M806', PROPERTY_YN, 'KO')																						AS IN_VAL_PROPERTY_YN			\n");
			sqlsb.append("    	,SELLER_CODE																													AS SELLER_CODE					\n");
			sqlsb.append("    	,GETCOMPANYNAMELOC('"+info.getSession("HOUSE_CODE")+"', SELLER_CODE, 'S')																							AS IN_VAL_SELLER_NAME			\n");
			sqlsb.append("    	,SIGN_PERSON_NAME																												AS IN_VAL_SIGN_PERSON_NAME		\n");
			sqlsb.append("    	,CASE WHEN CONT_FROM IS NULL THEN ''																																\n");
			sqlsb.append("    	     ELSE SUBSTR(CONT_FROM, 0,4)     || '년' || SUBSTR(CONT_FROM, 5,2)     || '월' || SUBSTR(CONT_FROM, 7,2)     || '일' END	AS IN_VAL_CONT_FROM				\n");
			sqlsb.append("    	,CASE WHEN CONT_TO IS NULL THEN ''																																	\n");
			sqlsb.append("    		 ELSE SUBSTR(CONT_TO, 0,4)       || '년' || SUBSTR(CONT_TO, 5,2)       || '월' || SUBSTR(CONT_TO, 7,2)       || '일' END	AS IN_VAL_CONT_TO				\n");
			sqlsb.append("    	,CASE WHEN CONT_DATE IS NULL THEN ''																																\n");
			sqlsb.append("    		 ELSE SUBSTR(CONT_DATE, 0,4)     || '년' || SUBSTR(CONT_DATE, 5,2)     || '월' || SUBSTR(CONT_DATE, 7,2)     || '일' END	AS IN_VAL_CONT_DATE				\n");
			sqlsb.append("    	,CASE WHEN CONT_DATE IS NULL THEN ''																															\n");
			sqlsb.append("    		 ELSE SUBSTR(CONT_DATE, 0,4) || '년' || SUBSTR(CONT_DATE, 5,2) || '월' || SUBSTR(CONT_DATE, 7,2) || '일' END	AS IN_VAL_CONT_ADD_DATE			\n");
			sqlsb.append("    	,GETCODETEXT2('M899', CONT_TYPE, 'KO')																							AS IN_VAL_CONT_TYPE				\n");
			sqlsb.append("    	,GETCODETEXT2('M223', ELE_CONT_FLAG, 'KO')																						AS IN_VAL_ELE_CONT_FLAG			\n");
			sqlsb.append("    	,GETCODETEXT2('M807', ASSURE_FLAG, 'KO')																						AS IN_VAL_ASSURE_FLAG			\n");
			sqlsb.append("    	,GETCODETEXT2('M806', START_START_INS_FLAG, 'KO')																				AS IN_VAL_START_START_INS_FLAG	\n");
			sqlsb.append("    	,GETCODETEXT2('M809', CONT_PROCESS_FLAG, 'KO')																					AS IN_VAL_CONT_PROCESS_FLAG		\n");
			sqlsb.append("    	,CONT_AMT																														AS IN_VAL_CONT_AMT				\n");
			sqlsb.append("    	,CONT_ASSURE_PERCENT																											AS IN_VAL_CONT_ASSURE_PERCENT	\n");
			sqlsb.append("    	,CONT_ASSURE_AMT																												AS IN_VAL_CONT_ASSURE_AMT		\n");
			sqlsb.append("    	,FAULT_INS_PERCENT																												AS IN_VAL_FAULT_INS_PERCENT		\n");
			sqlsb.append("    	,FAULT_INS_AMT																													AS IN_VAL_FAULT_INS_AMT			\n");
			//sqlsb.append("    	,GETCODETEXT2('M808', PAY_DIV_FLAG, 'KO')																						AS IN_VAL_PAY_DIV_FLAG			\n");
			sqlsb.append("    	,A.PAY_DIV_FLAG																						AS IN_VAL_PAY_DIV_FLAG			\n");
			sqlsb.append("    	,FAULT_INS_TERM																													AS IN_VAL_FAULT_INS_TERM		\n");
			sqlsb.append("    	,BD_NO																															AS IN_VAL_BD_NO					\n");
			sqlsb.append("    	,GETCODETEXT2('M813', AMT_GUBUN, 'KO')																							AS IN_VAL_AMT_GUBUN				\n");
			sqlsb.append("    	,TEXT_NUMBER																													AS IN_VAL_TEXT_NUMBER			\n");
			sqlsb.append("    	,DELAY_CHARGE																													AS IN_VAL_DELAY_CHARGE			\n");
			sqlsb.append("    	,DELV_PLACE																														AS IN_VAL_DELV_PLACE			\n");
			sqlsb.append("    	,REMARK																															AS TEXT_REMARK					\n");
			sqlsb.append("    	,ATTACH_NO																														AS ATTACH_NO					\n");
			sqlsb.append("    	,SE_ATTACH_NO																													AS SE_ATTACH_NO					\n");
			sqlsb.append("    	,FAULT_INS_NO																													AS FAULT_INS_NO					\n");
			sqlsb.append("    	,TTL_ITEM_QTY																													AS IN_VAL_TTL_ITEM_QTY					\n");
			sqlsb.append("    	,CONT_INS_VN																													AS CONT_INS_VN					\n");
			sqlsb.append("    	,CONT_INS_NO																													AS CONT_INS_NO					\n");
			sqlsb.append("    	,FAULT_INS_NO																													AS FAULT_INS_NO					\n");
			sqlsb.append("    	,CONT_INS_FLAG																													AS CONT_INS_FLAG					\n");
			sqlsb.append("    	,FAULT_INS_FLAG																													AS FAULT_INS_FLAG					\n");
			sqlsb.append("    	,ADD_TAX_FLAG																													AS ADD_TAX_FLAG					\n");
			sqlsb.append("    	,RD_DATE	--납품기한																												AS ADD_TAX_FLAG					\n");
			sqlsb.append("    	,ITEM_TYPE	--물품종류																												AS ADD_TAX_FLAG					\n");
			sqlsb.append("    	,STAMP_TAX_NO																																		\n");
			sqlsb.append("    	,STAMP_TAX_AMT																													\n");
			
			sqlsb.append("    	,A.SG_LEV1		AS	SG_LEV1																										\n");
			sqlsb.append("    	,A.SG_LEV2		AS	SG_LEV2																										\n");
			sqlsb.append("    	,A.SG_LEV3		AS	SG_LEV3																										\n");
			
			sqlsb.append("    	,GETFILENAMES(A.ATTACH_NO)    AS RPT_GETFILENAMES1	                          \n "); 			
			sqlsb.append("    	,GETFILENAMES(A.SE_ATTACH_NO) AS RPT_GETFILENAMES2	                          \n "); 			
			
			
			
			sqlsb.append("    FROM SCPGL A, SCOTX B																																						\n"); 
			sqlsb.append("	WHERE NVL(DEL_FLAG, 'N') = 'N'																																		\n");
			sqlsb.append("	AND   A.CONT_NO = B.CONT_NO(+)																																		\n");
			sqlsb.append("	AND   A.CONT_GL_SEQ = B.CONT_COUNT(+)																																		\n");
			sqlsb.append(sm.addSelectString("	  AND A.CONT_NO = ?																																\n"));
			sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString("	  AND A.CONT_GL_SEQ = ?																																\n"));
			sm.addStringParameter(cont_gl_seq);
			setValue(sm.doSelect(sqlsb.toString()));
	
			SepoaFormater sf     = new SepoaFormater(sm.doSelect(sqlsb.toString()));
			
			String seller_code = sf.getValue("SELLER_CODE",0);
			
			
		/*	sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("	SELECT																\n");
			sqlsb.append("			 ADDR.ADDRESS_LOC     AS IN_VAL_BUYER_ADDRESS_LOC			\n");
			sqlsb.append("			,SUGL.SELLER_NAME_LOC AS IN_VAL_BUYER_SELLER_NAME_LOC		\n");
			sqlsb.append("			,ADDR.PHONE_NO1       AS IN_VAL_BUYER_PHONE_NO1				\n");
			sqlsb.append("			,(SELECT ADDR.CEO_NAME_LOC FROM SADDR ADDR WHERE SUGL.SELLER_CODE = ADDR.CODE_NO AND ADDR.CODE_TYPE = '2'  AND ROWNUM < 2)	AS IN_VAL_BUYER_SIGN_PERSON_NAME				\n");
			sqlsb.append("			,SUGL.IRS_NO          AS IN_VAL_BUYER_IRS_NO				\n");
			sqlsb.append("	FROM SADDR ADDR, SSUGL SUGL											\n");
			sqlsb.append("	WHERE SUGL.SELLER_CODE = ADDR.CODE_NO								\n");
			sqlsb.append("	  AND ADDR.CODE_TYPE = '2'											\n");
			sqlsb.append(sm.addSelectString("	  AND SUGL.SELLER_CODE = ?						\n"));
			sm.addStringParameter(cont_no);
			setValue(sm.doSelect(sqlsb.toString()));*/
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("	SELECT  LANGUAGE												\n");                   
			sqlsb.append("	, 		ADDRESS_LOC    		AS IN_VAL_BUYER_ADDRESS_LOC         \n");
			sqlsb.append("	, 		COMPANY_NAME_LOC  	AS IN_VAL_BUYER_NAME_LOC            \n");
			sqlsb.append("	, 		PHONE_NO  			AS IN_VAL_BUYER_PHONE_NO1			\n");
			sqlsb.append("	, 		CEO_NAME    		AS IN_VAL_BUYER_SIGN_PERSON_NAME    \n");
			sqlsb.append("	, 		IRS_NO   			AS IN_VAL_BUYER_IRS_NO              \n");
			sqlsb.append("	FROM COMPANY_GENERAL_VW                                         \n");
			sqlsb.append("	WHERE COMPANY_CODE = 'WOORI'    								\n");
			setValue(sm.doSelect(sqlsb.toString()));
			
			/*sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("		SELECT															\n");
			sqlsb.append("			 (SELECT ADDR.ADDRESS_LOC      FROM SADDR ADDR WHERE SUGL.SELLER_CODE = ADDR.CODE_NO AND ADDR.CODE_TYPE = '2' AND ROWNUM < 2)          AS IN_VAL_SELLER_ADDRESS_LOC		\n");
			sqlsb.append("			,SUGL.SELLER_NAME_LOC AS IN_VAL_SELLER_SELLER_NAME		\n");
			sqlsb.append("			,(SELECT ADDR.PHONE_NO1        FROM SADDR ADDR WHERE SUGL.SELLER_CODE = ADDR.CODE_NO AND ADDR.CODE_TYPE = '2' AND ROWNUM < 2)          AS IN_VAL_SELLER_PHONE_NO1			\n");
			sqlsb.append("			,(SELECT ADDR.CEO_NAME_LOC     FROM SADDR ADDR WHERE SUGL.SELLER_CODE = ADDR.CODE_NO AND ADDR.CODE_TYPE = '2' AND ROWNUM < 2)          AS IN_VAL_SELLER_SIGN_PERSON_NAME		\n");
			sqlsb.append("			,SUGL.IRS_NO          AS IN_VAL_SELLER_IRS_NO				\n");
			sqlsb.append("			,(SELECT SUBK.BANK_NAME_LOC    FROM SSUBK SUBK WHERE SUGL.SELLER_CODE = SUBK.SELLER_CODE AND SUBK.USE_YN = 'Y' AND ROWNUM < 2)         AS IN_VAL_SELLER_BANK_NAME_LOC		\n");
			sqlsb.append("			,(SELECT SUBK.BANK_ACCT        FROM SSUBK SUBK WHERE SUGL.SELLER_CODE = SUBK.SELLER_CODE AND SUBK.USE_YN = 'Y' AND ROWNUM < 2)         AS IN_VAL_SELLER_BANK_ACCT			\n");
			sqlsb.append("			,(SELECT SUBK.DEPOSITOR_NAME   FROM SSUBK SUBK WHERE SUGL.SELLER_CODE = SUBK.SELLER_CODE AND SUBK.USE_YN = 'Y' AND ROWNUM < 2)         AS IN_VAL_SELLER_DEPOSITOR_NAME		\n");
			sqlsb.append("		FROM  SSUGL SUGL												\n");
			sqlsb.append(sm.addSelectString("	  where SUGL.SELLER_CODE = ?						\n"));
			sm.addStringParameter(cont_no);*/
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("		SELECT 	B.ADDRESS_LOC			IN_VAL_SELLER_ADDRESS_LOC           \n");
			sqlsb.append("		,		A.VENDOR_NAME_LOC 		IN_VAL_SELLER_NAME                  \n");
			sqlsb.append("		,		B.PHONE_NO1				IN_VAL_SELLER_PHONE_NO1             \n");
			sqlsb.append("		,		B.CEO_NAME_LOC			IN_VAL_SELLER_SIGN_PERSON_NAME      \n");
			sqlsb.append("		,		A.IRS_NO				IN_VAL_SELLER_IRS_NO                \n");
			sqlsb.append("		,		''						IN_VAL_SELLER_BANK_NAME_LOC         \n");
			sqlsb.append("		,		''						IN_VAL_SELLER_BANK_ACCT             \n");
			sqlsb.append("		,		''						IN_VAL_SELLER_DEPOSITOR_NAME        \n");
						
			sqlsb.append("    	,       (SELECT TEXT1 FROM SCODE WHERE TYPE = 'M349' AND CODE = A.BANK_CODE) 	   AS  IN_VAL_BANK_CODE			\n");									
			sqlsb.append("    	,       A.BANK_ACCT                                                                                                          AS  IN_VAL_BANK_ACCT			\n");
			sqlsb.append("    	,       A.DEPOSITOR_NAME																								   AS  IN_VAL_DEPOSITOR_NAME			\n");
						
			sqlsb.append("		FROM 	ICOMVNGL A                                                  \n");
			sqlsb.append("		,		ICOMADDR B                                                  \n");
			sqlsb.append("		WHERE 	A.VENDOR_CODE = B.CODE_NO                                   \n");
			sqlsb.append("		AND 	B.CODE_TYPE = '2'                                           \n");
			sqlsb.append(sm.addSelectString("	  AND 	A.VENDOR_CODE = ?							\n"));
			sm.addStringParameter(seller_code);
			
			setValue(sm.doSelect(sqlsb.toString()));
			
			if(!cont_gl_seq.equals("001")){
				
				
				String bfchg_cont_gl_seq = CommonUtil.lpad(""+(Integer.parseInt(cont_gl_seq)-1), 3, "0");
				
	
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				
				sqlsb.append("    SELECT																																							\n");
				sqlsb.append("    	 A.CONT_NO																														AS IN_VAL_CONT_NO				\n");
				sqlsb.append("    	,SUBJECT																														AS IN_VAL_SUBJECT				\n");
				sqlsb.append("    	,GETCODETEXT2('M811', CONT_GUBUN, 'KO')																							AS IN_VAL_CONT_GUBUN			\n");
				sqlsb.append("    	,GETCODETEXT2('M806', PROPERTY_YN, 'KO')																						AS IN_VAL_PROPERTY_YN			\n");
				sqlsb.append("    	,SELLER_CODE																													AS SELLER_CODE					\n");
				sqlsb.append("    	,GETCOMPANYNAMELOC('"+info.getSession("HOUSE_CODE")+"', SELLER_CODE, 'S')																							AS IN_VAL_SELLER_NAME			\n");
				sqlsb.append("    	,SIGN_PERSON_NAME																												AS IN_VAL_SIGN_PERSON_NAME		\n");
				sqlsb.append("    	,CASE WHEN CONT_FROM IS NULL THEN ''																																\n");
				sqlsb.append("    	     ELSE SUBSTR(CONT_FROM, 0,4)     || '년' || SUBSTR(CONT_FROM, 5,2)     || '월' || SUBSTR(CONT_FROM, 7,2)     || '일' END	AS IN_VAL_CONT_FROM				\n");
				sqlsb.append("    	,CASE WHEN CONT_TO IS NULL THEN ''																																	\n");
				sqlsb.append("    		 ELSE SUBSTR(CONT_TO, 0,4)       || '년' || SUBSTR(CONT_TO, 5,2)       || '월' || SUBSTR(CONT_TO, 7,2)       || '일' END	AS IN_VAL_CONT_TO				\n");
				sqlsb.append("    	,CASE WHEN CONT_DATE IS NULL THEN ''																																\n");
				sqlsb.append("    		 ELSE SUBSTR(CONT_DATE, 0,4)     || '년' || SUBSTR(CONT_DATE, 5,2)     || '월' || SUBSTR(CONT_DATE, 7,2)     || '일' END	AS IN_VAL_CONT_DATE				\n");
				sqlsb.append("    	,CASE WHEN CONT_ADD_DATE IS NULL THEN ''																															\n");
				sqlsb.append("    		 ELSE SUBSTR(CONT_ADD_DATE, 0,4) || '년' || SUBSTR(CONT_ADD_DATE, 5,2) || '월' || SUBSTR(CONT_ADD_DATE, 7,2) || '일' END	AS IN_VAL_CONT_ADD_DATE			\n");
				sqlsb.append("    	,GETCODETEXT2('M899', CONT_TYPE, 'KO')																							AS IN_VAL_CONT_TYPE				\n");
				sqlsb.append("    	,GETCODETEXT2('M223', ELE_CONT_FLAG, 'KO')																						AS IN_VAL_ELE_CONT_FLAG			\n");
				sqlsb.append("    	,GETCODETEXT2('M807', ASSURE_FLAG, 'KO')																						AS IN_VAL_ASSURE_FLAG			\n");
				sqlsb.append("    	,GETCODETEXT2('M806', START_START_INS_FLAG, 'KO')																				AS IN_VAL_START_START_INS_FLAG	\n");
				sqlsb.append("    	,GETCODETEXT2('M809', CONT_PROCESS_FLAG, 'KO')																					AS IN_VAL_CONT_PROCESS_FLAG		\n");
				sqlsb.append("    	,CONT_AMT																														AS IN_VAL_CONT_AMT				\n");
				sqlsb.append("    	,CONT_ASSURE_PERCENT																											AS IN_VAL_CONT_ASSURE_PERCENT	\n");
				sqlsb.append("    	,CONT_ASSURE_AMT																												AS IN_VAL_CONT_ASSURE_AMT		\n");
				sqlsb.append("    	,FAULT_INS_PERCENT																												AS IN_VAL_FAULT_INS_PERCENT		\n");
				sqlsb.append("    	,FAULT_INS_AMT																													AS IN_VAL_FAULT_INS_AMT			\n");
				//sqlsb.append("    	,GETCODETEXT2('M808', PAY_DIV_FLAG, 'KO')																						AS IN_VAL_PAY_DIV_FLAG			\n");
				sqlsb.append("    	,A.PAY_DIV_FLAG																						AS IN_VAL_PAY_DIV_FLAG			\n");
				sqlsb.append("    	,FAULT_INS_TERM																													AS IN_VAL_FAULT_INS_TERM		\n");
				sqlsb.append("    	,BD_NO																															AS IN_VAL_BD_NO					\n");
				sqlsb.append("    	,GETCODETEXT2('M813', AMT_GUBUN, 'KO')																							AS IN_VAL_AMT_GUBUN				\n");
				sqlsb.append("    	,TEXT_NUMBER																													AS IN_VAL_TEXT_NUMBER			\n");
				sqlsb.append("    	,DELAY_CHARGE																													AS IN_VAL_DELAY_CHARGE			\n");
				sqlsb.append("    	,DELV_PLACE																														AS IN_VAL_DELV_PLACE			\n");
				sqlsb.append("    	,REMARK																															AS TEXT_REMARK					\n");
				sqlsb.append("    	,ATTACH_NO																														AS ATTACH_NO					\n");
				sqlsb.append("    	,SE_ATTACH_NO																													AS SE_ATTACH_NO					\n");
				sqlsb.append("    	,FAULT_INS_NO																													AS FAULT_INS_NO					\n");
				sqlsb.append("    	,TTL_ITEM_QTY																													AS IN_VAL_TTL_ITEM_QTY					\n");
				sqlsb.append("    	,CONT_INS_VN																													AS CONT_INS_VN					\n");
				sqlsb.append("    	,CONT_INS_NO																													AS CONT_INS_NO					\n");
				sqlsb.append("    	,FAULT_INS_NO																													AS FAULT_INS_NO					\n");
				sqlsb.append("    	,CONT_INS_FLAG																													AS CONT_INS_FLAG					\n");
				sqlsb.append("    	,FAULT_INS_FLAG																													AS FAULT_INS_FLAG					\n");
				sqlsb.append("    	,ADD_TAX_FLAG																													AS ADD_TAX_FLAG					\n");
				sqlsb.append("    	,RD_DATE	--납품기한																												AS ADD_TAX_FLAG					\n");
				sqlsb.append("    	,ITEM_TYPE	--물품종류																												AS ADD_TAX_FLAG					\n");
				sqlsb.append("    	,STAMP_TAX_NO																																		\n");
				sqlsb.append("    	,STAMP_TAX_AMT																													\n");								
				sqlsb.append("    FROM SCPGL A, SCOTX B																																						\n"); 
				sqlsb.append("	WHERE NVL(DEL_FLAG, 'N') = 'N'																																		\n");
				sqlsb.append("	AND   A.CONT_NO = B.CONT_NO(+)																																		\n");
				sqlsb.append(sm.addSelectString("	  AND A.CONT_NO = ?																																\n"));
				sm.addStringParameter(cont_no);
				//sqlsb.append("	  AND A.CONT_GL_SEQ = TO_CHAR(TO_NUMBER('"+cont_gl_seq+"')-1,'000')																																\n");				
				sqlsb.append(sm.addSelectString("	  AND A.CONT_GL_SEQ = ?																															\n"));
				sqlsb.append("	AND   A.CONT_GL_SEQ = B.CONT_COUNT(+)																																		\n");
				sm.addStringParameter(bfchg_cont_gl_seq);
				setValue(sm.doSelect(sqlsb.toString()));
				
				
			}
			
			
			
			
			
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	public SepoaOut getContractContNoLnSelect(String cont_no) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			
			sqlsb.append("  SELECT DISTINCT                                              \n");
			sqlsb.append("  	 DESCRIPTION_LOC                                         \n");
			sqlsb.append("  	,SPECIFICATION                                           \n");
			sqlsb.append("  	,UNIT_MEASURE                                            \n");
			sqlsb.append("  	,SETTLE_QTY                                              \n");
			sqlsb.append("  	,UNIT_PRICE                                              \n");
			sqlsb.append("  	,ITEM_AMT                                                \n");
			sqlsb.append("  	,SUPPLY_AMT                                              \n");
			sqlsb.append("  	,SUPERTAX_AMT                                            \n");
			sqlsb.append("  	,DELV_PLACE                                              \n");
			sqlsb.append("  	,PR_NO                                                   \n");
			sqlsb.append("  	,PR_SEQ                                                  \n");
			sqlsb.append("  	,GETUSERNAME (CHANGE_USER_ID, 'LOC') AS ADD_USER_ID      \n");
			sqlsb.append("  FROM SCPLN                                                   \n");
			sqlsb.append("  WHERE NVL(DEL_FLAG, 'N') = 'N'                               \n");
			sqlsb.append(sm.addSelectString("	  AND CONT_NO = ?                        \n"));
			sqlsb.append("  ORDER BY DESCRIPTION_LOC, PR_NO, PR_SEQ                      \n");
			sm.addStringParameter(cont_no);
			setValue(sm.doSelect(sqlsb.toString()));
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}

	public SepoaOut setContractMakeSave( String cont_no, String in_attach_no, String ele_cont_flag, String cont_gl_seq, String content ,String cont_form_no ) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
		SepoaFormater sf = null;
		int rtn = 0;
		
		String CT_FLAG = "";
		
		if( "N".equals(ele_cont_flag) ) CT_FLAG = "OF"; // 오프라인계약서
		else							CT_FLAG = "CA"; // 전자계약서작성중
		
        try {
        	
        	if( "".equals( content ) ){
	        	ps.removeAllValue();
	        	sqlsb.delete(0, sqlsb.length());
	        	sqlsb.append("		UPDATE SCPGL SET             \n");
	        	sqlsb.append("			 CT_FLAG        = ?      \n");ps.addStringParameter(CT_FLAG);
	        	sqlsb.append("			,ATTACH_NO      = ?      \n");ps.addStringParameter(in_attach_no);
	        	sqlsb.append("			,CHANGE_USER_ID = ?      \n");ps.addStringParameter(info.getSession("ID"));
	        	sqlsb.append("			,CHANGE_DATE    = ?      \n");ps.addStringParameter(SepoaDate.getShortDateString());
	        	sqlsb.append("			,CHANGE_TIME    = ?      \n");ps.addStringParameter(SepoaDate.getShortTimeString());
	        	sqlsb.append("			,CONT_FORM_NO   = ?      \n");ps.addStringParameter(cont_no);
	        	sqlsb.append("		WHERE CONT_NO       = ?      \n");ps.addStringParameter(cont_no);
	        	sqlsb.append("		AND   CONT_GL_SEQ   = ?      \n");ps.addStringParameter(cont_gl_seq);
	        	rtn = ps.doUpdate(sqlsb.toString());
        	}else{
	        	ps.removeAllValue();
		        sqlsb.delete(0,sqlsb.length());
				sqlsb.append("		DELETE FROM SCPMT		            \n");
				sqlsb.append("		WHERE CONT_NO      = ?				\n");ps.addStringParameter(cont_no);
				sqlsb.append("		AND   CONT_GL_SEQ  = ?				\n");ps.addStringParameter(cont_gl_seq);
				ps.doDelete(sqlsb.toString());
	
	        	ps.removeAllValue();
		        sqlsb.delete(0,sqlsb.length());
		        sqlsb.append("	INSERT INTO SCPMT (			\n");
		        sqlsb.append("		 CONT_NO				\n");
		        sqlsb.append("		,CONT_GL_SEQ			\n");
		        sqlsb.append("		,SEQ					\n");
		        sqlsb.append("		,SEQ_SEQ				\n");
		        sqlsb.append("		,CONTENT				\n");
		        sqlsb.append("		,ADD_USER_ID			\n");
		        sqlsb.append("		,ADD_DATE				\n");
		        sqlsb.append("		,ADD_TIME				\n");
		        sqlsb.append("		,CHANGE_USER_ID			\n");
		        sqlsb.append("		,CHANGE_DATE			\n");
		        sqlsb.append("		,CHANGE_TIME			\n");
		        sqlsb.append("		,DEL_FLAG				\n");
		        sqlsb.append("	) VALUES (					\n");
		        sqlsb.append("		 ?						\n");ps.addStringParameter(cont_no);
		        sqlsb.append("		,?						\n");ps.addStringParameter(cont_gl_seq);
		        sqlsb.append("		,?						\n");ps.addStringParameter(cont_form_no);
		        sqlsb.append("		,TO_CHAR(?, '000000')	\n");ps.addStringParameter("1");
		        sqlsb.append("		,?						\n");ps.addStringParameter(content);
		        sqlsb.append("		,?						\n");ps.addStringParameter(info.getSession("ID"));
		        sqlsb.append("		,?						\n");ps.addStringParameter(SepoaDate.getShortDateString());
		        sqlsb.append("		,?						\n");ps.addStringParameter(SepoaDate.getShortTimeString());
		        sqlsb.append("		,?						\n");ps.addStringParameter(info.getSession("ID"));
		        sqlsb.append("		,?						\n");ps.addStringParameter(SepoaDate.getShortDateString());
		        sqlsb.append("		,?						\n");ps.addStringParameter(SepoaDate.getShortTimeString());
		        sqlsb.append("		,?						\n");ps.addStringParameter("N");
		        sqlsb.append("	)							\n");
		        rtn = ps.doInsert(sqlsb.toString());
        	}
//        	ps.removeAllValue();
//        	sqlsb.delete(0, sqlsb.length());
//        	sqlsb.append("		DELETE FROM SCPMT            \n");
//        	sqlsb.append("		WHERE CONT_NO       = ?      \n");ps.addStringParameter(cont_no);
//        	rtn = ps.doUpdate(sqlsb.toString());
//        	
//        	ps.removeAllValue();
//			sqlsb.delete(0, sqlsb.length());
//			sqlsb.append("		INSERT INTO SCPMT            \n");
//			sqlsb.append("			(CONT_NO                 \n");
//			sqlsb.append("			,SEQ                     \n");
//			sqlsb.append("			,SEQ_SEQ                 \n");
//			sqlsb.append("			,CONTENT                 \n");
//			sqlsb.append("			,DEL_FLAG                \n");
//			sqlsb.append("			,ADD_USER_ID             \n");
//			sqlsb.append("			,ADD_DATE                \n");
//			sqlsb.append("			,ADD_TIME                \n");
//			sqlsb.append("			,CHANGE_USER_ID          \n");
//			sqlsb.append("			,CHANGE_DATE             \n");
//			sqlsb.append("			,CHANGE_TIME)            \n");
//			sqlsb.append("		SELECT                       \n");
//			sqlsb.append("		     ?                       \n");ps.addStringParameter(cont_no);
//			sqlsb.append("		    ,SEQ                     \n");
//			sqlsb.append("		    ,SEQ_SEQ                 \n");
//			sqlsb.append("		    ,CONTENT                 \n");
//			sqlsb.append("		    ,DEL_FLAG                \n");
//			sqlsb.append("		    ,?                       \n");ps.addStringParameter(info.getSession("ID"));
//			sqlsb.append("		    ,?                       \n");ps.addStringParameter(SepoaDate.getShortDateString());
//			sqlsb.append("		    ,?                       \n");ps.addStringParameter(SepoaDate.getShortTimeString());
//			sqlsb.append("		    ,?                       \n");ps.addStringParameter(info.getSession("ID"));
//			sqlsb.append("		    ,?                       \n");ps.addStringParameter(SepoaDate.getShortDateString());
//			sqlsb.append("		    ,?                       \n");ps.addStringParameter(SepoaDate.getShortTimeString());
//			sqlsb.append("		 FROM SCTMT_FORM             \n");
//			sqlsb.append("		WHERE SEQ = ?                \n");ps.addStringParameter(cont_form_no);
//			sqlsb.append("		  AND DEL_FLAG     = ?       \n");ps.addStringParameter("N");
//			rtn = ps.doInsert(sqlsb.toString());
//			
//			ps.removeAllValue();
//			sqlsb.delete(0, sqlsb.length());
//			sqlsb.append("	SELECT							\n");
//			sqlsb.append("		 PR_NO						\n");
//			sqlsb.append("		,PR_SEQ						\n");
//			sqlsb.append("	FROM SCPLN						\n");
//			sqlsb.append("	WHERE NVL(DEL_FLAG, 'N') = 'N'	\n");
//			sqlsb.append(ps.addSelectString("	  AND CONT_NO = ?	\n"));
//			ps.addStringParameter(cont_no);
//			SepoaFormater wf = new SepoaFormater(ps.doSelect(sqlsb.toString()));
//			
//			if(wf.getRowCount() > 0) {
//				for(int i=0; i<wf.getRowCount(); i++) {
//					//PR������ ���� �������{scode_type=M157}
//					ps.removeAllValue();
//					sqlsb.delete(0, sqlsb.length());
//					sqlsb.append("		UPDATE SPRLN SET			\n");
//					sqlsb.append("			 PR_PROCEEDING_FLAG = ?	\n");ps.addStringParameter("CA");//��
//					sqlsb.append("			,DEL_FLAG			= ?	\n");ps.addStringParameter("N");
//					sqlsb.append("			,CHANGE_USER_ID		= ?	\n");ps.addStringParameter(info.getSession("ID"));
//					sqlsb.append("			,CHANGE_DATE		= ?	\n");ps.addStringParameter(SepoaDate.getShortDateString());
//					sqlsb.append("			,CHANGE_TIME		= ?	\n");ps.addStringParameter(SepoaDate.getShortTimeString());
//					sqlsb.append("		WHERE PR_NUMBER	= ?			\n");ps.addStringParameter(wf.getValue("PR_NO", i));
//					sqlsb.append("		  AND PR_SEQ	= ?			\n");ps.addStringParameter(wf.getValue("PR_SEQ", i));
//					ps.doUpdate(sqlsb.toString());
//				}
//			}

//	        ps.removeAllValue();
//			sqlsb.delete(0, sqlsb.length());
//			sqlsb.append("	SELECT COUNT(*) AS CNT FROM SCTAT WHERE CONT_FORM_NO =  '"+ cont_form_no +"' ");
//			sf = new SepoaFormater(ps.doSelect_limit(sqlsb.toString()));
//			
//			int cnt = Integer.valueOf(sf.getValue("CNT", 0));
//			
//			if(cnt > 0) {
//	        	ps.removeAllValue();
//				sqlsb.delete(0, sqlsb.length());
//				sqlsb.append("		INSERT INTO SCPAT            \n");
//				sqlsb.append("			(CONT_NO                 \n");
//				sqlsb.append("			,CONT_FORM_NO            \n");
//				sqlsb.append("			,DONT_FORM_NO            \n");
//				sqlsb.append("			,SEQ                     \n");
//				sqlsb.append("			,SEQ_SEQ                 \n");
//				sqlsb.append("			,CONTENT                 \n");
//				sqlsb.append("			,DONT_FORM_NAME          \n");
//				sqlsb.append("			,DONT_FORM_DESC          \n");
//				sqlsb.append("			,SIGN_FLAG               \n");
//				sqlsb.append("			,DONT_CLIC               \n");
//				sqlsb.append("			,WR_SUBJECT              \n");
//				sqlsb.append("			,MATERIAL_FLAG           \n");
//				sqlsb.append("			,ADD_USER_ID             \n");
//				sqlsb.append("			,ADD_DATE                \n");
//				sqlsb.append("			,ADD_TIME                \n");
//				sqlsb.append("			,CHANGE_USER_ID          \n");
//				sqlsb.append("			,CHANGE_DATE             \n");
//				sqlsb.append("			,CHANGE_TIME             \n");
//				sqlsb.append("			,DEL_FLAG                \n");
//				sqlsb.append("			,CHKECKED)               \n");
//				sqlsb.append("   SELECT                          \n");
//				sqlsb.append("   	 ?                           \n");ps.addStringParameter(cont_no);
//				sqlsb.append("   	,A.CONT_FORM_NO              \n");
//				sqlsb.append("   	,A.DONT_FORM_NO              \n");
//				sqlsb.append("   	,B.DONT_SEQ                  \n");
//				sqlsb.append("   	,B.SEQ_SEQ                   \n");
//				sqlsb.append("   	,B.CONTENT                   \n");
//				sqlsb.append("   	,A.DONT_FORM_NAME            \n");
//				sqlsb.append("   	,A.DONT_FORM_DESC            \n");
//				sqlsb.append("   	,A.SIGN_FLAG                 \n");
//				sqlsb.append("   	,A.DONT_CLIC                 \n");
//				sqlsb.append("   	,A.WR_SUBJECT                \n");
//				sqlsb.append("   	,A.MATERIAL_FLAG             \n");
//				sqlsb.append("   	,?                           \n");ps.addStringParameter(info.getSession("ID"));
//				sqlsb.append("   	,?                           \n");ps.addStringParameter(SepoaDate.getShortDateString());
//				sqlsb.append("   	,?                           \n");ps.addStringParameter(SepoaDate.getShortTimeString());
//				sqlsb.append("   	,?                           \n");ps.addStringParameter(info.getSession("ID"));
//				sqlsb.append("   	,?                           \n");ps.addStringParameter(SepoaDate.getShortDateString());
//				sqlsb.append("   	,?                           \n");ps.addStringParameter(SepoaDate.getShortTimeString());
//				sqlsb.append("   	,B.DEL_FLAG                  \n");
//				sqlsb.append("   	,?                           \n");ps.addStringParameter("Y");
//				sqlsb.append("   FROM SCTAT A, SCTAT_FORM B      \n");
//				sqlsb.append("   WHERE A.CONT_FORM_NO = B.CONT_SEQ                                    \n");
//				sqlsb.append("     AND A.DONT_FORM_NO = B.DONT_SEQ                                    \n");
//				sqlsb.append("     AND A.CONT_FORM_NO = ?                                             \n");ps.addStringParameter(cont_form_no);
//				sqlsb.append("   ORDER BY CONT_FORM_NO, DONT_FORM_NO, CONT_SEQ, DONT_SEQ, SEQ_SEQ     \n");
//				rtn = ps.doInsert(sqlsb.toString());
//			}
			
			if(rtn == 0) {
				setStatus(0);
				throw new Exception("SQL Manager is Null");
			} else {
				setStatus(1);
				Commit();
			}

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

	public SepoaOut getContractFormSelectSCPMT(String cont_form_no, String cont_gl_seq) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("					  SELECT CONTENT					 \n ");
			sqlsb.append("					  FROM   SCPMT					     \n ");
			sqlsb.append("					  WHERE  1 = 1						 \n ");
			sqlsb.append(sm.addFixString("    AND    CONT_NO            = ?		 \n ")); sm.addStringParameter(cont_form_no);
			sqlsb.append(sm.addFixString("    AND    CONT_GL_SEQ        = ?		 \n ")); sm.addStringParameter(cont_gl_seq);
			sqlsb.append("		  			  AND    NVL(DEL_FLAG, 'N') = 'N'	 \n ");
			sqlsb.append("					  ORDER BY SEQ_SEQ 				     \n ");
			setValue(sm.doSelect(sqlsb.toString()));
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}

	public SepoaOut setContractBuyerSend( String cont_no, String ct_flag, String in_attach_no, String cont_gl_seq ) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
		SepoaFormater sf = null;
		int rtn = 0;
        try {
        	
        	ps.removeAllValue();
        	sqlsb.delete(0, sqlsb.length());
        	sqlsb.append("		UPDATE SCPGL SET             \n");
        	sqlsb.append("			 CT_FLAG        = ?      \n");ps.addStringParameter(ct_flag);
        	sqlsb.append("			,ATTACH_NO      = ?      \n");ps.addStringParameter(in_attach_no);
        	sqlsb.append("			,SEND_DATE      = ?      \n");ps.addStringParameter(SepoaDate.getShortDateString());
        	sqlsb.append("			,CHANGE_USER_ID = ?      \n");ps.addStringParameter(info.getSession("ID"));
        	sqlsb.append("			,CHANGE_DATE    = ?      \n");ps.addStringParameter(SepoaDate.getShortDateString());
        	sqlsb.append("			,CHANGE_TIME    = ?      \n");ps.addStringParameter(SepoaDate.getShortTimeString());
        	sqlsb.append("		WHERE CONT_NO       = ?      \n");ps.addStringParameter(cont_no);
        	sqlsb.append("		AND   CONT_GL_SEQ   = ?      \n");ps.addStringParameter(cont_gl_seq);
        	ps.doUpdate(sqlsb.toString());
        	
        	if(getConfig("sepoa.server.development.flag").equals("false")){
	        	ps.removeAllValue();
	        	sqlsb.delete( 0, sqlsb.length() );
	        	sqlsb.append("           	       SELECT B.VENDOR_CODE                             \n");
	        	sqlsb.append("           		         ,B.NAME_LOC                                \n");
	        	sqlsb.append("                           ,C.MOBILE_NO                               \n");
	        	sqlsb.append("                     FROM   SCPGL      A                              \n");
	        	sqlsb.append("                           ,ICOMVNGL   B                              \n");
	        	sqlsb.append("                           ,ICOMVNCP   C                              \n");
	        	sqlsb.append("	                   WHERE  NVL(A.DEL_FLAG, 'N') = 'N'				\n");
				sqlsb.append(ps.addSelectString("  AND    A.CONT_NO            = ?	                \n")); ps.addStringParameter(cont_no);
				sqlsb.append(ps.addSelectString("  AND    A.CONT_GL_SEQ        = ?	                \n")); ps.addStringParameter(cont_gl_seq);
				sqlsb.append("           		   AND    A.SELLER_CODE        = B.VENDOR_CODE      \n");
	        	sqlsb.append("           		   AND    B.HOUSE_CODE         = C.HOUSE_CODE       \n");
	        	sqlsb.append("           		   AND    B.VENDOR_CODE        = C.VENDOR_CODE      \n");
				sf = new SepoaFormater( ps.doSelect_limit( sqlsb.toString() ) ); 
				//INSERT OR UPDATE
				for( int s = 0; s < sf.getRowCount(); s++ ){
//					setSmsData(sf.getValue("MOBILE_NO", s));
				}
        	}
//			ps.removeAllValue();
//			sqlsb.delete(0, sqlsb.length());
//			sqlsb.append("	SELECT							\n");
//			sqlsb.append("		 PR_NO						\n");
//			sqlsb.append("		,PR_SEQ						\n");
//			sqlsb.append("	FROM SCPLN						\n");
//			sqlsb.append("	WHERE NVL(DEL_FLAG, 'N') = 'N'	\n");
//			sqlsb.append(ps.addSelectString("	  AND CONT_NO = ?	\n"));
//			ps.addStringParameter(cont_no);
//			SepoaFormater wf = new SepoaFormater(ps.doSelect(sqlsb.toString()));
//			
//			if(wf.getRowCount() > 0) {
//				for(int i=0; i<wf.getRowCount(); i++) {
//					//PR������ ���� �������{scode_type=M157}
//					ps.removeAllValue();
//					sqlsb.delete(0, sqlsb.length());
//					sqlsb.append("		UPDATE SPRLN SET			\n");
//					sqlsb.append("			 PR_PROCEEDING_FLAG = ?	\n");ps.addStringParameter(ct_flag);//���
//					sqlsb.append("			,DEL_FLAG			= ?	\n");ps.addStringParameter("N");
//					sqlsb.append("			,CHANGE_USER_ID		= ?	\n");ps.addStringParameter(info.getSession("ID"));
//					sqlsb.append("			,CHANGE_DATE		= ?	\n");ps.addStringParameter(SepoaDate.getShortDateString());
//					sqlsb.append("			,CHANGE_TIME		= ?	\n");ps.addStringParameter(SepoaDate.getShortTimeString());
//					sqlsb.append("		WHERE PR_NUMBER	= ?			\n");ps.addStringParameter(wf.getValue("PR_NO", i));
//					sqlsb.append("		  AND PR_SEQ	= ?			\n");ps.addStringParameter(wf.getValue("PR_SEQ", i));
//					ps.doUpdate(sqlsb.toString());
//				}
//			}
			
			setStatus(1);
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
	
	public SepoaOut setCreateSave( String cont_form_no, String content, String cont_no, String cont_gl_seq ) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
		SepoaFormater sf = null;

        try {
        	setStatus(1);
        	content = content.replaceAll("\r\n", "");
        	
        	ps.removeAllValue();
	        sqlsb.delete(0,sqlsb.length());
			sqlsb.append("		DELETE FROM SCPMT		            \n");
			sqlsb.append("		WHERE CONT_NO      = ?				\n");ps.addStringParameter(cont_no);
			sqlsb.append("		AND   CONT_GL_SEQ  = ?				\n");ps.addStringParameter(cont_gl_seq);
			ps.doDelete(sqlsb.toString());

        	ps.removeAllValue();
	        sqlsb.delete(0,sqlsb.length());
	        sqlsb.append("	INSERT INTO SCPMT (			\n");
	        sqlsb.append("		 CONT_NO				\n");
	        sqlsb.append("		,CONT_GL_SEQ			\n");
	        sqlsb.append("		,SEQ					\n");
	        sqlsb.append("		,SEQ_SEQ				\n");
	        sqlsb.append("		,CONTENT				\n");
	        sqlsb.append("		,ADD_USER_ID			\n");
	        sqlsb.append("		,ADD_DATE				\n");
	        sqlsb.append("		,ADD_TIME				\n");
	        sqlsb.append("		,CHANGE_USER_ID			\n");
	        sqlsb.append("		,CHANGE_DATE			\n");
	        sqlsb.append("		,CHANGE_TIME			\n");
	        sqlsb.append("		,DEL_FLAG				\n");
	        sqlsb.append("	) VALUES (					\n");
	        sqlsb.append("		 ?						\n");ps.addStringParameter(cont_no);
	        sqlsb.append("		,?						\n");ps.addStringParameter(cont_gl_seq);
	        sqlsb.append("		,?						\n");ps.addStringParameter(cont_form_no);
	        sqlsb.append("		,TO_CHAR(?, '000000')	\n");ps.addStringParameter("1");
	        sqlsb.append("		,?						\n");ps.addStringParameter(content);
	        sqlsb.append("		,?						\n");ps.addStringParameter(info.getSession("ID"));
	        sqlsb.append("		,?						\n");ps.addStringParameter(SepoaDate.getShortDateString());
	        sqlsb.append("		,?						\n");ps.addStringParameter(SepoaDate.getShortTimeString());
	        sqlsb.append("		,?						\n");ps.addStringParameter(info.getSession("ID"));
	        sqlsb.append("		,?						\n");ps.addStringParameter(SepoaDate.getShortDateString());
	        sqlsb.append("		,?						\n");ps.addStringParameter(SepoaDate.getShortTimeString());
	        sqlsb.append("		,?						\n");ps.addStringParameter("N");
	        sqlsb.append("	)							\n");
	        ps.doInsert(sqlsb.toString());
    
        	setValue(cont_no);
        	Commit();
		} catch (Exception e) {
			try {
				
				Rollback();
			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}
			setStatus(0);
//			e.printStackTrace();
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}

	private void setSmsData( String mobile_no) throws Exception
	{
  
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		SepoaFormater sf = null; 
		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

		sm.removeAllValue();
		sqlsb.delete(0, sqlsb.length());
		sqlsb.append("  SELECT										\n");
		sqlsb.append("  	 TEXT1                                  \n");
		sqlsb.append("  FROM  SCODE                       			\n");
		sqlsb.append("   WHERE TYPE = 'M314'	 					\n");
		sqlsb.append("  AND DEL_FLAG = 'N'                          \n");
		sqlsb.append("  AND CODE = 'CT'                             \n");
		sqlsb.append("  AND USE_FLAG = 'Y'                          \n");
		sf = new SepoaFormater(sm.doSelect(sqlsb.toString()));

		String message = sf.getValue("TEXT1", 0); 
 
		String hostname		   =    getConfig("sepoa.sms.hostname");
		int port		       =    Integer.parseInt(getConfig("sepoa.sms.port"));

//		SmsClient cl = new SmsClient(hostname, port, mobile_no, message);

	}
	
public SepoaOut getContractsignSelect(String company_code, String seller_code) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			

			sqlsb.append("  					SELECT                                     \n");
			sqlsb.append("  					(SELECT DES_FILE_NAME                      \n");
			sqlsb.append("  					FROM                                       \n");
			sqlsb.append("  						SFILE A,                               \n");
			sqlsb.append("  						(SELECT SIGN_ATTACH_NO                 \n");
			sqlsb.append("  						FROM ICOMCMGL           	           \n");
			sqlsb.append("  						WHERE 1=1                 			   \n");	
			sqlsb.append(sm.addSelectString("  		 AND COMPANY_CODE =?				   \n"));sm.addStringParameter(company_code);
			sqlsb.append("  						) B                    				   \n");
			sqlsb.append(" 						WHERE A.DOC_NO = B.SIGN_ATTACH_NO          \n");
			sqlsb.append("  					) AS WOORI_SIGN_NAME                       \n");
			sqlsb.append("  					,(                                         \n");
			sqlsb.append("  					SELECT DES_FILE_NAME                       \n");
			sqlsb.append(" 						FROM                                       \n");
			sqlsb.append("  						SFILE A,                               \n");
			sqlsb.append("   						(SELECT SIGN_ATTACH_NO                 \n");
			sqlsb.append("   						FROM ICOMVNGL                    	   \n");
			sqlsb.append("  					WHERE 1=1 						    	   \n");
			sqlsb.append(sm.addSelectString("  	AND VENDOR_CODE =?			    		   \n"));sm.addStringParameter(seller_code);
			sqlsb.append("  					) B 						    		   \n");
			sqlsb.append("  					WHERE A.DOC_NO = B.SIGN_ATTACH_NO          \n");
			sqlsb.append(" 					 	) AS VENDOR_SIGN_NAME                      \n");
			sqlsb.append("  			 		FROM DUAL                                  \n");

			setValue(sm.doSelect(sqlsb.toString()));
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}

public SepoaOut getContractGuaranteeView(String cont_no, String cont_gl_seq, String bond_type) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer(); 
 
		try {
			setStatus(1);
			setFlag(true); 
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());  
			sqlsb.append(" SELECT                                     \n");
			if(bond_type.equals("002"))
				sqlsb.append("  	CONT_INS_DATA                     \n"); 
			else
				sqlsb.append("  	FAULT_INS_DATA                     \n"); 
			sqlsb.append(" FROM SCPFL                              \n"); 
			sqlsb.append(" WHERE 1=1                 			   \n");	
			sqlsb.append(" AND COMPANY_CODE = 'W100'   \n");	 
			sqlsb.append(sm.addSelectString("  	AND CONT_NO =?	\n"));sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString("  	AND CONT_GL_SEQ =?	\n"));sm.addStringParameter(cont_gl_seq); 

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