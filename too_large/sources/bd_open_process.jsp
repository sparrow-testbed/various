<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_016");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BD_016";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--  /t_system1/wise/vaatz_package/myserver/V1.0.0/wisedoc/kr/dt/bid/ebd_bd_ins1.jsp -->
<!--
Title:        FrameWork 적용 Sample화면(PROCESS_ID)  <p>
 Description:  개발자들에게 적용될 기본 Sample(조회) 작업 입니다.(현재 모듈명에 대한 간략한 내용 기술) <p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       DEV.Team 2 Senior Manager Song Ji Yong<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!-->
 
<%

	Configuration wiseCfg = new Configuration();
	//boolean useXecureFlag = wiseCfg.getBoolean("wise.UseXecure");

    String BID_NO        = JSPUtil.nullToEmpty(request.getParameter("BID_NO"));
    String BID_COUNT     = JSPUtil.nullToEmpty(request.getParameter("BID_COUNT"));
    String VOTE_COUNT    = JSPUtil.nullToEmpty(request.getParameter("VOTE_COUNT"));

    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");

    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간

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

// 인증 관련
    String CRYP_CERT            = "";
    String CERTV           = "";
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
    
    boolean estm_sign_result    = false;
 	
 	 

%> 
<%
    Object[] args = {BID_NO, BID_COUNT, "C"};

    WiseOut value = null;
    WiseRemote wr = null;
    String nickName = "p1016d";
    String MethodName = "getCompareDisplay";
    String conType = "CONNECTION";
    WiseFormater wf = null;

    //다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
    try {
        wr = new WiseRemote(nickName,conType,info);
        value = wr.lookup(MethodName,args);

        wf = new WiseFormater(value.result[0]);
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
        


// 2nd  =======================================================================
        wf = new WiseFormater(value.result[1]);

        CTRL_AMT_TEXT                = wf.getValue("CTRL_AMT_TEXT"         ,0);
        ESTM_PRICE                   = wf.getValue("ESTM_PRICE_ENC"       ,0);
        FINAL_ESTM_PRICE		 	 = wf.getValue("FINAL_ESTM_PRICE"     ,0);
        FINAL_ESTM_PRICE_ENC		 = wf.getValue("FINAL_ESTM_PRICE_ENC"     ,0);

        CERTV						 = wf.getValue("CERTV"                 ,0);
        ESTM_TIMESTAMP               = wf.getValue("TIMESTAMP"             ,0);
        ESTM_SIGN_CERT               = wf.getValue("SIGN_CERT"             ,0);
        BASIC_AMT               	 = wf.getValue("BASIC_AMT"             ,0);
        ESTM_USER_ID				 = wf.getValue("ESTM_USER_ID"          ,0);
        
        /* 2011.02.19 이대규 xecure 처리 부분 적용 */
        /*
    	if(useXecureFlag) {
	        // 예정가격 복호화
	        EnvelopeData envelope 	= null;
	       	String PASSWORD		 	= null;
	        envelope = new EnvelopeData(new XecureConfig());
	        
	  		PASSWORD = HOUSE_CODE+BID_NO+BID_COUNT+ESTM_USER_ID;
	        if(!"".equals(envelope.keKeyDeEnvelopeData(PASSWORD.getBytes(),FINAL_ESTM_PRICE_ENC))){
	        	estm_sign_result = true;
	        } 
	             	 
	        FINAL_ESTM_PRICE = envelope.keKeyDeEnvelopeData(PASSWORD.getBytes(),FINAL_ESTM_PRICE_ENC);
    	}
    	else {
			EncDec crypt = new EncDec();
    		FINAL_ESTM_PRICE = crypt.decrypt(FINAL_ESTM_PRICE_ENC);
			estm_sign_result = true;
    	}
*/
    }catch(StackOverflowError so){
    	    	
    }catch(Exception e) {   
        Logger.err.println(info.getSession("ID"),this,"e = " + e.getMessage());
        Logger.dev.println(e.getMessage());
    }finally{
        wr.Release();
    } // finally 끝
	
    // 기술점수, 가격점수, 합계점수
	String TECH_DQ_SIZE = String.valueOf(Double.parseDouble("".equals(TECH_DQ) ? "0" : TECH_DQ) > 0 ? "100" : "0");
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  --> 
<!-- 
<SCRIPT language=javascript src="/include/attestation/TSToolkitConfig.js"></script>
<SCRIPT language=javascript src="/include/attestation/TSToolkitObject.js"></script>
 -->
