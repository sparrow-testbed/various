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

public class CT_030 extends SepoaService
{
	private String ID = info.getSession("ID");

	public CT_030(String opt, SepoaInfo info) throws SepoaServiceException
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

    public SepoaOut getContractList(String from_date, String to_date, String seller_code, String cont_no, String status, String ele_cont_flag, String sign_person_id, String subject, String view, String sg_type1, String sg_type2, String sg_type3) {

		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		String COMPANY_CODE = info.getSession("COMPANY_CODE");
		String USER_TYPE = info.getSession("USER_TYPE");
		
		try {
			setStatus(1);
			setFlag(true);
			
			if(USER_TYPE.equals("S")) {
				seller_code = COMPANY_CODE;
			}

			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append(" 			 SELECT                         										\n ");
			sqlsb.append(" 			 		 CONT_NO                										\n ");
			sqlsb.append(" 			 		,CONT_GL_SEQ                  									\n ");
			sqlsb.append(" 			 		,BD_NO                  										\n ");
			sqlsb.append(" 			 		,CONT_METHOD            										\n ");
			sqlsb.append(" 			 		,SELLER_CODE AS SELLER											\n ");
			sqlsb.append(" 			 		,SELLER_CODE													\n ");  	
			sqlsb.append(" 			 		,GETCOMPANYNAMELOC('"+info.getSession("HOUSE_CODE")+"', SELLER_CODE, 'S') AS SELLER_CODE_TEXT		\n ");
			sqlsb.append(" 			 		,GETCODETEXT2('M286', CT_FLAG, 'KO') AS CT_NAME       			\n ");
			sqlsb.append(" 			 		,CT_FLAG                    									\n ");
			sqlsb.append(" 			 		,CONVERT_DATE(CONT_DATE) AS CONT_DATE                 			\n ");
			sqlsb.append(" 			 		,CONVERT_DATE(CONT_FROM) AS CONT_FROM                 			\n ");
			sqlsb.append(" 			 		,CONVERT_DATE(CONT_TO)   AS CONT_TO                  			\n ");
			sqlsb.append(" 			 		,CONT_AMT                   									\n ");
			sqlsb.append(" 			 		,GETCODETEXT2('M806', ELE_CONT_FLAG, 'KO') AS ELE_CONT_FLAG     \n ");
			sqlsb.append(" 			 		,CONT_TYPE                  									\n ");
			sqlsb.append(" 			 		,SUBJECT                    									\n ");
			sqlsb.append(" 			 		,TO_CHAR(TO_DATE(CONT_DATE), 'YYYY/MM/DD') AS CONT_ADD_DATE     \n ");
			sqlsb.append(" 			 		,SIGN_PERSON_ID             									\n ");
			sqlsb.append(" 			 		,SIGN_PERSON_NAME           									\n ");
			sqlsb.append(" 			 		,CONVERT_DATE(SELLER_CONFRIM_DATE) AS SELLER_CONFRIM_DATE       \n ");
			sqlsb.append(" 			 		,CONT_FORM_NO               									\n ");
			sqlsb.append(" 			 		,ATTACH_NO		               									\n ");
			sqlsb.append(" 			 		,CONT_INS_NO		               									\n ");
			sqlsb.append(" 			 		,FAULT_INS_NO		               									\n ");
			sqlsb.append(" 			 		,SIGN_PERSON_NAME		               								\n ");
			sqlsb.append(" 			 		,CONT_FILE_NO		               									\n ");
			sqlsb.append(" 			 		,FAULT_FILE_NO		               									\n ");
			if("".equals(view)){
			sqlsb.append(" 			 		,CONT_INS_VN														\n ");
			}else{
			sqlsb.append("					,GETCODETEXT1('M225', CONT_INS_VN, 'KO') AS CONT_INS_VN             \n");
			}
			sqlsb.append(" 			 		,NVL(SIGN_STATUS, 'T') AS SIGN_STATUS								\n ");
			sqlsb.append(" 			 		,GETCODETEXT1('M100', NVL(SIGN_STATUS, 'T'), 'KO') AS SIGN_STATUS_TEXT	\n ");
			sqlsb.append(" 			 		,CONT_GL_SEQ														\n ");
			sqlsb.append(" 			 		,CONT_TYPE1_TEXT													\n ");
			sqlsb.append(" 			 		,CONT_TYPE2_TEXT													\n ");
			sqlsb.append(" 			 		,REJECT_REASON														\n ");
			sqlsb.append(" 			 		,getsgname2(SG_LEV1) AS	SG_LEV1										\n ");
			sqlsb.append(" 			 		,getsgname2(SG_LEV2) AS SG_LEV2										\n ");
			sqlsb.append(" 			 		,getsgname2(SG_LEV3) AS SG_LEV3										\n ");
			sqlsb.append(" 			 		,(SELECT MAX(CONT_GL_SEQ) FROM SCPGL WHERE CONT_NO = A.CONT_NO AND NVL(DEL_FLAG,'N') = 'N' ) AS MAX_CNT				\n ");
			sqlsb.append(" 			 		,( SELECT CT_FLAG FROM SCPGL WHERE CONT_NO = A.CONT_NO AND CONT_GL_SEQ = (SELECT MAX(CONT_GL_SEQ) AS CNT FROM SCPGL WHERE CONT_NO = A.CONT_NO ) ) AS MAX_CT_FLAG	\n ");
			sqlsb.append("					,GETCODETEXT1('M223', CONT_DD_FLAG, 'KO') AS CONT_DD_FLAG                       \n");
			sqlsb.append("					,GETCODETEXT1('M223', FAULT_DD_FLAG, 'KO') AS FAULT_DD_FLAG                       \n");
			sqlsb.append("					,A.EXEC_NO                      \n");
			sqlsb.append("					,SUBSTR(A.REMARK,1,50) AS REMARK                      \n");			
			sqlsb.append(" 			 FROM   SCPGL A                      										\n ");
			sqlsb.append(" 			 WHERE  NVL(DEL_FLAG, 'N') = 'N'  										\n ");
			//sqlsb.append(" 			 AND    TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')) <= TO_NUMBER(CONT_TO)  	\n ");
			
			if(info.getSession("USER_TYPE").equals("S")) { 
				sqlsb.append("       AND    CT_FLAG IN('CC', 'CD', 'CE', 'OF', 'CR', 'CV', 'CL' )  							\n "); 
				sqlsb.append(sm.addSelectString(" AND SELLER_CODE = ?                        				\n "));	sm.addStringParameter(info.getSession("COMPANY_CODE"));
			} else {
				sqlsb.append("       AND    CT_FLAG NOT IN( 'CT', 'CW' )  									\n ");
				sqlsb.append(sm.addSelectString(" AND SIGN_PERSON_ID = ?                                    \n "));	sm.addStringParameter(sign_person_id);
				sqlsb.append(sm.addSelectString("     AND SELLER_CODE    = ?                                	\n ")); sm.addStringParameter(seller_code);
			}
			
			sqlsb.append(sm.addSelectString("     AND CONT_DATE >=     ?                                   \n ")); sm.addStringParameter(from_date);
			sqlsb.append(sm.addSelectString("     AND CONT_DATE <=     ?                                    \n ")); sm.addStringParameter(to_date);
			sqlsb.append(sm.addSelectString("     AND CONT_NO        = ?                                	\n ")); sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString("     AND CT_FLAG        = ?                               	 	\n ")); sm.addStringParameter(status);
			sqlsb.append(sm.addSelectString("     AND ELE_CONT_FLAG  = ?                                    \n ")); sm.addStringParameter(ele_cont_flag);
			sqlsb.append(sm.addSelectString("     AND SUBJECT LIKE '%' || ? || '%'                          \n ")); sm.addStringParameter(subject);
			sqlsb.append(sm.addSelectString("     AND SIGN_PERSON_ID = ?                                    \n ")); sm.addStringParameter(sign_person_id);
			sqlsb.append(sm.addSelectString("     AND SG_LEV1 		 = ?                                    \n ")); sm.addStringParameter(sg_type1);
			sqlsb.append(sm.addSelectString("     AND SG_LEV2 		 = ?                                    \n ")); sm.addStringParameter(sg_type2);
			sqlsb.append(sm.addSelectString("     AND SG_LEV3        = ?                                    \n ")); sm.addStringParameter(sg_type3);
//			sqlsb.append("            AND NOT (CT_FLAG='CD' AND  SIGN_STATUS='E')           									    \n ");
			sqlsb.append("            ORDER BY CONT_NO DESC           									    \n "); 
			setValue(sm.doSelect(sqlsb.toString()));

		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
    
    
    public SepoaOut getContractList2(String from_date, String to_date, String seller_code, String cont_no, String status, String ele_cont_flag, String sign_person_id, String subject, String view, String sg_type1, String sg_type2, String sg_type3) {
    	
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sqlsb = new StringBuffer();
    	String COMPANY_CODE = info.getSession("COMPANY_CODE");
    	String USER_TYPE = info.getSession("USER_TYPE");
    	
    	try {
    		setStatus(1);
    		setFlag(true);
    		
    		if(USER_TYPE.equals("S")) {
    			seller_code = COMPANY_CODE;
    		}
    		
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		
    		sm.removeAllValue();
    		sqlsb.delete(0, sqlsb.length());
    		sqlsb.append(" 			 SELECT                         										\n ");
    		sqlsb.append(" 			 		 A.CONT_NO                										\n ");
    		sqlsb.append(" 			 		,A.CONT_GL_SEQ                  									\n ");
    		sqlsb.append(" 			 		,A.BD_NO                  										\n ");
    		sqlsb.append(" 			 		,A.CONT_METHOD            										\n ");
    		sqlsb.append(" 			 		,A.SELLER_CODE AS SELLER											\n ");
    		sqlsb.append(" 			 		,A.SELLER_CODE													\n ");  	
    		sqlsb.append(" 			 		,GETCOMPANYNAMELOC('"+info.getSession("HOUSE_CODE")+"', A.SELLER_CODE, 'S') AS SELLER_CODE_TEXT		\n ");
    		sqlsb.append(" 			 		,GETCODETEXT2('M286', A.CT_FLAG, 'KO') AS CT_NAME       			\n ");
    		sqlsb.append(" 			 		,A.CT_FLAG                    									\n ");
    		sqlsb.append(" 			 		,CONVERT_DATE(A.CONT_DATE) AS CONT_DATE                 			\n ");
    		sqlsb.append(" 			 		,CONVERT_DATE(A.CONT_FROM) AS CONT_FROM                 			\n ");
    		sqlsb.append(" 			 		,CONVERT_DATE(A.CONT_TO)   AS CONT_TO                  			\n ");
    		sqlsb.append(" 			 		,A.CONT_AMT                   									\n ");
    		sqlsb.append(" 			 		,GETCODETEXT2('M806', A.ELE_CONT_FLAG, 'KO') AS ELE_CONT_FLAG     \n ");
    		sqlsb.append(" 			 		,A.CONT_TYPE                  									\n ");
    		sqlsb.append(" 			 		,A.SUBJECT                    									\n ");
    		sqlsb.append(" 			 		,TO_CHAR(TO_DATE(A.CONT_DATE), 'YYYY/MM/DD') AS CONT_ADD_DATE     \n ");
    		sqlsb.append(" 			 		,A.SIGN_PERSON_ID             									\n ");
    		sqlsb.append(" 			 		,A.SIGN_PERSON_NAME           									\n ");
    		sqlsb.append(" 			 		,CONVERT_DATE(A.SELLER_CONFRIM_DATE) AS SELLER_CONFRIM_DATE       \n ");
    		sqlsb.append(" 			 		,A.CONT_FORM_NO               									\n ");
    		sqlsb.append(" 			 		,A.ATTACH_NO		               									\n ");
    		sqlsb.append(" 			 		,A.CONT_INS_NO		               									\n ");
    		sqlsb.append(" 			 		,A.FAULT_INS_NO		               									\n ");
    		sqlsb.append(" 			 		,A.SIGN_PERSON_NAME		               								\n ");
    		sqlsb.append(" 			 		,A.CONT_FILE_NO		               									\n ");
    		sqlsb.append(" 			 		,A.FAULT_FILE_NO		               									\n ");
    		if("".equals(view)){
    			sqlsb.append(" 			 		,A.CONT_INS_VN													\n ");
    		}else{
    			sqlsb.append("		,GETCODETEXT1('M225', A.CONT_INS_VN, 'KO') AS CONT_INS_VN                       \n");
    			
    		}
    		sqlsb.append(" 			 		,A.SIGN_STATUS		               									\n ");
    		sqlsb.append(" 			 		,GETCODETEXT1('M100', A.SIGN_STATUS, 'KO') AS SIGN_STATUS_TEXT		\n ");
    		sqlsb.append(" 			 		,A.CONT_GL_SEQ														\n ");
    		sqlsb.append(" 			 		,A.CONT_TYPE1_TEXT													\n ");
    		sqlsb.append(" 			 		,A.CONT_TYPE2_TEXT													\n ");
    		sqlsb.append(" 			 		,A.REJECT_REASON													\n ");
    		sqlsb.append(" 			 		,( SELECT DISTINCT SG_NAME FROM SSGGL WHERE SG_REFITEM = SG_LEV1)								\n ");
    		sqlsb.append(" 			 		|| ' / ' ||( SELECT DISTINCT SG_NAME FROM SSGGL WHERE SG_REFITEM = SG_LEV2)								\n ");
    		sqlsb.append(" 			 		|| ' / ' ||( SELECT DISTINCT SG_NAME FROM SSGGL WHERE SG_REFITEM = SG_LEV3)	AS SG_LEV 							\n ");
    		sqlsb.append(" 			 		,( SELECT DISTINCT SG_NAME FROM SSGGL WHERE SG_REFITEM = SG_LEV1) AS SG_LEV1								\n ");
    		sqlsb.append(" 			 		,( SELECT DISTINCT SG_NAME FROM SSGGL WHERE SG_REFITEM = SG_LEV2) AS SG_LEV2								\n ");
    		sqlsb.append(" 			 		,( SELECT DISTINCT SG_NAME FROM SSGGL WHERE SG_REFITEM = SG_LEV3) AS SG_LEV3								\n ");
    		sqlsb.append(" 			 		,( SELECT MAX(CONT_GL_SEQ) FROM SCPGL WHERE CONT_NO = A.CONT_NO AND NVL(DEL_FLAG,'N') = 'N' ) AS MAX_CNT				\n ");
    		sqlsb.append(" 			 		,( SELECT CT_FLAG FROM SCPGL WHERE CONT_NO = A.CONT_NO AND CONT_GL_SEQ = (SELECT MAX(CONT_GL_SEQ) AS CNT FROM SCPGL WHERE CONT_NO = A.CONT_NO ) ) AS MAX_CT_FLAG	\n ");
    		sqlsb.append("					,GETCODETEXT1('M223', CONT_DD_FLAG, 'KO') AS CONT_DD_FLAG                       \n");
    		sqlsb.append("					,GETCODETEXT1('M223', FAULT_DD_FLAG, 'KO') AS FAULT_DD_FLAG                       \n");
    		sqlsb.append("					,A.EXEC_NO                      	\n");
    		sqlsb.append("					,CNHD.ADD_USER_ID AS EXEC_USER_ID                      \n");
    		sqlsb.append("					,GETUSERNAMELOC('"+info.getSession("HOUSE_CODE")+"',CNHD.ADD_USER_ID) AS EXEC_USER_NAME                      \n");
    		sqlsb.append("					,SCTP.SIGN_USER_ID AS LAST_SIGN_USER_ID                    \n");
    		sqlsb.append("					,GETUSERNAMELOC('"+info.getSession("HOUSE_CODE")+"',SCTP.SIGN_USER_ID) AS LAST_SIGN_USER_NAME                      \n");
    		sqlsb.append(" 			 FROM   SCPGL A ,  ICOYCNHD CNHD ,                   										\n ");
    		sqlsb.append(" 			 (SELECT DOC_NO, DOC_SEQ, SIGN_USER_ID FROM ICOMSCTP AA WHERE SIGN_PATH_SEQ = (SELECT MAX(SIGN_PATH_SEQ) FROM ICOMSCTP BB WHERE AA.DOC_NO = BB.DOC_NO AND AA.DOC_SEQ = BB.DOC_SEQ) )SCTP                  										\n ");
    		sqlsb.append(" 			 WHERE  NVL(DEL_FLAG, 'N') = 'N'  										\n ");
    		//sqlsb.append(" 			 AND    TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')) <= TO_NUMBER(CONT_TO)  	\n ");
    		//sqlsb.append("       AND    CT_FLAG IN ('CD', 'OF')  									\n ");
    		sqlsb.append("       AND ((A.CT_FLAG='CD' AND A.SIGN_STATUS='E') or A.CT_FLAG='OF')		\n ");
    		sqlsb.append("       AND    A.EXEC_NO = CNHD.EXEC_NO 									\n ");
    		sqlsb.append("       AND    A.CONT_NO = SCTP.DOC_NO(+) 									\n ");
    		sqlsb.append("       AND    A.CONT_GL_SEQ  = SCTP.DOC_SEQ(+) 									\n ");
    		
    		if(info.getSession("USER_TYPE").equals("S")) { 
    			sqlsb.append(sm.addSelectString(" AND A.SELLER_CODE = ?                        				\n "));	sm.addStringParameter(info.getSession("COMPANY_CODE"));
    		} else {
    			if (!sign_person_id.equals(""))
    			{
    				sqlsb.append(sm.addSelectString(" AND A.SIGN_PERSON_ID = ?                                    \n "));	sm.addStringParameter(sign_person_id); //sm.addStringParameter(info.getSession("ID"));
    			}
    			sqlsb.append(sm.addSelectString("     AND A.SELLER_CODE    = ?                                	\n ")); sm.addStringParameter(seller_code);
    		}
    		
    		sqlsb.append(sm.addSelectString("     AND A.CONT_DATE >=     ?                                   \n ")); sm.addStringParameter(from_date);
    		sqlsb.append(sm.addSelectString("     AND A.CONT_DATE <=     ?                                    \n ")); sm.addStringParameter(to_date);
    		sqlsb.append(sm.addSelectString("     AND A.CONT_NO        = ?                                	\n ")); sm.addStringParameter(cont_no);
    		sqlsb.append(sm.addSelectString("     AND A.CT_FLAG        = ?                               	 	\n ")); sm.addStringParameter(status);
    		sqlsb.append(sm.addSelectString("     AND A.ELE_CONT_FLAG  = ?                                    \n ")); sm.addStringParameter(ele_cont_flag);
    		sqlsb.append(sm.addSelectString("     AND A.SUBJECT LIKE '%' || ? || '%'                          \n ")); sm.addStringParameter(subject);
    		sqlsb.append(sm.addSelectString("     AND A.SIGN_PERSON_ID = ?                                    \n ")); sm.addStringParameter(sign_person_id);
    		sqlsb.append(sm.addSelectString("     AND SG_LEV1 		 = ?                                    \n ")); sm.addStringParameter(sg_type1);
    		sqlsb.append(sm.addSelectString("     AND SG_LEV2 		 = ?                                    \n ")); sm.addStringParameter(sg_type2);
    		sqlsb.append(sm.addSelectString("     AND SG_LEV3        = ?                                    \n ")); sm.addStringParameter(sg_type3);
    		sqlsb.append("            ORDER BY CONT_NO DESC           									    \n "); 
    		setValue(sm.doSelect(sqlsb.toString()));
    		
    	} catch (Exception e) {
    		setStatus(0);
    		setFlag(false);
    		setMessage(e.getMessage());
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    	}
    	
    	return getSepoaOut();
    }
    
public SepoaOut getContractList3(String from_date1, String to_date1, String from_date2, String to_date2, String seller_code, String cont_no, String status, String ele_cont_flag, String sign_person_id, String subject, String view, String sg_type1, String sg_type2, String sg_type3, String gw_cod_no, String gw_title) {
    	
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sqlsb = new StringBuffer();
    	String COMPANY_CODE = info.getSession("COMPANY_CODE");
    	String USER_TYPE = info.getSession("USER_TYPE");
    	
    	try {
    		setStatus(1);
    		setFlag(true);
    		
    		if(USER_TYPE.equals("S")) {
    			seller_code = COMPANY_CODE;
    		}
    		
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		
    		sm.removeAllValue();
    		sqlsb.delete(0, sqlsb.length());
    		sqlsb.append(" 			 SELECT                         										\n ");
    		sqlsb.append(" 			 		 A.CONT_NO                										\n ");
    		sqlsb.append(" 			 		,A.CONT_GL_SEQ                  									\n ");
    		sqlsb.append(" 			 		,A.CONT_METHOD            										\n ");
    		sqlsb.append(" 			 		,A.SELLER_CODE AS SELLER											\n ");
    		sqlsb.append(" 			 		,A.SELLER_CODE													\n ");  	
    		sqlsb.append(" 			 		,GETCOMPANYNAMELOC('"+info.getSession("HOUSE_CODE")+"', A.SELLER_CODE, 'S') AS SELLER_CODE_TEXT		\n ");
    		sqlsb.append(" 			 		,GETCODETEXT2('M286', A.CT_FLAG, 'KO') AS CT_NAME       			\n ");
    		sqlsb.append(" 			 		,A.CT_FLAG                    									\n ");
    		sqlsb.append(" 			 		,CONVERT_DATE(A.CONT_DATE) AS CONT_DATE                 			\n ");
    		sqlsb.append(" 			 		,CONVERT_DATE(A.CONT_FROM) AS CONT_FROM                 			\n ");
    		sqlsb.append(" 			 		,CONVERT_DATE(A.CONT_TO)   AS CONT_TO                  			\n ");
    		sqlsb.append(" 			 		,A.CONT_AMT                   									\n ");
    		sqlsb.append(" 			 		,GETCODETEXT2('M806', A.ELE_CONT_FLAG, 'KO') AS ELE_CONT_FLAG     \n ");
    		sqlsb.append(" 			 		,A.CONT_TYPE                  									\n ");
    		sqlsb.append(" 			 		,A.SUBJECT                    									\n ");
    		sqlsb.append(" 			 		,TO_CHAR(TO_DATE(A.CONT_DATE), 'YYYY/MM/DD') AS CONT_ADD_DATE     \n ");
    		sqlsb.append(" 			 		,A.SIGN_PERSON_ID             									\n ");
    		sqlsb.append(" 			 		,A.SIGN_PERSON_NAME           									\n ");
    		sqlsb.append(" 			 		,CONVERT_DATE(A.SELLER_CONFRIM_DATE) AS SELLER_CONFRIM_DATE       \n ");
    		sqlsb.append(" 			 		,A.CONT_FORM_NO               									\n ");
    		sqlsb.append(" 			 		,A.ATTACH_NO		               									\n ");
    		sqlsb.append(" 			 		,A.CONT_INS_NO		               									\n ");
    		sqlsb.append(" 			 		,A.FAULT_INS_NO		               									\n ");
    		sqlsb.append(" 			 		,A.SIGN_PERSON_NAME		               								\n ");
    		sqlsb.append(" 			 		,A.CONT_FILE_NO		               									\n ");
    		sqlsb.append(" 			 		,A.FAULT_FILE_NO		               									\n ");
    		if("".equals(view)){
    			sqlsb.append(" 			 		,A.CONT_INS_VN													\n ");
    		}else{
    			sqlsb.append("		,GETCODETEXT1('M225', A.CONT_INS_VN, 'KO') AS CONT_INS_VN                       \n");
    			
    		}
    		sqlsb.append(" 			 		,A.SIGN_STATUS		               									\n ");
    		sqlsb.append(" 			 		,GETCODETEXT1('M100', A.SIGN_STATUS, 'KO') AS SIGN_STATUS_TEXT		\n ");
    		sqlsb.append(" 			 		,A.CONT_GL_SEQ														\n ");
    		sqlsb.append(" 			 		,A.CONT_TYPE1_TEXT													\n ");
    		sqlsb.append(" 			 		,A.CONT_TYPE2_TEXT													\n ");
    		sqlsb.append(" 			 		,A.REJECT_REASON													\n ");
    		sqlsb.append(" 			 		,( SELECT DISTINCT SG_NAME FROM SSGGL WHERE SG_REFITEM = SG_LEV1)								\n ");
    		sqlsb.append(" 			 		|| ' / ' ||( SELECT DISTINCT SG_NAME FROM SSGGL WHERE SG_REFITEM = SG_LEV2)								\n ");
    		sqlsb.append(" 			 		|| ' / ' ||( SELECT DISTINCT SG_NAME FROM SSGGL WHERE SG_REFITEM = SG_LEV3)	AS SG_LEV 							\n ");
    		sqlsb.append(" 			 		,( SELECT DISTINCT SG_NAME FROM SSGGL WHERE SG_REFITEM = SG_LEV1) AS SG_LEV1								\n ");
    		sqlsb.append(" 			 		,( SELECT DISTINCT SG_NAME FROM SSGGL WHERE SG_REFITEM = SG_LEV2) AS SG_LEV2								\n ");
    		sqlsb.append(" 			 		,( SELECT DISTINCT SG_NAME FROM SSGGL WHERE SG_REFITEM = SG_LEV3) AS SG_LEV3								\n ");
    		sqlsb.append(" 			 		,( SELECT MAX(CONT_GL_SEQ) FROM SCPGL WHERE CONT_NO = A.CONT_NO AND NVL(DEL_FLAG,'N') = 'N' ) AS MAX_CNT				\n ");
    		sqlsb.append(" 			 		,( SELECT CT_FLAG FROM SCPGL WHERE CONT_NO = A.CONT_NO AND CONT_GL_SEQ = (SELECT MAX(CONT_GL_SEQ) AS CNT FROM SCPGL WHERE CONT_NO = A.CONT_NO ) ) AS MAX_CT_FLAG	\n ");
    		sqlsb.append("					,GETCODETEXT1('M223', CONT_DD_FLAG, 'KO') AS CONT_DD_FLAG                       \n");
    		sqlsb.append("					,GETCODETEXT1('M223', FAULT_DD_FLAG, 'KO') AS FAULT_DD_FLAG                       \n");
    		sqlsb.append("					,A.EXEC_NO                      	\n");
    		sqlsb.append("					,CNHD.ADD_USER_ID AS EXEC_USER_ID                      \n");
    		sqlsb.append("					,GETUSERNAMELOC('"+info.getSession("HOUSE_CODE")+"',CNHD.ADD_USER_ID) AS EXEC_USER_NAME                      \n");
    		sqlsb.append("					,SCTP.SIGN_USER_ID AS LAST_SIGN_USER_ID                    \n");
    		sqlsb.append("					,GETUSERNAMELOC('"+info.getSession("HOUSE_CODE")+"',SCTP.SIGN_USER_ID) AS LAST_SIGN_USER_NAME                      \n");
    		
    		sqlsb.append("					,GW.GW_COD_NO AS GW_COD_NO                      \n");
    		sqlsb.append("					,GW.GW_TITLE AS GW_TITLE                        \n");
    		sqlsb.append("					,GW.DOC_LINK AS DOC_LINK                        \n");
    		
    		sqlsb.append("    	            ,(SELECT TEXT2 FROM SCODE WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"' AND TYPE = 'M355' AND USE_FLAG = 'Y' AND CODE = A.ASSURE_FLAG)          AS ASSURE_FLAG_TEXT        \n "); //계약이행 보증구분
    		sqlsb.append("    	            ,A.FAULT_INS_PERCENT                 \n"); //하자보증금 %
			sqlsb.append("    	            ,TO_CHAR(A.FAULT_INS_AMT,'999,999,999,999,999')  AS FAULT_INS_AMT \n"); //하자보증금 금액
			sqlsb.append("    	            ,A.CONT_ASSURE_PERCENT               \n"); //계약보증금 %
			sqlsb.append("    	            ,TO_CHAR(A.CONT_ASSURE_AMT,'999,999,999,999,999')  AS CONT_ASSURE_AMT                   \n"); //계약보증금 금액
			
			sqlsb.append("    	            ,CASE WHEN A.FAULT_INS_TERM IS NOT NULL AND A.FAULT_INS_TERM <> 0 THEN CAST(A.FAULT_INS_TERM/12 AS NUMBER(10,0)) || '년 ' ||  MOD(A.FAULT_INS_TERM,12) || '월' ELSE '' END AS FAULT_INS_TERM    \n"); //하자보증기간 (연산로직 contract_approval_detail.jsp 참조)
			
			sqlsb.append("    	            ,A.FAULT_INS_TERM AS FAULT_INS_TERM_H    \n"); //하자보증기간 (개발용 삭제예정)
			
			/*
			if( !"".equals( FAULT_INS_TERM ) && !"0".equals( FAULT_INS_TERM ) ){
			    
			    
			    FAULT_INS_TERM_MON = "" + Integer.parseInt(FAULT_INS_TERM) % 12;
			    Logger.sys.println("FAULT_INS_TERM_MON = " + FAULT_INS_TERM_MON);
			        
			    FAULT_INS_TERM  = "" + Integer.parseInt(FAULT_INS_TERM) / 12; 
			    Logger.sys.println("FAULT_INS_TERM2 = " + FAULT_INS_TERM);
			    
			    
				if(FAULT_INS_TERM.equals("0")) FAULT_INS_TERM = "";
		    }else{
		    	FAULT_INS_TERM = "";
		    }
		    */
			
			
			sqlsb.append("    	            ,A.BD_NO||'('||A.BD_COUNT||')' AS BD_NO_COUNT   \n"); //소싱번호			
			sqlsb.append("    	            ,A.BD_NO                             \n"); //소싱번호
			sqlsb.append("    	            ,A.BD_COUNT                          \n"); //소싱번호
			sqlsb.append("    	            ,CASE WHEN A.DELAY_CHARGE IS NULL THEN '' ELSE '1000 분의 '||A.DELAY_CHARGE END AS DELAY_CHARGE    \n"); //지체상금율(%)   1000 분의 DELAY_CHARGE
	
			sqlsb.append("    	            ,A.ITEM_TYPE	                     \n"); //물품종류
			sqlsb.append("    	            ,CONVERT_DATE(A.RD_DATE) AS RD_DATE	                         \n"); //납품기한
			sqlsb.append("    	            ,A.DELV_PLACE                        \n"); //납품장소
			sqlsb.append("    	            ,(SELECT TEXT2 FROM SCODE WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"' AND TYPE = 'M204' AND USE_FLAG = 'Y' AND CODE = A.CONT_TOTAL_GUBUN)     AS CONT_TOTAL_GUBUN_TEXT   \n "); //계약단가 명칭 					
			sqlsb.append("    	            ,TO_CHAR(A.CONT_PRICE,'999,999,999,999,999')  AS CONT_PRICE	 \n"); //계약단가
			sqlsb.append("    	            ,A.REMARK                            \n"); //비고
						
    		sqlsb.append(" 			 FROM   SCPGL A ,  ICOYCNHD CNHD                    										\n ");
    		sqlsb.append(" 			 ,(SELECT DOC_NO, DOC_SEQ, SIGN_USER_ID FROM ICOMSCTP AA WHERE SIGN_PATH_SEQ = (SELECT MAX(SIGN_PATH_SEQ) FROM ICOMSCTP BB WHERE AA.DOC_NO = BB.DOC_NO AND AA.DOC_SEQ = BB.DOC_SEQ) )SCTP                  										\n ");    		
    		sqlsb.append("           ,(SELECT DISTINCT CNDT.EXEC_NO, INEP.GW_COD_NO, INEP.GW_TITLE, INEP.DOC_LINK                                                                \n ");
    		sqlsb.append("       		FROM  GWAPPPR  APPR                                                                                                       \n ");
    		sqlsb.append("       	   INNER JOIN GWAPP       GAPP ON APPR.HOUSE_CODE = GAPP.HOUSE_CODE AND APPR.INF_NO = GAPP.INF_NO                             \n ");
    		sqlsb.append("       	   INNER JOIN SINEP0022_2 INEP ON GAPP.HOUSE_CODE = INEP.HOUSE_CODE AND GAPP.INF_NO = INEP.DOC_NO                             \n ");
    		sqlsb.append("       	   INNER JOIN ICOYCNDT    CNDT ON APPR.HOUSE_CODE = CNDT.HOUSE_CODE AND APPR.PR_NO = CNDT.PR_NO AND APPR.PR_SEQ = CNDT.PR_SEQ \n ");
    		sqlsb.append("       	   WHERE APPR.HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'                                                                                              \n ");
    		sqlsb.append("       		 AND GAPP.TYPE       = 'G'                                                                                                \n ");
    		sqlsb.append("       		 AND INEP.STATUS     = 'E'                                                                                                \n ");
    		sqlsb.append("       	  )GW                                                                                                                         \n ");    			    
    		
    		sqlsb.append(" 	     WHERE  NVL(DEL_FLAG, 'N') = 'N'  									\n ");
    		sqlsb.append("       AND ((A.CT_FLAG='CD' AND A.SIGN_STATUS='E') or A.CT_FLAG='OF')		\n ");
    		sqlsb.append("       AND    A.EXEC_NO = CNHD.EXEC_NO 									\n ");
    		sqlsb.append("       AND    A.CONT_NO = SCTP.DOC_NO(+) 									\n ");
    		sqlsb.append("       AND    A.CONT_GL_SEQ  = SCTP.DOC_SEQ(+) 							\n ");
    		sqlsb.append("       AND    A.CONT_NO = SCTP.DOC_NO(+) 									\n ");
    		sqlsb.append("       AND    A.EXEC_NO = GW.EXEC_NO(+) 									\n ");
    		    		
    		if(info.getSession("USER_TYPE").equals("S")) { 
    			sqlsb.append(sm.addSelectString(" AND A.SELLER_CODE = ?                        				\n "));	sm.addStringParameter(info.getSession("COMPANY_CODE"));
    		} else {
    			if (!sign_person_id.equals(""))
    			{
    				sqlsb.append(sm.addSelectString(" AND A.SIGN_PERSON_ID = ?                                    \n "));	sm.addStringParameter(sign_person_id); //sm.addStringParameter(info.getSession("ID"));
    			}
    			sqlsb.append(sm.addSelectString("     AND A.SELLER_CODE    = ?                                	\n ")); sm.addStringParameter(seller_code);
    		}
    		
    		if (!from_date1.equals("") && !to_date1.equals("")){
    			sqlsb.append(sm.addSelectString("     AND A.CONT_TO >=     ?                                   \n ")); sm.addStringParameter(from_date1);
        		sqlsb.append(sm.addSelectString("     AND A.CONT_TO <=     ?                                    \n ")); sm.addStringParameter(to_date1);        		
    		}
    		
    		if (!from_date2.equals("") && !to_date2.equals("")){
    			sqlsb.append(sm.addSelectString("     AND A.CONT_DATE >=     ?                                   \n ")); sm.addStringParameter(from_date2);
        		sqlsb.append(sm.addSelectString("     AND A.CONT_DATE <=     ?                                    \n ")); sm.addStringParameter(to_date2);        		        	
    		}
    		
    		sqlsb.append(sm.addSelectString("     AND A.CONT_NO        = ?                                	\n ")); sm.addStringParameter(cont_no);
    		sqlsb.append(sm.addSelectString("     AND A.CT_FLAG        = ?                               	 	\n ")); sm.addStringParameter(status);
    		sqlsb.append(sm.addSelectString("     AND A.ELE_CONT_FLAG  = ?                                    \n ")); sm.addStringParameter(ele_cont_flag);
    		sqlsb.append(sm.addSelectString("     AND A.SUBJECT LIKE '%' || ? || '%'                          \n ")); sm.addStringParameter(subject);
    		sqlsb.append(sm.addSelectString("     AND A.SIGN_PERSON_ID = ?                                    \n ")); sm.addStringParameter(sign_person_id);
    		sqlsb.append(sm.addSelectString("     AND SG_LEV1 		 = ?                                    \n ")); sm.addStringParameter(sg_type1);
    		sqlsb.append(sm.addSelectString("     AND SG_LEV2 		 = ?                                    \n ")); sm.addStringParameter(sg_type2);
    		sqlsb.append(sm.addSelectString("     AND SG_LEV3        = ?                                    \n ")); sm.addStringParameter(sg_type3);
    		
    		if (!gw_cod_no.equals("")){
    			sqlsb.append(sm.addSelectString("       	    AND GW.GW_COD_NO  LIKE '%' || ? || '%'             \n "));sm.addStringParameter(gw_cod_no);     			
    		}
    		if (!gw_title.equals("")){
    			sqlsb.append(sm.addSelectString("       	    AND GW.GW_TITLE  LIKE '%' || ? || '%'              \n "));sm.addStringParameter(gw_title);     			
    		}
    		    
    		
    		sqlsb.append("            ORDER BY CONT_NO DESC           									    \n ");    		
    		setValue(sm.doSelect(sqlsb.toString()));
    		
    	} catch (Exception e) {
    		setStatus(0);
    		setFlag(false);
    		setMessage(e.getMessage());
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    	}
    	
    	return getSepoaOut();
    }
    
    public SepoaOut getContractInfoList(String from_date, String to_date, String seller_code, String cont_no, String status, String ele_cont_flag, String sg_type1, String sg_type2, String sg_type3) {
    	
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sqlsb = new StringBuffer();
    	
    	try {
    		setStatus(1);
    		setFlag(true);
    		
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		
    		sm.removeAllValue();
    		sqlsb.delete(0, sqlsb.length());
			sqlsb.append("	SELECT DISTINCT                                                                    \n");
			sqlsb.append("		 GL.CONT_NO                                                                    \n");
			sqlsb.append("		,GL.CONT_GL_SEQ                                                                \n");
			sqlsb.append("      ,GETCODETEXT1('M811', GL.CONT_GUBUN, 'KO') AS CONT_GUBUN                       \n");
			sqlsb.append("		,GETCODETEXT2('M800', GL.CONT_TYPE, 'KO') AS CONT_TYPE                         \n");
			sqlsb.append("		,GETCODETEXT2('M806', GL.ELE_CONT_FLAG, 'KO') AS ELE_CONT_FLAG															   \n");
			sqlsb.append("		,GL.SUBJECT                                                                    \n");
			sqlsb.append("		,GETCOMPANYNAMELOC(GL.SELLER_CODE, 'S') AS SELLER_CODE                         \n");
			sqlsb.append("		,(SELECT substr(IRS_NO,1,3)||'-'||substr(IRS_NO,4,2)||'-'||substr(IRS_NO,6,5) FROM ICOMVNGL WHERE HOUSE_CODE = '100' AND VENDOR_CODE = GL.SELLER_CODE) AS IRS_NO  \n");
			sqlsb.append("		,GL.CONT_ADD_DATE                                                              \n");
			sqlsb.append("		,getDateFormat(GL.CONT_FROM) ||' ~ ' || getDateFormat(GL.CONT_TO) AS CONT_DATE \n");
			sqlsb.append("		,GL.CONT_AMT                                                                   \n");
			sqlsb.append("		,GETCODETEXT2('M809', GL.CONT_PROCESS_FLAG, 'KO') AS CONT_PROCESS_FLAG         \n");
			sqlsb.append("		,GL.SIGN_PERSON_NAME AS CTRL_CODE_NAME       									\n");
			sqlsb.append("		,TEXT_NUMBER                                                                   \n");
			sqlsb.append("		,LN.ACCOUNTS_COURSES_LOC                                                       \n");
			sqlsb.append("		,'' AS CONFIRM_USER_NAME 						\n");
			sqlsb.append("		,CONT_INS_NO                                                                   \n");
			sqlsb.append("		,FAULT_INS_NO                                                                   \n");
			sqlsb.append("		,GETCODETEXT1('M225', GL.CONT_INS_VN, 'KO') AS CONT_INS_VN                       \n");
			sqlsb.append("		,BD_NO                                                                         \n");
			sqlsb.append(" 		,CONT_FILE_NO		               									           \n ");
			sqlsb.append(" 		,FAULT_FILE_NO		               									           \n ");
			sqlsb.append(" 		,CONT_FORM_NO		               											   \n ");
			sqlsb.append(" 		,CT_FLAG		               												   \n ");
			sqlsb.append(" 		,GETCODETEXT2('M286', CT_FLAG, 'KO') AS CT_NAME		               				\n ");
			sqlsb.append(" 		,getsgname2(SG_LEV1) AS	SG_LEV1													\n ");
			sqlsb.append(" 		,getsgname2(SG_LEV2) AS SG_LEV2													\n ");
			sqlsb.append(" 		,getsgname2(SG_LEV3) AS SG_LEV3													\n ");			
			sqlsb.append("	FROM SCPGL GL, SCPLN LN                                                            \n");
			sqlsb.append("	WHERE GL.CONT_NO = LN.CONT_NO                                                      \n");
			sqlsb.append("	  AND NVL(GL.DEL_FLAG, 'N') = 'N'                                                  \n");
			sqlsb.append("	  AND NVL(LN.DEL_FLAG, 'N') = 'N'                                                  \n");
			sqlsb.append(sm.addSelectString("    AND GL.CTRL_DEMAND_DEPT = ?                      			   \n"));
			sm.addStringParameter(info.getSession("DEPARTMENT"));
			sqlsb.append(sm.addSelectString("    AND GL.CONT_ADD_DATE BETWEEN ?                        			   \n"));
			sm.addStringParameter(from_date);
			sqlsb.append(sm.addSelectString("    AND ?                                          			   \n"));
			sm.addStringParameter(to_date);
			sqlsb.append(sm.addSelectString("    AND GL.SELLER_CODE = ?                                \n"));
			sm.addStringParameter(seller_code);
			sqlsb.append(sm.addSelectString("    AND GL.CONT_NO  = ?                               	\n"));
			sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString("    AND GL.CT_FLAG   = ?                             	 	\n"));
			sm.addStringParameter(status);
			sqlsb.append(sm.addSelectString("    AND GL.ELE_CONT_FLAG   = ?                            \n"));
			sm.addStringParameter(ele_cont_flag);
			sqlsb.append(sm.addSelectString("     AND SG_LEV1 		 = ?                                    \n ")); sm.addStringParameter(sg_type1);
			sqlsb.append(sm.addSelectString("     AND SG_LEV2 		 = ?                                    \n ")); sm.addStringParameter(sg_type2);
			sqlsb.append(sm.addSelectString("     AND SG_LEV3        = ?                                    \n ")); sm.addStringParameter(sg_type3);			
			
			
    		sqlsb.append("  ORDER BY CONT_NO DESC          													   \n");
    		setValue(sm.doSelect(sqlsb.toString()));
    		
    	} catch (Exception e) {
    		setStatus(0);
    		setFlag(false);
    		setMessage(e.getMessage());
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    	}
    	
    	return getSepoaOut();
    }

	public SepoaOut getContractSelect(String cont_no) {

		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("	SELECT DISTINCT                       \n");
			sqlsb.append("		   CONT_FORM_NO                   \n");
			sqlsb.append("		  ,DONT_FORM_NO                   \n");
			sqlsb.append("		  ,WR_SUBJECT                     \n");
			sqlsb.append("		  ,DONT_CLIC                      \n");
			sqlsb.append("		  ,MATERIAL_FLAG                  \n");
			sqlsb.append("		  ,DONT_FORM_NAME                 \n");
			sqlsb.append("		  ,GETUSERNAME(ADD_USER_ID, '"+ info.getSession("LANGUAGE") +"') AS CHANGE_USER_ID   \n");
			sqlsb.append("	FROM  SCPAT                           \n");
			sqlsb.append("	WHERE NVL(DEL_FLAG, 'N') = 'N'        \n");
			sqlsb.append(sm.addSelectString(" AND CONT_NO = ?     \n"));
			sm.addStringParameter(cont_no);
			sqlsb.append("	ORDER BY CONT_FORM_NO, DONT_FORM_NO  \n");
			setValue(sm.doSelect(sqlsb.toString()));
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("  SELECT                                \n");
			sqlsb.append("         CONTENT                        \n");
			sqlsb.append("  FROM  SCPMT                           \n");
			sqlsb.append("  WHERE NVL(DEL_FLAG, 'N') = 'N'        \n");
			sqlsb.append(sm.addSelectString(" AND CONT_NO = ?     \n"));
			sm.addStringParameter(cont_no);
			sqlsb.append("  ORDER BY SEQ_SEQ                      \n");
			setValue(sm.doSelect(sqlsb.toString()));
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	public SepoaOut getDetailPopUp(String cont_no, String cont_form_no, String dont_form_no) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("   SELECT                                                            \n");
			sqlsb.append("   	 CONT_FORM_NO                                                  \n");
			sqlsb.append("   	,DONT_FORM_NO                                                  \n");
			sqlsb.append("   	,DONT_FORM_NAME                                                \n");
			sqlsb.append("   	,DONT_FORM_DESC                                                \n");
			sqlsb.append("   	,GETCODETEXT2('M801', SIGN_FLAG, 'KO')     AS SIGN_FLAG        \n");
			sqlsb.append("   	,GETCODETEXT2('M802', DONT_CLIC, 'KO')     AS DONT_CLIC        \n");
			sqlsb.append("   	,GETCODETEXT2('M803', WR_SUBJECT, 'KO')    AS WR_SUBJECT       \n");
			sqlsb.append("   	,GETCODETEXT2('M804', MATERIAL_FLAG, 'KO') AS MATERIAL_FLAG    \n");
			sqlsb.append("   	,DEL_FLAG                                                      \n");
			sqlsb.append("   FROM SCPAT                                                        \n");
			sqlsb.append("   WHERE NVL(DEL_FLAG, 'N') = 'N'                                    \n");
			sqlsb.append(sm.addSelectString("     AND CONT_NO = ?                              \n"));
			sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString("     AND CONT_FORM_NO = ?                         \n"));
			sm.addStringParameter(cont_form_no);
			sqlsb.append(sm.addSelectString("     AND DONT_FORM_NO = ?                         \n"));
			sm.addStringParameter(dont_form_no);
			setValue(sm.doSelect(sqlsb.toString()));
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	public SepoaOut getContractDetailPopUp(String cont_no, String cont_form_no, String dont_form_no) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("   SELECT                                                            \n");
			sqlsb.append("   	 CONTENT                                                       \n");
			sqlsb.append("   FROM SCPAT                                                        \n");
			sqlsb.append("   WHERE NVL(DEL_FLAG, 'N') = 'N'                                    \n");
			sqlsb.append(sm.addSelectString("     AND CONT_NO = ?                              \n"));
			sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString("     AND CONT_FORM_NO = ?                         \n"));
			sm.addStringParameter(cont_form_no);
			sqlsb.append(sm.addSelectString("     AND DONT_FORM_NO = ?                         \n"));
			sm.addStringParameter(dont_form_no);
			sqlsb.append("   ORDER BY SEQ_SEQ                                                  \n");
			setValue(sm.doSelect(sqlsb.toString()));
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	public SepoaOut getContractFormSelect(String cont_no) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			
			sqlsb.append("    SELECT DISTINCT                       \n");
			sqlsb.append("    	 CONT_FORM_NO                       \n");
			sqlsb.append("    	,DONT_FORM_NO                       \n");
			sqlsb.append("    	,DONT_FORM_NAME                     \n");
			sqlsb.append("    FROM SCPAT                            \n");
			sqlsb.append("    WHERE NVL(DEL_FLAG, 'N') = 'N'        \n");
			sqlsb.append(sm.addSelectString(" AND CONT_NO = ?		\n"));
			sm.addStringParameter(cont_no);
			sqlsb.append("    ORDER BY DONT_FORM_NO                 \n");
			
			setValue(sm.doSelect(sqlsb.toString()));
			
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			
			sqlsb.append("		SELECT CONTENT					\n");
			sqlsb.append("		FROM SCPMT						\n");
			sqlsb.append("		WHERE NVL(DEL_FLAG, 'N') = 'N'	\n");
			sqlsb.append(sm.addSelectString(" AND CONT_NO = ?	\n"));
			sm.addStringParameter(cont_no);
			sqlsb.append("		ORDER BY SEQ_SEQ				\n");
			setValue(sm.doSelect(sqlsb.toString()));
			

		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}

