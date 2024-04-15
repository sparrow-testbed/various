<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AU_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AU_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON     = "";

%>
<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/kr/dt/rfq/rat_bd_lis1.jsp -->
<!--
Title:         역경매등록현황  <p>
 Description:  역경매등록현황<p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       JUN.S.K<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!-->

<% //PROCESS ID 선언 %>
<% String WISEHUB_PROCESS_ID="AU_001";%>

<% //사용 언어 설정  %>
<% String WISEHUB_LANG_TYPE="KR";%>
<%-- <%@ include file="/include/wisehub_common.jsp"%> --%>
<%-- <%@ include file="/include/wisehub_session.jsp" %> --%>
<%-- <%@ include file="/include/wisehub_auth.jsp" %> --%>
<%-- <%@ include file="/include/wisetable_scripts.jsp"%> --%>




<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<%
    String house_code       = info.getSession("HOUSE_CODE");
	String user_id		    = info.getSession("ID");
	String ctrl_code	    = info.getSession("CTRL_CODE");
	String USER_NAME 	= info.getSession("NAME_LOC");
%>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->

<%-- <%@ include file="/include/wisehub_scripts.jsp"%> --%>

<script language="javascript">
<!--
    var mode;

    var server_time;
    var diff_time;

    var INDEX_SELECTED;
    var INDEX_ANN_NO;
    var INDEX_STATUS_TEXT;
    var INDEX_SUBJECT;
    var INDEX_ATTACH_NO;
    var INDEX_END_DATETIME;
    var INDEX_BID_COUNT;
    //var INDEX_CURRENT_PRICE;
    var INDEX_RESERVE_PRICE;
    var INDEX_PR_NO;
    var INDEX_RA_NO;
    var INDEX_RA_COUNT;
    var INDEX_CTRL_CODE;
    var INDEX_STATUS;
    var INDEX_CHANGE_USER_ID;
	var INDEX_RA_FLAG;
	var INDEX_SIGN_STATUS;
	var INDEX_CUST_CODE;
	var INDEX_WBS_NO;
	var INDEX_WBS_TXT;
	var INDEX_DEMAND_DEPT;
	var INDEX_ADD_USER_ID;
	var INDEX_TEL_NO;
	

    function init() {
//     	$.post(
<%--    			"<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_lis1", --%>
//    	 		{ mode : "getServerTime"},
//    	 		function(arg){
   	 			
//    	 			var yy = eval(arg.substring(0, 4));
//    	 			var mm = eval(arg.substring(4, 6));
//    	 			var dd = eval(arg.substring(6, 8));
//    	 			var hh = eval(arg.substring(8, 10));
//    	 			var mi = eval(arg.substring(10, 12));
//    	 			var ss = eval(arg.substring(12, 14));
   	 			
//    	 			var tmp = new Date(yy, mm, dd, hh, mi, ss);
//    	 			server_time = tmp.getTime();
//    	 		}
//    	 	);	    	    	
    	
		setGridDraw();
		setHeader();
        doSelect();
        printDate();
    }

    function setHeader() {
    	//hidden Value
    	GridObj.strHDClickAction="sortmulti";
// 		GridObj.SetColCellSortEnable(	     "STATUS_TEXT"   ,false);
// 		GridObj.SetColCellSortEnable(    "SUBJECT"       ,false);
// 		GridObj.SetColCellSortEnable(	     "END_DATETIME"  ,false);
// 		GridObj.SetColCellSortEnable(    "BID_COUNT"     ,false);
// 		GridObj.SetNumberFormat(	     "RESERVE_PRICE" ,G_format_unit);
// 		GridObj.SetColCellSortEnable(	     "RESERVE_PRICE" ,false);
		
// 		GridObj.SetColCellSortEnable(      "RA_NO"         ,false);
// 		GridObj.SetColCellSortEnable(		 "RA_COUNT"      ,false);
// 		GridObj.SetColCellSortEnable(	 "CTRL_CODE"     ,false);
// 		GridObj.SetColCellSortEnable(	     "STATUS"        ,false);
// 		GridObj.SetColCellSortEnable(	     "RA_FLAG"        ,false);
// 		GridObj.SetColCellSortEnable("CHANGE_USER_ID",false);
// 		GridObj.SetColCellSortEnable("SIGN_STATUS",false);

        INDEX_SELECTED          = GridObj.GetColHDIndex("SELECTED");
        INDEX_ANN_NO            = GridObj.GetColHDIndex("ANN_NO");
        INDEX_STATUS_TEXT       = GridObj.GetColHDIndex("STATUS_TEXT");
        INDEX_SUBJECT           = GridObj.GetColHDIndex("SUBJECT");
        INDEX_ATTACH_NO         = GridObj.GetColHDIndex("ATTACH_NO");
        INDEX_END_DATETIME      = GridObj.GetColHDIndex("END_DATETIME");
        INDEX_BID_COUNT         = GridObj.GetColHDIndex("BID_COUNT");
        INDEX_RESERVE_PRICE     = GridObj.GetColHDIndex("RESERVE_PRICE");
        INDEX_PR_NO             = GridObj.GetColHDIndex("PR_NO");
        INDEX_RA_NO             = GridObj.GetColHDIndex("RA_NO");
        INDEX_RA_COUNT          = GridObj.GetColHDIndex("RA_COUNT");
        INDEX_CTRL_CODE         = GridObj.GetColHDIndex("CTRL_CODE");
        INDEX_STATUS            = GridObj.GetColHDIndex("STATUS");
        INDEX_CHANGE_USER_ID    = GridObj.GetColHDIndex("CHANGE_USER_ID");
		INDEX_RA_FLAG			= GridObj.GetColHDIndex("RA_FLAG");
		INDEX_SIGN_STATUS		= GridObj.GetColHDIndex("SIGN_STATUS");
		INDEX_CUST_CODE			= GridObj.GetColHDIndex("CUST_CODE");
		INDEX_WBS_NO			= GridObj.GetColHDIndex("WBS_NO");
		INDEX_WBS_TXT			= GridObj.GetColHDIndex("WBS_TXT");
		INDEX_DEMAND_DEPT		= GridObj.GetColHDIndex("DEMAND_DEPT");
		INDEX_ADD_USER_ID		= GridObj.GetColHDIndex("ADD_USER_ID");
		INDEX_TEL_NO			= GridObj.GetColHDIndex("TEL_NO");
		
    }


    //조회버튼을 클릭
    function doSelect() {
    	
    	form1.from_date.value = del_Slash(form1.from_date.value);
    	form1.to_date.value = del_Slash(form1.to_date.value);
    	
    	var from_date			= LRTrim(form1.from_date.value);
    	var to_date	    		= LRTrim(form1.to_date.value);
		var CHANGE_USER_NAME	= LRTrim(form1.CHANGE_USER_NAME.value);
    	var bid_flag			= form1.bid_flag.value;
    	var r_subject 			= LRTrim(form1.r_subject.value);
    	var ann_no	    		= LRTrim(form1.ann_no.value).toUpperCase();
    	 

    	if(from_date == "" || to_date == "" ) {
    		alert("생성일자를 입력하셔야 합니다.");
    		return;
    	}
    	if(!checkDate(from_date)) {
    		alert("생성일자를 확인하세요.");
    		form1.from_date.select();
    		return;
    	}
    	if(!checkDate(to_date)) {
    		alert("생성일자를 확인하세요.");
    		form1.to_date.select();
    		return;
    	}

		if(eval(document.forms[0].to_date.value) < eval(document.forms[0].from_date.value))
		{
			alert("생성일자를 확인하세요.");
			return;
		}
		
    	/*service : p1008.java
    	* query : p1008.xml
    	*/
    	
        var mode   = "getratbdlis1_1";
    	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_lis1";
    	
    	var cols_ids = "<%=grid_col_id%>";
    	var params = "mode=" + mode;
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	GridObj.post( servletUrl, params );
    	GridObj.clearAll(false);
    }


    function checkedRow() {
	    var checked_count = 0;
	    var checked_row   = -1;
	    var rowcount = GridObj.GetRowCount();

	    for (var row = 0; row < rowcount; row++) {
	    	if ("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
   			    checked_row   = row;
        		checked_count++;
        	}
	    }

        if(checked_count == 0)  {
	    	alert("선택된 로우가 없습니다.");
	    	return -1;
	    }

        if(checked_count > 1)  {
	    	alert("하나의 로우만 선택할 수 있습니다.");
	    	return -1;
	    }

        return checked_row;
  	}

    function checkCtrlCode(row_idx) { //구매그룹 체크
	    var ctrl_code  = GD_GetCellValueIndex(GridObj,row_idx, INDEX_CTRL_CODE);
	    var ctrl_codes = "<%=info.getSession("CTRL_CODE")%>".split("&");

	    for( i=0; i < ctrl_code.length; i++ )	{
  	        if (ctrl_code == ctrl_codes[i]) {
  	        	return true;
  	        }
        }

        alert("구매그룹이 동일한 경우만 작업 가능합니다.");
        return false;
  	}

    function checkUserId(row_idx) {
        var user_id        = "<%=user_id%>";
	    var change_user_id = GD_GetCellValueIndex(GridObj,row_idx, INDEX_CHANGE_USER_ID);

        if (user_id != change_user_id) {
   	        alert("담당자만 작업 가능합니다.");
   	        return false;
        }

 		return true;
  	}

    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	    
	    
	    if(msg1 == "doQuery"){
// 	    	server_time = LRTrim(GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("SERVER_TIME")).getValue());
//        	    server_time = GD_GetParam(GridObj,0);

//             var currentDate = new Date();
//             var client_time = currentDate.getTime();
// 			server_time = client_time;
//        	    clock("s");
	    } else if(msg1 == "doData") {
// 		    if("1" == GridObj.GetStatus()) {
// 			    alert( "역경매내역이 삭제되었습니다." );
// 			    doSelect();
// 		    }
	    } else if(msg1 == "t_imagetext") {
    		var ra_no		= GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_RA_NO),msg2);
    		var ra_count	= GD_GetCellValueIndex(GridObj,msg2, INDEX_RA_COUNT);
    		var pr_no       = GD_GetCellValueIndex(GridObj,msg2,INDEX_PR_NO);
			var RA_FLAG     = GD_GetCellValueIndex(GridObj,msg2,INDEX_RA_FLAG);


		    if(msg3 == INDEX_ANN_NO){       //공고번호 click
				if(RA_FLAG != "D") { // 입찰공고, 정정공고
                   window.open("/ebid_doc/reveracution.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=900,height=740,left=0,top=0");

                } else {//취소공고
                   window.open("/s_kr/bidding/rat/rat_pp_dis3.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=550,left=0,top=0");
                }

		    } else if(msg3 == INDEX_ATTACH_NO) { //첨부파일
				//var attach_no = WiseTable.getValue(msg2,INDEX_ATTACH_NO);
				//attach(attach_no);
				var ATTACH_VIEW_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ATTACH_NO));

                if("" != ATTACH_VIEW_VALUE) {
                    rMateFileAttach('P','R','RA',ATTACH_VIEW_VALUE);
                }
		    } else if(msg3 == INDEX_PR_NO) { //청구번호
                window.open('../pr/pr3_pp_dis1.jsp?PR_NO='+pr_no,"windowopen2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=840,height=680,left=0,top=0");
		    }
	    }
    }

    function from_date(year,month,day,week) {
    	document.forms[0].from_date.value=year+month+day;
    }

    function to_date(year,month,day,week) {
    	document.forms[0].to_date.value=year+month+day;
    }

