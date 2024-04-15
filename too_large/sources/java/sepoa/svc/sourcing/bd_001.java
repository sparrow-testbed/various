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



import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap ;
import java.util.List ;
import java.util.Map ;

import org.apache.commons.collections.MapUtils ;
import org.apache.commons.io.IOUtils;

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
/*
import sepoa.svc.common.constants ;
import sepoa.svc.datatypes.SSCGL_DataType;
import sepoa.svc.datatypes.SSCLN_DataType;
import sepoa.svc.misInterface.MisInterfaceUtil;
import Interface.webService.MMIF0200;
import Interface.webService.WS_002 ;
*/
@SuppressWarnings( { "unchecked", "unused", "rawtypes" } )
public class BD_001 extends SepoaService {

    private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession( "HOUSE_CODE" );
    private String lang         = info.getSession( "LANGUAGE" );
    //20131212 sendakun
    private HashMap msg = null;

    public BD_001( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.sys.println( "BD_001 : " + e.getMessage() );
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


    public SepoaOut getPrHeaderDetail(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
        	sxp = new SepoaXmlParser(this, "getPrHeaderDetail");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

        	headerData.put("house_code", house_code);  
        	
        	setValue(ssm.doSelect(headerData));
        	
        	
        	sxp = new SepoaXmlParser(this, "getBidVedorList");
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
	
	public SepoaOut getDefaultPrData(Map< String, String > headerData) throws Exception
	{

		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		String language = info.getSession("LANGUAGE");
		String ctrl_code = info.getSession("CTRL_CODE");
        String house_code   = info.getSession("HOUSE_CODE"); 
		String RE_PR_DATA = "";
        String rtn = null;

		Map map = new HashMap();
		 
		try {



			String PR_DATA = MapUtils.getString( headerData, "PR_DATA", "" ); 
			
            StringTokenizer st1 = new StringTokenizer(PR_DATA,",");
            int count1 =  st1.countTokens();

            String [][] REQ_NO_SEQ_DATA = new String[count1][2];

            String[] REQ_NO_SEQ = new String[count1];
            for( int j =0 ; j< count1 ; j++ ){
            	REQ_NO_SEQ[j] = st1.nextToken();
            	
            	StringTokenizer st2 = new StringTokenizer(REQ_NO_SEQ[j],"-");
                for(int i = 0 ; i < 2 ; i++){
                	REQ_NO_SEQ_DATA[j][i] = st2.nextToken();
                }
            }
            
            String PR_NO = REQ_NO_SEQ_DATA[0][0];
            String PR_NO_SEQ = "";
            for( int i = 0 ; i < REQ_NO_SEQ_DATA.length ; i++ ){
        		if(i != 0) PR_NO_SEQ += ",";	
                       	
                PR_NO_SEQ  += REQ_NO_SEQ_DATA[i][0] + REQ_NO_SEQ_DATA[i][1];
            }
            map.put("house_code"    , house_code); 
			map.put("PR_NO"		    , PR_NO); 
			map.put("PR_NO_SEQ"		, PR_NO_SEQ);

			/*
			getDefaultBdPrNo // 생성된건이 있는지 조회
			getDefaultBd     // 생성된건이 있다면, 입찰이 또는 역경매가 생성되었는지 확인.
			delDefaultBdPrNo // 없다면 기존에 생성된 PR삭제처리
			setDefaultBdPrNo1// 없다면 기존의 BD_PR_NO 리셋처리 
			setDefaultBdPrNo2// 입찰생성완료후 BD_PR_NO에 생성된 PR번호 셋팅
			getDefaultPrhd   // PR헤더데이타 조회
			getDefaultPrdt   // PR디테일데이타 조회
			setDefaultPrhd   // PR헤더 새로생성
			setDefaultPrdt   // PR디테일 새로 성
			getDefaultPrData // 생성된 PR정보 셋팅
			*/
			
			SepoaXmlParser sxp = new SepoaXmlParser(this, "getDefaultBdPrNo");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			SepoaFormater bdPrNoSf = new SepoaFormater(ssm.doSelect(map));
			if(bdPrNoSf != null && bdPrNoSf.getRowCount() > 0){
				for ( int i = 0 ; i < bdPrNoSf.getRowCount() ; i++){
					if(!"".equals(bdPrNoSf.getValue("BD_PR_NO", i))){
						map.put("BD_PR_NO",bdPrNoSf.getValue("BD_PR_NO", i));
						sxp = new SepoaXmlParser(this, "getDefaultBd");
						ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
						SepoaFormater bdSf = new SepoaFormater(ssm.doSelect(map));
						if(bdSf != null && bdSf.getRowCount() > 0){
							throw new Exception("입찰또는 역경매중인건이 포함되어있습니다.");
						}
					}
				}

				for ( int i = 0 ; i < bdPrNoSf.getRowCount() ; i++){
					if(!"".equals(bdPrNoSf.getValue("BD_PR_NO", i))){
						map.put("BD_PR_NO",bdPrNoSf.getValue("BD_PR_NO", i));
						sxp = new SepoaXmlParser(this, "delDefaultBdPrNo");
						ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
						ssm.doDelete(map);
	
						sxp = new SepoaXmlParser(this, "setDefaultBdPrNo1");
						ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
						ssm.doUpdate(map);
					}
				}
			}

			SepoaOut wo   = DocumentUtil.getDocNumber(info, "BR");
		    String   prNo = wo.result[0];
		    map.put("NEW_PR_NO", prNo);
			
			sxp = new SepoaXmlParser(this, "getDefaultPrhd");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			SepoaFormater prHeaderSf = new SepoaFormater(ssm.doSelect(map));
			List<Map<String, String>> prHeaderList = new ArrayList<Map<String,String>>();
			for(int i = 0 ; i < 1 ; i++){ // 헤더는 한로우만 돌림.
				HashMap<String, String> prHeaderMap = new HashMap<String, String>();
				for(int j = 0 ; j < prHeaderSf.getColumnCount() ; j++){
					prHeaderMap.put(prHeaderSf.getColumnNames()[j], prHeaderSf.getValue(prHeaderSf.getColumnNames()[j], i));
				}
				prHeaderList.add(prHeaderMap);
			}
			
			sxp = new SepoaXmlParser(this, "getDefaultPrdt");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			SepoaFormater prDetailSf = new SepoaFormater(ssm.doSelect(map));
			List<Map<String, String>> prDetailList = new ArrayList<Map<String,String>>();
			for(int i = 0 ; i < prDetailSf.getRowCount() ; i++){
				HashMap<String, String> prDetailMap = new HashMap<String, String>();
				for(int j = 0 ; j < prDetailSf.getColumnCount() ; j++){
					prDetailMap.put(prDetailSf.getColumnNames()[j], prDetailSf.getValue(prDetailSf.getColumnNames()[j], i));
				}
				prDetailList.add(prDetailMap);
			}

			sxp = new SepoaXmlParser(this, "setDefaultPrhd");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			ssm.doInsert(prHeaderList);

			sxp = new SepoaXmlParser(this, "setDefaultPrdt");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			ssm.doInsert(prDetailList);

			sxp = new SepoaXmlParser(this, "getDefaultPrData");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			setValue(ssm.doSelect(map));

			String[] PR_NO_SEQ_SPLIT = MapUtils.getString(map, "PR_NO_SEQ", "").split(",");
			for(int i = 0; i < PR_NO_SEQ_SPLIT.length ; i++){
				map.put("PR_NO_SEQ", PR_NO_SEQ_SPLIT[i]);
				sxp = new SepoaXmlParser(this, "setDefaultBdPrNo2");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				ssm.doUpdate(map);
			}
			
            setStatus(1);
			setFlag(true);
			Commit();
			 
		} catch (Exception e) {
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();
	} 
	

	public SepoaOut getPreBdCancelCheck(Map< String, String > headerData)
	{
		ConnectionContext ctx = getConnectionContext();
		String bdCancelCheckFlag = "";
		try {
			SepoaXmlParser sxp = new SepoaXmlParser(this, "getPreBdCancelCheck");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			SepoaFormater sf = new SepoaFormater(ssm.doSelect(headerData));
			if(sf.getRowCount() < 1){
				bdCancelCheckFlag = "";
			}else{
				bdCancelCheckFlag = sf.getValue(0, 0);
			}
			setValue(bdCancelCheckFlag);
            setStatus(1);
			setFlag(true);
			 
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();
	}
	
	
	public SepoaOut getPrItemDetail(Map< String, String > headerData) throws Exception {

		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		String language = info.getSession("LANGUAGE");
		String ctrl_code = info.getSession("CTRL_CODE");
        String house_code   = info.getSession("HOUSE_CODE"); 
		String RE_PR_DATA = "";
        String rtn = null;

		Map map = new HashMap();
		 
		try {

			SepoaXmlParser sxp = new SepoaXmlParser(this, "getPrItemDetail");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

 
			String PR_DATA = MapUtils.getString( headerData, "PR_DATA", "" ); 
			
            StringTokenizer st1 = new StringTokenizer(PR_DATA,",");
            int count1 =  st1.countTokens();

            String [][] REQ_NO_SEQ_DATA = new String[count1][2];

            String[] REQ_NO_SEQ = new String[count1];
            for( int j =0 ; j< count1 ; j++ ){
            	REQ_NO_SEQ[j] = st1.nextToken();
            	
            	StringTokenizer st2 = new StringTokenizer(REQ_NO_SEQ[j],"-");
                for(int i = 0 ; i < 2 ; i++){
                	REQ_NO_SEQ_DATA[j][i] = st2.nextToken();
                }
            }
            
            String PR_NO_SEQ = "";
            for( int i = 0 ; i < REQ_NO_SEQ_DATA.length ; i++ ){
            	
        		if(i != 0) PR_NO_SEQ += ",";	
                       	
                PR_NO_SEQ  += REQ_NO_SEQ_DATA[i][0] + REQ_NO_SEQ_DATA[i][1];
            }
 

            map.put("house_code", house_code); 
			map.put("PR_NO_SEQ"		, PR_NO_SEQ); 
 
			rtn = ssm.doSelect(map); 
			setValue(rtn);
            setStatus(1);
			setFlag(true);
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();
	}

	/*
	 * 입찰공고생성
	 */ 
    public SepoaOut setAnnCreate( Map< String, Object > allData ) throws Exception {

        SepoaOut    so  = null;

        Map< String, String >           headerData  = null;
        List< Map< String, String > >   gridData    = null;

        String BID_NO  		= "";
        String BID_COUNT   	= ""; 
        String ANN_NO 		= "";
        String vendor_values  	="";
        String estm_kind = "";
        String pflag = "";

        String HOUSE_CODE      = info.getSession("HOUSE_CODE");
        String COMPANY_CODE    = info.getSession("COMPANY_CODE");
        String DEPT            = info.getSession("DEPARTMENT");
        String USER_ID         = info.getSession("ID");
        String NAME_LOC        = info.getSession("NAME_LOC");
        String NAME_ENG        = info.getSession("NAME_ENG");
        String CTRL_CODE 	   = info.getSession("CTRL_CODE");
        String ADD_DATE 	   = SepoaDate.getShortDateString();
        String ADD_TIME 	   = SepoaDate.getShortTimeString();
        
        int rtn0    = 0;
        int rtn1    = 0;
        int rtn2    = 0;
        int rtn3    = 0;
        int rtn4    = 0;
        int rtn5    = 0;
        int rtn6    = 0;

        try {

            setFlag( true );
            setStatus( 1 );

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );
 
            BID_NO  = MapUtils.getString( headerData, "bid_no", "" );
            if( BID_NO == null || "".equals( BID_NO ) || BID_NO.length() < 1 ) { 
            	so        = DocumentUtil.getDocNumber( info, "BD" );  
                headerData.put( "BID_NO", so.result[0] );
                BID_NO = so.result[0];
                
            }
            headerData.put( "BID_NO", BID_NO );

            BID_COUNT   = MapUtils.getString( headerData, "bid_count", "" );

            if( "".equals( BID_COUNT ) || BID_NO != null ) {
            	BID_COUNT = "1";
                headerData.put( "BID_COUNT", BID_COUNT );
            }

            String ANN_TITLE       = "입찰공고";

            int pr_count = 1;

            pr_count = et_getGonggoCount2(allData); // 입찰공고가능여부 체크

            if (pr_count > 0) { //아이템이 견적중임.....
                setStatus(0);
                setMessage("구매가 진행중인 품목이 있습니다.");

                setValue("");
                setValue("");
                setValue("");
                setValue("");
                return getSepoaOut();
            }
 
            headerData.put( "ANN_NO", ANN_NO );

            headerData.put("HOUSE_CODE", HOUSE_CODE);
            headerData.put("COMPANY_CODE", COMPANY_CODE);
            headerData.put("ID", USER_ID);
            headerData.put("NAME_LOC", NAME_LOC);
            headerData.put("NAME_ENG", NAME_ENG); 
            headerData.put("DEPT", DEPT); 
            headerData.put("CTRL_CODE", CTRL_CODE.split("&")[0]);
            headerData.put("ADD_DATE", ADD_DATE);
            headerData.put("ADD_TIME", ADD_TIME);
            
            int rtnHD          = et_setBDHDCreate(allData); 
          
            int rtnDT          = et_setBDDTCreate(allData);   
            int rtnPG          = et_setBDPGCreate(allData);

            int rtnAP   = et_setBDAPCreate(allData); 

            String location_values 	= MapUtils.getString( headerData, "location_values" );
            if (location_values == null) {

            } else { 
                    int rtnDR = et_setBDRCreate(allData); 
            }

            if (estm_kind.equals("M")){
 
            	int rtnBDES = et_setInsertBDES(allData);
            }


            int rtnPRHD = et_setPRDTUPDATE_Gonggo(headerData);
            
            pflag = MapUtils.getString( headerData, "pflag", "" );
            setStatus(1);
            setValue(pflag);
            setValue(BID_NO);
            setValue("1");
            setValue(ANN_NO); 

            if("P".equals(pflag)){
            	setBDCreateSignRequestInfo(BID_NO, BID_COUNT, headerData.get("approval_str"), headerData.get("ANN_ITEM"), gridData.size());
            }
            	
           
            if(pflag.equals("T")) {
                setMessage("임시저장 되었습니다.");
            } /*else if (pflag.equals("P")) {
                setMessage("결재요청 되었습니다.");
            }*/ else {
                setMessage("생성되었습니다.");
            	//setMessage("작성완료 되었습니다.\n\n[견적/입찰]의 [입찰공고] 메뉴에서 입찰공고를 완료하셔야 입찰을 진행할 수 있습니다.");
            }
//            Rollback();
            Commit();	
           
        }catch (Exception e){
//        	e.printStackTrace();
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    }    
 
    private int et_getGonggoCount2( Map< String, Object > allData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();
        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
        
        int rtn = 0;
        int	intGridRowData  = 0;
        String value = null;
        String pr_no_seq = "";


        try {

            headerData  = MapUtils.getMap( allData, "headerData", null );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );
            String pr_no = "";
            if( gridData != null && gridData.size() > 0 ) {

                intGridRowData  = gridData.size();

                for( int i = 0; i < intGridRowData; i++ ) {

                    gridRowData = gridData.get( i );
                    
                    if(i != 0) pr_no_seq  += ",";
                    
                    pr_no = MapUtils.getString( gridRowData, "PR_NO" );
                    String pr_seq = MapUtils.getString( gridRowData, "PR_SEQ" );
                    
                    pr_no_seq  += pr_seq;
                }
            } 
            
            headerData.put("house_code",  info.getSession("HOUSE_CODE"));
            headerData.put("PR_NO",		pr_no);
            headerData.put("PR_SEQ",		pr_no_seq);
	        
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_getGonggoCount2");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			value = ssm.doSelect(headerData);
            SepoaFormater wf = new SepoaFormater(value);
            rtn = Integer.parseInt(wf.getValue(0,0) );
         
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

    private int et_setBDHDCreate( Map< String, Object > allData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();
        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
        
        int rtn = 0;
        int	intGridRowData  = 0;
        String value = null;
        String sign_user_id = "";
        String sign_user_name = "";

        String USER_ID         = info.getSession("ID");
        String NAME_LOC        = info.getSession("NAME_LOC");
        
        try {

            headerData  = MapUtils.getMap( allData, "headerData", null );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );
            
            String pflag = MapUtils.getString( headerData, "pflag" );
            if (pflag.equals("E") || pflag.equals("C")) { // 작성완료
            	sign_user_id 	= USER_ID;
            	sign_user_name 	= NAME_LOC;
            }
 
            if("C".equals(pflag)){ // 신규저장일때 입찰공고로 들어온다면 바로 입찰공고가 가능하도록 함..
            	pflag = "E";
                headerData.put("BID_STATUS", "AC");
            }
            
            String  start_time	= MapUtils.getString( headerData, "start_time");
            String  end_time	= MapUtils.getString( headerData, "end_time");
            String  area		= MapUtils.getString( headerData, "area");
            String  place		= MapUtils.getString( headerData, "place");
            String  notifier	= MapUtils.getString( headerData, "notifier");
            String  resp		= MapUtils.getString( headerData, "resp"); 
            String  anncomment	= MapUtils.getString( headerData, "comment");
 
            headerData.put("SIGN_USER_ID", sign_user_id);
            headerData.put("SIGN_USER_NAME", sign_user_name);
            headerData.put("PFLAG", pflag);
//            headerData.put("ANN_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "ANN_DATE", "" ) ) );
//            headerData.put("APP_BEGIN_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "APP_BEGIN_DATE", "" ) ) );
//            headerData.put("APP_END_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "APP_END_DATE", "" ) ) );
//            headerData.put("BID_BEGIN_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "BID_BEGIN_DATE", "" ) ) );
//            headerData.put("BID_END_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "BID_END_DATE", "" ) ) );
//            headerData.put("OPEN_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "OPEN_DATE", "" ) ) );
 
            headerData.put("ANNOUNCE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "szdate", "" ) ) );
            headerData.put("ANNOUNCE_TIME_FROM", start_time);
            headerData.put("ANNOUNCE_TIME_TO", end_time);
            headerData.put("ANNOUNCE_AREA", area);
            headerData.put("ANNOUNCE_PLACE", place);
            headerData.put("ANNOUNCE_NOTIFIER", notifier);
            headerData.put("ANNOUNCE_RESP", resp);
//            headerData.put("DOC_FRW_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "doc_frw_date", "" ) ) );
            headerData.put("ANNOUNCE_COMMENT", anncomment);  
//            headerData.put("RD_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "RD_DATE", "" ) ) );
            
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setBDHDCreate");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            Logger.err.println("=PFLAG=="+headerData.get("PFLAG"));  
            
//            System.out.println(headerData);
            
			  /*
            Logger.err.println("==="+headerData.get("BID_NO"));                 
            Logger.err.println("==="+headerData.get("BID_COUNT"));              
            Logger.err.println("==="+headerData.get("COMPANY_CODE"));          
            Logger.err.println("==="+headerData.get("STATUS"));                
            Logger.err.println("==="+headerData.get("NAME_LOC"));         
            Logger.err.println("==="+headerData.get("NAME_ENG"));         
            Logger.err.println("==="+headerData.get("DEPT"));              
            Logger.err.println("==="+headerData.get("SIGN_PERSON_ID"));            
            Logger.err.println("==="+headerData.get("SIGN_PERSON_NAME"));          
            Logger.err.println("==="+headerData.get("SIGN_DATE"));                 
            Logger.err.println("==="+headerData.get("SIGN_STATUS"));               
            Logger.err.println("==="+headerData.get("BID_TYPE"));                  
            Logger.err.println("==="+headerData.get("CONT_TYPE1"));                
            Logger.err.println("==="+headerData.get("CONT_TYPE2"));                
            Logger.err.println("==="+headerData.get("ANN_TITLE"));                 
            Logger.err.println("==="+headerData.get("ANN_NO"));                    
            Logger.err.println("==="+headerData.get("ANN_DATE"));                  
            Logger.err.println("==="+headerData.get("ANN_ITEM"));                  
            Logger.err.println("==="+headerData.get("LIMIT_CRIT"));                
            Logger.err.println("==="+headerData.get("PROM_CRIT"));                 
            Logger.err.println("==="+headerData.get("APP_BEGIN_DATE"));            
            Logger.err.println("==="+headerData.get("APP_BEGIN_TIME"));            
            Logger.err.println("==="+headerData.get("APP_END_DATE"));              
            Logger.err.println("==="+headerData.get("APP_END_TIME"));                
            Logger.err.println("==="+headerData.get("ANNOUNCE_DATE"));             
            Logger.err.println("==="+headerData.get("ANNOUNCE_TIME_FROM"));        
            Logger.err.println("==="+headerData.get("ANNOUNCE_TIME_TO"));          
            Logger.err.println("==="+headerData.get("ANNOUNCE_HOST"));             
            Logger.err.println("==="+headerData.get("ANNOUNCE_AREA"));             
            Logger.err.println("==="+headerData.get("ANNOUNCE_PLACE"));            
            Logger.err.println("==="+headerData.get("ANNOUNCE_NOTIFIER"));         
            Logger.err.println("==="+headerData.get("ANNOUNCE_RESP"));             
            Logger.err.println("==="+headerData.get("DOC_FRW_DATE"));              
            Logger.err.println("==="+headerData.get("ANNOUNCE_COMMENT"));          
            Logger.err.println("==="+headerData.get("ANNOUNCE_FLAG"));             
            Logger.err.println("==="+headerData.get("BID_STATUS"));                
            Logger.err.println("==="+headerData.get("ESTM_FLAG"));                 
            Logger.err.println("==="+headerData.get("COST_STATUS"));               
            Logger.err.println("==="+headerData.get("PR_NO"));                     
            Logger.err.println("==="+headerData.get("CTRL_CODE"));                 
            Logger.err.println("==="+headerData.get("ANNOUNCE_TEL"));              
            Logger.err.println("==="+headerData.get("CTRL_AMT"));   
            Logger.err.println("==="+headerData.get("ESTM_KIND"));   
            Logger.err.println("==="+headerData.get("ESTM_RATE"));   
            Logger.err.println("==="+headerData.get("ESTM_MAX"));   
            Logger.err.println("==="+headerData.get("ESTM_VOTE"));   
            Logger.err.println("==="+headerData.get("FROM_CONT"));   
            Logger.err.println("==="+headerData.get("FROM_LOWER_BND"));   
            Logger.err.println("==="+headerData.get("ASUMTN_OPEN_YN"));   
            Logger.err.println("==="+headerData.get("CONT_TYPE_TEXT"));   
            Logger.err.println("==="+headerData.get("CONT_PLACE"));   
            Logger.err.println("==="+headerData.get("BID_PAY_TEXT"));   
            Logger.err.println("==="+headerData.get("BID_CANCEL_TEXT"));   
            Logger.err.println("==="+headerData.get("BID_JOIN_TEXT"));   
            Logger.err.println("==="+headerData.get("REMARK"));   
            Logger.err.println("==="+headerData.get("ESTM_MAX_VOTE"));   
            Logger.err.println("==="+headerData.get("STANDARD_POINT"));   
            Logger.err.println("==="+headerData.get("TECH_DQ"));   
            Logger.err.println("==="+headerData.get("AMT_DQ"));   
            Logger.err.println("==="+headerData.get("RD_DATE"));   
            Logger.err.println("==="+headerData.get("DELY_PLACE"));   
            Logger.err.println("==="+headerData.get("BID_EVAL_SCORE"));   
            Logger.err.println("==="+headerData.get("REPORT_ETC"));   
            */
			rtn = ssm.doInsert(headerData); 
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

    private int et_setBDDTCreate( Map< String, Object > allData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();
        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
        
        int rtn = 0;
        int	intGridRowData  = 0;
        int	item_seq         = 0;
    	try {
            headerData  = MapUtils.getMap( allData, "headerData", null );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );
            
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setBDDTCreate");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

            if( gridData != null && gridData.size() > 0 ) {

                intGridRowData  = gridData.size();

                for( int i = 0; i < intGridRowData; i++ ) {

                    gridRowData = gridData.get( i );

                    gridRowData.put( "HOUSE_CODE",	MapUtils.getString( headerData, "HOUSE_CODE" ) );
                    gridRowData.put( "BID_NO",	MapUtils.getString( headerData, "BID_NO" ) );
                    gridRowData.put( "BID_COUNT",	MapUtils.getString( headerData, "BID_COUNT" ) );
                    gridRowData.put( "ITEM_SEQ",	String.valueOf( ++item_seq ) );
                    gridRowData.put( "ADD_DATE",	MapUtils.getString( headerData, "ADD_DATE" ) );
                    gridRowData.put( "ADD_TIME",	MapUtils.getString( headerData, "ADD_TIME" ) );
                    gridRowData.put( "ID",	MapUtils.getString( headerData, "ID" ) );
                    gridRowData.put( "NAME_LOC",	MapUtils.getString( headerData, "NAME_LOC" ) );
                    gridRowData.put( "NAME_ENG",	MapUtils.getString( headerData, "NAME_ENG" ) );
                    gridRowData.put( "DEPT",	MapUtils.getString( headerData, "DEPT" ) );
                    
            		rtn = ssm.doInsert(gridRowData);
                }
            }
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }

    private int et_setBDPGCreate( Map< String, Object > allData ) throws Exception 
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
            
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setBDPGCreate");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 
    		rtn = ssm.doInsert(headerData);
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private int et_setBDAPCreate( Map< String, Object > allData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();
        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
        
        int rtn = 0;
        int	intGridRowData  = 0;
        String[]    strDivide0;        
        String[]    strDivide1;    
        String      SELLER_CODE     = "";
        
    	try {
            headerData  = MapUtils.getMap( allData, "headerData", null );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );
            
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setBDAPCreate");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

            if( gridData != null && gridData.size() > 0 ) {

                intGridRowData  = gridData.size(); 
                // 그리드의 데이터 만큼 돌린다.
//                for( int i = 0; i < intGridRowData; i++ ) {

                    gridRowData = gridData.get( 0 );
                    gridRowData.put ( "SELLER_SELECTED" ,  MapUtils.getString( gridRowData, "SELLER_SELECTED", "" ).replaceAll ( "&#64;" , "@" ).replaceAll ( "&#40;" , "(").replaceAll ( "&#41;" , ")" ) );
                    strDivide0  = SepoaString.parser( MapUtils.getString( gridRowData, "SELLER_SELECTED", "" ), "#" );

                    if( strDivide0 != null && strDivide0.length > 0 ) {

                        // 그리드의 업체 데이터 수만큼 돌린다.
                        for( int j = 0; j < strDivide0.length; j++ ) {

                            strDivide1  = SepoaString.parser( strDivide0[j], "@" );

                            SELLER_CODE = strDivide1[0].trim();
                            
                            
                            String SELLER_SEQ  = strDivide1[5].trim();
                            String[] SELLER_SEQS = SELLER_SEQ.split ( "!" ); 
                            
                            SELLER_SEQ = "";
                            for(int k = 0 ; k < SELLER_SEQS.length ; k++){
                                if(SELLER_SEQS[k].indexOf ( SELLER_CODE ) != -1){
                                    SELLER_SEQ += SELLER_SEQS[k] + "!";
                                }
                            }
 
                            gridRowData.put( "VENDOR_CODE",        SELLER_CODE );
                            gridRowData.put( "SUPI_ID",        SELLER_SEQ );
                            rtn  = ssm.doInsert( gridRowData );
                        }
                    }
//                }
            }
            /*
        	StringTokenizer st_row, st_col;
            String vendor_code = "";

            //업체(vendor_values)--Data format [vendor_code, vendor명, flag], ex (0000300007 @한국식품공업(주) @N @#...)
            String vendor_values = MapUtils.getString( headerData, "vendor_values");
            st_row = new StringTokenizer(vendor_values, "#", false);

            while(st_row.hasMoreElements()) {
                st_col = new StringTokenizer(st_row.nextToken().trim(), "@", false);

                vendor_code = st_col.nextToken().trim();	//vendor_code
                headerData.put("VENDOR_CODE",vendor_code);
                
        		rtn = ssm.doInsert(headerData);
            }
             */
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private int et_setBDRCreate( Map< String, Object > allData ) throws Exception 
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
            
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setBDRCreate");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

        	StringTokenizer st_row, st_col;
            String code = "";
            String name = "";

            //업체(vendor_values)--Data format [vendor_code, vendor명, flag], ex (0000300007 @한국식품공업(주) @N @#...)
            String location_values = MapUtils.getString( headerData, "location_values");
            st_row = new StringTokenizer(location_values, "#", false);

            while(st_row.hasMoreElements()) {
                st_col = new StringTokenizer(st_row.nextToken().trim(), "@", false);

                code = st_col.nextToken().trim();    //vendor_code
                name = st_col.nextToken().trim();    //vendor_code
                headerData.put("RC_CODE",code);
                headerData.put("RC_NAME",name);
                
        		rtn = ssm.doInsert(headerData);
            }
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private int et_setInsertBDES( Map< String, Object > allData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();
        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
        
        int rtn = 0;
        int	intGridRowData  = 0;
        float BASIC_AMT = 0;
    	try {
            headerData  = MapUtils.getMap( allData, "headerData", null );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );
            
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setInsertBDES");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

            if( gridData != null && gridData.size() > 0 ) {

                intGridRowData  = gridData.size();

                for( int i = 0; i < intGridRowData; i++ ) {

                    gridRowData = gridData.get( i );

                    BASIC_AMT +=  Float.parseFloat(MapUtils.getString( gridRowData, "AMT" ) );
                     
                }
            } 
            headerData.put("BASIC_AMT",  BASIC_AMT+"");
			rtn = ssm.doInsert(headerData);   
			
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private int et_setPRDTUPDATE_Gonggo( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext(); 

        String pr_proceeding_flag = "";
        String bid_status = ""; 
        int rtn = 0;

        String HOUSE_CODE      = info.getSession("HOUSE_CODE"); 
        
    	try { 
            
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setPRDTUPDATE_Gonggo");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

			bid_status = headerData.get("BID_STATUS");
			
	        if ("CC".equals(bid_status)) {	// 취소공고가 확정일시에 접수현황으로 돌려서 다시 소싱을 진행시킨다.
	        	pr_proceeding_flag = "P";
	        } else {
	        	pr_proceeding_flag = "C";        	
	        }

	        headerData.put("HOUSE_CODE",			HOUSE_CODE);  
	        headerData.put("PR_PROCEEDING_FLAG",	pr_proceeding_flag);
	        headerData.put( "PURCHASER_NAME",     info.getSession( "NAME_LOC" )  ); 
	        //headerData.put("BID_STATUS",			bid_status);
			rtn = ssm.doInsert(headerData);   
			
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }

	public SepoaOut getBidAnnounce(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 
        String company_code   = info.getSession("COMPANY_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBidAnnounce");
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
	/*
	 * 입찰공고수정
	 */ 
    public SepoaOut setGonggoModify( Map< String, Object > allData ) throws Exception {

        SepoaOut    so  = null;

        Map< String, String >           headerData  = null;
        List< Map< String, String > >   gridData    = null;

        String BID_NO  		= "";
        String BID_COUNT   	= ""; 
        String ANN_NO 		= "";
        String vendor_values  	="";
        String estm_kind = "";
        String pflag = "";

        String HOUSE_CODE      = info.getSession("HOUSE_CODE");
        String COMPANY_CODE    = info.getSession("COMPANY_CODE");
        String DEPT            = info.getSession("DEPARTMENT");
        String USER_ID         = info.getSession("ID");
        String NAME_LOC        = info.getSession("NAME_LOC");
        String NAME_ENG        = info.getSession("NAME_ENG");
        String CTRL_CODE 	   = info.getSession("CTRL_CODE");
        String ADD_DATE 	   = SepoaDate.getShortDateString();
        String ADD_TIME 	   = SepoaDate.getShortTimeString();
        
        int rtn0    = 0;
        int rtn1    = 0;
        int rtn2    = 0;
        int rtn3    = 0;
        int rtn4    = 0;
        int rtn5    = 0;
        int rtn6    = 0;

        try {

            setFlag( true );
            setStatus( 1 );

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );

            headerData.put("HOUSE_CODE", 	HOUSE_CODE);
            headerData.put("COMPANY_CODE", 	COMPANY_CODE);
            headerData.put("ID", 			USER_ID);
            headerData.put("NAME_LOC", 		NAME_LOC);
            headerData.put("NAME_ENG", 		NAME_ENG); 
            headerData.put("DEPT", 			DEPT); 
            headerData.put("CTRL_CODE", 	CTRL_CODE.split("&")[0]);
            headerData.put("ADD_DATE", 		ADD_DATE);
            headerData.put("ADD_TIME", 		ADD_TIME);
            headerData.put("BID_NO", 		MapUtils.getString( headerData, "bid_no" ));
            headerData.put("BID_COUNT", 	MapUtils.getString( headerData, "bid_count" ));
            
            String status = et_chkModify(allData); // 입찰공고가능여부 체크
 
            if (status.equals("N")){
                setStatus(0);
                setMessage("공고일자가 지난 건은 수정할 수 없습니다.");   // 공고일자가 지난 건은 수정할 수 없습니다.
                return getSepoaOut();
            }
  
            int delDT          = et_delBDDT(headerData);
            int delAP          = et_delBDAP(headerData);
            int delPG          = et_delBDPG(headerData);
            int delRC          = et_delBDRC(headerData);
            int delES          = et_delBDES(headerData);
            int delHD          = et_delBDHD(headerData);
 
            int rtnHD          = et_setBDHDCreate(allData);  
            int rtnDT          = et_setBDDTCreate(allData);   
            int rtnPG          = et_setBDPGCreate(allData);

            int rtnAP   = et_setBDAPCreate(allData); 
/*
            String location_values 	= MapUtils.getString( headerData, "location_values" );
            if (location_values == null) {

            } else { 
                    int rtnDR = et_setBDRCreate(allData); 
            }
*/
            if (estm_kind.equals("M")){
 
            	int rtnBDES = et_setInsertBDES(allData);
            }
 
            int rtnPRHD_old = et_setPRDTUPDATE_Gonggo_Old(headerData);
            int rtnPRHD = et_setPRDTUPDATE_Gonggo(headerData);

            pflag = MapUtils.getString( headerData, "pflag", "" );
            BID_NO = MapUtils.getString( headerData, "bid_no" );
            BID_COUNT = MapUtils.getString( headerData, "bid_count" );
 
            setStatus(1);
            setValue(pflag);
            setValue(MapUtils.getString( headerData, "bid_no" )); 
            setValue(MapUtils.getString( headerData, "bid_count" )); 
            /*
            if(pflag.equals("T")) {
                setMessage("임시저장 되었습니다.");
            } else if (pflag.equals("P")) {
                setMessage("결재요청 되었습니다.");
            } else {
            	setMessage("작성완료 되었습니다.\n\n[견적/입찰]의 [입찰공고] 메뉴에서 입찰공고를 완료하셔야 입찰을 진행할 수 있습니다.");
            }
            */
            
            if("P".equals(pflag)){
            	setBDCreateSignRequestInfo(BID_NO, BID_COUNT, headerData.get("approval_str"), headerData.get("ANN_ITEM"), gridData.size());
            }
            
            setMessage("성공적으로 처리되었습니다.");
            Commit();	
           
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    }      
    private String et_chkModify( Map< String, Object > allData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();
        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;

        String rtn = "";
        String value = null;

        String HOUSE_CODE      = info.getSession("HOUSE_CODE"); 
        
    	try {
            headerData  = MapUtils.getMap( allData, "headerData", null ); 
            
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_chkModify");
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
    private int et_setPRDTUPDATE_Gonggo_Old( Map< String, String > headerData ) throws Exception
    {
        ConnectionContext ctx = getConnectionContext(); 
        int rtn = 0; 
        String HOUSE_CODE      = info.getSession("HOUSE_CODE"); 
        
    	try { 
    		
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setPRDTUPDATE_Gonggo_Old");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 
	        headerData.put("HOUSE_CODE",			HOUSE_CODE);   
			rtn = ssm.doInsert(headerData);   
			
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private int et_delBDDT( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();  
        int rtn = 0; 
        String HOUSE_CODE      = info.getSession("HOUSE_CODE"); 
        
    	try { 
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_delBDDT");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 
	        headerData.put("HOUSE_CODE",			HOUSE_CODE);   
			rtn = ssm.doInsert(headerData);   
			
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private int et_delBDAP( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();  
        int rtn = 0; 
        String HOUSE_CODE      = info.getSession("HOUSE_CODE"); 
        
    	try { 
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_delBDAP");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 
	        headerData.put("HOUSE_CODE",			HOUSE_CODE);   
			rtn = ssm.doInsert(headerData);   
			
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }     
    private int et_delBDPG( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();  
        int rtn = 0; 
        String HOUSE_CODE      = info.getSession("HOUSE_CODE"); 
        
    	try { 
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_delBDPG");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 
	        headerData.put("HOUSE_CODE",			HOUSE_CODE);   
			rtn = ssm.doInsert(headerData);   
			
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private int et_delBDRC( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();  
        int rtn = 0; 
        String HOUSE_CODE      = info.getSession("HOUSE_CODE"); 
        
    	try { 
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_delBDRC");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 
	        headerData.put("HOUSE_CODE",			HOUSE_CODE);   
			rtn = ssm.doInsert(headerData);   
			
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private int et_delBDHD( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();  
        int rtn = 0; 
        String HOUSE_CODE      = info.getSession("HOUSE_CODE"); 
        
    	try { 
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_delBDHD");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 
	        headerData.put("HOUSE_CODE",			HOUSE_CODE);   
			rtn = ssm.doInsert(headerData);   
			
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private int et_delBDES( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();  
        int rtn = 0; 
        String HOUSE_CODE      = info.getSession("HOUSE_CODE"); 
        
    	try { 
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_delBDDT");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 
	        headerData.put("HOUSE_CODE",			HOUSE_CODE);   
			rtn = ssm.doInsert(headerData);   
			
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    
    
    
	/*
	 * 입찰공고확정
	 */ 
    public SepoaOut setGonggoConfirm( Map< String, Object > allData ) throws Exception {

        SepoaOut    so  = null;

        Map< String, String >           headerData  = null;
        List< Map< String, String > >   gridData    = null;

        String BID_NO  		= "";
        String BID_COUNT   	= ""; 
        String ANN_NO 		= "";
        String vendor_values  	="";
        String estm_kind = "";
        String pflag = "";

        String HOUSE_CODE      = info.getSession("HOUSE_CODE");
        String COMPANY_CODE    = info.getSession("COMPANY_CODE");
        String DEPT            = info.getSession("DEPARTMENT");
        String USER_ID         = info.getSession("ID");
        String NAME_LOC        = info.getSession("NAME_LOC");
        String NAME_ENG        = info.getSession("NAME_ENG");
        String CTRL_CODE 	   = info.getSession("CTRL_CODE");
        String ADD_DATE 	   = SepoaDate.getShortDateString();
        String ADD_TIME 	   = SepoaDate.getShortTimeString();
        
        int rtn    = 0;
        int rtn1    = 0;
        int rtn2    = 0;
        int rtn3    = 0;
        int rtn4    = 0;
        int rtn5    = 0;
        int rtn6    = 0;

        try {

            setFlag( true );
            setStatus( 1 );

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );

            headerData.put("HOUSE_CODE", 	HOUSE_CODE);
            headerData.put("COMPANY_CODE", 	COMPANY_CODE);
            headerData.put("ID", 			USER_ID);
            headerData.put("NAME_LOC", 		NAME_LOC);
            headerData.put("NAME_ENG", 		NAME_ENG); 
            headerData.put("DEPT", 			DEPT); 
            headerData.put("CTRL_CODE", 	CTRL_CODE.split("&")[0]);
            headerData.put("ADD_DATE", 		ADD_DATE);
            headerData.put("ADD_TIME", 		ADD_TIME);
            headerData.put("BID_NO", 		MapUtils.getString( headerData, "bid_no" ));
            headerData.put("BID_COUNT", 	MapUtils.getString( headerData, "bid_count" ));
            
            String BID_STATUS = MapUtils.getString( headerData, "BID_STATUS");
            BID_STATUS = BID_STATUS.substring(0, 1);

            Logger.err.println("===BID_STATUS=============>" +BID_STATUS);
            headerData.put("BID_STATUS",  BID_STATUS +"C" );
            
            rtn = et_setStatusUpdateBDHD(headerData);

            rtn = et_setStatusUpdateBDPG(headerData);
 
            if(BID_STATUS.equals("U")) { // 정정 or 취소공고 확정일때만...이전 차수의 status = 'D' 로 update해준다.
                 rtn = et_setStatusBeforeUpdateBDHD(headerData);
            }
            	 rtn = et_setPRDTUPDATE_Gonggo(headerData);
            if( rtn == 0 )
                setStatus(0);
            else
                setStatus(1);

            setValue(String.valueOf(rtn));
            setMessage("입찰 공고 되었습니다.");
            Commit();	
           
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    }   
    private int et_setStatusUpdateBDHD( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();  
        int rtn = 0; 
        String HOUSE_CODE      = info.getSession("HOUSE_CODE"); 
        
    	try { 
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setStatusUpdateBDHD");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 
	        headerData.put("HOUSE_CODE",			HOUSE_CODE);   
			rtn = ssm.doInsert(headerData);   
			
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private int et_setStatusUpdateBDPG( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();  
        int rtn = 0; 
        String HOUSE_CODE      = info.getSession("HOUSE_CODE"); 
        
    	try { 
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setStatusUpdateBDPG");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 
	        headerData.put("HOUSE_CODE",			HOUSE_CODE);  
	        headerData.put("VOTE_COUNT",			"1");   
			rtn = ssm.doInsert(headerData);   
			
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private int et_setStatusBeforeUpdateBDHD( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();  
        int rtn = 0; 
        String HOUSE_CODE      = info.getSession("HOUSE_CODE"); 
        
    	try { 
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_setStatusBeforeUpdateBDHD");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 
	        headerData.put("HOUSE_CODE",			HOUSE_CODE);   
			rtn = ssm.doInsert(headerData);   
			
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }


    /**
     * 결재 요청 로직. 
     * 
     * @param allData
     * @return
     * @throws Exception
     */
    public SepoaOut setApprovalRequest(  Map allData  ) throws Exception {

        ConnectionContext ctx = getConnectionContext(); 
        SepoaFormater     sf  = null;
        
        Map< String, String > grid   = null;
        Map< String, String > header = null;
        
        List< Map< String, String >> gridData = null; 
 
        String sign_status = "";
          
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
        try {
        	
            header                  = MapUtils.getMap(allData, "headerData", null);
            gridData                = (List<Map<String,String>>)MapUtils.getObject(allData, "gridData");
            
            String appApproved    = "E";                  // 결재진행(완료) 코드
            String appApproving   = "P";                 // 결재진행 코드
            String appRejected    = "R";                  // 결재반려
            String signApproving  = "P";                // 결재진행 코드
            String job_Approving  = "P";                 // 결재진행 코드
            String codeProceeding = "A";       // PR_PROCEEDING_FLAG 상태
            String docType        = "BD";       // 문서타입(EX 구매품의서)
            String defSellCompany = "S999";
            
            String flagN          = "N";
            String flagY          = "Y";
            String docNo          = "";
            
            String strDate        = SepoaDate.getShortDateString();                                           // 현재 일자 
            String strTime        = SepoaDate.getShortTimeString();                                           // 현재 시간
            String companyCode    = info.getSession("COMPANY_CODE");                                          // 작성자의 회사코드 
            
            String signCheck      = "";                                                                       // 임시 승인여부
            String appCheck       = "";
            
            String subject        = "";                                                                       // 결제 문서 제목
            
            
            
            /* ***********************************************************************************************
             * 결재선의 정보를 배열로 받아 보관 한다.
             * 
             */
            String   app_line   = header.get( "app_line" );
            Logger.debug.println("app_line==="+app_line);
            String[] appLines   = app_line.split( "[#][#]");
            String[] appLinesId = appLines[0].split( "[@][@]");
            String[] appLinesSe = appLines[1].split( "[@][@]");
            String[] appLinesAutoFlag = appLines[2].split( "[@][@]");
            for(int ii = 0 ; ii<appLinesAutoFlag.length ; ii++){
            	if("1".equals(appLinesAutoFlag[ii])){
            		appLinesAutoFlag[ii] = "Y";
            	}else{
            		appLinesAutoFlag[ii] = "N";
            	}
            }

            grid = gridData.get( 0 );
                
                /* *******************************************************************************************
                 * 문서 번호를 생성한다.
                 * 
                 * 문서 제목을 생성.
                 * 
                 */
                String ANN_NO = header.get( "ANN_NO" );
                if( ANN_NO == null || ANN_NO.length() == 0){

    	        	SepoaOut so = DocumentUtil.getDocNumber( info, "AD" );
    	            ANN_NO = so.result[0];
                	
                }
	        
                docNo   = ANN_NO;
                subject = header.get( "ANN_ITEM" );
                 
                /* *******************************************************************************************
                 * GET SETTER 로 데이터를 세팅.
                 * 
                 */
                String doc_seq = header.get( "bid_count" );
                header.put("company_code", companyCode);
                header.put("doc_type", docType);
                header.put("doc_no", docNo);
                header.put("doc_seq", doc_seq);
                header.put("auto_manual_flag", "A");
                header.put("app_stage", "1");
                header.put("app_status", appApproving);
                header.put("subject", subject);
                  
                /* *******************************************************************************************
                 * 해당 문서가 존재한다면(반려되지 않는 문서가)
                 * 이는 재 상신이 불가능 하다.
                 * 
                 */
				sxp = new SepoaXmlParser(this, "setApprovalRequest_selectSSCGL");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				
				sf = new SepoaFormater( ssm.doSelect( header ) );
                
                if( !"0".equals( sf.getValue( "CNT" , 0 ) ) ){
                    throw new Exception("결재 진행 중인 문서가 존재 합니다.");
                    
                } // end if

                
                /* *******************************************************************************************
                 * 반려된 문서만 존재 한다면 등록된 문서를 삭제 후 재 등록한다.
                 * SSCGL , SSCLN 의 데이터를 모두 삭제.
                 */
				sxp = new SepoaXmlParser(this, "setApprovalRequest_deleteSSCGL");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				ssm.doDelete( header ); 

				sxp = new SepoaXmlParser(this, "setApprovalRequest_deleteSSCLN");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				ssm.doDelete( header ); 
                  
                /* *******************************************************************************************
                 * 해당 문서의 등록
                 * 
                 */
				sxp = new SepoaXmlParser(this, "setApprovalRequest_insertSSCGL");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				ssm.doInsert( header );  
                

                /* *******************************************************************************************
                 * 해당 문서의 SSCLN 의 등록
                 * 
                 */
                
                
	            Logger.debug.println("appLinesId.length==="+appLinesId.length);
                for( int j = 0 , jMax = appLinesId.length ; j < jMax ; j++ ){
                    
                    if( "0".equals( appLinesSe[j] ) ){
                        signCheck = flagN;
                        appCheck  = appApproved;
                        
                    } else if( "1".equals( appLinesSe[j] ) ){
                            signCheck = flagY;
                            appCheck  = appApproving;
                            
                    } else {
                        signCheck = flagN;
                        appCheck  = appApproving;
                        
                    } // end if

    	            Logger.debug.println("appLinesSe["+j+"]==="+appLinesSe[j]);
                    grid.put( "COMPANY_CODE",     	MapUtils.getString( header, "company_code", "" ) );
                    grid.put( "DOC_TYPE",     		docType );
                    grid.put( "DOC_NO",     		docNo );
                    grid.put( "DOC_SEQ",     		doc_seq );
                    grid.put( "SIGN_PATH_SEQ",     	appLinesSe[j] );
                    grid.put( "PROCEEDING_FLAG",    codeProceeding );
                    grid.put( "APP_STATUS",     	appCheck );
                    grid.put( "SIGN_CHECK",     	signCheck );
                    grid.put( "SIGN_USER_ID",     	appLinesId[j] );
                    grid.put( "SIGN_AUTO_FLAG",     appLinesAutoFlag[j] );

    				sxp = new SepoaXmlParser(this, "setApprovalRequest_insertSSCLN");
    				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    				ssm.doInsert( grid );   
                    
                } // end for

                 
                /* *******************************************************************************************
                 * 결제 문서의 등록이 완료 되었으면 신청의 상태 값을 변경해 준다.
                 * 
                 */
                header.put( "ann_no", ANN_NO );
                SepoaOut out = setBDStatus( allData );

                if( !out.flag ){
                    throw new Exception( out.message );
                    
                }
                
//            } // end for
            
            setFlag( true );
            setStatus( 1 );
            setMessage("결재요청 되었습니다.");
            
            Commit();

        } catch( Exception e ) {
            try {
                Rollback();
            } catch( Exception d ) {
                Logger.err.println( info.getSession( "ID" ), this, d.getMessage() );
            }

            
            Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
            setFlag( false );
            setStatus( 0 );
            setMessage( e.getMessage() );
        }

        return getSepoaOut();
    }
    
    /**
     * G/W 상신창을 띄우고 나서 정상적으로 상신을 했을때
     * 상태값을 결재 진행중으로 바꿔주는 함수
     * 
     * @param headerData
     * @return
     */
    public SepoaOut setBDStatus( Map<String, Object> allData ) {

        ConnectionContext ctx = getConnectionContext(); 

        Map< String, String >   headerData  = new HashMap< String, String >();
 
        List< Map< String, String >> gridData = null;

        String flagDel   = "N";
        String Approving = "P";

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

            setStatus( 1 );
            setFlag( true );
 
            headerData  = MapUtils.getMap( allData, "headerData", null );
 
            // DR 상태값 업데이트
			sxp = new SepoaXmlParser(this, "setApprovalRequest_updateSBDGL");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			ssm.doUpdate( headerData );  
             

        } catch( Exception e ) {
 
             
            setMessage( msg.get( "MSG_0000" ).toString() );
            setStatus( 0 );
            setFlag( false );
        }

        return getSepoaOut();

    }/*
	 * 정정공고생성
	 */ 
    public SepoaOut setUGonggoCreate( Map< String, Object > allData ) throws Exception {

        SepoaOut    so  = null;

        Map< String, String >           headerData  = null;
        List< Map< String, String > >   gridData    = null;

        String BID_NO  		= "";
        String BID_COUNT   	= ""; 
        String ANN_NO 		= "";
        String vendor_values  	="";
        String estm_kind = "";
        String pflag = "";

        String HOUSE_CODE      = info.getSession("HOUSE_CODE");
        String COMPANY_CODE    = info.getSession("COMPANY_CODE");
        String DEPT            = info.getSession("DEPARTMENT");
        String USER_ID         = info.getSession("ID");
        String NAME_LOC        = info.getSession("NAME_LOC");
        String NAME_ENG        = info.getSession("NAME_ENG");
        String CTRL_CODE 	   = info.getSession("CTRL_CODE");
        String ADD_DATE 	   = SepoaDate.getShortDateString();
        String ADD_TIME 	   = SepoaDate.getShortTimeString();
        
        int rtn0    = 0;
        int rtn1    = 0;
        int rtn2    = 0;
        int rtn3    = 0;
        int rtn4    = 0;
        int rtn5    = 0;
        int rtn6    = 0;

        try {

            setFlag( true );
            setStatus( 1 );

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );
   
            String ANN_TITLE       = "입찰공고";

            String F_BID_COUNT = MapUtils.getString( headerData, "bid_count" );      // 현재 차수   ex) 1

            headerData.put("HOUSE_CODE", 	HOUSE_CODE);
            headerData.put("COMPANY_CODE", 	COMPANY_CODE);
            headerData.put("ID", 			USER_ID);
            headerData.put("NAME_LOC", 		NAME_LOC);
            headerData.put("NAME_ENG", 		NAME_ENG); 
            headerData.put("DEPT", 			DEPT); 
            headerData.put("CTRL_CODE", 	CTRL_CODE.split("&")[0]);
            headerData.put("ADD_DATE", 		ADD_DATE);
            headerData.put("ADD_TIME", 		ADD_TIME);
            headerData.put("BID_NO", 		MapUtils.getString( headerData, "bid_no" ));
            headerData.put("BID_COUNT", 	MapUtils.getString( headerData, "bid_count" ));
 
            int preBdDelete = delPreBdDelete(headerData);
            
            if(preBdDelete == 0){
            	throw new Exception(F_BID_COUNT + "차수 공고 삭제 처리중 에러가 발생하였습니다.");
            }
            
            String C_BID_COUNT = getMaxBidCount(headerData); 
            
            String status = et_chkUGonggo(headerData);

            if (status.equals("N")){
                setStatus(0);
                setMessage("공고일자가 지난 건은 정정공고를 생성할 수 없습니다.");   // 공고일자가 지난 건은 정정공고를 생성할 수 없습니다.
                return getSepoaOut();
            }

            String valid_flag = et_getGonggoIsValid(headerData); // 해당 입찰번호에 2개 이상의 차수가 존재한다면, 더 진행을 못하게 한다.

            if (valid_flag.equals("N")) { //아이템이 견적중임.....
                setStatus(0);
                setMessage("정정공고 또는 취소공고가 이미 진행중입니다.");
                return getSepoaOut();
            }
   
            headerData.put("BID_COUNT", C_BID_COUNT);
            
            int rtnHD          = et_setBDHDCreate(allData); 
          
            int rtnDT          = et_setBDDTCreate(allData);   
            int rtnPG          = et_setBDPGCreate(allData);

            vendor_values =  MapUtils.getString( headerData, "vendor_values" );
             
            Logger.err.println(info.getSession("ID"),this,"vendor_values===="+vendor_values+"=========>" );
            if( vendor_values == null || vendor_values.length() == 0) {

            } else { 
                    int rtnAP   = et_setBDAPCreate(allData); 
            }
/*
            String location_values 	= MapUtils.getString( headerData, "location_values" );
            if (location_values == null) {

            } else { 
                    int rtnDR = et_setBDRCreate(allData); 
            }
*/
            if (estm_kind.equals("M")){  //예정가격 :복수예가사용시
 
            	int rtnBDES = et_setInsertBDES(allData);
            }


            headerData.put("bid_count", F_BID_COUNT);  //현재차수로 변경해서 업데이트
            int rtnPRHD_old = et_setPRDTUPDATE_Gonggo_Old(headerData);
            
            headerData.put("bid_count", C_BID_COUNT); 
            int rtnPRHD = et_setPRDTUPDATE_Gonggo(headerData);
            
            pflag = MapUtils.getString( headerData, "pflag", "" );
            BID_NO = MapUtils.getString( headerData, "bid_no" );
            setStatus(1);
            setValue(pflag);
            setValue(BID_NO);
            setValue(C_BID_COUNT);
            setValue(ANN_NO);
            
            if("P".equals(pflag)){
            	setBDCreateSignRequestInfo(BID_NO, C_BID_COUNT, headerData.get("approval_str"), headerData.get("ANN_ITEM"), gridData.size());
            }
            /*
            if(pflag.equals("T")) {
                setMessage("임시저장 되었습니다.");
            } else if (pflag.equals("P")) {
                setMessage("결재요청 되었습니다.");
            } else {
            	setMessage("작성완료 되었습니다.\n\n[견적/입찰]의 [입찰공고] 메뉴에서 입찰공고를 완료하셔야 입찰을 진행할 수 있습니다.");
            }*/

            setMessage("성공적으로 처리되었습니다.");
            Commit();	
           
        }catch (Exception e){
        	Rollback();
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    }   

    private int delPreBdDelete( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext(); 
        
        int rtn = 0; 
    	try { 
    		
    		SepoaXmlParser sxp = null;
			SepoaSQLManager ssm = null; 

			sxp = new SepoaXmlParser(this, "bddt_delPreBdDelete");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			ssm.doUpdate(headerData);

			sxp = new SepoaXmlParser(this, "bdpg_delPreBdDelete");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			ssm.doUpdate(headerData);

			sxp = new SepoaXmlParser(this, "bdap_delPreBdDelete");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			ssm.doUpdate(headerData);
			
			sxp = new SepoaXmlParser(this, "bdhd_delPreBdDelete");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			ssm.doUpdate(headerData);
			
			rtn = 1;
                		
   		} catch(Exception e) {
   			rtn = 0;
   			Rollback();
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private String getMaxBidCount( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext(); 
        
        String rtn = ""; 
    	try { 
    		
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "getMaxBidCount");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

			rtn = ssm.doSelect(headerData);
            SepoaFormater wf = new SepoaFormater(rtn);
            rtn = wf.getValue(0,0);
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private String et_chkUGonggo( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext(); 
        
        String rtn = ""; 
    	try { 
    		
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_chkUGonggo");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

			rtn = ssm.doSelect(headerData);
            SepoaFormater wf = new SepoaFormater(rtn);
            rtn = wf.getValue(0,0);
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }
    private String et_getGonggoIsValid( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext(); 
        
        String rtn = ""; 
    	try { 
    		
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_getGonggoIsValid");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

			rtn = ssm.doSelect(headerData);
            SepoaFormater wf = new SepoaFormater(rtn);
            rtn = wf.getValue(0,0);
    		
   		} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
   		}
   		return rtn;
    }

	/*
	 * 입찰공고취소
	 */ 
    public SepoaOut setCancelGonggo( Map< String, Object > allData ) throws Exception {

		ConnectionContext ctx = getConnectionContext();
        SepoaOut    so  = null;

        Map< String, String >           headerData  = null;
        List< Map< String, String > >   gridData    = null;

        String HOUSE_CODE      = info.getSession("HOUSE_CODE");
        String COMPANY_CODE    = info.getSession("COMPANY_CODE");
        String DEPT            = info.getSession("DEPARTMENT");
        String USER_ID         = info.getSession("ID");
        String NAME_LOC        = info.getSession("NAME_LOC");
        String NAME_ENG        = info.getSession("NAME_ENG");
        String CTRL_CODE 	   = info.getSession("CTRL_CODE");
        String ADD_DATE 	   = SepoaDate.getShortDateString();
        String ADD_TIME 	   = SepoaDate.getShortTimeString();
        
        int rtn    = 0; 

        String ANN_TITLE       = "취소공고";

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

            setFlag( true );
            setStatus( 1 );

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );

            headerData.put("HOUSE_CODE", 	HOUSE_CODE);
            headerData.put("COMPANY_CODE", 	COMPANY_CODE);
            headerData.put("ID", 			USER_ID);
            headerData.put("NAME_LOC", 		NAME_LOC);
            headerData.put("NAME_ENG", 		NAME_ENG); 
            headerData.put("DEPT", 			DEPT); 
            headerData.put("CTRL_CODE", 	CTRL_CODE.split("&")[0]);
            headerData.put("ADD_DATE", 		ADD_DATE);
            headerData.put("ADD_TIME", 		ADD_TIME); 
            headerData.put("ANN_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "ANN_DATE", "" ) ) );
            

			sxp = new SepoaXmlParser(this, "et_chkCGonggo");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			SepoaFormater sf = new SepoaFormater(ssm.doSelect(headerData)); 
			String status = sf.getValue(0, 0); 

            if (status.equals("N")){
                setStatus(0);
                setMessage("공고일자가 지난 건은 정정공고를 생성할 수 없습니다.");   // 공고일자가 지난 건은 정정공고를 생성할 수 없습니다.
                return getSepoaOut();
            }

			sxp = new SepoaXmlParser(this, "et_getGonggoIsValid");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            sf = new SepoaFormater(ssm.doSelect(headerData)); 
			String valid_flag = sf.getValue(0, 0);  // 해당 입찰번호에 2개 이상의 차수가 존재한다면, 더 진행을 못하게 한다.

            if (valid_flag.equals("N")) { //아이템이 견적중임.....
                setStatus(0);
                setMessage("정정공고 또는 취소공고가 이미 진행중입니다.");
                return getSepoaOut();
            }
            
            String C_BID_COUNT = getMaxBidCount(headerData); 
            
            int rtnDT = 0;
            int rtnPG = 0;
            int rtnAP = 0;
            int rtnHD = 0;
            int rtnPRHD = 0;
            String ANN_DATE = SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "ANN_DATE", "" ) );

            if ( "C".equals(MapUtils.getString( headerData, "FLAG" )) ) {
				sxp = new SepoaXmlParser(this, "et_setBDLNCancelConfirmCreate");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				rtnDT = ssm.doUpdate(headerData); 

        		String input_date = SepoaDate.addSepoaDateMonth(ANN_DATE,+1); // 입찰공고화면에 조회되귀 위하여, 공고일자+1달 을 임의로 넣어준다.

                Logger.err.println("input_date===========>" + input_date);
        		headerData.put("E_ANN_DATE", input_date);
				sxp = new SepoaXmlParser(this, "et_setBDPGCancelConfirmCreate");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				rtnPG = ssm.doUpdate(headerData);  

				sxp = new SepoaXmlParser(this, "et_setBDAPCancelConfirmCreate");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				rtnAP = ssm.doUpdate(headerData);  
				 
                // ICOYBDHD INSERT
				sxp = new SepoaXmlParser(this, "et_setBDHDCancelConfirmCreate");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				rtnHD = ssm.doUpdate(headerData);  
  
                rtn = et_setStatusBeforeUpdateBDHD(headerData);
                
                String BID_COUNT = MapUtils.getString( headerData, "BID_COUNT" );
        		headerData.put("BID_COUNT", String.valueOf(Integer.parseInt(BID_COUNT) + 1));
        		headerData.put("BID_STATUS", "CC");

				sxp = new SepoaXmlParser(this, "et_setPRDTUPDATE_Confirm_Gonggo");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				rtnPRHD = ssm.doUpdate(headerData);  
 		 
            } else {

				sxp = new SepoaXmlParser(this, "et_setBDDTCancelCreate");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				rtnDT = ssm.doUpdate(headerData);
				
				sxp = new SepoaXmlParser(this, "et_setBDPGCancelCreate");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				rtnPG = ssm.doUpdate(headerData);
				
				sxp = new SepoaXmlParser(this, "et_setBDAPCancelCreate");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				rtnAP = ssm.doUpdate(headerData);  
            	 
                // ICOYBDHD INSERT
				sxp = new SepoaXmlParser(this, "et_setBDHDCancelCreate");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				rtnHD = ssm.doUpdate(headerData); 
				
                rtnPRHD = et_setPRDTUPDATE_Gonggo(headerData);
            }

            
            headerData.put("BID_COUNT", Integer.parseInt(MapUtils.getString(headerData, "BID_COUNT")) -1 + "");
            headerData.put("BID_STATUS", "CC");
            int preBdDelete = delPreBdDelete(headerData);
            
            if(preBdDelete < 1){
            	throw new Exception(MapUtils.getString(headerData, "BID_COUNT") + "차수 공고 삭제 처리중 에러가 발생하였습니다.");
            }

            Map<String, String> param = new HashMap<String, String>();
			
			param.put("HOUSE_CODE", headerData.get("HOUSE_CODE"));
			param.put("BID_NO",     headerData.get("BID_NO"));
			param.put("BID_COUNT",  headerData.get("BID_COUNT"));
			
			new SMS("NONDBJOB", info).bd1Process(ctx, param);
            
            setValue(String.valueOf(rtn));
            setMessage("공고가 취소되었습니다.");
            Commit();	
           
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    }
    
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
	
	public SepoaOut setBdAnnVersion(Map< String, Object > data)
	{
		ConnectionContext ctx = getConnectionContext();
		String house_code   = info.getSession("HOUSE_CODE"); 
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;

		List< Map< String, String > >   gridData    = null;
		Map< String, String >  			gridInfo    = null;
		
		try {
			gridData    = (List< Map< String, String > >)MapUtils.getObject( data, "gridData" );
			sxp = new SepoaXmlParser(this, "setBdAnnVersion");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery()); 
			gridInfo = gridData.get(0);
			gridInfo.put("HOUSE_CODE", house_code);
			
			ssm.doUpdate(gridInfo);
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
	
	public SepoaOut setFileCopy(Map<String, String> headerData)
	{

        int rtn = 0;
        ConnectionContext ctx = getConnectionContext();
  	 
		String kr_path		= CommonUtil.getConfig("sepoa.filecopy.kr_path.GONG");// D:/bea/user_projects/domains/woori/applications/V1.0.0/wisedoc/kr/dt/bidd"; 
		String HOUSE_CODE   = info.getSession("HOUSE_CODE"); 
	//	String kr_path	= getConfig("wise.filecopy.kr_path.GONG");// D:/bea/user_projects/domains/woori/applications/V1.0.0/wisedoc/kr/dt/bidd"; 
	//	String s_kr_path	= getConfig("wise.filecopy.s_kr_path.GONG");// D:/bea/user_projects/domains/woori/applications/V1.0.0/wisedoc/s_kr/bidding"; 
	//	String s_kr_pathc	= getConfig("wise.filecopy.s_kr_pathc.GONG");// D:/bea/user_projects/domains/woori/applications/V1.0.0/wisedoc/s_kr/bidding"; 
	//	String HOUSE_CODE       = info.getSession("HOUSE_CODE"); 
	            //Logger.debug.println(info.getSession("ID"), this, "filecopy_path============>"+filecopy_path);
		SepoaSQLManager sm 	= null;
        String value 		= null;
        String next_version	= "";
        String add_path 	= "";
        String mmsg 		= "";
    		 
        StringBuffer sql = new StringBuffer();

        sql.append(" UPDATE SCODE                           \n");
        sql.append("   SET CODE		= (SELECT  to_char(max(code)+1,'FM000') as code from scode where type = 'VR001')	\n"); 
        sql.append(" WHERE HOUSE_CODE	= '"+HOUSE_CODE+"'	\n");
        sql.append("   AND TYPE		= 'VR001'				\n");

        StringBuffer sql2 = new StringBuffer();
        sql2.append(" SELECT CODE FROM SCODE 		\n");
        sql2.append(" WHERE HOUSE_CODE	= '"+HOUSE_CODE+"'	\n");
        sql2.append(" AND   TYPE	='VR001'		\n"); 
        sql2.append(" AND   USE_FLAG = 'Y'			\n");
        //sql2.append(" AND   STATUS = 'C'			\n");
	
    	try {
//    		System.out.println("headerData :: "+headerData);
    		
    		sm = new SepoaSQLManager(userid,this,ctx,sql.toString()); 
           	rtn = sm.doUpdate((String[][])null, null);
            
           	sm = new SepoaSQLManager(userid,this,ctx,sql2.toString());
           	value = sm.doSelect((String[])null);

           	SepoaFormater wf = new SepoaFormater(value);
           	next_version = wf.getValue(0,0);
 
        	copyFile(kr_path+"/bd_ann_"+headerData.get("curr_version")+".jsp", kr_path+"/bd_ann_"+next_version+".jsp"); 
        	Logger.debug.println(info.getSession("ID"), this, "bd_ann_" + next_version + ".jsp가 생성되었습니다.");
        	copyFile(kr_path+"/bd_ann_d_"+headerData.get("curr_version")+".jsp", kr_path+"/bd_ann_d_"+next_version+".jsp"); 
        	Logger.debug.println(info.getSession("ID"), this, "bd_ann_d" + next_version + ".jsp가 생성되었습니다.");
//        	copyFile(s_kr_path+"/ebd_bd_dis2_"+curr_version+".jsp", s_kr_path+"/ebd_bd_dis2_"+next_version+".jsp"); 
//	 		copyFile(s_kr_pathc+"/ebd_bd_dis2_"+curr_version+".jsp", s_kr_pathc+"/ebd_bd_dis2_"+next_version+".jsp"); 
	 	
	 		mmsg = next_version+" 버전 공고문이 생성되었습니다.";
	 	
            setStatus(1);
            setFlag(true);
            setValue(String.valueOf(rtn));  
            setMessage(mmsg); 
            Commit(); 
        } catch(Exception e) {
            try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setFlag(false);
            setMessage("복사중 오류가 발생하였습니다.");
        }
        return getSepoaOut();
    }//setFileCopy End


	private void copyFile(String source, String target){
//		try{   
			BufferedInputStream in = null;
			BufferedOutputStream out = null;
			try {
				in = new BufferedInputStream(new FileInputStream(source));
				out = new BufferedOutputStream(new FileOutputStream(target));
		
		  		int s1=0;
		  		
		  		while((s1=in.read())!=-1){
		  			out.write(s1);
		  		}
			} catch (Exception e) {
//				e.printStackTrace();
				Logger.err.println(info.getSession("ID"), this, "########## ERROR copyFile ##########");
			}
			finally {  if(in != null){ IOUtils.closeQuietly(in); } if(out != null){ IOUtils.closeQuietly(out); }
//		  		if(in != null){ in.close(); }
//		  		if(in != null){ out.close(); }
			}
//	  	}catch (Exception  e) {
////		  	System.out.println(" Error occurred: " + e.getMessage()); 
//	  		Logger.err.println(info.getSession("ID"), this, e.getMessage());
//	  	}
	}
	
	private void setBDCreateSignRequestInfo(String bd_no, String bd_count, String pflag, String subject, int itemSize) {
		String              add_user_id       =  info.getSession("ID");
        String              house_code        =  info.getSession("HOUSE_CODE");
        String              company           =  info.getSession("COMPANY_CODE");
        String              add_user_dept     =  info.getSession("DEPARTMENT");
        int                 signRtn           = 0;

        SignRequestInfo sri = new SignRequestInfo();
        sri.setHouseCode(house_code);
        sri.setCompanyCode(company);
        sri.setDept(add_user_dept);
        sri.setReqUserId(add_user_id);
        sri.setDocType("BID");
        sri.setDocNo(bd_no);
        sri.setDocSeq(bd_count);
        sri.setDocName(subject);
        sri.setItemCount(itemSize);
        sri.setSignStatus("P");
        sri.setCur("KRW");
        sri.setTotalAmt(Double.parseDouble("0"));
        sri.setSignString(pflag); // AddParameter 에서 넘어온 정보
        
        try{
        	String[]            pFlagArray           = pflag.split("$");
    		String[]            pFlagArrayFirstArray = pFlagArray[0].split("#");
    		String              fistUserId           = pFlagArrayFirstArray[1].trim();
    		Map<String, String> param                = new HashMap<String, String>();
    		ConnectionContext   ctx                  = getConnectionContext();
    	            
    		param.put("USER_ID", fistUserId);
    		param.put("BID_NO", bd_no);
    				
    		new SMS("NONDBJOB", info).bd4Process(ctx, param);
        }
        catch(Exception e){ Logger.err.println("setBDCreateSignRequestInfo: = " + e.getMessage()); }
		
        try {
        	signRtn = CreateApproval(info,sri);    //밑에 함수 실행
        	
        	if(signRtn == 0) {
//        		System.out.println("Sign Rollback!");
        		Rollback();
        	}
			
		} catch (Exception e) {
//			e.printStackTrace();
			signRtn = 0;
		}
	}

	private int CreateApproval(SepoaInfo info,SignRequestInfo sri) throws Exception
    {
        SepoaOut wo     = new SepoaOut();
        SepoaRemote ws  ;
        String nickName= "p6027";
        String conType = "NONDBJOB";
        String MethodName1 = "setConnectionContext";
        ConnectionContext ctx = getConnectionContext();

        try
        {
            Object[] obj1 = {ctx};
            String MethodName2 = "addSignRequest";
            Object[] obj2 = {sri};

            ws = new SepoaRemote(nickName,conType,info);
            ws.lookup(MethodName1,obj1);
            wo = ws.lookup(MethodName2,obj2);
        }catch(Exception e) {
//        	e.printStackTrace();
            Logger.err.println("approval: = " + e.getMessage());
        }
        return wo.status ;
    }
	
	
	
	
	 public SepoaOut setGonggoBdtm(Map<String, Object> data) throws Exception{

	  		setStatus(1);
			setFlag(true);
			ConnectionContext ctx = getConnectionContext();
			SepoaXmlParser sxp = null;
			SepoaSQLManager ssm = null;
			SepoaFormater sf = null;			
//			Message msg = null;
			int rtn=0;
			setMessage("성공적으로 처리되었습니다.");
			try {
//				msg = new Message(info, "SR_008");
				
				Map<String, String> header = MapUtils.getMap(data, "headerData");
				
//		BID_NO       
//		BID_COUNT       
//		VOTE_COUNT  
//		X_DOC_SUBMIT_DATE
//		X_DOC_SUBMIT_TIME		
//		BID_BEGIN_DATE
//		BID_BEGIN_TIME
//		BID_END_DATE
//		BID_END_TIME
//		OPEN_DATE
//		OPEN_TIME
//		O_X_DOC_SUBMIT_DATE
//		O_X_DOC_SUBMIT_TIME
//		O_BID_BEGIN_DATE
//		O_BID_BEGIN_TIME
//		O_BID_END_DATE
//		O_BID_END_TIME
//		O_OPEN_DATE
//		O_OPEN_TIME
				
				
				String BID_NO                              = header.get("BID_NO");  
				String BID_COUNT                       = header.get("BID_COUNT");  
				String VOTE_COUNT                    = header.get("VOTE_COUNT");  
				String ANN_DATE                         = header.get("ANN_DATE");
				String X_DOC_SUBMIT_DATE         = header.get("X_DOC_SUBMIT_DATE").replaceAll("/", "");  
				String X_DOC_SUBMIT_TIME	      = header.get("X_DOC_SUBMIT_TIME") + "00";  
				String BID_BEGIN_DATE                = header.get("BID_BEGIN_DATE").replaceAll("/", "");  
				String BID_BEGIN_TIME                = header.get("BID_BEGIN_TIME") + "00";  
				String BID_END_DATE                  = header.get("BID_END_DATE").replaceAll("/", "");  
				String BID_END_TIME                   = header.get("BID_END_TIME") + "00";  
				String OPEN_DATE                      = header.get("OPEN_DATE").replaceAll("/", "");  
				String OPEN_TIME                       = header.get("OPEN_TIME") + "00";  
				String O_X_DOC_SUBMIT_DATE     = header.get("O_X_DOC_SUBMIT_DATE");  
				String O_X_DOC_SUBMIT_TIME     = header.get("O_X_DOC_SUBMIT_TIME") + "00";  
				String O_BID_BEGIN_DATE             = header.get("O_BID_BEGIN_DATE");  
				String O_BID_BEGIN_TIME              = header.get("O_BID_BEGIN_TIME") + "00";  
				String O_BID_END_DATE                = header.get("O_BID_END_DATE");  
				String O_BID_END_TIME                 = header.get("O_BID_END_TIME") + "00";  
				String O_OPEN_DATE                    = header.get("O_OPEN_DATE");  
				String O_OPEN_TIME                    = header.get("O_OPEN_TIME") + "00";  
				 
//				String add_date 			= SepoaDate.getShortDateString();
//				String add_time 			= SepoaDate.getShortTimeString();
//				String add_user_id 			= info.getSession("ID");
							
				Map<String, String> map = new HashMap<String, String>();
				map.put("BID_NO", 		                     BID_NO             );
				map.put("BID_COUNT", 		             BID_COUNT          );
				map.put("VOTE_COUNT", 		         VOTE_COUNT         );
				map.put("X_DOC_SUBMIT_DATE",     X_DOC_SUBMIT_DATE );
				map.put("X_DOC_SUBMIT_TIME",     X_DOC_SUBMIT_TIME );
				map.put("BID_BEGIN_DATE", 		     BID_BEGIN_DATE );
				map.put("BID_BEGIN_TIME", 		     BID_BEGIN_TIME );
				map.put("BID_END_DATE", 		         BID_END_DATE );
				map.put("BID_END_TIME", 		         BID_END_TIME );
				map.put("OPEN_DATE", 		             OPEN_DATE );
				map.put("OPEN_TIME", 		             OPEN_TIME );
				map.put("O_X_DOC_SUBMIT_DATE", O_X_DOC_SUBMIT_DATE);
				map.put("O_X_DOC_SUBMIT_TIME", O_X_DOC_SUBMIT_TIME);
				map.put("O_BID_BEGIN_DATE", 		 O_BID_BEGIN_DATE );
				map.put("O_BID_BEGIN_TIME", 		 O_BID_BEGIN_TIME);
				map.put("O_BID_END_DATE", 		     O_BID_END_DATE  );
				map.put("O_BID_END_TIME", 		     O_BID_END_TIME);
				map.put("O_OPEN_DATE", 		         O_OPEN_DATE );
				map.put("O_OPEN_TIME", 		         O_OPEN_TIME );
				
				
				sxp = new SepoaXmlParser(this, "bdtm_getStatus");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

				String value1 = ssm.doSelect(map);
	            SepoaFormater wf1 = new SepoaFormater(value1);
	            String rtn1 = wf1.getValue(0,0);
	            if("N".equals(rtn1)){
		            throw new Exception("해당 입찰공고의 진행상태가 변경 되었습니다.");
		        }
	            
	            
	            sxp = new SepoaXmlParser(this, "bdvo_getCnt");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

				String value2 = ssm.doSelect(map);
	            SepoaFormater wf2 = new SepoaFormater(value2);
	            String rtn2 = wf2.getValue(0,0);
	            if(!"0".equals(rtn2)){
		            if( !X_DOC_SUBMIT_DATE.equals(O_X_DOC_SUBMIT_DATE) || 
		            	!BID_BEGIN_DATE.equals(O_BID_BEGIN_DATE) ||
		            	!BID_END_DATE.equals(O_BID_END_DATE) ||
		            	!OPEN_DATE.equals(O_OPEN_DATE) ||
		            	!X_DOC_SUBMIT_TIME.equals(O_X_DOC_SUBMIT_TIME) ||
		            	!BID_BEGIN_TIME.equals(O_BID_BEGIN_TIME) ){
		            		throw new Exception("투찰업체가 존재하여 입찰종료시각, 개찰시각 만 조정 가능합니다.");
		            	}		            			            			     
		        }
	            
	            
	            sxp = new SepoaXmlParser(this, "getAlarmData");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
	            
				String value3 = ssm.doSelect(map);
	            SepoaFormater wf3 = new SepoaFormater(value3);
	            int current_date = Integer.parseInt(wf3.getValue(0,0).substring(0, 8));
	            int current_time = Integer.parseInt(wf3.getValue(0,0).substring(8, 12));
	            
	            int i_ANN_DATE = Integer.parseInt(ANN_DATE);
	            int i_X_DOC_SUBMIT_DATE = Integer.parseInt(X_DOC_SUBMIT_DATE);
	            int i_X_DOC_SUBMIT_TIME = Integer.parseInt(X_DOC_SUBMIT_TIME);
	            int i_BID_BEGIN_DATE        = Integer.parseInt(BID_BEGIN_DATE   );
	            int i_BID_BEGIN_TIME        = Integer.parseInt(BID_BEGIN_TIME   );
	            int i_BID_END_DATE           = Integer.parseInt(BID_END_DATE     );
	            int i_BID_END_TIME           = Integer.parseInt(BID_END_TIME     );
	            int i_OPEN_DATE               = Integer.parseInt(OPEN_DATE        );
	            int i_OPEN_TIME               = Integer.parseInt(OPEN_TIME        );
	            
	            int i_O_X_DOC_SUBMIT_DATE = Integer.parseInt(O_X_DOC_SUBMIT_DATE);
	            int i_O_X_DOC_SUBMIT_TIME = Integer.parseInt(O_X_DOC_SUBMIT_TIME);
	            int i_O_BID_BEGIN_DATE    = Integer.parseInt(O_BID_BEGIN_DATE   );
	            int i_O_BID_BEGIN_TIME    = Integer.parseInt(O_BID_BEGIN_TIME   );
	            int i_O_BID_END_DATE      = Integer.parseInt(O_BID_END_DATE     );
	            int i_O_BID_END_TIME      = Integer.parseInt(O_BID_END_TIME     );
	            int i_O_OPEN_DATE         = Integer.parseInt(O_OPEN_DATE        );
	            int i_O_OPEN_TIME         = Integer.parseInt(O_OPEN_TIME        );
	            	          	            
	            if(i_O_X_DOC_SUBMIT_DATE != i_X_DOC_SUBMIT_DATE || i_O_X_DOC_SUBMIT_TIME != i_X_DOC_SUBMIT_TIME){	            
		            if(current_date > i_X_DOC_SUBMIT_DATE){
		            	throw new Exception("제출일자는 당일이거나 현재일자 이후만 입력가능 합니다.");
		            }else if(current_date == i_X_DOC_SUBMIT_DATE){
		            	if(current_time > i_X_DOC_SUBMIT_TIME){
		            		throw new Exception("제출시각은 현재시각보다 이후만 입력가능 합니다.");
		            	}
		            }
		            
		            if (i_X_DOC_SUBMIT_DATE > i_BID_END_DATE ) {
		            	throw new Exception("제출일자는 입찰종료일자 이전이어야 합니다.");
					} else if (i_X_DOC_SUBMIT_DATE == i_BID_END_DATE) {
						if (i_X_DOC_SUBMIT_TIME >   i_BID_END_TIME) {
							throw new Exception("제출시각은 종료시각 이전이어야 합니다.");
						}
					}	            
	            }
	            	            
	            if(i_O_BID_BEGIN_DATE != i_BID_BEGIN_DATE || i_O_BID_BEGIN_TIME != i_BID_BEGIN_TIME){	            			        
		            if (current_date > i_BID_BEGIN_DATE) {
		            	throw new Exception("입찰일시의 시작일자는 오늘보다 이후 날짜이어야 합니다.");
		    		} else if (current_date == i_BID_BEGIN_DATE) {
		    			if(current_time > i_BID_BEGIN_TIME){
		            		throw new Exception("입찰일시의 시작시각은 현재시각보다 이후여야 합니다.");
		            	}
		    		}
	            }
	            
	            if (current_date > i_BID_END_DATE) {
		            throw new Exception("입찰일시의 종료일자는 오늘보다 이후   날짜이어야 합니다.");
		    	} else if (current_date == i_BID_END_TIME) {
		    		if(current_time > i_O_BID_END_TIME){
		    			throw new Exception("입찰일시의 종료시각은 현재시각보다 이후여야   합니다.");
		            }
		    	}
	            	            
	            if (i_BID_BEGIN_DATE > i_BID_END_DATE) {
	            	throw new Exception("입찰일시의 종료일자는 시작일자보다 커야합니다.");
	    		} else if (i_BID_BEGIN_DATE == i_BID_END_DATE) {
	    			if (i_BID_BEGIN_TIME > i_BID_END_TIME ) {
	    				throw new Exception("입찰일시의 종료시각은 시작시각보다 커야합니다.");
	    			}
	    		}
	            	            	           
	            if (current_date > i_OPEN_DATE) {
	            	throw new Exception("개찰일시의 일자는 오늘보다 이후 날짜이어야 합니다.");
	    		} else if (current_date == i_OPEN_DATE) {
	    			if(current_time > i_OPEN_TIME){
	            		throw new Exception("개찰일시의 시간은 현재시간보다 이후여야 합니다.");
	            	}
	    		}
	            
	            // 공고일시 ~ 입찰서제출일시
	    		if (i_ANN_DATE > i_BID_BEGIN_DATE) {
	    			throw new Exception("입찰일시 시작일자는 공고등록일시보다  커야합니다.");
	    		}
	    		
	    		// 입찰서제출일시 ~ 개찰일시
	    		if (i_OPEN_DATE < i_BID_END_DATE) {
	    			throw new Exception("개찰일은 입찰종료일과 같거나 이후여야 합니다.");
	    		} else if (i_OPEN_DATE == i_BID_END_DATE) {
	    			if (i_OPEN_TIME < i_BID_END_TIME) {
	    				throw new Exception("개찰시각은 입찰일시 종료시각보다 이후여야 합니다.");
	    			}
	    		}
	            
				
				
				
				
				
				sxp = new SepoaXmlParser(this, "bdhd_updBdTm");
//				System.out.println(sxp.getQuery());
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				rtn = ssm.doUpdate(map);
				
				 if(rtn < 1){
		            throw new Exception("입찰시간 변경 처리중 에러가 발생하였습니다.");
		         }
				
				sxp = new SepoaXmlParser(this, "bdpg_updBdTm");
//				System.out.println(sxp.getQuery());
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				rtn = ssm.doUpdate(map);
				
				if(rtn < 1){
		            throw new Exception("입찰시간 변경 처리중 에러가 발생하였습니다.");
		        }
				
				sxp = new SepoaXmlParser(this, "bdtm_insBdtm");
//				System.out.println(sxp.getQuery());
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				rtn = ssm.doInsert(map);
				
				if(rtn < 1){
		            throw new Exception("입찰시간 변경 처리중 에러가 발생하였습니다.");
		        }
				
				Commit();
				
//				setValue(house_code);
//				setValue(con_number);
				
			} catch (Exception e) {
//				e.printStackTrace();
				Rollback();
				setStatus(0);
				setFlag(false);
				setMessage(e.getMessage());
				Logger.err.println(info.getSession("ID"), this, e.getMessage());
			} finally {
			}

			return getSepoaOut();
	  	}

	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
}//  

