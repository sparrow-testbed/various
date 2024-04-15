/**
 *========================================================
 *Copyright(c) 2013 SEPOA SOFT
 *
 *@File     : BD_002.java
 *
 *@FileName : 입찰공고조회
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
/*
import sepoa.svc.common.constants ;
import sepoa.svc.datatypes.SSCGL_DataType;
import sepoa.svc.datatypes.SSCLN_DataType;
import sepoa.svc.misInterface.MisInterfaceUtil;
import Interface.webService.MMIF0200;
import Interface.webService.WS_002 ;
*/
@SuppressWarnings( { "unchecked", "unused", "rawtypes" } )
public class I_BD_002 extends SepoaService {

    private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession( "HOUSE_CODE" );
    private String lang         = info.getSession( "LANGUAGE" );
    //20131212 sendakun
    private HashMap msg = null;

    public I_BD_002( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.err.println("I_BD_002: = " + e.getMessage());
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

	/* ICT관련 추가*/
    public SepoaOut getBdAnnVersion(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
			sxp = new SepoaXmlParser(this, "getBdAnnVersion");
			sxp.addVar("HOUSE_CODE", house_code);
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery()); 
            setValue(ssm.doSelect((String[])null));
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
    public SepoaOut getBdAnnList(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 
        String company_code   = info.getSession("COMPANY_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdAnnList");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

            headerData.put("HOUSE_CODE", house_code); 
            headerData.put("START_CHANGE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "start_change_date", "" ) ) ); 
            headerData.put("END_CHANGE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "end_change_date", "" ) ) ); 
            headerData.put("ANN_NO", MapUtils.getString( headerData,  "ann_no")); 
            headerData.put("ANN_ITEM", MapUtils.getString( headerData,  "ann_item"));  
            
            //Logger.err.println("====status=="+MapUtils.getString( headerData,  "STATUS"));
            
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
            setMessage(e.getMessage());
            setStatus(0);
        }
        return getSepoaOut();
    } 
	
    /* ICT 사용 */
	public SepoaOut setBdDelete(  List< Map< String, String > > gridData ) throws Exception {

        SepoaOut    so  = null;
        int rtn = 0;
        int	intGridRowData  = 0;

        Map< String, String >   gridRowData = null;
        try { 

            for( int i = 0; i < gridData.size(); i++ ) {

                gridRowData = gridData.get( i );

                gridRowData.put( "HOUSE_CODE",	info.getSession("HOUSE_CODE") ); 
                gridRowData.put( "COMPANY_CODE",	info.getSession("COMPANY_CODE") ); 
                 
                String bid_count = MapUtils.getString( gridRowData, "BID_COUNT",       "" );

                //Logger.err.println("==bid_count=="+bid_count);
                
                //if(bid_count.equals("1")){
                //		//rtn = et_setPRDT_1(gridRowData);
                //}else{
                //		//rtn = et_setPRDT(gridRowData);
                //}
       
                rtn = et_setBidDelete(gridRowData);
                
                // 결재정보 삭제(결재중,결재완료라도 확정이 되기전에 삭제가 가능하므로.)
                //rtn = et_setApprovalDelete(gridRowData);

            }

            setFlag( true );
            setStatus( 1 );
            setValue(String.valueOf(rtn)); 
            setMessage("삭제되었습니다.");
            Commit();	
           
        }catch (Exception e){
            Rollback();
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage(e.getMessage());
            setStatus(0);
        }
        return getSepoaOut();
    }    

    private int et_setPRDT_1(Map< String, String > headerData ) throws Exception  
	{
        ConnectionContext ctx = getConnectionContext(); 
        
        int rtn = 0;
        int	intGridRowData  = 0;
    	try { 
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setPRDT_1");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 
        	rtn = ssm.doUpdate(headerData); 
    		
   		} catch(Exception e) {
            setMessage(e.getMessage());
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		} 
   		return rtn; 
	}

    private int et_setPRDT(Map< String, String > headerData ) throws Exception  
    {
    	ConnectionContext ctx = getConnectionContext(); 
        
        int rtn = 0; 
    	try { 
    			SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setPRDT");
    			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 
        		rtn = ssm.doUpdate(headerData); 
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		} 
   		return rtn; 
    }

    /* ICT 사용 */
    private int et_setBidDelete( Map< String, String > headerData ) throws Exception  
    {
        ConnectionContext ctx = getConnectionContext(); 
        
        int rtn = 0; 
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
    	try { 

	    		sxp = new SepoaXmlParser(this, "et_setBidDelete_1");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
	    		rtn = ssm.doUpdate(headerData);	
	
	    		sxp = new SepoaXmlParser(this, "et_setBidDelete_2");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
	    		rtn = ssm.doUpdate(headerData);	
	
	    		sxp = new SepoaXmlParser(this, "et_setBidDelete_3");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
	    		rtn = ssm.doUpdate(headerData);	
	
	    		sxp = new SepoaXmlParser(this, "et_setBidDelete_4");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
	    		rtn = ssm.doUpdate(headerData);	 
	    		
	    		sxp = new SepoaXmlParser(this, "et_setBidDelete_5");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
	    		rtn = ssm.doUpdate(headerData);	 
    		
	    		sxp = new SepoaXmlParser(this, "et_setBidDelete_6");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
	    		rtn = ssm.doUpdate(headerData);	 
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }

    private int et_setApprovalDelete( Map< String, String > headerData ) throws Exception  
    {
        ConnectionContext ctx = getConnectionContext(); 
        
        int rtn = 0; 
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
    	try { 

	    		sxp = new SepoaXmlParser(this, "et_setApprovalDelete_1");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
	    		rtn = ssm.doUpdate(headerData);	
	
	    		sxp = new SepoaXmlParser(this, "et_setApprovalDelete_2");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
	    		rtn = ssm.doUpdate(headerData);	 
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    
    
    public SepoaOut getLocList(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   	= info.getSession("HOUSE_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getLocList");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			headerData.put("house_code"	, house_code);
			headerData.put("type"		, "M912");
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
    
    public SepoaOut getPrgBidCount(Map<String, Object> data) throws Exception{

  		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		int rtn=0;
		try {
			
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			
			String HOUSE_CODE 	    = info.getSession("HOUSE_CODE"); 
			String BID_NO           = header.get("BID_NO");  
			
			int cnt = 0;
			//순번가져오기
			Map map = new HashMap();
			map.put("HOUSE_CODE"    , HOUSE_CODE); 
			map.put("BID_NO"		, BID_NO); 
			sxp = new SepoaXmlParser(this, "getPrgBidCount");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			SepoaFormater wf = new SepoaFormater(ssm.doSelect(map));
			cnt = Integer.parseInt(wf.getValue("CNT", 0));

			if(cnt != 0){
				throw new Exception("진행할수 없는 공고건입니다.");
			}
			
			setValue(cnt+"");
			
			
		} catch (Exception e) {
//			e.printStackTrace();
			setValue("-1");
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		} finally {
		}

		return getSepoaOut();
  	}
    
    /**
	 * 공문 담당자 변경
	 * @param Transfer_person_id
	 * @param inv_no
	 * @return
	 */
	public SepoaOut charge_transfer( Map< String, String > headerData , List< Map< String, String > > gridData )  throws Exception{
		SepoaOut    so  = null;
        int rtn = 0;
        int	intGridRowData  = 0;

        Map< String, String >   gridRowData = null;
        try { 

            for( int i = 0; i < gridData.size(); i++ ) {

                gridRowData = gridData.get( i );
                gridRowData.put("DOC_TYPE",	"BID_ICT");                  
                gridRowData.put("Transfer_person_id"    , MapUtils.getString( headerData,  "Transfer_person_id")); 
				gridRowData.put("Transfer_person_name"    , MapUtils.getString( headerData,  "Transfer_person_name")); 
                
//              String bid_count = MapUtils.getString( gridRowData, "BID_COUNT",       "" );

                rtn = et_charge_transfer(gridRowData);                                
            }

            setFlag( true );
            setStatus( 1 );
            setValue(String.valueOf(rtn)); 
            setMessage("공문 담당자 변경 되었습니다.");
            Commit();	
           
        }catch (Exception e){
        	Rollback();
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage(e.getMessage());
            setStatus(0);
        }
        return getSepoaOut();		
	}
	
	private int et_charge_transfer( Map< String, String > gridRowData ) throws Exception  
	{
	    ConnectionContext ctx = getConnectionContext(); 
	     
	    int rtn = 0; 
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
	 	try { 
	 			sxp = new SepoaXmlParser(this, "et_charge_transfer");
	 			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
	 			rtn = ssm.doUpdate(gridRowData);	
	    		
	    		sxp = new SepoaXmlParser(this, "et_charge_transfer_1");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
	    		rtn = ssm.doUpdate(gridRowData);	
		
	    		sxp = new SepoaXmlParser(this, "et_charge_transfer_2");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
	    		rtn = ssm.doUpdate(gridRowData);	
		
	    		sxp = new SepoaXmlParser(this, "et_charge_transfer_3");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
	    		rtn = ssm.doUpdate(gridRowData);				
	 		
	 	} catch(Exception e) {
	 		Logger.err.println(userid,this,e.getMessage());
	 		throw new Exception(e.getMessage());
	 	}
	 	return rtn;
	}

}// 
