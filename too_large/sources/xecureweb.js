
/**
 * @mainpage XecureWeb SSL Client JavaScript API�޴���
 * 
 * @section Program XecureWeb SSL Client JavaScript
 * - ���α׷� �̸� : XecureWeb SSL Client JavaScript
 * - ���α׷� ���� : XecureWeb SSL Client�� API�� ��ȭ�� ����� ����� ���ǿ� �µ��� �����Ѵ�.
 *
 * @section CREATEINFO �ۼ�����
 * - �ۼ��� : 2008/04/28
 */

/**
 * @file xecureweb.js
 * xecureweb javascript�� ����ü
 *
 * @author  PKI Part, Softforum R&D Team
 * @date    2008/04/28
 * @attention Copyright (c) 2008 Softforum - All rights reserved.
 */

/**
 * @defgroup clientRequestCryptoAPI Ŭ���̾�Ʈ Request ��ȣ API
 * Ŭ���̾�Ʈ Request ��ȣ API<BR>
 */

/**
 * @defgroup serverResponseCryptoAPI ���� Response ��ȣ API
 * ���� Response ��ȣ API<BR>
 */

/**
 * @defgroup digitalSignAPI ���ڼ��� API
 * ���ڼ��� API<BR>
 * @code
 * var sign_desc=����; ( ������� Ȯ��â�� �⺻ ���� )
 * var show_plain=1; ( 0 : ������� Ȯ��â ������ �ʱ� , 1 : ������� Ȯ��â ���̱� )
 * var accept_cert = ��yessign,SoftForum CA��; (���� ���� ��ȿ�� ������� ��� (CN) )
 * // Yessign Test : yessignCA-TEST
 * // Yessign Real : yessignCA
 * // SignGate Test : SignGateFTCA
 * // SignGate Real : signGate CA
 * // SignKorea Test : SignKorea Test CA
 * // SignKorea Real : SignKorea CA
 * // ��Ÿ ������������߱���(�������)��CN
 * var pwd_fail = 3; (������ ��ȣ ������ ���ȸ��)
 * var xgate_addr	= window.location.hostname + ��:443:8080��; 
 * (������ ���ǰ������� IP�� ��Ʈ��ȣ , 443 : Direct port , 8080 : Proxy port )
 * @endcode
 */

/**
 * @defgroup CMPAPI ������ �߱�/����/��� ���� CMP API
 * ������ �߱�/����/��� ���� CMP API<BR>
 * @code
 * var ca_ip =  ��203.233.91.232��;  (YesSign ���� ������� IP - Test)
 * var ca_ip =  ��203.233.91.71��;  (YesSign ���� ������� IP - Real)
 * var ca_ip =  "192.168.10.25;SoftforumCA"; (Xecure ������� IP;CA Name)
 * var ca_port = 4512; (YesSign ���� ������� Port )
 * var ca_type = 11; (YesSign ������� Type ? Test)
 * var ca_type = 1; (YesSign ������� Type ? Real)
 * var ca_type = 101; (Xecure ������� Type ? RSA)
 * var ca_type = 101+256; (Xecure ������� Type ? RSA & CSP ���� Ű1�ָ� ����)
 * var ca_type = 102; (Xecure ������� Type ? GPKI)
 * var pwd_fail = 3; (������ ��ȣ ������ ���ȸ��)
 * @endcode
 */

/**
 * @defgroup SFCA_CMPAPI SFCA ������ ���� API
 * SFCA ������ ���� API<BR>
 * <B>Linux System������ �������� �ʴ´�.</B>
 */

/**
 * @defgroup etcAPI ��Ÿ API
 * ��Ÿ API<BR>
 */


/**
 * �־��� �����ڷ� ���е� ���� �޾�. ������ token�� ���ؼ� �־��� serial�� ���� �������� ���ڼ����� �Ѵ�.<BR>
 * �̶�, ���ڼ���� �� ���� �����ڷ� ���еȴ�.<BR>
 * 
 * @param total ������ �������� ����
 * @param sign_msg ������ ������
 * @param delimeter �Է� �޽����� ������
 * @param serial ���� ����� �������� �ø��� ��ȣ
 * @param locaton ���� ����� �������� ��ġ ����
 * @return �����ڷ� �̷���� ���ڼ��� ������
 * @see MultiSign
 */
var MultiSignWithSerial(var total, var sign_msg, var delimeter, var serial, var locaton) { }

/**
 * �־��� ���ڿ��� Escape ó�� ���ش�.<BR>
 *
 * @param Msg ����
 * @return Escape�� ���ڿ�
 */
var XecureEscape(var Msg) { }

/**
 * ���� ����� �ĺ���ȣ Ȯ���� ����� ����� ���, IDN ���� Web Application �� �Ѱ��� ���, �����ϱ� ������ �� �Լ��� ���Ͽ� idn �� �Ѱ��ش�.<BR>
 * Sign_with_vid_web() ���ο� ����Ǿ� ����.
 *
 * @ingroup digitalSignAPI
 * @param idn �ĺ���ȣ(�ֹε��/����ڵ�Ϲ�ȣ)
 * @return Success : 0<BR>
 * Fail : -1
 */
var Set_ID_Num(var idn) { }

/**
 * �־��� �����Ϳ� ���� ������ �Ѵ�. <BR>
 * ������� Ȯ��â�� ������ ������ �� �ִ�.<BR>
 * �� �Լ��� ȣ���ϸ� ���ڼ��� �̷���� �� ���ȼ����� ��������� �ʴ´�.<BR>
 * @ingroup digitalSignAPI
 * @param plain �����ϰ��� �ϴ� ���� ����
 * @param desc ������� Ȯ��â�� ����
 * @return Success : ����� ����[���ڼ���=����+����+������]<BR>
 * Fail : empty string (����)
 */
