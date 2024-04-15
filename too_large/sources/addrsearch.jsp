<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	SepoaInfo info = new SepoaInfo("000", "ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL");
%>
<html>
<head>
	<title></title>
	<style>
		.buttons_base {
			font-family:Dotum;
			border: 1px solid #5AC6EA;
			cursor: pointer;
			height: 22px;
			font-size: 13px;
			text-align: center;
			vertical-align: middle;
		}

		.button_table {
			color: #000000;
			text-align:center;
			vertical-align: middle;
		}
	</style>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/include_css.jsp"%>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script type="text/javascript" src="../js/lib/sec.js"></script>
<script type="text/javascript" src="../js/lib/jslb_ajax.js"></script>
<script type="text/javascript" src="../js/cal.js"></script>
<script language="javascript">
var objData    = null;
var searchFlag = "dong";
		
function searchTypeChage(flag){
	if(flag == "dong"){
		searchFlag = "dong";
		document.all.dongDiv.style.display = "";
		document.all.roadDiv.style.display = "none";
		document.all.button1.style.backgroundColor = "#5AC6EA";
		document.all.button2.style.backgroundColor = "#ffffff";
		document.all.button1.style.color = "#ffffff";
		document.all.button2.style.color = "#4084C2";

		// 도로명 안내 문구 숨기기
		displayDiv( "div_road_info" , "none" );

		// 데이터 조회 창 숨기기
		displayDiv( "divRoadData"   , "none" );
		displayDiv( "divDongData"   , "none" );
	}
	else if (flag == "road"){
		searchFlag = "road";
		document.all.dongDiv.style.display = "none";
		document.all.roadDiv.style.display = "";
		document.all.button1.style.backgroundColor = "#ffffff";
		document.all.button2.style.backgroundColor = "#5AC6EA";
		document.all.button1.style.color = "#4084C2";
		document.all.button2.style.color = "#ffffff";

		// 도로명 안내 문구 보이기
		displayDiv( "div_road_info" , "block" );

		// 데이터 조회 창 숨기기
		displayDiv( "divRoadData"   , "none" );
		displayDiv( "divDongData"   , "none" );
	}
			
	document.forms[0].searchFlagInput.value = searchFlag;
	objData = null;
}

/**
 * 조회 로직 시작.
 * 해당 데이터의 조회 조건을 입력을 확인한다.
 */
function doSelect(){
	objData = null;
			
	var roadbuilding    = document.forms[0].roadbuilding.value;
	var sido            = document.forms[0].sido.value;
	var sigungu         = document.forms[0].sigungu.value;
	var dong            = document.forms[0].dong.value;

	if(searchFlag == "road"){
		if(isEmpty(sido)) {
			alert('시도를 선택해주세요.');
			
			return;
		}
		else if(isEmpty(sigungu)) {
			alert('시군구를 선택해주세요.');
			
			return;
		}
		else if(isEmpty(roadbuilding)) {
			alert('도로명+건물주소를 입력해주세요.');
			
			return;
		}
		
		displayDiv( "div_road_info" , "none"  );
		displayDiv( "divRoadData"   , "block" );
		displayDiv( "divDongData"   , "none"  );
	}
	else if (searchFlag == "dong"){
		if(isEmpty(dong)) {
			alert('주소를 입력해주세요.');
			
			return;
		}
				
		displayDiv( "divRoadData"   , "none"  );
		displayDiv( "divDongData"   , "block" );
	}
			
	doSelectRun();
}

function doSelectRun(){
	var nickName        = "SIF_001";
	var conType         = "CONNECTION";
	var methodName      = "callAjax_ZipCodeList";
	var SepoaOut        = doServiceAjax( nickName, conType, methodName );
	
	objData = eval('(' + SepoaOut.result + ')');

	var workObj = null;
	var dataObj = null; 
	var dataOpt = null;
			
	if( searchFlag == "dong" ){
		workObj = document.getElementById("selectDongData");
	}
	else if(searchFlag == "road"){
		workObj = document.getElementById("selectRoadData");
	}

	var zip_code = null;
	var address  = null;
	var value    = null;
			
	workObj.length = 0;
			
	for( var i = 0 , iMax = objData.length ; i < iMax ; i++ ){
		dataObj = getData( i );
		zip_code = dataObj.zip_code;
		address  = dataObj.address;
		value    = dataObj.value;
				
		dataOpt = new Option();
		dataOpt.value = value;
		dataOpt.text  = "[ " + zip_code + " ] " + address;
				
		workObj.options[i] = dataOpt;
	}
			
	if( objData.length == 0 ){
		workObj.options[i] = new Option( "조회된 데이터가 없습니다." , "" );
	}
} // end of function doSelectRun

