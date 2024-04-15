package sepoa.svc.sourcing;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;


public class BD_011 extends SepoaService
{
	private HashMap msg = null;

    public BD_011(String opt, SepoaInfo info) throws SepoaServiceException
    {
        super(opt, info);
        setVersion( "1.0.0" );
        try {

            msg = MessageUtil.getMessageMap( info, "BD_001");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.sys.println( "BD_011 : " + e.getMessage() );
        }

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

    /**
     *  헤더 조회
     */
    public SepoaOut bdHdDisplay(String[] args)
    {
        try
        {
            String rtnHD = et_bdHdDisplay(args);
            setStatus(1);
            setValue(rtnHD);
            //setMessage(msg.getMessage("0000"));
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            setStatus(0);

            //setMessage(msg.getMessage("0001"));
        }

        return getSepoaOut();
    } //End of bdHdDisplay()

    private String et_bdHdDisplay(String[] args) throws Exception
    {
    	
   
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        try
        {

            
            HashMap map = new HashMap();
            
            String bd_no	= args[0];
            String bd_count = args[1];
         	SepoaXmlParser sxp  = new SepoaXmlParser();
   			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
   			
   			map.put("bd_no"		, bd_no);
            map.put("bd_count"	, bd_count);
            map.put("language"	, info.getSession("LANGUAGE"));
            
         	rtn = ssm.doSelect(map);
   			setValue(rtn);
        	
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    } //End of et_bdHdDisplay()

    /**
     *  디테일 조회
     */
    public SepoaOut bdDtDisplay(Map<String, String> headerData)
    {
        try
        {
            String rtn = et_bdDtDisplay(headerData);
            setStatus(1);
            setValue(rtn);
            //setMessage(msg.getMessage("0000"));
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            setStatus(0);

            //setMessage(msg.getMessage("0001"));
        }

        return getSepoaOut();
    } //End of bdDtDisplay()

    private String et_bdDtDisplay(Map<String, String> headerData) throws Exception
    {
        String rtn = null;
		ConnectionContext ctx = getConnectionContext();
        try
        {
        	  HashMap map = new HashMap();
              
        	  SepoaXmlParser sxp  = new SepoaXmlParser();
        	  SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);

              
     			rtn = ssm.doSelect(headerData);
     			setValue(rtn);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    } //End of et_bdDtDisplay()
 
    
    


    /*
     * 입찰공고 확정
     */
    public SepoaOut setBDSend( Map< String, String > headerData ) {

           ConnectionContext ctx = getConnectionContext();
           String language = info.getSession( "LANGUAGE" );
           int  rtn = 0;
           
           
           try
           {
        	   
        	   SepoaXmlParser sxp = new SepoaXmlParser();
        	   SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
   			
        	   headerData.put("house_code"		, info.getSession("HOUSE_CODE"));
        	   headerData.put("company_code"	, info.getSession("COMPANY_CODE"));
        	   
        	   rtn = ssm.doUpdate(headerData);
	            
               if( rtn > 0 ){
            	   
	                setStatus( 1 );
	                setFlag( true );
	    			Commit();
               
               }

           } catch( Exception e ) {
               setStatus( 0 );
               setFlag( false );
               setMessage( e.getMessage() );
               Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
           }

           return getSepoaOut();

       }  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //정정공고
    public SepoaOut setReBdSave( String[] bd_data) throws Exception
	{
		try
		{
			String[] rtn1 = null;
			
			setStatus(1);
			setFlag(true);
			
			//SEBGL UPDATE
			rtn1 = et_setReBdHdSave(bd_data);
			
			
			if (rtn1[1] != null)
			{
				Rollback();
				setMessage(rtn1[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn1[1]);
				setStatus(0);
				setFlag(false);
			}
			
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}    
    
  //수정
    public SepoaOut setBDUpdate( Map< String, Object > allData ) throws Exception
	{

		Map< String, String >           headerData  = null;
		List< Map< String, String > >   gridData    = null;
		
		String bd_no		= "";
		String pub_no		= "";
		String bd_count		= "";
		String explan_flag	= "";
		
		int rtn0    = 0;
		int rtn1    = 0;
		int rtn2    = 0;
		int rtn3    = 0;
		int rtn4    = 0;
		int rtn5    = 0;
		int rtn6    = 0;
		int signup  = 0;

	        try {
 
	            setFlag( true );
	            setStatus( 1 );

	            
	            /***************************************************************
	             * 1. 입찰 해더 정보 (SEBGL) 수정
	             **************************************************************/
	            rtn2 = et_setEBGLUpdate( allData );
	            if( rtn2 < 1 ) {
	                Rollback();
	                //입력중 오류가 발생했습니다.
	                setMessage( msg.get( "PU_113.0000" ).toString());
	                setStatus( 0 );
	                setFlag( false );
	                return getSepoaOut();
	            }

	            
	            /***************************************************************
	             * 2. 입찰 상세 정보 (SEBLN) 수정
	             **************************************************************/
	            rtn3 = et_setEBLNUpdate( allData );
	            
	            
	            if( rtn3 < 1 ) {
	                Rollback();
	                //입력중 오류가 발생했습니다.
	                setMessage( msg.get( "PU_113.0000" ).toString());
	                setStatus( 0 );
	                setFlag( false );
	                return getSepoaOut();
	            }

	            /***************************************************************
	             * 4. 입찰   대상업체 정보 (SEBSE) 생성
	             **************************************************************/
	            /*
	            rtn4 = et_setEBSECreate( allData );
	            if( rtn4 < 1 ) {
	                Rollback();
	                //입력중 오류가 발생했습니다.
	                setMessage( msg.get( "PU_113.0000" ).toString());
	                setStatus( 0 );
	                setFlag( false );
	                return getSepoaOut();
	            }
				*/
	            
	            
	            /*************************************************************************** 
	             * 8. 메일 발송
	             **************************************************************************/
	            
				String development_flag = getConfig("sepoa.server.development.flag");
				//개발장비인 경우 메일발송

				//String rfq_flag  = MapUtils.getString( headerData, "rfq_status", "" );
				//String subject 	 = MapUtils.getString( headerData, "subject"   , "" );
		       // String rp_type   = "";
		        
		        /*
		        String bd_flag = "";
				if("P".equals(bd_flag))
				{

					PU_112_Mail mail = new PU_112_Mail( info , this ); 
	                    String result = mail.sendMailToSellerDongA( rfq_number , subject , mail_type , rp_type , headerData );
	                    if(result.contains("E")){
	                    	setStatus(3);
	                    }
	                
					sendToSeller(headerData);
				
				}			
	            
	            if(getStatus() == 3){
	            	setMessage( msg.get( "PU_113.0001" ).toString() + " (email 처리중 오류가 발생하였습니다.)");
	            }else{
	            	
	            	setStatus( 1 );
	            	setMessage( msg.get( "PU_113.0001" ).toString());
	            }
	            */	
	            
	            setFlag( true );
	            
	            setValue(bd_no);
	            
	            Commit();
	     	   

	        } catch( Exception e ) {
	            try {
	                Rollback();
	            } catch( Exception d ) {
	                Logger.err.println( info.getSession( "ID" ), this, d.getMessage() );
	            }

	            
	            Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
	            setFlag( false );
	            setStatus( 0 );
	            //setMessage( e.getMessage() );
	        }
	        return getSepoaOut();
//	        finally{
//	        	return getSepoaOut();
//	        }	      
	    }
		    
		 /**
	     * 입찰요청 해더정보(SEBGL) 수정
	     * 
	     * @param allData
	     * @return
	     * @throws Exception
	     */
	    private int et_setEBGLUpdate( Map< String, Object > allData ) throws Exception {

	        int     rtn = 0;

	        ConnectionContext ctx = getConnectionContext();
	        StringBuffer sb = new StringBuffer();
	        ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );

	        Map< String, String >           headerData  = null;
	        
	        try { 
	        	
	            headerData  = MapUtils.getMap( allData, "headerData" );

	            headerData.put("house_code"				, info.getSession("HOUSE_CODE"));
	            headerData.put("company_code"		, info.getSession("COMPANY_CODE"));
	            headerData.put("bd_status"   				, "T");//입찰상태
	            

	            headerData.put("req_begin_date"	,SepoaString.getDateUnSlashFormat(MapUtils.getString( headerData, "req_begin_date", "" )));
	            headerData.put("req_end_date"		,SepoaString.getDateUnSlashFormat(MapUtils.getString( headerData, "req_end_date", "" )));
	            headerData.put("bd_open_date"		,SepoaString.getDateUnSlashFormat(MapUtils.getString( headerData, "bd_open_date", "" )));
	            headerData.put("prop_sub_date"		,SepoaString.getDateUnSlashFormat(MapUtils.getString( headerData, "prop_sub_date", "" )));
	            
				SepoaXmlParser sxp = new SepoaXmlParser();
				
				
				
				SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				
				
				rtn = ssm.doInsert(headerData); 
				
				
				
	        } catch( Exception e ) {
	            
	            Logger.debug.println( info.getSession( "ID" ), this, e.getMessage() );
	        } finally {
	        }

	        return rtn;

	    }

	    /**
	     * 입찰요청 상세 정보 (SEBLN) 수정
	     * 
	     * @param allData
	     * @return
	     * @throws Exception
	     */
	    private int et_setEBLNUpdate( Map< String, Object > allData ) throws Exception {

	        ConnectionContext ctx = getConnectionContext();
	        StringBuffer sb = new StringBuffer();
	        ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );

	        Map< String, String >				headerData 	= null;
	        Map< String, String >				gridRowData	= null;
	        List< Map< String, String > >	gridData			= null;
	 
	        int         intGridRowData  = 0;
	        int         rtn					= 0;
	        int         rfq_seq				= 0;
	        int         reValue				= 0;

	        try {

	            headerData  = MapUtils.getMap( allData, "headerData", null );
	            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );

	         
	    		SepoaXmlParser sxp = null;
				SepoaSQLManager ssm = null;
				
				headerData.put("house_code"				, info.getSession("HOUSE_CODE"));
 	            headerData.put("company_code"		, info.getSession("COMPANY_CODE"));
              

	            if( gridData != null && gridData.size() > 0 ) {

	                
	            	  
	           		sxp = new SepoaXmlParser();
        			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
        			
        			reValue = ssm.doInsert(gridData, headerData);  
        			rtn  = reValue;
	            }
	        
	            

	        } catch( Exception e ) {
	            
	            Logger.debug.println( info.getSession( "ID" ), this, e.getMessage() );
	        } finally {
	        }

	        return rtn;

	    }

	    /**
	     * 업체선택으로 셋팅한 업체 저장
	     * 
	     * @param allData
	     * @return
	     * @throws Exception
	     */
	    private int et_setEBSECreate( Map< String, Object > allData ) throws Exception {

	        ConnectionContext ctx = getConnectionContext();
	        StringBuffer sb = new StringBuffer();
	        ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );
	        SepoaFormater   wf  = null;

	        Map< String, String >           headerData  = null;
	        Map< String, String >           gridRowData = null;
	        List< Map< String, String > >   gridData    = null;
	        
	        Map map = new HashMap();

	        int         rtn             = 0;
	        int         intGridRowData  = 0;
	        String[]    strDivide0;        
	        String[]    strDivide1;        

	        String      SELLER_CODE     = "";
	            

	        try {
	            
	            headerData  = MapUtils.getMap( allData, "headerData", null );
	            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );

				SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setRfqSECreate_deleteSE");                     
				SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  

				map.put("RFQ_NUMBER"	, MapUtils.getString( headerData, "rfq_number", "" ));
				map.put("RFQ_COUNT"		, MapUtils.getString( headerData, "rfq_count", "" ));
	 
				ssm.doDelete(map); 

	            if( gridData != null && gridData.size() > 0 ) {

	                intGridRowData  = gridData.size();

	                // 그리드의 데이터 만큼 돌린다.
	                for( int i = 0; i < intGridRowData; i++ ) {

	                    gridRowData = gridData.get( i );
	                    gridRowData.put ( "SELLER_SELECTED" ,  MapUtils.getString( gridRowData, "SELLER_SELECTED", "" ).replaceAll ( "&#64;" , "@" ).replaceAll ( "&#40;" , "(").replaceAll ( "&#41;" , ")" ) );
	                    strDivide0  = SepoaString.parser( MapUtils.getString( gridRowData, "SELLER_SELECTED", "" ), "#" );

	                    if( strDivide0 != null && strDivide0.length > 0 ) {

	                        // 그리드의 업체 데이터 수만큼 돌린다.
	                        for( int j = 0; j < strDivide0.length; j++ ) {

	                            strDivide1  = SepoaString.parser( strDivide0[j], "@" );

	                            SELLER_CODE = strDivide1[0].trim();
	                            
	                            
	                            String SELLER_SEQ  = strDivide1[5].trim();
	                            String[] SELLER_SEQS = SELLER_SEQ.split ( "!" ); 
	                            
	                            SELLER_SEQ = "";
	                            for(int k = 0 ; k < SELLER_SEQS.length ; k++){
	                                if(SELLER_SEQS[k].indexOf ( SELLER_CODE ) != -1){
	                                    SELLER_SEQ += SELLER_SEQS[k] + "!";
	                                }
	                            }
	                            
	 
	                            gridRowData.put( "COMPANY_CODE",    MapUtils.getString( headerData, "t_company_code", "" ) );
	                            gridRowData.put( "CURRENT_DATE",    MapUtils.getString( headerData, "current_date",     "" ) );
	                            gridRowData.put( "CURRENT_TIME",    MapUtils.getString( headerData, "current_time",     "" ) );
	                            gridRowData.put( "SESSION_USER_ID", MapUtils.getString( headerData, "session_user_id",  "" ) );
	                            gridRowData.put( "CONFIRM_FLAG",    "S" ); // CONFIRM_FLAG( S:진행중, Y:완료, R:포기/거부)
	                            gridRowData.put( "DEL_FLAG",        "N" );
	                            gridRowData.put( "SELLER_CODE",        SELLER_CODE );

	                			sxp = new SepoaXmlParser(this, "et_setRfqSECreate_selectQT");                     
	                			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
	                			
	                			String result = ssm.doSelect (gridRowData);
	  
	                            SepoaFormater sf = new SepoaFormater ( result );
	                            
	                            if(Integer.parseInt(sf.getValue("CNT", 0))>0){
	                            	gridRowData.put( "CONFIRM_FLAG",    "P" ); // CONFIRM_FLAG( S:진행중, Y:완료, R:포기/거부, P:동일한 견적서 사용)
	                            }
	                            

	                			sxp = new SepoaXmlParser(this, "et_setEBSECreate");                     
	                			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  

	                            rtn  = ssm.doInsert( gridRowData );

	                        }

	                    // 선택업체가 없을경우 에러방지용
	                    } else {
	                        rtn = 1;
	                    }

	                }

	            }

	        } catch( Exception e ) {
	            
	            Logger.debug.println( info.getSession( "ID" ), this, e.getMessage() );
	        } finally {
	        }

