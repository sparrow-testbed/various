<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("MA_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "MA_005";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
%>
<%--
 Title:        	MA_005  <p>
 Description:  	품목  master수정<p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	DEV.Team Echo<p>
 @version      	1.0.0<p>
 @Comment       ICOMMTGL에서 마스터정보를 가지고 와 수정한다.<p>
 				ICOMMTGL의 ITEM_NO를 이용해 ICOMMTGS의 자재속성을 불러와 수정한다.<p>
 				마스터 수정은 ICOMMTGL,ICOMMTGS를 업데이트하고 INTERFACE를 생성한다.<p>
--%>

<% String WISEHUB_PROCESS_ID="MA_005";%>

<%
    String house_code   = info.getSession("HOUSE_CODE");
    String company_code = info.getSession("COMPANY_CODE");
    
    String user_id          		= info.getSession("ID");
	String user_name_loc    		= info.getSession("NAME_LOC");
	String user_name_eng    		= info.getSession("NAME_ENG");
	String user_dept        		= info.getSession("DEPARTMENT");
	
	
    String Attach_Index = "";
    String item_no = JSPUtil.CheckInjection(request.getParameter("ITEM_NO"));
    String BUY = JSPUtil.CheckInjection(request.getParameter("BUY"));
    SepoaListBox lb = new SepoaListBox();
    
    //WORK필요
    String result = lb.Table_ListBox( request, "SL0200", house_code, "#", "@");
//	String attach_path = CommonUtil.getConfig("wisehub.attach.view.IMAGE");
	String attach_path = "";
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%//@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<%

	
    String[] args={item_no};
	Object[] obj = {args};
	SepoaOut value = ServiceConnector.doService(info, "t0002", "CONNECTION","real_getReqList1", obj);
	SepoaFormater wf = new SepoaFormater(value.result[0]);

    String ITEM_NO      		= "";
    String ITEM_NAME      		= "";
    String ITEM_GROUP 			= "";
    String ITEM_GROUP_CODE 		= "";
    String REQ_ITEM_NO 			= "";

    String MATERIAL_CLASS1      = "";
    String MATERIAL_CLASS2      = "";
    String MATERIAL_TYPE      	= "";
    String MATERIAL_CTRL_TYPE   = "";
    String MATERIAL_CLASS2_NAME = "";
    String MATERIAL_CLASS1_NAME = "";
    String MATERIAL_CTRL_TYPE_NAME = "";
    String MATERIAL_TYPE_NAME = "";
    String DESCRIPTION_LOC      = "";
    String PRODUCT_ID_NAME      = "";
    String BASIC_UNIT           = "";
    String SALES_CONV_QTY       = "";
    String SALES_UNIT           = "";
    String MAKER_NAME           = "";
    String ORIGIN_COUNTRY       = "";
    String MODEL_NO             = "";
    String RELEASE_FLAG         = "";
    String RELEASE_FLAG_NAME    = "";
    String INTEGRATED_BUY_FLAG  = "";
    String INTEGRATED_BUY_NAME  = "";
    String COMPANY_CODE_NAME    = "";
    String TAX_CODE             = "";
    String SHIPPER_TYPE         = "";
    String IMAGE_FILE_PATH      = "";
    String IMAGE_FILE_NAME 		= "";
    String ATTACH_FILE_PATH     = "";
    String ATTACH_FILE_NAME 	="";
    String CERTIFICATION_NO     = "";
    String DRAWING_NO1       	= "";
    String OLD_ITEM_NO          = "";
    String Z_ITEM_DESC          = "";
    String ITEM_ABBREVIATION    = "";
    String OLD_DESCRIPTION      = "";
    String OLD_SPECIFICATION    = "";
    String SPECIFICATION    	= "";
    String Z_PURCHASE_TYPE_CODE = "";
    String APP_TAX_CODE_CODE 	= "";
    String BOM_ITEM_UNIT 		= "";

    String Z_PURCHASE_TYPE 		= "";
    String PROXY_ITEM_NO 		= "";
    String APP_TAX_CODE 		= "";
    String DELIVERY_LT 			= "";
    String MARKET_TYPE 			= "";
    String MARKET_TYPE_CODE 	= "";
    String CATALOG_USER_ID      = "";
    String SOURCING_USER_ID     = "";

    String REQ_USER_ID          = "";
    String REQ_DATE             = "";
    String REQ_TYPE             = "";
    String CONFIRM_STATUS       = "";
    String DATA            		= "";
    String DATA_TYPE            = "";
    String CONFIRM_DATE         = "";
    String CONFIRM_USER_NAME    = "";
    String REMARK 				= "";
    String QI_FLAG 				= "";

    String MAKER_ITEM_NO        = "";
    String ITEM_BLOCK_FLAG      = "";
    String USEDFLAG             = "";
    String Z_WORK_STAGE_FLAG    = "";
    String Z_DELIVERY_CONFIRM_FLAG = "";
    String DO_FLAG 				= "";
    String MAKER_CODE 			= "";

	String MAKER_FLAG			= "";
	String MODEL_FLAG			= "";
	String ATTACH_NO					= "";
	String ATTACH_COUNT  				= "";

	String ITEM_GROUP_NAME				= "";
	String TAXKM_NAME					= "";
	String KTGRM_NAME					= "";
	String BKLAS_NAME					= "";
	String MTART_NAME					= "";
	String MATKL_NAME					= "";

	String N_ITEM_GROUP				= "";
	String N_TAXKM					= "";
	String N_KTGRM					= "";
	String N_BKLAS					= "";
	String N_MTART					= "";
	String N_MATKL					= "";
	String MAKE_AMT_CODE        	= "";
    String WID  = "";
	String HGT = "";
	
	String ABOL_RSN = "";

	String material_name = "";
	
	
	
    for ( int i = 0; i<wf.getRowCount(); i++) {

        ITEM_NO      			= wf.getValue("ITEM_NO"     		,   i);
        ITEM_NAME      			= wf.getValue("ITEM_NAME"     		,   i);
        ITEM_GROUP 				= wf.getValue("ITEM_GROUP"			, 	i);
        ITEM_GROUP_CODE 		= wf.getValue("ITEM_GROUP_LOC"		, 	i);
        REQ_ITEM_NO 			= wf.getValue("REQ_ITEM_NO"			, 	i);
        MAKER_ITEM_NO 			= wf.getValue("MAKER_ITEM_NO"		, 	i);
        MATERIAL_CLASS1      	= wf.getValue("MATERIAL_CLASS1"     ,   i);
        MATERIAL_CLASS2      	= wf.getValue("MATERIAL_CLASS2"     ,   i);
        MATERIAL_TYPE      		= wf.getValue("MATERIAL_TYPE"     	,   i);
        MATERIAL_CTRL_TYPE      = wf.getValue("MATERIAL_CTRL_TYPE"	,   i);
        MATERIAL_CLASS2_NAME 	= wf.getValue("MATERIAL_CLASS2_NAME",   i);
        MATERIAL_CLASS1_NAME 	= wf.getValue("MATERIAL_CLASS1_NAME",   i);
        MATERIAL_CTRL_TYPE_NAME = wf.getValue("MATERIAL_CTRL_TYPE_NAME",   i);
        MATERIAL_TYPE_NAME      = wf.getValue("MATERIAL_TYPE_NAME",   i);
        
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
        
        DESCRIPTION_LOC      	= wf.getValue("DESCRIPTION_LOC"     ,   i);
        PRODUCT_ID_NAME      	= wf.getValue("PRODUCT_NAME"     	,   i);
        BASIC_UNIT           	= wf.getValue("BASIC_UNIT"          ,   i);
        SALES_CONV_QTY       	= wf.getValue("SALES_CONV_QTY"      ,   i);
        SALES_UNIT           	= wf.getValue("SALES_UNIT"          ,   i);
        MAKER_NAME           	= wf.getValue("MAKER_NAME"          ,   i);
        MAKER_CODE           	= wf.getValue("MAKER_CODE"          ,   i);
        ORIGIN_COUNTRY       	= wf.getValue("ORIGIN_COUNTRY"      ,   i);
        MODEL_NO             	= wf.getValue("MODEL_NO"            ,   i);
        ATTACH_NO            	= wf.getValue("ATTACH_NO"           ,   i);
        ATTACH_COUNT            = wf.getValue("ATTACH_COUNT"        ,   i);
        RELEASE_FLAG         	= wf.getValue("RELEASE_FLAG"        ,   i);
        Z_PURCHASE_TYPE_CODE 	= wf.getValue("Z_PURCHASE_TYPE_CODE", 	i);
        if(RELEASE_FLAG.equals("Y"))
            RELEASE_FLAG_NAME = "YES";
        else RELEASE_FLAG_NAME = "NO";
        INTEGRATED_BUY_FLAG  = wf.getValue("INTEGRATED_BUY_FLAG" ,   i);
        TAX_CODE             = wf.getValue("TAX_CODE"            ,   i);
        SHIPPER_TYPE         = wf.getValue("SHIPPER_TYPE"        ,   i);
        IMAGE_FILE_PATH      = wf.getValue("IMAGE_FILE_PATH"     ,   i);
        IMAGE_FILE_NAME      = wf.getValue("IMAGE_FILE_NAME"     ,   i);
        ATTACH_FILE_PATH     = wf.getValue("ATTACH_FILE_PATH"    ,   i);
        ATTACH_FILE_NAME     = wf.getValue("ATTACH_FILE_NAME"    ,   i);
        CERTIFICATION_NO     = wf.getValue("CERTIFICATION_NO"    ,   i);
        DRAWING_NO1          = wf.getValue("DRAWING_NO1"      	 ,   i);
        OLD_ITEM_NO          = wf.getValue("OLD_ITEM_NO"         ,   i);
        Z_ITEM_DESC          = wf.getValue("Z_ITEM_DESC"         ,   i);
        ITEM_ABBREVIATION 	 = wf.getValue("ITEM_ABBREVIATION"	 , 	 i);
        OLD_DESCRIPTION      = wf.getValue("OLD_DESCRIPTION"     ,   i);
        OLD_SPECIFICATION    = wf.getValue("OLD_SPECIFICATION"   ,   i);
        SPECIFICATION    	 = wf.getValue("SPECIFICATION"   	 ,   i);
        BOM_ITEM_UNIT 		 = wf.getValue("BOM_ITEM_UNIT"		 , 	 i);

		Z_PURCHASE_TYPE 	= wf.getValue("Z_PURCHASE_TYPE"   	 ,   i);
		PROXY_ITEM_NO 		= wf.getValue("PROXY_ITEM_NO"   	 ,   i);
		APP_TAX_CODE_CODE 	= wf.getValue("Z_APP_TAX_CODE_CODE"	 ,   i);

		APP_TAX_CODE 		= wf.getValue("APP_TAX_CODE"   		,   i);
		DELIVERY_LT 		= wf.getValue("DELIVERY_LT"   		,   i);
		MARKET_TYPE 		= wf.getValue("MARKET_TYPE"   		,   i);
		MARKET_TYPE_CODE 	= wf.getValue("MARKET_TYPE_CODE"	, 	i);
		REMARK 				= wf.getValue("REMARK"     			,   i);

        CATALOG_USER_ID     = wf.getValue("CATALOG_USER_ID"     ,   i);
        SOURCING_USER_ID    = wf.getValue("SOURCING_USER_ID"    ,   i);

        REQ_USER_ID         = wf.getValue("REQ_USER_ID"         ,   i);
        REQ_DATE            = wf.getValue("REQ_DATE"            ,   i);
        REQ_TYPE            = wf.getValue("REQ_TYPE"            ,   i);
        CONFIRM_STATUS      = wf.getValue("CONFIRM_STATUS"      ,   i);
        DATA                = wf.getValue("DATA"                ,   i);
        DATA_TYPE           = wf.getValue("DATA_TYPE"           ,   i);
        CONFIRM_DATE        = wf.getValue("CONFIRM_DATE"        ,   i);
        CONFIRM_USER_NAME   = wf.getValue("CONFIRM_USER_NAME"   ,   i);

        REQ_DATE            =   SepoaString.dateStr(REQ_DATE);
		CONFIRM_DATE        =   SepoaString.dateStr(CONFIRM_DATE);

		QI_FLAG             =  wf.getValue("QI_FLAG"   ,   i).equals("Y")?"checked":"";;
		DO_FLAG             =   wf.getValue("DO_FLAG"   ,   i).equals("Y")?"checked":"";;
		ITEM_BLOCK_FLAG     =   wf.getValue("ITEM_BLOCK_FLAG"   ,   i).equals("Y")?"checked":"";;
		USEDFLAG            =   wf.getValue("USEDFLAG"   ,   i).equals("Y")?"checked":"";;
		Z_WORK_STAGE_FLAG   =  wf.getValue("Z_WORK_STAGE_FLAG"   ,   i).equals("Y")?"checked":"";;
		Z_DELIVERY_CONFIRM_FLAG =   wf.getValue("Z_DELIVERY_CONFIRM_FLAG"   ,   i).equals("Y")?"checked":"";;

	  	MAKER_FLAG			= wf.getValue("MAKER_FLAG"   ,   i) ;
	  	MODEL_FLAG			= wf.getValue("MODEL_FLAG"   ,   i) ;

	  	ITEM_GROUP_NAME					= wf.getValue("ITEM_GROUP_NAME"   	    	,   i);
	  	TAXKM_NAME						= wf.getValue("TAXKM_NAME"   	    	,   i);
	  	KTGRM_NAME						= wf.getValue("KTGRM_NAME"   	    	,   i);
	  	BKLAS_NAME						= wf.getValue("BKLAS_NAME"   	    	,   i);
	  	MTART_NAME						= wf.getValue("MTART_NAME"   	    	,   i);
	  	MATKL_NAME						= wf.getValue("MATKL_NAME"   	    	,   i);

	  	N_ITEM_GROUP					= wf.getValue("N_ITEM_GROUP"   	    	,   i);
	  	N_TAXKM							= wf.getValue("N_TAXKM"   	    	,   i);
	  	N_KTGRM							= wf.getValue("N_KTGRM"   	    	,   i);
	  	N_BKLAS							= wf.getValue("N_BKLAS"   	    	,   i);
	  	N_MTART							= wf.getValue("N_MTART"   	    	,   i);
	  	N_MATKL							= wf.getValue("N_MATKL"   	    	,   i);
	  	MAKE_AMT_CODE					= wf.getValue("MAKE_AMT_CODE"   	,   i);

	  	WID                                   = wf.getValue("WID"   	,   i);
	 	HGT                                  = wf.getValue("HGT"   	,   i);
	 	
	 	ABOL_RSN                        = wf.getValue("ABOL_RSN"   	,   i);
    }
    
    //단위결정기준
    String make_amt_codes = ListBox(request, "SL0018",  info.getSession("HOUSE_CODE")+"#M799", MAKE_AMT_CODE);

%>

<script language="javascript">
var INDEX_MANDATORY_FLAG;
var INDEX_ATTRIBUTE_ID;
var INDEX_ATTRIBUTE_NAME;
var INDEX_ATTRIBUTE_VALUE;

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

function setAttach_ITEM(mode)
{
    document.forms[0].ATTACH_INDEX.value=mode;
    if(mode=="ITEM")
    {
        if(document.forms[0].ATTACH_FILE_PATH.value == "") {
            FileAttach('ITEM','','');
        } else {
            FileAttachChange('ITEM', document.forms[0].ATTACH_FILE_PATH.value);
        }
    }else{
        if(document.forms[0].IMAGE_FILE_PATH.value == "") {
            FileAttach('IMAGE','','');
        } else {
            FileAttachChange('IMAGE', document.forms[0].IMAGE_FILE_PATH.value);
        }
    }
}

/* function setAttach(attach_key, arrAttrach, attach_count)
{
    var attachname = "";
    if(arrAttrach != "")
    {
        attachname = arrAttrach[0].toString().split(',')[4];
    }

    if(document.forms[0].ATTACH_INDEX.value=="ITEM")
    {
        document.forms[0].ATTACH_FILE_PATH.value = attach_key;
        document.forms[0].ATTACH_FILE_NAME.value =  attachname;

        if(attach_count > 0) {

        } else if(attach_count == 0){
            document.forms[0].ATTACH_FILE_PATH.value = "";
        }
    }else{
        document.forms[0].IMAGE_FILE_PATH.value = attach_key;
        document.forms[0].IMAGE_FILE_NAME.value =  attachname;

        if(attach_count > 0) {

        } else if(attach_count == 0){
            document.forms[0].IMAGE_FILE_PATH.value = "";
        }
    }
} */

/* 파일 등록 */
function goAttach(attach_no){
	attach_file(attach_no,"IMAGE");
}

function setAttach(attach_key, arrAttrach, rowid, attach_count) {
	document.forms[0].attach_no.value = attach_key;
	document.forms[0].attach_no_count.value = attach_count;
}


function Code_Search1()
{
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

function Code_Search2()
{
	//var url = "/kr/master/new_material/category_popup.jsp";
	
	var url = "/kr/admin/basic/material/mcl_bd_lis2.jsp?app_flag=Y&item_no=<%=ITEM_NO%>";
	var left = 50;
	var top = 100;
	var width = 950;
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
	document.forms[0].material_class2.value = MATERIAL_CLASS2;
	document.forms[0].material_class2_name.value = MATERIAL_CLASS2_NAME;
	document.forms[0].material_type.value = MATERIAL_TYPE;
	document.forms[0].material_ctrl_type.value = MATERIAL_CTRL_TYPE;
	document.forms[0].material_class1.value = MATERIAL_CLASS1;
	document.forms[0].pr_flag.value = PR_FLAG;
}

/*
function Category(a,b,c,d,e,f) {
	document.forms[0].MATERIAL_CLASS2.value = d;
	document.forms[0].MATERIAL_CLASS2_NAME.value = e;
	document.forms[0].MATERIAL_TYPE.value = a;
	document.forms[0].MATERIAL_CTRL_TYPE.value = b;
	document.forms[0].MATERIAL_CLASS1.value = c;
	document.forms[0].PR_FLAG.value = f;
	
}
*/

function PR_FLAG()
{
    if(document.forms[0].PR_FLAG.value == "P" )
    {
		<%--
		document.forms[0].input_flag.checked = false;
        document.forms[0].input_flag.disabled = true;
        document.forms[0].input_flag1.checked = false;
		--%>
		//document.forms[0].SHIPPER_TYPE.value = "D";
		//document.forms[0].SHIPPER_TYPE.disabled = true;
		<%--
		document.forms[0].UNIT_PRICE.readOnly = true;
        document.forms[0].CONTRACT_FROM_DATE.readOnly = true;
        document.forms[0].CONTRACT_TO_DATE.readOnly = true;
        document.forms[0].AUTO_EXT_FLAG.disabled = true;
        document.forms[0].MIN_ORDER_QTY.readOnly = true;
        document.forms[0].DELIVERY_LT.readOnly = true;
        document.forms[0].PAY_TERMS.disabled = true;
        document.forms[0].DELEY_TERMS.disabled = true;
		--%>
    } else {
		<%--
		document.forms[0].input_flag.checked = true;
        document.forms[0].input_flag.disabled = false;
        document.forms[0].input_flag1.checked = true;
		--%>
        //document.forms[0].SHIPPER_TYPE.disabled = false;
		<%--
		document.forms[0].UNIT_PRICE.readOnly = false;
        document.forms[0].CONTRACT_FROM_DATE.readOnly = false;
        document.forms[0].CONTRACT_TO_DATE.readOnly = false;
        document.forms[0].AUTO_EXT_FLAG.disabled = false;
        document.forms[0].MIN_ORDER_QTY.readOnly = false;
        document.forms[0].DELIVERY_LT.readOnly = false;
        document.forms[0].PAY_TERMS.disabled = false;
        document.forms[0].DELEY_TERMS.disabled = false;
		--%>
    }
    Query();
}

function goSubmit() {
	document.form1.method="post";
	document.form1.action = "req_bd_lis1.jsp";
	document.form1.submit();
}

var approval_str_value = "";
var sign_status = "P";

function doRemove(getName) {
 	if(getName == "MAKER_FLAG"){
		document.form1.maker_name.value 	= "";
		document.form1.maker_code.value 	= "";
	}else{
		document.form1.model_no.value 	= "";
	}
}

function doModify(flag) {
	var	wise                    = GridObj;
  	var	sel_row	                = -1;
  	var makeAmtCode             = document.getElementById("make_amt_code");
  	var specification           = document.getElementById("specification");
  	var specificationSplitArray = null;
  	var width                   = null;
  	var height                  = null;
	
  	var pfrm = document.forms[0];
  	
  	if(pfrm.abol_rsn.value != ""){
  		alert('폐기건은 수정이 불가합니다.');
  		return;
  	}
  	
  	if (pfrm.material_class2_name.value == "") {
  		alert('카테고리가 선택되지 않았습니다.');
  		return;
  	}
  	if (pfrm.ktgrm.value == "") {
  		alert('계정그룹이 선택되지 않았습니다.');
  		return;
  	}
  	if (pfrm.description_loc.value == "") {
  		alert('품목명이 입력되지 않았습니다.');
  		return;
  	}
  	
  	if (pfrm.basic_unit.value == "") {
  		alert('기본단위가 선택되지 않았습니다.');
  		return;
  	}
  	
  	if(makeAmtCode.value == ""){
		alert("단위결정기준을 선택하세요.");
		
		return;
	}
	else if(makeAmtCode.value == "01"){
		if(document.forms[0].WID.value == "" || document.forms[0].HGT.value == ""){
  			alert("가로 * 세로를 입력하여 주세요.\n입력예시 : 100*100");
  			document.forms[0].WID.focus();
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
  	if(makeAmtCode.value == "01"){
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
  	
	if(!confirm("품목정보를 수정 하시겠습니까?")) {
		return;
	} else {
		//document.attachframe.setdata();	//startupload
		//첨부 후 함수 직접 호출
		//setrMateFileAttach('','','','');
	
		
		pfrm.item_block_flag.value = (true == pfrm.item_block_flag.checked)?"Y":"N";
		pfrm.usedflag.value = (true == pfrm.usedflag.checked)?"Y":"N";
		pfrm.method = "post";
		pfrm.target = "childFrame";
		pfrm.action = "real_wk_upd2.jsp";
		pfrm.submit();
		
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
	f.attach_no.value    = attach_key;

   	document.forms[0].item_block_flag.value = (true == document.forms[0].item_block_flag.checked)?"Y":"N";
   	document.forms[0].usedflag.value = (true == document.forms[0].usedflag.checked)?"Y":"N";
   	form1.method = "post";
	form1.target = "childFrame";
	form1.action = "real_wk_upd2.jsp";
	form1.submit();
} 

function doSave(message, v_status){
	alert(message);
	parent.close();
}

function setAttachFile() {
	form1.attachImageUrl.value = "<%=attach_path+"/"%>";
}

function viewImage() {
	var left = 187; var top = 134;
	var resizable = "yes";
	var toolbar = "no"; var menubar = "no"; var status = "no"; var scrollbars = "yes";
	var url = "mat_pp_dis3.jsp?source=" + form1.attachImageUrl.value+"&doc_no="+form1.IMAGE_FILE_PATH.value+"&item_no=<%=item_no%>&description_loc=<%=DESCRIPTION_LOC%>&specification=<%=SPECIFICATION.replaceAll("\"","")%>";
	
	if(url != "") {
		var width = 100;
		var height = 100;
		var view = window.open(url, 'view', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		view.focus();
	}
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
	document.form1.maker_name.value 	= maker_name;
	document.form1.maker_code.value 	= maker_code;
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

function SP0348_getCode(code, text)
{
	document.form1.MATKL.value = code;
	document.form1.MATKL_NAME.value = text;
}

function SP0343_getCode(code, text)
{
	document.form1.ITEM_GROUP.value = code;
	document.form1.ITEM_GROUP_NAME.value = text;
}
</script>




<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
	
    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
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
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
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
<!--내용시작-->

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="title_page">품목 수정
	</td>
</tr>
</table>

<form name="form1" method="post" action="">
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
	<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD--%>
	<input type="hidden" name="house_code" 		    id="house_code" 		    value="<%=info.getSession("HOUSE_CODE")%>">
	<input type="hidden" name="company_code" 	    id="company_code" 	        value="<%=info.getSession("COMPANY_CODE")%>">
	<input type="hidden" name="dept_code" 		    id="dept_code" 		        value="<%=info.getSession("DEPARTMENT")%>">
	<input type="hidden" name="req_user_id" 	    id="req_user_id" 	        value="<%=info.getSession("ID")%>">
	<input type="hidden" name="doc_type" 		    id="doc_type" 		        value="PR">
	<input type="hidden" name="fnc_name" 		    id="fnc_name" 		        value="getApproval">
	<input type="hidden" name="ctrl_dept" 		    id="ctrl_dept" 		        value="">
	<input type="hidden" name="ctrl_flag" 		    id="ctrl_flag" 		        value="">
    <input type="hidden" name="attachimageurl"      id="attachimageurl"         value="">         
    <input type="hidden" name="old_item_no" 	    id="old_item_no" 	        value="<%=OLD_ITEM_NO%>">
    <input type="hidden" name="maker_flag" 		    id="maker_flag" 		    value="<%=MAKER_FLAG%>">
    <input type="hidden" name="model_flag" 		    id="model_flag" 		    value="<%=MODEL_FLAG%>">
	<%-- <input type="hidden" name="attach_no" 		    id="attach_no" 		        value="<%=ATTACH_NO%>"> --%>
	<input type="hidden" name="att_mode"            id="att_mode"               value="">
	<input type="hidden" name="view_type"           id="view_type"              value="">
	<input type="hidden" name="file_type"           id="file_type"              value="">
	<input type="hidden" name="tmp_att_no"          id="tmp_att_no"             value="">
	<input type="hidden" name="material_type"       id="material_type"          value="<%=MATERIAL_TYPE%>">
	<input type="hidden" name="material_ctrl_type"	id="material_ctrl_type"	    value="<%=MATERIAL_CTRL_TYPE%>">
	<input type="hidden" name="material_class1"   	id="material_class1"   	    value="<%=MATERIAL_CLASS1%>">
	<input type="hidden" name="material_class2"    	id="material_class2"    	value="<%=MATERIAL_CLASS2%>">
	<input type="hidden" name="pr_flag"				id="pr_flag"				value="">
	<input type="hidden" name="abol_rsn"		    id="abol_rsn"				value="<%=ABOL_RSN%>">
	
    <tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목코드</td>
		<td class="data_td">
		    <input type="text" name="item_no" id="item_no" value="<%=ITEM_NO%>" style="width:92%" maxlength="30" class="input_data2" readOnly>
		</td>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용유무</td>
		<td class="data_td">
			<input type="checkbox" name="item_block_flag" id="item_block_flag" class="inputsubmit" <%=ITEM_BLOCK_FLAG%> style="display:none;">
			<input type="checkbox" name="usedflag" id="usedflag" class="inputsubmit" <%=USEDFLAG%> >*체크는 사용함
		</td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>	
	<tr>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;카테고리</td>
		<td width="35%" class="data_td" >
			<input type="text" name="material_class2_name" id="material_class2_name" 	value="<%=material_name%>" style="width:70%" maxlength="160" class="input_re" readonly >&nbsp;<a href="javascript:Code_Search2();"><img src="/images/button/butt_query.gif"  align="absmiddle" border="0"></a>
		</td>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계정그룹</td>
		<td  class="data_td">
			<select name="ktgrm" id="ktgrm" class="input_re">
				<option value="">:::선택:::</option>
				<%
				String ktgrm_listbox = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+ "#M346" , N_KTGRM);
				out.println(ktgrm_listbox);
				%>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>	
	<tr>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목명</td>
		<td class="data_td" colspan="3">
			<input type="text" name="description_loc" id="description_loc" value="<%=DESCRIPTION_LOC%>" size="80" maxlength="100" class="input_re">
		</td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>	
	<tr>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기본단위</td>
		<td class="data_td">
			<select name="basic_unit" id="basic_unit" class="input_re">
				<option value="<%=BASIC_UNIT%>"><%=BASIC_UNIT%></option>
				<%
				String listbox1 = ListBox(request, "SL0014", info.getSession("HOUSE_CODE")+ "#M007" , BASIC_UNIT);
				out.println(listbox1);
				%>
			</select>
		</td>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제조사</td>
		<td class="data_td">
			<input type="text" name="maker_code" id="maker_code" value="<%=MAKER_CODE%>" style="width:30%" maxlength="22" class="inputsubmit" readOnly>
			<a href="javascript:SP9053_Popup()"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"></a>
			<input type="text" name="maker_name" id="maker_name"   value="<%=MAKER_NAME%>" style="width:54%" maxlength="100" class="input_data1" readOnly>
		</td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>	
	<tr>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;단위결정기준</td>
		<td class="data_td" >
	      	<select name = "make_amt_code" id="make_amt_code" class="inputsubmit" >
				<%=make_amt_codes%>
		    </select>
		</td>
		<td width="16%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;가로 * 세로</td>
		<td  class="data_td">
			<input type="text" name="WID"  value="<%=WID%>" size="10" maxlength="14" dir="rtl"  onKeyUp="return chkMaxByte(14, this, '가로');" onKeyPress="return onlyNumber2(event.keyCode);" style="ime-mode:disabled;" >
				*
			<input type="text" name="HGT"  value="<%=HGT%>" size="10" maxlength="14" dir="rtl"  onKeyUp="return chkMaxByte(14, this, '세로');" onKeyPress="return onlyNumber2(event.keyCode);" style="ime-mode:disabled;" >
		</td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>	
	<tr>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사양</td>
		<td class="data_td"  colspan="3">
	      	<textarea name="specification" id="specification" rows="5" cols="30" style="overflow=hidden;ime-mode:active"><%=SPECIFICATION%></textarea>
		</td>
	</tr>
	<tr style="display:none;">
		<td class="title_td">부가세구분</td>
		<td class="data_td" >
			<select name="app_tax_code" id="app_tax_code" class="input_re">
				<option value = "">과세구분</option>
				<%
				String listbox9 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+ "#M082" , APP_TAX_CODE_CODE);
				out.println(listbox9);
				%>
			</select>
		</td>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;유사품목명</td>
		<td class="data_td">
			<input type="text" name="item_abbreviation" id="item_abbreviation" value="<%=ITEM_ABBREVIATION%>" size="38" onKeyUp="return chkMaxByte(200, this, '유사품목명');">
		</td>
	</tr>

<%--------------------------------------------------------------------------------------------------------------------------------------%>
            <tr style="display:none;">
			  <td class="title_td">자재유형</td>
    		  <td  class="data_td">
    		      <select name="mtart" id="mtart" class="input_re">
    		      <option value = "">자재유형</option>
<%
    		        String mtart_listbox = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+ "#M342" , N_MTART);
    		        out.println(mtart_listbox);
%>
    		      </select>
    		  </td>
    		  <td class="title_td">자재그룹</td>
    		  <td  class="data_td">
    		  	<input type="text" name="matkl_name" id="matkl_name" size="20" class="input_re" readonly value="<%=MATKL_NAME %>">
				<a href="javascript:SP0348_Popup();">
					<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
				</a>
				<input type="hidden"  name="matkl" id="matkl" value="<%=N_MATKL %>">
    		  </td>
    		</tr>
    		<tr style="display:none;">
			  <td class="title_td">품목범주</td>
    		  <td  class="data_td">
    		  	<input type="text" name="item_group_name" id="item_group_name" size="20" class="input_re" readonly value="<%=ITEM_GROUP_NAME %>">
				<a href="javascript:SP0343_Popup();">
					<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
				</a>
				<input type="hidden"  name="item_group" id="item_group" value="<%=N_ITEM_GROUP %>">
    		  </td>
    		  <td class="title_td">세금분류</td>
    		  <td  class="data_td">
    		    <select name="taxkm" id="taxkm" class="input_re">
    		    <option value = "">세금분류</option>
<%
    		        String taxkm_listbox = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+ "#M344" , N_TAXKM);
    		        out.println(taxkm_listbox);
%>
    		      </select>
    		  </td>
    		</tr>
    		<tr style="display:none;">
    		  <td class="title_td">평가클래스</td>
    		  <td class="data_td">
    		    <select name="bklas" id="bklas" class="input_re" disabled>
    		    <option value = "">평가클래스</option>
<%
    		        String bklas_listbox = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+ "#M345" , N_BKLAS);
    		        out.println(bklas_listbox);
%>
    		      </select>
    		  </td>
    		</tr>
<%--------------------------------------------------------------------------------------------------------------------------------------%>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>	
	<tr>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목설명</td>
		<td class="data_td" colspan="3">
			<textarea name="z_item_desc" id="z_item_desc" rows="5" cols="80" style="overflow=hidden;ime-mode:active"><%=Z_ITEM_DESC%></textarea>
		</td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>	
	<tr>
	   	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청내역</td>
	    <td class="data_td" colspan="3">
	      	<textarea name="remark" id="remark" rows="5" cols="80"  style="overflow=hidden;ime-mode:active"><%=REMARK%></textarea>
	    </td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>	
	<tr>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
		<td class="data_td" colspan="3" height="150">
			<script language="javascript">
						btn("javascript:goAttach(document.getElementById('attach_no').value);", "파일등록");
					</script>
					<input type="text" size="3" readOnly class="input_empty" value="<%=ATTACH_COUNT %>" name="attach_no_count" id="attach_no_count"/>
					<input type="hidden" value="<%=ATTACH_NO %>" name="attach_no" id="attach_no">
			
			<!-- <iframe name="attachFrame" width="520" height="150" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
			<br>&nbsp; -->
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
			<TD><script language="javascript">btn("javascript:doModify('R')","수 정")</script></TD>
			<TD><script language="javascript">btn("javascript:parent.close()","닫 기")</script></TD>
		</TR>
		</TABLE>
</TR>
</TABLE>


</form>

</s:header>
<%-- <s:grid screen_id="MA_005" grid_obj="GridObj" grid_box="gridbox"/> --%>
<s:footer/>
</body>
</html>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
<%-- <script language="javascript">rMateFileAttach('S','C','ITEM',form1.ATTACH_NO.value);</script> --%>


