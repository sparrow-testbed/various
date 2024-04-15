//////////////////////////////Update Zhang////////////////////////////////
// XecureWeb SSL Client Java Script ver4.1  2001.5.30
//
// ���� : Netscape 6.0�� �������� �ʽ��ϴ�....
// Edit List 2000,05,30
// process_error() --> XecureWebError() // by Zhang ����
// function IsNetscape60()		// by Zhang �߰�
// function XecureUnescape(Msg)		// by Zhang �߰�
// function XecureEscape(Msg)		// by Zhang �߰�
// function XecurePath(xpath)		// by zhang �߰�

var gIsContinue=0;
var busy_info = "��ȣȭ �۾��� �������Դϴ�. Ȯ���� �����ð� ��� ��ٷ� �ֽʽÿ�."
var E2E_keytype = 1;
///////////// since 6.0 v210 //////////////////////////////////////////////
// usePageCharset : �Ϻ�ȣ�� �������� ��õ� ���ڼ��� ��� ����
// XecureWeb Java ���� �Ϻ�ȣ�� �ý��� ����Ʈ ���ڵ��� �ٸ� ���ڼ���
// �޼����� ó���ϴ� ��� true ����
// 
var usePageCharset=true;
var gXWCMPInfoList;

function XWCMPInfo (name, aIP, aPort, aType, aCAName, aRAName)
{
	this.mName = name;
	this.mIP = aIP;
	this.mPort = aPort;
	this.mType = aType;

	this.setCAName (aCAName);
	this.setRAName (aRAName);

};

XWCMPInfo.prototype = {

	setCAName : function (aCAName)
	{
		if (aCAName != undefined)
			this.mCAName = aCAName;
		else
			this.mCAName = null;
	},

	setRAName : function (aRAName)
	{
		if (aRAName != undefined)
			this.mRAName = aRAName;
		else
			this.mRAName = null;
	},
	getCAName : function ()
	{
		return this.mCAName;
	},

	getRAName : function ()
	{
		return this.mRAName;
	},

	getType : function ()
	{
		return this.mType;
	},

	getIP : function ()
	{
		return this.mIP;
	},

	getPort : function ()
	{
		return this.mPort;
	},

	getName : function ()
	{
		return this.mName;
	},

	show : function ()
	{
		var res = "";
		res += "[Name]:" + this.mName + "\n";
		res += "[IP]:" + this.mIP + "\n";
		res += "[Port]:" + this.mPort + "\n";
		res += "[Type]:" + this.mType + "\n";
		res += "[CAName]:" + this.mCAName+ "\n";
		res += "[RAName]:" + this.mRAName+ "\n";
	}
};

gXWCMPInfoList = new Array ();

gXWCMPInfoList.push (new XWCMPInfo("Yessign", "203.233.91.71", 4512, 11));
gXWCMPInfoList.push (new XWCMPInfo("SignGate", "61.72.247.152", 4502, 12));
gXWCMPInfoList.push (new XWCMPInfo("SignKorea", "211.175.81.101", 4099, 13));
gXWCMPInfoList.push (new XWCMPInfo("CrossCert", "203.238.26.30", 4512, 14));

// 2048 (203.233.91.231)
gXWCMPInfoList.push (new XWCMPInfo("Yessign Test 1", "203.233.91.231;yessignCA-Test Class 1,yessignCA-Test Class 0", 4512, 11 + 256));
gXWCMPInfoList.push (new XWCMPInfo("Yessign Test 0", "203.233.91.234;yessignCA-Test Class 1,yessignCA-Test Class 0,Root CA", 4512, 11 + 256));
gXWCMPInfoList.push (new XWCMPInfo("SignGate Test", "61.72.247.152", 4502, 12 + 256));
gXWCMPInfoList.push (new XWCMPInfo("SignKorea Test", "211.175.81.101", 4099, 13 + 256));
gXWCMPInfoList.push (new XWCMPInfo("CrossCert Test", "203.238.26.30", 4512, 14 + 256));

gXWCMPInfoList.push (new XWCMPInfo("XecureCA RSA 2048", "192.168.10.30;test ca",12101, 101));
//gXWCMPInfoList.push (new XWCMPInfo("XecureCA RSA 1024", "192.168.10.30;CA130000002",29211, 101));

// �Ʒ����� �ڵ��� ����Բ� �ӽ�.
gXWCMPInfoList.push (new XWCMPInfo("XecureCA RSA 1024", "192.168.10.3;CA131000031T",20101, 101));
// Test ����û ���������
//gXWCMPInfoList.push (new XWCMPInfo("XecureCA KCDSA 2048", "192.168.10.30;test ca", 12101, 102));
//gXWCMPInfoList.push (new XWCMPInfo("XecureCA KCDSA 1024", "192.168.10.30;CA130000002", 29211, 102));
//gXWCMPInfoList.push (new XWCMPInfo("XecureCA KCDSA 2048", "192.168.10.30;CA130000031T:1.2.410.100001.2.2", 12101, 102));
gXWCMPInfoList.push (new XWCMPInfo("XecureCA KCDSA 2048", "192.168.10.30;CA130000031T:1.2.410.100001.2.2,CA130000002", 12101, 102));
gXWCMPInfoList.push (new XWCMPInfo("XecureCA KCDSA 1024", "192.168.10.30;CA130000031T:1.2.410.100001.2.2,CA130000002", 29211, 102));
//gXWCMPInfoList.push (new XWCMPInfo("XecureCA KCDSA 1024", "192.168.10.30;CA131000031T",24101, 102));


// ����� ���� CA �߱��� ǥ��
//gXWCMPInfoList.push (new XWCMPInfo("XecureCA", "192.168.10.30;CA130000031T", 12101, 120));	// �߱��� ��Ī ����� ����
gXWCMPInfoList.push (new XWCMPInfo("Xecure Defined CA RSA", "192.168.10.30;test ca", 12101, 120));
gXWCMPInfoList.push (new XWCMPInfo("Xecure Defined CA KCDSA", "192.168.10.30;test ca", 12101, 121));

gXWCMPInfoList.push (new XWCMPInfo("MPKI", "192.168.10.30;pki50ca", 10101, 110, "ldap.gcc.go.kr:389/cn=CA131000002,ou=GPKI,o=Government of Korea,c=KR", "cn=RA143000001,cn=CA131000002,ou=GPKI,o=Government of Korea,c=KR"));

var yessign_ca_type = 11+256;	// Yessign Test (sign Only)
var yessign_ca_ip =  "203.233.91.231"; // 2048bits
//var yessign_ca_ip =  "203.233.91.234"; // 1024bits
var yessign_ca_port = 4512; //3280

var xecure_ca_type = 101;	// XecureCA (RSA)
var xecure_ca_ip = "192.168.10.3;test ca"; //
var xecure_ca_port = 22600; 

// Test by ghlee 20110608
var xecure_ca_type_1 = 102; //(KCSSA)for military ,silvertest.

var xecure_ca_ip_1 =  "192.168.10.30";  //
var xecure_ca_port_1 = 28101;
/*
var xecure_ca_type_1 = 102; //(KCSSA)for military ,silvertest.

var xecure_ca_ip_1 =  "192.168.10.30;mma ca";  //
var xecure_ca_port_1 = 21101;
*/

/*
var xecure_ca_type = 101;	// XecureCA (RSA)
var xecure_ca_ip = "192.168.10.30;pki50ca"; //
var xecure_ca_port = 21101; 

var xecure_ca_type_1 = 102; //(KCSSA)for military ,silvertest.

var xecure_ca_ip_1 =  "192.168.10.30;mma ca";  //
var xecure_ca_port_1 = 21101;

*/
var mpki_ca_type = 110;
var mpki_ca_ip =  "192.168.10.30;pki51 ca";
var mpki_ca_port = 10101;
var mpki_ca_name = "ldap.gcc.go.kr:389/cn=CA131000002,ou=GPKI,o=Government of Korea,c=KR";  // example
var mpki_ra_name = "cn=RA143000001,cn=CA131000002,ou=GPKI,o=Government of Korea,c=KR";      // example

var signgate_ca_type = 12+256; //signgate test
var signgate_ca_ip = "61.72.247.152";
var signgate_ca_port = 4502;

var crosscert_ca_type = 14+256;//��������
var crosscert_ca_ip = "203.238.26.30";
var crosscert_ca_port = 4512;

var signkorea_ca_type = 13+256;//�ڽ���
var signkorea_ca_ip = "211.175.81.101";
var signkorea_ca_port = 4099;


function GetXWCMPInfo (name)
{
	var aInfo = null;
	for (aInfo in gXWCMPInfoList)
	{
		if (gXWCMPInfoList[aInfo].getName () == name)
		{
			return gXWCMPInfoList[aInfo];
		}
	}
	return null;
}

function GetCAInfo (type)
{
	var aXWCMPInfo = null;
	switch (parseInt(type))
	{
		case 1:
			aXWCMPInfo = GetXWCMPInfo ("Yessign");
			break;

		case 2:
			aXWCMPInfo = GetXWCMPInfo ("SignGate");
			break;

		case 3:
			aXWCMPInfo = GetXWCMPInfo ("SignKorea");
			break;

		case 4:
			aXWCMPInfo = GetXWCMPInfo ("CrossCert");
			break;

		case 10:
		case 11:
			// by jjw
			if(location.port == 9090)	// 1024 
				aXWCMPInfo = GetXWCMPInfo ("Yessign Test 0");
			else											// 2048
				aXWCMPInfo = GetXWCMPInfo ("Yessign Test 1");
		
			break;

		case 12:
			aXWCMPInfo = GetXWCMPInfo ("SignGate Test");
			break;

		case 13:
			aXWCMPInfo = GetXWCMPInfo ("SignKorea Test");
			break;

		case 14:
			aXWCMPInfo = GetXWCMPInfo ("CrossCert Test");
			break;

		case 21:
			/* SFCA �� */
			alert ("�������� �ʴ� ������� �Դϴ�.");
			break;

		case 101:
			// by jjw
			if(location.port == 9090)
				aXWCMPInfo = GetXWCMPInfo ("XecureCA RSA 1024");
			else
				aXWCMPInfo = GetXWCMPInfo ("XecureCA RSA 2048");
			break;

		case 102:
			if(location.port == 9090)
				aXWCMPInfo = GetXWCMPInfo ("XecureCA KCDSA 1024");
			else
				aXWCMPInfo = GetXWCMPInfo ("XecureCA KCDSA 2048");
			break;

		case 110:
			aXWCMPInfo = GetXWCMPInfo ("MPKI");
			break;

		case 120:   // Defined CA RSA
			aXWCMPInfo = GetXWCMPInfo ("Xecure Defined CA RSA");
			break;

		case 121:		// Defined CA KCDSA
			aXWCMPInfo = GetXWCMPInfo ("Xecure Defined CA KCDSA");
			break;
			
		case 202:
			/* GPKI �� */
			alert ("�������� �ʴ� ������� �Դϴ�.");
			break;

		case 203:
		case 204:
		case 210:
			
			break;

		default:
			/* ���� */
			break;
	}

	return aXWCMPInfo;
}

///////////////////////////////////////////////////////////////////////////////
// !!!!!!!!!!!!!!< ���� >!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// Sign, RequestCertificate, RevokeCertificate �� ��Ÿ���� ������ ��� 
// XecureWeb ver 5.1 ������ accept_cert �� ��ȿ�� ������� �������� 
// CN �� ��Ȯ�� �����ش�.
// ver 4.0 ���� yessign �̶� ������ ���� yessignCA-TEST, yessignCA �� ����ȭ �ȴ�.
// YESSIGN TEST : yessignCA-TEST
// YESSIGN REAL : yessignCA
////////////////////////////////////////////////////////////////////////////////
//var accept_cert = "yessignCA-Test Class 1,SOFO RootCA 1,Root CA,XecurePKI51 ca,cn=CA131000010,pki50ca,CA131000002Test,CA131000002,CA131000010,Softforum CA 3.0,SoftforumCA,yessignCA-OCSP,yessignCA,signGATE CA,SignKorea CA,CrossCertCA,CrossCertCA-Test2,3280TestCAServer,NCASignCA,TradeSignCA,yessignCA-TEST,lotto test CA,NCATESTSign,SignGateFTCA,SignKorea Test CA,TestTradeSignCA,Softforum Demo CA,mma ca,����û �������,MND CA,signGATE FTCA02,.ROOT.CA.KT.BCN.BU,CA974000001,setest CA,3280TestCAServer:yessignCA-Test Class 0:test ca"; // added [CA974000001] 20080205

// accept_cert_list included OID (Wooribank)
var IsAttachedOID = 'TRUE';
//var IsAttachedOID = 'FALSE';
if(IsAttachedOID == 'TRUE')
{
		var accept_cert = "yessignCA:1.2.410.200005.1.1.1:1.2.410.200005.1.1.2:1.2.410.200005.1.1.4:1.2.410.200005.1.1.5";
		accept_cert+=",signGATE CA:1.2.410.200004.5.2.1.2:1.2.410.200004.5.2.1.1:1.2.410.200004.5.2.1.7.1";
		accept_cert+=",SignKorea CA:1.2.410.200004.5.1.1.7:1.2.410.200004.5.1.1.5";
		accept_cert+=",NCASign CA:1.2.410.200004.5.3.1.2:1.2.410.200004.5.3.1.9";
		accept_cert+=",CrossCertCA:1.2.410.200004.5.4.1.1:1.2.410.200004.5.4.1.2:1.2.410.200004.5.4.1.101";
		accept_cert+=",TradeSignCA:1.2.410.200012.1.1.3:1.2.410.200012.1.1.1:1.2.410.200012.1.1.101";
		accept_cert+=",signGATE CA2:1.2.410.200004.5.2.1.2:1.2.410.200004.5.2.1.1:1.2.410.200004.5.2.1.7.1";
		accept_cert+=",NCASignCA:1.2.410.200004.5.3.1.2:1.2.410.200004.5.3.1.9";
		accept_cert+=",CrossCert Certificate Authority:1.2.410.200004.5.4.1.1:1.2.410.200004.5.4.1.2:1.2.410.200004.5.4.1.101";
		accept_cert+=",yessignCA-TEST:1.2.410.200005.1.1.1:1.2.410.200005.1.1.2:1.2.410.200005.1.1.4:1.2.410.200005.1.1.5";
		accept_cert+=",yessignCA-Test Class 1:1.2.410.200005.1.1.1:1.2.410.200005.1.1.4:1.2.410.200005.1.1.2:1.2.410.200005.1.1.4:1.2.410.200005.1.1.5";
		accept_cert+=",yessignCA-Test Class 0:1.2.410.200005.1.1.5:1.2.410.200005.1.1.4";
		accept_cert+=",SignGateFTCA CA:1.2.410.200004.5.2.1.2:1.2.410.200004.5.2.1.1:1.2.410.200004.5.2.1.7.1";
		accept_cert+=",SignKorea Test CA:1.2.410.200004.5.1.1.7:1.2.410.200004.5.1.1.5";
		accept_cert+=",NCATESTSign:1.2.410.200004.5.3.1.2:1.2.410.200004.5.3.1.9";
		accept_cert+=",CrossCertCA-Test2:1.2.410.200004.5.4.1.1:1.2.410.200004.5.4.1.2:1.2.410.200004.5.4.1.101";
		accept_cert+=",TestTradeSignCA:1.2.410.200012.1.1.3:1.2.410.200012.1.1.1:1.2.410.200012.1.1.101";
		accept_cert+=",CA131000001:1.2.410.100001.2.1.1";
		accept_cert+=",MPKI_Test_CA,MMACA001";
		accept_cert+=",Root CA";
		accept_cert+=",TradeSignCA2011Test2";
		accept_cert+=",CA130000002";
		accept_cert+=",MMAPKI_Test_CA";
		accept_cert+=",TradeSignCA2,yessignCA Class 1";
		accept_cert+=",CA130000031T,CA131000031T,yessignCA-Test Class 0";
		accept_cert+=",��� CA,���CA"; // ����� ICī�� ������ ���� �׽�Ʈȯ�� ����
}
else
{
	var accept_cert = "yessignCA-Test Class 1,SOFO RootCA 1,Root CA,XecurePKI51 ca,cn=CA131000010,pki50ca,CA131000002Test,CA131000002,CA131000010,Softforum CA 3.0,SoftforumCA,yessignCA-OCSP,yessignCA,signGATE CA,SignKorea CA,CrossCertCA,CrossCertCA-Test2,3280TestCAServer,NCASignCA,TradeSignCA,yessignCA-TEST,lotto test CA,NCATESTSign,SignGateFTCA,SignKorea Test CA,TestTradeSignCA,Softforum Demo CA,mma ca,����û �������,MND CA,signGATE FTCA02,.ROOT.CA.KT.BCN.BU,CA974000001,setest CA,3280TestCAServer:yessignCA-Test Class 0:test ca,yessignCA-Test Class 0"; // added [CA974000001] 20080205			
}

/////////////////////////////////////////////////////////////////////////////////
// ���ڼ���, ������ ����, ������ ���ÿ� ������ ��ȣ������ ���ȸ��
var pwd_fail = 3;

//////////////////////////////////////////////////////////////////////////////////
// �α��� â�� ���� �̹����� �ٿ�ε� ���� URL
//var bannerUrl =  "http://" + window.location.host + "/XecureObject/xecure.bmp";
var bannerUrl =  "http://" + window.location.host + "/XecureObject/xecureweb_big_test.bmp.sig";

///////////////////////////////////////////////////////////////////////////////////
// ������� ������ �ٿ�ε�� ������� �������� ������ CN
//var pCaCertUrl= "http://" + window.location.host + "/XecureObject/signed_cacert.bin";
//var pCaCertName = "�ؼ��� CA";
var pCaCertUrl= "http://192.168.10.30:8188/XecureObject/signed_cacert.bin";
//var pCaCertName = "�׽�Ʈ �������";
//var pCaCertName = "RA143000001";
var pCaCertUrl= "http://192.168.10.30:8188/XecureObject/signed_cacert.bin";
var pCaCertName = "STX ���� CA";
//////////////////////////////////////////////////////////////////////////////////
// ���ڼ��� Ȯ��â�� ���� �޼����� ���ڼ��� Ȯ��â ���� �ɼ�
// 0 : ���� ���� ��� ����, 1: ���� ���� ��� 
var sign_desc = "";
var show_plain = 0; 


///////////////////////////////////////////////////////////////////////////////////
// xgate ���� ��:��Ʈ ���� , ��Ʈ ������ ����Ʈ�� 443 ��Ʈ ���
///////////////////////////////////////////////////////////////////////////////////
var xgate_addr    = window.location.hostname + ":50443:8989";

function GetXgateAddr()
{
	return xgate_addr;
}


//////////////////////////////////////////////////////////////////////////////////
//	Xecure Big �Լ���....
function SetConvertTable() {

	document.XecureWeb.SetPolicyConvertTableFirst(0, "1.2.410.200005.1.1.6.8", " ���ڼ��ݿ�", "����������");
	//document.XecureWeb.SetPolicyConvertTableNext("1.2.410.200005.1.1.4", "����/�����", "����������");
	document.XecureWeb.SetPolicyConvertTableNext("1.2.410.100001.2.2", "KCDSA(2048)", "����������");
	document.XecureWeb.SetPolicyConvertTableFinal(0x409);


	document.XecureWeb.SetIssuerConvertTableFirst("lotto test CA", "�ζ��������","");
	document.XecureWeb.SetIssuerConvertTableNext("yessignCA-Test Class 0", "1024RSA", "�׽�Ʈ");
	document.XecureWeb.SetIssuerConvertTableFinal();

}


/* Warmstar Add 		*/
/* XecureLiveUpdate */
var XWMSIEUpdateCtrl = {
	mName				: "XecureWebBaseCtrl",
	mCID				: "CLSID:0B13E3E0-8907-45C7-9C50-C700C68DFBA0",
	mCodeBase		: "http://192.168.70.198:8080/XecureObject/LiveUpdate/xwliveupdate_install.cab#Version=1,2,1,3"
}

// param ����( name : value )
//
// [��� ����]
//    lang : KOREAN / ENGLISH
//    ex) <param name="LANG" value="KOREAN">
//
// [���� �ɼ�] only over XecureWeb Client v5.3.0.1
//    "���� �ɼ�"�� ������ �ݵ�� �������� ���� �ڼ��� ������ Ȯ���� �� ����Ͻñ� �ٶ��ϴ�.
//    sec_option :
//	- xgate �ּҷ� ���� ����(����Ʈ�� host name���� ���� ����)		: 0x00000080 = 128
//	- ������ ��ȣ ����(ICī���� ��� �ɹ�ȣ�� ����)
//        USBTOKE_KB�� ���, SetPinNum���� �ɹ�ȣ�� preset�ؾ� ��	        : 0x00000040 =  64
//	- ����� ������ ����â���� ĳ�õ� ������ ���(only for IC card, USBTOKEN_KB)
//        USBTOKE_KB�� ���� ĳ������ �ʰ� �ڵ����� �ٽ� �о����              : 0x00000020 =  32
//	- �α��ν� ������ ����â���� ĳ�õ� ������ ���(only for IC card)	: 0x00000010 =  16
//	- IC ī�� Pin/Cert Pwd cache :  512+64+32 => 608 (0x260) 
// ���� Operation Option
//             _______________________________
// option bit : |_8_|_7_|_6_|_5_|_4_|_3_|_2_|_1_|
// 13th : flag for always same random value
// 12th : flag for (.sig)ext append (1:only one, 0:repeatly append - default)
// 11th : flag for CSM Tray hide/view (1:hide, 0:view-default)
// 10th : flag for signing with cached cert and pwd/pin(without established session)
// 9th : flag for MAC check in the SSL handshaking[0 : no check / 1 : check]
// 8th : method for the verification of signature [0 : host name / 1 : xgate address]
// 7th : certificate password reuse [0 : not use / 1 : use]
// 6th : certificate reuse for signing(no selection window) [0 : not use / 1 : reuse]
// 5th : certificate reuse for logging on(no selection window) [0 : not use / 1 : reuse]
//

//#define 	SECOPT_DEF_RANDOM			0x00001000	// 13th bit "ON" (4096)
//#define 	SECOPT_EXT_ONLY_ONE_EXIST		0x00000800	// 12th bit "ON" (2048)
//#define 	SECOPT_CSM_TRAY_HIDE		0x00000400	// 11th bit "ON" (1024)
//#define 	SECOPT_SIGN_CACHE_CERT		0x00000200	// 10th bit "ON" (512)
//#define		SECOPT_MAC_CHECK			0x00000100	// 9th bit "ON"  (256)
//#define		SECOPT_ADDR_VERIFICATION		0x00000080	// 8th bit "ON"  (128)
//#define		SECOPT_PASSWORD_REUSE		0x00000040	// 7th bit "ON"  (64)
//#define		SECOPT_CERT_SIGN_REUSE		0x00000020	// 6th bit "ON"  (32)
//#define		SECOPT_CERT_LOGIN_REUSE		0x00000010	// 5th bit "ON"  (16)

//    sec_context : ����
//    sec_desc : ������ ���ڿ�(storage�� iccard�� ������ ��� icī�� �ɹ�ȣ �Է�â�� ��Ÿ���� �ȳ�����. �������� ������ default ������ ��Ÿ��)
// 
// [������ �����ü ����] only over XecureWeb Client v5.3.0.1
//    storage : "HARD" / "REMOVABLE" / "ICCARD" / "CSP" / "VSC" / "USBTOKEN","USBTOKEN_KB","USBTOKEN_KIUP" "FP_NITGEN" "MPHONE"
//    ex1) <param name="STORAGE" value="HARD">
//    ex2) <param name="STORAGE" value="HARD,REMOVABLE,ICCARD"> ==> ���� ���� �����ü�� ������ ������ ù��° �����ü�� �켱 ���õǾ���
//    ��1) ICCARD�� ������ �����ϴ� SmartOn������ �� Ȱ��ȭ ��, ICCard�� ��Ȱ��ȭ ��Ű���� NO_SmartOn�� �߰��Ͽ�����.
//
// [Ű��Ʈ��ũ ��ŷ���� �ɼ�] only over XecureWeb Client v5.3.0.1
//    seckey : KeyStroke ��ŷ������ ���� ����, �ش��ϴ� vendor�� ���� string value �Է�
//             ����[2003/10/30] ������ string value
//             - "XW_SKS_SOFTCAMP_KEYPAD" : ����Ʈķ���� Ű�е� ����
//             - "XW_SKS_SOFTCAMP_DRIVER" : ����Ʈķ���� ����̹� ����
//             - "XW_SKS_KINGS_DRIVER"    : ŷ����������� ����̹� ����
//             - "_WITH_SKS_ENCRYPT"      : �� �������� �н����� Ÿ�Կ� ���ؼ� ��ȣȭ => BlockEnc ȣ��� ���ο��� �ٽ� ��ȣȭ��(xwcs_client.dll ���)
//    ex) <param name="SECKEY" value="XW_SKS_SOFTCAMP_KEYPAD"> ==> ����Ʈķ���� Ű�е� ���� ����
//    ex) <param name="SECKEY" value="XW_SKS_KINGS_DRIVER_WITH_SKS_ENCRYPT"> ==> ŷ����������� ����̹� ���� ���� + �н����� Ÿ�� ��ȣȭ
//    ex) <param name="SECKEY" value="_WITH_SKS_ENCRYPT"> ==> �н����� Ÿ�� ��ȣȭ�� ����
//		  <param name="SECKEY" value="XW_SKS_AHNLAB_DRIVER">  
//		   <param name="SECKEY" value="XW_SKS_JRSOFT_DRIVER">
//		   <param name="SECKEY" value="XW_SKS_SFVIRTUAL_DRIVER">
//
// [���̼���] only over XecureWeb Client v5.4.x
//    XecureWeb Client�� Ư�� ��ɿ� ���ؼ� ����Ʈ ���̼����� ������ ������ ��� ����
//    ���� ���̼����� ����� ���
//      - ���� ����(VerifySignedData)
//    ex) <param name="LICENSE" value="���������� �����ϴ� ����">
//					document.write('<param name="DEFINEDCANAME" value="CJ Systems">');
//	[����Ű���� �ɼ�] ���ڼ��� �� �α���, ��й�ȣ �Է�â���� ����Ű������ ��뿩�� �ɼ�.
//		mVirKey Option 			-	XW_VKEY_NO_USE (���� Ű���� ��� ����)
//												- XW_VKEY_TRANSKEY (TransCS.dll ��� ���)
//												- XW_VKEY_USAFEON (LaunchSafeOn.dll ��� ���)

