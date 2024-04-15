<%@page import="sepoa.svl.util.SepoaMessage"%>
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
	
	String ctrl_code = info.getSession("CTRL_CODE");

	String menu_type = "";
	if (ctrl_code.startsWith("P01") || ctrl_code.startsWith("P02")) {
		menu_type = "ADMIN";
	} else {
		menu_type = "NORMAL";
	}
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
    String PROM_CRIT_NAME		= "";

    String OPEN_DATE_TIME	= "";
    String BID_STATUS	= "";
    
    String VENDORS = "";
    String BID_INPUT_TYPE = "";
    
    boolean estm_sign_result    = false;
    
    Double 	last_bid_amt = 0.0;
    Double 	estm_bid_amt = 0.0;
    double  conf_bid_amt = 0.0;
    int		bidCVendor	 = 0;
    int		validVendor	 = 0;
    String  conf_rate	 = "";
    String  conf_rate2	 = "";

	Map< String, String >   map = new HashMap< String, String >();
	map.put("HOUSE_CODE"	, info.getSession("HOUSE_CODE"));
	map.put("BID_NO"		, BID_NO);
	map.put("BID_COUNT"		, BID_COUNT);
	map.put("VOTE_COUNT"	, VOTE_COUNT);
	map.put("FLAG"			, "C");

	Object[] obj = {map};
	SepoaOut value = ServiceConnector.doService(info, "BD_014", "CONNECTION","getBdHeaderCompare", obj);
	
	SepoaFormater wf 		= new SepoaFormater(value.result[0]); 
	SepoaFormater wfList 	= null; 

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
        
        VENDORS                      = wf.getValue("VENDORS"			   ,0);
        BID_INPUT_TYPE               = wf.getValue("BID_INPUT_TYPE"			   ,0);
        
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
	        SepoaOut value1 = ServiceConnector.doService(info, "BD_014", "CONNECTION", "getBidResult", obj);
	        wfList = new SepoaFormater(value1.result[0]);
	        
	        if(wfList.getRowCount() > 0){
	        	conf_bid_amt = wfList.getDouble("BID_AMT_" + VOTE_COUNT, 0);
		        if(conf_bid_amt > 0 && "SB".equals(BID_STATUS)){
		        	conf_rate  = conf_bid_amt / Double.parseDouble(FINAL_ESTM_PRICE) * 100 + "";
		        	conf_rate2 = conf_bid_amt / Double.parseDouble(BASIC_AMT) * 100 + "";
		        }
		        
		        if("SB".equals(wfList.getValue("BID_STATUS", 0))){
			        VENDOR_NAME	= wfList.getValue("VENDOR_NAME"	, 0);  

			        USER_MOBILE = wfList.getValue("USER_MOBILE"	, 0);
			        ADDRESS_LOC = wfList.getValue("ADDRESS_LOC"	, 0);
			        USER_EMAIL  = wfList.getValue("USER_EMAIL"	, 0);
			        CEO_NAME_LOC= wfList.getValue("CEO_NAME_LOC", 0);
			        USER_NAME   = wfList.getValue("USER_NAME"	, 0);
			        
			        if("S".equals(info.getSession("USER_TYPE")) ){
			        	USER_MOBILE = "****";
			        	ADDRESS_LOC = "****";
			        	USER_EMAIL  = "****";
			        	CEO_NAME_LOC= "****";
			        	USER_NAME   = "****";
			        }
		        }
	        }
	        
	        for(int i = 0 ; i < wfList.getRowCount() ; i++){
	        	
	        	if("D".equals(PROM_CRIT)){
		        	last_bid_amt = wfList.getDouble("PRODUCT_PRICE_" + VOTE_COUNT, i);
	        	}else{
		        	last_bid_amt = wfList.getDouble("BID_AMT_" + VOTE_COUNT, i);
	        	}

	        	try
	        	{
		        	estm_bid_amt = Double.parseDouble(Math.floor(Double.parseDouble(FINAL_ESTM_PRICE) * Double.parseDouble(FROM_LOWER_BND) / 100) + "");
		        	
		        	if(Double.parseDouble(FINAL_ESTM_PRICE) >= last_bid_amt && estm_bid_amt <= last_bid_amt && !"Y".equals(wfList.getValue("BID_CANCEL_" + VOTE_COUNT, i)) ){
		        		validVendor++;
		        	}

		        	if("Y".equals(wfList.getValue("BID_CANCEL_" + VOTE_COUNT, i)) ){
		        		bidCVendor++;
		        	}
		        	
	        	}catch(Exception e){
	        		
	        	}
	        }
        }
    } 
	
    // 기술점수, 가격점수, 합계점수
	String TECH_DQ_SIZE = String.valueOf(Double.parseDouble("".equals(TECH_DQ) ? "0" : TECH_DQ) > 0 ? "100" : "0");
    
	String vendor_name = "";
	String bid_cancel_yn = "";
    
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName = (PROM_CRIT.equals("A"))?"020644/rpt_bd_open_compare_pop_a":"020644/rpt_bd_open_compare_pop_b";         //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
    
	
	//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
	_rptData.append(ANN_NO);
	_rptData.append(_RF);
	_rptData.append(ANN_ITEM);
	_rptData.append(_RF);
	_rptData.append(CONT_TYPE1_TEXT_D);
	_rptData.append(" / ");
	_rptData.append(CONT_TYPE2_TEXT_D);
	_rptData.append(" / ");
	_rptData.append(PROM_CRIT_NAME);
	_rptData.append(_RF);
	_rptData.append(OPEN_DATE_TIME);
	
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
	
	_rptData.append(_RD);	
	
	if (PROM_CRIT.equals("A")){
		_rptData.append("예정가격(A)");
		_rptData.append(_RF);
		_rptData.append(SepoaMath.SepoaNumberType( BASIC_AMT, "###,###,###,###,###,###" ));
		_rptData.append(_RF);
		_rptData.append(SepoaMath.SepoaNumberType(conf_rate2, "###.##"));
		_rptData.append(_RL);
		_rptData.append("내정가격(B)");
		_rptData.append(_RF);
		_rptData.append(SepoaMath.SepoaNumberType( FINAL_ESTM_PRICE, "###,###,###,###,###,###" ));
		_rptData.append(_RF);
		_rptData.append(SepoaMath.SepoaNumberType(conf_rate, "###.##"));
		_rptData.append(_RL);
		if("SB".equals(BID_STATUS) ){
			_rptData.append("낙찰금액(C)");
			_rptData.append(_RF);
			_rptData.append(SepoaMath.SepoaNumberType(conf_bid_amt, "###,###,###,###,###,###" ));
			_rptData.append(_RF);			
		}
		
		_rptData.append(_RD);	
		
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
					_rptData.append(SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###"));	
					_rptData.append(bid_cancel_yn);	
				}
				_rptData.append(_RL);
			}
		}	
	}else if(PROM_CRIT.equals("B")){
		_rptData.append("예정가격");
		_rptData.append(_RF);
		_rptData.append(SepoaMath.SepoaNumberType( BASIC_AMT, "###,###,###,###,###,###" ));
		_rptData.append(_RF);
		_rptData.append(_RF);
		_rptData.append(_RL);
		_rptData.append("확정내정가격");
		_rptData.append(_RF);
		_rptData.append(SepoaMath.SepoaNumberType( FINAL_ESTM_PRICE, "###,###,###,###,###,###" ));
		_rptData.append(_RF);
		_rptData.append(_RF);
		_rptData.append("예비내정가격의 상하 2%범위내에서 전산 랜덤방식으로 10개를 자동 선정한 후 다시 전산 랜덤방식으로 5개를 선정하여 평균한 금액");
		_rptData.append(_RL);
		_rptData.append("(확정내정가격의 ");
		_rptData.append(FROM_LOWER_BND);
		_rptData.append("% 금액)");
		_rptData.append(_RF);
		_rptData.append(SepoaMath.SepoaNumberType(estm_bid_amt, "###,###,###,###,###,###" ));
		_rptData.append(_RF);
		_rptData.append(_RF);
		_rptData.append(_RL);
		_rptData.append("낙찰금액");
		_rptData.append(_RF);
		_rptData.append(SepoaMath.SepoaNumberType(conf_bid_amt, "###,###,###,###,###,###" ));
		_rptData.append(_RF);
		_rptData.append(SepoaMath.SepoaNumberType(conf_rate, "###.##"));
		_rptData.append(" %");
		_rptData.append(_RF);
		_rptData.append(_RL);
		_rptData.append("입찰업체수");
		_rptData.append(_RF);
		_rptData.append(wfList.getRowCount() - bidCVendor);
		_rptData.append(" 개 업체");
		_rptData.append(_RF);
		_rptData.append(_RF);
		_rptData.append(_RL);
		_rptData.append("유효입찰업체수");
		_rptData.append(_RF);
		_rptData.append(validVendor);
		_rptData.append(" 개 업체");
		_rptData.append(_RF);
		_rptData.append(_RF);
		
		_rptData.append(_RD);	
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
					_rptData.append(SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###"));	
					_rptData.append(bid_cancel_yn);	
				}
				_rptData.append(_RL);
				
				if((""+j).equals(VOTE_COUNT)){ 
					_rptData.append(i+1);	
					_rptData.append(_RF);						
					_rptData.append(vendor_name);	
					_rptData.append(_RF);	
					_rptData.append("비율<BR>(예정가격대비)"); 
					_rptData.append(_RF);
					if( info.getSession("COMPANY_CODE").equals(wfList.getValue("VENDOR_CODE", i)) || "ADMIN".equals(menu_type) ){
						_rptData.append(SepoaMath.SepoaNumberType((wfList.getDouble("BID_AMT_" + j, i)/Double.parseDouble(BASIC_AMT) * 100), "###.##"));	
						_rptData.append(" %");	
					}
					_rptData.append(_RL);
				} 
				
			}
		}	
		
	}
    
    
    
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

