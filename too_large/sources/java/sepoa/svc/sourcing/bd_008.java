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
public class BD_008 extends SepoaService {

    private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession( "HOUSE_CODE" );
    private String lang         = info.getSession( "LANGUAGE" );
    //20131212 sendakun
    private HashMap msg = null;

    public BD_008( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.sys.println( "BD_008 : " + e.getMessage() );
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
  
	public SepoaOut getBdEstimateList(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext(); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdEstimateList");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  

            headerData.put( "HOUSE_CODE",	info.getSession("HOUSE_CODE") ); 
            headerData.put( "COMPANY_CODE",	info.getSession("COMPANY_CODE") ); 
            headerData.put( "START_CHANGE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "start_change_date",        "" ) ) ); 
            headerData.put( "END_CHANGE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "end_change_date",          "" ) ) ); 
            headerData.put( "BID_NO",		MapUtils.getString( headerData,  "bid_no") ); 
            headerData.put( "BID_COUNT",	MapUtils.getString( headerData,  "bid_count") ); 
            headerData.put( "ANN_NO",	MapUtils.getString( headerData,  "ann_no") ); 
            headerData.put( "ANN_ITEM",	MapUtils.getString( headerData,  "ann_item") ); 
            
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
