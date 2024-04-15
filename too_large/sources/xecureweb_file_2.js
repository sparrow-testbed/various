/*************************************************************************//**
 * @file xecureweb_file.js
 * xecureweb file javascript의 구현체
 *
 * @author  PKI Part, Softforum R&D Team
 * @date    2008/04/28
 * @attention Copyright (c) 2008 Softforum - All rights reserved.
 *****************************************************************************/

/**
 * 서버의 호스트 네임<BR>
 */
var hostname  = window.location.hostname;
var po = window.location.port;
var port ;

if ( po == '' ) {
	port = 80;
}
else {
	port = parseInt( po, 10 );
}

/**
 * 업로드시 보여줄 메시지<BR>
 */
var desc_upload ='';// '파일을 암호화하여 전송합니다...';
/**
 * 다운로드시 보여줄 메시지<BR>
 */
var desc_download ='';// '파일을 암호화하여 내려받고 있습니다..';

/**
 * 업로드 기본 디렉토리<BR>
 */
var initdir_up = ''; // v 2.1.4 add
/**
 * 다운로드 기본 디렉토리<BR>
 */
var initdir_down = ''; // v 2.1.4 add
/*
 * file_upload.jsp 는 암호화된 파일을 그냥 읽어준다.
 */


var     packageURL1 = 'http://' + window.location.host + '/XecureObject/NPFileAccess_Install.jar';
var     packageName1 = 'XecureWeb File 4.0 Plug-in'
var     updateObjectName1 = 'XecureWeb File 4.0 Plug-in';
var     versionMaj1 = 4;
var     versionMin1 = 2;
var     versionRel1 = 6;
var     versionBld1 = 20011012;

var accept_cert = "CA131000002Test,CA131000002,Xecure TestCA,SoftforumCA,Softforum Demo CA,Softforum CA 3.0,yessignCA,yessignCA-OCSP,signGATE CA,SignKorea CA,CrossCertCA,CrossCertCA-Test2,NCASign CA,TradeSignCA,yessignCA-TEST,lotto test CA,NCATESTSign,SignGateFTCA,SignKorea Test CA,TestTradeSignCA,Matsushita Group PKI Card CA 2002";

function EAlert ( errCode, errMsg ) {

        alert( "에러코드 : " + errCode + "\n\n" + errMsg );
}

function Agent()
{
        var str;
        var agent;

        str = navigator.userAgent;
        agent = str.substring(0,9);
        return agent;
}

/**
 * 전역변수 initdir_up를 Default위치로 파일선택창을 Display한다.<BR>
 * initdir_up이 ‘’인 경우 현 위치에서 파일선택창을 Diplay한다.<BR>
 * 선택한 파일 파일을 암호화하여 전송하며 있때, desc_upload를 기준으로 <BR>
 * 창이 열리면서 전송된다.<BR>
 * <BR>
 * <B>Linux System에서는 지원하지 않는다.</B><BR>
 * <BR>
 * example><BR>
 * @code
 * <p>
 * <a href='file_upload.php' onClick="FileUpload(this); return false;">file upload [FileUploadLink]</a>
 * </p>
 * @endcode
 * @param link : Link객체
 * @return 성공 : true<BR>
 * 오류 : false
 */
function FileUpload(link)
{
	var qs;
	var errCode;
	var errMsg='';
	var extname;
	var filename;
	var docKind;
	var agent = Agent();

	qs = link.search;
	if ( qs.length > 1 ) {
    	qs = link.search.substring(1);
	}
        
	path = link.pathname;
	ext = path.lastIndexOf('.');
	//php확장자가 php3 php4 phps php 인 경우에 대해서 처리한다. 그 이외의 경우에는 조건문에 추가해 준다.
	extname = path.substring(ext + 1, ext + 4);
	if(extname == 'php')
		docKind = "php";
	else
		docKind	= "jsp";
		
	if(navigator.appName == 'Netscape') {
		
    	if(agent != 'Mozilla/5') {

			filename = document.FileAccess.FileSelect2(escape(initdir_up));
			
   			if( filename == "" ) {
				errCode = document.FileAccess.LastErrCode();
				errMsg = unescape(document.FileAccess.LastErrMsg());
				EAlert( errCode, errMsg );
    			return false;
			}
			else if( filename == "CANCEL" )
    		{
    			alert('암호화 파일 전송이 취소되었습니다!');
       			return false;
    		}

			if(docKind == "php")
				r = document.FileAccess.FileUpload(
					xgate_addr, "/cgi-bin/xw_upload.cgi", "", hostname, port, filename, escape(desc_upload));
			else
    			r = document.FileAccess.FileUpload(
					xgate_addr, path, escape(qs), hostname, port, filename, escape(desc_upload));
   		
			if( r== "" )
   			{
   				errCode = document.FileAccess.LastErrCode();
   				errMsg = unescape(document.FileAccess.LastErrMsg());
				EAlert( errCode, errMsg );
   				return false;
   			}
		}
		else { 
			filename = document.FileAccess.nsIXecureFileInstance.FileSelect2(escape(initdir_up));
	   		if( filename == "" ) {
    			errCode = document.FileAccess.nsIXecureFileInstance.LastErrCode();
    			errMsg = unescape(document.FileAccess.nsIXecureFileInstance.LastErrMsg());
				EAlert( errCode, errMsg );
    			return false;
    		}
    		
	    	r = document.FileAccess.nsIXecureFileInstance.FileUpload(
					xgate_addr, path, escape(qs), hostname, port, filename, escape(desc_upload));
					
	   		if( r== "" )
	   		{
	    		errCode = document.FileAccess.nsIXecureFileInstance.LastErrCode();
	    		errMsg = unescape(document.FileAccess.nsIXecureFileInstance.LastErrMsg());
				EAlert( errCode, errMsg );
	    		return false;
	   		}
		}
	}
    else  {	/* Explorer */

      	path = "/" + path;
		filename = document.FileAccess.FileSelect2(initdir_up);
	 	if( filename == "" ) {
     		errCode = document.FileAccess.LastErrCode();
     		errMsg = unescape(document.FileAccess.LastErrMsg());
			EAlert( errCode, errMsg );
       		return false;
    	}
    	else if( filename == "CANCEL" )
		{
			alert('암호화 파일 전송이 취소되었습니다!');
   			return true;
		}
		if(docKind == "php")
    		r = document.FileAccess.FileUpload(
					xgate_addr, "/cgi-bin/xw_upload.cgi" ,"", 
					hostname, port, filename, desc_upload);
    	else
    		r = document.FileAccess.FileUpload(
					xgate_addr,path ,qs, hostname, port, filename, desc_upload);
	   	if( r== "" )
	   	{
      		errCode = document.FileAccess.LastErrCode();
       		errMsg = document.FileAccess.LastErrMsg();
			EAlert( errCode, errMsg );
       		return false;
	   	}
    }

	if( r == 'OK' ){
		alert('암호화 파일 전송이 완료되었습니다!');
		return true;
	}
	if( r == 'CANCEL'){
		alert('암호화 파일 전송이 취소되었습니다!');
		return false;
	}
	if( r != '') {
		redirect = BlockDec(r);
		if(redirect == null || redirect.length == 0){
			alert('암호화 파일 전송이 실패하였습니다!');
			return false;
		}
		if(qs.length > 1) {
			redirect = path + "?" + redirect + "&" + qs;
		}
		else{
			redirect = path + "?" + redirect;
		}
		alert(redirect);
	    	XecureNavigate( redirect, '_self' )
		return true;
	}

    return false;
}