function PopupManager(VOTE_COUNT,VENDOR_CODE,VENDOR_NAME){
	var url  = '';
	var title  = '';
	var param  = '';
		
	url    = '/sourcing/bd_open_compare_vt_desc_pop.jsp';
	title  = '';
    param  = 'popup=Y';
    param  += '&bid_no=<%=BID_NO%>';
    param  += '&bid_count=<%=BID_COUNT%>';
    param  += '&vote_count=';
    param  += VOTE_COUNT;
    param  += '&vendor_code=';
    param  += VENDOR_CODE;
    param  += '&vendor_name=';
    param  += encodeUrl(VENDOR_NAME);
	popUpOpen01(url, title, '700', '550', param);
	
}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint() {
    var url = "/ClipReport4/ClipViewer.jsp";
	//url = url + "?BID_TYPE=" + bid_type;	
    var cwin = window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form1.method = "POST";
	document.form1.action = url;
	document.form1.target = "ClipReport4";
	document.form1.submit(); 
	cwin.focus();
}

</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" >

<!--내용시작--> 
<form id="form1" name="form1" >
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

<input type="hidden" name="H_ESTM_PRICE" value="<%=ESTM_PRICE%>">

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
      							<td width="15%" class="title_td">&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>&nbsp;&nbsp;공고번호</td>
      							<td width="85%" class="data_td">&nbsp;<%=ANN_NO%></td>
    						</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>     
    						<tr>
      							<td width="15%" class="title_td">&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>&nbsp;&nbsp;입찰건명</td>
      							<td width="85%" class="data_td">&nbsp;<%=ANN_ITEM%></td>
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr> 
    						<tr>
      							<td class="title_td" width="15%">&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>&nbsp;&nbsp;입찰방법</td>
      							<td width="85%" class="data_td">&nbsp;<%=CONT_TYPE1_TEXT_D%>&nbsp;/&nbsp;<%=CONT_TYPE2_TEXT_D%>&nbsp;/&nbsp;<%=PROM_CRIT_NAME %></td>
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr> 
    						<tr>
      							<td class="title_td" width="15%">&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>&nbsp;&nbsp;개찰일시</td>
      							<td width="85%" class="data_td">&nbsp;<%=OPEN_DATE_TIME %></td>
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
      							<td width="15%" class="title_td">&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>&nbsp;&nbsp;낙찰업체</td>
      							<td width="35%" class="data_td">&nbsp;
        							<input type="text" name="VENDOR_NAME" value="<%=VENDOR_NAME%>" style="width:90%;background-color: #f6f6f6;border: 0px;" readonly >
      							</td>
      							<td width="15%" class="title_td">&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>&nbsp;&nbsp;담당자명</td>
      							<td width="35%" class="data_td">&nbsp;
        							<input type="text" name="USER_NAME" value="<%=USER_NAME%>" style="width:90%;background-color: #f6f6f6;border: 0px;" readonly >
      							</td>
    						</tr>
    						<tr>
      							<td width="15%" class="title_td">&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>&nbsp;&nbsp;대표자명</td>
      							<td width="35%" class="data_td">&nbsp;
        							<input type="text" name="CEO_NAME_LOC" value="<%=CEO_NAME_LOC%>" style="width:90%;background-color: #f6f6f6;border: 0px;" readonly >
      							</td>
      							<td width="15%" class="title_td">&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>&nbsp;&nbsp;핸드폰번호</td>
      							<td width="35%" class="data_td">&nbsp;
        							<input type="text" name="USER_MOBILE" value="<%=USER_MOBILE%>" style="width:90%;background-color: #f6f6f6;border: 0px;" readonly >
      							</td>
    						</tr>
    						<tr>
      							<td class="title_td" width="15%">&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>&nbsp;&nbsp;주소</td>
      							<td width="35%" class="data_td">&nbsp;
        							<input type="text" name="ADDRESS_LOC" value="<%=ADDRESS_LOC%>" style="width:90%;background-color: #f6f6f6;border: 0px;" readonly >
      							</td>
      							<td class="title_td" width="15%">&nbsp;<img src='/images/blt_srch.gif' width='7' height='7' align='absmiddle'>&nbsp;&nbsp;EMAIL</td>
      							<td width="35%" class="data_td">&nbsp;
        							<input type="text" name="USER_EMAIL" value="<%=USER_EMAIL%>" style="width:90%;background-color: #f6f6f6;border: 0px;" readonly >
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
	if (PROM_CRIT.equals("A") || PROM_CRIT.equals("C") || PROM_CRIT.equals("D")){
%>
							<tr>
      							<td width="20%" class="title_td" style="text-align: center">구분</td>
						      	<td width="40%" class="title_td" style="text-align: center">금액(VAT 포함)</td>
						      	<td width="40%" class="title_td" style="text-align: center">낙찰가율</td>
						      	<td id="tech_dq_1" width="*"  class="title_td" style="text-align: center; display: none;">절감액 및 절감율</td>
    						</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>      
    						<tr>
      							<td class="title_td" style="text-align: center;">예정가격(A)</td>
      							<td class="data_td">
        							<input type="text" name="BASIC_AMT" style="width:58%;text-align: right;background-color: #f6f6f6;border: 0px;" value="<%= SepoaMath.SepoaNumberType( BASIC_AMT, "###,###,###,###,###,###" )%>" readonly>
      							</td>
      							<td class="data_td">
        							<input type="text" name="CTRL_SETTLE_RATE" style="width:55%; text-align: right;background-color: #f6f6f6;border: 0px;" readonly value="<%=SepoaMath.SepoaNumberType(conf_rate2, "###.##")%>">&nbsp;%
      							</td>
      							<td id="tech_dq_2" class="data_td" style=" display: none;">
        							A - C = <input type="text" name="AC" style="text-align: right;background-color: #f6f6f6;border: 0px;" size="12" readonly >&nbsp;
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
      							<td class="data_td">
        							<input type="text" name="ESTM_SETTLE_RATE" style="width:55%;text-align: right;background-color: #f6f6f6;border: 0px;"  size="6" readonly value="<%=SepoaMath.SepoaNumberType(conf_rate, "###.##")%>">&nbsp;%
      							</td>
      							<td id="tech_dq_3" class="data_td"  style=" display: none;">
        							B - C = <input type="text" name="BC" size="12" readonly style="text-align: right;background-color: #f6f6f6;border: 0px;">&nbsp;
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
      							<td class="data_td"></td>
      							<td id="tech_dq_4" class="data_td"  style=" display: none;">
        							최저하한가 <input type="text" name="FROM_LOWER_BND_AMT" id="FROM_LOWER_BND_AMT"  size="12" readonly style="text-align: right;background-color: #f6f6f6;border: 0px;"/>&nbsp;
        							(<input type="text" name="FROM_LOWER_BND" style="text-align: right;background-color: #f6f6f6;border: 0px;" size="5" readonly>&nbsp;%)
      							</td>
    						</tr>
<%	}else{	%>
        					<tr>
								<td>
	        						<input type="hidden" name="SETTLE_AMT" style="width:58%;text-align: right;background-color: #f6f6f6;border: 0px;"  readonly>
	    							<input type="hidden" name="FROM_LOWER_BND_AMT" id="FROM_LOWER_BND_AMT"  size="12" readonly style="text-align: right;background-color: #f6f6f6;border: 0px;">
    								<input type="hidden" name="FROM_LOWER_BND" style="text-align: right;background-color: #f6f6f6;border: 0px;" size="5" readonly>
								</td>        					
        					</tr>
<%  }	%>
    
