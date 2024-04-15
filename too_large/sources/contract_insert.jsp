<%--
	계약서 작성 ( 변경계약포함)
	박세준
 --%>

<%@page import="org.apache.commons.collections.MapUtils"%>
<!DOCTYPE html>
<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"      %>
<%@ include file="/include/sepoa_session.jsp"     %>
<%@ include file="/include/code_common.jsp"       %>
<%@ include file="/include/sepoa_scripts.jsp"     %>

<%@ taglib prefix="s" uri="/sepoa"%>

<%!private String formatNumberPrice(String num) {
		return SepoaMath.SepoaNumberType(num,
				"#,###,###,###,###,###,###,###,###.###");
	}%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);
    Config  conf    = new Configuration();
	String buttonText     = (String) text.get ( "CT_001.TXT_002" ); /* 저장 */
	String changeCtText1  = "";
	String changeCtText2  = "";
	StringBuffer sb       = new StringBuffer();
    String p_cont_no      = JSPUtil.nullToEmpty(request.getParameter("cont_no"));
	String p_cont_gl_seq  = JSPUtil.nullToRef(request.getParameter("cont_gl_seq"),"");
	String p_exec_no      = JSPUtil.nullToEmpty(request.getParameter("exec_no"));
	String p_exec_count   = JSPUtil.nullToRef(request.getParameter("exec_count"),"1");
	String p_seller_name  = JSPUtil.nullToEmpty(request.getParameter("seller_name")); 
	String p_seller_code  = JSPUtil.nullToEmpty(request.getParameter("seller_code")); 
	String p_rfq_no       = JSPUtil.nullToEmpty(request.getParameter("rfq_no")); 
	String originalDocType= JSPUtil.nullToRef  (request.getParameter("doc_type"),"IU"); 
	String p_doc_type     = JSPUtil.nullToRef  (request.getParameter("doc_type"),"IU"); 
	String p_contractPrice= JSPUtil.nullToRef  (request.getParameter("contractPrice"),"N"); //단가계약 생성여부 단가계약은(아이템을 선택하지 않고 들어올수 있다.)
    String readOnly = "readOnly";
	int exec_cnt = Integer.parseInt (p_exec_count);
	String p_cont_number = ""; 

	// "IU" 저장 & 수정(안날려줌 기본값 S셋팅) / "SS" 업체전송 // "SA" 업체인증 // "BA" 구매사인증 // "BCC" 구매사 변경계약생성 // "BCU" 변경계약수정
	String p_view         = JSPUtil.nullToEmpty(request.getParameter("view")).toUpperCase (  ); //VI가 넘어오면 VIEW 
	
	if("VI".equals ( p_view ) && !"1".equals ( p_cont_gl_seq ) && !"SS".equals ( originalDocType ) && !"SA".equals ( originalDocType ) && !"BA".equals ( originalDocType )){
	    p_doc_type = "BCU";
	}
	
	if( "SS".equals ( originalDocType ) ) {
	    buttonText = (String) text.get ( "CT_001.TXT_003" );/* "업체전송"; */
	} else if ( "SA".equals ( originalDocType ) ){
	    buttonText = (String) text.get ( "CT_001.TXT_004" );/* "업체인증"; */
	} else if ( "BA".equals ( originalDocType ) ){
	    buttonText = (String) text.get ( "CT_001.TXT_005" );/* "한화인증"; */
	} else if ( "BCC".equals ( originalDocType ) ){
	    buttonText = (String) text.get ( "CT_001.TXT_006" );/* "변경계약생성"; */
	    changeCtText1  = (String) text.get ( "CT_001.TXT_009" );/* "[ 당 초 ]  "; */
	    changeCtText2  = (String) text.get ( "CT_001.TXT_010" );/* "[ 변 경 ]  "; */
	} else if ( "BCU".equals ( originalDocType ) ){
	    buttonText = (String) text.get ( "CT_001.TXT_007" );/* "변경계약수정"; */
	    changeCtText1  = (String) text.get ( "CT_001.TXT_009" );/* "[ 당 초 ]  "; */
	    changeCtText2  = (String) text.get ( "CT_001.TXT_010" );/* "[ 변 경 ]  "; */
	} else if ( !"".equals ( p_cont_no ) ) {
	    buttonText = (String) text.get ( "CT_001.TXT_008" );/* "수정"; */
	}
	boolean migrationFlag = false;
	
	
	
	if(p_cont_gl_seq.equals ( "" )){
		p_cont_gl_seq = p_exec_count;
	}
	
	if(!"BCC".equals ( originalDocType ) ){		 
	
		if( exec_cnt > 1){      // && "".equals ( p_rfq_no )){
		    buttonText = (String) text.get ( "CT_001.TXT_006" );/* "변경계약생성"; */
		    p_cont_gl_seq = p_exec_count;
		    p_doc_type = "BCU";
		}
		
		if("".equals ( p_rfq_no ) && Integer.parseInt ( p_cont_gl_seq ) < 3){ //RFQ번호가 없고 계약차수가 3차 미만이라면. ( 마이그레이션 데이타 변경계약건으로 인해 추가.)
			migrationFlag = true;
		}
	}
	
	HashMap headerData = new HashMap();
	headerData.put( "cont_number"     , p_cont_no      );
	headerData.put( "cont_gl_seq"     , p_cont_gl_seq  );
	headerData.put( "company_code"    , info.getSession ( "COMPANY_CODE" ) );
	headerData.put( "exec_no"         , p_exec_no        );
	headerData.put( "exec_count"      , p_exec_count     );
	headerData.put( "seller_code"     , p_seller_code  );
 	headerData.put( "doc_type"        , p_doc_type     );
	headerData.put( "rfq_number"      , p_rfq_no       );
	headerData.put( "contractPrice"   , p_contractPrice);

	//변경계약의 생성의 경우 첫번재쿼리에서 다음차수PO 두버째쿼리에서 전차수CT
	//변경계약의 수정의 경우 첫번째쿼리에서 현재차수CT 두번째 쿠리에서 전차수CT
	if("BCC".equals ( p_doc_type )){//변경계약생성의 경우
		headerData.put( "cont_gl_seq"     , String.valueOf ( Integer.parseInt ( p_cont_gl_seq ) + 1 ) ); //변경된 PO차수에대해 데이타를 가져온다. 계약 2차수면 3차수 PO데이타를 가져온다.
	}
	//'BCU' 변견계약 수정의 경우는 계약차수 그대로 데이타를 가져오면 되기때문에 따로 처리할 내용이 없다.
	
	Object[] obj = { headerData };
	
	SepoaOut value = ServiceConnector.doService(info, "CT_001", "CONNECTION" , "getContractDeaitl" , obj);
	
	HashMap<String, String> headerHm = new HashMap<String, String>();

	if(value.flag){
		SepoaFormater headerSf = new SepoaFormater(value.result[0]); //헤더데이타 조회해 오 내용 
		if(headerSf.getRowCount (  ) < 1){
		   	out.println("<script>");
		   	out.println("alert('"+ (String) text.get ( "CT_001.TXT_011" ) +"')");/* 계약대상건이 없습니다. (구매관리 >> 계약변경신청이 완료되었는지 확인해주세요.)  */
		   	out.println("window.close();");
		   	out.println("</script>");
		}else{
		    for (int i = 0 ; i < headerSf.getColumnCount () ; i++ ){ //조회해온 내용을 포문을 돌려 headerHm(해쉬맵)에 저장한다
		        headerHm.put ( headerSf.getColumnNames ()[i] , headerSf.getValue ( headerSf.getColumnNames ()[i] , 0 ).trim (  ) );
		    }
		    p_cont_number = MapUtils.getString ( headerHm , "CONT_NUMBER" , "");
		}
	}else{
        //out.println("<script>");
        //out.println("alert('"+ (String) text.get ( "CT_001.TXT_011" ) +"')");/* 계약대상건이 없습니다. (구매관리 >> 계약변경신청이 완료되었는지 확인해주세요.)  */
        //out.println("window.close();");
        //out.println("</script>");
	}
	
	exec_cnt = Integer.parseInt (MapUtils.getString ( headerHm , "EXEC_COUNT" , "1"));
	p_exec_count = MapUtils.getString ( headerHm , "EXEC_COUNT" , "1");
	p_cont_gl_seq = MapUtils.getString ( headerHm , "CONT_GL_SEQ" , "1");
	
	if(!"BCC".equals ( originalDocType )){
		//exec_cnt = Integer.parseInt (MapUtils.getString ( headerHm , "EXEC_COUNT" , "1"));
		//p_exec_count = MapUtils.getString ( headerHm , "EXEC_COUNT" , "1");
		//p_cont_gl_seq = MapUtils.getString ( headerHm , "CONT_GL_SEQ" , "1");
		if( exec_cnt > 1 ){         // && "".equals ( p_rfq_no )){			
		    if(!p_cont_number.equals ( "" ) && p_exec_count.equals(p_cont_gl_seq)){          // 계약번호가 있을시 PO차수와 계약차수가 다르면 계약 생성
		    	p_doc_type = "BCU";
	    }else{
		    	p_doc_type = "BCC";
		    	p_cont_gl_seq = p_exec_count;
		    }
		}
		
		if("".equals ( p_rfq_no ) && Integer.parseInt ( p_cont_gl_seq ) < 3){ //RFQ번호가 없고 계약차수가 3차 미만이라면. ( 마이그레이션 데이타 변경계약건으로 인해 추가.)
			migrationFlag = true;
		}
	}
		
	

	if("BCC".equals ( p_doc_type )){//변경계약 생성의 경우
		headerData.put( "cont_gl_seq"     , p_cont_gl_seq );
		headerData.put( "doc_type"        , ""            ); //두번째쿼리 가져올땐 계약테이블에서 가져와야하기 때문에 doc_type의 BCC값을 빈값으로 처리한다(서비스에서 BCC로 분기되어있음.)
	}

	if("BCU".equals ( p_doc_type )){//변경계약 수정의 경우 전 차수데이타를 CT에서 가지고온다.
		headerData.put( "cont_gl_seq"     , String.valueOf ( Integer.parseInt ( p_cont_gl_seq ) - 1 ) );
		if(migrationFlag){ //RFQ번호가 없고 계약차수가 3차 미만이라면. ( 마이그레이션 데이타 변경계약건으로 인해 추가.)
			headerData.put( "cont_gl_seq"     , String.valueOf ( Integer.parseInt ( p_cont_gl_seq ) ) );
		}
	}
	HashMap<String, String> headerHmChange = new HashMap<String, String>();
	SepoaOut valueChange = null;
	if("BCC".equals ( p_doc_type ) || "BCU".equals ( p_doc_type )){//변경계약의경우 기본 계약데이타 조회 회 다음차수 PO의 데이타를 불러온다.
		valueChange = ServiceConnector.doService(info, "CT_001", "CONNECTION" , "getContractDeaitl" , obj);
		if(valueChange.flag){
			SepoaFormater headerSf = new SepoaFormater(valueChange.result[0]); //헤더데이타 조회해 오 내용 
			if(headerSf.getRowCount (  ) < 1){
			   	out.println("<script>");
			   	out.println("alert('"+ (String) text.get ( "CT_001.TXT_011" ) +"')");/* 계약대상건이 없습니다. (구매관리 >> 계약변경신청이 완료되었는지 확인해주세요.)  */
			   	out.println("window.close();");
			   	out.println("</script>");
			}else{
			    for (int i = 0 ; i < headerSf.getColumnCount () ; i++ ){ //조회해온 내용을 포문을 돌려 headerHm(해쉬맵)에 저장한다
			        headerHmChange.put ( headerSf.getColumnNames ()[i] , headerSf.getValue ( headerSf.getColumnNames ()[i] , 0 ).trim (  ) );
			    }
			}
		}else{
		   	out.println("<script>");
		   	out.println("alert('"+ (String) text.get ( "CT_001.TXT_011" ) +"')");/* 계약대상건이 없습니다. (구매관리 >> 계약변경신청이 완료되었는지 확인해주세요.)  */
		   	out.println("window.close();");
		   	out.println("</script>");
		}
	}
	thisWindowPopupFlag = "true";
	thisWindowPopupScreenName = "계약서";
	
    String contAmtReadOnly = "readonly";
    
	 if(MapUtils.getString ( headerHm , "TAXATION_AMT" , "").equals ( "0.00" )){ /* Migration 건의 경우 계약금액 수정가능  */
		 contAmtReadOnly = "";
	 }
     //단가계약서 작성일경우에는 공급가액을 입력할수 있도록 한다.

     if("Y".equals ( p_contractPrice ) ) {
         contAmtReadOnly = "";
     } 
	 
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%><!-- CSS  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"%><!-- AJAX SELECTBOX -->
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>
<% if("S".equals ( info.getSession ( "USER_TYPE" ) )){ %>
<script language="javascript" src="../include/attestation/TSToolkitConfig.js"></script>
<script language="javascript" src="../include/attestation/TSToolkitObject.js"></script>
<% } %>
<script language="javascript" type="text/javascript">
	<%-- 계약프로세스 자바스크립트 부분  시작!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  시작!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  시작!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  시작!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  시작!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  시작!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  시작!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  시작!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  시작!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  시작!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  시작!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>

	<%--모든문자치환--%>
	String.prototype;//.replaceAll = replaceAll;
	function replaceAll(strValue1, strValue2) {
	    var strTemp = this;
	    strTemp = strTemp.replace(new RegExp(strValue1, "g"), strValue2);
	    return strTemp;
	}
	
	function initAjax(){
		// 계약서종류
		// 1 / 공사계약서
		// 2 / 물품공급계약서
		// 3 / 용역도급계약서
		// 4 / 유지보수계약서
		// 5 / 단가계약서(일반/용역)
		// 6 / 물품공급계약서(단가계약)
		// 7 / 기타계약서
		/* doRequestUsingPOST( 'SL5001', 'M125' ,'cont_type', '' ); */
		// SL0148
		doRequestUsingPOST( 'SL0147', '' ,'attach_no', '<%=MapUtils.getString ( headerHm , "ATTACH_NO" , "" ) %>' );
		contTypeChange(); //계약타입별루 화면 조정
		onKeyUpChangeAmt(document.getElementById("cont_amt").id);    //금액 한글처리
		onKeyUpChangeAmt(document.getElementById("cont_ttl_amt").id);//금액 한글처리
		onKeyUpChangeAmt(document.getElementById("cont_vat").id);    //금액 한글처리
		paySpecCheck(document.getElementById("pay_terms_spec_flag"));//지불조건상세 체크처리.
		if("<%=p_view%>" == "VI"){ //p_view 일경우 View용화면으로 전환
			viewAjax();
		}

		<%
			String attachSelect1 = "";
			String attachSelect2 = "";
			if("".equals ( MapUtils.getString ( headerHm , "ATTACH_NO2" , MapUtils.getString ( headerHmChange , "ATTACH_NO2" , "" ) ) )){
			    out.println("attachSelect1()");
			    attachSelect1 = " checked='checked'";
			}else{
			    out.println("attachSelect2()");
			    attachSelect2 = " checked='checked'";
			}
		%>
		
		select_col = 'attach_no2';
		document.forms[0].only_attach.value = "attach_no2";
        setAttach1();
		select_col = 'attach_no3';
        document.forms[0].only_attach.value = "attach_no3";
        setAttach1();
		select_col = 'attach_no4';
        document.forms[0].only_attach.value = "attach_no4";
        setAttach1();
	}
	
	function viewAjax(){//Span에 있는 입력박스들의 값을 뽑아온뒤 Input박스와 값을 대체 시킨다. (InputBox >> Text) 뷰처리할 Input박스는 Span으로 감싸면 뷰적용완료!!!
		var viewSpan = document.getElementsByTagName("span");
		var childObj;
		
		for(var i = 0 ; i < viewSpan.length ; i++){
			childObj = viewSpan[i].firstChild;
			try{
				if(viewSpan[i].id == "viewSpan"){
					if(childObj.tagName == "IMG"){
                        viewSpan[i].innerHTML = "";
                    }else if(childObj.tagName == "SELECT"){
                        viewSpan[i].innerHTML = childObj.options[childObj.selectedIndex].text;
                    }else{
                        if(childObj.type == "checkbox"){
                            if(childObj.checked){
                                viewSpan[i].innerHTML = "[선택]";
                            }else{
                                viewSpan[i].innerHTML = "[미선택]";
                            }
                        }else{
                            if(childObj.value != null && childObj.value != "" && typeof childObj.value != "undefined"){
                                viewSpan[i].innerHTML = (childObj.value).replaceAll("\n","<br>");
                            }
                        }
                    }
				}
			}catch(e){alert(e.message);}
		}
		
		var inputObj  = document.getElementsByTagName("input");
		var selectObj = document.getElementsByTagName("select");
		
		for(var i = 0 ; i < inputObj.length ; i++){
			if(inputObj[i].id == "resident_no" || inputObj[i].id == "docTypeFlagMessage"){ //보증보험에 관한걸로 뷰화면에서도 쓸 수 있어야함
				//제외항목추가부분
			}else{
				inputObj[i].readOnly = "readonly"; //일반input이면 Readonly 아니면 Disable
			}
			
			if(inputObj[i].type == "checkbox"){
				inputObj[i].disabled = "disabled";
			}
			
		}
		for(var i = 0 ; i < selectObj.length ; i++){
			selectObj[i].disabled = "disabled";
		}
	}
	
	function contTypeChange(){
		var contType      = document.forms[0].cont_type.value;
		var contTypeName  = document.forms[0].cont_type.options[document.forms[0].cont_type.selectedIndex].text;

		if("<%=p_doc_type%>" == "BCC" || "<%=p_doc_type%>" == "BCU"){ //변경계약서의 경우
			contTypeName = contTypeName;//.replaceAll("<%=text.get ( "CT_001.TXT_012" ) %><%-- 계약서 --%>"," <%=text.get ( "CT_001.TXT_013" ) %><%-- 변경 계약서 --%>  ");
		}
		
		contTypeScreenChange(contType,contTypeName);
	}
	
	function clearSelectBox(selectBox){
		if (null == selectBox || null == selectBox.options) {
			return;
		}
		var length = selectBox.options.length;
		for (var index=0;index<length ;index++){ selectBox.options.remove(0); }
	}
	
	function contTypeScreenChange(contTypeSelect, contTypeName){ //계약타입별루 화면변환
		var cts = contTypeSelect;
		var ctsName = "";
		
		var trObj = document.getElementsByTagName("tr");
		for ( var i = 0 ; i < trObj.length ; i++){ //TR에 ID에계약타입의 숫자가 있다면 Display None처리한다.
			var trId = trObj[i].id;
			if(trId != ""){
				if(trId.indexOf(contTypeSelect) == -1){
					trObj[i].style.display = "";
				}else{
					trObj[i].style.display = "none";
				}
			}
		}
		// 공통처리부분
		document.getElementById("contTypeTd").innerHTML = contTypeName;
		clearSelectBox(document.getElementById("attach_no1"));
		doRequestUsingPOST( 'SL0148', contTypeSelect ,'attach_no1', '<%=MapUtils.getString ( headerHm , "ATTACH_NO1" , "" ) %>' );
		// 공통처리부분 끝
		
		// 1 / 공사계약서
		if ( contTypeSelect == "1" ) {

			document.getElementById("subjectTd") .innerHTML = "<%=text.get ( "CT_001.TXT_014" ) %><%-- 공사명 --%>"        ; // 계약명 셋팅
			document.getElementById("locationTd").innerHTML = "<%=text.get ( "CT_001.TXT_015" ) %><%-- 공사장소 --%>"      ; // 장소셋팅

		// 2 / 물품공급계약서
		} else if ( contTypeSelect == "2" ) {

			document.getElementById("subjectTd") .innerHTML = "<%=text.get ( "CT_001.TXT_016" ) %><%-- 공사장소 --%>"    ; // 계약명 셋팅
			document.getElementById("locationTd").innerHTML = "<%=text.get ( "CT_001.TXT_017" ) %><%-- 납품장소 --%>"      ; // 장소셋팅

		// 3 / 용역도급계약서
		} else if ( contTypeSelect == "3" ) {

			document.getElementById("subjectTd") .innerHTML = "<%=text.get ( "CT_001.TXT_018" ) %><%-- 용역명 --%>"        ; // 계약명 셋팅
			document.getElementById("locationTd").innerHTML = "<%=text.get ( "CT_001.TXT_019" ) %><%-- 용역장소 --%>"      ; // 장소셋팅

		// 4 / 유지보수계약서
		} else if ( contTypeSelect == "4" ) {
			
			document.getElementById("subjectTd") .innerHTML = "<%=text.get ( "CT_001.TXT_020" ) %><%-- 계약명 --%>"        ; // 계약명 셋팅
			document.getElementById("locationTd").innerHTML = "<%=text.get ( "CT_001.TXT_021" ) %><%-- 유지보수장소 --%>"  ; // 장소셋팅

		// 5 / 단가계약서(일반/용역)
		} else if ( contTypeSelect == "5" ) {
			
			document.getElementById("subjectTd") .innerHTML = "<%=text.get ( "CT_001.TXT_022" ) %><%-- 계약명 --%>"        ; // 계약명 셋팅
			document.getElementById("locationTd").innerHTML = "<%=text.get ( "CT_001.TXT_023" ) %><%-- 공사(용역)장소 --%>"; // 장소셋팅

		// 6 / 물품공급계약서(단가계약)
		} else if ( contTypeSelect == "6" ) {
			
			document.getElementById("subjectTd") .innerHTML = "<%=text.get ( "CT_001.TXT_024" ) %><%-- 계약명 --%>"        ; // 계약명 셋팅
			document.getElementById("locationTd").innerHTML = "<%=text.get ( "CT_001.TXT_025" ) %><%-- 납품장소 --%>"      ; // 장소셋팅

		// 7 / 기타계약서
		} else if ( contTypeSelect == "7" ) {
			
			document.getElementById("subjectTd") .innerHTML = "<%=text.get ( "CT_001.TXT_026" ) %><%-- 계약명 --%>"        ; // 계약명 셋팅
			document.getElementById("locationTd").innerHTML = "<%=text.get ( "CT_001.TXT_027" ) %><%-- 납품장소 --%>"      ; // 장소셋팅
			
		}
	}
	
	//지불조건 상세 체크박스 체크시와 미체크시
	function paySpecCheck(chObj){
		var pay_terms_spec_flag = chObj.checked;
		if(pay_terms_spec_flag){ //상세체크박스 체크가 True일 경우 
			document.getElementById(LRTrim("pre_ins_percent_text")).value = "<%=text.get ( "CT_001.TXT_028" ) %><%-- 선급금 전액(100%)의 보증보험증권(단,선급금이 없는 경우는 제외) --%>";
			document.getElementById(LRTrim("pre_ins_percent_text")).readOnly = "readonly";
			document.getElementById(LRTrim("first_amt_ratio     ")).readOnly = "";
			document.getElementById(LRTrim("first_amt_time      ")).readOnly = "";
			document.getElementById(LRTrim("second_amt_ratio_01 ")).readOnly = "";
			document.getElementById(LRTrim("second_amt_time_01  ")).readOnly = "";
			document.getElementById(LRTrim("third_amt_ratio     ")).readOnly = "";
			document.getElementById(LRTrim("third_amt_time      ")).readOnly = "";
		}else{
			document.getElementById(LRTrim("pre_ins_percent_text")).readOnly = "readonly";
			document.getElementById(LRTrim("first_amt_ratio     ")).readOnly = "readonly";
			document.getElementById(LRTrim("first_amt_time      ")).readOnly = "readonly";
			document.getElementById(LRTrim("second_amt_ratio_01 ")).readOnly = "readonly";
			document.getElementById(LRTrim("second_amt_time_01  ")).readOnly = "readonly";
			document.getElementById(LRTrim("third_amt_ratio     ")).readOnly = "readonly";
			document.getElementById(LRTrim("third_amt_time      ")).readOnly = "readonly";
			
			document.getElementById(LRTrim("pre_ins_percent_text")).value = "";
			document.getElementById(LRTrim("first_amt_ratio     ")).value = "";
			document.getElementById(LRTrim("first_amt_time      ")).value = "";
			document.getElementById(LRTrim("second_amt_ratio_01 ")).value = "";
			document.getElementById(LRTrim("second_amt_time_01  ")).value = "";
			document.getElementById(LRTrim("third_amt_ratio     ")).value = "";
			document.getElementById(LRTrim("third_amt_time      ")).value = "";
		}
	}
	
	//숫자 콤마작업 및 금액 한글로 표기
	function onKeyUpChangeAmt(objId){
		var originalAmt     = document.getElementById(objId).value;
		
		// 오리지날 금액이 0원일경우 0으로 셋팅 ( 0000000 입력방지 )
		if(new Number(del_comma(originalAmt)) == 0){ 
			originalAmt = "0";
		}
		
		var commaAmt        = Comma(del_comma(originalAmt));
		var formatAmtText   = setAmtFromNumberToKorea(del_comma(originalAmt),23);
		
		// 0원일경우에는 영원으로 텍스트에 셋팅
		if(commaAmt == "0"){ 
			formatAmtText = "<%=text.get ( "CT_001.TXT_029" ) %><%-- 영원 --%>";
		}
		
		document.getElementById(objId).value = commaAmt;
		try{
			document.getElementById(objId+"_text").value = formatAmtText;
		}catch(e){
			// 텍스트로 셋팅안하는 Input 박스도 있기때문에 Catch로 무시
		}
	}
	
	//계약금액 부가세 자동계산
	function onKeyUPContAmtCal(objId){

		var cont_ttl_amt = new Number(del_comma(document.forms[0].cont_ttl_amt.value));
		var cont_amt     = new Number(del_comma(document.forms[0].cont_amt    .value));
		var cont_vat     = new Number(del_comma(document.forms[0].cont_vat    .value));
		
		var temp_cont_ttl_amt = 0;
		var temp_cont_amt     = 0;
		var temp_cont_vat     = 0;

		if(objId == "cont_ttl_amt"){
			temp_cont_vat = cont_ttl_amt - cont_amt;
			document.forms[0].cont_vat    .value = Comma(temp_cont_vat + "");
			onKeyUpChangeAmt(document.getElementById("cont_vat").id);
		}else if(objId == "cont_vat"){
			temp_cont_ttl_amt = cont_amt + cont_vat;
			document.forms[0].cont_ttl_amt.value = Comma(temp_cont_ttl_amt + "");
			onKeyUpChangeAmt(document.getElementById("cont_ttl_amt").id);
		}else if(objId == "cont_amt"){
			temp_cont_ttl_amt = cont_amt + cont_vat;
			document.forms[0].cont_ttl_amt.value = Comma(temp_cont_ttl_amt + "");
			onKeyUpChangeAmt(document.getElementById("cont_ttl_amt").id);
		}
		if("<%=p_doc_type %>" == "BCC" || "<%=p_doc_type %>" == "BCU"){
			cont_ttl_amt = new Number(del_comma(document.forms[0].cont_ttl_amt.value)); 
			cont_amt     = new Number(del_comma(document.forms[0].cont_amt    .value)); 
			cont_vat     = new Number(del_comma(document.forms[0].cont_vat    .value)); 
			
			var cont_ttl_amt_ori = new Number(del_comma(document.forms[0].cont_ttl_amt_ori.value));
			var cont_amt_ori     = new Number(del_comma(document.forms[0].cont_amt_ori    .value));
			var cont_vat_ori     = new Number(del_comma(document.forms[0].cont_vat_ori    .value));
			
			document.forms[0].cont_ttl_cal_amt.value  = Comma(cont_ttl_amt_ori - cont_ttl_amt  + "");
			document.forms[0].cont_cal_amt    .value  = Comma(cont_amt_ori     - cont_amt      + "");
			document.forms[0].cont_cal_vat    .value  = Comma(cont_vat_ori     - cont_vat      + "");
		}
	}

	var select_col = '';
	function attachFile(attach_no, module, type) {
		var ATTACH_VALUE = LRTrim(attach_no);
		if("" == ATTACH_VALUE) {
			FileAttach(module,'','');
		} else {
			FileAttachChange(module, ATTACH_VALUE);
		}
		select_col = type;
	}
	function setAttach(attach_key, arrAttrach, attach_count) {

	    var attachfilename  = arrAttrach + "";
	    var result 			= "";

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

		if( select_col == 'attach_no2'){
			if(attach_count == 0){
				document.forms[0].attach_no2.value     	= "";
				document.forms[0].attach_name2.value 	= "";
				document.getElementById("attach_no2_text").innerHTML = "";
			}else{
				document.forms[0].attach_no2.value     	= attach_key;
				document.forms[0].attach_name2.value 	= src_file_name;
				document.forms[0].only_attach.value = "attach_no2";
                setAttach1();
			}

		}else if( select_col == 'attach_no3'){
			if(attach_count == 0){
				document.forms[0].attach_no3.value     	= "";
				document.forms[0].attach_name3.value 	= "";
				document.getElementById("attach_no3_text").innerHTML = "";
			}else{
				document.forms[0].attach_no3.value     	= attach_key;
				document.forms[0].attach_name3.value 	= src_file_name;
				document.forms[0].only_attach.value = "attach_no3";
                setAttach1();
			}

		}else if( select_col == 'attach_no4'){
			if(attach_count == 0){
				document.forms[0].attach_cnt4.value     = "";
				document.forms[0].attach_name4.value 	= "";
				document.getElementById("attach_no4_text").innerHTML = "";
			}else{
				document.forms[0].attach_no4.value     	= attach_key;
				document.forms[0].attach_name4.value 	= src_file_name;
				document.forms[0].only_attach.value = "attach_no4";
                setAttach1();
			}
		}
	}
	
	function setAttach1() {
        var nickName        = "SIF_001";
        var conType         = "TRANSACTION";
        var methodName      = "getFileNames";
        var SepoaOut        = doServiceAjax( nickName, conType, methodName );
        
        if( SepoaOut.status == "1" ) { // 성공
            //alert("성공적으로 처리 하였습니다.");
            var test = (SepoaOut.result[0]).split("<%=conf.getString( "sepoa.separator.line" )%>");
            var test1 = test[1].split("<%=conf.getString( "sepoa.separator.field" )%>");
            
            setAttach2(test1[0]);
            
        } else { // 실패
<%--             alert("<%=text.get("MESSAGE.1002")%>"); --%>
        }
    }

    function setAttach2(result){
        var text  = result.split("||");
        var text1 = "";
    
        for( var i = 0; i < text.length ; i++ ){
            
            text1  += text[i] + "<br/>";
        }
        
        if( select_col == 'attach_no2'){
            document.getElementById("attach_no2_text").innerHTML  = text1;
        }else if( select_col == 'attach_no3'){
            document.getElementById("attach_no3_text").innerHTML = text1;
        }else if( select_col == 'attach_no4'){
            document.getElementById("attach_no4_text").innerHTML = text1;
        }
    }
	
	
	function attachFileDownload(attachNoInput){
		document.downloadForm.doc_no.value = document.getElementById(attachNoInput).value;
		document.downloadForm.submit();
	}
	
	function doInsert(send){
		document.forms[0].doc_type_send.value = send;
		if("<%=originalDocType%>" == "SA"){
			var signMsg = "";
			var nRet    = "";
			var certdn  = "";
			var storage = "";
			if("<%=MapUtils.getString ( headerHm , "SIGN_VALUE" , "" ) %>" == ""){
				//alert("업체등록 화면에서 인증서를 등록해주세요.");
				//return;
			}

			if("<%=MapUtils.getString ( headerHm , "SIGN_NAME" , "" ).trim (  ) %>" == ""){
				//alert("업체등록 화면에서 인증서를 등록해주세요.");
				//return;
			}
			
			// 모든 Condition 설정. POLICIES >> POLICIES1로 셋팅시 법인용 인증서만 보인다.
			nRet = TSToolkit.SetConfig("", CA_LDAP_INFO, CTL_INFO, POLICIES1, INC_CERT_SIGN, INC_SIGN_TIME_SIGN, INC_CRL_SIGN, INC_CONTENT_SIGN, USING_CRL_CHECK, USING_ARL_CHECK); 
			if (nRet > 0) {	alert(nRet + " : " + TSToolkit.GetErrorMessage());return;}

			// 사용자가 자신의 인증서를 선택. 
			nRet = TSToolkit.SelectCertificate(STORAGE_TYPE, 0, "");
			/* if (nRet > 0) { alert("SelectCertificate : " + TSToolkit.GetErrorMessage()); return; } */
			nRet = TSToolkit.GetCertificate(CERT_TYPE_SIGN, DATA_TYPE_PEM);
			/* if (nRet > 0) { alert("GetCertificate : " + TSToolkit.GetErrorMessage());return; } */
			<%-- 
			var cert;
			cert = TSToolkit.OutData;
			nRet = TSToolkit.CertificateValidation(cert);
			if (nRet > 0) {
				if (nRet == 141) {
					var revokedTime;
					revokedTime = TSToolkit.OutData;
					alert("선택한 인증서는 폐기 및 손상된 인증서 입니다. \n인증센터에서 인증서를 발급 받으십시오.");
					return;
				}
			}
			
			nRet = TSToolkit.VerifyVID("<%=MapUtils.getString ( headerHm , "SELLER_COMPANY_IRS_NO" , MapUtils.getString ( headerHmChange , "SELLER_COMPANY_IRS_NO" , "" ) ) %>");//.replaceAll ( "-" , "" ).trim (  )
			if (nRet > 0)
			{
				alert(nRet + " : " + TSToolkit.GetErrorMessage());
				return false;
			}
			 
			if (TSToolkit.OutData != "true")
			{
				//alert("발급된 인증서의 사업자번호와 계약서의 사업자번호가 다릅니다.");
				//return false;
			}
			
			//고유한 인증서 값을 가져 온다..
			var str;
			TSToolkit.GetCertificatePropertyFromID(cert, CERT_ATTR_SUBJECT_KEY_ID); 
			str = TSToolkit.OutData; 
			var str_value = str;
			document.form.sign_key.value   = str;
			nRet = TSToolkit.GetCertificate(CERT_TYPE_SIGN, DATA_TYPE_PEM);
			if (nRet > 0) {	alert("GetCertificate : " + TSToolkit.GetErrorMessage());return false;	}
			var cert;
			cert = TSToolkit.OutData;
			TSToolkit.GetCertificatePropertyFromID(cert, CERT_ATTR_CRLDP);
			str = TSToolkit.OutData;
			var signValue = str.substring(str.indexOf(",o=")+3, str.indexOf(",c="));
			document.form.sign_value.value   = signValue; --%>
		}
		
        var nickName        = "CT_001";
        var conType         = "TRANSACTION";
        var methodName      = "setCTInsert";
        var SepoaOut        = doServiceAjax( nickName, conType, methodName );
        
     	if(("<%=MapUtils.getString ( headerHm , "CONT_INS_NO", "" ).trim (  )%>" == ""
     			|| "<%=MapUtils.getString ( headerHm , "ATTACH_CONT_INS_NO", "" ).trim (  )%>" == "" )
     			&& "BA" == "<%=originalDocType%>"){
     			//보증보험 연계시 주석해제 ( PSJSJPSJ=YO << 검색어)
     			//alert("업체에서 계약이행증권을 등록하지 않아 전자서명(계약완료)를 할 수 없습니다.");
     			//return;
     	}
        
        if( SepoaOut.status == "1" ) { // 성공
	    	alert(SepoaOut.message);
        	window.close();
        	opener.doQuery();
        	
        	//if( SepoaOut.result[0] != "" )
        		//document.forms[0].product_sales_amt.value	= add_comma(SepoaOut.result[0],0);
        } else {
        	if(SepoaOut.message == "null"){
    	    	alert("<%=text.get ( "CT_001.TXT_030" ) %><%-- 관리자에게 문의 부탁드립니다. --%>");
        	}else{
    	    	alert(SepoaOut.message);
        	}
        }
	}

	function attachSelect1(){
		document.forms[0].attach_no2.value='';
		document.forms[0].attach_name2.value='';
		document.forms[0].attach_no1.disabled='';
		document.getElementById('attImg2').style.display='none';
		document.getElementById('attach_no2_text').style.display='none';
	}
	function attachSelect2(){
		document.forms[0].attach_no1.value='';
		document.forms[0].attach_no1.disabled='disabled';
		document.getElementById('attImg2').style.display='';
		document.getElementById('attach_no2_text').style.display='';
	}
	
	function getSellerCode() {
        var arrayValue = new Array("<%=info.getSession("COMPANY_CODE")%>","","");
        PopupCommonPost("SP0087_1","SP0087_1_getCode",arrayValue);
    }
    function SP0087_1_getCode( 
    							 seller_code    
                        		,seller_company_name             
                        		,seller_company_irs_no   
                        		,seller_company_ceo_name 
                        		,seller_company_zip_code1
                        		,seller_company_zip_code2
                        		,seller_company_addr     
                        		,seller_company_addr2    
                            ) {
    	document.forms[0].seller_code             .value = seller_code             ;
    	document.forms[0].seller_company_name     .value = seller_company_name     ; 
    	document.forms[0].seller_company_irs_no   .value = seller_company_irs_no   ;
    	document.forms[0].seller_company_ceo_name .value = seller_company_ceo_name ;
    	document.forms[0].seller_company_zip_code1.value = seller_company_zip_code1;
    	document.forms[0].seller_company_zip_code2.value = seller_company_zip_code2;
    	document.forms[0].seller_company_addr     .value = seller_company_addr     ;
    	document.forms[0].seller_company_addr2    .value = seller_company_addr2    ;
    }
	<%-- 계약프로세스 자바스크립트 부분  끝!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  끝!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  끝!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  끝!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  끝!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  끝!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  끝!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  끝!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  끝!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  끝!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
	<%-- 계약프로세스 자바스크립트 부분  끝!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--%>
