var USING_CUSTOM_IMAGE = 0;
var CUSTOM_IMAGE_URL = "";
var USING_TouchEnKey = "1";		

var TouchEnKey_CLSID		= "clsid:6CE20149-ABE3-462E-A1B4-5B549971AA38";
var TouchEnKey_CODEBASE_x64 = "/TouchEnKey/module/TouchEnkey3.1.0.26_64k.cab";
var TouchEnKey_CODEBASE_x86 = "/TouchEnKey/module/TouchEnkey3.1.0.26_32k.cab";
var TouchEnKey_VERSION 		= "3,1,0,26";
var Multi_InstallBinary 	= "/TouchEnKey/module/TouchEnKey_Installer_32bit_3.1.0.26.exe";
var Multi_InstallBinary_x64	= "/TouchEnKey/module/TouchEnKey_Installer_64bit_3.1.0.26.exe"; // 64 bit IE only
//var Multi_InstallBinary 	= "/TouchEnKey/module/TouchEnKey_Installer_32bit_3.zip";
//var Multi_InstallBinary_x64	= "/TouchEnKey/module/TouchEnKey_Installer_64bit_3.zip"; // 64 bit IE only
var Multi_Version 			= "3.1.0.27";
var TouchEnKey_indexpage		= "/index.jsp"; // �ㅼ튂 ���대룞 �섏씠吏�

var cert = "-----BEGIN CERTIFICATE-----MIIDVTCCAj2gAwIBAgIJAOYjCX4wgWJ3MA0GCSqGSIb3DQEBCwUAMGcxCzAJBgNVBAYTAktSMR0wGwYDVQQKExRSYW9uU2VjdXJlIENvLiwgTHRkLjEaMBgGA1UECxMRUXVhbGl0eSBBc3N1cmFuY2UxHTAbBgNVBAMTFFJhb25TZWN1cmUgQ28uLCBMdGQuMB4XDTE0MTAxNDA3MTkzNFoXDTE1MTAxNDA3MTkzNFowUTELMAkGA1UEBhMCS1IxIDAeBgNVBAoTF1dvb3JpQmFuayBlLVByb2N1cmVtZW50MSAwHgYDVQQDExdXb29yaUJhbmsgZS1Qcm9jdXJlbWVudDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN8MIlFygbhO595BcaCTrUt7pS2NB0T9Gfd1dEkvXDXZnZ0sqvlNvirYqj3JFopMxG4M1M6y5lVuKd3w3YU6Vy6nvdbRqJT1s659YWsK4IvM+TbEaRKYUt8UBKhpk2tq/74UuqWN7KlKwNRXY8lAN5c3hMSfqj47HEd/RtTLMjD4Oz+tS88n0DXkF9S2Q70wfgtRzi+k63q4kFOO+DImZUVG2GKhED2mIMoZ/9TlpROtHtkk51vlM3geMwf6XCXLUbqkJC323Jgg92aqSNI80rl799cT3PU30nZzQKHvNYxenQ32z9+Yr7VuisuFAFtpr7lO2AxOCgMi/jIaDphmqqUCAwEAAaMaMBgwCQYDVR0TBAIwADALBgNVHQ8EBAMCBeAwDQYJKoZIhvcNAQELBQADggEBAKcLrioQ/IxVDRX5S4kisdVAsDZgAFix+Sf0AX0xF58RnfuGZexhyIZBMFcX2U4rvs1jREGqKpVDMjXO8olmTxikrNugP4Titr1fVfaXp7y/wPhcsBdpw/JWvBxh3zyCD1rCZFaYKXe8Iy2wEQ274oueowxtKj+50Mm2hKXgRfRAq8r9AU7S5yVrVy+IpNbLk7mhkHQ5pv+V1K72WJkhtwCeLYih5siZW1fbBERSvEnbiNmYZAu5BiVIeFzsFSYOCaRXwbRLW0fjc0+xqkRlWMqyOw4nn6JOee/DuCiBgEerOjttGjPZ2P6hNSwq2+bjAlug4GNNdFrsPz66IcWxnBk=-----END CERTIFICATE-----";