/*	
	[FileUploadEx]
	
	filePath : 업로드할 파일 경로. ""이면 파일 선택창으로부터 사용자 선택
	
	upOption =  0 : 한 번에 한 개의 파일씩 업로드함
	         = 16 : 여러 개의 파일을 동시에 업로드함(valid for only over v5.4.x)	
*/
/**
 * 전역변수 initdir_up를 Default위치로 파일선택창을 Display한다.<BR>
 * initdir_up이 ‘’인 경우 현 위치에서 파일선택창을 Diplay한다.<BR>
 * 선택한 파일 파일을 암호화하여 전송하며 있때, desc_upload를 기준으로 <BR>
 * 창이 열리면서 전송된다.<BR>
 * <BR>
 * <B>Linux System에서는 지원하지 않는다.</B><BR>
 *  <BR>
 * example><BR>
 * @code
 * <p><a href='file_upload.php' onClick="FileUploadEx(“”, this, 0); return false;">file upload [FileUploadLink]</a></p>
 * @endcode
 * 
 * @param filePath : 업로드할 파일 경로. “”이면 파일 선택창으로부터 사용자가 파일 선택
 * @param link : Link객체
 * @param upOption 파일 업로드 옵션<BR>
 * 0 : 한 번에 한 개의 파일만 업로드
 * 16 : 여러 개의 파일을 동시에 업로드함(valid for only over v5.4.x)	
 * @return 성공 : true<BR>
 * 오류 : false
 */
function FileUploadEx( filePath, link, upOption )
{
	var qs;
	var errCode;
	var errMsg='';
	var extname;
	var filename;
	var docKind;
	var agent = Agent();


	qs = link.search;
	if ( qs.length > 1 ) {
    	qs = link.search.substring(1);
	}
        
	path = link.pathname;
	ext = path.lastIndexOf('.');
	//php확장자가 php3 php4 phps php 인 경우에 대해서 처리한다. 그 이외의 경우에는 조건문에 추가해 준다.
	extname = path.substring(ext + 1, ext + 4);
	if(extname == 'php')
		docKind = "php";
	else
		docKind	= "jsp";
		
	if(navigator.appName == 'Netscape') {
		
    	if(agent != 'Mozilla/5') {

			filename = document.FileAccess.FileSelect2(escape(initdir_up));
			
   			if( filename == "" ) {
				errCode = document.FileAccess.LastErrCode();
				errMsg = unescape(document.FileAccess.LastErrMsg());
				EAlert( errCode, errMsg );
    			return false;
			}
			else if( filename == "CANCEL" )
    		{
    			alert('암호화 파일 전송이 취소되었습니다!');
       			return false;
    		}

			if(docKind == "php")
				r = document.FileAccess.FileUpload(
					xgate_addr, "/cgi-bin/xw_upload.cgi", "", hostname, port, filename, escape(desc_upload));
			else
    			r = document.FileAccess.FileUpload(
					xgate_addr, path, escape(qs), hostname, port, filename, escape(desc_upload));
   		
			if( r== "" )
   			{
   				errCode = document.FileAccess.LastErrCode();
   				errMsg = unescape(document.FileAccess.LastErrMsg());
				EAlert( errCode, errMsg );
   				return false;
   			}
		}
		else { 
			filename = document.FileAccess.nsIXecureFileInstance.FileSelect2(escape(initdir_up));
	   		if( filename == "" ) {
    			errCode = document.FileAccess.nsIXecureFileInstance.LastErrCode();
    			errMsg = unescape(document.FileAccess.nsIXecureFileInstance.LastErrMsg());
				EAlert( errCode, errMsg );
    			return false;
    		}
    		
	    	r = document.FileAccess.nsIXecureFileInstance.FileUpload(
					xgate_addr, path, escape(qs), hostname, port, filename, escape(desc_upload));
					
	   		if( r== "" )
	   		{
	    		errCode = document.FileAccess.nsIXecureFileInstance.LastErrCode();
	    		errMsg = unescape(document.FileAccess.nsIXecureFileInstance.LastErrMsg());
				EAlert( errCode, errMsg );
	    		return false;
	   		}
		}
	}
    else  {	/* Explorer */

      	path = "/" + path;
      		if( filePath == "" )
			filename = document.FileAccess.FileSelect2(initdir_up);
		else
			filename = filePath;
			
	 	if( filename == "" ) {
     		errCode = document.FileAccess.LastErrCode();
     		errMsg = unescape(document.FileAccess.LastErrMsg());
			EAlert( errCode, errMsg );
       		return false;
    	}
    	else if( filename == "CANCEL" )
		{
			alert('암호화 파일 전송이 취소되었습니다!');
   			return true;
		}
		if(docKind == "php")
    		r = document.FileAccess.FileUploadEx(
					xgate_addr, "/cgi-bin/xw_upload.cgi" ,"", 
					hostname, port, filename, desc_upload, upOption);
    	else
    		r = document.FileAccess.FileUploadEx(
					xgate_addr,path ,qs, hostname, port, filename, desc_upload, upOption);
	   	if( r== "" )
	   	{
      		errCode = document.FileAccess.LastErrCode();
       		errMsg = document.FileAccess.LastErrMsg();
			EAlert( errCode, errMsg );
       		return false;
	   	}
    }

	if( r == 'OK' ){
		alert('암호화 파일 전송이 완료되었습니다!');
		return true;
	}
	if( r == 'CANCEL'){
		alert('암호화 파일 전송이 취소되었습니다!');
		return false;
	}
	if( r != '') {
		redirect = BlockDec(r);
		if(redirect == null || redirect.length == 0){
			alert('암호화 파일 전송이 실패하였습니다!');
			return false;
		}
		if(qs.length > 1) {
			redirect = path + "?" + redirect + "&" + qs;
		}
		else{
			redirect = path + "?" + redirect;
		}
		alert(redirect);
	    	XecureNavigate( redirect, '_self' )
		return true;
	}

    return false;
}