var XWMSIECtrl = {
	mName				: "XecureWebClient",
	mCID				: "CLSID:7E9FDB80-5316-11D4-B02C-00C04F0CD404",
	mCodeBase			: "http://192.168.70.198:8080/XecureObject/xw_install.cab#Version=7,2,2,8",
	mStorage			: "hard,pkcs11,removable,csp,USBTOKEN_KIUP,iccard,NO_SMARTON,MPHONE,MOBISIGN",
	//mStorage			: "iccard", // ����� ICī�� ������ ���� �׽�Ʈȯ�� ����
	mSecOption			: "4096:hard:REMOVABLE:iccard:USBTOKEN_KIUP:pkcs11:MPHONE",
	//mSecOption			: "1248:iccard", // ����� ICī�� ������ ���� �׽�Ʈȯ�� ����
	//mSecKey			: "XW_SKS_JRSOFT_DRIVER",		//XW_SKS_JRSOFT_DRIVER , XW_SKS_SFVIRTUAL_DRIVER
	//mLicense			: "30820721020101310b300906052b0e03021a05003081fe06092a864886f70d010701a081f00481ed313a3139322e3136382e37302e3139383a5665726966795369676e6564446174612c46696c655369676e2c46696c655665726966792c4d756c746946696c655369676e2c46696c655369676e416e645665726966792c46696c65456e76656c6f702c46696c654465456e76656c6f702c46696c65436c6561722c46696c655a69702c46696c65556e5a69702c46696c655369676e344f454d2c4d756c746946696c655369676e344f454d2c5369676e44617461434d535769746848544d4c2c5369676e44617461434d535769746848544d4c45782c56657269667944657461636865645369676e656444617461a0820467308204633082034ba003020102020107300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3034303431393030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920524e44204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010043340b4e1f2f30d6634c818e9fa4b35c199e0628503dbe0d1f5ad2c05890a918408dc330c991083bc7cdfc50021303c04afab4cb522d22fced11d1be6559835f1f000d466120cff97a2a80e4fdf972ac127f9bb8e8ddb84974323e4cb822c5f15b22f82da3de6ef61a0b6798ca49a85af3d8f8298912b4d26411e2e1635c081a3306931716c5e56b279c4d36068a4b645c10aa582693086e14132ba67fb03526312790261f9c641993e2ffc3fd9e8df3efebfddecd722e874d6366ad1252ac0d8bddb5674533cc2717a7342e5cfb18f8a301e7196ca33d6c3bb7e1f1e4bee34f5358af6ae0fd52a9fc3bdd4925f5eab7db6628e24738f6c882bb0aaa0e10afbf0203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e041604142e49ab278ae8c8af977537de8b74bb240e0d275f300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c505542432c4f553d536563757269747920524e44204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d010105050003820101003ce700a0492b225b1665d9c73d84c34f7a5faad7b397ed49231f030e4e0e91953a607bd9006425373d490ef3ba1cf47810ca8c22fabe0c609f93823efdede64744458e910267f9f857c907318e286da6c131c9dd5fada43fd8cfdf6bd1b1b239338cea83eb6b6893b88fbcfd8e86a677b7270ad96be5a82b40569efc2dda6df4bcd642d067183186d6cace6c8f73b80f30b57acb3bcd5cbbc51307922d5edb38cb0d90c3917a8e37534183ba10f403c1c034287f39442df795050f39d78ddad97da8a43f02d7641549af9b5d68908e49faa8a1597cfed4a43baadd42c8fe4fd44c96d314df56147b8a7fa6ba65ffdee9ed3a5da52ef9ac7f9ca5afb633e1ccdf318201a13082019d020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020107300706052b0e03021a300d06092a864886f70d010105050004820100387e90aed953f727bbcd66bcd13116bcd9a1dd8ba0c4d5a79e8d887e0741463dfae297766c8b96c8d400d00267e42d4f8a2fe20e4057f062f0a90f229c8905d243aea7611f17d24a8d919003661f91fe0eadd72bc0f8d62d9001b449d997a091a10cd942f82c47cee1cf8328f395a5a671a534cc3ef12968d90c9c79941c912d3d4140c61b0a2ca6c57a79e6ef91d0212f6d4cdd1752d0c44e44445519d1035158adaec5c3a3aba26813c7ad3b8c431f811d146b22894be10a6bdd52ca28c68a2fff46699552662fae170bd35ad72daf349ad0e2dd680aa9e8976973e790302b3cc1554d74055fd5b6c233f1c631a337e0ff46bd23ec19c2c402d4c7873fbfdd",
	//mSecContext		: "30820641020101310b300906052b0e03021a0500301d06092a864886f70d010701a010040e3139322e3136382e37302e313938a0820467308204633082034ba003020102020107300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3034303431393030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920524e44204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010043340b4e1f2f30d6634c818e9fa4b35c199e0628503dbe0d1f5ad2c05890a918408dc330c991083bc7cdfc50021303c04afab4cb522d22fced11d1be6559835f1f000d466120cff97a2a80e4fdf972ac127f9bb8e8ddb84974323e4cb822c5f15b22f82da3de6ef61a0b6798ca49a85af3d8f8298912b4d26411e2e1635c081a3306931716c5e56b279c4d36068a4b645c10aa582693086e14132ba67fb03526312790261f9c641993e2ffc3fd9e8df3efebfddecd722e874d6366ad1252ac0d8bddb5674533cc2717a7342e5cfb18f8a301e7196ca33d6c3bb7e1f1e4bee34f5358af6ae0fd52a9fc3bdd4925f5eab7db6628e24738f6c882bb0aaa0e10afbf0203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e041604142e49ab278ae8c8af977537de8b74bb240e0d275f300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c505542432c4f553d536563757269747920524e44204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d010105050003820101003ce700a0492b225b1665d9c73d84c34f7a5faad7b397ed49231f030e4e0e91953a607bd9006425373d490ef3ba1cf47810ca8c22fabe0c609f93823efdede64744458e910267f9f857c907318e286da6c131c9dd5fada43fd8cfdf6bd1b1b239338cea83eb6b6893b88fbcfd8e86a677b7270ad96be5a82b40569efc2dda6df4bcd642d067183186d6cace6c8f73b80f30b57acb3bcd5cbbc51307922d5edb38cb0d90c3917a8e37534183ba10f403c1c034287f39442df795050f39d78ddad97da8a43f02d7641549af9b5d68908e49faa8a1597cfed4a43baadd42c8fe4fd44c96d314df56147b8a7fa6ba65ffdee9ed3a5da52ef9ac7f9ca5afb633e1ccdf318201a33082019f020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020107300906052b0e03021a0500300d06092a864886f70d0101010500048201001934efd25401af22a01b7f95eee66a2ad99bdd6fd1ef32f319e3359f4c371afaf1cfa02db6d8a0e980d43c8a26ac0241aab5e24f100a1f05c7f80d9824c36adea417f78e25664a3540194accc19a791c79a606ec341f1d33038e1425fc401d313dad68cf88192aff660a4d59b89d0542df0e8076e7e95c178ee4fb0aea1e13842b378bc9a2865299c1c6706819c1d8288e5e3522a8f1ecba5e39dc38160bc28e590b55133f097b292f42d09ea30a91cdea21bbc8e089b9364b198a4333338f58abb7901a101c7b6be30c85892ee7db63cf230fcf22c8db7df082015bf7aeaea8da42d8ec9d979bd193261968f64c884468715213313c567d6e41230b22b0fdf2",
	mLicense			: "30820726020101310b300906052b0e03021a05003082010206092a864886f70d010701a081f40481f1313a736f6e612e736f6674666f72756d2e636f6d3a5665726966795369676e6564446174612c46696c655369676e2c46696c655665726966792c4d756c746946696c655369676e2c46696c655369676e416e645665726966792c46696c65456e76656c6f702c46696c654465456e76656c6f702c46696c65436c6561722c46696c655a69702c46696c65556e5a69702c46696c655369676e344f454d2c4d756c746946696c655369676e344f454d2c5369676e44617461434d535769746848544d4c2c5369676e44617461434d535769746848544d4c45782c56657269667944657461636865645369676e656444617461a0820467308204633082034ba003020102020107300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3034303431393030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920524e44204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010043340b4e1f2f30d6634c818e9fa4b35c199e0628503dbe0d1f5ad2c05890a918408dc330c991083bc7cdfc50021303c04afab4cb522d22fced11d1be6559835f1f000d466120cff97a2a80e4fdf972ac127f9bb8e8ddb84974323e4cb822c5f15b22f82da3de6ef61a0b6798ca49a85af3d8f8298912b4d26411e2e1635c081a3306931716c5e56b279c4d36068a4b645c10aa582693086e14132ba67fb03526312790261f9c641993e2ffc3fd9e8df3efebfddecd722e874d6366ad1252ac0d8bddb5674533cc2717a7342e5cfb18f8a301e7196ca33d6c3bb7e1f1e4bee34f5358af6ae0fd52a9fc3bdd4925f5eab7db6628e24738f6c882bb0aaa0e10afbf0203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e041604142e49ab278ae8c8af977537de8b74bb240e0d275f300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c505542432c4f553d536563757269747920524e44204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d010105050003820101003ce700a0492b225b1665d9c73d84c34f7a5faad7b397ed49231f030e4e0e91953a607bd9006425373d490ef3ba1cf47810ca8c22fabe0c609f93823efdede64744458e910267f9f857c907318e286da6c131c9dd5fada43fd8cfdf6bd1b1b239338cea83eb6b6893b88fbcfd8e86a677b7270ad96be5a82b40569efc2dda6df4bcd642d067183186d6cace6c8f73b80f30b57acb3bcd5cbbc51307922d5edb38cb0d90c3917a8e37534183ba10f403c1c034287f39442df795050f39d78ddad97da8a43f02d7641549af9b5d68908e49faa8a1597cfed4a43baadd42c8fe4fd44c96d314df56147b8a7fa6ba65ffdee9ed3a5da52ef9ac7f9ca5afb633e1ccdf318201a13082019d020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020107300706052b0e03021a300d06092a864886f70d010105050004820100247b19249e2c322f2db24ca2403cb48f9455e6854c6c52eb4bc398eb2c4a3674418566b85f7f97c2acbc30171770ebc3f3ad46519fd390b9b674f1fae1dd891955febc28975665f735f4b17f49ca1e26445159a6bc52501b02f31b1414c9182c220f0cebdda30b0c02e5b71a924ccd96b1e579a99aa6d1f130b945e7a42a713f1cc9a1e7a5a7a901943ac88e13e4b7f6dd0c2ef5aa50af058fa56ec2dc16222a9d4bf72f2a7689307d565be5fc597f84bff2bfec3cc6a587ba096ce7e6b3823e2576e881515e98621e587437fd2989035b3b84dcf43a01b31b02f65b35df6feea70a6557ef3e92c40bb85bd0d5fdac943f29e3b180372c13465b8f100729d3d6",
	mSecContext			: "30820645020101310b300906052b0e03021a0500302106092a864886f70d010701a0140412736f6e612e736f6674666f72756d2e636f6da0820467308204633082034ba003020102020107300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3034303431393030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920524e44204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010043340b4e1f2f30d6634c818e9fa4b35c199e0628503dbe0d1f5ad2c05890a918408dc330c991083bc7cdfc50021303c04afab4cb522d22fced11d1be6559835f1f000d466120cff97a2a80e4fdf972ac127f9bb8e8ddb84974323e4cb822c5f15b22f82da3de6ef61a0b6798ca49a85af3d8f8298912b4d26411e2e1635c081a3306931716c5e56b279c4d36068a4b645c10aa582693086e14132ba67fb03526312790261f9c641993e2ffc3fd9e8df3efebfddecd722e874d6366ad1252ac0d8bddb5674533cc2717a7342e5cfb18f8a301e7196ca33d6c3bb7e1f1e4bee34f5358af6ae0fd52a9fc3bdd4925f5eab7db6628e24738f6c882bb0aaa0e10afbf0203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e041604142e49ab278ae8c8af977537de8b74bb240e0d275f300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c505542432c4f553d536563757269747920524e44204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d010105050003820101003ce700a0492b225b1665d9c73d84c34f7a5faad7b397ed49231f030e4e0e91953a607bd9006425373d490ef3ba1cf47810ca8c22fabe0c609f93823efdede64744458e910267f9f857c907318e286da6c131c9dd5fada43fd8cfdf6bd1b1b239338cea83eb6b6893b88fbcfd8e86a677b7270ad96be5a82b40569efc2dda6df4bcd642d067183186d6cace6c8f73b80f30b57acb3bcd5cbbc51307922d5edb38cb0d90c3917a8e37534183ba10f403c1c034287f39442df795050f39d78ddad97da8a43f02d7641549af9b5d68908e49faa8a1597cfed4a43baadd42c8fe4fd44c96d314df56147b8a7fa6ba65ffdee9ed3a5da52ef9ac7f9ca5afb633e1ccdf318201a33082019f020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020107300906052b0e03021a0500300d06092a864886f70d0101010500048201004250cd3ce762dfb04930cb011f23423853cb2527b9658f4ba6e757b7aebf34d45f709096435423402a16afb9fa30ecf1558c44e381c9ac70e9bbabced1de45feda62b99c450de0d4e73155beab18ce858df4214f8b822848dee99dec486490172dbe57df9c42e332270e8b5f4f523fc1f1de6c5bd81d07a2eeca6199c318306124397648de47b7500f464be31fc56297bfce43e3427826aabf4861b648afcc6cb376806e2bdd8821bc8f1f13e1b4572de2ad48d027776067d623e6fb827295289076e9d5d9dcdceceb8b416140fd6c4d6e52a109caf33a3a3d119d1cbf46cb782b9a441486bd57fbafafd1e160dfa6498d339a6a6f07923fd9cbd917a4a5127a",
	mLIMITPIN			: "2",
	mLIMITCERTPWD		: "3",
	mLang				: "KOREAN",
	mCaName				: "�츮��",
	//mVirKey			: "XW_VKEY_USAFEON&http://scard.besoft.co.kr/besoft/safeon/download.html|450,450&1.2.0.8",
	mVirKey				: "XW_VKEY_TRANSKEY&MULTI&" + xgate_addr,
	mCloudSignConf		: window.location.host + "|http://211.175.81.101:8701/rss/rssreceiver,http://211.175.81.101:8702/rss/rssreceiver|http://211.175.81.101:8002/cloudSign/_gbs/controller/uplogin.do,http://211.175.81.101:8002/cloudSign/_gbs/controller/upservice.do|http://211.175.81.101:8701/rcs/rcsreceiver|2&http://download.softforum.co.kr/CloudSign/install.html|width=507,height=502,left=10,top=10|1.0.0.1"
	
	
}

// XecureWeb Client 64bit
var XWMSIECtrlx64 = {
	mName				: "XecureWebClient",
	mCID				: "CLSID:7E9FDB80-5316-11D4-B02C-00C04F0CD404",
	mCodeBase			: "http://192.168.70.198:8080/XecureObject/x64/xw_install.cab#Version=7,2,4,0",
	mLicense			: "30820721020101310b300906052b0e03021a05003081fe06092a864886f70d010701a081f00481ed313a3139322e3136382e37302e3139383a5665726966795369676e6564446174612c46696c655369676e2c46696c655665726966792c4d756c746946696c655369676e2c46696c655369676e416e645665726966792c46696c65456e76656c6f702c46696c654465456e76656c6f702c46696c65436c6561722c46696c655a69702c46696c65556e5a69702c46696c655369676e344f454d2c4d756c746946696c655369676e344f454d2c5369676e44617461434d535769746848544d4c2c5369676e44617461434d535769746848544d4c45782c56657269667944657461636865645369676e656444617461a0820467308204633082034ba003020102020107300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3034303431393030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920524e44204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010043340b4e1f2f30d6634c818e9fa4b35c199e0628503dbe0d1f5ad2c05890a918408dc330c991083bc7cdfc50021303c04afab4cb522d22fced11d1be6559835f1f000d466120cff97a2a80e4fdf972ac127f9bb8e8ddb84974323e4cb822c5f15b22f82da3de6ef61a0b6798ca49a85af3d8f8298912b4d26411e2e1635c081a3306931716c5e56b279c4d36068a4b645c10aa582693086e14132ba67fb03526312790261f9c641993e2ffc3fd9e8df3efebfddecd722e874d6366ad1252ac0d8bddb5674533cc2717a7342e5cfb18f8a301e7196ca33d6c3bb7e1f1e4bee34f5358af6ae0fd52a9fc3bdd4925f5eab7db6628e24738f6c882bb0aaa0e10afbf0203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e041604142e49ab278ae8c8af977537de8b74bb240e0d275f300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c505542432c4f553d536563757269747920524e44204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d010105050003820101003ce700a0492b225b1665d9c73d84c34f7a5faad7b397ed49231f030e4e0e91953a607bd9006425373d490ef3ba1cf47810ca8c22fabe0c609f93823efdede64744458e910267f9f857c907318e286da6c131c9dd5fada43fd8cfdf6bd1b1b239338cea83eb6b6893b88fbcfd8e86a677b7270ad96be5a82b40569efc2dda6df4bcd642d067183186d6cace6c8f73b80f30b57acb3bcd5cbbc51307922d5edb38cb0d90c3917a8e37534183ba10f403c1c034287f39442df795050f39d78ddad97da8a43f02d7641549af9b5d68908e49faa8a1597cfed4a43baadd42c8fe4fd44c96d314df56147b8a7fa6ba65ffdee9ed3a5da52ef9ac7f9ca5afb633e1ccdf318201a13082019d020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020107300706052b0e03021a300d06092a864886f70d010105050004820100387e90aed953f727bbcd66bcd13116bcd9a1dd8ba0c4d5a79e8d887e0741463dfae297766c8b96c8d400d00267e42d4f8a2fe20e4057f062f0a90f229c8905d243aea7611f17d24a8d919003661f91fe0eadd72bc0f8d62d9001b449d997a091a10cd942f82c47cee1cf8328f395a5a671a534cc3ef12968d90c9c79941c912d3d4140c61b0a2ca6c57a79e6ef91d0212f6d4cdd1752d0c44e44445519d1035158adaec5c3a3aba26813c7ad3b8c431f811d146b22894be10a6bdd52ca28c68a2fff46699552662fae170bd35ad72daf349ad0e2dd680aa9e8976973e790302b3cc1554d74055fd5b6c233f1c631a337e0ff46bd23ec19c2c402d4c7873fbfdd",
	mStorage			: "hard,removable,csp,pkcs11,USBTOKEN_KIUP,iccard,NO_SMARTON,USBTOKEN_KIUP",
	mSecOption			: "4096:hard:iccard:USBTOKEN_KIUP",
	mSecKey				: "XW_SKS_SFVIRTUAL_DRIVER",
	mSecContext			: "30820641020101310b300906052b0e03021a0500301d06092a864886f70d010701a010040e3139322e3136382e37302e313938a0820467308204633082034ba003020102020107300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3034303431393030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920524e44204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010043340b4e1f2f30d6634c818e9fa4b35c199e0628503dbe0d1f5ad2c05890a918408dc330c991083bc7cdfc50021303c04afab4cb522d22fced11d1be6559835f1f000d466120cff97a2a80e4fdf972ac127f9bb8e8ddb84974323e4cb822c5f15b22f82da3de6ef61a0b6798ca49a85af3d8f8298912b4d26411e2e1635c081a3306931716c5e56b279c4d36068a4b645c10aa582693086e14132ba67fb03526312790261f9c641993e2ffc3fd9e8df3efebfddecd722e874d6366ad1252ac0d8bddb5674533cc2717a7342e5cfb18f8a301e7196ca33d6c3bb7e1f1e4bee34f5358af6ae0fd52a9fc3bdd4925f5eab7db6628e24738f6c882bb0aaa0e10afbf0203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e041604142e49ab278ae8c8af977537de8b74bb240e0d275f300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c505542432c4f553d536563757269747920524e44204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d010105050003820101003ce700a0492b225b1665d9c73d84c34f7a5faad7b397ed49231f030e4e0e91953a607bd9006425373d490ef3ba1cf47810ca8c22fabe0c609f93823efdede64744458e910267f9f857c907318e286da6c131c9dd5fada43fd8cfdf6bd1b1b239338cea83eb6b6893b88fbcfd8e86a677b7270ad96be5a82b40569efc2dda6df4bcd642d067183186d6cace6c8f73b80f30b57acb3bcd5cbbc51307922d5edb38cb0d90c3917a8e37534183ba10f403c1c034287f39442df795050f39d78ddad97da8a43f02d7641549af9b5d68908e49faa8a1597cfed4a43baadd42c8fe4fd44c96d314df56147b8a7fa6ba65ffdee9ed3a5da52ef9ac7f9ca5afb633e1ccdf318201a33082019f020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020107300906052b0e03021a0500300d06092a864886f70d0101010500048201001934efd25401af22a01b7f95eee66a2ad99bdd6fd1ef32f319e3359f4c371afaf1cfa02db6d8a0e980d43c8a26ac0241aab5e24f100a1f05c7f80d9824c36adea417f78e25664a3540194accc19a791c79a606ec341f1d33038e1425fc401d313dad68cf88192aff660a4d59b89d0542df0e8076e7e95c178ee4fb0aea1e13842b378bc9a2865299c1c6706819c1d8288e5e3522a8f1ecba5e39dc38160bc28e590b55133f097b292f42d09ea30a91cdea21bbc8e089b9364b198a4333338f58abb7901a101c7b6be30c85892ee7db63cf230fcf22c8db7df082015bf7aeaea8da42d8ec9d979bd193261968f64c884468715213313c567d6e41230b22b0fdf2",
	mLang				: "KOREAN",
	mCaName				: "XWC Test",
	mVirKey				: "XW_VKEY_TRANSKEY"		// XW_VKEY_NO_USE or XW_VKEY_TRANSKEY	
	//mVirKey			: "XW_VKEY_USAFEON&http://scard.besoft.co.kr/besoft/safeon/download.html|450,450&1.2.0.8"
}
//

var XWFirefoxCtrl = {
	mName				: "XecureWebClient",
	mType				: null,
	mTypeWin32			: "application/xecureweb-plugin",
	mTypeLinux			: "application/xecure-plugin",
	//mSecOption		: "12288:hard:iccard:USBTOKEN_KIUP", // 4608 + 8192
	mSecOption			: "512:hard:iccard:USBTOKEN_KIUP",
	//mPluginLicense	: "30820679020101310b300906052b0e03021a0500305706092a864886f70d010701a04a0448313a3139322e3136382e37302e3139383a46697265666f785f456e61626c652c4368726f6d655f456e61626c652c4f706572615f456e61626c652c5361666172695f456e61626c65a0820467308204633082034ba003020102020107300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3034303431393030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920524e44204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010043340b4e1f2f30d6634c818e9fa4b35c199e0628503dbe0d1f5ad2c05890a918408dc330c991083bc7cdfc50021303c04afab4cb522d22fced11d1be6559835f1f000d466120cff97a2a80e4fdf972ac127f9bb8e8ddb84974323e4cb822c5f15b22f82da3de6ef61a0b6798ca49a85af3d8f8298912b4d26411e2e1635c081a3306931716c5e56b279c4d36068a4b645c10aa582693086e14132ba67fb03526312790261f9c641993e2ffc3fd9e8df3efebfddecd722e874d6366ad1252ac0d8bddb5674533cc2717a7342e5cfb18f8a301e7196ca33d6c3bb7e1f1e4bee34f5358af6ae0fd52a9fc3bdd4925f5eab7db6628e24738f6c882bb0aaa0e10afbf0203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e041604142e49ab278ae8c8af977537de8b74bb240e0d275f300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c505542432c4f553d536563757269747920524e44204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d010105050003820101003ce700a0492b225b1665d9c73d84c34f7a5faad7b397ed49231f030e4e0e91953a607bd9006425373d490ef3ba1cf47810ca8c22fabe0c609f93823efdede64744458e910267f9f857c907318e286da6c131c9dd5fada43fd8cfdf6bd1b1b239338cea83eb6b6893b88fbcfd8e86a677b7270ad96be5a82b40569efc2dda6df4bcd642d067183186d6cace6c8f73b80f30b57acb3bcd5cbbc51307922d5edb38cb0d90c3917a8e37534183ba10f403c1c034287f39442df795050f39d78ddad97da8a43f02d7641549af9b5d68908e49faa8a1597cfed4a43baadd42c8fe4fd44c96d314df56147b8a7fa6ba65ffdee9ed3a5da52ef9ac7f9ca5afb633e1ccdf318201a13082019d020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020107300706052b0e03021a300d06092a864886f70d0101050500048201002e087d3fe6b1024846dcb4517079b8ed85f9d007ea5cdb0ea1cfec4287c84da9a125fbafd3a3ba988cd09f1d38dce553168c7660912fb4bf46a6c21340443b8cc17a1a95b0149af89efe85f47b76b3a23bd058efdc809edfb7b35fd1bdb244ba1e628098d732d29b936646a0e9c2b9f1848bd02521786aba8d4b7e9d242ad35b9b3f6ba72586d94252f4b52534f6d2153795ba5032d975b158d7b782bade45350819c4f9fef100dbab7b1545a0eb39e6cd8d6229c7cc16bc038c50dbad4e74ce1a417a356b78652429189cab674a938655853295e68ffc4e790e17db06ed932bdf043c7e0ea4422d9c64af3674b91422c0d5774b63089da64be81305642d7dbd",
	mPluginLicense		: "3082067d020101310b300906052b0e03021a0500305b06092a864886f70d010701a04e044c313a736f6e612e736f6674666f72756d2e636f6d3a46697265666f785f456e61626c652c4368726f6d655f456e61626c652c4f706572615f456e61626c652c5361666172695f456e61626c65a0820467308204633082034ba003020102020107300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3034303431393030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920524e44204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010043340b4e1f2f30d6634c818e9fa4b35c199e0628503dbe0d1f5ad2c05890a918408dc330c991083bc7cdfc50021303c04afab4cb522d22fced11d1be6559835f1f000d466120cff97a2a80e4fdf972ac127f9bb8e8ddb84974323e4cb822c5f15b22f82da3de6ef61a0b6798ca49a85af3d8f8298912b4d26411e2e1635c081a3306931716c5e56b279c4d36068a4b645c10aa582693086e14132ba67fb03526312790261f9c641993e2ffc3fd9e8df3efebfddecd722e874d6366ad1252ac0d8bddb5674533cc2717a7342e5cfb18f8a301e7196ca33d6c3bb7e1f1e4bee34f5358af6ae0fd52a9fc3bdd4925f5eab7db6628e24738f6c882bb0aaa0e10afbf0203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e041604142e49ab278ae8c8af977537de8b74bb240e0d275f300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c505542432c4f553d536563757269747920524e44204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d010105050003820101003ce700a0492b225b1665d9c73d84c34f7a5faad7b397ed49231f030e4e0e91953a607bd9006425373d490ef3ba1cf47810ca8c22fabe0c609f93823efdede64744458e910267f9f857c907318e286da6c131c9dd5fada43fd8cfdf6bd1b1b239338cea83eb6b6893b88fbcfd8e86a677b7270ad96be5a82b40569efc2dda6df4bcd642d067183186d6cace6c8f73b80f30b57acb3bcd5cbbc51307922d5edb38cb0d90c3917a8e37534183ba10f403c1c034287f39442df795050f39d78ddad97da8a43f02d7641549af9b5d68908e49faa8a1597cfed4a43baadd42c8fe4fd44c96d314df56147b8a7fa6ba65ffdee9ed3a5da52ef9ac7f9ca5afb633e1ccdf318201a13082019d020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020107300706052b0e03021a300d06092a864886f70d010105050004820100038acb976abbc005bf0a8d0d26c0d6d2ce1b1c96bc76f3f5cfeae2528b9b30aa2c8813e069a7d0c488fd336eb2a9d0e720b255df248eba2fcf417dc9beb18a7f68c6361ca5267db49a321668fa6ff91111923508212d5b4d3ca8fce88b6d41d95038c9024fed1580a221210e68d2b3d5e48f23d364881a5a5c94c91215de2e4b777c6544b67c16751b98f00baf1b495ffd0c1b2bdd1670f65928ee76c8b265fdb3ca42b3fee98b19e4717cc703afc802503498bf39593d727be91fd0c93700bf8877fa8af0f486933acce2e74612c9f8952eedad18410da5763a6e7d06473e798d62baf5e29cc136dedd07fd375ee2ddb3482b736fe4e83bc06cc97dc69ede77",
	mStorage			: "hard,removable,csp,pkcs11,USBTOKEN_KIUP,iccard,NO_SMARTON,USBTOKEN_KIUP,MPHONE",
	mSecKey				: "XW_SKS_SFVIRTUAL_DRIVER",	//XW_SKS_SFVIRTUAL_DRIVER
	//mSecContext		: "30820641020101310b300906052b0e03021a0500301d06092a864886f70d010701a010040e3139322e3136382e37302e313938a0820467308204633082034ba003020102020107300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3034303431393030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920524e44204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010043340b4e1f2f30d6634c818e9fa4b35c199e0628503dbe0d1f5ad2c05890a918408dc330c991083bc7cdfc50021303c04afab4cb522d22fced11d1be6559835f1f000d466120cff97a2a80e4fdf972ac127f9bb8e8ddb84974323e4cb822c5f15b22f82da3de6ef61a0b6798ca49a85af3d8f8298912b4d26411e2e1635c081a3306931716c5e56b279c4d36068a4b645c10aa582693086e14132ba67fb03526312790261f9c641993e2ffc3fd9e8df3efebfddecd722e874d6366ad1252ac0d8bddb5674533cc2717a7342e5cfb18f8a301e7196ca33d6c3bb7e1f1e4bee34f5358af6ae0fd52a9fc3bdd4925f5eab7db6628e24738f6c882bb0aaa0e10afbf0203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e041604142e49ab278ae8c8af977537de8b74bb240e0d275f300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c505542432c4f553d536563757269747920524e44204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d010105050003820101003ce700a0492b225b1665d9c73d84c34f7a5faad7b397ed49231f030e4e0e91953a607bd9006425373d490ef3ba1cf47810ca8c22fabe0c609f93823efdede64744458e910267f9f857c907318e286da6c131c9dd5fada43fd8cfdf6bd1b1b239338cea83eb6b6893b88fbcfd8e86a677b7270ad96be5a82b40569efc2dda6df4bcd642d067183186d6cace6c8f73b80f30b57acb3bcd5cbbc51307922d5edb38cb0d90c3917a8e37534183ba10f403c1c034287f39442df795050f39d78ddad97da8a43f02d7641549af9b5d68908e49faa8a1597cfed4a43baadd42c8fe4fd44c96d314df56147b8a7fa6ba65ffdee9ed3a5da52ef9ac7f9ca5afb633e1ccdf318201a33082019f020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020107300906052b0e03021a0500300d06092a864886f70d0101010500048201001934efd25401af22a01b7f95eee66a2ad99bdd6fd1ef32f319e3359f4c371afaf1cfa02db6d8a0e980d43c8a26ac0241aab5e24f100a1f05c7f80d9824c36adea417f78e25664a3540194accc19a791c79a606ec341f1d33038e1425fc401d313dad68cf88192aff660a4d59b89d0542df0e8076e7e95c178ee4fb0aea1e13842b378bc9a2865299c1c6706819c1d8288e5e3522a8f1ecba5e39dc38160bc28e590b55133f097b292f42d09ea30a91cdea21bbc8e089b9364b198a4333338f58abb7901a101c7b6be30c85892ee7db63cf230fcf22c8db7df082015bf7aeaea8da42d8ec9d979bd193261968f64c884468715213313c567d6e41230b22b0fdf2",
	mSecContext			: XWMSIECtrl.mSecContext,
	mVirKey				: "XW_VKEY_TRANSKEY&MULTI&" + xgate_addr,
	mCloudSignConf		: window.location.host + "|http://211.175.81.101:8701/rss/rssreceiver,http://211.175.81.101:8702/rss/rssreceiver|http://211.175.81.101:8002/cloudSign/_gbs/controller/uplogin.do,http://211.175.81.101:8002/cloudSign/_gbs/controller/upservice.do|http://211.175.81.101:8701/rcs/rcsreceiver|2&http://download.softforum.co.kr/CloudSign/install.html|width=507,height=502,left=10,top=10|1.0.0.1",

	// windows
	mWinVersion			: "7.2.2.8",
	mWin32Src			: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/xw_install.xpi"},
	mWin32SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win32.html"},
	mWin64Src			: null,
	mWin64SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win64.html"},

	// linux 32
	mVer_linux_32_30	: "7.2.1.4",
	mSrc_linux_32_30	: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_linux_32_firefox_30.xpi"},
	mVer_linux_32_50	: "7.2.1.4",
	mSrc_linux_32_50	: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_linux_32_firefox_50.xpi"},
	mVer_linux_32_60	: "7.2.1.4",
	mSrc_linux_32_60	: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_linux_32_firefox_60.xpi"},
	mVer_linux_32_70	: "7.2.1.5",
	mSrc_linux_32_70	: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_linux_32_firefox_70.xpi"},
	mVer_linux_32_80	: "7.2.1.6",
	mSrc_linux_32_80	: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_linux_32_firefox_80.xpi"},
	
	// linux 64
	mVer_linux_64_30	: "7.2.1.4",
	mSrc_linux_64_30	: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_linux_64_firefox_30.xpi"},
	mVer_linux_64_50	: "7.2.1.4",
	mSrc_linux_64_50	: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_linux_64_firefox_50.xpi"},
	mVer_linux_64_60	: "7.2.1.4",
	mSrc_linux_64_60	: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_linux_64_firefox_60.xpi"},
	mVer_linux_64_70	: "7.2.1.5",
	mSrc_linux_64_70	: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_linux_64_firefox_70.xpi"},
	mVer_linux_64_80	: "7.2.1.6",
	mSrc_linux_64_80	: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_linux_64_firefox_80.xpi"},

	// mac ppc
	mVer_mac_ppc_30		: "7.2.1.4",
	mSrc_mac_ppc_30		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_mac_ppc_firefox_30.xpi"},

	// mac 32
	mVer_mac_32_30		: "7.2.1.4",
	mSrc_mac_32_30		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_mac_32_firefox_30.xpi"},

	// mac intel
	mVer_mac_intel_50	: "7.2.1.4",
	mSrc_mac_intel_50	: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_mac_intel_firefox_50.xpi"},
	mVer_mac_intel_60	: "7.2.1.4",
	mSrc_mac_intel_60	: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_mac_intel_firefox_60.xpi"},
	mVer_mac_intel_70	: "7.2.1.5",
	mSrc_mac_intel_70	: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_mac_intel_firefox_70.xpi"},
	mVer_mac_intel_80	: "7.2.1.6",
	mSrc_mac_intel_80	: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/inst/xwc_install_mac_intel_firefox_80.xpi"}



	//mLinuxVersion		: "7.1.0.0",
	//mLinux32Src		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/xw_install_linux.xpi"},
	//mLinux64Src		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/xw_install_linux-x86_64.xpi"},

	//mMacVersion		: "7.1.0.0",
	//mMacPPCSrc		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/xw_install_mac_ppc.xpi"},
	//mMacIntelSrc		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/xw_install_mac_intel.xpi"}

}

