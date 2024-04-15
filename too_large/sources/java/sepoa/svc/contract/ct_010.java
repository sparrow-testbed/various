package sepoa.svc.contract;

import java.util.StringTokenizer;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

public class CT_010 extends SepoaService
{
	private String ID = info.getSession("ID");
	private Message msg;

	public CT_010(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		setVersion("1.0.0");
		msg = new Message(info, "PO_002_BEAN");
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

	public SepoaOut getContractWaitList(String from_date, String to_date, String ctrl_person_id, String subject, String seller_code) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			
			//if(bd_methode.equals("")) {
				
				
				/*	
				sqlsb.append("SELECT DISTINCT            																						\n"); 
				sqlsb.append("                                                                                                          		\n"); 
				sqlsb.append("   	 H.QTA_NUMBER  AS CONTRACT_NUMBER  -- 견적번호                                                   			\n"); 
				sqlsb.append("   	,'' AS CONTRACT_COUNT   -- 견적차수                                      									\n"); 
				sqlsb.append("   	,D.SETTLE_DATE AS CONTRACT_DATE -- 낙찰일자                                                     			\n"); 
				sqlsb.append("   	,H.SUBJECT	   -- 견적명                                                                   					\n"); 
				sqlsb.append("   	,H.CTRL_PERSON_ID  -- 계약담당자                                                                			\n"); 
				sqlsb.append("   	,GETUSERNAME(H.CTRL_PERSON_ID, 'KO') AS CTRL_PERSON_NAEM   -- 계약담당자                        			\n"); 
				sqlsb.append("   	,H.SELLER_CODE AS CONT_SELLER_CODE                                                                          \n"); 
				sqlsb.append("   	,GETCOMPANYNAMELOC(H.SELLER_CODE, 'S') AS CONT_SELLER_NAME                                      			\n"); 
				sqlsb.append("   	,'RF' AS RFQ_TYPE                             																\n");
				sqlsb.append("      ,H.TTL_AMT||'' AS CONTRACT_AMT                                                                      		\n"); 
				sqlsb.append("   	, '수의계약' AS CONT_TYPE                                                                       			\n"); 
				sqlsb.append("   	,'UA' AS BD_KIND                                                                                            \n"); 
				sqlsb.append("   FROM SQTGL H                                                                                           		\n"); 
				sqlsb.append("   , SQTLN D                                                                                     					\n"); 
				sqlsb.append("    WHERE H.QTA_NUMBER  = D.QTA_NUMBER                                                                       		\n"); 
				sqlsb.append("    AND   H.SELLER_CODE = D.SELLER_CODE                                                                     		\n"); 
				sqlsb.append("                                                                                                          		\n"); 
				sqlsb.append("  AND NVL(H.DEL_FLAG, 'N') = 'N'                                                                        			\n"); 
				sqlsb.append("     AND D.SETTLE_FLAG = 'Y'                                                                              		\n"); 
				sqlsb.append("     AND NVL(H.CT_FLAG, 'N') = 'N'                                                                              	\n"); 
				sqlsb.append("     AND NVL(H.CT_FLAG, 'N') = 'N'                                                                              	\n"); 
				sqlsb.append(sm.addSelectString("     AND H.CTRL_PERSON_ID = ?                           										\n"));
				sm.addStringParameter(info.getSession("ID"));
				sqlsb.append(sm.addSelectString("     AND H.CHANGE_DATE BETWEEN ?                           									\n"));
				sm.addStringParameter(from_date);
				sqlsb.append(sm.addSelectString("     AND ?                                                 									\n"));
				sm.addStringParameter(to_date);
				sqlsb.append(sm.addSelectString("     AND  H.CTRL_PERSON_ID = ?                             									\n"));
				sm.addStringParameter(ctrl_person_id);
				sqlsb.append(sm.addSelectString("     AND  D.SELLER_CODE = ?                               										\n"));
				sm.addStringParameter(seller_code);
				
				
				sqlsb.append("                                                                                                          		\n"); 
				sqlsb.append("UNION ALL                                                                                                 		\n"); 
				sqlsb.append("																													\n"); 
				sqlsb.append("SELECT DISTINCT                                                                                                   \n"); 
				sqlsb.append("	VO.VOTE_NO AS CONTRACT_NUMBER  -- 입찰번호                                                                      \n"); 
				sqlsb.append("  ,'' AS CONTRACT_COUNT   -- 견적차수                                                                             \n"); 
				sqlsb.append("  ,GL.REQ_END_DATE AS CONTRACT_DATE -- 낙찰일자                                                                   \n"); 
				sqlsb.append("  ,GL.PUB_ITEM AS SUBJECT  -- 입찰명                                                                              \n"); 
				sqlsb.append("  ,CTRL_PERSON_ID AS CTRL_PERSON_ID   -- 계약담당자                                                               \n"); 
				sqlsb.append("  ,GETUSERNAME(GL.CTRL_PERSON_ID, 'KO') AS CTRL_PERSON_NAEM   -- 계약담당자                                       \n"); 
				sqlsb.append("  ,VO.SELLER_CODE  CONT_SELLER_CODE                                                                               \n"); 
				sqlsb.append("  ,CASE WHEN VO.BD_STATUS = 'SB' THEN GETCOMPANYNAMELOC(VO.SELLER_CODE, 'S')  ELSE '' END  CONT_SELLER_NAME       \n"); 
				sqlsb.append("  ,'BD' AS RFQ_TYPE                                                                                               \n"); 
				sqlsb.append("  ,VO.BD_AMT_ENC AS CONTRACT_AMT                             														\n");
				sqlsb.append("  ,'입찰' AS CONT_TYPE                                                                                            \n"); 
				sqlsb.append("  ,GL.BD_NO AS BD_KIND                                                                                            \n"); 
				sqlsb.append(" FROM SEBGL GL                                                                                                    \n"); 
				sqlsb.append(", SEBVO VO                                                                                                        \n"); 
				sqlsb.append("  WHERE GL.BD_NO = VO.BD_NO                                                                                       \n"); 
				sqlsb.append("  AND GL.BD_COUNT = VO.BD_COUNT                                                                                   \n"); 
				sqlsb.append("                                                                                                                  \n"); 
				sqlsb.append(" AND NVL(GL.DEL_FLAG, 'N') = 'N'                                                                                  \n"); 
				sqlsb.append("     AND GL.BD_COUNT = (SELECT MAX(BD_COUNT) FROM SEBGL WHERE BD_NO = GL.BD_NO)                                   \n"); 
				sqlsb.append("     AND GL.BD_STATUS= 'CB'                                                                                       \n"); 
				sqlsb.append("     AND NVL(VO.CT_FLAG, 'N') = 'N'                                                                               \n"); 
				sqlsb.append("            AND VO.BD_STATUS = 'SB'																				\n"); 
				
				sqlsb.append(sm.addSelectString("     AND CTRL_PERSON_ID = ?                           											\n"));
				sm.addStringParameter(info.getSession("ID"));
				sqlsb.append(sm.addSelectString(" AND GL.BD_OPEN_DATE BETWEEN ?																	\n"));
				sm.addStringParameter(from_date);
				sqlsb.append(sm.addSelectString("     AND ?                                                 									\n"));
				sm.addStringParameter(to_date);
				sqlsb.append(sm.addSelectString("     AND  GL.CTRL_PERSON_ID = ?                             									\n"));
				sm.addStringParameter(ctrl_person_id);
				sqlsb.append(sm.addSelectString("     AND  VO.SELLER_CODE = ?                               									\n"));
				sm.addStringParameter(seller_code);
				sqlsb.append("  ORDER BY 1 DESC,2,3,4,5																							\n");
				*/

			sqlsb.append("		SELECT  CONTRACT_NUMBER																									\n ");
			sqlsb.append("		       ,CONTRACT_COUNT                                                                                                  \n ");
			sqlsb.append("			   ,CONTRACT_DATE                                                                                                   \n ");
			sqlsb.append("			   ,SUBJECT                                                                                                         \n ");
			sqlsb.append("			   ,CTRL_PERSON_ID                                                                                                  \n ");
			sqlsb.append("			   ,CTRL_PERSON_NAME                                                                                                \n ");
			sqlsb.append("			   ,CONT_SELLER_CODE                                                                                                \n ");
			sqlsb.append("			   ,CONT_SELLER_NAME                                                                                                \n ");
			sqlsb.append("			   ,RFQ_TYPE                                                                                                        \n ");
			sqlsb.append("			   ,CONTRACT_AMT                                                                                                    \n ");
			sqlsb.append("			   ,CONT_TYPE                                                                                                       \n ");
			sqlsb.append("			   ,BD_KIND                                                                                                         \n ");
			sqlsb.append("			   ,PR_NO                                                                                                           \n ");
			sqlsb.append("			   ,BID_NO                                                                                                          \n ");
			sqlsb.append("			   ,BID_COUNT                                                                                                       \n ");
			sqlsb.append("			   ,BID_TYPE                                                                                                        \n ");
			sqlsb.append("			   ,ANN_VERSION                                                                                                     \n ");
			sqlsb.append("			   ,CONT_TYPE1_TEXT                                                                                                 \n ");
			sqlsb.append("			   ,CONT_TYPE2_TEXT                                                                                                 \n ");
			sqlsb.append("			   ,X_PURCHASE_QTY                                                                                                  \n ");
			sqlsb.append("			   ,DELV_PLACE                                                                                                      \n ");			
			sqlsb.append("		FROM (                                                                                                                  \n ");
			sqlsb.append("				SELECT  HD.ANN_NO                    as CONTRACT_NUMBER      --공고번호                                         \n ");	
			sqlsb.append("					   ,PG.VOTE_COUNT                as CONTRACT_COUNT       --차수                                             \n ");
			sqlsb.append("					   ,PG.BID_END_DATE              as CONTRACT_DATE        --입찰마감일자                                     \n ");			
			sqlsb.append("					   ,HD.ANN_ITEM	                 as SUBJECT              -- 입찰건명                                        \n ");				
			//sqlsb.append("					   ,getconprnnm(HD.BID_NO)   as CTRL_PERSON_ID       -- 구매담당자                                      \n ");                					
			//sqlsb.append("					   ,getuserlname(HD.BID_NO)  as CTRL_PERSON_NAME     -- 구매담당자                                      \n ");
			sqlsb.append("					   ,HD.ADD_USER_ID               as CTRL_PERSON_ID       -- 구매담당자ID                                    \n ");                					
			sqlsb.append("					   ,HD.ADD_USER_NAME_LOC         as CTRL_PERSON_NAME     -- 구매담당자성명                                  \n ");
			sqlsb.append("					   ,HD.BID_NO                    					        												\n ");
			sqlsb.append("					   ,HD.BID_COUNT                    					        											\n ");
			sqlsb.append("					   ,HD.BID_TYPE                   					        												\n ");
			sqlsb.append("					   ,HD.ANN_VERSION                   					        											\n ");
			sqlsb.append("					   ,(                                                                                                       \n ");
			sqlsb.append("						 SELECT  VENDOR_CODE                                                                                    \n ");
			sqlsb.append("						 FROM    ICOYBDVO                                                                                       \n ");
			sqlsb.append("						 WHERE   HOUSE_CODE = PG.HOUSE_CODE                                                                     \n ");
			sqlsb.append("						 AND     BID_NO     = PG.BID_NO                                                                         \n ");
			sqlsb.append("						 AND     BID_COUNT  = PG.BID_COUNT                                                                      \n ");
			sqlsb.append("						 AND     VOTE_COUNT = PG.VOTE_COUNT                                                                     \n ");
			sqlsb.append("						 AND     BID_CANCEL = 'N'                                                                               \n ");
			sqlsb.append("						 AND     BID_STATUS = 'SB'                                                                              \n ");
			sqlsb.append("						 AND     STATUS IN ('C', 'R')                                                                           \n ");
			sqlsb.append("						)  AS CONT_SELLER_CODE                                                                                  \n ");
			sqlsb.append("					   ,(                                                                                                       \n ");
//			sqlsb.append("						 SELECT  NAME_LOC                                                                                       \n ");
			sqlsb.append("						 SELECT  VENDOR_NAME_LOC                                                                                       \n ");
			sqlsb.append("						 FROM    ICOMVNGL                                                                                       \n ");
			sqlsb.append("						 WHERE   HOUSE_CODE = PG.HOUSE_CODE                                                                     \n ");
			sqlsb.append("						 AND     VENDOR_CODE = (                                                                                \n ");
			sqlsb.append("												SELECT VENDOR_CODE                                                              \n ");
			sqlsb.append("												FROM   ICOYBDVO                                                                 \n ");
			sqlsb.append("												WHERE  HOUSE_CODE = PG.HOUSE_CODE                                               \n ");
			sqlsb.append("												AND    BID_NO     = PG.BID_NO                                                   \n ");
			sqlsb.append("												AND    BID_COUNT  = PG.BID_COUNT                                                \n ");
			sqlsb.append("												AND    VOTE_COUNT = PG.VOTE_COUNT                                               \n ");
			sqlsb.append("												AND    BID_CANCEL = 'N'                                                         \n ");
			sqlsb.append("												AND    BID_STATUS = 'SB'                                                        \n ");
			sqlsb.append("												AND    STATUS IN ('C', 'R')                                                     \n ");
			sqlsb.append("											   )                                                                                \n ");
			sqlsb.append("						) AS CONT_SELLER_NAME                                                                                   \n ");
			sqlsb.append("					   ,'BD' AS RFQ_TYPE                             	                                                        \n ");
			sqlsb.append("					   ,NVL( (                                                                                                  \n ");
			sqlsb.append("							  SELECT BID_AMT                                                                       				\n ");	
			sqlsb.append("							  FROM   ICOYBDVO                                                             					    \n ");
			sqlsb.append("							  WHERE  HOUSE_CODE = HD.HOUSE_CODE                                                             	\n ");				
			sqlsb.append("							  AND    BID_NO     = HD.BID_NO                                                      				\n ");	
			sqlsb.append("							  AND    BID_COUNT  = HD.BID_COUNT                                                          		\n ");			
			sqlsb.append("							  AND    STATUS IN ('C', 'R')                                                           			\n ");		
			sqlsb.append("							  AND    BID_CANCEL = 'N'                                                                           \n ");
			sqlsb.append("							  AND    BID_STATUS = 'SB' ), 0) ||''                                                      			\n ");		
			sqlsb.append("													  AS CONTRACT_AMT                             					            \n ");
			sqlsb.append("					  , '입찰' AS CONT_TYPE                                                                       				\n ");	
			sqlsb.append("					  ,HD.BID_NO AS BD_KIND                                                                                     \n ");               					
			sqlsb.append("					  ,(SELECT DISTINCT PR_NO FROM ICOYBDDT WHERE BID_NO = HD.BID_NO ) AS PR_NO		  					        \n ");
			sqlsb.append("					  , HD.CONT_TYPE1             AS CONT_TYPE1_TEXT    --입찰방법		  										\n ");
			sqlsb.append("					  , HD.CONT_TYPE2             AS CONT_TYPE2_TEXT    --낙찰방법		  										\n ");
			sqlsb.append("					  , HD.X_PURCHASE_QTY         AS X_PURCHASE_QTY     --구매수량		  										\n ");
			sqlsb.append("					  , HD.DELY_PLACE             AS DELV_PLACE         --납품장소		  										\n ");
			sqlsb.append("				FROM  ICOYBDHD HD                                                                                       		\n ");			
			sqlsb.append("					 ,ICOYBDPG PG                                                                                 				\n ");	
			sqlsb.append("					 ,ICOYBDES ES                                                                              					\n ");
			sqlsb.append("					 ,(                                                                                                         \n ");
			sqlsb.append("					   SELECT COUNT(*) A                                                                             			\n ");		
			sqlsb.append("							 ,BID_NO                                                                            				\n ");	
			sqlsb.append("					   FROM ICOMQTEE                                                                          					\n ");
			sqlsb.append("					   GROUP BY BID_NO                                                                                          \n ");
			sqlsb.append("					   )  EE                                                                          					        \n ");
			sqlsb.append("				WHERE PG.HOUSE_CODE  = HD.HOUSE_CODE                                                                            \n ");
			sqlsb.append("				AND   HD.HOUSE_CODE  = '100'                                                                                    \n ");
			sqlsb.append("				AND   PG.BID_NO      = HD.BID_NO                                   					                            \n ");
			sqlsb.append("				AND   HD.BID_STATUS  IN ('SB')                                                                 					\n ");
			sqlsb.append("				AND   HD.BID_TYPE   in ('C','D')                                                                                \n ");                     					
			sqlsb.append("				AND   PG.BID_NO    = ES.BID_NO                                                                       			\n ");		
			sqlsb.append("				AND   PG.BID_count = ES.BID_count                                                                             	\n ");				
			sqlsb.append("				AND   PG.BID_NO    = EE.BID_NO AND   HD.SIGN_STATUS  IN ('C')                                                   \n ");                          					
			sqlsb.append("				AND   HD.STATUS IN ('C' ,'R')                                                                            		\n ");			
//			sqlsb.append("				AND   NVL(HD.CTRL_FLAG,'N') = 'N'                                                                            	\n ");				
			sqlsb.append("				AND   PG.STATUS IN ('C' ,'R') AND   HD.CHANGE_USER_NAME_LOC   !=  'C'                                           \n ");                             					
			sqlsb.append("              AND  (                           			                                                                    \n ");
			sqlsb.append(sm.addSelectString("     PG.BID_END_DATE BETWEEN  ?                          			                                        \n ")); sm.addStringParameter(from_date);
			sqlsb.append(sm.addSelectString("     AND  ?                           			                                                            \n ")); sm.addStringParameter(to_date);
			sqlsb.append(sm.addSelectString("     AND  HD.ANN_ITEM LIKE '%' || ? ||'%'                           			                            \n ")); sm.addStringParameter(subject);
			sqlsb.append("                        AND PG.BID_COUNT   = HD.BID_COUNT                                              			            \n ");
			sqlsb.append("                        OR  PG.BID_END_DATE IS NULL                       													\n ");
			sqlsb.append("                   )                               																			\n ");
			sqlsb.append("			)                                                                                                                   \n ");
			sqlsb.append("           WHERE 1=1                                                                                							\n ");
			sqlsb.append(sm.addSelectString(" AND   CONT_SELLER_CODE = ?                                                                                \n ")); sm.addStringParameter(seller_code);
			sqlsb.append(sm.addSelectString(" AND   SUBJECT LIKE '%' || ? || '%'                                                                        \n ")); sm.addStringParameter(subject);
			sqlsb.append(sm.addSelectString(" AND   CTRL_PERSON_ID = ?                                                                                  \n ")); sm.addStringParameter(ctrl_person_id);
			sqlsb.append("		ORDER BY CONTRACT_NUMBER DESC                                                                                           \n ");
	
			/*		
			} else if(bd_methode.equals("BD")) { //
				sqlsb.append("SELECT DISTINCT                                                                                                           \n"); 
				sqlsb.append("	VO.VOTE_NO AS CONTRACT_NUMBER  -- 입찰번호                                                                              \n"); 
				sqlsb.append("   	, '' AS CONTRACT_COUNT   -- 견적차수                                                                                \n"); 
				sqlsb.append("   	, GL.REQ_END_DATE AS CONTRACT_DATE -- 낙찰일자                                                                      \n"); 
				sqlsb.append("   	, GL.PUB_ITEM AS SUBJECT  -- 입찰명                                                                                 \n"); 
				sqlsb.append("      , CTRL_PERSON_ID AS CTRL_PERSON_ID   -- 계약담당자                                                                  \n"); 
				sqlsb.append("      , GETUSERNAME(GL.CTRL_PERSON_ID, 'KO') AS CTRL_PERSON_NAEM   -- 계약담당자                                          \n"); 
				sqlsb.append("   	, VO.SELLER_CODE  CONT_SELLER_CODE                                                                                  \n"); 
				sqlsb.append("   	, CASE WHEN VO.BD_STATUS = 'SB' THEN GETCOMPANYNAMELOC(VO.SELLER_CODE, 'S')  ELSE '' END  CONT_SELLER_NAME          \n"); 
				sqlsb.append("   	, VO.BD_AMT AS CONTRACT_AMT                             															\n");
				sqlsb.append("   	, '입찰' AS CONT_TYPE                                                                                               \n"); 
				sqlsb.append("   	, 'BD' AS RFQ_TYPE                                                                                                  \n"); 
				sqlsb.append("      , GL.BD_NO AS BD_KIND                                                                                               \n"); 
				sqlsb.append(" FROM SEBGL GL                                                                                                            \n"); 
				sqlsb.append(", SEBVO VO                                                                                                                \n"); 
				sqlsb.append("  WHERE GL.BD_NO = VO.BD_NO                                                                                               \n"); 
				sqlsb.append("  AND GL.BD_COUNT = VO.BD_COUNT                                                                                           \n"); 
				sqlsb.append("                                                                                                                          \n"); 
				sqlsb.append(" AND NVL(GL.DEL_FLAG, 'N') = 'N'                                                                                          \n"); 
				sqlsb.append("     AND GL.BD_COUNT = (SELECT MAX(BD_COUNT) FROM SEBGL WHERE BD_NO = GL.BD_NO)                                           \n"); 
				sqlsb.append("     AND GL.BD_STATUS = 'CB'                                                                                              \n"); 
				sqlsb.append("     AND NVL(VO.CT_FLAG, 'N') = 'N'                                                                                       \n"); 
				sqlsb.append("            AND VO.BD_STATUS = 'SB'																						\n"); 
				
				sqlsb.append(sm.addSelectString("     AND CTRL_PERSON_ID = ?                           													\n"));
				sm.addStringParameter(info.getSession("ID"));
				sqlsb.append(sm.addSelectString(" AND GL.BD_OPEN_DATE BETWEEN ?																			\n"));
				sm.addStringParameter(from_date);
				sqlsb.append(sm.addSelectString("     AND ?                                                 											\n"));
				sm.addStringParameter(to_date);
				sqlsb.append(sm.addSelectString("     AND  GL.CTRL_PERSON_ID = ?                             											\n"));
				sm.addStringParameter(ctrl_person_id);
				sqlsb.append(sm.addSelectString("     AND  VO.SELLER_CODE = ?                               											\n"));
				sm.addStringParameter(seller_code);
			}
			else if(bd_methode.equals("RF")) {
				sqlsb.append("SELECT DISTINCT            																								\n"); 
				sqlsb.append("                                                                                                          				\n"); 
				sqlsb.append("   	H.QTA_NUMBER  AS CONTRACT_NUMBER  -- 견적번호                                                   					\n"); 
				sqlsb.append("   	,'' AS CONTRACT_COUNT   -- 견적차수                                     											\n"); 
				sqlsb.append("   	,D.SETTLE_DATE AS CONTRACT_DATE -- 낙찰일자                                                     					\n"); 
				sqlsb.append("   	,H.SUBJECT	   -- 견적명                                                                   							\n"); 
				sqlsb.append("   	,H.CTRL_PERSON_ID  -- 계약담당자                                                                					\n"); 
				sqlsb.append("   	,GETUSERNAME(H.CTRL_PERSON_ID, 'KO') AS CTRL_PERSON_NAEM   -- 계약담당자                        					\n"); 
				sqlsb.append("   	,H.SELLER_CODE AS CONT_SELLER_CODE                                                                                 	\n"); 
				sqlsb.append("   	,GETCOMPANYNAMELOC(H.SELLER_CODE, 'S') AS CONT_SELLER_NAME                                      					\n"); 
				sqlsb.append("   	,H.TTL_AMT AS CONTRACT_AMT                                                                      					\n"); 
				sqlsb.append("   	, '수의계약' AS CONT_TYPE                                                                       					\n"); 
				sqlsb.append("   	,'RF' AS RFQ_TYPE                             																		\n");
				sqlsb.append("      , 'UA' AS BD_KIND                                                                                                   \n"); 
				sqlsb.append("   FROM SQTGL H                                                                                           				\n"); 
				sqlsb.append("   , SQTLN D                                                                                     							\n"); 
				sqlsb.append("   WHERE H.QTA_NUMBER = D.QTA_NUMBER                                                                       				\n"); 
				sqlsb.append("    AND H.SELLER_CODE = D.SELLER_CODE                                                                     				\n"); 
				sqlsb.append("                                                                                                          				\n"); 
				sqlsb.append("   AND NVL(H.DEL_FLAG, 'N') = 'N'                                                                        					\n"); 
				sqlsb.append("     AND D.SETTLE_FLAG = 'Y'                                                                              				\n"); 
				sqlsb.append("     AND NVL(H.CT_FLAG, 'N') = 'N'                                                                              			\n"); 
				sqlsb.append(sm.addSelectString("     AND H.CTRL_PERSON_ID = ?                           												\n"));
				sm.addStringParameter(info.getSession("ID"));
				sqlsb.append(sm.addSelectString("     AND H.CHANGE_DATE BETWEEN ?                           											\n"));
				sm.addStringParameter(from_date);
				sqlsb.append(sm.addSelectString("     AND ?                                                 											\n"));
				sm.addStringParameter(to_date);
				sqlsb.append(sm.addSelectString("     AND  H.CTRL_PERSON_ID = ?                             											\n"));
				sm.addStringParameter(ctrl_person_id);
				sqlsb.append(sm.addSelectString("     AND  D.SELLER_CODE = ?                               												\n"));
				sm.addStringParameter(seller_code);
			}
			*/
			setValue(sm.doSelect(sqlsb.toString()));
			
		} catch (Exception e) {
//			System.out.println("=======================================================");
//			e.printStackTrace();
//			System.out.println("=======================================================");
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
		
	}

