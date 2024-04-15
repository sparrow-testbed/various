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
public class I_BD_027 extends SepoaService 
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

    public I_BD_027( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.err.println("I_BD_027: = " + e.getMessage());
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
	
	public SepoaOut getBdResultList(Map< String, String > headerData, String biz_no)
	{
        ConnectionContext ctx = getConnectionContext(); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {

			sxp = new SepoaXmlParser(this, "getBdResultList");
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
	
	/*ICT 사용(입찰결과 신규 보고서)*/
	public SepoaOut getRptBdResult(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
        	sxp = new SepoaXmlParser(this, "getRptBdResultTitle");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

        	headerData.put("house_code", house_code);  
        	
        	setValue(ssm.doSelect(headerData));
        	
        	
        	sxp = new SepoaXmlParser(this, "getRptBdResultSummary");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			setValue(ssm.doSelect(headerData)); 

			sxp = new SepoaXmlParser(this, "getRptBdResultDetail");
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
			
} 
 
 
