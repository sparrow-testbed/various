/*************************************************************************//**
 * @file xecureweb_file.js
 * xecureweb file javascript�� ����ü
 *
 * @author  PKI Part, Softforum R&D Team
 * @date    2008/04/28
 * @attention Copyright (c) 2008 Softforum - All rights reserved.
 *****************************************************************************/

/**
 * ������ ȣ��Ʈ ����<BR>
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
 * ���ε�� ������ �޽���<BR>
 */
var desc_upload ='';// '������ ��ȣȭ�Ͽ� �����մϴ�...';
/**
 * �ٿ�ε�� ������ �޽���<BR>
 */
var desc_download ='';// '������ ��ȣȭ�Ͽ� �����ް� �ֽ��ϴ�..';

/**
 * ���ε� �⺻ ���丮<BR>
 */
var initdir_up = ''; // v 2.1.4 add
/**
 * �ٿ�ε� �⺻ ���丮<BR>
 */
var initdir_down = ''; // v 2.1.4 add
/*
 * file_upload.jsp �� ��ȣȭ�� ������ �׳� �о��ش�.
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

        alert( "�����ڵ� : " + errCode + "\n\n" + errMsg );
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
 * �������� initdir_up�� Default��ġ�� ���ϼ���â�� Display�Ѵ�.<BR>
 * initdir_up�� ������ ��� �� ��ġ���� ���ϼ���â�� Diplay�Ѵ�.<BR>
 * ������ ���� ������ ��ȣȭ�Ͽ� �����ϸ� �ֶ�, desc_upload�� �������� <BR>
 * â�� �����鼭 ���۵ȴ�.<BR>
 * <BR>
 * <B>Linux System������ �������� �ʴ´�.</B><BR>
 * <BR>
 * example><BR>
 * @code
 * <p>
 * <a href='file_upload.php' onClick="FileUpload(this); return false;">file upload [FileUploadLink]</a>
 * </p>
 * @endcode
 * @param link : Link��ü
 * @return ���� : true<BR>
 * ���� : false
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
	//phpȮ���ڰ� php3 php4 phps php �� ��쿡 ���ؼ� ó���Ѵ�. �� �̿��� ��쿡�� ���ǹ��� �߰��� �ش�.
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
    			alert('��ȣȭ ���� ������ ��ҵǾ����ϴ�!');
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
			alert('��ȣȭ ���� ������ ��ҵǾ����ϴ�!');
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
		alert('��ȣȭ ���� ������ �Ϸ�Ǿ����ϴ�!');
		return true;
	}
	if( r == 'CANCEL'){
		alert('��ȣȭ ���� ������ ��ҵǾ����ϴ�!');
		return false;
	}
	if( r != '') {
		redirect = BlockDec(r);
		if(redirect == null || redirect.length == 0){
			alert('��ȣȭ ���� ������ �����Ͽ����ϴ�!');
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
	
	filePath : ���ε��� ���� ���. ""�̸� ���� ����â���κ��� ����� ����
	
	upOption =  0 : �� ���� �� ���� ���Ͼ� ���ε���
	         = 16 : ���� ���� ������ ���ÿ� ���ε���(valid for only over v5.4.x)	
*/
/**
 * �������� initdir_up�� Default��ġ�� ���ϼ���â�� Display�Ѵ�.<BR>
 * initdir_up�� ������ ��� �� ��ġ���� ���ϼ���â�� Diplay�Ѵ�.<BR>
 * ������ ���� ������ ��ȣȭ�Ͽ� �����ϸ� �ֶ�, desc_upload�� �������� <BR>
 * â�� �����鼭 ���۵ȴ�.<BR>
 * <BR>
 * <B>Linux System������ �������� �ʴ´�.</B><BR>
 *  <BR>
 * example><BR>
 * @code
 * <p><a href='file_upload.php' onClick="FileUploadEx(����, this, 0); return false;">file upload [FileUploadLink]</a></p>
 * @endcode
 * 
 * @param filePath : ���ε��� ���� ���. �����̸� ���� ����â���κ��� ����ڰ� ���� ����
 * @param link : Link��ü
 * @param upOption ���� ���ε� �ɼ�<BR>
 * 0 : �� ���� �� ���� ���ϸ� ���ε�
 * 16 : ���� ���� ������ ���ÿ� ���ε���(valid for only over v5.4.x)	
 * @return ���� : true<BR>
 * ���� : false
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
	//phpȮ���ڰ� php3 php4 phps php �� ��쿡 ���ؼ� ó���Ѵ�. �� �̿��� ��쿡�� ���ǹ��� �߰��� �ش�.
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
    			alert('��ȣȭ ���� ������ ��ҵǾ����ϴ�!');
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
			alert('��ȣȭ ���� ������ ��ҵǾ����ϴ�!');
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
		alert('��ȣȭ ���� ������ �Ϸ�Ǿ����ϴ�!');
		return true;
	}
	if( r == 'CANCEL'){
		alert('��ȣȭ ���� ������ ��ҵǾ����ϴ�!');
		return false;
	}
	if( r != '') {
		redirect = BlockDec(r);
		if(redirect == null || redirect.length == 0){
			alert('��ȣȭ ���� ������ �����Ͽ����ϴ�!');
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
	
	option =  0 : �ٿ�ε� ���� ���Ͽ� ���� ����/���� ���θ� ����ڿ��� Ȯ�ι���
	              (Ȯ���ڰ� doc, xls, ppt, cvs�� ������ ����/���� ���θ� ���� �ʰ� �������� �󿡼� �ٷ� �����)
	       =  1 : �ٿ�ε� ���� ������ ������ �����Ŵ
	       = 16 : �ٿ�ε� â�� ���� �� ��� �� ����(valid for only over v5.4.x)
	              (�� ���� �ٿ�ε尡 �Ϸ�Ǳ� ���� ���ϵǱ� ������ ��ó�� �۾��� ���� ���)
	       
	return value(modified for v5.4.x)
	   - ���� : ""
	   - ����� ��� : "CANCEL"
	   - ���� : �ٿ�ε�� ���� ��� ex) "C:\\Download\\..."
*/
/**
 * filePath���ϸ� ��ȣȭ�Ͽ� Downloading�� �ϰ� �Ǹ�, ������ġ�� ��������<BR>
 * initdir_down�� Default�� �Ͽ� �����ϰ� �Ǹ�, ������ ��� ����ġ�� �����ϰ� �ȴ�.<BR>
 * Option�� 0�� ��� â�� ���� ���� �õ��� �ϱ� �Ǹ�,<BR>
 * 1�� ���� �ٷ� �����ϱ� â�� ������ �ȴ�.<BR>
 * �������� desc_download�� �������� DownLoading�Ѵ�.<BR>
 * <BR>
 * <B>Linux System������ �������� �ʴ´�.</B><BR>
 * <BR>
 * example><BR>
 * @code
 * <a href='file_download.php' onClick="FileDownload('/user/zhang/xecureweb_ver4/object/xw40_install.exe', this, 0, 0); return false;">file(bin) download & save test</a>
 * @endcode
 *
 * @param filePath : DownLoad�ϰ��� �ϴ� ������ Path
 * @param link : Link��ü
 * @param option 0 : �ٿ�ε� ���� ���Ͽ� ���� ����/���� ���θ� ����ڿ��� Ȯ�ι���(Ȯ���ڰ� doc, xls, ppt, cvs�� ������ ����/���� ���θ� ���� �ʰ� �������� �󿡼� �ٷ� �����)<BR>
 * 1 : �ٿ�ε� ���� ������ ������ �����Ŵ<BR>
 * 2 : Ȯ���ڰ� doc, xls, ppt, cvs�� ������ �����ų ��, ���������� �ƴ� ������ ���ø����̼����� �����Ŵ
 * 16 : �ٿ�ε� â�� ���� �� ��� �� ����(valid for only over v5.4.x)<BR>
 * (�� ���� �ٿ�ε尡 �Ϸ�Ǳ� ���� ���ϵǱ� ������ ��ó�� �۾��� ���� ���)
 * @param newWindow 0 : ���� â���� ���� �ٿ�ε�<BR>
 * 1 : ���ο� â�� ������ �� ���� �ٿ�ε�
 *
 * ���� : �ٿ�ε�� ���� ��� ex) "C:\\Download\\..."<BR>
 * ����� ��� : "CANCEL"<BR>
 * ���� : ����
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
		winObject.document.write("alert( '��ȣȭ ���� �ٿ�ε尡 �Ϸ�Ǿ����ϴ�[' + r + '].' );\n");
		winObject.document.write("}\n");
    		winObject.document.write("}\n");
    		winObject.document.write("</script>\n");
    		
    		return "OK";
		}
    }

/*
	if( r == 'OK' )
		alert('��ȣȭ ���� �ٿ�ε尡 �Ϸ� �Ǿ����ϴ�!');
	if( r == 'CANCEL' )
		alert('��ȣȭ ���� �ٿ�ε尡 ��� �Ǿ����ϴ�!');

	if( r != "" ) {
		alert(r);	
	}
*/
	
	if( r == "CANCEL" )
		alert('��ȣȭ ���� �ٿ�ε尡 ��ҵǾ����ϴ�.');
	else if( r != "" )
	{
		desc = "��ȣȭ ���� �ٿ�ε尡 �Ϸ�Ǿ����ϴ�[" + r + "].";
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
            else alert('�� �÷��� ���� �������� 95/98/NT ȯ�濡���� �۵��մϴ�.')
        }
        else
            alert('�ݽ������� SmartUpdate ��ġ�� �����ϵ��� �ؾ��մϴ�.');
    }
    else
        alert('Java ������ �����ϵ��� �ؾ��մϴ�.');
}


