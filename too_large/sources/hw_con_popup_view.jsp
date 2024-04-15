<!--  /t_system1/wise/vaatz_package/myserver/V1.0.0/wisedoc/kr/dt/bid/ebd_bd_ins1.jsp -->
<!--
Title:        공사수기계약 <p>
 Description:  공사수기계약작성 <p>
 Copyright:     <p>
 Company:     SepoaSoft <p>
 @author       next1210 <p>
 @version      1.0
 @Comment   
!-->
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_007");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	boolean isSelectScreen = false;

    String mode       = "update";

    String house_code   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
    
    String con_number = JSPUtil.nullToEmpty(request.getParameter("con_number"));
    
    String con_kind_list	= ListBox(request, "SL0018",  house_code+"#H001#", "");
    String con_type_list	= ListBox(request, "SL0018",  house_code+"#H002#", "");
    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간
    
    String con_kind        		= "";
    String own_kind        		= "";
    String dept            		= "";
    String dept_text	   		= "";
    String con_name        		= "";
    String pay_term        		= "";
    String con_date        		= "";
    String made_date       		= "";
    String pay_date        		= "";
    String own_name1       		= "";
    String own_name2       		= "";
    String own_name3       		= "";
    String con_type1       		= "";
    String vendor_code1    		= "";
    String vendor_code1_text    = "";
    String pre_amt1        		= "";
    String con_amt1        		= "";
    String con_type2       		= "";
    String vendor_code2    		= "";
    String vendor_code2_text    = "";
    String pre_amt2        		= "";
    String con_amt2        		= "";
    String con_type3       		= "";
    String vendor_code3    		= "";
    String vendor_code3_text    = "";
    String pre_amt3        		= "";
    String con_amt3        		= "";
    String con_type4       		= "";
    String vendor_code4    		= "";
    String vendor_code4_text    = "";
    String pre_amt4        		= "";
    String con_amt4        		= "";
    String con_type5       		= "";
    String vendor_code5    		= "";
    String vendor_code5_text    = "";
    String pre_amt5        		= "";
    String con_amt5        		= "";
    String con_type6       		= "";
    String vendor_code6    		= "";
    String vendor_code6_text    = "";
    String pre_amt6        		= "";
    String con_amt6        		= "";
    String con_type7       		= "";
    String vendor_code7    		= "";
    String vendor_code7_text    = "";
    String pre_amt7        		= "";
    String con_amt7        		= "";
    String con_type8       		= "";
    String etc_amt1        		= "";
    String etc_amt2        		= "";
    String etc_amt3        		= "";
    String etc_amt4        		= "";
    String total_amt       		= "";
    String pa_title        		= "";
    String pa_name         		= "";
    String boss_title      		= "";
    String boss_name       		= "";
    String remark          		= "";
    String attach_no       		= "";

    String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
  
    if("update".equals(mode)) {
	   	Map map = new HashMap();
	   	map.put("house_code"		, house_code);
	   	map.put("con_number"		, con_number);
	
	   	Object[] obj = {map};
	   	SepoaOut value = ServiceConnector.doService(info, "h1001", "CONNECTION","getConData", obj);
	   	
	   	SepoaFormater wf = new SepoaFormater(value.result[0]); 
	   	
	   	con_kind        	= wf.getValue("CON_KIND",0);
	   	own_kind        	= wf.getValue("OWN_KIND",0); 
	   	dept            	= wf.getValue("DEPT",0); 
	   	dept_text	   	    = wf.getValue("DEPT_TEXT",0); 
	   	con_name        	= wf.getValue("CON_NAME",0); 
	   	pay_term        	= wf.getValue("PAY_TERM",0); 
	   	con_date        	= wf.getValue("CON_DATE",0); 
	   	made_date       	= wf.getValue("MADE_DATE",0); 
	   	pay_date        	= wf.getValue("PAY_DATE",0); 
	   	own_name1       	= wf.getValue("OWN_NAME1",0); 
	   	own_name2       	= wf.getValue("OWN_NAME2",0); 
	   	own_name3       	= wf.getValue("OWN_NAME3",0); 
	   	con_type1       	= wf.getValue("CON_TYPE1",0); 
	   	vendor_code1    	= wf.getValue("VENDOR_CODE1",0); 
	   	vendor_code1_text   = wf.getValue("VENDOR_CODE1_TEXT",0); 
	   	pre_amt1        	= wf.getValue("PRE_AMT1",0); 
	   	con_amt1        	= wf.getValue("CON_AMT1",0); 
	   	con_type2       	= wf.getValue("CON_TYPE2",0); 
	   	vendor_code2    	= wf.getValue("VENDOR_CODE2",0); 
	   	vendor_code2_text   = wf.getValue("VENDOR_CODE2_TEXT",0); 
	   	pre_amt2        	= wf.getValue("PRE_AMT2",0); 
	   	con_amt2        	= wf.getValue("CON_AMT2",0); 
	   	con_type3       	= wf.getValue("CON_TYPE3",0); 
	   	vendor_code3    	= wf.getValue("VENDOR_CODE3",0); 
	   	vendor_code3_text   = wf.getValue("VENDOR_CODE3_TEXT",0); 
	   	pre_amt3        	= wf.getValue("PRE_AMT3",0); 
	   	con_amt3        	= wf.getValue("CON_AMT3",0); 
	   	con_type4       	= wf.getValue("CON_TYPE4",0); 
	   	vendor_code4    	= wf.getValue("VENDOR_CODE4",0); 
	   	vendor_code4_text   = wf.getValue("VENDOR_CODE4_TEXT",0); 
	   	pre_amt4        	= wf.getValue("PRE_AMT4",0); 
	   	con_amt4        	= wf.getValue("CON_AMT4",0); 
	   	con_type5       	= wf.getValue("CON_TYPE5",0); 
	   	vendor_code5    	= wf.getValue("VENDOR_CODE5",0); 
	   	vendor_code5_text   = wf.getValue("VENDOR_CODE5_TEXT",0); 
	   	pre_amt5        	= wf.getValue("PRE_AMT5",0); 
	   	con_amt5        	= wf.getValue("CON_AMT5",0); 
	   	con_type6       	= wf.getValue("CON_TYPE6",0); 
	   	vendor_code6    	= wf.getValue("VENDOR_CODE6",0); 
	   	vendor_code6_text   = wf.getValue("VENDOR_CODE6_TEXT",0); 
	   	pre_amt6        	= wf.getValue("PRE_AMT6",0); 
	   	con_amt6        	= wf.getValue("CON_AMT6",0); 
	   	con_type7       	= wf.getValue("CON_TYPE7",0); 
	   	vendor_code7    	= wf.getValue("VENDOR_CODE7",0); 
	   	vendor_code7_text   = wf.getValue("VENDOR_CODE7_TEXT",0); 
	   	pre_amt7        	= wf.getValue("PRE_AMT7",0); 
	   	con_amt7        	= wf.getValue("CON_AMT7",0); 
	   	con_type8       	= wf.getValue("CON_TYPE8",0); 
	   	etc_amt1        	= wf.getValue("ETC_AMT1",0); 
	   	etc_amt2        	= wf.getValue("ETC_AMT2",0); 
	   	etc_amt3        	= wf.getValue("ETC_AMT3",0); 
	   	etc_amt4        	= wf.getValue("ETC_AMT4",0); 
	   	total_amt       	= wf.getValue("TOTAL_AMT",0); 
	   	pa_title        	= wf.getValue("PA_TITLE",0); 
	   	pa_name         	= wf.getValue("PA_NAME",0); 
	   	boss_title      	= wf.getValue("BOSS_TITLE",0); 
	   	boss_name       	= wf.getValue("BOSS_NAME",0); 
	   	remark          	= wf.getValue("REMARK",0); 
	   	attach_no       	= wf.getValue("ATTACH_FILE",0); 
	   	
    }
    
    
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_hw_con_popup_view"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
    
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%-- <%@ include file="/include/sepoa_grid_common.jsp"%> --%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp" %>
<script language="javascript" type="text/javascript">

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;
var G_C_INDEX     = "MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:DELIVERY_IT:MAKER_NAME:MAKER_CODE:ITEM_GROUP:DELY_TO_ADDRESS:KTGRM";

