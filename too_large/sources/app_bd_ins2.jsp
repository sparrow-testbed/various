<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AR_001_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AR_001_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
%>
<%--
	기안 생성
	삭제 후 삭제한 PR_NO가 다른 로우에 있어야만 삭제가 가능하다. 기안 하려고한 PR_NO가 다 남아있어야하기 때문에.
	추가는 하나의 PR_NO를 가지고 쪼개는 개념이다.
	저장시 하나의 PR_NO의 요청금액끼리, 공급가액끼리 맞아야 한다.
	삭제된 PR_NO PR_SEQ는 CNDT에 CNDT.STATUS='D'로 인서트되고 승인시에 PRDT.PR_PROCEEDING_FLAG = 'R', PRDT.STATUS = 'D' 로 업데이트 된다.
	추가된 로우는 MAX(PRDT.PR_SEQ) 의 형태로 PRDT에 인서트되고, 영업관리쪽의 PR데이터도 같이 맞춰준다.
	추가,삭제없이 요청금액, 공급가액만 변동시에도 위와같은 로직으로 태운다.
--%>

<script language='javascript' for='WiseGrid'
	event='ChangeCell(strColumnKey,nRow,vtOldValue,vtNewValue)'>
	GD_ChangeCell(GridObj,strColumnKey,nRow,vtOldValue,vtNewValue);
</script>
<script language='javascript' for='WiseGrid'
	event='ChangeCombo(strColumnKey, nRow, vtOldIndex, vtNewIndex)'>
	GD_ChangeCombo(GridObj,strColumnKey, nRow, vtOldIndex, vtNewIndex);
</script>
<script language='javascript' for='WiseGrid'
	event='CellClick(strColumnKey, nRow)'>
	GD_CellClick(GridObj,strColumnKey, nRow);
</script>
<script language='javascript' for='WiseGrid'
	event='HDClick(strColumnKey)'>
	GD_HDClick(GridObj,strColumnKey);
</script>

<% String WISEHUB_PROCESS_ID="AR_001_1";%>
<%
	String house_code = info.getSession("HOUSE_CODE");
	String COMPANY_CODE = info.getSession("COMPANY_CODE");
	String user_id = info.getSession("ID");
	String DEPARTMENT = info.getSession("DEPARTMENT");
	/* String CTRL_CODE	= JSPUtil.nullToEmpty(request.getParameter("ctrl_code")); */
	String CTRL_CODE = "";
	if (info.getSession("CTRL_CODE").equals("&")) {
		CTRL_CODE = "";
	} else {
		CTRL_CODE = info.getSession("CTRL_CODE").split("&")[0];
	}
	String user_name = info.getSession("NAME_LOC");
	String PR_NO = JSPUtil.nullToEmpty(request.getParameter("pr_no"));
	String REMARK = JSPUtil.nullToEmpty(request.getParameter("remark"));
	String ATTACH_NO = JSPUtil.nullToEmpty(request.getParameter("attach_no"));
	String PR_TOT_AMT = JSPUtil.nullToEmpty(request.getParameter("pr_tot_amt"));
	String SUBJECT = JSPUtil.nullToEmpty(request.getParameter("subject"));
	String PR_TYPE = JSPUtil.nullToEmpty(request.getParameter("pr_type"));
	String CREATE_TYPE = "PR";//JSPUtil.nullToEmpty(request.getParameter("create_type"));
	
  	String rtnValue = "";
  	StringTokenizer st = null;
  	if(request.getParameter("pr_seq") != null){
  		st = new StringTokenizer(request.getParameter("pr_seq"),"&");
  		String addComma = "','";
  		int tokenCount = st.countTokens();
  		for(int i = 0 ; i < tokenCount ; i++){
  			if(i == tokenCount-1)
  				addComma = "";
  				rtnValue += st.nextToken()+addComma;
  		}
  	}
	
	String pr_seq = rtnValue;
	
	String pre_cont_seq = JSPUtil.nullToEmpty(request.getParameter("pre_cont_seq"));
	String pre_cont_count = JSPUtil.nullToEmpty(request.getParameter("pre_cont_count"));

	String pr_data = JSPUtil.nullToEmpty(request.getParameter("pr_data"));
	String exec_no = JSPUtil.nullToEmpty(request.getParameter("exec_no"));
	String editable = JSPUtil.nullToEmpty(request.getParameter("editable"));
	String screenMode = JSPUtil.nullToEmpty(request.getParameter("screenMode"));

	if ("".equals(screenMode)) {
		screenMode = "".equals(exec_no) ? "C" : "N".equals(editable) ? "R" : "U";
	}
	
	
	String REQ_TYPE = JSPUtil.nullToEmpty(request.getParameter("req_type"));

	//LISTBOX
	String LB_PO_TYPE = ListBox(request, "SL0018", house_code + "#M204" + "#", "");
	String LB_EXEC_FLAG = ListBox(request, "SL0018", house_code + "#M035", "");

	String DELY_TERMS = ListBox(request, "SL0018", house_code + "#M009", "");

	String buyer_code = CommonUtil.getConfig("sepoa.company.code");

	String gridEdit = "true";
	if ("R".equals(screenMode))
		gridEdit = "false";

	// 2011.07.28 HMCHOI 작성
	// 발주서 생성 및 수정시 전자계약서 작성 사용여부
	// wise.properties의 wise.po.contract.use.#HOUSE_CODE# = true/false 에 따라 옵션으로 진행한다.
	boolean po_contract_use_flag = false;
	try {
		po_contract_use_flag = Boolean.parseBoolean(CommonUtil.getConfig("wise.po.contract.use." + info.getSession("HOUSE_CODE"))); //발주 전자계약 사용여부
	} catch (Exception e) {
		po_contract_use_flag = false;
	}
%>

<%
	/**
	 * 전자결재 사용여부
	 */
	Config signConf = new Configuration();
	String sign_use_module = "";// 전자결재 사용모듈
	boolean sign_use_yn = false;
	try {
		sign_use_module = CommonUtil.getConfig("wise.sign.use.module." + info.getSession("HOUSE_CODE")); //전자결재 사용모듈
	} catch (Exception e) {
		
		out.println("에러 발생:" + e.getMessage() + "<br>");
		sign_use_module = "";
	}
	st = new StringTokenizer(sign_use_module, ";");
	while (st.hasMoreTokens()) {
		String signFlag = REQ_TYPE.equals("B") ? "BREX" : "EX";
		if (signFlag.equals(st.nextToken())) {
			sign_use_yn = true;
		}
	}
%>

<html>
<head>
<title>
<%--
<%if("B".equals(REQ_TYPE)) {%>
 <%=("C".equals(screenMode)) ? "사전지원 완료" : (("R".equals(screenMode)) ? "사전지원 상세" : (("U".equals(screenMode)) ? "사전지원 수정" : (("E".equals(screenMode)) ? "변경기안생성" : "")))%>
<%}else{ %>
 <%=("C".equals(screenMode)) ? "기안생성" : (("R".equals(screenMode)) ? "기안상세" : (("U".equals(screenMode)) ? "기안수정" : (("E".equals(screenMode)) ? "변경기안생성" : "")))%>
<%} %>		
--%>	
<%=text.get("MESSAGE.MSG_9999")%>
</title> <%-- 우리은행 전자구매시스템 --%>		
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>

<%@ include file="/include/sepoa_grid_common.jsp"%>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="AR_001_2"/>  
 			<jsp:param name="grid_obj" value="GridObj2"/>
 			<jsp:param name="grid_box" value="gridbox_1"/>
 			<jsp:param name="grid_cnt" value="2"/>
</jsp:include>

<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>
<Script language="javascript" type="text/javascript">
//<!--

	<%if ("R".equals(screenMode)) {%>
		G_COL1_OPT = "255|255|255";
		G_COL1_ESS = "255|255|255";
	<%}%>

var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_bd_ins1";
var pr_type = "<%=PR_TYPE%>";

var INDEX_SELECTED			;
var INDEX_PR_NO			    ;
var INDEX_PR_SEQ		    ;
var INDEX_SUBJECT			;
var INDEX_ADD_USER_ID		;
var INDEX_PO_VENDOR_CODE	;
var INDEX_VENDOR_NAME		;
var INDEX_ITEM_NO			;
var INDEX_DESCRIPTION_LOC	;
var INDEX_QTY				;
var INDEX_UNIT_MEASURE		;
var INDEX_UNIT_PRICE		;
var INDEX_ITEM_AMT			;
var INDEX_CUSTOMER_PRICE	;
var INDEX_S_ITEM_AMT		;
var INDEX_DISCOUNT			;
var INDEX_SALE_PER_2		;
var INDEX_PR_UNIT_PRICE	    ;
var INDEX_PR_AMT			;
var INDEX_RD_DATE			;
var INDEX_PAY_TERMS		    ;
var INDEX_CONTRACT_FLAG	    ;
var INDEX_INSURANCE		    ;
var INDEX_VALID_FROM_DATE	;
var INDEX_VALID_TO_DATE		;
var INDEX_ENT_FROM_DATE	;
var INDEX_ENT_TO_DATE		;
var INDEX_PAY_TERMS_HD_DESC	;
var INDEX_SALE_AMT			;
var INDEX_ITEM_VAT_AMT		;
var INDEX_SPECIFICATION		;
var INDEX_MAKER_NAME		;
var INDEX_MAKER_CODE		;
var INDEX_ORIGIN_PR_SEQ		;
var INDEX_SOURCING_NO		;
var INDEX_RFQ_NO			;
var INDEX_RFQ_COUNT			;
var INDEX_RFQ_SEQ			;
var INDEX_QTA_NO			;
var INDEX_QTA_SEQ			;
var INDEX_CLASS_GRADE		;
var INDEX_CLASS_SCORE		;
var INDEX_PLANT_CODE		;
var INDEX_ROLE_CODE			;

var INDEX_HUMAN_NAME_LOC	;
var INDEX_CONTRACT_DIV		;
var INDEX_ITEM_GBN			;

