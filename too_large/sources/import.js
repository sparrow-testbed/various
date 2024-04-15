var __import = function(__SANDBOX) {
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
import_tk1 = null; var gImportType = "pkcs12";
var gDialogObj;
var gMediaID;
var gPkcs12PassInput;
var gSavepasswdResult;
var gErrCallback;
var gInputHandler;

XWC.getLocaleResource("import", XWC.lang());

function onload(aDialogObj) 
{
	var aEncryptID = "";

    gDialogObj = aDialogObj;
	if (gDialogObj.args.errCallback)
		gErrCallback = gDialogObj.args.errCallback;
	else
		gErrCallback = gErrCallback_common;
	
	gMediaID = Math.floor(gDialogObj.args.selectedMediaID / 100) * 100;
		
	XWC.UI.setDragAndDrop(__2);
	
	if (__SANDBOX.getInputType(gMediaID) == "lite") {
		gInputHandler = new __SANDBOX.inputKeyHandler ("import", __22, 1, -70, 5, "qwerty_crt", 30, 240, "lite");
	} else {
		gInputHandler = new __SANDBOX.inputKeyHandler ("import", __22, 1, -70, 5, "qwerty_crt", 30, 240);
	}
	
	gInputHandler.onComplete({
		ok : function (){
		},
		close : function () {gInputHandler.clear();}
	});

	gInputHandler.onEnterKeyPress (__67);

    var aNextButtonClickListeners = [
	function(callback) {
	    if (gImportType == "pkcs12")
	    {
			if (__14.value.length == 0) {
				alert(XWC.S.blinkpfxfilefail);
				callback (false);
				return;
			}

			var aExt = __14.value.split(".").pop();
			if (aExt != "pfx" && aExt != "p12") {
			    alert(XWC.S.wrongpfxfilefail);
				callback (false);
				return;
			}

			if (gInputHandler.getLength() == 0) {
			    alert(XWC.S.blinkpasswdfail);
				callback (false);
				return;
			}
						_CB_checkPFXPwd = function (result)
			{
				if (result != 0 )
				{
					alert(XWC.S.passwdfail);
					gInputHandler.clear();
					callback (false);
					return;
				}
				else
				{
					callback (true);
					return;
				}
			}
						_CB_generateSessionID = function (result)
			{
				gPkcs12PassInput = gInputHandler.getValue(result);
				
				__SANDBOX.upInterface().checkPFXPwd(__14.value, gPkcs12PassInput, _CB_checkPFXPwd);
			}
						gInputHandler.generateSessionID(0, _CB_generateSessionID);
	    }
	    else
	    {
			if (__24.checked == false &&
			    __41.checked == false) {
			    alert(XWC.S.blinkx509type);
			    return false;	    
			}

			if (__24.checked == true) {
			    if (__32.value.length == 0) {
					alert(XWC.S.x509signcertfail);
					return;
			    }
			    if (__38.value.length == 0) {
					alert(XWC.S.x509signkeyfail);
					return;
			    }
			}
		
			if (__41.checked == true) {
			    if (__32.value.length == 0) {
					alert(XWC.S.x509kmcertfail);
					return false;
			    }
			    if (__55.value.length == 0) {
					alert(XWC.S.x509kmkeyfail);
					return false;
			    }
			}
	    }

		try {
			__67.focus();
		} catch (err) {}

	    return true;
	}
    ];

    aWizardView = new XWC_UI_WizardView(__5,
					aNextButtonClickListeners,
					null);

    __24.checked = true;
    __41.checked = false;
    __49.disabled = true;
    __50.disabled = true;
    __55.disabled = true;
    __56.disabled = true;

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

		aParent = __60;
		var aImg = aParent.firstChild.firstChild;
		aImg.src = AnySign.mBasePath + "/img/wizimg01_wb.png";

		var label = XWC.UI.createElement('LABEL');
		label.style.fontSize = '12.0px';
		label.setAttribute('for', 'xwup_import_tek_check1', 0);
		label.setAttribute('id', 'xwup_import_tek_label1', 0);

		var checkbox = XWC.UI.createElement('INPUT');
		checkbox.style.margin = '0 4.0px 0 0';
		checkbox.setAttribute('tabindex', '4', 0);
		if (__SANDBOX.IEVersion <= 8) {
			checkbox.mergeAttributes(XWC.UI.createElement("<INPUT name='import_tek_check1'>"), false);
		} else {
			checkbox.setAttribute('name', 'import_tek_check1', 0);
		}

		checkbox.setAttribute('id', 'xwup_import_tek_check1', 0);
		checkbox.setAttribute('type', 'checkbox', 0);
		checkbox.onclick = function (event) { onInputMouseCheckBoxClick(event); };

		label.appendChild (checkbox);
		label.appendChild(document.createTextNode(XWC.S.input_mouse));

		__22.parentNode.appendChild (label);
	}

	return 0;
}    