function init() {
	
	var mode = "<%=mode %>";
	
<%-- 	document.forms[0].confirm_from_date.value = add_Slash("<%=confirm_from_date %>"); --%>
<%-- 	document.forms[0].confirm_to_date.value   = add_Slash("<%=confirm_to_date%>"); --%>
<%-- 	document.forms[0].install_date.value   = add_Slash("<%=install_date%>"); --%>
	
	document.forms[0].con_kind.value = "<%=con_kind%>";
	document.forms[0].con_type1.value = "<%=con_type1%>";
	document.forms[0].con_type2.value = "<%=con_type2%>";
	document.forms[0].con_type3.value = "<%=con_type3%>";
	document.forms[0].con_type4.value = "<%=con_type4%>";
	document.forms[0].con_type5.value = "<%=con_type5%>";
	document.forms[0].con_type6.value = "<%=con_type6%>";
	document.forms[0].con_type7.value = "<%=con_type7%>";
	document.forms[0].con_type8.value = "<%=con_type8%>";
	
}

function doQuery() {

    var cols_ids = "";
    var params = "mode=getBdItemDetail";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
//     GridObj.post( G_SERVLETURL, params );
//     GridObj.clearAll(false);
}

function doSave(temp) {
	var con_kind = document.forms[0].con_kind.value;
	var own_kind = document.forms[0].own_kind.value;
	var dept = document.forms[0].dept.value;
	var con_name = document.forms[0].con_name.value;
	var pay_term = document.forms[0].pay_term.value;
	var con_date = document.forms[0].con_date.value;
	
	if(con_kind == "") { alert("공사구분이 없습니다."); return; }
	if(own_kind == "") { alert("소유구분이 없습니다."); return; }
	if(dept == "") { alert("영업점이 없습니다."); return; }
	if(con_name == "") { alert("공사명이 없습니다."); return; }
	if(pay_term == "") { alert("지급방법이 없습니다."); return; }
	if(del_Slash(con_date) == "") { alert("계약일자가 없습니다."); return; }
	
	 var nickName       	= "h1001";
     var conType         	= "TRANSACTION";
     var methodName 		= "doSaveCon";
     var SepoaOut        	= doServiceAjax( nickName, conType, methodName );
     // SepoaOut.result[0] << setValue
     
     if( SepoaOut.status == "1" ) { // 성공
     	alert(SepoaOut.message);

		var house_code 		= SepoaOut.result[0];
		var con_number 		= SepoaOut.result[1];
        
		var param = "";
		param += "?mode=update"
		param += "&house_code=" + house_code
		param += "&con_number=" + con_number
		
		location.href = "hw_con_popup.jsp"+param;
		opener.doSelect();
     } else {
         if(SepoaOut.message == "null"){
             alert("AjaxError");
         }else{
             alert(SepoaOut.message);
         }
     }
}