/**
 * Netscape�� ����&lt;EMBED> Tag��, Internet Explorer�� ���� &lt;OBJECT> Tag�� document.write�Ѵ�.<BR>
 * Linux System������ �������� �ʴ´�.<BR>
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

	alert('��ȣȭ ���� �ٿ�ε尡 �Ϸ� �Ǿ����ϴ�!');

    	return true;
}

/*
	*** valid for only XWebFilCom v5.4.x ***
	
	It is possible to combine following option flags
	
	signOption =   0 : �⺻ ���� + ���� ���� ��ο� ����� ���� ����
	           =   1 : cert chain�� ���Խ��� ����
	           =   2 : CRL ���Խ��� ����
	           =   4 : �ټ� �������� ���� ����(only for FileSign)
		   =   8 : signed attribute(s) ����
	           =  16 : XecureWeb �ӽ� ������ ����� ���� ����
	           =  32 : ����� ���� ���丮�� ����� ���� ����
	           =  64 : CMS Ÿ������ ���� 
	           = 256 : �α����� �������� ����
	           
	return value
	   - success : path of signed file
	   - fail    : ""
*/
/**
 * FileSign�� <B>���̼���</B>�� �ʿ��� ����̸�, ����� ������ XecureWeb FileControl����<BR>
 * �ν��� �� �ִ� ������ format�� ������. Ư�� XecureWeb �ӽ� ������ ����� ������<BR>
 * �����ϴ� ���, ��� �۾��� �Ϸ�� �Ŀ��� <B>FileClear</B>�� �̿��Ͽ� �ӽ� ������<BR>
 * �ִ� ������ �����ϵ��� �Ѵ�.<BR>
 * <BR>
 * <B>Linux System������ �������� �ʴ´�.</B>
 * <B>valid for only XWebFilCom v5.4.x B>
 *
 * @param filePath : ������ ���� ���. �����̸� ���� ����â���κ��� ����ڰ� ���� ����
 * @param signOption : ���� ���� �ɼ�<BR>
 * 0 : �⺻ ���� + ���� ���� ��ο� ����� ���� ����<BR>
 * 1 : cert chain�� ���Խ��� ����<BR>
 * 2 : CRL ���Խ��� ����<BR>
 * 8 : signed attribute(s) ����<BR>
 * 4 : �� ���� ���� ���� ���� �������� ���� ����(MultiFileSign���� ����ȵ�)<BR>
 * 16 : XecureWeb �ӽ� ������ ����� ���� ����<BR>
 * 32 : ����� ������ ���丮�� ����� ���� ����<BR>
 * 128 : ���� ���� ������ ������ ���, ������ ������ ���� �ٸ� �������� ������ �� ����(FileSignAndVerify���� �����)<BR>
 * 256 : �α����� �������� ����<BR>
 * 512 : ����� �����(Progress Bar) ǥ�� ����<BR>
 * <BR>
 * ������ �ɼ��� �����ؼ� ��� ������<BR>
 * ex) �α����� �������� ������ ������ �ӽ� ������ ������ ���, <BR>
 * signOption = 256 + 16
 *
 * @return ���� : ����� ������ ���<BR>
 * ���� : ����
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
		
		// ���ϰ��� ����� ������ ����Դϴ�.
		r = document.FileAccess.FileSign(xgate_addr, accept_cert, filename, "", signOption, "", "", 0, "", 3);

	   	if( r == "" )
	   	{
			errCode = document.FileAccess.LastErrCode();
			errMsg = document.FileAccess.LastErrMsg();
			EAlert( errCode, errMsg );
			return false;
	   	}

//		FileClear( xgate_addr );

		alert( "������ �Ϸ�Ǿ����ϴ�[" + r + "]." );
	}
	
	return r;
}

/*
	*** valid for only XWebFilCom v5.4.x ***
	
	It is possible to combine following option flags
	
	signOption = FileSign���� ����ϴ� ���� ����
	
	verifyOption =   0 : ������ ����
	             =   1 : ������ �⺻ ����
	             =   2 : cert chain ����
	             =   4 : CRL ����
	             =  16 : ���� ���� �������� ����
	             =  32 : �߰� �������� ����
	             
	return value
	   - success : path of signed file / "OK"
	   - fail    : ""
*/
/**
 * FileVerify�� <B>���̼���</B>�� �ʿ��� ����̸�, FileSign���� ����� ���ϸ��� ������ �� �ִ�.<BR>
 * <B>Linux System������ �������� �ʴ´�.</B><BR>
 * <B>valid for only XWebFilCom v5.4.x </B>
 *
 * @param filePath ���� ������ ���� ���. �����̸� ���� ����â���κ��� ����ڰ� ���� ����
 * @param verifyOption ���� ���� ���� �ɼ�<BR>
 * 0 : ������ ����<BR>
 * 1 : ������ �⺻ ����<BR>
 * 2 : cert chain ����<BR>
 * 4 : CRL ����<BR>
 * 16 : ���� ���� �������� ����<BR>
 * 32 : �߰� �������� ����<BR>
 * 512 : ����� �����(Progress Bar) ǥ�� ����<BR>
 * <BR>
 * ������ �ɼ��� �����ؼ� ��� ������<BR>
 * ex) cert chain �����ϰ� �߰��� �������� ���ϰ� �� ���, verifyOption = 2 + 32
 *
 * @return ����<BR>
 * - ���� �߰����� ���� ��� : ��OK��<BR>
 * - ���� �߰��� ��� : ����� ������ ���<BR>
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
		
		// ���ϰ��� �߰� ����� ������ ��� / OK �Դϴ�.
		r = document.FileAccess.FileVerify(xgate_addr,accept_cert,filename, verifyOption, signOption, "", "", 0, "");
		
		if( r== "" )
		{
			errCode = document.FileAccess.LastErrCode();
			errMsg = document.FileAccess.LastErrMsg();
			EAlert( errCode, errMsg );
			return false;
		}

//		FileClear( xgate_addr );

		alert( "���� ������ �Ϸ�Ǿ����ϴ�[" + r + "]." );
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
	
	envOption  =   1 : ��������� ���ں���
	           =   2 : �н������� ���ں���
	           =   4 : ���� ���� �������� ���ں���
	           =   8 : CMS Ÿ������ Envelop
	           =  16 : �ӽ� ������ ���ں��� ���� ����
	           =  32 : ����� ���� ���丮�� ���ں��� ���� ����(����ڰ� ������ ��ġ�� �ִ� ������ ������ ������ �� ����)
	           =  64 : ����ڿ� ���� ���õ� ������ ���ϱ�� ���ں���
	           = 256 : �α����� �������� ���ں���
	           
	return value
	   - success : path of enveloped file
	   - fail    : ""
*/
/**
 * FileEnvelop�� <B>���̼���</B>�� �ʿ��� ����̸�, envelop�� ������ XecureWeb FileControl����<BR>
 * �ν��� �� �ִ� ������ format�� ������. Ư�� XecureWeb �ӽ� ������ envelop�� ������<BR>
 * �����ϴ� ���, ��� �۾��� �Ϸ�� �Ŀ��� <B>FileClear</B>�� �̿��Ͽ� �ӽ� ������ �ִ�<BR>
 * ������ �����ϵ��� �Ѵ�.<BR>
 * <B>Linux System������ �������� �ʴ´�.<B/><BR>
 * <B>valid for only XWebFilCom v5.4.x </B><BR>
 *
 * @param filePath envelop�� ���� ���. �����̸� ���� ����â���κ��� ����ڰ� ���� ����
 * @param envOption ���� envelop �ɼ�<BR>
 * 1 : ��������� envelop<BR>
 * 2 : �н������� envelop<BR>
 * 4 : ���� ���� �������� envelop<BR>
 * 8 : CMS Ÿ������ Envelop<BR>
 * 16 : �ӽ� ������ envelop�� ���� ����<BR>
 * 32 : ����� ���� ���丮�� envelop�� ���� ����<BR>
 * 64 : ����ڿ� ���� ���õ� ������ ���ϱ�� envelop (����ڰ� ������ ��ġ�� �ִ� ������ ������ ������ �� ����)<BR>
 * 256 : �α����� �������� envelop<BR>
 * 512 : ����� �����(Progress Bar) ǥ�� ����<BR>
 * <BR>
 * ������ �ɼ��� �����ؼ� ��� ������<BR>
 * ex) �н����� ������� envelop�Ͽ� ����� ���� ���丮�� ����<BR>
 * envOption = 2 + 32<BR>
 * ����)
 * - 1, 2, 64�� ���ÿ� ����� �� ����<BR>
 * - 16, 32�� ���ÿ� ����� �� ����<BR>
 * - 4�� 1�� ����� ������ ��ȿ��<BR>
 *
 * @exception <BR>
 * - 1,2,64 are not used simultaneously<BR>
 * - 4 is valid for only 1<BR>
 * - 16,32 are not used simultaneously<BR>
 * @return ���� : Envelop�� ������ ���<BR>
 * ���� : ����
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
		
		// ���ϰ��� envelop�� ������ ����Դϴ�.
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

		alert( "���� ��ȣȭ�� �Ϸ�Ǿ����ϴ�[" + r + "]." );
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
 * FileDeEnvelop�� <B>���̼���</B>�� �ʿ��� ����̸�, FileEnvelop���� ����� ���ϸ��� ��ȣȭ�� �� �ִ�.<BR>
 * <B>Linux System������ �������� �ʴ´�.</B><BR>
 * <B>valid for only XWebFilCom v5.4.x </B>
 *
 * @param filePath : deenvelop�� ���� ���. �����̸� ���� ����â���κ��� ����ڰ� ���� ����
 * @param deenvOption :<BR>
 * 0 : deenvelop�� ������ ����� ���� ��ġ�� ����<BR>
 * 1 : deenvelop�� ������ �����Ŵ<BR>
 * 512 : ����� �����(Progress Bar) ǥ�� ����
 *
 * @return ���� : ��Ok��<BR>
 * ���� : ����
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

		alert( "���� ��ȣȭ�� �Ϸ�Ǿ����ϴ�[" + r + "]." );
	}
	
	return r;
}

/**
 * XecureWeb �ӽ� ������ ����Ͽ� ���� ���� �۾��� ������ ���, FileClear�� ȣ���ϸ�<BR>
 * �ش� ������ �ӽ� ���ϵ��� �����Ѵ�. FileClear�� <B>���̼���</B>�� �ʿ��� ����̴�.<BR>
 * ���� ��Ʈ���� ��ε�Ǹ� XecureWeb �ӽ� ������ ��� ������ �����ȴ�.<BR>
 * <B>Linux System������ �������� �ʴ´�.</B>
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
	
	zipOption  =  16 : �ӽ� ������ ���� ���� ����
	           =  32 : ����� ���� ���丮�� ���� ���� ����
	           
	return value
	   - success : path of zipped file
	   - fail    : ""
*/
/**
 * FileZip�� <B>���̼���</B>�� �ʿ��� ����̸�, ����� ������ �Ϲ� ���� ��ƿ��Ƽ�� ȣȯ�ȴ�.<BR>
 * Ư�� XecureWeb �ӽ� ������ ����� ������ �����ϴ� ���, ��� �۾��� �Ϸ�� �Ŀ���<BR>
 * <B>FileClear</B>�� �̿��Ͽ� �ӽ� ������ �ִ� ������ �����ϵ��� �Ѵ�.<BR>
 * <B>Linux System������ �������� �ʴ´�.</B><BR>
 * <B>valid for only XWebFilCom v5.4.x </B>
 *
 * @param filePath ������ ���� ���. �����̸� ���� ����â���κ��� ����ڰ� ���� ����
 * @param zipOption ���� ���� �ɼ�<BR>
 * 16 : �ӽ� ������ ���� ���� ����<BR>
 * 32 : ����� ���� ���丮�� ���� ���� ����<BR>
 *
 * @return ���� : ����� ���� ���<BR>
 * ���� : ����
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
		
		// ���ϰ��� ����� ������ ����Դϴ�.
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
	   	
	   	alert( "���Ͼ����� �Ϸ�Ǿ����ϴ�[" + r + "]" );

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
 * FileUnZip�� <B>���̼���</B>�� �ʿ��� ����̴�.<BR>
 * <B>valid for only XWebFilCom v5.4.x </B>
 *
 * @param filePath ������ Ǯ ���� ���. �����̸� ���� ����â���κ��� ����ڰ� ���� ����
 * @param targetPath ������ Ǯ ���丮. �����̸� ����ڰ� �����ϵ��� ��
 * @param uzOption 0(reserved for later use)
 * @return ���� : ��Ok��<BR>
 * ���� : ����
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
		
		// ���ϰ��� ����� ������ ����Դϴ�.
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
	   	
	   	alert( "����Ǯ�Ⱑ �Ϸ�Ǿ����ϴ�[" + r + "]" );

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