</script>
</head>
<%@ include file="/include/sepoa_milestone.jsp"%>
<body leftmargin="15" topmargin="6" onload="initAjax();">
<s:header popup="true">
<form name="form">  
<input type="hidden" name="only_attach" id="only_attach" value="">
<input type="hidden" id="contractPrice" name="contractPrice" class="inputsubmit" value="<%=p_contractPrice%>">
<input type="hidden" id="doc_type"      name="doc_type"      class="inputsubmit" value="<%=originalDocType%>">
<input type="hidden" id="doc_type_send" name="doc_type_send" class="inputsubmit" value="">
<input type="hidden" id="cont_number"   name="cont_number"   class="inputsubmit" value="<%=MapUtils.getString ( headerHm , "CONT_NUMBER"  , MapUtils.getString ( headerHmChange , "CONT_NUMBER"  , "" ) )%>">
<input type="hidden" id="cont_gl_seq"   name="cont_gl_seq"   class="inputsubmit" value="<%=MapUtils.getString ( headerHm , "CONT_GL_SEQ"  , MapUtils.getString ( headerHmChange , "CONT_GL_SEQ"  , "" ) )%>">
<input type="hidden" id="EXEC_COUNT"      name="EXEC_COUNT"      class="inputsubmit" value="<%=MapUtils.getString ( headerHm , "EXEC_COUNT"     , MapUtils.getString ( headerHmChange , "EXEC_COUNT"     , "" ) )%>">

