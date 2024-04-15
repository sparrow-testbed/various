<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%!
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
	multilang_id.addElement("PR_009");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_009";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String SepoaHUB_PROCESS_ID="PR_009";
	String PR_NO          = JSPUtil.nullToEmpty(request.getParameter("pr_no"));

    String USER_ID        = info.getSession("ID");
    String HOUSE_CODE     = info.getSession("HOUSE_CODE") ;
    String COMPANY_CODE   = info.getSession("COMPANY_CODE") ;

    String SUBJECT            = "";
    String ORDER_NO           = "";
    String ORDER_NAME         = "";
    String RECEIVE_TERM       = "";
    String ADD_DATE           = "";
    String DEMAND_DEPT_NAME   = "";
    String DEMAND_DEPT        = "";
    String ADD_USER_ID        = "";
    String ADD_USER_NAME	  = "";
    String CONTRACT_HOPE_DAY  = "";
    String SALES_DEPT    	  = "";
    String SALES_DEPT_NAME 	  = "";
    String SALES_USER_ID      = "";
    String SALES_USER_NAME    = "";
    String PR_TYPE            = "";
    String SALES_TYPE         = "";
    String EXPECT_AMT         = "";
    String REMARK             = "";
    String RETURN_HOPE_DAY      = "";
    String ATTACH_NO            = "";
    String ATT_COUNT            = "";
    String HARD_MAINTANCE_TERM  = "";
    String SOFT_MAINTANCE_TERM  = "";
    String CREATE_TYPE  		= "";
    String PR_TOT_AMT  			= "";
    String BSART			  = "";
    String WBS_NO			  = "";
    String WBS_SUB_NO		  = "";
    String WBS_TXT			  = "";
    String CUST_TYPE  			= "";
    String CUST_CODE          = "";
    String CUST_NAME  			= "";
    String AHEAD_FLAG = "";
    String wbs = "";
    String wbs_name = "";
    String PJT_SEQ = "";
    String pre_cont_seq = "";
    String pre_cont_count = "";

	String DELY_TO_LOCATION     = "";
	String DELY_TO_ADDRESS      = "";
	String DELY_TO_USER         = "";
	String DELY_TO_PHONE        = "";
	
	String PC_FLAG        = "";
	String PC_FLAG1       = "";
	String PC_REASON      = "";
	String[] args = {PR_NO };
	String sPrNo    = "";
	String addPrNo  = "";
	Map<String, String> svcParam = new HashMap<String, String>();
	
	svcParam.put("PR_NO", PR_NO);
	svcParam.put("HOUSE_CODE", HOUSE_CODE);
	
	Object[] svcArgs = {svcParam};
	
    SepoaOut valuePrBr = ServiceConnector.doService(info, "p1015", "CONNECTION","PrBrDisplay", svcArgs);

    SepoaFormater wfvaluePrBr = new SepoaFormater(valuePrBr.result[0]);
    int iRowCountPrBr = wfvaluePrBr.getRowCount();
    
    for(int i=0; i<iRowCountPrBr; i++)
    {
    	sPrNo = wfvaluePrBr.getValue("BR_NO",i)+':';
    	addPrNo += sPrNo;
    }
	
    SepoaOut value = ServiceConnector.doService(info, "p1015", "CONNECTION","ReqBidHDQueryDisplay", args);

    SepoaFormater wf = new SepoaFormater(value.result[0]);
    int iRowCount = wf.getRowCount();
    if(iRowCount>0)
    {
    	SUBJECT             = wf.getValue("SUBJECT",0);
    	ORDER_NO            = wf.getValue("ORDER_NO",0);
    	ORDER_NAME          = wf.getValue("ORDER_NAME",0);
    	ADD_DATE            = wf.getValue("ADD_DATE",0);
    	DEMAND_DEPT_NAME    = wf.getValue("DEMAND_DEPT_NAME",0);
    	DEMAND_DEPT         = wf.getValue("DEMAND_DEPT",0);
    	ADD_USER_ID         = wf.getValue("ADD_USER_ID",0);
    	ADD_USER_NAME		= wf.getValue("ADD_USER_NAME",0);
    	CONTRACT_HOPE_DAY   = wf.getValue("CONTRACT_HOPE_DAY",0);
    	SALES_DEPT     		= wf.getValue("SALES_USER_DEPT",0);
    	SALES_DEPT_NAME     = wf.getValue("SALES_USER_DEPT_NAME",0);
    	SALES_USER_ID     	= wf.getValue("SALES_USER_ID",0);
    	SALES_USER_NAME     = wf.getValue("SALES_USER_NAME",0);
    	PR_TYPE             = wf.getValue("PR_TYPE",0);
    	SALES_TYPE          = wf.getValue("SALES_TYPE",0);
        EXPECT_AMT          = wf.getValue("EXPECT_AMT",0);
        REMARK              = wf.getValue("REMARK",0);
        RETURN_HOPE_DAY     = wf.getValue("RETURN_HOPE_DAY",0);
        ATTACH_NO           = wf.getValue("ATTACH_NO",0);
        ATT_COUNT           = wf.getValue("ATT_COUNT",0);
        HARD_MAINTANCE_TERM = wf.getValue("HARD_MAINTANCE_TERM",0);
        SOFT_MAINTANCE_TERM = wf.getValue("SOFT_MAINTANCE_TERM",0);
        CREATE_TYPE 		= wf.getValue("CREATE_TYPE",0);
        PR_TOT_AMT 			= wf.getValue("PR_TOT_AMT",0);
        BSART				= wf.getValue("BSART",0);
        WBS_NO				= wf.getValue("WBS_NO",0);
        WBS_SUB_NO			= wf.getValue("WBS_SUB_NO",0);
        WBS_TXT				= wf.getValue("WBS_TXT",0);
        CUST_TYPE			= wf.getValue("CUST_TYPE",0);
        CUST_CODE 			= wf.getValue("CUST_CODE",0);
        CUST_NAME 			= wf.getValue("CUST_NAME",0);
        AHEAD_FLAG 			= wf.getValue("AHEAD_FLAG",0);
        wbs 			    = wf.getValue("WBS",0);
        wbs_name 			= wf.getValue("WBS_NAME",0);
        PJT_SEQ 			= wf.getValue("PJT_SEQ",0);
        pre_cont_seq 		= wf.getValue("PRE_CONT_SEQ",0);
        pre_cont_count 		= wf.getValue("PRE_CONT_COUNT",0);

    	DELY_TO_LOCATION		= wf.getValue("DELY_TO_LOCATION",0);
    	DELY_TO_ADDRESS			= wf.getValue("DELY_TO_ADDRESS",0);
    	DELY_TO_USER			= wf.getValue("DELY_TO_USER",0);
    	DELY_TO_PHONE			= wf.getValue("DELY_TO_PHONE",0);
    	
    	//PC_FLAG     		    = wf.getValue("PC_FLAG"   	, 0).equals("Y")?"checked":""; ;
    	PC_FLAG     		    = wf.getValue("PC_FLAG"   	, 0);
    	PC_FLAG1     		    = wf.getValue("PC_FLAG"   	, 0);
    	PC_REASON			    = wf.getValue("PC_REASON",0);
    }
    //LISTBOX VALUE

    //LISTBOX
	String LB_PR_TYPE 		= ListBox(request, "SL0018",  HOUSE_CODE+"#M138#", PR_TYPE);
	String LB_HARD_MAINTANCE_TERM = ListBox(request, "SL0018",  HOUSE_CODE+"#M165#", HARD_MAINTANCE_TERM);
	String LB_SOFT_MAINTANCE_TERM = ListBox(request, "SL0018",  HOUSE_CODE+"#M165#", SOFT_MAINTANCE_TERM);
	String LB_CREATE_TYPE = ListBox(request, "SL9997",  HOUSE_CODE+"#M113#B#", CREATE_TYPE);
	String LB_BSART = ListBox(request, "SL0018",  HOUSE_CODE+"#M371#", BSART);
	String LB_S_SALES_TYPE 		= ListBox(request, "SL0018",  HOUSE_CODE+"#M372#", SALES_TYPE);

	//SepoaTable 콤보박스
	SepoaListBox LB = new SepoaListBox();
    String COMBO_M000     = LB.Table_ListBox(request, "SL0022", HOUSE_CODE+"#M169#", "&" , "#");
    String COMBO_M001     = LB.Table_ListBox(request, "SL0018", HOUSE_CODE+"#M170#", "&" , "#");
    String COMBO_M002     = LB.Table_ListBox(request, "SL0014", HOUSE_CODE+"#M002#", "&" , "#");
    String COMBO_IDX_M002 = ""+CommonUtil.getComboIndex(COMBO_M002,"KRW","#");
    String COMBO_M007     = LB.Table_ListBox(request, "SL0014", HOUSE_CODE+"#M007#", "&" , "#");
    
    String COMBO_IDX_M007 = ""+CommonUtil.getComboIndex(COMBO_M007,"EA","#");
    String COMBO_M933     = LB.Table_ListBox(request, "SL0022", HOUSE_CODE+"#M933#", "&" , "#");
    
    String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지

	/**
	 * 전자결재 사용여부
	 */
	Config signConf = new Configuration();
	String sign_use_module = "";// 전자결재 사용모듈
	boolean sign_use_yn = false;
	try {
		sign_use_module = signConf.get("sepoa.sign.use.module." + info.getSession("HOUSE_CODE")); //전자결재 사용모듈
	} catch(Exception e) {
		
		out.println("에러 발생:" + e.getMessage() + "<br>");
		
		sign_use_module	= "";
	}
	StringTokenizer st = new StringTokenizer(sign_use_module, ";");
	while (st.hasMoreTokens()) {
		if ("PR".equals(st.nextToken())) {
			sign_use_yn = true;
		}
	}
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript" type="text/javascript">
var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME %>/servlets/dt.ebd.ebd_bd_ins4_main";
var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";
var G_SAVE_STATUS  = "T";
var G_CUR_ROW;//팝업 관련해서 씀..
var G_PR_NO        = "<%=PR_NO%>";
var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
var summaryCnt = 0;
var G_PRE_CODE   = "B";

