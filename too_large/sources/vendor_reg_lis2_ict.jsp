<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_SU_103");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_SU_103";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON     = "/images/ico_zoom.gif"; 

%>
<!--
 Description:  	업체등록관리/등록업체목록<p>
-->

<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID="I_SU_103";%>



<%
	String house_code 	= info.getSession("HOUSE_CODE");
	String user_id 		= info.getSession("ID");
	String company_code = info.getSession("COMPANY_CODE");
	String ctrl_code	= info.getSession("CTRL_CODE");
	String menu_profile_code1 = info.getSession("MENU_TYPE");

%>

<%
	String popup = "Y";
	popup = "Y";
    //if (admin_flag) popup = "U";
    ////********협력업체 수정은 전체admin 및 업체admin만 수정가능***********************************
%>


<html>	
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
<!--

	var INDEX_SEL;
	var INDEX_NAME_LOC;
	var INDEX_VENDOR_CODE;
	var INDEX_CREDIT_GRADE;
	var INDEX_PURCHASE_BLOCK_FLAG;
	var INDEX_IRS_NO;
	var INDEX_CLASS_GRADE;
	
	var INDEX_GB_GJ;
	var INDEX_GB_GJ_NM;

	function Init(){
		setGridDraw();
		setHeader();
	}
	function setHeader()
	{

		INDEX_SELECTED       		= GridObj.GetColHDIndex("SELECTED");
		INDEX_NAME_LOC 				= GridObj.GetColHDIndex("NAME_LOC");
		INDEX_VENDOR_CODE 			= GridObj.GetColHDIndex("VENDOR_CODE");
		INDEX_CREDIT_GRADE 			= GridObj.GetColHDIndex("CREDIT_GRADE");
		INDEX_PURCHASE_BLOCK_FLAG 	= GridObj.GetColHDIndex("PURCHASE_BLOCK_FLAG");
		INDEX_APPROVAL_REASON 		= GridObj.GetColHDIndex("APPROVAL_REASON");
		INDEX_IRS_NO				= GridObj.GetColHDIndex("IRS_NO");
		INDEX_CLASS_GRADE			= GridObj.GetColHDIndex("CLASS_GRADE");
		
		INDEX_GB_GJ             = GridObj.GetColHDIndex("GB_GJ");
		INDEX_GB_GJ_NM          = GridObj.GetColHDIndex("GB_GJ_NM");

		//조회된 화면을 View한다.
		//doSelect();
	}

	//Data Query해서 가져오기
	function doSelect()
	{
		var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.master.register.vendor_reg_lis2_ict";
		
		var cols_ids = "<%=grid_col_id%>";
		var params = "mode=getRegVenLst";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( G_SERVLETURL, params );
		GridObj.clearAll(false);
		
	}
	
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}

	function getCredit(vendor_code)
	{
		MM_openBrWindow('about:blank','subpop','width=716,height=660,left=40,top=20,resizable=yes');
		GotoUrl('https://www.ecredit.co.kr/embedded/pri/p_index.asp?bizno=' + vendor_code + '&EID=WJT','subpop');
	}

	var doc;
	function popup(url, flag)
	{
		var left = 0;
		var top = 0;
		var width = 750;
		var height = 700;

		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'yes';
		var resizable = 'yes';
		if(flag == 2) {
			width = 600;
			height = 550;
			scrollbars = 'no';
			resizable = 'no';
		} else if(flag == 1) {
			width = 400;
			height = 200;
			scrollbars = 'no';
			resizable = 'no';
		}
		doc = window.open( url, 'doc', 'left=250, top=150, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	//enter를 눌렀을때 event발생
	function entKeyDown() {
  		if(event.keyCode==13) {
   			window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
   			doSelect();
  		}
  	}
	/*
	function vendorReg() {        
		window.open("/s_kr/admin/info/ven_bd_agree.jsp","ven_bd_agree","left=50,top=50,width=690,height=200,resizable=yes,scrollbars=yes");
	}
	*/
	
	//function vendorMod () {
    //    var row 		= GridObj.GetRowCount();
    //    var chkcnt 		= 0;
    //    var vendor_code = "";
    //    var irs_no 		= "";
    //    
    //    for(var i = 0;i < row;i++){
    //        if(GD_GetCellValueIndex(GridObj,i,INDEX_sel) == "true"){
    //            chkcnt++;
	//			
    //            vendor_code = GD_GetCellValueIndex(GridObj,i, INDEX_vendor_code);
    //            irs_no      = GD_GetCellValueIndex(GridObj,i, INDEX_IRS_NO);
    //        }
    //    }
    //	if(chkcnt == 0){
	//	    alert(G_MSS1_SELECT);
	//	    return;
	//	}
	//	if(chkcnt != 1){
	//	    alert(G_MSS2_SELECT);
	//	    return;
	//	}
	//	window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=<%=popup%>&mode=irs_no&CompanyCode=<%=company_code%>&vendor_code="+vendor_code+"&irs_no="+irs_no+"&user_type=","ven_bd_con","left=0,top=0,width=950,height=700,resizable=yes,scrollbars=yes");
	//}

  	//1 - 이벤트종류, 2-행의 인덱스 3-열의인덱스, 4-이벤트 지정셀의 이전값, 5-현재값(변경된)
  	function JavaCall(msg1,msg2,msg3,msg4,msg5)
  	{
		//내용보기	
		if(msg3 == INDEX_APPROVAL_REASON) {
			if(GridObj.GetCellHiddenValue("APPROVAL_REASON", msg2) == ""){
				return;
			}
	        var url = "/kr/master/register/vendor_approval_reason.jsp?ROW=" + msg2;
			var left = 150;
			var top = 150;
			var width = 600;
			var height = 300;
			var toolbar = 'no';
			var menubar = 'no';
			var status = 'yes';
			var scrollbars = 'yes';
			var resizable = 'no';
			var APPROVAL_REASON = window.open( url, 'APPROVAL_REASON', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
			APPROVAL_REASON.focus();
			
		}
		
		if(msg3 == INDEX_CREDIT_GRADE){
			var irs_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_IRS_NO);
			
			irs_no = irs_no.replace(/-/gi, "");

			var credit_grade = GD_GetCellValueIndex(GridObj,msg2,INDEX_CREDIT_GRADE);
			if(credit_grade == ""){
				alert("신용등급이 없습니다."); 
				return;
			} 
			var url = "http://clip.nice.co.kr/rep_nclip/rep_DLink/rep_Link_ibk.jsp?bz_ins_no="+irs_no; 
			var credit_eval = window.open(url,"credit","left=0,top=0,width=900,height=780,resizable=yes,scrollbars=yes");
			credit_eval.focus();
		}
		
		if(msg1 == "doData") { // 전송/저장시
            alert(GridObj.GetMessage());
            doSelect();
		}
	}

  	function MATERIAL_CLASS1_Changed()
  	{
  	  	var sg_refitem = form1.material_class1.value;
  	  	target = "MATERIAL_CLASS1";
  	  	data = "vendor_reg_hidden.jsp?target=" + target + "&sg_refitem=" + sg_refitem;
  	  	this.hiddenframe.location.href = data;
  	}

  	function clearMATERIAL_CLASS1()
  	{
  	  	if(form1.material_class1.length > 0)
  	  	{
  	    		for(i=form1.material_class1.length-1; i>=0;  i--) {
  	     			form1.material_class1.options[i] = null;
  	    		}
  	  	}
  	}

  	function setMATERIAL_CLASS1(name, value)
  	{
  		var option1 = new Option(name, value, true);
  	  	form1.material_class1.options[form1.material_class1.length] = option1;
  	}

  	function MATERIAL_CTRL_TYPE_Changed()
  	{
  	  	clearMATERIAL_CLASS1();
  	  	var sg_refitem = form1.material_ctrl_type.value;
  	  	target = "MATERIAL_CTRL_TYPE";
  	  	data = "vendor_reg_hidden.jsp?target=" + target + "&sg_refitem=" + sg_refitem;
  	  	this.hiddenframe.location.href = data;
  	}

  	function clearMATERIAL_CTRL_TYPE()
  	{
  	  	if(form1.material_ctrl_type.length > 0) {
  	    		for(i=form1.material_ctrl_type.length-1; i>=0;  i--) {
  	     			form1.material_ctrl_type.options[i] = null;
  	    		}
  	  	}
  	}

  	function setMATERIAL_CTRL_TYPE(name, value)
  	{
  	  	var option1 = new Option(name, value, true);
  	  	form1.material_ctrl_type.options[form1.material_ctrl_type.length] = option1;
  	}

  	function MATERIAL_TYPE_Changed()
  	{
  	  	clearMATERIAL_CTRL_TYPE();
  	  	setMATERIAL_CTRL_TYPE("----------", "");
		clearMATERIAL_CLASS1();
  	  	setMATERIAL_CLASS1("----------", "");
  	    var sg_refitem = form1.material_type.value;
  	  	target = "MATERIAL_TYPE";
  	  	data = "vendor_reg_hidden.jsp?target=" + target + "&sg_refitem=" + sg_refitem;
  	  	this.hiddenframe.location.href = data;
  	  	//location.href = data;
  	}

  	function approvalSign(){
		hiddenframe.location.href='/kr/admin/basic/approval/approval.jsp?house_code=<%=info.getSession("HOUSE_CODE")%>&company_code=<%=info.getSession("COMPANY_CODE")%>&dept_code=<%=info.getSession("DEPARTMENT")%>&req_user_id=<%=info.getSession("ID")%>&doc_type=VM&fnc_name=getApproval';
	}

  	function approval(){


  		var checkedCnt = 0;
  		var checkedIndex;
  		var VENDOR_CODE = "";
		for(var i=0; i<GridObj.GetRowCount(); i++){
			if(GridObj.GetCellValue("SELECTED", i) == true){
				checkedCnt++;
				checkedIndex = i;
				if(checkedCnt > 1){
					alert("한업체만 선택하실수 있습니다.");
					return;
				}
			}
		}

		if(checkedCnt == 0){
			alert("선택한 업체가 없습니다.");
			return;
		}

		document.forms[0].vendor_code.value = GridObj.GetCellValue("VENDOR_CODE", checkedIndex);
		if(GridObj.GetCellValue("PURCHASE_BLOCK_FLAG", checkedIndex) != 'N'){
			alert("거래상태가 거래인 경우에만 거래중지 하실 수 있습니다.");
			return;
		}
//	    if(!confirm("결재요청 하시겠습니까?"))
//	    	return;
		//approvalSign(); 
		//거래중지 결재요청은 하지 않는다 바로 승인 처리한다.
		
		//아래 임시 승인 처리한다.
		getApproval('E');
	}

	function getApproval(str){
	    if(!confirm("결재요청 하시겠습니까?")) return;
	    if(str == '') return;

	    var sign_flag = "";
	    saveRock = true;
	    if(str=="SAVE")
	        sign_flag = "T";   // 작성중
	    else
	        sign_flag = "P";   // 결재중(결재상신)
	        
	    sign_flag = "E";   // 결재중(결재상신)

	    document.forms[0].sign_flag.value	= sign_flag			;
	    document.forms[0].approval.value	= str				;
		document.forms[0].ctrl_code.value	= "<%=ctrl_code%>"	;

		document.forms[0].method = "POST";
	    document.forms[0].action = "/kr/master/vendor/sta_wk_ins1.jsp"
	    document.forms[0].target = "hiddenframe"
	    document.forms[0].submit();
	}

	function Saved(message, v_status){
		alert(message);
		doSelect();
	}

  	function setBlock(PURCHASE_BLOCK_FLAG){		//거래개시
		var sepoa       =  GridObj;
		var vendor_code = "";
		var sel_row     = 0;

		var PURCHASE_BLOCK_NOTE = "";
		
		/* P:결재진행중 N:거래 Y:중지 */
		var PURCHASE_BLOCK_FLAG_STR = PURCHASE_BLOCK_FLAG == "Y" ? "거래중지" : "거래개시"				
		for(var i=0;i<sepoa.GetRowCount();i++)
		{
			var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);
			
			if(temp == true) {
				if(GridObj.GetCellValue("PURCHASE_BLOCK_FLAG", i) == 'S'){
					alert("탈퇴인 경우는 조작할 수 없습니다.");
					return;
				}
				
				if(PURCHASE_BLOCK_FLAG == 'N' && GridObj.GetCellValue("PURCHASE_BLOCK_FLAG", i) != 'Y'){
					alert("거래상태가 중지인 경우에만 거래개시 하실 수 있습니다.");
					return;
				}
				
				if(PURCHASE_BLOCK_FLAG == 'Y' && GridObj.GetCellValue("PURCHASE_BLOCK_NOTE", i) == ''){
					alert("거래상태가 중지인 경우 중지사유를 입력하세요.");
					return;
				}
				
				PURCHASE_BLOCK_NOTE = GridObj.GetCellValue("PURCHASE_BLOCK_NOTE", i);	
				
				sel_row++;
				vendor_code = vendor_code + "," + GD_GetCellValueIndex(GridObj,i,INDEX_VENDOR_CODE);
			}
		}
		if(sel_row == 0)
		{
			alert("항목을 선택해주세요.");
			return;
		}
		
		vendor_code = vendor_code.substring(1);
		var value = confirm(PURCHASE_BLOCK_FLAG_STR + " 하시겠습니까?");
		if(value){
			this.hiddenframe.location.href = "vendor_reg_ins_ict.jsp?mode=block&vendor_code=" + vendor_code + "&purchase_block_flag=" + PURCHASE_BLOCK_FLAG + "&purchase_block_note=" + PURCHASE_BLOCK_NOTE;
		}
	}
  	
  	function setKG(PURCHASE_BLOCK_FLAG){		//경고,경고해제
		var sepoa       =  GridObj;
		var vendor_code = "";
		var sel_row     = 0;

		var PURCHASE_BLOCK_NOTE = "";
		
		/* P:결재진행중 N:거래 Y:중지 */
		var PURCHASE_BLOCK_FLAG_STR = PURCHASE_BLOCK_FLAG == "K" ? "경고" : "경고해제"				
		for(var i=0;i<sepoa.GetRowCount();i++)
		{
			var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);
			
			if(temp == true) {
				if(GridObj.GetCellValue("PURCHASE_BLOCK_FLAG", i) == 'S'){
					alert("탈퇴인 경우는 조작할 수 없습니다.");
					return;
				}
				
				if(PURCHASE_BLOCK_FLAG == 'K' && GridObj.GetCellValue("PURCHASE_BLOCK_FLAG", i) != 'N'){
					alert("거래상태가 정상인 경우에만 경고 하실 수 있습니다.");
					return;
				}
				
				if(PURCHASE_BLOCK_FLAG != 'K' && GridObj.GetCellValue("PURCHASE_BLOCK_FLAG", i) != 'K'){
					alert("거래상태가 경고인 경우에만 경고해제 하실 수 있습니다.");
					return;
				}
				
				if(PURCHASE_BLOCK_FLAG == 'K' && GridObj.GetCellValue("PURCHASE_BLOCK_NOTE", i) == ''){
					alert("거래상태가 경고인 경우 경고사유를 입력하세요.");
					return;
				}
				
				PURCHASE_BLOCK_NOTE = GridObj.GetCellValue("PURCHASE_BLOCK_NOTE", i);	
				
				sel_row++;
				vendor_code = vendor_code + "," + GD_GetCellValueIndex(GridObj,i,INDEX_VENDOR_CODE);
			}
		}
		if(sel_row == 0)
		{
			alert("항목을 선택해주세요.");
			return;
		}
		
		vendor_code = vendor_code.substring(1);
		var value = confirm(PURCHASE_BLOCK_FLAG_STR + " 하시겠습니까?");
		if(value){
			this.hiddenframe.location.href = "vendor_reg_ins_ict.jsp?mode=kg&vendor_code=" + vendor_code + "&purchase_block_flag=" + PURCHASE_BLOCK_FLAG + "&purchase_block_note=" + PURCHASE_BLOCK_NOTE;
		}
	}
  	
  	function setSSCS(){		//거래개시
		var sepoa       =  GridObj;
		var vendor_code = "";
		var sel_row     = 0;

		for(var i=0;i<sepoa.GetRowCount();i++)
		{
			var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);
			
			if(temp == true) {
				if(GridObj.GetCellValue("PURCHASE_BLOCK_FLAG", i) != 'R'){
					alert("탈퇴요청인 경우만 조작할 수 없습니다.");
					return;
				}
								
				sel_row++;
				vendor_code = GD_GetCellValueIndex(GridObj,i,INDEX_VENDOR_CODE);
			}
		}
		if(sel_row == 0)
		{
			alert("항목을 선택해주세요.");
			return;
		}
		
		if(sel_row > 1)
		{
			alert("항목을 한건만 선택해주세요.");
			return;
		}
		
		var value = confirm("탈퇴처리 하시겠습니까?");
		if(value){
			this.hiddenframe.location.href = "vendor_reg_ins_ict.jsp?mode=sscs&vendor_code=" + vendor_code + "&purchase_block_flag=S";
		}
	}

	function doUpload() {
		url = "vendor_reg_upload.jsp";
		popup(url, 1);
	}

	function onRefresh(){
		doc.close();
		setGridDraw();
		setHeader();
	}
	/*
	function add_date_start(year,month,day,week) {
   		document.form1.add_date_start.value=year+month+day;
	}

	function add_date_end(year,month,day,week) {
   		document.form1.add_date_end.value=year+month+day;
	}
	*/
	function doCredit() {
		var checkedCnt = 0;
  		var checkedIndex;
  		var VENDOR_CODE = "";
		for(var i=0; i<GridObj.GetRowCount(); i++){
			if(GridObj.GetCellValue("SELECTED", i) == "1"){
				checkedCnt++;
				checkedIndex = i;
				if(checkedCnt > 1){
					alert("한업체만 선택하실수 있습니다.");
					return;
				}
			}
		}
		if(checkedCnt == 0){
			alert("선택한 업체가 없습니다.");
			return;
		}
		var vendor_code = GridObj.GetCellValue("VENDOR_CODE", checkedIndex);
		
		var left = 0;
		var top = 0;
		var width = 800;
		var height = 300;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/master/register/vendor_reg_lis2_pop.jsp?code=SP0278&function=selectCode&values=<%=info.getSession("HOUSE_CODE")%>&values=M199&values=&values=/&desc=코드&desc=이름&vendor_code="+vendor_code;
		
		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		
		/*
		if(GridObj.GetCellValue("PURCHASE_BLOCK_FLAG", checkedIndex) != 'N'){
			alert("거래상태가 거래인 경우에만 거래중지 하실 수 있습니다.");
			return;
		}
		*/
	}
	
	function doSave() {
		
     	var sepoa = GridObj;
     	
     	var checkedCnt = 0;
  		var checkedIndex;
  		var VENDOR_CODE = "";
		for(var i=0; i<GridObj.GetRowCount(); i++){
			if(GridObj.GetCellValue("SELECTED", i) == "1"){
				checkedCnt++;
				checkedIndex = i;
				if(checkedCnt > 1){
					alert("한업체만 선택하실수 있습니다.");
					return;
				}
			}
		}
		if(checkedCnt == 0){
			alert("선택한 업체가 없습니다.");
			return;
		}
		var vendor_code = GridObj.GetCellValue("VENDOR_CODE", checkedIndex);
		var class_grade = GridObj.GetCellValue("CLASS_GRADE", checkedIndex);
		
		if(!confirm("저장하시겠습니까?")) return;
		
		G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/master.register.vendor_reg_lis2";
		var cols_ids = "<%=grid_col_id%>";
		var params = "mode=setVendorReg";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( G_SERVLETURL, params );
		GridObj.clearAll(false);
		
		/* GridObj.SetParam("mode", "setVendorReg");
		GridObj.SetParam("VENDOR_CODE", vendor_code);
		GridObj.SetParam("CLASS_GRADE", class_grade);
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL"); */
		
	}
	
	function check_rows() {
     	var checkedCnt = 0;
  		var checkedIndex;
		for(var i=0; i<GridObj.GetRowCount(); i++){
			if(GridObj.GetCellValue("SELECTED", i) == "1"){
				checkedCnt++;
				checkedIndex = i;
				if(checkedCnt > 1){
					alert("하나의 업체만 선택하여 주십시오.");
					return false;
				}
			}
		}
		if(checkedCnt == 0){
			alert("선택한 업체가 없습니다.");
			return false;
		}

		document.forms[0].sel_vendor_code.value = GridObj.GetCellValue("VENDOR_CODE", checkedIndex);;
		return true;
	}

	// 삭제
	function doDelete(){
		if (check_rows() == false) return;
		
		var sepoa       =  GridObj;

		for(var i=0;i<sepoa.GetRowCount();i++)
		{
			var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);
			
			if(temp == true) {
				if(GridObj.GetCellValue("PURCHASE_BLOCK_FLAG", i) == 'S'){
					alert("탈퇴인 경우는 조작할 수 없습니다.");
					return;
				}			
			}
		}
		
		if(!confirm("선택한 업체를 삭제 하시겠습니까?")) return;
		
		var vendor_code = document.forms[0].sel_vendor_code.value;

		this.hiddenframe.location.href = "vendor_reg_ins_ict.jsp?mode=delete_approval&vendor_code=" + vendor_code;

	}

	// 복구
	function doRestore(){
		if (check_rows() == false) return;
		
		var sepoa       =  GridObj;

		for(var i=0;i<sepoa.GetRowCount();i++)
		{
			var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);
			
			if(temp == true) {
				if(GridObj.GetCellValue("PURCHASE_BLOCK_FLAG", i) == 'S'){
					alert("탈퇴인 경우는 조작할 수 없습니다.");
					return;
				}			
			}
		}

		if(!confirm("선택한 업체를 복구 하시겠습니까?")) return;
		
		var vendor_code = document.forms[0].sel_vendor_code.value;

		this.hiddenframe.location.href = "vendor_reg_ins_ict.jsp?mode=restore_approval&vendor_code=" + vendor_code;
	}
