// XecureWeb SSL Client Java Script ver5.1  2010.03.18
var yessign_ca_type = 11+256;	// Yessign Test (sign Only)
var yessign_ca_ip =  "203.233.91.234";
var yessign_ca_port = 4512; //3280

var gIsContinue=0;
var busy_info = "암호화 작업이 진행중입니다. 확인을 누르시고 잠시 기다려 주십시오."
var usePageCharset=true;
var accept_cert = "Root CA,XecurePKI51 ca,";
accept_cert += "CA128000002,cn=CA128000002,cn=CA131000010,pki50ca,CA131000002Test,CA131000002,CA131000010,";
accept_cert += "Softforum CA 3.0,SoftforumCA,yessignCA,yessignCA-OCSP,signGATE CA,SignKorea CA,";
accept_cert += "CrossCertCA,CrossCertCA-Test2,3280TestCAServer,";
accept_cert += "NCASignCA,TradeSignCA,";
accept_cert += "yessignCA-TEST,yessignCA-Test Class 0,yessignCA-Test Class 1";
accept_cert += ",lotto test CA,NCATESTSign,SignGateFTCA,SignKorea Test CA,TestTradeSignCA,";
accept_cert += "Softforum Demo CA,mma ca,병무청 인증기관,MND CA,signGATE FTCA02,";
accept_cert += ".ROOT.CA.KT.BCN.BU,CA974000001,setest CA,3280TestCAServer";

var pCaCertUrl= "http://reaver.softforum.com:8080/XecureObject/signed_cacert.bin";
var pCaCertName = "TestRootCA";

var pwd_fail = 3;
var xgate_addr    = window.location.hostname + ":50443:8989";

var XWMSIECtrl = {
	mName			: "XecureWeb",
	mCID			: "CLSID:7E9FDB80-5316-11D4-B02C-00C04F0CD404",
	mCodeBase		: "http://192.168.10.30:8188/XecureObject/xw_install.cab#Version=7.2.0.7",
	mLicense		: "3082072b020101310b300906052b0e03021a05003082010706092a864886f70d010701a081f90481f6313a6d6572637572792e736f6674666f72756d2e636f2e6b723a5665726966795369676e6564446174612c46696c655369676e2c46696c655665726966792c4d756c746946696c655369676e2c46696c655369676e416e645665726966792c46696c65456e76656c6f702c46696c654465456e76656c6f702c46696c65436c6561722c46696c655a69702c46696c65556e5a69702c46696c655369676e344f454d2c4d756c746946696c655369676e344f454d2c5369676e44617461434d535769746848544d4c2c5369676e44617461434d535769746848544d4c45782c56657269667944657461636865645369676e656444617461a0820467308204633082034ba003020102020107300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3034303431393030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920524e44204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010043340b4e1f2f30d6634c818e9fa4b35c199e0628503dbe0d1f5ad2c05890a918408dc330c991083bc7cdfc50021303c04afab4cb522d22fced11d1be6559835f1f000d466120cff97a2a80e4fdf972ac127f9bb8e8ddb84974323e4cb822c5f15b22f82da3de6ef61a0b6798ca49a85af3d8f8298912b4d26411e2e1635c081a3306931716c5e56b279c4d36068a4b645c10aa582693086e14132ba67fb03526312790261f9c641993e2ffc3fd9e8df3efebfddecd722e874d6366ad1252ac0d8bddb5674533cc2717a7342e5cfb18f8a301e7196ca33d6c3bb7e1f1e4bee34f5358af6ae0fd52a9fc3bdd4925f5eab7db6628e24738f6c882bb0aaa0e10afbf0203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e041604142e49ab278ae8c8af977537de8b74bb240e0d275f300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c505542432c4f553d536563757269747920524e44204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d010105050003820101003ce700a0492b225b1665d9c73d84c34f7a5faad7b397ed49231f030e4e0e91953a607bd9006425373d490ef3ba1cf47810ca8c22fabe0c609f93823efdede64744458e910267f9f857c907318e286da6c131c9dd5fada43fd8cfdf6bd1b1b239338cea83eb6b6893b88fbcfd8e86a677b7270ad96be5a82b40569efc2dda6df4bcd642d067183186d6cace6c8f73b80f30b57acb3bcd5cbbc51307922d5edb38cb0d90c3917a8e37534183ba10f403c1c034287f39442df795050f39d78ddad97da8a43f02d7641549af9b5d68908e49faa8a1597cfed4a43baadd42c8fe4fd44c96d314df56147b8a7fa6ba65ffdee9ed3a5da52ef9ac7f9ca5afb633e1ccdf318201a13082019d020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020107300706052b0e03021a300d06092a864886f70d0101050500048201002a722081e8f73fa00f39b75247111e06e9cd1a68e822b63f0e77bc814b219eb07d63785c56b5f18de4fcaf79011297e01fad3d908841f51e33b47f6ca72e5ca17df41622246a1442380b05ff03d362b78a735509d0b30df63e08075b1cdc71f28891ed3e442eb5794486f267573c03d273e88b9ab1406a62795545f962c67cf2cf4c899f549523df0a52ed1d4649099014c4f8cd45856dab00f91c003c004cdc7ce3c2c1a4bd7f4ed609e76028252c9bd7eacb6553b91bead9a9b6e7c7766cdd45813659f43d1147d0db3837f00280f3644b11d68e870f0c306acff6130e20e644ac01f9ca26c496342080d08e06bdb58af7bba99cbafc11bc5f5dbbbae330e0",
	mStorage		: "hard,removable,csp,pkcs11,USBTOKEN_KIUP,iccard,NO_SMARTON,USBTOKEN_KIUP,YESSIGNM",
	mSecOption		: "4608:hard:iccard:USBTOKEN_KIUP",
	mSecKey			: "XW_SKS_SFVIRTUAL_DRIVER",
	mSecContext		: "30820647020101310b300906052b0e03021a0500302306092a864886f70d010701a01604147265617665722e736f6674666f72756d2e636f6da0820467308204633082034ba003020102020107300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3034303431393030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920524e44204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010043340b4e1f2f30d6634c818e9fa4b35c199e0628503dbe0d1f5ad2c05890a918408dc330c991083bc7cdfc50021303c04afab4cb522d22fced11d1be6559835f1f000d466120cff97a2a80e4fdf972ac127f9bb8e8ddb84974323e4cb822c5f15b22f82da3de6ef61a0b6798ca49a85af3d8f8298912b4d26411e2e1635c081a3306931716c5e56b279c4d36068a4b645c10aa582693086e14132ba67fb03526312790261f9c641993e2ffc3fd9e8df3efebfddecd722e874d6366ad1252ac0d8bddb5674533cc2717a7342e5cfb18f8a301e7196ca33d6c3bb7e1f1e4bee34f5358af6ae0fd52a9fc3bdd4925f5eab7db6628e24738f6c882bb0aaa0e10afbf0203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e041604142e49ab278ae8c8af977537de8b74bb240e0d275f300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c505542432c4f553d536563757269747920524e44204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d010105050003820101003ce700a0492b225b1665d9c73d84c34f7a5faad7b397ed49231f030e4e0e91953a607bd9006425373d490ef3ba1cf47810ca8c22fabe0c609f93823efdede64744458e910267f9f857c907318e286da6c131c9dd5fada43fd8cfdf6bd1b1b239338cea83eb6b6893b88fbcfd8e86a677b7270ad96be5a82b40569efc2dda6df4bcd642d067183186d6cace6c8f73b80f30b57acb3bcd5cbbc51307922d5edb38cb0d90c3917a8e37534183ba10f403c1c034287f39442df795050f39d78ddad97da8a43f02d7641549af9b5d68908e49faa8a1597cfed4a43baadd42c8fe4fd44c96d314df56147b8a7fa6ba65ffdee9ed3a5da52ef9ac7f9ca5afb633e1ccdf318201a33082019f020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020107300906052b0e03021a0500300d06092a864886f70d0101010500048201000e1c302b83a002ac95434a1f33b5907f1641d5bb444ff190608a182c89a1668875236bc90713677754c956041c956b79b4218a6ca3c776c0a152236d6d58a70b7ab220d5c56181165052da2201969e4aea705eea07320135086ad66f3224a972e222c289c197769a283d74b1ab2b5ff4871bff2c9590e7259a1def18c47eba3275a8b974774089b6be4b43702c7ea8bc3c4eba77f9ac81018168ceb0366a00038a83254df56e893dd761abe735c1f3ccc75bfb7efc21a19b0e55c0e590b19ce0d013d3db47ea22280ef13f375cbbd4d673cb2d553bf7d390668685abb889940a9e00d28a0b618df8b53f67e628bb303430c527585507ebd79d6605d4e577450b"
}