function setFocus() {
	gInputHandler.refresh();
}

function onComplete(aCompleteResult) { 
	var aGuideModule,
		aGuideDialog = null;

		
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
		
		if (gMediaID == XWC.CERT_LOCATION_PKCS11) {
			__SANDBOX.upInterface().finalizePKCS11FromName (gDialogObj.args.providerName, _final_callback);
		} else if (gMediaID == XWC.CERT_LOCATION_SECUREDISK) {
			__SANDBOX.upInterface().finalizeSecureDiskFromName (gDialogObj.args.providerName, _final_callback);
		} else {
			_final_callback ();
		}
	}
		
    if (gImportType == "pkcs12")
    {
		if (gMediaID == XWC.CERT_LOCATION_PKCS11)
		{
			var verifyhsmModule = __SANDBOX.loadModule("verifyhsm"),
				verifyhsmDialog;

			AnySign.SetUITarget (__67);
			verifyhsmDialog = verifyhsmModule({
				args: {messageType: "import"},
				onconfirm: function(pin) {
					verifyhsmDialog.dispose();
					_show_guidewindow ();

										_CB_importCert = function (result)
					{
						__SANDBOX.isFailed(result, gErrCallback);
						var _fn_final_callback = function () {
							gDialogObj.onconfirm(result);
						}
						_fn_final (_fn_final_callback);
					}

										_CB_loginPKCS11FromIndex = function (result)
					{
						if (result != 0) {
							var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
							var _fn_final_callback = function () {
								alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
								__67.disabled = false;
							}
							_fn_final (_fn_final_callback);
						}
						else
						{
							__SANDBOX.upInterface().importCert (gDialogObj.args.selectedMediaID,
																pin,
																gPkcs12PassInput,
																__14.value,
																"", "", "", "",
																_CB_importCert);
						}
					}
										__SANDBOX.upInterface().loginPKCS11FromIndex (gDialogObj.args.selectedMediaID,
																  pin,
																  _CB_loginPKCS11FromIndex);
				},
				oncancel: function() {
					verifyhsmDialog.dispose();
					__67.disabled = false;
				}
			});
			verifyhsmDialog.show();
		}
		else if (gMediaID == XWC.CERT_LOCATION_SECUREDISK)
		{
						_CB_importCert = function (result)
			{
				__SANDBOX.isFailed(result, gErrCallback);
				var _fn_final_callback = function () {
					gDialogObj.onconfirm(result);
				}
				_fn_final (_fn_final_callback);
			}
			
			_securedisk_login = function (aLoginResult)
			{
				if (aLoginResult != 0) {
					var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
					var _fn_final_callback = function () {
						alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
						__67.disabled = false;
					}
					_fn_final (_fn_final_callback);
				} else {
					__SANDBOX.upInterface().importCert (gDialogObj.args.selectedMediaID,
														gSavepasswdResult,
														gPkcs12PassInput,
														__14.value,
														"", "", "", "",
														_CB_importCert);
				}
			}
			
			_show_guidewindow ();
			
			__SANDBOX.upInterface().loginSecureDiskFromIndex (gDialogObj.args.selectedMediaID,
															  gSavepasswdResult,
															  "",
															  "",
															  "",
															  1,
															  _securedisk_login);
		}
		else
		{
						_CB_importCert = function (result)
			{
				__SANDBOX.isFailed(result, gErrCallback);
				gDialogObj.onconfirm(result);
			}
			
			__SANDBOX.upInterface().importCert (gDialogObj.args.selectedMediaID,
												gSavepasswdResult,
												gPkcs12PassInput,
												__14.value,
												"", "", "", "",
												_CB_importCert);
		}
    }
    else 
    {
		var aSignCertPath = "";
		var aSignKeyPath  = "";
		var aKMCertPath   = "";
		var aKMKeyPath    = "";

		if (__24.checked == true) {
			aSignCertPath = __32.value;
			aSignKeyPath  = __38.value;
		}
		if (__41.checked == true) {
			aKMCertPath   = __49.value;
			aKMKeyPath    = __55.value;
		}

				_CB_importCert = function (result)
		{
			gDialogObj.onconfirm (result);
		}

		__SANDBOX.upInterface().importCert (gDialogObj.args.selectedMediaID, 
											"", "", "",
											aSignCertPath,
											aSignKeyPath,
											aKMCertPath,
											aKMKeyPath,
											_CB_importCert);
	}
}

