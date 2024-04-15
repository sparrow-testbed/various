<%@ page contentType="text/html; charset=UTF-8"%>
<script>
/**
 * IE하위버전(7,8)에서 Object.create 함수가 존재하지 않기에
 * 크롬브라우저에서 제공하는 Object.create 함수를 이용해서 사용한다.
 * dhtmlx grid,calendar를 상속받는 과정에서 Object.create함수를 사용한다.
 * dhtmlx 의 객체 생성자들은 new 하는 과정에서 html tag를 생성하기 때문에 상속하는 과정에서 new 명령어를 사용할 수 없다.
 * 그러기에 이러한 방법을 이용하였다.
 * */
if (!Object.create) {
    Object.create = (function(){
        function F(){}

        return function(o){
            if (arguments.length != 1) {
                throw new Error('Object.create implementation only accepts one parameter.');
            }
            F.prototype = o;
            return new F()
        }
    })()
}

/**
 * 1.grid
 */
//dhtmlxgrid.js의 dhtmlXGridObject 생성자를 상속합니다.
//상속후, 변경하고자 하는 함수나 변수를 오버라이딩 합니다.
//즉, dhtmlxgrid.js원본을 유지한채, 본 sepoa_dhtmlxgrid.js를 변경하는 방식으로 파일을 관리합니다.
//as of 131031 ysh

function SepoaDhtmlXGridObject(id, screen_id){
    var base = dhtmlXGridObject.call(this, id);
    
    /**
     * 테스트용 코드. 
     * 향후 JSP가 아닌 아래와 같은 방식으로 JS에서 DB로부터 데이터를 가져와서 
     * 처리하는 방식으로 수정하였으면 한다.
     * 이로써 각 그리드가 오브젝트화되어 멀티그리드도 개념적으로 쉽게 접근이 
     * 가능할 것으로 기대된다.
     */
//    if(screen_id != null) {
//        var nickName = "CO_013";
//        var conType = "CONNECTION";
//        var methodName = "getGridData";
//        var params = "&screen_id=" + screen_id;
//        var SepoaOut = doServiceAjax( nickName, conType, methodName, params );
//    }
    
    //오버라이딩 - 그리드의 스크롤을 움직일 때 - 콤보박스,textarea가 사라지지 않고 공중에 떠 있는 현상 개선(dhtmlx 자체 버그)
    this.objBox.onscroll = function () {
        this.grid._doOnScroll();    //dhtmlxgrid.js 3.6버전 - 기존에 존재하는 명령어
        this.grid.editStop();       //추가 - 스크롤을 움직이면, 에디트 상태를 해제한다.
    };
    
    this.setSelectScreen = function (b) {
        if(b) {
            this.detachEvent("onEditCell");
        }
    };

    this.postGrid = function(url, params) {
        if(params.indexOf("grid_col_id") == -1) {
            var grid_col_id = "";
            var colNum = this.getColumnsNum();
            for(var i = 0;; i++) {
                grid_col_id += this.getColumnId(i);
                if(i < colNum) {
                    grid_col_id += ",";
                } else {
                    break;
                }
            }
            params += "&grid_col_id=" + grid_col_id;
        }
        
        this.post(url, params);
    };
    
    //서블릿 갔다오면 행삭제 안되는 버그(?)로 인한 펑션 생성 
    this.deleteRow2 = function(row_id, node){
		if (!node)
			node=this.getRowById(row_id)
	
		if (!node)
			return;
		
		//this.editStop();
		//if (!this._realfake)
		//	if (this.callEvent("onBeforeRowDeleted", [row_id]) == false)
		//		return false;
		
		var pid=0;
		if (this.cellType._dhx_find("tree") != -1 && !this._realfake){
			pid=this._h2.get[row_id].parent.id;
			this._removeTrGrRow(node);
		}
		else {
			if (node.parentNode)
				node.parentNode.removeChild(node);
	
			var ind = this.rowsCol._dhx_find(node);
	
			if (ind != -1)
				this.rowsCol._dhx_removeAt(ind);
	
			for (var i = 0; i < this.rowsBuffer.length; i++)
				if (this.rowsBuffer[i]&&this.rowsBuffer[i].idd == row_id){
					this.rowsBuffer._dhx_removeAt(i);
					ind=i;
					break;
				}
		}
		this.rowsAr[row_id]=null;
	
		for (var i = 0; i < this.selectedRows.length; i++)
			if (this.selectedRows[i].idd == row_id)
				this.selectedRows._dhx_removeAt(i);
	
		if (this._srnd){
			for (var i = 0; i < this._fillers.length; i++){
				var f = this._fillers[i]
	            if (!f) continue; //can be null	
	            
	            this._update_fillers(i, (f[1] >= ind ? -1 : 0), (f[0] >= ind ? -1 : 0));
			};
	
			this._update_srnd_view();
		}
	
		if (this.pagingOn)
			this.changePage();
		if (!this._realfake)  this.callEvent("onAfterRowDeleted", [row_id,pid]);
		this.callEvent("onGridReconstructed", []);
		if (this._ahgr) this.setSizes();
		return true;
	};
}
SepoaDhtmlXGridObject.prototype = Object.create(dhtmlXGridObject.prototype);
SepoaDhtmlXGridObject.prototype.constructor = SepoaDhtmlXGridObject;