var XWFirefoxCtrl = {
	mName				: "XecureWeb",
	mType				: null,
	mTypeWin32			: "application/xecureweb-plugin",
	mTypeLinux			: "application/xecure-plugin",
	mSecOption			: "4608:hard:iccard",
	mLicense			: XWMSIECtrl.mLicense,
	mStorage			: "hard,removable,pkcs11",
	mSecKey				: "XW_SKS_SFVIRTUAL_DRIVER",
	mSecContext			: XWMSIECtrl.mSecContext,

	mWinVersion			: "7.0.0.0",
	mWin32Src			: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/xw_install.xpi"},
	mWin32SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win32.html"},
	mWin64Src			: null,
	mWin64SrcManual		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/install_integrated_plugin_win64.html"},

	mLinuxVersion		: "7.2.0.3",
	mLinux32Src			: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/xw_install_linux_x86.xpi"},
	mLinux64Src			: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/xw_install_linux_x86-64.xpi"},

	mMacVersion			: "7.2.0.3",
	mMacPPCSrc			: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/xw_install_mac_ppc.xpi"},
	mMacIntelSrc		: {"XecureWeb Plugin":"http://" + window.location.host + "/XecureObject/xw_install_mac_intel.xpi"}

}

var XWSafariCtrl = {
	mName				: "XecureWeb",
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

	mMacVersion			: "7.2.0.3",
	mMacPPCSrc			: "http://" + window.location.host + "/XecureObject/xw_install_mac_ppc.dmg",
	mMacIntelSrc		: "http://" + window.location.host + "/XecureObject/xw_install_mac_intel.dmg"
}

var XWIphoneCtrl = {
	mName				: "XecureWeb",
	mType				: null,
	mTypeLinux			: "application/xecure-plugin",
	mLicense			: XWMSIECtrl.mLicense,
	mStorage			: "hard,removable,pkcs11",
	mSecOption			: "4672:hard:iccard:keychain",
	mSecKey				: "XW_SKS_SFVIRTUAL_DRIVER",
	mSecContext			: XWMSIECtrl.mSecContext,

	mMacVersion			: "7.2.0.2"
}

var XWAndroidCtrl = {
    mName: "XecureWeb",
    mType: null,
    mTypeLinux: "application/xecure-plugin",
    mLicense: "license data",
    mStorage: "hard,removable,pkcs11",
    //mSecOption: "4608:hard:iccard",
    mSecOption: "4608:hard:removable:iccard",
    mSecKey: "XW_SKS_SFVIRTUAL_DRIVER",
    mSecContext: XWMSIECtrl.mSecContext,
    mAndroidVersion: "7.2.0.4"
}

