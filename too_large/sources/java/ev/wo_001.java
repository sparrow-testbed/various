package ev;


import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
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
import sepoa.fw.util.SepoaString;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.MapUtils;

public class WO_001 extends SepoaService
{
	private String ID = info.getSession("ID");

	public WO_001(String opt,SepoaInfo info) throws SepoaServiceException 
	{ 
		super(opt,info); 
		setVersion("1.0.0"); 
	}
	Message msg = new Message(info,"FW"); 
 
	/**
	 * 심사표 조회
	 * @method ev_bd_lis1
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-12-01
	 * @modify 2014-12-01
	 */
	public SepoaOut ev_bd_lis1(Map<String, String> header) throws Exception{
		
		try 
		{ 
	        String user_id = info.getSession("ID"); 
			Logger.debug.println(user_id,this,"######ev_bd_lis1#######"); 
			String rtn = ""; 
			// Isvalue(); .... 
			rtn = et_ev_bd_lis1(header); 
 
			setValue(rtn); 
			setStatus(1); 
			setMessage(msg.getMessage("0000")); 
		}catch(Exception e) 
		{ 
		    Logger.err.println("Exception e =" + e.getMessage()); 
			setStatus(0); 
			setMessage(msg.getMessage("0001")); 
			Logger.err.println(this,e.getMessage()); 
		} 
		return getSepoaOut(); 
		
		
	}
	
	/**
	 * 심사표 조회 쿼리
	 * @method et_ev_bd_lis1
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-12-08
	 * @modify 2014-12-08
	 */
	private String et_ev_bd_lis1(Map<String, String> header) throws Exception{
		String rtn = ""; 
		ConnectionContext ctx = getConnectionContext();
		header.put("I_HOUSE_CODE", info.getSession("HOUSE_CODE"));
		
		try 
		{
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			//wxp.addVar("dept_name", header.get("I_DEPT_NAME"));
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			 
			rtn = sm.doSelect(header); 
 
			if(rtn == null) throw new Exception("SQL Manager is Null"); 
    	}
		catch(Exception e) 
		{ 
			throw new Exception("et_ev_bd_lis1:"+e.getMessage()); 
    	} 
		finally
    	{ 
		 
		} 
		return rtn; 
	}

	
	/**
	 * //	 평가 sheet 등록 팝업  등록 탭 detail
	 * @method getSEVGL_detail
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-12-02
	 * @modify 2014-12-02
	 */
	
public SepoaOut getSEVGL_detail(Map<String, String> header) throws Exception{
		
		try 
		{ 
	        String user_id = info.getSession("ID"); 
			Logger.debug.println(user_id,this,"######ev_bd_lis1#######"); 
			String rtn = ""; 
			// Isvalue(); .... 
			rtn = et_getSEVGL_detail(header); 
 
			setValue(rtn); 
			setStatus(1); 
			setMessage(msg.getMessage("0000")); 
		}catch(Exception e) 
		{ 
		    Logger.err.println("Exception e =" + e.getMessage()); 
			setStatus(0); 
			setMessage(msg.getMessage("0001")); 
			Logger.err.println(this,e.getMessage()); 
		} 
		return getSepoaOut(); 
		
		
	}


	private String et_getSEVGL_detail(Map<String, String> header) throws Exception{
		String rtn = ""; 
		ConnectionContext ctx = getConnectionContext();
		header.put("I_HOUSE_CODE", info.getSession("HOUSE_CODE"));
		
		try 
		{
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("dept_name", header.get("I_DEPT_NAME"));
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			 
			rtn = sm.doSelect(header); 
 
			if(rtn == null) throw new Exception("SQL Manager is Null"); 
    	}
		catch(Exception e) 
		{ 
			throw new Exception("et_getSEVGL_detail:"+e.getMessage()); 
    	} 
		finally
    	{ 
		 
		} 
		return rtn; 
	}

	/**
	 * // 심사표 저장
	 * @method getsevgl_insert
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-12-08
	 * @modify 2014-12-08
	 */
	public SepoaOut getsevgl_insert(String[][] bean_args, Map<String, String> data) throws Exception 
	{
		ConnectionContext         ctx      = null;
        SepoaXmlParser            sxp      = null;
		SepoaSQLManager           ssm      = null;
		Map<String, String>       header   = null;
		List<Map<String, String>> grid     = null;
		Map<String, String>       gridInfo = null;
		String                    id       = info.getSession("ID");
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			header     = MapUtils.getMap(data, "headerData"); // 헤더 정보 조회
			
			String ev_no            = header.get("ev_no");   
			                        
			String sheet_kind       = header.get("sheet_kind");     
			String sg_kind          = header.get("sg_kind");       
			String period           = header.get("period");
			String use_flag         = header.get("use_flag");  
			String ev_year          = header.get("ev_year");
			String accept_value     = header.get("accept_value");
			String st_date          = header.get("st_date");
			String end_date         = header.get("end_date");
			String subject          = header.get("subject");
			String sheet_status     = header.get("sheet_status");
			
			String sg_refitem = "";
			String ev_pass	="";
			
			header.put( "st_date  ".trim(), SepoaString.getDateUnSlashFormat( st_date  ) );
			header.put( "end_date ".trim(), SepoaString.getDateUnSlashFormat( end_date ) );
			
			if("false".equals(use_flag)){header.put("use_flag", "N");}else{header.put("use_flag", "Y");}
			
			SepoaFormater sf = null;

			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			
			for (int i = 0; i < bean_args.length; i++)
			{
				String sg_type1 = bean_args[i][0];
				String sg_type2 = bean_args[i][1];
				String sg_type3 = bean_args[i][2];
					if(i == bean_args.length-1){
						sg_refitem += "'"+sg_type3+"'";
					}else{
						sg_refitem += "'"+sg_type3+"',";
					}
				
			}
			
			//header.put("sg_refitem", sg_refitem);
			header.put("USER_ID", info.getSession("ID"));

			sxp = new SepoaXmlParser(this, "et_getsevgl_list");
			sxp.addVar("sg_refitem", sg_refitem);
            ssm = new SepoaSQLManager(id, this, ctx, sxp);
            sf = new SepoaFormater(ssm.doSelect(header));
			
            if("".equals(ev_no)){
				
				SepoaOut wo = DocumentUtil.getDocNumber(info, "EV");
				String EV_NO = wo.result[0];
				
				header.put("EV_NO", EV_NO);
				
				sxp = new SepoaXmlParser(this, "et_setInsert_sevgl");
	            ssm = new SepoaSQLManager(id, this, ctx, sxp);
	            ssm.doInsert(header);
	            
	            ev_pass = EV_NO;
				
//	            System.out.println(sf.getRowCount()+"===cnt" );
				for (int i = 0; i < sf.getRowCount(); i++){
					
					Map<String, String> paramInfo = new HashMap<String, String>();
					
	                sxp = new SepoaXmlParser(this, "et_setInsert_sevvn");
	                ssm = new SepoaSQLManager(id, this, ctx, sxp);
	                
	                //gridInfo.put("HOUSE_CODE",   info.getSession("HOUSE_CODE"));
	                //gridInfo.put("USER_ID",      info.getSession("ID"));
	                //gridInfo.put("COMPANY_CODE", info.getSession("COMPANY_CODE"));
	                paramInfo.put("EV_NO",        EV_NO);
	                paramInfo.put("EV_YEAR",      ev_year);
	                paramInfo.put("SG_REFITEM",   sf.getValue("SG_REFITEM", i));
	                paramInfo.put("VENDOR_CODE",  sf.getValue("VENDOR_CODE", i));
	                
	                ssm.doInsert(paramInfo);
	            }
            }else{
            	
            	ev_pass = ev_no;
            	
            	//수정
            	sxp = new SepoaXmlParser(this, "et_setUpdate_sevgl");
	            sxp.addVar("sheet_status", sheet_status);
            	ssm = new SepoaSQLManager(id, this, ctx, sxp);
	            ssm.doInsert(header);
	            
	            //상세정보 삭제
	            sxp = new SepoaXmlParser(this, "et_setDelete_sevvn");
            	ssm = new SepoaSQLManager(id, this, ctx, sxp);
	            ssm.doDelete(header);
            	
	            for (int i = 0; i < sf.getRowCount(); i++){
					
					Map<String, String> paramInfo = new HashMap<String, String>();
					
	                sxp = new SepoaXmlParser(this, "et_setInsert_sevvn");
	                ssm = new SepoaSQLManager(id, this, ctx, sxp);
	                
	                paramInfo.put("EV_NO", 		  ev_pass);
	                paramInfo.put("EV_YEAR", 	  ev_year);
	                paramInfo.put("HOUSE_CODE",   info.getSession("HOUSE_CODE"));
	                paramInfo.put("USER_ID",      info.getSession("ID"));
	                paramInfo.put("COMPANY_CODE", info.getSession("COMPANY_CODE"));
	                paramInfo.put("SG_REFITEM",   sf.getValue("SG_REFITEM", i));
	                paramInfo.put("VENDOR_CODE",  sf.getValue("VENDOR_CODE", i));
	                
	                ssm.doInsert(paramInfo);
	            }
            	
            }
            setMessage(ev_pass); 
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		finally {}

		return getSepoaOut();
	}
	
	/*public SepoaOut getsevgl_insert(Map<String, String> data) throws Exception 
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
			String ID = info.getSession("ID");
			SepoaFormater sf = null;

			String ev_no     = (String) header.get("ev_no");   
			String sheet_kind   = (String) header.get("sheet_kind");     
			String sg_kind   = (String) header.get("sg_kind");       
			String period     = (String) header.get("period");
			String use_flag     = (String) header.get("use_flag");  
			String ev_year     = (String) header.get("ev_year");
			String accept_value     = (String) header.get("accept_value");
			String st_date     = (String) header.get("st_date");
			String end_date     = (String) header.get("end_date");
			String subject     = (String) header.get("subject");
			String sheet_status     = (String) header.get("sheet_status");
			
			String sg_refitem = "";
			String ev_pass	="";
			
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			for (int i = 0; i < bean_args.length; i++)
			{
				String sg_type1 = bean_args[i][0];
				String sg_type2 = bean_args[i][1];
				String sg_type3 = bean_args[i][2];
					if(i == bean_args.length-1){
						sg_refitem += "'"+sg_type3+"'";
					}else{
						sg_refitem += "'"+sg_type3+"',";
					}
				
			}
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append(" SELECT A.SG_REFITEM, A.VENDOR_CODE, B.name_loc		\n");
			sb.append(" FROM SSGVN A,ICOMVNGL B		\n");
			sb.append(" WHERE 1=1 				 							\n");
			sb.append(" and  A.VENDOR_CODE = B.VENDOR_CODE 				 							\n");
			sb.append(" and A.sg_refitem in ("+sg_refitem+") 				 							\n");
			sb.append(" and A.del_flag='N' 				 							\n");
			sb.append(" and A.apply_flag='Y'				 							\n");
			sb.append(sm.addSelectString(" and SUBSTR(A.ADD_DATE,1,4)= ?				 							\n"));sm.addStringParameter(ev_year);
			sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));
			
			
			if("".equals(ev_no)){
				
				SepoaOut wo = DocumentUtil.getDocNumber(info, "EV");
				String EV_NO = wo.result[0];
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" INSERT INTO SEVGL (         \n");
				sb.append(" 		 EV_NO          		\n");
				sb.append(" 		,EV_YEAR        		\n");
				sb.append(" 		,SUBJECT        		\n");
				sb.append(" 		,SHEET_KIND     		\n");
				sb.append(" 		,SG_KIND        		\n");
				sb.append(" 		,PERIOD           		\n");
				sb.append(" 		,USE_FLAG       		\n"); 
				sb.append(" 		,ACCEPT_VALUE   		\n");
				sb.append(" 		,ST_DATE        		\n");
				sb.append(" 		,END_DATE       		\n");
				sb.append(" 		,ADD_DATE         		\n");
				sb.append(" 		,ADD_USER_ID    		\n");
				sb.append(" 		,CHANGE_DATE    		\n");
				sb.append(" 		,CHANGE_USER_ID 		\n");
				sb.append(" 		,DEL_FLAG       		\n"); 
				sb.append(" 		,SHEET_STATUS   		\n"); 				
				sb.append(" ) VALUES (                     \n");
				sb.append("      '"+EV_NO+"'                         \n");
				sb.append("      ,?                         \n");sm.addStringParameter(ev_year);
				sb.append("      ,?                         \n");sm.addStringParameter(subject);
				sb.append("      ,?                         \n");sm.addStringParameter(sheet_kind);
				sb.append("      ,?                         \n");sm.addStringParameter(sg_kind);
				sb.append("      ,?                         \n");sm.addStringParameter(period);
				sb.append("      ,?                         \n");sm.addStringParameter(use_flag);
				sb.append("      ,?                         \n");sm.addStringParameter(accept_value);
				sb.append("      ,?                         \n");sm.addStringParameter(st_date);
				sb.append("      ,?                         \n");sm.addStringParameter(end_date);
				sb.append("      ,?                         \n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("      ,?                         \n");sm.addStringParameter(info.getSession("ID"));
				sb.append("      ,?                         \n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("      ,?                         \n");sm.addStringParameter(info.getSession("ID"));
				sb.append("      ,'N'                         \n");
				sb.append("      ,'W'                         \n");
				
				sb.append(" )                              \n");
				sm.doInsert(sb.toString());
				ev_pass = EV_NO;
				
				
				
				
	        	System.out.println(sf.getRowCount()+"===cnt" );
					for (int i = 0; i < sf.getRowCount(); i++)
					{

						sm.removeAllValue();
						sb.delete(0, sb.length());
						sb.append(" INSERT INTO SEVVN (         \n");
						sb.append(" 		 EV_NO          		\n");
						sb.append(" 		,EV_YEAR        		\n");
						sb.append(" 		,SG_REGITEM        		\n");
						sb.append(" 		,SELLER_CODE     		\n");
								
						sb.append(" ) VALUES (                     \n");
						sb.append("      '"+EV_NO+"'                         \n");
						sb.append("      ,?                         \n");sm.addStringParameter(ev_year);
						sb.append("      ,?                         \n");sm.addStringParameter(sf.getValue("SG_REFITEM", i));
						sb.append("      ,?                         \n");sm.addStringParameter(sf.getValue("VENDOR_CODE", i));
						sb.append(" )                              \n");
						sm.doInsert(sb.toString());
					}
					
			}else{
				ev_pass = ev_no;
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" UPDATE  SEVGL SET         \n");
				sb.append(" 		SUBJECT     =?   		\n");sm.addStringParameter(subject);
				sb.append(" 		,SHEET_KIND    =? 		\n");sm.addStringParameter(sheet_kind);
				sb.append(" 		,SG_KIND	=?        		\n");sm.addStringParameter(sg_kind);
				sb.append(" 		,PERIOD       =?    		\n");sm.addStringParameter(period);
				sb.append(" 		,USE_FLAG    =?   		\n"); sm.addStringParameter(use_flag);
				sb.append(" 		,ACCEPT_VALUE  =? 		\n");sm.addStringParameter(accept_value);
				sb.append(" 		,ST_DATE      =?  		\n");sm.addStringParameter(st_date);
				sb.append(" 		,END_DATE     =?  		\n");sm.addStringParameter(end_date);
				sb.append(" 		,CHANGE_DATE   =? 		\n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append(" 		,CHANGE_USER_ID =?		\n");sm.addStringParameter(info.getSession("ID"));
				if(!"R".equals(sheet_status)){
				sb.append(" 		,SHEET_STATUS = 'W'  	\n"); 	
				}
				sb.append(" 		WHERE  EV_NO = ?  		\n");sm.addStringParameter(ev_no);
				sb.append(" 		AND  EV_YEAR = ?  		\n");sm.addStringParameter(ev_year);
				sm.doUpdate(sb.toString());
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" DELETE FROM SEVVN          \n");
				sb.append(" 		 WHERE EV_NO = ?          		\n");sm.addStringParameter(ev_no);
				sb.append(" 		 AND EV_YEAR = ?          		\n");sm.addStringParameter(ev_year);
				sm.doDelete(sb.toString());
				
				for (int i = 0; i < sf.getRowCount(); i++)
				{

					sm.removeAllValue();
					sb.delete(0, sb.length());
					sb.append(" INSERT INTO SEVVN (         \n");
					sb.append(" 		 EV_NO          		\n");
					sb.append(" 		,EV_YEAR        		\n");
					sb.append(" 		,SG_REGITEM        		\n");
					sb.append(" 		,SELLER_CODE     		\n");
							
					sb.append(" ) VALUES (                     \n");
					sb.append("      '"+ev_no+"'                         \n");
					sb.append("      ,?                         \n");sm.addStringParameter(ev_year);
					sb.append("      ,?                         \n");sm.addStringParameter(sf.getValue("SG_REFITEM", i));
					sb.append("      ,?                         \n");sm.addStringParameter(sf.getValue("VENDOR_CODE", i));
					sb.append(" )                              \n");
					sm.doInsert(sb.toString());
				}
				
			}
			
			
				Commit();
				
				rtn[0] = ev_pass;
				setValue(rtn[0]);
				
		}
		catch (Exception e)
		{
			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			System.out.println(new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);

		}

		return getSepoaOut();
	}
*/


