<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/kr/dt/rfq/rfq_pp_ins1.jsp -->
<!--
Title:        FrameWork 적용 Sample화면(PROCESS_ID)  <p>
 Description:  개발자들에게 적용될 기본 Sample(조회) 작업 입니다.(현재 모듈명에 대한 간략한 내용 기술) <p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       DEV.Team 2 Senior Manager Song Ji Yong<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!-->
<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간

    String REQ_BID_NO     = JSPUtil.nullToEmpty(request.getParameter("BID_NO"));
    String REQ_BID_COUNT  = JSPUtil.nullToEmpty(request.getParameter("BID_COUNT"));
    String REQ_VOTE_COUNT = JSPUtil.nullToEmpty(request.getParameter("VOTE_COUNT"));
    
    String DB_time 				= "";
    String ANN_NO   			= "";
    String ANN_ITEM 			= "";
    String CONT_TYPE1_TEXT_D   	= "";
    String CONT_TYPE2_TEXT_D   	= "";
    String PROM_CRIT_NAME   	= "";
    
    String ANN_DATE = "";
    
    String X_DOC_SUBMIT_DATE = "";
    String X_DOC_SUBMIT_TIME = "";
    String BID_BEGIN_DATE = "";
    String BID_BEGIN_TIME = "";
    String BID_END_DATE = "";
    String BID_END_TIME = "";
    String OPEN_DATE = "";
    String OPEN_TIME = "";
    
    String BID_NO     = "";
    String BID_COUNT  = "";
    String VOTE_COUNT = "";
    
    

	Map< String, String >   map = new HashMap< String, String >();
	map.put("BID_NO"		, REQ_BID_NO);
	map.put("BID_COUNT"		, REQ_BID_COUNT);

	Object[] obj = {map};
	SepoaOut value = ServiceConnector.doService(info, "BD_006", "CONNECTION","getBdHeaderDetail", obj);
	
	SepoaFormater wf = new SepoaFormater(value.result[0]); 

    if(wf != null) {
        if(wf.getRowCount() > 0) { //데이타가 있는 경우
        	BID_NO           = wf.getValue("BID_NO", 0);
            BID_COUNT    = wf.getValue("BID_COUNT", 0);
            VOTE_COUNT = wf.getValue("VOTE_COUNT", 0);
            
        	ANN_NO      		= wf.getValue("ANN_NO", 0);
        	ANN_ITEM    		= wf.getValue("ANN_ITEM", 0);
        	CONT_TYPE1_TEXT_D  	= wf.getValue("CONT_TYPE1_TEXT_D", 0);
        	CONT_TYPE2_TEXT_D  	= wf.getValue("CONT_TYPE2_TEXT_D", 0);
        	PROM_CRIT_NAME  	= wf.getValue("PROM_CRIT_NAME", 0);
        	
        	ANN_DATE = wf.getValue("ANN_DATE", 0);
        	
        	X_DOC_SUBMIT_DATE = wf.getValue("X_DOC_SUBMIT_DATE", 0);
        	X_DOC_SUBMIT_TIME = wf.getValue("X_DOC_SUBMIT_TIME", 0).substring(0, 4);
        	BID_BEGIN_DATE =  wf.getValue("BID_BEGIN_DATE", 0);
        	BID_BEGIN_TIME = wf.getValue("BID_BEGIN_TIME", 0).substring(0, 4);
        	BID_END_DATE =  wf.getValue("BID_END_DATE", 0);
        	BID_END_TIME = wf.getValue("BID_END_TIME", 0).substring(0, 4);
        	OPEN_DATE =  wf.getValue("OPEN_DATE", 0);
        	OPEN_TIME = wf.getValue("OPEN_TIME", 0).substring(0, 4);
        } 
    }

    wf = new SepoaFormater(value.result[1]);
    if(wf != null) {
        if(wf.getRowCount() > 0) { //데이타가 있는 경우
            DB_time = getDBDate(wf.getValue(0, 0));
        }
    }
%>

