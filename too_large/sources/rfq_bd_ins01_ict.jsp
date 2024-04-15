<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
    request.setCharacterEncoding("utf-8");
    String rfq_no	      = JSPUtil.nullToRef(request.getParameter("rfq_no"),"");
	String rfq_count	  = JSPUtil.nullToRef(request.getParameter("rfq_count"),"");
	
	String biz_no         = JSPUtil.nullToRef(request.getParameter("txt_biz_no"),"");
	String biz_nm         = JSPUtil.nullToRef(request.getParameter("txt_biz_nm"),"");
	String rfq_nm         = JSPUtil.nullToRef(request.getParameter("txt_rfq_nm"),"");
	String item_no        = JSPUtil.nullToRef(request.getParameter("sel_item_no"),"1");
	String item_cn        = JSPUtil.nullToRef(request.getParameter("txt_item_cn"),"");	
	String rfq_close_date = JSPUtil.nullToRef(request.getParameter("rfq_close_date"),SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(), 1)));
	String szTime         = JSPUtil.nullToRef(request.getParameter("szTime"),"23");
	String szMin          = JSPUtil.nullToRef(request.getParameter("szMin"),"00");	
	String rfq_id         = JSPUtil.nullToRef(request.getParameter("txt_rfq_id"),info.getSession("ID"));
	String rfq_name       = JSPUtil.nullToRef(request.getParameter("txt_rfq_name"),info.getSession("NAME_LOC"));	
	String rmk_txt        = JSPUtil.nullToRef(request.getParameter("txt_rmk_txt"),"");
	
	
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_RQ_50"+item_no);	
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_RQ_50"+item_no;
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON     = "/images/ico_zoom.gif"; 
	
	String VENDOR_CNT = "0";
	String VENDOR_VALUES = "";
	String VENDOR_INFO = "";
	
    
	String WISEHUB_PROCESS_ID="I_RQ_50"+item_no;
	
	boolean sign_use_yn = false;


%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript" type="text/javascript">
function Init() {	//화면 초기설정 
	setGridDraw();
	setHeader();
}

function  setBIZNO(biz_no, biz_nm) {
    document.forms[0].txt_biz_no.value = biz_no;
    document.forms[0].txt_biz_nm.value = biz_nm;
}

function getBIZ_pop() {
    var url = "/ict/kr/dt/rfq/rfq_bzNo_pop_main.jsp?flag=1";
    Code_Search(url,'사업명','0','0','500','500');
    
    //url, title, left, top, width, height
}

var Arow = 0;

var mode									;
var Current_Row								;
var poprow									;

function setHeader() {
	GridObj.bHDMoving 			= false;
	GridObj.bHDSwapping 		= false;
	GridObj.bRowSelectorVisible = false;
	GridObj.strRowBorderStyle 	= "none";
	GridObj.nRowSpacing 		= 0 ;
	GridObj.strHDClickAction 	= "select";
	GridObj.nHDLineSize  		= 40; 
	
	pre_Insert();
	
	GridObj.strHDClickAction="sortmulti";
}

//삭제 (wisetable상에서 row 감추기)
/*
function doDelete() {
	rowcount = GridObj.GetRowCount();
	
	if(rowcount == 0){
		return;
	}

	rowcount = GridObj.GetRowCount()-1;
	checked_count = 0;
	confirm_flag = true;

	for(row=rowcount; row>=0; row--) {
		if( "true" == GD_GetCellValueIndex(GridObj,row, GridObj.GetColHDIndex("SELECTED"))) {
			checked_count++;

			if(true == confirm_flag) {
				if(confirm("삭제 하시겠습니까?") != 1) {
					return;
				}
				confirm_flag = false;
			}
			
			GridObj.DeleteRow(row);
		}
	}

	if(checked_count == 0)  {
		alert(G_MSS1_SELECT);
		
		return;
	}

	rowcount = GridObj.GetRowCount()-1;
	
	if(rowcount < 1){
		return;
	}

	checked_count = 0;
	confirm_flag = true;
}
*/

function checkData() {
	rowcount = GridObj.GetRowCount();
	checked_count = 0;
	
	return true;
}