//var INDEX_MODE;

var INDEX_SELECTED			;
var INDEX_ITEM_NO			;
var INDEX_DESCRIPTION_LOC	;
var INDEX_UNIT_MEASURE		;
var INDEX_PR_QTY			;
var INDEX_CUR				;
var INDEX_UNIT_PRICE		;
var INDEX_RD_DATE			;
var INDEX_PR_AMT			;
var INDEX_ATTACH_NO			;
var INDEX_REC_VENDOR_CODE   ;
var INDEX_REC_VENDOR_NAME   ;
var INDEX_REMARK			;
var INDEX_DELY_TO_LOCATION  ;
var INDEX_PURCHASE_LOCATION ;
var INDEX_PURCHASER_ID      ;
var INDEX_PURCHASER_NAME    ;
var INDEX_PURCHASE_DEPT_NAME;
var INDEX_PURCHASE_DEPT     ;
var INDEX_TECHNIQUE_GRADE   ;
var INDEX_TECHNIQUE_TYPE    ;
var INDEX_INPUT_FROM_DATE   ;
var INDEX_INPUT_TO_DATE  	;
var INDEX_WBS_NO     		;
var INDEX_WBS_SUB_NO     	;
var INDEX_WBS_TXT     		;
var INDEX_CTRL_CODE    		;

var INDEX_CONTRACT_DIV;
var INDEX_WARRANTY;
var INDEX_EXCHANGE_RATE;
var INDEX_ACCOUNT_TYPE;
var INDEX_ASSET_TYPE;
var G_C_INDEX    = "MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:DELIVERY_IT:MAKER_NAME:MAKER_CODE:ITEM_GROUP:DELY_TO_ADDRESS:KTGRM";
var G_C_INDEX_MY = "MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:MAKER_NAME:MAKER_CODE:ITEM_GROUP:DELY_TO_ADDRESS";

function init()
{
	setHeader_1();
	sales_com();
	orderChange('<%=SALES_TYPE%>');
}

function init_1()
{

}

function setHeader_1()
{
    var Sepoa = GridObj;

	INDEX_SELECTED              = GridObj.GetColHDIndex("SELECTED");
	INDEX_ITEM_NO               = GridObj.GetColHDIndex("ITEM_NO");
	INDEX_DESCRIPTION_LOC       = GridObj.GetColHDIndex("DESCRIPTION_LOC");
	INDEX_SPECIFICATION         = GridObj.GetColHDIndex("SPECIFICATION");
	INDEX_MAKER_NAME            = GridObj.GetColHDIndex("MAKER_NAME");
	INDEX_MAKER_CODE            = GridObj.GetColHDIndex("MAKER_CODE");
	INDEX_UNIT_MEASURE          = GridObj.GetColHDIndex("UNIT_MEASURE");
	INDEX_PR_QTY                = GridObj.GetColHDIndex("PR_QTY");
	INDEX_CUR                   = GridObj.GetColHDIndex("CUR");
	INDEX_UNIT_PRICE            = GridObj.GetColHDIndex("UNIT_PRICE");
	INDEX_EXCHANGE_RATE         = GridObj.GetColHDIndex("EXCHANGE_RATE");
	INDEX_RD_DATE               = GridObj.GetColHDIndex("RD_DATE");
	INDEX_PR_AMT                = GridObj.GetColHDIndex("PR_AMT");
	INDEX_REC_VENDOR_CODE     = GridObj.GetColHDIndex("REC_VENDOR_CODE");
	INDEX_REC_VENDOR_NAME     = GridObj.GetColHDIndex("REC_VENDOR_NAME");
	INDEX_ATTACH_NO           = GridObj.GetColHDIndex("ATTACH_NO");
	INDEX_REMARK              = GridObj.GetColHDIndex("REMARK");
	INDEX_PURCHASE_LOCATION   = GridObj.GetColHDIndex("PURCHASE_LOCATION");
	INDEX_PURCHASER_ID        = GridObj.GetColHDIndex("PURCHASER_ID");
	INDEX_PURCHASER_NAME      = GridObj.GetColHDIndex("PURCHASER_NAME");
	INDEX_PURCHASE_DEPT_NAME  = GridObj.GetColHDIndex("PURCHASE_DEPT_NAME");
	INDEX_PURCHASE_DEPT       = GridObj.GetColHDIndex("PURCHASE_DEPT");
	INDEX_WBS_NO             = GridObj.GetColHDIndex("WBS_NO");
	INDEX_WBS_SUB_NO         = GridObj.GetColHDIndex("WBS_SUB_NO");
	INDEX_WBS_TXT            = GridObj.GetColHDIndex("WBS_TXT");
	INDEX_ORDER_SEQ          = GridObj.GetColHDIndex("ORDER_SEQ");
	INDEX_ITEM_GROUP        = GridObj.GetColHDIndex("ITEM_GROUP");
	INDEX_CONTRACT_DIV      = GridObj.GetColHDIndex("CONTRACT_DIV");
	INDEX_DELY_TO_ADDRESS	= GridObj.GetColHDIndex("DELY_TO_ADDRESS");
	INDEX_WARRANTY        	= GridObj.GetColHDIndex("WARRANTY");
	INDEX_CTRL_CODE      	= GridObj.GetColHDIndex("CTRL_CODE");
	INDEX_ACCOUNT_TYPE      = GridObj.GetColHDIndex("ACCOUNT_TYPE");
	INDEX_ASSET_TYPE      	= GridObj.GetColHDIndex("ASSET_TYPE");
	INDEX_KTGRM      		= GridObj.GetColHDIndex("KTGRM");
	INDEX_MATERIAL_TYPE      		= GridObj.GetColHDIndex("MATERIAL_TYPE");

	GridObj.strHDClickAction="select";
	doSelect();
}

function fnFormInputSet(frm, inputName, inputValue) {
	var input = document.createElement("input");
	
	input.type  = "hidden";
	input.name  = inputName;
	input.id    = inputName;
	input.value = inputValue;
	
//	frm.appendChild(input);
	
	return input;
}

function fnGetDynamicForm(url, param, target){
	var form           = document.createElement("form");
	var paramArray     = param.split("&");
	var i              = 0;
	var paramInfoArray = null;

	if((target == null) || (target == "")){
		target = "_self";
	}

	for(i = 0; i < paramArray.length; i++){
		paramInfoArray = paramArray[i].split("=");
		
		var input = fnFormInputSet(form, paramInfoArray[0], paramInfoArray[1]);

		form.appendChild(input);
	}

	form.action = url;
	form.target = target;
	form.method = "post";

	return form;
}

function getParams(){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var params;
	
	inputParam = "prNo=" + G_PR_NO;
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=getReqBidDTDisplayChange";
	params += "&cols_ids=<%=grid_col_id%>";
	params += dataOutput();
	
	body.removeChild(form);
	
	return params;
}

function doSelect(){
	var params = getParams();
	
	GridObj.post( G_SERVLETURL, params );
	
	GridObj.clearAll(false);
}

/*
	카탈로그 : cat_pp_lis_main.jsp에서 호출되는 부분, 선택한 항목에 대해 와이즈 테이블에 인서트한다.
*/

function setCatalog1(arr)
{
	var Sepoa = GridObj;

	//INDEX=ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME
	var ITEM_NO = arr[getCatalogIndex("BUYER_ITEM_NO")];

	var dup_flag = true;
	for(var i=0;i<GridObj.GetRowCount();i++)
	{
		if(ITEM_NO == GD_GetCellValueIndex(GridObj,i,INDEX_ITEM_NO))
		{
			dup_flag = true;
			break;
		}
	}

	if(!dup_flag)
	{
		var iMaxRow = GridObj.GetRowCount();
		GridObj.AddRow();

		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SELECTED,				"true", "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ITEM_NO, 				"null&"+ITEM_NO+"&"+ITEM_NO, "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_DESCRIPTION_LOC, 		arr[getCatalogIndex("DESCRIPTION_LOC")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_UNIT_MEASURE, 		arr[getCatalogIndex("BASIC_UNIT")]);
      	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CTRL_CODE,      		arr[getCatalogIndex("CTRL_CODE")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_REC_VENDOR_NAME, 		G_IMG_ICON + "&"+"null"+"&"+"null", "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_DELY_TO_LOCATION, 	G_IMG_ICON + "&"+"null"+"&"+"null", "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ATTACH_NO, 			G_IMG_ICON + "&"+"null"+"&"+"null", "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CUR, 					"<%=COMBO_M002%>", "&","#");
		//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_RD_DATE, 			arr[getCatalogIndex("DELIVERY_IT")]);

		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PR_QTY,				arr[getCatalogIndex("QTY")]);
		//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_LOCATION, 	arr[getCatalogIndex("PURCHASE_LOCATION")]);
		//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASER_ID,      	arr[getCatalogIndex("CTRL_PERSON_ID")]);
		//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASER_NAME,    	arr[getCatalogIndex("PURCHASER_NAME")]);
		//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_DEPT_NAME,	arr[getCatalogIndex("PURCHASE_DEPT_NAME")]);
		//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_DEPT, 		arr[getCatalogIndex("PURCHASE_DEPT")]);

	}
}
function getItemValue(){
	return;
}

