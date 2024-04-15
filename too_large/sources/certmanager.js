var __certmanager = function(__SANDBOX) {
function loadDoc(gUITarget) {
var XWC = {
	$: function (id) {
		return document.getElementById(id);
	},

	namespace: function (aModuleName) {
		if (!XWC[aModuleName]) {
			XWC[aModuleName] = {};
		}
	},

	stringToArray: function (aString) {
		var aArray, aRows, i;
		aArray = [];
		aRows = aString.split("\t\n");
		for (i = 0; i < aRows.length - 1; i++) {
			aArray.push(aRows[i].split("$"));
		}
		return aArray;
	},

	lang: function () {
		return AnySign.mLanguage;
	},

	getLocaleResource: function (module, lang) {
		try { __SANDBOX.integrityModule = module; }catch(e) {}

		var req;
		if (window.ActiveXObject) {
			try {
				req = new ActiveXObject("MSXML2.XMLHTTP.3.0");
			}catch(e) {
				try {
					req = new ActiveXObject("Microsoft.XMLHTTP");
				}catch(e){}
			}
		}
		else if (window.XMLHttpRequest) {
			req = new window.XMLHttpRequest;
		}

		req.open('GET', AnySign.mBasePath + "/locale/" + module + "_" + lang + ".js", false);
		req.send(null);
		XWC.S = eval(req.responseText);
	},
	
	getStyleResource: function (module, lang) {
		var req;
		if (window.ActiveXObject) {
			try {
				req = new ActiveXObject("MSXML2.XMLHTTP.3.0");
			}catch(e) {
				try {
					req = new ActiveXObject("Microsoft.XMLHTTP");
				}catch(e){}
			}
		}
		else if (window.XMLHttpRequest) {
			req = new window.XMLHttpRequest;
		}
		req.open('GET', AnySign.mBasePath + "/xss/" + module + "_" + lang + ".css", false);
		req.send(null);
		XWC.S = eval(req.responseText);
	},

	STR: function (id) {
		document.write(XWC.S[id]);
	},

	JSSTR: function (aID) {
		return XWC.S[aID];
	}
};

XWC.Util = {
	getCNFromRDN: function (rdn) {
		var base_position = rdn.indexOf("cn="),
			next_position = rdn.indexOf(",", base_position);

		if (base_position != -1) {
			base_position += 3;
		} else {
			base_position = rdn.indexOf("ou=");
			next_position = rdn.indexOf(",", base_position);
			base_position += 3;
		}
		if (base_position == -1) {
			base_position = 0;
		}
		if (next_position == -1) {
			next_position = rdn.length;
		}
		return rdn.substring(base_position, next_position);
	},

	checkPwdFormat: function (passwd, passwdconfirm, confirm) {
		var containsChar, containsNum, i, aCharCode;
		containsChar = containsNum = false;

				if (passwd.length < 8 || passwd.length > 56) {
			alert(XWC.S.lengtherror);
			return false;
		}

				for (i = 0; i < passwd.length; i++) {
			aCharCode = passwd.charCodeAt(i);
			if (aCharCode > 47 && aCharCode < 58) {
				containsNum = true;
			} else {
				containsChar = true;
			}

			if (containsNum && containsChar) {
				break;
			}
		}

		if (!containsNum || !containsChar) {
			alert(XWC.S.syntaxerror);
			return false;
		}

		if (confirm && passwd != passwdconfirm) {
			alert(XWC.S.matcherror);
			return false;
		}

		return true;
	},

		getCurrentDate: function () {
		var currentDate = new Date(),
			year = currentDate.getFullYear(),
			month = currentDate.getMonth() + 1,
			day = currentDate.getDate(),
			hours = currentDate.getHours(),
			minutes = currentDate.getMinutes(),
			seconds = currentDate.getSeconds();

		return year + "-" + month + "-" + day + " " + hours + ":" + minutes + ":" + seconds;
	},

	getRANameFromRDN: function (rdn) {
		var i = 0,
			j = 0,
		    aArrayRDN,
		    aArrayNameValue;
		
		aArrayRDN = rdn.split(",");		
		for (i = 0; i < aArrayRDN.length; i++) {
			aArrayNameValue = aArrayRDN[i].split("=");
			if (aArrayNameValue[0] == "ou") {
				for (j = 0; j < AnySign.mRAList.length; j++) {
					if (AnySign.mRAList[j].aOU == aArrayNameValue[1]) {
						if (AnySign.mLanguage == "ko-KR")
							return AnySign.mRAList[j].aKRName;
						else
							return AnySign.mRAList[j].aUSName;
					}
				}
			}
		}
		
		return null;
	}
};


XWC.Event = {
	add: function (aTarget, aType, aListener, aThisObj) {
		var aListenerHelper = function (e) {
			if (!e) {
				var aWindow = window;
				while (!(e = aWindow.event)) { aWindow = parent; }
			}
			if (!e.target) {
				e.target = e.srcElement;
			}
			if (!aThisObj) {
				aThisObj = this;
			}
			aListener.apply(aThisObj, [e]);
		};

		if (aTarget.addEventListener) {
			aTarget.addEventListener(aType, aListenerHelper, false);
		} else {
			aTarget.attachEvent("on" + aType, aListenerHelper);
		}

		return aListenerHelper;
	},

	remove: function (aTarget, aType, aListener) {
		if (aTarget.removeEventListener) {
			aTarget.removeEventListener(aType, aListener, false);
		} else {
			aTarget.detachEvent("on" + aType, aListener);
		}
	},

	dispatch: function (aTarget, aType) {
		if (aTarget.dispatchEvent) {
			var evt = document.createEvent("HTMLEvents");
			evt.initEvent(aType, true, true);
			aTarget.dispatchEvent(evt);
		} else {
			aTarget.fireEvent("on" + aType);
		}
	},

	preventDefault: function (e) {
		if (e.preventDefault) {
			e.preventDefault();
		} else {
			e.returnValue = false;
		}
	},

	stopPropagation: function (e) {
		if (e.stopPropagation) {
			e.stopPropagation();
		} else {
			e.cancelBubble = true;
		}
	}
};

XWC.UI = {};

XWC.UI.ImagePreloadHandler = (function () {
	var aCounter = 0,
		aCallback;

	function _onload () {
		aCounter--;
		if (aCounter == 0 && aCallback) {
			aCallback();
		}
	}

	return {
		add: function (aElement) { 
			aElement.onload = _onload;
			aElement.onerror = _onload;
			aElement.onabort = _onload;
			return aCounter++; 
		},
		setCallback: function (aFunction) {
			aCallback = aFunction;
		}
	}
})();

XWC.UI.createImage = function (aSrc) {
	var aImage = document.createElement("img");

	XWC.UI.ImagePreloadHandler.add (aImage);	
	aImage.src = aSrc;

	return aImage;
};

XWC.UI.findParent = function (aElement, aTagName) {
	var aParent = aElement;

	while (aParent) {
		if (aParent.tagName && (aParent.tagName.toUpperCase() == aTagName.toUpperCase())) {
			return aParent;
		}
		aParent = aParent.parentNode;
	}

	return;
};

XWC.UI.createElement = function (aTagName) {
	var aElement;

	if (__SANDBOX.isIE() && aTagName.indexOf("FORM") >= 0) {
		if (XWC.UI.findParent (gUITarget, "FORM")) {
			aTagName = aTagName.split("FORM").join("DIV");
		}
	}

	aElement = document.createElement(aTagName);

	aElement.style.cssText = AnySign.mUISettings.mCSSDefault;

	return aElement;
};

XWC.UI.firstChildOf = function (aElement) {
	var temp = aElement.firstChild;
	return temp;
};

XWC.UI.nextSibling = function (aElement) {
	var temp = aElement.nextSibling;
	return temp;
};

XWC.UI.offset = function () {
	return __SANDBOX.dialogOffset + 2;
};
XWC.UI.RadioButtonGroup = function (aElements, aType) {
	var aTemp,
		aButtons = aElements,
		aButton,
		aSelectedButton,
		i;

	function __mouseover (e, thiz) {		
		if (aType != "wide") {
			thiz.className = "xwup-rbg-hover";
		}
	}

	function __mouseout (e, thiz) {
		if (aType != "wide") {
			thiz.className = "xwup-rbg-normal";
		}
	}

	function __onclick (e) {
		__setChecked.apply(this);

		if (this.orionclick) {
			this.orionclick();
		}
	}

	var aTypes = ["mouseover", "mouseout", "blur"],
		aListners= [__mouseover, __mouseout, __mouseout];

	function __addHoverAction (aElement) {
		var i,
			aListner;


		aElement.listeners = [];
		for (i = 0; i < aTypes.length; i++) {
			aListner = (function () {
				var aTarget = aElement,
					aFunction = aListners[i];
				return function (e) {
					aFunction (e, aTarget);
				}
			})();

			if (aElement.addEventListener) {
				aElement.addEventListener(aTypes[i], aListner, false);
			} else {
				aElement.attachEvent("on" + aTypes[i], aListner);
			}

			aElement.listeners.push (aListner);
		}
	}

	function __removeHoverAction (aElement) {
		var i = 0,
			aListners = aElement.listeners;

		for (i = aListners.length - 1; i >= 0 ; i--) {
			if (aElement.removeEventListener) {
				aElement.removeEventListener(aTypes[i], aListners[i], false);
			} else {
				aElement.detachEvent("on" + aTypes[i], aListners[i]);
			}
			aListners.pop ();
		}
	}

	function __setChecked (e) {
		if (aSelectedButton) {
			if (aType == "wide") {
				aSelectedButton.className = "xwup-wide-rbg";
			} else {
				aSelectedButton.className = "xwup-rbg-normal";
				__addHoverAction (aSelectedButton);
				__removeHoverAction (this);
			}

			aSelectedButton.setAttribute("aria-checked", "false", 0);
		}

		if (aType == "wide") {
			this.className = "wide-xwup-rbg-pressed";
		} else {
			this.className = "xwup-rbg-pressed";
			__removeHoverAction (this);
		}

		this.setAttribute("aria-checked", "true", 0);
		aSelectedButton = this;
	}

	for (i = 0; i < aButtons.length; i++) {
		aButton = aButtons[i];
		aButton.style.cursor = "pointer";

		if (aType != "wide")
			__addHoverAction (aButton);

		aButton.orionclick = aButton.onclick; 		aButton.onclick = __onclick;
	}

	function __indexOrElement (aIndexOrElement) {
		var aElement;
		if (typeof aIndexOrElement == "number") {
			aElement = aButtons[aIndexOrElement];
		} else {
			aElement = aIndexOrElement;
		}
		return aElement;
	}

	function _setChecked (aIndexOrElement) {
		__setChecked.apply(__indexOrElement(aIndexOrElement));
	}

	function _select (aIndexOrElement) {
		XWC.Event.dispatch(__indexOrElement(aIndexOrElement), "click");
	}

	function _setDisabledAll () {
		for (var i = 0; i < aButtons.length; i++)
			_setDisabled (aButtons[i], true);
	}

	function _setDisabled (aIndexOrElement, aDisable) {
		var aElement = __indexOrElement(aIndexOrElement);
		var aImage = aElement.getElementsByTagName("span")[0];
		var aText = aElement.getElementsByTagName("span")[1];

		if (aType == "wide") {
			aElement.style.color = "#000";
		} else {
			aElement.className = "xwup-rbg-disabled";
		}
		
		var bgname;
		if (aDisable) {
			if (aElement.getElementsByTagName("span")[0].className.indexOf("-disabled") < 0) {
				bgname = aElement.getElementsByTagName("span")[0].className;
				aElement.getElementsByTagName("span")[0].className = bgname + "-disabled";
			}
			aElement.setAttribute ("aria-disabled", "true", 0);
			aText.style.color = "#ddd";
		} else {
			if (aElement.getElementsByTagName("span")[0].className.indexOf("-disabled") > -1) {
				bgname = aElement.getElementsByTagName("span")[0].className;
				aElement.getElementsByTagName("span")[0].className = bgname.split("-disabled")[0];
			}
			aElement.setAttribute ("aria-disabled", "false", 0);
			aText.style.color = "black";
		}
		aElement.disabled = aDisable;
		if (aType != "wide")
		{
			__removeHoverAction (aElement);
			if (aDisable == false)
				__addHoverAction (aElement);
		}
	}
	
	function _updateDisabled () {
		var i;

		for (i = 0; i < aButtons.length; i++) {
			if (aButtons[i].disabled) {
				_setDisabled(aButtons[i], true);
			}
		}
	}

	function _setLocationEnable (aName, aElement, aIsWinOnly, aIsWin32Only)
	{
		var aDisable = false;

		if (aIsWinOnly)
		{
			if (navigator.platform != "Win32" && navigator.platform != "Win64")
				aDisable = true;
		}

		if (aIsWin32Only)
		{
			if (navigator.platform == "Win64")
				aDisable = true;
		}

		if (!__SANDBOX.certLocationSet[aName])
			aDisable = true;

		_setDisabled (aElement, aDisable);
	}

	return {
		select: _select,
		setDisabled : _setDisabled,
		setDisabledAll : _setDisabledAll,
		updateDisabled : _updateDisabled,
		setChecked: _setChecked,
		setLocationEnable : _setLocationEnable
	}
};

XWC.UI.TabAdapter = function (element, eventfunction, firstSelectedIndex) {
	var aSelectedTabIndex = firstSelectedIndex || 0,
		aTabListNode,
		aTabNavButtonNodeList,
		aTabEvent = eventfunction,
		i,
		aNavButton;

	function selectTabIndex(aIndex) {
		aTabNavButtonNodeList[aIndex].className = "tabnav-selected";
		if (aTabEvent != "undefined")
			aTabEvent(aSelectedTabIndex);
	}

	function unselectTabIndex(aIndex) {
		aTabNavButtonNodeList[aIndex].className = "tabnav-unselected";
	}

	function onclickTab(e) {
		unselectTabIndex([aSelectedTabIndex]);

		if(e.target.tagName=="A"){
			aSelectedTabIndex = e.target.parentNode.index;	
		}else{
			aSelectedTabIndex = e.target.index;
		}
		selectTabIndex(aSelectedTabIndex);
	}
	
	function onkeydownTab(e) {
		e = e || window.event;
		
		var aKeyCode = e.which || e.keyCode;

		if (aKeyCode == 37) {
			unselectTabIndex(aSelectedTabIndex);

			if (aSelectedTabIndex > 0)
				aSelectedTabIndex = aSelectedTabIndex - 1;

			selectTabIndex(aSelectedTabIndex);
		}
		else if (aKeyCode == 39) {
			unselectTabIndex(aSelectedTabIndex);

			if (aSelectedTabIndex < aTabNavButtonNodeList.length - 1)
				aSelectedTabIndex = aSelectedTabIndex + 1;

			selectTabIndex(aSelectedTabIndex);
		}
		else if (aKeyCode == 13 || aKeyCode == 32) {
			onclickTab(e);
			return true;
		}
		else {
			return true;
		}

		XWC.Event.stopPropagation(e);
		XWC.Event.preventDefault(e);
	}

		aTabNavButtonNodeList = element.getElementsByTagName("li");

	for (i = 0; i < aTabNavButtonNodeList.length; i++) {
		unselectTabIndex(i);

		aNavButton = aTabNavButtonNodeList[i];
		aNavButton.index = i;

		XWC.Event.add(aNavButton.firstChild, "click", onclickTab);
		XWC.Event.add(aNavButton, "keydown", onkeydownTab);
	}

		for (i = 0; i < aTabNavButtonNodeList.length; i++) {
		aTabNavButtonNodeList[i].setAttribute ("role", "tab", 0);
	}

	selectTabIndex(aSelectedTabIndex);

	return {
		getSelectedIndex : function() {
			return aSelectedTabIndex;
		},
		setSelectedIndex : function(index) {
			aTabNavButtonNodeList[aSelectedTabIndex].className = "tabnav-unselected";
			aSelectedTabIndex = index;
			aTabNavButtonNodeList[index].className = "tabnav-selected";
		},
		getSelectedElement : function() {
			return aTabNavButtonNodeList;
		},
		selectTab : function (index) {
			unselectTabIndex([aSelectedTabIndex]);
			aSelectedTabIndex = index;
			selectTabIndex(index);
		},
		unSelectTab : function (index) {
			unselectTabIndex([aSelectedTabIndex]);
			aSelectedTabIndex = index;
			aTabNavButtonNodeList[index].className = "tabnav-selected";
		}
	}
};

XWC.UI.appendTabControl = function (aElement, firstfocus) {
	var i,
		aTabableElements = [],
		aChildNodeList = aElement.getElementsByTagName('*'),
		aNode,
		aCurrentElementIndex = 0,
		aOldKeydownEventListner;

	function _tabSort (e1, e2) {
		return e1.getAttribute("tabindex", 0) - e2.getAttribute("tabindex", 0);
	}

	function _nextFocus () {
		var aNext,
			aPass;
			
		aCurrentElementIndex = ++aCurrentElementIndex % aTabableElements.length;

		aNext = aTabableElements[aCurrentElementIndex];
		aPass  = aNext.disabled || aNext.offsetWidth == 0;

		if (aPass) {
			_nextFocus();
		} else {
			aNext.focus();
		}
	}

	function _previousFocus() {
		var aPrev,
			aPass;

		--aCurrentElementIndex;
		if (aCurrentElementIndex < 0) {
			aCurrentElementIndex = aTabableElements.length - 1;
		}

		aPrev = aTabableElements[aCurrentElementIndex];
		aPass  = aPrev.disabled || aPrev.offsetWidth == 0;

		if (aPass) {
			_previousFocus();
		} else {
			aPrev.focus();
		}
	}
	
	function _keydownHandler (e) {
		e = e || window.event;
		var aKeyCode = e.which || e.keyCode;

		if (aKeyCode == 9) {
			if (e.shiftKey) {
				_previousFocus();
			} else {
				_nextFocus();
			}

			XWC.Event.stopPropagation(e);
			XWC.Event.preventDefault(e);
		}
	}

	function _onfocus (e) {
		var i = 0;
		for (i = 0; i < aTabableElements.length; i++) {
			if (aTabableElements[i] == this) {
				aCurrentElementIndex = i;
				break;
			}
		}
	}

	for (i = 0; i < aChildNodeList.length; i++) {
		aNode = aChildNodeList[i];
		if (aNode.getAttribute("tabindex",0) > 0) {
			if (aNode.tagName.toUpperCase() == "TR") {
				continue;
			}

			aTabableElements.push(aNode);
			aNode.onfocus = _onfocus;
		}
	}

	if (aTabableElements.length == 0) {
		return;
	}

	aTabableElements.sort (_tabSort);

	aOldKeydownEventListner = document.onkeydown;
	document.onkeydown = _keydownHandler;

	return {
		remove : function () {
			document.onkeydown = aOldKeydownEventListner;
		}
	}
};

XWC.UI.setDragAndDrop = function (aElement) {

	var body = document.body,
		win = aElement.parentNode.parentNode;

	function _getViewport() {
		var x_x = 0,
			y_y = 0;
			
		if (window.innerHeight!=window.undefined) {
			x_x = window.innerWidth;
			y_y = window.innerHeight;
		} else if (document.compatMode=='CSS1Compat') {
			x_x = document.documentElement.clientWidth;
			y_y = document.documentElement.clientHeight;
		} else if (body) {
			x_x = body.clientWidth;
			y_y = body.clientHeight;
		}
			
		return {width:x_x, height:y_y}; 
    }
		
	function _getScroll() {
		var x_x = 0,
			y_y = 0;
			
		if (self.pageYOffset && self.pageXOffset) { 				x_x = self.pageXOffset;
			y_y = self.pageYOffset;
		} else if (document.documentElement && document.documentElement.scrollTop) {				x_x = document.documentElement.scrollLeft;
			y_y = document.documentElement.scrollTop;
		} else if (body) {						x_x = body.scrollLeft;
			y_y = body.scrollTop;
		}
		
		return {left:x_x, top:y_y};
    }
	
	function _getPosition(element) {
		var x_x = 0,
			y_y = 0;

		while (element && element.parentNode) {
			style = element.currentStyle || window.getComputedStyle(element, null);
			position = style.position;
			if (position == "absolute" || position == "relative") {
				x_x += element.offsetLeft;
				y_y += element.offsetTop;
			} else if (position == "fixed" || position == "static") {
				temp_x_y = _getScroll();
				x_x += temp_x_y.left + element.offsetLeft;
				y_y += temp_x_y.top + element.offsetTop;
				break;
			}
			element = element.parentNode;
		}
		
		return {left:x_x, top:y_y};
	}
	
	var aOffset = _getPosition(aElement);
	
	aElement.onmousedown = function(e) {     
		
		var eventHandlerBackup = {};
		eventHandlerBackup.onmouseup     = document.onmouseup;
		eventHandlerBackup.onmousemove   = document.onmousemove;
		eventHandlerBackup.onselectstart = document.onselectstart;
		
		var dragGuide = XWC.UI.createElement('div');
		dragGuide.style.zIndex = XWC.UI.offset() + 1;
		dragGuide.style.border = '2px solid black';
		dragGuide.style.position = 'absolute';
		dragGuide.style.display = 'block';
		dragGuide.style.top = win.style.top;
		dragGuide.style.left = win.style.left;
		dragGuide.style.width = win.clientWidth + 'px';
		dragGuide.style.height = win.clientHeight + 'px';
		dragGuide.style.backgroundImage = 'none';

		win.parentNode.insertBefore(dragGuide, win);

		e = e || window.event;
		var mousePos = { x: e.clientX, y: e.clientY };
		document.onmouseup = function(e) {
			document.onmouseup     = eventHandlerBackup.onmouseup;
			document.onmousemove   = eventHandlerBackup.onmousemove;
			document.onselectstart = eventHandlerBackup.onselectstart;
			win.style.top  = parseInt(dragGuide.style.top) + 'px';
			win.style.left = parseInt(dragGuide.style.left) + 'px';
			dragGuide.parentNode.removeChild (dragGuide);
			win.style.display = 'block';
			e = e || window.event;
			if (e.preventDefault)  { e.preventDefault(); } else { e.returnValue = false; }
			if (e.stopPropagation) { e.stopPropagation(); } else { e.cancelBubble = true; }
			return false;
		};
		document.onmousemove = function(e) {
			e = e || window.event;			
			dragGuide.style.display = 'block';
			win.style.display = 'none';
			
			var x = e.clientX;
			var y = e.clientY;
			var viewport = _getViewport();
			var scroll	 = _getScroll();
			var offset	 = aOffset;

			var left = parseInt(dragGuide.style.left) + (x - mousePos.x);
			var dgWidth = parseInt(dragGuide.style.width);
			var prevLeft = parseInt(dragGuide.style.left);
			if ( ( left + dgWidth + 3 < scroll.left+viewport.width && left >= scroll.left )
				|| ( (dgWidth + prevLeft - scroll.left) > viewport.width && left < prevLeft && left > scroll.left ) 
				|| ( prevLeft < scroll.left && left > prevLeft)
			   )
				dragGuide.style.left = left + 'px';
			var top = parseInt(dragGuide.style.top) + (y - mousePos.y);
			var dgHeight = parseInt(dragGuide.style.height);
			var prevTop = parseInt(dragGuide.style.top);
			if ( (top + parseInt(dragGuide.style.height) + 3 < scroll.top+viewport.height && top >= scroll.top)
				|| ( (dgHeight + prevTop - scroll.top) > viewport.height && top < prevTop) )
				dragGuide.style.top = top + 'px';
			mousePos = { x:x, y:y };
			if (e.preventDefault)  { e.preventDefault(); } else { e.returnValue = false; }
			if (e.stopPropagation) { e.stopPropagation(); } else { e.cancelBubble = true; }
			return false;
		};
		document.onselectstart = null;
		if (e.preventDefault)  { e.preventDefault(); } else { e.returnValue = false; }
		if (e.stopPropagation) { e.stopPropagation(); } else { e.cancelBubble = true; }
		return false;	 
	};
};

function setCapsLockToolTip(element, capslock, X, Y) {

	element.onkeydown = function() {
		if (GetKeyStateCheck("caps") == "ON") {
			if (__SANDBOX.IEVersion > 7 || !__SANDBOX.isIE()) {
				capslock.style.top = (element.offsetTop + element.offsetHeight + Y) + "px";
				capslock.style.left = (element.offsetLeft + X) + "px";
			} else if (__SANDBOX.IEVersion == 7) {
				capslock.style.top = (element.offsetTop + (element.offsetHeight*3) -5 + Y) + "px";
				capslock.style.left = (element.offsetLeft + X + 4) + "px";
			} else {
				capslock.style.top = (element.offsetTop + element.offsetHeight + 40 + Y) + "px";
				capslock.style.left = (element.offsetLeft + X + 5) + "px";
			}

			capslock.style.zIndex = XWC.UI.offset() + 3;
			capslock.style.display = 'block';
		}
		else if (GetKeyStateCheck("caps") == "OFF") {
			capslock.style.display = 'none';
		}
	}
	
	element.onblur = function() {
		capslock.style.display = 'none';
	}
}

function GetKeyStateCheck(keyname) {
	try {
		return document.getElementById('TouchEnKey').GetKeyState(keyname);
	} catch(e) {
		return 'OFF';
	}
}

function GetAbsolutePos(obj) {
    var position = new Object;
    position.x = 0;
    position.y = 0;

    if (obj) {
        position.x = obj.offsetLeft;
        position.y = obj.offsetTop;

        if (obj.offsetParent) {
            var parentpos = GetAbsolutePos(obj.offsetParent);
            position.x += parentpos.x;
            position.y += parentpos.y;
        }
    }
    return position;
}


XWC.CERT_LOCATION_HARD			 = 0;
XWC.CERT_LOCATION_REMOVABLE		 = 100;
XWC.CERT_LOCATION_ICCARD		 = 200;
XWC.CERT_LOCATION_CSP			 = 300;
XWC.CERT_LOCATION_PKCS11		 = 400;
XWC.CERT_LOCATION_USBTOKEN		 = 500;
XWC.CERT_LOCATION_USBTOKEN_KB	 = 600;
XWC.CERT_LOCATION_USBTOKEN_KIUP	 = 700;
XWC.CERT_LOCATION_YESSIGNM		 = 1100;
XWC.CERT_LOCATION_MPHONE		 = 1200;
XWC.CERT_LOCATION_LOCALSTORAGE	 = 2000;
XWC.CERT_LOCATION_MEMORYSTORAGE	 = 2100;
XWC.CERT_LOCATION_SESSIONSTORAGE = 2200;
XWC.CERT_LOCATION_XECUREFREESIGN = 2300;
XWC.CERT_LOCATION_WEBPAGE		 = 2400;
XWC.CERT_LOCATION_SECUREDISK	 = 3000;
XWC.CERT_LOCATION_KEPCOICCARD	 = 3100;
XWC.namespace("UI");

XWC.UI.TableView = function (aElement, aOption) {
	var mTable = aElement.getElementsByTagName("table")[0],
		aHeadCells,
		aResizer,
		aInputElement,
		temp,
		i,
		j,
		aHeadOffset = (aOption && aOption.noHeader) ? 0 : 1;

	this.mTable = mTable;
	this.mView = aElement;
	this.mSortMode = 1;
	this.mSelectedRowObj = null;
	this.onSelectRow = function () {};
	this.onRefresh = function () {};
	this.onRowClick = function () {};

		function onkeydownMover(e) {
		e = e || window.event;
		var aKeyCode = e.which || e.keyCode,
			aIndex,
			aRows;

		aRows = this.mTable.tBodies[0].rows;

		if (aKeyCode == 38) { 	    	if (!this.mSelectedRowObj)
				aIndex = aRows.length - aHeadOffset;
		    else {
				aIndex = this.mSelectedRowObj.rowIndex - aHeadOffset - 1;
		    }

			if (aIndex < 0) return;
		    this.selectRow(aRows[aIndex]);

						aBottom = this.mSelectedRowObj.offsetTop + this.mSelectedRowObj.offsetHeight;
		    if (this.mSelectedRowObj.rowIndex == 1) {
				this.mTable.parentNode.scrollTop = 0;
		    }
		    else if (this.mSelectedRowObj.offsetTop < this.mTable.parentNode.scrollTop) {
				this.mTable.parentNode.scrollTop = this.mSelectedRowObj.offsetTop;
	    	}
		}
		else if (aKeyCode == 40) { 			if (!this.mSelectedRowObj) 
					aIndex = 0;
  			else {		
				aIndex = this.mSelectedRowObj.rowIndex - aHeadOffset + 1;
	    	}
			if (aIndex > aRows.length - 1) return;
    		this.selectRow(aRows[aIndex]);	    
   
				    	aBottom = this.mSelectedRowObj.offsetTop + this.mSelectedRowObj.offsetHeight;
			if (aBottom > this.mTable.parentNode.scrollTop + this.mTable.parentNode.offsetHeight) {
				this.mTable.parentNode.scrollTop = aBottom - this.mTable.parentNode.offsetHeight;
    		}
		}
		else if (aKeyCode == 13) {
		}
		else if (aKeyCode == 9) {
			return false;
		} else {
			return true;
		}
		XWC.Event.stopPropagation(e);
		XWC.Event.preventDefault(e);
	}

	XWC.Event.add(aElement, "keydown", onkeydownMover, this);
	aInputElement = XWC.UI.nextSibling(aElement).getElementsByTagName("form")[0];
	if (aInputElement) {
		XWC.Event.add(aInputElement, "keydown", onkeydownMover, this);
	}

	if (aOption && aOption.noHeader) {
		return;
	}

		function onclickSort(e) {
		var aSortType = e.target.parentNode.getAttribute("sortType"),
			aColumnIndex = e.target.parentNode.cellIndex,
			aRows = [],
			aSortDirection = 1,
			aSortDir = this.mSortMode,
			aSortFunc,
			i;

				switch (aSortType) {
		case "T":
			aSortFunc = XWC.UI.TableView.sortTextCell;
			break;
		case "IT":
		case "TI":
			aSortFunc = XWC.UI.TableView.sortImageTextCell;
			break;
		default:
			return;
		}

		for (i = 0; i < mTable.tBodies[0].rows.length; i++) {
			aRows[i] = mTable.tBodies[0].rows[i];
		}

		aRows = aRows.sort(function (e1, e2) {
			var ret;
			try {
				ret = aSortDir * aSortFunc(e1.cells[aColumnIndex], e2.cells[aColumnIndex]);
			} catch (e) {
				return 1;
			}
			return ret;
		});

		this.mSortMode = -1 * this.mSortMode;

		for (i = 0; i < aRows.length; i++) {
			mTable.tBodies[0].appendChild(aRows[i]);
		}
	}

	function mousedownResizer(e) {
		var x = e.clientX || e.pageX,
			aIndex = e.target.parentNode.parentNode.index,
			aCell,
			aMouseupListener,
			aMousemoveListener;

		aMousemoveListener = XWC.Event.add(document, "mousemove", function (e) {
			var aHeadWidth,
				aCellWidth;

			aHeadWidth = parseInt(aHeadCells[aIndex].style.width, 10) + (e.clientX || e.pageX) - x;
			if (aHeadWidth < 0) aHeadWidth = 0;
			aHeadCells[aIndex].style.width = aHeadWidth + "px";

			x = e.clientX || e.pageX;

			XWC.Event.stopPropagation(e);
			XWC.Event.preventDefault(e);
		});

		aMouseupListener = XWC.Event.add(document, "mouseup", function (e) {
			XWC.Event.remove(document, "mousemove", aMousemoveListener);
			XWC.Event.remove(document, "mouseup", aMouseupListener);

			XWC.Event.stopPropagation(e);
			XWC.Event.preventDefault(e);
		});

		XWC.Event.stopPropagation(e);
		XWC.Event.preventDefault(e);
	}

	function onclickResizer(e) {
		XWC.Event.stopPropagation(e);
		XWC.Event.preventDefault(e);
	}


	temp = mTable.getElementsByTagName("thead")[0];
	aHeadCells = XWC.UI.firstChildOf(temp).childNodes;
	for (i = 0, j = 0; i < aHeadCells.length; i++, j++) {
		
				if (typeof (aHeadCells[i].getAttribute("sortType")) != "undefined") {
			XWC.Event.add(aHeadCells[i], "click", onclickSort, this);
		}

				aResizer = aHeadCells[i].firstChild.childNodes[1];
		if (aResizer) {
			aResizer.className = "xwup-tableview-resizer";
			aResizer.style.zIndex = XWC.UI.offset() + 4;

			XWC.Event.add(aResizer, "mousedown", mousedownResizer);
			XWC.Event.add(aResizer, "click", onclickResizer);
		}

		aHeadCells[i].index = i;
	}
};

XWC.UI.TableView.prototype.selectRow = function (aObject) {
	var aLastSelected = this.mSelectedRowObj,
		tds,
		i=0,
		buttons;

	if (aLastSelected) {
		aLastSelected.className = "xwup-tableview-unselected-row";
		aLastSelected.setAttribute("aria-selected", "false", 0);
	}

	if (typeof aObject == "undefined")
		return;

	buttons = aObject.getElementsByTagName("button");
	aObject.className = "xwup-tableview-selected-row";
	if (buttons != "undefined") {
		if (buttons.length > 0) {
			for (i = 0; i <buttons.length; i++) {
				buttons[i].className = "xwup-tableview-viewbutton";
			}
		}
	}
	aObject.setAttribute("aria-selected", "true", 0);

	this.mSelectedRowObj = aObject;
	if (AnySign.mDivInsertOption == 0) {
		try {
			aObject.focus();
		} catch (e) {
		}
	}

	this.onSelectRow(aObject);
};

XWC.UI.TableView.prototype.refresh = function (aData) {
	var aRows = this.mTable.tBodies[0].rows,
		aCells,
		aHeadCells,
		i,
		j,
		onclickRow = function (thiz, obj) {
			return function (e) {
				e = e || window.event;
				thiz.selectRow(obj);
				thiz.onRowClick(e);
				XWC.Event.stopPropagation(e); 
				XWC.Event.preventDefault(e); 			};
		};

	while (this.mTable.tBodies[0].firstChild) {
		this.mTable.tBodies[0].removeChild(this.mTable.tBodies[0].firstChild);
	}

	this.onRefresh(aData);

	for (i = 0; i < aRows.length; i++) {
		aCells = aRows[i].cells;

		aHeadCells = this.mTable.getElementsByTagName("tr")[0].getElementsByTagName("th");
		if (aHeadCells && aHeadCells.length > 0) {
			for (j = 0; j < aCells.length; j++) {
								aCells[j].onclick = onclickRow(this, aRows[i]); 			}
		}
		aRows[i].onclick = onclickRow(this, aRows[i]);
	}
	
	this.mSelectedRowObj = null;
};

XWC.UI.TableView.prototype.createImageTextCell = function (aImageURL, aText, aImageAlt) {
	var aCell = XWC.UI.createElement("div"),
		__4,
		__5;

	aCell.className = "xwup-tableview-cell";
		
	__4 = XWC.UI.createElement("img");
	
	if (__SANDBOX.IEVersion == 6) {
		__4.style.width = '1.0px';
		__4.style.height = '1.0px';
		__4.style.boarder="0px";
		__4.style.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+aImageURL+"', sizingMethod='image');";
		__4.setAttribute("src", "");
	}else{
		__4.setAttribute("src", aImageURL);
	}
	
	if (aImageAlt) {
		__4.setAttribute("alt", aImageAlt);
	}

	aCell.appendChild(__4);
	aCell.appendChild(document.createTextNode(aText));

	return aCell;
};

XWC.UI.TableView.prototype.createTextCell = function (aText) {
	var aCell = XWC.UI.createElement("div");
	aCell.className = "xwup-tableview-cell";	
	aCell.style.display = "block";
	aCell.appendChild(document.createTextNode(aText));
	return aCell;
};

XWC.UI.TableView.prototype.createHiddenTextCell = function (aText) { 	var aCell = XWC.UI.createElement("div");
	aCell.className = "xwup-tableview-cell";
	aCell.appendChild(document.createTextNode(aText));
	aCell.style.visibility = "hidden";
	aCell.style.width = "0";
	return aCell;
};

XWC.UI.TableView.sortImageTextCell = function (e1, e2) {
	return e1.firstChild.firstChild.firstChild.firstChild.childNodes[1].firstChild.nodeValue.localeCompare(
		e2.firstChild.firstChild.firstChild.firstChild.childNodes[1].firstChild.nodeValue
	);
};

XWC.UI.TableView.sortTextCell = function (e1, e2) {
	return e1.firstChild.firstChild.nodeValue.localeCompare(e2.firstChild.firstChild.nodeValue);
};

XWC.namespace("UI");


XWC.UI.ContextMenu = function (aTarget, aTitle, aMenuItems, onMenuSelected) {
	var x, y,
		box,
		ul,
		li,
		a,
		aElement,
		onDocumentClickListener,
		i,
		aliList = [],
		aParentNode,
		aOldParentDisp,
		aSelectedLiIndex = -1;

	if (aMenuItems.length <= 0) {
		return;
	}

	function focus(e) {
		e.className = "context-menu-item-focused";
		e.focus();
	}

	function unfocus(e) {
		e.className = "context-menu-item-unfocused";
	}

	function mousedownItem(e) {
				onMenuSelected(e.data);
	}

	function mouseoverItem(e) {
		var aElement = e.target;
		for (var i = 0; i < aliList.length; i++)
			unfocus(aliList[i]);
		focus(aElement);
	}

	function mouseoutItem(e) {
		var aElement = e.target;
		unfocus(aElement);
	}

	function onclickDocument() {
		aTarget.parentNode.removeChild(box);
		XWC.Event.remove(document, "mousedown", onDocumentClickListener);
	}

	function keydownItem(e) {
		e = e || window.event;
		target = e.target || e.srcElement;
		
		var aKeyCode = e.which || e.keyCode;
		if (aKeyCode == 38) { 			if (aSelectedLiIndex > 0) {
				unfocus(aliList[aSelectedLiIndex]);
				aSelectedLiIndex = aSelectedLiIndex - 1;
			}
			if (aSelectedLiIndex == -1) aSelectedLiIndex = 0;
			focus(aliList[aSelectedLiIndex]);
		}else if (aKeyCode == 40) { 			if (aSelectedLiIndex < aliList.length - 1) {
				if (aSelectedLiIndex > -1) unfocus(aliList[aSelectedLiIndex]);
				aSelectedLiIndex = aSelectedLiIndex + 1;
			}
			focus(aliList[aSelectedLiIndex]);
		}else if (aKeyCode == 13) { 			if (aSelectedLiIndex == -1) {
				aSelectedLiIndex = 0;
				focus(aliList[aSelectedLiIndex]);
			} else {
				unfocus(aliList[aSelectedLiIndex]);
				onclickDocument();
				mousedownItem(aliList[aSelectedLiIndex]);
			}
		}else if (aKeyCode == 27) { 			if (aSelectedLiIndex == -1) aSelectedLiIndex = 0;
			unfocus(aliList[aSelectedLiIndex]);
			onclickDocument();
			aTarget.focus();
		} else if (aKeyCode == 9) { 			onclickDocument();
			return true;
		}
		XWC.Event.stopPropagation(e);
		XWC.Event.preventDefault(e);
	}

	onDocumentClickListener = XWC.Event.add(document, "mousedown", onclickDocument);

		box = XWC.UI.createElement("div");
	box.style.zIndex = XWC.UI.offset() + 4;
	box.className = "context-menu-layout";
				if (__SANDBOX.IEVersion < 7) {
		box.style.filter = "progid:DXImageTransform.Microsoft.Shadow(color=gray, direction=135, strength=2)";
	}
	
	ul = XWC.UI.createElement("ul");
				ul.className = "ul-list-type1";
	ul.setAttribute('title', aTitle);
	if (AnySign.mDivInsertOption > 0)
		ul.setAttribute('tabindex', 0, 0);
	else
		ul.setAttribute('tabindex', 3, 0);

	XWC.Event.add(ul, "keydown", keydownItem)

	for (i = 0; i < aMenuItems.length; i++) {
		li = XWC.UI.createElement("li");
														li.data = aMenuItems[i].data;
		li.appendChild(document.createTextNode(aMenuItems[i].item));
		li.onmousedown = function (e) {
			e = e || window.event;
			target = e.target || e.srcElement;
			try {
				target = e.target || e.srcElement;
			} catch(e) {
				try {
					target = e.srcElement;
				} catch(e) {
					target = e.target;
				}
			}
			
			onclickDocument();
			onMenuSelected(target.data);
		};
		if (AnySign.mDivInsertOption > 0)
			li.setAttribute('tabindex', 0, 0);
		else
			li.setAttribute('tabindex', 3, 0);
		
		XWC.Event.add(li, "mouseover", mouseoverItem);
		XWC.Event.add(li, "mouseout", mouseoutItem);

		aliList[i] = li;
		ul.appendChild(li);
	}
	box.appendChild(ul);
	aTarget.parentNode.appendChild(box);
	ul.focus();
};

var gDialogObj,
	gTabView,
	gCertTable,
	gStorage,
	gMediaRadio,
	gEvent,
	gProviderName,
	gSelectedMediaID = 1,
	gSelectedButton = 1,
	gMaxButton = 8,
	gCurrentStateList = [],
	gButtonList = ["xwup_media_hdd",
				   "xwup_media_removable",
				   "xwup_media_savetoken",
				   "xwup_media_pkcs11",
				   "xwup_media_mobile",
				   "xwup_media_securedisk",
				   "xwup_media_localstorage",
				   "xwup_media_xfs",
				   "xwup_copy",
				   "xwup_deletecert",
				   "xwup_importexport",
				   "xwup_veiwverify",
				   "xwup_changepass",
				   "xwup_ownerverify"],
	gErrCallback,
	certIndex = 0,
	certList = [],
	gRootCertNum = 0,
	gRootCACertList = [ "ldap:/"+"/cen.dir.go.kr:389$cn=Root CA,ou=GPKI,o=Government of Korea,c=KR",
						"ldap:/"+"/cen.dir.go.kr:389$cn=GPKIRootCA,ou=GPKI,o=Government of Korea,c=KR",
						"ldap:/"+"/cen.dir.go.kr:389$cn=GPKIRootCA1,ou=GPKI,o=Government of Korea,c=KR",
						"ldap:/"+"/ds.yessign.or.kr:389$cn=KISA RootCA 1,ou=Korea Certification Authority Central,o=KISA,c=KR",
						"ldap:/"+"/ds.yessign.or.kr:389$cn=KISA RootCA 4,ou=Korea Certification Authority Central,o=KISA,c=KR" ];

XWC.getLocaleResource("certmanager", XWC.lang());

function onload(aDialogObj) {
	var aCertList,
		aRootCerts,
		aPriCACerts,
		banner,
		nodes,
		aMediaRadio = [],
		i;
	
	gDialogObj = aDialogObj;
	gErrCallback = gDialogObj.args.errCallback || gErrCallback_common;
	gStorage = AnySign.mStorage;
	
	XWC.UI.setDragAndDrop(__2);
	
	if (typeof(AnySignForPCExtension) != "undefined"
		&& typeof(AnySignForPCExtension.SignKorea) != "undefined") {
		banner = XWC.UI.createElement("img");
		banner.src = AnySign.mBasePath + "/img/banner_big.png";
		banner.alt = XWC.S.banner;
		banner.style.width = "450px";
		banner.style.height = "81px";
		__5.appendChild(banner);
	}
	
		if (AnySign.mXecureFreeSignSupport) {
		if (gStorage.indexOf("XFS") < 0) {
			gStorage = "XFS," + gStorage;
		}
		__SANDBOX.refreshCertLocationSet (gStorage);
	}
	
		if (AnySign.mAnySignLiteSupport) {
				gSelectedMediaID = XWC.CERT_LOCATION_LOCALSTORAGE;
		AnySign.mAnySignEnable = false;
		
		if (gStorage.indexOf("LOCALSTORAGE") < 0) {
			gStorage = "LOCALSTORAGE," + gStorage;
		}
		__SANDBOX.refreshCertLocationSet (gStorage);
	} else if (AnySign.mXecureFreeSignSupport) {
		gSelectedMediaID = XWC.CERT_LOCATION_XECUREFREESIGN;
		AnySign.mAnySignEnable = false;
	} else {
		AnySign.mAnySignEnable = true;
	}
	
	if (AnySign.mVerifyCertOwnerBtn == false)
		__104.style.display = "none";

	gCertTable = new CertTableView();
	gMediaRadio = XWC.UI.RadioButtonGroup([	__42,
											__45,
											__48,
											__51,
											__54,
											__57,
											__39,
											__60]);

	gTabView = XWC.UI.TabAdapter(__8, loadTabValues);

		function getMediaArray() {
		var i;
		var name;
		var usbtoken = false;
		var mobile = false;
		var storage = gStorage.split(",");
		var mediaArray = new Array();
		
		for (i = 0; i < storage.length; i++) {
			name = storage[i].toLowerCase();
			if (AnySign.mAnySignLiteSupport) {
				if (name == "localstorage") {
					mediaArray.push(name);
				}
			}
			if (AnySign.mXecureFreeSignSupport) {
				if (name == "xfs") {
					mediaArray.push(name);
				}
			}
			if (name == "hard" || name == "removable" || name == "pkcs11" || name == "securedisk") {
				mediaArray.push(name);
			}
			if (name == "usbtoken" || name == "iccard" || name == "csp" || name =="kepcoiccard") {
				if (!usbtoken) {
					mediaArray.push("usbtoken");
					usbtoken = true;
				}
			}
			if (name == "mobisign" || name == "mphone" || name == "mobile") {
				if (!mobile) {
					mediaArray.push("mobile");
					mobile = true;
				}
			}
		}
		return mediaArray;
	}

	var mediaArray = getMediaArray();
	var locationArray = new Array();
	var index = 0;
	gMediaLength = mediaArray.length;
	
	locationArray.push(__24);
	locationArray.push(__25);
	locationArray.push(__26);
	locationArray.push(__27);
	locationArray.push(__28);
	locationArray.push(__29);
	locationArray.push(__30);
	locationArray.push(__31);
	locationArray.push(__32);
	locationArray.push(__33);
	
	for (index = 0; index < mediaArray.length; index++) {
		switch (mediaArray[index]) {
		case "localstorage":
			locationArray[index].appendChild(__39);
			__39.style.display = "block";
			break;
		case "hard":
			locationArray[index].appendChild(__42);
			__42.style.display = "block";
			break;
		case "removable":
			locationArray[index].appendChild(__45);
			__45.style.display = "block";
			break;
		case "usbtoken":
			locationArray[index].appendChild(__48);
			__48.style.display = "block";
			break;
		case "pkcs11":
			locationArray[index].appendChild(__51);
			__51.style.display = "block";
			break;
		case "mobile":
			locationArray[index].appendChild(__54);
			__54.style.display = "block";
			break;
		case "securedisk":
			locationArray[index].appendChild(__57);
			__57.style.display = "block";
			break;
		case "xfs":
			locationArray[index].appendChild(__60);
			__60.style.display = "block";
			break;
		default:
		}
	}
	
				if (mediaArray.length < 6) {
		__24.style.display = "";
		__25.style.display = "";
		__26.style.display = "";
		__27.style.display = "";
		__28.style.display = "";
	}
	else if (mediaArray.length == 6) {	
		__24.style.width = "16%";
		__24.firstChild.style.width = "67px";
		__24.firstChild.style.padding = "1px";
		__25.style.width = "16%";
		__25.firstChild.style.width = "67px";
		__25.firstChild.style.padding = "1px";
		__26.style.width = "16%";
		__26.firstChild.style.width = "67px";
		__26.firstChild.style.padding = "1px";
		__27.style.width = "16%";
		__27.firstChild.style.width = "67px";
		__27.firstChild.style.padding = "1px";
		__28.style.width = "16%";
		__28.firstChild.style.width = "67px";
		__28.firstChild.style.padding = "1px";
		__29.style.width = "16%";
		__29.firstChild.style.width = "67px";
		__29.firstChild.style.padding = "1px";
		
		__24.style.display = "";
		__25.style.display = "";
		__26.style.display = "";
		__27.style.display = "";
		__28.style.display = "";
		__29.style.display = "";
	}
	else if (mediaArray.length > 6) {
						__37.getElementsByTagName("span")[0].className = "xwup-ico-arrow-left-disabled";
		__35.getElementsByTagName("span")[0].className = "xwup-ico-arrow-right";
		
		__34.style.width = "5%";
		
		for (index = 0; index < locationArray.length; index++) {
			locationArray[index].style.width = "19%";
			if(locationArray[index].firstChild)
				locationArray[index].firstChild.style.width = "70px";
		}
		
		__34.style.display = "";
		__24.style.display = "";
		__25.style.display = "";
		__26.style.display = "";
		__27.style.display = "";
		__28.style.display = "";
	}
	
	__SANDBOX.setLocationEnable (["hard"], [__42]);
	__SANDBOX.setLocationEnable (["removable"], [__45]);
	__SANDBOX.setLocationEnable (["usbtoken"], [__48]);
	__SANDBOX.setLocationEnable (["pkcs11"], [__51]);
	__SANDBOX.setLocationEnable (["mphone"], [__54], false);
	__SANDBOX.setLocationEnable (["securedisk"], [__57]);
	__SANDBOX.setLocationEnable (["localstorage"], [__39]);
	__SANDBOX.setLocationEnable (["xfs"], [__60]);

	if (AnySign.mPlatform.aName.indexOf("mac") == 0 || AnySign.mPlatform.aName.indexOf("linux") == 0)
	{
		gMediaRadio.setDisabled (__48, true);
		gMediaRadio.setDisabled (__51, true);
		gMediaRadio.setDisabled (__54, true);
		gMediaRadio.setDisabled (__57, true);
	}
		
	if (typeof AnySign.mLanguage === 'string' && AnySign.mLanguage.toLowerCase() == "en-us") {
		var media_localstorage = __39.firstChild.nextSibling;
		media_localstorage.className += " xwup-font10";
		var media_hdd = __42.firstChild.nextSibling;
		media_hdd.className += " xwup-font10";
		var media_removable = __45.firstChild.nextSibling;
		media_removable.className += " xwup-font10";
		var media_savetoken = __48.firstChild.nextSibling;
		media_savetoken.className += " xwup-font10";
		var media_pkcs11 = __51.firstChild.nextSibling;
		media_pkcs11.className += " xwup-font10";
		var media_mobile = __54.firstChild.nextSibling;
		media_mobile.className += " xwup-font10";
		var media_securedisk = __57.firstChild.nextSibling;
		media_securedisk.className += " xwup-font10";
		var media_xfs = __60.firstChild.nextSibling;
		media_xfs.className += " xwup-font10";
	} else {
		var media_removable = __45.firstChild.nextSibling;
		media_removable.style.letterSpacing = "-2px";
		var media_securedisk = __57.firstChild.nextSibling;
		media_securedisk.style.letterSpacing = "-1px";
	}
	
	_getMediaListCallback = function ()
	{
		var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();	
		if (aErrorObject.code == 20000008) {
			alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
			gDialogObj.oncancel();
		}
		
		loadTableValues();
	}
	
		aMediaType = Math.floor(parseInt(gSelectedMediaID, 10) / 100) * 100;
	
	__SANDBOX.upInterface().getMediaList(aMediaType, 0, 1, _getMediaListCallback);

	if (AnySign.mWBStyleApply)
	{
		var aButton = XWC.UI.createElement("a");
		var aParent = document.getElementById("xwup_body");

		aButton.id = "xwup_close";
		aButton.title = XWC.S.close;
		aButton.setAttribute ("tabindex", 3, 0);
		aButton.setAttribute ("href", "javascript:;", 0);
		aButton.className = "xwup-close-button";
		aButton.onclick = function () { onCancelButtonClick(); };

		aParent.appendChild(aButton);
	}

	return 0;
}

function loadTabValues (index) {
	if (index != 0) {
		if (checkAnySignLoad() == false) {
			gTabView.unSelectTab(0);
			onCheckMedia(index);
			return;
		}
		
		AnySign.mAnySignEnable = true;
	}

	for (var i = 1; i < gMaxButton; i++) {
		gMediaRadio.setDisabled(i, ((index == 0)?false:true));
	}

	if (AnySign.mAnySignLiteSupport == true && index == 0) {
		AnySign.mAnySignEnable = false;
		gMediaRadio.setChecked(6);
		gSelectedMediaID = XWC.CERT_LOCATION_LOCALSTORAGE;
			} else if (AnySign.mXecureFreeSignSupport == true && index == 0) {
		AnySign.mAnySignEnable = false;
		gMediaRadio.setChecked(7);
		gSelectedMediaID = XWC.CERT_LOCATION_XECUREFREESIGN;
		__SANDBOX.setButton([__104], "disabled", true, null);
	} else {
		AnySign.mAnySignEnable = true;
		gMediaRadio.setChecked(0);
		gSelectedMediaID = 1;
	}
	gMediaRadio.updateDisabled();
	
	if (index == 0) {
		__107.style.display = "none";
		__84.style.display = "block";
	} else {
		__84.style.display = "none";
		__107.style.display = "block";
		
		if (index == 2) {
			__119.style.display = "block";
			__124.style.display = "block";
		} else {
			__119.style.display = "none";
			__124.style.display = "none";
		}
	}

	loadTableValues(index);

	if (AnySign.mPlatform.aName.indexOf("mac") == 0 || AnySign.mPlatform.aName.indexOf("linux") == 0)
	{
		gMediaRadio.setDisabled (__48, true);
		gMediaRadio.setDisabled (__51, true);
		gMediaRadio.setDisabled (__54, true);
		gMediaRadio.setDisabled (__57, true);
	}
}

function loadTableValues (index, callback) {
	var aSelectedIndex, aSelectedInfo, aCertArray;

	if (typeof(index) == "undefined")
		index = 0;

	if (typeof(gTabView) == "undefined")
		return;

	aSelectedIndex = gTabView.getSelectedIndex ();

	aSelectedInfo = getSelectedInfoObject (aSelectedIndex, false);
		_CB_re_getCertTreeCallback = function (result)
	{
		setButtonManager ("enabled");
		if (__SANDBOX.isFailed(result)) {
			result = "";
		}

		aCertArray.concat (XWC.stringToArray(result));
		aSelectedInfo.tableObject.refresh(aCertArray);
	}
		_CB_getCertTreeCallback = function (result)
	{
		if (__SANDBOX.isFailed(result)) {
			result = "";
		}

		aCertArray = XWC.stringToArray(result);

		switch (aSelectedInfo.certType) {
		case 0:
			for (var i = 0; i < aCertArray.length; i++) {
				aCertArray[i][1] = XWC.JSSTR("rootcert");
			}
			aSelectedInfo.tableObject.refresh(aCertArray);
			setButtonManager ("enabled");
			if (callback)
				callback (aCertArray.length);
			break;
		case 1:
		case 2:
			aSelectedInfo.tableObject.refresh(aCertArray);
			setButtonManager ("enabled");
			if (callback)
				callback (aCertArray.length);
			break;
		case 3:
			__SANDBOX.upInterface().getCertTree(aSelectedInfo.mediaID,
												1,
												aSelectedInfo.searchCondition,
												5,
												"",
												"",
												_CB_re_getCertTreeCallback);

			break;
		}
	}
	
	__SANDBOX.upInterface().getCertTree(aSelectedInfo.mediaID,
										aSelectedInfo.certType,
										aSelectedInfo.searchCondition,
										5,
										"",
										"",
										_CB_getCertTreeCallback);
}

function getSelectedInfoObject (aIndex, isIssuerAndSerial) {
	var aResult = {};

	switch (aIndex) {
	case 0:
		aResult.mediaID = gSelectedMediaID;
		aResult.certType = 2;
		aResult.searchCondition = 0;
		aResult.tableObject = gCertTable;
		break;
	case 1:
		aResult.mediaID = 1;
		aResult.certType = 1;
		aResult.searchCondition = 30;
		aResult.tableObject = gCertTable;
		break;
	case 2:
		aResult.mediaID = 1;
		aResult.certType = 0;
		aResult.searchCondition = 30;
		aResult.tableObject = gCertTable;
		break;
	case 3:
		aResult.mediaID = 1;
		aResult.certType = 3;
		aResult.searchCondition = 50;
		aResult.tableObject = gCertTable;
		break;
	}

	if (isIssuerAndSerial) {
		aResult.issuerRDN = aResult.tableObject.getSelectedIssuerRDN();
		aResult.certSerial = aResult.tableObject.getSelectedCertSerial();
		aResult.certClass = aResult.tableObject.getSelectedCertClass();
		aResult.certStatus = aResult.tableObject.getSelectedCertStatus();
		if (!aResult.issuerRDN || !aResult.certSerial) {
			alert(XWC.S.noselection);
			aResult = undefined;
		}
	}

	return aResult;
}

function onHddButtonClick(element) {
	var aCertList,
		i;

	gSelectedButton = 1;
	gSelectedMediaID = 1;
	gCertTable.refresh("");

	if (checkAnySignLoad() == false) {
		__SANDBOX.setButton([__87, __90, __93, __98, __101, __104], "disabled", true, null);
		gEvent = element;
		onCheckMedia();	
		return;
	}
	
	AnySign.mAnySignEnable = true;

	__SANDBOX.setButton([__87, __90, __93, __98, __101, __104], "disabled", false, null);
	setButtonManager ("disabled");
	
	__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_HARD, 0, 1, loadTableValues);
}

function onRemovableButtonClick(element) {
	var aMediaList,
		aMenuItems,
		i;

	gSelectedButton = 2;
	gSelectedMediaID = XWC.CERT_LOCATION_REMOVABLE;
	gCertTable.refresh("");

	if (checkAnySignLoad() == false) {
		__SANDBOX.setButton([__87, __90, __93, __98, __101, __104], "disabled", true, null);
		gEvent = element;
		onCheckMedia();
		return;
	}
	
	AnySign.mAnySignEnable = true;

	__SANDBOX.setButton([__87, __90, __93, __98, __101, __104], "disabled", false, null);
	setButtonManager ("disabled");

		_getMediaListRefresh = function (result) {
		var aIDList = result.split("\t\n");
		setButtonManager ("enabled");

		if (__SANDBOX.isFailed(aIDList, gErrCallback))
			return;

		aMenuItems = [];

		for (i = 0; i < aMediaList.length; i++) {
			if (aMediaList[i].length > 0) {
				aMenuItems.push({ item: aMediaList[i], data: Number(aIDList[i]) });
			}
		}

		XWC.UI.ContextMenu(element, XWC.S.media_removable_list, aMenuItems, aContextMenuFunc);
	}
		_getMediaListCallback = function (result) {
		aMediaList = result.split("\t\n");
		if (__SANDBOX.isFailed(aMediaList, gErrCallback))
			return;

		__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_REMOVABLE, 1, 0, _getMediaListRefresh);
	}

	function aContextMenuFunc(aMenuData) {
		var aCertList;
		gSelectedMediaID = aMenuData;

		loadTableValues (0);
		element.focus();
	}

	__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_REMOVABLE, 0, 1, _getMediaListCallback);
}

