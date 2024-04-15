<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BR_001_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BR_001_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON = "/images/ico_zoom.gif"; 

    String USER_ID        = info.getSession("ID");
    String HOUSE_CODE     = info.getSession("HOUSE_CODE") ;
    String COMPANY_CODE   = info.getSession("COMPANY_CODE") ;
    String CURRENT_DATE     = SepoaDate.getShortDateString(); // yyyymmdd
    String RETURN_HOPE_DAY  = SepoaDate.addSepoaDateDay(CURRENT_DATE,7); // yyyymmdd
    String LB_CODE_SHIPPER_TYPE = "D";     //LISTBOX VALUE
    String LB_PR_TYPE           = ListBox(request, "SL0018",  HOUSE_CODE+"#M138#", "I"); //LISTBOX
    String LB_MAINTANCE_TERM    = ListBox(request, "SL0018",  HOUSE_CODE+"#M165#", "");
    String LB_CREATE_TYPE       = ListBox(request, "SL9997",  HOUSE_CODE+"#M113#B#", "BD");
    String LB_BSART             = ListBox(request, "SL0018",  HOUSE_CODE+"#M371#", "");
    String LB_S_SALES_TYPE      = ListBox(request, "SL0018",  HOUSE_CODE+"#M372#", "P");
    
    SepoaListBox LB = new SepoaListBox(); //WiseTable 콤보박스
    String COMBO_M000     = LB.Table_ListBox(request, "SL0022", HOUSE_CODE+"#M169#", "&" , "#");
    String COMBO_M001     = LB.Table_ListBox(request, "SL0018", HOUSE_CODE+"#M170#", "&" , "#");
    String COMBO_M002     = LB.Table_ListBox(request, "SL0014", HOUSE_CODE+"#M002#", "&" , "#");
    String COMBO_IDX_M002 = ""+CommonUtil.getComboIndex(COMBO_M002,"KRW","#");
    String COMBO_M007     = LB.Table_ListBox(request, "SL0014", HOUSE_CODE+"#M007#", "&" , "#");
    String COMBO_M933     = LB.Table_ListBox(request, "SL0022", HOUSE_CODE+"#M933#", "&" , "#");
	String WISEHUB_PROCESS_ID="BR_001_1";
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
	<jsp:param name="screen_id" value="BR_001_2"/>  
	<jsp:param name="grid_obj" value="GridObj_1"/>
	<jsp:param name="grid_box" value="gridbox_1"/>
	<jsp:param name="grid_cnt" value="2"/>
</jsp:include>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>
<Script language="javascript" type="text/javascript">
var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_ins5";
var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";
var G_SAVE_STATUS  = "T";
var G_CUR_ROW;//팝업 관련해서 씀..
var summaryCnt = 0;
var G_PRE_CODE   = "A";
var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
var INDEX_SELECTED;
var INDEX_ITEM_NO;
var INDEX_DESCRIPTION_LOC;
var INDEX_UNIT_MEASURE;
var INDEX_PR_QTY;
var INDEX_CUR;
var INDEX_UNIT_PRICE;
var INDEX_RD_DATE;
var INDEX_PR_AMT;
var INDEX_ATTACH_NO;
var INDEX_REC_VENDOR_CODE;
var INDEX_REC_VENDOR_NAME;
var INDEX_REMARK;
var INDEX_DELY_TO_LOCATION;
var INDEX_PURCHASE_LOCATION;
var INDEX_PURCHASER_ID;
var INDEX_PURCHASER_NAME;
var INDEX_PURCHASE_DEPT_NAME;
var INDEX_TECHNIQUE_GRADE;
var INDEX_TECHNIQUE_TYPE;
var INDEX_INPUT_FROM_DATE;
var INDEX_INPUT_TO_DATE;
var INDEX_WBS_NO;
var INDEX_WBS_SUB_NO;
var INDEX_WBS_TXT;
var INDEX_ORDER_SEQ;
var INDEX_ITEM_GROUP;

function init(){
	setGridDraw();
	setHeader_1();
	GridView(0);
	setHeader_2();
}

function init_1(){}

function setHeader_1(){
	var wise = GridObj;

    INDEX_SELECTED           = GridObj.GetColHDIndex("SELECTED");
	INDEX_ITEM_NO            = GridObj.GetColHDIndex("ITEM_NO");
	INDEX_DESCRIPTION_LOC    = GridObj.GetColHDIndex("DESCRIPTION_LOC");
	INDEX_SPECIFICATION      = GridObj.GetColHDIndex("SPECIFICATION");
	INDEX_MAKER_NAME         = GridObj.GetColHDIndex("MAKER_NAME");
	INDEX_MAKER_CODE         = GridObj.GetColHDIndex("MAKER_CODE");
	INDEX_UNIT_MEASURE       = GridObj.GetColHDIndex("UNIT_MEASURE");
	INDEX_PR_QTY             = GridObj.GetColHDIndex("PR_QTY");
	INDEX_CUR                = GridObj.GetColHDIndex("CUR");
	INDEX_UNIT_PRICE         = GridObj.GetColHDIndex("UNIT_PRICE");
	INDEX_RD_DATE            = GridObj.GetColHDIndex("RD_DATE");
	INDEX_PR_AMT             = GridObj.GetColHDIndex("PR_AMT");
	INDEX_REC_VENDOR_CODE    = GridObj.GetColHDIndex("REC_VENDOR_CODE");
	INDEX_REC_VENDOR_NAME    = GridObj.GetColHDIndex("REC_VENDOR_NAME");
	INDEX_ATTACH_NO          = GridObj.GetColHDIndex("ATTACH_NO");
	INDEX_REMARK             = GridObj.GetColHDIndex("REMARK");
	INDEX_PURCHASE_LOCATION  = GridObj.GetColHDIndex("PURCHASE_LOCATION");
	INDEX_PURCHASER_ID       = GridObj.GetColHDIndex("PURCHASER_ID");
	INDEX_PURCHASER_NAME     = GridObj.GetColHDIndex("PURCHASER_NAME");
	INDEX_PURCHASE_DEPT_NAME = GridObj.GetColHDIndex("PURCHASE_DEPT_NAME");
	INDEX_PURCHASE_DEPT      = GridObj.GetColHDIndex("PURCHASE_DEPT");
	INDEX_WBS_NO             = GridObj.GetColHDIndex("WBS_NO");
	INDEX_WBS_SUB_NO         = GridObj.GetColHDIndex("WBS_SUB_NO");
	INDEX_WBS_TXT            = GridObj.GetColHDIndex("WBS_TXT");
	INDEX_ORDER_SEQ          = GridObj.GetColHDIndex("ORDER_SEQ");
	INDEX_ITEM_GROUP         = GridObj.GetColHDIndex("ITEM_GROUP");
	INDEX_CONTRACT_DIV       = GridObj.GetColHDIndex("CONTRACT_DIV");
	INDEX_DELY_TO_ADDRESS	 = GridObj.GetColHDIndex("DELY_TO_ADDRESS");
	INDEX_DELY_TO_ADDRESS_CD = GridObj.GetColHDIndex("DELY_TO_ADDRESS_CD");
	INDEX_WARRANTY	         = GridObj.GetColHDIndex("WARRANTY");
	INDEX_CTRL_CODE          = GridObj.GetColHDIndex("CTRL_CODE");
	INDEX_MATERIAL_TYPE      = GridObj.GetColHDIndex("MATERIAL_TYPE");

    GridObj.strHDClickAction="select";
}

