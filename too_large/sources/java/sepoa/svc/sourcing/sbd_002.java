/**
 *========================================================
 *Copyright(c) 2013 SEPOA SOFT
 *
 *@File     : SBD_002.java
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
 
@SuppressWarnings( { "unchecked", "unused", "rawtypes" } )
public class SBD_002 extends SepoaService {

    private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession( "HOUSE_CODE" );
    private String lang         = info.getSession( "LANGUAGE" );
    //20131212 sendakun
    private HashMap msg = null;

    public SBD_002( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.sys.println( "SBD_002 : " + e.getMessage() );
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

	public SepoaOut getBdAcceptList(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 
        String company_code   = info.getSession("COMPANY_CODE"); 
 
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdAcceptList");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

			String start_change_date 	= SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "start_change_date",        "" ) );
			String end_change_date 		= SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "end_change_date",          "" ) );

            headerData.put("HOUSE_CODE", house_code); 
            headerData.put("START_CHANGE_DATE", start_change_date); 
            headerData.put("END_CHANGE_DATE", end_change_date); 
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
	
	public SepoaOut getBdRegister(Map< String, String > headerData)
    {
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 
        String company_code   = info.getSession("COMPANY_CODE"); 
 
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
 
        String rtnData = null;
        try {
            headerData.put("HOUSE_CODE", house_code); 
            headerData.put("COMPANY_CODE", company_code); 
            
    		sxp = new SepoaXmlParser(this, "et_getVNGLinfo");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
            setValue( ssm.doSelect (headerData)); 
            setStatus(1);

    		sxp = new SepoaXmlParser(this, "et_getBDHDDisplay");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
            setValue( ssm.doSelect (headerData));  
            setStatus(1); 

    		sxp = new SepoaXmlParser(this, "et_getChkLoading");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
            setValue( ssm.doSelect (headerData));  
            setStatus(1); 

            setMessage("");
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage("");
        }
        return getSepoaOut();
    }

	public SepoaOut setBdAcceptInsert(Map< String, Object > allData)
    {
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 
        String company_code   = info.getSession("COMPANY_CODE"); 
        String USER_ID         = info.getSession("ID");
        String NAME_LOC        = info.getSession("NAME_LOC");
        String NAME_ENG        = info.getSession("NAME_ENG");
        String DEPT            = info.getSession("DEPARTMENT");

        Map< String, String >   headerData  = null;
        try {
            headerData = MapUtils.getMap( allData, "headerData" );
            headerData.put("HOUSE_CODE", house_code); 
            headerData.put("COMPANY_CODE", company_code); 
            headerData.put("ID", 			USER_ID);
            headerData.put("NAME_LOC", 		NAME_LOC);
            headerData.put("NAME_ENG", 		NAME_ENG); 
            headerData.put("DEPT", 			DEPT); 
 
            String status = et_chkAppEndDate(headerData); // 입찰등록마감시간 체크

			if (status.equals("N")){
                //setStatus(0);
               // setMessage("입찰신청마감 시간이 지났습니다.");
               // return getSepoaOut();
			}

			int rtn = et_setBidRegister(headerData);
            setStatus(1);
            setValue(rtn+"");

            setMessage("입찰 참가 신청서를 제출하셨습니다.");

            Commit();
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage("");
        }
        return getSepoaOut();
    }

    private String et_chkAppEndDate( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext(); 
        
        String rtn = null; 
        String value = null; 
        try { 
              
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_chkAppEndDate");
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
    private int et_setBidRegister( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext(); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        int rtn = 0; 
    	try { 
    		
    		 String BDAP_CNT = headerData.get("BDAP_CNT");
    		 
    		 if(BDAP_CNT.equals("0")){ 
    			 sxp = new SepoaXmlParser(this, "et_setBidRegister_insert");
    			 ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
    			 rtn = ssm.doInsert(headerData);
    		 }else{
        		 sxp = new SepoaXmlParser(this, "et_setBidRegister_update");
    			 ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
    			 rtn = ssm.doUpdate(headerData); 
    		 }
			 
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
}//  