function onSaveTokenButtonClick(element) {
	var	aGuideDialog,
		aGuideModule,
		aMenuItems = [];

	gSelectedButton = 3;
	gCertTable.refresh("");

	if (checkAnySignLoad() == false) {
		__SANDBOX.setButton([__87, __90, __93, __98, __101, __104], "disabled", true, null);
		gEvent = element;
		onCheckMedia();
		return;
	}
	
	AnySign.mAnySignEnable = true;
	
	__SANDBOX.setButton([__87, __90, __93, __98, __101, __104], "disabled", false, null);

	if (__SANDBOX.certLocationSet["iccard"])
		aMenuItems.push({ item: XWC.S.iccard, data: XWC.CERT_LOCATION_ICCARD});
	
	if (__SANDBOX.certLocationSet["kepcoiccard"])
		aMenuItems.push({ item: XWC.S.kepcoiccard, data: XWC.CERT_LOCATION_KEPCOICCARD});

		_getCertTree = function ()
	{
		var _cb_logoutStoreToken = function () {
			aGuideDialog.dispose();
		}

		__SANDBOX.upInterface().logoutStoreToken(gSelectedMediaID, _cb_logoutStoreToken);
	}
		_loginStoreToken = function (result)
	{
		var aErrorObject, aCertList;
		if(result != 0)
		{
			aGuideDialog.dispose ();
			aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
		}
		else
		{ 
			__SANDBOX.setButton([__93], "disabled", true, null);
			loadTableValues (0, _getCertTree);
		}
	}
	
	function aContextMenuFunc(aMenuData) {
		
		gSelectedMediaID = aMenuData;
		var aMediaType = gSelectedMediaID;
		
				ShowIccardDialog = function (aMediaID)
		{
			gSelectedMediaID = aMediaID;
			
			if (aMediaType == XWC.CERT_LOCATION_KEPCOICCARD)
				aICCardType = "kepco";
			else
				aICCardType = "iccard";
			
			AnySign.SetUITarget (__48);
			var iccardModule = __SANDBOX.loadModule("iccard");
			var iccardDialog = iccardModule({
				type: aICCardType,
				args: {},
				onconfirm: function (aPin) {
					iccardDialog.dispose();

					aGuideModule = __SANDBOX.loadModule("guidewindow");
					aGuideDialog = aGuideModule({
						type: "loading",
						args: "",
						onconfirm: "",
						oncancel: function () {aGuideDialog.dispose();}
					});
					
					__SANDBOX.upInterface().loginStoreToken(gSelectedMediaID, aPin, 1, _loginStoreToken);

					aGuideDialog.show();
				},
				oncancel: function () {
					iccardDialog.dispose();
				}
			});
			iccardDialog.show();
		}
		
		if (gSelectedMediaID == XWC.CERT_LOCATION_ICCARD) {
			AnySign.SetUITarget (__48);
			var iccardlistModule = __SANDBOX.loadModule("iccardlist");
			var iccardlistDialog = iccardlistModule({
				args: {},
				onconfirm: function (aResult) {
					iccardlistDialog.dispose();
					ShowIccardDialog (XWC.CERT_LOCATION_ICCARD + aResult);
				},
				oncancel: function () {
					iccardlistDialog.dispose();
				}
			});
			iccardlistDialog.show();
		} else if (gSelectedMediaID == XWC.CERT_LOCATION_KEPCOICCARD) {
			_CB_initStoreToken = function (aResult)
			{
				var aErrCallback = function (aErrorObject) {
										alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
				}
				
				if (!__SANDBOX.isFailed(aResult, aErrCallback)) {
					ShowIccardDialog (XWC.CERT_LOCATION_KEPCOICCARD + 1);
				}
			}
			__SANDBOX.upInterface().initStoreToken(XWC.CERT_LOCATION_KEPCOICCARD + 1, _CB_initStoreToken);
		}
	}

	XWC.UI.ContextMenu(element, XWC.S.media_savetoken_list, aMenuItems, aContextMenuFunc);
}

