package ev;

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
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

public class WO_024 extends SepoaService
{
	private String ID = info.getSession("ID");

	public WO_024(String opt, SepoaInfo info) throws SepoaServiceException
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

	public SepoaOut a_24_list(String ev_no) throws Exception
	{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb = new StringBuffer();
			String language = info.getSession("LANGUAGE");
			ArrayList arr_list = new ArrayList();
			SepoaFormater sf = null;

			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" select                             \n");
				sb.append(" ev_no                              \n");
				sb.append(" ,subject                           \n");
				sb.append(" ,sheet_kind                        \n");
				sb.append(" ,sg_kind                           \n");
				sb.append(" ,period                            \n");
				sb.append(" ,use_flag                          \n");
				sb.append(" ,ev_year                           \n");
				sb.append(" ,sheet_status                      \n");
				sb.append(" ,st_date                           \n");
				sb.append(" ,end_date                          \n");
				sb.append(" from                               \n");
				sb.append(" SEVGL                              \n");
				sb.append(" WHERE                              \n");
				sb.append(" 1=1                                \n");
				sb.append(sm.addSelectString("   AND EV_NO= ?					      			\n"));
				sm.addStringParameter(ev_no);
				sb.append(sm.addSelectString("   AND EV_YEAR= ?					      			\n"));
				sm.addStringParameter(SepoaDate.getYear()+"");
				
				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());
				
				sf = new SepoaFormater(sm.doSelect(sb.toString()));
				for (int i = 0; i < sf.getRowCount(); i++)
	            {
	            	Hashtable ht = new Hashtable();
	            	ht.put("SHEET_KIND", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("SHEET_KIND", i))).trim());
	            	ht.put("SG_KIND", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("SG_KIND", i))).trim());
	            	ht.put("PERIOD", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("PERIOD", i))).trim());
	            	ht.put("USE_FLAG", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("USE_FLAG", i))).trim());
	            	ht.put("EV_YEAR", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("EV_YEAR", i))).trim());
	            	ht.put("SHEET_STATUS", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("SHEET_STATUS", i))).trim());
	            	ht.put("ST_DATE", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("ST_DATE", i))).trim());
	            	ht.put("END_DATE", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("END_DATE", i))).trim());
	            	
	            	
	            	arr_list.add(ht);
	            }//for~end
				
				setValue(arr_list);	//setValue로 list를 넘기자!!
 
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" SELECT                                                                                        \n");
				sb.append(" A.EV_NO                                                                                       \n");
				sb.append(" ,A.EV_YEAR                                                                                    \n");
				sb.append(" ,A.SELLER_CODE                                                                                \n");
				sb.append(" ,(SELECT VENDOR_NAME_LOC FROM ICOMVNGL WHERE VENDOR_CODE = A.SELLER_CODE) AS SELLER_NAME_LOC   \n");
				sb.append(" ,A.teb_id                                                                                     \n");
				sb.append(" ,CONVERT_DATE(DECODE(B.REG_DATE,NULL,'업체평가미실시','업체평가실시')) AS REG_DATE                             \n");
				//sb.append(" ,DECODE(A.EV_DATE,'','평가미실시','평가실시' ) AS ev_start_flag      	                         \n");
				sb.append(" ,DECODE(B.TOTAL_SCORE,'','평기미실시',DECODE(B.TOTAL_SCORE,'','평가미실시','평가실시') ) AS ev_start_flag \n");
				
				sb.append(" ,CONVERT_DATE(A.ev_date)  AS ev_date                                                                                   \n");
				sb.append(" ,CONVERT_DATE(B.REG_DATE)     AS REG_DATE_2                                                                                \n");				
				//sb.append(" ,getcodetext1('M224',A.vn_status,'KO') AS vn_status                                                                                  \n");
				sb.append(" ,DECODE(B.TOTAL_SCORE,'','',getcodetext1('M224',A.vn_status,'KO')) AS vn_status                                              \n");
				sb.append(" ,DECODE(A.confirm_flag,'Y','평가완료','평가중') AS CONFIRM_FLAG                                                                               \n");
				sb.append(" ,A.SG_REGITEM                                                                                 \n");
				sb.append(" ,CONVERT_DATE(B.ST_DATE) AS ST_DATE 				                                                                      \n");
				sb.append(" ,CONVERT_DATE(B.ET_DATE) AS ET_DATE 				                                                                      \n");
				sb.append(" ,A.EV_NO 				                                                                      \n");
				sb.append(" ,A.EV_YEAR 				                                                                      \n");
				sb.append(" ,GETSGNAME2(A.SG_REGITEM) AS SG_REGITEM 				                                                                  \n");
				sb.append(" ,A.SG_REGITEM AS SG_REGITEM_CODE 				                                  \n");
				sb.append(" ,(SELECT USER_NAME_LOC FROM ICOMLUSR WHERE HOUSE_CODE = '100' AND USER_TYPE = 'W100' AND STATUS != 'D' AND USER_ID = B.EVAL_ID ) AS EVAL_NAME						 				                                  \n");
				sb.append(" ,B.EVAL_ID 				                                  \n");
				sb.append(" FROM                                                                                          \n");
				sb.append(" SEVVN A ,                                                                                     \n");
				sb.append(" (SELECT                                                                                       \n");
				sb.append("  EV_NO                                                                                        \n");
				sb.append("  ,EV_YEAR                                                                                     \n");
				sb.append("  ,SG_REGITEM                                                                                  \n");
				sb.append("  ,VENDOR_CODE                                                                                 \n");
				sb.append("  ,ST_DATE                                                                                     \n");
				sb.append("  ,ET_DATE                                                                                     \n");
				sb.append("  ,REG_DATE                                                                                     \n");
				sb.append("  ,EVAL_ID                                                                                     \n");
				sb.append("  ,TOTAL_SCORE                                                                                     \n");
				sb.append("  FROM SINVN                                                                                   \n");
				sb.append("  WHERE DEL_FLAG = 'N'                                                                           \n");
				sb.append(sm.addSelectString("   AND EV_YEAR= ?					      			\n"));
				sm.addStringParameter(SepoaDate.getYear()+"");
				sb.append(" AND EV_FLAG = 'Y'		                                                                     \n");
				sb.append("  GROUP BY EV_NO,EV_YEAR, VENDOR_CODE, SG_REGITEM, ST_DATE, ET_DATE ,REG_DATE,EVAL_ID, TOTAL_SCORE) B               \n");
				sb.append(" WHERE A.EV_NO = B.EV_NO                                                                       \n");
				sb.append(" AND A.EV_YEAR = B.EV_YEAR                                                                     \n");
				sb.append(" AND A.SELLER_CODE = B.VENDOR_CODE                                                             \n");
				sb.append(" AND A.SG_REGITEM = B.SG_REGITEM                                                               \n");
				sb.append(" AND A.SG_REGITEM = B.SG_REGITEM                                                               \n");
				sb.append(sm.addSelectString("   AND A.EV_NO= ?																\n"));
				sm.addStringParameter(ev_no);
				sb.append(sm.addSelectString("   AND A.EV_YEAR= ?					      			\n"));
				sm.addStringParameter(SepoaDate.getYear()+"");
				
				sb.append(" AND A.DEL_FLAG = 'N'                                                               \n");
				
				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

				rtn[0] = sm.doSelect(sb.toString());
			
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
//			System.out.println(new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);

		}

		return getSepoaOut();
	}
	
	
	public SepoaOut getEvaluation_header(String ev_no, String ev_year) throws Exception
	{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb = new StringBuffer();
			String language = info.getSession("LANGUAGE");
			ArrayList arr_list = new ArrayList();
			SepoaFormater sf = null;

			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" select                             \n");
				sb.append(" subject                           \n");
				sb.append(" ,ev_year                           \n");
				sb.append(" ,sg_kind                           \n");
				sb.append(" ,sheet_status                      \n");
				sb.append(" from                               \n");
				sb.append(" SEVGL                              \n");
				sb.append(" WHERE                              \n");
				sb.append(" 1=1                                \n");
				sb.append(sm.addSelectString("   AND EV_NO= ?					      			\n"));
				sm.addStringParameter(ev_no);
				sb.append(sm.addSelectString("   AND EV_YEAR= ?					      			\n"));
				sm.addStringParameter(ev_year);
				
				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());
				
				rtn[0] = sm.doSelect(sb.toString());
			
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
//			System.out.println(new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);

		}

		return getSepoaOut();
	}
	
	public SepoaOut a_24_pop_list(String ev_no, String ev_year, String seller_code, String sg_regitem, String ev_date, String reg_date_2, String eval_id) throws Exception
	{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb = new StringBuffer();
			String language = info.getSession("LANGUAGE");
			ArrayList arr_list = new ArrayList();
			SepoaFormater sf = null;
//			System.out.println("팝업");
			
			// 평가자가 입력을 하지않았으면 0점으로 보여준다.
			String data = "0";
			if( !"".equals(ev_date) )  data = "D.EV_POINT";
			
			// 업체가 입력을 하지않았으면 0점으로 보여준다.
			String data1 = "0";
			if( !"".equals(reg_date_2) )  data1 = "D.EV_POINT";
			
			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" SELECT TO_NUMBER(NVL(Z.SORT_SEQ,888)) AS SORT_SEQ																											  \n");
				sb.append("       ,TO_NUMBER(SUBSTR(EV_M_ITEM,3)) SEQ                                                                  		\n");
				sb.append("       ,C.EV_M_ITEM AS EV_M_ITEM_CODE                                                                  		\n");
				sb.append("       ,C.EV_D_ITEM AS EV_D_ITEM_CODE                                                                  		\n");
				sb.append("       ,GETEV_M_ITEMEXT1('EV001',C.EV_M_ITEM) AS EV_M_ITEM	--대분류평가항목                                                                                                      														  \n");
				sb.append("       ,GETEV_M_ITEMEXT1(C.EV_M_ITEM,C.EV_D_ITEM) AS EV_D_ITEM	--중분류평가항목                                                                                                      													  \n");
				sb.append("       ,TO_CHAR(C.EV_BASIC_POINT) AS EV_BASIC_POINT			-- 기본점수                                                                                                                            																				  \n");
				sb.append("       ,D.EV_ITEM_DESC				--평가요소                                                                                                                            																			  \n");
				sb.append("       ,TO_CHAR(D.EV_POINT) AS EV_POINT				--배점                                                                                                                                																				  \n");
				sb.append("       ,DECODE(C.EV_M_ITEM,'ev11',DECODE(D.SCORE,0, TO_CHAR(D.EV_POINT), TO_CHAR(D.SCORE)),TO_CHAR(D.EV_POINT)) AS EV_POINT_REL				--배점_REL                                                                                                                                																				  \n");
				sb.append(" , TO_CHAR ( (CASE WHEN C.EV_TYPE ='01'                                                       																									  \n");
				sb.append("              THEN (CASE WHEN C.EV_ITEM = '1'                                                    																						  \n");
				sb.append("                        THEN (D.ITEM_POINT1 + D.ITEM_POINT2 + D.ITEM_POINT3)       																									  \n");
				sb.append("  						ELSE  (CASE WHEN D.ITEM_POINT1 = '0'                                 							                           \n");
				sb.append("                                     THEN 0                                                   									     \n");
				sb.append("                                     ELSE (CASE WHEN D.ITEM_POINT2 = '0'                									           \n");
				sb.append("                                                 THEN 100                                									          \n");
				sb.append("                                                 ELSE ROUND((D.ITEM_POINT1 / D.ITEM_POINT2  * 100),2)  											     \n");
				sb.append("                                    		 END)                                         														   \n");	
				sb.append("                               END)                                                         													      \n");
				sb.append("                   END)                                                             																									  \n");
				sb.append("              ELSE 0                                                              																									  \n");
				sb.append("         END) , 'FM99999999999999990.00') AS ITEM_POINT_CAL    -- 업체기재                                     \n");
				sb.append("       , TO_CHAR ( (                                                                                        																					  \n");
				sb.append("          CASE WHEN C.EV_TYPE ='01'                                                                                                                     								  \n");
				sb.append(" 	          THEN (CASE WHEN C.EV_ITEM = '1'                                                                                               											  \n");
				sb.append(" 			            THEN (CASE WHEN TO_NUMBER(D.EV_MIN) <= TO_NUMBER(D.ITEM_POINT1 + D.ITEM_POINT2 + D.ITEM_POINT3)           															  \n");
				sb.append(" 			 	                       AND TO_NUMBER(D.ITEM_POINT1 + D.ITEM_POINT2 + D.ITEM_POINT3) < TO_NUMBER(D.EV_MAX)     																	  \n");
				sb.append(" 			 	                  THEN D.EV_POINT                                                                             																	  \n");
				sb.append(" 			 	                  ELSE 0                                                                                      																	  \n");
				sb.append(" 			                 END)                                                                                                 															  \n");
				sb.append(" 			            ELSE                                                                                                  																  \n");
				sb.append(" 			 	             (CASE WHEN D.ITEM_POINT2 = '0'                                                            																			  \n");
				sb.append(" 			                      THEN (CASE WHEN TO_NUMBER(D.EV_MIN) <= TO_NUMBER(100)                                   																	  \n");
				sb.append(" 			 	 	                             AND TO_NUMBER(100) < TO_NUMBER(D.EV_MAX)                                       																	  \n");
				sb.append(" 			 	 	                        THEN " + data1 + "                                                                   																		  \n");
				sb.append(" 			 	 	                        ELSE 0                                                                            																		  \n");
				sb.append(" 			 	 	                        END)                                                                               																			  \n");
				sb.append(" 			 	                  ELSE (CASE WHEN TO_NUMBER(D.EV_MIN) <= TO_NUMBER(D.ITEM_POINT1 / D.ITEM_POINT2  * 100) 																		  \n");
				sb.append(" 			 	 	                             AND TO_NUMBER(D.ITEM_POINT1 / D.ITEM_POINT2  * 100) < TO_NUMBER(D.EV_MAX)      																	  \n");
				sb.append(" 			 	 	                        THEN " + data1 + "                                                                  																		  \n");
				sb.append(" 			 	 	                        ELSE 0                                                                           																		  \n");
				sb.append(" 			 	 	                        END)                                                                              																		      \n");
				sb.append(" 			 	              END)                                                                                              																	  \n");
				sb.append(" 		            END)                                                                                                       	 													      \n");
				sb.append(" 	 	   ELSE 0                                                                                                                   												  \n");
				sb.append(" 		END                                                                                                                            												  \n");
				sb.append("        ) , 'FM99999999999999990.00')       AS ITEM_POINT_SCORE   -- 업체배점                                                                                                         											 			  \n");
				sb.append("       ,TO_CHAR (D.REAL_SCORE , 'FM99999999999999990.00') AS REAL_SCORE                        -- 실적                                                                                                             							 							  \n");
				sb.append(" , TO_CHAR ( (CASE WHEN C.EV_TYPE ='01'                                                                                                                              		  \n");
				sb.append(" 		                   THEN (CASE WHEN C.EV_ITEM = '1'                                                                                                                    			  \n");
				sb.append(" 			                         THEN (CASE WHEN D.REAL_SCORE != '0'    				  \n");
				sb.append(" 			                                    THEN (CASE WHEN TO_NUMBER(D.EV_MIN) <= DECODE(D.REAL_SCORE,'0',TO_NUMBER(D.ITEM_POINT1 + D.ITEM_POINT2 + D.ITEM_POINT3),D.REAL_SCORE)    				  \n");
				sb.append(" 			                                                    AND DECODE(D.REAL_SCORE,'0',TO_NUMBER(D.ITEM_POINT1 + D.ITEM_POINT2 + D.ITEM_POINT3),D.REAL_SCORE) < TO_NUMBER(D.EV_MAX)    				  \n");
				sb.append(" 			 	                                           THEN D.EV_POINT                                                                                                               					  \n");
				sb.append(" 			 	                                           ELSE 0                                                                                                                        					  \n");
				sb.append(" 			 	                                      END)                                                                                                                          					  \n");
				
				sb.append(" 			                                    ELSE (CASE WHEN TO_NUMBER(D.EV_MIN) <= DECODE(D.REAL_SCORE,'0',TO_NUMBER(D.ITEM_POINT1 + D.ITEM_POINT2 + D.ITEM_POINT3),D.REAL_SCORE)    				  \n");
				sb.append(" 			 	                                                AND DECODE(D.REAL_SCORE,'0',TO_NUMBER(D.ITEM_POINT1 + D.ITEM_POINT2 + D.ITEM_POINT3),D.REAL_SCORE) < TO_NUMBER(D.EV_MAX) 					  \n");
				sb.append(" 			 	                                           THEN "+data+"                                                                                                              					  \n");
				sb.append(" 			 	                                           ELSE 0                                                                                                                        					  \n");
				sb.append(" 			 	                                      END)                                                                                                                          					  \n");
				sb.append(" 			 	                          END)                                                                                                                          					  \n");				
				sb.append(" 			 	                    ELSE                                                                                                                              					  \n");
				sb.append("                                          (CASE WHEN D.REAL_SCORE != '0'                                                                                                                                \n");
				sb.append(" 		 			 			   		       THEN (CASE WHEN TO_NUMBER(D.EV_MIN) <= TO_NUMBER(D.REAL_SCORE)          \n");
				sb.append(" 		 		 	 	                                       AND TO_NUMBER(D.REAL_SCORE) < TO_NUMBER(D.EV_MAX)               \n");
				sb.append(" 		 		 	 	                                  THEN D.EV_POINT                                                      \n");
				sb.append(" 		 		 	 	                                  ELSE 0                                                               \n");
				sb.append(" 		 	 	 	                                 END)                                                                                  \n");
				sb.append(" 		 			 			   		       ELSE (CASE WHEN D.ITEM_POINT2 = '0'                                     \n");
				sb.append(" 		 			               	   		              THEN (CASE WHEN TO_NUMBER(D.EV_MIN) <= TO_NUMBER(D.REAL_SCORE)                      \n");
				sb.append(" 		 			 	 	            	                              AND TO_NUMBER(D.REAL_SCORE) < TO_NUMBER(D.EV_MAX)                     \n");
				sb.append(" 		 			 	 	           		                         THEN "+data+"                                          \n");
				sb.append(" 		 			 	 	            	                         ELSE 0                                                           \n");
				sb.append(" 		 			 	                                        END)                                                                      \n");
				sb.append(" 		 			 	                                  ELSE (CASE WHEN TO_NUMBER(D.EV_MIN) <= TO_NUMBER(D.REAL_SCORE)                 \n");
				sb.append(" 		 		 	 	                                                  AND TO_NUMBER(D.REAL_SCORE) < TO_NUMBER(D.EV_MAX)               \n");
				sb.append(" 		 		 	 	                                             THEN "+data+"                                                      \n");
				sb.append(" 		 		 	 	                                             ELSE 0                                                               \n");
				sb.append(" 		 	 	 	                                            END)                                                                         \n");
				sb.append(" 		 	                                         END)                                                                                          \n");
				sb.append(" 	                                       END)                                                                                                                   \n");
				sb.append(" 	                            END)                                                                                                                              				  \n");
				sb.append(" 			              ELSE                                                                                                                                                  				  \n");
				sb.append("                                (CASE WHEN C.AUTO_CAL = 'Y'                                                                                                                                                 		  \n");
				sb.append(" 		                             THEN NVL(to_number(sheet_cal(C.AVG_EV_NO,C.CAL_TYPE,C.AVG_VALUE,C.SUM_EV_NO,'"+seller_code+"')),0)        			  \n");
				sb.append(" 		                        ELSE                                                                                                                            		  \n");
				sb.append(" 	 			                  (CASE WHEN D.ITEM_CHECK = '1'                                                                                        		  \n");
				sb.append(" 	 			      	               THEN DECODE(C.EV_M_ITEM,'ev11',DECODE(D.SCORE,0,D.EV_POINT,D.SCORE),D.EV_POINT)                                                                                                		  \n");
				sb.append(" 	 				                   ELSE 0                                                                                                      		  \n");
				sb.append(" 	 			                  END)                                                                                                                 		  \n");
				sb.append(" 		                        END)                                                                                                                                 		  \n");
				sb.append(" 		             END)	, 'FM99999999999999990.00')																		 																					  \n");
				sb.append("  AS  SCORE             --점수																	 																			  \n");
				sb.append("        ,C.EV_REMARK				--비고                                                                                                                             																				      \n");
				sb.append("        ,D.EV_SEQ				                                                                                                                        					          \n");
				sb.append("        ,D.EV_REQSEQ			                                                                                                                              							  \n");
				sb.append("        ,getcodetext1('M050',C.EV_TYPE,'KO')  as EV_TYPE		                                                                                                                              \n");
				sb.append("        ,D.ITEM_CHECK		                                                                                                                              \n");
				sb.append("        ,C.EV_ITEM		                                                                                                                              \n");
				sb.append("        ,D.EV_DSEQ		                                                                                                                              \n");
				sb.append("        ,C.AUTO_CAL --자동계산 여부		                                                                                                                              \n");
				sb.append("        ,D.EV_REMARK AS ITEM_REMARK --ITEM_비고		                                                                                                                              \n");
				sb.append("        ,D.ATTACH_TXT		                                                                                                                              \n");
				sb.append("        ,C.ATTACH_REMARK		                                                                                                                              \n");
				sb.append("        ,'1' SORT_CNT                     \n");
				sb.append(" FROM  SEVLN   C                                                                                                                                                                       \n");
				sb.append("      ,(                                                                                                                                                                               \n");
				sb.append("        SELECT  A.EV_NO                                                                                                                                                                \n");
				sb.append("               ,A.EV_SEQ                                                                                                                                                               \n");
				sb.append("               ,A.EV_DSEQ                                                                                                                                                              \n");
				sb.append("               ,A.EV_ITEM_DESC                                                                                                                                                         \n");
				sb.append("               ,A.EV_POINT                                                                                                                                                             \n");
				sb.append("               ,NVL(B.ITEM_POINT1,'0')  AS ITEM_POINT1                                                                                                                                 \n");
				sb.append("               ,NVL(B.ITEM_POINT2,'0')  AS ITEM_POINT2                                                                                                                                 \n");
				sb.append("               ,NVL(B.ITEM_POINT3,'0')  AS ITEM_POINT3                                                                                                                                 \n");
				sb.append("               ,NVL(B.REAL_SCORE,'0')   AS REAL_SCORE                                                                                                                                  \n");
				sb.append("               ,NVL(B.SCORE,'0')        AS SCORE                                                                                                                                       \n");
				sb.append("               ,B.ATTACH_TXT                                                                                                                                                           \n");
				sb.append("               ,A.EV_MAX                                                                                                                                                               \n");
				sb.append("               ,A.EV_MIN                                                                                                                                                               \n");
				sb.append("               ,B.EV_REQSEQ                                                                                                                                                            \n");
				sb.append("               ,B.ITEM_CHECK                                                                                                                                                           \n");
				sb.append("               ,B.EV_REMARK                                                                                                                                                           \n");
				sb.append("        FROM    SEVDT  A                                                                                                                                                               \n");
				sb.append("               ,SINVN  B                                                                                                                                                               \n");
				sb.append("        WHERE   A.EV_NO   = B.EV_NO                                                                                                                                                    \n");
				sb.append("        AND     A.EV_YEAR = B.EV_YEAR                                                                                                                                                  \n");
				sb.append("        AND     A.EV_SEQ  = B.EV_SEQ                                                                                                                                                   \n");
				sb.append("        AND     A.EV_DSEQ = B.EV_DSEQ                                                                                                                                                  \n");
				sb.append(sm.addSelectString("        AND     A.EV_NO   = ?                                                                                                                                       \n"));
				sm.addStringParameter(ev_no);
				sb.append(sm.addSelectString("        AND     B.EV_YEAR  = ?                                                                                                                                      \n"));
				sm.addStringParameter(ev_year);
				sb.append(sm.addSelectString("        AND     A.EV_YEAR  = ?                                                                                                                                     \n"));
				sm.addStringParameter(ev_year);
				sb.append(sm.addSelectString("        AND     B.VENDOR_CODE = ?                                                                                                                                   \n"));
				sm.addStringParameter(seller_code);
				sb.append(sm.addSelectString("        AND     B.SG_REGITEM = ?                                                                                                                                    \n"));
				sm.addStringParameter(sg_regitem);
				sb.append(sm.addSelectString("        AND     B.EVAL_ID = ?                                                                                                                                    \n"));
				sm.addStringParameter(eval_id);				
				
				sb.append("       AND B.DEL_FLAG = 'N'                                                                                                                                                  	 	  \n");
				sb.append("       AND A.DEL_FLAG ='N'                                                                                                                                                 			  \n");
				sb.append("       AND B.EV_FLAG  = 'Y'                                                                                                                                                 			  \n");
				sb.append("       )       D     , SCODE Z                                                                                                                                                         \n");
				sb.append(" WHERE  C.EV_SEQ   = D.EV_SEQ                                                                                                                                                          \n");
				sb.append(sm.addSelectString(" AND    C.EV_NO    = ?                                                                                                                                              \n"));
				sm.addStringParameter(ev_no);
				sb.append(sm.addSelectString(" AND    C.EV_YEAR  = ?                                                                                                                                              \n"));
				sm.addStringParameter(ev_year);
				sb.append(" AND    C.DEL_FLAG = 'N'                                                                                                                                                               \n");
				sb.append(" AND    Z.TYPE='EV001'                                                                                                                                                               \n");
				sb.append(" AND    NVL(Z.DEL_FLAG,'N') = 'N'                                                                                                                                                              \n");
				sb.append(" AND    C.EV_M_ITEM = Z.CODE                                                                                                                                                               \n");
				sb.append("                                           \n");
				sb.append("UNION                                      \n");
				sb.append("                                           \n");
				sb.append("SELECT   999 AS SORT_SEQ                                  \n");
				sb.append(" 		,999 SEQ                             \n");
				sb.append("       	,'' EV_M_ITEM_CODE                \n");
				sb.append("       	,'' EV_D_ITEM_CODE                \n");
				sb.append("       	,'' AS EV_M_ITEM --대분류평가항목   	  \n");
				sb.append("       	,'' AS EV_D_ITEM --중분류평가항목       \n");
				sb.append("       	,'' EV_BASIC_POINT   -- 기본점수       \n");
				sb.append("       	,'' EV_ITEM_DESC    --평가요소           \n");
				sb.append("       	,'' EV_POINT                      \n");
				sb.append("       	,'' EV_POINT_REL                   \n");
				sb.append("  		,'' ITEM_POINT_CAL                \n");
				sb.append("  		,'' ITEM_POINT_SCORE   -- 업체배점   \n");
				sb.append("       	,'' REAL_SCORE                    \n");
				sb.append("       	,'' AS  SCORE             --점수      \n");
				sb.append("        	,'' EV_REMARK    --비고            	  \n");
				sb.append("        	,'' EV_SEQ                        \n");
				sb.append("        	,'' EV_REQSEQ                     \n");
				sb.append("        	,'' as EV_TYPE                    \n");
				sb.append("        	,'' ITEM_CHECK                    \n");
				sb.append("        	,'' EV_ITEM                       \n");
				sb.append("        	,'' EV_DSEQ                       \n");
				sb.append("        	,'' AUTO_CAL --자동계산 여부                  \n");
				sb.append("        	,'' AS ITEM_REMARK --ITEM_비고     	  \n");
				sb.append("        	,'' ATTACH_TXT                    \n");
				sb.append("        	,''ATTACH_REMARK                  \n");
				sb.append("        	,'2' SORT_CNT                     \n");
				sb.append("FROM DUAL                                  \n");
				sb.append("                                           \n");
				sb.append(" ORDER BY SORT_SEQ , EV_DSEQ            \n");

				
			/*	sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" SELECT GETEV_M_ITEMEXT1('EV001',C.EV_M_ITEM) AS EV_M_ITEM	--대분류평가항목                                                                                                      														  \n");
				sb.append("       ,GETEV_M_ITEMEXT1(C.EV_M_ITEM,C.EV_D_ITEM) AS EV_D_ITEM	--중분류평가항목                                                                                                      													  \n");
				sb.append("       ,C.EV_BASIC_POINT			-- 기본점수                                                                                                                            																				  \n");
				sb.append("       ,D.EV_ITEM_DESC				--평가요소                                                                                                                            																			  \n");
				sb.append("       ,D.EV_POINT				--배점                                                                                                                                																				  \n");
				sb.append(" ,(CASE WHEN C.EV_TYPE ='01'                                                       																									  \n");
				sb.append("              THEN (CASE WHEN C.EV_ITEM = '1'                                                    																						  \n");
				sb.append("                        THEN (D.ITEM_POINT1 + D.ITEM_POINT2 + D.ITEM_POINT3)       																									  \n");
				sb.append("  						ELSE  (CASE WHEN D.ITEM_POINT1 = '0'                                 							                           \n");
				sb.append("                                     THEN 0                                                   									     \n");
				sb.append("                                     ELSE (CASE WHEN D.ITEM_POINT2 = '0'                									           \n");
				sb.append("                                                 THEN 100                                									          \n");
				sb.append("                                                 ELSE ROUND((D.ITEM_POINT1 / D.ITEM_POINT2  * 100),2)  											     \n");
				sb.append("                                    		 END)                                         														   \n");	
				sb.append("                               END)                                                         													      \n");
				sb.append("                   END)                                                             																									  \n");
				sb.append("              ELSE 0                                                              																									  \n");
				sb.append("         END) AS ITEM_POINT_CAL    -- 업체기재                                     \n");
				sb.append("       ,(                                                                                        																					  \n");
				sb.append("          CASE WHEN C.EV_TYPE ='01'                                                                                                                     								  \n");
				sb.append(" 	          THEN (CASE WHEN C.EV_ITEM = '1'                                                                                               											  \n");
				sb.append(" 			            THEN (CASE WHEN TO_NUMBER(D.EV_MIN) <= TO_NUMBER(D.ITEM_POINT1 + D.ITEM_POINT2 + D.ITEM_POINT3)           															  \n");
				sb.append(" 			 	                       AND TO_NUMBER(D.ITEM_POINT1 + D.ITEM_POINT2 + D.ITEM_POINT3) < TO_NUMBER(D.EV_MAX)     																	  \n");
				sb.append(" 			 	                  THEN D.EV_POINT                                                                             																	  \n");
				sb.append(" 			 	                  ELSE 0                                                                                      																	  \n");
				sb.append(" 			                 END)                                                                                                 															  \n");
				sb.append(" 			            ELSE                                                                                                  																  \n");
				sb.append(" 			 	             (CASE WHEN D.ITEM_POINT2 = '0'                                                            																			  \n");
				sb.append(" 			                      THEN (CASE WHEN TO_NUMBER(D.EV_MIN) <= TO_NUMBER(100)                                   																	  \n");
				sb.append(" 			 	 	                             AND TO_NUMBER(100) < TO_NUMBER(D.EV_MAX)                                       																	  \n");
				sb.append(" 			 	 	                        THEN D.EV_POINT                                                                   																		  \n");
				sb.append(" 			 	 	                        ELSE 0                                                                            																		  \n");
				sb.append(" 			 	 	                        END)                                                                               																			  \n");
				sb.append(" 			 	                  ELSE (CASE WHEN TO_NUMBER(D.EV_MIN) <= TO_NUMBER(D.ITEM_POINT1 / D.ITEM_POINT2  * 100) 																		  \n");
				sb.append(" 			 	 	                             AND TO_NUMBER(D.ITEM_POINT1 / D.ITEM_POINT2  * 100) < TO_NUMBER(D.EV_MAX)      																	  \n");
				sb.append(" 			 	 	                        THEN D.EV_POINT                                                                  																		  \n");
				sb.append(" 			 	 	                        ELSE 0                                                                           																		  \n");
				sb.append(" 			 	 	                        END)                                                                              																		      \n");
				sb.append(" 			 	              END)                                                                                              																	  \n");
				sb.append(" 		            END)                                                                                                       	 													      \n");
				sb.append(" 	 	   ELSE 0                                                                                                                   												  \n");
				sb.append(" 		END                                                                                                                            												  \n");
				sb.append("        )                                   AS ITEM_POINT_SCORE   -- 업체배점                                                                                                         											 			  \n");
				sb.append("       ,D.REAL_SCORE                                              -- 실적                                                                                                             							 							  \n");
				sb.append(" , (CASE WHEN C.EV_TYPE ='01'                                                                                                                              		  \n");
				sb.append(" 		                   THEN (CASE WHEN C.EV_ITEM = '1'                                                                                                                    			  \n");
				sb.append(" 			                         THEN (CASE WHEN TO_NUMBER(D.EV_MIN) <= DECODE(D.REAL_SCORE,'0',TO_NUMBER(D.ITEM_POINT1 + D.ITEM_POINT2 + D.ITEM_POINT3),D.REAL_SCORE)    				  \n");
				sb.append(" 			 	                                    AND DECODE(D.REAL_SCORE,'0',TO_NUMBER(D.ITEM_POINT1 + D.ITEM_POINT2 + D.ITEM_POINT3),D.REAL_SCORE) < TO_NUMBER(D.EV_MAX) 					  \n");
				sb.append(" 			 	                               THEN D.EV_POINT                                                                                                               					  \n");
				sb.append(" 			 	                               ELSE 0                                                                                                                        					  \n");
				sb.append(" 			 	                          END)                                                                                                                          					  \n");
				sb.append(" 			 	                    ELSE                                                                                                                              					  \n");
				sb.append("                                          (CASE WHEN D.REAL_SCORE != '0'                                                                                                                                \n");
				sb.append(" 		 			 			   		       THEN (CASE WHEN TO_NUMBER(D.EV_MIN) <= TO_NUMBER(D.REAL_SCORE)          \n");
				sb.append(" 		 		 	 	                                       AND TO_NUMBER(D.REAL_SCORE) < TO_NUMBER(D.EV_MAX)               \n");
				sb.append(" 		 		 	 	                                  THEN D.EV_POINT                                                      \n");
				sb.append(" 		 		 	 	                                  ELSE 0                                                               \n");
				sb.append(" 		 	 	 	                                 END)                                                                                  \n");
				sb.append(" 		 			 			   		       ELSE (CASE WHEN D.ITEM_POINT2 = '0'                                     \n");
				sb.append(" 		 			               	   		              THEN (CASE WHEN TO_NUMBER(D.EV_MIN) <= TO_NUMBER(100)                      \n");
				sb.append(" 		 			 	 	            	                              AND TO_NUMBER(100) < TO_NUMBER(D.EV_MAX)                     \n");
				sb.append(" 		 			 	 	           		                         THEN D.EV_POINT                                          \n");
				sb.append(" 		 			 	 	            	                         ELSE 0                                                           \n");
				sb.append(" 		 			 	                                        END)                                                                      \n");
				sb.append(" 		 			 	                                  ELSE (CASE WHEN TO_NUMBER(D.EV_MIN) <= TO_NUMBER(D.REAL_SCORE)                 \n");
				sb.append(" 		 		 	 	                                                  AND TO_NUMBER(D.REAL_SCORE) < TO_NUMBER(D.EV_MAX)               \n");
				sb.append(" 		 		 	 	                                             THEN D.EV_POINT                                                      \n");
				sb.append(" 		 		 	 	                                             ELSE 0                                                               \n");
				sb.append(" 		 	 	 	                                            END)                                                                         \n");
				sb.append(" 		 	                                         END)                                                                                          \n");
				sb.append(" 	                                       END)                                                                                                                   \n");
				sb.append(" 	                            END)                                                                                                                              				  \n");
				sb.append(" 			              ELSE                                                                                                                                                  				  \n");
				sb.append("                                (CASE WHEN C.AUTO_CAL = 'Y'                                                                                                                                                 		  \n");
				sb.append(" 		                             THEN NVL(to_number(sheet_cal(C.AVG_EV_NO,C.CAL_TYPE,C.AVG_VALUE,C.SUM_EV_NO,'"+seller_code+"')),0)        			  \n");
				sb.append(" 		                        ELSE                                                                                                                            		  \n");
				sb.append(" 	 			                  (CASE WHEN D.ITEM_CHECK = 'Y'                                                                                        		  \n");
				sb.append(" 	 			      	               THEN D.EV_POINT                                                                                                 		  \n");
				sb.append(" 	 				                   ELSE 0                                                                                                      		  \n");
				sb.append(" 	 			                  END)                                                                                                                 		  \n");
				sb.append(" 		                        END)                                                                                                                                 		  \n");
				sb.append(" 		             END)																			 																					  \n");
				sb.append("  AS  SCORE             --점수																	 																			  \n");
				sb.append("        ,C.EV_REMARK				--비고                                                                                                                             																				      \n");
				sb.append("        ,D.EV_SEQ				                                                                                                                        					          \n");
				sb.append("        ,D.EV_REQSEQ			                                                                                                                              							  \n");
				sb.append("        ,getcodetext1('M050',C.EV_TYPE,'KO')  as EV_TYPE		                                                                                                                              \n");
				sb.append("        ,D.ITEM_CHECK		                                                                                                                              \n");
				sb.append("        ,C.EV_ITEM		                                                                                                                              \n");
				sb.append("        ,D.EV_DSEQ		                                                                                                                              \n");
				sb.append("        ,C.AUTO_CAL --자동계산 여부		                                                                                                                              \n");
				sb.append("        ,D.EV_REMARK AS ITEM_REMARK --ITEM_비고		                                                                                                                              \n");
				sb.append("        ,D.ATTACH_TXT		                                                                                                                              \n");
				sb.append(" FROM  SEVLN   C                                                                                                                                                                       \n");
				sb.append("      ,(                                                                                                                                                                               \n");
				sb.append("        SELECT  A.EV_NO                                                                                                                                                                \n");
				sb.append("               ,A.EV_SEQ                                                                                                                                                               \n");
				sb.append("               ,A.EV_DSEQ                                                                                                                                                              \n");
				sb.append("               ,A.EV_ITEM_DESC                                                                                                                                                         \n");
				sb.append("               ,A.EV_POINT                                                                                                                                                             \n");
				sb.append("               ,NVL(B.ITEM_POINT1,'0')  AS ITEM_POINT1                                                                                                                                 \n");
				sb.append("               ,NVL(B.ITEM_POINT2,'0')  AS ITEM_POINT2                                                                                                                                 \n");
				sb.append("               ,NVL(B.ITEM_POINT3,'0')  AS ITEM_POINT3                                                                                                                                 \n");
				sb.append("               ,NVL(B.REAL_SCORE,'0')   AS REAL_SCORE                                                                                                                                  \n");
				sb.append("               ,NVL(B.SCORE,'0')        AS SCORE                                                                                                                                       \n");
				sb.append("               ,B.ATTACH_TXT                                                                                                                                                           \n");
				sb.append("               ,A.EV_MAX                                                                                                                                                               \n");
				sb.append("               ,A.EV_MIN                                                                                                                                                               \n");
				sb.append("               ,B.EV_REQSEQ                                                                                                                                                            \n");
				sb.append("               ,B.ITEM_CHECK                                                                                                                                                           \n");
				sb.append("               ,B.EV_REMARK                                                                                                                                                           \n");
				sb.append("        FROM    SEVDT  A                                                                                                                                                               \n");
				sb.append("               ,SINVN  B                                                                                                                                                               \n");
				sb.append("        WHERE   A.EV_NO   = B.EV_NO                                                                                                                                                    \n");
				sb.append("        AND     A.EV_YEAR = B.EV_YEAR                                                                                                                                                  \n");
				sb.append("        AND     A.EV_SEQ  = B.EV_SEQ                                                                                                                                                   \n");
				sb.append("        AND     A.EV_DSEQ = B.EV_DSEQ                                                                                                                                                  \n");
				sb.append(sm.addSelectString("        AND     A.EV_NO   = ?                                                                                                                                       \n"));
				sm.addStringParameter(ev_no);
				sb.append(sm.addSelectString("        AND     B.EV_YEAR  = ?                                                                                                                                      \n"));
				sm.addStringParameter(ev_year);
				sb.append(sm.addSelectString("        AND     A.EV_YEAR  = ?                                                                                                                                     \n"));
				sm.addStringParameter(ev_year);
				sb.append(sm.addSelectString("        AND     B.VENDOR_CODE = ?                                                                                                                                   \n"));
				sm.addStringParameter(seller_code);
				sb.append(sm.addSelectString("        AND     B.SG_REGITEM = ?                                                                                                                                    \n"));
				sm.addStringParameter(sg_regitem);
				sb.append("       AND B.DEL_FLAG = 'N'                                                                                                                                                  	 	  \n");
				sb.append("       AND A.DEL_FLAG ='N'                                                                                                                                                 			  \n");
				sb.append("       AND B.EV_FLAG  = 'Y'                                                                                                                                                 			  \n");
				sb.append("       )       D                                                                                                                                                                       \n");
				sb.append(" WHERE  C.EV_SEQ   = D.EV_SEQ                                                                                                                                                          \n");
				sb.append(sm.addSelectString(" AND    C.EV_NO    = ?                                                                                                                                              \n"));
				sm.addStringParameter(ev_no);
				sb.append(sm.addSelectString(" AND    C.EV_YEAR  = ?                                                                                                                                              \n"));
				sm.addStringParameter(ev_year);
				sb.append(" AND    C.DEL_FLAG = 'N'                                                                                                                                                               \n");
				sb.append(" ORDER BY  D.EV_SEQ                                                                                                                                                                   \n");
				sb.append("          ,D.EV_DSEQ                                                                                                                                                                    \n");
*/
				
				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

				rtn[0] = sm.doSelect(sb.toString());

				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
