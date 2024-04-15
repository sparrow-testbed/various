<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%!
private String nvl(String str) throws Exception{
	String result = null;
	
	result = this.nvl(str, "");
	
	return result;
}

private String nvl(String str, String defaultValue) throws Exception{
	String result = null;
	
	if(str == null){
		str = "";
	}
	
	if(str.equals("")){
		result = defaultValue;
	}
	else{
		result = str;
	}
	
	return result;
}

private boolean isAdmin(SepoaInfo info){
	String  adminMenuProfileCode = null;
	String  menuProfileCode      = null;
	String  propertiesKey        = null;
	String  houseCode            = info.getSession("HOUSE_CODE");
	boolean result               = false;
	
	try {
		menuProfileCode      = info.getSession("MENU_PROFILE_CODE");
		menuProfileCode      = this.nvl(menuProfileCode);
		propertiesKey        = "wise.all_admin.profile_code." + houseCode;
		adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);
		
   		if (menuProfileCode.equals(adminMenuProfileCode)){
   			result = true;
    	} else {
   			propertiesKey        = "wise.admin.profile_code." + houseCode;
			adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);
		
			if (menuProfileCode.equals(adminMenuProfileCode)){
    			result = true;
	    	} else {
				propertiesKey        = "wise.ict_admin.profile_code." + houseCode;
				adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);

				if (menuProfileCode.equals(adminMenuProfileCode)){
	    			result = true;
			    }
			}
    	}
	} catch (Exception e) {
		result = false;
	}
	
	return result;
}

private String getDateSlashFormat(String target) throws Exception{
	String       result       = null;
	StringBuffer stringBuffer = new StringBuffer();
	
	stringBuffer.append(target.subSequence(0, 4)).append("/").append(target.substring(4, 6)).append("/").append(target.substring(6, 8));
	
	result = stringBuffer.toString();
	
	return result;
}
%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("MA_018");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "MA_018";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
	
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
    String to_time = SepoaDate.getShortTimeString();
	
    
%>
<%--
 Title:        	t0002  <p>
 Description:  	품목  목록<p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	DEV.Team Echo<p>
 @version      	1.0.0<p>
 @Comment       실제 제조업체의 공장 단위를 의미.<p>
 				소요량 관리의 기준이 된다.<p>
 				하나의 PlantUnit은 하나의 Company에 종속되나,여러개의 Operating Unit에 연결되어 질 수 있으므로,<p>
 				Plant를 개별로 생성후 OperatingUnit에 연결해 주는 Assign부분이 별도로 존재한다.<p>
--%>

<% String WISEHUB_PROCESS_ID="MA_018";%>

<%
    String house_code      = info.getSession("HOUSE_CODE");
    String company_code    = info.getSession("COMPANY_CODE");
    String company_code_nm = info.getSession("COMPANY_NAME");
    String user_id         = info.getSession("ID");
    String name_loc        = info.getSession("NAME_LOC");
    String dept            = info.getSession("DEPARTMENT");
    String ctrl_code       = info.getSession("CTRL_CODE");


    //첨부파일 보기 PATH
	//Config conf = new Configuration();
	//String server_name = conf.get("wise.ip.info");
	//String attach_path = CommonUtil.getConfig("wisehub.attach.view.IMAGE");
	String attach_path = "";
	String gate         = JSPUtil.nullToRef(request.getParameter("gate"),""); // 외부에서 접근하였을 경우 flag
	
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_pbc_bd_lis1"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
	
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">


var INDEX_SELECTED;
var INDEX_DEPT;                   
var INDEX_ITEM_NO;      
var INDEX_DESCRIPTION_LOC;

var INDEX_CRE_GB;               
var INDEX_DSTR_GB;             

var INDEX_STK_QTY;             
var INDEX_NTC_QTY;             
var INDEX_ABOL_QTY;            

var INDEX_STK_USER_ID;         
var INDEX_STK_USER_NAME_LOC;   
var INDEX_STK_DATE;            
var INDEX_STK_TIME;            

var INDEX_NTC_YN;              
var INDEX_NTC_LOC;             
var INDEX_NTC_LOC_ETC;         

var INDEX_NTC_USER_ID;         
var INDEX_NTC_USER_NAME_LOC;   
var INDEX_NTC_DATE;            
var INDEX_NTC_TIME;            

var INDEX_ABOL_YN;             
var INDEX_ABOL_USER_ID;        
var INDEX_ABOL_USER_NAME_LOC;  
var INDEX_ABOL_DATE;           
var INDEX_ABOL_TIME;     

var INDEX_MATERIAL_TYPE;
var INDEX_MATERIAL_CTRL_TYPE;
var INDEX_MATERIAL_CLASS1;
var INDEX_MATERIAL_CLASS2;

var INDEX_IMAGE_FILE_PATH;
var INDEX_IMAGE_FILE;

function Init()
{
	setGridDraw();
	setHeader();

	// GridObj.setColHidden("0|1|2|3|4",false);
	
	
    // 2011.3.28 정민석  기본 조회 조건을 대분류-상품으로 조회
    //form1.MATERIAL_TYPE.value = "HW";
    //doSelect();
    var dept = "<%=dept%>";
    /*
    if(dept == "CBE"){
    	document.form1.ITEM_GROUP.value = "2";
	} else if(dept == "CBD"){
    	document.form1.ITEM_GROUP.value = "1";
	} else {
    	document.form1.ITEM_GROUP.value = "3";
	}
	*/	
<%--    INTEGRATED_BUY_change(); --%>
}

