<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("MA_010");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "MA_010";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

 	String WISEHUB_PROCESS_ID="MA_010"; 
 	String WISEHUB_LANG_TYPE="KR";
 
    String house_code   = info.getSession("HOUSE_CODE");
    String company_code = info.getSession("COMPANY_CODE");
    String Attach_Index = "";
    String req_item_no = JSPUtil.CheckInjection(request.getParameter("REQ_ITEM_NO"));
    String item_no 			= JSPUtil.CheckInjection(request.getParameter("ITEM_NO"));
    String BUY = JSPUtil.CheckInjection(request.getParameter("BUY"));
    SepoaListBox lb = new SepoaListBox();
    String result = lb.Table_ListBox( request, "SL0200", house_code, "#", "@");

    String[] args={req_item_no};
	//Object[] obj = {args};

	SepoaOut value = ServiceConnector.doService(info, "t0002", "CONNECTION","req_ins_getReqList", args);
	SepoaFormater wf = new SepoaFormater(value.result[0]);

    String ITEM_GROUP					= "";
    String ITEM_GROUP_CODE				= "";
	String ITEM_NO						= "";
	String Z_PURCHASE_TYPE 		        = "";
	String Z_PURCHASE_TYPE_CODE         = "";
	String MATERIAL_TYPE                = "";
	String MATERIAL_TYPE_NAME			= "";
	String MATERIAL_CTRL_TYPE           = "";
	String MATERIAL_CTRL_TYPE_NAME      = "";
	String MATERIAL_CLASS1_NAME         = "";
	String MATERIAL_CLASS1              = "";
	String MATERIAL_CLASS2              = "";
	String MATERIAL_CLASS2_NAME         = "";
	String DESCRIPTION_LOC  	        = "";
	String ITEM_ABBREVIATION            = "";
	String BASIC_UNIT 		            = "";
	String ATTACH_INDEX  		        = "";
	String IMAGE_FILE_PATH 	            = "";
	String IMAGE_FILE_NAME 	            = "";
	String MARKET_TYPE 		            = "";
	String DELIVERY_LT  		        = "";
	String APP_TAX_CODE 		        = "";
	String DRAWING_NO1  		        = "";
	String ITEM_BLOCK_FLAG			    = "";
	String MAKER_NAME		            = "";
	String MAKER_ITEM_NO 		        = "";
	String OLD_ITEM_NO   		        = "";
	String DO_FLAG 			            = "";
	String QI_FLAG					    = "";
	String PROXY_ITEM_NO	            = "";
	String Z_WORK_STAGE_FLAG            = "";
	String Z_DELIVERY_CONFIRM_FLAG		= "";
	String Z_ITEM_DESC					= "";
    String SPECIFICATION				= "";
    String REQ_USER_ID          		= "";
    String REQ_DATE             		= "";
    String REQ_TYPE             		= "";
    String CONFIRM_STATUS       		= "";
    String DATA            				= "";
    String DATA_TYPE            		= "";
    String CONFIRM_DATE         		= "";
    String CONFIRM_USER_NAME    		= "";
	String RELEASE_FLAG					= "";
	String RELEASE_FLAG_NAME			= "";
	String INTEGRATED_BUY_NAME			= "";
	String REMARK						= "";
	String INTEGRATED_BUY_FLAG			= "";
	String COMPANY_CODE_NAME			= "";
	String title = "";
	String PR_FLAG						= "";
	String ITEM_BLOCK_FLAG_ON			= "";
	String Z_WORK_STAGE_FLAG_ON         = "";
	String Z_DELIVERY_CONFIRM_FLAG_ON	= "";
	String DO_FLAG_ON		            = "";
	String QI_FLAG_ON				    = "";
	String MAKER_CODE					= "";
	String MARKET_TYPE_CODE				= "";

	String MODEL_NO						= "";
	String MAKER_FLAG					= "";
	String MODEL_FLAG					= "";
	String ATTACH_NO					= "";
	String ATTACH_COUNT					= "";
	String MAKE_AMT_CODE				="";

	String material_name	= "";
	String KTGRM_NAME = "";
	String KTGRM = "";
	
	String WID  = "";
    String HGT = "";
    
    for ( int i = 0; i<wf.getRowCount(); i++) {

        ITEM_NO      		 			= wf.getValue("ITEM_NO"     			    ,   i);
        ITEM_GROUP						= wf.getValue("ITEM_GROUP"					,	i);
        MATERIAL_CLASS2      			= wf.getValue("MATERIAL_CLASS2"     	    ,   i);
        MATERIAL_TYPE					= wf.getValue("MATERIAL_TYPE" 				,	i);
        MATERIAL_TYPE_NAME				= wf.getValue("MATERIAL_TYPE_NAME" 			,	i);
        MATERIAL_CLASS2_NAME 			= wf.getValue("MATERIAL_CLASS2_NAME"	    ,   i);
        MATERIAL_CLASS1_NAME 			= wf.getValue("MATERIAL_CLASS1_NAME"	    ,   i);
        MATERIAL_CLASS1     			= wf.getValue("MATERIAL_CLASS1"	            ,   i);
        MATERIAL_CTRL_TYPE 				= wf.getValue("MATERIAL_CTRL_TYPE"   		,   i);
        MATERIAL_CTRL_TYPE_NAME 		= wf.getValue("MATERIAL_CTRL_TYPE_NAME"   	,   i);
        DESCRIPTION_LOC      			= wf.getValue("DESCRIPTION_LOC"     	    ,   i);
        ITEM_ABBREVIATION				= wf.getValue("ITEM_ABBREVIATION"		    ,	i);
        BASIC_UNIT           			= wf.getValue("BASIC_UNIT"          	    ,   i);
        MAKER_NAME           			= wf.getValue("MAKER_NAME"          	    ,   i);
        RELEASE_FLAG         			= wf.getValue("RELEASE_FLAG"        	    ,   i);
        ATTACH_INDEX					= wf.getValue("ATTACH_INDEX"			    ,	i);
        MARKET_TYPE						= wf.getValue("MARKET_TYPE"					,   i);
        DELIVERY_LT						= wf.getValue("DELIVERY_LT"					,	i);
        APP_TAX_CODE					= wf.getValue("APP_TAX_CODE"			    ,   i);
        //ITEM_BLOCK_FLAG					= wf.getValue("ITEM_BLOCK_FLAG"				,	i);
        ITEM_BLOCK_FLAG     			=   wf.getValue("ITEM_BLOCK_FLAG", i).equals("Y")?"구매정지 ":"구매가능";;
        MAKER_ITEM_NO					= wf.getValue("MAKER_ITEM_NO"			    ,	i);
        DO_FLAG 			   			= wf.getValue("DO_FLAG" 			        ,	i);
		QI_FLAG							= wf.getValue("QI_FLAG"						,	i);
		PROXY_ITEM_NO	       			= wf.getValue("PROXY_ITEM_NO"	            ,	i);
		Z_WORK_STAGE_FLAG      			= wf.getValue("Z_WORK_STAGE_FLAG"         	,	i);
		Z_DELIVERY_CONFIRM_FLAG			= wf.getValue("Z_DELIVERY_CONFIRM_FLAG"   	,	i);
        MAKER_CODE						= wf.getValue("MAKER_CODE"					,   i);
        MARKET_TYPE_CODE					= wf.getValue("Z_MARKET_TYPE_CODE"		,	i);
        if(RELEASE_FLAG.equals("Y"))
            RELEASE_FLAG_NAME 			= "YES";
        else RELEASE_FLAG_NAME 			= "NO";
        INTEGRATED_BUY_FLAG  			= wf.getValue("INTEGRATED_BUY_FLAG" 	    ,   i);
        if(INTEGRATED_BUY_FLAG.equals("Y"))
            INTEGRATED_BUY_NAME 		= "통합구매";
        else {
            INTEGRATED_BUY_NAME 		= "자체구매";
            COMPANY_CODE_NAME    		= wf.getValue("COMPANY_CODE_NAME"   	    ,   i);
        }
        IMAGE_FILE_PATH      			= wf.getValue("IMAGE_FILE_PATH"     	    ,   i);
        IMAGE_FILE_NAME      			= wf.getValue("IMAGE_FILE_NAME"     	    ,   i);
        DRAWING_NO1       				= wf.getValue("DRAWING_NO1"      			,   i);
        OLD_ITEM_NO          			= wf.getValue("OLD_ITEM_NO"         	    ,   i);
        Z_ITEM_DESC          			= wf.getValue("Z_ITEM_DESC"         	    ,   i);
        SPECIFICATION    				= wf.getValue("SPECIFICATION"   		    ,   i);
        REMARK    						= wf.getValue("REMARK"   				    ,   i);

        ITEM_GROUP_CODE					= wf.getValue("Z_ITEM_GROUP"   				,   i);
		Z_PURCHASE_TYPE 				= wf.getValue("Z_PURCHASE_TYPE"   			,   i);
		Z_PURCHASE_TYPE_CODE			= wf.getValue("Z_PURCHASE_TYPE_CODE"		,   i);

        REQ_USER_ID          			= wf.getValue("REQ_USER_ID"         	    ,   i);
        REQ_DATE             			= wf.getValue("REQ_DATE"            	    ,   i);
        REQ_TYPE             			= wf.getValue("REQ_TYPE"            	    ,   i);
        CONFIRM_STATUS       			= wf.getValue("CONFIRM_STATUS"      	    ,   i);
        DATA                 			= wf.getValue("DATA"                	    ,   i);
        DATA_TYPE            			= wf.getValue("DATA_TYPE"           	    ,   i);
        CONFIRM_DATE         			= wf.getValue("CONFIRM_DATE"        	    ,   i);
        CONFIRM_USER_NAME    			= wf.getValue("CONFIRM_USER_NAME"   	    ,   i);
        MODEL_NO             			= wf.getValue("MODEL_NO"            		,   i);
        ATTACH_NO            			= wf.getValue("ATTACH_NO"            		,   i);
        ATTACH_COUNT            		= wf.getValue("ATTACH_CNT"            		,   i);

        REQ_DATE            			= SepoaString.dateStr(REQ_DATE);
		CONFIRM_DATE        			= SepoaString.dateStr(CONFIRM_DATE);
		ITEM_BLOCK_FLAG_ON 				= ITEM_BLOCK_FLAG.equals("Y")?"checked":"";
		Z_WORK_STAGE_FLAG_ON  			= Z_WORK_STAGE_FLAG.equals("Y")?"checked":"";
		Z_DELIVERY_CONFIRM_FLAG_ON      = Z_DELIVERY_CONFIRM_FLAG.equals("Y")?"checked":"";
		DO_FLAG_ON		                = DO_FLAG.equals("Y")?"checked":"";
		QI_FLAG_ON				        = QI_FLAG.equals("Y")?"checked":"";
	  	MAKER_FLAG						= wf.getValue("MAKER_FLAG"   ,   i);
	  	MODEL_FLAG						= wf.getValue("MODEL_FLAG"   ,   i);
	  	KTGRM_NAME						= wf.getValue("KTGRM_NAME"   ,   i);
	  	KTGRM							= wf.getValue("KTGRM"   ,   i);
	  	MAKE_AMT_CODE					= wf.getValue("MAKE_AMT_CODE"   	  	,   i);

        //2012.03.28 카테고리 수정(기존 : 세분류만 나옴, 수정 : 최종분류를 보여줌)
        if(MATERIAL_CLASS2 != null && !MATERIAL_CLASS2.equals("") && MATERIAL_CLASS2_NAME != null && !MATERIAL_CLASS2_NAME.equals("")){
        	material_name = MATERIAL_CLASS2_NAME;
        }else if(MATERIAL_CLASS1 != null && !MATERIAL_CLASS1.equals("") && MATERIAL_CLASS1_NAME != null && !MATERIAL_CLASS1_NAME.equals("")){
        	material_name = MATERIAL_CLASS1_NAME;
        }else if(MATERIAL_CTRL_TYPE != null && !MATERIAL_CTRL_TYPE.equals("") && MATERIAL_CTRL_TYPE_NAME != null && !MATERIAL_CTRL_TYPE_NAME.equals("")){
        	material_name = MATERIAL_CTRL_TYPE_NAME;
        }else if(MATERIAL_TYPE != null && !MATERIAL_TYPE.equals("") && MATERIAL_TYPE_NAME != null && !MATERIAL_TYPE_NAME.equals("")){
        	material_name = MATERIAL_TYPE_NAME;
        }
        
        WID  = wf.getValue("WID"   ,   i);
        HGT = wf.getValue("HGT"   ,   i);
    }
    if( ITEM_NO.equals("") ){
		title = "품목 등록요청 승인";
	} else {
		title = "품목 변경요청 승인";
	}

    
    //단위결정기준
    String make_amt_codes = ListBox(request, "SL0018",  info.getSession("HOUSE_CODE")+"#M799", MAKE_AMT_CODE);

    String G_IMG_ICON = "/images/ico_zoom.gif";
    
    
    
    
    
    
    String top_code  = "";
	String middle_code  = "";
	boolean isNumber = false;
	int length = 0;
	
	if("".equals(ITEM_NO)){
		top_code = "";
	}else{
		//isNumber = java.util.regex.Pattern.matches("^[0-9a-zA-Z가-힣]*$","asdfsadf");
		isNumber = StringUtils.isNumeric(ITEM_NO);
		length = ITEM_NO.length();
		
		if(isNumber){
			if(length == 6){
				if("1".equals(ITEM_NO.substring(0,1))){ //일반집기
					top_code = "02";
					middle_code = "02001";
				}else if("2".equals(ITEM_NO.substring(0,1))){ //일반기구
					top_code = "02";
					middle_code = "02002";
				}else if("3".equals(ITEM_NO.substring(0,1))){ //전산기기
					top_code = "02";
					middle_code = "02003";
				}else if("4".equals(ITEM_NO.substring(0,1))){ //사무기기
					top_code = "02";
					middle_code = "02004";
				}else if("5".equals(ITEM_NO.substring(0,1))){ //간판류
					top_code = "02";
					middle_code = "02005";
				}else if("6".equals(ITEM_NO.substring(0,1))){ //차량류
					top_code = "02";
					middle_code = "02006";
				}else if("7".equals(ITEM_NO.substring(0,1))){ //서화류
					top_code = "02";
					middle_code = "02007";
				}else if("8".equals(ITEM_NO.substring(0,1))){ //안전관리장비
					top_code = "02";
					middle_code = "02008";
				}else if("9".equals(ITEM_NO.substring(0,1))){ //기타
					top_code = "02";
					middle_code = "02009";
				}
			}else if(length == 10){
				if("20".equals(ITEM_NO.substring(0,2))){ //중용증서
					top_code = "01";
					middle_code = "01020";
				}else if("30".equals(ITEM_NO.substring(0,2))){ //용도품
					top_code = "01";
					middle_code = "01030";
				}else if("91".equals(ITEM_NO.substring(0,2))){ //안내장
					top_code = "03";
					middle_code = "03091";
				}
			}else if(length == 14){
				if("92".equals(ITEM_NO.substring(0,2))){ //홍보물
					top_code = "03";
					middle_code = "03092";
				}
			}
		}
	}
	
