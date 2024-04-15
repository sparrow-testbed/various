<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa" %>

<%

    String to_day    = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date   = to_day;

/*  넘어온 파라미터 값 셋팅  START */
	String ev_no	       = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("g_ev_no")));
	String subject	       = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("g_subject")));	
	String seller_code     = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("g_seller_code")));
	String vendor_name_loc = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("g_vendor_name_loc")));
	String ev_year         = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("g_ev_year")));
	String sg_regitem      = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("g_sg_regitem")));	
	
	String irs_no          = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("irs_no")));	
	String address_loc     = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("address_loc")));	
	String phone_no        = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("phone_no")));	
	String plant_address   = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("plant_address")));	
	String phone_no1       = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("phone_no1")));	
	    	
	    		
/*  넘어온 파라미터 값 셋팅  END */

	Logger.sys.println("g_ev_no           = " + ev_no);
	Logger.sys.println("g_subject         = " + subject);
	Logger.sys.println("g_seller_code     = " + seller_code);
	Logger.sys.println("g_vendor_name_loc = " + vendor_name_loc);
	Logger.sys.println("g_ev_year         = " + ev_year);
	Logger.sys.println("g_sg_regitem      = " + sg_regitem);

/*  페이지 사용 초기 지역 변수 셋팅 START */
	String EST_DESC   = "";
	String EST_NO     = "";
	String ATTACH_NO  = "";
	String ATTACH_NO1 = "";
	boolean btn_chk = false; // 현장실사등록-헤더(테이블)에 등록되어있으면 true 아니면 false;
