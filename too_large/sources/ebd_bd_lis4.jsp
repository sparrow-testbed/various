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
%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BR_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BR_004";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON = "/images/ico_zoom.gif"; 
	
	boolean isAdmin = isAdmin(info);

%>
<%--
	입찰요청접수(DOC)
--%>
<%
	String house_code = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
	String ctrl_code = info.getSession("CTRL_CODE");
	
	String purchaser_id = "";
	String purchaser_nm = "";
	
	Config conf = new Configuration();
	String all_admin_profile_code = "";
	String admin_profile_code = "";
	String session_profile_code = info.getSession("MENU_TYPE");
	String readOnly = "";
	
	try {
		all_admin_profile_code = conf.get("wise.all_admin.profile_code."+info.getSession("HOUSE_CODE"));
		admin_profile_code = conf.get("wise.admin.profile_code."+info.getSession("HOUSE_CODE"));
	}
	catch (Exception e1) {
		
		all_admin_profile_code = "";
		admin_profile_code = "";
	}
	
	if (session_profile_code.equals(all_admin_profile_code) || session_profile_code.equals(admin_profile_code)) {
		purchaser_id = "";
		purchaser_nm = "";
	}
	else{
		purchaser_id = info.getSession("ID");
		purchaser_nm = info.getSession("NAME_LOC");
		readOnly = "readonly";
	}

	String LB_PR_STATUS 	= ListBox(request, "SL0007",  house_code+"#M637#", "");
	String LB_CREATE_TYPE 	= ListBox(request, "SL9997",  house_code+"#M113#B#", "");
	String WISEHUB_PROCESS_ID="BR_004";%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- Ajax lib include한다. utf-8로 씌여졌으므로 charset은 반드시 utf-8로 기술할 것!! -->
<script language="javascript" src="/include/script/js/lib/jslb_ajax.js" charset="utf-8">
</script>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<Script language="javascript" type="text/javascript">
<!--
var mode;
var rfq_pop_id = false;
var ebd_pop_id = false;
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_lis4";
var G_ADD_USER_ID = "<%=info.getSession("ID")%>"
var G_DEPT           = "<%=info.getSession("DEPARTMENT")%>";
var G_HOUSE_CODE   = "<%=house_code%>";
var G_COMPANY_CODE = "<%=company_code%>";

var INDEX_SELECTED			;
var INDEX_PR_NO				;
var INDEX_SUBJECT			;
var INDEX_ADD_DATE			;
var INDEX_RETURN_HOPE_DAY	;
var INDEX_DEMAND_DEPT_NAME	;
var INDEX_ADD_USER_NAME		;
var INDEX_ITEM_NO			;
var INDEX_DESCRIPTION_LOC	;
var INDEX_PURCHASER_NAME	;
var INDEX_UNIT_MEASURE		;
var INDEX_PR_QTY     		;
var INDEX_CUR       		;
var INDEX_UNIT_PRICE     	;
var INDEX_PR_AMT     		;
var INDEX_PR_KRW_AMT     	;
var INDEX_REC_VENDOR_NAME	;
var INDEX_DEMAND_DEPT		;
var INDEX_ADD_USER_ID		;
var INDEX_VENDOR_CODE		;
var INDEX_SIGN_STATUS		;
var INDEX_PR_TYPE			;
var INDEX_PLANT_CODE		;
var INDEX_SHIPPER_TYPE		;
var INDEX_CTRL_CODE			;
var INDEX_PR_SEQ 			;
var INDEX_DELY_TO_ADDRESS 		;
var INDEX_DELY_TO_ADDRESS_NAME 	;
var INDEX_DELY_TO_LOCATION 		;
var INDEX_DELY_TO_LOCATION_NAME ;
var INDEX_RD_DATE 				;
var INDEX_PURCHASE_LOCATION 	;
var INDEX_CTRL_NAME 			;
var INDEX_MAKER_NAME		;

var Send_Data = "";

function init() {
	setGridDraw();
	setHeader();
	doSelect();
}