var XWSafariCtrl = {
	mName				: "XecureWebClient",
	mType				: null,
	mTypeWin32			: "application/xecureweb-plugin",
	mTypeLinux			: "application/xecure-plugin",
	mPluginLicense		: XWFirefoxCtrl.mPluginLicense,
	mStorage			: "hard,removable,csp,pkcs11,USBTOKEN_KIUP,iccard,NO_SMARTON,USBTOKEN_KIUP,MPHONE",
	//mSecOption		: "4096:hard:iccard:USBTOKEN_KIUP",		// 4608 + 8192
	mSecOption			: "0:hard:iccard:USBTOKEN_KIUP",
	mSecKey				: "XW_SKS_JRSOFT_DRIVER",	//XW_SKS_SFVIRTUAL_DRIVER
	mSecContext			: XWMSIECtrl.mSecContext,
	//mVirKey			: "XW_VKEY_USAFEON&http://scard.besoft.co.kr/besoft/safeon/download.html|350,350&1.2.0.7",
	mVirKey				: "XW_VKEY_TRANSKEY&SINGLE&" + xgate_addr,
	mCloudSignConf		: window.location.host + "|http://211.175.81.101:8701/rss/rssreceiver,http://211.175.81.101:8702/rss/rssreceiver|http://211.175.81.101:8002/cloudSign/_gbs/controller/uplogin.do,http://211.175.81.101:8002/cloudSign/_gbs/controller/upservice.do|http://211.175.81.101:8701/rcs/rcsreceiver|2&http://download.softforum.co.kr/CloudSign/install.html|width=507,height=502,left=10,top=10|1.0.0.1",
	
	mWinVersion			: XWFirefoxCtrl.mWinVersion,
	mWin32Src			: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/xw_install.xpi"},
	mWin32SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win32.html"},
	mWin64Src			: null,
	mWin64SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win64.html"},

	mLinuxVersion		: null,
	mLinux32Src			: null,
	mLinux64Src			: null,

	mMacVersion			: "7.1.0.0",
	mMacPPCSrc			: "http://" + window.location.host + "/XecureObject/inst/xwc_install_mac_ppc_safari.dmg",
	mMacIntelSrc		: "http://" + window.location.host + "/XecureObject/inst/xwc_install_mac_intel_safari.dmg"
}

var XWChromeCtrl = {
	mName				: "XecureWebClient",
	mType				: null,
	mTypeWin32			: "application/xecureweb-plugin",
	mTypeLinux			: "application/xecure-plugin",
	mSecOption			: "8192:hard:iccard:USBTOKEN_KIUP",
	//mSecOption		: "512:hard:iccard:USBTOKEN_KIUP",
	mPluginLicense		: XWFirefoxCtrl.mPluginLicense,
	mStorage			: "hard,removable,csp,pkcs11,USBTOKEN_KIUP,iccard,NO_SMARTON,USBTOKEN_KIUP,MPHONE",
	mSecKey				: "XW_SKS_JRSOFT_DRIVER",
	mLicense			: XWMSIECtrl.mLicense,
	mSecContext			: XWMSIECtrl.mSecContext,
	mVirKey				: "XW_VKEY_TRANSKEY&MULTI&" + xgate_addr,
	mCloudSignConf		: window.location.host + "|http://211.175.81.101:8701/rss/rssreceiver,http://211.175.81.101:8702/rss/rssreceiver|http://211.175.81.101:8002/cloudSign/_gbs/controller/uplogin.do,http://211.175.81.101:8002/cloudSign/_gbs/controller/upservice.do|http://211.175.81.101:8701/rcs/rcsreceiver|2&http://download.softforum.co.kr/CloudSign/install.html|width=507,height=502,left=10,top=10|1.0.0.1",

	mWinVersion			: XWFirefoxCtrl.mWinVersion,
	mWin32Src			: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/xw_install.xpi"},
	mWin32SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win32.html"},
	mWin64Src			: null,
	mWin64SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win64.html"},

	mLinuxVersion		: null,
	mLinux32Src			: null,
	mLinux64Src			: null,

	mMacVersion			: null,
	mMacPPCSrc			: null,
	mMacIntelSrc		: null
}

var XWOperaCtrl = {
	mName				: "XecureWebClient",
	mType				: null,
	mTypeWin32			: "application/xecureweb-plugin",
	mTypeLinux			: "application/xecure-plugin",
	//mSecOption		: "8704:hard:iccard:USBTOKEN_KIUP",
	mSecOption			: "512:hard:iccard:USBTOKEN_KIUP",
	mPluginLicense		: XWFirefoxCtrl.mPluginLicense,
	mStorage			: "hard,removable,csp,pkcs11,USBTOKEN_KIUP,iccard,NO_SMARTON,USBTOKEN_KIUP,MPHONE",
	mSecKey				: "XW_SKS_JRSOFT_DRIVER",
	mSecContext			: XWMSIECtrl.mSecContext,
	mVirKey				: "XW_VKEY_TRANSKEY&SINGLE&" + xgate_addr,
	mCloudSignConf		: window.location.host + "|http://211.175.81.101:8701/rss/rssreceiver,http://211.175.81.101:8702/rss/rssreceiver|http://211.175.81.101:8002/cloudSign/_gbs/controller/uplogin.do,http://211.175.81.101:8002/cloudSign/_gbs/controller/upservice.do|http://211.175.81.101:8701/rcs/rcsreceiver|2&http://download.softforum.co.kr/CloudSign/install.html|width=507,height=502,left=10,top=10|1.0.0.1",

	mWinVersion			: XWFirefoxCtrl.mWinVersion,
	mWin32Src			: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win32.html"},
	mWin32SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win32.html"},
	mWin64Src			: null,
	mWin64SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win64.html"},

	mLinuxVersion		: null,
	mLinux32Src			: null,
	mLinux64Src			: null,

	mMacVersion			: null,
	mMacPPCSrc			: null,
	mMacIntelSrc		: null
}

var XWIphoneCtrl = {
	mName				: "XecureWeb",
	mType				: null,
	mTypeLinux			: "application/xecure-plugin",
	mLicense			: XWMSIECtrl.mLicense,
	mStorage			: "hard,removable,pkcs11",
	//mSecOption			: "4672:hard:iccard",
	mSecOption			: "",
	mSecKey				: "XW_SKS_SFVIRTUAL_DRIVER",
	//mSecContext			: XWMSIECtrl.mSecContext,
	mSecContext			: "",

	mMacVersion			: "7.2.0.2"
}

var XWAndroidCtrl = {
	mName				: "XecureWeb",
	mType				: null,
	mTypeLinux			: "application/xecure-plugin",
	mLicense			: "license data",
	mStorage			: "hard,removable,pkcs11",
	//mSecOption			: "4608:hard:iccard",
	mSecOption			: "4608:hard:removable:iccard",
	mSecKey				: "XW_SKS_SFVIRTUAL_DRIVER",
	mSecContext			: XWMSIECtrl.mSecContext,
 	mAndroidVersion		: "7.2.0.4"
}

var XWSeamonkeyCtrl = {
	mName				: "XecureWebClient",
	mType				: null,
	mTypeWin32			: "application/xecureweb-plugin",
	mTypeLinux			: "application/xecure-plugin",
	mPluginLicense		: XWFirefoxCtrl.mPluginLicense,

	mWinVersion			: null,
	mWin32Src			: null,
	mWin64Src			: null,

	mLinuxVersion		: null,
	mLinux32Src			: null,
	mLinux64Src			: null,

	mMacVersion			: null,
	mMacPPCSrc			: null,
	mMacIntelSrc		: null
}

/* Netscape 9 */
var XWNavigatorCtrl = {
	mName				: "XecureWebClient",
	mType				: null,
	mTypeWin32			: "application/xecureweb-plugin",
	mTypeLinux			: "application/xecure-plugin",

	mWinVersion			: null,
	mWin32Src			: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/xw_install.xpi"},
	mWin32SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win32.html"},
	mWin64Src			: null,
	mWin64SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win64.html"},

	mLinuxVersion		: null,
	mLinux32Src			: null,
	mLinux64Src			: null,

	mMacVersion			: null,
	mMacPPCSrc			: null,
	mMacIntelSrc		: null
}

/* Netscape 6~8 */
var XWNetscapeCtrl = {
	mName				: "XecureWebClient",
	mType				: null,
	mTypeWin32			: "application/xecureweb-plugin",
	mTypeLinux			: "application/xecure-plugin",

	mWinVersion			: "7.0.0.0",
	mWin32Src			: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/xw_install.xpi"},
	mWin32SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win32.html"},
	mWin64Src			: null,
	mWin64SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win64.html"},

	mLinuxVersion		: null,
	mLinux32Src			: null,
	mLinux64Src			: null,

	mMacVersion			: null,
	mMacPPCSrc			: null,
	mMacIntelSrc		: null
}


/* Netscape 4 */
var XWNetscapeCtrl4 = {
	mName				: "XecureWebClient",
	mType				: "application/x-SoftForum-XecSSL40",

	mWinVersion			: "5.5.0.0",
	mWin32Src			: "http://" + window.location.host + "/XecureObject/NPXecSSL_Install.jar",
	mWin32SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win32.html"},
	mWin64Src			: null,
	mWin64SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win64.html"},

	mLinuxVersion		: null,
	mLinux32Src			: null,
	mLinux64Src			: null,

	mMacVersion			: null,
	mMacPPCSrc			: null,
	mMacIntelSrc		: null
}

function XWBrowser ()
{
	/* O/S Constant List */
	this.cWIN			= "Win";
	this.cWIN32			= "Win32";
	this.cWIN64			= "Win64";

	this.cLINUX			= "Linux";
	this.cLINUX32		= "Linux i";
	this.cLINUX64		= "Linux x86_64";

	this.cMAC			= "Mac";
	this.cMACPPC		= "MacPPC";
	this.cMACINTEL		= "MacIntel";

	this.cMACIPOD				= "iPod";
	this.cMACIPHONE				= "iPhone";
	this.cMACIPHONESIMULATOR	= "iPhone Simulator";

	this.cANDROID				= "Android";

	/* Web Browser Constant List */
	this.cMSIE					= "MSIE";
	this.cCHROME				= "Chrome";
	this.cSAFARI				= "Safari";
	this.cMOBILESAFARI			= "Mobile Safari";
	this.cXECUREWEBIPHONE		= "AppleWebKit";
	this.cSEAMONKEY				= "SeaMonkey";
	this.cFIREFOX				= "Firefox";
	this.cNAVIGATOR				= "Nevigator";
	this.cNETSCAPE				= "Netscape";
	this.cNETSCAPE4				= "Netscape4";
	this.cOPERA					= "Opera";
	this.cUNSUPPORT				= "Unsupport";

	/* Member variables */
	this.mPlatform		= navigator.platform;
	this.mUserAgent		= navigator.userAgent;

	this.mBrowserCtrl	= null;						/* ������ �������� ��Ʈ�ѿ� ���� �����ͷ� getBrowserName���� �����Ǵ� ���̴�.  */
	this.mBrowser		= this.getBrowserName();
	this.mVersion		= this.getBrowserVersion();
}

