<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>
 
<%
	String to_day 	 = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-30);
	String to_date 	 = to_day;	

	Vector multilang_id = new Vector();
	multilang_id.addElement("CTS_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	

	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String user_type    = info.getSession("USER_TYPE");
	String house_code = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
	String company_name = info.getSession("COMPANY_NAME");
	String CTRL_CODE   	  = info.getSession("CTRL_CODE");
	
	//String CTRL_TYPE      = CTRL_CODE.substring(0, 2);
	String CTRL_TYPE      = "";
	String USER_ID        = info.getSession("ID"); 
	
	// Dthmlx Grid 전역변수들..
	String screen_id = "CTS_002";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	boolean isSupplier = false;
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
	
// 	List Box
	String CT_FLAG = ListBox(request, "SL0018", house_code + "#M286", "");
	
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"                         %><!-- CSS  -->
<%@ include file="/include/sepoa_grid_common.jsp"                   %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>
<!-- <script src="../js/cal.js" language="javascript"></script> -->

<Script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_list_seller_info";

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
    	doQuery();
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
    
    function doOnRowSelected(rowId,cellInd)
    {
    	var header_name = GridObj.getColumnId(cellInd);

    	if( header_name == "CONT_NO")
		{
			var cont_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_NO")).getValue());
			var cont_gl_seq  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_GL_SEQ")).getValue()); 
	 		/* 
			var url = "contract_insert.jsp?doc_type=SA&view=VI&cont_no="+encodeUrl(cont_no)+"&cont_gl_seq="+encodeUrl(cont_gl_seq);
			var width = "1040";
			var height = "700";
			
			doOpenPopup(url, width, height);
			*/
		 	contractPopup( cont_no , cont_gl_seq , "VI" , "SA" );
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
	 
			if(ins_vn == "서울금융보증보험" && (file_no.length > 0) ){  
				
				var url = "contract_bond_view.jsp?update_flag=D&cont_no="+encodeUrl(cont_no)+"&cont_gl_seq="+encodeUrl(cont_gl_seq)+"&ins_flag=PREGUA";
				var width = "800";
				var height = "700";
				
				doOpenPopup(url, width, height); 
			}else{
				document.forms[0].attachrow.value = rowId;
				document.forms[0].isGridAttach.value = "true"
				document.forms[0].ins_flag.value = "PREINF"
				attach_file_grid(LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("PRE_FILE_NO")).getValue()),'CT');
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
			
			if(ins_vn == "서울금융보증보험" && (file_no.length > 0) ){  
				
				var url = "contract_bond_view.jsp?update_flag=D&cont_no="+encodeUrl(cont_no)+"&cont_gl_seq="+encodeUrl(cont_gl_seq)+"&ins_flag=CONGUA";
				var width = "800";
				var height = "700";
				
				doOpenPopup(url, width, height); 
				
			}else{
				document.forms[0].attachrow.value = rowId;
				document.forms[0].isGridAttach.value = "true"
				document.forms[0].ins_flag.value = "CONGUA"
				attach_file_grid(LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_FILE_NO")).getValue()),'CT');
			}
 
		}
		
		
    	else if( header_name == "FAULT_FILE_NO_IMG")
		{
	        var TYPE        = 'ALUP';
	        var view_type   = 'VI';

	        //var attach_key = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("FAULT_FILE_NO")).getValue());
			
	        //FileAttach(TYPE, attach_key, view_type);
	        //return;				
 	
			var cont_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_NO")).getValue());
			var cont_gl_seq  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_GL_SEQ")).getValue()); 
			var ins_vn = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_INS_VN")).getValue()); 
			var file_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("FAULT_INS_PATH")).getValue()); 
			if(ins_vn == "서울금융보증보험" && (file_no.length > 0) ){  
				
				var url = "contract_bond_view.jsp?update_flag=D&cont_no="+encodeUrl(cont_no)+"&cont_gl_seq="+encodeUrl(cont_gl_seq)+"&ins_flag=FLRGUA";
				var width = "800";
				var height = "700";
				
				doOpenPopup(url, width, height); 
			}else{
				document.forms[0].attachrow.value = rowId;
				document.forms[0].isGridAttach.value = "true"
				document.forms[0].ins_flag.value = "FLRINF"
				attach_file_grid(LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("FAULT_FILE_NO")).getValue()),'CT');
			}
 		
		}
    }
    
	// 첨부파일
	function setAttach(attach_key, arrAttrach, attach_count) {

		if(document.forms[0].isGridAttach.value == "true"){
			setAttach_Grid(attach_key, arrAttrach, attach_count);
			return;
		}

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
	
		document.forms[0].ATTACH_NO.value     	= attach_key;
		document.forms[0].ATTACH_CNT.value     	= attach_count;
	}
	
	//그리드 파일첨부
	function setAttach_Grid(attach_key, arrAttrach, attach_count) {

	    var attachfilename  = arrAttrach + "";
	    var result 			="";
	    var ins_flag		= document.forms[0].ins_flag.value;
	
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
		if(ins_flag == "CONGUA"){
			GridObj.cells(document.form.attachrow.value, GridObj.getColIndexById("CONT_FILE_NO")).setValue(attach_key);
			//GridObj.cells(document.form.attachrow.value, GridObj.getColIndexById("ATTACH_CNT")).setValue(attach_count);
		}else if(ins_flag == "FLRINF"){
			GridObj.cells(document.form.attachrow.value, GridObj.getColIndexById("FAULT_FILE_NO")).setValue(attach_key);
			//GridObj.cells(document.form.attachrow.value, GridObj.getColIndexById("ATTACH_CNT")).setValue(attach_count);
		}else{
			GridObj.cells(document.form.attachrow.value, GridObj.getColIndexById("PRE_FILE_NO")).setValue(attach_key);
			//GridObj.cells(document.form.attachrow.value, GridObj.getColIndexById("ATTACH_CNT")).setValue(attach_count);
		}
		document.forms[0].isGridAttach.value = "false";
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
			 
		        if( cellInd == GridObj.getColIndexById("CONT_INS_VN"))
				{ 
					//alert(SepoaGridGetCellValueId(GridObj, rowId, "CONT_INS_VN"));
					var cont_ins_vn = SepoaGridGetCellValueId(GridObj, rowId, "CONT_INS_VN");
					SepoaGridSetCellValueId(GridObj, rowId , "CONT_INS_VN_CODE", cont_ins_vn);   
				}
			
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

		alert("선택된 행이 없습니다.");
		return false;
	}
    function initAjax()
	{ 
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
	 * @Function Name  : getContractListSeller
	 * @작성일         : 2009. 07. 06
	 * @변경이력       : 2013. 04. 01 CTY
	 * @Function 설명  :  조회
	 */		
	function doQuery()
	{
		var from_cont_date	= encodeUrl(del_Slash(LRTrim(document.form.from_cont_date.value)));
		var to_cont_date  	= encodeUrl(del_Slash(LRTrim(document.form.to_cont_date.value))); 
		 
			if(LRTrim(from_cont_date) == "" || LRTrim(from_cont_date) == "" ) { 
	            alert("<%=text.get("CTS_001.0002")%>");
	            return;
	        }
	
	        if(!checkDate(del_Slash(from_cont_date))) { 
	             alert("<%=text.get("CTS_001.0003")%>");
	            document.form.from_cont_date.select();
	            return;
	        }
	        
	        if(!checkDate(del_Slash(to_cont_date))) { 
	             alert("<%=text.get("CTS_001.0003")%>");
	            document.form.to_cont_date.select();
	            return;
	        } 
        
        var cols_ids = "<%=grid_col_id%>";
        var param = "&mode=query";
        param += "&cols_ids="    + cols_ids;
        param += dataOutput();
        GridObj.post(G_SERVLETURL, param);
        GridObj.clearAll(false);
	}
	/**
	 * @Function Name  : doInsNoInsert
	 * @작성일         : 2009. 07. 10
	 * @변경이력       :
	 * @Function 설명  : 증권번호업등록
	 */	
	function doInsNoInsert(){
		if(!checkRows()) return;
		
		var check_count = getCheckedCount(GridObj, 'SELECTED'); //그리드의 체크된 갯수 반환
		
		if(check_count > 1){
			//alert("하나만 선택해주십시오.");
			alert("<%=text.get("CT_006.0004")%>");
			return;
		}
		 
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		 
		for(var i = 0; i < grid_array.length; i++)
		{
			var ins_vn = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_INS_VN")).getValue()); 
			var cont_ins_no = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_INS_NO")).getValue()); 
			var cont_file_no = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_FILE_NO")).getValue()); 

			if(ins_vn == "")
			{ 
				alert("<%=text.get("CTS_002.0005")%>");
				return;
			}
			if(cont_ins_no == "")
			{ 
				//alert("<%=text.get("CTS_002.0006")%>");
				//return;
			}
			if(cont_file_no == "")
			{ 
				//alert("<%=text.get("CTS_002.0007")%>");
				//return;
			}
		 }  
	   	if (confirm("등록하시겠습니까?"))
	   	{
			var cols_ids = "<%=grid_col_id%>"; 
			var SERVLETURL  = G_SERVLETURL + "?mode=insert&cols_ids="+cols_ids;
		    myDataProcessor = new dataProcessor(SERVLETURL);
			sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	    }
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

	function contractPopup(cont_no,cont_gl_seq,view,doc_type){

        if(cont_no != ''){
            document.forms[0].cont_no.value     = cont_no;
            document.forms[0].cont_gl_seq.value = cont_gl_seq;
            document.forms[0].view.value        = view;            
            document.forms[0].doc_type.value    = doc_type; 
            var url = "contract_detail_print.jsp?cont_no=" + cont_no + "&cont_gl_seq=" + cont_gl_seq + "&cont_form_no=" + cont_no;
            doOpenPopup( url, '1000', '750' );
        }
    }
	
	
	
	function doReject(){		
		if(!checkRows()) return;

		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		for(var i = 0; i < grid_array.length; i++)
		{ 
		   cont_no = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue());
		   cont_gl_seq = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue()); 
		   ct_flag = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue()); 
		   alert(ct_flag);
		}

		var check_count = getCheckedCount(GridObj, 'SELECTED'); //그리드의 체크된 갯수 반환
		if(check_count > 1){
			//alert("하나만 선택해주십시오.");
			alert("<%=text.get("CTS_001.0004")%>");
			return;
		}
		
		if(ct_flag == "CE"){
			alert("이미 반려요청된 건입니다."); // 이미 변경요청된 건입니다.
			return;
		}
		 
        var width = 700;
    	var height = 150;
        var left = "";
		var top = "";
	
	    //화면 가운데로 배치
	    var dim = new Array(2);
	
		dim = ToCenter(height,width);
		top = dim[0];
		left = dim[1];
	
	    var toolbar = 'no'; 
	    var menubar = 'no';
	    var status = 'yes';
	    var scrollbars = 'yes';
	    var resizable = 'yes';
	    //window.open("contract_reject_popup.jsp?update_flag=U", 'reject_pop', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	    var url = "contract_reject_popup.jsp?update_flag=U";
	    doOpenPopup(url, "700", "150", null);
	    
	}
	
	function doRejectConfirm(reject_reason){
		document.form.reject_reason.value = reject_reason;
		if(!checkRows()) return;
		
		var check_count = getCheckedCount(GridObj, 'SELECTED'); //그리드의 체크된 갯수 반환
		
		if(check_count > 1){
			//alert("하나만 선택해주십시오.");
			alert("<%=text.get("CTS_001.0004")%>");
			return;
		}
		 
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		  
		var ct_status = ""; 
		var cont_gl_seq  = ""; 
		
		for(var i = 0; i < grid_array.length; i++)
		{ 
		   cont_no = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue());
		   cont_gl_seq = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue()); 
		   ct_flag = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue()); 
		   alert(ct_flag);
		}
		
		if(ct_flag == "CE"){
			alert("이미 반려요청된 건입니다."); // 이미 변경요청된 건입니다.
			return;
		}
		 
	   	if (confirm("반려 하시겠습니까?")) // 계약변경요청 하시겠습니까?
	   	{
			var cols_ids = "<%=grid_col_id%>";
            var params="mode=reject";
            params += "&cols_ids=" + cols_ids;
            params += dataOutput();
            myDataProcessor = new dataProcessor(G_SERVLETURL,params);
            sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
	    }
	}
	

	function doDrop(){
		if(!checkRows()) return;
/*
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var checked_count;

		for(var i = 0; i < grid_array.length; i++)
		{
			checked_count++;
		}
		
		if(checked_count > 1){
            alert(G_MSS2_SELECT);
            return;
        }
*/
		var grid_array  = getGridChangedRows(GridObj, "SELECTED");
		var wise 		= GridObj;
		var iCheckedRow = Number(checkedOneRow('SELECTED'))-1;
	    if(iCheckedRow < 0)
	        return;
	    
       	var cont_no = "";
       	var cont_gl_seq = "";
       	var ct_flag = "";
       	var cont_dd_flag = "";
       	var fault_dd_flag = "";
       	var cont_ins_no = "";
       	var falut_ins_no = "";
		var save_flag   = "ST";
        
		for(var i = 0; i < grid_array.length; i++)
		{
			cont_no         = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue());
			cont_gl_seq     = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
			ct_flag         = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue());
