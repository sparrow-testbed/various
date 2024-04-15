package dt.bidd;
 
import java.util.*; 
import java.lang.reflect.*;
import java.io.*;

import javax.mail.*; 
import javax.mail.internet.*;
import javax.activation.*;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import mail.mail;

 
public class p1015d extends SepoaService
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

	private sepoa.fw.msg.Message msg = new sepoa.fw.msg.Message(info,"p10_pra");

	public p1015d(String opt,SepoaInfo info) throws SepoaServiceException
	{
		super(opt,info);
		setVersion("1.0.0");
	}

	public SepoaOut getRegisterList(String[] data)
    {
		try{

			String rtn = et_getRegisterList(data);

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

	private String et_getRegisterList(String[] data) throws Exception
	{

        lang             = info.getSession("LANGUAGE");
        ctrl_code        = info.getSession("CTRL_CODE");

        String house_code = data[0];
        String from_date  = data[1];
        String to_date    = data[2];
        String ann_no     = data[3];
        String ann_item   = data[4];
        String CHANGE_USER_NAME   = data[5];

   		ConnectionContext ctx = getConnectionContext();

        String rtn = "";

        StringBuffer sql = new StringBuffer();

        sql.append(" SELECT                                                                                                                 \n");
        sql.append("          HD.ANN_NO           ,                                                                                         \n");
        sql.append("          HD.ANN_ITEM         ,                                                                                         \n");
        sql.append("          HD.ANN_DATE         ,                                                                                         \n");
        sql.append("          TO_CHAR(TO_DATE(APP_BEGIN_DATE||APP_BEGIN_TIME, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI') AS APP_BEGIN_DATE,  \n");
        sql.append("          TO_CHAR(TO_DATE(APP_END_DATE||APP_END_TIME, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI') AS APP_END_DATE ,       \n");
        sql.append("          HD.CHANGE_USER_NAME_LOC,                                                                                      \n");
        sql.append("          GETICOMCODE2(HD.HOUSE_CODE, 'M985',                                                                           \n");
        sql.append("            (CASE                                                                                                       \n");
        sql.append("                WHEN TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) >= TO_NUMBER(HD.APP_BEGIN_DATE||HD.APP_BEGIN_TIME)  \n");
        sql.append("            AND    TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) < CASE WHEN TO_NUMBER(HD.APP_END_DATE||HD.APP_END_TIME)                  \n");
        sql.append("                                                                               > TO_NUMBER(NVL(PG.BID_END_DATE||PG.BID_END_TIME, 0))       \n");
        sql.append("                                                                            THEN TO_NUMBER(HD.APP_END_DATE||HD.APP_END_TIME)               \n");
        sql.append("                                                                            ELSE TO_NUMBER(NVL(PG.BID_END_DATE||PG.BID_END_TIME, 0))       \n");
        sql.append("                                                                            END                                                            \n");
        sql.append("                THEN 'BP' -- 진행중                                                                                     \n");
        sql.append("                ELSE                                                                                                    \n");
        sql.append("                    DECODE(HD.BID_STATUS, 'RC', 'BC', 'SR', 'BC', 'BT')                                                 \n");
        sql.append("             END)                                                                                                       \n");
        sql.append("          )    AS STATUS_TEXT,                                                                                          \n");
        sql.append("          HD.SIGN_PERSON_ID,                                                                                            \n");
        sql.append("          HD.SIGN_STATUS,                                                                                               \n");
        sql.append("          HD.BID_STATUS,                                                                                                \n");
        sql.append("          HD.BID_NO,                                                                                                    \n");
        sql.append("          HD.BID_COUNT,                                                                                                 \n");
        sql.append("          HD.CHANGE_USER_ID,                                                                                            \n");
        sql.append("         (CASE                                                                                                          \n");
        sql.append("            WHEN TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) >= TO_NUMBER(HD.APP_BEGIN_DATE||HD.APP_BEGIN_TIME)      \n");
        sql.append("            AND    TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) < CASE WHEN TO_NUMBER(HD.APP_END_DATE||HD.APP_END_TIME)                  \n");
        sql.append("                                                                               > TO_NUMBER(NVL(PG.BID_END_DATE||PG.BID_END_TIME, 0))       \n");
        sql.append("                                                                            THEN TO_NUMBER(HD.APP_END_DATE||HD.APP_END_TIME)               \n");
        sql.append("                                                                            ELSE TO_NUMBER(NVL(PG.BID_END_DATE||PG.BID_END_TIME, 0))       \n");
        sql.append("                                                                            END                                                            \n");

        sql.append("            THEN 'BP' -- 진행중                                                                                         \n");
        sql.append("            ELSE                                                                                                        \n");
        sql.append("                DECODE(HD.BID_STATUS, 'RC', 'BC', 'SR', 'BC', 'BT')                                                     \n");
        sql.append("          END) AS STATUS,                                                                                               \n");
        sql.append("          HD.PR_NO,                                                                                                     \n");
        sql.append("          HD.CTRL_CODE                                                                                                  \n");
        sql.append("        , GETICOMCODE2(HD.HOUSE_CODE, 'M974', HD.CONT_TYPE1) AS CONT_TYPE1_TEXT          \n");
        sql.append("        , GETICOMCODE2(HD.HOUSE_CODE, 'M973', HD.CONT_TYPE2) AS CONT_TYPE2_TEXT          \n");
        sql.append("        , (SELECT COUNT(VENDOR_CODE)                                    \n");
        sql.append("            FROM ICOYBDAP                                               \n");
        sql.append("            WHERE HOUSE_CODE = '"+HOUSE_CODE+"'                         \n");
        sql.append("              AND BID_NO = HD.BID_NO                                    \n");
        sql.append("              AND BID_COUNT = HD.BID_COUNT) AS VENDOR_COUNT             \n");
        sql.append("          , (SELECT SUM(PR_AMT)                                                     \n");
        sql.append("            	FROM ICOYBDDT                                                       \n");
        sql.append("            	WHERE HOUSE_CODE = '100'                                            \n");
        sql.append("               AND BID_NO = HD.BID_NO                                               \n");
        sql.append("               AND BID_COUNT = HD.BID_COUNT) AS SUM_AMT                             \n");
        sql.append("          , (SELECT CUR                                                             \n");
        sql.append("            	FROM ICOYBDDT                                                       \n");
        sql.append("            	WHERE HOUSE_CODE = '100'                                            \n");
        sql.append("               AND BID_NO = HD.BID_NO                                               \n");
        sql.append("               AND BID_COUNT = HD.BID_COUNT                                         \n");
        sql.append("               AND ROWNUM < 2) AS CUR                                               \n");
        sql.append(" FROM  ICOYBDHD HD  LEFT OUTER JOIN ICOYBDPG PG                                                                                            \n");
        sql.append("       ON    HD.HOUSE_CODE = PG.HOUSE_CODE                                                                                                 \n");
        sql.append("         AND HD.BID_NO = PG.BID_NO                                                                                                         \n");
        sql.append("         AND HD.BID_COUNT = PG.BID_COUNT                                                                                                   \n");
        sql.append("  <OPT=S,S> WHERE   HD.HOUSE_CODE  = ?     </OPT>                                                                         \n");
        sql.append("  <OPT=S,S> AND   HD.APP_END_DATE BETWEEN  ?     </OPT>                                                                 \n");
        sql.append("  <OPT=S,S> AND  ?     </OPT>                                                                                           \n");
        sql.append("  <OPT=S,S> AND   HD.ANN_NO    =  ?     </OPT>                                                                          \n");
        sql.append("  <OPT=S,S> AND   HD.ANN_ITEM  LIKE  '%'||?||'%' </OPT>                                                                 \n");
        sql.append("  AND   TO_NUMBER(HD.APP_BEGIN_DATE||HD.APP_BEGIN_TIME) <= TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'))               \n");
        sql.append("  AND   HD.SIGN_STATUS  IN ('C')                                                                                        \n");
        sql.append("  AND   HD.BID_STATUS   IN ('AC', 'UC', 'QR', 'RC', 'SR', 'SC', 'QC')                                                                     \n");
        sql.append("  <OPT=S,S> AND   HD.CHANGE_USER_NAME_LOC  LIKE  '%'||?||'%' </OPT>                                                                 \n");

        sql.append("  AND   HD.BID_TYPE = 'D'                                                                                               \n");
        sql.append("  AND   HD.STATUS IN ('C' ,'R')                                                                                         \n");
        sql.append("  AND   PG.STATUS IN ('C' ,'R')                                                                                         \n");

		sql.append(" ORDER BY HD.ANN_DATE DESC                                                  \n");


		try{
			SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());

            String[] args = {house_code, from_date, to_date, ann_no, ann_item, CHANGE_USER_NAME};
			rtn = sm.doSelect(args);

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	public SepoaOut getBDAPDisplay(String BID_NO, String BID_COUNT, String flag)
    {
		try{

			String rtn = et_getBDAPDisplay(BID_NO, BID_COUNT, flag);

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

	private String et_getBDAPDisplay(String BID_NO, String BID_COUNT, String flag) throws Exception
	{

        lang             = info.getSession("LANGUAGE");
        ctrl_code        = info.getSession("CTRL_CODE");

   		ConnectionContext ctx = getConnectionContext();

        String rtn = "";

        StringBuffer sql = new StringBuffer();

        sql.append(" SELECT                                                                                                        \n");
        sql.append("         ROWNUM      AS NO,                                                                                    \n");
        sql.append("         VN.VENDOR_NAME_LOC AS VENDOR_NAME,                                                                           \n");
        sql.append("         AD.CEO_NAME_LOC,                                                                                      \n");
        sql.append("         TO_CHAR(TO_DATE(APP_DATE||APP_TIME, 'YYYYMMDDHH24MISS'), 'YYYY/MM/DD HH24:MI') AS APP_DATE_TIME,      \n");
        sql.append("         AP.UNT_FLAG,                                                                                          \n");
        sql.append("         AP.ACHV_FLAG,                                                                                         \n");
        sql.append("         AP.FINAL_FLAG,                                                                                        \n");
        sql.append("         AP.INCO_REASON,                                                                                       \n");
        sql.append("         AP.EXPLAN_FLAG,                                                                                       \n");
        sql.append("         GETICOMCODE2(AP.HOUSE_CODE, 'M967', AP.GUAR_TYPE) AS GUAR_TYPE_TEXT,                                  \n");
        sql.append("         AP.BID_CANCEL,                                                                                        \n");
        sql.append("         AP.VENDOR_CODE                                                                                        \n");
        sql.append(" FROM ICOYBDAP AP, ICOMVNGL VN  ,ICOMADDR AD                                                                               \n");
        sql.append(" WHERE AP.HOUSE_CODE  = '"+info.getSession("HOUSE_CODE")+"'                                                    \n");
        sql.append(" AND   AP.BID_NO      = '"+BID_NO+"'                                                                           \n");
        sql.append(" AND   AP.BID_COUNT   = '"+BID_COUNT+"'                                                                        \n");
        sql.append(" AND   AP.HOUSE_CODE  = VN.HOUSE_CODE                                                                          \n");
        sql.append(" AND   AP.VENDOR_CODE = VN.VENDOR_CODE                                                                         \n");
        sql.append(" AND   AP.BID_CANCEL = 'N'                                                                                     \n");

        sql.append(" AND   VN.HOUSE_CODE=AD.HOUSE_CODE  \n");
        sql.append(" AND   VN.VENDOR_CODE=AD.CODE_NO  \n");
        sql.append(" AND   AD.CODE_TYPE='2'  \n");

        
        sql.append(" AND   AP.STATUS IN ('C', 'R')                                                                                 \n");
        sql.append(" AND   VN.STATUS IN ('C', 'R')                                                                                 \n");

        if(flag.equals("Y")) { // 입찰을 하기로 한 업체건만 조회 하려면....
            sql.append(" AND   AP.APP_DATE IS NOT NULL                                                                             \n");
        }

		try{
			SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());

			rtn = sm.doSelect((String[])null);

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	public SepoaOut setBidStatus(String BID_NO, String BID_COUNT, String[][] recvData, String BID_STATUS, String[][] setBDAP, String[][] setPRHD)
	{
		try{
       		ConnectionContext ctx = getConnectionContext();

            String status = et_chkMagam(ctx, BID_NO, BID_COUNT);

            if (!status.equals("BT")){
                setStatus(0);
                setMessage(msg.getMessage("0063"));   // 입찰마감이나 유찰하실 수 없는 상태입니다.
                return getSepoaOut();
            }
            int rtnBDAP = 0;
			//int rtn = et_setBidStatus(ctx, recvData);

            if(setBDAP.length >0 ) {// 참가신청 업체가 0일수도 있음으로...
			    rtnBDAP = et_setBDAP(ctx, setBDAP);
            }

            if(BID_STATUS.equals("NB")) {
    			//int rtnPRHD = et_setStatusPRHD(ctx, setPRHD);
            }

            setStatus(1);
            setValue("");
            if(BID_STATUS.equals("NB")) {
                setMessage(msg.getMessage("0048"));
            } else {
                setMessage(msg.getMessage("0000"));
            }
            Commit();

		}catch(Exception e) {
            try {
                Rollback();
				setStatus(0);
                if(BID_STATUS.equals("RC")) {
				    setMessage(msg.getMessage("0047"));
                } else {
				    setMessage(msg.getMessage("0049"));
                }
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0036"));
		}

		return getSepoaOut();
	}

    private String et_chkMagam(ConnectionContext ctx, String BID_NO, String BID_COUNT) throws Exception
    {
        String rtn = "";
        String value = null;

        StringBuffer sql = new StringBuffer();

        sql.append(" SELECT                                                                         \n");
        sql.append("      (CASE WHEN HD.BID_STATUS IN (SELECT CODE FROM ICOMCODE                    \n");
        sql.append("                                    WHERE HOUSE_CODE = '" + info.getSession("HOUSE_CODE") + "' AND TYPE = 'M962'  \n");
        sql.append("                                      AND TEXT3 BETWEEN  '3' AND '5' )          \n");
        sql.append("            THEN 'BT'  ELSE  'BC'     END) AS STATUS                            \n");
        sql.append("  FROM  ICOYBDHD HD                                                             \n");
        sql.append("  WHERE HD.HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'                     \n");
        sql.append("  AND HD.BID_NO       = '"+BID_NO+"'                                            \n");
        sql.append("  AND HD.BID_COUNT    = '"+BID_COUNT+"'                                         \n");
        sql.append("  AND HD.STATUS       IN ('C', 'R')                                             \n");

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

    private int et_setBidStatus(ConnectionContext ctx, String[][] recvData) throws Exception
    {
        int rtn = 0;

        StringBuffer sql = new StringBuffer();
        SepoaSQLManager sm = null;

        try {

            sql.append(" UPDATE ICOYBDHD SET                                                 \n");
            sql.append("       PREFERRED_BIDDER      = ?,                                    \n");
            sql.append("       BID_STATUS            = ?,                                    \n");
            sql.append("       NB_REASON             = ?,                                    \n");
            sql.append("       STATUS                = ?,                                    \n");
            sql.append("       CHANGE_USER_ID        = ?,                                    \n");
            sql.append("       CHANGE_USER_DEPT      = ?,                                    \n");
            sql.append("       CHANGE_USER_NAME_ENG  = ?,                                    \n");
            sql.append("       CHANGE_USER_NAME_LOC  = ?,                                    \n");
            sql.append("       CHANGE_DATE           = TO_CHAR(SYSDATE,'YYYYMMDD'),          \n");
            sql.append("       CHANGE_TIME           = TO_CHAR(SYSDATE,'HH24MISS'),          \n");
            sql.append("       SR_ATTACH_NO          = ?,                                    \n");
            sql.append("       SB_REASON          	 = ?                                     \n");
            sql.append("  WHERE HOUSE_CODE           = ?                                     \n");
            sql.append("    AND BID_NO               = ?                                     \n");
            sql.append("    AND BID_COUNT            = ?                                     \n");

            sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S","S","S","S",
            		         "S","S","S","S","S",
            		         "S","S","S"};

            rtn = sm.doUpdate(recvData, type);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }

    private int et_setBidStatusForecast(ConnectionContext ctx, String[][] recvData) throws Exception
    {
        int rtn = 0;

        try {
    		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

	        String[] type = {"S","S","S","S","S"};

            rtn = sm.doUpdate(recvData, type);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }

    private int et_setBDAP(ConnectionContext ctx, String[][] setBDAP) throws Exception
    {
        int rtn = 0;

        StringBuffer sql = new StringBuffer();
        SepoaSQLManager sm = null;

        try {

            sql.append(" UPDATE ICOYBDAP SET                                                 \n");
            sql.append("       STATUS                = ?,                                    \n");
            sql.append("       UNT_FLAG              = ?,                                    \n");
            sql.append("       ACHV_FLAG             = ?,                                    \n");
            sql.append("       FINAL_FLAG            = ?,                                    \n");
            sql.append("       INCO_REASON           = ?,                                    \n");
            sql.append("       BID_CANCEL            = ?                                     \n");
            sql.append("  WHERE HOUSE_CODE           = ?                                     \n");
            sql.append("    AND BID_NO               = ?                                     \n");
            sql.append("    AND BID_COUNT            = ?                                     \n");
            sql.append("    AND VENDOR_CODE          = ?                                     \n");

            sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S","S","S","S",
                            "S","S","S","S","S"};

            rtn = sm.doUpdate(setBDAP, type);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }

    private int et_setStatusPRHD(ConnectionContext ctx, String[][] PrData) throws Exception
    {
        int rtn = 0;

        StringBuffer sql = new StringBuffer();
        SepoaSQLManager sm = null;

        try {

            sql.append(" UPDATE ICOYPRHD SET                                                \n");
            sql.append("        BID_STATUS           = ?                                    \n");
            sql.append("  WHERE HOUSE_CODE           = ?                                    \n");
            sql.append("    AND PR_NO                = ?                                    \n");

            sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S","S"};

            rtn = sm.doUpdate(PrData, type);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    private int et_setStatusPRDT(ConnectionContext ctx, String[][] PrData) throws Exception
    {
        int rtn = 0;

        StringBuffer sql = new StringBuffer();
        SepoaSQLManager sm = null;

        try {

            sql.append(" UPDATE  ICOYPRDT  PRDT                                          \n");
            sql.append("    SET  PREFERRED_BIDDER    = ?                             \n");
            sql.append("        ,BID_STATUS          = ?                             \n");
//          sql.append("        ,PR_PROCEEDING_FLAG  = DECODE(?, 'SB', 'E', 'NB', 'P', 'PB', 'P')\n"); // 낙찰이면 품의대기, 유찰, 우선협상선정 이면 접수현황으로 백.
            sql.append("        ,PR_PROCEEDING_FLAG  = DECODE(?, 'SB', 'E', 'NB', 'P', 'PB', 'E')\n"); // 낙찰, 우선협상선정이면 품의대기, 유찰이면 접수현황으로 백.
            sql.append("  WHERE  HOUSE_CODE          = ?                             \n");
            sql.append("    AND ( PR_NO, PR_SEQ)  IN (                            \n");
            sql.append("            SELECT  PR_NO, PR_SEQ  FROM  ICOYBDDT       \n");     
            sql.append("             WHERE  HOUSE_CODE= PRDT.HOUSE_CODE                            \n");
            sql.append("               AND  BID_NO    = ?                            \n");
            sql.append("               AND  BID_COUNT = ?                            \n");
            sql.append("            )                                                \n");

            sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S","S","S","S","S"};

            rtn = sm.doUpdate(PrData, type);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }


	public SepoaOut getProgressList(String[] data)
    {
		try{

			String rtn = et_getProgressList(data);

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

	private String et_getProgressList(String[] data) throws Exception
	{

        lang             = info.getSession("LANGUAGE");
        ctrl_code        = info.getSession("CTRL_CODE");

        String house_code = data[0];
        String from_date  = data[1];
        String to_date    = data[2];
        String ann_no     = data[3];
        String ann_item   = data[4];
        String bid_flag   = data[5];
        String CHANGE_USER_NAME   = data[6];

   		ConnectionContext ctx = getConnectionContext();

        String rtn = "";

        Logger.debug.println(info.getSession("ID"), this, "bid_flag ================>" + bid_flag);

        StringBuffer sql = new StringBuffer();
        sql.append("  SELECT *                                                                                                              \n");
        sql.append("  FROM(                                                                                                              \n");
        sql.append("  SELECT                                                                                                               \n");
        sql.append("          HD.ANN_NO           ,                                                                                        \n");
        sql.append("          HD.ANN_ITEM         ,                                                                                        \n");
        sql.append("          HD.ANN_DATE         ,                                                                                        \n");
        sql.append("          TO_CHAR(TO_DATE(HD.APP_BEGIN_DATE||HD.APP_BEGIN_TIME, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI') AS APP_BEGIN_DATE, \n");
        sql.append("          TO_CHAR(TO_DATE(HD.APP_END_DATE||HD.APP_END_TIME, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI') AS APP_END_DATE ,      \n");
        sql.append("          TO_CHAR(TO_DATE(PG.BID_BEGIN_DATE||PG.BID_BEGIN_TIME, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI') AS BID_BEGIN_DATE, \n");
        sql.append("          TO_CHAR(TO_DATE(PG.BID_END_DATE||PG.BID_END_TIME, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI') AS BID_END_DATE ,      \n");
        sql.append("          HD.CHANGE_USER_NAME_LOC,                                                                                     \n");
        sql.append("          GETICOMCODE2(HD.HOUSE_CODE, 'M978',                                                                                       \n");
        sql.append("              CASE WHEN HD.BID_STATUS = 'SR'THEN 'SR'                                                                               \n");
        sql.append("                   WHEN HD.BID_STATUS IN ('AC', 'UC')                                                                               \n");
        sql.append("                       THEN CASE                                                                                                    \n");
        sql.append("                         WHEN TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) < TO_NUMBER(HD.APP_END_DATE||HD.APP_END_TIME)          \n");
        sql.append("                              THEN 'RC'                                                                                             \n");
        sql.append("                            ELSE 'SR'                                                                                               \n");
        sql.append("                            END                                                                                                     \n");
        sql.append("                   ELSE CASE                                                                                                        \n");
        sql.append("                          WHEN TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) >= TO_NUMBER(PG.BID_BEGIN_DATE||PG.BID_BEGIN_TIME)    \n");
        sql.append("                                  AND TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) < TO_NUMBER(PG.BID_END_DATE||PG.BID_END_TIME)  \n");
        sql.append("                          THEN 'P'                                                                                                  \n");
        sql.append("                          WHEN TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) >= TO_NUMBER(PG.BID_END_DATE||PG.BID_END_TIME)    	\n");
        sql.append("                          THEN 'BC'                                                                                                 \n");
        sql.append("                          ELSE 'SC' END                                                                                             \n");
        sql.append("                   END )    AS STATUS_TEXT,                                                                                         \n");
        sql.append("          HD.SIGN_PERSON_ID,                                                                                           	\n");
        sql.append("          HD.SIGN_STATUS,                                                                                              	\n");
        sql.append("          HD.BID_STATUS,                                                                                               	\n");
        sql.append("          GETICOMCODE2(HD.HOUSE_CODE, 'M962', HD.BID_STATUS) AS BID_STATUS_TEXT,										\n");
        sql.append("          HD.BID_NO,                                                                                                   	\n");
        sql.append("          HD.BID_COUNT,                                                                                                	\n");
        sql.append("          PG.VOTE_COUNT,                                                                                               	\n");
        sql.append("          HD.CHANGE_USER_ID,                                                                                           	\n");
        sql.append("                    CASE WHEN HD.BID_STATUS = 'SR'THEN 'SR'                                                                                  \n");
        sql.append("                         WHEN HD.BID_STATUS IN ('AC', 'UC')                                                                                  \n");
        sql.append("                              THEN CASE                                                                                                      \n");
        sql.append("                                   WHEN TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) < TO_NUMBER(HD.APP_END_DATE||HD.APP_END_TIME)         \n");
        sql.append("                                        THEN 'RC'                                                                                            \n");
        sql.append("                                        ELSE 'SR'                                                                                            \n");
        sql.append("                                      END                                                                                                    \n");
        sql.append("                       ELSE CASE                                                                                                             \n");
        sql.append("                                    WHEN TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) >= TO_NUMBER(PG.BID_BEGIN_DATE||PG.BID_BEGIN_TIME)   \n");
        sql.append("                                            AND TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) < TO_NUMBER(PG.BID_END_DATE||PG.BID_END_TIME) \n");
        sql.append("                                    THEN 'P'                                                                                                 \n");
        sql.append("                                    ELSE 'SC' END                                                                                            \n");
        sql.append("                         END  AS STATUS,                                                                                                     \n");
        sql.append("          HD.PR_NO,                                                                                                    	\n");
        sql.append("          HD.CONT_TYPE1,																								\n");
  		sql.append("          HD.CONT_TYPE2,																								\n");
  		sql.append("          GETICOMCODE2(HD.HOUSE_CODE, 'M974', HD.CONT_TYPE1) AS CONT_TYPE1_TEXT,										\n");
        sql.append("          GETICOMCODE2(HD.HOUSE_CODE, 'M973', HD.CONT_TYPE2) AS CONT_TYPE2_TEXT,										\n");
        sql.append("          PG.BID_END_DATE||PG.BID_END_TIME    AS BID_END_DATE_VALUE,                                                   	\n");
        sql.append("          HD.CTRL_CODE                                                                                                 	\n");
        sql.append("  FROM  ICOYBDHD HD, ICOYBDPG PG                                                                                       	\n");
        sql.append("  WHERE PG.HOUSE_CODE  = HD.HOUSE_CODE                                                                                 	\n");
        sql.append("  AND   HD.HOUSE_CODE  = '" + house_code + "'                                                                       	\n");
        sql.append("  AND   PG.BID_NO      = HD.BID_NO                                                                                     	\n");
        sql.append("  AND   PG.BID_COUNT   = HD.BID_COUNT                                                                                  	\n");
        sql.append("  AND  (PG.BID_END_DATE BETWEEN  '" + from_date + "' AND  '" + to_date + "'                                             \n");
        sql.append("        OR  PG.BID_END_DATE IS NULL                                                                                    	\n");
        sql.append("       )                                                                                                      			\n");
        sql.append("  AND   HD.BID_STATUS IN ('RC', 'SR', 'SC', 'AC', 'UC')                                                               \n");
        /*
	    if(bid_flag.equals("SR")) { // -- 1단계평가
	        sql.append("  AND HD.BID_STATUS = 'SR'                                                                                  		\n");
	    } else if(bid_flag.equals("RC")) { // 공고중
	        sql.append("  AND HD.BID_STATUS IN ('AC','UC')                                                                                 	\n");
	    } else if(bid_flag.equals("SC")) { // 입찰대기
	        sql.append("  AND TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) <  TO_NUMBER(PG.BID_BEGIN_DATE||PG.BID_BEGIN_TIME)       		\n");
	        sql.append("  AND HD.BID_STATUS IN ('RC','SC')                                                                                  \n");
	    } else if(bid_flag.equals("P")) { // 입찰중
	        sql.append("  AND TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) >= TO_NUMBER(PG.BID_BEGIN_DATE||PG.BID_BEGIN_TIME)             \n");
	        sql.append("  AND TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')) <  TO_NUMBER(PG.BID_END_DATE||PG.BID_END_TIME)                  \n");
	        sql.append("  AND HD.BID_STATUS IN ('RC','SC')                                                                                  \n");
	    }
	    */
        sql.append("  AND   HD.SIGN_STATUS  IN ('C')                                                                                       	\n");
        sql.append("  AND   HD.STATUS 		IN ('C' ,'R')                                                                                   \n");
        sql.append("  AND   PG.STATUS 		IN ('C' ,'R')                                                                                   \n");
        sql.append("  AND   HD.BID_TYPE 	= 'D'                                                                                           \n");
        sql.append("  AND   HD.CONT_TYPE2 	= 'TE'                                                                                          \n");
        sql.append("  ORDER BY HD.ANN_NO DESC                                                                                              	\n");
        sql.append("  )                                                                                              						\n");
        sql.append("  WHERE 1=1                                                                                             				\n");
        sql.append("  <OPT=S,S> AND   ANN_NO    		=  ?        		</OPT>															\n");
        sql.append("  <OPT=S,S> AND   ANN_ITEM  		LIKE  '%'||?||'%' 	</OPT>															\n");
        sql.append("  <OPT=S,S> AND   STATUS 			= ?                	</OPT>															\n");
        sql.append("  <OPT=S,S> AND   CHANGE_USER_ID 	= ?					</OPT>															\n");

		try {
			SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
			
            String[] args = {ann_no,ann_item,bid_flag,CHANGE_USER_NAME};
			rtn = sm.doSelect(args);
		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	public SepoaOut getBDAPDisplay2(String BID_NO, String BID_COUNT, String VOTE_COUNT)
    {
		try{

			String rtn = et_getBDAPDisplay2(BID_NO, BID_COUNT, VOTE_COUNT);

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

	private String et_getBDAPDisplay2(String BID_NO, String BID_COUNT, String VOTE_COUNT) throws Exception
	{
        String rtn = "";

   		ConnectionContext ctx = getConnectionContext();

		try{
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("house_code",	info.getSession("HOUSE_CODE"));

			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

            String[] args = {BID_NO, BID_COUNT};
            rtn = sm.doSelect(args);

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	public SepoaOut getSpecDisplay(String BID_NO, String BID_COUNT, String FLAG)
    {
		try{

			String rtn = et_getSpecDisplay(BID_NO, BID_COUNT, FLAG);

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

	private String et_getSpecDisplay(String BID_NO, String BID_COUNT, String FLAG) throws Exception
	{

        lang             = info.getSession("LANGUAGE");
        ctrl_code        = info.getSession("CTRL_CODE");

   		ConnectionContext ctx = getConnectionContext();

        String rtn = "";

        StringBuffer sql = new StringBuffer();

        if(FLAG.equals("D")) { // 규경평가 상세조회용
            sql.append(" SELECT                                                                 \n");
            sql.append("         ROWNUM      AS NO,                                             \n");
            sql.append("         VN.VENDOR_NAME_LOC AS VENDOR_NAME,                                    \n");
            sql.append("         AD.CEO_NAME_LOC,                                               \n");
            sql.append("         GETICOMCODE2(SP.HOUSE_CODE, 'M001' , VN.COUNTRY) AS COUNTRY,   \n");
            sql.append("         VN.PHONE_NO1 AS TEL,                                           \n");
            sql.append("         SP.SPEC_FLAG,                                                  \n");
            sql.append("         DECODE(NVL(VO.ATTACH_NO, ''), '',                              \n");
            sql.append("                AP.ATTACH_NO, VO.ATTACH_NO) AS ATTACH_NO,                                   \n");
            sql.append("         (SELECT COUNT(*) FROM ICOMATCH                                 \n");
            sql.append("          WHERE DOC_NO = DECODE(NVL(VO.ATTACH_NO, ''), '',              \n");
            sql.append("                        AP.ATTACH_NO, VO.ATTACH_NO)) AS ATTACH_CNT,                                 \n");
            sql.append("          SP.VENDOR_CODE                                                 \n");
            sql.append("          ,AP.USER_NAME                                                 \n");
            sql.append("          ,AP.USER_POSITION                                                 \n");
            sql.append("          ,AP.USER_MOBILE                                                 \n");
            sql.append("          ,AP.USER_EMAIL                                                 \n");
            sql.append(" FROM ICOYBDSP SP, ICOYBDVO VO, ICOMVNGL VN,ICOYBDAP AP,ICOMADDR AD  \n");
            sql.append(" WHERE  VN.HOUSE_CODE = AP.HOUSE_CODE(+)              \n");
            sql.append(" AND VN.VENDOR_CODE = AP.VENDOR_CODE(+)            \n");
            sql.append(" AND VN.BID_NO = AP.BID_NO(+)                      \n");
            sql.append(" AND VN.BID_COUNT = AP.BID_COUNT(+)                \n");
            sql.append(" AND AND    BID_CANCEL = 'N'                    \n");
            sql.append(" AND AP.STATUS IN ('C','R')                     \n");

            sql.append(" AND VN.HOUSE_CODE = AD.HOUSE_CODE \n");
            sql.append(" AND VN.VENDOR_CODE = AD.CODE_NO \n");
            sql.append(" AND AD.CODE_TYPE = '2' \n");
            
            
            sql.append(" AND SP.HOUSE_CODE  = '"+info.getSession("HOUSE_CODE")+"'             \n");
            sql.append(" AND   SP.BID_NO      = '"+BID_NO+"'                                    \n");
            sql.append(" AND   SP.BID_COUNT   = '"+BID_COUNT+"'                                 \n");
            sql.append(" AND   VO.HOUSE_CODE  = SP.HOUSE_CODE                                   \n");
            sql.append(" AND   VO.BID_NO      = SP.BID_NO                                       \n");
            sql.append(" AND   VO.BID_COUNT   = SP.BID_COUNT                                    \n");
            sql.append(" AND   VO.VOTE_COUNT  = SP.VOTE_COUNT                                   \n");
            sql.append(" AND   VO.VENDOR_CODE = SP.VENDOR_CODE                                  \n");
            sql.append(" AND   SP.HOUSE_CODE  = VN.HOUSE_CODE                                   \n");
            sql.append(" AND   SP.VENDOR_CODE = VN.VENDOR_CODE                                  \n");
            sql.append(" AND   VO.BID_CANCEL = 'N'                                              \n");
            sql.append(" AND   SP.STATUS IN ('C', 'R')                                          \n");
            sql.append(" AND   VO.STATUS IN ('C', 'R')                                          \n");
            sql.append(" AND   VN.STATUS IN ('C', 'R')                                          \n");
        } else if(FLAG.equals("C")) { // 규경평가 생성조회용
            sql.append(" SELECT                                                                 \n");
            sql.append("         ROWNUM      AS NO,                                             \n");
            sql.append("         VN.VENDOR_NAME_LOC AS VENDOR_NAME,                                    \n");
            sql.append("         AD.CEO_NAME_LOC,                                               \n");
            sql.append("         GETICOMCODE2(AP.HOUSE_CODE, 'M001' , VN.COUNTRY) AS COUNTRY,   \n");
            sql.append("         AP.USER_PHONE AS TEL,                                           \n");
            sql.append("         SP.SPEC_FLAG,            \n");
            sql.append("         (SELECT ATTACH_NO            									\n");	          
			sql.append("          FROM ICOYBDVO													\n");                                                
		    sql.append("		  WHERE  HOUSE_CODE = AP.HOUSE_CODE								\n");	
			sql.append("            AND    BID_NO     = AP.BID_NO                               \n");  
			sql.append("            AND    BID_COUNT  = AP.BID_COUNT                            \n");  
			sql.append("            AND    VENDOR_CODE= AP.VENDOR_CODE                          \n");  
			sql.append("            AND    BID_CANCEL = 'N'                                     \n"); 
			sql.append("            AND    STATUS IN ('C', 'R') 								\n");
			sql.append("         ) 								AS VO_ATTACH_NO					\n");
			sql.append("         ,AP.ATTACH_NO 					AS AP_ATTACH_NO                 \n");     	                                                
			sql.append("         ,(SELECT COUNT(*)												\n");
			sql.append("           FROM ICOMATCH                      							\n");
			sql.append("           WHERE DOC_NO = (SELECT ATTACH_NO FROM ICOYBDVO               \n");      
			sql.append("         					WHERE  HOUSE_CODE = AP.HOUSE_CODE           \n");                 
			sql.append("         					  AND    BID_NO     = AP.BID_NO            	\n");                     
			sql.append("         					  AND    BID_COUNT  = AP.BID_COUNT          \n");     	               
			sql.append("         					  AND    VENDOR_CODE= AP.VENDOR_CODE        \n");                    
			sql.append("         					  AND    BID_CANCEL = 'N'                   \n");                    
			sql.append("         					  AND    STATUS IN ('C', 'R'))				\n"); 
			sql.append("         	)	AS VO_ATTACH_CNT										\n");
			sql.append("         ,(SELECT COUNT(*) 												\n");
            sql.append("		   FROM ICOMATCH		                                 		\n");
			sql.append("           WHERE DOC_NO = AP.ATTACH_NO									\n");
			sql.append("         ) AS AP_ATTACH_CNT,               								\n");
            sql.append("           AP.VENDOR_CODE                                               \n");
            sql.append("          ,AP.USER_NAME                                                 \n");
            sql.append("          ,AP.USER_POSITION                                             \n");
            sql.append("          ,AP.USER_MOBILE                                               \n");
            sql.append("          ,AP.USER_EMAIL                                                \n");
             sql.append("          ,SP.TECH_POINT                                               \n");
            sql.append("          ,SP.AMT_POINT                                                 \n");

			sql.append("          ,SP.TEST_POINT      											\n");
            sql.append("          ,(SELECT STANDARD_POINT                                       \n");
            sql.append("          	FROM ICOYBDHD                                               \n");
            sql.append("          	WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'      \n");
            sql.append("          	  AND BID_NO = AP.BID_NO                                    \n");
            sql.append("          	  AND BID_COUNT = AP.BID_COUNT) AS STANDARD_POINT           \n");
            sql.append("          ,SP.REASON                                                  	\n");
            sql.append(" FROM ICOYBDAP AP                                          				\n");
            sql.append(" ,ICOYBDSP SP   , ICOMVNGL VN ,ICOMADDR AD  \n");
            sql.append("  WHERE  SP.HOUSE_CODE(+) = AP.HOUSE_CODE      \n");
            sql.append("   AND SP.BID_NO(+) = AP.BID_NO                \n");
            sql.append("   AND SP.BID_COUNT(+) = AP.BID_COUNT          \n");
            sql.append("   AND SP.VENDOR_CODE(+) = AP.VENDOR_CODE      \n");
            sql.append("   AND SP.STATUS(+) != 'D'             \n");

            sql.append(" AND VN.HOUSE_CODE = AD.HOUSE_CODE \n");
            sql.append(" AND VN.VENDOR_CODE = AD.CODE_NO \n");
            sql.append(" AND AD.CODE_TYPE = '2' \n");
            
            sql.append(" AND   AP.HOUSE_CODE  = '"+info.getSession("HOUSE_CODE")+"'             \n");
            sql.append(" AND   AP.BID_NO      = '"+BID_NO+"'                                    \n");
            sql.append(" AND   AP.BID_COUNT   = '"+BID_COUNT+"'                                 \n");
            sql.append(" AND   AP.HOUSE_CODE  = VN.HOUSE_CODE                                   \n");
            sql.append(" AND   AP.VENDOR_CODE = VN.VENDOR_CODE                                  \n");
            sql.append(" AND   AP.APP_DATE IS NOT NULL                                          \n");
            sql.append(" AND   AP.BID_CANCEL = 'N'                                              \n");
            sql.append(" AND   AP.STATUS IN ('C', 'R')                                          \n");
            sql.append(" AND   VN.STATUS IN ('C', 'R')                                          \n");
        }


		try{
			SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());

			rtn = sm.doSelect((String[])null);

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	public SepoaOut setSpecEstimate(String[][] setBDPG, String[][] recvData, String[][] setBDSP, String[][] setBDAP, String bdap_ins_ck)
	{
		try{
       		ConnectionContext ctx = getConnectionContext();


       		int rtnBDPG = et_setBDPG(ctx, setBDPG);

			int rtn = et_setBidStatus(ctx, recvData);

			
            if(bdap_ins_ck.equals("Y")){

                int rtnBDAP = et_setInsertBDAP(ctx, setBDAP);
            }

            int rtnBDSP = et_setInsertBDSP(ctx, setBDSP);


            int rtnPRDT = et_setUpdPRDT(ctx, setBDPG[0][7], setBDPG[0][8]);


            setStatus(1);
            setValue(rtn+"");
            setMessage(msg.getMessage("0064"));
            Commit();

		}catch(Exception e) {
            try {
                Rollback();
				setStatus(0);
			    setMessage(msg.getMessage("0036"));
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0036"));
		}

		return getSepoaOut();
	}




    private int et_setInsertBDAP(ConnectionContext ctx,
                                    String[][] setBDAP ) throws Exception
    {
        int rtn = 0;

        StringBuffer sql = new StringBuffer();

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
        sql.append("                         INCO_REASON                                           \n");
        sql.append("                         ,USER_NAME                                            \n");
        sql.append("                         ,USER_POSITION                                        \n");
        sql.append("                         ,USER_PHONE                                           \n");
        sql.append("                         ,USER_MOBILE                                          \n");
        sql.append("                         ,USER_EMAIL                                           \n");
        sql.append(" ) VALUES (                                                                    \n");
        sql.append("                         ?,                                                    \n");
        sql.append("                         ?,                                                    \n");
        sql.append("                         ?,                                                    \n");
        sql.append("                         ?,                                                    \n");
        sql.append("                         'C'           ,                -- STATUS              \n");
        sql.append("                         TO_CHAR(SYSDATE,'YYYYMMDD'),   -- ADD_DATE            \n");
        sql.append("                         TO_CHAR(SYSDATE,'HH24MISS'),   -- ADD_TIME            \n");
        sql.append("                         '"+info.getSession("ID")+"',                           \n");
        sql.append("                         '"+info.getSession("NAME_LOC")+"',                     \n");
        sql.append("                         '"+info.getSession("NAME_ENG")+"',                     \n");
        sql.append("                         '"+info.getSession("DEPARTMENT")+"',                   \n");
        sql.append("                         TO_CHAR(SYSDATE,'YYYYMMDD'),                -- APP_DATE            \n");
        sql.append("                         TO_CHAR(SYSDATE,'HH24MISS'),                -- APP_TIME            \n");
        sql.append("                         ''            ,                -- EXPLAN_FLAG         \n");
        sql.append("                         'N'           ,                -- UNT_FLAG            \n");
        sql.append("                         'Y'           ,                -- ACHV_FLAG           \n");
        sql.append("                         'Y'           ,                -- FINAL_FLAG          \n");
        sql.append("                         ''                             -- INCO_REASON         \n");
        sql.append("                         ,?                                                    \n");
        sql.append("                         ,?                                                    \n");
        sql.append("                         ,?                                                    \n");
        sql.append("                         ,?                                                    \n");
        sql.append("                         ,?                                                    \n");
        sql.append(" )                                                                             \n");

        try {
            Logger.debug.println(info.getSession("ID"), this,"sm====111111111111111111111" );
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            Logger.debug.println(info.getSession("ID"), this,"sm=========>"+sm );

            String[] type = {"S","S","S","S","S", "S","S","S","S"};
            Logger.debug.println(info.getSession("ID"), this,"mode=========!!!!!!!!!!!!!!!!!!!!!!" );
            rtn = sm.doInsert(setBDAP, type);
            Logger.debug.println(info.getSession("ID"), this,"rtn=========>"+rtn );
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }






    private int et_setBDPG(ConnectionContext ctx, String[][] setBDPG
                                    ) throws Exception
    {
        int rtn = 0;
        StringBuffer sql = new StringBuffer();

        sql.append(" UPDATE ICOYBDPG SET             \n");
        sql.append("         BID_BEGIN_DATE = ?,     \n");
        sql.append("         BID_BEGIN_TIME = ?,     \n");
        sql.append("         BID_END_DATE   = ?,     \n");
        sql.append("         BID_END_TIME   = ?,     \n");
        sql.append("         OPEN_DATE      = ?,     \n");
        sql.append("         OPEN_TIME      = ?      \n");
        sql.append("  WHERE HOUSE_CODE      = ?      \n");
        sql.append("     AND BID_NO         = ?      \n");
        sql.append("     AND BID_COUNT      = ?      \n");
        sql.append("     AND VOTE_COUNT     = ?      \n");

        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S","S","S","S",
                            "S","S","S","S","S"
                            };

            rtn = sm.doInsert(setBDPG, type);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

    private int et_setInsertBDSP(ConnectionContext ctx, String[][] setBDSP) throws Exception
    {
        int rtn = 0;

        StringBuffer sql = new StringBuffer();
        SepoaSQLManager sm = null;

        try {

            sql.append(" INSERT INTO ICOYBDSP (                                         \n");
            sql.append("                     HOUSE_CODE                    ,            \n");
            sql.append("                     BID_NO                        ,            \n");
            sql.append("                     BID_COUNT                     ,            \n");
            sql.append("                     VOTE_COUNT                    ,            \n");
            sql.append("                     VENDOR_CODE                   ,            \n");
            sql.append("                     STATUS                        ,            \n");
            sql.append("                     ADD_DATE                      ,            \n");
            sql.append("                     ADD_TIME                      ,            \n");
            sql.append("                     ADD_USER_ID                   ,            \n");
            sql.append("                     ADD_USER_NAME_LOC             ,            \n");
            sql.append("                     ADD_USER_NAME_ENG             ,            \n");
            sql.append("                     ADD_USER_DEPT                 ,            \n");
            sql.append("                     SPEC_FLAG                                  \n");
            sql.append("                     ,TECH_POINT                                \n");
            sql.append("                     ,AMT_POINT                                 \n");
            sql.append("                     ,REASON                                  	\n");
            sql.append("                     ,TEST_POINT                                  	\n");
            sql.append(" ) VALUES (                                                     \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     TO_CHAR(SYSDATE,'YYYYMMDD')   ,            \n");
            sql.append("                     TO_CHAR(SYSDATE,'HH24MISS')   ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     ?                                          \n");
            sql.append("                     ,?                                          \n");
            sql.append("                     ,?                                          \n");
            sql.append("                     ,?                                          \n");
            sql.append("                     ,?                                          \n");
            sql.append(" )                                                              \n");

            sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S","S","S","S",
                            "S","S","S","S","S",
                            "S","S","S","S","S"};

            rtn = sm.doInsert(setBDSP, type);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }

	public SepoaOut doBidProcess(String[][] recvData, String BID_STATUS, String[][] sendPRHD, String[][] sendBDVO, String[][] sendBDES, String data_cnt, String[][] sendPRDT, String[] sendBDVT) {
		try{
       		ConnectionContext ctx = getConnectionContext();
			int rtn = et_setBidStatus(ctx, recvData);
            //int rtnPRHD = et_setStatusPRHD(ctx, sendPRHD);
            int rtnPRDT = et_setStatusPRDT(ctx, sendPRDT);
            if(Integer.parseInt(data_cnt) > 0) {
                int rtnBDVO = et_setBDVO(ctx, sendBDVO);
                int rtnBDVT = et_setBDVT(ctx, sendBDVT);
            }
            int rtnBDES = et_setBDES(ctx, sendBDES);

            setStatus(1);
            setValue(rtn+"");
            if(BID_STATUS.equals("NB")) {
                setMessage(msg.getMessage("0048"));
            } else if(BID_STATUS.equals("SB")){
            	//new mail("CONNECTION",info).sendEmailInChalNakchal(sendBDVO[0][5],sendBDVO[0][8]);	
            	////new smsAgent("CONNECTION",info).sendEmailInChalNakchal(sendBDVO[0][5],sendBDVO[0][8]);	
            	setMessage(msg.getMessage("0050"));
            } else {
                setMessage(msg.getMessage("0072"));
            }
            
            Commit();
		}catch(Exception e) {
            try {
                Rollback();
				setStatus(0);
                if(BID_STATUS.equals("NB")) {
				    setMessage(msg.getMessage("0049"));
                } else if(BID_STATUS.equals("SB")){
				    setMessage(msg.getMessage("0051"));
                } else {
                    setMessage(msg.getMessage("0073"));
                }
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0036"));
		}

		return getSepoaOut();
	}

    private int et_setMISStatus(ConnectionContext ctx, String[][] recvData) throws Exception
    { // 수정할것.
        int rtn = 0;

        StringBuffer sql = new StringBuffer();
        SepoaSQLManager sm = null;

        try {

            sql.append(" UPDATE ICOYBDHD SET                                                 \n");
            sql.append("       BID_STATUS            = ?,                                    \n");
            sql.append("       STATUS                = ?,                                    \n");
            sql.append("       CHANGE_USER_ID        = ?,                                    \n");
            sql.append("       CHANGE_USER_DEPT      = ?,                                    \n");
            sql.append("       CHANGE_USER_NAME_ENG  = ?,                                    \n");
            sql.append("       CHANGE_USER_NAME_LOC  = ?,                                    \n");
            sql.append("       CHANGE_DATE           = TO_CHAR(SYSDATE,'YYYYMMDD'),          \n");
            sql.append("       CHANGE_TIME           = TO_CHAR(SYSDATE,'HH24MISS')           \n");
            sql.append("  WHERE HOUSE_CODE           = ?                                     \n");
            sql.append("    AND BID_NO               = ?                                     \n");
            sql.append("    AND BID_COUNT            = ?                                     \n");

            sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S","S","S","S",
                            "S","S","S","S"};

            rtn = sm.doUpdate(recvData, type);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }

    private int et_setBDVO(ConnectionContext ctx,  String[][] recvData) throws Exception
    {
        int rtn = 0;

        StringBuffer sql = new StringBuffer();
        SepoaSQLManager sm = null;

        try {

            sql.append(" UPDATE ICOYBDVO             \n");
            sql.append(" SET    BID_STATUS = ? ,     \n");
            sql.append("        NE_ORDER   = ? ,     \n");
            sql.append("        BID_RANK   = ? ,     \n");
            sql.append("        BID_AMT    = ?       \n");
            sql.append(" WHERE  HOUSE_CODE = ?       \n");
            sql.append(" AND    BID_NO     = ?       \n");
            sql.append(" AND    BID_COUNT  = ?       \n");
            sql.append(" AND    VOTE_COUNT = ?       \n");
            sql.append(" AND    VENDOR_CODE= ?       \n");

            sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S","S","S","S",
                            "S","S","S","S"};

            rtn = sm.doUpdate(recvData, type);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }
    
    private int et_setBDVT(ConnectionContext ctx,  String[] recvData) throws Exception
    {
        int rtn = 0;
        String str = "";
        
        //StringBuffer sql = new StringBuffer();
        SepoaXmlParser wxp = null;
        SepoaSQLManager sm = null;
        SepoaFormater wf   = null;
    	Configuration SepoaCfg = new Configuration();
    	boolean useXecureFlag = SepoaCfg.getBoolean("Sepoa.UseXecure");


        // ICOYBDVT를 조회 후 복호화하여 업데이트
        try {

            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+ "_1");
            sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

            str = sm.doSelect(recvData);
            wf = new SepoaFormater(str);
           	String PASSWORD	= null;
            
        	/**
			 * 투찰금액 복호화(2011.12.19)
			 * Xecure를 사용하지 않을 경우 MD5를 통해 복호화한다.
			 */
			//EncDec crypt = null;
			String cryptValue = "";
			
            // 아이템별 투찰단가 복호화
            String HOUSE_CODE 	= "";
            String BID_NO 		= "";
            String BID_COUNT 	= "";
            String VOTE_COUNT 	= "";
            String VENDOR_CODE 	= "";
            String ITEM_SEQ 	= "";
            String BID_PRICE_ENC= "";
            String BID_PRICE	= "";
            String[][] updateBDVO = new String[wf.getRowCount()][];
            for(int i=0; i<wf.getRowCount(); i++){
            	
            	HOUSE_CODE		= wf.getValue("HOUSE_CODE", i);
            	BID_NO			= wf.getValue("BID_NO", i);
            	BID_COUNT		= wf.getValue("BID_COUNT", i);
            	VOTE_COUNT		= wf.getValue("VOTE_COUNT", i);
            	VENDOR_CODE		= wf.getValue("VENDOR_CODE", i);
            	ITEM_SEQ		= wf.getValue("ITEM_SEQ", i);
            	BID_PRICE_ENC	= wf.getValue("BID_PRICE_ENC", i);
            	
            	if(useXecureFlag) {
//	                EnvelopeData envelope 	= null;
//	                envelope = new EnvelopeData(new XecureConfig());
	            	PASSWORD = HOUSE_CODE+BID_NO+BID_COUNT+VOTE_COUNT+VENDOR_CODE+ITEM_SEQ;
//	            	BID_PRICE = envelope.keKeyDeEnvelopeData(PASSWORD.getBytes(),BID_PRICE_ENC);
            	} else {
//    				crypt = new EncDec();
//    				cryptValue = crypt.decrypt(BID_PRICE_ENC);
    				BID_PRICE = cryptValue;
            	}
            	
            	String[] tempBDVO = {
            						BID_PRICE
            					   ,HOUSE_CODE
            					   ,BID_NO
            					   ,BID_COUNT	
            				       ,VOTE_COUNT	
            					   ,VENDOR_CODE	
            					   ,ITEM_SEQ	
            					};
            	
            	updateBDVO[i] = tempBDVO;
            	
            }
            
            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+ "_2");
            sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
            String[] type = {"S","S","S","S","S","S","S"};
            rtn = sm.doUpdate(updateBDVO, type);

            
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }

    private int et_setBDES(ConnectionContext ctx,  String[][] recvData) throws Exception
    {
        int rtn = 0;

        StringBuffer sql = new StringBuffer();
        SepoaSQLManager sm = null;

        try {

            sql.append(" UPDATE ICOYBDES                                        \n");
            sql.append(" SET    ESTM_PRICE1          = ?                   ,    \n");
            sql.append("        FINAL_ESTM_PRICE     = ?                   ,    \n");
            sql.append("        STATUS               = ?                   ,    \n");
            sql.append("        CHANGE_DATE = TO_CHAR(SYSDATE,'YYYYMMDD')  ,    \n");
            sql.append("        CHANGE_TIME = TO_CHAR(SYSDATE,'HH24MISS')  ,    \n");
            sql.append("        CHANGE_USER_ID       = ?                   ,    \n");
            sql.append("        CHANGE_USER_NAME_LOC = ?                   ,    \n");
            sql.append("        CHANGE_USER_NAME_ENG = ?                   ,    \n");
            sql.append("        CHANGE_USER_DEPT     = ?                        \n");
            sql.append(" WHERE  HOUSE_CODE = ?                                  \n");
            sql.append(" AND    BID_NO     = ?                                  \n");
            sql.append(" AND    BID_COUNT  = ?                                  \n");

            sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S","S","S","S",
                            "S","S","S","S","S"};

            rtn = sm.doUpdate(recvData, type);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }

	public SepoaOut doReBid(String[][] sendBDPG, String[][]  sendBDSP, String[][] delBDPG, String[][] delBDSP, String[][] sendBDVO, String[] sendBDVT)
	{
		try{
       		ConnectionContext ctx = getConnectionContext();

			int rtn = et_setReBDPGCreate(ctx, sendBDPG);
            int rtn2 = et_setReBDSPCreate(ctx, sendBDSP);
            int rtn3 = et_delBDPG(ctx, delBDPG);
            int rtn4 = et_delBDSP(ctx, delBDSP);
            int rtn5 = et_delBDVO(ctx, delBDSP);
            int rtnBDVO = et_setBDVO(ctx, sendBDVO);
            int rtnBDVT = et_setBDVT(ctx, sendBDVT);

            setStatus(1);
            setValue(rtn+"");
            setMessage(msg.getMessage("0052"));

            Commit();
//                Rollback();
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
			setMessage(msg.getMessage("0036"));
		}

		return getSepoaOut();
	}

    private int et_setReBDPGCreate(ConnectionContext ctx, String[][] dataPG
                                    ) throws Exception
    {
        int rtn = 0;

        StringBuffer sql = new StringBuffer();

        sql.append(" INSERT INTO ICOYBDPG (                                                             \n");
        sql.append("                         HOUSE_CODE              ,                                  \n");
        sql.append("                         BID_NO                  ,                                  \n");
        sql.append("                         BID_COUNT               ,                                  \n");
        sql.append("                         VOTE_COUNT              ,                                  \n");
        sql.append("                         STATUS                  ,                                  \n");
        sql.append("                         ADD_DATE                ,                                  \n");
        sql.append("                         ADD_TIME                ,                                  \n");
        sql.append("                         ADD_USER_ID             ,                                  \n");
        sql.append("                         ADD_USER_NAME_LOC       ,                                  \n");
        sql.append("                         ADD_USER_NAME_ENG       ,                                  \n");
        sql.append("                         ADD_USER_DEPT           ,                                  \n");
        sql.append("                         BID_BEGIN_DATE          ,                                  \n");
        sql.append("                         BID_BEGIN_TIME          ,                                  \n");
        sql.append("                         BID_END_DATE            ,                                  \n");
        sql.append("                         BID_END_TIME            ,                                  \n");
        sql.append("                         BID_PLACE               ,                                  \n");
        sql.append("                         BID_ETC                 ,                                  \n");
        sql.append("                         OPEN_DATE               ,                                  \n");
        sql.append("                         OPEN_TIME                                                  \n");
        sql.append(" )  (                                                                               \n");
        sql.append(" SELECT                                                                             \n");
        sql.append("                         ?,                                                         \n");
        sql.append("                         ?,                                                         \n");
        sql.append("                         ?,                                                         \n");
        sql.append("                         ?,                                                         \n");
        sql.append("                         'C'           ,                -- STATUS                   \n");
        sql.append("                         TO_CHAR(SYSDATE,'YYYYMMDD'),   -- ADD_DATE                 \n");
        sql.append("                         TO_CHAR(SYSDATE,'HH24MISS'),   -- ADD_TIME                 \n");
        sql.append("                         ?             ,                -- ADD_USER_ID              \n");
        sql.append("                         ?             ,                -- ADD_USER_NAME_LOC        \n");
        sql.append("                         ?             ,                -- ADD_USER_NAME_ENG        \n");
        sql.append("                         ?             ,                -- ADD_USER_DEPT            \n");
        sql.append("                         ?             ,                -- BID_BEGIN_DATE           \n");
        sql.append("                         ?             ,                -- BID_BEGIN_TIME           \n");
        sql.append("                         ?             ,                -- BID_END_DATE             \n");
        sql.append("                         ?             ,                -- BID_END_TIME             \n");
        sql.append("                         BID_PLACE     ,                -- BID_PLACE                \n");
        sql.append("                         BID_ETC       ,                -- BID_ETC                  \n");
        sql.append("                         ?             ,                -- OPEN_DATE                \n");
        sql.append("                         ?                              -- OPEN_TIME                \n");
        sql.append(" FROM ICOYBDPG                                                                      \n");
        sql.append(" WHERE HOUSE_CODE = ?                                                               \n");
        sql.append(" AND   BID_NO     = ?                                                               \n");
        sql.append(" AND   BID_COUNT  = ?                                                               \n");
        sql.append(" AND   VOTE_COUNT = ?                                                               \n");
        sql.append(" )                                                                                  \n");

        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S","S","S","S",
                             "S","S","S","S","S",
                             "S","S","S","S","S",
                             "S","S","S"
                            };

            rtn = sm.doInsert(dataPG, type);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

    private int et_setReBDSPCreate(ConnectionContext ctx,  String[][] setBDSP) throws Exception
    {
        int rtn = 0;
        StringBuffer sql = new StringBuffer();
        SepoaSQLManager sm = null;

        try {

            sql.append(" INSERT INTO ICOYBDSP (                                         \n");
            sql.append("                     HOUSE_CODE                    ,            \n");
            sql.append("                     BID_NO                        ,            \n");
            sql.append("                     BID_COUNT                     ,            \n");
            sql.append("                     VOTE_COUNT                    ,            \n");
            sql.append("                     VENDOR_CODE                   ,            \n");
            sql.append("                     STATUS                        ,            \n");
            sql.append("                     ADD_DATE                      ,            \n");
            sql.append("                     ADD_TIME                      ,            \n");
            sql.append("                     ADD_USER_ID                   ,            \n");
            sql.append("                     ADD_USER_NAME_LOC             ,            \n");
            sql.append("                     ADD_USER_NAME_ENG             ,            \n");
            sql.append("                     ADD_USER_DEPT                 ,            \n");
            sql.append("                     PRICE_SCORE                   ,            \n");
            sql.append("                     TECHNICAL_SCORE               ,            \n");
            sql.append("                     SPEC_RANK                     ,            \n");
            sql.append("                     SPEC_FLAG                                  \n");
            sql.append("                     ,TECH_POINT                                  \n");
            sql.append("                     ,AMT_POINT                                  \n");
            sql.append("                     ,REASON                                  	\n");
            sql.append("                     ,TEST_POINT                                  \n");
            sql.append(" )        (                                                     \n");
            sql.append(" SELECT                                                         \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     VENDOR_CODE                   ,            \n");
            sql.append("                     'C'                           ,            \n");
            sql.append("                     TO_CHAR(SYSDATE,'YYYYMMDD')   ,            \n");
            sql.append("                     TO_CHAR(SYSDATE,'HH24MISS')   ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     ?                             ,            \n");
            sql.append("                     PRICE_SCORE                   ,            \n");
            sql.append("                     TECHNICAL_SCORE               ,            \n");
            sql.append("                     SPEC_RANK                     ,            \n");
            sql.append("                     SPEC_FLAG                                  \n");
            sql.append("                     ,TECH_POINT                                  \n");
            sql.append("                     ,AMT_POINT                                  \n");
            sql.append("                     ,REASON                                  	\n");
            sql.append("                     ,TEST_POINT                                  \n");
            sql.append(" FROM ICOYBDSP                                                  \n");
            sql.append(" WHERE HOUSE_CODE = ?                                           \n");
            sql.append(" AND   BID_NO     = ?                                           \n");
            sql.append(" AND   BID_COUNT  = ?                                           \n");
            sql.append(" AND   VOTE_COUNT = ?                                           \n");
            sql.append(" )                                                              \n");

            sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S","S","S","S",
                            "S","S","S","S","S",
                            "S","S"};

            rtn = sm.doInsert(setBDSP, type);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }

    private int et_delBDPG(ConnectionContext ctx, String[][] dataPG
                                    ) throws Exception
    {
        int rtn = 0;
        StringBuffer sql = new StringBuffer();

        sql.append(" UPDATE ICOYBDPG       \n");
        sql.append(" SET   STATUS = 'D'    \n");
        sql.append(" WHERE HOUSE_CODE = ?  \n");
        sql.append(" AND   BID_NO     = ?  \n");
        sql.append(" AND   BID_COUNT  = ?  \n");
        sql.append(" AND   VOTE_COUNT = ?  \n");

        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S","S","S"
                            };

            rtn = sm.doInsert(dataPG, type);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

    private int et_delBDSP(ConnectionContext ctx, String[][] dataSP
                                    ) throws Exception
    {
        int rtn = 0;
        StringBuffer sql = new StringBuffer();

        sql.append(" UPDATE ICOYBDSP       \n");
        sql.append(" SET   STATUS = 'D'    \n");
        sql.append(" WHERE HOUSE_CODE = ?  \n");
        sql.append(" AND   BID_NO     = ?  \n");
        sql.append(" AND   BID_COUNT  = ?  \n");
        sql.append(" AND   VOTE_COUNT = ?  \n");

        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S","S","S"
                            };

            rtn = sm.doInsert(dataSP, type);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

    private int et_delBDVO(ConnectionContext ctx, String[][] dataSP
                                    ) throws Exception
    {
        int rtn = 0;
        StringBuffer sql = new StringBuffer();

        sql.append(" UPDATE ICOYBDVO       \n");
        sql.append(" SET   STATUS = 'D'    \n");
        sql.append(" WHERE HOUSE_CODE = ?  \n");
        sql.append(" AND   BID_NO     = ?  \n");
        sql.append(" AND   BID_COUNT  = ?  \n");
        sql.append(" AND   VOTE_COUNT = ?  \n");

        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S","S","S"
                            };

            rtn = sm.doInsert(dataSP, type);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
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
        String contact_user     = data[7];

   		ConnectionContext ctx = getConnectionContext();

        String rtn = "";

		try{
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());			
			wxp.addVar("HOUSE_CODE", HOUSE_CODE);
			wxp.addVar("bid_flag", bid_flag);
	        SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());


            String[] args = {house_code, from_date, to_date, ann_no, ann_item, settle_vendor, contact_user};
			rtn = sm.doSelect(args);

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	public SepoaOut getForecastList(String[] data)
    {
		try{

			String rtn = et_getForecastList(data);

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

	private String et_getForecastList(String[] data) throws Exception
	{
		String rtn = "";
		
        String house_code       = data[0];
        String from_date        = data[1];
        String to_date          = data[2];
        String ann_no           = data[3];
        String ann_item         = data[4];
        String bid_flag         = data[5];
        String contact_user		= data[6];


        ConnectionContext ctx = getConnectionContext();

        try{
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("house_code",	info.getSession("HOUSE_CODE"));

			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

            String[] args = {house_code, from_date, to_date, from_date, to_date, 
            		         ann_no, ann_item, bid_flag, contact_user};
            rtn = sm.doSelect(args);

        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

    public SepoaOut getForecastInsList(String[] data)
    {
        try{

            String rtn = et_getForecastInsList(data);

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

    private String et_getForecastInsList(String[] data) throws Exception
    {
        String house_code       = data[0];
        String from_date        = data[1];
        String to_date          = data[2];
        String ann_no           = data[3];
        String ann_item         = data[4];
        String bid_flag         = data[5];
        String bid_type         = data[6];
        String CHANGE_USER_NAME = data[7];

        ConnectionContext ctx = getConnectionContext();

        String rtn = "";

        try{
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("house_code",	info.getSession("HOUSE_CODE"));

			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

            String[] args = {house_code, from_date, to_date, from_date, to_date, ann_no, ann_item, bid_flag, bid_type, CHANGE_USER_NAME};
            rtn = sm.doSelect(args);

        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
    
    /**
     * 단수예가 신규 및 수정 저장인 경우(STATUS_FLAG = T)
     * @param STATUS_FLAG
     * @param sendBDES
     * @param sendBDHD
     * @return
     */
	public SepoaOut setForecastSave(String STATUS_FLAG, String[][] sendBDES, String[][] sendBDHD)
	{
        // STATUS_FLAG == 'T' 신규저장
        // STATUS_FLAG == 'TET' 수정저장
   		ConnectionContext ctx = getConnectionContext();
		try {
			int rtnBDES = 0;
			
            if(STATUS_FLAG.equals("T")) {
                rtnBDES = et_setInsertBDES(ctx, sendBDES);
            } else {
            	rtnBDES = et_setUpdateBDES(ctx, sendBDES);
            }
            
            int rtn = et_setBidStatusForecast(ctx, sendBDHD); // ICOYBDHD의 CONT_STATUS 수정
            
            setStatus(1);
            setValue(rtnBDES+"");
            setMessage(msg.getMessage("0053"));
            Commit();
		} catch(Exception e) {
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
	
	/**
	 * 단수예가 신규 및 수정 확정인 경우 (STATUS_FLAG = C)
	 * @param STATUS_FLAG
	 * @param updaBDES
	 * @param sendBDES
	 * @param sendBDHD
	 * @return
	 */
	public SepoaOut setForecastConfirm(String STATUS_FLAG, String[][] updaBDES, String[][] sendBDES, String[][] sendBDHD)
	{
        // STATUS_FLAG == 'C' 신규확정
        // STATUS_FLAG == 'CET' 수정확정
		try{
       		ConnectionContext ctx = getConnectionContext();

            int rtnBDES = 0;
/*          예정가격 등록시 예정가격 등록 요청 메뉴를 수행후 진행하기 때문에
 * 			INSERT 수행 없이 UPDATE를 진행하도록 합니다.
 * 			if(STATUS_FLAG.equals("C")) {
                rtnBDES = et_setInsertBDES(ctx, sendBDES);
            } else {
            */
            	rtnBDES = et_setUpdateBDES(ctx, sendBDES);
            /*
            }
             */
            int rtnUpda = et_setConfirmBDES(ctx, updaBDES);
            int rtn = et_setBidStatusForecast(ctx, sendBDHD);

            setStatus(1);
            setValue(rtn+"");
            setMessage("예정가격이 확정되었습니다.");

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
			setMessage(msg.getMessage("0003 "));
		}

		return getSepoaOut();
	}
	
	/**
	 * 단수예가 신규 저장인 경우(STATUS_FLAG = T)
	 * @param ctx
	 * @param setBDES
	 * @return
	 * @throws Exception
	 */
    private int et_setInsertBDES(ConnectionContext ctx, String[][] setBDES) throws Exception
    {
    	int rtn = 0;
    	try {
    		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    		SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
    		
            String[] type = {"S","S","S","S","S",
                             "S","S","S","S","S",
                             "S","S","S","S","S",
                             "S","S","S","S","S",
                             "S","S"};
            
            rtn = sm.doUpdate(setBDES, type);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        
        return rtn;
    }
    
    /**
	 * 단수예가 수정 저장인 경우(STATUS_FLAG = T)
     * @param ctx
     * @param setBDES
     * @return
     * @throws Exception
     */
    private int et_setUpdateBDES(ConnectionContext ctx,  String[][] setBDES) throws Exception
    {
        int rtn = 0;
        try {
    		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

            String[] type = {"S","S","S","S","S",
                             "S","S","S","S","S",
                             "S","S","S","S","S",
                             "S","S","S"};

            rtn = sm.doUpdate(setBDES, type);
        }
        catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        finally {}
        
        return rtn;
    }
    
    /**
     * 예정가격의 확정일자 수정
     * @param ctx
     * @param setBDES
     * @return
     * @throws Exception
     */
    private int et_setConfirmBDES(ConnectionContext ctx,  String[][] setBDES) throws Exception
    {
        int rtn = 0;
        try {
    		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

	        String[] type = {"S","S","S"};

            rtn = sm.doUpdate(setBDES, type);
        }
        catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        finally {}
        
        return rtn;
    }

    private int et_setDelBDES(ConnectionContext ctx,  String[][] delBDES) throws Exception
    {
        int rtn = 0;
        StringBuffer sql = new StringBuffer();
        SepoaSQLManager sm = null;

        try {

            sql.append(" DELETE  FROM ICOYBDSP    \n");
            sql.append(" WHERE HOUSE_CODE = ?     \n");
            sql.append(" AND   BID_NO     = ?     \n");
            sql.append(" AND   BID_COUNT  = ?     \n");

            sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S","S"};

            rtn = sm.doUpdate(delBDES, type);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }

	public SepoaOut setBidProcess(String[][] setBDVO, String[][] setBDSP, String[][] setVEVH)
	{
		try{
       		ConnectionContext ctx = getConnectionContext();

			int rtnBDVO = et_setBidProcess(ctx, setBDVO);
			int rtnBDSP = et_setBidBDSP(ctx, setBDSP);
			
			Logger.debug.println(this, "[setBidProcess] 제안평가 결과[setVEVH]==PROPOSAL_RESULT::"+setVEVH[0][0]);
			Logger.debug.println(this, "[setBidProcess] 제안평가 결과[setVEVH]==HOUSE_CODE::"+setVEVH[0][1]);
			Logger.debug.println(this, "[setBidProcess] 제안평가 결과[setVEVH]==EVAL_REFITEM::"+setVEVH[0][2]);
			if(!"".equals(setVEVH[0][2])){
				rtnBDSP = et_setBidVEVH(ctx, setVEVH);
			}

            setStatus(1);
            setValue("");
            setMessage(msg.getMessage("0000"));

            Commit();

		}catch(Exception e) {
            try {
                Rollback();
				setStatus(0);
			    setMessage(msg.getMessage("0036"));
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0036"));
		}

		return getSepoaOut();
	}

    private int et_setBidProcess(ConnectionContext ctx, String[][] setBDVO
                                    ) throws Exception
    {
        int rtn = 0;

        try {
    		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

            String[] type = {"S","S","S","S","S",
                             "S","S"
                            };

            rtn = sm.doUpdate(setBDVO, type);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
    
    private int et_setBidBDSP(ConnectionContext ctx, String[][] setBDSP) throws Exception
	{
		int rtn = 0;
		
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("user_id", info.getSession("ID"));
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			
			String[] type = {"S","S","S","S","S",
							 "S","S","S","S","S"
							};
			
			rtn = sm.doUpdate(setBDSP, type);
		} catch(Exception e) {
		Logger.err.println(userid,this,e.getMessage());
		throw new Exception(e.getMessage());
		}
		return rtn;
	}
    
    private int et_setBidVEVH(ConnectionContext ctx, String[][] setVEVH) throws Exception
	{
		int rtn = 0;
		
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			
			String[] type = {"S","S","S"};
			
			rtn = sm.doUpdate(setVEVH, type);
		} catch(Exception e) {
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

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doSelect((String[])null);
		} catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}


    public SepoaOut getProgressList2(String[] data)
    {
        try{

            String rtn = et_getProgressList2(data);

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

    private String et_getProgressList2(String[] data) throws Exception
    {

        lang             = info.getSession("LANGUAGE");
        ctrl_code        = info.getSession("CTRL_CODE");

        String house_code = data[0];
        String from_date  = data[1];
        String to_date    = data[2];
        String ann_no     = data[3];
        String ann_item   = data[4];
        String bid_flag   = data[5];
        String change_user_name = data[6];

        ConnectionContext ctx = getConnectionContext();

        String rtn = "";

        try{
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("house_code",	info.getSession("HOUSE_CODE"));
	        wxp.addVar("bid_flag",		bid_flag);

			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

            String[] args = {house_code, from_date, to_date, ann_no, ann_item, change_user_name};
            rtn = sm.doSelect(args);

        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }


    public SepoaOut setForecastSave_U(String STATUS_FLAG, String[][] sendBDES, String[][] sendBDHD)
    {
        // STATUS_FLAG == 'T' 신규저장
        // STATUS_FLAG == 'TET' 수정저장
        ConnectionContext ctx = getConnectionContext();
        try {
            int rtnBDES = 0;
            if(STATUS_FLAG.equals("T")) {
                rtnBDES = et_setInsertBDES(ctx, sendBDES);
            } else {
                rtnBDES = et_setUpdateBDES_U(ctx, sendBDES); // 복수예가 수정
            }
            int rtn = et_setBidStatusForecast(ctx, sendBDHD); // 예가상태 변경

            setStatus(1);
            setValue(rtnBDES+"");
            setMessage(msg.getMessage("0053"));

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
    
    /**
     * 복수예가 확정 수정
     * @param STATUS_FLAG
     * @param updaBDES
     * @param sendBDES
     * @param sendBDHD
     * @return
     */
    public SepoaOut setForecastConfirm_U(String STATUS_FLAG, String[][] updaBDES, String[][] sendBDES, String[][] sendBDHD)
    {
        // STATUS_FLAG == 'C' 신규확정
        // STATUS_FLAG == 'CET' 수정확정
        try{
            ConnectionContext ctx = getConnectionContext();

            int rtnBDES = 0;
            if(STATUS_FLAG.equals("C")) {
                rtnBDES = et_setInsertBDES(ctx, sendBDES);
            } else {
                rtnBDES = et_setUpdateBDES_U(ctx, sendBDES);
            }
            int rtnUpda = et_setConfirmBDES(ctx, updaBDES);
            int rtn = et_setBidStatusForecast(ctx, sendBDHD);

            setStatus(1);
            setValue(rtn+"");
            setMessage(msg.getMessage("0054"));

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
            setMessage(msg.getMessage("0003 "));
        }

        return getSepoaOut();
    }


    private int et_setUpdateBDES_U(ConnectionContext ctx,  String[][] setBDES) throws Exception
    {
        int rtn = 0;

        try {
    		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

	        String[] type = {"S","S","S","S","S",
                            "S","S","S","S","S",
                            "S","S","S","S","S",
                            "S","S","S","S","S",
                            "S","S","S","S","S",
                            "S","S","S","S","S",
                            "S","S","S","S","S",
                            "S","S","S","S","S",
                            "S","S","S","S","S",
                            "S"};

            rtn = sm.doUpdate(setBDES, type);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }

    private int et_setUpdPRDT(ConnectionContext ctx, String BID_NO, String BID_COUNT) throws Exception
    {
        int rtn = 0;
        HOUSE_CODE      = info.getSession("HOUSE_CODE");

        StringBuffer sql = new StringBuffer();

        sql.append(" UPDATE ICOYPRDT                                           \n");
        sql.append("   SET BID_STATUS           = 'SC'             \n");
        sql.append("  WHERE  HOUSE_CODE          = '"+HOUSE_CODE+"'                         \n");
        sql.append("    AND  (PR_NO, PR_SEQ)  IN (                            	\n");
        sql.append("            SELECT  PR_NO, PR_SEQ  FROM  ICOYBDDT       	\n");
        sql.append("             WHERE  BID_NO    = '"+BID_NO+"'                 \n");
        sql.append("               AND  BID_COUNT = '"+BID_COUNT+"'              \n");
        sql.append("            )                                                \n");

        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());

            rtn = sm.doUpdate((String[][])null, null);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }




    public int setMail( String BID_NO, String BID_COUNT , String TYPE, String DOC_NAME )
    {
        Logger.debug.println(info.getSession("ID"),this,"setMail=====================");
        int rtn = 0;

        int m=0;

        try{
            ConnectionContext ctx = getConnectionContext();

            StringBuffer sql = new StringBuffer();

            sql.append(" SELECT USER_EMAIL AS VENDOR_EMAIL       \n");
            sql.append("        , (SELECT NAME_LOC                                          \n");
            sql.append("          FROM ICOMVNGL                                             \n");
            sql.append("          WHERE HOUSE_CODE='"+HOUSE_CODE+"'                         \n");
            sql.append("            AND VENDOR_CODE = BDAP.VENDOR_CODE) AS VENDOR_NAME      \n");
            sql.append(" FROM ICOYBDAP BDAP                                                 \n");
            sql.append(" WHERE HOUSE_CODE = '"+HOUSE_CODE+"'                                \n");
            sql.append("   AND BID_NO = '"+BID_NO+"'                                        \n");
            sql.append("   AND BID_COUNT = '"+BID_COUNT+"'                                  \n");


            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String rtnSel = sm.doSelect((String[])null);

            SepoaFormater wf = new SepoaFormater(rtnSel);

            for( int i=0; i<wf.getRowCount(); i++ )
            {
                String ReceiverMail   = wf.getValue(i,0);
                String ReceiverName   = wf.getValue(i,1);

                Logger.debug.println(info.getSession("ID"),this,"ReceiverMail====================="+ReceiverMail);
                Logger.debug.println(info.getSession("ID"),this,"ReceiverName====================="+ReceiverName);

                String [] args =  {BID_NO, TYPE, DOC_NAME, ReceiverMail,ReceiverName };

                String serviceId = "SendMail2";
                Object[] obj = { args };
                String conType = "NONDBJOB";                    //conType : CONNECTION/TRANSACTION/NONDBJOB
                String MethodName = "mailDomestic";             //NickName으로 연결된 Class에 정의된 Method Name

                SepoaOut value = null;
                SepoaRemote wr = null;

                //다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
                try
                {

                    wr = new SepoaRemote( serviceId, conType, info );
                    wr.setConnection(ctx);

                    value = wr.lookup( MethodName, obj );
                    Logger.debug.println(info.getSession("ID"),this,"value.status====================="+value.status);

                    rtn = value.status;

                }catch( SepoaServiceException wse ) {
//                	try{
                        Logger.err.println("wse = " + wse.getMessage());
//                        Logger.err.println("message = " + value.message);
//                        Logger.err.println("status = " + value.status);                		
//                	}catch(NullPointerException ne){}
                }catch(Exception e) {
//                	try{
                        Logger.err.println("err = " + e.getMessage());
//                        Logger.err.println("message = " + value.message);
//                        Logger.err.println("status = " + value.status);                		
//                	}catch(NullPointerException ne){}
                }
//                finally{
//
//                }
            }
        }catch(Exception ee )
        {
        	Logger.err.println("err = " + ee.getMessage());
        }

        return rtn;
    }


    private void RFQ_SMS_send(String BID_NO, String BID_COUNT, String user_id, String sms_code) throws Exception {

        String rtn = "";
        SepoaSQLManager sm = null;
        SepoaFormater Sepoaformater1 = null;
        SepoaFormater Sepoaformater2 = null;
        SepoaFormater Sepoaformater3 = null;


        String vendor_name  = "";
        String receive_no   = "";
        String send_no      = "";

        ConnectionContext ctx = getConnectionContext();
        try {
            StringBuffer sql1 = new StringBuffer();

            sql1.append(" SELECT REPLACE(USER_MOBILE, '-', '') AS SMS_RECEIVE_NO     \n");
            sql1.append("        , (SELECT NAME_LOC                                          \n");
            sql1.append("          FROM ICOMVNGL                                             \n");
            sql1.append("          WHERE HOUSE_CODE='"+HOUSE_CODE+"'                         \n");
            sql1.append("            AND VENDOR_CODE = BDAP.VENDOR_CODE) AS VENDOR_NAME      \n");
            sql1.append(" FROM ICOYBDAP BDAP                                                 \n");
            sql1.append(" WHERE HOUSE_CODE = '"+HOUSE_CODE+"'                                \n");
            sql1.append("   AND BID_NO = '"+BID_NO+"'                                        \n");
            sql1.append("   AND BID_COUNT = '"+BID_COUNT+"'                                  \n");

            sm = new SepoaSQLManager(user_id, this, ctx, sql1.toString());
            rtn = sm.doSelect((String[])null);

            Sepoaformater1 = new SepoaFormater(rtn);

            StringBuffer sql2 = new StringBuffer();

            sql2.append("SELECT \n");
            sql2.append("    REPLACE(MOBILE_NO, '-', '') AS SMS_SEND_NO \n");
            sql2.append("FROM \n");
            sql2.append("    ICOMLUSR \n");
            sql2.append("WHERE \n");
            sql2.append("    HOUSE_CODE = '" + HOUSE_CODE + "' \n");
            sql2.append("    AND USER_ID = '" + user_id + "' \n");

            sm = new SepoaSQLManager(user_id, this, ctx, sql2.toString());
            rtn = sm.doSelect((String[])null);

            Sepoaformater2 = new SepoaFormater(rtn);

            //////sendSms //sendSms = null;
            String[][] ra_sms_data = new String[Sepoaformater1.getRowCount()][4];
            for (int i=0; i<Sepoaformater1.getRowCount(); i++) {
                vendor_name = Sepoaformater1.getValue("VENDOR_NAME", i);
                receive_no  = Sepoaformater1.getValue("SMS_RECEIVE_NO", i);
                send_no     = Sepoaformater2.getValue("SMS_SEND_NO", 0);
                if(vendor_name==null) vendor_name="";
                if(receive_no==null) receive_no="";
                if(send_no==null) send_no="";
                ra_sms_data[i][0] = vendor_name;
                ra_sms_data[i][1] = name_loc;
                ra_sms_data[i][2] = receive_no;
                ra_sms_data[i][3] = send_no;
            }
            ////sendSms = new //sendSms(info, ctx); // //sendSms 객체 생성
            ////sendSms.sendMessage(sms_code, ra_sms_data);// //sendSms 의 sendMessage Method call

         } catch(Exception e) {
            Logger.debug.println(info.getSession("ID"), this, "et_getratbdins1_1 = " + e.getMessage());
        } finally {}
    }

//낙찰시에 메일, sms 보내기
    public int setMail_sel( String BID_NO, String BID_COUNT, String VENDOR_CODE , String TYPE, String DOC_NAME )
    {
        Logger.debug.println(info.getSession("ID"),this,"setMail=====================");
        int rtn = 0;

        int m=0;

        try{
            ConnectionContext ctx = getConnectionContext();

            StringBuffer sql = new StringBuffer();

            sql.append(" SELECT USER_EMAIL AS VENDOR_EMAIL       \n");
            sql.append("        , (SELECT NAME_LOC                                          \n");
            sql.append("          FROM ICOMVNGL                                             \n");
            sql.append("          WHERE HOUSE_CODE='"+HOUSE_CODE+"'                         \n");
            sql.append("            AND VENDOR_CODE = BDAP.VENDOR_CODE) AS VENDOR_NAME      \n");
            sql.append(" FROM ICOYBDAP BDAP                                                 \n");
            sql.append(" WHERE HOUSE_CODE = '"+HOUSE_CODE+"'                                \n");
            sql.append("   AND BID_NO = '"+BID_NO+"'                                        \n");
            sql.append("   AND BID_COUNT = '"+BID_COUNT+"'                                  \n");
            sql.append("   AND VENDOR_CODE = '"+VENDOR_CODE+"'                              \n");


            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String rtnSel = sm.doSelect((String[])null);

            SepoaFormater wf = new SepoaFormater(rtnSel);

            for( int i=0; i<wf.getRowCount(); i++ )
            {
                String ReceiverMail   = wf.getValue(i,0);
                String ReceiverName   = wf.getValue(i,1);

                Logger.debug.println(info.getSession("ID"),this,"ReceiverMail====================="+ReceiverMail);
                Logger.debug.println(info.getSession("ID"),this,"ReceiverName====================="+ReceiverName);

                String [] args =  {BID_NO, TYPE, DOC_NAME, ReceiverMail,ReceiverName };

                String serviceId = "SendMail2";
                Object[] obj = { args };
                String conType = "NONDBJOB";                    //conType : CONNECTION/TRANSACTION/NONDBJOB
                String MethodName = "mailDomestic";             //NickName으로 연결된 Class에 정의된 Method Name

                SepoaOut value = null;
                SepoaRemote wr = null;

                //다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
                try
                {

                    wr = new SepoaRemote( serviceId, conType, info );
                    wr.setConnection(ctx);

                    value = wr.lookup( MethodName, obj );
                    Logger.debug.println(info.getSession("ID"),this,"value.status====================="+value.status);

                    rtn = value.status;

                }catch( SepoaServiceException wse ) {
//                	try{
                        Logger.err.println("wse = " + wse.getMessage());
//                        Logger.err.println("message = " + value.message);
//                        Logger.err.println("status = " + value.status);                		
//                	}catch(NullPointerException ne){}
                }catch(Exception e) {
//                	try{
                        Logger.err.println("err = " + e.getMessage());
//                        Logger.err.println("message = " + value.message);
//                        Logger.err.println("status = " + value.status);                		
//                	}catch(NullPointerException ne){}
                }
//                finally{
//
//                }
            }
        }catch(Exception ee )
        {
        	 Logger.err.println("err = " + ee.getMessage());
        }

        return rtn;
    }


    private void RFQ_SMS_send_sel(String BID_NO, String BID_COUNT, String VENDOR_CODE, String user_id, String sms_code) throws Exception {

        String rtn = "";
        SepoaSQLManager sm = null;
        SepoaFormater Sepoaformater1 = null;
        SepoaFormater Sepoaformater2 = null;
        SepoaFormater Sepoaformater3 = null;


        String vendor_name  = "";
        String receive_no   = "";
        String send_no      = "";

        ConnectionContext ctx = getConnectionContext();
        try {
            StringBuffer sql1 = new StringBuffer();

            sql1.append(" SELECT REPLACE(USER_MOBILE, '-', '') AS SMS_RECEIVE_NO     \n");
            sql1.append("        , (SELECT NAME_LOC                                          \n");
            sql1.append("          FROM ICOMVNGL                                             \n");
            sql1.append("          WHERE HOUSE_CODE='"+HOUSE_CODE+"'                         \n");
            sql1.append("            AND VENDOR_CODE = BDAP.VENDOR_CODE) AS VENDOR_NAME      \n");
            sql1.append(" FROM ICOYBDAP BDAP                                                 \n");
            sql1.append(" WHERE HOUSE_CODE = '"+HOUSE_CODE+"'                                \n");
            sql1.append("   AND BID_NO = '"+BID_NO+"'                                        \n");
            sql1.append("   AND BID_COUNT = '"+BID_COUNT+"'                                  \n");
            sql1.append("   AND VENDOR_CODE = '"+VENDOR_CODE+"'                              \n");

            sm = new SepoaSQLManager(user_id, this, ctx, sql1.toString());
            rtn = sm.doSelect((String[])null);

            Sepoaformater1 = new SepoaFormater(rtn);

            StringBuffer sql2 = new StringBuffer();

            sql2.append("SELECT \n");
            sql2.append("    REPLACE(MOBILE_NO, '-', '') AS SMS_SEND_NO \n");
            sql2.append("FROM \n");
            sql2.append("    ICOMLUSR \n");
            sql2.append("WHERE \n");
            sql2.append("    HOUSE_CODE = '" + HOUSE_CODE + "' \n");
            sql2.append("    AND USER_ID = '" + user_id + "' \n");

            sm = new SepoaSQLManager(user_id, this, ctx, sql2.toString());
            rtn = sm.doSelect((String[])null);

            Sepoaformater2 = new SepoaFormater(rtn);

            //////sendSms //sendSms = null;
            String[][] ra_sms_data = new String[Sepoaformater1.getRowCount()][4];
            for (int i=0; i<Sepoaformater1.getRowCount(); i++) {
                vendor_name = Sepoaformater1.getValue("VENDOR_NAME", i);
                receive_no  = Sepoaformater1.getValue("SMS_RECEIVE_NO", i);
                send_no     = Sepoaformater2.getValue("SMS_SEND_NO", 0);
                if(vendor_name==null) vendor_name="";
                if(receive_no==null) receive_no="";
                if(send_no==null) send_no="";
                ra_sms_data[i][0] = vendor_name;
                ra_sms_data[i][1] = name_loc;
                ra_sms_data[i][2] = receive_no;
                ra_sms_data[i][3] = send_no;
            }
            ////sendSms = new //sendSms(info, ctx); // //sendSms 객체 생성
            ////sendSms.sendMessage(sms_code, ra_sms_data);// //sendSms 의 sendMessage Method call

         } catch(Exception e) {
            Logger.debug.println(info.getSession("ID"), this, "et_getratbdins1_1 = " + e.getMessage());
        } finally {}
    }

    public SepoaOut getVendorDisplay(String vendor_name)
    {
        try{

            String rtn = et_getVendorDisplay(vendor_name);

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

    private String et_getVendorDisplay(String vendor_name) throws Exception
    {

        ConnectionContext ctx = getConnectionContext();
        String rtn = "";
        StringBuffer sql = new StringBuffer();

        sql.append(" SELECT                                                \n");
        sql.append("          VN.VENDOR_CODE,                              \n");
        sql.append("          VN.VENDOR_NAME_LOC AS VENDOR_NAME,                  \n");
        sql.append("          AD.CEO_NAME_LOC,                             \n");
        sql.append("          AD.PHONE_NO1 AS TEL,                         \n");
        sql.append("          CP.USER_NAME,                                \n");
        sql.append("          CP.POSITION AS USER_POSITION,                \n");
        sql.append("          CP.MOBILE_NO AS USER_MOBILE,                 \n");
        sql.append("          CP.EMAIL AS USER_EMAIL                       \n");
        sql.append(" FROM ICOMVNGL VN ,ICOMVNCP CP,ICOMADDR AD    \n");
        sql.append(" WHERE VN.HOUSE_CODE = CP.HOUSE_CODE (+)     \n");
        sql.append("  AND VN.VENDOR_CODE = CP.VENDOR_CODE (+)    \n");
        sql.append("  AND CP.STATUS(+) != 'D'                  \n");
        
        sql.append("  AND VN.HOUSE_CODE = AD.HOUSE_CODE \n");
        sql.append("  AND VN.VENDOR_CODE = AD.CODE_NO \n");
        sql.append("  AND AD.CODE_TYPE='2' \n");

        
        
        sql.append(" AND VN.HOUSE_CODE = UPPER('"+info.getSession("HOUSE_CODE")+"') \n");
        sql.append(" AND VN.STATUS IN ('C','R')    \n");
        sql.append(" <OPT=S,S>AND VN.VENDOR_NAME_LOC LIKE '%' || UPPER(?) || '%'  </OPT>         \n");
        sql.append("  ORDER BY VN.VENDOR_NAME_LOC                  \n");

        try{
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] args = {vendor_name};
            rtn = sm.doSelect(args);

        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

    public int setMail_D04( String BID_NO, String BID_COUNT, String VOTE_COUNT , String TYPE, String DOC_NAME )
    {
        Logger.debug.println(info.getSession("ID"),this,"setMail=====================");
        int rtn = 0;

        int m=0;

        try{
            ConnectionContext ctx = getConnectionContext();

            StringBuffer sql = new StringBuffer();

            sql.append(" SELECT USER_EMAIL AS VENDOR_EMAIL       \n");
            sql.append("        , (SELECT NAME_LOC                                          \n");
            sql.append("          FROM ICOMVNGL                                             \n");
            sql.append("          WHERE HOUSE_CODE='"+HOUSE_CODE+"'                         \n");
            sql.append("            AND VENDOR_CODE = BDAP.VENDOR_CODE) AS VENDOR_NAME      \n");
            sql.append(" FROM ICOYBDAP BDAP, ICOYBDVO BDVO                                                 \n");
            sql.append(" WHERE BDAP.HOUSE_CODE = '"+HOUSE_CODE+"'                                \n");
            sql.append("   AND BDAP.BID_NO = '"+BID_NO+"'                                        \n");
            sql.append("   AND BDAP.BID_COUNT = '"+BID_COUNT+"'                                  \n");
            sql.append("   AND BDVO.HOUSE_CODE = '"+HOUSE_CODE+"'                                \n");
            sql.append("   AND BDVO.BID_NO = '"+BID_NO+"'                                        \n");
            sql.append("   AND BDVO.BID_COUNT = '"+BID_COUNT+"'                                  \n");
            sql.append("   AND BDVO.VOTE_COUNT = '"+VOTE_COUNT+"'                                  \n");
            sql.append("   AND BDAP.HOUSE_CODE = BDVO.HOUSE_CODE                                    \n");
            sql.append("   AND BDAP.BID_NO = BDVO.BID_NO                                            \n");
            sql.append("   AND BDAP.BID_COUNT = BDVO.BID_COUNT                                      \n");
            sql.append("   AND BDAP.VENDOR_CODE = BDVO.VENDOR_CODE                                  \n");


            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String rtnSel = sm.doSelect((String[])null);

            SepoaFormater wf = new SepoaFormater(rtnSel);

            for( int i=0; i<wf.getRowCount(); i++ )
            {
                String ReceiverMail   = wf.getValue(i,0);
                String ReceiverName   = wf.getValue(i,1);

                Logger.debug.println(info.getSession("ID"),this,"ReceiverMail====================="+ReceiverMail);
                Logger.debug.println(info.getSession("ID"),this,"ReceiverName====================="+ReceiverName);

                String [] args =  {BID_NO, TYPE, DOC_NAME, ReceiverMail,ReceiverName };

                String serviceId = "SendMail2";
                Object[] obj = { args };
                String conType = "NONDBJOB";                    //conType : CONNECTION/TRANSACTION/NONDBJOB
                String MethodName = "mailDomestic";             //NickName으로 연결된 Class에 정의된 Method Name

                SepoaOut value = null;
                SepoaRemote wr = null;

                //다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
                try
                {

                    wr = new SepoaRemote( serviceId, conType, info );
                    wr.setConnection(ctx);

                    value = wr.lookup( MethodName, obj );
                    Logger.debug.println(info.getSession("ID"),this,"value.status====================="+value.status);

                    rtn = value.status;

                }catch( SepoaServiceException wse ) {
//                	try{
                        Logger.err.println("wse = " + wse.getMessage());
//                        Logger.err.println("message = " + value.message);
//                        Logger.err.println("status = " + value.status);                		
//                	}catch(NullPointerException ne){}
                }catch(Exception e) {
//                	try{
                        Logger.err.println("err = " + e.getMessage());
//                        Logger.err.println("message = " + value.message);
//                        Logger.err.println("status = " + value.status);                		
//                	}catch(NullPointerException ne){}
                }
//                finally{
//
//                }
            }
        }catch(Exception ee )
        {
        	Logger.err.println("err = " + ee.getMessage());
        }

        return rtn;
    }


    private void RFQ_SMS_send_D04(String BID_NO, String BID_COUNT, String VOTE_COUNT, String user_id, String sms_code) throws Exception {

        String rtn = "";
        SepoaSQLManager sm = null;
        SepoaFormater Sepoaformater1 = null;
        SepoaFormater Sepoaformater2 = null;
        SepoaFormater Sepoaformater3 = null;


        String vendor_name  = "";
        String receive_no   = "";
        String send_no      = "";

        ConnectionContext ctx = getConnectionContext();
        try {
            StringBuffer sql1 = new StringBuffer();

            sql1.append(" SELECT REPLACE(USER_MOBILE, '-', '') AS SMS_RECEIVE_NO     \n");
            sql1.append("        , (SELECT NAME_LOC                                          \n");
            sql1.append("          FROM ICOMVNGL                                             \n");
            sql1.append("          WHERE HOUSE_CODE='"+HOUSE_CODE+"'                         \n");
            sql1.append("            AND VENDOR_CODE = BDAP.VENDOR_CODE) AS VENDOR_NAME      \n");
            sql1.append(" FROM ICOYBDAP BDAP, ICOYBDVO BDVO                                                 \n");
            sql1.append(" WHERE BDAP.HOUSE_CODE = '"+HOUSE_CODE+"'                                \n");
            sql1.append("   AND BDAP.BID_NO = '"+BID_NO+"'                                        \n");
            sql1.append("   AND BDAP.BID_COUNT = '"+BID_COUNT+"'                                  \n");
            sql1.append("   AND BDVO.HOUSE_CODE = '"+HOUSE_CODE+"'                                \n");
            sql1.append("   AND BDVO.BID_NO = '"+BID_NO+"'                                        \n");
            sql1.append("   AND BDVO.BID_COUNT = '"+BID_COUNT+"'                                  \n");
            sql1.append("   AND BDVO.VOTE_COUNT = '"+VOTE_COUNT+"'                                  \n");
            sql1.append("   AND BDAP.HOUSE_CODE = BDVO.HOUSE_CODE                                    \n");
            sql1.append("   AND BDAP.BID_NO = BDVO.BID_NO                                            \n");
            sql1.append("   AND BDAP.BID_COUNT = BDVO.BID_COUNT                                      \n");
            sql1.append("   AND BDAP.VENDOR_CODE = BDVO.VENDOR_CODE                                  \n");

            sm = new SepoaSQLManager(user_id, this, ctx, sql1.toString());
            rtn = sm.doSelect((String[])null);

            Sepoaformater1 = new SepoaFormater(rtn);

            StringBuffer sql2 = new StringBuffer();

            sql2.append("SELECT \n");
            sql2.append("    REPLACE(MOBILE_NO, '-', '') AS SMS_SEND_NO \n");
            sql2.append("FROM \n");
            sql2.append("    ICOMLUSR \n");
            sql2.append("WHERE \n");
            sql2.append("    HOUSE_CODE = '" + HOUSE_CODE + "' \n");
            sql2.append("    AND USER_ID = '" + user_id + "' \n");

            sm = new SepoaSQLManager(user_id, this, ctx, sql2.toString());
            rtn = sm.doSelect((String[])null);

            Sepoaformater2 = new SepoaFormater(rtn);

            //////sendSms //sendSms = null;
            String[][] ra_sms_data = new String[Sepoaformater1.getRowCount()][4];
            for (int i=0; i<Sepoaformater1.getRowCount(); i++) {
                vendor_name = Sepoaformater1.getValue("VENDOR_NAME", i);
                receive_no  = Sepoaformater1.getValue("SMS_RECEIVE_NO", i);
                send_no     = Sepoaformater2.getValue("SMS_SEND_NO", 0);
                if(vendor_name==null) vendor_name="";
                if(receive_no==null) receive_no="";
                if(send_no==null) send_no="";
                ra_sms_data[i][0] = vendor_name;
                ra_sms_data[i][1] = name_loc;
                ra_sms_data[i][2] = receive_no;
                ra_sms_data[i][3] = send_no;
            }
            ////sendSms = new //sendSms(info, ctx); // //sendSms 객체 생성
            ////sendSms.sendMessage(sms_code, ra_sms_data);// //sendSms 의 sendMessage Method call

         } catch(Exception e) {
            Logger.debug.println(info.getSession("ID"), this, "et_getratbdins1_1 = " + e.getMessage());
        } finally {}
    }
    
    // 낙찰취소
    public SepoaOut doCancelBidding(String[][] sendBDHD, String[][] sendBDVO, String[][] sendPRDT)
    {
        try{
            ConnectionContext ctx = getConnectionContext();

            int rtn = et_doCancelBidding(ctx, sendBDHD, sendBDVO, sendPRDT);

            setStatus(1);
            setValue(rtn+"");
            setMessage(msg.getMessage("0074"));

            Commit();

        }catch(Exception e) {
            try {
                Rollback();
                setStatus(0);
                setMessage(msg.getMessage("0075"));
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0075"));
        }

        return getSepoaOut();
    }


    private int et_doCancelBidding(ConnectionContext ctx,  String[][] sendBDHD, String[][] sendBDVO, String[][] sendPRDT) throws Exception
    {
        int rtn = 0;
        SepoaXmlParser wxp = null;
        SepoaSQLManager sm = null;
        
        try {
    		wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_1");
	        sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
	        String[] type_1 = {"S", "S", "S"};
            rtn = sm.doUpdate(sendBDHD, type_1);
            
	        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_2");
	        sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
	        String[] type_2 = {"S", "S", "S", "S"};
            rtn = sm.doUpdate(sendBDVO, type_2);
            
	        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_3");
	        sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
	        String[] type_3 = {"S", "S", "S", "S", "S", "S"};
            rtn = sm.doUpdate(sendPRDT, type_3);
            
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
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
			rtn	= sm.doSelect((String[])null); 
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
			wxp.addVar("doc_count", doc_count);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
			rtn	= sm.doSelect((String[])null); 
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
	public String getEvalUser(String doc_no, String doc_count, Integer eval_id){
		String rtn = null;
		try{
			rtn = et_getEvalUser(doc_no, doc_count, eval_id); 
			 		
		}catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			setStatus(0); 
			setMessage(msg.getMessage("0005")); 
		} 
		return rtn; 
	}
	
	/*
	 * 평가 담당자 - 구매담당자 가져오기
	 * 2010.07.
	 */
	private	String et_getEvalUser(String doc_no, String doc_count, Integer eval_id) throws Exception 
	{ 
	
		
		String rtn = null; 
		ConnectionContext ctx =	getConnectionContext(); 
		
		SepoaXmlParser wxp = null;
		
		if(eval_id == 7){	//제안평가일 경우 평가자는 구매담당자.
			wxp = new SepoaXmlParser(this, "et_getEvalCtrlUser");
		}else{
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		}
		try{ 
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("doc_no", doc_no);
			wxp.addVar("doc_count", doc_count);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
			rtn	= sm.doSelect((String[])null); 
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
	public SepoaOut setEvalInert(String doc_no, String doc_count, String eval_name, String eval_flag, Integer eval_id){
		try{

			int rtn = et_setEvalInert(doc_no, doc_count, eval_name, eval_flag, eval_id); 
			Logger.debug.println(info.getSession("ID"),this, "=========================평가 여부  및 평가 생성 END::"+rtn);
			
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
		return getSepoaOut(); 
	}
		
	private	int et_setEvalInert(String doc_no, String doc_count, String eval_name, String eval_flag, Integer eval_id) throws Exception 
	{ 
		int rtn =  0;
		ConnectionContext ctx =	getConnectionContext(); 
		
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [doc_no]::"+doc_no);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [doc_count]::"+doc_count);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_name]::"+eval_name);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_flag]::"+eval_flag);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_id]::"+eval_id);
		
		try{ 
			Integer eval_refitem = 0;
			if(!"N".equals(eval_flag)){	//평가제외가 아닐 경우 평가 생성.
				Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 START");
				String rtn1 =  et_setEvalInsert(doc_no, doc_count, eval_name, eval_id);
				
				 if("".equals(rtn1)){
		             Rollback();
		             setStatus(0);
		             setMessage(msg.getMessage("9003"));
		             return 0;
		         }
		         eval_refitem = Integer.valueOf(rtn1);
			}
			Logger.debug.println(info.getSession("ID"),this, "=========================평가 상태 등록");
			
			/*
			 * 개찰 화면에서 평가대상 등록시 ICOYBDHD에 EVAL_FLAG, EVAL_REFITEM 컬럼 업데이트를 하지 않습니다.
			 * EVAL_FLAG 는 제안평가의 FLAG값으로 사용합니다.
			 * 평가대상 등록의 FLAG 값을 관리하지 않습니다.
			 */
			if("N".equals(eval_flag)){	//평가제외일 경우 ICOYBDHD에 업데이트 처리.
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("eval_flag", eval_flag);
				wxp.addVar("eval_refitem", eval_refitem);
				wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
				wxp.addVar("doc_no", doc_no);
				wxp.addVar("doc_count", doc_count);
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				rtn	= sm.doUpdate((String[][])null, null); 
			}
		}catch(Exception e)	{ 
			rtn=0;
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			throw new Exception(e.getMessage()); 
		} 
		return rtn; 
	} 
	

	private String et_setEvalInsert(String doc_no, String doc_count, String eval_name, Integer eval_id) throws Exception 
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
			String evaltemp_num	= "";
			String from_date  	= "";
			String to_date  	= "";
			String flag			= "2"; 	//eval_status[2]
			 
			//템플릿코드 조회
			String rtn1 = getEvalTemplate(eval_id);
			wf =  new SepoaFormater(rtn1);
			if(wf != null && wf.getRowCount() > 0) {
				evaltemp_num = wf.getValue("text3", 0);
				from_date = wf.getValue("FROMDATE", 0);
				to_date = wf.getValue("TODATE", 0);
			}
			Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 템플릿코드::"+evaltemp_num);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[doc_no]::"+doc_no);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[doc_count]::"+doc_count);
			
			//평가자 조회
			String rtn2 = getEvalUser(doc_no, doc_count, eval_id);
			wf =  new SepoaFormater(rtn2);
			String[] eval_user_id = new String[wf.getRowCount()];
			String[] eval_user_dept = new String[wf.getRowCount()];
			for(int	i=0; i<wf.getRowCount(); i++) {	
				eval_user_id[i] = wf.getValue("PROJECT_PM", i);
				eval_user_dept[i] = wf.getValue("PROJECT_DEPT", i);
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자::"+eval_user_id[i]);
			}
			 
			//평가업체 조회
			String rtn3 = getEvalCompany(doc_no, doc_count);
			wf =  new SepoaFormater(rtn3);
			
			String setData[][] = new String[wf.getRowCount()*eval_user_id.length][];
			int kk=0;
			for(int	i=0; i<wf.getRowCount(); i++) {	
				for(int j=0; j<eval_user_id.length; j++){
					Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가업체::"+wf.getValue("VENDOR_CODE", i));
					String Data[] = { wf.getValue("VENDOR_CODE", i), "N", "0", eval_user_id[j], eval_user_dept[j]};
					setData[kk] = Data;
					kk++;
				}
			}
			
			//평가마스터 일련번호 조회
    		SepoaXmlParser wxp =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_0");
			wxp.addVar("house_code", house_code);
			sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
  	    	String rtn = sm.doSelect((String[])null);
  	    	wf =  new SepoaFormater(rtn);
	    	
  	    	String max_eval_refitem = "";
	    	if(wf != null && wf.getRowCount() > 0) {
	    		max_eval_refitem = wf.getValue("MAX_EVAL_REFITEM", 0);
			}
	    	Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가일련번호::"+max_eval_refitem);
	    	
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
	    	wxp_1.addVar("DOC_TYPE", "BD");	//입찰
	    	wxp_1.addVar("DOC_NO", doc_no);
	    	wxp_1.addVar("DOC_COUNT", doc_count);
			sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_1.getQuery() );
			rtnIns = sm.doInsert((String[][]) null, null );
			Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가마스터 정보 저장 끝");
			
			String i_sg_refitem = "";
			String i_vendor_code = "";
			String i_value_id = "";
			String i_value_dept = "";

			//평가대상업체 테이블 생성
			SepoaXmlParser wxp_2 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_2");
			
			//평가대상업체 평가자 테이블 생성
			SepoaXmlParser wxp_3 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_3");
			
			for ( int i = 0; i < setData.length; i++ )
			{
				i_sg_refitem 	= setData[i][2];
				i_vendor_code 	= setData[i][0];
				i_value_id 		= setData[i][3];
				i_value_dept 	= setData[i][4];

				//평가대상업체 테이블 생성
				wxp_2.addVar("house_code", house_code);
				wxp_2.addVar("i_sg_refitem", i_sg_refitem);
				wxp_2.addVar("i_vendor_code", i_vendor_code);
				wxp_2.addVar("max_eval_refitem", max_eval_refitem);

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_2.getQuery() );
				rtnIns = sm.doInsert((String[][]) null, null );
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가대상업체 정보 저장 끝");
				
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자 ::"+i_value_id);
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자 부서 ::"+i_value_dept);
				
				//평가자 생성하기
				/*
				int row_cnt = st.countTokens();
				String[][] value_data = new String[row_cnt][2];

				for ( int j = 0 ; j < row_cnt ; j++ ) 
				{
					SepoaStringTokenizer st1 = new SepoaStringTokenizer(st.nextToken().trim(), "@", false);
					int row_cnt1 = st1.countTokens();

					for ( int k = 0 ; k < row_cnt1 ; k++ ) 
					{
						String tmp_data = st1.nextToken().trim();

						if(k == 0)
							value_data[j][0] = tmp_data;//부서코드
						else if(k ==3)
							value_data[j][1] = tmp_data;//평가자ID
					}	
				}
				*/
				
				String i_dept = "";
				String i_id = "";

				//평가대상업체 평가자 테이블 생성
				wxp_3.addVar("house_code", house_code);
				wxp_3.addVar("i_dept", i_value_dept);
				wxp_3.addVar("i_id", i_value_id);
				wxp_3.addVar("getCurrVal", getCurrVal("icomvevd", "eval_item_refitem"));

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_3.getQuery() );
				rtnIns = sm.doInsert((String[][]) null, null );
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

	/*
	 * 제안 평가 생성
	 */
	public SepoaOut setEvalPropInert(Map<String, Object> data)	
	{
		try{

			Logger.debug.println(info.getSession("ID"),this, "[setEvalPropInsert]=========================평가 여부  및 평가 생성 START::");
			int rtn = et_setEvalPropInsert(data); 
			Logger.debug.println(info.getSession("ID"),this, "[setEvalPropInsert]=========================평가 여부  및 평가 생성 END::"+rtn);

			setValue(String.valueOf(rtn));  
			if(rtn==0){
				Rollback();
				setStatus(0); 
				setMessage("평가정보 처리중 오류가 발생하였습니다.");
			}else{
				Commit();
				setStatus(1); 
//				setValue(rtn+"");
				setMessage(rtn + ""); 
			}
		 	
		}catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			setStatus(0); 
			setMessage("평가정보 처리중 오류가 발생하였습니다."); 
		} 
		
		return getSepoaOut(); 
	}
	
	/*
	 * 제안 평가 생성
	 */
	private	int et_setEvalPropInsert(Map<String, Object> data) throws Exception 
	{ 
		int rtn =  0;
		Integer eval_refitem = 0;
		
		ConnectionContext ctx =	getConnectionContext(); 
		
//		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [doc_no]::"+doc_no);
//		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [doc_count]::"+doc_count);
//		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_name]::"+eval_name);
//		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_flag]::"+eval_flag);
//		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_id]::"+eval_id);
//		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [from_date]::"+from_date);
//		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [to_date]::"+to_date);
		
		try{ 
			Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 START");
			String rtn1 =  et_setEvalPropInsert_1(data);

			if("".equals(rtn1)){
	             Rollback();
	             setStatus(0);
	             setMessage(msg.getMessage("9003"));
	             return 0;
	         }
	         eval_refitem = Integer.valueOf(rtn1);
			
			Logger.debug.println(info.getSession("ID"),this, "=========================평가 상태 등록");
			
			Map <String, String> header = MapUtils.getMap(data, "headerData");
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, "et_setEvalInsert");
			wxp.addVar("eval_flag"		, "T");
			wxp.addVar("eval_refitem"	, eval_refitem);
			wxp.addVar("house_code"		, info.getSession("HOUSE_CODE"));
			wxp.addVar("doc_no"			, header.get("bid_no"));
			wxp.addVar("doc_count"		, header.get("bid_count"));
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
			rtn	= sm.doUpdate((String[][])null, null); 
			
		}catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			throw new Exception(e.getMessage()); 
		} 
		return eval_refitem; 
	} 
	
	/*
	 * 제안 평가 생성
	 */
	private String et_setEvalPropInsert_1(Map<String, Object> data) throws Exception 
	{
		String returnString = "";
		ConnectionContext ctx = getConnectionContext();
		
		String user_id 		= info.getSession("ID");
		String house_code 	= info.getSession("HOUSE_CODE");

		int rtnIns = 0;
		SepoaFormater wf = null;
		SepoaSQLManager sm = null;
		
		
		List<Map<String, String>> grid          = null;
		Map<String, String>       gridInfo      = null;
		Map<String, String> 	  header		= null;
		header = MapUtils.getMap(data, "headerData");

		try 
		{
			
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			
			String auto = "N";
			String evaltemp_num	= "";
			String flag			= "2"; 	//eval_status[2]
			 
			//템플릿코드 조회
			String rtn1 = getEvalTemplate(Integer.parseInt(header.get("evaltemp_num")));
			wf =  new SepoaFormater(rtn1);
			if(wf != null && wf.getRowCount() > 0) {
				evaltemp_num = wf.getValue("text3", 0);
			}
			Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 템플릿코드::"+evaltemp_num);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[doc_no]::"+header.get("bid_no"));
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[doc_count]::"+header.get("bid_count"));
			
			//평가자 
			String[] eval_user_id = new String[ grid.size()];
			String[] eval_user_name = new String[ grid.size()];
			String[] eval_user_comp = new String[ grid.size()];
			for(int	i=0; i< grid.size(); i++) {	
				eval_user_comp[i] 	=  grid.get(i).get("EVAL_VALUER_DEPT_NAME");
				eval_user_name[i] 	=  grid.get(i).get("EVAL_VALUER_NAME");
				eval_user_id[i] 	=  CommonUtil.getConfig("sepoa.eval.user_id");
						
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자::"+eval_user_name[i]);
			}
			 
			//평가업체 조회
			String rtn3 = getEvalCompany(header.get("bid_no"), header.get("bid_count"));
			wf =  new SepoaFormater(rtn3);
			
			String setData[][] = new String[wf.getRowCount()][];
			int kk=0;
			for(int	i=0; i<wf.getRowCount(); i++) {	
					Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가업체::"+wf.getValue("VENDOR_CODE", i));
					String Data[] = { wf.getValue("VENDOR_CODE", i), "N", "0"};
					setData[kk] = Data;
					kk++;
			}
			
			//평가마스터 일련번호 조회
    		SepoaXmlParser wxp =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_0");
			wxp.addVar("house_code", house_code);
			sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
  	    	String rtn = sm.doSelect((String[])null);
  	    	wf =  new SepoaFormater(rtn);
	    	
  	    	String max_eval_refitem = "";
	    	if(wf != null && wf.getRowCount() > 0) {
	    		max_eval_refitem = wf.getValue("MAX_EVAL_REFITEM", 0);
			}
	    	Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가일련번호::"+max_eval_refitem);
	    	
			//평가테이블 생성 - ADD( 견적[RQ]/입찰[BD]/역경매[RA] 구분, 문서번호, 문서SEQ 등록)
	    	SepoaXmlParser wxp_1 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_prop");
	    	wxp_1.addVar("house_code", house_code);
	    	wxp_1.addVar("max_eval_refitem", max_eval_refitem);
	    	wxp_1.addVar("evalname", header.get("evalname"));
	    	wxp_1.addVar("flag", flag);
	    	wxp_1.addVar("evaltemp_num", evaltemp_num);
	    	wxp_1.addVar("fromdate", header.get("fromdate"));
	    	wxp_1.addVar("todate", header.get("todate"));
	    	wxp_1.addVar("auto", auto);
	    	wxp_1.addVar("user_id", user_id);
	    	wxp_1.addVar("DOC_TYPE", "BD");	//입찰
	    	wxp_1.addVar("DOC_NO", header.get("bid_no"));
	    	wxp_1.addVar("DOC_COUNT", header.get("bid_count"));
	    	wxp_1.addVar("ATTACH_NO", header.get("attach_no"));
			sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_1.getQuery() );
			rtnIns = sm.doInsert((String[][]) null, null );
			Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가마스터 정보 저장 끝");
			
			String i_sg_refitem = "";
			String i_vendor_code = "";
			String i_value_id = "";
			String i_value_name = "";
			String i_value_dept = "";

			//평가대상업체 테이블 생성
			SepoaXmlParser wxp_2 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_2");
			
			//평가대상업체 평가자 테이블 생성
			SepoaXmlParser wxp_3 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_3_1");
			
			Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가대상업체 정보  setData.length::"+setData.length);
			for ( int i = 0; i < setData.length; i++ )
			{
				i_sg_refitem 	= setData[i][2];
				i_vendor_code 	= setData[i][0];
				
				
				//평가대상업체 테이블 생성
				wxp_2.addVar("house_code", house_code);
				wxp_2.addVar("i_sg_refitem", i_sg_refitem);
				wxp_2.addVar("i_vendor_code", i_vendor_code);
				wxp_2.addVar("max_eval_refitem", max_eval_refitem);

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_2.getQuery() );
				rtnIns = sm.doInsert((String[][]) null, null );
				
				for(int j=0; j<eval_user_id.length; j++){
					i_value_id 		= eval_user_id[j];
					i_value_name 	= eval_user_name[j];
					i_value_dept 	= eval_user_comp[j];
					
					Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가대상업체 ::"+i_vendor_code);
					Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자 ::"+i_value_name);
					Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자 부서 ::"+i_value_dept);
					 
					//평가대상업체 평가자 테이블 생성
					wxp_3.addVar("house_code", house_code);
					wxp_3.addVar("i_dept", i_value_dept);
					wxp_3.addVar("i_id", i_value_id);
					wxp_3.addVar("i_name", i_value_name);
					wxp_3.addVar("getCurrVal", getCurrVal("icomvevd", "eval_item_refitem"));

					sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_3.getQuery() );
					rtnIns = sm.doInsert((String[][]) null, null );
				}
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가대상업체, 평가자 정보 저장 회수 ::" + i);
			}
			Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가대상업체, 평가자 정보 저장 끝");
			
			//평가일련번호를 리턴해 줌.
			returnString = max_eval_refitem;

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
  			rtn = sm.doSelect((String[])null);
      	
              setValue(rtn);
              setStatus(1);

          } catch(Exception e) {

              Logger.err.println("Exception e =" + e.getMessage());
              setStatus(0);
              Logger.err.println(this,e.getMessage());
          }
          return getSepoaOut();
      }    


	 	/*
		 * 제안 평가 평가자 평가정보 삭제
		 */
		public SepoaOut setEvalPropUpdate(String doc_no, String doc_count, String eval_refitem, String eval_item_refitem, String eval_valuer_refitem)	
		{
			try{
				int rtn = et_setEvalPropUpdate(doc_no, doc_count, eval_refitem, eval_item_refitem, eval_valuer_refitem); 

				Logger.debug.println(info.getSession("ID"),this, "rtn="+rtn);
				
				setValue(String.valueOf(rtn));  
				if(rtn==0){
					Rollback();
					setStatus(0); 
					setMessage("평가정보 삭제 처리중 오류가 발생하였습니다.");
				}else{
					Commit();
					setStatus(1); 
					setMessage("평가정보가 정상적으로 삭제 처리되었습니다."); 
				}
			 	
			}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				setStatus(0); 
				setMessage("평가정보 삭제 처리중 오류가 발생하였습니다."); 
			} 
			
			return getSepoaOut();
		}
		
		/*
		 * 제안 평가 평가자 평가정보 삭제
		 */
		
		private	int et_setEvalPropUpdate(String doc_no, String doc_count, String eval_refitem, String eval_item_refitem, String eval_valuer_refitem) throws Exception 
		{ 
			int rtn =  0;
			 
			ConnectionContext ctx =	getConnectionContext(); 
			String house_code = info.getSession("HOUSE_CODE");
      		
			SepoaXmlParser wxp_1 = new SepoaXmlParser(this, "et_setEvalPropUpdate_1");
			SepoaXmlParser wxp_2 = new SepoaXmlParser(this, "et_setEvalPropUpdate_2");
			SepoaXmlParser wxp_3 = new SepoaXmlParser(this, "et_setEvalPropUpdate_3");
			SepoaXmlParser wxp_4 = new SepoaXmlParser(this, "et_setEvalPropUpdate_4");
			
			wxp_1.addVar("house_code", house_code);
			wxp_1.addVar("eval_valuer_refitem", eval_valuer_refitem);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp_1.getQuery());
			rtn	= sm.doUpdate((String[][])null, null); 
			
			wxp_2.addVar("house_code", house_code);
			wxp_2.addVar("eval_valuer_refitem", eval_valuer_refitem);
			sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp_2.getQuery());
			rtn	= sm.doUpdate((String[][])null, null); 
			
			wxp_3.addVar("house_code", house_code);
			wxp_3.addVar("eval_item_refitem", eval_item_refitem);
			sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp_3.getQuery());
			rtn	= sm.doUpdate((String[][])null, null); 
			
			wxp_4.addVar("eval_flag", "P");  //진행중 
			wxp_4.addVar("house_code", house_code);
			wxp_4.addVar("doc_no", doc_no);
			wxp_4.addVar("doc_count", doc_count);
			sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp_4.getQuery());
			rtn	= sm.doUpdate((String[][])null, null); 
				
			return rtn; 
		} 
}