	public SepoaOut getContractWaitListInsert(String rfq_number, String rfq_count, String seller_code, String rfq_type, String bd_kind, String pr_no) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		String[] rtn = null;
		String gubun = "";
		
		try {
			setStatus(1);
			setFlag(true);
			
			Logger.debug.println("rfq_type  ====>" + rfq_type);
			
			if(rfq_type.equals("RF")){
				
				rtn = et_getContractWaitPFListRF(rfq_number, rfq_count, seller_code);
				
				if (rtn[1] != null)
				{
					Rollback();
					setMessage(rtn[1]);
					Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
					setStatus(0);
					setFlag(false);
					return getSepoaOut();
				}
			} else if(rfq_type.equals("BD")){
				rtn = et_getContractWaitPFListBD(rfq_number, rfq_count, seller_code, bd_kind, pr_no);
				
				if (rtn[1] != null)
				{
					Rollback();
					setMessage(rtn[1]);
					Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
					setStatus(0);
					setFlag(false);
					return getSepoaOut();
				}
			}
			
			setValue((rtn != null && rtn[0] != null)?rtn[0]:"");
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	public String[] et_getContractWaitPFListRF(String rfq_number, String rfq_count, String seller_code) {
	
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		String COMPANY_CODE =  info.getSession("COMPANY_CODE");
		
		
		String[] rtn = new String[2];
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
		
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append(" SELECT																														\n");
			
			sqlsb.append("           LN.DESCRIPTION_LOC																									\n");
			sqlsb.append("          ,LN.SPECIFICATION    -- SPEC                                                            							\n");
			sqlsb.append("          ,LN.UNIT_MEASURE	                                                                    							\n");
			//sqlsb.append("          ,GETCODETEXT1('M007',LN.UNIT_MEASURE, 'KO') AS UNIT_MEASURE_TEXT													\n");
			sqlsb.append("          ,LN.UNIT_MEASURE AS UNIT_MEASURE_TEXT																				\n");
			sqlsb.append("          ,NVL(LN.ITEM_QTY, 0) AS SETTLE_QTY																					\n");
			sqlsb.append("          ,NVL(LN.UNIT_PRICE, 0) AS UNIT_PRICE																				\n");
			sqlsb.append("          ,NVL(LN.ITEM_AMT, 0) AS ITEM_AMT																					\n");
			sqlsb.append("          ,(NVL(LN.ITEM_AMT, 0)- (NVL(LN.ITEM_AMT, 0) * 0.1)) AS SUPPLY_AMT													\n");
			sqlsb.append("          ,(NVL(LN.ITEM_AMT, 0) * 0.1) AS SUPERTAX_AMT																		\n");
			sqlsb.append("          ,GL.RD_DATE																											\n");
			sqlsb.append("          ,LN.DELY_TO_LOCATION  AS DELV_PLACE																					\n");
			sqlsb.append("          ,LN.PR_NUMBER AS PR_NO																								\n");
			sqlsb.append("       	,LN.PR_SEQ AS PR_SEQ																								\n");
			
			sqlsb.append("          ,CASE WHEN LN.PR_USER_ID IS NOT NULL THEN LN.PR_USER_ID																\n");
			sqlsb.append("                ELSE (SELECT PR_USER_ID FROM SPRGL WHERE NVL(DEL_FLAG, 'N') = 'N'                 							\n");
			sqlsb.append("                   AND PR_NUMBER = LN.PR_NUMBER)                                                  							\n");
			sqlsb.append("           END PR_USER_ID																										\n");
			sqlsb.append("                                                                                                  							\n");
			sqlsb.append("          ,CASE WHEN LN.PR_USER_ID IS NOT NULL THEN GETUSERNAME(LN.PR_USER_ID, 'KO')                  						\n");
			sqlsb.append("                ELSE (SELECT GETUSERNAME(PR_USER_ID, 'KO') FROM SPRGL WHERE NVL(DEL_FLAG, 'N') = 'N'  						\n");
			sqlsb.append("               	 AND PR_NUMBER = LN.PR_NUMBER)                                                  							\n");
			sqlsb.append("           END PR_USER_NAME																									\n");
			sqlsb.append("                                                                                                      						\n");
			sqlsb.append("          ,CASE WHEN LN.DEMAND_DEPT IS NOT NULL THEN LN.DEMAND_DEPT                                         					\n");
			sqlsb.append("                ELSE  (SELECT DEMAND_DEPT FROM SPRGL WHERE NVL(DEL_FLAG, 'N') = 'N'                         					\n");
			sqlsb.append("                    AND PR_NUMBER = LN.PR_NUMBER)                                                     						\n");
			sqlsb.append("           END DEMAND_DEPT																									\n");
			sqlsb.append("                                                                                                                  			\n");
			sqlsb.append("          ,CASE WHEN LN.DEMAND_DEPT IS NOT NULL THEN GETDEPTNAME('"+COMPANY_CODE+"', LN.DEMAND_DEPT, 'KO')                    \n");
			sqlsb.append("                ELSE (SELECT GETDEPTNAME('"+COMPANY_CODE+"', DEMAND_DEPT, 'KO') FROM SPRGL WHERE NVL(DEL_FLAG, 'N') = 'N'		\n");
			sqlsb.append("                   AND PR_NUMBER = LN.PR_NUMBER)																				\n");
			sqlsb.append("           END DEMAND_DEPT_LOC																								\n");
			 
			
			
			sqlsb.append("          ,GL.SELLER_CODE																										\n");
			sqlsb.append("          ,GETCOMPANYNAMELOC(GL.SELLER_CODE, 'S') AS SELLER_NAME																\n");
			sqlsb.append("          ,LN.ACCOUNTS_COURSES_CODE																							\n");
			sqlsb.append("          ,LN.ACCOUNTS_COURSES_LOC																							\n");
			sqlsb.append("          ,LN.ASSET_NUMBER																									\n");
			sqlsb.append("          ,LN.MATERIAL_NUMBER																									\n");
			sqlsb.append("          ,LN.MAKER																											\n");
			sqlsb.append("          ,LN.YEAR_OF_MANUFACTURE																								\n");
			sqlsb.append("          ,LN.QTA_NUMBER  AS QTA_NO																							\n");
			sqlsb.append("          ,LN.QTA_SEQ																											\n");
			sqlsb.append("          ,LN.RFQ_NUMBER AS RFQ_NO																							\n");
			sqlsb.append("          ,LN.RFQ_COUNT																										\n");
			sqlsb.append("          ,LN.RFQ_SEQ																											\n");
			sqlsb.append("          ,LN.COMPANY_CODE-- company_code                                                         \n");
			sqlsb.append("                                                                                                  \n");
			sqlsb.append("     FROM SQTGL GL                                                                                \n");
			sqlsb.append("    , SQTLN LN                                                                           \n");
			sqlsb.append("      WHERE GL.QTA_NUMBER = LN.QTA_NUMBER                                                           \n");
			sqlsb.append("      AND GL.SELLER_CODE = LN.SELLER_CODE                                                         \n");
			sqlsb.append("                                                                                                  \n");
			sqlsb.append("    AND "+DB_NULL_FUNCTION+"(GL.DEL_FLAG, 'N') = 'N'                                         	\n");
			sqlsb.append("      AND "+DB_NULL_FUNCTION+"(LN.DEL_FLAG, 'N') = 'N'                                      		\n");
			
			sqlsb.append("      AND  LN.SETTLE_FLAG = 'Y'                                    		\n");
			
			sqlsb.append(sm.addSelectString("        AND LN.QTA_NUMBER = ?                                           		\n"));
			sm.addStringParameter(rfq_number);
			sqlsb.append(sm.addSelectString("        AND LN.QTA_COUNT  = ?                                           		\n"));
			sm.addStringParameter(rfq_count);
			sqlsb.append(sm.addSelectString("        AND LN.SELLER_CODE  = ?                                         		\n"));
			sm.addStringParameter(seller_code);
			
			sqlsb.append("    ORDER BY LN.RFQ_NUMBER, LN.RFQ_COUNT, LN.SELLER_CODE                                          \n");
			
			rtn[0] = sm.doSelect(sqlsb.toString());
			
		} 
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
//			e.printStackTrace();
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return rtn;
		
	}
	