/*	
	[FileDownload2]
	
	option =  0 : 다운로드 받은 파일에 대한 저장/실행 여부를 사용자에게 확인받음
	              (확장자가 doc, xls, ppt, cvs인 파일은 저장/실행 여부를 묻지 않고 웹브라우저 상에서 바로 실행됨)
	       =  1 : 다운로드 받은 파일을 무조건 저장시킴
	       = 16 : 다운로드 창을 여러 개 띄울 수 있음(valid for only over v5.4.x)
	              (이 때는 다운로드가 완료되기 전에 리턴되기 때문에 후처리 작업시 주의 요망)
	       
	return value(modified for v5.4.x)
	   - 오류 : ""
	   - 사용자 취소 : "CANCEL"
	   - 성공 : 다운로드된 파일 경로 ex) "C:\\Download\\..."
*/
/**
 * filePath파일를 암호화하여 Downloading를 하게 되며, 저장위치는 전역변수<BR>
 * initdir_down를 Default로 하여 저장하게 되며, ‘’인 경우 현위치에 저장하게 된다.<BR>
 * Option이 0인 경우 창이 나와 열기 시도를 하기 되며,<BR>
 * 1인 경우는 바로 저장하기 창이 열리게 된다.<BR>
 * 전역변수 desc_download을 기준으로 DownLoading한다.<BR>
 * <BR>
 * <B>Linux System에서는 지원하지 않는다.</B><BR>
 * <BR>
 * example><BR>
 * @code
 * <a href='file_download.php' onClick="FileDownload('/user/zhang/xecureweb_ver4/object/xw40_install.exe', this, 0, 0); return false;">file(bin) download & save test</a>
 * @endcode
 *
 * @param filePath : DownLoad하고자 하는 파일의 Path
 * @param link : Link객체
 * @param option 0 : 다운로드 받은 파일에 대한 저장/실행 여부를 사용자에게 확인받음(확장자가 doc, xls, ppt, cvs인 파일은 저장/실행 여부를 묻지 않고 웹브라우저 상에서 바로 실행됨)<BR>
 * 1 : 다운로드 받은 파일을 무조건 저장시킴<BR>
 * 2 : 확장자가 doc, xls, ppt, cvs인 파일을 실행시킬 때, 웹브라우저가 아닌 별도의 애플리케이션으로 실행시킴
 * 16 : 다운로드 창을 여러 개 띄울 수 있음(valid for only over v5.4.x)<BR>
 * (이 때는 다운로드가 완료되기 전에 리턴되기 때문에 후처리 작업시 주의 요망)
 * @param newWindow 0 : 현재 창에서 파일 다운로드<BR>
 * 1 : 새로운 창을 생성한 후 파일 다운로드
 *
 * 성공 : 다운로드된 파일 경로 ex) "C:\\Download\\..."<BR>
 * 사용자 취소 : "CANCEL"<BR>
 * 오류 : “”
 *
 */