var Sign_with_desc(var plain, var desc) { }
var xecure_ca_type_1;

/**
 * ���ں����� �����ϴ� XecureNagivate<BR>
 *
 * @ingroup clientRequestCryptoAPI
 * @since XecureWeb 6.0 v220
 * @see XecureNavigate
 */
var XecureNavigate_Env(var url, var target, var feature) { }

/**
 * ISO ������ url��ASCII ���ڿ��� ��ȯ�Ѵ�.
 *
 * @ingroup etcAPI
 * @param url escape ó���� ���ڿ�
 * @return escape ó���� ���ڿ�
 */
var escape_url(var url) { }
var getPath(var url) { }
var XecureAddQuery(var qs) { }
var s_sign_desc;

/**
 * �־��� ���� �����Ϳ� ���� ������ �Ѵ�. <BR>
 * ������� Ȯ��â Diplay ���� �� ������ ���� ��� �� �� �ִ�.<BR>
 * �� �Լ��� ȣ���ϸ� ���ڼ��� �̷���� �� ���ȼ����� ��������� �ʴ´�.<BR>
 * ���ڼ���� �ĺ���ȣ Ȯ���� ���Ͽ� Web Application���� ������� IDN�� �Է� �ϸ�, send_vid_info() �� ���� �ĺ� ��ȣ ������ ���� ��ȣȭ �� ���� ������ �� �ִ�.<BR>
 * <BR>
 * @ingroup digitalSignAPI
 * @param option : 0 : ������� Ȯ��â No Display, ��� ������ ���� �����ϰ�<BR>
 * 1 : ������� Ȯ��â Display, ��� ������ ���� �����ϰ�<BR>
 * 2 : ������� Ȯ��â No Display, Login�� �������θ� ���� �����ϰ�<BR>
 * 3 : ������� Ȯ��â Display, Login�� �������θ� ���� �����ϰ�
 * @param plain �����ϰ��� �ϴ� ���� ����
 * @param svrCert IDN, R ���� ��ȣȭ�ϱ� ���� ������ ( pem type )
 * @param idn �������� �ֹε��(����ڵ��)��ȣ
 *
 * @return Success : ����� ����[���ڼ���=����+����+������]<BR>
 * Fail : empty string (����)
 */
var Sign_with_vid_web(var option, var plain, var svrCert, var idn) { }
var Multi_Sign(var multiSignId, var Option) { }

/**
 * �������� �ĺ���ȣ�� �����Ѵ�.<BR/>
 *
 * @ingroup etcAPI
 * @param Idn <PRE>������ �������� �ĺ���ȣ<BR>
 * Idn�� �����̸� ����ڷκ��� IDN�� �Է¹޴´�.<BR>
 * option bit : _4_ _3_ _2_ _1_<BR>
 *                       |   |<BR>
 *                       |   --- 0 : ��� ������ ����Ʈ��, 1 : �α����� ������ ���<BR>
 *                          ------- 0 : ����ڿ��� idn �Է� �䱸, 1 : idn�� "NULL" setting, �������� idn ����</PRE>
 * @param TimeStamp ������ Ÿ�ӽ���
 * @param ServerCertPem pemŸ���� ����������
 *
 * @return �����ϸ� VID������ envelop�� ��� ����
 * ���н� ���� ����
 */
var VerifyVirtualID(var Idn, var TimeStamp, var ServerCertPem) { }
var isOldPlugin(var desc, var version) { }
var ran_gen() { }
var Multi_Sign_Init() { }
var XecureMakePlain_Org(var form) { }

/**
 * ����� PC�� ����� ������Ʈ ���������� ������ �����Ѵ�.<BR>
 * <BR>
 * example><BR>
 * SetUpdateInfo( ��PERIOD��, ��Apply��, ��0�� );<BR>
 * => �Ϸ�� �����Ǿ� �ִ� ������Ʈ �ֱ⸦ �Ͻ������� ��ȿȭ��Ŵ<BR>
 *
 * @ingroup etcAPI
 * @param section �ٿ�ε�� ������Ʈ ���������� section name
 * @param key section������ key name
 * @param value1 ������ ���� value
 *
 * @return 0 : ����, -1 : ����
 */
var SetUpdateInfo(var section, var key, var value1) { }
var XecureWebError() { }

/**
 * �־��� ���� �����Ϳ� ���� ������ �Ѵ�. <BR>
 * ������� Ȯ��â Diplay ���� �� ������ ���� ��� �� �� �ִ�.<BR>
 * �� �Լ��� ȣ���ϸ� ���ڼ��� �̷���� �� ���ȼ����� ��������� �ʴ´�.<BR>
 * �ĺ���ȣ�� ���Ե� �������� ����â���� ������� IDN�� �Է� �ϸ�, send_vid_info() �� ���� �ĺ� ��ȣ ������ ���� ��ȣȭ �� ���� ������ �� �ִ�.<BR>
 * <BR>
 * @ingroup digitalSignAPI
 * @param option 0 : ������� Ȯ��â No Display, ��� ������ ���� �����ϰ�<BR>
 * 1 : ������� Ȯ��â Display, ��� ������ ���� �����ϰ�<BR>
 * 2 : ������� Ȯ��â No Display, Login�� �������θ� ���� �����ϰ�<BR>
 * 3 : ������� Ȯ��â Display, Login�� �������θ� ���� �����ϰ�
 * @param plain �����ϰ��� �ϴ� ���� ����
 * @param svrCert IDN, R ���� ��ȣȭ�ϱ� ���� ������ ( pem type )
 *
 * @return Success : ����� ����[���ڼ���=����+����+������]<BR>
 * Fail : empty string (����)
 */
