var USING_CUSTOM_IMAGE = 0;
var CUSTOM_IMAGE_URL = "";
var USING_TouchEnKey = "1";		
 
var TouchEnKey_CLSID		= "clsid:6CE20149-ABE3-462E-A1B4-5B549971AA38";
var TouchEnKey_CODEBASE_x64 = "/TouchEnKey/module/TouchEnkey3.1.0.26_64k.cab";
var TouchEnKey_CODEBASE_x86 = "/TouchEnKey/module/TouchEnkey3.1.0.26_32k.cab";
var TouchEnKey_VERSION 		= "3,1,0,26";
var Multi_InstallBinary 	= "/TouchEnKey/module/TouchEnKey_Installer_32bit_3.1.0.26.exe";
var Multi_InstallBinary_x64	= "/TouchEnKey/module/TouchEnKey_Installer_64bit_3.1.0.26.exe"; // 64 bit IE only
var Multi_Version 			= "3.1.0.27";
var TouchEnKey_Installpage	= "/TouchEnKey/installpage/install.html"; // 설치 페이지 경로


var cert = "-----BEGIN CERTIFICATE-----MIIDVTCCAj2gAwIBAgIJAOYjCX4wgWJ3MA0GCSqGSIb3DQEBCwUAMGcxCzAJBgNVBAYTAktSMR0wGwYDVQQKExRSYW9uU2VjdXJlIENvLiwgTHRkLjEaMBgGA1UECxMRUXVhbGl0eSBBc3N1cmFuY2UxHTAbBgNVBAMTFFJhb25TZWN1cmUgQ28uLCBMdGQuMB4XDTE0MTAxNDA3MTkzNFoXDTE1MTAxNDA3MTkzNFowUTELMAkGA1UEBhMCS1IxIDAeBgNVBAoTF1dvb3JpQmFuayBlLVByb2N1cmVtZW50MSAwHgYDVQQDExdXb29yaUJhbmsgZS1Qcm9jdXJlbWVudDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN8MIlFygbhO595BcaCTrUt7pS2NB0T9Gfd1dEkvXDXZnZ0sqvlNvirYqj3JFopMxG4M1M6y5lVuKd3w3YU6Vy6nvdbRqJT1s659YWsK4IvM+TbEaRKYUt8UBKhpk2tq/74UuqWN7KlKwNRXY8lAN5c3hMSfqj47HEd/RtTLMjD4Oz+tS88n0DXkF9S2Q70wfgtRzi+k63q4kFOO+DImZUVG2GKhED2mIMoZ/9TlpROtHtkk51vlM3geMwf6XCXLUbqkJC323Jgg92aqSNI80rl799cT3PU30nZzQKHvNYxenQ32z9+Yr7VuisuFAFtpr7lO2AxOCgMi/jIaDphmqqUCAwEAAaMaMBgwCQYDVR0TBAIwADALBgNVHQ8EBAMCBeAwDQYJKoZIhvcNAQELBQADggEBAKcLrioQ/IxVDRX5S4kisdVAsDZgAFix+Sf0AX0xF58RnfuGZexhyIZBMFcX2U4rvs1jREGqKpVDMjXO8olmTxikrNugP4Titr1fVfaXp7y/wPhcsBdpw/JWvBxh3zyCD1rCZFaYKXe8Iy2wEQ274oueowxtKj+50Mm2hKXgRfRAq8r9AU7S5yVrVy+IpNbLk7mhkHQ5pv+V1K72WJkhtwCeLYih5siZW1fbBERSvEnbiNmYZAu5BiVIeFzsFSYOCaRXwbRLW0fjc0+xqkRlWMqyOw4nn6JOee/DuCiBgEerOjttGjPZ2P6hNSwq2+bjAlug4GNNdFrsPz66IcWxnBk=-----END CERTIFICATE-----";

var ServKeyForSending = null;

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
        Str+= '\n\t <PARAM name="DefaultPaste" value="On">';
        Str+= '\n\t <PARAM name="ClearBufferOnEmpty" value="true">';
        Str+= '\n\t <PARAM name="IgnoreProgress" value="on">';
        Str+= '\n\t <PARAM name="Verify" value="0">'; //Verify 개발 0 운영 2
        Str+= '\n\t <PARAM name="KeyboardOnly" value="false">';
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
        Str+= 'Verify="2"';
        Str+= '>';
        Str+= '</EMBED>';
        Str+= '<NOEMBED>no TouchEn Key</NOEMBED>';
        
        document.write(Str);
    }
}

function PrintTouchEnKeyTag() {
    if(getPluginType.TouchEn_ACTIVEX) {
        PrintTouchEnKeyActiveXTag();
    } else if(getPluginType.TouchEn_NPRUNTIME) {
        var mTypeRet = checkTouchEnKeyMime();
        if(mTypeRet) {
            PrintTouchEnKeyEmbedTag();
        } else {
           location.href = TouchEnKey_Installpage;
        }
    }
}