function setHeader() {
	GridObj.strHDClickAction="sortmulti";

	INDEX_SELECTED				= GridObj.GetColHDIndex("SELECTED"			);
	INDEX_PR_STATUS         	= GridObj.GetColHDIndex("PR_STATUS"			);
	INDEX_PR_STATUS_FLAG    	= GridObj.GetColHDIndex("PR_STATUS_FLAG"		);
	INDEX_PR_NO					= GridObj.GetColHDIndex("PR_NO"				);
	INDEX_SUBJECT				= GridObj.GetColHDIndex("SUBJECT"				);
	INDEX_ADD_DATE				= GridObj.GetColHDIndex("ADD_DATE"			);
	INDEX_RETURN_HOPE_DAY		= GridObj.GetColHDIndex("RETURN_HOPE_DAY"		);
	INDEX_DEMAND_DEPT_NAME		= GridObj.GetColHDIndex("DEMAND_DEPT_NAME"	);
	INDEX_ADD_USER_NAME			= GridObj.GetColHDIndex("ADD_USER_NAME"		);
	INDEX_ITEM_NO				= GridObj.GetColHDIndex("ITEM_NO"				);
	INDEX_DESCRIPTION_LOC		= GridObj.GetColHDIndex("DESCRIPTION_LOC"		);
	INDEX_SPECIFICATION			= GridObj.GetColHDIndex("SPECIFICATION"		);
	INDEX_PURCHASER_ID			= GridObj.GetColHDIndex("PURCHASER_ID"		);
	INDEX_PURCHASER_NAME		= GridObj.GetColHDIndex("PURCHASER_NAME"		);
	INDEX_UNIT_MEASURE 			= GridObj.GetColHDIndex("UNIT_MEASURE"		);
	INDEX_PR_QTY     			= GridObj.GetColHDIndex("PR_QTY"				);
	INDEX_CUR       			= GridObj.GetColHDIndex("CUR"					);
	INDEX_UNIT_PRICE     		= GridObj.GetColHDIndex("UNIT_PRICE"			);
	INDEX_PR_AMT     			= GridObj.GetColHDIndex("PR_AMT"				);
	INDEX_PR_KRW_AMT     		= GridObj.GetColHDIndex("PR_KRW_AMT"			);
	INDEX_REC_VENDOR_NAME		= GridObj.GetColHDIndex("REC_VENDOR_NAME"		);
	INDEX_DEMAND_DEPT			= GridObj.GetColHDIndex("DEMAND_DEPT"			);
	INDEX_ADD_USER_ID	    	= GridObj.GetColHDIndex("ADD_USER_ID"			);
	INDEX_REC_VENDOR_CODE	    = GridObj.GetColHDIndex("REC_VENDOR_CODE"		);
	INDEX_SIGN_STATUS	    	= GridObj.GetColHDIndex("SIGN_STATUS"			);
	INDEX_PR_TYPE	    		= GridObj.GetColHDIndex("PR_TYPE"				);
	INDEX_PLANT_CODE	    	= GridObj.GetColHDIndex("PLANT_CODE"			);
	INDEX_SHIPPER_TYPE	    	= GridObj.GetColHDIndex("SHIPPER_TYPE"		);
	INDEX_CTRL_CODE	    		= GridObj.GetColHDIndex("CTRL_CODE"			);
	INDEX_PR_SEQ 				= GridObj.GetColHDIndex("PR_SEQ"				);
	INDEX_DELY_TO_ADDRESS 		= GridObj.GetColHDIndex("DELY_TO_ADDRESS"			);
	INDEX_DELY_TO_ADDRESS_NAME 	= GridObj.GetColHDIndex("DELY_TO_ADDRESS_NAME"	);
	INDEX_DELY_TO_LOCATION 		= GridObj.GetColHDIndex("DELY_TO_LOCATION"		);
	INDEX_DELY_TO_LOCATION_NAME = GridObj.GetColHDIndex("DELY_TO_LOCATION_NAME"	);
	INDEX_RD_DATE 				= GridObj.GetColHDIndex("RD_DATE"					);
	INDEX_PURCHASE_LOCATION 	= GridObj.GetColHDIndex("PURCHASE_LOCATION"		);
	INDEX_CTRL_NAME 			= GridObj.GetColHDIndex("CTRL_NAME"				);
	INDEX_INFO_VENDOR			= GridObj.GetColHDIndex("INFO_VENDOR"				);
	INDEX_CREATE_TYPE			= GridObj.GetColHDIndex("CREATE_TYPE"				);
	INDEX_REQ_TYPE				= GridObj.GetColHDIndex("REQ_TYPE"				);
	INDEX_HUMAN_NAME_LOC		= GridObj.GetColHDIndex("HUMAN_NAME_LOC"			);
	INDEX_TECHNIQUE_GRADE		= GridObj.GetColHDIndex("TECHNIQUE_GRADE"			);
	INDEX_TECHNIQUE_FLAG		= GridObj.GetColHDIndex("TECHNIQUE_FLAG"			);
	INDEX_TECHNIQUE_TYPE		= GridObj.GetColHDIndex("TECHNIQUE_TYPE"			);
	INDEX_BID_STATUS			= GridObj.GetColHDIndex("BID_STATUS"				);
	INDEX_BID_PR_NO				= GridObj.GetColHDIndex("BID_PR_NO"				);
	INDEX_INPUT_FROM_DATE	   	= GridObj.GetColHDIndex("INPUT_FROM_DATE"			);
	INDEX_INPUT_TO_DATE			= GridObj.GetColHDIndex("INPUT_TO_DATE"			);
	INDEX_ATTACH_NO				= GridObj.GetColHDIndex("ATTACH_NO"			);
	INDEX_ATT_COUNT				= GridObj.GetColHDIndex("ATT_COUNT"			);
	INDEX_MAKER_NAME		    = GridObj.GetColHDIndex("MAKER_NAME"			);

	GridObj.strHDClickAction="sortmulti";
}

function doSelect(){
	var f    = document.form1;
	var wise = GridObj;

	if(LRTrim(f.add_date_start.value) == "" || LRTrim(f.add_date_end.value) == ""){
		alert("생성일자를 입력하셔야 합니다.");
		
		return;
	}

	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=getReqBidItemList";
	
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	GridObj.post( G_SERVLETURL, params );
	GridObj.clearAll(false);
}

function checkUpdate(wise, row){
	if(GD_GetCellValueIndex(GridObj,row, INDEX_ADD_USER_ID) != G_ADD_USER_ID) {
		alert("수정할 권한이 없습니다. 사유)생성한 ID와 같지 않습니다.");
		
		return false;
	}

	if(GD_GetCellValueIndex(GridObj,row, INDEX_DEMAND_DEPT) != G_DEPT) {
		alert("수정할 권한이 없습니다.사유)생성한 부서와 같지 않습니다.");
		
		return false;
	}

	var SIGN_STATUS = GD_GetCellValueIndex(GridObj,row, INDEX_SIGN_STATUS);

	if( (SIGN_STATUS=='T') || (SIGN_STATUS=='R') || (SIGN_STATUS=='D')){
		return true;
	}

	alert("수정/삭제는 작성중이거나 결재취소/반려된 항목일때 가능합니다.");
	
	return false;
}

