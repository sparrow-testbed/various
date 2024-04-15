<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("IV_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "IV_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<%
	String sign_status = JSPUtil.nullToEmpty(request.getParameter("sign_status"));
	String user_id         = info.getSession("ID");
	String company_code    = info.getSession("COMPANY_CODE");
	String house_code      = info.getSession("HOUSE_CODE");
	String menu_profile_code = info.getSession("MENU_PROFILE_CODE");
	String to_date          = SepoaDate.getShortDateString();
	String from_date        = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1);
	String user_name   	   = info.getSession("NAME_LOC");
	String ctrl_code       = info.getSession("CTRL_CODE");
	String LB_SIGN_STATUS = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M994", sign_status);
	String LB_APP_STATUS = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M100", "");
	String srch_user_id = user_id;
	String srch_user_name = user_name;

// 	if(menu_profile_code.equals("MUP141000001")){
// 		srch_user_id = "";
// 		srch_user_name ="";
// 	}
	
	String[] ctrl_codes = info.getSession("CTRL_CODE").split("&");
	String ctrl_yn = "N";
	for(int v1=0; v1 < ctrl_codes.length; v1++){
		if(ctrl_codes[v1].equals("P01")){
			ctrl_yn = "Y";
			break;
		}
	}

	String gate = JSPUtil.nullToRef(request.getParameter("gate"),"");
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<script language="javascript">
	var	servletUrl = "";
	var mode;
	var checked_count = 0;
	var G_USER_ID	=	"<%=user_id%>";
	var IDX_SEL				;
	var IDX_PO_NO			;
	var IDX_PO_SUBJECT		;
	var IDX_PO_CREATE_DATE	;
	var IDX_VENDOR_CODE		;
	var IDX_VENDOR_NAME		;
	var IDX_PO_TTL_AMT		;
	var IDX_INV_PERSON_ID	;
	var IDX_ADD_USER_ID		;
	var IDX_IV_NO			;
	var IDX_DP_TEXT			;
	var IDX_DP_PAY_TERMS	;
	var IDX_IV_SEQ			;
	var IDX_DP_PERCENT		;
	var IDX_DP_AMT			;
    var IDX_INV_DATE		;
    var IDX_CONFIRM_DATE	;
    var IDX_SIGN_STATUS		;
    var IDX_SIGN_REMARK		;
    var IDX_PAY_FLAG		;
    var IDX_INV_NO			;
    var IDX_INV_QTY			;
    var IDX_INV_SUBJECT		;
    var IDX_ATTACH_NO		;
    var IDX_ATTACH_POP		;
    var IDX_ORDER_NO		;
    var IDX_ORDER_SEQ		;
    var IDX_ORDER_COUNT		;
    var IDX_EVAL_FLAG		;
    var IDX_EVAL_FLAG_DESC	;
    var IDX_EVAL_REFITEM	;
    var IDX_EVAL_DATE		;
   var chkrow;

   
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
		var po_no = SepoaGridGetCellValueId(GridObj, rowId, "PO_NO");
		var inv_no = SepoaGridGetCellValueId(GridObj, rowId, "INV_NO");
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
		if(header_name == "INV_NO") {
			if(inv_no == ""){
				alert("검수요청 번호가 없습니다.");
			}else{
				var url = "../procure/invoice_detail.jsp";
				var param = "";
				param += "?popup_flag_header=true";
				param += "&po_no="+SepoaGridGetCellValueId(GridObj, rowId, "PO_NO");
				param += "&inv_no="+SepoaGridGetCellValueId(GridObj, rowId, "INV_NO");
				PopupGeneral(url+param, "IvDetailPop", "", "", "1000", "600");
			}
		}else if(header_name == "PO_NO"){
			var url = "../procure/po_detail.jsp";
			var param = "";
			param += "?popup_flag_header=true";
			param += "&po_no="+SepoaGridGetCellValueId(GridObj, rowId, "PO_NO");
			PopupGeneral(url+param, "PoDetailPop", "", "", "1000", "600");
		}else if(header_name == "VENDOR_NAME"){
			//var rfqNo    = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_NO");
			//var rfqCount = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_COUNT");
		    var url = "/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+vendor_code;
			popUpOpen(url, 'GridCellClick', '900', '700');
		} if(header_name == "ATTACH_POP") {
			var attach_no = SepoaGridGetCellValueId(GridObj, rowId, "ATTACH_NO");
			if(attach_no != null && attach_no != "") {
				fnFiledown(GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO")).getValue());	
			}
		}
		
   }
   
   function fnFiledown(attach_no){
		var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
		var b = "fileDown";
		var c = "300";
		var d = "100";
		 
		window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
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
       // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
       if(status == "false") alert(msg);

       if("undefined" != typeof JavaCall) {
       	JavaCall("doQuery");
       } 
       
       document.forms[0].inv_from_date.value = add_Slash( document.forms[0].inv_from_date.value );
       document.forms[0].inv_to_date.value   = add_Slash( document.forms[0].inv_to_date.value   );
       
       return true;
   }

	function setHeader() {
		var f0 = document.forms[0];

// 		GridObj.bHDMoving 			= false;
// 		GridObj.bHDSwapping 			= false;
// 		GridObj.bRowSelectorVisible	= false;
// 		GridObj.strRowBorderStyle 	= "none";
// 		GridObj.nRowSpacing			= 0;
// 		GridObj.strHDClickAction 		= "select";


// 		GridObj.SetColCellSortEnable("PO_CREATE_DATE"		,false);
// 		GridObj.SetColCellSortEnable("PO_TTL_AMT"			,false);
// 		GridObj.SetDateFormat("PO_CREATE_DATE"	,"yyyy/MM/dd");
// 		GridObj.SetDateFormat("INV_DATE"			,"yyyy/MM/dd");
// 		GridObj.SetDateFormat("CONFIRM_DATE"		,"yyyy/MM/dd");
// 		GridObj.SetNumberFormat("PO_TTL_AMT"		,G_format_amt);
// 		GridObj.SetNumberFormat("DP_AMT"			,G_format_amt);

		IDX_SEL				= GridObj.GetColHDIndex("SEL"				);
		IDX_PO_NO			= GridObj.GetColHDIndex("PO_NO"			);
		IDX_PO_SUBJECT		= GridObj.GetColHDIndex("PO_SUBJECT"		);
		IDX_PO_CREATE_DATE	= GridObj.GetColHDIndex("PO_CREATE_DATE"	);
		IDX_VENDOR_CODE		= GridObj.GetColHDIndex("VENDOR_CODE"		);
		IDX_VENDOR_NAME		= GridObj.GetColHDIndex("VENDOR_NAME"		);
		IDX_PO_TTL_AMT		= GridObj.GetColHDIndex("PO_TTL_AMT"		);
		IDX_INV_PERSON_ID	= GridObj.GetColHDIndex("INV_PERSON_ID"	);
		IDX_ADD_USER_ID		= GridObj.GetColHDIndex("ADD_USER_ID"		);
		IDX_IV_NO			= GridObj.GetColHDIndex("IV_NO"			);
		IDX_DP_TEXT			= GridObj.GetColHDIndex("DP_TEXT"			);
		IDX_DP_PAY_TERMS	= GridObj.GetColHDIndex("DP_PAY_TERMS"	);
		IDX_IV_SEQ			= GridObj.GetColHDIndex("IV_SEQ"			);
		IDX_DP_PERCENT		= GridObj.GetColHDIndex("DP_PERCENT"		);
		IDX_DP_AMT			= GridObj.GetColHDIndex("DP_AMT"			);
		IDX_INV_DATE		= GridObj.GetColHDIndex("INV_DATE"		);
		IDX_CONFIRM_DATE	= GridObj.GetColHDIndex("CONFIRM_DATE"	);
		IDX_SIGN_STATUS		= GridObj.GetColHDIndex("SIGN_STATUS"		);
		IDX_SIGN_REMARK		= GridObj.GetColHDIndex("SIGN_REMARK"		);
		IDX_PAY_FLAG		= GridObj.GetColHDIndex("PAY_FLAG"		);
		IDX_INV_NO			= GridObj.GetColHDIndex("INV_NO"			);
		IDX_INV_SUBJECT		= GridObj.GetColHDIndex("INV_SUBJECT" 	);
		IDX_INV_QTY			= GridObj.GetColHDIndex("INV_QTY"			);
		IDX_ATTACH_NO		= GridObj.GetColHDIndex("ATTACH_NO"		);
		IDX_ATTACH_POP		= GridObj.GetColHDIndex("ATTACH_POP"		);
		IDX_ORDER_NO		= GridObj.GetColHDIndex("ORDER_NO"		);
		IDX_EVAL_FLAG		= GridObj.GetColHDIndex("EVAL_FLAG"		);
		IDX_EVAL_FLAG_DESC	= GridObj.GetColHDIndex("EVAL_FLAG_DESC"		);
		IDX_EVAL_REFITEM	= GridObj.GetColHDIndex("EVAL_REFITEM"	);
		IDX_EVAL_DATE		= GridObj.GetColHDIndex("EVAL_DATE"	);
	}