//-->

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

	if(cellInd == INDEX_NAME_LOC){
		var vendor_code = GridObj.cells(rowId, INDEX_VENDOR_CODE).getValue();	//GD_GetCellValueIndex(GridObj,msg2,INDEX_vendor_code);
		var irs_no = GridObj.cells(rowId, INDEX_IRS_NO).getValue();
		var gb_gj = GridObj.cells(rowId, INDEX_GB_GJ).getValue();
		
		//var url = "/kr/master/vendor/ven_pp_dis1.jsp?vendor_code=" + vendor_code+"&flag=popup";
		if(gb_gj == "J"){
			window.open("/ict/s_kr/admin/info/ven_bd_con_j_ict.jsp?popup=<%=popup%>&mode=irs_no&CompanyCode=<%=company_code%>&vendor_code="+vendor_code+"&irs_no="+irs_no+"&user_type=","ven_bd_con","left=0,top=0,width=950,height=400,resizable=yes,scrollbars=yes");			
		}else{
			window.open("/ict/s_kr/admin/info/ven_bd_con_ict.jsp?popup=<%=popup%>&mode=irs_no&CompanyCode=<%=company_code%>&vendor_code="+vendor_code+"&irs_no="+irs_no+"&user_type=","ven_bd_con","left=0,top=0,width=950,height=700,resizable=yes,scrollbars=yes");				
		}		
	}
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
	var header_name = GridObj.getColumnId(cellInd);
	var max_value = GridObj.cells(rowId, cellInd).getValue();
	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
	if(stage==0) {
			return true;
	} else if(stage==1) {
			if( header_name == "SELECTED" ) {
					var gg = getGridSelectedRows(GridObj, "SELECTED");
					if(gg !=0){
							for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
							{
									GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue(0);
									GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = false;
							}
					}
			
					GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).setValue(1);
					GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
					row_id = rowId;
					return true;
			}
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
    return true;
}