//전송(P),저장(N)
function doSave(rfq_status,sign_status) {
	
	form1.rfq_status.value = rfq_status;
	form1.sign_status.value = sign_status;
	
	var rfq_close_date = del_Slash(form1.rfq_close_date.value);
	
	if(rfq_status == "B"){
		if(document.form1.txt_biz_no.value == ""){
			alert("사업명을 선택하세요.");
			return;
		}
		
		if(LRTrim(form1.txt_rfq_nm.value) == "") {
			alert("견적요청명을 입력하셔야 합니다. ");
			form1.txt_rfq_nm.focus();
			return;
		}
	}
	
	if(document.form1.sel_item_no.selectedIndex == 0){
		alert("견적품목을 선택하세요.");
		document.form1.sel_item_no.focus();
		return;
	}
	
	if(LRTrim(form1.txt_item_cn.value) != "" ) {
		if(!IsNumber(form1.txt_item_cn.value)){
			alert("수량은 숫자만 입력 가능합니다.");
			form1.txt_item_cn.select();
			return;
		}
	}
	
	if(LRTrim(rfq_close_date) == "") {
		alert("견적마감일을 입력하셔야 합니다. ");		
		return;
	}
	
	var close_date = parseInt(LRTrim(rfq_close_date)+LRTrim(form1.szTime.value)+LRTrim(form1.szMin.value));
	var today_date_str = "<%= SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4)%>";
	var today_date = parseInt(today_date_str);

	if( close_date <= today_date ){
		alert("견적마감일은 현재 시간 이후 시 등록가능합니다.");
		
		return;
	}

	if(eval(LRTrim(rfq_close_date)) == eval("<%=SepoaDate.getShortDateString()%>")) {
		var TIME = <%=SepoaDate.getShortTimeString().substring(0,4)%>;
		var fHour = LRTrim(form1.szTime.value);
		var fMin = LRTrim(form1.szTime.value);
			
		if (Number(form1.szMin.value) < 10){
			fMin = "0" + fMin.toString();
		}
		
		if(!IsNumber(IsTrimStr(form1.szMin.value)) || IsTrimStr(form1.szMin.value).length != 2) {
			alert("견적마감일이 유효하지 않습니다. ");			
			form1.szMin.select();			
			return;
		}
		
		if(parseInt(form1.szMin.value) > 59) {
			alert("견적마감일이 유효하지 않습니다. ");			
			form1.szMin.select();			
			return;
		}
	}

	if(!IsNumber(IsTrimStr(form1.szMin.value))  || IsTrimStr(form1.szMin.value).length != 2) {
		alert("견적마감일이 유효하지 않습니다. ");		
		form1.szMin.select();		
		return;
	}

	if(parseInt(form1.szMin.value) > 59) {
		alert("견적마감일이 유효하지 않습니다. ");		
		form1.szMin.select();		
		return;
	}
		
	var rfq_close_date = form1.rfq_close_date.value;
	var szTime = form1.szTime.value;
	var szMin = form1.szMin.value;
	var rfq_date = rfq_close_date.replace("/","") + "" + szTime + "" + szMin;
	rfq_date = rfq_date.replace("/","");
		
	
	if(rfq_status == "B"){
		if(form1.seller_cnt.value == "0"){
			alert("견적업체를 선정하세요.");		
			return;
		}
		
		if(GridObj.GetRowCount() == 0){
			alert("견적품목 상세를 행삽입하세요.");
			return;
		}
	}
	
	/*
	if(checkData() == false){
		alert(G_MSS1_SELECT);
		return;
	}
	*/
	
	if(GridObj.GetRowCount() == 0){
		alert(G_MSS1_SELECT);
		return;
	}
	

	checked_count = 0;
	
	if(rfq_status == "B"){
		for(row=GridObj.GetRowCount()-1; row>=0; row--) {
			if( true == GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("SELECTED"))){
				checked_count++;
				
				if("<%=item_no%>" == "1"){
					
					var opDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("OP_DIS"));
					if(opDis == "선택" || opDis == ""){
						alert("운영구분을 선택하세요.");				
						return;
					}
					var eqPm = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("EQPM"));
					if(eqPm == "선택" || eqPm == ""){
						alert("장비급을 선택하세요.");				
						return;
					}
					var cntCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("CNT_CN"));
					if(!IsNumber(IsTrimStr(cntCn)) || IsTrimStr(cntCn).length > 19 || IsTrimStr(cntCn).length == 0) {
						alert("수량이 유효하지 않습니다.");				
						return;
					}
					var os = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("OS"));
					if(os == "선택" || os == ""){
						alert("OS를 선택하세요.");				
						return;
					}
					var mem = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("MEM"));
					if(!IsNumber(IsTrimStr(mem)) || IsTrimStr(mem).length > 19) {
						alert("메모리가 유효하지 않습니다.");				
						return;
					}
					var internalDiskType = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("INTERNALDISK_TYPE"));
					if(internalDiskType == "선택" || internalDiskType == ""){
						alert("Internal Disk타입을 선택하세요.");				
						return;
					}
					var internalDiskCntCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("INTERNALDISK_CNT_CN"));
					if(!IsNumber(IsTrimStr(internalDiskCntCn)) || IsTrimStr(internalDiskCntCn).length > 19) {
						alert("Internal Disk 수량이 유효하지 않습니다.");				
						return;
					}
					
					var nicType = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("NIC_TYPE"));
					if(nicType == "선택" || nicType == ""){
						alert("NIC 타입을 선택하세요.");				
						return;
					}
					var nicPortCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("NIC_PORT_CN"));
					if(nicPortCn == "선택" || nicPortCn == ""){
						alert("NIC 포트수를 선택하세요.");				
						return;
					}
					var nicCdCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("NIC_CD_CN"));
					if(!IsNumber(IsTrimStr(nicCdCn)) || IsTrimStr(nicCdCn).length > 19) {
						alert("NIC 카드수량이 유효하지 않습니다.");				
						return;
					}
					
					var hbaType = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("HBA_TYPE"));
					if(hbaType == "선택" || hbaType == ""){
						alert("HBA 타입을 선택하세요.");				
						return;
					}
					var hbaPortCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("HBA_PORT_CN"));
					if(hbaPortCn == "선택" || hbaPortCn == ""){
						alert("HBA 포트수를 선택하세요.");				
						return;
					}
					var hbaCdCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("HBA_CD_CN"));
					if(!IsNumber(IsTrimStr(hbaCdCn)) || IsTrimStr(hbaCdCn).length > 19) {
						alert("HBA 카드수량이 유효하지 않습니다.");				
						return;
					}
					
					var cluster = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("CLUSTER_DIS"));
					if(cluster == "선택" || cluster == ""){
						alert("Cluster을 선택하세요.");				
						return;
					}
				
				}else if("<%=item_no%>" == "2"){
					var opDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("OP_DIS"));
					if(opDis == "선택" || opDis == ""){
						alert("운영구분을 선택하세요.");				
						return;
					}	
					var eqPm = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("EQPM"));
					if(eqPm == "선택" || eqPm == ""){
						alert("장비급을 선택하세요.");				
						return;
					}
					var cntCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("CNT_CN"));
					if(!IsNumber(IsTrimStr(cntCn)) || IsTrimStr(cntCn).length > 19 || IsTrimStr(cntCn).length == 0) {
						alert("수량이 유효하지 않습니다.");				
						return;
					}					
					var ptMkYn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("PT_MK_YN"));
					if(ptMkYn == "선택" || ptMkYn == ""){
						alert("파티션 구성여부를 선택하세요.");				
						return;
					}
					var internaldiskType = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("INTERNALDISK_TYPE"));
					if(internaldiskType == "선택" || internaldiskType == ""){
						alert("Internal Disk 타입을 선택하세요.");				
						return;
					}
					var internaldiskCntCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("INTERNALDISK_CNT_CN"));
					if(!IsNumber(IsTrimStr(internaldiskCntCn)) || IsTrimStr(internaldiskCntCn).length > 19) {
						alert("Internal Disk 수량이 유효하지 않습니다.");				
						return;
					}
					var nicType = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("NIC_TYPE"));
					if(nicType == "선택" || nicType == ""){
						alert("NIC 타입을 선택하세요.");				
						return;
					}
					var nicPortCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("NIC_PORT_CN"));
					if(nicPortCn == "선택" || nicPortCn == ""){
						alert("NIC 포트수를 선택하세요.");				
						return;
					}
					var nicCdCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("NIC_CD_CN"));
					if(!IsNumber(IsTrimStr(nicCdCn)) || IsTrimStr(nicCdCn).length > 19) {
						alert("NIC 수량이 유효하지 않습니다.");				
						return;
					}					
					var hbaType = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("HBA_TYPE"));
					if(hbaType == "선택" || hbaType == ""){
						alert("HBA 타입을 선택하세요.");				
						return;
					}
					var hbaPortCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("HBA_PORT_CN"));
					if(hbaPortCn == "선택" || hbaPortCn == ""){
						alert("HBA 포트수를 선택하세요.");				
						return;
					}
					var hbaCdCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("HBA_CD_CN"));
					if(!IsNumber(IsTrimStr(hbaCdCn)) || IsTrimStr(hbaCdCn).length > 19) {
						alert("HBA 수량이 유효하지 않습니다.");				
						return;
					}
					var cluster = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("CLUSTER_DIS"));
					if(cluster == "선택" || cluster == ""){
						alert("Cluster를 선택하세요.");				
						return;						
					}					
				}else if("<%=item_no%>" == "3"){
					var opDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("OP_DIS"));
					if(opDis == "선택" || opDis == ""){
						alert("운영구분을 선택하세요.");				
						return;
					}	
					var eqPm = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("EQPM"));
					if(eqPm == "선택" || eqPm == ""){
						alert("장비급을 선택하세요.");				
						return;
					}
					var eqpmDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("EQPM_DIS"));
					if(eqpmDis == "선택" || eqpmDis == ""){
						alert("장비구분을 선택하세요.");				
						return;
					}
					var cntCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("CNT_CN"));
					if(!IsNumber(IsTrimStr(cntCn)) || IsTrimStr(cntCn).length > 19 || IsTrimStr(cntCn).length == 0) {
						alert("수량이 유효하지 않습니다.");				
						return;
					}	
					var diskType = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("DISK_TYPE"));
					if(diskType == "선택" || diskType == ""){
						alert("Disk 타입을 선택하세요.");				
						return;
					}					
					var diskCptCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("DISK_CPT_CN"));
					if(IsTrimStr(diskCptCn).length > 19 || IsTrimStr(diskCptCn).length == 0) {
						alert("Disk 용량이 유효하지 않습니다.");				
						return;
					}									
					var raid = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("RAID"));
					if(raid == "선택" || raid == ""){
						alert("Raid 타입을 선택하세요.");				
						return;
					}					
					var usableCptCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("USABLE_CPT_CN"));
					if(!IsNumber(IsTrimStr(usableCptCn)) || IsTrimStr(usableCptCn).length > 19 || IsTrimStr(usableCptCn).length == 0) {
						alert("Usable용량이 유효하지 않습니다.");				
						return;
					}
					var frontProtType = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("FRONT_PROT_TYPE"));
					if(frontProtType == "선택" || frontProtType == ""){
						alert("Front End 포트Type을 선택하세요.");				
						return;
					}
					var frontProtCntcn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("FRONT_PROT_CNT_CN"));
					if(!IsNumber(IsTrimStr(frontProtCntcn)) || IsTrimStr(frontProtCntcn).length > 19) {
						alert("Front End 포트수가 유효하지 않습니다.");				
						return;
					}
				}else if("<%=item_no%>" == "4"){
					var opDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("OP_DIS"));
					if(opDis == "선택" || opDis == ""){
						alert("운영구분을 선택하세요.");				
						return;
					}						
					var prdDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("PRD_DIS"));
					if(prdDis == "선택" || prdDis == ""){
						alert("제품구분을 선택하세요.");				
						return;
					}
					var editionDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("EDITION_DIS"));
					if(editionDis == "선택" || editionDis == ""){
						alert("Edition구분을 선택하세요.");				
						return;
					}
					var eqpmDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("EQPM_DIS"));
					if(eqpmDis == "선택" || eqpmDis == ""){
						alert("장비구분을 선택하세요.");				
						return;
					}					
					var cntCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("CNT_CN"));
					if(!IsNumber(IsTrimStr(cntCn)) || IsTrimStr(cntCn).length > 19 || IsTrimStr(cntCn).length == 0) {
						alert("수량이 유효하지 않습니다.");				
						return;
					}	
					
				}else if("<%=item_no%>" == "5"){
					var opDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("OP_DIS"));
					if(opDis == "선택" || opDis == ""){
						alert("운영구분을 선택하세요.");				
						return;
					}						
					var editionDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("EDITION_DIS"));
					if(editionDis == "선택" || editionDis == ""){
						alert("Edition구분을 선택하세요.");				
						return;
					}
					var eqpmDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("EQPM_DIS"));
					if(eqpmDis == "선택" || eqpmDis == ""){
						alert("장비구분을 선택하세요.");				
						return;
					}					
					var cntCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("CNT_CN"));
					if(!IsNumber(IsTrimStr(cntCn)) || IsTrimStr(cntCn).length > 19 || IsTrimStr(cntCn).length == 0) {
						alert("수량이 유효하지 않습니다.");				
						return;
					}	
					
				}else if("<%=item_no%>" == "6"){
					var opDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("OP_DIS"));
					if(opDis == "선택" || opDis == ""){
						alert("운영구분을 선택하세요.");				
						return;
					}						
					var eqpmDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("EQPM_DIS"));
					if(eqpmDis == "선택" || eqpmDis == ""){
						alert("장비구분을 선택하세요.");				
						return;
					}					
					var cntCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("CNT_CN"));
					if(!IsNumber(IsTrimStr(cntCn)) || IsTrimStr(cntCn).length > 19 || IsTrimStr(cntCn).length == 0) {
						alert("수량이 유효하지 않습니다.");				
						return;
					}						
				}else if("<%=item_no%>" == "7"){
					var opDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("OP_DIS"));
					if(opDis == "선택" || opDis == ""){
						alert("운영구분을 선택하세요.");				
						return;
					}						
					var eqpmDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("EQPM_DIS"));
					if(eqpmDis == "선택" || eqpmDis == ""){
						alert("장비구분을 선택하세요.");				
						return;
					}					
					var cntCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("CNT_CN"));
					if(!IsNumber(IsTrimStr(cntCn)) || IsTrimStr(cntCn).length > 19 || IsTrimStr(cntCn).length == 0) {
						alert("수량이 유효하지 않습니다.");				
						return;
					}						
				}else if("<%=item_no%>" == "8"){
					var opDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("OP_DIS"));
					if(opDis == "선택" || opDis == ""){
						alert("운영구분을 선택하세요.");				
						return;
					}						
					var eqpmDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("EQPM_DIS"));
					if(eqpmDis == "선택" || eqpmDis == ""){
						alert("장비구분을 선택하세요.");				
						return;
					}					
					var cntCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("CNT_CN"));
					if(!IsNumber(IsTrimStr(cntCn)) || IsTrimStr(cntCn).length > 19 || IsTrimStr(cntCn).length == 0) {
						alert("수량이 유효하지 않습니다.");				
						return;
					}						
				}else if("<%=item_no%>" == "9"){
					var opDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("OP_DIS"));
					if(opDis == "선택" || opDis == ""){
						alert("운영구분을 선택하세요.");				
						return;
					}						
					var osDis = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("OS_DIS"));
					if(osDis == "선택" || osDis == ""){
						alert("OS구분을 선택하세요.");				
						return;
					}					
					var cntCn = GD_GetCellValueIndex(GridObj,row, GridObj.getColIndexById("CNT_CN"));
					if(!IsNumber(IsTrimStr(cntCn)) || IsTrimStr(cntCn).length > 19 || IsTrimStr(cntCn).length == 0) {
						alert("수량이 유효하지 않습니다.");				
						return;
					}						
				}
				
			}
		}
	}

	/*
	if(checked_count == 0)  {
		alert(G_MSS1_SELECT);	
		return;
	}
	*/
	
	Approval(rfq_status,sign_status);
}