function getData( i ){
	var obj  = new Object();
			
	var address  = null;
	var zip_code = null;
	var zipcode  = null;
			
	if( "road" == searchFlag ){
		zip_code =  objData[i].zip_cd;;
		zipcode  = objData[i].zip_cd;
		value    = i;
		address  = objData[i].sido;
				
		if( objData[i].sigungu != null && objData[i].sigungu != ""){
			address  += " " + objData[i].sigungu;
		}

		if( objData[i].eupmyun != null && objData[i].eupmyun != ""){
			address  += " " + objData[i].eupmyun;
		}

		if( objData[i].road_nm != null && objData[i].road_nm != ""){
			address  += " " + objData[i].road_nm;
		}

		if( objData[i].build_num1 != null && objData[i].build_num1 != ""){
			address  += " " + objData[i].build_num1;
		}

		if( objData[i].build_num2 != null && objData[i].build_num2 != ""){
			address  += "-" + objData[i].build_num2;
		}
	}
	else if( searchFlag == "dong" ){
		zip_code =  objData[i].zip_cd;;
		zipcode  = objData[i].zipcode;
		value    = i;
		address  = objData[i].sido_name;
				
		if( objData[i].gugun_name != null && objData[i].gugun_name != ""){
			address  += " " + objData[i].gugun_name;
		}
				
		if( objData[i].dong_name != null && objData[i].dong_name != ""){
			address  += " " + objData[i].dong_name;
		}
				
		if( objData[i].bunji_name != null && objData[i].bunji_name != ""){
			address  += " " + objData[i].bunji_name;
		}
				
		if( objData[i].ree_name != null && objData[i].ree_name != ""){
			address  += " " + objData[i].ree_name;
		}
				
		if( objData[i].apt_name != null && objData[i].apt_name != ""){
			address  += " " + objData[i].apt_name;
		}
	}
			
	obj.address  = address;
	obj.zip_code = zip_code;
	obj.zipcode  = zipcode;
	obj.value    = i;
			
	return obj;
}

function selectAddr(zip, addr, addr2, city) {
	addr2 = LRTrim(LRTrim(LRTrim(LRTrim(LRTrim(LRTrim(LRTrim(LRTrim(LRTrim(addr2)))))))));
	
	//opener.SetZipCode(zip.substring(0,3), zip.substring(3,6), addr2, '','','','','');
	opener.selectAddr(zip, addr, addr2, city);
	self.close();
}

//enter를 눌렀을때 event발생
function entKeyDown(){
	if(event.keyCode==13) {
		doSelect();
	}
}

//시도 셀렉트 박스 선택 이벤트
function sigunguRequest(){
	var sido    = document.forms[0].sido;
	var value   = sido.value;
	var sigungu = document.forms[0].sigungu;
	
	sigungu.length = 1;
			
	doRequestUsingPOST( 'SL0129', value+"#1", 'sigungu', '');
}

function sigunguTdChange(htmlTag){
	document.getElementById("sigungutd").innerHTML = htmlTag;
}

		
/* 
 * 입력 받은 div 를 display 값에 따라 view, hidden 처리 한다.
 * display : none   - hidden
 *           block  - view
 *
 */
function displayDiv( id , display ){
	document.getElementById( id ).style.display = display;
}

