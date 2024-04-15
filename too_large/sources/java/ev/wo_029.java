package ev;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;

import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaDate;

public class WO_029 extends SepoaService{

	public WO_029(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		setVersion("1.0.0");
	}

	public SepoaOut ev_query( String p_year, String ev_no, String subject, String sg_kind, String seller_code, String vn_status ) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;

			rtn  = et_ev_query( p_year, ev_no, subject, sg_kind, seller_code, vn_status );

			if (rtn[1] != null){
				setStatus(0);
				setFlag(false);				
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
			}

			setValue(rtn[0]);
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
	
	private String[] et_ev_query( String p_year, String ev_no, String subject, String sg_kind, String seller_code, String vn_status ) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		String cur_date       = SepoaDate.getShortDateString();
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sm.removeAllValue();
			sb.delete( 0, sb.length() );
			sb.append("								SELECT   A.SELLER_CODE                                                                                                      \n ");
			sb.append("			      						,B.VENDOR_NAME_LOC                                                                               \n ");
			sb.append("			      						,A.EV_NO                                                                                                            \n ");
			sb.append("				  						,GETSGNAME2(C.SG_KIND)                                                                             AS SG_KIND       \n ");
			sb.append("				  						,A.TEB_ID                                                                                                           \n ");
			sb.append("				  						,C.SUBJECT                                                                                                          \n ");
			sb.append("				  						,CONVERT_DATE(A.EV_DATE) AS EV_DATE                                                                                                          \n ");
			sb.append("				  						,DECODE( D.TOTAL_SCORE,'','평가미실행', DECODE(A.CONFIRM_FLAG,'Y','평가확정',DECODE( A.VN_STATUS,'WG','평가실행(적격)',DECODE( A.VN_STATUS,'WC','평가실행(부적격)','평가미실행') ) ) ) AS VN_STATUS     \n ");
			sb.append("			      						,A.EV_YEAR                                                                                                          \n ");
			sb.append("				  						,A.SG_REGITEM                                                                                                       \n ");
			sb.append("				  						,DECODE(A.OFFLINE_FLAG,NULL,'작성중','완료')  AS OFFLINE_FLAG                                                         \n ");  // 현장실사여부
			sb.append("				  						,A.SCORE   AS VN_SCORE                                                                                                       \n ");  // 평가점수  
			sb.append("				  						,C.ACCEPT_VALUE                                                                                                     \n "); // 적격점수
			sb.append("				  						,D.EVAL_ID		                                                                                                    \n ");
			sb.append(" ,(SELECT USER_NAME_LOC FROM ICOMLUSR WHERE HOUSE_CODE = '100' AND USER_TYPE = 'W100' AND STATUS != 'D' AND USER_ID = D.EVAL_ID ) AS EVAL_NAME			\n ");
			sb.append("								FROM   	 SEVVN     A                                                                                                        \n ");
			sb.append("			      						,ICOMVNGL  B                                                                                                        \n ");
			sb.append("			      						,SEVGL     C                                                                                                        \n ");
			sb.append("    			      					,(																													\n ");
			sb.append("			 				               SELECT EV_NO                                 																	\n ");
			sb.append("			 			       	                 ,EV_YEAR                               																	\n ");
			sb.append("			 				                     ,VENDOR_CODE                          	 																	\n ");
			sb.append("			 				                     ,SG_REGITEM                            																	\n ");
			sb.append("			 				                     ,CONVERT_DATE(MAX(ST_DATE))   AS ST_DATE             																	\n ");
			sb.append("			 				                     ,CONVERT_DATE(MAX(ET_DATE))   AS ET_DATE             																	\n ");
			sb.append("			 				                     ,EVAL_ID					             																	\n ");
			sb.append("			 				                     ,TOTAL_SCORE					             																	\n ");
			sb.append("			 			                   FROM   SINVN                                 																	\n ");
			sb.append("			 			                   WHERE  EV_FLAG  = 'Y'                        																	\n ");
			sb.append("			 			                   AND    DEL_FLAG = 'N'                        																	\n ");
			sb.append("			 			                   GROUP BY VENDOR_CODE                         																	\n ");
			sb.append("			 			                           ,EV_NO                               																	\n ");
			sb.append("			 					                   ,EV_YEAR                             																	\n ");
			sb.append("			 					                   ,SG_REGITEM                          																	\n ");
			sb.append("			 					                   ,EVAL_ID		                          																	\n ");
			sb.append("			 					                   ,TOTAL_SCORE		                          																	\n ");
			sb.append("			 				              )         D                                   																	\n ");
			sb.append("								WHERE  A.SELLER_CODE = B.VENDOR_CODE                                                                                        \n ");
			sb.append("								AND    A.EV_NO       = C.EV_NO                                                                                              \n ");
			sb.append("								AND    A.EV_YEAR     = C.EV_YEAR                                                                                            \n ");
			sb.append(" 							AND    A.EV_YEAR     = D.EV_YEAR																							\n ");
			sb.append("		 			            AND    A.EV_NO       = D.EV_NO                                                  											\n ");
			sb.append("		 			            AND    A.EV_YEAR     = D.EV_YEAR                                                											\n ");
			sb.append("		 			            AND    A.SELLER_CODE = D.VENDOR_CODE                                           												\n ");
			sb.append("		 			            AND    A.SG_REGITEM  = D.SG_REGITEM                                             											\n ");
			sb.append("								AND    A.DEL_FLAG    = 'N'                                                                                                  \n ");
			sb.append("								AND    C.DEL_FLAG    = 'N'                                                                                                  \n ");
			sb.append("								AND    C.SHEET_STATUS IN ( 'C', 'E', 'ED' )                                                                                 \n ");
			sb.append(sm.addSelectString("			AND    A.EV_YEAR     =  ?                                                                                                   \n "));  sm.addStringParameter(p_year);
			sb.append(sm.addSelectString("			AND    A.EV_NO   LIKE '%' || ? || '%'                                                                                       \n "));  sm.addStringParameter(ev_no);
			sb.append(sm.addSelectString("			AND    C.SUBJECT LIKE '%' || ? || '%'                                                                                       \n "));  sm.addStringParameter(subject);
			sb.append(sm.addSelectString("			AND    C.SG_KIND     =  ?                                                                                                   \n "));  sm.addStringParameter(sg_kind);
			sb.append(sm.addSelectString("			AND    A.SELLER_CODE =  ?                                                                                                   \n "));  sm.addStringParameter(seller_code);
			if( "WE".equals(vn_status) ){
				sb.append(sm.addSelectString("			AND    DECODE( D.TOTAL_SCORE,'','N',NVL(A.CONFIRM_FLAG,'N') ) =  ?                                                                                               \n "));  sm.addStringParameter("Y");
			}else{
				sb.append(sm.addSelectString("			AND    DECODE( D.TOTAL_SCORE,'','N', NVL(A.VN_STATUS,'N') )   =  ?                                                                                               \n "));  sm.addStringParameter(vn_status);
			}
			sb.append("                             ORDER BY SELLER_CODE                                                                                                        \n ");
			sb.append("                                     ,EV_NO                                                                                                              \n ");
			straResult[0] = sm.doSelect( sb.toString() );
			if( straResult[0] == null )	straResult[1] = "SQL manager is Null";
		}
		catch (Exception e)
		{
			straResult[1] = e.getMessage();
			Logger.debug.println(info.getSession("ID"), this, "=------------------ error.");
		}
		finally
		{
		}

		return straResult;
	}
}	