function Approval(rfq_status,sign_status) { // 결재요청='P'
	if (checkData() == false){
		return;
	}
	
	if (sign_status == "P") {
		document.forms[0].target = "childframe";
		document.forms[0].action = "/kr/admin/basic/approval/approval.jsp";
		document.forms[0].method = "POST";
		document.forms[0].submit();
	}
	else {
		getApproval(rfq_status);
		
		return;
	}
}

function getApproval(approval_str) {
	if (approval_str == "") {
		alert("결재자를 지정해 주세요");
		
		return;
	}
	
	var rfq_status = form1.rfq_status.value;
	var Message = "";
	
	if(rfq_status == "T"){
		Message = "임시저장 하시겠습니까?";
	}
	else if(rfq_status == "P"){
		Message = "결재요청 하시겠습니까?";
	}
	else if(rfq_status == "B"){
		Message = "업체에 견적요청 하시겠습니까?";
	}
		
	if(confirm(Message) != 1) {
		return;
	}
	
	form1.approval_str.value = approval_str;
	//document.attachFrame.setData();	//startUpload
	getApprovalSend(approval_str);
}

function fnFormInputSet(inputName, inputValue) {
	var input = document.createElement("input");
	
	input.type  = "hidden";
	input.name  = inputName;
	input.id    = inputName;
	input.value = inputValue;
	
	return input;
}