function onHSMButtonClick(element) {
	var aGuideModule,
		aGuideDialog,
		aErrorObject;

	gCertTable.refresh(XWC.stringToArray(""));
	gSelectedButton = 4;
	gSelectedMediaID = XWC.CERT_LOCATION_PKCS11;

	if (checkAnySignLoad() == false) {
		__SANDBOX.setButton([__87, __90, __93, __98, __101, __104], "disabled", true, null);
		gEvent = element;
		onCheckMedia();
		return;
	}
	
	AnySign.mAnySignEnable = true;
	
	__SANDBOX.setButton([__87, __90, __93, __98, __101, __104], "disabled", false, null);

		_hsmDriverManager = function (result)
	{
		if (result != 0)
		{
			var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			if(aErrorObject.code == 10010009)
			{
				if (confirm(XWC.S.savetoken_msg))
					window.open(XWC.S.rootca_url, "_blank");
			}
			else
			{
				alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
			}
		}
	}
		_getMediaList = function (aMediaList)
	{
		if (aGuideDialog)
			aGuideDialog.dispose();

		if (aMediaList == "")
		{
			var aResult = confirm(XWC.JSSTR("installNotifyHSM"));
			if (aResult)
			{
				__SANDBOX.upInterface().hsmDriverManager(_hsmDriverManager);
			}
		}
		else
		{
			_hsmSelectDialog ();
		}
	}
		_finalizePKCS11FromName = function () {}
		_getCertTree = function ()
	{
		__SANDBOX.upInterface().finalizePKCS11FromName (gProviderName, _finalizePKCS11FromName);
	}
	
	function _hsmSelectDialog ()
	{
		var hsmselectModule = __SANDBOX.loadModule("hsmselect");
		AnySign.SetUITarget (__51);
		var hsmselectDialog = hsmselectModule({
			onconfirm: function (aResult, aProviderName) {
				if(aResult < 0) {
					element.focus();
					hsmselectDialog.dispose();
					return;
				}

				gProviderName = aProviderName;
				gSelectedMediaID = XWC.CERT_LOCATION_PKCS11 + aResult;

				hsmselectDialog.dispose();
				__SANDBOX.setButton([__87, __101], "disabled", true, null);
				loadTableValues (0, _getCertTree);
			},
			oncancel: function () { 
				element.focus();
				hsmselectDialog.dispose();
			}
		});
		hsmselectDialog.show();
	}

	aGuideModule = __SANDBOX.loadModule("guidewindow");
	aGuideDialog = aGuideModule({
					type: "delete",
					args: "",
					onconfirm: "",
					oncancel: function () {aGuideDialog.dispose();}
	});

	__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_PKCS11, 0, 1, _getMediaList);

	aGuideDialog.show();
}

