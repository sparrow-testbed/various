<!DOCTYPE html>
<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>

<%

	Vector multilang_id = new Vector();
	multilang_id.addElement("p1015");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	Config  conf    = new Configuration();

	String house_code = info.getSession("HOUSE_CODE");
	String item_no = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("item_no")));

%>

<html>
<head>

<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/include_css.jsp"%><!-- CSS  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"%><!-- AJAX SELECTBOX -->
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

<script type="text/javascript">
function init(){
	
	var nickName = "p1015";
	var conType = "CONNECTION";
	var methodName = "getImageFile";
	var SepoaOut = doServiceAjax( nickName, conType, methodName );

	if(SepoaOut.status == '0') {
		alert("이미지를 조회할 수 없습니다.");
	} else {
		var rs = (SepoaOut.result[0]).split("<%=conf.getString( "sepoa.separator.line" )%>");
        var rs1 = rs[1].split("<%=conf.getString( "sepoa.separator.field" )%>");
		document.write("<img id='img01' name='img02'  src='" + rs1[0] + "' onload='img_resize(this)' onclick='window.close()'>");
	}
	
}

function img_resize(imgObj) {
	
	//이미지 리사이즈 초기화
	var resize_width = "0";
	var resize_height = "0";
	
	//원본 이미지 사이즈 저장
	var width = imgObj.width;
	var height = imgObj.height;
	
	//가로, 세로 최대 사이즈 설정
	var max_width = "800";
	var max_height = "600";

	if( width > max_width || height > max_height ) {//가로나 세로의 길이가 최대 사이즈보다 크면 실행
		
		if( width > height ) {//가로가 세로보다 크면 가로는 최대 사이즈로 하고, 세로는 비율 맞춰 리사이즈
			resize_width = max_width;
			resize_height = Math.round( ( height * resize_width ) / width );
		} else {//세로가 가로보다 크면 세로는 최대 사이즈로 하고, 가로는 비율 맞춰 리사이즈
			resize_height = max_height;
			resize_width = Math.round( ( width * resize_height ) / height );
		}
		
	} else {//최대 사이즈보다 크지 않으면 실행
		resize_width = width;
		resize_height = height;
	}
	
	//리사이즈 크기로 이미지 크기를 재지정
	imgObj.width = resize_width;
	imgObj.height = resize_height;
	
}

</script>

</head>

<body leftmargin="10" topmargin="10">
<%-- <s:header popup="true"> --%>

	<table width="100%" height="100%" border="1" cellpadding="0" cellspacing="0">
	<form id="form" name="form">
		<input type="hidden" id="house_code" name="house_code" value="<%=house_code%>">
		<input type="hidden" id="item_no" name="item_no" value="<%=item_no%>">
		<tr>
			<td width="98%" height="98%" align="center">
				<script>javascript:init();</script>
			</td>
		</tr>
	</form>
	</table>
	
<%-- </s:header>	 --%>
<%-- <s:footer/> --%>
</body>
</html>