<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
<Script language="javascript">
<!--
	var rCnt = 0; //낙찰업체 인덱스

    var BID_NO      = "<%=BID_NO%>";
    var BID_COUNT   = "<%=BID_COUNT%>";
    var VOTE_COUNT  = "<%=VOTE_COUNT%>";
    var G_first_vendor_cnt = 0;
    var G_action_flag = "";

	var mode;
	var button_flag = false;

    var date_flag;
	var Current_Row;

    var current_date = "<%=current_date%>";
    var current_time = "<%=current_time%>";
 
    var thistime    = "<%=current_time%>".substring(0,2);
    var thisminute    = "<%=current_time%>".substring(2,4);



    function doSelect() {
    	mode = "getCompareDisplayDT";
		servletUrl = "/servlets/dt.bidd.ebd_pp_ins13";
		GridObj.SetParam("mode", mode);
		GridObj.SetParam("BID_NO", "<%=BID_NO%>");
		GridObj.SetParam("BID_COUNT", "<%=BID_COUNT%>");
		GridObj.SetParam("VOTE_COUNT", "<%=VOTE_COUNT%>");
		GridObj.SetParam("ANNOUNCE_FLAG", "<%=ANNOUNCE_FLAG%>");

		GridObj.bSendDataFuncDefaultValidate=false;
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
		GridObj.strHDClickAction="sortmulti";
    }
    
    function row_decode(){
        var insValue;
        for (k = 0; k < GridObj.getRowCount ; k++) {
            if ( GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_1_ENC ) != '' ){
                insValue = GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_1_ENC);
				insValue = DecryptValue(insValue,GD_GetCellValueIndex(GridObj,k, INDEX_CERTV_1 ));
                GD_SetCellValueIndex(GridObj,k , INDEX_BID_AMT_1, insValue);
            }
            if ( GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_2_ENC ) != '' ){
                insValue = GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_2_ENC);
				insValue = DecryptValue(insValue,GD_GetCellValueIndex(GridObj,k, INDEX_CERTV_2 ));
                GD_SetCellValueIndex(GridObj,k , INDEX_BID_AMT_2, insValue);
            }
            if ( GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_3_ENC ) != '' ){
                insValue = GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_3_ENC);
				insValue = DecryptValue(insValue,GD_GetCellValueIndex(GridObj,k, INDEX_CERTV_3 ));
                GD_SetCellValueIndex(GridObj,k , INDEX_BID_AMT_3, insValue);
            }
            if ( GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_4_ENC ) != '' ){
                insValue = GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_4_ENC);
				insValue = DecryptValue(insValue,GD_GetCellValueIndex(GridObj,k, INDEX_CERTV_4 ));
                GD_SetCellValueIndex(GridObj,k , INDEX_BID_AMT_4, insValue);
            }
            if ( GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_5_ENC ) != '' ){
                insValue = GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_5_ENC);
				insValue = DecryptValue(insValue,GD_GetCellValueIndex(GridObj,k, INDEX_CERTV_5 ));
                GD_SetCellValueIndex(GridObj,k , INDEX_BID_AMT_5, insValue);
            }
            if ( GD_GetCellValueIndex(GridObj,k, INDEX_VOTE_CNT_AMT_ENC ) != '' ){
                insValue = GD_GetCellValueIndex(GridObj,k, INDEX_VOTE_CNT_AMT_ENC);
				insValue = DecryptValue(insValue,GD_GetCellValueIndex(GridObj,k, INDEX_VOTE_CNT_CERTV ));
                GD_SetCellValueIndex(GridObj,k , INDEX_VOTE_CNT_AMT, insValue);
            }
        }
    }
    function row_decode33dd333(){
        var insValue;
        for (k = 0; k < GridObj.GetRowCount() ; k++) {

            if ( GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_1_ENC ) != '' ){
                insValue = GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_1_ENC);
                GD_SetCellValueIndex(GridObj,k , INDEX_BID_AMT_1, insValue);
            }
            if ( GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_2_ENC ) != '' ){
                insValue = GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_2_ENC);
                GD_SetCellValueIndex(GridObj,k , INDEX_BID_AMT_2, insValue);
            }
            if ( GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_3_ENC ) != '' ){
                insValue = GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_3_ENC);
                GD_SetCellValueIndex(GridObj,k , INDEX_BID_AMT_3, insValue);
            }
            if ( GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_4_ENC ) != '' ){
                insValue = GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_4_ENC);
                GD_SetCellValueIndex(GridObj,k , INDEX_BID_AMT_4, insValue);
            }
            if ( GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_5_ENC ) != '' ){
                insValue = GD_GetCellValueIndex(GridObj,k, INDEX_BID_AMT_5_ENC);
                GD_SetCellValueIndex(GridObj,k , INDEX_BID_AMT_5, insValue);
            }
            if ( GD_GetCellValueIndex(GridObj,k, INDEX_VOTE_CNT_AMT_ENC ) != '' ){
                insValue = GD_GetCellValueIndex(GridObj,k, INDEX_VOTE_CNT_AMT_ENC);
                GD_SetCellValueIndex(GridObj,k , INDEX_VOTE_CNT_AMT, insValue);
            }
        }
    }
	
	var excute_getCompareDisplayDT = false;
	function JavaCall(msg1, msg2, msg3, msg4, msg5) {

		if(msg1 == "doQuery") {
            if (mode == "getCompareDisplayDT") {
            	/*
            	if(GridObj.GetParam(0) == "0"){
            		alert(GridObj.GetMessage());
            		return;
            	}
            	*/	
            	/*
            	예비가격, 입찰금액 복호화는 조회시 서블릿에서 Xecure 전자봉투(패쓰워드) 방식 으로 검증
                estm_decode();
                vote_decode();
                row_decode();
                
                getFROM_LOWER_BND_AMT();

                if(GridObj.GetRowCount() > 0)
                    setPostData();                  // 최저 금액순으로 재정렬 및 낙찰업체 선정
				*/       
			 	if(!excute_getCompareDisplayDT){// 최초 조회시에만 실행			 		
			 		estm_decode();  			// 예정가격 셋팅      
			 		if(GridObj.GetRowCount() == 0){
			 			return;
			 		}    
					getFROM_LOWER_BND_AMT();	// 최저하한가 셋팅
				<%
					// 기술평가율이 있는 경우
					if(!"0".equals(TECH_DQ_SIZE)){
				%>			
						setAMT_DQ();				// 가격점수 계산
						setPriceScore();			// 가격점수 등록 후 기술점수+가격점수가 높은순으로 정렬
				<%
					} else {
				%>
						setOrder();					// 입찰가격이 낮은순으로 정렬, 최저 금액순으로 재정렬 및 낙찰업체 선정
				<%
					}
				%>
			 	} else {
                    var ctrl_amt = 0;
               	 	var settle_amt = 0;
                	var estm_price = 0;

                	ctrl_amt   = '<%=BASIC_AMT%>';
                	settle_amt = del_comma(GD_GetCellValueIndex(GridObj,0, INDEX_VOTE_CNT_AMT));
                	estm_price = del_comma(document.forms[0].ESTM_PRICE.value);

					//if(parseFloat(settle_amt)  <= parseFloat(estm_price)){
						document.forms[0].VENDOR_CODE.value = GD_GetCellValueIndex(GridObj,0, INDEX_T_VENDOR_CODE);
                    	document.forms[0].VENDOR_NAME.value = GD_GetCellValueIndex(GridObj,0, INDEX_VENDOR_NAME);
                    	document.forms[0].CEO_NAME_LOC.value = GD_GetCellValueIndex(GridObj,0, INDEX_CEO_NAME_LOC);
                    	document.forms[0].ADDRESS_LOC.value = GD_GetCellValueIndex(GridObj,0, INDEX_ADDRESS_LOC);
                    	document.forms[0].USER_NAME.value = GD_GetCellValueIndex(GridObj,0, INDEX_USER_NAME);
                    	document.forms[0].USER_MOBILE.value = GD_GetCellValueIndex(GridObj,0, INDEX_USER_MOBILE);
                    	document.forms[0].USER_EMAIL.value = GD_GetCellValueIndex(GridObj,0, INDEX_USER_EMAIL);
                    
                		document.forms[0].SETTLE_AMT.value        = add_comma(settle_amt, 2);
                		document.forms[0].CTRL_SETTLE_RATE.value  = RoundEx((settle_amt/ctrl_amt) * 100, 3);
                		document.forms[0].ESTM_SETTLE_RATE.value  = RoundEx((settle_amt/estm_price) * 100, 3);
                		document.forms[0].AC.value                = add_comma(ctrl_amt - settle_amt, 0);
                		document.forms[0].AC_RATE.value           = RoundEx((ctrl_amt - settle_amt) / ctrl_amt * 100, 3);
                		document.forms[0].BC.value                = add_comma(estm_price - settle_amt, 0);
                		document.forms[0].BC_RATE.value           = RoundEx((estm_price - settle_amt) / estm_price * 100, 3);
                	//}
			 	}		
				excute_getCompareDisplayDT = true;
			
            	//낙찰여부 선택
				if (GD_GetCellValueIndex(GridObj,0, INDEX_T_FLAG) == "SB") {
	            	GD_SetCellValueIndex(GridObj,0, INDEX_SETTLE_FLAG, "true&", "&");
	            }
            } else if(mode == "getReload") {
            	
                G_first_vendor_cnt = 0; // 다시 초기화 해야, 추첨시 사용할수 있다.

				for(i=0; i<GridObj.GetRowCount(); i++) {
                    if(GD_GetCellValueIndex(GridObj,i, INDEX_NO) == "1")
                        G_first_vendor_cnt++;
                }

                if(G_first_vendor_cnt == 1) {
                    document.forms[0].VENDOR_CODE.value = GD_GetCellValueIndex(GridObj,0, INDEX_T_VENDOR_CODE);
                    document.forms[0].VENDOR_NAME.value = GD_GetCellValueIndex(GridObj,0, INDEX_VENDOR_NAME);
                    document.forms[0].CEO_NAME_LOC.value = GD_GetCellValueIndex(GridObj,0, INDEX_CEO_NAME_LOC);
                    document.forms[0].ADDRESS_LOC.value = GD_GetCellValueIndex(GridObj,0, INDEX_ADDRESS_LOC);
                    document.forms[0].USER_NAME.value = GD_GetCellValueIndex(GridObj,0, INDEX_USER_NAME);
                    document.forms[0].USER_MOBILE.value = GD_GetCellValueIndex(GridObj,0, INDEX_USER_MOBILE);
                    document.forms[0].USER_EMAIL.value = GD_GetCellValueIndex(GridObj,0, INDEX_USER_EMAIL);
                }
				
                if(G_action_flag == "getRandomVendor")
                    document.forms[0].COMP_MARK.value = GD_GetParam(GridObj,0);

                var ctrl_amt = 0;
                var settle_amt = 0;
                var estm_price = 0;

                ctrl_amt   = '<%=BASIC_AMT%>';
                settle_amt = del_comma(GD_GetCellValueIndex(GridObj,0, INDEX_VOTE_CNT_AMT));
                estm_price = del_comma(document.forms[0].ESTM_PRICE.value);

                document.forms[0].SETTLE_AMT.value        = add_comma(settle_amt, 0);
                document.forms[0].CTRL_SETTLE_RATE.value  = fomatter((settle_amt/ctrl_amt) * 100, 2);
                document.forms[0].ESTM_SETTLE_RATE.value  = fomatter((settle_amt/estm_price) * 100, 2);
                document.forms[0].AC.value                = add_comma(ctrl_amt - settle_amt, 0);
                document.forms[0].AC_RATE.value           = fomatter((ctrl_amt - settle_amt) / ctrl_amt * 100, 2);
                document.forms[0].BC.value                = add_comma(estm_price - settle_amt, 0);
                document.forms[0].BC_RATE.value           = fomatter((estm_price - settle_amt) / estm_price * 100, 2);
            }
        } else if(msg1 == "doData") { // 전송
            if(mode == "doBidProcess") {
                alert(GD_GetParam(GridObj,0));
                location.href = "ebd_bd_lis13.jsp";
            } else if(mode == "doReBid") {
                alert(GD_GetParam(GridObj,0));
                location.href = "ebd_bd_lis13.jsp";
            } else if(mode == "getVendorDoData" || mode == "getRandomVendor") {
                if(mode == "getVendorDoData")
                    G_action_flag = "getVendorDoData";
                else
                    G_action_flag = "getRandomVendor";

				var random_res = GD_GetParam(GridObj,0);
                mode = "getReload";

                servletUrl = "/servlets/dt.bidd.ebd_pp_ins13";
                GridObj.SetParam("mode", mode);
                GridObj.SetParam("random_res", random_res);
                GridObj.bSendDataFuncDefaultValidate=false;
				GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
				GridObj.SendData(servletUrl);

            } else if(mode == "setPriceScore"){
            	doSelect();
            } else if(mode == "setOrder"){
            	var str = GridObj.GetParam(0);
            	var array = str.split(",");
            	var array2 ;
            	var curRow, oldRow;
            	var colums = new Array(
            						 //"NO"				    
				            		 "VENDOR_NAME"		    
				            		,"CEO_NAME_LOC"		    
				            		,"BID_AMT_1"			
				            		,"NE_ORDER_1"		    
				            		,"BID_AMT_2"			
				            		,"NE_ORDER_2"		    
				            		,"BID_AMT_3"			
				            		,"NE_ORDER_3"		    
				            		,"BID_AMT_4"			
				            		,"NE_ORDER_4"		    
				            		,"BID_AMT_5"			
				            		,"NE_ORDER_5"		    
				            		,"BID_AMT_6"			
				            		,"BID_AMT_7"			
				            		,"BID_AMT_8"			
				            		,"BID_AMT_9"			
				            		,"BID_AMT_10"		    
				            	  //,"T_VENDOR_CODE"		
				            		,"ADDRESS_LOC"		    
				            	   //,"T_FLAG"			    
				            		,"VOTE_CNT_AMT"		    
				            		,"USER_NAME"			
				            		,"USER_MOBILE"		    
				            		,"USER_EMAIL"		    
				            		,"BID_AMT_1_ENC"		
				            		,"BID_AMT_2_ENC"		
				            		,"BID_AMT_3_ENC"		
				            		,"BID_AMT_4_ENC"		
				            		,"BID_AMT_5_ENC"		
				            		,"BID_AMT_6_ENC"		
				            		,"BID_AMT_7_ENC"		
				            		,"BID_AMT_8_ENC"		
				            		,"BID_AMT_9_ENC"		
				            		,"BID_AMT_10_ENC"	    
				            		,"VOTE_CNT_AMT_ENC"	    
				            		,"CERTV_1"			    
				            		,"CERTV_2"			    
				            		,"CERTV_3"			    
				            		,"CERTV_4"			    
				            		,"CERTV_5"			    
				            		,"VOTE_CNT_CERTV"	    
				            		,"TECHNICAL_SCORE"	    
				            		,"PRICE_SCORE"		    
				            		,"TOTAL_SCORE"		    
				            		,"FINAL_ESTM_PRICE"	    
				            		,"FROM_LOWER_BND"	    
				            		,"BASIC_AMT"		
            	); 
            	
            	var t_vendor_code, no, t_flag;            	
            	for(var i=0; i<array.length; i++){
            		array2 			= array[i].split("-");//(순위-업체코드-낙찰/유찰)
            		no 				= array2[0];
            		t_vendor_code 	= array2[1];
            		t_flag 			= array2[2];
            		
            		GridObj.AddRow();
            		curRow = GridObj.GetRowCount()-1;
            		for(var x=0; x<GridObj.GetRowCount(); x++){
            			if(GridObj.GetCellValue("T_VENDOR_CODE", x) == t_vendor_code){
            				oldRow = x;
            				break;
            			}
            		}
            		GridObj.SetCellValue("SELECTED", curRow, "1");
            		for(var k=0; k<colums.length; k++){
            			GridObj.SetCellValue(colums[k], curRow, GridObj.GetCellValue(colums[k], oldRow));
            		}
            		GridObj.SetCellValue("NO"				, curRow, no);
            		GridObj.SetCellValue("T_VENDOR_CODE"	, curRow, t_vendor_code);
            		GridObj.SetCellValue("T_FLAG"			, curRow, t_flag);
            		GridObj.SetCellValue("T_FLAG"			, oldRow, "");
            	}
            	
            	// 기존꺼 삭제
            	for(var i=GridObj.GetRowCount()-1; i >=0; i--){
            		if(GridObj.GetCellValue("T_FLAG", i) == ""){
            			GridObj.DeleteRow(i);
            		}
            	}
            	
            	//낙찰여부 선택
				if (GD_GetCellValueIndex(GridObj,0, INDEX_T_FLAG) == "SB") {
	            	GD_SetCellValueIndex(GridObj,0, INDEX_SETTLE_FLAG, "true&", "&");
	            }
                            	
			<%
				// 낙찰하한가 선정방식일 경우 낙찰자를 예정가격과 낙찰하한가에 포함되는 업체를 선택함.
				// 동일한 가격은 랜덤 선택함.
				if (PROM_CRIT.equals("B")) {
			%>
	                var estm_price = parseFloat(del_comma(document.forms[0].ESTM_PRICE.value));
	                var from_lower_bnd = parseFloat(del_comma(document.forms[0].FROM_LOWER_BND_AMT.value));
	                
                	for(i=0; i<GridObj.GetRowCount(); i++) {
                		var vote_cnt_amt = parseFloat(del_comma(GD_GetCellValueIndex(GridObj, i, INDEX_VOTE_CNT_AMT)));
                		if (from_lower_bnd > vote_cnt_amt || vote_cnt_amt > estm_price) {
                			GD_SetCellValueIndex(GridObj, i, INDEX_SETTLE_FLAG, "false&", "&");
                			GD_SetCellValueIndex(GridObj, i, INDEX_T_FLAG, "NB");
                		} else {
                			GD_SetCellValueIndex(GridObj, i, INDEX_SETTLE_FLAG, "true&", "&");
                			GD_SetCellValueIndex(GridObj, i, INDEX_T_FLAG, "SB");                			
                			rCnt = i;
                			break;
                		}
                	}
			
                	// 낙찰업체가 없는 경우 최저가 입찰업체를 낙찰업체로 선정하여 업무를 진행함.
					if ( rCnt == 0 ) {
						GD_SetCellValueIndex(GridObj, rCnt, INDEX_SETTLE_FLAG, "true&", "&");
            			GD_SetCellValueIndex(GridObj, rCnt, INDEX_T_FLAG, "SB");
					}
            <%
				}
			%>
            	
				var ctrl_amt = 0;
               	var settle_amt = 0;
                var estm_price = 0;
				
                ctrl_amt   = '<%=BASIC_AMT%>';
                settle_amt = del_comma(GD_GetCellValueIndex(GridObj, rCnt, INDEX_VOTE_CNT_AMT));
                estm_price = del_comma(document.forms[0].ESTM_PRICE.value);
                	
				//if(parseFloat(settle_amt)  <= parseFloat(estm_price)){
					document.forms[0].VENDOR_CODE.value = GD_GetCellValueIndex(GridObj,rCnt, INDEX_T_VENDOR_CODE);
                   	document.forms[0].VENDOR_NAME.value = GD_GetCellValueIndex(GridObj,rCnt, INDEX_VENDOR_NAME);
                   	document.forms[0].CEO_NAME_LOC.value = GD_GetCellValueIndex(GridObj,rCnt, INDEX_CEO_NAME_LOC);
                   	document.forms[0].ADDRESS_LOC.value = GD_GetCellValueIndex(GridObj,rCnt, INDEX_ADDRESS_LOC);
                   	document.forms[0].USER_NAME.value = GD_GetCellValueIndex(GridObj,rCnt, INDEX_USER_NAME);
                   	document.forms[0].USER_MOBILE.value = GD_GetCellValueIndex(GridObj,rCnt, INDEX_USER_MOBILE);
                   	document.forms[0].USER_EMAIL.value = GD_GetCellValueIndex(GridObj,rCnt, INDEX_USER_EMAIL);
                   
                	document.forms[0].SETTLE_AMT.value        = add_comma(settle_amt, 2);
                	document.forms[0].CTRL_SETTLE_RATE.value  = RoundEx((settle_amt/ctrl_amt) * 100, 3);
                	document.forms[0].ESTM_SETTLE_RATE.value  = RoundEx((settle_amt/estm_price) * 100, 3);
                	document.forms[0].AC.value                = add_comma(ctrl_amt - settle_amt, 0);
                	document.forms[0].AC_RATE.value           = RoundEx((ctrl_amt - settle_amt) / ctrl_amt * 100, 3);
                	document.forms[0].BC.value                = add_comma(estm_price - settle_amt, 0);
                	document.forms[0].BC_RATE.value           = RoundEx((estm_price - settle_amt) / estm_price * 100, 3);
            	//}
            }
		} else if(msg1 == "t_imagetext") {

	    } else if(msg1 == "t_header") {

		} else if(msg1 == "t_insert") {
            if(msg3 == INDEX_SETTLE_FLAG) {
                for(i=0; i<GridObj.GetRowCount(); i++) {
                    if("true" == GD_GetCellValueIndex(GridObj,i, INDEX_SETTLE_FLAG)) {
                    	//alert(i + ", " + msg2);
                        if(i != msg2) {
                            GD_SetCellValueIndex(GridObj,i, INDEX_SETTLE_FLAG, "false&", "&");
                        	GridObj.SetCellValue("T_FLAG", i, "NB");
                        } else {
                        	GridObj.SetCellValue("T_FLAG", i, "SB");
                        }
                    } else if ("false" == GD_GetCellValueIndex(GridObj,i, INDEX_SETTLE_FLAG)) {
                    	if(i == msg2) {
                    		GD_SetCellValueIndex(GridObj,i, INDEX_SETTLE_FLAG, "true&", "&");
                    	}
                    }
                }
                
                var ctrl_amt = 0;
               	var settle_amt = 0;
                var estm_price = 0;

                ctrl_amt   = '<%=BASIC_AMT%>';
                settle_amt = del_comma(GD_GetCellValueIndex(GridObj,msg2, INDEX_VOTE_CNT_AMT));
                estm_price = del_comma(document.forms[0].ESTM_PRICE.value);

                //if(parseFloat(settle_amt)  <= parseFloat(estm_price)){
					document.forms[0].VENDOR_CODE.value = GD_GetCellValueIndex(GridObj,msg2, INDEX_T_VENDOR_CODE);
                   	document.forms[0].VENDOR_NAME.value = GD_GetCellValueIndex(GridObj,msg2, INDEX_VENDOR_NAME);
                   	document.forms[0].CEO_NAME_LOC.value = GD_GetCellValueIndex(GridObj,msg2, INDEX_CEO_NAME_LOC);
                   	document.forms[0].ADDRESS_LOC.value = GD_GetCellValueIndex(GridObj,msg2, INDEX_ADDRESS_LOC);
                   	document.forms[0].USER_NAME.value = GD_GetCellValueIndex(GridObj,msg2, INDEX_USER_NAME);
                   	document.forms[0].USER_MOBILE.value = GD_GetCellValueIndex(GridObj,msg2, INDEX_USER_MOBILE);
                   	document.forms[0].USER_EMAIL.value = GD_GetCellValueIndex(GridObj,msg2, INDEX_USER_EMAIL);
                    
                	document.forms[0].SETTLE_AMT.value        = add_comma(settle_amt, 2);
                	document.forms[0].CTRL_SETTLE_RATE.value  = RoundEx((settle_amt/ctrl_amt) * 100, 3);
                	document.forms[0].ESTM_SETTLE_RATE.value  = RoundEx((settle_amt/estm_price) * 100, 3);
                	document.forms[0].AC.value                = add_comma(ctrl_amt - settle_amt, 0);
                	document.forms[0].AC_RATE.value           = RoundEx((ctrl_amt - settle_amt) / ctrl_amt * 100, 3);
                	document.forms[0].BC.value                = add_comma(estm_price - settle_amt, 0);
                	document.forms[0].BC_RATE.value           = RoundEx((estm_price - settle_amt) / estm_price * 100, 3);
            	//}
            }
        }
	}

	function POPUP_Open(url, title, left, top, width, height) {
        var toolbar = 'no';
        var menubar = 'no';
        var status = 'no';
        var scrollbars = 'yes';
        var resizable = 'no';
        var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
        code_search.focus();
	}

    function checkData() {

		rowcount = GridObj.GetRowCount();

		checked_count = 0;
		for(row = rowcount - 1; row >= 0; row--) {
                checked_count++;
	    }

        if(checked_count == 0) {
            alert("선택된 건이 없습니다.");
            return;
        }

		return true;
    }

    function doRandom() {

        if(document.forms[0].COMP_MARK.value == "1") {
            alert("이미 추첨을 하셨습니다.");
            return;
        }

        if(G_first_vendor_cnt == 1) {
            //alert("동가업체가 없음으로 추첨하실 수 없습니다.");
            //return;
        }

		rowcount = GridObj.GetRowCount();
        if(rowcount == 0) {
            alert("입찰가를 제출한 업체가 없습니다.\n\n유찰 하세요.");
            return;
        }

        var Message = "추첨 하시겠습니까?";

        if(confirm(Message) == 1){
            mode = "getRandomVendor";

            servletUrl = "/servlets/dt.bidd.ebd_pp_ins13";

            GridObj.SetParam("mode", mode);
	        GridObj.SetParam("FROM_LOWER_BND", del_comma(document.forms[0].FROM_LOWER_BND_AMT.value));

            GridObj.SetParam("BID_NO", "<%=BID_NO%>");
            GridObj.SetParam("BID_COUNT", "<%=BID_COUNT%>");
            GridObj.SetParam("VOTE_COUNT", "<%=VOTE_COUNT%>");

            GridObj.bSendDataFuncDefaultValidate=false;
			GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
			GridObj.SendData(servletUrl, "ALL", "ALL"); // doData 로 보내서 재구성하게끔 한다.
        }
    }

    function setCancelText(){
    	url =  "/kr/dt/bidd/ebd_pp_ins20.jsp";
	    window.open( url , "ebd_pp_ins20","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=no,resizable=no,width=680,height=360,left=0,top=0");
    }

    function doBidProcess(flag) {
		// SB : 낙찰
		// 아직 미정.....
		// 기존 ==> PB : 우선협상자지정(낙찰 + 유찰 : 선정은 되지만 구매접수현황으로 넘겨서 다시 입찰을 태운다.)
		// 변경 ==> PB : 우선협상자지정(낙찰 + 유찰 : 선정은 되지만 협상결과에서 최종적으로 금액을 조정한다.)
		// NB:유찰
        var Message = "";
        var rowcount = GridObj.GetRowCount();

        if(flag == "SB" || flag == "PB") {
            rowcount = GridObj.GetRowCount();
            if(rowcount == 0) {
                alert("입찰가를 제출한 업체가 없습니다.\n\n유찰 하세요.");
                return;
            }
        }

        if(flag == "SB" || flag == "PB") { // '낙찰', '우선협상선정'일 경우에...
            if(LRTrim(document.forms[0].VENDOR_CODE.value) == "") {
                alert("낙찰할 업체가 없습니다.\n\n낙찰하실 수 없습니다.");
                return;
            }

            var ESTM_PRICE = parseFloat(del_comma(document.forms[0].ESTM_PRICE.value));
            var SETTLE_AMT = parseFloat(del_comma(document.forms[0].SETTLE_AMT.value));

            if(ESTM_PRICE < SETTLE_AMT) {
                alert("낙찰금액이 내정가격보다 클 수는 없습니다.");
                return;
            }

            var FROM_LOWER_BND_AMT = parseFloat(del_comma(document.forms[0].FROM_LOWER_BND_AMT.value));
            if(FROM_LOWER_BND_AMT > SETTLE_AMT) {
                alert("낙찰금액이 최저하한가보다 작을 수는 없습니다.");
                return;
            }
            //0번째가 낙찰이 아닌경우 낙찰여부 변경으로 간주하여 낙찰여부 입력 하도록 수정
            if(GD_GetCellValueIndex(GridObj,rCnt, INDEX_T_FLAG) != "SB" && document.forms[0].SB_REASON.value == "") {
            	if (!confirm("낙찰업체를 변경할 경우 낙찰업체 변경사유를 입력해야 합니다.\n\n낙찰업체를 변경하시겠습니까?")) {
            		return;
            	}
            	var url = "ebd_pp_ins17.jsp";
                window.open( url , "ebd_pp_ins17","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=600,height=220,left=0,top=0");
                return;
            }
			
			if(flag == "SB" ){
				Message = "낙찰 하시겠습니까?";
			}else {
				Message = "우선협상 대상자로 선정할 경우 선정 후 선정업체로 다시 입찰을 진행하셔야 합니다.\n\n우선협상 대상자로 선정하시겠습니까?";
			}
			
            if(rowcount == 1) {
                //단독입찰도 낙찰할 수 있게.......
                Message = "단독 입찰입니다.\n\n진행하시겠습니까?";
            }

        } else { // '유찰'일 경우에...
            Message = "유찰 하시겠습니까?";
        }

        if(confirm(Message) == 1){

            if(flag == "NB") {
                for (var row = 0; row < rowcount; row++) {
                    if ("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
                        GD_SetCellValueIndex(GridObj,row, INDEX_T_FLAG, "NB");
                    }
                }
            }

            mode = "doBidProcess";
            servletUrl = "/servlets/dt.bidd.ebd_pp_ins13";
            GridObj.SetParam("mode", mode);
  	      	GridObj.SetParam("FROM_LOWER_BND", del_comma(document.forms[0].FROM_LOWER_BND_AMT.value));
            GridObj.SetParam("BID_NO", "<%=BID_NO%>");
            GridObj.SetParam("BID_COUNT", "<%=BID_COUNT%>");
            GridObj.SetParam("VOTE_COUNT", "<%=VOTE_COUNT%>");
            GridObj.SetParam("PR_NO", "<%=PR_NO%>");
            GridObj.SetParam("ESTM_PRICE", del_comma(document.forms[0].ESTM_PRICE.value));
			GridObj.SetParam("NB_REASON", document.form1.cancle_text.value);
			GridObj.SetParam("FLAG", flag); //낙찰:SB, 유찰:NB, 우선협상선정 : PB
            GridObj.SetParam("VENDOR_CODE", document.forms[0].VENDOR_CODE.value);
            GridObj.SetParam("SR_ATTACH_NO",   document.forms[0].sr_attach_no.value);
			GridObj.SetParam("SB_REASON", document.form1.SB_REASON.value);
            
            GridObj.bSendDataFuncDefaultValidate=false;
			GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
			GridObj.SendData(servletUrl, "ALL", "ALL");
        }
    }

    function doReBid() {
        if(parseInt("<%=VOTE_COUNT%>") >= 5) {
            alert("재입찰은 5차까지만 할 수 있습니다.");
            return;
        }

		rowcount = GridObj.GetRowCount();
        if(rowcount == 0) {
            alert("입찰가를 제출한 업체가 없습니다.\n\n유찰 하세요.");
            return;
        }
        
        if(rowcount == 1) {
            if(confirm("단독 입찰입니다.\n\n재입찰을 하시겠습니까?")){
				var BID_NO = "<%=BID_NO%>";
				var BID_COUNT = "<%=BID_COUNT%>";
				var VOTE_COUNT = "<%=VOTE_COUNT%>";

                var url = "ebd_pp_ins7.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&VOTE_COUNT="+VOTE_COUNT+"&TITLE=재입찰일시등록";
                window.open( url , "ebd_pp_ins7","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=800,height=300,left=0,top=0");
            }
        } else {
            Message = "재입찰 하시겠습니까?";
            if(confirm(Message) == 1){
                var BID_NO = "<%=BID_NO%>";
                var BID_COUNT = "<%=BID_COUNT%>";
                var VOTE_COUNT = "<%=VOTE_COUNT%>";

                var url = "ebd_pp_ins7.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&VOTE_COUNT="+VOTE_COUNT+"&TITLE=재입찰일시등록";
                window.open( url , "ebd_pp_ins7","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=800,height=300,left=0,top=0");
            }
        }
        return;
    }

    function setDecision(BID_BEGIN_DATE, BID_BEGIN_TIME, BID_END_DATE, BID_END_TIME, OPEN_DATE, OPEN_TIME) {
        mode = "doReBid";

        servletUrl = "/servlets/dt.bidd.ebd_pp_ins13";

        GridObj.SetParam("mode", mode);
        GridObj.SetParam("FROM_LOWER_BND", del_comma(document.forms[0].FROM_LOWER_BND_AMT.value));

        GridObj.SetParam("BID_NO", "<%=BID_NO%>");
        GridObj.SetParam("BID_COUNT", "<%=BID_COUNT%>");
        GridObj.SetParam("VOTE_COUNT", "<%=VOTE_COUNT%>");        
        GridObj.SetParam("CONT_TYPE1", "<%=CONT_TYPE1%>");

        GridObj.SetParam("BID_BEGIN_DATE",   BID_BEGIN_DATE);
        GridObj.SetParam("BID_BEGIN_TIME",   BID_BEGIN_TIME);
        GridObj.SetParam("BID_END_DATE",     BID_END_DATE);
        GridObj.SetParam("BID_END_TIME",     BID_END_TIME);
        GridObj.SetParam("OPEN_DATE",        OPEN_DATE);
        GridObj.SetParam("OPEN_TIME",        OPEN_TIME);


        GridObj.bSendDataFuncDefaultValidate=false;
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
    }
	/*
    function estm_decode() {    //예정가격 복호화
        document.forms[0].H_ESTM_PRICE.value 	= add_comma( DecryptValue("<%=ESTM_PRICE%>","<%=CERTV%>"), 0);
        document.forms[0].ESTM_PRICE.value    	= add_comma( DecryptValue("<%=ESTM_PRICE%>","<%=CERTV%>"), 0);

		//document.forms[0].H_ESTM_PRICE.value 	= add_comma( "<%=ESTM_PRICE%>", 0);
		//document.forms[0].ESTM_PRICE.value   	= add_comma( "<%=ESTM_PRICE%>", 0);
        document.forms[0].BASIC_AMT.value    	= add_comma("<%=BASIC_AMT%>", 0);
    }
	*/

    function estm_decode() {    //예정가격 복호화
        document.forms[0].H_ESTM_PRICE.value 	= add_comma("<%=FINAL_ESTM_PRICE%>",2);
        document.forms[0].ESTM_PRICE.value    	= add_comma("<%=FINAL_ESTM_PRICE%>",2);
        document.forms[0].BASIC_AMT.value    	= add_comma("<%=BASIC_AMT%>", 2);
    }
	
    function vote_decode() {    //입찰금액 복호화
	/*
        var rowcount = GridObj.GetRowCount();

        for(row = 0; row < rowcount; row++) {
            if (GD_GetCellValueIndex(GridObj,row, INDEX_VALID_CERT) != "Y") continue;

            var vote_amt = GD_GetCellValueIndex(GridObj,row, INDEX_VOTE_CNT_AMT);

            GD_SetCellValueIndex(GridObj,row, eval("INDEX_BID_AMT_<%=VOTE_COUNT%>"),  vote_amt);
            GD_SetCellValueIndex(GridObj,row, INDEX_VOTE_CNT_AMT,  vote_amt);
            GD_SetCellValueIndex(GridObj,row, INDEX_VALID_ENC,  "Y");
        }
	*/
    }

    function setPostData() {

        var vendor_code = "";
        var min = 99999999999;
        var tmp_arr = new Array(GridObj.GetRowCount());

        for (var i = 0; i < tmp_arr.length ;i++ )
        {
            tmp_arr[i] = GD_GetCellValueIndex(GridObj,i, INDEX_VOTE_CNT_AMT);
            var tmp = tmp_arr[i];

            if (parseFloat(tmp) < parseFloat(min)){
                min = tmp;
                vendor_code = GD_GetCellValueIndex(GridObj,i, INDEX_T_VENDOR_CODE);
            }
        }

        var cnt_vendor = 0;
        for (var i = 0; i < GridObj.GetRowCount() ;i++ )
        {
            if(parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_VOTE_CNT_AMT)) == parseFloat(min)) {
                cnt_vendor++;
            }
        }

        mode = "getVendorDoData";

        servletUrl = "/servlets/dt.bidd.ebd_pp_ins13";

        GridObj.SetParam("mode", mode);
        GridObj.SetParam("FROM_LOWER_BND", del_comma(document.forms[0].FROM_LOWER_BND_AMT.value));

        GridObj.SetParam("BID_NO", "<%=BID_NO%>");
        GridObj.SetParam("BID_COUNT", "<%=BID_COUNT%>");
        GridObj.SetParam("VOTE_COUNT", "<%=VOTE_COUNT%>");
        GridObj.SetParam("SAME_CNT", cnt_vendor);
        GridObj.SetParam("MIN_AMT", min);

        GridObj.bSendDataFuncDefaultValidate=false;
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL"); // doData 로 보내서 재구성하게끔 한다.

    }

    /*
	function getFROM_LOWER_BND_AMT(){

		var ESTM_PRICE = parseFloat(del_comma(document.forms[0].ESTM_PRICE.value));
		var FROM_LOWER_BND = parseFloat("<%=FROM_LOWER_BND%>");
		var FROM_LOWER_BND_AMT = ((ESTM_PRICE * FROM_LOWER_BND)/100)

        document.forms[0].FROM_LOWER_BND_AMT.value  = add_comma(FROM_LOWER_BND_AMT, 0);
        document.forms[0].FROM_LOWER_BND.value    	= FROM_LOWER_BND;
	}
	*/

	function getFROM_LOWER_BND_AMT(){

		var FINAL_ESTM_PRICE	= parseFloat(GridObj.GetCellValue("FINAL_ESTM_PRICE", 0));
		var FROM_LOWER_BND 		= parseFloat(GridObj.GetCellValue("FROM_LOWER_BND", 0));
		var FROM_LOWER_BND_AMT 	= ((FINAL_ESTM_PRICE * FROM_LOWER_BND)/100)

        document.forms[0].FROM_LOWER_BND_AMT.value  = add_comma(FROM_LOWER_BND_AMT, 2);
        document.forms[0].FROM_LOWER_BND.value    	= add_comma(FROM_LOWER_BND, 2);
	}
	
	/**
	 * 가격 및 기술점수 세팅
	 */
	function setAMT_DQ()
	{
		var BID_EVAL_SCORE 	= parseFloat("<%="".equals(BID_EVAL_SCORE) ? "1" :  BID_EVAL_SCORE%>");	// 공고작성시 평가배점
		var AMT_DQ 			= parseFloat("<%="".equals(AMT_DQ) ? "1" :  AMT_DQ%>");					// 공고작성시 가격점수 비율
		var minBidAmt = ""; //최저입찰가
		var cnt =0;
		for(var i=0; i<GridObj.GetRowCount(); i++){
			cnt =0;
			for(var k=0; k<GridObj.GetRowCount(); k++){
				if(parseFloat(GridObj.GetCellValue("VOTE_CNT_AMT", i)) <= parseFloat(GridObj.GetCellValue("VOTE_CNT_AMT", k))){
					cnt++;
				}
			}
			
			if(cnt == GridObj.GetRowCount()){
				minBidAmt = GridObj.GetCellValue("VOTE_CNT_AMT", i);
				break;
			}
		}

		for(var i=0; i<GridObj.GetRowCount(); i++){
			var VOTE_CNT_AMT 	= parseFloat(GridObj.GetCellValue("VOTE_CNT_AMT", i));
			var TECHNICAL_SCORE = parseFloat(GridObj.GetCellValue("TECHNICAL_SCORE", i) == "" ? "0" : GridObj.GetCellValue("TECHNICAL_SCORE", i));
			//var PRICE_SCORE  	= RoundEx(minBidAmt/VOTE_CNT_AMT*AMT_DQ, 3); 			
			//var PRICE_SCORE  	= RoundEx(calulatePriceScore(AMT_DQ, minBidAmt, VOTE_CNT_AMT, "<//%=FINAL_ESTM_PRICE%>"), 5) * BID_EVAL_SCORE;			
			var PRICE_SCORE  	= RoundEx(calulatePriceScore(AMT_DQ * BID_EVAL_SCORE, minBidAmt, VOTE_CNT_AMT, "<%=FINAL_ESTM_PRICE%>"), 5);
			var TOTAL_SCORE		= TECHNICAL_SCORE + PRICE_SCORE;
			GridObj.SetCellValue("PRICE_SCORE", i, PRICE_SCORE);
			GridObj.SetCellValue("TOTAL_SCORE", i, TOTAL_SCORE);
			//alert('가격점수 ==> ' + PRICE_SCORE + ", 총점수 ==> " + TOTAL_SCORE);
		}		
	}
	
	// 입찰시스템의 가격점수 산정 방식
	// 가격평가 배점한도, 최저입찰가격, 당해입찰가격, 예정가격
	function calulatePriceScore(AMT_DQ, minBidAmt, VOTE_CNT_AMT, ESTM_PRICE)
	{
		/**
			입찰시스템 입찰가격 평점산식
			가) 입찰가격을 추정가격의 100분의 80 이상으로 입찰한 자에 대한 평가
				평점 = 가격평가 배점한도 * (최저입찰가격/당해입찰가격)
				
				- 최저입찰가격 : 유효한 입찰자중 최저입찰가격
				- 당해입찰가격 : 당해 평가대상자의 입찰가격
				- 입찰가격 평가 시 사업예산으로 하는 경우에는 추정가격에 부가가치세를 포함하여 적용하고, 예정가격을 작성한 경우에는 추정가격을 예정가격으로 적용
				
			나) 입찰가격을 추정가격의 100분의 80 미만으로 입찰한 자에 대한 평가
				평점 = 입찰가격이 추정가격의 80%일 경우의 평점 + (2 * (   추정가격의 80% 상당가격 - 당해입찰가격   / 추정가격의 80% 상당가격 - 추정가격의 60% 상당가격     ))
				
				- 최저입찰가격 : 유효한 입찰자중 최저입찰가격
				- 당해입찰가격 : 당해 평가대상자의 입찰가격으로 하되, 입찰가격이 추정가격의 100분의 60미만일 경우에는 100분의 60으로 계산
				- 입찰가격 평가 시 사업예산으로 하는 경우에는 추정가격에 부가가치세를 포함하여 적용하고, 예정가격을 작성한 경우에는 추정가격을 예정가격으로 적용	
			
			다) 입찰가격을 추정가격의 100분의 60 미만으로 입찰한 자에 대한 평가
				평점 = 가격평가 배점한도 * 60/100
				
			라) 입찰가격 평점산식에 의한 계산결과 소수점이하의 숫자가 있는 경우에는 소수점 다섯째자리에서 반올림함.	
		*/  
		AMT_DQ			= AMT_DQ 		== "" ? "0" : parseFloat(AMT_DQ); // 가격비율
		minBidAmt 		= minBidAmt 	== "" ? "0" : parseFloat(minBidAmt); // 최저입찰가격
		VOTE_CNT_AMT 	= VOTE_CNT_AMT 	== "" ? "0" : parseFloat(VOTE_CNT_AMT); // 공급사 입찰가격
		ESTM_PRICE		= ESTM_PRICE 	== "" ? "0" : parseFloat(ESTM_PRICE); // 추정가격
		
		//alert("AMT_DQ : " + AMT_DQ + ", minBidAmt : " + minBidAmt + ", VOTE_CNT_AMT : " + VOTE_CNT_AMT + ", ESTM_PRICE : " + ESTM_PRICE);
		var PRICE_SCORE ;		 
		var ESTM_PRICE_80_PCT 	= ESTM_PRICE * 80/100;				// 예정가격의 100분의 80
		var ESTM_PRICE_60_PCT 	= ESTM_PRICE * 60/100;				// 예정가격의 100분의 60		
		
		//alert("ESTM_PRICE_80_PCT : " + ESTM_PRICE_80_PCT + ", ESTM_PRICE_60_PCT : " + ESTM_PRICE_60_PCT);
		if(VOTE_CNT_AMT < ESTM_PRICE_60_PCT){ // 입찰가격이 예정가격의 60 미만인 경우 : 가격점수 = 예정가격 * 0.6
			PRICE_SCORE = AMT_DQ * 0.6;
		} else {
			if(VOTE_CNT_AMT >= ESTM_PRICE_80_PCT){	// 입찰가격이 예정가격의 80이상인 경우
				PRICE_SCORE = AMT_DQ * minBidAmt / VOTE_CNT_AMT;
			}else {	
				PRICE_SCORE = AMT_DQ * minBidAmt / ESTM_PRICE_80_PCT + (2 * ((ESTM_PRICE_80_PCT - VOTE_CNT_AMT) / (ESTM_PRICE_80_PCT - ESTM_PRICE_60_PCT)));			
			}	
		}
		//alert("PRICE_SCORE : " + PRICE_SCORE);
		return PRICE_SCORE;
	}
	
	function setPriceScore(){
		//가격점수를 등록후 제안점수+가격점수로 순위를 매겨서 다시 조회.
		mode = "setPriceScore";
        servletUrl = "/servlets/dt.bidd.ebd_pp_ins13";

        GridObj.SetParam("mode", mode);
        GridObj.SetParam("BID_NO", "<%=BID_NO%>");
        GridObj.SetParam("BID_COUNT", "<%=BID_COUNT%>");
        GridObj.SetParam("VOTE_COUNT", "<%=VOTE_COUNT%>");
        
        GridObj.bSendDataFuncDefaultValidate=false;
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL"); 
		
	}
	
	function setOrder(){
		// 입찰금액이 낮은순으로 조회 같은금액이면 랜덤으로
		mode = "setOrder";

        servletUrl = "/servlets/dt.bidd.ebd_pp_ins13";

        GridObj.SetParam("mode", mode);
        GridObj.SetParam("BID_NO", "<%=BID_NO%>");
        GridObj.SetParam("BID_COUNT", "<%=BID_COUNT%>");
        GridObj.SetParam("VOTE_COUNT", "<%=VOTE_COUNT%>");
        
        GridObj.bSendDataFuncDefaultValidate=false;
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL"); 
	}