function init()
{
	setGridDraw();
	//GD_setProperty(GridObj);
	setHeader1();
	

	GridObj2_setGridDraw();
	GridObj2.setSizes();
}
function setHeader1()
{

	GridObj.bHDMoving 	= false;
	GridObj.bHDSwapping 	= false;
	GridObj.nHDLineSize   = 40;

// 	GridObj.AddGroup("PR_INFO","예산"	);
// 	GridObj.AddGroup("S_INFO"	,"소비자가"	);
//   	//GridObj.AddGroup("INFO"	,"공급가"	);
// 	GridObj.AddGroup("INFO"	,"계약금액"	);

// 	GridObj.AppendHeader("PR_INFO","PR_UNIT_PRICE");
// 	GridObj.AppendHeader("PR_INFO","PR_AMT");
// 	GridObj.AppendHeader("S_INFO","CUSTOMER_PRICE");
// 	GridObj.AppendHeader("S_INFO","S_ITEM_AMT");
// 	GridObj.AppendHeader("INFO","UNIT_PRICE");
// 	GridObj.AppendHeader("INFO","ITEM_AMT");

// 	//GridObj.SetColCellBgColor("CUSTOMER_PRICE"	,G_COL1_OPT);

// 	GridObj.SetNumberFormat("UNIT_PRICE"		,G_format_unit);
// 	GridObj.SetNumberFormat("ITEM_AMT"		,G_format_amt);
// 	GridObj.SetNumberFormat("CUSTOMER_PRICE"	,G_format_unit);
// 	GridObj.SetNumberFormat("S_ITEM_AMT"		,G_format_amt);
// 	GridObj.SetNumberFormat("PR_UNIT_PRICE"	,G_format_unit);
// 	GridObj.SetNumberFormat("PR_AMT"			,G_format_amt);
// 	GridObj.SetNumberFormat("SALE_AMT"		,G_format_amt);
// 	GridObj.SetNumberFormat("ITEM_VAT_AMT"	,G_format_amt);
// 	GridObj.SetNumberFormat("DISCOUNT"   ,G_format_pctg);
// 	GridObj.SetNumberFormat("SALE_PER_2"   ,G_format_pctg);
// 	GridObj.SetNumberFormat("QTY"	         ,G_format_qty);
// 	GridObj.SetDateFormat("VALID_FROM_DATE","yyyy/MM/dd");
// 	GridObj.SetDateFormat("VALID_TO_DATE"	 ,"yyyy/MM/dd");
// 	GridObj.SetDateFormat("RD_DATE"	     ,"yyyy/MM/dd");

// 	GridObj.SetNumberFormat("MAINTENANCE_RATE"	,G_format_pctg);
// 	GridObj.SetDateFormat("ENT_FROM_DATE"			,"yyyy/MM/dd");
// 	GridObj.SetDateFormat("ENT_TO_DATE"			,"yyyy/MM/dd");

	
	INDEX_SELECTED			= GridObj.GetColHDIndex("SELECTED"		);
	INDEX_PR_NO			    = GridObj.GetColHDIndex("PR_NO"			);
	INDEX_PR_SEQ			= GridObj.GetColHDIndex("PR_SEQ"			);
	INDEX_SUBJECT			= GridObj.GetColHDIndex("SUBJECT"			);
	INDEX_ADD_USER_ID		= GridObj.GetColHDIndex("ADD_USER_ID"		);
	INDEX_PO_VENDOR_CODE	= GridObj.GetColHDIndex("PO_VENDOR_CODE"	);
	INDEX_VENDOR_NAME		= GridObj.GetColHDIndex("VENDOR_NAME"		);
	INDEX_ITEM_NO			= GridObj.GetColHDIndex("ITEM_NO"			);
	INDEX_DESCRIPTION_LOC	= GridObj.GetColHDIndex("DESCRIPTION_LOC"	);
	INDEX_QTY				= GridObj.GetColHDIndex("QTY"				);
	INDEX_UNIT_MEASURE		= GridObj.GetColHDIndex("UNIT_MEASURE"	);
	INDEX_UNIT_PRICE		= GridObj.GetColHDIndex("UNIT_PRICE"		);
	INDEX_ITEM_AMT			= GridObj.GetColHDIndex("ITEM_AMT"		);
	INDEX_CUSTOMER_PRICE	= GridObj.GetColHDIndex("CUSTOMER_PRICE"	);
	INDEX_S_ITEM_AMT		= GridObj.GetColHDIndex("S_ITEM_AMT"		);
	INDEX_DISCOUNT			= GridObj.GetColHDIndex("DISCOUNT"		);
	INDEX_SALE_PER_2		= GridObj.GetColHDIndex("SALE_PER_2"		);
	INDEX_PR_UNIT_PRICE	    = GridObj.GetColHDIndex("PR_UNIT_PRICE"	);
	INDEX_PR_AMT			= GridObj.GetColHDIndex("PR_AMT"			);
	INDEX_RD_DATE			= GridObj.GetColHDIndex("RD_DATE"	        );
	INDEX_PAY_TERMS		    = GridObj.GetColHDIndex("PAY_TERMS"		);
	INDEX_PAY_TERMS_HD	    = GridObj.GetColHDIndex("PAY_TERMS_HD"	);
	INDEX_PAY_TERMS_HD_DESC = GridObj.GetColHDIndex("PAY_TERMS_HD_DESC");
	INDEX_CONTRACT_FLAG	    = GridObj.GetColHDIndex("CONTRACT_FLAG"	);
	INDEX_INSURANCE		    = GridObj.GetColHDIndex("INSURANCE"		);
	INDEX_VALID_FROM_DATE	= GridObj.GetColHDIndex("VALID_FROM_DATE"	);
	INDEX_VALID_TO_DATE		= GridObj.GetColHDIndex("VALID_TO_DATE"	);
	INDEX_SALE_AMT			= GridObj.GetColHDIndex("SALE_AMT"		);
	INDEX_ITEM_VAT_AMT		= GridObj.GetColHDIndex("ITEM_VAT_AMT"	);
	INDEX_CUR				= GridObj.GetColHDIndex("CUR"				);
	INDEX_SPECIFICATION		= GridObj.GetColHDIndex("SPECIFICATION"	);
	INDEX_MAKER_NAME		= GridObj.GetColHDIndex("MAKER_NAME"		);
	INDEX_MAKER_CODE		= GridObj.GetColHDIndex("MAKER_CODE"		);
	INDEX_ORIGIN_PR_SEQ		= GridObj.GetColHDIndex("ORIGIN_PR_SEQ"	);
	INDEX_SOURCING_NO		= GridObj.GetColHDIndex("SOURCING_NO"		);
	INDEX_RFQ_NO			= GridObj.GetColHDIndex("RFQ_NO"			);
	INDEX_RFQ_COUNT			= GridObj.GetColHDIndex("RFQ_COUNT"		);
	INDEX_RFQ_SEQ			= GridObj.GetColHDIndex("RFQ_SEQ"			);
	INDEX_QTA_NO			= GridObj.GetColHDIndex("QTA_NO"			);
	INDEX_QTA_SEQ			= GridObj.GetColHDIndex("QTA_SEQ"			);
	INDEX_CLASS_GRADE		= GridObj.GetColHDIndex("CLASS_GRADE"		);
	INDEX_CLASS_SCORE		= GridObj.GetColHDIndex("CLASS_SCORE"		);
	INDEX_PLANT_CODE		= GridObj.GetColHDIndex("PLANT_CODE"		);
	INDEX_ROLE_CODE			= GridObj.GetColHDIndex("ROLE_CODE"		);

	INDEX_HUMAN_NAME_LOC	= GridObj.GetColHDIndex("HUMAN_NAME_LOC");
	INDEX_CONTRACT_DIV      = GridObj.GetColHDIndex("CONTRACT_DIV");
	INDEX_ITEM_GBN         	= GridObj.GetColHDIndex("ITEM_GBN");

	doSelect1();
}


function setHeader2() {
	IDX_SEL					= GridObj2.GetColHDIndex("SEL"			     );
	IDX_DP_SEQ			    = GridObj2.GetColHDIndex("DP_SEQ"			 );
	IDX_DP_TYPE             = GridObj2.GetColHDIndex("DP_TYPE"           );
	IDX_DP_PERCENT          = GridObj2.GetColHDIndex("DP_PERCENT"        );
	IDX_DP_AMT              = GridObj2.GetColHDIndex("DP_AMT"            );
	IDX_DP_PLAN_DATE        = GridObj2.GetColHDIndex("DP_PLAN_DATE"      );
	IDX_DP_PAY_TERMS        = GridObj2.GetColHDIndex("DP_PAY_TERMS"      );
	IDX_DP_PAY_TERMS_TEXT   = GridObj2.GetColHDIndex("DP_PAY_TERMS_TEXT" );
	IDX_FIRST_DEPOSIT       = GridObj2.GetColHDIndex("FIRST_DEPOSIT"     );
	IDX_FIRST_PERCENT       = GridObj2.GetColHDIndex("FIRST_PERCENT"     );
	IDX_CONTRACT_DEPOSIT    = GridObj2.GetColHDIndex("CONTRACT_DEPOSIT"  );
	IDX_CONTRACT_PERCENT    = GridObj2.GetColHDIndex("CONTRACT_PERCENT"  );
	IDX_MENGEL_DEPOSIT      = GridObj2.GetColHDIndex("MENGEL_DEPOSIT"    );
	IDX_MENGEL_PERCENT      = GridObj2.GetColHDIndex("MENGEL_PERCENT"    );
}

function doSelect1()
{
	var wise = GridObj;

	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=getEXDTInfo";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	GridObj.post( G_SERVLETURL, params );
	GridObj.clearAll(false);
	
	
	
// 	wise.SetParam("mode","getEXDTInfo");
<%-- 	wise.SetParam("pr_data","<%=pr_data%>"); --%>
<%-- 	wise.SetParam("pr_type","<%=PR_TYPE%>"); --%>
<%-- 	wise.SetParam("exec_no","<%=exec_no%>"); --%>
<%-- 	wise.SetParam("editable","<%=editable%>"); --%>
//     wise.SetParam("WISETABLE_DOQUERY_DODATA","0");
// 	wise.SendData(G_SERVLETURL);
//     wise.strHDClickAction="sortmulti";

}

function doSelect2()
{
	
	var wise = GridObj2;

<%-- 	var cols_ids = "<%=grid_col_id%>"; --%>
	var params = "mode=getCNDPInfo";
	params += "&cols_ids=" + GridObj2_getColIds();
	params += dataOutput();
	GridObj2.post( G_SERVLETURL, params );
	GridObj2.clearAll(false);
	

// 	var wise2 = GridObj2;
// 	wise2.SetParam("mode","getCNDPInfo");
<%-- 	wise2.SetParam("exec_no","<%=exec_no%>"); --%>
<%-- 	wise2.SetParam("pre_cont_seq","<%=pre_cont_seq%>"); --%>
<%-- 	wise2.SetParam("pre_cont_count","<%=pre_cont_count%>"); --%>
// 	wise2.SetParam("WISETABLE_DOQUERY_DODATA","0");
// 	wise2.SendData(G_SERVLETURL);
//     wise2.strHDClickAction="sortmulti";

}

function RoundEx(val, pos){
    var rtn;
    
    rtn = Math.round(val * Math.pow(10, Math.abs(pos)-1))
    rtn = rtn / Math.pow(10, Math.abs(pos)-1)

    return rtn;
}


function add_comma(input, num)
{
    var output = "";
    var output1 = "";
    var output2 = "";
    var temp1 = IsTrimStr(input);

    if(temp1 != "") {
        var temp = fixed_number(temp1);

        i = temp.length ;

        var k = i / 3 ;
        var m = i % 3 ;
        var n= 0;
        if(m==0) {
            for(j = 0; j < k-1; j++) {
                output1 += temp.substring(n, j*3+3)+",";
                n=j*3+3;
            }
        } else {
            for(j = 0; j < k-1; j++){
                output1 += temp.substring(n, j*3+m)+",";
                n=j*3+m;
            }
        }

        output1 += temp.substring(n,temp.length);
        var h = searchDot(temp1);
        if(num != "0") {
            //output2 += "." ;
        }
        if(h == ""){
            for(p=0; p < num; p++){
                //output2 += "0" ;
            }
        } else {
            var temp2 = decimal_number(temp1,num)+"" ;
            temp2 = temp2.substring(1,temp2.length);
            output2 = temp2;
        }
        output = output1 + output2 ;

    } else if(temp1 == "") {
        if(num == "0"){
            output += "" ;
        }else{
            output += "0." ;
        }

        for(p=0; p < num; p++){
            output += "0" ;
        }
    }
    var tmp1 = "";

    if(output.charAt(0)=="-"){
        if(output.charAt(1)==",") {
            tmp1 = output.substring(2, output.length);
            output = "-"+tmp1;
        }
    }
    return output;
}

function del_comma(input){
	var s = 0;
   	for(i=0; i < input.length; i++){
        if(input.charAt(i)==","){
            s++ ;
        }
    }
    for(i = 0;i < s; i++){
        input = input.replace(",", "");
    }
    return input;
}


var grid2SelectCnt = 0;
var addOptionCnt = 0;
var firstValues = new Array(); // 최초 조회된 값들. 수정이 됐는지 여부 판단하기위한 데이터
var colums = new Array("QTY", "PR_UNIT_PRICE", "CUSTOMER_PRICE", "UNIT_PRICE", "PR_AMT", "ITEM_AMT", "PR_NO", "PR_SEQ");