<input type="hidden" id="rfq_number"    name="rfq_number"    class="inputsubmit" value="<%=p_rfq_no%>">
<input type="hidden" id="sign_value" name="sign_value" class="inputsubmit" value="<%=MapUtils.getString ( headerHm , "SIGN_NAME" , "" )%>">
<input type="hidden" id="sign_key"   name="sign_key"   class="inputsubmit" value="<%=MapUtils.getString ( headerHm , "SIGN_KEY"  , "" )%>">
<div class="inputsubmit" style="border: 0px;"><%=text.get ( "CT_001.TXT_031" ) %><%-- ◆ 계약서정보 --%></div>
<div style="width: 100%;">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="100%" valign="top"/>
	</tr>
	<tr>
		<td>
			<table width="100%" height="3" border="0" cellspacing="0" cellpadding="0" bgcolor="#629DD9"><tr><td></td></tr></table>
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<colgroup>
					<col width="20%"/>
					<col width="80%"/>
				</colgroup>
				<tr>
					<td class="title_td"><%=text.get ( "CT_001.TXT_032" ) %><%-- 계약서종류 --%></td>
					<td class="data_td_input">
						<span id="viewSpan"><select id="cont_type" name="cont_type" class="inputsubmit" style="width: 160px;"> //onchange="contTypeChange();"
							<%
								//페이지로딩되자마자 설정 자바스크립트를 실행시키기 위해 자바단에서 처리 (Ajax로 하면 딜레이가 있어 제대로 처리되질 않을 위험이 있어서 처리.)
							//out.println(ListBox ( request , "SL5001" , "M125" , MapUtils.getString ( headerHm , "CONT_TYPE" , MapUtils.getString ( headerHmChange , "CONT_TYPE" , "" ) ) ));
							out.println(ListBox ( request , "SL5001" , "M125" , "2" ));
							%>
						</select></span>
					</td>
				</tr>
				<tr> 
					<td class="title_td"><%=text.get ( "CT_001.TXT_033" ) %><%-- 발주번호 --%></td>
					<td class="data_td_input">
						<span id="viewSpan"><input id="exec_number" name="exec_number" class="input_empty" style="width: 90%;" readonly onfocus="this.blur();" value="<%=MapUtils.getString ( headerHm , "EXEC_NUMBER" , MapUtils.getString ( headerHmChange , "EXEC_NUMBER" , "" ) ) %>"/></span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br>
