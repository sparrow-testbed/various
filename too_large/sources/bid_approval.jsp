<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AP_103_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AP_103_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
품의 결제승인목록
--%>
<% String WISEHUB_PROCESS_ID="AP_103_1";%>
<%!
	public String[] parseValue(String value) {
		String token = "@";
		if(value == null) return null;

		Vector v = new Vector();

		String subvalue;
		boolean token_flag = true;
		int start_token_count = 0;
		int end_token_count = 0;

		while(token_flag) {
			end_token_count = value.indexOf(token, end_token_count);

			if(end_token_count == -1) token_flag = false;
			else {
				subvalue = value.substring(start_token_count, end_token_count);
				end_token_count += token.length();
				start_token_count = end_token_count;
				v.addElement(subvalue);
			}
		}

		String[] szvalue = new String[v.size()];
		v.copyInto(szvalue);

		return szvalue;
	}

	public String[] parseValueOp(String value) {
		String token = "@";
		if(value == null) return null;
		//System.out.println("value===>"+value);

		Vector v = new Vector();

		String subvalue;
		boolean token_flag = true;
		int start_token_count = 0;
		int end_token_count = 0;

		while(token_flag) {
			end_token_count = value.indexOf(token, end_token_count);

			if(end_token_count == -1) token_flag = false;
			else {
				subvalue = value.substring(start_token_count, end_token_count);
				end_token_count += token.length();
				start_token_count = end_token_count;
				v.addElement(subvalue.replaceAll("#","@"));
			}
		}

		String[] szvalue = new String[v.size()];
		v.copyInto(szvalue);

		return szvalue;
	}
%>
<%
	String HOUSE_CODE   	= info.getSession("HOUSE_CODE");
	String COMPANY_CODE 	= info.getSession("COMPANY_CODE");
	String ID           	= info.getSession("ID");
	String DEPARTMENT   	= info.getSession("DEPARTMENT");
	String CTRL_CODE		= info.getSession("CTRL_CODE");

	String doc_type			= JSPUtil.nullToEmpty(request.getParameter("doc_type"));	// BID
	String doc_no			= JSPUtil.nullToEmpty(request.getParameter("doc_no"));		// ANN_NO
	String doc_seq			= JSPUtil.nullToEmpty(request.getParameter("doc_seq"));		// BID_COUNT
	String sign_path_seq	= JSPUtil.nullToEmpty(request.getParameter("sign_path_seq"));//결재순번
	String proceeding_flag	= JSPUtil.nullToEmpty(request.getParameter("proceeding_flag"));//결재요청상태(합의, 결재)

	String sign_enable 		= JSPUtil.nullToEmpty(request.getParameter("sign_enable"));
	String attach_no 		= JSPUtil.nullToEmpty(request.getParameter("attach_no"));
	String doc_status		= JSPUtil.nullToEmpty(request.getParameter("doc_status"));

	String BID_NO       	= "";
	String BID_COUNT    	= "";

	String CONT_TYPE1         = "";
	String CONT_TYPE2         = "";
	String CONT_TYPE1_TEXT_D  = "";
	String CONT_TYPE2_TEXT_D  = "";
	String ANN_TITLE          = "";
	String ANN_NO             = "";
	String ANN_DATE           = "";
	String ANN_ITEM           = "";
	String RD_DATE            = "";
	String DELY_PLACE         = "";
	String LIMIT_CRIT         = "";
	String PROM_CRIT          = "";
	String PROM_CRIT_NAME	  = "";
	String APP_BEGIN_DATE     = "";
	String APP_BEGIN_TIME     = "";
	String APP_END_DATE       = "";
	String APP_END_TIME       = "";
	String APP_PLACE          = "";
	String APP_ETC            = "";
	String ATTACH_NO          = "";
	String ATTACH_CNT         = "0";
	String VENDOR_CNT         = "0";
	String VENDOR_VALUES      = "";
	String LOCATION_CNT         = "0";
	String LOCATION_VALUES    = "";
	String ANNOUNCE_DATE      = "";
	String ANNOUNCE_TIME_FROM = "";
	String ANNOUNCE_TIME_TO   = "";
	String ANNOUNCE_AREA      = "";
	String ANNOUNCE_PLACE     = "";
	String ANNOUNCE_NOTIFIER  = "";
	String ANNOUNCE_RESP      = "";
	String DOC_FRW_DATE       = "";
	String ANNOUNCE_COMMENT   = "";
	String ANNOUNCE_FLAG      = "";
	String ANNOUNCE_TEL       = "";
	String BID_STATUS		  = "";
	String ESTM_FLAG          = "";
	String COST_STATUS        = "";
	String BID_BEGIN_DATE     = "";
	String BID_BEGIN_TIME     = "";
	String BID_END_DATE       = "";
	String BID_END_TIME       = "";
	String BID_PLACE          = "";
	String BID_ETC            = "";
	String OPEN_DATE          = "";
	String OPEN_TIME          = "";

	String APP_BEGIN_TIME_HOUR_MINUTE     	= "0000";
	String APP_END_TIME_HOUR_MINUTE   		= "0000";
	String BID_BEGIN_TIME_HOUR_MINUTE     	= "0000";
	String BID_END_TIME_HOUR_MINUTE   		= "0000";
	String OPEN_TIME_HOUR_MINUTE          	= "0000";

	String PR_NO				= "";
	String BID_TYPE				= "";
   	String ESTM_KIND			= "";
	String ESTM_RATE            = "";
	String ESTM_MAX             = "";
	String ESTM_VOTE            = "";
	String FROM_CONT            = "";
	String FROM_CONT_TEXT		= "";
	String FROM_LOWER_BND       = "";
	String ASUMTN_OPEN_YN       = "";

	String CONT_TYPE_TEXT  = "";
	String CONT_PLACE      = "";
	String BID_PAY_TEXT    = "";
	String BID_CANCEL_TEXT = "";
	String BID_JOIN_TEXT   = "";
	String REMARK          = "";
	String ESTM_MAX_VOTE   = "";

	String STANDARD_POINT   = "";
	String TECH_DQ   		= "";
	String AMT_DQ   		= "";
	String BID_EVAL_SCORE	= "";
	String REPORT_ETC		= "";

	String ADD_USER_NAME  = "";
	String SCR_FLAG		  = "U";