var XWSeamonkeyCtrl = {
	mName				: "XecureWeb",
	mType				: null,
	mTypeWin32			: "application/xecureweb-plugin",
	mTypeLinux			: "application/xecure-plugin",

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

var XWChromeCtrl = {
	mName				: "XecureWeb",
	mType				: null,
	mTypeWin32			: "application/xecureweb-plugin",
	mTypeLinux			: "application/xecure-plugin",
	mSecOption			: "4608:hard:iccard:USBTOKEN_KIUP",
	mLicense			: "license data",
	mStorage			: "hard,removable",
	mSecKey				: "XW_SKS_SFVIRTUAL_DRIVER",
	mSecContext			: "SecContext data",

	mWinVersion			: "7.1.0.0",
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
	mName				: "XecureWeb",
	mType				: null,
	mTypeWin32			: "application/xecureweb-plugin",
	mTypeLinux			: "application/xecure-plugin",
	mSecOption			: "4608:hard:iccard:USBTOKEN_KIUP",
	mLicense			: "license data",
	mStorage			: "hard,removable",
	mSecKey				: "XW_SKS_SFVIRTUAL_DRIVER",
	mSecContext			: "SecContext data",

	mWinVersion			: "7.0.0.0",
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

/* Netscape 9 */
var XWNavigatorCtrl = {
	mName				: "XecureWeb",
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

function XWBrowser ()
{
	/* O/S Constant List */
	this.cWIN					= "Win";
	this.cWIN32					= "Win32";
	this.cWIN64					= "Win64";

	this.cLINUX					= "Linux";
	this.cLINUX32				= "Linux i";
	this.cLINUX64				= "Linux x86_64";

	this.cMAC					= "Mac";
	this.cMACPPC				= "MacPPC";
	this.cMACINTEL				= "MacIntel";

	this.cMACIPOD				= "iPod";
	this.cMACIPHONE				= "iPhone";
	this.cMACIPHONESIMULATOR	= "iPhone Simulator";
	this.cMACIPAD				= "iPad";

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
	this.cOPERA					= "Opera";
	this.cUNSUPPORT				= "Unsupport";

	/* Member variables */
	this.mPlatform		= navigator.platform;
	this.mUserAgent		= navigator.userAgent;

	this.mBrowserCtrl	= null;						/* 감지된 브라우저의 컨트롤에 대한 포인터로 getBrowserName에서 설정되는 값이다.  */
	this.mBrowser		= this.getBrowserName();
	this.mVersion		= this.getBrowserVersion();
}

XWBrowser.prototype = {
	getBrowserName : function ()
	{
		var result;

		if (this.mUserAgent.indexOf (this.cMSIE) != -1)				// Explorer
		{
			this.mBrowserCtrl = XWMSIECtrl;
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
			if (this.mUserAgent.indexOf ("Mobile") != -1)			// Mobile Safari
			{
				result = this.cMOBILESAFARI;
			}
			else
			{
				this.mBrowserCtrl = XWSafariCtrl;
				result = this.cSAFARI;
			}
		}

		else if (this.mUserAgent.indexOf (this.cOPERA) != -1)			// Opera
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
		else if (this.mBrowser == this.cXECUREWEBIPHONE)
		{
			fromIndex = this.mUserAgent.indexOf (this.cXECUREWEBIPHONE);
			fromIndex += this.cXECUREWEBIPHONE.length;
			result = this.mUserAgent.substring (fromIndex + 1);
			result = result.substring (0, result.indexOf (" "));
		}
		else
			result = 0;

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
		 * 지원되는 OS
		 * - windows 32bit
		 *------------------------------------------------------------------------------------*/
		else if (aBrowser == this.cMSIE)
		{
			if (aPluginFlag == 0)
				XWBrowserCtrl = XWMSIECtrl;
			else
				XWBrowserCtrl = XWFileMSIECtrl;

			result = "<object ";
			result += "id=\"" + XWBrowserCtrl.mName + "\" ";
			result += "classid=\"" + XWBrowserCtrl.mCID + "\" ";
			result += "codebase=\"" + XWBrowserCtrl.mCodeBase + "\" ";
			result += "width=0 height=0>";
			result += "<param name=\"LICENSE\"     value=\""	+ XWBrowserCtrl.mLicense + "\">";
			result += "<param name=\"storage\"     value=\""	+ XWBrowserCtrl.mStorage + "\">";
			result += "<param name=\"sec_option\"  value=\""	+ XWBrowserCtrl.mSecOption + "\">";
			result += "<param name=\"SECKEY\"      value=\""	+ XWBrowserCtrl.mSecKey + "\">";
			result += "<param name=\"sec_context\" value=\""	+ XWBrowserCtrl.mSecContext + "\">";
			result += "No XecureWeb PlugIn";
			result += "</object>";

			if (this.mPlatform.indexOf (this.cWIN32) == -1)
				result = this.mPlatform + "는 지원하지 않는 운영체제입니다.";
		}

		/*------------------------------------------------------------------------------------
		 * Firefox
		 * 지원되는 OS
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
			result += "<param name=\"LICENSE\"     value=\""	+ XWBrowserCtrl.mLicense + "\">";
			result += "<param name=\"storage\"     value=\""	+ XWBrowserCtrl.mStorage + "\">";
			result += "<param name=\"sec_option\"  value=\""	+ XWBrowserCtrl.mSecOption + "\">";
			result += "<param name=\"SECKEY\"      value=\""	+ XWBrowserCtrl.mSecKey + "\">";
			result += "<param name=\"sec_context\" value=\""	+ XWBrowserCtrl.mSecContext + "\">";
			result += "No XecureWeb PlugIn";
			result += "</object>";

			if (this.mPlatform.indexOf (this.cWIN32) != -1
				|| this.mPlatform.indexOf (this.cLINUX) != -1
				|| this.mPlatform.indexOf (this.cMAC) != -1)
			{
				if (this.mPlatform == this.cWIN64)
					result = this.mPlatform + "는 지원하지 않는 운영체제입니다.";
			}

			else
				result = this.mPlatform + "는 지원하지 않는 운영체제입니다.";
		}

		/*------------------------------------------------------------------------------------
		 * Chrome
		 * 지원되는 OS
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
			result += "<param name=\"LICENSE\"     value=\""	+ XWBrowserCtrl.mLicense + "\">";
			result += "<param name=\"storage\"     value=\""	+ XWBrowserCtrl.mStorage + "\">";
			result += "<param name=\"sec_option\"  value=\""	+ XWBrowserCtrl.mSecOption + "\">";
			result += "<param name=\"SECKEY\"      value=\""	+ XWBrowserCtrl.mSecKey + "\">";
			result += "<param name=\"sec_context\" value=\""	+ XWBrowserCtrl.mSecContext + "\">";
			result += "No XecureWeb PlugIn";
			result += "</object>";

			if (this.mPlatform.indexOf (this.cWIN32) == -1)
			{
				result = this.mPlatform + "는 지원하지 않는 운영체제입니다.";
			}
		}

		/*------------------------------------------------------------------------------------
		 * Safari
		 * 지원되는 OS
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
			result += "<param name=\"LICENSE\"     value=\""	+ XWBrowserCtrl.mLicense + "\">";
			result += "<param name=\"storage\"     value=\""	+ XWBrowserCtrl.mStorage + "\">";
			result += "<param name=\"sec_option\"  value=\""	+ XWBrowserCtrl.mSecOption + "\">";
			result += "<param name=\"SECKEY\"      value=\""	+ XWBrowserCtrl.mSecKey + "\">";
			result += "<param name=\"sec_context\" value=\""	+ XWBrowserCtrl.mSecContext + "\">";
			result += "No XecureWeb PlugIn";
			result += "</object>";

			/*
			if (!(this.mPlatform.indexOf (this.cMAC) != -1
				  || this.mPlatform.indexOf (this.cWIN32) != -1))
			{
				result = this.mPlatform + "는 지원하지 않는 운영체제입니다.";
			}
			*/

		}

		/*------------------------------------------------------------------------------------
		 * XecureWeb for iPhone
		 * 지원되는 OS
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
				result += "XWiPhone.CreateObject.begin ();";

			result += "</script>";
		}

		/*------------------------------------------------------------------------------------
		 * Android Webkit
		 * 지원되는 OS   
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
		 * 지원되는 OS
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
			result += "<param name=\"LICENSE\"     value=\""	+ XWBrowserCtrl.mLicense + "\">";
			result += "<param name=\"storage\"     value=\""	+ XWBrowserCtrl.mStorage + "\">";
			result += "<param name=\"sec_option\"  value=\""	+ XWBrowserCtrl.mSecOption + "\">";
			result += "<param name=\"SECKEY\"      value=\""	+ XWBrowserCtrl.mSecKey + "\">";
			result += "<param name=\"sec_context\" value=\""	+ XWBrowserCtrl.mSecContext + "\">";
			result += "No XecureWeb PlugIn";
			result += "</object>";

			if (this.mPlatform.indexOf (this.cWIN32) == -1)
				result = this.mPlatform + "는 지원하지 않는 운영체제입니다.";
		}

		/*------------------------------------------------------------------------------------
		 * Netscape 6.0
		 * 지원되는 OS
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
				result = this.mPlatform + "는 지원하지 않는 운영체제입니다.";
		}

		/*------------------------------------------------------------------------------------
		 * Netscape 4.0
		 * 지원되는 OS
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
				result = this.mPlatform + "는 지원하지 않는 운영체제입니다.";
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

		xecuremime = navigator.mimeTypes [this.mBrowserCtrl.mType];

		if (xecuremime)
		{
			result = this.checkCtrlVersion(xecuremime.enabledPlugin.description, aVersion);
		}
		else
			result = true;


		return result;
	},

	checkCtrlVersion : function (aDesc, aVersion)
	{
		var index = aDesc.indexOf('v.', 0);
		if (index < 0)	return false;

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
	}
};

var gXWBrowser = new XWBrowser();



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
		if (aPlatForm.indexOf (gXWBrowser.cWIN) != -1)
			aVersion = XWFirefoxCtrl.mWinVersion;
		else if (aPlatForm.indexOf (gXWBrowser.cLINUX) != -1)
			aVersion = XWFirefoxCtrl.mLinuxVersion;
		else if (aPlatForm.indexOf (gXWBrowser.cMAC) != -1)
			aVersion = XWFirefoxCtrl.mMacVersion;
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
		else if (aPlatForm.indexOf (gXWBrowser.cMACIPAD) != -1)
			aVersion = XWIphoneCtrl.mMacVersion;
	}

	else if (aBrowser == gXWBrowser.cOPERA)
	{
		if (aPlatForm.indexOf (gXWBrowser.cWIN) != -1)
			aVersion = XWOperaCtrl.mWinVersion;
		else if (aPlatForm.indexOf (gXWBrowser.cLINUX) != -1)
			aVersion = XWOperaCtrl.mLinuxVersion;
	}

	else
	{
		aVersion = null;
	}
/*
	if (aResult == false && aVersion == null)
	{
		alert ("XecureWeb은 이 브라우저 " + aBrowser + "는 지원하지 않습니다.");
		return false;
	}
*/
	if (gXWBrowser.checkCtrl (aVersion))
	{
		aResult = false;
	}
	else
		aResult = true;

	if (aResult)
	{
		aObjectTag = gXWBrowser.getObjectTag(0);
		document.write (aObjectTag);
	}

	if (document.XecureWeb == undefined)
	{
		// edited by sunil for android browser
		// this is not a permanent solution, I'll fix it later.
		if (window.XecureWeb) {
			document.XecureWeb = window.XecureWeb;
		}
		else {
			document.XecureWeb = document.getElementById ("XecureWeb");
		}
	}
}

var agt=navigator.userAgent.toLowerCase();
var is_gecko = (agt.indexOf('gecko') != -1);
var is_linux = (agt.indexOf('linux') != -1);

//////////////////////////////////////////////////////////////////////////////////
//	Xecure 함수들....
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

function IsSafari()
{
	var kitName = "applewebkit/";
	var tempStr = navigator.userAgent.toLowerCase();
	var pos = tempStr.indexOf(kitName);
	var pos_ppc = tempStr.indexOf("ppc");
	var isAppleWebkit = (pos != -1);
	var isppc = (pos_ppc != -1);

	/* Android 2.1에서는 link.host가 reaver.softforum.com:8080 이였는데 반해 */
	/* Android 2.2에서는 link.host가 reaver.softforum.com이 되었음 */
	if (tempStr.indexOf("android 2.2") != -1)
	{
		return 0;
	}
	else if (isAppleWebkit && isppc) 
	{
		return 1;
	} 
	else if (isAppleWebkit)
	{
		return 2;
	}
	else 
	{
		return 0;
	}
}

function XecureUnescape(Msg)		// by Zhang
{
	if(IsNetscape() && !is_gecko)
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
		if(confirm("에러코드 : " + errCode + "\n\n" + XecureUnescape(errMsg) + "\n\n 인증서관리창을 열겠습니까?"))
			ShowCertManager() ;
	}
	else
	{

		alert( "에러코드 : " + errCode + "\n\n" + XecureUnescape(errMsg) );
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

function RequestCertificate ( type, ref_code, auth_code )
{
	var r;
	var ca_type;
	var ca_ip;
	var ca_port;

	if(type == 10) {
		ca_type = yessign_ca_type;
		ca_ip = yessign_ca_ip;
		ca_port = yessign_ca_port;
	}
	else if(type == 11) {
		ca_type = xecure_ca_type;
		ca_ip = xecure_ca_ip;
		ca_port = xecure_ca_port;
	}
	else if(type == 12) {

		ca_type = xecure_ca_type_1;
	ca_ip = xecure_ca_ip_1;
		ca_port = xecure_ca_port_1;

	}
	else if(type == 13)
	{
		ca_type = signgate_ca_type;
		ca_ip = signgate_ca_ip;
		ca_port = signgate_ca_port;	
	}
	else if(type == 24)
	{//정보인증,기존 mpki가 14를 쓰고 있음
		ca_type = crosscert_ca_type;
		ca_ip = crosscert_ca_ip;
		ca_port = crosscert_ca_port;	
	}		
	
	else if(type == 25)
	{//코스콤,기존 mpki가 15를 쓰고 있음
		ca_type = signkorea_ca_type;
		ca_ip = signkorea_ca_ip;
		ca_port = signkorea_ca_port;	
	}		
		
	else if(type == 14||type==15) {
		ca_type = mpki_ca_type;
		ca_ip = mpki_ca_ip;
		ca_port = mpki_ca_port;
	}
	else {
		alert("Input type error!");
		return 0;
	}
	
	if(type==14){
		r = document.XecureWeb.RequestCertificateEx(ca_port, ca_ip, ref_code, auth_code, ca_type, 2, mpki_ca_name, mpki_ra_name);
	}else{
		r = document.XecureWeb.RequestCertificate ( ca_port, ca_ip, ref_code, auth_code, ca_type);
	}

	if ( r != 0 )	XecureWebError();
	
	return r;
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
		cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
		gIsContinue = 0;
	}
	else {
		return false;
	}
			
	if( cipher == "" )	return XecureWebError();
	
	xecure_url = path + "?q=" + escape_url(cipher)+"&charset=" + "UTF-8";
	// adding character set information

	if (feature=="" || feature==null) open ( xecure_url, target );
	else open(xecure_url, target, feature );

	return true;
}

function XecureLink( link )
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
			cipher = document.XecureWeb.BlockEncEx(xgate_addr, path, XecureEscape(qs),"GET",accept_cert);

			if ( hash.length == 1 )
			{
				/* Safari set the '#' as location.hash
				   But another broswer doen't set any value when the location doesn't have any hash
				   So it should be erased
				   */
				hash ="";
			}
		}
		cipher = document.XecureWeb.BlockEncEx(xgate_addr, path, XecureEscape(qs),"GET",accept_cert);
		gIsContinue = 0;
	}
	else {
		return false;
	}

	if( cipher.length == 0)	
	{
		return XecureWebError() ;
	}

	if( link.hostname.length > link.host.length)
	{
		xecure_url = "http://" + link.hostname + path + hash + "?q=" + escape_url(cipher)+"&charset=" + "UTF-8";
	}
	else
	{
		xecure_url = "http://" + link.host + path + hash + "?q=" + escape_url(cipher)+"&charset=" + "UTF-8";
	}

	if(usePageCharset) {
	}
	
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
			cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
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
			cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
			gIsContinue = 0;
		}
		else {
			return false;
		}		


		if( cipher == "" )	return XecureWebError() ;

		document.xecure.action = path + "?q=" + escape_url(cipher);
		// adding character set information
		if(usePageCharset) {
			if(is_linux || IsSafari())
				document.xecure.action += "&charset=" + "UTF-8";
			else 
				document.xecure.action += "&charset=" + "euc-kr";

		}

		posting_data = XecureMakePlain( form );
		//alert (posting_data);

		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			cipher = document.XecureWeb.BlockEnc ( xgate_addr, path, XecureEscape(posting_data), "POST" );
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