<%!public String getDBDate(String date_time) {
		int db_year = Integer.parseInt(date_time.substring(0, 4));
		int db_month = Integer.parseInt(date_time.substring(4, 6)) - 1;
		int db_date = Integer.parseInt(date_time.substring(6, 8));
		int db_hour = Integer.parseInt(date_time.substring(8, 10));
		int db_minute = Integer.parseInt(date_time.substring(10, 12));
		int db_second = Integer.parseInt(date_time.substring(12, 14));

		java.util.Calendar svr_calendar = java.util.Calendar.getInstance();
		svr_calendar.set(db_year, db_month, db_date, db_hour, db_minute,
				db_second);

		return String.valueOf(svr_calendar.getTimeInMillis());
	}%>
	
<% 
	if( "".equals(BID_NO) || "".equals(BID_COUNT) || "".equals(VOTE_COUNT) ||	
		!REQ_BID_NO.equals(BID_NO) || !REQ_BID_COUNT.equals(BID_COUNT) || !REQ_VOTE_COUNT.equals(VOTE_COUNT)  ){ 
%>
	<script language="javascript" type="text/javascript">
	<!--
		alert("입찰공고를 다시 조회후 입찰시간 변경 해주세요.");
		self.close();
	//-->
	</script>
<% }else{ %>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title>
<%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME%>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript" type="text/javascript"> 
<!--
    var current_date = "<%=current_date%>";
    var current_time = "<%= current_time%>";

    var cur_hh   	= current_time.substring(0,2);
    var cur_mm   	= current_time.substring(2,4);
    var cur_hh_mm 	= current_time.substring(0,4);

    var server_time;
    var diff_time;
    var check_term;
    var query_term = 10;    //초단위
    
    var button_flag 	= false;

    //로딩시 년,월,시,분을 가져오는 함수
    function init()
    {
		// 현재시간 setting
        check_term = query_term;
        server_time = "<%=DB_time%>";
		clock('s');

		
		document.form1.ANN_DATE.value = "<%=ANN_DATE%>";
		
		// 날짜는 오늘로			
		//document.form1.X_DOC_SUBMIT_DATE.value = add_Slash(current_date);
		document.form1.O_X_DOC_SUBMIT_DATE.value = "<%=X_DOC_SUBMIT_DATE%>";
		document.form1.O_X_DOC_SUBMIT_TIME.value = "<%=X_DOC_SUBMIT_TIME%>";
		document.form1.O_BID_BEGIN_DATE.value = "<%=BID_BEGIN_DATE%>";
		document.form1.O_BID_BEGIN_TIME.value = "<%=BID_BEGIN_TIME%>";
		document.form1.O_BID_END_DATE.value = "<%=BID_END_DATE%>";
		document.form1.O_BID_END_TIME.value = "<%=BID_END_TIME%>";
		document.form1.O_OPEN_DATE.value = "<%=OPEN_DATE%>";
		document.form1.O_OPEN_TIME.value = "<%=OPEN_TIME%>";
		
		document.form1.X_DOC_SUBMIT_DATE.value = "<%=SepoaString.getDateSlashFormat(X_DOC_SUBMIT_DATE)%>";
		document.form1.X_DOC_SUBMIT_TIME.value = "<%=X_DOC_SUBMIT_TIME%>";		
		document.form1.BID_BEGIN_DATE.value = "<%=SepoaString.getDateSlashFormat(BID_BEGIN_DATE)%>";
		document.form1.BID_BEGIN_TIME.value = "<%=BID_BEGIN_TIME%>";
		document.form1.BID_END_DATE.value = "<%=SepoaString.getDateSlashFormat(BID_END_DATE)%>";
		document.form1.BID_END_TIME.value = "<%=BID_END_TIME%>";
		document.form1.OPEN_DATE.value = "<%=SepoaString.getDateSlashFormat(OPEN_DATE)%>";
		document.form1.OPEN_TIME.value = "<%=OPEN_TIME%>";
		
		document.form1.BID_NO.value = "<%=BID_NO%>";
		document.form1.BID_COUNT.value = "<%=BID_COUNT%>";
		document.form1.VOTE_COUNT.value = "<%=VOTE_COUNT%>";
				
	}

	function BID_BEGIN_DATE(year, month, day, week) {
		document.form1.BID_BEGIN_DATE.value = year + month + day;
	}

	function BID_END_DATE(year, month, day, week) {
		document.form1.BID_END_DATE.value = year + month + day;
	}

	function OPEN_DATE(year, month, day, week) {
		document.form1.OPEN_DATE.value = year + month + day;
	}

	function clock(flag) {
		if (flag == "s") { // Server Call
			var currentDate = new Date();
			var client_time = currentDate.getTime();

			diff_time = client_time - server_time;
		}

		curDate = new Date(Date.parse(Date()) - diff_time);
		yyyy = curDate.getYear();
		mm = curDate.getMonth() + 1;
		dd = curDate.getDate();
		hh = curDate.getHours();
		mi = curDate.getMinutes();
		ss = curDate.getSeconds();

		if (mm < 10)
			mm = "0" + mm;
		if (dd < 10)
			dd = "0" + dd;
		if (hh < 10)
			hh = "0" + hh;
		if (mi < 10)
			mi = "0" + mi;
		if (ss < 10)
			ss = "0" + ss;

		switch (curDate.getDay()) {
		case 0:
			day = "일";
			break;
		case 1:
			day = "월";
			break;
		case 2:
			day = "화";
			break;
		case 3:
			day = "수";
			break;
		case 4:
			day = "목";
			break;
		case 5:
			day = "금";
			break;
		case 6:
			day = "토";
			break;
		}

		document.form1.server_date.value = yyyy + "년" + mm + "월" + dd + "일("
				+ day + ") " + hh + "시" + mi + "분" + ss + "초";
		document.form1.h_server_date.value = "" + yyyy + mm + dd + hh + mi + ss;
		setTimeout('clock("c")', 1000);
	}

	function checkData() {
				
		var cur_hh   = current_time.substring(0,2);
		var cur_mm   = current_time.substring(2,4);
		
		var ANN_DATE = document.form1.ANN_DATE.value;
		
		var O_X_DOC_SUBMIT_DATE = document.form1.O_X_DOC_SUBMIT_DATE.value;
		var O_X_DOC_SUBMIT_TIME = document.form1.O_X_DOC_SUBMIT_TIME.value;
		var O_BID_BEGIN_DATE = document.form1.O_BID_BEGIN_DATE.value;
		var O_BID_BEGIN_TIME = document.form1.O_BID_BEGIN_TIME.value;
		var O_BID_END_DATE = document.form1.O_BID_END_DATE.value;
		var O_BID_END_TIME = document.form1.O_BID_END_TIME.value;		
		var O_OPEN_DATE = document.form1.O_OPEN_DATE.value;
		var O_OPEN_TIME = document.form1.O_OPEN_TIME.value;
		
		var X_DOC_SUBMIT_DATE = del_Slash(document.form1.X_DOC_SUBMIT_DATE.value);
		var X_DOC_SUBMIT_TIME = document.form1.X_DOC_SUBMIT_TIME.value;		
		var BID_BEGIN_DATE = del_Slash(document.form1.BID_BEGIN_DATE.value);
		var BID_BEGIN_TIME = document.form1.BID_BEGIN_TIME.value;
		var BID_END_DATE = del_Slash(document.form1.BID_END_DATE.value);
		var BID_END_TIME = document.form1.BID_END_TIME.value;		
		var OPEN_DATE = del_Slash(document.form1.OPEN_DATE.value);
		var OPEN_TIME = document.form1.OPEN_TIME.value;
		
		var VOTE_COUNT = document.form1.VOTE_COUNT.value;
		
		if( VOTE_COUNT != "1"){
			alert("재입찰 진행건은 입찰시간 변경이 불가합니다.");
			return false;
		}
		
		
		if(O_X_DOC_SUBMIT_DATE != X_DOC_SUBMIT_DATE || O_X_DOC_SUBMIT_TIME != X_DOC_SUBMIT_TIME){
		
			if(LRTrim(X_DOC_SUBMIT_DATE)== "") {
			    alert("제출일을 입력하세요. ");
			    document.forms[0].X_DOC_SUBMIT_DATE.focus();
			    return false;
			}
	
			if(!checkDateCommon(X_DOC_SUBMIT_DATE)){
			    document.forms[0].X_DOC_SUBMIT_DATE.select();
			    alert("제출일을 확인하세요.");
			    return false;
			}
			
			if(LRTrim(X_DOC_SUBMIT_TIME)== "") {
				alert("제출일시를 입력하세요.");
			    document.forms[0].X_DOC_SUBMIT_TIME.focus();
			    return false;
			}
			
			if(X_DOC_SUBMIT_TIME.length != 4) {
				alert("제출일시를 확인하세요.");
			    document.forms[0].X_DOC_SUBMIT_TIME.focus();
			    return false;
			}
							
			if (eval(X_DOC_SUBMIT_DATE) < eval(current_date)) {
				alert ("제출일의 시작일자는 오늘보다 이후 날짜이어야 합니다.");
				document.forms[0].X_DOC_SUBMIT_DATE.focus();
				return false;
			} else if (eval(X_DOC_SUBMIT_DATE) == eval(current_date)) {
				if (eval(X_DOC_SUBMIT_TIME.substring(0,2)) <   eval(cur_hh)) {
					alert ("제출일의 시간은 현재시간보다 이후여야 합니다.");
					document.forms[0].X_DOC_SUBMIT_TIME.focus();
					return false;
				} else if (eval(X_DOC_SUBMIT_TIME.substring(0,2)) ==   eval(cur_hh)) {
					if (eval(X_DOC_SUBMIT_TIME.substring(2,4)) < eval(cur_mm)) {
						alert ("제출일의 시간 설정이 잘못되었습니다.");
						document.forms[0].X_DOC_SUBMIT_TIME.focus();
						return false;
					}
				}
			}
			
			if (eval(X_DOC_SUBMIT_DATE) > eval(BID_END_DATE)) {
				alert ("제출일자는 입찰종료일자 이전이어야 합니다.");
				document.forms[0].X_DOC_SUBMIT_DATE.focus();
				return false;
			} else if (eval(X_DOC_SUBMIT_DATE) == eval(BID_END_DATE)) {
				if (eval(X_DOC_SUBMIT_TIME) >   eval(BID_END_TIME)) {
					alert ("제출일시는 종료시각 이전이어야 합니다.");
					document.forms[0].BID_END_TIME.focus();
					return false;
				}
			}
		
		}
		
		
		
		
		
		
		if(LRTrim(BID_BEGIN_DATE)== "") {
		    alert("입찰시작일을 입력하세요. ");
		    document.forms[0].BID_BEGIN_DATE.focus();
		    return false;
		}

		if(!checkDateCommon(BID_BEGIN_DATE)){
		    document.forms[0].BID_BEGIN_DATE.select();
		    alert("입찰시작일을 확인하세요.");
		    return false;
		}
		
		if(LRTrim(BID_BEGIN_TIME)== "") {
			alert("입찰시작일시를 입력하세요.");
		    document.forms[0].BID_BEGIN_TIME.focus();
		    return false;
		}
		
		if(BID_BEGIN_TIME.length != 4) {
			alert("입찰시작일시를 확인하세요.");
		    document.forms[0].BID_BEGIN_TIME.focus();
		    return false;
		}
		
		if(O_BID_BEGIN_DATE != BID_BEGIN_DATE || O_BID_BEGIN_TIME != BID_BEGIN_TIME){			
			if (eval(BID_BEGIN_DATE) < eval(current_date)) {
				alert ("입찰일시의 시작일자는 오늘보다 이후 날짜이어야 합니다.");
				document.forms[0].BID_BEGIN_DATE.focus();
				return false;
			} else if (eval(BID_BEGIN_DATE) == eval(current_date)) {
				if (eval(BID_BEGIN_TIME.substring(0,2)) <   eval(cur_hh)) {
					alert ("입찰일시의 시작시간은 현재시간보다 이후여야 합니다.");
					document.forms[0].BID_BEGIN_TIME.focus();
					return false;
				} else if (eval(BID_BEGIN_TIME.substring(0,2)) ==   eval(cur_hh)) {
					if (eval(BID_BEGIN_TIME.substring(2,4)) < eval(cur_mm)) {
						alert ("입찰일시의 시작시간 설정이 잘못되었습니다.");
						document.forms[0].BID_BEGIN_TIME.focus();
						return false;
					}
				}
			}		
		}
		
		
		if(LRTrim(BID_END_DATE)== "") {
		    alert("입찰종료일을 입력하세요. ");
		    document.forms[0].BID_END_DATE.focus();
		    return false;
		}

		if(!checkDateCommon(BID_END_DATE)){
		    document.forms[0].BID_END_DATE.select();
		    alert("입찰종료일을 확인하세요.");
		    return false;
		}
		
		if(LRTrim(BID_END_TIME)== "") {
			alert("입찰종료일시를 입력하세요.");
		    document.forms[0].BID_END_TIME.focus();
		    return false;
		}
		
		if(BID_END_TIME.length != 4) {
			alert("입찰종료일시를 확인하세요.");
		    document.forms[0].BID_END_TIME.focus();
		    return false;
		}
		
		if (eval(BID_END_DATE) < eval(current_date)) {
			alert ("입찰일시의 종료일자는 오늘보다 이후   날짜이어야 합니다.");
			document.forms[0].BID_END_DATE.focus();
			return false;
		} else if (eval(BID_END_DATE) == eval(current_date)) {
			if (eval(BID_END_TIME.substring(0,2))   < eval(cur_hh)) {
				alert ("입찰일시의 종료시간은 현재시간보다 이후여야   합니다.");
				document.forms[0].BID_END_TIME.focus();
				return false;
			} else if (eval(BID_END_TIME.substring(0,2)) == eval(cur_hh))   {
				if (eval(BID_END_TIME.substring(2,4)) < eval(cur_mm)) {
					alert (" 입찰일시의 종료시간 설정이 잘못되었습니다.");
					document.forms[0].BID_END_TIME.focus();
					return false;
				}
			}
		}
		
		if (eval(BID_BEGIN_DATE) > eval(BID_END_DATE)) {
			alert ("입찰일시의 종료일자는 시작일자보다 커야합니다.");
			document.forms[0].BID_BEGIN_DATE.focus();
			return false;
		} else if (eval(BID_BEGIN_DATE) == eval(BID_END_DATE)) {
			if (eval(BID_BEGIN_TIME) >   eval(BID_END_TIME) ) {
				alert ("입찰일시의 종료시간은 시작시간보다 커야합니다.");
				document.forms[0].BID_END_TIME.focus();
				return false;
			}
		}
		
		
		
		
		
		
		if(LRTrim(OPEN_DATE) == "") {
		    alert("개찰일을 입력하세요. ");
		    document.forms[0].OPEN_DATE.focus();
		    return false;
		}

		if(!checkDateCommon(OPEN_DATE)){
		    document.forms[0].OPEN_DATE.select();
		    alert("개찰일을 확인하세요.");
		    return false;
		}
		
		if(LRTrim(OPEN_TIME)== "") {
			alert("개찰일시를 입력하세요.");
		    document.forms[0].OPEN_TIME.focus();
		    return false;
		}
		
		if(OPEN_TIME.length != 4) {
			alert("개찰일시를 입력하세요.");
		    document.forms[0].OPEN_TIME.focus();
		    return false;
		}
		
		if (eval(OPEN_DATE) < eval(current_date)) {
			alert ("개찰일시의 일자는 오늘보다 이후 날짜이어야 합니다.");
			document.forms[0].OPEN_DATE.focus();
			return false;
		} else if (eval(OPEN_DATE) == eval(current_date)) {
			if (eval(OPEN_TIME.substring(0,2)) < eval(cur_hh)) {
				alert ("개찰일시의 시간은 현재시간보다 이후여야 합니다.");
				document.forms[0].OPEN_TIME.focus();
				return false;
			} else if (eval(OPEN_TIME.substring(0,2))   == eval(cur_hh)) {
				if (eval(OPEN_TIME.substring(2,4)) < eval(cur_mm)) {
					alert ("개찰일시 시간 설정이 잘못되었습니다.");
					document.forms[0].OPEN_TIME.focus();
					return false;
				}
			}
		}

		// 공고일시 ~ 입찰서제출일시
		if (eval(ANN_DATE) > eval(BID_BEGIN_DATE)) {
			alert ("입찰일시 시작일자는 공고등록일시보다  커야합니다.");
			document.forms[0].BID_BEGIN_DATE.focus();
			return false;
		}

		// 입찰서제출일시 ~ 개찰일시
		if (eval(OPEN_DATE) < eval(BID_END_DATE)) {
			alert ("개찰일은 입찰종료일과 같거나 이후여야 합니다.");
			document.forms[0].OPEN_DATE.focus();
			return false;
		} else if (eval(OPEN_DATE) == eval(BID_END_DATE)) {
			if (eval(OPEN_TIME) < eval(BID_END_TIME)) {
				alert ("개찰시각은 입찰일시 종료시각보다 이후여야 합니다.");
				document.forms[0].OPEN_TIME.focus();
				return false;
			}
		}
		
		return true;
	}
	
	function doConfirm() { 
		  
	    if (!checkData()) {
	        button_flag = false;
	    	return;
	    }
		
	    if(confirm("입찰시간을 변경 하시겠습니까?") != 1) {
            button_flag = false;
            return;
        }
	 
	    if(button_flag == true) {
	        alert("작업이 진행중입니다.");
	        return;
	    }

	    button_flag = true;
	    
	    var nickName    = "BD_001";
	    var conType     = "TRANSACTION";
	    var methodName  = "setGonggoBdtm";
	    var SepoaOut    = doServiceAjax( nickName, conType, methodName );

	    if( SepoaOut.status == "1" ) { // 성공
	        alert( SepoaOut.message );
			opener.doSelect();
	        window.close();
	    } else { // 실패
	        alert( SepoaOut.message );
	    }
	   	  
	} 
	
//-->
</script>

</head>

<body bgcolor="#FFFFFF" text="#000000" onLoad="init();">
	<s:header popup="true">
		<form name="form1">
		    <input type="hidden" name="BID_NO" id="BID_NO" />
			<input type="hidden" name="BID_COUNT" id="BID_COUNT" />
			<input type="hidden" name="VOTE_COUNT" id="VOTE_COUNT" />	
			<input type="hidden" name="ANN_DATE" id="ANN_DATE" />				
			<input type="hidden" name="O_X_DOC_SUBMIT_DATE" id="O_X_DOC_SUBMIT_DATE" />
			<input type="hidden" name="O_X_DOC_SUBMIT_TIME" id="O_X_DOC_SUBMIT_TIME" />
			<input type="hidden" name="O_BID_BEGIN_DATE" id="O_BID_BEGIN_DATE" />
			<input type="hidden" name="O_BID_BEGIN_TIME" id="O_BID_BEGIN_TIME" />			
			<input type="hidden" name="O_BID_END_DATE" id="O_BID_END_DATE" />
			<input type="hidden" name="O_BID_END_TIME" id="O_BID_END_TIME" />			
			<input type="hidden" name="O_OPEN_DATE" id="O_OPEN_DATE" />
			<input type="hidden" name="O_OPEN_TIME" id="O_OPEN_TIME" />					
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class='title_page'>입찰시간 변경 &nbsp;</td>
				</tr>
			</table>
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
						<table width="100%" border="0" cellspacing="1" cellpadding="0"
							bgcolor="#dedede">
							<tr>
								<td width="100%">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<colgroup>
											<col width="15%" />
											<col width="35%" />
											<col width="15%" />
											<col width="35%" />
										</colgroup>
										<tr>
											<td width="18%" class="title_td">
												<div align="left">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7"
														align="absmiddle">&nbsp;&nbsp;공고번호
												</div>
											</td>
											<td width="82%" class="data_td"><%=ANN_NO%></td>
										</tr>
										<tr>
											<td colspan="4" height="1" bgcolor="#dedede"></td>
										</tr>
										<tr>
											<td class="title_td">
												<div align="left">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7"
														align="absmiddle">&nbsp;&nbsp;입찰건명
												</div>
											</td>
											<td class="data_td"><%=ANN_ITEM%></td>
										</tr>
										<tr>
											<td colspan="4" height="1" bgcolor="#dedede"></td>
										</tr>
										<tr>
											<td class="title_td">
												<div align="left">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7"
														align="absmiddle">&nbsp;&nbsp;입찰방법
												</div>
											</td>
											<td class="data_td"><%=CONT_TYPE1_TEXT_D%>&nbsp;/&nbsp;<%=CONT_TYPE2_TEXT_D%>&nbsp;/&nbsp;<%=PROM_CRIT_NAME%></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>

			<table width="98%" border="0" cellspacing="0" cellpadding="0"
				align="center">
				<tr>
					<td></td>
				</tr>
			</table>
			<br>

			<table width="100%" border="0" cellspacing="0" cellpadding="1">
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="1" cellpadding="0"
							bgcolor="#dedede">
							<tr>
								<td width="100%">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<colgroup>
											<col width="15%" />
											<col width="35%" />
											<col width="15%" />
											<col width="35%" />
										</colgroup>
										<tr>
											<td width="18%" class="title_td">
												<div align="left">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7"
														align="absmiddle">&nbsp;&nbsp;현재시간
												</div>
											</td>
											<td width="82%" class="data_td"><input type="text"
												name="server_date" readonly disabled="disabled"
												style="width: 180px;"> <input type="hidden"
												name="h_server_date" class="input_data2" readonly></td>
										</tr>								
										<tr>
											<td colspan="4" height="1" bgcolor="#dedede"></td>
										</tr>
										<tr>
											<td class="title_td" ><span>&nbsp;<img
													src="/images/blt_srch.gif" width="7" height="7"
													align="absmiddle">&nbsp;&nbsp;제출기한
											</span></td>
											<td colspan="3" class="data_td"><span>
													<s:calendar id="X_DOC_SUBMIT_DATE" default_value=""
														format="%Y/%m/%d" />일 <input type="text"
													name="X_DOC_SUBMIT_TIME" id="X_DOC_SUBMIT_TIME"
													value="" size="4" maxlength="4" class="input_re" 
													style="ime-mode: disabled"
													onKeyPress="checkNumberFormat('[0-9]');"></td>
										</tr>										
										<tr>
											<td colspan="4" height="1" bgcolor="#dedede"></td>
										</tr>
										<tr id="g1">
											<td class="title_td" id="g2"><span id="g3">&nbsp;<img
													src="/images/blt_srch.gif" width="7" height="7"
													align="absmiddle">&nbsp;&nbsp;입찰일시
											</span></td>
											<td colspan="3" id="g4" class="data_td"><span id="g5">
													<s:calendar id="BID_BEGIN_DATE" default_value=""
														format="%Y/%m/%d" />일 <input type="text"
													name="BID_BEGIN_TIME"
													id="BID_BEGIN_TIME" value="" size="4"
													maxlength="4" class="input_re" id=g9
													style="ime-mode: disabled"
													onKeyPress="checkNumberFormat('[0-9]');">
													&nbsp;&nbsp;~&nbsp;&nbsp; <s:calendar id="BID_END_DATE"
														default_value="" format="%Y/%m/%d" />일 <input type="text"
													name="BID_END_TIME"
													id="BID_END_TIME" value="" size="4"
													maxlength="4" class="input_re" id=g13
													style="ime-mode: disabled"
													onKeyPress="checkNumberFormat('[0-9]');"></td>
										</tr>
										<tr>
											<td colspan="4" height="1" bgcolor="#dedede"></td>
										</tr>
										<tr id="g14">
											<td class="title_td" id="g15"><span id="g16">&nbsp;<img
													src="/images/blt_srch.gif" width="7" height="7"
													align="absmiddle">&nbsp;&nbsp;개찰일시
											</span></td>
											<td colspan="3" id="g17" class="data_td"><span id="g18">
													<s:calendar id="OPEN_DATE" default_value=""
														format="%Y/%m/%d" />일 <input type="text"
													name="OPEN_TIME" id="OPEN_TIME"
													value="" size="4" maxlength="4" class="input_re" id=g22
													style="ime-mode: disabled"
													onKeyPress="checkNumberFormat('[0-9]');"></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>

			<table width="98%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="30" align="right">
						<TABLE cellpadding="0">
							<TR>
								<td><script language="javascript">
									btn("javascript:doConfirm();", "변 경")
								</script></td>
								<td><script language="javascript">
									btn("javascript:window.close();", "닫 기")
								</script></td>
							</TR>
						</TABLE>
					</td>
				</tr>
			</table>
		</form>
	</s:header>
</body>
</html>
<% } %>