	public String[] et_getContractWaitPFListBD(String rfq_number, String rfq_count, String seller_code, String bd_kind, String pr_no) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		String[] rtn = new String[2];
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			
			/*
			sqlsb.append("    SELECT                                                                                           \n");
			sqlsb.append("    	DESCRIPTION_LOC								AS DESCRIPTION_LOC			--ǰ��                                   \n");
			sqlsb.append("    	,SPECIFICATION								AS SPECIFICATION			--Spec                                     \n");
			sqlsb.append("    	,UNIT_MEASURE					            AS UNIT_MEASURE             --��'�ڵ�..                     \n");
			sqlsb.append("    	,GETCODETEXT1('M007', UNIT_MEASURE, 'KO')	AS UNIT_MEASURE_TEXT		--��'                       \n");
			sqlsb.append("    	,nvl(PR_QTY, 0)								AS SETTLE_QTY				--����                                   \n");
			sqlsb.append("    	,nvl(UNIT_PRICE, 0)							AS UNIT_PRICE				--���ܰ�                                 \n");
			sqlsb.append("    	,nvl(PR_AMT, 0)								AS ITEM_AMT					--���ݾ�                                   \n");
			sqlsb.append("    	,POR_DATE 									AS RD_DATE              	-- �������                              \n");
			sqlsb.append("    	,DILIVER_PLACE								AS DELV_PLACE				--��ǰ���                                   \n");
			sqlsb.append("    	,PR_NUMBER									AS PR_NO					--���ſ�û��ȣ                                   \n");
			sqlsb.append("    	,PR_SEQ										AS PR_SEQ					--���ſ�û�׹�                                     \n");
			sqlsb.append("    	,PR_USER_ID									AS PR_USER_ID				--���� ��û��                                  \n");
			sqlsb.append("    	,GETUSERNAME(PR_USER_ID, 'KO')             	AS PR_USER_NAME   			--���� ��û�ڸ�            \n");
			sqlsb.append("    	,DEMAND_DEPT                                AS DEMAND_DEPT                                     \n");
			sqlsb.append("    	,GETDEPTNAME('1000', DEMAND_DEPT, 'KO') 	AS DEMAND_DEPT_LOC 			-- ��û�μ�                  \n");
			sqlsb.append("    	,ACCOUNTS_COURSES_CODE						AS ACCOUNTS_COURSES_CODE	--��d����ڵ�                     \n");
			sqlsb.append("    	,ACCOUNTS_COURSES_LOC						AS ACCOUNTS_COURSES_LOC		--��d����                         \n");
			sqlsb.append("    	,ASSET_NUMBER								AS ASSET_NUMBER				--�ڻ��ȣ                                   \n");
			sqlsb.append("    	,MATERIAL_NUMBER							AS MATERIAL_NUMBER			--ǰ���ڵ�                               \n");
			sqlsb.append("    	,MAKER										AS MAKER					--fv��                                           \n");
			sqlsb.append("    	,YEAR_OF_MANUFACTURE						AS YEAR_OF_MANUFACTURE		--fv�⵵                           \n");
			sqlsb.append("    	,''								AS COMPANY_CODE				                                             \n");
			sqlsb.append("    FROM SEBLN                                                                                       \n");
			sqlsb.append("	 WHERE NVL(DEL_FLAG, 'N') = 'N'                                                   						\n");
			
			//sqlsb.append("	 AND (SELECT BD_STATUS FROM SEBVO WHERE BD_NO = VL.BD_NO AND BD_COUNT = VL.BD_COUNT AND SELLER_CODE = VL.SELLER_CODE)  = 'SB'		\n");
			
			sqlsb.append(sm.addSelectString("	  AND BD_NO = ?                                                      		\n"));
			sm.addStringParameter(bd_kind);
			
			sqlsb.append(sm.addSelectString("	  AND BD_COUNT = ?                                                        	\n"));
			sm.addStringParameter(rfq_count);
			
			sqlsb.append("    ORDER BY BD_NO, BD_COUNT                                          							\n");
			*/
			
