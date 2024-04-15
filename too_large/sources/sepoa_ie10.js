/**
 * 좌측 메뉴 숨기기/보이기
 */
function hideAndShowMenu(flag){ 
	
/*	if(flag == "hide"){
		//1.좌측메뉴를 숨기고
		var leftHide = document.getElementById("snb");
		leftHide.style.display = "none";
		//2.우측 내용부를 좌측으로 당기고
		var content = document.getElementById("content");
		content.style.marginLeft = "0px";
		content.style.paddingLeft = "50px";
		//3.이미지를 보이게
		$("#leftHideid").css("display","block");
	}else if(flag == "show"){
		var leftHide = document.getElementById("snb");
		leftHide.style.display = "block";
		var content = document.getElementById("content");
		content.style.marginLeft = "254px";
		content.style.paddingLeft = "10px";
		//3.이미지를 감춤(기본값)
		$("#leftHideid").css("display","none");		
	}*/
	
	
	if(document.form_footer.hideMenu.value == "false"){
		//1.좌측메뉴를 숨기고
		var leftHide = document.getElementById("snb");
		leftHide.style.display = "none";
		//2.우측 내용부를 좌측으로 당기고
		var content = document.getElementById("content");
		content.style.marginLeft = "0px";
		//3.이미지를 변경
		var img = document.getElementById("click1");
		img.src = _POASRM_CONTEXT_NAME+"/images/common/btn_leftOn.gif?type=w1";
		//img.src = _POASRM_CONTEXT_NAME+"/images/pr/button/butt_arrow_right.gif?type=w1";
		//4.flag 변경
		document.getElementById("leftHideid").style.display="block";
		document.form_footer.hideMenu.value = "true";
	}else{
		var leftHide = document.getElementById("snb");
		leftHide.style.display = "block";
		var content = document.getElementById("content");
		content.style.marginLeft = "214px";
		//var img = document.getElementById("click1");
		//img.src = _POASRM_CONTEXT_NAME+"/images/common/btn_leftOff.gif?type=w2";
		//img.src = _POASRM_CONTEXT_NAME+"/images/pr/button/butt_arrow_left.gif?type=w2";
		document.getElementById("leftHideid").style.display="none";
		document.form_footer.hideMenu.value = "false";
	}
	if(typeof GridObj != "undefined"){
		GridObj.setSizes();
	}
       
}	
/**
 * 상단메뉴에서 마우스를 올려 놓았을때 img가 바뀐다.
 * */
function topMenuMouseOver(index){
	// index는 1부터 시작
	if(typeof document.form_header == "undefined"){
		return;
	}
	var nowClickedIndex = document.form_header.nowClickedIndex;
	if(typeof nowClickedIndex == "undefined"){//페이지가 모두 로딩되지 않은 상태에서
		return;
	}
	
	// index는 1부터 시작
	if(document.getElementById("topMenuId"+index) == null){
		return;
	}else{
		//$("#topMenuText_"+index).css("color","#FEA843");	//#FEA843:주황색
		var topMenuIdIndexObject    = document.getElementById("topMenuId" + index);
		var topMenuIdIndexObjectSrc = topMenuIdIndexObject.src;
		var underBarIndex           = topMenuIdIndexObjectSrc.indexOf("_");
		
		if(underBarIndex == -1){
			var dotIndex = topMenuIdIndexObjectSrc.lastIndexOf(".");
			var fileName = topMenuIdIndexObjectSrc.substring(0, dotIndex);
			
			topMenuIdIndexObjectSrc = fileName + "_1.gif";
			topMenuIdIndexObject.src = topMenuIdIndexObjectSrc;
		}
	}
}

/**
 * 마우스가 바깥으로 나갔을때 img를 원상복귀 한다.(현재 클릭된 상태가 아닌경우에만)
 * */