XWBrowser.prototype = {
	getBrowserName : function ()
	{
		var result;

		if (this.mUserAgent.indexOf (this.cMSIE) != -1)				// Explorer
		{
			// XecureWeb Client 64bit
			if (this.mPlatform == this.cWIN64 || this.mUserAgent.indexOf (this.cWIN64) != -1)
				this.mBrowserCtrl = XWMSIECtrlx64;
			else
				this.mBrowserCtrl = XWMSIECtrl;
			//
				
			result = this.cMSIE;
		}

		else if (this.mUserAgent.indexOf (this.cCHROME) != -1)		// Chrome
		{
			this.mBrowserCtrl = XWChromeCtrl;
			result = this.cCHROME;
		}
		
		else if (this.mUserAgent.indexOf (this.cANDROID) != -1)
		{
			result = this.cANDROID;
		}

		else if (this.mUserAgent.indexOf (this.cSAFARI) != -1)		// Safari
		{
			if (this.mUserAgent.indexOf ("Mobile") != -1)
			{
				result = this.cMOBILESAFARI;
			}
			else
			{
				this.mBrowserCtrl = XWSafariCtrl;
				result = this.cSAFARI;
			}
		}

		else if (this.mUserAgent.indexOf (this.cOPERA) != -1)		// Opera
		{
			this.mBrowserCtrl = XWOperaCtrl;
			result = this.cOPERA;
		}

		else if (this.mUserAgent.indexOf (this.cFIREFOX) != -1)
		{
			if (this.mUserAgent.indexOf (this.cNETSCAPE) != -1)		// Netscape 6
			{
				this.mBrowserCtrl = XWNetscapeCtrl;
				result = this.cNETSCAPE;
			}
			else													// Firefox
			{
				this.mBrowserCtrl = XWFirefoxCtrl;
				result = this.cFIREFOX;
			}
		}

		else if (this.mUserAgent.indexOf ("BonEcho") != -1)			// Firefox 2 source build
		{
			this.mBrowserCtrl = XWFirefoxCtrl;
			result = this.cFIREFOX;
		}

		else if (this.mUserAgent.indexOf ("Minefield") != -1)		// Firefox 3 source build
		{
			this.mBrowserCtrl = XWFirefoxCtrl;
			result = this.cFIREFOX;
		}

		else if (this.mUserAgent.indexOf (this.cNETSCAPE) != -1)	// Netscape 6
		{
			this.mBrowserCtrl = XWNetscapeCtrl;
			result = this.cNETSCAPE;
		}

		else if (this.mUserAgent.indexOf ("Mozilla/4") != -1)		// Netscape 4
		{
			this.mBrowserCtrl = XWNetscapeCtrl4;
			result = this.cNETSCAPE4;
		}
		
		else if (this.mUserAgent.indexOf (this.cXECUREWEBIPHONE) != -1 &&
				 this.mUserAgent.indexOf ("Mobile") != -1)			// XecureWeb for iPhone
		{
			this.mBrowserCtrl = XWIphoneCtrl;
			result = this.cXECUREWEBIPHONE;
		}
		else
			result = this.cUNSUPPORT;								// Unsupport

		return result;

	},

	getBrowserVersion : function ()
	{
		var result;
		var fromIndex = this.mUserAgent.indexOf (this.mBrowser);

		if (this.mBrowser == this.cMSIE)
		{
			fromIndex += 5;
			result = this.mUserAgent.substring (fromIndex,
												this.mUserAgent.indexOf (";", fromIndex));
		}
		else if (this.mBrowser == this.cCHROME)
		{
/*
Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/530.5 (KHTML, like Gecko) Chrome/2.0.172.30 Safari/530.5
 */
			fromIndex += this.cCHROME.length + 1;
			result = this.mUserAgent.substring (fromIndex,
												this.mUserAgent.indexOf (" ", fromIndex));
		}
		else if (this.mBrowser == this.cSAFARI)
		{
			fromIndex = this.mUserAgent.indexOf ("Version") + 8;
			result = this.mUserAgent.substring (fromIndex,
												this.mUserAgent.indexOf (" ", fromIndex));
		}
		else if (this.mBrowser == this.cFIREFOX)
		{
			fromIndex += 8;
			result = this.mUserAgent.substring (fromIndex);
		}
		else if (this.mBrowser == this.cNETSCAPE)
		{
			fromIndex += 10;
			result = this.mUserAgent.substring (fromIndex);
		}
		else if (this.mBrowser == this.cNETSCAPE4)
		{
			fromIndex = this.mUserAgent.indexOf ("Mozilla") + 8;
			result = this.mUserAgent.substring (fromIndex, fromIndex + 4);
		}
		else if (this.mBrowser == this.cOPERA)
		{
			fromIndex = this.mUserAgent.indexOf (this.cOPERA) + 6;
			result = this.mUserAgent.substring (fromIndex, fromIndex + 4);
		}
		else
			result = 0;

		return result;
	},

	getUpdateTag : function ()
	{
		var result = "";
		if (this.mBrowser == this.cMSIE)
		{
			result = "<object ";
			result += "id=\"" + XWMSIEUpdateCtrl.mName + "\" ";
			result += "classid=\"" + XWMSIEUpdateCtrl.mCID + "\" ";
			result += "codebase=\"" + XWMSIEUpdateCtrl.mCodeBase + "\" ";
			result += "width=0 height=0>";
			result += "No XecureWeb LiveUpdate";
			result += "</object>";
		}

		return result;
	},

	getObjectTag : function (aPluginFlag, aBrowser)
	{
		var result;
		var XWBrowserCtrl;

		if (aBrowser == undefined)
		{
			return this.getObjectTag (aPluginFlag, this.mBrowser);
		}

		/*------------------------------------------------------------------------------------
		 * Internet Explore
		 * �����Ǵ� OS
		 * - windows 32/64bit
		 *------------------------------------------------------------------------------------*/
		else if (aBrowser == this.cMSIE)
		{
			// XecureWeb Client 64bit
			if (this.mPlatform == this.cWIN64 || this.mUserAgent.indexOf (this.cWIN64) != -1)
			{
				if (aPluginFlag == 0)
					XWBrowserCtrl = XWMSIECtrlx64;
				else
					XWBrowserCtrl = XWFileMSIECtrlx64;
				
			}
			// XecureWeb Client 32bit
			else if (this.mPlatform == this.cWIN32)
			{		
				if (aPluginFlag == 0)
					XWBrowserCtrl = XWMSIECtrl;
				else
					XWBrowserCtrl = XWFileMSIECtrl;
			}
			else
			{
				result = this.mPlatform + "�� �������� �ʴ� �ü���Դϴ�.";
			}
			//
			 
		
			result = "<object ";
			result += "id=\"" + XWBrowserCtrl.mName + "\" ";
			result += "classid=\"" + XWBrowserCtrl.mCID + "\" ";
			result += "codebase=\"" + XWBrowserCtrl.mCodeBase + "\" ";
			result += "width=0 height=0>";
			result += "<param name=\"LICENSE\"    		value=\""	+ XWBrowserCtrl.mLicense + "\">";
			result += "<param name=\"storage\"     		value=\""	+ XWBrowserCtrl.mStorage + "\">";
			result += "<param name=\"sec_option\" 	 	value=\""	+ XWBrowserCtrl.mSecOption + "\">";
			result += "<param name=\"SECKEY\"      		value=\""	+ XWBrowserCtrl.mSecKey + "\">";
			result += "<param name=\"sec_context\" 		value=\""	+ XWBrowserCtrl.mSecContext + "\">";
			result += "<param name=\"LANG\" 			 		value=\""	+ XWBrowserCtrl.mLang + "\">";
			result += "<param name=\"DEFINEDCANAME\" 	value=\""	+ XWBrowserCtrl.mCaName + "\">";
			result += "<param name=\"LIMITPIN\" 			value=\""	+ XWBrowserCtrl.mLIMITPIN + "\">";
			result += "<param name=\"LIMITCERTPWD\" 	value=\""	+ XWBrowserCtrl.mLIMITCERTPWD + "\">";
			result += "<param name=\"VIRKEYBRD\" 			value=\""	+ XWBrowserCtrl.mVirKey + "\">";
			result += "<param name=\"CLOUDSIGNDATA\" 	value=\""	+ XWBrowserCtrl.mCloudSignConf + "\">";
			result += "<param name=\"BROWSER\"		 		value=\""	+ aBrowser + "\">";
			result += "No XecureWeb PlugIn";
			result += "</object>";
		}



		/*------------------------------------------------------------------------------------
		 * Firefox
		 * �����Ǵ� OS
		 * - windows 32bit
		 * - linux 32/64bit
		 * - macintosh intel/ppc
		 *------------------------------------------------------------------------------------*/
		else if (aBrowser == this.cFIREFOX)
		{
			if (aPluginFlag == 0)
				XWBrowserCtrl = XWFirefoxCtrl;
			else
				XWBrowserCtrl = XWFileFirefoxCtrl;

			result = "<object ";
			result += "id=\"" + XWBrowserCtrl.mName + "\" ";
			result += "type=\""		+ XWBrowserCtrl.mType + "\" ";
			result += "width=0 height=0>";
			result += "<param name=\"LICENSE\"     		value=\""	+ XWBrowserCtrl.mLicense + "\">";
			result += "<param name=\"PluginLicense\"    value=\""	+ XWBrowserCtrl.mPluginLicense + "\">";
			result += "<param name=\"storage\"     		value=\""	+ XWBrowserCtrl.mStorage + "\">";
			result += "<param name=\"sec_option\"  		value=\""	+ XWBrowserCtrl.mSecOption + "\">";
			result += "<param name=\"SECKEY\"      		value=\""	+ XWBrowserCtrl.mSecKey + "\">";
			result += "<param name=\"sec_context\" 		value=\""	+ XWBrowserCtrl.mSecContext + "\">";
			result += "<param name=\"VIRKEYBRD\" 		value=\""	+ XWBrowserCtrl.mVirKey + "\">";
			result += "<param name=\"CLOUDSIGNDATA\" 	value=\""	+ XWBrowserCtrl.mCloudSignConf + "\">";
			result += "<param name=\"BROWSER\" 			value=\""	+ aBrowser + "\">";
			result += "No XecureWeb PlugIn";
			result += "</object>";

			if (this.mPlatform.indexOf (this.cWIN32) != -1
				|| this.mPlatform.indexOf (this.cLINUX) != -1
				|| this.mPlatform.indexOf (this.cMAC) != -1)
			{
				if (this.mPlatform == this.cWIN64)
					result = this.mPlatform + "�� �������� �ʴ� �ü���Դϴ�.";
			}

			else
				result = this.mPlatform + "�� �������� �ʴ� �ü���Դϴ�.";
		}

		/*------------------------------------------------------------------------------------
		 * Chrome
		 * �����Ǵ� OS
		 * - windows 32bit
		 *------------------------------------------------------------------------------------*/
		else if (aBrowser == this.cCHROME)
		{
			if (aPluginFlag == 0)
				XWBrowserCtrl = XWChromeCtrl;
			else
				XWBrowserCtrl = XWFileChromeCtrl;

			result = "<object ";
			result += "id=\"" + XWBrowserCtrl.mName + "\" ";
			result += "type=\""		+ XWBrowserCtrl.mType + "\" ";
			result += "width=0 height=0>";
			result += "<param name=\"LICENSE\"   		value=\""	+ XWBrowserCtrl.mLicense + "\">";
			result += "<param name=\"VIRKEYBRD\" 		value=\""	+ XWBrowserCtrl.mVirKey + "\">";
			result += "<param name=\"storage\"    		value=\""	+ XWBrowserCtrl.mStorage + "\">";
			result += "<param name=\"sec_option\"  		value=\""	+ XWBrowserCtrl.mSecOption + "\">";
			result += "<param name=\"SECKEY\"      		value=\""	+ XWBrowserCtrl.mSecKey + "\">";
			result += "<param name=\"sec_context\" 		value=\""	+ XWBrowserCtrl.mSecContext + "\">";
			result += "<param name=\"CLOUDSIGNDATA\" 	value=\""	+ XWBrowserCtrl.mCloudSignConf + "\">";
			result += "<param name=\"BROWSER\" 			value=\""	+ aBrowser + "\">";
			result += "<param name=\"PluginLicense\"    value=\""	+ XWBrowserCtrl.mPluginLicense + "\">";
			result += "No XecureWeb PlugIn";
			result += "</object>";

			if (this.mPlatform.indexOf (this.cWIN32) == -1)
			{
				result = this.mPlatform + "�� �������� �ʴ� �ü���Դϴ�.";
			}
		}

		/*------------------------------------------------------------------------------------
		 * Safari
		 * �����Ǵ� OS
		 * - windows 32bit
		 * - macintosh intel/ppc
		 *------------------------------------------------------------------------------------*/
		else if (aBrowser == this.cSAFARI)
		{
			if (aPluginFlag == 0)
				XWBrowserCtrl = XWSafariCtrl;
			else
				XWBrowserCtrl = XWFileSafariCtrl;

			result = "<object ";
			result += "id=\"" + XWBrowserCtrl.mName + "\" ";
			result += "type=\""		+ XWBrowserCtrl.mType + "\" ";
			result += "width=0 height=0>";
			result += "<param name=\"LICENSE\"    		value=\""	+ XWBrowserCtrl.mLicense + "\">";
			result += "<param name=\"PluginLicense\"    value=\""	+ XWBrowserCtrl.mPluginLicense + "\">";
			result += "<param name=\"storage\"     		value=\""	+ XWBrowserCtrl.mStorage + "\">";
			result += "<param name=\"sec_option\"  		value=\""	+ XWBrowserCtrl.mSecOption + "\">";
			result += "<param name=\"SECKEY\"      		value=\""	+ XWBrowserCtrl.mSecKey + "\">";
			result += "<param name=\"sec_context\" 		value=\""	+ XWBrowserCtrl.mSecContext + "\">";
			result += "<param name=\"VIRKEYBRD\" 		value=\""	+ XWBrowserCtrl.mVirKey + "\">";
			result += "<param name=\"CLOUDSIGNDATA\" 	value=\""	+ XWBrowserCtrl.mCloudSignConf + "\">";
			result += "<param name=\"BROWSER\" 			value=\""	+ aBrowser + "\">";
			result += "No XecureWeb PlugIn";
			result += "</object>";

			if (!(this.mPlatform.indexOf (this.cMAC) != -1
				  || this.mPlatform.indexOf (this.cWIN32) != -1))
			{
				result = this.mPlatform + "�� �������� �ʴ� �ü���Դϴ�.";
			}

		}

		/*------------------------------------------------------------------------------------
		 * XecureWeb for iPhone
		 * �����Ǵ� OS
		 * - iPod / iPhone / iPhone Simulator
		 *------------------------------------------------------------------------------------*/
		else if (aBrowser == this.cXECUREWEBIPHONE)
		{
			if (aPluginFlag == 0)
				XWBrowserCtrl = XWIphoneCtrl;
			else
				XWBrowserCtrl = XWFileIphoneCtrl;

			result = "<script>";

			if (aPluginFlag == 0)
				result += "if (XWiPhone.XecureWeb.CreateObject ('";
			else
				result += "if (XWiPhone.FileAccess.CreateObject ('";

			result += "id			: " + XWBrowserCtrl.mName + "$";
			result += "type			: " + XWBrowserCtrl.mType + "$";
			result += "license		: " + XWBrowserCtrl.mLicense + "$";
			result += "storage		: " + XWBrowserCtrl.mStorage + "$";
			result += "sec_option	: " + XWBrowserCtrl.mSecOption + "$";
			result += "seckey		: " + XWBrowserCtrl.mSecKey + "$";
			result += "sec_context	: " + XWBrowserCtrl.mSecContext + "";
			result += "') == true)";
			result += "{";

			if (aPluginFlag == 0)
				result += "		document.XecureWeb = XWiPhone.XecureWeb;";
			else
				result += "		document.FileAccess = XWiPhone.FileAccess;";

			result += "}";
			result += "else";
			result += "{";
			result += "		document.write ('No XecureWeb PlugIn');";
			result += "}";
			result += "</script>";
		}
		
		
		/*------------------------------------------------------------------------------------
		 * Android Webkit
		 * �����Ǵ� OS
		 *  - Android
		 *------------------------------------------------------------------------------------*/
		else if (aBrowser == this.cANDROID)
		{
			if (aPluginFlag == 0)
				XWBrowserCtrl = XWAndroidCtrl;
			else
				XWBrowserCtrl = XWFileAndroidCtrl;

			result = "<script>";

			if (aPluginFlag == 0)
			{
				result += "document.XecureWeb = window.XecureWeb;";
				result += "document.XecureWeb.SetAttribute('id', '" + XWBrowserCtrl.mName + "');";
				result += "document.XecureWeb.SetAttribute('type', '" + XWBrowserCtrl.mType + "');";
				result += "document.XecureWeb.SetAttribute('license', '" + XWBrowserCtrl.mLicense + "');";
				result += "document.XecureWeb.SetAttribute('storage', '" + XWBrowserCtrl.mStorage + "');";
				result += "document.XecureWeb.SetAttribute('sec_option', '" + XWBrowserCtrl.mSecOption + "');";
				result += "document.XecureWeb.SetAttribute('seckey', '" + XWBrowserCtrl.mSecKey + "');";
				result += "document.XecureWeb.SetAttribute('sec_context', '" + window.location.hostname + "\\t\\n" + XWBrowserCtrl.mSecContext + "');";
			}
			else
				result += "     document.FileAccess = window.FileAccess;";


			result += "</script>";
		}
		
		/*------------------------------------------------------------------------------------
		 * Opera
		 * �����Ǵ� OS
		 * - windows 32bit
		 *------------------------------------------------------------------------------------*/
		else if (aBrowser == this.cOPERA)
		{
			if (aPluginFlag == 0)
				XWBrowserCtrl = XWOperaCtrl;
			else
				XWBrowserCtrl = XWFileOperaCtrl;

			result = "<object ";
			result += "id=\"" + XWBrowserCtrl.mName + "\" ";
			result += "type=\""		+ XWBrowserCtrl.mType + "\" ";
			result += "width=0 height=0>";
			result += "<param name=\"LICENSE\"   		value=\""	+ XWBrowserCtrl.mLicense + "\">";
			result += "<param name=\"PluginLicense\"    value=\""	+ XWBrowserCtrl.mPluginLicense + "\">";
			result += "<param name=\"storage\"   		value=\""	+ XWBrowserCtrl.mStorage + "\">";
			result += "<param name=\"sec_option\" 		value=\""	+ XWBrowserCtrl.mSecOption + "\">";
			result += "<param name=\"SECKEY\"      		value=\""	+ XWBrowserCtrl.mSecKey + "\">";
			result += "<param name=\"sec_context\" 		value=\""	+ XWBrowserCtrl.mSecContext + "\">";
			result += "<param name=\"VIRKEYBRD\" 		value=\""	+ XWBrowserCtrl.mVirKey + "\">";
			result += "<param name=\"CLOUDSIGNDATA\" 	value=\""	+ XWBrowserCtrl.mCloudSignConf + "\">";
			result += "<param name=\"BROWSER\" 			value=\""	+ aBrowser + "\">";
			result += "No XecureWeb PlugIn";
			result += "</object>";

			if (this.mPlatform.indexOf (this.cWIN32) == -1)
				result = this.mPlatform + "�� �������� �ʴ� �ü���Դϴ�.";
		}

		/*------------------------------------------------------------------------------------
		 * Netscape 6.0
		 * �����Ǵ� OS
		 * - windows 32bit
		 *------------------------------------------------------------------------------------*/
		else if (aBrowser == this.cNETSCAPE)
		{
			result += "<embed ";
			result += "name=\""		+ XWNetscapeCtrl.mName + "\" ";
			result += "type=\""		+ XWNetscapeCtrl.mType + "\" ";
			result += "width=0 height=0 ";
			result += "hidden=true>";
			result += "</embed>";
			result += "<noembed>No XecureWeb PlugIn</noembed>";

			if (this.mPlatform.indexOf (this.cWIN32) == -1)
				result = this.mPlatform + "�� �������� �ʴ� �ü���Դϴ�.";
		}

		/*------------------------------------------------------------------------------------
		 * Netscape 4.0
		 * �����Ǵ� OS
		 * - windows 32bit
		 *------------------------------------------------------------------------------------*/
		else if (aBrowser == this.cNETSCAPE4)
		{
			result += "<embed ";
			result += "name=\""		+ XWNetscapeCtrl4.mName + "\" ";
			result += "type=\""		+ XWNetscapeCtrl4.mType + "\" ";
			result += "width=0 height=0 ";
			result += "hidden=true>";
			result += "</embed>";
			result += "<noembed>No XecureWeb PlugIn</noembed>";

			if (this.mPlatform.indexOf (this.cWIN32) == -1)
				result = this.mPlatform + "�� �������� �ʴ� �ü���Դϴ�.";
		}
		else
		{
			result += "No XecureWeb PlugIn";
		}

		return result;
	},

	checkCtrl : function (aVersion)
	{
		var result = false;
		var xecuremime;

		if (aVersion == null || aVersion == undefined)
			return result;
		if (this.mPlatform == this.cWIN32)
			this.mBrowserCtrl.mType = this.mBrowserCtrl.mTypeWin32
		else if (this.mPlatform == this.cWIN64)
			this.mBrowserCtrl.mType = this.mBrowserCtrl.mTypeWin64
		else
			this.mBrowserCtrl.mType = this.mBrowserCtrl.mTypeLinux

		if (this.mBrowser == this.cMSIE)
			return result;
			
		if (this.mBrowser == this.cXECUREWEBIPHONE ||
			this.mBrowser == this.cANDROID)
		{
			this.mBrowserCtrl.mType = this.mBrowserCtrl.mTypeLinux;
			return result;
		}

//		xecuremime = navigator.mimeTypes [this.mBrowserCtrl.mType];

//		if (xecuremime)
//		{
//			result = this.checkCtrlVersion(xecuremime.enabledPlugin.description, aVersion);
//		}
//		else
//			result = true;

		if ((this.mPlatform.indexOf (this.cLINUX) != -1 || this.mPlatform.indexOf (this.cMAC) != -1) &&
			(this.mBrowser == this.cFIREFOX && parseInt (this.mVersion.substring (0, 1)) >= 4))
		{
			aLocalVersion = this.getFirefox4ControlVersion ();

			if (aLocalVersion == null)
			{
				return true;
			}
		}
		else
		{
			xecuremime = navigator.mimeTypes [this.mBrowserCtrl.mType];

			if (xecuremime)
			{
				aLocalVersion = xecuremime.enabledPlugin.description;
			}
			else
			{
				return true;
			}
		}

		result = this.checkCtrlVersion (aLocalVersion, aVersion);

		return result;
	},

	checkCtrlVersion : function (aDesc, aVersion)
	{
		var index = aDesc.indexOf('v.', 0);
		if (index < 0)	return true;

		aDesc += ' ';
		var versionString = aDesc.substring(index +2, aDesc.length);

		var arrayOfStrings = versionString.split('.');
		var thisMaj = parseInt(arrayOfStrings[0], 10);
		var thisMin = parseInt(arrayOfStrings[1], 10);
		var thisRel = parseInt(arrayOfStrings[2], 10);
		var thisLast = parseInt(arrayOfStrings[3], 10);

		arrayOfStrings = aVersion.split('.');
		var s_verMaj = parseInt(arrayOfStrings[0], 10);
		var s_verMin = parseInt(arrayOfStrings[1], 10);
		var s_verRel = parseInt(arrayOfStrings[2], 10);
		var s_verLast = parseInt(arrayOfStrings[3], 10);

		if (thisMaj > s_verMaj)		return false;
		if (thisMaj < s_verMaj)		return true;

		if (thisMin > s_verMin)		return false;
		if (thisMin < s_verMin)		return true;

		if (thisRel > s_verRel)		return false;
		if (thisRel < s_verRel)		return true;

		if (thisLast > s_verLast)	return false;
		if (thisLast < s_verLast)	return true;

		return false;
	},
	
	getFirefox4ControlVersion : function ()
	{
		var		aResult = null;

		try
		{
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			var aContractID = "@softforum.com/xecurewebclient/service;1";
			var aInterface = Components.interfaces.nsIXWClientComponent;
			var aPlugin = Components.classes[aContractID].getService ().QueryInterface (aInterface);

			aResult = aPlugin.GetVerInfo (1);
		}
		catch (aException)
		{
		}

		return aResult;
	},

	installCtrl : function ()
	{
		var result;
		var version;

		if (this.mBrowser == this.cFIREFOX)
		{
			if (this.mPlatform == this.cWIN32)
			{
				version = this.getBrowserVersion().split(".");
				result = window.open(XWFirefoxCtrl.mWin32SrcManual["XecureWeb Plugin"], '_blank');
			}
			else if (this.mPlatform.indexOf (this.cLINUX) != -1)
			{
				if (this.mPlatform == this.cLINUX64)
				{
					if (parseInt (this.mVersion.substring (0, 1)) < 4)
					{
						result = this.installGecko (XWFirefoxCtrl.mSrc_linux_64_30);
					}
					else if (parseInt (this.mVersion.substring (0, 1)) < 6)
					{
						result = this.installGecko (XWFirefoxCtrl.mSrc_linux_64_50);
					}
					else if (parseInt (this.mVersion.substring (0, 1)) < 7)
					{
						result = this.installGecko (XWFirefoxCtrl.mSrc_linux_64_60);
					}
					else if (parseInt (this.mVersion.substring (0, 1)) < 8)
					{
						result = this.installGecko (XWFirefoxCtrl.mSrc_linux_64_70);
					}
					else
					{
						result = this.installGecko (XWFirefoxCtrl.mSrc_linux_64_80);
					}
				}
				else
				{
					if (parseInt (this.mVersion.substring (0, 1)) < 4)
					{
						result = this.installGecko (XWFirefoxCtrl.mSrc_linux_32_30);
					}
					else if (parseInt (this.mVersion.substring (0, 1)) < 6)
					{
						result = this.installGecko (XWFirefoxCtrl.mSrc_linux_32_50);
					}
					else if (parseInt (this.mVersion.substring (0, 1)) < 7)
					{
						result = this.installGecko (XWFirefoxCtrl.mSrc_linux_32_60);
					}
					else if (parseInt (this.mVersion.substring (0, 1)) < 8)
					{
						result = this.installGecko (XWFirefoxCtrl.mSrc_linux_32_70);
					}
					else
					{
						result = this.installGecko (XWFirefoxCtrl.mSrc_linux_32_80);
					}
				}
			}
			else if (this.mPlatform.indexOf (this.cMAC) != -1)
			{
				if (this.mPlatform == this.cMACINTEL)
				{
					if (parseInt (this.mVersion.substring (0, 1)) < 4)
					{
						result = this.installGecko (XWFirefoxCtrl.mSrc_mac_32_30);
					}
					else if (parseInt (this.mVersion.substring (0, 1)) < 6)
					{
						result = this.installGecko (XWFirefoxCtrl.mSrc_mac_intel_50);
					}
					else if (parseInt (this.mVersion.substring (0, 1)) < 7)
					{
						result = this.installGecko (XWFirefoxCtrl.mSrc_mac_intel_60);
					}
					else if (parseInt (this.mVersion.substring (0, 1)) < 8)
					{
						result = this.installGecko (XWFirefoxCtrl.mSrc_mac_intel_70);
					}
					else
					{
						result = this.installGecko (XWFirefoxCtrl.mSrc_mac_intel_80);
					}
				}
				else
				{
					result = this.installGecko (XWFirefoxCtrl.mSrc_mac_ppc_30);
				}
			}
			else
			{
				alert ("Unsupported O/S");
			}
		}
		else if (this.mBrowser == this.cCHROME)
		{	// Win32
			/* ũ���� �˾� ������ �ٷ� ���ܵǴ� ���� �⺻�̶� _self ������ �̵����� ó�� �Ѵ�. */
			if (this.mPlatform == this.cWIN32)
			{
				version = this.getBrowserVersion().split(".");
				result = window.open(XWChromeCtrl.mWin32SrcManual["XecureWeb Plugin"], '_self');
			}
		}

		else if (this.mBrowser == this.cSAFARI)
		{	// Win32, MacPPC, MacIntel
			/* Safari�� �˾� ������ �ٷ� ���ܵǴ� ���� �⺻�̶� _self ������ �̵����� ó�� �Ѵ�. */
			if (this.mPlatform == this.cWIN32)
				result = window.open(XWSafariCtrl.mWin32SrcManual["XecureWeb Plugin"], '_self');
			if (this.mPlatform == this.cMACPPC)
				result = window.open(XWSafariCtrl.mMacPPCSrc, '_self');
			else if (this.mPlatform == this.cMACINTEL)
				result = window.open(XWSafariCtrl.mMacIntelSrc, '_self');
		}
		else if (this.mBrowser == this.cOPERA)
		{
			if (this.mPlatform == this.cWIN32)
				result = window.open(XWOperaCtrl.mWin32SrcManual["XecureWeb Plugin"], '_self');
		}
		else if (this.mBrowser == this.cNETSCAPE)
		{
			if (this.mPlatform == this.cWIN32)
				result = this.installGecko (XWNetscapeCtrl.mWin32Src);
		}
		else if (this.mBrowser == this.cNETSCAPE4)
		{
			if (this.mPlatform == this.cWIN32)
				result = this.installNetscape (XWNetscapeCtrl4.mWin32Src);
		}

		return result;
	},

	installGecko : function (aSrc)
	{
		var result = null;

		function xpiCB (url, status)
		{
			if( status != 0 ) {
				// error occurred
				alert( status + " : " + url);
			}
		}

		result = InstallTrigger.install (aSrc, xpiCB);

		return result;
	},

	installNetscape : function (aSrc)
	{
		var result = false;

		if ( navigator.javaEnabled() )
		{
			var trigger = netscape.softupdate.Trigger;
			if ( trigger.UpdateEnabled() )
			{
				result = trigger.StartSoftwareUpdate( aSrc, trigger.DEFAULT_MODE);
			}
			else
				alert('�ݽ������� SmartUpdate ��ġ�� �����ϵ��� �ؾ��մϴ�.');
		}
		else
			alert('Java ������ �����ϵ��� �ؾ��մϴ�.');

		return result;
	},

	updateModules : function ( aModuleName, aSetupURL, aUpdateURL, aOption)
	{
		var aResult = false;

		if (this.mBrowser != this.cMSIE)
		{
			var aVersion;

			if (this.mBrowser == this.cFIREFOX)
			{
				if (this.mPlatform.indexOf (this.cWIN) != -1)
					aVersion = XWFirefoxCtrl.mWinVersion;
				else if (this.mPlatform.indexOf (this.cLINUX) != -1)
					aVersion = XWFirefoxCtrl.mLinuxVersion;
				else if (this.mPlatform.indexOf (this.cMAC) != -1)
					aVersion = XWFirefoxCtrl.mMacVersion;
			}
			else if (this.mBrowser == this.cSAFARI)
			{
				if (this.mPlatform.indexOf (this.cWIN) != -1)
					aVersion = XWSafariCtrl.mWinVersion;
				else if (this.mPlatform.indexOf (this.cLINUX) != -1)
					aVersion = XWSafariCtrl.mLinuxVersion;
				else if (this.mPlatform.indexOf (this.cMAC) != -1)
					aVersion = XWSafariCtrl.mMacVersion;
			}
			else if (this.mBrowser == this.cNETSCAPE)
			{
				if (this.mPlatform.indexOf (this.cWIN) != -1)
					aVersion = XWNetscapeCtrl.mWinVersion;
				else if (this.mPlatform.indexOf (this.cLINUX) != -1)
					aVersion = XWNetscapeCtrl.mLinuxVersion;
				else if (this.mPlatform.indexOf (this.cMAC) != -1)
					aVersion = XWNetscapeCtrl.mMacVersion;
			}
			else if (this.mBrowser == this.cNETSCAPE4)
			{
				if (this.mPlatform.indexOf (this.cWIN) != -1)
					aVersion = XWNetscapeCtrl4.mWinVersion;
				else if (this.mPlatform.indexOf (this.cLINUX) != -1)
					aVersion = XWNetscapeCtrl4.mLinuxVersion;
				else if (this.mPlatform.indexOf (this.cMAC) != -1)
					aVersion = XWNetscapeCtrl4.mMacVersion;
			}
			else
				aVersion = null;

			if (aVersion == null)
			{
				alert ("Unsupported Browser!!");
				return aResult;
			}

			if (this.checkCtrl (aVersion))
			{
				this.installCtrl();
			}

			aResult = true;
		}

		else
		{
			var errCode = 0;
			var errDivision = 0;
			var errMsg;

			/*
			 * #define UPDATE_OK               1   // ������Ʈ�� ������ ���
			 * #define UPDATE_CANCEL           2   // ������Ʈ�� ����� ���
			 * #define UPDATE_ALREADY          3   // �Ϸ翡 �� �� �̹� ������Ʈ�� ������ ���
			 *
			 * #define UPDATE_ERROR            -1  // �� ���� ������Ʈ���� ������ �� ���
			 * #define UPDATE_COPY_ERROR       -2  // �����ϴ� ���߿� ���� ����
			 * #define UPDATE_HOLDING          -3  // ������� ������ �־ ������Ʈ�� ���ϴ� ���
			 * #define UPDATE_INVALID_USER     -4  // �����ڷ� �α����� �ؾ� ������Ʈ�� ������ ���
			 * #define UPDATE_NEED_NOT         -5
			 * #define UPDATE_USIGN            -6
			 * #define UPDATE_INVALID_URL      -7  // Update ������ ���� ini������ url�� �߸��� ���
			 * #define UPDATE_FAIL_DIR         -8  // ���丮 ���� ����
			 * #define INSTALL_ERROR           -9  // ��ġ���Ϸ� ��ġ�ϴٰ� ������ �� ���.
			 * #define UPDATE_REG_ERROR        -10
			 * moduleName : ��ġ�� ��ǰ�� �� �־���� ������ ��ο� �̸�
			 * setupURL   : ��ġ�� ��ǰ�� ���� ��쿡 ��ġ������ �޾ƿ� URL
			 * updateURL  : ������Ʈ�� �� URL
			 * opution    : ��� ������Ʈ ��(���� ������Ʈ) 1, �׿��� ��� 0
			 */          

			try {
				errCode = document.XecureWebBaseCtrl.RunLiveUpdate(aModuleName, aSetupURL, aUpdateURL, aOption);
			} catch (e) {
				// ��ġ�� ���� �ȵǾ��� ��
				return false;
			}

			switch(errCode)
			{
				case 1:
					errMsg = "Success / ���������� ������Ʈ�� �����߽��ϴ�. \n\n" + errCode;
					location.reload(true);
					break;
				case 2:
					errMsg = "Liveupdate �� ��� �Ǿ����ϴ�.\n\n" + errCode;
					break;
				case 3:
					errMsg = "Liveupdate �� �̹� ó�� �Ǿ����ϴ�.. \n\n" + errCode;
					aResult = true;
					break;
				case 4:
					errMsg = "Liveupdate �̹� ���� ���Դϴ�. ��ø� ��ٷ� �ּ���.\n\n" + errCode;
					break;
				default:
					errMsg = "Liveupdate �� ������ �߻��Ͽ����ϴ�.\n���� �ڵ�[" + errCode + "]\n" + errCode;
					break;
			}
		}

		return aResult;
	}
};


var gXWBrowser = new XWBrowser();


function PrintUpdateTag ()
{
	document.write (gXWBrowser.getUpdateTag());
}

function LiveUpdateModules (aModuleName, aSetupURL, aUpdateURL, aOption)
{
	var aResult = false;
	alert(aResult);
	aResult = gXWBrowser.updateModules (aModuleName, aSetupURL, aUpdateURL, aOption);
	alert(aResult);
	return aResult;
}

var XWClientComponent = {
	SetAttribute : function (aKey, aValue)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege ("UniversalXPConnect");
			return ccObj.SetAttribute (aKey, aValue);
		}
		catch (aError)
		{
			return aError;
		}
	},

	BlockEnc : function(xgate_addr, path, qs, type)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.BlockEnc(xgate_addr, path, qs, type);
		} catch (err) {
			return err;
		}
	},

	BlockEncEx : function(xgate_addr, path, qs, type, cert)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.BlockEncEx (xgate_addr, path, qs, type, cert);
		} catch (err) {
			return err;
		}
	},

	BlockEnc3 : function(xgate_addr, path, qs, type)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.BlockEnc3(xgate_addr, path, qs, type);
		} catch (err) {
			return err;
		}
	},

	BlockDec : function(xgate_addr, cipher)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.BlockDec(xgate_addr, cipher);
		} catch (err) {
			return err;
		}
	},

	
	BlockDecREP : function(xgate_addr, cipher, method)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.BlockDecREP(xgate_addr, cipher, method);
		} catch (err) {
			return err;
		}
	},

	HashData : function(data, hashAlg)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.HashData(data, hashAlg);
		} catch (err) {
			return err;
		}
	},

	SignData : function(xgate_addr, ca_name, data, fView, desc, pwd_fail)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SignData(xgate_addr, ca_name, data, fView, desc, pwd_fail);
		} catch (err) {
			return err;
		}
	},

	SignDataAdd : function(xgate_addr, accept_cert, plain, option, sign_desc, pwd_fail)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SignDataAdd(xgate_addr, accept_cert, plain, option, sign_desc, pwd_fail);
		} catch (err) {
			return err;
		}
	},

	SignDataCMS : function(xgate_addr, accept_cert, plain, option, sign_desc, pwd_fail)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SignDataCMS(xgate_addr, accept_cert, plain, option, sign_desc, pwd_fail);
		} catch (err) {
			return err;
		}
	},

	SignDataCMSWithHTMLEx : function(xgate_addr, accept_cert, plain, keydata, svrCert, option, sign_desc, pwd_fail)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege ("UniversalXPConnect");
			return ccObj.SignDataCMSWithHTMLEx (xgate_addr, accept_cert, plain, keydata, svrCert, option, sign_desc, pwd_fail);
		} catch (err) {
			return err;
		}
	},

	SignDataCMSWithHTMLExAndSerial : function(xgate_addr, accept_cert, certSerial, certLocation, plain, keydata, svrCert, option, sign_desc, pwd_fail)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege ("UniversalXPConnect");
			return ccObj.SignDataCMSWithHTMLExAndSerial (xgate_addr, accept_cert, certSerial, certLocation, plain, keydata, svrCert, option, sign_desc, pwd_fail);
		} catch (err) {
			return err;
		}
	},

	SignDataWithVID : function(xgate_addr, accept_cert, plain, svrCert, option, sign_desc, pwd_fail)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SignDataWithVID(xgate_addr, accept_cert, plain, svrCert, option, sign_desc, pwd_fail);
		} catch (err) {
			return err;
		}
	},
	
	SetIDNum : function(idn)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SetIDNum(idn);
		} catch (err) {
			return err;
		}
	},
	
	GetVidInfo : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.GetVidInfo();
		} catch (err) {
			return err;
		}
	},
	
	SignDataCMSWithSerial : function(xgate_addr, 
									 accept_cert, 
									 certSerial, 
									 certLocation, 
									 plain, 
									 option, 
									 sign_desc,
									 pwd_fail)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SignDataCMSWithSerial(xgate_addr, 
											 accept_cert, 
											 certSerial, 
											 certLocation, 
											 plain, 
											 option, 
											 sign_desc, 
											 pwd_fail);
		} catch (err) {
			return err;
		}
	},

	SignDataWithVID_Serial : function(xgate_addr, 
									  accept_cert, 
									  certSerial, 
									  certLocation, 
									  plain, 
									  svrCert, 
									  option, 
									  sign_desc, 
									  pwd_fail)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SignDataWithVID_Serial(xgate_addr, 
									  		  accept_cert, 
											  certSerial, 
											  certLocation, 
											  plain, 
											  svrCert, 
											  option, 
											  sign_desc, 
											  pwd_fail);
		} catch (err) {
			return err;
		}
	},
	
	VerifySignedData : function(signedData, option, directoryServer)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.VerifySignedData(signedData, option, directoryServer);
		} catch (err) {
			return err;
		}
	},
	
	EnvelopData : function(xgate_addr, accept_cert, inMsg, envOption, pwd, certPem, certSerial, certLocation, desc, pwd_limit)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.EnvelopData(xgate_addr, accept_cert, inMsg, envOption, pwd, certPem, certSerial, certLocation, desc, pwd_limit);
		} catch (err) {
			return err;
		}
	},
	
	DeEnvelopData : function(xgate_addr, accept_cert, inMsg, deEnvOption, pwd, desc, pwd_limit)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.DeEnvelopData(xgate_addr, accept_cert, inMsg, deEnvOption, pwd, desc, pwd_limit);
		} catch (err) {
			return err;
		}
	},

	RequestCertificate : function(ca_port, ca_ip, ref_code, auth_code, ca_type)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.RequestCertificate(ca_port, ca_ip, ref_code, auth_code, ca_type);
		} catch (err) {
			return err;
		}
	},

	RequestCertificateEx : function(port, ip, ref_code, auth_code, type, option, ca_name, ra_name)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.RequestCertificateEx(port, ip, ref_code, auth_code, type, option, ca_name, ra_name);
		} catch (err) {
			return err;
		}
	},

	RenewCertificate : function(ca_port, ca_ip, ca_type, pwd_fail)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.RenewCertificate(ca_port, ca_ip, ca_type, pwd_fail);
		} catch (err) {
			return err;
		}
	},

	RevokeCertificate : function(ca_port, ca_ip, jobcode, reason, ca_type, pwd_fail)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.RevokeCertificate(ca_port, ca_ip, jobcode, reason, ca_type, pwd_fail);
		} catch (err) {
			return err;
		}
	},

	RecoverCertificate : function(xgate_addr, ca_port, ca_ip, ref_code, auth_code, ca_type, option, pwd_fail)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.RecoverCertificate(xgate_addr, ca_port, ca_ip, ref_code, auth_code, ca_type, option, pwd_fail);
		} catch (err) {
			return err;
		}
	},

	InstallCertificate : function(cert_type, cert)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.InstallCertificate(cert_type, cert);
		} catch (err) {
			return err;
		}
	},

	PutCACert : function(pCaCertName, pCaCertUrl)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.PutCACert(pCaCertName, pCaCertUrl);
		} catch (err) {
			return err;
		}
	},

	PutCertificate : function(pCaCertName, pCaCertUrl, type)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.PutCertificate(pCaCertName, pCaCertUrl, type);
		} catch (err) {
			return err;
		}
	},

	ShowCertManager : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.ShowCertManager();
		} catch (err) {
			return err;
		}
	},

	DeleteCertificate : function(dn)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.DeleteCertificate(dn);
		} catch (err) {
			return err;
		}
	},

	SetIssuerConvertTableFirst : function(issuer, convertedIssuer, comment)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SetIssuerConvertTableFirst(issuer, convertedIssuer, comment);
		} catch (err) {
			return err;
		}
	},

	SetIssuerConvertTableNext : function(issuer, convertedIssuer, comment)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SetIssuerConvertTableNext(issuer, convertedIssuer, comment);
		} catch (err) {
			return err;
		}
	},

	SetIssuerConvertTableFinal : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SetIssuerConvertTableFinal();
		} catch (err) {
			return err;
		}
	},

	SetPolicyConvertTableFirst : function(lang, policy, convertedPolicy, comment)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SetPolicyConvertTableFirst(lang, policy, convertedPolicy, comment);
		} catch (err) {
			return err;
		}
	},

	SetPolicyConvertTableNext : function(policy, convertedPolicy, comment)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SetPolicyConvertTableNext(policy, convertedPolicy, comment);
		} catch (err) {
			return err;
		}
	},

	SetPolicyConvertTableFinal : function(lang)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SetPolicyConvertTableFinal(lang);
		} catch (err) {
			return err;
		}
	},

	UpdateModules : function(url)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.UpdateModules(url);
		} catch (err) {
			return err;
		}
	},

	SetUpdateInfoString : function(section, key, value)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SetUpdateInfoString(section, key, value);
		} catch (err) {
			return err;
		}
	},

	SCardChangePIN : function(oldPin, newPin)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SCardChangePIN(oldPin, newPin);
		} catch (err) {
			return err;
		}
	},

	SCardChangePinDlg : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SCardChangePinDlg();
		} catch (err) {
			return err;
		}
	},

	SCardChangePinDlgEx : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SCardChangePinDlgEx();
		} catch (err) {
			return err;
		}
	},

	SCardInitHSM : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SCardInitHSM();
		} catch (err) {
			return err;
		}
	},

	SCardUpdateIRD : function(ird, pin)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SCardUpdateIRD(ird, pin);
		} catch (err) {
			return err;
		}
	},

	SCardUpdateIrdDlg : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SCardUpdateIrdDlg();
		} catch (err) {
			return err;
		}
	},

	SCardReadIRD : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SCardReadIRD();
		} catch (err) {
			return err;
		}
	},

	SCardReadCSN : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SCardReadCSN();
		} catch (err) {
			return err;
		}
	},

	SCardGetRetryCount : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SCardGetRetryCount();
		} catch (err) {
			return err;
		}
	},

	SCardLoginHSM : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SCardLoginHSM();
		} catch (err) {
			return err;
		}
	},

	SCardGetVersionInfo : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SCardGetVersionInfo();
		} catch (err) {
			return err;
		}
	},

	XHSMChangePIN : function(oldPin, newPin)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.XHSMChangePIN(oldPin, newPin);
		} catch (err) {
			return err;
		}
	},

	XHSMChangePinDlg : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.XHSMChangePinDlg ();
		} catch (err) {
			return err;
		}
	},

	XHSMInit : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.XHSMInit();
		} catch (err) {
			return err;
		}
	},

	XHSMReadCSN : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.XHSMReadCSN();
		} catch (err) {
			return err;
		}
	},

	XHSMGetRetryCount : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.XHSMGetRetryCount();
		} catch (err) {
			return err;
		}
	},

	XHSMLogin : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.XHSMLogin();
		} catch (err) {
			return err;
		}
	},

	XHSMGetVersionInfo : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.XHSMGetVersionInfo();
		} catch (err) {
			return err;
		}
	},

	LastErrCode : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.LastErrCode();
		} catch (err) {
			return err;
		}
	},

	LastErrMsg : function()
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.LastErrMsg();
		} catch (err) {
			return err;
		}
	},

	EndSession : function(xaddr)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.EndSession(xaddr);
		} catch (err) {
			return err;
		}
	},

	PutBannerUrl : function(xgate_addr, url)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.PutBannerUrl(xgate_addr, url);
		} catch (err) {
			return err;
		}
	},

	PutBigBannerUrl : function(xgate_addr, url)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.PutBigBannerUrl(xgate_addr, url);
		} catch (err) {
			return err;
		}
	},

	GetVerInfo : function(option)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.GetVerInfo(option);
		} catch (err) {
			return err;
		}
	},

	VerifyAndGetVID : function(xgate_addr, ServerCertPem, TimeStamp, accept_cert, option, Idn)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.VerifyAndGetVID(xgate_addr, ServerCertPem, TimeStamp, accept_cert, option, Idn);
		} catch (err) {
			return err;
		}
	},

	SetProvider : function(provider)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SetProvider(provider);
		} catch (err) {
			return err;
		}
	},

	MapHostName : function(hostName, ip, comment, option)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.MapHostName(hostName, ip, comment, option);
		} catch (err) {
			return err;
		}
	},

	ClearCache : function(data, option)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.ClearCache(data, option);
		} catch (err) {
			return err;
		}
	},

	PutUserData : function(xaddr, data)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.PutUserData(xaddr, data);
		} catch (err) {
			return err;
		}
	},

	GetUserData : function(xaddr)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.GetUserData(xaddr);
		} catch (err) {
			return err;
		}
	},

	SetEnvVar : function(xaddr, envVar)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SetEnvVar(xaddr, envVar);
		} catch (err) {
			return err;
		}
	},

	SetPinNum : function(pin)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.SetPinNum(pin);
		} catch (err) {
			return err;
		}
	},

	GetSessionStateForToken : function(tokenSerial, type)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.GetSessionStateForToken(tokenSerial, type);
		} catch (err) {
			return err;
		}
	},

	GetSID : function(xaddr)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.GetSID(xaddr);
		} catch (err) {
			return err;
		}
	},

	ValidateWB : function(acceptList, denyList)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.ValidateWB(acceptList, denyList);
		} catch (err) {
			return err;
		}
	},

	AddTrustedSite : function(id_name, signed_url)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.AddTrustedSite(id_name, signed_url);
		} catch (err) {
			return err;
		}
	},

	GetUserHWInfo : function(option, pem)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.GetUserHWInfo(option, pem);
		} catch (err) {
			return err;
		}
	},

	BlockXMLDec : function(xaddr, cipher)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.BlockXMLDec(xaddr, cipher);
		} catch (err) {
			return err;
		}
	},

	GetXid : function(mode)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.GetXid(mode);
		} catch (err) {
			return err;
		}
	},

	VerifyData : function(signedData)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.VerifyData(signedData);
		} catch (err) {
			return err;
		}
	},

	GetCertInfo : function (signedData, opOpt, infoOpt)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.GetCertInfo (signedData, opOpt, infoOpt);
		} catch (err) {
			return err;
		}
	},

	GetCertInfoEx : function (signedData, orgData, opOpt, infoOpt, verifyOpt)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.GetCertInfoEx (signedData, orgData, opOpt, infoOpt, verifyOpt);
		} catch (err) {
			return err;
		}
	},

	GetCacheCertLocation : function (xgate_addr)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			return ccObj.GetCacheCertLocation (xgate_addr);
		} catch (err) {
			return err;
		}
	}
}