	public SepoaOut getDocumentSelect(String cont_no, String cont_form_no, String dont_form_no) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			
			sqlsb.append("		SELECT                      \n");
			sqlsb.append("			 CONT_FORM_NO           \n");
			sqlsb.append("			,DONT_FORM_NO           \n");
			sqlsb.append("			,DONT_FORM_NAME         \n");
			sqlsb.append("			,DONT_FORM_DESC         \n");
			sqlsb.append("			,SIGN_FLAG              \n");
			sqlsb.append("			,DONT_CLIC              \n");
			sqlsb.append("			,WR_SUBJECT             \n");
			sqlsb.append("			,MATERIAL_FLAG          \n");
			sqlsb.append("			,ADD_USER_ID            \n");
			sqlsb.append("			,ADD_DATE               \n");
			sqlsb.append("			,ADD_TIME               \n");
			sqlsb.append("			,CHANGE_USER_ID         \n");
			sqlsb.append("			,CHANGE_DATE            \n");
			sqlsb.append("			,CHANGE_TIME            \n");
			sqlsb.append("			,DEL_FLAG               \n");
			sqlsb.append("		FROM SCPAT                  \n");
			sqlsb.append("		WHERE NVL(DEL_FLAG, 'N') = 'N'                \n");
			sqlsb.append(sm.addSelectString("		  AND CONT_NO = ?         \n"));
			sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString("		  AND CONT_FORM_NO = ?    \n"));
			sm.addStringParameter(cont_form_no);
			sqlsb.append(sm.addSelectString("		  AND DONT_FORM_NO = ?    \n"));
			sm.addStringParameter(dont_form_no);
			
			setValue(sm.doSelect(sqlsb.toString()));
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			
			sqlsb.append("		SELECT CONTENT					\n");
			sqlsb.append("		FROM SCPAT						\n");
			sqlsb.append("		WHERE NVL(DEL_FLAG, 'N') = 'N'	\n");
			sqlsb.append(sm.addSelectString(" AND CONT_NO  = ?	\n"));
			sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString(" AND CONT_FORM_NO = ?	\n"));
			sm.addStringParameter(cont_form_no);
			sqlsb.append(sm.addSelectString(" AND DONT_FORM_NO = ?	\n"));
			sm.addStringParameter(dont_form_no);
			sqlsb.append("		ORDER BY SEQ_SEQ				\n");
			setValue(sm.doSelect(sqlsb.toString()));
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}

	public SepoaOut getContractDetailPopUpUpdate(String cont_no, String cont_form_no, String dont_form_no) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("   SELECT                                                            \n");
			sqlsb.append("   	 CONTENT                                                       \n");
			sqlsb.append("   FROM SCPAT                                                        \n");
			sqlsb.append("   WHERE NVL(DEL_FLAG, 'N') = 'N'                                    \n");
			sqlsb.append(sm.addSelectString("     AND CONT_NO = ?                              \n"));
			sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString("     AND CONT_FORM_NO = ?                         \n"));
			sm.addStringParameter(cont_form_no);
			sqlsb.append(sm.addSelectString("     AND DONT_FORM_NO = ?                         \n"));
			sm.addStringParameter(dont_form_no);
			sqlsb.append("   ORDER BY SEQ_SEQ                                                  \n");
			setValue(sm.doSelect(sqlsb.toString()));
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	public SepoaOut getContractFormList(String cont_no) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			
			sqlsb.append("		SELECT CONTENT					\n");
			sqlsb.append("		FROM SCPMT						\n");
			sqlsb.append("		WHERE NVL(DEL_FLAG, 'N') = 'N'	\n");
			sqlsb.append(sm.addSelectString(" AND CONT_NO = ?	\n"));
			sm.addStringParameter(cont_no);
			sqlsb.append("		ORDER BY SEQ_SEQ				\n");
			setValue(sm.doSelect(sqlsb.toString()));
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	public SepoaOut getContractFormUpdate(String cont_no, String cont_form_no, String cont_content) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
			
        	ps.removeAllValue();
	        sqlsb.delete(0,sqlsb.length());
			sqlsb.append("		DELETE FROM SCPMT			\n");
			sqlsb.append("		WHERE CONT_NO = ?			\n");ps.addNumberParameter(cont_no);
			ps.doInsert(sqlsb.toString());
			
	        Vector v_cut_content = getSplitString(cont_content, 2000);

	        for(int i = 0; i < v_cut_content.size(); i++){

	        	ps.removeAllValue();
		        sqlsb.delete(0,sqlsb.length());
		        sqlsb.append("	INSERT INTO SCPMT (			\n");
		        sqlsb.append("		 CONT_NO				\n");
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
		        sqlsb.append("		 ?						\n");ps.addStringParameter(cont_form_no);
		        sqlsb.append("		,TO_CHAR(?, '000000')	\n");ps.addStringParameter((i+1)+"");
		        sqlsb.append("		,?						\n");ps.addStringParameter((String)v_cut_content.elementAt(i));
		        sqlsb.append("		,?						\n");ps.addStringParameter(info.getSession("ID"));
		        sqlsb.append("		,?						\n");ps.addStringParameter(SepoaDate.getShortDateString());
		        sqlsb.append("		,?						\n");ps.addStringParameter(SepoaDate.getShortTimeString());
		        sqlsb.append("		,?						\n");ps.addStringParameter(info.getSession("ID"));
		        sqlsb.append("		,?						\n");ps.addStringParameter(SepoaDate.getShortDateString());
		        sqlsb.append("		,?						\n");ps.addStringParameter(SepoaDate.getShortTimeString());
		        sqlsb.append("		,?						\n");ps.addStringParameter("N");
		        sqlsb.append("	)							\n");
		        ps.doInsert(sqlsb.toString());
	        } //end for
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	// 보증증권번호등록
	public SepoaOut getContractSave(String[][] bean_args) { 
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			


			for (int i = 0; i < bean_args.length; i++)
			{
				String CONT_INS_VN   = bean_args[i][0];  //계약이행보증증권회사
				String CONT_INS_NO   = bean_args[i][1];  //계약이행보증증권번호
				String FAULT_INS_NO  = bean_args[i][2]; //하자이행보증증권번호
				String CONT_NO       = bean_args[i][3]; //계약번호
				String CONT_FILE_NO  = bean_args[i][4]; //계약이행보증증권파일번호
				String FAULT_FILE_NO = bean_args[i][5]; //하자이행보증증권파일번호
				String CONT_GL_SEQ   = bean_args[i][6];
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" update scpgl set        \n ");
				sb.append(" 	CONT_INS_VN    = ?, \n "); sm.addStringParameter(CONT_INS_VN);
				sb.append(" 	CONT_INS_NO    = ?, \n "); sm.addStringParameter(CONT_INS_NO);
				sb.append(" 	FAULT_INS_NO   = ?, \n "); sm.addStringParameter(FAULT_INS_NO);
				sb.append(" 	CONT_FILE_NO   = ?, \n "); sm.addStringParameter(CONT_FILE_NO);
				sb.append(" 	FAULT_FILE_NO  = ?  \n "); sm.addStringParameter(FAULT_FILE_NO);
				sb.append(" where CONT_NO      = ?  \n "); sm.addStringParameter(CONT_NO);
				sb.append(" AND   CONT_GL_SEQ  = ?  \n "); sm.addStringParameter(CONT_GL_SEQ);
				
				sm.doUpdate(sb.toString());
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

	
	// 계약폐기
	public SepoaOut setDrop(String[][] bean_args , String ct_flag) { 
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for (int i = 0; i < bean_args.length; i++)
			{
				String CONT_NO       = bean_args[i][0]; //계약번호
				String CONT_GL_SEQ   = bean_args[i][1];
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" UPDATE SCPGL SET                 \n ");
				sb.append(" 	         CT_FLAG        = ?  \n "); sm.addStringParameter(ct_flag);
				sb.append("       WHERE  CONT_NO        = ?  \n "); sm.addStringParameter(CONT_NO);
				sb.append("       AND    CONT_GL_SEQ    = ?  \n "); sm.addStringParameter(CONT_GL_SEQ);
				
				sm.doUpdate(sb.toString());
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

	// 계약폐기
	public SepoaOut setDelete(String[][] bean_args , String ct_flag) { 
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for (int i = 0; i < bean_args.length; i++)
			{
				String CONT_NO       = bean_args[i][0]; //계약번호
				String CONT_GL_SEQ   = bean_args[i][1];
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" UPDATE SCPGL SET                 \n ");
				sb.append(" 	         CT_FLAG        = ?  \n "); sm.addStringParameter(ct_flag);
				sb.append("       WHERE  CONT_NO        = ?  \n "); sm.addStringParameter(CONT_NO);
				sb.append("       AND    CONT_GL_SEQ    = ?  \n "); sm.addStringParameter(CONT_GL_SEQ);
				
				sm.doUpdate(sb.toString());
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
	
public SepoaOut getContractDetailList(String from_date, String to_date, String seller_code, String cont_no, String status, String ele_cont_flag, String sign_person_id, String subject, String view, String sg_type1, String sg_type2, String sg_type3) {
    	
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sqlsb = new StringBuffer();
    	String COMPANY_CODE = info.getSession("COMPANY_CODE");
    	String USER_TYPE = info.getSession("USER_TYPE");
    	
    	try {
    		setStatus(1);
    		setFlag(true);
    		
    		if(USER_TYPE.equals("S")) {
    			seller_code = COMPANY_CODE;
    		}
    		
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		    		
    		sm.removeAllValue();
    		sqlsb.delete(0, sqlsb.length());
    		sqlsb.append("SELECT                         			                                                                                                                \n ");
    		sqlsb.append(" 		  ( SELECT DISTINCT SG_NAME FROM SSGGL WHERE SG_REFITEM = T1.SG_LEV1) AS SG_LEV1								                              		\n ");
    		sqlsb.append(" 		 ,( SELECT DISTINCT SG_NAME FROM SSGGL WHERE SG_REFITEM = T1.SG_LEV2) AS SG_LEV2								                              		\n ");
    		sqlsb.append(" 		 ,( SELECT DISTINCT SG_NAME FROM SSGGL WHERE SG_REFITEM = T1.SG_LEV3) AS SG_LEV3                                                             		\n ");
    		sqlsb.append(" 		 ,(SELECT TEXT1 FROM SCODE WHERE TYPE = 'M809' AND USE_FLAG = 'Y' AND DEL_FLAG = 'N' AND CODE =  T1.CONT_PROCESS_FLAG) CONT_PROCESS_FLAG_TEXT		\n ");
    		sqlsb.append(" 		 ,T1.SIGN_PERSON_NAME     								                                                                                      		\n ");
    		sqlsb.append(" 		 ,T1.SIGN_PERSON_ID         									                                                                              		\n ");
    		sqlsb.append(" 		 ,T1.CONT_NO               										                                                                          		    \n ");
    		sqlsb.append(" 		 ,T1.CONT_GL_SEQ                                                                                                                             		\n ");
    		sqlsb.append(" 		 ,CONVERT_DATE(T1.CONT_DATE) AS CONT_DATE                                                                                                    		\n ");
    		sqlsb.append(" 		 ,CONVERT_DATE(T1.CONT_FROM) AS CONT_FROM                                                                                                    	    \n ");
    		sqlsb.append(" 		 ,CONVERT_DATE(T1.CONT_TO)   AS CONT_TO                                                                                                      		\n ");
    		sqlsb.append(" 		 ,T1.SUBJECT                                                                                                                                 		\n ");
    		sqlsb.append(" 		 ,DECODE(T1.ADD_TAX_FLAG,'Y',ROUND((T1.CONT_AMT/11)*10),T1.CONT_AMT) AS CONT_AMT1                 									          		\n ");
    		sqlsb.append(" 		 ,DECODE(T1.ADD_TAX_FLAG,'Y',ROUND(T1.CONT_AMT/11),NULL) AS CONT_AMT2                  									                  		    \n ");
    		sqlsb.append(" 		 ,T1.CONT_AMT                                                                                                                                		\n ");
    		sqlsb.append(" 		 ,(SELECT IRS_NO FROM ICOMVNGL WHERE VENDOR_CODE = T1.SELLER_CODE) AS IRS_NO                                                                 		\n ");
    		sqlsb.append(" 		 ,(SELECT COMPANY_REG_NO FROM ICOMVNGL WHERE VENDOR_CODE = T1.SELLER_CODE) AS COMPANY_REG_NO                                                 		\n ");
    		sqlsb.append(" 		 ,GETCOMPANYNAMELOC('000', T1.SELLER_CODE, 'S') AS SELLER_CODE_TEXT	                                                                      		    \n ");
    		sqlsb.append(" 		 ,T1.SELLER_CODE                                                                                                                               		\n ");
    		sqlsb.append(" 		 ,(CASE WHEN NVL(T1.REGISTER_DATE, 'N') = 'N' THEN T1.APP_DATE                                                                                      \n ");
    		sqlsb.append(" 		   ELSE ''                                                                                                                                          \n ");
    		sqlsb.append(" 		   END) AS GW_END_DATE                                                                                                                       	    \n ");
    		sqlsb.append(" 		 ,T1.GW_COD_NO                                                                                                                               		\n ");
    		sqlsb.append(" 		 ,T1.GW_TITLE                                                                                                                                	    \n ");
    		sqlsb.append(" 		 ,T1.DOC_LINK               	                                                                                                              	    \n ");
    		sqlsb.append(" 		 ,T2.EXCD                                                                                                                                    		\n ");
    		sqlsb.append(" 		 ,T2.PAY_NO                                                                                                                                  		\n ");
    		sqlsb.append(" 		 ,T2.PAY_DATE                                                                                                                                		\n ");
    		sqlsb.append(" 		 ,T2.PAY_AMT                                                                                                                                 		\n ");
    		sqlsb.append(" 		 ,T2.BANK_NAME                                                                                                                               		\n ");
    		sqlsb.append(" 		 ,T2.BANK_ACCT                                                                                                                               		\n ");    		
    		
    		sqlsb.append("FROM				    									                                                                                                \n ");
   
    		sqlsb.append("(SELECT  /*+ INDEX_DESC(A SCPGL_IDX02) */		                                                                                                                                                    \n ");
    		sqlsb.append(" 	     A.SG_LEV1                                                                                                                                                                                     	\n ");
    		sqlsb.append(" 		,A.SG_LEV2								                                                                                                                                                       	\n ");
    		sqlsb.append(" 		,A.SG_LEV3                                                                                                                                                                                     	\n ");
    		sqlsb.append(" 		,A.CONT_PROCESS_FLAG								                                                                                                                                           	\n ");
    		sqlsb.append(" 		,A.SIGN_PERSON_NAME		               								                                                                                                                           	\n ");
    		sqlsb.append(" 		,A.SIGN_PERSON_ID             									                                                                                                                               	\n ");
    		sqlsb.append(" 		,A.CONT_NO                										                                                                                                                               	\n ");
    		sqlsb.append(" 		,A.CONT_GL_SEQ                  									                                                                                                                           	\n ");
    		sqlsb.append(" 		,A.CONT_DATE                                                                                                                                                                                   	\n ");
    		sqlsb.append(" 		,A.CONT_FROM                                                                                                                                                                                   	\n ");
    		sqlsb.append(" 		,A.CONT_TO                                                                                                                                                                                     	\n ");
    		sqlsb.append(" 		,A.SUBJECT                    									                                                                                                                               		\n ");
    		sqlsb.append(" 		,A.ADD_TAX_FLAG           									                                                                                                                                   		\n ");
    		sqlsb.append(" 		,A.CONT_AMT                                                                                                                                                                                    		\n ");
    		sqlsb.append(" 	    ,A.SELLER_CODE                                                                                                                                                                                 	\n ");
    		sqlsb.append(" 	    ,GW.REGISTER_DATE                                                                                                                                                                                            		\n ");
    		sqlsb.append(" 	    ,GW.APP_DATE													  			 		                                                                                                           	\n ");
    		sqlsb.append(" 	    ,GW.GW_COD_NO                                                                                                                                                                                  	\n ");
    		sqlsb.append(" 	    ,GW.GW_TITLE                                                                                                                                                                                   		\n ");
    		sqlsb.append(" 	    ,GW.DOC_LINK                         	                                                                                                                                                       	\n ");
    		sqlsb.append(" 	FROM   SCPGL A, ICOYCNHD CNHD                    										                                                                                                           	\n ");
    		sqlsb.append(" 	     ,(SELECT DOC_NO, DOC_SEQ, SIGN_USER_ID FROM ICOMSCTP AA WHERE SIGN_PATH_SEQ = (SELECT MAX(SIGN_PATH_SEQ) FROM ICOMSCTP BB WHERE AA.DOC_NO = BB.DOC_NO AND AA.DOC_SEQ = BB.DOC_SEQ) )SCTP      		\n ");
    		sqlsb.append(" 	     ,(SELECT /*+ INDEX_DESC(INEP SINEP0022_2_IDX01,CNDT ICOYCNDT_IDX01)*/ DISTINCT CNDT.EXEC_NO, INEP.GW_COD_NO, INEP.GW_TITLE, INEP.DOC_LINK,INEP.APP_DATE,INEP.REGISTER_DATE                    		\n ");
    		sqlsb.append(" 	         FROM  GWAPPPR  APPR                                                                                                                                                                       	\n ");
    		sqlsb.append(" 	        INNER JOIN GWAPP       GAPP ON APPR.HOUSE_CODE = GAPP.HOUSE_CODE AND APPR.INF_NO = GAPP.INF_NO                                                                                             	\n ");
    		sqlsb.append(" 	        INNER JOIN SINEP0022_2 INEP ON GAPP.HOUSE_CODE = INEP.HOUSE_CODE AND GAPP.INF_NO = INEP.DOC_NO                                                                                             	\n ");
    		sqlsb.append(" 	        INNER JOIN ICOYCNDT    CNDT ON APPR.HOUSE_CODE = CNDT.HOUSE_CODE AND APPR.PR_NO = CNDT.PR_NO AND APPR.PR_SEQ = CNDT.PR_SEQ                                                                 	\n ");
    		sqlsb.append(" 	        WHERE APPR.HOUSE_CODE = '000'                                                                                                                                                              	\n ");
    		sqlsb.append(" 	          AND GAPP.TYPE       = 'G'                                                                                                                                                                	\n ");
    		sqlsb.append(" 	          AND INEP.STATUS     = 'E'                                                                                                                                                                	\n ");
    		sqlsb.append(" 	       )GW                                                                                                                                                                                         	\n ");
    		sqlsb.append(" 	WHERE  NVL(A.DEL_FLAG, 'N') = 'N'  									                                                                                                                               	\n ");
    		sqlsb.append(" 	AND    ((A.CT_FLAG='CD' AND A.SIGN_STATUS='E') or A.CT_FLAG='OF')	                                                                                                                               	\n ");
    		sqlsb.append(" 	AND    '000' = CNHD.HOUSE_CODE	                                                                                                                                                                   	\n ");
    		sqlsb.append(" 	AND    A.EXEC_NO = CNHD.EXEC_NO 									                                                                                                                               	\n ");
    		sqlsb.append(" 	AND    A.CONT_NO = SCTP.DOC_NO(+) 									                                                                                                                               	\n ");
    		sqlsb.append(" 	AND    A.CONT_GL_SEQ  = SCTP.DOC_SEQ(+) 							                                                                                                                               	\n ");
    		sqlsb.append(" 	AND    A.EXEC_NO = GW.EXEC_NO(+)                                                                                                                                                                   	\n ");
    		sqlsb.append(sm.addSelectString("     AND    A.CONT_DATE >=?                                   \n ")); sm.addStringParameter(from_date);     		    		 
    		sqlsb.append(sm.addSelectString("     AND    A.CONT_DATE <= ?                                  \n ")); sm.addStringParameter(to_date);      		
    		if (!sign_person_id.equals(""))
			{
				sqlsb.append(sm.addSelectString(" AND A.SIGN_PERSON_ID = ?                                  \n "));	sm.addStringParameter(sign_person_id); 
			}
			sqlsb.append(sm.addSelectString("     AND A.SELLER_CODE    = ?                                	\n ")); sm.addStringParameter(seller_code);
			sqlsb.append(sm.addSelectString("     AND A.CONT_NO        = ?                                	\n ")); sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString("     AND A.ELE_CONT_FLAG  = ?                                  \n ")); sm.addStringParameter(ele_cont_flag);    		
			sqlsb.append(sm.addSelectString("     AND A.SUBJECT LIKE '%' || ? || '%'                        \n ")); sm.addStringParameter(subject);			
			sqlsb.append(sm.addSelectString("     AND A.SIGN_PERSON_ID = ?                                  \n ")); sm.addStringParameter(sign_person_id);
    		sqlsb.append(sm.addSelectString("     AND A.SG_LEV1 		 = ?                                \n ")); sm.addStringParameter(sg_type1);
    		sqlsb.append(sm.addSelectString("     AND A.SG_LEV2 		 = ?                                \n ")); sm.addStringParameter(sg_type2);
    		sqlsb.append(sm.addSelectString("     AND A.SG_LEV3        = ?                                  \n ")); sm.addStringParameter(sg_type3);    		
    		sqlsb.append("  ) T1,                                                                                                                                                                                    		\n ");
    		
    		sqlsb.append("  (SELECT  F.CONT_NO                                                                              \n ");
    		sqlsb.append("   ,  F.CONT_GL_SEQ                                                                                        \n ");
    		sqlsb.append("   ,  '자본예산' AS EXCD                                                                                       \n ");
    		sqlsb.append("   ,  'S' AS PAY_TYPE                                                                                      \n ");
    		sqlsb.append("   ,  A.PAY_SEND_NO AS PAY_NO                                                                              \n ");
    		sqlsb.append("   ,  CONVERT_DATE(A.CHANGE_DATE) AS PAY_DATE                                                              \n ");
    		sqlsb.append("   ,   A.PAY_AMT AS PAY_AMT                                                                                \n ");
    		sqlsb.append("   ,   A.VENDOR_CODE                                                                                       \n ");
    		sqlsb.append("   ,  GETVENDORNAME(A.HOUSE_CODE, A.VENDOR_CODE) AS VENDOR_NAME                                            \n ");
    		sqlsb.append("   ,   A.BANK_CODE                                                                                         \n ");
    		sqlsb.append("   ,  GETCODETEXT1('M349',A.BANK_CODE,'KO') AS BANK_NAME                                                   \n ");
    		sqlsb.append("   ,   A.BANK_ACCT                                                                                         \n ");
    		sqlsb.append("   ,  F.CONT_DATE                                                                                          \n ");
    		sqlsb.append("   FROM  SPY1GL A                                                                                          \n ");
    		sqlsb.append("   ,  SPY1LN B                                                                                             \n ");
    		sqlsb.append("   ,  ICOYTRDT C                                                                                           \n ");
    		sqlsb.append("   ,  ICOYTXHD C1                                                                                          \n ");
    		sqlsb.append("   ,  SALEEBILL C2                                                                                         \n ");
    		sqlsb.append("   ,  ICOYIVDT D                                                                                           \n ");
    		sqlsb.append("   ,  ICOYPODT E                                                                                           \n ");
    		sqlsb.append("   ,      ( SELECT CONT_NO,CONT_GL_SEQ,CONT_DATE,EXEC_NO                                                   \n ");
    		sqlsb.append("      FROM SCPGL                                                                                           \n ");
    		sqlsb.append("       WHERE (CONT_NO,CONT_GL_SEQ) IN (SELECT A.CONT_NO,MAX(A.CONT_GL_SEQ) FROM SCPGL A                    \n ");
    		sqlsb.append("                                                           GROUP BY A.COMPANY_CODE,A.CONT_NO) ) F          \n ");
    		sqlsb.append("   ,  ICOYPRDT G                                                                                           \n ");
    		sqlsb.append("   WHERE  A.STATUS_CD = '30'                                                                               \n ");
    		sqlsb.append("   AND  A.PAY_SEND_NO = B.PAY_SEND_NO                                                                      \n ");
    		sqlsb.append("   AND  B.TAX_NO = C.TAX_NO                                                                                \n ");
    		sqlsb.append("   AND  B.TAX_SEQ = C.TAX_SEQ                                                                              \n ");
    		sqlsb.append("   AND  C.TAX_NO = C1.TAX_NO                                                                               \n ");
    		sqlsb.append("   AND  C.TAX_NO = C2.RESSEQ                                                                               \n ");
    		sqlsb.append("   AND  C.INV_NO = D.INV_NO                                                                                \n ");
    		sqlsb.append("   AND  C.INV_SEQ = D.INV_SEQ                                                                              \n ");
    		sqlsb.append("   AND  D.PO_NO = E.PO_NO                                                                                  \n ");
    		sqlsb.append("   AND  D.PO_SEQ = E.PO_SEQ                                                                                \n ");
    		sqlsb.append("   AND  E.EXEC_NO = F.EXEC_NO(+)                                                                           \n ");
    		sqlsb.append("   AND  E.PR_NO = G.PR_NO                                                                                  \n ");
    		sqlsb.append("   AND  E.PR_SEQ = G.PR_SEQ                                                                                \n ");    		
    		sqlsb.append(sm.addSelectString("     AND    F.CONT_DATE >=?                                     \n ")); sm.addStringParameter(from_date);     		    		 
    		sqlsb.append(sm.addSelectString("     AND    F.CONT_DATE <= ?                                    \n ")); sm.addStringParameter(to_date);      		    		   
    		sqlsb.append("   UNION                                                                                                   \n ");
    		sqlsb.append("   SELECT                                                                                                  \n ");
    		sqlsb.append("      F.CONT_NO                                                                                            \n ");
    		sqlsb.append("   ,  F.CONT_GL_SEQ                                                                                        \n ");
    		sqlsb.append("   ,  GETCODETEXT1('M810',A.EXPENSECD,'KO') AS EXCD                                                        \n ");
    		sqlsb.append("   ,  'A' AS PAY_TYPE                                                                                      \n ");
    		sqlsb.append("   ,  A.PAY_ACT_NO AS PAY_NO                                                                               \n ");
    		sqlsb.append("   ,  CONVERT_DATE(A.ACT_DATE) AS PAY_DATE                                                                 \n ");
    		sqlsb.append("   ,   A.TOT_AMT AS PAY_AMT                                                                                \n ");
    		sqlsb.append("   ,   A.VENDOR_CODE                                                                                       \n ");
    		sqlsb.append("   ,  GETVENDORNAME(A.HOUSE_CODE, A.VENDOR_CODE) AS VENDOR_NAME                                            \n ");
    		sqlsb.append("   ,   A.BANK_CODE                                                                                         \n ");
    		sqlsb.append("   ,  GETCODETEXT1('M349',A.BANK_CODE,'KO') AS BANK_NAME                                                   \n ");
    		sqlsb.append("   ,   A.BANK_ACCT                                                                                         \n ");
    		sqlsb.append("   ,  F.CONT_DATE                                                                                          \n ");
    		sqlsb.append("   FROM  SPY2GL A                                                                                          \n ");
    		sqlsb.append("   ,  SPY2LN B                                                                                             \n ");
    		sqlsb.append("   ,  ICOYTRDT C                                                                                           \n ");
    		sqlsb.append("   ,  ICOYTXHD C1                                                                                          \n ");
    		sqlsb.append("   ,  SALEEBILL C2                                                                                         \n ");
    		sqlsb.append("   ,  ICOYIVDT D                                                                                           \n ");
    		sqlsb.append("   ,  ICOYPODT E                                                                                           \n ");
    		sqlsb.append("   ,      ( SELECT CONT_NO,CONT_GL_SEQ,CONT_DATE,EXEC_NO                                                   \n ");
    		sqlsb.append("      FROM SCPGL                                                                                           \n ");
    		sqlsb.append("       WHERE (CONT_NO,CONT_GL_SEQ) IN (SELECT A.CONT_NO,MAX(A.CONT_GL_SEQ) FROM SCPGL A                    \n ");
    		sqlsb.append("                                                           GROUP BY A.COMPANY_CODE,A.CONT_NO) ) F          \n ");
    		sqlsb.append("   ,  ICOYPRDT G                                                                                           \n ");
    		sqlsb.append("   WHERE  A.APP_STATUS_CD = 'F'                                                                            \n ");
    		sqlsb.append("   AND  A.PAY_ACT_NO = B.PAY_ACT_NO                                                                        \n ");
    		sqlsb.append("   AND  A.TAX_NO = C.TAX_NO                                                                                \n ");
    		sqlsb.append("   AND  B.PMKPMKCD = C.ITEM_NO                                                                             \n ");
    		sqlsb.append("   AND  B.CNT = C.ITEM_QTY                                                                                 \n ");
    		sqlsb.append("   AND  B.PAY_ACT_SEQ = C.PAY_SEQ                                                                          \n ");
    		sqlsb.append("   AND  C.TAX_NO = C1.TAX_NO                                                                               \n ");
    		sqlsb.append("   AND  C.TAX_NO = C2.RESSEQ                                                                               \n ");
    		sqlsb.append("   AND  C.INV_NO = D.INV_NO                                                                                \n ");
    		sqlsb.append("   AND  C.INV_SEQ = D.INV_SEQ                                                                              \n ");
    		sqlsb.append("   AND  D.PO_NO = E.PO_NO                                                                                  \n ");
    		sqlsb.append("   AND  D.PO_SEQ = E.PO_SEQ                                                                                \n ");
    		sqlsb.append("   AND  E.EXEC_NO = F.EXEC_NO(+)                                                                           \n ");
    		sqlsb.append("   AND  E.PR_NO = G.PR_NO                                                                                  \n ");
    		sqlsb.append("   AND  E.PR_SEQ = G.PR_SEQ                                                                                \n ");
    		sqlsb.append(sm.addSelectString("     AND    F.CONT_DATE >=?                                     \n ")); sm.addStringParameter(from_date);     		    		 
    		sqlsb.append(sm.addSelectString("     AND    F.CONT_DATE <= ?                                    \n ")); sm.addStringParameter(to_date);      		
    		sqlsb.append("  ) T2                                                                                                     \n ");
    		
    		sqlsb.append("  WHERE T1.CONT_NO = T2.CONT_NO(+)                                                                         \n ");
    		sqlsb.append(" 	AND T1.CONT_GL_SEQ = T2.CONT_GL_SEQ(+)      		                                                     \n ");
    		sqlsb.append(" 	ORDER BY T1.CONT_NO DESC, T1.CONT_GL_SEQ      		                                                     \n ");
    		    		
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