//===================== TouchEnKey Event function (Start) ==============================//

function triggerEvent(el,eventName,keycode){
	var htmlEvents = {
		onkeydown:1,
		onkeypress:1,
		onkeyup:1
	};
    var event;
    if(document.createEvent){
        event = document.createEvent('HTMLEvents');
        event.initEvent(eventName,true,true);
    }else if(document.createEventObject){// IE < 9
        event = document.createEventObject();
        event.eventType = eventName;
    }
    event.eventName = eventName;
	event.keyCode = keycode;
	event.which = keycode;
	
    if(el.dispatchEvent){
        el.dispatchEvent(event);
    }else if(el.fireEvent && htmlEvents['on'+eventName]){
        el.fireEvent('on'+event.eventType,event);
    }else if(el[eventName]){
        el[eventName]();
    }else if(el['on'+eventName]){
        el['on'+eventName]();
    }
}

function XecureCK_UIEevents(frm,ele,event,keycode) {
	TouchEnKey_UIEevents(frm,ele,event,keycode);

}

function TouchEnKey_UIEevents(frm,ele,event,keycode) {
 var obj;
    var e;
	if (navigator.userAgent.match('Trident/7.0') == 'Trident/7.0')
	{
		obj = document.activeElement;
		e = event.replace("on", "");		
		triggerEvent(obj, e, 120);
	}	
	else 
	{
		obj = document.activeElement;
		try {
			if( document.createEventObject )
			{
				eventObj = document.createEventObject();
				eventObj.keyCode=keycode;
				if(obj)
				{
					console.log(keycode);
					obj.fireEvent(event,eventObj);
				}
			}
			else if(document.createEvent) {
				if(window.KeyEvent) {
					
					e = document.createEvent('KeyEvents');
					e.initKeyEvent(event, true, true, window, false, false, false, false, keycode, 0);
				} else {
					e = document.createEvent('UIEvents');
					/*if(event=='keypress'){
						e.initUIEvent('input', true, true, window, 1);
						console.log('input');
					}*/					
					e.initUIEvent(event, true, true, window, 1);
					e.keyCode = keycode;
				}
				obj.dispatchEvent(e);
			} 
		} catch(e) {
		}	
	}
}
//===================== TouchEnKey Event function (End) ==============================//

//===================== TouchEnKey E2E function (Start) ==============================//
function SetServKey(PlainServKeyURL) {
    var transkey = this;
    var request = new XMLHttpRequest();
    
    request.open("POST", PlainServKeyURL, false);
    request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

    try {
        request.send(null);
    } catch(e) {
        alert("TouchEn key error: Cannot load Serverkey. Network is not available.");
        return false;
    }

    if(request.readyState == 4 && request.status == 200) {
        if(request.responseText) {
            ServKeyForSending= request.responseText.substring(request.responseText.indexOf("<TEKSRK>")+8, request.responseText.indexOf("</TEKSRK>"));
        }
        return true;
    } else {
        return false;
    }
}


function TouchEnkey_GetVariable(name) {
    if(name == "SR")
    {
     return TNK_SR;		
    }
}

function DrawHiddenElements(frm) {
	if (frm.hid_key_data == null && frm.hid_enc_data == null) {
		var newEle = document.createElement("input");
	    newEle.type = "hidden";
	    newEle.name = "hid_key_data";
	    newEle.id = "hid_key_data";
	    newEle.value = "";
	    frm.appendChild(newEle);
	
	    var newEle = document.createElement("input");
	    newEle.type = "hidden";
	    newEle.name = "hid_enc_data";
	    newEle.id = "hid_enc_data";
	    newEle.value = "";
	    frm.appendChild(newEle);
	  }
}

function GetEncDataFun(keyData, frm, ele) {
    return document.getElementById('TouchEnKey').GetEncData(keyData, frm, ele);
}

function findElementByName(form, eleName) {
    if(eleName == null) {
        return null;
    }

    var findEle = null;
    var len = form.elements.length;
    for(var i=0; i<len; i++) {
        if(eleName == form.elements[i].name) {
            return form.elements[i];
        }
    }
}