function topMenuMouseOut(index){
	// index는 1부터 시작
	if(typeof document.form_header == "undefined"){
		return;
	}
	var nowClickedIndex = document.form_header.nowClickedIndex;
	if(typeof nowClickedIndex == "undefined"){//페이지가 모두 로딩되지 않은 상태에서
		return;
	}
	if(nowClickedIndex == null){
		//페이지가 모두 로딩되지 않은 상태에서
		$("#topMenuText_"+index).css("color","white");
	}else{
		//페이지가 모두 로딩 된 후
		if(nowClickedIndex.value != index){
			//$("#topMenuText_"+index).css("color","white");
			var topMenuIdIndexObject = document.getElementById("topMenuId" + index);
			var topMenuIdIndexObjectSrc = topMenuIdIndexObject.src;
			var dotIndex = topMenuIdIndexObjectSrc.indexOf("_");
			var fileName = topMenuIdIndexObjectSrc.substring(0, dotIndex);
			
			topMenuIdIndexObjectSrc = fileName + ".gif";
			topMenuIdIndexObject.src = topMenuIdIndexObjectSrc;
		}
	}
}
/**
 * 상단메뉴에서 마우스를 올려 놓았을때 img가 바뀐다.
 * *//*
function topMenuMouseOver(imgUrl, index){
	// index는 1부터 시작
	if(document.getElementById("topMenuImg_"+index) == null){
		return;
	}else{
		document.getElementById("topMenuImg_"+index).src = imgUrl;
	}
}

*//**
 * 마우스가 바깥으로 나갔을때 img를 원상복귀 한다.(현재 클릭된 상태가 아닌경우에만)
 * *//*
function topMenuMouseOut(imgUrl, index){
	// index는 1부터 시작
	var nowClickedIndex = document.form_header.nowClickedIndex.value;
	if(nowClickedIndex == null){
		//페이지가 모두 로딩되지 않은 상태에서
		document.getElementById("topMenuImg_"+index).src = imgUrl;
	}else{
		//페이지가 모두 로딩 된 후
		if(nowClickedIndex != index){
			document.getElementById("topMenuImg_"+index).src = imgUrl;
		}
	}
}
*/
/**
 *	상단 메뉴 클릭시 클릭한 부분의 code를 세션에 등록한다.
 */
function topMenuClick(url, menuObjectCode, index, imgUrl, url3){
	/** 
	 * 페이지 이동 로직 정리
	 * 
	 * [1]좌측 tree 메뉴 직접 클릭시
	 * 1.callback함수(leftMenuClick) 호출됨 - 클릭한 메뉴의 id로 마일스톤, href 구함
	 * 2.ajax통신(openPage.jsp페이지) - id,마일스톤을 세션에 등록
	 * 3.ajax통신 성공 - 1번에서 구한 href 로 페이지 이동
	 * 
	 * [2]상단메뉴 직접 클릭시
	 * 1.ajax통신(topMenuApply.jsp페이지)
	 *  - 다음으로 이동할 페이지의 object code를 세션에 등록(페이지 이동후 tree를 그리기 위해)
	 *  - 클릭한 버튼 이미지에 대한 index,imgUrl세션 등록(페이지 이동후 이미지를 누름버튼으로 변경하기 위해)
	 *  - 세션에 등록되어 있는 현재 tree menu id 삭제(초기화)(페이지 이동후 잘못된 곳으로 focus 방지하기 위해)
	 *  - ajax 성공시 다음으로 이동할 페이지 href를 가지고 해당하는 tree menu id를 찾기 위해 페이지 이동하기 전에 임시로 다음에 페이지에 나타날 tree를 만들어서 href로 id를 찾기
	 *  - 찾은 id로 leftMenuClick 함수 강제 호출 - id로 마일스톤 구해서 ajax통신(openPage.jsp페이지)으로 세션등록([1]-1,2번)
	 *  - 임시로 만든 div 삭제하고, 처음부터 가지고 있었던 url로 페이지 이동
	 */
	
	// index는 1부터 시작
	//클릭한 	menuObjectCode를 세션에 등록한다.	

		var vCommonForm = document.createElement("form");
		vCommonForm.setAttribute("name"   , "commonForm"  );
		vCommonForm.setAttribute("method" , "post"             );
//		vCommonForm.setAttribute("target" , title              );
		vCommonForm.setAttribute("action" , "/common/topMenuApply.jsp"	);

        postInputObj = document.createElement("input");
        postInputObj.setAttribute("type"  , "hidden" );
        postInputObj.setAttribute("name"  , "menuObjectCode" );
        postInputObj.setAttribute("value" , menuObjectCode);
        vCommonForm.appendChild(postInputObj);

        postInputObj = document.createElement("input");
        postInputObj.setAttribute("type"  , "hidden" );
        postInputObj.setAttribute("name"  , "index" );
        postInputObj.setAttribute("value" , index);
        vCommonForm.appendChild(postInputObj);

        postInputObj = document.createElement("input");
        postInputObj.setAttribute("type"  , "hidden" );
        postInputObj.setAttribute("name"  , "imgUrl" );
        postInputObj.setAttribute("value" , imgUrl);
        vCommonForm.appendChild(postInputObj);

        postInputObj = document.createElement("input");
        postInputObj.setAttribute("type"  , "hidden" );
        postInputObj.setAttribute("name"  , "url" );
        postInputObj.setAttribute("value" , url);
        vCommonForm.appendChild(postInputObj);

        postInputObj = document.createElement("input");
        postInputObj.setAttribute("type"  , "hidden" );
        postInputObj.setAttribute("name"  , "url3" );
        postInputObj.setAttribute("value" , url3);
        vCommonForm.appendChild(postInputObj);

        postInputObj = document.createElement("input");
        postInputObj.setAttribute("type"  , "hidden" );
        postInputObj.setAttribute("name"  , "beforeUrl" );
        postInputObj.setAttribute("value" , form_footer.nowPageAddress.value);
        vCommonForm.appendChild(postInputObj);

		document.body.appendChild(vCommonForm);
		vCommonForm.submit();
}