/**
 * 동적 form을 생성하여 반환하는 메소드
 *
 * @param url
 * @param param
 * @param target
 * @return form
 */
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
		var input = fnFormInputSet(paramInfoArray[0], paramInfoArray[1]);

		form.appendChild(input);
	}
	
	form.action = url;
	form.target = target;
	form.method = "post";

	return form;
}

function getApprovalSend(approval_str){
	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.dt.rfq.rfq_bd_ins1";
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var params     = getApprovalSendParam(approval_str);
	
	myDataProcessor = new dataProcessor(servletUrl, params);
	sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
}

function getApprovalSendParam(approvalStr){
	var inputParam = "I_RFQ_STATUS=" + document.getElementById("rfq_status").value;
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = "<%=grid_col_id%>";
	var params;

	inputParam = inputParam + "&I_PFLAG=" + approvalStr;
	inputParam = inputParam + "&I_BIZ_NO=" + document.getElementById("txt_biz_no").value;
	inputParam = inputParam + "&I_RFQ_NM=" + document.getElementById("txt_rfq_nm").value;
	inputParam = inputParam + "&I_RFQ_NO=" + document.getElementById("txt_rfq_no").value;
	inputParam = inputParam + "&I_RFQ_COUNT=" + document.getElementById("txt_rfq_count").value;
	inputParam = inputParam + "&I_ITEM_NO=" + document.getElementById("sel_item_no").value;
	inputParam = inputParam + "&I_ITEM_CN=" + document.getElementById("txt_item_cn").value;
	inputParam = inputParam + "&I_RFQ_CLOSE_DATE=" + document.getElementById("rfq_close_date").value;
	inputParam = inputParam + "&I_RFQ_CLOSE_TIME=" + document.getElementById("szTime").value + document.getElementById("szMin").value;	
	inputParam = inputParam + "&I_RFQ_ID=" + document.getElementById("txt_rfq_id").value;
	inputParam = inputParam + "&I_RFQ_NAME=" + document.getElementById("txt_rfq_name").value;
	inputParam = inputParam + "&I_RMK_TXT=" + document.getElementById("txt_rmk_txt").value;
	inputParam = inputParam + "&I_ATTACH_NO=" + document.getElementById("attach_no").value;
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=setRfqCreate";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	params += inputParam;
	
	body.removeChild(form);
	
	return params;
}