<div class="inputsubmit" style="border: 0px;"><%=text.get ( "CT_001.TXT_034" ) %><%-- ◆ 계약서 갑지 작성 --%></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<table width="100%" height="3" border="0" cellspacing="0" cellpadding="0" bgcolor="#629DD9"><tr><td></td></tr></table>
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<colgroup>
					<col width="20%"/>
					<col width="80%"/>
				</colgroup>
				<tr> 
					<td class="title_td"><%=text.get ( "CT_001.TXT_035" ) %><%-- 계약서종류 --%></td>
					<td class="data_td_input" id="contTypeTd"/>
				</tr>
				<tr> 
					<td class="title_td"><%=text.get ( "CT_001.TXT_036" ) %><%-- 계약번호 --%></td>
					<td class="data_td_input">
						<span id="viewSpan"><input type="text" id="cont_number" name="cont_number" class="input_empty_no" size="15" readonly onfocus="this.blur();" value="<%=MapUtils.getString ( headerHm , "CONT_NUMBER" , MapUtils.getString ( headerHmChange , "CONT_NUMBER" , "" ) ) %>"/></span>
						<span id="viewSpan"><input type="text" id="cont_gl_seq" name="cont_gl_seq" class="input_empty_no" size="3" readonly onfocus="this.blur();" value="<%=MapUtils.getString ( headerHm , "CONT_GL_SEQ" , MapUtils.getString ( headerHmChange , "CONT_GL_SEQ" , "" ) ) %>"/></span>
					</td>
				</tr>
				<tr id="567"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td"><%=text.get ( "CT_001.TXT_037" ) %><%-- 프로젝트명 --%></td>
					<td class="data_td_input">
						<span id="viewSpan"><input type="text" id="pj_name" name="pj_name" class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "PJ_NAME" , MapUtils.getString ( headerHmChange , "PJ_NAME" , "" ) ) %>"/></span>
					</td>
				</tr>
				<tr> 
					<td class="title_td" id="subjectTd"><%=text.get ( "CT_001.TXT_038" ) %><%-- 공사명 --%></td>
					<td class="data_td_input">
						<span id="viewSpan"><input id="subject" name="subject" class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "SUBJECT" , MapUtils.getString ( headerHmChange , "SUBJECT" , "" ) ) %>"/></span>
					</td>
				</tr>
				<tr> 
					<td class="title_td"><%=text.get ( "CT_001.TXT_039" ) %><%-- 계약체결일 --%></td>
					<td class="data_td_input">
						<%
							String cont_date = SepoaString.getDateSlashFormat ( MapUtils.getString ( headerHm , "CONT_DATE" , MapUtils.getString ( headerHmChange , "CONT_DATE" , "" ) ) );
						%>
						<s:calendar id="cont_date" default_value="<%=SepoaString.getDateSlashFormat(cont_date)%>" format="%Y/%m/%d"/>
					</td>
				</tr>
				<%------------------------------------------------------------변경계약서에서만 보이는 부분----------------------------------------------------------시작--%>
				<%------------------------------------------------------------변경계약서에서만 보이는 부분----------------------------------------------------------시작--%>
				<%------------------------------------------------------------변경계약서에서만 보이는 부분----------------------------------------------------------시작--%>
				<% if( ( "BCC".equals ( p_doc_type ) || "BCU".equals ( p_doc_type ) ) && !migrationFlag ){ %>
				<tr>
					<td class="title_td"><%=changeCtText1 %><%=text.get ( "CT_001.TXT_040" ) %><%-- 계약기간 --%></td>
					<td class="data_td_input">
						<%
							String cont_from_change = SepoaString.getDateSlashFormat ( MapUtils.getString ( headerHmChange , "CONT_FROM" , "" ) );
							String cont_to_change   = SepoaString.getDateSlashFormat ( MapUtils.getString ( headerHmChange , "CONT_TO" , "" ) );
						%>
						<span id="viewSpan"><s:calendar id_from="cont_from_change" default_from="<%=SepoaString.getDateSlashFormat(cont_from_change)%>" id_to="cont_to_change" default_to="<%=SepoaString.getDateSlashFormat(cont_to_change)%>" format="%Y/%m/%d"/></span>
					</td>
				</tr>
				<% } %>
				<%------------------------------------------------------------변경계약서에서만 보이는 부분----------------------------------------------------------종료--%>
				<%------------------------------------------------------------변경계약서에서만 보이는 부분----------------------------------------------------------종료--%>
				<%------------------------------------------------------------변경계약서에서만 보이는 부분----------------------------------------------------------종료--%>
				<tr> 
					<td class="title_td"><%=changeCtText2 %><%=text.get ( "CT_001.TXT_041" ) %><%-- 계약기간 --%></td>
					<td class="data_td_input">
						<%
							String cont_from = SepoaString.getDateSlashFormat ( MapUtils.getString ( headerHm , "CONT_FROM" , "" ) );
							String cont_to   = SepoaString.getDateSlashFormat ( MapUtils.getString ( headerHm , "CONT_TO" , "" ) );
						%>
						<span id="viewSpan"><s:calendar id_from="cont_from" default_from="<%=SepoaString.getDateSlashFormat(cont_from)%>" id_to="cont_to" default_to="<%=SepoaString.getDateSlashFormat(cont_to)%>" format="%Y/%m/%d"/></span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<table width="100%" height="3" border="0" cellspacing="0" cellpadding="0" bgcolor="#629DD9"><tr><td></td></tr></table>
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<colgroup>
					<col width="20%"/>
					<col width="40%"/>
					<col width="40%"/>
				</colgroup>
				<tr> 
					<td class="title_td"><%=text.get ( "CT_001.TXT_042" ) %><%-- 업체명 --%></td>
					<td class="data_td_input">
						<span id="viewSpan"><input type="text"   id="buyer_company_name" name="buyer_company_name" class="input_empty" style="width: 90%;" readonly onfocus="this.blur();" value="<%=MapUtils.getString ( headerHm , "BUYER_COMPANY_NAME" , "" ) %>"/></span>
						<input type="hidden" id="company_code"       name="company_code"       class="input_empty" style="width: 90%;" readonly onfocus="this.blur();" value="<%=MapUtils.getString ( headerHm , "COMPANY_CODE" , MapUtils.getString ( headerHmChange , "COMPANY_CODE" , "" ) ) %>"/>
					</td>
					<td class="data_td_input">
                        <%
                            //단가계약의 경우에는 업체를 선택 할 수 있도록 한다.
                            String sellerSelectInputSize = "99.5%";
                            String sellerSelectImageBox  = "";
                            if( "Y".equals ( p_contractPrice ) ) {
                                sellerSelectInputSize = "90.5%";
                                sellerSelectImageBox  = "<a href=\"javascript:getSellerCode();\"><img src=\"../images/button/butt_query.gif\" align=\"absmiddle\" border=\"0\" alt=\"\"></a>"; 
                            }
                        %>
						<span id="viewSpan"><input type="text"   id="seller_company_name" name="seller_company_name"  class="input_empty" style="width: <%=sellerSelectInputSize %>;" readonly onfocus="this.blur();" value="<%=MapUtils.getString ( headerHm , "SELLER_COMPANY_NAME" , MapUtils.getString ( headerHmChange , "SELLER_COMPANY_NAME" , "" ) ) %>"/></span>
						<input type="hidden" id="seller_code"         name="seller_code"          class="input_empty" style="width: 90%;" readonly onfocus="this.blur();" value="<%=MapUtils.getString ( headerHm , "SELLER_CODE" , MapUtils.getString ( headerHmChange , "SELLER_CODE" , "" ) ) %>"/>
                        <%=sellerSelectImageBox %>
					</td>
				</tr>
				<tr> 
					<td class="title_td"><%=text.get ( "CT_001.TXT_043" ) %><%-- 사업자번호 --%></td>
					<td class="data_td_input">
						<span id="viewSpan"><input type="text" id="buyer_company_irs_no" name="buyer_company_irs_no" class="input_empty" style="width: 90%;" readonly onfocus="this.blur();" value="<%=MapUtils.getString ( headerHm , "BUYER_COMPANY_IRS_NO" , MapUtils.getString ( headerHmChange , "BUYER_COMPANY_IRS_NO" , "" ) ) %>"/></span>
					</td>
					<td class="data_td_input">
						<span id="viewSpan"><input type="text" id="seller_company_irs_no" name="seller_company_irs_no"  class="input_empty" style="width: 90%;" readonly onfocus="this.blur();" value="<%=MapUtils.getString ( headerHm , "SELLER_COMPANY_IRS_NO" , MapUtils.getString ( headerHmChange , "SELLER_COMPANY_IRS_NO" , "" ) ) %>"/></span>
					</td>
				</tr>
				
				<tr> 
					<td class="title_td" rowspan="3" valign="top"><%=text.get ( "CT_001.TXT_044" ) %><%-- 주소 --%></td>
					<td class="data_td_input">
						<span id="viewSpan"><input type="text" id="buyer_company_zip_code1" name="buyer_company_zip_code1" class="inputsubmit_no" size="3" value="<%=MapUtils.getString ( headerHm , "BUYER_COMPANY_ZIP_CODE1" , MapUtils.getString ( headerHmChange , "BUYER_COMPANY_ZIP_CODE1" , "" ) ) %>"/></span> -&nbsp;
						<span id="viewSpan"><input type="text" id="buyer_company_zip_code2" name="buyer_company_zip_code2" class="inputsubmit_no" size="3" value="<%=MapUtils.getString ( headerHm , "BUYER_COMPANY_ZIP_CODE2" , MapUtils.getString ( headerHmChange , "BUYER_COMPANY_ZIP_CODE2" , "" ) ) %>"/></span>
					</td>
					<td class="data_td_input">
						<span id="viewSpan"><input type="text" id="seller_company_zip_code1" name="seller_company_zip_code1"  class="inputsubmit_no" size="3" onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" value="<%=MapUtils.getString ( headerHm , "SELLER_COMPANY_ZIP_CODE1" , MapUtils.getString ( headerHmChange , "SELLER_COMPANY_ZIP_CODE1" , "" ) ) %>"/></span> - 
						<span id="viewSpan"><input type="text" id="seller_company_zip_code2" name="seller_company_zip_code2"  class="inputsubmit_no" size="3" onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" value="<%=MapUtils.getString ( headerHm , "SELLER_COMPANY_ZIP_CODE2" , MapUtils.getString ( headerHmChange , "SELLER_COMPANY_ZIP_CODE2" , "" ) ) %>"/></span>
					</td>
				</tr>
				
				<tr> 
					<!-- <td class="title_td" rowspan="3">주소</td> rowSpan된 상태-->
					<td class="data_td_input">
						<span id="viewSpan"><input type="text" id="buyer_company_addr" name="buyer_company_addr1" class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "BUYER_COMPANY_ADDR1" , MapUtils.getString ( headerHmChange , "BUYER_COMPANY_ADDR1" , "" )  ) %>"/></span>
					</td>
					<td class="data_td_input">
						<span id="viewSpan"><input type="text" id="seller_company_addr" name="seller_company_addr1"  class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "SELLER_COMPANY_ADDR1" , MapUtils.getString ( headerHmChange , "SELLER_COMPANY_ADDR1" , "" ) ) %>"/></span>
					</td>
				</tr>
				
				<tr> 
					<!-- <td class="title_td" rowspan="3">주소</td> rowSpan된 상태-->
					<td class="data_td_input">
						<span id="viewSpan"><input type="text" id="buyer_company_addr2" name="buyer_company_addr2" class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "BUYER_COMPANY_ADDR2" , MapUtils.getString ( headerHmChange , "BUYER_COMPANY_ADDR2" , "" ) ) %>"/></span>
					</td>
					<td class="data_td_input">
						<span id="viewSpan"><input type="text" id="seller_company_addr2" name="seller_company_addr2"  class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "SELLER_COMPANY_ADDR2" , MapUtils.getString ( headerHmChange , "SELLER_COMPANY_ADDR2" , "" ) ) %>"/></span>
					</td>
				</tr>
				<tr> 
					<td class="title_td"><%=text.get ( "CT_001.TXT_045" ) %><%-- 대표이사 --%></td>
					<td class="data_td_input">
						<span id="viewSpan"><input type="text" id="buyer_company_ceo_name" name="buyer_company_ceo_name" class="input_empty" style="width: 90%;" readonly onfocus="this.blur();" value="<%=MapUtils.getString ( headerHm , "BUYER_COMPANY_CEO_NAME" , MapUtils.getString ( headerHmChange , "BUYER_COMPANY_CEO_NAME" , "" ) ) %>"/></span>
					</td>
					<td class="data_td_input">
						<span id="viewSpan"><input type="text" id="seller_company_ceo_name" name="seller_company_ceo_name" class="input_empty" style="width: 90%;" readonly onfocus="this.blur();" value="<%=MapUtils.getString ( headerHm , "SELLER_COMPANY_CEO_NAME" , MapUtils.getString ( headerHmChange , "SELLER_COMPANY_CEO_NAME" , "" ) ) %>"/></span>
					</td>
				</tr>
				<tr> 
					<td class="title_td"><%=text.get ( "CT_001.TXT_046" ) %><%-- 대표이사서명 --%></td>
					<td class="data_td_input">
						<font color="red"><%=MapUtils.getString ( headerHm , "SELLER_APP_SUCCESS" , "" ) %></font>
					</td>
					<td class="data_td_input">
						<font color="red"><%=MapUtils.getString ( headerHm , "BUYER_APP_SUCCESS" , "" ) %></font>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<table width="100%" height="3" border="0" cellspacing="0" cellpadding="0" bgcolor="#629DD9"><tr><td></td></tr></table>
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB" >
				<colgroup>
					<col width="15%" />
					<col width="15%" />
					<col width="35%" />
					<col width="35%" />
				</colgroup>
				<tr id="7"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" colspan="2" id="locationTd"><%=text.get ( "CT_001.TXT_047" ) %><%-- 공사장소 --%></td>
					<td class="data_td_input" colspan="2">
						<span id="viewSpan"><input type="text" id="location" name="location" class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "LOCATION" , MapUtils.getString ( headerHmChange , "LOCATION" , "" ) ) %>"/></span>
					</td>
				</tr>
				
				<%------------------------------------------------------------변경계약서에서만 보이는 부분----------------------------------------------------------시작--%>
				<%------------------------------------------------------------변경계약서에서만 보이는 부분----------------------------------------------------------시작--%>
				<%------------------------------------------------------------변경계약서에서만 보이는 부분----------------------------------------------------------시작--%>
				<% if( ( ( "BCC".equals ( p_doc_type ) || "BCU".equals ( p_doc_type ) )  && !migrationFlag ) ) { %>
				<tr>
					<td colspan="4">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DBDBDB">
							<colgroup>
					<col width="10%" />
					<col width="30%" />
					<col width="30%" />
					<col width="30%" />
							</colgroup>
							<tr align="center">
								<td class="title_td">
									구&nbsp;&nbsp;&nbsp;&nbsp;분
								</td>
								<td class="title_td">
									당&nbsp;&nbsp;&nbsp;&nbsp;초
								</td>
								<td class="title_td">
									변&nbsp;&nbsp;&nbsp;&nbsp;경
								</td>
								<td class="title_td">
									증&nbsp;&nbsp;&nbsp;&nbsp;감
								</td>
							</tr>
							
							<tr>
								<td class="title_td" align="center">
									<%=text.get ( "CT_001.TXT_048" ) %><%-- 계 약 금 액 --%>
								</td>
								<td class="data_td_input">
									( <%=MapUtils.getString ( headerHm , "CUR" , "" ) %> 
									<span id="viewSpan"><input type="text" id="cont_ttl_amt_ori" name="cont_ttl_amt_ori"  class="input_empty" readonly style="width: 80%;text-align: right;" value="<%=formatNumberPrice ( MapUtils.getString ( headerHmChange , "CONT_TTL_AMT" , "" ) ) %>"
									 onkeyup="onKeyUpChangeAmt(this.id);onKeyUPContAmtCal(this.id);"
									 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
									/> 
									</span>
									)
								</td>
								<td class="data_td_input">
									<input type="hidden" id="cont_ttl_amt_text" name="cont_ttl_amt_text" class="inputsubmit" style="width: 80%;text-align: right;" readonly onfocus="this.blur();"  value="<%=MapUtils.getString ( headerHm , "CONT_TTL_AMT_TEXT" , "" ) %>"/>
									( <%=MapUtils.getString ( headerHm , "CUR" , "" ) %> 
									<span id="viewSpan"><input type="text" id="cont_ttl_amt" name="cont_ttl_amt"  class="inputsubmit" style="width: 80%;text-align: right;" value="<%=formatNumberPrice ( MapUtils.getString ( headerHm , "CONT_TTL_AMT" , "" ) ) %>"
									 onkeyup="onKeyUpChangeAmt(this.id);onKeyUPContAmtCal(this.id);"
									 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
									/> 
									</span>
									)
								</td>
								<td class="data_td_input">
									( <%=MapUtils.getString ( headerHm , "CUR" , "" ) %> 
									<span id="viewSpan"><input type="text" id="cont_ttl_cal_amt" name="cont_ttl_cal_amt"  class="input_empty" readonly style="width: 80%;text-align: right;" 
									 value="<%=formatNumberPrice ( String.valueOf ( Double.parseDouble ( MapUtils.getString ( headerHm , "CONT_TTL_AMT" , "0" ) ) - Double.parseDouble ( MapUtils.getString ( headerHmChange , "CONT_TTL_AMT" , "0" ) ) ) ) %>"
									 onkeyup="onKeyUpChangeAmt(this.id);onKeyUPContAmtCal(this.id);"
									 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
									/> 
									</span>
									)
								</td>
							</tr>
							<tr>
								<td class="title_td" align="center">
									<%=text.get ( "CT_001.TXT_049" ) %><%-- 공급가액 --%>
								</td>
								<td class="data_td_input">
									( <%=MapUtils.getString ( headerHm , "CUR" , "" ) %> 
									<span id="viewSpan"><input type="text" id="cont_amt_ori" name="cont_amt_ori"  class="input_empty"  readonly  style="width: 80%;text-align: right;" value="<%=formatNumberPrice ( MapUtils.getString ( headerHmChange , "CONT_AMT" , "" ) ) %>"
									 onkeyup="onKeyUpChangeAmt(this.id);onKeyUPContAmtCal(this.id);"
									 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
									/> 
									</span>
									)
								</td>
								<td class="data_td_input">
									<input type="hidden" id="cont_amt_text" name="cont_amt_text" class="inputsubmit" style="width: 80%;text-align: right;" readonly onfocus="this.blur();"  value="<%=MapUtils.getString ( headerHm , "CONT_AMT_TEXT" , "" ) %>"/>
									( <%=MapUtils.getString ( headerHm , "CUR" , "" ) %> 
									<span id="viewSpan"><input type="text" id="cont_amt" name="cont_amt"  class="inputsubmit" style="width: 80%;text-align: right;" value="<%=formatNumberPrice ( MapUtils.getString ( headerHm , "CONT_AMT" , "" ) ) %>"
									 onkeyup="onKeyUpChangeAmt(this.id);onKeyUPContAmtCal(this.id);"
									 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
									/> 
									</span>
									)
								</td>
								<td class="data_td_input">
									( <%=MapUtils.getString ( headerHm , "CUR" , "" ) %> 
									<span id="viewSpan"><input type="text" id="cont_cal_amt" name="cont_cal_amt"  class="input_empty" readonly style="width: 80%;text-align: right;" value="<%=formatNumberPrice ( String.valueOf ( Double.parseDouble ( MapUtils.getString ( headerHm , "CONT_AMT" , "0" ) ) - Double.parseDouble ( MapUtils.getString ( headerHmChange , "CONT_AMT" , "0" ) ) ) ) %>"
									 onkeyup="onKeyUpChangeAmt(this.id);onKeyUPContAmtCal(this.id);"
									 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
									/> 
									</span>
									)
								</td>
							</tr>
							<tr>
								<td class="title_td" align="center">
									<%=text.get ( "CT_001.TXT_050" ) %><%-- 부가가치세 --%>
								</td>
								<td class="data_td_input">
									( <%=MapUtils.getString ( headerHm , "CUR" , "" ) %> 
									<span id="viewSpan"><input type="text" id="cont_vat_ori" name="cont_vat_ori"  class="input_empty" readonly style="width: 80%;text-align: right;" value="<%=formatNumberPrice ( MapUtils.getString ( headerHmChange , "CONT_VAT" , "" ) ) %>"
									 onkeyup="onKeyUpChangeAmt(this.id);onKeyUPContAmtCal(this.id);"
									 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
									/> 
									</span>
									)
								</td>
								<td class="data_td_input">
									<input type="hidden" id="cont_vat_text" name="cont_vat_text" class="inputsubmit" style="width: 80%;text-align: right;" readonly onfocus="this.blur();"  value="<%=MapUtils.getString ( headerHm , "CONT_VAT_TEXT" , "" ) %>"/>
									( <%=MapUtils.getString ( headerHm , "CUR" , "" ) %> 
									<span id="viewSpan"><input type="text" id="cont_vat" name="cont_vat"  class="inputsubmit" style="width: 80%;text-align: right;" value="<%=formatNumberPrice ( MapUtils.getString ( headerHm , "CONT_VAT" , "" ) ) %>"
									 onkeyup="onKeyUpChangeAmt(this.id);onKeyUPContAmtCal(this.id);"
									 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
									/> 
									</span>
									)
								</td>
								<td class="data_td_input">
									( <%=MapUtils.getString ( headerHm , "CUR" , "" ) %> 
									<span id="viewSpan"><input type="text" id="cont_cal_vat" name="cont_cal_vat"  class="input_empty" readonly style="width: 80%;text-align: right;" value="<%=formatNumberPrice ( String.valueOf ( Double.parseDouble ( MapUtils.getString ( headerHm , "CONT_VAT" , "0" ) ) - Double.parseDouble ( MapUtils.getString ( headerHmChange , "CONT_VAT" , "0" ) ) ) ) %>"
									 onkeyup="onKeyUpChangeAmt(this.id);onKeyUPContAmtCal(this.id);"
									 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
									/> 
									</span>
									)
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<%------------------------------------------------------------변경계약서에서만 보이는 부분----------------------------------------------------------종료--%>
				<%------------------------------------------------------------변경계약서에서만 보이는 부분----------------------------------------------------------종료--%>
				<%------------------------------------------------------------변경계약서에서만 보이는 부분----------------------------------------------------------종료--%>
				
				<% } else {  %>
				
				<%------------------------------------------------------------변경계약서에서만 안보이는 부분----------------------------------------------------------시작--%>
				<%------------------------------------------------------------변경계약서에서만 안보이는 부분----------------------------------------------------------시작--%>
				<%------------------------------------------------------------변경계약서에서만 안보이는 부분----------------------------------------------------------시작--%>
				
				<tr id="56"> <!-- 계약서종류별 안보이는 코드로 TR IDs정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" colspan="2"><%=text.get ( "CT_001.TXT_051" ) %><%-- 계약금액 --%><font color="red"><%=text.get ( "CT_001.TXT_052" ) %><%-- (VAT 포함) --%></font></td>
                    <td class="data_td_input">
                        ( <%=MapUtils.getString ( headerHm , "CUR" , "" ) %> 
                        <span id="viewSpan"><input type="text" id="cont_ttl_amt" name="cont_ttl_amt"  class="inputsubmit" style="width: 80%;text-align: right;ime-mode=disabled;" value="<%=formatNumberPrice ( MapUtils.getString ( headerHm , "CONT_TTL_AMT" , "" ) ) %>"
                         onkeyup="onKeyUpChangeAmt(this.id);onKeyUPContAmtCal(this.id);"
                         onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
                        /> 
                        </span>
                        )
                    </td>
                    <td class="data_td_input">
                        <% if("KRW".equals ( MapUtils.getString ( headerHm , "CUR" , "" ) )){ %>
						金 <span id="viewSpan"><input type="text" id="cont_ttl_amt_text" name="cont_ttl_amt_text" class="inputsubmit" style="width: 80%;text-align: right;" readonly onfocus="this.blur();"  value="<%=MapUtils.getString ( headerHm , "CONT_TTL_AMT_TEXT" , "" ) %>"/></span> 정
                        <% } %>
					</td>
				</tr>
				<tr id="567"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" colspan="2"><%=text.get ( "CT_001.TXT_053" ) %><%-- 공급가액 --%><font color="red"><%=text.get ( "CT_001.TXT_054" ) %><%-- (VAT 별도) --%></font></td>
					<td class="data_td_input">
                        <%
                            //단가계약서 작성일경우에는 공급가액을 입력할수 있도록 한다.
                         //   String contAmtReadOnly = "readonly";
                            if("Y".equals ( p_contractPrice ) ) {
                                contAmtReadOnly = "";
                            }
                        %>
						( <%=MapUtils.getString ( headerHm , "CUR" , "" ) %> 
						<span id="viewSpan"><input type="text" id="cont_amt" name="cont_amt"  class="inputsubmit" <%=contAmtReadOnly %> style="width: 80%;text-align: right;ime-mode=disabled;" value="<%=formatNumberPrice ( MapUtils.getString ( headerHm , "CONT_AMT" , "" ) ) %>"
						 onkeyup="onKeyUpChangeAmt(this.id);onKeyUPContAmtCal(this.id);"
						 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
						/> 
						</span>
						)
					</td>
                    <td class="data_td_input">
                        <% if("KRW".equals ( MapUtils.getString ( headerHm , "CUR" , "" ) )){ %>
                        金 <span id="viewSpan"><input type="text" id="cont_amt_text" name="cont_amt_text" class="inputsubmit" style="width: 80%;text-align: right;" readonly onfocus="this.blur();" value="<%=MapUtils.getString ( headerHm , "CONT_AMT_TEXT" , "" ) %>"/></span> 정
                        <% } %>
                    </td>
				</tr>
				<tr id="567"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" colspan="2"><%=text.get ( "CT_001.TXT_055" ) %><%-- 부가가치세 --%></td>
					<td class="data_td_input">
						( <%=MapUtils.getString ( headerHm , "CUR" , "" ) %> 
						<span id="viewSpan"><input type="text" id="cont_vat" name="cont_vat"  class="inputsubmit" style="width: 80%;text-align: right;;ime-mode=disabled;" value="<%=formatNumberPrice ( MapUtils.getString ( headerHm , "CONT_VAT" , "" ) ) %>" 
						 onkeyup="onKeyUpChangeAmt(this.id);onKeyUPContAmtCal(this.id);"
						 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
						/> 
						</span>
						)
					</td>
                    <td class="data_td_input">
                        <% if("KRW".equals ( MapUtils.getString ( headerHm , "CUR" , "" ) )){ %>
                        金 <span id="viewSpan"><input type="text" id="cont_vat_text" name="cont_vat_text" class="inputsubmit" style="width: 80%;text-align: right;" readonly onfocus="this.blur();" value="<%=MapUtils.getString ( headerHm , "CONT_VAT_TEXT" , "" ) %>"/></span> 정
                        <% } %>
                    </td>
				</tr>
				<%------------------------------------------------------------변경계약서에서만 안보이는 부분----------------------------------------------------------종료--%>
				<%------------------------------------------------------------변경계약서에서만 안보이는 부분----------------------------------------------------------종료--%>
				<%------------------------------------------------------------변경계약서에서만 안보이는 부분----------------------------------------------------------종료--%>
				<% } %>
				
				<tr id="7"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" colspan="2"><%=text.get ( "CT_001.TXT_056" ) %><%-- 대금지급방법 --%></td>
					<td class="data_td_input" colspan="2">
						<span id="viewSpan"><input type="text" id="pay_terms_text" name="pay_terms_text" class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "PAY_TERMS_TEXT" , MapUtils.getString ( headerHmChange , "PAY_TERMS_TEXT" , "" ) ) %>"/></span>
					</td>
				</tr>
				<tr> 
					<td class="title_td" colspan="2"><%=text.get ( "CT_001.TXT_057" ) %><%-- 대금정산조건 --%></td>
					<td class="data_td_input" colspan="2">
						<span id="viewSpan"><input type="text" id="pay_terms_date" name="pay_terms_date" class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "PAY_TERMS_DATE" , MapUtils.getString ( headerHmChange , "PAY_TERMS_DATE" , "" ) ) %>"/></span>
					</td>
				</tr>
				<tr <%-- id="7" --%>style="display: none"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" colspan="2"><%=text.get ( "CT_001.TXT_058" ) %><%-- 지불조건/비율 --%></td>
					<td class="data_td_input" colspan="2">
						<span id="viewSpan"><input type="text" id="pay_terms_percent" name="pay_terms_percent" class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "PAY_TERMS_PERCENT" , MapUtils.getString ( headerHmChange , "PAY_TERMS_PERCENT" , "" ) ) %>"/></span>
					</td>
				</tr>
				
				<tr id="47"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td"  colspan="2" valign="top" style="border-bottom: 1px solid #F8F8F8;">
						<%=text.get ( "CT_001.TXT_059" ) %><%-- 지불조건 상세 --%> 
						<span id="viewSpan"><input type="checkbox" id="pay_terms_spec_flag" name="pay_terms_spec_flag" class="inputsubmit" style="border: 0px;" onclick="paySpecCheck(this)" <%=MapUtils.getString ( headerHm , "PAY_TERMS_SPEC_FLAG" , MapUtils.getString ( headerHmChange , "PAY_TERMS_SPEC_FLAG" , "checked" ) )%>/></span>
					</td>
					<td class="data_td_input" colspan="2" colspan="2">
						<%=text.get ( "CT_001.TXT_060" ) %><%-- 선급금 --%>
						<span id="viewSpan"><input type="text" id="first_amt_ratio" name="first_amt_ratio"  class="inputsubmit" size="4" value="<%=MapUtils.getString ( headerHm , "FIRST_AMT_RATIO" , MapUtils.getString ( headerHmChange , "FIRST_AMT_RATIO" , "" ) ) %>"
						 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;"
						/></span> %
						( 
						<span id="viewSpan"><input type="text" id="first_amt_time" name="first_amt_time" class="inputsubmit" style="width: 50%;text-align: left;" value="<%=MapUtils.getString ( headerHm , "FIRST_AMT_TIME" , MapUtils.getString ( headerHmChange , "FIRST_AMT_TIME" , "" ) ) %>"
						/>
						</span> 
						)
					</td>
				</tr>
				
				<tr id="47"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td colspan="2" style="border-bottom: 1px solid #F8F8F8;border-top: 1px solid #F8F8F8;background-color: #F8F8F8;">
						&nbsp;
					</td>
					<td class="data_td_input" colspan="2" colspan="2">
						<%=text.get ( "CT_001.TXT_061" ) %><%-- 중도금 --%>
						<span id="viewSpan"><input type="text" id="second_amt_ratio_01" name="second_amt_ratio_01"  class="inputsubmit" size="4" value="<%=MapUtils.getString ( headerHm , "SECOND_AMT_RATIO_01" , MapUtils.getString ( headerHmChange , "SECOND_AMT_RATIO_01" , "" ) ) %>"
						 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;"
						/></span> %
						( 
						<span id="viewSpan"><input type="text" id="second_amt_time_01" name="second_amt_time_01" class="inputsubmit" style="width: 50%;text-align: left;" value="<%=MapUtils.getString ( headerHm , "SECOND_AMT_TIME_01" , MapUtils.getString ( headerHmChange , "SECOND_AMT_TIME_01" , "" ) ) %>"
						/></span> 
						)
					</td>
				</tr>
				
				<tr id="47"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td colspan="2" style="border-top: 1px solid #F8F8F8;background-color: #F8F8F8;">
						&nbsp;
					</td>
					<td class="data_td_input" colspan="2" colspan="2">
						&nbsp;&nbsp;&nbsp;<%=text.get ( "CT_001.TXT_062" ) %><%-- 잔금 --%>
						<span id="viewSpan"><input type="text" id="third_amt_ratio" name="third_amt_ratio"  class="inputsubmit" size="4" value="<%=MapUtils.getString ( headerHm , "THIRD_AMT_RATIO" , MapUtils.getString ( headerHmChange , "THIRD_AMT_RATIO" , "" ) ) %>"
						 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;"
						/></span> %
						( 
						<span id="viewSpan"><input type="text" id="third_amt_time" name="third_amt_time" class="inputsubmit" style="width: 50%;text-align: left;" value="<%=MapUtils.getString ( headerHm , "THIRD_AMT_TIME" , MapUtils.getString ( headerHmChange , "THIRD_AMT_TIME" , "" ) ) %>"
						/></span> 
						)
					</td>
				</tr>
				<tr id="123567"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" valign="top" style="padding-top: 2px;" colspan="2"><%=text.get ( "CT_001.TXT_063" ) %><%-- 지불조건상세 --%></td>
					<td class="data_td_input" colspan="2">
						<span id="viewSpan"><textarea id="pay_terms_spec" name="pay_terms_spec" style="width: 90%;" rows="3"><%=MapUtils.getString ( headerHm , "PAY_TERMS_SPEC" , MapUtils.getString ( headerHmChange , "PAY_TERMS_SPEC" , "" ) ) %></textarea></span>
					</td>
				</tr>
				<tr id="123567"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" valign="top" style="padding-top: 2px;" colspan="2"><%=text.get ( "CT_001.TXT_064" ) %><%-- 정기(예방)점검주기 --%></td>
					<td class="data_td_input" colspan="2">
						<span id="viewSpan"><input type="text" id="period_check" name="period_check" class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "PERIOD_CHECK" , MapUtils.getString ( headerHm , "PERIOD_CHECK" , "" ) ) %>"/></span>
					</td>
				</tr>
				<tr id="4567"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" colspan="2"><%=text.get ( "CT_001.TXT_065" ) %><%-- 납기일 --%></td>
					<td class="data_td_input" colspan="2"> 
						<%
							String calRdDate = SepoaString.getDateSlashFormat ( MapUtils.getString ( headerHm , "RD_DATE" , MapUtils.getString ( headerHmChange , "RD_DATE" , "" ) ) );
						%>
						<span id="viewSpan"><s:calendar id="rd_date" default_value="<%=SepoaString.getDateSlashFormat(calRdDate)%>" format="%Y/%m/%d"/></span>
					</td>
				</tr>
				<tr id="47"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" colspan="2"><%=text.get ( "CT_001.TXT_066" ) %><%-- 지체상금 --%></td>
					<td class="data_td_input" colspan="2">
						<span id="viewSpan"><input type="text" id="delay_price" name="delay_price" class="inputsubmit_num_no" size="4" value="<%=MapUtils.getString ( headerHm , "DELAY_PRICE" , MapUtils.getString ( headerHmChange , "DELAY_PRICE" , "" ) ) %>"
						 <%-- onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" --%> <%-- 숫자만 입력 가능하도록 --%>
						/></span>
						 <%=text.get ( "CT_001.TXT_067" ) %><%-- / 1000 (지연일수 1일당 총계약금액의) --%>
					</td>
				</tr>
				<tr id="7"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" colspan="2"><%=text.get ( "CT_001.TXT_068" ) %><%-- 계약이행보증금율 --%></td>
					<td class="data_td_input" colspan="2">
						<%=text.get ( "CT_001.TXT_069" ) %><%-- 계약금액의 --%>
						<span id="viewSpan"><input type="text" id="cont_ins_percent" name="cont_ins_percent" class="inputsubmit_num_no" size="3" value="<%=MapUtils.getString ( headerHm , "CONT_INS_PERCENT" , MapUtils.getString ( headerHmChange , "CONT_INS_PERCENT" , "0.00" ) ) %>"
						 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
						/></span>
						 %
						<%
							String cont_ins_amt_temp = MapUtils.getString ( headerHm , "CONT_INS_AMT" , MapUtils.getString ( headerHmChange , "CONT_INS_AMT" , "" ) );
							if( "0".equals ( cont_ins_amt_temp.trim (  ) ) || "".equals ( cont_ins_amt_temp.trim (  ) )) {
							    cont_ins_amt_temp = formatNumberPrice ( String.valueOf ( Double.parseDouble ( MapUtils.getString ( headerHm , "CONT_TTL_AMT" , MapUtils.getString ( headerHmChange , "CONT_TTL_AMT" , "" ) ) ) * Double.parseDouble ( MapUtils.getString ( headerHm , "CONT_INS_PERCENT" , MapUtils.getString ( headerHmChange , "CONT_INS_PERCENT" , "0.00" ) ) ) / 100 ) );
							} else {
							    cont_ins_amt_temp = formatNumberPrice ( cont_ins_amt_temp );
							}
						%>
						( <%=MapUtils.getString ( headerHm , "CUR" , "" ) %> <span id="viewSpan"><input type="text" id="cont_ins_amt" name="cont_ins_amt" class="inputsubmit" size="20" value="<%=cont_ins_amt_temp %>" style="text-align: right"
						 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
						/></span>
						)
					</td>
				</tr>
				<tr id="7"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" colspan="2"><%=text.get ( "CT_001.TXT_070" ) %><%-- 선급금지급 보증금율 --%></td>
					<td class="data_td_input" colspan="2">
						<span id="viewSpan"><input type="text" id="pre_ins_percent_text" name="pre_ins_percent_text" class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "PRE_INS_PERCENT_TEXT" , MapUtils.getString ( headerHmChange , "PRE_INS_PERCENT_TEXT" , "" ) ) %>"/></span>
						<span id="viewSpan"><input type="hidden" id="pre_ins_percent" name="pre_ins_percent" class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "PRE_INS_PERCENT" , MapUtils.getString ( headerHmChange , "PRE_INS_PERCENT" , "0.00" ) ) %>"/></span>
					</td>
				</tr>
				<tr id="47"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td width="10%" class="title_td" style="border-bottom: 1px solid #F8F8F8;"><%=text.get ( "CT_001.TXT_117" ) %><%-- 하자이행 --%></td>
					<td width="10%" class="title_td"><%=text.get ( "CT_001.TXT_071" ) %><%-- 보증금율 --%></td>
					<td width="80%" class="data_td_input" colspan="2">
						<%=text.get ( "CT_001.TXT_072" ) %><%-- 계약금액의 --%>
						<span id="viewSpan"><input type="text" id="fault_ins_percent" name="fault_ins_percent" class="inputsubmit_num_no" size="3" value="<%=MapUtils.getString ( headerHm , "FAULT_INS_PERCENT" , MapUtils.getString ( headerHmChange , "FAULT_INS_PERCENT" , "0.00" ) ) %>"
						 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
						/></span>
						 %
						<%
							String fault_ins_amt_temp = MapUtils.getString ( headerHm , "FAULT_INS_AMT" , MapUtils.getString ( headerHmChange , "FAULT_INS_AMT" , "" ) );
							if( "0".equals ( fault_ins_amt_temp.trim (  ) ) || "".equals ( fault_ins_amt_temp.trim (  ) )) {
							    fault_ins_amt_temp = formatNumberPrice ( String.valueOf ( Double.parseDouble ( MapUtils.getString ( headerHm , "CONT_TTL_AMT" , MapUtils.getString ( headerHmChange , "CONT_TTL_AMT" , "" ) ) ) * Double.parseDouble ( MapUtils.getString ( headerHm , "FAULT_INS_PERCENT" , MapUtils.getString ( headerHmChange , "FAULT_INS_PERCENT" , "0.00" ) ) ) / 100 ) );
							} else {
							    fault_ins_amt_temp = formatNumberPrice ( fault_ins_amt_temp );
							}
						%>
						( <%=MapUtils.getString ( headerHm , "CUR" , "" ) %> <span id="viewSpan"><input type="text" id="fault_ins_amt" name="fault_ins_amt" class="inputsubmit" size="20" value="<%=fault_ins_amt_temp %>" style="text-align: right"
						 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
						/></span>
						)
					</td>
				</tr>
				<tr id="47"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td style="border-bottom: 1px solid #F8F8F8;border-top: 1px solid #F8F8F8;background-color: #F8F8F8;">&nbsp;</td>
					<td class="title_td"><%=text.get ( "CT_001.TXT_073" ) %><%-- 보증기간 --%></td>
					<td class="data_td_input" colspan="2">
						<span id="viewSpan"><input type="text" id="fault_ins_from" name="fault_ins_from" class="inputsubmit_num_no" size="3" value="<%=MapUtils.getString ( headerHm , "FAULT_INS_FROM" , MapUtils.getString ( headerHmChange , "FAULT_INS_FROM" , "" ) ) %>"
						 onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;" <%-- 숫자만 입력 가능하도록 --%>
						/></span>
						 <%=text.get ( "CT_001.TXT_074" ) %><%-- 개월 --%>
					</td>
				</tr>
				<tr id="47"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td style="border-bottom: 1px solid #F8F8F8;border-top: 1px solid #F8F8F8;background-color: #F8F8F8;">&nbsp;</td>
					<td class="title_td" style="border-bottom: 1px solid #F8F8F8; padding-top: 3px;" valign="top"><%=text.get ( "CT_001.TXT_118" ) %><%-- 특이사항 --%></td>
					<td class="data_td_input" colspan="2" valign="top">
						<%
							sb.delete ( 0 , sb.length (  ) );
							sb.append ( ((String) text.get ( "CT_001.TXT_075" )));//.replaceAll ( "-ENTER-" , "\r\n" ) 
							/* 하자이행 보증기간 內 하자보수는, 요청시 4시간 이내로 조치완료하며, -ENTER-위반시 지체일수 일당 계약금액의 2.5 / 1000을 지체상금으로 지불한다. */
						%>
						1. <span id="viewSpan"><textarea id="delay_date1" name="delay_date1" style="width: 98%;font-family: 'dotumche','tahoma', 'Arial'" rows="2"><%=MapUtils.getString ( headerHm , "DELAY_DATE1" , MapUtils.getString ( headerHmChange , "DELAY_DATE1" , sb.toString (  ) ) ) %></textarea></span>
					</td>
				</tr>
				<tr id="2467"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td style="border-top: 1px solid #F8F8F8;background-color: #F8F8F8;">&nbsp;</td>
					<td style="border-top: 1px solid #F8F8F8;background-color: #F8F8F8;">&nbsp;</td>
					<td class="data_td_input" colspan="2">
						2. <span id="viewSpan"><input type="text" id="delay_remark1" name="delay_remark1" class="inputsubmit" style="width: 95%;" value="<%=MapUtils.getString ( headerHm , "DELAY_REMARK1" , MapUtils.getString ( headerHmChange , "DELAY_REMARK1" , "" ) ) %>"/></span>
					</td>
				</tr>
				<tr id="13457"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td style="border-top: 1px solid #F8F8F8;background-color: #F8F8F8;">&nbsp;</td>
					<td style="border-top: 1px solid #F8F8F8;background-color: #F8F8F8;">&nbsp;</td>
					<td class="data_td_input" colspan="2">
						2. <span id="viewSpan"><input type="text" id="delay_remark3" name="delay_remark3" class="inputsubmit" style="width: 95%;" value="<%=MapUtils.getString ( headerHm , "DELAY_REMARK3" , MapUtils.getString ( headerHmChange , "DELAY_REMARK3" , "" ) ) %>"/></span>
					</td>
				</tr>
				<tr id="123567"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" colspan="2" valign="top" style="padding-top: 3px;"><%=text.get ( "CT_001.TXT_076" ) %><%-- 지체상금 --%></td>
					<td class="data_td_input" colspan="2" valign="top">
						<%
							sb.delete ( 0 , sb.length (  ) );
							sb.append ( ((String) text.get ( "CT_001.TXT_077" )));//.replaceAll ( "-ENTER-" , "\r\n" ) 
							/* 하자이행 보증기간 內 하자보수는, 요청시 4시간 이내로 조치완료하며, -ENTER-위반시 지체일수 일당 계약금액의 2.5 / 1000을 지체상금으로 지불한다. */
						%>
						1. <span id="viewSpan"><textarea id="delay_date2" name="delay_date2" style="width: 98%;font-family: 'dotumche','tahoma', 'Arial'" rows="2"><%=MapUtils.getString ( headerHm , "DELAY_DATE2" , MapUtils.getString ( headerHmChange , "DELAY_DATE2" , sb.toString (  ) ) ) %></textarea></span>
						<br>
						2. <span id="viewSpan"><input type="text" id="delay_remark2" name="delay_remark2" class="inputsubmit" style="width: 95%;" value="<%=MapUtils.getString ( headerHm , "DELAY_REMARK2" , MapUtils.getString ( headerHmChange , "DELAY_REMARK2" , "" ) ) %>"/></span>
					</td>
				</tr>
				<tr id="7"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" colspan="2"><%=text.get ( "CT_001.TXT_119" ) %><%-- 검사방법 --%></td>
					<td class="data_td_input" colspan="2">
						<%
							sb.delete ( 0 , sb.length (  ) );
							sb.append ( ((String) text.get ( "CT_001.TXT_078" )));//.replaceAll ( "-ENTER-" , "\r\n" ) 
							/* 검사는 (갑)이 견적서, 시방서 및 계약서, 기타 도면과 대조하여 시행하며, -ENTER-검사결과 부적합사항에 대해서는 (갑)의 요청에 따라 즉시 시정조치 해야한다. */
						%>
						<span id="viewSpan"><textarea id="confirm_method" name="confirm_method" style="width: 90%;font-family: 'dotumche','tahoma', 'Arial'" rows="2"><%=MapUtils.getString ( headerHm , "CONFIRM_METHOD" , MapUtils.getString ( headerHmChange , "CONFIRM_METHOD" , sb.toString (  ) ) ) %></textarea></span>
					</td>
				</tr>
				<tr id="7"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" colspan="2"><%=text.get ( "CT_001.TXT_120" ) %><%-- 합의관할 --%></td>
					<td class="data_td_input" colspan="2">
						<%=text.get ( "CT_001.TXT_079" ) %><%-- 본 계약건과 분쟁발생시 (갑)과 (을)은 --%> 
						<span id="viewSpan"><input type="text" id="mutual_district" name="mutual_district" class="inputsubmit" size="15" value="<%=MapUtils.getString ( headerHm , "MUTUAL_DISTRICT" , MapUtils.getString ( headerHmChange , "MUTUAL_DISTRICT" , "서울중앙지방법원" ) ) %>"/></span>
						<%=text.get ( "CT_001.TXT_080" ) %><%-- 을 관할법원으로 한다. --%>
					</td>
				</tr>
				<tr id="13457">
					<td class="title_td" colspan="2" valign="top" style=""><%=text.get ( "CT_001.TXT_081" ) %><%-- 계약대상물 및 계약금액 --%></td>
					<td colspan="2" style="margin: 0px;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<col width="30%"><col width="10%"><col width="20%"><col width="20%"><col width="20%">
							<tr align="center">
								<td class="data_td_input" style="border-right: 1px solid #DBDBDB;background-color: #E9F3FF"><%=text.get ( "CT_001.TXT_082" ) %><%-- 품명 --%></td>
								<td class="data_td_input" style="border-right: 1px solid #DBDBDB;background-color: #E9F3FF"><%=text.get ( "CT_001.TXT_083" ) %><%-- 단위 --%></td>
								<td class="data_td_input" style="border-right: 1px solid #DBDBDB;background-color: #E9F3FF"><%=text.get ( "CT_001.TXT_084" ) %><%-- 수량 --%></td>
								<td class="data_td_input" style="border-right: 1px solid #DBDBDB;background-color: #E9F3FF"><%=text.get ( "CT_001.TXT_085" ) %><%-- 단가 --%></td>
								<td class="data_td_input" style="background-color: #E9F3FF"><%=text.get ( "CT_001.TXT_086" ) %><%-- 금액 --%></td>
							</tr>
							<tr align="left">
								<td class="data_td_input" style="border-right: 1px solid #DBDBDB;border-bottom: 1px solid #DBDBDB;">
									<span id="viewSpan"><input type="text" id="description1" name="description1" class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "DESCRIPTION1" , MapUtils.getString ( headerHmChange , "DESCRIPTION1" , "" ) ) %>"/></span>
								</td>
								<td class="data_td_input" style="border-right: 1px solid #DBDBDB;border-bottom: 1px solid #DBDBDB;">
									<span id="viewSpan"><input type="text" id="unit_measure1" name="unit_measure1" class="inputsubmit" style="width: 90%; text-align: center;" value="<%=MapUtils.getString ( headerHm , "UNIT_MEASURE1" , MapUtils.getString ( headerHmChange , "UNIT_MEASURE1" , "" ) ) %>"/></span>
								</td>
								<td class="data_td_input" style="border-right: 1px solid #DBDBDB;border-bottom: 1px solid #DBDBDB;">
									<span id="viewSpan"><input type="text" id="item_qty1" name="item_qty1" class="inputsubmit" style="width: 90%; text-align: right;" value="<%=SepoaMath.SepoaNumberType ( MapUtils.getString ( headerHm , "ITEM_QTY1" , MapUtils.getString ( headerHmChange , "ITEM_QTY1" , "" ) ) , "#,###,###,###,###,###,###" ) %>"/></span>
								</td>
								<td class="data_td_input" style="border-right: 1px solid #DBDBDB;border-bottom: 1px solid #DBDBDB;">
									<span id="viewSpan"><input type="text" id="unit_price1" name="unit_price1" class="inputsubmit" style="width: 90%; text-align: right;" value="<%=SepoaMath.SepoaNumberType ( MapUtils.getString ( headerHm , "UNIT_PRICE1" , MapUtils.getString ( headerHmChange , "UNIT_PRICE1" , "" ) ) , "#,###,###,###,###,###,###" ) %>"/></span>
								</td>
								<td class="data_td_input" style="border-bottom: 1px solid #DBDBDB;">
									<span id="viewSpan"><input type="text" id="item_amt1" name="item_amt1" class="inputsubmit" style="width: 90%; text-align: right;" value="<%=SepoaMath.SepoaNumberType ( MapUtils.getString ( headerHm , "ITEM_AMT1" , MapUtils.getString ( headerHmChange , "ITEM_AMT1" , "" ) ) , "#,###,###,###,###,###,###" ) %>"/></span>
								</td>
							</tr>
							<tr align="left">
								<td class="data_td_input" style="border-right: 1px solid #DBDBDB;border-bottom: 1px solid #DBDBDB;">
									<span id="viewSpan"><input type="text" id="description2" name="description2" class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "DESCRIPTION2" , MapUtils.getString ( headerHmChange , "DESCRIPTION2" , "" ) ) %>"/></span>
								</td>
								<td class="data_td_input" style="border-right: 1px solid #DBDBDB;border-bottom: 1px solid #DBDBDB;">
									<span id="viewSpan"><input type="text" id="unit_measure2" name="unit_measure2" class="inputsubmit" style="width: 90%; text-align: center;" value="<%=MapUtils.getString ( headerHm , "UNIT_MEASURE2" , MapUtils.getString ( headerHmChange , "UNIT_MEASURE2" , "" ) ) %>"/></span>
								</td>
								<td class="data_td_input" style="border-right: 1px solid #DBDBDB;border-bottom: 1px solid #DBDBDB;">
									<span id="viewSpan"><input type="text" id="item_qty2" name="item_qty2" class="inputsubmit" style="width: 90%; text-align: right;" value="<%=SepoaMath.SepoaNumberType ( MapUtils.getString ( headerHm , "ITEM_QTY2" , MapUtils.getString ( headerHmChange , "ITEM_QTY2" , "" ) ) , "#,###,###,###,###,###,###" ) %>"/></span>
								</td>
								<td class="data_td_input" style="border-right: 1px solid #DBDBDB;border-bottom: 1px solid #DBDBDB;">
									<span id="viewSpan"><input type="text" id="unit_price2" name="unit_price2" class="inputsubmit_num_no" style="width: 90%; text-align: right;" value="<%=SepoaMath.SepoaNumberType ( MapUtils.getString ( headerHm , "UNIT_PRICE2" , MapUtils.getString ( headerHmChange , "UNIT_PRICE2" , "" ) ) , "#,###,###,###,###,###,###" ) %>"/></span>
								</td>
								<td class="data_td_input" style="border-bottom: 1px solid #DBDBDB;">
									<span id="viewSpan"><input type="text" id="item_amt2" name="item_amt2" class="inputsubmit" style="width: 90%; text-align: right;" value="<%=SepoaMath.SepoaNumberType ( MapUtils.getString ( headerHm , "ITEM_AMT2" , MapUtils.getString ( headerHmChange , "ITEM_AMT2" , "" ) ) , "#,###,###,###,###,###,###" ) %>"/></span>
								</td>
							</tr>
							<tr align="center">
								<td colspan="2" class="data_td_input" style="border-right: 1px solid #DBDBDB;">
									<span id="viewSpan"><input type="text" id="description3" name="description3" class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "DESCRIPTION3" , MapUtils.getString ( headerHmChange , "DESCRIPTION3" , "" ) ) %>"/></span>
								</td>
								<td colspan="3" class="data_td_input">&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr id="7"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" colspan="2"><%=text.get ( "CT_001.TXT_087" ) %><%-- 부가설명 --%></td>
					<td class="data_td_input" colspan="2">
						<span id="viewSpan"><input type="text" id="remark" name="remark" class="inputsubmit" style="width: 90%;" value="<%=MapUtils.getString ( headerHm , "REMARK" , MapUtils.getString ( headerHmChange , "REMARK" , "" ) ) %>"/></span>
					</td>
				</tr>
				<tr id="7"> <!-- 계약서종류별 안보이는 코드로 TR ID정의 ID에 코드가 포함되어있으면 숨김 -->
					<td class="title_td" colspan="2" valign="top"><%=text.get ( "CT_001.TXT_088" ) %><%-- 전자계약의 효력 --%></td>
					<td class="data_td_input" colspan="2">
						<%
							sb.delete ( 0 , sb.length (  ) );
							sb.append ( ((String) text.get ( "CT_001.TXT_089" )));//.replaceAll ( "-ENTER-" , "\r\n" ) 
							/* 1. 을이 본 계약과 관련하여 전자서명한 것은 서면 계약의 서명날인과 동일한 효력을 지니며, $ENTER$   본 계약이 유효하게 성립되었음을 진술 보증합니다. $ENTER$2. 또한 본 계약과 관련하여 첨부한 일체의 서류는 본 계약의 일부요소로서 법적 효력을 $ENTER$   발생함에 동의합니다. */
						%>
						<span id="viewSpan"><textarea id="contract_effect" name="contract_effect" style="width: 90%;font-family: 'dotumche','tahoma', 'Arial'" rows="4"><%=MapUtils.getString ( headerHm , "CONTRACT_EFFECT" , MapUtils.getString ( headerHmChange , "CONTRACT_EFFECT" , sb.toString (  ) ) ) %></textarea></span>
					</td>
				</tr>
				<tr>
					<td class="title_td" colspan="2" valign="top"><%=text.get ( "CT_001.TXT_090" ) %><%-- 계약의무 --%></td>
					<td class="data_td_input" colspan="2">
						<%
							String contTypeName = "";
							if("1".equals ( MapUtils.getString ( headerHm , "CONT_TYPE" , "" ) ) ){
							    contTypeName = (String) text.get ( "CT_001.TXT_091" ); /* "공사계약"; */
							} else if ( "2".equals ( MapUtils.getString ( headerHm , "CONT_TYPE" , "" ) ) ){
							    contTypeName = (String) text.get ( "CT_001.TXT_092" ); /* "물품공급계약"; */
							} else if ( "3".equals ( MapUtils.getString ( headerHm , "CONT_TYPE" , "" ) ) ){
							    contTypeName = (String) text.get ( "CT_001.TXT_093" ); /* "용역도급계약"; */
							} else if ( "4".equals ( MapUtils.getString ( headerHm , "CONT_TYPE" , "" ) ) ){
							    contTypeName = (String) text.get ( "CT_001.TXT_094" ); /* "유지보수계약"; */
							} else if ( "5".equals ( MapUtils.getString ( headerHm , "CONT_TYPE" , "" ) ) ){
							    contTypeName = (String) text.get ( "CT_001.TXT_095" ); /* "단가계약(일반/용역)"; */
							} else if ( "6".equals ( MapUtils.getString ( headerHm , "CONT_TYPE" , "" ) ) ){
							    contTypeName = (String) text.get ( "CT_001.TXT_096" ); /* "물품공급단가계약"; */
							} else if ( "7".equals ( MapUtils.getString ( headerHm , "CONT_TYPE" , "" ) ) ){
							    contTypeName = (String) text.get ( "CT_001.TXT_097" ); /* "계약"; */
							}
							sb.delete ( 0 , sb.length (  ) );
							sb.append ( MapUtils.getString ( headerHm , "BUYER_COMPANY_NAME" , "" ) + (String) text.get ( "CT_001.TXT_098" ) + "  " + MapUtils.getString ( headerHm , "SELLER_COMPANY_NAME" , "" ) + ((String) text.get ( "CT_001.TXT_099" )));//.replaceAll ( "-ENTER-" , "\r\n" ) 
							sb.append ( contTypeName + ((String) text.get ( "CT_001.TXT_100" )));//.replaceAll ( "-ENTER-" , "\r\n" ) 
							/* 
							( "CT_001.TXT_098" )와                             
							( "CT_001.TXT_099" )(은)는 상호 대등한 입장에서  \r\n        
							( "CT_001.TXT_100" )을 체결하고 신의에 따라 성실히 계약상의 의무를 이행 및 완수할 것을 확약하며 계약의 증거로서 \r\n양사가 계약서에 전자서명을 한다.
							*/
						%>
						<span id="viewSpan"><textarea id="cont_contents" name="cont_contents" style="width: 90%;font-family: 'dotumche','tahoma', 'Arial'" rows="3"><%=MapUtils.getString ( headerHm , "CONT_CONTENTS" , MapUtils.getString ( headerHmChange , "CONT_CONTENTS" , sb.toString (  ) ) ) %></textarea></span>
					</td>
				</tr>
				<% if(migrationFlag  || "BCC".equals ( p_doc_type ) || "BCU".equals ( p_doc_type )){ %>
                <% if(!"BCC".equals ( p_doc_type ) && !"BCU".equals ( p_doc_type ) && "Y".equals ( p_contractPrice )){ %>
                <% } else { %>
                <tr>
                    <td class="title_td" colspan="2" valign="top">변경계약</td>
                    <td class="data_td_input" colspan="2">
                        <span id="viewSpan"><textarea id="migration_remark" name="migration_remark" style="width: 90%;font-family: 'dotumche','tahoma', 'Arial'" rows="4"><%=MapUtils.getString ( headerHm , "MIGRATION_REMARK" , MapUtils.getString ( headerHmChange , "MIGRATION_REMARK" , "" ) ) %></textarea></span>
                    </td>
                </tr>
                <% } %>
				<% } %>
			</table>
		</td>
	</tr>