var ADD_UNIT_MEASURE_OPTION_CNT = 0;
<%--
function setCatalog(arr)
{
	var Sepoa = GridObj;

	//INDEX=ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME
	var ITEM_NO = arr[getCatalogIndex("ITEM_NO")];

	var dup_flag = false;
	for(var i=0;i<GridObj.GetRowCount();i++)
	{
		if(ITEM_NO == GD_GetCellValueIndex(GridObj,i,INDEX_ITEM_NO))
		{
			dup_flag = true;
			break;
		}
	}

	//if(!dup_flag)
	//{
		var iMaxRow = GridObj.GetRowCount();
		GridObj.AddRow();

	    GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SELECTED,     	"1" );
	    GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ITEM_NO,      	"null&"+ITEM_NO+"&"+ITEM_NO, "&");
	    GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_DESCRIPTION_LOC,  arr[getCatalogIndex("DESCRIPTION_LOC")]);
	    GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SPECIFICATION,  	arr[getCatalogIndex("SPECIFICATION")]);
	    GridObj.SetCellValue	  ("MAKER_NAME", iMaxRow, 				arr[getCatalogIndex("MAKER_NAME")]);
	    GridObj.SetCellHiddenValue("MAKER_NAME", iMaxRow, 			arr[getCatalogIndex("MAKER_NAME")]);
	    GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_MAKER_CODE,     	arr[getCatalogIndex("MAKER_CODE")]);
	    GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_UNIT_MEASURE,     "<%=COMBO_M007%>", "&","#");
	    GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CTRL_CODE,      	arr[getCatalogIndex("CTRL_CODE")]);
	    GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_REC_VENDOR_NAME,  "<%=G_IMG_ICON%>" + "&"+"null"+"&"+"null", "&");
	    GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ATTACH_NO,    	"<%=G_IMG_ICON%>" + "&"+"null"+"&"+"null", "&");
	    GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CUR,        		"<%=COMBO_M002%>", "&","#", "<%=COMBO_IDX_M002%>");
	    //GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_RD_DATE,      	arr[getCatalogIndex("DELIVERY_IT")]);
	    GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PR_QTY,     		arr[getCatalogIndex("QTY")]);
	    GridObj.SetCellValue("PR_NO",iMaxRow, "<%=PR_NO%>");
	    GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_EXCHANGE_RATE,     "1");
	    //GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_LOCATION, arr[getCatalogIndex("PURCHASE_LOCATION")]);
	    //GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASER_ID,      arr[getCatalogIndex("CTRL_PERSON_ID")]);
	    //GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASER_NAME,    arr[getCatalogIndex("PURCHASER_NAME")]);
	    //GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_DEPT_NAME,arr[getCatalogIndex("PURCHASE_DEPT_NAME")]);
	    //GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_DEPT,  arr[getCatalogIndex("PURCHASE_DEPT")]);
	    if(ADD_UNIT_MEASURE_OPTION_CNT == 0){
	      	GridObj.AddComboListValue("UNIT_MEASURE", "", "");
	      	ADD_UNIT_MEASURE_OPTION_CNT++;
	    }
	    GridObj.SetComboSelectedHiddenValue('UNIT_MEASURE',iMaxRow,	arr[getCatalogIndex("BASIC_UNIT")]);
	    GridObj.SetCellValue("MATERIAL_TYPE", iMaxRow, 				arr[getCatalogIndex("MATERIAL_TYPE")]);
	    GridObj.SetCellValue("CTRL_CODE", iMaxRow, 					ctrl_code[0]);
	    GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_DELY_TO_ADDRESS,  arr[getCatalogIndex("DELY_TO_ADDRESS")]);
	    
	    var pjt_code = form1.pjt_code.value;
      	if(pjt_code != ''){
      		if(pjt_code.substr(0,2) == 'SI' && arr[getCatalogIndex("KTGRM")] == '01'){
      			GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ACCOUNT_TYPE,     "상품(" + pjt_code.substr(0,5) + ")");
      		}else{
      			GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ACCOUNT_TYPE,     pjt_code.substr(0,9));
      		}
      	}
	    
	    /*
	     * 변경계약 구매요청
	     *  - 업체정보를 기존업체로 자동 SETTING 처리 합니다.
	     */
	     GridObj.SetCellValue("REC_VENDOR_CODE", iMaxRow, 				document.getElementById("REC_VENDOR_CODE").value);
	     GridObj.SetCellValue("REC_VENDOR_NAME", iMaxRow, 				document.getElementById("REC_VENDOR_NAME").value);
	     GridObj.SetCellActivation('REC_VENDOR_NAME',iMaxRow,'activatenoedit');
	//}
}
--%>
function setCatalog(itemNo, descriptionLoc, specification, makerCode, ctrlCode, qty, itemGroup, delyToAddress, unitPrice, ktgrm, makerName, basicUnit, materialType){
	var dup_flag   = false;
	var i          = 0;
	var iMaxRow    = GridObj.GetRowCount();
	var newId      = (new Date()).valueOf();
	var pjt_code   = document.getElementById("pjt_code").value;
	
	GridObj.addRow(newId,"");
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SELECTED,     	  "true");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_NO,      	  itemNo);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DESCRIPTION_LOC, descriptionLoc);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SPECIFICATION,   specification);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKER_CODE,      makerCode);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CTRL_CODE,       ctrlCode);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_PR_QTY,          qty);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_GROUP,      itemGroup);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DELY_TO_ADDRESS, delyToAddress);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_PRICE,      unitPrice);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_EXCHANGE_RATE,   "1");
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_KTGRM,           ktgrm);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKER_NAME,      makerName);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_MEASURE,    basicUnit);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MATERIAL_TYPE,   materialType);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CUR,             "KRW");
    
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ACCOUNT_TYPE, ktgrm);
    
	if(pjt_code != ''){
		if(pjt_code.substr(0,2) == 'SI' && ktgrm == '01'){
			GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ACCOUNT_TYPE, "상품(" + pjt_code.substr(0,5) + ")");
		}
		else{
			GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ACCOUNT_TYPE, pjt_code.substr(0,9));
		}
	}
     
	if(ADD_UNIT_MEASURE_OPTION_CNT == 0){
		//GridObj.AddComboListValue("UNIT_MEASURE", "", "");
		
		ADD_UNIT_MEASURE_OPTION_CNT++;
	}
	
	if((GD_GetCellValueIndex(GridObj,iMaxRow, INDEX_CUR ) == "KRW") == false){
		//GridObj.SetCellActivation('EXCHANGE_RATE', iMaxRow, 'edit');
	}
	
	calculate_pr_amt(GridObj, iMaxRow);
	calculate_pr_tot_amt();

	return true;
}

function setCatalogPrBr(arr)
	{
	var Sepoa = GridObj;
	var ITEM_NO = arr[getCatalogIndex("ITEM_NO")];
	
	var dup_flag = false;
	for(var i=0;i<GridObj.GetRowCount();i++) {
  		if(ITEM_NO == GD_GetCellValueIndex(GridObj,i,INDEX_ITEM_NO)) {
    		dup_flag = true;
    		break;
  		}
	}
	// 동일 품목도 요청 가능
  	var iMaxRow = GridObj.GetRowCount();
  	GridObj.AddRow();
  	
  	//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_MODE,     	"1" );
  	
  	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SELECTED,     	"1" );
  	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ITEM_NO,      	"null&"+ITEM_NO+"&"+ITEM_NO, "&");
  	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_DESCRIPTION_LOC,	arr[getCatalogIndex("DESCRIPTION_LOC")]);
  	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SPECIFICATION,  	arr[getCatalogIndex("SPECIFICATION")]);
  	GridObj.SetCellValue	  ("MAKER_NAME", iMaxRow, 				arr[getCatalogIndex("MAKER_NAME")]);
  	GridObj.SetCellHiddenValue("MAKER_NAME", iMaxRow, 			arr[getCatalogIndex("MAKER_NAME")]);
  	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_MAKER_CODE,     	arr[getCatalogIndex("MAKER_CODE")]);
  	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_UNIT_MEASURE,   	"<%=COMBO_M007%>", "&","#");
  	//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_UNIT_MEASURE,   	"<%=COMBO_M007%>", "&","#", getCatalogIndex("BASIC_UNIT")); 	
  	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CTRL_CODE,      	arr[getCatalogIndex("CTRL_CODE")]);
  	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_REC_VENDOR_NAME,	"<%=G_IMG_ICON%>" + "&"+"null"+"&"+"null", "&");
  	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ATTACH_NO,    	"<%=G_IMG_ICON%>" + "&"+"null"+"&"+"null", "&");
  	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CUR,        		"<%=COMBO_M002%>", "&","#", "<%=COMBO_IDX_M002%>");
  	//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PR_QTY,     		arr[getCatalogIndex("PR_QTY")]);
  	//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ITEM_GROUP,     	arr[getCatalogIndex("ITEM_GROUP")]);
  	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_DELY_TO_ADDRESS,  arr[getCatalogIndex("DELY_TO_ADDRESS")]);
  	//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_UNIT_PRICE,  arr[getCatalogIndex("UNIT_PRICE")]);
  	//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PR_AMT,  arr[getCatalogIndex("PR_AMT")]);
  	//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_REC_VENDOR_NAME,  arr[getCatalogIndex("REC_VENDOR_NAME")]);
  	//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CONTRACT_DIV,  arr[getCatalogIndex("CONTRACT_DIV")]);
  	//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CONTRACT_DIV,   "<%=COMBO_M933%>", "&","#", getCatalogIndex("CONTRACT_DIV")); 
  	//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_RD_DATE,  arr[getCatalogIndex("RD_DATE")]);
  	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CONTRACT_DIV,     "<%=COMBO_M933%>", "&","#");
  	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WARRANTY,  arr[getCatalogIndex("WARRANTY")]);
  	GridObj.SetCellValue("PR_NO",iMaxRow, "<%=PR_NO%>");
  	
  	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_EXCHANGE_RATE,     "1");
 
  	if(ADD_UNIT_MEASURE_OPTION_CNT == 0){
  		GridObj.AddComboListValue("UNIT_MEASURE", "", "");
  		ADD_UNIT_MEASURE_OPTION_CNT++;
  	}
  	GridObj.SetComboSelectedHiddenValue('UNIT_MEASURE',iMaxRow,	arr[getCatalogIndex("BASIC_UNIT")]);
  	GridObj.SetComboSelectedHiddenValue('CONTRACT_DIV',iMaxRow,	arr[getCatalogIndex("CONTRACT_DIV")]);
  	GridObj.SetCellValue("MATERIAL_TYPE", iMaxRow, 				arr[getCatalogIndex("MATERIAL_TYPE")]);
  	if(!(GD_GetCellValueIndex(GridObj,iMaxRow, INDEX_CUR )=="KRW")){
  		GridObj.SetCellActivation('EXCHANGE_RATE', iMaxRow, 'edit');
  	}
  	return true;
}
function setPrNo(addPrNo,prno_cnt){
	var iCount = GridObj.GetRowCount();	
	var str="";
		
	if(prno_cnt==1){
		str = addPrNo.replace(/:/gi,"");
	}else{
		str = addPrNo;
		//var sLength = str.length;
		//alert("sLength===>"+sLength);
		//str.substring(sLength-1,sLength);
	}	
	document.forms[0].pre_pjt_code.value = str;
	document.forms[0].pre_pjt_name.value = prno_cnt+"건";
}
//사원지원
	function PREPJTCODE() {
		var f = document.forms[0];
		if(f.pjt_code.value == ""){
	        alert("프로젝트코드를 입력하세요!");
	        return;
   		 }
		var pjt_code = f.pjt_code.value;
  	setCatalogIndex(G_C_INDEX_PJ);

	url = "/kr/catalog/pr/pr1_pp_lis5.jsp?INDEX=" + getAllCatalogIndex()+"&pjt_code="+pjt_code;
	
	CodeSearchCommon(url,"INVEST_NO",0,0,"950","530");
  	//windowopen1 = window.open(url,"mycatalog_win","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=950,height=500,left=0,top=0");
	}	
