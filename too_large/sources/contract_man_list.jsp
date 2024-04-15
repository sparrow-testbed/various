<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
    String house_code   = info.getSession("HOUSE_CODE");

    String G_IMG_ICON = "/images/ico_zoom.gif";

	String to_day 	 = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-30);
	String to_date 	 = to_day;	
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("MAN_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
    String contractPrice = JSPUtil.nullToRef ( request.getParameter ( "contractPrice" ) , "N" );

	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String user_type    = info.getSession("USER_TYPE");
	String company_code = info.getSession("COMPANY_CODE");
	String company_name = info.getSession("COMPANY_NAME");
	String CTRL_CODE   	  = info.getSession("CTRL_CODE");
	
	//String CTRL_TYPE      = CTRL_CODE.substring(0, 2);
	String CTRL_TYPE      = "";
	String USER_ID        = info.getSession("ID"); 
	
	// Dthmlx Grid 전역변수들..
	String screen_id = "MAN_002";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	boolean isSupplier = false;
	String ctFlag = JSPUtil.nullToEmpty ( JSPUtil.CheckInjection ( request.getParameter ( "ct_flag" ) ) );
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";

	if("true".equals(JSPUtil.nullToEmpty(request.getParameter("summary")))){
		thisWindowPopupScreenName= "전자계약 > 계약관리 > 계약생성현황"; 
		thisWindowPopupFlag = "true";
	}
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title>
<%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>

<script language=javascript
	src="<%=POASRM_CONTEXT_NAME%>/js/lib/sec.js"></script>
<script language="javascript"
	src="<%=POASRM_CONTEXT_NAME%>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">

var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_manual_list";

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;
var click_row = "";

	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();
    	GridObj.setColumnHidden(GridObj.getColIndexById("SIGN_STATUS_TEXT"), true);
//     	doQuery();
    }

	function doMoveRowUp()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"up");
    }

    function doMoveRowDown()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"down");
    }
    
    function doQueryEnd(GridObj, RowCnt)
    {
    	var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");
 		if(status == "false") alert(msg);

		//if(GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("BD_SELLER_CNT")).getValue() !="0")
		//{
			//GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("BD_SELLER_CNT")).setValue("yellow");
		//}
		return true;
    }
    function contractPopup(cont_no,cont_gl_seq,view,doc_type){

        if(cont_no != ''){
            document.forms[0].cont_no.value     = cont_no;
            document.forms[0].cont_gl_seq.value = cont_gl_seq;
            document.forms[0].view.value        = view;            
            document.forms[0].doc_type.value    = doc_type; 
            var url = "contract_insert.jsp";
            doOpenPopup( url, '1000', '750' );
        }
    }
    function doOnRowSelected(rowId,cellInd)
    {	
    	var row_id = rowId;
    	var header_name = GridObj.getColumnId(cellInd);

    	if( header_name == "CONT_NO")
		{
    		
			var	cont_no      = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_NO")).getValue());	
			var	cont_gl_seq  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
			
			if(cont_no != '') {
			 	var strParm  = "cont_no="+ cont_no + "&cont_gl_seq=" + cont_gl_seq;
			 	popUpOpen("contract_man_detail.jsp?"+strParm, 'CONT_NO_DETAIL', '1080', '700');
			}
		}
		 
     	else if( header_name == "PRE_FILE_NO_IMG")
		{ 
	        var TYPE        = 'ALUP';
	        var view_type   = 'VI';

	        var attach_key = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("PRE_FILE_NO")).getValue());
			
	        //FileAttach(TYPE, attach_key, view_type);
	        //return;			
	 
			var cont_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_NO")).getValue());
			var cont_gl_seq  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_GL_SEQ")).getValue()); 
			var ins_vn = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_INS_VN")).getValue()); 
			var file_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("PRE_INS_PATH")).getValue()); 
			if(ins_vn == "서울금융보증보험" && file_no != ""){  
				
				var url = "contract_bond_view.jsp?update_flag=D&cont_no="+encodeUrl(cont_no)+"&cont_gl_seq="+encodeUrl(cont_gl_seq)+"&ins_flag=PREGUA";
				var width = "800";
				var height = "700";
				
				doOpenPopup(url, width, height); 
			}else{
				document.forms[0].attachrow.value = rowId;
				document.forms[0].isGridAttach.value = "true"
				document.forms[0].ins_flag.value = "PRE"
				//attach_file_grid(LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("PRE_FILE_NO")).getValue()),'CT');
				FileAttach_Grid('CT',LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("PRE_FILE_NO")).getValue()),'VI');
			}
 
		}
		
    	else if( header_name == "CONT_FILE_NO_IMG")
		{ 
		
	        var TYPE        = 'ALUP';
	        var view_type   = 'VI';

	        var attach_key = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_FILE_NO")).getValue());
			
	        //FileAttach(TYPE, attach_key, view_type);
	        //return;		
	        

 
			var cont_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_NO")).getValue());
			var cont_gl_seq  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_GL_SEQ")).getValue()); 
			var ins_vn = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_INS_VN")).getValue()); 
			var file_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_INS_PATH")).getValue()); 
			
			
			if(ins_vn == "서울금융보증보험" && file_no != ""){  
				
				var url = "contract_bond_view.jsp?update_flag=D&cont_no="+encodeUrl(cont_no)+"&cont_gl_seq="+encodeUrl(cont_gl_seq)+"&ins_flag=CONGUA";
				var width = "800";
				var height = "700";
				
				doOpenPopup(url, width, height); 
				
			}else{
				document.forms[0].attachrow.value = rowId;
				document.forms[0].isGridAttach.value = "true"
				document.forms[0].ins_flag.value = "INS"
				//attach_file_grid(LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_FILE_NO")).getValue()),'CT');
				FileAttach_Grid('CT',LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_FILE_NO")).getValue()),'VI');
			}
 		
		}
		
		
    	else if( header_name == "FAULT_FILE_NO_IMG")
		{
	        var TYPE        = 'ALUP';
	        var view_type   = 'VI';

	        var attach_key = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("FAULT_FILE_NO")).getValue());
			
	        //FileAttach(TYPE, attach_key, view_type);
	        //return;				
 
			var cont_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_NO")).getValue());
			var cont_gl_seq  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_GL_SEQ")).getValue()); 
			var ins_vn = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_INS_VN")).getValue()); 
			var file_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("FAULT_INS_PATH")).getValue()); 
			if(ins_vn == "서울금융보증보험" && file_no != ""){  
				
				var url = "contract_bond_view.jsp?update_flag=D&cont_no="+encodeUrl(cont_no)+"&cont_gl_seq="+encodeUrl(cont_gl_seq)+"&ins_flag=FLRGUA";
				var width = "800";
				var height = "700";
				
				doOpenPopup(url, width, height); 
			}else{
				document.forms[0].attachrow.value = rowId;
				document.forms[0].isGridAttach.value = "true"
				document.forms[0].ins_flag.value = "FAL"
				//attach_file_grid(LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("FAULT_FILE_NO")).getValue()),'CT');
				FileAttach_Grid('CT',LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("FAULT_FILE_NO")).getValue()),'VI');
			}
 	
		}
		
    	else if( header_name == "EXEC_NO")
		{
    		var    exec_number = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("EXEC_NO")).getValue());  
            if(exec_number != ''){
                window.open("/kr/dt/app/app_bd_ins1.jsp?exec_no="+exec_number+ "&pr_type=I&editable=N&req_type=P","execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");            	
            }  	
		}
    	
    	else if( header_name == "SELLER_CODE_TEXT" ) {//WGW
    		
    		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "SELLER_CODE");
    		
    		if(vendor_code != null && vendor_code != "") {
    		
    			var url    = '/s_kr/admin/info/ven_bd_con.jsp';
    			var title  = '업체상세조회';
    			var param  = 'popup=Y';
    			param     += '&mode=irs_no';
    			param     += '&vendor_code=' + vendor_code;
    			popUpOpen01(url, title, '900', '700', param);
    			
    		}
    		
    	}
    }
 	function setSelectGrid(){
		
		for(var row = 0; row < GridObj.getRowsNum(); row++) 
		{
			GridObj.enableSmartRendering(true);
	    	GridObj.selectRowById(GridObj.getRowId(row), false, true);
	    	GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	    	GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SELECTED")).setValue("1");
		}
	}
	
 	function setReTender(param) {
		//setSelectGrid();
		//alert("param=="+param);
		var grid_array = getGridChangedRows(GridObj, "SELECTED");	

		myDataProcessor = new dataProcessor(param);
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	}
    
    function doOnCellChange(stage,rowId,cellInd)
    {
    	var max_value = GridObj.cells(rowId, cellInd).getValue();
    	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    	if(stage==0) {
    	
			return true;
		} else if(stage==2) {
			
			
			return true;
		}
		return false;
    }
    
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("<%=text.get("MAN_002.0001")%>");
		return false;
	}
    function initAjax()
	{ 
<%-- 		doRequestUsingPOST( 'SL5001', 'M125' ,'cont_type', 	'' ); 			계약유형  --%>
<%-- 		doRequestUsingPOST( 'SL5001', 'M286' ,'ct_flag', 	'' ); 			상태 --%>

		
        doRequestUsingPOST( 'SL0018', '<%=house_code%>#M809' ,'cont_process_flag'	, 'FU' 	);//계약방법		
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M989' ,'cont_type1_text'		, '' 	);//입찰방법
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M930' ,'cont_type2_text'		, '' 	);//낙찰방법
		
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M900' ,'sg_type1'			, ''	);//계약구분(대)
							  
    }
    
    function nextAjax( type ){
		var f = document.forms[0];
		
		if( type == '2' ){
			var sg_refitem  = f.sg_type1.value;
			var sg_type2_id = eval(document.getElementById('sg_type2')); //id값 얻기
			
			sg_type2_id.options.length = 0;    //길이 0으로
//			sg_type2_id.fireEvent("onchange"); //onchange 이벤트발생
			$(sg_type2_id).trigger("onchange");
			if( sg_refitem.valueOf().length > 0 ){
				// 공백인 option 하나 추가(전체 검색위해서)
				var nodePath  = document.getElementById("sg_type2");
				var ooption   = document.createElement("option");
				ooption.text  = "전체";
				ooption.value = "";
				nodePath.add(ooption);
				
				//doRequestUsingPOST( 'W002', '2'+'#'+sg_refitem ,'sg_type2', '' );
				doRequestUsingPOST( 'SL0149', '<%=house_code%>#'+sg_refitem ,'sg_type2'			, ''	);//계약구분(중)
			}
			else{
				var nodePath  = document.getElementById("sg_type2");
				var ooption   = document.createElement("option");
				ooption.text  = "전체";
				ooption.value = "";
				nodePath.add(ooption);
			}
		}
	}
   	
    // 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
	// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
	function doSaveEnd(obj)
	{
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		var rewo_number = "";
		var rewo_seq = "";
		
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

		return false;
	}
   
	/**
	 * @Function Name  : getCTList
	 * @작성일         : 2009. 07. 06
	 * @변경이력       :
	 * @Function 설명  :  조회
	 */		
	function doQuery()
	{

	 	var grid_col_id     = "<%=grid_col_id%>";
		var param = "mode=query&grid_col_id="+grid_col_id;
		    param += dataOutput();
		GridObj.post(G_SERVLETURL, param);
		GridObj.clearAll(false);
		<%-- 
		var from_cont_date	    = encodeUrl(LRTrim(del_Slash(document.form.from_cont_date.value)));
		var to_cont_date  	    = encodeUrl(LRTrim(del_Slash(document.form.to_cont_date.value)));
		var ctrl_code 		    = encodeUrl(LRTrim(document.form.ctrl_code.value));    
		var seller_code 	    = encodeUrl(LRTrim(document.form.company_code.value));
		var subject 		    = encodeUrl(LRTrim(document.form.subject.value));  
		var cont_type 		    = encodeUrl(LRTrim(document.form.cont_type.value));  
		var ct_flag 		    = encodeUrl(LRTrim(document.form.ct_flag.value));  
		var contractPriceFlag	= encodeUrl(LRTrim(document.form.contractPriceFlag.value));  
		var changeContract		= document.form.changeContract.checked;
		
			if(LRTrim(from_cont_date) == "" || LRTrim(from_cont_date) == "" ) { 
	            alert("<%=text.get("MAN_002.0002")%>");
	            return;
	        }
	
	        if(!checkDate(from_cont_date)) { 
	             alert("<%=text.get("MAN_002.0003")%>"); // 계약작성일자를 확인하세요.
	            document.form.from_cont_date.select();
	            return;
	        }
	        
	        if(!checkDate(to_cont_date)) { 
	            alert("<%=text.get("MAN_002.0003")%>"); // 계약작성일자를 확인하세요.
	            document.form.to_cont_date.select();
	            return;
	        } 
	        if(!checkDateBetween(from_cont_date, to_cont_date))
			{
				alert("<%=text.get("MAN_002.0014")%>"); // 계약 작성 일자를 잘못 입력하셨습니다.
				return;
			}
		var param = "&from_cont_date=" + from_cont_date + "&to_cont_date=" + to_cont_date + "&ctrl_code=" + ctrl_code
				   + "&seller_code=" + seller_code + "&subject=" + subject + "&ct_flag=" + ct_flag + "&cont_type=" + cont_type + "&contractPriceFlag=" + contractPriceFlag		
		           + "&changeContract=" + changeContract  ;
		
		var grid_col_id = "<%=grid_col_id%>";
		
		var SERVLETURL  = G_SERVLETURL + "?mode=query&grid_col_id="+grid_col_id + param;
		
		param = "mode=query&grid_col_id="+grid_col_id + param;
		GridObj.post(G_SERVLETURL, param);
		GridObj.clearAll(false);
		 --%>
	}
	
	function doModify(){
		if(!checkRows()) return;
		
		var check_count = getCheckedCount(GridObj, 'SELECTED'); //그리드의 체크된 갯수 반환
		
		if(check_count > 1){
			//alert("하나만 선택해주십시오.");
			alert("<%=text.get("MAN_002.0004")%>");
			return;
		}
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		var ct_status = "";
		var ct_flag = "";
		var cont_gl_seq  = ""; 
		var rfq_number = "";
		
		var cont_file_no = "";
		var cont_ins_no = "";
		var contractPrice = "";
		var ct_flag = "";
		
		for(var i = 0; i < grid_array.length; i++)
		{ 
		   cont_no = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue());
		   cont_gl_seq = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
		   ct_flag = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue());
		}		
		
		 

		location.href = "contract_man_update.jsp?cont_no=" + cont_no + "&cont_gl_seq=" + cont_gl_seq;
	}
	
	/**
	 * @Function Name  : doUpdate
	 * @작성일         : 2011. 02. 24
	 * @변경이력       :
	 * @Function 설명  : 계약수정/업체전송/풍산인증/계약폐기
	 */	
	function doUpdate(flag){
		if(!checkRows()) return;
		
		var check_count = getCheckedCount(GridObj, 'SELECTED'); //그리드의 체크된 갯수 반환
		
		if(check_count > 1){
			//alert("하나만 선택해주십시오.");
			alert("<%=text.get("MAN_002.0004")%>");
			return;
		}
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		var ct_status = "";
		var ct_flag = "";
		var cont_gl_seq  = ""; 
		var rfq_number = "";
		
		var cont_file_no = "";
		var cont_ins_no = "";
		var contractPrice = "";
		
		for(var i = 0; i < grid_array.length; i++)
		{ 
		   cont_no = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue());
		   cont_gl_seq = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
		   ct_flag = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue());  
		   rfq_number = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("RFQ_NUMBER")).getValue());  
		   cont_file_no = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_FILE_NO")).getValue());  
		   cont_ins_no  = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_INS_NO")).getValue());   
		   contractPrice  = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONTRACT_PRICE")).getValue());  
		}
		document.forms[0].contractPrice.value = contractPrice;
		document.forms[0].rfq_no.value        = rfq_number; // 마이그레이션데이타는 RFQ번호가 음따!!!
		
		if(flag == "U"){//수정
		
			if(ct_flag != "CT" && ct_flag != "CE" )
			{
				alert("<%=text.get("MAN_002.0015")%>"); // 작성중인경우에만 수정가능합니다.
				return;
			}
			var contractChangeUpdateParam = "";
			if(cont_gl_seq != "1"){
				/* contractChangeUpdateParam = "&doc_type=BCU"; */
				contractChangeUpdateParam = "BCU";
			} 
			/* 
	 		var param = "?cont_no=" + encodeUrl(cont_no) + "&cont_gl_seq=" + encodeUrl(cont_gl_seq) + contractChangeUpdateParam; 
	 		popUpOpen("contract_insert.jsp"+param, 'cont_update_pop', '1040', '700'); 
	 		 */
	 		contractPopup( cont_no , cont_gl_seq , "" , contractChangeUpdateParam );
	 		
	 	}else if(flag == "CB") {//업체전송
		
			if(ct_flag != "CT")
			{
				alert("<%=text.get("MAN_002.0016")%>"); // 작성중인경우에만 업체전송이 가능합니다.
				return;
			}
	 		/* 
	 		var param = "?cont_no="+cont_no+"&cont_gl_seq="+cont_gl_seq+"&view=VI"+"&doc_type=SS";
	 		popUpOpen("contract_insert.jsp"+param, 'cont_update_pop', '1040', '700'); 
	 		 */

	 		contractPopup( cont_no , cont_gl_seq , "VI" , "SS" );
	 	}else if(flag == "CD") {//구매사인증
	 	
	 		if(ct_flag != "CC")
			{
				alert("<%=text.get("MAN_002.0017")%>"); // 업체인증상태에서 인증이 가능합니다.
				return;
			}
	 		//보증보험 연계시 주석해제 ( PSJSJPSJ=YO << 검색어)
	 		if(cont_file_no == "" || cont_ins_no == "" ){
	 			//alert("업체에서 계약이행증권을 등록하지 않아 전자서명(계약완료)를 할 수 없습니다.");
	 			//return;
	 		}
	 		
			/* 
	 		var param = "?cont_no="+cont_no+"&cont_gl_seq="+cont_gl_seq+"&view=VI"+"&doc_type=BA";
	 		popUpOpen("contract_insert.jsp"+param, 'cont_update_pop', '1040', '700'); 
	 		 */
		 	contractPopup( cont_no , cont_gl_seq , "VI" , "BA" );
	 		<%-- 
		   	if (confirm("<%=text.get("MAN_002.0007")%>"))
		   	{  
		   		
				document.form.method = "POST";
				document.form.target = "actionFrame"; 
				document.form.action = "contract_buyer_sign.jsp?ct_flag=CD&cont_no=" + encodeUrl(cont_no) + "&cont_gl_seq=" + encodeUrl(cont_gl_seq);//서버
				document.form.submit(); 
		    }
		   	 --%>
	 	}else if(flag == "CL") {//계약폐기
			if(ct_flag != "CD")
			{
				alert("<%=text.get("MAN_002.0018")%>"); // 한화인증상태에서 폐기가능합니다.
				return;
			}
		   	if (confirm("<%=text.get("MAN_002.0009")%>")) // 계약서를 폐기하시겠습니까?
		   	{
				var cols_ids = "<%=grid_col_id%>";
				
				var SERVLETURL  = G_SERVLETURL + "?mode=update&cols_ids="+cols_ids+"&ct_flag=CL";
			    myDataProcessor = new dataProcessor(SERVLETURL);
				sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
		    }
	 	}else if(flag == "CE") {//변경계약서생성
	 	
			if(ct_flag != "CE" && ct_flag != "CD")
			{
				alert("<%=text.get("MAN_002.0019")%>"); // 한화인증인경우에만 변경계약서 생성이 가능합니다.
				return;
			}
			/* 
	 		var param = "?cont_no="+cont_no+"&cont_gl_seq="+cont_gl_seq+"&doc_type=BCC";
	 		popUpOpen("contract_insert.jsp"+param, 'contract_change', '1040', '700'); 
	 		 */
		 	contractPopup( cont_no , cont_gl_seq , "" , "BCC" );
	 	}
	}

	/**
	 * @Function Name  : doDelere
	 * @작성일         : 2011. 02. 24
	 * @변경이력       :
	 * @Function 설명  : 삭제
	 */	
	function doDelete(){
		if(!checkRows()) return;
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		//삭제 하시겠습니까?
	   	if (confirm("<%=text.get("MESSAGE.1015")%>"))
	   	{
			var cols_ids = "<%=grid_col_id%>";
			var params ="mode=delete&cols_ids="+cols_ids;
			params+=dataOutput();
		 	myDataProcessor = new dataProcessor(G_SERVLETURL,params);
		    sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
	    }
	}	
	
	function doChange() {
	
		if(!checkRows()) return;
		
		var check_count = getCheckedCount(GridObj, 'SELECTED'); //그리드의 체크된 갯수 반환
		
		if(check_count > 1){
			//alert("하나만 선택해주십시오.");
			alert("<%=text.get("MAN_002.0004")%>");
			return;
		}
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		var change_yn = "";
		var ct_flag = "";
		var cont_gl_seq  = ""; 
		
		for(var i = 0; i < grid_array.length; i++)
		{ 
		   cont_no = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue());
		   cont_gl_seq = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
		   ct_flag = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue());  
		   change_yn = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CHANGE_YN")).getValue());  
		}
		
		if(change_yn == "N")
		{
				alert("<%=text.get("MAN_002.0012")%>");
				return;
		} 
		
		if(ct_flag != "CE")
		{
				alert("<%=text.get("MAN_002.0011")%>");
				return;
		}
	 		var param = "?update_flag=D&ct_flag=CT&cont_no=" + encodeUrl(cont_no) + "&cont_gl_seq=" + encodeUrl(cont_gl_seq) ;  
			     
	 		popUpOpen("contract_change.jsp"+param, 'cont_change_pop', '1040', '700'); 
	 		 
	}
	function doOpenPopup(url, width, height)
	{
	  	document.form.action = url;
	  	document.form.method = "post";
	  	
	  	//화면 가운데로 배치
	    var dim = new Array(2);
	
		dim = ToCenter(height,width);
		var top = dim[0];
		var left = dim[1];
	
	    var toolbar = 'no';
	    var menubar = 'no';
	    var status = 'yes';
	    var scrollbars = 'yes';
	    var resizable = 'yes';
	  	
	  	var setValue  = "left="+left+", top="+top+",width="+width+",height="+height+", toolbar="+toolbar+", menubar="+menubar+", status="+status+", scrollbars="+scrollbars+", resizable="+resizable ;
	
	 	var newWin = window.open('','EX', setValue);
	  	document.form.target = "EX";
	  	document.form.submit();
	}
	
	/**
	 * @Function Name  : SP0216_Popup
	 * @작성일       : 2009. 04. 24
	 * @변경이력     :
	 * @Function 설명  : 구매그룹 조회팝업
	 */
	function SP0216_Popup() {
		var url = "<%=POASRM_CONTEXT_NAME%>/common/cm_list1.jsp?code=SP0216&function=SP0216_Code&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=";
		Code_Search(url, '', '', '', '600', '500');
	}
	
	function SP0216_Code(code, text1) {
	    document.forms[0].ctrl_code.value = code  ;
	    document.forms[0].ctrl_name_loc.value = text1 ;
	}	
	function doRemove(inputString){
        //alert(inputString);
        var array_data = inputString.split("||");
        var len = array_data.length;
        for(var i=0;i<len;i++){
            document.getElementById(array_data[i]).value = "";
        }
    } 
	/**
	 * @Function Name  : doInsert
	 * @작성일         : 2009. 07. 10
	 * @변경이력       :
	 * @Function 설명  : 계약생성
	 */	
	function doInsert_price(){
 		popUpOpen("contract_insert.jsp?contractPrice=Y", 'cont_ins_pop', '1040', '700');  
	}
	

	// 오프라인계약서작성
	function doOffMake(){
		var cont_no = "";
		var cont_gl_seq = "";
		var cont    = "";
		var ele_cont_flag = "";
		var ct_flag  = "";
		var cont_form_no  = "";
		
		if(!checkRows()) return;
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		if( grid_array.length > 1 ){
            alert(G_MSS2_SELECT);
            return;
        }
		
		for(var i = 0; i < grid_array.length; i++)
		{
			cont_no          = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue()));
			cont_gl_seq      = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue()));
			cont             = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_TYPE")).getValue()));
			ele_cont_flag    = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ELE_CONT_FLAG")).getValue()));
			cont_form_no     = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_FORM_NO")).getValue()));

			if(ele_cont_flag == "Y") {
				alert("전자계약작성여부가 Yes인것은 오프라인계약서를 작성 할 수 없습니다.");
				return;
			}
			
			ct_flag = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue()));
			
			if(!(ct_flag == "CW")) {
				alert("계약품의가 확정되지 않은 것은 오프라인계약서를 작성 할 수 없습니다.");
				return;
			}
			
		}

	   	if(confirm("오프라인계약서를 생성 하시겠습니까?")){
	   		location.href="contract_make_form_list.jsp?cont_no="+ cont_no + "&cont_gl_seq=" + cont_gl_seq +"&cont="+ cont + "&ele_cont_flag=" + ele_cont_flag;
// 			popUpOpen("contract_make_form_list.jsp?cont_no="+ cont_no + "&cont_gl_seq=" + cont_gl_seq +"&cont="+ cont + "&ele_cont_flag=" + ele_cont_flag, 'CONTRACT_FORM', '700', '330');
		}			
	}	
	

	function doContractMake() {
		var cont_no       = "";
		var cont_gl_seq   = "";
		var cont          = "";
		var ele_cont_flag = "";
		var ct_flag       = "";
		var cont_form_no  = "";
		
		if(!checkRows()) return;
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		if( grid_array.length > 1 ){
            alert(G_MSS2_SELECT);
            return;
        }
		
		for(var i = 0; i < grid_array.length; i++)
		{
			cont_no          = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue()));
			cont             = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_TYPE")).getValue()));
			ele_cont_flag    = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ELE_CONT_FLAG")).getValue()));
			cont_form_no     = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_FORM_NO")).getValue()));
			cont_gl_seq      = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue()));  
			
			if(ele_cont_flag == "N") {
				alert("전자계약작성여부가 No인것은 전자계약서를 작성 할 수 없습니다.");
				return;
			}
			
			ct_flag = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue()));
			
			if(!(ct_flag == "CW")) {
				alert("계약품의가 확정되지 않은 것은 전자계약서를 작성 할 수 없습니다.");
				return;
			}
			
		}
		