var Sign_with_vid_user(var option, var plain, var svrCert) { }

/**
 * <B>���� ������ �����ϰ� �־��� url��query string �κ��� ��ȣȭ ���� �ʰ� �̵��Ѵ�. script ( javascript Ȥ�� VBscript ) ���ο��� �̵��� ��� ���</B><BR>
 * <BR>
 * script�� �ȿ��� window.open �̳�, document.location.href ���� �̿��� ������ <BR>
 * �̵��ÿ� query string�� ��ȣȭ ���� �ʰ� �̵��� ���<BR>
 * window.open, document.location.href ���XecureNavigate_NoEnc �Լ��� ȣ���Ѵ�.</B> <BR>
 * <BR>
 * Query string�� ���� ���  :   <B>url?q=��ȣȭ�� SID</B><BR>
 * Query string�� �ִ� ���  :   <B>url?q=��ȣȭ�� SID;��ȣȭ ���� ���� ������</B><BR>
 * <BR>
 * @ingroup clientRequestCryptoAPI
 * @param url : �̵��� URL
 * @param target �̵��� Ÿ��
 * @return Success : true<BR>
 * Fail : false
 */
var XecureNavigate_NoEnc(var url, var target) { }
var xecure_ca_ip_1;
var cert_serial;

/**
 * �־��� �ø��� ��ȣ�� ��ġ�ϴ� �������� �־��� �����͸� ���� ������ �Ѵ�.<BR>
 * ������� Ȯ��â Diplay �� ������ �� �ִ�.<BR>
 * �� �Լ��� ȣ���ϸ� ���ڼ��� �̷���� �� ���ȼ����� ��������� �ʴ´�.<BR>
 * �ĺ���ȣ�� ���Ե� �������� ����â���� ������� IDN�� �Է��ϸ�, send_vid_info() �� ���� �ĺ� ��ȣ ������ ���� ��ȣȭ�� ���� ������ �� �ִ�.<BR>
 *
 * @ingroup digitalSignAPI
 * @param certSerial : ���� ����� �������� �ø��� ��ȣ<BR>
 * ���� ���� �ø����� ����� ��� ��,���� �����Ѵ�.<BR>
 * Ex) ��008ade93, 008ade94��
 * @param certLocation ���� ����� ������ ��ġ<BR>
 * 0 : �ϵ��ũ, 1 : �̵��ĵ�ũ, 2 : ICī��,3 :CSP 4: pkcs11,5:USBTOKEN_KIUP, 6 :iccard,  7 :NO_SMARTON, 8 : USBTOKEN_KIUP, 9 :YESSIGNM
 * @param option 0 : ������� Ȯ��â No Display<BR>
 * 1 : ������� Ȯ��â Display
 * @param plain �����ϰ��� �ϴ� ���� ����
 * @param svrCert IDN, R ���� ��ȣȭ�ϱ� ���� ������ ( pem type )
 *
 * @return Success : ����� ����[���ڼ���=����+����+������]<BR>
 * Fail : empty string (����)
 */
var Sign_with_vid_user_serial(var certSerial, var certLocation, var option, var plain, var svrCert) { }

/**
 * Xgate_addr�� �ش��ϴ� ���ȼ����� ������ �����Ѵ�.
 *
 * @ingroup etcAPI
 * @return Success : 0<BR>
 * Fail : �����ڵ�
 */
var EndSession() { }
var versionRel;

/**
 * ������� ������ �ٿ�ε�� ������� ������<BR>
 */
var pCaCertUrl;

/**
 * MultiSign ���ο��� ���Ǵ� ������� ����� �޸𸮸� �����Ѵ�.<BR>
 */
var Multi_Sign_Final(var multiSignId) { }
var Set_Multi_Sign_Data(var multiSignId, var plain) { }
var gIsContinue;
var escape_url_applet(var in_str) { }
var dec(var str) { }
var enc(var str) { }

/**
 * �־��� �����ڷ� ���е� ���� �޾�. ������ token�� ���ؼ� ���ڼ����� �Ѵ�.<BR>
 * �̶�, ���ڼ���� �� ���� �����ڷ� ���еȴ�.<BR>
 * 
 * @param total ������ �������� ����
 * @param sign_msg ������ ������
 * @param delimeter �Է� �޽����� ������
 * @return �����ڷ� �̷���� ���ڼ��� ������
 */
var MultiSign(var total, var sign_msg, var delimeter) { }

/**
 * Netscape�� ����&lt;EMBED&gt; Tag��, Internet Explorer�� ���� &lt;OBJECT&gt; Tag�� document.write�Ѵ�.<BR>
 * <BR>
 * example><BR>
 * &lt;html><BR>
 * &lt;head><BR>
 * &lt;form name='xecure' >&lt;input type=hidden name='p'>&lt;/form><BR>
 * &lt;script language='javascript' src='/XecureObject/xecureweb.js'>&lt;/script><BR>
 * &lt;script language='javascript' src='/XecureObject/xecureweb_file.js'>&lt;/script><BR>
 * &lt;script><BR>
 * PrintObjectTag();<BR>
 * PrintFileObjectTag();<BR>
 * &lt;/script><BR>
 * &lt;/head><BR>
 * &lt;body> &lt;/body>&lt;/html>
 * @ingroup etcAPI
 */