function PrintObjectTag ()
{
	var aBrowser	= gXWBrowser.mBrowser;
	var aPlatForm	= gXWBrowser.mPlatform;
	var aVersion	= null;
	var aObjectTag	= null;
	var aResult		= false;

	if (aBrowser == gXWBrowser.cMSIE)
	{
		aResult = true;
	}
	
	else if (aBrowser == gXWBrowser.cANDROID)
	{
		aVersion = XWAndroidCtrl.mAndroidVersion;
		gXWBrowser.mBrowserCtrl = XWAndroidCtrl;
	}
	
	else if (aBrowser == gXWBrowser.cFIREFOX)
	{
gXWBrowser.mBrowserCtrl = XWFirefoxCtrl;
		if (aPlatForm.indexOf (gXWBrowser.cWIN) != -1)
			aVersion = XWFirefoxCtrl.mWinVersion;
		else if (aPlatForm.indexOf (gXWBrowser.cLINUX) != -1)
		{
			if (aPlatForm == gXWBrowser.cLINUX64)
			{
				if (parseInt (gXWBrowser.mVersion.substring (0, 1)) < 4)
				{
					aVersion = XWFirefoxCtrl.mVer_linux_64_30;
				}
				else if (parseInt (gXWBrowser.mVersion.substring (0, 1)) < 6)
				{
					aVersion = XWFirefoxCtrl.mVer_linux_64_50;
				}
				else if (parseInt (gXWBrowser.mVersion.substring (0, 1)) < 7)
				{
					aVersion = XWFirefoxCtrl.mVer_linux_64_60;
				}
				else if (parseInt (gXWBrowser.mVersion.substring (0, 1)) < 8)
				{
					aVersion = XWFirefoxCtrl.mVer_linux_64_70;
				}
				else
				{
					aVersion = XWFirefoxCtrl.mVer_linux_64_80;
				}
			}
			else
			{
				if (parseInt (gXWBrowser.mVersion.substring (0, 1)) < 4)
				{
					aVersion = XWFirefoxCtrl.mVer_linux_32_30;
				}
				else if (parseInt (gXWBrowser.mVersion.substring (0, 1)) < 6)
				{
					aVersion = XWFirefoxCtrl.mVer_linux_32_50;
				}
				else if (parseInt (gXWBrowser.mVersion.substring (0, 1)) < 7)
				{
					aVersion = XWFirefoxCtrl.mVer_linux_32_60;
				}
				else if (parseInt (gXWBrowser.mVersion.substring (0, 1)) < 8)
				{
					aVersion = XWFirefoxCtrl.mVer_linux_32_70;
				}
				else
				{
					aVersion = XWFirefoxCtrl.mVer_linux_32_80;
				}
			}
		}
		else if (aPlatForm.indexOf (gXWBrowser.cMAC) != -1)
		{
			if (aPlatForm == gXWBrowser.cMACINTEL)
			{
				if (parseInt (gXWBrowser.mVersion.substring (0, 1)) < 4)
				{
					aVersion = XWFirefoxCtrl.mVer_mac_32_30;
				}
				else if (parseInt (gXWBrowser.mVersion.substring (0, 1)) < 6)
				{
					aVersion = XWFirefoxCtrl.mVer_mac_intel_50;
				}
				else if (parseInt (gXWBrowser.mVersion.substring (0, 1)) < 7)
				{
					aVersion = XWFirefoxCtrl.mVer_mac_intel_60;
				}
				else if (parseInt (gXWBrowser.mVersion.substring (0, 1)) < 8)
				{
					aVersion = XWFirefoxCtrl.mVer_mac_intel_70;
				}
				else
				{
					aVersion = XWFirefoxCtrl.mVer_mac_intel_80;
				}
			}
			else
			{
				aVersion = XWFirefoxCtrl.mVer_mac_ppc_30;
			}
		}
	}
	else if (aBrowser == gXWBrowser.cCHROME)
	{
		if (aPlatForm.indexOf (gXWBrowser.cWIN) != -1)
			aVersion = XWChromeCtrl.mWinVersion;
	}

	else if (aBrowser == gXWBrowser.cSAFARI)
	{
		if (aPlatForm.indexOf (gXWBrowser.cWIN) != -1)
			aVersion = XWSafariCtrl.mWinVersion;
		else if (aPlatForm.indexOf (gXWBrowser.cLINUX) != -1)
			aVersion = XWSafariCtrl.mLinuxVersion;
		else if (aPlatForm.indexOf (gXWBrowser.cMAC) != -1)
			aVersion = XWSafariCtrl.mMacVersion;
	}
	
	else if (aBrowser == gXWBrowser.cXECUREWEBIPHONE)
	{
		if (aPlatForm.indexOf (gXWBrowser.cMACIPOD) != -1)
			aVersion = XWIphoneCtrl.mMacVersion;
		else if (aPlatForm.indexOf (gXWBrowser.cMACIPHONE) != -1)
			aVersion = XWIphoneCtrl.mMacVersion;
		else if (aPlatForm.indexOf (gXWBrowser.cMACIPHONESIMULATOR) != -1)
			aVersion = XWIphoneCtrl.mMacVersion;
	}
	
	else if (aBrowser == gXWBrowser.cOPERA)
	{
		if (aPlatForm.indexOf (gXWBrowser.cWIN) != -1)
			aVersion = XWOperaCtrl.mWinVersion;
		else if (aPlatForm.indexOf (gXWBrowser.cLINUX) != -1)
			aVersion = XWOperaCtrl.mLinuxVersion;
	}

	else if (aBrowser == gXWBrowser.cNETSCAPE)
	{
		if (aPlatForm.indexOf (gXWBrowser.cWIN) != -1)
			aVersion = XWNetscapeCtrl.mWinVersion;
		else if (aPlatForm.indexOf (gXWBrowser.cLINUX) != -1)
			aVersion = XWNetscapeCtrl.mLinuxVersion;
		else if (aPlatForm.indexOf (gXWBrowser.cMAC) != -1)
			aVersion = XWNetscapeCtrl.mMacVersion;
	}

	else if (aBrowser == gXWBrowser.cNETSCAPE4)
	{
		if (aPlatForm.indexOf (gXWBrowser.cWIN) != -1)
			aVersion = XWNetscapeCtrl4.mWinVersion;
		else if (aPlatForm.indexOf (gXWBrowser.cLINUX) != -1)
			aVersion = XWNetscapeCtrl4.mLinuxVersion;
		else if (aPlatForm.indexOf (gXWBrowser.cMAC) != -1)
			aVersion = XWNetscapeCtrl4.mMacVersion;
	}

	else
	{
		aVersion = null;
	}

	if (aResult == false && aVersion == null)
	{
		alert ("XecureWeb�� �� ������ " + aBrowser + "�� �������� �ʽ��ϴ�.");
		return false;
	}

	
	if (gXWBrowser.checkCtrl (aVersion))
	{
		gXWBrowser.installCtrl();
		aResult = false;
	}
	else
		aResult = true;

	

	if (aResult)
	{
		aObjectTag = gXWBrowser.getObjectTag(0);
		
		if ((gXWBrowser.mBrowser == gXWBrowser.cFIREFOX && gXWBrowser.mVersion.substr (0, 3).replace (".", "") >= 36) &&
			(aPlatForm.indexOf (gXWBrowser.cLINUX) != -1 || aPlatForm.indexOf (gXWBrowser.cMAC) != -1))
		{
			/********************************************************************
			 * Routine for Accessing to XPCOM component by XPCONNECT
			 ********************************************************************/
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			var cid = "@softforum.com/xecurewebclient/service;1";
			var ccInterface = Components.interfaces.nsIXWClientComponent;
			ccObj = Components.classes[cid].getService().QueryInterface(ccInterface);

			document.XecureWeb = XWClientComponent;
			document.XecureWeb.SetAttribute ("license", XWFirefoxCtrl.mLicense);
			document.XecureWeb.SetAttribute ("storage", XWFirefoxCtrl.mStorage);
			document.XecureWeb.SetAttribute ("sec_option", XWFirefoxCtrl.mSecOption);
			document.XecureWeb.SetAttribute ("seckey", XWFirefoxCtrl.mSecKey);
			document.XecureWeb.SetAttribute ("sec_context", XWFirefoxCtrl.mSecContext);
		}
		else
		{
			document.write (aObjectTag);
		}
		
	}

	// IE9 is 5.0 ie6~ie8(4.0)
	if(navigator.appName == 'Microsoft Internet Explorer')
	{
		if(navigator.appVersion.substr(0,1) >= 5)	
		{
			
			document.XecureWeb = document.getElementById ("XecureWebClient");			
		}
	}

	if (document.XecureWeb == undefined)
	{
		document.XecureWeb = document.getElementById ("XecureWebClient");
	}	
	
	return aResult;
}

/* Warmstar Add End */

var agt=navigator.userAgent.toLowerCase();
var is_gecko = (agt.indexOf('gecko') != -1);
var is_linux = (agt.indexOf('linux') != -1);

//////////////////////////////////////////////////////////////////////////////////
//	Xecure �Լ���....
function UserAgent()
{
	return navigator.userAgent.substring(0,9);
}

function IsNetscape()			// by Zhang
{
	if(navigator.appName == 'Netscape')
		return true ;
	else
		return false ;
}

function IsNetscape60()			// by Zhang
{
	if (is_gecko) return false;
	else if(IsNetscape() && UserAgent() == 'Mozilla/5')
		return true ;
	else
		return false ;
}

function IsOpera ()                               
{                                                 
	if (gXWBrowser.mBrowser == gXWBrowser.cOPERA) 
	{                                             
		/* OPERA */                               
		return 1;                                 
	}                                             
	/* Not OPERA */                               
	return 0;                                     
}                                                 

function IsSafari()
{
	if (gXWBrowser.mBrowser == gXWBrowser.cSafari)
	{
		/* SAFARI */
		return 1;
	}
	/* Not safari */
	return 0;
}

function XecureUnescape(Msg)		// by Zhang
{
	if(                                
			(IsNetscape() && !is_gecko)
			||                         
			true == IsOpera ()         
	  )                          
		return unescape(Msg) ;
	else
		return Msg ;
}

function XecureEscape(Msg)		// by Zhang
{
	if(IsNetscape() && !is_gecko)
		return escape(Msg) ;
	else
		return Msg ;
}

function XecurePath(xpath)		// by zhang
{
	if(IsNetscape())
		return (xpath) ;
	else if (IsOpera())
		return (xpath);
	else
		return ("/" + xpath) ;		
}

function XecureAddQuery(qs)
{
	if(qs == "")	
		return "" ;
	else
		return "&" + qs ;
}

function XecureWebError()		// by zhang
{
	var errCode = 0 ;
	var errMsg = "" ;
	
	if( IsNetscape60() )		// Netscape 6.0
	{
		errCode = document.XecureWeb.nsIXecurePluginInstance.LastErrCode();
		errMsg  = document.XecureWeb.nsIXecurePluginInstance.LastErrMsg();
	}
	else
	{
		errCode = document.XecureWeb.LastErrCode();
		errMsg  = document.XecureWeb.LastErrMsg();
	}
	
	if(errCode == -144)
	{
		if(confirm("�����ڵ� : " + errCode + "\n\n" + XecureUnescape(errMsg) + "\n\n ����������â�� ���ڽ��ϱ�?"))
			ShowCertManager() ;
	}
	else
	{

		alert( "�����ڵ� : " + errCode + "\n\n" + XecureUnescape(errMsg) );
	}
	
	return false;
}

function escape_url(url) {
	var i;
	var ch;
	var out = '';
	var url_string = '';

	url_string = String(url);

	for (i = 0; i < url_string.length; i++) {
		ch = url_string.charAt(i);
		if (ch == ' ')		out += '%20';
		else if (ch == '%')	out += '%25';
		else if (ch == '&')	out += '%26';
		else if (ch == '+')	out += '%2B';
		else if (ch == '=')	out += '%3D';
		else if (ch == '?') out += '%3F';
		else				out += ch;
	}
	return out;
}

function ran_gen()
{
	var maxnumbers = "999999";
	var r = Math.round(Math.random() * (maxnumbers-1))+1+"";

	for(var i=0; i < 6-r.length; i++)
		r = "0" + r;
	
	return r;
}

function XecureNavigate_NoEnc( url, target )
{
	var qs ;
	var path = "/";
	var sid;
	var xecure_url;

	// get path info & query string & hash from url
	qs_begin_index = url.indexOf('?');
	path = getPath(url)

	// get query string action url
	if ( qs_begin_index < 0 ) {
		qs = "";
	}
	else {
		qs = url.substring(qs_begin_index + 1, url.length );
	}

	if( gIsContinue == 0 ) {
		gIsContinue = 1;
		if( IsNetscape60() )		// Netscape 6.0
			sid = document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr, path, "", "GET");
		else
			sid = document.XecureWeb.BlockEnc ( xgate_addr, path, "", "GET" );
		gIsContinue = 0;
	}
	else {
		return false ;
	}

	if( sid == "")	return XecureWebError();

	xecure_url = path + "?q=" + sid + XecureAddQuery(qs);
	// adding character set information

	alert ("XecureNavigate_NoEnc:query=" + xecure_url);

	open ( xecure_url, target );

	return true;
}

function XecureNavigate( url, target, feature )
{
	var qs ;
	var path = "/";
	var cipher;
	var xecure_url;

	// get path info & query string & hash from url
	qs_begin_index = url.indexOf('?');
	path = getPath(url)
	// get query string action url
	if ( qs_begin_index < 0 ) {
		qs = "";
	}
	else {
		qs = url.substring(qs_begin_index + 1, url.length );
	}
	
	if( gIsContinue == 0 ) {
		gIsContinue = 1;
		if( IsNetscape60() )		// Netscape 6.0
			cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr, path, XecureEscape(qs), "GET");
		else 
			cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
		gIsContinue = 0;
	}
	else {
		return false;
	}
			
	if( cipher == "" )	return XecureWebError();
	
	xecure_url = path + "?q=" + escape_url(cipher);
	// adding character set information
	//alert ("XecureNavigate:" + url + "\nquery=" + xecure_url);

	if (feature=="" || feature==null) open ( xecure_url, target );
	else open(xecure_url, target, feature );

	return true;
}

/**
 * @since XecureWeb 6.0 v220
 */
function XecureNavigate_Env( url, target, feature )
{
	var qs ;
	var path = "/";
	var cipher;
	var xecure_url;
	
	// get path info & query string & hash from url
	qs_begin_index = url.indexOf('?');
	path = getPath(url)
	// get query string action url
	if ( qs_begin_index < 0 ) {
		qs = "";
	}
	else {
		qs = url.substring(qs_begin_index + 1, url.length );
	}
	
	if( gIsContinue == 0 ) {
		gIsContinue = 1;
		//cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs), "GET");
		cipher = EnvelopData(XecureEscape(qs), "", serverCert, 1);
		gIsContinue = 0;
	}
	else {
		return false;
	}
			
	if( cipher == "" )	return XecureWebError();
	
	//xecure_url = path + "?q=" + escape_url(cipher);
	xecure_url = path + "?eq=" + escape_url(cipher);

	// adding character set information

	if (feature=="" || feature==null) {
		open ( xecure_url, target );
	}
	else {
		open(xecure_url, target, feature );
	}

	return true;
}


function XecureLink( link )
{

	PutMPhoneData();
	var qs ;
	var cipher;

	qs = link.search;
	if ( qs.length > 1 ) {
		qs = link.search.substring(1);
	}

	hash = link.hash;
	
	
	if( gIsContinue == 0 ) {
		path = XecurePath(link.pathname) ;
		gIsContinue = 1;

		if(IsSafari())
		{
			cipher = document.embeds["XecureWeb"].BlockEnc (xgate_addr, path, XecureEscape(qs),"GET");

			if ( hash.length == 1 )
			{
				/* Safari set the '#' as location.hash
				   But another broswer doen't set any value when the location doesn't have any hash
				   So it should be erased
				   */
				hash ="";
			}
		}
		else if( IsNetscape60() )		// Netscape 6.0
		{
			cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr, path, XecureEscape(qs), "GET");
		}
		else 
		{
			//alert("xgate_addr = "+xgate_addr);
			//alert("path = "+path);
			//alert("qs = "+qs);
			//alert("XecureEscape(qs) = "+XecureEscape(qs));
			//alert("accept_cert = "+accept_cert);
			cipher = document.XecureWeb.BlockEncEx(xgate_addr, path, XecureEscape(qs),"GET",accept_cert);
		}
		gIsContinue = 0;
	}
	else {
		return false;
	}

		
	if( cipher.length == 0)	
	{
		return XecureWebError() ;
	}

	if( IsSafari() )
	{
		xecure_url = "http://" + link.hostname + path + hash + "?q=" + escape_url(cipher);
	}
	else
	{
		xecure_url = "http://" + link.host + path + hash + "?q=" + escape_url(cipher);
		xecure_url = path + hash + "?q=" + escape_url(cipher);
	}

	// xecure_url = path + hash + "?q=" + escape_url(cipher);

	if(usePageCharset) {
	}
	

	if ( link.target == "" || link.target == null ) open ( xecure_url, "_self" );
	else open( xecure_url, link.target );
	return false;
}

function XecureLink_cloud( link )
{

	PutMPhoneData();
	var qs ;
	var cipher;
	//var CurrentCertLocation = "";

	qs = link.search;
	if ( qs.length > 1 ) {
		qs = link.search.substring(1);
	}

	hash = link.hash;
	
	//CurrentCertLocation = document.XecureWeb.CertLocation;

	document.XecureWeb.CertLocation = "hard,pkcs11,removable,csp,USBTOKEN_KIUP,iccard,NO_SMARTON,MPHONE,MOBISIGN,CLOUDSIGN";
	
	if( gIsContinue == 0 ) {
		path = XecurePath(link.pathname) ;
		gIsContinue = 1;

		if(IsSafari())
		{
			cipher = document.embeds["XecureWeb"].BlockEnc (xgate_addr, path, XecureEscape(qs),"GET");

			if ( hash.length == 1 )
			{
				/* Safari set the '#' as location.hash
				   But another broswer doen't set any value when the location doesn't have any hash
				   So it should be erased
				   */
				hash ="";
			}
		}
		else if( IsNetscape60() )		// Netscape 6.0
		{
			cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr, path, XecureEscape(qs), "GET");
		}
		else 
		{
			//alert("xgate_addr = "+xgate_addr);
			//alert("path = "+path);
			//alert("qs = "+qs);
			//alert("XecureEscape(qs) = "+XecureEscape(qs));
			//alert("accept_cert = "+accept_cert);
			cipher = document.XecureWeb.BlockEncEx(xgate_addr, path, XecureEscape(qs),"GET",accept_cert);
		}
		gIsContinue = 0;
	}
	else {
		//document.XecureWeb.CertLocation = "";
		//document.XecureWeb.CertLocation = CurrentCertLocation;
		return false;
	}

		
	if( cipher.length == 0)	
	{
		//document.XecureWeb.CertLocation = "";
		//document.XecureWeb.CertLocation = CurrentCertLocation;
		return XecureWebError() ;
	}

	if( IsSafari() )
	{
		xecure_url = "http://" + link.hostname + path + hash + "?q=" + escape_url(cipher);
	}
	else
	{
		xecure_url = "http://" + link.host + path + hash + "?q=" + escape_url(cipher);
		xecure_url = path + hash + "?q=" + escape_url(cipher);
	}

	// xecure_url = path + hash + "?q=" + escape_url(cipher);

	if(usePageCharset) {
	}
	
	if ( link.target == "" || link.target == null ) open ( xecure_url, "_self" );
	else open( xecure_url, link.target );
	
	//document.XecureWeb.CertLocation = "";
	//document.XecureWeb.CertLocation = CurrentCertLocation;
		
	return false;
}

function XecureLink3 ( link )
{
	var qs ;
	var cipher;

	qs = link.search;
	if ( qs.length > 1 ) {
		qs = link.search.substring(1);
	}

	hash = link.hash;
	
	
	if( gIsContinue == 0 ) {
		path = XecurePath(link.pathname) ;
		gIsContinue = 1;

		if(IsSafari())
		{
			cipher = document.embeds["XecureWeb"].BlockEnc3 (xgate_addr, path, XecureEscape(qs),"GET", accept_cert);

			if ( hash.length == 1 )
			{
				/* Safari set the '#' as location.hash
				   But another broswer doen't set any value when the location doesn't have any hash
				   So it should be erased
				   */
				hash ="";
			}
		}
		else if( IsNetscape60() )		// Netscape 6.0
		{
			cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc3 (xgate_addr, path, XecureEscape(qs), "GET", accept_cert);
		}
		else 
		{
			cipher = document.XecureWeb.BlockEnc3 (xgate_addr, path, XecureEscape(qs),"GET", accept_cert);
		}
		gIsContinue = 0;
	}
	else {
		return false;
	}

	if( cipher.length == 0)	
	{
		return XecureWebError() ;
	}


	xecure_url = "http://";

	if( IsSafari() )
		xecure_url += link.hostname;
	else
		xecure_url += link.host;

	xecure_url += path + hash + "?aq=" + escape_url(cipher);

	if(usePageCharset) {
	}
	
	if ( link.target == "" || link.target == null ) open ( xecure_url, "_self" );
	else open( xecure_url, link.target );
	return false;
}

/**
 * @since XecureWeb 6.0 v220
 */
function XecureLink_Env( link )
{
	var qs ;
//	var path = "/";
	var cipher;


	// get path info & query string from action url 

	if ( link.protocol != "http:" ) {
		return true;
	}

	qs = link.search;
	if ( qs.length > 1 ) {
		qs = link.search.substring(1);
	}

	hash = link.hash;
	
	if( gIsContinue == 0 ) {
		path = XecurePath(link.pathname) ;
		gIsContinue = 1;
		//cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
		cipher = EnvelopData(XecureEscape(qs), "", serverCert, 1);
		gIsContinue = 0;
	}
	else {
		return false;
	}
	if( cipher.length == 0)	return XecureWebError() ;

	// link.search = "?q=" + escape_url(cipher);
	//xecure_url = "http://" + link.host + path + hash + "?q=" + escape_url(cipher);
	xecure_url = "http://" + link.host + path + hash + "?eq=" + escape_url(cipher);

	// adding character set information

	if ( link.target == "" || link.target == null ) open ( xecure_url, "_self" );
	else open( xecure_url, link.target );
	return false;
}