function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
	if (msg1 == "doQuery")
	{
		var rowCount = GridObj.GetRowCount();
		if(rowCount > 0) {

			var preferred_bidder = GridObj.GetCellValue("PREFERRED_BIDDER"			, 0);
			if(preferred_bidder == "Y"){
				var divObj = document.getElementById("preferred_bidder");
				divObj.innerText = "우선협상대상자 선정기안";
			}

			setAmt();
			//document.forms[0].pr_no.value 				= GridObj.GetCellValue("PR_NO"				, 0);
			document.forms[0].pr_subject.value 			= GridObj.GetCellValue("PR_SUBJECT"			, 0);
			// 변경기안서인 경우 변경기안라는 내용표기
			var subject_name = (GridObj.GetCellValue("SUBJECT", 0) == "" ? (GridObj.GetCellValue("WBS_NAME", 0) == "" ? GridObj.GetCellValue("PR_SUBJECT", 0) : GridObj.GetCellValue("WBS_NAME", 0)) : GridObj.GetCellValue("SUBJECT", 0));
			if ("E" == "<%=screenMode%>") {
				if (subject_name.indexOf("[변경기안]") == -1) {
					document.forms[0].subject.value = "[변경기안] " + subject_name;
				} else {
					document.forms[0].subject.value = subject_name;
				}
			} else {
				document.forms[0].subject.value = subject_name;
			}
			document.forms[0].add_user_id.value 		= GridObj.GetCellValue("PR_ADD_USER_ID"		, 0);
			document.forms[0].add_user_name.value 		= GridObj.GetCellValue("PR_USER_NAME"			, 0);
			document.forms[0].vendor_code.value 		= GridObj.GetCellValue("PO_VENDOR_CODE"		, 0);
			document.forms[0].vendor_name.value 		= GridObj.GetCellValue("VENDOR_NAME"			, 0);

			document.forms[0].i_dp_count.value 			= GridObj.GetCellValue("PAY_TERMS"		    , 0);
			document.forms[0].i_dp_type.value 			= GridObj.GetCellValue("PAY_TERMS_HD"			, 0);
			document.forms[0].i_dp_type_text.value	 	= GridObj.GetCellValue("PAY_TERMS_HD_DESC" 	, 0);

			document.forms[0].i_insurance.value 		= GridObj.GetCellValue("INSURANCE"			, 0);//'Y'
// 			document.forms[0].s_insurance.value 		= GridObj.GetCellValue("INSURANCE"			, 0);//'Y'
			document.forms[0].pre_exec_no.value 		= GridObj.GetCellValue("PRE_EXEC_NO"		    , 0);

// 			document.forms[0].delay_remark.value 		= GridObj.GetCellValue("DELAY_REMARK"		    , 0);
// 			document.forms[0].warranty_month.value 		= GridObj.GetCellValue("WARRANTY_MONTH"		    , 0);

			document.forms[0].dely_to_location.value 	= GridObj.GetCellValue("DELY_TO_LOCATION"		    , 0);
			document.forms[0].dely_to_address.value 	= GridObj.GetCellValue("DELY_TO_ADDRESS"		    , 0);
			document.forms[0].dely_to_user.value 		= GridObj.GetCellValue("DELY_TO_USER"		    	, 0);
			document.forms[0].dely_to_phone.value 		= GridObj.GetCellValue("DELY_TO_PHONE"		    , 0);

			for(var i = 0; i < document.forms[0].dely_terms.options.length; i++){
				if(document.forms[0].dely_terms.options[i].value == GridObj.GetCellValue("DELY_TERMS", 0)){
					document.forms[0].dely_terms.options[i].selected = true;
					break;
				}
			}

			var valid_from_date = GridObj.GetCellValue("VALID_FROM_DATE"		, 0);
			var valid_to_date	= GridObj.GetCellValue("VALID_TO_DATE"		, 0);
<%if ("R".equals(screenMode)) {%>
		if (valid_from_date.length == 8) valid_from_date = valid_from_date.substring(0,4) + "/" + valid_from_date.substring(4,6)  + "/" + valid_from_date.substring(6,8);
		if (valid_to_date.length   == 8) valid_to_date   = valid_to_date.substring(0,4) + "/" + valid_to_date.substring(4,6)  + "/" + valid_to_date.substring(6,8);
<%}%>
			document.forms[0].valid_from_date.value 	= valid_from_date
			document.forms[0].valid_to_date.value 		= valid_to_date;

			document.forms[0].wbs_info.value 			= GridObj.GetCellValue("WBS_NO"		, 0);
			document.forms[0].ahead_flag_header.checked = GridObj.GetCellValue("AHEAD_FLAG"		, 0) == "Y" ? true : false ;
			document.forms[0].ahead_flag.value 			= GridObj.GetCellValue("AHEAD_FLAG"		, 0);

			var ADD_DATE = GridObj.GetCellValue("ADD_DATE", 0).substring(0, 4) + "/"+ GridObj.GetCellValue("ADD_DATE", 0).substring(4, 6) + "/" + GridObj.GetCellValue("ADD_DATE", 0).substring(6, 8);
			document.forms[0].add_date.value 			= GridObj.GetCellValue("ADD_DATE"		, 0) == "" ? "<%=SepoaDate.getFormatString("yyyy/MM/dd")%>" 	: ADD_DATE;
//			document.forms[0].ctrl_person_id.value 		= GridObj.GetCellValue("ADD_USER_ID"		, 0);
//			document.forms[0].ctrl_person_name.value 	= GridObj.GetCellValue("USER_NAME"		, 0);
			document.forms[0].ctrl_person_id.value 		= GridObj.GetCellValue("ADD_USER_ID"		, 0) == "" ? "<%=user_id%>" 	: GridObj.GetCellValue("ADD_USER_ID"		, 0);
			document.forms[0].ctrl_person_name.value 	= GridObj.GetCellValue("USER_NAME"		, 0) == "" ? "<%=user_name%>" 	: GridObj.GetCellValue("USER_NAME"		, 0);
			document.forms[0].ctrl_code.value 			= GridObj.GetCellValue("CTRL_CODE"		, 0) == "" ? "<%=CTRL_CODE%>" 	: GridObj.GetCellValue("CTRL_CODE"		, 0);

			document.forms[0].dely_to_location.value 		= GridObj.GetCellValue("DELY_TO_LOCATION"		, 0) ;
			document.forms[0].dely_to_address.value 		= GridObj.GetCellValue("DELY_TO_ADDRESS"		, 0) ;
			document.forms[0].dely_to_user.value 		= GridObj.GetCellValue("DELY_TO_USER"		, 0) ;
			document.forms[0].dely_to_phone.value 		= GridObj.GetCellValue("DELY_TO_PHONE"		, 0) ;

			for(var i = 0; i < document.forms[0].contract_flag.options.length; i++){
				if(document.forms[0].contract_flag.options[i].value == GridObj.GetCellValue("CONTRACT_FLAG", 0)){
					document.forms[0].contract_flag.options[i].selected = true;
					break;
				}
			}

			for(var i = 0; i < document.forms[0].po_type.options.length; i++){
				if(document.forms[0].po_type.options[i].value == GridObj.GetCellValue("PO_TYPE", 0)){
					document.forms[0].po_type.options[i].selected = true;
					break;
				}
			}

			document.forms[0].remark.value 				= GridObj.GetCellValue("REMARK"		, 0);
			document.forms[0].attach_no.value			= GridObj.GetCellValue("H_ATTACH_NO"		, 0);

			var screenMode = "<%=(screenMode.equals("R")) ? "R" : "C"%>";
			//rMateFileAttach('S',screenMode,'EX',form1.attach_no.value);
		}


		if(addOptionCnt == 0){
			//GridObj.AddComboListValue("PLANT_CODE","선택","");
			//GridObj.AddComboListValue("ROLE_CODE","선택","");
			addOptionCnt++
		}

		<%if ("".equals(exec_no)) {%>
				for(var i = 0; i < GridObj.GetRowCount(); i++){
					//GridObj.SetComboSelectedHiddenValue("PLANT_CODE",i,"");
					//GridObj.SetComboSelectedHiddenValue("ROLE_CODE",i,"");
				}
		<%}%>
		
		<%if (!"".equals(exec_no)) {%>
			if(grid2SelectCnt == 0){
				doSelect2();
				grid2SelectCnt++;
				changeContract();
			}

		<%}else if(!pre_cont_seq.equals("")){%>
			document.form1.contract_flag.value = 'Y';
			changeContract();
		<%}%>
		

		// 수량, 예상단가, 소비자단가, 공급단가
		var obj;
		for(var i = 0; i < GridObj.GetRowCount(); i++){

			var obj = new Object();
			for(var j = 0; j < colums.length; j++){
				obj[colums[j]] = GridObj.GetCellValue(colums[j], i);
			}
			firstValues[i] = obj;
			if(GridObj.GetCellValue("UNIT_MEASURE",i) == "M/M" ){
				GridObj.SetComboSelectedIndex("STD_PRICE_FLAG",i,1);
			}
		}


// 		if(GridObj2.GetRowCount() > 0){
// 			var I_amt = 0;
// 			var S_amt = 0;
// 			var S_dp_type_text = "";
// 			var I_dp_type_text = "";
// 			for(var i = 0; i < GridObj2.GetRowCount(); i++){
// 				if(GridObj2.GetCellValue("DP_DIV", i) == "I"){
// 					I_amt += parseFloat(GridObj2.GetCellValue("DP_AMT", i));
// 					I_dp_type_text = GridObj2.GetCellValue("DP_TYPE_DESC", i);
// 				}else if(GridObj2.GetCellValue("DP_DIV", i) == "S"){
// 					S_amt += parseFloat(GridObj2.GetCellValue("DP_AMT", i));
// 					S_dp_type_text = GridObj2.GetCellValue("DP_TYPE_DESC", i);
// 				}
// 			}
// 			document.form1.s_dp_type_text.value	= S_dp_type_text;
// 			document.form1.i_dp_type_text.value = I_dp_type_text;
// 			document.form1.s_pay_amt.value = S_amt == 0 ? "" : add_comma(S_amt, 2);
// 			document.form1.i_pay_amt.value = I_amt == 0 ? "" : add_comma(I_amt, 2);
// 		}

		if(GridObj2.GetRowCount() > 0){
			var I_amt = 0;
			var I_dp_type_text = "";
			for(var i = 0; i < GridObj2.GetRowCount(); i++){
				I_amt += parseFloat(GridObj2.GetCellValue("DP_AMT", i));
				I_dp_type_text = GridObj2.GetCellValue("DP_TYPE_DESC", i);
			}
			document.form1.i_dp_type_text.value = I_dp_type_text;
			document.form1.i_pay_amt.value = I_amt == 0 ? "" : add_comma(I_amt, 2);
		}
	}
	if(msg1 == "doData")
	{
// 		var mode = GD_GetParam(GridObj,0);
// 		var status = GD_GetParam(GridObj,1);
// 		alert(GridObj.GetMessage());
// 		if(status != "0")
// 		{
// 			opener.doSelect();
// 			self.close();

// 		}


	}
	if(msg1=="t_insert"){
		if(msg3 == INDEX_VALID_FROM_DATE || msg3==INDEX_VALID_TO_DATE){
			var vendor_code	= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("PO_VENDOR_CODE")).getValue());
			for( i = 0 ; i < GridObj.GetRowCount() ; i++ ){
				if( vendor_code == wise.GetCellValue("PO_VENDOR_CODE",i)){
					wise.SetCellValueIndex(msg3,i,msg5);
				}
			}
		}

		if(msg3 == INDEX_UNIT_PRICE || msg3 == INDEX_CUSTOMER_PRICE || msg3 == INDEX_QTY || msg3 == INDEX_PR_UNIT_PRICE){
			// 수량이나 소비자가단가, 공급가단가 변동시
			// 예상가금액, 소비자가금액, 공급가금액, 할인율, 절감율, 절감액, 부가세
			
			var wise 			= GridObj;
			
			var qty				= parseFloat(LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("QTY")).getValue())			   == "" ? 0 : LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("QTY")).getValue()));
			var pr_unit_price 	= parseFloat(LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("PR_UNIT_PRICE")).getValue())  == "" ? 0 : LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("PR_UNIT_PRICE")).getValue()));
			var customer_price 	= parseFloat(LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("CUSTOMER_PRICE")).getValue()) == "" ? 0 : LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("CUSTOMER_PRICE")).getValue()));
			var unit_price 		= parseFloat(LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("UNIT_PRICE")).getValue())     == "" ? 0 : LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("UNIT_PRICE")).getValue()));

			//예상가금액
			
			
			GridObj.cells(msg2, GridObj.getColIndexById("PR_AMT")).setValue(RoundEx(qty * pr_unit_price, 3));
			//wise.SetCellValue("PR_AMT", msg2, RoundEx(qty * pr_unit_price, 3));

			//소비자가금액
			GridObj.cells(msg2, GridObj.getColIndexById("S_ITEM_AMT")).setValue(RoundEx(qty * customer_price, 3));
// 			wise.SetCellValue("S_ITEM_AMT", msg2, RoundEx(qty * customer_price, 3));

			//공급가금액
			GridObj.cells(msg2, GridObj.getColIndexById("ITEM_AMT")).setValue(RoundEx(qty * unit_price, 3));
// 			wise.SetCellValue("ITEM_AMT", msg2, RoundEx(qty * unit_price, 3));

			var pr_amt 			= parseFloat(LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("PR_AMT")).getValue()));
			var cumstomer_amt 	= parseFloat(LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("S_ITEM_AMT")).getValue()));
			var item_amt 		= parseFloat(LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("ITEM_AMT")).getValue()));

			//할인율
			
			GridObj.cells(msg2, GridObj.getColIndexById("DISCOUNT")).setValue(customer_price == 0 ? 0.00 : RoundEx((customer_price- unit_price)/customer_price*10000/100, 3));
//			wise.SetCellValue("DISCOUNT", msg2, customer_price == 0 ? 0.00 : RoundEx((customer_price- unit_price)/customer_price*10000/100, 3));

			//절감액 (예상액 - 공급가액)
			GridObj.cells(msg2, GridObj.getColIndexById("SALE_AMT")).setValue(pr_amt - item_amt);