var PrintObjectTag() { }
var versionMin;
var XecurePath(var xpath) { }
var s_bannerPath;

/**
 * ������� ������ �ٿ�ε�� ������� ������ CN<BR>
 */
var pCaCertName;

/**
 * �ݰ�� CA�� ���� Port
 */
var yessign_ca_port;

/**
 * RSA 1024 bit ����Ű/����Ű���� ��������, ����Ű ������ Client ���� �����ϰ�<BR>
 * ����Ű ������ �����Ѵ�. (�缳 ������ �߱�/���Ž� �̿�Ǹ�, ������ �߱޽ÿ�<BR>
 * �Էµ� �ʿ��� ������� �� �Լ����� ���ϵ� ����Ű�� ������ �缳���������<BR>
 * �����Ͽ� �������� �߱�/���� �Ѵ�. )
 *
 * @ingroup SFCA_CMPAPI
 * @return Success : ������ ����Ű ���ڿ�<BR>
 * Fail : ����
 *
 */
var GenCertReq() { }

/**
 * �Ϻ�ȣ�� �������� ��õ� ���ڼ��� ��� ����<BR>
 * XecureWeb Java ���� �Ϻ�ȣ�� �ý��� ����Ʈ ���ڵ��� �ٸ� ���ڼ���<BR>
 * �޼����� ó���ϴ� ��� true ����
 *
 * @since 6.0 v210
 */
var usePageCharset;

/**
 * ���ȼ����� �����ϰ� <a href> ���� �̿��Ͽ� �־��� link��query string�� ��ȣȭ �Ͽ� �����Ѵ�.<BR>
 * �� �Լ��� ȣ��Ǹ� ��Ʈ���� ClientSM ���� xgate��SSL handshaking�� ��û�Ͽ� ���ο� ���� ������<BR>
 * �����ϰų� ����� ���ȼ����� ������ Resume�� ����.  javascript onClick �̺�Ʈ�� ����Ͽ�<BR>
 * XecureLink �Լ��� ȣ���Ѵ�. �� �Լ��� ����Ǿ� �־��� url�� �̵��� ��append �Ǵ� query string��<BR>
 * ������ �����̴�.<BR>
 * <BR>
 * ��ȣȭ�� �����Ͱ� ���� ���  :   <B>url?q=��ȣȭ�� SID</B><BR>
 * ��ȣȭ�� �����Ͱ� �ִ� ���  :   <B>url?q=��ȣȭ�� SID;��ȣȭ�� ������</B><BR>
 * <BR>
 * ex><BR>
 * <a href=��enc_demo_result.php?aa=test&bb=test�� onClick=��return XecureLink(this);��>��ȣ</a><BR>
 *
 * @ingroup clientRequestCryptoAPI
 * @param link link ��ü
 * @return Success : true
 * Fail : false
 k*/
var XecureLink(var link) { }
var get_sid() { }
var xecure_ca_ip;

/**
 * ClientSM�� ������ ������ �޴��� �� �󿡼� ���� ȣ���Ͽ� ����� �� �ִ�.
 * @ingroup etcAPI
 */
var ShowCertManager() { }

/**
 * ���ڼ���, ������ ����, ������ ���ÿ� ������ ��ȣ������ ���ȸ��<BR>
 */
var pwd_fail;

/**
 * <B>���� ������ �����ϰ� �־��� url��query string�� ��ȣȭ ���� �Էµ� frame ���� �̵��Ѵ�. script ( javascript Ȥ�� VBscript ) ���ο��� �̵��� ��� ���</B><BR>
 * <BR>
 * script�� �ȿ��� window.open �̳�, document.location.href ���� �̿��� ������ �̵��ÿ��� window.open, document.location.href ���<BR>
 * XecureNavigate �Լ��� ȣ���Ѵ�. <BR>
 * <BR>
 * Query string�� ���� ���  :   <B>url?q=��ȣȭ�� SID</B><BR>
 * Query string�� �ִ� ���  :   <B>url?q=��ȣȭ�� SID;��ȣȭ�� ������</B><BR>
 * <BR>
 * example><BR>
 * &lt;script language=javascript> <BR>
 * window.open ( ��/hello.php��, ��body�� ) ; <BR>
 * &lt;/script> <BR>
 * ==> <BR>
 * &lt;script language=javascript> <BR>
 * XecureNavigate ( ��/hello.php��, ��body�� ) ; <BR>
 * &lt;/script><BR>
 *
 * @ingroup clientRequestCryptoAPI
 * @param url �̵��� URL<BR>
 * @param target ��� ȭ���� ��µ� frame��<BR>
 * @param feature ���ο� â�� ���� ���� ( â ũ�� ��� ) ? �ɼ�
 *
 * @return Success : true<BR>
 * Fail : false
 *
 */
var XecureNavigate(var url, var target, var feature) { }
var XecureWebPlugin(var version) { }