%>
<%
		Object[] args = {doc_no, doc_seq}; // ANN_NO, BID_COUNT

		SepoaOut value = null;
		SepoaRemote wr = null;
		String nickName = "p1016d"; //p1009
		String MethodName = "getBDHDPRHDDisplay";
		String conType = "CONNECTION";
		SepoaFormater wf = null;

		//다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
		try {
			wr = new SepoaRemote(nickName,conType,info);
			value = wr.lookup(MethodName,args);
			wf = new SepoaFormater(value.result[0]);
			int rw_cnt = wf.getRowCount();

			BID_NO						 = wf.getValue("BID_NO"            	   ,0);
			BID_COUNT					 = wf.getValue("BID_COUNT"             ,0);
			CONT_TYPE1                   = wf.getValue("CONT_TYPE1"            ,0);
			CONT_TYPE2                   = wf.getValue("CONT_TYPE2"            ,0);
			CONT_TYPE1_TEXT_D			 = wf.getValue("CONT_TYPE1_TEXT_D"     ,0);
			CONT_TYPE2_TEXT_D			 = wf.getValue("CONT_TYPE2_TEXT_D"     ,0);
			ANN_TITLE                    = wf.getValue("ANN_TITLE"             ,0);
			ANN_NO                       = wf.getValue("ANN_NO"                ,0);
			ANN_DATE                     = wf.getValue("ANN_DATE"              ,0);
			ANN_ITEM                     = wf.getValue("ANN_ITEM"              ,0);
			RD_DATE                      = wf.getValue("RD_DATE"               ,0);
			DELY_PLACE                   = wf.getValue("DELY_PLACE"            ,0);
			LIMIT_CRIT                   = wf.getValue("LIMIT_CRIT"            ,0);
			PROM_CRIT                    = wf.getValue("PROM_CRIT"             ,0);
			PROM_CRIT_NAME               = wf.getValue("PROM_CRIT_NAME"        ,0);
			APP_BEGIN_DATE               = wf.getValue("APP_BEGIN_DATE"        ,0);
			APP_BEGIN_TIME               = wf.getValue("APP_BEGIN_TIME"        ,0);
			APP_END_DATE                 = wf.getValue("APP_END_DATE"          ,0);
			APP_END_TIME                 = wf.getValue("APP_END_TIME"          ,0);
			APP_PLACE                    = wf.getValue("APP_PLACE"             ,0);
			APP_ETC                      = wf.getValue("APP_ETC"               ,0);
			ATTACH_NO                    = wf.getValue("ATTACH_NO"             ,0);
			ATTACH_CNT                   = wf.getValue("ATTACH_CNT"            ,0);
			VENDOR_CNT                   = wf.getValue("VENDOR_CNT"            ,0);
			LOCATION_CNT                 = wf.getValue("LOCATION_CNT"          ,0);
			VENDOR_VALUES                = wf.getValue("VENDOR_VALUES"         ,0);
			LOCATION_VALUES              = wf.getValue("LOCATION_VALUES"       ,0);
			ANNOUNCE_DATE                = wf.getValue("ANNOUNCE_DATE"         ,0);
			ANNOUNCE_TIME_FROM           = wf.getValue("ANNOUNCE_TIME_FROM"    ,0);
			ANNOUNCE_TIME_TO             = wf.getValue("ANNOUNCE_TIME_TO"      ,0);
			ANNOUNCE_AREA                = wf.getValue("ANNOUNCE_AREA"         ,0);
			ANNOUNCE_PLACE               = wf.getValue("ANNOUNCE_PLACE"        ,0);
			ANNOUNCE_NOTIFIER            = wf.getValue("ANNOUNCE_NOTIFIER"     ,0);
			ANNOUNCE_RESP                = wf.getValue("ANNOUNCE_RESP"         ,0);
			DOC_FRW_DATE                 = wf.getValue("DOC_FRW_DATE"          ,0);
			ANNOUNCE_COMMENT             = wf.getValue("ANNOUNCE_COMMENT"      ,0);
			ANNOUNCE_FLAG                = wf.getValue("ANNOUNCE_FLAG"         ,0);
			ANNOUNCE_TEL                 = wf.getValue("ANNOUNCE_TEL"          ,0);
			BID_STATUS                   = wf.getValue("BID_STATUS"            ,0);
			ESTM_FLAG                    = wf.getValue("ESTM_FLAG"             ,0);
			COST_STATUS                  = wf.getValue("COST_STATUS"           ,0);
			BID_BEGIN_DATE               = wf.getValue("BID_BEGIN_DATE"        ,0);
			BID_BEGIN_TIME               = wf.getValue("BID_BEGIN_TIME"        ,0);
			BID_END_DATE                 = wf.getValue("BID_END_DATE"          ,0);
			BID_END_TIME                 = wf.getValue("BID_END_TIME"          ,0);
			BID_PLACE                    = wf.getValue("BID_PLACE"             ,0);
			BID_ETC                      = wf.getValue("BID_ETC"               ,0);
			OPEN_DATE                    = wf.getValue("OPEN_DATE"             ,0);
			OPEN_TIME                    = wf.getValue("OPEN_TIME"             ,0);

			APP_BEGIN_TIME_HOUR_MINUTE   = wf.getValue("APP_BEGIN_TIME_HOUR"   ,0) + ":" + wf.getValue("APP_BEGIN_TIME_MINUTE" ,0);
			APP_END_TIME_HOUR_MINUTE     = wf.getValue("APP_END_TIME_HOUR"     ,0) + ":" + wf.getValue("APP_END_TIME_MINUTE"   ,0);
			BID_BEGIN_TIME_HOUR_MINUTE   = wf.getValue("BID_BEGIN_TIME_HOUR"   ,0) + ":" + wf.getValue("BID_BEGIN_TIME_MINUTE" ,0);
			BID_END_TIME_HOUR_MINUTE     = wf.getValue("BID_END_TIME_HOUR"     ,0) + ":" + wf.getValue("BID_END_TIME_MINUTE"   ,0);
			OPEN_TIME_HOUR_MINUTE        = wf.getValue("OPEN_TIME_HOUR"        ,0) + ":" + wf.getValue("OPEN_TIME_MINUTE"      ,0);

			PR_NO                        = wf.getValue("PR_NO"                 	,0);
			BID_TYPE                     = wf.getValue("BID_TYPE"              	,0);

			ESTM_KIND                    = wf.getValue("ESTM_KIND"      		,0);
			ESTM_RATE                    = wf.getValue("ESTM_RATE"              ,0);
			ESTM_MAX                     = wf.getValue("ESTM_MAX"              	,0);
			ESTM_VOTE                    = wf.getValue("ESTM_VOTE"              ,0);
			FROM_CONT                    = wf.getValue("FROM_CONT"              ,0);
			FROM_CONT_TEXT               = wf.getValue("FROM_CONT_TEXT"         ,0);
			FROM_LOWER_BND               = wf.getValue("FROM_LOWER_BND"         ,0);
			ASUMTN_OPEN_YN               = wf.getValue("ASUMTN_OPEN_YN"         ,0);

			CONT_TYPE_TEXT               = wf.getValue("CONT_TYPE_TEXT"      	,0);
			CONT_PLACE                   = wf.getValue("CONT_PLACE"       		,0);
			BID_PAY_TEXT                 = wf.getValue("BID_PAY_TEXT"       	,0);
			BID_CANCEL_TEXT              = wf.getValue("BID_CANCEL_TEXT"        ,0);
			BID_JOIN_TEXT                = wf.getValue("BID_JOIN_TEXT"          ,0);

			REMARK                       = wf.getValue("REMARK"            		,0);
			ESTM_MAX_VOTE                = wf.getValue("ESTM_MAX_VOTE"          ,0);

			STANDARD_POINT               = wf.getValue("STANDARD_POINT"         ,0);
			TECH_DQ                		 = wf.getValue("TECH_DQ"            	,0);
			AMT_DQ                		 = wf.getValue("AMT_DQ"            		,0);
			BID_EVAL_SCORE				 = wf.getValue("BID_EVAL_SCORE"         ,0);
			REPORT_ETC					 = wf.getValue("REPORT_ETC"            	,0);
			ADD_USER_NAME				 = wf.getValue("ADD_USER_NAME"          ,0);


		}catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,"e = " + e.getMessage());
			Logger.dev.println(e.getMessage());
		}finally{
			wr.Release();
		} // finally 끝

		String firstLetterOfBidStatus = BID_STATUS.substring(0, 1);
		String title 	= "";
		String title2 	= "";

		if("A".equals(firstLetterOfBidStatus)){
			title 	= "입찰공고";
			title2 	= "입 찰 공 고";
		}else if("U".equals(firstLetterOfBidStatus)){
			title 	= "정정공고";
			title2 	= "정 정 공 고";
		}else if("C".equals(firstLetterOfBidStatus)){
			title 	= "취소공고";
			title2 	= "취 소 공 고";
		}else {
			title 	= "입찰공고";
			title2 	= "입 찰 공 고";
		}




