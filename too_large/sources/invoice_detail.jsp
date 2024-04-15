<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("IV_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "IV_004";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<%
    String house_code = info.getSession("HOUSE_CODE");
    String inv_no          = JSPUtil.nullToEmpty(request.getParameter("inv_no"));
    String po_no           = JSPUtil.nullToEmpty(request.getParameter("po_no"));

    String po_no11 = "";
    String po_name12 = "";
    String project_name21 = "";
    String iv_no31 = "";   //매입계산서번호
    String inv_no32 = "";
    String inv_seq41 = "";
    String app_status42 = "";
    String confirm_date1 = "";
    String po_ttl_amt51 = "";
    String inv_amt52 = "";
    String vendor_name61 = "";
    String vendor_cp_name62 = "";
    String bb71 = "";
    String attach_no81 = "";
    String attach_no_1 = "";
    String inv_date98 = "";
    String inv_person_name99 = "";
    String invoice_status = "";
    String file_name = "";
    String RPT_GETFILENAMES81 = "";
    String RPT_GETFILENAMES1  = "";  
    Object[] obj = {inv_no};
    SepoaOut value = ServiceConnector.doService(info, "IV_001", "CONNECTION", "getIvHeader", obj);

    SepoaFormater wf = new SepoaFormater(value.result[0]);
    wf.setFormat("INV_DATE","YYYY/MM/DD","DATE");
    if(wf.getRowCount() > 0) {
        po_no11           = wf.getValue("po_no11", 0);
        po_name12         = wf.getValue("po_name12", 0);
        project_name21    = wf.getValue("project_name21", 0);
        inv_no32          = wf.getValue("inv_no32", 0);
        inv_seq41         = wf.getValue("inv_seq41", 0);
        app_status42      = wf.getValue("app_status42", 0);
        confirm_date1     = wf.getValue("confirm_date1", 0);
        file_name         = wf.getValue("SRC_FILE_NAME", 0);
        if(confirm_date1.equals("//")) {
        	confirm_date1 = "미완료";	
        }
        
        po_ttl_amt51      = wf.getValue("po_ttl_amt51", 0);
        inv_amt52         = wf.getValue("inv_amt52", 0);
        vendor_name61     = wf.getValue("vendor_name61", 0);
        vendor_cp_name62  = wf.getValue("vendor_cp_name62", 0);
        bb71              = wf.getValue("bb71", 0);
        attach_no81       = wf.getValue("attach_no81", 0);
        attach_no_1       = wf.getValue("attach_no_1", 0);
        inv_date98        = wf.getValue("inv_date98", 0);
        inv_person_name99 = wf.getValue("inv_person_name99", 0);
        invoice_status	  = wf.getValue("sign_status", 0);
        
        RPT_GETFILENAMES81 = wf.getValue("RPT_GETFILENAMES81", 0);
        RPT_GETFILENAMES1  = wf.getValue("RPT_GETFILENAMES1", 0);     
    }
    
    Map<String, String> data2 = new HashMap<String,String>();
	data2.put("inv_no", inv_no);
	data2.put("po_no",po_no);
	data2.put("gridFlag", "TOP");
	
	Object[] obj2 = {data2};
	// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
	SepoaOut value2 = ServiceConnector.doService(info, "IV_001", "CONNECTION", "getIvDetail", obj2);
    SepoaFormater wf2 = new SepoaFormater(value2.result[0]);
    
    
    Map<String, String> data3 = new HashMap<String,String>();
	data3.put("inv_no", inv_no);
	data3.put("po_no",po_no);
	data3.put("gridFlag", "BOTTOM");
	
	Object[] obj3 = {data3};
	// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
	SepoaOut value3 = ServiceConnector.doService(info, "IV_001", "CONNECTION", "getIvDetail", obj3);
    SepoaFormater wf3 = new SepoaFormater(value3.result[0]);
    
    
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_invoice_detail"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
	
	//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
	_rptData.append(po_no11);
	_rptData.append(_RF);
	_rptData.append(po_name12);
	_rptData.append(_RF);
	_rptData.append(app_status42);
	_rptData.append(_RF);
	_rptData.append(confirm_date1);
	_rptData.append(_RF);
	_rptData.append(inv_no32);
	_rptData.append(_RF);
	_rptData.append(inv_seq41);
	_rptData.append(_RF);
	_rptData.append(po_ttl_amt51);
	_rptData.append(_RF);
	_rptData.append(inv_amt52);
	_rptData.append(_RF);
	_rptData.append(vendor_name61);
	_rptData.append(_RF);
	_rptData.append(vendor_cp_name62);
	_rptData.append(_RF);
	_rptData.append(RPT_GETFILENAMES81);
	_rptData.append(_RF);
	_rptData.append(RPT_GETFILENAMES1);
	_rptData.append(_RD);				
	if(wf2 != null) {
		if(wf2.getRowCount() > 0) { //데이타가 있는 경우
			for(int i = 0 ; i < wf2.getRowCount() ; i++){
				_rptData.append(wf2.getValue("ITEM_NO", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("DESCRIPTION_LOC", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("UNIT_MEASURE", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("ITEM_QTY", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("UNIT_PRICE", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("ITEM_AMT", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("INV_QTY", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("GR_QTY", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("EXPECT_AMT", i));
				_rptData.append(_RL);			
			}
		}
	}
	_rptData.append(_RD);			
	if(wf3 != null) {
		if(wf3.getRowCount() > 0) { //데이타가 있는 경우
			for(int i = 0 ; i < wf3.getRowCount() ; i++){
				_rptData.append(wf3.getValue("SEQ", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("DATE1", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("AMT", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("REMARK", i));
				_rptData.append(_RL);	
			}
		}
	}
	//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////
%>

<html>
<head>
<title>
	<%=text.get("MESSAGE.MSG_9999")%>
</title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="IV_005"/>  
 			<jsp:param name="grid_obj" value="GridObj_1"/>
 			<jsp:param name="grid_box" value="gridbox_1"/>
 			<jsp:param name="grid_cnt" value="2"/>
</jsp:include>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
    var mode;
    var checked_count = 0;

    var IDX_SEL             ;
    var IDX_ITEM_NO;
    var IDX_DESCRIPTION_LOC;
    var IDX_DP_SEQ          ;
    var IDX_DP_TEXT         ;
    var IDX_PAY_TERMS       ;
    var IDX_PAY_TERMS_TEXT  ;
    var IDX_DP_PERCENT      ;
    var IDX_DP_AMT          ;
    var IDX_DP_PLAN_DATE    ;

    var chkrow;

 /*    function setHeader()
    {

        GridObj.SetNumberFormat("UNIT_PRICE"  ,G_format_amt);
        GridObj.SetNumberFormat("EXPECT_AMT"  ,G_format_amt);
        GridObj.SetNumberFormat("ITEM_AMT"    ,G_format_amt);
        GridObj.SetNumberFormat("ITEM_QTY"    ,G_format_qty);
		
		
		

        IDX_ITEM_NO = GridObj.GetColHDIndex("ITEM_NO");
        IDX_DESCRIPTION_LOC = GridObj.GetColHDIndex("DESCRIPTION_LOC");
		
        doSelect();
        setHeader2();
    } */

    function doSelect()
    {
<%--         GridObj.SetParam("inv_no","<%=inv_no%>");
        GridObj.SetParam("grid_type","grid_top");
        GridObj.SetParam("SepoaTABLE_DOQUERY_DODATA","0");
        GridObj.SendData(servletUrl);
        //GridObj.AddGridRawData("SepoaGRID_DATA2", GridObj2.GetGridRawData());
        GridObj.strHDClickAction="sortmulti"; --%>
        var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.invoice_detail";
		var grid_col_id = "<%=grid_col_id%>";
		var param = "mode=grid_top&grid_col_id="+grid_col_id;
		param += "&inv_no=<%=inv_no%>";
		param += dataOutput();
		GridObj.post(servletUrl, param);
		GridObj.clearAll(false);
        
    }

/*     function setHeader2() {
        var itemsize        = 100;
        var servicesize     = 0;
        var inv_qty         = "검수요청수량";
        var item_no         = "품목";
        var description_loc = "품목명";


     // 2011-03-08 송장일자  hidden


        GridObj2.SetDateFormat("DATE1"     ,"yyyy/MM/dd");
        GridObj2.SetDateFormat("DATE2"    ,"yyyy/MM/dd");
        GridObj2.SetDateFormat("FLAG"     ,"yyyy/MM/dd");
        GridObj2.SetNumberFormat("AMT"    ,G_format_amt);

        //GridObj2.SetColCellAlign("DATE2","center");
        doSelect2();
        //doSelect();
    } */

    function doSelect2()
    {
<%--         GridObj2.SetParam("po_no","<%=po_no%>");
        GridObj2.SetParam("inv_no","<%=inv_no%>");
        GridObj2.SetParam("grid_type","grid_bottom");
        GridObj2.SetParam("SepoaTABLE_DOQUERY_DODATA","0");
        GridObj2.SendData(servletUrl);
        GridObj2.strHDClickAction="sortmulti";
         --%>
        var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.invoice_detail";
		var grid_col_id = GridObj_1_getColIds();
		var param = "mode=grid_bottom&grid_col_id="+grid_col_id;
		param += "&po_no=<%=po_no%>";
		param += "&inv_no=<%=inv_no%>";
		param += dataOutput();
		GridObj_1.post(servletUrl, param);
		GridObj_1.clearAll(false);
    }

//     function JavaCall(msg1, msg2, msg3, msg4, msg5)
//     {
//         var GridObj = GridObj;
//         var GridObj2 = GridObj2;
        
//         var f0              = document.forms[0];
//         var row             = GridObj.GetRowCount();
//         var po_no           = "";
//         var shipper         = "";
//         var sign_flag       = "";

//         if(msg1 == "doQuery"){
// 	        GridObj.AddSummaryBar('SUMMARY1', '소계', 'summaryall', 'sum', 'EXPECT_AMT');
// 	      	GridObj2.AddSummaryBar('SUMMARY1', '소계', 'summaryall', 'sum', 'AMT');
//     	}
        
//     	if(msg1 == "doData")
//     	{
//     		var mode  = GD_GetParam(GridObj,0);
//     		var status= GD_GetParam(GridObj,1);

//     		if(mode == "inv_app")
//     		{
//     			alert(GridObj.GetMessage());
//     			if(status != "0")
//     			{
//     				window.close();
//     				opener.doSelect();
//     			}
//     		}
//     	}
    	
// 		if(msg1 == "t_imagetext") {
// 			if(msg3 == IDX_ITEM_NO) {
// 				item_no = GD_GetCellValueIndex(GridObj,msg2,IDX_ITEM_NO);
// 				window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
// 			}
// 		}
//     }

    function Add_file(){
	    var ATTACH_NO_VALUE = document.forms[0].attach_no.value;
	    FileAttach('INV',ATTACH_NO_VALUE,'VI');
	}
    
    function printOZ(){
        window.open("/oz/oz_inv_dis1.jsp?inv_no=<%=inv_no%>&house_code=<%=info.getSession("HOUSE_CODE")%>","newWin_oz","width=1000,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
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
	
	function download(url)
	{
	 	location.href = url;
	}

// 	function rMateFileAttach(att_mode, view_type, file_type, att_no, company) {
// 		var f = document.forms[0];

// 		f.att_mode.value   = att_mode;
// 		f.view_type.value  = view_type;
// 		f.file_type.value  = file_type;
// 		f.tmp_att_no.value = att_no;

// 		if (att_mode == "P") {
// 			var protocol = location.protocol;
// 			var host     = location.host;
// 			var addr     = protocol +"//" +host;

// 			var win = window.open("","fileattach",'left=0,top=0, width=620, height=300,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');

// 			f.method = "POST";
// 			f.target = "fileattach";
// 			f.action = addr + "/rMateFM/rMate_file_attach_pop.jsp";
// 			f.submit();
// 		} else if (att_mode == "S") {
// 			f.method = "POST";
// 			if (company == "B") {			// Buyer
// 				f.target = "attachBFrame";
// 			} else if (company == "S") {	// Supplier
// 				f.target = "attachSFrame";
// 			}
// 			f.action = "/rMateFM/rMate_file_attach.jsp";
// 			f.submit();
// 		}
// 	}
	
	/**
	 * 검수증 인쇄하기
	 */
	function goIReport(){
		window.open("inv1_bd_dis2.jsp"+"?inv_no=<%=inv_no%>","nextWin","width=770,height=690,resizable=no,scrollbars=yes,status=yes,top=0,left=0");
		//childFrame.location.href = "/report/iReportPrint.jsp?flag=DL&house_code=<//%=house_code%>&so_no=<//%=inv_no%>";
	}

	function Approval(sign_status)
	{
	    var Sepoa = GridObj;
	    var f = document.forms[0];

	    var iRowCount = GridObj.GetRowCount();
	    //var iCheckedCount = getCheckedCount(Sepoa, INDEX_SELECTED);
	    //if(iCheckedCount<1)
	    //{
	    //  alert(G_MSS1_SELECT);
	    //  return;
	    //}

		if(new Number(getCheckedCount) == 0){
			alert("검수 내역이 없습니다.");
			return;
		}
	    f.sign_status.value = sign_status;


	    if(sign_status == "P")
	    {
	      f.method = "POST";
	      f.target = "childFrame";
	      f.action = "/kr/admin/basic/approval/approval.jsp";
	      f.submit();
	    }
	    else if(sign_status == G_SAVE_STATUS)
	    {
	      //getApproval(sign_status);
	    }


		//getApproval(sign_status);

	  }//Approval End

// 	  function getApproval(approval_str){
// 		  var f = document.forms[0];
// 		  mode = "inv_app";

// 		  var tot_amt = 0;

// 		  for(var i = 0; i < GridObj.GetRowCount();i++)	{
// 			  tot_amt = tot_amt + new Number(GridObj.GetCellValue("EXPECT_AMT", i));
// 		  }

// 		  GridObj.SetParam("mode" , mode);
<%-- 		  GridObj.SetParam("inv_no" , "<%=inv_no%>"); --%>
// 		  GridObj.SetParam("tot_amt" , tot_amt);
// 		  GridObj.SetParam("approval_str" , approval_str);
// 		  GridObj.SetParam("sign_status"  , f.sign_status.value);
// 		  GridObj.SetParam("doc_type"   	, f.doc_type.value);	//사전지원요청, 구매요청 구분
<%-- 		  GridObj.SetParam("subject"  , "<%=po_name12%>"); --%>
// 		  GridObj.SetParam("SepoaTABLE_DOQUERY_DODATA","1");
<%-- 		  GridObj.SendData("<%=getSepoaServletPath("order.ivdp.inv1_bd_dis1")%>", "ALL", "ALL"); --%>
// 	  }
////////////////////////////////////gird1/////////////////////////////////////////
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
		
			var url    = '/kr/master/new_material/real_pp_lis1.jsp';
			var title  = '품목상세조회';        
			var param  = 'ITEM_NO=' + itemNo;
			param     += '&BUY=';
			popUpOpen01(url, title, '750', '550', param);
			
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
	      	//JavaCall("doQuery");
	      } 
	      return true;
	  }
	  
////////////////////////////////////gird2/////////////////////////////////////////
	  var GridObj_1 = null;
	  var MenuObj = null;
	  var myDataProcessor = null;

	  	function GridObj_1_setGridDraw()
	      {
	      	GridObj_1_setGridDraw();
	      	GridObj_1.setSizes();
	      }
	  // 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
	  // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
	  function GridObj_1_doOnRowSelected(rowId,cellInd)
	  {
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
	  function GridObj_1_doOnCellChange_1(stage,rowId,cellInd)
	  {
	      var max_value = GridObj_1.cells(rowId, cellInd).getValue();
	      //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
	      if(stage==0) {
	          return true;
	      } else if(stage==1) {
	      } else if(stage==2) {
	          return true;
	      }
	      
	      return false;
	  }

	  function GridObj_1_doQueryEnd() {
	      var msg        = GridObj_1.getUserData("", "message");
	      var status     = GridObj_1.getUserData("", "status");

	      //if(status == "false") alert(msg);
	      // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
	      if(status == "0") alert(msg);
	      if("undefined" != typeof JavaCall) {
	      	//JavaCall("doQuery");
	      } 
	      return true;
	  }
	  
	  function init(){
		  setGridDraw();
		  GridObj_1_setGridDraw();
		  doSelect();
		  doSelect2();
	  }
	  
	  
	  function callPO(PO_NO){
		   var url = "../procure/po_detail.jsp";
			var param = "";
			param += "?popup_flag_header=true";
			param += "&po_no="+PO_NO;
			PopupGeneral(url+param, "PoDetailPop", "", "", "1000", "600");
			
	  }
	  
	  <%-- ClipReport4 리포터 호출 스크립트 --%>
		function clipPrint(rptAprvData,approvalCnt) {
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
<body onload="init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >

<s:header>
<!--내용시작-->
<form name="form1" >
	<%--ClipReport4 hidden 태그 시작--%>
	<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
	<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
	<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="N">
	<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
	<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
	<input type="hidden" name="rptAprv" id="rptAprv">		
	<%--ClipReport4 hidden 태그 끝--%>	
	<input type="hidden" name="kind" id="kind">
	<input type="hidden" name="attach_no" id="attach_no" value="<%=attach_no81%>">
	<input type="hidden" name="attach_count" id="attach_count" value="">
	<input type="hidden" name="attach_no_1" id="attach_no_1" value="<%=attach_no_1%>">
	<input type="hidden" name="attach_count_1" id="attach_count_1" value="">

	<input type="hidden" name="att_mode" id="att_mode"  value="">
	<input type="hidden" name="view_type" id="view_type"  value="">
	<input type="hidden" name="file_type" id="file_type"  value="">
	<input type="hidden" name="tmp_att_no" id="tmp_att_no" value="">

	<input type="hidden" id="house_code" name="house_code" value="<%=info.getSession("HOUSE_CODE")%>">
	<input type="hidden" id="company_code" name="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
	<input type="hidden" id="dept_code" name="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
	<input type="hidden" id="req_user_id" name="req_user_id" value="<%=info.getSession("ID")%>">
	<input type="hidden" id="fnc_name" name="fnc_name" value="getApproval">
	<input type="hidden" id="approval_str" name="approval_str" value="">
	<input type="hidden" id="sign_status" name="sign_status" value="N">
	<input type="hidden" id="doc_type" name="doc_type" value="INV">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="20" align="left" class="title_page" vAlign="bottom">
		검수요청상세조회
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
      <td width="18%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주번호</td>
      <td width="35%" class="data_td"><a href="#" onclick="javascript:callPO('<%=po_no11%>');"><font color='blue' size='10'><%=po_no11%></font></a></td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주명</td>
      <td width="35%" class="data_td"><%=po_name12%></td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>

<%--       <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 프로젝트명</td> --%>
<%--       <td class="data_td"><%=project_name21%></td> --%>

      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수요청일자</td>
      <td class="data_td"><%=app_status42%></td>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수완료일자</td>
      <td class="data_td"><b><%=confirm_date1 %></b></td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수요청번호</td>
      <td class="data_td"><%=inv_no32%></td>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 요청차수</td>
      <td class="data_td"><%=inv_seq41%></td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주총금액 (VAT포함)</td>
      <td class="data_td"><%=po_ttl_amt51%></td>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수후잔액 (VAT포함)</td>
      <td class="data_td"><%=inv_amt52%></td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공급업체</td>
      <td class="data_td"><%=vendor_name61%></td>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공급담당</td>
      <td class="data_td"><%=vendor_cp_name62%></td>
    </tr>
    <!-- 2011-03-08 solarb 검수요청현황 -->
    <!-- 2011-03-08 보증보험증권  hidden -->
    <tr style="display: none;">
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 보증보험증권</td>
      <td colspan="3" class="data_td"><%=bb71%></td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
	<tr>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 첨부파일</td>
		<td class="data_td" colspan="3" height="150" align="center">
			<table border="0" style="padding-top: 10px; width: 100%;">
				<tr>
					<td>
						<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=attach_no81%>&view_type=VI" style="width: 98%;height: 90px; border: 0px;" frameborder="0" ></iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<%-- WGW --%>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	
	<tr>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;검수자 첨부파일</td>
		<td class="data_td" colspan="3" height="150" align="center">
			<table border="0" style="padding-top: 10px; width: 100%;">
				<tr>
					<td>
						<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=attach_no_1%>&view_type=VI" style="width: 98%;height: 90px; border: 0px;" frameborder="0" ></iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<%-- WGW --%>
	
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td height="30" align="right">
                <TABLE cellpadding="0">
                    <TR>
                    <!-- 2011.09.07 HMCHOI -->
                    <!-- 납품서가 "합격"인 경우 검수증 출력이 가능하다. -->
                    <!-- 2011.11.15 welchsy
                    	검수요청이 되면 검수증 출력가능으로 변경 
                    -->
                    <%if (invoice_status.equals("E1") || invoice_status.equals("RE")) {%>
                   		<TD><script language="javascript">btn("javascript:clipPrint()","출 력")</script></TD>
                    <%}%>
                        <TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>
                    </TR>
                </TABLE>
            </td>
        </tr>
    </table>
<b>검수내역</b>

<!-- 상단 그리드 -->
<s:grid screen_id="IV_004" grid_obj="GridObj" grid_box="gridbox"/>

<br>
<b>기검수내역</b>

<!-- 하단 그리드 -->
<s:grid screen_id="IV_005" grid_obj="GridObj_1" grid_box="gridbox_1"/>

</form>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
<iframe src="" name="childFrame" WIDTH="0" Height="0" border="0" scrolling="no" frameborder="0"></iframe>

</s:header>
<s:footer/>
</body>
</html>
<%-- <script language="javascript">rMateFileAttach('S','R','IV',form1.attach_no.value,'S');</script> --%>