// 			wise.SetCellValue("SALE_AMT", msg2, pr_amt - item_amt);

			//절감율
			GridObj.cells(msg2, GridObj.getColIndexById("SALE_PER_2")).setValue(pr_amt == 0 ? 0.00 : RoundEx((pr_amt- item_amt)/pr_amt*10000/100, 3));
// 			wise.SetCellValue("SALE_PER_2", msg2,pr_amt == 0 ? 0.00 : RoundEx((pr_amt- item_amt)/pr_amt*10000/100, 3));

			var tot_pr_amt 	= 0;
			var tot_item_amt= 0;

			for(var i = 0; i < GridObj.GetRowCount(); i++){
				tot_pr_amt 		+= parseFloat(GridObj.GetCellValue("PR_AMT", i));
				tot_item_amt 	+= parseFloat(GridObj.GetCellValue("ITEM_AMT", i));
			}


			document.forms[0].sale_amt.value = add_comma(RoundEx(tot_pr_amt - tot_item_amt, 3), 2);
			document.forms[0].sale_per.value = tot_pr_amt == 0 ? 0.00 : add_comma(RoundEx((tot_pr_amt - tot_item_amt) / tot_pr_amt*100, 3), 2);
			
			//부가세
			
			
			GridObj.cells(msg2, GridObj.getColIndexById("ITEM_VAT_AMT")).setValue(RoundEx(parseFloat(LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("ITEM_AMT")).getValue())) * 0.1 , 3));
// 			wise.SetCellValue("ITEM_VAT_AMT", msg2 , RoundEx(wise.GetCellValue("ITEM_AMT", msg2) * 0.1 , 3));

			// 사전지원요청인 경우에는 요청금액이 0일수 있으므로 기안금액이 항상 바뀔수 있다.
			<%if ("B".equals(REQ_TYPE)) {%>
				//setAmt();
			<%}%>


		}
		/*
		if(msg3 == INDEX_ITEM_VAT_AMT){

			var ITEM_VAT_AMT = parseFloat(LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("ITEM_VAT_AMT")).getValue()));
			
			var tmp = parseFloat(LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("ITEM_AMT")).getValue())     == "" ? 0 : LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("ITEM_AMT")).getValue()));
			var TEN_PERCENT_ITEM_AMT = RoundEx(tmp * 0.1 , 3);

			if(!(ITEM_VAT_AMT == 0 || ITEM_VAT_AMT == TEN_PERCENT_ITEM_AMT) ){
				alert("부가세는 0.00 또는 " + add_comma(TEN_PERCENT_ITEM_AMT, 2) + " 만 입력가능합니다.");
				GridObj.cells(msg2, GridObj.getColIndexById("ITEM_VAT_AMT")).setValue(msg4);
				
				//GridObj.SetCellValue("ITEM_VAT_AMT", msg2, msg4);
			}
		}
		*/


	}
    if(msg1=="t_imagetext")
    {
    	G_CUR_ROW = msg2;
    	var url = "";
    	//대금지불조건
    	if(msg3 == INDEX_PAY_TERMS)
    	{
    		var wise 		= GridObj;
    		//var pr_seq 		= wise.GetCellValue("PR_SEQ"			,msg2);
    		var item_amt 	= 0;
    		//var dp_info 	= wise.GetCellValue("DP_INFO"			,msg2);
    		//var vendor_code	= wise.GetCellValue("PO_VENDOR_CODE"	,msg2);
    		//var pr_no		= wise.GetCellValue("PR_NO"				,msg2);
    		
    		
    		
    		var dp_type 	= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("PAY_TERMS_HD")).getValue());
			var rowCount 	= wise.GetRowCount();
			for( i = 0 ; i < rowCount ; i++ ){
				//if( vendor_code == wise.GetCellValue("PO_VENDOR_CODE",i) && pr_no ==  wise.GetCellValue("PR_NO",i)){
					item_amt += parseInt(wise.GetCellValue("ITEM_AMT",i));
				//}
			}
    		//url = "/kr/dt/app/app_pp_ins2.jsp?exec_amt="+item_amt+"&pr_seq="+pr_seq+"&row="+msg2+"&dp_info="+dp_info+"&vendor_code="+vendor_code+"&dp_type="+dp_type;
    		url = "/kr/dt/app/app_pp_ins3.jsp?exec_amt="+item_amt+"&dp_type="+dp_type;
    		window.open(url,"app_pp_ins2","left=0,top=0,width=800,height=500,resizable=yes,scrollbars=yes");
    	}
    	//구매요청번호
    	
    	
        if (msg3 == INDEX_PR_NO) {
        	
      		var img_pr_no = LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("PR_NO")).getValue());
      		window.open("/kr/dt/pr/pr1_bd_dis1.jsp?pr_no="+img_pr_no,"pr1_bd_dis1","left=0,top=0,width=1024,height=650,resizable=yes,scrollbars=yes");
		}
    	

		if(msg3 == INDEX_ITEM_NO){
			var item_no = LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("ITEM_NO")).getValue());
			if(item_no == ""){
				return;
			}
			//if(pr_type=="I")
				window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+msg4,"real_pp_lis1","left=0,top=0,width=750,height=550,resizable=yes,scrollbars=yes");
			//else
			//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+msg4,"real_pp_lis1","left=0,top=0,width=750,height=550,resizable=yes,scrollbars=yes");
		}
		if(msg3 == INDEX_DESCRIPTION_LOC){
			
			var item_no = LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("ITEM_NO")).getValue());
			//if(pr_type=="I")
				window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+item_no,"real_pp_lis1","left=0,top=0,width=750,height=550,resizable=yes,scrollbars=yes");
			//else
			//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+item_no,"real_pp_lis1","left=0,top=0,width=750,height=550,resizable=yes,scrollbars=yes");
		}
		if(msg3 == INDEX_PO_VENDOR_CODE){
			
			var tmp = LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("PO_VENDOR_CODE")).getValue());
			alert(tmp);
			if(tmp==""){
				alert("업체가 없습니다.");
				return;
			}
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+tmp,"ven_bd_con","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
		}
        if(msg3 == INDEX_HUMAN_NAME_LOC) {
            var ITEM_NO_SUB = LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("ITEM_NO")).getValue()).substring(0, 2);
            //var ITEM_NO_SUB = GridObj.GetCellValue("ITEM_GBN", msg2);
           	if (ITEM_NO_SUB == "HW" || ITEM_NO_SUB == "SW") {
           	}else {
           		var vendor_code = LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("PO_VENDOR_CODE")).getValue());

            	if ("<%=screenMode%>" == "R") {
            	} else {
          			SP0272_Popup(vendor_code)
          		}
           	}
        }
		if(msg3 == INDEX_SOURCING_NO){
			//BID,RAT,RFQ
			// RFQ : window.open("rfq_bd_dis1.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=850,height=550,left=0,top=0");
			// RAT : window.open("/ebid_doc/reveracution.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1dd","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=900,height=740,left=0,top=0");
			// BID : window.open('/ebid_doc/inchaldetail.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
			var send_url = "";
			var sourcing_no 	= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("SOURCING_NO")).getValue());
			var sourcing_count 	= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("SOURCING_COUNT")).getValue());
			var sourcing_type	= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("SOURCING_TYPE")).getValue());

			if(sourcing_type == "RFQ"){
				send_url = "/kr/dt/rfq/rfq_bd_dis1.jsp?rfq_no=" + sourcing_no + "&rfq_count=" + sourcing_count;
			}else if(sourcing_type == "RAT"){
				send_url= "/ebid_doc/reveracution.jsp?RA_NO=" + sourcing_no + "&RA_COUNT=" + sourcing_count;
			}else if(sourcing_type == "BID"){
				send_url= "/ebid_doc/inchaldetail.jsp?BID_NO=" + sourcing_no + "&BID_COUNT=" + sourcing_count
			}else if(sourcing_type == ""){
				return;
			}

			window.open(send_url ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1021,height=768,left=0,top=0");
		}
    }
}
function setAmt(){
	var rowCount = GridObj.GetRowCount();
	var amt		=0;
	var sale_amt=0;
	var pr_amt  =0;
	for(i = 0; i < rowCount; i++){

		amt 	 += parseFloat(GD_GetCellValueIndex(GridObj,i,INDEX_ITEM_AMT) == "" ? "0" : GD_GetCellValueIndex(GridObj,i,INDEX_ITEM_AMT));
		sale_amt += parseFloat(GD_GetCellValueIndex(GridObj,i,INDEX_SALE_AMT) == "" ? "0" : GD_GetCellValueIndex(GridObj,i,INDEX_SALE_AMT));
	    pr_amt 	 += parseFloat(GD_GetCellValueIndex(GridObj,i,INDEX_PR_AMT)   == "" ? "0" : GD_GetCellValueIndex(GridObj,i,INDEX_PR_AMT));
	}
	document.all.exec_amt.value = amt;
	document.all.amt.value = add_comma(amt,2);
	document.all.sale_amt.value = add_comma(pr_amt-amt,2);
	document.all.sale_per.value = pr_amt == "0" ? "0.00" :  RoundEx((pr_amt-amt)/pr_amt*10000/100, 3);
}
function checkData()
{

	return true;
}


