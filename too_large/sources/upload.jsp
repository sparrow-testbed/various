<%@ page contentType="text/html;charset=UTF-8" %>

<script type="text/javascript">
var message = '<%=request.getAttribute("message")%>';
var filename = '<%=request.getAttribute("filename")%>';
var filesize = '<%=request.getAttribute("filesize")%>';
var target = '<%=request.getAttribute("target")%>';
var context = '<%=request.getContextPath()%>';

function complete() {
	if (message != 'null' && message.length != 0) {
		if (message == 'max size exceed!') {
			alert('업로드 파일 사이즈가 제한된 사이즈보다 초과하였습니다!');
		}
		else if (message == 'file invalidateion error') {
			alert('파일이 비정상적 입니다');
		}
		else if (message == 'file upload error') {
			alert('파일업로드중 오류가 발생하였습니다');
		}
		
		if (filename.indexOf("_swf") > -1) {
			parent.Alice.flash.loading(false);
		}
		else {
			parent.Alice.image.loading(false);
		}
	}
	else {
		if (filename.indexOf("_swf") > -1) {
			parent.Alice.flash.preview({filename:filename, filesize:filesize, upload:(context.length > 0? context+target:target)});
		}
		else {
			parent.Alice.image.preview({filename:filename, filesize:filesize, upload:(context.length > 0? context+target:target)});
		}
	}
}

window.onload=complete;
</script>