function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
	var Sepoa = GridObj;
	var f = document.forms[0];

	if(msg1 == "t_insert")
	{
		if(msg3 == INDEX_PR_QTY || msg3 == INDEX_UNIT_PRICE)
		{
			calculate_pr_amt(Sepoa, msg2);
		}
		//통화 변경시
  		else if(msg3 == INDEX_CUR){
  			var cur = GD_GetCellValueIndex(GridObj,msg2, INDEX_CUR);
  			
  			if(cur == 'KRW'){
  				GridObj.SetCellActivation('EXCHANGE_RATE',msg2,'activatenoedit');
  			}else{
  				GridObj.SetCellActivation('EXCHANGE_RATE',msg2,'edit');
  			}
  		}
	}

	if(msg1 == "t_imagetext")
	{
		G_CUR_ROW = msg2;

		if(msg3 == INDEX_ITEM_NO)
		{
		 	var left = 30;
        	var top = 30;
        	var toolbar = 'no';
        	var menubar = 'no';
    	    var status = 'yes';
	        var scrollbars = 'yes';
        	var resizable = 'no';
			var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);
			var width = 750;
        	var height = 550;
        	var url = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
        	var PoDisWin =window.open(url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
        	PoDisWin.focus();
		}
		if(msg3==INDEX_DELY_TO_LOCATION)
		{
			PopupManager("DELY_TO_LOCATION");
		}
		if(msg3==INDEX_REC_VENDOR_NAME)
		{
			<%if(pre_cont_seq.equals("")){%>
			PopupManager("REC_VENDOR_NAME");
			<%}%>
		}
		if(msg3 == INDEX_ATTACH_NO)
		{
				var ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ATTACH_NO));
				Arow = msg2;
				document.form1.attach_gubun.value = "Sepoa";
				if("" == ATTACH_NO_VALUE) {
					FileAttach('PR','','');
				} else {
					FileAttachChange('PR', ATTACH_NO_VALUE);
				}
		}
		if(msg3==INDEX_MAKER_NAME){
      		if(GridObj.GetCellInfo("activation", "DESCRIPTION_LOC", msg2) == "edit"){
      			SP9053_Popup();
      		}

      	}

	}

	if(msg1 == "t_header")
	{
		if(msg3==INDEX_RD_DATE)
		{
			copyCell(Sepoa, INDEX_RD_DATE, "t_date");
		}

	}

	if(msg1 == "doData")
	{
		opener.doSelect();
		window.close();
		/*
		var mode  = GD_GetParam(GridObj,0);
		var status= GD_GetParam(GridObj,1);

		if(mode == "setReqBidChange")
		{
			alert(GridObj.GetMessage());
			if(status != "0")
			{
				GridObj.RemoveAllData();
				f.pr_tot_amt.value = "";
				parent.window.close();
				parent.parent.opener.doSelect();
			}
		}
		*/
	}

	//grid에러(테스트중)
<%-- 	if(msg1 == "doQuery")
	{
		document.form1.attach_count.value = "<%=ATT_COUNT%>";
		
		
 		if(summaryCnt == 0) {
			GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'PR_QTY,PR_AMT');
			GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
			summaryCnt++;
		}

		var ITEM_NO = "";
		var cur = "";
		for(var i=0; i<GridObj.GetRowCount(); i++){
			// 대표코드인경우에는 품목코드를 제외한 나머지를 모두 기입할 수 있다.
			ITEM_NO = GridObj.GetCellValue("ITEM_NO", i);
  			if(ITEM_NO.substring(2, 8) == "000000"){ // HW000000, SW000000, SI000000, CT000000
  	  			GridObj.SetCellBgColor("DESCRIPTION_LOC",  i  ,G_COL1_OPT);
				GridObj.SetCellBgColor("SPECIFICATION",    i  ,G_COL1_OPT);
				GridObj.SetCellBgColor("MAKER_NAME",    i  ,G_COL1_OPT);
				GridObj.SetCellBgColor("UNIT_MEASURE",    i  ,G_COL1_OPT);

				GridObj.SetCellActivation("DESCRIPTION_LOC",i,"edit") ;
				GridObj.SetCellActivation("SPECIFICATION",i,"edit") ;
				GridObj.SetCellActivation("UNIT_MEASURE",i,"edit") ;

				GD_SetCellValueIndex(GridObj,i, INDEX_MAKER_NAME,  "<%=G_IMG_ICON%>" + "&"+GridObj.GetCellValue("MAKER_NAME", i)+"&"+GridObj.GetCellValue("MAKER_NAME", i), "&");
  	 	 	}
  			
  			cur = GD_GetCellValueIndex(GridObj,i, INDEX_CUR);
			
			if(cur == 'KRW'){
				GridObj.SetCellActivation('EXCHANGE_RATE',i,'activatenoedit');
			}else{
				GridObj.SetCellActivation('EXCHANGE_RATE',i,'edit');
			}
			
			/*
			 * 이전계약의 검수승인된 품목인 경우 수정할 수 없도록 합니다.
			 *  - 수량, 통화, 단가
			 */
			//1. 기존 승인된 품목 수량일 경우 수정불가 처리.
			 if( GridObj.GetCellValue("PRE_TYPE", i)== "1"){
				GridObj.SetCellActivation('PR_QTY',i,'activatenoedit');
				GridObj.SetCellActivation('CUR',i,'activatenoedit');
				GridObj.SetCellActivation('UNIT_PRICE',i,'activatenoedit');
			 }
			GridObj.SetCellActivation('REC_VENDOR_NAME',i,'activatenoedit');
		}
		
		//2. 업체코드 저장.
		document.getElementById("REC_VENDOR_CODE").value= GridObj.GetCellValue("REC_VENDOR_CODE", 0);
		document.getElementById("REC_VENDOR_NAME").value= GridObj.GetCellValue("REC_VENDOR_NAME", 0);
		
		GridObj.AddComboListValue("UNIT_MEASURE", "", "");
	} --%>
}

/**
 * 구매요청금액을 계산한다.
 */
function calculate_pr_amt(wise, row){
	var prQty      = GD_GetCellValueIndex(GridObj, row, INDEX_PR_QTY);
	var unitPrice  = GD_GetCellValueIndex(GridObj, row, INDEX_UNIT_PRICE);
	var calculEval = getCalculEval(unitPrice);
	var prAmt      = 0;
	
	calculEval = prQty * calculEval;
	calculEval = getCalculEval(calculEval);
	prAmt      = RoundEx(calculEval, 3); // 소숫점 두자리까지 계산
	prAmt      = prAmt + "";
	
	if(prAmt.length > 17){
		alert("금액이 너무 큽니다.");
		
		GD_SetCellValueIndex(GridObj, row, INDEX_PR_AMT,     "0");
		GD_SetCellValueIndex(GridObj, row, INDEX_PR_QTY,     "0");
		GD_SetCellValueIndex(GridObj, row, INDEX_UNIT_PRICE, "0");
	}
	else{
		GD_SetCellValueIndex(GridObj, row, INDEX_PR_AMT, prAmt);
	}
	
	calculate_pr_tot_amt();
	
}

function RoundEx(val, pos){
    var rtn;
    
    rtn = Math.round(val * Math.pow(10, Math.abs(pos)-1))
    rtn = rtn / Math.pow(10, Math.abs(pos)-1)

    return rtn;
}

/*
총금액을 계산한다.
calculate_pr_amt에서 호출한다.
*/
function calculate_pr_tot_amt(){
	var f          = document.forms[0];
   var pr_tot_amt = 0;
   var pr_amt     = 0;

   for(var i=0;i<GridObj.GetRowCount();i++){
		pr_amt     = GD_GetCellValueIndex(GridObj, i, INDEX_PR_AMT);
		pr_amt     = getCalculEval(pr_amt);
		pr_tot_amt = pr_tot_amt + pr_amt;
	}
   
	f.expect_amt.value = add_comma(pr_tot_amt, 2);
}

