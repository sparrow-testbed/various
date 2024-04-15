<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PO_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PO_004";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<%
    String inv_no          = JSPUtil.nullToEmpty(request.getParameter("po_no"));
	//발주구분 : 직발주(D), 품의발주(N), 메뉴얼발주(M), 카테고리 발주(C)
	String prm_po_type = JSPUtil.nullToEmpty(request.getParameter("po_type"));
	
    Object[] obj1 = {inv_no};
    SepoaOut value1 = ServiceConnector.doService(info, "PO_002", "CONNECTION", "getPoCreateInfo_2", obj1);
    SepoaFormater wf1 = new SepoaFormater(value1.result[0]);
    String dely_terms = "";
    String delay_remark = "";
    String warranty_month = "";
    String first_percent = "";
    String contract_percent = "";
    String mengel_percent = "";
    if(wf1.getRowCount() > 0) {
    	dely_terms = wf1.getValue("DELY_TERMS", 0);
    	delay_remark = wf1.getValue("DELAY_REMARK", 0);
    	warranty_month = wf1.getValue("WARRANTY_MONTH", 0);
    	first_percent = wf1.getValue("FIRST_PERCENT", 0);
    	contract_percent = wf1.getValue("CONTRACT_PERCENT", 0);
    	mengel_percent = wf1.getValue("MENGEL_PERCENT", 0);
    } 
%>