function getSepoaMilestone(){
	var result = "default";
	var jqa = new jQueryAjax();
	jqa.action = _POASRM_CONTEXT_NAME+"/common/getMilestone.jsp";
	jqa.dataType = "json";
	jqa.async = false;
	jqa.successF = function(data){
		result =  data.screen_name;
	};
	jqa.submit(false);
	return result;
	
}
/**
 * 좌측 tree의 메뉴를 마우스로 click 했을때의 callback 함수 
 * */
function seekTreeMenuIdFromUrl(tree, url) {
	var itemList = tree.getAllChildless();		//subItem이 없는 리스트 목록(즉, <userdata>를 가진 Item 리스트)
	var itemListArray = itemList.split(',');	//콤마(,)로 id를 구분한다.
	for(var i in itemListArray){
		var id = itemListArray[i];
		var url2 = tree.getUserData(id,"href");
		//id에서 추출한 href주소와 url이 일치하는 id를 찾기
		if(url == url2){
			return id;
		}
	}
	return null;
}

/**
 * 좌측 tree의 메뉴를 마우스로 click 했을때의 callback 함수 
 * */
function leftMenuClick(id,topId,param){
	//id : 사용자가 마우스로 클릭한 tree 메뉴 id
	//topId : 사용자가 마우스로 클릭한 tree의 최상위 메뉴 id(매개변수 개수를 맞추기위해 표시만 해둠.)
	//param : 본 함수를 임의로 컨트롤하기 위한 변수
	var tree = null;
	var state = 0;
	if(typeof param == "undefined"){
		//사용자가 좌측 tree를 클릭했을때는 항상 undefined 이다.
		state = 1;
		tree = this;
	}else{
		//상단메뉴를 클릭했을때 가상의 tree를 click한 것과 같은 효과를 줄때
		state = 2;
		tree = param;
	}
	var jsp_addr = tree.getUserData(id,"href");
	if(jsp_addr != null && jsp_addr != "" && jsp_addr != "NULL"){
		jsp_addr = _POASRM_CONTEXT_NAME + jsp_addr;
		
		//해당 id를 세션에 저장한다.
		//세션 attribute : treeMenuId
		var sepoa_screen_name = tree.getItemText(id);
		//sepoa_screen_name 안에 img tag가 들어있으면 삭제한다.
		if(sepoa_screen_name.indexOf(">&nbsp;") != -1){
			sepoa_screen_name = sepoa_screen_name.substring(sepoa_screen_name.indexOf(">&nbsp;")+7);
		}
		var pId = id;
		var sepoa_screen_path = sepoa_screen_name;
		do {
			pId = tree.getParentId(pId);
		    var text = tree.getItemText(pId);
		    if(text == "") {
		        break;
		    } else {
		        sepoa_screen_path = text + " > " + sepoa_screen_path;
		    }
		} while (true);
		
		var vCommonForm = document.createElement("form");
		vCommonForm.setAttribute("name"   , "commonForm"  );
		vCommonForm.setAttribute("method" , "post"             );
//		vCommonForm.setAttribute("target" , title              );
		vCommonForm.setAttribute("action" , "/common/openPage.jsp"	);

        postInputObj = document.createElement("input");
        postInputObj.setAttribute("type"  , "hidden" );
        postInputObj.setAttribute("name"  , "id" );
        postInputObj.setAttribute("value" , id);
        vCommonForm.appendChild(postInputObj);

        postInputObj = document.createElement("input");
        postInputObj.setAttribute("type"  , "hidden" );
        postInputObj.setAttribute("name"  , "sepoa_screen_path" );
        postInputObj.setAttribute("value" , sepoa_screen_path);
        vCommonForm.appendChild(postInputObj);

        postInputObj = document.createElement("input");
        postInputObj.setAttribute("type"  , "hidden" );
        postInputObj.setAttribute("name"  , "sepoa_screen_name" );
        postInputObj.setAttribute("value" , sepoa_screen_name);
        vCommonForm.appendChild(postInputObj);
        
		if(state == 1){
            postInputObj = document.createElement("input");
            postInputObj.setAttribute("type"  , "hidden" );
            postInputObj.setAttribute("name"  , "menuObjectCode" );
            postInputObj.setAttribute("value" , document.form_footer.menuObjectCode.value);
            vCommonForm.appendChild(postInputObj);

            postInputObj = document.createElement("input");
            postInputObj.setAttribute("type"  , "hidden" );
            postInputObj.setAttribute("name"  , "jsp_addr" );
            postInputObj.setAttribute("value" , jsp_addr);
            vCommonForm.appendChild(postInputObj);
		}
		document.body.appendChild(vCommonForm);
		vCommonForm.submit();
		
	}else{
		//alert("There is no link.");
	}
}

