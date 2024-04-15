<%@page import="sepoa.svl.util.SepoaMessage"%>
<%@page import="sepoa.fw.log.*"%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%!
private String trns(int cnt) throws Exception{
	StringBuilder sbData = new StringBuilder();
	
	for(int i=0; i<cnt; i++) {
		sbData.append(" ");
	}
	return sbData.toString();
}
%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_BD_016");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_BD_016";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	
	String ctrl_code = info.getSession("CTRL_CODE");

	String menu_type = "";
	//if (ctrl_code.startsWith("P01") || ctrl_code.startsWith("P02")) {
	//	menu_type = "ADMIN";
	//} else {
	//	menu_type = "NORMAL";
	//}
	
	if("S".equals(info.getSession("USER_TYPE")) ){
		menu_type = "";
	}
	else
	{
		menu_type = "ADMIN";
	}
	
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020325/rpt_bd_open_compare_pop_ict"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////


	Configuration wiseCfg = new Configuration();
	//boolean useXecureFlag = wiseCfg.getBoolean("wise.UseXecure");

    String BID_NO        = JSPUtil.nullToEmpty(request.getParameter("BID_NO"));
    String BID_COUNT     = JSPUtil.nullToEmpty(request.getParameter("BID_COUNT"));
    String VOTE_COUNT    = JSPUtil.nullToEmpty(request.getParameter("VOTE_COUNT"));

    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");

    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간

    String MAX_VOTE_COUNT     = "0";

    String CONT_TYPE1         = "";
    String CONT_TYPE2         = "";
    String ANN_NO             = "";
    String ANN_ITEM           = "";
    String CONT_TYPE1_TEXT_D  = "";
    String CONT_TYPE2_TEXT_D  = "";
    String CTRL_AMT           = "";
    String PR_NO              = "";

    String VENDOR_NAME        = "";
    String VENDOR_CODE        = "";
    String CEO_NAME_LOC       = "";
    String ADDRESS_LOC        = "";

    String USER_NAME          = "";
    String USER_MOBILE        = "";
    String USER_EMAIL         = "";

    String ESTM_PRICE         = "";
    String SETTLE_AMT         = "";
    String CTRL_SETTLE_RATE   = "";
    String ESTM_SETTLE_RATE   = "";
    String AC                 = "";
    String AC_RATE            = "";
    String BC                 = "";
    String BC_RATE            = "";

    String SAME_CNT           = "";

    String CTRL_AMT_TEXT        = "";

	String ANNOUNCE_FLAG       	= "";
    String BASIC_AMT       		= "";
    String PROM_CRIT			= "";
    
    String TCO_PERIOD           = "";