function pre_Insert() {
	document.form1.attach_count.value = '';
}

function POPUP_Open(url, title, left, top, width, height) {
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'no';
	var scrollbars = 'yes';
	var resizable = 'no';
	var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	code_search.focus();
}

//업체선택 (화면맨아래)
function vendor_Select() {
	
	document.form1.vendor_each_flag.value = "0";
	
	load_type = 0;
	var cnt = 0;
	
	//if(!checkRows()) return;
	
	//var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var strVendor_Codes  = "";
	var strVendor_Info   = "";
	var SOURCING_GROUP   = "";
	var DESCRIPTION_LOC  = "";
	var selller_selected = "";
	

	cnt = document.form1.vendor_count.value;
	strVendor_Codes = document.form1.vendor_values.value;
	strVendor_Info = document.form1.vendor_info.value;
	
	if(cnt == 0) {
		getVenderList("-1", "E", strVendor_Codes,strVendor_Info);
	} else if(cnt > 0) {
		getVenderList("-1", "A", strVendor_Codes,strVendor_Info);
	}
}

function getVenderList(szRow, mode,strVendor_Codes,strVendor_Info) {

	var shipper_type = 'D';
	var param        = "&mode=" + encodeUrl(mode) + "&szRow=" + encodeUrl(szRow);//+"&selller_selected="+selller_selected;
	
	if(document.form1.vendor_each_flag.value != "1"){ //버튼클릭하여 업체지정시
		param += "&type=button";
	}
	param +=  "&shipper_type="+encodeUrl(shipper_type)+"&MATERIAL_NUMBER="+strVendor_Info;
	popUpOpen("/ict/sourcing/rfq_req_sellerselframe_ict.jsp?popup_flag=true"+param, 'RFQ_REQ_SELLERSELFRAME', '880', '660');
}

<%--업체선택후 호출되는 Function--%>
function setVendorList(szRow, VANDOR_INFO, VANDOR_SELECTED, SELECTED_COUNT) {
	
	document.form1.seller_cnt.value = SELECTED_COUNT;
	document.form1.vendor_count.value = SELECTED_COUNT;
	document.form1.seller_choice.value="1";
	document.form1.vendor_values.value=VANDOR_SELECTED;
	document.form1.vendor_info.value=VANDOR_INFO;	
}

function sel_item_no_Changed(){
	
	document.form1.action = "/ict/kr/dt/rfq/rfq_bd_ins01_ict.jsp";
	document.form1.method = "POST";
	document.form1.target = "_self";
	document.form1.submit();
	
}

function PopupManager(part)
{
	if(part == "rfq_id"){
		//window.open("/common/CO_008_ict.jsp?callback=getConUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");		
		var url    = '/common/CO_008_ict.jsp';
		var title  = '담당자';
		var param  = 'callback=getConUser';
		popUpOpen01(url, title, '450', '550', param);			
	}
	
}

//지우기
function doRemove( type ){
	if( type == "rfq_id" ) {
		document.form1.txt_rfq_id.value = "";
		document.form1.txt_rfq_name.value = "";
	}else if( type == "biz_no" ) {
    	document.forms[0].txt_biz_no.value = "";
        document.forms[0].txt_biz_nm.value = "";
    }    
}

function getConUser(code, text){
	document.form1.txt_rfq_id.value = code;
	document.form1.txt_rfq_name.value = text;
}

