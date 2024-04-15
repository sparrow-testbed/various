<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AR_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AR_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<% String WISEHUB_PROCESS_ID="AR_003";%>
<script language="javascript">var OLD_PO_QTY	=	0	;</script>
<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>


<%
        String user_id        		= info.getSession("ID");
        String house_code     		= info.getSession("HOUSE_CODE");
        String company_code   		= info.getSession("COMPANY_CODE");
        String ctrl_code      		= info.getSession("CTRL_CODE");
        String user_name	 		= info.getSession("NAME_LOC");
        String toDaysSo       		= SepoaDate.getShortDateString();
        String toDays         		= SepoaDate.getFormatString("yyyy/MM/dd");
		String VENDOR_CODE			= "";
		String VENDOR_NAME			= "";
		String SUBJECT				= "";
		String CTRL_CODE			= "";
		String PAY_TERMS			= "";
		String PAY_TERMS_DESC		= "";
		String PR_TYPE				= "";
		String PR_TYPE_CODE			= "";
		String ORDER_NO				= "";
		String ORDER_NAME			= "";
		String CUR					= "";
		String EXEC_AMT_KRW			= "";
		String TAKE_USER_NAME		= "";
		String TAKE_USER_ID			= "";
		String CTR_DATE				= "";
		String TAKE_TEL				= "";
		String REMARK				= "";
		String EXEC_NO				= "";
		String CTR_NO				= "";
		String VENDOR_CP_NAME		= "";
        String VENDOR_MOBILE_NO 	= "";
        String CONTRACT_FROM_DATE	= "";
		String CONTRACT_TO_DATE		= "";
		String SIGN_PERSON_ID		= "";
		String SIGN_DATE			= "";
		String ADD_TIME				= "";
		String ADD_DATE				= "";
		String ADD_USER_ID			= "";
		String PO_TYPE				= "";
		String PO_AMT_KRW			= "";
		String BSART_DESC			= "";
		String ATTACH_NO			= "";
		String INV_PROGRESS_CNT     = "";

        String pr_type          	= JSPUtil.nullToEmpty(request.getParameter("pr_type"));
		String po_no        		= JSPUtil.nullToEmpty(request.getParameter("po_no"));
        String pr_no   				= JSPUtil.nullToEmpty(request.getParameter("pr_no"));
        String exec_no		    	= JSPUtil.nullToEmpty(request.getParameter("exec_no"));
        String prdt_pr_seq          = JSPUtil.nullToEmpty(request.getParameter("prdt_pr_seq"));
        String yr_unit_pr_ord_gb    = JSPUtil.nullToEmpty(request.getParameter("yr_unit_pr_ord_gb"));
        String wk_type          	= JSPUtil.nullToEmpty(request.getParameter("wk_type"));
		if ("".equals(po_no)) po_no = JSPUtil.nullToEmpty(request.getParameter("doc_no"));
		
        Object[] obj = {po_no};
        SepoaOut value = ServiceConnector.doService(info, "p2090", "CONNECTION", "getPOHeader", obj);

		SepoaFormater wf = new SepoaFormater(value.result[0]);
		if(wf.getRowCount() > 0) {
			VENDOR_CODE		    = wf.getValue("VENDOR_CODE"	 		, 0);
			VENDOR_NAME		    = wf.getValue("VENDOR_NAME"	 		, 0);
			SUBJECT			    = wf.getValue("SUBJECT"	 			, 0);
			CTRL_CODE		    = wf.getValue("CTRL_CODE"    		, 0);
			PAY_TERMS		    = wf.getValue("PAY_TERMS"    		, 0);
			PAY_TERMS_DESC		= wf.getValue("PAY_TERMS_DESC"    	, 0);
			PR_TYPE			    = wf.getValue("PR_TYPE_DESC"		, 0);
			PR_TYPE_CODE		= wf.getValue("PR_TYPE"				, 0);
			ORDER_NO			= wf.getValue("ORDER_NO"	 		, 0);
			ORDER_NAME			= wf.getValue("ORDER_NAME"	 		, 0);
			CUR				    = wf.getValue("CUR"	 				, 0);
			EXEC_AMT_KRW		= wf.getValue("PO_TTL_AMT"			, 0);
			TAKE_USER_NAME	    = wf.getValue("TAKE_USER_NAME"  	, 0);
			TAKE_USER_ID	    = wf.getValue("TAKE_USER_ID"  	, 0);
			CTR_DATE			= wf.getValue("CTR_DATE"	 		, 0);
			TAKE_TEL			= wf.getValue("TAKE_TEL"	 		, 0);
			REMARK			    = wf.getValue("REMARK"    			, 0);
			EXEC_NO			    = wf.getValue("EXEC_NO"	 			, 0);
			CTR_NO			    = wf.getValue("CTR_NO"    			, 0);
			VENDOR_CP_NAME		= wf.getValue("VENDOR_CP_NAME"		, 0);
			VENDOR_MOBILE_NO    = wf.getValue("VENDOR_MOBILE_NO"	, 0);
			CONTRACT_FROM_DATE	= wf.getValue("CONTRACT_FROM_DATE"	, 0);
			CONTRACT_TO_DATE    = wf.getValue("CONTRACT_TO_DATE"	, 0);
			SIGN_PERSON_ID		= wf.getValue("SIGN_PERSON_ID"		, 0);
			SIGN_DATE    		= wf.getValue("SIGN_DATE"			, 0);
			ADD_DATE    		= wf.getValue("ADD_DATE"			, 0);
			ADD_TIME    		= wf.getValue("ADD_TIME"			, 0);
			ADD_USER_ID    		= wf.getValue("ADD_USER_ID"			, 0);
			PO_TYPE    			= wf.getValue("PO_TYPE"				, 0);
			PO_AMT_KRW    		= wf.getValue("PO_AMT_KRW"			, 0);
			BSART_DESC    		= wf.getValue("BSART_DESC"			, 0);
			ATTACH_NO    		= wf.getValue("ATTACH_NO"			, 0);
			INV_PROGRESS_CNT    = wf.getValue("INV_PROGRESS_CNT"	, 0);
		}
		SepoaListBox LB = new SepoaListBox();
		String COMBO_M004     = LB.Table_ListBox(request, "SL0022", house_code+"#M187#", "&" , "#");

