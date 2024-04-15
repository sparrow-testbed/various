var __certsaveloc = function(__SANDBOX) {
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
var gDialogObj,
	gSelectedMediaID,
	gRadioButtons,
	gErrCallback,
	gOKButtonClick,
	gEvent,
	gSelectedButton = 1,
	gIsFalseInstallPageNewOpen = false;


XWC.getLocaleResource("certsaveloc", XWC.lang());

function onload(aDialogObj) {
	var aMediaList,
		aIDList,
		aSelectElement,
		aOption,
		aHSMList,
		aCertLocationSet = __SANDBOX.certLocationSet,
		aDisableItem,
		aGuideModule,
		aGuideDialog = null,
		i;
	
    gDialogObj = aDialogObj;
	gErrCallback = aDialogObj.args.errCallback;
	
	XWC.UI.setDragAndDrop(__2);
	
	gRadioButtons = [ __14,								  __17,							  __23,								  __29,								  __32,							  __35,								  __43,							  __46,								  __8,						  __38,							  __26,						  __11];				
		__SANDBOX.setButton([gRadioButtons[3],
						 gRadioButtons[4],
						 gRadioButtons[6]],
						 "disabled", true, 0);
	
	__28.style.display = "none";
	__31.style.display = "none";
	__42.style.display = "none";
	
	 	 if (!(navigator.platform == "Win32" || navigator.platform == "Win64")) {
	 	__SANDBOX.setButton([gRadioButtons[2],
	 						 gRadioButtons[5],
							 gRadioButtons[7],
	 						 gRadioButtons[9],
							 gRadioButtons[10]],
	 						 "disabled", true, 0);
	}

	aDisableItem = Math.floor(aDialogObj.args.disableItem / 100) * 100;
	if (aDisableItem == XWC.CERT_LOCATION_ICCARD)
		gRadioButtons[2].disabled = true;
	else if (aDisableItem == XWC.CERT_LOCATION_SECUREDISK)
		gRadioButtons[9].disabled = true;
	else if (aDisableItem == XWC.CERT_LOCATION_KEPCOICCARD)
		gRadioButtons[10].disabled = true;
	else if (aDisableItem == XWC.CERT_LOCATION_XECUREFREESIGN) {
		gRadioButtons[11].disabled = true;
		gRadioButtons[7].disabled = true;		}
	
				if (AnySign.mAnySignLiteSupport) {
				if( aDialogObj.args.type == "request")
		{
			gRadioButtons[8].checked = true;				gRadioButtons[5].disabled = false;
		}
		else
		{
			if (__SANDBOX.getInputType(aDialogObj.args.disableItem) == "lite") {
				gRadioButtons[8].disabled = true;
				gRadioButtons[0].checked = true;					gRadioButtons[7].disabled = true;				} else {
				if (aDialogObj.args.disableItem == 1) {
					gRadioButtons[0].disabled = true;
					gRadioButtons[1].checked = true;
					__19.disabled = false;
				} else {
					gRadioButtons[0].checked = true;
				}
			}
		}

	} else {
		__7.style.display = "none";
		
				if (aDialogObj.args.disableItem == 1) {
			gRadioButtons[0].disabled = true;
			gRadioButtons[1].checked = true;
			__19.disabled = false;
		} else {
			gRadioButtons[0].checked = true;
		}
	}
	
	if (!aCertLocationSet["kepcoiccard"]) {
		__25.style.display = "none";
	}
	
	if (!AnySign.mXecureFreeSignEnable || aDialogObj.args.type == "request") {
		__10.style.display = "none";
	}

		_setLocationFinal = function ()
	{
		if (aGuideDialog)
			aGuideDialog.dispose();
	}
		
	
		_getIDListCallback = function (result)
	{
		if (result)
			aIDList = result.split("\t\n");

		if (__SANDBOX.isFailed(aIDList, gErrCallback)) {
			_setLocationFinal ();
			return;
		}

		aSelectElement = __19;
		for (i = 0; i < aMediaList.length; i++) {
			if ((aMediaList[i].length > 0) && (aIDList[i] != aDialogObj.args.disableItem)) {
				aOption = XWC.UI.createElement("option");
				aOption.value = Number(aIDList[i]);
				aOption.innerHTML = aMediaList[i];
				aSelectElement.appendChild(aOption);
			}
		}
		
		if (aSelectElement.length == 0)
			__SANDBOX.setButton([gRadioButtons[1]], "disabled", true, 0);
			
		_setLocationFinal ();
	}
	

		_getMediaListCallback = function (result)
	{
		if (result)
			aMediaList = result.split("\t\n");
		else {
			__SANDBOX.setButton([gRadioButtons[1]], "disabled", true, 0);
			_setLocationFinal ();
			return;
		}

		if (__SANDBOX.isFailed(aMediaList, gErrCallback)) {
			_setLocationFinal ();
			return;
		}
		
		__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_REMOVABLE, 1, 0, _getIDListCallback);
	}
	
	if (checkAnySignLoad() == true)
	{
		aGuideModule = __SANDBOX.loadModule("guidewindow");
		aGuideDialog = aGuideModule({
			type: "loading",
			args: "",
			onconfirm: "",
			oncancel: function () {aGuideDialog.dispose ();}
		});
		aGuideDialog.show();
		
		AnySign.mAnySignEnable = true;
	
		__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_REMOVABLE, 0, 1, _getMediaListCallback);
	}

	if (AnySign.mWBStyleApply)
	{
		var aButton = XWC.UI.createElement("a");
		var aParent = __4;

		aButton.id = "xwup_close";
		aButton.title = XWC.S.close;
		aButton.setAttribute ("tabindex", 4, 0);
		aButton.setAttribute ("href", "javascript:;", 0);
		aButton.className = "xwup-close-button";
		aButton.onclick = function () { onCancelButtonClick(); };

		aParent.appendChild(aButton);
	}

	return 0;
}