</table>

<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%
    if ( "".equals ( MapUtils.getString ( hashMap , "bond" , "" ) ) ) {
%>
<script type="text/javascript">
function doBondSend(docTypeCode, docTypeFlag){
	//docTypeFlag - SEND 전송
	//docTypeFlag - DD   취소
	//docTypeFlag - AP   접수
	//docTypeFlag - RE   거부
	//docTypeFlag - DE   폐기
	document.forms[0].docTypeCode.value = docTypeCode; <%-- 계약 / 선급 / 하자 구분 --%>
	document.forms[0].docTypeFlag.value = docTypeFlag; <%-- 전송 / 취소 / 거부 / 접수 / 폐기 구분 --%>
	//작업여부 ( 전송(SENDXML) / 최종응답서(FINALXML) / 보증증권 수신(RECVXML)
	if(docTypeFlag == "SEND"){
		document.forms[0].bondJobFalg.value = "SENDXML";
	}else{
		document.forms[0].bondJobFalg.value = "FINALXML";
	}
	
	var seller_irs_no  = "<%=MapUtils.getString ( headerHm , "SELLER_COMPANY_IRS_NO" , MapUtils.getString ( headerHmChange , "SELLER_COMPANY_IRS_NO" , "" ) ) %>";
    var seller_irs_no_2c = 11;//new Number(seller_irs_no.split("-")[1]);
    if(seller_irs_no_2c < 80 || seller_irs_no_2c > 89){
    	var resident_no = LRTrim(document.forms[0].resident_no.value);
        if( resident_no == "" ) {
            alert("대표자주민번호를 입력해 주세요");
            return;
        }
        if(resident_no.length != 13){
        	alert("13자리 주민등록번호를 입력해주세요");
        	return;
        }
    }
    
    var nickName        = "CT_001";
    var conType         = "TRANSACTION";
    var methodName      = "setContractBond";
    var SepoaOut        = doServiceAjax( nickName, conType, methodName );
    
 
    if( SepoaOut.status == "1" ) { // 성공
        alert(SepoaOut.message);
        //window.close();
        opener.doQuery();
    } else {
        if(SepoaOut.message == "null"){
            alert("<%=text.get ( "CT_001.TXT_030" ) %><%-- 관리자에게 문의 부탁드립니다. --%>");
        }else{
            alert(SepoaOut.message);
        }
    }
}

function doBondView(ins_flag){

    if(ins_flag == "PREGUA" && pre_ins_no.length  < 1 ){
            alert("선급금증권정보가 존재하지 않습니다.");
            return;
    }else if(ins_flag == "CONGUA" && cont_ins_no.length  < 1){
            alert("계약이행증권정보가 존재하지 않습니다.");
            return;
    }else if(ins_flag == "FLRGUA" && fault_ins_no.length < 1){
            alert("하자이행증권정보가 존재하지 않습니다. ");
            return;
    }else{
        var url = "contract_bond_view.jsp?update_flag=D&cont_no="+encodeUrl("<%//cont_no%>")+"&cont_gl_seq="+encodeUrl("<%//cont_gl_seq%>")+"&ins_flag="+ins_flag;
        var width = "800";
        var height = "700";

        doOpenPopup(url, width, height);
    }
}
</script>
<br>
<div class="inputsubmit" style="border: 0px;">◆ 서울보증보험</div>
<input type="hidden" id="docTypeCode"           name="docTypeCode" /> <%-- 계약 / 선급 / 하자 구분 --%>
<input type="hidden" id="docTypeFlag"           name="docTypeFlag" /> <%-- 전송 / 취소 / 거부 / 접수 / 폐기 구분 --%>
<input type="hidden" id="bondJobFalg"           name="bondJobFalg" /> <%-- 작업여부 ( 전송(SENDXML) / 최종응답서(FINALXML) / 보증증권 수신(RECVXML) --%>
<input type="hidden" id="attach_pre_ins_no"     name="attach_pre_ins_no"    value="<%=MapUtils.getString ( headerHm , "ATTACH_PRE_INS_NO  ".trim(), "" ).trim() %>"/>
<input type="hidden" id="attach_cont_ins_no"    name="attach_cont_ins_no"   value="<%=MapUtils.getString ( headerHm , "ATTACH_CONT_INS_NO ".trim(), "" ).trim() %>"/>
<input type="hidden" id="attach_fault_ins_no"   name="attach_fault_ins_no"  value="<%=MapUtils.getString ( headerHm , "ATTACH_FAULT_INS_NO".trim(), "" ).trim() %>"/>
<input type="hidden" id="pre_ins_no"            name="pre_ins_no"           value="<%=MapUtils.getString ( headerHm , "PRE_INS_NO         ".trim(), "" ).trim() %>"/>
<input type="hidden" id="cont_ins_no"           name="cont_ins_no"          value="<%=MapUtils.getString ( headerHm , "CONT_INS_NO        ".trim(), "" ).trim() %>"/>
<input type="hidden" id="fault_ins_no"          name="fault_ins_no"         value="<%=MapUtils.getString ( headerHm , "FAULT_INS_NO       ".trim(), "" ).trim() %>"/>
<input type="hidden" id="pre_ins_flag"          name="pre_ins_flag"         value="<%=MapUtils.getString ( headerHm , "PRE_INS_FLAG       ".trim(), "" ).trim() %>"/>
<input type="hidden" id="cont_ins_flag"         name="cont_ins_flag"        value="<%=MapUtils.getString ( headerHm , "CONT_INS_FLAG      ".trim(), "" ).trim() %>"/>
<input type="hidden" id="fault_ins_flag"        name="fault_ins_flag"       value="<%=MapUtils.getString ( headerHm , "FAULT_INS_FLAG     ".trim(), "" ).trim() %>"/>
<input type="hidden" id="pre_ins_path"          name="pre_ins_path"         value="<%=MapUtils.getString ( headerHm , "PRE_INS_PATH       ".trim(), "" ).trim() %>"/>
<input type="hidden" id="cont_ins_path"         name="cont_ins_path"        value="<%=MapUtils.getString ( headerHm , "CONT_INS_PATH      ".trim(), "" ).trim() %>"/>
<input type="hidden" id="fault_ins_path"        name="fault_ins_path"       value="<%=MapUtils.getString ( headerHm , "FAULT_INS_PATH     ".trim(), "" ).trim() %>"/>
<input type="hidden" id="attach_ins_xmlno"      name="attach_ins_xmlno"     value="<%=MapUtils.getString ( headerHm , "ATTACH_INS_XMLNO   ".trim(), "" ).trim() %>"/>
<input type="hidden" id="attach_fal_xmlno"      name="attach_fal_xmlno"     value="<%=MapUtils.getString ( headerHm , "ATTACH_FAL_XMLNO   ".trim(), "" ).trim() %>"/>
<input type="hidden" id="attach_pre_xmlno"      name="attach_pre_xmlno"     value="<%=MapUtils.getString ( headerHm , "ATTACH_PRE_XMLNO   ".trim(), "" ).trim() %>"/>
<input type="hidden" id="preins_seller_check"   name="preins_seller_check"  value="<%=MapUtils.getString ( headerHm , "PREINS_SELLER_CHECK".trim(), "" ).trim() %>"/>
<input type="hidden" id="conins_seller_check"   name="conins_seller_check"  value="<%=MapUtils.getString ( headerHm , "CONINS_SELLER_CHECK".trim(), "" ).trim() %>"/>
<input type="hidden" id="flrins_seller_check"   name="flrins_seller_check"  value="<%=MapUtils.getString ( headerHm , "FLRINS_SELLER_CHECK".trim(), "" ).trim() %>"/>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <table width="100%" height="3" border="0" cellspacing="0" cellpadding="0" bgcolor="#629DD9"><tr><td></td></tr></table>
            <table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
                <colgroup>
                    <col width="10%"/>
                    <col width="15%"/>
                    <col width="5%"/>
                    <col width="25%"/>
                    <col width="5%"/>
                    <col width="50%"/>
                </colgroup>
                <tr> 
                    <td class="title_td" align="center" style="padding-left: 0px;">보증</td>
                    <td class="title_td" align="center" style="padding-left: 0px;">금액</td>
                    <td class="title_td" align="center" style="padding-left: 0px;">보증율</td>
                    <td class="title_td" align="center" style="padding-left: 0px;">기간</td>
                    <td class="title_td" align="center" style="padding-left: 0px;">상태</td>
                    <td class="title_td" align="center" style="padding-left: 0px;">증권</td>
                </tr>
                <tr> 
                    
                    <%
                        String pre_ins_amt_temp = formatNumberPrice ( String.valueOf ( Double.parseDouble ( MapUtils.getString ( headerHm , "CONT_AMT" , "" ) ) * Double.parseDouble ( MapUtils.getString ( headerHm , "PRE_INS_PERCENT" , "0.00" ) ) / 100 ) );
                    %>
                    <td class="title_td" align="center" style="padding-left: 0px;">선급지급보증</td>
                    <td class="data_td_input" align="right"><%=pre_ins_amt_temp %>&nbsp;&nbsp;</td>
                    <td class="data_td_input" align="right">&nbsp;</td>
                    <td class="data_td_input">
                        <%
                        	String calPreInsDate = "";
                            if ( "".equals ( MapUtils.getString ( headerHm , "PRE_INS_DATE" , MapUtils.getString ( headerHmChange , "PRE_INS_DATE" , "" ) ).trim ( ) ) ) {
                            	calPreInsDate = SepoaString.getDateSlashFormat( MapUtils.getString ( headerHm , "CONT_FROM" , MapUtils.getString ( headerHmChange , "CONT_FROM" , "" ) ).trim ( ) );     
                            }else{
                            	calPreInsDate = SepoaString.getDateSlashFormat( MapUtils.getString ( headerHm , "PRE_INS_DATE" , MapUtils.getString ( headerHmChange , "PRE_INS_DATE" , "" ) ).trim ( ) );
                            }
                        %>
                        <span id="viewSpan"><s:calendar id="pre_ins_date" default_value="<%=SepoaString.getDateSlashFormat(calPreInsDate)%>" format="%Y/%m/%d"/></span>
                    </td>
                    <td class="data_td_input" align="right">&nbsp;</td>
                    <td class="data_td_input" align="center">
                        <table cellpadding="2" cellspacing="0">
                            <tr>
                                <td><script language="javascript">btn("javascript:doBondSend('PREINF','SEND')","전송");</script></td>
                                <td><script language="javascript">btn("javascript:doBondSend('PREINF','DD')"  ,"취소");</script></td>
                                <td><script language="javascript">btn("javascript:doBondSend('PREINF','AP')"  ,"접수");</script></td>
                                <td><script language="javascript">btn("javascript:doBondSend('PREINF','RE')"  ,"거부");</script></td>
                                <td><script language="javascript">btn("javascript:doBondSend('PREINF','DE')"  ,"폐기");</script></td>
                                <td><script language="javascript">btn("javascript:doBondView('PREINF')"       ,"보기");</script></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class="title_td" align="center" style="padding-left: 0px;">계약이행보증</td>
                    <td class="data_td_input" align="right"><%=cont_ins_amt_temp %>&nbsp;&nbsp;</td>
                    <td class="data_td_input" align="right"><%=MapUtils.getString ( headerHm , "CONT_INS_PERCENT" , "0.00" ) %>&nbsp;%&nbsp;&nbsp;</td>
                    <td class="data_td_input">
                        <%
                        	String calContInsFrom = "";
                        	String calContInsTo = "";
                            if ( "".equals ( MapUtils.getString ( headerHm , "CONT_INS_FROM" , MapUtils.getString ( headerHmChange , "CONT_INS_FROM" , "" ) ).trim ( ) ) ) {
                            	calContInsFrom = SepoaString.getDateSlashFormat( MapUtils.getString ( headerHm , "CONT_FROM" , MapUtils.getString ( headerHmChange , "CONT_FROM" , "" ) ).trim ( ) );
                            }else{
                            	calContInsFrom = SepoaString.getDateSlashFormat( MapUtils.getString ( headerHm , "CONT_INS_FROM" , MapUtils.getString ( headerHmChange , "CONT_INS_FROM" , "" ) ).trim ( ) );
                            }
                            if ( "".equals ( MapUtils.getString ( headerHm , "CONT_INS_TO" , MapUtils.getString ( headerHmChange , "CONT_INS_TO" , "" ) ).trim ( ) ) ) {
                            	calContInsTo = SepoaString.getDateSlashFormat( MapUtils.getString ( headerHm , "CONT_TO" , MapUtils.getString ( headerHmChange , "CONT_TO" , "" ) ).trim ( ) );     
                            }else{
                            	calContInsTo = SepoaString.getDateSlashFormat( MapUtils.getString ( headerHm , "CONT_INS_TO" , MapUtils.getString ( headerHmChange , "CONT_INS_TO" , "" ) ).trim ( ) );
                            }
                        %>
                        <s:calendar id_from="cont_ins_from" default_from="<%=SepoaString.getDateSlashFormat(calContInsFrom)%>" id_to="cont_ins_to" default_to="<%=SepoaString.getDateSlashFormat(calContInsTo)%>" format="%Y/%m/%d"/>
                    </td>
                    <td class="data_td_input" align="right">&nbsp;</td>
                    <td class="data_td_input" align="center">
                        <table cellpadding="2" cellspacing="0">
                            <tr>
                                <td><script language="javascript">btn("javascript:doBondSend('CONINF','SEND')","전송");</script></td>
                                <td><script language="javascript">btn("javascript:doBondSend('CONINF','DD')"  ,"취소");</script></td>
                                <td><script language="javascript">btn("javascript:doBondSend('CONINF','AP')"  ,"접수");</script></td>
                                <td><script language="javascript">btn("javascript:doBondSend('CONINF','RE')"  ,"거부");</script></td>
                                <td><script language="javascript">btn("javascript:doBondSend('CONINF','DE')"  ,"폐기");</script></td>
                                <td><script language="javascript">btn("javascript:doBondView('CONINF')"       ,"보기");</script></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class="title_td" align="center" style="padding-left: 0px;">하자이행보증</td>
                    <td class="data_td_input" align="right"><%=fault_ins_amt_temp %>&nbsp;&nbsp;</td>
                    <td class="data_td_input" align="right"><%=MapUtils.getString ( headerHm , "FAULT_INS_PERCENT" , "0.00" ) %>&nbsp;%&nbsp;&nbsp;</td>
                    <td class="data_td_input">
                          <%=MapUtils.getString ( headerHm , "FAULT_INS_FROM" , "" ) %> 개월
                    </td>
                    <td class="data_td_input" align="right">&nbsp;</td>
                    <td class="data_td_input" align="center">
                        <table cellpadding="2" cellspacing="0">
                            <tr>
                                <td><script language="javascript">btn("javascript:doBondSend('FLRINF','SEND')","전송");</script></td>
                                <td><script language="javascript">btn("javascript:doBondSend('FLRINF','DD')"  ,"취소");</script></td>
                                <td><script language="javascript">btn("javascript:doBondSend('FLRINF','AP')"  ,"접수");</script></td>
                                <td><script language="javascript">btn("javascript:doBondSend('FLRINF','RE')"  ,"거부");</script></td>
                                <td><script language="javascript">btn("javascript:doBondSend('FLRINF','DE')"  ,"폐기");</script></td>
                                <td><script language="javascript">btn("javascript:doBondView('FLRINF')"       ,"보기");</script></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class="title_td" align="center" style="padding-left: 0px;">주민등록번호</td>
                    <td class="data_td_input" colspan="5" style="color: blue;font-weight: bold;">
                        <input type="text" id="resident_no" name="resident_no" maxlength="13" size="15"
                        onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;"
                        />
                        ※"-"를 제외한 13자리 주민등록번호를 입력해주세요.(개인사업자의 경우 주민등록번호는 필수사항입니다.)
                    </td>
                </tr>
                <tr> 
                    <td class="title_td" align="center" style="padding-left: 0px;">사유</td>
                    <td class="data_td_input" colspan="5" style="color: blue;font-weight: bold;">
                        <input type="text" id="docTypeFlagMessage" name="docTypeFlagMessage" style="width: 99%"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<%
    }
%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<%----------------------------------------------------------------------- 보증증권 -----------------------------------------------------------------------%>
<br>
<div class="inputsubmit" style="border: 0px;"><%=text.get ( "CT_001.TXT_101" ) %><%-- ◆ 계약서 약정서 선택 --%></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<table width="100%" height="3" border="0" cellspacing="0" cellpadding="0" bgcolor="#629DD9"><tr><td></td></tr></table>
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<colgroup>
					<col width="20%"/>
					<col width="40%"/>
					<col width="40%"/>
				</colgroup>
				<tr> 
					<td class="title_td"><%=text.get ( "CT_001.TXT_102" ) %><%-- 확약서 선택 --%></td>
					<td class="data_td_input">
						<select class="div_data_no" id="attach_no" name="attach_no"/>
					</td>
					<td class="data_td_input">
						<script language="javascript">btn("javascript:attachFileDownload('attach_no')","보기")</script>
					</td>
				</tr>
				<tr> 
					<td class="title_td"><%=text.get ( "CT_001.TXT_103" ) %><%-- 약정서 선택 --%></td>
					<td class="data_td_input">
						<input type="radio" name="yak" class="div_data_no" style="border: 0px;"
						onclick="attachSelect1()"
						<%=attachSelect1 %>
						/>
						<select class="div_data_no" id="attach_no1" name="attach_no1"/>
					</td>
					<td class="data_td_input">
						<script language="javascript">btn("javascript:attachFileDownload('attach_no1')","보기")</script>
					</td>
				</tr>
				<tr> 
					<td class="title_td"><%=text.get ( "CT_001.TXT_104" ) %><%-- 약정서 첨부 --%></td>
					<td class="data_td_input" colspan="2">
                    <table>
                        <tr>
                            <td>
								<input type="radio" name="yak" class="div_data_no" style="border: 0px;"	onclick="attachSelect2()" <%=attachSelect2 %>/>
								<input type="hidden" name="attach_no2" id="attach_no2" readonly value="<%=MapUtils.getString ( headerHm , "ATTACH_NO2" , MapUtils.getString ( headerHmChange , "ATTACH_NO2" , "" ) ) %>">
					      		<input type="hidden" name="attach_name2" class="div_empty_no" size = "37" readonly value="<%=MapUtils.getString ( headerHm , "ATTACH_NAME2" , MapUtils.getString ( headerHmChange , "ATTACH_NAME2" , "" ) ) %>">
                            </td>
                            <td>
        						<div id="attImg2" style="display: none;"></span>
                                <%if(!"VI".equals ( p_view )){ %>
                                <script language="javascript">btn("javascript:attachFile(document.forms[0].attach_no2.value,'CT','attach_no2')","<%=text.get("CT_001.ATTACH_NO")%>")</script>
                                <%} else { %>
                                <script language="javascript">btn("javascript:javascript:FileAttach('CT',document.forms[0].attach_no2.value,'VI');","<%=text.get("CT_001.ATTACH_NO")%>")</script>
                                <%} %>
                                
                                
                                </span>
                            </td>
                            <td>
                                <div id="attach_no2_text"></div>
                           </td>
                        </tr>
                    </table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br>
<div class="inputsubmit" style="border: 0px;"><%=text.get ( "CT_001.TXT_105" ) %><%-- ◆ 계약 건적서 첨부 --%></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<table width="100%" height="3" border="0" cellspacing="0" cellpadding="0" bgcolor="#629DD9"><tr><td></td></tr></table>
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<colgroup>
					<col width="20%"/>
					<col width="80%"/>
				</colgroup>
				<tr> 
					<td class="title_td"><%=text.get ( "CT_001.TXT_106" ) %><%-- 견적서 첨부 --%></td>
					<%-- 
					<td class="data_td_input">
		      		<input type="text" name="attach_name3" class="div_empty_no" size = "37" readonly value="<%=MapUtils.getString ( headerHm , "ATTACH_NAME3" , MapUtils.getString ( headerHmChange , "ATTACH_NAME3" , "" ) ) %>">
					</td>
					 --%>
					<td class="data_td_input">
                    <table>
                        <tr>
                            <td>
								<input type="hidden" name="attach_no3" id="attach_no3" readonly value="<%=MapUtils.getString ( headerHm , "QTA_ATTACH_NO" , MapUtils.getString ( headerHm , "ATTACH_NO3" , "" ) ) %>">
        						<%-- <script language="javascript">btn("javascript:attachFile(document.forms[0].attach_no3.value,'CT','attach_no3')","<%=text.get("CT_001.ATTACH_NO")%>")</script> --%>
        						<script language="javascript">btn("javascript:javascript:FileAttach('SELLER',document.forms[0].attach_no3.value,'VI');","<%=text.get("CT_001.ATTACH_NO")%>")</script>
                            </td>
                            <td>
                                <div id="attach_no3_text"></div>
                           </td>
                        </tr>
                    </table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br>
<div class="inputsubmit" style="border: 0px;"><%=text.get ( "CT_001.TXT_107" ) %><%-- ◆ 계약 첨부 파일 --%></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<table width="100%" height="3" border="0" cellspacing="0" cellpadding="0" bgcolor="#629DD9"><tr><td></td></tr></table>
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<colgroup>
					<col width="20%"/>
					<col width="80%"/>
				</colgroup>
				<tr> 
					<td class="title_td"><%=text.get ( "CT_001.TXT_108" ) %><%-- 파일 첨부 --%></td>
					<td class="data_td_input">
                    <table>
                        <tr>
                            <td>
                            	<input type="hidden" name="attach_name4" class="div_empty" size = "37" readonly value="<%=MapUtils.getString ( headerHm , "ATTACH_NAME4" , MapUtils.getString ( headerHmChange , "ATTACH_NAME4" , "" ) ) %>">
                                <input type="hidden" name="attach_no4" id="attach_no4" readonly value="<%=MapUtils.getString ( headerHm , "ATTACH_NO4" , MapUtils.getString ( headerHmChange , "ATTACH_NO4" , "" ) ) %>">
        						<%if(!"VI".equals ( p_view )){ %>
                                <script language="javascript">btn("javascript:attachFile(document.forms[0].attach_no4.value,'CT','attach_no4')","<%=text.get("CT_001.ATTACH_NO")%>")</script>
                                <%} else { %>
                                <script language="javascript">btn("javascript:javascript:FileAttach('CT',document.forms[0].attach_no4.value,'VI');","<%=text.get("CT_001.ATTACH_NO")%>")</script>
                                <%} %>
                            </td>
                            <td>
                                <div id="attach_no4_text"></div>
                           </td>
                        </tr>
                    </table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br style="display: none;">
<div class="inputsubmit" style="border: 0px;display: none;"><%=text.get ( "CT_001.TXT_109" ) %><%-- ◆ 권한 설정 --%></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0" style="display: none;">
	<tr>
		<td>
			<table width="100%" height="3" border="0" cellspacing="0" cellpadding="0" bgcolor="#629DD9"><tr><td></td></tr></table>
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<colgroup>
					<col width="20%"/>
					<col width="40%"/>
					<col width="40%"/>
				</colgroup>
				<tr> 
					<td class="data_td_input" style="padding-left: 40px;">
						<%=text.get ( "CT_001.TXT_110" ) %><%-- 계약서 해당 팀 공유 --%> <input class="inputsubmit" type="checkbox" name="team_view"           id="team_view"           style="border: 0px;" <%=MapUtils.getString ( headerHm , "TEAM_VIEW" , "" ) %>/>
						<br>
						<%=text.get ( "CT_001.TXT_111" ) %><%-- 계약서 다른 팀 공유 --%> <input class="inputsubmit" type="checkbox" name="different_team_view" id="different_team_view" style="border: 0px;" <%=MapUtils.getString ( headerHm , "DIFFERENT_TEAM_VIEW" , "" ) %>/>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br style="display: none;">
<div class="inputsubmit" style="border: 0px;" style="display: none;"><%=text.get ( "CT_001.TXT_112" ) %><%-- ◆ 승인 요청 --%></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0" style="display: none;">
	<tr>
		<td>
			<table width="100%" height="3" border="0" cellspacing="0" cellpadding="0" bgcolor="#629DD9"><tr><td></td></tr></table>
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<colgroup>
					<col width="20%"/>
					<col width="40%"/>
					<col width="40%"/>
				</colgroup>
				<tr> 
					<td class="data_td_input" style="padding-left: 40px;">
						<%=text.get ( "CT_001.TXT_113" ) %><%-- 팀장 승인요청 --%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" name="app_team_manager"      id="app_team_manager"      class="inputsubmit" style="border: 0px;" <%=MapUtils.getString ( headerHm , "APP_TEAM_MANAGER" , "" ) %>/>&nbsp;
						<span id="viewSpan"><input type="text"     name="app_team_manager_text" id="app_team_manager_text" class="inputsubmit" style="width: 70%" value="<%=MapUtils.getString ( headerHm , "APP_TEAM_MANAGER_TEXT" , "" ) %>"></span>
						<br>
						<%=text.get ( "CT_001.TXT_114" ) %><%-- 법무 승인요청 --%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" name="app_judicial"        id="app_judicial"       class="inputsubmit" style="border: 0px;" <%=MapUtils.getString ( headerHm , "APP_JUDICIAL" , "" ) %>/>&nbsp;
						<span id="viewSpan"><input type="text"     name="app_judicial_text"   id="app_judicial_text"  class="inputsubmit" style="width: 70%" value="<%=MapUtils.getString ( headerHm , "APP_JUDICIAL_TEXT" , "" ) %>"></span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br>
<div class="inputsubmit_no" style="border: 0px;"><%=text.get ( "CT_001.TXT_115" ) %><%-- ◆ 협력업체 담당자 정보 --%></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<table width="100%" height="3" border="0" cellspacing="0" cellpadding="0" bgcolor="#629DD9"><tr><td></td></tr></table>
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<colgroup>
					<col width="20%"/>
					<col width="40%"/>
					<col width="40%"/>
				</colgroup>
				<tr> 
					<td class="data_td_input" style="padding-left: 40px;">
						<%=text.get ( "CT_001.TXT_116" ) %><%-- 담당자 연락처 --%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<%
						//담당자 전화번호 가져와서 뿌려주기
						String qtaMobileNumber = SepoaString.decString ( MapUtils.getString ( headerHm , "MOBILE_NO" , "" ) , "PHONE" );//.replaceAll ( "-" , "" );
						String QMN = "";
						if(!"".equals ( qtaMobileNumber ) ){
						    int qtaMobileNumberLength = qtaMobileNumber.length (  );
						    if(qtaMobileNumberLength == 11){
						        headerHm.put ( "PERSON_CHARGE_PHONE1" , qtaMobileNumber.substring ( 0 , 3 ) );
						        headerHm.put ( "PERSON_CHARGE_PHONE2" , qtaMobileNumber.substring ( 3 , 7 ) );
						        headerHm.put ( "PERSON_CHARGE_PHONE3" , qtaMobileNumber.substring ( 7 , 11 ) );
						    }else if(qtaMobileNumberLength == 10){
						        headerHm.put ( "PERSON_CHARGE_PHONE1" , qtaMobileNumber.substring ( 0 , 3 ) );
						        headerHm.put ( "PERSON_CHARGE_PHONE2" , qtaMobileNumber.substring ( 3 , 6 ) );
						        headerHm.put ( "PERSON_CHARGE_PHONE3" , qtaMobileNumber.substring ( 6 , 10 ) );
						    }
						}
						%>
						<span id="viewSpan"><input type="text" name="person_charge_phone1" id="person_charge_phone1" class="inputsubmit_no" size="3" value="<%=MapUtils.getString ( headerHm , "PERSON_CHARGE_PHONE1" , MapUtils.getString ( headerHmChange , "PERSON_CHARGE_PHONE1" , "" ) ) %>" onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;"></span> -
						<span id="viewSpan"><input type="text" name="person_charge_phone2" id="person_charge_phone2" class="inputsubmit_no" size="4" value="<%=MapUtils.getString ( headerHm , "PERSON_CHARGE_PHONE2" , MapUtils.getString ( headerHmChange , "PERSON_CHARGE_PHONE2" , "" ) ) %>" onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;"></span> -
						<span id="viewSpan"><input type="text" name="person_charge_phone3" id="person_charge_phone3" class="inputsubmit_no" size="4" value="<%=MapUtils.getString ( headerHm , "PERSON_CHARGE_PHONE3" , MapUtils.getString ( headerHmChange , "PERSON_CHARGE_PHONE3" , "" ) ) %>" onkeypress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;"></span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<center>
<table>
	<tr>
	<%--<td>CT_FLAG:<%=MapUtils.getString ( headerHm , "CT_FLAG" , "" ) %>p_view:<%=p_view%>originalDocType:<%=originalDocType%>buttonText:<%=buttonText%></td>--%>
<%if(!"CD".equals ( MapUtils.getString ( headerHm , "CT_FLAG" , "" ) ) ){ %>
	<% if(
            !"VI".equals ( p_view ) 
         || ("S".equals ( info.getSession ( "USER_TYPE" ) ) && !"CE".equals ( MapUtils.getString ( headerHm , "CT_FLAG" , "" ) ) )  
         //|| "SS".equals ( originalDocType ) 
         || "BA".equals ( originalDocType ) 
       ) {
    %>
		<td><script language="javascript">btn("javascript:doInsert('');","<%=buttonText%>")</script></td>
	<% } %>
    
	<% if(
            ("".equals ( p_cont_no ) || "CT".equals ( MapUtils.getString ( headerHm , "CT_FLAG" , "" ) ) ) 
         || ( !"S".equals ( info.getSession ( "USER_TYPE" ) ) && "CE".equals ( MapUtils.getString ( headerHm , "CT_FLAG" , "" ) ) ) 
         && !"VI".equals ( p_view ) 
    ){ %>
		<td><script language="javascript">btn("javascript:doInsert('SEND');","<%=text.get ( "CT_001.TXT_003" ) %>")</script></td><!-- 업체전송 -->
	<% } %>
<%} %>
    
    <%
        if ( !"".equals ( MapUtils.getString ( headerHm , "CT_FLAG" , "" ).trim (  ) ) ){
    %>
            <script>
            /*
             *   한글 발주서 생성 
             */
             function doPdf(){
                 document.form.method = "POST";
                 document.form.target = "ifr_pdf";
                 document.form.action = "contract_insert_pdf.jsp";
                 document.form.submit();
             }
            </script>
            <td><script language="javascript">btn("javascript:doPdf();","PDF저장")</script></td>
            <iframe  name="ifr_pdf"  src="" style="width:0;height:0;visibility: hidden;"></iframe> 
    <%
        }
    %>
	</tr>
</table>
</center>
</div>	
</form>
</s:header>
<%-- 파일다운로드용 시작 --%>
<form name="downloadForm" action="../sepoafw/file/file_download2.jsp" method="post" target="actionFrame">
	<input type="hidden" name="doc_no"/>
</form>
<%-- 파일다운로드용 끝   --%>
<iframe name="actionFrame" width="0" height="0"></iframe>
</body>
</html>