function getDataParams(BID_TYPE){
	var wise = GridObj;

	var SEND_BID_TYPE = "&BID_TYPE="+BID_TYPE;

	var PR_NO            = "";
	var PR_SEQ           = "";
	var ITEM_NO          = "";
	var DESCRIPTION_LOC  = "";
	var UNIT_MEASURE     = "";
	var PR_QTY           = "";
	var CUR              = "";
	var PR_UNIT_PRICE    = "";
	var SPECIFICATION    = "";
	var RD_DATE          = "";
	var DELY_TO_ADDRESS  = "";
	var PLANT_CODE       = "";
	var PR_TYPE          = "";

	var PR_AMT            = "";
	var CTRL_NAME         = "";
	var DEMAND_DEPT_NAME  = "";
	var VENDORCNT         = "";
	var REC_VENDOR_NAME   = "";
	var SHIPPER_TYPE_NAME = "";
	var CTRL_CODE         = "";
	var VENDOR_CODE       = "";
	var SHIPPER_TYPE      = "";
	var PURCHASE_LOCATION = "";
	var DELY_TO_LOCATION  = "";
	var ADD_USER_NAME     = "";
	var DELY_TO_LOCATION_NAME  = "";
	var PURCHASE_LOCATION = "";
	var PR_TYPE          = "";
	var CREATE_TYPE = "";
	var SUBJECT = "";
	var REQ_TYPE = "";
	var HUMAN_NAME_LOC = "";
	var TECHNIQUE_GRADE = "";
	var TECHNIQUE_FLAG = "";
	var TECHNIQUE_TYPE = "";
	var INPUT_FROM_DATE	= "";
	var INPUT_TO_DATE	= "";
	var ATTACH_NO	= "";
	var ATT_COUNT	= "";
	var PR_KRW_AMT = "";
	var MAKER_NAME = "";
	var chk_cnt = 0;

	for(var i=0;i<GridObj.GetRowCount();i++){
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == "true"){
			var pr_type = GD_GetCellValueIndex(GridObj,i, INDEX_PR_TYPE);

			PR_NO            = PR_NO             + "&PR_NO=" + GD_GetCellValueIndex(GridObj,i, INDEX_PR_NO);
			ITEM_NO          = ITEM_NO           + "&ITEM_NO=" + GD_GetCellValueIndex(GridObj,i, INDEX_ITEM_NO);
			PR_SEQ           = PR_SEQ            + "&PR_SEQ=" + GD_GetCellValueIndex(GridObj,i, INDEX_PR_SEQ);
			DESCRIPTION_LOC  = DESCRIPTION_LOC   + "&DESCRIPTION_LOC=" + ( GD_GetCellValueIndex(GridObj,i, INDEX_DESCRIPTION_LOC) );
			UNIT_MEASURE     = UNIT_MEASURE      + "&UNIT_MEASURE=" + GD_GetCellValueIndex(GridObj,i, INDEX_UNIT_MEASURE);
			PR_QTY           = PR_QTY            + "&PR_QTY=" + GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY);
			PR_AMT    		 = PR_AMT     		 + "&PR_AMT=" + GD_GetCellValueIndex(GridObj,i, INDEX_PR_AMT);
			CUR              = CUR               + "&CUR=" + GD_GetCellValueIndex(GridObj,i, INDEX_CUR);
			PR_UNIT_PRICE    = PR_UNIT_PRICE     + "&PR_UNIT_PRICE=" + GD_GetCellValueIndex(GridObj,i, INDEX_UNIT_PRICE);
			RD_DATE          = RD_DATE           + "&RD_DATE=" + GD_GetCellValueIndex(GridObj,i, INDEX_RD_DATE);
			DELY_TO_ADDRESS  = DELY_TO_ADDRESS   + "&DELY_TO_ADDRESS=" + GD_GetCellValueIndex(GridObj,i, INDEX_DELY_TO_ADDRESS);
			PLANT_CODE       = PLANT_CODE        + "&PLANT_CODE=" + GD_GetCellValueIndex(GridObj,i, INDEX_PLANT_CODE);

			VENDOR_CODE       = VENDOR_CODE        	+ "&VENDOR_CODE="       + GD_GetCellValueIndex(GridObj,i,INDEX_VENDOR_CODE      );
			SHIPPER_TYPE      = SHIPPER_TYPE       	+ "&SHIPPER_TYPE="      + GD_GetCellValueIndex(GridObj,i,INDEX_SHIPPER_TYPE     );
			DELY_TO_LOCATION  = DELY_TO_LOCATION   	+ "&DELY_TO_LOCATION="  + GD_GetCellValueIndex(GridObj,i,INDEX_DELY_TO_LOCATION );
			DELY_TO_LOCATION_NAME     = DELY_TO_LOCATION_NAME      + "&DELY_TO_LOCATION_NAME="     + GD_GetCellValueIndex(GridObj,i,INDEX_DELY_TO_LOCATION_NAME );
			PURCHASE_LOCATION   = PURCHASE_LOCATION	+ "&PURCHASE_LOCATION="   + GD_GetCellValueIndex(GridObj,i,INDEX_PURCHASE_LOCATION   );
			REC_VENDOR_NAME   	= REC_VENDOR_NAME	+ "&REC_VENDOR_NAME="   + GD_GetCellValueIndex(GridObj,i,INDEX_REC_VENDOR_NAME  );
			ADD_USER_NAME   	= ADD_USER_NAME		+ "&ADD_USER_NAME="   + GD_GetCellValueIndex(GridObj,i,INDEX_PURCHASER_NAME   );

			SUBJECT 			= SUBJECT 			+ "&SUBJECT="   + GD_GetCellValueIndex(GridObj,i,INDEX_SUBJECT );    //cjsrm에서 SPECIFICATION을 사용안함으로 CREATE_TYPE을 SPECIFICATION으로 사용.
			CREATE_TYPE 		= CREATE_TYPE 		+ "&CREATE_TYPE="   + GD_GetCellValueIndex(GridObj,i,INDEX_CREATE_TYPE  );    //cjsrm에서 SPECIFICATION을 사용안함으로 CREATE_TYPE을 SPECIFICATION으로 사용.
			PR_TYPE          	= PR_TYPE           + "&PR_TYPE=" + GD_GetCellValueIndex(GridObj,i, INDEX_PR_TYPE);

			REQ_TYPE           	= REQ_TYPE           + "&REQ_TYPE=" + GD_GetCellValueIndex(GridObj,i, INDEX_REQ_TYPE );
			HUMAN_NAME_LOC      = HUMAN_NAME_LOC     + "&CTRL_NAME=" + GD_GetCellValueIndex(GridObj,i, INDEX_HUMAN_NAME_LOC );
			SPECIFICATION     	  = SPECIFICATION      + "&SPECIFICATION=" + GD_GetCellValueIndex(GridObj,i, INDEX_SPECIFICATION );
			TECHNIQUE_GRADE     = TECHNIQUE_GRADE    + "&TECHNIQUE_GRADE=" + GD_GetCellValueIndex(GridObj,i, INDEX_TECHNIQUE_GRADE );
			TECHNIQUE_FLAG      = TECHNIQUE_FLAG     + "&TECHNIQUE_FLAG=" + GD_GetCellValueIndex(GridObj,i, INDEX_TECHNIQUE_FLAG );
			TECHNIQUE_TYPE      = TECHNIQUE_TYPE     + "&TECHNIQUE_TYPE=" + GD_GetCellValueIndex(GridObj,i, INDEX_TECHNIQUE_TYPE );
			INPUT_FROM_DATE		= INPUT_FROM_DATE     + "&INPUT_FROM_DATE=" + GD_GetCellValueIndex(GridObj,i, INDEX_INPUT_FROM_DATE );
			INPUT_TO_DATE		= INPUT_TO_DATE     + "&INPUT_TO_DATE=" + GD_GetCellValueIndex(GridObj,i, INDEX_INPUT_TO_DATE );
			ATTACH_NO			= ATTACH_NO     + "&ATTACH_NO=" + GD_GetCellValueIndex(GridObj,i, INDEX_ATTACH_NO );
			ATT_COUNT			= ATT_COUNT		+ "&ATT_COUNT=" + GD_GetCellValueIndex(GridObj,i, INDEX_ATT_COUNT );
			PR_KRW_AMT			= PR_KRW_AMT			 + "&PR_KRW_AMT=" ;
			CTRL_CODE			= CTRL_CODE		+ "&CTRL_CODE=" + GD_GetCellValueIndex(GridObj,i, INDEX_CTRL_CODE );
			MAKER_NAME			= MAKER_NAME		+ "&MAKER_NAME=" + GD_GetCellValueIndex(GridObj,i, INDEX_MAKER_NAME );

			chk_cnt++;
		}
	}
	
	if(chk_cnt == 0) {
		alert("선택하신 항목이 없습니다.");
	
		return;
	}

	if (BID_TYPE == "EX" ){
		Message = "입찰요청을 생성하시겠습니까?";
	}
	else{
		Message = "견적요청을 생성하시겠습니까?";
	}
	
	if(!confirm(Message) == 1) {
		return;
	}
	else{
		var params = SEND_BID_TYPE + PR_NO + ITEM_NO + PR_SEQ+ DESCRIPTION_LOC+ UNIT_MEASURE+ PR_QTY+ PR_AMT+ CUR+ PR_UNIT_PRICE;
		
		params = params + RD_DATE + DELY_TO_ADDRESS + PLANT_CODE ;
		params = params + CTRL_CODE + VENDOR_CODE + SHIPPER_TYPE;
		params = params + DELY_TO_LOCATION+ DELY_TO_LOCATION_NAME + PURCHASE_LOCATION+ ADD_USER_NAME+ REC_VENDOR_NAME;
		params = params + CREATE_TYPE  + SUBJECT + PR_TYPE;
		params = params + REQ_TYPE + HUMAN_NAME_LOC + SPECIFICATION + TECHNIQUE_GRADE  + TECHNIQUE_FLAG + TECHNIQUE_TYPE ;
		params = params + INPUT_FROM_DATE  + INPUT_TO_DATE + ATT_COUNT + ATTACH_NO + PR_KRW_AMT + MAKER_NAME;

		return params;
	}
}