function setFocus() {
	__2.focus();
}

function onOKButtonClick(e) {
    var result = -1;

    if (__8.checked !== true &&
		__11.checked !== true)
    {
   		gSelectedButton = 7;

		if (checkAnySignLoad() == false) {
			gEvent = e;

			if (__17.checked == true) {
				gSelectedButton = 2;
			}

			onCheckMedia();	
			return;
		}
    }

    if (__14.checked == true) {
		result = 1;
    } else if (__17.checked == true) {
		result = __19.value;
    } else if (__23.checked == true) {
		result = XWC.CERT_LOCATION_ICCARD;
		var _getMediaListCallback = function (aResult) {
			if (aResult == "") {
				alert(XWC.S.no_iccard);
			} else {
				__49.disabled = true;
			    gDialogObj.onconfirm(Number(result));
			}
		}
		__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_ICCARD, 0, 1, _getMediaListCallback);
		return;
	} else if (__26.checked == true) {
		result = XWC.CERT_LOCATION_KEPCOICCARD;
    } else if (__35.checked == true) {
		result = XWC.CERT_LOCATION_PKCS11;
		var _getMediaListCallback = function (aResult) {
			if (aResult == "") {
				alert(XWC.S.no_pkcs11);
			} else {
				__49.disabled = true;
			    gDialogObj.onconfirm(Number(result));
			}
		}
		__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_PKCS11, 0, 1, _getMediaListCallback);
		return;
    } else if (__43.checked == true) {
		result = XWC.CERT_LOCATION_MPHONE;
	} else if (__46.checked == true) {
		gOKButtonClick = true;
		onUBIKeyButtonClick ();
		return;
	} else if (__8.checked == true) {

		if( gDialogObj.args.type == "request" )
		{
			AnySign.mAnySignEnable = false;
		}

		result = XWC.CERT_LOCATION_LOCALSTORAGE;
	} else if (__38.checked == true) {
		result = XWC.CERT_LOCATION_SECUREDISK;
	} else if (__11.checked == true) {
		result = XWC.CERT_LOCATION_XECUREFREESIGN;
	}

	__49.disabled = true;
    gDialogObj.onconfirm(Number(result));
}