			/*   기존
			 * 
			sqlsb.append(" SELECT                                                                                                                                          \n");
			sqlsb.append("          DESCRIPTION_LOC                                                         AS DESCRIPTION_LOC                      --ǰ��                 \n");
			sqlsb.append("         ,SPECIFICATION                                                          AS SPECIFICATION                --Spec                          \n");
			sqlsb.append("         ,UNIT_MEASURE                                               AS UNIT_MEASURE             --��'�ڵ�..                                    \n");
			//sqlsb.append("         ,GETCODETEXT1('M007', UNIT_MEASURE, 'KO')       AS UNIT_MEASURE_TEXT            --��'                                                  \n");
			sqlsb.append("         ,UNIT_MEASURE       AS UNIT_MEASURE_TEXT            --��'                                                  \n");
			sqlsb.append("         ,nvl(ITEM_QTY, 0)                                                         AS SETTLE_QTY                   --����                    \n");
			sqlsb.append("         ,nvl(UNIT_PRICE, 0)                                                     AS UNIT_PRICE                   --���ܰ�                      \n");
			sqlsb.append("         ,nvl(ITEM_AMT, 0)                                                         AS ITEM_AMT                             --���ݾ�            \n");
			sqlsb.append("         ,RD_DATE                                                         AS RD_DATE                      -- �������                            \n");
			sqlsb.append("         ,DELY_TO_LOCATION                                                          AS DELV_PLACE                   --��ǰ���                   \n");
			sqlsb.append("         ,PR_NUMBER                                                                      AS PR_NO                                --���ſ�û��ȣ  \n");
			sqlsb.append("         ,PR_SEQ                                                                         AS PR_SEQ                               --���ſ�û�׹�  \n");
			sqlsb.append("         ,PR_USER_ID                                                                     AS PR_USER_ID                           --���� ��û��   \n");
			sqlsb.append("         ,GETUSERNAME(PR_USER_ID, 'KO')                  AS PR_USER_NAME                         --���� ��û�ڸ�                                 \n");
			sqlsb.append("         ,DEMAND_DEPT                                AS DEMAND_DEPT                                                                              \n");
			sqlsb.append("         ,GETDEPTNAME('"+info.getSession("COMPANY_CODE")+"', DEMAND_DEPT, 'KO')         AS DEMAND_DEPT_LOC                      -- ��û�μ�                                     \n");
			sqlsb.append("         ,ACCOUNTS_COURSES_CODE                                          AS ACCOUNTS_COURSES_CODE    --��d����ڵ�                              \n");
			sqlsb.append("         ,ACCOUNTS_COURSES_LOC                                           AS ACCOUNTS_COURSES_LOC     --��d����                                \n");
			sqlsb.append("         ,ASSET_NUMBER                                                           AS ASSET_NUMBER                 --�ڻ��ȣ                      \n");
			sqlsb.append("         ,MATERIAL_NO                                                            AS MATERIAL_NUMBER              --ǰ���ڵ�                      \n");
			sqlsb.append("         ,MAKER                                                                          AS MAKER                                --fv��        \n");
			sqlsb.append("         ,YEAR_OF_MANUFACTURE                                            AS YEAR_OF_MANUFACTURE      --fv�⵵                                  \n");
			sqlsb.append("         ,''                                                             AS COMPANY_CODE                                                         \n");
			sqlsb.append("     FROM SEBVL                                                                                                                                  \n");
			sqlsb.append("    WHERE NVL(DEL_FLAG, 'N') = 'N'                                                                                                               \n");
			sqlsb.append(sm.addSelectString("	  AND BD_NO = ?                                                      		\n"));
			sm.addStringParameter(bd_kind);
			
			sqlsb.append(sm.addSelectString("	  AND BD_COUNT = ?                                                        	\n"));
			sm.addStringParameter(rfq_count);
			
			sqlsb.append(sm.addSelectString("      AND VOTE_NO = ?                                                          \n"));
			sm.addStringParameter(rfq_number);
			
			sqlsb.append("    ORDER BY BD_NO, BD_COUNT \n");
			
			rtn[0] = sm.doSelect(sqlsb.toString());
			
			*/
			
			
			sqlsb.append("  select                                                                                                                                                             \n");
			sqlsb.append("          ROWNUM                                                                                          as NO                                                      \n");
			sqlsb.append("        , HD.ANN_NO                                                                                                             --공고번호                           \n");
			sqlsb.append("        , HD.ANN_ITEM                                                                                                           --입찰건명                           \n");
			sqlsb.append("        , case when hd.cont_type1 = 'NC' then (                                                                                                                      \n");
			sqlsb.append("                                                case when hd.cont_type1 = 'NC' then (select count(*) as A                                                            \n");
			sqlsb.append("                                                                                       from ICOYBDAP                                                                 \n");
			sqlsb.append("                                                                                      where hd.bid_no    = bid_no                                                    \n");
			sqlsb.append("                                                                                        and hd.bid_count = bid_count)                                                \n");
			sqlsb.append("                                                     else 0                                                                                                          \n");
			sqlsb.append("                                                end                                                                                                                  \n");
			sqlsb.append("                                              )                                                                                                                      \n");
			sqlsb.append("               else 0                                                                                                                                                \n");
			sqlsb.append("          end                                                                                             as bid_vendor_cnt -- 입찰업체수                            \n");
			sqlsb.append("        , EE.A ee_vendor_cnt                                                                                       --입찰보증금등록한업체수                          \n");
			sqlsb.append("        , (select count(*) A                                                                                                                                         \n");
			sqlsb.append("             from ICOYBDVO BDVO                                                                                                                                      \n");
			sqlsb.append("                , ICOMQTEE TEE                                                                                                                                       \n");
			sqlsb.append("            where HD.HOUSE_CODE    = BDVO.HOUSE_CODE                                                                                                                 \n");
			sqlsb.append("              and PG.BID_NO        = BDVO.BID_NO                                                                                                                     \n");
			sqlsb.append("              and PG.BID_COUNT     = BDVO.BID_COUNT                                                                                                                  \n");
			sqlsb.append("              and PG.VOTE_COUNT    = BDVO.VOTE_COUNT                                                                                                                 \n");
			sqlsb.append("              and BDVO.VENDOR_CODE = TEE.VENDOR_CODE                                                                                                                 \n");
			sqlsb.append("              and TEE.HOUSE_CODE   = HD.HOUSE_CODE                                                                                                                   \n");
			sqlsb.append("              and TEE.BID_NO       = HD.BID_NO                                                                                                                       \n");
			sqlsb.append("              and TEE.BID_COUNT    = HD.BID_COUNT                                                                                                                    \n");
			sqlsb.append("          )                                                                                               as join_vendor_cnt --참가업체수                            \n");
			sqlsb.append("        , (select NAME_LOC                                                                                                                                           \n");
			sqlsb.append("             from ICOMVNGL                                                                                                                                           \n");
			sqlsb.append("  		  where HOUSE_CODE = PG.HOUSE_CODE                                                                                                                 \n");
			sqlsb.append("  		    and VENDOR_CODE = (select VENDOR_CODE                                                                                                          \n");
			sqlsb.append("                                   from ICOYBDVO                                                                                                                     \n");
			sqlsb.append("                                  where HOUSE_CODE = PG.HOUSE_CODE                                                                                                   \n");
			sqlsb.append("                                    and BID_NO     = PG.BID_NO                                                                                                       \n");
			sqlsb.append("                                    and BID_COUNT  = PG.BID_COUNT                                                                                                    \n");
			sqlsb.append("                                    and VOTE_COUNT = PG.VOTE_COUNT                                                                                                   \n");
			sqlsb.append("                                    and BID_CANCEL = 'N'                                                                                                             \n");
			sqlsb.append("                                    and BID_STATUS = 'SB'                                                                                                            \n");
			sqlsb.append("                                    and STATUS IN ('C', 'R')                                                                                                         \n");
			sqlsb.append("                                 )                                                                                                                                   \n");
			sqlsb.append("          )                                                                                               AS VENDOR_NAME     --낙찰업체                              \n");
			sqlsb.append("        , es.BASIC_AMT                                                                                    as ASUMTNAMT       --예정가격                              \n");
			sqlsb.append("        , case when HD.BID_STATUS = 'SB' and HD.CONT_TYPE2 = 'RL' THEN (select max(Z.ESTM_PRICE)                                                                     \n");
			sqlsb.append("                                                                          from ICOYBDCP Z                                                                            \n");
			sqlsb.append("                                                                        where 1=1                                                                                    \n");
			sqlsb.append("                                                                          and Z.HOUSE_CODE = PG.HOUSE_CODE                                                           \n");
			sqlsb.append("                                                                          and Z.BID_NO     = PG.BID_NO                                                               \n");
			sqlsb.append("                                                                          and Z.SEQ_NO     = 1                                                                       \n");
			sqlsb.append("                                                                       )                                                                                             \n");
			sqlsb.append("               else ''                                                                                                                                               \n");
			sqlsb.append("          end                                                                                             as ESTM_PRICE     -- 예비내정가격                          \n");
			sqlsb.append("        , case when HD.BID_STATUS = 'SB' THEN ES.FINAL_ESTM_PRICE_ENC                                                                                                \n");
			sqlsb.append("               else ''                                                                                                                                               \n");
			sqlsb.append("          end                                                                                             as FINAL_ESTM_PRICE_ENC --내정가격                         \n");
			sqlsb.append("        , NVL( (SELECT BID_AMT                                                                                                                                       \n");
			sqlsb.append("                  FROM ICOYBDVO                                                                                                                                      \n");
			sqlsb.append("                 WHERE HOUSE_CODE = HD.HOUSE_CODE                                                                                                                    \n");
			sqlsb.append("                   AND BID_NO     = HD.BID_NO                                                                                                                        \n");
			sqlsb.append("                   AND BID_COUNT  = HD.BID_COUNT                                                                                                                     \n");
			sqlsb.append("                   AND STATUS IN ('C', 'R')                                                                                                                          \n");
			sqlsb.append("                   AND BID_CANCEL = 'N'                                                                                                                              \n");
			sqlsb.append("                   AND BID_STATUS = 'SB'                                                                                                                             \n");
			sqlsb.append("                ), 0)                                                                                     as SUM_AMT         --낙찰금액                              \n");
			sqlsb.append("        , (SELECT CUR                                                                                                                                                \n");
			sqlsb.append("             FROM ICOYBDDT                                                                                                                                           \n");
			sqlsb.append("            WHERE HOUSE_CODE = '100'                                                                                                                                 \n");
			sqlsb.append("              AND BID_NO     = HD.BID_NO                                                                                                                             \n");
			sqlsb.append("              AND BID_COUNT  = HD.BID_COUNT                                                                                                                          \n");
			sqlsb.append("              AND ROWNUM     < 2)                                                                         as CUR             --화폐                                  \n");
			sqlsb.append("        , (SELECT VENDOR_CODE                                                                                                                                        \n");
			sqlsb.append("             FROM ICOYBDVO                                                                                                                                           \n");
			sqlsb.append("            WHERE HOUSE_CODE = PG.HOUSE_CODE                                                                                                                         \n");
			sqlsb.append("              AND BID_NO     = PG.BID_NO                                                                                                                             \n");
			sqlsb.append("              AND BID_COUNT  = PG.BID_COUNT                                                                                                                          \n");
			sqlsb.append("              AND VOTE_COUNT = PG.VOTE_COUNT                                                                                                                         \n");
			sqlsb.append("              AND BID_CANCEL = 'N'                                                                                                                                   \n");
			sqlsb.append("              AND BID_STATUS = 'SB'                                                                                                                                  \n");
			sqlsb.append("              AND STATUS IN ('C', 'R')                                                                                                                               \n");
			sqlsb.append("           ) AS VENDOR_CODE                                                                                                                                          \n");
			sqlsb.append("           , HD.SIGN_STATUS                                                                                                                                          \n");
			sqlsb.append("           ,HD.BID_TYPE                                                                                                                                              \n");
			sqlsb.append("           ,'"+pr_no+"' AS PR_NO          --구매 요청번                                                                                                                                  \n");
			sqlsb.append("			 , HD.DELY_PLACE AS DELV_PLACE																								\n");
			sqlsb.append("			,(SELECT DLVRYDSREDATE FROM ICOYPRHD A, (SELECT DISTINCT PR_NO FROM ICOYBDDT WHERE BID_NO = '"+ bd_kind +"') B  WHERE A.PR_NO = B.PR_NO) AS DLVRYDSREDATE				\n");
			
			sqlsb.append("     FROM  ICOYBDHD HD                                                                                                                                               \n");
			sqlsb.append("         , ICOYBDPG PG                                                                                                                                               \n");
			sqlsb.append("         , ICOYBDES ES                                                                                                                                               \n");
			sqlsb.append("         , (SELECT COUNT(*) A                                                                                                                                        \n");
			sqlsb.append("                 , BID_NO                                                                                                                                            \n");
			sqlsb.append("              FROM ICOMQTEE                                                                                                                                          \n");
			sqlsb.append("             GROUP BY BID_NO)  EE                                                                                                                                    \n");
			sqlsb.append("    WHERE PG.HOUSE_CODE  = HD.HOUSE_CODE AND   HD.HOUSE_CODE  = '100'                                                                                                \n");
			sqlsb.append("    AND   PG.BID_NO      = HD.BID_NO                                                                                                                                 \n");
			sqlsb.append(sm.addSelectString("    and HD.BID_NO = ?                                                                                                                                   \n"));
			sm.addStringParameter(bd_kind);
			sqlsb.append("              AND   HD.BID_STATUS  IN ('SB', 'NB', 'AC', 'UC' )                                                                                                      \n");
			sqlsb.append("              AND   PG.BID_NO    = ES.BID_NO                                                                                                                         \n");
			sqlsb.append("              AND   PG.BID_count = ES.BID_count                                                                                                                      \n");
			sqlsb.append("              AND   PG.BID_NO    = EE.BID_NO AND   HD.SIGN_STATUS  IN ('C')                                                                                          \n");
			sqlsb.append("              AND   HD.STATUS IN ('C' ,'R')                                                                                                                          \n");
			sqlsb.append("              AND   PG.STATUS IN ('C' ,'R') AND   HD.CHANGE_USER_NAME_LOC   !=  'C' ORDER BY HD.ANN_NO DESC                                                          \n");

			
			rtn[0] = sm.doSelect(sqlsb.toString());
			
			
			
			
//			sqlsb.append("	SELECT														\n");
//			sqlsb.append("	        DESCRIPTION_LOC								AS DESCRIPTION_LOC		--ǰ��            	\n");
//			sqlsb.append("	       ,SPECIFICATION								AS SPECIFICATION		--Spec            	\n");
//			sqlsb.append("	       ,UNIT_MEASURE					                                --��'�ڵ�..            \n");
//			sqlsb.append("	       ,GETCODETEXT1('M007', UNIT_MEASURE, 'KO')	AS UNIT_MEASURE_TEXT		--��'       	\n");
//			sqlsb.append("	       ,PR_QTY										AS SETTLE_QTY			--����        	\n");
//			sqlsb.append("	       ,UNIT_PRICE									AS UNIT_PRICE			--���ܰ�        	\n");
//			sqlsb.append("	       ,PR_AMT										AS ITEM_AMT			--���ݾ�              \n");
//			sqlsb.append("	       ,POR_DATE 									AS RD_DATE              	-- �������   	\n");
//			sqlsb.append("	       ,DILIVER_PLACE								AS DELV_PLACE			--��ǰ���       	\n");
//			sqlsb.append("	       ,PR_NUMBER									AS PR_NO			--���ſ�û��ȣ          \n");
//			sqlsb.append("	       ,PR_SEQ										AS PR_SEQ			--���ſ�û�׹�          \n");
//			sqlsb.append("	       ,PR_USER_ID									AS PR_USER_ID			--���� ��û��     	\n");
//			sqlsb.append("	       ,GETUSERNAME(PR_USER_ID, 'KO')             	AS PR_USER_NAME   		--���� ��û�ڸ�  	\n");
//			sqlsb.append("	       ,DEMAND_DEPT                                                                          	\n");
//			sqlsb.append("	       ,GETDEPTNAME('1000', DEMAND_DEPT, 'KO') 		AS DEMAND_DEPT_LOC 		-- ��û�μ�      	\n");
//			sqlsb.append("	       ,(NVL(PR_AMT, 0)- (NVL(PR_AMT, 0) * 0.1))	AS SUPPLY_AMT			-- ��ް���       	\n");
//			sqlsb.append("	       ,(NVL(PR_AMT, 0) * 0.1)						AS SUPERTAX_AMT			--�ΰ���        	\n");
//			sqlsb.append("	       ,ACCOUNTS_COURSES_CODE						AS ACCOUNTS_COURSES_CODE	--��d����ڵ�	\n");
//			sqlsb.append("	       ,ACCOUNTS_COURSES_LOC						AS ACCOUNTS_COURSES_LOC		--��d���� 	\n");
//			sqlsb.append("	       ,ASSET_NUMBER								AS ASSET_NUMBER			--�ڻ��ȣ    		\n");
//			sqlsb.append("	       ,MATERIAL_NUMBER								AS MATERIAL_NUMBER		--ǰ���ڵ�       	\n");
//			sqlsb.append("	       ,MAKER										AS MAKER			--fv��                \n");
//			sqlsb.append("         ,YEAR_OF_MANUFACTURE							AS YEAR_OF_MANUFACTURE		--fv�⵵		\n");
//			sqlsb.append("	                                                                                       			\n");
//			sqlsb.append("	  FROM SEBLN                                                                           			\n");
//			sqlsb.append("	 WHERE NVL(DEL_FLAG, 'N') = 'N'                                                         		\n");
			
			
			
		} 
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
//			e.printStackTrace();
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return rtn;
		
	}
	