function FileDownload(filePath, link, option, newWindow)
{
	var r;
	var qs;
	var errCode;
	var errMsg='';
	var filename;
	var agent = Agent();

	qs = link.search;
	if ( qs.length > 1 ) 
	{
   		qs = link.search.substring(1);
   	}

	if(navigator.appName == 'Netscape') 
	{
   		path = link.pathname;
   		if(agent != 'Mozilla/5') 
   		{
   		 	r = document.FileAccess.FileDownload2(
			xgate_addr,path,escape(qs),hostname,
			port, filePath,escape(initdir_down),escape(desc_download));
			if( r== "" )
			{
	    		errCode = document.FileAccess.LastErrCode();
	    		errMsg = unescape(document.FileAccess.LastErrMsg());
				EAlert( errCode, errMsg );
	    		return false;
			}
		}
		else 
		{ // for netscape 6 , not implemented...
			r = document.FileAccess.nsIXecureFileInstance.FileDownload2(
				xgate_addr, path, escape(qs), hostname, port,
				filePath, escape(initdir_down), escape(desc_download)
				);
			if( r== "" )
			{
			    errCode = document.FileAccess.nsIXecureFileInstance.LastErrCode();
		    	errMsg = unescape(document.FileAccess.nsIXecureFileInstance.LastErrMsg());
				EAlert( errCode, errMsg );
		    	return false;
			}
		}
	}
	else  /* explorer */
	{
		if(newWindow == 0)
		{
	   	 	path = "/" + link.pathname;
	   	 	   		
			r = document.FileAccess.FileDownload2( xgate_addr, path, qs, hostname, port, filePath, initdir_down, desc_download, option);
			if( r== "" )	// error
			{
	        	errCode = document.FileAccess.LastErrCode();
	        	errMsg = document.FileAccess.LastErrMsg();
				EAlert( errCode, errMsg );
		        	return false;
			}
		}
		else if(newWindow == 1)
		{
			path = "/" + link.pathname;
			winObject = window.open("", "", "toolbar=yes, location=yes, status=yes, menubar=yes, resizable=yes, width=600, height=400");
			winObject.document.write(
			"<OBJECT ID='FileAccess' CLASSID='CLSID:6AC69002-DAD5-11D4-B065-00C04F0CD404' CODEBASE='/XecureObject/xw50_install.cab#Version=5,0,3,0'><PARAM name='lang' value='KOREAN'>\n");
			winObject.document.write("<COMMENT><EMBED type='application/x-SoftForum-XWFile' hidden=true name='FileAccess' lang='KOREAN'>\n");
			winObject.document.write("<NOEMBED></COMMENT>No XecureWeb 5.0 File PlugIn</NOEMBED></EMBED></OBJECT>\n");
			winObject.document.write("<script language='javascript'>\n");
			winObject.document.write("if (navigator.appName == 'Netscape') {\n");
			winObject.document.write("} else {\n");
			winObject.document.write("path = '/" + link.pathname + "';\n");
			winObject.document.write("r = document.FileAccess.FileDownload2('" + xgate_addr + "',\n");
			winObject.document.write("'" + path + "','" + qs + "','" + hostname + "'," + port + ",'" + filePath + "','"  + "" + "','" + desc_download + "'," + option + ");\n");
			winObject.document.write("if( r== '' ) {\n");
       		winObject.document.write("errCode = document.FileAccess.LastErrCode();\n");
        	winObject.document.write("errMsg = document.FileAccess.LastErrMsg();\n");
//		winObject.document.write("}\n");
		winObject.document.write("}else{\n");
		winObject.document.write("alert( '암호화 파일 다운로드가 완료되었습니다[' + r + '].' );\n");
		winObject.document.write("}\n");
    		winObject.document.write("}\n");
    		winObject.document.write("</script>\n");
    		
    		return "OK";
		}
    }

/*
	if( r == 'OK' )
		alert('암호화 파일 다운로드가 완료 되었습니다!');
	if( r == 'CANCEL' )
		alert('암호화 파일 다운로드가 취소 되었습니다!');

	if( r != "" ) {
		alert(r);	
	}
*/
	
	if( r == "CANCEL" )
		alert('암호화 파일 다운로드가 취소되었습니다.');
	else if( r != "" )
	{
		desc = "암호화 파일 다운로드가 완료되었습니다[" + r + "].";
		alert(desc);
	}
		
	return r;
}

function file_isNewPlugin(desc)
{
    	index = desc.indexOf('v.', 0);
    	if (index < 0)
            	return false;
    	desc += ' ';

    	versionString = desc.substring(index +2, desc.length);
    	arrayOfStrings = versionString.split('.');
    	thisMajor = parseInt(arrayOfStrings[0], 10);
    	thisMinor = parseInt(arrayOfStrings[1], 10);
    	thisBuild = parseInt(arrayOfStrings[2], 10);
    	if (thisMajor > versionMaj1)
            	return true;
    	else if (thisMajor < versionMaj1)
            	return false;
    	if (thisMinor > versionMin1)
            	return true;
    	else if (thisMinor < versionMin1)
            	return false;
    	if (thisBuild > versionRel1)
            	return true;
    	else if (thisBuild < versionRel1)
            	return false;
    	return true;
}

function file_downloadNow () {
    if ( navigator.javaEnabled() ) {
        trigger = netscape.softupdate.Trigger;
        if ( trigger.UpdateEnabled() ) {
            if (navigator.platform == "Win32") {
                trigger.StartSoftwareUpdate( packageURL1, trigger.DEFAULT_MODE);

            }
            else alert('이 플러그 인은 윈도우즈 95/98/NT 환경에서만 작동합니다.')
        }
        else
            alert('넷스케입의 SmartUpdate 설치를 가능하도록 해야합니다.');
    }
    else
        alert('Java 실행을 가능하도록 해야합니다.');
}


/**
 * Netscape를 위해&lt;EMBED> Tag를, Internet Explorer를 위해 &lt;OBJECT> Tag를 document.write한다.<BR>
 * Linux System에서는 지원하지 않는다.<BR>
 * <BR>
 * example><BR>
 * @code
 * <html>
 * <head>
 * <form name='xecure' ><input type=hidden name='p'></form>
 * <script language='javascript' src='/XecureObject/xecureweb.js'></script>
 * <script language='javascript' src='/XecureObject/xecureweb_file.js'></script>
 * <script>
 * PrintObjectTag();
 * PrintFileObjectTag();
 * </script>
 * </head>
 * <body> </body></html>
 * @endcode
 */