function doBidding(){
	if(!hasRequreCondition("CONFIRM_USER_ID", "접수를 먼저 해주십시요.")){
		return;
	}

	if(!hasRequreCondition("PURCHASER_ID", "담당자가 아닙니다.", "<%=info.getSession("ID")%>")){
		return;
	}

	var checkCnt=0;
	var cur 	="";
	var pr_data ="";

	var pr_type			= "";
	var req_type		= "";
	var create_type		= "";
	var shipper_type	= "";
	var preferred_bidder_vendor_name = "";

	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			checkCnt ++;
			cur 							= GridObj.GetCellValue("CUR", i);
			preferred_bidder_vendor_name	= GridObj.GetCellValue("PREFERRED_BIDDER_VENDOR_NAME", i);

			if(cur != "KRW"){
				alert("원화만 입찰요청을 하실 수 있습니다.");
				
				return;
			}

			if(preferred_bidder_vendor_name != ""){
				alert("이미 입찰에서 우선협상업체가 선정되었습니다.");
				
				return;
			}

			if(checkCnt == 1){
				pr_type 		= GridObj.GetCellValue("PR_TYPE", i);
				req_type 		= GridObj.GetCellValue("REQ_TYPE", i);
				create_type		= GridObj.GetCellValue("CREATE_TYPE", i);
				shipper_type	= GridObj.GetCellValue("SHIPPER_TYPE", i);
			}

			if(i == GridObj.GetRowCount()-1){
				pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i);
			}
			else {
				pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i) + ",";
			}
		}
	}

	if(checkCnt == 0){
		alert("선택한 항목이 없습니다.");
	
		return;
	}

	if(!confirm("입찰요청 하시겠습니까?")){
		return;
	}

	document.form2.PR_DATA.value 		= pr_data;
	document.form2.PR_TYPE.value		= pr_type;
	document.form2.REQ_TYPE.value		= req_type;
	document.form2.CREATE_TYPE.value	= create_type;
	document.form2.SHIPPER_TYPE.value	= shipper_type;

	var url  = "/sourcing/bd_ann.jsp?BID_STATUS=AR";
	
	window.open("","doBidding","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	
	document.form2.method = "POST";
	document.form2.action = url;
	document.form2.target = "doBidding";
	document.form2.submit();
}