/*
    KTGRM
	02	경상비
	03	자본예산
	04	준경상비
	05	용도품/중요증서
*/
	if("02".equals(top_code)){
		KTGRM = "03";
	}
	
	if("01020".equals(middle_code) || "01030".equals(middle_code)){
		KTGRM = "05";
	}
	
	if("03091".equals(middle_code)){
		KTGRM = "02";
	}
	
	if("03092".equals(middle_code)){
		KTGRM = "04";
	}
	
    
    
    
    
    
    
    
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-kr">
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
var G_HOUSE_CODE   = "<%=house_code%>";
var G_COMPANY_CODE = "<%=company_code%>";

function trim(target){
	return target.replace(/(^\s*)|(\s*$)/gi, "");
}

function isNumber(s){
	s += "";
	s = s.replace(/(^\s*)|(\s*$)/g, "");
	
	if(s == '' || isNaN(s)){
		return false;
	}
	
	return true;
}

function Code_Search1(){
	var house_code = "<%=house_code%>";

	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0241&function=D&values=<%=house_code%>&values=&values=";
	var left = 50;
	var top = 100;
	var width = 650;
	var height = 450;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	//var SpecCodeWin = window.open( url, 'SpecCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	//SpecCodeWin.focus();
	CodeSearchCommon(url, 'SpecCodeWin', left, top, width, height);
}