// 			cont_ins_no     = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_INS_NO")).getValue());
// 			fault_ins_no    = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("FAULT_INS_NO")).getValue());
// 			cont_dd_flag    = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_DD_FLAG")).getValue());
// 			fault_dd_flag   = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("FAULT_DD_FLAG")).getValue());
		}
 
		// 우리은행인증, 업체인증, 업체전송, 업체변경요청 인 경우
		if( ct_flag != "CR" ){
			alert("계약서 상태가 폐기요청인 상태만 계약폐기가 가능합니다.");
			return;	
		}
		/*
		if(cont_ins_no == "" && fault_ins_no == ""){
			alert("폐기할 증권이 없습니다.");
			return;	
		}
		
		if(cont_ins_no == "" && cont_dd_flag != "") {
			alert("폐기할 계약이행보증증권이 없습니다.");
			return;	
		}
		
		if(fault_ins_no == "" && fault_dd_flag != "") {
			alert("폐기할 하자이행보증증권이 없습니다.");
			return;	
		}
		*/
// 		if(cont_dd_flag == "" && fault_dd_flag == ""){
// 			alert("폐기할 증권(계약이행 또는 하자이행)을 선택해주세요.");
// 			return;	
// 		}
		
		if( confirm("계약서를 폐기하시겠습니까?") ) { 
			var param  = "cont_no="        + cont_no ;
				param += "&save_flag="     + save_flag ;
				param += "&cont_form_no=&vendor_in_attach_no";
				param += "&cont_gl_seq="   + cont_gl_seq;
				param += "&cont_dd_flag="  + cont_dd_flag;
				param += "&fault_dd_flag=" + fault_dd_flag;
				param += "&ct_flag=CV";    
				
			document.form.method = "POST";
			//document.form.target = "childFrame";
			document.form.action = "contract_list_seller_abol.jsp?"+param;
			document.form.submit();
		}					
	}	

	// 회수처리
	function doCollection(){
		if(!checkRows()) return;
		var grid_array  = getGridChangedRows(GridObj, "SELECTED");
		var wise 		= GridObj;
		var iCheckedRow = Number(checkedOneRow('SELECTED'))-1;
	    if(iCheckedRow < 0)
	        return;

	    document.forms[0].cont_no.value     = LRTrim(wise.GetCellValue("CONT_NO"    , iCheckedRow));
	    document.forms[0].cont_gl_seq.value = LRTrim(wise.GetCellValue("CONT_GL_SEQ", iCheckedRow));

		if( confirm("회수하시겠습니까?") ) { 
			var cols_ids = "<%=grid_col_id%>";
            var params   = "mode=Collection";
            	params  += "&cols_ids=" + cols_ids;
            	params  += dataOutput();
            myDataProcessor = new dataProcessor(G_SERVLETURL,params);
            sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
		}
	}
