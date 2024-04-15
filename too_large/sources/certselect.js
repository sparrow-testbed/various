var __certselect = function(__SANDBOX) {
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

certselect_tk1 = null; var gCertList,
	gMediaRadio,
	gProviderName,
	gSelectedSubjectRDN,
	gSelectedIssuerRDN,
	gSelectedCertSerial,
	gSelectedCertClass,
	gSelectedRowIndex,
	gSelectedMediaID,
	gSelectedButton = 1, 	gMaxButton = 12,
	gSelectedSmartCert = false,
	gCurrentStateList = [],
	gButtonList = ["xwup_media_hdd",
				   "xwup_media_removable",
				   "xwup_media_savetoken",
				   "xwup_media_pkcs11",
				   "xwup_media_mobile",
				   "xwup_media_smartcert",
				   "xwup_media_securedisk",
				   "xwup_media_nfciccard",
				   "xwup_media_localstorage",
				   "xwup_media_memorystorage",
				   "xwup_media_xfs",
				   "xwup_media_webpage",
				   "xwup_find",
				   "xwup_view",
				   "xwup_delete"],
	gCertTableView,
	gDialogObj,
	gPasswordTryCount = 1,
	gCertSerial,
	gSearchCondition,
	gCAList,
	gErrCallback,
	gNeedPassword,
	gDisablePasswordInput,
	gCertTableBody,
	gInputHandler,
	gInputHandler_4pc,
	gInputHandler_lite,
	gInputHandler_xfs,
	gInputHandler_e2e,
	gFilter,
	gPFXInfo,
	gMediaLength,
	gMediaPage = 1,
	gStorage,
	gEvent;

XWC.getLocaleResource("certselect", XWC.lang());

function onload(aDialogObj) {
	var header,
		info,
		html,
		certInfo,
		aTableNextBtn,
		aMediaType,
		aInputType,
		aCheckedRadioIndex = -1;
	
	gDialogObj = aDialogObj;
	gErrCallback = gDialogObj.args.errCallback || gErrCallback_common;
	gCertSerial = gDialogObj.args.certSerial || "";
	gSearchCondition = gDialogObj.args.searchCondition || 0;
	gCAList = gDialogObj.args.caList || "";
	gDisablePasswordInput = aDialogObj.args.disablePasswordInput;
	gFilter = aDialogObj.args.filter;
	gPFXInfo = {withPFX:false,pfxPath:"",passwd:""};
	gStorage = AnySign.mStorage;
	
		if (AnySign.mAnySignLiteSupport) {
		gSelectedMediaID = gDialogObj.args.certLocation || XWC.CERT_LOCATION_LOCALSTORAGE;
	} else if (AnySign.mWebPageStorageSupport) {
		gSelectedMediaID = gDialogObj.args.certLocation || XWC.CERT_LOCATION_WEBPAGE;
	} else if (AnySign.mXecureFreeSignSupport) {
		gSelectedMediaID = gDialogObj.args.certLocation || XWC.CERT_LOCATION_XECUREFREESIGN;
	} else {
		gSelectedMediaID = gDialogObj.args.certLocation || 1;
	}
	
	aInputType = __SANDBOX.getInputType(gSelectedMediaID);
	
	if (aInputType == "4pc" && AnySign.mAnySignLoad) {
		AnySign.mAnySignEnable = true;
	} else if (aInputType == "e2e" && AnySign.mWebPageStorageSupport) {
		AnySign.mAnySignEnable = false;
	} else if (aInputType == "xfs" && AnySign.mXecureFreeSignSupport) {
		AnySign.mAnySignEnable = false;
	} else {
		if (AnySign.mAnySignLiteSupport) {
			if (aInputType != "lite") {
				gSelectedMediaID = XWC.CERT_LOCATION_LOCALSTORAGE;
			}
			AnySign.mAnySignEnable = false;
		} else {
			if (!AnySign.mAnySignLoad) {
				gSelectedMediaID = -1;
			} else if (aInputType != "4pc") {
				gSelectedMediaID = 1;
			}
			AnySign.mAnySignEnable = true;
		}
	}
	
		aMediaType = Math.floor(parseInt(gSelectedMediaID, 10) / 100) * 100;
	aInputType = __SANDBOX.getInputType(gSelectedMediaID);
	
	if (!AnySign.mExtensionSetting.mExternalCallback.func)
		AnySign.mExtensionSetting.mExternalCallback.result = 0;
	
	if (!__SANDBOX.isIE())
		__4.style.display = "none";
	
		if (!(__SANDBOX.isIE() && navigator.userAgent.indexOf('Windows NT 6.2') >= 0)) {
		__120.onkeydown = function () { checkCaps(); };
		__120.onblur = function () { __100.style.display = 'none'; };
		setCapsLockToolTip(__120, __100, 100, 10);
	}
	
	aTableNextBtn = __111;
	function disabledFindButton() {
		__111.style.display = "none";
		__111.parentNode.style.verticalAlign = "middle";
		aTableNextBtn = __112
	}
	
	if (gDialogObj.type == "sign-no-pfx" ||
		gDialogObj.type == "renew" || gDialogObj.type == "revoke" ||
		gDialogObj.type == "envelope" || gDialogObj.type == "deenvelope") {
		disabledFindButton();
	}
	
	if (AnySign.mDivInsertOption > 0) {
			__6.style.display = "none";
			__138.parentNode.style.display = 'none';
			__139.style.display = 'none';
			__2.parentNode.parentNode.style.width = '600px';
			__2.parentNode.parentNode.style.border = '0';

			__2.style.height = '45px';

			__2.firstChild.style.height = '45px';
			__2.firstChild.style.color = '#000';
			__2.firstChild.style.backgroundImage = '';
			__2.firstChild.style.backgroundColor = '#fff';
	} else {
		__7.setAttribute("alt", XWC.S.banner_explain, 0);
		header = __6;
		
		if (gDialogObj.args.htmlData) {
			__7.style.display = "none";

			info = XWC.UI.createElement("div");
			info.className = "info-type1";
			info.appendChild(document.createTextNode(XWC.S.info));
			header.appendChild(info);

			html = XWC.UI.createElement("iframe");
			html.className = "frame-type1"; 
			html.frameBorder = "0px";
			header.appendChild(html);
			if (__SANDBOX.isIE() && location.hostname != document.domain) {
				html.src = 'javascript:(function(){document.open();document.domain="' + document.domain + '";document.close();})()';
			}

			html.contentWindow.document.write(gDialogObj.args.htmlData);
		} else {
			__7.style.display = "inline-block";
		}
		
		switch (gDialogObj.type) {
		case "sign":
			XWC.UI.setDragAndDrop(__2);
			__2.firstChild.appendChild(document.createTextNode(XWC.S.title));
			break;
		case "sign-no-pfx":
			XWC.UI.setDragAndDrop(__2);
			__2.firstChild.appendChild(document.createTextNode(XWC.S.title));
			break;
		case "renew":
			XWC.UI.setDragAndDrop(__2);
			__2.firstChild.appendChild(document.createTextNode(XWC.S.renew));
			break;
		case "revoke":
			XWC.UI.setDragAndDrop(__2);
			__2.firstChild.appendChild(document.createTextNode(XWC.S.revoke));
			break;
		case "envelope":
			XWC.UI.setDragAndDrop(__2);
			__2.firstChild.appendChild(document.createTextNode(XWC.S.selectenvelope));
			break;
		case "deenvelope":
			XWC.UI.setDragAndDrop(__2);
			__2.firstChild.appendChild(document.createTextNode(XWC.S.selectdeenvelope));
			break;
		}
	}

		gCertTableView = new XWC.UI.TableView(__71);

	gCertTableView.onSelectRow = function (aObject) {
		var aSelectedRowElement = gCertTableBody.rows[aObject.rowIndex - 1],
			aSelectedRowObject = gCertTableView.mSelectedRowObj,
			aIssuerRDN = aSelectedRowObject.getAttribute("issuer"),
			aCertSerial = aSelectedRowObject.getAttribute("serial"),
			aExpireAlert,
			aGrandMom,
			expireMessage,
			expireMessages,
			aElement,
			i;

		for (i = 0; i < gCertList.length; i++) {
			if (aIssuerRDN == gCertList[i][5] && aCertSerial == gCertList[i][6]) {
				gSelectedSubjectRDN = gCertList[i][2];
				gSelectedIssuerRDN = gCertList[i][5];
				gSelectedCertSerial = gCertList[i][6];
				gSelectedCertClass = gCertList[i][1];
				gSelectedRowIndex = i;
				break;
			}
		}
		
		aExpireAlert = __92;
		if (gCertList[gSelectedRowIndex][0] == 1) {
			aGrandMom = __71;

			aAddOffset = aGrandMom;

			aExpireAlert.style.top = aSelectedRowElement.offsetTop + aGrandMom.offsetTop - aGrandMom.scrollTop + aSelectedRowElement.offsetHeight + 4 - aExpireAlert.parentNode.offsetTop + "px";
			aExpireAlert.style.left = aSelectedRowElement.cells[1].offsetLeft + 60 + "px";


			expireMessage = XWC.S.willbeexpired.split("%s").join(gCertList[gSelectedRowIndex][4]);
			aElement = __95;
			while (aElement.firstChild) { aElement.removeChild(aElement.firstChild); }

			expireMessages = expireMessage.split("\n");
			for (i = 0; i < expireMessages.length; i++) {
				aElement.appendChild(document.createTextNode(expireMessages[i]));
				aElement.appendChild(XWC.UI.createElement("BR"));
			}
			
			aExpireAlert.style.display = "block";
			
			aGrandMom.onscroll = function () { aExpireAlert.style.display = "none"; };
			aExpireAlert.onclick = function () { aExpireAlert.style.display = "none"; };
			
			setTimeout (function () {if(gInputHandler) gInputHandler.refresh();}, 0);
			setTimeout (function () {if(gInputHandler) gInputHandler.clear();}, 0);
			try {
				setTimeout (function () {aExpireAlert.style.display = "none";}, 2200);
			} catch(ex) {
							}
		} else {
			aExpireAlert.style.display = "none";
			
			setTimeout (function () {if(gInputHandler) gInputHandler.refresh();}, 0);
			setTimeout (function () {if(gInputHandler) gInputHandler.clear();}, 0);
		}

	};

	gCertTableView.onRefresh = function (aData) {
		var tr, td, i, temp;
		gCertTableBody = __71.getElementsByTagName("table")[0].tBodies[0];
		gCertTableBody.removeAttribute("tabindex");
		if (aData.length == 1) {
			if (AnySign.mDivInsertOption == 0)
				gCertTableBody.setAttribute("tabindex", 3, 0);
			else 
				gCertTableBody.setAttribute("tabindex", 0, 0);
		}
		gCertList = aData;

		for (i = 0; i < aData.length; i++) {
			certInfo = aData[i];
			tr = XWC.UI.createElement("tr");
			tr.setAttribute("role", "row", 0);
			tr.setAttribute("aria-selected", "false", 0);
			tr.setAttribute('subject', certInfo[2]);
			tr.setAttribute("issuer", certInfo[5]);
			tr.setAttribute("serial", certInfo[6]);
			
			statusTextCell = gCertTableView.createTextCell(XWC.S["table_select"] + XWC.S["cert_status" + certInfo[0]]);
			statusTextCell.style.width = "0px";
			statusTextCell.style.height = "0px";
			statusTextCell.style.display = "none";

			td = XWC.UI.createElement("td");
			imageTextCell1 = gCertTableView.createImageTextCell(AnySign.mBasePath + "/img/cert" + certInfo[0] + ".png",
									   certInfo[1], XWC.S["cert_status" + certInfo[0]]);
						td.appendChild(statusTextCell);
			td.appendChild(imageTextCell1);
			tr.appendChild(td);

			td = XWC.UI.createElement("td");
			textCell1 = gCertTableView.createTextCell(XWC.Util.getCNFromRDN(certInfo[2]));
			td.appendChild(textCell1);
			tr.appendChild(td);

			td = XWC.UI.createElement("td");
			textCell2 = gCertTableView.createTextCell(certInfo[4]);
			textCell2.style.textAlign = "center";
			td.appendChild(textCell2);
			tr.appendChild(td);

			td = XWC.UI.createElement("td");
			textCell3 = gCertTableView.createTextCell(certInfo[3]);
			textCell3.style.textAlign = "center";
			td.appendChild(textCell3);
			tr.appendChild(td);

			if (AnySign.mDivInsertOption > 0)
				tr.setAttribute("tabindex", 3, 0);
			else
				tr.setAttribute("tabindex", 0, 0);
			
			tr.onkeydown = function(e) {
				e = e || window.event;

				var aKeyCode = e.which || e.keyCode;

				if (aKeyCode == 9 && e.shiftKey) {
					__71.focus();
				} else if (aKeyCode == 9) {
					aTableNextBtn.focus();
				} else if (aKeyCode == 32) {
					return false;
				} else {
					return true;
				}

				XWC.Event.stopPropagation(e);
				XWC.Event.preventDefault(e);
			};
			
			gCertTableBody.appendChild(tr);
		}
		
		var aTableRows = gCertTableBody.getElementsByTagName('tr');
		if (aTableRows.length > 0) {
			setTimeout (function () {gCertTableView.selectRow(aTableRows[0]);});
		}
	};

	gMediaRadio = XWC.UI.RadioButtonGroup([	__41,
											__44,
											__47,
											__50,
											__53,
											__56,
											__59,
											__68,
											__35,
											__38,
											__62,
											__65]);

	gMediaRadio.setDisabledAll();

	if (typeof AnySign.mLanguage === 'string' && AnySign.mLanguage.toLowerCase() == "en-us") {
		var media_localstorage = __35.firstChild.nextSibling;
		media_localstorage.className += " xwup-font10";
		var media_memorystorage = __38.firstChild.nextSibling;
		media_memorystorage.className += " xwup-font10";
		var media_hdd = __41.firstChild.nextSibling;
		media_hdd.className += " xwup-font10";
		var media_removable = __44.firstChild.nextSibling;
		media_removable.className += " xwup-font10";
		var media_savetoken = __47.firstChild.nextSibling;
		media_savetoken.className += " xwup-font10";
		var media_pkcs11 = __50.firstChild.nextSibling;
		media_pkcs11.className += " xwup-font10";
		var media_mobile = __53.firstChild.nextSibling;
		media_mobile.className += " xwup-font10";
		var media_smartcert = __56.firstChild.nextSibling;
		media_smartcert.className += " xwup-font10";
		var media_securedisk = __59.firstChild.nextSibling;
		media_securedisk.className += " xwup-font10";
		var media_nfciccard = __68.firstChild.nextSibling;
		media_nfciccard.className += " xwup-font10";
		var media_xfs = __62.firstChild.nextSibling;
		media_xfs.className += " xwup-font10";
		var media_webpage = __65.firstChild.nextSibling;
		media_webpage.className += " xwup-font10";

		__138.className = "xwup_btn_ok";
		__139.className = "xwup_btn_cancel";
	} else {
		var media_removable = __44.firstChild.nextSibling;
		media_removable.style.letterSpacing = "-2px";
		var media_smartcert = __56.firstChild.nextSibling;
		media_smartcert.style.letterSpacing = "-1px";
		var media_securedisk = __59.firstChild.nextSibling;
		media_securedisk.style.letterSpacing = "-1px";
	}

	if (__SANDBOX.IEVersion < 7) {
		__99.style.display = "none";
		__98.style.display = "none";
		__104.style.display = "none";
		__103.style.display = "none";
		__120.className = "certselect_input_type1";
		__125.className = "certselect_input_type1";
		__128.className = "certselect_input_type1";
		__131.className = "certselect_input_type1";
	}

	if (AnySign.mDivInsertOption > 0) {
		__2.removeAttribute("tabindex");
		__10.removeAttribute("tabindex");
		__41.removeAttribute("tabindex");
		__35.removeAttribute("tabindex");
		__38.removeAttribute("tabindex");
		__44.removeAttribute("tabindex");
		__47.removeAttribute("tabindex");
		__50.removeAttribute("tabindex");
		__53.removeAttribute("tabindex");
		__56.removeAttribute("tabindex");
		__59.removeAttribute("tabindex");
		__68.removeAttribute("tabindex");
		__62.removeAttribute("tabindex");
		__65.removeAttribute("tabindex");
		__71.removeAttribute("tabindex");
		__111.removeAttribute("tabindex");
		__112.removeAttribute("tabindex");
		__113.removeAttribute("tabindex");
		__120.removeAttribute("tabindex");
		__125.removeAttribute("tabindex");
		__128.removeAttribute("tabindex");
		__131.removeAttribute("tabindex");
		__138.removeAttribute("tabindex");
		__139.removeAttribute("tabindex");
	}
	
		if (AnySign.mXecureFreeSignSupport) {
		if (gStorage.indexOf("XFS") < 0) {
			gStorage = "XFS," + gStorage;
		}
		__SANDBOX.refreshCertLocationSet (gStorage);
	}
	
		if (AnySign.mWebPageStorageSupport) {
		if (gStorage.indexOf("WEBPAGE") < 0) {
			gStorage = "WEBPAGE," + gStorage;
		}
		__SANDBOX.refreshCertLocationSet (gStorage);
		
		if (AnySign.mStorage == "") {
			disabledFindButton();
			setDeleteButton(false);
		}
	}
	
		if (AnySign.mAnySignLiteSupport) {
		if (gStorage.indexOf("MEMORYSTORAGE") < 0) {
			gStorage = "MEMORYSTORAGE," + gStorage;
		}
		if (gStorage.indexOf("LOCALSTORAGE") < 0) {
			gStorage = "LOCALSTORAGE," + gStorage;
		}
		__SANDBOX.refreshCertLocationSet (gStorage);
		disabledFindButton();
	}
	
		if (gDialogObj.type == "envelope") {
		setPasswordInputDisable();
	} else {
				if (AnySign.mAnySignLiteSupport)
			createInputHandler_lite();
		
				if (AnySign.mXecureFreeSignSupport)
			createInputHandler_xfs();
		
				if (AnySign.mWebPageStorageSupport)
			createInputHandler_e2e();
		
				if (AnySign.mAnySignLoad)
			createInputHandler_4pc();
		
		switch (aInputType) {
		case "4pc":
			break;
		case "lite":
			setInputHandler("lite");
			break;
		case "xfs":
			setInputHandler("xfs");
			break;
		case "e2e":
			setInputHandler("e2e");
			break;
		default: 					}
		
		setPasswordInputEnable();
	}
	
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
				if (name == "localstorage" || name == "memorystorage") {
					mediaArray.push(name);
				}
			}
			if (AnySign.mXecureFreeSignSupport) {
				if (name == "xfs") {
					mediaArray.push(name);
				}
			}
			if (AnySign.mWebPageStorageSupport) {
				if (name == "webpage") {
					mediaArray.push(name);
				}
			}
			if (name == "hard" || name == "removable" || name == "pkcs11" || name == "smartcert" || name == "securedisk") {
				mediaArray.push(name);
			}
			if (name == "usbtoken" || name == "iccard" || name == "csp" || name == "kepcoiccard") {
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
			if (name == "nfciccard") {
				mediaArray.push(name);
			}
		}
		return mediaArray;
	}
	
	var mediaArray = getMediaArray();
	var locationArray = new Array();
	var index = 0;
	gMediaLength = mediaArray.length;
	
	locationArray.push(__15);
	locationArray.push(__16);
	locationArray.push(__17);
	locationArray.push(__18);
	locationArray.push(__19);
	locationArray.push(__20);
	locationArray.push(__21);
	locationArray.push(__22);
	locationArray.push(__23);
	locationArray.push(__24);
	locationArray.push(__25);
	locationArray.push(__26);
	locationArray.push(__27);
	locationArray.push(__28);
	locationArray.push(__29);
	
	for (index = 0; index < mediaArray.length; index++) {
		switch (mediaArray[index]) {
		case "localstorage":
			locationArray[index].appendChild(__35);
			__35.style.display = "block";
			break;
		case "memorystorage":
			locationArray[index].appendChild(__38);
			__38.style.display = "block";
			break;
		case "hard":
			locationArray[index].appendChild(__41);
			__41.style.display = "block";
			break;
		case "removable":
			locationArray[index].appendChild(__44);
			__44.style.display = "block";
			break;
		case "usbtoken":
			locationArray[index].appendChild(__47);
			__47.style.display = "block";
			break;
		case "pkcs11":
			locationArray[index].appendChild(__50);
			__50.style.display = "block";
			break;
		case "mobile":
			locationArray[index].appendChild(__53);
			__53.style.display = "block";
			break;
		case "smartcert":
			locationArray[index].appendChild(__56);
			__56.style.display = "block";
			break;
		case "securedisk":
			locationArray[index].appendChild(__59);
			__59.style.display = "block";
			break;
		case "nfciccard":
			locationArray[index].appendChild(__68);
			__68.style.display = "block";
			break;
		case "xfs":
			locationArray[index].appendChild(__62);
			__62.style.display = "block";
			break;
		case "webpage":
			locationArray[index].appendChild(__65);
			__65.style.display = "block";
			break;
		default:
		}
	}
	
	var aSelectMediaName;
	switch (aMediaType) {
	case XWC.CERT_LOCATION_HARD: 		if (__41.style.display == "block") {
			aCheckedRadioIndex = 0;
			aSelectMediaName = "hard";
		}
		break;
	case XWC.CERT_LOCATION_REMOVABLE: 		if (__44.style.display == "block") {
			aCheckedRadioIndex = 1;
			aSelectMediaName = "removable";
		}
		break;
	case XWC.CERT_LOCATION_ICCARD: 	case XWC.CERT_LOCATION_KEPCOICCARD: 		if (__47.style.display == "block") {
			aCheckedRadioIndex = 2;
			aSelectMediaName = "usbtoken";
		}
		break;
	case XWC.CERT_LOCATION_PKCS11: 		if (__50.style.display == "block") {
			aCheckedRadioIndex = 3;
			aSelectMediaName = "pkcs11";
		}
		break;
	case XWC.CERT_LOCATION_YESSIGNM: 	case XWC.CERT_LOCATION_MPHONE: 		if (__53.style.display == "block") {
			aCheckedRadioIndex = 4;
			aSelectMediaName = "mobile";
		}
		break;
	case XWC.CERT_LOCATION_LOCALSTORAGE: 		if (__35.style.display == "block") {
			aCheckedRadioIndex = 8;
			aSelectMediaName = "localstorage";
		}
		break;
	case XWC.CERT_LOCATION_MEMORYSTORAGE: 		if (__38.style.display == "block") {
			aCheckedRadioIndex = 9;
			aSelectMediaName = "memorystorage";
		}
		break;
	case XWC.CERT_LOCATION_XECUREFREESIGN: 		if (__62.style.display == "block") {
			aCheckedRadioIndex = 10;
			aSelectMediaName = "xfs";
		}
		break;
	case XWC.CERT_LOCATION_WEBPAGE: 		if (__65.style.display == "block") {
			aCheckedRadioIndex = 11;
			aSelectMediaName = "webpage";
		}
		break;
	default:
			}
	
	if (aCheckedRadioIndex == -1) {
		aMediaType = -1;
		gSelectedMediaID = -1;
	}
	
	var aSelectMediaIndex = mediaArray.indexOf(aSelectMediaName);
	
				if (mediaArray.length < 6) {
		__15.style.display = "";
		__16.style.display = "";
		__17.style.display = "";
		__18.style.display = "";
		__19.style.display = "";
	}
	else if (mediaArray.length == 6) {		
		__15.style.width = "16%";
		__15.firstChild.style.width = "67px";
		__15.firstChild.style.padding = "1px";
		__16.style.width = "16%";
		__16.firstChild.style.width = "67px";
		__16.firstChild.style.padding = "1px";
		__17.style.width = "16%";
		__17.firstChild.style.width = "67px";
		__17.firstChild.style.padding = "1px";
		__18.style.width = "16%";
		__18.firstChild.style.width = "67px";
		__18.firstChild.style.padding = "1px";
		__19.style.width = "16%";
		__19.firstChild.style.width = "67px";
		__19.firstChild.style.padding = "1px";
		__20.style.width = "16%";
		__20.firstChild.style.width = "67px";
		__20.firstChild.style.padding = "1px";
		
		__15.style.display = "";
		__16.style.display = "";
		__17.style.display = "";
		__18.style.display = "";
		__19.style.display = "";
		__20.style.display = "";
	}
	else if (mediaArray.length > 6) {
						__33.getElementsByTagName("span")[0].className = "xwup-ico-arrow-left-disabled";
		__31.getElementsByTagName("span")[0].className = "xwup-ico-arrow-right";
		
		__30.style.width = "5%";
		
		for (index = 0; index < locationArray.length; index++) {
			locationArray[index].style.width = "19%";
			if(locationArray[index].firstChild)
				locationArray[index].firstChild.style.width = "70px";
		}
		
		__30.style.display = "";
		__15.style.display = "";
		__16.style.display = "";
		__17.style.display = "";
		__18.style.display = "";
		__19.style.display = "";
		
		if(aSelectMediaIndex > 4)
			onMediaRight();
		if(aSelectMediaIndex > 9)
			onMediaRight();
	}
	
	if (AnySign.mStorageEnable == false)
		__9.style.display = "none";

		_setMediaRadio = function ()
	{
		gMediaRadio.setLocationEnable("hard", __41);
		gMediaRadio.setLocationEnable("removable", __44);
		gMediaRadio.setLocationEnable("usbtoken", __47, true);
		gMediaRadio.setLocationEnable("pkcs11", __50, true);
		gMediaRadio.setLocationEnable("mobile", __53, true);
		gMediaRadio.setLocationEnable("smartcert", __56, true);
		gMediaRadio.setLocationEnable("securedisk", __59, true);
		gMediaRadio.setLocationEnable("nfciccard", __68, true);
		gMediaRadio.setLocationEnable("localstorage", __35);
		gMediaRadio.setLocationEnable("memorystorage", __38);
		gMediaRadio.setLocationEnable("xfs", __62);
		gMediaRadio.setLocationEnable("webpage", __65);
		
		if ((__SANDBOX.certLocationSet["mphone"]) || (__SANDBOX.certLocationSet["mobisign"]))
			gMediaRadio.setDisabled (__53, false);
		
		if (AnySign.mPlatform.aName.indexOf("mac") == 0 || AnySign.mPlatform.aName.indexOf("linux") == 0)
		{
			gMediaRadio.setDisabled (__47, true);
			gMediaRadio.setDisabled (__50, true);
			gMediaRadio.setDisabled (__53, true);
			gMediaRadio.setDisabled (__56, true);
			gMediaRadio.setDisabled (__59, true);
		}
		
				if (gDialogObj.args.funcname == "SignFile" || gDialogObj.args.funcname == "MultiFileSign") {
			gMediaRadio.setDisabled (__47, true);
			gMediaRadio.setDisabled (__50, true);
			gMediaRadio.setDisabled (__59, true);
		}
		
				if (gDialogObj.args.funcname == "SignFileEx" || gDialogObj.args.funcname == "SignFileExWithVID") {
			gMediaRadio.setDisabled (__59, true);
		}
		
				if (gDialogObj.args.funcname == "EnvelopeFileWithCert" || gDialogObj.args.funcname == "DeEnvelopeFileWithCert") {
			gMediaRadio.setDisabled (__47, true);
			gMediaRadio.setDisabled (__53, true);
			gMediaRadio.setDisabled (__59, true);
		}
		
		if (gDialogObj.args.funcname == "EnvelopeDataWithCert" || gDialogObj.args.funcname == "DeEnvelopeDataWithCert") {
			gMediaRadio.setDisabled (__59, true);
			gMediaRadio.setDisabled (__68, true);
			gMediaRadio.setDisabled (__65, true);
			
			if (gDialogObj.args.funcname == "EnvelopeDataWithCert" && gDialogObj.args.multicert == true) {
				if (AnySign.mAnySignEnable == true) {
					gMediaRadio.setDisabled (__35, true);
					gMediaRadio.setDisabled (__38, true);
				} else {
					gMediaRadio.setDisabled (__41, true);
					gMediaRadio.setDisabled (__44, true);
					gMediaRadio.setDisabled (__47, true);
					gMediaRadio.setDisabled (__50, true);
					gMediaRadio.setDisabled (__53, true);
					gMediaRadio.setDisabled (__56, true);
					
					if(gDialogObj.args.disablePFX == true)
						gMediaRadio.setDisabled (__38, true);
				}
			}
		}
		
		if (__SANDBOX.certLocationSet["smartcert"]) {
			if (gDialogObj.type.indexOf("sign") < 0) { 				gMediaRadio.setDisabled (__56, true);
			}
			if (gDialogObj.args.funcname == "SignFile" || gDialogObj.args.funcname == "MultiFileSign" ||
				gDialogObj.args.funcname == "SignFileEx" || gDialogObj.args.funcname == "SignFileExWithVID" ||
				gDialogObj.args.funcname == "EnvelopeFileWithCert" || gDialogObj.args.funcname == "DeEnvelopeFileWithCert") {
				gMediaRadio.setDisabled (__56, true);
			}
		}
		
		if (gDialogObj.type == "renew") {
			gMediaRadio.setDisabled (__68, true);
			gMediaRadio.setDisabled (__38, true);
			gMediaRadio.setDisabled (__62, true);
			gMediaRadio.setDisabled (__65, true);
		}
		
		if (gDialogObj.args.funcname == "GetCertPath") {
			gMediaRadio.setDisabled (__47, true);
			gMediaRadio.setDisabled (__50, true);
			gMediaRadio.setDisabled (__53, true);
			gMediaRadio.setDisabled (__56, true);
			gMediaRadio.setDisabled (__59, true);
			gMediaRadio.setDisabled (__68, true);
			gMediaRadio.setDisabled (__35, true);
			gMediaRadio.setDisabled (__38, true);
			gMediaRadio.setDisabled (__62, true);
			gMediaRadio.setDisabled (__65, true);
		}
		
		if (gDialogObj.args.funcname == "SignDataAdd" || gDialogObj.args.funcname == "DeEnvelopeDataWithCert") {
			if (AnySign.mXecureFreeSignData.signType != "client")
				gMediaRadio.setDisabled (__62, true);
		}
		
		if (aCheckedRadioIndex >= 0) {
			gMediaRadio.setChecked(aCheckedRadioIndex);
		}
		
		if (__SANDBOX.isIE () > 7)
			setTimeout (function () {setFocus();}, 0);

		if (aMediaType == XWC.CERT_LOCATION_PKCS11)
		{
			setButtonManager("enabled");
			gNeedPassword = setPasswordInputEnable(false);
			__50.focus();
		}
	}
		_CB_getCertTree = function (aCertList) 
	{
		if (__SANDBOX.isFailed(aCertList))
			aCertList = "";

		refreshTableView(aCertList);
		
		_setMediaRadio();
	}
		_CB_getMediaList = function ()
	{
		var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();	
		if (aErrorObject.code == 20000008) {
			alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
			return;
		}
		
		__SANDBOX.upInterface().getCertTree(gSelectedMediaID, 2, gSearchCondition, 5, gCAList, gCertSerial, _CB_getCertTree);
	}
		_CB_setConvertTable = function ()
	{
		__SANDBOX.upInterface().getMediaList(aMediaType, 0, 1, _CB_getMediaList);
	}
		
	if (gSelectedMediaID >= 0) {
		__SANDBOX.setConvertTable(_CB_setConvertTable);
	} else {
		_setMediaRadio();
	}
	
	if (AnySign.mWBStyleApply)
	{
		var aButton = XWC.UI.createElement("a");
		var aParent = document.getElementById("xwup_body");

		if (AnySign.mDivInsertOption > 0) {
		} else {
			aButton.id = "xwup_close";
			aButton.title = XWC.S.close;
			aButton.setAttribute ("tabindex", 3, 0);
			aButton.setAttribute ("href", "javascript:;", 0);
			aButton.className = "xwup-close-button";
			aButton.onclick = function () { onCancelButtonClick(); };

			aParent.appendChild(aButton);
		}

		__138.className = "ok";
		__139.className = "cancel";

		aParent = __6;
		aImg = aParent.firstChild;

		var gHostName = document.location.hostname;
		if (gHostName == "w1sccd.wooribank.com" || gHostName == "sccd.wooribank.com" || gHostName == "pccd.wooribank.com")
			aImg.src = AnySign.mBasePath + "/img/banner_card.png";

		__121.style.display = 'inline-block';
		if (__SANDBOX.isIE () < 9) {
			__121.style.display = 'inline';
			__121.style.zoom = '1';
			__122.style.display = 'inline';
			__122.style.zoom = '1';
		}

		__122.style.backgroundImage = 'url(' + AnySign.mBasePath + '/img/off.png)';
		__122.style.backgroundRepeat = "no-repeat";
		if (__SANDBOX.isIE () < 9) {
					} else {
			__122.style.margin = '3px 0px 0px 6px';
		}
		__122.style.width = '29px';
		__122.style.height= '27px';
		__122.style.border = '0px';
		__122.onclick = function(event) {onInputMouseCheckBoxClick (event);};

		__120.style.border = '1.0px solid #0078d4';
	}
	else
	{
		__121.style.display = 'none';
        __122.style.display = 'none';
	}

	return 0;
}