//     var tmpSec = 1000;
// 	function clock(flag) {
		
// 		if("undefined" != typeof server_time) {
// 			curDate = new Date(server_time + tmpSec);
// 			yyyy    = curDate.getYear();
// 			mm      = curDate.getMonth()+1;
// 			dd      = curDate.getDate();
// 			hh      = curDate.getHours();
// 			mi      = curDate.getMinutes();
// 			ss      = curDate.getSeconds();
	
// 	        if (mm < 10) mm = "0" + mm;
// 	        if (dd < 10) dd = "0" + dd;
// 	        if (hh < 10) hh = "0" + hh;
// 	        if (mi < 10) mi = "0" + mi;
// 	        if (ss < 10) ss = "0" + ss;
	
// 	        var day = "";
	        
// 			switch(curDate.getDay()) {
// 				case 0: day = "일"; break;
// 				case 1: day = "월"; break;
// 				case 2: day = "화"; break;
// 				case 3: day = "수"; break;
// 				case 4: day = "목"; break;
// 				case 5: day = "금"; break;
// 				case 6: day = "토"; break;
// 			}
// 			document.form1.server_date.value = yyyy + "년" + mm + "월" + dd + "일(" + day + ") " + hh + "시" + mi + "분" + ss + "초";
// 		}
// 		tmpSec = tmpSec + 1000;
//  		setTimeout('clock("c")', 1000);
// 	}

	 function doCreate(){
        location.href = "rat_bd_ins1.jsp?BID_STATUS=AR";
    }

	function chk_Ctrl_Code(ctrl_d, ctrl_o) { // function의 실행 권한 check (내/외자 담당자만 가능함.)

		var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
		var flag = false;

		for( i=0; i<ctrl_code.length; i++ )
		{
			if ((ctrl_code[i] == ctrl_d) || (ctrl_code[i] == ctrl_o)){
				flag = true;
				break;
			}
		}
		flag = true;
		return flag;
	}


	function setModify() {
        var SCR_FLAG;
        var url;

        var checked_count = 0;
        var rowcount = GridObj.GetRowCount();
        var index_flag = 0;

        var getchk = chk_Ctrl_Code("D","");

        if(getchk == false) {
            alert("처리할 권한이 없습니다.");
            return;
        }

        checked_count = 0;
		//'RT'='작성중', 'RP' = '결재중', 'RC'='확정'  CC = 공고확정,'RA'='역경매공고중', 'RP'='역경매진행', 'RF'='역경매마감'
		var RA_NO			= "";
		var RA_COUNT		= "";
        var SIGN_STATUS     = "";
        var CHANGE_USER_ID  = "";
		var RA_FLAG			= "";
		
        for(row=0; row<GridObj.GetRowCount(); row++) {
            if( "1" == LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SELECTED")).getValue())) {
                checked_count++;

                RA_NO			= LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("RA_NO")).getValue());
                RA_COUNT		= LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("RA_COUNT")).getValue());
                SIGN_STATUS     = LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SIGN_STATUS")).getValue());
                STATUS     		= LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("STATUS")).getValue());
                CHANGE_USER_ID  = LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("CHANGE_USER_ID")).getValue());
				RA_FLAG			= LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("RA_FLAG")).getValue());
				
				if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
                    alert("처리할 권한이 없습니다.");
                    return;
                }
				
				if( "P" == SIGN_STATUS) {
                    alert("결재중인 공고는 수정하실 수 없습니다.");
                    return;
                } else if ( "E" == SIGN_STATUS) {
                    alert("결재완료된 공고는 수정하실 수 없습니다.");
                    return;
                } else if( "C" == SIGN_STATUS) {
                	alert("확정된 공고는 수정할 수 없습니다.");
                	return;
                }
