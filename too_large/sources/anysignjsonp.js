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

AnySignForPCExtension.AnySignJSONP = function () {
	var	JSONPObject = null,
		JpMap,
		gSendDataList,
		gResendCount = 0,
		gReceiveDataList = [],
		gDecDataList = [],
		gURL,
		gConnectPort,
		gIntegrityRet,
		gTrialNumber,
		gDirectConnect,
		gDirectConnectFailCount = 0,
		gConnectFailCount = 0,
		gLauncherErrorCount = 0,
		gRandomNumber = new Date().getTime() + Math.floor(Math.random() * 1000);
		gBlockSize = 800,
		gSessionID = AnySign.mAnySignSID,
		gProtocolType = "general",
		gCallback = null,
		gRunUpdate = false,
		gUpdateStartTime = 0,
		gIdleTime = 20000,
		gLastMessageTime = null,
		gPingFunction = null,
		gPongMessage = "",
		gPingPongStart = false,
		gAjaxTimeout = 5000,
		gSetTimeoutObj1 = null,
		gSetTimeoutObj2 = null,
		gErrObject = {code: 0, msg: ""};

		var	gUserCheckMode = true;

		var	gDecCount = 0,
		gDecIDNum = 0;


	eval(GetSafeResponse (loadSecurePro ("json2.js")));
	eval(GetSafeResponse (loadSecurePro ("anySignjQuery-1.11.1.js")));

	try {
		if (AnySign.mExtensionSetting.mIsIE7 == false) {
			gBlockSize = 2048;
		}
	} catch (e) {}

	JpMap = function () {
		this.map = new Object();
	}

	JpMap.prototype = {
		put: function (key, value) {
			this.map[key] = value;
		},
		get: function (key) {
			return this.map[key];
		},
		remove: function (key) {
			delete this.map[key];
		},
		size: function () {
			var count = 0;
			for (var prop in this.map) {
				count++;
			}
			return count;
		},
		shift: function (key) {
			this.map[key].shift ();
		}
	}

	gSendDataList = new JpMap ();

	function _startJSONP () {
		this.isConnected = false;
		this.settingOK = false;
		this.isExec = true;
		this.isReadySendPing = true;
		this.send = function (aRequestMessage) {
			SofoAnySignJQuery.ajax({
				url: gURL,
				type: 'GET',
				scriptCharset: "utf-8",
				data: {'senddata': aRequestMessage},
				dataType: 'jsonp',
				jsonp: 'callback',
				timeout: gAjaxTimeout,
				success: function (aResultData) {

					gLastMessageTime = new Date().getTime();

					if (typeof aResultData.message == "undefined") {
						gReceiveDataList.push (aResultData);
					}
					else if (aResultData.message.InterfaceName == "pong") {
						gPongMessage = aResultData.message.ReturnValue;
						JSONPObject.isConnected = true;
					}
					else {
						gReceiveDataList.push (aResultData.message);
					}

					JSONPObject.isExec = true;
				},
				error: function () {
					if (gRunUpdate == true)
					{
						console.log("[AnySign for PC][AnySignJSONP_error_10001]");
						var time = new Date().getTime();
						if ((time - gUpdateStartTime) > 120000)
							_openInstallPage(AnySign.mPlatform.aInstallPage);
						else
							setTimeout (reRun, 2000);
					}
					else if (gDirectConnect == true) {
						if (AnySign.mExtensionSetting.mInstallCheck_Level == 1) {
							console.log("[AnySign for PC][AnySignJSONP_error_10007]");
							AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NEED_INSTALL";
							
							if (AnySign.mExtensionSetting.mInstallCheck_CB != null) 
							{
								if (gSetTimeoutObj1) {
									clearInterval (gSetTimeoutObj1);
									gSetTimeoutObj1 = null;
								}

								if (gSetTimeoutObj2) {
									clearInterval (gSetTimeoutObj2);
									gSetTimeoutObj2 = null;
								}

								AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_NEED_INSTALL");
								AnySign.mExtensionSetting.mInstallCheck_CB = null;
							}
							else 
							{
								var selectResult = confirm("AnySign for PC 공인인증 보안 프로그램 설치가 필요합니다.\n[확인]을 선택하시면 설치페이지로 연결됩니다.");

								if (selectResult)
									_openInstallPage(AnySign.mPlatform.aInstallPage);

								AnySign.mExtensionSetting.mImgIntervalError = true;
							}
						} else {
							gDirectConnectFailCount++;
							if (gDirectConnectFailCount >= 5) {
								clearInterval (gSetTimeoutObj1);
								gSetTimeoutObj1 = null;
								gDirectConnectFailCount = 0;
								gDirectConnect = false;
								gServicePort = Number(AnySign.mExtensionSetting.mPort) + 1;
								gTrialNumber = 0;
								console.log("[AnySign for PC][AnySignJSONP_error_10004]");

								reRun ();
							} else {
								console.log("[AnySign for PC][AnySignJSONP_error_10007][" + gDirectConnectFailCount + "]");
								JSONPObject = null;
								setTimeout (_getWebSocket, 1000);
							}
						}
					}
					else if (JSONPObject.isConnected == true)
					{
						console.log("[AnySign for PC][AnySignJSONP_error_10000]");
						if (gConnectFailCount > 3)
						{
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
					else if (gIntegrityRet == "FAILED")
					{
						console.log("[AnySign for PC][AnySignJSONP_error_10002]");
						return;
					}
					else
					{
						if (gTrialNumber < AnySign.mExtensionSetting.mTrialPortRange) {
							gTrialNumber++;
							gServicePort = gServicePort + 2;							
							console.log("[AnySign for PC][AnySignJSONP_error_10005][" + gServicePort + "]");
							reRun();
						}
						else {
							console.log("[AnySign for PC][AnySignJSONP_error_10006]");
							if (AnySign.mExtensionSetting.mInstallCheck_CB != null) 
							{
								if (gSetTimeoutObj1) {
									clearInterval (gSetTimeoutObj1);
									gSetTimeoutObj1 = null;
								}

								if (gSetTimeoutObj2) {
									clearInterval (gSetTimeoutObj2);
									gSetTimeoutObj2 = null;
								}

								AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_NEED_INSTALL");
								AnySign.mExtensionSetting.mInstallCheck_CB = null;
							}
							else 
							{
								AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NEED_INSTALL";
								var selectResult = confirm("AnySign for PC 공인인증 보안 프로그램 설치가 필요합니다.\n[확인]을 선택하시면 설치페이지로 연결됩니다.");

								if (selectResult)
									_openInstallPage(AnySign.mPlatform.aInstallPage);

								AnySign.mExtensionSetting.mImgIntervalError = true;
							}
						}
					}
				}
			});
		}
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

	function _onMessage (aData, aElementID, aFunc, aFuncParam) {
		try {
			var aInterfaceName = aData.InterfaceName;
			var aType = aData.ReturnType;
			var aValue = aData.ReturnValue;
			var aMessageUID = aData.MessageUID;
		} catch(e) {
			gDirectConnect = false;
			gServicePort = Number(AnySign.mExtensionSetting.mPort) + 1;
			gConnectPort = gServicePort;
			reRun();
			return;
		}

		if (aType == "number")
			aValue = Number(aData.ReturnValue);
		else
			aValue = aData.ReturnValue;

		gErrObject.code = aData.InterfaceErrorCode;
		gErrObject.msg = aData.InterfaceErrorMessage;

		if (gErrObject.code == "21000") {
			alert("[AnySign for PC] 공인인증 보안 프로그램의 동작을 중지합니다.\n악의적 공격에 의해 수정되었을 가능성이 있습니다.\n재설치 하시기 바랍니다.");

			if (AnySign.mExtensionSetting.mInstallCheck_CB != null)
				AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_INTEGRITY_FAIL");
			else
				_openInstallPage(AnySign.mPlatform.aInstallPage);

			return;
		}

		if (gErrObject.code == "20004") {
			console.log("[AnySign for PC][AnySignJSONP_onmessage_01010]");
			if (gResendCount > 5) {
				gResendCount = 0;
				AnySign.mExtensionSetting.mImgIntervalError = true;
				alert ("[AnySign for PC] 공인인증 보안 프로그램 통신과정에서 오류가 발생하였습니다.\n[오류메세지] bad parameter");
				return;
			}

			var aResendData = gSendDataList.get (aMessageUID);
			if (typeof aResendData == "undefined") {
				// error
				AnySign.mExtensionSetting.mImgIntervalError = true;
				console.log("[AnySign for PC][AnySignJSONP_onmessage_01011][" + aMessageUID + "]");
			} else {
				gResendCount++;
				_doSend ("", aMessageUID, 0, aResendData.length, aElementID, true, aFunc, aFuncParam);
			}
			return;
		}
		else {
			gResendCount = 0;
			gSendDataList.remove (aMessageUID);
		}

		switch (aInterfaceName)
		{
			case "launcher":
				if (gErrObject.code == "30000" || gErrObject.code == "30002" ||
					gErrObject.code == "30003" || gErrObject.code == "30004" || gErrObject.code == "30005")
				{
					console.log("[AnySign for PC][AnySignJSONP_onmessage_01000][" + gErrObject.code + "]");
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

						gURL = "https://127.0.0.1:" + gServicePort;

						if (JSONPObject == null) {
							JSONPObject = new _startJSONP ();
						}
						
						_setAttributeInfo ();
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
					console.log("[AnySign for PC][AnySignJSONP_onmessage_01001]");
					// update
					if (AnySign.mExtensionSetting.mInstallCheck_CB != null) 
					{
						AnySign.mExtensionSetting.mInstallCheck_CB ("ANYSIGN4PC_NEED_UPDATE");
						AnySign.mExtensionSetting.mInstallCheck_CB = null;
						return;
					}

					if (AnySign.mAnySignLiveUpdate) {
						if (gRunUpdate) {
							console.log("update continue");
							var time = new Date().getTime();
							if ((time - gUpdateStartTime) > 120000)
								_openInstallPage(AnySign.mPlatform.aInstallPage);
							else
								setTimeout (_setDemonInfo, 2000);
						} else {
							gUpdateStartTime = new Date().getTime();
							gAjaxTimeout = 120000;
							setTimeout (function () {
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
							}, 2000);
							_setUpdateState ("updateready");
						}
					}
					else {
						AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NEED_INSTALL";
						var selectResult = confirm("[AnySign for PC] 공인인증 보안 프로그램 설치가 필요합니다.\n[확인]을 선택하시면 설치페이지로 연결됩니다.");

						if (selectResult) {
							if (AnySign.mExtensionSetting.mIgnoreInstallPage != true)
								_openInstallPage(AnySign.mPlatform.aInstallPage);
						}

						AnySign.mExtensionSetting.mImgIntervalError = true;
					}
				}
				else if (gErrObject.code == 0)
				{
					// run Demon
					var portList = aValue.split(","); 
					var protocol = gURL.substring(0, gURL.length-5);
					gURL = protocol + portList[1];
					gConnectPort = portList[1];

					console.log("[AnySign for PC][AnySignJSONP_onmessage_01002][" + gConnectPort + "]");

					if (gRunUpdate)
					{
						gRunUpdate = false;
						setTimeout (function () {
										JSONPObject = new _startJSONP ();
										_sendPingInfo ();
										_setAttributeInfo ();
									}, 2000);
					}
					else
					{
						//JSONPObject = new _startJSONP ();
						_setAttributeInfo ();
					}
				}
				else
				{
					_openInstallPage(AnySign.mPlatform.aInstallPage);
				}
				break;
			case "setAttributeInfo":
				if (gErrObject.code == 30006 || gErrObject.code == 30001) {
					console.log("[AnySign for PC][AnySignJSONP_onmessage_01003][" + gErrObject.code + "]");
					gServicePort = Number(AnySign.mExtensionSetting.mPort) + 1;
					gDirectConnect = false;
					reRun ();
					return;
				}

				AnySign.mAnySignLoad = true;
				console.log("[AnySign for PC][AnySignJSONP_onmessage_01004]");
				gAjaxTimeout = 120000;

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
					gIntegrityRet = "FAILED";
					JSONPObject.isConnected = false;
					console.log("[AnySign for PC][AnySignJSONP_onmessage_01005]");

					return;
				}

				AnySign.mExtensionSetting.mInstallCheck_State = "ANYSIGN4PC_NORMAL";
				
				if ( document.getElementById("EncryptionAreaID_0") == null )
				{
					AnySign.mPageBlockDecDone = true;
					_executeDecCallback();
				}
				//
				
				{
					var i = 0;
					function send () {
						if (i < gDecDataList.length) {
							_doSend (gDecDataList[i].message, gDecDataList[i].messageuid, 0, 0, gDecDataList[i].elementid, false, gDecDataList[i].funcObj, gDecDataList[i].funcObjParam);
							i++;
							setTimeout (send, 30);
						}
						else
						{
							gDecDataList = [];
						}
					}
					send ();

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

				// ping pong start.
				if (gPingFunction == null)
					gPingFunction = setInterval(_checkPingPong, 30000);
				break;
			case "blockDecEx":
				if (aElementID) {
					SofoAnySignJQuery ("#"+aElementID).append(aValue);
					
					var elementIDName = aElementID;
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

				if (aFunc) {
					aFunc (aValue, aFuncParam);
				}
				
				if (AnySign.mExtensionSetting.mPageDecCallback.length > 0 && AnySign.mPageBlockDecDone == true)
				{
					_executeDecCallback();
				}
				
				break;
			case "blockEnc":
			case "blockEnc2":
			case "blockEncConvert2":
				if (gCallback) {
					var exeFunc = gCallback;
					gCallback = null;
					exeFunc (aValue);
				} else {
					aFunc (aValue, aFuncParam);
				}
				break;
			case "updateready":
				if (gErrObject.code == 0)
				{
					gRunUpdate = true;
					_setUpdateState ("updatestart");
				}
				else
				{
					alert("[AnySign for PC] 보안 프로그램의 업데이트 설치에 실패하였습니다. 설치페이지로 이동합니다.\n" + "[오류코드] : " + gErrObject.code);
					_openInstallPage(AnySign.mPlatform.aInstallPage);
				}
				break;
			case "updatestart":
				setTimeout (reRun, 0);
				break;
			default:
				if (gCallback) {
					var exeFunc = gCallback;
					gCallback = null;
					exeFunc (aValue);
				}
		}
	}

	function reRun () 
	{
		gURL = "https://127.0.0.1:" + gServicePort;
		JSONPObject = null;
		JSONPObject = new _startJSONP ();

		_sendPingInfo ();
		_setDemonInfo ();
	}
	
	_doSend = function (aMessage, aMessageUID, aCurrentCnt, aTotalCnt, aElementID, isSplitData, aFuncObj, aFuncObjParam)
	{
		if (JSONPObject.isConnected == false) return;

		gLastMessageTime = new Date().getTime();

		if (isSplitData == false)
		{
			_splitMessage (aMessage, aMessageUID, aElementID, aFuncObj, aFuncObjParam);
			return;
		}

		JSONPObject.isReadySendPing = false;

		var aRequestJSONPData = new _setRequestJSONPData (aMessageUID, aCurrentCnt, aTotalCnt, aElementID, aFuncObj, aFuncObjParam);

		var aIntervalID = setInterval(function () {

			if( aRequestJSONPData == null || typeof aRequestJSONPData == "undefined")
			{
				clearInterval (aIntervalID);
				return;
			}
			
			if (aRequestJSONPData.sendOK == true && JSONPObject.isConnected == true && JSONPObject.isExec == true)
			{
				var data;

				JSONPObject.isExec = false;

				data = gSendDataList.get (aRequestJSONPData.messageuid);
				data = data[aCurrentCnt];
				if (typeof data == "undefined") {
					data = "";
				}
				data = _createData (data, aRequestJSONPData, true);

				JSONPObject.send (data);
				data = null;
				aRequestJSONPData.sendOK = false;
			}
			
			for (var i = 0; i < gReceiveDataList.length; i++)
			{
				if (gReceiveDataList[i].MessageUID == aRequestJSONPData.messageuid)
				{
					clearInterval (aIntervalID);

					if (gReceiveDataList[i].InterfaceName == "JSONP")
					{
						var currentCnt = ++aRequestJSONPData.currentCnt;
						var totalCnt = aRequestJSONPData.totalCnt;
						gReceiveDataList.splice (i, 1);
						_doSend ("", aMessageUID, currentCnt, totalCnt, aElementID, true, aFuncObj, aFuncObjParam);
					}
					else
					{
						_onMessage (gReceiveDataList[i], aRequestJSONPData.elementid, aRequestJSONPData.funcObj, aRequestJSONPData.funcObjParam);
						aRequestJSONPData = null;
						gReceiveDataList.splice (i, 1);
						JSONPObject.isReadySendPing = true;
					}
				}
			}
		}, 10);
	}

	_splitMessage = function (aMessage, aMessageUID, aElementID, aFuncObj, aFuncObjParam) 
	{
		var dataList = [];
		var index = 0;

		var size = aMessage.length;
		var splitSize = parseInt (size/gBlockSize);

		if ( (size%gBlockSize) > 0)
			splitSize++;

		for (var i = 0; i < splitSize; i++)
		{
			index += gBlockSize;
			var sData = aMessage.substring (i*gBlockSize, index);

			dataList.push (sData);
		}

		gSendDataList.put (aMessageUID, dataList);
		_doSend (aMessage, aMessageUID, 0, splitSize, aElementID, true, aFuncObj, aFuncObjParam);
	}

	function _checkPingPong () {
		var currentTime = new Date().getTime();
		if ((currentTime - gLastMessageTime) > gIdleTime) {
			if (JSONPObject.isExec == true) {
				JSONPObject.isExec = false;
				if (gPongMessage != "heartbeat" && gPingPongStart == true)
				{
					// assume Local Server is disable or not executed.
					clearInterval (gPingFunction);
					reRun ();
				}
				else
				{
					_sendPingInfo ();
				}
			}
		}
	}

	//------------------------------------------------------------------------------
	// create data.
	//------------------------------------------------------------------------------
	_createJSONData = function (aMemberFilter) {
		// Create protocol json text
		var aJSONProtocol = {protocolType:gProtocolType,
							 message:aMemberFilter,
							 hash:""};

		return JSON.stringify(aJSONProtocol);
	}

	function _setRequestJSONPData (aMessageUID, aCurrentCnt, aTotalCnt, aElementID, aFuncObj, aFuncObjParam)
	{
		this.messageuid = aMessageUID;
		this.funcObj = aFuncObj;
		this.funcObjParam = aFuncObjParam;
		this.currentCnt = aCurrentCnt;
		this.totalCnt = aTotalCnt;
		this.elementid = aElementID;
		this.sendOK = true;
	}

	function _createData (args, infoObject, isBase64)
	{
		// Create protocol message
		var interfaceName,
			paramLength,
			messageuid,
			data = [];

		if (isBase64)
			interfaceName = "JSONP";
		else
			interfaceName = args[0];

		if (isBase64)
		{
			data[0] = infoObject.currentCnt.toString();
			data[1] = infoObject.totalCnt.toString();
			data[2] = args;

			messageuid = infoObject.messageuid.toString();
			paramLength = "3";
		}
		else
		{
			messageuid = args[args.length-1];
			messageuid = messageuid.toString();
			for (i = 0; i < args.length-2; i++)
				data[i] = String(args[i+1]);

			paramLength = String(args.length-2);
		}
	
		// Create 'message' 
		var aMemberFilter = {InterfaceName:interfaceName,
							 ParameterLength:paramLength,
							 Parameter:data,
							 MessageUID: messageuid,
							 SessionID: gSessionID};

		if (isBase64)
			return JSON.stringify (aMemberFilter);
		else
			return aMemberFilter;
	}
	//------------------------------------------------------------------------------
	//------------------------------------------------------------------------------

	//------------------------------------------------------------------------------
	// setting.
	//------------------------------------------------------------------------------
	function _setAttributeInfo () {
		if (gSetTimeoutObj1) {
			clearInterval (gSetTimeoutObj1);
			gSetTimeoutObj1 = null;
		}

		gSetTimeoutObj1 = setInterval (function () {
			var result,
				message,
				input = [],
				aRandom = gRandomNumber++;

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

			message = _createData(input, false);
			result = _createJSONData (message);
			result = encodeURIComponent (result);

			if(JSONPObject == null) {
                clearInterval (gSetTimeoutObj1);
                gSetTimeoutObj1 = null;
            } else if(JSONPObject.isConnected && JSONPObject.isExec){
                clearInterval (gSetTimeoutObj1);
                gSetTimeoutObj1 = null;
                _doSend (result, aRandom, 0, 0, "", false);
            }
		}, 1000);
	}

	function _setDemonInfo () {
		if (gSetTimeoutObj2) {
			clearInterval (gSetTimeoutObj2);
			gSetTimeoutObj2 = null;
		}

		gSetTimeoutObj2 = setInterval (function () {
			var input = [],
				aRandom = gRandomNumber++;

			input.push("launcher");
			input.push(AnySign.mBrowser.aName);
			input.push(1);
			input.push(AnySign.mAnySignVersion);
			input.push(aRandom);

			var message = _createData(input, false);
			var result = JSON.stringify(message);
			result = encodeURIComponent (result);

			if(JSONPObject == null) {
                clearInterval (gSetTimeoutObj2);
                gSetTimeoutObj2 = null;
            } else if(JSONPObject.isConnected && JSONPObject.isExec){
                clearInterval (gSetTimeoutObj2);
                gSetTimeoutObj2 = null;
                _doSend (result, aRandom, 0, 0, "", false);
            }
		}, 1000);
	}

	function _setUpdateState (type) {
		var input = [],
			aRandom = gRandomNumber++;

		input.push (type);
		input.push (AnySign.mAnySignVersion);
		input.push (aRandom);

		var message = _createData(input);
		var result = _createJSONData(message);
		result = encodeURIComponent (result);

		setTimeout(function(){
			_doSend (result, aRandom, 0, 0, "", false);
		}, 1000);
	}

	function _sendPingInfo () {
		if(JSONPObject.isReadySendPing == false) {
			return;
		}

		var input = [],
			aRandom = gRandomNumber++;

		input.push ("ping");
		input.push ("heartbeat");
		input.push (aRandom);

		var message = _createData(input);
		var result = _createJSONData(message);
		result = encodeURIComponent (result);

		result = _createData (result, {messageuid: aRandom, currentCnt: 0, totalCnt: 1}, true);
		gPingPongStart = true;

		JSONPObject.send (result);
	}
	//------------------------------------------------------------------------------
	//------------------------------------------------------------------------------

	//------------------------------------------------------------------------------
	// etc.
	//------------------------------------------------------------------------------
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
	
	function _executeDecCallback () {
	
		var lengthCallback = AnySign.mExtensionSetting.mPageDecCallback.length;
					
		for (var indexCB = 0; indexCB < lengthCallback; indexCB++)
		{						
			var aPageDecCallBack = AnySign.mExtensionSetting.mPageDecCallback[indexCB].pageDecCallback;
			var aPageDecCBParam = AnySign.mExtensionSetting.mPageDecCallback[indexCB].pageDecCallbackParam;
			
			if (aPageDecCBParam)
			{
				console.log("[AnySign for PC][AnySignJSONP_executeDecCallback_03000]");
				aPageDecCallBack(aPageDecCBParam);
			}
			else
			{
				console.log("[AnySign for PC][AnySignJSONP_executeDecCallback_03001]");
				aPageDecCallBack ();
			}
		}
		
		AnySign.mExtensionSetting.mPageDecCallback.splice (0, lengthCallback);
		
	}

	function _getWebSocket () {
		if (AnySign.mPlatform.aName.indexOf("windows") == 0) {
			console.log("[AnySign for PC][AnySignJSONP_GetWebSocket_00001]");
			gDirectConnect = true;
			gServicePort = Number(AnySign.mExtensionSetting.mDirectPort)+1;
			gConnectPort = gServicePort;
		} else {
			console.log("[AnySign for PC][AnySignJSONP_GetWebSocket_00002]");
			gServicePort = Number(AnySign.mExtensionSetting.mPort) + 1;
		}

		gURL = "https://127.0.0.1:" + gServicePort;

		if (JSONPObject == null) {
			JSONPObject = new _startJSONP ();
		}

		if (AnySign.mPlatform.aName.indexOf("windows") == 0) {
			_sendPingInfo();
			_setAttributeInfo ();
		}
		else {
			gTrialNumber = 0;
			_setDemonInfo ();
		}
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
	//------------------------------------------------------------------------------
	//------------------------------------------------------------------------------

	return {
		GetWebSocket: function () {
			_getWebSocket ();
		},
		doSend: function () {
			var aRandomN = gRandomNumber++;
			var mainArguments = Array.prototype.slice.call(arguments);
			mainArguments.push(aRandomN);

			var message = _createData (mainArguments);
			var result = _createJSONData (message);
			result = encodeURIComponent (result);

			_doSend (result, aRandomN, 0, 0, "", false);
		},
		doAsyncSend: function () {
			var mainArguments = Array.prototype.slice.call(arguments);
			var aRandomN = gRandomNumber++;
			var aElementID = mainArguments[0];

			mainArguments.shift();
			mainArguments.push(aRandomN);

			var message = _createData (mainArguments);
			var result = _createJSONData (message);
			result = encodeURIComponent (result);

			var argument_funcObj, argument_funcObjParam;
			if (mainArguments[0] == "blockDecEx") {
				argument_funcObj = mainArguments[4]
				argument_funcObjParam = mainArguments[5]
			}
			else if (mainArguments[0] == "blockEnc2") {
				argument_funcObj = mainArguments[6]
				argument_funcObjParam = mainArguments[7]
			}
			else if (mainArguments[0] == "blockEncConvert2") {
				argument_funcObj = mainArguments[7]
				argument_funcObjParam = mainArguments[8]
			}

			if (AnySign.mAnySignLoad) 
				_doSend (result, aRandomN, 0, 0, aElementID, false, argument_funcObj, argument_funcObjParam);
			else
				gDecDataList.push ({messageuid: aRandomN, message: result, elementid: aElementID, funcObj: argument_funcObj, funcObjParam: argument_funcObjParam});
		},
		setcallbackFunc: function (func) {
			gCallback = func;
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
			gCallback = null;
		}
	};
};