function Add_file(){
	var ATTACH_NO_VALUE = document.forms[0].attach_no.value;
	if("" == ATTACH_NO_VALUE) {
		FileAttach('INV','','');
	} else {
		FileAttachChange('INV', ATTACH_NO_VALUE,'VI');
	}
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
	function doSelect()
	{
		var f0 = document.forms[0];
		
		inv_from_date = del_Slash( f0.inv_from_date.value );
		inv_to_date   = del_Slash( f0.inv_to_date.value   );

		if(!checkDateCommon(inv_from_date)) {
			alert(" 검수요청일자(From)를 확인 하세요 ");
			f0.inv_from_date.focus();
			return;
		}

		if(!checkDateCommon(inv_to_date)) {
			alert(" 검수요청일자(To)를 확인 하세요 ");
			f0.inv_to_date.focus();
			return;
		}
		
// 		GridObj.SetParam("from_date"		,""	);
// 		GridObj.SetParam("to_date"		,""	);
// 		GridObj.SetParam("inv_from_date"	,f0.inv_from_date.value	);
// 		GridObj.SetParam("inv_to_date"	,f0.inv_to_date.value	);
// 		GridObj.SetParam("ctrl_person_id"	,""						);
// 		GridObj.SetParam("sign_status"	,f0.sign_status.value	);
// 		GridObj.SetParam("pay_flag"		,""				     	);
// 		GridObj.SetParam("vendor_code"	,f0.vendor_code.value  	);
// 		GridObj.SetParam("inv_person_id"	,f0.inv_person_id.value );
// 		GridObj.SetParam("po_no"			,f0.po_no.value  		);
// 		GridObj.SetParam("order_no"		,""		);
// 		GridObj.SetParam("dept"			,f0.demand_dept.value	);
// 		GridObj.SetParam("app_status"			,f0.app_status.value	);
// 		GridObj.SetParam("SepoaTABLE_DOQUERY_DODATA","0");
// 		GridObj.SendData(servletUrl);
// 		GridObj.strHDClickAction="sortmulti";

		document.forms[0].inv_from_date.value = del_Slash( document.forms[0].inv_from_date.value );
		document.forms[0].inv_to_date.value   = del_Slash( document.forms[0].inv_to_date.value   );

		var grid_col_id = "<%=grid_col_id%>";
		var param = "mode=getInvoiceList&grid_col_id="+grid_col_id;
		param += dataOutput();
		var url = "../servlets/sepoa.svl.procure.invoice_list";
		GridObj.post(url, param);
		GridObj.clearAll(false);
	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5)
	{

		var f0              = document.forms[0];
		var row             = GridObj.GetRowCount();
		var po_no           = "";
		var shipper         = "";
		var sign_flag       = "";

		if(msg1 == "doData"){
// 			alert(GD_GetParam(GridObj,"0"));

// 			if(GridObj.GetStatus()==1)
// 				doSelect();
		}
		if(msg1 == "doQuery"){
			//GridObj.SetGroupMerge("PO_NO,PO_SUBJECT,PO_CREATE_DATE,VENDOR_NAME,PO_TTL_AMT");
		}
		if(msg1 == "t_imagetext")
		{
			
			if(msg3==IDX_PO_NO) {
				po_no            = GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
			    //window.open("/kr/order/bpo/po3_pp_dis1.jsp"+"?po_no="+po_no,"newWin","width=1024,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
				var url              = "/kr/order/bpo/po3_pp_dis1.jsp";
				var title            = '발주화면상세조회';
				var param = "";
				param = param + "po_no=" + po_no;

				if (po_no != "") {
				    popUpOpen01(url, title, '1024', '600', param);
				}
			    
		    } else if(msg3==IDX_IV_NO){
				po_no            = GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
				iv_no            = GD_GetCellValueIndex(GridObj,msg2,IDX_IV_NO);
				window.open("iv1_pp_dis1.jsp"+"?po_no="+po_no+"&iv_no="+iv_no,"newWin","width=1000,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");

			}else if(msg3==IDX_INV_NO){
				po_no            = GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
				iv_no            = GD_GetCellValueIndex(GridObj,msg2,IDX_IV_NO);
				window.open("inv1_bd_dis1.jsp"+"?inv_no="+msg4+"&po_no="+po_no+"&iv_no="+iv_no+"&gubun=noamt","newWin","width=1000,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
			}else if(msg3==IDX_SIGN_REMARK){
				var remark = GridObj.GetCellValueIndex(msg3,msg2);
				window.open("iv1_pp_dis2.jsp"+"?sign_remark="+remark+"&row="+msg2,"newWin","width=550,height=270,resizable=NO, scrollbars=YES, status=yes, top=0, left=0");
			}else if(msg3==IDX_ATTACH_POP){
				var attach_no = GridObj.GetCellValueIndex(IDX_ATTACH_NO,msg2);
				if("" == attach_no) {
					alert("첨부파일이 없습니다.");
					return;
				} else {
//					FileAttachChange('INV', attach_no,'VI');
					rMateFileAttach('P','R','IV',attach_no,'S');
				}
			}else if(msg3==IDX_VENDOR_NAME) {
				if(msg4==""){
					alert("업체가 없습니다.");
					return;
				}
				var vendor_code = GridObj.GetCellValue("VENDOR_CODE",msg2);
				window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+vendor_code,"ven_bd_con","left=0,top=0,width=900,height=700,resizable=yes,scrollbars=yes");
	    	}
	    	else if(msg3 == IDX_EVAL_FLAG_DESC){	//수행평가
            	var eval_refitem = GD_GetCellValueIndex(GridObj,msg2, IDX_EVAL_REFITEM);
            	var evalname = GD_GetCellValueIndex(GridObj,msg2, IDX_PO_SUBJECT);
            	var evaldate = GD_GetCellValueIndex(GridObj,msg2, IDX_EVAL_DATE);
            	var inv_person_id 	= GD_GetCellValueIndex(GridObj,msg2, IDX_INV_PERSON_ID);
            	
            	if( eval_refitem != ""){
            		evalname = evalname.replace("&","＆");
            		document.forms[0].evalname.value	= evalname;
           			if(GD_GetCellValueIndex(GridObj,msg2, IDX_EVAL_FLAG) == "C" ){  // 평가 완료시
           				if(G_USER_ID == inv_person_id  || "<%=menu_profile_code%>" == "MUP141000001" || "<%=menu_profile_code%>" == "MUP210200001"){
           					
                    	    //window.open("/kr/master/evaluation/eva_bd_ins2_1.jsp?eval_refitem="+eval_refitem+"&evalname="+evalname+"&gate=eproinv&interval="+evaldate+"&closebtn=Y","windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=640,left=0,top=0");	
                          window.open("/kr/master/evaluation/eva_bd_ins2_1.jsp?eval_refitem="+eval_refitem+"&gate=eproinv&interval="+evaldate+"&closebtn=Y","windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=640,left=0,top=0");
           				} else {
           					alert("평가완료 확인 할 수 없습니다.");
                			return;
           				}
           			}else{
                		if(G_USER_ID != inv_person_id  ){
                			alert("검수담당자만 처리할 수 있습니다.");
                			return;
                		}
                	    //window.open("/kr/master/evaluation/eva_bd_ins2_1.jsp?eval_refitem="+eval_refitem+"&evalname="+evalname+"&gate=eproinv&interval="+evaldate+"&closebtn=Y","windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=640,left=0,top=0");           				
                      window.open("/kr/master/evaluation/eva_bd_ins2_1.jsp?eval_refitem="+eval_refitem+"&gate=eproinv&interval="+evaldate+"&closebtn=Y","windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=640,left=0,top=0");
           			}
            	}
            }
		}
	}
//************************************************** Date Set *************************************
// 	function valid_from_date(year,month,day,week) {
// 		var f0 = document.forms[0];
// 		f0.po_from_date.value=year+month+day;
// 	}

// 	function valid_to_date(year,month,day,week) {
// 	    var f0 = document.forms[0];
// 	    f0.po_to_date.value=year+month+day;
// 	}
// 	function inv_valid_from_date(year,month,day,week) {
// 		var f0 = document.forms[0];
// 		f0.inv_from_date.value=year+month+day;
// 	}

// 	function inv_valid_to_date(year,month,day,week) {
// 	    var f0 = document.forms[0];
// 	    f0.inv_to_date.value=year+month+day;
// 	}
	function Approval(val){
		var Sepoa 			= GridObj;
		var iRowCount 		= GridObj.GetRowCount();
		var iCheckedCount 	= 0;
		var iSelectedRow  	= -1;

		for(var i=0;i<iRowCount;i++) {
			if(GD_GetCellValueIndex(GridObj,i,0) == "1") {
				iCheckedCount++;
				iSelectedRow = i;
			}
		}

		if(iCheckedCount < 1) {
			alert(G_MSS1_SELECT);
			return;
		}

    	if(iCheckedCount > 1) {
			alert("하나의 항목만 선택해주세요");
			return;
		}
		var inv_no 			= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_INV_NO);
		var sign_status 	= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_SIGN_STATUS);
		var inv_person_id 	= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_INV_PERSON_ID);
		var sign_remark 	= GridObj.GetCellValueIndex(IDX_SIGN_REMARK,iSelectedRow);
		var eval_status     = GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_EVAL_FLAG);
		var eval_refitem    = GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_EVAL_REFITEM);
		var app_status 		= GridObj.GetCellValue("APP_STATUS", iSelectedRow);
		var prc_gb          = 'I';

		if(G_USER_ID != inv_person_id){
			alert("검수담당자만 처리할 수 있습니다.");
			return;
		}
		
		if(val=='R' && sign_remark==""){
			alert("반송사유를 넣으셔야 합니다.");
			return;
		}
		
		if(sign_status == 'E1') {
			alert("이미 승인된 건 입니다.");
			return;
		}
		
		//if(sign_status =='R' && val=='R'){
		if(sign_status =='R') {
			alert("이미 반송된 건 입니다.");
			return;
		}
		
		if(sign_status =='RE') {
			alert("일부 승인된 건 입니다.");
			return;
		}		
		var app = val=="R"?"반송":"승인";
		<%--
		2011.02.17 이대규 아래 체크로직 제외한다.
		if(val == 'E1'){
	    	if(!(eval_status == "" || eval_status == "N" || eval_status == "C") ){
				alert("평가제외 또는 평가 완료된 건이 아니면 승인 하실 수 없습니다. \n평가등록 화면에서 수행평가를 등록해 주시기 바랍니다.");
				return;
			}
		}
		--%>
		//검수평가를 필수로 실시한다.
