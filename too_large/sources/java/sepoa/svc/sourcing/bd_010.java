/**
 *========================================================
 *Copyright(c) 2013 SEPOA SOFT
 *
 *@File     : BD_001.java
 *
 *@FileName : 입찰공고생성
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
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.DBUtil ;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate ;
import sepoa.fw.util.SepoaFormater ;
import sepoa.fw.util.SepoaString ;   
import ucMessage.UcMessage;

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
public class BD_010 extends SepoaService {

    private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession( "HOUSE_CODE" );
    private String lang         = info.getSession( "LANGUAGE" );
    //20131212 sendakun
    private HashMap msg = null;

    public BD_010( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.sys.println( "BD_010 : " + e.getMessage() );
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


	public SepoaOut getBdReqPrepareList(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdReqPrepareList");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 


            headerData.put("HOUSE_CODE", house_code); 
            headerData.put("START_CHANGE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "start_change_date",        "" ) ) ); 
            headerData.put("END_CHANGE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "end_change_date",          "" ) ) ); 
            
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

	public SepoaOut getBdReqPrepareHeader(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

            headerData.put("HOUSE_CODE", house_code);  
			sxp = new SepoaXmlParser(this, "getBdReqPrepareHeader_BDHD");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
            setValue(ssm.doSelect(headerData));
            
			sxp = new SepoaXmlParser(this, "getBdReqPrepareHeader_BDSE");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
            setValue(ssm.doSelect(headerData));
            
			sxp = new SepoaXmlParser(this, "getBdReqPrepareHeader_BDDT");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
            setValue(ssm.doSelect(headerData));
            
			sxp = new SepoaXmlParser(this, "getBdReqPrepareHeader_BDVO");
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

	public SepoaOut getBdReqPrepareInsert(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdReqPrepareInsert");
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
 
    public SepoaOut setReqPrepare( Map< String, Object > allData ) throws Exception {

        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 
        String DEPT            = info.getSession("DEPARTMENT");
        String USER_ID         = info.getSession("ID");
        String NAME_LOC        = info.getSession("NAME_LOC");
        String NAME_ENG        = info.getSession("NAME_ENG");

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        SepoaOut    so  = null;

        Map< String, String >           headerData  = null;
        List< Map< String, String > >   gridData    = null;
        try {

            setFlag( true );
            setStatus( 1 );

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );

    		String pflag = MapUtils.getString( headerData, "approval_str");
    		
			sxp = new SepoaXmlParser(this, "et_getBDES_Basic");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            headerData.put("HOUSE_CODE", house_code);  
            headerData.put("DEPT", DEPT);  
            headerData.put("NAME_LOC", NAME_LOC);  
            headerData.put("NAME_ENG", NAME_ENG);   
            headerData.put("FLAG", pflag); 
              
    		SepoaFormater wf = new SepoaFormater(ssm.doSelect(headerData));
    		String BDES_CK = wf.getValue(0,0);

    		int rtn = -1;
  
    		if(BDES_CK.equals("0")){
    			sxp = new SepoaXmlParser(this, "et_setBDES_Basic_Ins");
    			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
    			ssm.doInsert(headerData);
    		}else{
    			sxp = new SepoaXmlParser(this, "et_setBDES_Basic_Upd");
    			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
    			ssm.doUpdate(headerData);
    		}

			sxp = new SepoaXmlParser(this, "et_DelBDEB");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
			ssm.doDelete(headerData);

            String wf_ck = "NO";
            if(gridData.size()>0){
                wf_ck = "YES";
            }
            
    		if(wf_ck.equals("YES")){
    			//rtn = et_InsBDEB(ctx, setBDEB);
    		}

    		
    		if(pflag.equals("P")) {
                setMessage("임시저장 되었습니다.");
            } else   {
                setMessage("등록요청 되었습니다.");
                
                //R102006115128 - [서비스개발] (변원상) 전자구매시스템 결재알림 시스템 개선
        		String ucline = CommonUtil.getConfig("sepoa.ucmessage.line");
        		StringBuffer  sbMsg        = new StringBuffer();
        		sbMsg.append("시 스 템  : 전자구매");
        		sbMsg.append(ucline);						
        		sbMsg.append("거래경로 : 구매관리 ▶▶ 입찰관리 ▶▶  내정가격 ▶▶ 내정가격등록");
        		sbMsg.append(ucline);						
        		sbMsg.append("공고번호 : ");
        		sbMsg.append(MapUtils.getString( headerData, "BID_NO"));
        		sbMsg.append(ucline);						
        		sbMsg.append("입 찰 명  : ");				
        		sbMsg.append(MapUtils.getString( headerData, "ANN_ITEM"));	
        		sbMsg.append(ucline);						
        		sbMsg.append(ucline);
        		sbMsg.append("내정가격 등록바랍니다.");	
				UcMessage.DirectSendMessage(info.getSession("ID"), MapUtils.getString( headerData, "ESTM_USER_ID"), sbMsg.toString());
        		//////////////////////////////////////////////////////////////////////////////////////////                          
            }  
    		setStatus(1); 
            Commit();	
           
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    }   
    
    public SepoaOut setBdEsCancel(Map<String, String> grid) throws Exception  {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		try {
			grid.put("HOUSE_CODE", info.getSession("HOUSE_CODE"));
			
			sxp = new SepoaXmlParser(this, "sel_chk_bdhd_bdes");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			String value1 = ssm.doSelect(grid);
            SepoaFormater wf1 = new SepoaFormater(value1);
            String A_COST_STATUS = wf1.getValue(0,0);
            String A_STATUS = wf1.getValue(0,1);
            String B_REQ_YN = wf1.getValue(0,2);
            String B_STATUS = wf1.getValue(0,3);
            if( A_STATUS.equals("NULL") || A_STATUS.equals("D") ||
                B_REQ_YN.equals("NULL") || 
                B_STATUS.equals("NULL") || B_STATUS.equals("D") ){
	            throw new Exception("회수불가 상태입니다.1");
	        }
			
            if( B_REQ_YN.equals("N") ){
	            throw new Exception("회수불가 상태입니다.2");
	        }                  
           
			sxp = new SepoaXmlParser(this, "sel_chk_dttm");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			String value2 = ssm.doSelect(grid);
            SepoaFormater wf2 = new SepoaFormater(value2);
            String dttm = wf2.getValue(0,0);
            if( Long.parseLong(dttm) <= 0 ){
	            throw new Exception("입찰시작시간이 지나서 내정가 회수가 불가합니다.");
	        }
                        
			int rtn1 = in_can_ICOYBDES_H(grid);
			int rtn2 = upd_can_BDES(grid);
			int rtn3 = upd_can_BDHD(grid);
			if(rtn1<= 0 ||rtn2 <= 0 ||rtn3 <= 0 ){
//				Rollback();
//             setStatus(0);
//             setMessage("회수처리 실패하였습니다.");
//             return getSepoaOut();
                
                throw new Exception("회수처리 실패하였습니다.");	    		
			}

        	setMessage("내정가 회수처리가 완료 되었습니다.");
        	
		    Commit();
			setStatus(1);
            setValue("");
		}catch (Exception e){
			try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            setValue(e.getMessage().trim());
            setMessage(e.getMessage().trim());
            setStatus(0);            
            setFlag(false);
	        
		}

		return getSepoaOut();
	}
    
    private int in_can_ICOYBDES_H(Map<String, String> grid) throws Exception  {
 		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
 		int rtn=-1;
 		try{
 			//대상건 변경처리를 한다. 			
			sxp = new SepoaXmlParser(this, "in_can_ICOYBDES_H");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	rtn=ssm.doUpdate(grid);
 			
	 	}catch(Exception e) {
	    	throw new Exception("in_can_ICOYBDES_H:"+e.getMessage());
	    }
 		return rtn;
 	}
    
    private int upd_can_BDES(Map<String, String> grid) throws Exception  {
 		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
 		int rtn=-1;
 		try{
 			//대상건 삭제처리를 한다. 			
			sxp = new SepoaXmlParser(this, "upd_can_BDES");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	rtn=ssm.doUpdate(grid);
 			
	 	}catch(Exception e) {
	    	throw new Exception("upd_can_BDES:"+e.getMessage());
	    }
 		return rtn;
 	}
    
    private int upd_can_BDHD(Map<String, String> grid) throws Exception  {
 		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
 		int rtn=-1;
 		try{
 			//대상건 삭제처리를 한다. 			
			sxp = new SepoaXmlParser(this, "upd_can_BDHD");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	rtn=ssm.doUpdate(grid);
 			
	 	}catch(Exception e) {
	    	throw new Exception("upd_can_BDHD:"+e.getMessage());
	    }
 		return rtn;
 	}
}//  