%>


<%
	  String code = "";
	  String desc = "";
	  String result = "";
	  SepoaListBox wlb = new SepoaListBox();
	  String node_code = wlb.Table_ListBox(request, "SL0034", HOUSE_CODE+"#" + "M002" + "#", "#", "@");
	  StringTokenizer st = new StringTokenizer(node_code,"@");
	  int count = st.countTokens();
	  String[] line = new String[count];

	  for ( int i = 0 ; i < count ; i++ ){
		line[i] = st.nextToken().trim();
	  }
	  for( int j=0; j< line.length ; j++){
		   StringTokenizer std = new StringTokenizer(line[j],"#");
		   code =std.nextToken();
		   desc =std.nextToken();

		   result += desc + "&" + code + "#";
	  }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<%@ include file="/include/include_css.jsp"%>

<%@ include file="/include/sepoa_grid_common.jsp"%>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="AP_103_2"/>  
 			<jsp:param name="grid_obj" value="GridObj_1"/>
 			<jsp:param name="grid_box" value="gridbox_1"/>
 			<jsp:param name="grid_cnt" value="2"/>
</jsp:include>


<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<style type="text/css">
<!--
.style1 {
	color: #000000;
	font-size: 18px;
	font-weight: bold;
}
-->
</style>
<Script language="javascript" type="text/javascript">
//<!--

var Vendor_values   = "<%=VENDOR_VALUES%>";       // 업체 Data
var G_SERVLETURL = "<%=getSepoaServletPath("dt.bidd.bid_approval")%>";

function init()
{
	GD_setProperty(GridObj);
setGridDraw();
setHeader();
	setHeader2()
	setVisibleVendor();
	setVisiblePeriod();
	setVisibleESTM();
}


function setHeader()
{



		GridObj.SetNumberFormat("QTY",G_format_qty);
		GridObj.SetNumberFormat("UNIT_PRICE",G_format_unit);
		GridObj.SetNumberFormat("AMT",G_format_amt);

		INDEX_SELECTED          = GridObj.GetColHDIndex("SELECTED");
		INDEX_DESCRIPTION_LOC   = GridObj.GetColHDIndex("DESCRIPTION_LOC");
		INDEX_UNIT_MEASURE      = GridObj.GetColHDIndex("UNIT_MEASURE");
		INDEX_QTY               = GridObj.GetColHDIndex("QTY");
		INDEX_CUR               = GridObj.GetColHDIndex("CUR");
		INDEX_UNIT_PRICE        = GridObj.GetColHDIndex("UNIT_PRICE");
		INDEX_AMT               = GridObj.GetColHDIndex("AMT");
		INDEX_PR_NO        		= GridObj.GetColHDIndex("PR_NO");
		INDEX_PR_SEQ            = GridObj.GetColHDIndex("PR_SEQ");


		doSelect();
}


// function setHeader2() {
//     GridObj2.AddHeader("SEQ", 		"No.", 		"t_text", 50, 	0, 		false);
//     GridObj2.AddHeader("VENDOR_CODE", "업체코드", 	"t_text", 50, 	100, 	false);
//     GridObj2.AddHeader("VENDOR_NAME", "업체명", 	"t_text", 200, 	200, 	false);     	


//     GridObj2.SetColCellAlign("VENDOR_CODE","center");
//     GridObj2.SetColCellAlign("VENDOR_CODE","center");
// }

function doSelect()
{
	mode = "getBDDTDisplay";
	servletUrl = "/servlets/dt.bidd.bid_approval";

		GridObj.SetParam("mode", mode);
		GridObj.SetParam("PR_NO", "<%=PR_NO%>");
		GridObj.SetParam("BID_NO", "<%=BID_NO%>");
		GridObj.SetParam("BID_COUNT", "<%=BID_COUNT%>");


		GridObj.bSendDataFuncDefaultValidate=false;
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
		GridObj.strHDClickAction="sortmulti";
}

var grid2SelectCnt = 0;
var grid3SelectCnt = 0;
function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
	if (msg1 == "doQuery")
	{
			var sign_url = "/kr/admin/basic/approval2/ap2_pp_lis7.jsp?company_code=<%=COMPANY_CODE%>&doc_type=<%=doc_type%>&doc_no=<%=doc_no%>&doc_seq=<%=doc_seq%>";
			//var sign_popup = window.open(sign_url, "BKWin", "left=1200, top=0, width=400, height=400", "toolbar=no", "menubar=no", "status=yes", "scrollbars=no", "resizable=no");
   			//sign_popup.focus();
   			vendorInsert2()
   			
   			
	}
	if(msg1 == "doData")
	{
		var mode = GD_GetParam(GridObj,0);
		var status = GD_GetParam(GridObj,1);

	}
    if(msg1=="t_imagetext")
    {
    	G_CUR_ROW = msg2;
    	var url = "";

    	//구매요청번호
        if (msg3 == INDEX_PR_NO) {
      		var img_pr_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_PR_NO);
      		window.open("/kr/dt/pr/pr1_bd_dis1.jsp?pr_no="+img_pr_no,"pr1_bd_dis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
		}
		if(msg3 == INDEX_ITEM_NO){
			//if(pr_type=="I")
				window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			//else
			//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
		}
		if(msg3 == INDEX_PO_VENDOR_CODE){
			if(msg4==""){
				alert("업체가 없습니다.");
				return;
			}
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+msg4,"ven_bd_con","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
		}
		if(msg3 == INDEX_SOURCING_NO){
			var send_url = "/kr/dt/rfq/qta_pp_dis1.jsp?st_vendor_code=" + GridObj.GetCellValue("PO_VENDOR_CODE", msg2) + "&st_qta_no=" + GridObj.GetCellValue("SOURCING_NO", msg2) + "&t_flag=Y";
			CodeSearchCommon(send_url,'qta_win1','0','0','1012','650');
		}
    }
}

function vendorInsert2() {
	var vendorArr = Vendor_values.split("@");
	var cnt = 0;
	var SELECTED_COUNT =  parseInt( vendorArr.length / 3);
	
	for(i = 0; i < vendorArr.length; i++){
		if( i % 3 == 0 	&& 	cnt < SELECTED_COUNT){
			vcValue = i == 0 ? vendorArr[i] : vendorArr[i].substring(1);
			GridObj2.AddRow(); 	
			GridObj2.SetCellValue("VENDOR_CODE", cnt, vcValue	);	
			GridObj2.SetCellValue("VENDOR_NAME", cnt, vendorArr[i + 1]);
			cnt++;
		}
	}
}
function getFormatDate(v_date){
	return v_date.substring(0,4)+"/"+v_date.substring(4,6)+"/"+v_date.substring(6);
}

function checkData()
{
	var wise = GridObj;
	var f = document.forms[0];
	var iRowCount = wise.getRowCount();

	for(var i=0;i<iRowCount;i++)
	{

	}

}


function Add_file(){
	var ATTACH_NO_VALUE = document.forms[0].attach_no.value;
	FileAttach('APP',ATTACH_NO_VALUE,'VI');

}

/*
	파일첨부 팝업에서 받아오는 화면
*/
function setAttach(attach_key, arrAttrach, attach_count)
{
	var f = document.forms[0];
    f.attach_no.value = attach_key;
    f.attach_count.value = attach_count;
}
function searchProfile(fc)
{

	if (fc == 'pay_method' ){
	}
    if(fc == "jt_dp_pay_terms") {
	}

	Code_Search(url,'','','','','');
}

