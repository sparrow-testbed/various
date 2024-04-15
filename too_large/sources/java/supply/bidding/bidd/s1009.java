package supply.bidding.bidd;
import java.util.Map;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaFormater;


public class s1009 extends SepoaService
{
	private String HOUSE_CODE       = info.getSession("HOUSE_CODE");
	private String company          = info.getSession("COMPANY_CODE");
	private String dept             = info.getSession("DEPARTMENT");
	private String dept_name        = info.getSession("DEPARTMENT_NAME_LOC");
	private String name_eng         = info.getSession("NAME_ENG");
	private String name_loc         = info.getSession("NAME_LOC");
	private String location         = info.getSession("LOCATION_CODE");
	private String location_name    = info.getSession("LOCATION_NAME");
	private String operating_code   = info.getSession("LOCATION_CODE");
	private String lang             = info.getSession("LANGUAGE");
	private String ctrl_code        = info.getSession("CTRL_CODE");

	private Message msg = new Message(info,"p10_pra");

	public s1009(String opt,SepoaInfo info) throws SepoaServiceException
	{
		super(opt,info);
		setVersion("1.0.0");
	}
	
	public SepoaOut getBidAvgRateList(Map<String, String> header)
  {
		try{
			String rtn = et_getBidAvgRateList(header);
	        setStatus(1);
	        setValue(rtn);

            rtn = et_getDBTime();
			setValue(rtn);

			setMessage(msg.getMessage("0000"));

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}
	
	private String et_getBidAvgRateList(Map<String, String> header) throws Exception
	{
        lang             = info.getSession("LANGUAGE");
        ctrl_code        = info.getSession("CTRL_CODE");

   		ConnectionContext ctx = getConnectionContext();
   		
		SepoaXmlParser sxp = null;
		SepoaSQLManager sm = null;

        String rtn = "";
//
//        StringBuffer sql = new StringBuffer();
//
//		sql.append("			 SELECT                                                                                          \n");
//        sql.append("			  A.ITEM_TYPE,                                                                                   \n");
//        sql.append("			 (SELECT TEXT2 FROM SCODE WHERE TYPE IN ('M150','M151') AND CODE = A.ITEM_TYPE) ITEM_NAME,          \n");
//        sql.append("			  A.FINAL_ESTM_PRICE_ENC,                                                                        \n");
//        sql.append("			  A.BID_AMT,                                                                                     \n");
//        sql.append("			  A.AVG_RATE                                                                                     \n");
//        sql.append("			 FROM                                                                                            \n");
//        sql.append("			 (                                                                                               \n");
//        sql.append("			 	SELECT A.ITEM_TYPE,                                                                          \n");
//        sql.append("			 	       ROUND(AVG(B.AMT),0) FINAL_ESTM_PRICE_ENC,                            \n");
//        sql.append("			 	       ROUND(AVG(C.BID_AMT),0) BID_AMT,                                                      \n");
//        sql.append("			 	       ROUND(AVG((C.BID_AMT/B.AMT)*100),2) AVG_RATE                         \n");
//        sql.append("			 	FROM                                                                                         \n");
//        sql.append("			 	(SELECT HOUSE_CODE,BID_NO,BID_COUNT,ITEM_TYPE,PR_NO                                          \n");
//        sql.append("			 	   FROM ICOYBDHD                                                                             \n");
//        sql.append("			 	  WHERE STATUS = 'R'                                                                         \n");
//        sql.append("		        AND BID_STATUS = 'SB'                                                                   	 \n");
//        sql.append("		        AND NVL(ITEM_TYPE, ' ') NOT IN ( 'D03','D05','D06','D08','D10','D11','D20')             	 \n");
//        sql.append("<OPT=S,S>		AND BID_TYPE = ?    </OPT>                                                                   \n");
//        sql.append("<OPT=S,S>		AND PROM_CRIT = ?  </OPT> )A,                                                               \n");
////        sql.append("			 	ICOYPRHD B,                                                                                  \n");
//        sql.append("			 	(SELECT BID_NO, BID_COUNT, SUM(PR_AMT) AS AMT FROM ICOYBDDT GROUP BY BID_NO, BID_COUNT) B,   \n");
//        sql.append("			 	(SELECT HOUSE_CODE,BID_NO,BID_COUNT,VOTE_COUNT,BID_AMT                                       \n");
//        sql.append("			 	   FROM ICOYBDVO                                                                             \n");
//        sql.append("			 	  WHERE STATUS = 'R'                                                                         \n");
//        sql.append("         		AND BID_STATUS = 'SB' )C,                                                                 \n");
//        sql.append("			 	(SELECT HOUSE_CODE,BID_NO,BID_COUNT,VOTE_COUNT,OPEN_DATE                                     \n");
//        sql.append("			 	   FROM ICOYBDPG                                                                             \n");
//        sql.append("			 	  WHERE STATUS = 'C'                                                                         \n");
//        sql.append("<OPT=S,S>		AND OPEN_DATE >= ?   </OPT>                                                              \n");
//        sql.append("<OPT=S,S>		AND OPEN_DATE <= ?   </OPT> )D                                                             \n");
//        sql.append("			 	WHERE A.BID_NO = B.BID_NO                                                            \n");
//        sql.append("			 	AND A.BID_COUNT = B.BID_COUNT                                                                      \n");
//        sql.append("			 	AND A.HOUSE_CODE = C.HOUSE_CODE                                                              \n");
//        sql.append("			 	AND A.BID_NO = C.BID_NO                                                                      \n");
//        sql.append("			 	AND A.BID_COUNT = C.BID_COUNT                                                                \n");
//        sql.append("			 	AND C.HOUSE_CODE = D.HOUSE_CODE                                                              \n");
//        sql.append("			 	AND C.BID_NO = D.BID_NO                                                                      \n");
//        sql.append("			 	AND C.BID_COUNT = D.BID_COUNT                                                                \n");
//        sql.append("			 	AND C.VOTE_COUNT = D.VOTE_COUNT                                                              \n");
//        sql.append("			 	GROUP BY A.ITEM_TYPE                                                                         \n");
//        sql.append("			 )A                                                                                              \n");
//        sql.append("			 ORDER BY A.ITEM_TYPE                                                                            \n");
        
		try
		{
			String[] item_type_arr = header.get("item_type").split(",") ;
			String item_type = "";
			
			if(item_type_arr != null && item_type_arr.length > 0){
				for(int i = 0 ; i < item_type_arr.length ; i++){
					if(i == 0){
						item_type = item_type_arr[i];						
					}else{
						item_type += "','" + item_type_arr[i];   						
					}
				}
			}
			header.put("item_type", item_type);
			
			Logger.info.println("item_type : " + item_type);
			
			sxp = new SepoaXmlParser(this, "et_getBidAvgRateList");
			sm = new SepoaSQLManager(userid,this,ctx,sxp);
			rtn = sm.doSelect(header);

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	public SepoaOut getBidAnnList(String[] data)
    {
		try{

			String rtn = et_getBidAnnList(data);

	        setStatus(1);
	        setValue(rtn);

            rtn = et_getDBTime();
			setValue(rtn);

			setMessage(msg.getMessage("0000"));

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}

		return getSepoaOut();
	}

	private String et_getBidAnnList(String[] data) throws Exception
	{

        lang             = info.getSession("LANGUAGE");
        ctrl_code        = info.getSession("CTRL_CODE");

        String house_code   = data[0];
        String from_date    = data[1];
        String to_date      = data[2];
        String ann_no       = data[3];
        String ann_item     = data[4];
        String cont_type2   = data[5];

   		ConnectionContext ctx = getConnectionContext();

        String rtn = "";

        StringBuffer sql = new StringBuffer();

        sql.append(" SELECT                                                                                                                                  \n");
        sql.append("           VW.ANN_NO           ,                                                                                                        \n");
        sql.append("           VW.ANN_ITEM         ,                                                                                                        \n");
        sql.append("           GETICOMCODE2(VW.HOUSE_CODE, 'M994', VW.CONT_TYPE1)||' ('||                                                                   \n");
        sql.append("           GETICOMCODE2(VW.HOUSE_CODE, 'M993', VW.CONT_TYPE2)||')' AS CONT_TYPE_TEXT,                                                   \n");
        sql.append("           TO_CHAR(TO_DATE(VW.BID_BEGIN_DATE||VW.BID_BEGIN_TIME, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI') AS APP_BEGIN_DATE_TIME ,     \n");
        sql.append("           TO_CHAR(TO_DATE(VW.BID_END_DATE||VW.BID_END_TIME, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI') AS APP_END_DATE_TIME ,           \n");
        sql.append("           DECODE(NVL(VW.ANNOUNCE_DATE, ''), '', 'N', 'Y')        AS ANNOUNCE,                                                              \n");
        sql.append("           VW.ATTACH_NO,                                                                                                                \n");
        sql.append("           (SELECT COUNT(*) FROM ICOMATCH                                                                                               \n");
        sql.append("             WHERE DOC_NO     = VW.ATTACH_NO) AS ATTACH_CNT,                                                                             \n");
        
        sql.append("           AT.ATTACH_NO AS ATTACH_NO2,                                                              \n");
        sql.append("           DECODE(NVL(AT.ATTACH_NO, ''), '', 'N', 'Y')        AS ATTACH_TXT,                                                              \n");
        
        sql.append("           CASE WHEN VW.BID_STATUS in ('SB','NB')                                                                                            \n");
        sql.append("                     THEN DECODE(VW.BID_STATUS, 'SB', '낙찰', 'NB','유찰', 'NE','협상중')                                                    \n");
        sql.append("                WHEN VW.BID_STATUS in ('AR','UR','CR')                                                                                       \n");
        sql.append("                     THEN '공고작성'                                                                                                         \n");
        sql.append("                WHEN VW.BID_STATUS in ('CC')                                                                                                 \n");
        sql.append("                     THEN '취소공고'                                                                                                         \n");
        sql.append("                WHEN VW.BID_STATUS in ('AC','UC')                                                                                            \n");
        sql.append("                     THEN (CASE WHEN TO_CHAR(SYSDATE, 'YYYYMMDD') < VW.ANN_DATE     THEN '공고대기'                                          \n");
        sql.append("                                WHEN VW.ANN_DATE  <= TO_CHAR(SYSDATE, 'YYYYMMDD')  AND SYSDATE < VW.APP_SDATE    THEN '공고중'               \n");
        sql.append("                                WHEN VW.APP_SDATE <= SYSDATE AND SYSDATE < VW.APP_EDATE                                                      \n");
        
        sql.append("                                     THEN '입찰중'                                                      \n");
        /*
        sql.append("                                     THEN ( CASE WHEN VW.CONT_TYPE2 = 'LP'                                                           \n");
        sql.append("                                                  THEN '입찰중' ELSE '평가서제출'  END )                                                     \n");
        */
        sql.append("                                ELSE '시간종료'                                                                                              \n");
        sql.append("                                END)                                                                                                         \n");
        sql.append("                WHEN VW.BID_STATUS in ('SR','QR')                                                                                            \n");
        sql.append("                     THEN '1단계 평가'                                                                                       \n");
        sql.append("                WHEN VW.BID_STATUS in ('RC','SC','QC')                                                                                       \n");
        sql.append("                     THEN (CASE WHEN SYSDATE < VW.BID_SDATE                                                                                  \n");
        sql.append("                                     THEN DECODE(VW.BID_STATUS, 'RC','마감', 'SC','입찰대기', 'QC','입찰대기')                               \n");
        sql.append("                                WHEN VW.BID_SDATE <= SYSDATE AND SYSDATE < VW.BID_EDATE                                                      \n");
        sql.append("                                     THEN '입찰중'                                                                                           \n");
        sql.append("                                ELSE '입찰대기'                                                                                              \n");
        sql.append("                                END)                                                                                                         \n");
        sql.append("                END  AS STATUS_TEXT,                                                                 \n");
        sql.append("            VW.BID_STATUS,                                                                                                               \n");
        sql.append("            VW.BID_NO,                                                                                                                   \n");
        sql.append("            VW.BID_COUNT,                                                                                                                \n");
        sql.append("            DECODE(NVL(AP.APP_DATE, ''), '', 'N', 'Y') AS STATUS,                                                                         \n");
        sql.append("            VW.X_DOC_SUBMIT_DATE X_DOC_SUBMIT_DATE,  VW.X_DOC_SUBMIT_TIME X_DOC_SUBMIT_TIME,                                                 \n");
        sql.append("            VW.ANN_VERSION                                                                                                                   \n");   //2010.10.27추가                
        
        sql.append("    FROM (SELECT  HD.BID_TYPE,    \n");
        sql.append("    			  HD.ANN_NO,          HD.ANN_ITEM,        HD.CONT_TYPE1,     HD.CONT_TYPE2,                          \n");
        sql.append("                  HD.APP_BEGIN_DATE,  HD.APP_BEGIN_TIME,  HD.APP_END_DATE,   HD.APP_END_TIME,                        \n");
        sql.append("                  HD.ANNOUNCE_DATE,   HD.ATTACH_NO,       HD.BID_STATUS,     HD.ANN_DATE,                            \n");
        sql.append("                  PG.BID_BEGIN_DATE,  PG.BID_BEGIN_TIME,  PG.BID_END_DATE,   PG.BID_END_TIME,                        \n");
        sql.append("                  HD.HOUSE_CODE,      HD.BID_NO,          HD.BID_COUNT,                                      \n");
        sql.append("                  TO_DATE(HD.APP_BEGIN_DATE||HD.APP_BEGIN_TIME, 'YYYYMMDDHH24MISS') AS APP_SDATE,                        \n");
        sql.append("                  TO_DATE(HD.APP_END_DATE||HD.APP_END_TIME, 'YYYYMMDDHH24MISS') AS APP_EDATE,                        \n");
        sql.append("                  TO_DATE(NVL(PG.BID_BEGIN_DATE||PG.BID_BEGIN_TIME, APP_BEGIN_DATE||HD.APP_BEGIN_TIME), 'YYYYMMDDHH24MISS') AS BID_SDATE,    \n");
        sql.append("                  TO_DATE(NVL(PG.BID_END_DATE||PG.BID_END_TIME, APP_END_DATE||HD.APP_END_TIME), 'YYYYMMDDHH24MISS') AS BID_EDATE,         \n");        
        sql.append("                  HD.X_DOC_SUBMIT_DATE,  HD.X_DOC_SUBMIT_TIME ,                                                 \n");                
        sql.append("    	            HD.ANN_VERSION                         \n");             
        sql.append("             FROM ICOYBDHD HD , ICOYBDPG PG                                               \n");    
        sql.append("             WHERE HD.BID_TYPE   = 'D'                                        \n");                
        sql.append("                 AND HD.HOUSE_CODE = PG.HOUSE_CODE(+)                                 \n");        
        sql.append("                 AND HD.BID_NO = PG.BID_NO(+)                                 \n");                
        sql.append("                 AND HD.BID_COUNT = PG.BID_COUNT(+)                               \n");            
        sql.append("             	 AND HD.STATUS IN ('C' ,'R')                                    \n");              
//        sql.append("             FROM ICOYBDHD HD LEFT OUTER JOIN ICOYBDPG PG                                            \n");
//        sql.append("              ON HD.BID_TYPE   = 'D'                                                     \n");
//        sql.append("                 AND HD.HOUSE_CODE = PG.HOUSE_CODE                                               \n");
//        sql.append("                 AND HD.BID_NO = PG.BID_NO                                               \n");
//        sql.append("                 AND HD.BID_COUNT = PG.BID_COUNT                                             \n");
//        sql.append("             WHERE HD.STATUS IN ('C' ,'R')                                                 \n");
        sql.append("                 AND PG.STATUS IN ('C' ,'R')                                                 \n");
        sql.append("                 AND HD.SIGN_STATUS  IN ('C')                                                                                \n");
        sql.append(" <OPT=S,S>       AND HD.HOUSE_CODE  = ?     </OPT>                                                                                           \n");
        sql.append(" <OPT=S,S>       AND HD.ANN_DATE BETWEEN  ? </OPT> <OPT=S,S> AND  ? </OPT>                                                               \n");
        sql.append(" <OPT=S,S>       AND HD.ANN_NO    =  ?                                                                                                       \n");
        sql.append(" <OPT=S,S>       AND HD.ANN_ITEM  LIKE  '%'||?||'%' </OPT>                                                                                   \n");
        sql.append("         ) VW,                                                               \n");
        sql.append("          ICOYBDAP AP , ICOMVNGL VN                                                           \n");        
        sql.append("          ,ICOYBDAT AT                                       \n");
        
        sql.append("    WHERE VW.HOUSE_CODE = AP.HOUSE_CODE(+)                                                                                               \n");
        sql.append("    AND   VW.BID_TYPE   = 'D'  \n");
        sql.append("    AND   VW.BID_NO     = AP.BID_NO(+)  \n");
        sql.append("    AND   VW.BID_COUNT  = AP.BID_COUNT(+)                                                                                                \n");
        sql.append("    AND   AP.VENDOR_CODE(+)= '"+info.getSession("COMPANY_CODE")+"'                                                                                    \n");
        sql.append("    AND   AP.BID_CANCEL(+) = 'N'                                                         \n");
        
        sql.append("    AND   VW.HOUSE_CODE = AT.HOUSE_CODE(+)                                                                                               \n");
        sql.append("    AND   VW.BID_NO     = AT.BID_NO(+)  \n");
        sql.append("    AND   VW.BID_COUNT  = AT.BID_COUNT(+)                                                                                                \n");
        sql.append("    AND   AT.VENDOR_CODE(+)= '"+info.getSession("COMPANY_CODE")+"'                                                                                    \n");
        
        sql.append("    AND   VN.VENDOR_CODE = '"+info.getSession("COMPANY_CODE")+"'                                                         \n");
        sql.append("    AND   TO_NUMBER(VW.ANN_DATE) <= TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD'))                                                               \n");
        sql.append("    AND   (VW.CONT_TYPE1 <> 'NC' OR '"+info.getSession("COMPANY_CODE")+"' IN (SELECT VENDOR_CODE FROM ICOYBDAP                                        \n");
        sql.append("                                         WHERE HOUSE_CODE = VW.HOUSE_CODE                                                                \n");
        sql.append("                                         AND BID_NO       = VW.BID_NO                                                                    \n");
        sql.append("                                         AND BID_COUNT    = VW.BID_COUNT                                                                 \n");
        sql.append("                                         AND BID_CANCEL   = 'N'                                                                          \n");
        sql.append("                                         AND STATUS IN ('C', 'R')) )                                                                     \n");

//        sql.append("-- 제한경쟁일경우                                                                          \n");
//        sql.append("   AND   (VW.CONT_TYPE1 <> 'LC'                                                            \n");
//        sql.append("     OR                                                                                    \n");
//        sql.append("      (VN.PURCHASE_LOCATION IN (SELECT RC_CODE FROM ICOYBDRC                           				   \n");
//        sql.append("                                                WHERE HOUSE_CODE = VW.HOUSE_CODE           \n");
//        sql.append("                                                  AND BID_NO       = VW.BID_NO             \n");
//        sql.append("                                                  AND BID_COUNT    = VW.BID_COUNT )        \n");
//        sql.append("       ))                                                                                  \n");

        sql.append("-- 업체등급제한                                                                          \n");
        sql.append("   AND   (VW.CONT_TYPE1 <> 'GC'                                                          \n");
        sql.append("     OR                                                                                  \n");
//        sql.append("      ((SELECT CASE WHEN CODE = 'A' THEN 999999999999999999999                           \n");
//        sql.append("      		   		ELSE TO_NUMBER(TEXT2)                                                \n");
//        sql.append("       		   END                                                                       \n");
        sql.append("      ((SELECT TEXT2                           \n");
        sql.append("      	FROM ICOMCODE                                                                    \n");
        sql.append("      	WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'                           \n");
        sql.append("      	  AND TYPE = 'M949'                                                              \n");
        sql.append("      	  AND CODE = VN.BIDDING_LEVEL) >= (SELECT SUM(PR_AMT) FROM ICOYBDDT              \n");
        sql.append("                                                WHERE HOUSE_CODE = VW.HOUSE_CODE         \n");
        sql.append("                                                  AND BID_NO       = VW.BID_NO           \n");
        sql.append("                                                  AND BID_COUNT    = VW.BID_COUNT )      \n");
        sql.append("       ))                                                                            				   \n");

		    sql.append("   ORDER BY VW.ANN_NO DESC                                                               \n");
		try{
			SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());

            String[] args = {house_code, from_date, to_date, ann_no, ann_item};
			rtn = sm.doSelect(args);

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}


    public SepoaOut getBidProgressList(String[] data)
    {
        try{

            String rtn = et_getBidProgressList(data);

            setStatus(1);
            setValue(rtn);

            rtn = et_getDBTime();
            setValue(rtn);

            setMessage(msg.getMessage("0000"));

        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }

        return getSepoaOut();
    }

    private String et_getBidProgressList(String[] data) throws Exception
    {

        lang             = info.getSession("LANGUAGE");
        ctrl_code        = info.getSession("CTRL_CODE");

        String house_code   = data[0];
        String from_date    = data[1];
        String to_date      = data[2];
        String ann_no       = data[3];
        String ann_item     = data[4];
        String bid_flag     = data[5];
        String cont_type2   = data[6];

        ConnectionContext ctx = getConnectionContext();

        String rtn = "";

        StringBuffer sql = new StringBuffer();

        sql.append("   SELECT                                                                                                                            \n");
        sql.append("           HD.ANN_NO           ,                                                                                                     \n");
        sql.append("           HD.ANN_ITEM         ,                                                                                                     \n");
        sql.append("           GETICOMCODE2(HD.HOUSE_CODE, 'M994', HD.CONT_TYPE1)||' ('||                                                                \n");
        sql.append("           GETICOMCODE2(HD.HOUSE_CODE, 'M993', HD.CONT_TYPE2)||')' AS CONT_TYPE_TEXT,                                                \n");
        sql.append("           TO_CHAR(TO_DATE(HD.APP_BEGIN_DATE||HD.APP_BEGIN_TIME, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI') AS APP_BEGIN_DATE_TIME ,  \n");
        sql.append("           TO_CHAR(TO_DATE(HD.APP_END_DATE||HD.APP_END_TIME, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI') AS APP_END_DATE_TIME ,        \n");
        sql.append("           DECODE(NVL(ANNOUNCE_DATE, ''), '', 'N', 'Y')        AS ANNOUNCE,                                                          \n");
        sql.append("           HD.ATTACH_NO,                                                                                                             \n");
        sql.append("           (SELECT COUNT(*) FROM ICOMATCH                                                                                            \n");
        sql.append("            WHERE DOC_NO     = HD.ATTACH_NO) AS ATTACH_CNT,                                                                          \n");
        sql.append("           GETICOMCODE2(HD.HOUSE_CODE, 'M974', DECODE(NVL(AP.APP_DATE, ''), '', 'N', 'Y'))    AS STATUS_TEXT,                        \n");
        sql.append("           HD.BID_STATUS,                                                                                                            \n");
        sql.append("           HD.BID_NO,                                                                                                                \n");
        sql.append("           HD.BID_COUNT,                                                                                                             \n");
        sql.append("           DECODE(NVL(AP.APP_DATE, ''), '', 'N', 'Y') AS STATUS,                                                                     \n");
        sql.append("           CASE WHEN  EXISTS(SELECT UN.IRS_NO  FROM ICOMUNVN  UN,  ICOMVNGL  VN                                                      \n");
        sql.append("                              WHERE TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN RES_FROM_DATE AND RES_TO_DATE                                \n");
        sql.append("                                AND VN.VENDOR_CODE = '"+info.getSession("COMPANY_CODE")+"'                                           \n");
        sql.append("                                AND VN.IRS_NO  = UN.IRS_NO )                                                                         \n");
        sql.append("                THEN 'N'     ELSE 'Y'      END   AS  ENABLE_YN                                                                       \n");
        sql.append("           ,HD.ANNOUNCE_FLAG                                                                                                         \n");
        sql.append("           ,CASE WHEN  EXISTS(SELECT VENDOR_CODE  FROM ICOYBDCR                                                                     \n");
        sql.append("                              WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'                                                \n");
        sql.append("                                AND VENDOR_CODE = '"+info.getSession("COMPANY_CODE")+"'                                             \n");
        sql.append("                                AND HOUSE_CODE  = HD.HOUSE_CODE                                                                     \n");
        sql.append("                                AND BID_NO = HD.BID_NO                                                                              \n");
        sql.append("                                AND BID_COUNT = HD.BID_COUNT )                                                                      \n");
        sql.append("                THEN 'Y'     ELSE 'N'      END   AS  ANNOUNCE_YN                                                                    \n");
        sql.append("   FROM  ICOYBDHD HD, ICOYBDAP AP  , ICOMVNGL VN                                                                                                  \n");
        sql.append("   WHERE HD.BID_TYPE = 'D'                                                                                                           \n");
        sql.append("   AND   HD.HOUSE_CODE = AP.HOUSE_CODE(+)                                                                                            \n");
        sql.append("   AND   HD.BID_NO     = AP.BID_NO(+)                                                                                                \n");
        sql.append("   AND   HD.BID_COUNT  = AP.BID_COUNT(+)                                                                                             \n");
        sql.append("   AND   AP.VENDOR_CODE(+)= '"+info.getSession("COMPANY_CODE")+"'                                                                    \n");
        sql.append("   AND   AP.BID_CANCEL(+) = 'N'                                    \n");
        sql.append(" <OPT=S,S> AND   HD.HOUSE_CODE  = ?     </OPT>                                                                                       \n");
        sql.append(" <OPT=S,S> AND   HD.APP_END_DATE BETWEEN  ? </OPT> <OPT=S,S> AND  ? </OPT>                                                           \n");
        sql.append(" <OPT=S,S> AND   HD.ANN_NO    =  ?                                                                                                   \n");
        sql.append(" <OPT=S,S> AND   HD.ANN_ITEM  LIKE  '%'||?||'%' </OPT>                                                                               \n");
        sql.append("   AND   TO_NUMBER(HD.ANN_DATE) <= TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD'))                                                            \n");
        sql.append("   AND   TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) < TO_NUMBER(HD.APP_END_DATE||HD.APP_END_TIME)                                \n");
        sql.append("   AND   HD.BID_STATUS||HD.SIGN_STATUS IN ('ACC', 'UCC', 'CCC')                                                                      \n");
        sql.append("   AND   (HD.CONT_TYPE1 <> 'NC' OR '"+info.getSession("COMPANY_CODE")+"' IN (SELECT VENDOR_CODE FROM ICOYBDAP                        \n");
        sql.append("                                        WHERE HOUSE_CODE = HD.HOUSE_CODE                                                             \n");
        sql.append("                                        AND BID_NO       = HD.BID_NO                                                                 \n");
        sql.append("                                        AND BID_COUNT    = HD.BID_COUNT                                                              \n");
        sql.append("                                        AND BID_CANCEL   = 'N'                                                                       \n");
        sql.append("                                        AND STATUS IN ('C', 'R')) )                                                                  \n");

        sql.append("    AND   VN.VENDOR_CODE = '"+info.getSession("COMPANY_CODE")+"'                                                         \n");
        sql.append("-- 제한경쟁일경우                                                                          \n");
        sql.append("   AND   (HD.CONT_TYPE1 <> 'LC'                                                            \n");
        sql.append("     OR                                                                                    \n");
        sql.append("      (VN.PURCHASE_LOCATION IN (SELECT RC_CODE FROM ICOYBDRC                           				   \n");
        sql.append("                                                WHERE HOUSE_CODE = HD.HOUSE_CODE           \n");
        sql.append("                                                  AND BID_NO       = HD.BID_NO             \n");
        sql.append("                                                  AND BID_COUNT    = HD.BID_COUNT )        \n");
        sql.append("       ))                                                                                  \n");

        sql.append("-- 업체등급제한                                                                          \n");
        sql.append("   AND   (HD.CONT_TYPE1 <> 'GC'                                                          \n");
        sql.append("     OR                                                                                  \n");
//        sql.append("      ((SELECT CASE WHEN CODE = 'A' THEN 999999999999999999999                           \n");
//        sql.append("      		   		ELSE TO_NUMBER(TEXT2)                                                \n");
//        sql.append("       		   END                                                                       \n");
        sql.append("      ((SELECT TEXT2                           \n");
        sql.append("      	FROM ICOMCODE                                                                    \n");
        sql.append("      	WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'                           \n");
        sql.append("      	  AND TYPE = 'M949'                                                              \n");
        sql.append("      	  AND CODE = VN.BIDDING_LEVEL) >= (SELECT SUM(PR_AMT) FROM ICOYBDDT              \n");
        sql.append("                                                WHERE HOUSE_CODE = HD.HOUSE_CODE         \n");
        sql.append("                                                  AND BID_NO       = HD.BID_NO           \n");
        sql.append("                                                  AND BID_COUNT    = HD.BID_COUNT )      \n");
        sql.append("       ))                                                                            				   \n");

        if(bid_flag.equals("N")) { // 미제출
            sql.append("   AND   ((                                                                                 \n");
            sql.append("            '"+info.getSession("COMPANY_CODE")+"' NOT IN (SELECT VENDOR_CODE FROM ICOYBDAP  \n");
            sql.append("                                  WHERE HOUSE_CODE = HD.HOUSE_CODE                          \n");
            sql.append("                                  AND BID_NO       = HD.BID_NO                              \n");
            sql.append("                                  AND BID_COUNT    = HD.BID_COUNT                           \n");
            sql.append("                                  AND BID_CANCEL   = 'N'                                    \n");
            sql.append("                                  AND STATUS IN ('C', 'R')                                  \n");
            sql.append("                                )                                                           \n");
            sql.append("           )  OR '"+info.getSession("COMPANY_CODE")+"' IN (SELECT VENDOR_CODE FROM ICOYBDAP \n");
            sql.append("                                        WHERE HOUSE_CODE = HD.HOUSE_CODE                    \n");
            sql.append("                                        AND BID_NO       = HD.BID_NO                        \n");
            sql.append("                                        AND BID_COUNT    = HD.BID_COUNT                     \n");
            sql.append("                                        AND BID_CANCEL   = 'N'                              \n");
            sql.append("                                        AND APP_DATE IS NULL                                \n");
            sql.append("                                        AND STATUS IN ('C', 'R')) )                         \n");
        } else if(bid_flag.equals("Y")) { // 제출
            sql.append("   AND  '"+info.getSession("COMPANY_CODE")+"' IN (SELECT VENDOR_CODE FROM ICOYBDAP          \n");
            sql.append("                                                   WHERE HOUSE_CODE = HD.HOUSE_CODE         \n");
            sql.append("                                                   AND BID_NO       = HD.BID_NO             \n");
            sql.append("                                                   AND BID_COUNT    = HD.BID_COUNT          \n");
            sql.append("                                                   AND BID_CANCEL   = 'N'                   \n");
            sql.append("                                                   AND AP.APP_DATE IS NOT NULL              \n");
            sql.append("                                                   AND STATUS IN ('C', 'R'))                \n");
        }
        sql.append("   AND   HD.SIGN_STATUS  IN ('C')                                                               \n");
        sql.append("   AND   HD.BID_TYPE = 'D'                                                                      \n");
        if(cont_type2.equals("LP")) { // 최저가 인경우만 적용
            sql.append("   AND   HD.CONT_TYPE2 <>  'LP'                                                                    \n");
        }
        sql.append("   AND   HD.STATUS IN ('C' ,'R')                                                                \n");
		sql.append("   ORDER BY HD.ANN_NO DESC                                                               \n");


        try{
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());

            String[] args = {house_code, from_date, to_date, ann_no, ann_item};
            rtn = sm.doSelect(args);

        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

	public SepoaOut setBidRegister(String BID_NO, String BID_COUNT, String BDAP_CNT, String GUAR_TYPE, String ATTACH_NO, String USER_NAME, String USER_POSITION, String USER_PHONE, String USER_MOBILE, String USER_EMAIL)
	{

		try{
       		ConnectionContext ctx = getConnectionContext();

            String status = et_chkAppEndDate(ctx, BID_NO, BID_COUNT); // 입찰등록마감시간 체크
			if (status.equals("N")){
                setStatus(0);
                setMessage(msg.getMessage("0057"));
                return getSepoaOut();
			}
			
			int rtn = et_setBidRegister(ctx, BID_NO, BID_COUNT, BDAP_CNT, GUAR_TYPE, ATTACH_NO, USER_NAME, USER_POSITION, USER_PHONE, USER_MOBILE, USER_EMAIL);
            setStatus(1);
            setValue(rtn+"");

            setMessage(msg.getMessage("0055"));

            Commit();

		}catch(Exception e) {
            try {
                Rollback();
				setStatus(0);
			    setMessage(msg.getMessage("0003"));
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0003"));
		}

		return getSepoaOut();
	}

    private String et_chkAppEndDate(ConnectionContext ctx, String BID_NO, String BID_COUNT) throws Exception
    {
        String rtn = "";
        String value = null;

        StringBuffer sql = new StringBuffer();

        sql.append(" SELECT                                                                                                                   \n");
        sql.append("       (case when TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) < TO_NUMBER(HD.APP_END_DATE||HD.APP_END_TIME) then 'Y'   \n");
        sql.append("             else 'N'                                                                                                     \n");
        sql.append("        end) status                                                                                                       \n");
        sql.append("   FROM  ICOYBDHD hd                                                                                                      \n");
        sql.append(" WHERE hd.HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'                                                                \n");
        sql.append("  AND hd.BID_NO      = '"+BID_NO+"'                                                                                       \n");
        sql.append("  AND hd.BID_COUNT   = '"+BID_COUNT+"'                                                                                    \n");

        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            value = sm.doSelect((String[])null);

            SepoaFormater wf = new SepoaFormater(value);
            rtn = wf.getValue(0,0);

        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

    private int et_setBidRegister(ConnectionContext ctx, String BID_NO, String BID_COUNT, String BDAP_CNT, String GUAR_TYPE, String ATTACH_NO, String USER_NAME, String USER_POSITION, String USER_PHONE, String USER_MOBILE, String USER_EMAIL) throws Exception
    {
        int rtn = 0;

        StringBuffer sql = new StringBuffer();
        SepoaSQLManager sm = null;

        HOUSE_CODE      = info.getSession("HOUSE_CODE");
        company         = info.getSession("COMPANY_CODE");
        dept            = info.getSession("DEPARTMENT");
        String USER_ID  = info.getSession("ID");
        name_loc        = info.getSession("NAME_LOC");
        name_eng        = info.getSession("NAME_ENG");

        try {
            if(BDAP_CNT.length() == 0  ){
            	BDAP_CNT = "0";
            }
            if(Integer.parseInt(BDAP_CNT) > 0) { // '지명입찰'일 경우엔 이미 bdap에 데이터가 들어가 있다.
                sql = new StringBuffer();
                String[][] recvData = new String[1][];
            
                String[] tmp = {GUAR_TYPE, ATTACH_NO, USER_NAME, USER_POSITION, USER_PHONE, USER_MOBILE, USER_EMAIL, HOUSE_CODE, BID_NO, BID_COUNT, company};
            
                recvData[0] = tmp;
            
                sql.append(" UPDATE ICOYBDAP                                          \n");
                sql.append(" SET    APP_DATE = TO_CHAR(SYSDATE,'YYYYMMDD')            \n");
                sql.append("       ,APP_TIME = TO_CHAR(SYSDATE,'HH24MISS')            \n");
                sql.append("       ,GUAR_TYPE= ?                                      \n");
                sql.append("       ,ATTACH_NO= ?                                      \n");
                sql.append("       ,USER_NAME= ?                                      \n");
                sql.append("       ,USER_POSITION= ?                                  \n");
                sql.append("       ,USER_PHONE= ?                                     \n");
                sql.append("       ,USER_MOBILE= ?                                    \n");
                sql.append("       ,USER_EMAIL= ?                                     \n");
            
                sql.append(" WHERE  HOUSE_CODE = ?                                    \n");
                sql.append("  AND   BID_NO     = ?                                    \n");
                sql.append("  AND   BID_COUNT  = ?                                    \n");
                sql.append("  AND   VENDOR_CODE  = ?                                  \n");
            
                sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
                String[] type = {"S","S","S","S","S","S","S","S","S","S","S"};
            
                rtn = sm.doUpdate(recvData, type);
            } else {
                sql = new StringBuffer();
            
                sql.append(" INSERT INTO ICOYBDAP (                                                        \n");
                sql.append("                         HOUSE_CODE              ,                             \n");
                sql.append("                         BID_NO                  ,                             \n");
                sql.append("                         BID_COUNT               ,                             \n");
                sql.append("                         VENDOR_CODE             ,                             \n");
                sql.append("                         STATUS                  ,                             \n");
                sql.append("                         ADD_DATE                ,                             \n");
                sql.append("                         ADD_TIME                ,                             \n");
                sql.append("                         ADD_USER_ID             ,                             \n");
                sql.append("                         ADD_USER_NAME_LOC       ,                             \n");
                sql.append("                         ADD_USER_NAME_ENG       ,                             \n");
                sql.append("                         ADD_USER_DEPT           ,                             \n");
                sql.append("                         APP_DATE                ,                             \n");
                sql.append("                         APP_TIME                ,                             \n");
                sql.append("                         EXPLAN_FLAG             ,                             \n");
                sql.append("                         UNT_FLAG                ,                             \n");
                sql.append("                         ACHV_FLAG               ,                             \n");
                sql.append("                         FINAL_FLAG              ,                             \n");
                sql.append("                         INCO_REASON             ,                             \n");
                sql.append("                         GUAR_TYPE               ,                             \n");
                sql.append("                         ATTACH_NO               ,                             \n");
                sql.append("                         USER_NAME               ,                             \n");
                sql.append("                         USER_POSITION           ,                             \n");
                sql.append("                         USER_PHONE              ,                             \n");
                sql.append("                         USER_MOBILE             ,                             \n");
                sql.append("                         USER_EMAIL                                             \n");
                sql.append(" ) VALUES (                                                                    \n");
                sql.append("                         ?,                                                    \n");
                sql.append("                         ?,                                                    \n");
                sql.append("                         ?,                                                    \n");
                sql.append("                         ?,                                                    \n");
                sql.append("                         'C'           ,                -- STATUS              \n");
                sql.append("                         TO_CHAR(SYSDATE,'YYYYMMDD'),   -- ADD_DATE            \n");
                sql.append("                         TO_CHAR(SYSDATE,'HH24MISS'),   -- ADD_TIME            \n");
                sql.append("                         ?             ,                -- ADD_USER_ID         \n");
                sql.append("                         ?             ,                -- ADD_USER_NAME_LOC   \n");
                sql.append("                         ?             ,                -- ADD_USER_NAME_ENG   \n");
                sql.append("                         ?             ,                -- ADD_USER_DEPT       \n");
                sql.append("                         TO_CHAR(SYSDATE,'YYYYMMDD'),   -- APP_DATE            \n");
                sql.append("                         TO_CHAR(SYSDATE,'HH24MISS'),   -- APP_TIME            \n");
                sql.append("                         ''            ,                -- EXPLAN_FLAG         \n");
                sql.append("                         'N'            ,               -- UNT_FLAG            \n");
                sql.append("                         'Y'            ,               -- ACHV_FLAG           \n");
                sql.append("                         'Y'            ,               -- FINAL_FLAG          \n");
                sql.append("                         ''            ,                -- INCO_REASON         \n");
                sql.append("                         ?             ,                -- GUAR_TYPE           \n");
                sql.append("                         ?             ,                -- ATTACH_NO           \n");
                sql.append("                         ?             ,                -- USER_NAME           \n");
                sql.append("                         ?             ,                -- USER_POSITION       \n");
                sql.append("                         ?             ,                -- USER_PHONE          \n");
                sql.append("                         ?             ,                -- USER_MOBILE         \n");
                sql.append("                         ?                              -- USER_EMAIL          \n");
                sql.append(" )                                                                             \n");
            
                sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
                String[] type = {"S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "S","S","S","S","S"
                                };
            
                String[][] dataAP={{
                                    HOUSE_CODE       ,
                                    BID_NO           ,
                                    BID_COUNT        ,
                                    company          ,
                                    USER_ID          ,
            
                                    name_loc         ,
                                    name_eng         ,
                                    dept             ,
                                    GUAR_TYPE        ,
                                    ATTACH_NO        ,
                                    USER_NAME        ,
                                    USER_POSITION    ,
                                    USER_PHONE       ,
                                    USER_MOBILE      ,
                                    USER_EMAIL
                                    }};
            
                rtn = sm.doInsert(dataAP, type);
            }
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }   
        return rtn;
    }       
            
	public SepoaOut getBidPriceList(String[] data)
    {       
		try{
            
			String rtn = et_getBidPriceList(data);
            
	        setStatus(1);
	        setValue(rtn);
            
            rtn = et_getDBTime();
			setValue(rtn);
            
			setMessage(msg.getMessage("0000"));
            
		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}   
            
		return getSepoaOut();
	}       
            
	private String et_getBidPriceList(String[] data) throws Exception
	{       
            
        lang             = info.getSession("LANGUAGE");
        ctrl_code        = info.getSession("CTRL_CODE");
            
        String house_code = data[0];
        String from_date  = data[1];
        String to_date    = data[2];
        String ann_no     = data[3];
        String ann_item   = data[4];
        String bid_flag   = data[5];
            
   		ConnectionContext ctx = getConnectionContext();
            
        String rtn = "";
            
        StringBuffer sql = new StringBuffer();
            
        sql.append(" SELECT                                                                                                                                               \n");
        sql.append("        HD.ANN_NO           ,                                                                                                                         \n");
        sql.append("        HD.ANN_ITEM         ,                                                                                                                         \n");
        sql.append("        GETICOMCODE2(HD.HOUSE_CODE, 'M994', HD.CONT_TYPE1)||' ('||                                                                                    \n");
        sql.append("        GETICOMCODE2(HD.HOUSE_CODE, 'M993', HD.CONT_TYPE2)||')' AS CONT_TYPE_TEXT,                                                                    \n");
        sql.append("        TO_CHAR(TO_DATE(PG.BID_BEGIN_DATE||PG.BID_BEGIN_TIME, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI') AS BID_BEGIN_DATE_TIME ,                      \n");
        sql.append("        TO_CHAR(TO_DATE(PG.BID_END_DATE||PG.BID_END_TIME, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI') AS BID_END_DATE_TIME ,                            \n");
        sql.append("        HD.ATTACH_NO,                                                                                                                                 \n");
        sql.append("        (SELECT COUNT(*) FROM ICOMATCH                                                                                                                \n");
        sql.append("         WHERE DOC_NO     = HD.ATTACH_NO) AS ATTACH_CNT,                                                                                              \n");
        sql.append("        GETICOMCODE2(HD.HOUSE_CODE, 'M973',                                                                                                           \n");
        sql.append("                                   (CASE                                                                                                              \n");
        sql.append("                                         WHEN  TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) >= TO_NUMBER(PG.BID_BEGIN_DATE||PG.BID_BEGIN_TIME)      \n");
        sql.append("                                          AND  TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) < TO_NUMBER(PG.BID_END_DATE||PG.BID_END_TIME)           \n");
        sql.append("                                         THEN 'P' -- 진행중                                                                                           \n");
        sql.append("                                         WHEN  (TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) < TO_NUMBER(PG.BID_BEGIN_DATE||PG.BID_BEGIN_TIME)      \n");
        sql.append("                                                 OR PG.BID_END_DATE IS NULL)                                                                          \n");
        sql.append("                                         THEN 'F' -- 예정중                                                                                           \n");
        sql.append("                                         ELSE 'C' -- 종료                                                                                             \n");
        sql.append("                                    END)                                                                                                              \n");
        sql.append("        )    AS STATUS_TEXT,                                                                                                                          \n");
        sql.append("        HD.BID_STATUS,                                                                                                                                \n");
        sql.append("        HD.BID_NO,                                                                                                                                    \n");
        sql.append("        HD.BID_COUNT,                                                                                                                                 \n");
        sql.append("       (CASE                                                                                                                                          \n");
        sql.append("             WHEN  TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) >= TO_NUMBER(PG.BID_BEGIN_DATE||PG.BID_BEGIN_TIME)                                  \n");
        sql.append("              AND  TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) < TO_NUMBER(PG.BID_END_DATE||PG.BID_END_TIME)                                       \n");
        sql.append("             THEN 'P' -- 진행중                                                                                                                       \n");
        sql.append("             WHEN  (TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) < TO_NUMBER(PG.BID_BEGIN_DATE||PG.BID_BEGIN_TIME)                                  \n");
        sql.append("                     OR PG.BID_END_DATE IS NULL)                                                                                                      \n");
        sql.append("             THEN 'F' -- 예정중                                                                                                                       \n");
        sql.append("             ELSE 'C' -- 종료                                                                                                                         \n");
        sql.append("        END) AS STATUS,                                                                                                                               \n");
        sql.append("       (SELECT COUNT(*) FROM ICOYBDAP                                                                                                                 \n");
        sql.append("        WHERE HOUSE_CODE = HD.HOUSE_CODE                                                                                                              \n");
        sql.append("        AND BID_NO       = HD.BID_NO                                                                                                                  \n");
        sql.append("        AND BID_COUNT    = HD.BID_COUNT                                                                                                               \n");
        sql.append("        AND VENDOR_CODE  = '"+info.getSession("COMPANY_CODE")+"'                                                                                      \n");
        sql.append("        AND STATUS IN ('C', 'R')                                                                                                                      \n");
        sql.append("        AND ADD_DATE IS NOT NULL) AS PARTICIPATE_FLAG,                                                                                                \n");
        sql.append("       (SELECT COUNT(*) FROM ICOYBDVO                                                         \n");
        sql.append("        WHERE HOUSE_CODE = HD.HOUSE_CODE                                                      \n");
        sql.append("        AND BID_NO       = HD.BID_NO                                                          \n");
        sql.append("        AND BID_COUNT    = HD.BID_COUNT                                                       \n");
        sql.append("        AND VENDOR_CODE  = '"+info.getSession("COMPANY_CODE")+"'                              \n");
        sql.append("        AND VOTE_COUNT   = PG.VOTE_COUNT                                                      \n");
        sql.append("        AND STATUS IN ('C', 'R')                                                              \n");
        sql.append("        ) AS VOTE_FLAG,                                                                       \n");
        sql.append("       (SELECT FINAL_FLAG FROM ICOYBDAP                                                       \n");
        sql.append("        WHERE HOUSE_CODE = HD.HOUSE_CODE                                                      \n");
        sql.append("        AND BID_NO       = HD.BID_NO                                                          \n");
        sql.append("        AND BID_COUNT    = HD.BID_COUNT                                                       \n");
        sql.append("        AND VENDOR_CODE  = '"+info.getSession("COMPANY_CODE")+"'                              \n");
        sql.append("        AND STATUS IN ('C', 'R')) AS FINAL_FLAG,                                              \n");
        sql.append("        DECODE( HD.CONT_TYPE2, 'LC', 'Y',                                     \n");
        sql.append("       (SELECT SPEC_FLAG FROM ICOYBDSP                                        \n");
        sql.append("        WHERE HOUSE_CODE = HD.HOUSE_CODE                                      \n");
        sql.append("        AND BID_NO       = HD.BID_NO                                          \n");
        sql.append("        AND BID_COUNT    = HD.BID_COUNT                                       \n");
        sql.append("        AND VOTE_COUNT   = PG.VOTE_COUNT                                      \n");
        sql.append("        AND VENDOR_CODE  = '"+info.getSession("COMPANY_CODE")+"'              \n");
        sql.append("        AND STATUS IN ('C', 'R'))) AS SPEC_FLAG,                              \n");
        sql.append("       (SELECT BID_CANCEL FROM ICOYBDAP                                                       \n");
        sql.append("        WHERE HOUSE_CODE = HD.HOUSE_CODE                                                      \n");
        sql.append("        AND BID_NO       = HD.BID_NO                                                          \n");
        sql.append("        AND BID_COUNT    = HD.BID_COUNT                                                       \n");
        sql.append("        AND VENDOR_CODE  = '"+info.getSession("COMPANY_CODE")+"'                              \n");
        sql.append("        AND STATUS IN ('C', 'R')) AS BID_CANCEL,                                              \n");
        sql.append("        HD.CONT_TYPE2,                                                        \n");
        sql.append("        PG.VOTE_COUNT,                                                                                                     \n");
        sql.append("        CASE WHEN  EXISTS(SELECT UN.IRS_NO  FROM ICOMUNVN  UN,  ICOMVNGL  VN                                               \n");
        sql.append("                           WHERE TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN RES_FROM_DATE AND RES_TO_DATE                         \n");
        sql.append("                             AND VN.VENDOR_CODE = '"+info.getSession("COMPANY_CODE")+"'                                    \n");
        sql.append("                             AND VN.IRS_NO  = UN.IRS_NO )                                                                  \n");
        sql.append("                THEN 'N'     ELSE 'Y'      END   AS  ENABLE_YN                                                             \n");
        sql.append("           ,HD.ANNOUNCE_FLAG                                                                                                         \n");
        sql.append("           ,CASE WHEN  EXISTS(SELECT VENDOR_CODE  FROM ICOYBDCR                                                                     \n");
        sql.append("                              WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'                                                \n");
        sql.append("                                AND VENDOR_CODE = '"+info.getSession("COMPANY_CODE")+"'                                             \n");
        sql.append("                                AND HOUSE_CODE  = HD.HOUSE_CODE                                                                     \n");
        sql.append("                                AND BID_NO = HD.BID_NO                                                                              \n");
        sql.append("                                AND BID_COUNT = HD.BID_COUNT )                                                                      \n");
        sql.append("                THEN 'Y'     ELSE 'N'      END   AS  ANNOUNCE_YN                                                                    \n");
        sql.append(" ,nvl((select bid_amt_enc from icoybdvo where hd.bid_no = bid_no and hd.bid_count = bid_count and vn.vendor_code = vendor_code and pg.vote_count = vote_count), '미참여') bid_amt_enc		\n");
        sql.append(" , HD.ANN_VERSION                                                                                                                                    \n");   //2010.10.27추가
        sql.append(" FROM  ICOYBDHD HD, ICOYBDPG PG  , ICOMVNGL VN                                                                                           \n");
        sql.append(" WHERE HD.BID_TYPE   = 'D'                                                                                                 \n");
        sql.append(" AND   HD.HOUSE_CODE = PG.HOUSE_CODE                                                                                       \n");
        sql.append(" AND   HD.BID_NO     = PG.BID_NO                                                                                           \n");
        sql.append(" AND   HD.BID_COUNT  = PG.BID_COUNT                                                                                        \n");
        sql.append(" <OPT=S,S> AND   HD.HOUSE_CODE  = ?     </OPT>                                                                             \n");
        sql.append(" <OPT=S,S> AND   (PG.BID_BEGIN_DATE BETWEEN  ?  </OPT>  <OPT=S,S> AND  ? </OPT>  <OPT=S,S>                                 \n");
        sql.append("     OR PG.BID_END_DATE BETWEEN  ?  </OPT>  <OPT=S,S> AND  ?)     </OPT>                                                   \n");
        sql.append(" <OPT=S,S> AND   HD.ANN_NO    =  ?                                                                                         \n");
        sql.append(" <OPT=S,S> AND   HD.ANN_ITEM  LIKE  '%'||?||'%' </OPT>                                                                     \n");
            
        if(bid_flag.equals("P")) {
            sql.append("    AND   TO_NUMBER(PG.BID_BEGIN_DATE||PG.BID_BEGIN_TIME) <= TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'))            \n");
            sql.append("    AND   TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) < TO_NUMBER(PG.BID_END_DATE||PG.BID_END_TIME)    -- 진행중    \n");
        } else if(bid_flag.equals("F")) {
            sql.append("    AND  (TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) < TO_NUMBER(PG.BID_BEGIN_DATE||PG.BID_BEGIN_TIME) --예정중    \n");
            sql.append("           OR PG.BID_END_DATE IS NULL)                                                                                 \n");
        } else if(bid_flag.equals("C")) {
            sql.append("    AND   TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) >= TO_NUMBER(PG.BID_END_DATE||PG.BID_END_TIME) -- 종료        \n");
        }   
            
        sql.append(" AND   HD.BID_STATUS IN ('AC', 'UC', 'RC', 'SR', 'SC')                                                                     \n");
        sql.append(" AND   (HD.CONT_TYPE1 <> 'NC' OR '"+info.getSession("COMPANY_CODE")+"' IN (SELECT VENDOR_CODE FROM ICOYBDAP                \n");
        sql.append("                             WHERE HOUSE_CODE = HD.HOUSE_CODE                                                              \n");
        sql.append("                             AND BID_NO       = HD.BID_NO                                                                  \n");
        sql.append("                             AND BID_COUNT    = HD.BID_COUNT                                                               \n");
        sql.append("                             AND STATUS IN ('C', 'R')) )                                                                   \n");
        sql.append("    AND   VN.VENDOR_CODE = '"+info.getSession("COMPANY_CODE")+"'                                                         \n");
        /*
        sql.append("-- 제한경쟁일경우                                                                          \n");
        sql.append("   AND   (HD.CONT_TYPE1 <> 'LC'                                                            \n");
        sql.append("     OR                                                                                    \n");
        sql.append("      (VN.PURCHASE_LOCATION IN (SELECT RC_CODE FROM ICOYBDRC                           	   \n");
        sql.append("                                                WHERE HOUSE_CODE = HD.HOUSE_CODE           \n");
        sql.append("                                                  AND BID_NO       = HD.BID_NO             \n");
        sql.append("                                                  AND BID_COUNT    = HD.BID_COUNT )        \n");
        sql.append("       ))                                                                                  \n");
          */  
        sql.append("-- 업체등급제한                                                                          \n");
        sql.append("   AND   (HD.CONT_TYPE1 <> 'GC'                                                          \n");
        sql.append("     OR                                                                                  \n");
//        sql.append("      ((SELECT CASE WHEN CODE = 'A' THEN 999999999999999999999                           \n");
//        sql.append("      		   		ELSE TO_NUMBER(TEXT2)                                                \n");
//        sql.append("       		   END                                                                       \n");
        sql.append("      ((SELECT TEXT2                           \n");
        sql.append("      	FROM ICOMCODE                                                                    \n");
        sql.append("      	WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'                           \n");
        sql.append("      	  AND TYPE = 'M949'                                                              \n");
        sql.append("      	  AND CODE = VN.BIDDING_LEVEL) >= (SELECT SUM(PR_AMT) FROM ICOYBDDT              \n");
        sql.append("                                                WHERE HOUSE_CODE = HD.HOUSE_CODE         \n");
        sql.append("                                                  AND BID_NO       = HD.BID_NO           \n");
        sql.append("                                                  AND BID_COUNT    = HD.BID_COUNT )      \n");
        sql.append("       ))                                                                            				   \n");
            
        sql.append(" AND   HD.SIGN_STATUS  IN ('C')                                                                                            \n");
        sql.append(" AND   HD.STATUS IN ('C' ,'R')                                                                                             \n");
        sql.append(" AND   PG.STATUS IN ('C' ,'R')                                                                                             \n");

		// 입찰적격확인(보증금입력)이 되지 않은 업체는 공고가 표시되지 않도록 수정 : code by ihStone 20100224
        sql.append(" and   ( (VN.VENDOR_CODE in (select VENDOR_CODE                                             \n"); 
        sql.append("                            from ICOMQTEE Z                                              \n");
        sql.append("                           where Z.HOUSE_CODE = HD.HOUSE_CODE                            \n");
        sql.append("                             and Z.BID_NO     = HD.BID_NO                                \n");
        sql.append("                             and Z.BID_COUNT  = HD.BID_COUNT                             \n");   
				sql.append("                            ))                                                            \n");
		//[R101301239534]전자입찰시스템 입찰보증금 면제 추진 (지명경쟁제한적최저가)
    //  sql.append("         OR ((HD.CONT_TYPE1 = 'NC') AND (HD.CONT_TYPE2 = 'RL'))                         \n");
        sql.append("        )                                                                                 \n");
        
    		
		sql.append("   ORDER BY HD.ANN_NO DESC                                                               \n");
		try{
			SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            
            String[] args = {house_code, from_date, to_date, from_date, to_date, ann_no, ann_item};
			rtn = sm.doSelect(args);
            
		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}   
		return rtn;
	}       
            
	public SepoaOut setBid(String BID_NO, String BID_COUNT, String VOTE_COUNT, String ATTACH_NO,
                          String BID_AMT_ENC, String CERTV, String TIMESTAMP, String SIGN_CERT,
                          String USER_NAME, String USER_POSITION, String USER_PHONE, String USER_MOBILE, String USER_EMAIL,
                          String CHOICE_ESTM_NUM1, String CHOICE_ESTM_NUM2, String CHOICE_ESTM_NUM3, String CHOICE_ESTM_NUM4)
	{       
            
		try{
       		ConnectionContext ctx = getConnectionContext();
            
            String status = et_chkBidEndDate(ctx, BID_NO, BID_COUNT, VOTE_COUNT); // 입찰제출마감시간 체크
            
            if (status.equals("N")){
                setStatus(0);
                setMessage(msg.getMessage("0058"));
                return getSepoaOut();
            }
            
            int rtn = et_setBDAPinst(ctx, BID_NO, BID_COUNT, USER_NAME, USER_POSITION, USER_PHONE, USER_MOBILE, USER_EMAIL);
            
			rtn = et_setBid(ctx, BID_NO, BID_COUNT, VOTE_COUNT, ATTACH_NO,
			                         BID_AMT_ENC, CERTV, TIMESTAMP, SIGN_CERT,
                                     CHOICE_ESTM_NUM1, CHOICE_ESTM_NUM2, CHOICE_ESTM_NUM3, CHOICE_ESTM_NUM4);
            setStatus(1);
            setValue(rtn+"");
            
            setMessage(msg.getMessage("0056"));
            
            Commit();
            
		}catch(Exception e) {
            try {
                Rollback();
				setStatus(0);
			    setMessage(msg.getMessage("0003"));
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0003"));
		}   
            
		return getSepoaOut();
	}       
            
    private String et_chkBidEndDate(ConnectionContext ctx, String BID_NO, String BID_COUNT, String VOTE_COUNT) throws Exception
    {       
        String rtn = "";
        String value = null;
            
        StringBuffer sql = new StringBuffer();
            
        sql.append(" SELECT                                                                                                                   \n");
        sql.append("       (case when TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) < TO_NUMBER(PG.BID_END_DATE||PG.BID_END_TIME) then 'Y'   \n");
        sql.append("             else 'N'                                                                                                     \n");
        sql.append("        end) status                                                                                                       \n");
        sql.append("   FROM  ICOYBDPG PG                                                                                                      \n");
        sql.append(" WHERE PG.HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'                                                                \n");
        sql.append("  AND PG.BID_NO      = '"+BID_NO+"'                                                                                       \n");
        sql.append("  AND PG.BID_COUNT   = '"+BID_COUNT+"'                                                                                    \n");
        sql.append("  AND PG.VOTE_COUNT  = '"+VOTE_COUNT+"'                                                                                    \n");
            
        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            value = sm.doSelect((String[])null);
            
            SepoaFormater wf = new SepoaFormater(value);
            rtn = wf.getValue(0,0);
            
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }   
        return rtn;
    }       
            
    private int et_setBDAPinst(ConnectionContext ctx, String BID_NO, String BID_COUNT, String USER_NAME, String USER_POSITION, String USER_PHONE, String USER_MOBILE, String USER_EMAIL) throws Exception
    {       
        int rtn = 0;
        String BDAP_CNT = "";
        String bdap_enable = "";
        String bdap_flag = "";
            
        StringBuffer sql = new StringBuffer();
        SepoaSQLManager sm = null;
            
        HOUSE_CODE      = info.getSession("HOUSE_CODE");
        company         = info.getSession("COMPANY_CODE");
        dept            = info.getSession("DEPARTMENT");
        String USER_ID  = info.getSession("ID");
        name_loc        = info.getSession("NAME_LOC");
        name_eng        = info.getSession("NAME_ENG");
            
        try {
            
            BDAP_CNT = et_chkIsBDAP(ctx, BID_NO, BID_COUNT); //입찰신청자료(BDAP)에 공급업체가 존재하는지 체크
            if(BDAP_CNT == null) {
                bdap_enable = "N";
                bdap_flag = "";
            } else {
                bdap_enable = BDAP_CNT.substring(0, 1);
                bdap_flag = BDAP_CNT.substring(2, 3);
            }
            
            Logger.debug.println(userid,this,"BDAP_CNT"+BDAP_CNT+","+bdap_enable+","+bdap_flag+".");
            
            if(bdap_enable.equals("Y")) { //  이미 bdap에 데이터가 들어가 있다.
                sql = new StringBuffer();
            
                String[][] recvData = new String[1][];
            
                String[] tmp = {USER_NAME, USER_POSITION, USER_PHONE, USER_MOBILE, USER_EMAIL, HOUSE_CODE, BID_NO, BID_COUNT, company};
            
                recvData[0] = tmp;
            
                sql.append(" UPDATE ICOYBDAP                                          \n");
                sql.append(" SET    APP_DATE = TO_CHAR(SYSDATE,'YYYYMMDD')            \n");
                sql.append("       ,APP_TIME = TO_CHAR(SYSDATE,'HH24MISS')            \n");
                sql.append("       ,USER_NAME= ?                                      \n");
                sql.append("       ,USER_POSITION= ?                                  \n");
                sql.append("       ,USER_PHONE= ?                                     \n");
                sql.append("       ,USER_MOBILE= ?                                    \n");
                sql.append("       ,USER_EMAIL= ?                                     \n");
            
                if (bdap_flag.equals(" ")) {
                    sql.append("       ,UNT_FLAG= 'N'                                 \n");
                    sql.append("       ,ACHV_FLAG= 'Y'                                \n");
                    sql.append("       ,FINAL_FLAG= 'Y'                               \n");
                }
            
                sql.append(" WHERE  HOUSE_CODE = ?                                    \n");
                sql.append("  AND   BID_NO     = ?                                    \n");
                sql.append("  AND   BID_COUNT  = ?                                    \n");
                sql.append("  AND   VENDOR_CODE  = ?                                  \n");
            
                sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
                String[] type = {"S","S","S","S","S","S","S","S","S"};
            
                rtn = sm.doUpdate(recvData, type);
            } else {
            
                sql = new StringBuffer();
            
                sql.append(" INSERT INTO ICOYBDAP (                                                        \n");
                sql.append("                         HOUSE_CODE              ,                             \n");
                sql.append("                         BID_NO                  ,                             \n");
                sql.append("                         BID_COUNT               ,                             \n");
                sql.append("                         VENDOR_CODE             ,                             \n");
                sql.append("                         STATUS                  ,                             \n");
                sql.append("                         ADD_DATE                ,                             \n");
                sql.append("                         ADD_TIME                ,                             \n");
                sql.append("                         ADD_USER_ID             ,                             \n");
                sql.append("                         ADD_USER_NAME_LOC       ,                             \n");
                sql.append("                         ADD_USER_NAME_ENG       ,                             \n");
                sql.append("                         ADD_USER_DEPT           ,                             \n");
                sql.append("                         APP_DATE                ,                             \n");
                sql.append("                         APP_TIME                ,                             \n");
                sql.append("                         EXPLAN_FLAG             ,                             \n");
                sql.append("                         UNT_FLAG                ,                             \n");
                sql.append("                         ACHV_FLAG               ,                             \n");
                sql.append("                         FINAL_FLAG              ,                             \n");
                sql.append("                         INCO_REASON             ,                             \n");
                sql.append("                         GUAR_TYPE               ,                             \n");
                sql.append("                         ATTACH_NO               ,                             \n");
                sql.append("                         USER_NAME               ,                             \n");
                sql.append("                         USER_POSITION           ,                             \n");
                sql.append("                         USER_PHONE              ,                             \n");
                sql.append("                         USER_MOBILE             ,                             \n");
                sql.append("                         USER_EMAIL                                             \n");
                sql.append(" ) VALUES (                                                                    \n");
                sql.append("                         ?,                                                    \n");
                sql.append("                         ?,                                                    \n");
                sql.append("                         ?,                                                    \n");
                sql.append("                         ?,                                                    \n");
                sql.append("                         'C'           ,                -- STATUS              \n");
                sql.append("                         TO_CHAR(SYSDATE,'YYYYMMDD'),   -- ADD_DATE            \n");
                sql.append("                         TO_CHAR(SYSDATE,'HH24MISS'),   -- ADD_TIME            \n");
                sql.append("                         ?             ,                -- ADD_USER_ID         \n");
                sql.append("                         ?             ,                -- ADD_USER_NAME_LOC   \n");
                sql.append("                         ?             ,                -- ADD_USER_NAME_ENG   \n");
                sql.append("                         ?             ,                -- ADD_USER_DEPT       \n");
                sql.append("                         TO_CHAR(SYSDATE,'YYYYMMDD'),   -- APP_DATE            \n");
                sql.append("                         TO_CHAR(SYSDATE,'HH24MISS'),   -- APP_TIME            \n");
                sql.append("                         ''            ,                -- EXPLAN_FLAG         \n");
                sql.append("                         'N'            ,               -- UNT_FLAG            \n");
                sql.append("                         'Y'            ,               -- ACHV_FLAG           \n");
                sql.append("                         'Y'            ,               -- FINAL_FLAG          \n");
                sql.append("                         ''            ,                -- INCO_REASON         \n");
                sql.append("                         ''            ,                -- GUAR_TYPE           \n");
                sql.append("                         ''            ,                -- ATTACH_NO           \n");
                sql.append("                         ?             ,                -- USER_NAME           \n");
                sql.append("                         ?             ,                -- USER_POSITION       \n");
                sql.append("                         ?             ,                -- USER_PHONE          \n");
                sql.append("                         ?             ,                -- USER_MOBILE         \n");
                sql.append("                         ?                              -- USER_EMAIL          \n");
                sql.append(" )                                                                             \n");
            
                sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
                String[] type = {"S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "S","S","S"          };
            
                String[][] dataAP={{
                                    HOUSE_CODE       ,
                                    BID_NO           ,
                                    BID_COUNT        ,
                                    company          ,
                                    USER_ID          ,
                                    name_loc         ,
                                    name_eng         ,
                                    dept             ,
                                    USER_NAME        ,
                                    USER_POSITION    ,
                                    USER_PHONE       ,
                                    USER_MOBILE      ,
                                    USER_EMAIL
                                    }};
            
                rtn = sm.doInsert(dataAP, type);
            }
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }   
        return rtn;
    }       
            
            
    private String et_chkIsBDAP(ConnectionContext ctx, String BID_NO, String BID_COUNT) throws Exception
    {       
        String rtn = "";
        String value = null;
            
        StringBuffer sql = new StringBuffer();
            
        sql.append(" SELECT                                                                \n");
        sql.append("       CASE WHEN COUNT(VENDOR_CODE) > 0 THEN 'Y' ELSE 'N' END ||'@'||   \n");
        sql.append("       NVL(FINAL_FLAG, ' ')   AS IS_YN    \n");
        sql.append("   FROM  ICOYBDAP                                                      \n");
        sql.append(" WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'             \n");
        sql.append("  AND BID_NO      = '"+BID_NO+"'                                    \n");
        sql.append("  AND BID_COUNT   = '"+BID_COUNT+"'                                 \n");
        sql.append("  AND VENDOR_CODE   = '"+info.getSession("COMPANY_CODE")+"'          \n");
        sql.append(" GROUP BY  FINAL_FLAG                                \n");
            
        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            value = sm.doSelect((String[])null);
            
            SepoaFormater wf = new SepoaFormater(value);
            
            if(wf.getRowCount() == 0 ){
                rtn = null;
            } else {
            	rtn = wf.getValue(0,0);
            }
            
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }   
        return rtn;
    }       
            
    private int et_setBid(ConnectionContext ctx, String BID_NO, String BID_COUNT,  String VOTE_COUNT, String ATTACH_NO,
                                                 String BID_AMT_ENC, String CERTV, String TIMESTAMP, String SIGN_CERT,
                                                 String CHOICE_ESTM_NUM1, String CHOICE_ESTM_NUM2, String CHOICE_ESTM_NUM3, String CHOICE_ESTM_NUM4) throws Exception
    {       
        int rtn = 0;
            
        StringBuffer sql = new StringBuffer();
        SepoaSQLManager sm = null;
            
        HOUSE_CODE      = info.getSession("HOUSE_CODE");
        company         = info.getSession("COMPANY_CODE");
        dept            = info.getSession("DEPARTMENT");
        String USER_ID  = info.getSession("ID");
        name_loc        = info.getSession("NAME_LOC");
        name_eng        = info.getSession("NAME_ENG");
            
        try {
            
            sql.append(" INSERT INTO ICOYBDVO (                                             \n");
            sql.append("                         HOUSE_CODE            ,                    \n");
            sql.append("                         BID_NO                ,                    \n");
            sql.append("                         BID_COUNT             ,                    \n");
            sql.append("                         VOTE_COUNT            ,                    \n");
            sql.append("                         VENDOR_CODE           ,                    \n");
            sql.append("                         STATUS                ,                    \n");
            sql.append("                         ADD_DATE              ,                    \n");
            sql.append("                         ADD_TIME              ,                    \n");
            sql.append("                         ADD_USER_ID           ,                    \n");
            sql.append("                         ADD_USER_NAME_LOC     ,                    \n");
            sql.append("                         ADD_USER_NAME_ENG     ,                    \n");
            sql.append("                         ADD_USER_DEPT         ,                    \n");
            sql.append("                         VOTE_DATE             ,                    \n");
            sql.append("                         VOTE_TIME             ,                    \n");
            sql.append("                         BID_AMT_ENC           ,                    \n"); // 암호화된 금액이 들어감
            //sql.append("                         BID_AMT               ,                    \n");
            
            sql.append("                         CERTV                 ,                    \n");
            sql.append("                         TIMESTAMP             ,                    \n");
            sql.append("                         SIGN_CERT             ,                    \n");
            
            sql.append("                         ATTACH_NO,                                 \n");
            
            sql.append("                         CHOICE_ESTM_NUM1,                          \n");
            sql.append("                         CHOICE_ESTM_NUM2,                          \n");
            sql.append("                         CHOICE_ESTM_NUM3,                          \n");
            sql.append("                         CHOICE_ESTM_NUM4                           \n");
            
            sql.append(" ) VALUES (                                                         \n");
            sql.append("                         '"+HOUSE_CODE+"',                          \n");
            sql.append("                         '"+BID_NO+"'                ,              \n");
            sql.append("                         '"+BID_COUNT+"'             ,              \n");
            sql.append("                         "+VOTE_COUNT+"              ,              \n");
            sql.append("                         '"+company+"'   ,                          \n");
            sql.append("                         'C'                   ,                    \n");
            sql.append("                         TO_CHAR(SYSDATE,'YYYYMMDD'),               \n");
            sql.append("                         TO_CHAR(SYSDATE,'HH24MISS'),               \n");
            sql.append("                         '"+USER_ID+"'          ,                   \n");
            sql.append("                         '"+name_loc+"'         ,                   \n");
            sql.append("                         '"+name_eng+"'         ,                   \n");
            sql.append("                         '"+dept+"'             ,                   \n");
            sql.append("                         TO_CHAR(SYSDATE,'YYYYMMDD'),               \n");
            sql.append("                         TO_CHAR(SYSDATE,'HH24MISS'),               \n");
            sql.append("                         '"+BID_AMT_ENC+"'          ,                   \n"); // 암호화된 금액이 들어감 (임시로 실제금액을 넣음)
            //sql.append("                         '"+BID_AMT+"'          ,                   \n");
            
            sql.append("                         '"+CERTV+"'            ,                   \n");
            sql.append("                         '"+TIMESTAMP +"'       ,                   \n");
            sql.append("                         '"+SIGN_CERT+"'        ,                   \n");
            
            sql.append("                         '"+ATTACH_NO+"'        ,                   \n");
            
            sql.append("                         '"+CHOICE_ESTM_NUM1+"' ,                   \n");
            sql.append("                         '"+CHOICE_ESTM_NUM2+"' ,                   \n");
            sql.append("                         '"+CHOICE_ESTM_NUM3+"' ,                   \n");
            sql.append("                         '"+CHOICE_ESTM_NUM4+"'                            \n");
            sql.append(" )                                                                  \n");
            
            sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            rtn = sm.doInsert((String[][])null, null);
            
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }   
        return rtn;
    }       
            
	public SepoaOut getResultList(String[] data)
    {       
		try{
            
			String rtn = et_getResultList(data);
            
	        setStatus(1);
	        setValue(rtn);
            
            rtn = et_getDBTime();
			setValue(rtn);
            
			setMessage(msg.getMessage("0000"));
            
		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}   
            
		return getSepoaOut();
	}       
            
	private String et_getResultList(String[] data) throws Exception
	{       
            
        lang             = info.getSession("LANGUAGE");
        ctrl_code        = info.getSession("CTRL_CODE");
            
        String house_code       = data[0];
        String from_date        = data[1];
        String to_date          = data[2];
        String ann_no           = data[3];
        String ann_item         = data[4];
        String bid_flag         = data[5];
        String settle_vendor    = data[6];
            
   		ConnectionContext ctx = getConnectionContext();
            
        String rtn = "";
            
        StringBuffer sql = new StringBuffer();
            
        sql.append(" SELECT                                                                                                                      \n");
        
        sql.append("    (SELECT NAME_LOC FROM ICOMVNGL                                        \n");
        sql.append("      WHERE HOUSE_CODE = PG.HOUSE_CODE                                    \n");
        sql.append("      AND   VENDOR_CODE = (SELECT VENDOR_CODE FROM ICOYBDVO               \n");
        sql.append("                              WHERE  HOUSE_CODE = PG.HOUSE_CODE           \n");
        sql.append("                              AND    BID_NO     = PG.BID_NO               \n");
        sql.append("                              AND    BID_COUNT  = PG.BID_COUNT            \n");
        sql.append("                              AND    VOTE_COUNT = PG.VOTE_COUNT           \n");
        sql.append("                              AND    BID_CANCEL = 'N'                     \n");
        sql.append("                              AND    BID_STATUS = 'SB'                    \n");
        sql.append("                              AND    STATUS IN ('C', 'R')                 \n");
        sql.append("                              )) AS SETTLE_VENDOR,                        \n");
        
        sql.append("         HD.ANN_NO           ,                                                                                               \n");
        sql.append("         HD.ANN_ITEM         ,                                                                                               \n");
        sql.append("         GETICOMCODE2(HD.HOUSE_CODE, 'M994', HD.CONT_TYPE1)                                              as CONT_TYPE1_TEXT,    --입찰방법         \n");
        sql.append("         GETICOMCODE2(HD.HOUSE_CODE, 'M993', HD.CONT_TYPE2)                                              as CONT_TYPE2_TEXT,    --낙찰방법         \n");
        sql.append("         TO_CHAR(TO_DATE(PG.BID_BEGIN_DATE||PG.BID_BEGIN_TIME, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI') AS BID_BEGIN_DATE , \n");
        sql.append("         TO_CHAR(TO_DATE(PG.BID_END_DATE||PG.BID_END_TIME, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI') AS BID_END_DATE ,       \n");
//        sql.append("         GETICOMCODE2(HD.HOUSE_CODE, 'M976', HD.BID_STATUS)    AS STATUS_TEXT,                                               \n");
//        sql.append("         DECODE(VO.BID_STATUS, 'SB', 'Y', 'NB', 'N') AS SETTLE_FLAG,                                                         \n");
        sql.append("         DECODE(HD.BID_STATUS, 'SB','낙찰', GETICOMCODE2(HD.HOUSE_CODE, 'M976', HD.BID_STATUS))    AS STATUS_TEXT,               \n");
        sql.append("         DECODE(VO.BID_STATUS, 'SB', 'Y', 'NB', 'N', 'NE', '협상중') AS SETTLE_FLAG,                                                      \n");
        sql.append("         DT.CUR,                                                                                                             \n");
        
 //       sql.append("         VO.BID_AMT AS SETTLE_AMT,			\n");
 
       sql.append("		(SELECT BID_AMT_enc FROM ICOYBDVO    \n");           
       sql.append("		 WHERE  HOUSE_CODE = PG.HOUSE_CODE   \n");        
       sql.append("		 AND    BID_NO     = PG.BID_NO       \n");        
       sql.append("		 AND    BID_COUNT  = PG.BID_COUNT    \n");        
       sql.append("		 AND    VOTE_COUNT = PG.VOTE_COUNT   \n");        
       sql.append("		 AND    BID_CANCEL = 'N'             \n");        
       sql.append("		 AND    BID_STATUS = 'SB'            \n");        
       sql.append("		 AND    STATUS IN ('C', 'R')         \n");        
       sql.append("		 ) AS SETTLE_AMT,               \n");
        
        //sql.append("         DECODE(VO.BID_STATUS, 'SB', VO.BID_AMT, 'NB', '', 'NE', '') AS SETTLE_AMT,                                                    \n");
        
        sql.append("         HD.BID_NO,                                                                                                          \n");
        sql.append("         HD.BID_COUNT,                                                                                                       \n");
        sql.append("         PG.VOTE_COUNT,                                                                                                      \n");
        sql.append("         HD.BID_STATUS AS STATUS,                                                                                            \n");
        sql.append(" 		 DECODE(HD.BID_STATUS ,'NB' , '유찰사유 : ' ||  HD.NB_REASON ,'NE', '협상순위 : ' || TO_CHAR(VO.NE_ORDER) ,  '' ) AS REMARK    \n");                                                                                
        sql.append(" 		,DECODE( VO.BID_STATUS , 'SB' , NVL(HD.CONT_STATUS, 'N') , 'N' ) AS CONT_STATUS                                                \n");
        sql.append(" 		,vo.bid_amt_enc as bid_pay_confirm_amt     \n");
//        sql.append("         CASE HD.BID_STATUS                                                                                                 \n");
//        sql.append("              WHEN 'NB' THEN '유찰사유 : ' || HD.NB_REASON                                                                     \n");
//        sql.append("              WHEN 'NE' THEN '협상순위 : ' || TO_CHAR(VO.NE_ORDER)                                                             \n");
//        sql.append("              ELSE '' END AS REMARK                                                                                          \n");
//        sql.append("         ,CASE VO.BID_STATUS WHEN 'SB' THEN NVL(HD.CONT_STATUS, 'N') ELSE 'N' END AS CONT_STATUS                                                                                            \n");
        sql.append("         ,HD.ANN_VERSION                                                                                            \n");   //2010.10.27추가
        sql.append(" FROM  ICOYBDHD HD, ICOYBDDT DT, ICOYBDPG PG, ICOYBDVO VO, ICOYBDAP AP           , icomvngl gl                                             \n");
        sql.append(" WHERE PG.HOUSE_CODE  = HD.HOUSE_CODE       and gl.vendor_code = ap.vendor_code                                                                                       \n");
        sql.append(" <OPT=S,S> AND   HD.HOUSE_CODE  = ?     </OPT>                                                                               \n");
        sql.append(" AND   PG.BID_NO      = HD.BID_NO                                                                                            \n");
        sql.append(" AND   PG.BID_COUNT   = HD.BID_COUNT                                                                                         \n");
        sql.append(" AND   DT.HOUSE_CODE  = HD.HOUSE_CODE                                                                                        \n");
        sql.append(" AND   DT.BID_NO      = HD.BID_NO                                                                                            \n");
        sql.append(" AND   DT.BID_COUNT   = HD.BID_COUNT                                                                                         \n");
        sql.append(" AND   DT.ITEM_SEQ    = '000001'                                                                                             \n");
        sql.append(" AND   VO.HOUSE_CODE  = PG.HOUSE_CODE                                                                                        \n");
        sql.append(" AND   VO.BID_NO      = PG.BID_NO                                                                                            \n");
        sql.append(" AND   VO.BID_COUNT   = PG.BID_COUNT                                                                                         \n");
        sql.append(" AND   VO.VENDOR_CODE = '"+info.getSession("COMPANY_CODE")+"'                                                                \n");
        sql.append(" AND   VO.BID_CANCEL  = 'N'                                                                                                  \n");
        sql.append(" AND   VO.HOUSE_CODE  = AP.HOUSE_CODE                                                                                        \n");
        sql.append(" AND   VO.VENDOR_CODE = AP.VENDOR_CODE                                                                                        \n");
        sql.append(" AND   VO.HOUSE_CODE  = AP.HOUSE_CODE                                                                                        \n");
        sql.append(" AND   VO.BID_NO      = AP.BID_NO                                                                                        \n");
        sql.append(" AND   VO.BID_COUNT   = AP.BID_COUNT                                                                                        \n");
        sql.append(" AND   AP.STATUS  IN ('C', 'R')                                                                                              \n");
        sql.append(" AND   AP.BID_CANCEL  = 'N'                                                                                                  \n");
            
        sql.append(" <OPT=S,S> AND   (PG.BID_BEGIN_DATE BETWEEN  ?  </OPT>  <OPT=S,S> AND  ? </OPT>  <OPT=S,S>                                   \n");
        sql.append("     OR PG.BID_END_DATE BETWEEN  ?  </OPT>  <OPT=S,S> AND  ?)     </OPT>                                                     \n");
        sql.append(" <OPT=S,S> AND   HD.ANN_NO    =  ?                                                                                           \n");
        sql.append(" <OPT=S,S> AND   HD.ANN_ITEM  LIKE  '%'||?||'%' </OPT>                                                                       \n");
//        sql.append(" <OPT=S,S> AND   HD.BID_STATUS  =  ?     </OPT>                                                                              \n");
        sql.append(" <OPT=S,S> AND   VO.BID_STATUS  =  ?     </OPT>                                                                              \n");
        sql.append(" <OPT=S,S> AND  (SELECT NAME_LOC FROM ICOMVNGL                                                                               \n");
        sql.append("       WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'                                                                \n");
        sql.append("       AND   VENDOR_CODE = (SELECT VENDOR_CODE FROM ICOYBDVO                                                                 \n");
        sql.append("                            WHERE  HOUSE_CODE = PG.HOUSE_CODE                                                                \n");
        sql.append("                            AND    BID_NO     = PG.BID_NO                                                                    \n");
        sql.append("                            AND    BID_COUNT  = PG.BID_COUNT                                                                 \n");
        sql.append("                            AND    VOTE_COUNT = PG.VOTE_COUNT                                                                \n");
        sql.append("                            AND    BID_STATUS = 'SB'                                                                         \n");
        sql.append("                            AND    BID_CANCEL = 'N'                                                                          \n");
        sql.append("                            AND    STATUS IN ('C', 'R')                                                                      \n");
        sql.append("                            )) LIKE '%'||?||'%'    </OPT>                                                                    \n");
        sql.append(" AND   HD.BID_STATUS  IN ('SB', 'NB', 'NE')                                                                                        \n");
        sql.append(" AND   HD.SIGN_STATUS  IN ('C')                                                                                              \n");
        sql.append(" AND   HD.STATUS IN ('C' ,'R')                                                                                               \n");
        sql.append(" AND   PG.STATUS IN ('C' ,'R')                                                                                               \n");
        sql.append(" AND   VO.STATUS IN ('C' ,'R')                                                                                               \n");
        sql.append(" AND   HD.BID_TYPE = 'D'                                                                                                     \n");
		sql.append(" ORDER BY HD.ANN_NO DESC                                                               \n");
            
            
		try{
			SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            
            String[] args = {house_code, from_date, to_date, from_date, to_date, ann_no, ann_item, bid_flag, settle_vendor};
			rtn = sm.doSelect(args);
            
		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}   
		return rtn;
	}       
            
/////////////////////////////////////////////
	public SepoaOut getDBTime()
    {       
        String rtn = "";
		try{
            rtn = et_getDBTime();
			setValue(rtn);
            
			setMessage(msg.getMessage("0000"));
            
		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}   
            
		return getSepoaOut();
	}       
            
            
	private String et_getDBTime() throws Exception
	{       
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
            
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT to_char(sysdate, 'YYYYMMDDHH24MISS')              \n");
		sql.append("   FROM dual                                              \n");
            
		try {
			SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            
			rtn = sm.doSelect((String[])null);
		} catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}   
		return rtn;
	}       
            
            
    public SepoaOut getBDHD_VnInfo(String BID_NO, String BID_COUNT)
    {       
        String rtnData = null;
        try {
            rtnData = et_getBDHD_VnInfo(BID_NO, BID_COUNT);
            setStatus(1);
            setValue(rtnData);
            
            setMessage(msg.getMessage("0000"));
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }   
        return getSepoaOut();
    }       
            
    private String et_getBDHD_VnInfo(String BID_NO, String BID_COUNT) throws Exception
    {       
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
            
        StringBuffer sql = new StringBuffer();
            
        sql.append(" SELECT                                                               												\n");
        sql.append("        NAME_LOC AS VENDOR_NAME,                                      												\n");
        sql.append("        IRS_NO,                                                       												\n");
        sql.append("        CITY_TEXT||' '||ADDRESS_LOC AS ADDRESS,                       												\n");
        sql.append("        PHONE_NO1 AS TEL_NO,                                          												\n");
        sql.append("        CEO_NAME_LOC,                                                 												\n");
        sql.append("        COMPANY_REG_NO,                                               												\n");
        sql.append("        (SELECT COUNT(*) FROM ICOYBDAP WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"' \n");
        sql.append("        AND BID_NO      = '"+BID_NO+"'                                                        \n");
        sql.append("        AND BID_COUNT   = '"+BID_COUNT+"'                                                     \n");
        sql.append("        AND BID_CANCEL  = 'N'                                                                 \n");
        sql.append("        AND STATUS  IN ('C', 'R')                                                             \n");
        sql.append("        AND VENDOR_CODE = '"+info.getSession("COMPANY_CODE")+"'                               \n");
        sql.append("        )         AS BDAP_CNT,                                                                \n");
        sql.append("        USER_NAME,                                                                       			\n");
        sql.append("        USER_POSITION,                                                                   			\n");
        sql.append("        USER_PHONE,                                                                      			\n");
        sql.append("        USER_MOBILE,                                                                     			\n");
        sql.append("        USER_EMAIL ,                                                                     			\n");
        sql.append("        (SELECT QTEE.QUARANTEE FROM ICOMQTEE QTEE																							\n");
        sql.append("          WHERE QTEE.BID_NO = '"+BID_NO+"' AND QTEE.BID_COUNT = '"+BID_COUNT+"'								\n");
        sql.append("            AND QTEE.VENDOR_CODE = '"+info.getSession("COMPANY_CODE")+"') AS QTEE,     				\n");
        sql.append("        (SELECT  ESTM_KIND   FROM   ICOYBDHD                                             			\n");
        sql.append("          WHERE BID_NO = '"+BID_NO+"'  AND BID_COUNT = '"+BID_COUNT+"' ) AS ESTM_KIND,     		\n");
        sql.append("        (SELECT  CD.TEXT2       FROM   ICOYBDHD HD,  ICOMCODE CD                              \n");
        sql.append("          WHERE HD.BID_NO = '"+BID_NO+"'  AND HD.BID_COUNT = '"+BID_COUNT+"'                  \n");
        sql.append("            AND CD.HOUSE_CODE  = '"+info.getSession("HOUSE_CODE")+"'                       		\n");
        sql.append("            AND CD.TYPE  = 'M959'      AND HD.ESTM_KIND = CD.CODE ) AS ESTM_KIND_NM,    			\n");
        
        sql.append("        (SELECT  CONT_TYPE1   FROM   ICOYBDHD                                             			\n");
        sql.append("          WHERE BID_NO = '"+BID_NO+"'  AND BID_COUNT = '"+BID_COUNT+"' ) AS CONT_TYPE1,     		\n");
        
        sql.append("        (SELECT  CONT_TYPE2   FROM   ICOYBDHD                                             			\n");
        sql.append("          WHERE BID_NO = '"+BID_NO+"'  AND BID_COUNT = '"+BID_COUNT+"' ) AS CONT_TYPE2     		\n");
        
        sql.append(" FROM ICOMVNGL VN,                                                             								\n");
        sql.append("           (SELECT VENDOR_CODE, USER_NAME, USER_POSITION, USER_PHONE, USER_MOBILE, USER_EMAIL \n");
        sql.append("              FROM ICOYBDAP                                                                   \n");
        sql.append("             WHERE BID_NO = '"+BID_NO+"'  AND BID_COUNT = '"+BID_COUNT+"' )AP                 \n");
        
        
        
        
        sql.append(" WHERE VN.VENDOR_CODE = AP.VENDOR_CODE(+)                                                \n");
        
        sql.append(" AND VN.HOUSE_CODE  = '"+info.getSession("HOUSE_CODE")+"'           													\n");
        
        
        sql.append(" AND VN.HOUSE_CODE  = '"+info.getSession("HOUSE_CODE")+"'           													\n");
        
        
            
            
//      sql.append(" FROM ICOMVNGL VN LEFT OUTER JOIN                                                             \n");
//      sql.append("           (SELECT VENDOR_CODE, USER_NAME, USER_POSITION, USER_PHONE, USER_MOBILE, USER_EMAIL \n");
//      sql.append("              FROM ICOYBDAP                                                                   \n");
//      sql.append("             WHERE BID_NO = '"+BID_NO+"'  AND BID_COUNT = '"+BID_COUNT+"' )AP                 \n");
//      sql.append("      ON VN.VENDOR_CODE = AP.VENDOR_CODE                                                      \n");
//          
//      sql.append(" WHERE VN.HOUSE_CODE  = '"+info.getSession("HOUSE_CODE")+"'           												\n");
        sql.append(" AND   VN.VENDOR_CODE = '"+info.getSession("COMPANY_CODE")+"'         												\n");
        sql.append(" AND   VN.STATUS IN ('C', 'R')                                        												\n");
            
        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            
            rtn = sm.doSelect((String[])null);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }   
        return rtn;
    }       
            
    public SepoaOut getBDHD_Estm(String BID_NO, String BID_COUNT)
    {       
        String rtnData = null;
        try {
            rtnData = et_getBDHD_Estm(BID_NO, BID_COUNT);
            setStatus(1);
            setValue(rtnData);
            
            setMessage(msg.getMessage("0000"));
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }   
        return getSepoaOut();
    }       
            
    private String et_getBDHD_Estm(String BID_NO, String BID_COUNT) throws Exception
    {       
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
            
        StringBuffer sql = new StringBuffer();
            
        sql.append(" SELECT                                    \n");
        sql.append("        ESTM_MAX,                          \n");
        sql.append("        ESTM_VOTE                          \n");
        sql.append(" FROM ICOYBDHD                             \n");
        sql.append(" WHERE BID_NO    = '"+BID_NO+"'            \n");
        sql.append("   AND BID_COUNT = '"+BID_COUNT+"'         \n");
            
        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            
            rtn = sm.doSelect((String[])null);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }   
        return rtn;
    }       
}   
            