/*                
                if( "RT" == STATUS) { // 수정 (어차피 결재반려건은 조회 안됨.)
//                    url = "rat_bd_ins1.jsp?RA_NO="+RA_NO+"&RA_COUNT="+RA_COUNT+"&SCR_FLAG=U";  //&BID_STATUS="+BID_STATUS입찰공고, 정정공고 수정             	
                	if (RA_COUNT == "2") {  // TTA:1 line remark, 5 line insert 2007/07/26 ==> 바로 확정으로 처리
                    		url = "rat_bd_ins2.jsp?RA_NO="+RA_NO+"&RA_COUNT="+RA_COUNT+"&SCR_FLAG=C";  //&BID_STATUS="+BID_STATUS입찰공고, 정정공고 수정
                	} else {
                    		url = "rat_bd_ins1.jsp?RA_NO="+RA_NO+"&RA_COUNT="+RA_COUNT+"&SCR_FLAG=U";  //&BID_STATUS="+BID_STATUS입찰공고, 정정공고 수정
                	}
                } else if( "RP" == STATUS) { // 결재중
                    alert("결재중인 건은 수정할 수  없습니다.");
                    return;
                } else  {                   // 확인(상세조회)
                    //if(front_STATUS == "A" || front_STATUS == "U") {
//                        url = "rat_bd_ins1.jsp?RA_NO="+RA_NO+"&RA_COUNT="+RA_COUNT+"&SCR_FLAG=D";  //입찰공고, 정정공고 상세조회&BID_STATUS="+BID_STATUS
										alert("이미 확정된 건입니다.");	// TTA:1 line remark, 2 line insert 2007/07/26
										return;
                    //} else {
                       // url = "rat_bd_dis2.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&SCR_FLAG=D&BID_STATUS="+BID_STATUS;  //취소공고 상세조회
                    //}
                }

                //if(BID_STATUS == "RC" || BID_STATUS == "SR" || BID_STATUS == "SC") { // 마감처리, 규격평가 건일 경우에는 아래의 로직의 예외사항...-> 확인 으로 보여준다.
                    //url = "rat_bd_ins1.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&SCR_FLAG=D&BID_STATUS="+BID_STATUS;  //입찰공고, 정정공고 상세조??
                //}
*/                
				if( "T" == SIGN_STATUS || "R" == SIGN_STATUS) {
					if (RA_FLAG == "D") { 
                    		url = "rat_bd_ins2.jsp?RA_NO="+RA_NO+"&RA_COUNT="+RA_COUNT+"&SCR_FLAG=U";  // 취소공고수정
                	} else {
                    		url = "rat_bd_ins1.jsp?RA_NO="+RA_NO+"&RA_COUNT="+RA_COUNT+"&SCR_FLAG=U";  // 입찰공고, 정정공고 수정
                	}
                }	
            }            
        }


        if(checked_count == 0) {
            alert("선택된 로우가 없습니다.");
            return;
        }

        if(checked_count > 1) {
            alert("한 건만 선택하실 수 있습니다.");
            return;
        }
		//location.href = url;		
		window.open(url,"doReverseAuction","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
        

    }

	function Approval(pflag) {       // 확정= 'C'
        var SCR_FLAG;
        var url;

        var checked_count = 0;
        var rowcount = GridObj.GetRowCount();
        var index_flag = 0;

        var getchk = chk_Ctrl_Code("D","");

        if(getchk == false) {
            alert("처리할 권한이 없습니다.");
            return;
        }

        checked_count = 0;

        for(row=0; row<GridObj.GetRowCount(); row++) {
            if( "1" == LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SELECTED")).getValue())) {
                checked_count++;
            }
        }

        if(checked_count == 0) {
            alert("선택된 로우가 없습니다.");
            return;
        }

        if(checked_count > 1) {
            alert("한 건만 선택하실 수 있습니다.");
            return;
        }

        checked_count = 0;


        for(row=0; row<GridObj.GetRowCount(); row++) {
            if( "1" == LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SELECTED")).getValue())) {
                checked_count++;

                
                
                var RA_NO			= LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("RA_NO")).getValue());
                var RA_COUNT       	= LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("RA_COUNT")).getValue())
                var RA_FLAG      	= LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("RA_FLAG")).getValue())
                var SIGN_STATUS     = LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SIGN_STATUS")).getValue())
                var STATUS     		= LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("STATUS")).getValue())
                var CHANGE_USER_ID  = LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("CHANGE_USER_ID")).getValue())
                //var ANN_DATE        = WiseTable.getValue(row, INDEX_ANN_DATE);


                if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
                    alert("처리할 권한이 없습니다.");
                    return;
                }
				//'RT'='작성중', 'RC'='확정'  ,'RA'='역경매공고중', 'RP'='역경매진행', 'RF'='역경매마감'
				
				if(SIGN_STATUS != "E") { 
					alert("'결재완료'된 역경매공고만 공고할 수 있습니다.");
					return;
				}
				
				if(SIGN_STATUS == "E") {                   // 확정
					if(RA_FLAG == "P") {
						url = "rat_bd_ins1.jsp?RA_NO="+RA_NO+"&RA_COUNT="+RA_COUNT+"&SCR_FLAG=C&RA_FLAG="+RA_FLAG;  //입찰공고, 정정공고 확정,&BID_STATUS="+BID_STATUS
					} else if(RA_FLAG == "D" ){
						url = "rat_bd_ins2.jsp?RA_NO="+RA_NO+"&RA_COUNT="+RA_COUNT+"&SCR_FLAG=C&RA_FLAG="+RA_FLAG;  //취소공고 확정,&BID_STATUS="+BID_STATUS
					}
				}else {
					alert("이미 확정된 건입니다.");
					return;
				}
			}
		}
		window.open(url,"doReverseAuction","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
    }

	function doDelete() {

        var SCR_FLAG;
        var url;

        var checked_count = 0;
        var rowcount = GridObj.GetRowCount();
        var index_flag = 0;

        checked_count = 0;

        for(row=0; row<GridObj.GetRowCount(); row++) {
        	
            if( "1" == LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SELECTED")).getValue())) {
                checked_count++;

                var RA_NO          	= LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("RA_NO")).getValue());
                var RA_COUNT       	= LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("RA_COUNT")).getValue());
                //var BID_STATUS      = WiseTable.getValue(row, INDEX_BID_STATUS);
				//var BID_STATUS      = LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("BID_STATUS")).getValue());
                var CHANGE_USER_ID  = LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("CHANGE_USER_ID")).getValue());
				var SIGN_STATUS  	= LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SIGN_STATUS")).getValue());
                //var end_STATUS    	= BID_STATUS.substring(1, 2);
				//alert(BID_STATUS);

                if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
                    alert("처리할 권한이 없습니다.");
                    return;
                }

				//if(end_STATUS != "C") {
                if(SIGN_STATUS == "P"){
                	alert("결재중인 공고는 삭제할 수 없습니다.");
                    return;
                }else if(SIGN_STATUS == "E"){
                	alert("결재완료된 공고는 삭제할 수 없습니다.");
                    return;
				}else if(SIGN_STATUS == "C") {
                    alert("공고중인 건은 삭제할 수 없습니다.");
                    return;
                }

            }
        }
		
		if(checked_count == 0) {
            alert("선택된 로우가 없습니다.");
            return;
        }
        
		Message = "삭제 하시겠습니까?";

		if(confirm(Message) != 1) return;
		
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_lis1";
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		params = "?mode=setRaDelete";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor(servletUrl+params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
		
			
// 		servletUrl = "/servlets/dt.rat.rat_bd_lis11";

// 		GridObj.SetParam("mode", "setRaDelete");
//         GridObj.bSendDataFuncDefaultValidate=false;
// 		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
// 		GridObj.SendData(servletUrl, "ALL", "ALL");
//         GridObj.strHDClickAction="sortmulti";
   		
	}

	function setCancelNoti() {
        var SCR_FLAG;
        var url;

        var checked_count = 0;
        var rowcount = GridObj.GetRowCount();
        var index_flag = 0;

        var getchk = chk_Ctrl_Code("D","");

        if(getchk == false) {
            alert("처리할 권한이 없습니다.");
            return;
        }

        checked_count = 0;

        for(row=0; row<GridObj.GetRowCount(); row++) {
        	if( "1" == LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SELECTED")).getValue())) {
                checked_count++;

                var RA_NO          	= LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("RA_NO")).getValue());
                var RA_COUNT       	= LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("RA_COUNT")).getValue());
                var SIGN_STATUS     = LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SIGN_STATUS")).getValue());
				var STATUS			= LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("STATUS")).getValue());
                var CHANGE_USER_ID  = LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("CHANGE_USER_ID")).getValue());
				var RA_FLAG			= LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("RA_FLAG")).getValue());
                // 'RT', '작성중', 'RP', '결재중', 'RC', '확정' ,'RA', '역경매공고중', 'RP', '역경매진행', 'RF', '역경매마감'
                if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
                    alert("처리할 권한이 없습니다.");
                    return;
                }

                if(RA_FLAG == "D"  &&  SIGN_STATUS == "C") {
                    alert("이미 확정된 취소공고건입니다.");
                    return;
                }

				if(SIGN_STATUS != "C"){
					alert("공고중인 건만 취소공고를 하실 수 있습니다.");
					return;
				}
				
                if(RA_FLAG == "C") {
                    alert("이미 개찰이 끝난건은 취소공고를 하실 수 없습니다.");
                    return;
                } else {
                    url = "rat_bd_ins2.jsp?RA_NO="+RA_NO+"&RA_COUNT="+RA_COUNT+"&SCR_FLAG=I&BID_STATUS=CR";  //취소공고 생성
                }
            }
        }

        if(checked_count == 0) {
            alert("선택된 로우가 없습니다.");
            return;
        }

        if(checked_count > 1) {
            alert("한 건만 선택하실 수 있습니다.");
            return;
        }
		
		if(!confirm("역경매 취소공고를 작성하시겠습니까?")) return;
        
        window.open(url,"doReverseAuction","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
        //location.href = url;

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
		}
	}