function onMobileButtonClick(element) {
	var aInfoList = XWC.S.mobile_info,
		aMenuItems = [];

	aMenuItems.push({ item: aInfoList, data: XWC.CERT_LOCATION_YESSIGNM + 1 });
	gCertTable.refresh(XWC.stringToArray(""));
	gSelectedButton = 5;
	gSelectedMediaID = XWC.CERT_LOCATION_YESSIGNM;

	if (checkAnySignLoad() == false) {
		__SANDBOX.setButton([__87, __90, __93, __98, __101, __104], "disabled", true, null);
		gEvent = element;
		onCheckMedia();
		return;
	}
	
	AnySign.mAnySignEnable = true;
	
	__SANDBOX.setButton([__87, __90, __93, __98, __101, __104], "disabled", false, null);

	function aContextMenuFunc(aMenuData) {
		var aMediaType,
			aGuideModule,
			aGuideDialog;

		gSelectedMediaID = aMenuData;

        function getCertificateList() {
			if (aGuideDialog)
				aGuideDialog.dispose();
			
            loadTableValues(0);
            __SANDBOX.setButton([__87, __90, __93, __101], "disabled", true, null);
            element.focus();
        }

				_CB_getMediaList = function (result)
		{
			if ((typeof (result) == "string" && result == "")) {
				var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();

				if (aErrorObject.code == 10010002) {
					if (aGuideDialog)
						aGuideDialog.dispose();
					
					result = confirm(XWC.JSSTR("installNotify"));

					var aURL = AnySign.mUbikeyData.mInstallURL;
					var aOpenOption = AnySign.mUbikeyData.mInstallPageOption;

					if (result == true) {
						window.open(aURL, 'DownLoadPage', aOpenOption);
					}
					return;
				}
			}

			getCertificateList();
		}
				_CB_setPhoneData = function ()
		{
			aMediaType = Math.floor(parseInt(gSelectedMediaID, 10) / 100) * 100;

			__SANDBOX.upInterface().getMediaList(aMediaType, 0, 1, _CB_getMediaList);
		}
				
		aGuideModule = __SANDBOX.loadModule("guidewindow");
		aGuideDialog = aGuideModule({
						type: "loading",
						args: "",
						onconfirm: "",
						oncancel: function () {aGuideDialog.dispose();}
		});
		aGuideDialog.show();
		
		switch (gSelectedMediaID) { 
			case XWC.CERT_LOCATION_YESSIGNM + 1:
				aUbikeyData = AnySign.mUbikeyData;

				aPhoneData = AnySign.mXgateAddress + "&"
									+ aUbikeyData.mSite + "|" + aUbikeyData.mLiveUpdate + "&"
									+ aUbikeyData.mSecurity + "|" + aUbikeyData.mKeyboardSecurity + "&"
								+ aUbikeyData.mVersion;

				__SANDBOX.upInterface().setPhoneData (aPhoneData, 0x10, _CB_setPhoneData);

				break;
			default:
				aGuideDialog.dispose();
		}
	}

	XWC.UI.ContextMenu(element, XWC.S.media_mobile, aMenuItems, aContextMenuFunc);
}

function onSecureDiskButtonClick(element) {
	var aGuideModule,
		aGuideDialog;

	gCertTable.refresh(XWC.stringToArray(""));
	gSelectedButton = 6;
	gSelectedMediaID = XWC.CERT_LOCATION_SECUREDISK;
	
	if (checkAnySignLoad() == false) {
		__SANDBOX.setButton([__87, __90, __93, __98, __101, __104], "disabled", true, null);
		gEvent = element;
		onCheckMedia();
		return;
	}
	
	AnySign.mAnySignEnable = true;
	
	__SANDBOX.setButton([__87, __90, __93, __98, __101, __104], "disabled", false, null);
	
		_finalizeSecureDiskFromName = function ()
	{
		if (aGuideDialog)
			aGuideDialog.dispose();
		element.focus();
	}
	
		_getCertTree = function ()
 	{
		__SANDBOX.upInterface().finalizeSecureDiskFromName (gProviderName, _finalizeSecureDiskFromName);
 	}
	
		_securedisk_install = function ()
	{
		var aURL = AnySign.mSecureDiskData.mInstallURL;
		var aOption = AnySign.mSecureDiskData.mInstallPageOption;
		
		if (aURL == null || aURL == undefined || aURL == "")
		{
			alert(XWC.JSSTR("securedisk_notable"));
		}
		else
		{
			if (confirm(XWC.JSSTR("securedisk_install")) == true)
				window.open (aURL, 'DownLoadPage', aOption);
		}
	}
	
		_initializeSecureDiskFromName = function (aResult)
	{
		if (aResult == 0) {
			gSelectedMediaID = XWC.CERT_LOCATION_SECUREDISK + 1;
			__SANDBOX.setButton([__87, __104], "disabled", true, null);
			loadTableValues (0, _getCertTree);
		} else {
						
			if (aGuideDialog)
				aGuideDialog.dispose();
			
			var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			if (aErrorObject.code == 23000802) {
				_securedisk_install ();
			} else {
				alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
			}
			
			element.focus();
		}
	}
	
		_getMediaList = function (aProviderName)
	{
		if (aProviderName == "")
		{
			if (aGuideDialog)
				aGuideDialog.dispose();
			
			_securedisk_install ();
			
			element.focus();
		}
		else
		{
			gProviderName = aProviderName;
			
			__SANDBOX.upInterface().initializeSecureDiskFromName(aProviderName, _initializeSecureDiskFromName);
		}
	}
		
	aGuideModule = __SANDBOX.loadModule("guidewindow");
	aGuideDialog = aGuideModule({
					type: "loading",
					args: "",
					onconfirm: "",
					oncancel: function () {aGuideDialog.dispose();}
	});
	aGuideDialog.show();
	
	__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_SECUREDISK, 0, 1, _getMediaList);
}

function onLocalStorageButtonClick() {
	AnySign.mAnySignEnable = false;
	gSelectedButton = 7;
	gSelectedMediaID = XWC.CERT_LOCATION_LOCALSTORAGE;
	gCertTable.refresh("");
	__SANDBOX.setButton([__87, __90, __93, __98, __101, __104], "disabled", false, null);
	
	__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_LOCALSTORAGE, 0, 1, loadTableValues);
}

function onXecureFreeSignButtonClick(element) {
	AnySign.mAnySignEnable = false;
	gSelectedButton = 8;
	gSelectedMediaID = XWC.CERT_LOCATION_XECUREFREESIGN;
	gCertTable.refresh("");
	__SANDBOX.setButton([__87, __90, __93, __98, __101, __104], "disabled", false, null);
	
	var _cb_getCertTree2 = function (aResult) {
		if (aResult == 0) {
			var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			if (aErrorObject.code == 0)
				alert(XWC.S.xfs_no_cert)
			else
				alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
			
						
									
			__SANDBOX.setButton([__104], "disabled", true, null);
		} else {
			__SANDBOX.setButton([__104], "disabled", true, null);
		}
	}
	
	var _openXFSLogin = function () {
		var xfsModule = __SANDBOX.loadModule("xfslogin");
		var xfsDialog = xfsModule({
			args:"",
			onconfirm: function (aResult) {
				xfsDialog.dispose();
				if(aResult == 0) {
					loadTableValues(0, _cb_getCertTree2);
				} else {
									}
			},
			oncancel: function () {
				xfsDialog.dispose();
			}
		});
		xfsDialog.show();
	}
	
	var _cb_getCertTree = function (aResult) {
				__SANDBOX.setButton([__104], "disabled", true, null);
	}
	
	var _cb_getMediaList = function (aResult) {
		if (aResult == 0) {					loadTableValues(0, _cb_getCertTree);
		} else {
			var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			if (aErrorObject.code == 0x7005011C)
				_openXFSLogin();				else
				alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));			}
	}
	
		__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_XECUREFREESIGN, 0, 1, _cb_getMediaList);
}

function onOKButtonClick() { gDialogObj.onconfirm(); }
function onCancelButtonClick() { gDialogObj.oncancel(); }

function CertTableView() {
	var aSelectedIssuerRDN,
		aSelectedCertSerial,
		aSelectedSubjectRDN,
		aSelectedCertClass,
		aSelectedCertStatus,
		tableView,
		gCertTable = __63.getElementsByTagName("table")[0];

	this.mData = null;
	aSelectedIssuerRDN = null;
	aSelectedCertSerial = null;
	aSelectedCertClass = null;
	aSelectedCertStatus = null;
	tableView = new XWC.UI.TableView( __63, 1);

	tableView.onSelectRow = function (aObject) {
		var aSelectedRow,
			aTableBody = gCertTable.tBodies[0],
			aSelectedRowElement = aTableBody.rows[aObject.rowIndex - 1],
			i;

		aSelectedSubjectRDN = aSelectedRowElement.getAttribute('subject');
		aSelectedIssuerRDN = aSelectedRowElement.getAttribute('issuer');
		aSelectedCertSerial = aSelectedRowElement.getAttribute('serial');
		aSelectedCertClass = aSelectedRowElement.getAttribute('certClass');
		aSelectedCertStatus = aSelectedRowElement.getAttribute('status');

		aSelectedRowElement.focus();
	};

	tableView.onRowClick = function () {
	};

	tableView.onRefresh = function (aData) {
		var aTargetImgUrl,
			certInfo,
			tr,
			td,
			i;

		aSelectedSubjectRDN = null;
		aSelectedIssuerRDN = null;
		aSelectedCertSerial = null;
		aSelectedCertClass = null;
		aSelectedCertStatus = null;

		aTableBody = gCertTable.tBodies[0];
		this.mData = aData;

		for (i = 0; i < aData.length; i++) {
			certInfo = aData[i];
			if (!certInfo[1]) { certInfo[1] = XWC.JSSTR("privatecert"); }
			if (!certInfo[2]) continue;

			tr = XWC.UI.createElement("tr");
			tr.setAttribute("role", "row", 0);
			tr.setAttribute("aria-selected", "false", 0);

			tr.setAttribute('status', certInfo[0]);
			tr.setAttribute('certClass', certInfo[1]);
			tr.setAttribute('subject', certInfo[2]);
			tr.setAttribute('issuer', certInfo[5]);
			tr.setAttribute('serial', certInfo[6]);
			
			statusTextCell = tableView.createTextCell(XWC.S["table_select"] + XWC.S["cert_status" + certInfo[0]]);
			statusTextCell.style.display = "none";

			td = XWC.UI.createElement("td");

			aTargetImgUrl = AnySign.mBasePath + "/img/cert" + certInfo[0] + ".png";

			td.appendChild(tableView.createImageTextCell(aTargetImgUrl, certInfo[1], XWC.S["cert_status" + certInfo[0]]));
			tr.appendChild(statusTextCell);
			tr.appendChild(td);

			td = XWC.UI.createElement("td");
			td.appendChild(tableView.createTextCell(XWC.Util.getCNFromRDN(certInfo[2])));
			tr.appendChild(td);

			td = XWC.UI.createElement("td");
			td.appendChild(tableView.createTextCell(certInfo[4]));
			tr.appendChild(td);

			td = XWC.UI.createElement("td");
			td.appendChild(tableView.createTextCell(certInfo[3]));
			tr.appendChild(td);

			tr.className = "xwup-tableview-unselected-row";

			tr.setAttribute("tabindex", 3, 0);
			
			aTableBody.appendChild(tr);
		}
	};

	tableView.getSelectedSubjectRDN = function () {
		return aSelectedSubjectRDN || null;
	};

	tableView.getSelectedIssuerRDN = function () {
		return aSelectedIssuerRDN || null;
	};

	tableView.getSelectedCertSerial = function () {
		return aSelectedCertSerial || null;
	};

	tableView.getSelectedCertClass = function () {
		return aSelectedCertClass || null;
	};
	
	tableView.getSelectedCertStatus = function () {
		return aSelectedCertStatus || null;
	};

	return tableView;
}

function setFocus() {
	__2.parentNode.focus();
}