/**
 * dataOutput 과 차이는 &, = 의 사용이다. 그리고 id가 없는 경우(name만 있는 경우에도 가져올 수 있도록 한다.)
 */
function dataOutputForjQueryAjax(encoding, formName){ 
	var table_data = "";
    var obj1 = document.getElementsByTagName("input");
    var obj2 = document.getElementsByTagName("select");
    var obj3 = document.getElementsByTagName("textarea");
    
    if(formName == ""){
    	//전체 form의 내용을 모두 가져옴.
    	for (var i = 0; i < obj1.length; i++) {
    		if(obj1[i].name != "") {
    			if(obj1[i].type == "checkbox"){
    				table_data = table_data + "&" + obj1[i].name + "=" + obj1[i].checked;
    			}else if(obj1[i].type == "radio"){
    				if(obj1[i].checked == true){
    					table_data = table_data + "&" + obj1[i].name + "=" + obj1[i].value;
    				}
    			}else{
    				table_data = table_data + "&" + obj1[i].name + "=" + obj1[i].value;
    			}
    		}
    	}
    	for (var i = 0; i < obj2.length; i++) {
    		if(obj2[i].name != "") {
    			table_data = table_data + "&" + obj2[i].name + "=" + obj2[i].value;
    		}
    	}
    	for (var i = 0; i < obj3.length; i++) {
    		if(obj3[i].name != "") {    
    			if(obj3[i].value != null || obj3[i].value != ""){
    				table_data = table_data + "&" + obj3[i].name + "=" + obj3[i].value.replace(/\r\n/g,"\n");
    			}
    		}
    	}    	
    }else{
    	//해당 form의 내용을 모두 가져옴.
    	for (var i = 0; i < obj1.length; i++) {
    		if(obj1[i].form == null){	continue;	}	//form에 속하지 않은 element(input,select,,,)가 존재할 수 있다.
    		if(obj1[i].name != "" && obj1[i].form.name == formName) {
    			if(obj1[i].type == "checkbox"){
    				table_data = table_data + "&" + obj1[i].name + "=" + obj1[i].checked;
    			}else if(obj1[i].type == "radio"){
    				if(obj1[i].checked == true){
    					table_data = table_data + "&" + obj1[i].name + "=" + obj1[i].value;
    				}
    			}else{
    				table_data = table_data + "&" + obj1[i].name + "=" + obj1[i].value;
    			}
    		}
    	}
    	for (var i = 0; i < obj2.length; i++) {
    		if(obj2[i].form == null){	continue;	}	//form에 속하지 않은 element(input,select,,,)가 존재할 수 있다.
    		if(obj2[i].name != "" && obj2[i].form.name == formName) {
    			table_data = table_data + "&" + obj2[i].name + "=" + obj2[i].value;
    		}
    	}
    	for (var i = 0; i < obj3.length; i++) {
    		if(obj3[i].form == null){	continue;	}	//form에 속하지 않은 element(input,select,,,)가 존재할 수 있다.
    		if(obj3[i].name != "" && obj3[i].form.name == formName) {    
    			if(obj3[i].value != null || obj3[i].value != ""){
    				table_data = table_data + "&" + obj3[i].name + "=" + obj3[i].value.replace(/\r\n/g,"\n");
    			}
    		}
    	}
    }
    
    if( encoding == undefined || encoding == null ) {
        encoding = true;
    }
    if( encoding ) {
        table_data = encodeUrl(LRTrim(table_data));
    } 
    return table_data;
}

