<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
    String file_type = JSPUtil.nullToEmpty(request.getParameter("file_type"));
    String att_no    = JSPUtil.nullToEmpty(request.getParameter("att_no"));
 	String att_mode  = JSPUtil.nullToRef(request.getParameter("att_mode"), "S");

	String G_separatorfield = "";
	String G_attach_count   = "";
	String G_attach_maxsize = "";
	String G_not_type = "";
	try {
    	Config conf = new Configuration();

    	G_separatorfield = conf.get("sepoa.separator.field");
    	//G_attach_count   = conf.get("wisehub.attach.count");
    	G_attach_count   = "0";
    	G_attach_maxsize = conf.get("sepoa.attach.maxsize");
    	G_not_type = conf.get("sepoa.file.attach.type") ;

    	if ((G_attach_maxsize == null) || (G_attach_maxsize.equals(""))) {
    		G_attach_maxsize = "1000"; // default (1G)
    	}
	} catch(Exception e) {
		throw e;
	}
%>

<html>
<head>
<title>File</title>

<script src="/rMateFM/js/AC_OETags.js" language="javascript"></script>
<script src="/rMateFM/js/rMateFileManagerLicense.js" language="javascript"></script>

<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<form name="f1" method="post" action="">
<input type="hidden" name="filename">
<input type="hidden" name="filesize">
<input type="hidden" name="fileid">
<input type="hidden" name="result">

<input type="hidden" name="att_mode" value="<%=att_mode%>">
<input type="hidden" name="att_no" value="<%=att_no%>"> <%-- return values --%>
<input type="hidden" name="att_data">                   <%-- return values --%>


<script language="JavaScript" type="text/javascript">
<!--
<%--
///////// 컴포넌트 설정값 세팅 시작 ///////////
// uploader 컴포넌트의 property를 넣기위한 변수
// 사용환경에 맞게 수정해서 사용하시기 바랍니다.
// uploadUrl, uploadFieldName는 환경에 맞게 반드시 설정하시기 바랍니다.
--%>
var uploadUrl = encodeURIComponent("/rMateFM/rMateUpload.jsp?file_type=<%=file_type%>");	// 업로드 URL
var flashVars = "uploadUrl="+uploadUrl;
var uploadFieldName = "FileData";				// 업로드시 서버에 전달할 파일의 필드명

flashVars += "&uploadFieldName="+uploadFieldName;
flashVars += "&flash.system.System.useCodePage=true";

var maxFileCount = <%=G_attach_count%>;			// 최대 업로드파일 수 -> 0이면 무제한
flashVars += "&maxFileCount="+maxFileCount;

var maxUploadSize = <%=G_attach_maxsize%>;		// 최대 업로드 MByte -> 0이면 무제한
flashVars += "&maxUploadSize="+maxUploadSize;

var previewEnable = "false";					// 업로드 파일에 대한 preview 표시 여부
flashVars += "&previewEnable="+previewEnable;

<%--
//var fileFilterDescription = "image";			// 업로드 파일 선택 확장자 설명 - 1종류만 처리할 경우에 사용하며, 여러개를 처리할 경우 아래의 setFileFilters를 참조하세요
//flashVars += "&fileFilterDescription="+encodeURIComponent(fileFilterDescription);
--%>
var fileFilterExtension = "*.jpg;*.gif;*.png";	// 업로드 파일 선택 확장자 - 1종류만 처리할 경우에 사용하며, 여러개를 처리할 경우 아래의 setFileFilters를 참조하세요
flashVars += "&fileFilterExtension="+encodeURIComponent(fileFilterExtension);

var forbiddenExtensions = "<%=G_not_type%>";			// 업로드 금지 확장자
flashVars += "&forbiddenExtensions="+forbiddenExtensions;

<%--
//var forbiddenExtensions = "jsp,zip";			// 업로드 금지 확장자
//flashVars += "&forbiddenExtensions="+forbiddenExtensions;

//var showUploadBtn = true;						// 업로드 버튼 표시 여부
//flashVars += "&showUploadBtn="+showUploadBtn;

//var uploadBtnLabel = "업로드";					// 업로드 버튼의 라벨
//flashVars += "&uploadBtnLabel="+encodeURIComponent(uploadBtnLabel);

//var fileAddBtnLabel = "파일 추가";				// 업로드 파일 추가 버튼의 라벨
//flashVars += "&fileAddBtnLabel="+encodeURIComponent(fileAddBtnLabel);

//var fileRemoveBtnLabel = "파일 삭제";			// 업로드 파일 삭제 버튼의 라벨
//flashVars += "&fileRemoveBtnLabel="+encodeURIComponent(fileRemoveBtnLabel);

//var fontSize = 11;							// 업로더 Font크기.
//flashVars += "&fontSize="+fontSize;