function setHeader_2(){
	var wise = GridObj;
}

/*카탈로그 : cat_pp_lis_main.jsp에서 호출되는 부분, 선택한 항목에 대해 와이즈 테이블에 인서트한다.*/
function setCatalog1(arr) {
	var wise = GridObj;
	var ITEM_NO = arr[getCatalogIndex("BUYER_ITEM_NO")];
	var dup_flag = true;
	
	for(var i=0;i<GridObj.GetRowCount();i++) {
		if(ITEM_NO == GD_GetCellValueIndex(GridObj,i,INDEX_ITEM_NO)) {
			dup_flag = true;
			
			break;
		}
	}

	if(!dup_flag) {
		var iMaxRow = GridObj.GetRowCount();
		GridObj.AddRow();

		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SELECTED,     "true", "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ITEM_NO,      "null&"+ITEM_NO+"&"+ITEM_NO, "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_DESCRIPTION_LOC,  arr[getCatalogIndex("DESCRIPTION_LOC")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_REC_VENDOR_NAME,  "<%=G_IMG_ICON%>" + "&"+"null"+"&"+"null", "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ATTACH_NO,    "<%=G_IMG_ICON%>" + "&"+"null"+"&"+"null", "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CUR,        "<%=COMBO_M002%>", "&","#", "<%=COMBO_IDX_M002%>");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PR_QTY,     arr[getCatalogIndex("QTY")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_LOCATION, arr[getCatalogIndex("PURCHASE_LOCATION")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASER_ID,      arr[getCatalogIndex("CTRL_PERSON_ID")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASER_NAME,    arr[getCatalogIndex("PURCHASER_NAME")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_DEPT_NAME,arr[getCatalogIndex("PURCHASE_DEPT_NAME")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_DEPT,  arr[getCatalogIndex("PURCHASE_DEPT")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_NO,         document.form1.wbs_no.value);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_SUB_NO,     document.form1.wbs_sub_no.value);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_TXT,        document.form1.wbs_txt.value);
	}
}

var ADD_UNIT_MEASURE_OPTION_CNT = 0;

function setCatalog(itemNo, descriptionLoc, specification, makerCode, ctrlCode, qty, itemGroup, delyToAddress, unitPrice, ktgrm, makerName, basicUnit, materialType){
	var dup_flag   = false;
	var i          = 0;
	var iMaxRow    = GridObj.GetRowCount();
	var newId      = (new Date()).valueOf();
	var pjt_code   = document.getElementById("pjt_code").value;
	
	GridObj.addRow(newId, "");
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SELECTED,     	  "true");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_NO,      	  itemNo);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DESCRIPTION_LOC, descriptionLoc);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SPECIFICATION,   specification);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKER_CODE,      makerCode);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CTRL_CODE,       ctrlCode);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_PR_QTY,          qty);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_GROUP,      itemGroup);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_PRICE,      unitPrice);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKER_NAME,      makerName);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_MEASURE,    basicUnit);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MATERIAL_TYPE,   materialType);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CUR,             "KRW");
    
	if(pjt_code != ''){
		if(pjt_code.substr(0,2) == 'SI' && ktgrm == '01'){
			GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ACCOUNT_TYPE, "상품(" + pjt_code.substr(0,5) + ")");
		}
		else{
			GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ACCOUNT_TYPE, pjt_code.substr(0,9));
		}
	}
     
	if(ADD_UNIT_MEASURE_OPTION_CNT == 0){
		ADD_UNIT_MEASURE_OPTION_CNT++;
	}
	
	if((GD_GetCellValueIndex(GridObj,iMaxRow, INDEX_CUR ) == "KRW") == false){}
	
	calculate_pr_amt(GridObj, iMaxRow);
	calculate_pr_tot_amt();

	return true;
}

function setCatalog2(arr){
	var wise = GridObj;
    var ITEM_NO = arr[getCatalogIndex("MATNR")];
    var dup_flag = false;
    
    for(var i=0;i<GridObj.GetRowCount();i++){
		if(ITEM_NO == GD_GetCellValueIndex(GridObj,i,INDEX_ORDER_SEQ)){
			dup_flag = true;
			
			break;
        }
    }

    var iMaxRow = GridObj.GetRowCount();
	GridObj.AddRow();

	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SELECTED,         "true" );
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ITEM_NO,          "null&"+ITEM_NO+"&"+ITEM_NO, "&");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_DESCRIPTION_LOC,  arr[getCatalogIndex("ARKTX")]);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PR_QTY,       arr[getCatalogIndex("KWMENG")]);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_UNIT_MEASURE,     "<%=COMBO_M007%>", "&","#");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_REC_VENDOR_NAME,  "<%=G_IMG_ICON%>" + "&"+"null"+"&"+"null", "&");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ATTACH_NO,    "<%=G_IMG_ICON%>" + "&"+"null"+"&"+"null", "&");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CUR,              "<%=COMBO_M002%>", "&","#", "<%=COMBO_IDX_M002%>");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_NO,           arr[getCatalogIndex("PS_PSP_PNR")]);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_SUB_NO,       arr[getCatalogIndex("CONV_PSPNR")]);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_TXT,          arr[getCatalogIndex("POST1")]);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ORDER_SEQ,        arr[getCatalogIndex("VBELP")]);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ITEM_GROUP,       arr[getCatalogIndex("PSTYV")]);

	GridObj.SetComboSelectedHiddenValue('UNIT_MEASURE',iMaxRow,arr[getCatalogIndex("VRKME")]);

	document.forms[0].order_no.value = arr[getCatalogIndex("VBELN")];
	document.forms[0].cust_code.value = arr[getCatalogIndex("KUNNR")];
	document.forms[0].cust_name.value = arr[getCatalogIndex("WAERK")];
	document.forms[0].subject.value = arr[getCatalogIndex("POST1")];
}