function XecureSubmit( form )
{
	var qs ;
	var path ;
	var cipher;

	qs_begin_index = form.action.indexOf('?');
	
	// if action is relative url, get base url from window location
	path = getPath(form.action)
	// get path info & query string & hash from action url
	if ( qs_begin_index < 0 ) {
		qs = "";
	}
	else {
		qs = form.action.substring(qs_begin_index + 1, form.action.length );
	}

	document.xecure.target = form.target;

	if ( form.method == "get" || form.method=="GET" ) {
		// collect input field values 
		//qs = XecureMakePlain( form );
		if(qs.length!=0)
			qs += "&"+XecureMakePlain( form );
		else
			qs = XecureMakePlain( form );

		// encrypt QueryString
		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			if( IsNetscape60() )		// Netscape 6.0
				cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");			
			else{
				cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
			}
			gIsContinue = 0;
		}
		else {
			return false;
		}
		
		if( cipher == "" )	return XecureWebError() ;
		
		xecure_url = path + "?q=" + escape_url(cipher);
		// adding character set information
		
		if ( form.target == "" || form.target == null ) open( xecure_url, "_self");
		else open ( xecure_url, form.target );
	}
	else {
		document.xecure.method = "post";

		// encrypt QueryString of action field
		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			if( IsNetscape60() )		// Netscape 6.0
				cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");			
			else {
				cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
				
			}
			gIsContinue = 0;
		}
		else {
			return false;
		}		

		if( cipher == "" )	{
			return XecureWebError() ;
		}

		document.xecure.action = path + "?q=" + escape_url(cipher);
		// adding character set information
		if(usePageCharset) {
		}

		posting_data = XecureMakePlain( form );

		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			if( IsNetscape60() )		// Netscape 6.0
				cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc ( xgate_addr, path, XecureEscape(posting_data), "POST" );
			else{
				cipher = document.XecureWeb.BlockEnc ( xgate_addr, path, XecureEscape(posting_data), "POST" );
			}
			gIsContinue = 0;
		}
		else {
			return false;
		}		
		
		if( cipher == "" )	return XecureWebError() ;
		
		document.xecure.p.value = cipher;
		document.xecure.submit();
	}
	return false;
}

/**
 * �̰� ���� �׽�Ʈ ������ ����Ʈ�� �������� �ƴ�!!
 */
function XecureSubmit2 ( form )
{
	var path ;
	var cipher;
	var sid;


	if(
			IsNetscape60()		// Netscape 6.0
			||
			(gXWBrowser.mBrowser == gXWBrowser.cFIREFOX && gXWBrowser.mPlatform == gXWBrowser.cWIN) /* Window firefox */
			)
	{
		sid = document.XecureWeb.nsIXecurePluginInstance.GetSID ( xgate_addr );
	}
	else{
		sid = document.XecureWeb.GetSID ( xgate_addr );
	}

	if (sid == null || sid.length == 0)
	{
		alert ("There is no session!!");
		return false;
	}

	// if action is relative url, get base url from window location
	path = getPath(form.action)
	document.xecure.target = form.target;

	if ( form.method == "get" || form.method=="GET" ) {
		alert ("GET method is not support in XecureSubmit2");
	}
	else {
		document.xecure.method = "post";
		document.xecure.action = path + "?q=" + sid;
		alert ("SID=" + sid);
		// adding character set information
		if(usePageCharset) {
		}
 
		posting_data = XecureMakePlain( form );

		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			if( IsNetscape60() )		// Netscape 6.0
				cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc ( xgate_addr, path, XecureEscape(posting_data), "POST" );
			else{
				cipher = document.XecureWeb.BlockEnc ( xgate_addr, path, XecureEscape(posting_data), "POST" );
			}
			gIsContinue = 0;
		}
		else {
			return false;
		}		
		
		if( cipher == "" )	return XecureWebError() ;
		
		document.xecure.p.value = cipher;
		document.xecure.submit();
	}
	return false;
}

function XecureSubmit3 ( form )
{
	var qs ;
	var path ;
	var cipher;

	qs_begin_index = form.action.indexOf('?');
	
	// if action is relative url, get base url from window location
	path = getPath(form.action)
	// get path info & query string & hash from action url
	if ( qs_begin_index < 0 ) {
		qs = "";
	}
	else {
		qs = form.action.substring(qs_begin_index + 1, form.action.length );
	}
	document.xecure.target = form.target;

	if ( form.method == "get" || form.method=="GET" ) {
		// collect input field values 
		//qs = XecureMakePlain( form );
		if(qs.length!=0)
			qs += "&"+XecureMakePlain( form );
		else
			qs = XecureMakePlain( form );

		// encrypt QueryString
		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			if( IsNetscape60() )		// Netscape 6.0
				cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc3 (xgate_addr, path, XecureEscape(qs),"GET", accept_cert);
			else{
				cipher = document.XecureWeb.BlockEnc3 (xgate_addr, path, XecureEscape(qs),"GET", accept_cert);
			}
			gIsContinue = 0;
		}
		else {
			return false;
		}
		
		if( cipher == "" )	return XecureWebError() ;
		
		xecure_url = path + "?aq=" + escape_url(cipher);
		// adding character set information
		
		if ( form.target == "" || form.target == null ) open( xecure_url, "_self");
		else open ( xecure_url, form.target );
	}
	else {
		document.xecure.method = "post";

		// encrypt QueryString of action field
		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			if( IsNetscape60() )		// Netscape 6.0
				cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc3 (xgate_addr, path, XecureEscape(qs),"GET", accept_cert);
			else {
				cipher = document.XecureWeb.BlockEnc3 (xgate_addr, path, XecureEscape(qs),"GET", accept_cert);
				
			}
			gIsContinue = 0;
		}
		else {
			return false;
		}		


		if( cipher == "" )	return XecureWebError() ;

		document.xecure.action = path + "?aq=" + escape_url(cipher);
		// adding character set information
		if(usePageCharset) {
		}

		posting_data = XecureMakePlain( form );

		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			if( IsNetscape60() )		// Netscape 6.0
				cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc3 ( xgate_addr, path, XecureEscape(posting_data), "POST", accept_cert );
			else{
				cipher = document.XecureWeb.BlockEnc3 ( xgate_addr, path, XecureEscape(posting_data), "POST", accept_cert);
			}
			gIsContinue = 0;
		}
		else {
			return false;
		}		
		
		if( cipher == "" )	return XecureWebError() ;
		
		document.xecure.ap.value = cipher;
		document.xecure.submit();
	}
	return false;
}

/**
 * @since XecureWeb 6.0 v220
 */
function XecureSubmit_Env( form )
{
	var qs ;
	var path ;
	var cipher;

	qs_begin_index = form.action.indexOf('?');
	
	// if action is relative url, get base url from window location
	path = getPath(form.action)
	// get path info & query string & hash from action url
	if ( qs_begin_index < 0 ) {
		qs = "";
	}
	else {
		qs = form.action.substring(qs_begin_index + 1, form.action.length );
	}
	document.xecure.target = form.target;
	
	if ( form.method == "get" || form.method=="GET" ) {
		// collect input field values 
		if(qs.length!=0)
			qs += "&"+XecureMakePlain( form );
		else
			qs = XecureMakePlain( form );
		
		// encrypt QueryString
		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			//cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
			cipher = EnvelopData(XecureEscape(qs), "", serverCert, 1);
			gIsContinue = 0;
		}
		else {
			return false;
		}
		
		if( cipher == "" )	return XecureWebError() ;
		
		xecure_url = path + "?eq=" + escape_url(cipher);
		
		// adding character set information

		if ( form.target == "" || form.target == null ) open( xecure_url, "_self");
		else open ( xecure_url, form.target );
	}
	else {
		document.xecure.method = "post";

		// encrypt QueryString of action field
		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			//cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
			cipher = EnvelopData(XecureEscape(qs), "", serverCert, 1);
			gIsContinue = 0;
		}
		else {
			return false;
		}		


		if( cipher == "" )	return XecureWebError() ;

		document.xecure.action = path + "?eq=" + escape_url(cipher);
		// adding character set information

		posting_data = XecureMakePlain( form );

		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			//cipher = document.XecureWeb.BlockEnc ( xgate_addr, path, XecureEscape(posting_data), "POST" );
			cipher = EnvelopData(XecureEscape(posting_data), "", serverCert, 1);
			gIsContinue = 0;
		}
		else {
			return false;
		}				
				
		if( cipher == "" )	return XecureWebError() ;
		
		//document.xecure.p.value = cipher;
		document.xecure.ep.value = cipher;
		document.xecure.submit();
	}
	return false;
}

function XecureMakePlain(form)
{
	var name = new Array(form.elements.length); 
	var value = new Array(form.elements.length); 
	var flag = false;
	var j = 0;
	var plain_text="";
	var len = 0;
	var enable=false;//for softcamp

	//for softcamp
/*
	if(document.secukey==null || typeof(document.secukey) == "undefined" || document.secukey.object==null) {
		enable=false;
	}
	else {
		enable=secukey.GetSecuKeyEnable();
	}
*/

	if(document.CKKeyPro==null || typeof(document.CKKeyPro) == "undefined" || document.CKKeyPro.object==null) {
		enable=false;
	}
	else {
		enable= true;
	}

	len = form.elements.length; 
	for (i = 0; i < len; i++) {
		if ((form.elements[i].type != "button")
				 && (form.elements[i].type != "reset")
				 && (form.elements[i].type != "submit"))
		{
			if (form.elements[i].type == "radio" 
			 		|| form.elements[i].type == "checkbox")
			 	{ // Leejh 99.11.10 checkbox�߰�
					if (form.elements[i].checked == true) {
						name[j] = form.elements[i].name; 
						value[j] = form.elements[i].value;
						j++;
					}
		 		}
/*
			//for softcamp
			else if(enable && form.elements[i].type == "password"){
				if(form.elements[i].type == "password"){
					name[j] = form.elements[i].name;
					value[j] = secukey.GetRealPass(form.elements[i].name,form.elements[i].value);
					j++;
				}
			}
*/
// for E2E
			else if(enable){
				if(form.elements[i].getAttribute("enc") != "on") 
				{						
						name[j] 	= form.elements[i].name;
						value[j]  = form.elements[i].value;
				}
				else
				{
					  if(document.CKKeyPro.E2EMode == '4')		// E2E = '4'	
							name[j]   =  "xw" + form.elements[i].name;
						else																		// Ȯ��E2E = '32'
							name[j]   =  "xk" + form.elements[i].name;
						
						version 	= document.XecureWeb.GetVerInfo(0);
						
						if(version >= '7, 2, 1, 7')
						{
							if(form.elements[i].type == "hidden")
							{
								value[j] = form.elements[i].value;
							}
							else
							{
								enc_xgate = document.XecureWeb.GetEncUserData(xgate_addr);
								value[j]  = document.CKKeyPro.GetEncData(enc_xgate,form.name,form.elements[i].name);
							}
						}	
						else
						{								 
							value[j]  = document.CKKeyPro.GetEncData(xgate_addr,form.name,form.elements[i].name);
						}
				}					
				j++;
			}
// E2E End	 (Add jjw)			
			else {
				name[j] = form.elements[i].name; 
				if (form.elements[i].type == "select-one") {
					var ind = form.elements[i].selectedIndex;
					if (form.elements[i].options[ind].value != '')
						value[j] = form.elements[i].options[ind].value;
					else
						value[j] = form.elements[i].options[ind].text;
					// form.elements[i].selectedIndex = 0;
				}
				else {
					value[j] = form.elements[i].value;
				}
				j++;
			}
		}
	}
	for (i = 0; i < j; i++) {
		str = value[i]; 
		value[i] = escape_url(str); 
	}

	for (i = 0; i < j; i++) {
		if (flag)
			plain_text += "&";
		else
			flag = true;
		plain_text += name[i] ;
		plain_text += "=";
		plain_text += value[i];
	}

	return plain_text;
}

/*************For Applet**********************/
function BlockEnc(auth_type,plain_text)
{	
	var cipher = "";
	if( IsNetscape60() )		// Netscape 6.0
		cipher =  XecureUnescape(document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr,auth_type,plain_text,"GET"));
	else
		cipher =  XecureUnescape(document.XecureWeb.BlockEnc(xgate_addr,auth_type,plain_text,"GET"));		
		
	if( cipher == "" ) XecureWebError() ;
	
	return cipher;
}

function BlockEncPost(auth_type,plain_text, request_type)
{	
	var cipher = "";
	if( IsNetscape60() )		// Netscape 6.0
		cipher =  XecureUnescape(document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr,auth_type,plain_text,request_type));
	else
		cipher =  XecureUnescape(document.XecureWeb.BlockEnc(xgate_addr,auth_type,plain_text,request_type));		
		
	if( cipher == "" ) XecureWebError() ;
	
	return cipher;
}

function BlockDec(cipher)
{
	var plain = "";

	try
	{

	if( IsNetscape60() )		// Netscape 6.0
		plain = XecureUnescape(document.XecureWeb.nsIXecurePluginInstance.BlockDec( xgate_addr, cipher));
	else {
		plain = XecureUnescape(document.XecureWeb.BlockDec( xgate_addr, cipher));
	}

	}
	catch (aException)
	{
		alert (aException + "\n\n\n\nXWObject=" + document.XecureWeb);
	}

	if( plain == "" ) XecureWebError() ;
	//else plain += "s=''";
		
	return plain;
}

function BlockXMLDec(cipher)
{
	var path = "";

	if( IsNetscape60() )		// Netscape 6.0
		path = XecureUnescape(document.XecureWeb.nsIXecurePluginInstance.BlockXMLDec( xgate_addr, cipher));	
	else
		path = XecureUnescape(document.XecureWeb.BlockXMLDec( xgate_addr, cipher));
	
	if( path == "" ) 	XecureWebError() ;
	
	return path;
}

function XecureLogIn( link )
{
	EndSession();
	return XecureLink(link);
}

function XecureLogIn3 (link)
{
	EndSession();

	if ( link.target == "" || link.target == null ) open ( link.href, "_self" );
	else open( link.href, link.target );
	return false;
}

function EndSession()
{
	if( IsNetscape60() )		// Netscape 6.0
		document.XecureWeb.nsIXecurePluginInstance.EndSession( xgate_addr );
	else
		document.XecureWeb.EndSession(xgate_addr);
}

// XecureWeb ver 4.1 add
// option : 0 : no confirm window, all certificates
// option : 1 : confirm window, all certificates
// option : 2 : no confirm window, log-on certificate only
// option : 3 : confirm window, log-on certificate only
// option : 4 : ������� ����.. USB ��ū���� ����(���� ����� �ݵ�� ����)
// option : 4194304(0x00400000) : �и�����

function Sign_with_option( option, plain )
{
			var signed_msg="";
		
			PutMPhoneData();

			//document.XecureWeb.ClearCache(xgate_addr,"192.168.70.199");
			// accept_cert = XecureEscape(accept_cert);
			if( IsNetscape60() )	// Netscape 6.0
			{
				signed_msg = document.XecureWeb.nsIXecurePluginInstance.SignDataCMS( xgate_addr,
									accept_cert, 
									escape(plain), 
									option, 
									escape(sign_desc),
									pwd_fail);
			}
			else
			{
					signed_msg = document.XecureWeb.SignDataCMS(
									xgate_addr,
									accept_cert, 
									XecureEscape(plain), 
									option, 
									XecureEscape(sign_desc),
									pwd_fail);
			}
			
			if( signed_msg == "" )	XecureWebError();
			
			//document.XecureWeb.ClearCache(xgate_addr,0);
			return signed_msg;

}

function Sign_with_option_cloud( option, plain )
{
			var signed_msg="";
			var CurrentCertLocation = "";
		
			PutMPhoneData();
			
			CurrentCertLocation = document.XecureWeb.CertLocation;
			
			document.XecureWeb.CertLocation = "hard,pkcs11,removable,csp,USBTOKEN_KIUP,iccard,NO_SMARTON,MPHONE,MOBISIGN,CLOUDSIGN";

			//document.XecureWeb.ClearCache(xgate_addr,"192.168.70.199");
			// accept_cert = XecureEscape(accept_cert);
			if( IsNetscape60() )	// Netscape 6.0
			{
				signed_msg = document.XecureWeb.nsIXecurePluginInstance.SignDataCMS( xgate_addr,
									accept_cert, 
									escape(plain), 
									option, 
									escape(sign_desc),
									pwd_fail);
			}
			else
			{
					signed_msg = document.XecureWeb.SignDataCMS(
									xgate_addr,
									accept_cert, 
									XecureEscape(plain), 
									option, 
									XecureEscape(sign_desc),
									pwd_fail);
			}
			
			if( signed_msg == "" )	XecureWebError();
			
			document.XecureWeb.CertLocation = "";
			document.XecureWeb.CertLocation = CurrentCertLocation;
			
			//document.XecureWeb.ClearCache(xgate_addr,0);
			return signed_msg;

}

//nOEM - 1:court default
//     - 2:no IC Card pin verify 
function Sign4Court( plain ,nOEM)
{
	var signed_msg;
	
	signed_msg = document.XecureWeb.SignDataCMS4OEM(
						nOEM,
						xgate_addr,
						XecureEscape(accept_cert), 
						XecureEscape(plain), 
						2, 
						XecureEscape(sign_desc),
						pwd_fail);						
	if( signed_msg == "" )	XecureWebError() ;
	
	return signed_msg;
}  
function Sign_Add( option, plain )
{
	var signed_msg;

	signed_msg = document.XecureWeb.SignDataAdd ( xgate_addr, accept_cert, plain, option, sign_desc, pwd_fail );

    if( signed_msg == "" )	XecureWebError() ;

    return signed_msg;
}

// [2006/08/03]
// option : 1048576(0x00100000): GetCacheCertLocation ���� ����Ǿ��� �������� Location�� ��ȯ��
function Sign( plain )
{
	var signed_msg;
	
	if( IsNetscape60() )		// Netscape 6.0
	{
		signed_msg = document.XecureWeb.nsIXecurePluginInstance.SignDataCMS( xgate_addr, XecureEscape(accept_cert), XecureEscape(plain), show_plain, XecureEscape(sign_desc) );
	}
	else
	{
		signed_msg = document.XecureWeb.SignDataCMS( xgate_addr, XecureEscape(accept_cert), XecureEscape(plain), show_plain, XecureEscape(sign_desc), 3 );
	}
	
	if( signed_msg == "" )	XecureWebError() ;
	
	return signed_msg;
}

function Sign_with_desc( plain, desc )
{
	var signed_msg;

	if( IsNetscape60() )		// Netscape 6.0
		signed_msg = document.XecureWeb.nsIXecurePluginInstance.SignDataCMS( xgate_addr, XecureEscape(accept_cert), XecureEscape(plain), show_plain, XecureEscape(desc) );
	else
		signed_msg = document.XecureWeb.SignDataCSM( xgate_addr, XecureEscape(accept_cert), XecureEscape(plain), show_plain, XecureEscape(desc) );
		
	if( signed_msg == "" )	XecureWebError() ;
	
	return signed_msg;
}

// XecureWeb ver 4.1 add
// option : 0 : no confirm window, all certificates
// option : 1 : confirm window, all certificates
// option : 2 : no confirm window, log-on certificate only
// option : 3 : confirm window, log-on certificate only

// XecureWeb ver 5.0 add
function Sign_with_vid_oem( option, plain, svrCert )
{
	var signed_msg;

	option = option + 4;
	
	if(IsNetscape())
	{
		alert("Not supported function [Sign_with_vid_oem]");
	}
	else {
		signed_msg = document.XecureWeb.SignDataWithVID4OEM (1, xgate_addr, accept_cert, plain, svrCert, option, sign_desc, pwd_fail );
	}

    if( signed_msg == "" )	XecureWebError();

    return signed_msg;
}

function Sign_with_vid_user( option, plain, svrCert )
{
	var signed_msg;

	option = option + 4;

	Set_ID_Num("");
	
	if(IsNetscape() && is_gecko == false )
	{
		alert("Not supported function [Sign_with_vid_user]");
	}
	else if(is_gecko)
	{
		signed_msg = document.XecureWeb.SignDataWithVID ( xgate_addr, accept_cert, plain, svrCert, option, sign_desc, pwd_fail );
	}
	else {
		signed_msg = document.XecureWeb.SignDataWithVID ( xgate_addr, accept_cert, plain, svrCert, option, sign_desc, pwd_fail );
		//signed_msg = document.XecureWeb.SignDataWithVID ( xgate_addr, accept_cert, plain, s, option, sign_desc, pwd_fail );
	}

    if( signed_msg == "" )	XecureWebError();

    return signed_msg;
}

function Sign_with_vid_web( option, plain, svrCert, idn )
{
	var ret;
	var signed_msg;

	option = option + 12;
	
	if(IsNetscape() && is_gecko == false)
	{
		alert("Not supported function [Sign_with_vid_web]");
	}
	else {
		ret = Set_ID_Num(idn);
		if(ret != 0) {
			XecureWebError();
			return signed_msg;
		}
			
		signed_msg = document.XecureWeb.SignDataWithVID ( xgate_addr, accept_cert, plain, svrCert, option, sign_desc, pwd_fail );
	}

    if( signed_msg == "" )	XecureWebError();

    return signed_msg;
}

// only over XecureWeb Client v5.3.0.1
// [certLocation]
// 	0 : HARD
//	1 : REMOVABLE
//	2 : ICCARD
//	3 : CSP
//	4 : VSC
// [option]
//	0 : ������� Ȯ��â ����
//	1 : ������� Ȯ��â ���
function Sign_with_vid_user_serial( certSerial, certLocation, option, plain, svrCert )
{
	var signed_msg;

	option = option + 4;
	
	if(IsNetscape())
	{
		alert("Not supported function [Sign_with_vid_user_serail]");
	}
	else {
		signed_msg = document.XecureWeb.SignDataWithVID_Serial ( xgate_addr, accept_cert, certSerial, certLocation, plain, svrCert, option, sign_desc, pwd_fail );
	}

    if( signed_msg == "" )	XecureWebError();

    return signed_msg;
}

// only over XecureWeb Client v5.3.0.1
// [certLocation]
// 	0 : HARD
//	1 : REMOVABLE
//	2 : ICCARD
//	3 : CSP
//	4 : VSC
// [option]
//	0 : ������� Ȯ��â ����
//	1 : ������� Ȯ��â ���
function Sign_with_vid_web_serial( certSerial, certLocation, option, plain, svrCert, idn )
{
	var ret;
	var signed_msg;

	option = option + 12;
	
	if(IsNetscape())
	{
		alert("Not supported function [Sign_with_vid_web_serial]");
	}
	else {
		ret = Set_ID_Num(idn);
		if(ret != 0) {
			XecureWebError();
			return signed_msg;
		}
			
		signed_msg = document.XecureWeb.SignDataWithVID_Serial ( xgate_addr, accept_cert, certSerial, certLocation, plain, svrCert, option, sign_desc, pwd_fail );
	}

    if( signed_msg == "" )	XecureWebError();

    return signed_msg;
}

function Set_ID_Num(idn)
{
	var ret;
	
	if( IsNetscape() && is_gecko == false )
	{
		alert("Not supported function [Set_ID_Num]");
	}
	else
	{
		ret = document.XecureWeb.SetIDNum(idn);
	}
	
	return ret;
}

function send_vid_info()
{
	var	vid_info;
	
	if( IsNetscape() && is_gecko == false )
	{
		alert("Not supported function [send_vid_info]");
	}
	else if( is_gecko )
	{
		vid_info = document.XecureWeb.GetVidInfo();
	}
	else
	{
		vid_info = document.XecureWeb.GetVidInfo();
	}

	if(vid_info.length == 0)
		return null;
	else
		return vid_info;
}

// only over XecureWeb Client v5.3.0.1
// [certLocation]
// 	0 : HARD
//	1 : REMOVABLE
//	2 : ICCARD
//	3 : CSP
//	4 : VSC
// [option]
//	0 : ������� Ȯ��â ����
//	1 : ������� Ȯ��â ���
function Sign_with_serial( certSerial, certLocation, plain, option )
{
	var	signed_msg;
	if( IsNetscape() )
	{
		alert("Not supported function [Sign_with_serial]");
	}
	else
	{
		signed_msg = document.XecureWeb.SignDataCMSWithSerial(  xgate_addr, 
									XecureEscape(accept_cert), 
									certSerial, 
									certLocation, 
									plain, 
									option, 
									XecureEscape(sign_desc),
									pwd_fail );
	}

	if( signed_msg == "" )	XecureWebError();

	return signed_msg;	
}

//
// only over XecureWeb Client v5.4.x
//
// !!! This function need site/executable license !!!
// 
// [option]
//      0 : only signature verification( NOT perform cert verification )
// 	1 : signature verification + default cert verification
//	2 : + cert chain check
//	3 : + CRL check
//	4 : + LDAP 
// [directoryServer]
//	ex) dirsys.rootca.or.kr:389 or ""
//
function Verify_SignedData( signedData, option, directoryServer )
{
	var	verified_msg;
	var	errCode;
	
	if( IsNetscape() && is_gecko == false )
	{
		alert("Not supported function [Verify_SignedData]");
		return "";
	}
	else
	{
		verified_msg = document.XecureWeb.VerifySignedData( signedData, option, directoryServer );
	}

	if(verified_msg == null)	alert("error : " + XecureWebError());
	else
		alert("--�����޽���--\n\n"+verified_msg);
	// VerifySignedData�� ������ ������ ������ �߻��ϴ��� ���� ������ �����ϸ� ������ �����ϱ� ������
	// �ݵ�� LastErrCode�� Ȯ���ؾ� �Ѵ�.
	errCode = document.XecureWeb.LastErrCode();
	if( errCode != 0 )
		XecureWebError();
	else
		alert("signed verify success");
			
	return verified_msg;	
}
// �⺻ �ɼ��� Verify_SignedData �� ����
// softforum �и������� ��� 256(0x00000100)
// MCURIX    �и������� ��� 512(0x00000200) �� ���ؼ� ���
function Verify_DetachedSignedData( signedData, orgData,option, directoryServer )
{
	var	verified_msg;
	var	errCode;
	var ret;
	
	if( IsNetscape() && is_gecko == false )
	{
		alert("Not supported function [Verify_SignedData]");
		return "";
	}
	else
	{
		ret = document.XecureWeb.VerifyDetachedSignedData( signedData, orgData,option, directoryServer );
	}

	if(ret < 0)
		alert("error : " + XecureWebError());
	else
		alert("signed verify success");
			
	return verified_msg;	
}

// VerifyPKCS1SignedData �Լ��� ���� ������� �޽����� ��ȯ��Ű�� ����. ���ϰ� ��ȯ�ϵ��� �ٲ�. verified_msg -> ret 
function Verify_PKCS1SignedData( signedData, orgData,cert,option, directoryServer )
{
	var	verified_msg;
	var	errCode;
	var	ret;
	
	if( IsNetscape() && is_gecko == false )
	{
		alert("Not supported function [Verify_SignedData]");
		return "";
	}
	else if( is_gecko )
	{
		verified_msg = document.XecureWeb.VerifySignedData( signedData, option, directoryServer );
		
		if(ret == null)	alert("error : " + XecureWebError());
		else
			alert("--�����޽���--\n\n"+verified_msg);
		// VerifySignedData�� ������ ������ ������ �߻��ϴ��� ���� ������ �����ϸ� ������ �����ϱ� ������
		// �ݵ�� LastErrCode�� Ȯ���ؾ� �Ѵ�.
		errCode = document.XecureWeb.LastErrCode();
		if( errCode != 0 )
			XecureWebError();
		else
			alert("signed verify success");
	}
	else
	{
		ret = document.XecureWeb.VerifyPKCS1SignedData( signedData, orgData,cert ,option, directoryServer );
		
			if(ret < 0)
			alert("error : " + XecureWebError());
		else
			alert("signed verify success");			
	}
		
	return verified_msg;	
}

//
// only over XecureWeb Client v5.4.x
//
// !!! This function need site/executable license !!!
// 
// [option]
//      0 : only signature verification( NOT perform cert verification )
// 	1 : signature verification + default cert verification
//	2 : + cert chain check
//	3 : + CRL check
//	4 : + LDAP 
// [directoryServer]
//	ex) dirsys.rootca.or.kr:389 or ""
//
function GetSignTime( signedData, option, directoryServer )
{
	var	signing_time;
	var	verified_msg;
	var	errCode;

///////////////////////////////////////////////////////////////////////////////////
// ���� ���� ���� �κ�
	if( IsNetscape() && is_gecko == false )
	{
		alert("Not supported function [Verify_SignedData]");
		return "";
	}
	else
	{
		verified_msg = document.XecureWeb.VerifySignedData( signedData, option, directoryServer );
	}

	if(verified_msg == null)
	{
		alert("error : " + XecureWebError());
		return "";
	}
	else
	{
		alert("--�����޽���--\n\n"+verified_msg);
		// VerifySignedData�� ������ ������ ������ �߻��ϴ��� ���� ������ �����ϸ� ������ �����ϱ� ������
		// �ݵ�� LastErrCode�� Ȯ���ؾ� �Ѵ�.
		errCode = document.XecureWeb.LastErrCode();
	}
	if( errCode != 0 )
	{
		XecureWebError();
		return "";
	}
	else
	{
		alert("signed verify success");	
	}
//////////////////////////////////////////////////////////////////////////////////////
	
	signing_time = document.XecureWeb.GetSignTime();
	
	if( signing_time == 0)
	{
		alert("fail get SignTime");
	}
	else		
	{
		alert("--���� �ð�--\n\n"+signing_time+"\n\n(yyyy/mm/dd/hh/mm/ss : ����Ͻú���)");
	}
			
	return signing_time;	
}

//
// only over XecureWeb Client v5.4.x
//
// applicable cert location : usbtoken_kb, usbtoken_kiup
//
function Set_PinNumber( pin )
{
	var	ret = -1;
	
	if( IsNetscape() )
	{
		alert("Not supported function [Set_PinNumber]");
	}
	else
	{
		 ret = document.XecureWeb.SetPinNum( pin );
	}

	return ret;
}

