/*!
* AnySign for PC, v1.1.1.0, r1710
*
* For more information on this product, please see
* http://hsecure.co.kr/
*
* Copyright (c) Hancom Secure Co.,Ltd All Rights Reserved.
*
* Date: 2017-10-10
*/
if (typeof AnySignForPCExtension == "undefined") {
	AnySignForPCExtension = {};
}

AnySignForPCExtension.AnySignAjax = function () {
	var gURL;
	var xdrSocket = null;
	var callback = null;
	var gErrObject = {code: 0, msg: ""};
	var gSendDataList = [];
	var gDecData = [];
	var gProtocolType = "general";
	var _createJSONData = null;
	var _createJSONDataOld = null;

	var enableWS = false;
	var gConnectFailCount = 0;
	var gLauncherErrorCount = 0;

	var gPingFunction;
	var gPingEnable = true;
	var gPongRandom = null;
	var gPongMessage = null;
	var gPingRandom = null;
	var gPingMessage = "heartbeat!"	
	var gPingTime = 30000;
	var gIdleTime = 20000;
	var gLastMessageTime;

	var gStartInterval = 300;
	var gSecondInterval = 200;   
	var gAsynchSendInterval = 230;
	var gSendInterval = 0;
	var gSocketTimeout = 0;

	var gSessionID = AnySign.mAnySignSID;

	var gDirectConnect = false;
	var gTrialNumber;

	var gServicePort;
	var gConnectPort;

	var gLauncherSocket = false;

	var gRandomNumber = 0;
	var gDecExeSend = false;
	var gDecResultList = [];

	var gRunUpdate = false;
	var gUpdateStartTime = 0;

	var gIntegrityRet;

	var	gUserCheckMode = true;

	var	gDecCount = 0;
	var	gDecIDNum = 0;

	//eval(GetSafeResponse (loadSecurePro ("AnySign4PC_min.js")));
	eval(GetSafeResponse (loadSecurePro ("SecureProto.js")));
	eval(GetSafeResponse (loadSecurePro ("anySignjQuery-1.11.1.js")));

	function loadSecurePro (aName)
	{
		var aRequest,
			aExtension;

		if (window.ActiveXObject) {
			try {
				aRequest = new ActiveXObject("MSXML2.XMLHTTP.3.0");
			}catch(e) {
				try {
					aRequest = new ActiveXObject("Microsoft.XMLHTTP");
				}catch(e){}
			}
		}
		else if (window.XMLHttpRequest) {
			aRequest = new window.XMLHttpRequest;
		}

		aRequest.open ('GET', AnySign.mBasePath + "/ext/" + aName, false);
		aRequest.send (null);

		if (aRequest.status != 200) {
			alert("[AnySign for PC] 서버로부터 프로그램 실행을 위한 스크립트를 가져오는데 실패하였습니다.\n[스크립트 파일명] : " + aName);
			return;
		}
		return aRequest.responseText;
	}

	function _checkPingPong () {
		var currentTime = new Date().getTime();
		if ((currentTime - gLastMessageTime) > gIdleTime) {
			if (gPingEnable) {
				if(gPongMessage != null)
				{
					if(gPongMessage != gPingMessage || gPongRandom != gPingRandom)
					{
						// assume Local Server is disable or not executed.
						clearInterval (gPingFunction);
						gPongRandom = null;
						gPongMessage = null;
						gPingRandom = null;
						_getWebSocket();
					}
				}

				if (gPingEnable) 
					gPingRandom = _sendPingInfo(gPingMessage ,gAsynchSendInterval);
			}
		}
	}

	function reRun () {
		console.log("[AnySign for PC][AnySignAjax_reRun_02000]");
		webSocket = null;
		enableWS = false;
		gLauncherSocket = false;
		AnySign.mAnySignLoad = false;
		var protocol = gURL.substring(0, gURL.length-5);
		gURL = protocol + gServicePort;

		_getWebSocket ();
	}

	function _getWebSocket () {

		xdrSocket = new XDomainRequest();
		if (!gLauncherSocket && gDirectConnect == false)
		{
			var message = _setDemonInfo ();
			setTimeout (function () {
				_doSend (message);
			}, 300);
		}
		else
		{
			if (gURL.indexOf("https:") == 0)
			{
				_setAttributeInfo (gStartInterval);
			}
			else if(gURL.indexOf("http:") == 0)
			{
				Secure.start("envelope",_doAjaxSend);
			}
		}
		
		xdrSocket.onload = function() {
			var aData, aProtocolData, aContact, aFuncname, aType, aValue, aMessageUID, aSessionID;
			var isDec = false;

			gLastMessageTime = new Date().getTime();
			gPingEnable = true;

			aData = xdrSocket.responseText;
			try {
				aProtocolData = JSON.parse(aData);
				aProtocolType = aProtocolData.protocolType;
				aContact = aProtocolData.message;
			} catch(e) {
				gDirectConnect = false;
				var port = Number(AnySign.mExtensionSetting.mPort);
				if(window.location.protocol.indexOf("https:") == 0 ) {
					gServicePort = port + 1;
					gURL = "https://127.0.0.1:" + gServicePort;
				}
				else {
					gServicePort = port;
					gURL = "http://127.0.0.1:" + gServicePort;
				}
				gConnectPort = gServicePort;

				reRun();
				return;
			}

			if (aProtocolType == "secure")
			{
				AnySign.mExtensionSetting.mImgIntervalError = true;
				alert("[AnySign for PC] Internet Explorer 9 이하 버전에서는 Secure 보안프로토콜이 동작하지 않습니다.");
				return;
			}

			if (aProtocolType == "envelope")
			{
				try {
					aMessageType = aContact.messageType;
					switch (aMessageType)
					{
						case "application":
							aContact = JSON.parse (Secure.receiveApplication (aProtocolData));
							break;
						case "server_hello":
							if (Secure.handShake (_doAjaxSend, aProtocolData))
							{
								gProtocolType = "envelope";
								_createJSONDataOld = _createJSONData;
								_createJSONData = function (message) {
									var JSONData = JSON.stringify(message);
									return Secure.sendApplication (JSONData);
								}
								_setAttributeInfo (gSecondInterval);
							}
							else
							{
								alert("[AnySign for PC] Envelope 보안프로토콜 암호세션 생성이 실패하였습니다.\n\n보안프로토콜 인증서가 유효하지 않습니다. 다시 암호세션 생성을 시도하겠습니다.");
								_getWebSocket();
							}
							return;
						default:
							alert("[AnySign for PC] Envelope 보안프로토콜이 정상적으로 동작하지 않았습니다.\n[메시지 코드] : " + aContact.code);
							return;
					}
				}
				catch (err)
				{
					alert("[AnySign for PC] Envelope 보안프로토콜에 예외동작이 발생하였습니다.\n[예외처리 메시지] : " + err);
				}
			}
	
			aFuncname = aContact.InterfaceName;
			aType = aContact.ReturnType;
			aMessageUID = aContact.MessageUID;
			aSessionID = aContact.SessionID;
			if (aType == "number")
				aValue = Number(aContact.ReturnValue);
			else
				aValue = aContact.ReturnValue;

			gErrObject.code = aContact.InterfaceErrorCode;
			gErrObject.msg = aContact.InterfaceErrorMessage;

			if (gErrObject.code == "21000") {
				if (AnySign.mExtensionSetting.mInstallCheck_CB != null) {
					AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_INTEGRITY_FAIL");
				} else {
					alert("[AnySign for PC] 공인인증 보안 프로그램의 동작을 중지합니다.\n악의적 공격에 의해 수정되었을 가능성이 있습니다.\n재설치 하시기 바랍니다.");
					_openInstallPage(AnySign.mPlatform.aInstallPage);
				}

				return;
			}

			switch (aFuncname)
			{
				case "launcher":
					if (gErrObject.code == "30000" || gErrObject.code == "30002" ||
						gErrObject.code == "30003" || gErrObject.code == "30004" || gErrObject.code == "30005")
					{
						console.log("[AnySign for PC][AnySignAjax_onload_01000][" + gErrObject.code + "]");
						if (AnySign.mExtensionSetting.mInstallCheck_CB != null) 
						{
							AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_NEED_INSTALL");
							AnySign.mExtensionSetting.mInstallCheck_CB = null;
							return;
						}

						gLauncherErrorCount++;
						if (gLauncherErrorCount > 3) {
							AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NEED_INSTALL";
							var selectResult = confirm("[AnySign for PC] 공인인증 보안 프로그램 설치가 필요합니다.\n[확인]을 선택하시면 설치페이지로 연결됩니다.");
							
							if (selectResult)
								_openInstallPage(AnySign.mPlatform.aInstallPage);

							AnySign.mExtensionSetting.mImgIntervalError = true;
							return;
						}

						if (gErrObject.code == "30002" && AnySign.mPlatform.aName.indexOf("windows") == 0)
						{
							gUserCheckMode = false;

							gDirectConnect = true;
							gServicePort = Number(AnySign.mExtensionSetting.mDirectPort)+1;
							gConnectPort = gServicePort;

							reRun();
						}
						else
						{

							AnySign.mExtensionSetting.mImgIntervalError = true;

							var msg = "[AnySign for PC] 서비스를 통한  AnySign4PC.exe 프로그램 실행에 실패하였습니다. 다시 실행하겠습니다.\n" + "[" + gErrObject.code + "] [" + eval("ANYSIGN4PC_ERROR_" + gErrObject.code) + "]";
							alert(msg);
						}

						return;
					}
					else if (gErrObject.code == "30001")
					{
						console.log("[AnySign for PC][AnySignAjax_onload_01001]");
						// update
						if (AnySign.mExtensionSetting.mInstallCheck_CB != null) 
						{
							AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_NEED_UPDATE");
							AnySign.mExtensionSetting.mInstallCheck_CB = null;
							return;
						}

						if (AnySign.mAnySignLiveUpdate)
						{
							if (gRunUpdate) {
								var time = new Date().getTime();
								if ((time - gUpdateStartTime) > 120000)
									_openInstallPage(AnySign.mPlatform.aInstallPage);
								else
									setTimeout (function () {reRun ();}, 2000);
							} else {
								var aElement = document.getElementById("AnySign4PCLoadingImg");
								if (aElement != null) {
									if (typeof AnySign.mLanguage === 'string' && AnySign.mLanguage.toLowerCase() == "ko-kr")
										aElement.src = AnySign.mBasePath + "/img/loading_update.gif";
									else
										aElement.src = AnySign.mBasePath + "/img/loading_update_en.gif";
								} else {
									try {
										if (AnySign.mAnySignShowImg.showUpdateImg) {
											AnySign.mExtensionSetting.mImgIntervalFunc = setInterval(function () {
												showAnySignLoadingImg ("update");
											}, 50);
										}
									}catch(err){}
								}

								gUpdateStartTime = new Date().getTime();
								gRunUpdate = true;
								console.log ("[AnySign4PC] send message: updateready");
								_setUpdateState ("updateready");
							}
						}
						else
						{
							AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NEED_INSTALL";
							if (AnySign.mExtensionSetting.mIgnoreInstallPage != true) {
								var selectResult = confirm("[AnySign for PC] 공인인증 보안 프로그램 설치가 필요합니다.\n[확인]을 선택하시면 설치페이지로 연결됩니다.");
								
								if (selectResult)
									_openInstallPage(AnySign.mPlatform.aInstallPage);

								AnySign.mExtensionSetting.mImgIntervalError = true;
							}
						}
					}
					else if (gErrObject.code == 0)
					{
						if (gRunUpdate)
						{
							gRunUpdate = false;
						}

						enableWS = true;
						gLauncherSocket = true;
						var portList = aValue.split(","); 
						var protocol = gURL.substring(0, gURL.length-5);
						if (protocol.indexOf("https:") == 0)
						{
							gConnectPort = portList[1];
							gURL = protocol + portList[1];
						}
						else
						{
							gConnectPort = portList[0];
							gURL = protocol + portList[0];
						}

						console.log("[AnySign for PC][AnySignAjax_onload_01002][" + gConnectPort + "]");

						_getWebSocket();
					}
					else
					{
						AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NEED_INSTALL";
						var selectResult = confirm("[AnySign for PC] 공인인증 보안 프로그램 설치가 필요합니다.\n[확인]을 선택하시면 설치페이지로 연결됩니다.");

						if (selectResult)
							_openInstallPage(AnySign.mPlatform.aInstallPage);

						AnySign.mExtensionSetting.mImgIntervalError = true;
					}
					break;
				case "setAttributeInfo":
					if (gErrObject.code == 30006 || gErrObject.code == 30001) {
						console.log("[AnySign for PC][AnySignAjax_onload_01003][" + gErrObject.code + "]");
						gDirectConnect = false;
						port = Number(AnySign.mExtensionSetting.mPort);
						if(window.location.protocol.indexOf("https:") == 0) {
							gServicePort = port + 1;
							gURL = "https://127.0.0.1:" + gServicePort;
						}
						else {
							if (gErrObject.code == 30001)
								_createJSONData = _createJSONDataOld;
							gServicePort = port;
							gURL = "http://127.0.0.1:" + gServicePort;
						}

						reRun ();
						return;
					}

					AnySign.mAnySignLoad = true;
					console.log("[AnySign for PC][AnySignAjax_onload_01004]");

					// check setAttribute result
					if (gErrObject.code == 20015)
					{
						AnySign.mAnySignLoad = false;
						alert("[AnySign for PC] AnySign4PC.exe 프로그램 초기화에 실패하였습니다.\n" + "[실패 명령어] : " + gErrObject.msg);
						return;
					}

					// check integrity fail
					if (aValue.length == 0)
						aValue = null;

					// verify integrity data
					if (onSendToServer (aValue) != 0)
					{
						AnySign.mAnySignLoad = false;
						enableWS = false;
						gIntegrityRet = "FAILED";
						console.log("[AnySign for PC][AnySignAjax_onload_01005]");
						return;
					}

					AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NORMAL";
					
					if ( document.getElementById("EncryptionAreaID_0") == null )
					{
						AnySign.mPageBlockDecDone = true;
						_executeDecCallback();
					}
					//

					if (AnySign.mExtensionSetting.mEncCallback)
					{
						var aEncCB = AnySign.mExtensionSetting.mEncCallback;
						AnySign.mExtensionSetting.mEncCallback = "";
						aEncCB ();
					}

					if (AnySign.mExtensionSetting.mLoadCallback.func) {
						var aLoadCB = AnySign.mExtensionSetting.mLoadCallback.func;
						var aLoadParam = AnySign.mExtensionSetting.mLoadCallback.param;
						AnySign.mExtensionSetting.mLoadCallback.func = null;
						AnySign.mExtensionSetting.mLoadCallback.param = null;
						aLoadCB(aLoadParam);
					}

					if (AnySign.mExtensionSetting.mInstallCheck_CB != null) 
					{
						AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_NORMAL");
						AnySign.mExtensionSetting.mInstallCheck_CB = null;
					}

					gPingFunction = setInterval(_checkPingPong, gPingTime);
					gDecExeSend = true;
					break;
				case "pong":
					gPongRandom = aMessageUID; 
					gPongMessage = aValue;
					break;
				case "blockDecEx":
					gDecResultList.push (aContact);
					gDecExeSend = true;
					break;
				case "blockEnc":
				case "blockEnc2":
				case "blockEncConvert2":
					if (callback) {
						var exeFunc = callback;
						callback = null;
						exeFunc (aValue);
					} else {
						gDecResultList.push (aContact);
						gDecExeSend = true;
					}
					break;
				case "updateready":
					console.log ("[AnySign4PC] receive message: updateready");
					if (gErrObject.code == 0)
					{
						console.log ("[AnySign4PC] send message: updatestart");
						_setUpdateState ("updatestart");
					}
					else
					{
						alert("[AnySign for PC] 보안 프로그램의 업데이트 설치에 실패하였습니다. 설치페이지로 이동합니다.\n" + "[오류코드] : " + gErrObject.code);
						_openInstallPage(AnySign.mPlatform.aInstallPage);
					}
					break;
				case "updatestart":
					console.log ("[AnySign4PC] receive message: updatestart");
					setTimeout (reRun, gSendInterval);
					break;
				default:
					if (callback) {
						var exeFunc = callback;
						callback = null;
						exeFunc (aValue);
					}
			}
		};

		xdrSocket.onerror = function() {
			if (enableWS)
			{
				console.log("[AnySign for PC][AnySignAjax_error_10000]");
				if (gPingFunction)
					clearInterval (gPingFunction);

				if (gConnectFailCount > 3) {
					AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NEED_INSTALL";
					var selectResult = confirm("안정적인 동작을 위해 AnySign for PC 공인인증 보안 프로그램의 재설치가 필요합니다.\n[확인]을 선택하시면 설치페이지로 연결됩니다.");
					
					if (selectResult)
						_openInstallPage(AnySign.mPlatform.aInstallPage);

					AnySign.mExtensionSetting.mImgIntervalError = true;
					return;
				}

				try {
					var element = document.getElementById("xwup_title_guidewindow");
					if (element != null) {
						AnySign.mExtensionSetting.mDialog.oncancel ();
					}
				} catch(e) {}

				gConnectFailCount++;
				reRun ();
			}
			else if (gRunUpdate == true)
			{
				console.log("[AnySign for PC][AnySignAjax_error_10001]");
				var time = new Date().getTime();
				if ((time - gUpdateStartTime) > 120000)
					_openInstallPage(AnySign.mPlatform.aInstallPage);
				else
					reRun ();
			}
			else if (gIntegrityRet == "FAILED")
			{
				console.log("[AnySign for PC][AnySignAjax_error_10002]");
				return;
			}
			else if (gDirectConnect) {
				if (AnySign.mExtensionSetting.mInstallCheck_Level == 1) {
					console.log("[AnySign for PC][AnySignAjax_error_10007]");
					AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NEED_INSTALL";
					
					if (AnySign.mExtensionSetting.mInstallCheck_CB != null)
					{
						AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_NEED_INSTALL");
						AnySign.mExtensionSetting.mInstallCheck_CB = null;
					}
					else if (AnySign.mExtensionSetting.mIgnoreInstallPage != true)
					{
						var selectResult = confirm("[AnySign for PC] 공인인증 보안 프로그램 설치가 필요합니다.\n[확인]을 선택하시면 설치페이지로 연결됩니다.");

						if (selectResult)
							_openInstallPage(AnySign.mPlatform.aInstallPage);

						AnySign.mExtensionSetting.mImgIntervalError = true;
					}
				} else {
					gDirectConnect = false;
					gTrialNumber = 0;
					port = Number(AnySign.mExtensionSetting.mPort);

					if(window.location.protocol.indexOf("https:") == 0 )
					{
						gServicePort = port + 1;
						gURL = "https://127.0.0.1:" + gServicePort;
					}
					else
					{
						gServicePort = port;
						gURL = "http://127.0.0.1:" + gServicePort;
					}
					console.log("[AnySign for PC][AnySignAjax_error_10004]");

					reRun ();
				}
			}
			else
			{
				if (gTrialNumber < AnySign.mExtensionSetting.mTrialPortRange)
				{
					var type;

					if(window.location.protocol.indexOf("https:") == 0 )
						type = "https://127.0.0.1:";
					else
						type = "http://127.0.0.1:";

					gServicePort = gServicePort + 2;
					gURL = type + gServicePort;

					console.log("[AnySign for PC][AnySignAjax_error_10005][" + gServicePort + "]");
					gTrialNumber++;
					_getWebSocket ();
				}
				else {
					console.log("[AnySign for PC][AnySignAjax_error_10006]");
					AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NEED_INSTALL";
					
					if (AnySign.mExtensionSetting.mInstallCheck_CB != null)
					{
						AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_NEED_INSTALL");
						AnySign.mExtensionSetting.mInstallCheck_CB = null;
					}
					else if (AnySign.mExtensionSetting.mIgnoreInstallPage != true)
					{
						var selectResult = confirm("[AnySign for PC] 공인인증 보안 프로그램 설치가 필요합니다.\n[확인]을 선택하시면 설치페이지로 연결됩니다.");

						if (selectResult)
							_openInstallPage(AnySign.mPlatform.aInstallPage);

						AnySign.mExtensionSetting.mImgIntervalError = true;
					}
				}
			}
		};

		xdrSocket.ontimeout = function(){};
		xdrSocket.onprogress = function(){};
		xdrSocket.timeout = gSocketTimeout;
	}

	function _doSend (message) {
		gPingEnable = false;
		xdrSocket.open("POST", gURL);
		xdrSocket.send(message);
	}

	function _doAjaxSend (message, timeout) {

		gPingEnable = false;

		if( timeout === undefined)
		{
			setTimeout( function () {_doSend (message);}, gStartInterval);
		}
		else
		{
			setTimeout( function () {_doSend (message);}, timeout );
		}
	}

	function _createData (args) {
		// Create protocol message
		var interfaceName = args[0];
		var messageuid = args[args.length-1];

		var data = [];
		for (i = 0; i < args.length-2; i++)
			data[i] = String(args[i+1]);

		var paramLength = String(args.length-2);
	
		var aMemberFilter = {InterfaceName:interfaceName,
							 ParameterLength:paramLength,
							 Parameter:data,
							 MessageUID: messageuid,
							 SessionID: gSessionID};

		return aMemberFilter;
	}

	_createJSONData = function (aMemberFilter) {
		var aJSONProtocol = {protocolType:gProtocolType,
							 message:aMemberFilter,
							 hash:""};

		return JSON.stringify(aJSONProtocol);
	}

	function _setAttributeInfo (timeout) {
		var input = [];
		var aRandom = new Date().getTime() + Math.floor(Math.random() * 1000);

		input.push("setAttributeInfo");
		if (gUserCheckMode == false)
			input.push("put_CheckUserName=" + gUserCheckMode);
		input.push("check_Version=" + AnySign.mAnySignVersion);
		input.push("put_LicenseN=" + AnySign.mLicense);
		input.push("put_StorageN=" + AnySign.mStorage);
		if (AnySign.mSecurityContext) {
			input.push("put_SecContextN=" + AnySign.mSecurityContext);
			input.push("put_SecOptionN=" + AnySign.mSecurityOption);
		}
		input.push("put_LanguageN=" + AnySign.mLanguage);
		input.push("put_CharsetN=" + AnySign.mCharset);
		input.push("put_ProxyUsageN=" + AnySign.mProxyUsage);
		input.push("put_TransKeyN=");
		if (AnySign.mAnySignITGT)
			input.push("put_Integrity=" + AnySign.mAnySignITGT);
		input.push(aRandom);

		var message = _createData(input);
		var result = _createJSONData (message);

		_doAjaxSend (result,timeout);
	}

	function _setDemonInfo (timeout) {
		var input = [];
		var aRandom = new Date().getTime() + Math.floor(Math.random() * 1000);

		input.push("launcher");
		input.push(AnySign.mBrowser.aName);
		input.push(1);
		input.push(AnySign.mAnySignVersion);
		input.push(aRandom);

		var message = _createData(input);
		var result = JSON.stringify(message);

		return result;
	}

	function _sendPingInfo (payload,timeout) {
		var input = [];
		var aRandom = new Date().getTime() + Math.floor(Math.random() * 1000);

		input.push ("ping");
		input.push (payload);
		input.push (aRandom);

		var message = _createData(input);
		var result = _createJSONData(message);

		_doAjaxSend(result,timeout);
		
		return aRandom;
	}

	function _setUpdateState (type) {
		var input = [];
		var aRandom = new Date().getTime() + Math.floor(Math.random() * 1000);

		input.push (type);
		input.push (AnySign.mAnySignVersion);
		input.push (aRandom);

		var message = _createData(input);
		var result = _createJSONData(message);

		_doAjaxSend (result);
	}

	function _getLastErrCode () {
		return gErrObject.code;
	}

	function _getLastErrMsg () {
		return gErrObject.msg;
	}

	function _resetErrAndMsg () {
		gErrObject.code = "";
		gErrObject.msg = "";
	}

	function onSendToServer(value)
	{
		if (AnySign.mAnySignITGT == "")
			return 0;

		var aRet = -1;
		var aRequest = new XMLHttpRequest ();
		var aResponse = "";
		var aURL = "";
		var aMessage = "";

		aMessage = "SIGNED=" + encodeURIComponent(value);
		aMessage +=	"&ITGTVALUE=" + AnySign.mAnySignITGT;
		aMessage += "&PORTVALUE=" + gConnectPort;

		aURL = AnySign.mExtensionSetting.mIntegrityPageURL;
		aRequest.open ("POST", aURL, false);
		aRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		aRequest.send (aMessage);

		try
		{
			aResponse = eval (aRequest.responseText);

			if (parseInt (aResponse["code"]) != 0)
			{
				AnySign.mExtensionSetting.mImgIntervalError = true;

				if (AnySign.mExtensionSetting.mInstallCheck_CB != null) {
					AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_NEED_INSTALL");
					AnySign.mExtensionSetting.mInstallCheck_CB = null;
				}

				if (parseInt (aResponse["code"]) == -3)
					alert ("[AnySign for PC] 공인인증 보안 프로그램의 무결성 검증에 실패하였습니다.\n악의적 공격에 의해 수정되었을 가능성이 있습니다.\n재설치 하시거나 관리자에게 문의해주시기 바랍니다.");
				else
					alert ("[AnySign for PC] 공인인증 보안 프로그램 무결성 검증과정에서 오류가 발생하였습니다.\n재설치 하시거나 관리자에게 문의해주시기 바랍니다.\n[오류코드] : " + aResponse["code"] + "\n" + "[오류메시지] : " + aResponse["reason"]);
			}
			else
			{
				aRet = 0;
			}
		}
		catch (evalException)
		{
			alert ("[AnySign for PC] 보안 프로그램 무결성 검증 메시지 처리과정에서 예외동작이 발생하였습니다.\n[예외처리 메시지] : " + evalException + "\n[무결성 검증 응답 메시지] : " + aRequest.responseText);
		}

		return aRet;
	}

	Array.prototype.removeElement = function (index)
	{
		this.splice (index, 1);
		return this;
	}
	
	function _executeDecCallback () {
	
		var lengthCallback = AnySign.mExtensionSetting.mPageDecCallback.length;
								
		for (var indexCB = 0; indexCB < lengthCallback; indexCB++)
		{
			var aPageDecCallBack = AnySign.mExtensionSetting.mPageDecCallback[indexCB].pageDecCallback;
			var aPageDecCBParam = AnySign.mExtensionSetting.mPageDecCallback[indexCB].pageDecCallbackParam;
			
			if (aPageDecCBParam)
			{
				console.log("[AnySign for PC][AnySignAjax_executeDecCallback_03000]");
				aPageDecCallBack(aPageDecCBParam);
			}
			else
			{
				console.log("[AnySign for PC][AnySignAjax_executeDecCallback_03001]");
				aPageDecCallBack ();
			}
		}
		
		AnySign.mExtensionSetting.mPageDecCallback.splice (0, lengthCallback);
	
	}

	function _openInstallPage (installPageUrl) {

		if (installPageUrl == undefined)
		{
			return;
		}

		if (AnySign.mInstallPageNewOpen == true)
		{
			window.open(installPageUrl);
		}
		else
		{
			location.href = installPageUrl;
		}
	}

	// public
	return {
		GetWebSocket: function () {
			var port;
			if (AnySign.mPlatform.aName.indexOf("windows") != 0) {
				console.log("[AnySign for PC][AnySignAjax_GetWebSocket_00002]");
				gTrialNumber = 0;
				port = Number(AnySign.mExtensionSetting.mPort);
			}
			else {
				console.log("[AnySign for PC][AnySignAjax_GetWebSocket_00001]");
				gDirectConnect = true;
				port = Number(AnySign.mExtensionSetting.mDirectPort);
			}

			if(window.location.protocol.indexOf("https:") == 0 ) {
				gServicePort = port + 1;
				gURL = "https://127.0.0.1:" + gServicePort;
			}
			else {
				gServicePort = port;
				gURL = "http://127.0.0.1:" + gServicePort;
			}

			if (AnySign.mPlatform.aName.indexOf("windows") == 0)
				gConnectPort = gServicePort;
			
			gLauncherSocket = false;
			_getWebSocket ();
		},
		doSend: function () {
			var aRandom = new Date().getTime() + Math.floor(Math.random() * 1000);
			var mainArguments = Array.prototype.slice.call(arguments);
			mainArguments.push(aRandom);

			var message = _createData (mainArguments);
			var result = _createJSONData (message);

			_doAjaxSend(result,gSendInterval);
		},
		doAsyncSend: function () {
			var mainArguments = Array.prototype.slice.call(arguments);
			var aRandom = gRandomNumber++;

			if (mainArguments[1] == "blockDecEx")
				aDecObj = {messageuid: aRandom, elementID: mainArguments[0], funcObj: mainArguments[5], funcObjParam: mainArguments[6]}
			else if (mainArguments[1] == "blockEnc2")
				aDecObj = {messageuid: aRandom, elementID: "", funcObj: mainArguments[7], funcObjParam: mainArguments[8]}
			else if (mainArguments[1] == "blockEncConvert2")
				aDecObj = {messageuid: aRandom, elementID: "", funcObj: mainArguments[8], funcObjParam: mainArguments[9]}

			mainArguments.shift();
			mainArguments.push(aRandom);

			var message = _createData (mainArguments);
			
			gSendDataList.push (message);

			var aDecIntervalFunc = setInterval(function() { 
				if (gDecExeSend) {
					if (gSendDataList.length != 0) 
					{
						gDecExeSend = false;

						var result = _createJSONData (gSendDataList[0]);
						gSendDataList.shift ();
						_doSend (result);
					}
				}

				for (var i = 0; i < gDecResultList.length; i++)
				{
					for (var j = 0; j < gDecData.length; j++)
					{
						if (gDecResultList[i].MessageUID == gDecData[j].messageuid)
						{
							clearInterval(aDecIntervalFunc);

							if (gDecData[j].elementID) {
								SofoAnySignJQuery("#"+gDecData[j].elementID).append(gDecResultList[i].ReturnValue);
								
								var elementIDName = gDecData[j].elementID;
								var indexelementID = elementIDName.indexOf('_');
								var elementIDNumber = elementIDName.substring(indexelementID+1);
								var searchElementIDNum = parseInt(elementIDNumber) + 1;

								gDecCount++;
								
								if ( document.getElementById("EncryptionAreaID_" + searchElementIDNum) == null )
								{
									gDecIDNum = searchElementIDNum;
								}

								if (gDecCount == gDecIDNum)
								{
									AnySign.mPageBlockDecDone = true;
								}
							}

							if (gDecData[j].funcObj) {
								gDecData[j].funcObj(gDecResultList[i].ReturnValue, gDecData[j].funcObjParam);
							}
							
							if (AnySign.mExtensionSetting.mPageDecCallback.length > 0 && AnySign.mPageBlockDecDone == true)
							{
								_executeDecCallback();
							}
							
							gDecData.removeElement(j);
							gDecResultList.removeElement(i);
							break;
						}
					}
				}

			}, 10);

			gDecData.push(aDecObj);
		},
		setcallbackFunc: function (func) {
			callback = func;
		},
		getLastErrCode: function () {
			return _getLastErrCode ();
		},
		getLastErrMsg: function () {
			return _getLastErrMsg ();
		},
		resetErrAndMsg: function () {
			_resetErrAndMsg ();
		},
		resetcallbackFunc: function ()
		{
			callback = null;
		}
	};
};
