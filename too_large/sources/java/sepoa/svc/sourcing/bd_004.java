package sepoa.svc.sourcing;

import java.util.HashMap ;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.*;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.DBUtil ;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.fw.util.DocumentUtil ;

@SuppressWarnings({"unchecked"})
public class BD_004 extends SepoaService {

    //20131129 sendakun
    private HashMap msg = null;


    public BD_004( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
//        msg = new Message( info, "PU_011_BEAN" );
        //20131129 sendakun
        try {
            //20131129 PU_011_BEAN 내용이 두줄밖에 없어서  PR_002로 옮긴다.
            msg = MessageUtil.getMessageMap( info, "BD_004");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.sys.println( "BD_004 : " + e.getMessage() );
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

    /**
     * 구매관리 > 입찰관리 > 입찰공고현황
     * 
     * @param headerData
     * @return
     */
    public SepoaOut getBdSellerStatusList( Map< String, String > headerData ) {

    	 ConnectionContext ctx = getConnectionContext();
         StringBuffer sqlsb = new StringBuffer();

         try {

             setStatus( 1 );
             setFlag( true );

             SepoaXmlParser sxp = new SepoaXmlParser();
             SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
             
             
             
             headerData.put("from_date"		, SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "from_end_date",    "" ) ));//2014-07-14 -> 20140714
             headerData.put("to_date"		, SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "to_end_date",    "" ) ));
             headerData.put("language"		, info.getSession("LANGUAGE"));
             headerData.put("company_code"	, info.getSession("COMPANY_CODE"));
            
             headerData.put("USER_TYPE", info.getSession("USER_TYPE"));
             headerData.put("ID", info.getSession("ID"));
  
             setValue( ssm.doSelect( headerData ) );
             
             

         } catch( Exception e ) {
             setStatus( 0 );
             setFlag( false );
             setMessage( e.getMessage() );
             Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
         }

         return getSepoaOut();

     }
    
    /**
     * 구매관리 > 입찰관리 > 입찰공고현황
     * 
     * @param headerData
     * @return
     */
    public SepoaOut getBdSellerList( Map< String, String > headerData ) {

    	 ConnectionContext ctx = getConnectionContext();
         StringBuffer sqlsb = new StringBuffer();

         try {

             setStatus( 1 );
             setFlag( true );

             SepoaXmlParser sxp = new SepoaXmlParser();
             SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
             
             String CTRL_TYPE_CODE_LIST = String.valueOf(info.getSession ( "CTRL_TYPE_CODE_LIST" ).indexOf ( "P~" ));
             
            
             
             
             headerData.put("from_date"		, SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "from_date",    "" ) ));//2014-07-14 -> 20140714
             headerData.put("to_date"		, SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "to_date",    "" ) ));
            // headerData.put("settle_flag"	, MapUtils.getString( headerData,  "settle_flag",  "" ));
             headerData.put("language"			, info.getSession("LANGUAGE"));
             headerData.put("company_code"		, info.getSession("COMPANY_CODE"));
             
    