//행추가 이벤트 입니다.
function doAddRow()
{
	/*
	if(document.form1.txt_biz_no.value == ""){
		alert("사업명을 선택하세요.");
		return;
	}
	*/
	
	if(document.form1.sel_item_no.selectedIndex == 0){
		alert("견적품목을 선택하세요.");
		document.form1.sel_item_no.focus();
		return;
	}
	
	dhtmlx_last_row_id++;
	var nMaxRow2 = dhtmlx_last_row_id;
	var row_data = "<%=grid_col_id%>";
	
	GridObj.enableSmartRendering(true);
	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
	GridObj.selectRowById(nMaxRow2, false, true);
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CRUD")).setValue("C");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("RFQ_NO")).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("RFQ_COUNT")).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("BIZ_NO")).setValue(document.form1.txt_biz_no.value);
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("BIZ_NM")).setValue(document.form1.txt_biz_nm.value);
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("ITEM_NO")).setValue(document.form1.sel_item_no.value);
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("ITEM_NM")).setValue(document.form1.sel_item_no.options[document.form1.sel_item_no.selectedIndex].text);
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("OP_DIS")).setValue("선택");
	
	<% if("1".equals(item_no)){ %>
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("EQPM")).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("USG")).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CNT_CN")).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("OS")).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CPU")).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("MEM")).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("INTERNALDISK_TYPE")).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("INTERNALDISK_CPT_CN")).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("INTERNALDISK_CNT_CN")).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("NIC_TYPE")).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("NIC_PORT_CN")).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("NIC_CD_CN")).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("HBA_TYPE")).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("HBA_PORT_CN")).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("HBA_CD_CN")).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CLUSTER_DIS")).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("ETC")).setValue("");
	<% }else if("2".equals(item_no)){ %>
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("EQPM"               )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("USG"                )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CNT_CN"             )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("PT_MK_YN"           )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("PT_CN"              )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CPU"                )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("MEM"                )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("INTERNALDISK_TYPE"  )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("INTERNALDISK_CPT_CN")).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("INTERNALDISK_CNT_CN")).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("NIC_TYPE"           )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("NIC_PORT_CN"        )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("NIC_CD_CN"          )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("HBA_TYPE"           )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("HBA_PORT_CN"        )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("HBA_CD_CN"          )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CLUSTER_DIS"            )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("ETC"                )).setValue("");
	<% }else if("3".equals(item_no)){ %>
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("EQPM"                 )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("EQPM_DIS"             )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("USG"                  )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CNT_CN"               )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CACHE_MEM"            )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("DISK_TYPE"            )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("DISK_CPT_CN"          )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("USABLE_CPT_CN"        )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("RAID"                 )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("FRONT_PROT_TYPE"      )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("FRONT_PROT_CNT_CN"    )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("ETC"                  )).setValue("");
	<% }else if("4".equals(item_no)){ %>
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("USG"                  )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("PRD_DIS"              )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("EDITION_DIS"          )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("EQPM_DIS"             )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SA_YANG"              )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CNT_CN"               )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("ETC"                  )).setValue("");
	<% }else if("5".equals(item_no)){ %>
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("USG"                  )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("EDITION_DIS"          )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("EQPM_DIS"             )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SA_YANG"              )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CNT_CN"               )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("ETC"                  )).setValue("");
	<% }else if("6".equals(item_no)){ %>
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("USG"                  )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("EQPM_DIS"             )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SA_YANG"              )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CNT_CN"               )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("ETC"                  )).setValue("");
	<% }else if("7".equals(item_no)){ %>
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("USG"                  )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("EQPM_DIS"             )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SA_YANG"              )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CNT_CN"               )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("ETC"                  )).setValue("");
	<% }else if("8".equals(item_no)){ %>
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("USG"                  )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("EQPM_DIS"             )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SA_YANG"              )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CNT_CN"               )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("ETC"                  )).setValue("");
	<% }else if("9".equals(item_no)){ %>
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("USG"                  )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("OS_DIS"               )).setValue("선택");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SA_YANG"              )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CNT_CN"               )).setValue("");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("ETC"                  )).setValue("");
	<% } %>
	
	dhtmlx_before_row_id = nMaxRow2;
}



//행삭제시 호출 되는 함수 입니다.
function doDeleteRow()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var rowcount = grid_array.length;
	GridObj.enableSmartRendering(false);

	for(var row = rowcount - 1; row >= 0; row--)
	{		
		if("1" == GridObj.cells(grid_array[row], 0).getValue() && "C" == GridObj.cells(grid_array[row], GridObj.getColIndexById("CRUD")).getValue())
		{
			GridObj.deleteRow(grid_array[row]);
    	}
    }
}

function openPopup(szRow, mode,SG_REFITEM) {
	var url = "rfq_pp_ins2.jsp?mode=" + mode + "&szRow=" + szRow + "&SG_REFITEM="+SG_REFITEM;
	window.open(url, "rfq_pp_ins2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=580,left=0,top=0");
}

function rfq_close_date(year,month,day,week) {
	document.form1.rfq_close_date.value=year+month+day;
}

function checkMin(sFilter) {
	var sKey = String.fromCharCode(event.keyCode);
	var re = new RegExp(sFilter);

	// Enter는 키검사를 하지 않는다.
	if(sKey != "\r" && !re.test(sKey)) {
		event.returnValue = false;
	}

	if (form1.szMin.value.length == 0) {
		if (parseInt(sKey) > 5){
			event.returnValue = false;
		}
	}
}

function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	if(msg1 == "doQuery"){
		
		//전체 선택
		selectAll();
		
	}
	
	if(msg1 == "t_imagetext") {
	}
	else if(msg1 == "doData") { // 전송/저장시 Row삭제
		//opener.doSelect();
		//window.close();
		//location.href = "/ict/kr/dt/rfq/rfq_bd_lis01_ict.jsp";
		topMenuClick("/ict/kr/dt/rfq/rfq_bd_lis01_ict.jsp", "MUO18062700001" , 4, '');
				
	}
	else if(msg1 == "t_insert") { //
		if(msg3 == INDEX_RD_DATE) {
			se_rd_date  = GD_GetCellValueIndex(GridObj,msg2, INDEX_RD_DATE);
			var  rfq_close_date_val = form1.rfq_close_date.value;			
			if(rfq_close_date_val == "") {
				alert("견적마감일을 먼저 입력하세요");				
				return;
			}
			
			if(!checkDateCommon(form1.rfq_close_date.value)){
				document.forms[0].rfq_close_date.select();				
				alert("견적마감일을 확인하세요.");				
				return;
			}
		}
	}
	else if(msg1 == "t_header") {
		if(msg3 == INDEX_RD_DATE) {
			copyCell(GridObj, INDEX_RD_DATE, "t_date");
		}
	}
}

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	<% if("1".equals(item_no)){ %>
	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,Disk 타입,용량,수량,Type,포트수,카드수량,Type,포트수,카드수량,#rspan,#rspan");
	<% }else if("2".equals(item_no)){ %>
	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,구성여부,파티션갯수,#rspan,#rspan,Disk타입,용량,수량,Type,포트수,카드수량,Type,포트수,카드수량,#rspan,#rspan");
	<% }else if("3".equals(item_no)){ %>
	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,타입,용량,#rspan,#rspan,포트Type,포트수,#rspan");
	<% } %>
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
   
}

