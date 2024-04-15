package ict.sepoa.svc.sourcing;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap ;
import java.util.List ;
import java.util.Map ;

import org.apache.commons.collections.MapUtils ;

import sepoa.fw.msg.Message;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.cfg.Configuration ;
import sepoa.fw.cfg.ConfigurationException ;
import sepoa.fw.db.ConnectionContext ;
import sepoa.fw.db.ParamSql ;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger ;
import sepoa.fw.ses.SepoaInfo ;
import sepoa.fw.srv.SepoaOut ;
import sepoa.fw.srv.SepoaService ;
import sepoa.fw.srv.SepoaServiceException ;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.DBUtil ;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate ;
import sepoa.fw.util.SepoaFormater ;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString ;   
import sms.SMS;
import wisecommon.SignRequestInfo;

import java.util.StringTokenizer;

@SuppressWarnings( { "unchecked", "unused", "rawtypes" } )
public class I_CT_001 extends SepoaService 
{ 
 
/************************************************************** 
---------------------------------------------------------------------------------------------------- 
FUNCTION					  DESC												PATH 
---------------------------------------------------------------------------------------------------- 
setRfqCreate			      IT사업관리							     DT>견적관리>IT사업관리 
---------------------------------------------------------------------------------------------------- 
**************************************************************/
	private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession( "HOUSE_CODE" );
    private String lang         = info.getSession( "LANGUAGE" );
    //20131212 sendakun
    private HashMap msg = null;