var TouchEn_BaseBRW = {
	ua      : navigator.userAgent.toLowerCase(),
    ie      : navigator.appName == 'Microsoft Internet Explorer',
    ie_		: navigator.userAgent.match('MSIE') == 'MSIE',
    ns      : navigator.appName == 'Netscape',
    ff      : navigator.userAgent.match('Firefox') == 'Firefox',
    sf      : navigator.userAgent.match('Safari') == 'Safari',
    op      : navigator.userAgent.match('Opera') == 'Opera',
    cr      : navigator.userAgent.match('Chrome') == 'Chrome',
    win     : navigator.platform.match('Win') == 'Win',
    mac     : navigator.userAgent.match('Mac') == 'Mac',
    linux   : navigator.userAgent.match('Linux') == 'Linux',
    ie11		: navigator.userAgent.match('Trident/7.0') == 'Trident/7.0'
};

var getPluginType = {
    TouchEn_FFMIME      : ((TouchEn_BaseBRW.win) && (TouchEn_BaseBRW.ff ||TouchEn_BaseBRW.op)),
    TouchEn_SFMIME      : ((TouchEn_BaseBRW.win) && (TouchEn_BaseBRW.sf ||TouchEn_BaseBRW.cr)),
  	TouchEn_ACTIVEX   	: (TouchEn_BaseBRW.win && ( TouchEn_BaseBRW.ie || TouchEn_BaseBRW.ie11 || TouchEn_BaseBRW.ie_)),
    TouchEn_NPRUNTIME   : (TouchEn_BaseBRW.win && ((TouchEn_BaseBRW.ff || TouchEn_BaseBRW.sf || TouchEn_BaseBRW.cr) || TouchEn_BaseBRW.op)),
    TouchEn_OtherNP     : (TouchEn_BaseBRW.win && (TouchEn_BaseBRW.cr || TouchEn_BaseBRW.op)),
    TouchEn_OtherOS     : (TouchEn_BaseBRW.mac || TouchEn_BaseBRW.linux)
};


function checkTouchEnKeyMime() {
    if (getPluginType.TouchEn_NPRUNTIME) {
        var CKmType = navigator.plugins["TouchEn Key for Multi-Browser"];
        if (CKmType == undefined) {
            return false;
        } else {
            return true;
        }
    }
}

function downloadBinary() {
	location.href = Multi_InstallBinary;
}

function PrintTouchEnKeyActiveXTag() {
    if(USING_TouchEnKey == "1") {
        var Str="";

        Str+= '<object classid="' + TouchEnKey_CLSID + '"';
        if(navigator.cpuClass.toLowerCase() == "x64")   {
            Str+= '\n\t codebase="' + TouchEnKey_CODEBASE_x64 + '#version=' + TouchEnKey_VERSION + '"';
        } else {
           Str+= '\n\t codebase="' + TouchEnKey_CODEBASE_x86 + '#version=' + TouchEnKey_VERSION + '"';
        }
        Str+= '\n\tvspace="0" hspace="0" width="0" id="TouchEnKey" style="display:none;">';
        Str+= '\n\t <PARAM name="PKI" value="TouchEnKeyEx">';
        Str+= '\n\t <PARAM name="DefaultEnc" value="Off">';
        Str+= '\n\t <PARAM name="DefaultPaste" value="Off">';
        Str+= '\n\t <PARAM name="ClearBufferOnEmpty" value="true">';
        Str+= '\n\t <PARAM name="Verify" value="0">'; //Verify 媛쒕컻 0 �댁쁺 2
        Str+= '\n\t <PARAM name="IgnoreProgress" value="on">';
        if(USING_CUSTOM_IMAGE) {
            Str+= '\n\t <PARAM name="ImageURL" value="' + CUSTOM_IMAGE_URL + '">';
        }

        Str+= '</object>';
        document.write(Str);
    }
}

function PrintTouchEnKeyEmbedTag() {

    if(USING_TouchEnKey == "1") {
        var Str="";
        Str+= '<EMBED id="TouchEnKey" type="application/ClientKeeperKeyPro" width=0 height=0 ';
        if(USING_CUSTOM_IMAGE) {
            Str+= 'ImageURL="' + CUSTOM_IMAGE_URL + '" ';
        }
        Str+='PKI="TouchEnKeyEx"';
        Str+= 'TKFieldNotCheckPrefix="transkey_Tk_|transkey_"';
        Str+= 'RefreshSession="true"';
        Str+= 'DefaultPaste="off"';
        Str+= 'Verify="0"';
        Str+= '>';
        Str+= '</EMBED>';
        Str+= '<NOEMBED>no TouchEn Key</NOEMBED>';

        document.write(Str);
    }
}