function makeEncData(frm) {
	if ( navigator.platform.match('Win') != 'Win' ||( navigator.userAgent.indexOf("Opera") > -1 && navigator.userAgent.indexOf("Version/12.") > -1 ))
		return true;
	
	try{
		var encFieldCnt = 0;
		var fieldCnt = 0;
		var cipherEncText = "";
		var checkE2E = false;
		var elelength = frm.elements.length;
		
		var name = new Array(elelength);
		var value = new Array(elelength);
		
	  for (var j=0;j < elelength;j++)
	  {    	
	      if(frm.elements[j].tagName == "INPUT" && (frm.elements[j].type == "text" || frm.elements[j].type == "password") && frm.elements[j].getAttribute("data-enc")=="on")
	      {	
	    	checkE2E = true;
	      	name[encFieldCnt] = "E2E_" + frm.elements[j].name;
	      	value[encFieldCnt] = GetEncDataFun("", frm.name, frm.elements[j].name);
	      	
	      	encFieldCnt++;
	      }
	  }
	  	if(checkE2E){
			for (var i = 0; i < encFieldCnt; i++) {
				if (value[i] != "undefined") {
					cipherEncText += name[i];
					cipherEncText += "=";	
					cipherEncText += value[i];
					cipherEncText += "%TK%";
				}
				e2eEle = findElementByName(frm, name[i]);
				if( e2eEle == null ) {
							var newEle = document.createElement("input");
							newEle.type = "hidden";
							newEle.name = name[i];
							newEle.id = name[i];
							newEle.value = value[i];
							frm.appendChild(newEle);
					}
					else {
							e2eEle.value = value[i];
					}
			}
		
			DrawHiddenElements(frm); 
			frm.hid_key_data.value = GetEncDataFun(cert, "", "");
			frm.hid_enc_data.value = cipherEncText;
		}
		return true;
	} 
	catch(e) 
	{
		//alert("makeEncData Error");
		return false;
	}
}

function TouchEnKey_InvalidateSession() {
	if (isInstalledTouchEnKey()) {
		if (getPluginType.TouchEn_ACTIVEX){
			document.getElementById('TouchEnKey').InvalidateSession();
		} else if (getPluginType.TouchEn_NPRUNTIME) {
				document.getElementById('TouchEnKey').InvalidateSession();
		}
	} else {
		return false;
	}
}

function TouchEnKey_ReadOnly(name)
{		
	if (name != "TK") return;	
	if(document.activeElement.readOnly == 1)
	{
		return "true";
	}
	else
	{
			return "false";
	}
}

function TouchEnKey_GetElementInfo(name)
{	
	if (name == "form")
		{
		   return document.activeElement.form.name; 
		}
	if (name == "input")
		{
			return document.activeElement.name;
		}
}

//===================== TouchEnKey E2E function (End) ==============================//


//===================== TouchEnKey Multi Browser function (End) ==============================//
var CK_objFocused;
function CK_Start(nsEvent) {
    if(!getPluginType.TouchEn_NPRUNTIME) return;

    var theEvent;
    var inputObj;

    if(nsEvent.type == "text" || nsEvent.type == "password") {
        inputObj = nsEvent;
    } else {
        theEvent = nsEvent ? nsEvent : window.event;
        inputObj = theEvent.target ? theEvent.target : theEvent.srcElement;
    }

    try {
        document.getElementById('TouchEnKey').StartCK(inputObj);
        CK_objFocused = inputObj;
        CK_OP_IsStart = true;  
    } catch(e) {
    }
}

function CK_Stop() {
    if(!getPluginType.TouchEn_NPRUNTIME) return;

    try {
        document.getElementById('TouchEnKey').StopCK();
        CK_OP_IsStart = false;
    } catch(e) {
    }
}

function CK_PatchKey() {
    if(!getPluginType.TouchEn_NPRUNTIME) return;

    try {
        document.getElementById('TouchEnKey').PatchKey(CK_objFocused);
    } catch(e) {
    }
}

function CK_Blur() {
    if(!getPluginType.TouchEn_NPRUNTIME) return;

    try {
        CK_objFocused.blur();
    } catch(e) {
    }
}
function CK_Click(nsEvent) {
    var theEvent;
    var inputObj;

    if(nsEvent.type == "text" || nsEvent.type == "password") {
        inputObj = nsEvent;
    } else {
        theEvent = nsEvent ? nsEvent : window.event;
        inputObj = theEvent.target ? theEvent.target : theEvent.srcElement;
    }

}