function PrintFileObjectTag () {
        var tag;
        var agent;
        agent = Agent();

        if(navigator.appName == 'Netscape') {
                tag = "<EMBED type='application/x-SoftForum-XWFile' hidden=true name='FileAccess'>";
        }
        else {
                tag = '<OBJECT ID="FileAccess" CLASSID="CLSID:6AC69002-DAD5-11D4-B065-00C04F0CD404" CODEBASE="/XecureObject/xw50_install.cab#Version=4,1,0,6"></OBJECT>';
        }
        document.write(tag);
}

function FileDirectDownload(filePath)
{
    	var r;
	var qs = "";
    	var errCode;
    	var errMsg='';
    	var filename;
	var agent = Agent();

       	path = '/XecureDemo/file/file_download.jsp';
    	if(navigator.appName == 'Netscape') {
        	if(agent != 'Mozilla/5') {
                
			r = document.FileAccess.FileDownload(xgate_addr, '/XecureDemo/file/file_download.jsp' ,qs, 
								hostname, port, filePath, escape(desc_download));
    			if( r== "" )
    			{
        			errCode = document.FileAccess.LastErrCode();
        			errMsg = unescape(document.FileAccess.LastErrMsg());
				EAlert( errCode, errMsg );
        			return false;
    			}
		}
       		else { // for netscape 6 , not implemented...
			r = document.FileAccess.nsIXecureFileInstance.FileDownload(
						xgate_addr, '/XecureDemo/jsp/file_download.jsp' ,escape(qs), 
						hostname, port, filePath, escape(desc_download));
			if( r== "" )
			{
	    			errCode = document.FileAccess.nsIXecureFileInstance.LastErrCode();
	    			errMsg = unescape(document.FileAccess.nsIXecureFileInstance.LastErrMsg());
				EAlert( errCode, errMsg );
	    			return false;
			}
		}
    	}
    	else  {
		r = document.FileAccess.FileDownload(xgate_addr, '/XecureDemo/file/file_download.jsp' ,qs, 
					hostname, port, filePath, desc_download);
		if( r== "" )
		{
        		errCode = document.FileAccess.LastErrCode();
        		errMsg = document.FileAccess.LastErrMsg();
			EAlert( errCode, errMsg );
        		return false;
    		}
    	}

	alert('암호화 파일 다운로드가 완료 되었습니다!');

    	return true;
}

/*
	*** valid for only XWebFilCom v5.4.x ***
	
	It is possible to combine following option flags
	
	signOption =   0 : 기본 서명 + 원본 파일 경로에 서명된 파일 저장
	           =   1 : cert chain을 포함시켜 서명
	           =   2 : CRL 포함시켜 서명
	           =   4 : 다수 인증서로 서명 가능(only for FileSign)
		   =   8 : signed attribute(s) 포함
	           =  16 : XecureWeb 임시 폴더에 서명된 파일 저장
	           =  32 : 사용자 선택 디렉토리에 서명된 파일 저장
	           =  64 : CMS 타입으로 서명 
	           = 256 : 로그인한 인증서로 서명
	           
	return value
	   - success : path of signed file
	   - fail    : ""
*/
/**
 * FileSign은 <B>라이센스</B>가 필요한 기능이며, 서명된 파일은 XecureWeb FileControl에서<BR>
 * 인식할 수 있는 별도의 format을 가진다. 특히 XecureWeb 임시 폴더에 서명된 파일을<BR>
 * 저장하는 경우, 모든 작업이 완료된 후에는 <B>FileClear</B>를 이용하여 임시 폴더에<BR>
 * 있는 파일을 삭제하도록 한다.<BR>
 * <BR>
 * <B>Linux System에서는 지원하지 않는다.</B>
 * <B>valid for only XWebFilCom v5.4.x B>
 *
 * @param filePath : 서명할 파일 경로. “”이면 파일 선택창으로부터 사용자가 파일 선택
 * @param signOption : 파일 서명 옵션<BR>
 * 0 : 기본 서명 + 원본 파일 경로에 서명된 파일 저장<BR>
 * 1 : cert chain을 포함시켜 서명<BR>
 * 2 : CRL 포함시켜 서명<BR>
 * 8 : signed attribute(s) 포함<BR>
 * 4 : 한 번의 서명에 여러 개의 인증서로 서명 가능(MultiFileSign에는 적용안됨)<BR>
 * 16 : XecureWeb 임시 폴더에 서명된 파일 저장<BR>
 * 32 : 사용자 선택한 디렉토리에 서명된 파일 저장<BR>
 * 128 : 여러 개의 파일을 서명할 경우, 각각의 파일을 서로 다른 인증서로 서명할 수 있음(FileSignAndVerify에만 적용됨)<BR>
 * 256 : 로그인한 인증서로 서명<BR>
 * 512 : 서명시 진행바(Progress Bar) 표시 안함<BR>
 * <BR>
 * 각각의 옵션은 조합해서 사용 가능함<BR>
 * ex) 로그인한 인증서로 서명한 파일을 임시 폴더에 저장할 경우, <BR>
 * signOption = 256 + 16
 *
 * @return 성공 : 서명된 파일의 경로<BR>
 * 오류 : “”
 */

function FileSign( filePath, signOption )
{
	var r;
	var errCode;
	var errMsg='';
	var filename;
//	var signOption = 4 + 8 + 32 + 64;
		
	if(navigator.appName == 'Netscape') 
	{		
		alert( "Not supported function" );
	}
	else	/* Explorer */
	{	
		if( filePath == "" )
			filename = document.FileAccess.FileSelect2(initdir_up);
		else
			filename = filePath;
		
		if( filename == "" ) 
		{
			errCode = document.FileAccess.LastErrCode();
			errMsg = unescape(document.FileAccess.LastErrMsg());
			EAlert( errCode, errMsg );
			return false;
		}
		else if( filename == "CANCEL" )
		{
			return false;
		}
		
		// 리턴값은 서명된 파일의 경로입니다.
		r = document.FileAccess.FileSign(xgate_addr, accept_cert, filename, "", signOption, "", "", 0, "", 3);

	   	if( r == "" )
	   	{
			errCode = document.FileAccess.LastErrCode();
			errMsg = document.FileAccess.LastErrMsg();
			EAlert( errCode, errMsg );
			return false;
	   	}

//		FileClear( xgate_addr );

		alert( "서명이 완료되었습니다[" + r + "]." );
	}
	
	return r;
}