//-->
</Script>



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_open_process";


function init() {
	setGridDraw(); 
    <%--
    if(!estm_sign_result){
    %>
    	alert("예정가격이 변조되었습니다.");
    	return;
    <%
    }
    --%>
    //doQuery();
}
	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
   
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    
    return false;
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj)
{
    var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode");
    var status   = obj.getAttribute("status");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }

    if(status == "true") {
        alert(messsage);
        doQuery();
    } else {
        alert(messsage);
    }
    
    return false;
}

// 엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
// 복사한 데이터가 그리드에 Load 됩니다.
// !!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function doExcelUpload() {
    var bufferData = window.clipboardData.getData("Text");
    if(bufferData.length > 0) {
        GridObj.clearAll();
        GridObj.setCSVDelimiter("\t");
        GridObj.loadCSVString(bufferData);
    }
    return;
}

function doQuery() {

    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getBdOpenProcess";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);
}
function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    
    return true;
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작--> 
<form name="form1" >
<input type="hidden" name="VENDOR_CODE" value="<%=VENDOR_CODE%>">
<input type="hidden" name="COMP_MARK" value="">
<input type="hidden" name="CRYP_CERT" value="<%=CRYP_CERT%>">
<input type="hidden" name="cancle_text" value="">
<input type="hidden" name="sr_attach_no" value="">
<input type="hidden" name="SB_REASON" value="">

