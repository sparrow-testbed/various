/**
 *=============================================================================
 * P R O G R A M     I N F O R M A T I O N
 *============================================================================= 
 * PROJECT  : 전자구매
 * NAME     : 
 * DESC     :  
 * AUTHOR   : 퍼옴
 * VERSION  : v1.0
 * CopyrightⓒWOORI FIS Co., 2009 All rights reserved.
 *=============================================================================
 * V E R S I O N     C O N T R O L
 *=============================================================================
 *    DATE     AUTHOR                      DESCRIPTION                        
 *============================================================================= 
 *
 *=============================================================================
 **/
var isIE  = (navigator.appVersion.indexOf("MSIE") != -1) ? true : false;
var isWin = (navigator.appVersion.toLowerCase().indexOf("win") != -1) ? true : false;
var isOpera = (navigator.userAgent.indexOf("Opera") != -1) ? true : false;



////////////////////////////////////////////////////////////////////////////////////////////////
try {
	//window.parent.closeLoadingLayer();
	closeLoadingLayer();
} catch (e) { }


function closeLoadingLayer() {
	document.body.style.overflow = "auto";
	document.getElementById("divBackGround").style.display = "none";
	document.getElementById("divLoadingLayer").style.display = "none";
}

function showLoadingLayer() {
	document.body.style.overflow = "hidden";
	
	var waitBox = document.getElementById("divLoadingLayer");
	var backGround = document.getElementById("divBackGround");
	var scrollTop = document.body.scrollTop;
	var scrollLeft = document.body.scrollLeft;
	
	backGround.style.display = "";
	waitBox.style.display = "";
	
	var intBodyHeight = 0;
	var intBodyWidth = 0;
	if (isIE) {
		intBodyHeight = document.body.offsetHeight;
		intBodyWidth = document.body.offsetWidth;
	} else {
		intBodyHeight = window.innerHeight;
		intBodyWidth = window.innerWidth;
	}
	
	var wh = (intBodyHeight / 2) - (waitBox.offsetHeight / 2) + scrollTop;
	var ww = (intBodyWidth / 2) - (waitBox.offsetWidth / 2) + scrollLeft;
	
	if (wh < 0) wh = "0";
	if (ww < 0) ww = "0";
	
	waitBox.style.top = wh + "px";
	waitBox.style.left = ww + "px";
	
	backGround.style.top = scrollTop + "px";
	backGround.style.left = scrollLeft + "px";
}


function setDivBackground() {
	if (!document.getElementById("divBackGround")) {
		var htmlLayer = "<div id=\"divBackGround\" style=\"filter:alpha(opacity=70); position: absolute; z-index:100;left:0px; top:0px;display: none; width:100%; height:100%;\">"
			+ "<iframe width=\"100%\" height=\"100%\"frameborder=\"0\" scrolling=\"no\" ></iframe></div>";
		document.write(htmlLayer);
	}
}
setDivBackground();

function openLoadingLayer() {
	var waitBox = document.getElementById("divLoadingLayer");
	if (!waitBox) {
		var htmlLayer = "<div id=\"divLoadingLayer\" style=\"position:absolute; Z-INDEX:101; top:-1000px; left:-1000px\">"
			+ "<table><tr><td align=\"center\">"			
			+ "<b style=\"font-size:50px;color:red\">처리중 입니다..</b>"						
			+ "</td></tr>"					
			+ "<tr><td height=\"50px\">&nbsp;</td></tr>"			
			+ "<tr><td align=\"center\">"			
			+ "<b style=\"font-size:30px;color:blue\">처리메세지 확인후 화면이동 해주세요.</b>"						
			+ "</td></tr></table></div>";
		document.write (htmlLayer);
	}
}
openLoadingLayer();


function removeCloseLoding() {
	if (isIE) {
		window.detachEvent("onload", function () {closeLoadingLayer();});
	} else {
		window.removeEventListener("load", function() {closeLoadingLayer()}, false);	//mozilla,firefox
	}
}

if (isIE) {
	window.attachEvent("onload", function () {closeLoadingLayer();});
} else {
	window.addEventListener("load", function() {closeLoadingLayer()}, false);	//mozilla,firefox
}