function PrintTouchEnKeyTag() {
	if (getPluginType.TouchEn_ACTIVEX){
		PrintTouchEnKeyActiveXTag();
	} else if (getPluginType.TouchEn_NPRUNTIME){
		var mTypeRet = checkTouchEnKeyMime();
		if (mTypeRet) {
			PrintTouchEnKeyEmbedTag();
			if (isInstalledTouchEnKey()) {
				//location.href = TouchEnKey_indexpage;	
				self.close();
			} else {
				setTimeout("downloadBinary()", 2000);
			}
		} else {
			setTimeout("downloadBinary()", 2000);
		}
	}
}

function HaveControl_CK() {
	if(!getPluginType.TouchEn_ACTIVEX) return;
	if(document.TouchEnKey==null || typeof(document.TouchEnKey) == "undefined" || document.TouchEnKey.object == null) {

	}	else {
		//location.href = TouchEnKey_indexpage;
		self.close();
	}
}


var CK_objFocused;
function CK_Start(nsEvent)
{
	if(!getPluginType.TouchEn_NPRUNTIME) return;

	var theEvent;
	var inputObj;

	if (nsEvent.type == "text" || nsEvent.type == "password") {
		inputObj = nsEvent;
	}
	else {
		theEvent = nsEvent ? nsEvent : window.event;
		inputObj = theEvent.target ? theEvent.target : theEvent.srcElement;
	}

	try{
		TouchEnKeyTargetObject.StartCK(inputObj);
		CK_objFocused = inputObj;
	}catch(e){
		//alert("CK_Start catch");
	}
}

function CK_Stop()
{
	if(!getPluginType.TouchEn_NPRUNTIME) return;
	
	try{
		TouchEnKeyTargetObject.StopCK();
	}catch(e){
		//alert("CK_Stop catch");
	}
}

function CK_PatchKey()
{
	if(!getPluginType.TouchEn_NPRUNTIME) return;
	
 	try{
		TouchEnKeyTargetObject.PatchKey(CK_objFocused);
	}catch(e){
		//alert("CK_Dummy catch");
	}
}

function CK_Blur()
{
	if(!getPluginType.TouchEn_NPRUNTIME) return;
	
	try{
		CK_objFocused.blur();
	}catch(e){
		//alert("CK_Blur catch");
	}
}

function TouchEnKey_ApplySecurity()
{
	if(!getPluginType.TouchEn_NPRUNTIME) return;
	
	try{
		for(var i=0;i<document.forms.length;i++){
			for (var j=0;j < document.forms[i].elements.length;j++){				
				if(document.forms[i].elements[j].tagName == "INPUT" && (document.forms[i].elements[j].type == "text" || document.forms[i].elements[j].type == "password")){
			  	  if(document.forms[i].elements[j].addEventListener){
			  	  	document.forms[i].elements[j].addEventListener("focus", CK_Start, false);		//w3c
			  	  	document.forms[i].elements[j].addEventListener("blur", CK_Stop, false);		//w3c
			  	  }
		  	  	else if (document.forms[i].elements[j].attachEvent){
	  	  			 document.forms[i].elements[j].attachEvent("onfocus", CK_Start);					//msdom
	  	  			 document.forms[i].elements[j].attachEvent("onblur", CK_Stop);					//msdom
	  	  		}
					}	//end if
				} // end for
			} // end for
	}catch(e){		
			//	alert("error");	
	} // end try
}


function isInstalledTouchEnKey() {
	var installed = false;
	if(!getPluginType.TouchEn_NPRUNTIME) {
		if(document.TouchEnKey==null || typeof(document.TouchEnKey) == "undefined" || document.TouchEnKey.object == null) {
			installed = false;
		} else {
			installed = true;
		}
	} else {
		if( checkTouchEnKeyMime() ) {
			try {
				IsNeedUpdate = document.getElementById('TouchEnKey').NeedUpdate(Multi_Version);
				if (IsNeedUpdate==false) {
					installed = true;
				} else {
					installed = false;
				}
			} catch(e) {
				alert(e);
				installed = false;
			}
		} else {
			installed = false;
		}
	}
	return installed;
}

if (TouchEn_BaseBRW.win) {
	PrintTouchEnKeyTag();
	if(isInstalledTouchEnKey()) {
		//location.href = TouchEnKey_indexpage;
		self.close();
	} else {
		
	}

}