function onCopyButtonClick(e) {
	var aIssuerRDN,
		aCertSerial,
		aDisableItem,
		aProviderName,
		aTargetMediaID,
		aTargetMediaType,
		aTargetInputType,
		aSelectMediaType,
		aSelectInputType,
		aCertKeyword = "",
		aSaveKeyword = "",
		aStoreTokenPIN,
		aGuideModule,
		aGuideDialog = null,
		target;
	
	e = e || window.event;
	target = e.target || e.srcElement;

	gSelectedButton = 9;
		
	aIssuerRDN = gCertTable.getSelectedIssuerRDN();
	aCertSerial = gCertTable.getSelectedCertSerial();
	if (!aIssuerRDN || !aCertSerial) {
		alert(XWC.S.noselection);
		return;
	}

	aDisableItem = gSelectedMediaID;
	aSelectMediaType = Math.floor(gSelectedMediaID / 100) * 100;
	aSelectInputType = __SANDBOX.getInputType(gSelectedMediaID);
	
	var orgAnySignEnable;
	if (aSelectInputType == "lite" || aSelectInputType == "xfs")
		orgAnySignEnable = false;
	else
		orgAnySignEnable = true;
		
	AnySign.mAnySignEnable = true;
	
		_show_guidewindow = function ()
	{
		if (aGuideDialog) return;
		
		aGuideModule = __SANDBOX.loadModule("guidewindow");
		aGuideDialog = aGuideModule({
			type: "loading",
			args: "",
			onconfirm: "",
			oncancel: function () {aGuideDialog.dispose();}
		});
		aGuideDialog.show();
	}
	
	_close_guidewindow = function ()
	{
		if (aGuideDialog) {
			aGuideDialog.dispose ();
			aGuideDialog = null;
		}
	}

		_fn_final = function (aCallback)
	{
		var _final_callback = function () {
			AnySign.mAnySignEnable = orgAnySignEnable;
			
			_close_guidewindow ();
			
			if (aCallback)
				aCallback ();
		}
		
		
		var _final_targetMedia = function () {
			if (aTargetMediaType == XWC.CERT_LOCATION_ICCARD || aTargetMediaType == XWC.CERT_LOCATION_KEPCOICCARD) {
				AnySign.mAnySignEnable = true;
				__SANDBOX.upInterface().logoutStoreToken(aTargetMediaID, _final_callback);
			} else if (aTargetMediaType == XWC.CERT_LOCATION_PKCS11) {
				AnySign.mAnySignEnable = true;
				__SANDBOX.upInterface().finalizePKCS11FromName (aProviderName, _final_callback);
			} else if (aTargetMediaType == XWC.CERT_LOCATION_SECUREDISK) {
				AnySign.mAnySignEnable = true;
				__SANDBOX.upInterface().finalizeSecureDiskFromName (aProviderName, _final_callback);
			} else {
				_final_callback ();
			}
		}
		
		var _final_selectMedia = function () {
			if (aSelectMediaType == XWC.CERT_LOCATION_ICCARD || aSelectMediaType == XWC.CERT_LOCATION_KEPCOICCARD) {
				AnySign.mAnySignEnable = true;
				__SANDBOX.upInterface().logoutStoreToken(gSelectedMediaID, _final_targetMedia);
			} else {
				_final_targetMedia ();
			}
		}
		
		aCertKeyword = "";
		aSaveKeyword = "";
		aStoreTokenPIN = "";
		
		_final_selectMedia ();
	}
		
		_CB_saveCert = function (result)
	{
		var aMessage;
		var aResultAlert = true;
		
		if (result != 0 && aTargetMediaType == XWC.CERT_LOCATION_YESSIGNM) {
			var _fn_final_callback = function () {
				alert(XWC.S.copyfail_ubikey);
				target.focus();
			}
			_fn_final (_fn_final_callback);
			return;
		}
		
		if (result == 1) {
			var _fn_final_callback = function () {
				alert(XWC.S.copycancel);
				target.focus();
			}
			_fn_final (_fn_final_callback);
			return;
		}
		
		_errCallback = function(aResult) {
			if (!aResult.msg)
				aResult.msg = "Unknown Error";
			
			if (aResult.code == 21000405) {
				alert(aResult.msg.replace(/\\n/g, '\r\n'));
				aResultAlert = false;
			} else if (aResult.code == 22000006 || aResult.code == 21000015) {
				alert(XWC.S.verifypasserr);
				aResultAlert = false;
			} else {
				alert("[" + aResult.code + "] " +aResult.msg.replace(/\\n/g, '\r\n'));
			}
		}
		
		if (__SANDBOX.isFailed(result, _errCallback)) {
			if (aTargetMediaType == XWC.CERT_LOCATION_ICCARD || aTargetMediaType == XWC.CERT_LOCATION_KEPCOICCARD)
				aMessage = XWC.S.copyfail_iccard;
			else
				aMessage = XWC.S.copyfail;
		}
		else
		{
			getMediaName = function (aMediaID) {
				var aMediaType = Math.floor(aMediaID / 100) * 100;
				switch (aMediaType) {
				case (XWC.CERT_LOCATION_HARD):
					return XWC.S.media_hdd;
				case (XWC.CERT_LOCATION_REMOVABLE):
					return XWC.S.media_removable;
				case (XWC.CERT_LOCATION_ICCARD):
				case (XWC.CERT_LOCATION_KEPCOICCARD):
					return XWC.S.media_iccard;
				case (XWC.CERT_LOCATION_PKCS11):
					return XWC.S.media_pkcs11;
				case (XWC.CERT_LOCATION_YESSIGNM):
					return XWC.S.media_mobile;
				case (XWC.CERT_LOCATION_LOCALSTORAGE) :
					return XWC.S.media_localstorage;
				case (XWC.CERT_LOCATION_SECUREDISK) :
					return XWC.S.media_securedisk;
				case (XWC.CERT_LOCATION_XECUREFREESIGN) :
					return XWC.S.media_xfs;
				}
			};

			aMessage = XWC.S.copyok1;
			aMessage += getMediaName(gSelectedMediaID);
			aMessage += XWC.S.copyok2;
			aMessage += getMediaName(aTargetMediaID);
			aMessage += XWC.S.copyok3;
		}

		var _fn_final_callback = function () {
			if (aResultAlert)
				alert(aMessage);
			target.focus();
		}
		_fn_final (_fn_final_callback);
	}
	
		_CB_certsaveloc = function ()
	{
		if (aSelectInputType == aTargetInputType) {
						if (aSelectMediaType == XWC.CERT_LOCATION_ICCARD || aSelectMediaType == XWC.CERT_LOCATION_KEPCOICCARD) {
								__SANDBOX.upInterface().saveCertFromStoreToken (aIssuerRDN,
																aCertSerial,
																aCertKeyword,
																gSelectedMediaID,
																2,
																aTargetMediaID,
																aStoreTokenPIN,
																_CB_saveCert);
			} else {
								__SANDBOX.upInterface().saveCert(aIssuerRDN,
												 aCertSerial,
												 aCertKeyword,
												 gSelectedMediaID,
												 2,
												 aTargetMediaID,
												 _CB_saveCert);
			}
		} else {
			_CB_exportCertToPFX = function (result) {
				if (!result) {
					_CB_saveCert (-1);
					return;
				}
				
				if (aTargetInputType == "lite" || aTargetInputType == "xfs") {
					AnySign.mAnySignEnable = false;
					
				} else {
					AnySign.mAnySignEnable = true;
					result = "$" + result;
				}
				
				__SANDBOX.upInterface().importCertFromPFX (aTargetMediaID,
														   aSaveKeyword,
														   aSaveKeyword,
														   result,
														   "", "", "", "",
														   aStoreTokenPIN?aStoreTokenPIN:"",
														   0,
														   _CB_saveCert);
			}
			
			if (aSelectInputType == "lite" || aSelectInputType == "xfs")
				AnySign.mAnySignEnable = false;
			else
				AnySign.mAnySignEnable = true;
			
			__SANDBOX.upInterface().exportCertToPFX (gSelectedMediaID,
													 aIssuerRDN,
													 aCertSerial,
													 aCertKeyword,
													 aCertKeyword,
													 aStoreTokenPIN?aStoreTokenPIN:"",
													 0,
													 _CB_exportCertToPFX);
		}
	}
	
		_fn_nextProcess = function ()
	{
		if (aTargetMediaType == XWC.CERT_LOCATION_PKCS11) {
			_close_guidewindow ();
			AnySign.mAnySignEnable = true;
			_open_hsmselect ();
		} else if (aTargetMediaType == XWC.CERT_LOCATION_ICCARD) {
			_close_guidewindow ();
			AnySign.mAnySignEnable = true;
			_open_iccardlist (_CB_certsaveloc);
		} else if (aTargetMediaType == XWC.CERT_LOCATION_KEPCOICCARD) {
			_close_guidewindow ();
			AnySign.mAnySignEnable = true;
			_check_kepcoiccard (_CB_certsaveloc);
		} else if (aTargetMediaType == XWC.CERT_LOCATION_SECUREDISK) {
			_close_guidewindow ();
			AnySign.mAnySignEnable = true;
			_check_securedisk ();
		} else if (aTargetMediaType == XWC.CERT_LOCATION_XECUREFREESIGN) {
			_close_guidewindow ();
			AnySign.mAnySignEnable = false;
			_check_xfs_login ();
		} else {
			_CB_certsaveloc ();
		}
	}
	
		_open_savepasswd = function (aInputType)
	{
		AnySign.SetUITarget (target);
		var inputpasswdModule = __SANDBOX.loadModule("inputpasswd");
		var inputpasswdDialog = inputpasswdModule({
			args: {messageType: "certificate2",
				   descType: "copy",
				   inputType: aInputType,
				   errCallback: gErrCallback},
			onconfirm: function(aResult) { 
				inputpasswdDialog.dispose();
				aSaveKeyword = aResult;
				_fn_nextProcess();
			},
			oncancel: function() {
				inputpasswdDialog.dispose();
				var _fn_final_callback = function () {
					alert(XWC.S.copycancel);
					target.focus();
				}
				_fn_final (_fn_final_callback);
			}
		});
		inputpasswdDialog.show();
	}
	
		_CB_verifyPassword = function (result)
	{
		if (result != 0) {
			var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			if (aErrorObject.code == 22000006) {
				alert(XWC.S.verifypasserr);
			} else if (aErrorObject.code == 22000015) {
				alert(XWC.S.incorrect_kmcertPW);
			} else {
				alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
			}
			
			var _fn_final_callback = function () {
				target.focus();
			}
			_fn_final (_fn_final_callback);
		}
		else
		{
			if (aSelectInputType == aTargetInputType) {
								_fn_nextProcess();
			} else {
				if (aTargetInputType == "lite") {
					AnySign.mAnySignEnable = false;
					_open_savepasswd ("lite");
				} else if (aTargetInputType == "xfs") {
					AnySign.mAnySignEnable = false;
					_open_savepasswd ("xfs");
				} else {
					AnySign.mAnySignEnable = true;
					_open_savepasswd ("4pc");
				}
			}
		}
	}
	
		_open_inputpasswd = function ()
	{
		AnySign.SetUITarget (target);
		var inputpassModule = __SANDBOX.loadModule("inputpasswd");
		var inputpassDialog = inputpassModule({
			args: {messageType: "certificate",
				   descType: "copy",
				   inputType: aSelectInputType,
				   errCallback: gErrCallback},
			onconfirm: function (result) {
				inputpassDialog.dispose();
				
				aCertKeyword = result;
				__SANDBOX.upInterface().verifyPassword(gSelectedMediaID, aIssuerRDN, aCertSerial, result, _CB_verifyPassword);
			},
			oncancel: function (e) {
				inputpassDialog.dispose();
				var _fn_final_callback = function () {
					alert(XWC.S.copycancel);
					target.focus();
				}
				_fn_final (_fn_final_callback);
			}
		});
		
		inputpassDialog.show();
	}
	
		_open_verifyhsm = function ()
	{
		var _CB_loginPKCS11FromIndex = function (result)
		{
			if (result != 0)
			{
				var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
				var _fn_final_callback = function () {
					alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
					target.focus();
				}
				_fn_final (_fn_final_callback);
			}
			else
				_CB_certsaveloc ();
		}
		
		var verifyhsmModule, verifyhsmDialog;

		AnySign.SetUITarget (target);
		verifyhsmModule = __SANDBOX.loadModule("verifyhsm");
		verifyhsmDialog = verifyhsmModule({
			args: {messageType: "copy"},
			onconfirm: function (aPin) {
				verifyhsmDialog.dispose();
				_show_guidewindow ();
				
				__SANDBOX.upInterface().loginPKCS11FromIndex(aTargetMediaID, aPin, _CB_loginPKCS11FromIndex);
			},
			oncancel: function () {
				verifyhsmDialog.dispose();
				var _fn_final_callback = function () {
					alert(XWC.S.copycancel);
					target.focus();
				}
				_fn_final (_fn_final_callback);
			}
		});
		verifyhsmDialog.show();
	}
	
		_open_hsmselect = function ()
	{
		var hsmselectModule, hsmselectDialog;

		AnySign.SetUITarget (target);
		hsmselectModule = __SANDBOX.loadModule("hsmselect");
		hsmselectDialog = hsmselectModule({
			onconfirm: function (aResult, providerName) {
				hsmselectDialog.dispose();
				aProviderName = providerName;
				
				var _fn_final_callback = function () {
					alert(XWC.S.copyfail_ubikey);
					target.focus();
				}
				
				if(aResult < 0) {
					_fn_final (_fn_final_callback);
					return;
				}

				aTargetMediaID = aTargetMediaID + aResult;
				_open_verifyhsm();
			},
			oncancel: function () {
				hsmselectDialog.dispose();
				var _fn_final_callback = function () {
					alert(XWC.S.copycancel);
					target.focus();
				}
				_fn_final (_fn_final_callback);
			}
		});
		hsmselectDialog.show();
	}
	
		_open_iccard = function (mediaID, callback)
	{
		var _CB_loginStoreToken = function (result)
		{
			if(result != 0) {
				var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
				var _fn_final_callback = function () {
					alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
					target.focus();
				}
				_fn_final (_fn_final_callback);
			}
			else
			{
				callback ();
			}
		}
		
		var aMediaType = Math.floor(mediaID / 100) * 100;
		var aICCardType;
		if (aMediaType == XWC.CERT_LOCATION_KEPCOICCARD)
			aICCardType = "kepco";
		else
			aICCardType = "iccard";
		
		var iccardModule = __SANDBOX.loadModule("iccard");
		AnySign.SetUITarget (__48);
		var iccardDialog = iccardModule({
			type: aICCardType,
			args: {},
			onconfirm: function (aPin) {
				iccardDialog.dispose();
				aStoreTokenPIN = aPin;
				_show_guidewindow ();
				
				__SANDBOX.upInterface().loginStoreToken(mediaID, aStoreTokenPIN, 1, _CB_loginStoreToken);
			},
			oncancel: function () {
				iccardDialog.dispose();
				var _fn_final_callback = function () {
					alert(XWC.S.copycancel);
					target.focus();
				}
				_fn_final (_fn_final_callback);
			}
		});
		iccardDialog.show();
	}
	
		_open_iccardlist = function (callback)
	{
		var iccardlistModule = __SANDBOX.loadModule("iccardlist");
		AnySign.SetUITarget (__48);
		var iccardlistDialog = iccardlistModule({
			args: { },
			onconfirm: function (aResult) {
				iccardlistDialog.dispose();
				aTargetMediaID = XWC.CERT_LOCATION_ICCARD + aResult;

				_open_iccard (aTargetMediaID, callback);
			},
			oncancel: function () {
				iccardlistDialog.dispose();
				var _fn_final_callback = function () {
					alert(XWC.S.copycancel);
					target.focus();
				}
				_fn_final (_fn_final_callback);
			}
		});
		iccardlistDialog.show();
	}
	
		_check_kepcoiccard = function (callback)
	{
		_CB_initStoreToken = function (aResult)
		{
			var aErrCallback = function (aErrorObject) {
				var _fn_final_callback = function () {
										alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
					target.focus();
				}
				_fn_final (_fn_final_callback);
			}
			
			if (!__SANDBOX.isFailed(aResult, aErrCallback)) {
				aTargetMediaID = XWC.CERT_LOCATION_KEPCOICCARD + 1;
				_open_iccard (aTargetMediaID, callback);
			}
		}
		__SANDBOX.upInterface().initStoreToken(XWC.CERT_LOCATION_KEPCOICCARD + 1, _CB_initStoreToken);
	}
	
		_check_securedisk = function ()
	{
		aTargetMediaID = aTargetMediaID + 1;
		
		_securedisk_login = function (aLoginResult)
		{
			if (aLoginResult != 0) {
				var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
				var _fn_final_callback = function () {
					alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
					target.focus();
				}
				_fn_final (_fn_final_callback);
			} else {
				_CB_certsaveloc ();
			}
		}
		
		_securedisk_init = function (aInitResult)
		{
			if (aInitResult == 0) {
				var aKeyword;
				if (aSelectInputType == "lite" || aSelectInputType == "xfs") {
					aKeyword = aSaveKeyword;
				} else {
					aKeyword = aCertKeyword;
				}
				
				__SANDBOX.upInterface().loginSecureDiskFromIndex (aTargetMediaID,
																  aKeyword,
																  "",
																  "",
																  "",
																  1,
																  _securedisk_login);
			} else {
				var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
				var _fn_final_callback = function () {
					alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
					target.focus();
				}
				_fn_final (_fn_final_callback);
			}
		}
		
		_getMediaList = function (providerName)
		{
			if (providerName == "")
			{
				var _fn_final_callback = function () {
					alert(XWC.JSSTR("securedisk_notable"));
					target.focus();
				}
				_fn_final (_fn_final_callback);
			}
			else
			{
				aProviderName = providerName;
				
				__SANDBOX.upInterface().initializeSecureDiskFromName(aProviderName, _securedisk_init);
			}
		}
		
		_show_guidewindow ();
		
		__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_SECUREDISK, 0, 1, _getMediaList);
	}
	
		_check_xfs_login = function ()
	{
		var _openXFSLogin = function () {
			var xfsModule = __SANDBOX.loadModule("xfslogin");
			var xfsDialog = xfsModule({
				args:"",
				onconfirm: function (aResult) {
					xfsDialog.dispose();
					if(aResult == 0) {
						_CB_certsaveloc ();
					} else {
											}
				},
				oncancel: function () {
					xfsDialog.dispose();
					var _fn_final_callback = function () {
						alert(XWC.S.copycancel);
						target.focus();
					}
					_fn_final (_fn_final_callback);
				}
			});
			xfsDialog.show();
		}
		
		var _cb_getMediaList = function (aResult) {
			if (aResult == 0) {
				_CB_certsaveloc ();
			} else {
				var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
				if (aErrorObject.code == 0x7005011C) {
					_openXFSLogin();
				} else {
					var _fn_final_callback = function () {
						alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
						target.focus();
					}
					_fn_final (_fn_final_callback);
				}
			}
		}
		
		__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_XECUREFREESIGN, 0, 1, _cb_getMediaList);
	}
	
		AnySign.SetUITarget (target);
	certsavelocModule = __SANDBOX.loadModule("certsaveloc");
	certsavelocDialog = certsavelocModule ({
		args: { disableItem: aDisableItem },
		onconfirm: function (result) {
			aTargetMediaID = Number(result);
			
			var _fn_final_callback = function () {
				alert(XWC.S.copysamemedia);
			}

			if (aTargetMediaID == gSelectedMediaID) {
				_fn_final (_fn_final_callback);
				return;
			}
			
			certsavelocDialog.dispose();
			
			aTargetMediaType = Math.floor(aTargetMediaID / 100) * 100;
			aTargetInputType = __SANDBOX.getInputType(aTargetMediaID);
			
			if (aSelectInputType == "lite" || aSelectInputType == "xfs")
				AnySign.mAnySignEnable = false;

			if (aTargetMediaID == XWC.CERT_LOCATION_YESSIGNM + 1)
			{
				_show_guidewindow ();
				_CB_certsaveloc ();
			}
			else if (aSelectMediaType == XWC.CERT_LOCATION_ICCARD || aSelectMediaType == XWC.CERT_LOCATION_KEPCOICCARD)
			{
				_open_iccard (gSelectedMediaID, _open_inputpasswd);
			}
			else
			{
				_open_inputpasswd();
			}
		},
		oncancel: function (e) {
			certsavelocDialog.dispose();
			var _fn_final_callback = function () {
				alert(XWC.S.copycancel);
				target.focus();
			}
			_fn_final (_fn_final_callback);
		}
	});
	
	certsavelocDialog.show();
}

function onDeleteButtonClick(e) {
	var aDeleteResult,
		aCertList,
		aTarget,
		aSelectedInfo,
		aGuideModule,
		aGuideDialog = null;

	e = e || window.event;
	aTarget = e.target || e.srcElement;

	gSelectedButton = 10;

	var aMediaType = Math.floor(parseInt(gSelectedMediaID, 10) / 100) * 100;

		_show_guidewindow = function ()
	{
		aGuideModule = __SANDBOX.loadModule("guidewindow");
		aGuideDialog = aGuideModule({
			type: "loading",
			args: "",
			onconfirm: "",
			oncancel: function () {aGuideDialog.dispose();}
		});
		aGuideDialog.show();
	}
	
		_fn_final = function (aCallback)
	{
		var _final_callback = function () {
			if (aGuideDialog) {
				aGuideDialog.dispose ();
				aGuideDialog = null;
			}
			
			if (aCallback)
				aCallback ();
		}
		
		if (aMediaType == XWC.CERT_LOCATION_PKCS11) {
			__SANDBOX.upInterface().finalizePKCS11FromName (gProviderName, _final_callback);
		} else if (aMediaType == XWC.CERT_LOCATION_ICCARD || aMediaType == XWC.CERT_LOCATION_KEPCOICCARD) {
			__SANDBOX.upInterface().logoutStoreToken (gSelectedMediaID, _final_callback);
		} else if (aMediaType == XWC.CERT_LOCATION_SECUREDISK) {
			__SANDBOX.upInterface().finalizeSecureDiskFromName (gProviderName, _final_callback);
		} else {
			_final_callback();
		}
	}
	
		_CB_getMediaList = function ()
	{
		_finalMedia = function () {
			var _fn_final_callback = function () {
				if (aDeleteResult)
					alert(XWC.S.deleteok);
				else
					alert(XWC.S.deletefail);
				
				aTarget.focus();
			}
			_fn_final (_fn_final_callback);
		}
		
		loadTableValues (gTabView.getSelectedIndex(), _finalMedia);
	}
		_deleteCertCallback = function (result)
	{
		if (__SANDBOX.isFailed(result, gErrCallback))
			aDeleteResult = false;
		else
			aDeleteResult = true;

		__SANDBOX.upInterface().getMediaList(aMediaType , 0, 1, _CB_getMediaList);
	}
		_deleteCertificate = function ()
	{
		__SANDBOX.upInterface().deleteCertificate (aSelectedInfo.mediaID,
												   aSelectedInfo.certType,
												   aSelectedInfo.issuerRDN,
												   aSelectedInfo.certSerial,
												   _deleteCertCallback);
	}
	
	function _verifyhsm_result() {
		
		_loginPKCS11Callback = function (result)
		{
			if (result != 0) {
				var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
				var _fn_final_callback = function () {
					alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
					aTarget.focus();
				}
				_fn_final (_fn_final_callback);
			}
			else
			{
				_deleteCertificate ();
			}
		}
		
		var verifyhsmModule = __SANDBOX.loadModule("verifyhsm");
		AnySign.SetUITarget (aTarget);
		var verifyhsmDialog = verifyhsmModule({
			args: {	messageType: "delete" },
			onconfirm: function (pin) {
				verifyhsmDialog.dispose();
				_show_guidewindow();
				
				__SANDBOX.upInterface().loginPKCS11FromIndex(gSelectedMediaID, pin, _loginPKCS11Callback);
			},
			oncancel: function () {
				aTarget.focus();
				verifyhsmDialog.dispose(); 
			}
		});
		verifyhsmDialog.show();
	}

	function _iccard_result() {
		
		_loginTokenCallback = function (result)
		{
			if(result != 0) {
				var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
				var _fn_final_callback = function () {
					alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
					aTarget.focus();
				}
				_fn_final (_fn_final_callback);
			}
			else
			{
				_deleteCertificate ();
			}
		}
		
		var aICCardType;
		if (aMediaType == XWC.CERT_LOCATION_KEPCOICCARD)
			aICCardType = "kepco";
		else
			aICCardType = "iccard";
	
		var iccardModule = __SANDBOX.loadModule("iccard");
		AnySign.SetUITarget (aTarget);
		var iccardDialog = iccardModule({
			type: aICCardType,
			args: {},
			onconfirm: function (aPin) {
				iccardDialog.dispose();
				_show_guidewindow ();
				
				__SANDBOX.upInterface().loginStoreToken (gSelectedMediaID, aPin, 0, _loginTokenCallback);
			},
			oncancel: function () {
				aTarget.focus();
				iccardDialog.dispose();
			}
		});
		iccardDialog.show();
	};
	
	function _securedisk_result() {
		
		_initializeSecureDiskFromName = function (result)
		{
			if (result != 0) {
				var _fn_final_callback = function () {
					alert(XWC.JSSTR("securedisk_error"));
					aTarget.focus();
				}
				_fn_final (_fn_final_callback);
			}
			else
			{
				_deleteCertificate ();
			}
		}
		
		_show_guidewindow ();
		
		__SANDBOX.upInterface().initializeSecureDiskFromName (gProviderName, _initializeSecureDiskFromName);
	}

	aSelectedInfo = getSelectedInfoObject (gTabView.getSelectedIndex(), true);
	if (typeof(aSelectedInfo) == "undefined")
	{
		aTarget.focus();
		return;
	}
	
	aConfirmResult = confirm(XWC.S.deleteconfirm2);
	if (aConfirmResult)
	{
		if (aMediaType == XWC.CERT_LOCATION_PKCS11) {
			_verifyhsm_result();
		}
		else if (aMediaType == XWC.CERT_LOCATION_ICCARD || aMediaType == XWC.CERT_LOCATION_KEPCOICCARD) {
			_iccard_result();
		}
		else if (aMediaType == XWC.CERT_LOCATION_SECUREDISK) {
			_securedisk_result();
		} else {
			_deleteCertificate ();
		}
	}
	
	aTarget.focus();
}

function onExportAction(element) {
	var aSubjectRDN,
		aIssuerRDN,
		aCertSerial;
		
	var aMediaID = Math.floor(gSelectedMediaID / 100) * 100;
	var aInputType = __SANDBOX.getInputType(gSelectedMediaID);
	if (aMediaID == XWC.CERT_LOCATION_LOCALSTORAGE &&
			AnySign.mPlatform.aName.indexOf("mac") == 0 &&
			__SANDBOX.browserName == "safari") {
		alert(XWC.S.notsupportexport);
	} else if (aMediaID == XWC.CERT_LOCATION_PKCS11) {
		alert(XWC.S.notsupportexport);
	} else {
		aSubjectRDN = gCertTable.getSelectedSubjectRDN();
		aIssuerRDN = gCertTable.getSelectedIssuerRDN();
		aCertSerial = gCertTable.getSelectedCertSerial();
		if (!aIssuerRDN || !aCertSerial) {
			alert(XWC.S.noselection);
			return;
		}
		
				var aLocalStorageType = null;
		if (aInputType == "lite" || aInputType == "xfs") {
						try {
				var isFileSaverSupported = !!new Blob;
				aLocalStorageType = "blob";
			} catch (e) {
				if (__SANDBOX.browserName == "edge") {
										aLocalStorageType = "flash";
				} else {
					var aElement = document.createElement('a');
					if ('download' in aElement)
						aLocalStorageType = "html5";
					else
						aLocalStorageType = "flash";
				}
			}
			
			if (aLocalStorageType == "flash") {
				if (typeof (swfobject) == "undefined" || typeof (Downloadify) == "undefined") {
					alert(XWC.S.notsupportexport);
					return;
				}
				
				var flashVer = swfobject.getFlashPlayerVersion();
				if(flashVer.major < 10) {
					alert(XWC.S.notsupportexport_flash);
					return;
				}
			}
		}
		
		AnySign.SetUITarget (element);
		element.focus();
		var inputpassModule = __SANDBOX.loadModule("inputpasswd");
		var inputpassDialog = inputpassModule({
			args: {messageType: "certificate",
				   inputType: aInputType},
			onconfirm: function (keyword) {
				var exportModule,
					exportDialog;

								_CB_verifyPassword = function (result)
				{
					inputpassDialog.dispose();

					if (result != 0)
					{
						var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
						if (aErrorObject.code == 0x7005011C) {
							alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
							gCertTable.refresh("");
						} else if (aErrorObject.code == 22000006)
							alert(XWC.S.verifypasserr);
						else
							alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
					}
					else
					{
						exportModule = __SANDBOX.loadModule("export");
						AnySign.SetUITarget (element);
						exportDialog = exportModule({
							args: [ gSelectedMediaID, aSubjectRDN, aIssuerRDN, aCertSerial, keyword, aLocalStorageType ],

							onconfirm: function (result) {
								if (result == 0) {
									alert(XWC.S.exportsuccess);
								} else if (result == 1) {
									alert(XWC.S.exportcomplete);
								} else {
									alert(XWC.S.exportfail);
								}
								element.focus();
								exportDialog.dispose();
							},

							oncancel: function (e) {
								alert(XWC.S.exportcancel);
								element.focus();
								exportDialog.dispose();
							}
						});

						exportDialog.show();
					}
				}

				__SANDBOX.upInterface().verifyPassword (gSelectedMediaID,
														aIssuerRDN,
														aCertSerial,
														keyword,
														_CB_verifyPassword);
			},
			oncancel: function (e) {
				alert(XWC.S.exportcancel);
				element.focus();
				inputpassDialog.dispose();
			}
		});
		inputpassDialog.show();
	}
}

