var __changepasswd = function(__SANDBOX) {
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
changepasswd_tk1 = null; changepasswd_tk2 = null; changepasswd_tk3 = null; var gDialogObj,
	gErrCallback,
	gMediaID,
	gMediaType,
	gInputHandler_old,
	gInputHandler_new,
	gInputHandler_confirm;

XWC.getLocaleResource("changepasswd", XWC.lang());

function onload(aDialogObj) {
	gDialogObj = aDialogObj;
	gErrCallback = gDialogObj.args.errCallback || gErrCallback_common;
	gMediaID = Math.floor(gDialogObj.args.selectedMediaID / 100) * 100;
	
	XWC.UI.setDragAndDrop(__2);
	
	gMediaType = __SANDBOX.getInputType(gDialogObj.args.selectedMediaID);
	if (gMediaType == "lite") {
		gInputHandler_old = new __SANDBOX.inputKeyHandler("changepasswd", __21, 1, -190, 5, "qwerty_crt", 30, 150, "lite");
		gInputHandler_new = new __SANDBOX.inputKeyHandler("changepasswd", __24, 2, -190, 5, "qwerty_crt", 30, 150, "lite");
		gInputHandler_confirm = new __SANDBOX.inputKeyHandler("changepasswd", __27, 3, -190, 5, "qwerty_crt", 30, 150, "lite");
	} else if (gMediaType == "xfs") {
		gInputHandler_old = new __SANDBOX.inputKeyHandler("changepasswd", __21, 1, -190, 5, "qwerty_crt", 30, 150, "e2e");
		gInputHandler_new = new __SANDBOX.inputKeyHandler("changepasswd", __24, 2, -190, 5, "qwerty_crt", 30, 150, "e2e");
		gInputHandler_confirm = new __SANDBOX.inputKeyHandler("changepasswd", __27, 3, -190, 5, "qwerty_crt", 30, 150, "e2e");
	} else {
		gInputHandler_old = new __SANDBOX.inputKeyHandler("changepasswd", __21, 1, -190, 5, "qwerty_crt", 30, 150);
		gInputHandler_new = new __SANDBOX.inputKeyHandler("changepasswd", __24, 2, -190, 5, "qwerty_crt", 30, 150);
		gInputHandler_confirm = new __SANDBOX.inputKeyHandler("changepasswd", __27, 3, -190, 5, "qwerty_crt", 30, 150);
	}

	gInputHandler_old.onComplete({
		ok : function () {},
		close : function () { gInputHandler_old.clear(); }
	});
	gInputHandler_new.onComplete({
		ok : function () {},
		close : function () { gInputHandler_new.clear(); }
	});
	gInputHandler_confirm.onComplete({
		ok : function () {},
		close : function () { gInputHandler_confirm.clear(); }
	});

	gInputHandler_confirm.onEnterKeyPress(__29);

	if (!(__SANDBOX.isIE() && navigator.userAgent.indexOf('Windows NT 6.2') >= 0)) {
		if (__SANDBOX.isIE() <= 7) {
			setCapsLockToolTip(__21, __13, 0, -30);
			setCapsLockToolTip(__24, __13, 0, 6);
			setCapsLockToolTip(__27, __13, 0, 41);
		}
		else {
			setCapsLockToolTip(__21, __13, 0, -22);
			setCapsLockToolTip(__24, __13, 0, 11);
			setCapsLockToolTip(__27, __13, 0, 44);
		}
	}

	if (AnySign.mWBStyleApply)
	{
		var aButton = XWC.UI.createElement("a");
		var aParent = document.getElementById("xwup_body");

		aButton.id = "xwup_close";
		aButton.title = XWC.S.close;
		aButton.setAttribute ("tabindex", 4, 0);
		aButton.setAttribute ("href", "javascript:;", 0);
		aButton.className = "xwup-close-button";
		aButton.onclick = function () { onCancelButtonClick(); };

		aParent.appendChild(aButton);

				var label1 = XWC.UI.createElement('LABEL');
		label1.style.fontSize = '12.0px';
		label1.setAttribute('for', 'xwup_changepasswd_tek_check1', 0);
		label1.setAttribute('id', 'xwup_changepasswd_tek_label1', 0);
		label1.style.display = 'inline';
		label1.style.margin = '0px';

		var checkbox1 = XWC.UI.createElement('INPUT');
		checkbox1.style.margin = '0 4.0px 0 0';
		checkbox1.setAttribute('tabindex', '4', 0);
		if (__SANDBOX.IEVersion <= 8) {
			checkbox1.mergeAttributes(XWC.UI.createElement("<INPUT name='changepasswd_tek_check1'>"), false);
		} else {
			checkbox1.setAttribute('name', 'changepasswd_tek_check1', 0);
		}

		checkbox1.setAttribute('id', 'xwup_changepasswd_tek_check1', 0);
		checkbox1.setAttribute('type', 'checkbox', 0);
		checkbox1.onclick = function (event) { onInputMouseCheckBoxClick1(event); };

		label1.appendChild (checkbox1);
		label1.appendChild(document.createTextNode(XWC.S.input_mouse));

		__21.parentNode.appendChild (label1);

				var label2 = XWC.UI.createElement('LABEL');
		label2.style.fontSize = '12.0px';
		label2.setAttribute('for', 'xwup_changepasswd_tek_check2', 0);
		label2.setAttribute('id', 'xwup_changepasswd_tek_label2', 0);
		label2.style.display = 'inline';
		label2.style.margin = '0px';

		var checkbox2 = XWC.UI.createElement('INPUT');
		checkbox2.style.margin = '0 4.0px 0 0';
		checkbox2.setAttribute('tabindex', '4', 0);
		if (__SANDBOX.IEVersion <= 8) {
			checkbox2.mergeAttributes(XWC.UI.createElement("<INPUT name='changepasswd_tek_check2'>"), false);
		} else {
			checkbox2.setAttribute('name', 'changepasswd_tek_check2', 0);
		}

		checkbox2.setAttribute('id', 'xwup_changepasswd_tek_check2', 0);
		checkbox2.setAttribute('type', 'checkbox', 0);
		checkbox2.onclick = function (event) { onInputMouseCheckBoxClick2(event); };

		label2.appendChild (checkbox2);
		label2.appendChild(document.createTextNode(XWC.S.input_mouse));

		__24.parentNode.appendChild (label2);

				var label3 = XWC.UI.createElement('LABEL');
		label3.style.fontSize = '12.0px';
		label3.setAttribute('for', 'xwup_changepasswd_tek_check3', 0);
		label3.setAttribute('id', 'xwup_changepasswd_tek_label3', 0);
		label3.style.display = 'inline';
		label3.style.margin = '0px';

		var checkbox3 = XWC.UI.createElement('INPUT');
		checkbox3.style.margin = '0 4.0px 0 0';
		checkbox3.setAttribute('tabindex', '4', 0);
		if (__SANDBOX.IEVersion <= 8) {
			checkbox3.mergeAttributes(XWC.UI.createElement("<INPUT name='changepasswd_tek_check3'>"), false);
		} else {
			checkbox3.setAttribute('name', 'changepasswd_tek_check3', 0);
		}

		checkbox3.setAttribute('id', 'xwup_changepasswd_tek_check3', 0);
		checkbox3.setAttribute('type', 'checkbox', 0);
		checkbox3.onclick = function (event) { onInputMouseCheckBoxClick3(event); };

		label3.appendChild (checkbox3);
		label3.appendChild(document.createTextNode(XWC.S.input_mouse));

		__27.parentNode.appendChild (label3);

		if (AnySign.mPlatform == AnySign.mPlatformList[0] ||AnySign.mPlatform == AnySign.mPlatformList[1] || (__SANDBOX.browserName == "opera" && __SANDBOX.browserVersion >= 12.0))
		{
			__21.readOnly = true;
			checkbox1.checked = true;
			checkbox1.disabled = true;
			changepasswd_tk1.useTransKey = true;

			__24.readOnly = true;
			checkbox2.checked = true;
			checkbox2.disabled = true;
			changepasswd_tk2.useTransKey = true;

			__27.readOnly = true;
			checkbox3.checked = true;
			checkbox3.disabled = true;
			changepasswd_tk3.useTransKey = true;
		}
	}

	if (AnySign.mEnhancedPW._change) {
		var aParent = __11;
		aParent.removeChild(aParent.firstChild);
		aParent.appendChild(document.createTextNode(XWC.S.info3));
	}
	
	return 0;
}

function setFocus() {
	gInputHandler_old.refresh();
	__2.focus();
}

function onOKButtonClick() {
	var aOldPasswd,
		aPasswd,
		aPasswdconfirm,
		aPWLength = 8,
		aGuideModule,
		aGuideDialog = null;

	__29.disabled = true;

		if (gInputHandler_old.getLength() == 0) {
		alert(XWC.S.lengtherror3);
		__29.disabled = false;
		return;
	}

	if (AnySign.mEnhancedPW._change)
		aPWLength = 10;
	
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
	
	_close_guidewindow = function ()
	{
		if (aGuideDialog) {
			aGuideDialog.dispose ();
			aGuideDialog = null;
		}
	}
		_final = function (aCallback)
	{
		var _CB_final = function ()
		{
			_close_guidewindow ();
			
			if (aCallback)
				aCallback ();
		}
		
		if (gMediaID == XWC.CERT_LOCATION_ICCARD || gMediaID == XWC.CERT_LOCATION_KEPCOICCARD) {
			__SANDBOX.upInterface().logoutStoreToken(gDialogObj.args.selectedMediaID, _CB_final);
		} else if (gMediaID == XWC.CERT_LOCATION_SECUREDISK) {
			__SANDBOX.upInterface().finalizeSecureDiskFromName (gDialogObj.args.providerName, _CB_final);
		} else {
			_CB_final ();
		}
	}
		_loginStoreToken = function (result)
	{
		if (result != 0)
		{
			_close_guidewindow ();
			
			var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
			_iccard_result ();
		}
		else
		{
			_changeCertPassword ();
		}
	}
		_iccard_result = function ()
	{
		var aICCardType;
		if (gMediaID == XWC.CERT_LOCATION_KEPCOICCARD)
			aICCardType = "kepco";
		else
			aICCardType = "iccard";
		
		var iccardModule = __SANDBOX.loadModule("iccard");
		var iccardDialog = iccardModule({
			type: aICCardType,
			args: { },
			onconfirm: function (aPin) {
				iccardDialog.dispose ();
				__29.disabled = false;

				_show_guidewindow ();

				__SANDBOX.upInterface().loginStoreToken(gDialogObj.args.selectedMediaID, aPin, 0, _loginStoreToken);
			},
			oncancel: function () {
				iccardDialog.dispose();
				__29.disabled = false;
			}
		});
		iccardDialog.show();
	}

		_CB_changeCertPassword = function (result)
	{
		if (gMediaType == "xfs") {
			if (result != 0) {
				var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
				gErrCallback(aErrorObject);
				if (aErrorObject.code == 0x65021019 || aErrorObject.code ==0x65020120) {
					gInputHandler_new.clear();
					gInputHandler_confirm.clear();
					gInputHandler_new.focus();
					__29.disabled = false;
				} else {
					gDialogObj.onconfirm(-1);
				}
			} else {
				gDialogObj.onconfirm(0);
			}
		} else {
			if (__SANDBOX.isFailed(result, gErrCallback)) {
				var _CB_final = function () {
					gDialogObj.onconfirm(-1);
				}
				_final (_CB_final);
			} else {
				var _CB_final = function () {
					gDialogObj.onconfirm(0);
				}
				_final (_CB_final);
			}
		}
	}

	_changeCertPassword = function() {
		__SANDBOX.upInterface().changeCertPassword (gDialogObj.args.selectedMediaID,
													gDialogObj.args.issuerRDN,
													gDialogObj.args.certSerial,
													aOldPasswd,
													aPasswd,
													aPasswdconfirm,
													_CB_changeCertPassword);
	}
		_checkPasswordLen = function (result)
	{
		if (result < 0) {
			if (__SANDBOX.isFailed(result, gErrCallback)) {
				var _CB_final = function () {
					gInputHandler_new.clear();
					gInputHandler_confirm.clear();
					gInputHandler_new.focus();
					__29.disabled = false;
				}
				_final (_CB_final);
				return;
			}
		}

		if (gMediaID == XWC.CERT_LOCATION_ICCARD || gMediaID == XWC.CERT_LOCATION_KEPCOICCARD)
			_iccard_result ();
		else
			_changeCertPassword ();

	}
		_generateSessionID_confirmPasswd = function (result)
	{
		aPasswdconfirm = gInputHandler_confirm.getValue(result);

		if (gMediaType == "xfs") {
			_changeCertPassword ();
		} else {
			if (aPWLength != 8)
				__SANDBOX.upInterface().checkPasswordLenExt(aPasswd, aPasswdconfirm, 1, _checkPasswordLen);
			else
				__SANDBOX.upInterface().checkPasswordLen(aPasswd, aPasswdconfirm, 1, _checkPasswordLen);
		}
	}
		_generateSessionID_newPasswd = function (result)
	{
		aPasswd = gInputHandler_new.getValue(result);

		gInputHandler_confirm.generateSessionID(1, _generateSessionID_confirmPasswd);
	}
		_verifyPassword = function (result)
	{
		if (result != 0) {
			var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			var _CB_final = function () {
				gInputHandler_old.clear();
				gInputHandler_new.clear();
				gInputHandler_confirm.clear();
				gDialogObj.onconfirm(-2, aErrorObject.msg);
			}
			_final (_CB_final);
			return;
		}

		if (gInputHandler_new.getLength() < aPWLength || gInputHandler_confirm.getLength() < aPWLength) {
			var _CB_final = function () {
				gInputHandler_new.clear();
				gInputHandler_confirm.clear();

				if (aPWLength != 8)
					alert(XWC.S.lengtherror2);
				else
					alert(XWC.S.lengtherror);

				__29.disabled = false;
			}
			_final (_CB_final);
			return;
		}

		gInputHandler_new.generateSessionID(1, _generateSessionID_newPasswd);
	}
		_generateSessionID_oldPasswd = function (result)
	{
		aOldPasswd = gInputHandler_old.getValue(result);
		
		if (gMediaID == XWC.CERT_LOCATION_SECUREDISK) {
			
			_show_guidewindow ();
			
			__SANDBOX.upInterface().loginSecureDiskFromIndex (gDialogObj.args.selectedMediaID,
															  aOldPasswd,
															  gDialogObj.args.subjectRDN,
															  gDialogObj.args.issuerRDN,
															  gDialogObj.args.certSerial,
															  0,
															  _verifyPassword);
		} else {
			__SANDBOX.upInterface().verifyPassword (gDialogObj.args.selectedMediaID,
													gDialogObj.args.issuerRDN,
													gDialogObj.args.certSerial,
													aOldPasswd,
													_verifyPassword);
		}
	}

	gInputHandler_old.generateSessionID(0, _generateSessionID_oldPasswd);
}

function onCancelButtonClick() {
	gDialogObj.oncancel();
}

function onInputMouseCheckBoxClick1(aEvent) {
	var aChecked = false;
	var aTransKey = false;

	aEvent = aEvent || window.event;

	if (aEvent.target) {
		aChecked = aEvent.target.checked;
	}
	else {
		aChecked = aEvent.srcElement.checked;
	}

	aTransKey = changepasswd_tk1;

	if (aChecked) {
		aTransKey.useTransKey = true;
		__21.readOnly = true;
		showTransKeyBtn("changepasswd_tk1");
		aTransKey.clear();
	}
	else {
		aTransKey.useTransKey = false;
		__21.readOnly = false;
		aTransKey.clear();
		aTransKey.close();
	}
}

function onInputMouseCheckBoxClick2(aEvent) {
	var aChecked = false;
	var aTransKey = false;

	aEvent = aEvent || window.event;

	if (aEvent.target) {
		aChecked = aEvent.target.checked;
	}
	else {
		aChecked = aEvent.srcElement.checked;
	}

	aTransKey = changepasswd_tk2;

	if (aChecked) {
		aTransKey.useTransKey = true;
		__24.readOnly = true;
		showTransKeyBtn("changepasswd_tk2");
		aTransKey.clear();
	}
	else {
		aTransKey.useTransKey = false;
		__24.readOnly = false;
		aTransKey.clear();
		aTransKey.close();
	}
}

function onInputMouseCheckBoxClick3(aEvent) {
	var aChecked = false;
	var aTransKey = false;

	aEvent = aEvent || window.event;

	if (aEvent.target) {
		aChecked = aEvent.target.checked;
	}
	else {
		aChecked = aEvent.srcElement.checked;
	}

	aTransKey = changepasswd_tk3;

	if (aChecked) {
		aTransKey.useTransKey = true;
		__27.readOnly = true;
		showTransKeyBtn("changepasswd_tk3");
		aTransKey.clear();
	}
	else {
		aTransKey.useTransKey = false;
		__27.readOnly = false;
		aTransKey.clear();
		aTransKey.close();
	}
}

var __1 = XWC.UI.createElement('DIV');
__1.style.width = '420px';
var __2 = XWC.UI.createElement('DIV');
__2.setAttribute('id', 'xwup_title', 0);
__2.className = 'title';
__2.setAttribute('tabindex', '4', 0);
var __3 = XWC.UI.createElement('H3');
__3.appendChild(document.createTextNode(XWC.S.title));
__2.appendChild(__3);
__1.appendChild(__2);
var __4 = XWC.UI.createElement('DIV');
__4.setAttribute('id', 'xwup_body', 0);
__4.className = 'xwup-body';
var __5 = XWC.UI.createElement('DIV');
__5.className = 'xwup-ch-title';
var __6 = XWC.UI.createElement('TABLE');
__6.setAttribute('cellpadding', '0', 0);
__6.setAttribute('cellspacing', '0', 0);
var __7 = XWC.UI.createElement('TBODY');
var __8 = XWC.UI.createElement('TR');
var __9 = XWC.UI.createElement('TD');
var __10 = XWC.UI.createElement('IMG');
__10.setAttribute('width', '46', 0);
__10.setAttribute('height', '47', 0);
__10.setAttribute('src', AnySign.mBasePath+'/img/main_savepasswd.png', 0);
__10.setAttribute('alt', XWC.S.title, 0);
__10.className = 'timg';
__9.appendChild(__10);
__8.appendChild(__9);
var __11 = XWC.UI.createElement('TD');
__11.setAttribute('id', 'xwup_changepasswd_decinfo', 0);
__11.appendChild(document.createTextNode(XWC.S.info2));
__8.appendChild(__11);
__7.appendChild(__8);
__6.appendChild(__7);
__5.appendChild(__6);
__4.appendChild(__5);
var __12 = XWC.UI.createElement('DIV');
__12.className = 'xwup-widget-sec2';
var __13 = XWC.UI.createElement('DIV');
__13.setAttribute('id', 'xwup_capslock', 0);
__13.className = 'xwup-expire-alert';
var __14 = XWC.UI.createElement('SPAN');
__14.className = 'fb';
__14.appendChild(document.createTextNode(XWC.S.tooltip_capslock1));
__13.appendChild(__14);
var __15 = XWC.UI.createElement('SPAN');
__15.className = 'fc';
__15.appendChild(document.createTextNode(XWC.S.tooltip_capslock2));
__13.appendChild(__15);
var __16 = XWC.UI.createElement('DIV');
__16.setAttribute('id', 'xwup_expire_arrow_border', 0);
__16.className = 'xwup-expire-arrow-border';
__13.appendChild(__16);
var __17 = XWC.UI.createElement('DIV');
__17.setAttribute('id', 'xwup_expire_arrow', 0);
__17.className = 'xwup-expire-arrow';
__13.appendChild(__17);
__12.appendChild(__13);
__4.appendChild(__12);
var __18 = XWC.UI.createElement('FORM');
if (__SANDBOX.IEVersion <= 8) {
__18.mergeAttributes(XWC.UI.createElement("<FORM name='xwup_changepasswd_tek_form'>"),false);
} else {
__18.setAttribute('name', 'xwup_changepasswd_tek_form', 0);
}
__18.setAttribute('id', 'xwup_changepasswd_tek_form', 0);
__18.className = 'xwup-ch-section';
__18.onsubmit = function(event) {return false;};
var __19 = XWC.UI.createElement('DIV');
__19.className = 'xwup-password-field';
__19.setAttribute('id', 'changepasswd_tk1', 0);
var __20 = XWC.UI.createElement('LABEL');
__20.htmlFor = 'xwup_changepasswd_tek_input1';
__20.className = 'normal';
__20.appendChild(document.createTextNode(XWC.S.oldpass));
__19.appendChild(__20);
var __21 = XWC.UI.createElement('INPUT');
__21.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__21.mergeAttributes(XWC.UI.createElement("<INPUT name='changepasswd_tek_input1'>"),false);
} else {
__21.setAttribute('name', 'changepasswd_tek_input1', 0);
}
__21.setAttribute('id', 'xwup_changepasswd_tek_input1', 0);
__21.setAttribute('type', 'password', 0);
__21.className = 'xwup-input-pwd';
__21.setAttribute('kbd', 'qwerty_crt', 0);
__19.appendChild(__21);
__18.appendChild(__19);
var __22 = XWC.UI.createElement('DIV');
__22.className = 'xwup-password-field';
__22.setAttribute('id', 'changepasswd_tk2', 0);
var __23 = XWC.UI.createElement('LABEL');
__23.htmlFor = 'xwup_changepasswd_tek_input2';
__23.className = 'normal';
__23.appendChild(document.createTextNode(XWC.S.newpass));
__22.appendChild(__23);
var __24 = XWC.UI.createElement('INPUT');
__24.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__24.mergeAttributes(XWC.UI.createElement("<INPUT name='changepasswd_tek_input2'>"),false);
} else {
__24.setAttribute('name', 'changepasswd_tek_input2', 0);
}
__24.setAttribute('id', 'xwup_changepasswd_tek_input2', 0);
__24.setAttribute('type', 'password', 0);
__24.className = 'xwup-input-pwd';
__24.setAttribute('kbd', 'qwerty_crt', 0);
__22.appendChild(__24);
__18.appendChild(__22);
var __25 = XWC.UI.createElement('DIV');
__25.className = 'xwup-password-field';
__25.setAttribute('id', 'changepasswd_tk3', 0);
var __26 = XWC.UI.createElement('LABEL');
__26.htmlFor = 'xwup_changepasswd_tek_input3';
__26.className = 'normal';
__26.appendChild(document.createTextNode(XWC.S.confirm));
__25.appendChild(__26);
var __27 = XWC.UI.createElement('INPUT');
__27.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__27.mergeAttributes(XWC.UI.createElement("<INPUT name='changepasswd_tek_input3'>"),false);
} else {
__27.setAttribute('name', 'changepasswd_tek_input3', 0);
}
__27.setAttribute('id', 'xwup_changepasswd_tek_input3', 0);
__27.setAttribute('type', 'password', 0);
__27.className = 'xwup-input-pwd';
__27.setAttribute('kbd', 'qwerty_crt', 0);
__25.appendChild(__27);
__18.appendChild(__25);
__4.appendChild(__18);
var __28 = XWC.UI.createElement('DIV');
__28.className = 'xwup-buttons-layout';
var __29 = XWC.UI.createElement('BUTTON');
__29.setAttribute('tabindex', '4', 0);
__29.setAttribute('type', 'button', 0);
__29.setAttribute('id', 'xwup_ok', 0);
__29.onclick = function(event) {onOKButtonClick()};
__29.appendChild(document.createTextNode(XWC.S.button_ok));
__28.appendChild(__29);
var __30 = XWC.UI.createElement('BUTTON');
__30.setAttribute('tabindex', '4', 0);
__30.setAttribute('type', 'button', 0);
__30.setAttribute('id', 'xwup_cancel', 0);
__30.onclick = function(event) {onCancelButtonClick()};
__30.appendChild(document.createTextNode(XWC.S.button_cancel));
__28.appendChild(__30);
__4.appendChild(__28);
__1.appendChild(__4);
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