/*
	결재, 저장 전 데이터 체크
	1) 헤더 체크
	2) 디테일 체크
	: 저장품(공장코드, 창고코드가 입력되어야한다.), 비저장품(남품요청장소가 입력되어야한다.)일때 구분한다.
*/
 function checkData(Sepoa, f)
  {
    var iRowCount = GridObj.GetRowCount();

   /* if(f.bsart.value == "")
    {
        alert("문서유형을 선택하셔야합니다.");
        return false;
    }*/
/*
    if(f.sales_type.value == "")
    {
        alert("구매요청구분을  선택하셔야합니다.");
        return false;
    }

    if(f.demand_dept.value == "")
    {
        alert("요청부서를  선택하셔야합니다.");
        f.demand_dept.focus();
        return false;
    }

    if(f.add_user_id.value == "")
    {
        alert("요청자를  선택하셔야합니다.");
        f.add_user_id.focus();
        return false;
    }
*/



    if(f.subject.value == "")
    {
      alert("요청명을 입력하셔야합니다.");
      f.subject.focus();
      return false;
    }
<%--
    if(f.scms_cust_code.value == "")
    {
      alert("고객사를 입력하셔야합니다.");
      f.scms_cust_code.focus();
      return false;
    }

     if(f.create_type.value == "")
    {
      alert("요청구분을 입력하셔야합니다.");
      f.create_type.focus();
      return false;
    }

--%>
	/*
	if(f.dely_location.value == "")
	{
	  alert("납품장소를 입력하셔야합니다.");
	  f.dely_location.focus();
	  return false;
	}
	if(f.dely_to_address.value == "")
	{
	  alert("납품주소를 입력하셔야합니다.");
	  f.dely_to_address.focus();
	  return false;
	}
	
	if(f.dely_to_user.value == "")
	{
	  alert("수령인을 입력하셔야합니다.");
	  f.dely_to_user.focus();
	  return false;
	}

	if(f.dely_to_phone.value == "")
	{
	  alert("수령인연락처를 입력하셔야합니다.");
	  f.dely_to_phone.focus();
	  return false;
	}
	
    if(f.sales_user_id.value == "")
    {
      alert("검수자를 입력하셔야합니다.");
      f.sales_user_id.focus();
      return false;
    }
    */
    /*
    if(f.contract_hope_day.value == "")
    {
      alert("매출계약예상일을  입력하셔야합니다.");
      f.contract_hope_day.focus();
      return false;
    }
*/
/*
    if(f.sales_type.value == "P"){
        if(f.wbs_no.value == ""){
            alert("요청구분이 프로젝트일 경우에는 WBS요소를 선택 하셔야 합니다.");
            return;
        }
    }

    if(f.create_type.value != "AC"){
        if(f.cust_code.value == ""){
            alert("구분이 사전원가, 정식입찰일 경우에는  고객명은 필 수 입력입니다.");
            return false;
        }
    }
    //if(!checkTel(f.tel_no,"전화번호 형태로 입력하셔야합니다 예)111-111-1111"))
    //  return false;

    if(!checkEmpty(f.demand_dept,"구매요청부서를 입력하셔야합니다."))
      return false;

    //if(!checkEmpty(f.account_code,"계정번호를 입력하셔야합니다."))
    //  return false;

    if(!checkKorea(f.subject,"구매요청용도는 한글 50자를 넘을 수 없습니다",50))
      return false;

    //if(!checkEmpty(f.z_code1,"프로젝트를 입력하셔야합니다."))
    //  return false;
*/


    for(var i=0;i<iRowCount;i++)
    {
      if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) != true)
        continue;
      
      if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY)))
      {
        alert("수량을 입력하셔야합니다.");
        return false;
      }
      
      if(parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY))==0)
      {
        alert("수량은 0보다 커야합니다.");
        return false;
      }
      
      if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_RD_DATE)))
      {
        alert("납기요청일을 입력하셔야합니다.");
        return false;
      }
      /*  			
      if(f.pr_type.value == 'I'){
       if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_DESCRIPTION_LOC)))
          {
            alert("품목명을 입력하셔야합니다.");
            return false;
          }

          if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY)))
          {
            alert("수량을 입력하셔야합니다.");
            return false;
          }
          if(parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY))==0)
          {
            alert("수량은 0보다 커야합니다.");
            return false;
          }
          if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_RD_DATE)))
          {
            alert("납기요청일을 입력하셔야합니다.");
            return false;
          }
          if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_DELY_TO_ADDRESS)))
          {
            alert("납품장소를 입력하셔야합니다.");
            return false;
          }
       }else{
         if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_DESCRIPTION_LOC)))
          {
            alert("기술구분을 입력하셔야합니다.");
            return false;
          }
          if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY)))
          {
            alert("공수(MM)을 입력하셔야합니다.");
            return false;
          }
          if(parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY))==0)
          {
            alert("공수(MM)은 0보다 커야합니다.");
            return false;
          }
       }
      */
/*
      if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_UNIT_PRICE)))
      {
        alert("요청단가를 입력하셔야합니다.");
        return false;
      }
      if(parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_UNIT_PRICE))==0)
      {
        alert("요청단가는 0보다 커야합니다.");
        return false;
      }
*/
      <%--
      if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_RD_DATE)))
      {
        alert("납기일자를 입력하셔야합니다.");
        return false;
      }
      if(GD_GetCellValueIndex(GridObj,i, INDEX_RD_DATE) <= eval("<%=SepoaDate.getShortDateString()%>"))
      {
        alert("납기일자를 확인하세요.");
        return false;
      }
      if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_CTRL_CODE)))
      {
        alert("구매직무코드를 입력하셔야합니다.");
        return false;
      }
      if( isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_PLANT_CODE)) )
      {
        alert("공장코드를 입력하셔야합니다.");
        return false;
      }

      if( isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_DELY_TO_LOCATION)) && isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_DELY_TO_LOCATION2)) )
      {
        alert("저장품일 경우 창고코드, 비저장품일 경우 납품요청장소를 반드시 입력하셔야합니다..");
        return false;
      }

      if( (!isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_DELY_TO_LOCATION))) && (!isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_DELY_TO_LOCATION2))) )
      {
        alert("창고코드(저장품)와 납품요청장소(비저장품)를 동시에 입력할 수 없습니다.");
        return false;
      }
      --%>

    }//End for

    return true;
  }//checkData End

	/*
		결재, 저장
	*/
	function Approval(sign_status)
	{
		var Sepoa = GridObj;
		var f = document.forms[0];
	
		var iRowCount = GridObj.GetRowCount();
		
		//var iCheckedCount = getCheckedCount(Sepoa, INDEX_SELECTED);
		var iCheckedCount = getCheckedCount(Sepoa, "SELECTED");
		
		if(iCheckedCount<1)
		{
			alert(G_MSS1_SELECT);
			return;
		}
		if(!checkData(Sepoa, f)){
			return;
		}
		
		f.sign_status.value = sign_status;
	
		if(sign_status == "P")
		{
			f.method = "POST";
			f.target = "childFrame";
			f.action = "/kr/admin/basic/approval/approval.jsp";
			f.submit();
		} else {
			getApproval(sign_status);
			return;
		}
	}//Approval End

	function getApproval(approval_str) {
		
    	var f = document.forms[0];

	    if(approval_str == "") {
			alert("결재자를 지정해 주세요");
			return;
    	}

		var Message = "";
		if(f.sign_status.value == "P"){
			Message = "결재하시겠습니까?";
		} else if(f.sign_status.value == "T"){
			Message = "임시저장 하시겠습니까?";
		} else if(f.sign_status.value == "E"){
			Message = "요청완료 하시겠습니까?";
		}

		if(!confirm(Message))
			return;

		f.approval_str.value = approval_str;
		getApprovalSend(approval_str);
	}

	function getApprovalSend(approval_str) {
	    var expectAmt = document.getElementById("expect_amt").value;
		
		expectAmt = del_comma(expectAmt);
		
		document.getElementById("expect_amt").value = expectAmt;
		document.getElementById("pr_tot_amt").value = expectAmt;
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var cols_ids = "<%=grid_col_id%>";
		var params = "?mode=setReqBidChange";
		
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		
		myDataProcessor = new dataProcessor(G_SERVLETURL+params);
		
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
	}

	function rMateFileAttach(att_mode, view_type, file_type, att_no) {
		var f = document.forms[0];

		f.att_mode.value   = att_mode;
		f.view_type.value  = view_type;
		f.file_type.value  = file_type;
		f.tmp_att_no.value = att_no;

		if (att_mode == "P") {
			var protocol = location.protocol;
			var host     = location.host;
			var addr     = protocol +"//" +host;

			var win = window.open("","fileattach",'left=0,top=0, width=620, height=300,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');

			f.method = "POST";
			f.target = "fileattach";
			f.action = addr + "/rMateFM/rMate_file_attach_pop.jsp";
			f.submit();
		} else if (att_mode == "S") {
			f.method = "POST";
			f.target = "attachFrame";
			f.action = "/rMateFM/rMate_file_attach.jsp";
			f.submit();
		}
	}

	function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
		var attach_key   = att_no;
		var attach_count = att_cnt;

		if (document.form1.attach_gubun.value == "Sepoa"){
			GD_SetCellValueIndex(GridObj,Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");

			document.form1.attach_gubun.value="body";
		} else {
			var f = document.forms[0];
		    f.attach_no.value    = attach_key;
		    f.attach_count.value = attach_count;

		    var approval_str = f.approval_str.value;
		    getApprovalSend(approval_str);
		}
	}