/**
 * <B>���� ������ �����ϰ� &lt;form> ���� �Էµ� �����͸� ��ȣȭ �Ͽ� �����Ѵ�.</B> <BR>
 * <B>�� �Լ��� ����ϱ� ���ؼ��� �ݵ��</B><BR>
 * <B>&lt;form name=��xecure��>&lt;input type=hidden name=��p��>&lt;/form> �� ������ ���� ��ġ�ϵ��� �Ѵ�.</B><BR>
 * <BR>
 * �� �Լ��� ȣ��Ǹ� ��Ʈ���� ClientSM ���� xgate��SSL handshaking�� ��û�Ͽ� ���ο� ���� ������ �����ϰų�<BR>
 * ����� ���ȼ����� ������ Resume�� ����. javascript onSubmit �̺�Ʈ�� ����Ͽ� XecureSubmit �Լ��� ȣ���Ѵ�. 
 * <BR>
 * <B><�־��� form ���� method�� ��GET�� �� ���></B><BR>
 * form ���� �Է��ʵ���� input1=x&input2=&�� �������� ���� ��Ʈ�ѿ� ������ ��Ʈ���� ���ȼ����� ����/Resume ����<BR>
 * �Էµ� �����͸� ��ȣȭ�Ͽ� �����Ѵ�. ��ȣ���� �޾Ƽ� attach ���� target url�� �����Ѵ�.
 * �̶� �־��� form��action��query string�� �ִ� ��� ��query string�� ���õǰ� ���۵��� �ʴ´�.
 * <BR>
 * <B><�־��� form ���� method�� ��POST�� �� ���></B><BR>
 * form��action�� �־��� query string�� ��Ʈ�ѿ� ������ ��Ʈ���� ���ȼ����� ����/Resume�� �� �Էµ� �����͸�<BR>
 * ��ȣȭ �Ͽ� �����Ѵ�. ��ȣ���� �޾Ƽ� url?q=xxx ���·� �̹� ����� xecure frame��action ���� �����Ѵ�. 
 * form ���� �Է��ʵ���� input1=x&input2=&�� �������� ���� ��Ʈ�ѿ� ������ ��Ʈ���� (1) �������� ����/Resume��<BR>
 * ���������� �̿��Ͽ� form ���� �Է��ʵ���� ��ȣȭ �Ͽ� �����Ѵ�.
 * Xecure frame��p�ʵ忡 ���ϵ� ��ȣ���� �������� <BR>
 * xecure.summit() ���� (1)���� ������ url�� �̵��Ѵ�.<BR>
 * <BR>
 * ��ȣȭ�� �����Ͱ� ���� ���  :     <B>url?q=��ȣȭ�� SID</B><BR>
 * ��ȣȭ�� �����Ͱ� �ִ� ���  :     <B>url?q=��ȣȭ�� SID;��ȣȭ�� ������</B><BR>
 * <BR>
 * example><BR>
 * &lt;form name=��xecure��>&lt;input type=hidden name=��p��>&lt;/form><BR>
 * <BR>
 * &lt;form name=transfer action=��enc_demo_result.php�� method=��post��<BR>
 *  onSubmit=��return XecureSubmit(this);��> <BR>
 *  ... <BR>
 * &lt;/form><BR>
 *
 * @ingroup clientRequestCryptoAPI
 * @param form : form ��ü
 * @return Success : true<BR>
 * Fail : false
 */
var XecureSubmit(var form) { }
var Set_PinNumber(var pin) { }
var EnvelopData(var inMsg, var pwd, var certPem, var envOption) { }

/**
 * XecureWeb Control �� ���õ� ���� ������ �����Ѵ�.
 *
 * @ingroup etcAPI
 * @param nOption <BR>
 * 0 : (default value) File version, which is checked by 'Internet Explorer'<BR>
 * 1 : Product version<BR>
 * 2 : File Description
 *
 * @return nOption �� ���� ���� ����<BR>
 * �׳� GetVersion()�� ȣ���ϸ� Object tag���� �����ϴ� ������ ���� �� �ִ�.<BR>
 * ���ϰ��� ��7, 0, 5, 0�� �� ���� �����̴�.
 *
 */
var GetVersion(var nOption) { }

/**
 * ����� ���������� ã�Ƽ� �ش� Ű�� ��ȣȭ�� XML �����͸� ��ȣȭ�Ѵ�.
 *
 * @ingroup serverResponseCryptoAPI
 * @param cipher : ��ȣȭ�� XML data�� ��ȣ��
 * @return Success : ��ȣȭ�� ��<BR>
 * Fail : empty string (����) 
 */
var BlockXMLDec(var cipher) { }

/**
 * ���ڼ��� Ȯ��â�� ���� �޼����� ���ڼ��� Ȯ��â ���� �ɼ�<BR>
 * 0 : ���� ���� ��� ����, 1: ���� ���� ��� 
 */
var show_plain;
var versionMaj;
var DownloadPackage(var packageURL) { }

/**
 * [ ClinetSM : 2.3.3 / AcitveX 4.1.2.3 ���� Version�� ]<BR>
 * ����â�̳� ������Loginâ�� �̹����� �����Ѵ�. �̹��� BMP ������ �����Ѵ�. (���⼭�� login.bmp(�ػ�:290x64) �� ����)<BR>
 * XecureWeb ver4 server module�� ��ġ�Ǿ� �ִ� ���丮�� <BR>
 * /user/xecureweb_ver4�� �����ϸ�<BR>
 * /user/xecureweb_ver4/object/ �Ʒ��� login.bmp�� �����Ѵ�.<BR>
 * /user/xecureweb_ver4/object/xecureweb.js ������ ���� bannerUrl�� �����Ѵ�.<BR>
 * ��) var bannerUrl=<BR>
 * ��http://�� + window.location.hostname + ��/XecureObject/login.bmp��;<BR>
 * BMP�����..�ٸ��̸����� �����Ͽ��� �ٽ� DownLoad���� �� �ִ�.
 * @ingroup etcAPI
 */
