package ict.sepoa.svc.sourcing;

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
import sepoa.fw.util.JSPUtil ; 

@SuppressWarnings({"unchecked"})
public class I_PU_112 extends SepoaService {

    private HashMap msg = null;


    public I_PU_112( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
 
        try {
            //20131129 PU_011_BEAN 내용이 두줄밖에 없어서  PR_002로 옮긴다.
            msg = MessageUtil.getMessageMap( info, "PU_113");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.err.println("I_PU_112: = " + e.getMessage());
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

    public static String getCtrlCode(String is_admin_user, String own_ctrl_code, String ctrl_code)
    {
    	
        	
	    if( is_admin_user.equals("true") && ctrl_code.length() == 0 )//관리자이고 조회조건이 없는 경우
		{
			ctrl_code = "";
		}
		else if( ctrl_code.length() != 0 )//조회조건이 있는 경우
		{
			ctrl_code=ctrl_code;
		}
		else if( is_admin_user.equals("false") && ctrl_code.length() == 0 ){//일반사용자이고 조회조건이 없는 경우 - 본인의 구매그룹 권한만 조회된다.
			ctrl_code= own_ctrl_code;
		}
	    return ctrl_code;
    }
    
    public SepoaOut getRfqList( Map< String, String > header ) {

		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		 
		String language = info.getSession("LANGUAGE");
		 
        String current_date = SepoaDate.getShortDateString()+SepoaDate.getShortTimeString();

        Map map = new HashMap();
        String rtn = null;
		
		try {
				SepoaXmlParser sxp = new SepoaXmlParser();
				SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			 
				String from_rfq_date 	= SepoaString.getDateUnSlashFormat( MapUtils.getString( header,  "from_rfq_date",        "" ) );
				String to_rfq_date 		= SepoaString.getDateUnSlashFormat( MapUtils.getString( header,  "to_rfq_date",          "" ) );
				String rfq_number_s 	= MapUtils.getString( header,   "rfq_number_s", "" );
				String purchaser_id 	= MapUtils.getString( header,   "purchaser_id",  "" );   
				//String req_type 		= MapUtils.getString( header,  	"req_type",  "" );   
				String rfq_status 		= MapUtils.getString( header,  	"rfq_status",  "" );   
 
				map.put("CURRENT_DATE"		, current_date);
				map.put("LANGUAGE"		    , language); 
				map.put("FROM_RFQ_DATE"		, from_rfq_date );
				map.put("TO_RFQ_DATE"		, to_rfq_date);   
				map.put("RFQ_NUMBER_S"		, rfq_number_s);                                                                        
				map.put("PURCHASER_ID"		, purchaser_id );                                                                    
				map.put("RFQ_STATUS"		, rfq_status );  
				 
				rtn = ssm.doSelect(map); 
				setValue(rtn);
			 
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	/**
	 * 견적요청현황에서 그리드의 데이터 삭제 프로세스
	 * 
	 * @param gridData
	 * @return
	 * @throws Exception
	 */
	public SepoaOut setRfqDelete( List< Map< String, String > > gridData ) throws Exception {

        ConnectionContext ctx = getConnectionContext();

        String  RFQ_NUMBER  = "";
        String  RFQ_COUNT   = "";

        int     intPRGL     = 0;
        int     intPRLN     = 0;
        int     intRQLN     = 0;
        int     intRQSE     = 0;

        Map< String, String >   gridRowData = null;

        try {

            setFlag(true);

            for( int i = 0; i < gridData.size(); i++ ) {

                gridRowData = gridData.get( i );

                RFQ_NUMBER  = MapUtils.getString( gridRowData, "RFQ_NUMBER", "" );
                RFQ_COUNT   = MapUtils.getString( gridRowData, "RFQ_COUNT",  "" );

                /***************************************************************
                 * 1. 구매의뢰 헤더 정보 (SPRGL) 수정
                 **************************************************************/
                intPRGL = et_setPrGLUpdate( ctx, RFQ_NUMBER, RFQ_COUNT );

                /***************************************************************
                 * 2. 견적의뢰 해더 정보 (SRQGL) 삭제
                 **************************************************************/
                intPRLN = et_setRfqHDDelete( ctx, RFQ_NUMBER, RFQ_COUNT );

                /***************************************************************
                 * 3. 견적의뢰 상세 정보 (SRQLN) 삭제
                 **************************************************************/
                intRQLN = et_setRfqDTDelete( ctx, RFQ_NUMBER, RFQ_COUNT );

                /***************************************************************
                 * 4. 견적요청 업체정보  (SRQSE) 삭제
                 **************************************************************/
                intRQSE = et_setRfqSEDelete( ctx, RFQ_NUMBER, RFQ_COUNT );

            }

            setStatus( 1 ); 
            
            //견적요청이 마감되었습니다.
            setMessage( msg.get( "PU_113.0001" ).toString() );
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
	 *  구매의뢰 헤더 정보 (SPRGL) 수정
	 */
	private int et_setPrGLUpdate( ConnectionContext ctx, String rfq_number, String rfq_count ) {

		int rtn = 0;
		String result = "";
		String PR_NUMBER = "";
		String PR_SEQ = "";
 
		SepoaFormater wf = null; 
		
		Map map = new HashMap();
		
		try {
			

    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setPrGLUpdateList");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

			map.put("RFQ_NUMBER"	, rfq_number);
			map.put("RFQ_COUNT"		, rfq_count);
			
			wf = new SepoaFormater(ssm.doSelect(map)); 
			
			if ( wf.getRowCount() > 0 ) 
			{
				for(int k=0;k<wf.getRowCount() ; k ++)
				{
					PR_NUMBER =  wf.getValue("PR_NUMBER", k);
					PR_SEQ    =  wf.getValue("PR_SEQ", k);
					
					map = new HashMap();
					map.put("PR_NUMBER"		, PR_NUMBER);
					map.put("PR_SEQ"		, PR_SEQ);

				}
	    		sxp = new SepoaXmlParser(this, "et_setPrGLUpdate");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
				rtn = ssm.doUpdate(map);
			}

		} catch (Exception e) {
			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}

			
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			
		}
		
		return rtn;
	}

	/*
	 * 견적의뢰 해더 정보 (SRQGL) 삭제
	 */
	private int et_setRfqHDDelete( ConnectionContext ctx, String rfq_number, String rfq_count ) {

		int rtn = 0;
  
		Map map = new HashMap();
		
		try {

    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setRfqHDDelete");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

			map.put("RFQ_NUMBER"	, rfq_number);
			map.put("RFQ_COUNT"		, rfq_count);
			rtn = ssm.doDelete(map);

		} catch (Exception e) {
			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}

			
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			
		}

		return rtn;
	}

	/*
	 * 견전의뢰 상세 정보 (SRQLN) 삭제
	 */
	private int et_setRfqDTDelete( ConnectionContext ctx, String rfq_number, String rfq_count ) {

		int rtn = 0; 
		
		Map map = new HashMap();
		
		try {

    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setRfqDTDelete");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

			map.put("RFQ_NUMBER"	, rfq_number);
			map.put("RFQ_COUNT"		, rfq_count);
			rtn = ssm.doDelete(map);

		} catch (Exception e) {
			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}

			
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			
		}

		return rtn;
	}

	private int et_setRfqSEDelete( ConnectionContext ctx, String rfq_number, String rfq_count ) {

		int rtn = 0;
  
		Map map = new HashMap();
		
		try {

    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setRfqSEDelete");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

			map.put("RFQ_NUMBER"	, rfq_number);
			map.put("RFQ_COUNT"		, rfq_count);
			rtn = ssm.doDelete(map);


		} catch (Exception e) {
			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}

			
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			
		}

		return rtn;
	}		

	/**
	 * 견적요청현황에서 견적마감 프로세스
	 * 
	 * @param allData
	 * @return
	 * @throws Exception
	 */
	public SepoaOut setRFQClose( Map< String, Object > allData ) throws Exception {

	    ConnectionContext ctx = getConnectionContext();

	    StringBuffer sqlsb = new StringBuffer();
	    ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);

	    List< Map<String, String> >    gridData    = null;
	    Map< String, String >          headerData  = null;
	    Map< String, String >          gridRowData = null;
		Map map = new HashMap();
		

	    String RFQ_CLOSE_DATE  = "";
	    String RFQ_CLOSE_TIME  = "";
	    String RFQ_NUMBER      = "";
	    String RFQ_COUNT       = "";

        try {

            setFlag( true );

            headerData  = MapUtils.getMap( allData, "headerData", null );
            gridData    = (List< Map<String,String> >)MapUtils.getObject( allData, "gridData", null );

            SepoaXmlParser sxp = new SepoaXmlParser();
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			
            if( gridData != null ) {

    			ssm.doUpdate(gridData);	 
            }

            setStatus( 1 ); 
            
            //입력중 오류가 발생했습니다.
            setMessage( msg.get("PU_113.0000").toString() );

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

	public SepoaOut getRfqLNDisplay(String[]PR_NUMBER, String[]PR_SEQ , String RP_NUMBER) {

		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		String language = info.getSession("LANGUAGE");
		String ctrl_code = info.getSession("CTRL_CODE");
		String RE_PR_SEQ = "";
        String rtn = null;

		Map map = new HashMap();
		 
		try {

			SepoaXmlParser sxp = new SepoaXmlParser();
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
		   
			for(int i = 0; i<PR_SEQ.length; i++){
				
				if( i == 0 ){
				
					RE_PR_SEQ = PR_SEQ[i].trim() ;
				}
				else
				{
					RE_PR_SEQ += ","+PR_SEQ[i].trim();
						
				} 
				
			}	
			map.put("PR_NUMBER"		, PR_NUMBER[0]);
			map.put("PR_SEQ"		, RE_PR_SEQ);   

			rtn = ssm.doSelect(map);
		 
			setValue(rtn);
			 
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();
	}

    /* ICT 사용*/
	public SepoaOut getBottomSupiList(String seller_code, String rfq_no, String rfq_count, String sel_flag) {

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sqlsb = new StringBuffer();
        String[] seller_codes = seller_code.split ( "@" );
         
        Map<String, String> map = new HashMap<String, String>();
        
        String re_seller_code = "";
 
        try { 
        	
            setStatus(1);
            setFlag(true);

            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			map.put("RFQ_NUMBER"	, rfq_no);        
			map.put("RFQ_COUNT"		, rfq_count);  
 

			for(int i = 0; i<seller_codes.length; i++){
				
				if( i == 0 ){
				
					re_seller_code = seller_codes[i].trim();
				}
				else
				{
					re_seller_code += ","+seller_codes[i].trim();
						
				} 
				
			}	
            Logger.err.println(info.getSession("ID"), this, "===re_seller_code===="+re_seller_code);      
            
            if(re_seller_code.length() == 0) {
            	re_seller_code = "N"; 
            } 
 
			map.put("SELLER_CODE", re_seller_code);
        	SepoaXmlParser sxp = new SepoaXmlParser();                                                                
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            setValue(ssm.doSelect(map));


        } catch (Exception e) {
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
    }

	public SepoaOut getBottomSupiList2(String seller_code, String rfq_no, String rfq_count, String sel_flag) {

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sqlsb = new StringBuffer();
        String[] seller_codes = seller_code.split ( "@" );
         
        Map<String, String> map = new HashMap<String, String>();
        
        String re_seller_code = "";
 
        try { 
        	
            setStatus(1);
            setFlag(true);

            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			map.put("RFQ_NUMBER"	, rfq_no);        
			map.put("RFQ_COUNT"		, rfq_count);  
 

			for(int i = 0; i<seller_codes.length; i++){
				
				if( i == 0 ){
				
					re_seller_code = seller_codes[i].trim();
				}
				else
				{
					re_seller_code += ","+seller_codes[i].trim();
						
				} 
				
			}	
            Logger.err.println(info.getSession("ID"), this, "===re_seller_code===="+re_seller_code);      
            
            if(re_seller_code.length() == 0) {
            	re_seller_code = "N"; 
            } 
 
			map.put("SELLER_CODE", re_seller_code);
			 
        	SepoaXmlParser sxp = new SepoaXmlParser();                                                                
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            setValue(ssm.doSelect(map));
		 

        } catch (Exception e) {
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
    }

    /* ICT 사용*/
	public SepoaOut getRfqVedorList ( HashMap < String , String > hashMap ) {
    
        ConnectionContext ctx = getConnectionContext ( ) ; 
        
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null; 
		
        try {
            setStatus ( 1 ) ;
            setFlag ( true ) ;
             
            // seller_code
            // name_loc
            // type     : 의미없음
            // sg_code1 : 의미없음
            // sg_code2 : 의미없음
            // sg_code3 : 의미없음
            // sg_code4 : 의미없음
            // sg_code5 : 의미없음
            hashMap.put("company_code", info.getSession("COMPANY_CODE"));
            hashMap.put("house_code", info.getSession("HOUSE_CODE"));
            
			sxp = new SepoaXmlParser(this, "getRfqVedorList_selectSSUGL");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

			setValue(ssm.doSelect(hashMap)); 
        } catch ( Exception e ) {
            setStatus ( 0 ) ;
            setFlag ( false ) ;
            setMessage ( e.getMessage ( ) ) ;
            Logger.err.println ( info.getSession ( "ID" ) , this , e.getMessage ( ) ) ;
        }
        
        return getSepoaOut ( ) ;
    }

	/**
	 * 구매의뢰접수에서 견적생성
	 * 
	 * @param allData  request 전체 데이터
	 * @return SepoaOut
	 * @throws Exception
	 */
    public SepoaOut setRfqCreate( Map< String, Object > allData ) throws Exception {

        SepoaOut    so  = null;

        Map< String, String >           headerData  = null;
        List< Map< String, String > >   gridData    = null;

        String rfq_number  = "";
        String rfq_count   = "";
        String explan_flag = "";
        String mail_type   = "";
        
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

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );

            // rfq_number가 없으면 채번, 채번 후 rfq_count값 1 셋팅
            
            rfq_number  = MapUtils.getString( headerData, "rfq_number", "" );
            if( rfq_number == null || "".equals( rfq_number ) || rfq_number.length() < 1 ) {
            	if("P".equals(MapUtils.getString( headerData, "req_type", "P" )) ){
            	    mail_type = "RQ";
            		so        = DocumentUtil.getDocNumber( info , mail_type );
            		
            	}else if ("C".equals(MapUtils.getString( headerData, "req_type", "" ))){
            	    mail_type = "RQ";
            		so        = DocumentUtil.getDocNumber( info, mail_type );
            		
            	}else {
            	    mail_type = "BRQ";
            		so        = DocumentUtil.getDocNumber( info, mail_type );
            		
            	}
            	
                headerData.put( "rfq_number", so.result[0] );
                rfq_number = so.result[0];
                
            }

            rfq_count   = MapUtils.getString( headerData, "rfq_count", "" );
            
            //제안설명회 등록여부
            if( MapUtils.getString( headerData,    "pro_szdate",       "" ).length() > 0 )
            	explan_flag = "Y";
            
            
            
            if( "".equals( rfq_count ) || rfq_number != null ) {
                headerData.put( "rfq_count", "1" );
            }

            /***************************************************************
             * 0. 구매의뢰 해더 정보(SPRGL) 상태값 변경
             **************************************************************/
//            rtn0 = et_setPRGLUpdate( allData );
//            if( rtn0 < 1 ) {
//                Rollback();
//                setMessage( msg.get( "PU_113.0000" ).toString() );
//                setStatus( 0 );
//                setFlag( false );
//                return getSepoaOut();
//            }

            /***************************************************************
             * 1. 구매의뢰 상세 정보(SPRLN) 상태값 변경
             **************************************************************/
            rtn1 = et_setPRLNUpdate( allData );
            if( rtn1 < 1 ) {
                Rollback();
                //입력중 오류가 발생했습니다.
                setMessage( msg.get( "PU_113.0000" ).toString() );
                setStatus( 0 );
                setFlag( false );
                return getSepoaOut();
            }

            // !!!!!화면 프로세스상 추후 임시저장(N)인지 전송(P)인지 상태값 변경에 따라 값이 틀려지도록 수정해야 함
            /***************************************************************
             * 2. 견적의뢰 해더 정보 (SRQGL) 생성
             **************************************************************/
            rtn2 = et_setRfqHDCreate( allData );
            if( rtn2 < 1 ) {
                Rollback();
                //입력중 오류가 발생했습니다.
                setMessage( msg.get( "PU_113.0000" ).toString());
                setStatus( 0 );
                setFlag( false );
                return getSepoaOut();
            }

            /***************************************************************
             * 3. 견적의뢰 상세 정보 (SRQLN) 생성
             **************************************************************/
            rtn3 = et_setRfqDTCreate( allData );
            if( rtn3 < 1 ) {
                Rollback();
                //입력중 오류가 발생했습니다.
                setMessage( msg.get( "PU_113.0000" ).toString());
                setStatus( 0 );
                setFlag( false );
                return getSepoaOut();
            }

            /***************************************************************
             * 4. 견적의뢰 대상업체 정보 (SRQSE) 생성
             **************************************************************/
            rtn4 = et_setRfqSECreate( allData );
            if( rtn4 < 1 ) {
                Rollback();
                //입력중 오류가 발생했습니다.
                setMessage( msg.get( "PU_113.0000" ).toString());
                setStatus( 0 );
                setFlag( false );
                return getSepoaOut();
            }

            /***************************************************************
             * 제안설명회 정보 (SRQAN) 생성
             **************************************************************/
            //제안설명회 가 있는 경우 등록
            if( "Y".equals(explan_flag) ){
            	
                rtn5 = et_setRfqANCreate( allData );
	            if( rtn5 < 1 ) {
	                Rollback();
	                //입력중 오류가 발생했습니다.
	                setMessage( msg.get( "PU_113.0000" ).toString());
	                setStatus( 0 );
	                setFlag( false );
	                return getSepoaOut();
	            }
            }
	        
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

			String rfq_flag  = MapUtils.getString( headerData, "rfq_status", "" );
			String subject 	 = MapUtils.getString( headerData, "subject"   , "" );
	        String rp_type   = "";
	        
	        Commit();
	        
			if("P".equals(rfq_flag))
			{
  /*
				PU_112_Mail mail = new PU_112_Mail( info , this ); 
                    String result = mail.sendMailToSellerDongA( rfq_number , subject , mail_type , rp_type , headerData );
                    if(result.contains("E")){
                    	setStatus(3);
                    }
                
				sendToSeller(headerData);
*/				
			}			
            
            if(getStatus() == 3){
            	setMessage( msg.get( "PU_113.0001" ).toString() + " (email 처리중 오류가 발생하였습니다.)");
            }else{
            	//견적요청이 마감되었습니다.
            	setStatus( 1 );
            	setMessage( msg.get( "PU_113.0001" ).toString());
            }
            
            setFlag( true );
            setValue(rfq_number);

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

    /**
     * 구매관리 > 구매의뢰접수 > 구매의뢰 접수
     * 견적 생성시 SPRLN 상태값(C) 변경
     * 
     * @param allData
     * @return
     * @throws Exception
     */
    private int et_setPRLNUpdate( Map< String, Object > allData ) throws Exception {

        int     rtn = 0;

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();
        ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );

        int intGridRowData  = 0; // 그리드 데이터 갯수

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
        
        Map map = new HashMap();
        
        try {
        	
        	SepoaXmlParser sxp = new SepoaXmlParser();
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );

            headerData.put( "company_code", info.getSession( "COMPANY_CODE" ) );

            if( gridData != null && gridData.size() > 0 ) {
 
          		rtn = ssm.doUpdate(gridData);  

            }

        } catch( Exception e ) {
            
            Logger.debug.println( info.getSession( "ID" ), this, e.getMessage() );
        } finally {
        }

        return rtn;

    }

    /**
     * 견적요청 해더정보(SRQGL) 생성
     * 
     * @param allData
     * @return
     * @throws Exception
     */
    private int et_setRfqHDCreate( Map< String, Object > allData ) throws Exception {

        int     rtn = 0;

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();
        ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );

        Map< String, String >           headerData  = null;

        Map map = new HashMap();
        
        try { 
        	
            headerData  = MapUtils.getMap( allData, "headerData" );

            String test = MapUtils.getString( headerData, "t_company_code", "" );
            String test2=MapUtils.getString( headerData, "T_COMPANY_CODE", "" );

    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setRfqHDCreate_deleteHD");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			
			map.put("RFQ_NUMBER"	, MapUtils.getString( headerData, "rfq_number", "" ));
			map.put("RFQ_COUNT"		, MapUtils.getString( headerData, "rfq_count", "" ));
 
			ssm.doDelete(map);

            Logger.debug.println( info.getSession( "ID" ), this, "==="+MapUtils.getString( headerData, "req_type", "P" ) );
            Logger.debug.println( info.getSession( "ID" ), this, "==="+MapUtils.getString( headerData, "manual_type", "S" ));
            // 사전견적이고 견적요청타입이 메뉴얼일때 견적마감일자를 현재시간으로 셋팅. 시스템 견적과정을 거치지 않게 한다. 업체/단가 메뉴얼 입력 
            if( "B".equals(MapUtils.getString( headerData, "req_type", "P" )) && "M".equals(MapUtils.getString( headerData, "manual_type", "S" ))){
            	headerData.put( "close_time",   SepoaDate.getShortTimeString());
                headerData.put( "close_date",   SepoaDate.getShortDateString());
                headerData.put( "rfq_status",   "C"); // 
        	}else{
            	headerData.put( "close_time",   MapUtils.getString( headerData, "rfq_close_time",  "" ));
                headerData.put( "close_date",   SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,    "rfq_close_date",   "000000" ) ) );
                headerData.put( "rfq_status",   MapUtils.getString( headerData, "rfq_flag"   	,  "" )); // 임시저장 : T, 전송일경우 : P
        	}
            
            	
            // 구매담당자 정보
            headerData.put( "purchase_user_id"	    , info.getSession("ID") );	
            headerData.put( "purchase_user_name"	, info.getSession("NAME_LOC") );	
            headerData.put( "purchase_user_tel"	    , info.getSession("TEL") );	
            headerData.put( "purchase_user_email"	, info.getSession("EMAIL") );	
            headerData.put( "rd_date1",     SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,    "rd_date",          "000000" ) ) );
            headerData.put( "rfq_date",     SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,    "rfq_date",          "" ) ) );
            headerData.put( "sign_status",      "E" ); 
            headerData.put( "create_type" ,     "PR" );		// PR 로 고정
            headerData.put( "del_flag",         "N" );
            headerData.put( "rfq_type",         "CL" ); 	// 지명 : CL, 공개 : OP
              
    		sxp = new SepoaXmlParser(this, "et_setRfqHDCreate");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			                                                          
			String TECHNICAL_EVAL         =   "".equals( MapUtils.getString( headerData, "technical_eval",  "" ))?"0":MapUtils.getString( headerData, "technical_eval", "" );    
			String PRICE_EVAL             =   "".equals( MapUtils.getString( headerData, "price_eval",      "" ))?"100":MapUtils.getString( headerData, "price_eval", ""  );     
			
			headerData.put( "technical_eval" 	, TECHNICAL_EVAL);                                       
			headerData.put( "price_eval"   		, PRICE_EVAL);  
			
			rtn = ssm.doInsert(headerData); 

        } catch( Exception e ) {
            
            Logger.debug.println( info.getSession( "ID" ), this, e.getMessage() );
        } finally {
        }

        return rtn;

    }

    /**
     * 견적의뢰 상세 정보 (SRQLN) 생성
     * 
     * @param allData
     * @return
     * @throws Exception
     */
    private int et_setRfqDTCreate( Map< String, Object > allData ) throws Exception {

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();
        ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
 
        int         intGridRowData  = 0;
        int         rtn             = 0;
        int         rfq_seq         = 0;
        int         reValue         = 0;

        try {

            headerData  = MapUtils.getMap( allData, "headerData", null );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );


    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setRfqDTCreate_deleteDT");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			 
			ssm.doDelete(headerData); 

            if( gridData != null && gridData.size() > 0 ) {

                intGridRowData  = gridData.size();

                for( int i = 0; i < intGridRowData; i++ ) {

                    gridRowData = gridData.get( i );

                    /**
                     * SRQLN의 RFQ_STATUS / D : 자재별 유찰 / 재견적일경우(이전 차수), Y : 자재별 업체 선정, N : 견적요청임시저장 / 견적요청 전송 / 재견적
                     * SRQLN의 SETTLE_FLAG / N : 임시저장 / 전송 / 재견적 / 업체선정 취소, Y : 자재별 업체 선정, D : 자재별 유찰 / 재견적일경우(이전 차수)
                     */ 
                    gridRowData.put( "COMPANY_CODE",     MapUtils.getString( headerData, "t_company_code", "" ) );
                    gridRowData.put( "RFQ_STATUS",      "N" );
                    gridRowData.put( "SETTLE_FLAG",     "N" );
                    gridRowData.put( "RFQ_NUMBER",      MapUtils.getString( headerData, "rfq_number",       "" ) );
                    gridRowData.put( "RFQ_COUNT",       MapUtils.getString( headerData, "rfq_count",        "" ) );
                    gridRowData.put( "RFQ_SEQ",         String.valueOf( ++rfq_seq )                              );
                    gridRowData.put( "RD_DATE",         SepoaString.getDateUnSlashFormat( MapUtils.getString( gridRowData, "RD_DATE", "" ) ) );
                    gridRowData.put( "CURRENT_DATE",    MapUtils.getString( headerData, "current_date",     "" ) );
                    gridRowData.put( "CURRENT_TIME",    MapUtils.getString( headerData, "current_time",     "" ) );
                    gridRowData.put( "SESSION_USER_ID", MapUtils.getString( headerData, "session_user_id",  "" ) );
                    gridRowData.put( "DEL_FLAG",        "N" );
 
                }
              
        		sxp = new SepoaXmlParser(this, "et_setRfqDTCreate");
    			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    			reValue = ssm.doInsert(gridData);   

            }

            rtn  = reValue;

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
    private int et_setRfqSECreate( Map< String, Object > allData ) throws Exception {

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
                            gridRowData.put( "SUPI_ID",        SELLER_SEQ );

                			sxp = new SepoaXmlParser(this, "et_setRfqSECreate_selectQT");                     
                			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
                			
                			String result = ssm.doSelect (gridRowData);
  
                            SepoaFormater sf = new SepoaFormater ( result );
                            
                            if(Integer.parseInt(sf.getValue("CNT", 0))>0){
                            	gridRowData.put( "CONFIRM_FLAG",    "P" ); // CONFIRM_FLAG( S:진행중, Y:완료, R:포기/거부, P:동일한 견적서 사용)
                            }

                			sxp = new SepoaXmlParser(this, "et_setRfqSECreate");                     
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

    /**
     * 제안설명회 정보 (SRQAN) 생성
     * 
     * @param allData
     * @return
     * @throws Exception
     */
    private int et_setRfqANCreate( Map< String, Object > allData ) throws Exception {

        int     rtn = 0;

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();
        ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );

        Map< String, String >           headerData  = null;

        Map map = new HashMap();

        try {

    		SepoaXmlParser sxp = new SepoaXmlParser();
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			
            headerData  = MapUtils.getMap( allData, "headerData" );
 
            headerData.put( "company_code",     MapUtils.getString( headerData, "t_company_code", "" ) );
            headerData.put( "pro_szdate",       SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,    "pro_szdate",       "" ) ) );
            headerData.put( "pro_doc_frw_date", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,    "pro_doc_frw_date", "" ) ) );
            headerData.put( "pro_start_time",   MapUtils.getString( headerData,    "pro_start_time",   "" ) + "00" );
            headerData.put( "pro_end_time",     MapUtils.getString( headerData,    "pro_end_time",     "" ) + "00" );
            headerData.put( "del_flag",         "N" );
  
            rtn = ssm.doInsert( headerData );

        } catch( Exception e ) {
            
            Logger.debug.println( info.getSession( "ID" ), this, e.getMessage() );
        } finally {
        }

        return rtn;

    }

	/**
	 * 견적요청상세 > 제안설명회 클릭 
	 * 
	 * @param STRING STRING
	 * @return
	 */
	public SepoaOut getRfqAnnounce( String rfq_number, String rfq_count ) {

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sql = new StringBuffer();
        
        String  language        = info.getSession( "LANGUAGE" );
        String  strUserType     = info.getSession( "USER_TYPE" );
        String  strCompanyCode  = "";

        try {
            setStatus(1);
            setFlag(true);

            // BUYER와 SELLER가 공통으로 쓰는 함수여서 compnay_code를 구분하기 위함
            if( "S".equals( strUserType ) ) {
                strCompanyCode  = info.getSession( "BUYER_COMPANY_CODE" );
            } else {
                strCompanyCode  = info.getSession( "COMPANY_CODE" );
            }

            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            
            sql.delete(0, sql.length());
            sql.append("     SELECT                                                                 \n");
    		sql.append("         RFQ_NUMBER,                                                            \n");
    		sql.append("         (SELECT SUBJECT FROM SRQGL                                      \n");
    		sql.append("          WHERE RFQ_NUMBER     = AN.RFQ_NUMBER                                      \n");
    		sql.append("          AND   RFQ_COUNT  = AN.RFQ_COUNT) AS SUBJECT,                      \n");
    		sql.append("         RFQ_COUNT AS RFQ_COUNT,                                            \n");
    		sql.append("         ANNOUNCE_DATE,                                                     \n");
    		sql.append("         ANNOUNCE_DATE AS ANNOUNCE_DATE_VIEW,                 \n");
    		sql.append("         ANNOUNCE_TIME_FROM,                                                \n"); 
    		sql.append("         ANNOUNCE_TIME_TO,                                                  \n");
    		//sql.append("         SUBSTR(ANNOUNCE_TIME_FROM" + DBUtil.getAndSeparator()+ "ANNOUNCE_TIME_TO,0,2)" + DBUtil.getAndSeparator()+ "':'" + DBUtil.getAndSeparator()+ "SUBSTR(ANNOUNCE_TIME_FROM" + DBUtil.getAndSeparator()+ "ANNOUNCE_TIME_TO,3,2)    \n");
    		//sql.append("         " + DBUtil.getAndSeparator()+ "' ~ '" + DBUtil.getAndSeparator()+ "SUBSTR(ANNOUNCE_TIME_FROM" + DBUtil.getAndSeparator()+ "ANNOUNCE_TIME_TO,5,2)" + DBUtil.getAndSeparator()+ "':'" + DBUtil.getAndSeparator()+ "SUBSTR(ANNOUNCE_TIME_FROM" + DBUtil.getAndSeparator()+ "ANNOUNCE_TIME_TO,7,2) as ANNOUNCE_TIME_VIEW,   \n");
    		sql.append("         (SELECT	COMPANY_NAME_LOC FROM SCMGL                          \n");
    		sql.append("           WHERE	COMPANY_CODE    = AN.ANNOUNCE_HOST) AS ANNOUNCE_HOST,   \n");
    		sql.append("         ANNOUNCE_AREA,                                                     \n");
    		sql.append("         ANNOUNCE_PLACE,                                                    \n");
    		sql.append("         ANNOUNCE_NOTIFIER,                                                 \n");
    		sql.append("         DOC_FRW_DATE,                                                      \n");
    		sql.append("         DOC_FRW_DATE AS DOC_FRW_DATE_VIEW,                   \n");
    		sql.append("         ANNOUNCE_RESP,                                                     \n");
    		sql.append("         ANNOUNCE_COMMENT,                                                   \n");
    		sql.append("         AN.ANNOUNCE_HOST AS ANNOUNCE_HOST_CODE                                                   \n");
    		sql.append("     FROM    SRQAN AN                                                    \n");
    		sql.append("  WHERE " + DB_NULL_FUNCTION + " (AN.DEL_FLAG, 'N') = 'N'                                      	\n");
    		
    		sql.append(sm.addSelectString(" AND AN.RFQ_NUMBER = ? 	\n"));
    		sm.addStringParameter(rfq_number);
    		
    		sql.append(sm.addSelectString(" AND AN.RFQ_COUNT = ? 	\n"));
    		sm.addStringParameter(rfq_count);
    			
    		setValue(sm.doSelect(sql.toString()));
            
        } catch (Exception e) {
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
    }

public SepoaOut getRfqHDDisplay(String rfq_number, String rfq_count, String nego_count) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();

		Map map = new HashMap();
        
		try {

        	SepoaXmlParser sxp = new SepoaXmlParser();
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			
			map.put("RFQ_NUMBER"	, rfq_number);
			map.put("RFQ_COUNT"		, rfq_count); 
			
			setValue(ssm.doSelect(map));
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
	
		return getSepoaOut();
	}

	/**
	 * 견적요청현황 > 그리드 견적요청번호 클릭 > 상세 팝업 > 그리드 데이터
	 * 
	 * @param headerData
	 * @return
	 */
	public SepoaOut getRfqDTDisplay( String rfq_number, String rfq_count ) {

        ConnectionContext ctx = getConnectionContext(); 
        
        String  language        = info.getSession( "LANGUAGE" );
        String  strUserType     = info.getSession( "USER_TYPE" );
        String  strCompanyCode  = "";

        Map< String, String > map = new HashMap();
        
        try {
        	
        	SepoaXmlParser sxp = new SepoaXmlParser();
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

            // BUYER와 SELLER가 공통으로 쓰는 함수여서 compnay_code를 구분하기 위함
            if( "S".equals( strUserType ) ) {
                strCompanyCode  = info.getSession( "BUYER_COMPANY_CODE" );
            } else {
                strCompanyCode  = info.getSession( "COMPANY_CODE" );
            } 

			map.put("RFQ_NUMBER"	, rfq_number);
			map.put("RFQ_COUNT"		, rfq_count); 
			 
			map.put("LANGUAGE"	, language);
			map.put("USER_TYPE"	, strUserType);
    		if( "S".equals(info.getSession("USER_TYPE")))
    		{ 
    			map.put("SELLER_CODE"		, info.getSession("COMPANY_CODE")); 
    		}else{
    			map.put("SELLER_CODE"		, ""); 
    		} 
		 
    		setValue(ssm.doSelect(map));
              
        } catch (Exception e) {
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
    }
	/**
     * 견적요청현황에서 견적요청 수정
     * 
     * @param allData
     * @return
     * @throws Exception
     */
    public SepoaOut setRfqUpdate( Map< String, Object > allData ) throws Exception {

        SepoaOut    so  = null;

        Map< String, String >           headerData  = null;
        List< Map< String, String > >   gridData    = null;

        String  rfq_number  = "";
        String  rfq_count   = "";

        int rtn1    = 0;
        int rtn2    = 0;
        int rtn3    = 0;
        int rtn4    = 0;
        int signup  = 0;

        try {

            setFlag( true );
            setStatus( 1 );

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );
            
            String explan_flag = "";
            
            //제안설명회 등록여부
            if( MapUtils.getString( headerData,    "pro_szdate",       "" ).length() > 0 )
            	explan_flag = "Y";
            

            /***************************************************************
             * 1. 견적의뢰 해더 정보 (SRQGL) 수정
             **************************************************************/
            rtn1 = et_setRfqHDUpdate( allData );
            if( rtn1 < 1 ) {
                Rollback();
                //수정중 오류가 발생했습니다.
                setMessage( msg.get( "PU_113.0002" ).toString() );
                setStatus( 0 );
                setFlag( false );
                return getSepoaOut();
            }

            /***************************************************************
             * 2. 견적의뢰 상세 정보 (SRQLN) 수정
             **************************************************************/
            rtn2 = et_setRfqDTUpdate( allData );
            if( rtn2 < 1 ) {
                Rollback();
              //수정중 오류가 발생했습니다.
                setMessage( msg.get( "PU_113.0002" ).toString() );
                setStatus( 0 );
                setFlag( false );
                return getSepoaOut();
            }

            /***************************************************************
             * 3. 견적의뢰 대상업체 정보 (SRQSE) 수정
             **************************************************************/
            rtn3 = et_setRfqSEUpdate( allData );
            if( rtn3 < 1 ) {
                Rollback();
              //수정중 오류가 발생했습니다.
                setMessage( msg.get( "PU_113.0002" ).toString() );
                setStatus( 0 );
                setFlag( false );
                return getSepoaOut();
            }

            /***************************************************************
             * 제안설명회 정보 (SRQAN) 생성
             **************************************************************/
            //제안설명회 가 있는 경우 등록
            if( "Y".equals(explan_flag) ){
            	
                rtn4 = et_setRfqANCreate( allData );
	            if( rtn4 < 1 ) {
	                Rollback();
	                //입력중 오류가 발생했습니다.
	                setMessage( msg.get( "PU_113.0000" ).toString() );
	                setStatus( 0 );
	                setFlag( false );
	                return getSepoaOut();
	            }
            }
            
            
            /***************************************************************
             * 4. 원가 정보 (SRQEP) 수정
             **************************************************************/
            //et_setRfqEPCreate( allData );

            /*************************************************************************** 
             * 5. RFQ 생성후 결재요청
             *************************************************************************
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
             * 6. RFQ 생성후 icoyprdt.sourcing_type 업데이트 
             **************************************************************************/
            //signup = et_prdtSourcingTypeUpd( allData );

            /*************************************************************************** 
             * 7. 메일 발송
             **************************************************************************/
            String rfq_flag = MapUtils.getString( headerData, "rfq_status", "" );
            if("P".equals(rfq_flag))
            {
                    //sendToSeller(headerData);
            }           
            
            setStatus( 1 );
            //견적요청이 마감되었습니다.
            setMessage( msg.get( "PU_113.0001" ).toString() );

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
    /**
     * 견적요청 해더정보(SRQGL) 수정
     * 
     * @param allData
     * @return
     * @throws Exception
     */
    private int et_setRfqHDUpdate( Map< String, Object > allData ) throws Exception {

        int     rtn = 0;

        ConnectionContext ctx = getConnectionContext(); 

        Map< String, String >           headerData  = null;
        List< Map< String, String > >   gridData    = null;

        String  rfq_close_date  = "";
        String  rfq_close_time  = "";

        try {
        	
        	SepoaXmlParser sxp = new SepoaXmlParser();
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			
            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );
             
            // 구매담당자 정보                                                  
            headerData.put( "purchase_user_id"	    , info.getSession("ID") );	
            headerData.put( "purchase_user_name"	, info.getSession("NAME_LOC")); 
            headerData.put( "purchase_user_tel"	    , info.getSession("TEL") );	
            headerData.put( "purchase_user_email"	, info.getSession("EMAIL") );	

            rfq_close_date  = SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "rfq_close_date",  "" ) );
            rfq_close_time  = SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "rfq_close_time",  "" ) );
            headerData.put( "rfq_close_date",   rfq_close_date);  
            headerData.put( "rfq_close_time",   rfq_close_time); 
            headerData.put( "rfq_status",   	MapUtils.getString( headerData, "rfq_flag"   	,  "" )); // 임시저장 : T, 전송일경우 : P 
            headerData.put( "create_type" ,     "PR" );		// PR 로 고정           
            headerData.put( "sign_status" ,     "E" );            
            headerData.put( "del_flag",          "N" );        
            headerData.put( "rfq_type",         "CL" ); 	// 지명 : CL, 공개 : OP
            headerData.put( "del_flag",          "N" );

			String TECHNICAL_EVAL         =   "".equals( MapUtils.getString( headerData, "technical_eval",  "" ))?"0":MapUtils.getString( headerData, "technical_eval", "" );    
			String PRICE_EVAL             =   "".equals( MapUtils.getString( headerData, "price_eval",      "" ))?"100":MapUtils.getString( headerData, "price_eval", ""  );     
			
			headerData.put( "technical_eval" 	, TECHNICAL_EVAL);                                       
			headerData.put( "price_eval"   		, PRICE_EVAL);  
			
            rtn = ssm.doUpdate( headerData );

        } catch( Exception e ) {
            
            
            Logger.debug.println( info.getSession( "ID" ), this, e.getMessage() );
        } finally {
        }

        return rtn;

    }
    /**
     * 견적의뢰 상세 정보 (SRQLN) 수정
     * 
     * @param allData
     * @return
     * @throws Exception
     */
    private int et_setRfqDTUpdate( Map< String, Object > allData ) throws Exception {

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();
        ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;

        int         rtn     = 0;
        int         reValue = 0;
        int         rfq_seq = 0;

        try {
        	
        	SepoaXmlParser sxp = new SepoaXmlParser(this,"et_setRfqDTCreate_deleteDT");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			
            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );
 
            ssm.doDelete( headerData );

            if( gridData != null && gridData.size() > 0 ) {

	            for( int i = 0; i < gridData.size(); i++ ) {
	
	                gridRowData = gridData.get( i );
	
	                /**
	                 * RFQ_STATUS / 임시저장 : T, 전송일경우 : NULL
	                 * 추후 수정해야함...임시저장과 전송 구분
	                 */
	                gridRowData.put( "RFQ_STATUS",      "N");
	                gridRowData.put( "SETTLE_FLAG",     "N" );
	                gridRowData.put( "RFQ_NUMBER",      MapUtils.getString( headerData, "rfq_number",       "" ) );
	                gridRowData.put( "RFQ_COUNT",       MapUtils.getString( headerData, "rfq_count",        "" ) );
	                gridRowData.put( "RFQ_SEQ",         String.valueOf( ++rfq_seq )                              );
	                gridRowData.put( "RD_DATE",         SepoaString.getDateUnSlashFormat( MapUtils.getString( gridRowData, "RD_DATE", "" ) ) );
	                gridRowData.put( "CURRENT_DATE",    MapUtils.getString( headerData, "current_date",     "" ) );
	                gridRowData.put( "CURRENT_TIME",    MapUtils.getString( headerData, "current_time",     "" ) );
	                gridRowData.put( "SESSION_USER_ID", MapUtils.getString( headerData, "session_user_id",  "" ) );
	                gridRowData.put( "DEL_FLAG",        "N" );
	                gridRowData.put( "COMPANY_CODE",  MapUtils.getString( headerData,    "t_company_code",         "" ) ); // COMPANY_CODE   
	                /*
	                gridRowData.put( "RFQ_QTY",           MapUtils.getString( gridRowData,   "RFQ_QTY",              "0" ) ); // RFQ_QTY
	                gridRowData.put( "SETTLE_QTY",        MapUtils.getString( gridRowData,   "SETTLE_QTY",           "0" ) ); // SETTLE_QTY
	                gridRowData.put( "PRICE_UNIT",        MapUtils.getString( gridRowData,   "PRICE_UNIT",           "0" ) ); // PRICE_UNIT
	                gridRowData.put( "RFQ_AMT",           MapUtils.getString( gridRowData,   "RFQ_AMT",              "0" ) ); // RFQ_AMT
	                gridRowData.put( "BID_COUNT",         MapUtils.getString( gridRowData,   "BID_COUNT",            "0" ) ); // BID_COUNT
	                gridRowData.put( "RP_COUNT",          MapUtils.getString( gridRowData,   "RP_COUNT",             "0" ) ); // RP_COUNT
	                gridRowData.put( "MIN_PRICE",         MapUtils.getString( gridRowData,   "MIN_PRICE",            "0" ) ); // MIN_PRICE
	                gridRowData.put( "MAX_PRICE",         MapUtils.getString( gridRowData,   "MAX_PRICE",            "0" ) ); // MAX_PRICE
	                gridRowData.put( "COST_COUNT",        MapUtils.getString( gridRowData,   "COST_COUNT",           "0" ) ); // COST_COUNT
	                gridRowData.put( "YEAR_QTY",          MapUtils.getString( gridRowData,   "YEAR_QTY",             "0" ) ); // YEAR_QTY
	                gridRowData.put( "PURCHASE_PRE_PRICE", MapUtils.getString( gridRowData,   "PURCHASE_PRE_PRICE",   "0" ) ); // PURCHASE_PRE_PRICE
	                 */
	
	            }
	
	        	sxp = new SepoaXmlParser(this,"et_setRfqDTUpdate");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				
	            reValue = ssm.doInsert(gridData);
	            rtn  = reValue;
            }
        } catch( Exception e ) {
            
            Logger.debug.println( info.getSession( "ID" ), this, e.getMessage() );
        } finally {
        }

        return rtn;

    }

    /**
     * 업체선택으로 셋팅한 업체 수정
     * create나 update나 동일한 구문이 들어간다.
     * @param allData
     * @return
     * @throws Exception
     */
    private int et_setRfqSEUpdate( Map< String, Object > allData ) throws Exception {

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();
        ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;

        int         rtn = 0;
        String[]    strDivide0;        
        String[]    strDivide1;        

        String      SELLER_CODE = "";

        try {

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );
            if ( "N".equals(MapUtils.getString ( headerData , "seller_change_flag" , "" )) ) {
                return 1;
            }

        	SepoaXmlParser sxp = new SepoaXmlParser(this,"et_setRfqSECreate_deleteSE");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			
            ssm.doDelete( headerData );

            if( gridData != null && gridData.size() > 0 ) {

	            // 그리드의 데이터 만큼 돌린다.
	            for( int i = 0; i < gridData.size(); i++ ) {
	
	                gridRowData = gridData.get( i );
	                
	                gridRowData.put ( "SELLER_SELECTED" ,  MapUtils.getString( gridRowData, "SELLER_SELECTED", "" ).replaceAll ( "&#64;" , "@" ).replaceAll ( "&#40;" , "(").replaceAll ( "&#41;" , ")" ) );
	                strDivide0  = SepoaString.parser( MapUtils.getString( gridRowData, "SELLER_SELECTED", "" ), "#" );
	
	                // 그리드의 업체 데이터 수만큼 돌린다.
	                for( int j = 0; j < strDivide0.length; j++ ) {
	
	                    strDivide1  = SepoaString.parser( strDivide0[j], "@" );
	                    SELLER_CODE = strDivide1[0].trim();
	                    String SELLER_SEQ  = strDivide1[5].trim();
	                    //System.out.println (SELLER_SEQ) ;
	                    String[] SELLER_SEQS = SELLER_SEQ.split ( "!" ); 
	                    
	                    SELLER_SEQ = "";
	                    for(int k = 0 ; k < SELLER_SEQS.length ; k++){
	                        if(SELLER_SEQS[k].indexOf ( SELLER_CODE ) != -1){
	                            SELLER_SEQ += SELLER_SEQS[k] + "!";
	                        }
	                    }
	
	                    gridRowData.put( "ADD_DATE",    MapUtils.getString( headerData, "current_date",     "" ) );
	                    gridRowData.put( "ADD_TIME",    MapUtils.getString( headerData, "current_time",     "" ) );
	                    gridRowData.put( "ADD_USER_ID", MapUtils.getString( headerData, "session_user_id",  "" ) );
	                    gridRowData.put( "CONFIRM_FLAG",    "S" ); // CONFIRM_FLAG( S:진행중, Y:완료, R:포기/거부)
	                    gridRowData.put( "DEL_FLAG",        "N" );
	
	                	sxp = new SepoaXmlParser(this,"et_setRfqSECreate_selectQT");  
	        			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
	
	        			String result = ssm.doSelect (gridRowData);
	
	                    SepoaFormater sf = new SepoaFormater ( result );
	                    
	                    if(Integer.parseInt(sf.getValue("CNT", 0))>0){
	                    	gridRowData.put( "CONFIRM_FLAG",    "P" ); // CONFIRM_FLAG( S:진행중, Y:완료, R:포기/거부, P:동일한 견적서 사용)
	                    }
	                     
	                }
	
	            }
				sxp = new SepoaXmlParser(this, "et_setRfqSECreate");                     
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
	
	            rtn  = ssm.doInsert( gridRowData );
            }

        } catch( Exception e ) {
            
            Logger.debug.println( info.getSession( "ID" ), this, e.getMessage() );
        } finally {
        }

        return rtn;
    }
    public SepoaOut getSelectUserData(String rfq_number, String rfq_count, String nego_count) {
        
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sqlsb = new StringBuffer();

		Map map = new HashMap();
		
        try {
            setStatus(1);
            setFlag(true);

        	SepoaXmlParser sxp = new SepoaXmlParser(this,"getSelectUserData");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			
			map.put("RFQ_NUMBER", rfq_number);
			map.put("RFQ_COUNT", rfq_count);
			
			setValue(ssm.doSelect(map));
			 
            
        } catch (Exception e) {
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }
    
        return getSepoaOut();
    }

    /*
     * 재견적요청
     * */
    public SepoaOut setReRfqCreate( Map< String, Object > allData ) throws Exception {

        setFlag( true );
        setStatus( 1 );
        
        SepoaOut    so  = null;
        Map< String, String >           headerData  = null;
        List< Map< String, String > >   gridData    = null;

        //String  explan_flag   = "";

        int rtn0    = 0;
        int rtn1    = 0;
        int rtn2    = 0;
        int rtn3    = 0;
        int rtn4    = 0;
        
        String re_rfq_count = "";

        String mail_type    = "";
        
        try {

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );
            
            
            if("P".equals(MapUtils.getString( headerData, "req_type", "P" )) ){
                mail_type = "RQ";
                
            }else if ("C".equals(MapUtils.getString( headerData, "req_type", "" ))){
                mail_type = "RQ";
                
            }else {
                mail_type = "BRQ";
                
            }
            

            /***************************************************************
             * 0. 재견적 RFQ_COUNT 가져오기.
             **************************************************************/
            
            so = getReRfqcount( allData );
            
        	SepoaFormater wf = new SepoaFormater(so.result[0]);
        	
        	if(wf != null) {
        		re_rfq_count  = wf.getValue("RFQ_COUNT", 0);
        		headerData.put( "rfq_count"	    , re_rfq_count );	
        	}
            

            /***************************************************************
             * 1. 견적의뢰 해더 정보 (SRQGL) 생성
             **************************************************************/
            rtn0 = et_setRfqHDCreate( allData );
            if( rtn0 < 1 ) {
                Rollback();
                //입력중 오류가 발생했습니다.
                setMessage( msg.get( "PU_113.0000" ).toString());
                setStatus( 0 );
                setFlag( false );
                return getSepoaOut();
            }

            /***************************************************************
             * 2. 견적의뢰 상세 정보 (SRQLN) 생성
             **************************************************************/
            rtn1 = et_setRfqDTCreate( allData );
            if( rtn1 < 1 ) {
                Rollback();
                //입력중 오류가 발생했습니다.
                setMessage( msg.get( "PU_113.0000" ).toString());
                setStatus( 0 );
                setFlag( false );
                return getSepoaOut();
            }

            /***************************************************************
             * 3. 견적의뢰 대상업체 정보 (SRQSE) 생성
             **************************************************************/
            rtn2 = et_setRfqSECreate( allData );
            if( rtn2 < 1 ) {
                Rollback();
                //입력중 오류가 발생했습니다.
                setMessage( msg.get( "PU_113.0000" ).toString());
                setStatus( 0 );
                setFlag( false );
                return getSepoaOut();
            }

            /***************************************************************
             * 4.제안설명회 정보 (SRQAN) 생성
             **************************************************************/
            //제안설명회 가 있는 경우 등록
            /*if( sepoa.fw.util.CommonUtil.Flag.Yes.getValue().equals(explan_flag) ){
            	
                rtn3 = et_setRfqANCreate( allData );
	            if( rtn3 < 1 ) {
	                Rollback();
	                setMessage( msg.getMessage( "0000" ) );
	                setStatus( 0 );
	                setFlag( false );
	                return getSepoaOut();
	            }
            }*/
            
            
            /***************************************************************
			 * 5. 이전 RFQ 마감 정보 수정
			 **************************************************************/
            rtn4 = setRfqcomplete(allData);
            if( rtn4 < 1 ) {
                Rollback();
                //입력중 오류가 발생했습니다.
                setMessage( msg.get( "PU_113.0000" ).toString());
                setStatus( 0 );
                setFlag( false );
                return getSepoaOut();
            }
            
            Commit();
            /*************************************************************************** 
             * 6. 메일 발송
             **************************************************************************/
            
			String development_flag = getConfig("sepoa.server.development.flag");
			//개발장비인 경우 메일발송
			
			String rfq_number = MapUtils.getString( headerData, "rfq_number", "" );
			String subject 	= MapUtils.getString( headerData, "subject", "" );
			String rfq_flag = MapUtils.getString( headerData, "rfq_status", "" );
	        String rp_type   = "";
			
            if("P".equals(rfq_flag))
            {
                    //PU_112_Mail mail = new PU_112_Mail( info , this );
                    //mail.sendMailToSellerDongA( rfq_number , subject , mail_type , rp_type , headerData );
                    
                    //sendToSeller(headerData);
            }           
			

            setStatus( 1 );
            //견적요청이 마감되었습니다.
            setMessage( msg.get( "PU_113.0100" ).toString());
            setValue( MapUtils.getString( headerData, "rfq_number",      "" ));           


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
	
	private SepoaOut getReRfqcount(Map< String, Object > allData) throws Exception
	{

		setStatus(1);
		setFlag(true);

        ConnectionContext ctx = getConnectionContext(); 

        Map< String, String >           headerData  = null;
        
        headerData  = MapUtils.getMap( allData, "headerData" );
         
		try{

        	SepoaXmlParser sxp = new SepoaXmlParser();
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			
			setValue(ssm.doSelect(headerData)); 
			
			
		} catch(Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}

	private int setRfqcomplete(Map< String, Object > allData) throws Exception
	{
		int rtn = 0;

        ConnectionContext ctx = getConnectionContext(); 

        Map< String, String >           headerData  = null;
        headerData  = MapUtils.getMap( allData, "headerData" );

        String before_rfq_count = "";

    	SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		try{
			
	        String str_rfq_count = JSPUtil.getString( MapUtils.getString( headerData, "rfq_count", "2" ), "2" );
	        
	        int n_rfq_count = Integer.parseInt( str_rfq_count );
	        
	        before_rfq_count = String.valueOf(n_rfq_count - 1); 
	        
	        headerData.put("rfq_count", before_rfq_count);

        	sxp = new SepoaXmlParser(this, "setRfqcomplete_updateSRQGL");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn += ssm.doUpdate(headerData);

        	sxp = new SepoaXmlParser(this, "setRfqcomplete_updateSRQLN");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn += ssm.doUpdate(headerData);
			   
		} catch(Exception e) {
			rtn = -1;
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		
		return rtn;
	}
	
}