function onCancelButtonClick(e) {
    gDialogObj.oncancel();
}

function onLocalStorageButtonClick(e) {
	var i;

	if( gDialogObj.args.type == "request" )
	{
		AnySign.mAnySignEnable = false;
	}

    for (i = 0; i < gRadioButtons.length; i++) {
		gRadioButtons[i].checked = false;
    }
    gRadioButtons[8].checked = true;
    
	if (__8.value == "on") {
		__19.disabled = true;
	} else {
		__19.disabled = false;
	}
}

function onXecureFreeSignButtonClick(e) {
	var i;

    for (i = 0; i < gRadioButtons.length; i++) {
		gRadioButtons[i].checked = false;
    }
    gRadioButtons[11].checked = true;
    
	if (__11.value == "on") {
		__19.disabled = true;
	} else {
		__19.disabled = false;
	}
}

function onHddButtonClick(e) {
	var i;

	gSelectedButton = 1;

	if (checkAnySignLoad() == false) {
		gEvent = e;
		onCheckMedia();	
		return;
	}

	AnySign.mAnySignEnable = true;

    for (i = 0; i < gRadioButtons.length; i++) {
		gRadioButtons[i].checked = false;
    }
    gRadioButtons[0].checked = true;
    
	if (__14.value == "on") {
		__19.disabled = true;
	} else {
		__19.disabled = false;
	}
}

function onRemovableButtonClick(e) {
	var i;

	gSelectedButton = 2;

	if (checkAnySignLoad() == false) {
		gEvent = e;
		onCheckMedia();	
		return;
	}

	AnySign.mAnySignEnable = true;

    for (i = 0; i < gRadioButtons.length; i++) {
		gRadioButtons[i].checked = false;
    }
    gRadioButtons[1].checked = true;
    
    if (__17.value == "on") {
		__19.disabled = false;
	} else {
		__19.disabled = true;
	}
}

function onICCardButtonClick(e) {
	var i;

	gSelectedButton = 3;

	if (checkAnySignLoad() == false) {
		gEvent = e;
		onCheckMedia();	
		return;
	}

	AnySign.mAnySignEnable = true;

    for (i = 0; i < gRadioButtons.length; i++) {
		gRadioButtons[i].checked = false;
    }
    gRadioButtons[2].checked = true;
    
    if (__23.value == "on") {
		__19.disabled = false;
	} else {
		__19.disabled = true;
	}
}

function onKEPCOICCardButtonClick(e) {
	var i;

	gSelectedButton = 8;

	if (checkAnySignLoad() == false) {
		gEvent = e;
		onCheckMedia();	
		return;
	}

	AnySign.mAnySignEnable = true;

    for (i = 0; i < gRadioButtons.length; i++) {
		gRadioButtons[i].checked = false;
    }
    gRadioButtons[10].checked = true;
    
    if (__26.value == "on") {
		__19.disabled = false;
	} else {
		__19.disabled = true;
	}
}

function onPKCS11ButtonClick(e) {
	var i;

	gSelectedButton = 4;

	if (checkAnySignLoad() == false) {
		gEvent = e;
		onCheckMedia();	
		return;
	}

	AnySign.mAnySignEnable = true;

    for (i = 0; i < gRadioButtons.length; i++) {
		gRadioButtons[i].checked = false;
    }
    gRadioButtons[5].checked = true;
    
    if (__35.value == "on") {
		__19.disabled = false;
	} else {
		__19.disabled = true;
	}
}