function SP0241_getCode(a,b) {
	document.forms[0].PRODUCT_ID.value = a;
	document.forms[0].PRODUCT_ID_NAME.value = b;

}

function Code_Search2(){
  	var url = "/kr/admin/basic/material/mcl_bd_lis2.jsp?app_flag=Y&item_no=<%=ITEM_NO%>";

	var left = 50;
	var top = 100;
	var width = 850;
	var height = 530;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'yes';
	var resizable = 'no';
	var SpecCodeWin = window.open( url, 'Category', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	SpecCodeWin.focus();
}

function Category(MATERIAL_TYPE, MATERIAL_CTRL_TYPE, MATERIAL_CLASS1, MATERIAL_CLASS2, MATERIAL_CLASS2_NAME, PR_FLAG) {
	document.forms[0].MATERIAL_CLASS2.value = MATERIAL_CLASS2;
	document.forms[0].MATERIAL_CLASS2_NAME.value = MATERIAL_CLASS2_NAME;
	document.forms[0].MATERIAL_TYPE.value = MATERIAL_TYPE;
	document.forms[0].MATERIAL_CTRL_TYPE.value = MATERIAL_CTRL_TYPE;
	document.forms[0].MATERIAL_CLASS1.value = MATERIAL_CLASS1;
	document.forms[0].PR_FLAG.value = PR_FLAG;
	
	if(MATERIAL_TYPE == 'OS'){
		document.forms[0].KTGRM.selectedIndex = 2;
	}
	else{
		document.forms[0].KTGRM.selectedIndex = 0;
	}
}

function changeValue() {
	var value = document.form1.ITEM_GROUP.value;
}

var push = "false";
var old_item = "";

function Change() {
	var makeAmtCode             = document.getElementById("MAKE_AMT_CODE");
	var specification           = document.getElementById("SPECIFICATION");
  	var specificationSplitArray = null;
  	var width                   = null;
  	var height                  = null;

	if(document.forms[0].MATERIAL_CLASS2_NAME.value==""){
		alert("카테고리를 선택하세요.");
		return;
	}
	if(document.forms[0].DESCRIPTION_LOC.value==""){
		alert("품목명은 필수입니다.");
		return;
	}

	if(document.forms[0].BASIC_UNIT.value==""){
		alert("기본단위를 선택하세요.");
		return;
	}

	if(document.forms[0].KTGRM.value==""){
		alert("계정그룹을 선택하세요.");
		return;
	}
	
	if(makeAmtCode.value == ""){
		alert("단위결정기준을 선택하세요.");
		
		return;
	}
	else if(makeAmtCode.value == "01"){
		if(document.forms[0].WID.value == "" || document.forms[0].HGT.value == ""){
  			alert("가로 * 세로를 입력하여 주세요.\n입력예시 : 100*100");
  			return;
  		}else{
  			width  = isNumber(trim(document.forms[0].WID.value));
  			height = isNumber(trim(document.forms[0].HGT.value));
  			if(width == false){
  				alert("가로를 숫자로 입력하여 주십시오.");
  				document.forms[0].WID.focus();
  				return;
  			}
  			  			
  			if(height == false){
  				alert("세로를 숫자로 입력하여 주십시오.");
  				document.forms[0].HGT.focus();
  				return;
  			}
  		}
  	}
	else if(makeAmtCode.value == "02"){
		if(document.forms[0].WID.value == ""){
  			alert("가로를 입력하여 주세요.\n입력예시 : 100");
  			document.forms[0].WID.focus();
  			return;
		}else if(document.forms[0].HGT.value != ""){
			alert("가로만 입력하여 주세요.\n입력예시 : 100");
			document.forms[0].HGT.select();
  			return;
  		}else{
  			width  = isNumber(trim(document.forms[0].WID.value));
  			if(width == false){
  				alert("가로를 숫자로 입력하여 주십시오.");
  				document.forms[0].WID.select();
  				return;
  			}
  		}
	}
	else if(makeAmtCode.value == "03"){
		if(document.forms[0].HGT.value == ""){
  			alert("세로를 입력하여 주세요.\n입력예시 : 100");
  			document.forms[0].HGT.focus();
  			return;
		}else if(document.forms[0].WID.value != ""){
			alert("세로만 입력하여 주세요.\n입력예시 : 100");
			document.forms[0].WID.select();
  			return;
  		}else{
  			height  = isNumber(trim(document.forms[0].HGT.value));
  			if(height == false){
  				alert("세로를 숫자로 입력하여 주십시오.");
  				document.forms[0].HGT.select();
  				return;
  			}
  		}
	}
	else{
		if(document.forms[0].WID.value != ""){
  			alert("단위결정이 M2,가로 인경우만 가로 입력가능합니다.");
  			document.forms[0].WID.select();
  			return;
		}
		
		if(document.forms[0].HGT.value != ""){
  			alert("단위결정이 M2,세로 인경우만 세로 입력가능합니다.");
  			document.forms[0].HGT.select();
  			return;
		}		
	}
	/*
  	else if((makeAmtCode.value == "02") || (makeAmtCode.value == "03")){
  		if(isNumber(trim(specification.value)) == false){
  			alert("사양을 숫자로 입력하여 주십시오.");
				
			return;
  		}
  	}
	*/
	
	/*
	else if(makeAmtCode.value == "01"){
  		specificationSplitArray = specification.value.split("*");
  		
  		if(specificationSplitArray.length != 2){
  			alert("사양에 가로 * 세로를 입력하여 주세요.\n입력예시 : 100*100");
  			
  			return;
  		}
  		else{
  			width  = isNumber(trim(specificationSplitArray[0]));
  			height = isNumber(trim(specificationSplitArray[1]));
  			
  			if(width == false || height == false){
  				alert("가로 세로 사양을 숫자로 입력하여 주십시오.");
  				
  				return;
  			}
  		}
  	}
  	else if((makeAmtCode.value == "02") || (makeAmtCode.value == "03")){
  		if(isNumber(trim(specification.value)) == false){
  			alert("사양을 숫자로 입력하여 주십시오.");
				
			return;
  		}
  	}
	*/

	if(!confirm("품목등록요청 승인 하시겠습니까?")) {
			return;
	}
	else{
		//document.attachFrame.setData();	//startUpload
		var f = document.forms[0];

		document.forms[0].MAKER_FLAG.value = (true == document.forms[0].MAKER_FLAG.checked)?"Y":"N";
		document.forms[0].MODEL_FLAG.value = (true == document.forms[0].MODEL_FLAG.checked)?"Y":"N";
		
		form1.method = "POST";
		form1.target = "childFrame";
		form1.action = "confirm_wk_upd1.jsp";
		form1.submit();
	}
}

function rMateFileAttach(att_mode, view_type, file_type, att_no) {
	var f = document.forms[0];

	f.att_mode.value   = att_mode;
	f.view_type.value  = view_type;
	f.file_type.value  = file_type;
	f.tmp_att_no.value = att_no;

	if (att_mode == "S") {
		f.method = "POST";
		f.target = "attachFrame";
		f.action = "/rMateFM/rMate_file_attach.jsp";
		f.submit();
	}
}

function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
	var attach_key   = att_no;
	var attach_count = att_cnt;

	var f = document.forms[0];
	f.ATTACH_NO.value    = attach_key;

	document.forms[0].MAKER_FLAG.value = (true == document.forms[0].MAKER_FLAG.checked)?"Y":"N";
	document.forms[0].MODEL_FLAG.value = (true == document.forms[0].MODEL_FLAG.checked)?"Y":"N";
	form1.method = "POST";
	form1.target = "childFrame";
	form1.action = "confirm_wk_upd1.jsp";
	form1.submit();
}

