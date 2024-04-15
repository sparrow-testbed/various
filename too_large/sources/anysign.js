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

AnySignForPCExtension.AnySign = function () {
	var gURL;
	var webSocket;
	var callback = null;
	var gErrObject = {code: 0, msg: ""};
	var gSendDataList = [];
	var gDecData = [];
	var gRandomList = [];
	var gProtocolType = "general";
	var _createJSONData = null;

	var enableWS = false;
	var gProtocolFinish = false;

	var gSessionID = AnySign.mAnySignSID;

	var gServicePort;
	var gConnectPort;

	var gTrialNumber;

	var gDirectConnect;
	var gLauncherErrorCount = 0;

	var gIntegrityRet;

	var aBrowser = AnySign.mBrowser.aName;

	var gRunUpdate = false;
	var gRunUpdateN = 0;
	var gRunUpdateSuccess = false;

	var gUpdateStartTime = 0;

	var	gUserCheckMode = true;

	var gUpdateCountCheck = 0;

	var gDecCount = 0;
	var gDecIDNum = 0;

	eval(GetSafeResponse (loadSecurePro ("anySignjQuery-1.11.1.js")));

	function reRun () {
		console.log("[AnySign for PC][AnySign_reRun_02000]");
		if (webSocket != null)
			webSocket.close ();
		webSocket = null;
		enableWS = false;
		callback = null;
		AnySign.mAnySignLoad = false;
		var protocol = gURL.substring(0, gURL.length-5);
		gURL = protocol + gServicePort;

		_getWebSocket ();
	}

	function errorEventProcess () {
		if (enableWS)
		{
			console.log("[AnySign for PC][AnySign_error_10000]");
			try {
				var element = document.getElementById("xwup_title_guidewindow");
				if (element != null)
				{
					AnySign.mExtensionSetting.mDialog.oncancel ();
					alert("[AnySign for PC] 보안 프로그램이 비정상적으로 동작하였습니다. 다시 실행하겠습니다.");
				}
			} catch(e) {}
			reRun ();
		}
		else if (gRunUpdate == true)
		{
			console.log("[AnySign for PC][AnySign_error_10001]");
			var time = new Date().getTime();
			if ((time - gUpdateStartTime) > 120000)
				_openInstallPage(AnySign.mPlatform.aInstallPage);
			else
				setTimeout (reRun, 2000);
		}
		else if (gIntegrityRet == "FAILED")
		{
			console.log("[AnySign for PC][AnySign_error_10002]");
			return;
		}
		else if (gDirectConnect == true) {
			if (AnySign.mExtensionSetting.mInstallCheck_Level == 1) {
				console.log("[AnySign for PC][AnySign_error_10007]");
				AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NEED_INSTALL";

				if (AnySign.mExtensionSetting.mInstallCheck_CB != null) 
				{
					setTimeout (function () {
							AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_NEED_INSTALL");
							AnySign.mExtensionSetting.mInstallCheck_CB = null;
					}, 100);
				}
				else if (AnySign.mExtensionSetting.mIgnoreInstallPage != true)
				{
					var selectResult = confirm("[AnySign for PC] 공인인증 보안 프로그램 설치가 필요합니다.\n[확인]을 선택하시면 설치페이지로 연결됩니다.");
					
					if (selectResult)
						_openInstallPage(AnySign.mPlatform.aInstallPage);
					
					AnySign.mExtensionSetting.mImgIntervalError = true;
				}
			} else {
				var wsAttribute;
				if (webSocket.url)
					wsAttribute = webSocket.url;
				else
					wsAttribute = webSocket.URL;

				if (window.location.protocol == "http:" && wsAttribute.indexOf("wss:") == 0) {
					gServicePort = AnySign.mExtensionSetting.mDirectPort;
					gConnectPort = gServicePort;
					gURL = "ws://127.0.0.1:" + gConnectPort;
					console.log("[AnySign for PC][AnySign_error_10003]");
					_getWebSocket ();
				} else {
					console.log("[AnySign for PC][AnySign_error_10004]");
					gDirectConnect = false;
					_serviceConnect ();
				}
			}
		}
		else
		{
			var wsAttribute =  null;
			if (gTrialNumber < AnySign.mExtensionSetting.mTrialPortRange) {
				if (webSocket.url)
					wsAttribute = webSocket.url;
				else
					wsAttribute = webSocket.URL;

				var type;

				if (gServicePort%2 == 0)
				{
					//ws->wss
					type = "wss";
					gServicePort = gServicePort+3;
				}
				else
				{
					//wss->ws
					type = "ws";
					gServicePort = gServicePort-1;
					gTrialNumber++;
				}

				if (window.location.protocol == "https:" && type == "ws")
				{
					//https only wss
					type = "wss";
					gServicePort = gServicePort+3;
				}

				if (aBrowser == "explorer")
					gURL = type + "://127.0.0.1:" + gServicePort;
				else
					gURL = type + "://localhost:" + gServicePort;

				console.log("[AnySign for PC][AnySign_error_10005][" + gServicePort + "]");
				_getWebSocket ();
			}
			else {
				AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NEED_INSTALL";
				console.log("[AnySign for PC][AnySign_error_10006]");
				if (AnySign.mExtensionSetting.mInstallCheck_CB != null) 
				{
					setTimeout (function () {
							AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_NEED_INSTALL");
							AnySign.mExtensionSetting.mInstallCheck_CB = null;
					}, 100);
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
	}

	function _getWebSocket () {
		try {
			webSocket = new WebSocket(gURL);
		} catch (err) {
			alert("[AnySign for PC] 통신채널 생성에 실패하였습니다.\n[웹소켓 에러 메세지] : " + err);
		}
		
		webSocket.onopen = function(e) {
			var wsAttribute;
			if (webSocket.url)
				wsAttribute = webSocket.url;
			else
				wsAttribute = webSocket.URL;

			if (wsAttribute.indexOf(gServicePort) < 0 || gDirectConnect == true)
			{
				enableWS = true;
				if (wsAttribute.indexOf("wss:") == 0)
				{
					gProtocolFinish = true;
					_setAttributeInfo ();
				}
				else if(wsAttribute.indexOf("ws:") == 0)
				{
					Secure.start("secure", _doSend);
				}
			}
			else
			{
				setTimeout(_setDemonInfo, 30);
			}
		};

		webSocket.onclose = function(e) {			
			if (aBrowser == "safari") {
				if (AnySign.mPlatform.aName.indexOf("mac") == 0) {
					if (gRunUpdateSuccess) {
						if (gRunUpdateN < 2) {
							gRunUpdateN++;
							return;
						}
						gRunUpdateSuccess = false;
						gRunUpdateN = 0;
					}
				}
				errorEventProcess ();
			}
		};

		webSocket.onmessage = function(e) {
			var aData, aProtocolData, aContact, aFuncname, aType, aValue, aMessageUID, aSessionID;
			var isDec = false;

			aData = e.data;
			try {
				aProtocolData = JSON.parse(aData);
				aProtocolType = aProtocolData.protocolType;
				aContact = aProtocolData.message;
			} catch(e) {
				gDirectConnect = false;
				gServicePort = Number(AnySign.mExtensionSetting.mPort)+1;
				gConnectPort = gServicePort;
				reRun();
				return;
			}

			if (aProtocolType == "secure")
			{
				try {
					aMessageType = aContact.messageType;
					switch (aMessageType)
					{
						case "finish":
							if (Secure.finish (aProtocolData))
							{
								gProtocolType = "secure";
								gProtocolFinish = true;
								_createJSONData = function (message) {
									var JSONData = JSON.stringify(message);
									return Secure.sendApplication (JSONData);
								}
								_setAttributeInfo ();
							}
							else {
								_getWebSocket ();
							}
							return;
						case "application":
							aContact = JSON.parse (Secure.receiveApplication (aProtocolData));
							break;
						case "server_hello":
							Secure.handShake (_doSend, aProtocolData);
							return;
						default:
							alert("[AnySign for PC] Secure 보안프로토콜이 정상적으로 동작하지 않았습니다.\n[메시지 코드] : " + aContact.code);
							return;
					}
				}
				catch (err)
				{
					alert("[AnySign for PC] Secure 보안프로토콜에 예외동작이 발생하였습니다.\n[예외처리 메시지] : " + err);
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

				if (AnySign.mExtensionSetting.mInstallCheck_CB != null)
					AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_INTEGRITY_FAIL");
				else {
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
						console.log("[AnySign for PC][AnySign_onmessage_01000][" + gErrObject.code + "]");
						if (AnySign.mExtensionSetting.mInstallCheck_CB != null) 
						{
							AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_NEED_INSTALL");
							AnySign.mExtensionSetting.mInstallCheck_CB = null;
							return;
						}

						gLauncherErrorCount++;
						if (gLauncherErrorCount > 3) {
							AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NEED_INSTALL";
							var selectResult = confirm("AnySign for PC 공인인증 보안 프로그램 설치가 필요합니다.\n[확인]을 선택하시면 설치페이지로 연결됩니다.");
							
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
							// error
							AnySign.mExtensionSetting.mImgIntervalError = true;
	
							var msg = "[AnySign for PC] 서비스를 통한 AnySign4PC.exe 프로그램 실행에 실패하였습니다. 다시 실행하겠습니다.\n" + "[" + gErrObject.code + "] [" + eval("ANYSIGN4PC_ERROR_" + gErrObject.code) + "]";
							reRun ();
							alert(msg);
						}
					}
					else if (gErrObject.code == "30001")
					{
						console.log("[AnySign for PC][AnySign_onmessage_01001]");
						// update
						if (AnySign.mExtensionSetting.mInstallCheck_CB != null) 
						{
							webSocket.close ();
							setTimeout (function () {
								AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_NEED_UPDATE");
								AnySign.mExtensionSetting.mInstallCheck_CB = null;
							}, 100);
							return;
						}

						if (AnySign.mAnySignLiveUpdate)
						{
							if (gRunUpdate) {
								var time = new Date().getTime();
								if ((time - gUpdateStartTime) > 120000)
									_openInstallPage(AnySign.mPlatform.aInstallPage);
								else
									setTimeout (_setDemonInfo, 2000);
							} else {
								gUpdateStartTime = new Date().getTime();
								console.log ("send message: updateready");
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
						// run Demon
						var portList = aValue.split(","); 
						var protocol = gURL.substring(0, gURL.length-5);
						if (protocol.indexOf("wss:") == 0)
						{
							gConnectPort = portList[1];
							gURL = protocol + portList[1];
						}
						else
						{
							gConnectPort = portList[0];
							gURL = protocol + portList[0];
						}

						console.log("[AnySign for PC][AnySign_onmessage_01002][" + gConnectPort + "]");

						webSocket = null;

						if (gRunUpdate && AnySign.mPlatform.aName.indexOf("windows") == 0)
						{
							if(gUpdateCountCheck < 30)
							{
								if (protocol.indexOf("wss:") == 0)
								{
									gConnectPort = Number(AnySign.mExtensionSetting.mDirectPort)+1;
								}
								else
								{
									gConnectPort = AnySign.mExtensionSetting.mDirectPort;
								}
								gURL = protocol + gConnectPort;
								gUpdateCountCheck++;
							}
							setTimeout (_getWebSocket, 2000);
						}
						else
						{
							_getWebSocket ();
						}
					}
					else
					{
						if (AnySign.mPlatform.aName.indexOf("windows") == 0 && gErrObject.code == 20005)
							return;

						AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NEED_INSTALL";
						var selectResult = confirm("[AnySign for PC] 공인인증 보안 프로그램 설치가 필요합니다.\n[확인]을 선택하시면 설치페이지로 연결됩니다.");
						
						if (selectResult)
							_openInstallPage(AnySign.mPlatform.aInstallPage);

						AnySign.mExtensionSetting.mImgIntervalError = true;
					}
					break;
				case "setAttributeInfo":
					if (gErrObject.code == 30006 || gErrObject.code == 30001) {
						webSocket.close ();
						console.log("[AnySign for PC][AnySign_onmessage_01003][" + gErrObject.code + "]");
						gDirectConnect = false;
						gProtocolFinish = false;
						_serviceConnect ();
						return;
					}

					AnySign.mAnySignLoad = true;
					console.log("[AnySign for PC][AnySign_onmessage_01004]");

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
						webSocket.close ();
						webSocket = null;
						console.log("[AnySign for PC][AnySign_onmessage_01005]");

						return;
					}

					if (gRunUpdate)
					{
						console.log("LiveUpdate success");
						gRunUpdate = false;
						if (aBrowser == "safari" && AnySign.mPlatform.aName.indexOf("mac") == 0) {
							gRunUpdateSuccess = true;
						}
					}

					AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NORMAL";

					setTimeout( function () {
						if ( document.getElementById("EncryptionAreaID_0") == null )
						{
							AnySign.mPageBlockDecDone = true;
							_executeDecCallback();
						}
					}, 1000);
					
					while (gSendDataList[0])
					{
						var result = _createJSONData (gSendDataList[0]);
						gSendDataList.shift();
						_doSend (result);
					}
						
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
					break;
				case "blockDecEx":
					for (var index = 0; index < gDecData.length; index++)
					{
						if (gDecData[index].messageuid == aMessageUID)
						{
							if (gDecData[index].elementID) {
								SofoAnySignJQuery("#"+gDecData[index].elementID).append(aValue);
								
								var elementIDName = gDecData[index].elementID;
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

							if(gDecData[index].funcObj) {
								gDecData[index].funcObj (aValue, gDecData[index].funcObjParam);
							}
							
							if (AnySign.mExtensionSetting.mPageDecCallback.length > 0 && AnySign.mPageBlockDecDone == true)
							{
								_executeDecCallback();
							}

							gDecData.splice (index, 1);
						}
					}
					break;
				case "blockEnc":
				case "blockEnc2":
				case "blockEncConvert2":
					if (callback && gDecData.length == 0) {
						callback (aValue);
					}
					else {
						for (var index = 0; index < gDecData.length; index++)
						{
							if (gDecData[index].messageuid == aMessageUID)
							{
								if(gDecData[index].funcObjParam) {
									gDecData[index].funcObj (aValue, gDecData[index].funcObjParam);
								}
								else {
									gDecData[index].funcObj (aValue);
								}

								gDecData.splice (index, 1);
							}
						}
					}
					break;
				case "updateready":
					console.log ("receive message: updateready");
					if (gErrObject.code == 0)
					{
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

						gRunUpdate = true;
						console.log ("send message: updatestart");
						_setUpdateState ("updatestart");
						setTimeout (reRun, 5000);
					}
					else
					{
						alert("[AnySign for PC] 보안 프로그램의 업데이트 설치에 실패하였습니다. 설치페이지로 이동합니다.\n" + "[오류코드] : " + gErrObject.code);
						_openInstallPage(AnySign.mPlatform.aInstallPage);
					}
					break;
				case "updatestart":
					console.log ("receive message: updatestart");
					break;
				default:
					if (callback)
						callback (aValue);
			}
		};

		webSocket.onerror = function(e) {
			errorEventProcess ();
		};
	}

	function _doSend (message) {
		if (webSocket.readyState == 0) {
			setTimeout (function () {_doSend(message);}, 500);
		} else {
			webSocket.send(message);
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
	
		// Create 'message' 
		var aMemberFilter = {InterfaceName:interfaceName,
							 ParameterLength:paramLength,
							 Parameter:data,
							 MessageUID: messageuid,
							 SessionID: gSessionID};

		return aMemberFilter;
	}

	_createJSONData = function (aMemberFilter) {
		// Create protocol json text
		var aJSONProtocol = {protocolType:gProtocolType,
							 message:aMemberFilter,
							 hash:""};

		return JSON.stringify(aJSONProtocol);
	}

	function _setAttributeInfo () {
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

		_doSend (result);
	}

	function _setDemonInfo () {
		var input = [];
		var aRandom = new Date().getTime() + Math.floor(Math.random() * 1000);

		input.push("launcher");
		
		if( AnySign.mBrowser.aSearchWord.indexOf("Edge") != -1 )
			input.push("edge");
		else
			input.push(aBrowser);
		
		input.push(1);
		input.push(AnySign.mAnySignVersion);
		input.push(aRandom);

		var message = _createData(input);
		var result = JSON.stringify(message);

		_doSend (result);
	}

	function _getVersionInfo () {
		var input = [];
		var aRandom = new Date().getTime() + Math.floor(Math.random() * 1000);

		input.push ("getVersionInfo");
		input.push ("");
		input.push (aRandom);

		var message = _createData(input);
		var result = _createJSONData(message);

		_doSend (result);
	}

	function _setUpdateState (type) {
		var input = [];
		var aRandom = new Date().getTime() + Math.floor(Math.random() * 1000);

		input.push (type);
		input.push (AnySign.mAnySignVersion);
		input.push (aRandom);

		var message = _createData(input);
		var result = _createJSONData(message);

		_doSend (result);
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

	function _getRandomUID () {
		var randN;
		var getRandomFlag = false;
		while(!getRandomFlag)
		{
			randN = Math.floor(Math.random() * 1000);
			gRandomList.push(randN);
			if (gRandomList.length == 1)
				getRandomFlag = true;

			for (var i = 0; i < gRandomList.length-1; i++)
			{
				if (gRandomList[i] == randN)
				{
					getRandomFlag = false;
					break;
				}
				else
					getRandomFlag= true;
			}

			if (getRandomFlag)
				break;
		}
		return randN;
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
				AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_NEED_INSTALL");

				if (AnySign.mExtensionSetting.mInstallCheck_CB != null) {
					AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_NEED_INSTALL");
					AnySign.mExtensionSetting.mInstallCheck_CB = null;
					return;
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

	function _serviceConnect () {
		gDirectConnect = false;
		gServicePort = Number(AnySign.mExtensionSetting.mPort)+1;

		if (aBrowser == "explorer")
			gURL = "wss://127.0.0.1:" + gServicePort;
		else
			gURL = "wss://localhost:" + gServicePort;

		gTrialNumber = 0;
		_getWebSocket ();
	}
	
	function _executeDecCallback () {
		
		var lengthCallback = AnySign.mExtensionSetting.mPageDecCallback.length;
								
		for (var indexCB = 0; indexCB < lengthCallback; indexCB++)
		{
			var aPageDecCallBack = AnySign.mExtensionSetting.mPageDecCallback[indexCB].pageDecCallback;
			var aPageDecCBParam = AnySign.mExtensionSetting.mPageDecCallback[indexCB].pageDecCallbackParam;
			
			if (aPageDecCBParam)
			{
				console.log("[AnySign for PC][AnySign_executeDecCallback_03000]");
				
				aPageDecCallBack(aPageDecCBParam);
			}
			else
			{
				console.log("[AnySign for PC][AnySign_executeDecCallback_03001]");
				
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
			// default wss
			if (AnySign.mPlatform.aName.indexOf("windows") == 0)
			{
				console.log("[AnySign for PC][AnySign_GetWebSocket_00001]");
				gDirectConnect = true;
				gServicePort = Number(AnySign.mExtensionSetting.mDirectPort)+1;
				gConnectPort = gServicePort;
				if (aBrowser == "explorer")
					gURL = "wss://127.0.0.1:" + gServicePort;
				else
					gURL = "wss://localhost:" + gServicePort;

				_getWebSocket ();
			}
			else
			{
				console.log("[AnySign for PC][AnySign_GetWebSocket_00002]");
				_serviceConnect ();
			}
		},
		doSend: function () {
			var aRandom = new Date().getTime() + Math.floor(Math.random() * 100) + 1;
			var mainArguments = Array.prototype.slice.call(arguments);
			mainArguments.push(aRandom);

			var message = _createData (mainArguments);
			var result = _createJSONData (message);

			_doSend(result);
		},
		doAsyncSend: function () {
			var mainArguments = Array.prototype.slice.call(arguments);
			var aRandom = _getRandomUID ();
			var aDecObj;
			if (mainArguments[1] == "blockDecEx")
				aDecObj = {messageuid: aRandom, elementID: mainArguments[0], funcObj: mainArguments[5], funcObjParam: mainArguments[6]}
			else if (mainArguments[1] == "blockEnc2")
				aDecObj = {messageuid: aRandom, elementID: "", funcObj: mainArguments[7], funcObjParam: mainArguments[8]}
			else if (mainArguments[1] == "blockEncConvert2")
				aDecObj = {messageuid: aRandom, elementID: "", funcObj: mainArguments[8], funcObjParam: mainArguments[9]}

			gDecData.push(aDecObj);

			mainArguments.shift();
			mainArguments.push(aRandom);

			var message = _createData (mainArguments);
			var result = _createJSONData (message);
			
			if (gProtocolFinish)
				_doSend(result);
			else
				gSendDataList.push(message);
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