/*
	*** valid for only XWebFilCom v5.4.x ***
	
	It is possible to combine following option flags
	
	signOption = FileSign에서 사용하는 값과 동일
	
	verifyOption =   0 : 서명문만 검증
	             =   1 : 인증서 기본 검증
	             =   2 : cert chain 검증
	             =   4 : CRL 검증
	             =  16 : 원본 파일 저장하지 못함
	             =  32 : 추가 서명하지 못함
	             
	return value
	   - success : path of signed file / "OK"
	   - fail    : ""
*/
/**
 * FileVerify는 <B>라이센스</B>가 필요한 기능이며, FileSign으로 서명된 파일만을 검증할 수 있다.<BR>
 * <B>Linux System에서는 지원하지 않는다.</B><BR>
 * <B>valid for only XWebFilCom v5.4.x </B>
 *
 * @param filePath 서명 검증할 파일 경로. “”이면 파일 선택창으로부터 사용자가 파일 선택
 * @param verifyOption 파일 서명 검증 옵션<BR>
 * 0 : 서명문만 검증<BR>
 * 1 : 인증서 기본 검증<BR>
 * 2 : cert chain 검증<BR>
 * 4 : CRL 검증<BR>
 * 16 : 원본 파일 저장하지 못함<BR>
 * 32 : 추가 서명하지 못함<BR>
 * 512 : 서명시 진행바(Progress Bar) 표시 안함<BR>
 * <BR>
 * 각각의 옵션은 조합해서 사용 가능함<BR>
 * ex) cert chain 검증하고 추가로 서명하지 못하게 할 경우, verifyOption = 2 + 32
 *
 * @return 성공<BR>
 * - 서명 추가하지 않은 경우 : “OK”<BR>
 * - 서명 추가한 경우 : 서명된 파일의 경로<BR>
 */
function FileVerify( filePath, verifyOption )
{
	var r;
	var errCode;
	var errMsg='';
	var filename;
//	var verifyOption = 0;
	var signOption = 8 + 32;

	if(navigator.appName == 'Netscape') 
	{
		alert( "Not supported function" );
	}
	else	/* Explorer */
	{	
		if( filePath == "" )
			filename = document.FileAccess.FileSelect2(initdir_up);
		else
			filename = filePath;
		
		if( filename == "" ) 
		{
			errCode = document.FileAccess.LastErrCode();
			errMsg = unescape(document.FileAccess.LastErrMsg());
			EAlert( errCode, errMsg );
			return false;
		}
		else if( filename == "CANCEL" )
		{
			return false;
		}
		
		// 리턴값은 추가 서명된 파일의 경로 / OK 입니다.
		r = document.FileAccess.FileVerify(xgate_addr,accept_cert,filename, verifyOption, signOption, "", "", 0, "");
		
		if( r== "" )
		{
			errCode = document.FileAccess.LastErrCode();
			errMsg = document.FileAccess.LastErrMsg();
			EAlert( errCode, errMsg );
			return false;
		}

//		FileClear( xgate_addr );

		alert( "서명문 검증이 완료되었습니다[" + r + "]." );
	}

	return r;
}

/*
	*** valid for only XWebFilCom v5.4.x ***
	
	It is possible to combine following option flags
	[EXCEPTION]
	   - 1,2,64 are not used simultaneously
	   - 4 is valid for only 1
	   - 16,32 are not used simultaneously
	
	envOption  =   1 : 인증서기반 전자봉투
	           =   2 : 패스워드기반 전자봉투
	           =   4 : 여러 개의 인증서로 전자봉투
	           =   8 : CMS 타입으로 Envelop
	           =  16 : 임시 폴더에 전자봉투 파일 저장
	           =  32 : 사용자 선택 디렉토리에 전자봉투 파일 저장(사용자가 임의의 위치에 있는 인증서 파일을 선택할 수 있음)
	           =  64 : 사용자에 의해 선택된 인증서 파일기반 전자봉투
	           = 256 : 로그인한 인증서로 전자봉투
	           
	return value
	   - success : path of enveloped file
	   - fail    : ""
*/
/**
 * FileEnvelop은 <B>라이센스</B>가 필요한 기능이며, envelop된 파일은 XecureWeb FileControl에서<BR>
 * 인식할 수 있는 별도의 format을 가진다. 특히 XecureWeb 임시 폴더에 envelop된 파일을<BR>
 * 저장하는 경우, 모든 작업이 완료된 후에는 <B>FileClear</B>를 이용하여 임시 폴더에 있는<BR>
 * 파일을 삭제하도록 한다.<BR>
 * <B>Linux System에서는 지원하지 않는다.<B/><BR>
 * <B>valid for only XWebFilCom v5.4.x </B><BR>
 *
 * @param filePath envelop할 파일 경로. “”이면 파일 선택창으로부터 사용자가 파일 선택
 * @param envOption 파일 envelop 옵션<BR>
 * 1 : 인증서기반 envelop<BR>
 * 2 : 패스워드기반 envelop<BR>
 * 4 : 여러 개의 인증서로 envelop<BR>
 * 8 : CMS 타입으로 Envelop<BR>
 * 16 : 임시 폴더에 envelop된 파일 저장<BR>
 * 32 : 사용자 선택 디렉토리에 envelop된 파일 저장<BR>
 * 64 : 사용자에 의해 선택된 인증서 파일기반 envelop (사용자가 임의의 위치에 있는 인증서 파일을 선택할 수 있음)<BR>
 * 256 : 로그인한 인증서로 envelop<BR>
 * 512 : 서명시 진행바(Progress Bar) 표시 안함<BR>
 * <BR>
 * 각각의 옵션은 조합해서 사용 가능함<BR>
 * ex) 패스워드 기반으로 envelop하여 사용자 선택 디렉토리에 저장<BR>
 * envOption = 2 + 32<BR>
 * 예외)
 * - 1, 2, 64는 동시에 적용될 수 없음<BR>
 * - 16, 32는 동시에 적용될 수 없음<BR>
 * - 4는 1이 적용될 때에만 유효함<BR>
 *
 * @exception <BR>
 * - 1,2,64 are not used simultaneously<BR>
 * - 4 is valid for only 1<BR>
 * - 16,32 are not used simultaneously<BR>
 * @return 성공 : Envelop된 파일의 경로<BR>
 * 실패 : “”
 */