function JavaCall(msg1, msg2, msg3, msg4, msg5) {
    var wise = GridObj;
    var f = document.forms[0];

    if(msg1 == "t_insert") {
      	if(msg3 == INDEX_PR_QTY || msg3 == INDEX_UNIT_PRICE) {
        	calculate_pr_amt(wise, msg2);

        	if(summaryCnt == 0) {
            	GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'PR_QTY,PR_AMT');
            	GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
            	summaryCnt++;
          	}
		}
    }

    if(msg1 == "t_imagetext"){
		G_CUR_ROW = msg2;

		if(msg3 == INDEX_ITEM_NO) {}
		
		if(msg3==INDEX_DELY_TO_LOCATION) {
			PopupManager("DELY_TO_LOCATION");
		}
		
		if(msg3==INDEX_REC_VENDOR_NAME) {
			PopupManager("REC_VENDOR_NAME");
		}
		
		if(msg3 == INDEX_ATTACH_NO) {
			var ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ATTACH_NO));
			Arow = msg2;
			document.form1.attach_gubun.value = "wise";
			
			if("" == ATTACH_NO_VALUE) {
				FileAttach('PR','','');
			}
			else {
				FileAttachChange('PR', ATTACH_NO_VALUE);
			}
		}
		
		if(msg3==INDEX_MAKER_NAME){
			if(GridObj.GetCellInfo("activation", "DESCRIPTION_LOC", msg2) == "edit"){
				SP9053_Popup();
			}
		}
	}

    if(msg1 == "t_header"){
		if(msg3==INDEX_RD_DATE){
			copyCell(wise, INDEX_RD_DATE, "t_date");
		}
	}

    if(msg1 == "doData"){
    	location.href = "/kr/dt/ebd/ebd_bd_lis3.jsp";
	}
}

function setAttach(attach_key, arrAttrach, attach_count) {
	if(document.form1.attach_gubun.value == "wise"){
		GD_SetCellValueIndex(GridObj,Arow, INDEX_ATTACH_NO, "<%=G_IMG_ICON%>" + "&" + attach_count + "&" + attach_key, "&");
	}
	else{
		var f = document.forms[0];
		f.attach_no.value = attach_key;
		f.attach_count.value = attach_count;
	}
	
	document.form1.attach_gubun.value="body";
}

function calculate_pr_amt(wise, row){
	var prQty      = GD_GetCellValueIndex(wise, row, INDEX_PR_QTY);
	var unitPrice  = GD_GetCellValueIndex(wise, row, INDEX_UNIT_PRICE);
	var calculEval = getCalculEval(unitPrice);
	var prAmt      = 0;
		
	calculEval = prQty * calculEval;
	calculEval = getCalculEval(calculEval);
	prAmt      = RoundEx(calculEval, 3); // 소숫점 두자리까지 계산
	prAmt      = prAmt + "";
		
	GD_SetCellValueIndex(wise, row, INDEX_PR_AMT, prAmt);
		
	calculate_pr_tot_amt();
}  

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

function checkData(wise, f){
	var iRowCount = GridObj.GetRowCount();

    if(f.sales_type.value == ""){
		alert("구매요청구분을  선택하셔야합니다.");
		
        return false;
    }
    
    if(f.demand_dept.value == ""){
        alert("요청부서를  선택하셔야합니다.");
        f.demand_dept.focus();
        
        return false;
    }

    if(f.add_user_id.value == ""){
        alert("요청자를  선택하셔야합니다.");
        f.add_user_id.focus();
        
        return false;
    }

    if(f.subject.value == ""){
      alert("요청명을 입력하셔야합니다.");
      f.subject.focus();
      
      return false;
    }

	if(f.create_type.value == ""){
		alert("요청구분을 입력하셔야합니다.");
		f.create_type.focus();
		
		return false;
	}
     
	if(f.add_date.value < eval("<%=SepoaDate.getShortDateString()%>")){
		alert("요청일자는 오늘 이후여야 합니다.");
		
		return false;
	}

	if(f.pr_gubun.value == "P"){
		if(f.scms_cust_code.value == ""){
			alert("고객사를 입력하셔야합니다.");
			f.scms_cust_code.focus();
			
			return false;
		}
		
		if(f.sales_amt.value == ""){
			alert("매출액을 입력하셔야합니다.");
			f.sales_amt.focus();
			
			return false;
		}

		f.sales_amt.value = del_comma(f.sales_amt.value);

		if(f.order_no.value == ""){
			alert("수주번호를 입력하셔야합니다.");
			f.order_no.focus();
			
			return false;
		}
		
		if(f.order_count.value == ""){
			alert("수주차수를  입력하셔야합니다.");
			f.order_count.focus();
			
			return false;
		}
		
		if(f.project_pm.value == ""){
			alert("프로젝트 책임자를 입력하셔야합니다.");
			f.project_pm.focus();
			
			return false;
		}
		
		if(f.contract_from_date.value == ""){
			alert("프로젝트 수행시작일을 입력하셔야합니다.");
			f.contract_from_date.focus();
			
			return false;
		}
		
		if(f.contract_to_date.value == ""){
			alert("프로젝트 수행종료일을 입력하셔야합니다.");
			f.contract_to_date.focus();
			
			return false;
		}
	}

	var rdDateMsg = '';
	
	for(var i=0;i<iRowCount;i++){
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) != true)
			continue;

		if(f.pr_type.value == 'I'){
			if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_DESCRIPTION_LOC))){
				alert("품목명을 입력하셔야합니다.");
				
				return false;
			}

			if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY))){
				alert("수량을 입력하셔야합니다.");
				
				return false;
			}
			
			if(parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY))==0){
				alert("수량은 0보다 커야합니다.");
				
				return false;
			}
		}
		else{
			if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_DESCRIPTION_LOC))){
				alert("기술구분을 입력하셔야합니다.");
				
				return false;
			}
			
			if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY))){
				alert("공수(MM)을 입력하셔야합니다.");
				
				return false;
			}
			
			if(parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY))==0){
				alert("공수(MM)은 0보다 커야합니다.");
				
				return false;
			}
		}
      
		if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_RD_DATE))){
			alert("납기일자를 입력하셔야합니다.");
			
			return false;
		}
		
		if(GD_GetCellValueIndex(GridObj,i, INDEX_RD_DATE) <= eval("<%=SepoaDate.getShortDateString()%>")){
			alert("납기요청일은 오늘 이후 날짜로 설정해야 합니다.");
			
			return false;
		}
		
		var addDate = '<%=SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(), 14)%>';
      
		if(addDate > GD_GetCellValueIndex(GridObj,i, INDEX_RD_DATE)){}
	}//End for
    
    if(rdDateMsg != ''){
    	alert(rdDateMsg);
    }

    return true;
}//checkData End

/*결재, 저장*/
function Approval(sign_status){
	var wise = GridObj;
	var f = document.forms[0];
    
	if(f.pr_gubun.value == "P"){ //2010.12.08 swlee modify
		if(sign_status != "E"){
    		alert("등록구분이 구매요청일 경우 저장은 지원하지 않습니다.\n\n요청을 클릭하여 진행해 주세요."); //IBK시스템에선 영업관리시스템을 통해 PR정보를 내려 받아 진행하므로 sign_status = 'E'만 존재. 수정할 페이지가 없다.
    		
    		return;
		}
    }

    var iRowCount = GridObj.GetRowCount();
	var isSelected = false;
	
	for(var i=0;i<iRowCount;i++){
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == true){
			isSelected = true;
			
			break;
		}
	}
	
	if(isSelected == false){
		alert(G_MSS1_SELECT);
		
		return;
	}
	
    if(!checkData(wise, f))
		return;

	f.sign_status.value = sign_status;
	
	if(sign_status == "P"){
		f.method = "POST";
		f.target = "childFrame";
		f.action = "/kr/admin/basic/approval/approval.jsp";
		f.submit();
	}
	else {
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
	}
	else if(f.sign_status.value == "T"){
		Message = "저장 하시겠습니까?";
	}
	else if(f.sign_status.value == "E"){
		Message = "요청 하시겠습니까?";
	}
	
	if(!confirm(Message)) return;
		
	getApprovalSend(approval_str);
}