//팝업호출 공통
function PopupManager(part)
{
	var url = "";
	var f = document.forms[0];

	if(part == "DEPT"){	//영업점
		window.open("/common/CO_009.jsp?callback=return_dept", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");

	}else if(part == "STORE1" || part == "STORE2" || part == "STORE3" || part == "STORE4" || part == "STORE5" || part == "STORE6" || part == "STORE7"){	//공급업체
		window.open("/common/CO_014.jsp?callback=return_store_"+part, "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}
}

function return_dept(code,text){
    document.forms[0].dept.value	= code;
	document.forms[0].dept_text.value 	= text;
}

function return_store_STORE1(code, desc1, desc2 , desc3) {
	document.forms[0].vendor_code1.value = code;
	document.forms[0].vendor_code1_text.value = desc1;
}

function return_store_STORE2(code, desc1, desc2 , desc3) {
	document.forms[0].vendor_code2.value = code;
	document.forms[0].vendor_code2_text.value = desc1;
}

function return_store_STORE3(code, desc1, desc2 , desc3) {
	document.forms[0].vendor_code3.value = code;
	document.forms[0].vendor_code3_text.value = desc1;
}

function return_store_STORE4(code, desc1, desc2 , desc3) {
	document.forms[0].vendor_code4.value = code;
	document.forms[0].vendor_code4_text.value = desc1;
}

function return_store_STORE5(code, desc1, desc2 , desc3) {
	document.forms[0].vendor_code5.value = code;
	document.forms[0].vendor_code5_text.value = desc1;
}

function return_store_STORE6(code, desc1, desc2 , desc3) {
	document.forms[0].vendor_code6.value = code;
	document.forms[0].vendor_code6_text.value = desc1;
}

function return_store_STORE7(code, desc1, desc2 , desc3) {
	document.forms[0].vendor_code7.value = code;
	document.forms[0].vendor_code7_text.value = desc1;
}

//지우기
function doRemove( type ){
    if( type == "STORE1" ) {
    	document.forms[0].vendor_code1.value = "";
        document.forms[0].vendor_code1_text.value = "";
    } else if(type == "STORE2") {
    	document.forms[0].vendor_code2.value = "";
        document.forms[0].vendor_code2_text.value = "";
    } else if(type == "STORE3") {
    	document.forms[0].vendor_code3.value = "";
        document.forms[0].vendor_code3_text.value = "";
    } else if(type == "STORE4") {
    	document.forms[0].vendor_code4.value = "";
        document.forms[0].vendor_code4_text.value = "";
    } else if(type == "STORE5") {
    	document.forms[0].vendor_code5.value = "";
        document.forms[0].vendor_code5_text.value = "";
    } else if(type == "STORE6") {
    	document.forms[0].vendor_code6.value = "";
        document.forms[0].vendor_code6_text.value = "";
    } else if(type == "STORE7") {
    	document.forms[0].vendor_code7.value = "";
        document.forms[0].vendor_code7_text.value = "";
    } else if(type == "DEPT") {
    	document.forms[0].dept.value = "";
        document.forms[0].dept_text.value = "";
    } 
}

function change( type ){
	
	if(type == "pre_amt1") {
    	var amt = document.forms[0].pre_amt1.value;
    	if(amt.length > 0) {
    		document.forms[0].pre_amt1.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "con_amt1") {
		var amt = document.forms[0].con_amt1.value;
    	if(amt.length > 0) {
    		document.forms[0].con_amt1.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "pre_amt2") {
		var amt = document.forms[0].pre_amt2.value;
    	if(amt.length > 0) {
    		document.forms[0].pre_amt2.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "con_amt2") {
		var amt = document.forms[0].con_amt2.value;
    	if(amt.length > 0) {
    		document.forms[0].con_amt2.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "pre_amt3") {
		var amt = document.forms[0].pre_amt3.value;
    	if(amt.length > 0) {
    		document.forms[0].pre_amt3.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "con_amt3") {
		var amt = document.forms[0].con_amt3.value;
    	if(amt.length > 0) {
    		document.forms[0].con_amt3.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "pre_amt4") {
		var amt = document.forms[0].pre_amt4.value;
    	if(amt.length > 0) {
    		document.forms[0].pre_amt4.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "con_amt4") {
		var amt = document.forms[0].con_amt4.value;
    	if(amt.length > 0) {
    		document.forms[0].con_amt4.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "pre_amt5") {
		var amt = document.forms[0].pre_amt5.value;
    	if(amt.length > 0) {
    		document.forms[0].pre_amt5.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "con_amt5") {
		var amt = document.forms[0].con_amt5.value;
    	if(amt.length > 0) {
    		document.forms[0].con_amt5.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "pre_amt6") {
		var amt = document.forms[0].pre_amt6.value;
    	if(amt.length > 0) {
    		document.forms[0].pre_amt6.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "con_amt6") {
		var amt = document.forms[0].con_amt6.value;
    	if(amt.length > 0) {
    		document.forms[0].con_amt6.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "pre_amt7") {
		var amt = document.forms[0].pre_amt7.value;
    	if(amt.length > 0) {
    		document.forms[0].pre_amt7.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "con_amt7") {
		var amt = document.forms[0].con_amt7.value;
    	if(amt.length > 0) {
    		document.forms[0].con_amt7.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "etc_amt1") {
		var amt = document.forms[0].etc_amt1.value;
    	if(amt.length > 0) {
    		document.forms[0].etc_amt1.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "etc_amt2") {
		var amt = document.forms[0].etc_amt2.value;
    	if(amt.length > 0) {
    		document.forms[0].etc_amt2.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "etc_amt3") {
		var amt = document.forms[0].etc_amt3.value;
    	if(amt.length > 0) {
    		document.forms[0].etc_amt3.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "etc_amt4") {
		var amt = document.forms[0].etc_amt4.value;
    	if(amt.length > 0) {
    		document.forms[0].etc_amt4.value = Comma(amt.replace(/,/gi, ''));
    	}
	} else if(type == "total_amt") {
		var amt = document.forms[0].total_amt.value;
    	if(amt.length > 0) {
    		document.forms[0].total_amt.value = Comma(amt.replace(/,/gi, ''));
    	}
	}
}


<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData,approvalCnt) {
	var sRptData = "";
	var rf = "<%=CommonUtil.getConfig("clipreport4.separator.field")%>";
	var rl = "<%=CommonUtil.getConfig("clipreport4.separator.line")%>";
	var rd = "<%=CommonUtil.getConfig("clipreport4.separator.data")%>";
	
	
	
	sRptData += "<%=con_number%>"; //계약번호
	sRptData += rf;
	sRptData += document.form.con_name.value;	//공사명	
	sRptData += rf;
	sRptData += document.form.dept_text.value;	//영업점1
	sRptData += " (";
	sRptData += document.form.dept.value;	//영업점2
	sRptData += ")";
	sRptData += rf;
	sRptData += document.form.con_kind.options[document.form.con_kind.selectedIndex].text;	//공사구분
	sRptData += rf;
	sRptData += document.form.own_kind.value;	//소유구분
	sRptData += rf;
	sRptData += document.form.pay_term.value;	//지급방법
	sRptData += rf;
	sRptData += document.form.con_date.value;	//계약일자
	sRptData += rf;
	sRptData += document.form.made_date.value;	//준공일자
	sRptData += rf;
	sRptData += document.form.pay_date.value;	//대금지급일
	sRptData += rf;
	sRptData += document.form.own_name1.value;	//건축기술역
	sRptData += rf;
	sRptData += document.form.own_name2.value;	//설비기술역
	sRptData += rf;
	sRptData += document.form.own_name3.value;	//전기기술역
	sRptData += rf;
	
	//1
	sRptData += document.form.con_type1.options[document.form.con_type1.selectedIndex].text;	//계약방법1	
	sRptData += rf;
	sRptData += document.form.vendor_code1_text.value;	//업체1-1
	sRptData += rf;
	sRptData += document.form.vendor_code1.value; //업체1-2
	sRptData += rf;
	sRptData += document.form.pre_amt1.value;	//예정금액1
	sRptData += rf;
	sRptData += document.form.con_amt1.value;	//계약금액1
	sRptData += rf;

	//2
	sRptData += document.form.con_type2.options[document.form.con_type2.selectedIndex].text;	//계약방법2	
	sRptData += rf;
	sRptData += document.form.vendor_code2_text.value;	//업체2-1
	sRptData += rf;
	sRptData += document.form.vendor_code2.value; //업체2-2
	sRptData += rf;
	sRptData += document.form.pre_amt2.value;	//예정금액2
	sRptData += rf;
	sRptData += document.form.con_amt2.value;	//계약금액2
	sRptData += rf;	
	
	//3
	sRptData += document.form.con_type3.options[document.form.con_type3.selectedIndex].text;	//계약방법3	
	sRptData += rf;
	sRptData += document.form.vendor_code3_text.value;	//업체3-1
	sRptData += rf;
	sRptData += document.form.vendor_code3.value; //업체3-2
	sRptData += rf;
	sRptData += document.form.pre_amt3.value;	//예정금액3
	sRptData += rf;
	sRptData += document.form.con_amt3.value;	//계약금액3
	sRptData += rf;
	
	//4
	sRptData += document.form.con_type4.options[document.form.con_type4.selectedIndex].text;	//계약방법4	
	sRptData += rf;
	sRptData += document.form.vendor_code4_text.value;	//업체4-1
	sRptData += rf;
	sRptData += document.form.vendor_code4.value; //업체4-2
	sRptData += rf;
	sRptData += document.form.pre_amt4.value;	//예정금액4
	sRptData += rf;
	sRptData += document.form.con_amt4.value;	//계약금액4
	sRptData += rf;
	
	//5
	sRptData += document.form.con_type5.options[document.form.con_type5.selectedIndex].text;	//계약방법5	
	sRptData += rf;
	sRptData += document.form.vendor_code5_text.value;	//업체5-1
	sRptData += rf;
	sRptData += document.form.vendor_code5.value; //업체5-2
	sRptData += rf;
	sRptData += document.form.pre_amt5.value;	//예정금액5
	sRptData += rf;
	sRptData += document.form.con_amt5.value;	//계약금액5
	sRptData += rf;
	
	//6
	sRptData += document.form.con_type6.options[document.form.con_type6.selectedIndex].text;	//계약방법6	
	sRptData += rf;
	sRptData += document.form.vendor_code6_text.value;	//업체6-1
	sRptData += rf;
	sRptData += document.form.vendor_code6.value; //업체6-2
	sRptData += rf;
	sRptData += document.form.pre_amt6.value;	//예정금액6
	sRptData += rf;
	sRptData += document.form.con_amt6.value;	//계약금액6
	sRptData += rf;
	
	//7
	sRptData += document.form.con_type7.options[document.form.con_type7.selectedIndex].text;	//계약방법7	
	sRptData += rf;
	sRptData += document.form.vendor_code7_text.value;	//업체7-1
	sRptData += rf;
	sRptData += document.form.vendor_code7.value; //업체7-2	
	sRptData += rf;
	sRptData += document.form.pre_amt7.value;	//예정금액7
	sRptData += rf;
	sRptData += document.form.con_amt7.value;	//계약금액7
	sRptData += rf;
	
	sRptData += document.form.con_type8.options[document.form.con_type8.selectedIndex].text;	//계약방법8	
	sRptData += rf;	
	sRptData += document.form.etc_amt1.value;	//사용전검사수수료
	sRptData += rf;	
	sRptData += document.form.etc_amt2.value;	//한전납입금
	sRptData += rf;	
	sRptData += document.form.etc_amt3.value;	//취득세
	sRptData += rf;	
	sRptData += document.form.etc_amt4.value;	//기타금액
	sRptData += rf;	
	sRptData += document.form.total_amt.value;	//합계금액
	sRptData += rf;	
	sRptData += document.form.pa_title.value;	//담당자직위
	sRptData += rf;	
	sRptData += document.form.pa_name.value;	//담당자성명
	sRptData += rf;	
	sRptData += document.form.boss_title.value;	//결재권자직위
	sRptData += rf;	
	sRptData += document.form.boss_name.value;	//결재권자성명
	sRptData += rf;	
	for(var j = 0; j < attachFrm.document.form1.uploads.options.length; j++){
		sRptData += attachFrm.document.form1.uploads.options[j].text;
		if(j == attachFrm.document.form1.uploads.options.length-1){
			sRptData += "";
		}else{
			sRptData += "<BR>";
		}
	}	//첨부파일	
	sRptData += rf;	
	sRptData += "<%=remark%>"; //비고	
	
	
	
	document.form.rptData.value = sRptData;
	
	if(typeof(rptAprvData) != "undefined"){
		document.form.rptAprvUsed.value = "Y";
		document.form.rptAprvCnt.value = approvalCnt;
		document.form.rptAprv.value = rptAprvData;
    }
    var url = "/ClipReport4/ClipViewer.jsp";
	//url = url + "?BID_TYPE=" + bid_type;	
    var cwin = window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form.method = "POST";
	document.form.action = url;
	document.form.target = "ClipReport4";
	document.form.submit();
	cwin.focus();
}



</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header popup="true">
<!--내용시작--> 

<form name="form" >
<%--ClipReport4 hidden 태그 시작--%>
<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="N">
<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
<input type="hidden" name="rptAprv" id="rptAprv">		
<%--ClipReport4 hidden 태그 끝--%>	
<input type="hidden" name="save_flag" id="save_flag" value="">
<input type="hidden" name="remove_flag" id="remove_flag" value="">
<input type="hidden" name="con_number" id="con_number" value="<%=con_number%>">
<%  
thisWindowPopupFlag = "true";
thisWindowPopupScreenName = "공사수기계약";
%>
    <%@ include file="/include/sepoa_milestone.jsp"%>
    
   
<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
	<TR>
		<td></td>
		<td style="padding:5 5 5 0" align="right">
			<TABLE cellspacing="0">
				<TR>
					<td>
						<!--<script language="javascript">btn("javascript:window.print()","인쇄")</script>-->
						<script language="javascript">btn("javascript:clipPrint()", "출 력")</script>
					</td>
					<td>
						<script language="javascript">btn("javascript:window.close()","닫 기")</script>
					</td>
				</TR>
			</TABLE>
		</td>
	</TR>
</TABLE>
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
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공사구분</font>
		</td>
		<td width="35%" class="data_td">
			<select name="con_kind" id="con_kind" class="inputsubmit" disabled="disabled">
			<option value="">선택</option>
			<%=con_kind_list %>
		    </select>
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소유구분</font>
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="own_kind" id="own_kind" style="width:95%" class="inputsubmit" maxlength="100" value="<%=own_kind%>" readonly="readonly">
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;영업점</font>
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="dept" id="dept" size="16" class="inputsubmit" readonly value="<%=dept%>" readOnly>
			<input type="text" name="dept_text" id="dept_text" size="25" class="input_data2" readonly value="<%=dept_text %>" readOnly>
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공사명</font>
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="con_name" id="con_name" style="width:95%" class="inputsubmit" maxlength="500" value="<%=con_name%>" readonly="readonly">
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급방법</font>
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="pay_term" id="pay_term" style="width:95%" class="inputsubmit" maxlength="200" value="<%=pay_term%>" readonly="readonly">
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약일자</font>
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="con_date" id="con_date" style="width:20%" class="inputsubmit" value="<%=SepoaString.getDateSlashFormat(con_date) %>" readonly="readonly">
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;준공일자
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="made_date" id="made_date" style="width:20%" class="inputsubmit" value="<%=SepoaString.getDateSlashFormat(made_date) %>" readonly="readonly">
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;대금지급일
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="pay_date" id="pay_date" style="width:20%" class="inputsubmit" value="<%=SepoaString.getDateSlashFormat(pay_date) %>" readonly="readonly">
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;건축기술역
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="own_name1" id="own_name1" style="width:95%" class="inputsubmit" maxlength="200" value="<%=own_name1%>" readonly="readonly">
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;설비기술역
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="own_name2" id="own_name2" style="width:95%" class="inputsubmit" maxlength="200" value="<%=own_name2%>" readonly="readonly">
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;전기기술역
		</td>
		<td width="85%" class="data_td" colspan="3">
			<input type="text" name="own_name3" id="own_name3" style="width:39%" class="inputsubmit" maxlength="200" value="<%=own_name3%>" readonly="readonly">
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약방법1
		</td>
		<td width="35%" class="data_td">
			<select name="con_type1" id="con_type1" class="inputsubmit" disabled="disabled">
			<option value="">---</option>
			<%=con_type_list %>
		    </select>
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체1
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="vendor_code1" id="vendor_code1" size="16" class="inputsubmit" readonly value="<%=vendor_code1 %>" readOnly>
			<input type="text" name="vendor_code1_text" id="vendor_code1_text" size="25" class="input_data2" readonly value="<%=vendor_code1_text %>" readOnly>
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예정금액1
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="pre_amt1" id="pre_amt1" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="pre_amt1" name="pre_amt1" dir="rtl" value="<%=SepoaMath.SepoaNumberType(pre_amt1, "###,###,###,###,##0") %>" onchange="change('pre_amt1');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약금액1
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="con_amt1" id="con_amt1" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="con_amt1" name="con_amt1" dir="rtl" value="<%=SepoaMath.SepoaNumberType(con_amt1, "###,###,###,###,##0") %>" onchange="change('con_amt1');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약방법2
		</td>
		<td width="35%" class="data_td">
			<select name="con_type2" id="con_type2" class="inputsubmit" disabled="disabled">
			<option value="">---</option>
			<%=con_type_list %>
		    </select>
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체2
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="vendor_code2" id="vendor_code2" size="16" class="inputsubmit" readonly value="<%=vendor_code2 %>" readOnly>
			<input type="text" name="vendor_code2_text" id="vendor_code2_text" size="25" class="input_data2" readonly value="<%=vendor_code2_text %>" readOnly>
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예정금액2
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="pre_amt2" id="pre_amt2" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="pre_amt2" name="pre_amt2" dir="rtl" value="<%=SepoaMath.SepoaNumberType(pre_amt2, "###,###,###,###,##0") %>" onchange="change('pre_amt2');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약금액2
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="con_amt2" id="con_amt2" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="con_amt2" name="con_amt2" dir="rtl" value="<%=SepoaMath.SepoaNumberType(con_amt2, "###,###,###,###,##0") %>" onchange="change('con_amt2');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약방법3
		</td>
		<td width="35%" class="data_td">
			<select name="con_type3" id="con_type3" class="inputsubmit" disabled="disabled">
			<option value="">---</option>
			<%=con_type_list %>
		    </select>
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체3
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="vendor_code3" id="vendor_code3" size="16" class="inputsubmit" readonly value="<%=vendor_code3 %>" readOnly>
			<input type="text" name="vendor_code3_text" id="vendor_code3_text" size="25" class="input_data2" readonly value="<%=vendor_code3_text %>" readOnly>
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예정금액3
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="pre_amt3" id="pre_amt3" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="pre_amt3" name="pre_amt3" dir="rtl" value="<%=SepoaMath.SepoaNumberType(pre_amt3, "###,###,###,###,##0") %>" onchange="change('pre_amt3');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약금액3
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="con_amt3" id="con_amt3" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="con_amt3" name="con_amt3" dir="rtl" value="<%=SepoaMath.SepoaNumberType(con_amt3, "###,###,###,###,##0") %>" onchange="change('con_amt3');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약방법4
		</td>
		<td width="35%" class="data_td">
			<select name="con_type4" id="con_type4" class="inputsubmit" disabled="disabled">
			<option value="">---</option>
			<%=con_type_list %>
		    </select>
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체4
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="vendor_code4" id="vendor_code4" size="16" class="inputsubmit" readonly value="<%=vendor_code4 %>" readOnly>
			<input type="text" name="vendor_code4_text" id="vendor_code4_text" size="25" class="input_data2" readonly value="<%=vendor_code4_text %>" readOnly>
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예정금액4
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="pre_amt4" id="pre_amt4" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="pre_amt4" name="pre_amt4" dir="rtl" value="<%=SepoaMath.SepoaNumberType(pre_amt4, "###,###,###,###,##0") %>" onchange="change('pre_amt4');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약금액4
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="con_amt4" id="con_amt4" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="con_amt4" name="con_amt4" dir="rtl" value="<%=SepoaMath.SepoaNumberType(con_amt4, "###,###,###,###,##0") %>" onchange="change('con_amt4');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약방법5
		</td>
		<td width="35%" class="data_td">
			<select name="con_type5" id="con_type5" class="inputsubmit" disabled="disabled">
			<option value="">---</option>
			<%=con_type_list %>
		    </select>
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체5
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="vendor_code5" id="vendor_code5" size="16" class="inputsubmit" readonly value="<%=vendor_code5 %>" readOnly>
			<input type="text" name="vendor_code5_text" id="vendor_code5_text" size="25" class="input_data2" readonly value="<%=vendor_code5_text %>" readOnly>
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예정금액5
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="pre_amt5" id="pre_amt5" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="pre_amt5" name="pre_amt5" dir="rtl" value="<%=SepoaMath.SepoaNumberType(pre_amt5, "###,###,###,###,##0") %>" onchange="change('pre_amt5');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약금액5
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="con_amt5" id="con_amt5" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="con_amt5" name="con_amt5" dir="rtl" value="<%=SepoaMath.SepoaNumberType(con_amt5, "###,###,###,###,##0") %>" onchange="change('con_amt5');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약방법6
		</td>
		<td width="35%" class="data_td">
			<select name="con_type6" id="con_type6" class="inputsubmit" disabled="disabled">
			<option value="">---</option>
			<%=con_type_list %>
		    </select>
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체6
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="vendor_code6" id="vendor_code6" size="16" class="inputsubmit" readonly value="<%=vendor_code6 %>" readOnly>
			<input type="text" name="vendor_code6_text" id="vendor_code6_text" size="25" class="input_data2" readonly value="<%=vendor_code6_text %>" readOnly>
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예정금액6
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="pre_amt6" id="pre_amt6" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="pre_amt6" name="pre_amt6" dir="rtl" value="<%=SepoaMath.SepoaNumberType(pre_amt6, "###,###,###,###,##0") %>" onchange="change('pre_amt6');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약금액6
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="con_amt6" id="con_amt6" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="con_amt6" name="con_amt6" dir="rtl" value="<%=SepoaMath.SepoaNumberType(con_amt6, "###,###,###,###,##0") %>" onchange="change('con_amt6');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly" > (원)
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약방법7
		</td>
		<td width="35%" class="data_td">
			<select name="con_type7" id="con_type7" class="inputsubmit" disabled="disabled">
			<option value="">---</option>
			<%=con_type_list %>
		    </select>
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체7
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="vendor_code7" id="vendor_code7" size="16" class="inputsubmit" readonly value="<%=vendor_code7 %>" readOnly>
			<input type="text" name="vendor_code7_text" id="vendor_code7_text" size="25" class="input_data2" readonly value="<%=vendor_code7_text %>" readOnly>
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예정금액7
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="pre_amt7" id="pre_amt7" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="pre_amt7" name="pre_amt7" dir="rtl" value="<%=SepoaMath.SepoaNumberType(pre_amt7, "###,###,###,###,##0") %>" onchange="change('pre_amt7');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약금액7
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="con_amt7" id="con_amt7" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="con_amt7" name="con_amt7" dir="rtl" value="<%=SepoaMath.SepoaNumberType(con_amt7, "###,###,###,###,##0") %>" onchange="change('con_amt7');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약방법8
		</td>
		<td width="85%" class="data_td" colspan="3">
			<select name="con_type8" id="con_type8" class="inputsubmit" disabled="disabled">
			<option value="">---</option>
			<%=con_type_list %>
		    </select>
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용전검사수수료
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="etc_amt1" id="etc_amt1" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="etc_amt1" name="etc_amt1" dir="rtl" value="<%=SepoaMath.SepoaNumberType(etc_amt1, "###,###,###,###,##0") %>" onchange="change('etc_amt1');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;한전납입금
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="etc_amt2" id="etc_amt2" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="etc_amt2" name="etc_amt2" dir="rtl" value="<%=SepoaMath.SepoaNumberType(etc_amt2, "###,###,###,###,##0") %>" onchange="change('etc_amt2');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;취득세
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="etc_amt3" id="etc_amt3" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="etc_amt3" name="etc_amt3" dir="rtl" value="<%=SepoaMath.SepoaNumberType(etc_amt3, "###,###,###,###,##0") %>" onchange="change('etc_amt3');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기타금액
		</td>
		<td width="35%" class="data_td">
<!-- 			<input type="text" name="etc_amt4" id="etc_amt4" style="width:95%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="etc_amt4" name="etc_amt4" dir="rtl" value="<%=SepoaMath.SepoaNumberType(etc_amt4, "###,###,###,###,##0") %>" onchange="change('etc_amt4');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;합계금액
		</td>
		<td width="85%" class="data_td" colspan="3">
<!-- 			<input type="text" name="total_amt" id="total_amt" style="width:39%" class="inputsubmit" maxlength="200" value=""> -->
			<input type="text" size="15" maxlength="50" id="total_amt" name="total_amt" dir="rtl" value="<%=SepoaMath.SepoaNumberType(total_amt, "###,###,###,###,##0") %>" onchange="change('total_amt');" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" readonly="readonly"> (원)
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;담당자직위
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="pa_title" id="pa_title" style="width:95%" class="inputsubmit" maxlength="200" value="<%=pa_title%>" readonly="readonly">
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;담당자성명
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="pa_name" id="pa_name" style="width:95%" class="inputsubmit" maxlength="200" value="<%=pa_name%>" readonly="readonly">
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;결재권자직위
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="boss_title" id="boss_title" style="width:95%" class="inputsubmit" maxlength="200" value="<%=boss_title%>" readonly="readonly">
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;결재권자성명
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="boss_name" id="boss_name" style="width:95%" class="inputsubmit" maxlength="200" value="<%=boss_name%>" readonly="readonly">
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일
		</td>
		<td width="85%" class="data_td" colspan="3">
			<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=attach_no%>&view_type=VI" style="width: 98%;height: 102px; border: 0px;" frameborder="0" ></iframe>
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%"  class="title_td" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;비고</td>
		<td  class="data_td" width="85%" colspan="3" height="200">
			<%=remark %>
		</td>
    </tr>
	
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>	

<!-- <table width="100%" border="0" cellspacing="0" cellpadding="0"> -->
<!-- <tr> -->
<!-- 	<td height="30" align="right"> -->
<!-- 		<TABLE cellpadding="0"> -->
<!-- 		<TR> -->
<%-- 			<TD><script language="javascript">btn("javascript:doSave()", "저장")</script></TD> --%>
<%-- 			<TD><script language="javascript">btn("javascript:window.close();", "닫기")</script></TD> --%>
<!-- 		</TR> -->
<!-- 		</TABLE> -->
<!-- 	</td> -->
<!-- </tr> -->
<!-- </table>  -->

</form>
<!---- END OF USER SOURCE CODE ----> 
</s:header>
<s:footer/>
</body>
</html>


