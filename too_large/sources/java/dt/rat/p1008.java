package dt.rat;

//import sendmessage.sms.//sendSms;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import wisecommon.SignRequestInfo;
import wisecommon.SignResponseInfo;

/*
 ------------------------------------------------------------------------------------------------------------
 FUNCTION                        PATH (견적관리>역경매>)       JSP 파일명    DESCRIPTION
 -------------------------------------------------------------------------------------------------------------
 getPrRaStatus                   PRHD & RAHD 상태체크

 getratbdlis1_1                  역경매현황 조회               rat_bd_lis1   역경매현황 조회
 getratbdlis2_1                  역경매결과 조회               rat_bd_lis2   역경매결과 조회

 setratbdins1_1                  역경매등록                    rat_bd_ins1   역경매등록
 setratbdupd1_1                  역경매수정                    rat_bd_upd1   역경매수정
 setratbdlis1_1                  역경매삭제                    rat_bd_lis1   역경매삭제

 setratbdins4_1                  역경매개찰                    rat_bd_ins4   역경매개찰(낙찰/유찰처리)

 getratbdins1_1                  역경매등록 조회              rat_bd_ins1   역경매등록 로딩시 청구내역조회
 getratbdupd1_1                  역경매수정 조회               rat_bd_ins1   역경매수정시 기존 등록된 내용 조회
 getratbdins4_1                  역경매개찰 조회              rat_bd_ins4   역경매개찰 로딩시 역경매 내역조회
 getratpplis2_1                  역경매업체HISTORY   rat_pp_lis2   업체입찰현황조회




 setratbdlis2_1                  업체선정                       rat_bd_lis2   청구복구
 setratbdlis2_2                  업체선정                       rat_bd_lis2   결재요청

 getratbdins3_1                  역경매결과                     rat_bd_ins3   역경매결과조회
 setratbdins3_1                  역경매결과                     rat_bd_ins3   복귀


 setRaPoCreate                   역경매자동발주                               역경매자동발주
 
 getratbdRegList                 참가신청등록 조회    rat_bd_lis3
 
 getJoinVendorList               참가신청공급업체목록
 
 Approval            결재완료                                     결재완료
 --------------------------------------------------------------------------------------------------------------
*/
public class p1008 extends SepoaService
{

    String user_id      = info.getSession("ID");
    String house_code   = info.getSession("HOUSE_CODE");
    String plant_code   = info.getSession("PLANT_CODE");
    String operating_code   = info.getSession("OPERATING_CODE");
    String company_code = info.getSession("COMPANY_CODE");
    String department   = info.getSession("DEPARTMENT");
    String dept_name    = info.getSession("DEPARTMENT_NAME_LOC");
    String name_loc     = info.getSession("NAME_LOC");
    String name_eng     = info.getSession("NAME_ENG");
    String language     = info.getSession( "LANGUAGE" );
    String ctrl_code    = info.getSession( "CTRL_CODE" );
    String tel          = info.getSession( "TEL" );
    String email        = info.getSession( "EMAIL" );

    String location = info.getSession("LOCATION_CODE");
    String location_name = info.getSession("LOCATION_NAME");


    Message msg = new Message(info, "p10_app");

    public p1008(String opt,SepoaInfo info) throws SepoaServiceException
    {
        super(opt,info);
        setVersion("1.0.0");

    }

    public SepoaOut getPrRaStatus(String[] prData, String[] raData) {
        String rtn = "";
        try {
            rtn = et_getPrStatus(prData);
            if( rtn != null ){
                setValue(rtn);
            }

            rtn = et_getRaStatus(raData);
            if( rtn != null ){
                setValue(rtn);
            }

            setStatus(1);

        } catch(Exception e) {
            setStatus(0);
            setMessage(msg.getMessage("002"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }
    
    public SepoaOut getDBTime() {
    	String rtn = "";
    	try {
    		rtn = et_getDBTime();
    		if( rtn != null ){
    			setValue(rtn);
    		}
    		setStatus(1);
    		
    	} catch(Exception e) {
    		setStatus(0);
    		setMessage(msg.getMessage("002"));
    		Logger.err.println(this,e.getMessage());
    	}
    	return getSepoaOut();
    }
       

    private String et_getPrStatus(String[] prData) throws Exception {
        String rtn       = "";
        StringBuffer sql = new StringBuffer();

        ConnectionContext ctx = getConnectionContext();

        try {
            sql.append( "\n" );
            sql.append( "SELECT                                          \n" );
            sql.append( "       nvl(BID_TYPE,'') BID_TYPE                \n" );
            sql.append( "      ,BID_STATUS                               \n" );
            sql.append( "      ,DECODE(TRIM(PRHD.BID_TYPE)               \n" );
            sql.append( "              ,NULL, 'Y'                        \n" );
            sql.append( "              ,'', 'Y'                          \n" );
            sql.append( "              ,DECODE( PRHD.BID_STATUS          \n" );
            sql.append( "                      ,'AJ', 'Y'                \n" );
            sql.append( "                      ,'AC', 'Y'                \n" );
            sql.append( "                      ,'CC', 'Y'                \n" );
            sql.append( "                      ,'NB', 'Y'                \n" );
            sql.append( "                      ,'N'                      \n" );
            sql.append( "                     )                          \n" );
            sql.append( "             ) PR_STATUS                        \n" );
            sql.append( "  FROM ICOYPRHD PRHD                            \n" );
            sql.append( " <OPT=F,S> WHERE PRHD.HOUSE_CODE = ?  </OPT>    \n" );
            sql.append( " <OPT=F,S>   AND PRHD.PR_NO      = ?  </OPT>    \n" );

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());

            rtn = sm.doSelect(prData);

        } catch(Exception e) {
            Logger.debug.println(info.getSession("ID"),this,"et_getPrStatus = " + e.getMessage());
        }

        return rtn;
    }

    private String et_getRaStatus(String[] raData) throws Exception {
        String rtn       = "";
        StringBuffer sql = new StringBuffer();

        ConnectionContext ctx = getConnectionContext();

        try {
            sql.append( "\n" );
            sql.append( "SELECT                                          \n" );
            sql.append( "       STATUS                                   \n" );
            sql.append( "      ,SIGN_STATUS                              \n" );
            sql.append( "  FROM ICOYRAHD RAHD                            \n" );
            sql.append( " <OPT=F,S> WHERE RAHD.HOUSE_CODE = ?  </OPT>    \n" );
            sql.append( " <OPT=F,S>   AND RAHD.RA_NO      = ?  </OPT>    \n" );
            sql.append( " <OPT=F,S>   AND RAHD.RA_COUNT   = ?  </OPT>    \n" );

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());

            rtn = sm.doSelect(raData);

        } catch(Exception e) {
            Logger.debug.println(info.getSession("ID"),this,"et_getRaStatus = " + e.getMessage());
        }

        return rtn;
    }
    
    
    

/**
 * 역경매등록>저장
 **///dataRAHD, dataRADT, dataPRDT, dataRQSE  dataRAHD, dataRADT, dataPRDT, dataRQSE
//    public SepoaOut setratbdins1_1(String[] dataRAHD, String[][] dataRADT, String[][] dataPRDT, String[][] dataRQSE, String[][] dataBDRC, String approval_str, String sign_status, String ModifyFlag) {
	public SepoaOut setratbdins1_1(Map<String, Object> data) {
        int rtn = 0;
        
		List<Map<String, String>> grid          = null;
		Map<String, String>       gridInfo      = null;
		Map<String, String> 	  header		= null;
		header = MapUtils.getMap(data, "headerData");
        
        try {
        	
        	grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
        	
        	rtn = et_setratbdins1_1(data);

            //rtn = et_setratbdins1_1(dataRAHD, dataRADT, dataPRDT, dataRQSE, dataBDRC, approval_str, sign_status, ModifyFlag);
        	//rtn = et_setratbdins1_1(dataRAHD, dataRADT, dataPRDT, dataRQSE, dataBDRC, approval_str, sign_status, ModifyFlag);
            
            
            if (rtn < 0) { //오류 발생
                setMessage(msg.getMessage("0036"));
                setStatus(0);
            } else {
//            	setMessage("역경매요청번호 "+dataRAHD[1]+"번으로 전송되었습니다.");
            	//setMessage(msg.getMessage("0037"));
                setStatus(1);
            }
        }catch(Exception e) {
            Logger.err.println( info.getSession( "ID" ), this, "setratbdins1_1 Exception e =" + e.getMessage() );
            setStatus(0);
        }
        return getSepoaOut();
    }

/**
 * 역경매등록>생성
 **/
    private int et_setratbdins1_1(Map<String, Object> data) throws Exception
    {
        ConnectionContext 	ctx = getConnectionContext();
        SepoaSQLManager 	sm 	= null;
        /*
         * 저장 후, 추후에 다시 수정을 통하여 결재상신 할 경우
         * 기존에 있떤 RADT, RASE, RAHD 테이블의 정보를 삭제 한뒤에 생성시킨다.
         */
        int 					  row_cnt 		=  0;
        int 					  row_cnt2 		=  0;
        StringTokenizer 		  st 			= null;
        Map<String, String> 	  header		= null;
        Map<String, String> 	  gridInfo		= null;
        List<Map<String, String>> grid          = null;
		header = MapUtils.getMap(data, "headerData");
		
		header.put("house_code"		, info.getSession("HOUSE_CODE"));
		header.put("company_code"	, info.getSession("COMPANY_CODE"));
		header.put("user_id"		, info.getSession("ID"));
		header.put("name_loc"		, info.getSession("NAME_LOC"));
		header.put("name_eng"		, info.getSession("NAME_ENG"));
		header.put("department"		, info.getSession("DEPARTMENT"));
		header.put("RA_FLAG"		, "P");
		header.put("PR_NO"			, "");
		header.put("BID_COUNT"		, "1");
		header.put("type"			, "R");
		
		if(header.get("RA_COUNT") == null || "".equals(header.get("RA_COUNT"))){
			header.put("RA_COUNT", "1");
		}
		
		String RA_NO = "";
		if(header.get("RA_NO") == null || "".equals(header.get("RA_NO"))) {
			SepoaOut wo = DocumentUtil.getDocNumber(info,"RA");
			RA_NO = wo.result[0];
			
			header.put("RA_NO" , RA_NO);
			header.put("ANN_NO", RA_NO);
		}		
		
		String modifyFlag = header.get("ModifyFlag");
        
        if("M".equalsIgnoreCase(modifyFlag) || "S".equalsIgnoreCase(modifyFlag) ){
        	 int delDT          = et_delRADT(ctx, header.get("RA_NO"), header.get("RA_COUNT"));
             int delES          = et_delRASE(ctx, header.get("RA_NO"), header.get("RA_COUNT"));
             int delHD          = et_delRAHD(ctx, header.get("RA_NO"), header.get("RA_COUNT"));
        }
        
        SepoaXmlParser wxp = null;
        int rtnIns = 0;
    	
        try {
            // ICOYRAHD
            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_RAHD");
            sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            
            rtnIns = sm.doInsert(header);
            
            // UPDATE ICOYPRDT BID_STATUS : PR
            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_PRDT");
            wxp.addVar("RA_NO", header.get("RA_NO"));
            sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            rtnIns = sm.doInsert((String[][])null,null);
			
            grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
            
            // ICOYRADT
        	for(int i = 0 ; i < grid.size() ; i++){
        		gridInfo = grid.get(i);
        		
        	    Iterator value       = header.values().iterator();
        	    Iterator key         = header.keySet().iterator();
        	    Object   valueObject = null;
        	    
        	    String keyStr = "";
        	    String valStr = "";
        	   
        	    while(value.hasNext()){
        	    	valueObject = value.next();
        	    	
        	    	keyStr = key.next().toString();
        	    	if(valueObject != null){
        	    		valStr = valueObject.toString();
        	    	}
        	    	
        	    	if(gridInfo.get(keyStr) == null || gridInfo.get(keyStr).trim().equals("")){
        	    		gridInfo.put(keyStr, valStr);
        	    	}
//        	    	if(valueObject != null){
//        	    		gridInfo.put(keyStr, valueObject.toString());
//        	    	}
//        	    	else{
//        	    		gridInfo.put(key.next().toString(), "");
//        	    	}
        	    } 
        	    gridInfo.put("RA_SEQ"	, i+1+"");
        	    gridInfo.put("type"		, "R");
        	    wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_RADT");
        	    wxp.addVar("company_code", company_code);
        	    sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
        	    
        	    rtnIns = sm.doInsert(gridInfo);
        	    
           	 	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_PRDT_2");
           	 	sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
           	 	rtnIns = sm.doInsert(gridInfo);
        	}
        	
    	    // ICOYRQSE
        	if(gridInfo != null && gridInfo.get("RA_TYPE1").equals("NC")){
        		Map<String, String> rqseMap = null;
    	    	st = new StringTokenizer(header.get("vendor_values"), "#", false);
    	    	row_cnt = st.countTokens();
    	    	
    	    	if (row_cnt > 0) {
    	    		
    	    		for (int i = 0; i < row_cnt; i++) {
    	    			rqseMap = new HashMap<String, String>();
    	    			StringTokenizer st1 = new StringTokenizer(st.nextToken().trim(), "@", false);						
    	    			rqseMap.put("vendor_code"	, st1.nextToken().trim());
    	    			rqseMap.put("vendor_name"	, st1.nextToken().trim());
    	    			rqseMap.put("RA_NO"			, header.get("RA_NO"));
    	    			rqseMap.put("RA_COUNT"		, header.get("RA_COUNT"));
    	    			rqseMap.put("company_code"	, company_code);
    	    			rqseMap.put("house_code"	, house_code);
    	    			rqseMap.put("user_id"		, user_id);
    	    			
    	    			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_RQSE");
    	    			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
    	    			rtnIns = sm.doInsert(rqseMap);    	    			
    	    		}
    	    	}
    	    }        	    

            // ICOYBDRC        	
        	if(header.get("RA_TYPE1").equals("GC")){
        		Map<String, String> bdrcMap = null;
        		st = new StringTokenizer(header.get("location_values"), "#", false);
        		row_cnt2 = st.countTokens();
        		
        		if(row_cnt2 > 0){
        			
        			for(int i = 0 ; i < row_cnt2 ; i++){
        				bdrcMap = new HashMap<String, String>();
        				
        				StringTokenizer st1 = new StringTokenizer(st.nextToken().trim(), "@", false);
        				String code  = st1.nextToken().trim();
        				String name  = st1.nextToken().trim();
        				
                        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_BDRC");
                        wxp.addVar("user_id", user_id);
                        wxp.addVar("name_loc", name_loc);
                        wxp.addVar("name_eng", name_eng);
                        wxp.addVar("department", department);

                        bdrcMap.put("code"			, code);
                        bdrcMap.put("name"			, name);
                        bdrcMap.put("house_code"	, house_code);
                        bdrcMap.put("RA_NO"			, header.get("RA_NO"));
                        bdrcMap.put("RA_COUNT"		, header.get("RA_COUNT"));

                        sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
                        rtnIns = sm.doInsert(bdrcMap);
        			}
        		}
        	}
        	SepoaOut value = null;
             
        	if("P".equals(header.get("SIGN_STATUS")))
            {	
        		value = setReverseApproval(header.get("approval_str"), header.get("SIGN_STATUS"), header.get("RA_NO"),header.get("SUBJECT"),grid.size(),header.get("CUR"),header.get("RESERVE_PRICE"),header.get("RA_COUNT"));
             	                           // 결재관련                      결재상태                       역경매번호             문서제목                아이템카운트  화폐단위             총금액          				차수
            }      
        	
        	if("S".equals(modifyFlag)){
        		rtnIns = et_setStatusUpdateRAHD(ctx, header);
        		if(rtnIns < 1){
        			throw new Exception("확정처리중 오류가 발생하였습니다. \nICOYRAHD 테이블 수정실패.");
        		}
        		rtnIns = et_setPRDTUPDATE_Gonggo(ctx, MapUtils.getString(header, "RA_NO"),  MapUtils.getString(header, "RA_COUNT"), modifyFlag);
        		if(rtnIns < 1){
        			throw new Exception("확정처리중 오류가 발생하였습니다. \nICOYPRHD 테이블 수정실패.");
        		}
        	}
        	
        	Commit();
        }
        catch(Exception e) {
        	
            Rollback();
            rtnIns = -1;
            Logger.debug.println(info.getSession("ID"),this,"et_setratbdins1_1 = " + e.getMessage());
        }
        return rtnIns;
    }
    
 // 역경매 결재
    public SepoaOut setReverseApproval(String approval_str, String sign_status, String ra_no, String subject, int itemCount, String cur,String pr_tot_amt,String ra_count) throws Exception {
    
    	try {
    
    	SignRequestInfo sri = new SignRequestInfo();
    	sri.setHouseCode(house_code);
    	sri.setCompanyCode(company_code);
    	sri.setDept(department);
    	sri.setReqUserId(user_id);
    	sri.setDocType("RA");
    	sri.setDocNo(ra_no);
    	sri.setDocName(subject);
    	sri.setDocSeq(ra_count); 
    	sri.setItemCount(itemCount);
    	sri.setSignStatus(sign_status); 
    	sri.setCur(cur);
    	sri.setTotalAmt(Double.parseDouble(pr_tot_amt));
    	sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
    
    	SepoaOut wo = CreateApproval(info,sri);    //밑에 함수 실행
    	if(wo.status == 0)
    	{
    		try
    		{
    			Rollback();
    		}
    		catch(Exception d)
    		{
    			Logger.err.println(info.getSession("ID"),this,d.getMessage());
    		}
    		setStatus(0);
    		setMessage(msg.getMessage("0030"));
    		return getSepoaOut();
    	}
    	msg.setArg("RA_NO",ra_no);
    	setStatus(1);
    	setMessage("역경매요청번호 "+ra_no+"번으로 전송되었습니다.");
    	}catch(Exception e)
		{
			//if(!sign_status.equals("P")){
			try{
			Rollback();
			}catch(Exception e1){ Logger.err.println(info.getSession("ID"),this,e1.getMessage()); }
			//}
				Logger.err.println("Exception e =" + e.getMessage());
				setStatus(0);
				setMessage(msg.getMessage("4000"));
				Logger.err.println(this,e.getMessage());
	}
	return getSepoaOut();
}
    
    
	  //결재 상신을 위한 결재 공통모듈을 부른다.
	private SepoaOut CreateApproval(SepoaInfo info,SignRequestInfo sri) {
		SepoaOut wo=null;
		SepoaRemote ws = null;
		String nickName= "p6027";
		String conType = "NONDBJOB";
		String MethodName1 = "setConnectionContext";
		ConnectionContext ctx = getConnectionContext();
		try {
			Object[] obj1 = {ctx};
			String MethodName2 = "addSignRequest";
			Object[] obj2 = {sri};

			ws = new SepoaRemote(nickName,conType,info);
			ws.lookup(MethodName1,obj1);
			wo=ws.lookup(MethodName2,obj2);
		}catch(Exception e) {
			setStatus(0);
			
			Logger.err.println("approval: = " + e.getMessage());
		}
		return wo;
	}    
    
    
    
    
/**
 * 역경매수정>저장
 **/
    public SepoaOut setGonggoModify_1(String[] dataRAHD, String[][] dataRADT, String[][] dataPRDT, String[][] dataRQSE, String[][] dataBDRC) throws Exception
    {

    	int rtnIns = 0;
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        StringBuffer sql = null;

        String sendRAHD[][] = {dataRAHD};


        try {
             int delDT          = et_delRADT(ctx, dataRAHD[1], dataRAHD[2]);
             int delES          = et_delRASE(ctx, dataRAHD[1], dataRAHD[2]);
             int delHD          = et_delRAHD(ctx, dataRAHD[1], dataRAHD[2]);


             sql = new StringBuffer();
             sql.append( "INSERT INTO ICOYRAHD (                 \n" );
             sql.append( "           STATUS                      \n" );
             sql.append( "          ,ADD_DATE                    \n" );
             sql.append( "          ,ADD_TIME                    \n" );
             sql.append( "          ,CHANGE_DATE                 \n" );
             sql.append( "          ,CHANGE_TIME                 \n" );
             sql.append( "          ,HOUSE_CODE                  \n" );
             sql.append( "          ,RA_NO                       \n" );
             sql.append( "          ,RA_COUNT                    \n" );
             sql.append( "          ,COMPANY_CODE                \n" );
             sql.append( "          ,ADD_USER_ID                 \n" );
             sql.append( "          ,ADD_USER_NAME_LOC           \n" );
             sql.append( "          ,ADD_USER_NAME_ENG           \n" );
             sql.append( "          ,ADD_USER_DEPT               \n" );
             sql.append( "          ,CHANGE_USER_ID              \n" );
             sql.append( "          ,CHANGE_USER_NAME_LOC        \n" );
             sql.append( "          ,CHANGE_USER_NAME_ENG        \n" );
             sql.append( "          ,CHANGE_USER_DEPT            \n" );
             sql.append( "          ,SUBJECT                     \n" );
             sql.append( "          ,SIGN_STATUS                 \n" );
             sql.append( "          ,START_DATE                  \n" );
             sql.append( "          ,START_TIME                  \n" );
             sql.append( "          ,END_DATE                    \n" );
             sql.append( "          ,END_TIME                    \n" );
             sql.append( "          ,RA_FLAG                     \n" );
             sql.append( "          ,CREATE_TYPE                 \n" );
             sql.append( "          ,REMARK                      \n" );
             sql.append( "          ,RESERVE_PRICE               \n" );
             sql.append( "          ,CURRENT_PRICE               \n" );
             sql.append( "          ,BID_DEC_AMT                 \n" );
             sql.append( "          ,CUR                         \n" );
             sql.append( "          ,SHIPPER_TYPE                \n" );
             sql.append( "          ,PR_NO                       \n" );
             sql.append( "          ,CTRL_CODE                   \n" );
             sql.append( "          ,RA_TYPE1                    \n" );
             sql.append( "          ,RA_TYPE2                    \n" );
             sql.append( "          ,BID_COUNT                   \n" );
             sql.append( "          ,TYPE                        \n" ); //R:역경매, A:경매
             sql.append( "          ,ANN_NO                      \n" );
             sql.append( "          ,ANN_DATE                    \n" );
             sql.append( "          ,LIMIT_CRIT                  \n" );
             sql.append( "          ,PROM_CRIT                   \n" );
             sql.append( "          ,ATTACH_NO                   \n" );

            sql.append( "          ,CONT_TYPE_TEXT              \n" );
            sql.append( "          ,CONT_PLACE                  \n" );
            sql.append( "          ,BID_PAY_TEXT                \n" );
            sql.append( "          ,BID_CANCEL_TEXT             \n" );
            sql.append( "          ,BID_JOIN_TEXT               \n" );
            sql.append( "          ,RA_ETC                   	\n" );
            sql.append( "          ,FROM_LOWER_BND                   	\n" );
            sql.append( "          ,RD_DATE                   	\n" );
            sql.append( "          ,DELY_PLACE                   	\n" );

             sql.append( " ) VALUES (                            \n" );
             sql.append( "           'C'                         \n" );
             sql.append( "          ,TO_CHAR(SYSDATE,'YYYYMMDD') \n" );
             sql.append( "          ,TO_CHAR(SYSDATE,'HH24MISS') \n" );
             sql.append( "          ,TO_CHAR(SYSDATE,'YYYYMMDD') \n" );
             sql.append( "          ,TO_CHAR(SYSDATE,'HH24MISS') \n" );
             sql.append( "          ,? ,? ,? ,? ,?               \n" );
             sql.append( "          ,? ,? ,? ,? ,?               \n" );
             sql.append( "          ,? ,? ,? ,? ,?               \n" );
             sql.append( "          ,? ,? ,? ,? ,?               \n" );
             sql.append( "          ,? ,? ,? ,? ,?               \n" );
             sql.append( "          ,? ,? ,? ,? ,?               \n" );
             sql.append( "          ,? ,? ,? ,? ,?               \n" );
             sql.append( "          ,? ,? ,? ,? ,?               \n" );
             sql.append( "          ,? ,? ,? ,?,? ,?                     \n" );
             sql.append( " )                                     \n" );

             String[] type_rahd = { "S","S","S","S","S","S","S","S","S","S"
                                   ,"S","S","S","S","S","S","S","S","S","S"
                                   ,"S","S","S","S","S","S","S","S","S","S"
                                   ,"S","S","S","S","S","S","S","S","S","S"
                                   ,"S","S","S","S","S","S"};

             sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
             rtnIns = sm.doInsert(sendRAHD,type_rahd);

             // UPDATE ICOYPRDT BID_STATUS : PR
             sql = new StringBuffer();
             sql.append( "UPDATE  ICOYPRDT SET                                           \n" );
             sql.append( "   BID_TYPE   = '',                                            \n" );
             sql.append( "   BID_STATUS = 'PR'                                           \n" );
             sql.append( "  WHERE PR_NO || '^#^' || PR_SEQ    IN                         \n" );
             sql.append( "       (SELECT PR_NO || '^#^' || PR_SEQ FROM ICOYRADT          \n" );
             sql.append( "         WHERE RA_NO =  '" + dataRAHD[1] + "' )                \n" );


             sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
             rtnIns = sm.doInsert((String[][])null,null);

             // ICOYRADT
             sql = new StringBuffer();
             sql.append( "INSERT INTO ICOYRADT (                    \n" );
             sql.append( "           HOUSE_CODE                     \n" );
             sql.append( "          ,RA_NO                          \n" );
             sql.append( "          ,RA_COUNT                       \n" );
             sql.append( "          ,COMPANY_CODE                   \n" );
             sql.append( "          ,STATUS                         \n" );
             sql.append( "          ,ADD_DATE                       \n" );
             sql.append( "          ,ADD_TIME                       \n" );
             sql.append( "          ,ADD_USER_ID                    \n" );
             sql.append( "          ,ADD_USER_NAME_LOC              \n" );
             sql.append( "          ,ADD_USER_NAME_ENG              \n" );
             sql.append( "          ,ADD_USER_DEPT                  \n" );
             sql.append( "          ,CHANGE_DATE                    \n" );
             sql.append( "          ,CHANGE_TIME                    \n" );
             sql.append( "          ,CHANGE_USER_ID                 \n" );
             sql.append( "          ,CHANGE_USER_NAME_LOC           \n" );
             sql.append( "          ,CHANGE_USER_NAME_ENG           \n" );
             sql.append( "          ,CHANGE_USER_DEPT               \n" );
             sql.append( "          ,RA_SEQ                         \n" );
             sql.append( "          ,DESCRIPTION_LOC                \n" );
             sql.append( "          ,RA_QTY                         \n" );
             sql.append( "          ,UNIT_MEASURE                   \n" );
             sql.append( "          ,CUR                            \n" );
             sql.append( "          ,UNIT_PRICE                     \n" );
             sql.append( "          ,PR_NO                          \n" );
             sql.append( "          ,PR_SEQ                         \n" );
             sql.append( "          ,SETTLE_FLAG                    \n" );
             sql.append( "          ,BUYER_ITEM_NO                    \n" );
             sql.append( "          ,SPECIFICATION                    \n" );

             
             sql.append(" ) VALUES (                                                                             \n");
             sql.append("             ? ,                                -- HOUSE_CODE                           \n");
             sql.append("             ? ,                                -- RA_NO                                \n");
             sql.append("             ? ,                                -- RA_COUNT                             \n");
             sql.append("             '" + company_code + "',            -- COMPANY_CODE                         \n");
             sql.append("             'C' ,                              -- STATUS                               \n");
             sql.append("             TO_CHAR(SYSDATE,'YYYYMMDD'),       -- ADD_DATE                             \n");
             sql.append("             TO_CHAR(SYSDATE,'HH24MISS'),       -- ADD_TIME                             \n");
             sql.append("             ? ,                                -- ADD_USER_ID                          \n");
             sql.append("             ? ,                                -- ADD_USER_NAME_LOC                    \n");
             sql.append("             ? ,                                -- ADD_USER_NAME_ENG                    \n");
             sql.append("             ? ,                                -- ADD_USER_DEPT                        \n");
             sql.append("             TO_CHAR(SYSDATE,'YYYYMMDD'),       -- CHANGE_DATE                          \n");
             sql.append("             TO_CHAR(SYSDATE,'HH24MISS'),       -- CHANGE_TIME                          \n");
             sql.append("             ? ,                                -- CHANGE_USER_ID                       \n");
             sql.append("             ? ,                                -- CHANGE_USER_NAME_LOC                 \n");
             sql.append("             ? ,                                -- CHANGE_USER_NAME_ENG                 \n");
             sql.append("             ? ,                                -- CHANGE_USER_DEPT                     \n");
             sql.append("             ? ,                                -- RA_SEQ                               \n");
             sql.append("             ? ,                                -- DESCRIPTION_LOC                      \n");
             sql.append("             ? ,                                -- RA_QTY                               \n");
             sql.append("             ? ,                                -- UNIT_MEASURE                         \n");
             sql.append("             ? ,                                -- CUR                                  \n");
             sql.append("             ? ,                                -- UNIT_PRICE                           \n");
             sql.append("             ? ,                                -- PR_NO                                \n");
             sql.append("             ? ,                                -- PR_SEQ                               \n");
             sql.append("             'P'                                -- SETTLE_FLAG                          \n");
             sql.append( "          ,?  --BUYER_ITEM_NO                    \n" );
             sql.append( "          ,?  --SPECIFICATION                    \n" );

             sql.append(" )                                                                                      \n"); //SETTLE_FLAG 개찰시 Y/N

             String[] type_radt = { "S","S","S","S","S","S","S","S","S","S"
                                     ,"S","S","S","S","S","S","S","S","S","S","S"};

             sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
             rtnIns = sm.doInsert(dataRADT,type_radt);

             // ICOYRQSE
             if (dataRQSE != null) {
                 sql = new StringBuffer();
                 sql.append( "INSERT INTO ICOYRQSE               \n" );
                 sql.append( "(                                  \n" );
                 sql.append( "   HOUSE_CODE,                     \n" );
                 sql.append( "   VENDOR_CODE,                    \n" );
                 sql.append( "   RFQ_NO,                         \n" );
                 sql.append( "   RFQ_COUNT,                      \n" );
                 sql.append( "   RFQ_SEQ,                        \n" );
                 sql.append( "   COMPANY_CODE,                   \n" );
                 sql.append( "   STATUS,                         \n" );
                 sql.append( "   ADD_DATE,                       \n" );
                 sql.append( "   ADD_TIME,                       \n" );
                 sql.append( "   ADD_USER_ID,                    \n" );
                 sql.append( "   ADD_USER_NAME_LOC,              \n" );
                 sql.append( "   ADD_USER_NAME_ENG,              \n" );
                 sql.append( "   ADD_USER_DEPT,                  \n" );
                 sql.append( "   CHANGE_DATE,                    \n" );
                 sql.append( "   CHANGE_TIME,                    \n" );
                 sql.append( "   CHANGE_USER_ID,                 \n" );
                 sql.append( "   CHANGE_USER_NAME_LOC,           \n" );
                 sql.append( "   CHANGE_USER_NAME_ENG,           \n" );
                 sql.append( "   CHANGE_USER_DEPT,               \n" );
                 sql.append( "   VENDOR_NAME,                    \n" );
                 sql.append( "   BID_FLAG                        \n" );
                 sql.append( ")                                  \n" );
                 sql.append( "VALUES                             \n" );
                 sql.append( "(                                  \n" );
                 sql.append( "   ?                               \n" );//HOUSE_CODE,
                 sql.append( "  ,?                               \n" );//VENDOR_CODE,
                 sql.append( "  ,?                               \n" );//RFQ_NO,
                 sql.append( "  ,?                               \n" );//RFQ_COUNT,
                 sql.append( "  ,LPAD(1,6,0)                     \n" );//RFQ_SEQ,
                 sql.append( "  ,?                               \n" );//COMPANY_CODE,
                 sql.append( "  ,'C'                             \n" );//STATUS,
                 sql.append( "  ,TO_CHAR(SYSDATE,'YYYYMMDD')     \n" );//ADD_DATE,
                 sql.append( "  ,TO_CHAR(SYSDATE,'HH24MISS')     \n" );//ADD_TIME,
                 sql.append( "  ,?                               \n" );//ADD_USER_ID,
                 sql.append( "  ,?                               \n" );//ADD_USER_NAME_LOC,
                 sql.append( "  ,?                               \n" );//ADD_USER_NAME_ENG,
                 sql.append( "  ,?                               \n" );//ADD_USER_DEPT,
                 sql.append( "  ,TO_CHAR(SYSDATE,'YYYYMMDD')     \n" );//CHANGE_DATE,
                 sql.append( "  ,TO_CHAR(SYSDATE,'HH24MISS')     \n" );//CHANGE_TIME,
                 sql.append( "  ,?                               \n" );//CHANGE_USER_ID,
                 sql.append( "  ,?                               \n" );//CHANGE_USER_NAME_LOC,
                 sql.append( "  ,?                               \n" );//CHANGE_USER_NAME_ENG,
                 sql.append( "  ,?                               \n" );//CHANGE_USER_DEPT,
                 sql.append( "  ,?                               \n" );//VENDOR_NAME,
                 sql.append( "  ,'N'                             \n" );//BID_FLAG
                 sql.append( " )                                 \n" );

                 String[] type_rqse = { "S","S","S","S","S","S","S","S","S","S"
                                       ,"S","S","S","S"};

                 sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());
                 rtnIns = sm.doInsert(dataRQSE, type_rqse);
             }

            // ICOYBDRC
            if (dataBDRC != null) {
                sql = new StringBuffer();
		        sql.append(" INSERT INTO ICOYBDRC (                                                        \n");
		        sql.append("                         HOUSE_CODE              ,                             \n");
		        sql.append("                         BID_NO                  ,                             \n");
		        sql.append("                         BID_COUNT               ,                             \n");
		        sql.append("                         RC_CODE             ,                             \n");
		        sql.append("                         RC_NAME                  ,                             \n");
		        sql.append("                         ADD_DATE                ,                             \n");
		        sql.append("                         ADD_TIME                ,                             \n");
		        sql.append("                         ADD_USER_ID             ,                             \n");
		        sql.append("                         ADD_USER_NAME_LOC       ,                             \n");
		        sql.append("                         ADD_USER_NAME_ENG       ,                             \n");
		        sql.append("                         ADD_USER_DEPT           ,                             \n");
		        sql.append("                         CHANGE_DATE                ,                             \n");
		        sql.append("                         CHANGE_TIME                ,                             \n");
		        sql.append("                         CHANGE_USER_ID             ,                             \n");
		        sql.append("                         CHANGE_USER_NAME_LOC                ,                             \n");
		        sql.append("                         CHANGE_USER_NAME_ENG               ,                             \n");
		        sql.append("                         CHANGE_USER_DEPT                                           \n");
		        sql.append(" ) VALUES (                                                                    \n");
		        sql.append("                         ?,                                                    \n");
		        sql.append("                         ?,                                                    \n");
		        sql.append("                         ?,                                                    \n");
		        sql.append("                         ?,                                                    \n");
		        sql.append("                         ?,                                                   \n");
		        sql.append("                         TO_CHAR(SYSDATE,'YYYYMMDD'),   -- ADD_DATE            \n");
		        sql.append("                         TO_CHAR(SYSDATE,'HH24MISS'),   -- ADD_TIME            \n");
		        sql.append("                         '"+user_id+"'             ,                -- ADD_USER_ID         \n");
		        sql.append("                         '"+name_loc+"'             ,                -- ADD_USER_NAME_LOC   \n");
		        sql.append("                         '"+name_eng+"'             ,                -- ADD_USER_NAME_ENG   \n");
		        sql.append("                         '"+department+"'             ,                -- ADD_USER_DEPT       \n");
		        sql.append("                         TO_CHAR(SYSDATE,'YYYYMMDD'),   -- ADD_DATE            \n");
		        sql.append("                         TO_CHAR(SYSDATE,'HH24MISS'),   -- ADD_TIME            \n");
		        sql.append("                         '"+user_id+"'             ,                -- ADD_USER_ID         \n");
		        sql.append("                         '"+name_loc+"'             ,                -- ADD_USER_NAME_LOC   \n");
		        sql.append("                         '"+name_eng+"'             ,                -- ADD_USER_NAME_ENG   \n");
		        sql.append("                         '"+department+"'                             -- ADD_USER_DEPT       \n");
		        sql.append(" )                                                                             \n");

                String[] type_BDRC = { "S","S","S","S","S"};

                sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());
                rtnIns = sm.doInsert(dataBDRC, type_BDRC);
            }


             sql = new StringBuffer();
             sql.append("UPDATE ICOYPRDT                             \n");
             sql.append("   SET BID_TYPE   = 'R'                     \n");   // R:역경매
             sql.append( "     ,BID_STATUS = 'AR'                    \n" );  //
             sql.append("WHERE  HOUSE_CODE =  ?                      \n");
             sql.append("AND    PR_NO      =  ?                      \n");
             sql.append("AND    PR_SEQ     =  ?                      \n");


             String[] type_prdt = { "S","S","S"};

             sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());