<%
        String user_id        	= info.getSession("ID");
        String house_code     	= info.getSession("HOUSE_CODE");
        String company_code   	= info.getSession("COMPANY_CODE");
        String ctrl_code      	= info.getSession("CTRL_CODE");
        String user_name	 	= info.getSession("NAME_LOC");
        String toDaysSo       	= SepoaDate.getShortDateString();
        String toDays         	= SepoaDate.getFormatString("yyyy/MM/dd");
		String VENDOR_CODE		= "";
		String VENDOR_NAME		= "";
		String SUBJECT			= "";
		String CTRL_CODE		= "";
		String PAY_TERMS		= "";
		String DELY_TERMS		= "";
		String PR_TYPE			= "";
		String PR_TYPE_CODE		= "";
		String ORDER_NO			= "";
		String CUR				= "";
		String EXEC_AMT_KRW		= "";
		String TAKE_USER_NAME	= "";
		String TAKE_USER_ID		= "";
		String TAKE_USER_DEPT				= "";	//검수담당자 부서코드
		String TAKE_USER_DEPT_NAME		= "";	//검수담당자 부서명
		String TAKE_USER_IN_PHONE		= "";	//검수담당자 내선번호
		String CTR_DATE			= "";
		String TAKE_TEL			= "";
		String REMARK			= "";
		String EXEC_NO			= "";
		String CTR_NO			= "";
        String PO_CREATE_DATE	= "";
		String ADD_USER_NAME	= "";
		String VENDOR_CP_NAME	= "";
        String VENDOR_MOBILE_NO = "";
        String VENDOR_EMAIL		= "";
        String CONTRACT_FROM_DATE	= "";
		String CONTRACT_TO_DATE		= "";
		String CONTRACT_NO			= "";
		String PO_TYPE				= "";
		String ATTACH_NO			= "";
		String SRC_FILE_NAME		= "";
		String TAKE_USER_CHANGE_FG  = "";
		
		String TAKE_USER_CHANGE_MSG = "";
		String RPT_GETFILENAMES      = "";

        String po_no          		= JSPUtil.nullToEmpty(request.getParameter("po_no"));
		if ("".equals(po_no)) po_no = JSPUtil.nullToEmpty(request.getParameter("doc_no"));
        Object[] obj = {po_no};
         SepoaOut value = ServiceConnector.doService(info, "PO_002", "CONNECTION", "getPoDetailHeader", obj);

		SepoaFormater wf = new SepoaFormater(value.result[0]);
		if(wf.getRowCount() > 0) {
			VENDOR_CODE		    = wf.getValue("VENDOR_CODE"	 	, 0);
			VENDOR_NAME		    = wf.getValue("VENDOR_NAME"	 	, 0);
			SUBJECT			    = wf.getValue("SUBJECT"	 		, 0);
			CTRL_CODE		    = wf.getValue("CTRL_CODE"    	, 0);
			PAY_TERMS		    = wf.getValue("PAY_TERMS_DESC" 	, 0);
			DELY_TERMS		    = wf.getValue("DELY_TERMS_DESC"	, 0);
			PR_TYPE			    = wf.getValue("PR_TYPE_DESC"	, 0);
			ORDER_NO			= wf.getValue("ORDER_NO"	 	, 0);
			CUR				    = wf.getValue("CUR"	 			, 0);
			EXEC_AMT_KRW		= wf.getValue("PO_TTL_AMT"		, 0);
			TAKE_USER_NAME	    = wf.getValue("TAKE_USER_NAME"  , 0);
			TAKE_USER_ID	    = wf.getValue("TAKE_USER_ID"  , 0);
			TAKE_USER_DEPT	    		= wf.getValue("TAKE_USER_DEPT"  , 0);
			TAKE_USER_DEPT_NAME	= wf.getValue("TAKE_USER_DEPT_NAME"  , 0);
			TAKE_USER_IN_PHONE	    = wf.getValue("TAKE_USER_IN_PHONE"  , 0);
			CTR_DATE			= wf.getValue("CTR_DATE"	 	, 0);
			TAKE_TEL			= wf.getValue("TAKE_TEL"	 	, 0);
			REMARK			    = wf.getValue("REMARK"    		, 0);
			EXEC_NO			    = wf.getValue("EXEC_NO"	 		, 0);
			CTR_NO			    = wf.getValue("CTR_NO"    		, 0);
			PO_CREATE_DATE		= SepoaString.getDateSlashFormat(wf.getValue("PO_CREATE_DATE"  , 0));
			ADD_USER_NAME		= wf.getValue("USER_NAME"		, 0);
			VENDOR_CP_NAME		= wf.getValue("VENDOR_CP_NAME"	, 0);
			VENDOR_MOBILE_NO    = wf.getValue("VENDOR_MOBILE_NO", 0);
			VENDOR_EMAIL		= wf.getValue("VENDOR_EMAIL"	, 0);
			CONTRACT_FROM_DATE	= wf.getValue("CONTRACT_FROM_DATE"	, 0);
			CONTRACT_TO_DATE    = wf.getValue("CONTRACT_TO_DATE"	, 0);
			PR_TYPE_CODE		= wf.getValue("PR_TYPE"				, 0);
			CONTRACT_NO			= wf.getValue("CONTRACT_NO"			, 0);
			PO_TYPE    			= wf.getValue("PO_TYPE"				, 0);
			ATTACH_NO    		= wf.getValue("ATTACH_NO"			, 0);
			SRC_FILE_NAME		= wf.getValue("SRC_FILE_NAME"   , 0);
			TAKE_USER_CHANGE_FG = wf.getValue("TAKE_USER_CHANGE_FG"			, 0);
			
			if(TAKE_USER_CHANGE_FG.equals("1")){
				TAKE_USER_CHANGE_MSG = "검수담당자가 인사이동으로 원소속점이 변경되어 연락처를 재확인 바랍니다.";
			}
			RPT_GETFILENAMES    = wf.getValue("RPT_GETFILENAMES"			, 0);
		}
		
		Map map = new HashMap();
		map.put("po_no"		, po_no);
		Map<String, Object> data = new HashMap();
		data.put("headerData"		, map);

		Object[] obj2 = {data};
		SepoaOut value2= ServiceConnector.doService(info, "PO_002", "CONNECTION", "getPoDetailLine", obj2);
		SepoaFormater wf2 = new SepoaFormater(value2.result[0]);
		
		//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
		String _rptName          = "020644/rpt_po_detail"; //리포트명
		StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
		String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
		String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
		String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
		//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
		
		//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
		_rptData.append(po_no);
		_rptData.append(_RF);
		_rptData.append(SUBJECT);
		_rptData.append(_RF);
		_rptData.append(VENDOR_CODE);
		_rptData.append(" ");
		_rptData.append(VENDOR_NAME);
		_rptData.append(_RF);
		_rptData.append(PO_CREATE_DATE);
		_rptData.append(_RF);
		_rptData.append(PAY_TERMS);
		_rptData.append(_RF);
		_rptData.append(DELY_TERMS);
		_rptData.append(_RF);
		_rptData.append(VENDOR_CP_NAME);
		_rptData.append(_RF);
		_rptData.append(VENDOR_MOBILE_NO);
		_rptData.append(_RF);
		_rptData.append(VENDOR_EMAIL);
		_rptData.append(_RF);
		_rptData.append(EXEC_AMT_KRW);
		_rptData.append(_RF);
		_rptData.append(TAKE_USER_NAME);
		_rptData.append(_RF);
		_rptData.append(TAKE_TEL);
		_rptData.append(" <C.RED><B>");
		_rptData.append(TAKE_USER_CHANGE_MSG);
		_rptData.append("</B></C>");
		_rptData.append(_RF);
		_rptData.append(TAKE_USER_DEPT_NAME);
		_rptData.append(_RF);
		_rptData.append(REMARK);
		_rptData.append(_RF);
		_rptData.append(RPT_GETFILENAMES);
		_rptData.append(_RF);
		
		_rptData.append(_RD);			
		if(wf2 != null) {
			if(wf2.getRowCount() > 0) { //데이타가 있는 경우
				for(int i = 0 ; i < wf2.getRowCount() ; i++){
					_rptData.append(wf2.getValue("ITEM_NO", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("DESCRIPTION_LOC", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("SPECIFICATION", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("RD_DATE", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("VENDOR_RD_DATE", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("UNIT_MEASURE", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("PO_QTY", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("CUR", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("UNIT_PRICE", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("ITEM_AMT", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("DELY_TO_ADDRESS", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("EXEC_NO", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("REMARK", i));
					_rptData.append(_RL);			
				}
			}
		}
		//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////
%>


<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>
<script language="javascript">
window.resizeTo("1024","768");
</script>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript">

var G_CUR_ROW = -1;

var mode;
var G_HOUSE_CODE   = "<%-- <%=house_code%> --%>";
var po_no = "<%=inv_no%>";
var G_COMPANY_CODE = "<%-- <%=company_code%> --%>";
var pr_type = "<%=PR_TYPE_CODE%>";
var IDX_SEL					;
var IDX_ITEM_NO				;
var IDX_DESCRIPTION_LOC		;
var IDX_RD_DATE				;
var IDX_UNIT_MEASURE		;
var IDX_PO_QTY			    ;
var IDX_UNIT_PRICE		    ;
var IDX_ITEM_AMT			;
var IDX_PR_UNIT_PRICE	    ;
var IDX_PR_AMT			    ;
var IDX_DOWN_AMT			;
var IDX_PR_NO			    ;
var IDX_CUST_CODE		    ;
var IDX_CUR					;
var IDX_EXCHANGE_RATE	    ;
var IDX_EXEC_AMT_KRW		;
var IDX_DELY_TO_LOCATION	;

	function init() {
		document.forms[0].EXEC_AMT_KRW.value = add_comma(document.forms[0].EXEC_AMT_KRW.value,0);
		setGridDraw();
		doQuery();
		//setHeader();
	}

	function setHeader() {
	    var itemsize 	= 100;
		var servicesize = 0;
		var item_no			 = "품목코드";
		var description_loc  = "품목명";
		var po_qty           = "수량";
		var dely_to_location = "납품장소";
		if(pr_type=="S"){
			item_no			= "인력코드";
			description_loc = "성명";
			po_qty          = "공수";
			dely_to_location= "근무장소";
			itemsize 	= 0;
			servicesize = 120;
		}

        //GridObj.AddHeader("INVEST_NO"			, "자산번호"			, "t_text", 500, 0, false);
        //GridObj.AddHeader("INVEST_SUB_NO"		, "자산하위번호"		, "t_text", 500, 0, false);

		GridObj.SetColCellSortEnable("DESCRIPTION_LOC"	,false);
		GridObj.SetColCellSortEnable("UNIT_MEASURE"		,false);
		GridObj.SetColCellSortEnable("ITEM_AMT"			,false);
		GridObj.SetColCellSortEnable("PR_AMT"				,false);
		GridObj.SetColCellSortEnable("DELY_TO_LOCATION"	,false);
		GridObj.SetNumberFormat("PO_QTY"			,G_format_qty);
		GridObj.SetNumberFormat("UNIT_PRICE"		,G_format_unit);
		GridObj.SetNumberFormat("PR_UNIT_PRICE"	,G_format_unit);
		GridObj.SetNumberFormat("ITEM_AMT"		,G_format_amt);
		GridObj.SetNumberFormat("PR_AMT"			,G_format_amt);
		GridObj.SetNumberFormat("EXEC_AMT_KRW"	,G_format_amt);
		GridObj.SetNumberFormat("DOWN_AMT"		,G_format_amt);
		GridObj.SetDateFormat("RD_DATE"			,"yyyy/MM/dd");
		GridObj.SetDateFormat("INPUT_FROM_DATE"	,"yyyy/MM/dd");
		GridObj.SetDateFormat("INPUT_TO_DATE"		,"yyyy/MM/dd");


	    IDX_SEL					= GridObj.GetColHDIndex("SEL"				);
	    IDX_ITEM_NO				= GridObj.GetColHDIndex("ITEM_NO"			);
	    IDX_DESCRIPTION_LOC		= GridObj.GetColHDIndex("DESCRIPTION_LOC"	);
	    IDX_RD_DATE				= GridObj.GetColHDIndex("RD_DATE"			);
	    IDX_UNIT_MEASURE		= GridObj.GetColHDIndex("UNIT_MEASURE"	);
	    IDX_PO_QTY			    = GridObj.GetColHDIndex("PO_QTY"			);
	    IDX_UNIT_PRICE		    = GridObj.GetColHDIndex("UNIT_PRICE"		);
	    IDX_ITEM_AMT			= GridObj.GetColHDIndex("ITEM_AMT"		);
	    IDX_PR_UNIT_PRICE	    = GridObj.GetColHDIndex("PR_UNIT_PRICE"	);
	    IDX_PR_AMT			    = GridObj.GetColHDIndex("PR_AMT"			);
	    IDX_DOWN_AMT			= GridObj.GetColHDIndex("DOWN_AMT"		);
	    IDX_PR_NO			    = GridObj.GetColHDIndex("PR_NO"			);
	    IDX_CUST_CODE		    = GridObj.GetColHDIndex("CUST_CODE"		);
	    IDX_CUR					= GridObj.GetColHDIndex("CUR"				);
	    IDX_EXCHANGE_RATE	    = GridObj.GetColHDIndex("EXCHANGE_RATE"	);
	    IDX_EXEC_AMT_KRW		= GridObj.GetColHDIndex("EXEC_AMT_KRW"	);
	    IDX_DELY_TO_LOCATION	= GridObj.GetColHDIndex("DELY_TO_LOCATION");
	    IDX_EXEC_NO				= GridObj.GetColHDIndex("EXEC_NO"			);
	    doQuery();
	}
	function doQuery()
	{
		var grid_col_id = "<%=grid_col_id%>";
		var param = "mode=getPoDetail&grid_col_id="+grid_col_id;
		param += dataOutput();
		var url = "../servlets/sepoa.svl.procure.po_detail";
		GridObj.post(url, param);
		GridObj.clearAll(false);
	}

   	var summaryCnt = 0;
	function JavaCall(msg1, msg2, msg3, msg4, msg5)
	{
        if(msg1 == "doData") { // 전송/저장시 Row삭제

		} else if (msg1 == "t_imagetext") {
			G_CUR_ROW = msg2;

			if(msg3 == IDX_ITEM_NO){
				//if(pr_type=="I")
					window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
				//else
				//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			}else if(msg3 == IDX_EXEC_NO) {
				if (msg5 != "") {
            		window.open("/kr/dt/app/app_bd_ins1.jsp?exec_no="+msg5+ "&pr_type=I&editable=N&req_type=P","execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
				}
			}else if(msg3 == IDX_DESCRIPTION_LOC){
				var item_no = GridObj.GetCellValue("ITEM_NO",msg2);
				//if(pr_type=="I")
					window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
				//else
				//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			}else if(msg3 == IDX_PR_NO){
				window.open("/kr/dt/pr/pr1_bd_dis1.jsp?pr_no="+msg4,"pr1_bd_dis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			}
		} else if (msg1 == "t_insert") {
            if(msg3 == IDX_RD_DATE) {
				se_rd_date  = GD_GetCellValueIndex(GridObj,msg2, IDX_RD_DATE);

				if(se_rd_date <= eval("<%=SepoaDate.getShortDateString()%>") ) {
					alert("납기요청일은 현재날짜 이후여야 합니다."  );
					GD_SetCellValueIndex(GridObj,msg2, IDX_RD_DATE, msg4);
				}
            }
		} else if(msg1 == "t_header") {
			if(msg3 == IDX_RD_DATE) {
				copyCell(SepoaTable, IDX_RD_DATE, "t_date");
			}
		} else if(msg1 == "doQuery") {
        	if(msg3 == IDX_PO_QTY) {
        		//calculate_po_qty(GridObj, msg2);
				//calculate_po_amt(GridObj, msg2);
			}
			if(summaryCnt == 0) {
				//GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'PO_QTY,UNIT_PRICE,ITEM_AMT');
                //GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
                //summaryCnt++;
			}
		}
	}

	/**
	 * 품목별 발주 수량을 계산한다.
     */
	/* function calculate_po_qty(Sepoa, row)
  	{
  		// 소숫점 두자리까지 계산
    	GD_SetCellValueIndex(GridObj,row, IDX_PO_QTY, RoundEx(GD_GetCellValueIndex(GridObj,row,IDX_PO_QTY), 3));
  	} */
	
	/**
	 * 품목별 발주 금액을 계산한다.
     */
	/* function calculate_po_amt(Sepoa, row)
  	{
  		// 소숫점 두자리까지 계산
    	var ITEM_AMT = RoundEx(getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_PO_QTY))*getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_UNIT_PRICE)), 3);
    	GD_SetCellValueIndex(GridObj,row, IDX_ITEM_AMT, setAmt(ITEM_AMT));
  	} */

	function approvalSign(){
		<!-- alert("approvalSign---------------start"); -->
	    childframe.location.href='/kr/admin/basic/approval/approval.jsp?house_code=<%=info.getSession("HOUSE_CODE")%>&company_code=<%=info.getSession("COMPANY_CODE")%>&dept_code=<%=info.getSession("DEPARTMENT")%>&req_user_id=<%=info.getSession("ID")%>&doc_type=POD&fnc_name=getApproval';
	}

	var saveRock  = false;
	var divStatus = "";

	function approval(set){

	    var Sepoa = GridObj;


	    divStatus = set;
	    var f0 = document.forms[0];

	    f0.VENDOR_CODE.value = f0.VENDOR_CODE.value.toUpperCase();
	    f0.PO_NO.value       = f0.PO_NO.value.toUpperCase();

	    if(saveRock==true){
	        alert("해당하는 품번에 대해 이미 발주가 생성되었습니다.");
	        return;
	    }

	    var checked_count = 0;
	    var rowcount = GridObj.GetRowCount();
	    var qtyChk = true;
	    var rdChk = true;
	    var unitPriceChk = true;

	    var tmp_ctrl_code = "";

	    for(row=0; row<rowcount; row++) {
	        if("true" == GD_GetCellValueIndex(GridObj,row, IDX_SEL)) {

	            checked_count ++;

	            if(GD_GetCellValueIndex(GridObj,row,IDX_PO_QTY)=="")
	                qtyChk = false;
	            if(GD_GetCellValueIndex(GridObj,row,IDX_RD_DATE)=="")
	                rdChk = false;
	            if(GD_GetCellValueIndex(GridObj,row,IDX_UNIT_PRICE)=="")
	                unitPriceChk = false;
	        }
	    }

	    if(checked_count == 0){
	        alert(G_MSS1_SELECT);
	        return;
	    }

	    if(!qtyChk){
	        alert("발주 수량은 필수입력사항입니다.");
	        return;
	    }
	    if(!unitPriceChk){
	        alert("단가는 필수입력사항입니다.");
	        return;
	    }

	    if(!rdChk){
	        alert("납기요청일은 필수입력사항입니다.");
	        return;
	    }


	    var setCnt = 0;
	    for(var c=0; c<rowcount; c++)
	        if("true" == GD_GetCellValueIndex(GridObj,c, IDX_SEL))
	            setCnt ++;

	    if(!confirm("수정하시겠습니까?.")){
	        return;
	    }

	    var VENDOR_CODE =  f0.VENDOR_CODE.value;
	    var PO_NO       =  f0.PO_NO.value;
	    var CUR         =  f0.CUR.value;
	    var TTL_AMT     =  del_comma(f0.EXEC_AMT_KRW.value);
	    if(PO_NO=="") PO_NO="xp";
		GridObj.SetParam("VENDOR_CODE"	,VENDOR_CODE			);
	    GridObj.SetParam("PO_NO"          ,PO_NO					);
	    GridObj.SetParam("CUR"            ,CUR					);
	    GridObj.SetParam("TTL_AMT"        ,TTL_AMT				);
	    GridObj.SetParam("REMARK"         ,f0.REMARK.value		);
	    GridObj.SetParam("COMPANY_CODE"   ,"<%=company_code%>"	);
	    GridObj.SetParam("DELY_TERMS"     ,f0.DELY_TERMS.value	);
	    GridObj.SetParam("PAY_TERMS"      ,f0.PAY_TERMS.value		);
   	    GridObj.SetParam("ACCOUNT_TYPE"   ," "					);
   	    GridObj.SetParam("ORDER_NO"   	,f0.ORDER_NO.value		);
		GridObj.SetParam("CTR_NO"			,f0.CTR_NO.value		);
		GridObj.SetParam("CTR_DATE"		,f0.CTR_DATE.value		);
		GridObj.SetParam("PR_TYPE"		,f0.PR_TYPE.value		);
		GridObj.SetParam("ctrl_code"		,f0.ctrl_code.value		);
		GridObj.SetParam("SUBJECT"		,f0.SUBJECT.value		);
		GridObj.SetParam("ctrl_person_id"	,f0.ctrl_person_id.value);

	    if(set=="SAVE")
	        getApproval("SAVE");
	    else
	        approvalSign();
	}

	function getApproval(str){
	    if(str == '') return;
	
	    var sign_flag = "";
	    saveRock = true;
	
	    if(str=="SAVE")
	        sign_flag = "T";   // 작성중
	    else
	        sign_flag = "P";   // 결재중(결재상신)
	
	    GridObj.SetParam("SIGN_FLAG",sign_flag);
	    GridObj.SetParam("APPROVAL",str);
		GridObj.SetParam("CTRL_CODE","<%=ctrl_code%>");
	
	    var servletUrl = "/servlets/order.bpo.po1_bd_upd1";
	
	    GridObj.SetParam("SepoaTABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
	}
	
	function clearRow() {
		GridObj.RemoveAllData();
	}
	
	//담당자
	function SP0071_Popup() {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/admin/Sepoapopup/cod_cm_lis1.jsp?code=SP0071&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=P";
		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}
	
	function  SP0071_getCode(ls_ctrl_code, ls_ctrl_name, ls_ctrl_person_id, ls_ctrl_person_name) {
	
		form1.ctrl_code.value = ls_ctrl_code;
		form1.ctrl_name.value = ls_ctrl_name;
		form1.ctrl_person_id.value = ls_ctrl_person_id;
		form1.ctrl_person_name.value = ls_ctrl_person_name;
	
	}
	function printRD(){
		window.open("/RD/po_rd_dis.jsp?po_no=<%=po_no%>&house_code=<%=house_code%>","po_rd_dis","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
	}
	
	function printOZ(){
		window.open("/oz/oz_po3_pp_dis1.jsp?PO_NO=<%=po_no%>&house_code=<%=house_code%>","po_rd_dis","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
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
	
	
	function goIReport(){
		var cur = "<%=CUR%>";
		
		/*if(confirm("발주 내자는 YES 외자는 NO")){
			getDescframe.location.href = "/report/iReportPrint.jsp?flag=PO&house_code=<//%=house_code%>&so_no=<//%=po_no%>&type=D";
		}else{
			getDescframe.location.href = "/report/iReportPrint.jsp?flag=PO&house_code=<//%=house_code%>&so_no=<//%=po_no%>&type=O";
		}*/
	
		if(cur == "KRW"){
			getDescframe.location.href = "/report/iReportPrint.jsp?flag=PO&house_code=<%=house_code%>&so_no=<%=po_no%>&type=D";
		}else{
			getDescframe.location.href = "/report/iReportPrint.jsp?flag=PO&house_code=<%=house_code%>&so_no=<%=po_no%>&type=O";
		}
	}
	
	// 출력물
	
	function goReport(){
		
		param = new Array();
		param[0] = G_HOUSE_CODE;
		param[1] = po_no;
		fnOpen("/po/PO_REPORT", param);
	}
	
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
		
		var header_name = GridObj.getColumnId(cellInd);
		
		if( header_name == "ITEM_NO" ) {//품목상세
			
			var itemNo	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ITEM_NO") ).getValue()); 
		
			if(itemNo != "합계") {
				
				var url    = '/kr/master/new_material/real_pp_lis1.jsp';
				var title  = '품목상세조회';        
				var param  = 'ITEM_NO=' + itemNo;
				param     += '&BUY=';
				popUpOpen01(url, title, '750', '550', param);
				
			}

			
		}
			
		if(header_name=="EXEC_NO") {
			var exec_no	    = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("EXEC_NO") ).getValue()); 
			//var pr_type	    = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("PR_TYPE") ).getValue()); 
			
			pr_type = "I"
			
			var req_type	= "P";	//LRTrim(GridObj.cells(rowId, IDX_REQ_TYPE).getValue());	
			var sign_status = "E";
			var edit = "N";
			var aurl  = "/kr/dt/app/app_bd_ins1.jsp?exec_no="+exec_no+ "&pr_type=" + pr_type + "&editable=N&req_type="+req_type;
			window.open(aurl,"execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
		}
		
	    //alert(GridObj.cells(rowId, cellInd).getValue());
	<%--    
			GD_CellClick(document.SepoaGrid,strColumnKey, nRow);

	    
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
	    
	    getSumData();
	    
	    return true;
	}
	function getSumData(){
		var sum_PO_QTY = 0;
		var sum_UNIT_PRICE = 0;
		var sum_ITEM_AMT = 0;
		for(var i = 1 ; i<=GridObj.getRowsNum() ; i++){
			sum_PO_QTY += Number(GridObj.cells(i,GridObj.getColIndexById("PO_QTY")).getValue());
			sum_UNIT_PRICE += Number(GridObj.cells(i,GridObj.getColIndexById("UNIT_PRICE")).getValue());
			sum_ITEM_AMT += Number(GridObj.cells(i,GridObj.getColIndexById("ITEM_AMT")).getValue());
		}
		var nextRowId = GridObj.getRowsNum()+1;
		GridObj.addRow(nextRowId, "", GridObj.getRowIndex(nextRowId));
		GridObj.cells(nextRowId,GridObj.getColIndexById("ITEM_NO")).setValue("합계");
		GridObj.cells(nextRowId,GridObj.getColIndexById("PO_QTY")).setValue(sum_PO_QTY);
		GridObj.cells(nextRowId,GridObj.getColIndexById("UNIT_PRICE")).setValue(sum_UNIT_PRICE);
		GridObj.cells(nextRowId,GridObj.getColIndexById("ITEM_AMT")).setValue(sum_ITEM_AMT);
	}
	
	function setAttach(attach_key, arrAttrach, attach_count) {


	    var attachfilename  = arrAttrach + "";
	    var result 			="";

		var attach_info 	= attachfilename.split(",");

		for (var i =0;  i <  attach_count; i ++)
	    {
		    var doc_no 			= attach_info[0+(i*7)];
			var doc_seq 		= attach_info[1+(i*7)];
			var type 			= attach_info[2+(i*7)];
			var des_file_name 	= attach_info[3+(i*7)];
			var src_file_name 	= attach_info[4+(i*7)];
			var file_size 		= attach_info[5+(i*7)];
			var add_user_id 	= attach_info[6+(i*7)];

			if (i == attach_count-1)
				result = result + src_file_name;
			else
				result = result + src_file_name + ",";
		}

		document.forms[0].ATTACH_NO.value = attach_key;
		document.forms[0].FILE_NAME.value = result;

	}
	
	<%-- ClipReport4 리포터 호출 스크립트 --%>
	function clipPrint(rptAprvData) {
		if(typeof(rptAprvData) != "undefined"){
			alert(rptAprvData);
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
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
	<form name="form1" method="post">
		<%--ClipReport4 hidden 태그 시작--%>
		<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
		<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">	
		<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="Y">
		<%--ClipReport4 hidden 태그 끝--%>	
		<input type="hidden" name="h_po_no">
		<input type="hidden" name="set_company_code">
		<input type="hidden" name="SHIPPER_TYPE" value = "D">

		<input type="hidden" name="attach_gubun" value="body">
		<input type="hidden" name="attach_no" value="<%=ATTACH_NO%>">
		<input type="hidden" name="attach_count" value="">
		<input type="hidden" name="att_mode"  value="">
		<input type="hidden" name="view_type"  value="">
		<input type="hidden" name="file_type"  value="">
		<input type="hidden" name="tmp_att_no" value="">

		<table width="99%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<td class='title_page' height="20" align="left" valign="bottom">
					<span class='location_end'>발주화면 상세조회</span>
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
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주번호</td>
										<td width="35%" class="data_td">
											<input type="text" name="po_no" id="po_no" value="<%=po_no%>" readOnly style="width:92%;border:0;background-color: #f6f6f6;">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주명</td>
										<td width="35%" class="data_td">
											<input type="text" name="SUBJECT" value="<%=SUBJECT%>" readOnly style="width:92%;border:0;background-color: #f6f6f6;">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주업체</td>
										<td width="35%" class="data_td">
											<input type="text" name="VENDOR_CODE" value="<%=VENDOR_CODE%>" readOnly style="width:32%;border:0;background-color: #f6f6f6;">
											<input type="text" name="VENDOR_NAME" value="<%=VENDOR_NAME%>" readOnly style="width:59%;border:0;background-color: #f6f6f6;">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주일자</td>
										<td width="35%" class="data_td">
											<input type="text" name="PO_CREATE_DATE" size="20" value="<%=PO_CREATE_DATE%>" readOnly style="border:0;background-color: #f6f6f6;">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급조건</td>
										<td width="35%" class="data_td"><%=PAY_TERMS%></td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;인도조건</td>
										<td width="35%" class="data_td"><%=DELY_TERMS%></td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주업체담당자</td>										
										<td width="35%" class="data_td">
											담당자 : <%=VENDOR_CP_NAME%><br>
											핸드폰 : <%=VENDOR_MOBILE_NO%><br>
											이메일 : <%=VENDOR_EMAIL%>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주금액(VAT 포함)</td>
										<td width="35%" class="data_td">
											<input type="text" name="EXEC_AMT_KRW" value="<%=EXEC_AMT_KRW%>" readOnly style="width:95%;border:0;background-color: #f6f6f6;">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;검수담당자</td>
										<td width="35%" class="data_td">
											<input type="text" name="TAKE_USER_NAME" value="<%=TAKE_USER_NAME%>" readOnly style="width:95%;border:0;background-color: #f6f6f6;">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;검수자연락처</td>
										<td width="35%" class="data_td"><%=TAKE_TEL %>&nbsp;&nbsp;<font color="red"><b><%=TAKE_USER_CHANGE_MSG%></b></font></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;검수담당자부서</td>
										<td width="35%" class="data_td" colspan="3">
											<input type="text" name="TAKE_USER_DEPT_NAME" value="<%=TAKE_USER_DEPT_NAME%>" readOnly style="width:95%;border:0;background-color: #f6f6f6;">
										</td>
<!-- 										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;검수자내선번호</td> -->
<!-- 										<td width="35%" class="data_td"> -->
<%-- 											<input type="text" name="TAKE_USER_IN_PHONE" value="<%=TAKE_USER_IN_PHONE%>" readOnly style="width:95%;border:0;background-color: #f6f6f6;"> --%>
<!-- 										</td> -->
									</tr>
<%
	if(prm_po_type != null && prm_po_type.length() > 0){
		//품의발주 일 경우에만 보인다 
		if(!prm_po_type.equals("D") && !prm_po_type.equals("M") && !prm_po_type.equals("C") && !prm_po_type.equals("E")){
%>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약기간</td>
										<td width="35%" class="data_td"></td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지체상금율(%)</td>
										<td width="35%" class="data_td"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;하자이행 보증기간</td>
										<td width="35%" class="data_td">검수일로부터 ()개월</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약일반사항</td>
										<td width="35%" class="data_td">
											선급금보증 %<br>
											계약이행보증 %<br>
											하자이행보증 %<br>
										</td>
									</tr>				
<%
		}
	}
%>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;비고</td>
										<td class="data_td" colspan="3">
											<textarea name="REMARK" style="width:98%" rows="5" readOnly style="border:0"><%=REMARK%></textarea>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
										<td class="data_td" colspan="3" height="150">
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
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
    		<tr>
      			<td height="30" align="right">
					<TABLE cellpadding="0">
		      			<TR>
    						<TD>
<script language="javascript">
btn("javascript:clipPrint()","출 력");
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
	<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
	<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="PO_004" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>