//-->
</script>

<%-- Ajax SelectBox용 JSP--%>
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
	
    if(GridObj.getColIndexById("ANN_NO") == cellInd){
		var RA_FLAG 	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("RA_FLAG")).getValue());
		var ra_no		= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("RA_NO")).getValue());
		var ra_count	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("RA_COUNT")).getValue());
		var pr_no       = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("PR_NO")).getValue());
		
		if(RA_FLAG != "D") { // 입찰공고, 정정공고
            window.open("/ebid_doc/reveracution.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=900,height=740,left=0,top=0");

         } else {//취소공고
//             window.open("/s_kr/bidding/rat/rat_pp_dis3.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=550,left=0,top=0");
            window.open("/kr/dt/rat/rat_bd_ins2.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count+"&SCR_FLAG=V","windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=550,left=0,top=0");
         }    	
    }
    
    
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
        doSelect();
        //doQuery();
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
    
    //clock("s");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    
    form1.from_date.value = add_Slash(form1.from_date.value);
	form1.to_date.value = add_Slash(form1.to_date.value);
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}
</script>
</head>
<!-- <body onload="javascript:init();;GD_setProperty(document.WiseGrid);" bgcolor="#FFFFFF" text="#000000" topmargin="0"> -->
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" topmargin="0">