// type 10 : YessignCA
// type 11 : XecureCA
function RequestCertificate ( type, ref_code, auth_code )
{
	var r;
	var ca_type;
	var ca_ip;
	var ca_port;
	var mpki_ra_name;
	var mpki_ca_name;
	var aXWCMPInfo;


	aXWCMPInfo = GetCAInfo (type);
	if (aXWCMPInfo != null)
	{
		ca_type = aXWCMPInfo.getType ();
		ca_ip = aXWCMPInfo.getIP ();
		ca_port = aXWCMPInfo.getPort ();
		mpki_ca_name = aXWCMPInfo.getCAName ();
		mpki_ra_name = aXWCMPInfo.getRAName ();

		window.status = "CMP("+ aXWCMPInfo.getName () +"):" + ca_type + "\t" + ca_ip + "\t" + ca_port;

	}
	else {
		alert("Input type error!(" + type + ")");
		return 0;
	}

	PutMPhoneData();
	//alert("CMP("+ aXWCMPInfo.getName () +"):" + ca_type + "\t" + ca_ip + "\t" + ca_port);	
	if(IsNetscape())
	{
		if (IsSafari () != 0)
		{
			if(type==14)
			{
				r = document.XecureWeb.RequestCertificateEx(ca_port, ca_ip, ref_code, auth_code, ca_type, 2, mpki_ca_name, mpki_ra_name);
			}else{
				r = document.XecureWeb.RequestCertificateEx( ca_port, ca_ip, ref_code, auth_code, ca_type, 8192, "", "");
//			r = document.XecureWeb.RequestCertificate ( ca_port, ca_ip, ref_code, auth_code, ca_type);
			}
		}
		else if( IsNetscape60())	// Netscape 6.0
		{
			r = document.XecureWeb.nsIXecurePluginInstance.RequestCertificate2 ( ca_port, ca_ip, ref_code, auth_code, ca_type );
		}
		else
		{
			if(type==14){
				r = document.XecureWeb.RequestCertificateEx(ca_port, ca_ip, ref_code, auth_code, ca_type, 2, mpki_ca_name, mpki_ra_name);
			}else{
					r = document.XecureWeb.RequestCertificateEx( ca_port, ca_ip, ref_code, auth_code, ca_type, 8192,"", "");
//				r = document.XecureWeb.RequestCertificate ( ca_port, ca_ip, ref_code, auth_code, ca_type);				
			}
		}
	}
	else 
	{
		if(type==14){
			r = document.XecureWeb.RequestCertificateEx(ca_port, ca_ip, ref_code, auth_code, ca_type, 2, mpki_ca_name, mpki_ra_name);
		}else{
			r = document.XecureWeb.RequestCertificateEx( ca_port, ca_ip, ref_code, auth_code, ca_type, 8192, "", "");
//				r = document.XecureWeb.RequestCertificate ( ca_port, ca_ip, ref_code, auth_code, ca_type);
		}
		
	}

	if ( r != 0 )	XecureWebError();
	
	return r;
}

function RenewCertificate ( type )
{
	var r;
	var ca_type;
	var ca_ip;
	var ca_port;
	var aXWCMPInfo;

	PutMPhoneData();	
	aXWCMPInfo = GetCAInfo (type);
	if (aXWCMPInfo != null)
	{
		ca_type = aXWCMPInfo.getType ();
		ca_ip = aXWCMPInfo.getIP ();
		ca_port = aXWCMPInfo.getPort ();

		window.status = "CMP("+ aXWCMPInfo.getName () +"):" + ca_type + "\t" + ca_ip + "\t" + ca_port;

	}
	else {
		alert("Input type error!");
		return 0;
	}

	if(IsNetscape())
	{
		if( IsNetscape60() )	// Netscape 6.0
			r = document.XecureWeb.nsIXecurePluginInstance.RenewCertificate2( ca_port, ca_ip, ca_type, pwd_fail );
		else
			r = document.XecureWeb.RenewCertificate( ca_port, ca_ip, ca_type, pwd_fail );
	}
	else{
		r = document.XecureWeb.RenewCertificate ( ca_port, ca_ip, ca_type, pwd_fail );
	}

	if ( r != 0 ) 	XecureWebError();
	
	return r;
}

// type 00 : YessignCA
// type 11 : XecureCA
function RevokeCertificate ( type, jobcode, reason )
{
	var r;
	var ca_type;
	var ca_ip;
	var ca_port;

	var aXWCMPInfo;

	aXWCMPInfo = GetCAInfo (type);

	if (aXWCMPInfo != null)
	{
		ca_type = aXWCMPInfo.getType ();
		ca_ip = aXWCMPInfo.getIP ();
		ca_port = aXWCMPInfo.getPort ();

		window.status = "CMP("+ aXWCMPInfo.getName () +"):" + ca_type + "\t" + ca_ip + "\t" + ca_port;

	}
	else {
		alert("Input type error!");
		return 0;
	}
	
	if(IsNetscape() && !is_gecko)
	{
		if( IsNetscape60() )	// Netscape 6.0
			r = document.XecureWeb.nsIXecurePluginInstance.RevokeCertificate2( ca_port, ca_ip, jobcode, reason, ca_type, pwd_fail );
		else
			r = document.XecureWeb.RevokeCertificate2( ca_port, ca_ip, jobcode, reason, ca_type,  pwd_fail);
	}
	else {
		r = document.XecureWeb.RevokeCertificate ( ca_port, ca_ip, jobcode, reason, ca_type, pwd_fail );
	}

 if ( r != 0 ) 	XecureWebError();

	return r;
}

function GenCertReq ( )
{
	if( IsNetscape60() )		// Netscape 6.0
		cert_req = document.XecureWeb.nsIXecurePluginInstance.GenerateCertReq( 1024 );
	else
		cert_req = document.XecureWeb.GenerateCertReq( 1024 );

	if ( cert_req == "" )	XecureWebError() ;
	
	return cert_req;
}

function InstallCertificate (cert_type, cert)
{
	if( IsNetscape60() )		// Netscape 6.0
		document.XecureWeb.nsIXecurePluginInstance.InstallCertificate(cert_type, cert );
	else
		document.XecureWeb.InstallCertificate(cert_type, cert );
}

function ShowCertManager()
{
	if( IsNetscape60() )		// Netscape 6.0
		document.XecureWeb.nsIXecurePluginInstance.ShowCertManager();
	else
		document.XecureWeb.ShowCertManager();
}

function DeleteCertificate( dn )
{       
	var r; 
	
	if( IsNetscape60() )		// Netscape 6.0
		r = document.XecureWeb.nsIXecurePluginInstance.DeleteCertificate( XecureEscape(dn) );
	else
		r = document.XecureWeb.DeleteCertificate ( XecureEscape(dn) );

	if( r != 0 )	XecureWebError() ;
	else 		alert('�������� �����Ͽ����ϴ�.');
}

function PutBannerUrl()
{
	if( IsNetscape60() )		// Netscape 6.0
	{
		document.XecureWeb.nsIXecurePluginInstance.PutBigBannerUrl( xgate_addr, bannerUrl);
	}
	else
	{
		document.XecureWeb.PutBigBannerUrl( xgate_addr, bannerUrl);
	}
}

function PutBigBannerUrl(addr, url)
{
	if( IsNetscape60() )		// Netscape 6.0
	{
		document.XecureWeb.nsIXecurePluginInstance.PutBigBannerUrl( addr, url);
	}
	else
	{
		document.XecureWeb.PutBigBannerUrl( addr, url);
	}
}

function PutCertificate(type)
{
	//#define	PUT_CERT_TYPE_ROOT		0
	//#define	PUT_CERT_TYPE_CA		1
	//#define	PUT_CERT_TYPE_SERVER	2
	//#define	PUT_CERT_TYPE_USER		3
	//#define	PUT_CERT_TYPE_OTHER		4
	var r ;
	
	if( IsNetscape60() )		// Netscape 6.0
		r = document.XecureWeb.nsIXecurePluginInstance.PutCACert( XecureEscape(pCaCertName), pCaCertUrl, type);
	else
		r = document.XecureWeb.PutCertificate( XecureEscape(pCaCertName), pCaCertUrl, type);

	if( r != 0 )	XecureWebError() ;
}

function PutCACert()
{
	var r ;
	
	if( IsNetscape60() )		// Netscape 6.0
		r = document.XecureWeb.nsIXecurePluginInstance.PutCACert( XecureEscape(pCaCertName), pCaCertUrl);
	else
		r = document.XecureWeb.PutCACert( XecureEscape(pCaCertName), pCaCertUrl);

	if( r != 0 )	XecureWebError() ;
}

function get_sid() 
{
	var sid = document.XecureWeb.BlockEnc ( xgate_addr, "", "", "GET" );
        
	if( sid == "") 	return XecureWebError() ;
        
	return sid;
}

function XecureNavigate2iframe( url, target, feature, sid) 
{
	var qs ;
	var path = "/";
	var cipher;
	var xecure_url;

	path = getPath(url);
	
	cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"POST");
		
	if( cipher.length == 0 ) 	return XecureWebError() ;
	
	xecure_url = path + "?q=" + sid + ";" + escape_url(cipher);
	if (feature=="" || feature==null) open ( xecure_url, target );
	else open(xecure_url, target, feature );

	return true;
}

function getPath(url)
{
	var path = "/";
	// get path info & query string & hash from url
	qs_begin_index = url.indexOf('?');
	// if action is relative url, get base url from window location
	if ( url.charAt(0) != '/' && url.substring(0,7) != "http://" ) {
		path_end = window.location.href.indexOf('?');
		if(path_end < 0)	path_end_str = window.location.href;
		else				path_end_str = window.location.href.substring(0,path_end); 
		path_relative_base_end = path_end_str.lastIndexOf('/');
		path_relative_base_str = path_end_str.substring(0,path_relative_base_end+1);
		path_begin_index = path_relative_base_str.substring (7,path_relative_base_str.length).indexOf('/');
		if (qs_begin_index < 0){
			path = path_relative_base_str.substring( 7+path_begin_index,path_relative_base_str.length ) + url;
		}
		else {
			path = path_relative_base_str.substring( 7+path_begin_index,path_relative_base_str.length )
				 + url.substring(0, qs_begin_index );
		}
	}
	else if ( url.substring(0,7) == "http://" ) {
		path_begin_index = url.substring (7, url.length).indexOf('/');
		if (qs_begin_index < 0){
			path = url.substring( path_begin_index + 7, url.length);
		}
		else {
			path = url.substring(path_begin_index + 7, qs_begin_index );
		}
	}
	else if (qs_begin_index < 0){
		path = url;
	}
	else {
		path = url.substring(0, qs_begin_index );
	}
	return path;
}


function getPath_PP(url)
{
	var path = "/";
	// get path info & query string & hash from url
	qs_begin_index = url.indexOf('?');
	// if action is relative url, get base url from window location
	if ( url.charAt(0) != '/' && url.substring(0,9) != "http://" ) {
		path_end = window.location.href.indexOf('?');
		if(path_end < 0)	path_end_str = window.location.href;
		else				path_end_str = window.location.href.substring(0,path_end); 
		path_relative_base_end = path_end_str.lastIndexOf('/');
		path_relative_base_str = path_end_str.substring(0,path_relative_base_end+1);
		path_begin_index = path_relative_base_str.substring (9,path_relative_base_str.length).indexOf('/');
		if (qs_begin_index < 0){
			path = path_relative_base_str.substring( 9+path_begin_index,path_relative_base_str.length ) + url;
		}
		else {
			path = path_relative_base_str.substring( 9+path_begin_index,path_relative_base_str.length )
				 + url.substring(0, qs_begin_index );
		}
	}
	else if ( url.substring(0,9) == "http://" ) {
		path_begin_index = url.substring (9, url.length).indexOf('/');
		if (qs_begin_index < 0){
			path = url.substring( path_begin_index + 9, url.length);
		}
		else {
			path = url.substring(path_begin_index + 9, qs_begin_index );
		}
	}
	else if (qs_begin_index < 0){
		path = url;
	}
	else {
		path = url.substring(0, qs_begin_index );
	}
	return path;
}

// option bit : _4_ _3_ _2_ _1_
//                       |   |
//                       |   --- 0 : ��� ������ ����Ʈ��, 1 : �α����� ������ ���
//                       ------- 0 : ����ڿ��� idn �Է� �䱸, 1 : idn�� "NULL" setting, �������� idn ����
function VerifyVirtualID(Idn, TimeStamp, ServerCertPem)
{
	var msg;
	
	var option = 0;
	
	option = 0;   // ��� ������ ����Ʈ��, ����ڿ��� idn �Է� �䱸
	
	//alert(navigator.appName);
	if( IsNetscape60() )
	{
		//alert("netscape");
		msg = document.XecureWeb.VerifyAndGetVID(xgate_addr, ServerCertPem, TimeStamp, escape(accept_cert), option, escape(Idn));
	}
	else 
	{
		//alert("ie");
		msg = document.XecureWeb.VerifyAndGetVID(xgate_addr, ServerCertPem, TimeStamp, accept_cert, option, Idn);
	}
	
	return msg;

}

// nOption is 0 : (default value) File version, which is checked by 'Internet Explorer'
//            1 : Product version
//            2 : File Description
function GetVersion(nOption)
{
	var ver;

	if( IsNetscape() )
	{
		alert("Not supported function [GetVersion]");
		ver = "";
	}
	else
	{
		ver = document.XecureWeb.GetVerInfo(nOption);
		if( ver == "" )
			alert("No version information");
	}
	
	return ver;
}

// only over XecureWeb Client v5.3.0.1
function UpdateModules( infoURL )
{
	var	ret;
	
//	if( IsNetscape() )
//	{
//		alert("Not supported function [UpdateModules]");
//		ret = 0;
//	}
//	else
	{
		// success : 0, cancel : 1, file(s) holded : 2, already updated : 3, invalid user : 4, need not : 5
		// error : -1
		ret = document.XecureWeb.UpdateModules( infoURL );
		alert(ret);
	}
		
	return	ret;
}

// only over XecureWeb Client v5.3.0.1
function SetUpdateInfo( section, key, value1 )
{
	var	ret;
	
//	if( IsNetscape() )
//	{
//		alert( "Not supported function [SetUpdateInfo]" );
//		ret = 0;
//	}
//	else
	{
		ret = document.XecureWeb.SetUpdateInfoString( section, key, value1 );
	}
	
	return ret;			
}

// inserted by knlee 2003/06/10
function SetProviderList()
{
	var	ret;
	
	//var	provName = "TrustedNet Connect 2 Smart Card CSP;Microsoft Base Cryptographic Provider v1.0;Microsoft Enhanced Cryptographic Provider v1.0";
	var	provName = "TrustedNet Connect 2 Smart Card CSP;Keycorp CSP";
	
	if( IsNetscape() )
	{
		alert("Not supported function [SetProviderList]");
		return -1;
	}
	else
	{
		ret = document.XecureWeb.SetProvider(provName);
		if( ret != 0 )
			alert("Set Provider name is Fail!");
	}
	
	return ret;
}

// applet���� servlet���� ���� ���� ��ȣȭ �ϴ� function
function enc(str) {
	var state='';
	var plain='';
	var escaped_state='';
//	plain=String(str);

	alert("enc : " + str.length);
	if (navigator.appName == 'Netscape')
		state=XecureWeb.BlockEnc(xgate_addr, "/off", escape(str), "POST");
	else
   		state=XecureWeb.BlockEnc(xgate_addr, "/off", str, "POST");
   	//escaped_state=escape_url(state);
//   	escaped_state=escape_url_applet(state);
   	alert("POST:" + state.length);
	alert("enc end");
	return state;
}

// servlet���� applet���� ������ ���� ��ȣȭ �ϴ� function
function dec(str) {
	var result=BlockDec(str);
	return result;
}

function quick_escape(str)
{
	var len, leftlen, cut, i, j, pos, k;
	var out = "", out1 = "", out2 = "";

	len = str.length;
	if(len > 160) {
		leftlen = len/2;
		cut = Math.round(leftlen);
		out1 = quick_escape(str.substring(0, cut));
		out2 = quick_escape(str.substring(cut));
		out = out1 + out2;
	}else {
		pos = 0;
		j = -2;
		k = -2;
		while (pos > -1 && pos < len) 
		{
			if(j == -2)
				j = str.indexOf('+', pos);
			if(k == -2)		
				k = str.indexOf('=', pos);
			if(j < 0 && k < 0) {
				out += str.substring(pos);
				break;
			}
			if ((j < k && j > -1) || (j > -1 && k < 0))
			{
				out += str.substring(pos, j);
				out += '%2B';
				pos = j + 1;
				j = -2;
			}
			else if ((j > k && k > -1) || (k > -1 && j < 0))
			{
				out += str.substring(pos, k);
				out += '%3D';
				pos = k + 1;
				k = -2;
			}
			else{
				out += str.substring(pos);
				pos = -1;
			}
		}
	}
	return out;
}
function escape_url_applet(in_str)
{
	var len, leftlen, cut;
	var out = "", out1 = "", out2 = "";
	
	len = in_str.length;
	
	if(len > 160) {
		leftlen = len/2;
		cut = Math.round(leftlen);
		out1 = quick_escape(in_str.substring(0, cut));
		out2 = quick_escape(in_str.substring(cut));
		out = out1 + out2;
	}else {
		out = quick_escape(in_str);
	}
	alert("escape_url_applet end : " + out.length);
	return out;
} 

/*
	*** valid for only XWebFilCom v5.5.x ***
	
	It is possible to combine following option flags
	[EXCEPTION]
	   - 1,2 cannot be used simultaneously
	   - 4 is valid for only 1
	
	envOption  =   1 : ��������� ���ں���
	           =   2 : �н������� ���ں���
	           =   4 : ���� ���� �������� ���ں���
	           =   8 : CMS Ÿ������ Envelop
	           = 256 : �α����� �������� ���ں���
	           
	return value
	   - success : enveloped message
	   - fail    : ""
*/
function EnvelopData( inMsg, pwd, certPem, envOption )
{
	var envMsg;
  
	envMsg = document.XecureWeb.EnvelopData(
			xgate_addr, 
			XecureEscape(accept_cert), 
			XecureEscape(inMsg), 
			envOption, 
			pwd, 
			certPem, 
			"", 
			0, 
			"", 
			3 );

   	if( envMsg == "" )
   	{
		XecureWebError();
   	}

	return envMsg;
}

function RecoverCertificate( type, ref_code, auth_code )
{
    var r;
    var ca_type;
    var ca_ip;
    var ca_port;
	var aXWCMPInfo;

	aXWCMPInfo = GetCAInfo (type);
	if (aXWCMPInfo != null)
	{
		ca_type = aXWCMPInfo.getType ();
		ca_ip = aXWCMPInfo.getIP ();
		ca_port = aXWCMPInfo.getPort ();

		window.status = "CMP("+ aXWCMPInfo.getName () +"):" + ca_type + "\t" + ca_ip + "\t" + ca_port;

	}
	else {
		alert("Input type error!");
		return 0;
	}

    r = document.XecureWeb.RecoverCertificate( xgate_addr, ca_port, ca_ip, ref_code, auth_code, ca_type, 0, 3 );

    if ( r != 0 )   XecureWebError();

    return r;
}

function BlockDecEx(cipher, target)
{
	var ret;

	if( IsNetscape60() )		// Netscape 6.0
		plain = XecureUnescape(document.XecureWeb.nsIXecurePluginInstance.BlockDec( xgate_addr, cipher));
	else {
		ret = document.XecureWeb.DecryptWebData( xgate_addr, cipher, target);
        if(ret != 0)    alert( "�����ڵ� : " + ret );
        return "";


	}

	return ret;
}

// added Park, sohyun
// MultiSignData �߰�
//Multi_Sign�� �ϱ����� ó���� ����.
//���� �ʱ�ȭ, Sign Id ����.
var s_sign_desc = "MultiSign";
var s_bannerPath = "CHB_EFMS";
var cert_serial = "0376b015";

function Multi_Sign_Init()
{
    var multiSignId;

    multiSignId = document.XecureWeb.MultiSignInit();  //MultiSignInit()ȣ��

    if( multiSignId < 0 )
    {
        XecureSignError();
    }
    else
    {
        //alert("MultiSignId: " + multiSignId);
    }
    return multiSignId;
}

function Set_Multi_Sign_Data(multiSignId, plain)
{
    var     originalDataTotalSize = 0;

    if(multiSignId != "")
    {
        originalDataTotalSize = document.XecureWeb.SetMultiSignData(multiSignId, plain);

        if( originalDataTotalSize < 0 )
        {
            XecureSignError();
        }
        else
        {
            //alert(originalDataTotalSize + "���� ������Ÿ�� �ֽ�~�ϴ�");
        }
    }
    else
    {
    alert("MultiSignInit�� ���� ���ֽʽÿ�");
    }

    return originalDataTotalSize;
}

// old XecureSign
// option :
//              0 : ���� ���� ��� ����
//              1 : ���� ���� ���
//x2            0 : hex encoding
//x2            1 : BASE64 encoding
// mask : 0 : all certificates
//        1 : only user certificates
//        2 : only coperation certificates

// �ֽ��� MultiSign �Լ� �ּ� ����
function Multi_Sign(multiSignId, Option)
{
    var result = 0;
    
    PutMPhoneData();

    if(multiSignId != "")
    {
	//MultiSignEx(int nMultiSignId, BSTR xaddr, BSTR ca_list, BSTR desc, int option, int nLimitPwd, int *ret)
        result = document.XecureWeb.MultiSignEx(multiSignId, xgate_addr, accept_cert, sign_desc, Option, 2);
        //result = document.XecureWeb.MultiSignExWithSerial(multiSignId,accept_cert,"0342f234",
        //								sign_desc,Option,"",2);
        //MultiSignExWithSerial(nMultiSignId, BSTR ca_name,BSTR Serial,BSTR desc,
        //int option,BSTR bannerDir, int nLimitPwd);       
/*
        if( result < 0 )
        {
            alert("���� �����߽��ϴ�.");//XecureSignError();
        }
        else
        {
            alert("���� ����");
        }
*/
    }
    else
    {
        alert("MultiSignInit�� ���� ���ֽʽÿ�");
    }
    return result;
}

// �ֽ��� MultiSign �Լ� �ּ� ����
function Multi_Sign_with_serial(multiSignId, Option, Serial)
{
    var result = 0;
	
    if(multiSignId != "")
    {
 alert(xgate_addr);
// [certLocation]
// 	0 : HARD
//	1 : REMOVABLE
//	2 : ICCARD
//	3 : CSP
        //result = document.XecureWeb.MultiSignEx(multiSignId, accept_cert, sign_desc, Option, "", 2);
	//MultiSignExWithSerial(int nMultiSignId, BSTR xaddr, BSTR ca_list, BSTR Serial, int certLocation, BSTR desc, int option, int nLimitPwd, int *ret)
        result = document.XecureWeb.MultiSignExWithSerial(multiSignId, xgate_addr, accept_cert, Serial, 1, sign_desc, Option, 2);
        
        //MultiSignExWithSerial(nMultiSignId, BSTR ca_name,BSTR Serial,BSTR desc,
        //int option,BSTR bannerDir, int nLimitPwd);
        if( result < 0 )
        {
            alert("���� �����߽��ϴ�.");//XecureSignError();
        }
        else
        {
            //alert("���� ����");
        }
    }
    else
    {
        alert("MultiSignInit�� ���� ���ֽʽÿ�");
    }
    return result;
}


function Get_Multi_Signed_Data(multiSignId, index)
{
    var signedData = "";

    if(multiSignId != "")
    {
        signedData = document.XecureWeb.GetMultiSignedData(multiSignId, index);
        if( signedData == "" )
        {
        XecureSignError();
        }
        else
        {
                //alert("�������� ����");
        }
    }
    else
    {
        alert("MultiSignInit�� ���� ���ֽʽÿ�");
    }
    return signedData;
}

//Multi_Sign�� ���� �������� Call
//����� �޸� ���� free
function Multi_Sign_Final(multiSignId)
{
    var result;

    result = document.XecureWeb.MultiSignFinal(multiSignId);

    if( result < 0)
    {
        XecureSignError();
    }
    else
    {
        multiSignId = 0;
    }

    return result;
}
//#define XW_SIGN_OPTION_VIEW_CONFIRM_WINDOW	0x00000001
//#define	XW_SIGN_OPTION_ENCODING_BASE64		0x00000100 (256)
//#define XW_SIGN_OPTION_USE_CERT_SERIAL		0x00020000 (131072)
function MultiSign(total,sign_msg,delimeter)
{
    var signed_msg = "";
    var multiSign_id = "";
    var tmp = sign_msg;
    var index= "";
    var length = "";
    var signed_tmp = "";
    var ret = "";
    
		tmp = sign_msg.split(delimeter);
		total = tmp.length;

    if (total <= 0 || sign_msg == "")
    {
        alert("������ ����Ÿ�� �����ϴ�");
        return "";
    }

    //Multi���ڼ��� �ʱ�ȭ
    multiSign_id = Multi_Sign_Init();

    //���� ����
    for(i =0;i < total ;i++)
    {
    		if(tmp[i].replace(/^\s+|\s+$/g,"") == "")
    		{	
    			continue;
    		}
        Set_Multi_Sign_Data(multiSign_id,tmp[i]);
    }
    //���� ����
    ret = Multi_Sign(multiSign_id,0);//HEX  encoding
    // ret = Multi_Sign(multiSign_id,256);//base64  encoding    
    
    if(ret != 0)
    {	
        return "";
    }
	
    //���� ����
    for(i = 0; i < total ; i++)
    {
    	  if(tmp[i].replace(/^\s+|\s+$/g,"") == "")
    		{	
    			continue;
    		}
        signed_tmp = Get_Multi_Signed_Data(multiSign_id,i);
        signed_msg += signed_tmp + delimeter;
    }
    return signed_msg;
}

function MultiSignWithSerial(total, sign_msg, delimeter)
{
    var signed_msg = "";
    var multiSign_id = "";
    var tmp = sign_msg;
    var index= "";
    var length = "";
    var signed_tmp = "";
    var ret = "";

    if (total <= 0 || sign_msg == "")
    {
        alert("������ ����Ÿ�� �����ϴ�");
        return "";
    }

    //Multi���ڼ��� �ʱ�ȭ
    multiSign_id = Multi_Sign_Init();

    //���� ����
    for(i =0;i < total ;i++)
    {
        length = tmp.length;
        //index = tmp.indexOf('��');
        index = tmp.indexOf(delimeter);
        
        Set_Multi_Sign_Data(multiSign_id,tmp.substring(0,index));
        tmp = tmp.substring(index+1,length);
    }
    //���� ����
    //#define XW_SIGN_OPTION_VIEW_CONFIRM_WINDOW	0x00000001
    //#define	XW_SIGN_OPTION_ENCODING_BASE64		0x00000100 (256)
    //#define XW_SIGN_OPTION_USE_CERT_SERIAL		0x00020000 (131072)
    // XW_SIGN_OPTION_NO_CMS 65536
    ret = Multi_Sign_with_serial(multiSign_id, 256+65536+131072, cert_serial); //base64  encoding    
    
    if(ret != 0)
    {	
        return "";
    }
	
    //���� ����
    for(i = 0; i < total ; i++)
    {
        signed_tmp = Get_Multi_Signed_Data(multiSign_id,i);
        //signed_msg += signed_tmp + "��";
        signed_msg += signed_tmp + delimeter;
    }
    return signed_msg;
}

function DeEnvelop(data)
{
	var r;
	var errCode;
	var errMsg='';
	
	if( !is_gecko && navigator.appName == 'Netscape') 
	{		
		alert( "Not supported function" );
	}
	else	/* Explorer */
	{	
		r = document.XecureWeb.DeEnvelopData(
			xgate_addr, 
			accept_cert, 
			data, 
			0, // �ø��� ��ġ�ϴ� ������ ������ �޽���â ��� 
//			1024, // �ø��� ��ġ�ϴ� ������ ������ �޽���â ��¾���
			"", 
			"", 
			3);

	   	if( r == "" )
	   	{
	   		alert('a');
	   		/*
			errCode = document.XecureWeb.LastErrCode();
			alert('b');
			errMsg = document.XecureWeb.LastErrMsg();
			alert('c');
			Alert( errCode, errMsg );
			alert("Error");
			*/
			XecureWebError();
			return false;
	   	}
	   	
	}
	return r;
}
//deenvOption
//0, // �ø��� ��ġ�ϴ� ������ ������ �޽���â ��� 
//1024, // �ø��� ��ġ�ϴ� ������ ������ �޽���â ��¾���
function DeEnvelopWithOption(data,deenvOption)
{
	var r;
	var errCode;
	var errMsg='';
		
	if( !is_gecko && navigator.appName == 'Netscape') 
	{		
		alert( "Not supported function" );
	}
	else	/* Explorer */
	{	
		r = document.XecureWeb.DeEnvelopData(
			xgate_addr, 
			accept_cert, 
			data, 
			deenvOption,
			"", 
			"", 
			3);

	   	if( r == "" )
	   	{
	   		alert('a');
	   		/*
			errCode = document.XecureWeb.LastErrCode();
			alert('b');
			errMsg = document.XecureWeb.LastErrMsg();
			alert('c');
			Alert( errCode, errMsg );
			alert("Error");
			*/
			XecureWebError();
			return false;
	   	}
	   	
	}
	return r;
}


