/**
 *========================================================
 *Copyright(c) 2013 SEPOA SOFT
 *
 *@File     : BD_008.java
 *
 *@FileName : 1단계평가 
 *
 *Open Issues :
 *
 *Change history
 *@LastModifier :
 *@LastVersion : 2013.01.24
 *=========================================================
 */ 

package sepoa.svc.sourcing;


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
public class BD_014 extends SepoaService {

    private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession( "HOUSE_CODE" );
    private String lang         = info.getSession( "LANGUAGE" );
    //20131212 sendakun
    private HashMap msg = null;

    public BD_014( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.sys.println( "BD_014 : " + e.getMessage() );
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
  
	public SepoaOut getBdOpenList(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext(); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdOpenList");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  

            headerData.put( "HOUSE_CODE",	info.getSession("HOUSE_CODE") );  
            headerData.put( "START_CHANGE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "start_change_date",        "" ) ) ); 
            headerData.put( "END_CHANGE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "end_change_date",          "" ) ) );  
            
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
	
	public SepoaOut getVendor(Map< String, String > headerData)
	{
		ConnectionContext ctx = getConnectionContext(); 
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {
			
			sxp = new SepoaXmlParser(this, "getVendor");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
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

	public SepoaOut getBdOpen(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext(); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdOpen");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
 
            headerData.put( "HOUSE_CODE",	info.getSession("HOUSE_CODE") );   
            
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

	public SepoaOut setBdProcess( Map< String, Object > allData ) throws Exception {

        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		String EVAL_REFITEM = "";
        int         intGridRowData  = 0;
        try {

            setFlag(true);

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );
            
            if( gridData != null && gridData.size() > 0 ) {

                intGridRowData  = gridData.size();

                for( int i = 0; i < intGridRowData; i++ ) {

                    gridRowData = gridData.get( i );

 
                    gridRowData.put( "HOUSE_CODE",      house_code );
                    gridRowData.put( "BID_NO",      		MapUtils.getString( headerData, "BID_NO",       "" ) );
                    gridRowData.put( "BID_COUNT",      	MapUtils.getString( headerData, "BID_COUNT",       "" ) );
                    gridRowData.put( "VOTE_COUNT",      MapUtils.getString( headerData, "VOTE_COUNT",       "" ) ); 
                    
            		sxp = new SepoaXmlParser(this, "et_setBidProcess");
            		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            		ssm.doUpdate(gridRowData);
            		
            		sxp = new SepoaXmlParser(this, "et_setBidBDSP");
            		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            		ssm.doUpdate(gridRowData); 

        			//Logger.debug.println(this, "[setBidProcess] 제안평가 결과[setVEVH]==PROPOSAL_RESULT::"+setVEVH[0][0]);
        			//Logger.debug.println(this, "[setBidProcess] 제안평가 결과[setVEVH]==HOUSE_CODE::"+setVEVH[0][1]);
        			//Logger.debug.println(this, "[setBidProcess] 제안평가 결과[setVEVH]==EVAL_REFITEM::"+setVEVH[0][2]);
//                    if(!"".equals(setVEVH[0][2])){
//        				rtnBDSP = et_setBidVEVH(ctx, setVEVH);
//        			}
            		
                    EVAL_REFITEM = MapUtils.getString( gridRowData, "EVAL_REFITEM", "" );

        			if(!"".equals(EVAL_REFITEM)){
        	    		sxp = new SepoaXmlParser(this, "et_setBidVEVH");
        	    		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

                        gridRowData.put( "PROPOSAL_RESULT", MapUtils.getString( headerData, "choice_eval_num",  "" ) ); 
                        gridRowData.put( "HOUSE_CODE", info.getSession("HOUSE_CODE") );
                        gridRowData.put( "EVAL_REFITEM", MapUtils.getString( headerData, "eval_refitem",  "" ) );
        	    		ssm.doUpdate(gridRowData);  
        			}
                }
            }

            setStatus( 1 );  
            setMessage( "" );
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

	public SepoaOut getBdHeaderCompare(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext(); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdHeaderCompare");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
 
            headerData.put( "HOUSE_CODE",	info.getSession("HOUSE_CODE") );   

            setValue(ssm.doSelect(headerData)); 
         
            String flag = MapUtils.getString( headerData, "FLAG");
            Logger.err.println("====flag==========>" +flag);
            if(!flag.equals("D")) { // 입찰비교표
                // bdHD, bdES -- 입찰상세(기초금액/예정가격enc)정보
    			sxp = new SepoaXmlParser(this, "et_getEstmInfo_ENC");
    			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
                setValue(ssm.doSelect(headerData)); 

            } else {                // 상세조회

                // bdVO --낙찰업체정보
    			sxp = new SepoaXmlParser(this, "et_getSettleVendor");
    			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
                setValue(ssm.doSelect(headerData));  

                // bdHD, bdES, bdVO -- 입찰상세(기초금액/예정가격/낙찰금액)정보
    			sxp = new SepoaXmlParser(this, "et_getAmtInfo");
    			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
                setValue(ssm.doSelect(headerData)); 

    			sxp = new SepoaXmlParser(this, "et_getDispBDVO");
    			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
                setValue(ssm.doSelect(headerData)); 
            }
 
            setStatus(1);
        }catch (Exception e){
//        	e.printStackTrace();
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    } 

	public SepoaOut getBdOpenProcess(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext(); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdOpenProcess");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
 
            headerData.put( "HOUSE_CODE",	info.getSession("HOUSE_CODE") );   
            
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

	public SepoaOut getBdDetailCompare(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext(); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdDetailCompare");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
 
            headerData.put( "HOUSE_CODE",	info.getSession("HOUSE_CODE") );   
            
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

	public SepoaOut setOrder(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext(); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "setOrder");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
 
            headerData.put( "HOUSE_CODE",	info.getSession("HOUSE_CODE") );   
            
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
	
	public SepoaOut getBidResult(Map< String, String > headerData)
	{
		ConnectionContext ctx = getConnectionContext(); 
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {
			
			sxp = new SepoaXmlParser(this, "getBidResult");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
			
			headerData.put( "HOUSE_CODE",	info.getSession("HOUSE_CODE") );   
			
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

	public SepoaOut setBdProcessSB( Map< String, Object > allData ) throws Exception {

        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 
        String DEPT            = info.getSession("DEPARTMENT");
        String USER_ID         = info.getSession("ID");
        String NAME_LOC        = info.getSession("NAME_LOC");
        String NAME_ENG        = info.getSession("NAME_ENG");

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		String EVAL_REFITEM = "";
        int         intGridRowData  = 0;
        try {

            setFlag(true);

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );

            String FLAG = MapUtils.getString( headerData, "FLAG",  "" );
            Logger.err.println("===FLAG==========>" + FLAG);
            
            headerData.put("PREFERRED_BIDDER", 		"PB".equals(FLAG) ? "Y" : "N");  //PB: 우선협상선정
            headerData.put("BID_STATUS", 			"PB".equals(FLAG) ? "SB" : FLAG);
            
            headerData.put("HOUSE_CODE", house_code);  
            headerData.put("ID", USER_ID);  
            headerData.put("DEPT", DEPT);  
            headerData.put("NAME_LOC", NAME_LOC);  
            headerData.put("NAME_ENG", NAME_ENG);     
            
    		sxp = new SepoaXmlParser(this, "et_setBidStatus");
    		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    		int rtn = ssm.doUpdate(headerData);  

    		sxp = new SepoaXmlParser(this, "et_setStatusPRDT");
    		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    		int rtnPRDT = ssm.doUpdate(headerData);   

            Logger.err.println("===gridData.size()==========>" + gridData.size());
            if( gridData != null && gridData.size() > 0 ) {
                int rtnBDVO = et_setBDVO(allData);
                int rtnBDVT = et_setBDVT(allData);
            }

    		sxp = new SepoaXmlParser(this, "et_setBDES");
    		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    		int rtnBDES = ssm.doUpdate(headerData); 
             
            if(FLAG.equals("NB")) {
                setMessage("유찰에 성공했습니다.");
                
                Map<String, String>param = new HashMap<String, String>();
				
				param.put("HOUSE_CODE", house_code);
				param.put("BID_NO",     headerData.get("BID_NO"));
				param.put("BID_COUNT",  headerData.get("BID_COUNT"));
				
				new SMS("NONDBJOB", info).bd7Process(ctx, param);
            } else if(FLAG.equals("SB")){ 
            	setMessage("낙찰에 성공했습니다.");
            	
            	Map<String, String>param = new HashMap<String, String>();
				
				param.put("HOUSE_CODE", house_code);
				param.put("BID_NO",     headerData.get("BID_NO"));
				param.put("BID_COUNT",  headerData.get("BID_COUNT"));
				param.put("VOTE_COUNT", headerData.get("VOTE_COUNT"));
				
				new SMS("NONDBJOB", info).bd5Process(ctx, param);
            } else {
                setMessage("확정하였습니다.");
            }
            setStatus( 1 );   
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

	public int et_setBDVO( Map< String, Object > allData ) throws Exception {

        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;

        int         rtn             = 0;
        int         intGridRowData  = 0;
        try {

            setFlag(true);

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );

            if( gridData != null && gridData.size() > 0 ) {

                intGridRowData  = gridData.size();

                for( int i = 0; i < intGridRowData; i++ ) {

                    gridRowData = gridData.get( i );
                    gridRowData.put( "HOUSE_CODE",      MapUtils.getString( headerData,"HOUSE_CODE",      "" ) );
                    gridRowData.put( "BID_NO",      		 MapUtils.getString( headerData,"BID_NO",      "" ) );
                    gridRowData.put( "BID_COUNT",      	 MapUtils.getString( headerData,"BID_COUNT",      "" ) );
                    gridRowData.put( "VOTE_COUNT",      MapUtils.getString( headerData, "VOTE_COUNT",       "" ) );

            		sxp = new SepoaXmlParser(this, "et_setBDVO");
            		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            		rtn = ssm.doUpdate(gridRowData); 
                }
  
            }
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

        return rtn;

	}

	public int et_setBDVT( Map< String, Object > allData ) throws Exception {

        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;

        int         rtn             = 0;
        int         intGridRowData  = 0;
        SepoaFormater   sf  = null;
        try {

            setFlag(true);

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );

			sxp = new SepoaXmlParser(this, "et_setBDVT_1");                     
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
			sf = new SepoaFormater (ssm.doSelect (headerData) );
			 

                for( int i = 0; i < sf.getRowCount(); i++ ) {

                    gridRowData = gridData.get( i );
                    gridRowData.put( "HOUSE_CODE",      sf.getValue("HOUSE_CODE", i) ); 
                    gridRowData.put( "BID_NO",      sf.getValue("BID_NO", i) ); 
                    gridRowData.put( "BID_COUNT",      sf.getValue("BID_COUNT", i) ); 
                    gridRowData.put( "VENDOR_CODE",      sf.getValue("VENDOR_CODE", i) ); 
                    gridRowData.put( "VOTE_COUNT",      sf.getValue("VOTE_COUNT", i) );
                    gridRowData.put( "ITEM_SEQ",      sf.getValue("ITEM_SEQ", i) ); 
                    gridRowData.put( "BID_PRICE",      sf.getValue("BID_PRICE_ENC", i) ); 

	    			sxp = new SepoaXmlParser(this, "et_setBDVT_2");                     
	    			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
	    			rtn = ssm.doUpdate(gridRowData); 
                }
   
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

        return rtn;

	}
	public SepoaOut setReBd( Map< String, Object > allData ) throws Exception {

        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 
        String DEPT            = info.getSession("DEPARTMENT");
        String USER_ID         = info.getSession("ID");
        String NAME_LOC        = info.getSession("NAME_LOC");
        String NAME_ENG        = info.getSession("NAME_ENG");

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		 
        try {

            setFlag(true);

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );

            headerData.put("HOUSE_CODE", house_code);  
            headerData.put("ID", USER_ID);  
            headerData.put("DEPT", DEPT);  
            headerData.put("NAME_LOC", NAME_LOC);  
            headerData.put("NAME_ENG", NAME_ENG);     
            headerData.put("BID_STATUS", 	"NB");
             
			sxp = new SepoaXmlParser(this, "et_setReBDPGCreate");                     
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
			int rtn = ssm.doUpdate(headerData); 
 
			sxp = new SepoaXmlParser(this, "et_setReBDSPCreate");                     
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
			int rtn5 = ssm.doUpdate(headerData); 
 
			sxp = new SepoaXmlParser(this, "et_delBDPG");                     
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
			int rtn7 = ssm.doUpdate(headerData); 
			
			sxp = new SepoaXmlParser(this, "et_delBDSP");                     
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
			int rtn8 = ssm.doUpdate(headerData); 
			
			sxp = new SepoaXmlParser(this, "et_delBDVO");                     
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
			int rtn9 = ssm.doUpdate(headerData);  
			
            int rtnBDVO = et_setBDVO(allData);
            int rtnBDVT = et_setBDVT(allData);
            
            
            Map<String, String>param = new HashMap<String, String>();
			
			param.put("HOUSE_CODE", house_code);
			param.put("BID_NO",     headerData.get("BID_NO"));
			param.put("BID_COUNT",  headerData.get("BID_COUNT"));
			
			sxp = new SepoaXmlParser(this, "et_setBDHD");                     
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
			int rtn10 = ssm.doUpdate(param);  
			
			new SMS("NONDBJOB", info).bd6Process(ctx, param);

            setStatus(1);
            setValue(rtn+"");
            setMessage("재입찰 되었습니다.");
            
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
	
    public SepoaOut setPriceScore(Map<String, Object> data)
    { 
        int rtn = -1;

        try {
            ConnectionContext ctx = getConnectionContext();

            rtn = et_setPriceScore(ctx, data);

            if( rtn == 0 )
                setStatus(0);
            else
                setStatus(1);

            setValue(String.valueOf(rtn));
            //setMessage(msg.getMessage("0000"));

            Commit();
        }catch(Exception e){
            try {
                Rollback();
                //setMessage(msg.getMessage("0004"));
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            Logger.err.println(this,e.getMessage());
            setStatus(0);
        }
        return getSepoaOut();
    }

    private int et_setPriceScore(ConnectionContext ctx, Map<String, Object> data ) throws Exception
    {
    	SepoaSQLManager sm = null;
        int rtn = 0;
        
		List<Map<String, String>> grid          = null;
		Map<String, String>       gridInfo      = null;
		Map<String, String> 	  header		= null;
		header = MapUtils.getMap(data, "headerData");    
		
		grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
		
		for(int i = 0 ; i < grid.size() ; i++){
			gridInfo = grid.get(i);
			gridInfo.put("HOUSE_CODE", HOUSE_CODE);
			gridInfo.put("VENDOR_CODE", gridInfo.get("T_VENDOR_CODE"));
			
//			System.out.println(gridInfo);

			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			sm = new SepoaSQLManager("", this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(gridInfo);
			
		}
		return rtn;
    }
    
    public SepoaOut getBdUnitDetail(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext(); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdUnitDetail");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  


            headerData.put( "HOUSE_CODE",	info.getSession("HOUSE_CODE") );  
            headerData.put( "START_CHANGE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "start_change_date",        "" ) ) ); 
            headerData.put( "END_CHANGE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "end_change_date",          "" ) ) );  
            
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
}// 