function onCancelButtonClick() {
	gDialogObj.oncancel();
}

function onSelectChange(e)
{
    e = e || window.event;
    if ( (e.target || e.srcElement).value == "pkcs12") {
		__10.style.display  = "block";
		__23.style.display = "none";
		gImportType = "pkcs12";
    }
    else {
		__10.style.display  = "none";
		__23.style.display = "block";
		gImportType = "x509bin";
    } 
}

function onX509SignCheckboxClick(e)
{
    e = e || window.event;
    if ( (e.target || e.srcElement).checked == true) {
		__32.disabled = false;
		__38.disabled  = false;
		__33.disabled = false;
		__39.disabled  = false;
    }
    else {
		__32.disabled = true;
		__38.disabled  = true;
		__33.disabled = true;
		__39.disabled  = true;;
    }
}

function onX509KMCheckboxClick(e)
{
    e = e || window.event;
    if ( (e.target || e.srcElement).checked == true) {
		__49.disabled = false;
		__55.disabled  = false;
		__50.disabled = false;
		__56.disabled  = false;
    }
    else {
		__49.disabled = true;
		__55.disabled  = true;
		__50.disabled = true;
		__56.disabled  = true;
    }
}

function onPKCS12FileButtonClick()
{
	openFileDialog("", function(result) { 
	__14.value = result;
    });
}

function onX509SignCertButtonClick()
{
    openFileDialog("fileonly", function(result) { 
	__32.value = result;
    });
}

function onX509SignKeyButtonClick()
{
    openFileDialog("fileonly", function(result) { 
	__38.value = result;
    });
}

function onX509KMCertButtonClick()
{
    openFileDialog("fileonly", function(result) { 
	__49.value = result;
    });
}

function onX509KMKeyButtonClick()
{
    openFileDialog("fileonly", function(result) { 
	__55.value = result;
    });
}

function onX509DirButtonClick()
{
    openFileDialog("dironly", function(result) { 
	__32.value = result + "/signCert.der";
	__38.value  = result + "/signPri.key";
	__49.value   = result + "/kmCert.der";
	__55.value    = result + "/kmPri.key";	
    });	
}

function openFileDialog(option, _onconfirm)
{
    var module = __SANDBOX.loadModule("fileselect"),
		dialog;

		AnySign.SetUITarget (__17);
		dialog = module({	
		args: {	searchType:	option, 
				extType: 	1, 
				isPFXFile: true,
				isSaveMode: false
			},
		onconfirm: function(result) { _onconfirm(result); dialog.dispose(); },
		oncancel: function(e) { dialog.dispose(); }
		});
	dialog.show();
}

