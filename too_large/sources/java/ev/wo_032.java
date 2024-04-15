package ev;

import java.util.ArrayList;
import java.util.List;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;

import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

public class WO_032 extends SepoaService{

	public WO_032(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		setVersion("1.0.0");
	}
	
	public SepoaOut ev_query( String p_year, String p_ev_no, String p_conf_status ) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;

			rtn  = et_ev_query( p_year, p_ev_no, p_conf_status );

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
	
	private String[] et_ev_query( String p_year, String p_ev_no, String p_conf_status ) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		String cur_date       = SepoaDate.getShortDateString();
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sm.removeAllValue();
			sb.delete( 0, sb.length() );
			sb.append("			          SELECT  D.VENDOR_NAME_LOC AS SELLER_NAME                                                                         \n ");
			sb.append("			                 ,A.EV_NO                                                                                                  \n ");
			sb.append("			                 ,A.EV_YEAR                                                                                                \n ");
			sb.append("				             ,B.SUBJECT                                                                                                \n ");
			sb.append("				             ,B.ST_DATE || ' ~ ' || B.END_DATE                                                    AS CONF_DATE         \n ");
			sb.append("				             ,DECODE(C.ST_DATE || ' ~ ' || C.ET_DATE, ' ~ ', '', C.ST_DATE || ' ~ ' || C.ET_DATE) AS LIFNR_CONF_DATE   \n ");
			sb.append("				             ,A.SCORE                                                                                                  \n ");
			sb.append("				             ,B.ACCEPT_VALUE                                                                                           \n ");
			//sb.append("				             ,DECODE(A.EV_DATE,NULL,'작성중','완료')                                                AS EV_DATE_FLAG      \n ");
			sb.append("				             ,DECODE(C.TOTAL_SCORE,'','작성중',DECODE(A.EV_DATE,NULL,'작성중','완료') )					  AS EV_DATE_FLAG      \n ");
			sb.append("				             ,DECODE(A.OFFLINE_FLAG,NULL,'작성중','완료')                                           AS OFFLINE_FLAG      \n ");
			//sb.append("				             ,DECODE(A.CONFIRM_FLAG,'N','미확정',DECODE(A.REG_DATE,NULL,'미확정','확정'))            AS CONFIRM_FLAG      \n ");
			sb.append("				             ,DECODE(C.TOTAL_SCORE,'','미확정',DECODE(A.CONFIRM_FLAG,'N','미확정',DECODE(A.REG_DATE,NULL,'미확정','확정')) )           AS CONFIRM_FLAG      \n ");
			sb.append("				             ,A.SG_REGITEM                                                                                              \n ");
			sb.append("				             ,A.SELLER_CODE                                                                                             \n ");
			sb.append("				  			 ,C.EVAL_ID		                                                                                            \n ");
			sb.append(" ,(SELECT USER_NAME_LOC FROM ICOMLUSR WHERE HOUSE_CODE = '100' AND USER_TYPE = 'W100' AND STATUS != 'D' AND USER_ID = C.EVAL_ID ) AS EVAL_NAME			\n ");
			sb.append("			          FROM    SEVVN    A                                                                                                \n ");
			sb.append("			                 ,SEVGL    B                                                                                                \n ");
			sb.append("				             ,(                                                                                                         \n ");
			sb.append("				               SELECT EV_NO                                                                                             \n ");
			sb.append("			       	                 ,EV_YEAR                                                                                           \n ");
			sb.append("				                     ,VENDOR_CODE                                                                                       \n ");
			sb.append("				                     ,SG_REGITEM                                                                                        \n ");
			sb.append("				                     ,MAX(ST_DATE)   AS ST_DATE                                                                         \n ");
			sb.append("				                     ,MAX(ET_DATE)   AS ET_DATE                                                                         \n ");
			sb.append("				                     ,EVAL_ID                                                                         					\n ");
			sb.append("				                     ,TOTAL_SCORE                                                                         					\n ");
			sb.append("			                   FROM   SINVN                                                                                             \n ");
			sb.append("			                   WHERE  EV_FLAG  = 'Y'                                                                                    \n ");
			sb.append("			                   AND    DEL_FLAG = 'N'                                                                                    \n ");
			sb.append("			                   GROUP BY VENDOR_CODE                                                                                     \n ");
			sb.append("			                           ,EV_NO                                                                                           \n ");
			sb.append("					                   ,EV_YEAR                                                                                         \n ");
			sb.append("					                   ,SG_REGITEM                                                                                      \n ");
			sb.append("					                   ,EVAL_ID		                                                                                     \n ");
			sb.append("					                   ,TOTAL_SCORE                                                                                      \n ");
			sb.append("				               )         C                                                                                               \n ");
			sb.append("				              ,ICOMVNGL  D                                                                                               \n ");			
			sb.append("			           WHERE  A.EV_NO        = B.EV_NO                                                                                   \n ");
			sb.append("			           AND    A.EV_YEAR      = B.EV_YEAR                                                                                 \n ");
			sb.append("			           AND    A.EV_NO        = C.EV_NO                                                                                \n ");
			sb.append("			           AND    A.EV_YEAR      = C.EV_YEAR                                                                              \n ");
			sb.append("			           AND    A.SELLER_CODE  = C.VENDOR_CODE                                                                          \n ");
			sb.append("			           AND    A.SG_REGITEM   = C.SG_REGITEM                                                                           \n ");
			sb.append("			           AND    B.SHEET_STATUS IN ( 'C','E','ED' )                                                                         \n ");
			sb.append("			           AND    A.DEL_FLAG     = 'N'                                                                                       \n ");
			sb.append("			           AND    B.DEL_FLAG     = 'N'                                                                                       \n ");
			sb.append("					   AND    A.SELLER_CODE = D.VENDOR_CODE                                                                              \n ");
			sb.append(sm.addSelectString(" AND    A.EV_NO        LIKE '%' || ? || '%'                                                                        \n ")); sm.addStringParameter(p_ev_no);
			sb.append(sm.addSelectString(" AND    A.EV_YEAR      = ?                                                                                         \n ")); sm.addStringParameter(p_year);
			sb.append(sm.addSelectString(" AND    DECODE(C.TOTAL_SCORE,'','N',NVL(A.CONFIRM_FLAG,'N')) = ?                                                                                         \n ")); sm.addStringParameter(p_conf_status);
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
	