// 같은 품목명이 존재하는 경우
function AfterCheckedSameItem(itemNo, descriptionLoc, rowCount){
	var message = null;
	
	if(rowCount == 1){
		sameItemList = itemNo  + "[" + descriptionLoc + "]\n";
	}
	else{
		sameItemList = itemNo  + "[" + descriptionLoc + "] 외 " + (rowCount - 1) + "건\n";
	}

	if(confirm(sameItemList + "중복된 품목명이 존재합니다. 그래도 승인하시겠습니까?")){
		document.forms[0].isCheckedSameItemName.value = "Y";
		document.forms[0].MAKER_FLAG.value = (true == document.forms[0].MAKER_FLAG.checked)?"Y":"N";
  		document.forms[0].MODEL_FLAG.value = (true == document.forms[0].MODEL_FLAG.checked)?"Y":"N";
		form1.method = "POST";
		form1.target = "childFrame";
		form1.action = "confirm_wk_upd1.jsp";
		form1.submit();
	}
}

function doSave(message, v_status){
	alert(message);
	opener.getQuery();
	parent.close();
}

function SP9053_Popup() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0278&function=selectCode&values=<%=info.getSession("HOUSE_CODE")%>&values=M199&values=&values=/&desc=코드&desc=이름";
	//var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	CodeSearchCommon(url, 'doc', left, top, width, height);
}

