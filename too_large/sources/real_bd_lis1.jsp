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
	multilang_id.addElement("MA_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "MA_004";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
	
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-150);
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

<% String WISEHUB_PROCESS_ID="MA_004";%>

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
var INDEX_ITEM_NO;
var INDEX_DESCRIPTION_LOC;
var INDEX_ATTRIBUTE_NAME;
var INDEX_SALES_UNIT;
var INDEX_UNIT_PRICE;
var INDEX_CONTRACT_FROM_DATE;
var INDEX_CONTRACT_TO_DATE;
var INDEX_INTEGRATED_FLAG;
var INDEX_COMPANY_CODE;
var INDEX_SPECIFICATION;
var INDEX_SALES_VIEW;
var INDEX_IMAGE;
var INDEX_STATUS;
var INDEX_ITEM_GROUP;
var IDX_Z_COLOR;

function Init()
{
	setGridDraw();
	setHeader();

	
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

    /*
    */


	//GridObj.SetColCellSortEnable(     "STATUS",false);
	/* GridObj.SetColCellSortEnable(   "ITEM_GROUP",false);
 */

    INDEX_SELECTED                      =   GridObj.GetColHDIndex("SELECTED");
    INDEX_ITEM_NO                       =   GridObj.GetColHDIndex("ITEM_NO");
    INDEX_DESCRIPTION_LOC           	=   GridObj.GetColHDIndex("DESCRIPTION_LOC");
    INDEX_ATTRIBUTE_NAME            	=   GridObj.GetColHDIndex("ATTRIBUTE_NAME");
    INDEX_SALES_UNIT                    =   GridObj.GetColHDIndex("SALES_UNIT");
    INDEX_INTEGRATED_FLAG            	=   GridObj.GetColHDIndex("INTEGRATED_FLAG");
    INDEX_SPECIFICATION                 =   GridObj.GetColHDIndex("SPECIFICATION");
    INDEX_IMAGE                         =   GridObj.GetColHDIndex("IMAGE");
    //INDEX_STATUS						=	GridObj.GetColHDIndex("STATUS");
    INDEX_ITEM_GROUP					= 	GridObj.GetColHDIndex("ITEM_GROUP");
    IDX_Z_COLOR             			=   GridObj.GetColHDIndex("Z_COLOR");
}

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
<%--     servletUrl =  "<%=getWiseServletPath("master.new_material.real_bd_lis1") %>"; --%>
G_SERVLETURL =  "<%=POASRM_CONTEXT_NAME%>/servlets/master.new_material.real_bd_lis1";
   
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

        if(msg3 == INDEX_ITEM_NO) {
            var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);
            var BUY = GD_GetCellValueIndex(GridObj,msg2,INDEX_INTEGRATED_FLAG);
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
            var url = "real_pp_lis1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";

            var PoDisWin =window.open(url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
            PoDisWin.focus();
        } else if(msg3 == INDEX_SALES_VIEW) {
            var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);
            width = 750;
            height = 550;
            var url = "pay_pp_lis.jsp?ITEM_NO="+ITEM_NO;
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