<%		
	}else{
%>
							<tr>
      							<td width="15%" class="title_td" style="text-align: center">구분</td>
      							<td width="15%" class="title_td" style="text-align: center">금액(VAT 포함)</td>
      							<td width="20%" class="title_td" style="text-align: center">낙찰가율</br>(확정내정가격대비)</td>
      							<td width="*"   class="title_td" style="text-align: center;">비고</td>
    						</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>    
    						<tr>
      							<td class="title_td">예정가격</td>
      							<td class="data_td">
        							<input type="text" name="BASIC_AMT" style="width:90%;text-align: right;background-color: #f6f6f6;border: 0px;" value="<%=SepoaMath.SepoaNumberType( BASIC_AMT, "###,###,###,###,###,###" )%>" readonly>
      							</td>
      							<td class="data_td">
        							<input type="hidden" name="CTRL_SETTLE_RATE" style="width:80%; text-align: right;background-color: #f6f6f6;border: 0px;" readonly >&nbsp;
      							</td>
      							<td class="data_td" ></td>
    						</tr>  
    						<tr>
      							<td class="title_td">확정내정가격</td>
      							<td class="data_td">
        							<input type="text" name="ESTM_PRICE" id="ESTM_PRICE" style="width:90%;text-align: right;background-color: #f6f6f6;border: 0px;" size="15" readonly value="<%=SepoaMath.SepoaNumberType( FINAL_ESTM_PRICE, "###,###,###,###,###,###" )%>">
      							</td>
      							<td class="data_td">
        
      							</td>
      							<td class="data_td" >
      								예비내정가격의 상하 2%범위내에서 전산 랜덤방식으로 10개를 자동 선정한 후</br>다시 전산 랜덤방식으로 5개를 선정하여 평균한 금액
      							</td>
    						</tr>     
    						<tr>
      							<td class="title_td">(확정내정가격의 <%=FROM_LOWER_BND%>%금액)</td>
      							<td class="data_td">
        							<input type="text" name="FROM_LOWER_BND_AMT" id="FROM_LOWER_BND_AMT"  readonly style="text-align: right;width:90% ;background-color: #f6f6f6;border: 0px;" value="<%=SepoaMath.SepoaNumberType(estm_bid_amt, "###,###,###,###,###,###" ) %>"/>
      							</td>
      							<td class="data_td"></td>
      							<td class="data_td" ></td>
    						</tr>    
    						<tr>
      							<td class="title_td">낙찰금액</td>
      							<td class="data_td">
        							<input type="text" name="SETTLE_AMT" style="width:90%;text-align: right;background-color: #f6f6f6;border: 0px;"  readonly value="<%=SepoaMath.SepoaNumberType(conf_bid_amt, "###,###,###,###,###,###" )%>">
      							</td>
      							<td class="data_td">
      								<input type="text" name="ESTM_SETTLE_RATE" style="width:80%;text-align: right;background-color: #f6f6f6;border: 0px;"  size="6" readonly value="<%=SepoaMath.SepoaNumberType(conf_rate, "###.##")%>">&nbsp;%
      								<input type="hidden" name="FROM_LOWER_BND" style="text-align: right;width:80%;background-color: #f6f6f6;border: 0px;" size="5" readonly>&nbsp;
      							</td>
      							<td class="data_td" ></td>
    						</tr>     
    						<tr>
      							<td class="title_td">입찰업체수</td>
      							<td class="data_td" align="right">
        							<%=wfList.getRowCount() - bidCVendor %>개 업체&nbsp;&nbsp;&nbsp;
      							</td>
      							<td class="data_td">
      	
      							</td>
      							<td class="data_td" ></td>
    						</tr>     
    						<tr>
      							<td class="title_td">유효입찰업체수</td>
      							<td class="data_td" align="right">
        							<%=validVendor %>개 업체&nbsp;&nbsp;&nbsp;
      							</td>
      							<td class="data_td"></td>
      							<td class="data_td" >
        							<input type="hidden" name="AC" style="text-align: right;" size="12" readonly >&nbsp;
        							<input type="hidden" name="AC_RATE" style="text-align: right;" size="8" readonly >&nbsp;     
        							<input type="hidden" name="BC" size="12" readonly style="text-align: right;">&nbsp;
        							<input type="hidden" name="BC_RATE" size="8" readonly style="text-align: right;">&nbsp;         
      							</td>
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
// 			if("SB".equals(wfList.getValue("BID_STATUS", i))){
// 				vendor_name = wfList.getValue("VENDOR_NAME", i);
// 			}else{
// 				vendor_name = "";
// 			}
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
						if( "T".equals(BID_INPUT_TYPE)){
				%>								
  								<td class="data_td" style="text-align: right;"><%=SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###") + bid_cancel_yn%></td>

				<%
						}else{
				%>
								<td class="data_td" style="text-align: right;"><a href="javascript:PopupManager('<%=j%>','<%=wfList.getValue("VENDOR_CODE", i)%>','<%=vendor_name%>');"><%=SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###") + bid_cancel_yn%></a></td>
				<% 
						}
					
				}else{
				%>
  								<td class="data_td" style="text-align: right;"></td>
				<%
				}	
				%>				