function FileEnvelop( filePath, envOption )
{
	var r;
	var errCode;
	var errMsg='';
	var filename;
//	var envOption = 64 + 32 + 8;
	var cert_pem = "";
		
	
	if(navigator.appName == 'Netscape') 
	{		
		alert( "Not supported function" );
	}
	else	/* Explorer */
	{	
		if( filePath == "" )
			filename = document.FileAccess.FileSelect2(initdir_up);
		else
			filename = filePath;
		
		if( filename == "" ) 
		{
			errCode = document.FileAccess.LastErrCode();
			errMsg = unescape(document.FileAccess.LastErrMsg());
			EAlert( errCode, errMsg );
			return false;
		}
		else if( filename == "CANCEL" )
		{
			return false;
		}
		
		// 리턴값은 envelop된 파일의 경로입니다.
		r = document.FileAccess.FileEnvelop(
			xgate_addr, 
			accept_cert, 
			filename, 
			"", 
			envOption, 
			"", 
			cert_pem, 
			"", 
			0, 
			"", 
			3);

	   	if( r == "" )
	   	{
			errCode = document.FileAccess.LastErrCode();
			errMsg = document.FileAccess.LastErrMsg();
			EAlert( errCode, errMsg );
			return false;
	   	}

//		FileClear( xgate_addr );

		alert( "파일 암호화가 완료되었습니다[" + r + "]." );
	}
	
	return r;
}

/*
	*** valid for only XWebFilCom v5.4.x ***
	
	It is possible to combine following option flags
	
	deenvOption  =   1 : execute the deenveloped file	
	
	return value
	   - success : "OK"
	   - fail    : ""                 
*/
/**
 * FileDeEnvelop은 <B>라이센스</B>가 필요한 기능이며, FileEnvelop으로 서명된 파일만을 복호화할 수 있다.<BR>
 * <B>Linux System에서는 지원하지 않는다.</B><BR>
 * <B>valid for only XWebFilCom v5.4.x </B>
 *
 * @param filePath : deenvelop할 파일 경로. “”이면 파일 선택창으로부터 사용자가 파일 선택
 * @param deenvOption :<BR>
 * 0 : deenvelop된 파일을 사용자 지정 위치에 저장<BR>
 * 1 : deenvelop된 파일을 실행시킴<BR>
 * 512 : 서명시 진행바(Progress Bar) 표시 안함
 *
 * @return 성공 : “Ok”<BR>
 * 실패 : “”
 */
function FileDeEnvelop( filePath, deenvOption )
{
	var r;
	var errCode;
	var errMsg='';
	var filename;
//	var deenvOption = 0;
		
	if(navigator.appName == 'Netscape') 
	{		
		alert( "Not supported function" );
	}
	else	/* Explorer */
	{	
		if( filePath == "" )
			filename = document.FileAccess.FileSelect2(initdir_up);
		else
			filename = filePath;
		
		if( filename == "" ) 
		{
			errCode = document.FileAccess.LastErrCode();
			errMsg = unescape(document.FileAccess.LastErrMsg());
			EAlert( errCode, errMsg );
			return false;
		}
		else if( filename == "CANCEL" )
		{
			return false;
		}
		
		r = document.FileAccess.FileDeEnvelop(
			xgate_addr, 
			accept_cert, 
			filename, 
			deenvOption, 
			"", 			
			3);

	   	if( r != "OK" )
	   	{
			errCode = document.FileAccess.LastErrCode();
			errMsg = document.FileAccess.LastErrMsg();
			EAlert( errCode, errMsg );
			return false;
	   	}

//		FileClear( xgate_addr );

		alert( "파일 복호화가 완료되었습니다[" + r + "]." );
	}
	
	return r;
}

/**
 * XecureWeb 임시 폴더를 사용하여 파일 관련 작업을 수행한 경우, FileClear를 호출하면<BR>
 * 해당 세션의 임시 파일들을 삭제한다. FileClear는 <B>라이센스</B>가 필요한 기능이다.<BR>
 * 파일 콘트롤이 언로드되면 XecureWeb 임시 폴더의 모든 파일은 삭제된다.<BR>
 * <B>Linux System에서는 지원하지 않는다.</B>
 *
 * @param xaddr xgate address
 */
function FileClear( xaddr )
{
	if(navigator.appName == 'Netscape')
	{
		alert( "Not supported function" );
	}
	else
		document.FileAccess.FileClear( xaddr, 0 );

	return false;
}