function getApprovalSend(approval_str) {
	var f = document.forms[0];
		
	f.expect_amt.value = del_comma(f.expect_amt.value);
	f.pr_tot_amt.value = f.expect_amt.value;
	f.approval_str.value = approval_str;
	f.ctrl_code.value = ctrl_code[0];
    	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	
	params = "?mode=setPrCreate";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
		
	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
	
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
}

function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
	var attach_key   = att_no;
	var attach_count = att_cnt;

	if (document.form1.attach_gubun.value == "wise"){
		GD_SetCellValueIndex(GridObj,Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");

		document.form1.attach_gubun.value="body";
	}
	else {
		var f = document.forms[0];
		
		f.attach_no.value    = attach_key;
		f.attach_count.value = attach_count;

		var approval_str = f.approval_str.value;
		
		getApprovalSend(approval_str);
	}
}

/*팝업 관련 코드*/
function PopupManager(part){
	var url = "";
	var f = document.forms[0];
	var wise = GridObj;

	if(part == "CATALOG"){ //카탈로그
		if(f.sales_type.value == ""){
			alert("구매요청구분을 선택 후 카탈로그를 선택 하십시요");
			
			return;
		}

		if(f.sales_type.value == "M"){
			alert("구매요청구분이 판매오더인 경우 카탈로그 사용을 하실 수 없습니다.");
			
			return;
		}

		setCatalogIndex("MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:DELIVERY_IT:MAKER_NAME:MAKER_CODE:ITEM_GROUP");
		url = "/kr/catalog/cat_pp_lis_frame.jsp?INDEX=" + getAllCatalogIndex() ;
		CodeSearchCommon(url,"INVEST_NO",0,0,"950","530");
	}
    else if(part == "DELY_TO_LOCATION"){
		var plant_code = f.demand_dept.value;
		var item_no = GD_GetCellValueIndex(GridObj,G_CUR_ROW,INDEX_ITEM_NO);
		var arr = new Array(G_HOUSE_CODE, G_COMPANY_CODE, plant_code,item_no );
		PopupCommonArr("SP0237","getDely", arr, "","");
    }
    else if(part == "ITEM_NO"){
		var arr = new Array(G_HOUSE_CODE, "" );
		PopupCommonArr("SP0268","getItem",arr,"","");
    }
    else if(part == "DEMAND_DEPT"){
		window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
    }
    else if(part == "CUST_CODE"){
		PopupCommon0("SP0277","getCust","매출처코드","매출처명");
    }
    else if(part == "REC_VENDOR_NAME"){
		window.open("/common/CO_014.jsp?callback=getRecv", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
    }
    else if(part == "PROJECT_NM"){
		PopupCommon4("SP0351","getProject_nm",G_PRE_CODE,G_PRE_CODE,G_PRE_CODE,G_HOUSE_CODE,"프로젝트코드","프로젝트명");
    }
    else if(part == "ATTACH_FILE"){
		var attach_no = GD_GetCellValueIndex(GridObj,G_CUR_ROW, INDEX_ATTACH_NO);
		
		attach_file(attach_no,"PR");
    }
    else if(part == "ADD_USER_ID"){
		window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
    }
    else if(part == "project_pm"){
		window.open("/common/CO_008.jsp?callback=getProject_pm", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
    }
    else if(part == "DELY_TO_ADDRESS_GRID"){
    	window.open("/common/CO_009.jsp?callback=getDemandGrid", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
}

function getProject_nm(code, text ,cust, seq){
	document.form1.pjt_name.value = text;
    document.form1.pjt_code.value = code;
    document.form1.pjt_seq.value = seq;
    
    document.form1.subject.value = "["+text+"] 사전지원";
}
  
function searchCust() {
	url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0120F&function=scms_getCust&values=&values=/&desc=고객사코드&desc=고객사명";
	CodeSearchCommon(url,'','','','','');
}

/* 고객사 조회*/
function scms_getCust(code, text, div) {
	document.form1.scms_cust_type.value = div;
	document.form1.scms_cust_code.value = code;
	document.form1.scms_cust_name.value = text;
}

function getDemand(code, text){
	document.form1.demand_dept_name.value = text;
	document.form1.demand_dept.value = code;
}

function getRecv(code, text){
	var wise = GridObj;
	GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_REC_VENDOR_CODE, code);
    GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_REC_VENDOR_NAME, text);
}

function getItem(code, text, basic_unit){
    var wise = GridObj;
    GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_ITEM_NO,  "<%=G_IMG_ICON%>" + "&"+code+"&"+code, "&");
    GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_DESCRIPTION_LOC, text);
    GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_UNIT_MEASURE, basic_unit);
}

function getCust(code, text){
	document.form1.cust_name.value = text;
    document.form1.cust_code.value = code;
}

function getDely(code, text){
	var wise = GridObj;
    GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_DELY_TO_LOCATION, "<%=G_IMG_ICON%>" + "&"+text+"&"+code, "&");
}

function getAddUser(code, text){
	document.form1.add_user_name.value = text;
    document.form1.add_user_id.value = code;
}

function getDemandGrid(code, text){
	GD_SetCellValueIndex(GridObj, G_CUR_ROW, INDEX_DELY_TO_ADDRESS_CD, code);
	GD_SetCellValueIndex(GridObj, G_CUR_ROW, INDEX_DELY_TO_ADDRESS, text);
}

/*
업체지정 팝업(VENDOR_SELECT)에서 호출한다.
@parameter
szRow           : 넘긴 와이즈테이블 로우
values          : vendor_code@vendor_name@name@#
count           : 선택된 업체수가 넘어온다.
*/
function vendorInsert(szRow, values, count){
	if(szRow == "-1") {
		for(row=0; row<GridObj.GetRowCount(); row++) {
			if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
				GD_SetCellValueIndex(GridObj,row, INDEX_REC_VENDOR_CODE,  "<%=G_IMG_ICON%>" + "&" + count + "&Y", "&");
				GD_SetCellValueIndex(GridObj,row, INDEX_REC_VENDOR_SELECTED, values);
				GD_SetCellValueIndex(GridObj,row, IDX_VENDOR_CNT, count);
			}
		}
	}
	else {
		GD_SetCellValueIndex(GridObj,szRow, INDEX_REC_VENDOR_CODE,  "<%=G_IMG_ICON%>" + "&" + count + "&Y", "&");
        GD_SetCellValueIndex(GridObj,szRow, INDEX_REC_VENDOR_SELECTED, values);
        GD_SetCellValueIndex(GridObj,szRow, IDX_VENDOR_CNT, count);
	}
}

