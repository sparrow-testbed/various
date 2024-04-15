package dt.bidd;
import java.util.Map;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;

public class p1014 extends SepoaService
{
    private String HOUSE_CODE     = info.getSession("HOUSE_CODE");
    private String COMPANY_CODE   = info.getSession("COMPANY_CODE");
    private String DEPT           = info.getSession("DEPARTMENT");
    private String DEPT_NAME      = info.getSession("DEPARTMENT_NAME_LOC");
    private String USER_ID        = info.getSession("ID");
    private String NAME_ENG       = info.getSession("NAME_ENG");
    private String NAME_LOC       = info.getSession("NAME_LOC");
    private String LOCATION       = info.getSession("LOCATION_CODE");
    private String LOCATION_NAME  = info.getSession("LOCATION_NAME");
    private String OPERATING_CODE = info.getSession("LOCATION_CODE");
    private String CTRL_CODE      = info.getSession("CTRL_CODE");
    private String TEL            = info.getSession("TEL");
    private String LANG           = info.getSession("LANGUAGE");

    private sepoa.fw.msg.Message msg = new sepoa.fw.msg.Message(info,"p10_pra");

    public p1014(String opt,SepoaInfo info) throws SepoaServiceException
    {
        super(opt,info);
        setVersion("1.0.0");
    }
        

    public SepoaOut getRestricLowest(Map<String, String> header) {
        try{
            
        	
        	
            String rtn = et_getRestricLowest(header);
            
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
    
    private String et_getRestricLowest(Map<String, String> header) throws Exception {
        
		String rtn = "";

        ConnectionContext ctx = getConnectionContext();
        
        SepoaSQLManager sm = null;
        SepoaXmlParser wxp = null;
        
        try {
        	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());	
            sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            rtn = sm.doSelect(header);
		} catch (Exception e) {
			Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());

		}
        return rtn;
//        
//        StringBuffer sb = new StringBuffer();
//        sb.append("				SELECT  ANN_ITEM     AS ANN_ITEM																		\n ");
//		sb.append("				       ,BASIC_AMT    AS BASIC_AMT                                                                       \n ");
//		sb.append("				       ,(                                                                                               \n ");
//		sb.append("				         SELECT  ESTM_PRICE                                                                             \n ");
//		sb.append("				         FROM    ICOYBDCP                                                                               \n ");
//		sb.append("				         WHERE   HOUSE_CODE = HD.HOUSE_CODE                                                             \n ");
//		sb.append("				         AND     BID_NO     = HD.BID_NO                                                                 \n ");
//		sb.append("				         AND     BID_COUNT  = HD.BID_COUNT                                                              \n ");
//		sb.append("				         AND     ROWNUM = 1                                                                             \n ");
//		sb.append("				        )            AS ESTM_PRICE                                                                      \n ");
//		//sb.append("				       , --TRUNC((12000000/14630000)*100,1) AS RATE --에비내정가격/예정가격 * 100                       \n ");
//		sb.append("				       ,FINAL_ESTM_PRICE_ENC                                                                            \n ");
//		sb.append("				       ,TRUNC(GETAVERAGEPRICE(HD.HOUSE_CODE,HD.BID_NO, HD.BID_COUNT,FINAL_ESTM_PRICE_ENC),2)   AS AVERAGEPRICE               \n ");
//		sb.append("				       ,(                                                                                               \n ");
//		sb.append("				         SELECT  BID_AMT                                                                                \n ");
//		sb.append("				         FROM    ICOYBDVO                                                                               \n ");
//		sb.append("				         WHERE   HOUSE_CODE = HD.HOUSE_CODE                                                             \n ");
//		sb.append("				         AND     BID_NO     = HD.BID_NO                                                                 \n ");
//		sb.append("				         AND     BID_COUNT  = HD.BID_COUNT                                                              \n ");
//		sb.append("				         AND     BID_STATUS = 'SB'                                                                      \n ");
//		sb.append("				         AND     ROWNUM     = 1                                                                         \n ");
//		sb.append("				        )            AS BID_AMT                                                                         \n ");
//		sb.append("				       ,GETSETTLEAVERAGEPRICE(HD.HOUSE_CODE,HD.BID_NO, HD.BID_COUNT,FINAL_ESTM_PRICE_ENC) AS SETTLEAVERAGEPRICE              \n ");
//		sb.append("				       ,HD.CONT_TYPE2                                                                                   \n ");
//		sb.append("				FROM   ICOYBDHD   HD                                                                                    \n ");
//		sb.append("				      ,ICOYBDES   ES                                                                                    \n ");
//		sb.append("				      ,iCOYBDPG   PG                                                                                    \n ");
//		sb.append("				WHERE  HD.HOUSE_CODE = ES.HOUSE_CODE                                                                    \n ");
//		sb.append("				AND    HD.BID_NO     = ES.BID_NO                                                                        \n ");
//		sb.append("				AND    HD.BID_COUNT  = ES.BID_COUNT                                                                     \n ");
//		sb.append("				AND    HD.HOUSE_CODE = PG.HOUSE_CODE                                                                    \n ");
//		sb.append("				AND    HD.BID_NO     = PG.BID_NO                                                                        \n ");
//		sb.append("				AND    HD.BID_COUNT  = PG.BID_COUNT                                                                     \n ");
//		sb.append("				AND    HD.STATUS IN ('R', 'C')																			\n ");
//		sb.append("				AND    ES.STATUS IN ('R', 'C')																			\n ");
//		sb.append("				AND    PG.STATUS IN ('R', 'C')																			\n ");
//		sb.append("				AND    HD.BID_STATUS ='SB'                                                                              \n ");
//		sb.append("				AND    HD.CONT_TYPE2 ='RL'                                                                              \n ");
//		sb.append("   <OPT=S,S> AND    PG.BID_END_DATE BETWEEN  ? </OPT> <OPT=S,S> AND  ?   </OPT>     \n");
//		
//		// 구매입찰
//		if( gubun.equals("D") ){ 
//			sb.append("         AND    HD.BID_TYPE = 'D'                                 \n");
//		}
//		// 공사입찰
//		else if(  gubun.equals("C") ){
//			sb.append("         AND    HD.BID_TYPE = 'C'                                  \n");
//		}
//		
//
//        try{
//            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sb.toString());
//            
//            String[] args = { from_date, to_date };
//            rtn = sm.doSelect(args);
//            
//        }catch(Exception e) {
//            Logger.err.println(userid,this,e.getMessage());
//            throw new Exception(e.getMessage());
//        }
    }
}