//	public SepoaOut getContractWaitListInsert2(String rfq_number, String rfq_count, String seller_code) X{
//		
//		ConnectionContext ctx = getConnectionContext();
//		StringBuffer sqlsb = new StringBuffer();
//		
//		try {
//			setStatus(1);
//			setFlag(true);
//			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
//			
//			sm.removeAllValue();
//			sqlsb.delete(0, sqlsb.length());
//			sqlsb.append("      SELECT DISTINCT                                                                     \n");
//			sqlsb.append("      	 S.SELLER_CODE                                                 AS SELLER_CODE   \n");
//			sqlsb.append("      	,GETCOMPANYNAMELOC(S.SELLER_CODE, 'S')                         AS SELLER_NAME   \n");
//			sqlsb.append("      	,D.MATERIAL_NUMBER                                             AS MATERIAL_NO   \n");
//			sqlsb.append("      	,D.DESCRIPTION_LOC                                             AS DESCRIPTION_LOC   \n");
//			sqlsb.append("      	,D.SPECIFICATION                                               AS SPECIFICATION \n");
//			sqlsb.append("      	,D.UNIT_MEASURE                                                AS UNIT_MEASURE  \n");
//			sqlsb.append("      	,D.RFQ_QTY                                                     AS SETTLE_QTY    \n");
//			sqlsb.append("      	,D.UNIT_PRICE                                                  AS UNIT_PRICE    \n");
//			sqlsb.append("      	,(D.RFQ_QTY * D.UNIT_PRICE) + (D.RFQ_QTY * D.UNIT_PRICE) / 10  AS ITEM_AMT      \n");
//			sqlsb.append("      	,(D.RFQ_QTY * D.UNIT_PRICE)                                    AS SUPPLY_AMT    \n");
//			sqlsb.append("      	,(D.RFQ_QTY * D.UNIT_PRICE) / 10                               AS SUPERTAX_AMT  \n");
//			sqlsb.append("      	,D.DELY_TO_LOCATION                                            AS DELV_PLACE    \n");
//			sqlsb.append("      	,D.PR_NUMBER                                                   AS PR_NO         \n");
//			sqlsb.append("      	,D.PR_SEQ                                                      AS PR_SEQ        \n");
//			sqlsb.append("      	,GETUSERNAME (H.CHANGE_USER_ID, 'LOC')                         AS ADD_USER_ID   \n");
//			sqlsb.append("      FROM SRQGL H, SRQLN D, SRQSE S                                                      \n");
//			sqlsb.append("      WHERE NVL(D.DEL_FLAG, 'N') = 'N'                                                    \n");
//			sqlsb.append("        AND NVL(H.DEL_FLAG, 'N') = 'N'                                                    \n");
//			sqlsb.append("        AND NVL(S.DEL_FLAG, 'N') = 'N'                                                    \n");
//			sqlsb.append("        AND H.RFQ_NUMBER = D.RFQ_NUMBER                                                   \n");
//			sqlsb.append("        AND H.RFQ_NUMBER = S.RFQ_NUMBER                                                   \n");
//			sqlsb.append("        AND D.RFQ_NUMBER = S.RFQ_NUMBER                                                   \n");
//			sqlsb.append("        AND H.RFQ_COUNT  = D.RFQ_COUNT                                                    \n");
//			sqlsb.append("        AND H.RFQ_COUNT  = S.RFQ_COUNT                                                    \n");
//			sqlsb.append("        AND D.RFQ_COUNT  = S.RFQ_COUNT                                                    \n");
//			sqlsb.append(sm.addSelectString("        AND D.RFQ_NUMBER = ?                                           \n"));
//			sm.addStringParameter(rfq_number);
//			sqlsb.append(sm.addSelectString("        AND D.RFQ_COUNT  = ?                                           \n"));
//			sm.addStringParameter(rfq_count);
//			sqlsb.append(sm.addSelectString("        AND S.SELLER_CODE  = ?                                         \n"));
//			sm.addStringParameter(seller_code);
//			sqlsb.append("      ORDER BY SELLER_CODE, SELLER_NAME, PR_NUMBER, PR_SEQ                                \n");
//			setValue(sm.doSelect(sqlsb.toString()));
//		} catch (Exception e) {
//			setStatus(0);
//			setFlag(false);
//			setMessage(e.getMessage());
//			Logger.err.println(info.getSession("ID"), this, e.getMessage());
//		}
//		
//		return getSepoaOut();
//		
//	}
	
	public SepoaOut getContractInsert(
										String subject, 			String sg_type1,            String sg_type2,				String sg_type3,
										String seller_code,			String seller_name, 		String pr_no,
										String sign_person_id, 		String sign_person_name, 	String cont_from,				String cont_to, String cont_date,
										String cont_add_date, 		String cont_type, 			String ele_cont_flag, 			String assure_flag,
										String cont_process_flag, 	String cont_amt, 			String cont_assure_percent, 	String cont_assure_amt, 	String fault_ins_percent,
										String fault_ins_amt, 		String fault_ins_term, 		String bd_no, 					String bd_count,
										String amt_gubun, 			String text_number, 		String delay_charge, 			String remark,
										String ctrl_demand_dept,	String rfq_type,  			String[][] bean_args,
										String cont_type1_text,     String cont_type2_text,     String x_purchase_qty,
										String delv_place,          String add_tax_flag,
										String item_type,			String rd_date,				String cont_total_gubun,
										String cont_price,			String exec_no,            String pay_div_flag) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		String cont_no = "";
		SepoaOut wo = null;
		wo = DocumentUtil.getDocNumber(info, "CT");
		cont_no = wo.result[0];
		
		Logger.sys.println("cont_add_date2 = " + cont_add_date);
//		System.out.println("exec_no : " + exec_no);
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			/*
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			if(rfq_type.equals("RF")) {
				sqlsb.append("	UPDATE SQTGL SET		\n");
				sqlsb.append("		CT_FLAG = 'Y' 		\n");
				sqlsb.append("	WHERE QTA_NUMBER	= ?	\n");sm.addStringParameter(bd_no);
				sqlsb.append("	  AND SELLER_CODE	= ?	\n");sm.addStringParameter(seller_code);
				sm.doInsert(sqlsb.toString());
			} else if(rfq_type.equals("BD")) {
				sqlsb.append("	UPDATE SEBVO SET		\n");
				sqlsb.append("		CT_FLAG = 'Y' 		\n");
				sqlsb.append("	WHERE VOTE_NO = ?			\n");sm.addStringParameter(bd_no);
				sqlsb.append("	  AND SELLER_CODE  = ?		\n");sm.addStringParameter(seller_code);
				sm.doInsert(sqlsb.toString());
			}*/
			
			
			Logger.sys.println("!!!!!!!!!!!!!!!!!!!!!!! cont_no = " + cont_no);
			
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("	INSERT INTO SCPGL (				\n");
			sqlsb.append("		 CONT_NO					\n");
			sqlsb.append("		,CONT_GL_SEQ				\n");
			sqlsb.append("		,SUBJECT             		\n");
			//sqlsb.append("		,CONT_GUBUN      			\n");
			sqlsb.append("		,SG_LEV1      				\n");
			sqlsb.append("		,SG_LEV2      				\n");
			sqlsb.append("		,SG_LEV3	      			\n");
			//sqlsb.append("		,PROPERTY_YN    			\n");
			sqlsb.append("		,SELLER_CODE      			\n");
			
			//sqlsb.append("		,SELLER_NAME    			\n");
			sqlsb.append("		,SIGN_PERSON_ID           	\n");
			sqlsb.append("		,SIGN_PERSON_NAME           \n");
			sqlsb.append("		,CONT_FROM           		\n");
			sqlsb.append("		,CONT_TO           			\n");
			
			sqlsb.append("		,CONT_DATE            		\n");
			sqlsb.append("		,CONT_ADD_DATE       		\n");
			sqlsb.append("		,CONT_TYPE         			\n");
			sqlsb.append("		,ELE_CONT_FLAG    		 	\n");
			sqlsb.append("		,ASSURE_FLAG       			\n");
			
			//sqlsb.append("		,START_START_INS_FLAG       \n");
			sqlsb.append("		,CONT_PROCESS_FLAG       	\n");
			sqlsb.append("		,CONT_AMT      				\n");
			sqlsb.append("		,CONT_ASSURE_PERCENT		\n");
			sqlsb.append("		,CONT_ASSURE_AMT			\n");
			
			sqlsb.append("		,FAULT_INS_PERCENT			\n");
			sqlsb.append("		,FAULT_INS_AMT				\n");
			//sqlsb.append("		,PAY_DIV_FLAG				\n");
			sqlsb.append("		,FAULT_INS_TERM         	\n");
			sqlsb.append("		,BD_NO         				\n");
			
			sqlsb.append("		,BD_COUNT         			\n");
			sqlsb.append("		,AMT_GUBUN         			\n");
			sqlsb.append("		,TEXT_NUMBER         		\n");
			sqlsb.append("		,DELAY_CHARGE         		\n");
			//sqlsb.append("		,DELV_PLACE         		\n");
			
			sqlsb.append("		,REMARK         			\n");
			sqlsb.append("		,CTRL_DEMAND_DEPT         	\n");
			sqlsb.append("		,CT_FLAG             		\n");//STATUS
			sqlsb.append("		,CTRL_CODE           		\n");//SESSION[CTRL_CODE]
			sqlsb.append("		,COMPANY_CODE				\n");//SESSION[COMPANY_CODE]
			sqlsb.append("		,RFQ_TYPE					\n");//SESSION[COMPANY_CODE]
			
			sqlsb.append("		,ADD_USER_ID				\n");
			sqlsb.append("		,ADD_DATE            		\n");
			sqlsb.append("		,ADD_TIME            		\n");
			sqlsb.append("		,CHANGE_USER_ID      		\n");
			sqlsb.append("		,CHANGE_DATE         		\n");
			sqlsb.append("		,CHANGE_TIME         		\n");
			sqlsb.append("		,DEL_FLAG            		\n");
			//sqlsb.append("		,ACCOUNT_CODE          		\n");
			//sqlsb.append("		,ACCOUNT_NAME          		\n");
			sqlsb.append("		,CONT_TYPE1_TEXT          	\n"); 
			sqlsb.append("		,CONT_TYPE2_TEXT          	\n");
			sqlsb.append("		,TTL_ITEM_QTY            	\n"); // 구매수량
			sqlsb.append("		,DELV_PLACE              	\n"); // 납품장소
			sqlsb.append("		,ADD_TAX_FLAG              	\n"); // 부가가치세포함여부
			sqlsb.append("		,ITEM_TYPE              	\n"); // 물품종류
			sqlsb.append("		,RD_DATE	              	\n"); // 납품기한
			sqlsb.append("		,CONT_TOTAL_GUBUN	        \n"); // 계약단가구분
			sqlsb.append("		,CONT_PRICE	              	\n"); // 계약단가
			sqlsb.append("		,EXEC_NO	              	\n"); // 기안번호
			sqlsb.append("		,PAY_DIV_FLAG	              	\n"); // 대금지급횟수
			sqlsb.append("	) VALUES (               \n");
			sqlsb.append("		 ?                   \n");sm.addStringParameter(cont_no);
			sqlsb.append("		,TO_CHAR(?, 'FM000')  \n");sm.addStringParameter("1");
			sqlsb.append("		,?                   \n");sm.addStringParameter(subject);
			//sqlsb.append("		,?                   \n");sm.addStringParameter(cont_gubun);
			sqlsb.append("		,?                   \n");sm.addStringParameter(sg_type1);
			sqlsb.append("		,?                   \n");sm.addStringParameter(sg_type2);
			sqlsb.append("		,?                   \n");sm.addStringParameter(sg_type3);
			//sqlsb.append("		,?                   \n");sm.addStringParameter(property_yn);
			sqlsb.append("		,?                   \n");sm.addStringParameter(seller_code);
			
			//sqlsb.append("		,?                   \n");sm.addStringParameter(seller_name);
			sqlsb.append("		,?                   \n");sm.addStringParameter(sign_person_id);
			sqlsb.append("		,?                   \n");sm.addStringParameter(sign_person_name);
			sqlsb.append("		,?                   \n");sm.addStringParameter(cont_from);
			sqlsb.append("		,?                   \n");sm.addStringParameter(cont_to);
			
			sqlsb.append("		,?                   \n");sm.addStringParameter(cont_date);
			sqlsb.append("		,?                   \n");sm.addStringParameter(cont_add_date);
			sqlsb.append("		,?                   \n");sm.addStringParameter(cont_type);
			sqlsb.append("		,?                   \n");sm.addStringParameter(ele_cont_flag);
			sqlsb.append("		,?                   \n");sm.addStringParameter(assure_flag);
			
			//sqlsb.append("		,?                   \n");sm.addStringParameter(start_start_ins_flag);
			sqlsb.append("		,?                   \n");sm.addStringParameter(cont_process_flag);
			sqlsb.append("		,?                   \n");sm.addStringParameter(cont_amt);
			sqlsb.append("		,?                   \n");sm.addStringParameter(cont_assure_percent);
			sqlsb.append("		,?                   \n");sm.addStringParameter(cont_assure_amt);
			
			sqlsb.append("		,?                   \n");sm.addStringParameter(fault_ins_percent);
			sqlsb.append("		,?                   \n");sm.addStringParameter(fault_ins_amt);
			//sqlsb.append("		,?                   \n");sm.addStringParameter(pay_div_flag);
			sqlsb.append("		,?                   \n");sm.addStringParameter(fault_ins_term);
			sqlsb.append("		,?                   \n");sm.addStringParameter(bd_no);
			
			sqlsb.append("		,?                   \n");sm.addStringParameter(bd_count);
			sqlsb.append("		,?                   \n");sm.addStringParameter(amt_gubun);
			sqlsb.append("		,?                   \n");sm.addStringParameter(text_number);
			sqlsb.append("		,?                   \n");sm.addStringParameter(delay_charge);
			//sqlsb.append("		,?                   \n");sm.addStringParameter(delv_place);
			
			sqlsb.append("		,?                   \n");sm.addStringParameter(remark);
			sqlsb.append("		,?                   \n");sm.addStringParameter(ctrl_demand_dept);
			sqlsb.append("		,?                   \n");sm.addStringParameter("CT");
			sqlsb.append("		,?                   \n");sm.addStringParameter(info.getSession("CTRL_CODE"));
			sqlsb.append("		,?                   \n");sm.addStringParameter(info.getSession("COMPANY_CODE"));
			sqlsb.append("		,?                   \n");sm.addStringParameter(rfq_type);
			
			sqlsb.append("		,?                   \n");sm.addStringParameter(info.getSession("ID"));
			sqlsb.append("		,?                   \n");sm.addStringParameter(SepoaDate.getShortDateString());
			sqlsb.append("		,?                   \n");sm.addStringParameter(SepoaDate.getShortTimeString());
			sqlsb.append("		,?                   \n");sm.addStringParameter(info.getSession("ID"));
			sqlsb.append("		,?                   \n");sm.addStringParameter(SepoaDate.getShortDateString());
			sqlsb.append("		,?                   \n");sm.addStringParameter(SepoaDate.getShortTimeString());
			sqlsb.append("		,?                   \n");sm.addStringParameter("N");
			//sqlsb.append("		,?                   \n");sm.addStringParameter(account_code);
			//sqlsb.append("		,?                   \n");sm.addStringParameter(account_name);
			sqlsb.append("		,?                   \n");sm.addStringParameter(cont_type1_text);
			sqlsb.append("		,?                   \n");sm.addStringParameter(cont_type2_text);
			sqlsb.append("		,?                   \n");sm.addStringParameter(x_purchase_qty);
			sqlsb.append("		,?                   \n");sm.addStringParameter(delv_place);
			sqlsb.append("		,?                   \n");sm.addStringParameter(add_tax_flag); // 부가가치세포함여부
			sqlsb.append("		,?                   \n");sm.addStringParameter(item_type); // 물품종류
			sqlsb.append("		,?                   \n");sm.addStringParameter(rd_date); // 납품기한
			sqlsb.append("		,?                   \n");sm.addStringParameter(cont_total_gubun); // 계약단가구분
			sqlsb.append("		,?                   \n");sm.addStringParameter(cont_price); // 계약단가
			sqlsb.append("		,?                   \n");sm.addStringParameter(exec_no); // 기안번호
			sqlsb.append("		,?                   \n");sm.addStringParameter(pay_div_flag); // 대금지급횟수
			sqlsb.append("	)                        \n");
			sm.doInsert(sqlsb.toString());
			
			/*sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			
			//��d�ڵ尡 �ڵ� M293 �� x���ϸ� �ڻ�8�� �з�
			sqlsb.append("	UPDATE SCPGL SET		\n");
			sqlsb.append("		PROPERTY_YN = 'Y' 		\n");
			sqlsb.append("	WHERE CONT_NO	= ?	\n");sm.addStringParameter(cont_no);
			sqlsb.append("	  AND (SELECT COUNT(*) FROM SCODE WHERE TYPE='M293' AND CODE = '"+account_code+"' AND USE_FLAG='Y' ) = 1 \n");
			sm.doUpdate(sqlsb.toString());
			*/
				
			
			/**
			 * 결재 상세 저장처리 제외 끝 (Kavez)
			 */
			/*
			if(bean_args.length > 0) {
				int cnt = 0;
				for (int i = 0; i < bean_args.length; i++)
				{
					
					String ANN_ITEM             = bean_args[i][0];  //입찰건명
					String DELV_PLACE           = bean_args[i][1]; // 납품장소
					String BID_VENDOR_CNT       = bean_args[i][2];  //
					String EE_VENDOR_CNT        = bean_args[i][3]; 
					String JOIN_VENDOR_CNT      = bean_args[i][4]; 
					String VENDOR_NAME          = bean_args[i][5]; //낙찰업체명
					String ASUMTNAMT            = bean_args[i][6]; //예정가격
					String ESTM_PRICE           = bean_args[i][7]; 
					String FINAL_ESTM_PRICE_ENC	= bean_args[i][8]; 
					String SUM_AMT              = bean_args[i][9]; //낙찰금액
					String CUR                  = bean_args[i][10]; //금액화폐단위
					String VENDOR_CODE          = bean_args[i][11]; // 납품 업체 코드
					String DLVRYDSREDATE        = bean_args[i][12];  //납품 요청일
					
					
//					if(SELLER_CODE.equals("")) {
//						SELLER_CODE = seller_code;
//					}
					cnt++;

					sm.removeAllValue();
					sqlsb.delete(0, sqlsb.length());
					sqlsb.append("     INSERT INTO SCPLN (          \n");
					sqlsb.append("             CONT_NO              \n");
					sqlsb.append("            ,CONT_GL_SEQ          \n");
					sqlsb.append("            ,CONT_SEQ             \n");
					sqlsb.append("            ,SELLER_CODE          \n");
					sqlsb.append("            ,DESCRIPTION_LOC      \n"); // 입찰건명
					
					sqlsb.append("            ,ITEM_AMT             \n");
				//	sqlsb.append("            ,SUPPLY_AMT           \n");
					
				//	sqlsb.append("            ,SUPERTAX_AMT         \n");
					sqlsb.append("            ,DELV_PLACE           \n");
					sqlsb.append("            ,ADD_USER_ID          \n");
					sqlsb.append("            ,ADD_DATE             \n");
					sqlsb.append("            ,ADD_TIME             \n");
					
					sqlsb.append("            ,CHANGE_USER_ID       \n");
					sqlsb.append("            ,CHANGE_DATE          \n");
					sqlsb.append("            ,CHANGE_TIME          \n");
					sqlsb.append("            ,DEL_FLAG             \n");
					
					sqlsb.append("            ,PR_NO                \n");//���ſ�û��ȣ
					
					sqlsb.append("            ,RD_DATE     			\n");
					sqlsb.append("            ,COMPANY_CODE   		\n");
					sqlsb.append("            ,CUR   				\n");
					sqlsb.append("            ,ESTIMATE_PRICE   	\n");
					sqlsb.append("            ,MAKER   				\n");
					sqlsb.append("     ) VALUES (                   \n");
					sqlsb.append("             ?                    \n");sm.addStringParameter(cont_no);
					sqlsb.append("		      ,TO_CHAR(?, 'FM000')  \n");sm.addStringParameter("1");
					sqlsb.append("            ,Lpad(?,3,'0')        \n");sm.addStringParameter(String.valueOf(cnt));
					sqlsb.append("            ,?                    \n");sm.addStringParameter(seller_code);
					sqlsb.append("            ,?                    \n");sm.addStringParameter(ANN_ITEM);  // 입찰건명
					
					sqlsb.append("            ,?                    \n");sm.addStringParameter(SUM_AMT);
				//	sqlsb.append("            ,?                    \n");sm.addStringParameter(SUPPLY_AMT);
					
				//	sqlsb.append("            ,?                    \n");sm.addStringParameter(SUPERTAX_AMT);
					sqlsb.append("            ,?                    \n");sm.addStringParameter(DELV_PLACE);
					sqlsb.append("            ,?                    \n");sm.addStringParameter(info.getSession("ID"));
					sqlsb.append("            ,?                    \n");sm.addStringParameter(SepoaDate.getShortDateString());
					sqlsb.append("            ,?                    \n");sm.addStringParameter(SepoaDate.getShortTimeString());
					
					sqlsb.append("            ,?                    \n");sm.addStringParameter(info.getSession("ID"));
					sqlsb.append("            ,?                    \n");sm.addStringParameter(SepoaDate.getShortDateString());
					sqlsb.append("            ,?                    \n");sm.addStringParameter(SepoaDate.getShortTimeString());
					sqlsb.append("            ,?                    \n");sm.addStringParameter("N");
					
					sqlsb.append("            ,?                    \n");sm.addStringParameter(pr_no);
					
					
					sqlsb.append("            ,?                    \n");sm.addStringParameter(DLVRYDSREDATE);
					sqlsb.append("            ,?                    \n");sm.addStringParameter(VENDOR_CODE);
					sqlsb.append("            ,?                    \n");sm.addStringParameter(CUR);
					sqlsb.append("            ,?                    \n");sm.addStringParameter(ASUMTNAMT); //예정가격
					sqlsb.append("            ,?                    \n");sm.addStringParameter(VENDOR_NAME); //낙찰업체
					sqlsb.append("     )                            \n");
					sm.doInsert(sqlsb.toString());
					
	/*				
//					PR이후의 결재 진행상태{scode_type=M157}
					sm.removeAllValue();
					sqlsb.delete(0, sqlsb.length());
					sqlsb.append("		UPDATE SPRLN SET			\n");
					sqlsb.append("			 PR_PROCEEDING_FLAG = ?	\n");sm.addStringParameter("CT");//�ۼ���
					sqlsb.append("			,DEL_FLAG			= ?	\n");sm.addStringParameter("N");
					sqlsb.append("			,CHANGE_USER_ID		= ?	\n");sm.addStringParameter(info.getSession("ID"));
					sqlsb.append("			,CHANGE_DATE		= ?	\n");sm.addStringParameter(SepoaDate.getShortDateString());
					sqlsb.append("			,CHANGE_TIME		= ?	\n");sm.addStringParameter(SepoaDate.getShortTimeString());
					sqlsb.append("		WHERE PR_NUMBER	= ?			\n");sm.addStringParameter(PR_NO);
					sqlsb.append("		  AND PR_SEQ	= ?			\n");sm.addStringParameter(PR_SEQ);
					sm.doInsert(sqlsb.toString());
					*/
			/*
				}
			}
			*/
			/**
			 * 결재 상세 저장처리 제외 끝 (Kavez)
			 */			
			
			