function onImportAction(element) {
	var importDialog;

		_CB_getCertTree = function (result)
	{
		if (__SANDBOX.isFailed(result))
			result = "";

		gCertTable.refresh(XWC.stringToArray(result));

		element.focus();
		importDialog.dispose();
	}
		_CB_getMediaList = function ()
	{
		__SANDBOX.upInterface().getCertTree(gSelectedMediaID, 2, 0, 5, "", "", _CB_getCertTree);
	}
	
	importModule = __SANDBOX.loadModule("import");
	AnySign.SetUITarget (element);
	importDialog = importModule({
		args: { selectedMediaID: gSelectedMediaID, providerName: gProviderName, errCallback: gErrCallback },

		onconfirm: function (result) {
			if (result == 0)
			{
				alert(XWC.S.importsuccess);

								var aMediaType = Math.floor(parseInt(gSelectedMediaID, 10) / 100) * 100;
				__SANDBOX.upInterface().getMediaList(aMediaType , 0, 1, _CB_getMediaList);
			}
			else
			{
				alert(XWC.S.importfail);
				importDialog.dispose();
			}
		},

		oncancel: function (e) {
			alert(XWC.S.importcancel);
			element.focus();
			importDialog.dispose();
		}
	});

	importDialog.show();
}

function onImportHTML5Action(e) {
	var aMediaID = Math.floor(gSelectedMediaID / 100) * 100;
	var aInputType = __SANDBOX.getInputType(gSelectedMediaID);
	
	var aIsSavePFX = false;
	var IsSavePFX= function () {
		aIsSavePFX = !aIsSavePFX;	
	}

	var openPasswdDialog = function (pfx) {
		var _pfx = pfx;
		var inputpassModule = __SANDBOX.loadModule("inputpasswd");
		var inputpassDialog = inputpassModule({
			args: {messageType: "certificate",
				   descType: "copy",
				   inputType: aInputType,
				   func: IsSavePFX,
				   isSave: true},
			onconfirm: function (aResult) {
				inputpassDialog.dispose();
				
				var _cb_importCertFromPFX = function (aPWCheck) {
					if (aPWCheck == 0) {
						var _cb_getCertTree = function (aCertList) {
							if (aCertList != "") {
								aCertList = XWC.stringToArray(aCertList);
								gCertTable.refresh(aCertList);
							}
							alert(XWC.S.importsuccess);
						}
						
						var _cb_getMediaList = function () {
							__SANDBOX.upInterface().getCertTree(gSelectedMediaID, 2, 0, 5, "", "", _cb_getCertTree);
						}
						
						__SANDBOX.upInterface().getMediaList (aMediaID, 0, 1, _cb_getMediaList);
						
					} else if (aPWCheck == 1) {
						alert(XWC.S.importcancel);
					} else {
						var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
						if (aErrorObject.code == 0x7005011C) {
							alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
							gCertTable.refresh("");
						} else if (aErrorObject.code == 22000006) {
							alert(XWC.S.selectKeyworderror);
						} else {
							alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
						}
					}
				}
				
				__SANDBOX.upInterface().importCertFromPFX (gSelectedMediaID,
														   null,
														   aResult,
														   _pfx,
														   null, null, null, null, null,
														   0,
														   _cb_importCertFromPFX);
				
			},
			oncancel: function () {
				alert(XWC.S.importcancel);
				inputpassDialog.dispose();
			}
		});

		inputpassDialog.show();
	}
	
	var _pfxdialogOpen = function () {
		var pfxModule = __SANDBOX.loadModule("pfxdialog");
		var pfxDialog = pfxModule({
			onconfirm: function (aResult) {
				pfxDialog.dispose();
				openPasswdDialog(aResult);
			},
			oncancel: function () {
				alert(XWC.S.importcancel);
				pfxDialog.dispose();
			}
		});
		pfxDialog.show();
	}
	_pfxdialogOpen();

}

function onImportExportButtonClick(e) {
	e = e || window.event;
	aTarget = e.target || e.srcElement;

	gSelectedButton = 11;
	
	var aExportEnable = true;
	var aImportEnable = true;
	
	var aMediaType = Math.floor(parseInt(gSelectedMediaID, 10) / 100) * 100;
	
		if (aMediaType == XWC.CERT_LOCATION_ICCARD || aMediaType == XWC.CERT_LOCATION_KEPCOICCARD || aMediaType == XWC.CERT_LOCATION_YESSIGNM)
	{
		alert(XWC.S.notsupportexportimport);
		return;
	}
	
		if ((aMediaType == XWC.CERT_LOCATION_REMOVABLE && aMediaType == gSelectedMediaID) ||
		(aMediaType == XWC.CERT_LOCATION_PKCS11 && aMediaType == gSelectedMediaID) ||
		(aMediaType == XWC.CERT_LOCATION_SECUREDISK && aMediaType == gSelectedMediaID))
	{
		alert(XWC.S.noselection_media);
		return;
	}
	
		if (aMediaType == XWC.CERT_LOCATION_PKCS11 || aMediaType == XWC.CERT_LOCATION_SECUREDISK)
		aExportEnable = false;
	
	AnySign.SetUITarget(aTarget);
	var loadModule = __SANDBOX.loadModule("selectonrbg");
	var selectonrbg = loadModule({
		args: {dialogType: "importexport", exportEnable: aExportEnable, importEnable: aImportEnable},
		onconfirm: function(result){
			selectonrbg.dispose();
			if (result == "onExportAction") {
				onExportAction(aTarget);
			} else if (result == "onImportAction") {
				if (AnySign.mAnySignEnable)
					onImportAction(aTarget);
				else
					onImportHTML5Action(aTarget);
			}
		},
		oncancel: function(e){
			selectonrbg.dispose();
		}
	});
	selectonrbg.show();
}

function onViewVerifyButtonClick(e) {
	var	aSelectedInfo,
		aCertInfo,
		aCertState,
		aCertClass,
		aCertVerifyMsg,
		target;

	e = e || window.event;
	target = e.target || e.srcElement;

	aSelectedInfo = getSelectedInfoObject (gTabView.getSelectedIndex(), true);

	if(aSelectedInfo == undefined) {
		target.focus();
		return;
	}
	
	gSelectedButton = 12;
		_CB_verifyCert = function (result)
	{
		aCertState = result;
		aCertClass = aSelectedInfo.certClass;
		aCertVerifyMsg = __SANDBOX.upInterface().setErrCodeAndMsg().msg;

		viewverifyModule = __SANDBOX.loadModule("viewverify");
		AnySign.SetUITarget (target);
		viewverifyDialog = viewverifyModule({
			onconfirm: function () { 
				target.focus();
				viewverifyDialog.dispose(); 
			},
			oncancel: function () {
				target.focus();
				viewverifyDialog.dispose(); 
			},
			args: [ aCertState, aCertInfo, aCertClass, aCertVerifyMsg ]
		});
		viewverifyDialog.show();
	}

		_CB_getCertTree = function (result)
	{
		if (__SANDBOX.isFailed(result, gErrCallback)) {
			var _CB_getMediaList = function () {
				loadTableValues (gTabView.getSelectedIndex());
			}
			__SANDBOX.upInterface().getMediaList(Math.floor(parseInt(gSelectedMediaID, 10) / 100) * 100 , 0, 1, _CB_getMediaList);
			return;
		}
		
		aCertInfo = result.split("$");
		
		if (gSelectedMediaID == XWC.CERT_LOCATION_XECUREFREESIGN) {
			_CB_verifyCert(aSelectedInfo.certStatus);
		} else {
			__SANDBOX.upInterface().verifyCert(aSelectedInfo.mediaID, aSelectedInfo.certType, aSelectedInfo.issuerRDN, aSelectedInfo.certSerial, 0, _CB_verifyCert);
		}
	}
	
	__SANDBOX.upInterface().getCertTree(aSelectedInfo.mediaID, aSelectedInfo.certType, 24, 0, aSelectedInfo.issuerRDN, aSelectedInfo.certSerial, _CB_getCertTree);
}

function onChangePassButtonClick(e) {
	var aSubjectRDN,
		aIssuerRDN,
		aCertSerial,
		changepasswdModule,
		changepasswdDialog,
		target,
		verifyhsmModule,
		verifyvidDialog;

	e = e || window.event;
	target = e.target || e.srcElement;

	gSelectedButton = 13;

	aSubjectRDN = gCertTable.getSelectedSubjectRDN();
	aIssuerRDN = gCertTable.getSelectedIssuerRDN();
	aCertSerial = gCertTable.getSelectedCertSerial();
	if (!aIssuerRDN || !aCertSerial) {
		alert(XWC.S.noselection);
		target.focus();
		return;
	}

	changepasswdModule = __SANDBOX.loadModule("changepasswd");
	AnySign.SetUITarget (target);
	changepasswdDialog = changepasswdModule({
		args: { selectedMediaID: gSelectedMediaID,
				providerName: gProviderName,
				subjectRDN: aSubjectRDN,
				issuerRDN: aIssuerRDN,
				certSerial: aCertSerial,
				errCallback: gErrCallback },
		onconfirm: function (result, errmsg) {
			switch (result) {
			case 0:
				alert(XWC.S.changeok);
				break;
			case -1:
				alert(XWC.S.changefail);
				break;
			case -2:
				if (Math.floor(gSelectedMediaID / 100) * 100 == XWC.CERT_LOCATION_SECUREDISK) {
					alert(errmsg.replace(/\\n/g, '\t\n'));
				} else {
					alert(XWC.S.verifypasserr);
				}
				break;
			}
			target.focus();
			changepasswdDialog.dispose();
		},
		oncancel: function () {
			alert(XWC.S.changecancel);
			target.focus();
			changepasswdDialog.dispose();
		}
	});
	changepasswdDialog.show();
}

function onOwnerVerifyButtonClick(e) {
	var aMediaType,
		aIssuerRDN,
		aCertSerial,
		aPasswd = "",
		aTarget,
		aGuideModule,
		aGuideDialog;

	e = e || window.event;
	aTarget = e.target || e.srcElement;

	gSelectedButton = 14;
	
	aMediaType = Math.floor(gSelectedMediaID / 100) * 100;

	aIssuerRDN = gCertTable.getSelectedIssuerRDN();
	aCertSerial = gCertTable.getSelectedCertSerial();

	if (!aIssuerRDN || !aCertSerial) {
		alert(XWC.S.noselection);
		aTarget.focus();
		return;
	}
		_CB_loginStoreToken = function (result)
	{
		aGuideDialog.dispose ();

		if (result != 0)
		{
			var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			alert(aErrorObject.msg.replace(/\\n/g, '\t\n'));
		}
		else
		{
			_open_inputpasswd();
		}
	}
		_CB_loginPKCS11FromIndex = function (result)
	{
		aGuideDialog.dispose();
		if (result != 0) {
			var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
		}
		else
			_open_verifyvid();
	}
		_CB_verifyPassword = function (result)
	{
		if (result != 0)
		{
			var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			if (aErrorObject.code == 22000006)
				alert(XWC.S.verifypasserr);
			else
				alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
		}
		else
		{
			_open_verifyvid();
		}
	}
		_CB_verifyCertOwner = function (result)
	{
		if (aMediaType == XWC.CERT_LOCATION_ICCARD || aMediaType == XWC.CERT_LOCATION_KEPCOICCARD)
			aGuideDialog.dispose();

		if (result == 0) {
			alert(XWC.S.verifyvid);
		}
		else
		{
			var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			if (aErrorObject.code == 22000002) {
				alert(XWC.S.verifyidnerr);
			} else {
				alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
			}
		}

		var _cb_logoutStoreToken = function () {};

		if (aMediaType == XWC.CERT_LOCATION_ICCARD || aMediaType == XWC.CERT_LOCATION_KEPCOICCARD)
			__SANDBOX.upInterface().logoutStoreToken(gSelectedMediaID, _cb_logoutStoreToken);

		verifyvidDialog.dispose();
		aTarget.focus();
	}
	
	_open_inputpasswd = function () {
		var inputpassModule,
			inputpassDialog;
			
		var aInputType = __SANDBOX.getInputType(gSelectedMediaID);
		
		inputpassModule = __SANDBOX.loadModule("inputpasswd");
		AnySign.SetUITarget (aTarget);
		inputpassDialog = inputpassModule({
			args: {messageType: "certificate",
				   inputType: aInputType},
			onconfirm: function (result) {
				aPasswd = result;
				inputpassDialog.dispose();

				__SANDBOX.upInterface().verifyPassword(gSelectedMediaID, aIssuerRDN, aCertSerial, aPasswd, _CB_verifyPassword);
			},
			oncancel: function (e) {
				alert(XWC.S.verifycancel);
				aTarget.focus();
				inputpassDialog.dispose();
			}
		});
		inputpassDialog.show();
	};

	_open_verifyhsm = function () {
		var verifyhsmModule,
			verifyhsmDialog;

		verifyhsmModule = __SANDBOX.loadModule("verifyhsm");
		AnySign.SetUITarget (aTarget);
		verifyhsmDialog = verifyhsmModule({
			args: {messageType: "ownerverify" },
			onconfirm: function (pin) {
				verifyhsmDialog.dispose();

				aGuideModule = __SANDBOX.loadModule("guidewindow");
				aGuideDialog = aGuideModule({
					type: "loading",
					args: "",
					onconfirm: "",
					oncancel: function () {aGuideDialog.dispose();}
				});

				__SANDBOX.upInterface().loginPKCS11FromIndex(gSelectedMediaID, pin, _CB_loginPKCS11FromIndex);

				aGuideDialog.show();
			},
			oncancel: function (e) {
				alert(XWC.S.verifycancel);
				verifyhsmDialog.dispose();
			}
		});
		verifyhsmDialog.show();
	}

	_open_verifyvid = function () {
		var aInputType = __SANDBOX.getInputType(gSelectedMediaID);
		
		verifyvidModule = __SANDBOX.loadModule("verifyvid");
		AnySign.SetUITarget (aTarget);
		verifyvidDialog = verifyvidModule({
			onconfirm: function (result) {
				if (aMediaType == XWC.CERT_LOCATION_ICCARD || aMediaType == XWC.CERT_LOCATION_KEPCOICCARD)
				{
					aGuideModule = __SANDBOX.loadModule("guidewindow");
					aGuideDialog = aGuideModule({
						type: "loading",
						args: "",
						onconfirm: "",
						oncancel: function () {aGuideDialog.dispose();}
					});
					aGuideDialog.show();
				}
				
				__SANDBOX.upInterface().verifyCertOwner (gSelectedMediaID,
														 aIssuerRDN,
														 aCertSerial,
														 aPasswd,
														 result,
														 _CB_verifyCertOwner);
			},
			oncancel: function (e) {
				alert(XWC.S.verifycancel);
				aTarget.focus();
				verifyvidDialog.dispose();
			},
			args: {inputType: aInputType}
		});
		verifyvidDialog.show();
	}

	_open_iccard = function() {
		var aICCardType;
		if (aMediaType == XWC.CERT_LOCATION_KEPCOICCARD)
			aICCardType = "kepco";
		else
			aICCardType = "iccard";
		
		var iccardModule = __SANDBOX.loadModule("iccard");
		AnySign.SetUITarget (aTarget);
		var iccardDialog = iccardModule({
			type: aICCardType,
			args: {},
			onconfirm: function (aPin) {
				iccardDialog.dispose ();

				aGuideModule = __SANDBOX.loadModule("guidewindow");
				aGuideDialog = aGuideModule({
					type: "loading",
					args: "",
					onconfirm: "",
					oncancel: function () {aGuideDialog.dispose();}
				});

				__SANDBOX.upInterface().loginStoreToken(gSelectedMediaID, aPin, 0, _CB_loginStoreToken);

				aGuideDialog.show();
			},
			oncancel: function () {
				iccardDialog.dispose();
			}
		});
		iccardDialog.show();
	};

	if (aMediaType == XWC.CERT_LOCATION_PKCS11) {
		_open_verifyhsm();
	} else if (aMediaType == XWC.CERT_LOCATION_ICCARD || aMediaType == XWC.CERT_LOCATION_KEPCOICCARD) {
		_open_iccard();
	} else {
		_open_inputpasswd();
	}
}

function onRootVerifyButtonClick(e) {
	var aSubjectRDN,
		aIssuerRDN,
		aCertSerial,
		target;

	e = e || window.event;
	target = e.target || e.srcElement;

	aSubjectRDN = gCertTable.getSelectedSubjectRDN();
	aIssuerRDN = gCertTable.getSelectedIssuerRDN();
	aCertSerial = gCertTable.getSelectedCertSerial();

	if (!aIssuerRDN || !aCertSerial) {
		alert(XWC.S.noselection);
		target.focus();
		return;
	}

		_CB_verifyRootCaCert = function (result)
	{
		var aLDAPURL;
		var aHash = result;

		for (var i = 0; i < gRootCACertList.length; i++)
		{
			var aCertInfo = [];
			aCertInfo = gRootCACertList[i].split('$');
			if (aCertInfo[1] == aSubjectRDN)
			{
				aLDAPURL = aCertInfo[0] + "/" + aCertInfo[1];
				break;
			}
		}

		rootverifyModule = __SANDBOX.loadModule("rootverify");
		AnySign.SetUITarget (target);
		rootverifyDialog = rootverifyModule ({
			args: { subjectRDN: aSubjectRDN,
					issuerRDN: aIssuerRDN,
					hash: aHash,
					ldapURL: aLDAPURL,
					dialogType: "confirm"},
			onconfirm: function () { 
				target.focus();
				rootverifyDialog.dispose(); 
			},
			oncancel: function () 
			{
				loadTableValues(2);
				target.focus();
				rootverifyDialog.dispose(); 
			}
		});
		rootverifyDialog.show();
	}
	
	__SANDBOX.upInterface().verifyRootCaCert(1, aIssuerRDN, aCertSerial, _CB_verifyRootCaCert);
}

function onInstallCertButtonClick(e) {
	var aCertInfo = [],
		aLDAPURL,
		aSubjectRDN,
		aIssuerRDN,
		rootverifyModule,
		rootverifyDialog,
		target,
		aGuideModule,
		aGuideDialog;

	try {
		e = e || window.event;
		target = e.target || e.srcElement;
	}
	catch (aException) {}

	aCertInfo = gRootCACertList[gRootCertNum].split("$");
	aLDAPURL = aCertInfo[0] + "/" + aCertInfo[1];
	aSubjectRDN = aCertInfo[1].substring(3, aCertInfo[1].indexOf(','));
	aIssuerRDN = aCertInfo[1];

		_CB_getMediaList = function ()
	{
		loadTableValues (2);
		if (target) target.focus();
	}

		_CB_installCertificateByLDAP = function ()
	{
		aGuideDialog.dispose();
		_nextStep();
	}
	_nextStep = function ()
	{
		gRootCertNum++;
		rootverifyDialog.dispose();

		if(gRootCertNum < gRootCACertList.length)
		{
			onInstallCertButtonClick(e);
		}
		else {
			gRootCertNum = 0;

			__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_HARD, 0, 1, _CB_getMediaList);
		}
	}
		_CB_verifyRootCaCertByLDAP = function (result)
	{
		rootverifyModule = __SANDBOX.loadModule("rootverify");
		AnySign.SetUITarget (target);
		rootverifyDialog = rootverifyModule ({
			args: { subjectRDN: aSubjectRDN,
					hash: result,
					ldapURL: aLDAPURL,
					dialogType: "alert" },
			onconfirm: function () 
			{
				installCert (1, aLDAPURL, aIssuerRDN);
			},
			oncancel: function () 
			{
				_nextStep();
			}
		});

		rootverifyDialog.show();
	}
		
	function installCert(result, ldapURL, issuerRDN){
		
		aGuideModule = __SANDBOX.loadModule("guidewindow");
		aGuideDialog = aGuideModule({
			type: "loading",
			args: "",
			onconfirm: "",
			oncancel: function () {aGuideDialog.dispose();}
		});
		
		if (result) {
			__SANDBOX.upInterface().installCertificateByLDAP(ldapURL, issuerRDN, _CB_installCertificateByLDAP);
		}
		
		aGuideDialog.show();
	}

	__SANDBOX.upInterface().verifyRootCaCertByLDAP(aLDAPURL, _CB_verifyRootCaCertByLDAP);
}

function setButtonManager (type)
{
	var index,
		element;

	switch (type)
	{
		case "disabled":
			for (index = 0; index < gButtonList.length; index++)
			{
				element = document.getElementById(gButtonList[index]);
				if (element != null) {
					gCurrentStateList[index] = element.disabled;
					if (index < gMaxButton && index != gSelectedButton-1)
						gMediaRadio.setDisabled (element, true);
					else
						element.disabled = true;
				}
			}
			break;
		case "enabled":
			for (index = 0; index < gCurrentStateList.length; index++)
			{
				element = document.getElementById(gButtonList[index]);
				if (element != null) {
					if (index < gMaxButton && index != gSelectedButton-1)
						gMediaRadio.setDisabled (element, gCurrentStateList[index]);
					else
						element.disabled = gCurrentStateList[index];
				}
			}
			gCurrentStateList = [];
			break;
	}
}

function onMediaLeft() {
	if (__24.style.display == "none") {
		__24.style.display = "";
		__25.style.display = "";
		__26.style.display = "";
		__27.style.display = "";
		__28.style.display = "";

		if (gMediaLength > 6) {
			__29.style.display = "none";
			__30.style.display = "none";
			__31.style.display = "none";
			__32.style.display = "none";
			__33.style.display = "none";
		}

						__37.getElementsByTagName("span")[0].className = "xwup-ico-arrow-left-disabled";
		__35.getElementsByTagName("span")[0].className = "xwup-ico-arrow-right";
	}
}

function onMediaRight() {
	if (__29.style.display == "none") {
		__24.style.display = "none";
		__25.style.display = "none";
		__26.style.display = "none";
		__27.style.display = "none";
		__28.style.display = "none";

		if (gMediaLength > 6) {
			__29.style.display = "";
			__30.style.display = "";
			__31.style.display = "";
			__32.style.display = "";
			__33.style.display = "";
		}
		
						__37.getElementsByTagName("span")[0].className = "xwup-ico-arrow-left";
		__35.getElementsByTagName("span")[0].className = "xwup-ico-arrow-right-disabled";
	}
}