function doBidding_New(){
	var f = document.form2;
	params = getDataParams('EX');

	if(typeof(params) == "undefined") return;

	sendRequest(moveBidding,params,'POST','/servlets/dt.pr.AjaxPR',false,false);
}

function moveBidding(){
	var wise = GridObj;
	var iRowCount = GridObj.GetRowCount();
	var iCheckedCount = 0;
	var subject = "";

	for(var i=0;i<iRowCount;i++){
		subject = GD_GetCellValueIndex(GridObj,i,INDEX_SUBJECT);
		iCheckedCount++;
	}

	url =  "/kr/dt/bidd/ebd_bd_ins1.jsp?BID_STATUS=AR";
	
	var ebd_pop_id = window.open(url,"ebd_pop_id","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
	
	ebd_pop_id.focus();
}

function doRequest(){
	//견적은 KRW, 외화 둘다 할수있다. 하지만 KRW 끼리, 외화끼리만 할수있다.
	//입찰, 역경매, 종가발주는 KRW만 할수있다.
	if(!hasRequreCondition("CONFIRM_USER_ID", "접수를 먼저 해주십시요.")){
		return;
	}

	if(!hasRequreCondition("PURCHASER_ID", "담당자가 아닙니다.", "<%=info.getSession("ID")%>")){
		return;
	}

	var checkCnt=0;
	var cur 			= "";
	var pr_data 		= "";

	var pr_type			= "";
	var req_type		= "";
	var create_type		= "";
	var shipper_type	= "";

	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			checkCnt ++;
			
			if(checkCnt == 1){
				cur 			= GridObj.GetCellValue("CUR", i);
				pr_type 		= GridObj.GetCellValue("PR_TYPE", i);
				req_type 		= GridObj.GetCellValue("REQ_TYPE", i);
				create_type		= GridObj.GetCellValue("CREATE_TYPE", i);
				shipper_type	= GridObj.GetCellValue("SHIPPER_TYPE", i);
			}

			if(i == GridObj.GetRowCount()-1){
				pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i);
			}
			else {
				pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i) + ",";
			}
		}
	}

	if(checkCnt == 0){
		alert("선택하신 항목이 없습니다.");
		
		return;
	}

	if(!hasRequreCondition("CUR", "통화가 같아야합니다.", cur)){
		return;
	}

	if(!confirm("견적요청 하시겠습니까?")){
		return;
	}

	document.form2.PR_DATA.value 		= pr_data;
	document.form2.PR_TYPE.value		= pr_type;
	document.form2.REQ_TYPE.value		= req_type;
	document.form2.CREATE_TYPE.value	= create_type;
	document.form2.SHIPPER_TYPE.value	= shipper_type;

	var url  = "/kr/dt/rfq/rfq_bd_ins1.jsp";
	
	window.open("","doRequest","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
	
	document.form2.method = "POST";
	document.form2.action = url;
	document.form2.target = "doRequest";
	document.form2.submit();
}

function moveRequest(){
	for(var i=0;i<GridObj.GetRowCount();i++){
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == "true"){
			var create_type = GD_GetCellValueIndex(GridObj,i, INDEX_CREATE_TYPE);
			var pr_status = GD_GetCellValueIndex(GridObj,i,INDEX_PR_STATUS_FLAG);
		}
	}

	var url  = "/kr/dt/rfq/rfq_bd_ins1.jsp?create_type="+create_type;

	var ebd_pop_id = window.open(url,"rfq_pop_id","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
}

function doReverseAuction(){
	if(!hasRequreCondition("CONFIRM_USER_ID", "접수를 먼저 해주십시요.")){
		return;
	}

	if(!hasRequreCondition("PURCHASER_ID", "담당자가 아닙니다.", "<%=info.getSession("ID")%>")){
		return;
	}

	var checkCnt=0;
	var cur 	="";
	var pr_data ="";

	var pr_type			= "";
	var req_type		= "";
	var create_type		= "";
	var shipper_type	= "";

	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			checkCnt ++;
			cur = GridObj.GetCellValue("CUR", i);
			
			if(cur != "KRW"){
				alert("원화만 역경매요청을 하실 수 있습니다.");
				
				return;
			}

			if(checkCnt == 1){
				pr_type 		= GridObj.GetCellValue("PR_TYPE", i);
				req_type 		= GridObj.GetCellValue("REQ_TYPE", i);
				create_type		= GridObj.GetCellValue("CREATE_TYPE", i);
				shipper_type	= GridObj.GetCellValue("SHIPPER_TYPE", i);
			}

			if(i == GridObj.GetRowCount()-1){
				pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i);
			}
			else {
				pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i) + ",";
			}
		}
	}

	if(checkCnt == 0){
		alert("선택하신 항목이 없습니다.");
		
		return;
	}

	if(!confirm("역경매요청 하시겠습니까?")){
		return;
	}

	document.form2.PR_DATA.value 		= pr_data;
	document.form2.PR_TYPE.value		= pr_type;
	document.form2.REQ_TYPE.value		= req_type;
	document.form2.CREATE_TYPE.value	= create_type;
	document.form2.SHIPPER_TYPE.value	= shipper_type;

	var url  = "/kr/dt/rat/rat_bd_ins1.jsp";
	window.open("","doReverseAuction","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	
	document.form2.method = "POST";
	document.form2.action = url;
	document.form2.target = "doReverseAuction";
	document.form2.submit();
}

