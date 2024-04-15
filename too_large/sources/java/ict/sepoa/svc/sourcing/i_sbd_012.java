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
public class I_SBD_012 extends SepoaService {

    private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession( "HOUSE_CODE" );
    private String lang         = info.getSession( "LANGUAGE" );
    //20131212 sendakun
    private HashMap msg = null;

    public I_SBD_012( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.err.println("I_SBD_011: = " + e.getMessage());
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
	
	public SepoaOut getBdCt2SubmitList(Map< String, String > headerData)
	{
		ConnectionContext ctx = getConnectionContext();
		String house_code   = info.getSession("HOUSE_CODE"); 
		String company_code   = info.getSession("COMPANY_CODE"); 
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {
			
			sxp = new SepoaXmlParser(this, "getBdCt2SubmitList");
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
            
            String VOTE_COUNT = headerData.get("VOTE_COUNT");
            if(VOTE_COUNT != null && !"".equals(VOTE_COUNT) && !"1".equals(VOTE_COUNT)) {
    			sxp = new SepoaXmlParser(this, "et_chkVendor");
    			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
                setValue(ssm.doSelect(headerData));
            }
            setMessage("");
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage("");
        }
        return getSepoaOut();
    }
	
	public SepoaOut getBDHD_VnInfo(Map< String, String > headerData)
    {
        ConnectionContext ctx = getConnectionContext(); 
        String company_code   = info.getSession("COMPANY_CODE"); 
 
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
 
        String rtnData = null;
        try {
            headerData.put("HOUSE_CODE", HOUSE_CODE); 
            headerData.put("COMPANY_CODE", company_code); 
            
    		sxp = new SepoaXmlParser(this, "getBDHD_VnInfo");
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
	
	public SepoaOut setBDCt2Submit(Map< String, String > headerData)
	{
		ConnectionContext ctx = getConnectionContext(); 
		String company_code   = info.getSession("COMPANY_CODE"); 
		String USER_ID         = info.getSession("ID");
		String NAME_LOC        = info.getSession("NAME_LOC");
		String NAME_ENG        = info.getSession("NAME_ENG");
		String DEPT            = info.getSession("DEPARTMENT");
		int rtn = 0;
		
		
		try {
			headerData.put("HOUSE_CODE", HOUSE_CODE); 
			headerData.put("COMPANY_CODE", company_code); 
			headerData.put("ID", 			USER_ID);
			headerData.put("NAME_LOC", 		NAME_LOC);
			headerData.put("NAME_ENG", 		NAME_ENG); 
			headerData.put("DEPT", 			DEPT); 
			headerData.put("BID_NO", 		MapUtils.getString( headerData, "bid_no" )); 
			headerData.put("BID_COUNT", 	MapUtils.getString( headerData, "bid_count" )); 
			
			String status = et_chkConfirm(headerData); // 확정여부 체크
			
			if ("Y".equals(status)){
				setFlag( false );
				setStatus(0);
				setMessage("계약서류 적합이되어 다시 제출불가합니다.");
				return getSepoaOut();
			}
			
			headerData.put("ATTACH_NO", 	MapUtils.getString( headerData, "attach_no" )); 
			rtn = et_setBdCt2Submit(headerData);
			
			
			setFlag( true );
			setStatus(1);
			setValue(rtn+""); 
			setMessage("계약서류가 제출되었습니다");
			
			Commit();
		} catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage("");
			setFlag( false );
		}
		return getSepoaOut();
	}
	
	private String et_chkConfirm( Map< String, String > headerData ) throws Exception 
    {
		ConnectionContext ctx = getConnectionContext(); 
    	
    	String rtn = null; 
    	String value = null; 
    	try { 
    		
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_chkConfirm");
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
	
	private int et_setBdCt2Submit(Map< String, String > headerData ) throws Exception 
    {
		ConnectionContext ctx = getConnectionContext(); 
    	int rtn = 0;
    	
    	SepoaXmlParser sxp = null;
    	SepoaSQLManager ssm = null;
    	try {
    		
    		sxp = new SepoaXmlParser(this, "et_delBdCt2Submit");
    		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    		rtn = ssm.doInsert(headerData); 
    		
    		sxp = new SepoaXmlParser(this, "et_setBdCt2Submit");
    		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    		rtn = ssm.doInsert(headerData); 
    		
    	}catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
    	}finally {
    	}
    	return rtn;
    }
	
	public SepoaOut setBDCt2SubmitCancel(Map< String, String > headerData)
	{
		ConnectionContext ctx = getConnectionContext(); 
		String company_code   = info.getSession("COMPANY_CODE"); 
		String USER_ID         = info.getSession("ID");
		String NAME_LOC        = info.getSession("NAME_LOC");
		String NAME_ENG        = info.getSession("NAME_ENG");
		String DEPT            = info.getSession("DEPARTMENT");
		int rtn = 0;
		
		
		try {
			headerData.put("HOUSE_CODE", HOUSE_CODE); 
			headerData.put("COMPANY_CODE", company_code); 
			headerData.put("ID", 			USER_ID);
			headerData.put("NAME_LOC", 		NAME_LOC);
			headerData.put("NAME_ENG", 		NAME_ENG); 
			headerData.put("DEPT", 			DEPT); 
			headerData.put("BID_NO", 		MapUtils.getString( headerData, "bid_no" )); 
			headerData.put("BID_COUNT", 	MapUtils.getString( headerData, "bid_count" )); 
			
			String status = et_chkConfirm(headerData); // 확정여부 체크
			
			if ("Y".equals(status)){
				setFlag( false );
				setStatus(0);
				setMessage("계약서류 적합이되어 취소 불가합니다.");
				return getSepoaOut();
			}
			
			headerData.put("ATTACH_NO", 	MapUtils.getString( headerData, "attach_no" )); 
			rtn = et_setBDCt2SubmitCancel(headerData);
			
			
			setFlag( true );
			setStatus(1);
			setValue(rtn+""); 
			setMessage("계약서 업로드 취소되었습니다.");
			
			Commit();
		} catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage("");
			setFlag( false );
		}
		return getSepoaOut();
	}
	
	private int et_setBDCt2SubmitCancel(Map< String, String > headerData ) throws Exception 
    {
    	ConnectionContext ctx = getConnectionContext(); 
    	int rtn = 0;
    	
    	SepoaXmlParser sxp = null;
    	SepoaSQLManager ssm = null;
    	try {
    		
    		sxp = new SepoaXmlParser(this, "et_delBdCt2Submit");
    		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    		rtn = ssm.doInsert(headerData); 
    		
    		
    	}catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
    	}finally {
    	}
    	return rtn;
    }
}//  