var PutBannerUrl() { }

/**
 * ������� Ȯ��â�� �⺻ ����<BR>
 */
var sign_desc;
var busy_info;

/**
 * infoURL�κ��� ������ ����� ������Ʈ ���������� �̿��Ͽ� �ʿ��� ������ �ٿ�ε��Ͽ� ��ġ�Ѵ�.<BR>
 *
 * @ingroup etcAPI
 * @param infoURL : ������Ʈ ���������� �ִ� URL<BR>
 * Ex) infoURL = ��http://download.softforum.co.kr/ XecureWeb/Update/info.ini.sig��
 *
 * @return 0 : ����, 1 : ����� ���, 2 : ������Ʈ�� ������ �ٸ� ���ø����̼ǿ��� �����, 3 : �̹� ������Ʈ�Ǿ���, 4 : ������Ʈ ������ ���� �����, 5 : �ֽ� ������, -1 : ����
 */
var UpdateModules(var infoURL) { }
var DeleteCertificate(var dn) { }

/**
 * ������ �����ϰ� ���� ������ �����Ѵ�. ���� �ɼǿ� ���� �پ��� ���� �����<BR>
 * ������ �� �ִ�. ���� Verify_SignedData�� �Լ� ����� ���� <B>���̼���</B>�� �ʿ��ϴ�.
 *
 * @ingroup digitalSignAPI
 * @param signedData : ������ �����
 * @param option : ���� ���� �ɼ�<BR>
 * 0 : ������ ����(�������� ���� ������ ����)<BR>
 * 1 : 0�� ���Ͽ� ������ ����<BR>
 * 2 : 1�� ���Ͽ� ������ ü�α��� ����<BR>
 * 3 : 2�� ���Ͽ� ������ CRL üũ<BR>
 * 4 : 3�� ���Ͽ� LDAP���� ������ ����<BR>
 * @param directoryServer : CRL�� ������ ���丮 ���� �ּ�<BR>
 * Ex) dirsys.rootca.or.kr:389<BR>
 * ������ �Է��ϸ� �������� ���Ե� CRL �й��� �̿��Ͽ� CRL üũ<BR>
 *
 * @return Success : ���� ����
 * Fail : ����<BR>
 * <B>������ ���� ������ �ϴ� �����ϸ� ������ ������ ������ �߻��ϴ��� ���� ������ �����Ѵ�. ���� ��ü���� ���� �ɼǿ� ���� ���� ������ �ùٸ��� �Ǿ������� Ȯ���ϱ� ���ؼ���, ���ϰ� Ȯ�ΰ� �Բ� LastErrCode ������ ���� ���θ� Ȯ���ؾ� �Ѵ�.</B>
 */
var Verify_SignedData(var signedData, var option, var directoryServer) { }

/**
 * Send_vid_info_user() �Ǵ� Send_vid_info_web() ȣ���� ���Ͽ� �ĺ���ȣ�� ���Ե� �������� ���,<BR>
 * �ĺ���ȣ(VID)�� Ȯ���ϱ� ���� ������ ��ȣȭ �Ͽ� return �Ѵ�.<BR>
 * ����, �ĺ���ȣ�� ���Ե��� ���� �������� ��� null �� return �Ѵ�.
 * 
 * @ingroup digitalSignAPI
 * @return Success : �ĺ� ��ȣ ������ ���� ��ȣȭ�� ����<BR>
 * Fail : empty string (����)
 */
var send_vid_info() { }

/**
 * �ݰ�� CA�� ����<BR>
 * 1 : Yessign Real<BR>
 * 11 : Yessign Test
 */
var yessign_ca_type;
var IsNetscape60() { }

/*************For Applet**********************/
var BlockEnc(var auth_type, var plain_text) { }
var isNewPlugin(var desc) { }

/**
 * ���ں����� �����ϴ� XecureSubmit<BR>
 *
 * @ingroup clientRequestCryptoAPI
 * @since XecureWeb 6.0 v220
 * @see XecureSubmit
 */
var XecureSubmit_Env(var form) { }

/**
 * ����� ���������� ã�Ƽ� �ش� Ű�� ��ȣ���� ��ȣȭ�Ѵ�.<BR>
 *
 * @ingroup serverResponseCryptoAPI
 * @param cipher ��ȣȭ�� ��ȣ��
 * @return Success : ��ȣȭ�� ��<BR>
 * Fail : empty string (����) 
 */
var BlockDec(var cipher) { }

/**
 * �� �Լ��� �����Ű�� ����� �������� �������� �� �������� ����ϰ� �����<BR>
 * ��ġ���� ������Ų��. ( �ϵ��ũ/�÷��� ��ũ/ICī��)
 *
 * @ingroup CMPAPI
 * @param type  00 : YessignCA, 11 : XecureCA
 * @param jobcode <BR>
 * ������ ��� : 17<BR>
 * ������ ȿ������ : 256
 * @param reason (���/ȿ������ ���� )<BR>
 * 1 : keyCompromise ( default )<BR>
 * 2 : cACompromise<BR>
 * 3 : affiliationChanged<BR>
 * 4 : superseded<BR>
 * 5 : cessationOfOperation<BR>
 * 6 : certificateHold
 *
 * @return Success : 0<BR>
 * Fail : -1
 */
var RevokeCertificate(var type, var jobcode, var reason) { }

