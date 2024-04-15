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

import java.util.StringTokenizer;
 
@SuppressWarnings( { "unchecked", "unused", "rawtypes" } )
public class I_SBD_008 extends SepoaService {

    private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession( "HOUSE_CODE" );
    private String lang         = info.getSession( "LANGUAGE" );
    //20131212 sendakun
    private HashMap msg = null;

    public I_SBD_008( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.err.println("I_SBD_008: = " + e.getMessage());
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

	public SepoaOut getBdPriceList(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 
        String company_code   = info.getSession("COMPANY_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdPriceList");
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
	
	public SepoaOut getBdJoinList(Map< String, String > headerData)
	{
		ConnectionContext ctx = getConnectionContext();
		String house_code   = info.getSession("HOUSE_CODE"); 
		String company_code   = info.getSession("COMPANY_CODE"); 
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {
			
			sxp = new SepoaXmlParser(this, "getBdJoinList");
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

	// ICT 사용
	public SepoaOut getBDHeader(Map< String, String > headerData)
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
            
    		sxp = new SepoaXmlParser(this, "getBDHeader");
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
	
	/* ICT 사용 */
	public SepoaOut setBidCancel(Map< String, Object > allData)
    {
        ConnectionContext ctx = getConnectionContext(); 
        String company_code   = info.getSession("COMPANY_CODE"); 
        String USER_ID         = info.getSession("ID");
        String NAME_LOC        = info.getSession("NAME_LOC");
        String NAME_ENG        = info.getSession("NAME_ENG");
        String DEPT            = info.getSession("DEPARTMENT");
        
        Map< String, String >   gridData  = null;

        try {
        	gridData    = ((List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null )).get(0);
            int rtn = et_setBidCancel(gridData);
            setFlag( true );
            setStatus(1);
            setValue(rtn+""); 
            setMessage("입찰이 취소되었습니다.");
            Commit();
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage("");
            setFlag( false );
        }
        return getSepoaOut();
    }
	
	/* ICT 사용 */
	private int et_setBidCancel(Map< String, String > gridData ) throws Exception{
		ConnectionContext ctx = getConnectionContext(); 
        int rtn = 0;
        String BDAP_CNT = "";
        String bdap_enable = "";
        String bdap_flag = "";

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
        	
        	gridData.put("HOUSE_CODE"	, info.getSession("HOUSE_CODE"));
        	gridData.put("VENDOR_CODE"	, info.getSession("COMPANY_CODE"));
        	
        	//sxp = new SepoaXmlParser(this, "et_setBidCancel_1");
			//ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            //rtn = ssm.doUpdate(gridData);
            
            sxp = new SepoaXmlParser(this, "et_setBidCancel_2");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            rtn = ssm.doUpdate(gridData);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
	
	public SepoaOut setBDAPjoinCancel(Map< String, String > headerData)
	{
		ConnectionContext ctx = getConnectionContext(); 
		String company_code   = info.getSession("COMPANY_CODE"); 
		String USER_ID         = info.getSession("ID");
		String NAME_LOC        = info.getSession("NAME_LOC");
		String NAME_ENG        = info.getSession("NAME_ENG");
		String DEPT            = info.getSession("DEPARTMENT");
		
		try {
			headerData.put("HOUSE_CODE", HOUSE_CODE); 
			headerData.put("COMPANY_CODE", company_code); 
			headerData.put("ID", 			USER_ID);
			headerData.put("NAME_LOC", 		NAME_LOC);
			headerData.put("NAME_ENG", 		NAME_ENG); 
			headerData.put("DEPT", 			DEPT); 
			headerData.put("ANN_NO", 		MapUtils.getString( headerData, "ann_no" )); 
			headerData.put("ANN_COUNT", 	MapUtils.getString( headerData, "ann_count" )); 
			
//			String status = et_chkJoinEndDate(headerData); // 입찰제출마감시간 체크
//			
//			if (status.equals("N")){
//				setFlag( false );
//				setStatus(0);
//				setMessage("서류제출마감 시간이 지났습니다.");
//				return getSepoaOut();
//			}
			
			String status2 = et_chkMagam(headerData); // 입찰공고마감 체크			
			if (status2.equals("Y")){
				setFlag( false );
				setStatus(0);
				setMessage("공고가 마감되어 참가신청취소가 불가합니다.");
				return getSepoaOut();
			}
			
			String status3 = et_chkBDAP2(headerData); // 최종결과 체크			
			if (status3.equals("Y")){
				setFlag( false );
				setStatus(0);
				setMessage("제출된 서류가 적합결정되어 참가신청취소가 불가합니다.");
				return getSepoaOut();
			}
			
			String status4 = et_chkBDAP2_1(headerData); // 최종결과 체크			
			if (status4.equals("Y")){
				setFlag( false );
				setStatus(0);
				setMessage("서류접수되어 참가신청취소가 불가합니다.");
				return getSepoaOut();
			}
			
						
			int rtn = et_setBdap2(headerData);
			
			setFlag( true );
			setStatus(1);
			setValue(rtn+""); 
			setMessage("참가신청취소가 되었습니다");
			
			Commit();
		} catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage("");
			setFlag( false );
		}
		return getSepoaOut();
	}
	
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
    
    private String et_chkBDAP2( Map< String, String > headerData ) throws Exception 
    {
    	ConnectionContext ctx = getConnectionContext(); 
    	
    	String rtn = null; 
    	String value = null; 
    	try { 
    		
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_chkBDAP2");
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
    
    private String et_chkBDAP2_1( Map< String, String > headerData ) throws Exception 
    {
    	ConnectionContext ctx = getConnectionContext(); 
    	
    	String rtn = null; 
    	String value = null; 
    	try { 
    		
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_chkBDAP2_1");
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
        
    private int et_setBdap2(Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext(); 
        String rtnStr = "";
        int rtn = 0;
        String BDAP_CNT = "";
        String bdap_enable = "";
        String bdap_flag = "";

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
        	
        	sxp = new SepoaXmlParser(this, "et_setBdap2");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	rtn = ssm.doUpdate(headerData); 
    
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }
	
	
	
	
	
}//  