//             if ( ! "TRUE".equals( info.getSession("IS_ADMIN_USER") ) && info.getSession ( "CTRL_TYPE_CODE_LIST" ).indexOf ( "P~" ) == -1 && !"S".equals(info.getSession("USER_TYPE"))) {
//                 sqlsb.append("                             AND (                                                                        \n ");
//                 sqlsb.append(sm.addSelectString("                R.ADD_USER_ID  = ?  \n "));sm.addStringParameter ( info.getSession ( "ID" ) );
//                 sqlsb.append(sm.addSelectString("             OR R.PR_USER_ID   = ?  \n "));sm.addStringParameter ( info.getSession ( "ID" ) );
//                 sqlsb.append(sm.addSelectString("             OR R.PURCHASER_ID   = ?  \n "));sm.addStringParameter ( info.getSession ( "ID" ) );
//                 sqlsb.append(sm.addSelectString("             OR R.INSPECTOR_ID = ?  \n "));sm.addStringParameter ( info.getSession ( "ID" ) );
//                 sqlsb.append("                             )                                                                            \n ");
//             }
             
             headerData.put("IS_ADMIN_USER", info.getSession("IS_ADMIN_USER"));
             headerData.put("CTRL_TYPE_CODE_LIST", CTRL_TYPE_CODE_LIST);
             headerData.put("USER_TYPE", info.getSession("USER_TYPE"));
             headerData.put("ID", info.getSession("ID"));
  
             setValue( ssm.doSelect( headerData ) );
             
             

         } catch( Exception e ) {
             setStatus( 0 );
             setFlag( false );
             setMessage( e.getMessage() );
             Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
         }

         return getSepoaOut();

     }    
    
    /**
     * 구매관리 > 입찰관리 > 입찰공고현황 > 입찰서 제출 헤더 조회
     * 
     * @param headerData
     * @return
     */
    public SepoaOut getBdSellerStatusHD( Map< String, String > headerData ) {

    	 ConnectionContext ctx = getConnectionContext();
         StringBuffer sqlsb = new StringBuffer();

         try {

             setStatus( 1 );
             setFlag( true );

             SepoaXmlParser sxp = new SepoaXmlParser();
             SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

             headerData.put("language"		, info.getSession("LANGUAGE"));
             headerData.put("seller_code"	, info.getSession("COMPANY_CODE"));
            
             headerData.put("USER_TYPE", info.getSession("USER_TYPE"));
             headerData.put("ID", info.getSession("ID"));
  
             setValue( ssm.doSelect( headerData ) );
         
         } catch( Exception e ) {
             setStatus( 0 );
             setFlag( false );
             setMessage( e.getMessage() );
             Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
         }

         return getSepoaOut();

     }

    /**
     * 구매관리 > 입찰관리 > 입찰공고현황 > 입찰서 제출 라인 조회
     * 
     * @param headerData
     * @return
     */
    public SepoaOut getBdSellerStatusDT( Map< String, String > headerData ) {

    	 ConnectionContext ctx = getConnectionContext();
         StringBuffer sqlsb = new StringBuffer();

         SepoaXmlParser sxp = null;
         SepoaSQLManager ssm = null;

         String[] rtn1 = null; 
         try {

             setStatus( 1 );
             setFlag( true );

             headerData.put("language"		, info.getSession("LANGUAGE"));
             headerData.put("seller_code"	, info.getSession("COMPANY_CODE"));
            
             headerData.put("USER_TYPE", info.getSession("USER_TYPE"));
             headerData.put("ID", info.getSession("ID"));
             /*
 			 *   입찰서 유무 파악 
 			 */
 			rtn1 = getBdStatutsCount(headerData);
 			
 			if (rtn1[1] != null)
 			{
 				Rollback();
 				setMessage(rtn1[1]);
 				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn1[1]);
 				setStatus(0);
 				setFlag(false);
 				return getSepoaOut();
 			}
 			
 			if (Integer.parseInt(rtn1[0]) > 0) {  
 	             sxp = new SepoaXmlParser(this, "getBdStatusSelectVO");
 	             ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 				
 			}else{
 				sxp = new SepoaXmlParser(this, "getBdSellerStatusDT");
 				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 			}
             setValue( ssm.doSelect( headerData ) );
         
         } catch( Exception e ) {
             setStatus( 0 );
             setFlag( false );
             setMessage( e.getMessage() );
             Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
         }

         return getSepoaOut();

     }
    
    

	/**
	 * 업체에서 입찴서제출
	 * 
	 * @param allData  request 전체 데이터
	 * @return SepoaOut
	 * @throws Exception
	 */
    public SepoaOut setBDSubmit( Map< String, Object > allData ) throws Exception {

        SepoaOut    so  = null;

        Map< String, String >           headerData  = null;
        List< Map< String, String > >   gridData    = null;

        String bd_no		= "";
        String vote_no		= "";
        String bd_count		= ""; 
        
        int rtn0    = 0;
        int rtn1    = 0;
        int rtn2    = 0;
        int rtn3    = 0;
        String[] rtn4 = null; 
        String[] rtn5 = null; 

        try {

            setFlag( true );
            setStatus( 1 );

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );

            headerData.put( "seller_code"	, info.getSession("COMPANY_CODE") );
			/*
			 * 입찰신청마감시간 체크
			 */
			rtn4 = getBdStatutsTime(allData);
			 
			if (rtn4[1] != null)
			{
				Rollback();
				setMessage(rtn4[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn4[1]);
	            setValue("");
				setStatus(0);
				setFlag(false);
				return getSepoaOut();
			}
			/*
			 *   입찰서 유무 파악 
			 */
			rtn5 = getBdStatutsCount(headerData);
			
			if (rtn5[1] != null)
			{
				Rollback();
				setMessage(rtn5[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn5[1]);
	            setValue("");
				setStatus(0);
				setFlag(false);
				return getSepoaOut();
			}
			 
			
            // bd_no가 없으면 채번, 채번 후 bd_count값 1 셋팅
            vote_no  = MapUtils.getString( headerData, "vote_no", "" );
             
            /* 투찰번호 없는 경우 채번 */
            if( "".equals( vote_no ) || bd_no == null || vote_no.length() < 1 ) {
            	so = DocumentUtil.getDocNumber( info, "VT" );
            	headerData.put( "vote_no", so.result[0] );
            	vote_no = so.result[0];
            }
            	
            headerData.put( "vote_count"	, "1" );
 
            /***************************************************************
             * 0. 업체평가
             **************************************************************/
            rtn0 = et_setBDSP( allData );
            if( rtn0 < 1 ) {
                Rollback();
                setMessage( msg.get( "BD_004.0000" ).toString() );
	            setValue("");
                setStatus( 0 );
                setFlag( false );
                return getSepoaOut();
            }

            /***************************************************************
             * 1. 투찰헤더 
             **************************************************************/
          
            rtn1 = et_setBDVO( allData );
            if( rtn1 < 1 ) {
                Rollback();
                //입력중 오류가 발생했습니다.
                setMessage( msg.get( "BD_004.0000" ).toString() );
	            setValue("");
                setStatus( 0 );
                setFlag( false );
                return getSepoaOut();
            }
   			
            /***************************************************************
             * 2. 투찰 상세정보 생성
             **************************************************************/
            rtn2 = et_setBDVL( allData );
            if( rtn2 < 1 ) {
                Rollback();
                //입력중 오류가 발생했습니다.
                setMessage( msg.get( "BD_004.0000" ).toString());
	            setValue("");
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
                setMessage( msg.get( "BD_004.0000" ).toString());
                setStatus( 0 );
                setFlag( false );
                return getSepoaOut();
            }
			*/
            /***************************************************************
             * 제안설명회 정보 (SRQAN) 생성
             **************************************************************/
            /*제안설명회 가 있는 경우 등록
            if( sepoa.fw.util.CommonUtil.Flag.Yes.getValue().equals(explan_flag) ){
            	
                rtn5 = et_setRfqANCreate( allData );
	            if( rtn5 < 1 ) {
	                Rollback();
	                //입력중 오류가 발생했습니다.
	                setMessage( msg.get( "BD_004.0000" ).toString());
	                setStatus( 0 );
	                setFlag( false );
	                return getSepoaOut();
	            }
            }
	        */
            /***************************************************************
             * 5. 원가 정보 (SRQEP) 생성
             **************************************************************/
            //et_setRfqEPCreate( allData );

            /*************************************************************************** 
             * 6. RFQ 생성후 결재요청
             **************************************************************************
            headerData.put( "sign_status",      sepoa.svc.common.constants.SignStatus.TempSave.getValue() );
            headerData.put( "sign_person_id",   MapUtils.getString( headerData, "add_user_id" ) );
            headerData.put( "rfq_count",        "1" );
            // 전송(P) 일 경우.
            if( sepoa.svc.common.constants.RFQFlag.Estimating.getValue().equals( MapUtils.getString( headerData, "rfq_flag" ) ) ) {
                signup = temp_Approval( headerData );
            } else {
                signup = temp_Approval( headerData );
            }
            */

            /*************************************************************************** 
             * 7. RFQ 생성후 icoyprdt.sourcing_type 업데이트 
             **************************************************************************/
            //signup = et_prdtSourcingTypeUpd( allData );
            
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
            	setMessage( msg.get( "BD_004.0001" ).toString() + " (email 처리중 오류가 발생하였습니다.)");
            }else{
            	
            	setStatus( 1 );
            	setMessage( msg.get( "BD_004.0001" ).toString());
            }
            */	
            
            setFlag( true );
            
            setValue(vote_no);
            
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
            setMessage( e.getMessage() );
        }

        return getSepoaOut();

    }
    /*
	 * 입찰신청마감시간 체크
	 */
	public String[] getBdStatutsTime( Map< String, Object > allData )  throws Exception {
 
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();
        ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );

        Map< String, String >           headerData  = null;

		String[] rtn = new String[2];
        
		SepoaFormater wf = null;
		String result = "";
		
		try {
			setStatus(1);
			setFlag(true);

            headerData  = MapUtils.getMap( allData, "headerData" );
  
			SepoaXmlParser sxp = new SepoaXmlParser(this, "getBdStatutsTime");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			
			result = ssm.doSelect(headerData);
			SepoaFormater sf = new SepoaFormater(result);
			 
			if( sf.getRowCount() > 0 ){
			
				String cnt = sf.getValue("CNT",0);
				
				
				if( cnt.equals("1")){
					rtn[0] = "1";
					rtn[1] = "입찰신청마감시간이 종료되었습니다.";
					return rtn;
				}
			}

			
		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return rtn;
		
	}
	/*
	 *   입찰서 유무 파악 
	 */
	public String[] getBdStatutsCount( Map< String, String > headerData )  throws Exception {
 
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();
        ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );
 
		String[] rtn = new String[2];
        
		SepoaFormater wf = null;
		String result = "";
		
		try {
			setStatus(1);
			setFlag(true);

			SepoaXmlParser sxp = new SepoaXmlParser(this, "getBdStatutsCount");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			  
			result = ssm.doSelect(headerData);
			wf = new SepoaFormater(result);
			rtn[0] = wf.getValue(0, 0);
			
		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return rtn;
		
	}

    /**
     * 입찰요청 해더정보(SEBSP) 생성
     * 
     * @param allData
     * @return
     * @throws Exception
     */
    private int et_setBDSP( Map< String, Object > allData ) throws Exception {

        int     rtn = 0;

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();
        ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );

        Map< String, String >           headerData  = null;

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try { 
        	
            headerData  = MapUtils.getMap( allData, "headerData" );

            headerData.put("house_code"		, info.getSession("HOUSE_CODE"));
            headerData.put("company_code"	, info.getSession("COMPANY_CODE"));
            headerData.put("bd_status"		, "T");//입찰상태

			sxp = new SepoaXmlParser(this, "et_setBDSP_delete");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn = ssm.doDelete(headerData); 
			
			sxp = new SepoaXmlParser(this, "et_setBDSP");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			 
			rtn = ssm.doInsert(headerData); 
			  
        } catch( Exception e ) {
            
            Logger.debug.println( info.getSession( "ID" ), this, e.getMessage() );
        } finally {
        }

        return rtn;

    }    
    

    /**
     * 입찰요청 해더정보(SEBSP) 생성
     * 
     * @param allData
     * @return
     * @throws Exception
     */
    private int et_setBDVO( Map< String, Object > allData ) throws Exception {

        int     rtn = 0;

        ConnectionContext ctx = getConnectionContext(); 

        Map< String, String >           headerData  = null;

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try { 
        	
            headerData  = MapUtils.getMap( allData, "headerData" );

            headerData.put("house_code"				, info.getSession("HOUSE_CODE"));
            headerData.put("company_code"		, info.getSession("COMPANY_CODE"));
            headerData.put("bd_amt"   			, SepoaString.replace( MapUtils.getString( headerData, "bd_amt", "" ) , "," , "" ));

			sxp = new SepoaXmlParser(this, "et_setBDVO_delete");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			rtn = ssm.doDelete(headerData); 
			
			sxp = new SepoaXmlParser(this, "et_setBDVO");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			rtn = ssm.doInsert(headerData); 
			
			
			
        } catch( Exception e ) {
            
            Logger.debug.println( info.getSession( "ID" ), this, e.getMessage() );
        } finally {
        }

        return rtn;

    }    

    /**
     * 입찰요청 해더정보(SEBSP) 생성
     * 
     * @param allData
     * @return
     * @throws Exception
     */
    private int et_setBDVL( Map< String, Object > allData ) throws Exception {

        int     rtn = 0;

        ConnectionContext ctx = getConnectionContext(); 

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
 
        int         intGridRowData  = 0;

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try { 
        	
            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );
  
			sxp = new SepoaXmlParser(this, "et_setBDVL_delete");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			rtn = ssm.doDelete(headerData); 

            if( gridData != null && gridData.size() > 0 ) {

                intGridRowData  = gridData.size();

                for( int i = 0; i < intGridRowData; i++ ) {

                    gridRowData = gridData.get( i );

                    /**
                     * SRQLN의 RFQ_STATUS / D : 자재별 유찰 / 재견적일경우(이전 차수), Y : 자재별 업체 선정, N : 견적요청임시저장 / 견적요청 전송 / 재견적
                     * SRQLN의 SETTLE_FLAG / N : 임시저장 / 전송 / 재견적 / 업체선정 취소, Y : 자재별 업체 선정, D : 자재별 유찰 / 재견적일경우(이전 차수)
                     */ 
                    gridRowData.put( "seller_code",     info.getSession("COMPANY_CODE"));
                    gridRowData.put( "vote_no",      	MapUtils.getString( headerData, "vote_no",     "" ) ); 
                    gridRowData.put( "bd_no",      		MapUtils.getString( headerData, "bd_no",     "" ) );
                    gridRowData.put( "bd_count",       	MapUtils.getString( headerData, "bd_count",     "" ) ); 
 
                }
    			sxp = new SepoaXmlParser(this, "et_setBDVL");
    			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    			rtn = ssm.doInsert(gridData); 
            }
			 
			
        } catch( Exception e ) {
            
            Logger.debug.println( info.getSession( "ID" ), this, e.getMessage() );
        } finally {
        }

        return rtn;

    } 
}