function setHeader()
{
    INDEX_SELECTED                                =   GridObj.GetColHDIndex("SELECTED");
    INDEX_DEPT                                    =   GridObj.GetColHDIndex("DEPT");
    INDEX_ITEM_NO                                 =   GridObj.GetColHDIndex("ITEM_NO");
    
    INDEX_DESCRIPTION_LOC                         =   GridObj.GetColHDIndex("DESCRIPTION_LOC");
    
    INDEX_CRE_GB                                  =   GridObj.GetColHDIndex("CRE_GB");
    INDEX_DSTR_GB                                 =   GridObj.GetColHDIndex("DSTR_GB");
    
    INDEX_STK_QTY                                 =   GridObj.GetColHDIndex("STK_QTY");
    INDEX_NTC_QTY                                 =   GridObj.GetColHDIndex("NTC_QTY");
    INDEX_ABOL_QTY                                =   GridObj.GetColHDIndex("ABOL_QTY");
    
    INDEX_STK_USER_ID                             =   GridObj.GetColHDIndex("STK_USER_ID");
    INDEX_STK_USER_NAME_LOC                       =   GridObj.GetColHDIndex("STK_USER_NAME_LOC");
    INDEX_STK_DATE                                =   GridObj.GetColHDIndex("STK_DATE");
    INDEX_STK_TIME                                =   GridObj.GetColHDIndex("STK_TIME");
    
    INDEX_NTC_YN                                  =   GridObj.GetColHDIndex("NTC_YN");
    INDEX_NTC_LOC                                 =   GridObj.GetColHDIndex("NTC_LOC");
    INDEX_NTC_LOC_ETC                             =   GridObj.GetColHDIndex("NTC_LOC_ETC");
    
    INDEX_NTC_USER_ID                             =   GridObj.GetColHDIndex("NTC_USER_ID");
    INDEX_NTC_USER_NAME_LOC                       =   GridObj.GetColHDIndex("NTC_USER_NAME_LOC");
    INDEX_NTC_DATE                                =   GridObj.GetColHDIndex("NTC_DATE");
    INDEX_NTC_TIME                                =   GridObj.GetColHDIndex("NTC_TIME");
    
    INDEX_ABOL_YN                                 =   GridObj.GetColHDIndex("ABOL_YN");
    INDEX_ABOL_USER_ID                            =   GridObj.GetColHDIndex("ABOL_USER_ID");
    INDEX_ABOL_USER_NAME_LOC                      =   GridObj.GetColHDIndex("ABOL_USER_NAME_LOC");
    INDEX_ABOL_DATE                               =   GridObj.GetColHDIndex("ABOL_DATE");
    INDEX_ABOL_TIME                               =   GridObj.GetColHDIndex("ABOL_TIME");  
        
    INDEX_MATERIAL_TYPE                           =   GridObj.GetColHDIndex("MATERIAL_TYPE");  
    INDEX_MATERIAL_CTRL_TYPE                      =   GridObj.GetColHDIndex("MATERIAL_CTRL_TYPE");  
    INDEX_MATERIAL_CLASS1                         =   GridObj.GetColHDIndex("MATERIAL_CLASS1");  
    INDEX_MATERIAL_CLASS2                         =   GridObj.GetColHDIndex("MATERIAL_CLASS2"); 
    
    INDEX_IMAGE_FILE_PATH                         =   GridObj.GetColHDIndex("IMAGE_FILE_PATH"); 
    INDEX_IMAGE_FILE                              =   GridObj.GetColHDIndex("IMAGE_FILE"); 
}

var G_SERVLETURL =  "<%=POASRM_CONTEXT_NAME%>/servlets/master.pbc.pbc_bd_lis1";


function doSelect()
{
    var ITEM_NO             = LRTrim(form1.item_no.value);
    var MATERIAL_TYPE       = form1.material_type.value;
    var MATERIAL_CTRL_TYPE  = form1.material_ctrl_type.value;
    var MATERIAL_CLASS1     = form1.material_class1.value;
    var MATERIAL_CLASS2     = form1.material_class2.value;
    var MAKER_CODE			= form1.maker_code.value;
    var MODEL_NO			= "";
    var CERTIFICATION       = "";
    var ITEM_BLOCK_FLAG 	= form1.item_block_flag.value;
	var DESCRIPTION_LOC		= LRTrim(form1.description_loc.value);

 	 if(DESCRIPTION_LOC == "" &&  MATERIAL_TYPE == ""){
	    	alert("품목명, 대분류 중 하나는 필수입력입니다.");
	    	return;
	 } 

	var add_date_start      = LRTrim(form1.add_date_start.value);
	var add_date_end        = LRTrim(form1.add_date_end.value);
/*
	if (add_date_start != "" || add_date_end != "") {
		if ((add_date_start == "") || (add_date_end == "")) {
			alert("생성일자를 확인하세요.");
			return;
		}
	}
*/
<%--     servletUrl =  "<%=getWiseServletPath("master.pbc.real_bd_lis1") %>"; --%>
   
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getItemList";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);
    
   /*  GridObj.SetParam("ITEM_NO", ITEM_NO);
    GridObj.SetParam("MATERIAL_TYPE", MATERIAL_TYPE);
    GridObj.SetParam("MATERIAL_CTRL_TYPE", MATERIAL_CTRL_TYPE);
    GridObj.SetParam("MATERIAL_CLASS1", MATERIAL_CLASS1);
    GridObj.SetParam("MATERIAL_CLASS2", MATERIAL_CLASS2);
    GridObj.SetParam("MAKER_CODE", MAKER_CODE);
    GridObj.SetParam("MODEL_NO", MODEL_NO);
    GridObj.SetParam("INTEGRATED_BUY_FLAG", "");
    GridObj.SetParam("COMPANY_CODE", "");
    GridObj.SetParam("CERTIFICATION", CERTIFICATION);
    GridObj.SetParam("SYNONYM_NAME", "");
	GridObj.SetParam("UNIT_PRICE", "");
	GridObj.SetParam("ITEM_BLOCK_FLAG", ITEM_BLOCK_FLAG);
	GridObj.SetParam("DESCRIPTION_LOC", DESCRIPTION_LOC);
	GridObj.SetParam("add_date_start",  add_date_start);
	GridObj.SetParam("add_date_end",    add_date_end);

    GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
	GridObj.SendData(servletUrl);
    GridObj.strHDClickAction="sortmulti"; */
    
    

}