<%--   								<td class="data_td" style="text-align: right;"><%=SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###") + bid_cancel_yn%></td> --%>
<%				
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
}else if (PROM_CRIT.equals("B")) {
%>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
      							<td width="1%" class="title_td" style="text-align: center">NO</td>
      							<td width="7%" class="title_td" style="text-align: center">공급업체</td>
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(1차)</td>
<%if("1".equals(VOTE_COUNT)){ %><td width="7%" class="title_td" style="text-align: center">비율</br>(예정가격대비)</td><%} %>      							
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(2차)</td>
<%if("2".equals(VOTE_COUNT)){ %><td width="7%" class="title_td" style="text-align: center">비율</br>(예정가격대비)</td><%} %>      							
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(3차)</td>
<%if("3".equals(VOTE_COUNT)){ %><td width="7%" class="title_td" style="text-align: center">비율</br>(예정가격대비)</td><%} %>      							
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(4차)</td>
<%if("4".equals(VOTE_COUNT)){ %><td width="7%" class="title_td" style="text-align: center">비율</br>(예정가격대비)</td><%} %>      							
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(5차)</td>
<%if("5".equals(VOTE_COUNT)){ %><td width="7%" class="title_td" style="text-align: center">비율</br>(예정가격대비)</td><%} %>      							
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(6차)</td>
<%if("6".equals(VOTE_COUNT)){ %><td width="7%" class="title_td" style="text-align: center">비율</br>(예정가격대비)</td><%} %>      							
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(7차)</td>
<%if("7".equals(VOTE_COUNT)){ %><td width="7%" class="title_td" style="text-align: center">비율</br>(예정가격대비)</td><%} %>      							
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(8차)</td>
<%if("8".equals(VOTE_COUNT)){ %><td width="7%" class="title_td" style="text-align: center">비율</br>(예정가격대비)</td><%} %>      							
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(9차)</td>
<%if("9".equals(VOTE_COUNT)){ %><td width="7%" class="title_td" style="text-align: center">비율</br>(예정가격대비)</td><%} %>      							
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(10차)</td>
<%if("10".equals(VOTE_COUNT)){ %><td width="7%" class="title_td" style="text-align: center">비율</br>(예정가격대비)</td><%} %>      							
    						</tr>						
						
<%
	int sbIdx = -1;
	String last_bid_status = "";
	for(int i = 0 ; i < wfList.getRowCount() ; i++){
		last_bid_amt = wfList.getDouble("BID_AMT_" + VOTE_COUNT, i);
		
		if("ADMIN".equals(menu_type)){
			vendor_name = wfList.getValue("VENDOR_NAME", i);
		}else{
			if( info.getSession("COMPANY_CODE").equals(wfList.getValue("VENDOR_CODE", i))){
				vendor_name = wfList.getValue("VENDOR_NAME", i);
			}else{
				vendor_name = "";
			}			
			
// 			if("SB".equals(wfList.getValue("BID_STATUS", i))){
// 				vendor_name = wfList.getValue("VENDOR_NAME", i);
// 			}else{
// 				vendor_name = "";
// 			}
		}		
		
%>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>    
  							<tr>
  								<td class="data_td"><%=i+1%></td>
  								<td class="data_td"><%=vendor_name %></td>
<%
		for(int j = 1 ; j <= 10 ; j++){
			
			bid_cancel_yn = wfList.getValue("BID_CANCEL_" + j, i);
			
			if("Y".equals(bid_cancel_yn)){
				bid_cancel_yn = "</br><font color='red'>(입찰취소)</font>";
			}else{
				bid_cancel_yn = "";
			}
			
			if( info.getSession("COMPANY_CODE").equals(wfList.getValue("VENDOR_CODE", i)) || "ADMIN".equals(menu_type)){
				if( "T".equals(BID_INPUT_TYPE)){
%>
  								<td class="data_td" style="text-align: right;"><%=SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###") +bid_cancel_yn%></td>

<%				
				}else{
%>
								<td class="data_td" style="text-align: right;"><a href="javascript:PopupManager('<%=j%>','<%=wfList.getValue("VENDOR_CODE", i)%>','<%=vendor_name%>');"><%=SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###") +bid_cancel_yn%></a></td>
<%					
					
				}
			}else{
%>
  								<td class="data_td" style="text-align: right;"></td>
<%
			}	
			
%>



<%--   								<td class="data_td" style="text-align: right;"><%=SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###") +bid_cancel_yn%></td> --%>
<%			
			if(j == Integer.parseInt(VOTE_COUNT)){
				
				if( info.getSession("COMPANY_CODE").equals(wfList.getValue("VENDOR_CODE", i)) || "ADMIN".equals(menu_type)){
					%>
								<td class="data_td" style="text-align: right;"><%=SepoaMath.SepoaNumberType((wfList.getDouble("BID_AMT_" + j, i)/Double.parseDouble(BASIC_AMT) * 100), "###.##")%> %</td>

					<%				
								}else{
					%>
								<td class="data_td" style="text-align: right;"></td>
					<%
								}	
								
					%>
<%-- 								<td class="data_td" style="text-align: right;"><%=SepoaMath.SepoaNumberType((wfList.getDouble("BID_AMT_" + j, i)/Double.parseDouble(BASIC_AMT) * 100), "###.##")%> %</td> --%>
<%			
			} 
		}
%>  								
  							</tr>
<%			
	}
%>  								
  							</tr>
					
  						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>	
<%	
}else if (PROM_CRIT.equals("C")) {
%>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
      							<td width="2%" class="title_td" style="text-align: center">NO</td>
      							<td width="7%" class="title_td" style="text-align: center">공급업체</td>
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(1차)</td>
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(2차)</td>
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(3차)</td>
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(4차)</td>
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(5차)</td>
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(6차)</td>
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(7차)</td>
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(8차)</td>
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(9차)</td>
      							<td width="7%" class="title_td" style="text-align: center">입찰금액</br>(10차)</td>
      							<td width="7%" class="title_td" style="text-align: center">기술점수</td>
      							<td width="7%" class="title_td" style="text-align: center">가격점수</td>
      							<td width="7%" class="title_td" style="text-align: center">종합점수</td>
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
			
// 			if("SB".equals(wfList.getValue("BID_STATUS", i))){
// 				vendor_name = wfList.getValue("VENDOR_NAME", i);
// 			}else{
// 				vendor_name = "";
// 			}
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
				
				
				if( info.getSession("COMPANY_CODE").equals(wfList.getValue("VENDOR_CODE", i)) || "ADMIN".equals(menu_type)){
					if( "T".equals(BID_INPUT_TYPE)){
%>
  								<td class="data_td" style="text-align: right;"><%=SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###") + bid_cancel_yn%></td>
<%				
					}else{
					%>
								<td class="data_td" style="text-align: right;"><a href="javascript:PopupManager('<%=j%>','<%=wfList.getValue("VENDOR_CODE", i)%>','<%=vendor_name%>');"><%=SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###") + bid_cancel_yn%></a></td>
					<%												
					}
                                
				}else{
%>
  								<td class="data_td" style="text-align: right;"></td>
<%
				}	
				
%>
  								<td class="data_td" style="text-align: right;"><%=SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###") + bid_cancel_yn%></td>
<%				
			}
