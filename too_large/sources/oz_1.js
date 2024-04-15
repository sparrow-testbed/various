
Web={
	version:"0.22",
	creator:"GoodBug",
	mail:"unicorn@jakartaproject.com;tomcat5@paran.com",
	homepage:"http://www.jakartaproject.com",
	updated:"2008.04.17"
};

Web.config={
	imageroot:_POASRM_CONTEXT_NAME+'/images/alice/'
};

(function() {
	var idSeq=0;
	var ua=navigator.userAgent.toLowerCase();
	var isStrict=document.compatMode=="CSS1Compat",isOpera=ua.indexOf("opera")>-1,isSafari=(/webkit|khtml/).test(ua),isIE=!isOpera&&ua.indexOf("msie")>-1,isIE7=!isOpera&&ua.indexOf("msie 7")>-1,isIE6=!isOpera&&ua.indexOf("msie 6")>-1,isGecko=!isSafari&&ua.indexOf("gecko")>-1,isBorderBox=isIE&&!isStrict,isWindows=(ua.indexOf("windows")!=-1||ua.indexOf("win32")!=-1),isMac=(ua.indexOf("macintosh")!=-1||ua.indexOf("mac os x")!=-1),isLinux=(ua.indexOf("linux")!=-1),isSecure=window.location.href.toLowerCase().indexOf("https")===0;
	Object.extend(Web, {isStrict:isStrict,isOpera:isOpera,isSafari:isSafari,isIE:isIE,isIE7:isIE7,isIE6:isIE6,isGecko:isGecko,isBorderBox:isBorderBox,isWindows:isWindows,isMac:isMac,isLinux:isLinux,isSecure:isSecure,
		extendIf:function(o,c){
			if(o&&c){
				for(var p in c){
					if(typeof o[p]=="undefined"){
						o[p]=c[p]
					}
				}
			}
			return o
		},
		
		namespace:function(){
			var a=arguments,o=null,i,j,d,rt;
			for(i=0;i<a.length;++i){
				d=a[i].split(".");
				rt=d[0];
				eval("if (typeof "+rt+" == \"undefined\"){"+rt+" = {};} o = "+rt+";");
				for(j=1;j<d.length;++j){
					o[d[j]]=o[d[j]]||{}	;
					o=o[d[j]]
				}
			}
		}
});

Web.namespace("Web.util");

Web.util.Position = {
	clientWidth: function() {
		return document.body.clientWidth 
				|| document.documentElement.clientWidth
				|| 0;
	},
	clientHeight: function() {
		return document.body.clientHeight
				|| document.documentElement.clientHeight
				|| 0;
	},
	scrollWidth: function() {
		return document.body.scrollWidth
				|| document.documentElement.scrollWidth
				|| 0;
	},
	scrollHeight: function() {
		return document.body.scrollHeight
				|| document.documentelement.scrollHeight
				|| 0;
	},
	offsetWidth: function() {
		return document.body.offsetWidth
				|| document.documentElement.offsetWidth
				|| 0;
	},
	offsetHeight: function() {
		return document.body.offsetHeight
				|| document.documentElement.offsetHeight
				|| 0;
	},
	deltaY: function() {
		return window.pageYOffset
				|| document.documentElement.scrollTop
				|| document.body.scrollTop
				|| 0;
	},
	deltaX: function() {
		return window.pageXOffset
				|| document.documentElement.scrollLeft
				|| document.body.scrollLeft
				|| 0;
	},
	pure: function(w) {
		w = w.toString();
		return w.gsub(/px/, '').gsub(/%/, '');
	},
	objectY: function(obj) {
		obj = $$(obj);
		if (obj) {
			if (obj.offsetParent == document.body || obj.offsetParent.tagName == "HTML") {
				return obj.offsetTop;
			} 
			else {
				return obj.offsetTop + this.objectY(obj.offsetParent);
			}
		}
	},
	objectX: function(obj) {
		obj = $$(obj);
		if (obj) {
			if (obj.offsetParent == document.body || obj.offsetParent.tagName == "HTML") {
				return obj.offsetLeft;
			} 
			else {
				return obj.offsetLeft + this.objectX(obj.offsetParent);
			}
		}
	}
};

Web.util.Shadow = {
	box: 'oz-box',
	shadow: 'oz-shadow',
	iframe: 'oz-iframe',
	show: function(el) {
		var obj = $$(this.shadow);
		var ifm = $$(this.iframe);
		if (!obj) {
			if (el) {				
				var html = "<iframe id="+this.iframe+" width=0 height=0></iframe><div id="+this.shadow+"></div>";
				if (el.insertAdjacentHTML) {
					el.insertAdjacentHTML('beforeBegin', html);
				}
				else {
					var oRange = document.createRange() ;
					oRange.setStartBefore(el);
					var oFragment = oRange.createContextualFragment(html);
					el.parentNode.insertBefore(oFragment, el);
				}
				obj = $$(this.shadow);
				ifm = $$(this.iframe);
			}
			else {
				ifm = document.createElement("iframe");
				ifm.setAttribute("id", this.iframe);
				document.body.appendChild(ifm);	
				
				obj = document.createElement("div");
				obj.setAttribute("id", this.shadow);
				document.body.appendChild(obj);	
			}
		}

		obj.style.zIndex = 8090;
		ifm.style.zIndex = 8089;
		obj.style.display = 'inline';
		ifm.style.display = 'inline';
		
		var h = 0;
		if ($$(this.box)) {
			h = Math.max($$(this.box).offsetHeight, Web.util.Position.scrollHeight());			
		}
		else {
			h = Math.max(Web.util.Position.scrollHeight(),Web.util.Position.clientHeight());			
		}
		obj.style.height = h;
		ifm.style.height = h;
	},
	hide: function() {
		if ($$(this.iframe)) {
			$$(this.iframe).style.display = 'none';
		}
		if ($$(this.shadow)) {
			$$(this.shadow).style.display = 'none';
		}
	}
};

Web.util.Button = {
	button: {
		'ok': '<div id=i-btn-ok-? class=w-btn-ok><img src="'+Web.config.imageroot+'oz/button/btn_ok.gif" onmouseover=this.src="'+Web.config.imageroot+'oz/button/btn_ok_o.gif" onmouseout=this.src="'+Web.config.imageroot+'oz/button/btn_ok.gif"></div>',
		'cancel': '<div id=i-btn-cancel-? class=w-btn-cancel><img src="'+Web.config.imageroot+'oz/button/btn_cancel.gif" onmouseover=this.src="'+Web.config.imageroot+'oz/button/btn_cancel_o.gif" onmouseout=this.src="'+Web.config.imageroot+'oz/button/btn_cancel.gif"></div>',
		'yes': '<div id=i-btn-yes-? class=w-btn-yes><img src="'+Web.config.imageroot+'oz/button/btn_yes.gif" onmouseover=this.src="'+Web.config.imageroot+'oz/button/btn_yes_o.gif" onmouseout=this.src="'+Web.config.imageroot+'oz/button/btn_yes.gif"></div>',
		'no': '<div id=i-btn-no-? class=w-btn-no><img src="'+Web.config.imageroot+'oz/button/btn_no.gif" onmouseover=this.src="'+Web.config.imageroot+'oz/button/btn_no_o.gif" onmouseout=this.src="'+Web.config.imageroot+'oz/button/btn_no.gif"></div>'
	}
};

Web.util.Image = {
	image: {
		'information' : '<span id=i-image-info class=w-image-info><img src="'+Web.config.imageroot+'oz/window/i_info.gif"></span>',
		'warning' : '<span id=i-image-warn class=w-image-warn><img src="'+Web.config.imageroot+'oz/window/i_warning.gif"></span>',
		'question' : '<span id=i-image-ques class=w-image-ques><img src="'+Web.config.imageroot+'oz/window/i_question.gif"></span>',
		'error': '<span id=i-image-error class=w-image-error><img src="'+Web.config.imageroot+'oz/window/i_error.gif"></span>',
		'topclose': '<img src='+Web.config.imageroot+'oz/box/i_close.gif onmouseover=this.src="'+Web.config.imageroot+'oz/box/i_close_o.gif" onmouseout=this.src="'+Web.config.imageroot+'oz/box/i_close.gif">'
	}
};

Web.util.Countdown = {
	current:null,
	init: function(cur) {
		this.current = new Date(cur.substring(0,4),cur.substring(4,6),cur.substring(6,8),cur.substring(8,10),cur.substring(10,12));
		this.go();
	},
	go: function() {
		var tm = this.current.getTime();
		this.current.setTime(tm+1000);
		setTimeout('Web.util.Countdown.go()',1000);
		
	},
	count: function(target) {
		var trt = new Date(target.substring(0,4),target.substring(4,6),target.substring(6,8),target.substring(8,10),target.substring(10,12));
		var cal = trt - this.current;
		var day = Math.floor(cal/(60*60*1000*24));
		var hour = Math.floor((cal%(60*60*1000*24))/(60*60*1000));
		var mn = Math.floor(((cal%(60*60*1000*24))%(60*60*1000))/(60*1000));
		var sec = Math.floor((((cal%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000);
		
		return (day == 0? '':day+'일 ')+(hour == 0? '':hour+'시간 ')+(mn == 0? '':mn+'분 ')+(sec == 0? '':sec+'초');
	}	
}

Web.util.Select = {
	
};

Web.PannelManager = {
	hash: new Hash,
	sequence:0,
	put: function(el) {
		this.hash[el.id] = el;
	},
	get: function(id) {				
		return this.hash[id];
	},
	getAll: function() {
		return this.hash;
	},
	getSeq: function() {
		return "oz.p."+(++this.sequence);
	},
	remove: function(id) {
		this.hash.remove(id);
	},
	removeAll: function() {
		var keys = this.hash.keys();
		for (var i = 0; i < keys.length; i++) {
			this.remove(keys[i]);
		}
	},
	hideAll: function() {
		var keys = this.hash.keys();
		for (var i = 0; i < keys.length; i++) {
			this.get(keys[i]).hide();
		}
	}
}

Web.Pannel = Class.create();
Web.Pannel.prototype = {
	initialize : function(id, args) {
		if (!id) {
			id = Web.PannelManager.getSeq();
		}
		if ($$(id) == null) {
			var div = document.createElement("div");
			div.setAttribute("id", id);
			document.body.appendChild(div);
		}

		this.opt = Object.extend({
			width: 150,
			height: 80
			}, args);
		this.speed = 3;
		this.term = 10;
		this.id = id;		
		this.el = $$(id);
		this.el.id = id;		
		this.el.style.position = 'absolute';
		this.el.style.cursor = 'default';
		this.el.style.width = this.opt.width + 'px';
		this.el.style.height = this.opt.height + 'px';
		this.el.style.left = '1px';
		this.el.style.top = Web.util.Position.deltaY()+'px';
		this.el.style.zIndex = 8090 + (++Web.PannelManager.sequence);
		Web.PannelManager.put(this);
	},	
	
	update: function(cts) {
		this.el.update(cts);
	},
	
	show: function() {		
		this.el.style.display = '';
		this.el.style.visibility = 'visible';

		var tp = parseInt(Web.util.Position.pure(this.el.style.top));
		var ht = parseInt(Web.util.Position.pure(this.opt.height));
		this.el.style.top = (tp-ht)+'px';
		this.slideIn();
	},
	
	slideIn: function() {
		var tp = parseInt(Web.util.Position.pure(this.el.style.top));
		var ht = parseInt(Web.util.Position.pure(this.opt.height));
		var dy = parseInt(Web.util.Position.deltaY());
		if (tp >= dy) {
			setTimeout("Web.PannelManager.get('"+this.el.id+"').slideOut()", 3000);
			this.speed = 3;
			this.term = 10;
		}
		else {
			this.el.style.top = (tp + this.speed)+'px';
			setTimeout("Web.PannelManager.get('"+this.el.id+"').slideIn()",	this.term);
		}
	},
	
	slideOut: function() {
		var tp = parseInt(Web.util.Position.pure(this.el.style.top));
		var ht = parseInt(Web.util.Position.pure(this.opt.height));
		if (tp <= (0-ht)) {
			this.hide();	
		}
		else {			
			this.el.style.top = (tp - this.speed)+'px';
			setTimeout("Web.PannelManager.get('"+this.el.id+"').slideOut()", this.term);
		}
	},

	hide: function() {
		this.update('');
		this.el.style.visibility = 'hidden';
		this.el.style.display = 'none';
		Web.PannelManager.remove(this.el.id);		
	}
}


Web.InformationManager = {
	message: function(arg) {
		args = Object.extend(arg);
		inform = new Web.InformationBox(args.id, args);
		inform.message(args.title, args.msg);		
	}	
}

Web.InformationBox = Class.create();
Web.InformationBox.prototype = {
	message: function(title, msg) {		
		this.generate({
			title: title,
			msg: msg
		});
		this.show();
	},
	generate: function(args) {
		var div = '<fieldset onselectstart="return false" class=w-inform-box style="width:'+(args.width? args.width:this.opt.width)+'px;height:'+(args.height? args.height:this.opt.height)+'px">'+
						'<div class=title>'+args.title+'</div>'+
						'<div class=message>'+args.msg+'</div>'+
				  '</fieldset>';
		this.update(div);
	}
}

Object.extend(Web.InformationBox.prototype, Web.Pannel.prototype);

Web.CanvasManager = {
	hash: new Hash,
	sequence:0,
	put: function(el) {
		this.hash[el.id] = el;
	},
	get: function(id) {				
		return this.hash[id];
	},
	getAll: function() {
		return this.hash;
	},
	getSeq: function() {
		return "oz.s."+(++this.sequence);
	},
	remove: function(id) {
		this.hash.remove(id);
	},
	removeAll: function() {
		var keys = this.hash.keys();
		for (var i = 0; i < keys.length; i++) {
			this.remove(keys[i]);
		}
	},
	hideAll: function() {
		var keys = this.hash.keys();
		for (var i = 0; i < keys.length; i++) {
			this.get(keys[i]).hide();
		}
	},
	getRecent: function() {
		var keys = this.hash.keys();
		for (var i = 0; i < keys.length; i++) {
			return this.hash[keys[i]];
		}
	},
	getDragId: function() {
		var id = null;
		var keys = this.hash.keys();		
		for (var i = 0; i < keys.length; i++) {
			if ($$(keys[i]).dragging) {
				id = keys[i];
			}
		}
		return id;
	},
	isExist: function() {
		var keys = this.hash.keys();
		return keys.length>0 ? true : false;
	}
};

Web.Canvas = Class.create();
Web.Canvas.prototype = {
	initialize : function(id, args) {
		if (!id) {
			id = Web.CanvasManager.getSeq();
		}
		if ($$(id) == null) {
			var div = document.createElement("div");
			div.setAttribute("id", id);
			document.body.appendChild(div);			
		}

		this.opt = Object.extend({
			width: 320,
			height: 100
			}, args);
		this.captureKeyEnable = true;
		this.type = args.type;
		this.id = id;		
		this.el = $$(id);
		this.el.id = id;		
		this.el.style.position = 'absolute';
		this.el.style.cursor = 'default';
		this.el.style.width = this.opt.width + 'px';
		this.el.style.height = this.opt.height + 'px';
		this.el.style.left = ((Web.util.Position.clientWidth()/2) - (this.opt.width/2)) + 'px';
		this.el.style.top = ((Web.util.Position.clientHeight()/2) + Web.util.Position.deltaY() - (this.opt.height/2)) + 'px';
		this.el.style.zIndex = 8090 + (++Web.CanvasManager.sequence);
		this.el.dragging = false;
		if (this.opt.focus) {
			this.focus = this.opt.focus;
		}
		
		if (this.opt.blur) {
			$$(this.opt.blur).blur();
		}
		
		try {
			this.el.focus();
		} catch (e){}
		
		if (!Web.CanvasManager.isExist()) {
			var object = null;
			if (Web.isIE) {
				object = $$(this.id);
			}
			else {
				object = window;
			}
			Event.observe(object, "keyup", this.captureKey);
			Event.observe(document.body, "mousemove", this.drag);
			Event.observe(document.body, "mouseup", this.dragEnd);			
		}
		Event.observe(this.id, "mousedown", this.dragBegin);

		Web.CanvasManager.put(this);
	},	
	
	captureKey: function(event) {
		//	ESC : 27,
		//ENTER : 13,
		//SPACE : 32,
		
		//if ((Web.isIE && event.keyCode == 13)
		if (event.keyCode == 32) {				
			var el = Web.CanvasManager.getRecent();	
			if (el && el.captureKeyEnable) {
				el.terminate();
			}
		}
		else if (event.keyCode == 27) {
			var el = Web.CanvasManager.getRecent();	
			if (el && el.captureKeyEnable) {
				el.hide();
			}
		}
	},
	
	update: function(cts) {
		this.el.update(cts);
	},
	
	show: function() {		
		this.el.style.display = '';
		this.el.style.visibility = 'visible';
		Web.util.Shadow.show(this.el);
	},

	hide: function() {
		this.update('');
		this.el.style.visibility = 'hidden';
		this.el.style.display = 'none';
		Web.CanvasManager.remove(this.el.id);
		if (this.opt.focus) {
			try {
				$$(this.opt.focus).focus();
			}
			catch (e){};
		}
		if (!Web.CanvasManager.isExist()) {
			Web.util.Shadow.hide();
		}

		this.destroy();
	},
	
	terminate: function(el) {		
		if (this.defaultClickId) {
			$$(this.defaultClickId).onclick();
		}
		this.hide();
	},
	
	destroy: function() {
		if (!Web.CanvasManager.isExist()) {
			Event.stopObserving(document.body, "mousemove", this.drag);
			Event.stopObserving(document.body, "mouseup", this.dragEnd);			
			Event.stopObserving(document.body, "keyup", this.captureKey);
		}
		Event.stopObserving(this.id, "mousedown", this.dragBegin);
	},
	
	dragBegin: function(event) {
		var ob = Web.isIE? event.srcElement : event.target;		
		if (ob.className == 'w-box-tm-txt') {
			var el = Event.findElement(event, 'div');
			el.dragging = true;		
			el.diffx = Event.pointerX(event) - el.offsetLeft;
			el.diffy = Event.pointerY(event) - el.offsetTop;
		}
	},

	drag: function(event) {
		var id = Web.CanvasManager.getDragId();	
		el = $$(id);
		if (!el || !el.dragging) {
			return;
		}
		
		el.style.left = Event.pointerX(event) - el.diffx + 'px';
		el.style.top  = Event.pointerY(event) - el.diffy + 'px';
	},

	dragEnd: function(event) {
		var id = Web.CanvasManager.getDragId();
		el = $$(id);
		if (!el) {
			return;
		}
		el.dragging = false;
	}
};

Web.MessageManager = {
	SEQ:0,
	message: function(arg) {
		args = Object.extend({type:'message'}, arg);
		msg = new Web.MessageBox(args.id, args);
		msg.message(args.title, args.msg, args.fn);
		
	},
	
	alert: function(arg) {
		if (!Web.MessageManager.isExist()) {
			args = Object.extend({type:'message'}, arg);
			msg = new Web.MessageBox(args.id, args);
			msg.alert(args.title, args.msg, args.fn);
		}
	},
	
	confirm: function(arg) {
		if (!Web.MessageManager.isExist()) {
			args = Object.extend({type:'messages'}, arg);
			msg = new Web.MessageBox(args.id, args);
			msg.confirm(args.title, args.msg, args.fnok, args.fncancel);
		}
	},
	
	yesno: function(arg) {
		if (!Web.MessageManager.isExist()) {
			args = Object.extend({type:'messages'}, arg);
			msg = new Web.MessageBox(args.id, args);
			msg.yesno(args.title, args.msg, args.fnyes, args.fnno);
		}
	},
	
	yesnocancel: function(arg) {
		if (!Web.MessageManager.isExist()) {
			args = Object.extend({type:'messages'}, arg);
			msg = new Web.MessageBox(args.id, args);
			msg.yesnocancel(args.title, args.msg, args.fnyes, args.fnno, args.fncancel);
		}
	},
	
	getMessageBox: function(id) {
		return Web.CanvasManager.get(id);
	},
	
	isExist: function() {
		var h = Web.CanvasManager.getAll();
		var keys = h.keys();		
		for (var i = 0; i < keys.length; i++) {
			if (h[keys[i]].type == 'message') {
				return true;
			}
		}
		return false;
	}
};

Web.MessageBox = Class.create();
Web.MessageBox.prototype = {
	OK: {ok:true},
	CANCEL: {cancel:true},
	OKCANCEL: {ok:true, cancel:true},
	YESNO: {yes:true, no:true},
	YESNOCANCEL: {yes:true, no:true, cancel:true},
	INFO: {information:true},
	WARNING: {warning:true},
	QUESTION: {question:true},
	ERROR: 'error',
	
	defaultClick: function(id, fn) {
		if (fn) {
			this.defaultClickId = id;
		}
	},
	
	message: function(title, msg, fn) {		
		var ok = ++Web.MessageManager.SEQ;
		this.generate({
			title: title,
			msg: msg,
			buttons: this.OK,
			icon: this.INFO,
			okkey:ok
		});
		this.show();
		this.defaultClick("i-btn-ok-"+ok, fn);
		this.clickHandler("i-btn-ok-"+ok, fn);
	},
	
	alert: function(title, msg, fn) {
		var ok = ++Web.MessageManager.SEQ;
		this.generate({
			title: title,
			msg: msg,
			buttons: this.OK,
			icon: this.WARNING,
			okkey:ok
		});		
		this.show();
		this.defaultClick("i-btn-ok-"+ok, fn);
		this.clickHandler("i-btn-ok-"+ok, fn);
	},
	
	confirm: function(title, msg, fn1, fn2) {
		var ok = ++Web.MessageManager.SEQ;
		var cancel = ++Web.MessageManager.SEQ;
		this.generate({
			title: title,
			msg: msg,
			buttons: this.OKCANCEL,
			icon: this.QUESTION,
			okkey:ok,
			cancelkey:cancel
		});		
		this.show();		
		this.defaultClick("i-btn-ok-"+ok, fn1);
		this.clickHandler("i-btn-ok-"+ok, fn1);
		this.clickHandler("i-btn-cancel-"+cancel, fn2);
	},
	
	yesno: function(title, msg, fn1, fn2) {
		var yes = ++Web.MessageManager.SEQ;
		var no = ++Web.MessageManager.SEQ;
		this.generate({
			title: title,
			msg: msg,
			buttons: this.YESNO,
			icon: this.QUESTION,
			yeskey:yes,
			nokey:no
		});		
		this.show();
		this.defaultClick("i-btn-yes-"+yes, fn1);
		this.clickHandler("i-btn-yes-"+yes, fn1);
		this.clickHandler("i-btn-no-"+no, fn2);
	},
	
	yesnocancel: function(title, msg, fn1, fn2, fn3) {
		var yes = ++Web.MessageManager.SEQ;
		var no = ++Web.MessageManager.SEQ;
		var cancel = ++Web.MessageManager.SEQ;
		
		this.generate({
			title: title,
			msg: msg,
			buttons: this.YESNOCANCEL,
			icon: this.QUESTION,
			yeskey:yes,
			nokey:no,
			cancelkye:cancel
		});		
		this.show();
		this.defaultClick("i-btn-yes-"+yes, fn1);
		this.clickHandler("i-btn-yes-"+yes, fn1);
		this.clickHandler("i-btn-no-"+no, fn2);
		this.clickHandler("i-btn-cancel-"+cancel, fn3);
	},
	
	clickHandler: function(id, fn) {
		if (fn) {
			if ($$(id).onclick) {
				$$(id).onclick = null;
			}
			$$(id).onclick = fn;
		}
	},
	
	generate: function(args) {
		buttons = '<table cellspacing=0 cellpadding=0 border=0 onclick=\'Web.CanvasManager.get("'+this.el.id+'").hide()\'><tr>';
		if (args.buttons.ok) {
			buttons += '<td class=w-btn-c>'+Web.util.Button.button['ok'].gsub(/\?/, args.okkey)+'</td>';
		}
		if (args.buttons.yes) {
			buttons += '<td class=w-btn-c>'+Web.util.Button.button['yes'].gsub(/\?/, args.yeskey)+'</td>';
		}
		if (args.buttons.no) {
			buttons += '<td class=w-btn-c>'+Web.util.Button.button['no'].gsub(/\?/, args.nokey)+'</td>';	
		}
		if (args.buttons.cancel) {
			buttons += '<td class=w-btn-c>'+Web.util.Button.button['cancel'].gsub(/\?/, args.cancelkey)+'</td>';
		}
		buttons += '</tr></table>';
		icons = '';
		if (args.icon.information) {
			icons += Web.util.Image.image['information'];
		}
		if (args.icon.warning) {
			icons += Web.util.Image.image['warning'];
		}
		if (args.icon.question) {
			icons += Web.util.Image.image['question'];
		}
		if (args.icon.error) {
			icons += Web.util.Image.image['error'];
		}

		var div = 	'<table border=0 cellspacing=0 cellpadding=0 onselectstart="return false" class=w-box width='+(args.width? args.width:this.opt.width)+'px height='+(args.height? args.height:this.opt.height)+'px>'+						
					'<tr height=28>'+
						'<th class=w-box-tl style="background: url('+Web.config.imageroot+'oz/box/tl.gif) no-repeat 0 0"></th>'+
						'<th class=w-box-tm style="background: url('+Web.config.imageroot+'oz/box/tm.gif)">'+
							'<table border=0 cellspacing=0 cellpadding=0 width=100%>'+
								'<tr>'+
									'<td class=w-box-tm-txt>'+(args.title||"&#160;")+'</td>'+
									'<td class=w-box-close onclick=\'Web.CanvasManager.get("'+this.el.id+'").hide()\'>'+Web.util.Image.image['topclose']+'</td>'+
								'</tr>'+
							'</table>'+
						'</th>'+
						'<th class=w-box-tr style="background: url('+Web.config.imageroot+'oz/box/tr.gif) no-repeat 0 0"></th>'+
					'</tr>'+
					'<tr>'+
						'<td class=w-box-lm style="background: url('+Web.config.imageroot+'oz/box/lm.gif)"></td>'+
						'<td class=w-box-mm>'+
							'<table border=0 cellspacing=0 cellpadding=0 width=90% align=center>'+
								'<tr>'+
									'<td width=20% align=center>'+icons+'</td>'+
									'<td class=w-box-mm-txt>'+(args.msg||"&#160")+'</td>'+
								'</tr>'+
								'<tr>'+
									'<td colspan=2 align=center>'+buttons+'</td>'+
								'</tr>'+
							'</table>'+
						'</td>'+
						'<td class=w-box-rm style="background: url('+Web.config.imageroot+'oz/box/rm.gif)"></td>'+
					'</tr>'+
					'<tr height=28>'+
						'<td class=w-box-bl style="background: url('+Web.config.imageroot+'oz/box/bl.gif) no-repeat 0 0"></td>'+
						'<td class=w-box-bm style="background: url('+Web.config.imageroot+'oz/box/bm.gif)"></td>'+
						'<td class=w-box-br style="background: url('+Web.config.imageroot+'oz/box/br.gif) no-repeat 0 0"></td>'+
					'</tr>'+						
					'</table>';
		this.update(div);
	}
};

Object.extend(Web.MessageBox.prototype, Web.Canvas.prototype);

Web.PopupLayerManager = {
	SEQ:0,
	popup: function(arg) {
		args = Object.extend({type:'popup'}, arg);
		pop = new Web.PopupLayer(args.id, args);
		pop.popup(args);
	},
	template: function(arg) {
		args = Object.extend({type:'popup'}, arg);
		pop = new Web.PopupLayer(args.id, args);
		pop.template(args);
	}
};

Web.PopupLayer = Class.create();
Web.PopupLayer.prototype = {
	popup: function(args) {
		this.captureKeyEnable = false;
		var ok = ++Web.PopupLayerManager.SEQ;
		
		this.generate({
			title: args.title,
			msg: args.msg,
			buttons: this.OK,
			icon: this.INFO,
			okkey:ok,
			width: args.width,
			height: args.height,
			hide: args.hide
		});	
		this.show();
	},
	
	template: function(args) {
		this.captureKeyEnable = false;
		var ok = ++Web.PopupLayerManager.SEQ;
		
		this.update(args.template);
		this.show();
	},
	
	generate: function(args) {
		local = Object.extend({
			width:500,
			height:500,
			hide:function(){}
			}, args);
		var div = 	'<table border=0 cellspacing=0 cellpadding=0 onselectstart="return false" class=w-box width='+local.width+'px height='+local.height+'px>'+						
					'<tr height=28>'+
						'<th class=w-box-tl style="background: url('+Web.config.imageroot+'oz/box/tl.gif) no-repeat 0 0"></th>'+
						'<th class=w-box-tm style="background: url('+Web.config.imageroot+'oz/box/tm.gif)">'+
							'<table border=0 cellspacing=0 cellpadding=0 width=100%>'+
								'<tr>'+
									'<td class=w-box-tm-txt>'+(args.title||"&#160;")+'</td>'+
									'<td class=w-box-close onclick=\'Web.CanvasManager.get("'+this.el.id+'").hide(local.hide);\'>'+Web.util.Image.image['topclose']+'</td>'+
								'</tr>'+
							'</table>'+
						'</th>'+
						'<th class=w-box-tr style="background: url('+Web.config.imageroot+'oz/box/tr.gif) no-repeat 0 0"></th>'+
					'</tr>'+
					'<tr>'+
						'<td class=w-box-lm style="background: url('+Web.config.imageroot+'oz/box/lm.gif)"></td>'+
						'<td class=w-box-mm>'+
							'<table border=0 cellspacing=0 cellpadding=0 width='+(local.width-70)+'px align=center height=100%>'+
								'<tr>'+
									'<td class=w-box-mm-txt>'+(args.msg||"&#160")+'</td>'+
								'</tr>'+								
							'</table>'+
						'</td>'+
						'<td class=w-box-rm style="background: url('+Web.config.imageroot+'oz/box/rm.gif)"></td>'+
					'</tr>'+
					'<tr height=28>'+
						'<td class=w-box-bl style="background: url('+Web.config.imageroot+'oz/box/bl.gif) no-repeat 0 0"></td>'+
						'<td class=w-box-bm style="background: url('+Web.config.imageroot+'oz/box/bm.gif)"></td>'+
						'<td class=w-box-br style="background: url('+Web.config.imageroot+'oz/box/br.gif) no-repeat 0 0"></td>'+
					'</tr>'+						
					'</table>';

		this.update(div);
	}
};

Object.extend(Web.PopupLayer.prototype, Web.Canvas.prototype);

Web.Form = {
	gone:false,
	ALPHA:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",
	NUM:"0123456789",
	hash:null,
	setStyle: function(nm) {
		for (var i = 0; i < document.forms.length; i++) {
			form = document.forms[i];
			if ((nm && form.name == 'ALL') || (nm && form.name.include(nm))) {
				for (var k = 0; k < form.length; k++) {
					if (form[k].type == 'text' || form[k].type == 'textarea' || form[k].type == 'password' || (form[k].type == 'file' && Web.isIE) || form[k].type == 'select') {
						form[k].className = 'w-input-txt';
						form[k].style.backgroundImage = 'url('+Web.config.imageroot+'oz/form/text-bg.gif)';
						form[k].style.backgroundRepeat = 'repeat-x';
						form[k].style.backgroundPosition = '0 0';
						//form[k].onfocus = function() {this.className='w-input-txt-f';};
						form[k].onmouseover = function() {this.className='w-input-txt-o';};
						form[k].onmouseout =  function() {this.className='w-input-txt';};
					}
				}
			}
		}
	},	
	validateValue: function(id,nm) {
		var el = $$(id);	
		if (!el.present()) {
			Web.alert({title:'입력값 체크', msg:(nm||(el.title? '<b>'+el.title+'</b>에':''))+' 값을 반드시 입력하세요', focus:id});
			return false;
		}
		return true;
	},
	
	validateNum: function(id) {
		return Web.Form.validateInput(this.NUM, id);
	},
	
	validateAlpha: function(id) {
		return Web.Form.validateInput(this.ALPHA, id);
	},
	
	validateAlphaNum: function(id) {
		return Web.Form.validateInput(this.ALPHA+this.NUM, id);
	},
	
	validateInput: function(string, id) {
		var el = $$(id);
		var added = (string == this.ALPHA ? '<b>문자</b>만' : (string == this.ALPHA+this.NUM ? '<b>문자</b>와 <b>숫자</b>만' : (this.NUM ? '<b>숫자</b>만':'')));
		for (var i = 0; i < el.value.length; i++) {
			if (string.indexOf(el.value.substring(i, i + 1)) < 0) {
				Web.alert({title:'입력값 체크', msg:(el.title? '<b>'+el.title+'</b>에':'')+' 잘못된값이 입력되었습니다<br>'+added+' 입력하세요', focus:id});
				return false;
			}
		}
		return true;
	},
	
	validateEmail: function(id) {
		var el = $$(id);
		if (!this.validateValue(id)) {
			return;
		}
		
		var arrMatch = el.value.match(/^(\".*\"|[A-Za-z0-9_-]([A-Za-z0-9_-]|[\+\.])*)@(\[\d{1,3}(\.\d{1,3}){3}]|[A-Za-z0-9][A-Za-z0-9_-]*(\.[A-Za-z0-9][A-Za-z0-9_-]*)+)$/);
		if (arrMatch == null) {
			Web.alert({title:'입력값 체크',msg:'이메일주소가 올바르지 않습니다.<br>다시 확인해주세요!'});
        		return false;
		}
		return true;
	},
	
	validateMinByte: function(id, limitByte) {
		var el = $$(id);
		var limit = limitByte||el.minbyte||el.getAttribute("minbyte")||0;
		if (el.value.getByte() < limit) {
			Web.alert({title:'입력값 체크', msg:(el.title? '<b>'+el.title+'</b>에':'')+' '+limit+'BYTE 이상 입력해야 합니다',focus:id});
			return false;		
		}
		return true;
	},
	
	validateMaxByte: function(id, limitByte) {
		var el = $$(id);
		var limit = limitByte||el.maxbyte||el.getAttribute("maxbyte")||0;
		if (el.value.getByte() > limit) {
			Web.alert({title:'입력값 체크', msg:(el.title? '<b>'+el.title+'</b>에':'')+' '+limit+'BYTE 이하로 입력해야 합니다',focus:id});
			return false;		
		}
		return true;
	},
	
	validateByte: function(id, limitByte) {
		var el = $$(id);
		var limit = limitByte||el.byte||el.getAttribute("byte")||0;
		if (el.value.getByte() != limitByte) {
			Web.alert({title:'입력값 체크', msg:(el.title? '<b>'+el.title+'</b>에':'')+' '+limit+'BYTE 로 정확히 입력해야 합니다',focus:id});
			return false;		
		}
		return true;
	},
	
	validateLength: function(id, limitByte) {
		var el = $$(id);
		var limit = limitByte||el.byte||el.getAttribute("byte")||0;
		if (el.value.length != limit) {
			Web.alert({title:'입력값 체크', msg:(el.title? '<b>'+el.title+'</b>에':'')+' '+limit+'글자를 정확히 입력해야 합니다',focus:id});
			return false;		
		}
		return true;
	},
	
	validateFile: function(id) {
		var sp = $$(id).value.split("\\");
		var fn = sp[sp.length-1];
		var ex = fn.split(".");
		if (ex.length == 1) {
			Web.alert({title:'경고',msg:'확장자가 없는 파일은 업로드 할 수 없습니다'});
			return false;
		}
		var iscorrect = false;
		for (var i = 1; i < arguments.length; i++) {
			if (ex[1].toUpperCase() == arguments[i].toUpperCase()) {
				iscorrect = true;
				break;
			}
		}
		return iscorrect;
	},
	
	validateContent: function(id, bads) {
		if (bads && bads != null && (typeof bads) != 'undefined' && !bads.empty()) {
			var el = $$(id);
			var val = el.value;
			var bad = bads.split(/,/);
			for (var i = 0; i < bad.length; i++) {
				if (bad[i].strip().length > 0 && val.include(bad[i])) {
					Web.alert({title:'경고',msg:(el.title? '<b>'+el.title+'</b>에':'')+' <b>'+bad[i]+'<b>"을/를 사용할 수 없습니다!',focus:id});
					return false;
				}
			}
		}
		return true;
	},
	
	validateRegno: function(id1,id2) {
		var reg1 = $$(id1).value;
		var reg2 = $$(id2).value;
		
		if (!Web.Form.validateValue(id1)) return false;
		if (!Web.Form.validateValue(id2)) return false;
		if (!Web.Form.validateNum(id1)) return false;
		if (!Web.Form.validateNum(id2)) return false;
		if (!Web.Form.validateLength(id1, 6)) return false;
		if (!Web.Form.validateLength(id2, 7)) return false;
		
		var year = reg1.substring(0,2);
		var mon = reg1.substring(2,4);
		var day = reg1.substring(4,6);
		var sex = reg2.charAt(0);	
		if (mon < 1 || mon > 12 || day < 1 || day > 31) {
			Web.alert({title:'오류',msg:'주민등록번호 앞부분이 잘못되었습니다'});
			return false;
		}
		if (sex != 1 && sex != 2 && sex != 3 && sex != 4) {
			Web.alert({title:'오류',msg:'주민등록번호 뒷부분이 잘못되었습니다'});
			return false;
		}		
		
		var check = 0;
		for (var i = 0; i < 6; i++) {
			check += ((i + 2) * parseInt(reg1.charAt(i)));
		}		
		for (var i = 6; i < 12; i++) {
			check += ((i % 8 + 2) * parseInt(reg2.charAt(i - 6)));
		}		
		check = 11 - (check % 11);
		check %= 10;
		
		if (check != parseInt( reg2.charAt(6))) {
			Web.alert({title:'오류',msg:'유효하지않은 주민등록번호입니다'});
			return false;
		}
		return true;
	},
	
	loadForm: function(form) {
		form = $$(form);
		var hash = new Hash;
		for (var i = 0; i < form.elements.length; i++) {
			hash[form.elements[i].name] = form.elements[i].value;
		}
		this.hash = hash;
		return hash;
	},
	
	submit: function(id, args) {
		if (this.gone) {
			Web.alert({title:'경고',msg:'이미 전송되었습니다'});
		}
		else {		
			var obj = $$(id);
			if (obj) {
				obj.method = args.method||'post';
				var resubmit = args.resubmit||'N';
				
				if (args.action) {
					obj.action = args.action;
				}
		
				if (args.target) {
					obj.target = args.target;	
				}
				
				if (args.encoding) {
					obj.encoding = args.encoding;
				}
				
				if (resubmit.toUpperCase() == 'N') {
					this.gone = true;
				}
				obj.submit();
			}
		}
	}
};

Web.Window = {
	messagewin: null,
	loadingwin: null,
	popup: function(u,args) {
		var target = args.target||'_blank';
		window.open(u, target, 'width='+args.width+', height='+args.height+', left='+this.getLeft(args.width)+', top='+this.getTop(args.height));	
	},
	message: function(t,args) {
		t = t.gsub(/'/,'').gsub(/"/,'');
		var w = args.width||300;
		var h = args.height||170;
		var property = "menu=no,location=no,resiable=yes,toolbar=no,status=no,scrollbars=no,left="+this.getLeft(w)+",top="+this.getTop(h)+",width="+w+",height="+h;
		if (this.messagewin != null) {
			this.messagewin.close();
		}

		this.messagewin = window.open("about:blank", "_message", property);
		if (this.messagewin != null) {
			var txt = ""+
				"<title>정보</title>"+
				"<body leftmargin=0 topmargin=0 marginwidth=0 marginheight=0 onBlur=self.focus() bgcolor=#F5F5F5>"+
				"<table border=0 cellspacing=0 cellpadding=0 width=100% height=100% style=font-size:13px>"+
				"<tr><td width=1% height=30><img src=./img/oz/window/title_icon.gif width=23 height=30></td><td background='./img/oz/window/title_bg.gif' width=99%><b>정보</b></td></tr>"+
				"<tr><td colspan=2 align=center style=font-size:10pt><img src=./img/oz/window/i_info.gif style=vertical-align:middle><b> "+t+"</b></td></tr>"+
				"<tr><td colspan=2 align=center><img src=./img/oz/window/btn_close.gif style=cursor:pointer onclick=window.close()></td></tr></table>"+
				"</body>";

			this.messagewin.document.open();
			this.messagewin.document.write(txt);
			this.messagewin.document.close();
			this.messagewin.focus();
		} 
		else {
			t = t.gsub('<br>', '\n');
			alert(t.strip());	
		}
	},
	loading: function(bul,args) {
		if (bul) {
			var w = args.width||300;
			var h = args.height||170;
			var property = "menu=no,location=no,resiable=yes,toolbar=no,status=no,scrollbars=no,left="+this.getLeft(w)+",top="+this.getTop(h)+",width="+w+",height="+h;
			if (this.loadingwin != null) {
				this.loadingwin.close();
			}
			this.loadingwin = window.open("about:blank", "_loading", property);
			if (this.loadingwin != null) {
				var txt = ""+
					"<title>정보</title>"+
					"<body leftmargin=0 topmargin=0 marginwidth=0 marginheight=0 onBlur=self.focus() bgcolor=#F5F5F5>"+
					"<table border=0 cellspacing=0 cellpadding=0 width=100% height=100%>"+
					"<tr><td width=1% height=30><img src=./img/oz/window/title_icon.gif width=23 height=30></td><td background='./img/oz/window/title_bg.gif' width=99%><b>로딩중</b></td></tr>"+
					"<tr><td colspan=2 align=center style=font-size:10pt><img src=./img/oz/window/i_large_loading2.gif></td></tr></table>"+
					"</body>";

				this.loadingwin.document.open();
				this.loadingwin.document.write(txt);
				this.loadingwin.document.close();
				this.loadingwin.focus();
			}
		} 
		else {
			if (this.loadingwin != null) {
				this.loadingwin.close();
			}			
		}
	},
	getLeft: function(w) {
		return screen.width / 2 - w / 2;
	},
	getTop: function(h) {
		return screen.height / 2 - h / 2;
	}
	
	
}
Web.Location = {
	link: function(addr) {
		var val = Web.Math.random();
		if (addr.indexOf('&') > -1 || addr.indexOf('?') > -1) {
			if (addr.indexOf('&val=') == -1)
				addr = addr + '&val=' + val;
		} else {
			addr = addr + '?val='+ val;
		}
		window.open(addr, '_self');
	},
	domain: function() {
		var d = location.href;
		if (d.include("http://")) {
			d = d.gsub(/http:\/\//, '');
		}
		if (d.include("/")) {
			d = d.substring(0, d.indexOf("/"));	
		}
		return d;
	},
	current: function() {
		var l = location.href;
		l = l.substring(l.lastIndexOf('/')+1, l.length);
		if (l.lastIndexOf('?') > -1)
			l = l.substring(0, l.lastIndexOf('?'));
			
		return l.toLowerCase();
	},
	parameter: function() {
		var l = location.href;
		var c = this.current();
		if (l.indexOf('?') > -1) {
			l = l.substring(l.lastIndexOf(c)+c.length, l.length);
		}
		else {
			l = '';
		}
		return l;
	},
	back: function() {
		window.history.back();	
	}
};

Web.Math = {
	random: function(val) {
		if (!val) {
			val = 100000000;
		}
		return Math.floor(Math.random() * val);
	},
	format: function(val) {		
		var src;
		var f,s;		
		val = val.toString();		
		f = val.length % 3;
		s = (val.length - f) /3;
		src = val.substring(0,f);
	
		for (var i = 0; i < s; i++) {
			if ((f == 0) && (i == 0)) {
				src += val.substring(f+(3*i), f+3+(3*i));
			} 
			else {
				if (val.substring(f+(3*i) - 1, f+(3*i)) != "-" ) {
					src +=",";
				}
				src += val.substring(f+(3*i), f+3+(3*i));
			}
		}
		return src;
	}
}

Web.Event = {
	target: null,
	captureEnter: function(e, handler) {
		var e = Web.isIE? event:e;
		if (e.keyCode == 13) {			
			eval(handler);			
		}
	},
	nextEnter: function(e, id) {
		var e = Web.isIE? event:e;
		if (e.keyCode == 13) {
			var t = document.getElementsByTagName('input');
			var o = new Array;
			for (var i = 0; i < t.length; i++) {
				if (t[i].type == 'text' ||
					t[i].type == 'password') {
					o.push(t[i]);
				}					
			}
			var el = $$(id);
			for (var i = 0; i < o.length; i++) {
				if (o[i] ==	el && (i+1) < o.length) {
					o[i+1].focus();
					break;
				}
			}
		}
	}
}

Web.Ajax = {
	invoke: function(args) {
		var xmlhttpreq = Web.Ajax.getXMLHttpRequest();
		xmlhttpreq.open("POST", args.action, true);
		xmlhttpreq.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xmlhttpreq.onreadystatechange = function() {
	       	if (xmlhttpreq.readyState == 4) {
	       		if (xmlhttpreq.status == 200) {
	       			var result;
	       			var mode = args.mode||"XML";
	       			if (mode == "XML") {
	       				result = xmlhttpreq.responseXML;
	       			}
	       			else {
	       				result = xmlhttpreq.responseText;
	       			}
					eval(args.handler+'(result);');					
	       		}
	       	}
		}	
		xmlhttpreq.send(args.params);
	},
	
	getXMLHttpRequest: function() {
		var xmlhttpreq;
		if (window.XMLHttpRequest)
			xmlhttpreq = new XMLHttpRequest();
		else {
			try {
				xmlhttpreq = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e1) {
				try {
					xmlhttpreq = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e2) {}
			}
		}	
		return xmlhttpreq;
	}	
}

Web.Tag = {
	setStyle: function(nms, args) {
		var names = $$n(nms);		
		if (args.underline) {
			for (var i = 0; i < names.length; i++) {
				names[i].onmouseover = function() { this.style.textDecoration = 'underline';}
				names[i].onmouseout = function() { this.style.textDecoration = 'none'; }
			}
		}
		if (args.pointer) {
			for (var i = 0; i < names.length; i++) {
				names[i].style.cursor = 'pointer';
			}
		}	
	}
}

Web.Element = {
	toggleDisplay: function(id, bul) {
		var obj = $$(id);
		if (obj.style.display == 'none' || (bul && obj.style.display == '')) {
			obj.style.display = 'inline';	
		}
		else {
			obj.style.display = 'none';
		}
	},
	setClass: function(tag,out,over) {
		var s = document.getElementsByTagName(tag);
		for (var i = 0; i < s.length; i++) {
			if (s[i].className == out) {
				s[i].onmouseover = function() { this.className = over; };
				s[i].onmouseout = function() { this.className = out; };
			}	
		}
	},
	setInputBoxStyle: function(id) {
		var obj = $$(id);
		if (obj) {
			obj.className = 'w-input-txt';
			obj.style.backgroundImage = 'url('+Web.config.imageroot+'oz/form/text-bg.gif)';
			obj.style.backgroundRepeat = 'repeat-x';
			obj.style.backgroundPosition = '0 0';
			obj.onmouseover = function() {this.className='w-input-txt-o';};
			obj.onmouseout =  function() {this.className='w-input-txt';};
		}
	},
	insertAdjacent: function() {
		if(typeof HTMLElement!="undefined" && !HTMLElement.prototype.insertAdjacentElement){
			HTMLElement.prototype.insertAdjacentElement = function(where,parsedNode){
				switch (where){
					case 'beforeBegin':
					this.parentNode.insertBefore(parsedNode,this)
					break;
					case 'afterBegin':
					this.insertBefore(parsedNode,this.firstChild);
					break;
					case 'beforeEnd':
					this.appendChild(parsedNode);
					break;
					case 'afterEnd':
					if (this.nextSibling) this.parentNode.insertBefore(parsedNode,this.nextSibling);
					else this.parentNode.appendChild(parsedNode);
					break;
				}
			}
	    	
			HTMLElement.prototype.insertAdjacentHTML = function(where,htmlStr) {
				var r = this.ownerDocument.createRange();
				r.setStartBefore(this);
				var parsedHTML = r.createContextualFragment(htmlStr);
				this.insertAdjacentElement(where,parsedHTML)
			}
			
			HTMLElement.prototype.insertAdjacentText = function(where,txtStr){
				var parsedText = document.createTextNode(txtStr)
				this.insertAdjacentElement(where,parsedText)
			}
		}
	}
}

Web.Html = {
	appendHtml: function(html, id) {
		var el = $$(id);
		if (el.insertAdjacentHTML) {
			el.insertAdjacentHTML('beforeBegin', html);
		}
		else {
			var oRange = document.createRange() ;
			oRange.setStartBefore(el);
			var oFragment = oRange.createContextualFragment(html);
			el.parentNode.insertBefore(oFragment, el);
		}
	}
}

Web.Format = {
	file: function(v,f) {	
		var unit = "";
		var calsize = "";
	    if ((1024 < v) && (v < 1024 * 1024)) {
			unit = "KB";
	    	calsize = (v/1024).toString();
		} else if (1024 * 1024 <= v) {
			unit = "MB";
			calsize = (v/(1024*1024)).toString();
		} else {
			unit = "Bytes";
	    	calsize = v.toString();
		}
	  
		if (calsize.include(".")) {
			var sosu = calsize.substring(calsize.indexOf("."), calsize.length);	  		
			if (sosu.length > 0) {
				f = f||2;
				calsize = calsize.substring(0,calsize.indexOf("."))+sosu.substring(0,f);
			}
		}		
		return calsize+" "+unit;
	}
}

Web.information = Web.InformationManager.message;
Web.message = Web.MessageManager.message;
Web.alert = Web.MessageManager.alert;
Web.confirm = Web.MessageManager.confirm;
Web.yesno = Web.MessageManager.yesno;
Web.yesnocancel = Web.MessageManager.yesnocancel;
Web.popup = Web.PopupLayerManager.popup;
Web.template = Web.PopupLayerManager.template;
Web.submit = Web.Form.submit;
Web.link = Web.Location.link;

})();