//나의카탈로그
function mycatalog() {
	var f = document.forms[0];

    if(f.sales_type.value == ""){
        alert("구매요청구분을 선택 후 나의카탈로그를 선택 하십시요");
        
        return;
    }

    if(f.sales_type.value == "M"){
        alert("구매요청구분이 판매오더인 경우 나의카탈로그 사용을 하실 수 없습니다.");
        
        return;
    }
    
	setCatalogIndex("ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:MAKER_NAME:MAKER_CODE:ITEM_GROUP");

    url = "/kr/catalog/pr/pr1_pp_lis4.jsp?INDEX=" + getAllCatalogIndex() ;

	windowopen1 = window.open(url,"mycatalog_win","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1024,height=500,left=0,top=0");
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
    var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP1001&function=SP1001_Popup_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=&values=/&desc=프로젝트&desc=프로젝트명";
    CodeSearchCommon(url, 'doc', left, top, width, height);
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
	}
	else if(view_flag==1){
		GridObj.SetColHide("EXCHANGE_RATE", false);
		GridObj.SetColHide("KRW_AMT", false);
	}else{}
}

function GridView(view_flag){
	var id = "SL0018";

	if(view_flag==0){
		setHeader_1();
		var code = "M372";
		document.all.butt_i.style.display="";
		document.all.butt_s.style.display="none";
		document.form1.create_type.options[0].selected = true;
		document.form1.create_type.disabled = false;
		document.form1.hard_maintance_term.disabled = false;
		document.form1.sales_type.disabled=false;
	}
	else if(view_flag==1){
		setHeader_2();
		var code = "M372";
		document.all.butt_i.style.display="none";
		document.all.butt_s.style.display="";
		document.form1.create_type.options[0].selected = true;
		document.form1.create_type.disabled = true;
		document.form1.hard_maintance_term.disabled = true;
		orderChange("P");
		document.form1.sales_type.options[3].selected=true;
		document.form1.sales_type.disabled=true;
	}
    
    summaryCnt = 0;
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

function addDate(year,month,day,week){
	window.self.document.forms[0].add_date.value=year+month+day;
}

function returnhopeDay(year,month,day,week){
	window.self.document.forms[0].return_hope_day.value=year+month+day;
}

function contractDay(year,month,day,week){
	window.self.document.forms[0].contract_hope_day.value=year+month+day;
}

function contractFromDate(year,month,day,week){
	window.self.document.forms[0].contract_from_date.value=year+month+day;
}

function contractToDate(year,month,day,week){
	window.self.document.forms[0].contract_to_date.value=year+month+day;
}

function PrdeleteWiseTable() {
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
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SELECTED,     "true" );
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ITEM_NO,      "" + "&"+"null"+"&"+"null", "&");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_DESCRIPTION_LOC,  "");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_UNIT_MEASURE,     "<%=COMBO_M007%>", "&","#");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_REC_VENDOR_NAME,  "<%=G_IMG_ICON%>" + "&"+"null"+"&"+"null", "&");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ATTACH_NO,    "<%=G_IMG_ICON%>" + "&"+"null"+"&"+"null", "&");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CUR,        "<%=COMBO_M002%>", "&","#", "<%=COMBO_IDX_M002%>");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PR_QTY,     "");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_LOCATION, "");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASER_ID,      "");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASER_NAME,    "");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_DEPT_NAME,"");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_DEPT,  "");

	GridObj.SetCellActivation('ITEM_NO', iMaxRow, 'disable');
	GridObj.SetCellActivation('DESCRIPTION_LOC', iMaxRow, 'edit');
	GridObj.SetCellActivation('UNIT_MEASURE', iMaxRow, 'edit');

	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_NO,         document.form1.wbs_no.value);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_SUB_NO,     document.form1.wbs_sub_no.value);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_TXT,        document.form1.wbs_txt.value);
}

function Line_insert_2() {
	var iMaxRow = GridObj.GetRowCount();
	GridObj.AddRow();
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SELECTED,     "true" );
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_TECHNIQUE_GRADE,  "<%=COMBO_M000%>", "&","#");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_TECHNIQUE_TYPE,   "<%=COMBO_M001%>", "&","#");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ATTACH_NO,    "<%=G_IMG_ICON%>" + "&"+"null"+"&"+"null", "&");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CUR,        "KRW");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_UNIT_MEASURE,   "MM");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_NO,         document.form1.wbs_no.value);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_SUB_NO,     document.form1.wbs_sub_no.value);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_TXT,        document.form1.wbs_txt.value);
}