%>  		  								
  								<td class="data_td" style="text-align: right;"><%=SepoaMath.SepoaNumberType(wfList.getValue("TECHNICAL_SCORE", i),"###,###,###,###,###,###,###") %></td>
  								<td class="data_td" style="text-align: right;" id="price_score_<%=i%>"><%=SepoaMath.SepoaNumberType(wfList.getValue("PRICE_SCORE", i),"###,###,###,###,###,###,###") %></td>
  								<td class="data_td" style="text-align: right;" id="total_score_<%=i%>"><%=SepoaMath.SepoaNumberType(wfList.getValue("TOTAL_SCORE", i),"###,###,###,###,###,###,###") %></td>
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
								<td class="title_td"  colspan="12">※ 입찰 하단표기금액 정보 : <font size="2" color="blue">품목금액</font> &nbsp;<font size="2" color="red">,TCO금액</font></td>
							</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>   
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
// 			if("SB".equals(wfList.getValue("BID_STATUS", i))){
// 				vendor_name = wfList.getValue("VENDOR_NAME", i);
// 			}else{
// 				vendor_name = "";
// 			}
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
				
				if( info.getSession("COMPANY_CODE").equals(wfList.getValue("VENDOR_CODE", i)) || "ADMIN".equals(menu_type)){
	%>
  								<td class="data_td">
  									<table>	
  										<tr>
  											<td style="text-align: right;"><font color="blue"><%=SepoaMath.SepoaNumberType(wfList.getValue("PRODUCT_PRICE_" + j, i), "###,###,###,###,###,###,###")%></font></td>
  										</tr>
  										<tr>
  											<td style="text-align: right;"><font color="red"><%=SepoaMath.SepoaNumberType(wfList.getValue("TCO_PRICE_" + j, i), "###,###,###,###,###,###,###")%></font></td>
  										</tr>
  										<tr>
  											<td style="text-align: right;"><b><a href="javascript:PopupManager('<%=j%>','<%=wfList.getValue("VENDOR_CODE", i)%>','<%=vendor_name%>');"><%=SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###") + bid_cancel_yn%></a></b></td>
  										</tr>
  									</table>
  								</td>

	<%				
				}else{
	%>
  								<td class="data_td">
  									<table>	
  										<tr>
  											<td style="text-align: right;"></td>
  										</tr>
  										<tr>
  											<td style="text-align: right;"></td>
  										</tr>
  										<tr>
  											<td style="text-align: right;"></td>
  										</tr>
  									</table>
  								</td>
	<%
				}	
				