%>

<html>
<head>
<% if(wk_type.equals("3")){ %>
<title>발주대기환원</title>
<% }else if(wk_type.equals("2")){ %>
<title>연단가발주취소</title>
<% }else{ %>
<title>발주중도종결</title>	
<% } %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>
<script language="javascript">

var G_CUR_ROW = -1;

var mode;
var G_HOUSE_CODE   = "<%=house_code%>";
var G_COMPANY_CODE = "<%=company_code%>";
var pr_type = "<%=PR_TYPE_CODE%>";
var IDX_CUD_FG				;
var IDX_HD_SEL				;
var IDX_SEL					;
var IDX_ITEM_NO				;
var IDX_DESCRIPTION_LOC		;
var IDX_SPECIFICATION		;
var IDX_MAKER_NAME			;
var IDX_MAKER_CODE			;
var IDX_MATERIAL_TYPE		;

var IDX_RD_DATE				;
var IDX_UNIT_MEASURE		;
var IDX_PO_QTY			    ;
var IDX_OLD_PO_QTY			;
var IDX_CONTRACT_REMAIN		;
var IDX_CHK_QTY			    ;
var IDX_UNIT_PRICE		    ;
var IDX_ITEM_AMT			;

var IDX_PR_UNIT_PRICE	    ;
var IDX_PR_AMT			    ;
var IDX_DOWN_AMT			;

var IDX_PR_NO			    ;
var IDX_PR_SEQ			    ;
var IDX_PO_NO			    ;
var IDX_PO_SEQ			    ;

var IDX_CUST_NAME		    ;
var IDX_CUR					;
var IDX_EXCHANGE_RATE	    ;
var IDX_EXEC_NO				;
var IDX_EXEC_AMT_KRW		;
var IDX_DELY_TO_LOCATION	;

var IDX_DELY_TO_ADDRESS		;
var IDX_WARRANTY			;

var IDX_WBS_NO				;
var IDX_WBS_NAME			;
var IDX_ORDER_COUNT			;

