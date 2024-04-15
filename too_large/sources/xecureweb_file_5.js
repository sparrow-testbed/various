
/*************************************************************************/

/**
 * @file xecureweb_file.js
 * xecureweb file javascript�� ����ü
 *
 * @author  PKI Part, Softforum R&D Team
 * @date    2008/04/28
 * @attention Copyright (c) 2008 Softforum - All rights reserved.
 *****************************************************************************/


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
var FileEnvelop(var filePath, var envOption) { }

/**
 * ������ ȣ��Ʈ ����<BR>
 */
var hostname;
var EAlert(var errCode, var errMsg) { }
var po;
var Agent() { }
var file_downloadNow() { }

/**
 * ���ε�� ������ �޽���<BR>
 */
var desc_upload;
var port;
var versionBld1;
var accept_cert;
var updateObjectName1;
var Demo_File_Download_Unzip_Verify(var filePath, var link, var option, var newWindow) { }

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
var PrintFileObjectTag() { }
var versionRel1;

/**
 * ���ε� �⺻ ���丮<BR>
 */
var initdir_up;

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
var FileVerify(var filePath, var verifyOption) { }

/**
 * �ٿ�ε�� ������ �޽���<BR>
 */
var desc_download;
var versionMin1;

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
var FileUnZip(var filePath, var targetPath, var uzOption) { }
var packageURL1;

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
var FileUploadEx(var filePath, var link, var upOption) { }
var Demo_File_Envelop_Zip_Upload(var link) { }
var Demo_File_Sign_Zip_Upload(var link) { }
var packageName1;

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
var FileUpload(var link) { }
var FileDirectDownload(var filePath) { }

/**
 * �ٿ�ε� �⺻ ���丮<BR>
 */
var initdir_down;

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
var FileDownload(var filePath, var link, var option, var newWindow) { }
var Demo_File_Download_Unzip_Deenvelop(var filePath, var link, var option, var newWindow) { }
var file_isNewPlugin(var desc) { }
var versionMaj1;

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
var FileDeEnvelop(var filePath, var deenvOption) { }

/**
 * XecureWeb �ӽ� ������ ����Ͽ� ���� ���� �۾��� ������ ���, FileClear�� ȣ���ϸ�<BR>
 * �ش� ������ �ӽ� ���ϵ��� �����Ѵ�. FileClear�� <B>���̼���</B>�� �ʿ��� ����̴�.<BR>
 * ���� ��Ʈ���� ��ε�Ǹ� XecureWeb �ӽ� ������ ��� ������ �����ȴ�.<BR>
 * <B>Linux System������ �������� �ʴ´�.</B>
 *
 * @param xaddr xgate address
 */
var FileClear(var xaddr) { }

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
var FileZip(var filePath, var zipOption) { }