function JavaCall(msg1, msg2, msg3, msg4, msg5){
	var wise = GridObj;

	if(msg1 == "doData"){
		doSelect();
	}
	else if(msg1 == "t_imagetext"){
		if(msg3 == INDEX_PR_NO){
			pr_no = GridObj.GetCellValue(GridObj.GetColHDKey( msg3),msg2);
			window.open('ebd_pp_dis6.jsp?pr_no='+pr_no ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
		}
		else if(msg3 == INDEX_REC_VENDOR_NAME){
			var vendor_code = GD_GetCellValueIndex(GridObj,msg2,INDEX_REC_VENDOR_CODE);
			
			if(vendor_code == ""){
				return;
			}
			
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&CompanyCode=<%=company_code%>&vendor_code="+vendor_code+"&user_type=<%=info.getSession("COMPANY_CODE")%>","ven_bd_con","left=0,top=0,width=950,height=700,resizable=yes,scrollbars=yes");
		}
		else if(msg3 == INDEX_ITEM_NO) {
           	var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);
           	var url = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
           	var ItemWin =window.open(url, 'ItemWin', 'left=30,top=30,width=750,height=550,resizable=yes,scrollbars=yes');
           	ItemWin.focus();
		}
	}
}

function selectCond(wise, selectedRow){
	var wise = GridObj;
	var cur_pr_no  	 = GD_GetCellValueIndex(wise,selectedRow, INDEX_PR_NO);
	var iRowCount   	 = wise.GetRowCount();

	for(var i=0;i<iRowCount;i++){
		if(i==selectedRow){
			continue;
		}

		if(cur_pr_no == GD_GetCellValueIndex(wise,i,INDEX_PR_NO)){
			var flag = "true";
			GD_SetCellValueIndex(wise,i,INDEX_SELECTED,flag + "&","&");
		}
		else{
			var flag = "false";
			GD_SetCellValueIndex(wise,i,INDEX_SELECTED,flag + "&","&");
		}
	}
}

function doReturn(flag) {
	if(!hasRequreCondition("PURCHASER_ID", "담당자가 아닙니다.", "<%=info.getSession("ID")%>")){
		return;
	}

	checked_count = 0;
	var email;
	var pr_name;
		
	rowcount = GridObj.GetRowCount();
		
	for(row=rowcount-1; row>=0; row--) {
		if( true == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
			pr_name = GD_GetCellValueIndex(GridObj,row, INDEX_ADD_USER_NAME);

			checked_count++;
		}
	}

	if(checked_count == 0)  {
		alert("선택하신 항목이 없습니다.");
		
		return;
	}
		
	pMode = "reject";
	msg = "반려하시겠습니까?";
		
	if( !confirm(msg) ){
		return;
	}
		
	window.open('/kr/dt/pr/pr_pp_ins1.jsp?pMode='+pMode+'&email='+email+'&pr_name='+pr_name,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=580,height=340,left=0,top=0");
}//doReturn End

function setReasonParam(memo, pReturn, reason_code, email, pr_name){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var params;
	
	inputParam = "flag=D";
	inputParam = inputParam + "&pTitle_Memo=" + memo;
	inputParam = inputParam + "&reason_code=" + reason_code;
	inputParam = inputParam + "&email=" + email;
	inputParam = inputParam + "&pr_name=" + pr_name;
	inputParam = inputParam + "&req_type=B";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "?mode=reject";
	params += "&cols_ids=<%=grid_col_id%>";
	params += dataOutput();
	
	body.removeChild(form);
	
	return params;
}

function setReason(memo,pReturn,reason_code,email,pr_name) {
	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.pr.pr5_bd_lis2";
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var params     = setReasonParam(memo,pReturn,reason_code,email,pr_name);
	
	myDataProcessor = new dataProcessor(servletUrl + params);
	
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
}//setReason End

function add_date_start(year,month,day,week) {
	document.form1.add_date_start.value=year+month+day;
}

function add_date_end(year,month,day,week) {
	document.form1.add_date_end.value=year+month+day;
}

function MM_goToURL() { //v3.0
	var i, args=MM_goToURL.arguments; document.MM_returnValue = false;
	for (i=0; i<(args.length-1); i+=2){
		eval(args[i]+".location='"+args[i+1]+"'");
	}
}

//enter를 눌렀을때 event발생
function entKeyDown(){
	if(event.keyCode==13){
		window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
		doSelect();
	}
}

// 담당자 지정
function doTransfer() {
	checked_count = 0;
	rowcount = GridObj.GetRowCount();

	for(row=rowcount-1; row>=0; row--) {
		if( true == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
			checked_count++;
		}
	}

	if(checked_count == 0)  {
		alert("선택하여주십시요!");
		
		button_flag = false;
		
		return;
	}

	Transfer_id 			= LRTrim(form1.Transfer_id.value);
	Transfer_name 			= LRTrim(form1.Transfer_name.value);
	Transfer_person_id 		= LRTrim(form1.Transfer_person_id.value);
	Transfer_person_name 	= LRTrim(form1.Transfer_person_name.value);
	Transfer_id 			= Transfer_id.toUpperCase();

	if(Transfer_person_id == "") {
		alert("구매담당자를 입력하셔야 합니다.");
		
		button_flag = false;
		
		return;
	}

	Message = "구매담당을 "+Transfer_person_id+" / "+Transfer_person_name+"으로 지정 하시겠습니까?";
	
	if(confirm(Message) == 1) {
		servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.pr.pr5_bd_lis2";      //p1001.charge_transfer
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		params = "?mode=charge_transfer";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor(servletUrl+params);
		
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
	}
}//doTransfer End

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

function getParam(){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var params;
		
	inputParam = "req_type=B";
		
	var form = fnGetDynamicForm("", inputParam, null);
		
	body.appendChild(form);
		
	params = "mode=doConfirm";
	params += "&cols_ids=<%=grid_col_id%>";
	params += dataOutput();
		
	body.removeChild(form);
		
	return params;
}	

// 접수
function doConfirm(){
	// 구매담당자지정 - 접수 - 소싱
	// 구매담당자 체크
	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.pr.pr5_bd_lis2";

	var chk_cnt = 0;
	
	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == true){
			chk_cnt++;
		}
	}

	if(chk_cnt == 0) {
		alert("선택하신 항목이 없습니다.");
		
		return;
	}

	if(!hasRequreCondition("CONFIRM_USER_ID", "이미 접수되었습니다.", "FULL")){
		return;
	}

	if(hasRequreCondition("PURCHASER_ID", "담당자를 먼저 지정해주십시요.")){
		if(confirm("접수하시겠습니까?")){
			var grid_array = getGridChangedRows(GridObj, "SELECTED");
			var params     = getParam();
			myDataProcessor = new dataProcessor(servletUrl + "?" + params);
			sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);				
		}
	}
}