	/*public SepoaOut getSEVGL_detail(String ev_no, String ev_year) throws Exception
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
			
			System.out.println(ev_year+"=년도");
			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				sm.removeAllValue();
				sb.delete(0, sb.length());

				sb.append("  SELECT                                                                     		\n");
				sb.append("   SEQ	--대분류 순서  		\n");
				sb.append("  ,EV_M_ITEM	--대분류평가항목  		\n");
				sb.append("  ,EV_D_ITEM	--중분류평가항목   		\n");
				sb.append("  ,EV_ITEM_DESC			--평가요소                        		\n");
				sb.append("  ,EV_POINT				--배점                             		\n");
				sb.append("  ,EV_POINT				--배점                             		\n");
				sb.append("  ,EV_SEQ				--상세분류항번                             		\n");
				sb.append("  ,EV_DSEQ				--세분류항번                             		\n");
				sb.append("  ,EV_REMARK				--비고                             		\n");
				sb.append("  FROM (		\n");
				
				sb.append("   SELECT                            			                                \n");
				sb.append("    TO_NUMBER(SUBSTR(EV_M_ITEM,3)) SEQ                                    	    \n");
				sb.append("    ,GETEV_M_ITEMEXT1('EV001',EV_M_ITEM) AS EV_M_ITEM     --대분류평가항목    		\n");
				sb.append("    ,GETEV_M_ITEMEXT1(EV_M_ITEM,EV_D_ITEM) AS EV_D_ITEM --중분류평가항목       			\n");
				sb.append("    ,EV_ITEM_DESC    --평가요소                                                							\n");
				sb.append("    ,EV_POINT    --배점                                                       								\n");
				sb.append("    ,EV_REMARK    --비고                                                      								\n");
				sb.append("    ,A.EV_SEQ EV_SEQ   --상세분류항번                                          							\n");
				sb.append("    ,B.EV_DSEQ EV_DSEQ   --세분류항번                                         							\n");
				sb.append("    FROM SEVLN A,SEVDT B, SCODE C                                              	\n");
				sb.append("    WHERE A.EV_SEQ = B.EV_SEQ                                                  	\n");
				sb.append(sm.addSelectString(" AND A.EV_NO = ?												\n"));sm.addStringParameter(ev_no);
				sb.append(sm.addSelectString(" AND A.EV_YEAR = ?											\n"));sm.addStringParameter(ev_year);
				sb.append("    AND A.DEL_FLAG = 'N'                                                       	\n");
				sb.append("    AND C.TYPE='EV001'                                                         	\n");
				sb.append("    AND NVL(C.DEL_FLAG,'N') = 'N'                                                \n");
				sb.append("    AND EV_M_ITEM = C.CODE                                                     	\n");
				sb.append("    ORDER BY  TO_NUMBER(C.SORT_SEQ) , B.EV_DSEQ                   		       	\n");
				sb.append(" )		\n");

				  

				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

				rtn[0] = sm.doSelect(sb.toString());
			
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			System.out.println(new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);

		}

		return getSepoaOut();
	}*/
	
	
	public SepoaOut ev_pp_ins2(String eval_no, String eval_seq ) throws Exception
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

			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" SELECT												\n");
				sb.append(" 	EVAL_NO                                         \n");
				sb.append(" 	, EVAL_SEQ										\n");
				sb.append(" 	, GRADE											\n");
				sb.append(" 	, GRADE_TEXT									\n");
				sb.append(" 	, POINT											\n"); 
				sb.append(" FROM ICOYEVDT                                      \n");
				sb.append(" WHERE 1=1                                     \n");				
				sb.append(sm.addSelectString("  AND HOUSE_CODE = ?			      \n"));
				sm.addStringParameter(House_code);
				sb.append(sm.addSelectString("   AND EVAL_NO		= ?			     \n")); 
				sm.addStringParameter(eval_no);
				sb.append(sm.addSelectString("   AND EVAL_SEQ	= ?			   \n")); 
				sm.addStringParameter(eval_seq);
	 
				
				sb.append(" ORDER BY 1																				\n"); 
	 
				
				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

				rtn[0] = sm.doSelect(sb.toString());
			
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}
	
	
	public SepoaOut getEVDT(String eval_no, String eval_seq ) throws Exception
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

			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" SELECT										\n");
				sb.append(" 	EVAL_NO									\n");
				sb.append(" 	, GRADE_ITEM							\n");
				sb.append(" 	, STAGE									\n");
				sb.append(" 	, DESCRIPTION							\n"); 
				sb.append(" 	, REMARK								\n"); 
				sb.append(" FROM ICOYEVDT								\n");
				sb.append(" WHERE 1=1                                     \n");				
				sb.append(sm.addSelectString("  AND HOUSE_CODE = ?			      \n"));
				sm.addStringParameter(House_code);
				sb.append(sm.addSelectString("   AND EVAL_NO		= ?			     \n")); 
				sm.addStringParameter(eval_no);
				sb.append(sm.addSelectString("   AND EVAL_SEQ	= ?			   \n")); 
				sm.addStringParameter(eval_seq);
				
	 
				
				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

				rtn[0] = sm.doSelect(sb.toString());
			
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}
	
	public SepoaOut ev_pp_dis1_detail(SepoaInfo info, String eval_no) throws Exception
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
			

			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" SELECT																\n");
				sb.append(" 	EVDT.EVAL_NO                                                 	\n");
				sb.append(" 	,EVDT.EVAL_SEQ                                               	\n");
				sb.append(" 	,EVDT.STAGE                                           			\n");
				sb.append(" 	,EVDT.DESCRIPTION                                     			\n");
				//sb.append(" 	,EVDT.GRADE_ITEM AS lev					                       	\n");
				sb.append(" 	,EVDT.GRADE_ITEM||'�ܰ�' AS GRADE_ITEM                       	\n"); 
				sb.append(" 	,GETICOMCODE1(EVDT.HOUSE_CODE, 'M219',EVDT.GRADE ) AS GRADE		\n");
				sb.append(" 	,EVDT.GRADE_TEXT												\n");
				sb.append(" 	,EVDT.POINT														\n");
				sb.append(" 	,getDeptName(EVDT.HOUSE_CODE,'CJ001',EVDT.DEPT,'B') AS DEPT		\n"); 
				sb.append(" FROM ICOYEVDT  EVDT, ICOYEVHD EVHD									\n");
				sb.append(" where 1=1									\n");
				sb.append(sm.addSelectString("  AND EVDT.HOUSE_CODE = ?	      				\n")); 
				sm.addStringParameter(House_code);
				sb.append("  AND EVDT.HOUSE_CODE	= EVHD.HOUSE_CODE     						\n"); 
				sb.append("  AND EVDT.EVAL_NO 		= EVHD.EVAL_NO     							\n"); 
				sb.append(sm.addSelectString("   AND EVDT.EVAL_NO	= ? 					      \n"));
				sm.addStringParameter(eval_no);
				
				
				
				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

				rtn[0] = sm.doSelect(sb.toString());
			
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}

	
	public SepoaOut getEVHD(String eval_no ,  String reco_no) throws Exception
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
			

			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" SELECT																			\n");
				sb.append(" 	EVHD.EVAL_NO                     											\n");
				sb.append(" 	, EVHD.SHEET_KIND															\n");
				sb.append(" 	, EVHD.BIZ_TYPE																\n");
				sb.append(" 	, EVHD.PERIOD																\n");
				sb.append(" 	, GETICOMCODE1(EVHD.HOUSE_CODE, 'M216',EVHD.SHEET_KIND) AS SHEET_KIND_TEXT	\n");
				sb.append(" 	, GETICOMCODE2(EVHD.HOUSE_CODE, 'M217',EVHD.BIZ_TYPE) AS BIZ_TYPE_TEXT		\n");
				sb.append(" 	, GETICOMCODE1(EVHD.HOUSE_CODE, 'M218',EVHD.PERIOD) AS PERIOD_TEXT			\n");
				sb.append(" 	, EVHD.SUBJECT                       										\n");
				sb.append(" 	, EVHD.USE_FLAG																\n");
				sb.append(" 	, EVHD.START_DATE															\n");
				sb.append(" 	, EVHD.END_DATE																\n"); 
				sb.append(" 	, convert_date(EVHD.START_DATE) AS START_DATE_TEXT							\n");
				sb.append(" 	, convert_date(EVHD.END_DATE) AS END_DATE_TEXT								\n"); 
				sb.append(" 	, RCHD.EVAL_OPINION															\n"); 
				sb.append(" 	, EVHD.ATTACH_NO															\n"); 
				sb.append(" 	, GETFILEATTCOUNT(EVHD.ATTACH_NO) AS ATT_COUNT 								\n"); 
				sb.append(" 	, RCHD.ATTACH_NO2															\n"); 
				sb.append(" 	, GETFILEATTCOUNT(RCHD.ATTACH_NO2) AS ATT_COUNT2 							\n"); 
				sb.append(" FROM ICOYEVHD	EVHD, ICOYRCHD RCHD												\n");
				sb.append(sm.addSelectString("  WHERE EVHD.HOUSE_CODE = ?										\n")); 
				sm.addStringParameter(House_code);
				sb.append(sm.addSelectString("  AND EVHD.EVAL_NO = ?	      									\n"));
				sm.addStringParameter(eval_no);
				sb.append(" AND EVHD.HOUSE_CODE = RCHD.HOUSE_CODE(+)										\n"); 
				sb.append(" AND EVHD.EVAL_NO = RCHD.EVAL_NO(+)												\n"); 
				sb.append(sm.addSelectString("  AND RCHD.RECO_NO(+) = ?	     								\n")); 
				sm.addStringParameter(reco_no);
				
				
				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

				rtn[0] = sm.doSelect(sb.toString());
			
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}
	
	public SepoaOut getEVDTList(String eval_no , String sheet_kind,String biz_type,String period,String use_flag,String start_date,String end_date) throws Exception
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
			

			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" SELECT																\n");
				sb.append(" 	EVDT.EVAL_NO                                                 	\n");
				sb.append(" 	,EVDT.EVAL_SEQ                                               	\n");
				sb.append(" 	,EVDT.STAGE                                           			\n");
				sb.append(" 	,EVDT.DESCRIPTION                                     			\n");
				//sb.append(" 	,EVDT.GRADE_ITEM AS lev					                       	\n");
				sb.append(" 	,EVDT.GRADE_ITEM||'�ܰ�' AS GRADE_ITEM                       	\n"); 
				sb.append(" 	,GETICOMCODE1(EVDT.HOUSE_CODE, 'M219',EVDT.GRADE ) AS GRADE		\n");
				sb.append(" 	,EVDT.GRADE_TEXT												\n");
				sb.append(" 	,EVDT.POINT														\n");
				sb.append(" 	,getDeptName(EVDT.HOUSE_CODE,'CJ001',EVDT.DEPT,'B') AS DEPT		\n"); 
				sb.append(" FROM ICOYEVDT  EVDT, ICOYEVHD EVHD									\n");
				sb.append("  WHERE 1=1	      				\n"); 
				sb.append(sm.addSelectString(" AND EVDT.HOUSE_CODE = ?	   				\n")); 
				sm.addStringParameter(House_code);
				sb.append("  AND EVDT.HOUSE_CODE	= EVHD.HOUSE_CODE     						\n"); 
				sb.append("  AND EVDT.EVAL_NO 		= EVHD.EVAL_NO     							\n"); 
				sb.append(sm.addSelectString("   AND EVDT.EVAL_NO	= ? 					      \n"));
				sm.addStringParameter(eval_no);
				sb.append(sm.addSelectString("   AND EVHD.SHEET_KIND	= ? 					      \n"));
				sm.addStringParameter(sheet_kind);
				sb.append(sm.addSelectString("   AND EVHD.BIZ_TYPE	= ? 					      \n"));
				sm.addStringParameter(biz_type);
				sb.append(sm.addSelectString("   AND EVHD.PERIOD	= ? 					      \n"));
				sm.addStringParameter(period);
				sb.append(sm.addSelectString("   AND EVHD.USE_FLAG	= ? 					      \n"));
				sm.addStringParameter(use_flag);
				sb.append(sm.addSelectString("   AND EVHD.START_DATE	<= ? 					      \n"));
				sm.addStringParameter(start_date);
				sb.append(sm.addSelectString("   AND EVHD.END_DATE	>= ? 					      \n"));
				sm.addStringParameter(end_date);
				
				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

				rtn[0] = sm.doSelect(sb.toString());
			
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}
	
	
	/*public SepoaOut getEVDT(String eval_no , String sheet_kind,String biz_type,String period,String use_flag,String start_date,String end_date) throws Exception
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
			

			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" SELECT																\n");
				sb.append(" 	EVDT.EVAL_NO                                                 	\n");
				sb.append(" 	,EVDT.EVAL_SEQ                                               	\n");
				sb.append(" 	,EVDT.STAGE                                           			\n");
				sb.append(" 	,EVDT.DESCRIPTION                                     			\n");
				//sb.append(" 	,EVDT.GRADE_ITEM AS lev					                       	\n");
				sb.append(" 	,EVDT.GRADE_ITEM||'�ܰ�' AS GRADE_ITEM                       	\n"); 
				sb.append(" 	,GETICOMCODE1(EVDT.HOUSE_CODE, 'M219',EVDT.GRADE ) AS GRADE		\n");
				sb.append(" 	,EVDT.GRADE_TEXT												\n");
				sb.append(" 	,EVDT.POINT														\n");
				sb.append(" 	,getDeptName(EVDT.HOUSE_CODE,'CJ001',EVDT.DEPT,'B') AS DEPT		\n"); 
				sb.append(" FROM ICOYEVDT  EVDT, ICOYEVHD EVHD									\n");
				sb.append("  WHERE 1=1	      				\n"); 
				sb.append(sm.addSelectString(" AND EVDT.HOUSE_CODE = ?	   				\n")); 
				sm.addStringParameter(House_code);
				sb.append("  AND EVDT.HOUSE_CODE	= EVHD.HOUSE_CODE     						\n"); 
				sb.append("  AND EVDT.EVAL_NO 		= EVHD.EVAL_NO     							\n"); 
				sb.append(sm.addSelectString("   AND EVDT.EVAL_NO	= ? 					      \n"));
				sm.addStringParameter(eval_no);
				sb.append(sm.addSelectString("   AND EVHD.SHEET_KIND	= ? 					      \n"));
				sm.addStringParameter(sheet_kind);
				sb.append(sm.addSelectString("   AND EVHD.BIZ_TYPE	= ? 					      \n"));
				sm.addStringParameter(biz_type);
				sb.append(sm.addSelectString("   AND EVHD.PERIOD	= ? 					      \n"));
				sm.addStringParameter(period);
				sb.append(sm.addSelectString("   AND EVHD.USE_FLAG	= ? 					      \n"));
				sm.addStringParameter(use_flag);
				sb.append(sm.addSelectString("   AND EVHD.START_DATE	<= ? 					      \n"));
				sm.addStringParameter(start_date);
				sb.append(sm.addSelectString("   AND EVHD.END_DATE	>= ? 					      \n"));
				sm.addStringParameter(end_date);
				
				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

				rtn[0] = sm.doSelect(sb.toString());
			
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			System.out.println(new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);

		}

		return getSepoaOut();
	}*/
	
	public SepoaOut setEVAppend( String[][] bean_args, HashMap header) throws Exception 
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
			String ID = info.getSession("ID");
			SepoaFormater sf = null;

			String eval_no     = (String) header.get("eval_no");   
			String grade_item   = (String) header.get("grade_item");     
			String stage   = (String) header.get("stage");       
			String description     = (String) header.get("description");
			String remark     = (String) header.get("remark");  
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append(" SELECT ltrim(TO_CHAR(nvl(max(eval_seq)+1,1),'000000')) cnt FROM ICOYEVDT		\n");
			sb.append(" WHERE 1=1 				 							\n");
			sb.append(sm.addSelectString(" AND HOUSE_CODE 	= ?            							\n"));
			sm.addStringParameter(House_code);
			sb.append(sm.addSelectString(" AND   EVAL_NO		= ?           							\n"));
			sm.addStringParameter(eval_no);
			 
			sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));
        	
				for (int i = 0; i < bean_args.length; i++)
				{
					String GRADE = bean_args[i][0];
					String GRADE_TEXT = bean_args[i][1];
					String POINT = bean_args[i][2];

					sm.removeAllValue();
					sb.delete(0, sb.length());
					sb.append(" INSERT INTO ICOYEVDT (         \n");
					sb.append(" 		 HOUSE_CODE      		\n");
					sb.append(" 		,EVAL_NO         		\n");
					sb.append(" 		,EVAL_SEQ        		\n");
					sb.append(" 		,GRADE           		\n");
					sb.append(" 		,DESCRIPTION     		\n");
					sb.append(" 		,GRADE_TEXT        		\n");
					sb.append(" 		,STAGE           		\n"); 
					sb.append(" 		,POINT           		\n");
					sb.append(" 		,DEPT            		\n");
					sb.append(" 		,GRADE_ITEM      		\n");
					sb.append(" 		,REMARK            		\n");
					sb.append(" 		,ADD_DATE        		\n");
					sb.append(" 		,ADD_USER_ID     		\n");
					sb.append(" 		,CHANGE_DATE     		\n");
					sb.append(" 		,CHANGE_USER_ID  		\n"); 
			
					sb.append(" ) VALUES (                     \n");
					sb.append(" 		 ?                      \n");//  HOUSE_CODE
					sm.addStringParameter(House_code);
					sb.append(" 		,?                      \n");//  EVAL_NO
					sm.addStringParameter(eval_no);
					sb.append(" 		,? 						\n");//  EVAL_SEQ
					sm.addStringParameter(sf.getValue("cnt", 0));
					sb.append(" 		,?                      \n");//  GRADE
					sm.addStringParameter(GRADE);
					sb.append(" 		,?                      \n");//  DESCRIPTION
					sm.addStringParameter(description);
					sb.append(" 		,?                      \n");//  GRADE_TEXT
					sm.addStringParameter(GRADE_TEXT);
					sb.append(" 		,?                      \n");//  STAGE
					sm.addStringParameter(stage);
					sb.append(" 		,?                      \n");//  POINT
					sm.addStringParameter(POINT);
					sb.append(" 		,?            			\n");//  DEPT
					sm.addStringParameter(info.getSession("DEPARTMENT"));
					sb.append(" 		,?                      \n");//  GRADE_ITEM
					sm.addStringParameter(grade_item);
					sb.append(" 		,?                      \n");//  REMARK
					sm.addStringParameter(remark);
					sb.append(" 		,?                      \n");//  ADD_DATE
					sm.addStringParameter(SepoaDate.getShortDateString());
					sb.append(" 		,?                      \n");//  ADD_USER_ID
					sm.addStringParameter(ID);
					sb.append(" 		,?                      \n");//  CHANGE_DATE
					sm.addStringParameter(SepoaDate.getShortTimeString());
					sb.append(" 		,?                      \n");//  CHANGE_USER_ID
					sm.addStringParameter(ID);
					sb.append(" )                              \n");

					sm.doInsert(sb.toString());
				}

				Commit();
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}
	
	/*
	
	public SepoaOut getsevgl_insert( String[][] bean_args, HashMap header) throws Exception 
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
			String ID = info.getSession("ID");
			SepoaFormater sf = null;

			String ev_no     = (String) header.get("ev_no");   
			String sheet_kind   = (String) header.get("sheet_kind");     
			String sg_kind   = (String) header.get("sg_kind");       
			String period     = (String) header.get("period");
			String use_flag     = (String) header.get("use_flag");  
			String ev_year     = (String) header.get("ev_year");
			String accept_value     = (String) header.get("accept_value");
			String st_date     = (String) header.get("st_date");
			String end_date     = (String) header.get("end_date");
			String subject     = (String) header.get("subject");
			String sheet_status     = (String) header.get("sheet_status");
			
			String sg_refitem = "";
			String ev_pass	="";
			
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			for (int i = 0; i < bean_args.length; i++)
			{
				String sg_type1 = bean_args[i][0];
				String sg_type2 = bean_args[i][1];
				String sg_type3 = bean_args[i][2];
					if(i == bean_args.length-1){
						sg_refitem += "'"+sg_type3+"'";
					}else{
						sg_refitem += "'"+sg_type3+"',";
					}
				
			}
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append(" SELECT A.SG_REFITEM, A.VENDOR_CODE, B.name_loc		\n");
			sb.append(" FROM SSGVN A,ICOMVNGL B		\n");
			sb.append(" WHERE 1=1 				 							\n");
			sb.append(" and  A.VENDOR_CODE = B.VENDOR_CODE 				 							\n");
			sb.append(" and A.sg_refitem in ("+sg_refitem+") 				 							\n");
			sb.append(" and A.del_flag='N' 				 							\n");
			sb.append(" and A.apply_flag='Y'				 							\n");
			sb.append(sm.addSelectString(" and SUBSTR(A.ADD_DATE,1,4)= ?				 							\n"));sm.addStringParameter(ev_year);
			sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));
			
			
			if("".equals(ev_no)){
				
				SepoaOut wo = DocumentUtil.getDocNumber(info, "EV");
				String EV_NO = wo.result[0];
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" INSERT INTO SEVGL (         \n");
				sb.append(" 		 EV_NO          		\n");
				sb.append(" 		,EV_YEAR        		\n");
				sb.append(" 		,SUBJECT        		\n");
				sb.append(" 		,SHEET_KIND     		\n");
				sb.append(" 		,SG_KIND        		\n");
				sb.append(" 		,PERIOD           		\n");
				sb.append(" 		,USE_FLAG       		\n"); 
				sb.append(" 		,ACCEPT_VALUE   		\n");
				sb.append(" 		,ST_DATE        		\n");
				sb.append(" 		,END_DATE       		\n");
				sb.append(" 		,ADD_DATE         		\n");
				sb.append(" 		,ADD_USER_ID    		\n");
				sb.append(" 		,CHANGE_DATE    		\n");
				sb.append(" 		,CHANGE_USER_ID 		\n");
				sb.append(" 		,DEL_FLAG       		\n"); 
				sb.append(" 		,SHEET_STATUS   		\n"); 				
				sb.append(" ) VALUES (                     \n");
				sb.append("      '"+EV_NO+"'                         \n");
				sb.append("      ,?                         \n");sm.addStringParameter(ev_year);
				sb.append("      ,?                         \n");sm.addStringParameter(subject);
				sb.append("      ,?                         \n");sm.addStringParameter(sheet_kind);
				sb.append("      ,?                         \n");sm.addStringParameter(sg_kind);
				sb.append("      ,?                         \n");sm.addStringParameter(period);
				sb.append("      ,?                         \n");sm.addStringParameter(use_flag);
				sb.append("      ,?                         \n");sm.addStringParameter(accept_value);
				sb.append("      ,?                         \n");sm.addStringParameter(st_date);
				sb.append("      ,?                         \n");sm.addStringParameter(end_date);
				sb.append("      ,?                         \n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("      ,?                         \n");sm.addStringParameter(info.getSession("ID"));
				sb.append("      ,?                         \n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("      ,?                         \n");sm.addStringParameter(info.getSession("ID"));
				sb.append("      ,'N'                         \n");
				sb.append("      ,'W'                         \n");
				
				sb.append(" )                              \n");
				sm.doInsert(sb.toString());
				ev_pass = EV_NO;
				
				
				
				
	        	
					for (int i = 0; i < sf.getRowCount(); i++)
					{

						sm.removeAllValue();
						sb.delete(0, sb.length());
						sb.append(" INSERT INTO SEVVN (         \n");
						sb.append(" 		 EV_NO          		\n");
						sb.append(" 		,EV_YEAR        		\n");
						sb.append(" 		,SG_REGITEM        		\n");
						sb.append(" 		,SELLER_CODE     		\n");
								
						sb.append(" ) VALUES (                     \n");
						sb.append("      '"+EV_NO+"'                         \n");
						sb.append("      ,?                         \n");sm.addStringParameter(ev_year);
						sb.append("      ,?                         \n");sm.addStringParameter(sf.getValue("SG_REFITEM", i));
						sb.append("      ,?                         \n");sm.addStringParameter(sf.getValue("VENDOR_CODE", i));
						sb.append(" )                              \n");
						sm.doInsert(sb.toString());
					}
					
			}else{
				ev_pass = ev_no;
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" UPDATE  SEVGL SET         \n");
				sb.append(" 		SUBJECT     =?   		\n");sm.addStringParameter(subject);
				sb.append(" 		,SHEET_KIND    =? 		\n");sm.addStringParameter(sheet_kind);
				sb.append(" 		,SG_KIND	=?        		\n");sm.addStringParameter(sg_kind);
				sb.append(" 		,PERIOD       =?    		\n");sm.addStringParameter(period);
				sb.append(" 		,USE_FLAG    =?   		\n"); sm.addStringParameter(use_flag);
				sb.append(" 		,ACCEPT_VALUE  =? 		\n");sm.addStringParameter(accept_value);
				sb.append(" 		,ST_DATE      =?  		\n");sm.addStringParameter(st_date);
				sb.append(" 		,END_DATE     =?  		\n");sm.addStringParameter(end_date);
				sb.append(" 		,CHANGE_DATE   =? 		\n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append(" 		,CHANGE_USER_ID =?		\n");sm.addStringParameter(info.getSession("ID"));
				if(!"R".equals(sheet_status)){
				sb.append(" 		,SHEET_STATUS = 'W'  	\n"); 	
				}
				sb.append(" 		WHERE  EV_NO = ?  		\n");sm.addStringParameter(ev_no);
				sb.append(" 		AND  EV_YEAR = ?  		\n");sm.addStringParameter(ev_year);
				sm.doUpdate(sb.toString());
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" DELETE FROM SEVVN          \n");
				sb.append(" 		 WHERE EV_NO = ?          		\n");sm.addStringParameter(ev_no);
				sb.append(" 		 AND EV_YEAR = ?          		\n");sm.addStringParameter(ev_year);
				sm.doDelete(sb.toString());
				
				for (int i = 0; i < sf.getRowCount(); i++)
				{

					sm.removeAllValue();
					sb.delete(0, sb.length());
					sb.append(" INSERT INTO SEVVN (         \n");
					sb.append(" 		 EV_NO          		\n");
					sb.append(" 		,EV_YEAR        		\n");
					sb.append(" 		,SG_REGITEM        		\n");
					sb.append(" 		,SELLER_CODE     		\n");
							
					sb.append(" ) VALUES (                     \n");
					sb.append("      '"+ev_no+"'                         \n");
					sb.append("      ,?                         \n");sm.addStringParameter(ev_year);
					sb.append("      ,?                         \n");sm.addStringParameter(sf.getValue("SG_REFITEM", i));
					sb.append("      ,?                         \n");sm.addStringParameter(sf.getValue("VENDOR_CODE", i));
					sb.append(" )                              \n");
					sm.doInsert(sb.toString());
				}
				
			}
			
			
				Commit();
				
				rtn[0] = ev_pass;
				setValue(rtn[0]);
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}
*/

	public SepoaOut getsevgl_list(String ev_no, String EV_YEAR) throws Exception
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
			

			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" select            		\n");
				sb.append(" ev_no             		\n");
				sb.append(" ,EV_YEAR          		\n");
				sb.append(" ,SUBJECT          		\n");
				sb.append(" ,SHEET_KIND       		\n");
				sb.append(" ,SG_KIND         							\n");
				sb.append(" ,PERIOD           		\n");
				sb.append(" ,USE_FLAG         		\n");
				sb.append(" ,ACCEPT_VALUE     		\n");
				sb.append(" ,ST_DATE          		\n");
				sb.append(" ,END_DATE         		\n");
				sb.append(" ,SHEET_STATUS         		\n");
				sb.append(" from SEVGL        		\n");
				sb.append(" where 1=1         		\n");
				sb.append(sm.addSelectString(" and ev_no = ?		\n"));sm.addStringParameter(ev_no);
				sb.append(sm.addSelectString(" and ev_year = ?		\n"));sm.addStringParameter(EV_YEAR);
				sb.append(" and del_flag = 'N'		\n");

				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

				rtn[0] = sm.doSelect(sb.toString());
			
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}
	
	public SepoaOut getsevvn_list(String ev_no,String ev_year) throws Exception
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
			

			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" select                                                     		\n");
				sb.append(" d.parent_sg_refitem as sg_type1,     		\n");
				sb.append(" c.parent_sg_refitem as sg_type2,    		\n");
				sb.append(" c.sg_regitem as sg_type3     		\n");
				sb.append(" from                                                       		\n");
				sb.append(" 	(select b.parent_sg_refitem,sg_regitem             		\n");
				sb.append(" 		from SEVVN a, SSGGL b                      		\n");
				sb.append(" 		where a.sg_regitem= b.sg_refitem          		\n");
				sb.append(sm.addSelectString(" 		and a.ev_no = ?                		\n"));sm.addStringParameter(ev_no);
				sb.append(sm.addSelectString(" 		and a.ev_year = ?                		\n"));sm.addStringParameter(ev_year);
				sb.append(" 	)c, ssggl d                                        		\n");
				sb.append(" 	where c.parent_sg_refitem = d.sg_refitem           		\n");
				sb.append(" 	group by c.sg_regitem, d.parent_sg_refitem, c.parent_sg_refitem           		\n");

				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

				rtn[0] = sm.doSelect(sb.toString());
			
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}
	
	public SepoaOut getsevln_list(String ev_no,String ev_year,String ev_m_item,String ev_d_item) throws Exception
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
			SepoaFormater sf = null;
			ArrayList arr_list = new ArrayList();
			String ev_seq = "0";

			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("select             	\n");
				sb.append(" A.EV_SEQ           	\n");
				sb.append(",B.EV_REQSEQ	        	\n");
				sb.append(",A.EV_YEAR	        	\n");
				sb.append(",A.EV_M_ITEM        	\n");
				sb.append(",A.EV_D_ITEM        	\n");
				sb.append(",A.EV_TYPE          	\n");
				sb.append(",A.EV_UNIT          	\n");
				sb.append(",A.EV_SCOPE         	\n");
				sb.append(",A.EV_WEIGHT        	\n");
				sb.append(",A.EV_WEIGHT_POINT  	\n");
				sb.append(",A.EV_BASIC_POINT   	\n");
				sb.append(",A.EV_REMARK        	\n");
				sb.append(",A.ATTACH_REMARK    	\n");
				sb.append(",A.VN_DISPLAY       	\n");
				sb.append(",A.MONEY_USE        	\n");
				sb.append(",A.EV_ITEM          	\n");
				sb.append(",B.ITEM_NAME1       	\n");
				sb.append(",B.ITEM_NAME2       	\n");
				sb.append(",B.ITEM_NAME3       	\n");
				sb.append(",A.CAL_DESC         	\n");
				sb.append(",A.USE_FLAG         	\n");
				sb.append(",B.EV_REQ_DESC         	\n");
				sb.append(",A.AVG_EV_NO         	\n");
				sb.append(",A.SUM_EV_NO         	\n");
				sb.append(",A.CAL_TYPE         	\n");
				sb.append(",A.AVG_VALUE         	\n");
				sb.append(",A.AUTO_CAL         	\n");
				
				sb.append("from SEVLN A, SSREQ B       	\n");
				sb.append("where 1=1         	\n");
				sb.append("and A.EV_NO = B.EV_NO         	\n");
				sb.append("AND A.EV_YEAR = B.EV_YEAR         	\n");
				sb.append("AND A.EV_SEQ = B.EV_SEQ        	\n");
				
				sb.append(sm.addSelectString("and A.ev_no = ?     	\n"));sm.addStringParameter(ev_no);
				sb.append(sm.addSelectString("and A.ev_year = ?   	\n"));sm.addStringParameter(ev_year);
				sb.append(sm.addSelectString("and A.ev_m_item = ? 	\n"));sm.addStringParameter(ev_m_item);
				sb.append(sm.addSelectString("and A.ev_d_item = ? 	\n"));sm.addStringParameter(ev_d_item);
				
				sb.append("and A.del_flag = 'N'\n");

				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());
				sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				//rtn[0] = sm.doSelect(sb.toString());
				if(sf.getRowCount() > 0){
					ev_seq = sf.getValue("EV_SEQ", 0);
				}
				//setValue(rtn[0]);
				for (int i = 0; i < sf.getRowCount(); i++)
	            {
	            	Hashtable ht = new Hashtable();
	            	ht.put("EV_SEQ", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("EV_SEQ", i))).trim());
	            	ht.put("EV_YEAR", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("EV_YEAR", i))).trim());
	            	ht.put("EV_M_ITEM", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("EV_M_ITEM", i))).trim());
	            	ht.put("EV_D_ITEM", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("EV_D_ITEM", i))).trim());
	            	ht.put("EV_TYPE", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("EV_TYPE", i))).trim());
	            	ht.put("EV_UNIT", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("EV_UNIT", i))).trim());
	            	ht.put("EV_SCOPE", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("EV_SCOPE", i))).trim());
	            	ht.put("EV_WEIGHT", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("EV_WEIGHT", i))).trim());
	            	ht.put("EV_WEIGHT_POINT", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("EV_WEIGHT_POINT", i))).trim());
	            	ht.put("EV_BASIC_POINT", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("EV_BASIC_POINT", i))).trim());
	            	ht.put("EV_REMARK", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("EV_REMARK", i))).trim());
	            	ht.put("ATTACH_REMARK", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("ATTACH_REMARK", i))).trim());
	            	ht.put("VN_DISPLAY", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("VN_DISPLAY", i))).trim());
	            	ht.put("MONEY_USE", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("MONEY_USE", i))).trim());
	            	ht.put("EV_ITEM", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("EV_ITEM", i))).trim());
	            	ht.put("ITEM_NAME1", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("ITEM_NAME1", i))).trim());
	            	ht.put("ITEM_NAME2", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("ITEM_NAME2", i))).trim());
	            	ht.put("ITEM_NAME3", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("ITEM_NAME3", i))).trim());
	            	ht.put("CAL_DESC", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("CAL_DESC", i))).trim());
	            	ht.put("USE_FLAG", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("USE_FLAG", i))).trim());
	            	ht.put("EV_REQ_DESC", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("EV_REQ_DESC", i))).trim());
	            	ht.put("EV_REQSEQ", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("EV_REQSEQ", i))).trim());
	            	
	            	ht.put("AVG_EV_NO", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("AVG_EV_NO", i))).trim());
	            	ht.put("SUM_EV_NO", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("SUM_EV_NO", i))).trim());
	            	ht.put("CAL_TYPE", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("CAL_TYPE", i))).trim());
	            	ht.put("AVG_VALUE", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("AVG_VALUE", i))).trim());
	            	ht.put("AUTO_CAL", JSPUtil.CheckInjection(JSPUtil.nullChk(sf.getValue("AUTO_CAL", i))).trim());
					
	            	arr_list.add(ht);
	            }//for~end
	            
	            setValue(arr_list);	//setValue로 list를 넘기자!!

				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("select             	\n");
				sb.append(" EV_ITEM_DESC           	\n");
				sb.append(",EV_MAX        	\n");
				sb.append(",EV_MIN        	\n");
				sb.append(",EV_POINT          	\n");
				sb.append(",EV_DSEQ          	\n");

				sb.append("from SEVDT        	\n");
				sb.append("where 1=1         	\n");
				sb.append(sm.addSelectString("and ev_no = ?     	\n"));sm.addStringParameter(ev_no);
				sb.append(sm.addSelectString("and ev_year = ?   	\n"));sm.addStringParameter(ev_year);
				sb.append(sm.addSelectString("and ev_seq = ? 	\n"));sm.addStringParameter(ev_seq);
				
				sb.append("and del_flag = 'N'\n");

				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

				rtn[0] = sm.doSelect(sb.toString());
			
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}
	
	public SepoaOut getsevln_insert( String[][] bean_args, HashMap header) throws Exception 
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
			String ID = info.getSession("ID");
			SepoaFormater sf = null;
			
			
			String ev_seq     = (String) header.get("ev_seq");
			String ev_year     = (String) header.get("ev_year");
			String ev_no     = (String) header.get("ev_no");   
			String ev_m_item   = (String) header.get("ev_m_item");     
			String ev_d_item   = (String) header.get("ev_d_item");       
			String grade_item     = (String) header.get("grade_item");
			String ev_type     = (String) header.get("ev_type");  
			String ev_unit     = (String) header.get("ev_unit");
			String ev_scope     = (String) header.get("ev_scope");
			String ev_weight     = (String) header.get("ev_weight");
			String ev_weight_point     = (String) header.get("ev_weight_point");
			String ev_basic_point     = (String) header.get("ev_basic_point");
			String ev_remark     = (String) header.get("ev_remark");
			String attach_remark = (String) header.get("attach_remark");
			
			
			String vn_display     = (String) header.get("vn_display");
			String money_use     = (String) header.get("money_use");
			String ev_item     = (String) header.get("ev_item");
			String item_name1     = (String) header.get("item_name1");
			String item_name2     = (String) header.get("item_name2");
			String item_name3     = (String) header.get("item_name3");
			String cal_desc     = (String) header.get("cal_desc");
			String ev_req_desc     = (String) header.get("ev_req_desc");
			String ev_reqseq     = (String) header.get("ev_reqseq");
			
			String auto_cal     = (String) header.get("auto_cal");
			String avg_ev_no     = (String) header.get("avg_ev_no");
			String sum_ev_no     = (String) header.get("sum_ev_no");
			String cal_type     = (String) header.get("cal_type");
			String avg_value     = (String) header.get("avg_value");
			
			String sg_refitem = "";
			
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("  select nvl(ev_seq,'') EV_SEQ                  \n");
			sb.append("  from SEVLN                     \n");
			sb.append("  where 1=1                         \n");
			sb.append(sm.addSelectString("  and ev_d_item = ?              \n"));sm.addStringParameter(ev_d_item);
			sb.append(sm.addSelectString("  and ev_m_item = ?              \n"));sm.addStringParameter(ev_m_item);
			sb.append(sm.addSelectString("  and ev_year = ?           \n"));sm.addStringParameter(ev_year);
			sb.append(sm.addSelectString("  and ev_no = ?     \n"));sm.addStringParameter(ev_no);
			sf = new SepoaFormater(sm.doSelect(sb.toString()));
			
			if(sf.getRowCount() == 0){
				
				SepoaOut wo = DocumentUtil.getDocNumber(info, "EVLN");
				String EV_SEQ_NO = wo.result[0];
				
				ev_seq = EV_SEQ_NO;
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" INSERT INTO SEVLN (         \n");
				sb.append(" 		 EV_NO           		\n");
				sb.append(" 		,EV_YEAR         		\n");
				sb.append(" 		,EV_SEQ          		\n");
				sb.append(" 		,EV_M_ITEM       		\n");
				sb.append(" 		,EV_D_ITEM       		\n");
				sb.append(" 		,EV_TYPE           		\n");
				sb.append(" 		,EV_UNIT         		\n"); 
				sb.append(" 		,EV_SCOPE        		\n");
				sb.append(" 		,EV_WEIGHT       		\n");
				sb.append(" 		,EV_WEIGHT_POINT 		\n");
				sb.append(" 		,EV_BASIC_POINT    		\n");
				sb.append(" 		,EV_REMARK       		\n");
				sb.append(" 		,ATTACH_REMARK       	\n");
				sb.append(" 		,VN_DISPLAY      		\n");
				sb.append(" 		,MONEY_USE       		\n");
				sb.append(" 		,EV_ITEM         		\n");
				sb.append(" 		,ITEM_NAME1      		\n");
				sb.append(" 		,ITEM_NAME2      		\n");
				sb.append(" 		,ITEM_NAME3      		\n");
				sb.append(" 		,CAL_DESC        		\n");
				sb.append(" 		,USE_FLAG        		\n");
				sb.append(" 		,ADD_DATE        		\n");
				sb.append(" 		,ADD_USER_ID     		\n");
				sb.append(" 		,CHANGE_DATE     		\n"); 
				sb.append(" 		,CHANGE_USER_ID  		\n"); 	
				sb.append(" 		,DEL_FLAG        		\n");
				sb.append(" 		,AUTO_CAL        		\n");
				sb.append(" 		,AVG_EV_NO        		\n");
				sb.append(" 		,SUM_EV_NO        		\n");
				sb.append(" 		,CAL_TYPE        		\n");
				sb.append(" 		,AVG_VALUE        		\n");
				
				sb.append(" ) VALUES (                     \n");

				sb.append("      ?                         \n");sm.addStringParameter(ev_no);
				sb.append("      ,?                         \n");sm.addStringParameter(SepoaDate.getYear()+"");
				sb.append("      ,?                         \n");sm.addStringParameter(EV_SEQ_NO);
				sb.append("      ,?                         \n");sm.addStringParameter(ev_m_item);
				sb.append("      ,?                         \n");sm.addStringParameter(ev_d_item);
				sb.append("      ,?                         \n");sm.addStringParameter(ev_type);
				sb.append("      ,?                         \n");sm.addStringParameter(ev_unit);
				sb.append("      ,?                         \n");sm.addStringParameter(ev_scope);
				sb.append("      ,?                         \n");sm.addStringParameter(ev_weight);
				sb.append("      ,?                         \n");sm.addNumberParameter(ev_weight_point);
				sb.append("      ,?                         \n");sm.addNumberParameter(ev_basic_point);
				sb.append("      ,?                         \n");sm.addStringParameter(ev_remark);
				sb.append("      ,?                         \n");sm.addStringParameter(attach_remark);
				sb.append("      ,?                         \n");sm.addStringParameter(vn_display);
				sb.append("      ,?                         \n");sm.addStringParameter(money_use);
				sb.append("      ,?                         \n");sm.addStringParameter(ev_item);
				sb.append("      ,?                         \n");sm.addStringParameter(item_name1);
				sb.append("      ,?                         \n");sm.addStringParameter(item_name2);
				sb.append("      ,?                         \n");sm.addStringParameter(item_name3);
				sb.append("      ,?                         \n");sm.addStringParameter(cal_desc);
				sb.append("      ,'Y'                         \n");
				sb.append("      ,?                         \n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("      ,?                         \n");sm.addStringParameter(info.getSession("ID"));
				sb.append("      ,?                         \n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("      ,?                         \n");sm.addStringParameter(info.getSession("ID"));
				sb.append("      ,'N'                         \n");
				sb.append("      ,?                         \n");sm.addStringParameter(auto_cal);
				sb.append("      ,?                         \n");sm.addStringParameter(avg_ev_no);
				sb.append("      ,?                         \n");sm.addStringParameter(sum_ev_no);
				sb.append("      ,?                         \n");sm.addStringParameter(cal_type);
				sb.append("      ,?                         \n");sm.addStringParameter(avg_value);
				sb.append(" )                              \n");
				sm.doInsert(sb.toString());
				
				//sheet 세세정보
				for (int i = 0; i < bean_args.length; i++)
				{
					String EV_ITEM_DESC = bean_args[i][0];
					String EV_MAX = bean_args[i][1];
					String EV_MIN = bean_args[i][2];
					String EV_POINT = bean_args[i][3];
					
					SepoaOut wo1 = DocumentUtil.getDocNumber(info, "EVDT");
					String EV_DSEQ_NO = wo1.result[0];
					
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" INSERT INTO SEVDT (         \n");
				sb.append(" 		 EV_NO         		\n");
				sb.append(" 		,EV_YEAR       		\n");
				sb.append(" 		,EV_SEQ        		\n");
				sb.append(" 		,EV_DSEQ       		\n");
				sb.append(" 		,EV_ITEM_DESC  		\n");
				sb.append(" 		,EV_MAX          		\n");
				sb.append(" 		,EV_MIN        		\n"); 
				sb.append(" 		,EV_POINT      		\n");
				sb.append(" 		,USE_FLAG      		\n");
				sb.append(" 		,ADD_DATE      		\n");
				sb.append(" 		,ADD_USER_ID     		\n");
				sb.append(" 		,CHANGE_DATE   		\n");
				sb.append(" 		,CHANGE_USER_ID		\n");
				sb.append(" 		,DEL_FLAG      		\n");
				
				sb.append(" ) VALUES (                     \n");
				sb.append("      ?                         \n");sm.addStringParameter(ev_no);
				sb.append("      ,?                         \n");sm.addStringParameter(SepoaDate.getYear()+"");
				sb.append("      ,?                         \n");sm.addStringParameter(EV_SEQ_NO);
				sb.append("      ,?                         \n");sm.addStringParameter(EV_DSEQ_NO);
				sb.append("      ,?                         \n");sm.addStringParameter(EV_ITEM_DESC);
				sb.append("      ,?                         \n");sm.addStringParameter(EV_MAX);
				sb.append("      ,?                         \n");sm.addStringParameter(EV_MIN);
				sb.append("      ,?                         \n");sm.addNumberParameter(EV_POINT);
				
				sb.append("      ,'Y'                         \n");
				sb.append("      ,?                         \n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("      ,?                         \n");sm.addStringParameter(info.getSession("ID"));
				sb.append("      ,?                         \n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("      ,?                         \n");sm.addStringParameter(info.getSession("ID"));
				sb.append("      ,'N'                         \n");
				
				sb.append(" )                              \n");
				sm.doInsert(sb.toString());
				}
				
				// 질의서 테이블 저장
				SepoaOut wo2 = DocumentUtil.getDocNumber(info, "EVREQSEQ");
				String EV_REQSEQ_NO = wo2.result[0];
				
				
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("   INSERT INTO SSREQ(   \n");
				sb.append(" EV_NO          \n");
				sb.append(" ,EV_YEAR        \n");
				sb.append(" ,EV_SEQ         \n");
				sb.append(" ,EV_REQSEQ      \n");
				sb.append(" ,EV_REQ_DESC    \n");
				sb.append(" ,ITEM_NAME1     \n");
				sb.append(" ,ITEM_NAME2     \n");
				sb.append(" ,ITEM_NAME3     \n");
				sb.append(" ,USE_FLAG       \n");
				sb.append(" ,ADD_DATE       \n");
				sb.append(" ,ADD_USER_ID    \n");
				sb.append(" ,DEL_FLAG       \n");
				sb.append("  ) VALUES ( \n");
				sb.append("  ? \n");sm.addStringParameter(ev_no);
				sb.append("  ,? \n");sm.addStringParameter(ev_year);
				sb.append("  ,? \n");sm.addStringParameter(ev_seq);
				sb.append("  ,? \n");sm.addStringParameter(EV_REQSEQ_NO);
				sb.append("  ,? \n");sm.addStringParameter(ev_req_desc);
				sb.append("  ,? \n");sm.addStringParameter(item_name1);
				sb.append("  ,? \n");sm.addStringParameter(item_name2);
				sb.append("  ,? \n");sm.addStringParameter(item_name3);
				sb.append("  ,'Y' \n");
				sb.append("  ,? \n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("  ,? \n");sm.addStringParameter(info.getSession("ID"));
				sb.append("  ,'N' \n");
				sb.append("  ) \n");
				
				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());
				sm.doInsert(sb.toString());
			
				
					
			}else{
				ev_seq = sf.getValue("EV_SEQ", 0);
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" UPDATE  SEVLN SET         \n");
				sb.append(" 		EV_M_ITEM  = ?     		\n");sm.addStringParameter(ev_m_item);
				sb.append(" 		,EV_D_ITEM  = ?     		\n");sm.addStringParameter(ev_d_item);
				sb.append(" 		,EV_TYPE   = ?        		\n");sm.addStringParameter(ev_type);
				sb.append(" 		,EV_UNIT   = ?      		\n");sm.addStringParameter(ev_unit);
				sb.append(" 		,EV_SCOPE   = ?     		\n");sm.addStringParameter(ev_scope);
				sb.append(" 		,EV_WEIGHT  = ?     		\n");sm.addStringParameter(ev_weight);
				sb.append(" 		,EV_WEIGHT_POINT  = ?		\n");sm.addNumberParameter(ev_weight_point);
				sb.append(" 		,EV_BASIC_POINT   = ? 		\n");sm.addNumberParameter(ev_basic_point);
				sb.append(" 		,EV_REMARK   = ?    		\n");sm.addStringParameter(ev_remark);
				sb.append(" 		,ATTACH_REMARK   = ?    	\n");sm.addStringParameter(attach_remark);
				sb.append(" 		,VN_DISPLAY  = ?    		\n");sm.addStringParameter(vn_display);
				sb.append(" 		,MONEY_USE   = ?    		\n");sm.addStringParameter(money_use);
				sb.append(" 		,EV_ITEM   = ?      		\n");sm.addStringParameter(ev_item);
				sb.append(" 		,ITEM_NAME1  = ?    		\n");sm.addStringParameter(item_name1);
				sb.append(" 		,ITEM_NAME2  = ?    		\n");sm.addStringParameter(item_name2);
				sb.append(" 		,ITEM_NAME3  = ?    		\n");sm.addStringParameter(item_name3);
				sb.append(" 		,CAL_DESC    = ?    		\n");sm.addStringParameter(cal_desc);
				sb.append(" 		,CHANGE_DATE    = ? 		\n"); sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append(" 		,CHANGE_USER_ID = ? 		\n");sm.addStringParameter(info.getSession("ID")); 	
				sb.append("      ,AUTO_CAL = ?                         \n");sm.addStringParameter(auto_cal);
				sb.append("      ,AVG_EV_NO = ?                         \n");sm.addStringParameter(avg_ev_no);
				sb.append("      ,SUM_EV_NO = ?                         \n");sm.addStringParameter(sum_ev_no);
				sb.append("      ,CAL_TYPE = ?                         \n");sm.addStringParameter(cal_type);
				sb.append("      ,AVG_VALUE = ?                         \n");sm.addStringParameter(avg_value);
				sb.append(" 		where ev_seq = ?       		\n");sm.addStringParameter(ev_seq); 
				sb.append(" 		and ev_year = ?       		\n");sm.addStringParameter(ev_year);
				sb.append(" 		and ev_no = ?       		\n");sm.addStringParameter(ev_no);
				
				sm.doUpdate(sb.toString());
				
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" DELETE FROM SEVDT          \n");
				sb.append(" 		 WHERE EV_NO = ?          		\n");sm.addStringParameter(ev_no);
				sb.append(" 		 AND EV_YEAR = ?          		\n");sm.addStringParameter(ev_year);
				sb.append(" 		 AND EV_SEQ = ?          		\n");sm.addStringParameter(ev_seq);
				sm.doDelete(sb.toString());
				
				
				for (int i = 0; i < bean_args.length; i++)
				{
					String EV_ITEM_DESC = bean_args[i][0];
					String EV_MAX = bean_args[i][1];
					String EV_MIN = bean_args[i][2];
					String EV_POINT = bean_args[i][3];
					
					SepoaOut wo1 = DocumentUtil.getDocNumber(info, "EVDT");
					String EV_DSEQ_NO = wo1.result[0];
					
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" INSERT INTO SEVDT (         \n");
				sb.append(" 		 EV_NO         		\n");
				sb.append(" 		,EV_YEAR       		\n");
				sb.append(" 		,EV_SEQ        		\n");
				sb.append(" 		,EV_DSEQ       		\n");
				sb.append(" 		,EV_ITEM_DESC  		\n");
				sb.append(" 		,EV_MAX          		\n");
				sb.append(" 		,EV_MIN        		\n"); 
				sb.append(" 		,EV_POINT      		\n");
				sb.append(" 		,USE_FLAG      		\n");
				sb.append(" 		,ADD_DATE      		\n");
				sb.append(" 		,ADD_USER_ID     		\n");
				sb.append(" 		,CHANGE_DATE   		\n");
				sb.append(" 		,CHANGE_USER_ID		\n");
				sb.append(" 		,DEL_FLAG      		\n");
				sb.append(" ) VALUES (                     \n");
				sb.append("      ?                         \n");sm.addStringParameter(ev_no);
				sb.append("      ,?                         \n");sm.addStringParameter(ev_year);
				sb.append("      ,?                         \n");sm.addStringParameter(ev_seq);
				sb.append("      ,?                         \n");sm.addStringParameter(EV_DSEQ_NO);
				sb.append("      ,?                         \n");sm.addStringParameter(EV_ITEM_DESC);
				sb.append("      ,?                         \n");sm.addStringParameter(EV_MAX);
				sb.append("      ,?                         \n");sm.addStringParameter(EV_MIN);
				sb.append("      ,?                         \n");sm.addNumberParameter(EV_POINT);
				
				sb.append("      ,'Y'                         \n");
				sb.append("      ,?                         \n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("      ,?                         \n");sm.addStringParameter(info.getSession("ID"));
				sb.append("      ,?                         \n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("      ,?                         \n");sm.addStringParameter(info.getSession("ID"));
				sb.append("      ,'N'                         \n");
				
				sb.append(" )                              \n");
				sm.doInsert(sb.toString());
				}
				
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" UPDATE  SSREQ SET         		\n");
				sb.append(" 		EV_REQ_DESC    = ? 	\n");sm.addStringParameter(ev_req_desc);
				sb.append(" 		,ITEM_NAME1    = ? 		\n");sm.addStringParameter(item_name1);
				sb.append(" 		,ITEM_NAME2 = ? 		\n");sm.addStringParameter(item_name2); 	
				sb.append(" 		,ITEM_NAME3 = ? 		\n");sm.addStringParameter(item_name3); 
				sb.append(" 		,CHANGE_DATE	= ?		\n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append(" 		,CHANGE_USER_ID	= ?		\n");sm.addStringParameter(info.getSession("ID"));
				sb.append(" 		where EV_NO = ?       	\n");sm.addStringParameter(ev_no); 
				sb.append(" 		AND  EV_YEAR = ?       	\n");sm.addStringParameter(ev_year); 
				sb.append(" 		AND  EV_SEQ = ?       	\n");sm.addStringParameter(ev_seq); 
				sb.append(" 		AND  EV_REQSEQ = ?       	\n");sm.addStringParameter(ev_reqseq);
				sm.doUpdate(sb.toString());
				
			}
			
			
			
			
				Commit();
				rtn[0] = ev_seq;
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}
	
	// 평가 sheet 등록 팝업  등록 탭
	public SepoaOut getSEVGL_header(String ev_no, String ev_year) throws Exception
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
			

			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" select            		\n");
				sb.append(" EV_YEAR          		\n");
				sb.append(" ,SUBJECT          		\n");
				sb.append(" ,SHEET_KIND       		\n");
				sb.append(" ,SG_KIND         							\n");
				sb.append(" ,PERIOD           		\n");
				sb.append(" ,USE_FLAG         		\n");
				sb.append(" ,ACCEPT_VALUE     		\n");
				sb.append(" ,ST_DATE          		\n");
				sb.append(" ,END_DATE         		\n");
				sb.append(" ,SHEET_STATUS         		\n");
				sb.append(" from SEVGL        		\n");
				sb.append(" where 1=1         		\n");
				sb.append(sm.addSelectString(" and ev_no = ?		\n"));sm.addStringParameter(ev_no);
				sb.append(sm.addSelectString(" and ev_year = ?		\n"));sm.addStringParameter(ev_year);
				sb.append(" and del_flag = 'N'		\n");

				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

				rtn[0] = sm.doSelect(sb.toString());
			
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}
	
	
	
	
	//평가sheet 평가항목 삭제
	public SepoaOut getsevln_delete( HashMap header) throws Exception 
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
			String ID = info.getSession("ID");
			SepoaFormater sf = null;
			
			
			String ev_seq     = (String) header.get("ev_seq");
			String ev_year     = (String) header.get("ev_year");
			String ev_no     = (String) header.get("ev_no");   
			
			
			String sg_refitem = "";
			
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
				
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" DELETE FROM SEVLN          \n");
				sb.append(" 		 WHERE EV_NO = ?          		\n");sm.addStringParameter(ev_no);
				sb.append(" 		 AND EV_YEAR = ?          		\n");sm.addStringParameter(ev_year);
				sb.append(" 		 AND EV_SEQ = ?          		\n");sm.addStringParameter(ev_seq);
				
				sm.doDelete(sb.toString());
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" DELETE FROM SEVDT          \n");
				sb.append(" 		 WHERE EV_NO = ?          		\n");sm.addStringParameter(ev_no);
				sb.append(" 		 AND EV_YEAR = ?          		\n");sm.addStringParameter(ev_year);
				sb.append(" 		 AND EV_SEQ = ?          		\n");sm.addStringParameter(ev_seq);
				
				sm.doDelete(sb.toString());
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" DELETE FROM SSREQ          \n");
				sb.append(" 		 WHERE EV_NO = ?          		\n");sm.addStringParameter(ev_no);
				sb.append(" 		 AND EV_YEAR = ?          		\n");sm.addStringParameter(ev_year);
				sb.append(" 		 AND EV_SEQ = ?          		\n");sm.addStringParameter(ev_seq);
				
				sm.doDelete(sb.toString());
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" DELETE FROM SINVN          \n");
				sb.append(" 		 WHERE EV_NO = ?          		\n");sm.addStringParameter(ev_no);
				sb.append(" 		 AND EV_YEAR = ?          		\n");sm.addStringParameter(ev_year);
				sb.append(" 		 AND EV_SEQ = ?          		\n");sm.addStringParameter(ev_seq);

				sm.doDelete(sb.toString());
				
			
				Commit();
				
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}
	