/**
 * 2.calendar 
 */
function SepoaDhtmlXCalendarObject(inps, skin){
	var base = dhtmlXCalendarObject.call(this, inps, skin);
	
	/**
	 * dhtmlx calendar에서는 2013/04/12 또는 2013-04-12와 같이 날짜를 표시할 때 구분자가 필요하다.
	 * 그런데 20130412 와 같이 8자리 숫자로만 구성된 날짜에 대해 인식하지 못하는 dhtmlx 자체오류가 있기에
	 * 8자리 숫자로만 이루어진 경우 특별한 케이스를 두기로 하였다.
	 * 3.6버전의 _strToDate 함수를 오버라이드 하였다.
	 */
	this._strToDate = function(val, format) {
		format = (format||this._dateFormat);

		var f = format.match(/%[a-zA-Z]/g);
		
		if(format == '%Y%m%d') {
			v = new Array();
			v.push(val.substring(0, 4));
			v.push(val.substring(4, 6));
			v.push(val.substring(6, 8));
		} else {
			v = val.match(/[a-z0-9éûä\u0430-\u044F\u0451]{1,}/gi);
		}
		
		if (!v || v.length != f.length) return "Invalid Date";
		// sorting
		/*
		Year	y,Y	1
		Month	n,m,M,F	2
		Day	d,j	3
		AM/PM	a,A	4
		Hours	H,G,h,g	5
		Minutes	i	6
		Seconds	s	7
		*/
		var p = {"%y":1,"%Y":1,"%n":2,"%m":2,"%M":2,"%F":2,"%d":3,"%j":3,"%a":4,"%A":4,"%H":5,"%G":5,"%h":5,"%g":5,"%i":6,"%s":7};
		var v2 = {};
		var f2 = {};
		for (var q=0; q<f.length; q++) {
			if (typeof(p[f[q]]) != "undefined") {
				var ind = p[f[q]];
				if (!v2[ind]){v2[ind]=[];f2[ind]=[];}
				v2[ind].push(v[q]);
				f2[ind].push(f[q]);
			}
		}
		v = [];
		f = [];
		for (var q=1; q<=7; q++) {
			if (v2[q] != null) {
				for (var w=0; w<v2[q].length; w++) {
					v.push(v2[q][w]);
					f.push(f2[q][w]);
				}
			}
		}
		// parsing date
		var r = new Date();
		r.setDate(1); // fix for 31th
		r.setMinutes(0);
		r.setSeconds(0);
		for (var q=0; q<v.length; q++) {
			switch (f[q]) {
				case "%d":
				case "%j":
				case "%n":
				case "%m":
				case "%Y":
				case "%H":
				case "%G":
				case "%i":
				case "%s":
					if (!isNaN(v[q])) r[{"%d":"setDate","%j":"setDate","%n":"setMonth","%m":"setMonth","%Y":"setFullYear","%H":"setHours","%G":"setHours","%i":"setMinutes","%s":"setSeconds"}[f[q]]](Number(v[q])+(f[q]=="%m"||f[q]=="%n"?-1:0));
					break;
				case "%M":
				case "%F":
					var k = this._getInd(v[q].toLowerCase(),that.langData[that.lang][{"%M":"monthesSNames","%F":"monthesFNames"}[f[q]]]);
					if (k >= 0) r.setMonth(k);
					break;
				case "%y":
					if (!isNaN(v[q])) {
						var v0 = Number(v[q]);
						r.setFullYear(v0+(v0>50?1900:2000));
					}
					break;
				case "%g":
				case "%h":
					if (!isNaN(v[q])) {
						var v0 = Number(v[q]);
						if (v0 <= 12 && v0 >= 0) {
							// 12:00 AM -> midnight
							// 12:00 PM -> noon
							r.setHours(v0+(this._getInd("pm",v)>=0?(v0==12?0:12):(v0==12?-12:0)));
						}
					}
					break;
			}
		}
		return r;
	}
}