// 구매담당자 지정여부, 접수여부 체크, 담당자 체크
function hasRequreCondition(_condition , _msg, _emptyOrFull){
	var condition = "";
	_emptyOrFull = _emptyOrFull == null ? "EMPTY" : _emptyOrFull;

	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			condition = GridObj.GetCellValue(_condition, i);
			
			if(_emptyOrFull == "EMPTY"){
				if(condition == ""){
					alert(_msg);
					
					return false;
				}
			}
			else if(_emptyOrFull =="FULL"){
				if(condition != ""){
					alert(_msg);
					
					return false;
				}
			}
			else{	// EMPTY, FULL 값이 아니고 특정한 값
				if(condition != "" && condition != _emptyOrFull){
					alert(_msg);
					
					return false;
				}
			}
		}
	}

	return true;
}

function doModify(){
	checkCnt = 0;
	pr_data  = "";
	
	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			checkCnt ++;
			cur = GridObj.GetCellValue("CUR", i);
			
			pr_data = GridObj.GetCellValue("PR_NO", i);
		}
	}

	if(checkCnt == 0){
		alert("선택하신 항목이 없습니다.");
		
		return;
	}

	if(checkCnt > 1){
		alert("수정은 한건씩만 가능합니다");
		
		return;
	}

	document.form2.PR_NO.value = pr_data;
	
	var url  = "/kr/dt/pr/pr1_bd_ins2.jsp";
	
	window.open("","doModifyBR","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	
	document.form2.method = "POST";
	document.form2.action = url;
	document.form2.target = "doModifyBR";
	document.form2.submit();
}

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
	//var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	CodeSearchCommon(url, 'doc', left, top, width, height);
}

function  SP0023_getCode(USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION) {
	form1.Transfer_id.value = USER_ID;
	form1.Transfer_name.value = USER_NAME_LOC;
	form1.Transfer_person_id.value = USER_ID;
	form1.Transfer_person_name.value = USER_NAME_LOC;
}
	
function SP0352_Popup() {
	/*
	var left = 0;
	var top = 0;
	var width = 670;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0352&function=SP0352_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=/&desc=담당자ID&desc=담당자명";
	//var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	CodeSearchCommon(url, 'doc', left, top, width, height);
	*/
	PopupCommon2("SP0352","SP0352_getCode", "<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>", "담당자ID", "담당자명");
}

function  SP0352_getCode(CTRL_NAME, CTRL_CODE, USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION) {
	form1.Transfer_id.value = CTRL_CODE;
	form1.Transfer_name.value = CTRL_NAME;
	form1.Transfer_person_id.value = USER_ID;
	form1.Transfer_person_name.value = USER_NAME_LOC;
}