// 인증 관련
    String CRYP_CERT            = "";
    String CERTV				= "";
    String ESTM_CERTV           = "";
    String ESTM_TIMESTAMP       = "";
    String ESTM_SIGN_CERT       = "";
 
    String FROM_LOWER_BND       = "";
     
    String FINAL_ESTM_PRICE	 	= "";
    String FINAL_ESTM_PRICE_ENC = "";
    String ESTM_USER_ID			= "";
    
    String AMT_DQ				= "";
    String TECH_DQ			 	= "";
    String BID_EVAL_SCORE		= "";
    String PROM_CRIT_NAME		= "";

    String OPEN_DATE_TIME		= "";
    String BID_STATUS			= "";
    String PG_BEGIN_DATE		= "";
    String PG_END_DATE			= "";
    String CHANGE_USER_NAME_LOC = "";
    
    String VENDORS = "";
    
    
    boolean estm_sign_result	= false;
    
    double 	last_bid_amt      = 0.0;
    double estm_bid_amt      = 0.0;
    double conf_bid_amt      = 0.0;
    double product_price     = 0.0;
    double maintenance_price = 0.0;
    double dblRate01         = 0.0;
    double dblDiff01         = 0.0;

    int		bidCVendor	      = 0;
    int		validVendor	      = 0;
    String  conf_rate	      = "";
    String  conf_rate2	      = "";

	Map< String, String >   map = new HashMap< String, String >();
	map.put("HOUSE_CODE"	, info.getSession("HOUSE_CODE"));
	map.put("BID_NO"		, BID_NO);
	map.put("BID_COUNT"		, BID_COUNT);
	map.put("VOTE_COUNT"	, VOTE_COUNT);
	map.put("FLAG"			, "C");
	
	Object[] obj = {map};
	
	SepoaOut value0 = ServiceConnector.doService(info, "I_BD_014", "CONNECTION", "getBdMaxVoteCount", obj);
	SepoaFormater wf0 = new SepoaFormater(value0.result[0]);
	if(wf0 != null) {
        if(wf0.getRowCount() > 0) { //데이타가 있는 경우 
        	MAX_VOTE_COUNT = wf0.getValue("VOTE_COUNT"            ,0); 	
        }
	}
	
	SepoaOut value = ServiceConnector.doService(info, "I_BD_014", "CONNECTION","getBdHeaderCompare", obj);	
	SepoaFormater wf 		= new SepoaFormater(value.result[0]); 
	SepoaFormater wfList 	= null; 
	SepoaFormater wfListRpt = null; 
	

	
    if(wf != null) {
        if(wf.getRowCount() > 0) { //데이타가 있는 경우 
 
// 1st
        CONT_TYPE1                   = wf.getValue("CONT_TYPE1"            ,0);
        CONT_TYPE2                   = wf.getValue("CONT_TYPE2"            ,0);
        ANN_NO                       = wf.getValue("ANN_NO"                ,0);
        ANN_ITEM                     = wf.getValue("ANN_ITEM"              ,0);
        CONT_TYPE1_TEXT_D            = wf.getValue("CONT_TYPE1_TEXT_D"     ,0);
        CONT_TYPE2_TEXT_D            = wf.getValue("CONT_TYPE2_TEXT_D"     ,0);
        PR_NO                        = wf.getValue("PR_NO"                 ,0);
        CTRL_AMT                     = wf.getValue("CTRL_AMT"              ,0);
        ANNOUNCE_FLAG                = wf.getValue("ANNOUNCE_FLAG"         ,0);
        FROM_LOWER_BND               = wf.getValue("FROM_LOWER_BND"        ,0);
        AMT_DQ						 = wf.getValue("AMT_DQ"         	   ,0);
        TECH_DQ						 = wf.getValue("TECH_DQ"         	   ,0);
        BID_EVAL_SCORE				 = wf.getValue("BID_EVAL_SCORE"        ,0);
        PROM_CRIT				 	 = wf.getValue("PROM_CRIT"             ,0);
        PROM_CRIT_NAME				 = wf.getValue("PROM_CRIT_NAME"        ,0);

        OPEN_DATE_TIME				 = wf.getValue("OPEN_DATE"			   ,0);
        BID_STATUS				 	 = wf.getValue("BID_STATUS"			   ,0);
        PG_BEGIN_DATE				 = wf.getValue("PG_BEGIN_DATE"		   ,0);
        PG_END_DATE				 	 = wf.getValue("PG_END_DATE"		   ,0);
        CHANGE_USER_NAME_LOC         = wf.getValue("CHANGE_USER_NAME_LOC"  ,0);
        
        TCO_PERIOD                   = wf.getValue("TCO_PERIOD"  ,0);
        
        VENDORS                      = wf.getValue("VENDORS"			   ,0);
        
// 2nd  =======================================================================
        wf = new SepoaFormater(value.result[1]);

	        if(wf != null) {
	            if(wf.getRowCount() > 0) { //데이타가 있는 경우 
			        CTRL_AMT_TEXT                = wf.getValue("CTRL_AMT_TEXT"         ,0);
			        ESTM_PRICE                   = wf.getValue("ESTM_PRICE1_ENC"       ,0);
			        FINAL_ESTM_PRICE		 	 = wf.getValue("FINAL_ESTM_PRICE"      ,0);
			        FINAL_ESTM_PRICE_ENC		 = wf.getValue("FINAL_ESTM_PRICE_ENC"  ,0);
			
			        CERTV						 = wf.getValue("CERTV"                 ,0);
			        ESTM_TIMESTAMP               = wf.getValue("TIMESTAMP"             ,0);
			        ESTM_SIGN_CERT               = wf.getValue("SIGN_CERT"             ,0);
			        BASIC_AMT               	 = wf.getValue("BASIC_AMT"             ,0);
			        ESTM_USER_ID				 = wf.getValue("ESTM_USER_ID"          ,0);
	            }
	        }
	        SepoaOut value1 = ServiceConnector.doService(info, "I_BD_014", "CONNECTION", "getBidResult", obj);
	        wfList = new SepoaFormater(value1.result[0]);
	        wfListRpt = new SepoaFormater(value1.result[1]);
	        
	        //BID_AMT_1           ~ BID_AMT_10				: 투찰총액
	        //PRODUCT_PRICE_1     ~ PRODUCT_PRICE_10		: 물품공급금액
	        //MAINTENANCE_PRICE_1 ~ MAINTENANCE_PRICE_10	: 유지보수금액
	        if(wfList.getRowCount() > 0){
	        	//conf_bid_amt      = wfList.getDouble("BID_AMT_" + VOTE_COUNT, 0);
	        	//product_price     = wfList.getDouble("PRODUCT_PRICE_" + VOTE_COUNT, 0);
	        	//maintenance_price = wfList.getDouble("MAINTENANCE_PRICE_" + VOTE_COUNT, 0);
	        	conf_bid_amt      = wfList.getDouble("BID_AMT_" + MAX_VOTE_COUNT, 0);
	        	product_price     = wfList.getDouble("PRODUCT_PRICE_" + MAX_VOTE_COUNT, 0);
	        	maintenance_price = wfList.getDouble("MAINTENANCE_PRICE_" + MAX_VOTE_COUNT, 0);
	        		        	
		        if(conf_bid_amt > 0 && "SB".equals(BID_STATUS)){
		        	
		        	if ("TA".equals(CONT_TYPE2)){		        		
		        		conf_rate  = product_price / Double.parseDouble(FINAL_ESTM_PRICE) * 100 + "";			        	
		        	}else{
		        		conf_rate  = conf_bid_amt / Double.parseDouble(FINAL_ESTM_PRICE) * 100 + "";			        		
		        	}
		        	if ("0".equals(BASIC_AMT) )
		        	{
			        	conf_rate2 = "0";
		        		
		        	}else{
			        	conf_rate2 = conf_bid_amt / Double.parseDouble(BASIC_AMT) * 100 + "";
		        	}
		        }

		        //if("SB".equals(wfList.getValue("BID_STATUS", 0))){
		        if("SB".equals(BID_STATUS) && "SB".equals(wfList.getValue("BID_STATUS", 0))){
					VENDOR_NAME	= wfList.getValue("VENDOR_NAME"	, 0);  

			        USER_MOBILE = wfList.getValue("USER_MOBILE"	, 0);
			        ADDRESS_LOC = wfList.getValue("ADDRESS_LOC"	, 0);
			        USER_EMAIL  = wfList.getValue("USER_EMAIL"	, 0);
			        CEO_NAME_LOC= wfList.getValue("CEO_NAME_LOC", 0);
			        USER_NAME   = wfList.getValue("USER_NAME"	, 0);
			        VENDOR_CODE = wfList.getValue("VENDOR_CODE"	, 0);
			        
			        // 물품공급가액이 내정가격의 85% 미만인경우 내정가격과 차액보증보험금액(내정가격과 물품공급가액 차액) 표시
			        // 70% 미만인 경우는 차액보증보험금액*2 표시
			        
			        //product_price = 6990.00;
			        dblRate01 = ( product_price / Double.parseDouble(FINAL_ESTM_PRICE)) * 100;
			        dblRate01 = Math.round(dblRate01/.01)*.01;	// 소수점2자리에서 반올림 처리
			        
			        if (dblRate01 < 70.00){
			        	dblDiff01 = (Double.parseDouble(FINAL_ESTM_PRICE) - product_price) * 2;
			        }else if (dblRate01 < 85.00){
			        	dblDiff01 = Double.parseDouble(FINAL_ESTM_PRICE) - product_price;
			        }

			        if("S".equals(info.getSession("USER_TYPE")) ){
			        	USER_MOBILE = "****";
			        	ADDRESS_LOC = "****";
			        	USER_EMAIL  = "****";
			        	CEO_NAME_LOC= "****";
			        	USER_NAME   = "****";
			        	BASIC_AMT = "";
			        	conf_rate2= "";
			        	FINAL_ESTM_PRICE= "";
			        	conf_rate= "";
			        }
		        }else{
		        	if("S".equals(info.getSession("USER_TYPE")) ){
			        	BASIC_AMT = "";
			        	conf_rate2= "";
			        	FINAL_ESTM_PRICE= "";
			        	conf_rate= "";
			        }
		        }
		        	
	        }
		        
		        
		    
		        
		        
		        


        }
    } 
        
    String vendor_name = "";
	String bid_cancel_yn = "";
	//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
	_rptData.append(ANN_NO);
	_rptData.append(_RF);
	_rptData.append(ANN_ITEM);
	_rptData.append(_RF);
	_rptData.append(CONT_TYPE1_TEXT_D);
	_rptData.append(" / ");
	_rptData.append(("TA".equals(CONT_TYPE2))?TCO_PERIOD+"년":"");
	_rptData.append(CONT_TYPE2_TEXT_D);
	_rptData.append(" / ");
	_rptData.append(PROM_CRIT_NAME);
	_rptData.append(" / ");
	_rptData.append(("TA".equals(CONT_TYPE2))?"(단. 물품금액 ≤ 내정가격 조건) ":"");
	_rptData.append(_RF);
	_rptData.append(PG_BEGIN_DATE);
	_rptData.append(" ~ ");
	_rptData.append(PG_END_DATE);
	_rptData.append(_RF);
	_rptData.append(CHANGE_USER_NAME_LOC);
	_rptData.append(_RF);
	_rptData.append(VENDOR_NAME);
	_rptData.append(_RF);
	_rptData.append(USER_NAME);
	_rptData.append(_RF);
	_rptData.append(CEO_NAME_LOC);
	_rptData.append(_RF);
	_rptData.append(USER_MOBILE);
	_rptData.append(_RF);
	_rptData.append(ADDRESS_LOC);
	_rptData.append(_RF);
	_rptData.append(USER_EMAIL);
	_rptData.append(_RF);
	
	_rptData.append(SepoaMath.SepoaNumberType( FINAL_ESTM_PRICE, "###,###,###,###,###,###" ));
	_rptData.append(_RF);
	_rptData.append(SepoaMath.SepoaNumberType(conf_rate, "###.##"));
	_rptData.append(_RF);
	if("SB".equals(BID_STATUS) ){
		_rptData.append(SepoaMath.SepoaNumberType(conf_bid_amt, "###,###,###,###,###,###" ));		
		_rptData.append(_RF);
		if ("TA".equals(CONT_TYPE2)) {
			_rptData.append("물품가격 : ");
			_rptData.append(SepoaMath.SepoaNumberType(product_price, "###,###,###,###,###,###" ));
			_rptData.append(_RF);
			_rptData.append("유지보수 : ");
			_rptData.append(SepoaMath.SepoaNumberType(maintenance_price, "###,###,###,###,###,###" ));
		}else{
			_rptData.append(_RF);				
		}
	}else{
		_rptData.append(_RF);		
		_rptData.append(_RF);	
	}
	_rptData.append(_RF);
	if ( ( COMPANY_CODE.equals(VENDOR_CODE) || "ADMIN".equals(menu_type) ) && conf_bid_amt > 10000000 ){
		if (dblDiff01 != 0.0){
			_rptData.append(SepoaMath.SepoaNumberType(dblDiff01, "###,###,###,###,###,###" ));	
		}				
	}
	
	_rptData.append(_RD);
	_rptData.append(CONT_TYPE2);
	_rptData.append(_RD);
	/*
	for(int i = 0 ; i < wfList.getRowCount() ; i++){
		if("ADMIN".equals(menu_type)){
			vendor_name = wfList.getValue("VENDOR_NAME", i);
		}else{
			if( info.getSession("COMPANY_CODE").equals(wfList.getValue("VENDOR_CODE", i))){
				vendor_name = wfList.getValue("VENDOR_NAME", i);
			}else{
				vendor_name = "";
			}
		}					
		for(int j = 1 ; j <= Integer.parseInt(VOTE_COUNT) ; j++){				
			//if("".equals(wfList.getValue("BID_AMT_" + j, i)) && j != 1){
			//	break;
			//}
					
			_rptData.append(i+1);	
			_rptData.append(_RF);						
			_rptData.append(vendor_name);	
			_rptData.append(_RF);	
			_rptData.append("입찰금액(");
			_rptData.append(j);
			_rptData.append("차)");
			_rptData.append(_RF);
			bid_cancel_yn = wfList.getValue("BID_CANCEL_" + j, i);
	
			if("Y".equals(bid_cancel_yn)){
				bid_cancel_yn = "<BR><C.RED>(입찰취소)</C>";
			}else{
				bid_cancel_yn = "";
			}
					
			if( info.getSession("COMPANY_CODE").equals(wfList.getValue("VENDOR_CODE", i)) || "ADMIN".equals(menu_type) ){
				if (PROM_CRIT.equals("A") ) {
					_rptData.append(SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###"));	
					_rptData.append(bid_cancel_yn);	
				}else if(PROM_CRIT.equals("D")){
					_rptData.append(SepoaMath.SepoaNumberType(wfList.getValue("PRODUCT_PRICE_" + j, i), "###,###,###,###,###,###,###"));	
					_rptData.append("<BR>");
					_rptData.append(SepoaMath.SepoaNumberType(wfList.getValue("MAINTENANCE_PRICE_" + j, i), "###,###,###,###,###,###,###"));	
					_rptData.append("<BR>");
					_rptData.append(SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###"));							
					_rptData.append(bid_cancel_yn);												
				}
			}
			_rptData.append(_RL);
		}
		
	}
	*/
	
	int loopCnt1 = 0;
	int loopCnt2 = 0;
	int gpCnt = 0;
	String sANN_NO = "";
	String sCONT_TYPE2 = "";
	String sBDVO_VOTE_COUNT = "";
	int iVENDOR_COUNT = 0;
	
	if("WOORI".equals(info.getSession("COMPANY_CODE"))){
		
	    for(int j=0; j<wfListRpt.getRowCount(); j++) {
	    	Logger.debug.println("j = " + j);    	
	    	Logger.debug.println("wfListRpt.getValue(BDVO_VOTE_COUNT,j) = " + wfListRpt.getValue("BDVO_VOTE_COUNT",j));
	    	if(!sBDVO_VOTE_COUNT.equals(wfListRpt.getValue("BDVO_VOTE_COUNT",j))){
				loopCnt1 = 0;
				//gpCnt = Integer.parseInt(wfListRpt.getValue(j,7));
				sANN_NO = wfListRpt.getValue("ANN_NO",j);
				sCONT_TYPE2 = wfListRpt.getValue("CONT_TYPE2",j);
				sBDVO_VOTE_COUNT = wfListRpt.getValue("BDVO_VOTE_COUNT",j);
				iVENDOR_COUNT = Integer.parseInt(wfListRpt.getValue("VENDOR_COUNT",j)); 
				if("TA".equals(sCONT_TYPE2)){
					gpCnt = iVENDOR_COUNT * 3;
					if(gpCnt <= 15){
						loopCnt2 = 15 - gpCnt;
					}else if(gpCnt <= 30){
						loopCnt2 = 30 - gpCnt;
					}else if(gpCnt <= 45){
						loopCnt2 = 45 - gpCnt;
					}else if(gpCnt <= 60){
						loopCnt2 = 60 - gpCnt;
					}else if(gpCnt <= 75){
						loopCnt2 = 75 - gpCnt;
					}else if(gpCnt <= 90){
						loopCnt2 = 90 - gpCnt;
					}
				}else{
					gpCnt = iVENDOR_COUNT;
					if(gpCnt <= 5){
						loopCnt2 = 5 - gpCnt;
					}else if(gpCnt <= 10){
						loopCnt2 = 10 - gpCnt;
					}else if(gpCnt <= 15){
						loopCnt2 = 15 - gpCnt;
					}else if(gpCnt <= 20){
						loopCnt2 = 20 - gpCnt;
					}else if(gpCnt <= 25){
						loopCnt2 = 25 - gpCnt;
					}else if(gpCnt <= 30){
						loopCnt2 = 30 - gpCnt;
					}
				}
			}//end if
			//_rptData.append(wfListRpt.getValue("ANN_NO",j));
			//_rptData.append(_RF);
			_rptData.append(wfListRpt.getValue("BDVO_VOTE_COUNT",j));
			_rptData.append(_RF);
			_rptData.append(wfListRpt.getValue("GB_AMT",j));
			_rptData.append(_RF);
			if( info.getSession("COMPANY_CODE").equals(wfListRpt.getValue("VENDOR_CODE", j)) || "ADMIN".equals(menu_type) ){			
				_rptData.append(wfListRpt.getValue("VENDOR_NAME",j));
				_rptData.append(_RF);
				if("Y".equals(wfListRpt.getValue("BID_CANCEL_FLAG",j))){
					_rptData.append(wfListRpt.getValue("BID_AMT",j));
					_rptData.append("<BR><C.RED>(입찰취소)</C>");			
				}else{
					_rptData.append(wfListRpt.getValue("BID_AMT",j));			
				}
			}else{
				_rptData.append(_RF);
			}
			
			_rptData.append(_RF);
			_rptData.append(wfListRpt.getValue("RESULT",j));
			_rptData.append(_RL);	
			
			loopCnt1++;
			
			Logger.debug.println("loopCnt1 = " + loopCnt1);    	
	    	Logger.debug.println("loopCnt2 = " + loopCnt2);    	
	    	Logger.debug.println("gpCnt = " + gpCnt);    	
	    	if(loopCnt1 == gpCnt){
	    		Logger.debug.println("sCONT_TYPE2 = " + sCONT_TYPE2);  
				if("TA".equals(sCONT_TYPE2)){
					int cnt1 = 0;
					String a = " ";
					Logger.debug.println("loopCnt2 = " + loopCnt2);  
					for(int k=0; k<loopCnt2; k++) {		
						//_rptData.append(sANN_NO);
						//_rptData.append(_RF);
						_rptData.append(sBDVO_VOTE_COUNT);
						_rptData.append(_RF);
						if((k+3)%3 == 0){
							_rptData.append("물품금액");						
						}else if((k+3)%3 == 1){
							_rptData.append("유지보수");
						}else if((k+3)%3 == 2){
							_rptData.append("총금액");
						}					
						_rptData.append(_RF);
						//_rptData.append(trns(k+1));
						_rptData.append(a);
						_rptData.append(_RF);
						_rptData.append(a);
						_rptData.append(_RF);
						_rptData.append(a);
						_rptData.append(_RL);
						
						cnt1+=1;
						if(cnt1 == 3){
							a += " ";
							cnt1 = 0;
						}
					}	
				}else{
					for(int k=0; k<loopCnt2; k++) {
						//_rptData.append(sANN_NO);
						//_rptData.append(_RF);
						_rptData.append(sBDVO_VOTE_COUNT);
						_rptData.append(_RF);
						_rptData.append("총금액");
						_rptData.append(_RF);
						_rptData.append(trns(k+1));
						_rptData.append(_RF);
						_rptData.append(trns(k+1));
						_rptData.append(_RF);
						_rptData.append(trns(k+1));
						_rptData.append(_RL);	
					}	
				}
				
				loopCnt1 = 0;
				loopCnt2 = 0;
				gpCnt = 0;
				sANN_NO = "";
				sCONT_TYPE2 = "";
				sBDVO_VOTE_COUNT = "";
			}
		}
	    _rptData.append(_RD);		
	}else{
		for(int j=0; j<wfListRpt.getRowCount(); j++) {
	    	Logger.debug.println("j = " + j);    	
	    	Logger.debug.println("wfListRpt.getValue(BDVO_VOTE_COUNT,j) = " + wfListRpt.getValue("BDVO_VOTE_COUNT",j));
	    	if(!sBDVO_VOTE_COUNT.equals(wfListRpt.getValue("BDVO_VOTE_COUNT",j))){
	    		loopCnt1 = 0;
				//gpCnt = Integer.parseInt(wfListRpt.getValue(j,7));
				sANN_NO = wfListRpt.getValue("ANN_NO",j);
				sCONT_TYPE2 = wfListRpt.getValue("CONT_TYPE2",j);
				sBDVO_VOTE_COUNT = wfListRpt.getValue("BDVO_VOTE_COUNT",j);
				iVENDOR_COUNT = Integer.parseInt(wfListRpt.getValue("VENDOR_COUNT",j)); 
				if("TA".equals(sCONT_TYPE2)){
					gpCnt = iVENDOR_COUNT * 3;
					loopCnt2 = 12;					
				}else{
					gpCnt = iVENDOR_COUNT;
					loopCnt2 = 4;			
				}
			}	    	
			if( info.getSession("COMPANY_CODE").equals(wfListRpt.getValue("VENDOR_CODE", j)) || "ADMIN".equals(menu_type) ){				
				_rptData.append(wfListRpt.getValue("BDVO_VOTE_COUNT",j));
				_rptData.append(_RF);
				_rptData.append(wfListRpt.getValue("GB_AMT",j));
				_rptData.append(_RF);				
				_rptData.append(wfListRpt.getValue("VENDOR_NAME",j));
				_rptData.append(_RF);
				if("Y".equals(wfListRpt.getValue("BID_CANCEL_FLAG",j))){
					_rptData.append(wfListRpt.getValue("BID_AMT",j));
					_rptData.append("<BR><C.RED>(입찰취소)</C>");			
				}else{
					_rptData.append(wfListRpt.getValue("BID_AMT",j));			
				}
				_rptData.append(_RF);
				_rptData.append(wfListRpt.getValue("RESULT",j));
				_rptData.append(_RL);	
			}
			
			loopCnt1++;
			
			Logger.debug.println("loopCnt1 = " + loopCnt1);    	
	    	Logger.debug.println("loopCnt2 = " + loopCnt2);    	
	    	Logger.debug.println("gpCnt = " + gpCnt);    	
	    	if(loopCnt1 == gpCnt){
	    		Logger.debug.println("sCONT_TYPE2 = " + sCONT_TYPE2);  
				if("TA".equals(sCONT_TYPE2)){
					int cnt1 = 0;
					String a = " ";
					Logger.debug.println("loopCnt2 = " + loopCnt2);  
					for(int k=0; k<loopCnt2; k++) {		
						//_rptData.append(sANN_NO);
						//_rptData.append(_RF);
						_rptData.append(sBDVO_VOTE_COUNT);
						_rptData.append(_RF);
						if((k+3)%3 == 0){
							_rptData.append("물품금액");						
						}else if((k+3)%3 == 1){
							_rptData.append("유지보수");
						}else if((k+3)%3 == 2){
							_rptData.append("총금액");
						}					
						_rptData.append(_RF);
						//_rptData.append(trns(k+1));
						_rptData.append(a);
						_rptData.append(_RF);
						_rptData.append(a);
						_rptData.append(_RF);
						_rptData.append(a);
						_rptData.append(_RL);
						
						cnt1+=1;
						if(cnt1 == 3){
							a += " ";
							cnt1 = 0;
						}
					}	
				}else{
					for(int k=0; k<loopCnt2; k++) {
						//_rptData.append(sANN_NO);
						//_rptData.append(_RF);
						_rptData.append(sBDVO_VOTE_COUNT);
						_rptData.append(_RF);
						_rptData.append("총금액");
						_rptData.append(_RF);
						_rptData.append(trns(k+1));
						_rptData.append(_RF);
						_rptData.append(trns(k+1));
						_rptData.append(_RF);
						_rptData.append(trns(k+1));
						_rptData.append(_RL);	
					}	
				}
				
				loopCnt1 = 0;
				loopCnt2 = 0;
				gpCnt = 0;
				sANN_NO = "";
				sCONT_TYPE2 = "";
				sBDVO_VOTE_COUNT = "";
			}
		}
		
		
		
		_rptData.append(_RD);
		if("SB".equals(BID_STATUS)){
			if(COMPANY_CODE.equals(VENDOR_CODE)){
				_rptData.append(ANN_ITEM);
				_rptData.append("에 낙찰되었음을 확인합니다.");	
				_rptData.append(_RF);
				_rptData.append("금일 중 해당 구매 담당자에게 낙찰견적서 제출바랍니다. 계약체결 안내는 추후 공지하겠습니다.");	
			}else{
				_rptData.append(ANN_ITEM);
				_rptData.append("은 유찰 되었습니다.");	
				_rptData.append(_RF);
			}	
		}else{
			_rptData.append(ANN_ITEM);
			_rptData.append("은 유찰 되었습니다.");	
			_rptData.append(_RF);
			_rptData.append("재공고 및 재입찰 안내는 추후 공지하겠습니다.");	
		}
		
	}
