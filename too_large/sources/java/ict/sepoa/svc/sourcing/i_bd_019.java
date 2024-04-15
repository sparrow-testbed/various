/**
 *========================================================
 *Copyright(c) 2013 SEPOA SOFT
 *
 *@File     : BD_006.java
 *
 *@FileName : 입찰적격자조회
 *
 *Open Issues :
 *
 *Change history
 *@LastModifier :
 *@LastVersion : 2013.01.24
 *=========================================================
 */ 

package ict.sepoa.svc.sourcing;


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
import sepoa.fw.util.DBUtil ;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate ;
import sepoa.fw.util.SepoaFormater ;
import sepoa.fw.util.SepoaString ;    
import sms.SMS;

import java.util.StringTokenizer;
/*
import sepoa.svc.common.constants ;
import sepoa.svc.datatypes.SSCGL_DataType;
import sepoa.svc.datatypes.SSCLN_DataType;
import sepoa.svc.misInterface.MisInterfaceUtil;
import Interface.webService.MMIF0200;
import Interface.webService.WS_002 ;
*/
@SuppressWarnings( { "unchecked", "unused", "rawtypes" } )
public class I_BD_019 extends SepoaService {

    private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession( "HOUSE_CODE" );
    private String lang         = info.getSession( "LANGUAGE" );
    //20131212 sendakun
    private HashMap msg = null;