/*
	sign_status : P(결재요청)/T(저장)
*/
function Approval(sign_status)
{
	var f = document.forms[0];
    var wise = GridObj;
    f.sign_status.value = sign_status;
    var dp_info = "";
	dp_info = setDpInfo();
	
	/*
	if(""==document.forms[0].exec_flag.value){
		alert("기안종류를 선택해 주세요.");
		return;
	}
	*/
	if(""==document.forms[0].subject.value){
		alert("사전지원명을 입력해 주세요.");
		document.forms[0].subject.focus();
		return;
	}

	if(""==document.forms[0].ctrl_person_id.value){
		alert("사전지원담당자를 입력해 주세요.");
		document.forms[0].ctrl_person_id.focus();
		return;
	}
	
// 	if(""==document.forms[0].contract_flag.value){
// 		alert("계약여부를 선택해 주세요.");
// 		return;
// 	}
	
// 	if(document.forms[0].valid_from_date.value == "" || document.forms[0].valid_to_date.value == ""){	
// 		if(document.forms[0].contract_flag.value == 'Y'){
// 			alert("계약기간를 입력해주세요.");
// 			return;			
// 		}
// 	}

	/* 필수값 제거 2012.07.23
	if(""==document.forms[0].dely_to_location.value){
		alert("납품장소를 입력해 주세요.");
		document.forms[0].dely_to_location.focus();
		return;
	}

	if(""==document.forms[0].dely_to_address.value){
		alert("납품주소를 입력해 주세요.");
		document.forms[0].dely_to_address.focus();
		return;
	}

	if(""==document.forms[0].dely_to_user.value){
		alert("수령인을 입력해 주세요.");
		document.forms[0].dely_to_user.focus();
		return;
	}

	if(""==document.forms[0].dely_to_phone.value){
		alert("수령인연락처를 입력해 주세요.");
		document.forms[0].dely_to_phone.focus();
		return;
	}
	*/
// 	if(""==document.forms[0].po_type.value){
// 		alert("기안구분을 선택해 주세요.");
// 		return;
// 	}

// 	if(dp_info=="empty"){
// 		alert("대금 지불정보를 입력해주세요.");
// 		return;
// 	}

// 	if(dp_info=="S_empty"){
// 		alert("용역 대금지불정보를 입력해주세요.");
// 		return;
// 	}

// 	if(dp_info=="I_empty"){
// 		alert("물품 대금지불정보를 입력해주세요.");
// 		return;
// 	}

	// 기안금액 = 용역 + 장비
	var item_amt= parseFloat(del_comma(document.forms[0].amt.value));
	var dp_amt	= 0;

	for(var i = 0; i < GridObj.GetRowCount(); i++){

		if(GridObj.GetCellValue("QTY", i) == "0" || GridObj.GetCellValue("QTY", i) == ""){
			alert("수량을 입력해주세요.");
			return;
		}

		if(GridObj.GetCellValue("UNIT_PRICE", i) == "0" || GridObj.GetCellValue("UNIT_PRICE", i) == ""){
	      	//alert("공급가 단가를 입력해주세요.");
			alert("계약금액 단가를 입력해주세요.");
			return;
		}

		//item_amt+= parseFloat(GridObj.GetCellValue("ITEM_AMT",i));
		if(GridObj.GetCellValue("ITEM_VAT_AMT", i) == ""){
			alert("부가세를 입력해주세요.");
			return;
		}

// 		if(GridObj.GetCellValue("RD_DATE", i) == ""){
// 			alert("납기요청일을 입력해주세요.");
// 			return;
// 		}
	}

	for (var i = 0; i < GridObj2.GetRowCount(); i++){
		dp_amt 	+= parseFloat(GridObj2.GetCellValue("DP_AMT",i));
	}

// 	if(item_amt != dp_amt){
// 		alert("기안금액과 대금지불 금액이 올바르지 않습니다.\n기안(" + add_comma(item_amt, 2) + ") !=  대금지급(" + add_comma(dp_amt, 2) + ")");
// 		return;
// 	}
	
	$("#dp_info").val(dp_info);
	
	if (sign_status == "P") {
		childFrame.location.href="/kr/admin/basic/approval/approval.jsp?house_code=<%=house_code%>&company_code=<%=COMPANY_CODE%>&dept_code=<%=DEPARTMENT%>&req_user_id=<%=user_id%>&doc_type=EX&fnc_name=getApproval&amt="+document.all.exec_amt.value;
        //document.forms[0].target = "childframe";
        //document.forms[0].action = "/kr/admin/basic/approval/approval.jsp";
        //document.forms[0].method = "POST";
        //document.forms[0].submit();
	} else {
		getApproval(sign_status);
		return;
	}
}

	function getApproval(approval_str) {
		var f = document.forms[0];

		if (approval_str == "") {
			alert("결재자를 지정해 주세요");
			return;
		}
		
		var gu = "<%=("B".equals(REQ_TYPE)) ? "사전지원":"기안"%>";
		
		var message = gu+"을 임시저장 하시겠습니까?";
		if(f.sign_status.value == "P") {
		<%if("B".equals(REQ_TYPE)){%>		
			message = "기안을 완료요청 하시겠습니까?";
		<%}else{%>
			message = "기안을 결재요청 하시겠습니까?";		
		<%}%>
		} else if(f.sign_status.value == "E") {
			message = gu+"을 작성완료 하시겠습니까?";
		}

		if(!confirm(message)) {
			return;
		}
		
		f.approval_str.value = approval_str;
		//document.attachFrame.setData();	//startUpload
		getApprovalSend(approval_str);
	}

	function getApprovalSend(approval_str) {
		var f = document.forms[0];
		var wise = GridObj;

		var rowCount            = wise.GetRowCount();
		var G_TTL_ITEM_QTY      = rowCount;
		var G_CUR               = (rowCount > 0)?wise.GetCellValue("CUR",0):"KRW";
		var G_VALID_FROM_DATE   = del_Slash(document.forms[0].valid_from_date.value);
		var G_VALID_TO_DATE     = del_Slash(document.forms[0].valid_to_date.value);

		var G_CREATE_TYPE		= "<%=CREATE_TYPE%>";
		var G_PAY_TERMS         = document.forms[0].i_dp_type.value;
		var G_DELY_TERMS		= "";

		//  수정여부 판단
		if(gridModifyFlag == "N"){	// 행추가 및 삭제가 없는경우
			if(firstValues.length != GridObj.GetRowCount()){
				gridModifyFlag = "Y"
			} else {
				for(var i = 0; i < firstValues.length; i++){
					for(var j = 0; j < colums.length; j++){
						if(firstValues[i][colums[j]] != GridObj.GetCellValue(colums[j], i)){
							gridModifyFlag = "Y";
							break;
						}
					}

				}
			}
		}

		// PR별 총요청금액, 총공급가금액은 추가,삭제 수정이 되더라도 PR_NO별로 맞아야 한다.
		var arrayFromPR = new Array();
		var arrayToPR = new Array();
		for(var i = 0; i < firstValues.length; i++){
			arrayFromPR[i] = firstValues[i]["PR_NO"];
			arrayToPR[i] = firstValues[i]["PR_NO"];
		}

		// 중복된 PR_NO가 제거된 DISTINCT PR_NO들을 구한다.
		var sameCnt = 0;
		for(var i = 0; i < arrayFromPR.length; i++){
			sameCnt = 0;
			for(var j = 0; j < arrayToPR.length; j++){
				if(arrayFromPR[i] == arrayToPR[j]){
					sameCnt++;
					if(sameCnt > 1){
						arrayToPR[j] = "";
					}
				}
			}
		}

		// 최초조회된 리스트의 합계를 구한다.
		var prNo_prAmt_itemAmt = new Array();
		var k=0;
		for(var i = 0; i < arrayToPR.length; i++){ // arrayToPR 중복된 PR_NO가 제거된 DISTINCT PR_NO들
			if(arrayToPR[i] != "" ){
				var sum_origin_pr_amt = 0;
				var sum_origin_item_amt	= 0;
				for(var j = 0; j < firstValues.length; j++){
					if(arrayToPR[i] == firstValues[j]["PR_NO"]){
						sum_origin_pr_amt 	+=  parseFloat(firstValues[j]["PR_AMT"] 	== "" ? "0" : firstValues[j]["PR_AMT"]);
						sum_origin_item_amt +=  parseFloat(firstValues[j]["ITEM_AMT"] 	== "" ? "0" : firstValues[j]["ITEM_AMT"]);
					}
				}

				obj = new Object();

				obj.PR_NO = arrayToPR[i];
				obj.PR_AMT = sum_origin_pr_amt;
				obj.ITEM_AMT = sum_origin_item_amt;


				prNo_prAmt_itemAmt[k] = obj;
				k++;
			}
		}

		// 최초 조회된 요청금액, 공급가액 과 수정된 요청금액, 공급가액을 비교한다.
		for(var i = 0; i < prNo_prAmt_itemAmt.length; i++){
			var sum_grid_pr_amt = 0;
			var sum_grid_item_amt = 0;
			for(var j = 0; j < GridObj.GetRowCount(); j++){
				if(prNo_prAmt_itemAmt[i]["PR_NO"] == GridObj.GetCellValue("PR_NO", j)){
					sum_grid_pr_amt 	+= parseFloat(GridObj.GetCellValue("PR_AMT", j) 	== "" ? "0" : GridObj.GetCellValue("PR_AMT", j));
					sum_grid_item_amt 	+= parseFloat(GridObj.GetCellValue("ITEM_AMT", j) == "" ? "0" : GridObj.GetCellValue("ITEM_AMT", j));
				}
			}

<%--
			사전기안, 구매기안에서 요청금액은 항상 바뀔 수 있다.
			사전기안, 구매기안에서 기안금액(업체선정에서 투찰한 금액은 아이템 수정시 바뀔 수 있으나 투찰한 총 금액의 합은 바뀔 수 없다.)
			20100722
<%
			if("P".equals(REQ_TYPE)){
%>
				if(prNo_prAmt_itemAmt[i]["PR_AMT"] != sum_grid_pr_amt){
					alert("구매요청번호 " + prNo_prAmt_itemAmt[i]["PR_NO"] + "의 기존요청금액과(" + add_comma(prNo_prAmt_itemAmt[i]["PR_AMT"], 2) + ") 과 수정된 요청금액(" + add_comma(sum_grid_pr_amt, 2) + ") 이 일치하지 않습니다.");
					return;
				}

				if(prNo_prAmt_itemAmt[i]["ITEM_AMT"] != sum_grid_item_amt){
					alert("구매요청번호 " + prNo_prAmt_itemAmt[i]["PR_NO"] + "의 기존공급금액과(" + add_comma(prNo_prAmt_itemAmt[i]["ITEM_AMT"], 2) + ") 과 수정된 공급금액(" + add_comma(sum_grid_item_amt, 2) + ") 이 일치하지 않습니다.");
					return;
				}
<%
			}
%>
--%>

<%String pr_no_name = "P".equals(REQ_TYPE) ? "구매요청번호 " : "사전지원요청번호 ";
			pr_no_name = "구매요청번호";%>



			if(prNo_prAmt_itemAmt[i]["ITEM_AMT"] != sum_grid_item_amt){
			  	//alert("<//%=pr_no_name%>" + prNo_prAmt_itemAmt[i]["PR_NO"] + "의 기존공급금액과(" + add_comma(prNo_prAmt_itemAmt[i]["ITEM_AMT"], 2) + ") 과 수정된 공급금액(" + add_comma(sum_grid_item_amt, 2) + ") 이 일치하지 않습니다.");
				alert("<%=pr_no_name%>" + prNo_prAmt_itemAmt[i]["PR_NO"] + "의 기존계약금액과(" + add_comma(prNo_prAmt_itemAmt[i]["ITEM_AMT"], 2) + ") 과 수정된 계약금액(" + add_comma(sum_grid_item_amt, 2) + ") 이 일치하지 않습니다.");
				return;
			}
		}

		var remain_pr_data = ""; // 조회된건 중에 삭제되지 않고 남아있는 데이터 PR_SEQ가 있는 놈들
		for(var i = 0; i < GridObj.GetRowCount(); i++){
			if(GridObj.GetCellValue("PR_SEQ", i) != ""){
				remain_pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i) + ",";
			}
		}

		for(var i = 0; i < GridObj.GetRowCount(); i++){
// 			GridObj.SetCellValue("SELECTED", i, "1");
			
			GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;	
			GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");			
			
<%if ("B".equals(REQ_TYPE)) {%>
// 				GridObj.SetCellValue("ITEM_VAT_AMT", i, "0");
				GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("ITEM_VAT_AMT")).setValue("0");
<%}%>
		}
		
		if ("E" == "<%=screenMode%>") {
			$("#exec_no").val("");
			$("#bf_exec_no").val("<%=exec_no%>");
		}else{
			$("#exec_no").val("<%=exec_no%>");
			$("#bf_exec_no").val("");			
		}
		
		var grid2Cnt = GridObj2.GetRowCount();
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		params = "?mode=setInsertEX";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		
		var colId2 = GridObj2_getColIds().split(",");
		
// 		params += "&grid2Cnt=" + grid2Cnt;
		
// 		var msg = "";
// 		if(grid2Cnt > 0){
// 			for(var i = 0 ; i < grid2Cnt ; i++){
// 				for(var j = 0 ; j < colId2.length ; j++){
// 					msg += colId2[j] +"=" + LRTrim(GridObj2.cells(GridObj2.getRowId(i), GridObj2.getColIndexById(colId2[j])).getValue())+ "\n";
// 					params += "&SUB_" + colId2[j] + "_" + i + "=" +  LRTrim(GridObj2.cells(GridObj2.getRowId(i), GridObj2.getColIndexById(colId2[j])).getValue());					
// 				}	
// 			}
// 		}
		//alert(msg);
		
		
		myDataProcessor = new dataProcessor(G_SERVLETURL+params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);		
		
		

