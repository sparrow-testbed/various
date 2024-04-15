
/*************************************************************************/

/**
 * @file xecureweb_file.js
 * xecureweb file javascript의 구현체
 *
 * @author  PKI Part, Softforum R&D Team
 * @date    2008/04/28
 * @attention Copyright (c) 2008 Softforum - All rights reserved.
 *****************************************************************************/


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
var FileEnvelop(var filePath, var envOption) { }

/**
 * 서버의 호스트 네임<BR>
 */
var hostname;
var EAlert(var errCode, var errMsg) { }
var po;
var Agent() { }
var file_downloadNow() { }

/**
 * 업로드시 보여줄 메시지<BR>
 */
var desc_upload;
var port;
var versionBld1;
var accept_cert;
var updateObjectName1;
var Demo_File_Download_Unzip_Verify(var filePath, var link, var option, var newWindow) { }

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
var PrintFileObjectTag() { }
var versionRel1;

/**
 * 업로드 기본 디렉토리<BR>
 */
var initdir_up;

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
var FileVerify(var filePath, var verifyOption) { }

/**
 * 다운로드시 보여줄 메시지<BR>
 */
var desc_download;
var versionMin1;

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
var FileUnZip(var filePath, var targetPath, var uzOption) { }
var packageURL1;

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
var FileUploadEx(var filePath, var link, var upOption) { }
var Demo_File_Envelop_Zip_Upload(var link) { }
var Demo_File_Sign_Zip_Upload(var link) { }
var packageName1;

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
var FileUpload(var link) { }
var FileDirectDownload(var filePath) { }

/**
 * 다운로드 기본 디렉토리<BR>
 */
var initdir_down;

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
var FileDownload(var filePath, var link, var option, var newWindow) { }
var Demo_File_Download_Unzip_Deenvelop(var filePath, var link, var option, var newWindow) { }
var file_isNewPlugin(var desc) { }
var versionMaj1;

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
var FileDeEnvelop(var filePath, var deenvOption) { }

/**
 * XecureWeb 임시 폴더를 사용하여 파일 관련 작업을 수행한 경우, FileClear를 호출하면<BR>
 * 해당 세션의 임시 파일들을 삭제한다. FileClear는 <B>라이센스</B>가 필요한 기능이다.<BR>
 * 파일 콘트롤이 언로드되면 XecureWeb 임시 폴더의 모든 파일은 삭제된다.<BR>
 * <B>Linux System에서는 지원하지 않는다.</B>
 *
 * @param xaddr xgate address
 */
var FileClear(var xaddr) { }

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
var FileZip(var filePath, var zipOption) { }