function XecureMakePlain(form)	// modified by tiger on 2004/12/22
{
	var name = new Array(form.elements.length);
	var value = new Array(form.elements.length);
	var flag = false;
	var j = 0;
	var plain_text="";
	var	 tmpstr="";

	//for softcamp
	if(document.secukey==null || typeof(document.secukey) == "undefined" || document.secukey.object==null) {
		enable=false;
	}
	else {
		enable=secukey.GetSecuKeyEnable();
	}

	len = form.elements.length;
	for (i = 0; i < len; i++) {
		if ((form.elements[i].type != "button") && (form.elements[i].type != "reset") && (form.elements[i].type != "submit")) {
			if (form.elements[i].type == "radio" || form.elements[i].type == "checkbox") {
				if (form.elements[i].checked == true) {
					if (form.elements[i].disabled == false) {
						name[j] = form.elements[i].name;
						value[j] = form.elements[i].value;
						j++;
					}
				}
			}
			//for softcamp
			else if(enable && form.elements[i].type == "password"){
				if(form.elements[i].type == "password"){
					name[j] = form.elements[i].name;
					value[j] = secukey.GetRealPass(form.elements[i].name,form.elements[i].value);
					j++;
				}
			}
			else {
				name[j] = form.elements[i].name;
				if (form.elements[i].type == "select-one") {
					var ind = form.elements[i].selectedIndex;
					var op_len = form.elements[i].length;
					if (op_len > 0) {
						if(ind > 0) {
							if (form.elements[i].options[ind].value != '')
								value[j] = form.elements[i].options[ind].value;
							else
								//value[j] = form.elements[i].options[ind].text;
								value[j] = "";
						} else {
							if(ind == 0)
							{
								if (form.elements[i].options[ind].value != '')
									value[j] = form.elements[i].options[ind].value;
								else
									//value[j] = form.elements[i].options[ind].text;
									value[j] = "";
							}
						}
						// form.elements[i].selectedIndex = 0;
					}
				}
				else if (form.elements[i].type == "select-multiple") {
					var llen = form.elements[i].length;
					var increased = 0;
					for( k = 0; k < llen; k++) {
						if (form.elements[i].options[k].selected) {
							name[j] = form.elements[i].name;
							if (form.elements[i].options[k].value != '')
								value[j] = form.elements[i].options[k].value;
							else
								//value[j] = form.elements[i].options[k].text;
								value[j] = "";
							j++;
							increased++;
						}
					}
					if(increased > 0) {
						j--;
					}
					else {
						value[j] = "";
					}
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
		if (value[i] !="undefined"){
			plain_text += value[i];
		}else {
			plain_text += "";
		}
	}

	return plain_text;
}

function BlockEnc(auth_type,plain_text)
{	
	var cipher = "";
	cipher =  XecureUnescape(document.XecureWeb.BlockEnc(xgate_addr,auth_type,plain_text,"GET"));		
		
	if( cipher == "" ) XecureWebError() ;
	
	return cipher;
}

function EndSession()
{
	document.XecureWeb.EndSession(xgate_addr);
}

function PutCertificate(type)
{
	//#define	PUT_CERT_TYPE_ROOT		0
	//#define	PUT_CERT_TYPE_CA		1
	//#define	PUT_CERT_TYPE_SERVER	2
	//#define	PUT_CERT_TYPE_USER		3
	//#define	PUT_CERT_TYPE_OTHER		4
	var r ;
	
	r = document.XecureWeb.PutCertificate( XecureEscape(pCaCertName), pCaCertUrl, type);

	if( r != 0 )	XecureWebError() ;
}

function PutCACert()
{
	var r ;
	
	r = document.XecureWeb.PutCACert( XecureEscape(pCaCertName), pCaCertUrl);

	if( r != 0 )	XecureWebError() ;
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

// nOption is 0 : (default value) File version, which is checked by 'Internet Explorer'
//            1 : Product version
//            2 : File Description
function GetVersion(nOption)
{
	var ver;
	
	ver = document.XecureWeb.GetVerInfo(nOption);
	if( ver == "" )
		alert("No version information");
	
	return ver;
}

//Infovine
function PutMPhoneData()
{
    var bankUrl = "WOORIBANK|http://test.ubikey.co.kr/infovine/1023_1022/DownloadList";
	var coUrl = "SOFTFORUM|KINGS";
	var popUrl = "http://test.ubikey.co.kr/infovine/1023_1022/download.html|width=450,height=400,left=10,top=10";
	var mphone_data = "MPHONE:" + xgate_addr + "&" + bankUrl + "&" + coUrl + "&" + popUrl + "|" + window.location.hostname;

	if( IsSafari() || is_gecko )
	{
		return;
	}

	var version = document.XecureWeb.GetVerInfo(1);


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
}

function Sign_with_option (option, plain, callback)
{
	var signed_msg;

	PutMPhoneData();

	signed_msg = document.XecureWeb.SignDataCMS (xgate_addr,
												 XecureEscape(accept_cert), 
												 XecureEscape(plain), 
												 option, 
												 "",
												 pwd_fail);

    if( signed_msg == "" )	XecureWebError();

    if (callback)
	window[callback](signed_msg);
    else
	return signed_msg;
}

function send_vid_info ()
{
	var	aResult;

	aResult = document.XecureWeb.GetVidInfo ();

    if (aResult == "")
	{
		XecureWebError ();
	}

	return aResult;
}

function Sign_with_vid_user (aOption, aData, aPEM, callback)
{
	var aResult;

	if ((aOption & 4) == 0)
	{
		aOption += 4;
	}

	aResult = document.XecureWeb.SignDataWithVID (xgate_addr,
												  accept_cert,
												  aData,
												  aPEM,
												  aOption,
												  "",
												  pwd_fail);

    if (aResult == "")
	{
		XecureWebError ();
	}

    if (callback)
		window[callback](aResult, document.XecureWeb.GetVidInfo());
    else
		return aResult;
}

function Set_ID_Num(idn)
{
	var ret;

	ret = document.XecureWeb.SetIDNum(idn);

	return ret;
}

function Sign_with_vid_web (aOption, aData, aPEM, aIDN, callback)
{
	var aResult;

	if ((aOption & 4) == 0)
	{
		aOption += 4;
	}
	
	if ((aOption & 8) == 0)
	{
		aOption += 8;
	}

	aResult = Set_ID_Num (aIDN);

	if (aResult != 0)
	{
		XecureWebError ();

		return "";
	}

	aResult = document.XecureWeb.SignDataWithVID (xgate_addr,
												  accept_cert,
												  aData,
												  aPEM,
												  aOption,
												  "",
												  pwd_fail);

    if (aResult == "")
	{
		XecureWebError ();
	}

    if (callback)
		window[callback](aResult, document.XecureWeb.GetVidInfo());
    else
		return aResult;
}

function EnvelopData (inMsg, pwd, certPem, envOption, callback)
{
	var envMsg;

	envMsg = document.XecureWeb.EnvelopData (xgate_addr,
											 XecureEscape(accept_cert), 
											 XecureEscape(inMsg), 
											 envOption, 
											 pwd, 
											 certPem, 
											 "", 
											 0, 
											 "", 
											 3);

   	if (envMsg == "")
	{
		XecureWebError ();
   	}

    if (callback)
		window[callback](envMsg);
	else
	    return envMsg;
}

function DeEnvelop (data, callback)
{
	var r;

	r = document.XecureWeb.DeEnvelopData (xgate_addr, 
										  accept_cert, 
										  data, 
										  0,
										  "", 
										  "", 
										  3);

	if (r == "")
	{
		XecureWebError();
		return false;
	}

    if (callback)
		window[callback](r);
	else
	    return r;
}

// servlet에서 applet으로 보내준 값을 복호화 하는 function
function dec(str) {
	var result=BlockDec(str);
	return result;
}

function Sign_with_serial( certSerial, certLocation, plain, option )
{
	var	signed_msg;

	signed_msg = document.XecureWeb.SignDataCMSWithSerial(  xgate_addr, 
								XecureEscape(accept_cert), 
								certSerial, 
								certLocation, 
								plain, 
								option, 
								"",
								pwd_fail );

	if( signed_msg == "" )	XecureWebError();

	return signed_msg;	
}


function XecureLogIn(aLink)
{
    document.XecureWeb.EndSession(xgate_addr);
    XecureLink(aLink);
}

function BlockDec(aCipher)
{
    var aPlain = document.XecureWeb.BlockDec(xgate_addr, aCipher);

    var encryptionArea = document.createElement('div');
	document.body.appendChild(encryptionArea);

    if (aPlain == "")
    {
        XecureWebError ();
    }
    encryptionArea.innerHTML = unescape (aPlain);
}

function HasCertificate(aRDN, aUserCallBack)
{
    var aResult = document.XecureWeb.HasCertificate(aRDN);
    if (aUserCallBack)
	window[aUserCallBack](aResult);
}

function SetAttribute(aName, aValue, aUserCallBack)
{
    document.XecureWeb.SetAttribute(aName, aValue);
    if (aUserCallBack)
	window[aUserCallBack]();
}

function GetAttribute(aName, aUserCallBack)
{
    var aResult = document.XecureWeb.GetAttribute(aName);
    if (aUserCallBack)
	window[aUserCallBack](aResult);
}


/**
 * JobQueue class
 * @brief This class can receive jobs, and Run it. Because All of jobs should run after page was loaded, this queue is checking runnable until page is loaded.
 */
JobQueue = new Object();
JobQueue.queue = new Array();

JobQueue.push = function (aObject)
{
	if (JobQueue.timer == null)
		JobQueue.timer = setInterval (JobQueueRunner, 1);
	JobQueue.queue.push (aObject);
}

JobQueue.shift = function ()
{
	return JobQueue.queue.shift ();
}

JobQueue.timer = null;

JobQueue.isRun = false;
JobQueueRunner = function ()
{
	var aJob = null;
	var aFunction = null;

	if (
		document.readyState != 'loaded' &&
		document.readyState != 'complete'
		)
		return;

	if (JobQueue.isRun == true) return;

	JobQueue.isRun = true;

	aJob = JobQueue.shift ();

	aFunction = eval(aJob[0]);
	aFunction (aJob[1], aJob[2], aJob[3]);

	if (JobQueue.queue.length == 0)
	{
		clearInterval (JobQueue.timer);
		JobQueue.timer = null;
	}
}


var XWiPhone = new Object ();

XWiPhone.result = null;
XWiPhone.callback = "";

XWiPhone.setResult = function ()
{
	JobQueue.isRun = false;
	this.result = arguments[0];
}

XWiPhone.sendMessage = function ()
{
	var aParentPointer = null;
	var aCallBack = "";
	var aURL = null;
	var aQuery = [];
	var aName = null;
	var aValue = null;
	var aIter = 0;
	var aMode = 0;
	var aParameter = null;

	switch (arguments[0])
	{
		case "LastErrCode":
		case "LastErrMsg":
		case "CreateObject":
		case "SetAttribute":
		case "GetAttribute":
		case "BlockEnc":
		case "BlockEncEx":
		case "BlockDec":
		case "HasCertificate":
		case "SignDataCMS":
		case "SignDataWithVID":
			aMode = 0;		// location
			break;
		default:
			aMode = 0;		// location
			break;
	}

	if (arguments[0] == "CreateObject")
	{
		aParentPointer = self;

		while (aParentPointer.name.length != 0)
		{
			if (aParentPointer.name.indexOf ("framePath") != -1)
			{
				alert ("If you use frame, you MUST set [name] attribute!");
				return;
			}
			if (aCallBack.length == 0)
				aCallBack = aParentPointer.name + ".";
			else
				aCallBack = aParentPointer.name + "." + aCallBack;

			aParentPointer = aParentPointer.parent;
		}

		this.callback = aCallBack;
	}
	else if (document.XecureWeb == null)
	{
		PrintObjectTag ();
	}
	//if (document.XecureWeb)

	try
	{
		aCallBack = this.callback;

		aCallBack += arguments[1];

		if (aMode == 0)
		{
			aParameter = arguments[2];
		}
		else
		{
			aParameter = new Array ();

			for (aIter = 0;aIter < arguments[2].length;aIter++)
				aParameter.push (arguments[2][aIter]);
		}

		aURL = "XecureSmart://XecureWeb." + arguments[0] + "/" + aCallBack;

		if (aParameter != null)
		{
			if (arguments[0] == "CreateObject")
			{
				/* Named Array */
				for (var aName in aParameter)
				{
					aValue = aParameter[aName];
					aQuery.push (encodeURIComponent (aName) + "=" + encodeURIComponent (aValue));
				}
			}
			else
			{
				/* anonymous Array (based on integer) */
				for (var aIter = 0; aIter < aParameter.length; ++aIter)
				{
					var aName = aParameter[aIter];

					aQuery.push (encodeURIComponent (aIter) + "=" + encodeURIComponent (aName));
				}
			}

			if (aQuery.length > 0)
			{
				aURL += "?" + aQuery.join("&");
			}

		}
	}
	catch (err)
	{
		alert ("ERR:" + err);
	}

	if (aMode == 0)
	{
		document.location = aURL;
	}
	else
	{
		alert (aURL);

		return this.result;
	}
}


XWiPhone.XecureWeb = new Object ();

XWiPhone.XecureWeb.SignDataCMS = function ()
{
	return XWiPhone.sendMessage ("SignDataCMS",
								 "XWiPhone.setResult",
								 arguments);
}

XWiPhone.XecureWeb.SetIDNum = function ()
{
	return XWiPhone.sendMessage ("SetIDNum",
								 "XWiPhone.setResult",
								 arguments);
}

XWiPhone.XecureWeb.GetVidInfo = function ()
{
	return XWiPhone.sendMessage ("GetVidInfo",
								 "XWiPhone.setResult",
								 arguments);
}

XWiPhone.XecureWeb.SignDataWithVID = function ()
{
	return XWiPhone.sendMessage ("SignDataWithVID",
								 "XWiPhone.setResult",
								 arguments);
}

XWiPhone.XecureWeb.SignDataCMSWithSerial = function ()
{
	return XWiPhone.sendMessage ("SignDataCMSWithSerial",
								 "XWiPhone.setResult",
								 arguments);
}

XWiPhone.XecureWeb.SignDataWithVID_Serial = function ()
{
	return XWiPhone.sendMessage ("SignDataWithVID_Serial",
								 "XWiPhone.setResult",
								 arguments);
}
XWiPhone.XecureWeb.BlockEnc = function ()
{
	JobQueue.push(["XWiPhone.sendMessage", "BlockEnc", "XWiPhone.setResult", arguments]);
}

XWiPhone.XecureWeb.EndSession = function ()
{
	JobQueue.push(["XWiPhone.sendMessage", "EndSession", "XWiPhone.setResult", arguments]);
}

XWiPhone.XecureWeb.EnvelopData = function ()
{
	return XWiPhone.sendMessage ("EnvelopData",
								 "XWiPhone.setResult",
								 arguments);
}

XWiPhone.XecureWeb.DeEnvelopData = function ()
{
	return XWiPhone.sendMessage ("DeEnvelopData",
								 "XWiPhone.setResult",
								 arguments);
}

XWiPhone.XecureWeb.RequestCertificate = function ()
{
	/* In further implements, follow this methods. */
	JobQueue.push (["XWiPhone.sendMessage",
			"RequestCertificate",
			"XWiPhone.setResult",
			arguments]);
}

XWiPhone.XecureWeb.RequestCertificateEx = function ()
{
	JobQueue.push (["XWiPhone.sendMessage",
			"RequestCertificateEx",
			"XWiPhone.setResult",
			arguments]);
}

XWiPhone.XecureWeb.RenewCertificate = function ()
{
	return XWiPhone.sendMessage ("RenewCertificate",
								 "XWiPhone.setResult",
								 arguments);
}

XWiPhone.XecureWeb.RevokeCertificate = function ()
{
	return XWiPhone.sendMessage ("RevokeCertificate",
								 "XWiPhone.setResult",
								 arguments);
}

XWiPhone.XecureWeb.GetHWInfo = function ()
{
	return XWiPhone.sendMessage ("GetHWInfo",
								 "XWiPhone.setResult",
								 arguments);
}

XWiPhone.XecureWeb.GetUserHWInfo = function ()
{
	return XWiPhone.sendMessage ("GetUserHWInfo",
								 "XWiPhone.setResult",
								 arguments);
}

XWiPhone.XecureWeb.LastErrMsg = function ()
{
	return XWiPhone.sendMessage ("LastErrMsg",
								 "XWiPhone.setResult",
								 arguments);
}

XWiPhone.XecureWeb.LastErrCode = function ()
{
	return XWiPhone.sendMessage ("LastErrCode",
								 "XWiPhone.setResult",
								 arguments);
}

// CreateObject
XWiPhone.CreateObject = new Object ();
XWiPhone.CreateObject.begin = function ()
{
	XecureLogIn			= XWiPhone.XecureLogIn.begin;
	XecureLink			= XWiPhone.XecureLink.begin;
	XecureNavigate		= XWiPhone.XecureNavigate.begin;
	XecureSubmit		= XWiPhone.XecureSubmit.begin;
	XecureWebError		= XWiPhone.XecureWebError.begin;
	BlockDec			= XWiPhone.BlockDec.begin;
	PutCACert			= XWiPhone.PutCACert.begin;
	HasCertificate		= XWiPhone.HasCertificate.begin;
	SetAttribute		= XWiPhone.SetAttribute.begin;
	GetAttribute		= XWiPhone.GetAttribute.begin;
	Sign_with_option	= XWiPhone.Sign_with_option.begin;
	Sign_with_vid_user	= XWiPhone.Sign_with_vid_user.begin;
	Sign_with_vid_web	= XWiPhone.Sign_with_vid_web.begin;
	EnvelopData			= XWiPhone.EnvelopData.begin;
	DeEnvelop			= XWiPhone.DeEnvelop.begin;

	var aArguments = [];

	aArguments["id"]			= XWIphoneCtrl.mName;
	aArguments["type"]			= XWIphoneCtrl.mType;
	aArguments["license"]		= XWIphoneCtrl.mLicense;
	aArguments["storage"]		= XWIphoneCtrl.mStorage;
	aArguments["sec_option"]	= XWIphoneCtrl.mSecOption;
	aArguments["seckey"]		= XWIphoneCtrl.mSecKey;
	aArguments["sec_context"]	= XWIphoneCtrl.mSecContext;

	JobQueue.push (["XWiPhone.sendMessage",
					"CreateObject",
					"XWiPhone.CreateObject.callback",
					aArguments]);
}

XWiPhone.CreateObject.callback = function (aResult)
{
	if (aResult == true)
	{
		document.XecureWeb = XWiPhone.XecureWeb;
	}

	JobQueue.isRun = false;
}


// XecureLogIn
XWiPhone.XecureLogIn = new Object ();
XWiPhone.XecureLogIn.link = null;
XWiPhone.XecureLogIn.begin = function (aLink)
{
	var aArguments = null;

	XWiPhone.XecureLogIn.link = aLink;
	aArguments = [xgate_addr];

	JobQueue.push (["XWiPhone.sendMessage",
					"EndSession",
					"XWiPhone.XecureLogIn.callback",
					aArguments]);

	return false;
}
XWiPhone.XecureLogIn.callback = function (aVoid)
{
	JobQueue.isRun = false;
	XecureLink (XWiPhone.XecureLogIn.link);
}

// XecureLink
XWiPhone.XecureLink = new Object ();
XWiPhone.XecureLink.link = null;
XWiPhone.XecureLink.begin = function (aLink)
{
	var aQuery = null;
	var aArguments = null;

	if (gIsContinue != 0)
	{
		return false;
	}

	XWiPhone.XecureLink.link = aLink;

	aQuery = aLink.search;
	if (aQuery.length > 1)
	{
		aQuery = aQuery.substring (1);
	}

	gIsContinue = 1;

	aArguments = [xgate_addr, XecurePath (aLink.pathname), aQuery, "GET", accept_cert];

	JobQueue.push (["XWiPhone.sendMessage",
					"BlockEncEx",
					"XWiPhone.XecureLink.callback",
					aArguments]);

	return false;
}
XWiPhone.XecureLink.callback = function (aCipher)
{
	var aURL = null;
	var aLink = null;
	var aHost = null;

	if (aCipher.length == 0)
	{
		XecureWebError();
	}

	aLink = XWiPhone.XecureLink.link;

	if (aLink.hostname.length > aLink.host.length)
		aHost = aLink.hostname;
	else 
		aHost = aLink.host;

	aURL = "http://" + aHost + XecurePath (aLink.pathname) + "?q=" + escape_url (aCipher) + "&charset=" + document.charset;

	gIsContinue = 0;

	open (aURL, "_self" );

	JobQueue.isRun = false;
}

// XecureNavigate
XWiPhone.XecureNavigate = new Object ();
XWiPhone.XecureNavigate.path = null;
XWiPhone.XecureNavigate.target = null;
XWiPhone.XecureNavigate.feature = null;
XWiPhone.XecureNavigate.begin = function (aURL, aTarget, aFeature)
{

	var aQuery = null;
	var aArguments = null;
	var aPath = null;
	var aQueryStringBeginIndex = 0;

	if (gIsContinue != 0)
	{
		return false;
	}

	aPath = getPath (aURL);
	aQueryStringBeginIndex = aURL.indexOf ("?");

	if (aQueryStringBeginIndex < 0)
		aQuery = "";
	else
		aQuery = aURL.substring (aQueryStringBeginIndex + 1 , aURL.length);

	gIsContinue = 1;


	XWiPhone.XecureNavigate.path = aPath;
	XWiPhone.XecureNavigate.target = aTarget;
	XWiPhone.XecureNavigate.feature = aFeature;

	aArguments = [xgate_addr, aPath, XecureEscape(aQuery), "GET"];

	JobQueue.push (["XWiPhone.sendMessage",
					"BlockEnc",
					"XWiPhone.XecureNavigate.callback",
					aArguments]);

	return false;
}

XWiPhone.XecureNavigate.callback = function (aCipher)
{
	var aURL = null;
	var aTarget = null;
	var aFeature = null;

	if (aCipher.length == 0)
	{
		XecureWebError();
	}

	aURL = XWiPhone.XecureNavigate.path + "?q=" + escape_url (aCipher) + "&charset=UTF-8";

	aTarget = XWiPhone.XecureNavigate.target;
	aFeature = XWiPhone.XecureNavigate.feature;
	gIsContinue = 0;

	if (aFeature == "" || aFeature == null)
	{
		open (aURL, aTarget);
	}
	else
	{
		open (aURL, aTarget, aFeature);
	}

	JobQueue.isRun = false;
}


// XecureSubmit
XWiPhone.XecureSubmit = new Object ();
XWiPhone.XecureSubmit.method = "";
XWiPhone.XecureSubmit.path = "";
XWiPhone.XecureSubmit.queryString = "";
XWiPhone.XecureSubmit.cipherBuffer = new Array ();
XWiPhone.XecureSubmit.begin = function (aForm)
{
	var aQuery = null;
	var aArguments = null;
	var aPath = null;
	var aQueryStringBeginIndex = 0;

	aQueryStringBeginIndex = aForm.action.indexOf('?');

	aPath = getPath (aForm.action);
	XWiPhone.XecureSubmit.path = aPath;
	if (aQueryStringBeginIndex < 0)
		XWiPhone.XecureSubmit.queryString = "";
	else
		XWiPhone.XecureSubmit.queryString = aForm.action.substring (aQueryStringBeginIndex + 1, aForm.action.length);

	document.xecure.target = aForm.target;

	if (gIsContinue != 0)
	{
		alert (busy_info);
		return false;
	}

	gIsContinue = 1;
	XWiPhone.XecureSubmit.method = aForm.method.toLowerCase ();
	if (aForm.method.toLowerCase () == "get")
	{

		if (XWiPhone.XecureSubmit.queryString.length != 0)
			XWiPhone.XecureSubmit.queryString += "&" + XecureMakePlain(aForm);
		else
			XWiPhone.XecureSubmit.queryString = XecureMakePlain(aForm);

		aArguments = [xgate_addr, aPath, XecureEscape (XWiPhone.XecureSubmit.queryString), "GET"];
		JobQueue.push (["XWiPhone.sendMessage",
						"BlockEnc",
						"XWiPhone.XecureSubmit.callback",
						aArguments]);

	}
	else
	{
		XWiPhone.XecureSubmit.method = "post";
		document.xecure.method = "post";

		aArguments = [xgate_addr,
					  aPath,
					  //"",
					  XWiPhone.XecureSubmit.queryString,
					  "GET"];
		JobQueue.push (["XWiPhone.sendMessage",
						"BlockEnc",
						"XWiPhone.XecureSubmit.callback",
						aArguments]);

		aArguments = [xgate_addr,
				   	  aPath,
					  XecureEscape (XecureMakePlain(aForm)),
					  "POST"];
		JobQueue.push (["XWiPhone.sendMessage",
						"BlockEnc",
						"XWiPhone.XecureSubmit.callback",
						aArguments]);
	}
	gIsContinue = 0;

	return false;
}
XWiPhone.XecureSubmit.callback = function (aResult)
{
	var aPath = null;

	aPath = XWiPhone.XecureSubmit.path;
	XWiPhone.XecureSubmit.cipherBuffer.push (aResult);

	if (XWiPhone.XecureSubmit.method == "get")
	{
		var aTarget;

		aPath += "?q=" + escape_url(XWiPhone.XecureSubmit.cipherBuffer.shift ());

		if (document.xecure.target == "" || document.xecure.target == null)
			aTarget = "_self";
		else
			aTarget = document.xecure.target;

		aPath += "&charset=UTF-8";

		open (aPath, aTarget);

	}
	else if (XWiPhone.XecureSubmit.cipherBuffer.length == 2)
	{
		document.xecure.action = aPath +
								 "?q=" +
								 escape_url (XWiPhone.XecureSubmit.cipherBuffer.shift ()) +
								 "&" +
								 "charset=UTF-8";

		document.xecure.p.value = XWiPhone.XecureSubmit.cipherBuffer.shift ();

		document.xecure.submit ();
	}

	JobQueue.isRun = false;
}


// BlockDec
XWiPhone.BlockDec = new Object ();
XWiPhone.BlockDec.count = 0;
XWiPhone.BlockDec.begin = function (aCipher)
{
	var aArguments = [];
	aArguments = [xgate_addr,
			   	  aCipher];
	JobQueue.push (["XWiPhone.sendMessage",
					"BlockDec",
					"XWiPhone.BlockDec.callback",
					aArguments]);

	return "";
}
XWiPhone.BlockDec.callback = function (aPlain)
{
	var encryptionArea = document.getElementById ("XecureSmart_EncryptionAreaID_" + XWiPhone.BlockDec.count);

	XWiPhone.BlockDec.count++;

	if (aPlain == "")
	{
		XecureWebError ();
	}
	encryptionArea.innerHTML = unescape (aPlain);

	JobQueue.isRun = false;
}


XWiPhone.PutCACert = new Object ();
XWiPhone.PutCACert.begin = function ()
{
	var aArguments = [XecureEscape (pCaCertName), pCaCertUrl];

	JobQueue.push (["XWiPhone.sendMessage",
					"PutCACert",
					"XWiPhone.PutCACert.callback",
					aArguments]);
}
XWiPhone.PutCACert.callback = function (aResult)
{
	if (aResult != 0)
	{
		XecureWebError();
	}

	JobQueue.isRun = false;
}

XWiPhone.HasCertificate = new Object ();
XWiPhone.HasCertificate.usercallback = null;
XWiPhone.HasCertificate.begin = function (aRDN, aUserCallBack)
{
	var aArguments = [aRDN];

	if (arguments[1] != undefined)
	{
		XWiPhone.HasCertificate.usercallback = aUserCallBack;
	}
	else
	{
		XWiPhone.HasCertificate.usercallback = null;
	}

	JobQueue.push (["XWiPhone.sendMessage",
					"HasCertificate",
					"XWiPhone.HasCertificate.callback",
					aArguments]);
}
XWiPhone.HasCertificate.callback = function (aResult)
{
	var aFunction = null;

	JobQueue.isRun = false;

	if (XWiPhone.HasCertificate.usercallback != null)
	{
		aFunction = eval (XWiPhone.HasCertificate.usercallback);
		aFunction (aResult);
	}
}


XWiPhone.SetAttribute = new Object ();
XWiPhone.SetAttribute.begin = function (aName, aValue, aCallBack)
{
	var aArguments = [aName, aValue];
	var aCallBackFunction = null;

	if (arguments[2] == undefined)
	{
		aCallBackFunction = "XWiPhone.SetAttribute.callback";
	}
	else
	{
		aCallBackFunction = aCallBack;
	}

	JobQueue.push (["XWiPhone.sendMessage",
					"SetAttribute",
					aCallBackFunction,
					aArguments]);
}
XWiPhone.SetAttribute.callback = function (aResult)
{
	JobQueue.isRun = false;
}

XWiPhone.GetAttribute = new Object ();
XWiPhone.GetAttribute.begin = function (aName, aCallBack)
{
	var aArguments = [aName];
	var aCallBackFunction = null;

	if (arguments[1] == undefined)
	{
		aCallBackFunction = "XWiPhone.GetAttribute.callback";
	}
	else
	{
		aCallBackFunction = aCallBack;
	}

	JobQueue.push (["XWiPhone.sendMessage",
					"GetAttribute",
					aCallBackFunction,
					aArguments]);
}
XWiPhone.GetAttribute.callback = function (aResult)
{
	alert (aResult);

	JobQueue.isRun = false;
}

/* Sign_with_option */
XWiPhone.Sign_with_option = new Object();
XWiPhone.Sign_with_option.usercallback = null;
XWiPhone.Sign_with_option.begin = function (aOption, aPlain, aUserCallBack)
{
	if (arguments[2] == undefined)
	{
		alert ("aUserCallBack parameter is not set");
		return;
	}

	XWiPhone.Sign_with_option.usercallback = aUserCallBack;

	var aCallBackFunction = "XWiPhone.Sign_with_option.callback";
	var aArguments = [xgate_addr,
					  XecureEscape (accept_cert),
					  XecureEscape (aPlain),
					  aOption,
					  "",
					  pwd_fail];

	JobQueue.push (["XWiPhone.sendMessage",
					"SignDataCMS",
					aCallBackFunction,
					aArguments]);
}
XWiPhone.Sign_with_option.callback = function (aSignedData)
{
	JobQueue.isRun = false;

	if (aSignedData == "")
	{
		XecureWebError ();
		return;
	}

	eval (XWiPhone.Sign_with_option.usercallback + " (\"" + aSignedData + "\");");
}

/* Sign_with_vid_user */
XWiPhone.Sign_with_vid_user = new Object();
XWiPhone.Sign_with_vid_user.mUserCallBack = null;
XWiPhone.Sign_with_vid_user.mSignedData = null;
XWiPhone.Sign_with_vid_user.begin = function (aOption, aPlain, aPEM, aUserCallBack)
{
	if (arguments[3] == undefined)
	{
		alert ("aUserCallBack parameter is not set");
		return;
	}

	XWiPhone.Sign_with_vid_user.mUserCallBack = aUserCallBack;

	if ((aOption & 4) == 0)
	{
		aOption += 4;
	}

	var aCallBackFunction = "XWiPhone.Sign_with_vid_user.callback01";
	var aArguments = [xgate_addr, XecureEscape (accept_cert), XecureEscape (aPlain), aPEM, aOption, "", pwd_fail];

	JobQueue.push (["XWiPhone.sendMessage",
					"SignDataWithVID",
					aCallBackFunction,
					aArguments]);
}
XWiPhone.Sign_with_vid_user.callback01 = function (aSignedData)
{
	JobQueue.isRun = false;

	if (aSignedData == "")
	{
		XecureWebError ();
		return;
	}

	XWiPhone.Sign_with_vid_user.mSignedData = aSignedData;

	var aCallBackFunction = "XWiPhone.Sign_with_vid_user.callback02";
	var aArguments = [];

	JobQueue.push (["XWiPhone.sendMessage",
					"GetVidInfo",
					aCallBackFunction,
					aArguments]);
}
XWiPhone.Sign_with_vid_user.callback02 = function (aVID)
{
	JobQueue.isRun = false;

	if (aVID == "")
	{
		XecureWebError ();
		return;
	}

	eval (XWiPhone.Sign_with_vid_user.mUserCallBack + " (\"" + XWiPhone.Sign_with_vid_user.mSignedData + "\", \"" + aVID + "\");");
}

/* Sign_with_vid_web */
XWiPhone.Sign_with_vid_web = new Object();
XWiPhone.Sign_with_vid_web.mOption = null;
XWiPhone.Sign_with_vid_web.mPlain = null;
XWiPhone.Sign_with_vid_web.mPEM = null;
XWiPhone.Sign_with_vid_web.mUserCallBack = null;
XWiPhone.Sign_with_vid_web.begin = function (aOption, aPlain, aPEM, aIDN, aUserCallBack)
{
	if (arguments[4] == undefined)
	{
		alert ("aUserCallBack parameter is not set");
		return;
	}

	XWiPhone.Sign_with_vid_web.mOption = aOption;
	XWiPhone.Sign_with_vid_web.mPlain = aPlain;
	XWiPhone.Sign_with_vid_web.mPEM = aPEM;
	XWiPhone.Sign_with_vid_web.mUserCallBack = aUserCallBack;

	var aCallBackFunction = "XWiPhone.Sign_with_vid_web.callback01";
	var aArguments = [aIDN];

	JobQueue.push (["XWiPhone.sendMessage",
					"SetIDNum",
					aCallBackFunction,
					aArguments]);
}
XWiPhone.Sign_with_vid_web.callback01 = function (aResult)
{
	JobQueue.isRun = false;

	if (aResult != 0)
	{
		XecureWebError ();
		return;
	}

	if ((XWiPhone.Sign_with_vid_web.mOption & 4) == 0)
	{
		XWiPhone.Sign_with_vid_web.mOption += 4;
	}

	if ((XWiPhone.Sign_with_vid_web.mOption & 8) == 0)
	{
		XWiPhone.Sign_with_vid_web.mOption += 8;
	}

	var aCallBackFunction = "XWiPhone.Sign_with_vid_web.callback02";
	var aArguments = [xgate_addr,
					  XecureEscape (accept_cert),
					  XecureEscape (XWiPhone.Sign_with_vid_web.mPlain),
					  XWiPhone.Sign_with_vid_web.mPEM,
					  XWiPhone.Sign_with_vid_web.mOption,
					  "",
					  pwd_fail];

	JobQueue.push (["XWiPhone.sendMessage",
					"SignDataWithVID",
					aCallBackFunction,
					aArguments]);
}
XWiPhone.Sign_with_vid_web.callback02 = function (aSignedData)
{
	JobQueue.isRun = false;

	if (aSignedData == "")
	{
		XecureWebError ();
		return;
	}

	XWiPhone.Sign_with_vid_web.mSignedData = aSignedData;

	var aCallBackFunction = "XWiPhone.Sign_with_vid_web.callback03";
	var aArguments = [];

	JobQueue.push (["XWiPhone.sendMessage",
					"GetVidInfo",
					aCallBackFunction,
					aArguments]);
}
XWiPhone.Sign_with_vid_web.callback03 = function (aVID)
{
	JobQueue.isRun = false;

	if (aVID == "")
	{
		XecureWebError ();
		return;
	}

	eval (XWiPhone.Sign_with_vid_web.mUserCallBack + " (\"" + XWiPhone.Sign_with_vid_web.mSignedData + "\", \"" + aVID + "\");");
}

/* EnvelopData */
XWiPhone.EnvelopData = new Object ();
XWiPhone.EnvelopData.mUserCallback = null;
XWiPhone.EnvelopData.begin = function (inMsg, pwd, certPem, envOption, callback)
{
	var aCallBackFunction = "XWiPhone.EnvelopData.callback";

	if (arguments[4] == undefined)
	{
		alert ("output parameter is not set");
		return;
	}

	XWiPhone.EnvelopData.mUserCallback = callback;
	JobQueue.push (["XWiPhone.sendMessage",
			"EnvelopData",
			aCallBackFunction,
			[xgate_addr, XecureEscape(accept_cert), XecureEscape(inMsg), envOption, pwd, certPem, "", 0, "", 3]]);

}
XWiPhone.EnvelopData.callback = function (envelopedData)
{
	JobQueue.isRun = false;
	eval(XWiPhone.EnvelopData.mUserCallback+ "(\"" + envelopedData+ "\")");
}

/* DeEnvelop */
XWiPhone.DeEnvelop = new Object ();
XWiPhone.DeEnvelop.mUserCallback = null;
XWiPhone.DeEnvelop.begin = function (aEnvelopedData, callback)
{
	var aCallBackFunction = "XWiPhone.DeEnvelop.callback";

	if (arguments[1] == undefined)
	{
		alert ("output parameter is not set");
		return;
	}

	XWiPhone.DeEnvelop.mUserCallback = callback;
	JobQueue.push (["XWiPhone.sendMessage",
			"DeEnvelopData",
			aCallBackFunction,
			[xgate_addr, accept_cert, aEnvelopedData, 0, "", "", 3]]);

}
XWiPhone.DeEnvelop.callback = function (deEnvelopedData)
{
	JobQueue.isRun = false;
	eval(XWiPhone.DeEnvelop.mUserCallback + "(\"" + deEnvelopedData+ "\")");
}
XWiPhone.XecureWebError = new Object ();
XWiPhone.XecureWebError.code = "";                                                                      
XWiPhone.XecureWebError.msg = "";                                                                       
XWiPhone.XecureWebError.begin = function ()                                                             
{                                                                                                       
	var aCallBackFunction = "XWiPhone.XecureWebError.callbackCode";                                     
	JobQueue.push (["XWiPhone.sendMessage",                                                             
			"LastErrCode",
			aCallBackFunction,
			[]]);                                                                                        
}   

XWiPhone.XecureWebError.callbackCode = function (aResult)                                               
{       
	var aCallBackFunction = "XWiPhone.XecureWebError.callbackMsg";                                      
	XWiPhone.XecureWebError.code = aResult;
	JobQueue.isRun = false;                                                                             

	JobQueue.push (["XWiPhone.sendMessage",                                                             
			"LastErrMsg",
			aCallBackFunction,
			[]]);
}           

XWiPhone.XecureWebError.callbackMsg = function (aResult)                                               
{   
	JobQueue.isRun = false;                                                                             
	XWiPhone.XecureWebError.msg = aResult;

	alert ("XecureWebError\n" +                                                                         
			"Code:" + XWiPhone.XecureWebError.code + "\n" +                                             
			"Msg:" + XWiPhone.XecureWebError.msg);                                                      

}