/*
	팝업 관련 코드
*/
function PopupManager(part)
{
	var url = "";
	var f = document.forms[0];
	var Sepoa = GridObj;

	if(part == "CATALOG") //카탈로그
	{
		setCatalogIndex(G_C_INDEX);
		
		//url = "/kr/catalog/cat_pp_lis_frame.jsp?INDEX=" + getAllCatalogIndex() ;
		url = "/kr/catalog/cat_pp_lis_main.jsp?INDEX=" + getAllCatalogIndex() ;
		
		CodeSearchCommon(url,"INVEST_NO",0,0,"950","530");
	}
	else if(part == "DELY_TO_LOCATION")
	{
		var plant_code = f.demand_dept.value;
		var item_no = GD_GetCellValueIndex(GridObj,G_CUR_ROW,INDEX_ITEM_NO);
		var arr = new Array(G_HOUSE_CODE, G_COMPANY_CODE, plant_code,item_no );
		PopupCommonArr("SP0237","getDely", arr, "","");
	}
	else if(part == "ITEM_NO")
	{
		var arr = new Array(G_HOUSE_CODE, "" );
		PopupCommonArr("SP0268","getItem",arr,"","");
	}
	else if(part == "DEMAND_DEPT")
	{
		window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "SALES_DEPT")
	{
		window.open("/common/CO_009.jsp?callback=getSales", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "SALES_USER_ID")
	{
		window.open("/common/CO_008.jsp?callback=getSalesUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "PROJECT_NM")
    {
      PopupCommon4("SP0350","getProject_nm",G_PRE_CODE,G_PRE_CODE,G_PRE_CODE,G_HOUSE_CODE,"프로젝트코드","프로젝트명");
    }
	else if(part == "CUST_CODE")
	{
		PopupCommon0("SP0277","getCust","매출처코드","매출처명");
	}
	else if(part == "REC_VENDOR_NAME")
	{
		window.open("/common/CO_014.jsp?callback=getRecv", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}
	else if(part == "ATTACH_FILE")
	{
		var attach_no = GD_GetCellValueIndex(GridObj,G_CUR_ROW, INDEX_ATTACH_NO);
		attach_file(attach_no,"PR");
	}
	else if(part == "DELY_TO_ADDRESS_GRID"){
    	window.open("/common/CO_009.jsp?callback=getDemandGrid", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
}

function getDemandGrid(code, text){
	GD_SetCellValueIndex(GridObj, G_CUR_ROW, GridObj.GetColHDIndex("DELY_TO_ADDRESS_CD"), code);
	GD_SetCellValueIndex(GridObj, G_CUR_ROW, INDEX_DELY_TO_ADDRESS, text);
}

function getProject_nm(code, text,cust, seq)
{
  document.form1.pjt_name.value = text;
  document.form1.pjt_code.value = code;
  document.form1.scms_cust_code.value = cust;
  document.form1.pjt_seq.value = seq;
}
function getDemand(code, text)
{
	document.form1.demand_dept_name.value = text;
	document.form1.demand_dept.value = code;
}

function getSales(code, text)
{
	document.form1.sales_dept_name.value = text;
	document.form1.sales_dept.value = code;
}

function getSalesUser(code, text)
{
	document.form1.sales_user_name.value = text;
	document.form1.sales_user_id.value = code;
}

function getRecv(code, text)
{
	var Sepoa = GridObj;
	GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_REC_VENDOR_CODE, code);
	GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_REC_VENDOR_NAME, text);
}

function getItem(code, text, basic_unit)
{
	var Sepoa = GridObj;
	GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_ITEM_NO,  G_IMG_ICON + "&"+code+"&"+code, "&");
	GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_DESCRIPTION_LOC, text);
	GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_UNIT_MEASURE, basic_unit);
}

function getCust(code, text)
{
	document.form1.cust_name.value = text;
	document.form1.cust_code.value = code;
}

function getDely(code, text)
{
	var Sepoa = GridObj;
	GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_DELY_TO_LOCATION, G_IMG_ICON + "&"+text+"&"+code, "&");
}

/*
	업체지정 팝업(VENDOR_SELECT)에서 호출한다.
	@parameter
	szRow           : 넘긴 와이즈테이블 로우
	values          : vendor_code@vendor_name@name@#
	count           : 선택된 업체수가 넘어온다.
*/
function vendorInsert(szRow, values, count)
{
		if(szRow == "-1") {
			for(row=0; row<GridObj.GetRowCount(); row++) {
				if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
					GD_SetCellValueIndex(GridObj,row, INDEX_REC_VENDOR_CODE,  G_IMG_ICON + "&" + count + "&Y", "&");
					GD_SetCellValueIndex(GridObj,row, INDEX_REC_VENDOR_SELECTED, values);
					GD_SetCellValueIndex(GridObj,row, IDX_VENDOR_CNT, count);
				}
			}
		} else {
			GD_SetCellValueIndex(GridObj,szRow, INDEX_REC_VENDOR_CODE,  G_IMG_ICON + "&" + count + "&Y", "&");
			GD_SetCellValueIndex(GridObj,szRow, INDEX_REC_VENDOR_SELECTED, values);
			GD_SetCellValueIndex(GridObj,szRow, IDX_VENDOR_CNT, count);
		}
}

/*
	파일첨부 팝업에서 받아오는 화면
*/
	function setAttach(attach_key, arrAttrach, attach_count) {

		if(document.form1.attach_gubun.value == "Sepoa"){
			GD_SetCellValueIndex(GridObj,Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");
		}else{
			var f = document.forms[0];
		    f.attach_no.value = attach_key;
		    f.attach_count.value = attach_count;
		}
		document.form1.attach_gubun.value="body";
	}

function PrdeleteSepoaTable() {
	/*
	for(var v1=0; v1 < GridObj.GetRowCount(); v1++){
		if(GridObj.GetCellValue("SELECTED", v1)=="1" && GridObj.GetCellValue("PRE_TYPE", v1)=="1"){
			alert("품목번호:"+ GridObj.GetCellValue("ITEM_NO", v1) + "는 이전계약으로 검수승인된 품목입니다. 삭제하실 수 없습니다.");
			return;
		}		
	}
	
	deleteSepoaTable(GridObj, INDEX_SELECTED);
	*/
	var rowCount = GridObj.GetRowCount();
	var selected = false;
	var rowid    = "";
	
	for(var i = (rowCount - 1); i >= 0; i--){
		selected   = GD_GetCellValueIndex(GridObj, i, INDEX_SELECTED);
		
		if(selected == true){
			rowid = GridObj.getRowId(i);
			
			GridObj.deleteRow(rowid);
		}
	}
}

function Line_insert() {

		var iMaxRow = GridObj.GetRowCount();
		GridObj.AddRow();

		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SELECTED,			"true", "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ITEM_NO, 			"" + "&"+"null"+"&"+"null", "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_DESCRIPTION_LOC, 	"");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_UNIT_MEASURE, 	"<%=COMBO_M007%>", "&","#");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_REC_VENDOR_NAME, 	G_IMG_ICON + "&"+"null"+"&"+"null", "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_DELY_TO_LOCATION, "");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ATTACH_NO, 		G_IMG_ICON + "&"+"null"+"&"+"null", "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CUR, 				"<%=COMBO_M002%>", "&","#");
		//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_RD_DATE, 		"");

		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PR_QTY,				"");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_LOCATION, 	"");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASER_ID,      	"");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASER_NAME,    	"");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_DEPT_NAME,	"");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_DEPT, 		"");

		GridObj.SetCellActivation('ITEM_NO', iMaxRow, 'disable');
		GridObj.SetCellActivation('DESCRIPTION_LOC', iMaxRow, 'edit');
		GridObj.SetCellActivation('UNIT_MEASURE', iMaxRow, 'edit');

}

//나의카탈로그
function mycatalog() {
    setCatalogIndex(G_C_INDEX_MY);
	url = "/kr/catalog/pr/pr1_pp_lis4.jsp?INDEX=" + getAllCatalogIndex() ;
    windowopen1 = window.open(url,"mycatalog_win","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=950,height=500,left=0,top=0");
}

function SP1001_Popup() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/Sepoapopup/cod_cm_lis1.jsp?code=SP1001&function=SP1001_Popup_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=&values=/&desc=프로젝트&desc=프로젝트명";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function SP1001_Popup_getCode(z_code1, project_name) {
	document.form1.z_code1.value = z_code1;
	document.form1.project_name.value = project_name;
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

function ExView(view_flag){

     if(view_flag==0){
		GridObj.SetColHide("EXCHANGE_RATE", true);
		GridObj.SetColHide("KRW_AMT", true);
     }else if(view_flag==1){
		GridObj.SetColHide("EXCHANGE_RATE", false);
	    GridObj.SetColHide("KRW_AMT", false);
     }else{
     }

}


function GridView(view_flag){
	if("<%=SALES_TYPE%>" == "") {
	 	clearSALES_TYPE();
		var id = "SL0018";

 		setHeader_1();
	    var code = "M372";
	    document.all.butt_i.style.display="";
	    document.all.butt_s.style.display="none";
	    document.form1.create_type.options[2].selected = true;
	    document.form1.create_type.disabled = false;
	    document.form1.hard_maintance_term.disabled = false;

	    /*
	     if(view_flag==0){
	     		setHeader_1();
			    var code = "M372";
			    document.all.butt_i.style.display="";
			    document.all.butt_s.style.display="none";
			    document.form1.create_type.options[2].selected = true;
			    document.form1.create_type.disabled = false;
			    document.form1.hard_maintance_term.disabled = false;

	     }else if(view_flag==1){
	     		setHeader_2();
			    var code = "M372";
			    document.all.butt_i.style.display="none";
			    document.all.butt_s.style.display="";
			    document.form1.create_type.options[0].selected = true;
			    document.form1.create_type.disabled = true;
			    document.form1.hard_maintance_term.disabled = true;
	     }
	     */
		var value = "<%=SALES_TYPE%>";
		target = "SALES_TYPE";

		data = "/kr/dt/pr/pr1_bd_ins1_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
		//data = "/kr/dt/ebd/ebd_bd_ins4_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value ;

		document.mainFrame.location.href = data;
      }
}

function setSALES_TYPE(name, value) {
    var option1 = new Option(name, value, true);
    form1.sales_type.options[form1.sales_type.length] = option1;
}


function clearSALES_TYPE() {
    if(form1.sales_type.length > 0) {
        for(i=form1.sales_type.length-1; i>=0;  i--) {
            form1.sales_type.options[i] = null;
        }
    }
}

function addDate(year,month,day,week)
{
       window.self.document.forms[0].add_date.value=year+month+day;
}

function returnhopeDay(year,month,day,week)
{
       window.self.document.forms[0].return_hope_day.value=year+month+day;
}

function contractDay(year,month,day,week)
{
       window.self.document.forms[0].contract_hope_day.value=year+month+day;
}
function contractFromDate(year,month,day,week)
{
       window.self.document.forms[0].contract_from_date.value=year+month+day;
}
function contractToDate(year,month,day,week)
{
       window.self.document.forms[0].contract_to_date.value=year+month+day;
}

function Line_insert_2() {

		var iMaxRow = GridObj.GetRowCount();
		GridObj.AddRow();
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SELECTED,			"true" );
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_TECHNIQUE_GRADE, 	"<%=COMBO_M000%>", "&","#");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_DESCRIPTION_LOC, 	"");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_TECHNIQUE_TYPE, 	"<%=COMBO_M001%>", "&","#");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ATTACH_NO, 		G_IMG_ICON + "&"+"null"+"&"+"null", "&");


		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_LOCATION, "");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASER_ID,      "");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASER_NAME,    "");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_DEPT_NAME,"");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_DEPT, 	"");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CUR, 				"<%=COMBO_M002%>", "&","#", "<%=COMBO_IDX_M002%>");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_UNIT_MEASURE, 	"MM");

}