function onMediaLeft() {
	
	if (gMediaPage == 2) {
		gMediaPage = 1;
		
		__15.style.display = "";
		__16.style.display = "";
		__17.style.display = "";
		__18.style.display = "";
		__19.style.display = "";
		
		__20.style.display = "none";
		__21.style.display = "none";
		__22.style.display = "none";
		__23.style.display = "none";
		__24.style.display = "none";
		
		__33.disabled = true;
		__33.getElementsByTagName("span")[0].className = "xwup-ico-arrow-left-disabled";
		__31.disabled = false;
		__31.getElementsByTagName("span")[0].className = "xwup-ico-arrow-right";
		
	} else if (gMediaPage == 3) {
		gMediaPage = 2;
		
		__20.style.display = "";
		__21.style.display = "";
		__22.style.display = "";
		__23.style.display = "";
		__24.style.display = "";
		
		__25.style.display = "none";
		__26.style.display = "none";
		__27.style.display = "none";
		__28.style.display = "none";
		__29.style.display = "none";
		
		__31.disabled = false;
		__31.getElementsByTagName("span")[0].className = "xwup-ico-arrow-right";
	}
}

function onMediaRight() {
	
	if (gMediaPage == 1) {
		gMediaPage = 2;
		
		__15.style.display = "none";
		__16.style.display = "none";
		__17.style.display = "none";
		__18.style.display = "none";
		__19.style.display = "none";
		
		__20.style.display = "";
		__21.style.display = "";
		__22.style.display = "";
		__23.style.display = "";
		__24.style.display = "";
		
		__33.disabled = false;
		__33.getElementsByTagName("span")[0].className = "xwup-ico-arrow-left";
		
		if (gMediaLength < 11) {
			__31.disabled = true;
			__31.getElementsByTagName("span")[0].className = "xwup-ico-arrow-right-disabled";
		}
		
	} else if (gMediaPage == 2) {
		gMediaPage = 3;
		
		__20.style.display = "none";
		__21.style.display = "none";
		__22.style.display = "none";
		__23.style.display = "none";
		__24.style.display = "none";
		
		__25.style.display = "";
		__26.style.display = "";
		__27.style.display = "";
		__28.style.display = "";
		__29.style.display = "";
		
		__33.disabled = false;
		__33.getElementsByTagName("span")[0].className = "xwup-ico-arrow-left";
		__31.disabled = true;
		__31.getElementsByTagName("span")[0].className = "xwup-ico-arrow-right-disabled";
	}
}