function getpay_method(code, text2)
{
	document.forms[0].ADD_PAY_TERMS.value = code;
	document.forms[0].ADD_PAY_TEXT.value = text2;
}
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

function valid_from_date(year,month,day,week) {
	var f0 = document.forms[0];
	f0.valid_from_date.value=year+month+day;
}
function valid_to_date(year,month,day,week) {
	var f0 = document.forms[0];
	f0.valid_to_date.value=year+month+day;
}
function changeContract(){
	var contract_flag = document.forms[0].contract_flag.value;
	var rowCount = GridObj.GetRowCount();
	for( i = 0 ; i < rowCount ; i++ )
		GridObj.SetComboSelectedHiddenValue("CONTRACT_FLAG", i, contract_flag);
}
function RFQComparison(){
	var rfq_no = "";
	var t_rowCount = GridObj.GetRowCount();
	for( i = 0 ; i < t_rowCount ; i++){
		if(rfq_no == ""){
			rfq_no = GridObj.GetCellValue("RFQ_NO",0);
		}
	}
	if(rfq_no == "" || rfq_no.substring(0,2) != "RQ"){
		alert("견적번호가 없습니다.");
		return;
	}
	window.open("/kr/dt/rfq/ebd_bd_dis5.jsp?rfq_no="+rfq_no,"RFQComparison","left=0,top=0,width=1020,height=400,resizable=yes,scrollbars=yes,status=yes");
}

function printOZ(){


}

function goPrPage(){
	var img_pr_no = document.forms[0].pr_no.value;
    window.open("/kr/dt/pr/pr1_bd_dis1.jsp?pr_no="+img_pr_no,"pr1_bd_dis1","left=0,top=0,width=900,height=700,resizable=yes,scrollbars=yes");
}



function download(url)
{
 	location.href = url;
}

function setVisibleVendor() {
		var CONT_TYPE1 = document.forms[0].CONT_TYPE1.value;

		if ( CONT_TYPE1 == "NC" ) {
			for(n=1;n<=4;n++) {
				// document.all["h"+n].style.visibility = "visible";
			}

			for(m=1;m<=4;m++) {
				// document.all["h1"+m].style.visibility = "hidden";
			}

			//document.forms[0].location_values.value = "";
			//document.forms[0].location_count.value = "0";

		} else if ( CONT_TYPE1 == "LC" ) {
			for(m=1;m<=4;m++) {
				document.all["h1"+m].style.visibility = "visible";
			}

			for(n=1;n<=4;n++) {
				document.all["h"+n].style.visibility = "hidden";
			}

			document.forms[0].vendor_values.value = "";
			document.forms[0].vendor_count.value = "0";
		}else {
			for(n=1;n<=4;n++) {
				document.all["h"+n].style.visibility = "hidden";
			}

			document.forms[0].vendor_values.value = "";
			document.forms[0].vendor_count.value = "0";

			for(m=1;m<=4;m++) {
				document.all["h1"+m].style.visibility = "hidden";
			}

			//document.forms[0].location_values.value = "";
			document.forms[0].location_count.value = "0";
		}
	}

	function setVisiblePeriod() {
		var CONT_TYPE2 = document.forms[0].CONT_TYPE2.value;
		if ( CONT_TYPE2 == "LP" ) {
			for(n=1;n<=22;n++) {
				document.all["g"+n].style.display = "";
			}
			for(m=1;m<=13;m++) {
				document.all["i"+m].style.display = "none";
			}
			for(x=1;x<=12;x++) {
				//document.all["q"+x].style.display = ""; // 기준점수(1~6), 점수비율(7~12)
				document.all["q"+x].style.display = "none"; // 기준점수(1~6), 점수비율(7~12)
			}
		} else {
			for(n=1;n<=22;n++) {
				document.all["g"+n].style.display = "none";
			}
			for(m=1;m<=13;m++) {
				document.all["i"+m].style.display = "";
			}
			for(x=1;x<=6;x++) {
				document.all["q"+x].style.display = "";
			}
			if (( CONT_TYPE2 == "TE" ) || ( CONT_TYPE2 == "NE" )){
				for(x=1;x<=12;x++) {
					document.all["q"+x].style.display = "";
				}
			}else{
				for(x=1;x<=12;x++) {
					document.all["q"+x].style.display = "none";
				}
			}
		}
		/*
		for(n=1;n<=22;n++) {
			document.all["g"+n].style.display = "none";
		}

		for(m=1;m<=13;m++) {
			document.all["i"+m].style.display = "";
		}
		for(x=1;x<=6;x++) {
			document.all["q"+x].style.display = "";
		}

		for(x=1;x<=12;x++) {
			document.all["q"+x].style.display = "";
		}
		*/
		document.all.q5.style.display = "none";
	}


	function setVisibleESTM()   {
		var ESTM_KIND = document.forms[0].ESTM_KIND.value;

		if ( ESTM_KIND  == "M"  ) {
			for(n=1;n<=5;n++) {
				document.all["e"+n].style.display = "";
			}
		} else {
			for(n=1;n<=4;n++) {
				document.all["e"+n].style.display = "none";
			}
			document.forms[0].ESTM_VOTE.value = "2";
			document.forms[0].ESTM_MAX.value = "";
			document.forms[0].ESTM_RATE.value = "";
		}
	}

	function check_STANDARD_POINT(){
		if(!IsNumber(document.form1.STANDARD_POINT.value)){
			alert("기준 점수는 숫자만 입력 가능합니다.");
			document.forms[0].STANDARD_POINT.focus();
			return;
		}

		var check = parseFloat(document.form1.STANDARD_POINT.value);
		if(check > 100){
			alert("기준 점수는 100을 넘을수 없습니다.");
			document.forms[0].STANDARD_POINT.focus();
			return;
		}
	}

	function check_AMT_DQ(){
		if(!IsNumber(document.form1.AMT_DQ.value)||!IsNumber(document.form1.TECH_DQ.value)){
			alert("점수비율은 숫자만 입력 가능합니다.");
			//document.forms[0].STANDARD_POINT.focus();
			return;
		}

		var AMT_DQ = parseFloat(document.form1.AMT_DQ.value);
		var TECH_DQ = parseFloat(document.form1.TECH_DQ.value);
		if(TECH_DQ+AMT_DQ != 100 && document.form1.TECH_DQ.value != "" && document.form1.AMT_DQ.value != ""){
			alert("점수비율은 100% 입니다.");
			//document.forms[0].AMT_DQ.focus();
			return;
		}
	}

 	function getVendor() {      //업체지정
		var mode;
		var shipper_type = "KR";
		var szRow = "-1";
		var cnt = document.form1.vendor_count.value;

		var url;

		if( cnt == "" || cnt == 0 ) {
			mode = "E";
			url = "../rfq/rfq_pp_ins2.jsp?mode=" + mode + "&szRow=" + szRow + "&SCR_FLAG=<%=SCR_FLAG%>&shipper_type="+shipper_type;
		} else {
			mode = "I";
			url = "../rfq/rfq_pp_ins2.jsp?mode=" + mode + "&szRow=" + szRow + "&SCR_FLAG=<%=SCR_FLAG%>&shipper_type="+shipper_type;
		}
<%--
		if("<%=SCR_FLAG%>" == "U" || "<%=SCR_FLAG%>" == "C" || "<%=SCR_FLAG%>" == "D" || ( "<%=SCR_FLAG%>" == "I" && "<%=BID_STATUS%>" == "UR" )) { // 정정공고건의 경우에도 기존 데이터를 가져온다.
			mode = "BID";
			url = "../rfq/rfq_pp_ins2.jsp?mode=" + mode + "&szRow=" + szRow + "&shipper_type="+shipper_type+"&BID_NO=<%=BID_NO%>&BID_COUNT=<%=BID_COUNT%>&SCR_FLAG=<%=SCR_FLAG%>";
		}
--%>
		window.open( url , "doBuyerSelect_popup","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=580,left=0,top=0");
	}

	function getCompany(szRow) {
		return Vendor_values;
	}

	function getLocation() {      //제한조건
		var mode;
		var shipper_type = "KR";
		var szRow = "-1";
		var cnt = document.form1.location_count.value;

		var url;

		if( cnt == "" || cnt == 0 ) {
			mode = "E";
			url = "../rfq/rfq_pp_ins11.jsp?mode=" + mode + "&szRow=" + szRow + "&SCR_FLAG=<%=SCR_FLAG%>&shipper_type="+shipper_type;
		} else {
			mode = "I";
			url = "../rfq/rfq_pp_ins11.jsp?mode=" + mode + "&szRow=" + szRow + "&SCR_FLAG=<%=SCR_FLAG%>&shipper_type="+shipper_type;
		}

		if("<%=SCR_FLAG%>" == "U" || "<%=SCR_FLAG%>" == "C" || "<%=SCR_FLAG%>" == "D" || ( "<%=SCR_FLAG%>" == "I" && "<%=BID_STATUS%>" == "UR" )) { // 정정공고건의 경우에도 기존 데이터를 가져온다.
			mode = "BID";
			url = "../rfq/rfq_pp_ins11.jsp?mode=" + mode + "&szRow=" + szRow + "&shipper_type="+shipper_type+"&BID_NO=<%=BID_NO%>&BID_COUNT=<%=BID_COUNT%>&SCR_FLAG=<%=SCR_FLAG%>";
		}

		window.open( url , "doBuyerSelect_popup","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=650,height=400,left=0,top=0");
	}

	// 결재선변경
	function changeApprovalLine(doc_type ,doc_no ,doc_seq, sign_path_seq){
		if("<%=proceeding_flag%>" != "P"){
			alert("결재선변경은 결재자만 가능합니다.");
			return;
		}
		CodeSearchCommon("/kr/admin/basic/approval2/ap2_pp_upd3.jsp?doc_type="+doc_type+"&doc_no="+doc_no+"&doc_seq="+doc_seq+ "&sign_path_seq="+sign_path_seq+"&issue_type=&fnc_name=getApproval","pop_up","","","700","320");
	}

	function doExplanation() {
		mode = "D";
		cnt = GridObj.GetRowCount();
		BID_NO = form1.bid_no.value;
		BID_COUNT = form1.bid_count.value;
		SZDATE = form1.szdate.value;
		START_TIME = form1.start_time.value;

		END_TIME = form1.end_time.value;
		PLACE = form1.place.value;
		ANNOUNCE_FLAG = form1.ANNOUNCE_FLAG.value;
		ANNOUNCE_TEL = form1.ANNOUNCE_TEL.value;

		resp = form1.resp.value;
		comment = form1.comment.value;

		szurl = 'ebd_pp_ins1.jsp?mode=' + mode + '&BID_NO=' + BID_NO;
		szurl += '&BID_COUNT=' + BID_COUNT + '&SZDATE=' + SZDATE;
		szurl += '&START_TIME=' + START_TIME + '&END_TIME=' + END_TIME;
		szurl += '&PLACE=' + PLACE + '&ANNOUNCE_FLAG=' + ANNOUNCE_FLAG + '&ANNOUNCE_TEL=' + ANNOUNCE_TEL;
		szurl += '&resp=' + resp + '&SCR_FLAG=<%=SCR_FLAG%>&comment=' + comment;

		if(cnt > 0) window.open(szurl,"ebd_pp_ins1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=860,height=260,left=0,top=0");

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

//-->
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
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.WiseGrid2,strColumnKey, nRow);

    
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