SepoaDhtmlXCalendarObject.prototype = Object.create(dhtmlXCalendarObject.prototype);
SepoaDhtmlXCalendarObject.prototype.constructor = SepoaDhtmlXCalendarObject;

/**
 * 3.tabbar
 */
JavascriptMap = function(){
	 this.map = new Object();
	};   
	JavascriptMap.prototype = {   
	    put : function(key, value){   
	        this.map[key] = value;
	    },   
	    get : function(key){   
	        return this.map[key];
	    },
	    containsKey : function(key){    
	     return key in this.map;
	    },
	    containsValue : function(value){    
	     for(var prop in this.map){
	      if(this.map[prop] == value) return true;
	     }
	     return false;
	    },
	    containsValueForReturnKey : function(value){    
	     for(var prop in this.map){
	      if(this.map[prop] == value) return prop;
	     }
	     return false;
	    },
	    isEmpty : function(key){    
	     return (this.size() == 0);
	    },
	    clear : function(){   
	     for(var prop in this.map){
	      delete this.map[prop];
	     }
	    },
	    remove : function(key){    
	     delete this.map[key];
	    },
	    keys : function(){   
	        var keys = new Array();   
	        for(var prop in this.map){   
	            keys.push(prop);
	        }   
	        return keys;
	    },
	    values : function(){   
	     var values = new Array();   
	        for(var prop in this.map){   
	         values.push(this.map[prop]);
	        }   
	        return values;
	    },
	    size : function(){
	      var count = 0;
	      for (var prop in this.map) {
	        count++;
	      }
	      return count;
	    }
	};