function selectCode( maker_code, maker_name) {
	document.form1.MAKER_NAME.value 	= maker_name;
	document.form1.MAKER_CODE.value 	= maker_code;
}

function SP0343_Popup() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0343&function=SP0343_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=M343&values=&values=/&desc=코드&desc=이름";
	//var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	CodeSearchCommon(url, 'doc', left, top, width, height);
}

function SP0348_Popup() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0348&function=SP0348_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=M348&values=&values=/&desc=코드&desc=이름";
	//var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	CodeSearchCommon(url, 'doc', left, top, width, height);
}

function SP0348_getCode(code, text){
	document.form1.MATKL.value = code;
	document.form1.MATKL_NAME.value = text;
}

function SP0343_getCode(code, text){
	document.form1.ITEM_GROUP.value = code;
	document.form1.ITEM_GROUP_NAME.value = text;
}

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } 
    else if(stage==1) {
    	return false;
    }
    else if(stage==2) {
        return true;
    }
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj){
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
    }
    else {
        alert(messsage);
    }
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
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

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0"){
    	alert(msg);
    }
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    }
    
    return true;
}

function onlyNumber(keycode){
	if(keycode >= 48 && keycode <= 57){
	}else {
		return false;
	}
	return true;
}

function onlyNumber2(keycode){
	if((keycode >= 48 && keycode <= 57) || keycode == 46){
	}else {
		return false;
	}
	return true;
}
</script>
</head>
<body onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<%@ include file="/include/sepoa_milestone.jsp" %>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>

	<form name="form1" method="post" action="">
		<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD--%>
		<input type="hidden" name="house_code" value="<%=info.getSession("HOUSE_CODE")%>">
		<input type="hidden" name="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
		<input type="hidden" name="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
		<input type="hidden" name="req_user_id" value="<%=info.getSession("ID")%>">
		<input type="hidden" name="doc_type" value="PR">
		<input type="hidden" name="fnc_name" value="getApproval">
		<input type="hidden" name="ctrl_dept" value="">
		<input type="hidden" name="ctrl_flag" value="">
		<input type="hidden" name="MATERIAL_CLASS1_NAME" value="<%=MATERIAL_CLASS1_NAME%>" >
		<input type="hidden" name="OLD_ITEM_NO" value="<%=OLD_ITEM_NO%>" >
		<input type="hidden" name="REQ_ITEM_NO" value="<%=req_item_no%>" >
		<input type="hidden" name="attachImageUrl">
		<input type="hidden" name="MAKER_FLAG" value="<%=MAKER_FLAG%>">
		<input type="hidden" name="MODEL_FLAG" value="<%=MODEL_FLAG%>">
		<input type="hidden" name="isCheckedSameItemName" value="N">
		<input type="hidden" name="ATTACH_NO" value="<%=ATTACH_NO%>">
	
		<input type="hidden" name="att_mode" value="">
		<input type="hidden" name="view_type" value="">
		<input type="hidden" name="file_type" value="">
		<input type="hidden" name="tmp_att_no" value="">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목명<font style="color: red;">*</font></td>
										<td class="data_td" colspan="3">
											<input type="text" name="DESCRIPTION_LOC"  value="<%=DESCRIPTION_LOC%>" style="width:95%" maxlength="500" class="input_re" onKeyUp="return chkMaxByte(500, this, '품목명');">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;카테고리<font style="color: red;">*</font></td>
										<td width="35%" class="data_td" >
											<input type="hidden"  name="MATERIAL_TYPE"          value="<%=MATERIAL_TYPE%>">
											<input type="hidden"  name="MATERIAL_CTRL_TYPE"		value="<%=MATERIAL_CTRL_TYPE%>">
											<input type="hidden"  name="MATERIAL_CLASS1"   		value="<%=MATERIAL_CLASS1%>">
											<input type="hidden"  name="MATERIAL_CLASS2"    	value="<%=MATERIAL_CLASS2%>">
											<input type="hidden"  name="PR_FLAG"                value="<%=PR_FLAG%>">
											<input type="text"    name="MATERIAL_CLASS2_NAME" 	value="<%=material_name%>" style="width:85%" maxlength="160" class="input_re" readonly >
											&nbsp;
											<a href="javascript:Code_Search2();">
												<img src="<%=G_IMG_ICON%>"  align="absmiddle" border="0">
											</a>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매정지</td>
										<td width="35%" class="data_td" >
											<input type="checkbox" name="ITEM_BLOCK_FLAG" <%=ITEM_BLOCK_FLAG_ON%>>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기본단위<font style="color: red;">*</font></td>
										<td width="35%" class="data_td" >
											<select name="BASIC_UNIT" class="input_re">
												<option value="">:::선택:::</option>