<%--//품목수정--%>
function doModify(mode)
{
    var ITEM_NO = "";
    var left = 30;
    var top = 30;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'no';
    var width = "";
    var height = "";
    var wise = GridObj;
	var BUY = "";
	var max_row = GridObj.GetRowCount();
	var maxcol  = GridObj.GetColCount();

    for(var i=0;i<max_row;i++)
    {
        var selectCheck = GD_GetCellValueIndex(GridObj, i, INDEX_SELECTED);
        if(selectCheck == true)
        {

            ITEM_NO = GD_GetCellValueIndex(GridObj,i,INDEX_ITEM_NO);

            BUY = GD_GetCellValueIndex(GridObj,i,INDEX_INTEGRATED_FLAG);

<%--
            if(("<%=info.getSession("COMPANY_CODE")%>" != "L00" && GD_GetCellValueIndex(GridObj,i,INDEX_INTEGRATED_FLAG)=="Y")||("<%=info.getSession("COMPANY_CODE")%>" == "L00" && GD_GetCellValueIndex(GridObj,i,INDEX_INTEGRATED_FLAG)=="N"))
            {
                alert("수정할 권한이 없습니다.");
                return;
            }
--%>
        }
    }
    width = 750;
    height = 480;
    var url = "";

    if(ITEM_NO != "")
    {
        if(mode=="1"){
    	    url = "real_pp_upd2.jsp?ITEM_NO="+ITEM_NO;
    	}else if(mode=="2"){

    		for(var i=0;i<max_row;i++) {
    			var selectCheck = GD_GetCellValueIndex(GridObj,i, INDEX_SELECTED);
        		if(selectCheck == "true"){
	    			var flag_group = GD_GetCellValueIndex(GridObj,i,INDEX_ITEM_GROUP);
	    		}
	    	}

    		if(flag_group == "2"){
    		/*	url = "real_pp_upd2_1.jsp?ITEM_NO="+ITEM_NO; */
    		url = "real_pp_upd2.jsp?ITEM_NO="+ITEM_NO;
    		} else if(flag_group == "3"){
    		/*	url = "real_pp_upd2_3.jsp?ITEM_NO="+ITEM_NO; */
    		url = "real_pp_upd2.jsp?ITEM_NO="+ITEM_NO;
    		} else if(flag_group == "5"){
    		/*	url = "real_pp_upd2_2.jsp?ITEM_NO="+ITEM_NO; */
    		url = "real_pp_upd2.jsp?ITEM_NO="+ITEM_NO;
    		} else if(flag_group == "1"){
    			alert("메뉴는 품목수정/추가정보에서 수정하세요.");
				return;
    		} else {
	    		url = "real_pp_upd2.jsp?ITEM_NO="+ITEM_NO;
	    	}

	    }else if(mode=="3"){
    		if("<%=info.getSession("COMPANY_CODE")%>" == "L00" && BUY=="Y"){
    			url = "real_pp_upd12.jsp?ITEM_NO="+ITEM_NO;
    		}else{
	    		alert("수정할 권한이 없습니다.");
                return;
    		}
    	}
        var PoDisWin =window.open(url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
        PoDisWin.focus();
    } else alert("수정할 품목을 선택해주세요");
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
     
    if(cellInd == INDEX_ITEM_NO) {
            var ITEM_NO = GridObj.cells(rowId, INDEX_ITEM_NO).getValue()		//GD_GetCellValueIndex(GridObj,rowId,INDEX_ITEM_NO);
            var BUY = GridObj.cells(rowId, INDEX_INTEGRATED_FLAG).getValue()	     	//GD_GetCellValueIndex(GridObj,rowId,INDEX_INTEGRATED_FLAG);
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
            var url = "real_pp_lis1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";

            var PoDisWin =window.open(url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
            PoDisWin.focus();
        }
<%--    
		GD_CellClick(document.WiseGrid,strColumnKey, nRow);

    
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
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;생성일자</td>
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
    									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;대분류</td>
    									<td class="data_td">
        									<select name="material_type" id="material_type" class="inputsubmit" onChange="javacsript:MATERIAL_TYPE_Changed();">
        										<option value="" selected="selected">전체</option>
<%
	String listbox1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M040", "");
	out.println(listbox1);
%>
											</select>
										</td>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;중분류</td>
										<td class="data_td">
											<select name="material_ctrl_type" id="material_ctrl_type" class="inputsubmit" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();">
												<option value=''>전체</option>
											</select>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
    									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소분류</td>
    									<td class="data_td">
        									<select name="material_class1" id="material_class1" class="inputsubmit" onChange="javacsript:MATERIAL_CLASS1_Changed();">
        										<option value=''>전체</option>
        									</select>
    									</td>
    									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세분류</td>
    									<td class="data_td">
        									<select name="material_class2" id="material_class2" class="inputsubmit">
        										<option value=''>전체</option>
        									</select>
    									</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
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
										<%--
      										<input type="text" onkeydown='entKeyDown()'  name="maker_code" id="maker_code" style="ime-mode:inactive" value=""  size="15" maxlength="22" class="inputsubmit" >
        									<a href="javascript:SP9053_Popup()">
        										<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
        									</a>
        									<a href="javascript:doRemove('maker_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
        									<input type="text" onkeydown='entKeyDown()'  name="maker_name" id="maker_name" value=""  size="20" maxlength="100" class="input_data2">
    									--%>
    									</td>    									
									</tr>
									<tr>
    									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용여부</td>
    									<td class="data_td">
        									<select name="usedflag" id="usedflag" class="inputsubmit">
          										<option value = "" selected>전체</option>
          										<option value = "Y">Y</option>
          										<option value = "N">N</option>
        									</select>
    									</td>
    									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;폐기여부</td>
    									<td class="data_td">
        									<select name="abol_flag" id="abol_flag" class="inputsubmit">
          										<option value = "" selected>전체</option>
          										<option value = "4">Y</option>
          										<option value = "1">N</option>
        									</select>
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
	if(isAdmin(info)){
%>
							<TD>
<script language="javascript">
btn("javascript:doModify('2')","품목수정");
</script>
							</TD>
<%
	}
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
<%-- <s:grid screen_id="MA_004" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name="xWork" width="0" height="0" border="0"></iframe>
<iframe name="getDescframe" width="0" height="0" border="0"></iframe>
</body>
</html>