function checkAnySignLoad() {
	if (!AnySign.mAnySignLoad)
		return false;
	
	if (AnySign.mExtensionSetting.mExternalCallback.func &&
		AnySign.mExtensionSetting.mExternalCallback.result != 0)
		return false;
		
	return true;
}

function onCheckMedia(index) {
	var aSelectedTabIndex = index;
	var _refreshMedia = function () {
		if (aSelectedTabIndex) {
			gTabView.setSelectedIndex(aSelectedTabIndex);
			loadTabValues(aSelectedTabIndex);
			aSelectedTabIndex = "";
		}
		else {
			if (gSelectedButton == 1)
				onHddButtonClick(gEvent);
			else if (gSelectedButton == 2)
				onRemovableButtonClick(gEvent);
			else if (gSelectedButton == 3)
				onSaveTokenButtonClick(gEvent);
			else if (gSelectedButton == 4)
				onHSMButtonClick(gEvent);
			else if (gSelectedButton == 5)
				onMobileButtonClick(gEvent);
			else if (gSelectedButton == 6)
				onSecureDiskButtonClick(gEvent)
			else if (gSelectedButton == 9)
				onCopyButtonClick(gEvent);
		}
	}
	
	var _CB_external = function (aResult) {
		if (aResult == undefined || aResult == 0) {
			AnySign.mExtensionSetting.mExternalCallback.result = 0;
			__SANDBOX.setConvertTable(_refreshMedia);
		} else {
					}
	}
	
	var _Func_external = function (aResult) {
		if (AnySign.mExtensionSetting.mExternalCallback.func &&
			AnySign.mExtensionSetting.mExternalCallback.result != 0)
			AnySign.mExtensionSetting.mExternalCallback.func(_CB_external);
		else
			_CB_external(0);
	}

		if (AnySign.mExtensionSetting.mInstallCheck_State == "ANYSIGN4PC_NEED_INSTALL") {
		var selectResult = confirm(XWC.S.anysign4pc_update);
		if (selectResult)
			location.href = AnySign.mPlatform.aInstallPage;
		return;
	}
	
	if (!AnySign.mAnySignLoad) {
		AnySign.mAnySignEnable = true;
		AnySign.mExtensionSetting.mImgIntervalError = false;
		AnySign.mExtensionSetting.mInstallCheck_Level = 1;
		AnySign.mExtensionSetting.mLoadCallback.func = _Func_external;
		AnySign.mExtensionSetting.mLoadCallback.param = "";
		
		AnySign.StartAnySign();
	} else {
		_Func_external();
	}
}