<%
	String listbox1 = ListBox(request, "SL0014", info.getSession("HOUSE_CODE")+ "#M007" , BASIC_UNIT);

	out.println(listbox1);
%>
											</select>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계정그룹</td>
										<td  class="data_td">
											<select name="KTGRM" class="input_re">
												<option value="">:::선택:::</option>
<%
	String ktgrm_listbox2 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+ "#M346" , KTGRM);

	out.println(ktgrm_listbox2);
%>	
											</select>
										</td>
									</tr>
									<tr style="display:none;">
										<td class="se_cell_title">자재유형</td>
										<td class="c_data_1">
											<select name="MTART" class="input_re">
												<option value = "">자재유형</option>
<%
	String mtart_listbox = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+ "#M342" , "");

	out.println(mtart_listbox);
%>
											</select>
										</td>
										<td class="se_cell_title">자재그룹</td>
										<td class="c_data_1">
											<input type="text" name="MATKL_NAME" style="width:90%" class="input_re" readonly>
											<a href="javascript:SP0348_Popup();">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<input type="hidden"  name="MATKL" value="">
										</td>
									</tr>
									<tr style="display:none;">
										<td class="se_cell_title">품목범주</td>
										<td class="c_data_1">
											<input type="text" name="ITEM_GROUP_NAME" style="width:85%" class="input_re" readonly>
											<a href="javascript:SP0343_Popup();">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<input type="hidden"  name="ITEM_GROUP" value="">
										</td>
										<td class="se_cell_title">세금분류</td>
										<td class="c_data_1">
											<select name="TAXKM" class="input_re">
												<option value = "">세금분류</option>