function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
	var max_row = GridObj.GetRowCount();
	var maxcol  = GridObj.GetColCount();

    if(msg1 == "t_imagetext") {
        var left = 30;
        var top = 30;
        var toolbar = 'no';
        var menubar = 'no';
        var status = 'yes';
        var scrollbars = 'yes';
        var resizable = 'no';
        var width = "";
        var height = "";
        
        if(msg3 == INDEX_ITEM_NO || msg3 == INDEX_DESCRIPTION_LOC) {
            var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);
            //var BUY = GD_GetCellValueIndex(GridObj,msg2,INDEX_INTEGRATED_FLAG);
            //var BUY = GD_GetCellValueIndex(GridObj,msg2,INDEX_INTEGRATED_FLAG);
            width = 750;
            height = 550;

           /* if(GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_GROUP) == "2"){
            	var url = "real_pp_lis1_1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
            } else if(GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_GROUP) == "1"){
            	var url = "real_pp_lis1_2.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
            } else if(GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_GROUP) == "3"){
            	var url = "real_pp_lis1_3.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
            } else if(GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_GROUP) == "5"){
            	var url = "real_pp_lis1_4.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
            } else {
            	var url = "real_pp_lis1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
            }
            */
            var url = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";

            var PoDisWin =window.open(url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
            PoDisWin.focus();
        } else if(msg3 == INDEX_SALES_VIEW) {
            var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);
            width = 750;
            height = 550;
            var url = "/kr/master/new_material/pay_pp_lis.jsp?ITEM_NO="+ITEM_NO;
            var PoDisWin =window.open(url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
            PoDisWin.focus();
        } else if(msg3 == INDEX_IMAGE) {
            var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2, INDEX_ITEM_NO);
            var DESCRIPTION_LOC = GD_GetCellValueIndex(GridObj,msg2, INDEX_DESCRIPTION_LOC);
            var SPECIFICATION = GD_GetCellValueIndex(GridObj,msg2, INDEX_SPECIFICATION);
            var IMAGE_FILE_PATH = GD_GetCellValueIndex(GridObj,msg2, INDEX_IMAGE);
            if(IMAGE_FILE_PATH != "") {
                viewImage(ITEM_NO, DESCRIPTION_LOC, SPECIFICATION, IMAGE_FILE_PATH);
            }
        }
    }
    if(msg3 == INDEX_SELECTED)
    {
        oneSelect(max_row, msg1, msg2);
    }
}

function oneSelect(max_row, msg1, msg2)
{
    var noSelect = "";
    if(msg1 != "t_header" && GD_GetCellValueIndex(GridObj,msg2,INDEX_SELECTED) == "false") noSelect = "Y";
    for(var i=0;i<max_row;i++)  {
        GD_SetCellValueIndex(GridObj,i,INDEX_SELECTED,"false", "&");
    }
    if(msg1 != "t_header" && noSelect != "Y") GD_SetCellValueIndex(GridObj,msg2,INDEX_SELECTED,"true", "&");
}



