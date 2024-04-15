/**
 *========================================================
 *Copyright(c) 2013 SEPOA SOFT
 *
 *@File     : BD_009.java
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
public class BD_009 extends SepoaService {

    private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession( "HOUSE_CODE" );
    private String lang         = info.getSession( "LANGUAGE" );
    //20131212 sendakun
    private HashMap msg = null;

    public BD_009( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.sys.println( "BD_009 : " + e.getMessage() );
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
  
	public SepoaOut getBdEstimatePopupList(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 
        String company_code   = info.getSession("COMPANY_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdEstimatePopupList");
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
	
    public SepoaOut setBdStatus( Map< String, Object > allData ) throws Exception {

        SepoaOut    so  = null;
        int rtn = 0;
        int	intGridRowData  = 0;

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
            headerData.put( "BID_NO",		MapUtils.getString( headerData,  "BID_NO") ); 
            headerData.put( "BID_COUNT",	MapUtils.getString( headerData,  "BID_COUNT") ); 
             
            String status = et_chkMagam(headerData);

            if (!status.equals("BT")){
                setStatus(0);
                setMessage("입찰마감이나 유찰하실 수 없는 상태입니다.");   // 입찰마감이나 유찰하실 수 없는 상태입니다.
                return getSepoaOut();
            }
            int rtnBDAP = 0;
			//int rtn = et_setBidStatus(ctx, recvData);
 
            if( gridData != null && gridData.size() > 0 ) {// 참가신청 업체가 0일수도 있음으로...
			    rtnBDAP = et_setBDAP(allData);
            }
 
            String BID_STATUS = MapUtils.getString( headerData, "BID_STATUS" );
            if(BID_STATUS.equals("NB")) {
                setMessage("유찰에 성공했습니다.");
            } else {
                setMessage("성공적으로 작업을 수행했습니다.");
            }
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

    private String et_chkMagam(Map< String, String > headerData ) throws Exception  
	{
        ConnectionContext ctx = getConnectionContext(); 
        
        String rtn = null;
        int	intGridRowData  = 0;
    	try { 
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_chkMagam");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 
            SepoaFormater wf = new SepoaFormater(ssm.doSelect(headerData));
            rtn =  wf.getValue(0,0);
          
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

                    gridRowData.put("HOUSE_CODE",  MapUtils.getString( headerData, "HOUSE_CODE"));
                    gridRowData.put("BID_NO",  MapUtils.getString( headerData, "BID_NO"));
                    gridRowData.put("BID_COUNT",  MapUtils.getString( headerData, "BID_COUNT")); 
                    rtn = ssm.doInsert(gridRowData);
                }
            }
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }

    public SepoaOut setSpecEstimate( Map< String, Object > allData ) throws Exception {

        SepoaOut    so  = null; 
        int	intGridRowData  = 0;

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
        
        String SEL_YN = "";
        String bdap_ins_ck = "";
        int sel_yn_count = 0;
        
        String HOUSE_CODE   	= info.getSession("HOUSE_CODE"); 
        String DEPT            	= info.getSession("DEPARTMENT");
        String ID         			= info.getSession("ID");
        String NAME_LOC        = info.getSession("NAME_LOC");
        String NAME_ENG        = info.getSession("NAME_ENG");
        try {

            setFlag( true );
            setStatus( 1 );

            headerData  = MapUtils.getMap( allData, "headerData" ); 
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );

            headerData.put( "HOUSE_CODE",	info.getSession("HOUSE_CODE") ); 
            headerData.put("ID", ID);
            headerData.put("NAME_LOC", NAME_LOC);
            headerData.put("NAME_ENG", NAME_ENG); 
            headerData.put("DEPT", DEPT); 
            
       		int rtnBDPG = et_setBDPG(allData);
 
			int rtn = et_setBdStatus(allData);

            if( gridData != null && gridData.size() > 0 ) {

                intGridRowData  = gridData.size(); 
                // 그리드의 데이터 만큼 돌린다.
                for( int i = 0; i < intGridRowData; i++ ) {

                    gridRowData = gridData.get( i );

                    SEL_YN =  MapUtils.getString( gridRowData, "SEL_YN", "");
                    
                    if(SEL_YN.equals("Y")){
                    	sel_yn_count++;
                    }
                }
            }
            
            if(sel_yn_count > 0){
                bdap_ins_ck = "Y";
            }
            
            if(bdap_ins_ck.equals("Y")){
 
                int rtnBDAP = et_setInsertBDAP(allData);
            }
 
            int rtnBDSP = et_setInsertBDSP(allData);
 
           // int rtnPRDT = et_setUpdPRLN(allData);  필요한지 확인?

            setFlag( true );
            setStatus(1);
            setValue("");
            Commit();	
           
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("성공적으로 처리되었습니다.");
            setFlag( false );
            setStatus(0);
        }
        return getSepoaOut();
    }    

    private int et_setBDPG( Map< String, Object > allData ) throws Exception 
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
            
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setBDPG");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

			rtn = ssm.doInsert(headerData);
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private int et_setBdStatus( Map< String, Object > allData ) throws Exception 
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
            
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setBdStatus");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

			rtn = ssm.doInsert(headerData);
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private int et_setInsertBDAP( Map< String, Object > allData ) throws Exception 
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
            
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setInsertBDAP");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

            if( gridData != null && gridData.size() > 0 ) {

                intGridRowData  = gridData.size(); 
                // 그리드의 데이터 만큼 돌린다.
                for( int i = 0; i < intGridRowData; i++ ) {

                    gridRowData = gridData.get( i );

                    gridRowData.put("HOUSE_CODE",  MapUtils.getString( headerData, "HOUSE_CODE"));
                    gridRowData.put("BID_NO",  MapUtils.getString( headerData, "BID_NO"));
                    gridRowData.put("BID_COUNT",  MapUtils.getString( headerData, "BID_COUNT")); 
                    rtn = ssm.doInsert(gridRowData);
                }
            }
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private int et_setInsertBDSP( Map< String, Object > allData ) throws Exception 
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
            
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setInsertBDSP");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

            if( gridData != null && gridData.size() > 0 ) {

                intGridRowData  = gridData.size(); 
                // 그리드의 데이터 만큼 돌린다.
                for( int i = 0; i < intGridRowData; i++ ) {

                    gridRowData = gridData.get( i );

                    gridRowData.put("HOUSE_CODE",  MapUtils.getString( headerData, "HOUSE_CODE"));
                    gridRowData.put("BID_NO",  MapUtils.getString( headerData, "BID_NO"));
                    gridRowData.put("BID_COUNT",  MapUtils.getString( headerData, "BID_COUNT")); 
                    gridRowData.put("VOTE_COUNT",  MapUtils.getString( headerData, "VOTE_COUNT")); 
                    rtn = ssm.doInsert(gridRowData);
                }
            }
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private int et_setUpdPRLN( Map< String, Object > allData ) throws Exception 
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
            
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setUpdPRLN");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

			rtn = ssm.doInsert(headerData);
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
}// 