//var uploadBtnImageUrl = encodeURIComponent("/flashdemo/data/bu_download_over.gif");		// 업로드 버튼 이미지 URL.
//flashVars += "&uploadBtnImageUrl="+uploadBtnImageUrl;

//var fileAddBtnImageUrl = encodeURIComponent("/flashdemo/data/bu_browser_down.gif");		// 업로드 파일 추가 버튼 이미지 URL.
//flashVars += "&fileAddBtnImageUrl="+fileAddBtnImageUrl;

//var fileRemoveBtnImageUrl = encodeURIComponent("/flashdemo/data/bu_remove_down.png");		// 업로드 파일 삭제 버튼 이미지 URL.
//flashVars += "&fileRemoveBtnImageUrl="+fileRemoveBtnImageUrl;

//var previewImageUrl = encodeURIComponent("/flashdemo/data/bu_browser_down.gif");		// 미리보기 기본 이미지 URL.
//flashVars += "&previewImageUrl="+previewImageUrl;

//var backgroundColor = 0xFF0000;					// 업로더 배경색.
//flashVars += "&backgroundColor="+backgroundColor;

//var listFilesBackgroundColor = 0x999999;			// 업로더 파일목록 배경색.
//flashVars += "&listFiles.backgroundColor="+listFilesBackgroundColor;

// rMate FileManager와 스크립트간 동기화가 완료된 후 FileManager가 아래 설정한 함수를 호출합니다.
// 이 함수를 통하여 FileManager와 통신하기 때문에 배열형태로 데이터를 삽입할 경우 반드시
// 정의하여야 합니다.
//var rMateOnLoadCallFunction = "rMateFileManagerOnLoad";
//flashVars += "&rMateOnLoadCallFunction="+rMateOnLoadCallFunction;
--%>

<%--///////// 컴포넌트 설정값 세팅 끝 /////////// --%>

var rMateUploader;		// Uploader 컴포넌트 변수

// 업로드 시작
function startUpload() {
	rMateUploader.startUpload();
}

<%--// 사용자가 전송 취소(cancel)한 경우 업로더에 의해 불려집니다. --%>
function uploadCancel() {
//alert("canceled");
}

<%--// 업로드 완료시 업로더에 의해 불려집니다. - uploadGetData속성이 false시 --%>
function uploadComplete() {
//alert("업로드가 완료되었습니다.");
}

<%--// 업로드 완료시 업로더에 의해 불려집니다. - uploadGetData속성이 true시 --%>
function uploadCompleteData() {
	var result = rMateUploader.getUploadResultFiles();

<%--
	// 업로드 결과를 form의 hidden으로 넣어줍니다.
	// fileid는 uploader 컴포넌트의 generateFileID 속성을 true로 해줬을 때 입력되게 됩니다.
	// result에는 업로드후 서버에서 받은 값을 넣어주게 됩니다. (서버에 저장된 파일의 실제 path 또는 url등을 받는데 사용하실 수 있습니다.
--%>
	if (result != null) {
		document.f1.att_data.value = "";

		for (var i = 0; i < result.length; i++) { //result[i]["name"], result[i]["size"], result[i]["fileid"], result[i]["result"]
			document.f1.att_data.value  = document.f1.att_data.value
			                            + result[i]["name"]   + "<%=G_separatorfield%>"
			                            + result[i]["size"]   + "<%=G_separatorfield%>"
			                            + result[i]["fileid"];
//			                            + result[i]["result"];

			if (i < result.length-1) {
				document.f1.att_data.value  = document.f1.att_data.value + "<%=G_separatorfield%>" + "<%=G_separatorfield%>";
			}
		}
	}

	parent.uploadCompleteNewData(document.f1.att_no.value, document.f1.att_data.value);
}

<%--// 업로드 IO오류시 업로더에 의해 불려집니다. --%>
function uploadIOError(msg) {
	alert("파일 업로드가 실패하였습니다.\n"+msg);
}

<%--// 업로드 보안오류시 업로더에 의해 불려집니다. --%>
function uploadSecurityError(msg) {
	alert("보안적인 이유로 파일 업로드가 실패하였습니다.\n"+msg);
}

<%--// 파일 선택 확장자를 여러개 설정할 경우 아래의 설정을 수정하여 적용하시면 됩니다. - 사용할 경우 rMateFileManagerOnLoad함수의 comment를 푸시기 바랍니다. --%>
var fileFilters = [
	{ "fileFilterDescription":"image", "fileFilterExtension":"*.jpg;*.gif;*.png" },
	{ "fileFilterDescription":"html", "fileFilterExtension":"*.html;*.htm" },
	{ "fileFilterDescription":"office", "fileFilterExtension":"*.xls;*.ppt;*.doc" }
];

function setFileFilters() {
	rMateUploader.setFileFilters(fileFilters);
}