function SepoaDhtmlXTabBar(name, location, maxTabCount){
	if(maxTabCount == null){
		maxTabCount = 7;
	}
    var base = dhtmlXTabBar.call(this, name, location);
	this.tabSeq = 0;	// 간혹 tab을 삭제하는 경향이 있다. 가장 마지막으로 tab이 추가되었을때 번호를 가지고 채번을 이어나간다.
	// 나중에 ArrayList 형식으로 변경한다. 굳이 Map으로 사용할 필요가 없음.
	
	this.tabURLMapTemp = new JavascriptMap();	//탭을 추가할때, 이곳에 저장해 뒀다가, 탭을 선택 또는 focus 됐을때, 이곳의 url을 꺼내서 로딩한다.(id,탭이름+url) - url 중복을 방지
	this.tabURLMap = new JavascriptMap(); 		//탭 안의 페이지가 실제로 로딩되면 map에 추가한다.(id,url)	- 페이지 로딩 확인(리소스 문제 방지)
	
	//오버라이딩
    this.removeTab =  function (a, b) {
    	//소스추가
    	if(this.getAllTabs().length == 1){
    		alert("마지막 탭은 닫을 수 없습니다.");
    		return;
    	}
    	//기본소스
        var c = this._tabs[a];
        if (c) {
            this.cells(a)._dhxContDestruct();
            this._content[a] && this._content[a].parentNode && this._content[a].parentNode.removeChild(this._content[a]);
            this._content[a] = null;
            this._goToAny(c, b);
            var d = c.parentNode;
            c.innerHTML = "";
            d.removeChild(c);
            d.tabCount--;
            d.tabCount == 0 && this._rows.length > 1 ? this._removeRow(d) : this._setTabSizes(d);
            delete this._tabs[a];
            if (this._lastActive ==
                c) this._lastActive = null;
            this._setRowSizes();
            
            //소스추가
            this.tabURLMap.remove(a);	//a : id	(Map에서도 삭제하기)
            this.tabURLMapTemp.remove(a);	//a : id	(Map에서도 삭제하기)
        }
    },
    //추가(탭을 선택했는데, 페이지가 로딩되어 있지 않다면, 로딩시켜준다.)
    this.pageLoading = function(tabId){
    	if(this.tabURLMapTemp.get(tabId) != null){
    		if(this.tabURLMap.get(tabId) == null){
    			var url = this.tabURLMapTemp.get(arguments[0]).split("____");	//배열로 받음.
    			url = url[url.length-1];
    			this.tabURLMap.put(arguments[0], url);
    			this.setContentHref(arguments[0], url);
    			this.setTabActive(arguments[0]);
    		}    	
    	}else{
			//사용자가 tab을 삭제하고나서, 호출할 수도 있기 때문에
    		alert("탭이 존재하지 않습니다.\ntabId : "+tabId);
    	}
    },
    //오버라이딩
    this.setTabActive = function (a, b) {
        this._setTabActive(this._tabs[a], b === !1);
        
        //추가(탭을 선택했는데, 페이지가 로딩되어 있지 않다면, 로딩시켜준다.)
        this.pageLoading(arguments[0]);
    },
    
    /**
     * 탭추가는 기본 2단계로 나눠진다(해당 탭메뉴UI를 만들고, 실제 url을 로딩하는 것이다.)
     * addTab(tabId, tabName) : tab UI 1개 생성
     * setContentHref(tabId, url) : 생성된 tab UI 에 url 로딩
     *   
     * 원래는 개발자가 tabId를 지정해서 넣어줘야 하지만, tabId를 관리할때 tabId별로 정렬할 필요가 있기 때문에 자동으로 id를 생성하는 방법을 사용한다.
     * 그러기 위해서는 개발자는 addTab(), setContentHref() 를 사용하지 말고, addTabWithUrl() 함수 안에서 id를 자동 생성하고, 두 함수를 모두 사용하는 방법으로 하였다.  
     */
	this.addTabWithUrl = function(screen_name, url, autoLoading){
    	if(autoLoading == null){
    		autoLoading = true;
    	}
		//새로운 url인 경우만 tab에 추가한다.(탭을 삭제했을 때는 Map에서 url주소를 삭제해준다.)
    	var key = this.tabURLMapTemp.containsValueForReturnKey(encodeUrl(screen_name)+"____"+url);		//해당 url을 가지고 있는 id가 있다면,,,
		if(!key){
			var nextId = name + "_" + this.tabSeq;
			this.tabSeq++;
			
			this.addTab(nextId,screen_name);
			
			this.tabURLMapTemp.put(nextId,encodeUrl(screen_name)+"____"+url);
			
			if(autoLoading){
				//탭추가할때, url 중복을 방지하기 위해 임의 Map Object에 저장한다.(url)
				this.tabURLMap.put(nextId,url);
				this.setContentHref(nextId, url);
				this.setTabActive(nextId); 
			}
			
			if(this.getAllTabs().length > maxTabCount){
				//탭의 개수가 max를 넘으면, 가장 오래된 tab을 삭제한다.
				var oldestId = this.getAllTabs()[0];
				this.removeTab(oldestId,true);		//tab 하나를 삭제
			}
		}else{
			var key2 = this.tabURLMap.containsValueForReturnKey(url);	
			if(key2){
				//tab이 존재하면, tab위치에 다시 같은 페이지를 load 해준다.
				this.setContentHref(key, url);
				this.setTabActive(key);
			}else{
				if(autoLoading){
					this.tabURLMap.put(key,url);
					this.setContentHref(key, url);
					this.setTabActive(key);
				}
			}
		}
	};
	/**
	 * 	이벤트 등록
	 */
	this.attachEvent("onSelect", function() {
	    /**
	     	기본 : tab을 선택했을때 focus 이동
			변경 : 1.tab을 선택했을때 tabURLMap에 id랑 url이 존재하면 기본동작, 
				  2.id에 해당하는 url이 map안에 없으면 tabURLMapTemp에서 가져와서 tabURLMap에 넣어주고, url만 넣고 포커스! 
		*/													
        //추가(탭을 선택했는데, 페이지가 로딩되어 있지 않다면, 로딩시켜준다.)
        this.pageLoading(arguments[0]);
		
	    return true;
	});
	this.closeTabOthers = function(){
		var tabArray = this.getAllTabs();
		for(var n in tabArray){
			var id =  tabArray[n];
			if(id == this.getActiveTab()){
				continue;
			}
			this.removeTab(id,true);
		}
	};
	this.runFunctionInTab = function(tabId, functionName){
		if(this.tabURLMapTemp.get(tabId) != null){
			if(this.tabURLMap.get(tabId) == null){
				//사용자가 tab을 삭제하고나서, 함수를 호출할 수도 있기 때문에
				alert("페이지가 로딩되지 않았습니다.\ntabId : "+tabId+"\nfunctionName : "+functionName);
				return;
			}else{
				//함수호출
				var win = this.tabWindow(tabId);
				win[functionName]();				
			}
		}else{
			//사용자가 tab을 삭제하고나서, 호출할 수도 있기 때문에
    		alert("탭이 존재하지 않습니다.\ntabId : "+tabId+"\nfunctionName : "+functionName);
    	}
		
/*		//힘들게 html dom 구조로 tab의 iframe을 추적했는데, 나중에 보니 private API가 존재함.		
 		var obj = $("div[id="+name+"] div[tab_id="+tabId+"] iframe")[0];
		if(typeof obj == "undefined"){
			alert("there is not a tab("+tabId+")");
			return;
		}
		var objWin = obj.contentWindow || obj.contentDocument;
		objWin[functionName]();*/
	};
	
	/**
	 * 기본세팅(화면단에서 해야 하는데, 공통적인 부분이라, 함수 생성자 가장 마지막에 위치시켰다.)
	 * */
	this.setSkin("dhx_skyblue");
	//this.setSkin("glassy_blue");
	//this.setSkin("omega");
	this.setImagePath(_POASRM_CONTEXT_NAME+"/dhtmlx/dhtmlx_full_version/imgs/");
	this.enableAutoReSize();	//enables/disables auto adjusting height and width to outer conteiner
	this.enableAutoSize();		//enables/disables automatic adjusting the height and width to the inner content
	this.setHrefMode("iframes");
	
}
SepoaDhtmlXTabBar.prototype = Object.create(dhtmlXTabBar.prototype);
SepoaDhtmlXTabBar.prototype.constructor = SepoaDhtmlXTabBar;