/*
	*** valid for only XWebFilCom v5.4.x ***
	
	zipOption  =  16 : 임시 폴더에 압축 파일 저장
	           =  32 : 사용자 선택 디렉토리에 압축 파일 저장
	           
	return value
	   - success : path of zipped file
	   - fail    : ""
*/
/**
 * FileZip은 <B>라이센스</B>가 필요한 기능이며, 압축된 파일은 일반 압축 유틸리티와 호환된다.<BR>
 * 특히 XecureWeb 임시 폴더에 압축된 파일을 저장하는 경우, 모든 작업이 완료된 후에는<BR>
 * <B>FileClear</B>를 이용하여 임시 폴더에 있는 파일을 삭제하도록 한다.<BR>
 * <B>Linux System에서는 지원하지 않는다.</B><BR>
 * <B>valid for only XWebFilCom v5.4.x </B>
 *
 * @param filePath 압축할 파일 경로. “”이면 파일 선택창으로부터 사용자가 파일 선택
 * @param zipOption 파일 압축 옵션<BR>
 * 16 : 임시 폴더에 압축 파일 저장<BR>
 * 32 : 사용자 선택 디렉토리에 압축 파일 저장<BR>
 *
 * @return 성공 : 압축된 파일 경로<BR>
 * 실패 : “”
 */
function FileZip( filePath, zipOption )
{
	var r;
	var errCode;
	var errMsg='';
	var filename;
//	var zipOption = 32;
	var selOption = 1;	// allow multi-selection

	if(navigator.appName == 'Netscape') 
	{		
		alert( "Not supported function" );
	}
	/* Explorer */
	else
	{	
		if( filePath == "" )
			filename = document.FileAccess.FileSelectEx(initdir_up, selOption);
		else
			filename = filePath;
		
		if( filename == "" )
		{
			errCode = document.FileAccess.LastErrCode();
			errMsg = unescape(document.FileAccess.LastErrMsg());
			EAlert( errCode, errMsg );
			return false;
		}
		else if( filename == "CANCEL" )
		{
			return false;
		}
		
		// 리턴값은 압축된 파일의 경로입니다.
		r = document.FileAccess.FileZip(
			xgate_addr, 
			filename, 
			zipOption );

	   	if( r == "" )
	   	{
			errCode = document.FileAccess.LastErrCode();
			errMsg = document.FileAccess.LastErrMsg();
			EAlert( errCode, errMsg );
			return false;
	   	}
	   	
	   	alert( "파일압축이 완료되었습니다[" + r + "]" );

//		FileClear( xgate_addr );
	}
	
	return r;
}

/*
	*** valid for only XWebFilCom v5.4.x ***
	
	return value
	   - success : "OK"
	   - fail    : ""
*/
/**
 * FileUnZip은 <B>라이센스</B>가 필요한 기능이다.<BR>
 * <B>valid for only XWebFilCom v5.4.x </B>
 *
 * @param filePath 압축을 풀 파일 경로. “”이면 파일 선택창으로부터 사용자가 파일 선택
 * @param targetPath 압축을 풀 디렉토리. “”이면 사용자가 선택하도록 함
 * @param uzOption 0(reserved for later use)
 * @return 성공 : “Ok”<BR>
 * 실패 : “”
 */
function FileUnZip( filePath, targetPath, uzOption )
{
	var r;
	var errCode;
	var errMsg='';
	var filename;
//	var uzOption = 0;

	if(navigator.appName == 'Netscape') 
	{		
		alert( "Not supported function" );
	}
	/* Explorer */
	else
	{	
		if( filePath == "" )
			filename = document.FileAccess.FileSelectEx(initdir_up, 0);
		else
			filename = filePath;
		
		if( filename == "" )
		{
			errCode = document.FileAccess.LastErrCode();
			errMsg = unescape(document.FileAccess.LastErrMsg());
			EAlert( errCode, errMsg );
			return false;
		}
		else if( filename == "CANCEL" )
		{
			return false;
		}
		
		// 리턴값은 압축된 파일의 경로입니다.
		r = document.FileAccess.FileUnZip(
			filename, 
			targetPath,
			uzOption );

	   	if( r == "" )
	   	{
			errCode = document.FileAccess.LastErrCode();
			errMsg = document.FileAccess.LastErrMsg();
			EAlert( errCode, errMsg );
			return false;
	   	}
	   	
	   	alert( "압축풀기가 완료되었습니다[" + r + "]" );

//		FileClear( xgate_addr );
	}
	
	return r;
}

function Demo_File_Sign_Zip_Upload( link )
{
	var	filename;
	
	filename = FileSign( "", 8+16 );
	filename = FileZip( filename, 16 );
	FileUploadEx( filename, link, 0 );
		
	return false;	
}

function Demo_File_Download_Unzip_Verify( filePath, link, option, newWindow )
{
	var	filename, filename2, filename3, filename4;
	
	filename = FileDownload( filePath, link, option, newWindow );
	filename2 = filename.substring(0, filename.lastIndexOf("\\"));
//	alert( filename2 );
	FileUnZip( filename, filename2, 16 );
	filename3 = filename.substring(filename.lastIndexOf("\\"), filename.length);
//	alert( filename3 );
	filename4 = filename2 + filename3.substring(0, filename3.lastIndexOf("."));
//	alert( filename4 );
	FileVerify( filename4, 0 );
			
	return false;	
}

function Demo_File_Envelop_Zip_Upload( link )
{
	var	filename;
	
	filename = FileEnvelop( "", 2+16 );
	filename = FileZip( filename, 16 );
	FileUploadEx( filename, link, 0 );
		
	return false;	
}

function Demo_File_Download_Unzip_Deenvelop( filePath, link, option, newWindow )
{
	var	filename, filename2, filename3, filename4;
	
	filename = FileDownload( filePath, link, option, newWindow );
	filename2 = filename.substring(0, filename.lastIndexOf("\\"));
//	alert( filename2 );
	FileUnZip( filename, filename2, 16 );
	filename3 = filename.substring(filename.lastIndexOf("\\"), filename.length);
//	alert( filename3 );
	filename4 = filename2 + filename3.substring(0, filename3.lastIndexOf("."));
//	alert( filename4 );
	FileDeEnvelop( filename4, 0 );
			
	return false;	
}