function CK_KeyDown(nsEvent) {
    var theEvent;
    var inputObj;

    if(nsEvent.type == "text" || nsEvent.type == "password") {
        inputObj = nsEvent;
    } else {
        theEvent = nsEvent ? nsEvent : window.event;
        inputObj = theEvent.target ? theEvent.target : theEvent.srcElement;
    }
    if((typeof(inputObj.getAttribute("data-enc")) == "undefined") || (inputObj.getAttribute("data-enc") != "on")) return;
    
    if((theEvent.keyCode >= 35 && theEvent.keyCode <= 40)||(theEvent.keyCode == 46)) {
        if(theEvent.preventDefault) theEvent.preventDefault();
        if(theEvent.stopPropagation) theEvent.stopPropagation();

        theEvent.returnValue = false;
        theEvent.cancelBubble = true;

        return;
    }
}
function TouchEnKey_ApplySecurity() {
    if(!getPluginType.TouchEn_NPRUNTIME) return;
    try {
        for(var i=0;i<document.forms.length;i++) {
            for(var j=0;j < document.forms[i].elements.length;j++) {
                if(document.forms[i].elements[j].tagName == "INPUT" && (document.forms[i].elements[j].type == "text" || document.forms[i].elements[j].type == "password")) {
                    if(document.forms[i].elements[j].addEventListener){
                        document.forms[i].elements[j].addEventListener("focus", CK_Start, false);       //w3c
                        document.forms[i].elements[j].addEventListener("blur", CK_Stop, false);     //w3c
                        document.forms[i].elements[j].addEventListener("click", CK_Click, false);       //w3c
                        document.forms[i].elements[j].addEventListener("mouseup", CK_Click, false);     //w3c
                        document.forms[i].elements[j].addEventListener("keydown", CK_KeyDown, false);       //w3c ff/safari/chrome
                        document.forms[i].elements[j].addEventListener("keypress", CK_KeyDown, false);      //w3c opera
                    } else if(document.forms[i].elements[j].attachEvent) {
                        document.forms[i].elements[j].attachEvent("onfocus", CK_Start);                 //msdom
                        document.forms[i].elements[j].attachEvent("onblur", CK_Stop);//msdom
                    }
                }
            }
        }
    } catch(e) {
    }
}
function CK_ApplySecurity() {
    TouchEnKey_ApplySecurity();
}

//===================== TouchEnKey Multi Browser function (End) ==============================//


//===================== TouchEnKey dynamic input filed use this function (End) ==============================//

function TouchEnKey_ReScan() {
    if(USING_TouchEnKey == 1) {
        if(getPluginType.TouchEn_ACTIVEX) {
            var obj = document.getElementById("TouchEnKey");
            obj.ReScanDocument();
        } else {
            TouchEnKey_ApplySecurity();
        }
    }    
}

function TouchEnKey_EnqueueList(fname, iname)
{
	if(!getPluginType.TouchEn_ACTIVEX){
 	
  document.getElementById("TouchEnKey").ReScanDocument();

  } 
 if(document.TouchEnKey==null || typeof(document.TouchEnKey) == "undefined" || document.TouchEnKey.object==null) {
  
  return;
 }
 
 document.TouchEnKey.EnqueueList(fname, iname);
}

function TouchEnkey_EnqueueList_frm(frmname) {
 if(navigator.platform.match('Win') == 'Win'){
		if(!getPluginType.TouchEn_ACTIVEX) {
			CK_ApplySecurity();
	 		return;
		}
	}
 	var frm = document.getElementById(frmname);
 	var elelength = frm.elements.length;
	var fieldCnt = 0;	
	var name = new Array(elelength);
	for (var j=0;j < elelength;j++) {    	
		if(frm.elements[j].tagName == "INPUT" && (frm.elements[j].type == "text" || frm.elements[j].type == "password") && frm.elements[j].getAttribute("data-enc")=="on") {	  
			var elename = frm.elements[j].name;
			TouchEnKey_EnqueueList(frmname, elename);
		}
	}
}

/*
 * TouchEney install check function
 */
function isInstalledTouchEnKey() {
	var installed = false;
    if(!getPluginType.TouchEn_NPRUNTIME) {
        if(document.TouchEnKey==null || typeof(document.TouchEnKey) == "undefined" || document.TouchEnKey.object == null) {
            installed = false;
        } else {
            installed = true;
        }
    } else {
        if(checkTouchEnKeyMime()) {
            try {
                IsNeedUpdate = document.getElementById('TouchEnKey').NeedUpdate(Multi_Version);
                if(IsNeedUpdate==false) {
                     installed = true;
                } else {
                    installed = false;
                }
            } catch(e) {
                installed = false;
            }
        } else {
            installed = false;
        }
    }

    return installed;
}

/*
 * TouchEney Keyboard inpudata memory clear function
 */
function TouchEnKey_Clear(frmName,eleName) {
	try
	{
		var obj = document.getElementById("TouchEnKey");
	    obj.Clear(frmName, eleName, 0);
	}
	catch(e)
	{
	}
}

/*
 * TouchEnKey State Check function ( CapsLock, Shift )
 */
function GetKeyStateCheck(keyname){
	return document.getElementById('TouchEnKey').GetKeyState(keyname);
}


if(!TouchEn_BaseBRW.win || USING_TouchEnKey == 0 || (navigator.userAgent.indexOf("Opera") > -1 && navigator.userAgent.indexOf("Version/12.") > -1 )) {

} else {
    PrintTouchEnKeyTag();
    
    if(isInstalledTouchEnKey()) {
        TouchEnKey_ApplySecurity();
    } else {
    	location.href = TouchEnKey_Installpage;
    }
}
