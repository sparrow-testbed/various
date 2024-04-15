package ev;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;

import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
 
public class WO_203 extends SepoaService{

	public WO_203(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		setVersion("1.0.0");
	}

	public SepoaOut ev_query_203( String sg_kind, String sg_kind_1, String ev_year ) throws Exception{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb       = new StringBuffer();
			ParamSql sm           = new ParamSql(info.getSession("ID"), this, ctx);
			ArrayList arr_list    = new ArrayList();
			SepoaFormater sf      = null;
			SepoaFormater sf1     = null;
			SepoaFormater sf2     = null;
			SepoaFormater sf3     = null;
			int mapnum            = 0;
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("		DELETE FROM SHEET_RESULT																\n "); // 평가시트결과표 테이블 지우기
			sm.doDelete(sb.toString());
			
			sm.removeAllValue();  
			sb.delete(0, sb.length());
			sb.append("				SELECT  A.EV_YEAR																\n ");
			sb.append("				       ,A.EV_NO               													\n ");	
			sb.append("					   ,B.SG_REGITEM                                                            \n ");
			sb.append("				FROM   SEVGL    A                                                               \n ");
			sb.append("				      ,SEVVN    B                                                               \n ");
			sb.append("				WHERE  1=1                                                                      \n ");
			sb.append(sm.addFixString(" AND    A.SG_KIND   = ?                                                      \n "));	sm.addStringParameter(sg_kind);
			if(!"".equals(ev_year)){
				sb.append(sm.addFixString(" AND    A.EV_YEAR   = ?                                                      \n ")); sm.addStringParameter(ev_year);
			}
			sb.append("				--AND    A.USE_FLAG  = 'Y'                                                        \n ");
			sb.append("				AND    A.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.EV_NO     = B.EV_NO                                                    \n ");
			sb.append("				AND    A.EV_YEAR   = B.EV_YEAR                                                  \n ");
			sb.append("				AND    B.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.PERIOD    = 'P'                                                        \n ");
			//**변경**
			sb.append("				AND    A.SHEET_STATUS = 'ED'  													\n ");
			//*******
			sb.append("				AND    B.SG_REGITEM IN (                                                        \n ");
			sb.append("					   				    SELECT SG_REFITEM                                       \n ");
			sb.append("										FROM   SSGGL                                            \n ");
			sb.append("										WHERE LEVEL_COUNT         = '3'                         \n ");
			sb.append(sm.addFixString("						AND  PARENT_SG_REFITEM    =  ?                          \n ")); sm.addStringParameter(sg_kind_1);
			sb.append("										AND  NOTICE_FLAG          = 'Y'                         \n ");
			sb.append("										AND  DEL_FLAG             = 'N'                         \n ");
			sb.append("										AND  SUBSTR(ADD_DATE,1,4) = TO_CHAR(SYSDATE,'YYYY')     \n ");
			sb.append("				                       )                                                        \n ");
			sb.append("				GROUP BY A.EV_NO                                                                \n ");
			sb.append("				        ,A.EV_YEAR                                                              \n ");
			sb.append("						,B.SG_REGITEM                                                           \n ");
			sb.append("				ORDER BY EV_NO                                                                  \n ");			
			
			sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));
			
			for( int i = 0; i < sf.getRowCount(); i++ ){
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("				    SELECT  EV_SEQ															\n ");
				sb.append("				           ,EV_M_ITEM                                                       \n ");
				sb.append("				           ,EV_D_ITEM                                                       \n ");
				sb.append("				           ,GETEV_M_ITEMEXT1(EV_M_ITEM,EV_D_ITEM) AS EV_D_ITEM_NAME         \n ");
				sb.append("				    FROM    SEVLN                                                           \n ");
				sb.append("				    WHERE   1=1                                                             \n ");
				sb.append(sm.addFixString("	AND     EV_NO       = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				
				if(!"".equals(sf.getValue("EV_YEAR"  , i))){
					sb.append(sm.addFixString("	AND     EV_YEAR     = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				}
				sb.append("				    AND     DEL_FLAG    = 'N'                                               \n ");
				sb.append("				    ORDER BY  EV_SEQ                                                        \n ");
				sf1 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				sf3 = new SepoaFormater(sm.doSelect_limit(sb.toString()));

				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격')  AS  VN_STATUS									\n ");
				sb.append("		      ,ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total = new StringBuffer();
				for( int k = 0; k < 15; k++ ){
					//if( k != 14 ){
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
				//	}else{
				//		sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
				//	}
					total.append("A.SCORE" + k);
					if( k != 14 ){
						total.append("+");
					}
				}
				sb.append("			  ,(" + total.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 15; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf1.getRowCount(); k++ ){
						// 회사규모 >> 사업년수
						if( z == 0 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 회사규모 >> 매출규모
						else if( z == 1 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 재무상태 >> 부채비율
						else if( z == 2 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( z == 3 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 재무상태 >> 매출액영업이익율
						else if( z == 4 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 기술능력 >> 공장등록
						else if( z == 5 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> 인원현황
						else if( z == 6 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> 창고보유
						else if( z == 7 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row3") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf1.removeValue(k);
							break;	
						}
						// 이행실적 >> 당행
						else if( z == 8 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 이행실적 >> 기업체
						else if( z == 9 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 품질관리 >> 사후관리
						else if( z == 10 && sf1.getValue("EV_M_ITEM", k).equals("ev8") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}					
						// 당행기여도 >> RAR실적
						else if( z == 11 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 신용카드
						else if( z == 12 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 급여이체
						else if( z == 13 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						//당행기여도 >> 퇴직연금실적
						else if( z == 14 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append(sm.addFixString("		AND     EV_NO       = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append(sm.addFixString("		AND     EV_YEAR     = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				sb.append("		ORDER BY ROWNUM, VN_STATUS DESC                                                                 \n ");
				
				sf2 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				
				sm.removeAllValue();  // 평가시트 결과표 복사 (INSERT)
				sb.delete(0, sb.length());
				sb.append(" insert into SHEET_RESULT \n ");
				sb.append(" ( \n ");
				sb.append(" 	  ITEM_NAME        ,    \n ");
				sb.append(" 	  VN_STATUS        ,	\n ");
				sb.append(" 	  NO               ,	\n ");
				sb.append(" 	  VENDOR_NAME      ,	\n ");
				sb.append(" 	  DATA0            ,	\n ");
				sb.append(" 	  SCORE0       	   ,	\n ");
				sb.append("       DATA1            ,	 \n");
				sb.append("       SCORE1           ,	 \n");
				sb.append("       DATA2            ,	 \n");
				sb.append("       SCORE2	   ,	 \n");
				sb.append("       DATA3            ,	 \n");
				sb.append("       SCORE3           ,	 \n");
				sb.append("       DATA4            ,	 \n");
				sb.append("       SCORE4           ,	 \n");
				sb.append("       DATA5            ,	 \n");
				sb.append("       SCORE5           ,	 \n");
				sb.append("       DATA6            ,	 \n");
				sb.append("       SCORE6           ,	 \n");
				sb.append("       DATA7            ,	 \n");
				sb.append("       SCORE7           ,	 \n");
				sb.append("       DATA8            ,	 \n");
				sb.append("       SCORE8           ,	 \n");
				sb.append("       DATA9            ,	 \n");
				sb.append("       SCORE9           ,	 \n");
				sb.append("       DATA10           ,	 \n");
				sb.append("       SCORE10          ,	 \n");
				sb.append("       DATA11           ,	 \n");
				sb.append("       SCORE11          ,	 \n");
				sb.append("       DATA12           ,	 \n");
				sb.append("       SCORE12          ,	 \n");
				sb.append("       DATA13           ,	 \n");
				sb.append("       SCORE13          ,	 \n");
				sb.append("       DATA14           ,	 \n");
				sb.append("       SCORE14          ,	 \n");
			//	sb.append("        DATA15          ,	 \n");
			//	sb.append("       SCORE15          ,	 \n");
			//	sb.append("        DATA16          ,	 \n");
			//	sb.append("       SCORE16          ,	 \n");
			//	sb.append("        DATA17          ,	 \n");
			//	sb.append("       SCORE17          ,	 \n");
				sb.append("     TOTAL              ,	 \n");
				sb.append("     SCORE           ,	 \n");
				sb.append("     EV_NO              ,	 \n");
				sb.append("     EV_YEAR            ,	 \n");
				sb.append("     SELLER_CODE        ,	 \n");
				sb.append("     SELLER_NAME_LOC    ,	 \n");
				sb.append("     SG_REGITEM         	 \n");


				sb.append(" ) \n ");
				//sb.append(" values \n ");
				sb.append(" ( \n ");

				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격')  AS  VN_STATUS									\n ");
				sb.append("		      ,"+i+"||ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total_1 = new StringBuffer();
				for( int k = 0; k < 15; k++ ){
					//if( k != 14 ){
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}else{
					//	sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}
					total_1.append("A.SCORE" + k);
					if( k != 14 ){
						total_1.append("+");
					}
				}
				sb.append("			  ,(" + total_1.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 15; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf3.getRowCount(); k++ ){
						// 회사규모 >> 사업년수
						if( z == 0 && sf3.getValue("EV_M_ITEM", k).equals("ev1") && sf3.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 회사규모 >> 매출규모
						else if( z == 1 && sf3.getValue("EV_M_ITEM", k).equals("ev1") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 재무상태 >> 부채비율
						else if( z == 2 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( z == 3 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 재무상태 >> 매출액영업이익율
						else if( z == 4 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 기술능력 >> 공장등록
						else if( z == 5 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 기술능력 >> 인원현황
						else if( z == 6 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 기술능력 >> 창고보유
						else if( z == 7 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row3") ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf3.removeValue(k);
							break;	
						}
						// 이행실적 >> 당행
						else if( z == 8 && sf3.getValue("EV_M_ITEM", k).equals("ev4") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 이행실적 >> 기업체
						else if( z == 9 && sf3.getValue("EV_M_ITEM", k).equals("ev4") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 품질관리 >> 사후관리
						else if( z == 10 && sf3.getValue("EV_M_ITEM", k).equals("ev8") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}					
						// 당행기여도 >> RAR실적
						else if( z == 11 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 신용카드
						else if( z == 12 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 급여이체
						else if( z == 13 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						//당행기여도 >> 퇴직연금실적
						else if( z == 14 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE    END),0))          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append("		AND     EV_NO       = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append("		AND     EV_YEAR     = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				//sb.append("		ORDER BY ROWNUM, VN_STATUS DESC                                                                 \n ");
	
				
				
				sb.append(" )	 \n ");
				sm.doInsert(sb.toString());	
				Commit();
				
				for ( int r = 0; r < sf2.getRowCount(); r++ )
	            {
					ArrayList ht = new ArrayList();
					//ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE"       , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_NO"          , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_YEAR"        , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_CODE"    , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_NAME_LOC", r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SG_REGITEM"     , r) ).trim() );	
					
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("ITEM_NAME"  , r) ).trim() );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VN_STATUS"  , r) ).trim() );
	            	ht.add( ""+(mapnum+1) );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VENDOR_NAME", r) ).trim() );
					for( int k = 0; k < 15; k++ ){
						//if( k != 14 ){
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("DATA"  + k, r) ).trim());
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE" + k, r) ).trim());
						//}else{
						//	ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE" + k, r) ).trim());
						//}
					}
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE"       , r) ).trim() );
					//ht.add(JSPUtil.nullToEmpty( sf2.getValue("TOTAL", r) ).trim() );
	            	arr_list.add(ht);
	            	mapnum++;
	            }//for~end		
			}
			setValue(arr_list);
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
		}

		return getSepoaOut();
	}	

	public SepoaOut ev_query_204( String sg_kind, String sg_kind_1, String ev_year ) throws Exception{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb       = new StringBuffer();
			StringBuffer sb1      = new StringBuffer();
			StringBuffer sb2      = new StringBuffer();
			StringBuffer sb3      = new StringBuffer();
			StringBuffer sb4      = new StringBuffer();			
			ParamSql sm           = new ParamSql(info.getSession("ID"), this, ctx);
			ArrayList arr_list    = new ArrayList();
			SepoaFormater sf      = null;
			SepoaFormater sf1     = null;
			SepoaFormater sf2     = null;
			SepoaFormater sf3     = null;
			int mapnum            = 0;
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("		DELETE FROM SHEET_RESULT																\n "); // 평가시트결과표 테이블 지우기
			sm.doDelete(sb.toString());
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("				SELECT  A.EV_YEAR																\n ");
			sb.append("				       ,A.EV_NO               													\n ");	
			sb.append("					   ,B.SG_REGITEM                                                            \n ");
			sb.append("				FROM   SEVGL    A                                                               \n ");
			sb.append("				      ,SEVVN    B                                                               \n ");
			sb.append("				WHERE  1=1                                                                      \n ");
			sb.append(sm.addFixString(" AND    A.SG_KIND   = ?                                                      \n "));	sm.addStringParameter(sg_kind);
			sb.append(sm.addFixString(" AND    A.EV_YEAR   = ?                                                      \n ")); sm.addStringParameter(ev_year);
			sb.append("				AND    A.USE_FLAG  = 'Y'                                                        \n ");
			sb.append("				AND    A.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.EV_NO     = B.EV_NO                                                    \n ");
			sb.append("				AND    A.EV_YEAR   = B.EV_YEAR                                                  \n ");
			sb.append("				AND    B.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.PERIOD    = 'P'                                                        \n ");
			//**변경**
			sb.append("				AND    A.SHEET_STATUS = 'ED'  													\n ");
			//*******
			sb.append("				AND    B.SG_REGITEM IN (                                                        \n ");
			sb.append("					   				    SELECT SG_REFITEM                                       \n ");
			sb.append("										FROM   SSGGL                                            \n ");
			sb.append("										WHERE LEVEL_COUNT         = '3'                         \n ");
			sb.append(sm.addFixString("						AND  PARENT_SG_REFITEM    =  ?                          \n ")); sm.addStringParameter(sg_kind_1);
			sb.append("										AND  NOTICE_FLAG          = 'Y'                         \n ");
			sb.append("										AND  DEL_FLAG             = 'N'                         \n ");
			sb.append("										AND  SUBSTR(ADD_DATE,1,4) = TO_CHAR(SYSDATE,'YYYY')     \n ");
			sb.append("				                       )                                                        \n ");
			sb.append("				GROUP BY A.EV_NO                                                                \n ");
			sb.append("				        ,A.EV_YEAR                                                              \n ");
			sb.append("						,B.SG_REGITEM                                                           \n ");
			sb.append("				ORDER BY EV_NO                                                                  \n ");			
			
			sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));
			
			for( int i = 0; i < sf.getRowCount(); i++ ){
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("				    SELECT  EV_SEQ															\n ");
				sb.append("				           ,EV_M_ITEM                                                       \n ");
				sb.append("				           ,EV_D_ITEM                                                       \n ");
				sb.append("				           ,GETEV_M_ITEMEXT1(EV_M_ITEM,EV_D_ITEM) AS EV_D_ITEM_NAME         \n ");
				sb.append("				    FROM    SEVLN                                                           \n ");
				sb.append("				    WHERE   1=1                                                             \n ");
				sb.append(sm.addFixString("	AND     EV_NO       = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append(sm.addFixString("	AND     EV_YEAR     = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("				    AND     DEL_FLAG    = 'N'                                               \n ");
				sb.append("				    ORDER BY  EV_SEQ                                                        \n ");
				sf1 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				sf2 = new SepoaFormater(sm.doSelect_limit(sb.toString()));

				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격')  AS  VN_STATUS									\n ");
				sb.append("		      ,ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total = new StringBuffer();
				for( int k = 0; k < 18; k++ ){
					if( k == 7 ||  k == 8){
						continue;
					}
					else if( k == 9 ){
						sb.append("	  ,(CASE WHEN B.VN_STATUS != '' OR B.VN_STATUS IS NOT NULL 										\n ");
						sb.append("	         THEN (CASE WHEN A.DATA7 = '1' AND A.DATA8 = '1' AND A.DATA9 = '1'                      \n ");
						sb.append("	                    THEN '보유'                                                                 \n ");
						sb.append("						ELSE (CASE WHEN A.DATA7 = '1' OR A.DATA8 = '1' OR A.DATA9 = '1'             \n ");
						sb.append("						           THEN '일부보유'                                                  \n ");
						sb.append("								   ELSE (CASE WHEN A.DATA7 = '0' OR A.DATA8 = '0' OR A.DATA9 = '0'  \n ");
						sb.append("								              THEN '미보유'                                         \n ");
						sb.append("										 END)                                                       \n ");
						sb.append("						      END )                                                                 \n ");
						sb.append("			       END )                                                                            \n ");
						sb.append("	    END )                             AS DATA9                                                                              \n ");
						sb.append("   ,( A.SCORE7 + A.SCORE8 + A.SCORE9 ) AS SCORE9                                                 \n ");
					}
					//else if( k != 17 ){
					else{
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}else{
					//	sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					}
					total.append("A.SCORE" + k);
					if( k != 17 ){
						total.append("+");
					}
				}
				sb.append("			  ,(" + total.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 18; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf1.getRowCount(); k++ ){
						// 회사규모 >> 사업년수
						if( z == 0 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 회사규모 >> 매출규모
						else if( z == 1 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 재무상태 >> 부채비율
						else if( z == 2 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( z == 3 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 재무상태 >> 매출액영업이익율
						else if( z == 4 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 기술능력 >> 공장등록
						else if( z == 5 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> 인원현황
						else if( z == 6 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> 시설보유
						else if( z == 7 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row4") ){
							sb.append(", NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN ITEM_CHECK    END),0)     AS DATA"  + z + "    \n ");
							sb.append(", NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)       AS SCORE" + z + "    \n ");
							chk     = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> 시설보유(II)
						else if( z == 8 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row15") ){
							sb.append(", NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN ITEM_CHECK    END),0)     AS DATA"  + z + "    \n ");
							sb.append(", NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)       AS SCORE" + z + "    \n ");
							chk     = 1;
							sf1.removeValue(k);
							break;
						}						
						// 기술능력 >> 시설보유(III)
						else if( z == 9 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row16") ){
							sb.append(", NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN ITEM_CHECK    END),0)     AS DATA"  + z + "    \n ");
							sb.append(", NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)       AS SCORE" + z + "    \n ");
							chk     = 1;
							sf1.removeValue(k);
							break;						
						}						
						// 기술능력 >> 조합가입여부
						else if( z == 10 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row5") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf1.removeValue(k);
							break;	
						}
						// 이행실적 >> 당행
						else if( z == 11 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 이행실적 >> 기업체
						else if( z == 12 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 품질관리 >> 품질관리
						else if( z == 13 && sf1.getValue("EV_M_ITEM", k).equals("ev8") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}					
						// 당행기여도 >> RAR실적
						else if( z == 14 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 신용카드
						else if( z == 15 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 급여이체
						else if( z == 16 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 퇴직연금실적
						else if( z == 17 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}					
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("								,ITEM_CHECK                                      		           		\n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append(sm.addFixString("		AND     EV_NO       = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append(sm.addFixString("		AND     EV_YEAR     = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				sb.append("		ORDER BY ROWNUM, VN_STATUS DESC                                                                 \n ");
				
				sf3 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				
				sm.removeAllValue();  // 평가시트 결과표 복사 (INSERT)
				sb.delete(0, sb.length());
				sb.append(" insert into SHEET_RESULT \n ");
				sb.append(" ( \n ");
				sb.append(" 	  ITEM_NAME        ,    \n ");
				sb.append(" 	  VN_STATUS        ,	\n ");
				sb.append(" 	  NO               ,	\n ");
				sb.append(" 	  VENDOR_NAME      ,	\n ");
				sb.append(" 	  DATA0            ,	\n ");
				sb.append(" 	  SCORE0       	   ,	\n ");
				sb.append("       DATA1            ,	 \n");
				sb.append("       SCORE1           ,	 \n");
				sb.append("       DATA2            ,	 \n");
				sb.append("       SCORE2	   ,	 \n");
				sb.append("       DATA3            ,	 \n");
				sb.append("       SCORE3           ,	 \n");
				sb.append("       DATA4            ,	 \n");
				sb.append("       SCORE4           ,	 \n");
				sb.append("       DATA5            ,	 \n");
				sb.append("       SCORE5           ,	 \n");
				sb.append("       DATA6            ,	 \n");
				sb.append("       SCORE6           ,	 \n");
			//	sb.append("       DATA7            ,	 \n");
			//	sb.append("       SCORE7           ,	 \n");
			//	sb.append("       DATA8            ,	 \n");
			//	sb.append("       SCORE8           ,	 \n");
				sb.append("       DATA9            ,	 \n");
				sb.append("       SCORE9           ,	 \n");
				sb.append("       DATA10           ,	 \n");
				sb.append("       SCORE10          ,	 \n");
				sb.append("       DATA11           ,	 \n");
				sb.append("       SCORE11          ,	 \n");
				sb.append("       DATA12           ,	 \n");
				sb.append("       SCORE12          ,	 \n");
				sb.append("       DATA13           ,	 \n");
				sb.append("       SCORE13          ,	 \n");
				sb.append("       DATA14           ,	 \n");
				sb.append("       SCORE14          ,	 \n");
				sb.append("        DATA15          ,	 \n");
				sb.append("       SCORE15          ,	 \n");
				sb.append("        DATA16          ,	 \n");
				sb.append("       SCORE16          ,	 \n");
				sb.append("        DATA17          ,	 \n");
				sb.append("       SCORE17          ,	 \n");
				sb.append("     TOTAL              ,	 \n");
				sb.append("     SCORE           ,	 \n");
				sb.append("     EV_NO              ,	 \n");
				sb.append("     EV_YEAR            ,	 \n");
				sb.append("     SELLER_CODE        ,	 \n");
				sb.append("     SELLER_NAME_LOC    ,	 \n");
				sb.append("     SG_REGITEM         	 \n");


				sb.append(" ) \n ");
				//sb.append(" values \n ");
				sb.append(" ( \n ");

				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격')  AS  VN_STATUS									\n ");
				sb.append("		      ,"+i+"||ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total_1 = new StringBuffer();
				for( int k = 0; k < 18; k++ ){
					if( k == 7 ||  k == 8){
						continue;
					}
					else if( k == 9 ){
						sb.append("	  ,(CASE WHEN B.VN_STATUS != '' OR B.VN_STATUS IS NOT NULL 										\n ");
						sb.append("	         THEN (CASE WHEN A.DATA7 = '1' AND A.DATA8 = '1' AND A.DATA9 = '1'                      \n ");
						sb.append("	                    THEN '보유'                                                                 \n ");
						sb.append("						ELSE (CASE WHEN A.DATA7 = '1' OR A.DATA8 = '1' OR A.DATA9 = '1'             \n ");
						sb.append("						           THEN '일부보유'                                                  \n ");
						sb.append("								   ELSE (CASE WHEN A.DATA7 = '0' OR A.DATA8 = '0' OR A.DATA9 = '0'  \n ");
						sb.append("								              THEN '미보유'                                         \n ");
						sb.append("										 END)                                                       \n ");
						sb.append("						      END )                                                                 \n ");
						sb.append("			       END )                                                                            \n ");
						sb.append("	    END )                             AS DATA9                                                                              \n ");
						sb.append("   ,( A.SCORE7 + A.SCORE8 + A.SCORE9 ) AS SCORE9                                                 \n ");
					}
					//else if( k != 17 ){
					else{
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}else{
					//	sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					}
					total_1.append("A.SCORE" + k);
					if( k != 17 ){
						total_1.append("+");
					}
				}
				sb.append("			  ,(" + total_1.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 18; z++ ){
					int chk     = 0;

					for( int k = 0; k < sf2.getRowCount(); k++ ){
						// 회사규모 >> 사업년수
						if( sf2.getValue("EV_M_ITEM", k).equals("ev1") && sf2.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							Logger.sys.println("회사규모 >> 사업년수 k = " + k);
							sf2.removeValue(k);
							break;
						}
						// 회사규모 >> 매출규모
						else if( sf2.getValue("EV_M_ITEM", k).equals("ev1") && sf2.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							Logger.sys.println("회사규모 >> 매출규모 k = " + k);
							sf2.removeValue(k);
							break;
						}
						// 재무상태 >> 부채비율
						else if(sf2.getValue("EV_M_ITEM", k).equals("ev2") && sf2.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							Logger.sys.println("재무상태 >> 부채비율 k = " + k);
							sf2.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( sf2.getValue("EV_M_ITEM", k).equals("ev2") && sf2.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							Logger.sys.println("재무상태 >> 유동비율 k = " + k);
							sf2.removeValue(k);
							break;
						}
						// 재무상태 >> 매출액영업이익율
						else if( sf2.getValue("EV_M_ITEM", k).equals("ev2") && sf2.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							Logger.sys.println("재무상태 >> 매출액영업이익율 k = " + k);
							sf2.removeValue(k);
							break;
						}						
						// 기술능력 >> 공장등록
						else if( sf2.getValue("EV_M_ITEM", k).equals("ev3") && sf2.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							Logger.sys.println("기술능력 >> 공장등록 k = " + k);
							sf2.removeValue(k);
							break;
						}
						// 기술능력 >> 인원현황
						else if( sf2.getValue("EV_M_ITEM", k).equals("ev3") && sf2.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							Logger.sys.println("기술능력 >> 인원현황 k = " + k);
							sf2.removeValue(k);
							break;
						}
						// 기술능력 >> 시설보유
						else if( sf2.getValue("EV_M_ITEM", k).equals("ev3") && sf2.getValue("EV_D_ITEM", k).equals("row4") ){
							sb.append(", TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN ITEM_CHECK    END),0))     AS DATA"  + z + "    \n ");
							sb.append(", TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))       AS SCORE" + z + "    \n ");
							chk     = 1;
							Logger.sys.println("기술능력 >> 시설보유 k = " + k);
							sf2.removeValue(k);
							break;
						}
						// 기술능력 >> 시설보유(II)
						else if( sf2.getValue("EV_M_ITEM", k).equals("ev3") && sf2.getValue("EV_D_ITEM", k).equals("row15") ){
							sb.append(", TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN ITEM_CHECK    END),0))     AS DATA"  + z + "    \n ");
							sb.append(", TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))       AS SCORE" + z + "    \n ");
							chk     = 1;
							Logger.sys.println("기술능력 >> 시설보유(II) k = " + k);
							sf2.removeValue(k);
							break;
						}						
						// 기술능력 >> 시설보유(III)
						else if(  sf2.getValue("EV_M_ITEM", k).equals("ev3") && sf2.getValue("EV_D_ITEM", k).equals("row16") ){
							sb.append(", TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN ITEM_CHECK    END),0))     AS DATA"  + z + "    \n ");
							sb.append(", TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))       AS SCORE" + z + "    \n ");
							chk     = 1;
							Logger.sys.println("기술능력 >> 시설보유(III) k = " + k);
							sf2.removeValue(k);
							break;						
						}						
						// 기술능력 >> 조합가입여부
						else if( sf2.getValue("EV_M_ITEM", k).equals("ev3") && sf2.getValue("EV_D_ITEM", k).equals("row5") ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk     = 1;
							Logger.sys.println("기술능력 >> 조합가입여부 k = " + k);
							sf2.removeValue(k);
							break;	
						}
						// 이행실적 >> 당행
						else if( sf2.getValue("EV_M_ITEM", k).equals("ev4") && sf2.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							Logger.sys.println("이행실적 >> 당행 k = " + k);
							sf2.removeValue(k);
							break;
						}						
						// 이행실적 >> 기업체
						else if(sf2.getValue("EV_M_ITEM", k).equals("ev4") && sf2.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							Logger.sys.println("이행실적 >> 기업체 k = " + k);
							sf2.removeValue(k);
							break;
						}
						// 품질관리 >> 품질관리
						else if( sf2.getValue("EV_M_ITEM", k).equals("ev8") && sf2.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							Logger.sys.println("품질관리 >> 품질관리 k = " + k);
							sf2.removeValue(k);
							break;
						}					
						// 당행기여도 >> RAR실적
						else if( sf2.getValue("EV_M_ITEM", k).equals("ev5") && sf2.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							Logger.sys.println("당행기여도 >> RAR실적 k = " + k);
							sf2.removeValue(k);
							break;
						}
						// 당행기여도 >> 신용카드
						else if( sf2.getValue("EV_M_ITEM", k).equals("ev5") && sf2.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							Logger.sys.println("당행기여도 >> 신용카드 k = " + k);
							sf2.removeValue(k);
							break;
						}
						// 당행기여도 >> 급여이체
						else if( sf2.getValue("EV_M_ITEM", k).equals("ev5") && sf2.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							Logger.sys.println("당행기여도 >> 급여이체 k = " + k);
							sf2.removeValue(k);
							break;
						}
						// 당행기여도 >> 퇴직연금실적
						else if( sf2.getValue("EV_M_ITEM", k).equals("ev5") && sf2.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf2.getValue("EV_SEQ", k) + "' THEN SCORE    END),0))          AS SCORE"  + z + "    \n ");
							chk = 1;
							Logger.sys.println("당행기여도 >> 퇴직연금실적 k = " + k );
							sf2.removeValue(0);
							break;
						}				
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("								,ITEM_CHECK                                      		           		\n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append("		AND     EV_NO       = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append("		AND     EV_YEAR     = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				//sb.append("		ORDER BY ROWNUM, VN_STATUS DESC                                                                 \n ");
				
				sb.append(" )	 \n ");
				sm.doInsert(sb.toString());	
				Commit();
				
				for ( int r = 0; r < sf3.getRowCount(); r++ )
	            {
					ArrayList ht = new ArrayList();
					ht.add(JSPUtil.nullToEmpty( sf3.getValue("EV_NO"          , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf3.getValue("EV_YEAR"        , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf3.getValue("SELLER_CODE"    , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf3.getValue("SELLER_NAME_LOC", r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf3.getValue("SG_REGITEM"     , r) ).trim() );	
					
	            	ht.add(JSPUtil.nullToEmpty( sf3.getValue("ITEM_NAME"  , r) ).trim() );
	            	ht.add(JSPUtil.nullToEmpty( sf3.getValue("VN_STATUS"  , r) ).trim() );
	            	ht.add( ""+(mapnum+1) );
	            	ht.add(JSPUtil.nullToEmpty( sf3.getValue("VENDOR_NAME", r) ).trim() );
					for( int k = 0; k < 18; k++ ){
						if( k == 7 || k == 8 ){
							continue;
						}
//						else if( k != 17 ){
							ht.add(JSPUtil.nullToEmpty( sf3.getValue("DATA"  + k, r) ).trim());
							ht.add(JSPUtil.nullToEmpty( sf3.getValue("SCORE" + k, r) ).trim());
//						}else{
						//	ht.add(JSPUtil.nullToEmpty( sf3.getValue("SCORE" + k, r) ).trim());
						//}
					}
					ht.add(JSPUtil.nullToEmpty( sf3.getValue("SCORE"       , r) ).trim() );
					//ht.add(JSPUtil.nullToEmpty( sf3.getValue("TOTAL", r) ).trim() );
	            	arr_list.add(ht);
	            	mapnum++;
	            }//for~end		
			}
			setValue(arr_list);
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
		}

		return getSepoaOut();
	}	

	public SepoaOut ev_query_205( String sg_kind, String sg_kind_1, String ev_year ) throws Exception{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb       = new StringBuffer();
			ParamSql sm           = new ParamSql(info.getSession("ID"), this, ctx);
			ArrayList arr_list    = new ArrayList();
			SepoaFormater sf      = null;
			SepoaFormater sf1     = null;
			SepoaFormater sf2     = null;
			SepoaFormater sf3     = null;
			int mapnum            = 0;
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("		DELETE FROM SHEET_RESULT																\n "); // 평가시트결과표 테이블 지우기
			sm.doDelete(sb.toString());
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("				SELECT  A.EV_YEAR																\n ");
			sb.append("				       ,A.EV_NO               													\n ");	
			sb.append("					   ,B.SG_REGITEM                                                            \n ");
			sb.append("				FROM   SEVGL    A                                                               \n ");
			sb.append("				      ,SEVVN    B                                                               \n ");
			sb.append("				WHERE  1=1                                                                      \n ");
			sb.append(sm.addFixString(" AND    A.SG_KIND   = ?                                                      \n "));	sm.addStringParameter(sg_kind);
			sb.append(sm.addFixString(" AND    A.EV_YEAR   = ?                                                      \n ")); sm.addStringParameter(ev_year);
			sb.append("				AND    A.USE_FLAG  = 'Y'                                                        \n ");
			sb.append("				AND    A.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.EV_NO     = B.EV_NO                                                    \n ");
			sb.append("				AND    A.EV_YEAR   = B.EV_YEAR                                                  \n ");
			sb.append("				AND    B.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.PERIOD    = 'P'                                                        \n ");
			//**변경**
			sb.append("				AND    A.SHEET_STATUS = 'ED'  													\n ");
			//*******
			sb.append("				AND    B.SG_REGITEM IN (                                                        \n ");
			sb.append("					   				    SELECT SG_REFITEM                                       \n ");
			sb.append("										FROM   SSGGL                                            \n ");
			sb.append("										WHERE LEVEL_COUNT         = '3'                         \n ");
			sb.append(sm.addFixString("						AND  PARENT_SG_REFITEM    =  ?                          \n ")); sm.addStringParameter(sg_kind_1);
			sb.append("										AND  NOTICE_FLAG          = 'Y'                         \n ");
			sb.append("										AND  DEL_FLAG             = 'N'                         \n ");
			sb.append("										AND  SUBSTR(ADD_DATE,1,4) = TO_CHAR(SYSDATE,'YYYY')     \n ");
			sb.append("				                       )                                                        \n ");
			sb.append("				GROUP BY A.EV_NO                                                                \n ");
			sb.append("				        ,A.EV_YEAR                                                              \n ");
			sb.append("						,B.SG_REGITEM                                                           \n ");
			sb.append("				ORDER BY EV_NO                                                                  \n ");			
			
			sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));
			
			for( int i = 0; i < sf.getRowCount(); i++ ){
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("				    SELECT  EV_SEQ															\n ");
				sb.append("				           ,EV_M_ITEM                                                       \n ");
				sb.append("				           ,EV_D_ITEM                                                       \n ");
				sb.append("				           ,GETEV_M_ITEMEXT1(EV_M_ITEM,EV_D_ITEM) AS EV_D_ITEM_NAME         \n ");
				sb.append("				    FROM    SEVLN                                                           \n ");
				sb.append("				    WHERE   1=1                                                             \n ");
				sb.append(sm.addFixString("	AND     EV_NO       = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append(sm.addFixString("	AND     EV_YEAR     = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("				    AND     DEL_FLAG    = 'N'                                               \n ");
				sb.append("				    ORDER BY  EV_SEQ                                                        \n ");
				sf1 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				sf3 = new SepoaFormater(sm.doSelect_limit(sb.toString()));

				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격')  AS  VN_STATUS									\n ");
				sb.append("		      ,ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total = new StringBuffer();
				for( int k = 0; k < 17; k++ ){
					//if( k != 16 ){
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}else{
					//	sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}
					total.append("A.SCORE" + k);
					if( k != 16 ){
						total.append("+");
					}
				}
				sb.append("			  ,(" + total.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 17; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf1.getRowCount(); k++ ){
						// 회사규모 >> 사업년수
						if( z == 0 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 회사규모 >> 매출규모
						else if( z == 1 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 재무상태 >> 부채비율
						else if( z == 2 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( z == 3 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 재무상태 >> 매출액영업이익율
						else if( z == 4 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 기술능력 >> 공장등록
						else if( z == 5 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> 인원현황
						else if( z == 6 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> 소유기구
						else if( z == 7 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row6") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf1.removeValue(k);
							break;	
						}
						// 기술능력 >> 기술보유
						else if( z == 8 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row7") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf1.removeValue(k);
							break;	
						}						
						// 이행실적 >> 당행
						else if( z == 9 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 이행실적 >> 기업체
						else if( z == 10 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 품질평가 >> 품질관리
						else if( z == 11 && sf1.getValue("EV_M_ITEM", k).equals("ev8") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 품질평가 >> 사후관리
						else if( z == 12 && sf1.getValue("EV_M_ITEM", k).equals("ev8") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}					
						// 당행기여도 >> RAR실적
						else if( z == 13 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 신용카드
						else if( z == 14 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 급여이체
						else if( z == 15 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 퇴직연금실적
						else if( z == 16 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append(sm.addFixString("		AND     EV_NO       = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append(sm.addFixString("		AND     EV_YEAR     = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				sb.append("		ORDER BY ROWNUM, VN_STATUS DESC                                                                 \n ");
				
				sf2 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				
				sm.removeAllValue();  // 평가시트 결과표 복사 (INSERT)
				sb.delete(0, sb.length());
				sb.append(" insert into SHEET_RESULT \n ");
				sb.append(" ( \n ");
				sb.append(" 	  ITEM_NAME        ,    \n ");
				sb.append(" 	  VN_STATUS        ,	\n ");
				sb.append(" 	  NO               ,	\n ");
				sb.append(" 	  VENDOR_NAME      ,	\n ");
				sb.append(" 	  DATA0            ,	\n ");
				sb.append(" 	  SCORE0       	   ,	\n ");
				sb.append("       DATA1            ,	 \n");
				sb.append("       SCORE1           ,	 \n");
				sb.append("       DATA2            ,	 \n");
				sb.append("       SCORE2	   ,	 \n");
				sb.append("       DATA3            ,	 \n");
				sb.append("       SCORE3           ,	 \n");
				sb.append("       DATA4            ,	 \n");
				sb.append("       SCORE4           ,	 \n");
				sb.append("       DATA5            ,	 \n");
				sb.append("       SCORE5           ,	 \n");
				sb.append("       DATA6            ,	 \n");
				sb.append("       SCORE6           ,	 \n");
				sb.append("       DATA7            ,	 \n");
				sb.append("       SCORE7           ,	 \n");
				sb.append("       DATA8            ,	 \n");
				sb.append("       SCORE8           ,	 \n");
				sb.append("       DATA9            ,	 \n");
				sb.append("       SCORE9           ,	 \n");
				sb.append("       DATA10           ,	 \n");
				sb.append("       SCORE10          ,	 \n");
				sb.append("       DATA11           ,	 \n");
				sb.append("       SCORE11          ,	 \n");
				sb.append("       DATA12           ,	 \n");
				sb.append("       SCORE12          ,	 \n");
				sb.append("       DATA13           ,	 \n");
				sb.append("       SCORE13          ,	 \n");
				sb.append("       DATA14           ,	 \n");
				sb.append("       SCORE14          ,	 \n");
				sb.append("        DATA15          ,	 \n");
				sb.append("       SCORE15          ,	 \n");
				sb.append("        DATA16          ,	 \n");
				sb.append("       SCORE16          ,	 \n");
			//	sb.append("        DATA17          ,	 \n");
			//	sb.append("       SCORE17          ,	 \n");
				sb.append("     TOTAL              ,	 \n");
				sb.append("     SCORE           ,	 \n");
				sb.append("     EV_NO              ,	 \n");
				sb.append("     EV_YEAR            ,	 \n");
				sb.append("     SELLER_CODE        ,	 \n");
				sb.append("     SELLER_NAME_LOC    ,	 \n");
				sb.append("     SG_REGITEM         	 \n");


				sb.append(" ) \n ");
				//sb.append(" values \n ");
				sb.append(" ( \n ");
				
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격')  AS  VN_STATUS									\n ");
				sb.append("		      ,"+i+"||ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total_1 = new StringBuffer();
				for( int k = 0; k < 17; k++ ){
					//if( k != 16 ){
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}else{
					//	sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}
					total_1.append("A.SCORE" + k);
					if( k != 16 ){
						total_1.append("+");
					}
				}
				sb.append("			  ,(" + total_1.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 17; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf3.getRowCount(); k++ ){
						// 회사규모 >> 사업년수
						if( z == 0 && sf3.getValue("EV_M_ITEM", k).equals("ev1") && sf3.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 회사규모 >> 매출규모
						else if( z == 1 && sf3.getValue("EV_M_ITEM", k).equals("ev1") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 재무상태 >> 부채비율
						else if( z == 2 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( z == 3 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 재무상태 >> 매출액영업이익율
						else if( z == 4 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 기술능력 >> 공장등록
						else if( z == 5 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 기술능력 >> 인원현황
						else if( z == 6 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 기술능력 >> 소유기구
						else if( z == 7 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row6") ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf3.removeValue(k);
							break;	
						}
						// 기술능력 >> 기술보유
						else if( z == 8 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row7") ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf3.removeValue(k);
							break;	
						}						
						// 이행실적 >> 당행
						else if( z == 9 && sf3.getValue("EV_M_ITEM", k).equals("ev4") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 이행실적 >> 기업체
						else if( z == 10 && sf3.getValue("EV_M_ITEM", k).equals("ev4") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 품질평가 >> 품질관리
						else if( z == 11 && sf3.getValue("EV_M_ITEM", k).equals("ev8") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 품질평가 >> 사후관리
						else if( z == 12 && sf3.getValue("EV_M_ITEM", k).equals("ev8") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}					
						// 당행기여도 >> RAR실적
						else if( z == 13 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 신용카드
						else if( z == 14 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 급여이체
						else if( z == 15 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 퇴직연금실적
						else if( z == 16 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE    END),0))          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append("		AND     EV_NO       = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append("		AND     EV_YEAR     = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				
				sb.append(" )	 \n ");
				sm.doInsert(sb.toString());	
				Commit();
				
				
				for ( int r = 0; r < sf2.getRowCount(); r++ )
	            {
					ArrayList ht = new ArrayList();
					//ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE"       , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_NO"          , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_YEAR"        , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_CODE"    , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_NAME_LOC", r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SG_REGITEM"     , r) ).trim() );	
					
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("ITEM_NAME"  , r) ).trim() );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VN_STATUS"  , r) ).trim() );
	            	ht.add( ""+(mapnum+1) );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VENDOR_NAME", r) ).trim() );
					for( int k = 0; k < 17; k++ ){
						//if( k != 16 ){
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("DATA"  + k, r) ).trim());
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE" + k, r) ).trim());
						//}else{
						//	ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE" + k, r) ).trim());
						//}
					}
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE"       , r) ).trim() );
					//ht.add(JSPUtil.nullToEmpty( sf2.getValue("TOTAL", r) ).trim() );
	            	arr_list.add(ht);
	            	mapnum++;
	            }//for~end		
			}
			setValue(arr_list);
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
		}

		return getSepoaOut();
	}

	public SepoaOut ev_query_206( String sg_kind, String sg_kind_1, String ev_year ) throws Exception{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb       = new StringBuffer();
			ParamSql sm           = new ParamSql(info.getSession("ID"), this, ctx);
			ArrayList arr_list    = new ArrayList();
			SepoaFormater sf      = null;
			SepoaFormater sf1     = null;
			SepoaFormater sf2     = null;
			SepoaFormater sf3     = null;
			int mapnum            = 0;
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("		DELETE FROM SHEET_RESULT																\n "); // 평가시트결과표 테이블 지우기
			sm.doDelete(sb.toString());
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("				SELECT  A.EV_YEAR																\n ");
			sb.append("				       ,A.EV_NO               													\n ");	
			sb.append("					   ,B.SG_REGITEM                                                            \n ");
			sb.append("				FROM   SEVGL    A                                                               \n ");
			sb.append("				      ,SEVVN    B                                                               \n ");
			sb.append("				WHERE  1=1                                                                      \n ");
			sb.append(sm.addFixString(" AND    A.SG_KIND   = ?                                                      \n "));	sm.addStringParameter(sg_kind);
			sb.append(sm.addFixString(" AND    A.EV_YEAR   = ?                                                      \n ")); sm.addStringParameter(ev_year);
			sb.append("				AND    A.USE_FLAG  = 'Y'                                                        \n ");
			sb.append("				AND    A.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.EV_NO     = B.EV_NO                                                    \n ");
			sb.append("				AND    A.EV_YEAR   = B.EV_YEAR                                                  \n ");
			sb.append("				AND    B.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.PERIOD    = 'P'                                                        \n ");
			//**변경**
			sb.append("				AND    A.SHEET_STATUS = 'ED'  													\n ");
			//*******
			sb.append("				AND    B.SG_REGITEM IN (                                                        \n ");
			sb.append("					   				    SELECT SG_REFITEM                                       \n ");
			sb.append("										FROM   SSGGL                                            \n ");
			sb.append("										WHERE LEVEL_COUNT         = '3'                         \n ");
			sb.append(sm.addFixString("						AND  PARENT_SG_REFITEM    =  ?                          \n ")); sm.addStringParameter(sg_kind_1);
			sb.append("										AND  NOTICE_FLAG          = 'Y'                         \n ");
			sb.append("										AND  DEL_FLAG             = 'N'                         \n ");
			sb.append("										AND  SUBSTR(ADD_DATE,1,4) = TO_CHAR(SYSDATE,'YYYY')     \n ");
			sb.append("				                       )                                                        \n ");
			sb.append("				GROUP BY A.EV_NO                                                                \n ");
			sb.append("				        ,A.EV_YEAR                                                              \n ");
			sb.append("						,B.SG_REGITEM                                                           \n ");
			sb.append("				ORDER BY EV_NO                                                                  \n ");			
			
			sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));
			
			for( int i = 0; i < sf.getRowCount(); i++ ){
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("				    SELECT  EV_SEQ															\n ");
				sb.append("				           ,EV_M_ITEM                                                       \n ");
				sb.append("				           ,EV_D_ITEM                                                       \n ");
				sb.append("				           ,GETEV_M_ITEMEXT1(EV_M_ITEM,EV_D_ITEM) AS EV_D_ITEM_NAME         \n ");
				sb.append("				    FROM    SEVLN                                                           \n ");
				sb.append("				    WHERE   1=1                                                             \n ");
				sb.append(sm.addFixString("	AND     EV_NO       = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append(sm.addFixString("	AND     EV_YEAR     = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("				    AND     DEL_FLAG    = 'N'                                               \n ");
				sb.append("				    ORDER BY  EV_SEQ                                                        \n ");
				sf1 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				sf3 = new SepoaFormater(sm.doSelect_limit(sb.toString()));

				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격')  AS  VN_STATUS									\n ");
				sb.append("		      ,ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total = new StringBuffer();
				for( int k = 0; k < 16; k++ ){
//					/if( k != 15 ){
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}else{
					//	sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}
					total.append("A.SCORE" + k);
					if( k != 15 ){
						total.append("+");
					}
				}
				sb.append("			  ,(" + total.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 16; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf1.getRowCount(); k++ ){
						// 회사규모 >> 자산규모
						if( z == 0 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row3") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}	
						// 회사규모 >> 매출규모
						else if( z == 1 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 회사규모 >> 사업년수
						if( z == 2 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}

						// 재무상태 >> 부채비율
						else if( z == 3 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( z == 4 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 재무상태 >> 매출액영업이익율
						else if( z == 5 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 기술능력 >> 공장등록
						else if( z == 6 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row8")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> 인원현황
						else if( z == 7 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> 기술보유
						else if( z == 8 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row7") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf1.removeValue(k);
							break;	
						}						
						// 이행실적 >> 당행
						else if( z == 9 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 이행실적 >> 금융권
						else if( z == 10 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 품질관리 >> A/S조직   //사후관리
						else if( z == 11 && sf1.getValue("EV_M_ITEM", k).equals("ev8") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 당행기여도 >> RAR실적
						else if( z == 12 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 신용카드
						else if( z == 13 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 급여이체
						else if( z == 14 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 퇴직연금실적
						else if( z == 15 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append(sm.addFixString("		AND     EV_NO       = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append(sm.addFixString("		AND     EV_YEAR     = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				sb.append("		ORDER BY ROWNUM, VN_STATUS DESC                                                                 \n ");
				
				sf2 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				
				sm.removeAllValue();  // 평가시트 결과표 복사 (INSERT)
				sb.delete(0, sb.length());
				sb.append(" insert into SHEET_RESULT \n ");
				sb.append(" ( \n ");
				sb.append(" 	  ITEM_NAME        ,    \n ");
				sb.append(" 	  VN_STATUS        ,	\n ");
				sb.append(" 	  NO               ,	\n ");
				sb.append(" 	  VENDOR_NAME      ,	\n ");
				sb.append(" 	  DATA0            ,	\n ");
				sb.append(" 	  SCORE0       	   ,	\n ");
				sb.append("       DATA1            ,	 \n");
				sb.append("       SCORE1           ,	 \n");
				sb.append("       DATA2            ,	 \n");
				sb.append("       SCORE2	   ,	 \n");
				sb.append("       DATA3            ,	 \n");
				sb.append("       SCORE3           ,	 \n");
				sb.append("       DATA4            ,	 \n");
				sb.append("       SCORE4           ,	 \n");
				sb.append("       DATA5            ,	 \n");
				sb.append("       SCORE5           ,	 \n");
				sb.append("       DATA6            ,	 \n");
				sb.append("       SCORE6           ,	 \n");
				sb.append("       DATA7            ,	 \n");
				sb.append("       SCORE7           ,	 \n");
				sb.append("       DATA8            ,	 \n");
				sb.append("       SCORE8           ,	 \n");
				sb.append("       DATA9            ,	 \n");
				sb.append("       SCORE9           ,	 \n");
				sb.append("       DATA10           ,	 \n");
				sb.append("       SCORE10          ,	 \n");
				sb.append("       DATA11           ,	 \n");
				sb.append("       SCORE11          ,	 \n");
				sb.append("       DATA12           ,	 \n");
				sb.append("       SCORE12          ,	 \n");
				sb.append("       DATA13           ,	 \n");
				sb.append("       SCORE13          ,	 \n");
				sb.append("       DATA14           ,	 \n");
				sb.append("       SCORE14          ,	 \n");
				sb.append("        DATA15          ,	 \n");
				sb.append("       SCORE15          ,	 \n");
			//	sb.append("        DATA16          ,	 \n");
			//	sb.append("       SCORE16          ,	 \n");
			//	sb.append("        DATA17          ,	 \n");
			//	sb.append("       SCORE17          ,	 \n");
				sb.append("     TOTAL              ,	 \n");
				sb.append("     SCORE           ,	 \n");
				sb.append("     EV_NO              ,	 \n");
				sb.append("     EV_YEAR            ,	 \n");
				sb.append("     SELLER_CODE        ,	 \n");
				sb.append("     SELLER_NAME_LOC    ,	 \n");
				sb.append("     SG_REGITEM         	 \n");


				sb.append(" ) \n ");
				//sb.append(" values \n ");
				sb.append(" ( \n ");
				
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격')  AS  VN_STATUS									\n ");
				sb.append("		      ,"+i+"||ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total_1 = new StringBuffer();
				for( int k = 0; k < 16; k++ ){
					//if( k != 15 ){
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}else{
					//	sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}
					total_1.append("A.SCORE" + k);
					if( k != 15 ){
						total_1.append("+");
					}
				}
				sb.append("			  ,(" + total_1.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 16; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf3.getRowCount(); k++ ){
						// 회사규모 >> 자산규모
						if( z == 0 && sf3.getValue("EV_M_ITEM", k).equals("ev1") && sf3.getValue("EV_D_ITEM", k).equals("row3") ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}	
						// 회사규모 >> 매출규모
						else if( z == 1 && sf3.getValue("EV_M_ITEM", k).equals("ev1") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 회사규모 >> 사업년수
						if( z == 2 && sf3.getValue("EV_M_ITEM", k).equals("ev1") && sf3.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}

						// 재무상태 >> 부채비율
						else if( z == 3 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( z == 4 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 재무상태 >> 매출액영업이익율
						else if( z == 5 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 기술능력 >> 공장등록
						else if( z == 6 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row8")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 기술능력 >> 인원현황
						else if( z == 7 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 기술능력 >> 기술보유
						else if( z == 8 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row7") ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf3.removeValue(k);
							break;	
						}						
						// 이행실적 >> 당행
						else if( z == 9 && sf3.getValue("EV_M_ITEM", k).equals("ev4") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 이행실적 >> 금융권
						else if( z == 10 && sf3.getValue("EV_M_ITEM", k).equals("ev4") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 품질관리 >> A/S조직   //사후관리
						else if( z == 11 && sf3.getValue("EV_M_ITEM", k).equals("ev8") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 당행기여도 >> RAR실적
						else if( z == 12 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 신용카드
						else if( z == 13 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 급여이체
						else if( z == 14 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 퇴직연금실적
						else if( z == 15 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE    END),0))          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append("		AND     EV_NO       = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append("		AND     EV_YEAR     = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				
				sb.append(" )	 \n ");
				sm.doInsert(sb.toString());	
				Commit();


				
				for ( int r = 0; r < sf2.getRowCount(); r++ )
	            {
					ArrayList ht = new ArrayList();
					
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_NO"          , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_YEAR"        , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_CODE"    , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_NAME_LOC", r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SG_REGITEM"     , r) ).trim() );	
					
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("ITEM_NAME"  , r) ).trim() );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VN_STATUS"  , r) ).trim() );
	            	ht.add( ""+(mapnum+1) );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VENDOR_NAME", r) ).trim() );
					for( int k = 0; k < 16; k++ ){
						//if( k != 15 ){
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("DATA"  + k, r) ).trim());
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE" + k, r) ).trim());
						//}else{
						//	ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE" + k, r) ).trim());
						//}
					}
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE"       , r) ).trim() );
					//ht.add(JSPUtil.nullToEmpty( sf2.getValue("TOTAL", r) ).trim() );
	            	arr_list.add(ht);
	            	mapnum++;
	            }//for~end		
			}
			setValue(arr_list);
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
		}

		return getSepoaOut();
	}
	
	public SepoaOut ev_query_207( String sg_kind, String sg_kind_1, String ev_year ) throws Exception{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb       = new StringBuffer();
			StringBuffer sb1      = new StringBuffer();
			StringBuffer sb2      = new StringBuffer();
			ParamSql sm           = new ParamSql(info.getSession("ID"), this, ctx);
			ArrayList arr_list    = new ArrayList();
			SepoaFormater sf      = null;
			SepoaFormater sf1     = null;
			SepoaFormater sf2     = null;
			SepoaFormater sf3     = null;
			int mapnum            = 0;
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("		DELETE FROM SHEET_RESULT																\n "); // 평가시트결과표 테이블 지우기
			sm.doDelete(sb.toString());
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("				SELECT  A.EV_YEAR																\n ");
			sb.append("				       ,A.EV_NO               													\n ");	
			sb.append("					   ,B.SG_REGITEM                                                            \n ");
			sb.append("				FROM   SEVGL    A                                                               \n ");
			sb.append("				      ,SEVVN    B                                                               \n ");
			sb.append("				WHERE  1=1                                                                      \n ");
			sb.append(sm.addFixString(" AND    A.SG_KIND   = ?                                                      \n "));	sm.addStringParameter(sg_kind);
			sb.append(sm.addFixString(" AND    A.EV_YEAR   = ?                                                      \n ")); sm.addStringParameter(ev_year);
			sb.append("				AND    A.USE_FLAG  = 'Y'                                                        \n ");
			sb.append("				AND    A.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.EV_NO     = B.EV_NO                                                    \n ");
			sb.append("				AND    A.EV_YEAR   = B.EV_YEAR                                                  \n ");
			sb.append("				AND    B.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.PERIOD    = 'P'                                                        \n ");
			//**변경**
			sb.append("				AND    A.SHEET_STATUS = 'ED'  													\n ");
			//*******
			sb.append("				AND    B.SG_REGITEM IN (                                                        \n ");
			sb.append("					   				    SELECT SG_REFITEM                                       \n ");
			sb.append("										FROM   SSGGL                                            \n ");
			sb.append("										WHERE LEVEL_COUNT         = '3'                         \n ");
			sb.append(sm.addFixString("						AND  PARENT_SG_REFITEM    =  ?                          \n ")); sm.addStringParameter(sg_kind_1);
			sb.append("										AND  NOTICE_FLAG          = 'Y'                         \n ");
			sb.append("										AND  DEL_FLAG             = 'N'                         \n ");
			sb.append("										AND  SUBSTR(ADD_DATE,1,4) = TO_CHAR(SYSDATE,'YYYY')     \n ");
			sb.append("				                       )                                                        \n ");
			sb.append("				GROUP BY A.EV_NO                                                                \n ");
			sb.append("				        ,A.EV_YEAR                                                              \n ");
			sb.append("						,B.SG_REGITEM                                                           \n ");
			sb.append("				ORDER BY EV_NO                                                                  \n ");			
			
			sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));
			
			for( int i = 0; i < sf.getRowCount(); i++ ){
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("				    SELECT  EV_SEQ															\n ");
				sb.append("				           ,EV_M_ITEM                                                       \n ");
				sb.append("				           ,EV_D_ITEM                                                       \n ");
				sb.append("				           ,GETEV_M_ITEMEXT1(EV_M_ITEM,EV_D_ITEM) AS EV_D_ITEM_NAME         \n ");
				sb.append("				    FROM    SEVLN                                                           \n ");
				sb.append("				    WHERE   1=1                                                             \n ");
				sb.append(sm.addFixString("	AND     EV_NO       = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append(sm.addFixString("	AND     EV_YEAR     = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("				    AND     DEL_FLAG    = 'N'                                               \n ");
				sb.append("				    ORDER BY  EV_SEQ                                                        \n ");
				sf1 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				sf3 = new SepoaFormater(sm.doSelect_limit(sb.toString()));

				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격')  AS  VN_STATUS									\n ");
				sb.append("		      ,ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total = new StringBuffer();
				for( int k = 0; k < 12; k++ ){
					//if( k != 11 ){
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}else{
					//	sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}
					total.append("A.SCORE" + k);
					if( k != 11 ){
						total.append("+");
					}
				}
				sb.append("			  ,(" + total.toString() + ")     AS TOTAL                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");
				
				// 기술능력 >> 생산시설 있는지 확인
				boolean m_bool = false;
				for( int k = 0; k < sf1.getRowCount(); k++ ){
					if( sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row4") ){
						m_bool = true;
						break;
					}
				}
				
				for( int z = 0; z < 12; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf1.getRowCount(); k++ ){
						if( !m_bool && z == 6 ){
							break;
						}
						
						// 회사규모 >> 사업년수
						if( z == 0 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 회사규모 >> 매출규모
						else if( z == 1 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 재무상태 >> 부채비율
						else if( z == 2 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( z == 3 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> 공장등록
						else if( z == 4 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row8")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> 인원현황
						else if( z == 5 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}	
						// 기술능력 >> 생산시설
						else if( sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row4") ){
							sb1.delete(0, sb1.length());
							sb2.delete(0, sb2.length());
							
							sb1.append("				  ,( NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0) ");
							sb2.append("				  ,( NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0) ");
							//sf1.removeValue(k);
						}
						// 기술능력 >> 생산시설(II)
						else if( sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row15") ){
							sb.append(sb1.toString() + " || NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0) )    AS DATA"  + z + "    \n ");
							sb.append(sb2.toString() + "+ NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)    )    AS SCORE" + z + "    \n ");
							chk     = 1;
							sf1.removeValue(k);
							break;							
						}
						// 이행실적 >> 기업체
						else if( z == 7 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 당행기여도 >> RAR실적
						else if( z == 8 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 신용카드
						else if( z == 9 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 급여이체
						else if( z == 10 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 퇴직연금실적
						else if( z == 11 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append(sm.addFixString("		AND     EV_NO       = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append(sm.addFixString("		AND     EV_YEAR     = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				sb.append("		ORDER BY ROWNUM, VN_STATUS DESC                                                                 \n ");
				
				sf2 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				
				sm.removeAllValue();  // 평가시트 결과표 복사 (INSERT)
				sb.delete(0, sb.length());
				sb.append(" insert into SHEET_RESULT \n ");
				sb.append(" ( \n ");
				sb.append(" 	  ITEM_NAME        ,    \n ");
				sb.append(" 	  VN_STATUS        ,	\n ");
				sb.append(" 	  NO               ,	\n ");
				sb.append(" 	  VENDOR_NAME      ,	\n ");
				sb.append(" 	  DATA0            ,	\n ");
				sb.append(" 	  SCORE0       	   ,	\n ");
				sb.append("       DATA1            ,	 \n");
				sb.append("       SCORE1           ,	 \n");
				sb.append("       DATA2            ,	 \n");
				sb.append("       SCORE2	   ,	 \n");
				sb.append("       DATA3            ,	 \n");
				sb.append("       SCORE3           ,	 \n");
				sb.append("       DATA4            ,	 \n");
				sb.append("       SCORE4           ,	 \n");
				sb.append("       DATA5            ,	 \n");
				sb.append("       SCORE5           ,	 \n");
				sb.append("       DATA6            ,	 \n");
				sb.append("       SCORE6           ,	 \n");
				sb.append("       DATA7            ,	 \n");
				sb.append("       SCORE7           ,	 \n");
				sb.append("       DATA8            ,	 \n");
				sb.append("       SCORE8           ,	 \n");
				sb.append("       DATA9            ,	 \n");
				sb.append("       SCORE9           ,	 \n");
				sb.append("       DATA10           ,	 \n");
				sb.append("       SCORE10          ,	 \n");
				sb.append("       DATA11           ,	 \n");
				sb.append("       SCORE11          ,	 \n");
			//	sb.append("       DATA12           ,	 \n");
			//	sb.append("       SCORE12          ,	 \n");
			//	sb.append("       DATA13           ,	 \n");
			//	sb.append("       SCORE13          ,	 \n");
			//	sb.append("       DATA14           ,	 \n");
			//	sb.append("       SCORE14          ,	 \n");
			//	sb.append("        DATA15          ,	 \n");
			//	sb.append("       SCORE15          ,	 \n");
			//	sb.append("        DATA16          ,	 \n");
			//	sb.append("       SCORE16          ,	 \n");
			//	sb.append("        DATA17          ,	 \n");
			//	sb.append("       SCORE17          ,	 \n");
				sb.append("     TOTAL              ,	 \n");
				sb.append("     SCORE           ,	 \n");
				sb.append("     EV_NO              ,	 \n");
				sb.append("     EV_YEAR            ,	 \n");
				sb.append("     SELLER_CODE        ,	 \n");
				sb.append("     SELLER_NAME_LOC    ,	 \n");
				sb.append("     SG_REGITEM         	 \n");


				sb.append(" ) \n ");
				//sb.append(" values \n ");
				sb.append(" ( \n ");
				
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격')  AS  VN_STATUS									\n ");
				sb.append("		      ,"+i+"||ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total_1 = new StringBuffer();
				for( int k = 0; k < 12; k++ ){
					//if( k != 11 ){
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}else{
					//	sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}
					total_1.append("A.SCORE" + k);
					if( k != 11 ){
						total_1.append("+");
					}
				}
				sb.append("			  ,(" + total_1.toString() + ")     AS TOTAL                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");
				
				// 기술능력 >> 생산시설 있는지 확인
				boolean m_bool_1 = false;
				for( int k = 0; k < sf3.getRowCount(); k++ ){
					if( sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row4") ){
						m_bool_1 = true;
						break;
					}
				}
				
				for( int z = 0; z < 12; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf3.getRowCount(); k++ ){
						if( !m_bool_1 && z == 6 ){
							break;
						}
						
						// 회사규모 >> 사업년수
						if( z == 0 && sf3.getValue("EV_M_ITEM", k).equals("ev1") && sf3.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 회사규모 >> 매출규모
						else if( z == 1 && sf3.getValue("EV_M_ITEM", k).equals("ev1") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 재무상태 >> 부채비율
						else if( z == 2 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( z == 3 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 기술능력 >> 공장등록
						else if( z == 4 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row8")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 기술능력 >> 인원현황
						else if( z == 5 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}	
						// 기술능력 >> 생산시설
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row4") ){
							sb1.delete(0, sb1.length());
							sb2.delete(0, sb2.length());
							
							sb1.append("				  ,TO_CHAR(( NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0) ");
							sb2.append("				  ,TO_CHAR(( NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0) ");
							//sf3.removeValue(k);
						}
						// 기술능력 >> 생산시설(II)
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row15") ){
							sb.append(sb1.toString() + "|| NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0) ))    AS DATA"  + z + "    \n ");
							sb.append(sb2.toString() + "+ NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)    ))    AS SCORE" + z + "    \n ");
							chk     = 1;
							sf3.removeValue(k);
							break;							
						}
						// 이행실적 >> 기업체
						else if( z == 7 && sf3.getValue("EV_M_ITEM", k).equals("ev4") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 당행기여도 >> RAR실적
						else if( z == 8 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 신용카드
						else if( z == 9 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 급여이체
						else if( z == 10 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 퇴직연금실적
						else if( z == 11 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE    END),0))          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append("		AND     EV_NO       = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append("		AND     EV_YEAR     = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				
				sb.append(" )	 \n ");
				sm.doInsert(sb.toString());	
				Commit();


				
				for ( int r = 0; r < sf2.getRowCount(); r++ )
	            {
					ArrayList ht = new ArrayList();
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_NO"          , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_YEAR"        , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_CODE"    , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_NAME_LOC", r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SG_REGITEM"     , r) ).trim() );
					
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("ITEM_NAME"  , r) ).trim() );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VN_STATUS"  , r) ).trim() );
	            	ht.add( ""+(mapnum+1) );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VENDOR_NAME", r) ).trim() );
					for( int k = 0; k < 12; k++ ){
						//if( k != 11 ){
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("DATA"  + k, r) ).trim());
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE" + k, r) ).trim());
						//}else{
						//	ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE" + k, r) ).trim());
						//}
					}
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE"       , r) ).trim() );
					//ht.add(JSPUtil.nullToEmpty( sf2.getValue("TOTAL"          , r) ).trim() );
	            	arr_list.add(ht);
	            	mapnum++;
	            }//for~end		
			}
			setValue(arr_list);
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
		}

		return getSepoaOut();
	}

	public SepoaOut ev_query_208( String sg_kind, String sg_kind_1, String ev_year ) throws Exception{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb       = new StringBuffer();
			StringBuffer sb1      = new StringBuffer();
			StringBuffer sb2      = new StringBuffer();
			StringBuffer sb3      = new StringBuffer();
			StringBuffer sb4      = new StringBuffer();
			ParamSql sm           = new ParamSql(info.getSession("ID"), this, ctx);
			ArrayList arr_list    = new ArrayList();
			SepoaFormater sf      = null;
			SepoaFormater sf1     = null;
			SepoaFormater sf2     = null;
			SepoaFormater sf3     = null;
			int mapnum            = 0;
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("		DELETE FROM SHEET_RESULT																\n "); // 평가시트결과표 테이블 지우기
			sm.doDelete(sb.toString());
			
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("				SELECT  A.EV_YEAR																\n ");
			sb.append("				       ,A.EV_NO               													\n ");	
			sb.append("					   ,B.SG_REGITEM                                                            \n ");
			sb.append("				FROM   SEVGL    A                                                               \n ");
			sb.append("				      ,SEVVN    B                                                               \n ");
			sb.append("				WHERE  1=1                                                                      \n ");
			sb.append(sm.addFixString(" AND    A.SG_KIND   = ?                                                      \n "));	sm.addStringParameter(sg_kind);
			sb.append(sm.addFixString(" AND    A.EV_YEAR   = ?                                                      \n ")); sm.addStringParameter(ev_year);
			sb.append("				AND    A.USE_FLAG  = 'Y'                                                        \n ");
			sb.append("				AND    A.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.EV_NO     = B.EV_NO                                                    \n ");
			sb.append("				AND    A.EV_YEAR   = B.EV_YEAR                                                  \n ");
			sb.append("				AND    B.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.PERIOD    = 'P'                                                        \n ");
			//**변경**
			sb.append("				AND    A.SHEET_STATUS = 'ED'  													\n ");
			//*******
			sb.append("				AND    B.SG_REGITEM IN (                                                        \n ");
			sb.append("					   				    SELECT SG_REFITEM                                       \n ");
			sb.append("										FROM   SSGGL                                            \n ");
			sb.append("										WHERE LEVEL_COUNT         = '3'                         \n ");
			sb.append("						                AND  PARENT_SG_REFITEM    IN (                          \n ");
			sb.append("							   				                          SELECT SG_REFITEM										\n ");
			sb.append("													                  FROM   SSGGL                                          \n ");
			sb.append("													                  WHERE LEVEL_COUNT         = '2'                       \n ");
			sb.append(sm.addFixString("									                  AND  PARENT_SG_REFITEM    = ?                         \n "));  sm.addStringParameter(sg_kind_1);
			sb.append("													                  AND  NOTICE_FLAG          = 'Y'                       \n ");
			sb.append("													                  AND  DEL_FLAG             = 'N'                       \n ");
			sb.append("													                  AND  SUBSTR(ADD_DATE,1,4) = TO_CHAR(SYSDATE,'YYYY')   \n ");
			sb.append("						                                             )                                                      \n ");
			sb.append("										AND  NOTICE_FLAG          = 'Y'                         \n ");
			sb.append("										AND  DEL_FLAG             = 'N'                         \n ");
			sb.append("										AND  SUBSTR(ADD_DATE,1,4) = TO_CHAR(SYSDATE,'YYYY')     \n ");
			sb.append("				                       )                                                        \n ");
			sb.append("				GROUP BY A.EV_NO                                                                \n ");
			sb.append("				        ,A.EV_YEAR                                                              \n ");
			sb.append("						,B.SG_REGITEM                                                           \n ");
			sb.append("				ORDER BY EV_NO                                                                  \n ");			
			
			sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));
			
			for( int i = 0; i < sf.getRowCount(); i++ ){
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("				    SELECT  EV_SEQ															\n ");
				sb.append("				           ,EV_M_ITEM                                                       \n ");
				sb.append("				           ,EV_D_ITEM                                                       \n ");
				sb.append("				           ,GETEV_M_ITEMEXT1(EV_M_ITEM,EV_D_ITEM) AS EV_D_ITEM_NAME         \n ");
				sb.append("				    FROM    SEVLN                                                           \n ");
				sb.append("				    WHERE   1=1                                                             \n ");
				sb.append(sm.addFixString("	AND     EV_NO       = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append(sm.addFixString("	AND     EV_YEAR     = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("				    AND     DEL_FLAG    = 'N'                                               \n ");
				sb.append("				    ORDER BY  EV_SEQ                                                        \n ");
				sf1 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				sf3 = new SepoaFormater(sm.doSelect_limit(sb.toString()));

				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total = new StringBuffer();
				
				
				
				// 수정
				for( int k = 0; k < 10; k++ ){
					if( k == 1 ){
						sb.append("		  ,DECODE(A.DATA" + k + ",'1','보유','미보유' ) AS DATA"  + k + "                       \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");						
					}
					else if( k == 3 ||  k == 8 ||  k == 9 ){
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					}
					else{
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					}
					
					total.append("A.SCORE" + k);
					if( k != 9 ){
						total.append("+");
					}
				}
				// END				
				
				sb.append("			  ,(" + total.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 10; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf1.getRowCount(); k++ ){
						// 기술능력 >> 사업년수
						if( z == 0 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row11") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}	
						// 기술능력 >> 특허인증
						else if( z == 1 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row12")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN ITEM_CHECK    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 기술능력 >> 기술인원
						if( z == 2 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row2") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> A/S공정(I)(20)
						else if( z == 3 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row13")  ){
							sb1.delete(0, sb1.length());
							sb1.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0) ");
						}
						// 기술능력 >> A/S공정(II)(20)
						else if( sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row14")  ){
							sb.append(sb1.toString() + " + NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)     AS SCORE"  + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 카드
						else if( z == 4 && sf1.getValue("EV_M_ITEM", k).equals("ev19") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 여수신  평잔
						else if( z == 5 && sf1.getValue("EV_M_ITEM", k).equals("ev19") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 당행기여도 >> 당행기여도(RAR )
						else if( z == 6 && sf1.getValue("EV_M_ITEM", k).equals("ev19") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
//						 당행기여도 >> 퇴직연금실적
						else if( z == 7 && sf1.getValue("EV_M_ITEM", k).equals("ev19") && sf1.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 실적(I)(20)
						else if( z == 8 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb2.delete(0, sb2.length());
							sb2.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0) ");
						}						
						// 실적(II)(20)
						else if( z == 8 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row5")  ){
							sb.append(sb2.toString() + " + NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						
						// 재무상태(I)(15)
						else if( z == 9 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row1") ){
							sb3.delete(0, sb3.length());
							sb3.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0) ");
						}
						// 재무상태(II)(15)
						else if( z == 9 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row2") ){
							sb4.delete(0, sb4.length());
							sb4.append(sb3.toString() + " + NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0) ");
						}
						// 재무상태(III)(15)
						else if( z == 9 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row3") ){
							sb.append(sb4.toString() + " + NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf1.removeValue(k);
							break;	
						}				
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("								,ITEM_CHECK  															\n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append(sm.addFixString("		AND     EV_NO       = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_NO"      , i) );
				sb.append(sm.addFixString("		AND     EV_YEAR     = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"    , i) );
				sb.append(sm.addFixString("     AND     SG_REGITEM  = ?                                                         \n ")); sm.addStringParameter( sf.getValue("SG_REGITEM" , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				sb.append("		ORDER BY ROWNUM, VN_STATUS DESC                                                                 \n ");
				
				sf2 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				
				sm.removeAllValue();  // 평가시트 결과표 복사 (INSERT)
				sb.delete(0, sb.length());
				sb.append(" insert into SHEET_RESULT \n ");
				sb.append(" ( \n ");
				sb.append(" 	  ITEM_NAME        ,    \n ");
			//	sb.append(" 	  VN_STATUS        ,	\n ");
				sb.append(" 	  NO               ,	\n ");
				sb.append(" 	  VENDOR_NAME      ,	\n ");
				sb.append(" 	  DATA0            ,	\n ");
				sb.append(" 	  SCORE0       	   ,	\n ");
				sb.append("       DATA1            ,	 \n");
				sb.append("       SCORE1           ,	 \n");
				sb.append("       DATA2            ,	 \n");
				sb.append("       SCORE2	   ,	 \n");
			//	sb.append("       DATA3            ,	 \n");
				sb.append("       SCORE3           ,	 \n");
				sb.append("       DATA4            ,	 \n");
				sb.append("       SCORE4           ,	 \n");
				sb.append("       DATA5            ,	 \n");
				sb.append("       SCORE5           ,	 \n");
				sb.append("       DATA6            ,	 \n");
				sb.append("       SCORE6           ,	 \n");
				sb.append("       DATA7            ,	 \n");
				sb.append("       SCORE7           ,	 \n");
			//	sb.append("       DATA8            ,	 \n");
				sb.append("       SCORE8           ,	 \n");
			//	sb.append("       DATA9            ,	 \n");
				sb.append("       SCORE9           ,	 \n");
			//	sb.append("       DATA10           ,	 \n");
			//	sb.append("       SCORE10          ,	 \n");
			//	sb.append("       DATA11           ,	 \n");
			//	sb.append("       SCORE11          ,	 \n");
			//	sb.append("       DATA12           ,	 \n");
			//	sb.append("       SCORE12          ,	 \n");
			//	sb.append("       DATA13           ,	 \n");
			//	sb.append("       SCORE13          ,	 \n");
			//	sb.append("       DATA14           ,	 \n");
			//	sb.append("       SCORE14          ,	 \n");
			//	sb.append("        DATA15          ,	 \n");
			//	sb.append("       SCORE15          ,	 \n");
			//	sb.append("        DATA16          ,	 \n");
			//	sb.append("       SCORE16          ,	 \n");
			//	sb.append("        DATA17          ,	 \n");
			//	sb.append("       SCORE17          ,	 \n");
				sb.append("     TOTAL              ,	 \n");
				sb.append("     SCORE           ,	 \n");
				sb.append("     EV_NO              ,	 \n");
				sb.append("     EV_YEAR            ,	 \n");
				sb.append("     SELLER_CODE        ,	 \n");
				sb.append("     SELLER_NAME_LOC    ,	 \n");
				sb.append("     SG_REGITEM         	 \n");


				sb.append(" ) \n ");
				//sb.append(" values \n ");
				sb.append(" ( \n ");
				
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,"+i+"||ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total_1 = new StringBuffer();
				
				
				
				// 수정
				for( int k = 0; k < 10; k++ ){
					if( k == 1 ){
						sb.append("		  ,DECODE(A.DATA" + k + ",'1','보유','미보유' ) AS DATA"  + k + "                       \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");						
					}
					else if( k == 3 ||  k == 8 ||  k == 9 ){
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					}
					else{
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					}
					
					total_1.append("A.SCORE" + k);
					if( k != 9 ){
						total_1.append("+");
					}
				}
				// END				
				
				sb.append("			  ,(" + total_1.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 10; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf3.getRowCount(); k++ ){
						// 기술능력 >> 사업년수
						if( z == 0 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row11") ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}	
						// 기술능력 >> 특허인증
						else if( z == 1 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row12")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN ITEM_CHECK    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 기술능력 >> 기술인원
						if( z == 2 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row2") ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 기술능력 >> A/S공정(I)(20)
						else if( z == 3 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row13")  ){
							sb1.delete(0, sb1.length());
							sb1.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE    END),0) ");
						}
						// 기술능력 >> A/S공정(II)(20)
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row14")  ){
							sb.append(sb1.toString() + " + NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE    END),0))     AS SCORE"  + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 카드
						else if( z == 4 && sf3.getValue("EV_M_ITEM", k).equals("ev19") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 여수신  평잔
						else if( z == 5 && sf3.getValue("EV_M_ITEM", k).equals("ev19") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 당행기여도 >> 당행기여도(RAR )
						else if( z == 6 && sf3.getValue("EV_M_ITEM", k).equals("ev19") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
//						 당행기여도 >> 퇴직연금실적
						else if( z == 7 && sf3.getValue("EV_M_ITEM", k).equals("ev19") && sf3.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0))     AS DATA"  + z + "    \n ");
							sb.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 실적(I)(20)
						else if( z == 8 && sf3.getValue("EV_M_ITEM", k).equals("ev4") && sf3.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb2.delete(0, sb2.length());
							sb2.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0) ");
						}						
						// 실적(II)(20)
						else if( z == 8 && sf3.getValue("EV_M_ITEM", k).equals("ev4") && sf3.getValue("EV_D_ITEM", k).equals("row5")  ){
							sb.append(sb2.toString() + " + NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						
						// 재무상태(I)(15)
						else if( z == 9 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row1") ){
							sb3.delete(0, sb3.length());
							sb3.append("				  ,TO_CHAR(NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0) ");
						}
						// 재무상태(II)(15)
						else if( z == 9 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row2") ){
							sb4.delete(0, sb4.length());
							sb4.append(sb3.toString() + " + NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0) ");
						}
						// 재무상태(III)(15)
						else if( z == 9 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row3") ){
							sb.append(sb4.toString() + " + NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0))     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf3.removeValue(k);
							break;	
						}				
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("								,ITEM_CHECK  															\n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append("		AND     EV_NO       = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_NO"      , i) );
				sb.append("		AND     EV_YEAR     = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_YEAR"    , i) );
				sb.append("     AND     SG_REGITEM  = ?                                                         \n "); sm.addStringParameter( sf.getValue("SG_REGITEM" , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
			
				
				sb.append(" )	 \n ");
				sm.doInsert(sb.toString());	
				Commit();

				
				// 수정
				for ( int r = 0; r < sf2.getRowCount(); r++ )
	            {
					ArrayList ht = new ArrayList();
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_NO"          , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_YEAR"        , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_CODE"    , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_NAME_LOC", r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SG_REGITEM"     , r) ).trim() );	
					
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("ITEM_NAME"  , r) ).trim() );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VENDOR_NAME", r) ).trim() );
					for( int k = 0; k < 10; k++ ){
						if( k == 3 || k == 8 || k == 9 ){
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE" + k, r) ).trim());
						}
						else{
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("DATA"  + k, r) ).trim());
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE" + k, r) ).trim());
						}
					}
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE"       , r) ).trim() );
					//ht.add(JSPUtil.nullToEmpty( sf2.getValue("TOTAL", r) ).trim() );
	            	arr_list.add(ht);
	            	mapnum++;
	            }//for~end	
				// END
				
				
				
				
			}
			setValue(arr_list);
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
		}

		return getSepoaOut();
	}
	
	public SepoaOut ev_query_209( String sg_kind, String sg_kind_1, String ev_year ) throws Exception{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb       = new StringBuffer();
			StringBuffer sb1      = new StringBuffer();
			StringBuffer sb2      = new StringBuffer();
			StringBuffer sb3      = new StringBuffer();
			StringBuffer sb4      = new StringBuffer();
			ParamSql sm           = new ParamSql(info.getSession("ID"), this, ctx);
			ArrayList arr_list    = new ArrayList();
			SepoaFormater sf      = null;
			SepoaFormater sf1     = null;
			SepoaFormater sf2     = null;
			SepoaFormater sf3     = null;
			int mapnum            = 0;
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("		DELETE FROM SHEET_RESULT																\n "); // 평가시트결과표 테이블 지우기
			sm.doDelete(sb.toString());
			
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("				SELECT  A.EV_YEAR																\n ");
			sb.append("				       ,A.EV_NO               													\n ");	
			sb.append("					   ,B.SG_REGITEM                                                            \n ");
			sb.append("				FROM   SEVGL    A                                                               \n ");
			sb.append("				      ,SEVVN    B                                                               \n ");
			sb.append("				WHERE  1=1                                                                      \n ");
			sb.append(sm.addFixString(" AND    A.SG_KIND   = ?                                                      \n "));	sm.addStringParameter(sg_kind);
			sb.append(sm.addFixString(" AND    A.EV_YEAR   = ?                                                      \n ")); sm.addStringParameter(ev_year);
			sb.append("				AND    A.USE_FLAG  = 'Y'                                                        \n ");
			sb.append("				AND    A.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.EV_NO     = B.EV_NO                                                    \n ");
			sb.append("				AND    A.EV_YEAR   = B.EV_YEAR                                                  \n ");
			sb.append("				AND    B.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.PERIOD    = 'P'                                                        \n ");
			//**변경**
			sb.append("				AND    A.SHEET_STATUS = 'ED'  													\n ");
			//*******
			sb.append("				AND    B.SG_REGITEM IN (                                                        \n ");
			sb.append("					   				    SELECT SG_REFITEM                                       \n ");
			sb.append("										FROM   SSGGL                                            \n ");
			sb.append("										WHERE LEVEL_COUNT         = '3'                         \n ");
			sb.append("						                AND  PARENT_SG_REFITEM    IN (                          \n ");
			sb.append("							   				                          SELECT SG_REFITEM										\n ");
			sb.append("													                  FROM   SSGGL                                          \n ");
			sb.append("													                  WHERE LEVEL_COUNT         = '2'                       \n ");
			sb.append(sm.addFixString("									                  AND  PARENT_SG_REFITEM    = ?                         \n "));  sm.addStringParameter(sg_kind_1);
			sb.append("													                  AND  NOTICE_FLAG          = 'Y'                       \n ");
			sb.append("													                  AND  DEL_FLAG             = 'N'                       \n ");
			sb.append("													                  AND  SUBSTR(ADD_DATE,1,4) = TO_CHAR(SYSDATE,'YYYY')   \n ");
			sb.append("						                                             )                                                      \n ");
			sb.append("										AND  NOTICE_FLAG          = 'Y'                         \n ");
			sb.append("										AND  DEL_FLAG             = 'N'                         \n ");
			sb.append("										AND  SUBSTR(ADD_DATE,1,4) = TO_CHAR(SYSDATE,'YYYY')     \n ");
			sb.append("				                       )                                                        \n ");
			sb.append("				GROUP BY A.EV_NO                                                                \n ");
			sb.append("				        ,A.EV_YEAR                                                              \n ");
			sb.append("						,B.SG_REGITEM                                                           \n ");
			sb.append("				ORDER BY EV_NO                                                                  \n ");			
			
			sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));
			
			for( int i = 0; i < sf.getRowCount(); i++ ){
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("				    SELECT  EV_SEQ															\n ");
				sb.append("				           ,EV_M_ITEM                                                       \n ");
				sb.append("				           ,EV_D_ITEM                                                       \n ");
				sb.append("				           ,GETEV_M_ITEMEXT1(EV_M_ITEM,EV_D_ITEM) AS EV_D_ITEM_NAME         \n ");
				sb.append("				    FROM    SEVLN                                                           \n ");
				sb.append("				    WHERE   1=1                                                             \n ");
				sb.append(sm.addFixString("	AND     EV_NO       = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append(sm.addFixString("	AND     EV_YEAR     = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("				    AND     DEL_FLAG    = 'N'                                               \n ");
				sb.append("				    ORDER BY  EV_SEQ                                                        \n ");
				sf1 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				sf3 = new SepoaFormater(sm.doSelect_limit(sb.toString()));

				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total = new StringBuffer();
				
				
				
				// 수정
				for( int k = 0; k < 9; k++ ){
					if( k == 1 ){
						sb.append("		  ,A.AVG_SCORE                                                                         \n ");
						sb.append("		  ,A.SUM_SCORE	                                                                       \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					}else if(k == 8){
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					}
					else{
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					}
					total.append("A.SCORE" + k);
					if( k != 8 ){
						total.append("+");
					}
				}
				// END				
				
				sb.append("			  ,(" + total.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 9; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf1.getRowCount(); k++ ){
						// 시공능력 평가액 >> 시공능력 평가액
						if( z == 0 && sf1.getValue("EV_M_ITEM", k).equals("ev10") && sf1.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}	
						// 기술평가 >> 기술평가
						else if( z == 1 && sf1.getValue("EV_M_ITEM", k).equals("ev11") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN AVG_EV_NO_SCORE    END),0)     AS AVG_SCORE    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SUM_EV_NO_SCORE    END),0)     AS SUM_SCORE    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 금융권실적 >> 금융권실적
						if( z == 2 && sf1.getValue("EV_M_ITEM", k).equals("ev20") && sf1.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행 실거래기간 >> 당행실거래기간
						else if( z == 3 && sf1.getValue("EV_M_ITEM", k).equals("ev13") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 거래실적 >> 카드사용액
						else if( z == 4 && sf1.getValue("EV_M_ITEM", k).equals("ev14") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 거래실적 >> 여수신  평잔
						else if( z == 5 && sf1.getValue("EV_M_ITEM", k).equals("ev14") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 거래실적 >> 당행기여도(RAR )
						else if( z == 6 && sf1.getValue("EV_M_ITEM", k).equals("ev14") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						 //거래실적 >> 퇴직연금실적
						else if( z == 7 && sf1.getValue("EV_M_ITEM", k).equals("ev14") && sf1.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 감점 >> 하자
						else if( z == 8 && sf1.getValue("EV_M_ITEM", k).equals("ev15") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0) AS SCORE" + z + "   \n");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("								,ITEM_CHECK  															\n ");
				sb.append("								,AVG_EV_NO_SCORE  															\n ");
				sb.append("								,SUM_EV_NO_SCORE  															\n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append(sm.addFixString("		AND     EV_NO       = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_NO"      , i) );
				sb.append(sm.addFixString("		AND     EV_YEAR     = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"    , i) );
				sb.append(sm.addFixString("     AND     SG_REGITEM  = ?                                                         \n ")); sm.addStringParameter( sf.getValue("SG_REGITEM" , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				sb.append("		ORDER BY ROWNUM, VN_STATUS DESC                                                                 \n ");
				
				sf2 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				
				sm.removeAllValue();  // 평가시트 결과표 복사 (INSERT)
				sb.delete(0, sb.length());
				sb.append(" insert into SHEET_RESULT \n ");
				sb.append(" ( \n ");
				sb.append(" 	  ITEM_NAME        ,    \n ");
			//	sb.append(" 	  VN_STATUS        ,	\n ");
				sb.append(" 	  NO               ,	\n ");
				sb.append(" 	  VENDOR_NAME      ,	\n ");
				sb.append(" 	  DATA0            ,	\n ");
				sb.append(" 	  SCORE0       	   ,	\n ");
				sb.append("       AVG_SCORE        ,	 \n");
				sb.append("       SUM_SCORE        ,	 \n");
				sb.append("       SCORE1           ,	 \n");
				sb.append("       DATA2            ,	 \n");
				sb.append("       SCORE2		   ,	 \n");
				sb.append("       DATA3            ,	 \n");
				sb.append("       SCORE3           ,	 \n");
				sb.append("       DATA4            ,	 \n");
				sb.append("       SCORE4           ,	 \n");
				sb.append("       DATA5            ,	 \n");
				sb.append("       SCORE5           ,	 \n");
				sb.append("       DATA6            ,	 \n");
				sb.append("       SCORE6           ,	 \n");
				sb.append("       DATA7            ,	 \n");
				sb.append("       SCORE7           ,	 \n");
			//	sb.append("       DATA8            ,	 \n");
				sb.append("       SCORE8           ,	 \n");
			//	sb.append("       DATA9            ,	 \n");
			//	sb.append("       SCORE9           ,	 \n");
			//	sb.append("       DATA10           ,	 \n");
			//	sb.append("       SCORE10          ,	 \n");
			//	sb.append("       DATA11           ,	 \n");
			//	sb.append("       SCORE11          ,	 \n");
			//	sb.append("       DATA12           ,	 \n");
			//	sb.append("       SCORE12          ,	 \n");
			//	sb.append("       DATA13           ,	 \n");
			//	sb.append("       SCORE13          ,	 \n");
			//	sb.append("       DATA14           ,	 \n");
			//	sb.append("       SCORE14          ,	 \n");
			//	sb.append("        DATA15          ,	 \n");
			//	sb.append("       SCORE15          ,	 \n");
			//	sb.append("        DATA16          ,	 \n");
			//	sb.append("       SCORE16          ,	 \n");
			//	sb.append("        DATA17          ,	 \n");
			//	sb.append("       SCORE17          ,	 \n");
				sb.append("     TOTAL              ,	 \n");
				sb.append("     SCORE              ,	 \n");
				sb.append("     EV_NO              ,	 \n");
				sb.append("     EV_YEAR            ,	 \n");
				sb.append("     SELLER_CODE        ,	 \n");
				sb.append("     SELLER_NAME_LOC    ,	 \n");
				sb.append("     SG_REGITEM         	 \n");


				sb.append(" ) \n ");
				//sb.append(" values \n ");
				sb.append(" ( \n ");
				
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,"+i+"||ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total_1 = new StringBuffer();
				
				
				
//				 수정
				for( int k = 0; k < 9; k++ ){
					if( k == 1 ){
						sb.append("		  ,A.AVG_SCORE                                                                         \n ");
						sb.append("		  ,A.SUM_SCORE	                                                                       \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					}else if(k == 8){
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					}
					else{
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					}
					
					total_1.append("A.SCORE" + k);
					if( k != 8 ){
						total_1.append("+");
					}
				}
				// END			
				
				sb.append("			  ,(" + total_1.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 9; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf3.getRowCount(); k++ ){
						// 시공능력 평가액 >> 시공능력 평가액
						if( z == 0 && sf3.getValue("EV_M_ITEM", k).equals("ev10") && sf3.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}	
						// 기술평가 >> 기술평가
						else if( z == 1 && sf3.getValue("EV_M_ITEM", k).equals("ev11") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN AVG_EV_NO_SCORE    END),0)     AS AVG_SCORE    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SUM_EV_NO_SCORE    END),0)     AS SUM_SCORE    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 금융권실적 >> 금융권실적
						if( z == 2 && sf3.getValue("EV_M_ITEM", k).equals("ev20") && sf3.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행 실거래기간 >> 당행실거래기간
						else if( z == 3 && sf3.getValue("EV_M_ITEM", k).equals("ev13") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 거래실적 >> 카드사용액
						else if( z == 4 && sf3.getValue("EV_M_ITEM", k).equals("ev14") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 거래실적 >> 여수신  평잔
						else if( z == 5 && sf3.getValue("EV_M_ITEM", k).equals("ev14") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 거래실적 >> 당행기여도(RAR )
						else if( z == 6 && sf3.getValue("EV_M_ITEM", k).equals("ev14") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						 //거래실적 >> 퇴직연금실적
						else if( z == 7 && sf3.getValue("EV_M_ITEM", k).equals("ev14") && sf3.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 감점 >> 하자
						else if( z == 8 && sf3.getValue("EV_M_ITEM", k).equals("ev15") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0) AS SCORE" + z + " \n");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("								,ITEM_CHECK  															\n ");
				sb.append("								,AVG_EV_NO_SCORE  															\n ");
				sb.append("								,SUM_EV_NO_SCORE  															\n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append("		AND     EV_NO       = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_NO"      , i) );
				sb.append("		AND     EV_YEAR     = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_YEAR"    , i) );
				sb.append("     AND     SG_REGITEM  = ?                                                         \n "); sm.addStringParameter( sf.getValue("SG_REGITEM" , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				
				sb.append(" )	 \n ");
				sm.doInsert(sb.toString());	
				Commit();

				
				// 수정
				for ( int r = 0; r < sf2.getRowCount(); r++ )
	            {
					ArrayList ht = new ArrayList();
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_NO"          , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_YEAR"        , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_CODE"    , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_NAME_LOC", r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SG_REGITEM"     , r) ).trim() );	
					
	            	ht.add( ""+(mapnum+1) );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("ITEM_NAME"  , r) ).trim() );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VENDOR_NAME", r) ).trim() );
					for( int k = 0; k < 9; k++ ){
						if( k == 1){
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("AVG_SCORE", r) ).trim());
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("SUM_SCORE", r) ).trim());
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE" + k, r) ).trim());
						}else if(k == 8){
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE"  + k, r) ).trim());
						}
						else{
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("DATA"  + k, r) ).trim());
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE" + k, r) ).trim());
						}
						
					}
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE"       , r) ).trim() );
					//ht.add(JSPUtil.nullToEmpty( sf2.getValue("TOTAL", r) ).trim() );
	            	arr_list.add(ht);
	            	mapnum++;
	            }//for~end	
				// END
				
				
				
				
			}
			setValue(arr_list);
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
		}

		return getSepoaOut();
	}
	
	public SepoaOut ev_query_210( String sg_kind, String sg_kind_1, String sg_kind_2, String ev_year ) throws Exception{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb       = new StringBuffer();
			StringBuffer sb1      = new StringBuffer();
			StringBuffer sb2      = new StringBuffer();
			StringBuffer sb3      = new StringBuffer();
			StringBuffer sb4      = new StringBuffer();
			ParamSql sm           = new ParamSql(info.getSession("ID"), this, ctx);
			ArrayList arr_list    = new ArrayList();
			SepoaFormater sf      = null;
			SepoaFormater sf1     = null;
			SepoaFormater sf2     = null;
			SepoaFormater sf3     = null;
			int mapnum            = 0;
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("		DELETE FROM SHEET_RESULT																\n "); // 평가시트결과표 테이블 지우기
			sm.doDelete(sb.toString());
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("				SELECT  A.EV_YEAR																\n ");
			sb.append("				       ,A.EV_NO               													\n ");	
			sb.append("					   ,B.SG_REGITEM                                                            \n ");
			sb.append("				FROM   SEVGL    A                                                               \n ");
			sb.append("				      ,SEVVN    B                                                               \n ");
			sb.append("				WHERE  1=1                                                                      \n ");
			sb.append(sm.addFixString(" AND    A.SG_KIND   = ?                                                      \n "));	sm.addStringParameter(sg_kind);
			sb.append(sm.addFixString(" AND    A.EV_YEAR   = ?                                                      \n ")); sm.addStringParameter(ev_year);
			sb.append("				AND    A.USE_FLAG  = 'Y'                                                        \n ");
			sb.append("				AND    A.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.EV_NO     = B.EV_NO                                                    \n ");
			sb.append("				AND    A.EV_YEAR   = B.EV_YEAR                                                  \n ");
			sb.append("				AND    B.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.PERIOD    = 'P'                                                        \n ");
			//**변경**
			sb.append("				AND    A.SHEET_STATUS = 'ED'  													\n ");
			//*******
			sb.append(sm.addFixString("	AND    B.SG_REGITEM = ?                                         		    \n ")); sm.addStringParameter(sg_kind_2);
			sb.append("				GROUP BY A.EV_NO                                                                \n ");
			sb.append("				        ,A.EV_YEAR                                                              \n ");
			sb.append("						,B.SG_REGITEM                                                           \n ");
			sb.append("				ORDER BY EV_NO                                                                  \n ");			
			
			sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));			
			
			for( int i = 0; i < sf.getRowCount(); i++ ){
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("				    SELECT  EV_SEQ															\n ");
				sb.append("				           ,EV_M_ITEM                                                       \n ");
				sb.append("				           ,EV_D_ITEM                                                       \n ");
				sb.append("				           ,GETEV_M_ITEMEXT1(EV_M_ITEM,EV_D_ITEM) AS EV_D_ITEM_NAME         \n ");
				sb.append("				    FROM    SEVLN                                                           \n ");
				sb.append("				    WHERE   1=1                                                             \n ");
				sb.append(sm.addFixString("	AND     EV_NO       = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append(sm.addFixString("	AND     EV_YEAR     = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("				    AND     DEL_FLAG    = 'N'                                               \n ");
				sb.append("				    ORDER BY  EV_SEQ                                                        \n ");
				sf1 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				sf3 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격')  AS  VN_STATUS									\n ");
				sb.append("		      ,ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total = new StringBuffer();
				
				// 수정
				for( int k = 0; k < 17; k++ ){
					//if( k != 14 ){
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}else{
					//	sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}
					total.append("A.SCORE" + k);
					if( k != 16 ){
						total.append("+");
					}
				}
				// END				
				
				sb.append("			  ,(" + total.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 17; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf1.getRowCount(); k++ ){
						// 회사규모 >> 사업년수
						if( z == 0 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 회사규모 >> 매출규모
						else if( z == 1 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 재무상태 >> 부채비율
						else if( z == 2 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( z == 3 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 재무상태 >> 매출액영업이익율
						else if( z == 4 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 기술능력 >> 공장등록
						else if( z == 5 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row10")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> 인원현황
						else if( z == 6 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> 생산직접시설물 보유현황
						else if( z == 7 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row4") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf1.removeValue(k);
							break;	
						}
						// 기술능력 >> 조합가입여부
						else if( z == 8 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row5")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 이행실적 >> 계약목적물과 동등이상 물품
						else if( z == 9 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 이행실적 >> 계약목적물과 동등이상 물품(II)
						else if( z == 10 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}					
						// 품질평가 >> 품질관리
						else if( z == 11 && sf1.getValue("EV_M_ITEM", k).equals("ev8") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 품질평가 >> 사후관리
						else if( z == 12 && sf1.getValue("EV_M_ITEM", k).equals("ev8") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> RAR실적
						else if( z == 13 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 법인신용카드 실적
						else if( z == 14 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 종업원급여이체 실적
						else if( z == 15 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 당행기여도 >> 퇴직연금실적
						else if( z == 16 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("								,ITEM_CHECK  															\n ");
				sb.append("								,AVG_EV_NO_SCORE  															\n ");
				sb.append("								,SUM_EV_NO_SCORE  															\n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append(sm.addFixString("		AND     EV_NO       = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_NO"      , i) );
				sb.append(sm.addFixString("		AND     EV_YEAR     = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"    , i) );
				sb.append(sm.addFixString("     AND     SG_REGITEM  = ?                                                         \n ")); sm.addStringParameter( sf.getValue("SG_REGITEM" , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				sb.append("		ORDER BY ROWNUM, VN_STATUS DESC                                                                 \n ");
				
				sf2 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				
				sm.removeAllValue();  // 평가시트 결과표 복사 (INSERT)
				sb.delete(0, sb.length());
				sb.append(" insert into SHEET_RESULT \n ");
				sb.append(" ( \n ");
				sb.append(" 	  ITEM_NAME        ,    \n ");
				sb.append(" 	  VN_STATUS        ,	\n ");
				sb.append(" 	  NO               ,	\n ");
				sb.append(" 	  VENDOR_NAME      ,	\n ");
				sb.append(" 	  DATA0            ,	\n ");
				sb.append(" 	  SCORE0       	   ,	\n ");
				sb.append("       DATA1            ,	 \n");
				sb.append("       SCORE1           ,	 \n");
				sb.append("       DATA2            ,	 \n");
				sb.append("       SCORE2	   ,	 \n");
				sb.append("       DATA3            ,	 \n");
				sb.append("       SCORE3           ,	 \n");
				sb.append("       DATA4            ,	 \n");
				sb.append("       SCORE4           ,	 \n");
				sb.append("       DATA5            ,	 \n");
				sb.append("       SCORE5           ,	 \n");
				sb.append("       DATA6            ,	 \n");
				sb.append("       SCORE6           ,	 \n");
				sb.append("       DATA7            ,	 \n");
				sb.append("       SCORE7           ,	 \n");
				sb.append("       DATA8            ,	 \n");
				sb.append("       SCORE8           ,	 \n");
				sb.append("       DATA9            ,	 \n");
				sb.append("       SCORE9           ,	 \n");
				sb.append("       DATA10           ,	 \n");
				sb.append("       SCORE10          ,	 \n");
				sb.append("       DATA11           ,	 \n");
				sb.append("       SCORE11          ,	 \n");
				sb.append("       DATA12           ,	 \n");
				sb.append("       SCORE12          ,	 \n");
				sb.append("       DATA13           ,	 \n");
				sb.append("       SCORE13          ,	 \n");
				sb.append("       DATA14           ,	 \n");
				sb.append("       SCORE14          ,	 \n");
				sb.append("        DATA15          ,	 \n");
				sb.append("       SCORE15          ,	 \n");
				sb.append("        DATA16          ,	 \n");
				sb.append("       SCORE16          ,	 \n");
			//	sb.append("        DATA17          ,	 \n");
			//	sb.append("       SCORE17          ,	 \n");
				sb.append("     TOTAL              ,	 \n");
				sb.append("     SCORE           ,	 \n");
				sb.append("     EV_NO              ,	 \n");
				sb.append("     EV_YEAR            ,	 \n");
				sb.append("     SELLER_CODE        ,	 \n");
				sb.append("     SELLER_NAME_LOC    ,	 \n");
				sb.append("     SG_REGITEM         	 \n");


				sb.append(" ) \n ");
				//sb.append(" values \n ");
				sb.append(" ( \n ");

				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격') AS  VN_STATUS									\n ");
				sb.append("		      ,ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total_1 = new StringBuffer();
				
				// 수정
				for( int k = 0; k < 17; k++ ){
					//if( k != 14 ){
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}else{
					//	sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}
					total_1.append("A.SCORE" + k);
					if( k != 16 ){
						total_1.append("+");
					}
				}
				// END				
				
				sb.append("			  ,(" + total_1.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 17; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf3.getRowCount(); k++ ){
						// 회사규모 >> 사업년수
						if( z == 0 && sf3.getValue("EV_M_ITEM", k).equals("ev1") && sf3.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 회사규모 >> 매출규모
						else if( z == 1 && sf3.getValue("EV_M_ITEM", k).equals("ev1") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 재무상태 >> 부채비율
						else if( z == 2 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( z == 3 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 재무상태 >> 매출액영업이익율
						else if( z == 4 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 기술능력 >> 공장등록
						else if( z == 5 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row10")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 기술능력 >> 인원현황
						else if( z == 6 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 기술능력 >> 생산직접시설물 보유현황
						else if( z == 7 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row4") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf3.removeValue(k);
							break;	
						}
						// 기술능력 >> 조합가입여부
						else if( z == 8 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row5")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 이행실적 >> 계약목적물과 동등이상 물품
						else if( z == 9 && sf3.getValue("EV_M_ITEM", k).equals("ev4") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 이행실적 >> 계약목적물과 동등이상 물품(II)
						else if( z == 10 && sf3.getValue("EV_M_ITEM", k).equals("ev4") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}					
						// 품질평가 >> 품질관리
						else if( z == 11 && sf3.getValue("EV_M_ITEM", k).equals("ev8") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 품질평가 >> 사후관리
						else if( z == 12 && sf3.getValue("EV_M_ITEM", k).equals("ev8") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> RAR실적
						else if( z == 13 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 법인신용카드 실적
						else if( z == 14 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 종업원급여이체 실적
						else if( z == 15 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 당행기여도 >> 퇴직연금실적
						else if( z == 16 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("								,ITEM_CHECK  															\n ");
				sb.append("								,AVG_EV_NO_SCORE  															\n ");
				sb.append("								,SUM_EV_NO_SCORE  															\n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append("						AND     EV_NO       = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_NO"      , i) );
				sb.append("						AND     EV_YEAR     = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_YEAR"    , i) );
				sb.append("     				AND     SG_REGITEM  = ?                                                         \n "); sm.addStringParameter( sf.getValue("SG_REGITEM" , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				
				sb.append(" )	 \n ");
				sm.doInsert( sb.toString() );	
				Commit();				
				
				for ( int r = 0; r < sf2.getRowCount(); r++ )
	            {
					ArrayList ht = new ArrayList();
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_NO"          , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_YEAR"        , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_CODE"    , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_NAME_LOC", r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SG_REGITEM"     , r) ).trim() );	
					
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("ITEM_NAME"  , r) ).trim() );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VN_STATUS"  , r) ).trim() );
	            	ht.add( ""+(mapnum+1) );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VENDOR_NAME", r) ).trim() );
					for( int k = 0; k < 17; k++ ){
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("DATA"  + k, r) ).trim());
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE" + k, r) ).trim());
					}
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE"       , r) ).trim() );
					//ht.add(JSPUtil.nullToEmpty( sf2.getValue("TOTAL", r) ).trim() );
	            	arr_list.add(ht);
	            	mapnum++;
	            }//for~end		
			}
			setValue(arr_list);				
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
		}

		return getSepoaOut();
	}
	
	public SepoaOut ev_query_211( String sg_kind, String sg_kind_1, String sg_kind_2, String ev_year ) throws Exception{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb       = new StringBuffer();
			StringBuffer sb1      = new StringBuffer();
			StringBuffer sb2      = new StringBuffer();
			StringBuffer sb3      = new StringBuffer();
			StringBuffer sb4      = new StringBuffer();
			ParamSql sm           = new ParamSql(info.getSession("ID"), this, ctx);
			ArrayList arr_list    = new ArrayList();
			SepoaFormater sf      = null;
			SepoaFormater sf1     = null;
			SepoaFormater sf2     = null;
			SepoaFormater sf3     = null;
			int mapnum            = 0;
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("		DELETE FROM SHEET_RESULT																\n "); // 평가시트결과표 테이블 지우기
			sm.doDelete(sb.toString());
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("				SELECT  A.EV_YEAR																\n ");
			sb.append("				       ,A.EV_NO               													\n ");	
			sb.append("					   ,B.SG_REGITEM                                                            \n ");
			sb.append("				FROM   SEVGL    A                                                               \n ");
			sb.append("				      ,SEVVN    B                                                               \n ");
			sb.append("				WHERE  1=1                                                                      \n ");
			sb.append(sm.addFixString(" AND    A.SG_KIND   = ?                                                      \n "));	sm.addStringParameter(sg_kind);
			sb.append(sm.addFixString(" AND    A.EV_YEAR   = ?                                                      \n ")); sm.addStringParameter(ev_year);
			sb.append("				AND    A.USE_FLAG  = 'Y'                                                        \n ");
			sb.append("				AND    A.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.EV_NO     = B.EV_NO                                                    \n ");
			sb.append("				AND    A.EV_YEAR   = B.EV_YEAR                                                  \n ");
			sb.append("				AND    B.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.PERIOD    = 'P'                                                        \n ");
			//**변경**
			sb.append("				AND    A.SHEET_STATUS = 'ED'  													\n ");
			//*******
			sb.append(sm.addFixString("	AND    B.SG_REGITEM = ?                                         		    \n ")); sm.addStringParameter(sg_kind_2);
			sb.append("				GROUP BY A.EV_NO                                                                \n ");
			sb.append("				        ,A.EV_YEAR                                                              \n ");
			sb.append("						,B.SG_REGITEM                                                           \n ");
			sb.append("				ORDER BY EV_NO                                                                  \n ");			
			
			sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));			
			
			for( int i = 0; i < sf.getRowCount(); i++ ){
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("				    SELECT  EV_SEQ															\n ");
				sb.append("				           ,EV_M_ITEM                                                       \n ");
				sb.append("				           ,EV_D_ITEM                                                       \n ");
				sb.append("				           ,GETEV_M_ITEMEXT1(EV_M_ITEM,EV_D_ITEM) AS EV_D_ITEM_NAME         \n ");
				sb.append("				    FROM    SEVLN                                                           \n ");
				sb.append("				    WHERE   1=1                                                             \n ");
				sb.append(sm.addFixString("	AND     EV_NO       = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append(sm.addFixString("	AND     EV_YEAR     = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("				    AND     DEL_FLAG    = 'N'                                               \n ");
				sb.append("				    ORDER BY  EV_SEQ                                                        \n ");
				sf1 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				sf3 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격')  AS  VN_STATUS									\n ");
				sb.append("		      ,ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total = new StringBuffer();
				
				// 수정
				for( int k = 0; k < 17; k++ ){
					//if( k != 14 ){
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}else{
					//	sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}
					total.append("A.SCORE" + k);
					if( k != 16 ){
						total.append("+");
					}
				}
				// END				
				
				sb.append("			  ,(" + total.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 17; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf1.getRowCount(); k++ ){
						// 회사규모 >> 사업년수
						if( z == 0 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 회사규모 >> 매출규모
						else if( z == 1 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 재무상태 >> 부채비율
						else if( z == 2 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( z == 3 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 재무상태 >> 매출액영업이익율
						else if( z == 4 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 기술능력 >> 공장등록
						else if( z == 5 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row10")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> 인원현황
						else if( z == 6 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 기술능력 >> 생산직접시설물 보유현황
						else if( z == 7 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row4") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf1.removeValue(k);
							break;	
						}
						// 기술능력 >> 조합가입여부
						else if( z == 8 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row5")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 이행실적 >> 계약목적물과 동등이상 물품
						else if( z == 9 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 이행실적 >> 계약목적물과 동등이상 물품(II)
						else if( z == 10 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}					
						// 품질평가 >> 품질관리
						else if( z == 11 && sf1.getValue("EV_M_ITEM", k).equals("ev8") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 품질평가 >> 사후관리
						else if( z == 12 && sf1.getValue("EV_M_ITEM", k).equals("ev8") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> RAR실적
						else if( z == 13 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 법인신용카드 실적
						else if( z == 14 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 종업원급여이체 실적
						else if( z == 15 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 당행기여도 >> 퇴직연금실적
						else if( z == 16 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("								,ITEM_CHECK  															\n ");
				sb.append("								,AVG_EV_NO_SCORE  															\n ");
				sb.append("								,SUM_EV_NO_SCORE  															\n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append(sm.addFixString("		AND     EV_NO       = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_NO"      , i) );
				sb.append(sm.addFixString("		AND     EV_YEAR     = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"    , i) );
				sb.append(sm.addFixString("     AND     SG_REGITEM  = ?                                                         \n ")); sm.addStringParameter( sf.getValue("SG_REGITEM" , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				sb.append("		ORDER BY ROWNUM, VN_STATUS DESC                                                                 \n ");
				
				sf2 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
	
				sm.removeAllValue();  // 평가시트 결과표 복사 (INSERT)
				sb.delete(0, sb.length());
				sb.append(" insert into SHEET_RESULT \n ");
				sb.append(" ( \n ");
				sb.append(" 	  ITEM_NAME        ,    \n ");
				sb.append(" 	  VN_STATUS        ,	\n ");
				sb.append(" 	  NO               ,	\n ");
				sb.append(" 	  VENDOR_NAME      ,	\n ");
				sb.append(" 	  DATA0            ,	\n ");
				sb.append(" 	  SCORE0       	   ,	\n ");
				sb.append("       DATA1            ,	 \n");
				sb.append("       SCORE1           ,	 \n");
				sb.append("       DATA2            ,	 \n");
				sb.append("       SCORE2	   ,	 \n");
				sb.append("       DATA3            ,	 \n");
				sb.append("       SCORE3           ,	 \n");
				sb.append("       DATA4            ,	 \n");
				sb.append("       SCORE4           ,	 \n");
				sb.append("       DATA5            ,	 \n");
				sb.append("       SCORE5           ,	 \n");
				sb.append("       DATA6            ,	 \n");
				sb.append("       SCORE6           ,	 \n");
				sb.append("       DATA7            ,	 \n");
				sb.append("       SCORE7           ,	 \n");
				sb.append("       DATA8            ,	 \n");
				sb.append("       SCORE8           ,	 \n");
				sb.append("       DATA9            ,	 \n");
				sb.append("       SCORE9           ,	 \n");
				sb.append("       DATA10           ,	 \n");
				sb.append("       SCORE10          ,	 \n");
				sb.append("       DATA11           ,	 \n");
				sb.append("       SCORE11          ,	 \n");
				sb.append("       DATA12           ,	 \n");
				sb.append("       SCORE12          ,	 \n");
				sb.append("       DATA13           ,	 \n");
				sb.append("       SCORE13          ,	 \n");
				sb.append("       DATA14           ,	 \n");
				sb.append("       SCORE14          ,	 \n");
				sb.append("        DATA15          ,	 \n");
				sb.append("       SCORE15          ,	 \n");
				sb.append("        DATA16          ,	 \n");
				sb.append("       SCORE16          ,	 \n");
			//	sb.append("        DATA17          ,	 \n");
			//	sb.append("       SCORE17          ,	 \n");
				sb.append("     TOTAL              ,	 \n");
				sb.append("     SCORE           ,	 \n");
				sb.append("     EV_NO              ,	 \n");
				sb.append("     EV_YEAR            ,	 \n");
				sb.append("     SELLER_CODE        ,	 \n");
				sb.append("     SELLER_NAME_LOC    ,	 \n");
				sb.append("     SG_REGITEM         	 \n");


				sb.append(" ) \n ");
				//sb.append(" values \n ");
				sb.append(" ( \n ");

				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격') AS  VN_STATUS									\n ");
				sb.append("		      ,ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total_1 = new StringBuffer();
				
				// 수정
				for( int k = 0; k < 17; k++ ){
					//if( k != 14 ){
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}else{
					//	sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}
					total_1.append("A.SCORE" + k);
					if( k != 16 ){
						total_1.append("+");
					}
				}
				// END				
				
				sb.append("			  ,(" + total_1.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 17; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf3.getRowCount(); k++ ){
						// 회사규모 >> 사업년수
						if( z == 0 && sf3.getValue("EV_M_ITEM", k).equals("ev1") && sf3.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 회사규모 >> 매출규모
						else if( z == 1 && sf3.getValue("EV_M_ITEM", k).equals("ev1") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 재무상태 >> 부채비율
						else if( z == 2 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( z == 3 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 재무상태 >> 매출액영업이익율
						else if( z == 4 && sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 기술능력 >> 공장등록
						else if( z == 5 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row10")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 기술능력 >> 인원현황
						else if( z == 6 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 기술능력 >> 생산직접시설물 보유현황
						else if( z == 7 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row4") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf3.removeValue(k);
							break;	
						}
						// 기술능력 >> 조합가입여부
						else if( z == 8 && sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row5")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 이행실적 >> 계약목적물과 동등이상 물품
						else if( z == 9 && sf3.getValue("EV_M_ITEM", k).equals("ev4") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 이행실적 >> 계약목적물과 동등이상 물품(II)
						else if( z == 10 && sf3.getValue("EV_M_ITEM", k).equals("ev4") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}					
						// 품질평가 >> 품질관리
						else if( z == 11 && sf3.getValue("EV_M_ITEM", k).equals("ev8") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 품질평가 >> 사후관리
						else if( z == 12 && sf3.getValue("EV_M_ITEM", k).equals("ev8") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> RAR실적
						else if( z == 13 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 법인신용카드 실적
						else if( z == 14 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 종업원급여이체 실적
						else if( z == 15 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 당행기여도 >> 퇴직연금실적
						else if( z == 16 && sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("								,ITEM_CHECK  															\n ");
				sb.append("								,AVG_EV_NO_SCORE  															\n ");
				sb.append("								,SUM_EV_NO_SCORE  															\n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append("						AND     EV_NO       = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_NO"      , i) );
				sb.append("						AND     EV_YEAR     = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_YEAR"    , i) );
				sb.append("     				AND     SG_REGITEM  = ?                                                         \n "); sm.addStringParameter( sf.getValue("SG_REGITEM" , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				
				sb.append(" )	 \n ");
				sm.doInsert( sb.toString() );	
				Commit();					
				
				for ( int r = 0; r < sf2.getRowCount(); r++ )
	            {
					ArrayList ht = new ArrayList();
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_NO"          , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_YEAR"        , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_CODE"    , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_NAME_LOC", r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SG_REGITEM"     , r) ).trim() );	
					
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("ITEM_NAME"  , r) ).trim() );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VN_STATUS"  , r) ).trim() );
	            	ht.add( ""+(mapnum+1) );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VENDOR_NAME", r) ).trim() );
					for( int k = 0; k < 17; k++ ){
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("DATA"  + k, r) ).trim());
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE" + k, r) ).trim());
					}
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE"       , r) ).trim() );
					//ht.add(JSPUtil.nullToEmpty( sf2.getValue("TOTAL", r) ).trim() );
	            	arr_list.add(ht);
	            	mapnum++;
	            }//for~end		
			}
			setValue(arr_list);				
			
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
		}

		return getSepoaOut();
	}
	
	public SepoaOut ev_query_212( String sg_kind, String sg_kind_1, String sg_kind_2, String ev_year ) throws Exception{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb       = new StringBuffer();
			StringBuffer sb1      = new StringBuffer();
			StringBuffer sb2      = new StringBuffer();
			StringBuffer sb3      = new StringBuffer();
			StringBuffer sb4      = new StringBuffer();
			ParamSql sm           = new ParamSql(info.getSession("ID"), this, ctx);
			ArrayList arr_list    = new ArrayList();
			SepoaFormater sf      = null;
			SepoaFormater sf1     = null;
			SepoaFormater sf2     = null;
			SepoaFormater sf3     = null;
			int mapnum            = 0;
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("		DELETE FROM SHEET_RESULT																\n "); // 평가시트결과표 테이블 지우기
			sm.doDelete(sb.toString());
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("				SELECT  A.EV_YEAR																\n ");
			sb.append("				       ,A.EV_NO               													\n ");	
			sb.append("					   ,B.SG_REGITEM                                                            \n ");
			sb.append("				FROM   SEVGL    A                                                               \n ");
			sb.append("				      ,SEVVN    B                                                               \n ");
			sb.append("				WHERE  1=1                                                                      \n ");
			sb.append(sm.addFixString(" AND    A.SG_KIND   = ?                                                      \n "));	sm.addStringParameter(sg_kind);
			sb.append(sm.addFixString(" AND    A.EV_YEAR   = ?                                                      \n ")); sm.addStringParameter(ev_year);
			sb.append("				AND    A.USE_FLAG  = 'Y'                                                        \n ");
			sb.append("				AND    A.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.EV_NO     = B.EV_NO                                                    \n ");
			sb.append("				AND    A.EV_YEAR   = B.EV_YEAR                                                  \n ");
			sb.append("				AND    B.DEL_FLAG  = 'N'                                                        \n ");
			sb.append("				AND    A.PERIOD    = 'P'                                                        \n ");
			//**변경**
			sb.append("				AND    A.SHEET_STATUS = 'ED'  													\n ");
			//*******
			sb.append(sm.addFixString("	AND    B.SG_REGITEM = ?                                         		    \n ")); sm.addStringParameter(sg_kind_2);
			sb.append("				GROUP BY A.EV_NO                                                                \n ");
			sb.append("				        ,A.EV_YEAR                                                              \n ");
			sb.append("						,B.SG_REGITEM                                                           \n ");
			sb.append("				ORDER BY EV_NO                                                                  \n ");			
			
			sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));			
			
			for( int i = 0; i < sf.getRowCount(); i++ ){			
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("				    SELECT  EV_SEQ															\n ");
				sb.append("				           ,EV_M_ITEM                                                       \n ");
				sb.append("				           ,EV_D_ITEM                                                       \n ");
				sb.append("				           ,GETEV_M_ITEMEXT1(EV_M_ITEM,EV_D_ITEM) AS EV_D_ITEM_NAME         \n ");
				sb.append("				    FROM    SEVLN                                                           \n ");
				sb.append("				    WHERE   1=1                                                             \n ");
				sb.append(sm.addFixString("	AND     EV_NO       = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_NO"  , i) );
				sb.append(sm.addFixString("	AND     EV_YEAR     = ?                                                 \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"  , i) );
				sb.append("				    AND     DEL_FLAG    = 'N'                                               \n ");
				sb.append("				    ORDER BY  EV_SEQ                                                        \n ");
				sf1 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				sf3 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격')  AS  VN_STATUS									\n ");
				sb.append("		      ,ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total = new StringBuffer();
				
				// 수정
				for( int k = 0; k < 15; k++ ){
					//if( k != 14 ){
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}else{
					//	sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}
					total.append("A.SCORE" + k);
					if( k != 14 ){
						total.append("+");
					}
				}
				// END				
				
				sb.append("			  ,(" + total.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 15; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf1.getRowCount(); k++ ){
						// 회사규모 >> 사업년수
						if( z == 0 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 회사규모 >> 매출규모
						else if( z == 1 && sf1.getValue("EV_M_ITEM", k).equals("ev1") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 재무상태 >> 부채비율
						else if( z == 2 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( z == 3 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 재무상태 >> 매출액영업이익율
						else if( z == 4 && sf1.getValue("EV_M_ITEM", k).equals("ev2") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 기술능력 >> 인원현황
						else if( z == 5 && sf1.getValue("EV_M_ITEM", k).equals("ev3") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 이행실적 >> 계약목적물과 동등이상 물품
						else if( z == 6 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row1") ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf1.removeValue(k);
							break;	
						}
						// 이행실적 >> 계약목적물과 동등이상 물품(II)
						else if( z == 7 && sf1.getValue("EV_M_ITEM", k).equals("ev4") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 품질평가 >> 품질관리
						else if( z == 8 && sf1.getValue("EV_M_ITEM", k).equals("ev8") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 품질평가 >> 품질관리II
						else if( z == 9 && sf1.getValue("EV_M_ITEM", k).equals("ev8") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 품질평가 >> 사후관리
						else if( z == 10 && sf1.getValue("EV_M_ITEM", k).equals("ev8") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> RAR실적
						else if( z == 11 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row1")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 법인신용카드 실적
						else if( z == 12 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row2")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
						// 당행기여도 >> 종업원급여이체 실적
						else if( z == 13 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row3")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}						
						// 당행기여도 >> 퇴직연금실적
						else if( z == 14 && sf1.getValue("EV_M_ITEM", k).equals("ev5") && sf1.getValue("EV_D_ITEM", k).equals("row4")  ){
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf1.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf1.removeValue(k);
							break;
						}
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("								,ITEM_CHECK  															\n ");
				sb.append("								,AVG_EV_NO_SCORE  															\n ");
				sb.append("								,SUM_EV_NO_SCORE  															\n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append(sm.addFixString("		AND     EV_NO       = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_NO"      , i) );
				sb.append(sm.addFixString("		AND     EV_YEAR     = ?                                                         \n ")); sm.addStringParameter( sf.getValue("EV_YEAR"    , i) );
				sb.append(sm.addFixString("     AND     SG_REGITEM  = ?                                                         \n ")); sm.addStringParameter( sf.getValue("SG_REGITEM" , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				sb.append("		ORDER BY ROWNUM, VN_STATUS DESC                                                                 \n ");
				
				sf2 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				
				sm.removeAllValue();  // 평가시트 결과표 복사 (INSERT)
				sb.delete(0, sb.length());
				sb.append(" insert into SHEET_RESULT \n ");
				sb.append(" ( \n ");
				sb.append(" 	  ITEM_NAME        ,    \n ");
				sb.append(" 	  VN_STATUS        ,	\n ");
				sb.append(" 	  NO               ,	\n ");
				sb.append(" 	  VENDOR_NAME      ,	\n ");
				sb.append(" 	  DATA0            ,	\n ");
				sb.append(" 	  SCORE0       	   ,	\n ");
				sb.append("       DATA1            ,	 \n");
				sb.append("       SCORE1           ,	 \n");
				sb.append("       DATA2            ,	 \n");
				sb.append("       SCORE2	   ,	 \n");
				sb.append("       DATA3            ,	 \n");
				sb.append("       SCORE3           ,	 \n");
				sb.append("       DATA4            ,	 \n");
				sb.append("       SCORE4           ,	 \n");
				sb.append("       DATA5            ,	 \n");
				sb.append("       SCORE5           ,	 \n");
				sb.append("       DATA6            ,	 \n");
				sb.append("       SCORE6           ,	 \n");
				sb.append("       DATA7            ,	 \n");
				sb.append("       SCORE7           ,	 \n");
				sb.append("       DATA8            ,	 \n");
				sb.append("       SCORE8           ,	 \n");
				sb.append("       DATA9            ,	 \n");
				sb.append("       SCORE9           ,	 \n");
				sb.append("       DATA10           ,	 \n");
				sb.append("       SCORE10          ,	 \n");
				sb.append("       DATA11           ,	 \n");
				sb.append("       SCORE11          ,	 \n");
				sb.append("       DATA12           ,	 \n");
				sb.append("       SCORE12          ,	 \n");
				sb.append("       DATA13           ,	 \n");
				sb.append("       SCORE13          ,	 \n");
				sb.append("       DATA14           ,	 \n");
				sb.append("       SCORE14          ,	 \n");
			//	sb.append("        DATA15          ,	 \n");
			//	sb.append("       SCORE15          ,	 \n");
			//	sb.append("        DATA16          ,	 \n");
			//	sb.append("       SCORE16          ,	 \n");
			//	sb.append("        DATA17          ,	 \n");
			//	sb.append("       SCORE17          ,	 \n");
				sb.append("     TOTAL              ,	 \n");
				sb.append("     SCORE           ,	 \n");
				sb.append("     EV_NO              ,	 \n");
				sb.append("     EV_YEAR            ,	 \n");
				sb.append("     SELLER_CODE        ,	 \n");
				sb.append("     SELLER_NAME_LOC    ,	 \n");
				sb.append("     SG_REGITEM         	 \n");


				sb.append(" ) \n ");
				//sb.append(" values \n ");
				sb.append(" ( \n ");
				sb.append("		SELECT GETSGNAMETEXT2(A.SG_REGITEM)            AS ITEM_NAME										\n ");
				sb.append("		      ,DECODE(B.VN_STATUS,'WG','적격','부적격')  AS  VN_STATUS									\n ");
				sb.append("		      ,ROWNUM                                  AS NO											\n ");
				sb.append("			  ,A.VENDOR_NAME                                                                            \n ");
				StringBuffer total_1 = new StringBuffer();
				// 수정
				for( int k = 0; k < 15; k++ ){
					//if( k != 14 ){
						sb.append("		  ,A.DATA"  + k + "                                                                     \n ");
						sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}else{
					//	sb.append("		  ,A.SCORE" + k + "                                                                     \n ");
					//}
					total_1.append("A.SCORE" + k);
					if( k != 14 ){
						total_1.append("+");
					}
				}
				// END				
				sb.append("			  ,(" + total_1.toString() + ")     AS TOTAL                                                                  \n ");
				sb.append("			  ,B.SCORE    -- 합계점수																	\n ");
				sb.append("			  ,B.EV_NO                                              									\n ");
				sb.append("			  ,B.EV_YEAR                                            									\n ");
				sb.append("		      ,B.SELLER_CODE                                        									\n ");
				sb.append("			  ,A.VENDOR_NAME  AS SELLER_NAME_LOC                    									\n ");
				sb.append("			  ,B.SG_REGITEM                                         									\n ");				
				sb.append("		FROM   (                                                                                        \n ");
				sb.append("				SELECT EV_NO                                                                            \n ");
				sb.append("					  ,EV_YEAR                                                                          \n ");
				sb.append("					  ,VENDOR_CODE                                                                      \n ");
				sb.append("					  ,VENDOR_NAME                                                                      \n ");
				sb.append("					  ,SG_REGITEM                                                                       \n ");

				for( int z = 0; z < 15; z++ ){
					int chk     = 0;
					
					for( int k = 0; k < sf3.getRowCount(); k++ ){
						Logger.sys.println("k = " + k + ", sf3.getRowCount() = " + sf3.getRowCount());
						// 회사규모 >> 사업년수
						if( sf3.getValue("EV_M_ITEM", k).equals("ev1") && sf3.getValue("EV_D_ITEM", k).equals("row1") ){
							Logger.sys.println("회사규모 >> 사업년수");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 회사규모 >> 매출규모
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev1") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							Logger.sys.println("회사규모 >> 매출규모");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 재무상태 >> 부채비율
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							Logger.sys.println("재무상태 >> 부채비율");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}	
						// 재무상태 >> 유동비율
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							Logger.sys.println("재무상태 >> 유동비율");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 재무상태 >> 매출액영업이익율
						else if(sf3.getValue("EV_M_ITEM", k).equals("ev2") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							Logger.sys.println("재무상태 >> 매출액영업이익율");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN TO_NUMBER(REAL_SCORE)    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 기술능력 >> 인원현황
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev3") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							Logger.sys.println("기술능력 >> 인원현황");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 이행실적 >> 계약목적물과 동등이상 물품
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev4") && sf3.getValue("EV_D_ITEM", k).equals("row1") ){
							Logger.sys.println("이행실적 >> 계약목적물과 동등이상 물품");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk     = 1;
							sf3.removeValue(k);
							break;	
						}
						// 이행실적 >> 계약목적물과 동등이상 물품(II)
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev4") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							Logger.sys.println("이행실적 >> 계약목적물과 동등이상 물품(II)");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 품질평가 >> 품질관리
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev8") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							Logger.sys.println("품질평가 >> 품질관리");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 품질평가 >> 품질관리II
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev8") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							Logger.sys.println("품질평가 >> 품질관리II");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> RAR실적
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row1")  ){
							Logger.sys.println("당행기여도 >> RAR실적");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 품질평가 >> 사후관리
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev8") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							Logger.sys.println("품질평가 >> 사후관리");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}

						// 당행기여도 >> 법인신용카드 실적
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row2")  ){
							Logger.sys.println("당행기여도 >> 법인신용카드 실적");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						// 당행기여도 >> 종업원급여이체 실적
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row3")  ){
							Logger.sys.println("당행기여도 >> 종업원급여이체 실적");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE    END),0)          AS SCORE"  + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}						
						// 당행기여도 >> 퇴직연금실적
						else if( sf3.getValue("EV_M_ITEM", k).equals("ev5") && sf3.getValue("EV_D_ITEM", k).equals("row4")  ){
							Logger.sys.println("당행기여도 >> 퇴직연금실적");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN REAL_SCORE    END),0)     AS DATA"  + z + "    \n ");
							sb.append("				  ,NVL(MAX(CASE WHEN EV_SEQ = '" + sf3.getValue("EV_SEQ", k) + "' THEN SCORE		 END),0)     AS SCORE" + z + "    \n ");
							chk = 1;
							sf3.removeValue(k);
							break;
						}
						
					}
					if( chk == 0 ){
						sb.append("				      ,'0'  AS DATA"  + z + "             \n ");
						sb.append("				      ,'0'  AS SCORE" + z + "             \n ");
					}
				}
				sb.append("				FROM	(                                                                               \n ");
				sb.append("						 SELECT  EV_NO                                                                  \n ");
				sb.append("								,EV_YEAR                                                                \n ");
				sb.append("								,EV_SEQ                                                                 \n ");
				sb.append("								,EV_DSEQ                                                                \n ");
				sb.append("								,VENDOR_CODE                                                            \n ");
				sb.append("								,VENDOR_NAME                                                            \n ");
				sb.append("								,SG_REGITEM                                                             \n ");
				sb.append("								,DECODE(REAL_SCORE,NULL,EV_REMARK,REAL_SCORE)        AS REAL_SCORE      \n ");
				sb.append("								,NVL(SCORE,'0')                                      AS SCORE           \n ");
				sb.append("								,ITEM_CHECK  															\n ");
				sb.append("								,AVG_EV_NO_SCORE  														\n ");
				sb.append("								,SUM_EV_NO_SCORE  														\n ");
				sb.append("						FROM    SINVN                                                                   \n ");
				sb.append("						WHERE   1=1                                                                     \n ");
				sb.append("						AND     EV_NO       = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_NO"      , i) );
				sb.append("						AND     EV_YEAR     = ?                                                         \n "); sm.addStringParameter( sf.getValue("EV_YEAR"    , i) );
				sb.append("     				AND     SG_REGITEM  = ?                                                         \n "); sm.addStringParameter( sf.getValue("SG_REGITEM" , i) );
				sb.append("						AND     DEL_FLAG    = 'N'                                                       \n ");
				sb.append("						AND     EV_FLAG     = 'Y'                                                       \n ");
				sb.append("						ORDER BY  EV_SEQ                                                                \n ");
				sb.append("						         ,VENDOR_CODE                                                           \n ");
				sb.append("						         ,EV_DSEQ                                                               \n ");
				sb.append("						         ,EVAL_ID                                                               \n ");
				sb.append("					    )                                                                               \n ");
				sb.append("				GROUP BY  EV_NO                                                                         \n ");
				sb.append("						 ,EV_YEAR                                                                       \n ");
				sb.append("						 ,VENDOR_CODE                                                                   \n ");
				sb.append("						 ,VENDOR_NAME                                                                   \n ");
				sb.append("						 ,SG_REGITEM                                                                    \n ");
				sb.append("		       )      A                                                                                 \n ");
				sb.append("		      ,SEVVN  B                                                                                 \n ");
				sb.append("		WHERE 1=1                                                                                       \n ");
				sb.append("		AND   A.EV_NO       = B.EV_NO                                                                   \n ");
				sb.append("		AND   A.EV_YEAR     = B.EV_YEAR                                                                 \n ");
				sb.append("		AND   A.SG_REGITEM  = B.SG_REGITEM                                                              \n ");
				sb.append("		AND   A.VENDOR_CODE = B.SELLER_CODE                                                             \n ");
				
				sb.append(" )	 \n ");
				Logger.sys.println("sb.toString() = " + sb.toString());
				
				
				sm.doInsert( sb.toString() );	
				Commit();					
				
				
				for ( int r = 0; r < sf2.getRowCount(); r++ )
	            {
					ArrayList ht = new ArrayList();
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_NO"          , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("EV_YEAR"        , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_CODE"    , r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SELLER_NAME_LOC", r) ).trim() );
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SG_REGITEM"     , r) ).trim() );	
					
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("ITEM_NAME"  , r) ).trim() );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VN_STATUS"  , r) ).trim() );
	            	ht.add( ""+(mapnum+1) );
	            	ht.add(JSPUtil.nullToEmpty( sf2.getValue("VENDOR_NAME", r) ).trim() );
					for( int k = 0; k < 15; k++ ){
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("DATA"  + k, r) ).trim());
							ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE" + k, r) ).trim());
					}
					ht.add(JSPUtil.nullToEmpty( sf2.getValue("SCORE"       , r) ).trim() );
					//ht.add(JSPUtil.nullToEmpty( sf2.getValue("TOTAL", r) ).trim() );
	            	arr_list.add(ht);
	            	mapnum++;
	            }//for~end	
			}
			setValue(arr_list);	
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
		}

		return getSepoaOut();
	}	
}	