function sales_com(){
	var f = document.forms[0];
	
    commaPrice(f.expect_amt,'add',0);
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

function setOrderNO(cd_control, nm_control, cl_biz, cd_salecust, nm_salecust, dt_contstart, dt_contend, amt_cont, cd_saledept, no_saleemp, nm_saledept, nm_saleemp){
	document.forms[0].order_no.value       = cd_control;
	document.forms[0].order_name.value     = nm_control;
	document.forms[0].cl_biz.value       = cl_biz;
	document.forms[0].cust_code.value      = cd_salecust;
	document.forms[0].cust_name.value      = nm_salecust;
	document.forms[0].sales_user_name.value  = nm_saleemp ;
}

function orderChange(cd){
	GridObj.RemoveAllData();

	document.form1.bsart.value = "";

	if(cd == "M"){
		document.form1.cust_code.value = "";
		document.form1.cust_name.value = "";
		document.form1.order_no.value = "";
		document.form1.sales_amt.value = "";
		document.form1.wbs_no.value = "";
		document.form1.wbs_sub_no.value = "";
		document.form1.wbs_txt.value = "";

		document.form1.subject.value = "";
		document.getElementById("t_cls01").className = "c_title_1";
		document.all["t_cls01"].innerHTML = "Sales Order";
		document.all["_div01"].style.display="block";
		document.all["_div02"].style.display="none";
		document.form1.bsart.disabled = true;
	}
	else if(cd == "P"){
		document.form1.cust_code.value = "0000100000";
		document.form1.cust_name.value = "기타(계획용)";
		document.form1.order_no.value = "";
		document.form1.sales_amt.value = "";

		document.form1.wbs_no.value = "";
		document.form1.wbs_sub_no.value = "";
		document.form1.wbs_txt.value = "";

		document.form1.subject.value = "";
		document.getElementById("t_cls01").className = "c_title_1";
		document.all["t_cls01"].innerHTML = "WBS요소";
		document.all["_div01"].style.display="none";
		document.all["_div02"].style.display="block";
		document.form1.bsart.disabled = false;
	}
	else{
		document.form1.cust_code.value = "0000100000";
		document.form1.cust_name.value = "기타(계획용)";
		document.form1.order_no.value = "";
		document.form1.sales_amt.value = "";

		document.form1.wbs_no.value = "";
		document.form1.wbs_sub_no.value = "";
		document.form1.wbs_txt.value = "";

		document.form1.subject.value = "";
		
		if(cd == "A"){
			document.form1.bsart.value = "Z02";
		}
		
		document.getElementById("t_cls01").className = "c_data_1_p";
		document.all["t_cls01"].innerHTML = "&nbsp;";
		document.all["_div01"].style.display="none";
		document.all["_div02"].style.display="none";
		document.form1.bsart.disabled = true;
	}
}

function orderChange2(cd){
    document.form1.sales_type.value = cd;

    if(cd == "M"){
        document.getElementById("t_cls01").className = "c_title_1";
        document.all["t_cls01"].innerHTML = "Sales Order";
        document.all["_div01"].style.display="block";
        document.all["_div02"].style.display="none";
    }
    else if(cd == "P"){
        document.getElementById("t_cls01").className = "c_title_1";
        document.all["t_cls01"].innerHTML = "WBS요소";
        document.all["_div01"].style.display="none";
        document.all["_div02"].style.display="block";
    }
    else{
        document.getElementById("t_cls01").className = "c_data_1_p";
        document.all["t_cls01"].innerHTML = "&nbsp;";
        document.all["_div01"].style.display="none";
        document.all["_div02"].style.display="none";
    }
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

	setCatalogIndex("VBELN:KUNNR:NAME1:WAERK:VBELP:MATNR:ARKTX:KWMENG:VRKME:LGORT:PSTYV:PS_PSP_PNR:CONV_PSPNR:POST1");
	
	url = "/kr/dt/pr/es_bd_lis2.jsp?INDEX=" + getAllCatalogIndex() ;
	
	var getOrderNoWin = window.open( url, 'getOrderNoWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function getWbs_pop() {
	var url = "/kr/dt/pr/pr1_wbs_pop_main.jsp";
	
	Code_Search(url,'','','','','');
}

function setWbs(){
	var f = document.forms[0];

	for(var i=0;i<GridObj.GetRowCount();i++){
		GD_SetCellValueIndex(GridObj,i, INDEX_WBS_NO,     f.wbs_no.value);
		GD_SetCellValueIndex(GridObj,i, INDEX_WBS_SUB_NO,     f.wbs_sub_no.value);
		GD_SetCellValueIndex(GridObj,i, INDEX_WBS_TXT,    f.wbs_txt.value);
	}
}

function getItemValue(){
	var iRowCount = GridObj.GetRowCount();
	var indexItem = "";
	var itemArr = "";

	for(var i=0; i<iRowCount; i++){
		if( GD_GetCellValueIndex(GridObj,i, INDEX_SELECTED) == "true"){
			indexItem += GD_GetCellValueIndex(GridObj,i, INDEX_ITEM_GROUP) + ":"      //범주
		}
	}

	indexItem = indexItem.substr(0,indexItem.length-1).split(":");

	if(indexItem.length > 1){
		for(var k=0; k<indexItem.length; k++){
			if(itemArr != ""){
				itemArr = indexItem[k];
			}

			if(indexItem[k] != itemArr){
				itemArr = "Z06";
			}
		}
	}
	else{
		itemArr = indexItem;
	}
	
	setBsart(itemArr);
}

function setBsart(cd){
	if(document.form1.sales_type.value == "A"){
		document.form1.bsart.value = "Z02";
		
		return;
	}

	if(cd == "Z101" || cd == "Z201" || cd == "Z301"){
		document.form1.bsart.value = "Z01"; //상품구매요청
	}
	else if(cd == "Z105" || cd == "Z106" || cd == "Z206" || cd == "Z305" || cd == "Z306" || cd == "Z309"){
		document.form1.bsart.value = "Z05"; //유지보수 구매요청
	}
	else if(cd == "Z103" || cd == "Z203" || cd == "Z303" || cd == "Z403"){
		document.form1.bsart.value = "Z04"; //외주용역 구매요청
	}
	else{
		document.form1.bsart.value = "Z06"; //도급계약 요청
	}
}

function getCustomerList_pop() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var itemArr = "";
	var prArr = "";

	setCatalogIndex("VBELN:KUNNR:WAERK:NAME1:VBELP:MATNR:ARKTX:KWMENG:VRKME:LGORT:PSTYV:PS_PSP_PNR:CONV_PSPNR:POST1");
	
	url = "/kr/dt/pr/custom_pp_lis1.jsp?INDEX=" + getAllCatalogIndex() ;
	var getCustomerListWin = window.open( url, 'getCustomerListWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function setCustomerList(vendor_code, vendor_name){
	document.forms[0].cust_code.value = vendor_code;
	document.forms[0].cust_name.value = vendor_name;
}

function selectCode( maker_code, maker_name) {
	GridObj.SetCellValue("MAKER_CODE",G_CUR_ROW, maker_code);
	GridObj.SetCellValue("MAKER_NAME",G_CUR_ROW, maker_name);
	GridObj.SetCellHiddenValue("MAKER_NAME",G_CUR_ROW, maker_name);
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
	
	CodeSearchCommon(url, 'doc', left, top, width, height);
}

//2010.12.08 swlee add
function getProject_pm(code, text){
	document.forms[0].project_pm_name.value = text;
	document.forms[0].project_pm.value = code;
}

function setDocType(strType){
	if(strType == "B"){
		document.forms[0].doc_type.value = "BR";
	}
	else if(strType == "P"){
		document.forms[0].doc_type.value = "PR";
	}
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

function fnMa014Pop(){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	
	window.open("","windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
	
	var form = fnGetDynamicForm("/kr/bom/ma_014.jsp", inputParam, "windowopen1");
	
	body.appendChild(form);
	
	form.submit();
	
	body.removeChild(form);
}
</Script>

<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
    	
	GridObj_1_setGridDraw();
	GridObj_1.setSizes();
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
    	var prQtyIndex     = GridObj.getColIndexById("PR_QTY");
    	var unitPriceIndex = GridObj.getColIndexById("UNIT_PRICE");
    	var rowIndex       = GridObj.getRowIndex(GridObj.getSelectedId());
        
        if((cellInd == prQtyIndex) || (cellInd == unitPriceIndex)){
    		calculate_pr_amt(GridObj, rowIndex);
    	}
    	
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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}

<!--=========================================== Grid2 Default Script ===========================================-->
//그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
//이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function GridObj_1_doOnRowSelected(rowId,cellInd){}

//그리드 셀 ChangeEvent 시점에 호출 됩니다.
//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function GridObj_1_doOnCellChange(stage,rowId,cellInd){
	var max_value = GridObj_1.cells(rowId, cellInd).getValue();
	
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

//서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
//서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function GridObj_1_doSaveEnd(obj){
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

//엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
//복사한 데이터가 그리드에 Load 됩니다.
//!!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function GridObj_1_doExcelUpload() {
	var bufferData = window.clipboardData.getData("Text");
	
	if(bufferData.length > 0) {
		GridObj.clearAll();
		GridObj.setCSVDelimiter("\t");
		GridObj.loadCSVString(bufferData);
	}
	
	return;
}

function GridObj_1_doQueryEnd() {
	var msg        = GridObj.getUserData("", "message");
	var status     = GridObj.getUserData("", "status");

	// Wise그리드에서는 오류발생시 status에 0을 세팅한다.
	if(status == "0"){
		alert(msg);
	}
	
	if("undefined" != typeof JavaCall) {
		JavaCall("doQuery");
	}
	
	return true;
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
<!--내용시작-->
<form id="form1" name="form1" action="">
	<input type="hidden" name="sign_status" id="sign_status" value="N"> <!-- 저장,결재를 구분하는 플래그 -->
	<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD--%>
	<input type="hidden" id="house_code" 		name="house_code" 			value="<%=info.getSession("HOUSE_CODE")%>">
	<input type="hidden" id="company_code" 		name="company_code" 		value="<%=info.getSession("COMPANY_CODE")%>">
	<input type="hidden" id="dept_code" 		name="dept_code" 			value="<%=info.getSession("DEPARTMENT")%>">
	<input type="hidden" id="req_user_id" 		name="req_user_id" 			value="<%=info.getSession("ID")%>">
	<input type="hidden" id="doc_type" 			name="doc_type" 			value="BR">
	<input type="hidden" id="fnc_name" 			name="fnc_name" 			value="getApproval">
	<input type="hidden" id="pr_tot_amt"		name="pr_tot_amt"			value="">
	<input type="hidden" id="attach_no" 		name="attach_no" 			value="">
	<input type="hidden" id="attach_gubun" 		name="attach_gubun" 		value="body">
	<input type="hidden" id="dely_to_location" 	name="dely_to_location" 	value="S100">
	<input type="hidden" id="plan_code" 		name="plan_code" 			value="1000">
	<input type="hidden" id="pr_gubun" 			name="pr_gubun" 			value="B">
	                                                                           
	<input type="hidden" id="att_mode"   		name="att_mode"   			value="">
	<input type="hidden" id="view_type"  		name="view_type"  			value="">
	<input type="hidden" id="file_type"  		name="file_type"  			value="">
	<input type="hidden" id="tmp_att_no" 		name="tmp_att_no" 			value="">
	<input type="hidden" id="attach_count" 		name="attach_count" 		value="">
	<input type="hidden" id="approval_str" 		name="approval_str" 		value="">
	<input type="hidden" id="ctrl_code" 		name="ctrl_code" 		    value="">
	<input type="hidden" name="cl_biz" value="">

	<%@ include file="/include/sepoa_milestone.jsp"%>	

	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
   		<tr>
     		<td align="left" class="cell_title1">&nbsp;◆ 관리정보</td>
   		</tr>
 	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr style="display:none;">
         							<td width="15%" class="se_cell_title">문서유형</td>
       								<td class="se_cell_data" colspan="3">
           								<select id="bsart" name="bsart" class="inputsubmit" style="width:120px" >
           									<option value="">-----</option>
           									<%=LB_BSART%>
           								</select>
           								<input type="hidden" id="cust_code" name="cust_code" size="10" class="input_data2" value="0000100000">
           								<input type="hidden" id="cust_name" name="cust_name" size="20" class="input_data2" value="기타(계획용)" readonly style="border:0">
       								</td>
       							</tr>
       							<tr style="display:none;">
									<td width="15%" class="se_cell_title">구매요청구분</td>
									<td class="se_cell_data" >
										<select id="sales_type" name="sales_type" class="inputsubmit"  style="width:90px" onchange="orderChange(this.value)">
											<option value="">-----</option>
											<%=LB_S_SALES_TYPE %>
										</select>
									</td>
									<td id="t_cls01" class="se_cell_data"></td>
									<td id="t_cls02" class="se_cell_data">
										<div id="_div01" style="display:none;">
											<a href="javascript:getOrder_pop();">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
										</div>
										<div id="_div02" style="display:none;">
											<input type="hidden" id="wbs_txt" name="wbs_txt">
											<input type="text"   id="wbs_no"  name="wbs_no" size="15" maxlength="10" class="inputsubmit" value="" readonly>
											<a href="javascript:getWbs_pop();">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<input type="text" id="wbs_sub_no" name="wbs_sub_no" size="20" class="input_data2" maxlength="15" style="border:0">
										</div>
									</td>
								</tr>
								<tr style="display: none;">
									<td width="15%" class="se_cell_title">프로젝트</td>
									<td class="se_cell_data" colspan="3">
										<input type="text" id="pjt_code" name="pjt_code" size="50" style="width:20%" class="input_re" value='' readOnly>
										<a href="javascript:PopupManager('PROJECT_NM');">
											<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
										</a>
										<input type="text"   id="pjt_name" name="pjt_name" size="70" class="input_data2" value='' style="border:0" readOnly>
										<input type="hidden" id="pjt_seq"  name="pjt_seq" /> <br/>
										<font color="blue">※ 사전지원 요청을 위해서는 사업관리시스템에서 프로젝트를 우선 등록해야 합니다.</font>
									</td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청부서</td>
									<td width="35%" class="data_td">
										<input type="text" id="demand_dept" name="demand_dept" size="10" value='<%=info.getSession("DEPARTMENT")%>' readOnly>
										<a href="javascript:PopupManager('DEMAND_DEPT');">
											<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
										</a>
										<input type="text" id="demand_dept_name" name="demand_dept_name" size="20" maxlength="15" value='<%=info.getSession("DEPARTMENT_NAME_LOC")%>' style="border:0">
									</td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청자</td>
									<td width="35%" class="data_td" >
										<input type="text" id="add_user_id" name="add_user_id" size="13" value='<%=info.getSession("ID")%>' readOnly>
										<a href="javascript:PopupManager('ADD_USER_ID')">
											<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
										</a>
										<input type="text" id="add_user_name" name="add_user_name" size="20" value='<%=info.getSession("NAME_LOC")%>'>
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
    		<td height="3"></td>
 		</tr>
 		<tr>
   			<td align="left" class="cell_title1">&nbsp;◆ 등록정보</td>
 		</tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr style="display:none;">
									<td width="15%" class="se_cell_title">하자보증기간</td>
									<td class="se_cell_data" > H/W
										<select id="hard_maintance_term" name="hard_maintance_term" class="inputsubmit" >
											<option value="" selected><b>-----</b></option>
											<%=LB_MAINTANCE_TERM%>
										</select>
										&nbsp;&nbsp;&nbsp;S/W
										<select id="soft_maintance_term" name="soft_maintance_term" class="inputsubmit" >
											<option value="" selected><b>-----</b></option>
											<%=LB_MAINTANCE_TERM%>
           								</select>
       								</td>
       								<td width="15%" class="se_cell_title">회신희망일</td>
       								<td class="se_cell_data" >
         								<input type="text" id="return_hope_day" name="return_hope_day" size="8" class="inputsubmit" value="<%=RETURN_HOPE_DAY%>" readonly> 
<!--          								<a href="javascript:Calendar_Open('returnhopeDay');"><img src="../../images/button/butt_calender.gif" align="absmiddle" border="0"></a> -->
       								</td>
       							</tr>
       							<tr style="display: none;">
	  								<td width="15%" class="se_cell_title">매출계약예상일</td>
         							<td class="se_cell_data" colspan="3">
         								<s:calendar id="contract_hope_day" default_value="" format="%Y/%m/%d"/>
        							</td>
      							</tr>
       							<tr style="display:none">
	  								<td width="15%" class="se_cell_title">매출액</td>
         							<td class="se_cell_data" >
           								<input type="text" id="sales_amt" name="sales_amt" size="20" class="inputsubmit" maxlength="15" readonly  value="" onKeyPress="return onlyNumber(event.keyCode);">
         							</td>
         							<td width="15%" class="se_cell_title">프로젝트 책임자</td>
         							<td class="se_cell_data" >
         								<input type="text" id="project_pm" name="project_pm" size="13"  class="input_data" value='' readonly>
         								<a href="javascript:PopupManager('project_pm');">
         									<img src="<%=G_IMG_ICON%>" border="0" >
         								</a>
         								<input type="text" name="project_pm_name" size="20" class="input_data2" maxlength="15" value='' readonly>
        							</td>
       							</tr>
       							<tr style="display:none">
	  								<td width="15%" class="se_cell_title">수주번호</td>
         							<td class="se_cell_data" >
           								<input type="text" id="order_no" name="order_no" size="20" class="inputsubmit" maxlength="12" readonly  value="" onKeyPress="return onlyNumber(event.keyCode);">
         							</td>
         							<td width="15%" class="se_cell_title">수주차수</td>
         							<td class="se_cell_data" >
           								<input type="text" id="order_count" name="order_count" size="8" class="inputsubmit" maxlength="2" readonly  value="" onKeyPress="return onlyNumber(event.keyCode);">
         							</td>
       							</tr>
       							<tr style="display:none">
	  								<td width="15%" class="se_cell_title">프로젝트 수행기간</td>
         							<td class="se_cell_data" colspan="3">
         								<s:calendar id="contract_from_date" default_value="" format="%Y/%m/%d"/>
           								~
           								<s:calendar id="contract_to_date" default_value="" format="%Y/%m/%d"/>
         							</td>
        						</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청명</td>
									<td class="data_td" colspan="3">
										<input type="text" id="subject" name="subject" style="width:57%" class="input_re" onKeyUp="return chkMaxByte(500, this, '요청명');">
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr style="display: none;">
									<td width="15%" class="se_cell_title" style="display: none;">고객사</td>
									<td class="se_cell_data" width="35%" style="display: none;"> 
										<select id="pr_type" name="pr_type" class="input_re" onChange='GridView(form1.pr_type.options.selectedIndex)'  disabled style="display:none;">
											<%=LB_PR_TYPE%>
										</select>
										<input type="text" name="scms_cust_code" size="10"  class="inputsubmit" value='' readonly>
										<a href="javascript:searchCust();">
											<img src="<%=G_IMG_ICON%>" border="0" >
										</a>
										<input type="text"   id="scms_cust_name" name="scms_cust_name" size="20" class="input_data2" value='' style="border:0" readonly>
										<input type="hidden" id="scms_cust_type" name="scms_cust_type" size="30" class="input_data2" value='' style="border:0" readonly>
									</td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청구분</td>
									<td class="data_td" colspan="3">
										<select id="create_type" name="create_type" class="input_re" >
											<%=LB_CREATE_TYPE%>
           								</select>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청일자</td>
									<td width="35%" class="data_td">
										<s:calendar id="add_date" default_value="<%=SepoaString.getDateSlashFormat(CURRENT_DATE)%>" format="%Y/%m/%d" cssClass=" "/>
									</td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예상금액(자동계산)</td>
									<td width="35%" class="data_td">
										<input type="text" id="expect_amt" name="expect_amt" style="width:93%" readonly>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;특기사항</td>
									<td  class="data_td" colspan="3" style="height: 200px;">
										<textarea id="REMARK" name="REMARK" class="inputsubmit" cols="85" rows="10" onKeyUp="return chkMaxByte(4000, this, '특기사항');" style="width: 98%; height: 195px;"></textarea>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
									<td  class="data_td" colspan="3">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="15%">
<script language="javascript">
function setAttach(attach_key, arrAttrach, rowId, attach_count) {
	document.getElementById("attach_no").value            = attach_key;
	document.getElementById("sign_attach_no_count").value = attach_count;
}

btn("javascript:attach_file(document.getElementById('attach_no').value, 'TEMP');", "파일등록");
</script>
												</td>
												<td>
													<input type="text" size="3" readOnly value="0" name="sign_attach_no_count" id="sign_attach_no_count"/>
													<input type="hidden" value="" name="attach_no" id="attach_no">
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
        	<td height="30" align="right" id="butt_i" style="display:none;">
            	<TABLE cellpadding="0">
                	<TR>
                		<TD><script language="javascript">btn("javascript:fnMa014Pop()","BOM요청")    </script></TD>
                    	<TD><script language="javascript">btn("javascript:PopupManager('CATALOG')","품목카탈로그")    </script></TD>
                    	<TD><script language="javascript">btn("javascript:mycatalog()","나의 카탈로그")   </script></TD>
                    	<TD><script language="javascript">btn("javascript:PrdeleteWiseTable()","삭 제")</script></TD>
                    	<TD><script language="javascript">btn("javascript:Approval(G_SAVE_STATUS)","임시저장")</script></TD>
                    	<TD><script language="javascript">btn("javascript:Approval('E')","요청")</script></TD> <!-- 바로 결재를 태우지 말고 결재완료--> 
                    	<%--<TD><script language="javascript">btn("javascript:Approval('P')","결재요청")</script></TD>--%>
                  	</TR>
                </TABLE>
			</td>
            <td height="30" align="right" id="butt_s" style="display:block;">
            	<TABLE cellpadding="0">
                	<TR>
                    	<TD><script language="javascript">btn("javascript:Line_insert_2()","행삽입")</script></TD>
                    	<TD><script language="javascript">btn("javascript:PrdeleteWiseTable()","삭 제")</script></TD>
                    	<TD><script language="javascript">btn("javascript:Approval(G_SAVE_STATUS)","저 장")</script></TD>
                    	<TD><script language="javascript">btn("javascript:Approval('P')","결재요청")</script></TD>
                  	</TR>
				</TABLE>
			</td>
		</tr>
	</table>
</form>
</s:header>
<s:grid screen_id="BR_001_1" grid_obj="GridObj" grid_box="gridbox"/>
<div id="gridbox_1" name="gridbox_1" width="100%" style="background-color:white; display: none;"></div>
<s:footer/>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</body>
</html>