//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////
    
    if(!"ADMIN".equals(menu_type)){
    	if(VENDORS.indexOf(info.getSession("COMPANY_CODE")) < 0){    
%>
			<script language="javascript" type="text/javascript">
				alert("접근권한이 없습니다.");
				self.close();
			</script>
<%
			return;
    	}
    }
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" type="text/javascript">
var rCnt = 0; //낙찰업체 인덱스

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_open_compare";

function doHtmlSave(){
	var tmp = $("#btnTable").html(); 
	$("#btnTable").html("");
	
 	Some.document.open("text/html","replace");
 	
 	var getHtml = document.documentElement.outerHTML;
 	
 	getHtml = getHtml.replaceAll("<IMG align=absMiddle src=\"/images/blt_srch.gif\" width=7 height=7>", "");
 	getHtml = getHtml.replaceAll("<TABLE border=0 cellSpacing=0 cellPadding=1 width=\"100%\">", "<TABLE border=1 cellSpacing=0 cellPadding=1 width=\"100%\">");
 	getHtml = getHtml.replaceAll("BACKGROUND-COLOR: #f6f6f6;", "");
 	getHtml = getHtml.replaceAll("bgColor=#dedede", "");
 	
 	$("#btnTable").html(tmp);

 	Some.document.write(getHtml ) ;
	Some.document.close() ;
	Some.focus() ;
	Some.document.execCommand('SaveAs',false,'저장될 파일명');
	
} 