    public I_BD_019( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.err.println("I_BD_019: = " + e.getMessage());
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

	/* ICT 사용 : 적격업체대상 공고 목록 가져오기 */
    public SepoaOut getBdConfrimList(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 
        String company_code   = info.getSession("COMPANY_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdConfrimList");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

            headerData.put("HOUSE_CODE", house_code); 
            headerData.put("START_CHANGE_DATE",  SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "start_change_date", "" ) ) ); 
            headerData.put("END_CHANGE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "end_change_date", "" ) ) ); 
            headerData.put("ANN_NO", MapUtils.getString( headerData,  "ann_no")); 
            headerData.put("ANN_ITEM", MapUtils.getString( headerData,  "ann_item"));  
            
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

    /* ICT 사용 */
    public SepoaOut getBdHeaderDetail(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 
        String company_code   = info.getSession("COMPANY_CODE"); 
        String rtn = "";

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdHeaderDetail");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
 
            headerData.put("HOUSE_CODE", house_code);   
            
            
            
            rtn = ssm.doSelect(headerData);
            
            setValue(rtn);

			sxp = new SepoaXmlParser(this, "getAlarmData");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
			
			rtn = ssm.doSelect(headerData);

            setValue(rtn);
            
            setStatus(1);
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    } 

	/* ICT 사용 : 적격업체 업체리스트 가져오기 (개별처리) */
	public SepoaOut getBdItemDetail(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 
        String company_code   = info.getSession("COMPANY_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdItemDetail");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  

            headerData.put("HOUSE_CODE", house_code);   
            
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
	
	/* ICT 사용 : 적격업체 업체리스트 가져오기 (통합처리) */
	public SepoaOut getBdItemDetail2(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 
        String company_code   = info.getSession("COMPANY_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdItemDetail2");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  

            headerData.put("HOUSE_CODE", house_code);   
            
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
	
	/* ICT 사용 : 공고 서류접수,적격업체확인 (개별처러) */
	public SepoaOut setBdStatus( Map< String, Object > allData ) throws Exception {

        SepoaOut    so  = null;
        int rtn = 0;
        int	intGridRowData  = 0;
        String sVendors = null;
        
        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
        try {

            setFlag( true );
            setStatus( 1 );

            headerData  = MapUtils.getMap( allData, "headerData" ); 
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );
 
            headerData.put( "HOUSE_CODE",	info.getSession("HOUSE_CODE") ); 
            headerData.put( "COMPANY_CODE",	info.getSession("COMPANY_CODE") ); 
            headerData.put( "ANN_NO",		MapUtils.getString( headerData,  "ANN_NO") ); 
            headerData.put( "ANN_COUNT",	MapUtils.getString( headerData,  "ANN_COUNT") );
            
            String PFLAG = MapUtils.getString( headerData, "PFLAG" );
            
            /* 
             * 확인 필요함.
             * 
            String status = et_chkMagam(headerData);

            if (!status.equals("BT")){
                setStatus(0);
                setMessage("입찰마감이나 유찰하실 수 없는 상태입니다.");   // 입찰마감이나 유찰하실 수 없는 상태입니다.
                return getSepoaOut();
            }
            */
            
//            String status = et_chkJoinEndDate(headerData); // 입찰제출마감시간 체크
//                        
//            if (status.equals("N")){
//            	setFlag( false );
//                setStatus(0);
//				setMessage("서류제출마감 시간이 지났습니다.");
//				return getSepoaOut();
//			}
            
            String status2 = et_chkMagam(headerData); // 입찰제출마감시간 체크
			
			if (status2.equals("Y")){
				setFlag( false );
				setStatus(0);
				setMessage("공고가 마감되어 처리가 불가합니다.");
				return getSepoaOut();
			}

            int rtnBDAP = 0;
			//int rtn = et_setBidStatus(ctx, recvData);

            //Logger.err.println("==gridData.size()==="+gridData.size());
            if( gridData != null && gridData.size() > 0 ) {// 참가신청 업체가 0일수도 있음으로...
			    rtnBDAP = et_setBDAP(allData);
            }
 
            
//            String CONT_TYPE2 = MapUtils.getString( headerData, "CONT_TYPE2" );
//     
//
//            if(PFLAG.equals("RC")) {
//                if(CONT_TYPE2.equals("LP")) {
//                	PFLAG = "RC";
//                } else if(CONT_TYPE2.equals("TE")){
//                	PFLAG = "SR";
//                } else if(CONT_TYPE2.equals("TTE")){
//                	PFLAG = "SR";
//                }
//            }
            
            if( gridData != null && gridData.size() > 0 ) {// 참가신청 업체가 0일수도 있음으로...
            	 /* SMS 발송 */
	            ConnectionContext ctx = getConnectionContext();
	            Map<String, String> param = new HashMap<String, String>();
				
	            if("INP".equals(PFLAG)){
	            	param.put("SMS_KIND"	, "ICT_SMS_14");					
	            }else if("FINAL".equals(PFLAG)){
	            	param.put("SMS_KIND"	, "ICT_SMS_15");					
	            }
				param.put("HOUSE_CODE"	, headerData.get("HOUSE_CODE"));
				param.put("ANN_NO"		, headerData.get("ANN_NO"));
				param.put("ANN_COUNT"	, headerData.get("ANN_COUNT"));
				
				
            	intGridRowData  = gridData.size(); 
                // 그리드의 데이터 만큼 돌린다.
                for( int i = 0; i < intGridRowData; i++ ) {
                    gridRowData = gridData.get( i );
                    
                    
                    if("INP".equals(PFLAG)){
                    	if( "Y".equals(gridRowData.get("INP_CNF"))){
                    		param.put("VENDOR_CODE"	, gridRowData.get("VENDOR_CODE"));         
                    		
                    		new SMS("NONDBJOB", info).fnSMS_Send_ICT2(ctx, param);                  
                        }    	            				
    	            }else if("FINAL".equals(PFLAG)){
    	            	//if( "Y".equals(gridRowData.get("FINAL_FLAG"))){
    	            		param.put("VENDOR_CODE"	, gridRowData.get("VENDOR_CODE"));
    	            		param.put("FINAL_FLAG"	, gridRowData.get("FINAL_FLAG"));
    	            		    	            		    	            		
    	            		new SMS("NONDBJOB", info).fnSMS_Send_ICT2(ctx, param);                  
                        //}   		
    	            }
                    
                                 
                }
            				 
            }
          
            setMessage("성공적으로 작업을 수행했습니다.");
            
            setStatus(1);
            setValue("");
            Commit();	
            
            
           
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    }
	
	/* ICT 사용 : 공고 서류접수,적격업체확인 (통합처러) */
	public SepoaOut setBdStatus2( Map< String, Object > allData ) throws Exception {

        SepoaOut    so  = null;
        int rtn = 0;
        int	intGridRowData  = 0;
        String sVendors = null;
        
        String INP_CNF = null;
        String FINAL_FLAG = null;
        String INP_CNF_ASIS = null;
        String FINAL_FLAG_ASIS = null;
        
        
        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
        try {

            setFlag( true );
            setStatus( 1 );

            headerData  = MapUtils.getMap( allData, "headerData" ); 
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );
 
            headerData.put( "HOUSE_CODE",	info.getSession("HOUSE_CODE") ); 
            headerData.put( "COMPANY_CODE",	info.getSession("COMPANY_CODE") ); 
            headerData.put( "ANN_NO",		MapUtils.getString( headerData,  "ANN_NO") ); 
            headerData.put( "ANN_COUNT",	MapUtils.getString( headerData,  "ANN_COUNT") );
            
            String status2 = et_chkMagam(headerData); // 입찰제출마감시간 체크
			
			if (status2.equals("Y")){
				setFlag( false );
				setStatus(0);
				setMessage("공고가 마감되어 처리가 불가합니다.");
				return getSepoaOut();
			}

            int rtnBDAP = 0;
			
            //Logger.err.println("==gridData.size()==="+gridData.size());
            if( gridData != null && gridData.size() > 0 ) {// 참가신청 업체가 0일수도 있음으로...
			    rtnBDAP = et_setBDAP(allData);
            }
            
            if( gridData != null && gridData.size() > 0 ) {// 참가신청 업체가 0일수도 있음으로...
           	    /* SMS 발송 */
                ConnectionContext ctx = getConnectionContext();
                Map<String, String> param = new HashMap<String, String>();
       		
               	param.put("HOUSE_CODE"	, headerData.get("HOUSE_CODE"));
	       		param.put("ANN_NO"		, headerData.get("ANN_NO"));
	       		param.put("ANN_COUNT"	, headerData.get("ANN_COUNT"));
	       		
	       		
	           	intGridRowData  = gridData.size(); 
	            // 그리드의 데이터 만큼 돌린다.
	            for( int i = 0; i < intGridRowData; i++ ) {
	                gridRowData = gridData.get( i );
	                
	                INP_CNF         = gridRowData.get("INP_CNF");
	                FINAL_FLAG      = gridRowData.get("FINAL_FLAG");
	                INP_CNF_ASIS    = gridRowData.get("INP_CNF_ASIS");
	                FINAL_FLAG_ASIS = gridRowData.get("FINAL_FLAG_ASIS");
	                
	                if( "Y".equals(INP_CNF) && !INP_CNF_ASIS.equals(INP_CNF)){
	                	param.put("SMS_KIND"	, "ICT_SMS_14");	
	                	param.put("VENDOR_CODE"	, gridRowData.get("VENDOR_CODE"));         
	            		
	            		new SMS("NONDBJOB", info).fnSMS_Send_ICT2(ctx, param);
	                }
	                
	                if( !"".equals(FINAL_FLAG) && !FINAL_FLAG_ASIS.equals(FINAL_FLAG)){
	                	param.put("SMS_KIND"	, "ICT_SMS_15");	
	            		param.put("VENDOR_CODE"	, gridRowData.get("VENDOR_CODE"));
	            		param.put("FINAL_FLAG"	, gridRowData.get("FINAL_FLAG"));
	            		    	            		    	            		
	            		new SMS("NONDBJOB", info).fnSMS_Send_ICT2(ctx, param);                  
	                }   		                             
	            }
           				 
            }
          
            setMessage("성공적으로 작업을 수행했습니다.");
            
            setStatus(1);
            setValue("");
            Commit();	
            
            
           
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    }
	
	private String et_chkJoinEndDate( Map< String, String > headerData ) throws Exception 
    {
    	ConnectionContext ctx = getConnectionContext(); 
    	
    	String rtn = null; 
    	String value = null; 
    	try { 
    		
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_chkJoinEndDate");
    		SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    		value = ssm.doSelect(headerData);
    		SepoaFormater wf = new SepoaFormater(value);
    		rtn = wf.getValue(0,0);
    		
    	} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	return rtn;
    }


//    private String et_chkMagam(Map< String, String > headerData ) throws Exception  
//	{
//        ConnectionContext ctx = getConnectionContext(); 
//        
//        String rtn = null;
//        int	intGridRowData  = 0;
//    	try { 
//    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_chkMagam");
//			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
// 
//            SepoaFormater wf = new SepoaFormater(ssm.doSelect(headerData));
//            rtn =  wf.getValue(0,0);
//          
//   		} catch(Exception e) {
//    		Logger.err.println(userid,this,e.getMessage());
//    		throw new Exception(e.getMessage());
//   		} 
//   		return rtn; 
//	}
	
	private String et_chkMagam( Map< String, String > headerData ) throws Exception 
    {
    	ConnectionContext ctx = getConnectionContext(); 
    	
    	String rtn = null; 
    	String value = null; 
    	try { 
    		
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_chkMagam");
    		SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    		value = ssm.doSelect(headerData);
    		SepoaFormater wf = new SepoaFormater(value);
    		rtn = wf.getValue(0,0);
    		
    	} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	return rtn;
    }


    private int et_setBDAP( Map< String, Object > allData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();
        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
        
        int rtn = 0;
        int	intGridRowData  = 0;
    	try {
            headerData  = MapUtils.getMap( allData, "headerData", null );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );
            
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setBDAP");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

            if( gridData != null && gridData.size() > 0 ) {

                intGridRowData  = gridData.size(); 
                // 그리드의 데이터 만큼 돌린다.
                for( int i = 0; i < intGridRowData; i++ ) {
                    gridRowData = gridData.get( i );
                    
                    String final_flag = gridRowData.get("FINAL_FLAG");
                    //적합업체인 경우 사유컬럼 지운다
                    if( "Y".equals(final_flag)){
                    	gridRowData.put("INCO_REASON", "");
                    }

                    gridRowData.put("HOUSE_CODE",  MapUtils.getString( headerData, "HOUSE_CODE"));
                	gridRowData.put("ANN_NO",  MapUtils.getString( headerData, "ANN_NO"));
                	gridRowData.put("ANN_COUNT",  MapUtils.getString( headerData, "ANN_COUNT")); 
                	rtn = ssm.doInsert(gridRowData);
                }
            }
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }

	
}// 