function setFocus() {
	if (gCertTableBody != undefined) 
	{
		var aTableRows = gCertTableBody.getElementsByTagName('tr');

		if (aTableRows.length > 0) {
			setTimeout (function () {
				if(gInputHandler) gInputHandler.refresh();
			});
		}
	}
	if (AnySign.mDivInsertOption == 0)
		__2.parentNode.focus();
}

function setOKButtonDisabled(aEnable) {
	__138.disabled = aEnable;
}

function onOKButtonClick(e) {
	var aGuideModule,
		aGuideDialog = null,
		aKeyword = null,
		aKeywordResult = 0,
		aPin = null,
		aMediaType;
	
	var pageDivInsertOption = AnySign.mDivInsertOption;
	
	aMediaType = Math.floor(parseInt(gSelectedMediaID, 10) / 100) * 100;
	setOKButtonDisabled(true);

		_callback = function ()
	{
		if(gInputHandler) gInputHandler.clear();
		setOKButtonDisabled(false);
	}
	
	_confirmCallback = function ()
	{
		gDialogObj.onconfirm({
			mediaID: gSelectedMediaID,
			providerName: gProviderName,
			smartCert: gSelectedSmartCert,
			subjectRDN : gSelectedSubjectRDN,
			issuerRDN : gSelectedIssuerRDN,
			certSerial : gSelectedCertSerial,
			passwd: aKeyword,
			passwdResult: aKeywordResult,
			pin: aPin,
			dialog: aGuideDialog,
			callback: _callback
		});
	}
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
		
		if (aMediaType == XWC.CERT_LOCATION_ICCARD || aMediaType == XWC.CERT_LOCATION_KEPCOICCARD) {
			__SANDBOX.upInterface().logoutStoreToken(gSelectedMediaID, _final_callback);
		} else if (aMediaType == XWC.CERT_LOCATION_PKCS11) {
			__SANDBOX.upInterface().finalizePKCS11FromName (gProviderName, _final_callback);
		} else if (aMediaType == XWC.CERT_LOCATION_SECUREDISK) {
			__SANDBOX.upInterface().finalizeSecureDiskFromName (gProviderName, _final_callback);
		} else {
			_final_callback ();
		}
	}
		
	if (gPFXInfo.withPFX == true) {
	
		gDialogObj.onconfirm({
							withPFX: gPFXInfo.withPFX,
							pfxPath: gPFXInfo.pfxPath,
							passwd: gPFXInfo.passwd,
							callback: _callback
		});
		gPFXInfo = {withPFX:false,pfxPath:"",passwd:""};
		
	}
	else
	{
		if (gSelectedMediaID != XWC.CERT_LOCATION_MPHONE + 1 && gSelectedSmartCert != true) {
			if (!gSelectedIssuerRDN || !gSelectedCertSerial) {
				alert(XWC.S.selecterror);
				setOKButtonDisabled(false);
				return;
			}
		} else {
			gSelectedSubjectRDN = "";
			gSelectedIssuerRDN = "";
			gSelectedCertSerial = "";
			gSelectedCertClass = "";
		}

		if (gNeedPassword == true)
		{
			if (gInputHandler.getLength() == 0) {
				alert(XWC.S.nokeyworderror);
				setOKButtonDisabled(false);
				return;
			}
			
						_open_savepasswd = function (aPFXCert)
			{
				var aSaveKeyword;
				_CB_setCertificateFromPFX = function (aResult)
				{
					if (aResult == 0) {
						if (gCertList[gSelectedRowIndex][0] == 1 && AnySign.mExpireDateAlert) {
							var aExpireMessage = XWC.S.willbeexpired.split("%s");
							aExpireMessage = aExpireMessage[0] + gCertList[gSelectedRowIndex][4] + aExpireMessage[1];
							aExpireMessage += "\n";
							aExpireMessage += XWC.S.renewplease1 + XWC.S.renewplease2;
							alert(aExpireMessage);
						}
						
						gDialogObj.onconfirm({
							mediaID: gSelectedMediaID,
							subjectRDN : gSelectedSubjectRDN,
							issuerRDN : gSelectedIssuerRDN,
							certSerial : gSelectedCertSerial,
							passwd: aSaveKeyword,
							callback: _callback
						});
					} else {
						var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
						alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
						setOKButtonDisabled(false);
					}
				}
				
				AnySign.mDivInsertOption = 0;
				var inputpasswdModule = __SANDBOX.loadModule("inputpasswd");
				var inputpasswdDialog = inputpasswdModule({
					args: {messageType: "certificate2",
						   descType: "copy",
						   inputType: "lite",
						   errCallback: gErrCallback},
					onconfirm: function(aResult) { 
						AnySign.mDivInsertOption = pageDivInsertOption;
						inputpasswdDialog.dispose();
						aSaveKeyword = aResult;
						
						__SANDBOX.upInterface().importCertFromPFX (gSelectedMediaID,
																   null,
																   aSaveKeyword,
																   aPFXCert,
																   null, null, null, null, null,
																   1,
																   _CB_setCertificateFromPFX);
					},
					oncancel: function() {
						AnySign.mDivInsertOption = pageDivInsertOption;
						inputpasswdDialog.dispose();
						setOKButtonDisabled(false);
					}
				});
				inputpasswdDialog.show();
			}
			
						_resultCheckFun = function (aResult)
			{
				if (gSelectedMediaID == XWC.CERT_LOCATION_XECUREFREESIGN && AnySign.mXecureFreeSignData.signType == "client") {
					if (aResult) {
						_open_savepasswd (aResult);
						return;
					}
				} else {
					if (aResult == 0) {
						if (gCertList[gSelectedRowIndex][0] == 1 && AnySign.mExpireDateAlert) {
							var aExpireMessage = XWC.S.willbeexpired.split("%s");
							aExpireMessage = aExpireMessage[0] + gCertList[gSelectedRowIndex][4] + aExpireMessage[1];
							aExpireMessage += "\n";
							aExpireMessage += XWC.S.renewplease1 + XWC.S.renewplease2;
							alert(aExpireMessage);
						}
						_confirmCallback ();
						return;
					}
				}
				
				var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
				if (aErrorObject.code == 22000015) {
					if (confirm(XWC.S.incorrect_kmcertPW)) {
												_confirmCallback ();
						return;
					}
				}
				
				var _fn_final_callback = function ()
				{
					gInputHandler.clear();
					
					if (aErrorObject.code == 22000015) {
						setOKButtonDisabled(false);
					} else if (aErrorObject.code == 22000006) {
						alert(XWC.S.keyworderror1.split("%s").join(gDialogObj.args.keywordTryLimit) + XWC.S.keyworderror2.split("%s").join(gPasswordTryCount));
						if (gPasswordTryCount++ >= gDialogObj.args.keywordTryLimit) {
							aKeywordResult = -3;
							if (gSelectedMediaID == XWC.CERT_LOCATION_XECUREFREESIGN) {
								var _cb_logout = function(){ onCancelButtonClick(); }
								__SANDBOX.upInterface().xfsLogout(_cb_logout);
							} else {
								onCancelButtonClick();
							}
						} else {
							setOKButtonDisabled(false);
						}
					} else if (aErrorObject.code == 10010015) {
						alert(XWC.S.not_allowed);
						if (gSelectedMediaID == XWC.CERT_LOCATION_XECUREFREESIGN) {
							var _cb_logout = function(){ onCancelButtonClick(); }
							__SANDBOX.upInterface().xfsLogout(_cb_logout);
						} else {
							onCancelButtonClick();
						}
					} else {
						alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
						if (gSelectedMediaID == XWC.CERT_LOCATION_XECUREFREESIGN) {
							var _cb_getCertTree = function (aResult) {
								refreshTableView(aResult);
								setOKButtonDisabled(false);
							}
							__SANDBOX.upInterface().getCertTree(XWC.CERT_LOCATION_XECUREFREESIGN, 2, gSearchCondition, 5, gCAList, gCertSerial, _cb_getCertTree);
						} else {
							setOKButtonDisabled(false);
						}
					}
				}
				_fn_final (_fn_final_callback);
			}
						_inputHandlerCallback = function (aResult)
			{
				var aGetKeyword = gInputHandler.getValue(aResult);
				
				if (aMediaType == XWC.CERT_LOCATION_SECUREDISK) {
					aKeyword = "";
					aPin = aGetKeyword; 					
					AnySign.mDivInsertOption = 0;
					_show_guidewindow ();
					AnySign.mDivInsertOption = pageDivInsertOption;
					
					__SANDBOX.upInterface().loginSecureDiskFromIndex (gSelectedMediaID,
																	  aGetKeyword,
																	  gSelectedSubjectRDN,
																	  gSelectedIssuerRDN,
																	  gSelectedCertSerial,
																	  (gDialogObj.type == "renew" ? 3 : 0),
																	  _resultCheckFun);
				} else if (aMediaType == XWC.CERT_LOCATION_WEBPAGE) {
					gDialogObj.onconfirm({
						mediaID: gSelectedMediaID,
						subjectRDN : gSelectedSubjectRDN,
						issuerRDN : gSelectedIssuerRDN,
						certSerial : gSelectedCertSerial,
						passwd: aGetKeyword
					});
				} else {
					aKeyword = aGetKeyword;
					if (gSelectedMediaID == XWC.CERT_LOCATION_XECUREFREESIGN && AnySign.mXecureFreeSignData.signType == "client") {
						__SANDBOX.upInterface().exportCertToPFX (gSelectedMediaID,
																gSelectedIssuerRDN,
																gSelectedCertSerial,
																aGetKeyword,
																null, null, 0,
																_resultCheckFun);
					} else {
						__SANDBOX.upInterface().verifyPassword (gSelectedMediaID,
																gSelectedIssuerRDN,
																gSelectedCertSerial,
																aGetKeyword,
																_resultCheckFun);
					}
				}
			}
						
			gInputHandler.generateSessionID(0, _inputHandlerCallback);
		}
		else
		{
			if (aMediaType == XWC.CERT_LOCATION_PKCS11 && gSelectedSmartCert == false)
			{
				AnySign.mDivInsertOption = 0;
				
								_resultCheckFun = function (aResult)
				{
					if (aResult == 0)
					{
						aKeyword = "";
						_confirmCallback ();
					}
					else
					{
						var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
						var _fn_final_callback = function () {
							alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
							setOKButtonDisabled(false);
						}
						_fn_final (_fn_final_callback);
					}
				}
								
				var verifyhsmModule = __SANDBOX.loadModule("verifyhsm");
				var verifyhsmDialog = verifyhsmModule({
					args: {},
					onconfirm: function (aResult) {
						verifyhsmDialog.dispose();
						_show_guidewindow ();
						AnySign.mDivInsertOption = pageDivInsertOption;
						
						aPin = aResult;
						__SANDBOX.upInterface().loginPKCS11FromIndex(gSelectedMediaID, aResult, _resultCheckFun);
					},
					oncancel: function () {
						AnySign.mDivInsertOption = pageDivInsertOption;
						verifyhsmDialog.dispose();
						setOKButtonDisabled(false);
					}
				});
				verifyhsmDialog.show();
			}
			else
			{
				if (gSelectedMediaID == XWC.CERT_LOCATION_MPHONE + 1 || gSelectedSmartCert == true) {
					AnySign.mDivInsertOption = 0;
					_show_guidewindow ();
					AnySign.mDivInsertOption = pageDivInsertOption;
				}
				
				aKeyword = "";
				_confirmCallback ();
			}
		}
	}
}

function onCancelButtonClick(e) {
	gDialogObj.oncancel();		
}

function onHddButtonClick(element) {
	gSelectedButton = 1;
	gSelectedSmartCert = false;
	refreshTableView("");
	
	if (checkAnySignLoad() == false) {
		gEvent = element;
		onCheckMedia();	
		return;
	}
	
	AnySign.mAnySignEnable = true;
	setInputHandler();
	setPasswordInputEnable();
	setDeleteButton(true);
	setButtonManager ("disabled");

		_CB_getCertTree = function (aCertList)
	{
		setButtonManager ("enabled");
		if (__SANDBOX.isFailed(aCertList))
			aCertList = "";

		gSelectedMediaID = 1;
		refreshTableView(aCertList);
		element.focus();
	}
		_CB_getMediaList = function ()
	{
		__SANDBOX.upInterface().getCertTree(1, 2, gSearchCondition, 5, gCAList, gCertSerial, _CB_getCertTree);
	}
	
	__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_HARD, 0, 1, _CB_getMediaList);
}

function onRemovableButtonClick(element) {
	var aMediaList;
	
	gSelectedButton = 2;
	gSelectedSmartCert = false;
	refreshTableView("");
	
	if (checkAnySignLoad() == false) {
		gEvent = element;
		onCheckMedia();	
		return;
	}
	
	AnySign.mAnySignEnable = true;
	setInputHandler();
	setPasswordInputEnable();
	setDeleteButton(true);
	setButtonManager ("disabled");
	
		_CB_getMediaList_refresh = function (aResult)
	{
		setButtonManager ("enabled");
		var aMenuItems = [];
		
		if (__SANDBOX.isFailed(aResult, gErrCallback)) {
			onCancelButtonClick();
			return;
		}
		
		var aIDList = aResult.split("\t\n");
		
		for (var i = 0; i < aMediaList.length; i++) {
			if (aMediaList[i].length > 0) {
				aMenuItems.push({ item: aMediaList[i], data: Number(aIDList[i]) });
			}
		}
		
		XWC.UI.ContextMenu(element, XWC.S.media_removable_list, aMenuItems, aContextMenuFunc);
	}
		_CB_getMediaList = function (aResult)
	{
		aMediaList = aResult.split("\t\n");
		
		if (__SANDBOX.isFailed(aMediaList, gErrCallback)) {
			onCancelButtonClick();
			return;
		}

		__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_REMOVABLE, 1, 0, _CB_getMediaList_refresh);
	}
		_CB_getCertTree = function (aResult)
	{
		if (__SANDBOX.isFailed(aResult)) {
			aResult = "";
		}

		refreshTableView(aResult);
		element.focus();
	}
		
	function aContextMenuFunc(aMenuData)
	{
		gSelectedMediaID = aMenuData;
		gSelectedIssureRDN = null;
		gSelectedCertSerial = null;
		gSelectedRowIndex = null;
		gSelectedCertClass = null;
		
		__SANDBOX.upInterface().getCertTree(aMenuData, 2, gSearchCondition, 5, gCAList, gCertSerial, _CB_getCertTree);
	}

	__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_REMOVABLE, 0, 1, _CB_getMediaList);
}