	public SepoaOut ev_insert( String[][] straData ) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;
			rtn = et_ev_insert(straData);

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
	
	private String[] et_ev_insert( String[][] straData ) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		SepoaFormater sf      = null;
		String user_id        = info.getSession("ID");
		String cur_date       = SepoaDate.getShortDateString();
		try
		{
			ParamSql sm           = new ParamSql(info.getSession("ID"), this, ctx);
			List taget            = new ArrayList();
			StringBuffer dataList = new StringBuffer();
			String tempEv_no  = "";
			
			for ( int a = 0; a < straData.length; a++ ){
				String ev_no = straData[a][1];
				if( !tempEv_no.equals( ev_no ) ) {
					if( a > 0 ){
						dataList.delete( 0, dataList.length() );
						dataList.append(tempEv_no);
						dataList.append(","+straData[a][10]);
						taget.add( dataList.toString() );
					}
					tempEv_no = ev_no;
				}
				if( a == ( straData.length-1 ) ) {
					dataList.delete( 0, dataList.length() );
					dataList.append(tempEv_no);
					dataList.append(","+straData[a][10]);
					taget.add( dataList.toString() );
				}
				sm.removeAllValue();
				sb.delete( 0, sb.length() );
				sb.append("		UPDATE SEVVN SET                           \n ");
				sb.append("		                 CONFIRM_FLAG = 'Y'        \n ");
				sb.append("		                ,REG_DATE     = ?          \n "); sm.addStringParameter(cur_date);
				sb.append("				   WHERE EV_NO        = ?          \n "); sm.addStringParameter(straData[a][1]);
				sb.append("				   AND   EV_YEAR      = ?          \n "); sm.addStringParameter(straData[a][10]);
				sb.append("				   AND   SG_REGITEM   = ?          \n "); sm.addStringParameter(straData[a][11]);
				sb.append("				   AND   SELLER_CODE  = ?          \n "); sm.addStringParameter(straData[a][12]);
				sm.doUpdate(sb.toString());
			}
			
			for( int j = 0; j < taget.size(); j++ ){
				String dataSplit = (String)taget.get(j);
				boolean isBool   = true;
				String[] data    = dataSplit.split(",");

				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("			       SELECT  A.EV_NO										\n ");
				sb.append("			              ,B.SELLER_CODE                                \n ");
				sb.append("			              ,B.REG_DATE						            \n ");
				sb.append("			              ,B.CONFIRM_FLAG                               \n ");
			    sb.append("				   		  ,C.EV_FLAG                                    \n ");
				sb.append("				   FROM    SEVGL  A                                     \n ");
				sb.append("			              ,SEVVN  B                                     \n ");
				sb.append("				   		  ,(                                            \n ");
				sb.append("				    		SELECT  EV_YEAR                             \n ");     
				sb.append("			               		  ,EV_NO                                \n ");  
				sb.append("			           		      ,VENDOR_CODE                          \n ");  
				sb.append("			          		      ,MAX(IN_REFITEM) AS IN_REFITEM        \n ");  
				sb.append("			          		      ,MAX(EV_FLAG)    AS EV_FLAG           \n ");  
				sb.append("			         		      ,SG_REGITEM                           \n ");  
				sb.append("							FROM    SINVN                               \n ");   
				sb.append("							WHERE   DEL_FLAG = 'N'                      \n ");
				sb.append("							AND   EV_FLAG = 'Y'                         \n ");
				sb.append(sm.addFixString("			AND   EV_NO    = ?                          \n ")); sm.addStringParameter(data[0]);
				sb.append(sm.addFixString("			AND   EV_YEAR  = ?	                        \n ")); sm.addStringParameter(data[1]);				         
				sb.append("							GROUP BY VENDOR_CODE                        \n ");   
				sb.append("					        		,EV_NO                              \n ");   
				sb.append("					        		,EV_YEAR                            \n ");   
				sb.append("					        		,SG_REGITEM                         \n ");
				sb.append("					        		,EVAL_ID	                        \n ");
				sb.append("			        		)     C                                     \n ");
				sb.append("					WHERE A.EV_NO    = B.EV_NO                          \n ");
				sb.append("					AND   A.EV_YEAR  = B.EV_YEAR                        \n ");
				sb.append("					AND   B.EV_NO    = C.EV_NO                          \n ");
				sb.append("					AND   B.EV_YEAR  = C.EV_YEAR                        \n ");
				sb.append("					AND   B.SELLER_CODE = C.VENDOR_CODE                 \n ");
				sb.append("					AND   B.SG_REGITEM  = C.SG_REGITEM                  \n ");
				sb.append("					AND   A.DEL_FLAG = 'N'                              \n ");
				sb.append("					AND   B.DEL_FLAG = 'N'                              \n ");
				sb.append("			        AND   A.SHEET_STATUS IN ( 'C','E' )                 \n ");
				sb.append(sm.addFixString("	AND   A.EV_NO    = ?                                \n ")); sm.addStringParameter(data[0]);
				sb.append(sm.addFixString("	AND   A.EV_YEAR  = ?	                            \n ")); sm.addStringParameter(data[1]);
				
				sf = new SepoaFormater( sm.doSelect_limit( sb.toString() ) );
				for( int i = 0; i < sf.getRowCount(); i++ ){
					if( sf.getValue("REG_DATE", i).equals("") && !sf.getValue("CONFIRM_FLAG", i).equals("Y") && !sf.getValue("EV_FLAG", i).equals("Y") ){
						isBool = false;
						break;
					}
				}
				
				if( isBool ){
					sm.removeAllValue();
					sb.delete( 0, sb.length() );
					sb.append("		UPDATE SEVGL SET                           \n ");
					sb.append("		                 SHEET_STATUS = 'ED'       \n ");
					sb.append("				   WHERE EV_NO        = ?          \n "); sm.addStringParameter(data[0]);
					sb.append("				   AND   EV_YEAR      = ?          \n "); sm.addStringParameter(data[1]);
					sm.doUpdate(sb.toString());					
				}
			}
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.getMessage();
//			e.printStackTrace();
			Logger.debug.println(user_id, this, e.getMessage());
		}
		finally
		{
		}

		return straResult;
	}	
}	