// 		GridObj.SetParam("mode"				,"setInsertEX"        		);
// 		GridObj.SetParam("exec_amt_krw"		,del_comma(f.amt.value)		);
// 		GridObj.SetParam("exec_flag"		,f.exec_flag.value    		);
// 	    GridObj.SetParam("ctrl_code"		,f.ctrl_code.value    		);
// 		GridObj.SetParam("attach_no"		,f.attach_no.value    		);
// 		GridObj.SetParam("pay_terms"		,G_PAY_TERMS          		);
// 		GridObj.SetParam("subject"			,f.subject.value      		);
// 		GridObj.SetParam("remark"			,f.remark.value       		);
// 		GridObj.SetParam("ttl_item_qty"		,G_TTL_ITEM_QTY       		);
// 		GridObj.SetParam("cur"				,G_CUR                		);
// 		GridObj.SetParam("sign_status"		,f.sign_status.value  		);
// 		GridObj.SetParam("approval_str"		,approval_str         		);
// 		GridObj.SetParam("valid_from_date"	,G_VALID_FROM_DATE    		);
// 		GridObj.SetParam("valid_to_date"	,G_VALID_TO_DATE      		);
// 		GridObj.SetParam("create_type"		,G_CREATE_TYPE        		);
// 		GridObj.SetParam("DP_INFO"     		,form1.ar_val.value  		);
// 		GridObj.SetParam("ctrl_person_id" 	,form1.ctrl_person_id.value );
// 		GridObj.SetParam("pr_type" 			,pr_type 					);
// 		GridObj.SetParam("po_type"			,f.po_type.value    		);
// 		setAhead_flag(f.ahead_flag_header);
// 		GridObj.SetParam("ahead_flag"		,f.ahead_flag.value    		);
<%-- 		GridObj.SetParam("req_type"		,"<%=REQ_TYPE%>"    		); --%>
// 		// 변경기안서 작성인 경우 기안번호를 공백("") 처리하여 신규생성하도록 한다.
// 		// 변경기안서 작성인 경우 이전 기안번호를 현재의 기안번호로 저장한다.
<%-- 		if ("E" == "<%=screenMode%>") { --%>
// 			GridObj.SetParam("exec_no"	,"");
<%-- 			GridObj.SetParam("bf_exec_no"	,"<%=exec_no%>"); --%>
// 		} else {
<%-- 			GridObj.SetParam("exec_no"	,"<%=exec_no%>"); --%>
// 			GridObj.SetParam("bf_exec_no"	,"");
// 		}
		
// 		GridObj.SetParam("del_pr_data"	,del_pr_data	.substring(0, del_pr_data.length-1)   		);
// 		GridObj.SetParam("remain_pr_data"	,remain_pr_data	.substring(0, remain_pr_data.length-1)   	);
// 		GridObj.SetParam("gridModifyFlag"	,gridModifyFlag    			);
// 		GridObj.SetParam("pre_exec_no"	,IsTrimStr(f.pre_exec_no.value)    		);

// 		GridObj.SetParam("dely_terms"		,form1.dely_terms.value);
// 		GridObj.SetParam("delay_remark"		,form1.delay_remark.value);
// 		GridObj.SetParam("warranty_month"		,form1.warranty_month.value);
		
// 		GridObj.SetParam("dely_to_location"		,form1.dely_to_location.value);
// 		GridObj.SetParam("dely_to_address"		,form1.dely_to_address.value);
// 		GridObj.SetParam("dely_to_user"		,form1.dely_to_user.value);
// 		GridObj.SetParam("dely_to_phone"		,form1.dely_to_phone.value);

// 		// 수정인경우 삭제된 데이터와 삭제되지 않고 남아있던 데이터-수정되지 않았는 데이터는 STATUS = 'D' 상태로 인서트 - PR_SEQ 존재
// 		// 하나라도 수정시 그리드에 있는 전 로우를 새롭게 인서트 이때 PR_SEQ 는 없다. 기안결재 완료시에 생성된다. (기안결재가 없으므로 필요)
// // 		if(gridModifyFlag == "Y"){
// // 			for(var i = 0; i < GridObj.GetRowCount(); i++){
// // 				GridObj.SetCellValue("PR_SEQ", i, "");
// // 			}
// // 		}
// 		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
// 		GridObj.SendData(G_SERVLETURL, "ALL", "ALL");
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

		if (document.form1.attach_gubun.value == "wise"){
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

function setDpInfo(){
	var ar_val = "";
	var sub_item = "";
	var S_item_cnt = 0 ;
	var I_item_cnt = 0 ;
	var S_dp_cnt = 0;
	var I_dp_cnt = 0;
	var rowCount = GridObj2.GetRowCount();
	for( i = 0 ; i < rowCount ; i++ ){
		ar_val +=  changeSpace(GridObj2.GetCellValue("DP_SEQ"			  ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("DP_TYPE"          ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("DP_PERCENT"       ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("DP_AMT"           ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("DP_PAY_TERMS"     ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("DP_PAY_TERMS_TEXT",i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("FIRST_DEPOSIT"    ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("FIRST_PERCENT"    ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("CONTRACT_DEPOSIT" ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("CONTRACT_PERCENT" ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("MENGEL_DEPOSIT"   ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("MENGEL_PERCENT"   ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("DP_DIV"   		  ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("DP_CODE"   		  ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("DP_PLAN_DATE" 	  ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("FIRST_METHOD" 	  ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("CONTRACT_METHOD"  ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("MENGEL_METHOD" 	  ,i)) + "||";
		ar_val +=  changeSpace(GridObj2.GetCellValue("PRE_CONT_YN" 	  ,i)) + "||$";

// 		if(GridObj2.GetCellValue("DP_DIV",i) == "S"){
// 			S_dp_cnt++;
// 		}else if(GridObj2.GetCellValue("DP_DIV",i) == "I"){
// 			I_dp_cnt++
// 		}

	}
/*
	if(rowCount == 0){
		return "empty";
	}
*/
// 	for(var i=0; i<GridObj.GetRowCount(); i++){
// 		sub_item = GridObj.GetCellValue("ITEM_NO", i).substring(0,2);
// 		if(sub_item == "HW" || sub_item == "SW" || sub_item == "CT" || sub_item == "MA"){
// 			I_item_cnt++;
// 		}else {
// 			S_item_cnt++
// 		}
// 	}

	// 용역(S)일경우, 장비(I)일경우
// 	if(S_item_cnt > 0){
// 		if(S_dp_cnt == 0){
// 			return "S_empty";
// 		}
// 	}

// 	if(I_item_cnt > 0){
// 		if(I_dp_cnt == 0){
// 			return "I_empty";
// 		}
// 	}

	return ar_val;
}
function changeSpace(val){
	var re_val = val==""?" ":val;
	return re_val;
}
/*
	파일첨부 팝업에서 받아오는 화면
*/
// function setAttach(attach_key, arrAttrach, attach_count)
// {
// 	var f = document.forms[0];
//     f.attach_no.value = attach_key;
//     f.attach_count.value = attach_count;
    
//     $("#attach_no").val(attach_key);
//     $("#attach_count").val(attach_count);
// }
//구매담당
function SP0216_Popup()
{
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0216&function=SP0216_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function SP0216_getCode(ls_ctrl_code, ls_ctrl_name)
{
	document.forms[0].ctrl_code.value = ls_ctrl_code;
	document.forms[0].user_name.value = ls_ctrl_name;
}

//담당자
function SP0023_Popup() {
	var left = 0;
	var top = 0;
	var width = 570;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0023&function=SP0023_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=/&desc=담당자ID&desc=담당자명";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function  SP0023_getCode(USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION) {

	document.forms[0].ctrl_code.value = USER_ID;
	document.forms[0].ctrl_name.value = USER_NAME_LOC;
	document.forms[0].ctrl_person_id.value = USER_ID;
	document.forms[0].ctrl_person_name.value = USER_NAME_LOC;

}
function openDPinfo(dp_div){
	var wise 		= GridObj;
    var item_amt 	= parseFloat(del_comma(document.forms[0].amt.value));
    var total_amt = item_amt;
    var dp_type 	= ""//wise.GetCellValue("PAY_TERMS_HD"		,0);
	var rowCount 	= wise.GetRowCount();
	var cur = "";
	var S_item_cnt = 0;	// 용역품목수
	var S_item_amt = 0; // 용역공급가액 합
	var I_item_cnt = 0;	// 물품품목수
	var I_item_amt = 0; // 물품공급가액 합
	var S_dp_type  = "";
	var I_dp_type  = "";
	var no_item_code_cnt = 0; // 품목코드가 없는 아이템 수
	var item_gbn = ""; // 품목, 용역 구분.

	var default_amt = 0;

	var sub_item = "";
	
	var first_method = "";
	var contract_method = "";
	var mengel_method = "";
	
	for( i = 0 ; i < rowCount ; i++ ){
		//item_amt += parseFloat(wise.GetCellValue("ITEM_AMT",i));
		cur 	  	= wise.GetCellValue("CUR",i);
		if(wise.GetCellValue("ITEM_NO",i) == ""){
			no_item_code_cnt++;
			continue;
		}
		sub_item	= wise.GetCellValue("ITEM_NO",i).substring(0, 2);
		item_gbn	= wise.GetCellValue("ITEM_GBN",i);
		<%//TODO SUB_ITEM에 해당하는 품목만 품목으로 처리한다.%>
		if(item_gbn == "I"){
			I_item_cnt++;
			I_item_amt += parseInt(wise.GetCellValue("ITEM_AMT",i) == "" ? "0" : wise.GetCellValue("ITEM_AMT",i));
			for(var k=0; k<GridObj2.GetRowCount(); k++){
				if(GridObj2.GetCellValue("DP_DIV", k) == "I"){
					I_dp_type = GridObj2.GetCellValue("DP_TYPE", k);
					break;	
				}				
			}
		}else {
			S_item_cnt++;
			S_item_amt += parseInt(wise.GetCellValue("ITEM_AMT",i) == "" ? "0" : wise.GetCellValue("ITEM_AMT",i));
			for(var k=0; k<GridObj2.GetRowCount(); k++){
				if(GridObj2.GetCellValue("DP_DIV", k) == "S"){
					S_dp_type = GridObj2.GetCellValue("DP_TYPE", k);
					break;	
				}
				
			}
		}
	}

// 	if(no_item_code_cnt == 0){
// 		if(dp_div == "S" && S_item_cnt ==0){
// 			alert("용역 품목이 없습니다.");
// 			return;
// 		}

// 		if(dp_div == "I" && I_item_cnt ==0){
// 			alert("물품 품목이 없습니다.");
// 			return;
// 		}
// 	}

	// 용역대금지불금액(S) + 	장비대금지불(I) = 기안금액
	var I_amt = 0;
	var S_amt = 0;
	if(document.getElementById('pre_cont_seq').value == ''){	//변경계약이 아닐경우 대급지급 지준으로 DP_AMT처리를 한다.
		for(var i = 0; i < GridObj2.GetRowCount(); i++){
			if(GridObj2.GetCellValue("DP_DIV", i) == "I"){
				I_amt += parseFloat(GridObj2.GetCellValue("DP_AMT", i));
			}else if(GridObj2.GetCellValue("DP_DIV", i) == "S"){
				S_amt += parseFloat(GridObj2.GetCellValue("DP_AMT", i));
			}
		}
	}else{
		for(var i = 0; i < GridObj.GetRowCount(); i++){
			if(GridObj.GetCellValue("ITEM_GBN", i) == "I"){
				I_amt += parseFloat(GridObj.GetCellValue("ITEM_AMT", i));
			}else if(GridObj.GetCellValue("ITEM_GBN", i) == "S"){
				S_amt += parseFloat(GridObj.GetCellValue("ITEM_AMT", i));
			}
		}		
	}
	if(GridObj2.GetRowCount() > 0){
		first_method = GridObj2.GetCellValue("FIRST_METHOD",0);
		contract_method = GridObj2.GetCellValue("CONTRACT_METHOD",0);
		mengel_method = GridObj2.GetCellValue("MENGEL_METHOD",0);	
	}
	
	dp_type = dp_div == "I" ? I_dp_type :  S_dp_type;
	if(dp_div == "I"){
		item_amt -= S_amt;
	}else if(dp_div == "S"){
		item_amt -= I_amt;
	}
	var screenMode = "<%=screenMode%>";
	var mode = screenMode == "R" ? "popup" : "";
	var pre_cont_seq = document.getElementById('pre_cont_seq').value;

    url = "/kr/dt/app/app_pp_ins3.jsp?exec_amt="+item_amt+"&dp_type="+dp_type+"&cur="+cur+"&dp_div="+dp_div+"&mode="+mode+"&pre_cont_seq="+pre_cont_seq+"&first_method="+first_method+"&contract_method="+contract_method+"&mengel_method="+mengel_method+"&total_amt="+total_amt;
    window.open(url,"app_pp_ins2","left=0,top=0,width=850,height=500,resizable=yes,scrollbars=yes");
}
function valid_from_date(year,month,day,week) {
	var f0 = document.forms[0];
	f0.valid_from_date.value=year+month+day;
}
function valid_to_date(year,month,day,week) {
	var f0 = document.forms[0];
	f0.valid_to_date.value=year+month+day;
}
function changeContract(){
	if(document.getElementById("po_type").value == "U"){
		document.forms[0].contract_flag.value = "Y";
		alert("단가계약인 경우 계약은 필수입니다.");
	}
	
	var contract_flag = document.forms[0].contract_flag.value;
	var rowCount = GridObj.GetRowCount();
	for( i = 0 ; i < rowCount ; i++ ){
// 		GridObj.SetComboSelectedHiddenValue("CONTRACT_FLAG", i, contract_flag);
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("CONTRACT_FLAG")).setValue(contract_flag);
	}
}
function goPrPage(){
	var img_pr_no = document.forms[0].pr_no.value;
    window.open("/kr/dt/pr/pr1_bd_dis1.jsp?pr_no="+img_pr_no,"pr1_bd_dis1","left=0,top=0,width=900,height=700,resizable=yes,scrollbars=yes");
}

function setAhead_flag(obj){
	if(obj.checked){
		document.forms[0].ahead_flag.value='Y';
	}else{
		document.forms[0].ahead_flag.value='N'
	}
}

var modifyPrNo	= "";
var modifyPrSeq = "";
var modifyCur 	= "";
var modifySourcingNo	= "";
var modifySeq	;
var setCatalogCnt = 0;
var gridModifyFlag = "N";
function Catalog(){

	var selectedCnt = 0;
	for(var i = 0; i < GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			selectedCnt++;
			modifyPrNo 	= GridObj.GetCellValue("PR_NO", i);
			modifyPrSeq = GridObj.GetCellValue("PR_SEQ", i);
			modifyCur 	= GridObj.GetCellValue("CUR", i);
			modifySoucingNo	= GridObj.GetCellValue("SOURCING_NO", i);
			modifySeq = i;
		}
	}

	if(selectedCnt == 0){
		alert("수정하실 품목을 선택해주십시요.");
		return;
	}

	if(selectedCnt > 1){
		alert("수정은 한건씩 가능합니다.");
		return;
	}


// 	setCatalogIndex(G_C_INDEX);
// 	url = "/kr/catalog/cat_pp_lis_frame.jsp?INDEX=" + getAllCatalogIndex() ;
// 	CodeSearchCommon(url,"INVEST_NO",0,0,"950","530");
	

	setCatalogIndex("ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:MAKER_CODE:MAKER_NAME:BASIC_UNIT");
	url = "/kr/catalog/cat_pp_lis_frame.jsp?INDEX=" + getAllCatalogIndex() ;
	CodeSearchCommon(url,"CATALOG",0,0,"840","450");
}

// function setCatalog(arr){
function setCatalog(  itemNo
					, descriptionLoc
					, specification
					, makerCode
					, ctrlCode
					, qty
					, itemGroup
					, delyToAddress
					, unitPrice
					, ktgrm
					, makerName
					, basicUnit
					, materialType){
	if(setCatalogCnt == 0){
		//GridObj.DeleteRow(modifySeq);
		//setCatalogCnt++;
	}


	var wise = GridObj;

	var ITEM_NO = itemNo;

	var dup_flag = false;
	for(var i = 0;i < wise.GetRowCount();i++)
	{
		if(ITEM_NO == GD_GetCellValueIndex(GridObj,i,INDEX_ITEM_NO))
		{
			dup_flag = true;
		}
	}

	var iMaxRow = wise.GetRowCount();
	GridObj.AddRow();
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SELECTED,			"0" );
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PO_VENDOR_CODE		,wise.GetCellValue("PO_VENDOR_CODE", modifySeq));
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PR_NO				,wise.GetCellValue("PR_NO", modifySeq));
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PR_SEQ				,wise.GetCellValue("PR_SEQ", modifySeq));
	
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_RFQ_NO				,wise.GetCellValue("RFQ_NO", modifySeq));
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_RFQ_COUNT			,wise.GetCellValue("RFQ_COUNT", modifySeq));
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_RFQ_SEQ				,wise.GetCellValue("RFQ_SEQ", modifySeq));
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_QTA_NO				,wise.GetCellValue("QTA_NO", modifySeq));
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_QTA_SEQ				,wise.GetCellValue("QTA_SEQ", modifySeq));
// 	GridObj.SetComboSelectedHiddenValue("INSURANCE"			, iMaxRow, wise.GetCellValue("INSURANCE", modifySeq));
// 	GridObj.SetComboSelectedHiddenValue("CONTRACT_FLAG"		, iMaxRow, wise.GetCellValue("CONTRACT_FLAG", modifySeq));

	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ITEM_NO				,itemNo);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_DESCRIPTION_LOC		,descriptionLoc);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SPECIFICATION		,specification);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_MAKER_NAME			,makerName);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_MAKER_CODE			,makerCode);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_UNIT_MEASURE		,basicUnit);

	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ORIGIN_PR_SEQ		,modifyPrSeq);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CUR					,modifyCur);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SOURCING_NO			,modifySoucingNo);
// 	GridObj.SetCellHiddenValue("SOURCING_NO", iMaxRow, modifySourcingNo);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_RD_DATE				,wise.GetCellValue("RD_DATE", modifySeq));
	
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SPECIFICATION  		,wise.GetCellValue("SPECIFICATION", modifySeq));
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_MAKER_NAME  	 	,wise.GetCellValue("MAKER_NAME", modifySeq));
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_MAKER_CODE  	 	,wise.GetCellValue("MAKER_CODE", modifySeq));
	//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_QTY  			 ,wise.GetCellValue("QTY", modifySeq));	
	//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PR_UNIT_PRICE  ,wise.GetCellValue("PR_UNIT_PRICE", modifySeq));
	//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PR_AMT         ,wise.GetCellValue("PR_AMT", modifySeq));	
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CUSTOMER_PRICE 		,wise.GetCellValue("CUSTOMER_PRICE", modifySeq));
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_S_ITEM_AMT		 	,wise.GetCellValue("S_ITEM_AMT", modifySeq));
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_VENDOR_NAME	 		,wise.GetCellValue("VENDOR_NAME", modifySeq));
		
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CLASS_GRADE			,wise.GetCellValue("CLASS_GRADE", modifySeq));
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CLASS_SCORE			,wise.GetCellValue("CLASS_SCORE", modifySeq));
// 	GridObj.SetComboSelectedHiddenValue("PLANT_CODE"				, iMaxRow, "");
// 	GridObj.SetComboSelectedHiddenValue("ROLE_CODE"					, iMaxRow, "");	

	gridModifyFlag = "Y";

}