function PopupManager(part){
	var url = "";
	var f = document.form1;

	if(part == "DEMAND_DEPT"){
		window.open("/common/CO_009.jsp?callback=getDeptUser", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "ADD_USER_ID"){
		window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "PURCHASER_ID"){
		window.open("/common/CO_008.jsp?callback=getPurUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
}

function getDeptUser(code, text){
	document.form1.demand_dept_name.value = text;
	document.form1.demand_dept.value = code;
}

function getAddUser(code, text){
	document.form1.add_user_name.value = text;
	document.form1.add_user_id.value = code;
}

function getPurUser(code, text){
	document.form1.purchaser_name.value = text;
	document.form1.purchaser_id.value = code;
}
-->
</Script>

<script language="javascript" type="text/javascript">
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
	<%@ include file="/include/include_top.jsp"%>
	<%@ include file="/include/sepoa_milestone.jsp"%>	
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form id="form2" name="form2" method="post" >
		<input type="hidden" id="PR_NO"				    name="PR_NO"				>
		<input type="hidden" id="ITEM_NO"			    name="ITEM_NO"				>
		<input type="hidden" id="PR_NO_H" 			    name="PR_NO_H" 				value="">
		<input type="hidden" id="PR_SEQ_H" 			    name="PR_SEQ_H" 			value="">
		<input type="hidden" id="BUYER_ITEM_NO_H" 	    name="BUYER_ITEM_NO_H" 		value="">
		<input type="hidden" id="DESCRIPTION_LOC_H"     name="DESCRIPTION_LOC_H" 	value="">
		<input type="hidden" id="UNIT_MEASURE_H" 	    name="UNIT_MEASURE_H" 		value="">
		<input type="hidden" id="PR_QTY_H" 			    name="PR_QTY_H" 			value="">
		<input type="hidden" id="UNIT_PRICE_H" 		    name="UNIT_PRICE_H" 		value="">
		<input type="hidden" id="RD_DATE_H" 		    name="RD_DATE_H" 			value="">
		<input type="hidden" id="DELY_TO_ADDRESS_H"     name="DELY_TO_ADDRESS_H" 	value="">
		<input type="hidden" id="PLANT_NAME_H" 		    name="PLANT_NAME_H" 		value="">
		<input type="hidden" id="CHANGE_USER_NAME_H"	name="CHANGE_USER_NAME_H" 	value="">
		<input type="hidden" id="TEL_NO_H" 				name="TEL_NO_H" 			value="">
		<input type="hidden" id="CTRL_CODE_H" 			name="CTRL_CODE_H" 			value="">
		<input type="hidden" id="PLANT_CODE_H" 			name="PLANT_CODE_H" 		value="">
		<input type="hidden" id="CUR_H" 				name="CUR_H" 				value="">
		<input type="hidden" id="PRTYPE_H" 				name="PRTYPE_H" 			value="">
		<input type="hidden" id="dom_loi_flag" 			name="dom_loi_flag" 		value="">
		<input type="hidden" id="mtou_flag" 			name="mtou_flag" 			value="N" readOnly >
		<input type="hidden" id="PR_DATA"				name="PR_DATA"				>
		<input type="hidden" id="PR_TYPE"     			name="PR_TYPE"     			value="">
		<input type="hidden" id="REQ_TYPE"    			name="REQ_TYPE"    			value="B">
		<input type="hidden" id="CREATE_TYPE" 			name="CREATE_TYPE" 			value="">
		<input type="hidden" id="SHIPPER_TYPE" 			name="SHIPPER_TYPE" 		value="">
	</form>
	<form name="form1" action="">
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr style="display:none;">
										<td class="se_cell_title">관리코드</td>
										<td class="se_cell_data" colspan="3">
											<input type="text" id="order_no" name="order_no" style="width:95%" class="inputsubmit"   >
										</td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청일자</td>
										<td width="35%" class="data_td">
											<s:calendar id="add_date_start" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1))%>" format="%Y/%m/%d" cssClass=" "/>
											~
											<s:calendar id="add_date_end" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString())%>" format="%Y/%m/%d" cssClass=" "/>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청담당자</td>
										<td width="35%" class="data_td">
											<input type="text" id="add_user_id" name="add_user_id" size="10" class="inputsubmit"  value='' <%=readOnly%> >
<%
	if(isAdmin){
%>                        
											<a href="javascript:PopupManager('ADD_USER_ID')">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
<%
	}
%>                        
											<input type="text" id="add_user_name" name="add_user_name" size="10" readonly class="input_data2" value=''>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td" style="display: none;">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청구분</td>
										<td width="35%" class="data_td"  style="display: none;">
											<select id="create_type" name="create_type" class="inputsubmit" >
												<option value=''>전체</option>
												<%=LB_CREATE_TYPE%>
											</select>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사전지원요청번호</td>
										<td class="data_td">
											<input type="text" id="pr_no" name="pr_no" style="width:95%" onkeydown='entKeyDown()' class="inputsubmit" >
										</td>
										<td class="data_td" colspan="2">&nbsp;</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청명</td>
										<td width="35%" class="data_td">
											<input type="text" id="subject" name="subject" style="width:95%" onkeydown='entKeyDown()' class="inputsubmit" >
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청부서</td>
										<td width="35%" class="data_td">
											<input type="text" id="demand_dept" name="demand_dept" size="10" class="inputsubmit" value='' >
<%
	if(isAdmin){
%>                        
											<a href="javascript:PopupManager('DEMAND_DEPT');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
<%
	}
%>                        
											<input type="text" id="demand_dept_name" name="demand_dept_name" size="10" class="input_data2" maxlength="15" value='' style="border:0" readOnly>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매담당자</td>
										<td colspan="3" class="data_td">
											<input type="text" id="purchaser_id" name="purchaser_id" size="20" value="<%//=purchaser_id%>" <%=readOnly%> class="inputsubmit" >
<%
	if(isAdmin){
%>				        
											<a href="javascript:PopupManager('PURCHASER_ID')">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
											</a>
<%
	}
%>				        
											<input type="text" id="purchaser_name" name="purchaser_name" size="20" class="input_data2" value="<%//=purchaser_nm%>" readOnly>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
							
<%
	if(isAdmin){
%>
		<br/>
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;담당자지정</td>
										<td colspan="3" >
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="35%">
														<b>
															<input type="text" id="Transfer_person_id"   name="Transfer_person_id" size="10" maxlength="5" class="inputsubmit" readOnly value="<%=info.getSession("ID") %>">
															/
															<input type="text" id="Transfer_person_name" name="Transfer_person_name" size="15" class="inputsubmit" readOnly value="<%=info.getSession("NAME_LOC") %>">
															<a href="javascript:SP0352_Popup();">
																<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
															</a>       
														</b>
														<input type="hidden" id="Transfer_id" name="Transfer_id"  >
														<input type="hidden" id="Transfer_name" name="Transfer_name" >
													</td>
													<td>
<script language="javascript">
btn("javascript:doTransfer()" ,"지 정")     
</script>
													</td>
												</tr>
											</table>
										</td>
									</tr>
<%
	}
%>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br/>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
								<script language="javascript">
									btn("javascript:doSelect()", "조 회");
								</script>
							</TD>
<%
	if(isAdmin){
%>	    	  			
							<TD>
								<script language="javascript">
									btn("javascript:doReturn('D')","반 려");
								</script>
							</TD>
<%
	}
%>	
							<TD>
								<script language="javascript">
									btn("javascript:doRequest()","견적요청");
								</script>
							</TD>
<%--
	if(isAdmin){
%>
							<TD>
								<script language="javascript">
									btn("javascript:doBidding()","입찰요청");
								</script>
							</TD>
							<TD>
								<script language="javascript">
									btn("javascript:doReverseAuction()","역경매");
								</script>
							</TD>
<%
	}
--%>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
</s:header>
<s:grid screen_id="BR_004" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>
</body>
</html>