//============================================= Grid2 Script ===================================================
	
//그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
//이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function GridObj_1_doOnRowSelected(rowId,cellInd){}

//그리드 셀 ChangeEvent 시점에 호출 됩니다.
//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function GridObj_1_doOnCellChange(stage,rowId,cellInd){
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
function GridObj_1_doSaveEnd(obj){
	var messsage = obj.getAttribute("message");
	var mode     = obj.getAttribute("mode");
	var status   = obj.getAttribute("status");

	document.getElementById("GridObj_1_message").innerHTML = messsage; // 아이디 주의

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

// 트랜잭션용 함수
function GridObj_1_sendTransactionGrid(){
	var grid_array      = getGridChangedRows(GridObj_1, "Check"); // 선택 칼럼명에 맞춰서
	var row             = 0;
	var gridArrayLength = grid_array.length;
	var gridArrayInfo   = null;
	var checkColIndex   = GridObj_1.getColIndexById("Check");// 선택 칼럼명에 맞춰서
	var gridObj_1Cell   = null;
	var isSetUpdated    = false;
	
	if(grid_array == null){
		alert("grid_array is null.");
		
		return;
	}

	myDataProcessor.init(GridObj_1);
	myDataProcessor.enableDataNames(true);
	myDataProcessor.setTransactionMode("POST", true);
	myDataProcessor.defineAction("doSaveEnd", GridObj_1_doSaveEnd);
	myDataProcessor.setUpdateMode("off");
	
	for(row = 0; row < gridArrayLength; row++){
		gridArrayInfo = grid_array[row];
		gridObj_1Cell = GridObj_1.cells(gridArrayInfo, checkColIndex);
		checked       = gridObj_1Cell.getValue();

		if(checked == "1") {
			isSetUpdated = true;
		}
		else {
			isSetUpdated = false;
		}
		
		myDataProcessor.setUpdated(gridArrayInfo, isSetUpdated);
    }

	myDataProcessor.setUpdateMode("row");
	myDataProcessor.sendData();
	myDataProcessor.setUpdateMode("off");

	GridObj_1_doQueryDuring();
}
</script>



<body>
<s:header>
<form name="form1" method="post">
<input type="hidden" name="sign_status" value="N"> <!-- 저장,결재를 구분하는 플래그 -->
	<input type="hidden" name="bid_amt" value="">

	<input type="hidden" name="attach_values" value="<%=ATTACH_NO%>">
	<input type="hidden" name="vendor_values" value="<%=VENDOR_VALUES%>">
	<input type="hidden" name="location_values" value="<%=LOCATION_VALUES%>">

	<!-- hidden(제안설명회) //-->
	<input type="hidden" name="bid_no" value="<%=BID_NO%>">
	<input type="hidden" name="bid_count" value="<%=BID_COUNT%>">
	<input type="hidden" name="start_time" value="<%=ANNOUNCE_TIME_FROM%>">
	<input type="hidden" name="end_time" value="<%=ANNOUNCE_TIME_TO%>">

	<input type="hidden" name="ANNOUNCE_FLAG" value="<%=ANNOUNCE_FLAG%>">
	<input type="hidden" name="ANNOUNCE_TEL" value="<%=ANNOUNCE_TEL%>">
	<input type="hidden" name="area" value="<%=ANNOUNCE_AREA%>">
	<input type="hidden" name="place" value="<%=ANNOUNCE_PLACE%>">
	<input type="hidden" name="notifier" value="<%=ANNOUNCE_NOTIFIER%>">

	<input type="hidden" name="doc_frw_date" value="<%=DOC_FRW_DATE%>">
	<input type="hidden" name="resp" value="<%=ANNOUNCE_RESP%>">
	<input type="hidden" name="comment" value="<%=ANNOUNCE_COMMENT%>">

	<input type="hidden" name="data1" value="">

	<input type="hidden" name="att_mode"  value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td  height="20"></td>
   </tr>
   <tr>
     <td align="center" class="style1">
		<%=title2%>
     </td>
   </tr>
   <tr>
     <td  height="20">&nbsp;</td>
   </tr>
 </table>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" >
  <tr>
    <td width="29%" valign="top" >
    	<table width="90%" height="92" border="0" cellpadding="0" cellspacing="0">
	  		<tr>
        		<td class="title">공&nbsp;고&nbsp;번&nbsp;호&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=ANN_NO%></td>
      		</tr>
      		<tr>
        		<td height="1" bgcolor="#000000"></td>
      		</tr>
      		<tr>
        		<td class="title">공&nbsp;고&nbsp;일&nbsp;자&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=getFormatDate(ANN_DATE)%></td>
      		</tr>
      		<tr>
        		<td height="1" bgcolor="#000000"></td>
      		</tr>
      		<tr>
        		<td class="title">공&nbsp;&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=ADD_USER_NAME%></td>
      		</tr>
      		<tr>
        		<td height="1" bgcolor="#000000"></td>
      		</tr>
      		<tr>
        		<td class="title">입&nbsp;찰&nbsp;건&nbsp;명&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=ANN_ITEM%></td>
      		</tr>
      		<tr>
        		<td height="1" bgcolor="#000000"></td>
      		</tr>
    	</table>
    </td>
    <td width="*" colspan="2" align="right" >
<!-- 결재라인 시작 -->
    	<table border="0" cellspacing="1" cellpadding="0" bgcolor="#000000" align="right">
      		<tr bgcolor="#FFFFFF">
        		<td width="32" align="center" bgcolor="#CCCCCC" class="c_title_1" >결<br>재</td>
<%
    Object[] obj_sign = {doc_no,doc_type,doc_seq};	//기안자 + 결재자
    SepoaOut value_sign = ServiceConnector.doService(info,"p6029","CONNECTION","getSignPath2",obj_sign);
    SepoaFormater wf_sign = new SepoaFormater(value_sign.result[0]);

    Object[] obj_agree = {doc_no,doc_type,doc_seq}; //합의자
    SepoaOut value_agree = ServiceConnector.doService(info,"p6029","CONNECTION","getSignAgree2",obj_agree);
    SepoaFormater wf_agree = new SepoaFormater(value_agree.result[0]);

    int approvalCnt = wf_sign.getRowCount()-wf_agree.getRowCount() > 0 ?  wf_sign.getRowCount() : wf_sign.getRowCount()-wf_agree.getRowCount() == 0 ? wf_sign.getRowCount() :  wf_agree.getRowCount();   //결재라인수

 	String POSITION_TEXT = "";
 	String USER_NAME_LOC = "";
 	String SIGN_DATE = "";
 	String SIGN_TIME = "";
 	String APP_STATUS = "";
    for(int i = 0 ; i<approvalCnt; i++)
	{
		if(i < wf_sign.getRowCount()){
			POSITION_TEXT 		=	wf_sign.getValue("POSITION_TEXT"			, i);
			USER_NAME_LOC 	    =	wf_sign.getValue("USER_NAME_LOC"			, i);
			SIGN_DATE 	    =	wf_sign.getValue("SIGN_DATE"			, i);
			SIGN_TIME 	    =	wf_sign.getValue("SIGN_TIME"			, i);
			APP_STATUS 	    =	wf_sign.getValue("APP_STATUS"			, i);

%>
	        <td width="110">
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center"><%=POSITION_TEXT%>/<%=USER_NAME_LOC%></td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">
    	<%
       		if(APP_STATUS.equals("A")) { //기안
    	%>
              				기 안<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_2.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else if(APP_STATUS.equals("E")) { // 승인 %>
              				승 인<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_1.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else if(APP_STATUS.equals("R")) { // 반려%>
              				반 려<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_3.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else { %>
              &nbsp;
    	<% } %>
              			</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="20" class="input_data2" align="center"><%=SIGN_DATE%></td>
            		</tr>
        		</table>
        	</td>
<%
		}else {
%>
			 <td width="110">
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
        		</table>
        	</td>
<%
		}// end of if
	}//end of for
%>
      </tr>
	  <tr bgcolor="#FFFFFF">
      	<td width="32" align="center" bgcolor="#CCCCCC" class="c_title_1" >합<br>의</td>
<%

 	POSITION_TEXT = "";
 	USER_NAME_LOC = "";
 	SIGN_DATE = "";
 	SIGN_TIME = "";
 	APP_STATUS = "";

    for(int i = 0 ; i<approvalCnt; i++)
	{
		if(i < wf_agree.getRowCount()){
			POSITION_TEXT 	=	wf_agree.getValue("POSITION_TEXT"			, i);
			USER_NAME_LOC 	=	wf_agree.getValue("USER_NAME_LOC"			, i);
			SIGN_DATE 	    =	wf_agree.getValue("SIGN_DATE"			, i);
			SIGN_TIME 	    =	wf_agree.getValue("SIGN_TIME"			, i);
			APP_STATUS 	    =	wf_agree.getValue("APP_STATUS"			, i);

%>
	        <td>
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center"><%=POSITION_TEXT%></td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">
    	<%
       		if(APP_STATUS.equals("A")) { //기안
    	%>
              				기 안<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_2.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else if(APP_STATUS.equals("E")) { // 승인 %>
              				승 인<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_1.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else if(APP_STATUS.equals("R")) { // 반려%>
              				반 려<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_3.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else { %>
              &nbsp;
    	<% } %>
              			</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="20" class="input_data2" align="center"><%=SIGN_DATE%></td>
            		</tr>
        		</table>
        	</td>
<%
		}else {
%>
			 <td>
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
        		</table>
        	</td>
<%
		}// end of if
	}//end of for
%>
      </tr>
	</table>
<!-- 결재라인 끝-->
</td>
</tr>
</table>

<br>
<script language="javascript">rdtable_top1()</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td height="30" align="right">
			<TABLE cellpadding="0">
	      		<TR>
	      		<% if ("Y".equals(doc_status)) { %>
	      			<TD><script language="javascript">btn("javascript:opener.btnApprovalAll('2','1','<%=doc_no%>','<%=doc_seq%>')",13,"승 인")</script></TD>
		      		<TD><script language="javascript">btn("javascript:opener.btnApprovalAll('3','1','<%=doc_no%>','<%=doc_seq%>')",1,"반 려")</script></TD>
		      		<TD><script language="javascript">btn("javascript:changeApprovalLine('<%=doc_type%>','<%=doc_no%>','<%=doc_seq%>','<%=sign_path_seq%>')",24,"결재선변경")</script></TD>
		      	<% } %>
		      	<%--
	      			<TD><script language="javascript">btn("javascript:printOZ()",5,"인 쇄")</script></TD>
	      		--%>
	      			<TD><script language="javascript">btn("javascript:window.close()",36,"닫 기")   </script></TD>
	      		</TR>
  			</TABLE>
  		</td>
	</tr>
</table>
<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
	<tr>
	  <td width="22%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 공고번호</td>
	  <td class="c_data_1" width="35%">
		<input type="text" name="ANN_NO" value="<%=ANN_NO%>" class="input_data2" readonly style="widhth:100%;">
	  </td>
	  <td  width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 공고일자</td>
	  <td  width="35%" class="c_data_1">
		<input type="text" name="ANN_DATE" value="<%=getFormatDate(ANN_DATE)%>" size="8"  maxlength="8"  class="input_data2" readOnly style="ime-mode:disabled;width:100%;" onKeyPress="checkNumberFormat('[0-9]');">
	  </td>
	</tr>
	<tr>
	  <td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 입찰건명</td>
	  <td class="c_data_1" width="35%" colspan="3">
		<input type="text" name="ANN_ITEM" size="95" style="ime-mode:active;width:100%;" value="<%=ANN_ITEM.replaceAll("\"", "&quot;")%>" class="input_data2" readOnly>
	  </td>
	</tr>
	<tr>
	  <td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 입찰방법</td>
	  <td class="c_data_1" width="35%" colspan = "3">
	  	<input type="hidden" name="CONT_TYPE1" value="<%=CONT_TYPE1%>">&nbsp;&nbsp;&nbsp;&nbsp
		<input type="hidden" name="CONT_TYPE2" value="<%=CONT_TYPE2%>">
		<input type="text"   class="input_data2" name="CONT_TYPE1_TEXT_D" value="<%=CONT_TYPE1_TEXT_D%>" size="15" readOnly>&nbsp;&nbsp;&nbsp;&nbsp
		<input type="text"   class="input_data2" name="CONT_TYPE2_TEXT_D" value="<%=CONT_TYPE2_TEXT_D%>" size="15" readOnly>
	  </td>
	</tr>

	<tr id="q1">
	  <td class="c_title_1" width="15%" id="q2"> <span id="q3"></span></td>
	  <td class="c_data_1" width="35%" id="q4"><span id="q5">기준점수
		<input type="text" name="STANDARD_POINT" size="4"  maxlength="3"  class="input_data2"  onblur="check_STANDARD_POINT()" value="<%=STANDARD_POINT%>"  id=q6  readOnly>
		</span></td>
	  <td class="c_data_1" width="15%" id="q7" colspan="2"> <span id="q8">점수비율</span> [
	  <span id="q11">기술</span><span id="q12">제안서</span>
		<input type="text" name="TECH_DQ" size="4"  maxlength="3"  class="input_data2"  onblur="check_AMT_DQ()" value="<%=TECH_DQ%>"  id="q9"  readOnly>%
		 : 가격
		<input type="text" name="AMT_DQ"  value="<%=AMT_DQ%>" size="4"   maxlength="4"  onblur="check_AMT_DQ()" class="input_data2" readOnly id="q10" >%
		]&nbsp;&nbsp;&nbsp;&nbsp;
		<!--
		평가배점 <input type="text" name="BID_EVAL_SCORE" value="<%--=BID_EVAL_SCORE--%>" size="4" maxlength="4" class="input_data2" readOnly >
		-->
		</td>
	</tr>

	<tr>
	  <td  width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 입찰방법상세</td>
	  <td  width="35%" class="c_data_1" colspan="3">
		<input type="text" name="CONT_TYPE_TEXT"  value="<%=CONT_TYPE_TEXT%>"  class="input_data2" size="95" maxlength="50" readOnly>
	  </td>
	</tr>
    <tr>
	  <td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 입찰장소</td>
	  <td class="c_data_1" width="35%" colspan="3">
		<input type="text" name="CONT_PLACE" style="ime-mode:active;width:100%" class="input_data2" value="<%=CONT_PLACE%>" readOnly>
	  </td>
	</tr>

	<tr id="i11">
	  <td class="c_title_1" width="15%" id="i12"> <span id="i1"> <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 참가신청일시</span></td>
	  <td class="c_data_1" width="35%" colspan="3"    id="i13"><span id="i5">
		<input type="text" name="APP_BEGIN_DATE" size="10"  maxlength="8"  class="input_data2"  value="<%=getFormatDate(APP_BEGIN_DATE)%>"  id=i2  readOnly style="ime-mode:disabled;" onKeyPress="checkNumberFormat('[0-9]');">
<!-- 		<a id=i3><img src="../../images/button/butt_calender.gif" height="19" align="absmiddle"   border="0" id=i4 style="width:0;"></a> -->
		<input type="text" name="APP_BEGIN_TIME_HOUR_MINUTE" size="4"  value="<%=APP_BEGIN_TIME_HOUR_MINUTE%>" maxlength="4"  class="input_data2" readOnly id=i6  style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]');">
		&nbsp;&nbsp;~&nbsp;&nbsp;
		<input type="text" name="APP_END_DATE" size="10"  maxlength="8"  class="input_data2"  value="<%=getFormatDate(APP_END_DATE)%>"  id=i7  readOnly style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]');">
<!-- 		<a id=i8><img src="../../images/button/butt_calender.gif" width="22"   height="19" align="absmiddle" border="0" id=i9 style="width:0;"></a> -->
		<input type="text" name="APP_END_TIME_HOUR_MINUTE"   value="<%=APP_END_TIME_HOUR_MINUTE%>" size="4" maxlength="4"  class="input_data2" readOnly  id=i10  style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]');">
	  </td>
	</tr>

	<tr id="g1">
	  <td class="c_title_1" width="15%" id="g2"> <span id="g3"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 입찰일시</span></td>
	  <td class="c_data_1" width="35%" colspan="3" id="g4">
	  <span id="g5">
		<input type="text" name="BID_BEGIN_DATE" size="10"  maxlength="8"  class="input_data2"  value="<%=getFormatDate(BID_BEGIN_DATE)%>"  id=g6  readOnly style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]');">
<!-- 		<a id=g7><img src="../../images/button/butt_calender.gif" height="19" align="absmiddle" border="0" id=g8 style="width:0;"></a> -->
		<input type="text" name="BID_BEGIN_TIME_HOUR_MINUTE"  value="<%=getFormatDate(BID_BEGIN_TIME_HOUR_MINUTE)%>" size="4"   maxlength="4"  class="input_data2" readOnly id=g9  style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]');">
		&nbsp;&nbsp;~&nbsp;&nbsp;
		<input type="text" name="BID_END_DATE" size="10"  maxlength="8"  class="input_data2"  value="<%=getFormatDate(BID_END_DATE)%>"  id=g10     readOnly style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]');">