//			System.out.println(new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);

		}

		return getSepoaOut();
	}
	
	
	public SepoaOut a_24_doScore_Cal(String[][] bean_args,HashMap header) throws Exception
	{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);


			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb = new StringBuffer();
			String language = info.getSession("LANGUAGE");
			String House_code = info.getSession("HOUSE_CODE");
			
			String ev_year     = (String) header.get("ev_year");
			String ev_no       = (String) header.get("ev_no");   
			String seller_code = (String) header.get("seller_code");  
			String eval_id     = (String) header.get("eval_id");
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				
				for (int i = 0; i < bean_args.length; i++)
				{
					String REAL_SCORE  = bean_args[i][0];
					String EV_SEQ      = bean_args[i][1];
					String EV_REQSEQ   = bean_args[i][2];
					String ITEM_CHECK  = bean_args[i][3];
					String EV_TYPE     = bean_args[i][4];
					String EV_DSEQ     = bean_args[i][5];
					String ITEM_REMARK = bean_args[i][6];
					String ATTACH_TXT  = JSPUtil.CheckInjection(JSPUtil.nullChk(bean_args[i][7]));
					
					if( ITEM_CHECK.equals("") ) 	ITEM_CHECK = "N";
				
						sm.removeAllValue();
						sb.delete(0, sb.length());
						sb.append(" UPDATE  SINVN SET         		\n");
						if( EV_TYPE.equals("정량") ){
							sb.append(" 		REAL_SCORE    = ? 	\n"); sm.addStringParameter(REAL_SCORE);
							sb.append(" 	   ,EV_REMARK     = ? 	\n"); sm.addStringParameter(ITEM_REMARK);
							sb.append(" 	   ,ATTACH_TXT    = ? 	\n"); sm.addStringParameter(ATTACH_TXT);
						}
						else{
							sb.append(" 		ITEM_CHECK    = ? 	\n");sm.addStringParameter(ITEM_CHECK);
						}
						sb.append(" 		WHERE EV_NO      = ?       	\n");sm.addStringParameter(ev_no); 
						sb.append(" 		AND  EV_YEAR     = ?       	\n");sm.addStringParameter(ev_year); 
						sb.append(" 		AND  EV_SEQ      = ?       	\n");sm.addStringParameter(EV_SEQ); 
						sb.append(" 		AND  EV_REQSEQ   = ?       	\n");sm.addStringParameter(EV_REQSEQ);
						sb.append(" 		AND  VENDOR_CODE = ?       	\n");sm.addStringParameter(seller_code);
						sb.append(" 		AND  EVAL_ID     = ?       	\n");sm.addStringParameter(eval_id);
						if( EV_TYPE.equals("정성") ){
							sb.append(" 	AND  EV_DSEQ     = ?       	\n");sm.addStringParameter(EV_DSEQ);
						}
						
						sm.doUpdate(sb.toString());
						
						if( EV_TYPE.equals("정성") && !"null".equals(ATTACH_TXT) ){
							sm.removeAllValue();
							sb.delete(0, sb.length());
							sb.append(" UPDATE  SINVN SET         		    \n");
							sb.append(" 	    ATTACH_TXT    = ? 	        \n");sm.addStringParameter(ATTACH_TXT);
							sb.append(" 		where EV_NO = ?       	    \n");sm.addStringParameter(ev_no); 
							sb.append(" 		AND  EV_YEAR = ?       	    \n");sm.addStringParameter(ev_year); 
							sb.append(" 		AND  EV_SEQ = ?       	    \n");sm.addStringParameter(EV_SEQ); 
							sb.append(" 		AND  EV_REQSEQ = ?       	\n");sm.addStringParameter(EV_REQSEQ);
							sb.append(" 		AND  VENDOR_CODE = ?       	\n");sm.addStringParameter(seller_code);
							sb.append(" 		AND  EVAL_ID     = ?       	\n");sm.addStringParameter(eval_id);
							sm.doUpdate(sb.toString());
						}
						
						
						if( EV_TYPE.equals("정성") && !"null".equals(ITEM_REMARK) ){
						sm.removeAllValue();
						sb.delete(0, sb.length());
						sb.append(" UPDATE  SINVN SET         		\n");
						sb.append(" 		EV_REMARK    = ? 	    \n");sm.addStringParameter(ITEM_REMARK);
						sb.append(" 		where EV_NO = ?       	\n");sm.addStringParameter(ev_no); 
						sb.append(" 		AND  EV_YEAR = ?       	\n");sm.addStringParameter(ev_year); 
						sb.append(" 		AND  EV_SEQ = ?       	\n");sm.addStringParameter(EV_SEQ); 
						sb.append(" 		AND  EV_REQSEQ = ?       	\n");sm.addStringParameter(EV_REQSEQ);
						sb.append(" 		AND  VENDOR_CODE = ?       	\n");sm.addStringParameter(seller_code);
						sb.append(" 		AND  EVAL_ID     = ?       	\n");sm.addStringParameter(eval_id);						
						sm.doUpdate(sb.toString());
						}
					
				}
				
				Commit();
				
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
//			System.out.println(new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);

		}

		return getSepoaOut();
	}
	
	
	public SepoaOut a_24_insert(String[][] bean_args,HashMap header) throws Exception
	{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb = new StringBuffer();
			SepoaFormater sf      = null;
			SepoaFormater sf1      = null;
			SepoaFormater sf2      = null;
			SepoaFormater sf3      = null;
			
			String language   = info.getSession("LANGUAGE");
			String House_code = info.getSession("HOUSE_CODE");
			
			String ev_year          = (String) header.get("ev_year");
			String ev_no            = (String) header.get("ev_no");   
			String seller_code      = (String) header.get("seller_code");  
			String sg_regitem	    =	(String) header.get("sg_regitem"); 
			String item_score_total	=	(String) header.get("item_score_total"); //업체배점합계
			String score_total	    =	(String) header.get("score_total"); //점수합계
			String eval_id   	    =	(String) header.get("eval_id");
			String VN_STATUS        = "";   // 적격/ 부적격
			
			Logger.sys.println("점수 합계 score_total = " + score_total);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			// SCORE 초기화
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append(" UPDATE  SINVN SET         		        \n");
			sb.append(" 		 SCORE             = '' 		\n");
			sb.append(" 		,TOTAL_SCORE       = ''		    \n"); 
			sb.append(" 		WHERE EV_NO       = ?       	\n");sm.addStringParameter(ev_no); 
			sb.append(" 		AND   EV_YEAR     = ?       	\n");sm.addStringParameter(ev_year); 
			sb.append(" 		AND   VENDOR_CODE = ?       	\n");sm.addStringParameter(seller_code);
			sb.append(" 		AND   SG_REGITEM  = ?       	\n");sm.addStringParameter(sg_regitem);
			sb.append(" 		AND   EVAL_ID     = ?       	\n");sm.addStringParameter(eval_id);
			sb.append(" 		AND   DEL_FLAG    = 'N'       	\n");
			sm.doUpdate(sb.toString());
				
				
				for (int i = 0; i < bean_args.length; i++)
				{
					String REAL_SCORE   = bean_args[i][0];
					String EV_SEQ       = bean_args[i][1];
					String EV_REQSEQ    = bean_args[i][2];
					String SCORE        = bean_args[i][3];
					String ITEM_CHECK   = bean_args[i][4];
					String EV_TYPE      = bean_args[i][5];
					String EV_DSEQ      = bean_args[i][6];
					String EV_POINT_REL = bean_args[i][7];
					
					Logger.sys.println("################################## REAL_SCORE  = " + REAL_SCORE);
					Logger.sys.println("################################## EV_SEQ      = " + EV_SEQ);
					Logger.sys.println("################################## EV_REQSEQ   = " + EV_REQSEQ);
					Logger.sys.println("################################## SCORE       = " + SCORE);
					Logger.sys.println("################################## EV_POINT_REL= " + EV_POINT_REL);
					Logger.sys.println("################################## ITEM_CHECK  = " + ITEM_CHECK);
					Logger.sys.println("################################## EV_TYPE     = " + EV_TYPE);
					Logger.sys.println("################################## EV_DSEQ     = " + EV_DSEQ);
					
					if( SCORE.equals("null") ){
						SCORE = EV_POINT_REL;
					}
					if( EV_TYPE.equals("정성") ){ // 정성
						if( ITEM_CHECK.equals("1") ){
							sm.removeAllValue();
							sb.delete(0, sb.length());						
							sb.append("			           SELECT  MIN(IN_REFITEM)  AS IN_REFITEM  		\n ");
							sb.append("                    FROM    SINVN 								\n ");
							sb.append("                    WHERE   1=1									\n ");
							sb.append(sm.addSelectString(" AND     EV_NO       = ?						\n ")); sm.addStringParameter(ev_no); 
							sb.append(sm.addSelectString(" AND     EV_YEAR     = ?						\n ")); sm.addStringParameter(ev_year);
							sb.append(sm.addSelectString(" AND     EV_SEQ      = ?						\n ")); sm.addStringParameter(EV_SEQ);
							sb.append(sm.addSelectString(" AND     EV_REQSEQ   = ?						\n ")); sm.addStringParameter(EV_REQSEQ);
							sb.append(sm.addSelectString(" AND     VENDOR_CODE = ?						\n ")); sm.addStringParameter(seller_code);
							sb.append(sm.addSelectString(" AND     SG_REGITEM  = ?						\n ")); sm.addStringParameter(sg_regitem);
							sb.append(sm.addSelectString(" AND     EVAL_ID     = ?       				\n ")); sm.addStringParameter(eval_id);
							sb.append("                    AND     ITEM_CHECK  = '1'					\n ");
							sb.append("                    AND     DEL_FLAG    = 'N'					\n ");

//							sb.append(" select                                           \n");
//							sb.append(" IN_REFITEM                                       \n");
//							sb.append("  from SEVDT A, SINVN B                           \n");
//							sb.append("  	where                                    \n");
//							sb.append("  	 A.EV_NO = B.EV_NO                       \n");
//							sb.append("  	AND A.EV_YEAR = B.EV_YEAR                \n");
//							sb.append("  	AND A.EV_DSEQ = B.EV_DSEQ                \n");
//							sb.append(sm.addSelectString("  	AND A.EV_NO = ?             \n"));sm.addStringParameter(ev_no); 
//							sb.append(sm.addSelectString(" 	AND  A.EV_YEAR = ?                  \n"));sm.addStringParameter(ev_year); 
//							sb.append(sm.addSelectString(" 	AND  A.EV_SEQ = ?               \n"));sm.addStringParameter(EV_SEQ); 
//							sb.append(sm.addSelectString(" 	AND  B.EV_REQSEQ = ?            \n"));sm.addStringParameter(EV_REQSEQ); 
//							sb.append(sm.addSelectString(" 	AND  B.VENDOR_CODE = ?            \n"));sm.addStringParameter(seller_code); 
//							sb.append(sm.addSelectString(" 	AND  A.EV_POINT = ?                   \n"));sm.addStringParameter(SCORE); 
//							sb.append(sm.addSelectString(" 	AND  B.SG_REGITEM = ?                \n"));sm.addStringParameter(sg_regitem); 
//							sb.append("  	AND B.DEL_FLAG ='N'               \n");
							
							
							sf = new SepoaFormater(sm.doSelect(sb.toString()));
							
							if(sf.getRowCount() != 0){
								sm.removeAllValue();
								sb.delete(0, sb.length());
								sb.append(" UPDATE  SINVN SET         			\n");
								sb.append(" 		 SCORE          = ? 		\n");sm.addStringParameter(SCORE);
								sb.append(" 		,TOTAL_SCORE    = ? 		\n");sm.addStringParameter(score_total);
								sb.append(" 		where EV_NO = ?       	\n");sm.addStringParameter(ev_no); 
								sb.append(" 		AND  EV_YEAR = ?       	\n");sm.addStringParameter(ev_year); 
								sb.append(" 		AND  EV_SEQ = ?       	\n");sm.addStringParameter(EV_SEQ); 
								sb.append(" 		AND  EV_REQSEQ = ?       	\n");sm.addStringParameter(EV_REQSEQ);
								sb.append(" 		AND  VENDOR_CODE = ?       	\n");sm.addStringParameter(seller_code);
								sb.append(" 		AND  IN_REFITEM = ?       	\n");sm.addStringParameter(sf.getValue("IN_REFITEM", 0));
								sb.append(" 		AND  SG_REGITEM = ?       	\n");sm.addStringParameter(sg_regitem);
								sb.append(" 		AND  EVAL_ID    = ?       	\n");sm.addStringParameter(eval_id);
								sm.doUpdate(sb.toString());
							}							
						}
					}else{// 정량
						sm.removeAllValue();
						sb.delete(0, sb.length());
						sb.append("			           SELECT  MIN(IN_REFITEM)  AS IN_REFITEM  		\n ");
						sb.append("                    FROM    SINVN 								\n ");
						sb.append("                    WHERE   1=1									\n ");
						sb.append(sm.addSelectString(" AND     EV_NO       = ?						\n ")); sm.addStringParameter(ev_no); 
						sb.append(sm.addSelectString(" AND     EV_YEAR     = ?						\n ")); sm.addStringParameter(ev_year);
						sb.append(sm.addSelectString(" AND     EV_SEQ      = ?						\n ")); sm.addStringParameter(EV_SEQ);
						sb.append(sm.addSelectString(" AND     EV_REQSEQ   = ?						\n ")); sm.addStringParameter(EV_REQSEQ);
						sb.append(sm.addSelectString(" AND     VENDOR_CODE = ?						\n ")); sm.addStringParameter(seller_code);
						sb.append(sm.addSelectString(" AND     EV_DSEQ     = ?						\n ")); sm.addStringParameter(EV_DSEQ);
						sb.append(sm.addSelectString(" AND     SG_REGITEM  = ?						\n ")); sm.addStringParameter(sg_regitem);
						sb.append(sm.addSelectString(" AND     EVAL_ID     = ?       				\n ")); sm.addStringParameter(eval_id);
						sb.append("                    AND     DEL_FLAG    = 'N'					\n ");
						
						sf = new SepoaFormater(sm.doSelect(sb.toString()));
						
						if(sf.getRowCount() != 0){
							sm.removeAllValue();
							sb.delete(0, sb.length());
							sb.append(" UPDATE  SINVN SET         		    \n");
							sb.append(" 		 SCORE    = ? 		        \n");sm.addStringParameter(SCORE);
							sb.append(" 		,TOTAL_SCORE    = ? 		\n");sm.addStringParameter(score_total);
							sb.append(" 		where EV_NO = ?       	    \n");sm.addStringParameter(ev_no); 
							sb.append(" 		AND  EV_YEAR = ?       	    \n");sm.addStringParameter(ev_year); 
							sb.append(" 		AND  EV_SEQ = ?       	    \n");sm.addStringParameter(EV_SEQ); 
							sb.append(" 		AND  EV_REQSEQ = ?       	\n");sm.addStringParameter(EV_REQSEQ);
							sb.append(" 		AND  VENDOR_CODE = ?       	\n");sm.addStringParameter(seller_code);
							sb.append(" 		AND  EV_DSEQ     = ?       	\n");sm.addStringParameter(EV_DSEQ);
							sb.append(" 		AND  SG_REGITEM = ?       	\n");sm.addStringParameter(sg_regitem);
							sb.append(" 		AND  EVAL_ID    = ?       	\n");sm.addStringParameter(eval_id);
							sm.doUpdate(sb.toString());
						}
					
					}
				}
	
				// 자동계산  심사표 가져와서  점수계산해서 다시 DB에 넣기
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("			 SELECT  A.EV_SEQ															\n ");
				sb.append("			        ,A.AVG_EV_NO                                                        \n ");
				sb.append("			        ,A.SUM_EV_NO                                                        \n ");
				sb.append("			        ,NVL(                                                               \n ");
				sb.append("			            (                                                               \n ");
				sb.append("			             SELECT  F.TOTAL_SCORE                                          \n ");
				sb.append("			             FROM    SEVVN    G                                             \n ");
				sb.append("			                   ,(                                                       \n ");
				sb.append("			                     SELECT  EV_NO                                          \n ");
				sb.append("			                            ,VENDOR_CODE                                    \n ");
				sb.append("			                            ,EV_YEAR                                        \n ");
				sb.append("			                            ,EV_FLAG                                        \n ");
				sb.append("			                            ,AVG( TOTAL_SCORE ) AS TOTAL_SCORE              \n ");
				sb.append("			                     FROM    SINVN                                          \n ");
				sb.append("			                     WHERE   1=1                                         	\n ");
				sb.append(sm.addSelectString("			 AND     EVAL_ID = ?	                                \n ")); sm.addStringParameter(eval_id);
				sb.append("			                     GROUP BY  EV_NO                                        \n ");
				sb.append("			                              ,VENDOR_CODE                                  \n ");
				sb.append("			                              ,EV_YEAR                                      \n ");
				sb.append("			                              ,EV_FLAG                                      \n ");
				sb.append("			                              ,EVAL_ID                                      \n ");
				sb.append("			                     )         F                                            \n ");
				sb.append("			 	         WHERE  1=1                                                     \n ");
				sb.append("			             AND    G.EV_NO       = F.EV_NO                                 \n ");
				sb.append("			 		     AND    G.EV_YEAR     = F.EV_YEAR                               \n ");
				sb.append("			 		     AND    G.SELLER_CODE = F.VENDOR_CODE                           \n ");
				sb.append("			 		     AND    F.EV_FLAG     = 'Y'                                     \n ");
				sb.append("			 		     AND    G.EV_NO       = AVG_EV_NO                               \n ");
				sb.append(sm.addSelectString("   AND    G.EV_YEAR     = ?                                  		\n ")); sm.addStringParameter(ev_year);
				sb.append(sm.addSelectString("   AND    G.SELLER_CODE = ?		                                \n ")); sm.addStringParameter(seller_code);
				sb.append("			            ), 0 )    AS AVG_EV_NO_SCORE                                    \n ");
				sb.append("			        ,NVL(                                                               \n ");
				sb.append("			            (                                                               \n ");
				sb.append("			             SELECT  F.TOTAL_SCORE                                          \n ");
				sb.append("			             FROM    SEVVN   G                                              \n ");
				sb.append("			                    ,(                                                      \n ");
				sb.append("			                      SELECT  EV_NO                                         \n ");
				sb.append("			                             ,VENDOR_CODE                                   \n ");
				sb.append("			                             ,EV_YEAR                                       \n ");
				sb.append("			                             ,EV_FLAG                                       \n ");
				sb.append("			                             ,AVG( TOTAL_SCORE ) AS TOTAL_SCORE             \n ");
				sb.append("			                      FROM    SINVN                                         \n ");
				sb.append("			                      WHERE   1=1                                         	\n ");
				sb.append(sm.addSelectString("			  AND     EVAL_ID = ?	                                \n ")); sm.addStringParameter(eval_id);
				sb.append("			 		              GROUP BY  EV_NO                                       \n ");
				sb.append("			 		                       ,VENDOR_CODE                                 \n ");
				sb.append("			 		                       ,EV_YEAR                                     \n ");
				sb.append("			 		                       ,EV_FLAG                                     \n ");
				sb.append("			 		                       ,EVAL_ID                                     \n ");
				sb.append("			 		              )       F                                             \n ");
				sb.append("			 	         WHERE  1=1                                                     \n ");
				sb.append("			             AND    G.EV_NO       = F.EV_NO                                 \n ");
				sb.append("			 		     AND    G.EV_YEAR     = F.EV_YEAR                               \n ");
				sb.append("			 		     AND    G.SELLER_CODE = F.VENDOR_CODE                           \n ");
				sb.append("			 		     AND    F.EV_FLAG     = 'Y'                                     \n ");
				sb.append("			 		     AND    G.EV_NO       = AVG_EV_NO                               \n ");
				sb.append(sm.addSelectString("	 AND    G.EV_YEAR     = ?                                  	    \n ")); sm.addStringParameter(ev_year);
				sb.append(sm.addSelectString("	 AND    G.SELLER_CODE = ?	                                    \n ")); sm.addStringParameter(seller_code);
				sb.append("			            ), 0 )    AS SUM_EV_NO_SCORE                                    \n ");
				sb.append("			                                                                            \n ");
				sb.append("			FROM  SEVLN A                                                               \n ");
				sb.append("			WHERE 1=1                                                                   \n ");
				sb.append(sm.addSelectString("	AND   EV_YEAR  = ?                                              \n ")); sm.addStringParameter(ev_year);
				sb.append(sm.addSelectString("	AND   EV_NO    = ?                                              \n ")); sm.addStringParameter(ev_no);
				sb.append("			AND   AUTO_CAL = 'Y'                                                        \n ");
				
				
				
				sf3 = new SepoaFormater(sm.doSelect(sb.toString()));
				for(int i=0;i< sf3.getRowCount();i++){
					String auto_ev_seq = sf3.getValue("EV_SEQ", i);
					String AVG_EV_NO_SCORE = sf3.getValue("AVG_EV_NO_SCORE", i);
					String SUM_EV_NO_SCORE = sf3.getValue("SUM_EV_NO_SCORE", i);
					
					sm.removeAllValue();
					sb.delete(0, sb.length());
					sb.append(" UPDATE  SINVN SET         		\n");
					sb.append(" 		AVG_EV_NO_SCORE    = ? 	\n");sm.addStringParameter(AVG_EV_NO_SCORE);
					sb.append(" 		,SUM_EV_NO_SCORE    = ? \n");sm.addStringParameter(SUM_EV_NO_SCORE);
					sb.append(" 		where EV_NO = ?       	\n");sm.addStringParameter(ev_no); 
					sb.append(" 		AND  EV_YEAR = ?       	\n");sm.addStringParameter(ev_year); 
					sb.append(" 		AND  EV_SEQ = ?       	\n");sm.addStringParameter(auto_ev_seq);
					sb.append(" 		AND  VENDOR_CODE = ?    \n");sm.addStringParameter(seller_code);
					sb.append(" 		AND  EVAL_ID     = ?    \n");sm.addStringParameter(eval_id);
					sm.doUpdate(sb.toString());
					
				}
				
				//////////////////////////////////////  자동계산 점수 UPDATE  끝 /////////////////////
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" UPDATE  SINVN SET         		        \n");
				sb.append(" 		TOTAL_SCORE       = ?		    \n");sm.addStringParameter(score_total);
				sb.append(" 		WHERE EV_NO       = ?       	\n");sm.addStringParameter(ev_no); 
				sb.append(" 		AND   EV_YEAR     = ?       	\n");sm.addStringParameter(ev_year); 
				sb.append(" 		AND   VENDOR_CODE = ?       	\n");sm.addStringParameter(seller_code);
				sb.append(" 		AND   SG_REGITEM  = ?       	\n");sm.addStringParameter(sg_regitem);
				sb.append(" 		AND   EVAL_ID     = ?       	\n");sm.addStringParameter(eval_id);
				sb.append(" 		AND   DEL_FLAG    = 'N'       	\n");
				sm.doUpdate(sb.toString());				
				
				
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" select                                \n");
				sb.append(" ACCEPT_VALUE                          \n");
				sb.append(" from SEVGL                            \n");
				sb.append(" where 1=1                             \n");
				sb.append(sm.addSelectString(" and EV_NO = ?            \n"));sm.addStringParameter(ev_no); 
				sb.append(sm.addSelectString(" and EV_YEAR   = ?                 \n"));sm.addStringParameter(ev_year); 
				sf1 = new SepoaFormater(sm.doSelect(sb.toString()));
				String accept_value = sf1.getValue("ACCEPT_VALUE", 0);
				
				if(Double.parseDouble(accept_value) <= Double.parseDouble(score_total)){
					VN_STATUS = "WG";
				}else{
					VN_STATUS = "WC";
				}
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" UPDATE  SEVVN SET         		\n");
				sb.append(" 		TEB_ID    = ? 	\n");sm.addStringParameter(info.getSession("ID"));
				sb.append(" 		,SCORE    = ? 	\n");sm.addStringParameter(score_total);
				sb.append(" 		,VN_SCORE    = ? 	\n");sm.addStringParameter(item_score_total);
				sb.append(" 		,EV_DATE    = ? 	\n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append(" 		,VN_STATUS    = ? 	\n");sm.addStringParameter(VN_STATUS);
				sb.append(" 		where EV_NO = ?       	\n");sm.addStringParameter(ev_no); 
				sb.append(" 		AND  EV_YEAR = ?       	\n");sm.addStringParameter(ev_year); 
				sb.append(" 		AND  SG_REGITEM = ?       	\n");sm.addStringParameter(sg_regitem);
				sb.append(" 		AND  SELLER_CODE = ?       	\n");sm.addStringParameter(seller_code);
				sm.doUpdate(sb.toString());
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" 				SELECT           											\n");
				sb.append(" 						count(A.ev_no) 	  cnt           					\n");
				sb.append(" 						,count(A.ev_date) cnt1           					\n");
				sb.append(" 				FROM SEVVN A,      											\n"); 
				sb.append("              		(SELECT EV_NO, VENDOR_CODE, EV_YEAR,EV_FLAG FROM SINVN  \n");
				sb.append("                      WHERE 1=1 												\n");
				sb.append(sm.addSelectString("   and EV_NO = ? 											\n"));sm.addStringParameter(ev_no); 
				sb.append(sm.addSelectString("   AND  EV_YEAR = ? 										\n"));sm.addStringParameter(ev_year);
				sb.append("                      AND   NVL(DEL_FLAG,'N') = 'N' 							\n");
				sb.append("                      GROUP BY EV_NO ,VENDOR_CODE , EV_YEAR, EV_FLAG,EVAL_ID \n");
				sb.append("              		) B \n");
				sb.append(" 					WHERE 1=1       					\n"); 
				sb.append(" 					AND  A.EV_NO = B.EV_NO              \n");
				sb.append(" 					AND  A.EV_YEAR = B.EV_YEAR 			\n");
				sb.append(" 					AND  A.SELLER_CODE = B.VENDOR_CODE 	\n");
				sb.append(sm.addSelectString(" 	AND  A.EV_NO 			 = ?       	\n"));sm.addStringParameter(ev_no); 
				sb.append(sm.addSelectString(" 	AND  A.EV_YEAR 			 = ?       	\n"));sm.addStringParameter(ev_year); 
				sb.append(" 					AND  B.EV_FLAG           = 'Y'      \n");
				sb.append(" 					AND  NVL(A.DEL_FLAG,'N') = 'N'      \n");
				sf2 = new SepoaFormater(sm.doSelect(sb.toString()));
				String cnt = sf2.getValue("cnt", 0);
				String cnt1 = sf2.getValue("cnt1", 0);
				
				if(cnt.equals(cnt1)){
					sm.removeAllValue();
					sb.delete(0, sb.length());
					sb.append(" UPDATE  SEVGL SET         		\n");
					sb.append(" 		SHEET_STATUS    = ? 	\n");sm.addStringParameter("E");
	
					sb.append(" 		where EV_NO = ?       	\n");sm.addStringParameter(ev_no); 
					sb.append(" 		AND  EV_YEAR = ?       	\n");sm.addStringParameter(ev_year); 
					sm.doUpdate(sb.toString());
				}
				
				Commit();
				
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
//			System.out.println(new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);

		}

		return getSepoaOut();
	}


	public SepoaOut a_24_cancel( String to_year, String ev_no ) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;
			rtn = et_a_24_cancel( to_year, ev_no );

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
	
	private String[] et_a_24_cancel( String to_year, String ev_no ) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		String user_id        = info.getSession("ID");
		    
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sm.removeAllValue();
			sb.delete( 0, sb.length() );
			sb.append("		UPDATE SEVGL SET 						\n ");
			sb.append("		                 SHEET_STATUS = 'C'     \n ");
			sb.append("				   WHERE EV_YEAR      = ?       \n "); sm.addStringParameter(to_year);
			sb.append("				   AND   EV_NO        = ?       \n "); sm.addStringParameter(ev_no);
			sb.append("				   AND   DEL_FLAG     = 'N'     \n ");
			sm.doUpdate(sb.toString());
			
			sm.removeAllValue();
			sb.delete( 0, sb.length() );
			sb.append("		UPDATE SINVN SET 						\n ");
			sb.append("		                 ST_DATE      = ''      \n ");
			sb.append("		                ,ET_DATE      = ''      \n ");
			sb.append("		                ,REG_DATE     = ''      \n ");
			sb.append("		                ,EV_FLAG      = ''      \n ");
			sb.append("				   WHERE EV_YEAR      = ?       \n "); sm.addStringParameter(to_year);
			sb.append("				   AND   EV_NO        = ?       \n "); sm.addStringParameter(ev_no);
			sb.append("				   AND   DEL_FLAG     = 'N'     \n ");			
			sm.doUpdate(sb.toString());
			