function getItemValue(){

}

var del_pr_data = "";
function doDelete(){

	var gridObj = GridObj;
	var remainPrNoCnt = 0;
	var selectedCnt = 0;
	for(var i = gridObj.GetRowCount()-1 ; i >= 0; i--){
		if(gridObj.GetCellValue("SELECTED", i) == "1"){
			selectedCnt++;
			remainPrNoCnt = 0;
			del_pr_no = gridObj.GetCellValue("PR_NO", i);
			for(var j = 0; j < gridObj.GetRowCount(); j++){
				if(gridObj.GetCellValue("SELECTED", j) == "0"){
					if(del_pr_no == gridObj.GetCellValue("PR_NO", j)){
						remainPrNoCnt++;
						break;
					}
				}
			}

			if(remainPrNoCnt == 0){
				alert("삭제하실 수 없습니다.");
				return;
			}

			if(gridObj.GetCellValue("PR_SEQ", i) != ""){
				del_pr_data += gridObj.GetCellValue("PR_NO", i) + "-" + gridObj.GetCellValue("PR_SEQ", i) + ",";
			}

			gridObj.DeleteRow(i);
			gridModifyFlag = "Y";


		}
	}

	if(selectedCnt == 0){
		alert("삭제할 품목을 선택해주십시요.");
		return;
	}


	var tot_pr_amt 	= 0;
	var tot_item_amt= 0;

	for(var i = 0; i < gridObj.GetRowCount(); i++){
		tot_pr_amt 		+= parseFloat(gridObj.GetCellValue("PR_AMT", i));
		tot_item_amt 	+= parseFloat(gridObj.GetCellValue("ITEM_AMT", i));
	}


	document.forms[0].sale_amt.value = add_comma(RoundEx(tot_pr_amt - tot_item_amt, 3), 2);
	document.forms[0].sale_per.value = tot_pr_amt == 0 ? 0.00 : add_comma(RoundEx((tot_pr_amt - tot_item_amt) / tot_pr_amt*100, 3), 2);
}

	//개발자 이름
	function SP0272_Popup(vendor_code) {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0272&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=buyer_code%>&values="+vendor_code;
		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function  SP0272_getCode(ls_human_no, ls_name_loc) {
		GD_SetCellValueIndex(GridObj, G_CUR_ROW, INDEX_HUMAN_NAME_LOC, G_IMG_ICON + "&" + ls_name_loc + "&" + ls_human_no, "&");
	}

	function goIReport(){

		window.open("/kr/order/bpo/po3_pp_dis2.jsp"+"?exec_no=<%=exec_no%>","newWin","width="+screen.availWidth+",height=690,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
		//window.open("/kr/order/bpo/order_view.jsp"+"?po_no=","newWin","width="+screen.availWidth+",height=690,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");

	}

	function openSCMSProject(PJT_CODE, CON_NO, CON_DGR, CUST_CODE){
		return;
		<%Configuration conf = new Configuration();
			String scmsUrl = conf.get("wise.scms.url");%>
		var vURL = "<%=scmsUrl%>/iFrame?Class=com.ibks.mn.SCMPjtDetail&PAGE_NAME=CONSULT_DETAIL&PJT_CODE=" + PJT_CODE + "&CON_NO=" + CON_NO + "&CON_DGR=" + CON_DGR + "&CUST_CODE=" + CUST_CODE;
  		//2010.12.08 swlee modify
		//window.open (vURL , "SCMSPjt", "left=0, top=0,width=900,height=600, toolbar=no, menubar=no, status=no, scrollbars=no, resizable=no");

	}

	function openPreExec() {
		var pre_exec_no = document.forms[0].pre_exec_no.value;
		if (pre_exec_no == "") return;

        window.open("/kr/dt/app/app_pp_dis4_approval.jsp?exec_no="+pre_exec_no+"&doc_status=N&doc_no="+pre_exec_no+"&doc_type=EX&doc_seq=0&sign_enable=&attach_no=&sign_path_seq=","PreExecWin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
	}
	function save(){
		
	}

	//기안구분 수정시 연간단가계약일 경우 계약은 필수로 처리한다.
	function changePoType(){
		if(document.getElementById("po_type").value == 'U'){
			if(document.getElementById("contract_flag").value != 'Y'){
				document.getElementById("contract_flag").value = 'Y';
				changeContract();
			}
		} 
	}
//-->
</Script>

<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,단가,금액,단가,금액,단가,금액,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");
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
   	JavaCall("t_imagetext", rowId, cellInd);
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
var tmpValue = 0;
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
//    	tmpValue =  GridObj.cells(rowId, cellInd).getValue();
        return true;
    } else if(stage==1) {
    	tmpValue =  GridObj.cells(rowId, cellInd).getValue();
    } else if(stage==2) {
    	JavaCall("t_insert", rowId, cellInd, tmpValue);	
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
        opener.doSelect();
        window.close();
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


//===================================================== Grid2 Default Script =====================================================
	


//그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
//이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function GridObj2_doOnRowSelected(rowId,cellInd){}

//그리드 셀 ChangeEvent 시점에 호출 됩니다.
//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function GridObj2_doOnCellChange(stage,rowId,cellInd){
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

//서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
//서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function GridObj2_doSaveEnd(obj){
	var messsage = obj.getAttribute("message");
	var mode     = obj.getAttribute("mode");
	var status   = obj.getAttribute("status");

	document.getElementById("message").innerHTML = messsage;

	myDataProcessor.stopOnError = true;

// 	if(dhxWins != null) {
// 		dhxWins.window("prg_win").hide();
// 		dhxWins.window("prg_win").setModal(false);
// 	}

// 	if(status == "true") {
// 		alert(messsage);
		
// 		doQuery();
// 	}
// 	else {
// 		alert(messsage);
// 	}
	
// 	if("undefined" != typeof JavaCall) {
// 		JavaCall("doData");
// 	} 

	return false;
}

//엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
//복사한 데이터가 그리드에 Load 됩니다.
//!!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function GridObj2_doExcelUpload() {
	var bufferData = window.clipboardData.getData("Text");
	
	if(bufferData.length > 0) {
		GridObj.clearAll();
		GridObj.setCSVDelimiter("\t");
		GridObj.loadCSVString(bufferData);
	}
	
	return;
}

function GridObj2_doQueryEnd() {
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

function goAttach(attach_no){
	attach_file(attach_no,"IMAGE");
}

function setAttach(attach_key, arrAttrach, rowId, attach_count) {
	
	document.form1.attach_no.value = attach_key;
	document.form1.attach_no_count.value = attach_count;
}


</script>
</head>
<body onload="init();" bgcolor="#FFFFFF" text="#000000">

<s:header popup="true">
<!--내용시작-->

<form id="form1" name="form1" method="post">
	<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 시작--%>
	<input type="hidden" id="house_code" 	name="house_code" 		value="<%=info.getSession("HOUSE_CODE")%>"> 
	<input type="hidden" id="company_code" 	name="company_code" 	value="<%=info.getSession("COMPANY_CODE")%>"> 
	<input type="hidden" id="dept_code"	 	name="dept_code"	 	value="<%=info.getSession("DEPARTMENT")%>"> 
	<input type="hidden" id="req_user_id"  	name="req_user_id" 		value="<%=info.getSession("ID")%>">
	<input type="hidden" id="doc_type" 	 	name="doc_type" 		value="EX"> 
	<input type="hidden" id="fnc_name" 	 	name="fnc_name" 		value="getApproval">
	<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 종료--%>

	<input type="hidden" id="ar_val"		 name="ar_val"				> 
	<input type="hidden" id="dp_info"		 name="dp_info"				> 
<!-- 	<input type="hidden" id="attach_no"		 name="attach_no"			>  -->
	<input type="hidden" id="sign_status"	 name="sign_status"			>
	<input type="hidden" id="dp_change_flag" name="dp_change_flag"		value="N"> 
	<input type="hidden" id="exec_amt" 		 name="exec_amt" 			value="" size="20" class="input_data3" readonly> 
	<input type="hidden" id="ahead_flag"	 name="ahead_flag"			> 
	<input type="hidden" id="attach_gubun" 	 name="attach_gubun" 		value="body"> 
	<input type="hidden" id="att_mode" 		 name="att_mode" 			value=""> 
	<input type="hidden" id="view_type"	 	 name="view_type"	 		value=""> 
	<input type="hidden" id="file_type" 	 name="file_type" 			value=""> 
	<input type="hidden" id="tmp_att_no" 	 name="tmp_att_no" 			value=""> 
	<input type="hidden" id="attach_count" 	 name="attach_count" 		value=""> 
	<input type="hidden" id="approval_str" 	 name="approval_str" 		value=""> 
	<input type="hidden" id="pre_cont_seq" 	 name="pre_cont_seq" 		value="<%=pre_cont_seq%>">
	<input type="hidden" id="pre_cont_count" name="pre_cont_count"		value="<%=pre_cont_count%>">

	<input type="hidden" id="pr_data"  		name="pr_data" 		value="<%=pr_data%>">
	<input type="hidden" id="pr_type"  		name="pr_type" 		value="<%=PR_TYPE%>">
	<input type="hidden" id="exec_no"  		name="exec_no" 		value="<%=exec_no%>">
	<input type="hidden" id="editable" 		name="editable" 	value="<%=editable%>">
	<input type="hidden" id="bf_exec_no"  	name="bf_exec_no" 	value="">

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" align="left" class="title_page" vAlign="bottom"> 
				<span id="preferred_bidder"><%=("C".equals(screenMode)) ? "사전지원 완료" : (("R".equals(screenMode)) ? "사전지원 상세" : (("U".equals(screenMode))? "사전지원 수정" : (("E".equals(screenMode)) ? "변경기안생성" : "")))%></span>
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
		<tr>
			<td width="16%" class="title_td">
				생성일자
			</td>
			<td width="34%" class="data_td" colspan="3">
				<input type="text" id="add_date" name="add_date" class="input_data2" readOnly>
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>		
		<tr>
			<td width="16%" class="title_td">
				사전지원명
			</td>
			<td width="34%" class="data_td" colspan="3">
				<input type="text" id="subject" name="subject" style="width: 98%" <%if ("R".equals(screenMode)) {%> class="input_data2" readOnly <%} else {%> class="input_re" <%}%> onKeyUp="return chkMaxByte(500, this, '기안명');" <%=("B".equals(REQ_TYPE)) ? "readOnly":""%>>
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>		
		<tr>
			<td class="title_td">
				담당자
			</td>
			<td class="data_td" colspan="3">
				<b>
					<input type="text" id="ctrl_person_id" name="ctrl_person_id" size="8" readOnly value="<%=info.getSession("ID")%>"> 
					<input type="text" id="ctrl_person_name" name="ctrl_person_name" size="10" class="input_data2" readOnly  value="<%=info.getSession("NAME_LOC")%>">
				</b> 
				<input type="hidden" id="ctrl_code" name="ctrl_code" size="5" maxlength="5" class="inputsubmit" readOnly> 
				<input type="hidden" id="ctrl_name" name="ctrl_name" size="25" class="input_data2" readOnly> 
				<input type="hidden" id="wbs_info" name="wbs_info" style="width: 100%;" class="input_data2" readOnly> 
				<select id="exec_flag" name="exec_flag" class="inputsubmit" style="display: none;">
					<%=LB_EXEC_FLAG%>
				</select>
			</td>
			<td class="title_td" style="display: none;">
				요청자
			</td>
			<td class="data_td" style="display: none;">
				<input type="text" id="add_user_id" name="add_user_id" size="10" value="20" readOnly class="input_data2"> 
				<input type="text" id="add_user_name" name="add_user_name" size="20" maxlength="12" value="" readOnly class="input_data2" style="width: 50%;">
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>		
		<tr>
			<td class="title_td">
				선정업체
			</td>
			<td class="data_td">
				<input type="text" id="vendor_code" name="vendor_code" size="10" class="input_data2" readOnly value=""> 
				<input type="text" id="vendor_name" name="vendor_name" size="20" class="input_data2" readOnly value="" style="width: 75%;">
			</td>
			<td class="title_td">
				확인금액 (VAT 포함)
			</td>
			<td class="data_td"><input type="text" id="amt" name="amt" size="20" value="" readOnly class="input_data2"></td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>		
		<tr style="display: none">
			<td class="title_td">
				절감액
			</td>
			<td class="data_td">
				<input type="text" id="sale_amt" name="sale_amt" size="20" value="" readOnly class="input_data2">
			</td>
			<td class="title_td">
				절감율
			</td>
			<td class="data_td">
				<input type="text" id="sale_per" name="sale_per" size="6" value="" readOnly class="input_data2">%
			</td>
		</tr>
		<tr>
			<td class="title_td">
				구분
			</td>
			<td class="data_td">
				<select id="po_type" name="po_type" <%if ("R".equals(screenMode)) {%> class="inputsubmit" <%} else {%> class="input_re" <%}%> <%if ("R".equals(screenMode)) {%> disabled <%}%> onChange="changePoType();">
					<%=LB_PO_TYPE%>
				</select>
			</td>
			<td class="title_td">
				계약여부
			</td>
			<td class="data_td">
				<input type="checkbox" id="ahead_flag_header" name="ahead_flag_header" onChange="setAhead_flag(this);" <%if ("R".equals(screenMode)) {%> disabled <%}%> style="display: none;"> 
					<select name="contract_flag" <%if ("R".equals(screenMode)) {%> class="inputsubmit" <%} else {%> class="input_re" <%}%> onchange="changeContract()" <%if ("R".equals(screenMode)) {%> disabled <%}%>>
					<option value="">선택</option>
					<option value="N">N</option>
					<option value="Y">Y</option>
				</select>
			</td>
		</tr>
		<tr style="display: none;">
			<td class="title_td">
				요청명
			</td>
			<td class="data_td">
				<input type="text" id="pr_subject" name="pr_subject" class="input_data2" size="40" readOnly>
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>		
		<tr>
			<td width="15%" class="title_td">
				대금지불
			</td>
			<td width="35%" class="data_td" colspan="3">
				<a href="javascript:openDPinfo('I');"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"></a> 
				<input type="hidden" id="i_dp_count" 		name="i_dp_count" 		size="2" value="" readOnly class="input_data2"> 
				<input type="text" 	 id="i_dp_type_text" 	name="i_dp_type_text" 	size="14" value="" readOnly class="input_data2"> 
				<input type="hidden" id="i_dp_type" 		name="i_dp_type" 		size="3" value="" readOnly class="input_data2"> 
				<input type="hidden" id="i_insurance" 		name="i_insurance" 		size="3" value="Y" readOnly class="input_data2"> 
				<input type="text"   id="i_pay_amt" 		name="i_pay_amt" 		class="input_data2" readOnly>
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<input type="hidden" id="pre_exec_no" name="pre_exec_no">
		<tr>
			<td width="15%" class="title_td">
				인도조건
			</td>
			<td width="35%" class="data_td">
				<select id="dely_terms" name="dely_terms" <%if ("R".equals(screenMode)) {%> class="input_re" <%} else {%> class="input_re" <%}%> <%if ("R".equals(screenMode)) {%> disabled <%}%>>
					<%=DELY_TERMS%>
				</select>
			</td>
			
			<td class="title_td">
				계약기간
			</td>
			<td class="data_td">
				<%
					if ("R".equals(screenMode)) {
				%> 
				<input type="text" id="valid_from_date" name="valid_from_date" size="10" maxlength="10" value="" class="input_data2" readOnly> 
				~ 
				<input type="text" id="valid_to_date" name="valid_to_date" size="10" maxlength="10" value="" class="input_data2" readOnly> 
				<%
					} else {
				%> 
				<s:calendar id="valid_from_date" default_value="" 	format="%Y/%m/%d"/>
				~
				<s:calendar id="valid_to_date" default_value="" 	format="%Y/%m/%d"/> 
				<%
				 	}
				%>
			</td>			
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>		
		<tr>
			<td width="15%" class="title_td">
				납품장소
			</td>
			<td class="data_td" colspan="">
				<input type="text" id="dely_to_location" name="dely_to_location" style="width: 93%" onKeyUp="return chkMaxByte(80, this, '납품장소');" <%="R".equals(screenMode) ? "class='input_data2' readonly" : "class='inputsubmit'"%>>
			</td>
			<td width="15%" class="title_td">
				납품주소
			</td>
			<td class="data_td">
				<input type="text" id="dely_to_address" name="dely_to_address" style="width: 93%" onKeyUp="return chkMaxByte(100, this, '납품주소');" <%="R".equals(screenMode) ? "class='input_data2' readonly" : "class='inputsubmit'"%>>
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>		
		<tr>
			<td width="15%" class="title_td">
				수령인
			</td>
			<td class="data_td" colspan="">
				<input type="text" id="dely_to_user" name="dely_to_user" style="width: 30%" onKeyUp="return chkMaxByte(40, this, '수령인');" <%="R".equals(screenMode) ? "class='input_data2' readonly" : "class='inputsubmit'"%>>
			</td>
			<td width="15%" class="title_td">
				수령인연락처
			</td>
			<td class="data_td">
				<input type="text" id="dely_to_phone" name="dely_to_phone" style="width: 35%" onKeyUp="return chkMaxByte(13, this, '수령인연락처');" <%="R".equals(screenMode) ? "class='input_data2' readonly" : "class='inputsubmit'"%> style="ime-mode: disabled" onKeyPress="checkNumberFormat('[0-9]');">
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
			<td height="30" align="left" class="c_data_1">(VAT 포함)</td>
			<td height="30" align="right">
				<TABLE cellpadding="0">
					<TR>
						<%
							if ("R".equals(screenMode)) {
						%>
						<TD><script language="javascript">btn("javascript:self.close();","닫 기")   </script>
						</TD>
						<%
							} else {
						%>
						<TD><script language="javascript">btn("javascript:Catalog('CATALOG')","카탈로그")    </script>
						</TD>
						<TD><script language="javascript">btn("javascript:doDelete()","삭제")   </script>
						</TD>
						<TD><script language="javascript">btn("javascript:Approval('T')","임시저장")   </script>
						</TD>
						<%
							if (sign_use_yn) {
						%>
						<TD><script language="javascript">btn("javascript:Approval('P')","완료요청") </script>
						</TD>
						<%
							} else {
						%>
						<TD><script language="javascript">btn("javascript:Approval('E')","작성완료") </script>
						</TD>
						<%
							}
						%>
						<!-- 저장 버튼 추가 -->
						<!-- 			<TD><script language="javascript">btn("javascript:save();",7,"저 장")   </script></TD> -->
						<TD><script language="javascript">btn("javascript:self.close();","닫 기")   </script>
						</TD>
						<%
							}
						%>
					</TR>
				</TABLE>
			</td>
		</tr>
	</table>
<s:grid screen_id="AR_001_1" grid_obj="GridObj" grid_box="gridbox"/>
<div id="gridbox_1" name="gridbox_1" width="100%" style="background-color:white; display: none; "></div>	
	</br>
	
	
	
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="title_td">
				특기사항
			</td>
			<td colspan="3" class="data_td" style="width: 98%; height: 150px;">
				<textarea id="remark" name="remark" class="inputsubmit" rows="5" style="width: 98%;height: 145px;" onKeyUp="return chkMaxByte(1000, this, '특기사항');"></textarea>
			</td>
		</tr>
   		<tr>
   			<td width="15%" class="title_td">첨부파일</td>
			<td class="data_td" colspan="3">
				<table>
					<tr>
						<td>
							<script language="javascript">btn("javascript:goAttach($('#attach_no').val())", "<%=text.get("AR_001_1.TEXT01")%>")</script>	
						</td>
						<td>
							<input type="text" size="3" readOnly class="input_empty" value="0" name="attach_no_count" id="attach_no_count"/>
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
</form>

<%-- <script language="javascript">rMateFileAttach('S','C','EX',form1.attach_no.value);</script> --%>

</s:header>

<s:footer/>
</body>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0"
	marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>