<!-- 		<a id=g11><img src="../../images/button/butt_calender.gif" height="19" align="absmiddle"    border="0" id=g12 style="width:0;"></a> -->
		<input type="text" name="BID_END_TIME_HOUR_MINUTE"  value="<%=BID_END_TIME_HOUR_MINUTE%>" size="4" maxlength="4"  class="input_data2" readOnly  id=g13 onBlur="bin_end_time_event()"  style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]');">
	  </span>
	  </td>
	</tr>

	<tr id="g14">
	  <td class="c_title_1" width="15%" id="g15"><span id="g16"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 개찰일시</span></td>
	  <td class="c_data_1" width="35%" colspan="3" id="g17">
	  <span id="g18">
		<input type="text" name="OPEN_DATE" size="10"  maxlength="8"  class="input_data2" value="<%=getFormatDate(OPEN_DATE)%>"  id=g19  readOnly style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]');">
<!-- 		<a id=g20><img src="../../images/button/butt_calender.gif" height="19" align="absmiddle" border="0" id=g21 style="width:0;"></a> -->
		<input type="text" name="OPEN_TIME_HOUR_MINUTE"  value="<%=OPEN_TIME_HOUR_MINUTE%>" size="4"    maxlength="4"  class="input_data2" readOnly  id=g22  style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]');">
	  </span>
	  </td>
	</tr>

	<tr>
	  <td  width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 입찰참가자격</td>
	  <td  width="35%" class="c_data_1" colspan="3">
		<textarea name="LIMIT_CRIT" cols="95" rows="3" maxlength="500" class="inputsubmit" readOnly><%=LIMIT_CRIT%></textarea>
	  </td>
	</tr>

	<tr>
	  <td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 입찰보증금 납부 및 귀속</td>
	  <td class="c_data_1" width="35%" colspan="3">
		<input type="text" name="BID_PAY_TEXT" class="input_data2" value="<%=BID_PAY_TEXT%>" readOnly style="width:100%;">
	  </td>
	</tr>
	<tr>
	  <td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 입찰무효</td>
	  <td class="c_data_1" width="35%" colspan="3">
		<input type="text" name="BID_CANCEL_TEXT" size="95" class="input_data2" value="<%=BID_CANCEL_TEXT%>" readOnly style="widhth:100%;">
	  </td>
	</tr>
	<tr>
	  <td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 입찰참가 등록</td>
	  <td class="c_data_1" width="35%" colspan="3">
		<input type="text" name="BID_JOIN_TEXT" size="95" class="input_data2" value="<%=BID_JOIN_TEXT%>" readOnly style="widhth:100%;">
	  </td>
	</tr>
	<tr>
	  <td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 문의사항</td>
	  <td class="c_data_1" width="35%" colspan="3">
		<input type="text" name="REMARK" size="95" class="input_data2" value="<%=REMARK%>" readOnly style="widhth:100%;">
	  </td>
	</tr>

	<tr style="display:none;">
	  <td  width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 예정가격</td>
	  <td class="c_data_1"    width="35%">
	  <b>
		<select name="ESTM_KIND" class="input_data2"onChange="setVisibleESTM()" disabled>
		  <option value="U" selected>단일예가</option>
		  <option value="M" >복수예가</option>
		</select>
	  </b>
	  </td>
	  <td  width="50%" class="c_title_1" colspan="2"><span    id="e1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 예비가격범위
		<input type="text" name="ESTM_RATE" size="3" maxlength="2" value="<%=ESTM_RATE%>" readOnly  id=e2>
		%&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<span id="e3">사용예비가격/추첨수

		<input type="hidden" name="ESTM_MAX_VOTE" >
		<input type="text" name="ESTM_MAX" size="3" maxlength="2" value="<%=ESTM_MAX%>" onblur="check_ESTM_MAX()"   readOnly   id=e4>
		<input type="text" name="ESTM_VOTE" size="2" maxlength="1" readOnly value="<%=ESTM_VOTE%>" onblur="check_ESTM_VOTE()"    readOnly  id=e5>
		</span>
	  </td>
	</tr>
	<tr>
	  <td  width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 낙찰자선정기준</td>
	  <td  width="35%" class="c_data_1" colspan="3">
	  	<input type="text" name="PROM_CRIT" value="<%=PROM_CRIT_NAME%>" class="input_data2" readOnly  style="widhth:100%;">
	    <script>
	    	function avengerkim() {
	    		f = document.forms[0];
	    		if (f.PROM_CRIT.value=='A') {
	    			f.FROM_LOWER_BND.value='0';
	    			f.FROM_LOWER_BND.readOnly = true;
	    		} else {
	    			f.FROM_LOWER_BND.value='80';
	    			f.FROM_LOWER_BND.readOnly = '';
	    		}
	    	}
	    </script>
	    <input type="hidden" size="20" value="<%=FROM_CONT_TEXT%>" name="FROM_CONT_TEXT" class="input_data2" readonly >
 		<input type="hidden" size="3" value="<%=FROM_CONT%>" name="FROM_CONT" class="input_data2" readonly >
	  	<input type="hidden" name="FROM_LOWER_BND" value="<%=FROM_LOWER_BND%>">
	  </td>
	</tr>
	<!--
	<tr>
	  <td  width="15%" class="c_title_1"><img src="/images/<//%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 낙찰하한율</td>
	  <td class="c_data_1" colspan="3">
	  	<b><input type="text" name="FROM_LOWER_BND" size="3" maxlength="2" class="input_data2" value="<//%=FROM_LOWER_BND%>" readOnly style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]');">%</b>
	  </td>
	</tr>
	-->
	<tr>
	  	<td class="c_title_1" width="15%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 납기일자</td>
	  	<td class="c_data_1" width="35%">
			<input type="text" name="RD_DATE" size="10"   maxlength="8"  class="input_data2"   value="<%=getFormatDate(RD_DATE)%>"  readOnly  style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]');">
		</td>
	  	<td class="c_title_1" width="15%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 납품장소</td>
	  	<td class="c_data_1" width="35%">
			<input type="text" style="ime-mode:active;width:100%;" name="DELY_PLACE" size="95"   maxlength="80"  class="input_data2"   value="<%=DELY_PLACE%>"  readOnly>
		</td>
	</tr>
	<tr>
	  <td  width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 기타사항</td>
	  <td  width="35%" class="c_data_1" colspan="3">
		<textarea name="BID_ETC" style="ime-mode:active" rows="5" cols="95" class="inputsubmit" readOnly><%=BID_ETC%></textarea>
	  </td>
	</tr>
	<tr>
	  <td  width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 보고사항</td>
	  <td  width="35%" class="c_data_1" colspan="3">
		<textarea name="REPORT_ETC" style="ime-mode:active" rows="5" cols="95" class="inputsubmit" readOnly><%=REPORT_ETC%></textarea>
	  </td>
	</tr>