</script>
</head>

<body leftmargin="10" topmargin="6" onload="initAjax();setGridDraw();">
<s:header>
<form name="form">  
	<input type="hidden" name ="reject_reason" id="reject_reason"/>
	<input type="hidden" name="cont_no" id="cont_no"/>
	<input type="hidden" name="cont_gl_seq" id="cont_gl_seq"/>
	<input type="hidden" name="view"/>
	<input type="hidden" name="doc_type"/>
    <input type="hidden" name="attachrow">
    <input type="hidden" name="isGridAttach">
    <input type="hidden" name="ins_flag">
<%
// 	thisWindowPopupFlag = "true";
// 	thisWindowPopupScreenName = "전자계약진행현황"; //전자계약진행현황
%>
<%@ include file="/include/sepoa_milestone.jsp"%>
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
	    						<td width="100%" valign="top">
									<table width="100%"  class="board-search" border="0" cellpadding="0" cellspacing="0">
              							<colgroup>
                							<col width="10%" />
                							<col width="35%" />
                							<col width="10%" />
                							<col width="35%" />
              							</colgroup>	
		      							<tr>
		        							<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("CTS_002.T_CONT_ADD_DATE")%></td><%-- 계약작성일자 --%>
        									<td class="data_td">
        										<s:calendar id_from="from_cont_date" default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" id_to="to_cont_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d" />
        									</td>
        									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("CTS_002.T_SUBJECT")%></td> <%-- 계약명 --%>
        									<td class="data_td">
        										<input type="text" name="subject" id="subject" size="20" class="inputsubmit" value="" style="width : 98%">
        									</td>
			  							</tr>
		      							<tr>
		        							<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약상태</td><%-- 계약상태 --%>
        									<td class="data_td" colspan="3">
        										<select id="ct_flag" name="ct_flag" class="inputsubmit">
        											<option value="">전체</option>
													<%=CT_FLAG%>
												</select>
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
		
<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
	<TR>
		<td style="padding:5 5 5 0" align="right">
			<TABLE cellpadding="2" cellspacing="0">
				<TR>
			  		<td><script language="javascript">btn("javascript:doQuery()","<%=text.get("BUTTON.search")%>")</script></td> <%-- 조회 --%>
			  		<td><script language="javascript">btn("javascript:gridExport(<%=grid_obj%>);","엑셀다운")		</script></td> 
			  	  	<td><script language="javascript">btn("javascript:doDrop()","폐기승인")</script></td> 
			  	  	<td><script language="javascript">btn("javascript:doCollection()","회수")</script></td>
				</TR>
			</TABLE>
		</td>
	</TR>
</TABLE>
</form>
</s:header>
<iframe id="childFrame" name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="CTS_002" grid_box="gridbox" grid_obj="GridObj"/> --%>

<s:footer/>
</body>