function fnInit() {
	
	<%if ( ( COMPANY_CODE.equals(VENDOR_CODE) || "ADMIN".equals(menu_type) ) && conf_bid_amt > 10000000 ){%>
			if ("<%=dblDiff01%>" != "0.0"){
				$("#tr_003").show();		
			}		
	<%}%>
	

}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint() {
    var url = "/ClipReport4/ClipViewer.jsp";
	//url = url + "?BID_TYPE=" + bid_type;	
    window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=900,left=0,top=0");
	document.form1.method = "POST";
	document.form1.action = url;
	document.form1.target = "ClipReport4";
	document.form1.submit(); 
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onload="fnInit();">
<!--내용시작-->
<form id="form1" name="form1">
	<%--ClipReport4 hidden 태그 시작--%>
	<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
	<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">	
	<%--ClipReport4 hidden 태그 끝--%>
	
	<input type="hidden" id="VENDOR_CODE" 	name="VENDOR_CODE" 		value="<%=VENDOR_CODE%>">
	<input type="hidden" id="COMP_MARK" 	name="COMP_MARK" 		value="">
	<input type="hidden" id="CRYP_CERT" 	name="CRYP_CERT" 		value="<%=CRYP_CERT%>">
	<input type="hidden" id="NB_REASON" 	name="NB_REASON" 		value="">
	<input type="hidden" id="sr_attach_no" 	name="sr_attach_no" 	value="">
	<input type="hidden" id="SB_REASON" 	name="SB_REASON" 		value="">
	
	<input type="hidden" name="H_ESTM_PRICE">
	
	<input type="hidden" name="BID_NO" id="BID_NO" value="<%=BID_NO%>">
	<input type="hidden" name="BID_COUNT" id="BID_COUNT" value="<%=BID_COUNT%>">
	<input type="hidden" name="VOTE_COUNT" id="VOTE_COUNT" value="<%=VOTE_COUNT%>">
	<input type="hidden" name="FLAG" id="FLAG">
	<input type="hidden" name="CONT_TYPE1" id="CONT_TYPE1">
	<input type="hidden" name="BID_BEGIN_DATE" id="BID_BEGIN_DATE">
	<input type="hidden" name="BID_BEGIN_TIME" id="BID_BEGIN_TIME">
	<input type="hidden" name="BID_END_DATE" id="BID_END_DATE">
	<input type="hidden" name="BID_END_TIME" id="BID_END_TIME">
	<input type="hidden" name="OPEN_DATE" id="OPEN_DATE">
	<input type="hidden" name="OPEN_TIME" id="OPEN_TIME">

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" align="left" class="title_page" vAlign="bottom">
				개찰결과
			</td>
		</tr>
	</table>

	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>


	<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<colgroup>
									<col width="15%" />
									<col width="35%" />
									<col width="15%" />
									<col width="35%" />
								</colgroup>
								<tr>
									<td width="15%" class="title_td">
										&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>
										&nbsp;&nbsp;공문번호
									</td>
									<td width="85%" class="data_td">&nbsp;<%=ANN_NO%></td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">
										&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>
										&nbsp;&nbsp;입찰건명
									</td>
									<td width="85%" class="data_td">&nbsp;<%=ANN_ITEM%></td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td class="title_td" width="15%">
										&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>
										&nbsp;&nbsp;입찰방법
									</td>
									<td width="85%" class="data_td">
										&nbsp;<%=CONT_TYPE1_TEXT_D%>&nbsp;/&nbsp;<%=("TA".equals(CONT_TYPE2))?TCO_PERIOD+"년":"" %><%=CONT_TYPE2_TEXT_D%>&nbsp;/&nbsp;<%=PROM_CRIT_NAME %>&nbsp;&nbsp;<%=("TA".equals(CONT_TYPE2))?"(단. 물품금액 ≤ 내정가격 조건) ":"" %>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td class="title_td" width="15%">
										&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>
										&nbsp;&nbsp;입찰일시
									</td>
									<td width="85%" class="data_td">&nbsp;<%=PG_BEGIN_DATE %> ~ <%=PG_END_DATE %></td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td class="title_td" width="15%">
										&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>
										&nbsp;&nbsp;구매담당자
									</td>
									<td width="85%" class="data_td">&nbsp;<%=CHANGE_USER_NAME_LOC %></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
														
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="10"></td>
		</tr>
	</table>
														
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="15%" class="title_td">
										&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>
										&nbsp;&nbsp;낙찰업체
									</td>
									<td width="35%" class="data_td">
										&nbsp;<input type="text" name="VENDOR_NAME" value="<%=VENDOR_NAME%>" style="width:90%;background-color: #f6f6f6;border: 0px;" readonly >
									</td>
									<td width="15%" class="title_td">
										&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>
										&nbsp;&nbsp;담당자명
									</td>
									<td width="35%" class="data_td">
										&nbsp;<input type="text" name="USER_NAME" value="<%=USER_NAME%>" style="width:90%;background-color: #f6f6f6;border: 0px;" readonly >
									</td>
								</tr>
								<tr>
									<td width="15%" class="title_td">
										&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>
										&nbsp;&nbsp;대표자명
									</td>
									<td width="35%" class="data_td">
										&nbsp;<input type="text" name="CEO_NAME_LOC" value="<%=CEO_NAME_LOC%>" style="width:90%;background-color: #f6f6f6;border: 0px;" readonly >
									</td>
									<td width="15%" class="title_td">
										&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>
										&nbsp;&nbsp;핸드폰번호
									</td>
									<td width="35%" class="data_td">
										&nbsp;<input type="text" name="USER_MOBILE" value="<%=USER_MOBILE%>" style="width:90%;background-color: #f6f6f6;border: 0px;" readonly >
									</td>
								</tr>
								<tr>
									<td class="title_td" width="15%">
										&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>
										&nbsp;&nbsp;주소
									</td>
									<td width="35%" class="data_td">
										&nbsp;<input type="text" name="ADDRESS_LOC" value="<%=ADDRESS_LOC%>" style="width:90%;background-color: #f6f6f6;border: 0px;" readonly >
									</td>
									<td class="title_td" width="15%">
										&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>
										&nbsp;&nbsp;EMAIL
									</td>
									<td width="35%" class="data_td">
										&nbsp;<input type="text" name="USER_EMAIL" value="<%=USER_EMAIL%>" style="width:90%;background-color: #f6f6f6;border: 0px;" readonly >
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
														
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="10"></td>
		</tr>
	</table>
														
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<%
								
								if (PROM_CRIT.equals("A") ) {
								
									%>
									<tr>
										<td width="20%" class="title_td" style="text-align: center">구분</td>
										<td width="40%" class="title_td" style="text-align: center">금액(VAT 포함)</td>
										<td width="40%" class="title_td" style="text-align: center" colspan="2">낙찰가율</td>
										<td id="tech_dq_1" width="*"  class="title_td" style="text-align: center; display: none;">절감액 및 절감율</td>
									</tr>
									<tr style="display:none;">
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr style="display:none;">
										<td class="title_td" style="text-align: center;">예정가격(A)</td>
										<td class="data_td">
											<input type="text" name="BASIC_AMT" style="width:58%;text-align: right;background-color: #f6f6f6;border: 0px;" value="<%= SepoaMath.SepoaNumberType( BASIC_AMT, "###,###,###,###,###,###" )%>" readonly>
										</td>
										<td class="data_td" colspan="2">
											<input type="text" name="CTRL_SETTLE_RATE" style="width:55%; text-align: right;background-color: #f6f6f6;border: 0px;" readonly value="<%=SepoaMath.SepoaNumberType(conf_rate2, "###.##")%>">&nbsp;%
										</td>
										<td id="tech_dq_2" class="data_td" style=" display: none;">
											A - C = <input type="text" name="AC" style="text-align: right;background-color: #f6f6f6;border: 0px;" size="12" readonly >
											&nbsp;
											(<input type="text" name="AC_RATE" style="text-align: right;background-color: #f6f6f6;border: 0px;" size="8" readonly >&nbsp;%)
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td class="title_td" style="text-align: center;">내정가격(B)</td>
										<td class="data_td">
											<input type="text" name="ESTM_PRICE" id="ESTM_PRICE" style="width:58%;text-align: right;background-color: #f6f6f6;border: 0px;" size="15" readonly value="<%=SepoaMath.SepoaNumberType( FINAL_ESTM_PRICE, "###,###,###,###,###,###" )%>">
										</td>
										<td class="data_td" colspan="2">
											<input type="text" name="ESTM_SETTLE_RATE" style="width:55%;text-align: right;background-color: #f6f6f6;border: 0px;"  size="6" readonly value="<%=SepoaMath.SepoaNumberType(conf_rate, "###.##")%>">&nbsp;%
										</td>
										<td id="tech_dq_3" class="data_td"  style=" display: none;">
											B - C = <input type="text" name="BC" size="12" readonly style="text-align: right;background-color: #f6f6f6;border: 0px;">
											&nbsp;
											(<input type="text" name="BC_RATE" size="8" readonly style="text-align: right;background-color: #f6f6f6;border: 0px;">&nbsp;%)
										</td>
									</tr>
									<%
									if("SB".equals(BID_STATUS) ){
									%>
										<tr>
											<td colspan="4" height="1" bgcolor="#dedede"></td>
										</tr>
										<tr>
											<td class="title_td" style="text-align: center;">낙찰금액(C)</td>
											<td class="data_td">
												<input type="text" name="SETTLE_AMT" style="width:58%;text-align: right;background-color: #f6f6f6;border: 0px;"  readonly value="<%=SepoaMath.SepoaNumberType(conf_bid_amt, "###,###,###,###,###,###" )%>">
											</td>
											
											<%if ("TA".equals(CONT_TYPE2)) {	// TCO 입찰%>
												<td class="data_td" colspan="2">
													<table>
														<tr>
															<td class="title_td" width="20%">
																물품가격 :
																<input type="text" name="SETTLE_AMT1" style="width:30%;text-align: left;background-color: #f6f6f6;border: 0px;"  readonly value="<%=SepoaMath.SepoaNumberType(product_price, "###,###,###,###,###,###" )%>">
															</td>
															<td class="title_td" width="20%">
																유지보수 :
																<input type="text" name="SETTLE_AMT2" style="width:30%;text-align: left;background-color: #f6f6f6;border: 0px;"  readonly value="<%=SepoaMath.SepoaNumberType(maintenance_price, "###,###,###,###,###,###" )%>">
															</td>
														</tr>
													</table>
												</td>
											<%}else{%>
												<td class="data_td" colspan="2">
												</td>
											<%}%>
										</tr>
									<%
									}else{
									%>
										<tr>
											<td colspan="4">
												<input type="hidden" name="SETTLE_AMT" style="width:58%;text-align: right;background-color: #f6f6f6;border: 0px;"  readonly>
												<input type="hidden" name="FROM_LOWER_BND_AMT" id="FROM_LOWER_BND_AMT"  size="12" readonly style="text-align: right;background-color: #f6f6f6;border: 0px;">
												<input type="hidden" name="FROM_LOWER_BND" style="text-align: right;background-color: #f6f6f6;border: 0px;" size="5" readonly>
											</td>
										</tr>
									<%
									}
									%>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr id="tr_003" style=" display: none;">
										<td class="title_td" style="text-align: center;">차액보증보험금액</td>
										<td class="data_td">
											<input type="text" name="DIFF_AMT" style="width:58%;text-align: right;background-color: #f6f6f6;border: 0px;"  readonly value="<%=SepoaMath.SepoaNumberType(dblDiff01, "###,###,###,###,###,###" )%>">
										</td>
										<td class="data_td"><font color="red">* 차액 이행증권 제출</font></td>
										<td class="data_td"></td>
									</tr>

								<%
								} else if (PROM_CRIT.equals("D") ) {
								%>
								
								<tr>
										<td width="20%" class="title_td" style="text-align: center">구분</td>
										<td width="40%" class="title_td" style="text-align: center">금액(VAT 포함)</td>
										<td width="40%" class="title_td" style="text-align: center" colspan="2">낙찰가율</td>
										<td id="tech_dq_1" width="*"  class="title_td" style="text-align: center; display: none;">절감액 및 절감율</td>
									</tr>
									<tr style="display:none;">
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr style="display:none;">
										<td class="title_td" style="text-align: center;">예정가격(A)</td>
										<td class="data_td">
											<input type="text" name="BASIC_AMT" style="width:58%;text-align: right;background-color: #f6f6f6;border: 0px;" value="<%= SepoaMath.SepoaNumberType( BASIC_AMT, "###,###,###,###,###,###" )%>" readonly>
										</td>
										<td class="data_td" colspan="2">
											<input type="text" name="CTRL_SETTLE_RATE" style="width:55%; text-align: right;background-color: #f6f6f6;border: 0px;" readonly value="<%=SepoaMath.SepoaNumberType(conf_rate2, "###.##")%>">&nbsp;%
										</td>
										<td id="tech_dq_2" class="data_td" style=" display: none;">
											A - C = <input type="text" name="AC" style="text-align: right;background-color: #f6f6f6;border: 0px;" size="12" readonly >
											&nbsp;
											(<input type="text" name="AC_RATE" style="text-align: right;background-color: #f6f6f6;border: 0px;" size="8" readonly >&nbsp;%)
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td class="title_td" style="text-align: center;">내정가격(B)</td>
										<td class="data_td">
											<input type="text" name="ESTM_PRICE" id="ESTM_PRICE" style="width:58%;text-align: right;background-color: #f6f6f6;border: 0px;" size="15" readonly value="<%=SepoaMath.SepoaNumberType( FINAL_ESTM_PRICE, "###,###,###,###,###,###" )%>">
										</td>
										<td class="data_td" colspan="2">
											<input type="text" name="ESTM_SETTLE_RATE" style="width:55%;text-align: right;background-color: #f6f6f6;border: 0px;"  size="6" readonly value="<%=SepoaMath.SepoaNumberType(conf_rate, "###.##")%>">&nbsp;%
										</td>
										<td id="tech_dq_3" class="data_td"  style=" display: none;">
											B - C = <input type="text" name="BC" size="12" readonly style="text-align: right;background-color: #f6f6f6;border: 0px;">
											&nbsp;
											(<input type="text" name="BC_RATE" size="8" readonly style="text-align: right;background-color: #f6f6f6;border: 0px;">&nbsp;%)
										</td>
									</tr>
									<%
									if("SB".equals(BID_STATUS) ){
									%>
										<tr>
											<td colspan="4" height="1" bgcolor="#dedede"></td>
										</tr>
										<tr>
											<td class="title_td" style="text-align: center;">낙찰금액(C)</td>
											<td class="data_td">
												<input type="text" name="SETTLE_AMT" style="width:58%;text-align: right;background-color: #f6f6f6;border: 0px;"  readonly value="<%=SepoaMath.SepoaNumberType(conf_bid_amt, "###,###,###,###,###,###" )%>">
											</td>
											
											<%if ("TA".equals(CONT_TYPE2)) {	// TCO 입찰%>
												<td class="data_td" colspan="2">
													<table>
														<tr>
															<td class="title_td" width="20%">
																물품가격 :
																<input type="text" name="SETTLE_AMT1" style="width:30%;text-align: left;background-color: #f6f6f6;border: 0px;"  readonly value="<%=SepoaMath.SepoaNumberType(product_price, "###,###,###,###,###,###" )%>">
															</td>
															<td class="title_td" width="20%">
																유지보수 :
																<input type="text" name="SETTLE_AMT2" style="width:30%;text-align: left;background-color: #f6f6f6;border: 0px;"  readonly value="<%=SepoaMath.SepoaNumberType(maintenance_price, "###,###,###,###,###,###" )%>">
															</td>
														</tr>
													</table>
												</td>
											<%}else{%>
												<td class="data_td" colspan="2">
												</td>
											<%}%>
										</tr>
									<%
									}else{
									%>
										<tr>
											<td colspan="4">
												<input type="hidden" name="SETTLE_AMT" style="width:58%;text-align: right;background-color: #f6f6f6;border: 0px;"  readonly>
												<input type="hidden" name="FROM_LOWER_BND_AMT" id="FROM_LOWER_BND_AMT"  size="12" readonly style="text-align: right;background-color: #f6f6f6;border: 0px;">
												<input type="hidden" name="FROM_LOWER_BND" style="text-align: right;background-color: #f6f6f6;border: 0px;" size="5" readonly>
											</td>
										</tr>
									<%
									}
									%>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr id="tr_003" style=" display: none;">
										<td class="title_td" style="text-align: center;">차액보증보험금액</td>
										<td class="data_td">
											<input type="text" name="DIFF_AMT" style="width:58%;text-align: right;background-color: #f6f6f6;border: 0px;"  readonly value="<%=SepoaMath.SepoaNumberType(dblDiff01, "###,###,###,###,###,###" )%>">
										</td>
										<td class="data_td"><font color="red">* 차액 이행증권 제출</font></td>
										<td class="data_td"></td>
									</tr>
								<%
								}
								%>

							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
														
	</br>
	<%
	vendor_name = "";
	bid_cancel_yn = "";
	if (PROM_CRIT.equals("A")) {
		%>
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="3%" class="title_td" style="text-align: center">NO</td>
										<td width="9%" class="title_td" style="text-align: center">공급업체</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(1차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(2차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(3차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(4차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(5차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(6차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(7차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(8차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(9차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(10차)</td>
									</tr>
									
									<%
									for(int i = 0 ; i < wfList.getRowCount() ; i++){

										if("ADMIN".equals(menu_type)){
											vendor_name = wfList.getValue("VENDOR_NAME", i);
										}else{
											if( info.getSession("COMPANY_CODE").equals(wfList.getValue("VENDOR_CODE", i))){
												vendor_name = wfList.getValue("VENDOR_NAME", i);
											}else{
												vendor_name = "";
											}
										}
										%>
										
										<tr>
											<td colspan="4" height="1" bgcolor="#dedede"></td>
										</tr>
										<tr>
											<td class="data_td"><%=i+1 %></td>
											<td class="data_td"><%=vendor_name %></td>
											
											<%
											for(int j = 1 ; j <= 10 ; j++){
												
												bid_cancel_yn = wfList.getValue("BID_CANCEL_" + j, i);

												if("Y".equals(bid_cancel_yn)){
													bid_cancel_yn = "</br><font color='red'>(입찰취소)</font>";
												}else{
													bid_cancel_yn = "";
												}
														
												if( info.getSession("COMPANY_CODE").equals(wfList.getValue("VENDOR_CODE", i)) || "ADMIN".equals(menu_type) ){
													%>
													
													<td class="data_td" style="text-align: right;">
														<%=SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###") + bid_cancel_yn%>
													</td>
													
													<%
												}else{
													%>
													
													<td class="data_td" style="text-align: right;"></td>
													
													<%
												}

											}
											%>
										</tr>
										<%
									}
									%>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>

	<%
	}else if (PROM_CRIT.equals("D")) {
	%>
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="3%" class="title_td" style="text-align: center">NO</td>
										<td width="9%" class="title_td" style="text-align: center">공급업체</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(1차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(2차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(3차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(4차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(5차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(6차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(7차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(8차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(9차)</td>
										<td width="9%" class="title_td" style="text-align: center">입찰금액</br>(10차)</td>
									</tr>
									
									<%
									for(int i = 0 ; i < wfList.getRowCount() ; i++){

										if("ADMIN".equals(menu_type)){
											vendor_name = wfList.getValue("VENDOR_NAME", i);
										}else{
											if( info.getSession("COMPANY_CODE").equals(wfList.getValue("VENDOR_CODE", i))){
												vendor_name = wfList.getValue("VENDOR_NAME", i);
											}else{
												vendor_name = "";
											}
										}
										%>
										
										<tr>
											<td colspan="4" height="1" bgcolor="#dedede"></td>
										</tr>
										<tr>
											<td class="data_td"><%=i+1 %></td>
											<td class="data_td"><%=vendor_name %></td>
											
											<%
											for(int j = 1 ; j <= 10 ; j++){
												
												bid_cancel_yn = wfList.getValue("BID_CANCEL_" + j, i);

												if("Y".equals(bid_cancel_yn)){
													bid_cancel_yn = "</br><font color='red'>(입찰취소)</font>";
												}else{
													bid_cancel_yn = "";
												}
														
												if( info.getSession("COMPANY_CODE").equals(wfList.getValue("VENDOR_CODE", i)) || "ADMIN".equals(menu_type) ){
													%>
													
													<td class="data_td" style="text-align: right;">													    
														<%=SepoaMath.SepoaNumberType(wfList.getValue("PRODUCT_PRICE_" + j, i), "###,###,###,###,###,###,###")%></br>
														<%=SepoaMath.SepoaNumberType(wfList.getValue("MAINTENANCE_PRICE_" + j, i), "###,###,###,###,###,###,###")%></br>
														<%=SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###") + bid_cancel_yn%>
													</td>
													
													<%
												}else{
													%>
													
													<td class="data_td" style="text-align: right;"></td>
													
													<%
												}

											}
											%>
										</tr>
										<%
									}
									%>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	<%
	}
	%>


	<iframe id="Some" src="/sourcing/empty.htm"  width="0%" height="0" border=0 frameborder=0></iframe>
	</br>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" id="btnTable">
		<tr>
			<td height="30"></td>
			<td height="50" align=right>
				<table>
					<tr>
						<td><input type="button" style="height: 20px;" value="인 쇄" 		onclick="javascript:clipPrint()"></td>
						<td><input type="button" style="height: 20px;" value="내PC에저장" 	onclick="javascript:doHtmlSave()"></td>
						<td><input type="button" style="height: 20px;" value="닫 기" 		onclick="javascript:window.close()"></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>

</body>
</html>

