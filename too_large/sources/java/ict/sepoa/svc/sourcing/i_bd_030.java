/**
 *========================================================
 *Copyright(c) 2013 SEPOA SOFT
 *
 *@File     : SBD_003.java
 *
 *@FileName : 업체 > 입찰공고조회
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
 
@SuppressWarnings( { "unchecked", "unused", "rawtypes" } )
public class I_BD_030 extends SepoaService {

    private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession( "HOUSE_CODE" );
    private String lang         = info.getSession( "LANGUAGE" );
    //20131212 sendakun
    private HashMap msg = null;

    public I_BD_030( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.err.println("I_BD_025: = " + e.getMessage());
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
	
	public SepoaOut getBdPyConfirmList(Map< String, String > headerData)
	{
		ConnectionContext ctx = getConnectionContext();
		String house_code   = info.getSession("HOUSE_CODE"); 
		String company_code   = info.getSession("COMPANY_CODE"); 
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {
			
			sxp = new SepoaXmlParser(this, "getBdPyConfirmList");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			
			headerData.put("HOUSE_CODE", house_code); 
			headerData.put("START_CHANGE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "start_change_date",        "" ) ) ); 
			headerData.put("END_CHANGE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "end_change_date",          "" ) ) ); 
			headerData.put("ANN_NO", MapUtils.getString( headerData,  "ann_no")); 
			headerData.put("ANN_ITEM", MapUtils.getString( headerData,  "ann_item")); 
			headerData.put("COMPANY_CODE", company_code); 
			
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
	
	/* ICT 사용 : 적격업체 저장 */
	public SepoaOut setBdPyConfirm( Map< String, Object > allData ) throws Exception {

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
            headerData.put( "ID", 			info.getSession("ID"));
//			headerData.put( "BID_NO",		MapUtils.getString( headerData,  "BID_NO") ); 
//          headerData.put( "BID_COUNT",	MapUtils.getString( headerData,  "BID_COUNT") );
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
                     
            int rtnBDAP = 0;
			//int rtn = et_setBidStatus(ctx, recvData);

            //Logger.err.println("==gridData.size()==="+gridData.size());
            if( gridData != null && gridData.size() > 0 ) {// 참가신청 업체가 0일수도 있음으로...
			    rtnBDAP = et_setBdPy(allData);
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
	
	private int et_setBdPy( Map< String, Object > allData ) throws Exception 
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
            
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setBdPy");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

            if( gridData != null && gridData.size() > 0 ) {

                intGridRowData  = gridData.size(); 
                // 그리드의 데이터 만큼 돌린다.
                for( int i = 0; i < intGridRowData; i++ ) {
                    gridRowData = gridData.get( i );
                    
                    String confirm_flag = gridRowData.get("CONFIRM_FLAG");
                    //적합인 경우 사유컬럼 지운다
                    if( "Y".equals(confirm_flag)){
                    	gridRowData.put("NFIT_RSN", "");
                    }

                    gridRowData.put("HOUSE_CODE",  MapUtils.getString( headerData, "HOUSE_CODE"));
                    gridRowData.put("COMPANY_CODE",  MapUtils.getString( headerData, "COMPANY_CODE"));
                    gridRowData.put("ID",  MapUtils.getString( headerData, "ID"));                                    
//                	gridRowData.put("BID_NO",  MapUtils.getString( headerData, "BID_NO"));
//                	gridRowData.put("BID_COUNT",  MapUtils.getString( headerData, "BID_COUNT")); 
//                	gridRowData.put("VENDOR_CODE",  MapUtils.getString( headerData, "VENDOR_CODE")); 
                	rtn = ssm.doUpdate(gridRowData);                                            
                }
            }
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
}//  