<%--
// 스크립트와 FileManager간의 동기화가 완료된 후 호출되는 함수로 사용자가 조작 가능한 함수입니다.
// 지금의 예에서는 setUploadedFiles 함수를 통해 업로더에 데이터를 전달하는 구성으로 만들어 졌습니다.
--%>
function rMateFileManagerOnLoad() {
<%--
//	setFileFilters();	// 위의 setFileFilters함수를 사용할 경우 comment를 푸세요
--%>
}

<%--// for flash sync --%>
var rMateFileManagerJsReady = false;

function rMateFileManagerInit() {
	rMateUploader   = document.getElementById("UploaderWeb");
	rMateFileManagerJsReady = true;
}

function rMateFileManagerIsReady() {
	return rMateFileManagerJsReady;
}

function getRMateFileManagerLicense() {
	try {
		return rMateFileManagerLicense;
	} catch(e) {
		alert("rMate FileManager license is required.")
	}
}

<%--
// 아래부분은 플래시를 생성하기 위해 플래시 프로그램에서 자동으로 만드는 스크립트입니다.
// -----------------------------------------------------------------------------
// Globals
// Major version of Flash required
--%>
var requiredMajorVersion = 10;
<%--// Minor version of Flash required --%>
var requiredMinorVersion = 0;
<%--// Minor version of Flash required --%>
var requiredRevision = 0;
// -----------------------------------------------------------------------------

<%--// Version check for the Flash Player that has the ability to start Player Product Install (6.0r65) --%>
var hasProductInstall = DetectFlashVer(6, 0, 65);

<%--// Version check based upon the values defined in globals --%>
var hasRequestedVersion = DetectFlashVer(requiredMajorVersion, requiredMinorVersion, requiredRevision);

if ( hasProductInstall && !hasRequestedVersion ) {
<%--
	// DO NOT MODIFY THE FOLLOWING FOUR LINES
	// Location visited after installation is complete if installation is required
--%>
	var MMPlayerType = (isIE == true) ? "ActiveX" : "PlugIn";
	var MMredirectURL = window.location;
    document.title = document.title.slice(0, 47) + " - Flash Player Installation";
    var MMdoctitle = document.title;

	AC_FL_RunContent(
		"src", "/rMateFM/Component/playerProductInstall",
		"FlashVars", "MMredirectURL="+MMredirectURL+'&MMplayerType='+MMPlayerType+'&MMdoctitle='+MMdoctitle+"",
		"width", "100%",
		"height", "120",
		"align", "middle",
		"id", "UploaderWeb",
		"quality", "high",
		"bgcolor", "#ffffff",
		"name", "UploaderWeb",
		"allowScriptAccess","sameDomain",
		"type", "application/x-shockwave-flash",
		"pluginspage", "http://www.adobe.com/go/getflashplayer"
	);
} else if (hasRequestedVersion) {
<%--
	// if we've detected an acceptable version
	// embed the Flash Content SWF when all tests are passed
--%>
	AC_FL_RunContent(
			"src", "/rMateFM/Component/UploaderWeb",
			"flashVars", flashVars,
			"width", "100%",
			"height", "120",
			"align", "middle",
			"id", "UploaderWeb",
			"quality", "high",
			"bgcolor", "#ffffff",
			"name", "UploaderWeb",
			"allowScriptAccess","sameDomain",
			"type", "application/x-shockwave-flash",
			"pluginspage", "http://www.adobe.com/go/getflashplayer"
	);
  } else {   <%--// flash is too old or we can't detect the plugin --%>
    var alternateContent = 'Alternate HTML content should be placed here. '
  	+ 'This content requires the Adobe Flash Player. '
   	+ '<a href=http://www.adobe.com/go/getflash/>Get Flash</a>';
    document.write(alternateContent);  <%--// insert non-flash content --%>
  }
// -->
</script>

<noscript>
  	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
			id="UploaderWeb" width="100%" height="120"
			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
			<param name="movie" value="UploaderWeb.swf" />
			<param name="flashVars" value="localeChain=en_US"/>
			<param name="quality" value="high" />
			<param name="bgcolor" value="#ffffff" />
			<param name="allowScriptAccess" value="sameDomain" />
			<embed src="/rMateFM/Component/UploaderWeb.swf" quality="high" bgcolor="#ffffff"
				width="100%" height="100%" name="UploaderWeb" align="middle"
				play="true"
				loop="false"
				quality="high"
				allowScriptAccess="sameDomain"
				type="application/x-shockwave-flash"
				pluginspage="http://www.adobe.com/go/getflashplayer">
			</embed>
	</object>
</noscript>

<!-- ////////////////////////////////////////////////////////////////////////////// -->
<script language="JavaScript" type="text/javascript">
<!--
<%--// rMate FileManager 객체가 생성되고 웹페이지가 로딩이 완료된 경우 실행됩니다 (필요시 Body태그의 onLoad 이벤트로 불려져도 무방함) --%>
rMateFileManagerInit();
// -->
</script>

</form>
</body>
</html>