// 		if( !( eval_status == 'C' || eval_status == "N" )){
// 			alert("평가제외 또는 평가 완료된 건이 아니면 검수결과등록을 하실 수 없습니다. \n평가대상상태를 확인해주세요.");
// 			return;
// 		}
		// 검수완료 팝업
		window.open("inv1_bd_confirm1.jsp"+"?inv_no="+inv_no+"&eval_refitem="+eval_refitem+"&prc_gb="+prc_gb,"newWin","width=1000,height=630,resizable=YES,scrollbars=YES,status=yes,top=0,left=0");
		
		/*if(confirm(app+" 하시겠습니까?")){
			GridObj.SetParam("mode",			"approval");
			GridObj.SetParam("inv_no",		inv_no);
			GridObj.SetParam("sign_status",	val);
			GridObj.SetParam("sign_remark",	sign_remark);
			GridObj.SetParam("eval_refitem",	eval_refitem);
			GridObj.SetParam("SepoaTABLE_DOQUERY_DODATA","1");
			GridObj.SendData(servletUrl, "ALL", "ALL");
		}*/
	}

	//검수취소
	function Tly_Cancel() {
		var grid_array  = getGridChangedRows(GridObj, "SEL");
		var wise 		= GridObj;
		var iCheckedRow = Number(checkedOneRow('SEL'))-1;
	    if(iCheckedRow < 0)
	        return;

	    var iSelectedRow  	= -1;
		var inv_no 			= wise.GetCellValue("INV_NO"       ,iCheckedRow);
		//var inv_seq			= wise.GetCellValue("INV_SEQ"      ,iCheckedRow);
		//var pr_no 			= wise.GetCellValue("PR_NO"        ,iCheckedRow);
		//var pr_seq 			= wise.GetCellValue("PR_SEQ"       ,iCheckedRow);
		var sign_status 	= wise.GetCellValue("SIGN_STATUS"  ,iCheckedRow);
		var inv_person_id 	= wise.GetCellValue("INV_PERSON_ID",iCheckedRow);
		var eval_status     = wise.GetCellValue("EVAL_FLAG"    ,iCheckedRow);
		var eval_refitem    = wise.GetCellValue("EVAL_REFITEM" ,iCheckedRow);
		var prc_gb          = 'D';
		
		if(G_USER_ID != inv_person_id){
			alert("검수담당자만 처리할 수 있습니다.");
			return;
		}

/*
		if(sign_status == 'E1') {
			alert("이미 승인된 건 입니다.");
			return;
		}
*/
		//if(sign_status =='R' && val=='R'){
		if(sign_status =='R') {
			alert("이미 반송된 건 입니다.");
			return;
		}
/*
		if(sign_status =='RE') {
			alert("일부 승인된 건 입니다.");
			return;
		}
*/
		// 검수취소 팝업
		//window.open("inv1_bd_confirm1.jsp"+"?inv_no="+inv_no+"&inv_seq="+inv_seq+"&pr_no="+pr_no+"&pr_seq="+pr_seq+"&eval_refitem="+eval_refitem+"&prc_gb="+prc_gb,"newWin","width=1000,height=630,resizable=YES,scrollbars=YES,status=yes,top=0,left=0");
		window.open("inv1_bd_confirm1.jsp"+"?inv_no="+inv_no+"&eval_refitem="+eval_refitem+"&prc_gb="+prc_gb,"newWin","width=1000,height=630,resizable=YES,scrollbars=YES,status=yes,top=0,left=0");
	}
	
	function File_Attach(){
		var Sepoa 			= GridObj;
		var iRowCount 		= GridObj.GetRowCount();
		var iCheckedCount 	= 0;
		var iSelectedRow  	= -1;

		for(var i=0;i<iRowCount;i++) {
			if(GD_GetCellValueIndex(GridObj,i,0) == "1") {
				iCheckedCount++;
				iSelectedRow = i;
			}
		}

		if(iCheckedCount < 1) {
			alert(G_MSS1_SELECT);
			return;
		}

    	if(iCheckedCount > 1) {
			alert("하나의 항목만 선택해주세요");
			return;
		}
		var inv_no 			= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_INV_NO);
		var sign_status 	= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_SIGN_STATUS);
		var inv_person_id 	= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_INV_PERSON_ID);
		var sign_remark 	= GridObj.GetCellValueIndex(IDX_SIGN_REMARK,iSelectedRow);
		var eval_status     = GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_EVAL_FLAG);
		var eval_refitem    = GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_EVAL_REFITEM);
		var app_status 		= GridObj.GetCellValue("APP_STATUS", iSelectedRow);
		var prc_gb          = 'F';

		if(G_USER_ID != inv_person_id){
			alert("검수담당자만 처리할 수 있습니다.");
			return;
		}
	
		/*
		if(sign_status == 'E1' && sign_status =='RE') {
			alert("승인된 건만 파일첨부 가능합니다.");
			return;
		}
		*/
		if(sign_status != 'E1') {
			alert("검수완료 건만 파일첨부 가능합니다.");
			return;
		}
				
		window.open("inv1_bd_confirm1.jsp"+"?inv_no="+inv_no+"&eval_refitem="+eval_refitem+"&prc_gb="+prc_gb,"newWin","width=1000,height=630,resizable=YES,scrollbars=YES,status=yes,top=0,left=0");	
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
	// 검수담당자
	function SP9113_Popup(type_tmp) {

		document.forms[0].type_tmp.value = type_tmp;
		/*
		var arrValue = new Array();
		arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
		arrValue[1] = "<%=info.getSession("COMPANY_CODE")%>";
		arrValue[2] = "";
		arrValue[3] = "";
		var arrDesc = new Array();
		arrDesc[0] = "아이디";
		arrDesc[1] = "이름";
		PopupCommonArr("SP9113","SP9113_getCode",arrValue,arrDesc);
*/
		window.open("/common/CO_008.jsp?callback=SP9113_getCode", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}

	function  SP9113_getCode(ls_ctrl_person_id, ls_ctrl_person_name) {
	   var type = document.forms[0].type_tmp.value;

	   if(type == "inv_ctrl")
	   {
		form1.inv_person_id.value         = ls_ctrl_person_id;
		form1.inv_person_name.value       = ls_ctrl_person_name;
	   }else {
	   	form1.Transfer_person_id.value   = ls_ctrl_person_id;
        form1.Transfer_person_name.value = ls_ctrl_person_name;
	   }
	}

	function getVendorCode(setMethod) { popupvendor(setMethod); }
	function setVendorCode( code, desc1, desc2 , desc3) {
		document.forms[0].vendor_code.value = code;
		document.forms[0].vendor_code_name.value = desc1;
	}

	function popupvendor( fun ){
	    window.open("/common/CO_014.jsp?callback=setVendorCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}

	function PopupManager(part)
	{
		var url = "";
		var f = document.forms[0];
	
		if(part == "DEMAND_DEPT")
		{
			window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}
		else if(part == "ADD_USER_ID")
		{
			window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}
	}
	function getDemand(code, text)
	{
		document.forms[0].demand_dept_name.value = text;
		document.forms[0].demand_dept.value = code;
	}
	
	function getAddUser(code, text)
	{
		document.forms[0].add_user_name.value = text;
		document.forms[0].add_user_id.value = code;
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
		var url = "/kr/admin/Sepoapopup/cod_cm_lis1.jsp?code=SP0023&function=SP0023_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=/&desc=담당자ID&desc=담당자명";
		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}
	
	function  SP0023_getCode(USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION) {
	
		form1.Transfer_person_id.value = USER_ID;
		form1.Transfer_person_name.value = USER_NAME_LOC;
	
	}
	
	/*
	    검수담당자 변경
	    - PM이 이관 처리.
	    
	    검수담당자 변경
	    - 구매담당자만 사용할수 있어야 함. (수정)
	*/
	function doTransfer() {
        checked_count = 0;
		rowcount = GridObj.GetRowCount();
		user = "<%=info.getSession("CTRL_CODE")%>".split("&");
		
		var a = user[0];
		user = a.substr(0, 3);
		
	     for(row=rowcount-1; row>=0; row--) {
			if( true == GD_GetCellValueIndex(GridObj,row, IDX_SEL)) {
				checked_count++;
			}

<%-- 			if ("<%=user_id%>" != GD_GetCellValueIndex(GridObj,row, IDX_INV_PERSON_ID)) { --%>
// 				alert("본인의 검수건만 검수담당자를 변경 할 수 있습니다.!");
// 				button_flag = false;
// 				return;
// 			}

		}
	     //MUP141200004
	     
		if("<%=menu_profile_code%>" != "MUP141000001" && "<%=menu_profile_code%>" != "MUP141200004" && "<%=menu_profile_code%>" != "MUP150400001" && "<%=menu_profile_code%>" != "MUP210200001"){
	    	/*alert("검수담당자 변경은 구매담당자만 가능합니다.");*/
	    	alert("검수담당자 변경은 구매담당자,총무부-관리자만 가능합니다.");
	    	return;
	    }
	     

		if(checked_count == 0)  {
			alert("선택한 행이 없습니다.");
			button_flag = false;
			return;
		}

		Transfer_person_id 		= LRTrim(form1.Transfer_person_id.value);
		Transfer_person_name 	= LRTrim(form1.Transfer_person_name.value);

		if(Transfer_person_id == "") {
			alert("새로운 검수담당자를 입력하셔야 합니다.");
			button_flag = false;
			return;
		}

		Message = "검수담당자를 "+Transfer_person_name+"으로 지정 하시겠습니까?";
		
		if(confirm(Message) == 1) {
			

			var grid_array = getGridChangedRows(GridObj, "SEL");
			var cols_ids = "<%=grid_col_id%>";
			var params;
			params = "?mode=charge_transfer";
			params += "&cols_ids=" + cols_ids;
			params += dataOutput();
			myDataProcessor = new dataProcessor("../servlets/sepoa.svl.procure.invoice_list"+params);
			//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
			sendTransactionGrid(GridObj, myDataProcessor, "SEL",grid_array);			
// 			GridObj.SetParam("mode", "charge_transfer");//
// 			GridObj.SetParam("Transfer_person_id", Transfer_person_id);
// 			mode = "doTransfer";
// 			GridObj.SetParam("SepoaTABLE_DOQUERY_DODATA","1");
// 			GridObj.SendData(servletUrl, "ALL", "ALL");
		}

	}//doTransfer End

	function rMateFileAttach(att_mode, view_type, file_type, att_no, company) {
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
			if (company == "B") {			// Buyer
				f.target = "attachBFrame";
			} else if (company == "S") {	// Supplier
				f.target = "attachSFrame";
			}
			f.action = "/rMateFM/rMate_file_attach.jsp";
			f.submit();
		}
	}

	function Approval2(){
		var Sepoa 			= GridObj;
		var iRowCount 		= GridObj.GetRowCount();
		var iCheckedCount 	= 0;
		var iSelectedRow  	= -1;

		/*검수상태*/
		var sign_stuats = "";
		/*결재상태*/
		var app_stuats = "";

		for(var i=0;i<iRowCount;i++)
		{
			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "true")
			{
				iCheckedCount++;
				iSelectedRow = i;

				sign_status = GridObj.GetCellValue("SIGN_STATUS", i);
				app_status = GridObj.GetCellValue("APP_STATUS", i);
			}
		}

		if(iCheckedCount < 1)
		{
			alert(G_MSS1_SELECT);
			return;
		}

    	if(iCheckedCount > 1)
		{
			alert("하나의 항목만 선택해주세요");
			return;
		}

    	/*검수요청상태, 결재반려상태만 가능*/
		//if(sign_status != "P" || app_status != "R" || app_status != "D"){
		//if(sign_status != "P" && app_status != "R"){
		//	alert("상신 할 수 있는 상태가 아닙니다. 결재상태와 검수상태를 확인하세요.");
		//	return;
		//}

		var flag = false;
		if(sign_status == "P" ){
			flag = true;
		}

		if(app_status == "P" || app_status == "E"){
			flag = false;
		}

		if(!flag){
			alert("상신 할 수 있는 상태가 아닙니다. 결재상태와 검수상태를 확인하세요.");
			return;
		}


		var inv_no 			= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_INV_NO);
		var po_no 			= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_PO_NO);
		var sign_status 	= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_SIGN_STATUS);
		/*
		if(G_USER_ID != inv_person_id){
			alert("PM만 승인할 수 있습니다..");
			return;
		}
		if(val=='R' && sign_remark==""){
			alert("반려사유를 넣으셔야 합니다.");
			return;
		}

		if(sign_status == 'E1' ){
			alert("이미 승인된 건 입니다.");
			return;
		}else if(sign_status =='R' && val=='R'){
			alert("이미 반려된 건 입니다.");
			return;
		}*/
		var po_no            = GD_GetCellValueIndex(GridObj,iSelectedRow,IDX_PO_NO);
		var inv_no            = GD_GetCellValueIndex(GridObj,iSelectedRow,IDX_INV_NO);
		window.open("inv1_bd_dis1.jsp"+"?inv_no="+inv_no+"&po_no="+po_no+"&iv_no="+"&gubun=sign","newWin","width=1000,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
	}
    	
	//지우기
	function doRemove( type ){
	    if( type == "vendor_code" ) {
	    	document.forms[0].vendor_code.value = "";
	        document.forms[0].vendor_code_name.value = "";
	    }  
	    if( type == "inv_person_id" ) {
	    	document.forms[0].inv_person_id.value = "";
	        document.forms[0].inv_person_name.value = "";
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
<body onload="javascript:setGridDraw();doSelect();setHeader();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >

<s:header>
<!--내용시작-->
<%@ include file="/include/sepoa_milestone.jsp" %>
<%-- <%if("".equals(gate)){%> --%>
<!-- <table width="100%" border="0" cellspacing="0" cellpadding="0"> -->
<!-- <tr> -->
<!-- 	<td align="left" class="cell_title1">&nbsp; -->
		
<!-- 	</td> -->
<!-- </tr> -->
<!-- </table> -->
<%-- <% --%>
<!-- // } -->
<%-- %> --%>

<form name="form1" >
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
	<input type="hidden" name="kind" id="kind">
	<input type="hidden" name="type_tmp" id="type_tmp" value="">

	<input type="hidden" name="att_mode" id="att_mode"  value="">
	<input type="hidden" name="view_type" id="view_type" value="">
	<input type="hidden" name="file_type" id="file_type"  value="">
	<input type="hidden" name="tmp_att_no" id="tmp_att_no" value="">
    <input type="hidden" name="demand_dept" id="demand_dept">
    
	<input type="hidden" name="evalname" id="evalname" value="">
	
    <tr>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;검수요청일자</td>
      <td class="data_td">
        <s:calendar id_from="inv_from_date" default_from="<%=SepoaString.getDateSlashFormat(from_date) %>" default_to="<%=SepoaString.getDateSlashFormat(to_date) %>" id_to="inv_to_date" format="%Y/%m/%d" />
      </td>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체코드</td>
      <td class="data_td">
      	<input type="text" name="vendor_code" id="vendor_code" size="15" class="inputsubmit" style="ime-mode:inactive"  maxlength="10" onkeydown='entKeyDown()' >
        <a href="javascript:getVendorCode('setVendorCode')"><img src="/images/ico_zoom.gif" width="19" height="19" align="absmiddle" border="0"></a>
        <a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
        <input type="text" name="vendor_code_name" id="vendor_code_name" size="20" class="input_data2" onkeydown='entKeyDown()' >
      </td>
      <td class="title_td">&nbsp;</td>
      <td class="data_td">&nbsp;</td>
    </tr>
	<tr>
		<td colspan="6" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주번호</td>
      <td class="data_td">
      	<input type="text" name="po_no" id="po_no" size="15" style="ime-mode:inactive"  class="inputsubmit" maxlength="20"onkeydown='entKeyDown()' >
      </td>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;검수담당자</td>
      <td class="data_td">
        <b><input type="text" name="inv_person_id" id="inv_person_id" style="ime-mode:inactive"  value="<%=srch_user_id%>" size="15" class="inputsubmit" onkeydown='entKeyDown()' >
        <a href="javascript:SP9113_Popup('inv_ctrl');"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
        <a href="javascript:doRemove('inv_person_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
        <input type="text" name="inv_person_name" id="inv_person_name" size="20" value="<%=srch_user_name%>" class="input_data2" readOnly onkeydown='entKeyDown()' ></b>
        <input type="hidden" name="inv_ctrl_name" id="inv_ctrl_name">
        <input type="hidden" name="inv_ctrl_code" id="inv_ctrl_code">
      </td>
      <td class="title_td">&nbsp;</td>
      <td class="data_td">&nbsp;</td>
    </tr>
 	<tr>
		<td colspan="6" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td width="9%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;검수상태</td>
      <td class="data_td" width="30%">
        <select name="sign_status" id="sign_status" class="inputsubmit">
          <option value="">전체</option>
          <%=LB_SIGN_STATUS%>
        </select>
      </td>
	  <td width="9%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;선정구분</td>
	  <td class="data_td" width="30%">
      	<select id="bid_type_c" name="bid_type_c">
		  <option value="A">전체</option>
		  <option value="D">구매입찰</option>
		  <option value="C">공사입찰</option>
		  <option value="PC">수의계약</option>		  
		</select>
	  </td>
	  <td width="9%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주구분</td>
	  <td class="data_td" width="13%">
      	<select id="po_type" name="po_type">
		  <option value="A">전체</option>
		  <option value="Y">연단가발주</option>
		  <option value="N">연단가발주아님</option>		  
		</select>
	  </td>
    </tr>
    <tr style="display:none;">
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;결재상태</td>
      <td class="data_td" width="35%" colspan="3">
        <select name="app_status" id="app_status" class="inputsubmit" >
          <option value="">전체</option>
		  <option value="E">결재완료</option>
		  <option value="R">결재반려</option>
		  <option value="P">결재진행중</option>
		  <option value="D">결재취소</option>
        </select>
      </td>
<%--
      <td width="15%" class="title_td"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 담당부서</td>
      <td class="data_td" width="35%">
      
       <input type="text" name="demand_dept" size="6" maxlength="6" class="inputsubmit" value='<%=info.getSession("DEPARTMENT")%>' onBlur="javascript: param1 = form1.demand_dept.value; get_Sepoadesc('SP0073', 'form1', this, 'demand_dept_name','values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values='+param1+'&values=','1');">

            <a href="javascript:PopupManager('DEMAND_DEPT');">
                <img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
            </a>
            <input type="text" name="demand_dept_name" size="15" class="input_data2" readonly value='<%=info.getSession("DEPARTMENT_NAME_LOC")%>'>
      </td>
 --%>      
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
    	<%if(ctrl_yn.equals("Y")){%>
    	 	<td width="12%" style="font-weight:bold;font-size:12px;color:#555555;"><img src="../../images/blt_srch.gif">&nbsp;검수담당자변경</td>
	      	<td width="23%" > <b>
	        <input type="text" name="Transfer_person_id" id="Transfer_person_id" size="12" maxlength="5" class="inputsubmit" readOnly > /
	        <input type="text" name="Transfer_person_name" id="Transfer_person_name" size="15" class="inputsubmit" readOnly >
	        <!--a href="javascript:SP0023_Popup();"--><a href="javascript:SP9113_Popup('Transfer');"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>       </b>
      		</td>
      		 <td width="15%" > <b>
	        <table><tr><td><script language="javascript">btn("javascript:doTransfer()","담당자변경")</script></td></tr></table>
      		</td>
      	<%} %>
      		
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
	    	  			<TD><script language="javascript">btn("javascript:doSelect()","조 회")</script></TD>
						<!--
						<TD><script language="javascript">btn("javascript:Approval2()","결재상신")</script></TD>
	    	  			<TD><script language="javascript">btn("javascript:Approval('E1')","승 인")</script></TD>
	    	  			<TD><script language="javascript">btn("javascript:Approval('R')","반 송")</script></TD>
						-->
	    	  			<TD><script language="javascript">btn("javascript:Approval()","검 수")</script></TD>
	    	  			<TD><script language="javascript">btn("javascript:Tly_Cancel()","취 소")</script></TD>
	    	  			<TD><script language="javascript">btn("javascript:File_Attach()","파일 추가")</script></TD>	    	  			
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>

</form>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="IV_001" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>