/*//			검수확인자 업데이트 하는 부분
			if(!confirm_user_id.equals("")){
				String PR_NUMBER                    = bean_args[0][10];
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("		UPDATE SPRGL SET			\n");
				sqlsb.append("			 CONFIRM_USER_ID 	= ?	\n");sm.addStringParameter(confirm_user_id);
				sqlsb.append("			,CONFIRM_USER_NAME	= ?	\n");sm.addStringParameter(confirm_user_name);
				sqlsb.append("		WHERE PR_NUMBER	= ?			\n");sm.addStringParameter(PR_NUMBER);
				sm.doUpdate(sqlsb.toString());
			}*/
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("		UPDATE ICOYBDHD SET			\n");
			sqlsb.append("			 CTRL_FLAG 	= ?			\n");sm.addStringParameter("Y");
			sqlsb.append("		WHERE BID_NO	= ?			\n");sm.addStringParameter(text_number);
			sm.doUpdate(sqlsb.toString());	
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("		UPDATE ICOYBDHD SET			\n");
			sqlsb.append("			 CTRL_FLAG 	= ?			\n");sm.addStringParameter("Y");
			sqlsb.append("		WHERE BID_NO	= ?			\n");sm.addStringParameter(exec_no);
			sm.doUpdate(sqlsb.toString());	
			
			
			
			setValue(cont_no);
			
			Commit();
			
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
		
	}
	
	public SepoaOut setPoCreate( String PO_NO, String cont_no, String SELLER_CODE, String[] setHdData, String[][] setDtData) {
		
		String[] rtn1 = null;
		String[] rtn2 = null;
		String[] rtn3 = null;
		
		SepoaOut wo = null;
		
		try {
			setFlag(true);
			setStatus(1);
			
//			if (PO_NO.equals("") || PO_NO == null) {
//				wo = DocumentUtil.getDocNumber(info, "POD");
//				PO_NO = wo.result[0];
//			}
			
			if (PO_NO == null) {
				wo = DocumentUtil.getDocNumber(info, "POD");
				PO_NO = wo.result[0];
			}else{
				if (PO_NO.equals("")) {
					wo = DocumentUtil.getDocNumber(info, "POD");
					PO_NO = wo.result[0];
				}				
			}						
			
			
			////발주확인
			rtn2 = getContCount(cont_no);
			if (rtn2[1] != null)
			{
				Rollback();
				setMessage(rtn2[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn2[1]);
				setStatus(0);
				setFlag(false);
				return getSepoaOut();
			}

			
				
			/*
			 *  발주 헤더 등록(SPOGL)
			 */
			rtn1 = et_setPOHdDetail(PO_NO, cont_no, SELLER_CODE, setHdData);
			
			if (rtn1[1] != null)
			{
				Rollback();
				setMessage(rtn1[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn1[1]);
				setStatus(0);
				setFlag(false);
				return getSepoaOut();
			}
			
			/*
			 *  발주 상세  등록(SPOLN)
			 */
			rtn2 = et_setPODtDetail(PO_NO, SELLER_CODE, setDtData);
			
			if (rtn2[1] != null)
			{
				Rollback();
				setMessage(rtn2[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn2[1]);
				setStatus(0);
				setFlag(false);
				return getSepoaOut();
			}
			
			setValue(PO_NO);
			
			setMessage(msg.getMessage("0001"));
	
			Commit();
		} catch (Exception e) {
			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}
	
//			e.printStackTrace();
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setFlag(false);
			setStatus(0);
			setMessage(e.getMessage());
		}
	
		return getSepoaOut();
		
	}
	
	private String[] et_setPOHdDetail(String PO_NO, String cont_no, String SELLER_CODE, String[] setHdData) throws Exception
	{
		String[] rtn = new String[2];
		String[] rtn1 = new String[2];
		String[] rtn2 = new String[2];
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
		
		String ADD_USER_ID = info.getSession("ID");
		String ADD_DATE = SepoaDate.getShortDateString();
		String ADD_TIME = SepoaDate.getShortTimeString();
		
		String PO_CREATE_DATE    = "";
		String PO_TTL_AMT        = "";
		String PURCHASER_ID      = "";
		String PURCHASER_NAME    = "";
		
		String DEMAND_DEPT         = "";
		String PAY_DIV_FLAG        = "";
		String CONT_PROCESS_FLAG   = "";
		String CONT_GUBUN          = "";
		String QTA_BD_NO           = "";
		String QTA_BD_COUNT        = "";
		String CONT_TYPE           = "";
		
		
		String PR_DEPT          = "";
		String COMPANY_CODE     = info.getSession("COMPANY_CODE");
		String DEL_FLAG         = "N";
		String SIGN_STATUS      = "E";
		
		int result = 0;
		
		
		
		try
		{
				PO_CREATE_DATE      = setHdData[0]; 
				PO_TTL_AMT          = setHdData[1]; 
				PURCHASER_ID        = setHdData[2]; 
				PURCHASER_NAME      = setHdData[3]; 
				DEMAND_DEPT         = setHdData[4]; 
				PAY_DIV_FLAG        = setHdData[5]; 
				CONT_PROCESS_FLAG   = setHdData[6]; 
				CONT_GUBUN          = setHdData[7]; 
				QTA_BD_NO           = setHdData[8]; 
				QTA_BD_COUNT        = setHdData[9]; 
				CONT_TYPE           = setHdData[10];
				
				if(PO_CREATE_DATE.equals("")){
				  PO_CREATE_DATE = ADD_DATE;
				}
	
				
				if(PR_DEPT.equals("")) {
					PR_DEPT = info.getSession("DEPARTMENT");
				}
				
				rtn1 =   getPOCount(PO_NO, "", "SPOGL");
				
				if (rtn1[1] != null)
				{
					Rollback();
					setMessage(rtn1[1]);
					Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn1[1]);
					setStatus(0);
					setFlag(false);
					return rtn1;
				}
				
				if (Integer.parseInt(rtn1[0]) == 0) {
						ps.removeAllValue();
						sqlsb.delete(0, sqlsb.length());
						sqlsb.append(" INSERT INTO SPOGL 					\n");
						sqlsb.append(" 	      (                             \n");
						sqlsb.append(" 	   		  PO_NUMBER                 \n");
						sqlsb.append(" 	   		 ,ADD_DATE                  \n");
						sqlsb.append(" 	   		 ,ADD_TIME                  \n");
						sqlsb.append(" 	   		 ,ADD_USER_ID               \n");
						sqlsb.append(" 	   		 ,CHANGE_DATE               \n");
						sqlsb.append(" 	   		 ,CHANGE_TIME               \n");
						sqlsb.append(" 	   		 ,CHANGE_USER_ID            \n");
						sqlsb.append(" 	   		 ,COMPANY_CODE              \n");
						sqlsb.append(" 	   		 ,PO_CREATE_DATE            \n");
						sqlsb.append(" 	   		 ,SELLER_CODE              	\n");
						sqlsb.append(" 	   		 ,PO_TTL_AMT                \n");
						sqlsb.append(" 	   		 ,PURCHASER_ID              \n");
						sqlsb.append(" 	   		 ,PURCHASER_NAME            \n");
						sqlsb.append(" 	   		 ,DEL_FLAG                  \n");
						sqlsb.append(" 	   		 ,PR_DEPT                   \n");
						sqlsb.append("           ,SIGN_STATUS      	   		\n");
						sqlsb.append("           ,CONT_METHOD      	   		\n");
						sqlsb.append("         )                            \n");
						sqlsb.append(" VALUES								\n");
						sqlsb.append(" 	      (                             \n");
						sqlsb.append(" 	   		  		? 	                \n");
						ps.addStringParameter(PO_NO);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(ADD_DATE);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(ADD_TIME);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(ADD_DATE);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(ADD_DATE);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(ADD_TIME);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(ADD_USER_ID);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(COMPANY_CODE);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(ADD_DATE);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(SELLER_CODE);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(PO_TTL_AMT);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(PURCHASER_ID);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(PURCHASER_NAME);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(DEL_FLAG);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(PR_DEPT);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(SIGN_STATUS);
						sqlsb.append(" 	   		 ,		?	                \n");
						ps.addStringParameter(PAY_DIV_FLAG);
						
						sqlsb.append("         )                            \n");
						
						result = ps.doInsert(sqlsb.toString());
					
				}else{
					
					ps.removeAllValue();
					sqlsb.delete(0, sqlsb.length());
					sqlsb.append(" UPDATE SPOGL                    								\n");
					sqlsb.append("    SET                                                   	\n");
					sqlsb.append("         CHANGE_DATE           =  		?              		\n");
					ps.addStringParameter(ADD_DATE);
					sqlsb.append("        ,CHANGE_TIME           =  		?              		\n");
					ps.addStringParameter(ADD_TIME);
					sqlsb.append("        ,CHANGE_USER_ID        =  		?              		\n");
					ps.addStringParameter(ADD_USER_ID);
					sqlsb.append("        ,PO_CREATE_DATE        =  		?              		\n");
					ps.addStringParameter(PO_CREATE_DATE);
					sqlsb.append("        ,SELLER_CODE           =  		?              		\n");
					ps.addStringParameter(SELLER_CODE);
					sqlsb.append("        ,PO_TTL_AMT            =  		?              		\n");
					ps.addStringParameter(PO_TTL_AMT);
					
					sqlsb.append("        ,PURCHASER_ID          =  		?              		\n");
					ps.addStringParameter(PURCHASER_ID);
					sqlsb.append("        ,PURCHASER_NAME        =  		?              		\n");
					ps.addStringParameter(PURCHASER_NAME);
					sqlsb.append("        ,PR_DEPT               =  		?              		\n");
					ps.addStringParameter(PR_DEPT);
					sqlsb.append("        ,DEL_FLAG              =  		?              		\n");
					ps.addStringParameter(DEL_FLAG);
					sqlsb.append("        ,SIGN_STATUS           =  		?              		\n");
					ps.addStringParameter(SIGN_STATUS);
					
					sqlsb.append(" 	   		 ,CONT_TYPE                   \n");
					ps.addStringParameter(CONT_TYPE);
					sqlsb.append("           ,CONT_METHOD      	   		\n");
					ps.addStringParameter(PAY_DIV_FLAG);
					
					
					sqlsb.append("                                                          	\n");
					sqlsb.append("  WHERE "+DB_NULL_FUNCTION+"(DEL_FLAG, 'N') = 'N'    		    \n");
					sqlsb.append("    AND PO_NUMBER             =  		?              			\n");
					ps.addStringParameter(PO_NO);
					
					result =  ps.doUpdate(sqlsb.toString());
					
				}
		
				rtn[0] = String.valueOf(result);
		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
//			e.printStackTrace();
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}
		
		return rtn;
	} 
	
	
	private String[] et_setPODtDetail(String PO_NO, String SELLER_CODE, String[][] setDtData) throws Exception
	{
		String[] rtn = new String[2];
		String[] rtn1 = new String[2];
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
		SepoaFormater wf = null;
		
		String ADD_USER_ID = info.getSession("ID");
		String ADD_DATE = SepoaDate.getShortDateString();
		String ADD_TIME = SepoaDate.getShortTimeString();
		String result = "";
		
		
		String DESCRIPTION_LOC		    = "";
		String SPECIFICATION            = "";
		String UNIT_MEASURE             = "";
		String PR_NUMBER                = "";
		String PR_SEQ                   = "";
		String Z_DELIVERY_DATE          = "";
		String ITEM_QTY                 = "";
		String UNIT_PRICE               = "";
		String PR_AMT                   = "";
		String DELY_TO_LOCATION         = "";
		String PR_DEPT_TEXT             = "";
		String PR_USER_NAME             = "";
		String PR_USER_ID               = "";
		String PR_DEPT                  = "";
		String MAKER                    = "";
		String YEAR_OF_MANUFACTURE      = "";
		String ACCOUNTS_COURSES_CODE    = "";
		String ACCOUNTS_COURSES_LOC     = "";
		String ASSET_NUMBER             = "";
		String RD_DATE                  = "";
		String PO_SEQ                   = "";
		String PO_CREATE_DATE           = "";
		String CONT_NO                  = "";
		String CONT_SUBJECT             = "";
		String CONT_AMT                 = "";
		String CONT_DATE                = "";
		String CONT_USER_ID             = "";
		
		
		String COMPANY_CODE     = info.getSession("COMPANY_CODE");
		String DEL_FLAG         = "N";
		
		int value = 0;
		
		try
		{
			for (int i = 0; i < setDtData.length; i++) {
				
				DESCRIPTION_LOC		     = setDtData[i][0]; 
				SPECIFICATION            = setDtData[i][1]; 
				UNIT_MEASURE             = setDtData[i][2]; 
				PR_NUMBER                = setDtData[i][3]; 
				PR_SEQ                   = setDtData[i][4]; 
				Z_DELIVERY_DATE          = setDtData[i][5]; 
				ITEM_QTY                 = setDtData[i][6]; 
				UNIT_PRICE               = setDtData[i][7]; 
				PR_AMT                   = setDtData[i][8]; 
				DELY_TO_LOCATION         = setDtData[i][9]; 
				PR_DEPT_TEXT             = setDtData[i][10];
				PR_USER_NAME             = setDtData[i][11];
				PR_USER_ID               = setDtData[i][12];
				PR_DEPT                  = setDtData[i][13];
				MAKER                    = setDtData[i][14];
				YEAR_OF_MANUFACTURE      = setDtData[i][15];
				ACCOUNTS_COURSES_CODE    = setDtData[i][16];
				ACCOUNTS_COURSES_LOC     = setDtData[i][17];
				ASSET_NUMBER             = setDtData[i][18];
				RD_DATE                  = setDtData[i][19];
				PO_SEQ                   = setDtData[i][20];
				PO_CREATE_DATE           = setDtData[i][21];
				CONT_NO                  = setDtData[i][22];
				CONT_SUBJECT             = setDtData[i][23];
				CONT_AMT                 = setDtData[i][24];
				CONT_DATE                = setDtData[i][25];
				CONT_USER_ID             = setDtData[i][26];

				
				if(PO_CREATE_DATE.equals("")){
					  PO_CREATE_DATE = ADD_DATE;
				}
				
				if(PO_SEQ.equals("") || PO_SEQ.length() == 0){
					
					ps.removeAllValue();
					sqlsb.delete(0, sqlsb.length());
					sqlsb.append(" SELECT LTRIM(TO_CHAR(NVL(MAX(PO_SEQ), 0)+1, '0000'))   	\n");
					sqlsb.append("   FROM SPOLN 						 					\n");
					sqlsb.append("  WHERE "+DB_NULL_FUNCTION+"(DEL_FLAG, 'N') = 'N'         \n");
					sqlsb.append("    AND PO_NUMBER = '"+PO_NO+"'	 						\n");
					
					result = ps.doSelect(sqlsb.toString());
					wf = new SepoaFormater(result);
					
					PO_SEQ = wf.getValue(0, 0);
				}
				
				rtn1 =   getPOCount(PO_NO, PO_SEQ, "SPOLN");
				
				if (rtn1[1] != null)
				{
					Rollback();
					setMessage(rtn1[1]);
					Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn1[1]);
					setStatus(0);
					setFlag(false);
					return rtn1;
				}
				
				if (Integer.parseInt(rtn1[0]) == 0) {
					
					ps.removeAllValue();
					sqlsb.delete(0, sqlsb.length());
					sqlsb.append("  INSERT INTO SPOLN   				\n");
					sqlsb.append("  	(                               \n");
					sqlsb.append("     	    PO_NUMBER                   \n");
					sqlsb.append("     	    ,PO_SEQ                     \n");
					sqlsb.append("     	    ,ADD_DATE                   \n");
					sqlsb.append("     	    ,ADD_TIME                   \n");
					sqlsb.append("     	    ,ADD_USER_ID                \n");
					sqlsb.append("     	    ,CHANGE_DATE                \n");
					sqlsb.append("     	    ,CHANGE_TIME                \n");
					sqlsb.append("     	    ,CHANGE_USER_ID             \n");
					sqlsb.append("     	    ,COMPANY_CODE               \n");
					sqlsb.append("     	    ,SELLER_CODE				\n");
					sqlsb.append("     	    ,UNIT_MEASURE               \n");
					sqlsb.append("     	    ,ITEM_QTY                   \n");
					sqlsb.append("     	    ,UNIT_PRICE                 \n");
					sqlsb.append("     	    ,ITEM_AMT                   \n");
					sqlsb.append("     	    ,RD_DATE                    \n");
					sqlsb.append("     	    ,PO_CREATE_DATE             \n");
					sqlsb.append("     	    ,PO_CREATE_TIME             \n");
					sqlsb.append("     	    ,PR_NUMBER                  \n");
					sqlsb.append("     	    ,PR_SEQ                     \n");
					sqlsb.append("     	    ,PR_DEPT                    \n");
					sqlsb.append("     	    ,DESCRIPTION_ENG            \n");
					sqlsb.append("     	    ,DESCRIPTION_LOC            \n");
					sqlsb.append("     	    ,SPECIFICATION   			\n");
					sqlsb.append("     	    ,DELY_TO_LOCATION           \n");
					sqlsb.append("     	    ,Z_DELIVERY_DATE            \n");
					sqlsb.append(" 	   		,DEL_FLAG                   \n");
					sqlsb.append(" 	   		,PR_USER_ID               	\n");
					sqlsb.append(" 	   		,PR_USER_NAME               \n");
					sqlsb.append(" 	   		,CONT_NUMBER                \n");
					sqlsb.append(" 	   		,CONT_SUBJECT               \n");
					sqlsb.append(" 	   		,CONT_AMT               	\n");
					sqlsb.append(" 	   		,CONT_DATE                	\n");
					sqlsb.append(" 	   		,CONT_USER_ID               \n");
					sqlsb.append(" 	   		,ACCOUNTS_COURSES_CODE     	\n");
					sqlsb.append(" 	   		,ACCOUNTS_COURSES_LOC     	\n");
					sqlsb.append(" 	   		,ASSET_NUMBER               \n");
					sqlsb.append("    	)                               \n");
					sqlsb.append("  VALUES                              \n");
					sqlsb.append("  	(                               \n");
					sqlsb.append(" 	   				? 		            \n");
					ps.addStringParameter(PO_NO);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(PO_SEQ);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(ADD_DATE);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(ADD_TIME);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(ADD_USER_ID);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(ADD_DATE);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(ADD_TIME);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(ADD_DATE);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(COMPANY_CODE);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(SELLER_CODE);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(UNIT_MEASURE);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(ITEM_QTY);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(UNIT_PRICE);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(PR_AMT);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(RD_DATE);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(PO_CREATE_DATE);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(ADD_TIME);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(PR_NUMBER);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(PR_SEQ);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(PR_DEPT);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(DESCRIPTION_LOC);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(DESCRIPTION_LOC);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(SPECIFICATION);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(DELY_TO_LOCATION);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(Z_DELIVERY_DATE);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(DEL_FLAG);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(PR_USER_ID);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(PR_USER_NAME);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(CONT_NO);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(CONT_SUBJECT);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(CONT_AMT);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(CONT_DATE);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(CONT_USER_ID);
					
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(ACCOUNTS_COURSES_CODE);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(ACCOUNTS_COURSES_LOC);
					sqlsb.append(" 	   		,		? 		            \n");
					ps.addStringParameter(ASSET_NUMBER);
					
					
					sqlsb.append("    	)                               \n");
					
					
					value = ps.doInsert(sqlsb.toString());

					//PR������ ���� �������{scode_type=M157}
					ps.removeAllValue();
					sqlsb.delete(0, sqlsb.length());
					sqlsb.append("		UPDATE SPRLN SET			\n");
					sqlsb.append("			 PR_PROCEEDING_FLAG = ?	\n");ps.addStringParameter("PT");//PO��
					sqlsb.append("			,DEL_FLAG			= ?	\n");ps.addStringParameter("N");
					sqlsb.append("			,CHANGE_USER_ID		= ?	\n");ps.addStringParameter(info.getSession("ID"));
					sqlsb.append("			,CHANGE_DATE		= ?	\n");ps.addStringParameter(SepoaDate.getShortDateString());
					sqlsb.append("			,CHANGE_TIME		= ?	\n");ps.addStringParameter(SepoaDate.getShortTimeString());
					sqlsb.append("		WHERE PR_NUMBER	= ?			\n");ps.addStringParameter(PR_NUMBER);
					sqlsb.append("		  AND PR_SEQ	= ?			\n");ps.addStringParameter(PR_SEQ);
					ps.doInsert(sqlsb.toString());

					
					if(i == 0) {
						ps.removeAllValue();
						sqlsb.delete(0, sqlsb.length());
						sqlsb.append("	UPDATE SCPGL SET												\n");
						sqlsb.append("   CT_FLAG             = 	?		            \n");ps.addStringParameter("CD");
						sqlsb.append("	WHERE CONT_NO        = 	?		            \n");ps.addStringParameter(CONT_NO);
						value = ps.doInsert(sqlsb.toString());
					}
					

				}else{
					
					ps.removeAllValue();
					sqlsb.delete(0, sqlsb.length());
					sqlsb.append(" UPDATE SPOLN												\n");
					sqlsb.append("    SET                                                   \n");
					sqlsb.append("         CHANGE_DATE             = 	?		            \n");
					ps.addStringParameter(ADD_DATE);
					sqlsb.append("        ,CHANGE_TIME             = 	?		            \n");
					ps.addStringParameter(ADD_TIME);
					sqlsb.append("        ,CHANGE_USER_ID          = 	?		            \n");
					ps.addStringParameter(ADD_DATE);
					sqlsb.append("        ,SELLER_CODE             = 	?		            \n");
					ps.addStringParameter(SELLER_CODE);
					sqlsb.append("        ,DESCRIPTION_LOC         = 	?		            \n");
					ps.addStringParameter(DESCRIPTION_LOC);
					sqlsb.append("        ,DESCRIPTION_ENG         = 	?		            \n");
					ps.addStringParameter(DESCRIPTION_LOC);
					sqlsb.append("        ,SPECIFICATION           = 	?		            \n");
					ps.addStringParameter(SPECIFICATION);
					sqlsb.append("        ,UNIT_MEASURE            = 	?		            \n");
					ps.addStringParameter(UNIT_MEASURE);
					sqlsb.append("     	  ,ITEM_QTY                = 	?	   				\n");
					ps.addStringParameter(ITEM_QTY);
					sqlsb.append("        ,UNIT_PRICE              = 	?		            \n");
					ps.addStringParameter(UNIT_PRICE);
					sqlsb.append("     	  ,ITEM_AMT                = 	?	   				\n");
					ps.addStringParameter(PR_AMT);
					sqlsb.append("     	  ,PO_CREATE_DATE          = 	?	   				\n");
					ps.addStringParameter(PO_CREATE_DATE);
					sqlsb.append("     	  ,PO_CREATE_TIME          = 	?	   				\n");
					ps.addStringParameter(ADD_TIME);
					sqlsb.append("        ,Z_DELIVERY_DATE         = 	?		            \n");
					ps.addStringParameter(Z_DELIVERY_DATE);
					sqlsb.append("        ,DELY_TO_LOCATION        = 	?		            \n");
					ps.addStringParameter(DELY_TO_LOCATION);
					sqlsb.append("        ,CONT_NUMBER             = 	?		            \n");
					ps.addStringParameter(CONT_NO);
					sqlsb.append(" 	   	  ,CONT_SUBJECT            = 	?		            \n");
					ps.addStringParameter(CONT_SUBJECT);
					sqlsb.append(" 	   	  ,CONT_AMT                = 	?		            \n");
					ps.addStringParameter(CONT_AMT);
					sqlsb.append(" 	   	  ,CONT_DATE               = 	?		            \n");
					ps.addStringParameter(CONT_DATE);
					sqlsb.append(" 	   	  ,CONT_USER_ID            = 	?		            \n");
					ps.addStringParameter(CONT_USER_ID);
					sqlsb.append("                                                          \n");
					sqlsb.append("  WHERE "+DB_NULL_FUNCTION+"(DEL_FLAG, 'N') = 'N'         \n");
					sqlsb.append("    AND PO_NUMBER               = 	?		            \n");
					ps.addStringParameter(PO_NO);
					sqlsb.append("    AND PO_SEQ                  = 	?		            \n");
					ps.addStringParameter(PO_SEQ);
					
					value = ps.doUpdate(sqlsb.toString());
				}
				
			}
			
			rtn[0] = String.valueOf(value);
		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
//			e.printStackTrace();
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}
		
		return rtn;
	} 
	
    public String[] getPOCount(String PO_NO, String PO_SEQ, String TableName) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		String[] rtn = new String[2];
		SepoaFormater wf = null;
		String result = "";
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
		
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			
			sqlsb.append(" SELECT                                               \n");
			sqlsb.append(" 		   COUNT(PO_NUMBER)          	                \n");
			sqlsb.append("                                                     	\n");
			sqlsb.append("   FROM "+TableName+"                                 \n");
			sqlsb.append("    WHERE 1=1            		       					\n");
								
			sqlsb.append(sm.addSelectString(" AND PO_NUMBER =  ?				\n"));
			sm.addStringParameter(PO_NO);
			sqlsb.append(sm.addSelectString(" AND PO_SEQ =  ?					\n"));
			sm.addStringParameter(PO_SEQ);
			
			result = sm.doSelect(sqlsb.toString());
			wf = new SepoaFormater(result);
			rtn[0] = wf.getValue(0, 0);
			
		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