</table>

<table>
<tr><td></td></tr>
</table>
<script language="javascript">rdtable_bot1()</script>

<%
if(!"".equals(ANNOUNCE_FLAG)){
%>
<TABLE width="98%" border="0" cellspacing="0" cellpadding="0">
<TR>
	<TD height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
	  		<td><script language="javascript">btn("javascript:doExplanation()",7,"제안설명회")</script>
				<input type="hidden" name="szdate" size="8" value="<%=ANNOUNCE_DATE%>" style='border-style: none 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px' readonly >
			</td>
		</TR>
		</TABLE>
	</TD>
</TR>
</TABLE>
<%
}
%>

<s:grid screen_id="AP_103_1" grid_obj="GridObj" grid_box="gridbox"/>
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="1" class="cell"></td>
		<!-- wisegrid 상단 bar -->
	</tr>
	<tr>
		<td align="center">
<%-- 			<%=WiseTable_Scripts("100%","200")%> --%>
			<div id="gridbox_1" name="gridbox_1" width="100%" style="background-color:white;"></div>
		</td>
	</tr>
</table>
<br>
<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
	<tr>
    	<td  width="22%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 첨부파일</td>
    	<td  width="" class="c_data_1" colspan="3">
    		<div id='attach_list1'>
    			<iframe name="attachFrame" width="620" height="150" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
			</div>
		</td>
  	</tr>
</table>

<%-- 결재자 의견 --%>
<jsp:include page="/include/approvalOpinion.jsp" >
	<jsp:param name="doc_no" 	value="<%=doc_no%>"/>
	<jsp:param name="doc_seq" 	value="<%=doc_seq%>"/>
	<jsp:param name="doc_type" 	value="<%=doc_type%>"/>
</jsp:include>
</form>
<script language="javascript">rMateFileAttach('S','R','BD',"<%=ATTACH_NO%>");</script>
</s:header>
</body>
<s:footer/>
</html>