function getVendorCode(setMethod) { popupvendor(setMethod); }
function setVendorCode( code, desc1, desc2 , desc3) {
	document.forms[0].vendor_code.value = code;
	document.forms[0].vendor_name.value = desc1;
}

function popupvendor( fun ){
    window.open("/common/CO_014_ict.jsp?callback=setVendorCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
}

//지우기
function doRemove( type ){
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_name.value = "";
    }
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}

function onlyNumber(keycode){
	/* alert(keycode); */
	if(keycode >= 48 && keycode <= 57){
	}else {
		return false;
	}
	return true;
}
</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->
<%@ include file="/include/sepoa_milestone.jsp" %>

<form name="form1" method="post" action="">
	<!-- 결재관련 파리미터-->
	<input type="hidden" name="sign_flag"     id="sign_flag"     >
	<input type="hidden" name="approval"      id="approval"      >
	<input type="hidden" name="ctrl_code"     id="ctrl_code"     >
	<input type="hidden" name="approval_type" id="approval_type" value="PURCHASE_BLOCK">
	<input type="hidden" name="sg_refitem"    id="sg_refitem"    >
	<input type="hidden" name="level"         id="level"         >
	<input type="hidden" name="sel_vendor_code"   id="sel_vendor_code"   >
	
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
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>    
								<tr>
									<td width="15%" class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;사업자등록번호
									</td>
									<td class="data_td" align="left">
										<input type="text"  onkeydown='entKeyDown()'  size="30" value="" name="irs_no" id="irs_no" class="inputsubmit" style="ime-mode:inactive" onKeyPress="return onlyNumber(event.keyCode);" >
										&nbsp;(숫자만 입력)
									</td>
									<td width="15%" class="title_td">
              							&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
              							&nbsp;&nbsp;공급사/제조사
              						</td>
              						<td width="35%" class="data_td">
              							<select name="s_gb_gj" id="s_gb_gj" class="inputsubmit" onChange="">
											<option value="">전체</option>
											<option value="G">공급사</option>
											<option value="J">제조사</option>												
										</select>
              						</td>            
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>    
								<tr>
									<td width="15%" class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;업체코드
									</td>
									<td width="35%" class="data_td" align="left">
										<input type="text"  onkeydown='entKeyDown()'  name="vendor_code" id="vendor_code" size="15" class="inputsubmit" maxlength="10" readonly>
										<a href="javascript:getVendorCode('setVendorCode')">
											<img src="/images/ico_zoom.gif" width="19" height="19" align="absmiddle" border="0">
										</a>
										<a href="javascript:doRemove('vendor_code')">
											<img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0">
										</a>
										<input type="text"  onkeydown='entKeyDown()'  name="vendor_name" id="vendor_name" size="20" class="input_data2" readonly>
									</td>
									<td class="title_td" width="15%">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;거래상태
									</td>
									<td width="35%" class="data_td" align="left">
										<select name="purchase_block_flag" id="purchase_block_flag" class="inputsubmit" onChange="">
											<option value="">전체</option>
												<%
												String settle = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#"+"M213_ICT", "");
												out.println(settle);
												%>
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
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="30" align="right">
				<table cellpadding="0">
					<tr>
						<td><script language="javascript">btn("javascript:doSelect()","조 회")</script></td>
						<td style="display:none;"><script language="javascript">btn("javascript:doDelete()","삭 제")</script></td>
						<td style="display:none;"><script language="javascript">btn("javascript:doRestore()","복 구")</script></td>
						<td><script language="javascript">btn("javascript:setBlock('Y')","거래중지")</script></td>
						<td><script language="javascript">btn("javascript:setBlock('N')","거래개시")</script></td>						
						<td><script language="javascript">btn("javascript:setKG('K')","경고")</script></td>
						<td><script language="javascript">btn("javascript:setKG('N')","경고햬제")</script></td>						
						<td><script language="javascript">btn("javascript:setSSCS()","탈퇴처리")</script></td>								
					</tr>
				</table>
			</td>
		</tr>
	</table>
																
	<iframe name = "hiddenframe" src=""  width="0" height="0" border="0" frameborder="0"></iframe>
</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="I_SU_103" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>