function changeMoney(mon)
{
	var money = del_comma(mon);

	if(money == 0){
		alert("값을 입력하세요");
		return false;
	}
	if(isNaN(Number(del_comma(mon)))){
		alert("숫자로 입력하세요");
		
		return false;
	}
	if(money.length>13){
		alert("가용한 금액의 크기를 넘었습니다.");		
		return false;
	}
	if(money.indexOf(".")>=0){
		alert("정수로 입력하십시오");
		return false;
	}
	if(money.indexOf("-")>=0){
		alert("양수로 입력하십시오");
		return false;
	}
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
function doOnCellChange(stage,rowId,cellInd){
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

/* 파일 업로드 */
/* function goAttach(attach_no){
	attach_file(attach_no,"RFQ");
} */
/* function setAttach(attach_key, arrAttrach, attach_count) {
	document.form1.attach_no.value = attach_key;
	document.form1.attach_no_count.value = attach_count;
}
 */
/* 
function setAttach(attach_key, arrAttrach, attach_count) {

	if(document.form1.attach_gubun.value == "wise"){
		//alert(Arow+"|"+attach_key+"|"+attach_count);
		GridObj.cells(Arow, INDEX_ATTACH_NO).setValue(attach_key);
		GridObj.cells(Arow, INDEX_ATTACH_NO_CNT).setValue(attach_count);
		
//		GD_SetCellValueIndex(document.WiseGrid,Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");
		//GD_SetCellValueIndex(GridObj, Arow, INDEX_ATTACH_NO, attach_key);
		//GD_SetCellValueIndex(GridObj, Arow, INDEX_ATTACH_NO_CNT, attach_count);
		
	} else {
		var f = document.forms[0];
	    f.attach_no.value    = attach_key;
	    f.attach_count.value = attach_count;
	}
	document.form1.attach_gubun.value="body";

} */
 
 var selectAllFlag = 0;
	<%
	/**
	 * @메소드명 : selectAll()
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 전체선택 > 전체선택되어 있는 경우 클릭하면 전체선택 해제
	 */
	%>
 function selectAll(){
		if(selectAllFlag == 0)
		{
			for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
			{
				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("1"); 
			}
			selectAllFlag = 1;
		}
		else
		{
			for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
			{
				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("0");
			}
		}
	}
 	function setApprovalButton(attach_count){
 		try{
			if(attach_count>0){
				document.getElementById("approvalButton1").style.display = "";
				document.getElementById("approvalButton2").style.display = "none";
			}else{
				document.getElementById("approvalButton1").style.display = "none";     
				document.getElementById("approvalButton2").style.display = "";
			}
 		}catch(e){
 			
 		}
 	}
</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">
<s:header>
	<form name="form1" id="form1" action="">
		<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 시작--%>
		<input type="hidden" name="dept_code" id="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
		<input type="hidden" name="req_user_id" id="req_user_id" value="<%=info.getSession("ID")%>">
		<input type="hidden" name="doc_type" id="doc_type" value="RQ">
		<input type="hidden" name="fnc_name" id="fnc_name" value="getApproval">
		<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 종료--%>
		
		<input type="hidden" id="vendor_count" name="vendor_count" value="<%=VENDOR_CNT%>">
		<input type="hidden" name="vendor_values"   id="vendor_values"  value="<%=VENDOR_VALUES%>"> 
	    <input type="hidden" name="vendor_info"     id="vendor_info"    value="<%=VENDOR_INFO%>">
		<input type="hidden" id="vendor_each_flag" 	name="vendor_each_flag">
		<input type="hidden" name="seller_change_flag" 	id="seller_change_flag" value= "Y"><!-- 업체선택여부 -->
		<input type="hidden" id="seller_cnt" 		name="seller_cnt" value="<%=VENDOR_CNT%>">
		<input type="hidden" id="seller_choice" 	name="seller_choice">
		
		
		<input type="hidden" name="rfq_no" id="rfq_no" value="<%=rfq_no%>">
		<input type="hidden" name="rfq_count" id="rfq_count" value="<%=rfq_count%>">
		<input type="hidden" name="szdate" id="szdate">
		<input type="hidden" name="dely_text" id="dely_text">
		<input type="hidden" name="attach_gubun" id="attach_gubun" value="body">
		<input type="hidden" name="rfq_status" id="rfq_status" value="">		
		<input type="hidden" name="sign_status" id="sign_status" value="">
		
		<input type="hidden" name="att_mode" id="att_mode"  value="">
		<input type="hidden" name="view_type" id="view_type"  value="">
		<input type="hidden" name="file_type" id="file_type"  value="">
		<input type="hidden" name="tmp_att_no" id="tmp_att_no" value="">
		<input type="hidden" name="attach_count" id="attach_count" value="">
		<input type="hidden" name="approval_str" id="approval_str" value="">
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
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업명<font style="color: red;">*</font></td>
				<td width="35%" class="data_td">
					<input type="text" name="txt_biz_nm" id="txt_biz_nm" value="<%=biz_nm%>" size="20" readOnly>
					<a href="javascript:getBIZ_pop();">
						<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
					</a>
					<a href="javascript:doRemove('biz_no')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>	
					<input type="text" name="txt_biz_no" id="txt_biz_no" value="<%=biz_no%>" size="20" readOnly>					
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청명<font style="color: red;">*</font></td>
				<td width="35%" class="data_td">
					<input type="text" name="txt_rfq_nm" id="txt_rfq_nm" style="width:95%;" value="<%=rfq_nm%>" onKeyUp="return chkMaxByte(500, this, '견적요청명');">
				</td>
			</tr>
			<tr style="display:none;">
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청번호</td>
				<td width="35%"  class="data_td">
					<input type="text" name="txt_rfq_no" id="txt_rfq_no" value="<%=rfq_no%>" style="width:95%" class="input_data2" readonly>
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;차수</td>
				<td width="35%"  class="data_td"><input type="text" name="txt_rfq_count" id="txt_rfq_count" value="<%=rfq_count%>" size="10" class="input_data2" readonly>
				</td>
			</tr>			
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>	
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적품목<font style="color: red;">*</font></td>
				<td class="data_td">
					<select name="sel_item_no" id="sel_item_no" class="inputsubmit" onChange="javacsript:sel_item_no_Changed();">
									<option value="">선택</option>
<%
	String  lb_item_no = ListBox(request, "SL0019",info.getSession("HOUSE_CODE") + "#" + "M680_ICT" + "#" + "0", item_no);
	out.println(lb_item_no);
%>
					</select>
				</td>				
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;수량<font style="color: red;">*</font></td>
				<td class="data_td">
					<input type="text" name="txt_item_cn" id="txt_item_cn" value="<%=item_cn%>" style="width:70px" onKeyUp="return chkMaxByte(19, this, '수량');">
				</td>	
			</tr>											
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>	
			<tr>				
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적마감일<font style="color: red;">*</font></td>
				<td width="35%" class="data_td">
					<s:calendar id="rfq_close_date" default_value="<%=rfq_close_date%>" format="%Y/%m/%d"/>
					<select name="szTime" id="szTime" class="inputsubmit">
						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option>
						<option value="06">06</option>
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
						<option value="13">13</option>
						<option value="14">14</option>
						<option value="15">15</option>
						<option value="16">16</option>
						<option value="17">17</option>
						<option value="18">18</option>
						<option value="19">19</option>
						<option value="20">20</option>
						<option value="21">21</option>
						<option value="22">22</option>
						<option value="23" selected>23</option>
					</select>
					시
					<input type="text" name="szMin" id="szMin" size="2" maxLength="2" value="<%=szMin%>" style="ime-mode:disabled" onKeyPress="checkMin('[0-9]')">
					분
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적담당자<font style="color: red;">*</font></td>
				<td width="85%" class="data_td" colspan=3>
					<input type="text" name="txt_rfq_id" id="txt_rfq_id" size="16" maxlength="10"  value='<%=rfq_id
					%>'  readOnly>
					<a href="javascript:PopupManager('rfq_id');">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/query.gif" align="absmiddle" border="0" alt="">
					</a>
					<a href="javascript:doRemove('rfq_id')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/ico_x2.gif" align="absmiddle" border="0">
					</a>
					<input type="text" name="txt_rfq_name" id="txt_rfq_name" size="25" onkeydown='entKeyDown()' readonly value='<%=rfq_name%>' readOnly>
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;비고</td>
				<td class="data_td" colspan="3" height="150px">
					<table width="98%" >
						<tr>
							<td>
								<textarea name="txt_rmk_txt" id="txt_rmk_txt" class="inputsubmit" style="width: 98%; height: 140px" rows="5" onKeyUp="return chkMaxByte(4000, this, '비고');"><%=rmk_txt%></textarea>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr style="display:none">
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr style="display:none">
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
				<td class="data_td" colspan="3">
					<table><tr></tr><td>
					<script language="javascript">
					function setAttach(attach_key, arrAttrach, rowId, attach_count) {
						setApprovalButton(attach_count);
						document.getElementById("attach_no").value            = attach_key;
						document.getElementById("attach_no_count").value      = attach_count;
					}
						btn("javascript:attach_file(document.getElementById('attach_no').value, 'TEMP');", "파일등록");
					</script>
					</td><td>
					<input type="text" size="3" readOnly class="input_empty" value="0" name="attach_no_count" id="attach_no_count"/>
					<input type="hidden" value="" name="attach_no" id="attach_no">
					</td></table>
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>
</td>
</tr>
</table>
		
		
		
	</form>
	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		<tr>		 
			<td height="30" align="right">
				<TABLE cellpadding="0">
					<TR>				
						<TD>
							<script language="javascript">
								btn("javascript:vendor_Select()", "견적업체");
							</script>
						</TD>
						<TD>
							<script language="javascript">
								btn("javascript:doSave('T','')", "임시저장");
							</script>
						</TD>
<%
	if (sign_use_yn) {
%>
						<TD id="approvalButton1" style="display: none;">
							<script language="javascript">
								btn("javascript:doSave('','P')", "결재요청");
							</script>
						</TD>
						
						<TD id="approvalButton2">
							<script language="javascript">
								btn("javascript:doSave('B','E')", "견적요청 (업체전송)");
							</script>
						</TD>
<%
	}
	else{
%>
						<TD>
							<script language="javascript">
								btn("javascript:doSave('B','')", "견적요청 (업체전송)");
							</script>
						</TD>
<%
	}
%>
						<td>
							<script language="javascript">
								btn("javascript:doAddRow()","행삽입")
							</script>
						</td>
						<TD>
							<script language="javascript">
								btn("javascript:doDeleteRow()", "행삭제");
							</script>
						</TD>
						<TD>
							<script language="javascript">
								btn("javascript:window.close()", "닫 기");
							</script>
						</TD>
					</TR>
				</TABLE>
			</td>
		</tr>
	</table>
	<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>

<s:footer/>
</body>
</html>