function sales_com(){
	var f = document.forms[0];
	commaPrice(f.expect_amt,'add',2);
}
    function getOrder_pop() {

		var left = 0;
		var top = 0;
		var width = 1024;
		var height = 600;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/dt/pr/es_bd_lis1.jsp";
		var getOrderNoWin = window.open( url, 'getOrderNoWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

	}

  	function setOrderNO(cd_control, nm_control, cl_biz, cd_salecust, nm_salecust, dt_contstart, dt_contend, amt_cont,
  							cd_saledept, no_saleemp, nm_saledept, nm_saleemp){

	 document.forms[0].order_no.value 			= cd_control;
	 document.forms[0].order_name.value 		= nm_control;
	 document.forms[0].cl_biz.value 			= cl_biz;
	 document.forms[0].cust_code.value			= cd_salecust;
	 document.forms[0].cust_name.value			= nm_salecust;
	 document.forms[0].sales_dept.value 		= cd_saledept;
     document.forms[0].sales_user_id.value 		= no_saleemp ;
	 document.forms[0].sales_dept_name.value 	= nm_saledept;
     document.forms[0].sales_user_name.value 	= nm_saleemp ;
  }

  function orderChange(cd){

	  	document.form1.sales_type.disabled = true;

	  	if(cd == "M"){
	  		document.form1.cust_code.value = "<%=CUST_CODE %>";
	  		document.form1.cust_name.value = "<%=CUST_NAME %>";
	  		document.form1.order_no.value = "<%=ORDER_NO %>";
	  		document.getElementById("t_cls01").className = "se_cell_title";
	  		document.all["t_cls01"].innerHTML = "Sales Order";
	  		document.all["_div01"].style.display="block";
	  		document.all["_div02"].style.display="none";
	  	}else if(cd == "P"){
	  		document.form1.wbs_no.value = "<%=WBS_NO %>";
	  		document.form1.wbs_sub_no.value = "<%=WBS_SUB_NO %>";
	  		document.form1.wbs_txt.value = "<%=WBS_TXT %>";
	  		document.getElementById("t_cls01").className = "se_cell_title";
	  		document.all["t_cls01"].innerHTML = "WBS요소";
	  		document.all["_div01"].style.display="none";
	  		document.all["_div02"].style.display="block";
	  	}else{
	  		document.getElementById("t_cls01").className = "c_data_1";
	  		document.all["t_cls01"].innerHTML = "&nbsp;";
	  		document.all["_div01"].style.display="none";
	  		document.all["_div02"].style.display="none";
	  	}

}

  function searchCust() {
	url = "/kr/admin/Sepoapopup/cod_cm_lis1.jsp?code=SP0120F&function=scms_getCust&values=&values=/&desc=고객사코드&desc=고객사명";
	//CodeSearchCommon(url,'CUSTOMER_CODE','50','100','570','530');
	Code_Search(url,'','','','','');
  }

	/* 고객사 조회*/
  function scms_getCust(code, text, div) {
  	 document.form1.scms_cust_type.value = div;
	 document.form1.scms_cust_code.value = code;
	 document.form1.scms_cust_name.value = text;
  }

  function selectCode( maker_code, maker_name) {
		GridObj.SetCellValue("MAKER_CODE",G_CUR_ROW, maker_code);
		GridObj.SetCellValue("MAKER_NAME",G_CUR_ROW, maker_name);
		GridObj.SetCellHiddenValue("MAKER_NAME",G_CUR_ROW, maker_name);
	}
  function pcflagYn(obj){
	if(obj.checked){
		document.getElementById("pc_reason").disabled = false;
		document.getElementById("pc_flag").value='Y';
	}
	else{
		document.getElementById("pc_reason").disabled = true;
		document.getElementById("pc_reason").value = "";
		document.getElementById("pc_flag").value='N';
		//document.forms[0].pjt_code.focus();
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
		var url = "/kr/admin/Sepoapopup/cod_cm_lis1.jsp?code=SP0278&function=selectCode&values=<%=info.getSession("HOUSE_CODE")%>&values=M199&values=&values=/&desc=코드&desc=이름";
		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

    //var url = "/s_kr/admin/info/hico_code_search_pop.jsp?title=제조사 Code 검색&type=M199";
	//window.open( url, 'Category', 'left=50, top=100, width=500, height=450, toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=no');
	}
	
	var selectAllFlag = 0;
	
function selectAll(){
	if(selectAllFlag == 0)
	{
		for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
		{
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("1"); 
		}
		selectAllFlag = 1;
	}
	else
	{
		for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
		{
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("0");
		}
	}
}
</Script>



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
function doOnRowSelected(rowId,cellInd){
	if(cellInd == GridObj.getColIndexById("REC_VENDOR_NAME")) {
		G_CUR_ROW = GridObj.getRowIndex(GridObj.getSelectedId());
		
		PopupManager("REC_VENDOR_NAME");
	}
	else if(cellInd == GridObj.getColIndexById("ITEM_NO")) {
		var selectedId = GridObj.getSelectedId();
		var rowIndex   = GridObj.getRowIndex(selectedId);
		var itemNo     = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_ITEM_NO);
		
		var url        = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO=" + itemNo + "&BUY=";
		var PoDisWin   = window.open(url, 'agentCodeWin', 'left=0, top=0, width=750, height=550, toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes');
		
		PoDisWin.focus();
	}
	else if(cellInd == GridObj.getColIndexById("DELY_TO_ADDRESS")) {
		G_CUR_ROW = GridObj.getRowIndex(GridObj.getSelectedId());
		PopupManager('DELY_TO_ADDRESS_GRID');
	}
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
    	return true;
    }
    else if(stage==1) {
    }
    else if(stage==2) {
    	var prQtyIndex     = GridObj.getColIndexById("PR_QTY");
    	var unitPriceIndex = GridObj.getColIndexById("UNIT_PRICE");
    	var rowIndex       = GridObj.getRowIndex(GridObj.getSelectedId());
         
        if((cellInd == prQtyIndex) || (cellInd == unitPriceIndex)){
    		calculate_pr_amt(GridObj, rowIndex);
    	    
    		/*
    		if(summaryCnt == 0) {
    			GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'PR_QTY,PR_AMT');
    			GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
    			summaryCnt++;
    		}
    		*/
    		
    	}
        
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

    alert(messsage);
    
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
    if(status == "0"){
    	alert(msg);
    }
    
    document.forms[0].add_date.value          = add_Slash( document.forms[0].add_date.value          );
    document.forms[0].contract_hope_day.value = add_Slash( document.forms[0].contract_hope_day.value );
    
    selectAll();
     
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    
    return true;
}
</script>
</head>
<body onload="setGridDraw();init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<table width="99%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td class='title_page' height="20" align="left" valign="bottom">
				<span class='location_end'>구매요청 수정</span>
			</td>
		</tr>
	</table>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form1" action="">
		<input type="hidden" name="sign_status" id="sign_status" value="N"> <!-- 저장,결재를 구분하는 플래그 -->
	
		<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD--%>
		<input type="hidden" name="house_code" id="house_code" value="<%=info.getSession("HOUSE_CODE")%>">
		<input type="hidden" name="company_code" id="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
		<input type="hidden" name="dept_code" id="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
		<input type="hidden" name="req_user_id" id="req_user_id" value="<%=info.getSession("ID")%>">
		<input type="hidden" name="doc_type" id="doc_type" value="PR">
		<input type="hidden" name="fnc_name" id="fnc_name" value="getApproval">
		<input type="hidden" name="pr_tot_amt" id="pr_tot_amt" value="<%=PR_TOT_AMT%>">
		<input type="hidden" name="attach_no" id="attach_no" value="<%=ATTACH_NO%>">
		<input type="hidden" name="attach_gubun" id="attach_gubun" value="body">
		<input type="hidden" name="dely_to_location" id="dely_to_location" value="S100">
		<input type="hidden" name="plan_code" id="plan_code" value="1000">
	
		<input type="hidden" name="att_mode" id="att_mode"   value="">
		<input type="hidden" name="view_type" id="view_type"  value="">
		<input type="hidden" name="file_type" id="file_type"  value="">
		<input type="hidden" name="tmp_att_no" id="tmp_att_no" value="">
		<input type="hidden" name="attach_count" id="attach_count" value="">
		<input type="hidden" name="approval_str" id="approval_str" value="">
		
		<!-- 변경계약시 참조 변수 -->
		<input type="hidden" name="pre_cont_seq" id="pre_cont_seq" value="<%=pre_cont_seq%>">
		<input type="hidden" name="pre_cont_count" id="pre_cont_count" value="<%=pre_cont_count%>">
		<input type="hidden" name="REC_VENDOR_CODE" id="REC_VENDOR_CODE" value="">
		<input type="hidden" name="REC_VENDOR_NAME" id="REC_VENDOR_NAME" value="">
		
		<input type="hidden" name="order_name" id="order_name" value=""><%-- 없는 변수 추가 -.-;;; --%>
	
		<%--수주번호 조회 정보 HIDDEN FIELD--%>
		<input type="hidden" name="cl_biz" id="cl_biz" value="">

		<table width="100%" border="0" cellspacing="0" cellpadding="1" style="display: none;">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr style="display:none;">
										<td class="se_cell_title">문서유형</td>
										<td class="c_data_1">
											<select name="bsart" id="bsart" class="inputsubmit" style="width:120px" disabled>
												<option value="">-----</option>
												<%=LB_BSART%>
											</select>
										</td>
										<td class="se_cell_title" >고객명</td>
										<td class="c_data_1" >
											<input type="text" name="cust_code" id="cust_code" size="8" class="inputsubmit" value="<%=CUST_CODE%>">
											<a href="javascript:PopupManager('CUST_CODE');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<input type="text"   name="cust_name" id="cust_name" size="30" class="input_data2" value='' style="border:0" readonly>
										</td>
									</tr>
									<tr style="display:none;">
										<td class="se_cell_title">구매요청구분</td>
											<td class="c_data_1" >
												<select name="sales_type" id="sales_type" class="inputsubmit"  style="width:90px" onchange="orderChange(this.value)">
													<option value="">-----</option>
													<%=LB_S_SALES_TYPE %>
												</select>
											</td>
										<td id="t_cls01" class="c_data_1"></td>
										<td id="t_cls02" class="c_data_1">
											<div id="_div01" style="display:none;">
												<input type="text" name="order_no" id="order_no" size="15" maxlength="10" class="inputsubmit" value="" readonly>
												<a href="javascript:getOrder_pop();">
													<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
												</a>
											</div>
											<div id="_div02" style="display:none;">
												<input type="hidden" name="wbs_txt" id="wbs_txt">
												<input type="text" name="wbs_no" id="wbs_no" size="15" maxlength="10" class="inputsubmit" value="" readonly>
												<a href="javascript:getWbs_pop();">
													<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
												</a>
												<input type="text" name="wbs_sub_no" id="wbs_sub_no" size="20" class="input_data0" maxlength="15" style="border:0">
											</div>
										</td>
									</tr>
									<tr style="display:none;">
										<td width="15%" class="se_cell_title" >요청부서</td>
										<td width="35%" class="c_data_1" >
											<input type="text" name="demand_dept" id="demand_dept" size="10" class="input_re" value='<%=DEMAND_DEPT%>' readOnly>
											<input type="text" name="demand_dept_name" id="demand_dept_name" size="20" class="input_data2" maxlength="15" value='<%=DEMAND_DEPT_NAME%>' style="border:0">
										</td>
									</tr>
									<tr style="display: none">
										<td class="se_cell_title">영업부서</td>
										<td class="c_data_1">
											<input type="text" name="sales_dept" id="sales_dept" size="10"  class="input_data" readonly value="<%=SALES_DEPT%>">
											<a href="javascript:PopupManager('SALES_DEPT');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<input type="text" name="sales_dept_name" id="sales_dept_name" size="20" class="input_data2" maxlength="15" readonly style="border:0" value="<%=SALES_DEPT_NAME%>">
										</td>
									</tr>
									<tr style="display: none">
										<td class="se_cell_title" >검수자</td>
										<td  class="c_data_1" colspan="3">
											<input type="text" name="sales_user_id" id="sales_user_id" size="13"  class="input_re" readonly value="<%=SALES_USER_ID%>">
											<a href="javascript:PopupManager('SALES_USER_ID');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<input type="text" name="sales_user_name" id="sales_user_name" size="20" class="input_data2" maxlength="15" readonly style="border:0"  value="<%=SALES_USER_NAME%>">
										</td>
									</tr>
									<tr style="display:none;">
										<td width="15%" class="se_cell_title">프로젝트코드</td>
										<td class="c_data_1"  >
											<input type="text" name="wbs" id="wbs" style="width:93%" class="input_re" value="<%=wbs %>" onKeyUp="return chkMaxByte(500, this, '프로젝트코드');">
										</td>
										<td width="15%" class="se_cell_title">프로젝트명</td>
										<td class="c_data_1"  >
											<input type="text" name="wbs_name" id="wbs_name" style="width:93%" value="<%=wbs_name %>" class="input_re" onKeyUp="return chkMaxByte(500, this, '프로젝트명');">
										</td>
									</tr>
									<tr style="display:none;">
										<td width="15%" class="se_cell_title">납품장소</td>
										<td  class="c_data_1" colspan="">
											<input type="text" name="dely_location" id="dely_location" style="width:93%" value="<%=DELY_TO_LOCATION%>" onKeyUp="return chkMaxByte(80, this, '납품장소');" class='input_re'>
										</td>
										<td width="15%" class="se_cell_title">납품주소</td>
										<td class="c_data_1"  >
											<input type="text" name="dely_to_address" id="dely_to_address" style="width:93%" value="<%=DELY_TO_ADDRESS%>" onKeyUp="return chkMaxByte(100, this, '납품주소');" class='input_re'>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr style="display: none;">
										<td width="15%" class="se_cell_title" style="display: none;">프로젝트</td>
										<td  width="35%" class="c_data_1" style="display: none;">
											<input type="text" name="pjt_code" id="pjt_code" size="20" style="width:43%" class="input_re" value='<%=wbs%>' readOnly>
<%
	if(!pre_cont_seq.equals("")){ //변경계약 구매요청일 경우 프로젝트 코드 수정이 불가
%>
											<a href="javascript:PopupManager('PROJECT_NM');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">       
											</a>
<%
	}
%>
											<input type="text" name="pjt_name" id="pjt_name" size="20" class="input_data2" maxlength="15" value='<%=wbs_name%>'>
											<input type="hidden" name="pjt_seq" id="pjt_seq" value="<%=PJT_SEQ %>"/>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사전지원</td>
										<td class="data_td" colspan="3" >
											<input type="text" name="pre_pjt_code" id="pre_pjt_code" size="300" style="width:43%" class="input_re" value='<%=addPrNo %>' readOnly>
<%
	if(!pre_cont_seq.equals("")){ //변경계약 구매요청일 경우 수정이 불가
%>
											<a href="javascript:PREPJTCODE();">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
<%
	}
%>
											<input type="text" name="pre_pjt_name" id="pre_pjt_name" size="20" maxlength="15" value='' style="border:0">
										</td>
									</tr>
									<tr style="display: none;">
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매요청번호</td>
										<td  width="35%" class="data_td" >
											<input type="text" name="rfq_no" id="rfq_no" style="width:93%" class="input_re" readonly value="<%=PR_NO%>">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청명</td>
										<td  width="35%" class="data_td" >
											<input type="text" name="subject" id="subject" style="width:93%" class="input_re" value="<%=SUBJECT%>" onKeyUp="return chkMaxByte(500, this, '요청명');">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td class="se_cell_title" style="display: none;">고객사</td>
										<td class="c_data_1" style="display: none;">
											<input type="text" name="scms_cust_code" id="scms_cust_code" size="10"  class="inputsubmit" value="<%=CUST_CODE%>" readonly>
											<a href="javascript:searchCust();">
												<img src="<%=G_IMG_ICON%>" border="0" >
											</a>      
											<input type="text"   name="scms_cust_name" id="scms_cust_name" size="30" class="input_data2" value="<%=CUST_NAME%>" style="border:0" readonly>
											<input type="hidden" name="scms_cust_type" id="scms_cust_type" size="30" class="input_data2" value="<%=CUST_TYPE%>" style="border:0" readonly>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청일자</td>
										<td class="data_td" colspan="3">
											<input type="hidden" name="add_user_id" id="add_user_id" value='<%=ADD_USER_ID%>'>
											<s:calendar id="add_date" default_value="<%=this.getDateSlashFormat(ADD_DATE)%>" format="%Y/%m/%d"/>
										</td>
									</tr>
									<tr style="display: none;">
										<td class="se_cell_title">매출계약예상일</td>
										<td class="c_data_1">
											<s:calendar id="contract_hope_day" default_value="<%=CONTRACT_HOPE_DAY%>" format="%Y/%m/%d"/>
										</td>
										<td class="se_cell_title">예상금액</td>
										<td class="c_data_1" >
											<input type="text" name="expect_amt" id="expect_amt" size="10" style="width:93%" class="input_re" value="<%=PR_TOT_AMT%>"  readonly>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr style="display: none;">
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;수의여부</td>
										<td class="data_td" colspan="3">
											<input type="checkbox" name="pc_flag" id="pc_flag" onChange="pcflagYn(this);" <%if("Y".equals(PC_FLAG)){ %> checked="checked" <%} %>>
											사유 : <input type="text" name="pc_reason" id="pc_reason" style="width:90%" class="inputsubmit"  value="<%=PC_REASON%>" <%if("N".equals(PC_FLAG)){ %> disabled="disabled;" <%} %> onKeyUp="return chkMaxByte(2000, this, '사유');" >
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr style="display: none;">
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;특기사항</td>
										<td class="data_td" colspan="3" height="150px">
											<textarea name="REMARK" id="REMARK" class="inputsubmit" style="width:98%;height: 130px;" rows="5" onKeyUp="return chkMaxByte(4000, this, '특기사항');"><%=REMARK%></textarea>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
										<td class="data_td" colspan="3">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="15%">
<script language="javascript">
function setAttach(attach_key, arrAttrach, rowId, attach_count) {
	document.getElementById("sign_attach_no").value = attach_key;
	document.getElementById("sign_attach_no_count").value = attach_count;
}
	
btn("javascript:attach_file(document.getElementById('sign_attach_no').value, 'TEMP');", "파일등록");
</script>
													</td>
													<td>
														<input type="text" size="3" readOnly class="input_empty" value="<%=ATT_COUNT %>" name="sign_attach_no_count" id="sign_attach_no_count"/>
														<input type="hidden" value="<%=ATTACH_NO %>" name="sign_attach_no" id="sign_attach_no">
													</td>
												</tr>
											</table>
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
				<td height="30" align="right" >
					<TABLE cellpadding="0">
						<TR>
							<TD>
								<script language="javascript">
									btn("javascript:PopupManager('CATALOG')","카탈로그");
								</script>
							</TD>
							<TD>
								<script language="javascript">
									btn("javascript:mycatalog()","나의 카탈로그");
								</script>
							</TD>
							<TD>
								<script language="javascript">
									btn("javascript:Approval('T')","임시저장");
								</script>
							</TD>
<%
	if (sign_use_yn) {
		if(!pre_cont_seq.equals("")){ //변경계약 구매요청일 경우 요청완료처리하도록 한다.
%>
							<TD>
								<script language="javascript">
									btn("javascript:Approval('E')","요청완료");
								</script>
							</TD>
<%
		}
		else{ 
%>
							<TD>
								<script language="javascript">
									//btn("javascript:Approval('P')","결재요청");
									btn("javascript:Approval('E')","요청완료");
								</script>
							</TD>
<%
		}
	}
	else {
%>
							<TD>
								<script language="javascript">
									btn("javascript:Approval('E')","요청완료");
								</script>
							</TD>
<%
	}
%>
							<TD>
								<script language="javascript">
									btn("javascript:PrdeleteSepoaTable()","행삭제");
								</script>
							</TD>
							<TD>
								<script language="javascript">
									btn("javascript:window.close()","닫 기");
								</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
	<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
	<iframe name="mainFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="PR_009" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>