function Code_Search()
{
    var url = "/kr/master/new_material/category_popup.jsp";
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
function Category(a,b,c,d,e,f) {
    document.forms[0].material_class2.value = d;
    document.forms[0].material_class2_name.value = e;

}
function INTEGRATED_BUY_change() {
    clearCOMPANY_CODE();
    var id = "SL0006";
    var value = form1.INTEGRATED_BUY_FLAG.value;
    if( "<%=info.getSession("COMPANY_CODE")%>" == "L00"){
        xWork.location.href = "req_company_hidden.jsp";
    }else setCOMPANY_CODE("<%=info.getSession("COMPANY_NAME")%>", "<%=info.getSession("COMPANY_CODE")%>");
}
function clearCOMPANY_CODE() {
    if(form1.COMPANY_CODE.length > 0) {
        for(i=form1.COMPANY_CODE.length-1; i>=0;  i--) {
            form1.COMPANY_CODE.options[i] = null;
        }
    }
}
function setCOMPANY_CODE(name, value) {
    var option1 = new Option(name, value, true);
    form1.COMPANY_CODE.options[form1.COMPANY_CODE.length] = option1;
}

function MATERIAL_TYPE_Changed()
{
	clearMATERIAL_CTRL_TYPE();
    clearMATERIAL_CLASS1();
    clearMATERIAL_CLASS2();
    setMATERIAL_CLASS1("전체", "");
    setMATERIAL_CLASS2("전체", "");
    var id = "SL0009";
    var code = "M041";
    form1.material_type.value = "03";
    
    var value = form1.material_type.value;
    target = "MATERIAL_TYPE";
    data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    xWork.location.href = data;
}
function MATERIAL_CTRL_TYPE_Changed()
{
    clearMATERIAL_CLASS1();
    clearMATERIAL_CLASS2();
    setMATERIAL_CLASS2("전체", "");
    var id = "SL0019";
    var code = "M042";
    var value = form1.material_ctrl_type.value;
    target = "MATERIAL_CTRL_TYPE";
    data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    xWork.location.href = data;
}

function MATERIAL_CLASS1_Changed()
{
    clearMATERIAL_CLASS2();
    var id = "SL0089";
    var code = "M122";
    var value = form1.material_class1.value;
    target = "MATERIAL_CLASS1";
    data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    xWork.location.href = data;
}
function clearMATERIAL_CTRL_TYPE() {
    if(form1.material_ctrl_type.length > 0) {
        for(i=form1.material_ctrl_type.length-1; i>=0;  i--) {
            form1.material_ctrl_type.options[i] = null;
        }
    }
}
function setMATERIAL_CTRL_TYPE(name, value) {
    var option1 = new Option(name, value, true);
    form1.material_ctrl_type.options[form1.material_ctrl_type.length] = option1;
}
function clearMATERIAL_CLASS1() {
    if(form1.material_class1.length > 0) {
        for(i=form1.material_class1.length-1; i>=0;  i--) {
            form1.material_class1.options[i] = null;
        }
    }
}
function setMATERIAL_CLASS1(name, value) {
    var option1 = new Option(name, value, true);
    form1.material_class1.options[form1.material_class1.length] = option1;
}
function clearMATERIAL_CLASS2() {
    if(form1.material_class2.length > 0) {
        for(i=form1.material_class2.length-1; i>=0;  i--) {
            form1.material_class2.options[i] = null;
        }
    }
}
function setMATERIAL_CLASS2(name, value) {
    var option1 = new Option(name, value, true);
    form1.material_class2.options[form1.material_class2.length] = option1;
}

function viewImage(item_no, description_loc, specification, image_file_path) {
	var left = 187; var top = 134;
	var resizable = "yes";
	var toolbar = "no"; var menubar = "no"; var status = "no"; var scrollbars = "yes";
    var attachImageUrl = "<%=attach_path%>";

	var url = "mat_pp_dis3.jsp?source=" + attachImageUrl + "&doc_no=" + image_file_path + "&item_no=" + item_no + "&description_loc=" + description_loc + "&specification=" + specification;

	if(url != "") {
		var width = 100;
		var height = 100;

		var view = window.open(url, 'view', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		view.focus();
	}
}

function num_check(){
	var value = add_comma(form1.UNIT_PRICE.value,2);
	form1.UNIT_PRICE.value = value;
}

function add_date_start(year,month,day,week) {
  		document.form1.add_date_start.value=year+month+day;
}

function add_date_end(year,month,day,week) {
  		document.form1.add_date_end.value=year+month+day;
}

function searchProfile(fc) {
	if(fc =="maker_code"){
		window.open("/common/CO_014.jsp?callback=SP0054_getCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}
}


function SP0054_getCode(code, text1, text2) {
	document.forms[0].maker_code.value = code;
	document.forms[0].maker_name.value = text1;
}	

<%-- 
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

    //var url = "/s_kr/admin/info/hico_code_search_pop.jsp?title=제조사 Code 검색&type=M199";
	//window.open( url, 'Category', 'left=50, top=100, width=500, height=450, toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=no');
}
function selectCode( maker_code, maker_name) {
	document.form1.maker_name.value 	= maker_name;
	document.form1.maker_code.value 	= maker_code;
}
--%>

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
	
var gRowId;

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    
    var left = 30;
    var top = 30;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'no';
    var width = "";
    var height = "";
    
    /*
    if(cellInd == INDEX_ITEM_NO) {
    	var ITEM_NO = GridObj.cells(rowId, INDEX_ITEM_NO).getValue()		//GD_GetCellValueIndex(GridObj,rowId,INDEX_ITEM_NO);
        width = 750;
        height = 550;
        
        if("C" == GridObj.cells(rowId, GridObj.getColIndexById("CRUD")).getValue() && ITEM_NO == ""){
        	var url = "/kr/catalog/cat_pp_lis_main.jsp?isSingle=Y";
        	gRowId = rowId;
        } else {
        	var MATERIAL_TYPE      = GridObj.cells(rowId, GridObj.getColIndexById("MATERIAL_TYPE")).getValue();
        	var MATERIAL_CTRL_TYPE = GridObj.cells(rowId, GridObj.getColIndexById("MATERIAL_CTRL_TYPE")).getValue();
        	var MATERIAL_CLASS1    = GridObj.cells(rowId, GridObj.getColIndexById("MATERIAL_CLASS1")).getValue();
        	var MATERIAL_CLASS2    = GridObj.cells(rowId, GridObj.getColIndexById("MATERIAL_CLASS2")).getValue();
        	
        	var url;
        	        	
        	if( MATERIAL_TYPE == "03"){ //홍보물
        		if( MATERIAL_CTRL_TYPE == "03091" ){ // 안내장
        			url = "http://barcode.woorifg.com/StckMgr/SRU/SRIF0001_PopImage.aspx?Name=" + ITEM_NO 
        		}else if( MATERIAL_CTRL_TYPE == "03092" ){ // e-홍보물
        			//자동화기기홍모물
        			if( MATERIAL_CLASS1 == "03092099" ){
        				url = "http://wpms.woorifg.com/PR/Common/a_CommDownload.aspx?Name=" + ITEM_NO 
        			}else{
        				url = "http://wpms.woorifg.com/PR/Common/CommImgWriter.aspx?FLAG=2&Name=" + ITEM_NO
        			}
        		}       		
        	}        	
        }
        
        var PoDisWin =window.open(url, 'ItemCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
        PoDisWin.focus();
        
        
    }else
    */
    

    
    if(cellInd == INDEX_IMAGE_FILE){
    	var ITEM_NO = GridObj.cells(rowId, INDEX_ITEM_NO).getValue()		//GD_GetCellValueIndex(GridObj,rowId,INDEX_ITEM_NO);
		var IMAGE_FILE_PATH = GridObj.cells(rowId, INDEX_IMAGE_FILE_PATH).getValue()		//GD_GetCellValueIndex(GridObj,rowId,INDEX_ITEM_NO); 
		
		if(IMAGE_FILE_PATH != null && IMAGE_FILE_PATH != "") {
			
			var url    = "/common/image_view_popup.jsp";
// 			var title  = "이미지보기";
// 			var param  = "item_no=" + item_no;
			
// 			popUpOpen01(url, title, "850", "650", param);
			window.open(url + '?item_no=' + ITEM_NO ,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=yes,width=850,height=650,left=0,top=0");
			
		}
    }else if(cellInd == INDEX_ITEM_NO || cellInd == INDEX_DESCRIPTION_LOC) {
    	var ITEM_NO = GridObj.cells(rowId, INDEX_ITEM_NO).getValue()		//GD_GetCellValueIndex(GridObj,rowId,INDEX_ITEM_NO);
        //var BUY = GridObj.cells(rowId, INDEX_INTEGRATED_FLAG).getValue()	     	//GD_GetCellValueIndex(GridObj,rowId,INDEX_INTEGRATED_FLAG);
        //var BUY = GD_GetCellValueIndex(GridObj,msg2,INDEX_INTEGRATED_FLAG);
        width = 750;
        height = 550;

       /* if(GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_GROUP) == "2"){
        	var url = "real_pp_lis1_1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
        } else if(GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_GROUP) == "1"){
        	var url = "real_pp_lis1_2.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
        } else if(GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_GROUP) == "3"){
        	var url = "real_pp_lis1_3.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
        } else if(GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_GROUP) == "5"){
        	var url = "real_pp_lis1_4.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
        } else {
        	var url = "real_pp_lis1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
        }
        */
        
        //var url = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";

        if("C" == GridObj.cells(rowId, GridObj.getColIndexById("CRUD")).getValue()){
        	var url = "/kr/catalog/cat_pp_lis_main.jsp?isSingle=Y";
        	gRowId = rowId;
        } else {
        	var url = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
        }
        
        var PoDisWin =window.open(url, 'ItemCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
        PoDisWin.focus();
    }else if(cellInd == INDEX_NTC_USER_ID || cellInd == INDEX_NTC_USER_NAME_LOC) {
    	
    	gRowId = rowId;
    	var PoDisWin = window.open("/common/CO_008.jsp?callback=ntc_user_callback", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
        PoDisWin.focus();
    }else if(cellInd == INDEX_ABOL_USER_ID || cellInd == INDEX_ABOL_USER_NAME_LOC) {
    	
    	gRowId = rowId;
    	var PoDisWin = window.open("/common/CO_008.jsp?callback=abol_user_callback", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
        PoDisWin.focus();
    }
}

function  ntc_user_callback(ls_ctrl_person_id, ls_ctrl_person_name) {	   
	GridObj.cells(gRowId, GridObj.getColIndexById("NTC_USER_ID")).setValue(ls_ctrl_person_id);
	GridObj.cells(gRowId, GridObj.getColIndexById("NTC_USER_NAME_LOC")).setValue(ls_ctrl_person_name);
	
	GridObj.cells(gRowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	GridObj.cells(gRowId, GridObj.getColIndexById("SELECTED")).setValue("1");
}

function  abol_user_callback(ls_ctrl_person_id, ls_ctrl_person_name) {	   
	GridObj.cells(gRowId, GridObj.getColIndexById("ABOL_USER_ID")).setValue(ls_ctrl_person_id);
	GridObj.cells(gRowId, GridObj.getColIndexById("ABOL_USER_NAME_LOC")).setValue(ls_ctrl_person_name);
	
	GridObj.cells(gRowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	GridObj.cells(gRowId, GridObj.getColIndexById("SELECTED")).setValue("1");
}

function setCatalog(itemNo, descriptionLoc, specification, makerCode, ctrlCode, qty, itemGroup, delyToAddress, unitPrice, ktgrm, makerName, basicUnit, materialType){
	//$("#item_no").val(itemNo);
	//$("#description_loc").val(descriptionLoc);
	
	if("03" != materialType){
		alert("품목 대분류가 'e홍보물플랫폼' 만 선택가능합니다.");
		return false;
	}
	
	
	GridObj.cells(gRowId, GridObj.getColIndexById("ITEM_NO")).setValue(itemNo);
	GridObj.cells(gRowId, GridObj.getColIndexById("DESCRIPTION_LOC")).setValue(descriptionLoc);
	
	//dhtmlx_last_row_id++;
	//var nMaxRow2 = dhtmlx_last_row_id;
	
	//GridObj.enableSmartRendering(true);
	//GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
	//GridObj.selectRowById(nMaxRow2, false, true);
	GridObj.cells(gRowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	GridObj.cells(gRowId, GridObj.getColIndexById("SELECTED")).setValue("1");
	
	
	return true;
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
        //doQuery();
        doSelect();
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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}

//지우기
function doRemove( type ){
    if( type == "maker_code" ) {
    	document.forms[0].maker_code.value = "";
        document.forms[0].maker_name.value = "";
    }  
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}





function SP0149_Popup() {
// 	var left = 0;
// 	var top = 0;
// 	var width = 570;
// 	var height = 500;
// 	var toolbar = 'no';
// 	var menubar = 'no';
// 	var status = 'yes';
// 	var scrollbars = 'no';
// 	var resizable = 'no';
<%-- 	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0149&function=SP0149_Popup_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=&values=/&desc=&desc="; --%>
// 	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	url = "/kr/catalog/cat_pp_lis_main.jsp?isSingle=Y";
	CodeSearchCommon(url,"INVEST_NO",0,0,"950","530");
}


//그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
function checkRows()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(grid_array.length > 0)
	{
		return true;
	}

	alert("선택된 행이 없습니다.");
	return false;	
}


function doSave()
{
	if(!checkRows()) return;
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	for(var i = 0; i < grid_array.length; i++)
	{
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ITEM_NO")).getValue()))
		{
			alert("품목코드를 선택하세요.");
			return;
		}
		
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("DSTR_GB")).getValue()))
		{
			alert("배부구분을 선택하세요.");
			return;
		}
		
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_YN")).getValue()) )
		{
			alert("게시여부를 선택하세요.");
			return;
		}
		
		if("Y" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_YN")).getValue()) )
		{
			if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_LOC")).getValue()))
			{
				alert("게시위치를 선택하세요.");
				return;
			}
			
			if("9" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_LOC")).getValue()))
			{
				if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_LOC_ETC")).getValue()))
				{
					alert("게시위치(기타)를 입력하세요.");
					return;
				}
			}
			
			if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_USER_NAME_LOC")).getValue()))
			{
				alert("게시자를 선택하세요.");
				return;
			}
			
			if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_DATE")).getValue()))
			{
				alert("게시일자를 선택하세요.");
				return;
			}
					
		}else{
			if("" != LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_LOC")).getValue()))
			{
				alert("미게시인경우 게시위치 선택이 불가합니다.");
				GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_LOC")).setValue("");
				return;
			}
			
			if("" != LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_LOC_ETC")).getValue()))
			{
				alert("미게시인경우 게시위치(기타) 선택이 불가합니다.");
				GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_LOC_ETC")).setValue("");
				return;
			}
			
			if("" != LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_USER_NAME_LOC")).getValue()))
			{
				alert("미게시인경우 게시자 선택이 불가합니다.");
				GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_USER_ID")).setValue("");
				GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_USER_NAME_LOC")).setValue("");
				return;
			}
			
			if("" != LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_DATE")).getValue()))
			{
				alert("미게시인경우 게시일자 선택이 불가합니다.");
				GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_DATE")).setValue("");
				return;
			}
		}
		
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ABOL_YN")).getValue()) )
		{
			alert("폐기여부를 선택하세요.");
			return;
		}
		
		if("Y" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ABOL_YN")).getValue()) )
		{
			if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ABOL_USER_NAME_LOC")).getValue()))
			{
				alert("폐기자를 선택하세요.");
				return;
			}
			
			if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ABOL_DATE")).getValue()))
			{
				alert("폐기일자를 선택하세요.");
				return;
			}
			
			var abol_date = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ABOL_DATE")).getValue()).replace("/","").replace("/","");
			var current_date = "<%=SepoaDate.getShortDateString()%>";
			
			if( parseInt(abol_date) < parseInt(current_date) ){
				alert("폐기일은 현재일 또는 현재일이후 만 가능합니다.");
				return;
			}
			
			
		}else{						
			if("" != LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ABOL_USER_NAME_LOC")).getValue()))
			{
				alert("폐기가 아닌경우 폐기자 선택이 불가합니다.");
				GridObj.cells(grid_array[i], GridObj.getColIndexById("ABOL_USER_ID")).setValue("");
				GridObj.cells(grid_array[i], GridObj.getColIndexById("ABOL_USER_NAME_LOC")).setValue("");
				return;
			}
			
			if("" != LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ABOL_DATE")).getValue()))
			{
				alert("폐기가 아닌경우 폐기일자 선택이 불가합니다.");
				GridObj.cells(grid_array[i], GridObj.getColIndexById("ABOL_DATE")).setValue("");
				return;
			}
		}
		
		if("Y" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ABOL_YN")).getValue()) )
		{
			if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_YN")).getValue()) || "N" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("NTC_YN")).getValue()) )
			{
				alert("게시여부를 선택하세요.");
				return;	
			}
			
		}
		
	}

    if (confirm("저장 하시겠습니까?")) {
        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
        // encodeUrl() 함수를 사용 하셔야 합니다.
    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
	    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
        var cols_ids = "<%=grid_col_id%>";
        
        var params;
    	params = "?mode=save";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    	
	    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
    }
}


function doDelete()
{
	if(!checkRows())
			return;
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	
	
	var rowcount = grid_array.length;
	GridObj.enableSmartRendering(false);
	
	for(var row = rowcount - 1; row >= 0; row--)
	{		
		if("2" != GridObj.cells(grid_array[row], GridObj.getColIndexById("CRE_GB")).getValue())
		{
			alert("수기입력만 삭제가능합니다.");
			return;
    	}
    }
    
   	if (confirm("삭제하시겠습니까?")){
   	    // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
        // encodeUrl() 함수를 사용 하셔야 합니다.
    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
	    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
	    var cols_ids = "<%=grid_col_id%>";
        
        var params;
    	params = "?mode=delete";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    	
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
   }
}

//행추가 이벤트 입니다.
function doAddRow()
{
	dhtmlx_last_row_id++;
	var nMaxRow2 = dhtmlx_last_row_id;
	var row_data = "<%=grid_col_id%>";
	
	GridObj.enableSmartRendering(true);
	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
	GridObj.selectRowById(nMaxRow2, false, true);
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CRUD")).setValue("C");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("DEPT")).setValue("<%=JSPUtil.nullToEmpty(info.getSession("DEPARTMENT"))%>");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("DEPT_NAME_LOC")).setValue("<%=JSPUtil.nullToEmpty(info.getSession("DEPARTMENT_NAME_LOC"))%>");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("ITEM_NO")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("CRE_GB_TXT")).setValue("수기입력");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("CRE_GB")).setValue("2");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("DSTR_GB")).setValue("2");
    
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("STK_USER_ID")).setValue("<%=JSPUtil.nullToEmpty(info.getSession("ID"))%>");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("STK_USER_NAME_LOC")).setValue("<%=JSPUtil.nullToEmpty(info.getSession("NAME_LOC"))%>");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("STK_DATE")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("STK_TIME")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("NTC_YN")).setValue("N");    
    
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("NTC_YN")).setValue("N");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("ABOL_YN")).setValue("N");
	
	dhtmlx_before_row_id = nMaxRow2;
}

//행삭제시 호출 되는 함수 입니다.
function doDeleteRow()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var rowcount = grid_array.length;
	GridObj.enableSmartRendering(false);

	for(var row = rowcount - 1; row >= 0; row--)
	{		
		if("1" == GridObj.cells(grid_array[row], 0).getValue() && "C" == GridObj.cells(grid_array[row], GridObj.getColIndexById("CRUD")).getValue())
		{
			GridObj.deleteRow(grid_array[row]);
    	}
    }
}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData,approvalCnt) {
	var sRptData = "";
	var rf = "<%=CommonUtil.getConfig("clipreport4.separator.field")%>";
	var rl = "<%=CommonUtil.getConfig("clipreport4.separator.line")%>";
	var rd = "<%=CommonUtil.getConfig("clipreport4.separator.data")%>";
	
	sRptData += document.form1.add_date_start.value;	//보유일자 from
	sRptData += " ~ ";
	sRptData += document.form1.add_date_end.value;	//보유일자 to
	sRptData += rf;
	sRptData += document.form1.description_loc.value;	//품목명
	sRptData += rf;
	sRptData += document.form1.material_ctrl_type.options[document.form1.material_ctrl_type.selectedIndex].text;	//중분류
	sRptData += rf;
	sRptData += document.form1.material_class1.options[document.form1.material_class1.selectedIndex].text;	//소분류
	sRptData += rf;
	sRptData += document.form1.material_class2.options[document.form1.material_class2.selectedIndex].text;	//세분류
	sRptData += rf;
	sRptData += document.form1.ntc_yn.options[document.form1.ntc_yn.selectedIndex].text;	//게시여부
	sRptData += rf;
	sRptData += document.form1.abol_yn2.options[document.form1.abol_yn2.selectedIndex].text;	//폐기여부
	sRptData += rf;
	sRptData += document.form1.abol_yn1.options[document.form1.abol_yn1.selectedIndex].text;	//폐기대상여부
	sRptData += rd;
			
	for(var i = 0; i < GridObj.GetRowCount(); i++){
		sRptData += GridObj.GetCellValue("ATTRIBUTE_NAME",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("DESCRIPTION_LOC",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("NTC_YN",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("H_NTC_LOC",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("NTC_LOC_ETC",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("NTC_DATE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("NTC_USER_NAME_LOC",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("ABOL_YN",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("_ABOL_DATE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("ABOL_DATE",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("ABOL_USER_NAME_LOC",i);
		sRptData += rl;				
	}	

	document.form1.rptData.value = sRptData;
	
	if(typeof(rptAprvData) != "undefined"){
		document.form1.rptAprvUsed.value = "Y";
		document.form1.rptAprvCnt.value = approvalCnt;
		document.form1.rptAprv.value = rptAprvData;
    }
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
<body bgcolor="#FFFFFF" text="#000000" onload="Init();">
<s:header>
<%
	if("".equals(gate)){
%>
	<%@ include file="/include/sepoa_milestone.jsp" %>
<%
	}
%>
	<form name="form1">
		<%--ClipReport4 hidden 태그 시작--%>
		<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
		<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
		<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="N">
		<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
		<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
		<input type="hidden" name="rptAprv" id="rptAprv">		
		<%--ClipReport4 hidden 태그 끝--%>
		<input type="hidden" name="item_no" id="item_no">
		
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
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;보유일자</td>
										<td width="35%" class="data_td" >
											<s:calendar id="add_date_start" default_value="<%=SepoaString.getDateSlashFormat(from_date) %>" format="%Y/%m/%d"/>
											~
											<s:calendar id="add_date_end" default_value="<%=SepoaString.getDateSlashFormat(to_date) %>" format="%Y/%m/%d"/>
										</td>
    									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목명</td>
    									<td width="35%" class="data_td" >
        									<input type="text" onkeydown='entKeyDown()'   name="description_loc" id="description_loc" style="width:95%" maxlength="160" class="inputsubmit"  >
    									</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
    									<td class="title_td" style="display:none;">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;대분류</td>
    									<td class="data_td" style="display:none;">
        									<select name="material_type" id="material_type" class="inputsubmit">
        										<option value="" selected="selected">전체</option>
<%
	String listbox1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M040#03", "03");
	out.println(listbox1);
%>
											</select>
										</td>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;중분류</td>
										<td class="data_td">
											<select name="material_ctrl_type" id="material_ctrl_type" class="inputsubmit" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();">
												<option value=''>전체</option>
<%
	String listbox2 = ListBox(request, "SL0020", info.getSession("HOUSE_CODE") + "#M041#03", "");
	out.println(listbox2);
%>
											</select>																							
										</td>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소분류</td>
    									<td class="data_td">
        									<select name="material_class1" id="material_class1" class="inputsubmit" onChange="javacsript:MATERIAL_CLASS1_Changed();">
        										<option value=''>전체</option>
        									</select>
    									</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
    									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세분류</td>
    									<td class="data_td" colspan="3">
        									<select name="material_class2" id="material_class2" class="inputsubmit">
        										<option value=''>전체</option>
        									</select>
    									</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
    									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;게시여부</td>
    									<td class="data_td">
        									<select name="ntc_yn" id="ntc_yn" class="inputsubmit">
          										<option value = "" selected>전체</option>
          										<option value = "Y">게시</option>
          										<option value = "N">게시안됨</option>          										
        									</select>
    									</td>
    									
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;폐기여부</td>
    									<td class="data_td">
        									<select name="abol_yn2" id="abol_yn2" class="inputsubmit">
          										<option value = "" selected>전체</option>
          										<option value = "Y">폐기</option>
          										<option value = "N">폐기안됨</option>          										
        									</select>
    									</td>
    									
									</tr>									
									
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
    									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;폐기대상여부</td>
    									<td class="data_td" colspan="3">
        									<select name="abol_yn1" id="abol_yn1" class="inputsubmit">
          										<option value = "" selected>전체</option>
          										<option value = "Y">폐기대상</option>
          										<option value = "N">폐기대상아님</option>          										
        									</select>
    									</td>
    									
										
    									
									</tr>									
									<tr style="display:none;">
    									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매정지</td>
    									<td class="data_td">
        									<select name="item_block_flag" id="item_block_flag" class="inputsubmit">
          										<option value = "" selected>전체</option>
          										<option value = "Y">Y</option>
          										<option value = "N">N</option>
        									</select>
    									</td>
    									
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제조사코드</td>
    									<td class="data_td">
    									<input type="text" onkeydown='entKeyDown()'  name="maker_code" id="maker_code" style="width:80px;ime-mode:inactive" class="inputsubmit" maxlength="10" >
										<a href="javascript:searchProfile('maker_code')">
											<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
										</a>
										<a href="javascript:doRemove('maker_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
										<input type="text" onkeydown='entKeyDown()'  name="maker_name" id="maker_name" style="width:120px" class="inputsubmit">										
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
btn("javascript:doSelect()","조 회");
</script>
							</TD>
<%
	//if(isAdmin(info)){
%>
<td><script language="javascript">btn("javascript:clipPrint()","출 력")		</script></td>
<td><script language="javascript">btn("javascript:doSave()","저 장 ( 게 시 / 폐 기 / 수기입력 )")</script></td>
<td><script language="javascript">btn("javascript:doDelete()","삭 제")</script></td>
<td><script language="javascript">btn("javascript:doAddRow()","행 삽 입")</script></td>
<td><script language="javascript">btn("javascript:doDeleteRow()","행 삭 제")</script></td>
<%
	//}
%>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>
	</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="MA_018" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name="xWork" width="0" height="0" border="0"></iframe>
<iframe name="getDescframe" width="0" height="0" border="0"></iframe>
</body>
</html>