<s:header>
<!--내용시작-->
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
<form name="form1" >
	<input type="hidden" name="ctrl_code" value="">

	<input type="hidden" id="att_mode"   name="att_mode"   value="">
	<input type="hidden" id="view_type"  name="view_type"  value="">
	<input type="hidden" id="file_type"  name="file_type"  value="">
	<input type="hidden" id="tmp_att_no" name="tmp_att_no" value="">
	
	<input type="hidden" id="RA_NO"	 	name="RA_NO"	value="">
	<input type="hidden" id="RA_COUNT" 	name="RA_COUNT" value="">
	<input type="hidden" id="SCR_FLAG" 	name="SCR_FLAG" value="">
	


<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">	
    	<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 생성일자</td>
      		<td width="25%" height="24" class="data_td">
      			<s:calendar id="from_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1))%>" 	format="%Y/%m/%d"/>~
      			<s:calendar id="to_date"   default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),1))%>" 									format="%Y/%m/%d"/>
      		</td>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 진행상황</td>
      		<td width="20%" height="24" class="data_td">
        		<select id="bid_flag" name="bid_flag" class="inputsubmit">
          			<option value="">전체</option>
          			<option value="RT">작성중</option>
          			<option value="RP">결재중</option>
          			<option value="RC	">결재완료</option>
          			<option value="CC">공고확정</option>
          			<option value="RA">공고중</option>
          			<option value="BP">역경매진행</option>
          			<!--
          			<option value="RF">역경매종료</option>
          			-->
        		</select>
      		</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>      	
    	<tr>
			<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</td>
      		<td class="data_td">
        		<input type="text" id="ann_no" name="ann_no" size="20" style="ime-mode:inactive" maxlength="14" class="inputsubmit" onkeydown='entKeyDown()' >
      		</td>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 구매담당자</td>
      		<td width="35%" class="data_td" >
         		<input type="text" id="CHANGE_USER_NAME" name="CHANGE_USER_NAME"  value="<%=USER_NAME%>" size="10" maxlength="10" class="inputsubmit" onkeydown='entKeyDown()' >
      		</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>      	
	 	<tr>
	  		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 현재시간</td>
      		<td class="data_td">
				<div id="id1"></div>
			    <input type="hidden" id="h_server_date" name="h_server_date" class="input_empty" size="50" readonly>      		
      		</td>
      		<td width="15%" class="title_td">
        		<div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 역경매건명</div>
      		</td>
      		<td width="35%" class="data_td">
         		<input type="text" id="r_subject" name="r_subject"  value="" size="30" maxlength="10" class="inputsubmit" onkeydown='entKeyDown()' >
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
      		<td height="30">
        		<div align="right">
				<!-- #새로 UI버튼추가함 -->
					<table cellpadding="0">
						<tr>
							<td><script language="javascript">btn("javascript:doSelect()","조 회")</script></td>
							<td><script language="javascript">btn("javascript:Approval('C')","공 고")</script></td>
							<td><script language="javascript">btn("javascript:setModify()","수 정")</script></td>			
							<td><script language="javascript">btn("javascript:setCancelNoti()","취소공고")</script></td>
							<td><script language="javascript">btn("javascript:doDelete()","삭 제")</script></td>
			
							<!--
							<td><script language="javascript">btn("javascript:doCreate()",1,"공 고")</script></td>
							<td><script language="javascript">btn("javascript:Approval('C')",7,"확 정")</script></td> -->
			
						</tr>
					</table>
				<!-- # -->
				</div>
      		</td>
    	</tr>
	</table>
</form>
<!---- END OF USER SOURCE CODE ---->
<!---- END OF USER SOURCE CODE ---->
</s:header>
<s:grid screen_id="AU_001" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