             rtnIns = sm.doInsert(dataPRDT, type_prdt);

             Commit();
             setStatus(1);
             setValue(String.valueOf(rtnIns));
             setValue( dataRAHD[1] );
             setValue( dataRAHD[2]);
             //setValue(ANN_NO);
             //msg.setArg("ANN_NO", ANN_NO);

             setMessage(msg.getMessage("0037"));
             Commit();

       } catch(Exception e) {
           try {
               Rollback();
           } catch(Exception d) {
               Logger.err.println(userid,this,d.getMessage());
           }
           Logger.err.println(userid,this,e.getMessage());
           setStatus(0);
           setMessage(msg.getMessage("0008"));
       }
       return getSepoaOut();
       //return rtnIns;
    }


    /*
     * 역경매 RADT 테이블 삭제
     */
    private int et_delRADT(ConnectionContext ctx,
                           String RA_NO, String RA_COUNT) throws Exception
    {
        int rtn = 0;
        SepoaSQLManager sm = null;
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        try {
        	/*
            sql.append(" DELETE  FROM ICOYRADT                                              \n");
            sql.append("  WHERE HOUSE_CODE           = ?                                    \n");
            sql.append("    AND RA_NO               = ?                                     \n");
            sql.append("    AND RA_COUNT            = ?                                     \n");
			*/
            sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            
            Map<String, String> params = new HashMap<String, String>();
            params.put("house_code"	, info.getSession("HOUSE_CODE"));
            params.put("RA_NO"		, RA_NO);
            params.put("RA_COUNT"	, RA_COUNT);

            rtn = sm.doUpdate(params);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }



    /*
     * 역경매 RQSE 테이블 삭제
     */
    private int et_delRASE(ConnectionContext ctx,
                           String RA_NO, String RA_COUNT) throws Exception
    {
        int rtn = 0;

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        SepoaSQLManager sm = null;

        try {
        	/*
            sql.append(" DELETE  FROM ICOYRQSE                                              \n");
            sql.append("  WHERE HOUSE_CODE           = ?                                    \n");
            sql.append("    AND RFQ_NO               = ?                                    \n");
            sql.append("    AND RFQ_COUNT            = ?                                    \n");
			*/
            sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());

            Map<String, String> params = new HashMap<String, String>();
            params.put("house_code"	, info.getSession("HOUSE_CODE"));
            params.put("RA_NO"		, RA_NO);
            params.put("RA_COUNT"	, RA_COUNT);

            rtn = sm.doUpdate(params);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }



    /*
     * 역경매 RAHD 테이블 삭제
     */
    private int et_delRAHD(ConnectionContext ctx,
                           String RA_NO, String RA_COUNT) throws Exception
    {
        int rtn = 0;

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        SepoaSQLManager sm = null;

        try {
        	/*
            sql.append(" DELETE  FROM ICOYRAHD                                             \n");
            sql.append("  WHERE HOUSE_CODE           = ?                                   \n");
            sql.append("    AND RA_NO               = ?                                    \n");
            sql.append("    AND RA_COUNT            = ?                                    \n");
			*/
            sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());

            Map<String, String> params = new HashMap<String, String>();
            params.put("house_code"	, info.getSession("HOUSE_CODE"));
            params.put("RA_NO"		, RA_NO);
            params.put("RA_COUNT"	, RA_COUNT);

            rtn = sm.doUpdate(params);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }


	/*
	 * 역경매 삭제1
	 */
    public SepoaOut setRaDelete(Map<String, Object> data){ // 입찰공고 조회 화면에 작성중인 건으로 나타나게끔 한다.
    	
        ConnectionContext         ctx           = null;
		List<Map<String, String>> grid          = null;
		Map<String, String>       gridInfo      = null;
		String                    menuFieldCode = null;
    	
    	
        int rtn = -1;

        try {
        	
        	grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
        	ctx = getConnectionContext();
        	
        	for(int i = 0; i < grid.size(); i++) {
        		
        		gridInfo = grid.get(i);
        		gridInfo.put("HOUSE_CODE"	, info.getSession("HOUSE_CODE"));
        		gridInfo.put("COMPANY_CODE"	, info.getSession("COMPANY_CODE"));
        		gridInfo.put("DOC_TYPE"		, "RA");
				
        		rtn = et_setPRDT(ctx, gridInfo);
        		
        		rtn = et_setRaDelete(ctx, gridInfo);
        		
        		// 결재정보 삭제(결재중,결재완료라도 확정이 되기전에 삭제가 가능하므로.)
        		rtn = et_setApprovalDelete(ctx, gridInfo);
			}

            if( rtn == 0 )
                setStatus(0);
            else
                setStatus(1);

            setValue(String.valueOf(rtn));
            setMessage(msg.getMessage("0037"));

            Commit();
        }catch(Exception e){
            try {
                Rollback();
                setMessage(msg.getMessage("0004"));
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            Logger.err.println(this,e.getMessage());
            setStatus(0);
        }
        return getSepoaOut();
    }


    private int et_setPRDT(ConnectionContext ctx, Map<String, String> gridInfo) throws Exception
    {
        SepoaSQLManager sm = null;
        int rtn = 0;
        
        SepoaXmlParser wxp = null; 
        
        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

        try {
        	sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            rtn = sm.doUpdate(gridInfo);
        } catch (Exception ex) {
            Logger.debug.println("", this, "et_setPRDT = " + ex.getMessage());
            throw ex;
        }
      

        return rtn;

    }



	/*
	 * 역경매 삭제2
	 */
    private int et_setRaDelete(ConnectionContext ctx,  Map<String, String> gridInfo) throws Exception
    {
        int rtn = 0;

        SepoaSQLManager sm = null;
        //String[] type = {"S","S","S"};
        SepoaXmlParser wxp = null;
        try {

        	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");	
            
            sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            rtn = sm.doUpdate(gridInfo);


            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
            
            sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            rtn = sm.doUpdate(gridInfo);


            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
           
            sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            rtn = sm.doUpdate(gridInfo);


        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }


/**
 * 역경매현황>개찰
 **/
    public SepoaOut setratbdins4_1(Map<String, Object> data) {
        String rtn = "";
        List<Map<String, String>> 	grid 		= null;
        Map<String, String> 		gridInfo	= null;
        Map<String, String> 	  header		= null;
        
        ConnectionContext ctx = getConnectionContext();

        try {
    		
    		header = MapUtils.getMap(data, "headerData");   
        	grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
        	
        	for(int grd = 0; grd < grid.size(); grd++) {
        		
        		gridInfo = grid.get(grd);
        		
        		gridInfo.put("BID_STATUS"	, header.get("BID_STATUS"));
        		gridInfo.put("BID_SEQ"		, header.get("BID_SEQ"));
        		gridInfo.put("RA_NO"		, header.get("RA_NO"));
        		gridInfo.put("RA_COUNT"		, header.get("RA_COUNT"));
        		gridInfo.put("sr_attach_no"	, header.get("sr_attach_no"));
        		
        		
        		
        		if ("SB".equals(header.get("BID_STATUS") )) {  //낙찰
        			gridInfo.put("settle_flag"		, "Y");
        			gridInfo.put("PR_PROCEEDING_FLAG"	, "E");	// 품의 대기
        		} else {                        //유찰
        			gridInfo.put("settle_flag"		, "N");
        			gridInfo.put("PR_PROCEEDING_FLAG"	, "P");	// 구매대기
        		}
        		
        		
        		gridInfo.put("HOUSE_CODE", info.getSession("HOUSE_CODE"));
        		
        		
        		
        		String dataPRNO = "";
        		dataPRNO = getPRNO(gridInfo); 
        		SepoaFormater wf = new SepoaFormater(dataPRNO);
        		
        		if (dataPRNO != null) {
        			
        			if(wf.getRowCount() > 0){
        				for(int i=0; i<wf.getRowCount(); i++) { //데이타가 있는 경우
        					gridInfo.put("PR_NO"	, wf.getValue("PR_NO", i));
        					gridInfo.put("PR_SEQ"	, wf.getValue("PR_SEQ", i));
        					rtn = et_setratbdins4_1(gridInfo, ctx);
        				}
        			}else{
        				rtn = et_setratbdins4_1(gridInfo, ctx);
        			}
        		}
        	}

            if ("ERROR".equals(rtn)) {  //오류가 발생하였다.
                setMessage(msg.getMessage("0003"));
                setStatus(0);
            } else {
                setValue(rtn);
                setMessage("작업이 완료되었습니다.");
                setStatus(1);
//                Logger.debug.println( info.getSession( "ID" ), this, "recvPRDT[1]==============>" + recvPRDT[1] );
                /*
                if(recvPRDT[0].equals("SB")){
                    setMail_B(recvPRDT[2], recvPRDT[3], "R02", "낙찰");//역경매 낙찰시
                    RFQ_SMS_send2(recvPRDT[2], recvPRDT[3], user_id ,"R02");
                }
                */
                
                Commit();
                
                try{
    	            // SMS 전송         
//    				String[][] args = new String[1][2];
//    				args[0][0] = recvPRDT[2];	// ra_no
//    				args[0][1] = String.valueOf(recvPRDT[3]);	//ra_count
    	
//    				Object[] sms_args = {args};
//    	            ServiceConnector.doService(info, "SMS", "TRANSACTION", "S00006_1", sms_args);
    			} catch (Exception e) {
    				Logger.debug.println("mail error = " + e.getMessage());
    				
    			}
            }
        }
        catch(Exception e) {
            Logger.err.println( info.getSession( "ID" ), this, "setratbdins4_1 Exception e =" + e.getMessage() );
            setStatus(0);
        }
        return getSepoaOut();
    }


/**
 * 역경매개찰>pr no 가져요기
 **/
    private String getPRNO(Map<String, String> header) throws Exception
    {
        String value =  "";

        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        SepoaXmlParser wxp = null;
        try {
            // ICOYPRDT
        	
            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());	
            wxp.addVar("house_code"	, header.get("HOUSE_CODE"));
            wxp.addVar("ra_no"		, header.get("RA_NO"));
            wxp.addVar("ra_count"	, header.get("RA_COUNT"));
            
            
            sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            value = sm.doSelect((String[])null);

        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return value;
    }


/**
 * 역경매현황>개찰
 **/
    private String et_setratbdins4_1(Map<String, String> header, ConnectionContext ctx) throws Exception
    {
        int rtnIns = 0;
        String rtnString = "";
        SepoaSQLManager sm = null;
        SepoaXmlParser wxp = null;

        try {
            // ICOYPRDT
            
            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_PRDT");	
            sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            rtnIns = sm.doUpdate(header);

            // ICOYRAHD
            header.put("RA_FLAG"	, "C");
            header.put("user_id"	, user_id);
            header.put("name_loc"	, name_loc);
            header.put("name_eng"	, name_eng);
            header.put("department"	, department);
            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_RAHD");
            sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            rtnIns = sm.doUpdate(header);

            // ICOYRADT
            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_RADT");
            

            sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            rtnIns = sm.doUpdate(header);

            if (!"NB".equals(header.get("BID_STATUS"))) {  //유찰이 아닐때만..
                // ICOYRADT
                wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_RABD");
                sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
                rtnIns = sm.doUpdate(header);
            }

            Commit();
        }
        catch(Exception e) {
            Rollback();
            rtnString = "ERROR";
            Logger.debug.println(info.getSession("ID"),this,"et_setratbdins4_1 = " + e.getMessage());
        }

        return rtnString;
    }

/* 조회------------------------------------------------------------------------------------------*/

/**
 * 역경매현황>조회을 클릭하면 내역조회
 **/

    public SepoaOut getratbdlis1_2(Map<String, String> header) {
        try {
            String rtn = "";
            header.put("house_code", house_code);
            rtn = et_getratbdlis1_2(header);
            if (rtn == null) rtn = "";
            setValue(rtn);

            //rtn = et_getDBTime();
            setValue(rtn);

            setStatus(1);
        }catch(Exception e)
        {
            Logger.err.println("getratbdlis1_2 ======>>" + e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("002"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }
/**
 * 역경매현황>조회을 클릭하면 내역조회
 **/
private String et_getratbdlis1_2(Map<String, String> header) throws Exception {

    String rtn = "";

    ConnectionContext ctx = getConnectionContext();

    try {

    	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        
    	SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

        rtn = sm.doSelect(header);
    }catch(Exception e) {
        Logger.debug.println(info.getSession("ID"),this,"et_getratbdlis1_2 = " + e.getMessage());
    } finally{

    }
    return rtn;
}


/**
 * 역경매현황>조회을 클릭하면 내역조회
 **/

    public SepoaOut getratbdlis1_1(Map<String, String> header) {
    	
    	String rtn = "";
    	
        try {
        	rtn = et_getratbdlis1_1(header);
        	setValue(rtn);

        	rtn = et_getDBTime();
        	setValue(rtn);
            
        	setMessage(msg.getMessage("0000"));
            setStatus(1);
        }catch(Exception e){
            Logger.err.println("getratbdlis1_1 ======>>" + e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("002"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }


/**
 * 역경매현황>조회을 클릭하면 내역조회
 **/
    private String et_getratbdlis1_1(Map<String, String> header) throws Exception {

        String rtn = "";

        ConnectionContext ctx = getConnectionContext();

        try {
        	header.put("house_code", info.getSession("HOUSE_CODE"));
        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);

        	rtn = sm.doSelect(header);
        }catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
        } finally{

        }
        return rtn;
    }

/**
 * 역경매등록>로딩시 디스플레이되는 내역조회
 **/

    public SepoaOut getratbdins1_1(String[] pData) {
        String rtn = "";

        try {
            rtn = et_getratbdins1_1(pData);

            if( rtn != null ) {
                setValue(rtn);
                setStatus(1);
            }
        } catch(Exception e) {
            Logger.err.println("getratbdins1_1 ======>>" + e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("002"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }


/**
 * 역경매등록>로딩시 디스플레이되는 내역조회
 **/
    private String et_getratbdins1_1(String[] pData) throws Exception {

        String rtn = "";

        ConnectionContext ctx = getConnectionContext();

        try {
            StringBuffer sql = new StringBuffer();
            sql.append( "SELECT                                                \n" );
            sql.append( "       PRHD.VATYN                                     \n" );
            sql.append( "      ,PRHD.AMT                                       \n" );
            sql.append( "      ,PRHD.AMT    AS AMT_VAT                         \n" );
            sql.append( "  FROM ICOYPRHD PRHD                                  \n" );
            sql.append( " <OPT=F,S> WHERE PRHD.HOUSE_CODE = ? </OPT>           \n" );
            sql.append( " <OPT=F,S>   AND PRHD.PR_NO      = ? </OPT>           \n" );

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());

            rtn = sm.doSelect(pData);

        }catch(Exception e) {
            Logger.debug.println(info.getSession("ID"),this,"et_getratbdins1_1 = " + e.getMessage());
        } finally{

        }
        return rtn;
    }

/**
 * 역경매현황>수정을 클릭하면 로딩되면서 내역조회
 **/

    public SepoaOut getratbdupd1_1(String HOUSE_CODE, String RA_NO, String RA_COUNT) {

        try {
            String rtn = "";

            rtn = et_getratbdupd1_1(HOUSE_CODE , RA_NO, RA_COUNT);
            if( rtn != null ) setValue(rtn);
/*
            rtn = et_getRaSEDisplay(pData);
            if( rtn != null ) setValue(rtn);
*/
            setStatus(1);
        }catch(Exception e) {
            Logger.err.println("getratbdupd1_1 ======>>" + e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("002"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }


/**
 * 역경매현황>수정을 클릭하면 로딩되면서 내역조회
 **/
    private String et_getratbdupd1_1(String HOUSE_CODE, String RA_NO, String RA_COUNT) throws Exception {

        String rtn = "";

        ConnectionContext ctx = getConnectionContext();
        
        try {
           
        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            wxp.addVar("house_code", HOUSE_CODE);
            wxp.addVar("RA_NO", RA_NO);
            wxp.addVar("RA_COUNT", RA_COUNT);
           /* 
            sql.append( "SELECT                                                                        \n" );
            sql.append( "       RAHD.ANN_NO                                                             \n" );
            sql.append( "      ,RAHD.ANN_DATE                                                           \n" );
            sql.append( "      ,RAHD.SUBJECT                                                            \n" );
            sql.append( "      ,RAHD.RA_TYPE1                                                           \n" );
            sql.append( "      ,(select count(*)                                                        \n" );
            sql.append( "          from icoyrqse rqse                                                   \n" );
            sql.append( "         where rqse.house_code = RAHD.HOUSE_CODE                               \n" );
            sql.append( "           and rqse.rfq_no     = RAHD.RA_NO                                    \n" );
            sql.append( "           and rqse.rfq_count  = RAHD.RA_COUNT                                 \n" );
            sql.append( "           and rqse.status    != 'D'                                           \n" );
            sql.append( "       ) VENDOR_COUNT                                                          \n" );
            sql.append( "      ,RAHD.START_DATE                                                         \n" );
            sql.append( "      ,RAHD.START_TIME                                                         \n" );
            sql.append("       ,SUBSTR(START_TIME, 0, 2) AS APP_BEGIN_TIME_HOUR                         \n" );
            sql.append("       ,SUBSTR(START_TIME, 3, 2) AS APP_BEGIN_TIME_MINUTE                       \n" );
            sql.append( "      ,RAHD.END_DATE                                                           \n" );
            sql.append( "      ,RAHD.END_TIME                                                           \n" );
            sql.append("       ,SUBSTR(END_TIME, 0, 2) AS APP_END_TIME_HOUR                             \n ");
            sql.append("       ,SUBSTR(END_TIME, 3, 2) AS APP_END_TIME_MINUTE                           \n ");
            sql.append( "      ,RAHD.CUR                                                                \n" );
            sql.append( "      ,RAHD.RESERVE_PRICE                                                      \n" );
            sql.append( "      ,RAHD.BID_DEC_AMT                                                        \n" );
            sql.append( "      ,RAHD.LIMIT_CRIT                                                         \n" );
            sql.append( "      ,RAHD.PROM_CRIT                                                          \n" );
            sql.append( "      ,RAHD.REMARK                                                             \n" );
            sql.append("       ,(select NVL(count(*),0)                                                 \n" );
            sql.append("          from icomatch where doc_no = RAHD.ATTACH_NO                           \n" );
            sql.append( "       ) ATTACH_COUNT                                                          \n" );
            sql.append( "      ,NVL(RAHD.ATTACH_NO,'xxx') ATTACH_NO                                     \n" );
            sql.append( "      ,GETVENDORS2(RAHD.HOUSE_CODE, RAHD.RA_NO, RAHD.RA_COUNT) VENDOR_SELECT   \n" );
            sql.append( "      ,RAHD.CONT_TYPE_TEXT                                                     \n" );
            sql.append( "      ,RAHD.CONT_PLACE                                                         \n" );
            sql.append( "      ,RAHD.BID_PAY_TEXT                                                       \n" );
            sql.append( "      ,RAHD.BID_CANCEL_TEXT                                                    \n" );
            sql.append( "      ,RAHD.BID_JOIN_TEXT                                                      \n" );
            sql.append( "      ,RAHD.RA_ETC                                                             \n" );
            sql.append( "      ,RAHD.FROM_LOWER_BND                                                             \n" );
	        sql.append("        ,(SELECT COUNT(*) FROM ICOYBDRC                      \n");
	        sql.append("         WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'                   \n");
	        sql.append("         AND   HOUSE_CODE = RAHD.HOUSE_CODE                       \n");
	        sql.append("         AND   BID_NO     = RAHD.RA_NO                       \n");
	        sql.append("         AND   BID_COUNT  = RAHD.RA_COUNT) AS LOCATION_CNT         \n");
	        sql.append("        ,GETLOCATIONS(RAHD.HOUSE_CODE, RAHD.RA_NO, RAHD.RA_COUNT) AS LOCATION_VALUES         \n");

            sql.append( "      ,RAHD.RD_DATE                                                             \n" );
            sql.append( "      ,RAHD.DELY_PLACE                                                             \n" );
            sql.append( "      ,RAHD.OPEN_REQ_FROM_DATE                                                             \n" );
            sql.append( "      ,RAHD.OPEN_REQ_TO_DATE                                                             \n" );
            sql.append( "      ,RAHD.PROM_CRIT_TYPE                                                             \n" );

            sql.append( "  FROM ICOYRAHD RAHD                                                           \n" );
            sql.append( "  WHERE RAHD.HOUSE_CODE = '" + HOUSE_CODE + "'                                 \n" );
            sql.append( "    AND RAHD.RA_NO      = '" + RA_NO + "'                                      \n" );
            sql.append( "    AND RAHD.RA_COUNT   = '" + RA_COUNT + "'                                   \n" );

			*/
            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

            rtn = sm.doSelect((String[])null);

        }catch(Exception e) {
            Logger.debug.println(info.getSession("ID"),this,"et_getratbdupd1_1 = " + e.getMessage());
        } finally{

        }
        return rtn;
    }


/**
 * 역경매개찰>로딩시 디스플레이되는 역경매 내역조회
 **/

    public SepoaOut getratbdins4_1(String[] pData) {
        String rtn = "";

        try {
        	
        	ConnectionContext ctx = getConnectionContext();
        	
            rtn = et_getratbdins4_1(pData, ctx);

            if( rtn != null ) {
                setValue(rtn);
            }
            //rtn = et_gstRatTableData(pData);
            rtn = et_getratbdins4_2(pData, ctx);

            if( rtn != null ) {
                setValue(rtn);
            }

            setStatus(1);
        } catch(Exception e) {
            Logger.err.println("getratbdins4_1 ======>>" + e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("002"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }


/**
 * 역경매개찰>로딩시 디스플레이되는 역경매 내역조회
 **/
    private String et_getratbdins4_1(String[] pData, ConnectionContext ctx) throws Exception {

        String rtn = "";

        try {
        	
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            wxp.addVar("house_code",pData[0]);
            wxp.addVar("ra_no", pData[1]);
            wxp.addVar("ra_count", pData[2]);
          
            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

            rtn = sm.doSelect((String[])null);

        }catch(Exception e) {
        	
            Logger.debug.println(info.getSession("ID"),this,"et_getratbdins4_1 = " + e.getMessage());
        } finally{

        }
        return rtn;
    }


/**
 * 역경매개찰>로딩시 디스플레이되는 역경매 입찰내역조회
 **/
    private String et_getratbdins4_2(String[] pData, ConnectionContext ctx) throws Exception {

        String rtn = "";

        try {
        	
        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	wxp.addVar("house_code",pData[0]);
        	wxp.addVar("ra_no", pData[1]);
        	wxp.addVar("ra_count", pData[2]);
        	
        	SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

            rtn = sm.doSelect((String[])null);

        }catch(Exception e) {
            Logger.debug.println(info.getSession("ID"),this,"et_getratbdins4_2 = " + e.getMessage());
        } finally{

        }
        return rtn;
    }


/////////////////////////////////////////////









    private int et_setRaOPCreate(ConnectionContext ctx, String  ra_no,
                                                         String[][] dataOP) throws Exception
    {
        int rtn = 0;
        String settle_flag = "Y";    //초기값

        StringBuffer sql = new StringBuffer();
        sql.append(" INSERT INTO ICOYRQOP            \n");
        sql.append(" (                               \n");
        sql.append("    HOUSE_CODE,                  \n");
        sql.append("    COMPANY_CODE,                \n");
        sql.append("    OPERATING_CODE,              \n");
        sql.append("    RFQ_NO,                      \n");
        sql.append("    RFQ_COUNT,                   \n");
        sql.append("    RFQ_SEQ,                     \n");
        sql.append("    SETTLE_FLAG,                 \n");
        sql.append("    ADD_USER_ID,                 \n");
        sql.append("    ADD_DATE,                    \n");
        sql.append("    ADD_TIME,                    \n");
        sql.append("    CHANGE_USER_ID,              \n");
        sql.append("    CHANGE_DATE,                 \n");
        sql.append("    CHANGE_TIME,                 \n");
        sql.append("    STATUS                       \n");
        sql.append(" ) VALUES (                      \n");
        sql.append("    '"+house_code+"',            \n");
        sql.append("    '"+company_code+"',          \n");
        sql.append("    ?,                           \n");//OPERATING_CODE
        sql.append("    '"+ra_no+"',                 \n");
        sql.append("    '1',                         \n");
        sql.append("    to_char(?,'FM000000'),       \n"); //ra_seq
        sql.append("    '"+settle_flag+"',           \n");
        sql.append("    '"+userid+"',                \n");
        sql.append("    TO_CHAR(SYSDATE,'YYYYMMDD'), \n");
        sql.append("    TO_CHAR(SYSDATE,'HH24MISS'), \n");
        sql.append("    '"+userid+"',                \n");
        sql.append("    TO_CHAR(SYSDATE,'YYYYMMDD'), \n");
        sql.append("    TO_CHAR(SYSDATE,'HH24MISS'), \n");
        sql.append("    'C'                          \n");
        sql.append(" ) \n");

        try {
        	SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S"};

            rtn = sm.doInsert(dataOP,type);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

    private int et_setRaOPDelete(ConnectionContext ctx, String  ra_no, String ra_count, String [][]dataOP) throws Exception
    {
        int rtn = 0;

        StringBuffer sql = new StringBuffer();
        sql.append(" DELETE FROM ICOYRQOP                     \n");
        sql.append("  WHERE HOUSE_CODE   = '"+house_code+"'   \n");
        sql.append("    AND COMPANY_CODE = '"+company_code+"' \n"); // company_code
        sql.append("    AND RFQ_NO       = '"+ra_no+"'        \n");
        sql.append("    AND RFQ_COUNT    = '"+ra_count+"'     \n");
        sql.append("    AND RFQ_SEQ      = ?                  \n");

        try {
            String[][] data = new String[dataOP.length][1];

            for (int i = 0; i < dataOP.length; i++) {
                data[i][0] = dataOP[i][1];
            }

            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S"};

            rtn = sm.doDelete(data,type);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

    private int et_setPrOPCreate(ConnectionContext ctx, String  pr_no,
                            String[][] dataOP) throws Exception
    {
        int rtn = 0;

        StringBuffer sql = new StringBuffer();
        sql.append( "INSERT INTO ICOYPROP               \n" );
        sql.append( "(                                  \n" );
        sql.append( "   HOUSE_CODE,                     \n" );
        sql.append( "   COMPANY_CODE,                   \n" );
        sql.append( "   OPERATING_CODE,                 \n" );
        sql.append( "   PR_NO,                          \n" );
        sql.append( "   PR_SEQ,                         \n" );
        sql.append( "   ADD_USER_ID,                    \n" );
        sql.append( "   ADD_DATE,                       \n" );
        sql.append( "   ADD_TIME,                       \n" );
        sql.append( "   CHANGE_USER_ID,                 \n" );
        sql.append( "   CHANGE_DATE,                    \n" );
        sql.append( "   CHANGE_TIME,                    \n" );
        sql.append( "   STATUS                          \n" );
        sql.append( ")                                  \n" );
        sql.append( "VALUES                             \n" );
        sql.append( "(                                  \n" );
        sql.append( "   '"+house_code+"',               \n" );//house_code
        sql.append( "   '"+company_code+"',             \n" );//company_code
        sql.append( "   ?,                              \n" );//operating_code
        sql.append( "   '"+pr_no+"',                    \n" );//pr_no
        sql.append( "   to_char(?,'FM000000'),          \n" );//pr_seq
        sql.append( "   '"+userid+"',                   \n" );//add_user_id
        sql.append( "   to_char(sysdate,'YYYYMMDD'),    \n" );//add_date
        sql.append( "   to_char(sysdate, 'HH24MISS'),   \n" );//add_time
        sql.append( "   '"+userid+"',                   \n" );//change_user_id
        sql.append( "   to_char(sysdate,'YYYYMMDD'),    \n" );//change_date
        sql.append( "   to_char(sysdate,'HH24MISS'),    \n" );//change_time
        sql.append( "   'C'                             \n" );//status
        sql.append( "   )                               \n" );

//          Logger.debug.println(userid,this,sql.toString());
        try {
        	SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String[] type = {"S","S"};

            rtn = sm.doInsert(dataOP,type);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }


    private String et_getDBTime() throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        /*
        sql.append(" SELECT to_char(sysdate, 'YYYYMMDDHH24MISS')              \n");
        sql.append("   FROM dual                                              \n");
         */
        
        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            rtn = sm.doSelect((String[])null);
        	
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }


/**
 * 역경매현황>수정을 클릭하면 로딩되면서 내역조회
 **/
    private String et_getratbdupd1_2(String ra_no, String ra_count, String ra_seq) throws Exception {

        String rtn = "";

        ConnectionContext ctx = getConnectionContext();

        try {
            StringBuffer sql = new StringBuffer();
            sql.append( "SELECT                     \n" );
            //회사정보
            sql.append( "   RAHD.COMPANY_CODE,                              \n" );
            sql.append( "   CMGL.NAME_LOC,                                  \n" );
            sql.append( "   CMGL.ADDRESS_LOC,                               \n" );
            sql.append( "   CMGL.COUNTRY,                                   \n" );
            sql.append( "   GETICOMCODE1('100','M001',CMGL.COUNTRY),        \n" );
            sql.append( "   CMGL.CITY_CODE,                                 \n" );
            sql.append( "   CMGL.ZIP_CODE,                                  \n" );
            sql.append( "   RAHD.ADD_USER_DEPT,                             \n" );
            sql.append( "   (SELECT NAME_LOC FROM ICOMOGDP WHERE DEPT = RAHD.ADD_USER_DEPT AND COMPANY_CODE=RAHD.COMPANY_CODE),\n" );
            sql.append( "   RAHD.ADD_USER_ID,               \n" );
            sql.append( "   RAHD.ADD_USER_NAME_LOC,                         \n" );
            sql.append( "   RAHD.TEL_NO,                                    \n" );
            sql.append( "   RAHD.EMAIL,                                     \n" );
            //품번정보
            sql.append( "   RADT.BUYER_ITEM_NO,                             \n" );
            sql.append( "   RADT.DESCRIPTION_LOC,                           \n" );
            sql.append( "   RADT.UNIT_MEASURE,                              \n" );
            sql.append( "   RADT.RA_QTY,                                    \n" );
            sql.append( "   RADT.RD_DATE,                                   \n" );
            sql.append( "   RADT.SPECIFICATION,                             \n" );
            sql.append( "   RADT.COMPANY_CODE,                          \n" );
            sql.append( "   RADT.DELY_TO_ADDRESS||'/'||                           \n" );
            sql.append( "       DECODE(NVL((SELECT MAX(NAME_LOC)                    \n" );
            sql.append( "                    FROM ICOMOGDP                                   \n" );
            sql.append( "                    WHERE HOUSE_CODE = '"+house_code+"'     \n" );
            sql.append( "                    AND DEPT = RADT.DELY_TO_ADDRESS  ),'N'),'N',(SELECT MAX(STR_NAME_LOC)   \n" );
            sql.append( "                                                                FROM ICOMOGSL              \n" );
            sql.append( "                                                                WHERE HOUSE_CODE = '"+house_code+"'  \n" );
            sql.append( "                                                                AND STR_CODE = RADT.DELY_TO_ADDRESS ),(SELECT MAX(NAME_LOC)  \n" );
            sql.append( "                                                                                                     FROM ICOMOGDP         \n" );
            sql.append( "                                                                                                     WHERE HOUSE_CODE = '"+house_code+"'  \n" );
            sql.append( "                                                                                                     AND DEPT = RADT.DELY_TO_ADDRESS   )),  \n" );

            //역경매정보
            sql.append( "   RAHD.SUBJECT,                                   \n" );
            sql.append( "   RAHD.START_DATE,                \n" );
            sql.append( "   SUBSTR(RAHD.START_TIME,0,2),                    \n" );
            sql.append( "   SUBSTR(RAHD.START_TIME,3,2),                    \n" );
            sql.append( "   RAHD.END_DATE,                  \n" );
            sql.append( "   SUBSTR(RAHD.END_TIME,0,2),                      \n" );
            sql.append( "   SUBSTR(RAHD.END_TIME,3,2),                      \n" );
            sql.append( "   GETICOMCODE2('"+house_code+"','M010',RADT.PAY_TERMS) PAY_TERMS, \n" );
//          sql.append( "   RADT.PAY_TERMS,                                 \n" );
            sql.append( "   RADT.TOD_1,                                     \n" );
            sql.append( "   RADT.TOD_2,                                     \n" );
            sql.append( "   RADT.TOD_3,                                     \n" );
            sql.append( "       GETICOMCODE2('"+house_code+"','M009',RADT.DELY_TERMS) DELY_TERMS,  \n" );
//          sql.append( "   RADT.DELY_TERMS,                                \n" );
            sql.append( "   RADT.SHIPPING_METHOD,                           \n" );
            sql.append( "   RADT.ARRIVAL_PORT,                              \n" );
            sql.append( "   RADT.ARRIVAL_PORT_NAME,                         \n" );
            sql.append( "   RAHD.PARTIAL_BID_FLAG,                          \n" );
            sql.append( "   RAHD.CUR,                                       \n" );
            sql.append( "   RAHD.RESERVE_PRICE,                             \n" );
            sql.append( "   RAHD.BID_DEC_AMT,                               \n" );
            sql.append( "   RAHD.RA_TYPE1,                                  \n" );
            sql.append( "   RAHD.RA_TYPE2,                                  \n" );
            sql.append( "   RAHD.REMARK,                                    \n" );
            sql.append("    (select NVL(count(*),0) from icomatch where doc_no = RADT.ATTACH_NO), \n");
            sql.append( "   RADT.ATTACH_NO,                                 \n" );

            sql.append( "   (SELECT COUNT(*)                \n" );
            sql.append( "   FROM ICOYRQSE RQSE              \n" );
            sql.append( "   WHERE RQSE.HOUSE_CODE='"+house_code+"'      \n" );
            sql.append( "   AND RQSE.RFQ_NO = '"+   ra_no+"'        \n" );
            sql.append( "   AND RQSE.RFQ_COUNT = '"+ra_count+"'         \n" );
            sql.append( "   AND RQSE.RFQ_SEQ = RADT.RA_SEQ ),       \n" );

            //사업장 추가(품번정보)
//          sql.append( "   DECODE(RADT.OPERATING_CODE,'I','인천','P','포항','')            \n" );
            sql.append( "   NVL(GETMULTIrqOPCODE(RADT.HOUSE_CODE,RADT.COMPANY_CODE,RADT.RA_NO,RADT.RA_COUNT,RADT.RA_SEQ),'') TOT_OP, \n" );
            sql.append( "   RAHD.SHIPPER_TYPE,                              \n" );
            sql.append( "   RAHD.CREATE_TYPE,                                \n" );
            sql.append( "   RADT.VALID_FROM_DATE,                                \n" );
            sql.append( "   RADT.VALID_TO_DATE                                \n" );

            sql.append( "FROM    ICOYRAHD RAHD, ICOYRADT RADT, ICOMCMGL CMGL\n" );
            sql.append( "WHERE   RAHD.HOUSE_CODE = RADT.HOUSE_CODE          \n" );
            sql.append( "  AND   RAHD.HOUSE_CODE = CMGL.HOUSE_CODE          \n" );
            sql.append( "  AND   RAHD.HOUSE_CODE = '"+house_code+"'         \n" );
            sql.append( "  AND   RAHD.COMPANY_CODE = CMGL.COMPANY_CODE      \n" );
            sql.append( "  AND   RAHD.RA_NO = RADT.RA_NO                    \n" );
            sql.append( "  AND   RAHD.RA_COUNT = RADT.RA_COUNT              \n" );
            sql.append( "  AND   RAHD.RA_NO = '"+ra_no+"'                   \n" );
            sql.append( "  AND   RAHD.RA_COUNT = '"+ra_count+"'             \n" );
            sql.append( "  AND   RAHD.TYPE = 'R'                            \n" );
            sql.append( "  AND   RADT.RA_SEQ = '"+ra_seq+"'                 \n" );
            //sql.append( "  AND  ( RAHD.RA_FLAG = 'T' OR RAHD.BID_COUNT = 0 OR RAHD.BID_COUNT IS NULL) \n" );

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());

            //Logger.debug.println(info.getSession("ID"),this,"query start");
            rtn = sm.doSelect((String[])null);
        }catch(Exception e) {
            Logger.debug.println(info.getSession("ID"),this,"et_getratbdupd1_2 = " + e.getMessage());
        } finally{

        }
        return rtn;
    }


/**
 * 업체선정리스트>조회을 클릭하면 내역조회
 **/

    public SepoaOut getratbdlis2_1(Map<String, String> header) {

        try {

            String rtn = "";
            
            header.put("HOUSE_CODE", info.getSession("HOUSE_CODE"));

            rtn = et_getratbdlis2_1(header);

            if( rtn != null ) {
                setValue(rtn);
                setStatus(1);
            }
        } catch(Exception e) {
            Logger.err.println("getratbdlis2_1 ======>>" + e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("002"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }


/**
 * 업체선정리스트>조회을 클릭하면 내역조회
 **/
    private String et_getratbdlis2_1(Map<String, String> header) throws Exception {
        String rtn = "";

        ConnectionContext ctx = getConnectionContext();

        try {
        	
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

            rtn = sm.doSelect(header);

        }catch(Exception e) {
            Logger.debug.println(info.getSession("ID"),this,"et_getratbdlis2_1 = " + e.getMessage());
        } finally{

        }
        return rtn;
    }


/**
 * 업체선정>로딩시 내역조회
 **/

    public SepoaOut getratppins1_1(String ra_no, String ra_count, String ra_seq) {

        try {

            String rtn = "";

            rtn = et_getratppins1_1(ra_no,ra_count,ra_seq);

            if( rtn != null )
            {
                setValue(rtn);
                setStatus(1);
            }
        }catch(Exception e)
        {
            Logger.err.println("getratppins1_1 ======>>" + e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("002"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }


/**
 * 업체선정>로딩시 내역조회
 **/
    private String et_getratppins1_1(String ra_no, String ra_count, String ra_seq) throws Exception {

        String rtn = "";

        ConnectionContext ctx = getConnectionContext();

        try {


            /*Logger.debug.println(user_id,this,"ra_no ==============>>" + ra_no);
            Logger.debug.println(user_id,this,"ra_count ==============>>" + ra_count);
            Logger.debug.println(user_id,this,"ra_seq ==============>>" + ra_seq);*/


            StringBuffer sql = new StringBuffer();

            sql.append( "SELECT                                                                         \n" );
            sql.append( "   VENDOR_CODE,                                                                \n" );
            sql.append( "   MIN((SELECT NAME_LOC FROM ICOMVNGL WHERE VENDOR_CODE = RABD.VENDOR_CODE)),  \n" );
            sql.append( "   MIN(RABD.VENDOR_ITEM_NO),                                                   \n" );
            sql.append( "   MIN(RABD.CUR),                                                              \n" );
            sql.append( "   MIN(BID_PRICE),                                                             \n" );
            sql.append( "   MIN(RABD.UNIT_MEASURE),                                                     \n" );
            sql.append( "   MIN(BID_QTY),                                                               \n" );
            sql.append( "   MIN(ARRIVAL_PORT_NAME),                                                     \n" );
            sql.append( "   MAX(TO_NUMBER(RABD.BID_SEQ))                                                \n" );
            sql.append( "FROM   ICOYRABD RABD, ICOYRADT RADT                                            \n" );
            sql.append( "WHERE  RABD.HOUSE_CODE = RADT.HOUSE_CODE                                       \n" );
            sql.append( "AND    RABD.RA_NO = RADT.RA_NO                                                 \n" );
            sql.append( "AND    RABD.RA_NO = '"+ra_no+"'                                                \n" );
            sql.append( "AND    RABD.RA_COUNT = RADT.RA_COUNT                                           \n" );
            sql.append( "AND    RABD.RA_COUNT = '"+ra_count+"'                                          \n" );
            sql.append( "AND    RABD.RA_SEQ = RADT.RA_SEQ                                               \n" );
            sql.append( "AND    RABD.RA_SEQ = '"+ra_seq+"'                                              \n" );
            sql.append( "GROUP BY RABD.RA_NO, RABD.RA_COUNT, RABD.RA_SEQ, RABD.VENDOR_CODE              \n" );


            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());


            rtn = sm.doSelect((String[])null);


        }catch(Exception e) {
            Logger.debug.println(info.getSession("ID"),this,"et_getratppins1_1 = " + e.getMessage());
        } finally{

        }
        return rtn;
    }


/**
 * 업체선정>낙찰
 **/
    public SepoaOut setratppins1_1( String[] pData ) {

        String rtn = "";
        int    rtnIns = 0;

        try {
            //낙찰
            rtn = et_setratppins1_1(pData);

            Logger.err.println( info.getSession( "ID" ), this, "setratppins1_1 ===>"+rtn );
            //setValue(" 성공적으로 작업을 수행했습니다. ");

            if ("ERROR".equals(rtn))  //오류가 발생하였다.
            {
                setMessage(msg.getMessage("002"));
                setStatus(0);
            }
            else
            {
                setValue(rtn);
                setStatus(1);
            }

        }catch(Exception e)
        {
            Logger.err.println( info.getSession( "ID" ), this, "setratppins1_1 Exception e =" + e.getMessage() );
            setStatus(0);

        }
        return getSepoaOut();
    }


/**
 * 업체선정>낙찰
 **/
    private String et_setratppins1_1( String[] pData ) throws Exception
    {

        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;

        StringBuffer sql = null;

            String rtnString = "";

        int rtnIns = 0;


        try {

            int j=0;

                String ra_no        = pData[j++];
                String ra_count     = pData[j++];
                String ra_seq       = pData[j++];
                String vendor_code  = pData[j++];
                String bid_qty      = pData[j++];


                sql = new StringBuffer();
                sql.append( "UPDATE ICOYRABD                            \n" );
                sql.append( "  SET  SETTLE_FLAG = 'Y',                  \n" );
                sql.append( "       SETTLE_QTY = "+bid_qty+"            \n" );
                sql.append( "WHERE  HOUSE_CODE = '"+house_code+"'       \n" );
                sql.append( "  AND  RA_NO = '"+ra_no+"'                 \n" );
                sql.append( "  AND  RA_COUNT = '"+ra_count+"'           \n" );
                sql.append( "  AND  RA_SEQ = '"+ra_seq+"'               \n" );
                sql.append( "  AND  VENDOR_CODE = '"+vendor_code+"'     \n" );
                sql.append( "  AND   BID_PRICE =                        \n" );
                sql.append( "  (SELECT    MIN(BID_PRICE)                \n" );
                sql.append( "  FROM ICOYRABD WHERE                      \n" );
                sql.append( "         HOUSE_CODE = '"+house_code+"'     \n" );
                sql.append( "  AND    RA_NO = '"+ra_no+"'               \n" );
                sql.append( "  AND    RA_COUNT = '"+ra_count+"'         \n" );
                sql.append( "  AND    RA_SEQ = '"+ra_seq+"'             \n" );
                sql.append( "  AND    VENDOR_CODE = '"+vendor_code+"'   \n" );
                sql.append( "  )                                        \n" );

            sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());
            rtnIns = sm.doInsert((String[][])null, null);

            Commit();

        }
        catch(Exception e) {
            Rollback();
            rtnString = "ERROR";
            Logger.debug.println(info.getSession("ID"),this,"et_setratppins1_1 = " + e.getMessage());

        }

        return rtnString;
    }




/**
 * 역경매결과>역경매결과내역조회
 **/

    public SepoaOut getratbdins3_1(String[] pData) {

        try {
            String from_date    = pData[0];
            String to_date      = pData[1];
            String ra_no        = pData[2];
            String add_user_dept    = pData[3];
            String add_user_id  = pData[4];
            String sign_status  = pData[5];
            String vendor_code  = pData[6];

            String rtn = "";
            String txtpurchaser = "";
            rtn = et_getratbdins3_1(from_date,to_date,ra_no,add_user_dept,add_user_id,sign_status,vendor_code);

            if(!"".equals(add_user_id))
            txtpurchaser = getctrlcode(add_user_id);

            if( rtn != null )
            {
                setValue(rtn);
                setValue(txtpurchaser);
                setStatus(1);
            }
        }catch(Exception e)
        {
            Logger.err.println("getratbdins3_1 ======>>" + e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("002"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }


/**
 * 역경매결과>역경과결과내역조회
 **/
    private String et_getratbdins3_1(String from_date,String to_date,String ra_no,String add_user_dept,String purchaserUser,String sign_status,String vendor_code) throws Exception {

        /////////////////////// 직무 코드 관련 처리
        //입력된 직무코드 가 세션상의 직무 코드에 속하면 where 절에 세션사의 직무 코드가 들어가며 그렇지 않으면 입력된 직무코드가 들어간다.

        boolean flag = false;

        StringTokenizer st = new StringTokenizer(ctrl_code,"&",false);
        int count =  st.countTokens();

        for( int i =0; i< count; i++ )
        {
            String tmp_ctrl_code = st.nextToken();
            if( purchaserUser.equals(tmp_ctrl_code) ){
                flag = true;

                Logger.debug.println(info.getSession("ID"),this,"============================same ctrl_code");
                break;
            }
            else
                Logger.debug.println(info.getSession("ID"),this,"============================== not same ctrl_code");

        }


        String purchaserUser_seperate="";

        if( flag == true )
        {
            StringTokenizer st1 = new StringTokenizer(ctrl_code,"&",false);
            int count1 =  st1.countTokens();

            for( int i =0; i< count1; i++ )
            {
                String tmp_ctrl_code = st1.nextToken();

                if( i == 0 )
                    purchaserUser_seperate = tmp_ctrl_code;
                else
                    purchaserUser_seperate += "','"+tmp_ctrl_code;

            }
        }
        else
        {
            purchaserUser_seperate = purchaserUser;
        }


        //////////////////////////직무 코드 관련 처리 끝

        String rtn = "";

        ConnectionContext ctx = getConnectionContext();

        try {

            StringBuffer sql = new StringBuffer();

            sql.append( "SELECT                            \n" );
            sql.append( "   RAHD.RA_NO,                                            \n" );//역경매번호
            //sql.append( " DECODE(RAHD.SIGN_STATUS,'P','결재진행','R','결재반려','C','결재완료'),      \n" );//상황
            sql.append( "   DECODE(RAHD.SIGN_STATUS,'R','낙찰취소','C','낙찰'),      \n" );//상황
            sql.append( "   RAHD.RA_COUNT,                                         \n" );//차수
            sql.append( "   RAHD.SUBJECT,                                          \n" );//제목
            sql.append( "   RADT.BUYER_ITEM_NO,                                    \n" );//품번
            sql.append( "   RADT.DESCRIPTION_LOC,                                  \n" );//품명
            //sql.append( " RABD.VENDOR_CODE,                                      \n" );//선정                                                                                                                                                                                                           업체
            sql.append( "   (SELECT NAME_LOC FROM ICOMVNGL WHERE HOUSE_CODE = '"+house_code+"'  AND VENDOR_CODE = RABD.VENDOR_CODE ),  \n"); //선정업체

            sql.append( "   RAHD.BID_COUNT,                                        \n" );//입찰수
            sql.append( "   RAHD.END_DATE,                                         \n" );//마감일
            sql.append( "   RADT.CUR,                                              \n" );//화폐                                                                                                                                                                                                           낙찰가
            sql.append( "   RABD.BID_PRICE,                                        \n" );//낙찰가
            sql.append( "   RAHD.RESERVE_PRICE,                                    \n" );//시작가
            sql.append( "   RADT.PR_NO,                                          \n" ); //pr_no

            sql.append( "   RADT.RA_SEQ,                                           \n" );
            sql.append( "   RAHD.CTRL_CODE,                                        \n" );
            sql.append( "   RAHD.SIGN_STATUS,                                      \n" );
            sql.append( "   RAHD.RA_FLAG,                                          \n" );
            sql.append( "   RAHD.RA_TYPE2                                        \n" );

            sql.append( "FROM   ICOYRAHD RAHD, ICOYRADT RADT, ICOYRABD RABD    \n" );
            sql.append( "WHERE  RAHD.HOUSE_CODE = RADT.HOUSE_CODE              \n" );
            sql.append( "AND    RAHD.HOUSE_CODE = RABD.HOUSE_CODE              \n" );
            sql.append( "AND    RAHD.HOUSE_CODE = '"+house_code+"'             \n" );
            sql.append( "AND    RAHD.RA_NO = RADT.RA_NO                        \n" );
            sql.append( "AND    RAHD.RA_NO = RABD.RA_NO                        \n" );
            sql.append( "AND    RAHD.RA_COUNT = RADT.RA_COUNT                  \n" );
            sql.append( "AND    RAHD.RA_COUNT = RABD.RA_COUNT                  \n" );
            sql.append( "AND    RAHD.TYPE = 'R'                                \n" );
            sql.append( "AND    RADT.RA_SEQ = RABD.RA_SEQ                      \n" );
            sql.append( "AND    RABD.SETTLE_FLAG = 'Y'                         \n" );
            sql.append( "AND    RAHD.SIGN_STATUS IN  ('C','R')                 \n" );
            sql.append( "AND    RAHD.STATUS <> 'D'              \n" );
            sql.append( "<OPT=S,S>AND   RAHD.ADD_DATE BETWEEN ? </OPT>         \n" );
            sql.append( "<OPT=S,S>AND       ?           </OPT>         \n" );
            sql.append( "<OPT=S,S>AND   RAHD.RA_NO = ?      </OPT>         \n" );
            sql.append( "<OPT=S,S>AND   RAHD.ADD_USER_DEPT = ?  </OPT>         \n" );
            //sql.append( "<OPT=S,S>AND RAHD.ADD_USER_ID = ?    </OPT>         \n" );

            //sql.append( "<OPT=S,S>AND RAHD.CTRL_CODE = ?  </OPT>         \n" );
            //if (!purchaserUser_seperate.equals("")) sql.append( "          AND  RAHD.CTRL_CODE IN ( '"+purchaserUser_seperate+"' )          \n" );

            sql.append( "<OPT=S,S>AND   RAHD.SIGN_STATUS = ?    </OPT>         \n" );
            sql.append( "<OPT=S,S>AND   RABD.VENDOR_CODE = ?    </OPT>         \n" );


            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());
            //String[] args = {from_date, to_date, ra_no, add_user_dept, add_user_id, sign_status, vendor_code };
            String[] args = {from_date, to_date, ra_no, add_user_dept,  sign_status, vendor_code };

            rtn = sm.doSelect(args);


        }catch(Exception e) {
            Logger.debug.println(info.getSession("ID"),this,"et_getratbdins3_1 = " + e.getMessage());
        } finally{

        }
        return rtn;
    }



/** 직무 담당자명 구하기
 */
    private String getctrlcode(String ctrl_code) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sql = new StringBuffer();
        sql.append(" SELECT CTRL_PERSON_NAME_LOC FROM ICOMBACP \n");
        sql.append(" WHERE HOUSE_CODE = '"+house_code+"' \n");
        //sql.append(" AND   CTRL_CODE = '"+ctrl_code+"' \n");
        sql.append(" AND   CTRL_TYPE = 'P' \n");
        sql.append(" AND   ROWNUM = 1 \n");

        try{
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            rtn = sm.doSelect((String[])null);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }


/**
 * 역경매결과>복귀
 **/
    public SepoaOut setratbdins3_1( String[][] pData ) {
        String rtn = "";

        try {

            rtn = et_setratbdins3_1(pData);

            //Logger.err.println( info.getSession( "ID" ), this, "setratbdins3_1 ===>"+rtn );
            //setValue(" 성공적으로 작업을 수행했습니다. ");

            if ("ERROR".equals(rtn))  //오류가 발생하였다.
            {
                setMessage(msg.getMessage("0003"));
                setStatus(0);
            }
            else
            {
                setValue(rtn);
                setStatus(1);
            }

        }catch(Exception e)
        {
            Logger.err.println( info.getSession( "ID" ), this, "setratbdins3_1 Exception e =" + e.getMessage() );
            setStatus(0);

        }
        return getSepoaOut();
    }


/**
 * 역경매결과>복귀
 **/
    private String et_setratbdins3_1( String[][] pData ) throws Exception
    {

        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;

        StringBuffer sql = null;

            String rtnString = "";

        int rtnIns = 0;


        try {


                        for ( int k = 0 ; k < pData.length ; k++ )
                        {
                            int j = 0;

                            String ra_no        = pData[k][j++];
                    String ra_count     = pData[k][j++];
                    String ra_seq       = pData[k][j++];
                    String sign_status  = pData[k][j++];
                    String ra_flag      = pData[k][j++];
                    String vendor_code  = pData[k][j++];


                                sql = new StringBuffer();
                sql.append( "UPDATE ICOYRAHD                \n" );
                sql.append( "  SET  SIGN_STATUS = 'T',                      \n" );
                sql.append( "       RA_FLAG = 'P'               \n" );
                sql.append( "WHERE  HOUSE_CODE = '"+house_code+"'           \n" );
                sql.append( "  AND  RA_NO = '"+ra_no+"'                     \n" );
                sql.append( "  AND  RA_COUNT = '"+ra_count+"'               \n" );
                sql.append( "  AND  SIGN_STATUS = '"+sign_status+"'     \n" );
                sql.append( "  AND  RA_FLAG = '"+ra_flag+"'         \n" );

                    sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());
                rtnIns = sm.doInsert((String[][])null, null);

                sql = new StringBuffer();
                sql.append( "UPDATE ICOYRABD                \n" );
                sql.append( "  SET  SETTLE_FLAG = 'N',          \n" );
                sql.append( "       SETTLE_QTY  = ''            \n" );
                sql.append( "WHERE  HOUSE_CODE = '"+house_code+"'       \n" );
                sql.append( "  AND  RA_NO = '"+ra_no+"'         \n" );
                sql.append( "  AND  RA_COUNT = '"+ra_count+"'       \n" );
                sql.append( "  AND  RA_SEQ = '"+ra_seq+"'           \n" );
                sql.append( "  AND  VENDOR_CODE = '"+vendor_code+"'     \n" );

                sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());
                rtnIns = sm.doInsert((String[][])null, null);


                        }//end of for

            Commit();

        }
        catch(Exception e) {
            Rollback();
            rtnString = "ERROR";
            Logger.debug.println(info.getSession("ID"),this,"et_setratbdins3_1 = " + e.getMessage());
        }

        return rtnString;
    }


/**
 * 업체선정리스트>청구복구
 **/
    public SepoaOut setratbdlis2_1( String[][] pData ) {
        String rtn = "";

        try {

            rtn = et_setratbdlis2_1(pData);

            Logger.err.println( info.getSession( "ID" ), this, "et_setratbdlis2_1 ===>"+rtn );
            //setValue(" 성공적으로 작업을 수행했습니다. ");

            if ("ERROR".equals(rtn))  //오류가 발생하였다.
            {
                setMessage(msg.getMessage("0003"));
                setStatus(0);
            }
            else
            {
                setValue(rtn);
                setStatus(1);
            }

        }catch(Exception e)
        {
            Logger.err.println( info.getSession( "ID" ), this, "setratbdlis2_1 Exception e =" + e.getMessage() );
            setStatus(0);

        }
        return getSepoaOut();
    }


/**
 * 업체선정리스트>청구복구
 **/
    private String et_setratbdlis2_1( String[][] pData ) throws Exception
    {

        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;

        StringBuffer sql = null;

            String rtnString = "";

        int rtnIns = 0;


        try {


                        for ( int k = 0 ; k < pData.length ; k++ )
                        {
                            int j = 0;

                            String ra_no        = pData[k][j++];
                    String ra_count     = pData[k][j++];
                    String ra_seq       = pData[k][j++];
                    String pr_no        = pData[k][j++];
                    String pr_seq       = pData[k][j++];


                                sql = new StringBuffer();
                sql.append( "UPDATE ICOYRAHD                \n" );
                sql.append( "  SET  STATUS = 'D'                           \n" );
                sql.append( "WHERE  HOUSE_CODE = '"+house_code+"'          \n" );
                sql.append( "  AND  RA_NO = '"+ra_no+"'                   \n" );
                sql.append( "  AND  RA_COUNT = '"+ra_count+"'              \n" );

                    sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());
                rtnIns = sm.doInsert((String[][])null, null);

                sql = new StringBuffer();
                sql.append( "UPDATE ICOYRADT                               \n" );
                sql.append( "  SET      STATUS = 'D'                   \n" );
                sql.append( "WHERE  HOUSE_CODE = '"+house_code+"'          \n" );
                sql.append( "  AND  RA_NO = '"+ra_no+"'                   \n" );
                sql.append( "  AND  RA_COUNT = '"+ra_count+"'              \n" );
                sql.append( "  AND  RA_SEQ = '"+ra_seq+"'                  \n" );

                sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());
                rtnIns = sm.doInsert((String[][])null, null);

                sql = new StringBuffer();

                sql.append( "UPDATE ICOYRQSE                               \n" );
                sql.append( "  SET  STATUS = 'D'                           \n" );
                sql.append( "WHERE  HOUSE_CODE = '"+house_code+"'          \n" );
                sql.append( "  AND  RFQ_NO = '"+ra_no+"'                  \n" );
                sql.append( "  AND  RFQ_COUNT = '"+ra_count+"'             \n" );
                sql.append( "  AND  RFQ_SEQ = '"+ra_seq+"'                 \n" );
                sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());
                rtnIns = sm.doInsert((String[][])null, null);

                sql = new StringBuffer();

                sql.append( "UPDATE     ICOYPRDT                               \n" );
                sql.append( "  SET  PROCEEDING_FLAG = 'P'                  \n" );
                sql.append( "WHERE  HOUSE_CODE = '"+house_code+"'          \n" );
                sql.append( "AND    PR_NO  = '"+pr_no+"'                   \n" );
                sql.append( "AND    PR_SEQ  = '"+pr_seq+"'                 \n" );

                sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());
                rtnIns = sm.doInsert((String[][])null, null);


                        }//end of for

            Commit();
        }
        catch(Exception e) {
            Rollback();
            rtnString = "ERROR";
            Logger.debug.println(info.getSession("ID"),this,"et_setratbdlis2_1 = " + e.getMessage());
        }

        return rtnString;
    }




/**
 * 업체입찰현황>조회
 **/

    public SepoaOut getratpplis2_1(String[] pData) {
            String rtn = "";
        try {
            rtn = et_getratpplis2_1(pData);

            if( rtn != null ) {
                setValue(rtn);
                setStatus(1);
            }
        } catch(Exception e) {
            Logger.err.println("getratpplis2_1 ======>>" + e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("002"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }


/**
 * 업체입찰현황>조회
 **/
    private String et_getratpplis2_1(String[] pData) throws Exception {

        String rtn = "";
        SepoaSQLManager sm = null;

        ConnectionContext ctx = getConnectionContext();

        try {

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            wxp.addVar("house_code", pData[0]);
            wxp.addVar("RA_NO", pData[1]);
            wxp.addVar("RA_COUNT", pData[2]);
            
            /*
            sql.append("SELECT                                          \n");
            sql.append("       RABD.VENDOR_CODE                         \n");
            sql.append("      ,(SELECT VENDOR_NAME_LOC                         \n");
            sql.append("          FROM ICOMVNGL                         \n");
            sql.append("         WHERE HOUSE_CODE  = RABD.HOUSE_CODE    \n");
            sql.append("           AND VENDOR_CODE = RABD.VENDOR_CODE   \n");
            sql.append("       ) VENDOR_NAME                            \n");
            sql.append("      ,TO_CHAR(TO_DATE(ADD_DATE,'YYYYMMDD'),'YYYY/MM/DD')||' '||TO_CHAR(TO_DATE(ADD_TIME,'HH24MISS'),'HH24:MI') AS BID_TIME \n");
            sql.append("      ,RABD.CUR                                 \n");
            sql.append("      ,RABD.BID_PRICE                           \n");
            sql.append(" FROM ICOYRABD RABD                             \n");
            sql.append("  <OPT=F,S> WHERE HOUSE_CODE = ? </OPT>         \n");
            sql.append("  <OPT=F,S>  AND RA_NO       = ? </OPT>         \n");
            sql.append("  <OPT=F,S>  AND RA_COUNT    = ? </OPT>         \n");
            sql.append(" ORDER BY RABD.BID_PRICE                        \n");
             */
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

            rtn = sm.doSelect(pData);

        }catch(Exception e) {
            Logger.debug.println(info.getSession("ID"),this,"et_getratpplis2_1 = " + e.getMessage());
        } finally{

        }
        return rtn;
    }



    /**
     *  ICOYPRDT UPDATE.
     */
    private int setPrdtUpdate(
                    String pr_no,
                    String pr_seq,
                    String vendor_code,
                    String settle_qty
                                ) throws Exception {

        int rtn = 0;
        ConnectionContext ctx = getConnectionContext();

        try {


            StringBuffer sql = new StringBuffer();

            sql.append( "UPDATE ICOYPRDT                    \n");
            sql.append( "  SET    PO_VENDOR_CODE = '"+vendor_code+"',     \n");
            sql.append( "       PO_QTY = NVL(PO_QTY,0)+"+settle_qty+",  \n");
            //sql.append( "       CONFIRM_QTY = "+settle_qty+",     \n");
            sql.append( "       PROCEEDING_FLAG = 'B'           \n");
            sql.append( "WHERE  HOUSE_CODE = '"+house_code+"'       \n");
            sql.append( "AND    PR_NO = '"+pr_no+"'             \n");
            sql.append( "AND    PR_SEQ = '"+pr_seq+"'           \n");

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());

            rtn = sm.doUpdate((String[][])null, null);

        }catch(Exception e) {
            throw new Exception("setPrdtUpdate:"+e.getMessage());
        }

        return rtn;

    }



    /**
     * ICOYPODT INSERT( 내자 )
     */

    private int setPodtInsert(  String pr_no,
                    String pr_seq,
                                String po_no,
                                String po_seq,
                                String ra_no) throws Exception {

        int rtn = 0;
        ConnectionContext ctx = getConnectionContext();

        try {

            StringBuffer sql = new StringBuffer();
            sql.append( "INSERT INTO ICOYPODT                \n" );
            sql.append( "(                                                   \n" );
            sql.append( "   HOUSE_CODE,                                      \n" );
            sql.append( "   PO_NO,                                           \n" );
            sql.append( "   PO_SEQ,                                          \n" );
            sql.append( "   COMPANY_CODE,                                    \n" );
            sql.append( "   OPERATING_CODE,                                  \n" );
            sql.append( "   PLANT_CODE,                                      \n" );
            sql.append( "   STATUS,                                          \n" );
            sql.append( "   ADD_DATE,                                        \n" );
            sql.append( "   ADD_TIME,                                        \n" );
            sql.append( "   ADD_USER_ID,                                     \n" );
            sql.append( "   ADD_USER_NAME_ENG,                               \n" );
            sql.append( "   ADD_USER_NAME_LOC,                               \n" );
            sql.append( "   ADD_USER_DEPT,                                   \n" );
            sql.append( "   CHANGE_DATE,                                     \n" );
            sql.append( "   CHANGE_TIME,                                     \n" );
            sql.append( "   CHANGE_USER_ID,                                  \n" );
            sql.append( "   CHANGE_USER_NAME_ENG,                            \n" );
            sql.append( "   CHANGE_USER_NAME_LOC,                            \n" );
            sql.append( "   CHANGE_USER_DEPT,                                \n" );
            sql.append( "   VENDOR_CODE,                                     \n" );
            sql.append( "   ITEM_NO,                                         \n" );
            sql.append( "   DESCRIPTION_ENG,                                 \n" );
            sql.append( "   DESCRIPTION_LOC,                                 \n" );
            sql.append( "   SPECIFICATION,                                   \n" );
            sql.append( "   HS_NO,                                           \n" );
            sql.append( "   MAKER_CODE,                                      \n" );
            sql.append( "   MAKER_NAME,                                      \n" );
            sql.append( "   UNIT_MEASURE,                                    \n" );
            sql.append( "   ITEM_QTY,                                        \n" );
            sql.append( "   MAX_QTY_RATE,                                    \n" );
            sql.append( "   MIN_QTY_RATE,                                    \n" );
            sql.append( "   CUR,                                             \n" );
            sql.append( "   UNIT_PRICE,                                      \n" );
            sql.append( "   UNIT_TAX,                                        \n" );
            sql.append( "   ITEM_AMT,                                        \n" );
            sql.append( "   TAX_AMT,                                         \n" );
            sql.append( "   RD_DATE,                                         \n" );
            sql.append( "   DOM_EXP_FLAG,                                    \n" );
            sql.append( "   DOM_TYPE,                                        \n" );
            sql.append( "   DELY_TO_LOCATION,                                \n" );
            sql.append( "   ORIGIN_COUNTRY,                                  \n" );
            sql.append( "   COMPLETE_MARK,                                   \n" );
            sql.append( "   DO_QTY,                                          \n" );
            sql.append( "   INV_QTY,                                         \n" );
            sql.append( "   GR_QTY,                                          \n" );
            sql.append( "   DI_QTY,                                          \n" );
            sql.append( "   PR_NO,                                           \n" );
            sql.append( "   PR_SEQ,                                          \n" );
            sql.append( "   QTA_NO,                                          \n" );
            sql.append( "   QTA_SEQ,                                         \n" );
            sql.append( "   EXEC_NO,                                         \n" );
            sql.append( "   LC_IF_FLAG,                                      \n" );
            sql.append( "   LC_PROCEEDING_FLAG,                              \n" );
            sql.append( "   LC_APPL_NO,                                      \n" );
            sql.append( "   INVEST_NO,                                       \n" );
            sql.append( "   INSPECT_TYPE,                                    \n" );
            sql.append( "   PKG_TYPE,                                        \n" );
            sql.append( "   ATTACH_NO,                                       \n" );
            sql.append( "   MOLDING_CHARGE,                                  \n" );
            sql.append( "   TTL_CHARGE,                                      \n" );
            sql.append( "   DS_FLAG,                                         \n" );
            sql.append( "   DO_FLAG,                                         \n" );
            sql.append( "   PR_DEPT,                                         \n" );
            sql.append( "   PR_USER_ID,                                      \n" );
            sql.append( "   SALES_PERSON_NAME,                               \n" );
            sql.append( "   SALES_PERSON_TEL,                                \n" );
            sql.append( "   OPTION_FLAG,                                     \n" );
            sql.append( "   OPTION_TYPE,                                     \n" );
            sql.append( "   ADV_PAY_AMT,                                     \n" );
            sql.append( "   ADV_PAY_DATE,                                    \n" );
            sql.append( "   REMAIN_AMT,                                      \n" );
            sql.append( "   MATERIAL_TYPE,                                   \n" );
            sql.append( "   INV_COMPLETE_FLAG,                               \n" );
            sql.append( "   PR_LOCATION,                                     \n" );
            sql.append( "   INV_MOLDING_CHARGE,                              \n" );
            sql.append( "   ACCOUNT_CODE,                                    \n" );
            sql.append( "   VENDOR_ITEM_NO,                                  \n" );
            sql.append( "   CREATE_TYPE,                                     \n" );
            sql.append( "   QI_GUARANTEE,                                    \n" );
            sql.append( "   CTRL_CODE,                                       \n" );
            sql.append( "   PREV_UNIT_PRICE,                                 \n" );
            sql.append( "   REPAIR_FLAG                                      \n" );
            sql.append( ")                                       \n" );
            sql.append( "                                                    \n" );
            sql.append( "(SELECT                                             \n" );
            sql.append( "   RADT.HOUSE_CODE,                 \n" );
            sql.append( "   '"+po_no+"',                                     \n" );
            sql.append( "   LPAD('"+po_seq+"',6,0) AS PO_SEQ,                \n" );
            sql.append( "   PRDT.COMPANY_CODE,                               \n" );
            sql.append( "   RADT.OPERATING_CODE,                             \n" );
            sql.append( "   NVL(PRDT.PLANT_CODE,'$'),                        \n" );
            sql.append( "   'C',                                             \n" );
            sql.append( "   TO_CHAR(SYSDATE,'YYYYMMDD'),                     \n" );
            sql.append( "   TO_CHAR(SYSDATE,'HH24MISS'),                     \n" );
            sql.append( "   RADT.CHANGE_USER_ID,                             \n" );
            sql.append( "   RADT.CHANGE_USER_NAME_ENG,                       \n" );
            sql.append( "   RADT.CHANGE_USER_NAME_LOC,                       \n" );
            sql.append( "   RADT.CHANGE_USER_DEPT,                           \n" );
            sql.append( "   TO_CHAR(SYSDATE,'YYYYMMDD'),                     \n" );
            sql.append( "   TO_CHAR(SYSDATE,'HH24MISS'),                     \n" );
            sql.append( "   RADT.CHANGE_USER_ID,                             \n" );
            sql.append( "   RADT.CHANGE_USER_NAME_ENG,                       \n" );
            sql.append( "   RADT.CHANGE_USER_NAME_LOC,                       \n" );
            sql.append( "   RADT.CHANGE_USER_DEPT,                           \n" );
            sql.append( "   PRDT.PO_VENDOR_CODE,                             \n" );
            sql.append( "   PRDT.BUYER_ITEM_NO,                              \n" );
            sql.append( "   MTGL.DESCRIPTION_ENG,                            \n" );
            sql.append( "   MTGL.DESCRIPTION_LOC,                            \n" );
            sql.append( "   MTGL.SPECIFICATION,                              \n" );
            sql.append( "   MTGL.HS_NO,                                      \n" );
            sql.append( "   NVL(PRDT.MAKER_CODE,' '),                        \n" );
            sql.append( "   PRDT.MAKER_NAME,                                 \n" );
            sql.append( "   PRDT.UNIT_MEASURE,                               \n" );
            sql.append( "   RABD.SETTLE_QTY,                                 \n" );
            sql.append( "   MTOU.OVER_GR_RATE,                               \n" );
            sql.append( "   MTOU.UNDER_GR_RATE,                              \n" );
            sql.append( "   RADT.CUR,                                        \n" );
            //sql.append( " RADT.UNIT_PRICE,                                 \n" );
            sql.append( "   RABD.BID_PRICE,                  \n" );
            sql.append( "   0,                                               \n" );
            sql.append( "   RABD.BID_QTY * RABD.BID_PRICE,                   \n" );
            sql.append( "   0,                                               \n" );
            sql.append( "   RADT.RD_DATE,                                    \n" );
            sql.append( "   RADT.DOM_EXP_FLAG,                               \n" );
            sql.append( "   DECODE(RADT.DOM_EXP_FLAG,'DO','N',''),           \n" );
            sql.append( "   PRDT.STR_CODE,                                   \n" );
            sql.append( "   MTGL.ORIGIN_COUNTRY,                             \n" );
            sql.append( "   'N',                                             \n" );
            sql.append( "   0,                                               \n" );
            sql.append( "   0,                                               \n" );
            sql.append( "   0,                                               \n" );
            sql.append( "   0,                                               \n" );
            sql.append( "   PRDT.PR_NO,                                      \n" );
            sql.append( "   PRDT.PR_SEQ,                                     \n" );
            sql.append( "   '',                                          \n" );
            sql.append( "   '',                                          \n" );
            sql.append( "   '',                                    \n" );
            sql.append( "   'N',                                             \n" );
            sql.append( "   'N',                                             \n" );
            sql.append( "   '',                                              \n" );
            sql.append( "   PRHD.INVEST_NO,                                  \n" );
            sql.append( "   GETINSPECTTYPE_FUNC(PRDT.HOUSE_CODE,PRDT.COMPANY_CODE,PRDT.OPERATING_CODE,PRDT.PLANT_CODE,PRDT.BUYER_ITEM_NO) AS INSPECT_TYPE,\n" );
            sql.append( "   'A',                                             \n" );
            sql.append( "   '',                                              \n" );
            sql.append( "   '',                             \n" );
            sql.append( "   '',                                 \n" );
            sql.append( "   'N',                                             \n" );
            sql.append( "   NVL(MTOU.DO_FLAG,'N'),                           \n" );
            sql.append( "   PRDT.CHANGE_USER_DEPT,                           \n" );
            sql.append( "   PRDT.CHANGE_USER_ID,                             \n" );

            sql.append( "   '',                             \n" );
            sql.append( "   '',                             \n" );

            //sql.append( " INFO.SALES_PERSON_NAME,                          \n" );
            //sql.append( " INFO.SALES_PERSON_TEL,                           \n" );
            sql.append( "   'N',                                             \n" );
            sql.append( "   'N',                                             \n" );
            sql.append( "   0,                                               \n" );
            sql.append( "   '',                                              \n" );
            sql.append( "   0,                                               \n" );
            sql.append( "   MTGL.MATERIAL_TYPE,                              \n" );
            sql.append( "   'N',                                             \n" );
            sql.append( "   PRHD.PR_LOCATION,                                \n" );
            sql.append( "   0,                                               \n" );
            sql.append( "   PRHD.ACCOUNT_CODE,                               \n" );
            sql.append( "   RABD.VENDOR_ITEM_NO,                             \n" );
            sql.append( "   'A',                                             \n" );
            sql.append( "   'MANUFACTURER TO BE FINAL',                      \n" );
            sql.append( "   RAHD.CTRL_CODE,                                  \n" );
            sql.append( "   GETPREVPRICEINFH(RADT.HOUSE_CODE,RADT.BUYER_ITEM_NO,RABD.VENDOR_CODE,PRHD.PR_LOCATION),\n" );
            sql.append( "   PRDT.REPAIR_FLAG                                 \n" );
            sql.append( "FROM   ICOMMTGL MTGL, ICOMMTOU MTOU,   \n" );
            sql.append( "       ICOYPRHD PRHD, ICOYPRDT PRDT, ICOYRADT RADT,    \n" );
            sql.append( "       ICOYRABD RABD, ICOYRAHD RAHD            \n" );
            sql.append( "WHERE   PRDT.HOUSE_CODE = '100'                     \n" );
            sql.append( "AND     PRDT.PR_NO = '"+pr_no+"'            \n" );
            sql.append( "AND     PRDT.PR_SEQ = '"+pr_seq+"'          \n" );
            sql.append( "AND     PRDT.STATUS <> 'D'                          \n" );
            sql.append( "AND     PRHD.HOUSE_CODE = PRDT.HOUSE_CODE           \n" );
            sql.append( "AND     PRHD.PR_NO = PRDT.PR_NO                     \n" );
            sql.append( "AND     RAHD.TYPE = 'R'                             \n" );
            sql.append( "AND     RADT.RA_NO = '"+ra_no+"'                    \n" );
            sql.append( "AND     RADT.PR_NO = PRDT.PR_NO                     \n" );
            sql.append( "AND     RADT.PR_SEQ = PRDT.PR_SEQ                   \n" );
            sql.append( "AND     RABD.HOUSE_CODE = RADT.HOUSE_CODE           \n" );
            sql.append( "AND     RABD.RA_NO = RADT.RA_NO                     \n" );
            sql.append( "AND     RABD.RA_COUNT = RADT.RA_COUNT               \n" );
            sql.append( "AND     RABD.RA_SEQ = RADT.RA_SEQ                   \n" );
            sql.append( "AND     RABD.VENDOR_CODE = PRDT.PO_VENDOR_CODE      \n" );
            sql.append( "AND     RABD.SETTLE_FLAG = 'Y'                      \n" );
            sql.append( "AND     RAHD.HOUSE_CODE = RADT.HOUSE_CODE           \n" );
            sql.append( "AND     RAHD.RA_NO = RADT.RA_NO                     \n" );
            sql.append( "AND     RAHD.RA_COUNT = RADT.RA_COUNT               \n" );
            //sql.append( "AND     INFO.HOUSE_CODE = RADT.HOUSE_CODE           \n" );
            //sql.append( "AND     INFO.OPERATING_CODE = RADT.OPERATING_CODE   \n" );
            //sql.append( "AND     INFO.VENDOR_CODE = RABD.VENDOR_CODE         \n" );
            //sql.append( "AND     INFO.ITEM_NO = RADT.BUYER_ITEM_NO           \n" );
            //sql.append( "AND     INFO.SHIPPER_TYPE = PRDT.SHIPPER_TYPE     \n" );
            sql.append( "AND     MTOU.HOUSE_CODE(+) = RADT.HOUSE_CODE        \n" );
            sql.append( "AND     MTOU.COMPANY_CODE(+) = RADT.COMPANY_CODE    \n" );
            sql.append( "AND     MTOU.OPERATING_CODE(+) = RADT.OPERATING_CODE\n" );
            sql.append( "AND     MTOU.ITEM_NO(+) = RADT.BUYER_ITEM_NO        \n" );
            sql.append( "AND     MTGL.HOUSE_CODE = RADT.HOUSE_CODE           \n" );
            sql.append( "AND     MTGL.ITEM_NO = RADT.BUYER_ITEM_NO           \n" );
            sql.append( ")                                                   \n" );



            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());

            rtn = sm.doInsert((String[][])null, null);

            Logger.debug.println(user_id,this," setPodtInsert rtn======"+rtn);

        }catch(Exception e) {
            throw new Exception("setPodtInsert:"+e.getMessage());
        }

        return rtn;

    }


    /**
     * POHD INSERT(내자)
     */

    private int setPohdInsert(
                    String po_no,
                    String sign_flag,
                    String sign_user_id,
                    String sign_date,
                    String ra_no,
                    String ra_seq,
                    String ra_count
                                ) throws Exception {

        int rtn = 0;
        ConnectionContext ctx = getConnectionContext();

        try {


            StringBuffer sql = new StringBuffer();

            sql.append( "INSERT INTO ICOYPOHD                   \n" );
            sql.append( "(                                                          \n" );
            sql.append( "   HOUSE_CODE,                                             \n" );
            sql.append( "   PO_NO,                                                  \n" );
            sql.append( "   COMPANY_CODE,                                           \n" );
            sql.append( "   OPERATING_CODE,                                         \n" );
            sql.append( "   PLANT_CODE,                                             \n" );
            sql.append( "   STATUS,                                                 \n" );
            sql.append( "   ADD_DATE,                                               \n" );
            sql.append( "   ADD_TIME,                                               \n" );
            sql.append( "   ADD_USER_ID,                                            \n" );
            sql.append( "   ADD_USER_NAME_ENG,                                      \n" );
            sql.append( "   ADD_USER_NAME_LOC,                                      \n" );
            sql.append( "   ADD_USER_DEPT,                                          \n" );
            sql.append( "   CHANGE_DATE,                                            \n" );
            sql.append( "   CHANGE_TIME,                                            \n" );
            sql.append( "   CHANGE_USER_ID,                                         \n" );
            sql.append( "   CHANGE_USER_NAME_ENG,                                   \n" );
            sql.append( "   CHANGE_USER_NAME_LOC,                                   \n" );
            sql.append( "   CHANGE_USER_DEPT,                                       \n" );
            sql.append( "   CONFIRM_DATE,                                           \n" );
            sql.append( "   CONFIRM_TIME,                                           \n" );
            sql.append( "   CONFIRM_USER_ID,                                        \n" );
            sql.append( "   PO_CREATE_DATE,                                         \n" );
            sql.append( "   ACCOUNT_TYPE,                                           \n" );
            sql.append( "   PROCESS_TYPE,                                           \n" );
            sql.append( "   SHIPPER_TYPE,                                           \n" );
            sql.append( "   PAY_TERMS,                                              \n" );
            sql.append( "   PAY_TEXT,                                               \n" );
            sql.append( "   DELY_TERMS,                                             \n" );
            sql.append( "   CUR,                                                    \n" );
            sql.append( "   PO_TTL_AMT,                                             \n" );
            sql.append( "   PO_TAX_TTL_AMT,                                         \n" );
            sql.append( "   SHIPPING_METHOD,                                        \n" );
            sql.append( "   PURCHASER_ID,                                           \n" );
            sql.append( "   PURCHASER_NAME,                                         \n" );
            sql.append( "   SALES_PERSON_NAME,                                      \n" );
            sql.append( "   SALES_PERSON_TEL,                                       \n" );
            sql.append( "   SUBJECT,                                                \n" );
            sql.append( "   REMARK,                                                 \n" );
            sql.append( "   ADV_PAY_AMT,                                            \n" );
            sql.append( "   ADV_PAY_DATE,                                           \n" );
            sql.append( "   REMAIN_AMT,                                             \n" );
            sql.append( "   VERSION,                                                \n" );
            sql.append( "   EMAIL_FLAG,                                             \n" );
            sql.append( "   COMPLETE_MARK,                                          \n" );
            sql.append( "   PRICE_TYPE,                                             \n" );
            sql.append( "   WARRENTY,                                               \n" );
            sql.append( "   SIGN_FLAG,                                              \n" );
            sql.append( "   SIGN_DATE,                                              \n" );
            sql.append( "   SIGN_PERSON_ID,                                         \n" );
            sql.append( "   PR_LOCATION,                                            \n" );
            sql.append( "   BILL_TO_LOCATION,                                       \n" );
            sql.append( "   BILL_TO_ADDRESS,                                        \n" );
            sql.append( "   GR_BASE_FLAG,                                           \n" );
            sql.append( "   EXP_ITEM_NO,                                            \n" );
            sql.append( "   TTL_CHARGE,                                             \n" );
            sql.append( "   NET_AMT,                                                \n" );
            sql.append( "   FOB_CHARGE,                                             \n" );
            sql.append( "   INV_COMPLETE_FLAG,                                      \n" );
            sql.append( "   DELY_TO_LOCATION,                                       \n" );
            sql.append( "   DELY_TO_ADDRESS,                                        \n" );
            sql.append( "   PRICE_CTRL_TYPE,                                        \n" );
            sql.append( "   VENDOR_CODE,                                            \n" );
            sql.append( "   CONSIGNEE,                                              \n" );
            sql.append( "   PAYEE,                                                  \n" );
            sql.append( "   PAYER,                                                  \n" );
            sql.append( "   NOTIFY,                                                 \n" );
            sql.append( "   DOC_TYPE,                                               \n" );
            sql.append( "   CIM_COUNT,                                              \n");
            sql.append( "   CIM_QTY,                                                \n");
            sql.append( "   CIM_AMOUNT                                              \n");
            sql.append( ")                                                          \n" );

            sql.append( "(                                                          \n" );
            sql.append( "SELECT                                                 \n" );
            sql.append( "   PODT.HOUSE_CODE,                                        \n" );
            sql.append( "   PODT.PO_NO,                                             \n" );
            sql.append( "   PODT.COMPANY_CODE,                                      \n" );
            sql.append( "   PODT.OPERATING_CODE,                                    \n" );
            sql.append( "   NVL(PODT.PLANT_CODE,'$'),                               \n" );
            sql.append( "   'C',                                                    \n" );
            sql.append( "   PODT.ADD_DATE,                                          \n" );
            sql.append( "   PODT.ADD_TIME,                                          \n" );
            sql.append( "   PODT.ADD_USER_ID,                                       \n" );
            sql.append( "   PODT.ADD_USER_NAME_ENG,                                 \n" );
            sql.append( "   PODT.ADD_USER_NAME_LOC,                                 \n" );
            sql.append( "   PODT.ADD_USER_DEPT,                                     \n" );
            sql.append( "   PODT.CHANGE_DATE,                                       \n" );
            sql.append( "   PODT.CHANGE_TIME,                                       \n" );
            sql.append( "   PODT.CHANGE_USER_ID,                                    \n" );
            sql.append( "   PODT.CHANGE_USER_NAME_ENG,                              \n" );
            sql.append( "   PODT.CHANGE_USER_NAME_LOC,                              \n" );
            sql.append( "   PODT.CHANGE_USER_DEPT,                                  \n" );
            sql.append( "   ' ',                                                    \n" );
            sql.append( "   ' ',                                                    \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   TO_CHAR(SYSDATE,'YYYYMMDD'),                            \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   PRDT.SHIPPER_TYPE,                                      \n" );
            sql.append( "   RADT.PAY_TERMS,                                         \n" );
            sql.append( "   '',                                          \n" );//PAY_TEXT
            sql.append( "   RADT.DELY_TERMS,                                        \n" );
            sql.append( "   RADT.CUR,                                               \n" );
            sql.append( "   (SELECT SUM(NVL(ITEM_AMT,0)) FROM ICOYPODT WHERE HOUSE_CODE = '"+house_code+"' AND PO_NO = '"+po_no+"'),\n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   RADT.SHIPPING_METHOD,                                   \n" );
            sql.append( "   PRDT.PURCHASER_ID,                                      \n" );
            sql.append( "   PRDT.PURCHASER_NAME,                                    \n" );
            sql.append( "   '',                                 \n" );
            sql.append( "   '',                                  \n" );
            //sql.append( " INFO.SALES_PERSON_NAME,                                 \n" );
            //sql.append( " INFO.SALES_PERSON_TEL,                                  \n" );
            sql.append( "   'PO CREATED AUTOMETICALLY',                             \n" );
            sql.append( "   RAHD.REMARK,                                                        \n" );//PO_REMARK
            sql.append( "   0,                                                      \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   '2',                                                    \n" );
            sql.append( "   'N',                                                    \n" );
            sql.append( "   'N',                                                    \n" );
            sql.append( "   RADT.PRICE_TYPE,                                        \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   '"+sign_flag+"',                                        \n" );
            sql.append( "   '"+sign_date+"',                                        \n" );
            sql.append( "   '"+sign_user_id+"',                                     \n" );
            sql.append( "   PRHD.PR_LOCATION,                                       \n" );
            sql.append( "   CMGL.COMPANY_CODE,                                      \n" );
            sql.append( "   CMGL.ADDRESS_ENG,                                       \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   (SELECT SUM(NVL(ITEM_AMT,0)) FROM ICOYPODT WHERE HOUSE_CODE = '"+house_code+"' AND PO_NO = '"+po_no+"'),\n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   'N',                                                    \n" );
            sql.append( "   PRDT.STR_CODE,                                          \n" );
            //sql.append( " INFO.DELY_TO_ADDRESS,                                   \n" );
            sql.append( "           DECODE(PRDT.STR_CODE,PRDT.DELY_TO_LOCATION,(SELECT NAME_LOC   \n");
            sql.append( "                                                  FROM ICOMOGDP   \n");
            sql.append( "                                                  WHERE HOUSE_CODE = '"+house_code+"'   \n");
            sql.append( "                                                  AND DEPT = PRDT.DELY_TO_LOCATION   \n");
            sql.append( "                                                  AND ROWNUM =1),(SELECT STR_NAME_LOC   \n");
            sql.append( "                                                                  FROM ICOMOGSL   \n");
            sql.append( "                                                                  WHERE HOUSE_CODE = '"+house_code+"'   \n");
            sql.append( "                                                                  AND COMPANY_CODE = PRDT.COMPANY_CODE   \n");
            sql.append( "                                                                  AND STR_CODE = PRDT.STR_CODE)),  \n"); // dely_to_address 넣어주기 수정. 기존엔 없었다.(07_25)


            sql.append( "   '',                                                     \n" );
            sql.append( "   PODT.VENDOR_CODE,                                       \n" );
            sql.append( "   PODT.COMPANY_CODE,                                      \n" );
            sql.append( "   PODT.VENDOR_CODE,                                       \n" );
            sql.append( "   PODT.COMPANY_CODE,                                      \n" );
            sql.append( "   PODT.COMPANY_CODE,                                      \n" );
            sql.append( "   'R',                                                    \n" );
            sql.append( "   (SELECT COUNT(*) FROM ICOYPODT WHERE HOUSE_CODE='100' AND PO_NO = PODT.PO_NO        ),\n");
            sql.append( "   (SELECT SUM(ITEM_QTY) FROM ICOYPODT WHERE HOUSE_CODE='100' AND PO_NO = PODT.PO_NO   ),\n");
            sql.append( "   (SELECT SUM(ITEM_AMT) FROM ICOYPODT WHERE HOUSE_CODE='100' AND PO_NO = PODT.PO_NO   ) \n");
            sql.append( "FROM   ICOMCMGL CMGL,                                  \n" );
            sql.append( "       ICOYRAHD RAHD,                                  \n" );
            sql.append( "       ICOYRADT RADT,                                  \n" );
            sql.append( "       ICOYPODT PODT,                                  \n" );
            sql.append( "       ICOYPRHD PRHD,                                  \n" );
            sql.append( "       ICOYPRDT PRDT                                   \n" );
            sql.append( "WHERE  PODT.HOUSE_CODE = '"+house_code+"'      \n" );
            sql.append( "AND    RADT.HOUSE_CODE = '"+house_code+"'      \n" );
            sql.append( "AND    RAHD.HOUSE_CODE = '"+house_code+"'      \n" );
            sql.append( "AND    PODT.PO_NO = '"+po_no+"'            \n" );
            sql.append( "AND    PODT.PO_SEQ = '000001'                          \n" );
            sql.append( "AND    PRHD.HOUSE_CODE = PODT.HOUSE_CODE               \n" );
            sql.append( "AND    PRHD.PR_NO = PODT.PR_NO                         \n" );
            sql.append( "AND    RAHD.TYPE = 'R'                                 \n" );
            sql.append( "AND    PRDT.HOUSE_CODE = PODT.HOUSE_CODE               \n" );
            sql.append( "AND    PRDT.PR_NO = PODT.PR_NO                         \n" );
            sql.append( "AND    PRDT.PR_SEQ = PODT.PR_SEQ                       \n" );
            sql.append( "AND    RADT.PR_NO = PODT.PR_NO                         \n" );
            sql.append( "AND    RADT.PR_SEQ = PODT.PR_SEQ                       \n" );
            sql.append( "AND    RADT.RA_NO = RAHD.RA_NO                     \n" );
            sql.append( "AND    RADT.RA_NO = '"+ra_no+"'                      \n" );
            sql.append( "AND    RADT.RA_SEQ = '"+ra_seq+"'                      \n" );
            sql.append( "AND    RADT.RA_COUNT = '"+ra_count+"'                      \n" );
            sql.append( "AND    CMGL.HOUSE_CODE = PODT.HOUSE_CODE               \n" );
            sql.append( "AND    CMGL.COMPANY_CODE = PODT.COMPANY_CODE           \n" );
            sql.append( ")                              \n" );

//sql.append( "     ICOYINFO INFO,                                  \n" );
//sql.append( "AND  INFO.HOUSE_CODE = PODT.HOUSE_CODE               \n" );
//sql.append( "AND  INFO.OPERATING_CODE = PODT.OPERATING_CODE       \n" );
//sql.append( "AND  INFO.VENDOR_CODE = PODT.VENDOR_CODE             \n" );
//sql.append( "AND  INFO.ITEM_NO = PODT.ITEM_NO                     \n" );
//sql.append( "AND  INFO.SHIPPER_TYPE = PRDT.SHIPPER_TYPE           \n" );

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());

            rtn = sm.doInsert((String[][])null, null);

            Logger.debug.println(user_id,this," setPohdInsert rtn======"+rtn);

        }catch(Exception e){
            throw new Exception("setPohdInsert:"+e.getMessage());
        }

        return rtn;

    }


    private int setPodtOverseasInsert(
                        String pr_no,
                        String pr_seq,
                        String po_no,
                        String po_seq,
                        String ra_no,
                        String ra_count,
                        String ra_seq
                                                ) throws Exception {

        int rtn = 0;
        ConnectionContext ctx = getConnectionContext();

        try {

            StringBuffer sql = new StringBuffer();

            sql.append( "INSERT INTO ICOYPODT                   \n" );
            sql.append( "(                                                          \n" );
            sql.append( "   HOUSE_CODE,                                             \n" );
            sql.append( "   PO_NO,                                                  \n" );
            sql.append( "   PO_SEQ,                                                 \n" );
            sql.append( "   COMPANY_CODE,                                           \n" );
            sql.append( "   OPERATING_CODE,                                         \n" );
            sql.append( "   PLANT_CODE,                                             \n" );
            sql.append( "   STATUS,                                                 \n" );
            sql.append( "   ADD_DATE,                                               \n" );
            sql.append( "   ADD_TIME,                                               \n" );
            sql.append( "   ADD_USER_ID,                                            \n" );
            sql.append( "   ADD_USER_NAME_ENG,                                      \n" );
            sql.append( "   ADD_USER_NAME_LOC,                                      \n" );
            sql.append( "   ADD_USER_DEPT,                                          \n" );
            sql.append( "   CHANGE_DATE,                                            \n" );
            sql.append( "   CHANGE_TIME,                                            \n" );
            sql.append( "   CHANGE_USER_ID,                                         \n" );
            sql.append( "   CHANGE_USER_NAME_ENG,                                   \n" );
            sql.append( "   CHANGE_USER_NAME_LOC,                                   \n" );
            sql.append( "   CHANGE_USER_DEPT,                                       \n" );
            sql.append( "   VENDOR_CODE,                                            \n" );
            sql.append( "   ITEM_NO,                                                \n" );
            sql.append( "   DESCRIPTION_ENG,                                        \n" );
            sql.append( "   DESCRIPTION_LOC,                                        \n" );
            sql.append( "   SPECIFICATION,                                          \n" );
            sql.append( "   HS_NO,                                                  \n" );
            sql.append( "   MAKER_CODE,                                             \n" );
            sql.append( "   MAKER_NAME,                                             \n" );
            sql.append( "   UNIT_MEASURE,                                           \n" );
            sql.append( "   ITEM_QTY,                                               \n" );
            sql.append( "   MAX_QTY_RATE,                                           \n" );
            sql.append( "   MIN_QTY_RATE,                                           \n" );
            sql.append( "   CUR,                                                    \n" );
            sql.append( "   UNIT_PRICE,                                             \n" );
            sql.append( "   UNIT_TAX,                                               \n" );
            sql.append( "   ITEM_AMT,                                               \n" );
            sql.append( "   TAX_AMT,                                                \n" );
            sql.append( "   RD_DATE,                                                \n" );
            sql.append( "   DOM_EXP_FLAG,                                           \n" );
            sql.append( "   DOM_TYPE,                                               \n" );
            sql.append( "   DELY_TO_LOCATION,                                       \n" );
            sql.append( "   ORIGIN_COUNTRY,                                         \n" );
            sql.append( "   COMPLETE_MARK,                                          \n" );
            sql.append( "   LC_OPEN_REQ_DATE,                                       \n" );
            sql.append( "   DO_QTY,                                                 \n" );
            sql.append( "   INV_QTY,                                                \n" );
            sql.append( "   GR_QTY,                                                 \n" );
            sql.append( "   DI_QTY,                                                 \n" );
            sql.append( "   PR_NO,                                                  \n" );
            sql.append( "   PR_SEQ,                                                 \n" );
            sql.append( "   QTA_NO,                                                 \n" );
            sql.append( "   QTA_SEQ,                                                \n" );
            sql.append( "   EXEC_NO,                                                \n" );
            sql.append( "   LC_IF_FLAG,                                             \n" );
            sql.append( "   LC_PROCEEDING_FLAG,                                     \n" );
            sql.append( "   LC_APPL_NO,                                             \n" );
            sql.append( "   INVEST_NO,                                              \n" );
            sql.append( "   INSPECT_TYPE,                                           \n" );
            sql.append( "   PKG_TYPE,                                               \n" );
            sql.append( "   ATTACH_NO,                                              \n" );
            sql.append( "   MOLDING_CHARGE,                                         \n" );
            sql.append( "   TTL_CHARGE,                                             \n" );
            sql.append( "   DS_FLAG,                                                \n" );
            sql.append( "   DO_FLAG,                                                \n" );
            sql.append( "   PR_DEPT,                                                \n" );
            sql.append( "   PR_USER_ID,                                             \n" );
            sql.append( "   SALES_PERSON_NAME,                                      \n" );
            sql.append( "   SALES_PERSON_TEL,                                       \n" );
            sql.append( "   OPTION_FLAG,                                            \n" );
            sql.append( "   OPTION_TYPE,                                            \n" );
            sql.append( "   ADV_PAY_AMT,                                            \n" );
            sql.append( "   ADV_PAY_DATE,                                           \n" );
            sql.append( "   REMAIN_AMT,                                             \n" );
            sql.append( "   MATERIAL_TYPE,                                          \n" );
            sql.append( "   INV_COMPLETE_FLAG,                                      \n" );
            sql.append( "   PR_LOCATION,                                            \n" );
            sql.append( "   INV_MOLDING_CHARGE,                                     \n" );
            sql.append( "   ACCOUNT_CODE,                                           \n" );
            sql.append( "   VENDOR_ITEM_NO,                                         \n" );
            sql.append( "   CREATE_TYPE,                                            \n" );
            sql.append( "   QI_GUARANTEE,                                           \n" );
            sql.append( "   INS_CLAUSE_CODE1,                                       \n" );
            sql.append( "   INS_CLAUSE_CODE2,                                       \n" );
            sql.append( "   CTRL_CODE,                                              \n" );
            sql.append( "   PREV_UNIT_PRICE,                                        \n" );
            sql.append( "   REPAIR_FLAG                                             \n" );
            sql.append( ")                                                          \n" );
            sql.append( "                                                           \n" );
            sql.append( "(                                                          \n" );
            sql.append( "SELECT                                                     \n" );
            sql.append( "   RADT.HOUSE_CODE,                                        \n" );
            sql.append( "   '"+po_no+"',                                            \n" );
            sql.append( "   LPAD('"+po_seq+"',6,0)AS PO_SEQ,                        \n" );
            sql.append( "   PRDT.COMPANY_CODE,                                      \n" );
            sql.append( "   RADT.OPERATING_CODE,                                    \n" );
            sql.append( "   NVL(PRDT.PLANT_CODE,'$'),                               \n" );
            sql.append( "   'C',                                                    \n" );
            sql.append( "   TO_CHAR(SYSDATE,'YYYYMMDD'),                            \n" );
            sql.append( "   TO_CHAR(SYSDATE,'HH24MISS'),                            \n" );
            sql.append( "   RADT.CHANGE_USER_ID,                                    \n" );
            sql.append( "   RADT.CHANGE_USER_NAME_ENG,                              \n" );
            sql.append( "   RADT.CHANGE_USER_NAME_LOC,                              \n" );
            sql.append( "   RADT.CHANGE_USER_DEPT,                                  \n" );
            sql.append( "   TO_CHAR(SYSDATE,'YYYYMMDD'),                            \n" );
            sql.append( "   TO_CHAR(SYSDATE,'HH24MISS'),                            \n" );
            sql.append( "   RADT.CHANGE_USER_ID,                                    \n" );
            sql.append( "   RADT.CHANGE_USER_NAME_ENG,                              \n" );
            sql.append( "   RADT.CHANGE_USER_NAME_LOC,                              \n" );
            sql.append( "   RADT.CHANGE_USER_DEPT,                                  \n" );
            sql.append( "   PRDT.PO_VENDOR_CODE,                                    \n" );
            sql.append( "   PRDT.BUYER_ITEM_NO,                                     \n" );
            sql.append( "   MTGL.DESCRIPTION_ENG,                                   \n" );
            sql.append( "   MTGL.DESCRIPTION_LOC,                                   \n" );
            sql.append( "   MTGL.SPECIFICATION,                                     \n" );
            sql.append( "   MTGL.HS_NO,                                             \n" );
            sql.append( "   NVL(PRDT.MAKER_CODE,' '),                               \n" );
            sql.append( "   RADT.MAKER_NAME,                                        \n" );
            sql.append( "   RABD.UNIT_MEASURE,                                      \n" );
            sql.append( "   RABD.SETTLE_QTY,                                        \n" );
            sql.append( "   MTOU.OVER_GR_RATE,                                      \n" );
            sql.append( "   MTOU.UNDER_GR_RATE,                                     \n" );
            sql.append( "   RABD.CUR,                                               \n" );
            sql.append( "   RABD.BID_PRICE,                                         \n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   RABD.SETTLE_QTY * RABD.BID_PRICE,                       \n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   RADT.RD_DATE,                                           \n" );
            sql.append( "   RADT.DOM_EXP_FLAG,                                      \n" );
            sql.append( "   DECODE(RADT.DOM_EXP_FLAG,'DO','N',''),                  \n" );
            sql.append( "   PRDT.STR_CODE,                                          \n" );
            sql.append( "   MTGL.ORIGIN_COUNTRY,                                    \n" );
            sql.append( "   'N',                                                    \n" );
            sql.append( "   NULL,                                                   \n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   PRDT.PR_NO,                                             \n" );
            sql.append( "   PRDT.PR_SEQ,                                            \n" );
            sql.append( "   RADT.RA_NO,                                             \n" );
            sql.append( "   RADT.RA_SEQ,                                            \n" );
            sql.append( "   '',                                           \n" );
            sql.append( "   'N',                                                    \n" );
            sql.append( "   'N',                                                    \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   PRHD.INVEST_NO,                                         \n" );
            sql.append( "   GETINSPECTTYPE_FUNC(PRDT.HOUSE_CODE,PRDT.COMPANY_CODE,PRDT.OPERATING_CODE,PRDT.PLANT_CODE,PRDT.BUYER_ITEM_NO) AS INSPECT_TYPE,\n" );
            sql.append( "   'A',                                                    \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   'N',                                                    \n" );
            sql.append( "   NVL(MTOU.DO_FLAG,'N'),                                  \n" );
            sql.append( "   RADT.CHANGE_USER_DEPT,                                  \n" );
            sql.append( "   RADT.CHANGE_USER_ID,                                    \n" );
            sql.append( "   '',                                 \n" );
            sql.append( "   '',                                  \n" );
            //sql.append( " INFO.SALES_PERSON_NAME,                                 \n" );
            //sql.append( " INFO.SALES_PERSON_TEL,                                  \n" );
            sql.append( "   'N',                                                    \n" );
            sql.append( "   'N',                                                    \n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   MTGL.MATERIAL_TYPE,                                     \n" );
            sql.append( "   'N',                                                    \n" );
            sql.append( "   PRHD.PR_LOCATION,                                       \n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   PRHD.ACCOUNT_CODE,                                      \n" );
            sql.append( "   RABD.VENDOR_ITEM_NO,                                    \n" );
            sql.append( "   'A',                                                    \n" );
            sql.append( "   'MANUFACTURER TO BE FINAL',                             \n" );
            sql.append( "   NULL,                                                   \n" );
            sql.append( "   NULL,                                                   \n" );
            sql.append( "   RAHD.CTRL_CODE,                                         \n" );
            sql.append( "   GETPREVPRICEINFH(RADT.HOUSE_CODE,RADT.BUYER_ITEM_NO,RABD.VENDOR_CODE,PRHD.PR_LOCATION),\n" );
            sql.append( "   PRDT.REPAIR_FLAG                                        \n" );
            sql.append( "FROM   ICOMMTGL MTGL,                  \n" );
            sql.append( "       ICOMMTOU MTOU,                  \n" );
            //sql.append( "     ICOYINFO INFO,                  \n" );
            sql.append( "       ICOYPRHD PRHD,                  \n" );
            sql.append( "       ICOYPRDT PRDT,                  \n" );
            sql.append( "       ICOYRADT RADT,                  \n" );
            sql.append( "       ICOYRABD RABD,                  \n" );
            sql.append( "       ICOYRAHD RAHD                   \n" );
            sql.append( "WHERE   PRDT.HOUSE_CODE = '"+house_code+"'                 \n" );
            sql.append( "AND     PRDT.PR_NO = '"+pr_no+"'                           \n" );
            sql.append( "AND     PRDT.PR_SEQ = '"+pr_seq+"'                         \n" );
            sql.append( "AND     PRDT.STATUS <> 'D'                                 \n" );
            sql.append( "AND     PRHD.HOUSE_CODE = PRDT.HOUSE_CODE                  \n" );
            sql.append( "AND     PRHD.PR_NO = PRDT.PR_NO                            \n" );
            sql.append( "AND     RAHD.TYPE = 'R'                                    \n" );
            sql.append( "AND     RADT.RA_NO = '"+ra_no+"'                           \n" );
            sql.append( "AND     RADT.PR_NO = PRDT.PR_NO                            \n" );
            sql.append( "AND     RADT.PR_SEQ = PRDT.PR_SEQ                          \n" );
            sql.append( "AND     RABD.HOUSE_CODE = RADT.HOUSE_CODE                  \n" );
            sql.append( "AND     RABD.RA_NO = RADT.RA_NO                            \n" );
            sql.append( "AND     RABD.RA_COUNT = RADT.RA_COUNT                      \n" );
            sql.append( "AND     RABD.RA_SEQ = RADT.RA_SEQ                          \n" );
            sql.append( "AND     RABD.VENDOR_CODE = PRDT.PO_VENDOR_CODE             \n" );
            sql.append( "AND     RABD.SETTLE_FLAG = 'Y'                             \n" );
            sql.append( "AND     RAHD.HOUSE_CODE = RADT.HOUSE_CODE                  \n" );
            sql.append( "AND     RAHD.RA_NO = RADT.RA_NO                            \n" );
            sql.append( "AND     RAHD.RA_COUNT = RADT.RA_COUNT                      \n" );
            sql.append( "AND     INFO.HOUSE_CODE = RADT.HOUSE_CODE                  \n" );
            sql.append( "AND     INFO.OPERATING_CODE = RADT.OPERATING_CODE          \n" );
            sql.append( "AND     INFO.VENDOR_CODE = RABD.VENDOR_CODE                \n" );
            sql.append( "AND     INFO.ITEM_NO = RADT.BUYER_ITEM_NO                  \n" );
            sql.append( "AND     MTOU.HOUSE_CODE(+) = RADT.HOUSE_CODE               \n" );
            sql.append( "AND     MTOU.COMPANY_CODE(+) = RADT.COMPANY_CODE           \n" );
            sql.append( "AND     MTOU.OPERATING_CODE(+) = RADT.OPERATING_CODE       \n" );
            sql.append( "AND     MTOU.ITEM_NO(+) = RADT.BUYER_ITEM_NO               \n" );
            sql.append( "AND     MTGL.HOUSE_CODE = RADT.HOUSE_CODE                  \n" );
            sql.append( "AND     MTGL.ITEM_NO = RADT.BUYER_ITEM_NO                  \n" );
            sql.append( "  )                            \n" );


            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());

            rtn = sm.doInsert((String[][])null, null);

            Logger.debug.println(user_id,this," setPodtOverseasInsert rtn======"+rtn);

        }catch(Exception e) {
            throw new Exception("setPodtOverseasInsert:"+e.getMessage());
        }

        return rtn;

    }


    /**
     * ICOYPOHD INSERT.(외자)
     */

    private int setPohdOverseasInsert(
                        String po_no,
                        String sign_flag,
                        String sign_user_id,
                        String sign_date

                        ) throws Exception {

        int rtn = 0;
        ConnectionContext ctx = getConnectionContext();

        try {


            StringBuffer sql = new StringBuffer();

            sql.append( "INSERT INTO ICOYPOHD                   \n" );
            sql.append( "(                                                          \n" );
            sql.append( "   HOUSE_CODE,                                             \n" );
            sql.append( "   PO_NO,                                                  \n" );
            sql.append( "   COMPANY_CODE,                                           \n" );
            sql.append( "   OPERATING_CODE,                                         \n" );
            sql.append( "   PLANT_CODE,                                             \n" );
            sql.append( "   STATUS,                                                 \n" );
            sql.append( "   ADD_DATE,                                               \n" );
            sql.append( "   ADD_TIME,                                               \n" );
            sql.append( "   ADD_USER_ID,                                            \n" );
            sql.append( "   ADD_USER_NAME_ENG,                                      \n" );
            sql.append( "   ADD_USER_NAME_LOC,                                      \n" );
            sql.append( "   ADD_USER_DEPT,                                          \n" );
            sql.append( "   CHANGE_DATE,                                            \n" );
            sql.append( "   CHANGE_TIME,                                            \n" );
            sql.append( "   CHANGE_USER_ID,                                         \n" );
            sql.append( "   CHANGE_USER_NAME_ENG,                                   \n" );
            sql.append( "   CHANGE_USER_NAME_LOC,                                   \n" );
            sql.append( "   CHANGE_USER_DEPT,                                       \n" );
            sql.append( "   CONFIRM_DATE,                                           \n" );
            sql.append( "   CONFIRM_TIME,                                           \n" );
            sql.append( "   CONFIRM_USER_ID,                                        \n" );
            sql.append( "   PO_CREATE_DATE,                                         \n" );
            sql.append( "   ACCOUNT_TYPE,                                           \n" );
            sql.append( "   PROCESS_TYPE,                                           \n" );
            sql.append( "   SHIPPER_TYPE,                                           \n" );
            sql.append( "   PAY_TERMS,                                              \n" );
            sql.append( "   PAY_TEXT,                                               \n" );
            sql.append( "   DELY_TERMS,                                             \n" );
            sql.append( "   CUR,                                                    \n" );
            sql.append( "   PO_TTL_AMT,                                             \n" );
            sql.append( "   PO_TAX_TTL_AMT,                                         \n" );
            sql.append( "   SHIPPING_METHOD,                                        \n" );
            sql.append( "   DEPART_PORT,                                            \n" );
            sql.append( "   ARRIVAL_PORT,                                           \n" );
            sql.append( "   DEPART_PORT_NAME,                                       \n" );
            sql.append( "   ARRIVAL_PORT_NAME,                                      \n" );
            sql.append( "   PURCHASER_ID,                                           \n" );
            sql.append( "   PURCHASER_NAME,                                         \n" );
            sql.append( "   SALES_PERSON_NAME,                                      \n" );
            sql.append( "   SALES_PERSON_TEL,                                       \n" );
            sql.append( "   SUBJECT,                                                \n" );
            sql.append( "   REMARK,                                                 \n" );
            sql.append( "   ADV_PAY_AMT,                                            \n" );
            sql.append( "   ADV_PAY_DATE,                                           \n" );
            sql.append( "   REMAIN_AMT,                                             \n" );
            sql.append( "   VERSION,                                                \n" );
            sql.append( "   EMAIL_FLAG,                                             \n" );
            sql.append( "   COMPLETE_MARK,                                          \n" );
            sql.append( "   PRICE_TYPE,                                             \n" );
            sql.append( "   WARRENTY,                                               \n" );
            sql.append( "   SIGN_FLAG,                                              \n" );
            sql.append( "   SIGN_DATE,                                              \n" );
            sql.append( "   SIGN_PERSON_ID,                                         \n" );
            sql.append( "   PR_LOCATION,                                            \n" );
            sql.append( "   BILL_TO_LOCATION,                                       \n" );
            sql.append( "   BILL_TO_ADDRESS,                                        \n" );
            sql.append( "   GR_BASE_FLAG,                                           \n" );
            sql.append( "   EXP_ITEM_NO,                                            \n" );
            sql.append( "   TTL_CHARGE,                                             \n" );
            sql.append( "   NET_AMT,                                                \n" );
            sql.append( "   FOB_CHARGE,                                             \n" );
            sql.append( "   INV_COMPLETE_FLAG,                                      \n" );
            sql.append( "   DELY_TO_LOCATION,                                       \n" );
            sql.append( "   DELY_TO_ADDRESS,                                        \n" );
            sql.append( "   PRICE_CTRL_TYPE,                                        \n" );
            sql.append( "   VENDOR_CODE,                                            \n" );
            sql.append( "   CONSIGNEE,                                              \n" );
            sql.append( "   PAYEE,                                                  \n" );
            sql.append( "   PAYER,                                                  \n" );
            sql.append( "   NOTIFY,                                                 \n" );
            sql.append( "   VENDOR_FWDR_CODE,                                       \n" );
            sql.append( "   BUYER_FWDR_CODE,                                        \n" );
            sql.append( "   INSTALLMENT_PAY_FLAG,                                   \n" );
            sql.append( "   VENDOR_FWDR_NAME,                                       \n" );
            sql.append( "   BUYER_FWDR_NAME,                                        \n" );
            sql.append( "   TRANSFER_FLAG,                                          \n" );
            sql.append( "   REVOCABLE_FLAG,                                         \n" );
            sql.append( "   PRESENT_TERM,                                           \n" );
            sql.append( "   PARTIAL_SHIPPING_FLAG,                                  \n" );
            sql.append( "   TRANS_SHIPPING_FLAG,                                    \n" );
            sql.append( "   PAY_TYPE,                                               \n" );
            sql.append( "   CONFIRM_INST,                                           \n" );
            sql.append( "   DOC_TYPE                                                \n" );
            sql.append( ")                                                          \n" );
            sql.append( "(                                                          \n" );
            sql.append( "SELECT                                                     \n" );
            sql.append( "   PD.HOUSE_CODE,                                          \n" );
            sql.append( "   PD.PO_NO,                                               \n" );
            sql.append( "   PD.COMPANY_CODE,                                        \n" );
            sql.append( "   PD.OPERATING_CODE,                                      \n" );
            sql.append( "   NVL(PD.PLANT_CODE,'$'),                                 \n" );
            sql.append( "   'C',                                                    \n" );
            sql.append( "   PD.ADD_DATE,                                            \n" );
            sql.append( "   PD.ADD_TIME,                                            \n" );
            sql.append( "   PD.ADD_USER_ID,                                         \n" );
            sql.append( "   PD.ADD_USER_NAME_ENG,                                   \n" );
            sql.append( "   PD.ADD_USER_NAME_LOC,                                   \n" );
            sql.append( "   PD.ADD_USER_DEPT,                                       \n" );
            sql.append( "   PD.CHANGE_DATE,                                         \n" );
            sql.append( "   PD.CHANGE_TIME,                                         \n" );
            sql.append( "   PD.CHANGE_USER_ID,                                      \n" );
            sql.append( "   PD.CHANGE_USER_NAME_ENG,                                \n" );
            sql.append( "   PD.CHANGE_USER_NAME_LOC,                                \n" );
            sql.append( "   PD.CHANGE_USER_DEPT,                                    \n" );
            sql.append( "   ' ',                                                    \n" );
            sql.append( "   ' ',                                                    \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   TO_CHAR(SYSDATE,'YYYYMMDD'),                            \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   RD.SHIPPER_TYPE,                                        \n" );
            sql.append( "   I.PAY_TERMS,                                            \n" );
            sql.append( "   I.PAY_TEXT,                                             \n" );
            sql.append( "   I.DELY_TERMS,                                           \n" );
            sql.append( "   I.CUR,                                                  \n" );
            sql.append( "   (SELECT SUM(NVL(ITEM_AMT,0)) FROM ICOYPODT WHERE HOUSE_CODE = '"+house_code+"' AND PO_NO = '"+po_no+"') ,0),\n" );
            sql.append( "   (SELECT SUM(NVL(ITEM_AMT,0)) + SUM(NVL(TAX_AMT,0)) FROM ICOYPODT WHERE HOUSE_CODE = '"+house_code+"' AND PO_NO = '"+po_no+"'),\n" );
            sql.append( "   I.SHIPPING_METHOD,                                      \n" );

            sql.append( "   I.DEPART_PORT,                                         \n" );
            sql.append( "   I.ARRIVAL_PORT,                                        \n" );

            sql.append( "   I.DEPART_PORT_NAME,                                     \n" );
            sql.append( "   I.ARRIVAL_PORT_NAME,                                    \n" );
            sql.append( "   RD.PURCHASER_ID,                                        \n" );
            sql.append( "   RD.PURCHASER_NAME,                                      \n" );
            sql.append( "   I.SALES_PERSON_NAME,                                    \n" );
            sql.append( "   I.SALES_PERSON_TEL,                                     \n" );
            sql.append( "   'PO CREATED AUTOMETICALLY',                             \n" );
            sql.append( "   I.PO_REMARK,                                            \n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   0,                                                      \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   'N',                                                    \n" );
            sql.append( "   'N',                                                    \n" );
            sql.append( "   I.PRICE_TYPE,                                           \n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   '"+sign_flag+"',                                        \n" );
            sql.append( "   '"+sign_date+"',                                        \n" );
            sql.append( "   '"+sign_user_id+"',                                     \n" );
            sql.append( "   RH.PR_LOCATION,                                         \n" );
            sql.append( "   DECODE(I.BILL_TO_LOCATION,NULL,I.COMPANY_CODE,I.BILL_TO_LOCATION),\n" );
            sql.append( "   DECODE(I.BILL_TO_LOCATION,NULL,CG.ADDRESS_ENG,I.BILL_TO_ADDRESS),\n" );
            sql.append( "   I.GR_BASE_FLAG,                                         \n" );
            sql.append( "   I.EXP_ITEM_NO,                                          \n" );
            sql.append( "   '',                         \n" );
            sql.append( "   (SELECT SUM(NVL(ITEM_AMT,0)) FROM ICOYPODT WHERE HOUSE_CODE = '"+house_code+"' AND PO_NO = '"+po_no+"'),\n" );
            sql.append( "   '',                                                     \n" );
            sql.append( "   'N',                                                    \n" );
            sql.append( "   RD.STR_CODE,                                            \n" );
            sql.append( "   I.DELY_TO_ADDRESS,                                      \n" );
            sql.append( "   I.PRICE_CTRL_TYPE,                                      \n" );
            sql.append( "   PD.VENDOR_CODE,                                         \n" );
            sql.append( "   PD.COMPANY_CODE,                                        \n" );
            sql.append( "   PD.VENDOR_CODE,                                         \n" );
            sql.append( "   PD.COMPANY_CODE,                                        \n" );
            sql.append( "   PD.COMPANY_CODE,                                        \n" );
            sql.append( "   PAYEE,                                                  \n" );
            sql.append( "   PAYER,                                                  \n" );
            sql.append( "   NOTIFY                                                  \n" );
            sql.append( "   VENFWDR.NAME_ENG,                                       \n" );
            sql.append( "   BUYFWDR.NAME_ENG,                                       \n" );
            sql.append( "   FR.TRANSFER_FLAG,                                       \n" );
            sql.append( "   FR.REVOCABLE_FLAG,                                      \n" );
            sql.append( "   FR.PRESENT_TERM,                                        \n" );
            sql.append( "   DECODE(RTRIM(FR.PARTIAL_SHIPPING_FLAG),NULL,'P','N','P','Y','A'),\n" );
            sql.append( "   DECODE(RTRIM(FR.TRANS_SHIPPING_FLAG),NULL,'P','N','P','Y','A'),\n" );
            sql.append( "   'DR',                                                   \n" );
            sql.append( "   'DA',                                                   \n" );
            sql.append( "   'R'                                                     \n" );
            sql.append( "FROM                                                       \n" );
            sql.append( "   ICOMCMGL CG,                                            \n" );
            sql.append( "   ICOYINFO I,                                             \n" );
            sql.append( "   ICOMVNFR FR,                                            \n" );
            sql.append( "   ICOMVNPU PU,                                            \n" );

            //sql.append( " ICOYCNSE CS,                                            \n" );
            //sql.append( " ICOYQTDT QD,                                            \n" );

            sql.append( "   ICOYPODT PD,                                            \n" );
            sql.append( "   ICOYPRHD RH,                                            \n" );
            sql.append( "   ICOYPRDT RD,                                            \n" );
            sql.append( "   (SELECT HOUSE_CODE,PARTNER_CODE,NAME_ENG FROM ICOMCMPT WHERE PARTNER_TYPE ='FW' AND STATUS IN ('C','R')) BUYFWDR,\n" );
            sql.append( "   (SELECT HOUSE_CODE,PARTNER_CODE,NAME_ENG FROM ICOMVNPT WHERE PARTNER_TYPE ='FW' AND STATUS IN ('C','R')) VENFWDR,\n" );
            sql.append( "WHERE  PD.HOUSE_CODE = '"+house_code+"'                \n" );
            sql.append( "AND    PD.PO_NO = '"+po_no+"'                          \n" );
            sql.append( "AND    PD.PO_SEQ = '000001'                            \n" );
            sql.append( "AND    RH.HOUSE_CODE = PD.HOUSE_CODE                   \n" );
            sql.append( "AND    RH.PR_NO = PD.PR_NO                             \n" );
            sql.append( "AND    RD.HOUSE_CODE = PD.HOUSE_CODE                   \n" );
            sql.append( "AND    RD.PR_NO = PD.PR_NO                             \n" );
            sql.append( "AND    RD.PR_SEQ = PD.PR_SEQ                           \n" );
            sql.append( "AND    I.HOUSE_CODE = PD.HOUSE_CODE                    \n" );
            sql.append( "AND    I.OPERATING_CODE = PD.OPERATING_CODE            \n" );
            sql.append( "AND    I.VENDOR_CODE = PD.VENDOR_CODE                  \n" );
            sql.append( "AND    I.ITEM_NO = PD.ITEM_NO                          \n" );
            sql.append( "AND        CG.HOUSE_CODE = PD.HOUSE_CODE                   \n" );
            sql.append( "AND    CG.COMPANY_CODE = PD.COMPANY_CODE               \n" );
            //sql.append( "AND  CS.HOUSE_CODE = RD.HOUSE_CODE                   \n" );
            //sql.append( "AND  CS.VENDOR_CODE = RD.PO_VENDOR_CODE              \n" );
            //sql.append( "AND  CS.PR_NO = RD.PR_NO                             \n" );
            //sql.append( "AND  CS.PR_SEQ = RD.PR_SEQ                           \n" );
            //sql.append( "AND  CS.EXEC_NO = I.EXEC_NO                          \n" );
            //sql.append( "AND  QD.VENDOR_CODE = CS.VENDOR_CODE                 \n" );
            //sql.append( "AND  QD.QTA_NO = CS.QTA_NO                           \n" );
            //sql.append( "AND  QD.QTA_SEQ = CS.QTA_SEQ                         \n" );
            sql.append( "AND     PU.HOUSE_CODE(+) = PD.HOUSE_CODE                   \n" );
            sql.append( "AND     PU.COMPANY_CODE(+) = PD.COMPANY_CODE               \n" );
            sql.append( "AND     PU.OPERATING_CODE(+) = PD.OPERATING_CODE           \n" );
            sql.append( "AND     PU.VENDOR_CODE(+) = PD.VENDOR_CODE                 \n" );
            sql.append( "AND     FR.HOUSE_CODE(+) = PD.HOUSE_CODE                   \n" );
            sql.append( "AND     FR.COMPANY_CODE(+) = PD.COMPANY_CODE               \n" );
            sql.append( "AND     FR.OPERATING_CODE(+) = PD.OPERATING_CODE           \n" );
            sql.append( "AND     FR.VENDOR_CODE(+) = PD.VENDOR_CODE                 \n" );
            sql.append( "AND     FR.HOUSE_CODE  = BUYFWDR.HOUSE_CODE(+)             \n" );
            sql.append( "AND     FR.BUYER_FWDR_CODE = BUYFWDR.PARTNER_CODE(+)       \n" );
            sql.append( "AND     FR.HOUSE_CODE = VENFWDR.HOUSE_CODE(+)              \n" );
            sql.append( "AND     FR.VENDOR_FWDR_CODE = VENFWDR.PARTNER_CODE(+)      \n" );
            sql.append( ")                                                          \n" );

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());

            rtn = sm.doInsert((String[][])null, null);

            Logger.debug.println(user_id,this," setPohdOverseasInsert rtn======"+rtn);

        }catch(Exception e) {
            throw new Exception("setPohdOverseasInsert:"+e.getMessage());
        }

        return rtn;


    }

    /**
     *  발주를 생성하기 위한 업체코드 조회
     **/
    private String getRAInfo(String ra_no, String ra_count, String ra_seq, String vendor_code) throws Exception {

        String rtn = null;
        ConnectionContext ctx = getConnectionContext();

        try {


            StringBuffer sql = new StringBuffer();

            sql.append( "SELECT RABD.VENDOR_CODE VENDOR_CODE,           \n" );
            sql.append( "       RADT.COMPANY_CODE COMPANY_CODE,         \n" );
            sql.append( "       RADT.OPERATING_CODE OPERATING_CODE,     \n" );
            sql.append( "       RADT.PR_NO PR_NO,               \n" );
            sql.append( "       RADT.PR_SEQ PR_SEQ,             \n" );
            sql.append( "       RABD.SETTLE_QTY SETTLE_QTY,         \n" );
            sql.append( "       RADT.RA_SEQ                 \n" );
            sql.append( "FROM   ICOYRADT RADT, ICOYRABD RABD                    \n" );
            sql.append( "WHERE  RADT.HOUSE_CODE = RABD.HOUSE_CODE               \n" );
            sql.append( "AND    RADT.HOUSE_CODE = '"+house_code+"'              \n" );
            sql.append( "AND    RADT.RA_NO  = RABD.RA_NO                    \n" );
            sql.append( "AND    RADT.RA_NO  = '"+ra_no+"'                   \n" );
            sql.append( "AND    RADT.RA_SEQ = RABD.RA_SEQ                   \n" );
            sql.append( "AND    RADT.RA_SEQ = '"+ra_seq+"'                  \n" );
            sql.append( "AND    RABD.VENDOR_CODE    = '"+vendor_code+"'         \n" );
            sql.append( "AND    RADT.RA_COUNT   = RABD.RA_COUNT                 \n" );
            sql.append( "AND    RADT.RA_COUNT   = '"+ra_count+"'                \n" );
            sql.append( "AND    RABD.SETTLE_FLAG= 'Y'                           \n" );

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());

            rtn = sm.doSelect((String[])null);

        }catch(Exception e) {
            Logger.debug.println(user_id,this,"getRAInfo=======>" +e.getMessage());
            throw new Exception("getRAInfo=======>" +e.getMessage());
        }
        finally {


        }
        return rtn;
    }


	/*
	 * 취소공고~ 화면 디스플레이
	 */
    public SepoaOut getRAHDDisplay(String RA_NO, String RA_COUNT)
    {

        String rtnData = null;
        try {
            rtnData = et_getRAHDDisplay(RA_NO, RA_COUNT);

            setStatus(1);
            setValue(rtnData);
            setMessage(msg.getMessage("0000"));
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }
        return getSepoaOut();
    }

    private String et_getRAHDDisplay(String RA_NO, String RA_COUNT) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("ra_no", RA_NO);
        wxp.addVar("ra_count", RA_COUNT);

        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());

            rtn = sm.doSelect((String[])null);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }



    public SepoaOut getRADTDisplay(Map<String, String> header)
    {

        String rtnData = null;
        try {
            rtnData = et_getRADTDisplay(header);

            setStatus(1);
            setValue(rtnData);
            setMessage(msg.getMessage("0000"));
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }
        return getSepoaOut();
    }

    private String et_getRADTDisplay(Map<String, String> header) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("HOUSE_CODE"	, info.getSession("HOUSE_CODE"));
        wxp.addVar("RA_NO"		, header.get("RA_NO"));
        wxp.addVar("RA_COUNT"	, header.get("RA_COUNT"));

        /*
        sql.append(" SELECT \n");
        sql.append("        STATUS                  ,   \n");
        sql.append("        ADD_DATE                ,   \n");
        sql.append("        ADD_TIME                ,   \n");
        sql.append("        ADD_USER_ID             ,   \n");
        sql.append("        ADD_USER_NAME_LOC       ,   \n");
        sql.append("        ADD_USER_NAME_ENG       ,   \n");
        sql.append("        ADD_USER_DEPT           ,   \n");
        sql.append("        CHANGE_DATE             ,   \n");
        sql.append("        CHANGE_TIME             ,   \n");
        sql.append("        CHANGE_USER_ID          ,   \n");
        sql.append("        CHANGE_USER_NAME_LOC    ,   \n");
        sql.append("        CHANGE_USER_NAME_ENG    ,   \n");
        sql.append("        CHANGE_USER_DEPT        ,   \n");
        sql.append("        BUYER_ITEM_NO           ,   \n");
        sql.append("        DESCRIPTION_LOC         ,   \n");
        sql.append("        UNIT_MEASURE            ,SPECIFICATION,  \n");
        sql.append("        RA_QTY                 ,    \n");
        sql.append("        CUR                     ,                        \n");
        sql.append("        UNIT_PRICE              ,                        \n");
        sql.append("        (RA_QTY*UNIT_PRICE) AS PR_AMT,                   \n");
        sql.append("        PR_NO ,                                          \n");
        sql.append("        PR_SEQ                                           \n");
        sql.append(" FROM ICOYRADT                                           \n");
        sql.append(" WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'  \n");
        sql.append(" AND   RA_NO     = '"+RA_NO+"'                           \n");
        sql.append(" AND   RA_COUNT  = '"+RA_COUNT+"'                        \n");
        sql.append(" AND   STATUS IN ('C', 'R')                              \n");
        */
        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());

            rtn = sm.doSelect((String[])null);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }





    public SepoaOut setGonggoConfirm(Map<String, Object> data)
    {

        int 				      rtn 			= -1;
		List<Map<String, String>> grid          = null;
		Map<String, String>       gridInfo      = null;
		Map<String, String> 	  header		= null;
		
		header = MapUtils.getMap(data, "headerData");       
		
		String RA_NO 	= header.get("RA_NO");
		String RA_FLAG 	= header.get("RA_FLAG");
		String RA_COUNT = header.get("RA_COUNT");
		String RA_TYPE1 = header.get("RA_TYPE1");

        try {
            ConnectionContext ctx = getConnectionContext();


            //rtn = et_setStatusUpdateRAHD(ctx,RA_FLAG, RA_NO, RA_COUNT);
            rtn = et_setStatusUpdateRAHD(ctx,header);

            if("D".equals(RA_FLAG)){ // 취소공고 확정일때만...이전 차수의 status = 'D' 로 update해준다.
                rtn = et_setStatusBeforeUpdateRAHD(ctx, RA_NO, String.valueOf(Integer.parseInt(RA_COUNT) - 1));
            }


            rtn = et_setPRDTUPDATE_Gonggo(ctx, RA_NO, RA_COUNT, RA_FLAG);

            if( rtn == 0 ) {
                setStatus(0);
            } else {
                setStatus(1);
            }

            if("NC".equals(RA_TYPE1)){//지명경쟁일 경우
                	//new mail("CONNECTION",info).sendEmailReversRFQ(RA_NO,RA_COUNT,RA_FLAG);	
            }

            if(!"NC".equals(RA_TYPE1)){//지명경쟁이 아닐 경우
                if("D".equals(RA_FLAG)){ //확정시만
                }
            }
            setValue(String.valueOf(rtn));
            //setMessage(msg.getMessage("0037"));
            setMessage("확정하였습니다.");
            Commit();


        }catch(Exception e){
            try {
                Rollback();
                //setMessage(msg.getMessage("0036"));
                setMessage("확정에 실패하였습니다.");
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            Logger.err.println(this,e.getMessage());
            setStatus(0);
        }
        return getSepoaOut();
    }



    
    private int et_setStatusUpdateRAHD(ConnectionContext ctx, Map<String, String> header) throws Exception
    						
    {
        int rtn = 0;

        SepoaSQLManager sm = null;
        SepoaXmlParser wxp = null;

        try {
        	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn = sm.doInsert(header);

        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }





    private int et_setStatusBeforeUpdateRAHD(ConnectionContext ctx,
             String RA_NO, String RA_COUNT ) throws Exception
    {
        int rtn = 0;

        SepoaSQLManager sm = null;
        SepoaXmlParser wxp = null;
        try {
        	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	wxp.addVar("user_id", user_id);
        	wxp.addVar("department", department);
        	wxp.addVar("name_eng", name_eng);
        	wxp.addVar("name_loc", name_loc);
        	wxp.addVar("house_code", house_code);
        	wxp.addVar("RA_NO", RA_NO);
        	wxp.addVar("RA_COUNT", RA_COUNT);
        	        	
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn = sm.doUpdate((String[][])null, null);

        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }




    private int et_setPRDTUPDATE_Gonggo(ConnectionContext ctx, String RA_NO, String RA_COUNT, String RA_FLAG) throws Exception
    {
        int rtn = 0;
        SepoaSQLManager sm = null;
        SepoaXmlParser wxp = null;
        try {
        	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	wxp.addVar("RA_FLAG", RA_FLAG);
        	wxp.addVar("house_code", house_code);
        	wxp.addVar("RA_NO", RA_NO);
        	wxp.addVar("RA_COUNT", RA_COUNT);
        	        	
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());


            rtn = sm.doUpdate((String[][])null, null);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }


    public int setMail_A(String RA_NO, String RA_COUNT , String TYPE, String DOC_NAME )
    {
        int rtn = 0;

        int m=0;

        try{
            ConnectionContext ctx = getConnectionContext();

            StringBuffer sql = new StringBuffer();

            sql.append(" SELECT (SELECT EMAIL                                               \n");
            sql.append("        FROM ICOMVNCP                                               \n");
            sql.append("        WHERE HOUSE_CODE='"+house_code+"'                           \n");
            sql.append("          AND VENDOR_CODE = RQSE.VENDOR_CODE) AS VENDOR_EMAIL       \n");
            sql.append("        , (SELECT NAME_LOC                                          \n");
            sql.append("          FROM ICOMVNGL                                             \n");
            sql.append("          WHERE HOUSE_CODE='"+house_code+"'                         \n");
            sql.append("            AND VENDOR_CODE = RQSE.VENDOR_CODE) AS VENDOR_NAME      \n");
            sql.append(" FROM ICOYRQSE RQSE                                                 \n");
            sql.append(" WHERE HOUSE_CODE = '"+house_code+"'                                \n");
            sql.append("   AND RFQ_NO = '"+RA_NO+"'                                        \n");
            sql.append("   AND RFQ_COUNT = '"+RA_COUNT+"'                                  \n");


            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            String rtnSel = sm.doSelect((String[])null);

            SepoaFormater wf = new SepoaFormater(rtnSel);

            for( int i=0; i<wf.getRowCount(); i++ )
            {
                String ReceiverMail   = wf.getValue(i,0);
                String ReceiverName   = wf.getValue(i,1);

                Logger.debug.println(info.getSession("ID"),this,"ReceiverMail====================="+ReceiverMail);
                Logger.debug.println(info.getSession("ID"),this,"ReceiverName====================="+ReceiverName);

                String [] args =  {RA_NO, TYPE, DOC_NAME, ReceiverMail,ReceiverName };

                String serviceId = "SendMail2";
                Object[] obj = { args };
                String conType = "NONDBJOB";                    //conType : CONNECTION/TRANSACTION/NONDBJOB
                String MethodName = "mailDomestic";             //NickName으로 연결된 Class에 정의된 Method Name

                SepoaOut value = null;
                SepoaRemote wr = null;

                //다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
                try
                {

                    wr = new SepoaRemote( serviceId, conType, info );
                    wr.setConnection(ctx);

                    value = wr.lookup( MethodName, obj );
                    Logger.debug.println(info.getSession("ID"),this,"value.status====================="+value.status);

                    rtn = value.status;

                }catch( SepoaServiceException wse ) {
//                	try{
                        Logger.err.println("wse = " + wse.getMessage());
//                        Logger.err.println("message = " + value.message);
//                        Logger.err.println("status = " + value.status);               		
//                	}catch(NullPointerException ne){
//                		
//                	}
                }catch(Exception e) {
//                	try{
                        Logger.err.println("err = " + e.getMessage());
//                        Logger.err.println("message = " + value.message);
//                        Logger.err.println("status = " + value.status);                		
//                	}catch(NullPointerException ne){
//    	    			
//    	    		}
                }
                finally{

                }
            }
        }catch(Exception ee )
        {
        	Logger.err.println("err = " + ee.getMessage());
        }

        return rtn;
    }

    public int setMail_B(String RA_NO, String RA_COUNT , String TYPE, String DOC_NAME )
    {
        int rtn = 0;

        int m=0;
        
        SepoaXmlParser wxp = null;
        
        try{
            ConnectionContext ctx = getConnectionContext();
     
            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            wxp.addVar("house_code", house_code);
            wxp.addVar("RA_NO", RA_NO);
            wxp.addVar("RA_COUNT", RA_COUNT);
            wxp.addVar("TYPE", TYPE);

            /*
            sql.append(" SELECT (SELECT EMAIL                                               \n");
            sql.append("        FROM ICOMVNCP                                               \n");
            sql.append("        WHERE HOUSE_CODE='"+house_code+"'                           \n");
            sql.append("          AND VENDOR_CODE = RABD.VENDOR_CODE) AS VENDOR_EMAIL       \n");
            sql.append("        , (SELECT VENDOR_NAME_LOC                                   \n");
            sql.append("          FROM ICOMVNGL                                             \n");
            sql.append("          WHERE HOUSE_CODE='"+house_code+"'                         \n");
            sql.append("            AND VENDOR_CODE = RABD.VENDOR_CODE) AS VENDOR_NAME      \n");
            sql.append(" FROM ICOYRABD RABD                                                 \n");
            sql.append(" WHERE HOUSE_CODE = '"+house_code+"'                                \n");
            sql.append("   AND RA_NO = '"+RA_NO+"'                                        \n");
            sql.append("   AND RA_COUNT = '"+RA_COUNT+"'                                  \n");
			if(TYPE.equals("R02")){
            	sql.append("   AND SETTLE_FLAG = 'Y'                                  \n");
			}
			*/
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            String rtnSel = sm.doSelect((String[])null);

            SepoaFormater wf = new SepoaFormater(rtnSel);

            for( int i=0; i<wf.getRowCount(); i++ )
            {
                String ReceiverMail   = wf.getValue(i,0);
                String ReceiverName   = wf.getValue(i,1);

                Logger.debug.println(info.getSession("ID"),this,"ReceiverMail====================="+ReceiverMail);
                Logger.debug.println(info.getSession("ID"),this,"ReceiverName====================="+ReceiverName);

                String [] args =  {RA_NO, TYPE, DOC_NAME, ReceiverMail,ReceiverName };

                String serviceId = "SendMail2";
                Object[] obj = { args };
                String conType = "NONDBJOB";                    //conType : CONNECTION/TRANSACTION/NONDBJOB
                String MethodName = "mailDomestic";             //NickName으로 연결된 Class에 정의된 Method Name

                SepoaOut value = null;
                SepoaRemote wr = null;

                //다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
                try
                {

                    wr = new SepoaRemote( serviceId, conType, info );
                    wr.setConnection(ctx);

                    value = wr.lookup( MethodName, obj );
                    Logger.debug.println(info.getSession("ID"),this,"value.status====================="+value.status);

                    rtn = value.status;

                }catch( SepoaServiceException wse ) {
//                	try{
                        Logger.err.println("wse = " + wse.getMessage());
//                        Logger.err.println("message = " + value.message);
//                        Logger.err.println("status = " + value.status);                		
//                	}catch(NullPointerException ne){
//                		
//                	}
                }catch(Exception e) {
//                	try{
                        Logger.err.println("err = " + e.getMessage());
//                        Logger.err.println("message = " + value.message);
//                        Logger.err.println("status = " + value.status);                		
//                	}catch(NullPointerException ne){
//    	    			
//    	    		}
                }
//                finally{
//
//                }
            }
        }catch(Exception ee )
        {
        	Logger.err.println("err = " + ee.getMessage());
        }

        return rtn;
    }

    private void RFQ_SMS_send(String RA_NO, String RA_COUNT, String user_id, String sms_code) throws Exception {

        String rtn = "";
        SepoaSQLManager sm = null;
        SepoaFormater Sepoaformater1 = null;
        SepoaFormater Sepoaformater2 = null;
        SepoaFormater Sepoaformater3 = null;


        String vendor_name  = "";
        String receive_no   = "";
        String send_no      = "";

        ConnectionContext ctx = getConnectionContext();
        try {
            StringBuffer sql1 = new StringBuffer();

            sql1.append(" SELECT (SELECT REPLACE(MOBILE_NO, '-', '')                                               \n");
            sql1.append("        FROM ICOMVNCP                                               \n");
            sql1.append("        WHERE HOUSE_CODE='"+house_code+"'                           \n");
            sql1.append("          AND VENDOR_CODE = RQSE.VENDOR_CODE) AS SMS_RECEIVE_NO     \n");
            sql1.append("        , (SELECT NAME_LOC                                          \n");
            sql1.append("          FROM ICOMVNGL                                             \n");
            sql1.append("          WHERE HOUSE_CODE='"+house_code+"'                         \n");
            sql1.append("            AND VENDOR_CODE = RQSE.VENDOR_CODE) AS VENDOR_NAME      \n");
            sql1.append(" FROM ICOYRQSE RQSE                                                 \n");
            sql1.append(" WHERE HOUSE_CODE = '"+house_code+"'                                \n");
            sql1.append("   AND RFQ_NO = '"+RA_NO+"'                                        \n");
            sql1.append("   AND RFQ_COUNT = '"+RA_COUNT+"'                                  \n");

            sm = new SepoaSQLManager(user_id, this, ctx, sql1.toString());
            rtn = sm.doSelect((String[])null);

            Sepoaformater1 = new SepoaFormater(rtn);

            StringBuffer sql2 = new StringBuffer();

            sql2.append("SELECT \n");
            sql2.append("    REPLACE(MOBILE_NO, '-', '') AS SMS_SEND_NO \n");
            sql2.append("FROM \n");
            sql2.append("    ICOMLUSR \n");
            sql2.append("WHERE \n");
            sql2.append("    HOUSE_CODE = '" + house_code + "' \n");
            sql2.append("    AND USER_ID = '" + user_id + "' \n");

            sm = new SepoaSQLManager(user_id, this, ctx, sql2.toString());
            rtn = sm.doSelect((String[])null);

            Sepoaformater2 = new SepoaFormater(rtn);

            ////sendSms //sendSms = null;
            String[][] ra_sms_data = new String[Sepoaformater1.getRowCount()][4];
            for (int i=0; i<Sepoaformater1.getRowCount(); i++) {
                vendor_name = Sepoaformater1.getValue("VENDOR_NAME", i);
                receive_no  = Sepoaformater1.getValue("SMS_RECEIVE_NO", i);
                send_no     = Sepoaformater2.getValue("SMS_SEND_NO", 0);
                if(vendor_name==null) vendor_name="";
                if(receive_no==null) receive_no="";
                if(send_no==null) send_no="";
                ra_sms_data[i][0] = vendor_name;
                ra_sms_data[i][1] = name_loc;
                ra_sms_data[i][2] = receive_no;
                ra_sms_data[i][3] = send_no;
            }
            //sendSms = new //sendSms(info, ctx); // //sendSms 객체 생성
            //sendSms.sendMessage(sms_code, ra_sms_data);// //sendSms 의 sendMessage Method call

         } catch(Exception e) {
            Logger.debug.println(info.getSession("ID"), this, "et_getratbdins1_1 = " + e.getMessage());
        } finally {}
    }

    private void RFQ_SMS_send2(String RA_NO, String RA_COUNT, String user_id, String sms_code) throws Exception {

        String rtn = "";
        SepoaSQLManager sm = null;
        SepoaFormater Sepoaformater1 = null;
        SepoaFormater Sepoaformater2 = null;
        SepoaFormater Sepoaformater3 = null;


        String vendor_name  = "";
        String receive_no   = "";
        String send_no      = "";
        SepoaXmlParser wxp = null;
        ConnectionContext ctx = getConnectionContext();
        try {
            
            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
            wxp.addVar("house_code", house_code);
            wxp.addVar("RA_NO", RA_NO);
            wxp.addVar("RA_COUNT", RA_COUNT);
            wxp.addVar("sms_code", sms_code);
            
            /*
            sql1.append(" SELECT (SELECT REPLACE(MOBILE_NO, '-', '')                                               \n");
            sql1.append("        FROM ICOMVNCP                                               \n");
            sql1.append("        WHERE HOUSE_CODE='"+house_code+"'                           \n");
            sql1.append("          AND VENDOR_CODE = RABD.VENDOR_CODE) AS SMS_RECEIVE_NO     \n");
            sql1.append("        , (SELECT NAME_LOC                                          \n");
            sql1.append("          FROM ICOMVNGL                                             \n");
            sql1.append("          WHERE HOUSE_CODE='"+house_code+"'                         \n");
            sql1.append("            AND VENDOR_CODE = RABD.VENDOR_CODE) AS VENDOR_NAME      \n");
            sql1.append(" FROM ICOYRABD RABD                                                 \n");
            sql1.append(" WHERE HOUSE_CODE = '"+house_code+"'                                \n");
            sql1.append("   AND RA_NO = '"+RA_NO+"'                                        \n");
            sql1.append("   AND RA_COUNT = '"+RA_COUNT+"'                                  \n");
            if(sms_code.equals("R02")){
            	sql1.append("   AND SETTLE_FLAG = 'Y'                                  \n");
            }
            sql1.append("   AND ROWNUM < 2				                                  \n");
			*/
            sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
            rtn = sm.doSelect((String[])null);

            Sepoaformater1 = new SepoaFormater(rtn);

            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
            wxp.addVar("house_code", house_code);
            wxp.addVar("user_id", user_id);
            
            /*
            sql2.append("SELECT \n");
            sql2.append("    REPLACE(MOBILE_NO, '-', '') AS SMS_SEND_NO \n");
            sql2.append("FROM \n");
            sql2.append("    ICOMLUSR \n");
            sql2.append("WHERE \n");
            sql2.append("    HOUSE_CODE = '" + house_code + "' \n");
            sql2.append("    AND USER_ID = '" + user_id + "' \n");
			*/
            
            sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
            rtn = sm.doSelect((String[])null);

            Sepoaformater2 = new SepoaFormater(rtn);

            ////sendSms //sendSms = null;
            String[][] ra_sms_data = new String[Sepoaformater1.getRowCount()][4];
            for (int i=0; i<Sepoaformater1.getRowCount(); i++) {
                vendor_name = Sepoaformater1.getValue("VENDOR_NAME", i);
                receive_no  = Sepoaformater1.getValue("SMS_RECEIVE_NO", i);
                send_no     = Sepoaformater2.getValue("SMS_SEND_NO", 0);
                if(vendor_name==null) vendor_name="";
                if(receive_no==null) receive_no="";
                if(send_no==null) send_no="";
                ra_sms_data[i][0] = vendor_name;
                ra_sms_data[i][1] = name_loc;
                ra_sms_data[i][2] = receive_no;
                ra_sms_data[i][3] = send_no;
            }
            //sendSms = new //sendSms(info, ctx); // //sendSms 객체 생성
            //sendSms.sendMessage(sms_code, ra_sms_data);// //sendSms 의 sendMessage Method call

         } catch(Exception e) {
            Logger.debug.println(info.getSession("ID"), this, "et_getratbdins1_1 = " + e.getMessage());
        } finally {}
    }

    private void set_interface_flag(String RA_FLAG, String RA_NO, String RA_COUNT)
    throws Exception
    {
        StringBuffer sql    = null;
        SepoaSQLManager sm   = null;
        SepoaFormater wf     = null;

        //msconn.setAutoCommit(false);
        ConnectionContext ctx   = getConnectionContext();
        String rtn = "";

        sql = new StringBuffer();

        sql.append(" SELECT PR_NO, PR_SEQ                                       \n");
        sql.append(" FROM ICOYRADT                                              \n");
        sql.append(" WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'     \n");
        sql.append("   AND RA_NO = '"+RA_NO+"'                                \n");
        sql.append("   AND RA_COUNT = '"+RA_COUNT+"'                          \n");

        try {
            sm = new SepoaSQLManager("", this, ctx, sql.toString());
            rtn = sm.doSelect_limit(null);
        } catch (Exception ex) {
            Logger.debug.println("", this, "getInterfaceInfo = " + ex.getMessage());
            
            throw ex;
        }
        wf = new SepoaFormater(rtn);
        String[][] PR_NO_SEQ    = new String[wf.getRowCount()][2];
        String BID_YN = "";

        for(int i=0; i < wf.getRowCount(); i++){
            PR_NO_SEQ[i][0] = wf.getValue("PR_NO", i);
            PR_NO_SEQ[i][1] = wf.getValue("PR_SEQ", i);
            this.set_BID_YN(RA_FLAG,  PR_NO_SEQ[i][0],  PR_NO_SEQ[i][1]);
            Logger.debug.println(info.getSession("ID"), this, "PR_NO_SEQ[i][0]=========>"+PR_NO_SEQ[i][0]);
            Logger.debug.println(info.getSession("ID"), this, "PR_NO_SEQ[i][1]=========>"+PR_NO_SEQ[i][1]);
        }
    }



    private void set_BID_YN(String RA_FLAG, String PR_NO, String PR_SEQ)
    throws Exception
    {
        //msconn.setAutoCommit(false);
        String BID_YN = "";
        if("D".equals(RA_FLAG)){
            BID_YN = "";
        } else {
            BID_YN = "Y";
        }


        Connection msconn = getConnectionMSSQL();
        Statement ps1 = msconn.createStatement();


        int rtnIns = 0;
        StringBuffer      sql = new StringBuffer();

        try {
            sql.append( "UPDATE                                                 \n");
            sql.append( "    TMA_CNTRREQDETL                                    \n");
            sql.append( "   SET                                                 \n");
            sql.append( "    BID_YN  = '" + BID_YN + "'                         \n");
            sql.append( "WHERE                                                  \n");
            sql.append( "    RTRIM(CNTRREQNO) = '" + PR_NO + "'                 \n");
            sql.append( "    AND CNTRREQDETLLN = '" + PR_SEQ + "'               \n");

            rtnIns = ps1.executeUpdate(sql.toString());
            //Commit();
            ps1.close();
        }catch(Exception e) {
            Rollback();
            
            Logger.debug.println("", this, "error = " + e.getMessage());
        }
        finally{
        	if(msconn != null){
        		try{
        			msconn.close();
        		}
        		catch(Exception e){ Logger.debug.println("", this, "error = " + e.getMessage()); }
        	}
        }
    }

    static public Connection getConnectionMSSQL()
    throws Exception
    {
        Config conf         = new Configuration();
        String driver       = conf.get("Sepoa.interface.interfacedriver");
        String url          = conf.get("Sepoa.interface.interfaceurl");
        String user         = conf.get("Sepoa.interface.interfaceuser");
        String passwd       = conf.get("Sepoa.interface.interfacepassword");



        if (driver == null)
            throw new Exception("JDBC Driver 정보가 존재하지 않습니다.");

        if (url == null)
            throw new Exception("JDBC URL 정보가 존재하지 않습니다.");

        // driver에 해당하는 Class 로드
        Class.forName(driver);

        if (user != null && passwd != null) {
            return DriverManager.getConnection(url, user, passwd);
        }
        else {  // client, user, password 모두 null인 경우
            return DriverManager.getConnection(url);
        }
    }


// 역경매 취소공지
    public SepoaOut setCancelGonggoCreate(String[] data )
    {

        String RA_FLAG             = data[0];
        String BID_STATUS          = data[1];
        String RA_NO               = data[2];
        String RA_COUNT            = data[3];
        String ANN_NO              = data[4];
        String ANN_DATE            = data[5];
        String ANN_ITEM            = data[6];
        String BID_ETC             = data[7];
        String FLAG                = data[8];//scr_flag        
        String ITEM_COUNT          = data[9];
        String TOTAL_AMT           = data[10];
        String approval_str        = data[11];
        

           
        String ANN_TITLE       = "취소공고";

        try {
            ConnectionContext ctx = getConnectionContext();


            String valid_flag = et_getGonggoIsValid(RA_NO); // 해당 입찰번호에 2개 이상의 차수가 존재한다면, 더 진행을 못하게 한다.

            if ("N".equals(valid_flag)) { //아이템이 견적중임.....
                setStatus(0);
                setMessage(msg.getMessage("0037"));
                return getSepoaOut();
            }
            
            SepoaOut maxRaCount_wo = getMaxRaCount(RA_NO);
            SepoaFormater maxRaCount_wf = new SepoaFormater(maxRaCount_wo.result[0]);
            String maxRaCount = maxRaCount_wf.getValue("RA_COUNT", 0);
            
            String F_RA_COUNT = "";
            maxRaCount_wo = getBeforRaCount(RA_NO);
            maxRaCount_wf = new SepoaFormater(maxRaCount_wo.result[0]);
            F_RA_COUNT = maxRaCount_wf.getValue("RA_COUNT", 0);

            int rtnHD          = et_setRAHDCancelCreate(ctx, ANN_NO         ,
                    ANN_DATE       ,
                    ANN_ITEM       ,
                    ANN_TITLE      ,
                    RA_NO         ,		
                    RA_COUNT      ,// 셀렉트할 차수
                    FLAG          ,// FLAG
                    RA_FLAG       ,
                    BID_STATUS    ,
                    BID_ETC		,
                    maxRaCount
                    );

            int rtnDT          = et_setRADTCancelCreate(ctx, RA_NO, RA_COUNT, maxRaCount);

            int rtnRQ          = et_setRARQCancelCreate(ctx, RA_NO ,RA_COUNT, maxRaCount);


           	// 결재로직을 추가해야함. 
            
            if("P".equals(FLAG)) {
            	String add_user_id     =  info.getSession("ID");
				String house_code      =  info.getSession("HOUSE_CODE");
				String company         =  info.getSession("COMPANY_CODE");
				String add_user_dept   =  info.getSession("DEPARTMENT");
			
                SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType("RA");
                sri.setDocNo(ANN_NO);                
//              sri.setDocSeq(String.valueOf(Integer.parseInt(BID_COUNT) + 1));
                sri.setDocSeq(maxRaCount);                
                sri.setItemCount(Integer.parseInt(ITEM_COUNT));
                sri.setSignStatus(FLAG);
                sri.setShipperType("D");
                sri.setCur("KRW");
                sri.setTotalAmt(Double.parseDouble("".equals(TOTAL_AMT) ? "0" : TOTAL_AMT));
                sri.setSignString(approval_str);       // AddParameter 에서 넘어온 정보
                sri.setDocName(ANN_ITEM);
                SepoaOut wo = CreateApproval(info,sri);    //밑에 함수 실행

                if(wo.status == 0){                	
                    try {
                        Rollback();
                    } catch(Exception d) {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.getMessage("0030")); //결재요청이 실패되었습니다.
                    return getSepoaOut();
                }
            } 	
            
            setStatus(1);
            setValue(String.valueOf(rtnHD));
            msg.setArg("ANN_NO", ANN_NO);

            //setMessage(msg.getMessage("0037"));
            if("T".equals(FLAG)) {
                setMessage("저장되었습니다.");
            } else {
                setMessage("결재요청되었습니다.");
            }

            Commit();
//                Rollback();
        } catch(Exception e) {
            try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0003"));
        }
        return getSepoaOut();

    }//setCancelGonggoCreate End

    // 역경매 취소공고 수정
    public SepoaOut setCancelGonggoModify(String[] data){

        String RA_FLAG             = data[0];
        String BID_STATUS          = data[1];
        String RA_NO               = data[2];
        String RA_COUNT            = data[3];
        String ANN_NO              = data[4];
        String ANN_DATE            = data[5];
        String ANN_ITEM            = data[6];
        String BID_ETC             = data[7];
        String FLAG                = data[8];//scr_flag
        String ITEM_COUNT          = data[9];
        String TOTAL_AMT           = data[10];
        String approval_str        = data[11];

        String ANN_TITLE       = "취소공고";

        try {
            ConnectionContext ctx = getConnectionContext();

/*
            String valid_flag = et_getGonggoIsValid(RA_NO); // 해당 입찰번호에 2개 이상의 차수가 존재한다면, 더 진행을 못하게 한다.

            if (valid_flag.equals("N")) { //아이템이 견적중임.....
                setStatus(0);
                setMessage(msg.getMessage("0037"));
                return getSepoaOut();
            }
*/
            int delDT          = et_delRADT(ctx, RA_NO, RA_COUNT);
            int delES          = et_delRASE(ctx, RA_NO, RA_COUNT);
            int delHD          = et_delRAHD(ctx, RA_NO, RA_COUNT);
            
            SepoaOut maxRaCount_wo = getMaxRaCount(RA_NO);
            SepoaFormater maxRaCount_wf = new SepoaFormater(maxRaCount_wo.result[0]);
            String maxRaCount = maxRaCount_wf.getValue("RA_COUNT", 0);
            
            String F_RA_COUNT = "";
            maxRaCount_wo = getBeforRaCount(RA_NO);
            maxRaCount_wf = new SepoaFormater(maxRaCount_wo.result[0]);
            F_RA_COUNT = maxRaCount_wf.getValue("RA_COUNT", 0);
            
            int rtnDT          = et_setRADTCancelCreate(ctx, RA_NO, F_RA_COUNT, maxRaCount);

            int rtnRQ          = et_setRARQCancelCreate(ctx, RA_NO, F_RA_COUNT, maxRaCount);
            
            int rtnHD          = et_setRAHDCancelCreate(ctx, ANN_NO         ,
                    ANN_DATE       ,
                    ANN_ITEM       ,
                    ANN_TITLE      ,
                    RA_NO         ,
                    F_RA_COUNT      ,
                    FLAG            ,// FLAG 
                    RA_FLAG       ,
                    BID_STATUS    ,
                    BID_ETC,
                    maxRaCount
                    );

           	// 결재로직을 추가해야함.
            
            if("P".equals(FLAG)) {
            	String add_user_id     =  info.getSession("ID");
				String house_code      =  info.getSession("HOUSE_CODE");
				String company         =  info.getSession("COMPANY_CODE");
				String add_user_dept   =  info.getSession("DEPARTMENT");

                SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType("RA");
                sri.setDocNo(ANN_NO);                
//              sri.setDocSeq(String.valueOf(Integer.parseInt(BID_COUNT) + 1));
                sri.setDocSeq(maxRaCount);                
                sri.setItemCount(Integer.parseInt(ITEM_COUNT));
                sri.setSignStatus(FLAG);
                sri.setShipperType("D");
                sri.setCur("KRW");
                sri.setTotalAmt(Double.parseDouble("".equals(TOTAL_AMT) ? "0" : TOTAL_AMT));
                sri.setSignString(approval_str);       // AddParameter 에서 넘어온 정보
                sri.setDocName(ANN_ITEM);                
                SepoaOut wo = CreateApproval(info,sri);    //밑에 함수 실행

                if(wo.status == 0){                	
                    try {
                        Rollback();
                    } catch(Exception d) {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.getMessage("0030")); //결재요청이 실패되었습니다.
                    return getSepoaOut();
                }
            } 	

            setStatus(1);
            setValue(String.valueOf(rtnHD));
            msg.setArg("ANN_NO", ANN_NO);

            setMessage(msg.getMessage("0037"));
            if("T".equals(FLAG)) {
                setMessage("저장되었습니다.");
            } else {
                setMessage("결재요청되었습니다.");
            }
            Commit();
//                Rollback();
        } catch(Exception e) {
            try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0003"));
        }
        return getSepoaOut();	

    }


    private int et_setRAHDCancelCreate(ConnectionContext ctx,
                                        String ANN_NO         ,
                                        String ANN_DATE       ,
                                        String ANN_ITEM       ,
                                        String ANN_TITLE      ,                                        
                                        String RA_NO         ,
                                        String RA_COUNT      ,
                                        String FLAG           ,
                                        String RA_FLAG       ,
                                        String BID_STATUS   ,
                                        String BID_ETC ,
                                        String maxRaCount) throws Exception
    {
        int rtn = 0;
       
        String SIGN_STATUS = "";

        if("T".equals(FLAG)) { // 임시저장
            SIGN_STATUS = "T";
        } else {               // 결재상신
            SIGN_STATUS = "P";
        }
        
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("RA_NO", RA_NO);
        wxp.addVar("VALUE_OF_RA_COUNT",String.valueOf(Integer.parseInt(RA_COUNT) + 1));
        wxp.addVar("company_code", company_code);
        wxp.addVar("user_id", user_id );
        wxp.addVar("name_loc", name_loc );
        wxp.addVar("name_eng", name_eng);
        wxp.addVar("department", department);
        wxp.addVar("SIGN_STATUS", SIGN_STATUS);
        wxp.addVar("ANN_NO", ANN_NO);
        wxp.addVar("ANN_DATE", ANN_DATE);
        wxp.addVar("ANN_ITEM", ANN_ITEM);
        wxp.addVar("RA_FLAG", RA_FLAG);
        wxp.addVar("RA_FLAG", RA_FLAG);
        wxp.addVar("BID_ETC", BID_ETC);
        wxp.addVar("RA_COUNT", RA_COUNT);		// 셀렉트할 차수
        wxp.addVar("house_code", house_code);
        wxp.addVar("maxRaCount", maxRaCount);	// 인서트할 차수
        

        String input_date = SepoaDate.addSepoaDateMonth(ANN_DATE,+1); // 입찰공고화면에 조회되기 위하여, 공고일자+1달 을 임의로 넣어준다.
        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            rtn = sm.doInsert((String[][])null, null);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }




    private int et_setRADTCancelCreate(ConnectionContext ctx,
                                        String RA_NO         ,
                                        String RA_COUNT ,
                                        String maxRaCount) throws Exception
    {
        int rtn = 0;
        
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        
        wxp.addVar("RA_NO", RA_NO);
        wxp.addVar("VALUE_OF_RA_COUNT",String.valueOf(Integer.parseInt(RA_COUNT) + 1));
        wxp.addVar("company_code", company_code);
        wxp.addVar("user_id", user_id );
        wxp.addVar("name_loc", name_loc );
        wxp.addVar("name_eng", name_eng);
        wxp.addVar("department", department);
        wxp.addVar("RA_COUNT", RA_COUNT);		// 셀렉트할 차수
        wxp.addVar("house_code", house_code);
        wxp.addVar("maxRaCount", maxRaCount);	// 인서트할 차수
        

        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            rtn = sm.doInsert((String[][])null, null);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }




    private int et_setRARQCancelCreate(ConnectionContext ctx,
                                        String RA_NO         ,
                                        String RA_COUNT,
                                        String maxRaCount) throws Exception
    {
        int rtn = 0;



        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("HOUSE_CODE"	, house_code);
        wxp.addVar("RA_NO"		, RA_NO);
        wxp.addVar("RA_COUNT"	, RA_COUNT);	// 셀렉트할 차수
        wxp.addVar("ADD_USER_ID"	, info.getSession("ID"));
        wxp.addVar("maxRaCount"	, maxRaCount);	// 인서트할 차수
        
        
        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            rtn = sm.doInsert((String[][])null, null);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }






    private String et_getGonggoIsValid(String BID_NO) throws Exception
    {
        String value = null;

        ConnectionContext ctx = getConnectionContext();

      
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        
        /*
        sql.append(" SELECT DECODE(NVL(COUNT(RA_COUNT), 0), 0, 'Y', 1, 'Y', 'N')       \n");
        sql.append(" FROM ICOYRAHD                                                      \n");
        sql.append(" <OPT=F,S> WHERE HOUSE_CODE = ?  </OPT>                             \n");
        sql.append(" <OPT=S,S> AND   RA_NO     = ?  </OPT>                             \n");
        sql.append(" AND STATUS IN ('C', 'R')                                           \n");
		*/
        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
            String[] data = {info.getSession("HOUSE_CODE"), BID_NO};
            value = sm.doSelect(data);

            SepoaFormater wf = new SepoaFormater(value);
            value = wf.getValue(0,0);

        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return value;
    }


    /**
     * 역경매개찰>개찰 조서로딩시 디스플레이 Sepoatable 내역조회
     **/

        public SepoaOut gstRatTableData(Map<String, String> header) {
            String rtn = "";

            try {
            	header.put("HOUSE_CODE", info.getSession("HOUSE_CODE"));
                rtn = et_gstRatTableData(header);

                if( rtn != null ) {
                    setValue(rtn);
                    setStatus(1);
                }
            } catch(Exception e) {
                Logger.err.println("getratbdins1_1 ======>>" + e.getMessage());
                setStatus(0);
                setMessage(msg.getMessage("002"));
                Logger.err.println(this,e.getMessage());
            }
            return getSepoaOut();
        }


    /**
     * 역경매개찰>개찰 조서로딩시 디스플레이 Sepoatable 내역조회
     **/
        private String et_gstRatTableData(Map<String, String> header) throws Exception {

            String rtn = "";

            ConnectionContext ctx = getConnectionContext();
            
            try {
                StringBuffer sql = new StringBuffer();
                
                SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
               
                SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

                rtn = sm.doSelect(header);

            }catch(Exception e) {
                Logger.debug.println(info.getSession("ID"),this,"et_getratbdins1_1 = " + e.getMessage());
            } finally{

            }
            return rtn;
        }


    public SepoaOut getVendorList (String BID_NO,String BID_COUNT)
    {
        try{

            String rtn = et_getVendorList(BID_NO,BID_COUNT);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }

        return getSepoaOut();
    }

    private String et_getVendorList(String BID_NO,String BID_COUNT) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sql = new StringBuffer();

        sql.append(" SELECT                                                        \n");
        sql.append("        VENDOR_CODE,                                           \n");
        sql.append("        (SELECT NAME_LOC FROM ICOMVNGL                         \n");
        sql.append("         WHERE HOUSE_CODE = RQSE.HOUSE_CODE                      \n");
        sql.append("         AND   VENDOR_CODE = RQSE.VENDOR_CODE) AS VENDOR_NAME,   \n");
        sql.append("         ''    AS DIS,                                         \n");
        sql.append("         ''    AS NO,                                          \n");
        sql.append("         ''    AS NAME                                         \n");
        sql.append(" FROM ICOYRQSE RQSE                                              \n");
        sql.append(" WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'        \n");
        sql.append(" AND   RFQ_NO     = '"+BID_NO+"'                               \n");
        sql.append(" AND   RFQ_COUNT  = '"+BID_COUNT+"'                            \n");
        sql.append(" AND   STATUS IN ('C', 'R')                                    \n");

        try{
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            rtn = sm.doSelect((String[])null);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
    
    
    /*
     * 참가신청등록 조회
     */
    
    public SepoaOut getratbdRegList(Map<String, String> header)
    {
		try{
			
			header.put("house_code", info.getSession("HOUSE_CODE"));
			String rtn = et_getratbdRegList(header);

	        setStatus(1);
	        setValue(rtn);
            et_getDBTime();
			

			setMessage(msg.getMessage("0000"));

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}

		return getSepoaOut();
	}

	private String et_getratbdRegList(Map<String, String> header) throws Exception
	{

        ctrl_code        = info.getSession("CTRL_CODE");

   		ConnectionContext ctx = getConnectionContext();

        String rtn = "";
        
		try{
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
			rtn = sm.doSelect(header);
		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	
	/*
     * 참가신청등록 시 지명경쟁일 경우 
     * 선정되어있는 업체들을 보여줌.
     */
    
    public SepoaOut getJoinVendorList(Map<String, String> header)
    {
		try{
			
			String rtn = et_getJoinVendorList(header);
			
	        setStatus(1);
	        setValue(rtn);
            //rtn = et_getDBTime();
			setValue(rtn);

			setMessage(msg.getMessage("0000"));

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}

		return getSepoaOut();
	}

	private String et_getJoinVendorList(Map<String, String> header) throws Exception
	{
//		String [] data = {house_code,company_code,RA_NO,RA_COUNT};
   		
		ConnectionContext ctx = getConnectionContext();

        String rtn = "";
        
		try{
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code"		, house_code);
			wxp.addVar("company_code"	, company_code);
			wxp.addVar("RA_NO"			, header.get("RA_NO"));
			wxp.addVar("RA_COUNT"		, header.get("VOTE_COUNT"));
			
			SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());

			rtn = sm.doSelect((String[])null);

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	/*
	 * 역경매에 참여할 업체의 적격 여부 등록
	 * 
	 */
	
	 public SepoaOut setJoinVendorReg(Map<String, Object> data) {
		 
	        ConnectionContext         ctx           = null;
			List<Map<String, String>> grid          = null;
			Map<String, String>       gridInfo      = null;
			String                    menuFieldCode = null;
			Map<String, String> 	  header		= null;
			header = MapUtils.getMap(data, "headerData");
			
	        int rtn = 0;

	        try {
	        	
	        	grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
	        	ctx = getConnectionContext();
	        	
	        	for(int i = 0; i < grid.size(); i++) {
	        		gridInfo = grid.get(i);
	                gridInfo.put("HOUSE_CODE"		, info.getSession("HOUSE_CODE"));
	                gridInfo.put("COMPANY_CODE"		, info.getSession("COMPANY_CODE"));
	                gridInfo.put("CHANGE_USER_ID"	, info.getSession("ID"));
	                gridInfo.put("RFQ_NO"			, header.get("RA_NO"));
	                gridInfo.put("RFQ_COUNT"		, header.get("VOTE_COUNT"));
	                
	        		rtn = et_setJoinVendorUpd(ctx, gridInfo);
	        	}
	            	
	            if (rtn < 0) { //오류 발생
	                setMessage(msg.getMessage("0036"));
	                setStatus(0);
	            } else {
	            	setMessage("저장되었습니다.");
	                setStatus(1);
	            }
	        }catch(Exception e) {
	            Logger.err.println( info.getSession( "ID" ), this, "et_setJoinVendorUpd Exception e =" + e.getMessage() );
	            setStatus(0);
	        }
	        return getSepoaOut();
	    }
	
	/*
	 * 업체 적격판정등록
	 */
	private int et_setJoinVendorUpd(ConnectionContext ctx, Map<String, String> gridInfo) throws Exception
    {
        int rtnIns = 0;
        
        try {
        	
        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());        	

        	SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
        	//String[] type_prdt = { "S","S","S", "S","S","S", "S"};
        	rtnIns = sm.doUpdate(gridInfo);
            
        	Commit();
        }
        catch(Exception e) {
            Rollback();
            rtnIns = -1;
            Logger.debug.println(info.getSession("ID"),this,"et_setJoinVendorUpd = " + e.getMessage());
        }

        return rtnIns;

    }
	
	/*
	 * 참가신청등록에서 등록된 업체를 수정시
	 */
	 private int et_delJoinVendorReg(ConnectionContext ctx, String RA_NO, String RA_COUNT, String CHANGE_USER_ID,String VENDOR_CODE) throws Exception
	 {
		int rtn = 0;
		SepoaSQLManager sm = null;
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try {
			
		 	sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());

		 	String[][] setData = {{house_code,company_code, RA_NO, RA_COUNT,VENDOR_CODE, CHANGE_USER_ID}};
		 	String[] type = {"S","S","S","S","S","S"};

		 	rtn = sm.doUpdate(setData, type);
		 	} catch(Exception e) {
		 		Logger.err.println(userid,this,e.getMessage());
		 		throw new Exception(e.getMessage());
		 	}

		 	return rtn;
	 }
	 
		/**
		 * 역경매 현황에서 상세조회 팝업에서 조회한다..
		 * @param args
		 * @param server_date
		 * @return
		 */
	    public SepoaOut getratbddis1_1(Map<String, String> header) {
	    	
	    	try {
	            String rtn = "";
	            
	            header.put("house_code", info.getSession("HOUSE_CODE"));

	            rtn = et_getratbddis1_1(header);
	            if( rtn != null ) setValue(rtn);

	            rtn = et_getRaSEDisplay(header);
	            if( rtn != null ) setValue(rtn);

	            setStatus(1);
	        }catch(Exception e) {
	            Logger.err.println("getratbdins1_1 ======>>" + e.getMessage());
	            setStatus(0);
	            setMessage(msg.getMessage("002"));
	            Logger.err.println(this,e.getMessage());
	        }
	        return getSepoaOut();
	    }

		/**
		 * 상세조회 팝업를 조회합니다.
		 * @param args
		 * @param server_date
		 * @return
		 * @throws Exception
		 */
	    private String et_getratbddis1_1( Map<String, String> header ) throws Exception {

	        String rtn = "";

	           ConnectionContext ctx = getConnectionContext();
	
	        try {
	        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//	            StringBuffer sql = new StringBuffer();
	//
//				sql.append( " SELECT																																									\n " );	
//				sql.append( "         RQDT.ITEM_NO                                   	   AS ITEM_NO,	                                                                                                \n " );
//				sql.append( "         PRDT.DESCRIPTION_LOC                                 AS DESCRIPTION_LOC,                                                                                          \n " );
//				sql.append( "         PRDT.SPECIFICATION                                   AS SPECIFICATION,                                                                                            \n " );
//				sql.append( "         RQDT.UNIT_MEASURE                                    AS UNIT_MEASURE,                                                                                             \n " );
//				sql.append( "         RQDT.RD_DATE                                         AS RD_DATE,                                                                                                  \n " );
//				sql.append( " 				(CASE                                                                                                                                                       \n " );
//				sql.append( " 				 	 		 WHEN PRDT.STR_FLAG = 'S' THEN GETSTORAGENAME(PRDT.HOUSE_CODE, PRDT.COMPANY_CODE, PRDT.PLANT_CODE, PRDT.DELY_TO_LOCATION, 'LOC' )               \n " );
//				sql.append( " 				 	 		 WHEN PRDT.STR_FLAG = 'D' THEN GETDEPTNAME(PRDT.HOUSE_CODE, PRDT.COMPANY_CODE, PRDT.DELY_TO_LOCATION, 'LOC' )                                   \n " );
//				sql.append( " 				 	 		 ELSE PRDT.DELY_TO_LOCATION                                                                                                                     \n " );
//				sql.append( " 				 	  END                                                                                                                                                   \n " );
//				sql.append( " 				 	 ) 																								 AS DELY_TO_LOCATION_NAME,                              \n " );
//				sql.append( " 				RQDT.PR_NO																					 AS PR_NO,                                                      \n " );
//				sql.append( " 				RQDT.PR_SEQ																					 AS PR_SEQ,                                                     \n " );
//				sql.append( " 				PRDT.PURCHASE_LOCATION															 AS PURCHASE_LOCATION,                                                      \n " );
//				sql.append( "         PRDT.DELY_TO_LOCATION                                AS DELY_TO_LOCATION,                                                                                         \n " );
//				sql.append( "                                                                                                                                                                           \n " );
//				sql.append( "                                                                                                                                                                           \n " );
//				sql.append( "         RQHD.RFQ_NO 																				 AS RA_NO,                                                              \n " );
//				sql.append( "         RQDT.RFQ_SEQ 																				 AS RA_SEQ,                                                             \n " );
//				sql.append( "         PRDT.SHIPPER_TYPE																		 AS SHIPPER_TYPE,                                                           \n " );
//				sql.append( "         RQHD.SUBJECT                                         AS SUBJECT,                                                                                                  \n " );
//				sql.append( "         GETUSERNAME(RQHD.HOUSE_CODE, RQHD.CHANGE_USER_ID, 'LOC') AS CHANGE_NAME_LOC,                                                                                      \n " );
//				sql.append( "         RQHD.TEL_NO                                          AS TEL,                                                                                                      \n " );
//				sql.append( "         RQHD.EMAIL                                           AS EMAIL,                                                                                                    \n " );
//				sql.append( "         RQHD.START_DATE                                      AS FROM_DATE,                                                                                                \n " );
//				sql.append( "         SUBSTR(RQHD.START_TIME,0,2)                          AS START_TIME,                                                                                               \n " );
//				sql.append( "         SUBSTR(RQHD.START_TIME,3,2)                          AS START_MINUTE,                                                                                             \n " );
//				sql.append( "         RQHD.RFQ_CLOSE_DATE                                  AS TO_DATE,                                                                                                  \n " );
//				sql.append( "         SUBSTR(RQHD.RFQ_CLOSE_TIME,0,2)                      AS END_TIME,                                                                                                 \n " );
//				sql.append( "         SUBSTR(RQHD.RFQ_CLOSE_TIME,3,2)                      AS END_MINUTE,                                                                                               \n " );
//				sql.append( "         GETICOMCODE2(RQHD.HOUSE_CODE,'M009',RQHD.DELY_TERMS) AS DELY_TERMS_TEXT,                                                                                          \n " );
//				sql.append( "         GETICOMCODE2(RQHD.HOUSE_CODE,'M010',RQHD.PAY_TERMS)  AS PAY_TERMS_TEXT,                                                                                           \n " );
//				sql.append( "         RQDT.CUR                                             AS CUR,                                                                                                      \n " );
//				sql.append( "         RQHD.RESERVE_PRICE                                   AS RESERVE_PRICE,                                                                                            \n " );
//				sql.append( "         RQHD.BID_DEC_AMT                                     AS BID_DEC_AMT,                                                                                              \n " );
//				sql.append( "         (SELECT COUNT(*)                                                                                                                                                  \n " );
//				sql.append( "         FROM ICOYRQSE RQSE                                                                                                                                                \n " );
//				sql.append( "         WHERE RQSE.HOUSE_CODE  = RQDT.HOUSE_CODE                                                                                                                          \n " );
//				sql.append( "         AND RQSE.RFQ_NO        = RQDT.RFQ_NO                                                                                                                              \n " );
//				sql.append( "         AND RQSE.RFQ_COUNT     = RQDT.RFQ_COUNT                                                                                                                           \n " );
//				sql.append( "         AND RQSE.RFQ_SEQ       = RQDT.RFQ_SEQ                                                                                                                             \n " );
//				sql.append( "         AND STATUS <> 'D')                                   AS VENDOR_COUNT,                                                                                             \n " );
//				sql.append( "         (SELECT NVL(COUNT(*),0) FROM ICOMATCH                                                                                                                             \n " );
//				sql.append( "         WHERE DOC_NO = RQDT.ATTACH_NO)                       AS ATTACH_COUNT,                                                                                             \n " );
//				sql.append( "         RQDT.ATTACH_NO                                       AS ATTACH_NO,                                                                                                \n " );
//				sql.append( "         RQHD.REMARK                                          AS REMARK,                                                                                                   \n " );
//				sql.append( "         RQDT.COMPANY_CODE                                    AS COMPANY_CODE,                                                                                              \n " );
//				sql.append( "         RQHD.Z_SMS_SEND_FLAG                                 AS Z_SMS_SEND_FLAG                                                                                           \n " );
//				sql.append( "       , PRDT.Z_CODE1 ||' / '|| GETZCODE(PRDT.HOUSE_CODE,PRDT.Z_CODE1,'Z_CODE1') AS Z_CODE1                                                                                 \n " );
//				sql.append( "                                                                                                                                                                           \n " );
//				sql.append( "  FROM    ICOYRQHD RQHD, ICOYRQDT RQDT , ICOYPRDT PRDT                                                                                                                     \n " );
//				sql.append( " <OPT=F,S> WHERE RQHD.HOUSE_CODE          = ?   </OPT>                                                                                                                     \n " );
//				sql.append( "    		AND   RQHD.HOUSE_CODE    = RQDT.HOUSE_CODE                                                                                                                      \n " );
//				sql.append( "    		AND   RQHD.RFQ_NO         = RQDT.RFQ_NO                                                                                                                         \n " );
//				sql.append( "    		AND   RQHD.RFQ_COUNT      = RQDT.RFQ_COUNT                                                                                                                      \n " );
//				sql.append( " <OPT=S,S> AND   RQHD.RFQ_NO         = ?   </OPT>                                                                                                                          \n " );
//				sql.append( " <OPT=S,S> AND   RQHD.RFQ_COUNT      = ?  </OPT>                                                                                                                           \n " );
//				sql.append( " <OPT=S,S>	AND   RQDT.RFQ_SEQ        = ?   </OPT>                                                                                                                          \n " );
//				sql.append( "   		AND   RQDT.HOUSE_CODE = PRDT.HOUSE_CODE                                                                                                                         \n " );
//				sql.append( "   		AND   RQDT.PR_NO = PRDT.PR_NO                                                                                                                                   \n " );
//				sql.append( "   		AND   RQDT.PR_SEQ = PRDT.PR_SEQ                                                                                                                                 \n " );
//				sql.append( "   		AND   RQHD.BID_TYPE ='RA'                                                                                                                                       \n " );
	            
	            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	            rtn = sm.doSelect(header);
	        }catch(Exception e) {
	            Logger.debug.println(info.getSession("ID"),this,"et_getratbdins1_1 = " + e.getMessage());
	        } finally{

	        }
	        return rtn;
	    }
	    
	    /*
	     * 역경매 결제화면 값
	     */
	    public SepoaOut getRatBdCont( String[] args ) {
	    	Logger.debug.println("getRatBdCont== start ====>>");
	    	try {
	            String rtn = "";

	            rtn = et_getRatBdCont(args);
	            if( rtn != null ) setValue(rtn);

	            //rtn = et_getRaSEDisplay(args);
	            if( rtn != null ) setValue(rtn);

	            setStatus(1);
	        }catch(Exception e) {
	            Logger.err.println("getRatBdCont ======>>" + e.getMessage());
	            setStatus(0);
	            setMessage(msg.getMessage("002"));
	            Logger.err.println(this,e.getMessage());
	        }
	        return getSepoaOut();
	    }

		/**
		 * 결제화면 팝업을 조회
		 * @param args
		 * @param server_date
		 * @return
		 * @throws Exception
		 */
	    private String et_getRatBdCont( String[] args ) throws Exception {

	        String rtn = "";

	           ConnectionContext ctx = getConnectionContext();

	        try {
	        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	            rtn = sm.doSelect(args);
	        }catch(Exception e) {
	            Logger.debug.println(info.getSession("ID"),this,"et_getRatBdCont = " + e.getMessage());
	        } finally{

	        }
	        return rtn;
	    }
	    
	    
	    
	    
	    private String et_getRaSEDisplay(Map<String, String> header) throws Exception
	    {
	        String rtn = null;
	        ConnectionContext ctx = getConnectionContext();

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        
//	        StringBuffer sql = new StringBuffer();
//	        sql.append(" SELECT distinct                                                        \n");
//	        sql.append("     rqse.VENDOR_CODE,                                                  \n");
//	        sql.append("     vngl.VENDOR_NAME_LOC,                                                     \n");
//	        sql.append("      'N'                                                               \n");//-------------확인...
//	        sql.append(" FROM ICOYRQSE rqse, ICOMVNGL vngl                                      \n");
//	        sql.append(" <OPT=F,S>WHERE rqse.HOUSE_CODE = ?   </OPT>           					\n");
//	        sql.append("   AND rqse.HOUSE_CODE = vngl.HOUSE_CODE                                \n");
//	        sql.append("   AND rqse.VENDOR_CODE = vngl.VENDOR_CODE                              \n");
//	        sql.append("   <OPT=S,S>AND rqse.RFQ_NO = ?    </OPT>                               \n");
//	        sql.append("   <OPT=S,S>AND rqse.RFQ_COUNT = ?  </OPT>                              \n");
//	        sql.append("   <OPT=S,S>AND rqse.RFQ_SEQ = ?  </OPT>                                \n");
//	        sql.append("   AND rqse.STATUS != 'D'                                               \n");

	        try {
	            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());

	            rtn = sm.doSelect(header);
	        } catch(Exception e) {
	            Logger.err.println(userid,this,e.getMessage());
	            throw new Exception(e.getMessage());
	        }
	        return rtn;
	    }
	    
	    
	    /**
	     * 역경매관리 > 역경매 결과 > 낙찰취소
	     **/
	        public SepoaOut setCancelBid(Map<String, String> header) {
	            String rtn = "";
	            List<Map<String, String>> grid          = null;
	            Map<String, String>       gridInfo      = null;

	            try {
	            	
	            	grid = (List<Map<String, String>>)MapUtils.getObject(header, "gridData");
	            	
	            	for(int grd = 0; grd < grid.size(); grd++) {
	            		gridInfo = grid.get(grd);

		                String dataPRNO = "";
		                dataPRNO = getPRNO(header); 
		                SepoaFormater wf = new SepoaFormater(dataPRNO);

		                gridInfo.put("HOUSE_CODE"			,  info.getSession("HOUSE_CODE"));
		                gridInfo.put("COMPANY_CODE"			,  info.getSession("COMPANY_CODE"));
		                gridInfo.put("USER_ID"				,  info.getSession("ID"));
		                gridInfo.put("NAME_LOC"				,  info.getSession("NAME_LOC"));
		                gridInfo.put("NAME_ENG"				,  info.getSession("NAME_ENG"));
		                gridInfo.put("DEPARTMENT"			,  info.getSession("DEPARTMENT"));		                	
		                gridInfo.put("BID_STATUS"			,  "AR");		                	
		                gridInfo.put("PR_PROCEEDING_FLAG"	,  "C");		                	
		                gridInfo.put("RA_FLAG"				,  "P");		                	
		                gridInfo.put("SETTLE_FLAG"			,  "P");		                	
		                gridInfo.put("SETTLE_FLAG_N"		,  "N");		                	

		                if (dataPRNO != null) {
		                	if(wf.getRowCount() > 0){
		                		for(int i=0; i<wf.getRowCount(); i++) { //데이타가 있는 경우
		                			gridInfo.put("RA_NO"				,  wf.getValue("PR_NO", i));
		                			gridInfo.put("RA_COUNT"				,  wf.getValue("PR_SEQ", i));
		                			gridInfo.put("PR_PROCEEDING_FLAG"	,  "C");
		                			rtn = et_setCancelBid(gridInfo);
		                		}
		                	}else{
		                		rtn = et_setCancelBid(gridInfo);
		                	}
		                }
	            	}

	                if ("ERROR".equals(rtn)) {  //오류가 발생하였다.
	                    setMessage("오류가 발생하였습니다.");
	                    setStatus(0);
	                } else {
	                    setValue(rtn);
	                    setMessage("낙찰이 취소되었습니다.");
	                    setStatus(1);
//	                    Logger.debug.println( info.getSession( "ID" ), this, "recvPRDT[1]==============>" + recvPRDT[1] );
	                    
	                    Commit();
	                }
	            }catch(Exception e) {
	            	Logger.err.println( info.getSession( "ID" ), this, "setCancelBid Exception e =" + e.getMessage() );
	                setStatus(0);
	            }
	            return getSepoaOut();
	        }
	        	        
	        /**
	         * 역경매결과 > 낙찰취소
	         **/
	            private String et_setCancelBid(Map<String, String> header) throws Exception
	            {
	                int rtnIns = 0;
	                String rtnString = "";

	                ConnectionContext ctx = getConnectionContext();
	                SepoaSQLManager sm = null;
	                SepoaXmlParser wxp = null;

	                try {
	                    // ICOYPRDT
	                	
	                    wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_PRDT");	
	                    sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
	                    rtnIns = sm.doUpdate(header);

	                    // ICOYRAHD
	                    wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_RAHD");
	                    sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
	                    rtnIns = sm.doUpdate(header);

	                    // ICOYRADT
	                    wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_RADT");
	                    sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
	                    rtnIns = sm.doUpdate(header);

	                    if ("NB".equals(header.get("BID_STATUS"))) {  //유찰
	                        // ICOYRADT
	                        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_RABD");
	                        sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
	                        rtnIns = sm.doUpdate(header);
	                    }
//	                    Commit();
	                }
	                catch(Exception e) {
	                    Rollback();
	                    rtnString = "ERROR";
	                    Logger.debug.println(info.getSession("ID"),this,"et_setCancelBid = " + e.getMessage());
	                }

	                return rtnString;
	            }
	    
	            /*
	             * 결재 완료후 결재모듈에서 호출하는 메소드
	             */
	                 public SepoaOut Approval(SignResponseInfo inf) {

	                     String app_rtn = inf.getSignStatus();

	                     String[] re_doc_no = inf.getDocNo();
	                     String[] re_doc_seq = inf.getDocSeq();
	                     String sign_date = inf.getSignDate();
	                     String sign_user_id = inf.getSignUserId();
	                     String sign_flag = "";
	                     String[] re_shipper_type = inf.getShipperType();

	                     String doc_no = "";
	                     String doc_seq = "";
	                     String doc_count = "1";  // Fix
	                     String shipper_type = "";
	                     int rtn = 0;
	                     int rtn_sms= 0;

	                     try {

	                         for( int i = 0; i < re_doc_no.length; i++ )
	                         {
	                             //StringTokenizer st = new StringTokenizer(re_doc_seq[i],"/");

	                             //doc_seq   = st.nextToken();
	                             //doc_count = st.nextToken();

	                             doc_no     = re_doc_no[i]; //문서번호
	                             doc_seq	= re_doc_seq[i];// seq 역경매 RA_COUNT
	                             
	                             shipper_type    = re_shipper_type[i];

	                             Logger.debug.println(info.getSession("ID"),this,"doc_no=============== >"+doc_no);
	                             Logger.debug.println(info.getSession("ID"),this,"doc_count=============== >"+doc_count);

	                             //app_rtn : 완료 E, 반려:R, 취소:D
	                             rtn = setApproval( doc_no,doc_seq,sign_date, sign_user_id,app_rtn );
	                             
	                             /**
	                              * 현재는 잠시 막아둠 : 2006.04.10 ,박은숙
	                             if(app_rtn.equals("E")) { // 완료일 경우에만 들어오게 끔 한다.
	                                 rtn_sms = setSMS(doc_no, doc_count);
	                             }
	                             **/
	                             //역경매자동발주생성
	                             //if( app_rtn.equals("E") )
	                             //    rtn = setRaPoCreate(doc_no,doc_count,shipper_type,sign_date,sign_user_id);

	                             if( rtn == 1 ){
	                                 setStatus(1);
	                             }
	                             else
	                                 setStatus(0);
	                         }
	                         
/*	             			//결재완료시 sms, mail 발송.
	             			String[] DOC_NO	      = inf.getDocNo();
	             			String[] DOC_SEQ	  = inf.getDocSeq();
	             			
	             			ConnectionContext ctx =	getConnectionContext();
	             			SepoaXmlParser wxp = null;
	             			
	             			for(int v1=0; v1 < DOC_NO.length; v1++){
	             				//cont_type1( 계약형태 ) 값을 가져온다.
	             				wxp = new SepoaXmlParser(this, "getRaType1");
	             				wxp.addVar("HOUSE_CODE", info.getSession("HOUSE_CODE"));
	             				wxp.addVar("RA_NO", DOC_NO[v1]);
	             				wxp.addVar("RA_COUNT", DOC_SEQ[v1]);
	             	            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx, wxp.getQuery());
	             	            String ra_rtn = sm.doSelect(null);

	             	            SepoaFormater wf = new SepoaFormater(ra_rtn);
	             	            String ra_type1 = wf.getValue("RA_TYPE1", 0);
	             	            
	             				//지명경쟁일 경우에만 발송.
	             				if("NC".equals(ra_type1)){
	             					String[][] args = new String[1][2];
	             					args[0][0] = DOC_NO[v1];
	             					args[0][1] = DOC_SEQ[v1];
	             					
	             					Object[] sms_args = {args};
	             			        String sms_type = "";
	             			        String mail_type = "";
	             			        
	             			        sms_type 	= "S00006";
	             			        mail_type 	= "M00006";
	             			        
	             			        if(!"".equals(sms_type)){
	             			        	ServiceConnector.doService(info, "SMS", "TRANSACTION", sms_type, sms_args);
	             			        }
	             			        if(!"".equals(mail_type)){
	             			        	ServiceConnector.doService(info, "mail", "CONNECTION", mail_type, sms_args);
	             			        }
	             				}
	             			}*/


	                     }
	                     catch(Exception e) {
	                         Logger.err.println(info.getSession("ID"),this,"Approval =="+e.getMessage());
	                         setStatus(0);
	                     }
	                     return getSepoaOut();
	                 }
	                 
	                 /**
	                  * 결재완료 후 처리하는 메소드
	                  **/
	                     private int setApproval(String ra_no,
	                    		 				 String ra_count,
	                                             String sign_date,
	                                             String sign_user_id,
	                                             String app_rtn ) throws Exception
	                     {

	                         ConnectionContext ctx = getConnectionContext();
	                         SepoaSQLManager sm = null;

//	                         StringBuffer sql = null;

	                         String rtnString = "";
	                         int rtnIns = 0;
	                         String house_code = info.getSession("HOUSE_CODE");
	                         SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	                         	wxp.addVar("house_code", house_code);
	                         	wxp.addVar("sign_date", sign_date);
	                         	wxp.addVar("sign_user_id", sign_user_id);
	                         	wxp.addVar("ra_no", ra_no);
	                         	wxp.addVar("ra_count", ra_count);
	                         	wxp.addVar("app_rtn", app_rtn);
	                         	
	                         try {
//	                             sql = new StringBuffer();
	         //
//	                             sql.append( "UPDATE    ICOYRQHD                                         \n" );
	         //
//	                             if( app_rtn.equals("E") )
//	                             {
//	                                 sql.append( " SET    SIGN_STATUS    = 'E',                          \n" ); 
//	                             }
//	                             else if( app_rtn.equals("R") ){
//	                                 sql.append( " SET       SIGN_STATUS    = 'R',                       \n" );
//	                                 sql.append( "           RFQ_FLAG     = 'N',                          \n" );// RFQ_FLAG : N 이면 임시저장
//	                             }
//	                             else if( app_rtn.equals("D") ){                      // 취소
//	                                 sql.append( " SET   SIGN_STATUS    = 'D',                           \n" );
//	                                 sql.append( "        RFQ_FLAG        = 'N',                          \n" );
//	                             }
//	                             sql.append( "        SIGN_DATE    = '"+sign_date+"',                    \n" );
//	                             sql.append( "        SIGN_PERSON_ID    = '"+sign_user_id+"'             \n" );
//	                             sql.append( "WHERE    HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'  \n" );
//	                             sql.append( "  AND    RFQ_NO = '"+ra_no+"'                               \n" );

	                             sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	                             rtnIns = sm.doInsert((String[][])null, null);
	                             /**
	                              * 현재는 잠시 막아둠 : 2006.04.10 ,박은숙
	                             //업체메일전송
	                             if( app_rtn.equals("E") )
	                             {
	                                 Logger.debug.println(info.getSession("ID"),this,"Mail Enter ");
	                                 setMail(ra_no);
	                             }
	                             **/
	                             
	                        }
	                         catch(Exception e) {

	                             rtnString = "ERROR";
	                             Logger.debug.println(info.getSession("ID"),this,"et_setratppins_1 = " + e.getMessage());

	                         }

	                         return rtnIns;
	                     }
	
	                     public SepoaOut getMaxRaCount(String RA_NO)
	                     {
	                         try{

	                             String rtn = et_getMaxRaCount(RA_NO);

	                             setStatus(1);
	                             setValue(rtn);

	                             setMessage(msg.getMessage("0000"));

	                         }catch(Exception e) {
	                             Logger.err.println(userid,this,e.getMessage());
	                             setStatus(0);
	                             setMessage(msg.getMessage("0001"));
	                         }

	                         return getSepoaOut();
	                     }

	                     private String et_getMaxRaCount(String RA_NO) throws Exception
	                     {

	                         ConnectionContext ctx = getConnectionContext();
	                         String rtn = "";
	                         try{
	                         	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());        	
	                         	wxp.addVar("HOUSE_CODE"	, house_code);
	                         	wxp.addVar("RA_NO"		, RA_NO);
	                             SepoaSQLManager sm = new SepoaSQLManager("", this, ctx, wxp.getQuery());
	                             rtn = sm.doSelect((String[])null);

	                         }catch(Exception e) {
	                             Logger.err.println(userid,this,e.getMessage());
	                             throw new Exception(e.getMessage());
	                         }
	                         return rtn;
	                     }	                     
	                     
	                     public SepoaOut getBeforRaCount(String RA_NO)
	                     {
	                         try{

	                             String rtn = et_getBeforRaCount(RA_NO);

	                             setStatus(1);
	                             setValue(rtn);

	                             setMessage(msg.getMessage("0000"));

	                         }catch(Exception e) {
	                             Logger.err.println(userid,this,e.getMessage());
	                             setStatus(0);
	                             setMessage(msg.getMessage("0001"));
	                         }

	                         return getSepoaOut();
	                     }

	                     private String et_getBeforRaCount(String RA_NO) throws Exception
	                     {

	                         ConnectionContext ctx = getConnectionContext();
	                         String rtn = "";
	                         try{
	                         	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());        	
	                         	wxp.addVar("HOUSE_CODE"	, house_code);
	                         	wxp.addVar("RA_NO"		, RA_NO);
	                             SepoaSQLManager sm = new SepoaSQLManager("", this, ctx, wxp.getQuery());
	                             rtn = sm.doSelect((String[])null);

	                         }catch(Exception e) {
	                             Logger.err.println(userid,this,e.getMessage());
	                             throw new Exception(e.getMessage());
	                         }
	                         return rtn;
	                     }
	
	                     
	 private int et_setApprovalDelete(ConnectionContext ctx, Map<String, String> gridInfo) throws Exception {
	     int rtn = 0;
	
	     SepoaSQLManager sm = null;
	     SepoaXmlParser wxp = null;
	     try {
	         wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_1");
	         sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
	         rtn = sm.doUpdate(gridInfo);
	         
	         wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_2");
	         sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
	         rtn = sm.doUpdate(gridInfo);
	
	
	     } catch(Exception e) {
	         Logger.err.println(userid,this,e.getMessage());
	         throw new Exception(e.getMessage());
	     }
	
	     return rtn;
	 }
	
	
	

 	/*
 	 * 평가 템플릿 코드 가져오기
 	 * 2010.07.
 	 */
 	public String getEvalTemplate(Integer eval_id){
 		String rtn = null;
 		try{
 			rtn = et_getEvalTemplate(eval_id); 
 					
 		}catch(Exception e)	{ 
 			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
 			setStatus(0); 
 			setMessage(msg.getMessage("0005")); 
 		} 
 		return rtn; 
 	}
 	

 	private	String et_getEvalTemplate(Integer eval_id) throws Exception 
 	{ 
 	
 		
 		String rtn = null; 
 		ConnectionContext ctx =	getConnectionContext(); 
 		
 		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 		try{ 
 			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
 			wxp.addVar("code", eval_id.toString());
 			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
 			rtn	= sm.doSelect((String[])null); 
 		}catch(Exception e)	{ 
 			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
 			throw new Exception(e.getMessage()); 
 		} 
 		return rtn; 
 	} 
 	

 	/*
 	 * 평가 대상업체 가져오기
 	 * 2010.07.
 	 */
 	public String getEvalCompany(String doc_no, String doc_count){
 		String rtn = null;
 		try{
 			rtn = et_getEvalCompany(doc_no, doc_count); 
 			
 		}catch(Exception e)	{ 
 			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
 			setStatus(0); 
 			setMessage(msg.getMessage("0005")); 
 		} 
 		return rtn; 
 	}
 	

 	private	String et_getEvalCompany(String doc_no, String doc_count) throws Exception 
 	{ 
 	
 		
 		String rtn = null; 
 		ConnectionContext ctx =	getConnectionContext(); 
 		
 		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 		try{ 
 			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
 			wxp.addVar("doc_no", doc_no);
 			wxp.addVar("doc_count", doc_count);
 			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
 			rtn	= sm.doSelect((String[])null); 
 		}catch(Exception e)	{ 
 			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
 			throw new Exception(e.getMessage()); 
 		} 
 		return rtn; 
 	} 
 	
 	/*
 	 * 평가 담당자  가져오기
 	 * 2010.07.
 	 */
 	public String getEvalUser(String doc_no, String doc_count){
 		String rtn = null;
 		try{
 			rtn = et_getEvalUser(doc_no, doc_count); 
 			 		
 		}catch(Exception e)	{ 
 			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
 			setStatus(0); 
 			setMessage(msg.getMessage("0005")); 
 		} 
 		return rtn; 
 	}
 	

 	private	String et_getEvalUser(String doc_no, String doc_count) throws Exception 
 	{ 
 	
 		
 		String rtn = null; 
 		ConnectionContext ctx =	getConnectionContext(); 
 		
 		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 		try{ 
 			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
 			wxp.addVar("doc_no", doc_no);
 			wxp.addVar("doc_count", doc_count);
 			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
 			rtn	= sm.doSelect((String[])null); 
 		}catch(Exception e)	{ 
 			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
 			throw new Exception(e.getMessage()); 
 		} 
 		return rtn; 
 	} 

 	/*
 	 * 평가 여부  및 평가 생성
 	 * 2010.07.
 	 */
 	public SepoaOut setEvalInert(String doc_no, String doc_count, String eval_name, String eval_flag, Integer eval_id){
 		try{

 			int rtn = et_setEvalInert(doc_no, doc_count, eval_name, eval_flag, eval_id); 
 			
 			setValue(String.valueOf(rtn));  
 			if(rtn==0){
 				Rollback();
 				setStatus(0); 
 				setMessage("평가정보 처리중 오류가 발생하였습니다.");
 			}else{
 				Commit();
 				setStatus(1); 
 				setMessage("평가정보가 정상적으로 처리되었습니다."); 
 			}
 		 	
 		}catch(Exception e)	{ 
 			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
 			setStatus(0); 
 			setMessage("평가정보 처리중 오류가 발생하였습니다."); 
 		} 
 		return getSepoaOut(); 
 	}
 	
   		
 	private	int et_setEvalInert(String doc_no, String doc_count, String eval_name, String eval_flag, Integer eval_id) throws Exception 
 	{ 
 		int rtn =  0;
 		ConnectionContext ctx =	getConnectionContext(); 
 		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 		
 		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [doc_no]::"+doc_no);
 		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [doc_count]::"+doc_count);
 		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_name]::"+eval_name);
 		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_flag]::"+eval_flag);
 		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_id]::"+eval_id);
 		
 		try{ 
 			Integer eval_refitem = 0;
 			if(!"N".equals(eval_flag)){	//평가제외가 아닐 경우 평가 생성.
 				Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 START");
 				String rtn1 =  et_setEvalInsert(doc_no, doc_count, eval_name, eval_id);
 				
 		         if("".equals(rtn1)){
 		             Rollback();
 		             setStatus(0);
 		             setMessage(msg.getMessage("9003"));
 		             return 0;
 		         }
 		         
 		         eval_refitem = Integer.valueOf(rtn1);
 			}
 			Logger.debug.println(info.getSession("ID"),this, "=========================평가 상태 등록");
 			
 			wxp.addVar("eval_flag", eval_flag);
 			wxp.addVar("eval_refitem", eval_refitem);
 			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
 			wxp.addVar("doc_no", doc_no);
 			wxp.addVar("doc_count", doc_count);
 			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
 			rtn	= sm.doUpdate((String[][])null, null); 
 		}catch(Exception e)	{ 
 			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
 			throw new Exception(e.getMessage()); 
 		} 
 		return rtn; 
 	} 
 	

 	private String et_setEvalInsert(String doc_no, String doc_count, String eval_name, Integer eval_id) throws Exception 
 	{
 		String returnString = "";
 		ConnectionContext ctx = getConnectionContext();
 		
 		String user_id 		= info.getSession("ID");
 		String house_code 	= info.getSession("HOUSE_CODE");

 		int rtnIns = 0;
 		SepoaFormater wf = null;
 		SepoaSQLManager sm = null;

 		try 
 		{
 			String auto = "N";
 			String evaltemp_num	= "";
 			String from_date  	= "";
 			String to_date  	= "";
 			String flag			= "2"; 	//eval_status[2]
 			 
 			//템플릿코드 조회
 			String rtn1 = getEvalTemplate(eval_id);
 			wf =  new SepoaFormater(rtn1);
 			if(wf != null && wf.getRowCount() > 0) {
 				evaltemp_num 	= wf.getValue("text3", 0);
 				from_date 		= wf.getValue("FROMDATE", 0);
 				to_date 		= wf.getValue("TODATE", 0);
 			}
 			Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 템플릿코드::"+evaltemp_num);
 			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[doc_no]::"+doc_no);
 			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[doc_count]::"+doc_count);
 			
 			//평가자 조회
 			String rtn2 = getEvalUser(doc_no, doc_count);
 			wf =  new SepoaFormater(rtn2);
 			String[] eval_user_id = new String[wf.getRowCount()];
 			String[] eval_user_dept = new String[wf.getRowCount()];
 			for(int	i=0; i<wf.getRowCount(); i++) {	
 				eval_user_id[i] = wf.getValue("PROJECT_PM", i);
 				eval_user_dept[i] = wf.getValue("PROJECT_DEPT", i);
 				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자::"+eval_user_id[i]);
 			}
 			 
 			//평가업체 조회
 			String rtn3 = getEvalCompany(doc_no, doc_count);
 			wf =  new SepoaFormater(rtn3);
 			
 			String setData[][] = new String[wf.getRowCount()*eval_user_id.length][];
 			int kk=0;
 			for(int	i=0; i<wf.getRowCount(); i++) {	
 				for(int j=0; j<eval_user_id.length; j++){
 					Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가업체::"+wf.getValue("VENDOR_CODE", i));
 					String Data[] = { wf.getValue("VENDOR_CODE", i), "N", "0", eval_user_id[j], eval_user_dept[j]};
 					setData[kk] = Data;
 					kk++;
 				}
 			}
 			
 			//평가마스터 일련번호 조회
     		SepoaXmlParser wxp =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_0");
 			wxp.addVar("house_code", house_code);
 			sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
   	    	String rtn = sm.doSelect((String[])null);
   	    	wf =  new SepoaFormater(rtn);
 	    	
   	    	String max_eval_refitem = "";
 	    	if(wf != null && wf.getRowCount() > 0) {
 	    		max_eval_refitem = wf.getValue("MAX_EVAL_REFITEM", 0);
 			}

 			//평가테이블 생성 - ADD( 견적[RQ]/입찰[BD]/역경매[RA] 구분, 문서번호, 문서SEQ 등록)
 	    	SepoaXmlParser wxp_1 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_1");
 	    	wxp_1.addVar("house_code", house_code);
 	    	wxp_1.addVar("max_eval_refitem", max_eval_refitem);
 	    	wxp_1.addVar("evalname", eval_name);
 	    	wxp_1.addVar("flag", flag);
 	    	wxp_1.addVar("evaltemp_num", evaltemp_num);
 	    	wxp_1.addVar("fromdate", from_date);
 	    	wxp_1.addVar("todate", to_date);
 	    	wxp_1.addVar("auto", auto);
 	    	wxp_1.addVar("user_id", user_id);
 	    	wxp_1.addVar("DOC_TYPE", "RA");	//역경매
 	    	wxp_1.addVar("DOC_NO", doc_no);
 	    	wxp_1.addVar("DOC_COUNT", doc_count);
 			sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_1.getQuery() );
 			rtnIns = sm.doInsert( (String[][])null, null );
 			Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가마스터 정보 저장 끝");
 			
 			String i_sg_refitem = "";
 			String i_vendor_code = "";
 			String i_value_id = "";
 			String i_value_dept = "";

 			//평가대상업체 테이블 생성
 			SepoaXmlParser wxp_2 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_2");
 			
 			//평가대상업체 평가자 테이블 생성
 			SepoaXmlParser wxp_3 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_3");
 			
 			for ( int i = 0; i < setData.length; i++ )
 			{
 				i_sg_refitem 	= setData[i][2];
 				i_vendor_code 	= setData[i][0];
 				i_value_id 		= setData[i][3];
 				i_value_dept 	= setData[i][4];

 				//평가대상업체 테이블 생성
 				wxp_2.addVar("house_code", house_code);
 				wxp_2.addVar("i_sg_refitem", i_sg_refitem);
 				wxp_2.addVar("i_vendor_code", i_vendor_code);
 				wxp_2.addVar("max_eval_refitem", max_eval_refitem);

 				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_2.getQuery() );
 				rtnIns = sm.doInsert((String[][]) null, null );
 				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가대상업체 정보 저장 끝");
 				
 				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자 ::"+i_value_id);
 				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자 부서 ::"+i_value_dept);
 				
 				//평가자 생성하기
 				/*
 				int row_cnt = st.countTokens();
 				String[][] value_data = new String[row_cnt][2];

 				for ( int j = 0 ; j < row_cnt ; j++ ) 
 				{
 					SepoaStringTokenizer st1 = new SepoaStringTokenizer(st.nextToken().trim(), "@", false);
 					int row_cnt1 = st1.countTokens();

 					for ( int k = 0 ; k < row_cnt1 ; k++ ) 
 					{
 						String tmp_data = st1.nextToken().trim();

 						if(k == 0)
 							value_data[j][0] = tmp_data;//부서코드
 						else if(k ==3)
 							value_data[j][1] = tmp_data;//평가자ID
 					}	
 				}
 				*/
 				
 				String i_dept = "";
 				String i_id = "";

 				//평가대상업체 평가자 테이블 생성
 				wxp_3.addVar("house_code", house_code);
 				wxp_3.addVar("i_dept", i_value_dept);
 				wxp_3.addVar("i_id", i_value_id);
 				wxp_3.addVar("getCurrVal", getCurrVal("icomvevd", "eval_item_refitem"));

 				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_3.getQuery() );
 				rtnIns = sm.doInsert((String[][]) null, null );
 				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가 평가자 정보 저장 끝");
 				
 				//평가일련번호를 리턴해 줌.
 				returnString = max_eval_refitem;
 			}	

 			//Commit();
 		} catch( Exception e ) {
 			Rollback();
 			Logger.err.println(this, "Error ::"+e.getMessage());
 			returnString = "";
 		} finally { }

 		return returnString;
 	}

 	 public double getCurrVal(String tableName, String columnName){
 	    	double currVal = 0;
 	  	    SepoaOut wo = currvalForMssql(tableName, columnName);
 	  	    try{
 		  	    SepoaFormater wf2 = new SepoaFormater(wo.result[0]);
 		  	    currVal = Double.parseDouble((wf2.getValue("CURRVAL",0)));
 	  	    } catch(Exception e){
 	  	    	currVal = 0;
 	  	    }
 	    	return currVal;
 	 }

 	 public SepoaOut currvalForMssql(String tableName, String columnName){

          try{
               String rtn = "";
       		ConnectionContext ctx = getConnectionContext();
       		String house_code = info.getSession("HOUSE_CODE");
       		String user_id = info.getSession("ID");
       	
   			SepoaXmlParser wxp =  new SepoaXmlParser("master/evaluation/p0080","currvalForMssql");
 			wxp.addVar("columnName", columnName);
 			wxp.addVar("tableName", tableName);
 			wxp.addVar("house_code", house_code);
   			
   			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
   			rtn = sm.doSelect((String[])null);
       	
               setValue(rtn);
               setStatus(1);

           } catch(Exception e) {

               Logger.err.println("Exception e =" + e.getMessage());
               setStatus(0);
               Logger.err.println(this,e.getMessage());
           }
           return getSepoaOut();
 	 }    
 	  	
	
}
