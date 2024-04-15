/**
 *========================================================
 *Copyright(c) 2013 SEPOA SOFT
 *
 *@File     : BD_003.java
 *
 *@FileName : 설명회결과등록 조회 페이지
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
/*
import sepoa.svc.common.constants ;
import sepoa.svc.datatypes.SSCGL_DataType;
import sepoa.svc.datatypes.SSCLN_DataType;
import sepoa.svc.misInterface.MisInterfaceUtil;
import Interface.webService.MMIF0200;
import Interface.webService.WS_002 ;
*/
@SuppressWarnings( { "unchecked", "unused", "rawtypes" } )
public class BD_003 extends SepoaService {

    private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession( "HOUSE_CODE" );
    private String lang         = info.getSession( "LANGUAGE" );
    //20131212 sendakun
    private HashMap msg = null;

    public BD_003( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.sys.println( "BD_003 : " + e.getMessage() );
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

   

	/*
	 * 품목승인 조회
	 */
	public SepoaOut getItemConfirmList(Map< String, String > headerData)
	{
        try {
            String rtn = "";
            //Query 수행부분 Call
            rtn = et_getItemConfirmList(headerData);
            msg.put("JOB","조회");
            setMessage("");
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


    private String et_getItemConfirmList(Map< String, String > headerData) throws Exception
    {
        String rtn = "";
        String house_code   = info.getSession("HOUSE_CODE");
        String company_code = info.getSession("COMPANY_CODE");
        
        ConnectionContext ctx = getConnectionContext();

        try 
        {
        	//StringBuffer sql = new StringBuffer();            
            SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            //sxp.addVar("HOUSE_CODE", house_code);
            
            
            
            
            headerData.put("HOUSE_CODE", house_code);
            headerData.put("sel_proceeding_type", "P");
          
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, sxp.getQuery());
            Logger.err.println(info.getSession("ID"),this, sxp.getQuery());
            
            rtn = sm.doSelect(headerData);

            if(rtn == null) throw new Exception("SQL Manager is Null");
            
        }catch(Exception e) {
            throw new Exception("et_getItemConfirmList ==========================================>"+e.getMessage());
        } finally{
        }
        return rtn;
    }

	public SepoaOut getBdExpList(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE");
        
        String addSql = "";

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdExpList");
			
			if(!"".equals(headerData.get("STATUS"))){
				addSql += "   AND   (CASE (SELECT COUNT(VENDOR_CODE) 		\n";                                                                                                      
                addSql += "   FROM ICOYBDCR                          		\n";                                                                                        
                addSql += "   WHERE HOUSE_CODE = '"+house_code+"'	 		\n";                                                                  
                addSql += "     AND HOUSE_CODE = BDHD.HOUSE_CODE     		\n";                                                                                        
                addSql += "     AND BID_NO = BDHD.BID_NO             		\n";                                                                                        
                addSql += "     AND BID_COUNT = BDHD.BID_COUNT)      		\n";                                                                                        
                addSql += "     WHEN 0 THEN 'N'                      		\n";                                                                                              
                addSql += "     ELSE 'Y'                             		\n";                                                                                              
                addSql += "     END)   =  '"+headerData.get("STATUS")+"'	\n";
			}
			sxp.addVar("addSql", addSql);
			
			
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

            headerData.put("house_code", house_code); 
            headerData.put("START_ANNOUNCE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "START_ANNOUNCE_DATE",        "" ) ) ); 
            headerData.put("END_ANNOUNCE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "END_ANNOUNCE_DATE",          "" ) ) );
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
 
}// BD_003() end