function doSelectData(){
	var	workObj = null;

	if( "road" == searchFlag ){
		workObj = document.getElementById("selectRoadData");
	}
	else if( searchFlag == "dong" ){
		workObj = document.getElementById("selectDongData");
	}
	
	if(workObj.value == null || workObj.value == ""){
		return;
	}
				
	var obj = getData( workObj.value );
	var zipCode = obj.zip_code;
	zipCode = zipCode.replace("-", "");
	//opener.SetZipCode( obj , objData );
	opener.selectAddr(zipCode, '', obj.address, '');
			
	close();
}
</script>
</head>
<BODY onload="window.resizeTo('450','500');searchTypeChage('road');">
<s:header popup="true">
	<form name="form1" method="post">
		<input type="hidden" name="searchFlag" >
		<input type="hidden" id="searchFlagInput" name="searchFlagInput" value="dong">
		<input type="hidden" name="mode">
		<input type="hidden" name="mode">
		<input type="hidden" id="re"           name="re" class="input_data2" style="width:0%" readOnly>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class='title_page'>우편번호 검색
	</td>
</tr>
</table>
		
		
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<%--  우편번호 검색 상단 타이틀 --%>

			<tr>
				<td colspan="2">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="760" height="2" bgcolor="#0072bc"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr height="5px">
				<td></td>
			</tr>
			<%-- 우편번호 구 주소, 도로명 주소 검색 선택 버튼 --%>
			<tr style="display: none;">
				<td>
					<div id="button1" class="buttons_base" style="background-color: #5AC6EA;color: #ffffff;" onclick="searchTypeChage('dong')">
						<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="button_table"><B>동명으로 구주소 검색</B></td>
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div id="button2" class="buttons_base" style="background-color: #ffffff;color: #5AC6EA;" onclick="searchTypeChage('road')">
						<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="button_table">
									<B>도로명으로 새주소 검색</B>
								</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
			<%-- 우편번호 구 주소 조회 입력 창 --%>
			<tr>
				<td colspan="2">
					<div id="dongDiv">
						<table cellpadding="0" cellspacing="0" width="100%" border="0" align="center">
							<tr>
								<td>
									<table cellpadding="0" cellspacing="0" width="100%" border="0" align="center">
										<tr>
											<td valign="top" width=98%>
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr height="10px">
														<td></td>
													</tr>
													<tr>
														<td align="left">
															<b>* 찾고자하는 주소의 동(읍/면/리)을 입력해주시기 바랍니다.</b>
														</td>
													</tr>
													<tr>
														<td align="left"></td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<table cellpadding="0" cellspacing="0" width="100%" border="0" align="center">
										<tr>
											<td width="*">
												<table width="100%" height="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="ccd5de">
													<tr>
														<td class="title_td" width="35%">
															<img src="../images/home/arr.gif" align="absmiddle">&nbsp; 동(읍/면/리)
														</td>
														<td class="data_td"  width="*"  >
															<input type="text"   id="dong" name="dong" class="inputsubmit" style="width: 98%;" onKeyDown="javascript:if(event.keyCode== 13)doSelect();">
															<input type="hidden" id="re"   name="re" class="input_data2" readOnly>
														</td>
													</tr>
												</table>
											</td>
											<td width="15%">
												<table height="100%" border="0">
													<tr>
														<td style="vertical-align: middle;">
<script language="javascript">
	btn("javascript:doSelect()", "조 회");
</script>
														</td>
													</tr>
												</table>
											</td>
										</tr>			
									</table>
								</td>
							</tr>
							<tr height="5px">
								<td></td>
							</tr>
							<tr>
								<td>
									<div id="divDongData" style="width:100%;height:285px;">
										<select id="selectDongData" style="width:100%;height:100%;" size="11" onClick="doSelectData()"></select>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
			<%-- 우편번호 도로명 주소 입력창 --%>
			<tr>
				<td colspan="2">
					<div id="roadDiv" style="display: none;">
						<table width="100%" border="0" cellspacing="0" cellpadding="1">
							<tr>
							<td>
							<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
							<tr>
							<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td class="title_td" align="left" style="padding: 0px;" width="35%">
															&nbsp;
															<img src="../images/home/arr.gif" align="absmiddle">
															&nbsp;시도
														</td>
														<td class="data_td"  align="left" style="padding: 1px;" width="*">
															<select id="sido" class="input_re" onchange="sigunguRequest()">