//	평가sheet 평가항목 등록
	public SepoaOut setSheet_save( HashMap header) throws Exception 
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
			String ID = info.getSession("ID");
			SepoaFormater sf = null;
			
			
			String ev_year     = (String) header.get("ev_year");
			String ev_no     = (String) header.get("ev_no");   
			
			
			
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
				
				
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append(" UPDATE  SEVGL SET         \n");
			sb.append(" 		SHEET_STATUS    = 'R' 		\n");
			sb.append(" 		,CHANGE_DATE    = ? 		\n"); sm.addStringParameter(SepoaDate.getShortDateString());
			sb.append(" 		,CHANGE_USER_ID = ? 		\n");sm.addStringParameter(info.getSession("ID")); 	
			sb.append(" 		where EV_NO = ?       		\n");sm.addStringParameter(ev_no); 
			sb.append(" 		AND  EV_YEAR = ?       		\n");sm.addStringParameter(ev_year); 
			sm.doUpdate(sb.toString());
			
				
			
				Commit();
				
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}
	
//	 평가 sheet 등록 팝업  평가요소 질의서 리스트
	public SepoaOut getSSREQ_list(String ev_no, String ev_year, String ev_seq) throws Exception
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
			
			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				
				sb.append("  select                                             \n");
				sb.append("  getev_m_itemext1('EV001',A.EV_M_ITEM) AS EV_M_ITEM	 --대분류 평가항목                 \n");
				sb.append("  ,getev_m_itemext1(A.EV_M_ITEM,A.EV_D_ITEM) as EV_D_ITEM --중분류 평가항목                     \n");
				sb.append("  ,getcodetext1('M051',A.EV_UNIT,'KO') AS EV_UNIT   --단위                                \n");
				sb.append("  ,A.EV_ITEM   --항목수                              \n");
				sb.append("  ,B.EV_REQ_DESC --질의내용                          \n");
				sb.append("  ,B.ITEM_NAME1  --항목1                             \n");
				sb.append("  ,B.ITEM_NAME2  --항목2                             \n");
				sb.append("  ,B.ITEM_NAME3  --항목3                             \n");
				sb.append("  ,B.EV_REQSEQ                                       \n");
				sb.append("  from SEVLN A ,SSREQ B                              \n");
				sb.append("  WHERE 1=1						                    \n");
				sb.append("  AND A.EV_NO = B.EV_NO(+)                               \n");
				sb.append("  AND A.EV_YEAR = B.EV_YEAR(+)                          \n");
				sb.append("  AND A.EV_SEQ = B.EV_SEQ(+)                            \n");
				sb.append(sm.addSelectString("  AND A.EV_NO = ?                 \n"));sm.addStringParameter(ev_no);
				sb.append(sm.addSelectString("  AND A.EV_YEAR = ?               \n"));sm.addStringParameter(ev_year);
				sb.append(sm.addSelectString("  AND A.EV_SEQ = ?                \n"));sm.addStringParameter(ev_seq);
				sb.append(" and a.del_flag = 'N'		\n");

				

				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

				rtn[0] = sm.doSelect(sb.toString());
			
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}
	