function XWC_UI_WizardView(aElement,
			   aNextButtonClickListeners,
			   aPrevButtonClickListeners)
{
    var mPages = new Array();
    var mCurrentPageIndex = 0;
    var mNextButtonClickListeners = aNextButtonClickListeners;
    var mPrevButtonClickListeners = aPrevButtonClickListeners;
	var mComplete = '';
    
        var temp = aElement.firstChild;
    while (temp) {
		if (temp.nodeName.toLowerCase() == "div") 
		    mPages.push(temp);
		temp = temp.nextSibling;
    }

    for (i = 0; i < mPages.length; i++)
		hide(mPages[i]);

    show(mPages[0]);
    __66.disabled = true;

    XWC.Event.add(__67, "click", function(e) {
		__67.disabled = true;
		
		_CB_nextButtonClickListeners = function (result)
		{
			if (!result)
			{
				__67.disabled = false;
				return;
			}
			
			if (mCurrentPageIndex == 0)
				__66.disabled = false;
			
						if (mCurrentPageIndex == mPages.length-2) {
				var aInputType = __SANDBOX.getInputType(gMediaID);
				
				if (gMediaID != XWC.CERT_LOCATION_PKCS11){
					var module = __SANDBOX.loadModule("savepasswd");
					AnySign.SetUITarget (__67);
					var savepasswdDialog = module({
						width: 350,
						height: 190,
						onconfirm: function(aResult) { 
							gSavepasswdResult = aResult;
							savepasswdDialog.dispose();
							__67.disabled = false;
							__67.innerHTML = XWC.S.button_complete;
							hide(mPages[mCurrentPageIndex]);
							show(mPages[++mCurrentPageIndex]);
						},
						oncancel: function() {
							savepasswdDialog.dispose();
							__67.disabled = false;
						},
						args: {messageType: "import", inputType: aInputType}
					});
					savepasswdDialog.show();
				}
				else {
					__67.disabled = false;
					__67.innerHTML = XWC.S.button_complete;
					hide(mPages[mCurrentPageIndex]);
					show(mPages[++mCurrentPageIndex]);
				}
			}
		}

		if (mNextButtonClickListeners && mNextButtonClickListeners[mCurrentPageIndex])
			mNextButtonClickListeners[mCurrentPageIndex](_CB_nextButtonClickListeners);
		else if (mCurrentPageIndex == mPages.length-1)
			onComplete(mComplete);
    });

    XWC.Event.add(__66, "click", function(e) {

		_CB_prevButtonClickListeners = function ()
		{
			if (mCurrentPageIndex == 1)
				__66.disabled = true;

			if (mCurrentPageIndex-1 >= 0) {
				hide(mPages[mCurrentPageIndex]);
				show(mPages[--mCurrentPageIndex]);
			}
		}

		if (mPrevButtonClickListeners && mPrevButtonClickListeners[mCurrentPageIndex])
		{
			mPrevButtonClickListeners[mCurrentPageIndex](_CB_prevButtonClickListeners);
		}
		else if(mCurrentPageIndex == mPages.length-1)
		{
			__67.disabled = false;
			__67.innerHTML = XWC.S.button_next;
			hide(mPages[mCurrentPageIndex]);
			show(mPages[--mCurrentPageIndex]);
		}
    });

    function show(element) { element.style.display = "block"; }
    function hide(element) { element.style.display = "none"; }
}

function onInputMouseCheckBoxClick(aEvent) {
	var aChecked = false;
	var aTransKey = false;

	aEvent = aEvent || window.event;

	if (aEvent.target) {
		aChecked = aEvent.target.checked;
	}
	else {
		aChecked = aEvent.srcElement.checked;
	}

	aTransKey = import_tk1;

	if (aChecked) {
		aTransKey.useTransKey = true;
		__22.readOnly = true;
		showTransKeyBtn("import_tk1");
		aTransKey.clear();
	}
	else {
		aTransKey.useTransKey = false;
		__22.readOnly = false;
		aTransKey.clear();
		aTransKey.close();
	}
}