<%
	String taxkm_listbox = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+ "#M344" , "");

	out.println(taxkm_listbox);
%>
											</select>
										</td>
									</tr>
									<tr style="display:none;">
										<td class="se_cell_title">평가클래스</td>
										<td class="c_data_1">
											<select name="BKLAS" class="input_re">
												<option value = "">평가클래스</option>
<%
	String bklas_listbox = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+ "#M345" , "");

	out.println(bklas_listbox);
%>
											</select>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td" style="display: none;">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제조사</td>
										<td width="35%" class="data_td" style="display: none;">
											<input type="text" name="MAKER_CODE" value="<%=MAKER_CODE%>"  size="10" maxlength="22" class="inputsubmit" readOnly>
											<a href="javascript:SP9053_Popup()">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
											</a>
											<input type="text" name="MAKER_NAME"   value="<%=MAKER_NAME%>"  size="50" maxlength="100" class="inputsubmit" readOnly>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;유사품목명</td>
										<td width="35%" class="data_td" colspan="3">
											<input type="text" name="ITEM_ABBREVIATION"  value="<%=ITEM_ABBREVIATION%>" style="width:95%" maxlength="200" onKeyUp="return chkMaxByte(200, this, '유사품목명');" class="inputsubmit">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;단위결정</td>
										<td  class="data_td" >
											<select name = "MAKE_AMT_CODE" id="MAKE_AMT_CODE" class="input_re" >
												<option value="">::선택::</option>
												<%=make_amt_codes%>
				    						</select>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;가로 * 세로</td>
										<td  class="data_td" >
											<input type="text" name="WID"  value="<%=WID%>" size="10" maxlength="14" dir="rtl"  onKeyUp="return chkMaxByte(14, this, '가로');" onKeyPress="return onlyNumber2(event.keyCode);" style="ime-mode:disabled;" >
											*
											<input type="text" name="HGT"  value="<%=HGT%>" size="10" maxlength="14" dir="rtl"  onKeyUp="return chkMaxByte(14, this, '세로');" onKeyPress="return onlyNumber2(event.keyCode);" style="ime-mode:disabled;" >																					
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사양</td>
										<td  class="data_td" colspan="3">
											<textarea name="SPECIFICATION" id="SPECIFICATION" class="inputsubmit" style="overflow=hidden;width: 98%;height: 80px" maxlength="256" onKeyUp="return chkMaxByte(256, this, '사양');"><%=SPECIFICATION%></textarea>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목설명</td>
										<td class="data_td" colspan="3">
											<textarea name="Z_ITEM_DESC" class="inputsubmit" style="overflow=hidden;width: 98%;height: 80px" maxlength="3000" onKeyUp="return chkMaxByte(3000, this, '품목설명');"><%=Z_ITEM_DESC%></textarea>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청내역</td>
										<td class="data_td" colspan="3">
											<textarea name="REMARK" class="inputsubmit" style="overflow=hidden;width: 98%;height: 80px" maxlength="500" onKeyUp="return chkMaxByte(500, this, '요청내역');"><%=REMARK%></textarea>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
										<td class="data_td" colspan="3">
											<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=ATTACH_NO%>&view_type=VI" style="width: 98%;height: 115px; border: 0px;" frameborder="0" ></iframe>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
			<TR>
				<TD height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
<script language="javascript">
	btn("javascript:Change()", "승 인");
</script>
							</TD>
							<TD>
<script language="javascript">
	btn("javascript:parent.close()", "닫 기");
</script>
							</TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>
	</form>
	<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</s:header>
<s:footer/>
</body>
</html>