/**
 * 4.tree
 */
function SepoaDhtmlXTreeObject(htmlObject, width, height, rootId){
	/*
		htmlObject : tree가 사용된 div id
	*/
	if(width == null){ width = "100%";	}
	if(height == null){ height = "100%"; }
	if(rootId == null){	rootId = "0"; }	
	
	var base = dhtmlXTreeObject.call(this, htmlObject, width, height, rootId);

	this.setScreenIdAndFunctionName = function(screen_id, functionName){
		this.screen_id = screen_id;
		this.functionName = functionName;
	};
	this.setLabelColumn = function(name){
		this.labelColumn = name;
	};
	this.setParentAndChildColumn = function(parent, child){
		this.parentColumn = parent;
		this.childColumn = child;
	};
	this.setParam = function(param){
		this.param = param;
	};
	this.setUrl = function(url) {
		this.url = url;
	};

	var flag = false;
	this.enableDynamicOpen = function(flag) {
		this.flag=flag;
	};
		
	//오버라이딩
	this.doQuery = function(url, params) {
		if(!url) {
			url = this.url;
		}
		if(params) {
			url += "?" + params;
		}
		this.loadXML(url);
	};	
	
	this.open = function(id) {
		var f = this.getOpenState(id);
			if(f == 0 && this.flag && this.url) {
				this.call(id);
			}
	};
	
	this.call = function(id) {
        var map = this.getAllUserData(id);
        var keys = map.keys();
        var params = "id=" + id;
        for(var i = 0; i < keys.length; i++) {
            params += "&" + keys[i] + "=" + map.get(keys[i]);
        }
        var url = _POASRM_CONTEXT_NAME+this.url+"?"+params;
        this.loadXML(url);
	}
	
	this.getAllUserData = function(id) {
		var sNode=this._globalIdStorageFind(id,0,true);
		var map = new JavascriptMap();
		if(sNode._userdatalist) {
			var userdatas = sNode._userdatalist.split(",");
			for(var i = 0; i < userdatas.length; i++) {
				map.put(userdatas[i], this.getUserData(id, userdatas[i]));
			}
		}
		return map;
	};

	var clicked = false;
	this.onClick = function(id) {
		if(!clicked) {
			clicked = true;
            window.setTimeout(function(){
                if(clicked) {
                	clicked = false;
                    if(treeClicked) {
                        treeClicked(id);
                    }
                }
            }, 300);
		} else {
			// double clicked.
			clicked = false;
			this.open(id);	
		}
	};
	var win;
	var isChild;
	var mode;
	this.doOnTreeMenuClick = function(menuItemId) {
        switch(menuItemId) {
    	case "AddEquiv":
    		isChild = false;
    		mode = "doSave";
			treeCtxMenu.hide();
			var dhxWins= new dhtmlXWindows();
			var height = 28* paramCnt + 64;
			win = dhxWins.createWindow('create', clickedX, clickedY, 300, height);
			win.setText("Data");
			win.button("minmax1").hide();
			win.button("minmax2").hide();
			win.button("park").hide();
			win.setModal(true);
			win.denyResize();
			win.denyPark();
			win.attachURL(_POASRM_CONTEXT_NAME + "/dhtmlx/createTreeNode.jsp" + inParams);
			break;
    	case "AddBelow":
    		isChild = true;
    		mode = "doSave";
			treeCtxMenu.hide();
			var dhxWins= new dhtmlXWindows();
			var height = 28* paramCnt + 64;
			win = dhxWins.createWindow('create', clickedX, clickedY, 300, height);
			win.setText("Data");
			win.button("minmax1").hide();
			win.button("minmax2").hide();
			win.button("park").hide();
			win.setModal(true);
			win.denyResize();
			win.denyPark();
			win.attachURL(_POASRM_CONTEXT_NAME + "/dhtmlx/createTreeNode.jsp" + inParams);
			break;
    	case "Edit":
    		mode = "doUpdate";
			treeCtxMenu.hide();
			var dhxWins= new dhtmlXWindows();
			var height = 28* paramCnt + 64;
			win = dhxWins.createWindow('create', clickedX, clickedY, 300, height);
			win.setText("Data");
			win.button("minmax1").hide();
			win.button("minmax2").hide();
			win.button("park").hide();
			win.setModal(true);
			win.denyResize();
			win.denyPark();
			win.attachURL(_POASRM_CONTEXT_NAME + "/dhtmlx/createTreeNode.jsp" + inParams);
    		break;
    	case "Delete":
    		mode = "doDelete";
    		that.doTreeSave();
    		break;
        }
	};
	
	this.createMenuContext = function() {
        var treeMenuObj = new dhtmlXMenuObject(null,"dhx_skyblue");
        treeMenuObj.setImagePath(_POASRM_CONTEXT_NAME+"/dhtmlx/dhtmlx_full_version/imgs/");
        treeMenuObj.setIconsPath(_POASRM_CONTEXT_NAME+"/images/");
        treeMenuObj.renderAsContextMenu();
        treeMenuObj.setOpenMode("web");
        treeMenuObj.attachEvent("onClick", this.doOnTreeMenuClick);
        treeMenuObj.loadXML(_POASRM_CONTEXT_NAME+"/dhtmlx/dhtmlx_full_version/dyn_tree_context.xml");
        
        return treeMenuObj;
	};
	var rClickedId;
	var clickedX;
	var clickedY;
	this.onRightClick = function(id, ev) {
		rClickedId = id;
		clickedX = ev.clientX;
		clickedY = ev.clientY;
		//ev.stopPropagation();
		ev.stopImmediatePropagation();
	};
	var treeCtxMenu;
	this.setEditable = function(flag) {
		if(flag) {
            treeCtxMenu = this.createMenuContext();
            this.enableContextMenu(treeCtxMenu);
            this.attachEvent("onRightClick", this.onRightClick);
//            this.enableItemEditor(true);
		}
	};
	
	this.getDepth = function(id) {
		var depth = 0;
		while(id) {
			id = this.getParentId(id);
			depth++;
		}
		return depth - 1;
	}
	
	this.doTreeSave = function(map, url) {
		var newId = new Date().getTime();
		var name;
		if(mode == "doSave") {
			name = map.get("text");
            if(isChild) {
                this.insertNewChild(rClickedId,newId,name,0,0,0,0,"SELECT,CALL");
            } else {
                this.insertNewNext(rClickedId,newId,name,0,0,0,0,"SELECT,CALL");
            }
		} else if(mode == "doUpdate") {
			name = map.get("text");
			newId = rClickedId;
			this.setItemText(newId, name);
		} else if(mode == "doDelete") {
			newId = rClickedId;
		}
		
		if(!url) {
			url = this.url;
		}
		
		var depth = this.getDepth(newId);
		
		var userDataMap = this.getAllUserData(newId);
		var nodeParam = this.mapToParams(userDataMap);
		var p = "mode=" + mode;
		p += "&n_text=" + this.getItemText(newId);
		p += "&n_depth=" + depth;
        var keys = userDataMap.keys();
        for(var i = 0; i < keys.length; i++) {
            p += "&n_" + keys[i] + "=" + userDataMap.get(keys[i]);
        }

		var pId = this.getParentId(newId);
		p += "&p_text=" + this.getItemText(pId);
		depth = this.getDepth(pId);
		p += "&p_depth=" + depth;

		userDataMap = this.getAllUserData(pId);
        keys = userDataMap.keys();
        for(var i = 0; i < keys.length; i++) {
            p += "&p_" + keys[i] + "=" + userDataMap.get(keys[i]);
        }

		if(mode == "doDelete") {
			this.deleteItem(newId);
		}

		var dp = new dataProcessor(url, p);
		this.sendTransactionTreePost(dp, newId);
	
	};

	/**
	 * 미완성. 
	 */
	this.doDeleteTree = function(map, url) {
		var newId = new Date().getTime();
		var name = map.get("text");
		if(isChild) {
			this.insertNewChild(rClickedId,newId,name,0,0,0,0,"SELECT,CALL");
		} else {
			this.insertNewNext(rClickedId,newId,name,0,0,0,0,"SELECT,CALL");
		}
		
		if(!url) {
			url = this.url;
		}
		var p = this.mapToParams(map);
		var dp = new dataProcessor(url+"?mode=doSave");
		
		this.sendTransactionTreePost(dp, newId);
	};

	this.sendTransactionTreePost = function(data_processor, id){
		
        data_processor.init(this);
        data_processor.enableDataNames(true);
        data_processor.setTransactionMode("POST", true);
        data_processor.defineAction("doTreeSaveEnd", doTreeSaveEnd);
		data_processor.stopOnError = true;

        //data_processor.enableDebug(true);
        data_processor.setUpdateMode("off");
        var row = 0;

        data_processor.setUpdated(id, true);

        data_processor.setUpdateMode("row");
        data_processor.sendDataPost();
        data_processor.setUpdateMode("off");

        this.openProgressBar();
    };
	
	this.mapToParams = function(map) {
        var keys = map.keys();
        var params = "";
        for(var i = 0; i < keys.length; i++) {
            params += "&" + keys[i] + "=" + map.get(keys[i]);
        }
        return params.substring(1);
	};

	var inParams = "?";
	var paramCnt = 0;
	this.addProperty = function(id, name) {
		paramCnt++;
		inParams += "&id_" + id + "=" + encodeURIComponent(name);
	};
	
	this.popupClose = function() {
		win.close();	
	};
	
	this.openProgressBar = function() {
	};

	this.closeProgressBar = function() {
	};
	

	/**
	 * 기본세팅(화면단에서 해야 하는데, 공통적인 부분이라, 함수 생성자 가장 마지막에 위치시켰다.)
	 * */
	var that = this;
	this.setSkin('dhx_skyblue');
	this.setImagePath("<%=POASRM_CONTEXT_NAME %>/dhtmlx/dhtmlx_full_version/imgs/csh_bluefolders/");
	this.enableHighlighting(true);
	this.enableTreeImages(true);
	this.preventIECaching(true);

	this.attachEvent("onClick", this.onClick);

	//this.attachEvent("onDblClick", this.onDblClick);
	
}	
SepoaDhtmlXTreeObject.prototype = Object.create(dhtmlXTreeObject.prototype);
SepoaDhtmlXTreeObject.prototype.constructor = SepoaDhtmlXTreeObject;


</script>