function onSecureDiskButtonClick(e) {
	var i;

	gSelectedButton = 5;

	if (checkAnySignLoad() == false) {
		gEvent = e;
		onCheckMedia();	
		return;
	}

	AnySign.mAnySignEnable = true;

    for (i = 0; i < gRadioButtons.length; i++) {
		gRadioButtons[i].checked = false;
    }
    gRadioButtons[9].checked = true;
    
    if (__38.value == "on") {
		__19.disabled = false;
	} else {
		__19.disabled = true;
	}
}

function onUBIKeyButtonClick(e) {
	var aMediaList,
		aUbikeyData,
		aPhoneData,
		aErrorObject;

	gSelectedButton = 6;

	if (checkAnySignLoad() == false) {
		gEvent = e;
		onCheckMedia();	
		return;
	}

	AnySign.mAnySignEnable = true;

	aUbikeyData = AnySign.mUbikeyData;

	aPhoneData = AnySign.mXgateAddress + "&"
						+ aUbikeyData.mSite + "|" + aUbikeyData.mLiveUpdate + "&"
						+ aUbikeyData.mSecurity + "|" + aUbikeyData.mKeyboardSecurity + "&"
						+ aUbikeyData.mVersion;

		_getMediaListCallback = function (result)
	{
		if ((typeof (result) == "string" && result == ""))
		{
			aErrorObject = __SANDBOX.upInterface().setErrCodeAndMsg();

			if (aErrorObject.code == 10010002)
			{
								result = confirm(XWC.JSSTR("installNotify"));

				if (result == true) 
					window.open(AnySign.mUbikeyData.mInstallURL, 'DownLoadPage', AnySign.mUbikeyData.mInstallPageOption);
			}
		}
		else
		{
			if (gOKButtonClick)
				gDialogObj.onconfirm(Number(XWC.CERT_LOCATION_YESSIGNM + 1));
		}
	}
	

		_setPhoneDataCallback = function ()
	{
		__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_YESSIGNM, 0, 0, _getMediaListCallback);
	}
	

	__SANDBOX.upInterface().setPhoneData (aPhoneData, 0x10, _setPhoneDataCallback);
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
	var aGuideModule,
		aGuideDialog = null;
	
	var _refreshMedia = function () {

			if (gSelectedButton == 1)
				onHddButtonClick(gEvent);
			else if (gSelectedButton == 2)
				onRemovableButtonClick(gEvent);
			else if (gSelectedButton == 3)
				onICCardButtonClick(gEvent);
			else if (gSelectedButton == 4)
				onPKCS11ButtonClick(gEvent);
			else if (gSelectedButton == 5)
				onSecureDiskButtonClick(gEvent);
			else if (gSelectedButton == 6)
				onUBIKeyButtonClick(gEvent);
			else if (gSelectedButton == 7)
				onOKButtonClick(gEvent);
			else if (gSelectedButton == 8)
				onKEPCOICCardButtonClick(gEvent);
	}

	var _initialMedia = function (aCallbackFunc) {

		_setLocationFinal = function ()
		{
			if (aGuideDialog)
				aGuideDialog.dispose();

			aCallbackFunc();
		}

		_getIDListCallback = function (result)
		{
			if (result)
				aIDList = result.split("\t\n");

			if (__SANDBOX.isFailed(aIDList, gErrCallback)) {
				if (aGuideDialog)
					aGuideDialog.dispose();
				return;
			}

			aSelectElement = __19;
			for (i = 0; i < aMediaList.length; i++) {
				if ((aMediaList[i].length > 0) && (aIDList[i] != gDialogObj.args.disableItem)) {
					aOption = XWC.UI.createElement("option");
					aOption.value = Number(aIDList[i]);
					aOption.innerHTML = aMediaList[i];
					aSelectElement.appendChild(aOption);
				}
			}

			if (aSelectElement.length == 0)
				__SANDBOX.setButton([gRadioButtons[1]], "disabled", true, 0);
			
			_setLocationFinal ();
		}

		_getMediaListCallback = function (result)
		{
			if (result)
				aMediaList = result.split("\t\n");
			else {
				__SANDBOX.setButton([gRadioButtons[1]], "disabled", true, 0);
				_setLocationFinal ();
				return;
			}

			if (__SANDBOX.isFailed(aMediaList, gErrCallback)) {
				if (aGuideDialog)
					aGuideDialog.dispose();
				return;
			}
			
			__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_REMOVABLE, 1, 0, _getIDListCallback);
		}

		if (AnySign.mAnySignEnable) {
			aGuideModule = __SANDBOX.loadModule("guidewindow");
			aGuideDialog = aGuideModule({
				type: "loading",
				args: "",
				onconfirm: "",
				oncancel: function () {aGuideDialog.dispose ();}
			});
			aGuideDialog.show();
		}

		__SANDBOX.upInterface().getMediaList(XWC.CERT_LOCATION_REMOVABLE, 0, 1, _getMediaListCallback);
	}
	
	var _CB_external = function (aResult) {
		if (aResult == undefined || aResult == 0) {
			AnySign.mExtensionSetting.mExternalCallback.result = 0;
			_initialMedia(_refreshMedia);

		}
	}
	
	var _Func_external = function (aResult) {

		if (gIsFalseInstallPageNewOpen == true)
		{
			AnySign.mInstallPageNewOpen = false;
			gIsFalseInstallPageNewOpen = false;
		}

		if (AnySign.mExtensionSetting.mExternalCallback.func &&
			AnySign.mExtensionSetting.mExternalCallback.result != 0)
			AnySign.mExtensionSetting.mExternalCallback.func(_CB_external);
		else
			_CB_external(0);
	}

			if (AnySign.mInstallPageNewOpen == false)
	{
		gIsFalseInstallPageNewOpen = true;
		AnySign.mInstallPageNewOpen = true;
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
__1.style.width = '400px';
__1.setAttribute('tabindex', '4', 0);
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
var __5 = XWC.UI.createElement('FIELDSET');
__5.className = 'p10x10-gray1';
var __6 = XWC.UI.createElement('LEGEND');
if (__SANDBOX.IEVersion == 8) {
__6.style.display = 'block';
}
__6.setAttribute('title', XWC.S.location, 0);
__6.appendChild(document.createTextNode(XWC.S.location));
__5.appendChild(__6);
var __7 = XWC.UI.createElement('DIV');
__7.className = 'xwup-slsave';
__7.setAttribute('id', 'xwup_div_localstorage', 0);
var __8 = XWC.UI.createElement('INPUT');
__8.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__8.mergeAttributes(XWC.UI.createElement("<INPUT name='loc'>"),false);
} else {
__8.setAttribute('name', 'loc', 0);
}
__8.setAttribute('id', 'xwup_certsaveloc_localstorage', 0);
__8.setAttribute('type', 'radio', 0);
__8.setAttribute('title', XWC.S.localstorage, 0);
__8.onclick = function(event) {onLocalStorageButtonClick(event);};
__7.appendChild(__8);
var __9 = XWC.UI.createElement('LABEL');
__9.htmlFor = 'xwup_certsaveloc_localstorage';
__9.appendChild(document.createTextNode(XWC.S.localstorage));
__7.appendChild(__9);
__5.appendChild(__7);
var __10 = XWC.UI.createElement('DIV');
__10.className = 'xwup-slsave';
__10.setAttribute('id', 'xwup_div_xfs', 0);
var __11 = XWC.UI.createElement('INPUT');
__11.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__11.mergeAttributes(XWC.UI.createElement("<INPUT name='loc'>"),false);
} else {
__11.setAttribute('name', 'loc', 0);
}
__11.setAttribute('id', 'xwup_certsaveloc_xfs', 0);
__11.setAttribute('type', 'radio', 0);
__11.setAttribute('title', XWC.S.xfs, 0);
__11.onclick = function(event) {onXecureFreeSignButtonClick(event);};
__10.appendChild(__11);
var __12 = XWC.UI.createElement('LABEL');
__12.htmlFor = 'xwup_certsaveloc_xfs';
__12.appendChild(document.createTextNode(XWC.S.xfs));
__10.appendChild(__12);
__5.appendChild(__10);
var __13 = XWC.UI.createElement('DIV');
__13.className = 'xwup-slsave';
var __14 = XWC.UI.createElement('INPUT');
__14.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__14.mergeAttributes(XWC.UI.createElement("<INPUT name='loc'>"),false);
} else {
__14.setAttribute('name', 'loc', 0);
}
__14.setAttribute('id', 'xwup_certsaveloc_hdd', 0);
__14.setAttribute('type', 'radio', 0);
__14.setAttribute('title', XWC.S.hdd, 0);
__14.onclick = function(event) {onHddButtonClick(event);};
__13.appendChild(__14);
var __15 = XWC.UI.createElement('LABEL');
__15.htmlFor = 'xwup_certsaveloc_hdd';
__15.appendChild(document.createTextNode(XWC.S.hdd));
__13.appendChild(__15);
__5.appendChild(__13);
var __16 = XWC.UI.createElement('DIV');
__16.className = 'xwup-slremovable';
var __17 = XWC.UI.createElement('INPUT');
__17.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__17.mergeAttributes(XWC.UI.createElement("<INPUT name='loc'>"),false);
} else {
__17.setAttribute('name', 'loc', 0);
}
__17.setAttribute('id', 'xwup_certsaveloc_removable', 0);
__17.setAttribute('type', 'radio', 0);
__17.setAttribute('title', XWC.S.removable, 0);
__17.onclick = function(event) {onRemovableButtonClick(event);};
__16.appendChild(__17);
var __18 = XWC.UI.createElement('LABEL');
__18.htmlFor = 'xwup_certsaveloc_removable';
__18.appendChild(document.createTextNode(XWC.S.removable));
__16.appendChild(__18);
__5.appendChild(__16);
var __19 = XWC.UI.createElement('SELECT');
__19.setAttribute('tabindex', '4', 0);
__19.setAttribute('id', 'xwup_removableselect', 0);
__19.setAttribute('title', XWC.S.removablelist, 0);
__19.className = 'xwup-slselect-cert';
__19.setAttribute('disabled', 'disabled', 0);
__5.appendChild(__19);
var __20 = XWC.UI.createElement('FIELDSET');
__20.className = 'p10x10-gray1 margin-bottom';
var __21 = XWC.UI.createElement('LEGEND');
if (__SANDBOX.IEVersion == 8) {
__21.style.display = 'block';
}
__21.appendChild(document.createTextNode(XWC.S.savetoken));
__20.appendChild(__21);
var __22 = XWC.UI.createElement('DIV');
__22.className = 'group';
var __23 = XWC.UI.createElement('INPUT');
__23.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__23.mergeAttributes(XWC.UI.createElement("<INPUT name='loc'>"),false);
} else {
__23.setAttribute('name', 'loc', 0);
}
__23.setAttribute('id', 'xwup_certsaveloc_iccard', 0);
__23.setAttribute('type', 'radio', 0);
__23.setAttribute('title', XWC.S.iccard, 0);
__23.onclick = function(event) {onICCardButtonClick(event);};
__22.appendChild(__23);
var __24 = XWC.UI.createElement('LABEL');
__24.htmlFor = 'xwup_certsaveloc_iccard';
__24.appendChild(document.createTextNode(XWC.S.iccard));
__22.appendChild(__24);
__20.appendChild(__22);
var __25 = XWC.UI.createElement('DIV');
__25.className = 'group';
__25.setAttribute('id', 'xwup_div_kepcoiccard', 0);
var __26 = XWC.UI.createElement('INPUT');
__26.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__26.mergeAttributes(XWC.UI.createElement("<INPUT name='loc'>"),false);
} else {
__26.setAttribute('name', 'loc', 0);
}
__26.setAttribute('id', 'xwup_certsaveloc_kepcoiccard', 0);
__26.setAttribute('type', 'radio', 0);
__26.setAttribute('title', XWC.S.iccard, 0);
__26.onclick = function(event) {onKEPCOICCardButtonClick(event);};
__25.appendChild(__26);
var __27 = XWC.UI.createElement('LABEL');
__27.htmlFor = 'xwup_certsaveloc_kepcoiccard';
__27.appendChild(document.createTextNode(XWC.S.kepcoiccard));
__25.appendChild(__27);
__20.appendChild(__25);
var __28 = XWC.UI.createElement('DIV');
__28.className = 'group';
__28.setAttribute('id', 'xwup_div_csp', 0);
var __29 = XWC.UI.createElement('INPUT');
__29.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__29.mergeAttributes(XWC.UI.createElement("<INPUT name='loc'>"),false);
} else {
__29.setAttribute('name', 'loc', 0);
}
__29.setAttribute('id', 'xwup_certsaveloc_csp', 0);
__29.setAttribute('type', 'radio', 0);
__29.setAttribute('title', XWC.S.csp, 0);
__29.setAttribute('disabled', 'disabled', 0);
__28.appendChild(__29);
var __30 = XWC.UI.createElement('LABEL');
__30.htmlFor = 'xwup_certsaveloc_csp';
__30.appendChild(document.createTextNode(XWC.S.csp));
__28.appendChild(__30);
__20.appendChild(__28);
var __31 = XWC.UI.createElement('DIV');
__31.className = 'group';
__31.setAttribute('id', 'xwup_div_usbtoken', 0);
var __32 = XWC.UI.createElement('INPUT');
__32.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__32.mergeAttributes(XWC.UI.createElement("<INPUT name='loc'>"),false);
} else {
__32.setAttribute('name', 'loc', 0);
}
__32.setAttribute('id', 'xwup_certsaveloc_usbtoken', 0);
__32.setAttribute('type', 'radio', 0);
__32.setAttribute('title', XWC.S.usbtoken, 0);
__32.setAttribute('disabled', 'disabled', 0);
__31.appendChild(__32);
var __33 = XWC.UI.createElement('LABEL');
__33.htmlFor = 'xwup_certsaveloc_usbtoken';
__33.appendChild(document.createTextNode(XWC.S.usbtoken));
__31.appendChild(__33);
__20.appendChild(__31);
__5.appendChild(__20);
var __34 = XWC.UI.createElement('DIV');
__34.className = 'xwup-sl-pkcs';
var __35 = XWC.UI.createElement('INPUT');
__35.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__35.mergeAttributes(XWC.UI.createElement("<INPUT name='loc'>"),false);
} else {
__35.setAttribute('name', 'loc', 0);
}
__35.setAttribute('id', 'xwup_certsaveloc_pkcs11', 0);
__35.setAttribute('type', 'radio', 0);
__35.setAttribute('title', XWC.S.pkcs11, 0);
__35.onclick = function(event) {onPKCS11ButtonClick(event);};
__34.appendChild(__35);
var __36 = XWC.UI.createElement('LABEL');
__36.htmlFor = 'xwup_certsaveloc_pkcs11';
__36.appendChild(document.createTextNode(XWC.S.pkcs11));
__34.appendChild(__36);
__5.appendChild(__34);
var __37 = XWC.UI.createElement('DIV');
__37.className = 'xwup-sl-securedisk';
__37.setAttribute('id', 'xwup_div_securedisk', 0);
var __38 = XWC.UI.createElement('INPUT');
__38.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__38.mergeAttributes(XWC.UI.createElement("<INPUT name='loc'>"),false);
} else {
__38.setAttribute('name', 'loc', 0);
}
__38.setAttribute('id', 'xwup_certsaveloc_securedisk', 0);
__38.setAttribute('type', 'radio', 0);
__38.setAttribute('title', XWC.S.securedisk, 0);
__38.onclick = function(event) {onSecureDiskButtonClick(event);};
__37.appendChild(__38);
var __39 = XWC.UI.createElement('LABEL');
__39.htmlFor = 'xwup_certsaveloc_securedisk';
__39.appendChild(document.createTextNode(XWC.S.securedisk));
__37.appendChild(__39);
__5.appendChild(__37);
var __40 = XWC.UI.createElement('FIELDSET');
__40.className = 'p10x10-gray1 margin-top';
var __41 = XWC.UI.createElement('LEGEND');
if (__SANDBOX.IEVersion == 8) {
__41.style.display = 'block';
}
__41.appendChild(document.createTextNode(XWC.S.mobile));
__40.appendChild(__41);
var __42 = XWC.UI.createElement('DIV');
__42.className = 'group';
__42.setAttribute('id', 'xwup_div_mobisign', 0);
var __43 = XWC.UI.createElement('INPUT');
__43.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__43.mergeAttributes(XWC.UI.createElement("<INPUT name='loc'>"),false);
} else {
__43.setAttribute('name', 'loc', 0);
}
__43.setAttribute('id', 'xwup_certsaveloc_mobisign', 0);
__43.setAttribute('type', 'radio', 0);
__43.setAttribute('title', XWC.S.mobisign, 0);
__43.setAttribute('disabled', 'disabled', 0);
__42.appendChild(__43);
var __44 = XWC.UI.createElement('LABEL');
__44.htmlFor = 'xwup_certsaveloc_mobisign';
__44.appendChild(document.createTextNode(XWC.S.mobisign));
__42.appendChild(__44);
__40.appendChild(__42);
var __45 = XWC.UI.createElement('DIV');
__45.className = 'group';
var __46 = XWC.UI.createElement('INPUT');
__46.setAttribute('tabindex', '4', 0);
if (__SANDBOX.IEVersion <= 8) {
__46.mergeAttributes(XWC.UI.createElement("<INPUT name='loc'>"),false);
} else {
__46.setAttribute('name', 'loc', 0);
}
__46.setAttribute('id', 'xwup_certsaveloc_mphone', 0);
__46.setAttribute('type', 'radio', 0);
__46.setAttribute('title', XWC.S.mphone, 0);
__46.onclick = function(event) {onUBIKeyButtonClick(event);};
__45.appendChild(__46);
var __47 = XWC.UI.createElement('LABEL');
__47.htmlFor = 'xwup_certsaveloc_mphone';
__47.appendChild(document.createTextNode(XWC.S.mphone));
__45.appendChild(__47);
__40.appendChild(__45);
__5.appendChild(__40);
__4.appendChild(__5);
var __48 = XWC.UI.createElement('DIV');
__48.className = 'xwup-buttons-layout';
var __49 = XWC.UI.createElement('BUTTON');
__49.setAttribute('tabindex', '4', 0);
__49.setAttribute('type', 'button', 0);
__49.setAttribute('id', 'xwup_ok', 0);
__49.onclick = function(event) {onOKButtonClick(event)};
__49.appendChild(document.createTextNode(XWC.S.button_ok));
__48.appendChild(__49);
var __50 = XWC.UI.createElement('BUTTON');
__50.setAttribute('tabindex', '4', 0);
__50.setAttribute('type', 'button', 0);
__50.setAttribute('id', 'xwup_cancel', 0);
__50.onclick = function(event) {onCancelButtonClick(event)};
__50.appendChild(document.createTextNode(XWC.S.button_cancel));
__48.appendChild(__50);
__4.appendChild(__48);
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