//	 평가 sheet 등록 팝업  평가요소 질의서 저장
	public SepoaOut getSSREQ_insert(String[][] bean_args,HashMap header) throws Exception
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
			String ev_no     = (String) header.get("ev_no");   
			String ev_seq     = (String) header.get("ev_seq");  
			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				
				for (int i = 0; i < bean_args.length; i++)
				{
					String EV_REQ_DESC = bean_args[i][0];
					String ITEM_NAME1 = bean_args[i][1];
					String ITEM_NAME2 = bean_args[i][2];
					String ITEM_NAME3 = bean_args[i][3];
					String EV_REQSEQ  = bean_args[i][4];
					
					
					if("".equals(EV_REQSEQ)){
						SepoaOut wo1 = DocumentUtil.getDocNumber(info, "EVREQSEQ");
						String EV_REQSEQ_NO = wo1.result[0];
						
						
						sm.removeAllValue();
						sb.delete(0, sb.length());
						sb.append("   INSERT INTO SSREQ(   \n");
						sb.append(" EV_NO          \n");
						sb.append(" ,EV_YEAR        \n");
						sb.append(" ,EV_SEQ         \n");
						sb.append(" ,EV_REQSEQ      \n");
						sb.append(" ,EV_REQ_DESC    \n");
						sb.append(" ,ITEM_NAME1     \n");
						sb.append(" ,ITEM_NAME2     \n");
						sb.append(" ,ITEM_NAME3     \n");
						sb.append(" ,USE_FLAG       \n");
						sb.append(" ,ADD_DATE       \n");
						sb.append(" ,ADD_USER_ID    \n");
						sb.append(" ,DEL_FLAG       \n");
						sb.append("  ) VALUES ( \n");
						sb.append("  ? \n");sm.addStringParameter(ev_no);
						sb.append("  ,? \n");sm.addStringParameter(ev_year);
						sb.append("  ,? \n");sm.addStringParameter(ev_seq);
						sb.append("  ,? \n");sm.addStringParameter(EV_REQSEQ_NO);
						sb.append("  ,? \n");sm.addStringParameter(EV_REQ_DESC);
						sb.append("  ,? \n");sm.addStringParameter(ITEM_NAME1);
						sb.append("  ,? \n");sm.addStringParameter(ITEM_NAME2);
						sb.append("  ,? \n");sm.addStringParameter(ITEM_NAME3);
						sb.append("  ,'Y' \n");
						sb.append("  ,? \n");sm.addStringParameter(SepoaDate.getShortDateString());
						sb.append("  ,? \n");sm.addStringParameter(info.getSession("ID"));
						sb.append("  ,'N' \n");
						sb.append("  ) \n");
						
						Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());
						sm.doInsert(sb.toString());
					}else {
						
						sm.removeAllValue();
						sb.delete(0, sb.length());
						sb.append(" UPDATE  SSREQ SET         		\n");
						sb.append(" 		EV_REQ_DESC    = ? 	\n");sm.addStringParameter(EV_REQ_DESC);
						sb.append(" 		,ITEM_NAME1    = ? 		\n");sm.addStringParameter(ITEM_NAME1);
						sb.append(" 		,ITEM_NAME2 = ? 		\n");sm.addStringParameter(ITEM_NAME2); 	
						sb.append(" 		,ITEM_NAME3 = ? 		\n");sm.addStringParameter(ITEM_NAME3); 
						sb.append(" 		,CHANGE_DATE	= ?		\n");sm.addStringParameter(SepoaDate.getShortDateString());
						sb.append(" 		,CHANGE_USER_ID	= ?		\n");sm.addStringParameter(info.getSession("ID"));
						sb.append(" 		where EV_NO = ?       	\n");sm.addStringParameter(ev_no); 
						sb.append(" 		AND  EV_YEAR = ?       	\n");sm.addStringParameter(ev_year); 
						sb.append(" 		AND  EV_SEQ = ?       	\n");sm.addStringParameter(ev_seq); 
						sb.append(" 		AND  EV_REQSEQ = ?       	\n");sm.addStringParameter(EV_REQSEQ);
						sm.doUpdate(sb.toString());
					}
				}
				
				Commit();
				
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			

		}

		return getSepoaOut();
	}

	public SepoaOut ev_copy( String temp_ev_no, String temp_ev_year, String temp_subject ) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;
			rtn = et_ev_copy( temp_ev_no, temp_ev_year, temp_subject );

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
	
	private String[] et_ev_copy( String temp_ev_no, String temp_ev_year, String temp_subject) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		SepoaFormater sf      = null;
		SepoaFormater sf1     = null;
		SepoaFormater sf2     = null;
		String user_id        = info.getSession("ID");
		String cur_date       = SepoaDate.getShortDateString();
		
		try
		{
			ParamSql sm  = new ParamSql(info.getSession("ID"), this, ctx);
			SepoaOut wo  = DocumentUtil.getDocNumber(info, "EV");
			String EV_NO = wo.result[0];
			// 평가SHEET헤더정보( SEVGL )
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append(" INSERT INTO SEVGL (                  								\n ");
			sb.append(" 		           EV_NO          			 						\n ");
			sb.append(" 		          ,EV_YEAR        			 						\n ");
			sb.append(" 				  ,SUBJECT        			 						\n ");
			sb.append(" 				  ,SHEET_KIND     		 	 						\n ");
			sb.append(" 				  ,SG_KIND        		 	 						\n ");
			sb.append(" 				  ,PERIOD           			 					\n ");
			sb.append(" 				  ,USE_FLAG       			 						\n "); 
			sb.append(" 				  ,ACCEPT_VALUE   			 						\n ");
			sb.append(" 				  ,ST_DATE        			 						\n ");
			sb.append(" 				  ,END_DATE       			 						\n ");
			sb.append(" 				  ,ADD_DATE         			 					\n ");
			sb.append(" 				  ,ADD_USER_ID    			 						\n ");
			sb.append(" 				  ,CHANGE_DATE    			 						\n ");
			sb.append(" 				  ,CHANGE_USER_ID 			 						\n ");
			sb.append(" 				  ,DEL_FLAG       			 						\n "); 
			sb.append(" 				  ,SHEET_STATUS   		     						\n ");
			sb.append(" 				  ,BEFORE_EV_NO   		     						\n ");
			sb.append("                  )                            						\n ");
			sb.append("                  (                            						\n ");
			sb.append("					  SELECT   '"+EV_NO+"'         					    \n "); 		
			sb.append("							  ,?        		                        \n "); sm.addStringParameter(cur_date.substring(0,4));
			sb.append("						      ,'[COPY_' || EV_NO || ']' || SUBJECT      \n ");    		
			sb.append("							  ,SHEET_KIND     		                    \n ");
			sb.append("							  ,SG_KIND        		                    \n ");
			sb.append("							  ,PERIOD           		                \n ");
			sb.append("							  ,USE_FLAG       		                    \n ");
			sb.append("							  ,ACCEPT_VALUE   		                    \n ");
			sb.append("							  ,ST_DATE        		                    \n ");
			sb.append("							  ,END_DATE       		                    \n ");
			sb.append("							  ,?           		                        \n "); 
			sb.append("							  ,?    		                            \n ");
			sb.append("							  ,''            		                    \n "); sm.addStringParameter(cur_date);
			sb.append("							  ,'' 		                                \n "); sm.addStringParameter(user_id);
			sb.append("							  ,DEL_FLAG       		                    \n ");
			sb.append("							  ,'D'                                      \n "); //상태값
			sb.append("							  ,EV_NO                                    \n ");
			sb.append("					  FROM   SEVGL                                      \n ");
			sb.append("					  WHERE  EV_NO   = ?                                \n "); sm.addStringParameter(temp_ev_no);
			sb.append("					  AND    EV_YEAR = ?                                \n "); sm.addStringParameter(temp_ev_year);
			sb.append(" 				 )                              					\n ");
			sm.doInsert(sb.toString());	
			
			// 평가SHEET-SG에연결된 업체평가테이블( SEVVN )
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append(" INSERT INTO SEVVN (                          \n" );
			sb.append(" 		           EV_NO          		     \n" );
			sb.append(" 		          ,EV_YEAR        		     \n" );
			sb.append(" 		          ,SG_REGITEM        		 \n" );
			sb.append(" 		          ,SELLER_CODE     		     \n" );
			sb.append("                   )                          \n" );
			sb.append("                   (                          \n" );
			sb.append("                    SELECT  '"+EV_NO+"'       \n" );
			sb.append("                           ,?                 \n" ); sm.addStringParameter(cur_date.substring(0,4));
			sb.append("                           ,SG_REGITEM        \n" );
			sb.append("                           ,SELLER_CODE       \n" );
			sb.append("                    FROM   SEVVN              \n" );
			sb.append("                    WHERE  EV_NO   = ?        \n" ); sm.addStringParameter(temp_ev_no);
			sb.append("                    AND    EV_YEAR = ?        \n" ); sm.addStringParameter(temp_ev_year);
			sb.append("                   )                          \n" );
			sm.doInsert(sb.toString());
			
			// 평가SHEET상세정보( SEVLN )
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("					 SELECT	 EV_SEQ          	  \n ");
			sb.append("					 	    ,EV_M_ITEM   	      \n ");
			sb.append("					  		,EV_D_ITEM       	  \n ");
			sb.append("					  		,EV_TYPE              \n ");
			sb.append("					  		,EV_UNIT         	  \n ");
			sb.append("					  		,EV_SCOPE        	  \n ");
			sb.append("					  		,EV_WEIGHT       	  \n ");
			sb.append("					  		,EV_WEIGHT_POINT 	  \n ");
			sb.append("					  		,EV_BASIC_POINT       \n ");
			sb.append("					  		,EV_REMARK       	  \n ");
			sb.append("					  		,VN_DISPLAY      	  \n ");
			sb.append("					  		,MONEY_USE       	  \n ");
			sb.append("					  		,EV_ITEM         	  \n ");
			sb.append("					  		,ITEM_NAME1      	  \n ");
			sb.append("					  		,ITEM_NAME2      	  \n ");
			sb.append("					 		,ITEM_NAME3      	  \n ");
			sb.append("					  		,CAL_DESC        	  \n ");
			sb.append("					  		,USE_FLAG        	  \n ");
			sb.append("					  		,DEL_FLAG        	  \n ");
			sb.append("					  		,AVG_EV_NO        	  \n ");
			sb.append("					  		,SUM_EV_NO        	  \n ");
			sb.append("					  		,CAL_TYPE        	  \n ");
			sb.append("					  		,AVG_VALUE        	  \n ");
			sb.append("					  		,AUTO_CAL        	  \n ");
			sb.append("						FROM  SEVLN               \n ");
			sb.append(sm.addFixString("		WHERE EV_NO   = ?         \n ")); sm.addStringParameter(temp_ev_no);
			sb.append(sm.addFixString("		AND   EV_YEAR = ?         \n ")); sm.addStringParameter(temp_ev_year);	
			sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));			
			
			for( int j = 0; j < sf.getRowCount(); j++ ){
				SepoaOut wo1 = DocumentUtil.getDocNumber(info, "EVLN");
				String EV_SEQ = wo1.result[0];

				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" INSERT INTO SEVLN (         				  \n ");
				sb.append(" 		           EV_NO           			  \n ");
				sb.append(" 		          ,EV_YEAR         			  \n ");
				sb.append(" 		          ,EV_SEQ          			  \n ");
				sb.append(" 		          ,EV_M_ITEM       			  \n ");
				sb.append(" 		          ,EV_D_ITEM       			  \n ");
				sb.append(" 		          ,EV_TYPE           		  \n ");
				sb.append(" 		          ,EV_UNIT         			  \n "); 
				sb.append(" 		          ,EV_SCOPE        			  \n ");
				sb.append(" 		          ,EV_WEIGHT       			  \n ");
				sb.append(" 		          ,EV_WEIGHT_POINT 			  \n ");
				sb.append(" 		          ,EV_BASIC_POINT    		  \n ");
				sb.append(" 		          ,EV_REMARK       			  \n ");
				sb.append(" 		          ,VN_DISPLAY      			  \n ");
				sb.append(" 		          ,MONEY_USE       			  \n ");
				sb.append(" 		          ,EV_ITEM         			  \n ");
				sb.append(" 		          ,ITEM_NAME1      			  \n ");
				sb.append(" 		          ,ITEM_NAME2      			  \n ");
				sb.append(" 		          ,ITEM_NAME3      			  \n ");
				sb.append(" 		          ,CAL_DESC        			  \n ");
				sb.append(" 		          ,USE_FLAG        			  \n ");
				sb.append(" 		          ,ADD_DATE        			  \n ");
				sb.append(" 		          ,ADD_USER_ID     			  \n ");
				sb.append(" 		          ,CHANGE_DATE     			  \n "); 
				sb.append(" 		          ,CHANGE_USER_ID  			  \n "); 	
				sb.append(" 		          ,DEL_FLAG        			  \n ");
				sb.append("					  ,AVG_EV_NO       		 	  \n ");
				sb.append("					  ,SUM_EV_NO       		 	  \n ");
				sb.append("					  ,CAL_TYPE        			  \n ");
				sb.append("					  ,AVG_VALUE       		 	  \n ");
				sb.append("					  ,AUTO_CAL        			  \n ");
				sb.append("                  ) VALUES					  \n ");
				sb.append("                  ( 							  \n ");
				sb.append("				       ?         				  \n "); sm.addStringParameter(EV_NO);
				sb.append("					  ,?         	          	  \n "); sm.addStringParameter(cur_date.substring(0,4));
				sb.append("					  ,?         				  \n "); sm.addStringParameter(EV_SEQ);
				sb.append("					  ,?       	  				  \n "); sm.addStringParameter(sf.getValue("EV_M_ITEM", j));
				sb.append("					  ,?       	  				  \n "); sm.addStringParameter(sf.getValue("EV_D_ITEM", j));
				sb.append("					  ,?              			  \n "); sm.addStringParameter(sf.getValue("EV_TYPE", j));
				sb.append("					  ,?         	  			  \n "); sm.addStringParameter(sf.getValue("EV_UNIT", j));
				sb.append("					  ,?        	  			  \n "); sm.addStringParameter(sf.getValue("EV_SCOPE", j));
				sb.append("					  ,?       	  				  \n "); sm.addStringParameter(sf.getValue("EV_WEIGHT", j));
				sb.append("					  ,? 	  					  \n "); sm.addStringParameter(sf.getValue("EV_WEIGHT_POINT", j));
				sb.append("					  ,?       					  \n "); sm.addStringParameter(sf.getValue("EV_BASIC_POINT", j));
				sb.append("					  ,?       	  				  \n "); sm.addStringParameter(sf.getValue("EV_REMARK", j));
				sb.append("					  ,?      	  				  \n "); sm.addStringParameter(sf.getValue("VN_DISPLAY", j));
				sb.append("					  ,?       	  				  \n "); sm.addStringParameter(sf.getValue("MONEY_USE", j));
				sb.append("					  ,?         	  			  \n "); sm.addStringParameter(sf.getValue("EV_ITEM", j));
				sb.append("					  ,?      	  				  \n "); sm.addStringParameter(sf.getValue("ITEM_NAME1", j));
				sb.append("					  ,?      	  				  \n "); sm.addStringParameter(sf.getValue("ITEM_NAME2", j));
				sb.append("					  ,?      	  				  \n "); sm.addStringParameter(sf.getValue("ITEM_NAME3", j));
				sb.append("					  ,?        	  			  \n "); sm.addStringParameter(sf.getValue("CAL_DESC", j));
				sb.append("					  ,?        	  			  \n "); sm.addStringParameter(sf.getValue("USE_FLAG", j));
				sb.append("					  ,?        	          	  \n "); sm.addStringParameter(cur_date); 
				sb.append("					  ,?     	              	  \n "); sm.addStringParameter(user_id);
				sb.append("					  ,''     	          		  \n "); 
				sb.append("					  ,''  	              		  \n "); 
				sb.append("					  ,?        	  			  \n "); sm.addStringParameter(sf.getValue("DEL_FLAG", j));
				sb.append("					  ,?        				  \n ");sm.addStringParameter(sf.getValue("AVG_EV_NO", j));
				sb.append("					  ,?       				 	  \n ");sm.addStringParameter(sf.getValue("SUM_EV_NO", j));
				sb.append("					  ,?     				   	  \n ");sm.addStringParameter(sf.getValue("CAL_TYPE", j));
				sb.append("					  ,?      				  	  \n ");sm.addStringParameter(sf.getValue("AVG_VALUE", j));
				sb.append("					  ,?       				 	  \n ");sm.addStringParameter(sf.getValue("AUTO_CAL", j));
				sb.append("                  )                            \n "); 
				sm.doInsert(sb.toString());		
				
				// 평가SHEET세세정보( SEVDT )
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("					   SELECT EV_NO         	   \n ");
				sb.append("				  	  		 ,EV_YEAR              \n ");
				sb.append("				  			 ,EV_SEQ               \n ");
				sb.append("				  			 ,EV_DSEQ              \n ");
				sb.append("				  			 ,EV_ITEM_DESC         \n ");
				sb.append("				  			 ,EV_MAX               \n ");
				sb.append("				  			 ,EV_MIN               \n ");
				sb.append("				  			 ,EV_POINT             \n ");
				sb.append("				  		 	 ,USE_FLAG             \n ");
				sb.append("				  			 ,ADD_DATE             \n ");
				sb.append("				  			 ,ADD_USER_ID          \n ");
				sb.append("				  			 ,CHANGE_DATE          \n ");
				sb.append("				  			 ,CHANGE_USER_ID       \n ");
				sb.append("				  			 ,DEL_FLAG             \n ");
				sb.append("					   FROM   SEVDT                \n ");
				sb.append(sm.addFixString("    WHERE  EV_NO   = ?          \n ")); sm.addStringParameter(temp_ev_no);
				sb.append(sm.addFixString("    AND    EV_YEAR = ?          \n ")); sm.addStringParameter(temp_ev_year);
				sb.append(sm.addFixString("    AND    EV_SEQ  = ?          \n ")); sm.addStringParameter(sf.getValue("EV_SEQ", j));
				sf1 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				for( int k = 0; k < sf1.getRowCount(); k++ ){
					SepoaOut wo2   = DocumentUtil.getDocNumber(info, "EVDT");
					String EV_DSEQ = wo2.result[0];
				
					sm.removeAllValue();
					sb.delete(0, sb.length());
					sb.append(" INSERT INTO SEVDT (         				   \n ");
					sb.append(" 		           EV_NO         			   \n ");
					sb.append(" 		          ,EV_YEAR       			   \n ");
					sb.append(" 		          ,EV_SEQ        			   \n ");
					sb.append(" 				  ,EV_DSEQ       			   \n ");
					sb.append(" 				  ,EV_ITEM_DESC  			   \n ");
					sb.append(" 				  ,EV_MAX          			   \n ");
					sb.append(" 				  ,EV_MIN        			   \n "); 
					sb.append(" 				  ,EV_POINT      			   \n ");
					sb.append(" 				  ,USE_FLAG      			   \n ");
					sb.append(" 				  ,ADD_DATE      			   \n ");
					sb.append(" 				  ,ADD_USER_ID     			   \n ");
					sb.append(" 				  ,CHANGE_DATE   			   \n ");
					sb.append(" 				  ,CHANGE_USER_ID			   \n ");
					sb.append(" 				  ,DEL_FLAG      			   \n ");
					sb.append(" 				  ) VALUES                 	   \n ");
					sb.append(" 				  (                      	   \n ");
					sb.append("					   ?         	   			   \n "); sm.addStringParameter(EV_NO);
					sb.append("				  	  ,?              			   \n "); sm.addStringParameter(cur_date.substring(0,4));
					sb.append("				  	  ,?               			   \n "); sm.addStringParameter(EV_SEQ);
					sb.append("				  	  ,?              			   \n "); sm.addStringParameter(EV_DSEQ);
					sb.append("				  	  ,?         				   \n "); sm.addStringParameter(sf1.getValue("EV_ITEM_DESC", k));
					sb.append("				  	  ,?               			   \n "); sm.addStringParameter(sf1.getValue("EV_MAX", k));
					sb.append("				  	  ,?               			   \n "); sm.addStringParameter(sf1.getValue("EV_MIN", k));
					sb.append("				  	  ,?             			   \n "); sm.addStringParameter(sf1.getValue("EV_POINT", k));
					sb.append("				  	  ,?             			   \n "); sm.addStringParameter(sf1.getValue("USE_FLAG", k));
					sb.append("				  	  ,?             			   \n "); sm.addStringParameter(cur_date);
					sb.append("				  	  ,?          				   \n "); sm.addStringParameter(user_id);
					sb.append("				  	  ,''          				   \n ");
					sb.append("				  	  ,''       				   \n ");
					sb.append("				  	  ,?             			   \n "); sm.addStringParameter(sf1.getValue("DEL_FLAG", k));
					sb.append(" 			      )                            \n ");
					sm.doInsert(sb.toString());		
				}
				
				// 질의서정보( SSREQ )
				sm.removeAllValue();
				sb.delete(0, sb.length());				
				sb.append("				    SELECT	EV_NO     			 \n ");    
				sb.append("				   		   ,EV_YEAR              \n ");
				sb.append("				   		   ,EV_SEQ               \n ");
				sb.append("				   		   ,EV_REQSEQ            \n ");
				sb.append(" 					   ,EV_REQ_DESC      	 \n ");
				sb.append(" 					   ,ITEM_NAME1      	 \n ");
				sb.append(" 					   ,ITEM_NAME2      	 \n ");
				sb.append(" 					   ,ITEM_NAME3      	 \n ");				
				sb.append("				   		   ,USE_FLAG             \n ");
				sb.append(" 					   ,ADD_DATE       		 \n ");
				sb.append(" 					   ,ADD_USER_ID    	 	 \n ");
				sb.append(" 					   ,CHANGE_DATE       	 \n ");
				sb.append(" 					   ,CHANGE_USER_ID    	 \n ");					
				sb.append("				   		   ,DEL_FLAG             \n ");
				sb.append("				    FROM    SSREQ                \n ");
				sb.append(sm.addFixString(" WHERE   EV_NO   = ?          \n ")); sm.addStringParameter(temp_ev_no);
				sb.append(sm.addFixString(" AND     EV_YEAR = ?          \n ")); sm.addStringParameter(temp_ev_year);
				sb.append(sm.addFixString(" AND     EV_SEQ  = ?          \n ")); sm.addStringParameter(sf.getValue("EV_SEQ", j));
				sf2 = new SepoaFormater(sm.doSelect_limit(sb.toString()));
				for( int k = 0; k < sf2.getRowCount(); k++ ){
					SepoaOut wo3     = DocumentUtil.getDocNumber(info, "EVREQSEQ");
					String EV_REQSEQ = wo3.result[0];
					sm.removeAllValue();
					sb.delete(0, sb.length());
					sb.append("   INSERT INTO SSREQ (   				 \n ");
					sb.append("                      EV_NO          	 \n ");
					sb.append(" 					,EV_YEAR        	 \n ");
					sb.append(" 					,EV_SEQ         	 \n ");
					sb.append(" 					,EV_REQSEQ      	 \n ");
					sb.append(" 					,EV_REQ_DESC      	 \n ");
					sb.append(" 					,ITEM_NAME1      	 \n ");
					sb.append(" 					,ITEM_NAME2      	 \n ");
					sb.append(" 					,ITEM_NAME3      	 \n ");
					sb.append(" 					,USE_FLAG       	 \n ");
					sb.append(" 					,ADD_DATE       	 \n ");
					sb.append(" 					,ADD_USER_ID    	 \n ");
					sb.append(" 					,CHANGE_DATE       	 \n ");
					sb.append(" 					,CHANGE_USER_ID    	 \n ");					
					sb.append(" 					,DEL_FLAG       	 \n ");
					sb.append("  					) VALUES        	 \n ");
					sb.append("  					( 	            	 \n ");
					sb.append("						 ?       			 \n "); sm.addStringParameter(EV_NO);   
					sb.append("				   		,?                   \n "); sm.addStringParameter(cur_date.substring(0,4));
					sb.append("				   		,?                   \n "); sm.addStringParameter(EV_SEQ);
					sb.append("				   		,?		           	 \n "); sm.addStringParameter(EV_REQSEQ);
					sb.append("				   		,?                   \n "); sm.addStringParameter(sf2.getValue("EV_REQ_DESC", k));
					sb.append("				   		,?                   \n "); sm.addStringParameter(sf2.getValue("ITEM_NAME1", k));
					sb.append("				   		,?                   \n "); sm.addStringParameter(sf2.getValue("ITEM_NAME2", k));
					sb.append("				   		,?                   \n "); sm.addStringParameter(sf2.getValue("ITEM_NAME3", k));
					sb.append("				   		,?                   \n "); sm.addStringParameter(sf2.getValue("USE_FLAG", k));
					sb.append("				   		,?                   \n "); sm.addStringParameter(cur_date);
					sb.append("				   		,?                   \n "); sm.addStringParameter(user_id);
					sb.append("				   		,''                  \n "); 
					sb.append("				   		,''                  \n "); 
					sb.append("				   		,?		             \n "); sm.addStringParameter(sf2.getValue("DEL_FLAG", k));
					sb.append(" 				 	) 					 \n ");
					sm.doInsert(sb.toString());					
				}
			}
			straResult[0] = EV_NO;
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.getMessage();
			
			Logger.debug.println(user_id, this, e.getMessage());
		}
		finally
		{
		}

		return straResult;
	}	
	
	public SepoaOut ev_delete(String[][] bean_args) throws Exception {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();

		try {
			setStatus(1);
			setFlag(true);
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for (int i = 0; i < bean_args.length; i++)
			{
				String EV_NO   = bean_args[i][0];
				String EV_YEAR = bean_args[i][1];
				
				// 평가SHEET헤더정보
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("     UPDATE SEVGL SET            				  	\n");
				sqlsb.append("                  DEL_FLAG = 'Y'          		\n");
				sqlsb.append("            WHERE EV_NO	 = ?           			\n"); sm.addStringParameter(EV_NO);
				sqlsb.append("            AND   EV_YEAR	 = ?           			\n"); sm.addStringParameter(EV_YEAR);
				sm.doDelete(sqlsb.toString());
				
				// 평가SHEET상세정보
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("     UPDATE SEVLN SET            				  	\n");
				sqlsb.append("                  DEL_FLAG = 'Y'          		\n");
				sqlsb.append("            WHERE EV_NO	 = ?           			\n"); sm.addStringParameter(EV_NO);
				sqlsb.append("            AND   EV_YEAR	 = ?           			\n"); sm.addStringParameter(EV_YEAR);
				sm.doDelete(sqlsb.toString());
				
				// 평가SHEET세세정보
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("     UPDATE SEVDT SET            				  	\n");
				sqlsb.append("                  DEL_FLAG = 'Y'          		\n");
				sqlsb.append("            WHERE EV_NO	 = ?           			\n"); sm.addStringParameter(EV_NO);
				sqlsb.append("            AND   EV_YEAR	 = ?           			\n"); sm.addStringParameter(EV_YEAR);
				sm.doDelete(sqlsb.toString());
				
				// 질의서정보
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("     UPDATE SSREQ SET            				  	\n");
				sqlsb.append("                  DEL_FLAG = 'Y'          		\n");
				sqlsb.append("            WHERE EV_NO	 = ?           			\n"); sm.addStringParameter(EV_NO);
				sqlsb.append("            AND   EV_YEAR	 = ?           			\n"); sm.addStringParameter(EV_YEAR);
				sm.doDelete(sqlsb.toString());
				
				// 평가SHEET-SG에연결된 업체평가테이블
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("     UPDATE SEVVN SET            				  	\n");
				sqlsb.append("                  DEL_FLAG = 'Y'          		\n");
				sqlsb.append("            WHERE EV_NO	 = ?           			\n"); sm.addStringParameter(EV_NO);
				sqlsb.append("            AND   EV_YEAR	 = ?           			\n"); sm.addStringParameter(EV_YEAR);
				sm.doDelete(sqlsb.toString());
				
				
/*
				// 업체평가입력정보
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("     UPDATE SINVN SET            				  	\n");
				sqlsb.append("                  DEL_FLAG = 'Y'          		\n");
				sqlsb.append("            WHERE EV_NO	 = ?           			\n"); sm.addStringParameter(EV_NO);
				sqlsb.append("            AND   EV_YEAR	 = ?           			\n"); sm.addStringParameter(EV_YEAR);
				sm.doDelete(sqlsb.toString());
				
				// 현장실사등록-헤더
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("     UPDATE SRGVN SET            				  	\n");
				sqlsb.append("                  DEL_FLAG = 'Y'          		\n");
				sqlsb.append("            WHERE EV_NO	 = ?           			\n"); sm.addStringParameter(EV_NO);
				sqlsb.append("            AND   EV_YEAR	 = ?           			\n"); sm.addStringParameter(EV_YEAR);
				sm.doDelete(sqlsb.toString());
				
				// 현장실사등록-디테일
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("     UPDATE SRGVD SET            				  	\n");
				sqlsb.append("                  DEL_FLAG = 'Y'          		\n");
				sqlsb.append("            WHERE EV_NO	 = ?           			\n"); sm.addStringParameter(EV_NO);
				sqlsb.append("            AND   EV_YEAR	 = ?           			\n"); sm.addStringParameter(EV_YEAR);
				sm.doDelete(sqlsb.toString());		
*/	
				
				
			}
			Commit();
		} catch (Exception e) {
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
}