<%-- //시도 GROUP BY 해서 가져오는데 시간이 오래걸려서 주석처리
<%
	String sido = ListBox(info, "SL0097", info.getSession("HOUSE_CODE")+"#M217" , "" );
	out.print(sido);
											
%>
--%>
																<option value="">선택</option>
																<OPTION VALUE="강원">강원도</OPTION>
																<OPTION VALUE="경기">경기도</OPTION>
																<OPTION VALUE="경남">경상남도</OPTION>
																<OPTION VALUE="경북">경상북도</OPTION>
																<OPTION VALUE="광주">광주광역시</OPTION>
																<OPTION VALUE="대구">대구광역시</OPTION>
																<OPTION VALUE="대전">대전광역시</OPTION>
																<OPTION VALUE="부산">부산광역시</OPTION>
																<OPTION VALUE="서울">서울특별시</OPTION>
																<OPTION VALUE="세종">세종특별자치시</OPTION>
																<OPTION VALUE="울산">울산광역시</OPTION>
																<OPTION VALUE="인천">인천광역시</OPTION>
																<OPTION VALUE="전남">전라남도</OPTION>
																<OPTION VALUE="전북">전라북도</OPTION>
																<OPTION VALUE="제주">제주특별자치도</OPTION>
																<OPTION VALUE="충남">충청남도</OPTION>
																<OPTION VALUE="충북">충청북도</OPTION>
															</select>
														</td>
													</tr>
													<tr>
														<td colspan="2" height="1" bgcolor="#dedede"></td>
													</tr>
													<tr>
														<td class="title_td" align="left" style="padding: 0px;" width="35%">
															&nbsp;
															<img src="../images/home/arr.gif" align="absmiddle">&nbsp;시군구
														</td>
														<td class="data_td"  align="left" style="padding: 1px;" width="*" id="sigungutd">
															<select id="sigungu" name="sigungu" class="input_re">
																<option value="">선택</option>
															</select>
														</td>
													</tr>
													<tr>
														<td colspan="2" height="1" bgcolor="#dedede"></td>
													</tr>
													
													<tr>
														<td class="title_td" width="35%" style="padding: 0px;">
															&nbsp;
															<img src="../images/home/arr.gif" align="absmiddle">
															&nbsp;도로명 + 건물번호
														</td>
														<td class="data_td"  width="*"   style="padding: 1px;">
															<input type="text" id="roadbuilding" name="roadbuilding" class="inputsubmit" style="width:90%;" onKeyDown="javascript:if(event.keyCode== 13)doSelect();">
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
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td align="right">
											<table><tr>
											<td bgcolor="#ffffff">
												<script language="javascript">
													btn("javascript:doSelect()","조 회");
												</script>
											</td>
											</tr></table>

											</td>
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
								<td>
									<div id="div_road_info">
										<table width="100%" border="0" cellpadding="0" cellspacing="0" >
											<tr>
												<td class="data_td"  width="*" colspan="4">
													<b>
														*새주소검색방법 : <br>
														시도/시군구 선택후,도로명(~로,~길)+건물번호 입력 후 검색<br>
													</b>
													(1)서울시 송파구 잠실로 51-33<br>
													예)'서울시 송파구'(버튼에서 선택),'잠실로 51-33'(도로명+건물번호 입력)<br>
													(2)서울시 강동구 상암로63길 39<br>
													예)'서울시 강동구'(버튼에서 선택),'상암로63길 39'(도로명+건물번호 입력)<br>
													<br>
													새주소가 검색되지 않는 경우는 행정안전부 새주소안내시스템<br>
													홈페이지(<a href="http://www.juso.go.kr" target="_blank">http://www.juso.go.kr</a>)에서 확인하시기 바랍니다.<br>
												</td>
											</tr>
										</table>
									</div>
								</td>
							</tr>
							<tr>
								<td>
									<div id="divRoadData" style="width:100%;height:245px;">
										<select id="selectRoadData" style="width:100%;height:100%;" size="11" onClick="doSelectData()"></select>
									</div>
								</td>
							</tr>
						</table>
						</td>
						</tr>
						</table>
						</td>
						</tr>
						</table>
												
					</div>
				</td>
			</tr>
		</table>
	</form>
</s:header>
<s:footer/>
</BODY>
</HTML>