/**
 * �־��� �����Ϳ� ���� ������ �Ѵ�. <BR>
 * ������� Ȯ��â Diplay ���� �� ������ ���� ��� �� �� �ִ�.<BR>
 * �� �Լ��� ȣ���ϸ� ���ڼ��� �̷���� �� ���ȼ����� ��������� �ʴ´�.<BR>
 * <BR>
 * @param option : 0 : ������� Ȯ��â No Display, ��� ������ ���� �����ϰ�<BR>
 * 1 : ������� Ȯ��â Display, ��� ������ ���� �����ϰ�<BR>
 * 2 : ������� Ȯ��â No Display, Login�� �������θ� ���� �����ϰ�<BR>
 * 3 : ������� Ȯ��â Display, Login�� �������θ� ���� �����ϰ�<BR>
 * @param plain : �����ϰ��� �ϴ� ���� ����
 * @return Success : ����� ����[���ڼ���=����+����+������]<BR>
 * Fail : empty string (����)
 */
var Sign_with_option(var option, var plain) { }

/**
 * ���� ���� ��ȿ�� ������� ��� (CN)<BR>
 * Sign, RequestCertificate, RevokeCertificate �� ��Ÿ���� ������ ��� <BR>
 * XecureWeb ver 5.1 ������ accept_cert �� ��ȿ�� ������� �������� <BR>
 * CN �� ��Ȯ�� �����ش�.<BR>
 * ver 4.0 ���� yessign �̶� ������ ���� yessignCA-TEST, yessignCA �� ����ȭ �ȴ�.<BR>
 * YESSIGN TEST : yessignCA-TEST<BR>
 * YESSIGN REAL : yessignCA<BR>
 */
var accept_cert;
var quick_escape(var str) { }

/**
 * �ݰ�� CA�� ���� IP
 */
var yessign_ca_ip;

/**
 * MultiSign ���ο��� ����ϴ� ���.<BR>
 */
var Get_Multi_Signed_Data(var multiSignId, var index) { }

/**
 * �缳 ��������� ���� �缳������� �������� ����ڿ��� �����Ѵ�.<BR>
 *
 * @ingroup etcAPI
 * @return Success : 0<BR>
 * Fail : -1
 */
var PutCACert() { }

/**
 * �־��� ���� �����Ϳ� ���� ������ �Ѵ�. <BR>
 * ������� Ȯ��â Diplay ���� �� ������ ���� ��� �� �� �ִ�.<BR>
 * �� �Լ��� ȣ���ϸ� ���ڼ��� �̷���� �� ���ȼ����� ��������� �ʴ´�.<BR>
 * <BR>
 * @ingroup digitalSignAPI
 * @param option 0 : ������� Ȯ��â No Display, ��� ������ ���� �����ϰ�<BR>
 * 1 : ������� Ȯ��â Display, ��� ������ ���� �����ϰ�<BR>
 * 2 : ������� Ȯ��â No Display, Login�� �������θ� ���� �����ϰ�<BR>
 * 3 : ������� Ȯ��â Display, Login�� �������θ� ���� �����ϰ�
 * @param plain �����ϰ��� �ϴ� ���� ����
 *
 * @return Success : ����� ����[���ڼ���=����+����+������(n)]<BR>
 * Fail : empty string (����)
 */
var Sign_Add(var option, var plain) { }

/**
 * �߱�/���ŵ� �缳 �������� �����Ų��. (���� ���ɸ�ü : �ϵ��ũ/ICī��)
 *
 * @ingroup SFCA_CMPAPI
 * @param cert_type �߱޵� ������ ����<BR>
 * 1 : ������� ������<BR>
 * 2 : ����� ������<BR>
 * 5 : ��ȣȭ�Ͽ� ������ ����� ������<BR/.
 * @param cert : �߱޵� ������ 
 */
var InstallCertificate(var cert_type, var cert) { }

/**
 * �α��� â�� ���� �̹����� �ٿ�ε� ���� URL<BR>
 */
var bannerUrl;

/**
 * �����ڵ�� �ΰ��ڵ带 ������ ������������� �����Ͽ� �������� �߱޹޴´�. ������ �߱� ��ġ�� �ϵ��ũ/ICī�� �̴�.
 * 
 * @ingroup CMPAPI
 * @param type CA TYPE 10: YessignCA, 11: XecureCA
 * @param ref_code �����ڵ�
 * @param auth_code �ΰ��ڵ�
 *
 * @return Success : 0<BR>
 * Fail : -1
 */
var RequestCertificate(var type, var ref_code, var auth_code) { }
var packageURL;
var SetProviderList() { }
var XecureNavigate2iframe(var url, var target, var feature, var sid) { }

/**
 * ���ȼ����� �����ϰ� <a href> ���� �̿��Ͽ� �־��� link��query string�� ��ȣȭ �Ͽ� �����Ѵ�.<BR>
 * ex>
 * <a href=��transfer_input.php �� target=main 
 * onClick=��return XecureLogIn(this);��>�α���</a>
 *
 * @param link link ��ü
 * @return Success : true <BR>
 * Fail : false
 */
var XecureLogIn(var link) { }
var downloadNow() { }
var XecureUnescape(var Msg) { }

/**
 * ���ں����� �����ϴ� XecureLink<BR>
 *
 * @ingroup clientRequestCryptoAPI
 * @since XecureWeb 6.0 v220
 * @see XecureLink
 */
var XecureLink_Env(var link) { }

/**
 * xgate ���� ��:��Ʈ ���� , ��Ʈ ������ ����Ʈ�� 443 ��Ʈ ���<BR>
 */