var __1 = XWC.UI.createElement('DIV');
__1.setAttribute('role', 'dialog', 0);
__1.style.width = '500px';
var __2 = XWC.UI.createElement('DIV');
__2.setAttribute('title', XWC.S.title, 0);
__2.setAttribute('id', 'xwup_title', 0);
__2.className = 'xwup-title';
var __3 = XWC.UI.createElement('H3');
__3.appendChild(document.createTextNode(XWC.S.title));
__2.appendChild(__3);
var __4 = XWC.UI.createElement('TEXTAREA');
__4.setAttribute('tabindex', '3', 0);
__4.setAttribute('title', XWC.S.xvvcursor_guide, 0);
__4.setAttribute('id', 'xwup_xvvcursor_disabled', 0);
__4.className = 'blank0';
__4.setAttribute('disabled', 'disabled', 0);
__2.appendChild(__4);
__1.appendChild(__2);
var __5 = XWC.UI.createElement('DIV');
__5.setAttribute('id', 'xwup_header', 0);
__5.className = 'blank0';
__1.appendChild(__5);
var __6 = XWC.UI.createElement('DIV');
__6.setAttribute('id', 'xwup_body', 0);
__6.className = 'xwup-body';
var __7 = XWC.UI.createElement('DIV');
__7.className = 'xwup-tab-list';
var __8 = XWC.UI.createElement('UL');
__8.setAttribute('id', 'xwup_certmanager_tablist', 0);
var __9 = XWC.UI.createElement('LI');
__9.setAttribute('tabindex', '3', 0);
__9.setAttribute('id', 'xwup_li1', 0);
__9.className = 'tmenu selected';
var __10 = XWC.UI.createElement('A');
__10.setAttribute('href', 'javascript:;', 0);
__10.appendChild(document.createTextNode(XWC.S.usertab));
__9.appendChild(__10);
__8.appendChild(__9);
var __11 = XWC.UI.createElement('LI');
__11.setAttribute('tabindex', '3', 0);
__11.setAttribute('id', 'xwup_li2', 0);
__11.className = 'tmenu2';
var __12 = XWC.UI.createElement('A');
__12.setAttribute('href', 'javascript:;', 0);
__12.appendChild(document.createTextNode(XWC.S.pubcatab));
__11.appendChild(__12);
__8.appendChild(__11);
var __13 = XWC.UI.createElement('LI');
__13.setAttribute('tabindex', '3', 0);
__13.setAttribute('id', 'xwup_li3', 0);
__13.className = 'tmenu3';
var __14 = XWC.UI.createElement('A');
__14.setAttribute('href', 'javascript:;', 0);
__14.appendChild(document.createTextNode(XWC.S.roottab));
__13.appendChild(__14);
__8.appendChild(__13);
var __15 = XWC.UI.createElement('LI');
__15.setAttribute('tabindex', '3', 0);
__15.setAttribute('id', 'xwup_li4', 0);
__15.className = 'tmenu4';
var __16 = XWC.UI.createElement('A');
__16.setAttribute('href', 'javascript:;', 0);
__16.appendChild(document.createTextNode(XWC.S.pricatab));
__15.appendChild(__16);
__8.appendChild(__15);
__7.appendChild(__8);
__6.appendChild(__7);
var __17 = XWC.UI.createElement('DIV');
__17.className = 'xwup-tab-view';
var __18 = XWC.UI.createElement('FIELDSET');
__18.setAttribute('role', 'radiogroup', 0);
__18.className = 'xwup-location-item';
var __19 = XWC.UI.createElement('LEGEND');
if (__SANDBOX.IEVersion == 8) {
__19.style.display = 'block';
}
__19.setAttribute('id', 'xwup_legend_location_item', 0);
__19.className = 'xwup-legend';
__19.appendChild(document.createTextNode(XWC.S.media_location));
__18.appendChild(__19);
var __20 = XWC.UI.createElement('TABLE');
__20.setAttribute('cellpadding', '0', 0);
__20.setAttribute('cellspacing', '0', 0);
__20.className = 'xwup-cert-position2';
var __21 = XWC.UI.createElement('CAPTION');
__21.appendChild(document.createTextNode(XWC.S.media_location));
__20.appendChild(__21);
var __22 = XWC.UI.createElement('TBODY');
var __23 = XWC.UI.createElement('TR');
var __24 = XWC.UI.createElement('TD');
__24.setAttribute('id', 'xwup_location_1', 0);
__24.style.display = 'none';
__23.appendChild(__24);
var __25 = XWC.UI.createElement('TD');
__25.setAttribute('id', 'xwup_location_2', 0);
__25.style.display = 'none';
__23.appendChild(__25);
var __26 = XWC.UI.createElement('TD');
__26.setAttribute('id', 'xwup_location_3', 0);
__26.style.display = 'none';
__23.appendChild(__26);
var __27 = XWC.UI.createElement('TD');
__27.setAttribute('id', 'xwup_location_4', 0);
__27.style.display = 'none';
__23.appendChild(__27);
var __28 = XWC.UI.createElement('TD');
__28.setAttribute('id', 'xwup_location_5', 0);
__28.style.display = 'none';
__23.appendChild(__28);
var __29 = XWC.UI.createElement('TD');
__29.setAttribute('id', 'xwup_location_6', 0);
__29.style.display = 'none';
__23.appendChild(__29);
var __30 = XWC.UI.createElement('TD');
__30.setAttribute('id', 'xwup_location_7', 0);
__30.style.display = 'none';
__23.appendChild(__30);
var __31 = XWC.UI.createElement('TD');
__31.setAttribute('id', 'xwup_location_8', 0);
__31.style.display = 'none';
__23.appendChild(__31);
var __32 = XWC.UI.createElement('TD');
__32.setAttribute('id', 'xwup_location_9', 0);
__32.style.display = 'none';
__23.appendChild(__32);
var __33 = XWC.UI.createElement('TD');
__33.setAttribute('id', 'xwup_location_10', 0);
__33.style.display = 'none';
__23.appendChild(__33);
var __34 = XWC.UI.createElement('TD');
__34.setAttribute('id', 'xwup_location_right', 0);
__34.style.display = 'none';
var __35 = XWC.UI.createElement('BUTTON');
__35.setAttribute('tabindex', '3', 0);
__35.setAttribute('type', 'button', 0);
__35.setAttribute('id', 'xwup_media_right', 0);
__35.style.width = '18px';
__35.style.height = '29px';
__35.style.border = '0px';
__35.style.margin = '1px';
__35.style.padding = '3px';
__35.setAttribute('title', XWC.S.media_right_title, 0);
__35.onclick = function(event) {onMediaRight(this);};
var __36 = XWC.UI.createElement('SPAN');
__36.style.height = '9px';
__36.className = 'xwup-ico-arrow-right';
__35.appendChild(__36);
__34.appendChild(__35);
var __37 = XWC.UI.createElement('BUTTON');
__37.setAttribute('tabindex', '3', 0);
__37.setAttribute('type', 'button', 0);
__37.setAttribute('id', 'xwup_media_left', 0);
__37.style.width = '18px';
__37.style.height = '29px';
__37.style.border = '0px';
__37.style.margin = '1px';
__37.style.padding = '3px';
__37.setAttribute('title', XWC.S.media_left_title, 0);
__37.onclick = function(event) {onMediaLeft(this);};
var __38 = XWC.UI.createElement('SPAN');
__38.style.height = '9px';
__38.className = 'xwup-ico-arrow-left-disabled';
__37.appendChild(__38);
__34.appendChild(__37);
__23.appendChild(__34);
var __39 = XWC.UI.createElement('BUTTON');
__39.setAttribute('role', 'radio', 0);
__39.setAttribute('aria-checked', 'false', 0);
__39.setAttribute('type', 'button', 0);
__39.setAttribute('tabindex', '3', 0);
__39.style.display = 'none';
__39.setAttribute('id', 'xwup_media_localstorage', 0);
__39.onclick = function(event) {onLocalStorageButtonClick(this);};
__39.setAttribute('title', XWC.S.media_localstorage, 0);
var __40 = XWC.UI.createElement('SPAN');
__40.className = 'xwup-ico-localstorage';
__39.appendChild(__40);
var __41 = XWC.UI.createElement('SPAN');
__41.className = 'xwup-rbg-text';
__41.appendChild(document.createTextNode(XWC.S.media_localstorage));
__39.appendChild(__41);
__23.appendChild(__39);
var __42 = XWC.UI.createElement('BUTTON');
__42.setAttribute('role', 'radio', 0);
__42.setAttribute('aria-checked', 'false', 0);
__42.setAttribute('type', 'button', 0);
__42.setAttribute('tabindex', '3', 0);
__42.style.display = 'none';
__42.setAttribute('id', 'xwup_media_hdd', 0);
__42.onclick = function(event) {onHddButtonClick(this);};
__42.setAttribute('title', XWC.S.media_hdd, 0);
var __43 = XWC.UI.createElement('SPAN');
__43.className = 'xwup-ico-hdd';
__42.appendChild(__43);
var __44 = XWC.UI.createElement('SPAN');
__44.className = 'xwup-rbg-text';
__44.appendChild(document.createTextNode(XWC.S.media_hdd));
__42.appendChild(__44);
__23.appendChild(__42);
var __45 = XWC.UI.createElement('BUTTON');
__45.setAttribute('role', 'radio', 0);
__45.setAttribute('aria-checked', 'false', 0);
__45.setAttribute('type', 'button', 0);
__45.setAttribute('tabindex', '3', 0);
__45.style.display = 'none';
__45.setAttribute('id', 'xwup_media_removable', 0);
__45.onclick = function(event) {onRemovableButtonClick(this);};
__45.setAttribute('title', XWC.S.media_removable, 0);
var __46 = XWC.UI.createElement('SPAN');
__46.className = 'xwup-ico-removable';
__45.appendChild(__46);
var __47 = XWC.UI.createElement('SPAN');
__47.className = 'xwup-rbg-text';
__47.appendChild(document.createTextNode(XWC.S.media_removable));
__45.appendChild(__47);
__23.appendChild(__45);
var __48 = XWC.UI.createElement('BUTTON');
__48.setAttribute('role', 'radio', 0);
__48.setAttribute('aria-checked', 'false', 0);
__48.setAttribute('type', 'button', 0);
__48.setAttribute('tabindex', '3', 0);
__48.style.display = 'none';
__48.setAttribute('id', 'xwup_media_savetoken', 0);
__48.onclick = function(event) {onSaveTokenButtonClick(this);};
__48.setAttribute('title', XWC.S.media_savetoken, 0);
var __49 = XWC.UI.createElement('SPAN');
__49.className = 'xwup-ico-savetoken';
__48.appendChild(__49);
var __50 = XWC.UI.createElement('SPAN');
__50.className = 'xwup-rbg-text';
__50.appendChild(document.createTextNode(XWC.S.media_savetoken));
__48.appendChild(__50);
__23.appendChild(__48);
var __51 = XWC.UI.createElement('BUTTON');
__51.setAttribute('role', 'radio', 0);
__51.setAttribute('aria-checked', 'false', 0);
__51.setAttribute('type', 'button', 0);
__51.setAttribute('tabindex', '3', 0);
__51.style.display = 'none';
__51.setAttribute('id', 'xwup_media_pkcs11', 0);
__51.onclick = function(event) {onHSMButtonClick(this);};
__51.setAttribute('title', XWC.S.open_layer + XWC.S.media_pkcs11, 0);
var __52 = XWC.UI.createElement('SPAN');
__52.className = 'xwup-ico-pkcs11';
__51.appendChild(__52);
var __53 = XWC.UI.createElement('SPAN');
__53.className = 'xwup-rbg-text';
__53.appendChild(document.createTextNode(XWC.S.media_pkcs11));
__51.appendChild(__53);
__23.appendChild(__51);
var __54 = XWC.UI.createElement('BUTTON');
__54.setAttribute('role', 'radio', 0);
__54.setAttribute('aria-checked', 'false', 0);
__54.setAttribute('type', 'button', 0);
__54.setAttribute('tabindex', '3', 0);
__54.style.display = 'none';
__54.setAttribute('id', 'xwup_media_mobile', 0);
__54.onclick = function(event) {onMobileButtonClick(this);};
__54.setAttribute('title', XWC.S.media_mobile, 0);
var __55 = XWC.UI.createElement('SPAN');
__55.className = 'xwup-ico-mobile';
__54.appendChild(__55);
var __56 = XWC.UI.createElement('SPAN');
__56.className = 'xwup-rbg-text';
__56.appendChild(document.createTextNode(XWC.S.media_mobile));
__54.appendChild(__56);
__23.appendChild(__54);
var __57 = XWC.UI.createElement('BUTTON');
__57.setAttribute('role', 'radio', 0);
__57.setAttribute('aria-checked', 'false', 0);
__57.setAttribute('type', 'button', 0);
__57.setAttribute('tabindex', '3', 0);
__57.style.display = 'none';
__57.setAttribute('id', 'xwup_media_securedisk', 0);
__57.onclick = function(event) {onSecureDiskButtonClick(this);};
__57.setAttribute('title', XWC.S.media_securedisk, 0);
var __58 = XWC.UI.createElement('SPAN');
__58.className = 'xwup-ico-securedisk';
__57.appendChild(__58);
var __59 = XWC.UI.createElement('SPAN');
__59.className = 'xwup-rbg-text';
__59.appendChild(document.createTextNode(XWC.S.media_securedisk));
__57.appendChild(__59);
__23.appendChild(__57);
var __60 = XWC.UI.createElement('BUTTON');
__60.setAttribute('role', 'radio', 0);
__60.setAttribute('aria-checked', 'false', 0);
__60.setAttribute('type', 'button', 0);
__60.setAttribute('tabindex', '3', 0);
__60.style.display = 'none';
__60.setAttribute('id', 'xwup_media_xfs', 0);
__60.onclick = function(event) {onXecureFreeSignButtonClick(this);};
__60.setAttribute('title', XWC.S.media_xfs, 0);
var __61 = XWC.UI.createElement('SPAN');
__61.className = 'xwup-ico-xfs';
__60.appendChild(__61);
var __62 = XWC.UI.createElement('SPAN');
__62.className = 'xwup-rbg-text';
__62.appendChild(document.createTextNode(XWC.S.media_xfs));
__60.appendChild(__62);
__23.appendChild(__60);
__22.appendChild(__23);
__20.appendChild(__22);
__18.appendChild(__20);
__17.appendChild(__18);
var __63 = XWC.UI.createElement('DIV');
__63.setAttribute('tabindex', '3', 0);
__63.setAttribute('id', 'xwup_cert_table', 0);
__63.setAttribute('title', XWC.S.certtable, 0);
__63.setAttribute('role', 'application', 0);
__63.className = 'xwup-tableview';
__63.style.width = '424px';
var __64 = XWC.UI.createElement('TABLE');
__64.setAttribute('cellpadding', '0', 0);
__64.setAttribute('cellspacing', '0', 0);
__64.setAttribute('role', 'grid', 0);
__64.setAttribute('summary', XWC.S.table_summary, 0);
var __65 = XWC.UI.createElement('CAPTION');
__65.appendChild(document.createTextNode(XWC.S.certtable));
__64.appendChild(__65);
var __66 = XWC.UI.createElement('THEAD');
var __67 = XWC.UI.createElement('TR');
var __68 = XWC.UI.createElement('TH');
__68.setAttribute('scope', 'col', 0);
__68.className = 'xwup-mcert';
__68.setAttribute('sortType', 'IT', 0);
__68.style.width = '82px';
var __69 = XWC.UI.createElement('DIV');
__69.className = 'wide-cert-table-resizearea';
__69.appendChild(document.createTextNode(XWC.S.table_section));
var __70 = XWC.UI.createElement('DIV');
__69.appendChild(__70);
__68.appendChild(__69);
__67.appendChild(__68);
var __71 = XWC.UI.createElement('TH');
__71.setAttribute('scope', 'col', 0);
__71.className = 'xwup-mcert2';
__71.setAttribute('sortType', 'T', 0);
__71.style.width = '164px';
var __72 = XWC.UI.createElement('DIV');
__72.className = 'wide-cert-table-resizearea';
__72.appendChild(document.createTextNode(XWC.S.table_user));
var __73 = XWC.UI.createElement('DIV');
__72.appendChild(__73);
__71.appendChild(__72);
__67.appendChild(__71);
var __74 = XWC.UI.createElement('TH');
__74.setAttribute('scope', 'col', 0);
__74.className = 'xwup-mcert3';
__74.setAttribute('sortType', 'T', 0);
__74.style.width = '82px';
var __75 = XWC.UI.createElement('DIV');
__75.className = 'wide-cert-table-resizearea';
__75.appendChild(document.createTextNode(XWC.S.table_expire));
var __76 = XWC.UI.createElement('DIV');
__75.appendChild(__76);
__74.appendChild(__75);
__67.appendChild(__74);
var __77 = XWC.UI.createElement('TH');
__77.setAttribute('scope', 'col', 0);
__77.className = 'xwup-mcert4';
__77.setAttribute('sortType', 'T', 0);
__77.style.width = '82px';
var __78 = XWC.UI.createElement('DIV');
__78.className = 'wide-cert-table-resizearea';
__78.appendChild(document.createTextNode(XWC.S.table_issuer));
var __79 = XWC.UI.createElement('DIV');
__78.appendChild(__79);
__77.appendChild(__78);
__67.appendChild(__77);
__66.appendChild(__67);
__64.appendChild(__66);
var __80 = XWC.UI.createElement('TBODY');
var __81 = XWC.UI.createElement('TR');
var __82 = XWC.UI.createElement('TD');
__81.appendChild(__82);
__80.appendChild(__81);
__64.appendChild(__80);
__63.appendChild(__64);
__17.appendChild(__63);
var __83 = XWC.UI.createElement('DIV');
__83.className = 'xwup-group-btn-layout';
var __84 = XWC.UI.createElement('DIV');
__84.setAttribute('id', 'xwup_manager_user', 0);
var __85 = XWC.UI.createElement('FIELDSET');
__85.className = 'manager';
var __86 = XWC.UI.createElement('LEGEND');
if (__SANDBOX.IEVersion == 8) {
__86.style.display = 'block';
}
__86.className = 'xwup-legend';
__86.appendChild(document.createTextNode(XWC.S.certfilemng));
__85.appendChild(__86);
var __87 = XWC.UI.createElement('BUTTON');
__87.setAttribute('type', 'button', 0);
__87.setAttribute('tabindex', '3', 0);
__87.setAttribute('id', 'xwup_copy', 0);
__87.className = 'xwup-size180';
__87.onclick = function(event) {onCopyButtonClick(event);};
__87.setAttribute('title', XWC.S.open_layer + XWC.S.copy, 0);
var __88 = XWC.UI.createElement('SPAN');
__88.className = 'xwup-ico-save';
__87.appendChild(__88);
var __89 = XWC.UI.createElement('SPAN');
__89.appendChild(document.createTextNode(XWC.S.copy));
__87.appendChild(__89);
__85.appendChild(__87);
var __90 = XWC.UI.createElement('BUTTON');
__90.setAttribute('type', 'button', 0);
__90.setAttribute('tabindex', '3', 0);
__90.setAttribute('id', 'xwup_deletecert', 0);
__90.className = 'xwup-size180';
__90.onclick = function(event) {onDeleteButtonClick(event);};
__90.setAttribute('title', XWC.S.deletecert, 0);
var __91 = XWC.UI.createElement('SPAN');
__91.className = 'xwup-ico-del';
__90.appendChild(__91);
var __92 = XWC.UI.createElement('SPAN');
__92.appendChild(document.createTextNode(XWC.S.deletecert));
__90.appendChild(__92);
__85.appendChild(__90);
var __93 = XWC.UI.createElement('BUTTON');
__93.setAttribute('type', 'button', 0);
__93.setAttribute('tabindex', '3', 0);
__93.setAttribute('id', 'xwup_importexport', 0);
__93.className = 'xwup-size180';
__93.onclick = function(event) {onImportExportButtonClick(event);};
__93.setAttribute('title', XWC.S.open_layer + XWC.S.importexport, 0);
var __94 = XWC.UI.createElement('SPAN');
__94.className = 'xwup-ico-pfx16';
__93.appendChild(__94);
var __95 = XWC.UI.createElement('SPAN');
__95.appendChild(document.createTextNode(XWC.S.importexport));
__93.appendChild(__95);
__85.appendChild(__93);
__84.appendChild(__85);
var __96 = XWC.UI.createElement('FIELDSET');
__96.className = 'manager';
var __97 = XWC.UI.createElement('LEGEND');
if (__SANDBOX.IEVersion == 8) {
__97.style.display = 'block';
}
__97.className = 'xwup-legend';
__97.appendChild(document.createTextNode(XWC.S.certinfomng));
__96.appendChild(__97);
var __98 = XWC.UI.createElement('BUTTON');
__98.setAttribute('type', 'button', 0);
__98.setAttribute('tabindex', '3', 0);
__98.setAttribute('id', 'xwup_veiwverify', 0);
__98.className = 'xwup-size180';
__98.onclick = function(event) {onViewVerifyButtonClick(event);};
__98.setAttribute('title', XWC.S.open_layer + XWC.S.verify, 0);
var __99 = XWC.UI.createElement('SPAN');
__99.className = 'xwup-ico-prop';
__98.appendChild(__99);
var __100 = XWC.UI.createElement('SPAN');
__100.appendChild(document.createTextNode(XWC.S.verify));
__98.appendChild(__100);
__96.appendChild(__98);
var __101 = XWC.UI.createElement('BUTTON');
__101.setAttribute('type', 'button', 0);
__101.setAttribute('tabindex', '3', 0);
__101.setAttribute('id', 'xwup_changepass', 0);
__101.className = 'xwup-size180';
__101.onclick = function(event) {onChangePassButtonClick(event);};
__101.setAttribute('title', XWC.S.open_layer + XWC.S.changepass, 0);
var __102 = XWC.UI.createElement('SPAN');
__102.className = 'xwup-ico-secure05';
__101.appendChild(__102);
var __103 = XWC.UI.createElement('SPAN');
__103.appendChild(document.createTextNode(XWC.S.changepass));
__101.appendChild(__103);
__96.appendChild(__101);
var __104 = XWC.UI.createElement('BUTTON');
__104.setAttribute('type', 'button', 0);
__104.setAttribute('tabindex', '3', 0);
__104.setAttribute('id', 'xwup_ownerverify', 0);
__104.className = 'xwup-size180';
__104.onclick = function(event) {onOwnerVerifyButtonClick(event);};
__104.setAttribute('title', XWC.S.open_layer + XWC.S.ownerverify, 0);
var __105 = XWC.UI.createElement('SPAN');
__105.className = 'xwup-ico-misc25';
__104.appendChild(__105);
var __106 = XWC.UI.createElement('SPAN');
__106.appendChild(document.createTextNode(XWC.S.ownerverify));
__104.appendChild(__106);
__96.appendChild(__104);
__84.appendChild(__96);
__83.appendChild(__84);
var __107 = XWC.UI.createElement('DIV');
__107.setAttribute('id', 'xwup_manager_ca', 0);
__107.style.display = 'none';
var __108 = XWC.UI.createElement('DIV');
__108.setAttribute('id', 'xwup_ca_function', 0);
var __109 = XWC.UI.createElement('DIV');
__109.setAttribute('id', 'xwup_viewverify_function', 0);
var __110 = XWC.UI.createElement('BUTTON');
__110.setAttribute('type', 'button', 0);
__110.setAttribute('tabindex', '3', 0);
__110.className = 'xwup-size150';
__110.onclick = function(event) {onViewVerifyButtonClick(event);};
__110.setAttribute('title', XWC.S.open_layer + XWC.S.verify, 0);
var __111 = XWC.UI.createElement('SPAN');
__111.className = 'xwup-ico-prop';
__110.appendChild(__111);
var __112 = XWC.UI.createElement('SPAN');
__112.appendChild(document.createTextNode(XWC.S.verify));
__110.appendChild(__112);
__109.appendChild(__110);
var __113 = XWC.UI.createElement('SPAN');
__113.className = 'xwup-group-btn-desc';
__113.appendChild(document.createTextNode(XWC.S.descvertify));
__109.appendChild(__113);
__108.appendChild(__109);
var __114 = XWC.UI.createElement('DIV');
__114.setAttribute('id', 'xwup_deletecert_function', 0);
var __115 = XWC.UI.createElement('BUTTON');
__115.setAttribute('type', 'button', 0);
__115.setAttribute('tabindex', '3', 0);
__115.className = 'xwup-size150';
__115.onclick = function(event) {onDeleteButtonClick(event);};
__115.setAttribute('title', XWC.S.open_layer + XWC.S.deletecert, 0);
var __116 = XWC.UI.createElement('SPAN');
__116.className = 'xwup-ico-del';
__115.appendChild(__116);
var __117 = XWC.UI.createElement('SPAN');
__117.appendChild(document.createTextNode(XWC.S.deletecert));
__115.appendChild(__117);
__114.appendChild(__115);
var __118 = XWC.UI.createElement('SPAN');
__118.className = 'xwup-group-btn-desc';
__118.appendChild(document.createTextNode(XWC.S.descdelete));
__114.appendChild(__118);
__108.appendChild(__114);
var __119 = XWC.UI.createElement('DIV');
__119.setAttribute('id', 'xwup_rootverify_function', 0);
var __120 = XWC.UI.createElement('BUTTON');
__120.setAttribute('type', 'button', 0);
__120.setAttribute('tabindex', '3', 0);
__120.className = 'xwup-size150';
__120.onclick = function(event) {onRootVerifyButtonClick(event);};
__120.setAttribute('title', XWC.S.open_layer + XWC.S.rootverify, 0);
var __121 = XWC.UI.createElement('SPAN');
__121.className = 'xwup-ico-misc25';
__120.appendChild(__121);
var __122 = XWC.UI.createElement('SPAN');
__122.appendChild(document.createTextNode(XWC.S.rootverify));
__120.appendChild(__122);
__119.appendChild(__120);
var __123 = XWC.UI.createElement('SPAN');
__123.className = 'xwup-group-btn-desc';
__123.appendChild(document.createTextNode(XWC.S.descroot));
__119.appendChild(__123);
__108.appendChild(__119);
var __124 = XWC.UI.createElement('DIV');
__124.setAttribute('id', 'xwup_installcert_function', 0);
var __125 = XWC.UI.createElement('BUTTON');
__125.setAttribute('type', 'button', 0);
__125.setAttribute('tabindex', '3', 0);
__125.className = 'xwup-size150';
__125.onclick = function(event) {onInstallCertButtonClick(event);};
__125.setAttribute('title', XWC.S.open_layer + XWC.S.installroot, 0);
var __126 = XWC.UI.createElement('SPAN');
__126.className = 'xwup-ico-install';
__125.appendChild(__126);
var __127 = XWC.UI.createElement('SPAN');
__127.appendChild(document.createTextNode(XWC.S.installroot));
__125.appendChild(__127);
__124.appendChild(__125);
var __128 = XWC.UI.createElement('SPAN');
__128.className = 'xwup-group-btn-desc';
__128.appendChild(document.createTextNode(XWC.S.descinstall));
__124.appendChild(__128);
__108.appendChild(__124);
__107.appendChild(__108);
__83.appendChild(__107);
__17.appendChild(__83);
__6.appendChild(__17);
var __129 = XWC.UI.createElement('DIV');
__129.className = 'xwup-buttons-layout';
var __130 = XWC.UI.createElement('BUTTON');
__130.setAttribute('type', 'button', 0);
__130.setAttribute('tabindex', '3', 0);
__130.setAttribute('id', 'xwup_cancel', 0);
__130.onclick = function(event) {onCancelButtonClick()};
__130.appendChild(document.createTextNode(XWC.S.close));
__129.appendChild(__130);
__6.appendChild(__129);
__1.appendChild(__6);
__1.onload = onload;
if (typeof setFocus != "undefined") {
__1.setFocus = setFocus;
}
if (!AnySign.mDivInsertOption) {
setTimeout(function () {__1.tabControl = XWC.UI.appendTabControl(__1);}, 0);
}
return __1;

}
return function(option) {
    /**
     * COMMON DHTML FUNCTIONS
     * These are handy functions I use all the time.
     *
     * By Seth Banks (webmaster at subimage dot com)
     * http://www.subimage.com/
     *
     * Up to date code can be found at http://www.subimage.com/dhtml/
     *
     * This code is free for you to use anywhere, just keep this comment block.
     */

    /**
     * Code below taken from - http://www.evolt.org/article/document_body_doctype_switching_and_more/17/30655/
     *
     * Modified 4/22/04 to work with Opera/Moz (by webmaster at subimage dot com)
     *
     * Gets the full width/height because it's different for most browsers.
     */

	var aBody = document.body,
		aDialogOffset = __SANDBOX.addDialogOffset(),
		aTarget,
		aParent,
		aEvent,
		aCaller = arguments.callee.caller,
		aOffsetTop = 0,
		aOffsetLeft = 0,
		i,
		aParentPointer,
		aStyle,
		aPosition;

	if (AnySign.mUISettings.mUITarget) {
		aTarget = AnySign.mUISettings.mUITarget;
		delete AnySign.mUISettings.mUITarget;
	} else {
		aTarget = document.body;
	}

	aParentPointer = aTarget;
	while (aParentPointer && aParentPointer.parentNode) {
		var computedStyle;
		try {
			computedStyle = window.getComputedStyle(aParentPointer, null);
		} catch (ex) {
			computedStyle = "";
		}
		aStyle = aParentPointer.currentStyle || computedStyle;
		aPosition = aStyle.position;
		if (aPosition == "absolute" || aPosition == "relative") {
			aOffsetTop += aParentPointer.offsetTop;
			aOffsetLeft += aParentPointer.offsetLeft;
		} else if (aPosition == "fixed") {
			aOffsetTop += getScrollTop() + aParentPointer.offsetTop;
			aOffsetLeft += getScrollLeft() + aParentPointer.offsetLeft;
			break;
		}

		aParentPointer = aParentPointer.parentNode;
	}

	aParentPointer = aTarget;
	while (aParentPointer && aParentPointer != aBody) {
		if (aParentPointer.getAttribute("xwupcaller") || (aParentPointer.tagName && aParentPointer.tagName.toUpperCase() == "BUTTON")) {
			aTarget = aParentPointer;
		}
		aParentPointer = aParentPointer.parentNode;
	}

	aParent = aTarget.parentNode;

	function UIAppend (aElement)
	{
		if (aTarget == aBody)
		{
			aBody.insertBefore(aElement, aBody.firstChild);
		}
		else if (aElement == aParent.lastChild)
		{
			aParent.appendChild(aElement);
		}
		else if (option.appendChild) {
			aParent.appendChild(aElement);
		} else
		{
			aParent.insertBefore(aElement, aTarget.nextSibling);
		}
	}

	function UIRemove (aElement) {
		if (aElement == null)
			return;

		ApA = aElement.parentNode;
		if (ApA)
			ApA.removeChild (aElement);
	}

    function getViewportHeight() {
		if (window.innerHeight!=window.undefined) return window.innerHeight;
		if (document.compatMode=='CSS1Compat') return document.documentElement.clientHeight;
		if (aBody) return aBody.clientHeight; 

		return window.undefined; 
    }
    function getViewportWidth() {
		var offset = 17;
		var width = null;
		if (window.innerWidth!=window.undefined) return window.innerWidth; 
		if (document.compatMode=='CSS1Compat') return document.documentElement.clientWidth; 
		if (aBody) return aBody.clientWidth; 
    }

    /**
     * Gets the real scroll top
     */
    function getScrollTop() {
		if (self.pageYOffset) // all except Explorer
		{
			return self.pageYOffset;
		}
		else if (document.documentElement && document.documentElement.scrollTop)
			// Explorer 6 Strict
		{
			return document.documentElement.scrollTop;
		}
		else if (aBody) // all other Explorers
		{
			return aBody.scrollTop;
		}
    }
    function getScrollLeft() {
		if (self.pageXOffset) // all except Explorer
		{
			return self.pageXOffset;
		}
		else if (document.documentElement && document.documentElement.scrollLeft)
			// Explorer 6 Strict
		{
			return document.documentElement.scrollLeft;
		}
		else if (aBody) // all other Explorers
		{
			return aBody.scrollLeft;
		}
    }
    
    function dummyEvent(e) {
		e.stopPropagation();
		e.preventDefault();
	}

    var overlay = document.createElement('div');
	//overlay.cssText = AnySign.mUISettings.mCSSDefault;
	var _resizeOverlayFunction;
	overlay.style.zIndex = aDialogOffset;
	overlay.style.backgroundImage = 'none';
	overlay.style.marginLeft = '0px';
	overlay.style.cursor = 'auto';
    overlay.onclick = null;
	if (__SANDBOX.IEVersion <= 6)
	{
    	overlay.style.position = 'absolute';

		_resizeOverlayFunction = function (e) {
			overlay.style.width = aBody.scrollWidth;
			overlay.style.height = aBody.scrollHeight;
		}
		window.attachEvent("onresize", _resizeOverlayFunction);
		window.attachEvent("onscroll", _resizeOverlayFunction);
		_resizeOverlayFunction();
	   	overlay.style.top = -aOffsetTop + 'px';
	    overlay.style.left = -aOffsetLeft + 'px';
	}
	else
	{
    	overlay.style.position = 'fixed';
    	overlay.style.width = '100%';
    	overlay.style.height = '100%';
	   	overlay.style.top = '0';
	    overlay.style.left = '0';
	}
    overlay.style.display = 'none';
	if (__SANDBOX.isIE() < 9) {
		overlay.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+AnySign.mBasePath+"/img/gray.png', sizingMethod='scale')";
	}
    else if((__SANDBOX.browserName == "chrome" && __SANDBOX.browserVersion > 9) ||
    		(__SANDBOX.browserName == "opera" && __SANDBOX.browserVersion > 12) ||
    		(__SANDBOX.browserName == "safari" && __SANDBOX.browserVersion >= 5.1) ||
    		__SANDBOX.browserName == "edge") {
        overlay.style.background = '-webkit-radial-gradient(rgba(127, 127, 127, 0.5), rgba(127, 127, 127, 0.5) 35%, rgba(0, 0, 0, 0.7))';
    }
    else if(__SANDBOX.browserName == "firefox")
    {
        overlay.style.background = '-moz-radial-gradient(rgba(127, 127, 127, 0.5), rgba(127, 127, 127, 0.5) 35%, rgba(0, 0, 0, 0.7))';
    }
	else {
    	overlay.style.backgroundColor = '#333333';
    	overlay.style.opacity = '0.2';
	}
	
	if (overlay.addEventListener) {
		overlay.addEventListener ('dragenter', dummyEvent, false);
		overlay.addEventListener ('dragover', dummyEvent, false);
		overlay.addEventListener ('dragleave', dummyEvent, false);
		overlay.addEventListener ('drop', dummyEvent, false);
	}
	
    var doc = loadDoc(aTarget);

	doc.style.display = 'block';
	var winWidth = parseInt(doc.style.width, 10);
	if (doc.style.marginLeft)
		winWidth += parseInt(doc.style.marginLeft,10);
	if (doc.style.marginRight)
		winWidth += parseInt(doc.style.marginRight, 10);

    var win = document.createElement('div');
	win.setAttribute ("role", "dialog", 0);
	win.style.zIndex = aDialogOffset + 2;
	if (aTarget.id != "certDialog" && aTarget.id != "xwup_embedded_area")
	    win.style.position = 'absolute';
	win.style.display = 'block';
	win.style.visibility = 'hidden';
    win.style.width = winWidth + 2 + 'px';
	win.style.top = getScrollTop() - aOffsetTop+ 'px';
	win.style.left= getScrollLeft() - aOffsetLeft + 'px';
	if (AnySign.mDivInsertOption == 1) {
		win.className = "xwup_common xwup_cert_wide";
	}
	else if (AnySign.mDivInsertOption == 2) {
		win.className = "xwup_common xwup_cert_mini";
	}
	else
	{
		win.className = "xwup_common xwup_cert_pop";
	}
	
	if (win.addEventListener) {
		win.addEventListener ('dragenter', dummyEvent, false);
		win.addEventListener ('dragover', dummyEvent, false);
		win.addEventListener ('dragleave', dummyEvent, false);
		win.addEventListener ('drop', dummyEvent, false);
	}

	if (aTarget.id != "certDialog" && aTarget.id != "xwup_embedded_area") {
	    UIAppend(overlay);
	}
	UIAppend(win);

    win.appendChild(doc);

	var aResult = doc.onload({
			type: option.type,
			args: option.args, 
     		onconfirm: option.onconfirm,
     		oncancel: option.oncancel
     	});    
	if(aResult != 0) {
   		UIRemove(win);
    	UIRemove(overlay);
		alert("Module loading error");
		return;
	}	

	var selectableEventBackup = {};
	function unselectableHandler (e) {
		var target,
			targetName,
			targetType;
		e = e || window.event;
 
		target = e.target || e.srcElement;

		if (target.tagName) {
			targetName = target.tagName.toLowerCase();
		}

		if (typeof target.type == "string" && target.type) {
			targetType = target.type.toLowerCase();
		}

		if  ( (targetName == "input" && (targetType == "text" || targetType == "password" )) 
			  || (targetName == "html") 
			  || (targetName == "textarea") 
			  || (targetName == "select") 
			  || (targetName == "button") ) {
			return true;
		} else {
			return false;
		}
	}

    return {
    	show: function() {
			var theBody = document.getElementsByTagName("BODY")[0];	    
			var fullHeight = getViewportHeight();
			var fullWidth = getViewportWidth();

			function centerWindow() {
				var width = doc.offsetWidth;
				var height = doc.offsetHeight;
				var scTop = parseInt(getScrollTop(),10);
				var scLeft = parseInt(theBody.scrollLeft,10);
				
				win.style.top  = (scTop  + ((fullHeight - height) / 3) - aOffsetTop) + "px";
				win.style.left = (scLeft + ((fullWidth  - width)  / 2) - aOffsetLeft) + "px";
			}
			
			centerWindow();

			overlay.style.display = 'block';
			win.style.visibility = 'visible';
			try {Integrity.setObserver(__SANDBOX.integrityModule);}catch(e){}

			// focus
			if (doc.setFocus) {
				setTimeout(doc.setFocus,0);
			} else {
				var liElements = doc.getElementsByTagName("li");
				if (liElements.length > 0) {
					liElements[0].focus();
				}   
				else {
					var inputElements = doc.getElementsByTagName("input");
					if (inputElements.length > 0) {
						var i = 0;
						while (inputElements[i].disabled || inputElements[i].style.display == "none") {
							i++; 
							if(inputElements.length <=  i) break;
						}
						if (inputElements[i] != undefined) {
							inputElements[i].focus();	
						}
					}
					else {
						var buttonElements = doc.getElementsByTagName("button");
						if (buttonElements.length > 0 && !buttonElements.disabled)
							buttonElements[0].focus();
					}
				}
			}

			//redraw win for IE8 rendering bug
			//don't check version number for compat view
			if (__SANDBOX.isIE())
			{
				win.style.cssText = win.style.cssText;
			}

			if (__SANDBOX.IEVersion <= 8) {
				selectableEventBackup.onmousedown = document.onmousedown;
				selectableEventBackup.onmouseup = document.onmouseup;
				document.onmousedown = unselectableHandler;
				document.onmouseup = function (e) { return true; };
			} else {
				selectableEventBackup.onselectstart = document.onselectstart;
				document.onselectstart = unselectableHandler;
			}

			if (doc.onShow) {
				setTimeout(doc.onShow, 0);
			}

			__SANDBOX.dialogStack.push (win);

    	},
    	
    	hide: function() {
    	    overlay.style.display = 'none';
    	    win.style.display = 'none';
    	},
    	
    	dispose: function() {
			if (doc.tabControl)
				doc.tabControl.remove();
	
			__SANDBOX.dialogStack.pop (win);

			__SANDBOX.removeDialogOffset();
			if (_resizeOverlayFunction) {
		 		window.detachEvent("onresize", _resizeOverlayFunction);
				window.detachEvent("onscroll", _resizeOverlayFunction);
				_resizeOverlayFunction = undefined;
			}
    	    UIRemove(win);
    	    win = null;
    	    if (overlay ? overlay.parentNode != null : null)
    	    {
    	    	UIRemove(overlay);
    	    	overlay = null;
    	    }

			if (__SANDBOX.IEVersion <= 8) {
				document.onmousedown   = selectableEventBackup.onmousedown;
				document.onmouseup     = selectableEventBackup.onmouseup;
			} else {
				document.onselectstart = selectableEventBackup.onselectstart;
			}
    	},

		getUITarget: function() {
			return aTarget;
		}
    };
}

};