function onSaveTokenButtonClick(element)
{
	var	aGuideModule,
		aGuideDialog,
		aCertList,
		aMenuItems = [];
	
	gSelectedButton = 3;
	gSelectedSmartCert = false;
	refreshTableView("");

	if (checkAnySignLoad() == false) {
		gEvent = element;
		onCheckMedia();	
		return;
	}
	
	AnySign.mAnySignEnable = true;
	setInputHandler();
	setPasswordInputEnable();
	setDeleteButton(true);
	
	var pageDivInsertOption = AnySign.mDivInsertOption;
	
	if (__SANDBOX.certLocationSet["iccard"])
		aMenuItems.push({ item: XWC.S.iccard, data: XWC.CERT_LOCATION_ICCARD});
	
	if (__SANDBOX.certLocationSet["kepcoiccard"])
		aMenuItems.push({ item: XWC.S.kepcoiccard, data: XWC.CERT_LOCATION_KEPCOICCARD});
	
		_CB_logoutStoreToken = function ()
	{
		if (!__SANDBOX.isFailed(aCertList))
			refreshTableView(aCertList);
			
		aGuideDialog.dispose ();
		element.focus();
	}
		_CB_getCertTree = function (aResult)
	{
		aCertList = aResult;
		
		__SANDBOX.upInterface().logoutStoreToken(gSelectedMediaID, _CB_logoutStoreToken);
	}
		_CB_loginStoreToken = function (result)
	{
		var aErrorObject;
		if (result != 0)
		{
			aGuideDialog.dispose ();
			element.focus();
			
			aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
		}
		else
		{ 
			__SANDBOX.upInterface().getCertTree(gSelectedMediaID, 2, gSearchCondition, 5, gCAList, gCertSerial, _CB_getCertTree);
		}
	}
	
	function aContextMenuFunc(aMenuData) {
		
		AnySign.mDivInsertOption = 0;
		
		gSelectedMediaID = aMenuData;
		
				ShowIccardDialog = function (aMediaID)
		{
			gSelectedMediaID = aMediaID;
			
			var aMediaType = Math.floor(gSelectedMediaID / 100) * 100;
			var aICCardType;
			if (aMediaType == XWC.CERT_LOCATION_KEPCOICCARD)
				aICCardType = "kepco";
			else
				aICCardType = "iccard";
			
			AnySign.SetUITarget (__47);
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
					
					__SANDBOX.upInterface().loginStoreToken(gSelectedMediaID, aPin, 1, _CB_loginStoreToken);
					
					aGuideDialog.show();
					AnySign.mDivInsertOption = pageDivInsertOption;
				},
				oncancel: function () {
					iccardDialog.dispose();
					element.focus();
					AnySign.mDivInsertOption = pageDivInsertOption;
				}
			});
			iccardDialog.show();
		}
		
		if (gSelectedMediaID == XWC.CERT_LOCATION_ICCARD) {
			AnySign.SetUITarget (__47);
			var iccardlistModule = __SANDBOX.loadModule("iccardlist");
			var iccardlistDialog = iccardlistModule({
				args: {},
				onconfirm: function (aResult) {
					iccardlistDialog.dispose();
					ShowIccardDialog (XWC.CERT_LOCATION_ICCARD + aResult);
				},
				oncancel: function () {
					iccardlistDialog.dispose();
					element.focus();
					AnySign.mDivInsertOption = pageDivInsertOption;
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

function onSmartCertButtonClick(element) {
	var aResult = "",
		aIndex = 0,
		aProviderName = "",
		aSmartCertDataList,
		aErrorObject,
		aGuideModule,
		aGuideDialog;
	
	gSelectedButton = 6;
	gSelectedSmartCert = false;
	refreshTableView("");

	if (checkAnySignLoad() == false) {
		gEvent = element;
		onCheckMedia();	
		return;
	}
	
	AnySign.mAnySignEnable = true;
	setInputHandler();
	setPasswordInputEnable(false);
	setDeleteButton(false);
	setButtonManager ("disabled");
	
	gNeedPassword = false;
	
	gSelectedIssureRDN = "";
	gSelectedCertSerial = "";
	gSelectedRowIndex = null;
	
	aSmartCertDataList = AnySign.mSmartCertDataList;
	
	var pageDivInsertOption = AnySign.mDivInsertOption;
	AnySign.mDivInsertOption = 0;
	
	function installSmartCert(index) {
		if (aGuideDialog)
			aGuideDialog.dispose();
		
		if (confirm(XWC.JSSTR("smartcert_install"))) {
			var aURL = aSmartCertDataList[index].mInstallURL;
			var aOption = aSmartCertDataList[index].mInstallPageOption;
			
			window.open (aURL, 'DownLoadPage', aOption);
		}
		
		setButtonManager ("enabled");
		element.focus();
	}
	
	function getSmartCertOption(aDataList, aAddOption) {
		var option = 0x04;
		if (aDataList.mSiteDomainURL != "" || aDataList.mServiceServerIP != "" || aDataList.mServiceServerPort != "" || aDataList.mSiteCode != "")
			option += 0x01;
		if (aDataList.mLoginOrder == "1")
			option += 0x08;
		if (aDataList.mMagicNum != "" || aDataList.mFilterShowExpired != "" || aDataList.mFilterOIDList != "" || aDataList.mFilterCACert != "" || aDataList.mFilterUserCert != "")
			option += 0x10;
		if (aDataList.mPlainDataView == "YES")
			option += 0x20;
		
		if (aAddOption != undefined)
			option += aAddOption;
		
		return option;
	}
	
		_getMediaList = function (result)
	{
		var aMediaList = result.split("\t\n");
		if (aMediaList == "") {
			installSmartCert(0);
			return;
		}
		
				var aFind = false;
		var aMediaIndex = 0;
		var aServiceInfo = "";
		var aOption = 0;
		var i = 0;
		
		for (i = 0; i < aSmartCertDataList.length; i++) {
			aFind = false;
			for (aMediaIndex = 0; aMediaIndex < aMediaList.length; aMediaIndex++) {
				if (aMediaList[aMediaIndex].indexOf(aSmartCertDataList[i].mProvider) == 0) {
					aSmartCertDataList[i].mProviderIndex = aMediaIndex;
					aSmartCertDataList[i].mProviderName = aMediaList[aMediaIndex];
					aFind = true;
					break;
				}
			}
			if (!aFind) {
				installSmartCert(i);
				return;
			}
		}
		
				aIndex = 0;
		aProviderName = aSmartCertDataList[aIndex].mProviderName;
		aServiceInfo = (aSmartCertDataList[aIndex].mSiteDomainURL == "" ? "NONE" : aSmartCertDataList[aIndex].mSiteDomainURL) + "|" +
					   (aSmartCertDataList[aIndex].mServiceServerIP == "" ? "NONE" : aSmartCertDataList[aIndex].mServiceServerIP) + "|" +
					   (aSmartCertDataList[aIndex].mServiceServerPort == "" ? "NONE" : aSmartCertDataList[aIndex].mServiceServerPort) + "|" +
					   (aSmartCertDataList[aIndex].mSiteCode == "" ? "NONE" : aSmartCertDataList[aIndex].mSiteCode);
		aOption = getSmartCertOption(aSmartCertDataList[aIndex]);
		
		__SANDBOX.upInterface().initializePKCS11FromNameEx(aProviderName, aServiceInfo, aOption, _initializePKCS11FromNameEx);
	}
	
		_initializePKCS11FromNameEx = function (result)
	{
		aResult = result;
		if (result == "OK") { 			_setPhoneData();
		} else if (result == "") { 			aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			__SANDBOX.upInterface().finalizePKCS11FromName(aProviderName, _error_finalizePKCS11FromName);
			
		} else { 			__SANDBOX.upInterface().finalizePKCS11FromName(aProviderName, _finalizePKCS11FromName);
		}
	}
	
		_initializePKCS11FromNameEx2 = function (result)
	{
		aResult = result;
		if (result == "OK") { 			_setPhoneData();
		} else { 			aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			__SANDBOX.upInterface().finalizePKCS11FromName(aProviderName, _error_finalizePKCS11FromName);
		}
	}
	
		_finalizePKCS11FromName = function ()
	{
		var aFind = false;
		var aServiceInfo = "";
		var aOption = 0;
		
				for (aIndex = 0; aIndex < aSmartCertDataList.length; aIndex++) {			
			if (aResult.indexOf (aSmartCertDataList[aIndex].mDriverName) == 0) {
				aFind = true;
				break;
			}
		}
		
		if (!aFind) { 			if (aGuideDialog)
				aGuideDialog.dispose();
			
			alert(XWC.JSSTR("smartcert_not_supported"));
			setButtonManager ("enabled");
			element.focus();
			return;
		}
		
				aProviderName = aSmartCertDataList[aIndex].mProviderName;
		aServiceInfo = (aSmartCertDataList[aIndex].mSiteDomainURL == "" ? "NONE" : aSmartCertDataList[aIndex].mSiteDomainURL) + "|" +
					   (aSmartCertDataList[aIndex].mServiceServerIP == "" ? "NONE" : aSmartCertDataList[aIndex].mServiceServerIP) + "|" +
					   (aSmartCertDataList[aIndex].mServiceServerPort == "" ? "NONE" : aSmartCertDataList[aIndex].mServiceServerPort) + "|" +
					   (aSmartCertDataList[aIndex].mSiteCode == "" ? "NONE" : aSmartCertDataList[aIndex].mSiteCode);
		aOption = getSmartCertOption(aSmartCertDataList[aIndex], 0x02);
		
		__SANDBOX.upInterface().initializePKCS11FromNameEx(aProviderName, aServiceInfo, aOption, _initializePKCS11FromNameEx2);
	}
	
		_error_finalizePKCS11FromName = function ()
	{
		if (aGuideDialog)
			aGuideDialog.dispose();
		
		if (aProviderName.indexOf("Mobile_SmartCert") == 0) { 			if (aErrorObject.code != 30000006 && aErrorObject.code != 31000006)
				alert(XWC.JSSTR("smartcert_error"));
		} else {
			if (aErrorObject.code == 30000001 || aErrorObject.code == 31000001)
				alert(XWC.JSSTR("smartcert_cancel"));
			else
				alert(XWC.JSSTR("smartcert_error"));
		}
		setButtonManager ("enabled");
		element.focus();
	}
	
		_setPhoneData = function (result)
	{
		var aSetPhoneData = "";
		
				aSetPhoneData = (aSmartCertDataList[aIndex].mMagicNum == "" ? "NONE" : aSmartCertDataList[aIndex].mMagicNum) + "$" +
						(aSmartCertDataList[aIndex].mFilterShowExpired == "" ? "NONE" : aSmartCertDataList[aIndex].mFilterShowExpired) + "$" +
						(aSmartCertDataList[aIndex].mFilterOIDList == "" ? "NONE" : aSmartCertDataList[aIndex].mFilterOIDList) + "$" +
						(aSmartCertDataList[aIndex].mFilterCACert == "" ? "NONE" : aSmartCertDataList[aIndex].mFilterCACert) + "$" +
						(aSmartCertDataList[aIndex].mFilterUserCert == "" ? "NONE" : aSmartCertDataList[aIndex].mFilterUserCert);
		__SANDBOX.upInterface().setPhoneData(aSetPhoneData, 0x040, _final);
	}
	
		_final = function ()
	{
		if (aGuideDialog)
			aGuideDialog.dispose();
		
		gSelectedMediaID = XWC.CERT_LOCATION_PKCS11 + aSmartCertDataList[aIndex].mProviderIndex + 1;
		gSelectedSmartCert = true;
		onOKButtonClick(null);
		setButtonManager ("enabled");
	}
		
	aGuideModule = __SANDBOX.loadModule("guidewindow");
	aGuideDialog = aGuideModule({
		type: "loading",
		args: "",
		onconfirm: "",
		oncancel: function () {aGuideDialog.dispose();}
	});
	aGuideDialog.show();
	AnySign.mDivInsertOption = pageDivInsertOption;
	
		__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_PKCS11, 0, 1, _getMediaList);
}

function onHSMButtonClick(element) {
	var aGuideModule,
		aGuideDialog,
		aCertList,
		hsmselectDialog;
	
	gSelectedButton = 4;
	gSelectedSmartCert = false;
	refreshTableView("");
	
	if (checkAnySignLoad() == false) {
		gEvent = element;
		onCheckMedia();	
		return;
	}
	
	AnySign.mAnySignEnable = true;
	setInputHandler();
	setPasswordInputEnable();
	setDeleteButton(true);
	
	var pageDivInsertOption = AnySign.mDivInsertOption;
	AnySign.mDivInsertOption = 0;
	
		_CB_finalizePKCS11FromName = function ()
	{
		if (!__SANDBOX.isFailed(aCertList))
			refreshTableView(aCertList);
		
		hsmselectDialog.dispose();
		setButtonManager("enabled");
		gNeedPassword = setPasswordInputEnable(false);
		element.focus();
	}
		_CB_getCertTree = function (aResult)
	{
		aCertList = aResult;
		
		__SANDBOX.upInterface().finalizePKCS11FromName (gProviderName, _CB_finalizePKCS11FromName);
	}
		_open_hsmselect = function ()
	{
		AnySign.SetUITarget (__50);
		var hsmselectModule = __SANDBOX.loadModule("hsmselect");
		hsmselectDialog = hsmselectModule({
			onconfirm: function (aResult, aProviderName, aUbikey) {
				if(aResult < 0) {
					setButtonManager("enabled");
					hsmselectDialog.dispose();
					element.focus();
					return;
				}
				
				gProviderName = aProviderName;
				gSelectedMediaID = XWC.CERT_LOCATION_PKCS11 + aResult;
				
				if (!aUbikey) {
					__SANDBOX.upInterface().getCertTree(gSelectedMediaID, 2, gSearchCondition, 5, gCAList, gCertSerial, _CB_getCertTree);
				} else {
					hsmselectDialog.dispose();
					setButtonManager("enabled");
										gSelectedSmartCert = true;
					refreshTableView("");
					onOKButtonClick(null);
				}
			},
			oncancel: function () {
				setButtonManager("enabled");
				hsmselectDialog.dispose();
				element.focus();
			}
		});
		hsmselectDialog.show();
		AnySign.mDivInsertOption = pageDivInsertOption;
	}
		_CB_hsmDriverManager = function (aResult)
	{
		if (aResult != 0)
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
		_CB_getMediaList = function (aMediaList)
	{
		if (aGuideDialog)
			aGuideDialog.dispose();
		
		setButtonManager("disabled");
		
		if (aMediaList)
			aMediaList = aMediaList.split("\t\n");
		
		if (aMediaList == "")
		{
			if (confirm(XWC.JSSTR("installNotifyHSM")) == true)
			{
				__SANDBOX.upInterface().hsmDriverManager (_CB_hsmDriverManager);
			}
			
			setButtonManager("enabled");
			element.focus();
			AnySign.mDivInsertOption = pageDivInsertOption;
		}
		else
		{
			_open_hsmselect ();
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
	
	__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_PKCS11, 0, 1, _CB_getMediaList);
}

function onSecureDiskButtonClick(element) {
	var aGuideModule,
		aGuideDialog,
		aCertList;
		
	gSelectedButton = 7;
	gSelectedSmartCert = false;
	refreshTableView("");
	
	if (checkAnySignLoad() == false) {
		gEvent = element;
		onCheckMedia();	
		return;
	}
	
	var pageDivInsertOption = AnySign.mDivInsertOption;
	AnySign.mDivInsertOption = 0;
	
	AnySign.mAnySignEnable = true;
	setInputHandler();
	setPasswordInputEnable();
	setDeleteButton(true);
	setButtonManager ("disabled");
	
	gSelectedMediaID = XWC.CERT_LOCATION_SECUREDISK + 1;
	
		_finalizeSecureDiskFromName = function ()
	{
		if (aGuideDialog)
			aGuideDialog.dispose();
		
		if (!__SANDBOX.isFailed(aCertList))
			refreshTableView(aCertList);
		
		setButtonManager("enabled");
		element.focus();
	}
	
		_getCertTree = function (aResult)
 	{
		aCertList = aResult;
		
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
			__SANDBOX.upInterface().getCertTree(gSelectedMediaID, 2, gSearchCondition, 5, gCAList, gCertSerial, _getCertTree);
		} else {
						
			if (aGuideDialog)
				aGuideDialog.dispose();
			
			var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			if (aErrorObject.code == 23000802) {
				_securedisk_install ();
			} else {
				alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
			}
			
			setButtonManager ("enabled");
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
			
			setButtonManager ("enabled");
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
	AnySign.mDivInsertOption = pageDivInsertOption;
	
	__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_SECUREDISK, 0, 1, _getMediaList);
}

function onNFCICCardButtonClick(element) {
	gSelectedButton = 8;
	gSelectedSmartCert = false;
	refreshTableView("");
	
	AnySign.mAnySignEnable = false;
	setInputHandler("lite");
	setPasswordInputEnable();
	setDeleteButton(false);
	
	}

function onLocalStorageButtonClick(element) {
	gSelectedButton = 9;
	gSelectedSmartCert = false;
	refreshTableView("");
	
	AnySign.mAnySignEnable = false;
	setInputHandler("lite");
	setPasswordInputEnable();
	setDeleteButton(true);
	
	gSelectedMediaID = XWC.CERT_LOCATION_LOCALSTORAGE;
	
	var _cb_getCertTree = function (aCertList) {
		if (__SANDBOX.isFailed(aCertList))
			aCertList = "";
		
		refreshTableView(aCertList);
	}
	
	var _cb_getMediaList = function () {
		__SANDBOX.upInterface().getCertTree(XWC.CERT_LOCATION_LOCALSTORAGE, 2, gSearchCondition, 5, gCAList, gCertSerial, _cb_getCertTree);
	}
	
	__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_LOCALSTORAGE, 0, 1, _cb_getMediaList);
}

function onMemoryStorageButtonClick(element) {
	gSelectedButton = 10;
	gSelectedSmartCert = false;
	refreshTableView("");
	
	AnySign.mAnySignEnable = false;
	setInputHandler("lite");
	setPasswordInputEnable();
	setDeleteButton(true);
	
	var pageDivInsertOption = AnySign.mDivInsertOption;
	AnySign.mDivInsertOption = 0;
	
	gSelectedMediaID = XWC.CERT_LOCATION_MEMORYSTORAGE;
	
	var aIsSavePFX = false;
	var IsSavePFX= function () {
		aIsSavePFX = !aIsSavePFX;	
	}

	var openPasswdDialog = function (pfx, name) {
		var _pfx = pfx;
		var _name = name;
		var inputpassModule = __SANDBOX.loadModule("inputpasswd");
		var inputpassDialog = inputpassModule({
			args: {messageType: "certificate",
				   descType: "pfx",
				   inputType: "lite",
				   isSave: false,
				   func: IsSavePFX},
			onconfirm: function (aResult) {
				inputpassDialog.dispose();
				element.focus();
				
				var _cb_setCertificateFromPFX = function (aPWCheck) {
					if (aPWCheck == 0 || aPWCheck == 1) { 						_callback = function ()
						{
							if(gInputHandler) gInputHandler.clear();
							setOKButtonDisabled(false);
						}
						
						gDialogObj.onconfirm({
							mediaID: XWC.CERT_LOCATION_MEMORYSTORAGE,
							passwd: aResult,
							passwdResult: 0,
							pfxPath: name,
							withPFX: true,
							callback: _callback
						});
					} else {
						var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
						if (aErrorObject.code == 22000006) {
							alert(XWC.S.keyworderror);
						} else {
							alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
						}
					}
				}
				
				__SANDBOX.upInterface().setCertificateFromPFX (_pfx, aResult, aIsSavePFX, gSearchCondition, gCAList, gCertSerial, _cb_setCertificateFromPFX);
			},
			oncancel: function () {
				inputpassDialog.dispose();
				element.focus();
			}
		});
		inputpassDialog.show();
		AnySign.mDivInsertOption = pageDivInsertOption;
	}
	
	var _pfxdialogOpen = function () {
		var pfxModule = __SANDBOX.loadModule("pfxdialog");
		var pfxDialog = pfxModule({
			onconfirm: function (aPFX, aName) {
				pfxDialog.dispose();
				openPasswdDialog(aPFX, aName);
			},
			oncancel: function () {
				pfxDialog.dispose();
				element.focus();
				AnySign.mDivInsertOption = pageDivInsertOption;
			}
		});
		pfxDialog.show();
	}
	
	_pfxdialogOpen();
}

function onXecureFreeSignButtonClick(element) {
	gSelectedButton = 11;
	gSelectedSmartCert = false;
	refreshTableView("");
	
	AnySign.mAnySignEnable = false;
	setInputHandler("xfs");
	setPasswordInputEnable();
	setDeleteButton(true);
	
	gSelectedMediaID = XWC.CERT_LOCATION_XECUREFREESIGN;
	
	var _cb_getCertTree2 = function (aResult) {
		if (aResult == "") {
			var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			if (aErrorObject.code == 0)
				alert(XWC.S.xfs_no_cert)
			else
				alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
			
						
								} else {
			refreshTableView(aResult);
		}
	}
	
	var _openXFSLogin = function () {
		var pageDivInsertOption = AnySign.mDivInsertOption;
		AnySign.mDivInsertOption = 0;
		
		var xfsModule = __SANDBOX.loadModule("xfslogin");
		var xfsDialog = xfsModule({
			args:"",
			onconfirm: function (aResult) {
				xfsDialog.dispose();
				if(aResult == 0) {
					__SANDBOX.upInterface().getCertTree(XWC.CERT_LOCATION_XECUREFREESIGN, 2, gSearchCondition, 5, gCAList, gCertSerial, _cb_getCertTree2);
				} else {
									}
			},
			oncancel: function () {
				xfsDialog.dispose();
			}
		});
		xfsDialog.show();
		AnySign.mDivInsertOption = pageDivInsertOption;
	}
	
	var _cb_getCertTree = function (aResult) {
		if (aResult == "") {
						
								} else {
			refreshTableView(aResult);
		}
	}
	
	var _cb_getMediaList = function (aResult) {
		if (aResult == 0) {					__SANDBOX.upInterface().getCertTree(XWC.CERT_LOCATION_XECUREFREESIGN, 2, gSearchCondition, 5, gCAList, gCertSerial, _cb_getCertTree);
		} else {
			var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			if (aErrorObject.code == 0x7005011C)
				_openXFSLogin();				else
				alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));			}
	}
	
		__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_XECUREFREESIGN, 0, 1, _cb_getMediaList);
}

function onWebPageButtonClick(element) {
	gSelectedButton = 15;
	gSelectedSmartCert = false;
	refreshTableView("");
	
	AnySign.mAnySignEnable = false;
	setInputHandler("e2e");
	setPasswordInputEnable();
	setDeleteButton(false);
	
	gSelectedMediaID = XWC.CERT_LOCATION_WEBPAGE;
	
	var _cb_getCertTree = function (aResult) {
		refreshTableView(aResult);
	}
		
	__SANDBOX.upInterface().getCertTree(XWC.CERT_LOCATION_WEBPAGE, 2, gSearchCondition, 5, gCAList, gCertSerial, _cb_getCertTree);
}

function onMobileButtonClick(element) {
	var aMobiList,
		aInfoList,
		aMenuItems;
	
	gSelectedButton = 5;
	gSelectedSmartCert = false;
	refreshTableView("");
	
	if (checkAnySignLoad() == false) {
		gEvent = element;
		onCheckMedia();	
		return;
	}
	
	AnySign.mAnySignEnable = true;
	setInputHandler();
	setPasswordInputEnable();
	setDeleteButton(false);
	
	aMobiList = XWC.S.mobile_mobi;
	aInfoList = XWC.S.mobile_info;

	aMenuItems = [];

	if (AnySign.mPlatform.aName.indexOf("mac universal") != 0)
	{
		if (__SANDBOX.certLocationSet["mphone"])
			aMenuItems.push({ item: aInfoList, data: XWC.CERT_LOCATION_YESSIGNM + 1 });
	}
	if (AnySign.mPlatform.aName.indexOf("windows") == 0)
	{
		if (__SANDBOX.certLocationSet["mobisign"])
			aMenuItems.push({ item: aMobiList, data: XWC.CERT_LOCATION_MPHONE + 1 });
	}
	
	function aContextMenuFunc(aMenuData) {
		var aUbikeyData,
			aMobiSignData,
			aPhoneData,
			aGuideModule,
			aGuideDialog;
		
		var pageDivInsertOption = AnySign.mDivInsertOption;
		AnySign.mDivInsertOption = 0;
		
		setButtonManager ("disabled");
		
		gSelectedMediaID = aMenuData;
		gSelectedRowIndex = null;
		
				_CB_getCertTree = function (aResult)
		{
			if (aGuideDialog)
				aGuideDialog.dispose();
			
			setButtonManager ("enabled");
			
			if (__SANDBOX.isFailed(aResult)) {
				aResult = "";
			}

						if (gSelectedMediaID == XWC.CERT_LOCATION_YESSIGNM + 1) {
				var aList = XWC.stringToArray(aResult);
				if (aList != "") {
					if (aList[0][0] == '2') {
						alert(XWC.JSSTR("mobileError"));
						onCancelButtonClick();
						return;
					}
				}
				setPasswordInputEnable();
			}
			else if (gSelectedMediaID == XWC.CERT_LOCATION_MPHONE + 1) {
				gNeedPassword = setPasswordInputEnable(false);
				
				onOKButtonClick(null);
			}
			
			refreshTableView(aResult);
			element.focus();
		}
				_CB_getMediaList = function (aResult)
		{
			if ((typeof (aResult) == "string" && aResult == ""))
			{
				var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();

				if (aErrorObject.code == 10010002)
				{
					if (aGuideDialog)
						aGuideDialog.dispose();
					
					aResult = confirm(XWC.JSSTR("installNotify"));
					
					var aURL, aOpenOption;
					if (gSelectedMediaID == XWC.CERT_LOCATION_YESSIGNM + 1) {
						aURL = AnySign.mUbikeyData.mInstallURL;
						aOpenOption = AnySign.mUbikeyData.mInstallPageOption;
					} else {
						aURL = AnySign.mMobiSignData.mInstallURL;
						aOpenOption = AnySign.mMobiSignData.mInstallPageOption;
					}
					
					if (aResult == true) {
						window.open(aURL, 'DownLoadPage', aOpenOption);
					}
					
					setButtonManager ("enabled");
					element.focus();
					return;
				}
			}
			
			__SANDBOX.upInterface().getCertTree(gSelectedMediaID, 2, gSearchCondition, 5, gCAList, gCertSerial, _CB_getCertTree);
		}
				_CB_setPhoneData = function ()
		{
			var aMediaType = Math.floor(parseInt(gSelectedMediaID, 10) / 100) * 100;
			
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
		AnySign.mDivInsertOption = pageDivInsertOption;

		switch (gSelectedMediaID) { 		case XWC.CERT_LOCATION_YESSIGNM + 1: 			aUbikeyData = AnySign.mUbikeyData;

			aPhoneData = AnySign.mXgateAddress + "&"
								+ aUbikeyData.mSite + "|" + aUbikeyData.mLiveUpdate + "&"
								+ aUbikeyData.mSecurity + "|" + aUbikeyData.mKeyboardSecurity + "&"
								+ aUbikeyData.mVersion;
			
			__SANDBOX.upInterface().setPhoneData (aPhoneData, 0x10, _CB_setPhoneData);
			break;
		case XWC.CERT_LOCATION_MPHONE + 1: 			aMobiSignData = AnySign.mMobiSignData;
			aPhoneData = aMobiSignData.mSite + "&" + aMobiSignData.mVersion;

			__SANDBOX.upInterface().setPhoneData (aPhoneData, 0x20, _CB_setPhoneData);
			break;
		}
	}
		
	XWC.UI.ContextMenu(element, XWC.S.media_mobile, aMenuItems, aContextMenuFunc);
}

function onFindCertButtonClick(e) {
	e = e || window.event;

	var inputpassModule,
		inputpassDialog,
		target,
		aKeyword,
		aPFXFilePath;
	
	gSelectedButton = 12;
	gSelectedSmartCert = false;
	
	if (checkAnySignLoad() == false) {
		gEvent = e;
		onCheckMedia();	
		return;
	}
	
	var aAnySignEnable = AnySign.mAnySignEnable;
	AnySign.mAnySignEnable = true;
	
	var pageDivInsertOption = AnySign.mDivInsertOption;
	AnySign.mDivInsertOption = 0;
	
	target = e.target || e.srcElement;

		_openFileDialog = function () {
		AnySign.SetUITarget (target);
		var fileModule = __SANDBOX.loadModule("fileselect");
		var fileDialog = fileModule({
			args: {	searchType:	"",
					extType: 0,
					isPFXFile: true,
					isSaveMode: false,
					defaultName: ""
			},
			onconfirm: function (aResult) {
				fileDialog.dispose();
				
				if (aResult == "") 				{
					AnySign.mDivInsertOption = pageDivInsertOption;
					AnySign.mAnySignEnable = aAnySignEnable;
					return;
				}
				
				aPFXFilePath = aResult;
				_openInputpasswd();
			},
			oncancel: function (e) { 
				target.focus();
				fileDialog.dispose();
				AnySign.mDivInsertOption = pageDivInsertOption;
				AnySign.mAnySignEnable = aAnySignEnable;
			}
		});
		fileDialog.show();
	};
	
		_checkPFXPwdCallback = function (aResult)
	{
		if (aResult != 0)
		{
			var aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();
			
			if (aResult == -3) {
				alert(XWC.S.keyworderror);
			} else if (aResult == -4) {
				alert(XWC.S.notableCert);
			} else {
				alert(aErrorObject.msg.replace(/\\n/g, '\r\n'));
			}
			
			inputpassDialog.dispose();
			AnySign.mAnySignEnable = aAnySignEnable;
			target.focus();
			return;
		}
		else if (pageDivInsertOption > 0)
		{
			alert(XWC.S.sign_complete_msg + "\n" + XWC.S.go_next_step_msg);
			__120.style.display = 'none';
			
			__134.style.display = 'none';
			__135.style.display = 'none';
			__136.style.display = 'inline';
			__136.setAttribute("tabindex", 0, 0);
		}
		
		_callback = function ()
		{
			if(gInputHandler) gInputHandler.clear();
			AnySign.mAnySignEnable = aAnySignEnable;
		}
		
		gDialogObj.onconfirm({
			withPFX: true,
			pfxPath: aPFXFilePath,
			passwd: aKeyword,
			callback: _callback
		});
		
		inputpassDialog.dispose();
	}
	
		_openInputpasswd = function () {
		AnySign.SetUITarget (target);
		inputpassModule = __SANDBOX.loadModule("inputpasswd");
		inputpassDialog = inputpassModule({
			args: { messageType: "certificate",
					inputType: "4pc",
					errCallback: gErrCallback },
			onconfirm: function (aResult) {
				aKeyword = aResult;
				__SANDBOX.upInterface().checkPFXPwdWithFilter(aPFXFilePath, aKeyword, gSearchCondition, gCAList, gCertSerial, _checkPFXPwdCallback);
			},
			oncancel: function (e) {
				target.focus();
				inputpassDialog.dispose();
				AnySign.mAnySignEnable = aAnySignEnable;
			}
		});
		inputpassDialog.show();
		AnySign.mDivInsertOption = pageDivInsertOption;
	};
	
	_openFileDialog();
}

function onViewVerifyButtonClick(e) {
	var aCertInfo,
		target;
	
	e = e || window.event;
	target = e.target || e.srcElement;
	
	gSelectedButton = 13;
	
	if (!gSelectedIssuerRDN && !gSelectedCertSerial)
	{
		alert(XWC.S.noselection);
		return;
	}
	
	var pageDivInsertOption = AnySign.mDivInsertOption;
	AnySign.mDivInsertOption = 0;

	_open_viewverify = function (aResult)
	{
		var aCertClass,
			aCertVerifyMsg,
			div_target;
		
		aCertClass = gSelectedCertClass; 
		aCertVerifyMsg = __SANDBOX.upInterface().setErrCodeAndMsg().msg;
		
		AnySign.SetUITarget (__112);
		var viewverifyModule = __SANDBOX.loadModule("viewverify");
		var viewverifydialog = viewverifyModule({
			onconfirm: function () { 
				target.focus();
				viewverifydialog.dispose(); 
				AnySign.mDivInsertOption = pageDivInsertOption;
			},
			oncancel: function () { 
				target.focus();
				viewverifydialog.dispose();
				AnySign.mDivInsertOption = pageDivInsertOption;
			},
			args: [ aResult, aCertInfo.split("$"), aCertClass, aCertVerifyMsg ]
		});
		viewverifydialog.show();
	}

	_CB_getCertTree = function (aResult)
	{
		if (__SANDBOX.isFailed(aResult, gErrCallback)) {
			AnySign.mDivInsertOption = pageDivInsertOption;
			onCancelButtonClick();
			return;
		}
		
		aCertInfo = aResult;
		
		if (gSelectedMediaID == XWC.CERT_LOCATION_XECUREFREESIGN || gSelectedMediaID == XWC.CERT_LOCATION_WEBPAGE) {
			_open_viewverify (gCertList[gSelectedRowIndex][0]);
		} else {
			__SANDBOX.upInterface().verifyCert(gSelectedMediaID, 2, gSelectedIssuerRDN, gSelectedCertSerial, 0, _open_viewverify);
		}
	}
	
	__SANDBOX.upInterface().getCertTree(gSelectedMediaID, 2, 24, 0, gSelectedIssuerRDN, gSelectedCertSerial, _CB_getCertTree);
}

function onDeleteCertButtonClick(e) {
	var aTarget,
		aGuideModule,
		aGuideDialog;
	
	e = e || window.event;
	aTarget = e.target || e.srcElement;
	
	gSelectedButton = 14;
	
	if (!gSelectedIssuerRDN && !gSelectedCertSerial) {
		alert(XWC.S.noselection);
		aTarget.focus();
		return;
	}
	
	var pageDivInsertOption = AnySign.mDivInsertOption;
	
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
		}
		else if (aMediaType == XWC.CERT_LOCATION_ICCARD || aMediaType == XWC.CERT_LOCATION_KEPCOICCARD) {
			__SANDBOX.upInterface().logoutStoreToken(gSelectedMediaID, _final_callback);
		}
		else if (aMediaType == XWC.CERT_LOCATION_SECUREDISK) {
			__SANDBOX.upInterface().finalizeSecureDiskFromName (gProviderName, _final_callback);
		} else {
			_final_callback();
		}
	}
		_CB_getCertTree = function (aResult)
	{
		if (__SANDBOX.isFailed(aResult)) {
			aResult = "";
		}
		
		refreshTableView(aResult);
		_fn_final ();
		aTarget.focus();
	}
		_CB_getMediaList = function ()
	{
		__SANDBOX.upInterface().getCertTree(gSelectedMediaID, 2, gSearchCondition, 5, gCAList, gCertSerial, _CB_getCertTree);
	}
		_CB_deleteCertificate = function (aResult)
	{
		if (__SANDBOX.isFailed(aResult, gErrCallback)) {
			alert(XWC.S.deletefail);
		}
		
		__SANDBOX.upInterface().getMediaList(aMediaType , 0, 1, _CB_getMediaList);
	}
		_deleteCertificate = function ()
	{
		__SANDBOX.upInterface().deleteCertificate(gSelectedMediaID, 2, gSelectedIssuerRDN, gSelectedCertSerial, _CB_deleteCertificate);
	}
		
	function _verifyhsm_result()
	{
		_CB_loginPKCS11FromIndex = function (aResult)
		{
			if (aResult != 0) {
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
		
		AnySign.mDivInsertOption = 0;
		AnySign.SetUITarget (aTarget);
		
		var verifyhsmModule = __SANDBOX.loadModule("verifyhsm");
		var verifyhsmDialog = verifyhsmModule({
			args: {},
			onconfirm: function (pin) {
				verifyhsmDialog.dispose();
				_show_guidewindow ();
				AnySign.mDivInsertOption = pageDivInsertOption;
				
				__SANDBOX.upInterface().loginPKCS11FromIndex(gSelectedMediaID, pin, _CB_loginPKCS11FromIndex);
			},
			oncancel: function () {
				verifyhsmDialog.dispose(); 
				AnySign.mDivInsertOption = pageDivInsertOption;
				aTarget.focus();
			}
		});
		verifyhsmDialog.show();
	}
	
	function _iccard_result()
	{
		_CB_loginStoreToken = function (aResult)
		{
			if(aResult != 0) {
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
		
		AnySign.mDivInsertOption = 0;
		AnySign.SetUITarget (aTarget);
		
		var aICCardType;
		if (aMediaType == XWC.CERT_LOCATION_KEPCOICCARD)
			aICCardType = "kepco";
		else
			aICCardType = "iccard";
		
		var iccardModule = __SANDBOX.loadModule("iccard");
		var iccardDialog = iccardModule({
			type: aICCardType,
			args: {},
			onconfirm: function (aPin) {
				iccardDialog.dispose();
				_show_guidewindow ();
				AnySign.mDivInsertOption = pageDivInsertOption;
				
				__SANDBOX.upInterface().loginStoreToken(gSelectedMediaID, aPin, 0, _CB_loginStoreToken);
			},
			oncancel: function () {
				iccardDialog.dispose();
				AnySign.mDivInsertOption = pageDivInsertOption;
				aTarget.focus();
			}
		});
		iccardDialog.show();
	}
	
	function _securedisk_result()
	{
		_CB_initializeSecureDiskFromName = function (aResult)
		{
			if (aResult != 0) {
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
		
		AnySign.mDivInsertOption = 0;
		_show_guidewindow ();
		AnySign.mDivInsertOption = pageDivInsertOption;
		
		__SANDBOX.upInterface().initializeSecureDiskFromName(gProviderName, _CB_initializeSecureDiskFromName);
	}
	
	if (confirm(XWC.S.deleteconfirm)) {
		if (aMediaType == XWC.CERT_LOCATION_PKCS11) {
			_verifyhsm_result();
		}
		else if (aMediaType == XWC.CERT_LOCATION_ICCARD || aMediaType == XWC.CERT_LOCATION_KEPCOICCARD) {
			_iccard_result();
		}
		else if (aMediaType == XWC.CERT_LOCATION_SECUREDISK) {
			_securedisk_result();
		} else {
			aGuideDialog = null;
			_deleteCertificate();
		}
	}
}

function refreshTableView(aCertList) {
	var aList;

	__92.style.display = "none";

	gSelectedSubjectRDN = null;
	gSelectedIssuerRDN = null;
	gSelectedCertSerial = null;
	gSelectedCertClass = null;
	gSelectedRowIndex = null;

	aList = stringToCertList(aCertList);

	if (gFilter) {
		gFilter(aList);
	}

	gCertTableView.refresh(aList);
	
		try {
		if(gInputHandler) gInputHandler.clear();
	} catch (e) {
			}
	
		setTimeout (function () {
		try {
			if(gInputHandler) gInputHandler.refresh();
		} catch (e) {
					}
	}, 0);
}

function stringToCertList(aString) {
	var aResultList = [],
		aList,
		i,
		j = 0;

	if (aString) {
		aList = XWC.stringToArray(aString);

		for (i = 0; i < aList.length; i++) {
			if (aList[i][1].length == 0) {
				aList[i][1] = XWC.S.privatecert;
			}
			if (aList[i][0] == '2' && !AnySign.mShowExpiredCert) {
				continue;
			}else {
				aResultList[j++] = aList[i];
			}
		}
	}

	return aResultList;
}

function setPasswordInputDisable() {	
	gNeedPassword = false;
	
	__118.style.display = 'none';
	__123.style.display = 'none';
	__126.style.display = 'none';
	__129.style.display = 'none';
	
	__116.style.display = 'none';
	__134.style.display = 'none';
	__135.style.display = '';
}

function setPasswordInputEnable(aEnable) {
	var aKeywordInputEnable;
	
	if (gDialogObj.type == "envelope")
		return false;
	
	if (aEnable == undefined) {
		gNeedPassword = true;
		aKeywordInputEnable = !gDisablePasswordInput;
	} else {
		aKeywordInputEnable = aEnable;
	}
	
	if (gInputHandler) {
		gInputHandler.enable(aKeywordInputEnable);
		gInputHandler.clear();
	}
	
	if(!aKeywordInputEnable) {
		__118.style.display = 'none';
		__123.style.display = 'none';
		__126.style.display = 'none';
		__129.style.display = 'none';
		
		__116.style.display = 'none';
		__134.style.display = 'none';
		__135.style.display = '';
	} else {
				__116.style.display = '';
		__134.style.display = '';
		__135.style.display = 'none';
	}

	if (AnySign.mWBStyleApply) {
		if (AnySign.mPlatform == AnySign.mPlatformList[0] ||AnySign.mPlatform == AnySign.mPlatformList[1] || (__SANDBOX.browserName == "opera" && __SANDBOX.browserVersion >= 12.0))
		{
			__120.readOnly = true;
			__122.checked = true;
			__122.disabled = true;
			certselect_tk1.useTransKey = true;
		}
	}
	
	return aKeywordInputEnable;
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
				gCurrentStateList[index] = element.disabled;
				if (index < gMaxButton && index != gSelectedButton-1)
					gMediaRadio.setDisabled (element, true);
				else
					element.disabled = true;
			}
			break;
		case "enabled":
			for (index = 0; index < gCurrentStateList.length; index++)
			{
				element = document.getElementById(gButtonList[index]);
				if (index < gMaxButton && index != gSelectedButton-1)
					gMediaRadio.setDisabled (element, gCurrentStateList[index]);
				else
					element.disabled = gCurrentStateList[index];
			}
			gCurrentStateList = [];
			break;
	}
}

function setDeleteButton (enable)
{
	if (enable == true)
		__SANDBOX.setButton([__113], "disabled", false, null);
	else
		__SANDBOX.setButton([__113], "disabled", true, null);
}

function onInputMouseCheckBoxClick (aEvent)
{
	var aChecked = false;
	var aTransKey = false;

	aEvent = aEvent || window.event;

	var objMouseBtn = __122;
	var bgImgUrl = objMouseBtn.style.backgroundImage;

	if (bgImgUrl.indexOf("off.png") > 0)
	{
		objMouseBtn.style.backgroundImage = bgImgUrl.replace("off.png", "on.png");
		aChecked = true;
	}
	else
	{
		objMouseBtn.style.backgroundImage = bgImgUrl.replace("on.png", "off.png");
		aChecked = false;
	}

	aTransKey = certselect_tk1;

	if (aChecked)
	{
		aTransKey.useTransKey = true;
		__120.readOnly = true;
		showTransKeyBtn ("certselect_tk1");
		aTransKey.clear ();
	}
	else
	{
		aTransKey.useTransKey = false;
		__120.readOnly = false;
		aTransKey.clear ();
		aTransKey.close ();
	}

	if (!certselect_tk1.useTransKey && aChecked == null)
	{
		aTransKey.useTransKey = true;
		__120.readOnly = true;
		showTransKeyBtn ("certselect_tk1");
		aTransKey.clear ();
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

function onCheckMedia(e) {
		if (gSelectedButton != 12)
		setInputHandler("4pc", false);
	
	var _refreshMedia = function () {
		if (gSelectedButton == 1) {
			onHddButtonClick(gEvent);
		} else if (gSelectedButton == 2) {
			onRemovableButtonClick(gEvent);
		} else if (gSelectedButton == 3) {
			onSaveTokenButtonClick(gEvent);
		} else if (gSelectedButton == 4) {
			onHSMButtonClick(gEvent);
		} else if (gSelectedButton == 5) {
			onMobileButtonClick(gEvent);
		} else if (gSelectedButton == 6) {
			onSmartCertButtonClick(gEvent);
		} else if (gSelectedButton == 7) {
			onSecureDiskButtonClick(gEvent);
		} else if (gSelectedButton == 12) {
			onFindCertButtonClick(gEvent);
		}
	}
	
	var _CB_external = function (aResult) {
		if (aResult == undefined || aResult == 0) {
			AnySign.mExtensionSetting.mExternalCallback.result = 0;
			
			if (gDialogObj.type != "envelope")
				createInputHandler_4pc();
			
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

function setInputHandler(aInputType, aEnable)
{
	var aElement;
	
	if (gDialogObj.type == "envelope")
		return;
	
	if (aInputType == "lite") {
		__118.style.display = 'none';
		__123.style.display = '';
		__126.style.display = 'none';
		__129.style.display = 'none';
		aElement = __125;
		gInputHandler = gInputHandler_lite;
	} else if (aInputType == "xfs") {
		__118.style.display = 'none';
		__123.style.display = 'none';
		__126.style.display = '';
		__129.style.display = 'none';
		aElement = __128;
		gInputHandler = gInputHandler_xfs;
	} else if (aInputType == "e2e") {
		__118.style.display = 'none';
		__123.style.display = 'none';
		__126.style.display = 'none';
		__129.style.display = '';
		aElement = __131;
		gInputHandler = gInputHandler_e2e;
	} else {
		__118.style.display = '';
		__123.style.display = 'none';
		__126.style.display = 'none';
		__129.style.display = 'none';
		aElement = __120;
		gInputHandler = gInputHandler_4pc;
	}
	
	if (aEnable != undefined) {
		if (aEnable) {
			aElement.style.backgroundColor = '#FFFFFF';
			aElement.disabled = false;
		} else {
			aElement.style.backgroundColor = '#EEEEEE';
			aElement.disabled = true;
		}
	}
}

function createInputHandler_4pc()
{
	if (__SANDBOX.IEVersion == 8) {
		gInputHandler_4pc = new __SANDBOX.inputKeyHandler("certselect", __120, 1, -122, -3, "qwerty_crt", 30, 110);
	} else {
		if (AnySign.mWBStyleApply)
			gInputHandler_4pc = new __SANDBOX.inputKeyHandler("certselect", __120, 1, -120, 5, "qwerty_crt", 30, 170);
		else
			gInputHandler_4pc = new __SANDBOX.inputKeyHandler("certselect", __120, 1, -120, 5, "qwerty_crt", 30, 110);
	}

	gInputHandler_4pc.onComplete({
		ok : function () {
			if (AnySign.mDivInsertOption < 1) {
				if (onOKButtonClick(null) == false) {
					return false;
				}
			}
		},
		close : function () {
			if (AnySign.mDivInsertOption < 1) {
				gInputHandler_4pc.clear(); 
			}
		}
	});
	
	gInputHandler = gInputHandler_4pc;
	
	if (setPasswordInputEnable()) {
		gInputHandler_4pc.onEnterKeyPress(__138);
	}
}

function createInputHandler_lite()
{
	if (__SANDBOX.IEVersion == 8) {
		gInputHandler_lite = new __SANDBOX.inputKeyHandler("certselect", __125, 1, -122, -3, "qwerty_crt", 30, 110, "lite");
	} else {
		if (AnySign.mWBStyleApply)
			gInputHandler_lite = new __SANDBOX.inputKeyHandler("certselect", __125, 1, -120, 5, "qwerty_crt", 30, 170, "lite");
		else
			gInputHandler_lite = new __SANDBOX.inputKeyHandler("certselect", __125, 1, -120, 5, "qwerty_crt", 30, 110, "lite");
	}

	gInputHandler_lite.onComplete({
		ok : function () {
			if (AnySign.mDivInsertOption < 1) {
				if (onOKButtonClick(null) == false) {
					return false;
				}
			}
		},
		close : function () {
			if (AnySign.mDivInsertOption < 1) {
				gInputHandler_lite.clear(); 
			}
		}
	});
	
	gInputHandler = gInputHandler_lite;
	
	if (setPasswordInputEnable()) {
		gInputHandler_lite.onEnterKeyPress(__138);
	}
}

function createInputHandler_xfs()
{
	var aInputType = "e2e";
		
	if (__SANDBOX.IEVersion == 8) {
		gInputHandler_xfs = new __SANDBOX.inputKeyHandler("certselect", __128, 1, -122, -3, "qwerty_crt", 30, 110, aInputType);
	} else {
		if (AnySign.mWBStyleApply)
			gInputHandler_xfs = new __SANDBOX.inputKeyHandler("certselect", __128, 1, -120, 5, "qwerty_crt", 30, 170, aInputType);
		else
			gInputHandler_xfs = new __SANDBOX.inputKeyHandler("certselect", __128, 1, -120, 5, "qwerty_crt", 30, 110, aInputType);
	}

	gInputHandler_xfs.onComplete({
		ok : function () {
			if (AnySign.mDivInsertOption < 1) {
				if (onOKButtonClick(null) == false) {
					return false;
				}
			}
		},
		close : function () {
			if (AnySign.mDivInsertOption < 1) {
				gInputHandler_xfs.clear(); 
			}
		}
	});
	
	gInputHandler = gInputHandler_xfs;
	
	if (setPasswordInputEnable()) {
		gInputHandler_xfs.onEnterKeyPress(__138);
	}
}

function createInputHandler_e2e()
{
	if (__SANDBOX.IEVersion == 8) {
		gInputHandler_e2e = new __SANDBOX.inputKeyHandler("certselect", __131, 1, -122, -3, "qwerty_crt", 30, 110, "e2e");
	} else {
		if (AnySign.mWBStyleApply)
			gInputHandler_e2e = new __SANDBOX.inputKeyHandler("certselect", __131, 1, -120, 5, "qwerty_crt", 30, 170, "e2e");
		else
			gInputHandler_e2e = new __SANDBOX.inputKeyHandler("certselect", __131, 1, -120, 5, "qwerty_crt", 30, 110, "e2e");
	}

	gInputHandler_e2e.onComplete({
		ok : function () {
			if (AnySign.mDivInsertOption < 1) {
				if (onOKButtonClick(null) == false) {
					return false;
				}
			}
		},
		close : function () {
			if (AnySign.mDivInsertOption < 1) {
				gInputHandler_e2e.clear(); 
			}
		}
	});
	
	gInputHandler = gInputHandler_e2e;
	
	if (setPasswordInputEnable()) {
		gInputHandler_e2e.onEnterKeyPress(__138);
	}
}

var __1 = XWC.UI.createElement('DIV');
__1.setAttribute('role', 'dialog', 0);
__1.style.width = '450px';
var __2 = XWC.UI.createElement('DIV');
__2.setAttribute('title', XWC.S.title, 0);
__2.setAttribute('id', 'xwup_title', 0);
__2.className = 'xwup-title xwup-title2';
var __3 = XWC.UI.createElement('H3');
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
__5.setAttribute('id', 'xwup_body', 0);
__5.className = 'xwup-body';
var __6 = XWC.UI.createElement('DIV');
__6.setAttribute('id', 'xwup_header', 0);
var __7 = XWC.UI.createElement('IMG');
__7.setAttribute('id', 'xwup_banner', 0);
__7.setAttribute('src', AnySign.mBasePath+'/img/banner.png', 0);
__7.setAttribute('width', '410', 0);
__7.setAttribute('height', '66', 0);
__7.className = 'banner';
__7.setAttribute('alt', XWC.S.selectsign, 0);
__6.appendChild(__7);
__5.appendChild(__6);
var __8 = XWC.UI.createElement('DIV');
__8.className = 'blank10';
__5.appendChild(__8);
var __9 = XWC.UI.createElement('FIELDSET');
__9.setAttribute('role', 'radiogroup', 0);
__9.className = 'xwup-location-item';
var __10 = XWC.UI.createElement('LEGEND');
if (__SANDBOX.IEVersion == 8) {
__10.style.display = 'block';
}
__10.setAttribute('id', 'xwup_legend_location_item', 0);
__10.className = 'xwup-legend';
__10.appendChild(document.createTextNode(XWC.S.media_location));
__9.appendChild(__10);
var __11 = XWC.UI.createElement('TABLE');
__11.setAttribute('cellpadding', '0', 0);
__11.setAttribute('cellspacing', '0', 0);
__11.className = 'xwup-cert-position';
__11.style.width = '400px';
var __12 = XWC.UI.createElement('CAPTION');
__12.appendChild(document.createTextNode(XWC.S.media_location));
__11.appendChild(__12);
var __13 = XWC.UI.createElement('TBODY');
var __14 = XWC.UI.createElement('TR');
var __15 = XWC.UI.createElement('TD');
__15.setAttribute('id', 'xwup_location_1', 0);
__15.style.display = 'none';
__14.appendChild(__15);
var __16 = XWC.UI.createElement('TD');
__16.setAttribute('id', 'xwup_location_2', 0);
__16.style.display = 'none';
__14.appendChild(__16);
var __17 = XWC.UI.createElement('TD');
__17.setAttribute('id', 'xwup_location_3', 0);
__17.style.display = 'none';
__14.appendChild(__17);
var __18 = XWC.UI.createElement('TD');
__18.setAttribute('id', 'xwup_location_4', 0);
__18.style.display = 'none';
__14.appendChild(__18);
var __19 = XWC.UI.createElement('TD');
__19.setAttribute('id', 'xwup_location_5', 0);
__19.style.display = 'none';
__14.appendChild(__19);
var __20 = XWC.UI.createElement('TD');
__20.setAttribute('id', 'xwup_location_6', 0);
__20.style.display = 'none';
__14.appendChild(__20);
var __21 = XWC.UI.createElement('TD');
__21.setAttribute('id', 'xwup_location_7', 0);
__21.style.display = 'none';
__14.appendChild(__21);
var __22 = XWC.UI.createElement('TD');
__22.setAttribute('id', 'xwup_location_8', 0);
__22.style.display = 'none';
__14.appendChild(__22);
var __23 = XWC.UI.createElement('TD');
__23.setAttribute('id', 'xwup_location_9', 0);
__23.style.display = 'none';
__14.appendChild(__23);
var __24 = XWC.UI.createElement('TD');
__24.setAttribute('id', 'xwup_location_10', 0);
__24.style.display = 'none';
__14.appendChild(__24);
var __25 = XWC.UI.createElement('TD');
__25.setAttribute('id', 'xwup_location_11', 0);
__25.style.display = 'none';
__14.appendChild(__25);
var __26 = XWC.UI.createElement('TD');
__26.setAttribute('id', 'xwup_location_12', 0);
__26.style.display = 'none';
__14.appendChild(__26);
var __27 = XWC.UI.createElement('TD');
__27.setAttribute('id', 'xwup_location_13', 0);
__27.style.display = 'none';
__14.appendChild(__27);
var __28 = XWC.UI.createElement('TD');
__28.setAttribute('id', 'xwup_location_14', 0);
__28.style.display = 'none';
__14.appendChild(__28);
var __29 = XWC.UI.createElement('TD');
__29.setAttribute('id', 'xwup_location_15', 0);
__29.style.display = 'none';
__14.appendChild(__29);
var __30 = XWC.UI.createElement('TD');
__30.setAttribute('id', 'xwup_location_right', 0);
__30.style.display = 'none';
var __31 = XWC.UI.createElement('BUTTON');
__31.setAttribute('tabindex', '3', 0);
__31.setAttribute('type', 'button', 0);
__31.setAttribute('id', 'xwup_media_right', 0);
__31.style.width = '18px';
__31.style.height = '29px';
__31.style.border = '0px';
__31.style.margin = '1px';
__31.style.padding = '3px';
__31.setAttribute('title', XWC.S.media_right_title, 0);
__31.onclick = function(event) {onMediaRight(this);};
var __32 = XWC.UI.createElement('SPAN');
__32.style.height = '9px';
__32.className = 'xwup-ico-arrow-right';
__31.appendChild(__32);
__30.appendChild(__31);
var __33 = XWC.UI.createElement('BUTTON');
__33.setAttribute('tabindex', '3', 0);
__33.setAttribute('type', 'button', 0);
__33.setAttribute('id', 'xwup_media_left', 0);
__33.style.width = '18px';
__33.style.height = '29px';
__33.style.border = '0px';
__33.style.margin = '1px';
__33.style.padding = '3px';
__33.setAttribute('title', XWC.S.media_left_title, 0);
__33.onclick = function(event) {onMediaLeft(this);};
var __34 = XWC.UI.createElement('SPAN');
__34.style.height = '9px';
__34.className = 'xwup-ico-arrow-left-disabled';
__33.appendChild(__34);
__30.appendChild(__33);
__14.appendChild(__30);
var __35 = XWC.UI.createElement('BUTTON');
__35.setAttribute('role', 'radio', 0);
__35.setAttribute('aria-checked', 'false', 0);
__35.setAttribute('type', 'button', 0);
__35.setAttribute('tabindex', '3', 0);
__35.style.display = 'none';
__35.setAttribute('id', 'xwup_media_localstorage', 0);
__35.onclick = function(event) {onLocalStorageButtonClick(this);};
__35.setAttribute('title', XWC.S.media_localstorage, 0);
var __36 = XWC.UI.createElement('SPAN');
__36.className = 'xwup-ico-localstorage';
__35.appendChild(__36);
var __37 = XWC.UI.createElement('SPAN');
__37.className = 'xwup-rbg-text';
__37.appendChild(document.createTextNode(XWC.S.media_localstorage));
__35.appendChild(__37);
__14.appendChild(__35);
var __38 = XWC.UI.createElement('BUTTON');
__38.setAttribute('role', 'radio', 0);
__38.setAttribute('aria-checked', 'false', 0);
__38.setAttribute('type', 'button', 0);
__38.setAttribute('tabindex', '3', 0);
__38.style.display = 'none';
__38.setAttribute('id', 'xwup_media_memorystorage', 0);
__38.onclick = function(event) {onMemoryStorageButtonClick(this);};
__38.setAttribute('title', XWC.S.media_memorystorage, 0);
var __39 = XWC.UI.createElement('SPAN');
__39.className = 'xwup-ico-memorystorage';
__38.appendChild(__39);
var __40 = XWC.UI.createElement('SPAN');
__40.className = 'xwup-rbg-text';
__40.appendChild(document.createTextNode(XWC.S.media_memorystorage));
__38.appendChild(__40);
__14.appendChild(__38);
var __41 = XWC.UI.createElement('BUTTON');
__41.setAttribute('role', 'radio', 0);
__41.setAttribute('aria-checked', 'false', 0);
__41.setAttribute('type', 'button', 0);
__41.setAttribute('tabindex', '3', 0);
__41.style.display = 'none';
__41.setAttribute('id', 'xwup_media_hdd', 0);
__41.onclick = function(event) {onHddButtonClick(this);};
__41.setAttribute('title', XWC.S.media_hdd, 0);
var __42 = XWC.UI.createElement('SPAN');
__42.className = 'xwup-ico-hdd';
__41.appendChild(__42);
var __43 = XWC.UI.createElement('SPAN');
__43.className = 'xwup-rbg-text';
__43.appendChild(document.createTextNode(XWC.S.media_hdd));
__41.appendChild(__43);
__14.appendChild(__41);
var __44 = XWC.UI.createElement('BUTTON');
__44.setAttribute('role', 'radio', 0);
__44.setAttribute('aria-checked', 'false', 0);
__44.setAttribute('type', 'button', 0);
__44.setAttribute('tabindex', '3', 0);
__44.style.display = 'none';
__44.setAttribute('id', 'xwup_media_removable', 0);
__44.onclick = function(event) {onRemovableButtonClick(this);};
__44.setAttribute('title', XWC.S.media_removable, 0);
var __45 = XWC.UI.createElement('SPAN');
__45.className = 'xwup-ico-removable';
__44.appendChild(__45);
var __46 = XWC.UI.createElement('SPAN');
__46.className = 'xwup-rbg-text';
__46.appendChild(document.createTextNode(XWC.S.media_removable));
__44.appendChild(__46);
__14.appendChild(__44);
var __47 = XWC.UI.createElement('BUTTON');
__47.setAttribute('role', 'radio', 0);
__47.setAttribute('aria-checked', 'false', 0);
__47.setAttribute('type', 'button', 0);
__47.setAttribute('tabindex', '3', 0);
__47.style.display = 'none';
__47.setAttribute('id', 'xwup_media_savetoken', 0);
__47.onclick = function(event) {onSaveTokenButtonClick(this);};
__47.setAttribute('title', XWC.S.media_savetoken, 0);
var __48 = XWC.UI.createElement('SPAN');
__48.className = 'xwup-ico-savetoken';
__47.appendChild(__48);
var __49 = XWC.UI.createElement('SPAN');
__49.className = 'xwup-rbg-text';
__49.appendChild(document.createTextNode(XWC.S.media_savetoken));
__47.appendChild(__49);
__14.appendChild(__47);
var __50 = XWC.UI.createElement('BUTTON');
__50.setAttribute('role', 'radio', 0);
__50.setAttribute('aria-checked', 'false', 0);
__50.setAttribute('type', 'button', 0);
__50.setAttribute('tabindex', '3', 0);
__50.style.display = 'none';
__50.setAttribute('id', 'xwup_media_pkcs11', 0);
__50.onclick = function(event) {onHSMButtonClick(this);};
__50.setAttribute('title', XWC.S.open_layer + XWC.S.media_pkcs11, 0);
var __51 = XWC.UI.createElement('SPAN');
__51.className = 'xwup-ico-pkcs11';
__50.appendChild(__51);
var __52 = XWC.UI.createElement('SPAN');
__52.className = 'xwup-rbg-text';
__52.appendChild(document.createTextNode(XWC.S.media_pkcs11));
__50.appendChild(__52);
__14.appendChild(__50);
var __53 = XWC.UI.createElement('BUTTON');
__53.setAttribute('role', 'radio', 0);
__53.setAttribute('aria-checked', 'false', 0);
__53.setAttribute('type', 'button', 0);
__53.setAttribute('tabindex', '3', 0);
__53.style.display = 'none';
__53.setAttribute('id', 'xwup_media_mobile', 0);
__53.onclick = function(event) {onMobileButtonClick(this);};
__53.setAttribute('title', XWC.S.media_mobile, 0);
var __54 = XWC.UI.createElement('SPAN');
__54.className = 'xwup-ico-mobile';
__53.appendChild(__54);
var __55 = XWC.UI.createElement('SPAN');
__55.className = 'xwup-rbg-text';
__55.appendChild(document.createTextNode(XWC.S.media_mobile));
__53.appendChild(__55);
__14.appendChild(__53);
var __56 = XWC.UI.createElement('BUTTON');
__56.setAttribute('role', 'radio', 0);
__56.setAttribute('aria-checked', 'false', 0);
__56.setAttribute('type', 'button', 0);
__56.setAttribute('tabindex', '3', 0);
__56.style.display = 'none';
__56.setAttribute('id', 'xwup_media_smartcert', 0);
__56.onclick = function(event) {onSmartCertButtonClick(this);};
__56.setAttribute('title', XWC.S.media_smartcert, 0);
var __57 = XWC.UI.createElement('SPAN');
__57.className = 'xwup-ico-smartcert';
__56.appendChild(__57);
var __58 = XWC.UI.createElement('SPAN');
__58.className = 'xwup-rbg-text';
__58.appendChild(document.createTextNode(XWC.S.media_smartcert));
__56.appendChild(__58);
__14.appendChild(__56);
var __59 = XWC.UI.createElement('BUTTON');
__59.setAttribute('role', 'radio', 0);
__59.setAttribute('aria-checked', 'false', 0);
__59.setAttribute('type', 'button', 0);
__59.setAttribute('tabindex', '3', 0);
__59.style.display = 'none';
__59.setAttribute('id', 'xwup_media_securedisk', 0);
__59.onclick = function(event) {onSecureDiskButtonClick(this);};
__59.setAttribute('title', XWC.S.media_securedisk, 0);
var __60 = XWC.UI.createElement('SPAN');
__60.className = 'xwup-ico-securedisk';
__59.appendChild(__60);
var __61 = XWC.UI.createElement('SPAN');
__61.className = 'xwup-rbg-text';
__61.appendChild(document.createTextNode(XWC.S.media_securedisk));
__59.appendChild(__61);
__14.appendChild(__59);
var __62 = XWC.UI.createElement('BUTTON');
__62.setAttribute('role', 'radio', 0);
__62.setAttribute('aria-checked', 'false', 0);
__62.setAttribute('type', 'button', 0);
__62.setAttribute('tabindex', '3', 0);
__62.style.display = 'none';
__62.setAttribute('id', 'xwup_media_xfs', 0);
__62.onclick = function(event) {onXecureFreeSignButtonClick(this);};
__62.setAttribute('title', XWC.S.media_xfs, 0);
var __63 = XWC.UI.createElement('SPAN');
__63.className = 'xwup-ico-xfs';
__62.appendChild(__63);
var __64 = XWC.UI.createElement('SPAN');
__64.className = 'xwup-rbg-text';
__64.appendChild(document.createTextNode(XWC.S.media_xfs));
__62.appendChild(__64);
__14.appendChild(__62);
var __65 = XWC.UI.createElement('BUTTON');
__65.setAttribute('role', 'radio', 0);
__65.setAttribute('aria-checked', 'false', 0);
__65.setAttribute('type', 'button', 0);
__65.setAttribute('tabindex', '3', 0);
__65.style.display = 'none';
__65.setAttribute('id', 'xwup_media_webpage', 0);
__65.onclick = function(event) {onWebPageButtonClick(this);};
__65.setAttribute('title', XWC.S.media_webpage, 0);
var __66 = XWC.UI.createElement('SPAN');
__66.className = 'xwup-ico-xfs';
__65.appendChild(__66);
var __67 = XWC.UI.createElement('SPAN');
__67.className = 'xwup-rbg-text';
__67.appendChild(document.createTextNode(XWC.S.media_webpage));
__65.appendChild(__67);
__14.appendChild(__65);
var __68 = XWC.UI.createElement('BUTTON');
__68.setAttribute('role', 'radio', 0);
__68.setAttribute('aria-checked', 'false', 0);
__68.setAttribute('type', 'button', 0);
__68.setAttribute('tabindex', '3', 0);
__68.style.display = 'none';
__68.setAttribute('id', 'xwup_media_nfciccard', 0);
__68.onclick = function(event) {onNFCICCardButtonClick(this);};
__68.setAttribute('title', XWC.S.media_nfciccard, 0);
var __69 = XWC.UI.createElement('SPAN');
__69.className = 'xwup-ico-nfciccard';
__68.appendChild(__69);
var __70 = XWC.UI.createElement('SPAN');
__70.className = 'xwup-rbg-text';
__70.appendChild(document.createTextNode(XWC.S.media_nfciccard));
__68.appendChild(__70);
__14.appendChild(__68);
__13.appendChild(__14);
__11.appendChild(__13);
__9.appendChild(__11);
__5.appendChild(__9);
var __71 = XWC.UI.createElement('DIV');
__71.setAttribute('tabindex', '3', 0);
__71.setAttribute('id', 'xwup_cert_table', 0);
__71.setAttribute('title', XWC.S.certtable, 0);
__71.setAttribute('role', 'application', 0);
__71.className = 'xwup-tableview';
__71.style.width = '408px';
var __72 = XWC.UI.createElement('TABLE');
__72.setAttribute('cellpadding', '0', 0);
__72.setAttribute('cellspacing', '0', 0);
__72.setAttribute('role', 'grid', 0);
__72.setAttribute('summary', XWC.S.table_summary, 0);
var __73 = XWC.UI.createElement('CAPTION');
__73.appendChild(document.createTextNode(XWC.S.certtable));
__72.appendChild(__73);
var __74 = XWC.UI.createElement('THEAD');
var __75 = XWC.UI.createElement('TR');
var __76 = XWC.UI.createElement('TH');
__76.setAttribute('role', 'columnheader', 0);
__76.setAttribute('scope', 'col', 0);
__76.className = 'xwup-mcert';
__76.setAttribute('sortType', 'IT', 0);
__76.style.width = '82px';
var __77 = XWC.UI.createElement('DIV');
__77.className = 'wide-cert-table-resizearea';
__77.appendChild(document.createTextNode(XWC.S.table_section));
var __78 = XWC.UI.createElement('DIV');
__77.appendChild(__78);
__76.appendChild(__77);
__75.appendChild(__76);
var __79 = XWC.UI.createElement('TH');
__79.setAttribute('role', 'columnheader', 0);
__79.setAttribute('scope', 'col', 0);
__79.className = 'xwup-mcert2';
__79.setAttribute('sortType', 'T', 0);
__79.style.width = '164px';
var __80 = XWC.UI.createElement('DIV');
__80.className = 'wide-cert-table-resizearea';
__80.appendChild(document.createTextNode(XWC.S.table_user));
var __81 = XWC.UI.createElement('DIV');
__80.appendChild(__81);
__79.appendChild(__80);
__75.appendChild(__79);
var __82 = XWC.UI.createElement('TH');
__82.setAttribute('role', 'columnheader', 0);
__82.setAttribute('scope', 'col', 0);
__82.className = 'xwup-mcert3';
__82.setAttribute('sortType', 'T', 0);
__82.style.width = '82px';
var __83 = XWC.UI.createElement('DIV');
__83.className = 'wide-cert-table-resizearea';
__83.appendChild(document.createTextNode(XWC.S.table_expire));
var __84 = XWC.UI.createElement('DIV');
__83.appendChild(__84);
__82.appendChild(__83);
__75.appendChild(__82);
var __85 = XWC.UI.createElement('TH');
__85.setAttribute('role', 'columnheader', 0);
__85.setAttribute('scope', 'col', 0);
__85.className = 'xwup-mcert4';
__85.setAttribute('sortType', 'T', 0);
__85.style.width = '82px';
var __86 = XWC.UI.createElement('DIV');
__86.className = 'wide-cert-table-resizearea';
__86.appendChild(document.createTextNode(XWC.S.table_issuer));
var __87 = XWC.UI.createElement('DIV');
__86.appendChild(__87);
__85.appendChild(__86);
__75.appendChild(__85);
__74.appendChild(__75);
__72.appendChild(__74);
var __88 = XWC.UI.createElement('TBODY');
var __89 = XWC.UI.createElement('TR');
var __90 = XWC.UI.createElement('TD');
__89.appendChild(__90);
__88.appendChild(__89);
__72.appendChild(__88);
__71.appendChild(__72);
__5.appendChild(__71);
var __91 = XWC.UI.createElement('DIV');
__91.className = 'xwup-widget-sec';
var __92 = XWC.UI.createElement('DIV');
__92.setAttribute('id', 'xwup_expire_alert', 0);
__92.className = 'xwup-expire-alert';
var __93 = XWC.UI.createElement('DIV');
__93.className = 'xwup-expire-icon';
var __94 = XWC.UI.createElement('IMG');
__94.setAttribute('src', AnySign.mBasePath+'/img/cert1.png', 0);
__94.setAttribute('width', '18', 0);
__94.setAttribute('height', '16', 0);
__94.setAttribute('alt', XWC.S.cert_status1, 0);
__93.appendChild(__94);
__92.appendChild(__93);
var __95 = XWC.UI.createElement('DIV');
__95.setAttribute('id', 'xwup_expire_message', 0);
__95.className = 'xwup-expire-message';
__95.appendChild(document.createTextNode(XWC.S.willbeexpired));
__92.appendChild(__95);
var __96 = XWC.UI.createElement('DIV');
__96.className = 'xwup-renew-message';
__96.appendChild(document.createTextNode(XWC.S.renewplease1));
var __97 = XWC.UI.createElement('BR');
__96.appendChild(__97);
__96.appendChild(document.createTextNode(XWC.S.renewplease2));
__92.appendChild(__96);
var __98 = XWC.UI.createElement('DIV');
__98.setAttribute('id', 'xwup_expire_arrow_border', 0);
__98.className = 'xwup-expire-arrow-border';
__92.appendChild(__98);
var __99 = XWC.UI.createElement('DIV');
__99.setAttribute('id', 'xwup_expire_arrow', 0);
__99.className = 'xwup-expire-arrow';
__92.appendChild(__99);
__91.appendChild(__92);
var __100 = XWC.UI.createElement('DIV');
__100.setAttribute('id', 'xwup_capslock', 0);
__100.className = 'xwup-expire-alert';
__100.style.display = 'none';
var __101 = XWC.UI.createElement('SPAN');
__101.className = 'fb';
__101.appendChild(document.createTextNode(XWC.S.tooltip_capslock1));
__100.appendChild(__101);
var __102 = XWC.UI.createElement('SPAN');
__102.className = 'fc';
__102.appendChild(document.createTextNode(XWC.S.tooltip_capslock2));
__100.appendChild(__102);
var __103 = XWC.UI.createElement('DIV');
__103.setAttribute('id', 'xwup_capslock_arrow_border', 0);
__103.className = 'xwup-expire-arrow-border';
__100.appendChild(__103);
var __104 = XWC.UI.createElement('DIV');
__104.setAttribute('id', 'xwup_capslock_arrow', 0);
__104.className = 'xwup-expire-arrow';
__100.appendChild(__104);
__91.appendChild(__100);
__5.appendChild(__91);
var __105 = XWC.UI.createElement('DIV');
__105.className = 'xwup-content-box';
var __106 = XWC.UI.createElement('TABLE');
__106.setAttribute('cellpadding', '0', 0);
__106.setAttribute('cellspacing', '0', 0);
__106.setAttribute('border', '0', 0);
var __107 = XWC.UI.createElement('CAPTION');
__107.appendChild(document.createTextNode(XWC.S.table_manager));
__106.appendChild(__107);
var __108 = XWC.UI.createElement('TBODY');
var __109 = XWC.UI.createElement('TR');
var __110 = XWC.UI.createElement('TD');
__110.className = 'cert-buttons';
var __111 = XWC.UI.createElement('BUTTON');
__111.setAttribute('tabindex', '3', 0);
__111.setAttribute('type', 'button', 0);
__111.className = 'view';
__111.setAttribute('id', 'xwup_find', 0);
__111.onclick = function(event) {onFindCertButtonClick(event);};
__111.setAttribute('title', XWC.S.open_layer + XWC.S.searchcert, 0);
__111.appendChild(document.createTextNode(XWC.S.searchcert));
__110.appendChild(__111);
var __112 = XWC.UI.createElement('BUTTON');
__112.setAttribute('tabindex', '3', 0);
__112.setAttribute('type', 'button', 0);
__112.className = 'view';
__112.setAttribute('id', 'xwup_view', 0);
__112.onclick = function(event) {onViewVerifyButtonClick(event);};
__112.setAttribute('title', XWC.S.open_layer + XWC.S.viewcert, 0);
__112.appendChild(document.createTextNode(XWC.S.viewcert));
__110.appendChild(__112);
var __113 = XWC.UI.createElement('BUTTON');
__113.setAttribute('tabindex', '3', 0);
__113.setAttribute('type', 'button', 0);
__113.className = 'view';
__113.setAttribute('id', 'xwup_delete', 0);
__113.onclick = function(event) {onDeleteCertButtonClick(event);};
__113.setAttribute('title', XWC.S.deletecert, 0);
__113.appendChild(document.createTextNode(XWC.S.deletecert));
__110.appendChild(__113);
__109.appendChild(__110);
var __114 = XWC.UI.createElement('TD');
__114.style.verticalAlign = 'middle';
var __115 = XWC.UI.createElement('FORM');
if (__SANDBOX.IEVersion <= 8) {
__115.mergeAttributes(XWC.UI.createElement("<FORM name='xwup_certselect_tek_form'>"),false);
} else {
__115.setAttribute('name', 'xwup_certselect_tek_form', 0);
}
__115.setAttribute('id', 'xwup_certselect_tek_form', 0);
__115.className = 'xwup-cert-passwd';
__115.onsubmit = function(event) {return false;};
var __116 = XWC.UI.createElement('DIV');
__116.setAttribute('id', 'xwup_certselect_pwd_guide', 0);
var __117 = XWC.UI.createElement('SPAN');
__117.appendChild(document.createTextNode(XWC.S.decpasswd));
__116.appendChild(__117);
__115.appendChild(__116);
var __118 = XWC.UI.createElement('DIV');
__118.className = 'xwup-passwd-field';
__118.setAttribute('id', 'certselect_tk1', 0);
var __119 = XWC.UI.createElement('LABEL');
__119.htmlFor = 'xwup_certselect_tek_input1';
__119.className = 'xwup-tit-pw';
__119.appendChild(document.createTextNode(XWC.S.passwd));
__118.appendChild(__119);
var __120 = XWC.UI.createElement('INPUT');
__120.setAttribute('type', 'password', 0);
__120.setAttribute('tabindex', '3', 0);
if (__SANDBOX.IEVersion <= 8) {
__120.mergeAttributes(XWC.UI.createElement("<INPUT name='certselect_tek_input1'>"),false);
} else {
__120.setAttribute('name', 'certselect_tek_input1', 0);
}
__120.setAttribute('id', 'xwup_certselect_tek_input1', 0);
__120.setAttribute('title', XWC.S.passwd, 0);
__120.className = 'xwup-pw-box';
__120.setAttribute('kbd', 'qwerty_crt', 0);
__118.appendChild(__120);
var __121 = XWC.UI.createElement('DIV');
__121.setAttribute('title', XWC.S.passwd, 0);
__121.setAttribute('id', 'xwup_certselect_fake_input1', 0);
__121.style.display = 'none';
__118.appendChild(__121);
var __122 = XWC.UI.createElement('INPUT');
__122.setAttribute('type', 'button', 0);
if (__SANDBOX.IEVersion <= 8) {
__122.mergeAttributes(XWC.UI.createElement("<INPUT name='certselect_tek_check1'>"),false);
} else {
__122.setAttribute('name', 'certselect_tek_check1', 0);
}
__122.setAttribute('tabindex', '3', 0);
__122.setAttribute('title', XWC.S.input_mouse, 0);
__122.setAttribute('id', 'xwup_certselect_tek_check1', 0);
__122.style.display = 'none';
__122.onclick = function(event) {onInputMouseCheckBoxClick();};
__118.appendChild(__122);
__115.appendChild(__118);
var __123 = XWC.UI.createElement('DIV');
__123.className = 'xwup-passwd-field';
__123.style.display = 'none';
var __124 = XWC.UI.createElement('LABEL');
__124.htmlFor = 'xwup_certselect_lite_input1';
__124.className = 'xwup-tit-pw';
__124.appendChild(document.createTextNode(XWC.S.passwd));
__123.appendChild(__124);
var __125 = XWC.UI.createElement('INPUT');
__125.setAttribute('type', 'password', 0);
__125.setAttribute('tabindex', '3', 0);
if (__SANDBOX.IEVersion <= 8) {
__125.mergeAttributes(XWC.UI.createElement("<INPUT name='certselect_lite_input1'>"),false);
} else {
__125.setAttribute('name', 'certselect_lite_input1', 0);
}
__125.setAttribute('id', 'xwup_certselect_lite_input1', 0);
__125.setAttribute('title', XWC.S.passwd, 0);
__125.className = 'xwup-pw-box';
__123.appendChild(__125);
__115.appendChild(__123);
var __126 = XWC.UI.createElement('DIV');
__126.className = 'xwup-passwd-field';
__126.style.display = 'none';
var __127 = XWC.UI.createElement('LABEL');
__127.htmlFor = 'xwup_certselect_lite_input1';
__127.className = 'xwup-tit-pw';
__127.appendChild(document.createTextNode(XWC.S.passwd));
__126.appendChild(__127);
var __128 = XWC.UI.createElement('INPUT');
__128.setAttribute('type', 'password', 0);
__128.setAttribute('tabindex', '3', 0);
if (__SANDBOX.IEVersion <= 8) {
__128.mergeAttributes(XWC.UI.createElement("<INPUT name='certselect_xfs_input1'>"),false);
} else {
__128.setAttribute('name', 'certselect_xfs_input1', 0);
}
__128.setAttribute('id', 'xwup_certselect_xfs_input1', 0);
__128.setAttribute('title', XWC.S.passwd, 0);
__128.className = 'xwup-pw-box';
__126.appendChild(__128);
__115.appendChild(__126);
var __129 = XWC.UI.createElement('DIV');
__129.className = 'xwup-passwd-field';
__129.style.display = 'none';
var __130 = XWC.UI.createElement('LABEL');
__130.htmlFor = 'xwup_certselect_lite_input1';
__130.className = 'xwup-tit-pw';
__130.appendChild(document.createTextNode(XWC.S.passwd));
__129.appendChild(__130);
var __131 = XWC.UI.createElement('INPUT');
__131.setAttribute('type', 'password', 0);
__131.setAttribute('tabindex', '3', 0);
if (__SANDBOX.IEVersion <= 8) {
__131.mergeAttributes(XWC.UI.createElement("<INPUT name='certselect_e2e_input1'>"),false);
} else {
__131.setAttribute('name', 'certselect_e2e_input1', 0);
}
__131.setAttribute('id', 'xwup_certselect_e2e_input1', 0);
__131.setAttribute('title', XWC.S.passwd, 0);
__131.className = 'xwup-pw-box';
__129.appendChild(__131);
__115.appendChild(__129);
var __132 = XWC.UI.createElement('DIV');
__132.setAttribute('id', 'xwup_certselect_tek_guide', 0);
__132.className = 'xwup-passwd-field';
var __133 = XWC.UI.createElement('IMG');
__133.setAttribute('src', AnySign.mBasePath+'/img/bu.png', 0);
__133.setAttribute('width', '16', 0);
__133.setAttribute('height', '16', 0);
__133.setAttribute('alt', XWC.S.exclamation_img, 0);
__132.appendChild(__133);
var __134 = XWC.UI.createElement('SPAN');
__134.setAttribute('id', 'xwup_certselect_tek_guide_msg1', 0);
__134.appendChild(document.createTextNode(XWC.S.input_guide));
__132.appendChild(__134);
var __135 = XWC.UI.createElement('SPAN');
__135.setAttribute('id', 'xwup_certselect_tek_guide_msg2', 0);
__135.appendChild(document.createTextNode(XWC.S.input_guide2));
__132.appendChild(__135);
var __136 = XWC.UI.createElement('SPAN');
__136.setAttribute('id', 'xwup_certselect_tek_guide_msg3', 0);
__136.style.display = 'none';
__136.appendChild(document.createTextNode(XWC.S.sign_complete_msg));
__132.appendChild(__136);
__115.appendChild(__132);
__114.appendChild(__115);
__109.appendChild(__114);
__108.appendChild(__109);
__106.appendChild(__108);
__105.appendChild(__106);
__5.appendChild(__105);
var __137 = XWC.UI.createElement('DIV');
__137.className = 'xwup-buttons-layout';
var __138 = XWC.UI.createElement('BUTTON');
__138.setAttribute('type', 'button', 0);
__138.setAttribute('tabindex', '3', 0);
__138.setAttribute('id', 'xwup_OkButton', 0);
__138.onclick = function(event) {onOKButtonClick(event)};
__138.appendChild(document.createTextNode(XWC.S.button_ok));
__137.appendChild(__138);
var __139 = XWC.UI.createElement('BUTTON');
__139.setAttribute('type', 'button', 0);
__139.setAttribute('tabindex', '3', 0);
__139.setAttribute('id', 'xwup_CancelButton', 0);
__139.onclick = function(event) {onCancelButtonClick(event)};
__139.appendChild(document.createTextNode(XWC.S.button_cancel));
__137.appendChild(__139);
__5.appendChild(__137);
__1.appendChild(__5);
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