var xgate_addr;

/**
 * �־��� form ���� �Է��ʵ��� type��button/reset/submit�� ���� �����ϰ�<BR>
 * aa=bb&cc=dd&ee=��  �������� ���ۼ��Ͽ� �����Ѵ�.
 *
 * @param form form ��ü
 * @return Form ���� �Է��ʵ�� ������ �ۼ��� ������
 */
var XecureMakePlain(var form) { }
var IsNetscape() { }

/**
 * �־��� �ø��� ��ȣ�� ��ġ�ϴ� �������� �־��� �����͸� ���� ������ �Ѵ�. <BR>
 * ������� Ȯ��â Diplay ������ ������ �� �ִ�.<BR>
 * �� �Լ��� ȣ���ϸ� ���ڼ��� �̷���� �� ���ȼ����� ��������� �ʴ´�.<BR>
 *
 * @ingroup digitalSignAPI
 * @param certSerial : ���� ����� �������� �ø��� ��ȣ<BR>
 * ���� ���� �ø����� ����� ��� ��,���� �����Ѵ�.<BR>
 * Ex) ��008ade93, 008ade94��<BR>
 * @param certLocation ���� ����� ������ ��ġ<BR>
 * 0 : �ϵ��ũ, 1 : �̵��ĵ�ũ, 2 : ICī��,3 :CSP 4: pkcs11,5:USBTOKEN_KIUP, 6 :iccard,  7 :NO_SMARTON, 8 : USBTOKEN_KIUP, 9 :YESSIGNM
 * @param option 0 : ������� Ȯ��â No Display<BR>
 * 1 : ������� Ȯ��â Display
 * @param plain �����ϰ��� �ϴ� ���� ����
 * @return Success : ����� ����[���ڼ���=����+����+������]<BR>
 * Fail : empty string (����)
 *
 */
var Sign_with_serial(var certSerial, var certLocation, var plain, var option) { }

/**
 * ����â, ����â, Loginâ���� ������ List�� �����Ͽ� �߱��ڸ� Rename�� ��<BR>
 * ����ϸ�, ������ �������� ��å���� �������� Rename�ǰ�, Default�� �缳������ �̴�.<BR>
 * �߱��ڴ� ������ �߱����� CN���� �������� Rename�ȴ�.<BR>
 * �ڼ��� ���� SE���� ����.<BR>
 * @ingroup etcAPI
 */
var SetConvertTable() { }
var xecure_ca_port;
var UserAgent() { }

/**
 * �־��� �ø��� ��ȣ�� ��ġ�ϴ� �������� �־��� �����͸� ���� ������ �Ѵ�.<BR>
 * ������� Ȯ��â Diplay �� ������ �� �ִ�.<BR>
 * �� �Լ��� ȣ���ϸ� ���ڼ��� �̷���� �� ���ȼ����� ��������� �ʴ´�.<BR>
 * ���ڼ���� �ĺ���ȣ Ȯ���� ���Ͽ� Web Application���� ������� IDN�� �Է��ϸ�, send_vid_info() �� ���� �ĺ� ��ȣ ������ ���� ��ȣȭ �� ���� ������ �� �ִ�.<BR>
 *
 * @ingroup digitalSignAPI
 * @param certSerial ���� ����� �������� �ø��� ��ȣ<BR>
 * ���� ���� �ø����� ����� ��� ��,���� �����Ѵ�.<BR>
 * Ex) ��008ade93, 008ade94��
 * @param certLocation ���� ����� ������ ��ġ<BR>
 * 0 : �ϵ��ũ, 1 : �̵��ĵ�ũ, 2 : ICī��,3 :CSP 4: pkcs11,5:USBTOKEN_KIUP, 6 :iccard,  7 :NO_SMARTON, 8 : USBTOKEN_KIUP, 9 :YESSIGNM
 * @param option 0 : ������� Ȯ��â No Display<BR>
 * 1 : ������� Ȯ��â Display
 * @param plain �����ϰ��� �ϴ� ���� ����
 * @param svrCert IDN, R ���� ��ȣȭ�ϱ� ���� ������ ( pem type )
 * @param idn �������� �ֹε��(����ڵ��)��ȣ
 *
 * @return Success : ����� ����[���ڼ���=����+����+������]<BR>
 * Fail : empty string (����)
 */
var Sign_with_vid_web_serial(var certSerial, var certLocation, var option, var plain, var svrCert, var idn) { }
var xecure_ca_port_1;

/**
 * �� �Լ��� �����Ű�� ������ �������� �������� �� �������� �����Ͽ� ���õ� ��ġ�� �ٽ� �����Ų��. ( �ϵ��ũ/�÷��� ��ũ/ICī��)
 *
 * @ingroup CMPAPI
 * @return Success : 0<BR>
 * Fail : -1
 */
var RenewCertificate(var type) { }

/**
 * �־��� �����Ϳ� ���ڼ����� �Ѵ�.<BR>
 * ������� Ȯ��â�� �� ��� â�� ������ sign_desc �̴�.<BR>
 * �� �Լ��� ȣ���ϸ� ���ڼ��� �̷���� �� ���ȼ����� ��������� �ʴ´�.<BR>
 * @ingroup digitalSignAPI
 * @param plain :  �����ϰ��� �ϴ� ���� ����
 * @return Success : ����� ����[���ڼ���=����+����+������]<BR>
 * Fail : empty string (����) 
 */
var Sign(var plain) { }
var xecure_ca_type;

