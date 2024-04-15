package ict.dt.rfq;

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
public class I_p1002 extends SepoaService 
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

    public I_p1002( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.sys.println( "getConfig error : " + e.getMessage() );
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


	public SepoaOut getRfqBzList(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
        	sxp = new SepoaXmlParser(this, "getRfqBzList");
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
	
	public SepoaOut saveRfqBzList(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_saveRfqBzList(info, bean_args);

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
	
	private String[] et_saveRfqBzList(SepoaInfo info, String[][] bean_info) throws Exception
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
				String CRUD               = bean_info[i][0];				
        		String BIZ_NO             = bean_info[i][1];
        		String BIZ_NM             = bean_info[i][2];
        		String BIZ_STATUS         = bean_info[i][3];
                                            
				SepoaXmlParser sxp = null;
				SepoaSQLManager ssm = null;
				
				String[] args = null;
				String[] types = null;
				//존재하면 Update
				if("C".equals(CRUD)){
					
					if( BIZ_NO == null || "".equals( BIZ_NO ) || BIZ_NO.length() < 1 ) { 
		            	so        = DocumentUtil.getDocNumber( info, "IBZ" );  
		            	BIZ_NO = so.result[0];		                
		            }            
		            
					args = new String[]{ BIZ_NO, BIZ_NM, BIZ_STATUS, ID, ID, ID, ID};
					types = new String[]{"S","S","S","S","S","S","S"};
    		
                    sxp = new SepoaXmlParser(this, "et_insertItem");
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
				}else if("R".equals(CRUD)){
										
					args = new String[]{ BIZ_NM, BIZ_STATUS, ID, ID,  BIZ_NO};
					types = new String[]{"S","S","S","S","S"};
    		
                    sxp = new SepoaXmlParser(this, "et_updateRfgBz");
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
	
	
	public SepoaOut deleteRfqBzList(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_deleteRfqBzList(info, bean_args);

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
	
	private String[] et_deleteRfqBzList(SepoaInfo info, String[][] bean_info) throws Exception
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
				String CRUD               = bean_info[i][0];				
        		String BIZ_NO             = bean_info[i][1];
        		String BIZ_NM             = bean_info[i][2];
        		String BIZ_STATUS         = bean_info[i][3];
                                            
				SepoaXmlParser sxp = null;
				SepoaSQLManager ssm = null;
				
				String[] args = null;
				String[] types = null;
				if("R".equals(CRUD)){
					sxp = new SepoaXmlParser(this, "et_deleteRfqBzList_ctivSelect");
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());

					args = new String[]{ BIZ_NO };
					sf = new SepoaFormater(ssm.doSelect_limit(args));

					if(Integer.parseInt(sf.getValue("cnt", 0)) > 0){
						throw new Exception("해당사업번호로 등록된 계약건이 존재하는 경우 삭제 불가합니다.");
					}
					
					sxp = new SepoaXmlParser(this, "et_deleteRfqBzList_bdhdSelect");
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());

					args = new String[]{ BIZ_NO };
					sf = new SepoaFormater(ssm.doSelect_limit(args));

					if(Integer.parseInt(sf.getValue("cnt", 0)) > 0){
						throw new Exception("해당사업번호로 진행중인 입찰공문이 존재하는 경우 삭제 불가합니다.");
					}
					
					sxp = new SepoaXmlParser(this, "et_deleteRfqBzList_select");
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
	
	public SepoaOut	getQuery_BIZNO(String flag) 
	{ 
//		String rtn = ""; 
//		ConnectionContext ctx =	getConnectionContext(); 
//		try	{ 
//			
//			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
// 
//			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
// 
//			flag = ("1".equals(flag)) ? "P":"P,E";
//						
//			String[] args =	{flag}; 
//			
//			rtn	= sm.doSelect(args);
// 
//			setValue(rtn); 
//			setStatus(1); 
//		}catch (Exception e){ 
//			Logger.err.println(info.getSession("ID"),this,"Exception e ==============>"	+ e.getMessage()); 
//			setStatus(0); 
//		} 
//		return getSepoaOut(); 
		
		
		ConnectionContext ctx                   = getConnectionContext();
		SepoaXmlParser    sxp                   = null;
		SepoaSQLManager   ssm                   = null;
		
		Map<String, String> param = null;
		
		
		try{
			param = new HashMap<String, String>();
			param.put("flag",   flag);
			
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			//sxp.addVar("flag", flag);
			
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	setValue(ssm.doSelect(param));
        	setStatus(1); 

		}catch (Exception e){
			
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
		
	} 
			
			
} 
 
 