%>
<!--   								<td class="data_td"> -->
<!--   									<table>	 -->
<!--   										<tr> -->
<%--   											<td style="text-align: right;"><font color="blue"><%=SepoaMath.SepoaNumberType(wfList.getValue("PRODUCT_PRICE_" + j, i), "###,###,###,###,###,###,###")%></font></td> --%>
<!--   										</tr> -->
<!--   										<tr> -->
<%--   											<td style="text-align: right;"><font color="red"><%=SepoaMath.SepoaNumberType(wfList.getValue("TCO_PRICE_" + j, i), "###,###,###,###,###,###,###")%></font></td> --%>
<!--   										</tr> -->
<!--   										<tr> -->
<%--   											<td style="text-align: right;"><b><%=SepoaMath.SepoaNumberType(wfList.getValue("BID_AMT_" + j, i), "###,###,###,###,###,###,###") + bid_cancel_yn%></b></td> --%>
<!--   										</tr> -->
<!--   									</table> -->
<!--   								</td> -->
<%				
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
 					<td><script language="javascript">btn("javascript:clipPrint()", "출 력")</script></td>
 					<td><script language="javascript">btn("javascript:window.close()", "닫 기")</script></td> 
 					<%-- <td><script language="javascript">btn("javascript:doHtmlSave()", "내PC에저장")</script></td> --%> 
<!-- 				<td><input type="button" style="height: 20px;" value="인 쇄" 		onclick="javascript:clipPrint()"></td>
					<td><input type="button" style="height: 20px;" value="내PC에저장" 	onclick="javascript:doHtmlSave()"></td>
					<td><input type="button" style="height: 20px;" value="닫 기" 		onclick="javascript:window.close()"></td> -->
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>