	        return rtn;
	    }

    
    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
    
    //사양설명회
    public SepoaOut setExplain( String[] exp_data ) throws Exception
	{
		try
		{
			String[] rtn1 = null;
			
			//SEBGL UPDATE
			rtn1 = et_setExplain(exp_data);			
		
			setStatus(1);
			//setMessage(msg.getMessage("0003"));
			setFlag(true);
			
		
			if (rtn1[1] != null)
			{
				Rollback();
				setMessage(rtn1[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn1[1]);
				setStatus(0);
				setFlag(false);
			}
			
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
    
    //사양설명회 SEBGL
	private String[] et_setExplain(String[] exp_data) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sql = new StringBuffer();
		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
		
		String ADD_DATE = SepoaDate.getShortDateString();
		String ADD_TIME = SepoaDate.getShortTimeString();
		String ADD_USER_ID = info.getSession("ID");
		String NAME_LOC = info.getSession("NAME_LOC");
		
		String NAME_ENG = info.getSession("NAME_ENG");
		String DEPT     = info.getSession("DEPARTMENT");

		try
		{			

			//사양설명회
			String explain_date     = exp_data[0];  //개최일
			String exp_from_time    = exp_data[1];
			String exp_to_time      = exp_data[2];
			String explain_area     = exp_data[3];  //지역
			String explain_place    = exp_data[4];  //장소
			String explain_flag     = exp_data[5];  //참석필수여부
			String explain_resp     = exp_data[6];  //담당자
			String explain_tel      = exp_data[7];  //문의처
			String explain_comment  = exp_data[8];  //특기사항
			String bd_no            = exp_data[9];  //입찰공고번호
			String bd_count         = exp_data[10];  //입찰공고차수

			sm.removeAllValue();
			sql.delete(0, sql.length());
			sql.append("UPDATE SEBGL SET                 \n");
			sql.append("       ADD_DATE          = ?  \n"); sm.addStringParameter(ADD_DATE);
			sql.append("     , ADD_TIME          = ?  \n"); sm.addStringParameter(ADD_TIME);			
			sql.append("     ,  CHANGE_DATE          = ?  \n"); sm.addStringParameter(ADD_DATE);
			sql.append("     , CHANGE_TIME          = ?  \n"); sm.addStringParameter(ADD_TIME);
			sql.append("     , CHANGE_USER_ID       = ?  \n"); sm.addStringParameter(ADD_USER_ID);
			sql.append("     , CHANGE_USER_NAME_LOC = ?  \n"); sm.addStringParameter(NAME_LOC);
			sql.append("     , CHANGE_USER_NAME_ENG = ?  \n"); sm.addStringParameter(NAME_ENG);
			sql.append("     , CHANGE_USER_DEPT     = ?  \n"); sm.addStringParameter(DEPT);
			sql.append("     , EXPLAIN_DATE         = ?  \n"); sm.addStringParameter(explain_date);
			sql.append("     , EXPLAIN_TIME_FROM    = ?  \n"); sm.addStringParameter(exp_from_time);
			sql.append("     , EXPLAIN_TIME_TO      = ?  \n"); sm.addStringParameter(exp_to_time);
			sql.append("     , EXPLAIN_AREA         = ?  \n"); sm.addStringParameter(explain_area);
			sql.append("     , EXPLAIN_PLACE        = ?  \n"); sm.addStringParameter(explain_place);
			sql.append("     , EXPLAIN_FLAG         = ?  \n"); sm.addStringParameter(explain_flag);
			sql.append("     , EXPLAIN_RESP         = ?  \n"); sm.addStringParameter(explain_resp);
			sql.append("     , EXPLAIN_TEL          = ?  \n"); sm.addStringParameter(explain_tel);
			sql.append("     , EXPLAIN_COMMENT      = ?  \n"); sm.addStringParameter(explain_comment);
			sql.append(" WHERE BD_NO                = ?  \n "); sm.addStringParameter(bd_no);
			sql.append("   AND BD_COUNT             = ?  \n "); sm.addStringParameter(bd_count);
			sql.append("   AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N')  = 'N' \n ");
			
			rtn[0] = String.valueOf(sm.doUpdate(sql.toString()));

		}
		catch (Exception e)
		{
			//rtn[1] = e.getMessage();
			rtn[1] = "사양설명회 저장에 실패하였습니다.";
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} // End of et_setExplain()    
 
	
	
	
    //정정공고SEBGL
	private String[] et_setReBdHdSave(String[] bd_data) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sql = new StringBuffer();
		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
		
		String ADD_DATE = SepoaDate.getShortDateString();
		String ADD_TIME = SepoaDate.getShortTimeString();
		String NAME_ENG = info.getSession("NAME_ENG");
		String DEPT     = info.getSession("DEPARTMENT");

		try
		{
			

			String bd_no                 	= bd_data[0];
			String bd_count                 = bd_data[1];
			String pub_date              	= bd_data[2];
			String pub_item                 = bd_data[3];
			String req_begin_date           = bd_data[4];
			String req_begin_time           = bd_data[5];
			String req_end_date         	= bd_data[6];
			String req_end_time             = bd_data[7];
			String bd_open_date             = bd_data[8];
			String bd_open_time         	= bd_data[9];
			String attach_no     			= bd_data[10];
			String prop_sub_date           	= bd_data[11];
			String prop_sub_time           	= bd_data[12];
			String attach_no1             	= bd_data[13];

			sm.removeAllValue();
			sql.delete(0, sql.length());
			sql.append("UPDATE SEBGL SET                 \n");
			sql.append("      PUB_ITEM             = ?  \n"); sm.addStringParameter(pub_item);
			sql.append("     , REQ_BEGIN_DATE       = ?  \n"); sm.addStringParameter(req_begin_date);
			sql.append("     , REQ_BEGIN_TIME       = ?  \n"); sm.addStringParameter(req_begin_time);
			sql.append("     , REQ_END_DATE         = ?  \n"); sm.addStringParameter(req_end_date);
			sql.append("     , REQ_END_TIME         = ?  \n"); sm.addStringParameter(req_end_time);
			sql.append("     , BD_OPEN_DATE         = ?  \n"); sm.addStringParameter(bd_open_date);
			sql.append("     , BD_OPEN_TIME         = ?  \n"); sm.addStringParameter(bd_open_time);
			sql.append("     , ATTACH_NO            = ?  \n"); sm.addStringParameter(attach_no);
			sql.append("     , ATTACH_NO1           = ?  \n"); sm.addStringParameter(attach_no1);
			sql.append("     , CHANGE_DATE          = ?  \n"); sm.addStringParameter(ADD_DATE);
			sql.append("     , CHANGE_TIME          = ?  \n"); sm.addStringParameter(ADD_TIME);
			sql.append("     , PROP_SUB_DATE        = ?  \n"); sm.addStringParameter(prop_sub_date);
			sql.append("     , PROP_SUB_TIME		= ?  \n"); sm.addStringParameter(prop_sub_time);
			//sql.append("     , BD_STATUS    		= ?  \n"); sm.addStringParameter("UB");
			
			sql.append(" WHERE BD_NO                = ?  \n "); sm.addStringParameter(bd_no);
			sql.append("   AND BD_COUNT             = ?  \n "); sm.addStringParameter(bd_count);
			sql.append("   AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N')  = 'N' \n ");
			
			rtn[0] = String.valueOf(sm.doUpdate(sql.toString()));

		}
		catch (Exception e)
		{
			//rtn[1] = e.getMessage();
			rtn[1] = "수정을 실패하였습니다.";
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} // End of et_setBdHdSave()	
	
    
    //수정 SEBGL
	private String[] et_setBdHdSave(String[] bd_data, String[] exp_data) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sql = new StringBuffer();
		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
		
		String ADD_DATE = SepoaDate.getShortDateString();
		String ADD_TIME = SepoaDate.getShortTimeString();
		String NAME_ENG = info.getSession("NAME_ENG");
		String DEPT     = info.getSession("DEPARTMENT");

		try
		{
			

			String pub_date                 = bd_data[0];  //--공고일자
			String pub_item                 = bd_data[1];  //--입찰건명
			String bd_category              = bd_data[2];  //--입찰종류
			String bd_type                  = bd_data[3];  //--입찰방법
			String bd_methode               = bd_data[4];  //--입찰형태
			String change_user_id           = bd_data[5];  //--입찰담당자
			String change_user_name         = bd_data[6];  //--입찰담당자명
			String jodal_bd_no              = bd_data[7];  //--조달청입찰번호
			String limit_crit               = bd_data[8];  //--제한조건
			String security_payment         = bd_data[9];  //--보증금전자납부
			String budget_estimate_flag     = bd_data[10]; //--예산/추정가격공개
			String req_begin_date           = bd_data[11]; //--입찰서제출일시
			String req_begin_time           = bd_data[12]; //--
			String req_end_date             = bd_data[13]; //--
			String req_end_time             = bd_data[14]; //--
			String bd_open_date             = bd_data[15]; //--개찰일시
			String bd_open_time             = bd_data[16]; //--
			String bd_eligibility           = bd_data[17]; //--입찰참가자격
			String req_etc                  = bd_data[18]; //--기타사항
			String attach_no                = bd_data[19]; //--공고서첨부파일
			String prepare_kind             = bd_data[20]; //--예정가격기준
			String prepare_rate             = bd_data[21]; //--예정가격범위
			String prepare_max              = bd_data[22]; //--총예비가격수
			String prepare_vote             = bd_data[23]; //--추첨수
			String min_vote_rate            = bd_data[24]; //--투찰율
			String estimated_cost           = bd_data[25]; //--사업예산
			String deduction_cost           = bd_data[26]; //--추정가격
			String prepare_flag             = bd_data[27]; //--예정가격확정여부
			String prepare_confirm_date     = bd_data[28]; //--예정가격확정일자
			String bd_status     			= bd_data[29]; //--입찰상태
			String bd_no     			    = bd_data[30]; //--입찰번호
			String bd_count     			= bd_data[31]; //--입찰차수
			String bd_kind           		= bd_data[32]; //--입찰구분
			String technology_assessment    = bd_data[33]; //--기술평가비율
			String prop_sub_date 			= bd_data[34]; //--제안서 제출일자
			String prop_sub_time			= bd_data[35]; //--제안서 제출시간
			String attach_no1               = bd_data[36]; //--규격서첨부파일
			
			//사양설명회
			String explain_date     = exp_data[0];  //개최일
			String exp_from_time    = exp_data[1];
			String exp_to_time      = exp_data[2];
			String explain_area     = exp_data[3];  //지역
			String explain_place    = exp_data[4];  //장소
			String explain_flag     = exp_data[5];  //참석필수여부
			String explain_resp     = exp_data[6];  //담당자
			String explain_tel      = exp_data[7];  //문의처
			String explain_comment  = exp_data[8];  //특기사항

			sm.removeAllValue();
			sql.delete(0, sql.length());
			sql.append("UPDATE SEBGL SET                 \n");
			sql.append("       PUB_DATE             = ?  \n"); sm.addStringParameter(pub_date);
			sql.append("     , PUB_ITEM             = ?  \n"); sm.addStringParameter(pub_item);
			sql.append("     , BD_CATEGORY          = ?  \n"); sm.addStringParameter(bd_category);
			sql.append("     , BD_TYPE              = ?  \n"); sm.addStringParameter(bd_type);
			sql.append("     , BD_METHODE           = ?  \n"); sm.addStringParameter(bd_methode);
			sql.append("     , JODAL_BD_NO          = ?  \n"); sm.addStringParameter(jodal_bd_no);
			sql.append("     , LIMIT_CRIT           = ?  \n"); sm.addStringParameter(limit_crit);
			sql.append("     , SECURITY_PAYMENT     = ?  \n"); sm.addStringParameter(security_payment);
			sql.append("     , BUDGET_ESTIMATE_FLAG = ?  \n"); sm.addStringParameter(budget_estimate_flag);
			sql.append("     , REQ_BEGIN_DATE       = ?  \n"); sm.addStringParameter(req_begin_date);
			sql.append("     , REQ_BEGIN_TIME       = ?  \n"); sm.addStringParameter(req_begin_time);
			sql.append("     , REQ_END_DATE         = ?  \n"); sm.addStringParameter(req_end_date);
			sql.append("     , REQ_END_TIME         = ?  \n"); sm.addStringParameter(req_end_time);
			sql.append("     , BD_OPEN_DATE         = ?  \n"); sm.addStringParameter(bd_open_date);
			sql.append("     , BD_OPEN_TIME         = ?  \n"); sm.addStringParameter(bd_open_time);
			sql.append("     , BD_ELIGIBILITY       = ?  \n"); sm.addStringParameter(bd_eligibility);
			sql.append("     , REQ_ETC              = ?  \n"); sm.addStringParameter(req_etc);
			sql.append("     , ATTACH_NO            = ?  \n"); sm.addStringParameter(attach_no);
			sql.append("     , ATTACH_NO1           = ?  \n"); sm.addStringParameter(attach_no1);
			sql.append("     , PREPARE_KIND         = ?  \n"); sm.addStringParameter(prepare_kind);
			sql.append("     , PREPARE_RATE         = ?  \n"); sm.addStringParameter(prepare_rate);
			sql.append("     , PREPARE_MAX          = ?  \n"); sm.addStringParameter(prepare_max);
			sql.append("     , PREPARE_VOTE         = ?  \n"); sm.addStringParameter(prepare_vote);
			sql.append("     , MIN_VOTE_RATE        = ?  \n"); sm.addStringParameter(min_vote_rate);
			sql.append("     , ESTIMATED_COST       = ?  \n"); sm.addStringParameter(estimated_cost);
			sql.append("     , DEDUCTION_COST       = ?  \n"); sm.addStringParameter(deduction_cost);
			sql.append("     , PREPARE_FLAG         = ?  \n"); sm.addStringParameter(prepare_flag);
			sql.append("     , PREPARE_CONFIRM_DATE = ?  \n"); sm.addStringParameter(prepare_confirm_date);
			sql.append("     , BD_STATUS            = ?  \n"); sm.addStringParameter(bd_status);
			sql.append("     , CHANGE_DATE          = ?  \n"); sm.addStringParameter(ADD_DATE);
			sql.append("     , CHANGE_TIME          = ?  \n"); sm.addStringParameter(ADD_TIME);
			sql.append("     , CHANGE_USER_ID       = ?  \n"); sm.addStringParameter(change_user_id);
			sql.append("     , CHANGE_USER_NAME_LOC = ?  \n"); sm.addStringParameter(change_user_name);
			sql.append("     , CHANGE_USER_NAME_ENG = ?  \n"); sm.addStringParameter(NAME_ENG);
			sql.append("     , CHANGE_USER_DEPT     = ?  \n"); sm.addStringParameter(DEPT);
			sql.append("     , EXPLAIN_DATE         = ?  \n"); sm.addStringParameter(explain_date);
			sql.append("     , EXPLAIN_TIME_FROM    = ?  \n"); sm.addStringParameter(exp_from_time);
			sql.append("     , EXPLAIN_TIME_TO      = ?  \n"); sm.addStringParameter(exp_to_time);
			sql.append("     , EXPLAIN_AREA         = ?  \n"); sm.addStringParameter(explain_area);
			sql.append("     , EXPLAIN_PLACE        = ?  \n"); sm.addStringParameter(explain_place);
			sql.append("     , EXPLAIN_FLAG         = ?  \n"); sm.addStringParameter(explain_flag);
			sql.append("     , EXPLAIN_RESP         = ?  \n"); sm.addStringParameter(explain_resp);
			sql.append("     , EXPLAIN_TEL          = ?  \n"); sm.addStringParameter(explain_tel);
			sql.append("     , EXPLAIN_COMMENT      = ?  \n"); sm.addStringParameter(explain_comment);
		
			sql.append("     , CTRL_PERSON_ID       = ?  \n"); sm.addStringParameter(change_user_id);
			sql.append("     , CTRL_PERSON_NAME_LOC = ?  \n"); sm.addStringParameter(change_user_name);
			sql.append("     , CTRL_PERSON_NAME_ENG = ?  \n"); sm.addStringParameter(NAME_ENG);
			sql.append("     , CTRL_PERSON_DEPT     = ?  \n"); sm.addStringParameter(DEPT);

			sql.append("     , BD_KIND       			= ?  \n"); sm.addStringParameter(bd_kind);
			sql.append("     , TECHNOLOGY_ASSESSMENT    = ?  \n"); sm.addStringParameter(technology_assessment);
			
			sql.append("     , PROP_SUB_DATE        = ?  \n"); sm.addStringParameter(prop_sub_date);
			sql.append("     , PROP_SUB_TIME		= ?  \n"); sm.addStringParameter(prop_sub_time);
			
			sql.append(" WHERE BD_NO                = ?  \n "); sm.addStringParameter(bd_no);
			sql.append("   AND BD_COUNT             = ?  \n "); sm.addStringParameter(bd_count);
			sql.append("   AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N')  = 'N' \n ");
			
			rtn[0] = String.valueOf(sm.doUpdate(sql.toString()));

		}
		catch (Exception e)
		{
			//rtn[1] = e.getMessage();
			rtn[1] = "수정을 실패하였습니다.";
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} // End of et_setBdHdSave()
	
	//수정 SEBLN
	private String[] et_setBdDtSave(String[][] bean_args, String bd_no, String bd_count, String bd_status, String change_user_id, String change_user_name) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sql = new StringBuffer();
		
		String ADD_DATE = SepoaDate.getShortDateString();
		String ADD_TIME = SepoaDate.getShortTimeString();
		String NAME_ENG = info.getSession("NAME_ENG");
		String DEPT     = info.getSession("DEPARTMENT");
		
		String MATERIAL_NUMBER			= "";
		String MAKER                    = "";
		String YEAR_OF_MANUFACTURE      = "";
		String DESCRIPTION_LOC          = "";
		String SPECIFICATION            = "";
		String UNIT_MEASURE_TEXT        = "";
		String PR_QTY                   = "";
		String UNIT_PRICE               = "";
		String PR_AMT                   = "";
		String PR_NUMBER                = "";
		String PR_SEQ                   = "";
		String RD_DATE                  = "";
		String DELY_TO_LOCATION         = "";
		String SELLER_CODE              = "";
		String SELLER_CODE_CNT          = "";
		String CTRL_PERSON_ID           = "";
		String UNIT_MEASURE             = "";
		String ACCOUNTS_COURSES_CODE    = "";
		String ACCOUNTS_COURSES_LOC     = "";
		String ASSET_NUMBER             = "";
		String DEMAND_DEPT              = "";
		String BD_SEQ					= "";   
		String PR_USER_ID               = "";

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			
			for (int i = 0; i < bean_args.length; i++)
			{
				MATERIAL_NUMBER		    = bean_args[i][0];   
				MAKER                   = bean_args[i][1];   
				YEAR_OF_MANUFACTURE     = bean_args[i][2];   
				DESCRIPTION_LOC         = bean_args[i][3];   
				SPECIFICATION           = bean_args[i][4];   
				UNIT_MEASURE_TEXT       = bean_args[i][5];   
				PR_QTY                  = bean_args[i][6];   
				UNIT_PRICE              = bean_args[i][7];   
				PR_AMT                  = bean_args[i][8];   
				PR_NUMBER               = bean_args[i][9];   
				PR_SEQ                  = bean_args[i][10];  
				RD_DATE                 = bean_args[i][11];  
				DELY_TO_LOCATION        = bean_args[i][12];  
				SELLER_CODE             = bean_args[i][13];  
				SELLER_CODE_CNT         = bean_args[i][14];  
				CTRL_PERSON_ID          = bean_args[i][15];  
				UNIT_MEASURE            = bean_args[i][16];  
				ACCOUNTS_COURSES_CODE   = bean_args[i][17];  
				ACCOUNTS_COURSES_LOC    = bean_args[i][18];  
				ASSET_NUMBER            = bean_args[i][19];  
				DEMAND_DEPT             = bean_args[i][20];  
				PR_USER_ID              = bean_args[i][21];  
				BD_SEQ					= bean_args[i][22];  

				String diliver_place   = "";
				
				
				sm.removeAllValue();
				sql.delete(0, sql.length());
				sql.append("UPDATE SEBLN SET                 \n");
				sql.append("       DESCRIPTION_LOC      = ?  \n"); sm.addStringParameter(DESCRIPTION_LOC);
				sql.append("     , SPECIFICATION        = ?  \n"); sm.addStringParameter(SPECIFICATION);
				sql.append("     , UNIT_MEASURE         = ?  \n"); sm.addStringParameter(UNIT_MEASURE);
				sql.append("     , PR_QTY               = ?  \n"); sm.addStringParameter(PR_QTY);
				sql.append("     , PR_AMT               = ?  \n"); sm.addStringParameter(PR_AMT);
				sql.append("     , PR_NUMBER            = ?  \n"); sm.addStringParameter(PR_NUMBER);
				sql.append("     , PR_SEQ               = ?  \n"); sm.addStringParameter(PR_SEQ);
				sql.append("     , DILIVER_PLACE        = ?  \n"); sm.addStringParameter(DELY_TO_LOCATION);
				sql.append("     , UNIT_PRICE           = ?  \n"); sm.addStringParameter(UNIT_PRICE);
				sql.append("     , CHANGE_DATE          = ?  \n"); sm.addStringParameter(ADD_DATE);
				sql.append("     , CHANGE_TIME          = ?  \n"); sm.addStringParameter(ADD_TIME);
				sql.append("     , CHANGE_USER_ID       = ?  \n"); sm.addStringParameter(change_user_id);
				sql.append("     , CHANGE_USER_NAME_LOC = ?  \n"); sm.addStringParameter(change_user_name);
				sql.append("     , CHANGE_USER_NAME_ENG = ?  \n"); sm.addStringParameter(NAME_ENG);
				sql.append("     , CHANGE_USER_DEPT     = ?  \n"); sm.addStringParameter(DEPT);
				
//				sql.append("     , MAKER     				= ?  \n"); sm.addStringParameter(MAKER);
//				sql.append("     , YEAR_OF_MANUFACTURE     = ?  \n"); sm.addStringParameter(YEAR_OF_MANUFACTURE);
				sql.append("     , ACCOUNTS_COURSES_CODE    = ?  \n"); sm.addStringParameter(ACCOUNTS_COURSES_CODE);
				sql.append("     , ACCOUNTS_COURSES_LOC     = ?  \n"); sm.addStringParameter(ACCOUNTS_COURSES_LOC);
				sql.append("     , ASSET_NUMBER     		= ?  \n"); sm.addStringParameter(ASSET_NUMBER);
//				sql.append("     , MATERIAL_NUMBER     = ?  \n"); sm.addStringParameter(MATERIAL_NUMBER);
				
				sql.append("	 , PR_USER_ID        	 = ?  \n"); sm.addStringParameter(PR_USER_ID);
				sql.append("	 , CTRL_PERSON_ID        = ?  \n"); sm.addStringParameter(CTRL_PERSON_ID);
				sql.append("	 , DEMAND_DEPT        	 = ?  \n"); sm.addStringParameter(DEMAND_DEPT);
				
				
				sql.append(" WHERE BD_NO                = ?  \n "); sm.addStringParameter(bd_no);
				sql.append("   AND BD_COUNT             = ?  \n "); sm.addStringParameter(bd_count);
				sql.append("   AND BD_SEQ               = ?  \n "); sm.addStringParameter(BD_SEQ);
				sql.append("   AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N')  = 'N' \n ");
//				sm.doUpdate(sql.toString());
				
				rtn[0] = String.valueOf(sm.doUpdate(sql.toString()));
			}

		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} // End of et_setBdDtSave()
	
	
//	수정 SEBSE
	private String[] et_setBdSESave(String BD_NO, String BD_COUNT,  String[][] bean_args) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
		
		String ADD_USER_ID = info.getSession("ID");
		String ADD_DATE = SepoaDate.getShortDateString();
		String ADD_TIME = SepoaDate.getShortTimeString();

		String SELLER_CODE = "";
		String BD_SEQ      = "";
		
		try
		{
			 Logger.err.println("SELLER_CODE ==>" + bean_args[0][13]);

				sqlsb.delete(0, sqlsb.length());
				sqlsb.append(" DELETE FROM SEBSE	\n");
				sqlsb.append("  WHERE 1=1 \n");
				sqlsb.append("    AND BD_NO = '" + BD_NO	+ "' \n");
				sqlsb.append("    AND BD_COUNT = '" + BD_COUNT	+ "' \n");
				ps.doDelete(sqlsb.toString());
				
				Logger.err.println("SELLER_CODE ==>" + bean_args[0][13]);
				
				BD_SEQ = bean_args[0][10];
				
				
				String[] vendor_selected_datas = CommonUtil.getTokenData( bean_args[0][13], "#");
	            
				for(int j=0; j < vendor_selected_datas.length; j++) {
					String[] vendor_datas = CommonUtil.getTokenData(vendor_selected_datas[j], "@");
					
					SELLER_CODE = vendor_datas[0].trim();
					
					Logger.err.println("SELLER_CODE ==>" + SELLER_CODE);

				ps.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append(" INSERT INTO SEBSE 				\n");
				sqlsb.append(" 		(                           \n");
				sqlsb.append(" 			SELLER_CODE             \n");
				sqlsb.append(" 			,BD_NO             		\n");
				sqlsb.append(" 			,BD_COUNT               \n");
				sqlsb.append(" 			,BD_SEQ                 \n");
				sqlsb.append(" 			,COMPANY_CODE           \n");
				sqlsb.append(" 			,ADD_DATE               \n");
				sqlsb.append(" 			,ADD_USER_ID            \n");
				sqlsb.append(" 			,ADD_TIME               \n");
				sqlsb.append(" 			,CHANGE_DATE			\n");
				sqlsb.append(" 			,CHANGE_USER_ID         \n");
				sqlsb.append(" 			,CHANGE_TIME            \n");
				sqlsb.append(" 			,DEL_FLAG               \n");
				sqlsb.append("    		)                       \n");
				sqlsb.append(" VALUES                           \n");
				sqlsb.append("     	(                           \n");
				sqlsb.append("             ?          			\n"); ps.addStringParameter(SELLER_CODE);
				sqlsb.append("            ,?          			\n"); ps.addStringParameter(BD_NO);
				sqlsb.append("            ,?          			\n"); ps.addStringParameter(BD_COUNT);
				sqlsb.append("            ,?          			\n"); ps.addStringParameter(BD_SEQ);
				sqlsb.append("            ,?          			\n"); ps.addStringParameter(SELLER_CODE);
				sqlsb.append("            ,?          			\n"); ps.addStringParameter(ADD_DATE);
				sqlsb.append("            ,?          			\n"); ps.addStringParameter(ADD_USER_ID);
				sqlsb.append("            ,?          			\n"); ps.addStringParameter(ADD_TIME);
				sqlsb.append("            ,?          			\n"); ps.addStringParameter(ADD_DATE);
				sqlsb.append("            ,?          			\n"); ps.addStringParameter(ADD_USER_ID);
				sqlsb.append("            ,?          			\n"); ps.addStringParameter(ADD_TIME);
				sqlsb.append(" 			  ,'N'                  \n");
				sqlsb.append("    		)                       \n");

				 ps.doInsert(sqlsb.toString());
			}

		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} // End of et_setBdDtSave()
	
	//확정
    public SepoaOut setBdApproval(String[] bd_data, String[][] bean_args ) throws Exception
	{
		try
		{
			String[] rtn = null;
			String[] rtn1 = null;
			String[] rtn2 = null;
			
			setStatus(1);
			setFlag(true);
			
			String bd_no 		= bd_data[0];
			String bd_count 	= bd_data[1];
			String bd_status  	= bd_data[2];
			
			//SEBGL UPDATE
			rtn = et_setBdApproval(bd_no, bd_count, bd_status);

			if (rtn[1] != null)
			{
				Rollback();
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
			}
			
			String PR_NUMBER = bean_args[0][0];
			String PR_SEQ = bean_args[0][1];
			
			rtn1 = et_setPrLNCreate(bd_status, PR_NUMBER, PR_SEQ);

			if (rtn1[1] != null)
			{
				Rollback();
				setMessage(rtn1[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn1[1]);
				setStatus(0);
				setFlag(false);
				return getSepoaOut();
			}
			
			rtn2 = et_setPrGLCreate(PR_NUMBER, bd_status);

			if (rtn2[1] != null)
			{
				Rollback();
				setMessage(rtn2[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn2[1]);
				setStatus(0);
				setFlag(false);
				return getSepoaOut();
			}
			//setMessage(msg.getMessage("0002"));
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

    //확정 SEBGL
	private String[] et_setBdApproval(String bd_no, String bd_count, String bd_status) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sql = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue();
			sql.append("UPDATE SEBGL SET                 \n");
			sql.append("       BD_STATUS            = ?  \n"); sm.addStringParameter(bd_status);
			sql.append("      ,PUB_DATE             = ?  \n"); sm.addStringParameter(SepoaDate.getShortDateString());
			sql.append(" WHERE BD_NO                = ?  \n "); sm.addStringParameter(bd_no);
			sql.append("   AND BD_COUNT             = ?  \n "); sm.addStringParameter(bd_count);
			sql.append("   AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N')  = 'N' \n ");
			sm.doUpdate(sql.toString());

		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} // End of et_setBdHdSave()
	
	
	//	결재요청
    public SepoaOut setBdBilling(String bd_no, String bd_count, String bd_status) throws Exception
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);
			
			//SEBGL UPDATE
			rtn = et_setBdBilling(bd_no, bd_count, bd_status);

			if (rtn[1] != null)
			{
				Rollback();
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
			}
			
			setValue(rtn[0]);
			
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

    //결제요청 SEBGL
	private String[] et_setBdBilling(String bd_no, String bd_count, String bd_status) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sql = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue();
			sql.append("UPDATE SEBGL SET                 \n");
			sql.append("       BD_STATUS            = ?  \n"); 
			sm.addStringParameter(bd_status);
			sql.append(" WHERE " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N')  = 'N' \n ");
			sql.append("   AND BD_NO                = ?  \n "); 
			sm.addStringParameter(bd_no);
			sql.append("   AND BD_COUNT             = ?  \n "); 
			sm.addStringParameter(bd_count);
			
			sm.doUpdate(sql.toString());

		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} // End of et_setBdHdSave()
	
	private String[] et_setPrLNCreate( String bd_status, String PR_NUMBER,  String PR_SEQ) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
		
		String ADD_USER_ID = info.getSession("ID");
		String ADD_DATE = SepoaDate.getShortDateString();
		String ADD_TIME = SepoaDate.getShortTimeString();
		
		String RFQ_FLAG  = "";
		String PR_PROCEEDING_FLAG = "";
		
		try
		{
			
			if(bd_status.equals("T")){
				PR_PROCEEDING_FLAG = "BR";
			}else{
				PR_PROCEEDING_FLAG = "BP";
			}
			
			ps.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append(" UPDATE SPRLN												\n");
			sqlsb.append("    SET  CHANGE_DATE             = ?				        \n");
			ps.addStringParameter(ADD_DATE);
			sqlsb.append("        ,CHANGE_TIME             = ?				        \n");
			ps.addStringParameter(ADD_TIME);
			sqlsb.append("        ,CHANGE_USER_ID          = ?				        \n");
			ps.addStringParameter(ADD_USER_ID);
			sqlsb.append("        ,PR_PROCEEDING_FLAG      = ?				        \n");
			ps.addStringParameter(PR_PROCEEDING_FLAG);
			sqlsb.append("                                                          \n");
			sqlsb.append("  WHERE PR_NUMBER                = ?				        \n");
			ps.addStringParameter(PR_NUMBER);
			sqlsb.append("    AND PR_SEQ               	   = ?				        \n");
			ps.addStringParameter(PR_SEQ);
			

			rtn[0] = String.valueOf(ps.doUpdate(sqlsb.toString()));

		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} 
	
		
  private String[] et_setPrGLCreate( String PR_NUMBER, String bd_status ) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
		
		String ADD_USER_ID = info.getSession("ID");
		String ADD_DATE = SepoaDate.getShortDateString();
		String ADD_TIME = SepoaDate.getShortTimeString();
		
		String PR_PROCEEDING_FLAG 	="";
		String CTRL_FLAG  			= "";
		
		try
		{
			if(bd_status.equals("T")){
				PR_PROCEEDING_FLAG = "BR";
				CTRL_FLAG = "BR";
			}else{
				PR_PROCEEDING_FLAG = "BP";
				CTRL_FLAG  = "BP";
			}
			
			ps.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append(" SELECT COUNT(PR_NUMBER) FROM  SPRLN		\n");
			sqlsb.append("  WHERE PR_NUMBER	= '"+PR_NUMBER+"'		\n");
			String result = ps.doSelect(sqlsb.toString());
			
			SepoaFormater wf = new SepoaFormater(result);
			
			int cnt = Integer.parseInt(wf.getValue(0,0));
			
			ps.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append(" SELECT COUNT(PR_NUMBER) FROM  SPRLN						\n");
			sqlsb.append("  WHERE PR_PROCEEDING_FLAG	= '"+PR_PROCEEDING_FLAG+"'	\n");
			sqlsb.append("    AND PR_NUMBER	= '"+PR_NUMBER+"'						\n");
			String result1 = ps.doSelect(sqlsb.toString());
			
			SepoaFormater wf1 = new SepoaFormater(result1);
			
			int cnt1 = Integer.parseInt(wf1.getValue(0,0));
			
			if(cnt == cnt1){
				
				ps.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append(" UPDATE SPRGL												\n");
				sqlsb.append("    SET  CHANGE_DATE             = ?				        \n");
				ps.addStringParameter(ADD_DATE);
				sqlsb.append("        ,CHANGE_TIME             = ?				        \n");
				ps.addStringParameter(ADD_TIME);
				sqlsb.append("        ,CHANGE_USER_ID          = ?				        \n");
				ps.addStringParameter(ADD_USER_ID);
				sqlsb.append("        ,CTRL_FLAG          	   = ?				        \n");
				ps.addStringParameter(CTRL_FLAG);
				sqlsb.append("                                                          \n");
				sqlsb.append("  WHERE PR_NUMBER               = ?				        \n");
				ps.addStringParameter(PR_NUMBER);

				rtn[0] = String.valueOf(ps.doUpdate(sqlsb.toString()));
			}
		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} 
}