/**
 * @desc	jQuery를 이용해서 jsp로 이동하기 위한 방법
 * @param	formName : 전송할 form의 이름(name)
 * method : post/get방식
 * action : 이동하고자 하는 jsp 주소
 * dataType : json,html,xml 등등
 * data : form이외에 추가로 넘길 파라메터
 * async : true(비동기)/false(동기)방식
 * successF : ajax통신이 성공했을때 call back 함수
 * errorF : ajax통신이 실패했을때 call back 함수
 * @return
 */
function jQueryAjax(formName){
	//아래의 this.* 는 기본값입니다. 다른 값을 원하면 객체 생성후, 필요한 property를 오버라이딩 하세요.
	
	//form name이 null이라면,전체 form을 가져가도록 설정
	if(!formName){
		formName = "";
	}
	this.formName = formName;	//조회할 form의 이름
	
	
	this.method = "POST";	//POST, Get 가능. (기본값:POST)
	this.action = "";		//이동하고자 하는 jsp상대주소(필수값)
	this.dataType = "html";	//json, html, xml 이 가능하다.(기본값:html)	- json으로 해서 return값을 얻고 싶은 경우, open되는 jsp파일에서 {"message":"ok"} 와 같은 형태의 json방식으로 표현을 해주어야 한다.
	this.data = "";
	this.async = true;		//true:비동기방식, false:동기방식
	this.successF = function(result,a,b,c){	//ajax 성공시 호출(동기) - 필요시 지정(오버라이딩)
		//alert("결과값="+result+",a="+a+",b="+b+",c="+c);
	
		if(this.dataType == "html"){
			//동적 div 만들기
			var index = (new Date()).getTime();
			var divT = document.createElement('div');
			divT.id='temporaryDiv'+index;
			divT.style.display = "none";
			document.body.appendChild(divT);
			
			$("#temporaryDiv"+index).html(result);
			
			document.body.removeChild(divT);
		}
		
	};
	this.errorF = function(x,y,z){
		//alert("처리중 오류가 발생하였습니다.\n"+x+","+y+","+z);
		alert("System error.\nRefresh a browser, plz.(F5 key)\nerror number:1");
	};
}
/**
 * @desc frame이나 iframe을 이용하여 form의 내용을 가지고, 임의 주소로 jsp를 실행시킬때
 * @param 
 * 기본값(true) : 모든 form의 내용을 전송(중복 오류 가능성 있음)
 * false : form의 값은 전송하지 않음.(this.data의 값은 전송)
 * @return
 * */
jQueryAjax.prototype.submit = function(isFormData){
	if(isFormData == null){
		isFormData = true;
	}
	var params = "";
	if(isFormData){
		//null이거나 true일때
		params = dataOutputForjQueryAjax(false,this.formName);	//화면상의 input,select,textarea,text값을 가져온다.(name이 지정되어 있는 한에서) //false: 인코딩하지 않음
	}
	// isFormData가 false일때는 form 데이터를 전송하지 않는다.
	if(this.action == ""){
		//alert("이동하고자 하는 jsp상대 주소를 입력해주세요.\n\n 예:\n var jqa = new jQueryAjax(); \n jqa.action = '../common/openPage.jsp'; \n jqa.submit(); ");
		alert("no address\nerror number:4");
		return;
	}
	$.ajax({
		type:this.method,
		url:this.action,
		dataType:this.dataType,
		data:this.data+params,
		async:this.async,
		success:this.successF,
		error:this.errorF
	});
};