var __1 = XWC.UI.createElement('DIV');
__1.style.width = '400px';
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
__5.className = 'xwup-import-area';
var __6 = XWC.UI.createElement('DIV');
__6.setAttribute('id', 'xwup_page1', 0);
var __7 = XWC.UI.createElement('SELECT');
__7.setAttribute('tabindex', '4', 0);
__7.setAttribute('id', 'xwup_select', 0);
__7.className = 'xwup-select-sert';
__7.onchange = function(event) {onSelectChange(event);};
var __8 = XWC.UI.createElement('OPTION');
__8.setAttribute('value', 'pkcs12', 0);
__8.appendChild(document.createTextNode(XWC.S.pkcs12));
__7.appendChild(__8);
__6.appendChild(__7);
var __9 = XWC.UI.createElement('DIV');
var __10 = XWC.UI.createElement('DIV');
__10.setAttribute('id', 'xwup_pkcs12_outline', 0);
var __11 = XWC.UI.createElement('DIV');
__11.className = 'xwup-tit-import';
var __12 = XWC.UI.createElement('LABEL');
__12.htmlFor = 'xwup_import_pkcs12FileInput';
__12.appendChild(document.createTextNode(XWC.S.selPFXLabel));
__11.appendChild(__12);
__10.appendChild(__11);
var __13 = XWC.UI.createElement('TEXTAREA');
__13.setAttribute('tabindex', '4', 0);
__13.setAttribute('title', XWC.S.xvvcursor_guide, 0);
__13.setAttribute('id', 'xwup_xvvcursor_disabled', 0);
__13.className = 'blank0';
__13.setAttribute('disabled', 'disabled', 0);
__10.appendChild(__13);
var __14 = XWC.UI.createElement('INPUT');
__14.setAttribute('tabindex', '4', 0);
__14.setAttribute('id', 'xwup_import_pkcs12FileInput', 0);
__14.setAttribute('type', 'text', 0);
__14.className = 'xwup-input-imfile';
__14.setAttribute('readOnly', 'readonly', 0);
__10.appendChild(__14);
var __15 = XWC.UI.createElement('DIV');
__15.className = 'xwup-buttons-layout3';
var __16 = XWC.UI.createElement('TEXTAREA');
__16.setAttribute('tabindex', '4', 0);
__16.setAttribute('title', XWC.S.xvvcursor_guide, 0);
__16.setAttribute('id', 'xwup_xvvcursor_disabled', 0);
__16.className = 'blank0';
__16.setAttribute('disabled', 'disabled', 0);
__15.appendChild(__16);
var __17 = XWC.UI.createElement('BUTTON');
__17.setAttribute('tabindex', '4', 0);
__17.setAttribute('type', 'button', 0);
__17.setAttribute('id', 'xwup_pkcs12_find', 0);
__17.className = 'w100';
__17.onclick = function(event) {onPKCS12FileButtonClick(event);};
__17.appendChild(document.createTextNode(XWC.S.findPFX));
__15.appendChild(__17);
__10.appendChild(__15);
var __18 = XWC.UI.createElement('FORM');
if (__SANDBOX.IEVersion <= 8) {
__18.mergeAttributes(XWC.UI.createElement("<FORM name='xwup_import_tek_form'>"),false);
} else {
__18.setAttribute('name', 'xwup_import_tek_form', 0);
}
__18.setAttribute('id', 'xwup_import_tek_form', 0);
__18.onsubmit = function(event) {return false;};
var __19 = XWC.UI.createElement('DIV');
__19.className = 'xwup-import-passwd';
__19.setAttribute('id', 'import_tk1', 0);
var __20 = XWC.UI.createElement('DIV');
__20.className = 'xwup-tit-import';
var __21 = XWC.UI.createElement('LABEL');
__21.htmlFor = 'xwup_import_tek_input1';
__21.appendChild(document.createTextNode(XWC.S.PFXPassLabel));
__20.appendChild(__21);
__19.appendChild(__20);
var __22 = XWC.UI.createElement('INPUT');
__22.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__22.mergeAttributes(XWC.UI.createElement("<INPUT name='import_tek_input1'>"),false);
} else {
__22.setAttribute('name', 'import_tek_input1', 0);
}
__22.setAttribute('id', 'xwup_import_tek_input1', 0);
__22.className = 'xwup-input-imfile2';
__22.setAttribute('type', 'password', 0);
__22.setAttribute('kbd', 'qwerty_crt', 0);
__19.appendChild(__22);
__18.appendChild(__19);
__10.appendChild(__18);
__9.appendChild(__10);
var __23 = XWC.UI.createElement('DIV');
__23.setAttribute('id', 'xwup_x509bin_outline', 0);
__23.style.display = 'none';
var __24 = XWC.UI.createElement('INPUT');
__24.setAttribute('tabindex', '4', 0);
__24.setAttribute('id', 'xwup_x509cert_checkbox', 0);
__24.setAttribute('type', 'checkbox', 0);
__24.onclick = function(event) {onX509SignCheckboxClick(event);};
__24.setAttribute('checked', '', 0);
__23.appendChild(__24);
var __25 = XWC.UI.createElement('SPAN');
__25.style.fontWeight = 'bold';
__25.appendChild(document.createTextNode(XWC.S.X509Sign));
__23.appendChild(__25);
var __26 = XWC.UI.createElement('TABLE');
var __27 = XWC.UI.createElement('TBODY');
var __28 = XWC.UI.createElement('TR');
var __29 = XWC.UI.createElement('TD');
var __30 = XWC.UI.createElement('SPAN');
__30.style.fontSize = '11px';
__30.style.marginRight = '3px';
__30.appendChild(document.createTextNode(XWC.S.cert));
__29.appendChild(__30);
__28.appendChild(__29);
var __31 = XWC.UI.createElement('TD');
var __32 = XWC.UI.createElement('INPUT');
__32.setAttribute('tabindex', '4', 0);
__32.style.width = '260px';
__32.setAttribute('type', 'text', 0);
__31.appendChild(__32);
var __33 = XWC.UI.createElement('BUTTON');
__33.setAttribute('tabindex', '4', 0);
__33.setAttribute('type', 'button', 0);
__33.onclick = function(event) {onX509SignCertButtonClick(event);};
__33.appendChild(document.createTextNode('...'));
__31.appendChild(__33);
__28.appendChild(__31);
__27.appendChild(__28);
var __34 = XWC.UI.createElement('TR');
var __35 = XWC.UI.createElement('TD');
var __36 = XWC.UI.createElement('SPAN');
__36.style.fontSize = '11px';
__36.style.marginRight = '3px';
__36.appendChild(document.createTextNode(XWC.S.key));
__35.appendChild(__36);
__34.appendChild(__35);
var __37 = XWC.UI.createElement('TD');
var __38 = XWC.UI.createElement('INPUT');
__38.setAttribute('tabindex', '4', 0);
__38.style.width = '260px';
__38.setAttribute('type', 'text', 0);
__37.appendChild(__38);
var __39 = XWC.UI.createElement('BUTTON');
__39.setAttribute('tabindex', '4', 0);
__39.setAttribute('type', 'button', 0);
__39.onclick = function(event) {onX509SignKeyButtonClick(event);};
__39.appendChild(document.createTextNode('...'));
__37.appendChild(__39);
__34.appendChild(__37);
__27.appendChild(__34);
__26.appendChild(__27);
__23.appendChild(__26);
var __40 = XWC.UI.createElement('DIV');
__40.className = 'blank10';
__23.appendChild(__40);
var __41 = XWC.UI.createElement('INPUT');
__41.setAttribute('type', 'checkbox', 0);
__41.onclick = function(event) {onX509KMCheckboxClick(event);};
__23.appendChild(__41);
var __42 = XWC.UI.createElement('SPAN');
__42.style.fontWeight = 'bold';
__42.appendChild(document.createTextNode(XWC.S.X509KM));
__23.appendChild(__42);
var __43 = XWC.UI.createElement('TABLE');
var __44 = XWC.UI.createElement('TBODY');
var __45 = XWC.UI.createElement('TR');
var __46 = XWC.UI.createElement('TD');
var __47 = XWC.UI.createElement('SPAN');
__47.style.fontSize = '11px';
__47.style.marginRight = '3px';
__47.appendChild(document.createTextNode(XWC.S.cert));
__46.appendChild(__47);
__45.appendChild(__46);
var __48 = XWC.UI.createElement('TD');
var __49 = XWC.UI.createElement('INPUT');
__49.setAttribute('tabindex', '4', 0);
__49.style.width = '260px';
__49.setAttribute('type', 'text', 0);
__49.setAttribute('disabled', 'disabled', 0);
__48.appendChild(__49);
var __50 = XWC.UI.createElement('BUTTON');
__50.setAttribute('tabindex', '4', 0);
__50.setAttribute('type', 'button', 0);
__50.onclick = function(event) {onX509KMCertButtonClick(event);};
__50.setAttribute('disabled', 'disabled', 0);
__50.appendChild(document.createTextNode('...'));
__48.appendChild(__50);
__45.appendChild(__48);
__44.appendChild(__45);
var __51 = XWC.UI.createElement('TR');
var __52 = XWC.UI.createElement('TD');
var __53 = XWC.UI.createElement('SPAN');
__53.style.fontSize = '11px';
__53.style.marginRight = '3px';
__53.appendChild(document.createTextNode(XWC.S.key));
__52.appendChild(__53);
__51.appendChild(__52);
var __54 = XWC.UI.createElement('TD');
var __55 = XWC.UI.createElement('INPUT');
__55.setAttribute('tabindex', '4', 0);
__55.style.width = '260px';
__55.setAttribute('type', 'text', 0);
__55.setAttribute('disabled', 'disabled', 0);
__54.appendChild(__55);
var __56 = XWC.UI.createElement('BUTTON');
__56.setAttribute('tabindex', '4', 0);
__56.setAttribute('type', 'button', 0);
__56.onclick = function(event) {onX509KMKeyButtonClick(event);};
__56.setAttribute('disabled', 'disabled', 0);
__56.appendChild(document.createTextNode('...'));
__54.appendChild(__56);
__51.appendChild(__54);
__44.appendChild(__51);
__43.appendChild(__44);
__23.appendChild(__43);
var __57 = XWC.UI.createElement('DIV');
__57.style.height = '5px';
__23.appendChild(__57);
var __58 = XWC.UI.createElement('DIV');
var __59 = XWC.UI.createElement('BUTTON');
__59.setAttribute('tabindex', '4', 0);
__59.setAttribute('type', 'button', 0);
__59.onclick = function(event) {onX509DirButtonClick(event);};
__59.appendChild(document.createTextNode(XWC.S.seldir));
__58.appendChild(__59);
__23.appendChild(__58);
__9.appendChild(__23);
__6.appendChild(__9);
__5.appendChild(__6);
var __60 = XWC.UI.createElement('DIV');
__60.setAttribute('id', 'xwup_page2', 0);
__60.style.display = 'none';
var __61 = XWC.UI.createElement('DIV');
__61.className = 'xwup-complete-page';
var __62 = XWC.UI.createElement('IMG');
__62.setAttribute('src', AnySign.mBasePath+'/img/wizimg01.png', 0);
__62.setAttribute('width', '140', 0);
__62.setAttribute('height', '220', 0);
__62.setAttribute('alt', XWC.S.ready, 0);
__61.appendChild(__62);
var __63 = XWC.UI.createElement('P');
__63.className = 'xwup-txt-notice';
__63.appendChild(document.createTextNode(XWC.S.end));
__61.appendChild(__63);
__60.appendChild(__61);
__5.appendChild(__60);
__4.appendChild(__5);
var __64 = XWC.UI.createElement('DIV');
__64.className = 'xwup-buttons-layout';
var __65 = XWC.UI.createElement('BUTTON');
__65.setAttribute('tabindex', '4', 0);
__65.setAttribute('type', 'button', 0);
__65.setAttribute('id', 'xwup_cancel', 0);
__65.onclick = function(event) {onCancelButtonClick()};
__65.appendChild(document.createTextNode(XWC.S.button_cancel));
__64.appendChild(__65);
var __66 = XWC.UI.createElement('BUTTON');
__66.setAttribute('tabindex', '4', 0);
__66.setAttribute('type', 'button', 0);
__66.setAttribute('id', 'xwup_previous', 0);
__66.appendChild(document.createTextNode(XWC.S.button_prev));
__64.appendChild(__66);
var __67 = XWC.UI.createElement('BUTTON');
__67.setAttribute('tabindex', '4', 0);
__67.setAttribute('type', 'button', 0);
__67.setAttribute('id', 'xwup_next', 0);
__67.appendChild(document.createTextNode(XWC.S.button_next));
__64.appendChild(__67);
__4.appendChild(__64);
__1.appendChild(__4);
var __68 = XWC.UI.createElement('IFRAME');
__68.className = 'not';
__1.appendChild(__68);
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