    public I_CT_001( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.err.println("I_CT_001: = " + e.getMessage());
        }
    }

    public String getConfig( String s ) {
        try {
            Configuration configuration = new Configuration();
            s = configuration.get( s );
            return s;
        } catch( ConfigurationException configurationexception ) {
            Logger.sys.println( "getConfig error : " + configurationexception.getMessage() );
        } catch( Exception exception ) {
            Logger.sys.println( "getConfig error : " + exception.getMessage() );
        }
        return null;
    }


	public SepoaOut getCtBzList(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
        	sxp = new SepoaXmlParser(this, "getCtBzList");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

//        	headerData.put("house_code", house_code);  
        	
        	setValue(ssm.doSelect(headerData));

        	setStatus(1);
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    }
	
	public SepoaOut getCtResultList(Map< String, String > headerData, String biz_no)
	{
        ConnectionContext ctx = getConnectionContext(); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {

			sxp = new SepoaXmlParser(this, "getCtResultList");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  

		
            headerData.put( "biz_no", biz_no ); 
            
            setValue(ssm.doSelect(headerData));
 
            setStatus(1);
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    }
	
	public SepoaOut saveBzList(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_saveBzList(info, bean_args);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
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
	
	private String[] et_saveBzList(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		
		SepoaOut    so  = null;
		
		try
		{
			int cnt = 0;
			SepoaFormater sf = null;

			for (int i = 0; i < bean_info.length; i++)
			{
				String CU                = bean_info[i][0];				
        		String PUM_NO            = bean_info[i][1];				
        		String BIZ_NO	         = bean_info[i][2];				
        		String BIZ_NM            = bean_info[i][3];				
        		String CT_USER_ID        = bean_info[i][4];		
        		String CT_USER_NAME      = bean_info[i][5];		
        		String BIZ_STATUS        = bean_info[i][6];				

				SepoaXmlParser sxp = null;
				SepoaSQLManager ssm = null;
				
				String[] args = null;
				String[] types = null;
				//존재하면 Update
				if("C".equals(CU)){
					
					if( BIZ_NO == null || "".equals( BIZ_NO ) || BIZ_NO.length() < 1 ) { 
		            	so        = DocumentUtil.getDocNumber( info, "IBZ" );  
		            	BIZ_NO = so.result[0];		                
		            }
					
					sxp = new SepoaXmlParser(this, "et_saveBzList_rqbzSelect");
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());

					args = new String[]{ PUM_NO };
					sf = new SepoaFormater(ssm.doSelect_limit(args));

					if(Integer.parseInt(sf.getValue("cnt", 0)) > 0){
						throw new Exception("해당품의번호는 이미 사용중입니다.");
					}
					
					
		            
					args = new String[]{ PUM_NO, BIZ_NO, BIZ_NM, CT_USER_ID, CT_USER_NAME, BIZ_STATUS, ID, ID, ID, ID};
					types = new String[]{"S","S","S","S","S","S","S","S","S","S"};
    		
                    sxp = new SepoaXmlParser(this, "et_insertBz");
                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    ssm.doInsert(new String[][]{args}, types);
					
//					else{
//						sxp = new SepoaXmlParser(this, "et_insertItem_select");
//						ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
//
//						args = new String[]{ info.getSession("HOUSE_CODE"), DEPT, ITEM_NO };
//						sf = new SepoaFormater(ssm.doSelect_limit(args));
//
//						if(Integer.parseInt(sf.getValue("cnt", 0)) > 0){
//							throw new Exception("보유중인 품목을 중복등록 불가합니다. - " + ITEM_NO );
//						}
//						
//						// SepoaDate.getShortDateString(), SepoaDate.getShortTimeString()
//						args = new String[]{ 
//								info.getSession("HOUSE_CODE"), DEPT, ITEM_NO, CRE_GB, DSTR_GB, 
//								STK_USER_ID, STK_USER_NAME_LOC, SepoaDate.getShortDateString(), SepoaDate.getShortTimeString(), NTC_YN, 
//								NTC_LOC, NTC_LOC_ETC, NTC_USER_ID, NTC_USER_NAME_LOC  , NTC_DATE, 
//								NTC_TIME, ABOL_YN, ABOL_USER_ID, ABOL_USER_NAME_LOC, ABOL_DATE, 
//								ABOL_TIME
//						};
//						types = new String[]{"S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S"};
//
//	                    sxp = new SepoaXmlParser(this, "et_insertItem");
//	                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
//	                    ssm.doInsert(new String[][]{args}, types);
//					}
					                    
//				}else{
//					args = new String[]{ DSTR_GB, NTC_YN, NTC_LOC, NTC_LOC_ETC, NTC_USER_ID, 
//							NTC_USER_NAME_LOC , NTC_DATE, NTC_TIME, ABOL_YN, ABOL_USER_ID, 
//							ABOL_USER_NAME_LOC, ABOL_DATE, ABOL_TIME    , info.getSession("HOUSE_CODE"), DEPT, 
//							ITEM_NO};
//					types = new String[]{"S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S"};
//
//                    sxp = new SepoaXmlParser(this, "et_updateItem");
//                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
//                    ssm.doUpdate(new String[][]{args}, types);
//
				}else{
					sxp = new SepoaXmlParser(this, "et_saveBzList_rqbzSelect2");
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());

					args = new String[]{ BIZ_NO,PUM_NO };
					sf = new SepoaFormater(ssm.doSelect_limit(args));

					if(Integer.parseInt(sf.getValue("cnt", 0)) > 0){
						throw new Exception("해당품의번호는 이미 사용중입니다.");
					}
														
					args = new String[]{ PUM_NO, BIZ_NM, CT_USER_ID, CT_USER_NAME, BIZ_STATUS, ID, ID,  BIZ_NO};
					types = new String[]{"S","S","S","S","S","S","S","S"};
					
					sxp = new SepoaXmlParser(this, "et_updateBz");
                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    ssm.doUpdate(new String[][]{args}, types);
                    
				}
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} //
	
	public SepoaOut deleteBzList(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_deleteBzList(info, bean_args);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
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
	
	private String[] et_deleteBzList(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		
		SepoaOut    so  = null;
		
		try
		{
			int cnt = 0;
			SepoaFormater sf = null;

			for (int i = 0; i < bean_info.length; i++)
			{
				String CU               = bean_info[i][0];				
        		String BIZ_NO             = bean_info[i][1];
        		String BIZ_NM             = bean_info[i][2];
        		String BIZ_STATUS         = bean_info[i][3];
                                            
				SepoaXmlParser sxp = null;
				SepoaSQLManager ssm = null;
				
				String[] args = null;
				String[] types = null;
				if("".equals(CU)){
					sxp = new SepoaXmlParser(this, "et_deleteBzList_ctivSelect");
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());

					args = new String[]{ BIZ_NO };
					sf = new SepoaFormater(ssm.doSelect_limit(args));

					if(Integer.parseInt(sf.getValue("cnt", 0)) > 0){
						throw new Exception("해당사업번호로 등록된 계약건이 존재하는 경우 삭제 불가합니다.");
					}
					
					sxp = new SepoaXmlParser(this, "et_deleteBzList_bdhdSelect");
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());

					args = new String[]{ BIZ_NO };
					sf = new SepoaFormater(ssm.doSelect_limit(args));

					if(Integer.parseInt(sf.getValue("cnt", 0)) > 0){
						throw new Exception("해당사업번호로 진행중인 입찰공문이 존재하는 경우 삭제 불가합니다.");
					}
					
					sxp = new SepoaXmlParser(this, "et_deleteBzList_rqhdselect");
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());

					sf = new SepoaFormater(ssm.doSelect_limit(args));

					if(Integer.parseInt(sf.getValue("cnt", 0)) > 0){
						throw new Exception("견적 진행상태가 [견적중 또는 견적마감] 인 경우 삭제 불가합니다.");
					}
					
					args = new String[]{ ID, ID, BIZ_NO};
					types = new String[]{"S","S","S"};
    		
                    sxp = new SepoaXmlParser(this, "et_deleteRfgBz");
                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    ssm.doUpdate(new String[][]{args}, types);
				}
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} //
	
	public SepoaOut saveCtList(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_saveCtList(info, bean_args);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
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
	
	private String[] et_saveCtList(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		
		SepoaOut    so  = null;
		
		try
		{
			int cnt = 0;
			SepoaFormater sf = null;

			for (int i = 0; i < bean_info.length; i++)
			{
				String CU                = bean_info[i][0];				
        		String BIZ_NO	         = bean_info[i][1];				
        		String BIZ_SEQ		     = bean_info[i][2];				
        		String MATERIAL_CLASS1   = bean_info[i][3];				
        		String MATERIAL_CLASS2   = bean_info[i][4];				
        		String CT_NM             = bean_info[i][5];				
        		String VENDOR_CODE		 = bean_info[i][6];				
        		String BID_NO	         = bean_info[i][7];				
        		String BID_COUNT		 = bean_info[i][8];				
        		String VENDOR_NAME		 = bean_info[i][9];				
        		
        		SepoaXmlParser sxp = null;
				SepoaSQLManager ssm = null;
				
				String[] args = null;
				String[] types = null;
				//존재하면 Update
				if("".equals(BIZ_SEQ)){
					
					sxp = new SepoaXmlParser(this, "et_maxBizseq_ctivSelect");
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
					
					args = new String[]{ BIZ_NO };
					sf = new SepoaFormater(ssm.doSelect_limit(args));
					BIZ_SEQ = sf.getValue("BIZ_SEQ", 0);
					
					args = new String[]{ BIZ_NO, BIZ_SEQ, MATERIAL_CLASS1, MATERIAL_CLASS2, CT_NM, VENDOR_CODE, BID_NO, BID_COUNT, ID, ID, 	VENDOR_NAME};
					types = new String[]{"S","S","S","S","S","S","S","S","S","S","S"};
					
                    sxp = new SepoaXmlParser(this, "et_insertCt");
                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    ssm.doInsert(new String[][]{args}, types);
					
//					else{
//						sxp = new SepoaXmlParser(this, "et_insertItem_select");
//						ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
//
//						args = new String[]{ info.getSession("HOUSE_CODE"), DEPT, ITEM_NO };
//						sf = new SepoaFormater(ssm.doSelect_limit(args));
//
//						if(Integer.parseInt(sf.getValue("cnt", 0)) > 0){
//							throw new Exception("보유중인 품목을 중복등록 불가합니다. - " + ITEM_NO );
//						}
//						
//						// SepoaDate.getShortDateString(), SepoaDate.getShortTimeString()
//						args = new String[]{ 
//								info.getSession("HOUSE_CODE"), DEPT, ITEM_NO, CRE_GB, DSTR_GB, 
//								STK_USER_ID, STK_USER_NAME_LOC, SepoaDate.getShortDateString(), SepoaDate.getShortTimeString(), NTC_YN, 
//								NTC_LOC, NTC_LOC_ETC, NTC_USER_ID, NTC_USER_NAME_LOC  , NTC_DATE, 
//								NTC_TIME, ABOL_YN, ABOL_USER_ID, ABOL_USER_NAME_LOC, ABOL_DATE, 
//								ABOL_TIME
//						};
//						types = new String[]{"S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S"};
//
//	                    sxp = new SepoaXmlParser(this, "et_insertItem");
//	                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
//	                    ssm.doInsert(new String[][]{args}, types);
//					}
					                    
//				}else{
//					args = new String[]{ DSTR_GB, NTC_YN, NTC_LOC, NTC_LOC_ETC, NTC_USER_ID, 
//							NTC_USER_NAME_LOC , NTC_DATE, NTC_TIME, ABOL_YN, ABOL_USER_ID, 
//							ABOL_USER_NAME_LOC, ABOL_DATE, ABOL_TIME    , info.getSession("HOUSE_CODE"), DEPT, 
//							ITEM_NO};
//					types = new String[]{"S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S"};
//
//                    sxp = new SepoaXmlParser(this, "et_updateItem");
//                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
//                    ssm.doUpdate(new String[][]{args}, types);
//
				}else{
					args = new String[]{ MATERIAL_CLASS1, MATERIAL_CLASS2, CT_NM, VENDOR_CODE, BID_NO, BID_COUNT, ID, ID, VENDOR_NAME, BIZ_NO, BIZ_SEQ};
					types = new String[]{"S","S","S","S","S","S","S","S","S","S","S"};
					
					sxp = new SepoaXmlParser(this, "et_updateCt");
                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    ssm.doUpdate(new String[][]{args}, types);                    
				}
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} //
	
	public SepoaOut deleteCtList(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_deleteCtList(info, bean_args);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
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
	
	private String[] et_deleteCtList(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		
		SepoaOut    so  = null;
		
		try
		{
			int cnt = 0;
			SepoaFormater sf = null;

			for (int i = 0; i < bean_info.length; i++)
			{
				String CU               = bean_info[i][0];				
        		String BIZ_NO           = bean_info[i][1];
        		String BIZ_SEQ          = bean_info[i][2];
        		                            
				SepoaXmlParser sxp = null;
				SepoaSQLManager ssm = null;
				
				String[] args = null;
				String[] types = null;
				if("".equals(CU)){
//					sxp = new SepoaXmlParser(this, "et_deleteBzList_ctivSelect");
//					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
//
//					args = new String[]{ BIZ_NO };
//					sf = new SepoaFormater(ssm.doSelect_limit(args));
//
//					if(Integer.parseInt(sf.getValue("cnt", 0)) > 0){
//						throw new Exception("해당사업번호로 등록된 계약건이 존재하는 경우 삭제 불가합니다.");
//					}
									
					args = new String[]{ ID, ID, BIZ_NO, BIZ_SEQ};
					types = new String[]{"S","S","S","S"};
    		
                    sxp = new SepoaXmlParser(this, "et_deleteCt");
                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    ssm.doUpdate(new String[][]{args}, types);
				}
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} //
	
	// ICT 사용
	public SepoaOut getCtInfo(Map< String, String > headerData)
	{
	    ConnectionContext ctx = getConnectionContext();
	    
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
	
	    String rtnData = null;
	    try {
	        
			sxp = new SepoaXmlParser(this, "getCtInfo");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
	        setValue( ssm.doSelect (headerData)); 
	        setStatus(1);     
	   } catch(Exception e) {
	        Logger.err.println(userid,this,e.getMessage());
	        setStatus(0);
	        setMessage("");
	    }
	    return getSepoaOut();
	}
	
	public SepoaOut setCtSubmit(Map< String, String > headerData)
	{
		ConnectionContext ctx = getConnectionContext(); 
		String company_code   = info.getSession("COMPANY_CODE"); 
		String USER_ID         = info.getSession("ID");
		String NAME_LOC        = info.getSession("NAME_LOC");
		String NAME_ENG        = info.getSession("NAME_ENG");
		String DEPT            = info.getSession("DEPARTMENT");
		int rtn = 0;
		
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		
		String[] args = null;
		
		try {
			
			String CU              = MapUtils.getString( headerData, "cu"              );				
			String BIZ_NO          = MapUtils.getString( headerData, "biz_no"          );				
			String BIZ_SEQ         = MapUtils.getString( headerData, "biz_seq"         );				
			String BID_NO          = MapUtils.getString( headerData, "bid_no"          );				
			String BID_COUNT       = MapUtils.getString( headerData, "bid_count"       );				
			String VOTE_COUNT      = MapUtils.getString( headerData, "vote_count"      );				
			String PUM_NO          = MapUtils.getString( headerData, "pum_no"          );				
			String ANN_NO          = MapUtils.getString( headerData, "ann_no"          );				
			String CT_NM           = MapUtils.getString( headerData, "ct_nm"           );				
			String VENDOR_CODE     = MapUtils.getString( headerData, "vendor_code"     );				
			String MATERIAL_CLASS1 = MapUtils.getString( headerData, "material_class1" );				
			String MATERIAL_CLASS2 = MapUtils.getString( headerData, "material_class2" );				
			String ATTACH_NO       = MapUtils.getString( headerData, "attach_no"       );				
			String VENDOR_NAME     = MapUtils.getString( headerData, "vendor_name"     );				
			
			if("C".equals(CU)){				
				sxp = new SepoaXmlParser(this, "et_maxBizseq_ctivSelect");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
				
				args = new String[]{ BIZ_NO };
				sf = new SepoaFormater(ssm.doSelect_limit(args));
				BIZ_SEQ = sf.getValue("BIZ_SEQ", 0);
				
				headerData.put("HOUSE_CODE", HOUSE_CODE); 
				headerData.put("COMPANY_CODE", company_code); 
				headerData.put("ID", 			USER_ID);
				headerData.put("NAME_LOC", 		NAME_LOC);
				headerData.put("NAME_ENG", 		NAME_ENG); 
				headerData.put("DEPT", 			DEPT); 
				
				headerData.put("CU"             , CU             ); 
				headerData.put("BIZ_NO"         , BIZ_NO         ); 
				headerData.put("BIZ_SEQ"        , BIZ_SEQ        ); 
				headerData.put("BID_NO"         , BID_NO         ); 
				headerData.put("BID_COUNT"      , BID_COUNT      ); 
				headerData.put("VOTE_COUNT"     , VOTE_COUNT     ); 
				headerData.put("PUM_NO"         , PUM_NO         ); 
				headerData.put("ANN_NO"         , ANN_NO         );
				headerData.put("CT_NM"          , CT_NM          );
				headerData.put("VENDOR_CODE"    , VENDOR_CODE    ); 
				headerData.put("MATERIAL_CLASS1", MATERIAL_CLASS1); 
				headerData.put("MATERIAL_CLASS2", MATERIAL_CLASS2); 
				headerData.put("ATTACH_NO"      , ATTACH_NO      );
				headerData.put("VENDOR_NAME"    , VENDOR_NAME    ); 
				
				sxp = new SepoaXmlParser(this, "et_insertCtSubmit");
	    		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
	    		rtn = ssm.doInsert(headerData); 
			}else{
				headerData.put("HOUSE_CODE", HOUSE_CODE); 
				headerData.put("COMPANY_CODE", company_code); 
				headerData.put("ID", 			USER_ID);
				headerData.put("NAME_LOC", 		NAME_LOC);
				headerData.put("NAME_ENG", 		NAME_ENG); 
				headerData.put("DEPT", 			DEPT); 
				
				headerData.put("CU"             , CU             ); 
				headerData.put("BIZ_NO"         , BIZ_NO         ); 
				headerData.put("BIZ_SEQ"        , BIZ_SEQ        ); 
				headerData.put("BID_NO"         , BID_NO         ); 
				headerData.put("BID_COUNT"      , BID_COUNT      ); 
				headerData.put("VOTE_COUNT"     , VOTE_COUNT     ); 
				headerData.put("PUM_NO"         , PUM_NO         ); 
				headerData.put("ANN_NO"         , ANN_NO         );
				headerData.put("CT_NM"          , CT_NM          );
				headerData.put("VENDOR_CODE"    , VENDOR_CODE    ); 
				headerData.put("MATERIAL_CLASS1", MATERIAL_CLASS1); 
				headerData.put("MATERIAL_CLASS2", MATERIAL_CLASS2); 
				headerData.put("ATTACH_NO"      , ATTACH_NO      );
				headerData.put("VENDOR_NAME"    , VENDOR_NAME    ); 
				
				sxp = new SepoaXmlParser(this, "et_updateCtSubmit");
	    		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
	    		rtn = ssm.doInsert(headerData); 
			}
			
			
												
//			String status = et_chkConfirm(headerData); // 확정여부 체크
//			
//			if ("Y".equals(status)){
//				setFlag( false );
//				setStatus(0);
//				setMessage("계약서류 적합이되어 다시 업로드불가합니다.");
//				return getSepoaOut();
//			}
			
			setFlag( true );
			setStatus(1);
			setValue(rtn+""); 
			setMessage("계약서류가 업로드되었습니다");
			
			Commit();
		} catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage("");
			setFlag( false );
		}
		return getSepoaOut();
	}
	
	
	
	
	
	
	
	
	
	
	
	
	public SepoaOut getIvResultList(Map< String, String > headerData, String biz_no)
	{
        ConnectionContext ctx = getConnectionContext(); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {

			sxp = new SepoaXmlParser(this, "getIvResultList");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  

		
            headerData.put( "biz_no", biz_no ); 
            
            setValue(ssm.doSelect(headerData));
 
            setStatus(1);
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    }
	
	// ICT 사용
		public SepoaOut getIvInfo(Map< String, String > headerData)
		{
		    ConnectionContext ctx = getConnectionContext();
		    
			SepoaXmlParser sxp = null;
			SepoaSQLManager ssm = null;
		
		    String rtnData = null;
		    try {
		        
				sxp = new SepoaXmlParser(this, "getIvInfo");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
		        setValue( ssm.doSelect (headerData)); 
		        setStatus(1);     
		   } catch(Exception e) {
		        Logger.err.println(userid,this,e.getMessage());
		        setStatus(0);
		        setMessage("");
		    }
		    return getSepoaOut();
		}
		
		public SepoaOut setIvSubmit(Map< String, String > headerData)
		{
			ConnectionContext ctx = getConnectionContext(); 
			String company_code   = info.getSession("COMPANY_CODE"); 
			String USER_ID         = info.getSession("ID");
			String NAME_LOC        = info.getSession("NAME_LOC");
			String NAME_ENG        = info.getSession("NAME_ENG");
			String DEPT            = info.getSession("DEPARTMENT");
			int rtn = 0;
			
			
			SepoaXmlParser sxp = null;
			SepoaSQLManager ssm = null;
			SepoaFormater sf = null;
			
			String[] args = null;
			
			try {
				
				String CU              = MapUtils.getString( headerData, "cu"              );				
				String BIZ_NO          = MapUtils.getString( headerData, "biz_no"          );				
				String BIZ_SEQ         = MapUtils.getString( headerData, "biz_seq"         );				
				String BID_NO          = MapUtils.getString( headerData, "bid_no"          );				
				String BID_COUNT       = MapUtils.getString( headerData, "bid_count"       );				
				String VOTE_COUNT      = MapUtils.getString( headerData, "vote_count"      );				
				String PUM_NO          = MapUtils.getString( headerData, "pum_no"          );				
				String ANN_NO          = MapUtils.getString( headerData, "ann_no"          );				
				String CT_NM           = MapUtils.getString( headerData, "ct_nm"           );				
				String VENDOR_CODE     = MapUtils.getString( headerData, "vendor_code"     );				
				String MATERIAL_CLASS1 = MapUtils.getString( headerData, "material_class1" );				
				String MATERIAL_CLASS2 = MapUtils.getString( headerData, "material_class2" );				
				String ATTACH_NO       = MapUtils.getString( headerData, "attach_no"       );				
				
				if(!"C".equals(CU)){				
					headerData.put("HOUSE_CODE", HOUSE_CODE); 
					headerData.put("COMPANY_CODE", company_code); 
					headerData.put("ID", 			USER_ID);
					headerData.put("NAME_LOC", 		NAME_LOC);
					headerData.put("NAME_ENG", 		NAME_ENG); 
					headerData.put("DEPT", 			DEPT); 
					
					headerData.put("CU"             , CU             ); 
					headerData.put("BIZ_NO"         , BIZ_NO         ); 
					headerData.put("BIZ_SEQ"        , BIZ_SEQ        ); 
					headerData.put("BID_NO"         , BID_NO         ); 
					headerData.put("BID_COUNT"      , BID_COUNT      ); 
					headerData.put("VOTE_COUNT"     , VOTE_COUNT     ); 
					headerData.put("PUM_NO"         , PUM_NO         ); 
					headerData.put("ANN_NO"         , ANN_NO         );
					headerData.put("CT_NM"          , CT_NM          );
					headerData.put("VENDOR_CODE"    , VENDOR_CODE    ); 
					headerData.put("MATERIAL_CLASS1", MATERIAL_CLASS1); 
					headerData.put("MATERIAL_CLASS2", MATERIAL_CLASS2); 
					headerData.put("ATTACH_NO"      , ATTACH_NO      );
					
					sxp = new SepoaXmlParser(this, "et_updateIvSubmit");
		    		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
		    		rtn = ssm.doInsert(headerData); 
				}
				
				
													
//				String status = et_chkConfirm(headerData); // 확정여부 체크
//				
//				if ("Y".equals(status)){
//					setFlag( false );
//					setStatus(0);
//					setMessage("계약서류 적합이되어 다시 업로드불가합니다.");
//					return getSepoaOut();
//				}
				
				setFlag( true );
				setStatus(1);
				setValue(rtn+""); 
				setMessage("검수확인서가 업로드되었습니다");
				
				Commit();
			} catch(Exception e) {
				Logger.err.println(userid,this,e.getMessage());
				setStatus(0);
				setMessage("");
				setFlag( false );
			}
			return getSepoaOut();
		}
			
} 
 
 