/*  페이지 사용 초기 지역 변수 셋팅 END */

	if(ev_no.trim().length() > 0){
		String[] args3 	 = { ev_no , ev_year, seller_code };
	    SepoaOut value   = ServiceConnector.doService(info, "WO_031", "CONNECTION","srgvn_tbl_select", args3);
	    SepoaFormater wf = new SepoaFormater(value.result[0]);		
		if( wf.getRowCount() > 0 ){
			EST_DESC       = wf.getValue("EST_DESC", 0);
			EST_NO         = wf.getValue("EST_NO", 0);
			irs_no         = wf.getValue("irs_no", 0);
			address_loc    = wf.getValue("address_loc", 0);
			phone_no       = wf.getValue("phone_no", 0);
			plant_address  = wf.getValue("plant_address", 0);
			phone_no1      = wf.getValue("phone_no1", 0);
			ATTACH_NO      = wf.getValue("ATTACH_NO", 0);
			ATTACH_NO1      = wf.getValue("ATTACH_NO1", 0);
			btn_chk  = true;
		}
	}
	else{
		response.sendRedirect("/errorPage/errorPage.jsp");
		return;
	}
		
	Vector multilang_id = new Vector();
	multilang_id.addElement("WO_031");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text    = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "WO_031";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	// 화면에 행머지기능을 사용할지 여부의 구분
	isRowsMergeable = false;	
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<Script language="javascript">
	var G_SERVLETURL    = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_runing_pop";
	var GridObj         = null;
	var MenuObj         = null;
	var myDataProcessor = null;

	function setGridDraw()
	{
		<%=grid_obj%>_setGridDraw();
		GridObj.setSizes();
	}
	
	function doOnRowSelected(rowId,cellInd)
	{
		//alert("doOnRowSelected");
	}
	
	function doOnCellChange(stage,rowId,cellInd)
	{
		var max_value = GridObj.cells(rowId, cellInd).getValue();
	   	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
	   	if( stage == 0 ){
			return true;
		} 
		else if( stage == 1 ){
		}
		else if( stage == 2 ){
		    return true;
		}
		return false;
	}

	//그리드의 선택된 행의 존재 여부를 리턴
	function checkRows(){
		var grid_array = getGridChangedRows(GridObj, "selected");
		
		if(grid_array.length > 0)	return true;
		
		alert("<%=text.get("MESSAGE.1004")%>");
		return false;
	}
	
	//조회
	function doQuery(){
		<%if( !btn_chk ){%>
			alert("기본정보들을 먼저 등록 해주십시요.");
			return;
		<%}%>
		var cols_ids    = "<%=grid_col_id%>";
		var form        = document.forms[0];
		
	    var param    = "?mode=query&cols_ids="+cols_ids;
            param   += "&est_no="      + "<%=EST_NO%>";
            param   += "&ev_no="       + "<%=ev_no%>";
            param   += "&ev_year="     + "<%=ev_year%>";
            param   += "&seller_code=" + "<%=seller_code%>";

		GridObj.post(G_SERVLETURL+param);
		GridObj.clearAll(false);		
	}
	
	//조회후 뒷처리
    function doQueryEnd(GridObj, RowCnt){
		var msg    = GridObj.getUserData("", "message");
		var status = GridObj.getUserData("", "status");

		if(status == "false")	alert(msg);

		return true;
    }
    			
	//저장
	function doInsert(){
		var form       = document.forms[0];
		/*
		if( form.invest_date.value == "" ){
			alert("조사일자를 입력하여주십시요.");
			form.invest_date.focus();
			return;
		}
		if( form.irs_no.value == "" ){
			alert("사업자번호를 입력하여주십시요.");
			form.irs_no.focus();
			return;
		}		
		if( form.address_loc.value == "" ){
			alert("본사주소지를 입력하여주십시요.");
			form.address_loc.focus();
			return;
		}
		if( form.phone_no.value == "" ){
			alert("본사연락처를 입력하여주십시요.");
			form.phone_no.focus();
			return;
		}
		if( form.plant_address.value == "" ){
			alert("공장주소지를 입력하여주십시요.");
			form.plant_address.focus();
			return;
		}
		if( form.phone_no1.value == "" ){
			alert("공장연락처를 입력하여주십시요.");
			form.phone_no1.focus();
			return;
		}	
		if( form.est_desc.value == "" ){
			alert("평가자의견을 입력하여주십시요.");
			form.est_desc.focus();
			return;
		}	
		*/
	    if (confirm("<%=text.get("MESSAGE.1018")%>")){
            var param    = "?est_no="      + "<%=EST_NO%>";  
		        param   += "&ev_no="       + "<%=ev_no%>";
		        param   += "&ev_year="     + "<%=ev_year%>";
		        param   += "&seller_code=" + "<%=seller_code%>";
		        param   += "&sg_regitem="  + "<%=sg_regitem%>";
		        param   += "&sheet_name="  + "<%=subject%>";
						        	    
			form.action            = "ev_sheet_runing_insert.jsp" + param; 
		   	form.target            = "childFrame";
		   	form.submit();		
        }	
	}

	//저장후 뒷처리
	function doSaveEnd(obj) {
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		document.getElementById("message").innerHTML = messsage;

		myDataProcessor.stopOnError = true;
		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}
		
		if(status == "true")	doQuery();
		else{
			alert(messsage);
		}

		return false;
	}	
	
	// SRGVN 체크
	function doDetailInsert(){
		if( !checkRows() )	return;
		
       	var param    = "?est_no="      + "<%=EST_NO%>";  
	        param   += "&ev_no="       + "<%=ev_no%>";
	        param   += "&ev_year="     + "<%=ev_year%>";
	        param   += "&seller_code=" + "<%=seller_code%>";
					        	    
		form.action            = "ev_sheet_runing_chk.jsp" + param; 
	   	form.target            = "childFrame";
	   	form.submit();				
	}
	
	//상세저장
	function doDetailInsert_2( cnt ){
		if( cnt == 0 ){
			alert( "기본정보를 먼저 등록해주십시요." );
			return;
		}
		
		var grid_array = getGridChangedRows(GridObj, "selected");
		/*
		for( var i = 0; i < grid_array.length; i++ ){
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("work_name")).getValue()) == ""){
				alert('담당자를 입력하여 주십시요.');
				return;
			}
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("dept")).getValue()) == ""){
				alert('부서를  입력하여 주십시요.');
				return;
			}
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("phone")).getValue()) == ""){
				alert('연락처를  입력하여 주십시요.');
				return;
			}
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("employee_seq")).getValue()) == ""){
				alert('종업원수를  입력하여 주십시요.');
				return;
			}

			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("admin_part")).getValue()) == ""){
				alert('관리직을  입력하여 주십시요.');
				return;

			}												
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("product_part")).getValue()) == ""){
				alert('생산직을  입력하여 주십시요.');
				return;
			}
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("sales")).getValue()) == ""){
				alert('총매출액을  입력하여 주십시요.');
				return;
			}
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("profit")).getValue()) == ""){
				alert('당기손익을  입력하여 주십시요.');
				return;
			}	
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("sales_date")).getValue()) == ""){
				alert('영업개시일을  입력하여 주십시요.');
				return;
			}	
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("machine")).getValue()) == ""){
				alert('공장기계유무를 선택하여 주십시요.');
				return;
			}	
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("product")).getValue()) == ""){
				alert('해당제품제조유무를  선택하여 주십시요.');
				return;
			}
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("goods")).getValue()) == ""){
				alert('제조관련물품유무를  선택하여 주십시요.');
				return;
			}	
		}
		*/
	    if (confirm("<%=text.get("MESSAGE.1018")%>")){
            var cols_ids = "<%=grid_col_id%>";
            	
            var param    = "?mode=insert&cols_ids="+cols_ids;  
		        param   += "&est_no="      + "<%=EST_NO%>";
		        param   += "&ev_no="       + "<%=ev_no%>";
		        param   += "&ev_year="     + "<%=ev_year%>";
		        param   += "&seller_code=" + "<%=seller_code%>";
		        param   += "&sg_regitem="  + "<%=sg_regitem%>";

		    myDataProcessor = new dataProcessor(G_SERVLETURL + param);
			sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
        }	
	
	}
	
	//삭제
	function doDelete(){
		<%if( !btn_chk ){%>
			alert("기본정보들을 먼저 등록 해주십시요.");
			return;
		<%}%>
		if( !checkRows() )	return;
		var grid_array = getGridChangedRows(GridObj, "selected");
				
		if( confirm("<%=text.get("MESSAGE.1015")%>") ){
            var cols_ids    = "<%=grid_col_id%>";
            var param       = "?mode=delete&cols_ids="+cols_ids;
		        param      += "&est_no="      + "<%=EST_NO%>";
		        param      += "&ev_no="       + "<%=ev_no%>";
		        param      += "&ev_year="     + "<%=ev_year%>";
		        param      += "&seller_code=" + "<%=seller_code%>";            
		        param      += "&sg_regitem="  + "<%=sg_regitem%>";
		         
			myDataProcessor = new dataProcessor(G_SERVLETURL + param);
			
			sendTransactionGrid( GridObj, myDataProcessor, "selected", grid_array );
		}		
		
	}

	//행삽입
	function doAddRow(){
		<%if( !btn_chk ){%>
			alert("기본정보들을 먼저 등록 해주십시요.");
			return;
		<%}%>
		dhtmlx_last_row_id++;
		
    	var nMaxRow2 = dhtmlx_last_row_id;
    	var row_data = "<%=grid_col_id%>";

    	GridObj.enableSmartRendering(true);
    	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
    	GridObj.selectRowById(nMaxRow2, false, true);
		GridObj.cells( nMaxRow2, GridObj.getColIndexById("selected")    ).cell.wasChanged = true;
		GridObj.cells( nMaxRow2, GridObj.getColIndexById("selected")    ).setValue("1");
   		GridObj.cells( nMaxRow2, GridObj.getColIndexById("est_no")      ).setValue("");
   		GridObj.cells( nMaxRow2, GridObj.getColIndexById("est_seq")     ).setValue("");
		GridObj.cells( nMaxRow2, GridObj.getColIndexById("work_name")   ).setValue("");
		GridObj.cells( nMaxRow2, GridObj.getColIndexById("dept")        ).setValue("");
		GridObj.cells( nMaxRow2, GridObj.getColIndexById("phone")       ).setValue("");
		GridObj.cells( nMaxRow2, GridObj.getColIndexById("employee_seq")).setValue("");
		GridObj.cells( nMaxRow2, GridObj.getColIndexById("admin_part")  ).setValue("");
		GridObj.cells( nMaxRow2, GridObj.getColIndexById("product_part")).setValue("");
		GridObj.cells( nMaxRow2, GridObj.getColIndexById("sales")       ).setValue("");
		GridObj.cells( nMaxRow2, GridObj.getColIndexById("profit")      ).setValue("");
		GridObj.cells( nMaxRow2, GridObj.getColIndexById("sales_date")  ).setValue("");
		GridObj.cells( nMaxRow2, GridObj.getColIndexById("machine")     ).setValue("");
		GridObj.cells( nMaxRow2, GridObj.getColIndexById("product")     ).setValue("");
		GridObj.cells( nMaxRow2, GridObj.getColIndexById("goods")       ).setValue("");
	}
    
    //행삭제
    function doDeleteRow(){
		<%if( !btn_chk ){%>
			alert("기본정보들을 먼저 등록 해주십시요.");
			return;
		<%}%>
    	var grid_array = getGridChangedRows(GridObj, "selected");
    	var rowcount   = grid_array.length;
    	GridObj.enableSmartRendering(false);

    	for(var row = rowcount - 1; row >= 0; row--){
			if( "1" == GridObj.cells(grid_array[row], 0).getValue() ) 	GridObj.deleteRow(grid_array[row]);
	    }
    }
    
	function searchProfile( part ){
		if( part == "name" ){
			//PopupCommon1("SP5001", "getVendor_code", "", "업체코드", "업체명");
		}
	}
	
	//저장후 자신호출
	function reCall( gubun ){
		alert( gubun+"이 완료되었습니다." );
		
		form.action            = "ev_sheet_runing_pop.jsp";
	   	form.target            = "_self";
	   	form.submit();
	}
	
	// 파일 업로드, 다운로드, 삭제
	function filePop(){
   		var w_dim  = new Array(2);
		    w_dim  = ToCenter(400, 640);
		var w_top  = w_dim[0];
		var w_left = w_dim[1];
   		
   		var TYPE       = "NOT";
   		var attach_key = document.form.in_attach_no.value;
		var view_type  = "";
		var rowId      = "";
		
   		win = window.open("<%=POASRM_CONTEXT_NAME%>/sepoafw/file/file_attach.jsp?rowId="+rowId+"&type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type,"fileattach",'left=' + w_left + ',top=' + w_top + ', width=620, height=400,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');
	}
	
    function setAttach(attach_key, arrAttrach, rowId, attach_count){
		document.form.in_attach_no.value  = attach_key;
		document.form.in_attach_cnt.value = attach_count;
    }		    		
</Script>
</head>
<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="setGridDraw();">
<s:header popup="true">
<form id="form" name="form" method="post" action="">
	    	
<input type="hidden" id="g_ev_no"           name="g_ev_no"           value="<%=ev_no%>">
<input type="hidden" id="g_subject"         name="g_subject"         value="<%=subject%>">
<input type="hidden" id="g_seller_code"     name="g_seller_code"     value="<%=seller_code%>">
<input type="hidden" id="g_vendor_name_loc" name="g_vendor_name_loc" value="<%=vendor_name_loc%>">
<input type="hidden" id="g_ev_year"         name="g_ev_year"         value="<%=ev_year%>">
<input type="hidden" id="g_sg_regitem"      name="g_sg_regitem"      value="<%=sg_regitem%>">

<%@ include file="/include/include_top.jsp"%>
<%
	 thisWindowPopupFlag = "true";
	 thisWindowPopupScreenName = "현장실사등록팝업";
	//if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "true";
%>
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5"></td>
    </tr>
    <tr>
    	<td width="100%" valign="top">
		  	<table cellpadding="0" cellspacing="0" border="0" width="100%">
		  	<tr>
				<td style="padding:5 5 5 0" align="right">
				<table cellpadding="2" cellspacing="0">
				    <tr>
						
						<td><script language="javascript">btn("doInsert()"       , "기본정보등록")</script></td>
					</tr>
			    </table>
			    </td>
		   	</tr>
		   	</table>        	
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		    <tr>
        		<td width="20%" height="24" class="div_input"><%=text.get("WO_031.name")%></td>
				<td width="30%" height="24" class="div_data"><%=subject%></td>
				<td width="20%" height="24" class="div_input_re"><%=text.get("WO_031.survey_date")%></td>
				<td width="30%" height="24" class="div_data">
					<s:calendar id="invest_date" default_value="<%=SepoaString.getDateSlashFormat(to_date)%>" 	format="%Y/%m/%d"/>				
				</td>
			</tr>
		    <tr>
        		<td width="20%" height="24" class="div_input_re"><%=text.get("WO_031.lifnr_name")%></td>
				<td width="30%" height="24" class="div_data"><%=vendor_name_loc%></td>
				<td width="20%" height="24" class="div_input_re"><%=text.get("WO_031.business_num")%></td>
				<td width="30%" height="24" class="div_data">
					<input id="irs_no" name="irs_no" type="text" class="input_submit" value="<%=irs_no%>"/>
				</td>
			</tr>
		    <tr>
        		<td width="20%" height="24" class="div_input_re"><%=text.get("WO_031.office_addr")%></td>
				<td width="30%" height="24" class="se_cell_data">
					<input id="address_loc" name="address_loc" type="text" style="width:200px;" class="input_submit" value="<%=address_loc%>"/>
				</td>
				<td width="20%" height="24" class="div_input_re"><%=text.get("WO_031.phone")%></td>
				<td width="30%" height="24" class="div_data">
					<input id="phone_no" name="phone_no" type="text"    style="width:200px;" class="input_submit" value="<%=phone_no%>"/>
				</td>
			</tr>
		    <tr>
        		<td width="20%" height="24" class="div_input_re"><%=text.get("WO_031.factory_addr")%></td>
				<td width="30%" height="24" class="div_data">
					<input id="plant_address" name="plant_address" type="text" style="width:200px;" class="input_submit" value="<%=plant_address%>"/>
				</td>
				<td width="20%" height="24" class="div_input_re"><%=text.get("WO_031.phone")%></td>
				<td width="30%" height="24" class="div_data">
					<input id="phone_no1" name="phone_no1" type="text"     style="width:200px;" class="input_submit"  value="<%=phone_no1%>"/>
				</td>
			</tr>
		    <tr>
        		<td width="20%" height="24" class="div_input_re"><%=text.get("WO_031.appr_view")%></td>
				<td width="80%" height="50" class="div_data" colspan="3">
					<textarea id="est_desc" name="est_desc" cols="80" rows="3"><%=EST_DESC%></textarea>
				</td>
			</tr>
		    <tr>
	       		<td width="20%" height="24" class="se_cell_title" align="right">
	       			파일첨부
	       		</td>
	       		<td width="80%" height="24" class="se_cell_data" colspan="3">
					<input type="hidden" id="in_attach_no" name="in_attach_no" value="<%=ATTACH_NO%>">
					<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td><script language="javascript">btn("javascript:filePop()","파일첨부")</script></td>
			        	<td>&nbsp;&nbsp;<input type="text" id="in_attach_cnt" name="in_attach_cnt" class="input_empty" readonly value="<%=ATTACH_NO1%>"></td>
			        </tr>
			        </table>
	       		</td>
		    </tr>																
			</table>
		  	<table cellpadding="0" cellspacing="0" border="0" width="100%">
		  	<tr>
		  		<td height="5"></td>
		  	</tr>
		  	<tr>
				<td style="padding:5 5 5 0" align="right">
				<table cellpadding="2" cellspacing="0">
				    <tr>
						<td><script language="javascript">btn("doQuery()"        , "조회")</script></td>
						<td><script language="javascript">btn("doDelete()"       , "삭제")</script></td>												
						<td><script language="javascript">btn("doDetailInsert()" , "상세정보등록")</script></td>												
						<td><script language="javascript">btn("doAddRow()"       , "행삽입")</script></td>
						<td><script language="javascript">btn("doDeleteRow()"    , "행삭제")</script></td>
					</tr>
			    </table>
			    </td>
		   	</tr>
		   	</table>
		</td>
	</tr>
</table>
<iframe id="childFrame" name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</form>
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<s:footer/>
</body>
</html>