//			sm.removeAllValue();
//			sb.delete( 0, sb.length() );
//			sb.append("		UPDATE SINVN SET 						\n ");
//			sb.append("		                 DEL_FLAG     = 'Y'     \n ");
//			sb.append("				   WHERE EV_YEAR      = ?       \n "); sm.addStringParameter(to_year);
//			sb.append("				   AND   EV_NO        = ?       \n "); sm.addStringParameter(ev_no);
//			sb.append("				   AND   DEL_FLAG     = 'N'     \n ");			
//			sm.doUpdate(sb.toString());
			
			sm.removeAllValue();
			sb.delete( 0, sb.length() );
			sb.append("		UPDATE SEVVN SET  						\n ");
			sb.append("		                  TEB_ID       = ''     \n ");
			sb.append("		                 ,SCORE        = ''     \n ");
			sb.append("		                 ,REAL_SCORE   = ''     \n ");
			sb.append("		                 ,VN_SCORE     = ''     \n ");
			sb.append("		                 ,EV_DATE      = ''     \n ");
			sb.append("		                 ,REG_DATE     = ''     \n ");
			sb.append("		                 ,VN_STATUS    = 'N'    \n ");
			sb.append("		                 ,CONFIRM_FLAG = ''     \n ");
			sb.append("				   WHERE  EV_YEAR      = ?      \n "); sm.addStringParameter(to_year);
			sb.append("				   AND    EV_NO        = ?      \n "); sm.addStringParameter(ev_no);
			sb.append("				   AND    DEL_FLAG     = 'N'    \n ");			
			sm.doUpdate(sb.toString());			

			sm.removeAllValue();
			sb.delete( 0, sb.length() );
			sb.append("		UPDATE SRGVN SET 						\n ");
			sb.append("		                 DEL_FLAG     = 'Y'     \n ");
			sb.append("				   WHERE EV_YEAR      = ?       \n "); sm.addStringParameter(to_year);
			sb.append("				   AND   EV_NO        = ?       \n "); sm.addStringParameter(ev_no);
			sb.append("				   AND   DEL_FLAG     = 'N'     \n ");				
			sm.doUpdate(sb.toString());		

			sm.removeAllValue();
			sb.delete( 0, sb.length() );
			sb.append("		UPDATE SRGVD SET 						\n ");
			sb.append("		                 DEL_FLAG     = 'Y'     \n ");
			sb.append("				   WHERE EV_YEAR      = ?       \n "); sm.addStringParameter(to_year);
			sb.append("				   AND   EV_NO        = ?       \n "); sm.addStringParameter(ev_no);
			sb.append("				   AND   DEL_FLAG     = 'N'     \n ");					
			sm.doUpdate(sb.toString());	
			
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