<input type="hidden" name="H_ESTM_PRICE" value="<%=ESTM_PRICE%>">

<%@ include file="/include/sepoa_milestone.jsp" %>
 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td height="5"> </td>
    </tr>
    <tr>
        <td width="100%" valign="top"><table width="100%" height="3" border="0" cellspacing="0" cellpadding="0" bgcolor="#629DD9"><tr><td></td></tr></table>
            <table width="100%" class="board-search" border="0" cellpadding="0" cellspacing="0">
                <colgroup>
                    <col width="15%" />
                    <col width="35%" />
                    <col width="15%" />
                    <col width="35%" />
                </colgroup>   
    <tr>
      <td width="15%" class="tit">공고번호</td>
      <td width="85%">&nbsp;
        <%=ANN_NO%>
      </td>
    </tr>
    <tr>
      <td width="15%" class="tit">입찰건명</td>
      <td width="85%">&nbsp;
        <%=ANN_ITEM%>
      </td>
    </tr>
    <tr>
      <td class="tit" width="15%">입찰방법</td>
      <td width="85%">&nbsp;
        <%=CONT_TYPE1_TEXT_D%>&nbsp;/&nbsp;<%=CONT_TYPE2_TEXT_D%>
      </td>
    </tr>
  </table>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td height="10"></td>
    </tr>
  </table>

  <table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
    <tr>
      <td width="15%" class="tit">공급업체</td>
      <td width="35%">&nbsp;
        <input type="text" name="VENDOR_NAME" value="<%=VENDOR_NAME%>" class="input_data2" style="width:90%;" readonly >
      </td>
      <td width="15%" class="tit">담당자명</td>
      <td width="35%">&nbsp;
        <input type="text" name="USER_NAME" value="<%=USER_NAME%>" class="input_data2" style="width:90%;" readonly >
      </td>
    </tr>
    <tr>
      <td width="15%" class="tit">대표자명</td>
      <td width="35%">&nbsp;
        <input type="text" name="CEO_NAME_LOC" value="<%=CEO_NAME_LOC%>" class="input_data1" style="width:90%;" readonly >
      </td>
      <td width="15%" class="tit">핸드폰번호</td>
      <td width="35%">&nbsp;
        <input type="text" name="USER_MOBILE" value="<%=USER_MOBILE%>" class="input_data1" style="width:90%;" readonly >
      </td>
    </tr>
    <tr>
      <td class="tit" width="15%">주소</td>
      <td width="35%">&nbsp;
        <input type="text" name="ADDRESS_LOC" value="<%=ADDRESS_LOC%>" class="input_data2" style="width:90%;" readonly >
      </td>
      <td class="tit" width="15%">EMAIL</td>
      <td width="35%">&nbsp;
        <input type="text" name="USER_EMAIL" value="<%=USER_EMAIL%>" class="input_data2" style="width:90%;" readonly >
      </td>
    </tr>
  </table>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td height="10"></td>
    </tr>
  </table>

  <table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
    <tr>
      <td width="15%" class="tit" style="text-align: center">구분</td>
      <td width="25%" class="tit" style="text-align: center">금액(VAT 별도)</td>
      <td width="20%" class="tit" style="text-align: center">낙찰가율</td>
      <td width="*"   class="tit" style="text-align: center">절감액 및 절감율</td>
    </tr>
    <tr>
      <td class="tit">예정가격(A)</td>
      <td>
        <input type="text" name="BASIC_AMT" style="width:90%;" value="<%=BASIC_AMT%>" class="input_data2_right" readonly>
      </td>
      <td>
        <input type="text" name="CTRL_SETTLE_RATE" style="width:80%;" class="input_data2_right" readonly >&nbsp;%
      </td>
      <td>
        A - C = <input type="text" name="AC" class="input_data1_right" size="12" readonly >&nbsp;
        (<input type="text" name="AC_RATE" class="input_data1_right" size="8" readonly >&nbsp;%)
      </td>
    </tr>
    <tr>
      <td class="tit">내정가격(B)</td>
      <td>
        <input type="text" name="ESTM_PRICE" style="width:90%;" class="input_data2_right" size="15" readonly>
      </td>
      <td>
        <input type="text" name="ESTM_SETTLE_RATE" style="width:80%;"  class="input_data2_right" size="6" readonly>&nbsp;%
      </td>
      <td>
        B - C = <input type="text" name="BC" class="input_data1_right" size="12" readonly>&nbsp;
        (<input type="text" name="BC_RATE" class="input_data1_right" size="8" readonly>&nbsp;%)
      </td>
    </tr>
    <tr>
      <td class="tit">낙찰금액(C)</td>
      <td>
        <input type="text" name="SETTLE_AMT" style="width:90%;"  class="input_data2_right" readonly>
      </td>
      <td></td>
      <td>
        	최저하한가 <input type="text" name="FROM_LOWER_BND_AMT" class="input_data1_right" size="12" readonly>&nbsp;
        	(<input type="text" name="FROM_LOWER_BND" class="input_data1_right" size="5" readonly>&nbsp;%)
      </td>
    </tr>
  </table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td height="30">
      </td>
      <td height="30" align=right>
		<table><tr>
			<td><script language="javascript">btn("javascript:doBidProcess('SB')",13,"낙 찰")</script></td>
			<td><script language="javascript">btn("javascript:doReBid()",28,"재입찰")</script></td>
			<td><script language="javascript">btn("javascript:setCancelText()",3,"유 찰")</script></td>
			<!--
			1. 우선협상선정 활성화시 구매접수목록 조회조건 변경
			        우선협상자는 선정처리는 진행하되, 구매접수목록에서 입찰을 다시 태우도록 한다.
			        입찰결과에서 협상결과를 등록하는 것으로 변경하는 방안 검토
			2. 구매품의대기현황
			=> 기존 : DT.PR_PROCEEDING_FLAG = 'P'
			=> 변경 : DT.PR_PROCEEDING_FLAG = 'P' OR (DT.PR_PROCEEDING_FLAG = 'E' AND DT.DT.PREFERRED_BIDDER = 'Y')
			-->
			<% if(CONT_TYPE2.equals("NE")){ //우선협상 일때 보여주도록 합니다.%>	
			<td><script language="javascript">btn("javascript:doBidProcess('PB')",29,"우선협상선정")</script></td>
			<% } %>
			<td><script language="javascript">btn("javascript:history.back(-1)",1,"취 소")</script></td>
		</tr></table>
      </td>
    </tr>
  </table>
 
<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</form>
 
</s:header>
<s:grid screen_id="BD_016" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>