//			e.printStackTrace();
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return rtn;
		
	}
    
    public String[] getContCount(String cont_no) {
    	
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sqlsb = new StringBuffer();
    	
    	String[] rtn = new String[2];
    	SepoaFormater wf = null;
    	String result = "";
    	
    	try {
    		setStatus(1);
    		setFlag(true);
    		
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		
    		sm.removeAllValue();
    		sqlsb.delete(0, sqlsb.length());
    		
//    		등록일때 이미 발주된 건이면 리턴 시킨다.
    		sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("	SELECT COUNT(CONT_NUMBER) AS CNT FROM SPOLN		\n");
			sqlsb.append("	 WHERE CONT_NUMBER = '"+ cont_no +"'						\n");
			sqlsb.append("	   AND NVL(DEL_FLAG, 'N')  = 'N'						\n");
    		
    		result = sm.doSelect(sqlsb.toString());
    		wf = new SepoaFormater(result);
    		
    		if(!wf.getValue(0, 0).equals("0"))
    			rtn[1] = "발주서가 이미 존재합니다. 확인하시기 바랍니다.";
    		else 
    			rtn[0] = wf.getValue(0, 0);
    	}
    	catch (Exception e)
    	{
    		rtn[1] = "발주서가 이미 존재합니다. 확인하시기 바랍니다.";
//    		e.printStackTrace();
    		Logger.debug.println(info.getSession("ID"), this, e.getMessage());
    	}
    	
    	return rtn;
    	
    }
    
    
    public SepoaOut getPrContractWaitListInsert(String pr_number) {

		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		String COMPANY_CODE = info.getSession("COMPANY_CODE");
		String USER_TYPE = info.getSession("USER_TYPE");
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append(" SELECT                                                                                            \n");
			sqlsb.append("    	 GL.PR_NUMBER       as PR_NO	        -- ���ſ�û��ȣ                                         \n");
			sqlsb.append("    	,LN.PR_SEQ	        as PR_SEQ           -- ���ſ�û�׹�                                         \n");
			sqlsb.append("    	,LN.DESCRIPTION_LOC as DESCRIPTION_LOC  -- ǰ��                                                 \n");
			sqlsb.append("    	,LN.SPECIFICATION   as SPECIFICATION    -- Spec                                                 \n");
			sqlsb.append("    	,LN.UNIT_MEASURE 	as UNIT_MEASURE     -- ��'                                                 \n");
			sqlsb.append("    	,GETCODETEXT1('M007', LN.UNIT_MEASURE, 'KO') AS UNIT_MEASURE_TEXT  	-- ��'                     \n");
			sqlsb.append("    	,LN.PR_QTY 	        as SETTLE_QTY       -- ��                                                 \n");
			sqlsb.append("    	,LN.UNIT_PRICE      as UNIT_PRICE       -- ��d�ܰ�                                             \n");
			sqlsb.append("    	,LN.PR_AMT  	    as ITEM_AMT         -- ��d�ݾ�                                             \n");
			sqlsb.append("    	,GETDATEFORMAT(GL.CHANGE_DATE) AS CHANGE_DATE	-- ���ſ�û����                                 \n");
			sqlsb.append("    	,GL.DEMAND_DEPT -- ���ſ�û�μ�                                                                 \n");
			sqlsb.append("    	,GETDEPTNAME(GL.COMPANY_CODE,GL.DEMAND_DEPT, 'KO') AS DEMAND_DEPT_LOC -- ���ſ�û�μ�          \n");
			sqlsb.append("    	,GL.PR_USER_ID -- ���ſ�û��                                                                    \n");
			sqlsb.append("    	,GETUSERNAME(GL.PR_USER_ID, 'KO') AS PR_USER_NAME -- ���ſ�û��                                 \n");
			sqlsb.append("    	,GETDATEFORMAT(LN.RD_DATE) AS RD_DATE	-- ��俹d��                                           \n");
			sqlsb.append("    	,LN.DELY_TO_LOCATION -- ��ǰ���                                                                \n");
			sqlsb.append("    	,GL.CTRL_FLAG   -- �������                                                                     \n");
			sqlsb.append("    	,GETCODETEXT1('M638', GL.CTRL_FLAG, 'KO') AS PR_PROCEEDING_FLAG_TXT  -- �������                \n");
			sqlsb.append("    	,LN.MATERIAL_NUMBER		-- ǰ���ڵ�                                                             \n");
			sqlsb.append("    	,LN.MAKER                  -- fv��                                                            \n");
			sqlsb.append("    	,LN.YEAR_OF_MANUFACTURE    -- fv�⵵                                                          \n");
			sqlsb.append("    	,LN.ACCOUNTS_COURSES_CODE  -- ��d�ڵ�                                                          \n");
			sqlsb.append("    	,LN.ACCOUNTS_COURSES_LOC   -- ��d���                                                          \n");
			sqlsb.append("    	,LN.ASSET_NUMBER		    -- �ڻ��ȣ                                                         \n");
			sqlsb.append(" FROM SPRGL GL                                                                                  \n");
			sqlsb.append("      , SPRLN LN                                                                             \n");
			sqlsb.append(" WHERE GL.PR_NUMBER = LN.PR_NUMBER                                                               \n");
			sqlsb.append("   AND NVL(GL.DEL_FLAG, 'N') = 'N'                                                               \n");
			sqlsb.append("   AND NVL(LN.DEL_FLAG, 'N') = 'N'                                                               \n");
			sqlsb.append(sm.addSelectString("    AND GL.PR_NUMBER = ?                        \n"));
			sm.addStringParameter(pr_number);
			sqlsb.append("  ORDER BY GL.PR_NUMBER, LN.PR_SEQ           									\n");
			setValue(sm.doSelect(sqlsb.toString()));

		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
    
    public SepoaOut getPrMtContractWaitListInsert(String pr_number, String pr_seq) {
    	
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sqlsb = new StringBuffer();
    	String COMPANY_CODE = info.getSession("COMPANY_CODE");
    	String USER_TYPE = info.getSession("USER_TYPE");
    	
    	try {
    		setStatus(1);
    		setFlag(true);
    		
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		
    		sm.removeAllValue();
    		sqlsb.delete(0, sqlsb.length());
    		sqlsb.append("    SELECT                                                                                            \n");
    		sqlsb.append("    	 GL.PR_NUMBER       as PR_NO	        -- ���ſ�û��ȣ                                         \n");
    		sqlsb.append("    	,LN.PR_SEQ	        as PR_SEQ           -- ���ſ�û�׹�                                         \n");
    		sqlsb.append("    	,LN.DESCRIPTION_LOC as DESCRIPTION_LOC  -- ǰ��                                                 \n");
    		sqlsb.append("    	,LN.SPECIFICATION   as SPECIFICATION    -- Spec                                                 \n");
    		sqlsb.append("    	,LN.UNIT_MEASURE 	as UNIT_MEASURE     -- ��'                                                 \n");
    		sqlsb.append("    	,GETCODETEXT1('M007', LN.UNIT_MEASURE, 'KO') AS UNIT_MEASURE_TEXT  	-- ��'                     \n");
    		sqlsb.append("    	,LN.PR_QTY 	        as SETTLE_QTY       -- ��                                                 \n");
    		sqlsb.append("    	,LN.UNIT_PRICE      as UNIT_PRICE       -- ��d�ܰ�                                             \n");
    		sqlsb.append("    	,LN.PR_AMT  	    as ITEM_AMT         -- ��d�ݾ�                                             \n");
    		sqlsb.append("    	,GETDATEFORMAT(GL.CHANGE_DATE) AS CHANGE_DATE	-- ���ſ�û����                                 \n");
    		sqlsb.append("    	,GL.DEMAND_DEPT -- ���ſ�û�μ�                                                                 \n");
    		sqlsb.append("    	,GETDEPTNAME(GL.COMPANY_CODE,GL.DEMAND_DEPT, 'KO') AS DEMAND_DEPT_LOC -- ���ſ�û�μ�           \n");
    		sqlsb.append("    	,GL.PR_USER_ID -- ���ſ�û��                                                                    \n");
    		sqlsb.append("    	,GETUSERNAME(GL.PR_USER_ID, 'KO') AS PR_USER_NAME -- ���ſ�û��                                 \n");
    		sqlsb.append("    	,GETDATEFORMAT(LN.RD_DATE) AS RD_DATE	-- ��俹d��                                           \n");
    		sqlsb.append("    	,LN.DELY_TO_LOCATION -- ��ǰ���                                                                \n");
    		sqlsb.append("    	,GL.CTRL_FLAG   -- �������                                                                     \n");
    		sqlsb.append("    	,GETCODETEXT1('M638', GL.CTRL_FLAG, 'KO') AS PR_PROCEEDING_FLAG_TXT  -- �������                \n");
    		sqlsb.append("    	,LN.MATERIAL_NUMBER		-- ǰ���ڵ�                                                             \n");
    		sqlsb.append("    	,LN.MAKER                  -- fv��                                                            \n");
    		sqlsb.append("    	,LN.YEAR_OF_MANUFACTURE    -- fv�⵵                                                          \n");
    		sqlsb.append("    	,LN.ACCOUNTS_COURSES_CODE  -- ��d�ڵ�                                                          \n");
    		sqlsb.append("    	,LN.ACCOUNTS_COURSES_LOC   -- ��d���                                                          \n");
    		sqlsb.append("    	,LN.ASSET_NUMBER		    -- �ڻ��ȣ                                                         \n");
    		sqlsb.append("       FROM SPRGL GL                                                                                  \n");
    		sqlsb.append("      , SPRLN LN                                                                             \n");
    		sqlsb.append("       WHERE GL.PR_NUMBER = LN.PR_NUMBER                                                               \n");
    		sqlsb.append("      AND NVL(GL.DEL_FLAG, 'N') = 'N'                                                               \n");
    		sqlsb.append("        AND NVL(LN.DEL_FLAG, 'N') = 'N'                                                               \n");
    		sqlsb.append("        AND ( 1 = 2																					\n");
    		
    		
    		StringTokenizer number = new StringTokenizer(pr_number, "@@@");
    		StringTokenizer seq    = new StringTokenizer(pr_seq,    "@@@");
    		
    		while (number.hasMoreTokens()) {
	    		sqlsb.append(sm.addSelectString("     OR (GL.PR_NUMBER = ?                        									\n"));
	    		sm.addStringParameter(number.nextToken());
	    		
	    		sqlsb.append(sm.addSelectString("    AND LN.PR_SEQ = ?)                        										\n"));
	    		sm.addStringParameter(seq.nextToken());
    		}
    		
    		
    		
    		sqlsb.append("        )                                                               								\n");
    		sqlsb.append("  ORDER BY GL.PR_NUMBER, LN.PR_SEQ           															\n");
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