function Sign_with_option_htmlex( option, plain, keydata, svrCert )
{
	var signed_msg;
	
	if( IsNetscape60() )	// Netscape 6.0
	{
		alert("�������� �ʴ� ����Դϴ�.");
	}
	else
	{
		signed_msg = document.XecureWeb.SignDataCMSWithHTMLEx(
							xgate_addr,
							XecureEscape(accept_cert), 
							XecureEscape(plain),
							XecureEscape(keydata),
							svrCert,
							option, 
							XecureEscape(sign_desc),
							pwd_fail);
	}

    if( signed_msg == "" )	XecureWebError();

    return signed_msg;
}

function Sign_with_option_htmlex_cloud( option, plain, keydata, svrCert )
{
	var signed_msg;
	var CurrentCertLocation = "";
	
	CurrentCertLocation = document.XecureWeb.CertLocation;

	document.XecureWeb.CertLocation = "hard,pkcs11,removable,csp,USBTOKEN_KIUP,iccard,NO_SMARTON,MPHONE,MOBISIGN,CLOUDSIGN";

	
	if( IsNetscape60() )	// Netscape 6.0
	{
		alert("�������� �ʴ� ����Դϴ�.");
	}
	else
	{
		signed_msg = document.XecureWeb.SignDataCMSWithHTMLEx(
							xgate_addr,
							XecureEscape(accept_cert), 
							XecureEscape(plain),
							XecureEscape(keydata),
							svrCert,
							option, 
							XecureEscape(sign_desc),
							pwd_fail);
	}

    if( signed_msg == "" )	XecureWebError();
    
    document.XecureWeb.CertLocation = "";
    document.XecureWeb.CertLocation = CurrentCertLocation;

    return signed_msg;
}

//Infovine
function PutMPhoneData()
{
	if(IsOpera() )
	{
		;
	}
	else
	{ // ����� ����
	//	var bankUrl = "LOTTECARD_S|https://" + window.location.host + "/visa3d/apps/XACS/infovine/DownloadList";
	   	var bankUrl = "WOORIBANK|http://test.ubikey.co.kr/infovine/1023_1022/DownloadList";
		var coUrl = "SOFTFORUM|KINGS";
		//var popUrl = "https://" + window.location.host + "/visa3d/apps/XACS/infovine/download.html|width=450,height=400,left=10,top=10";
		//var popUrl = "http://pib.wooribank.com/img/certi/mob/download.html|width=450,height=400,left=10,top=10";
		var popUrl = "http://test.ubikey.co.kr/infovine/1023_1022/download.html|width=450,height=400,left=10,top=10";

		// #232 [2008/06/25 by Lee,GuenHee] ������� �α��ν� �������� �ȵǴ� ���� �ذ�. MPhoneData xgate_addr�� pid���� ����.
		// 7221_after / v7222 �̻���� xgate_addr�� Pid �߰��Ͽ� mphone_data �� �Է��Ѵ�.
		var version = document.XecureWeb.GetVerInfo(1);
			
		if( (version.indexOf('7, 2, 3') >= 0 || version.indexOf('7,2,3') >=0) && !(version.indexOf('7, 2, 3, 0') >= 0 || version.indexOf('7,2,3,0') >=0) 
		|| version.indexOf('7, 2, 4,') >= 0 || version.indexOf('7,2,4') >=0 || version.indexOf('7, 2, 5,') >= 0 || version.indexOf('7,2,5') >=0 )
		{
			var mphone_data = "MPHONE:" + document.XecureWeb.GetEncUserData(xgate_addr) + "&" + bankUrl + "&" + coUrl + "&" + popUrl + "|" + window.location.hostname;
		}
		else
		{
			var mphone_data = "MPHONE:" + xgate_addr + "&" + bankUrl + "&" + coUrl + "&" + popUrl + "|" + window.location.hostname;
		}
		//
	
	
		if( IsSafari() || is_gecko )
		{
			return;
		}
	
		if( version.indexOf('7, 2,') >= 0 || version.indexOf('7,2,') >=0 )
		{
			mphone_data += "|1.0.2.3";
		}
	//	alert('put user data:'+mphone_data);
		document.XecureWeb.PutUserData( xgate_addr, mphone_data );
		if( version.indexOf('7, 2, 0, 7') >= 0 || version.indexOf('7,2,0,7') >=0 )
		{
			document.XecureWeb.SetPhoneData(mphone_data,1);	
		}
		if( version.indexOf('7, 2, 1,') >= 0 || version.indexOf('7,2,1,') >=0 )
		{
			document.XecureWeb.SetPhoneData(mphone_data,1);	
		}
		if( version.indexOf('7, 2, 3,') >= 0 || version.indexOf('7,2,3') >=0 
		|| version.indexOf('7, 2, 4,') >= 0 || version.indexOf('7,2,4') >=0
		|| version.indexOf('7, 2, 5,') >= 0 || version.indexOf('7,2,5') >=0)
		{
			document.XecureWeb.SetPhoneData(mphone_data,1);	
		}
		
		// #236 [2008/07/01 by Lee,GuenHee] Modified for adding MobiSign.
		var popUrl = "http://www.mobisign.kr/mobisigndll.htm|width=450,height=400,left=10,top=10";
		// var popUrl = "http://snoopy.yessign.or.kr/move/mobisigndll.htm|width=450,height=400,left=10,top=10";
		// var popUrl = "http://192.168.10.36:10234/mobisignxw/mobisign.htm|width=450,height=400,left=10,top=10";
		
		var bankUrl = "1234567";
			   	
		// ������ ������ cab ��ġ URL (���� ���� �ȵ��־ softforum.com���� ������ ����)
		// var popUrl = "http://download.softforum.co.kr/Published/mobisign/v3.0.46/mobisignxw.htm|width=450,height=400,left=10,top=10";
		
		if( version.indexOf('7, 2, 2,') >= 0 || version.indexOf('7,2,2,') >=0 
		|| version.indexOf('7, 2, 3,') >= 0 || version.indexOf('7,2,3,') >=0 
		|| version.indexOf('7, 2, 4,') >= 0 || version.indexOf('7,2,4') >=0 
		|| version.indexOf('7, 2, 5,') >= 0 || version.indexOf('7,2,5') >=0 )
		{
			var mphone_data = "MOBISIGN:" + document.XecureWeb.GetEncUserData(xgate_addr) + "&" + bankUrl + "&" + coUrl + "&" + popUrl + "|" + window.location.hostname;
		}
		
		if( version.indexOf('7, 2, 2,') >= 0 || version.indexOf('7,2,2,') >=0 
		|| version.indexOf('7, 2, 3,') >= 0 || version.indexOf('7,2,3,') >=0 
		|| version.indexOf('7, 2, 4,') >= 0 || version.indexOf('7,2,4') >=0
		|| version.indexOf('7, 2, 5,') >= 0 || version.indexOf('7,2,5') >=0 )
		{
			mphone_data += "|5.0.3.2";
		}
		
		if ( version.indexOf('7, 2, 2,') >= 0 || version.indexOf('7,2,2,') >=0 
		|| version.indexOf('7, 2, 3,') >= 0 || version.indexOf('7,2,3,') >=0 
		|| version.indexOf('7, 2, 4,') >= 0 || version.indexOf('7,2,4') >=0
		|| version.indexOf('7, 2, 5,') >= 0 || version.indexOf('7,2,5') >=0 )
		{
			document.XecureWeb.PutUserData( xgate_addr, mphone_data );
			document.XecureWeb.SetPhoneData(mphone_data,1);
		}
	} // ����� ����
	//
}

function PutStorageImage()
{
	var PhonebannerUrl = "https://" + window.location.host + "/visa3d/apps/XACS/infovine/xweb004.bmp";
	var version = document.XecureWeb.GetVerInfo(1);
	
	if( version.indexOf('7, 2,') >= 0 || version.indexOf('7,2,') >=0 )
	{
		PhonebannerUrl += ".sig";
	}
	document.XecureWeb.PutBigBannerUrl( "IMAGE:" + xgate_addr, PhonebannerUrl );
}
/*
 *	opOpt == 0x00000000 : "data" is signed data
 *        == 0x00000001 : "data" is signed data and need to verify
 *        == 0x****0000 : verification option(valid in case of GET_CERTINFO_VERIFY)
 *
 *	infoOpt == 1 : subject dn
 *          == 2 : issuer dn
 *          == 3 : serial
 *          == 4 : policy OID
 *			== 5 : Cert Data(all, Pem)
 *			== 6 : Cert Data(all, Binary / not yet implemented)
 */
function GetCertInfo(signedData,opOpt,infoOpt)
{
	var CertInfo;
	
	CertInfo = document.XecureWeb.GetCertInfo( signedData,opOpt,infoOpt );
	
	return CertInfo;
}

function GetCertInfoEx(signedData,orgData, opOpt,infoOpt, verifyOpt)
{
	var CertInfo;
	
	CertInfo = document.XecureWeb.GetCertInfoEx( signedData,orgData, opOpt,infoOpt,verifyOpt );
	
	return CertInfo;
}

/*
 type 
 1 : CERT_USBTOKEN_KOOKMINBANK;
 2 : CERT_USBTOKEN_KIUPBANK;
else :CERT_USBTOKEN;
*/

function GetUsbTokenSerial(type)
{
	var TokenSerial;
	
	TokenSerial = document.XecureWeb.GetUSBTokenSerial( type );
	return TokenSerial;
}

function InstallCertKey(signCert, signKey, kmCert, kmKey)
{
	var	ret;
	var ca_type;
	ca_type = GetCAInfo (15).getType () ;
	ret = document.XecureWeb.InstallCertKey(ca_type, signCert, signKey, kmCert, kmKey);
}
//���� HSM ��ū type
//Rainbow i-key 2032 : 1
function GetHSMTokenSerial(type)
{
	var TokenSerial;
	
	TokenSerial = document.XecureWeb.GetHSMTokenSerial( type ,"");
	//2��° ���ڴ� ������ ���ؼ� Xgate Addr
	return TokenSerial;
}

function GetCacheCertLocation()
{
	var certLocation;
	
	certLoaction = document.XecureWeb.GetCacheCertLocation(xgate_addr);

	return certLocation;
}

/**********************For Flex**********************/

function XecureFlex(tmp_url)
{
	//alert("XecureFlex");
	var qs ;
	var path = "/";
	var cipher;
	var xecure_url;

	// get path info & query string & hash from url
	qs_begin_index = tmp_url.indexOf('?');
	path = getPath(tmp_url)
	// get query string action url
	if ( qs_begin_index < 0 ) {
		qs = "";
	}
	else {
		qs = tmp_url.substring(qs_begin_index + 1, tmp_url.length );
	}

	if( gIsContinue == 0 ) {
		gIsContinue = 1;
		if( IsNetscape60() )		// Netscape 6.0
			cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr, path, XecureEscape(qs), "GET");
		else {
			alert(qs);
			cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
			alert(cipher);
		}
		gIsContinue = 0;
	}
	else {
		alert(busy_info);
		return false;
	}
			
	if( cipher == "" )	return XecureWebError();
	
	xecure_url = path + "?q=" + escape_url(cipher);

	return xecure_url;
}

//Flex ��ȣȭ�� ���� �Լ� �߰�
//2006/11/17 �̱Ǽ�
function BlockEncForFlex(plain)
{
	alert("BlockEncForFlex");
	var SID;
	var cipher;
	var errCode;
	var errMsg = "";

	if(plain == null && plain == "")
	plain = "flex";

	if(navigator.appName == 'Netscape')
	{
		if(agent != 'Mozilla/5')
			cipher = document.XecureWeb.BlockEnc(xgate_addr,"/",plain,"GET");
		else
			cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr,"/",plain,"GET");
	}
	else
	{
		cipher = document.XecureWeb.BlockEnc (xgate_addr,"/",plain,"GET" );
	}

	if( cipher == "" )
	{
		if(navigator.appName != 'Netscape')
		{
			errCode = document.XecureWeb.LastErrCode();
			errMsg = document.XecureWeb.LastErrMsg();
		}
		else if(agent != 'Mozilla/5')
		{
			errCode = document.XecureWeb.LastErrCode();
			errMsg = unescape(document.XecureWeb.LastErrMsg());
		}
		else
		{
			errCode = document.XecureWeb.nsIXecurePluginInstance.LastErrCode();
			errMsg = unescape(document.XecureWeb.nsIXecurePluginInstance.LastErrMsg());
		}
		process_error( errCode, errMsg );
		return false;
	}
	alert(cipher);
	return escape_url(cipher);
}

//created :2008/03/18  By KSS [Mantis Issue Number] : #179
function GetUserPCInfo(opOpt)
{
	var CertInfo;
	alert(opOpt);
	
	CertInfo = document.XecureWeb.GetUserPCInfo( opOpt );
	
	alert(CertInfo);
	return CertInfo;
}


/**
 * PP (Pelican Project) Functions
 * ��� ������ ����
 *
 */
function XecureLink_PP( link, flag )
{
	var qs ;
	var cipher;
	var xecure_url;
	var xalice = 0;

	alert ("�̰� ���� ������ ���� "); return false;

	if (flag != undefined)	xalice = flag;

	qs = link.search;
	if ( qs.length > 1 ) {
		qs = link.search.substring(1);
	}

	hash = link.hash;

	
	if( gIsContinue == 0 )
	{
		path = XecurePath(link.pathname) ;
		gIsContinue = 1;

		if (xalice == 0)
		{
			if(IsSafari())
			{
				cipher = document.embeds["XecureWeb"].BlockEnc3 (xgate_addr, path, XecureEscape(qs),"GET");
				if ( hash.length == 1 )
				{
					hash ="";
				}
			}
			else if( IsNetscape60() )		// Netscape 6.0
			{
				cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc3 (xgate_addr, path, XecureEscape(qs), "GET");
			}
			else 
			{
				cipher = document.XecureWeb.BlockEnc3(xgate_addr, path, XecureEscape(qs),"GET",accept_cert);
			}

			if( cipher.length == 0)
			{
				return XecureWebError() ;
			}
		}
		gIsContinue = 0;
	}
	else {
		return false;
	}




	xecure_url = link.protocol + "//";

	if( IsSafari() )
		xecure_url += link.hostname;
	else
		xecure_url += link.host;

	xecure_url += path + hash
		
	if (xalice == 0)
	{
		xecure_url += "?aq=" + escape_url(cipher) + "&Xalice=1";
	}
	else
		xecure_url += "?" + qs;
 	
	if(usePageCharset) {
	}

	
	if ( link.target == "" || link.target == null ) open ( xecure_url, "_self" );
	else open( xecure_url, link.target );

	return false;
}


function XecureSubmit_PP ( form , flag )
{
	var qs ;
	var path ;
	var url;
	var cipher;
	var xalice = 0;

	if (flag != undefined)	xalice = flag;
	alert ("�̰� ���� ������ ���� "); return false;

	qs_begin_index = form.action.indexOf('?');
	
	// if action is relative url, get base url from window location
	//if (window.location.href.indexOf("x-http://") < 0)
	if (flag == undefined)
		path = getPath(form.action);
	else
		path = getPath_PP(form.action);

	// get path info & query string & hash from action url
	if ( qs_begin_index < 0 ) {
		qs = "";
		url = form.action;
		if (url.indexOf("http://") < 0)
			url = "http://" + window.location.host + path;
	}
	else {
		qs = form.action.substring(qs_begin_index + 1, form.action.length );
		url = form.action.substring (0, qs_begin_index);
		if (url.indexOf("http://") < 0)
			url = "http://" + window.location.host + path;
	}

	document.xecure.target = form.target;

	if ( form.method == "get" || form.method=="GET" ) {
		// collect input field values 
		if(qs.length!=0)
			qs += "&"+XecureMakePlain( form );
		else
			qs = XecureMakePlain( form );

		// encrypt QueryString
		if( gIsContinue == 0 ) {
			gIsContinue = 1;

			if (xalice >= 0)
			{
				if ( IsNetscape60() )		// Netscape 6.0
					cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc3 (xgate_addr, path, XecureEscape(qs),"GET");			
				else
					cipher = document.XecureWeb.BlockEnc3 (xgate_addr, path, XecureEscape(qs),"GET");
				if ( cipher == "" )	return XecureWebError() ;
			}
			gIsContinue = 0;
		}
		else {
			return false;
		}
		
		if( IsSafari() )
			xecure_url = url + (xalice == 0 ? "?aq=" + escape_url(cipher) : "?" + qs);
		else
			xecure_url = url + (xalice == 0 ? "?aq=" + escape_url(cipher) : "?" + qs);

		// adding character set information

		
		if ( form.target == "" || form.target == null ) open( xecure_url, "_self");
		else open ( xecure_url, form.target );
	}
	else {
		document.xecure.method = "post";
		document.xecure.enctype = form.enctype;

		// encrypt QueryString of action field
		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			if (xalice == 0)
			{
				if( IsNetscape60() )		// Netscape 6.0
					cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc3 (xgate_addr, path, XecureEscape(qs),"GET");			
				else
					cipher = document.XecureWeb.BlockEnc3 (xgate_addr, path, XecureEscape(qs),"GET");

				if ( cipher == "" )	return XecureWebError() ;
			}
			gIsContinue = 0;
		}
		else {
			return false;
		}		

		if( IsSafari() )
			document.xecure.action = url + (xalice == 0 ? "?aq=" + escape_url(cipher) : "?" + qs);
		else
			document.xecure.action = url + (xalice == 0 ? "?aq=" + escape_url(cipher) : "?" + qs);

		// adding character set information

		
		posting_data = XecureMakePlain( form );

		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			if (xalice == 0)
			{
				if( IsNetscape60() )		// Netscape 6.0
					cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc3 ( xgate_addr, path, XecureEscape(posting_data), "POST" );
				else{
					//cipher = document.XecureWeb.BlockEnc ( xgate_addr, path, XecureEscape(posting_data), "POST" );
					cipher = document.XecureWeb.BlockEnc3 ( xgate_addr, path, posting_data, "POST" );
				}

				if( cipher == "" )	return XecureWebError() ;
			}
			else
				cipher = posting_data;
			gIsContinue = 0;
		}
		else {
			return false;
		}		
		
		//document.xecure.p.value = cipher;
		alert ("AP=" + document.xecure.ap.value);
		document.xecure.ap.value = cipher;
		document.xecure.submit();
	}
	return false;
}





// PP�� ����Ҷ� by sukbum

/** ******************************************************************* */
/** XecureWEB Library													*/
/** ******************************************************************* */
// ������ �� XecureWEB���� �����Ƚ��� XWPP
var XWPP = new Object();

// Ajax POST���۽� ���� ��� �����͸� �ܾ ������Ʈ�� ���·� ������ش�.
// Ű���� ���� ���� �������� �ʾҴ�.
XWPP.extractForm = function(form)
{
	var retValue = '';
	var element = null;

	for(var i = 0;i < form.length;i++)
	{
		element = form[i];
		switch(element.type)
		{
			case 'text':
			case 'hidden':
			case 'password':
			case 'textarea':
			case 'select-one':
				retValue += element.name + '=' + escape_url(element.value) + '&';
				break;
			case 'select-multiple':
				retValue += element.name + '=';
				for(var j = 0;j < element.option.length;j++)
				{
					if(element.option[j].selected)
					{
						retValue += element.option[j].value + ',';

						if(j == element.option.length)
							retvalue += '&';
						else
							retvalue += ',';
					}
				}
				break;
			case 'radio':
			case 'checkbox':
				if(element.checked && !element.disabled)
					retvalue += element.name + '=' + escape_url(element.value) + '&';
				break;
		}
	}
	return retValue.substr(0, retValue.length - 1);
}

// Ajax GET��Ŀ� �Լ�
// link : <a>�±�
// onLoadFunction : �������� �о�ͼ� ������ �Լ�
// xslPath : �ɼ����� ȣ�� �� �����ָ� ����� xsl�� xml����� transform���ش�.
// onErrorFunction : �ɼ����� Ajax���� �� ������ �߻��� ��� �� �ڼ��� ������ ����ʹٸ�
// ���� �����ָ� �ȴ�.
XWPP.XecureLink_Ajax = function(link, onLoadFunction, xslPath, onErrorFunction)
{
	var targetURL = link.href;

	new XWPP.ContentLoader(targetURL, null, onLoadFunction, xslPath, onErrorFunction);

	return false;
}

// Ajax POST��Ŀ� �Լ�
// form : <form>�±�
// onLoadFunction : �������� �о�ͼ� ������ �Լ�
// xslPath : �ɼ����� ȣ�� �� �����ָ� ����� xsl�� xml����� transform���ش�.
// onErrorFunction : �ɼ����� Ajax���� �� ������ �߻��� ��� �� �ڼ��� ������ ����ʹٸ�
// ���� �����ָ� �ȴ�.
XWPP.XecureSubmit_Ajax = function(form, onLoadFunction, xslPath, onErrorFunction)
{
	var targetURL = form.action;

	new XWPP.ContentLoader(targetURL, XWPP.extractForm(form), onLoadFunction, xslPath, onErrorFunction);

	return false;
}

// Ajax ó�� �Լ�(Ŭ����?)
XWPP.ContentLoader = function(targetURL, postParameters, onLoadFunction, syncmode, xslPath, onErrorFunction)
{
	this.syncmode 		= (syncmode) ? syncmode : true;
	this.targetURL		= targetURL;
	this.onLoad			= onLoadFunction;
	this.xslPath		= xslPath;
	this.onError		= (onErrorFunction) ? onErrorFunction : this.defaultError;
	this.request		= this.createXMLHttpRequest();

	this.transformedResponseHTML	= null;
	this.transformedResponseXML		= null;


	if(this.request)
	{
		try
		{
			if(postParameters)
			{
				this.postParameters	= postParameters;
				this.loadPostDocument();
			}
			else
			{
				this.loadGetDocument();
			}
		}
		catch(error)
		{
			alert ("ERRRRR:" + error);
			this.onError();
		}
	}
}
XWPP.ContentLoader.prototype = {
	loadGetDocument:function()
	{
		var loader = this;

		this.request.onreadystatechange = function()
		{
			loader.onReadyState.call(loader);
		}

		this.request.open('GET', this.targetURL, this.syncmode);
		this.request.send(null);
	},
	loadPostDocument:function()
	{
		 var loader = this;

		 this.request.onreadystatechange = function()
		 {
			 loader.onReadyState.call(loader);
		 }

		 this.request.open('POST', this.targetURL, this.syncmode);
		 this.request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		 this.request.send(this.postParameters);
	},
	onReadyState:function()
	{
		if(this.request.readyState == 4)
		{
			if(this.request.status == 200 || this.request.status == 0 )
			{
				if(this.xslPath && this.transformXML.call(this))
					this.onLoad.call(this);
				else
					this.onLoad.call(this.request);

				return false;
			}
			else
			{
				this.onError.call(this);
				return false;
			}
		}

		return true;
	},
	defaultError:function()
	{
		alert("Failed Ajax Request"
				+ "\nReadyState : " + this.request.readyState
				+ "\nStatus : " + this.request.status
				+ "\nHTTP Status : " + this.request.httpStatus
				+ "\nResponse Headers : " + this.request.getAllResponseHeaders());
	},
	createXMLHttpRequest:function()
	{
		var request;

		try		// IE7, other browser
		{
			request = new XMLHttpRequest();
		}
		catch(IE)
		{
			try
			{
				request = new ActiveXObject("Msxml2.XMLHTTP");
			}
			catch(oldIE)
			{
				try
				{
					request = new ActiveXObject("Microsoft.XMLHTTP");
				}
				catch(failed)
				{
					alert("Failed create XMLHttpRequest object");
					request = null;
				}
			}
		}

		return request;
	},
	transformXML:function()
	{
		xmlDocument		= null;
		xslDocument		= null;
		xmlSource		= this.request.responseText.replace("<!---BEGIN_ENC--->", "").replace("<!---END_ENC--->", "").replace(/(\n)/gi, "");
		xslSource		= this.xslPath;

		try
		{
			xmlDocument = new ActiveXObject("Microsoft.XMLDOM");
			xmlDocument.async = false;
			xmlDocument.loadXML(xmlSource);

			xslDocument = new ActiveXObject("Microsoft.XMLDOM");
			xslDocument.async = false;
			xslDocument.load(xslSource);

			this.transformedResponseHTML = xmlDocument.transformNode(xslDocument);

			return true;
		}
		catch(FF)
		{
			try
			{
				xsltProcessor	= new XSLTProcessor();
				xmlParser		= new DOMParser();
				xmlDocument		= xmlParser.parseFromString(xmlSource, "text/xml");
				xslDocument		= document.implementation.createDocument("", "", null);
				xslDocument.async = false;
				xslDocument.load(xslSource);
				xsltProcessor.importStylesheet(xslDocument);

				this.transformedResponseXML = xsltProcessor.transformToFragment(xmlDocument, document);
				this.transformedResponseHTML = (new XMLSerializer()).serializeToString(this.transformedResponseXML);

				return true;
			}
			catch(error)
			{
				alert("Failed XSL transform");
				return false;
			}
		}
	}
}


// #362 [2009/01/30 by Lee,GuenHee] Restart IE8 nomerge mode.
//
// RestartWebBrowser()
//
//	- vender : ����� ��ų �������� ���� ����
//
//		 - Internet Explorer 8	1
//
//
//	- mode   : ����� ��� ��忡 ���� ����
//		   (��� �ȵǰ� �ִ� �����̰�, �⺻������ IE8���� nomerge��� ����� ��� ������)
//
//	- Option : - 0 : ����� ���θ� ���� �ʰ� �ٷ� ������� ���� ��Ų��.
//		   - 1 : ������� �˸��� ����� ���θ� ����ڿ��� ���´�.
//
//	- restartUrl : ������ â�� ����� URL�� path ������ �Է��Ѵ�. 
//			host�� ������� �������� ���̵ȴ�. ��� ��θ� ����Ű�� ./ ../ �����Ѵ�.(���Ȱ�ȭ)
//
//	- reserved : ����� ����. API�� ������ ��.
//
//	- ret	 : 
//		  - 1  : Browser�� Restart�� ���������� ���۵Ǿ� �� ������ ����ǰ� ���� â �ݱ�.
//		  - 0  : ������ Restart�� �������̹Ƿ� �� ������ ����� ����.
//		  - -1 : Restartó���� ���� �߻�.
//		  - -2 : ���� ��ġ�� �������� IE8�� �ƴ� ��������.
//		  - -3 : ����ڿ� ���� ������ Restart�� ��ҵ�.
//
//	- ErrorCode : -2100 : �� IE���� ���ÿ� RestartIE ����Ǿ�����.(��ũ��Ʈ �ݺ��Ǿ� ȣ��)
//		      -2101 : �߸��� �Է� �μ�.
//	    	      -2102 : ���� ��� IE�� processId threadId ȹ�� ����
//	              -2103 : Nomerge�� IE ���� ���� ����
//	              -2104 : ���� Max 128�� ������ pid ����Ʈ(nomerge�� ��� �� �ִ� �ִ� IEâ ����)�� �Ѿ��� ��.
//		      -2110 : �Էµ� restartUrl ���� ��� ��θ� ��Ÿ���� ./ ../ �� ���� �� �Է½� ����.

function RestartWebBrowser( vender, mode, restartUrl, Option )
{
	var ret;
	var vender;
	var errCode;
	
	//alert("Called RestartWebBrowser js function");

	if ( checkIE8() == 1 )
	{
		//alert("return ture checkIE8 of javascript checking");
		vender = 1;

		ret = document.XecureWeb.RestartWebBrowser(vender, mode, restartUrl, Option, 0);
	}
	else
	{
		//alert("return false checkIE8 of javascript checking");
		return 0;
	}
	
	if( ret == 1 )
	{
		//alert("nomerge ������� ����Ǿ���. ������ IE â�� �� ������.");
	}
	
	if( ret == 0 )
	{
		//alert("�̹� nomerge ������ ������ �������̴�.");
	}
	
	if( ret < 0 )
	{
		//alert("���� �߻� ret < 0");
		//XecureWebError();
		// ���� ó�� �κ�.
	}
	
	return ret;
}

function checkIE8()
{
	var rv = -1; // Return value assumes failure

	if (navigator.appName == 'Microsoft Internet Explorer')
 	{
		var ua = navigator.userAgent.toLowerCase();
		if( ua.indexOf('trident/4.0') != -1 ||
				ua.indexOf('trident/5.0') != -1 )
		{
  			rv = 1;
	  }
		else
		{
			rv = 0;
		}
	}
		
 	return rv;
}

function CheckPlainDataAndSignedData( plainData, signedData )
{
	var	errCode;
	var 	ret;
	
	if( IsNetscape() && is_gecko == false )
	{
		alert("Not supported function [CheckPlainDataAndSignedData]");
		return "";
	}
	else
	{
		ret = document.XecureWeb.CheckPlainDataAndSignedData( plainData, signedData);
	}

	if(ret < 0)
		alert("error : " + XecureWebError());
	else if(ret == 0)
		alert("FALSE");
	else if(ret == 1)
		alert("TRUE");
	else 
		alert("Unknwon Error!");
			
	return ret;	
}