var setCatalogCnt = 0;

	function Catalog(){

		var selectedCnt = 0;
		for(var i=0; i<GridObj.GetRowCount(); i++){
			if(GridObj.GetCellValue("SEL", i) == "1"){
				selectedCnt++;
				modifyPrNo 	= GridObj.GetCellValue("PR_NO", i);
				modifyPrSeq = GridObj.GetCellValue("PR_SEQ", i);
				modifyCur 	= GridObj.GetCellValue("CUR", i);
				//modifySoucingNo	= GridObj.GetCellValue("SOURCING_NO", i);
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



		//setCatalogIndex("ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:MAKER_CODE:MAKER_NAME:BASIC_UNIT");
		setCatalogIndex("ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:MAKER_CODE:MAKER_NAME:MATERIAL_TYPE");
		url = "/kr/catalog/cat_pp_lis_frame.jsp?INDEX=" + getAllCatalogIndex() ;
		CodeSearchCommon(url,"CATALOG",0,0,"840","450");
	}

	/* function setCatalog(arr)
	{
		if(setCatalogCnt == 0){
			//GridObj.DeleteRow(modifySeq);
			//setCatalogCnt++;
		}


		var wise = GridObj;

		var ITEM_NO = arr[getCatalogIndex("ITEM_NO")];

		var dup_flag = false;
		for(var i=0;i<wise.getRowCount();i++)
		{
			if(ITEM_NO == GD_GetCellValueIndex(GridObj,i,IDX_ITEM_NO))
			{
				dup_flag = true;
			}
		}

		var iMaxRow = wise.getRowCount();
		GridObj.AddRow();


		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_CUD_FG,			"I" );
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_HD_SEL,			"1" );
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_SEL,			"0" );

		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_ITEM_NO, "null&"+arr[getCatalogIndex("ITEM_NO")]+"&"+arr[getCatalogIndex("ITEM_NO")], "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_DESCRIPTION_LOC, arr[getCatalogIndex("DESCRIPTION_LOC")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_SPECIFICATION,  arr[getCatalogIndex("SPECIFICATION")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_MAKER_NAME,     arr[getCatalogIndex("MAKER_NAME")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_MAKER_CODE,     arr[getCatalogIndex("MAKER_CODE")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_MATERIAL_TYPE,     arr[getCatalogIndex("MATERIAL_TYPE")]);

		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_RD_DATE,  wise.GetCellValue("RD_DATE", modifySeq));
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_UNIT_MEASURE,  wise.GetCellValue("UNIT_MEASURE", modifySeq));
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_PO_QTY,  "0");
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_OLD_PO_QTY,  "0");

		GridObj.SetComboSelectedHiddenValue('CONTRACT_REMAIN', iMaxRow, 'N');

		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_CHK_QTY, "0");
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_UNIT_PRICE,  "0");
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_ITEM_AMT,  "0");

		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_PR_UNIT_PRICE	, "0");
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_PR_AMT			, "0");
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_DOWN_AMT		, "0");
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_PR_NO			,  wise.GetCellValue("PR_NO", modifySeq));
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_PR_SEQ			,  wise.GetCellValue("PR_SEQ", modifySeq));
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_PO_NO			,  wise.GetCellValue("PO_NO", modifySeq));
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_PO_SEQ			,  wise.GetCellValue("PO_SEQ", modifySeq));
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_CUST_NAME		,  wise.GetCellValue("CUST_NAME", modifySeq));
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_CUR				,  wise.GetCellValue("CUR", modifySeq));
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_EXCHANGE_RATE	,  wise.GetCellValue("EXCHANGE_RATE", modifySeq));
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_EXEC_NO			,  wise.GetCellValue("EXEC_NO", modifySeq));
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_WBS_NO			,  wise.GetCellValue("WBS_NO", modifySeq));
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_WBS_NAME		,  wise.GetCellValue("WBS_NAME", modifySeq));
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_ORDER_NO		,  wise.GetCellValue("ORDER_NO", modifySeq));
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_ORDER_SEQ		,  wise.GetCellValue("ORDER_SEQ", modifySeq));
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_ORDER_COUNT		,  wise.GetCellValue("ORDER_COUNT", modifySeq));

		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_DELY_TO_ADDRESS	,  wise.GetCellValue("DELY_TO_ADDRESS", modifySeq));
		GD_SetCellValueIndex(GridObj,iMaxRow, IDX_WARRANTY		,  wise.GetCellValue("WARRANTY", modifySeq));

		//GD_SetCellValueIndex(GridObj,iMaxRow, IDX_DELY_TO_LOCATION,  wise.GetCellValue("DELY_TO_LOCATION", modifySeq));


		gridModifyFlag = "Y";

		GridObj.strScrollBars='both';




	} */

	function getItemValue(){
		GridObj.strScrollBars='both';
	}

	function init() {
		document.forms[0].EXEC_AMT_KRW.value = add_comma(document.forms[0].EXEC_AMT_KRW.value,0);
		setGridDraw();
		setHeader();
	}

	function setHeader() {

		var itemsize 	= 100;
		var servicesize = 0;
		var item_no			 = "품목코드";
		var description_loc  = "품목명";
		var po_qty           = "수량";
		var dely_to_location = "납품장소";
/*
		if(pr_type=="S"){
			item_no			= "인력코드";
			description_loc = "성명";
			po_qty          = "공수";
			dely_to_location= "근무장소";
			itemsize 	= 0;
			servicesize = 120;
		}
*/
		/* GridObj.AddHeader("CUD_FG"			,""					,"t_text"		,100	,0		,false); */


        /* * * * * * * * * * * BoundHeader * * * * * * * * * * */


/* 		GridObj.AddComboList('CONTRACT_REMAIN','COMBO1');
		GridObj.AddComboListValue('CONTRACT_REMAIN','','A', 'COMBO1');
		GridObj.AddComboListValue('CONTRACT_REMAIN','유지','Y', 'COMBO1');
		GridObj.AddComboListValue('CONTRACT_REMAIN','미유지','N', 'COMBO1');



		GridObj.SetColCellSortEnable("DESCRIPTION_LOC"	,false);
		GridObj.SetColCellSortEnable("UNIT_MEASURE"		,false);
		GridObj.SetColCellSortEnable("ITEM_AMT"			,false);
		GridObj.SetColCellSortEnable("PR_AMT"				,false);
		GridObj.SetColCellSortEnable("DELY_TO_LOCATION"	,false);
		GridObj.SetNumberFormat("PO_QTY"			,G_format_qty);
		GridObj.SetNumberFormat("CHK_QTY"			,G_format_qty);
		GridObj.SetNumberFormat("UNIT_PRICE"		,G_format_unit);
		GridObj.SetNumberFormat("PR_UNIT_PRICE"	,G_format_unit);
		GridObj.SetNumberFormat("ITEM_AMT"		,G_format_amt);
		GridObj.SetNumberFormat("PR_AMT"			,G_format_amt);
		GridObj.SetNumberFormat("DOWN_AMT"		,G_format_amt);
		GridObj.SetNumberFormat("EXEC_AMT_KRW"	,G_format_amt);
		GridObj.SetDateFormat("RD_DATE"			,"yyyy/MM/dd");
		GridObj.SetDateFormat("INPUT_FROM_DATE"	,"yyyy/MM/dd");
		GridObj.SetDateFormat("INPUT_TO_DATE"		,"yyyy/MM/dd"); */


		GridObj.strScrollBars='automatic';

		IDX_CUD_FG				= GridObj.GetColHDIndex("CUD_FG"			);
		IDX_HD_SEL				= GridObj.GetColHDIndex("HD_SEL"			);
	    IDX_SEL					= GridObj.GetColHDIndex("SEL"				);
	    IDX_ITEM_NO				= GridObj.GetColHDIndex("ITEM_NO"			);
		IDX_DESCRIPTION_LOC		= GridObj.GetColHDIndex("DESCRIPTION_LOC"	);
		IDX_SPECIFICATION		= GridObj.GetColHDIndex("SPECIFICATION"	);
		IDX_MAKER_NAME			= GridObj.GetColHDIndex("MAKER_NAME"		);
		IDX_MAKER_CODE			= GridObj.GetColHDIndex("MAKER_CODE"		);
		IDX_MATERIAL_TYPE		= GridObj.GetColHDIndex("MATERIAL_TYPE"	);
	    IDX_RD_DATE				= GridObj.GetColHDIndex("RD_DATE"			);
	    IDX_UNIT_MEASURE		= GridObj.GetColHDIndex("UNIT_MEASURE"	);
	    IDX_PO_QTY			    = GridObj.GetColHDIndex("PO_QTY"			);
	    IDX_OLD_PO_QTY			= GridObj.GetColHDIndex("OLD_PO_QTY"		);
	    IDX_CONTRACT_REMAIN		= GridObj.GetColHDIndex("CONTRACT_REMAIN"	);
		IDX_CHK_QTY			    = GridObj.GetColHDIndex("CHK_QTY"			);
	    IDX_UNIT_PRICE		    = GridObj.GetColHDIndex("UNIT_PRICE"		);
	    IDX_ITEM_AMT			= GridObj.GetColHDIndex("ITEM_AMT"		);
	    IDX_PR_UNIT_PRICE	    = GridObj.GetColHDIndex("PR_UNIT_PRICE"	);
	    IDX_PR_AMT			    = GridObj.GetColHDIndex("PR_AMT"			);
	    IDX_DOWN_AMT			= GridObj.GetColHDIndex("DOWN_AMT"		);
	    IDX_PR_NO			    = GridObj.GetColHDIndex("PR_NO"			);
		IDX_PR_SEQ			    = GridObj.GetColHDIndex("PR_SEQ"			);
		IDX_PO_NO			    = GridObj.GetColHDIndex("PO_NO"			);
		IDX_PO_SEQ			    = GridObj.GetColHDIndex("PO_SEQ"			);
	    IDX_CUST_NAME		    = GridObj.GetColHDIndex("CUST_NAME"		);
	    IDX_CUR					= GridObj.GetColHDIndex("CUR"				);
	    IDX_EXCHANGE_RATE	    = GridObj.GetColHDIndex("EXCHANGE_RATE"	);
	    IDX_EXEC_AMT_KRW		= GridObj.GetColHDIndex("EXEC_AMT_KRW"	);
	    IDX_DELY_TO_LOCATION	= GridObj.GetColHDIndex("DELY_TO_LOCATION");
	    IDX_EXEC_NO				= GridObj.GetColHDIndex("EXEC_NO");
	    IDX_DELY_TO_ADDRESS		= GridObj.GetColHDIndex("DELY_TO_ADDRESS");
		IDX_WARRANTY			= GridObj.GetColHDIndex("WARRANTY");

	    IDX_ORDER_NO			= GridObj.GetColHDIndex("ORDER_NO");
	    IDX_ORDER_SEQ			= GridObj.GetColHDIndex("ORDER_SEQ");
		IDX_ORDER_COUNT			= GridObj.GetColHDIndex("ORDER_COUNT");
	    IDX_WBS_NO				= GridObj.GetColHDIndex("WBS_NO");
		IDX_WBS_NAME			= GridObj.GetColHDIndex("WBS_NAME");
	    IDX_WBS_SUB_NO			= GridObj.GetColHDIndex("WBS_SUB_NO");
	    IDX_WBS_TXT				= GridObj.GetColHDIndex("WBS_TXT");

	    doQuery();

// 		GridObj.bHDMoving = false
// 		GridObj.bHDSwapping = false
// 		GridObj.strRowBorderStyle = 'none'
// 		GridObj.nRowSpacing = 0
// 		GridObj.strHDClickAction = 'select'
// 		GridObj.bRowSelectorVisible = false
// 		GridObj.nAlphaLevel=0;

		//WiseGrid에 SummaryBar를 추가한다.
		//GridObj.AddSummaryBar('ITEMSUM', '합계', 'summaryall', 'sum', 'ITEM_AMT,HD_ITEM_AMT');

		//SummaryBar의 색상을 조절한다.
		//GridObj.SetSummaryBarColor('ITEMSUM', '100|100|100', '250|222|222');

	}
	function doQuery()
	{
		var servletUrl ="/servlets/order.bpo.po1_bd_upd3";
		GridObj.SetParam("po_no","<%=po_no%>");
		GridObj.SetParam("combo","<%=COMBO_M004%>");
		/* GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0"); */
		var param = "mode=doQuery&grid_col_id="+grid_col_id;
			param +="<%=po_no%>";
			param +="<%=COMBO_M004%>";
		    param += dataOutput();
		/* GridObj.SendData(servletUrl);
		GridObj.strHDClickAction="sortmulti"; */
		GridObj.post(servletUrl, param);
		GridObj.clearAll(false);
	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5)
	{
		GridObj.strScrollBars='both';

		if(msg1 == "doQuery") {
<%
	if (!INV_PROGRESS_CNT.equals("0")) {
%>
		alert("발주중도종결은 검수요청 결재진행건이 없을때만  가능합니다.\n\n발주의 검수요청 결재상태를 확인하세요.");
<%
	}
%>
		}

        if(msg1 == "doData") { // 전송/저장시 Row삭제
        	var mode 	= GD_GetParam(GridObj,0);
			var status 	= GD_GetParam(GridObj,1);

			alert(GridObj.GetMessage());

//			alert("발주중도종결이 완료되었습니다.");
			if(GridObj.GetStatus() == 1){
				opener.doSelect();
				window.close();
			}

			//location.href="po3_bd_lis1.jsp";
		} else if (msg1 == "t_imagetext") {
			G_CUR_ROW = msg2;

			if(msg3 == IDX_ITEM_NO){
				//if(pr_type=="I")
					window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
				//else
				//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			}else if(msg3 == IDX_DESCRIPTION_LOC){
				var item_no = GridObj.GetCellValue("ITEM_NO",msg2);
				//if(pr_type=="I")
					window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
				//else
				//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			}else if(msg3 == IDX_PR_NO){
				window.open("/kr/dt/pr/pr1_bd_dis1.jsp?pr_no="+msg4,"pr1_bd_dis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			}else if(msg3 == IDX_EXEC_NO) {
				window.open("/kr/dt/app/app_pp_dis2.jsp?exec_no="+msg5,"execwin","left=0,top=0,width=1024,height=500,resizable=yes,scrollbars=yes, status=yes");
			}else if(msg3 == IDX_INVEST_NO_TEXT) {
			    var exec_no = GD_GetCellValueIndex(GridObj,msg2, IDX_EXEC_NO);
				window.open("/kr/order/bpo/po1_invest_pp_lis1.jsp?cur_row="+G_CUR_ROW,"execwin","left=0,top=0,width=1024,height=500,resizable=yes,scrollbars=yes, status=yes");
			}
		} else if (msg1 == "t_insert") {
            if(msg3 == IDX_RD_DATE) {
				se_rd_date  = GD_GetCellValueIndex(GridObj,msg2, IDX_RD_DATE);

				if(se_rd_date <= eval("<%=SepoaDate.getShortDateString()%>") ) {
					alert("납기요청일은 현재날짜 이후여야 합니다."  );
					GD_SetCellValueIndex(GridObj,msg2, IDX_RD_DATE, msg4);
				}
            }else if(msg3 == IDX_UNIT_PRICE||msg3 == IDX_PO_QTY) {

				/* 검수량 비교 체크 */
				if(GD_GetCellValueIndex(GridObj,msg2,IDX_PO_QTY) < GD_GetCellValueIndex(GridObj,msg2,IDX_CHK_QTY)){
					alert("검수량 보다 작을 순 없습니다");
					GD_SetCellValueIndex(GridObj,msg2,IDX_PO_QTY,OLD_PO_QTY);
					return	;
				}

				var ttl_amt = GD_GetCellValueIndex(GridObj,msg2,IDX_PO_QTY)*GD_GetCellValueIndex(GridObj,msg2,IDX_UNIT_PRICE);
				GD_SetCellValueIndex(GridObj,msg2,IDX_ITEM_AMT,ttl_amt);
				setTotalAmount();
            }
		} else if(msg1 == "t_header") {
			if(msg3 == IDX_RD_DATE) {
				copyCell(WiseTable, IDX_RD_DATE, "t_date");
			}
		}
	}

	/*
	function setValueP(cur_row, invest_no, invest_sub_no, ktogr, aktiv, txt50) {
		GridObj.SetCellValue("INVEST_NO",cur_row, invest_no);
		GridObj.SetCellValue("INVEST_NO_TEXT",cur_row, invest_no);
		GridObj.SetCellValue("INVEST_SUB_NO",cur_row, invest_sub_no);
		GridObj.SetCellValue("KTOGR",cur_row, ktogr);
		GridObj.SetCellValue("AKTIV",cur_row, aktiv);
		GridObj.SetCellValue("TXT50",cur_row, txt50);

	}
	*/
	function setTotalAmount(){
		var rowCount = GridObj.GetRowCount();
		var totalAmt = 0;
		for( i = 0; i < rowCount ; i++){
			totalAmt += parseInt(GD_GetCellValueIndex(GridObj, i, IDX_ITEM_AMT));
		}
		document.forms[0].EXEC_AMT_KRW.value = add_comma(totalAmt,0);
	}
	function approvalSign(){
		<!-- alert("approvalSign---------------start"); -->
	    childframe.location.href='/kr/admin/basic/approval/approval.jsp?house_code=<%=info.getSession("HOUSE_CODE")%>&company_code=<%=info.getSession("COMPANY_CODE")%>&dept_code=<%=info.getSession("DEPARTMENT")%>&req_user_id=<%=info.getSession("ID")%>&doc_type=POD&fnc_name=getApproval';
	}

	var saveRock  = false;
	var divStatus = "";

	function approval(set){

	    var wise = GridObj;


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

	    if(!rdChk && pr_type=="I"){
	        alert("납기요청일은 필수입력사항입니다.");
	        return;
	    }
	    if(f0.PO_TYPE.value == ""){
	    	alert("발주구분을 선택해주세요.");
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
	    GridObj.SetParam("DELY_TERMS"     ," "					);
	    GridObj.SetParam("PAY_TERMS"      ,"<%=PAY_TERMS%>"		);
   	    GridObj.SetParam("ACCOUNT_TYPE"   ," "					);
   	    GridObj.SetParam("ORDER_NO"   	,f0.ORDER_NO.value		);
   	    GridObj.SetParam("ORDER_NAME"   	,"<%=ORDER_NAME%>"		);
		GridObj.SetParam("CTR_NO"			,""		);
		GridObj.SetParam("CTR_DATE"		,""		);
		GridObj.SetParam("PR_TYPE"		,"<%=PR_TYPE_CODE%>"	);
		GridObj.SetParam("ctrl_code"		,f0.ctrl_code.value		);
		GridObj.SetParam("SUBJECT"		,f0.SUBJECT.value		);
		GridObj.SetParam("ctrl_person_id"	,f0.ctrl_person_id.value);
		GridObj.SetParam("TAKE_USER_NAME" ,f0.TAKE_USER_ID.value);
		GridObj.SetParam("TAKE_TEL"		,f0.TAKE_TEL.value		);
		GridObj.SetParam("VENDOR_CP_NAME"  	,f0.vendor_person_name.value	);
		GridObj.SetParam("VENDOR_MOBILE_NO"	,f0.vendor_person_mobil.value	);
		GridObj.SetParam("PO_TYPE"			,f0.PO_TYPE.value				);
		GridObj.SetParam("CONTRACT_FROM_DATE" ,"<%=CONTRACT_FROM_DATE%>"		);
		GridObj.SetParam("CONTRACT_TO_DATE"	,"<%=CONTRACT_TO_DATE%>"		);
		GridObj.SetParam("SIGN_DATE" 			,"<%=SIGN_DATE%>"				);
		GridObj.SetParam("SIGN_PERSON_ID"		,"<%=SIGN_PERSON_ID%>"			);
		GridObj.SetParam("ADD_DATE" 			,"<%=ADD_DATE%>"				);
		GridObj.SetParam("ADD_TIME" 			,"<%=ADD_TIME%>"				);
		GridObj.SetParam("ADD_USER_ID" 		,"<%=ADD_USER_ID%>"				);
		GridObj.SetParam("PO_AMT_KRW"			,"<%=PO_AMT_KRW%>"				);
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
		GridObj.SetParam("CTRL_CODE","<%=CTRL_CODE%>");

	    var servletUrl = "/servlets/order.bpo.po1_bd_upd3";

	    GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
	}

	function clearRow() {
        GridObj.RemoveAllData();
	}

	/* 발주중도종결 - 저장 */
	function fnSave(){
		if(form1.END_REMARK.value == ""){
			alert("종결사유를 입력하셔야 합니다.");
			form1.END_REMARK.focus();
			return;
		}
		var ws = GridObj	;
		var servletUrl = "/servlets/order.bpo.po1_bd_upd3";

		if(!confirm("발주중도종결 하시겠습니까?")){
			return;
		}
		
		var grid_array = getGridChangedRows(GridObj, "SEL");
		var cols_ids = grid_col_id;
		var params;
		params = "?mode=doData";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor(servletUrl+params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj, myDataProcessor, "SEL",grid_array);		
	}

	/* 발주취소(연단가) */
	function yrpoCancel(){
		var isSelected = false;
		var iRowCount  = GridObj.GetRowCount();
		
		for(var i=0;i<iRowCount;i++){
			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == true){
				isSelected = true;

				break;
			}
		}

		if(isSelected == false) {
			alert('선택된 행이 없습니다.');
			return;
		}
		
		var ws = GridObj;
		var servletUrl = "/servlets/order.bpo.po1_bd_upd3";
		if(!confirm("발주취소(연단가)처리를 하시겠습니까?")){
			return;
		}

		var grid_array  = getGridChangedRows(GridObj, "SEL");
		var cols_ids    = grid_col_id;
		var params;
		params = "?mode=setPoCancel";
		params +="&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor(servletUrl+params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj, myDataProcessor, "SEL",grid_array);		
	}
	
	/* 발주취소(기안생성) */
	function expoCancel(){
		var isSelected = false;
		var iRowCount  = GridObj.GetRowCount();
		
		for(var i=0;i<iRowCount;i++){
			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == true){
				isSelected = true;

				break;
			}
		}

		if(isSelected == false) {
			alert('선택된 행이 없습니다.');
			return;
		}
		
		var ws = GridObj;
		var servletUrl = "/servlets/order.bpo.po1_bd_upd3";
		if(!confirm("발주취소(기안생성)처리를 하시겠습니까?")){
			return;
		}

		var grid_array  = getGridChangedRows(GridObj, "SEL");
		var cols_ids    = grid_col_id;
		var params;
		params = "?mode=setExPoCancel";
		params +="&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor(servletUrl+params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj, myDataProcessor, "SEL",grid_array);		
	}
	

	/* 발주대개환원 */
	 function poReturn(){
		var isSelected = false;
		var iRowCount  = GridObj.GetRowCount();
		
		for(var i=0;i<iRowCount;i++){
			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == true){
				isSelected = true;

				break;
			}
		}

		if(isSelected == false) {
			alert('선택된 행이 없습니다.');
			return;
		}
		
		var ws = GridObj;
		var servletUrl = "/servlets/order.bpo.po1_bd_upd3";
		if(!confirm("재발주를 위해 발주대기로 환원 하시겠습니까?")){
			return;
		}

		var grid_array  = getGridChangedRows(GridObj, "SEL");
		var cols_ids    = grid_col_id;
		var params;
		params = "?mode=setPoReturn";
		params +="&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor(servletUrl+params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj, myDataProcessor, "SEL",grid_array);		
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
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0071&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=P";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function  SP0071_getCode(ls_ctrl_code, ls_ctrl_name, ls_ctrl_person_id, ls_ctrl_person_name) {

	form1.ctrl_code.value = ls_ctrl_code;
	form1.ctrl_name.value = ls_ctrl_name;
	form1.ctrl_person_id.value = ls_ctrl_person_id;
	form1.ctrl_person_name.value = ls_ctrl_person_name;

}
//공급업체 담당자
function SP0273_Popup() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0273&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=VENDOR_CODE%>";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function  SP0273_getCode(ls_vendor_person_name, ls_dept, ls_vendor_person_mobil, ls_email) {
	document.forms[0].vendor_person_mobil.value	= ls_vendor_person_mobil;
	document.forms[0].vendor_person_name.value  = ls_vendor_person_name;
}
function isEquals(){
	var ws			=	GridObj	;
	var chg_sum		=	eval(ws.GetSummaryBarValue('ITEMSUM','ITEM_AMT',0,false)	);
	var old_sum		=	eval(ws.GetSummaryBarValue('ITEMSUM','HD_ITEM_AMT',0,false)	);

	if(chg_sum != old_sum){
		return false	;
	}else{
		return true		;
	}
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
        opener.doSelect();
        window.close();
        //doQuery();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
//     	JavaCall("doData");
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
    
    for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).cell.wasChanged = true;
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).setValue("1");
    }
    
    if("undefined" != typeof JavaCall) {
    	//JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">

<!--내용시작-->

<form name="form1" method="post" action="/kr/order/bpo/po1_bd_upd3.jsp">
<input type="hidden" name="h_po_no">
<input type="hidden" name="set_company_code">
<input type="hidden" name="SHIPPER_TYPE" value= "D">
<input type="hidden" name="attach_gubun" value="body">
<input type="hidden" name="attach_no"    value="<%=ATTACH_NO%>">
<input type="hidden" name="attach_count" value="">
<input type="hidden" name="att_mode"     value="">
<input type="hidden" name="view_type"    value="">
<input type="hidden" name="file_type"    value="">
<input type="hidden" name="tmp_att_no"   value="">
<input type="hidden" name="hid_pr_no"    id="hid_pr_no"   value="<%=pr_no%>">
<input type="hidden" name="hid_pr_seq"   id="hid_pr_seq"  value="<%=prdt_pr_seq%>">
<input type="hidden" name="hid_exec_no"  id="hid_exec_no" value="<%=exec_no%>">
<input type="hidden" name="hid_po_no"    id="hid_po_no"   value="<%=po_no%>">
<input type="hidden" name="combo"        id="combo"       value="<%=COMBO_M004%>">

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
<% if(wk_type.equals("3")){ %>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		&nbsp;발주대기환원
	</td>
<% }else if(wk_type.equals("2")){ %>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		&nbsp;연단가발주취소
	</td>
<% }else{ %>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		&nbsp;발주 중도종결
	</td>	
<% } %>
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
      							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주번호</td>
      							<td width="30%" class="data_td">
      								<input type="text" name="PO_NO" id="PO_NO" style="width:92%" value="<%=po_no%>" readOnly  style="width:92%; ">
      							</td>
      							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주명</td>
      							<td width="51%" class="data_td" >
      								<input type="text" name="SUBJECT" style="width:92%" value="<%=SUBJECT%>" readOnly >
      							</td>	
    						</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>    		
    						<tr>
      							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업체코드</td>
      							<td width="30%" class="data_td">
      								<input type="text" name="VENDOR_CODE" style="width:92%" value="<%=VENDOR_CODE%>" readOnly  style="">
      							</td>	
      							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업체명</td>
      							<td width="30%" class="data_td">
      								<input type="text" name="VENDOR_NAME" style="width:92%" value="<%=VENDOR_NAME%>" readOnly  style="">
      							</td>
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
    						<tr>
      							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 중도종결자      </td>
      							<td class="data_td" width="30%">
      								<b><input type="text" name="ctrl_person_id" size="12"  readOnly value="<%=user_id%>">
        							<input type="text" name="ctrl_person_name" size="18"  readOnly value="<%=user_name%>"></b>
        							<input type="hidden" name="ctrl_code" size="5" maxlength="5"  readOnly value="<%=CTRL_CODE%>">
        							<input type="hidden" name="ctrl_name" size="25"  readOnly >
      							</td>
      							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주일자</td>
      							<td width="30%" class="data_td"></td>
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
    						<tr>
      							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 지급조건</td>
      							<td width="30%" class="data_td">
      								<%=PAY_TERMS_DESC%>
      							</td>
       							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 통화</td>
      							<td width="30%" class="data_td">
      								<input type="text" name="CUR" size="4" value="<%=CUR%>" readOnly  style="">
      							</td>
    						</tr>
    						<input type="hidden" id="PR_TYPE" 		name="PR_TYPE" 		size="15"  	value="<%=PR_TYPE%>">
    						<input type="hidden" id="PO_TYPE" 		name="PO_TYPE" 		size="15"  	value="<%=PO_TYPE%>">
      						<input type="hidden" id="ORDER_NO" 		name="ORDER_NO" 	size="15"  	value="<%=ORDER_NO%>" >
	  						<input type="hidden" id="ORDER_NAME" 	name="ORDER_NAME" 	size="15" 	value="<%=ORDER_NAME%>" >
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
    						<tr>
      							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주총금액(VAT 포함)</td>
      							<td width="30%" class="data_td">
      								<input type="text" name="EXEC_AMT_KRW" style="width:92%" value="<%=EXEC_AMT_KRW%>" readOnly  style="">
      							</td>
      							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 인수담당자</td>
      							<td width="30%" class="data_td">
      								<input type="text" name="TAKE_USER_NAME" style="width:92%" value="<%=TAKE_USER_NAME%>" readOnly  style="">
      								<input type="hidden" name="TAKE_USER_ID" value="<%=TAKE_USER_ID%>">
      							</td>
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
    						<tr>
      							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 인수자연락처</td>
      							<td width="30%" class="data_td">
								<% if(wk_type.equals("2") || wk_type.equals("3")){ %>
      								<input type="text" name="TAKE_TEL" style="width:92%;" value="<%=TAKE_TEL%>" readOnly style="">
								<% }else{ %>
      								<input type="text" name="TAKE_TEL" style="width:92%; ime-mode:disabled;" value="<%=TAKE_TEL%>" class="inputsubmit" onKeyPress="checkNumberFormat('[0-9]', this);" onKeyUp="return chkMaxByte(20, this, '인수자연락처');">
								<% } %>
      							</td>
      							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공급업체담당자</td>
      							<td width="30%" class="data_td">
      								<input type="text" name="vendor_person_name" size="12"  readOnly	 value="<%=VENDOR_CP_NAME%>">
<%--       								<a href="javascript:SP0273_Popup();"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"></a> --%>
	        						<input type="text" name="vendor_person_mobil" size="18"  readOnly value="<%=VENDOR_MOBILE_NO%>">
<%--       								<input type="text" name="vendor_person_name" size="12"  readOnly	 value="<%=VENDOR_CP_NAME%>"> --%>
<%--       								<a href="javascript:SP0273_Popup();"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"></a> --%>
<%-- 	        						<input type="text" name="vendor_person_mobil" size="18"  readOnly value="<%=VENDOR_MOBILE_NO%>"> --%>
      							</td>
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
    						<tr>
    							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 비고</td>
    							<td class="data_td" colspan="3">
									<textarea name="REMARK" style="width:98%" rows="5" readOnly ><%=REMARK%></textarea>
    							</td>
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
							<% if(wk_type.equals("2")||wk_type.equals("3")){ %>
							<% }else{ %>
    						<tr>
    							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 중도종결사유</td>
    							<td class="data_td" colspan="3">
									<textarea id="END_REMARK" name="END_REMARK" style="width:98%" rows="5" class="input_re_red_area" onKeyUp="return chkMaxByte(500, this, '중도종결사유');"></textarea>
    							</td>
    						</tr>	
							<% } %>
<!-- 							<tr> -->
<%-- 								<td width="15%" class="c_title_1">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 첨부파일</td> --%>
<!-- 								<td class="c_data_1" colspan="3" height="150"> -->
<!-- 									<iframe name="attachFrame" width="620" height="150" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe> -->
<!-- 									<br>&nbsp; -->
<!-- 								</td> -->
<!-- 							</tr> -->
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
<%
	if (INV_PROGRESS_CNT.equals("0")) {
%>
    					<!-- TD><script language="javascript">btn("javascript:Catalog('CATALOG')",31,"카탈로그")</script></TD-->

<%
	if (wk_type.equals("1")) {
%>
		      			<TD><script language="javascript">btn("javascript:fnSave()","중도종결")</script></TD>
<%
	}
%>
<%
	if (wk_type.equals("2")) {
%>
		      			<TD><script language="javascript">btn("javascript:yrpoCancel()","발주취소(연단가)")</script></TD>
<%
	}
%>
<%
	if (wk_type.equals("4")) {
%>
		      			<TD><script language="javascript">btn("javascript:expoCancel()","발주취소(기안생성)")</script></TD>
<%
	}
%>
<%
	if (wk_type.equals("3")) {
%>
		      			<TD><script language="javascript">btn("javascript:poReturn()","발주대기환원")</script></TD>
<%
	}
%>
<%
	}
%>
		      			<TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>

<table width="98%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td height="1" class="cell"></td>
	<!-- wisegrid 상단 bar -->
</tr>
<tr>
	<td>
		<%-- <%=WiseTable_Scripts("100%","300")%> --%>
	</td>
</tr>
</table>


</form>
<form>
   <input type="hidden" name="po_no">
</form>

<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>


</s:header>
<s:grid screen_id="AR_003" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
<%-- <script language="javascript">rMateFileAttach('S','R','PO',form1.attach_no.value);</script> --%>