<%--	    if("<%=info.getSession("LOGIN_FLAG")%>" == "Y") {                                    --%>
<%--	    	alert("공인인증서로 로그인 하지 않았습니다. \n등록된 인증서로 로그인하여 주세요.");--%>
<%--	    	return;                                                                            --%>
<%--	    }--%>
		
	   	if(confirm("전자계약서를 생성 하시겠습니까?")){
			if( cont_form_no != "" ){ // 반려상태이기때문에 cont_form_no 가있다. 
				location.href = "contract_make_insert.jsp?flag=N&cont_form_no=" + cont_form_no + "&cont_no=" + cont_no + "&ele_cont_flag=" + ele_cont_flag+ "&cont_gl_seq=" + cont_gl_seq;
			}
			else{   		
				//popUpOpen("contract_make_form_list.jsp?cont_no="+ cont_no +"&cont="+ cont + "&ele_cont_flag=" + ele_cont_flag + "&cont_gl_seq=" + cont_gl_seq, 'CONTRACT_FORM', '700', '330');
				location.href = "contract_make_form_list.jsp?cont_no="+ cont_no +"&cont="+ cont + "&ele_cont_flag=" + ele_cont_flag + "&cont_gl_seq=" + cont_gl_seq;
			}
		}
	}	
	function entKeyDown(){
	    if(event.keyCode==13) {
	        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
	        
	        doQuery();
	    }
	}
	
	//지우기
	function doRemove( type ){
	    if( type == "ctrl_person_id" ) {
	    	document.forms[0].ctrl_person_id.value = "";
	        document.forms[0].ctrl_person_name.value = "";
	    }  
	}
	
	function SP9113_Popup() {
		window.open("/common/CO_008.jsp?callback=SP9113_getCode", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}

	function  SP9113_getCode(ls_ctrl_person_id, ls_ctrl_person_name) {
		document.forms[0].ctrl_person_id.value         = ls_ctrl_person_id;
		document.forms[0].ctrl_person_name.value       = ls_ctrl_person_name;
	}	
	
	function searchProfile(fc) {
		if(fc =="seller_code"){
			window.open("/common/CO_014.jsp?callback=SP0054_getCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
		}
	}
	
	function SP0054_getCode(code, text1, text2) {
		document.forms[0].seller_code.value = code;
		document.forms[0].seller_name.value = text1;
	}
	
	//지우기
	function doRemove( type ){
	    if( type == "sign_person_id" ) { 
	    	document.forms[0].sign_person_id.value = "";
	        document.forms[0].sign_person_name.value = "";
	    } 
	    if( type == "seller_code" ) {
	    	document.forms[0].seller_code.value = "";
	        document.forms[0].seller_name.value = "";
	    }
	    if( type == "req_dept" ) {
	    	document.forms[0].req_dept.value = "";
	        document.forms[0].req_dept_name.value = "";
	    }
	}

	
</script>
</head>

<body leftmargin="10" topmargin="6" onload="setGridDraw();initAjax();">
	<s:header>
		<%@ include file="/include/sepoa_milestone.jsp"%>
		<table width="99%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5">&nbsp;</td>
			</tr>
		</table>
		<form name="form">
			<input type="hidden" id="contractPriceFlag" name="contractPriceFlag"
				value="<%=contractPrice%>" /> <input type="hidden"
				name="contractPrice" /> <input type="hidden" name="cont_no" /> <input
				type="hidden" name="cont_gl_seq" /> <input type="hidden"
				name="rfq_no" /> <input type="hidden" name="view" /> <input
				type="hidden" name="doc_type" /> <input type="hidden"
				name="attachrow" id="attachrow"> <input type="hidden"
				name="isGridAttach" id="isGridAttach"> <input type="hidden"
				name="ins_flag" id="ins_flag">

			<table width="100%" border="0" cellspacing="0" cellpadding="1">
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="1" cellpadding="0"
							bgcolor="#dedede">
							<tr>
								<td width="100%">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="8%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
		        								계약구분
		        							</td>
		      								<td class="data_td"   width="25%" >
		        								<select id="sg_type1" name="sg_type1" class="inputsubmit" onchange="nextAjax('2');">
						    						<option value="">전체</option>
						    					</select>
							    	
						    					<select id="sg_type2" name="sg_type2" class="inputsubmit" >
						    						<option value="">전체</option>
						    					</select>
		      								</td>  
		      								<td width="8%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
		        								계약방법
		        							</td>
		      								<td class="data_td"   width="15%" >
		        								<select id="cont_process_flag" name="cont_process_flag">
			        								<option value="">전체</option>
			        							</select><!-- M809 -->
		      								</td>
		      								<td width="8%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
		        								업체명
		        							</td>
		      								<td class="data_td" >
		        								<input type="text" onkeydown='entKeyDown()'  name="seller_code" id="seller_code" style="width:80px;ime-mode:inactive" class="inputsubmit" maxlength="10" >
												<a href="javascript:searchProfile('seller_code')">
													<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
												</a>
												<a href="javascript:doRemove('seller_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
												<input type="text" onkeydown='entKeyDown()'  name="seller_name" id="seller_name" style="width:120px" class="inputsubmit">
				        						
		      								</td>                
										</tr>
										<tr>
											<td colspan="4" height="1" bgcolor="#dedede"></td>
										</tr>	
										<tr>
											<td width="8%" class="title_td">&nbsp;<img	src="/images/blt_srch.gif" width="7" height="7"	align="absmiddle">
												계약일자</td>
											<td class="data_td"><s:calendar id_from="from_cont_date" default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" id_to="to_cont_date"	default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d" /></td>
											<td width="8%" class="title_td">&nbsp;<img	src="/images/blt_srch.gif" width="7" height="7"	align="absmiddle">
												입찰방법</td>
											<td class="data_td" colspan="3">
												<select id="cont_type1_text" name="cont_type1_text">
			        								<option value="">전체</option>
			        							</select><!-- M994 -->&nbsp;&nbsp;
			        							<select id="cont_type2_text" name="cont_type2_text">
			        								<option value="">전체</option>
			        							</select><!-- M993 -->        			
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
					<td height="30" align="right">
						<TABLE cellpadding="0">
							<TR>
								<td><script language="javascript">btn("javascript:doQuery()", "<%=text.get("BUTTON.search")%>");</script></td><%-- 조회 --%>
								<td><script language="javascript">btn("javascript:doModify()", "<%=text.get("BUTTON.update")%>");</script></td><%-- 수정 --%>
								<td><script language="javascript">btn("javascript:doDelete()", "<%=text.get("BUTTON.deleted")%>");</script></td><%-- 삭제 --%>
							</TR>
						</TABLE>
					</td>
				</TR>
			</TABLE>
			<iframe name="actionFrame" src="" frameborder="0" width="0"
				height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
		</form>
	</s:header>
	<s:grid screen_id="MAN_002" grid_obj="GridObj" grid_box="gridbox" />
	<s:footer />
</body>