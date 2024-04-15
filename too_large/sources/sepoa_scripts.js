function openDoDelyRegist(po_no, po_seq, po_statue) {
    width = 900;
    height = 550
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/procure/dely_register.jsp?po_no=" + po_no + "&po_seq="+ po_seq +"&po_statue="+po_statue+"&popup_flag=true";
	var info = window.open(url, 'PurchaseOrderInfo', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function replace(s, old, replacement)
{
        var i = s.indexOf(old, 0);
        var r = "";
        if(i <= 0)
            return s;
        r = r + s.substring(0, i) + replacement;

        if(i + old.length < s.length)
            r = r + replace(s.substring(i + old.length, s.length), old, replacement);

        return r;
}


//날짜 popup(달력보기)
function Calendar_Open(sfunc)
{
    var width = 247
    var height = 200
    var dim = new Array(2);
    dim = CenterWindow(height,width);
    top = dim[0];
    left = dim[1];
    var left = left;
    var top = top;
    var left = left;
    var top = top;
    var toolbar = 'no'
    var menubar = 'no'
    var status = 'no'
    var scrollbars = 'no'
    var resizable = 'no'
    var url = "/include/kr_Calendar.jsp?function="+sfunc;

    var cal_window = window.open(url,'Calendar','left='+left+',top='+top+',width='+width+',height='+height+',toolbar='+toolbar+',menubar='+menubar+',status='+status+',scrollbars='+scrollbars+',resizable='+resizable)

    return;
}

function PopupCommonNoCond( strCode, strFunctionName, arrValue, arrDesc )
{
	var url = _POASRM_CONTEXT_NAME+"/common/grid_cm_list.jsp";
    PopupCommonArrUrlNoCond(url, strCode, strFunctionName, arrValue, arrDesc );
}

function PopupCommonArrUrlNoCond( url, strCode, strFunctionName, arrValue, arrDesc )
{
	var title = 'Search_Code';
	var	left = 50;
	var top = 100;
	var width = 540;
	var height = 500;
	var bSearchFlag = true;
	var strParams = "";

	for(var i=0;i<arrValue.length;i++)
	{
		strParams = strParams + "&values=" + arrValue[i];
	}

	if(bSearchFlag)
	{
		strParams = strParams;
	}

	if(arrDesc.length>0)
	{
		strParams = strParams + "/";
		for(var i=0;i<arrDesc.length;i++)
		{
			strParams = strParams + "&desc=" + arrDesc[i];
		}
	}

	var setUrl = url + "?code="+strCode+"&function="+strFunctionName+strParams;

    CodeSearchCommon(setUrl,title,left,top,width,height);
}

function PopupCommonArr( strCode, strFunctionName, arrValue, arrDesc )
{
	var url = _POASRM_CONTEXT_NAME+"/common/grid_cm_list.jsp";
    PopupCommonArrUrl(url, strCode, strFunctionName, arrValue, arrDesc );
}

function PopupCommonArrUrl( url, strCode, strFunctionName, arrValue, arrDesc )
{
	var title = 'Search_Code';
	var	left = 50;
	var top = 100;
	var width = 540;
	var height = 500;
	var bSearchFlag = true;
	var strSearchValues = "&values=&values=";
	var strParams = "";

	for(var i=0;i<arrValue.length;i++)
	{
//		strParams = strParams + arrValue[i];
		strParams = strParams + "&values=" + arrValue[i];
	}

	if(strParams.replace(/(^\s*)|(\s*$)/g, "").length < 1)
	{
		strParams = strParams + strSearchValues;
	}

	if(arrDesc.length>0)
	{
		strParams = strParams + "/";
		for(var i=0;i<arrDesc.length;i++)
		{
			strParams = strParams + "&desc=" + encodeURIComponent(arrDesc[i]);
			//alert("strParams"+strParams);
		}
	}

	var setUrl = url + "?code="+strCode+"&function="+strFunctionName+strParams;

    CodeSearchCommon(setUrl,title,left,top,width,height);
}

function PopupCommon0( strCode, strFunctionName, strDesc1, strDesc2)
{
	var arrValue = new Array();
	var arrDesc  = new Array();
	if(strDesc1 != "")
	{
		arrDesc[0] = strDesc1;
		arrDesc[1] = strDesc2;
	}

	PopupCommonArr( strCode, strFunctionName, arrValue, arrDesc );
}

function CodeSearchCommon(url, title, left, top, width, height)
{


	if (title == '') title = 'Code_Search';
	if (left == '') left = 50;
	if (top == '') top = 100;
	if (width == '') width = 540;
	if (height == '') height = 500;

	var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'yes';
	var resizable = 'yes';


//	var code_search = window.open(url, title, "left="+left+", top="+top+",width="+width+",height="+height+", toolbar="+toolbar+", menubar="+menubar+", status="+status+", scrollbars="+scrollbars+", resizable="+resizable);
//    code_search.focus();
	var index = url.indexOf("?");
	var url2 = "";
	var aparam = "";
	if(index == -1){
		url2 = url;
	}else{
		url2 = url.substring(0,index);
		aparam = url.substring(index+1);
	}
    popUpOpen01(url2, title, width, height, aparam);
}

function PopupGeneral(url, title, left, top, width, height)
{
	CodeSearchCommon(url, title, left, top, width, height);
}

function PopupCommon1( strCode, strFunctionName, strValue, strDesc1, strDesc2 )
{
	var arrValue = new Array();
	arrValue[0] = strValue;
	arrValue[1] = "";

	var arrDesc  = new Array();
	if(strDesc1 != "")
	{
		arrDesc[0] = strDesc1;
		arrDesc[1] = strDesc2;
	}

	PopupCommonArr( strCode, strFunctionName, arrValue, arrDesc );
}

function PopupCommon2( strCode, strFunctionName, strValue1, strValue2, strDesc1, strDesc2 )
{
	var arrValue = new Array();
	arrValue[0] = strValue1;
	arrValue[1] = strValue2;

	var arrDesc  = new Array();
	if(strDesc1 != "")
	{
		arrDesc[0] = strDesc1;
		arrDesc[1] = strDesc2;
	}

	PopupCommonArr( strCode, strFunctionName, arrValue, arrDesc );
}

function PopupCommonUrl0( url, strCode, strFunctionName, strDesc1, strDesc2)
{
	var arrValue = new Array();
	var arrDesc  = new Array();
	if(strDesc1 != "")
	{
		arrDesc[0] = strDesc1;
		arrDesc[1] = strDesc2;
	}

	PopupCommonArrUrl( url, strCode, strFunctionName, arrValue, arrDesc );
}

function PopupCommonUrl1( url, strCode, strFunctionName, strValue, strDesc1, strDesc2 )
{
	var arrValue = new Array();
	arrValue[0] = strValue;

	var arrDesc  = new Array();
	if(strDesc1 != "")
	{
		arrDesc[0] = strDesc1;
		arrDesc[1] = strDesc2;
	}

	PopupCommonArrUrl( url, strCode, strFunctionName, arrValue, arrDesc );
}

function PopupCommonUrl2( url, strCode, strFunctionName, strValue1, strValue2, strDesc1, strDesc2 )
{
	var arrValue = new Array();
	arrValue[0] = strValue1;
	arrValue[1] = strValue2;

	var arrDesc  = new Array();
	if(strDesc1 != "")
	{
		arrDesc[0] = strDesc1;
		arrDesc[1] = strDesc2;
	}

	PopupCommonArrUrl( url, strCode, strFunctionName, arrValue, arrDesc );
}

/**
* 공통팝업 포스트방식 호출
*
* strCode : 코드값(필수)
* strFunctionName : 콜백 함수(필수)
*                   D로 지정한 경우는 Default값(Code값_getCode(????))로
*                   설정되어진다.
* arrValue : 조회조건의 배열(Default:조회조건없음.)
* arrDesc : 화면표시 배열(Default : Desc1, Desc2, ...)
* width : 팝업의 폭(Default : 500)
* height : 팝업의 높이(default : 540)
* url : 호출 URL (Default : /common/cm_list1.jsp)
*/
function PopupCommonPost( strCode, strFunctionName, arrValue, arrDesc, width, height, url) {
	var postInputObj;
	//url의 값이 없을경우 기본값 셋팅
	if ( url    == undefined || url    == '' || url    == null ) {
		url = "/common/grid_cm_list.jsp";
	}
	//width의 값이 없을경우 기본값 셋팅
	if ( width  == undefined || width  == "" || width  == null ) {
		width = "500";
	}
	//height의 값이 없을경우 기본값 셋팅
	if ( height == undefined || height == "" || height == null ) {
		height = "540";
	}
	var title  = "SEARCH";
	var status = "toolbar=no,directories=no,scrollbars=yes,resizable=no,status=no,menubar=no,width=" + width + ", height=" + height;
	//post값 셋팅에서 넘길 form 생성
	var vCommonPopupForm = document.createElement("form");
	vCommonPopupForm.setAttribute("name"   , "commonPopupForm"  );
	vCommonPopupForm.setAttribute("method" , "post"             );
	vCommonPopupForm.setAttribute("target" , title              );
	vCommonPopupForm.setAttribute("action" , url                );

	if ( arrDesc != undefined || arrDesc != null ) {
        for (var i = 0 ; i < arrDesc.length ; i++){
            commonParamName  = arrDesc[i]; // name

            postInputObj = document.createElement("input");
            postInputObj.setAttribute("type"  , "hidden" );
            postInputObj.setAttribute("name"  , "desc" );
            postInputObj.setAttribute("value" , commonParamName);
            vCommonPopupForm.appendChild(postInputObj);
        }
    }

	if ( arrValue != undefined || arrValue != null ) {
        for (var i = 0 ; i < arrValue.length ; i++){
            commonParamValue = arrValue[i]; // value

            postInputObj = document.createElement("input");
            postInputObj.setAttribute("type"  , "hidden" );
            postInputObj.setAttribute("name"  , "values" );
            postInputObj.setAttribute("value" , commonParamValue);
            vCommonPopupForm.appendChild(postInputObj);
        }
    }

    postInputObj = document.createElement("input");
    postInputObj.setAttribute("type"  , "hidden" );
    postInputObj.setAttribute("name"  , "code" );
    postInputObj.setAttribute("value" , strCode);
    vCommonPopupForm.appendChild(postInputObj);

    postInputObj = document.createElement("input");
    postInputObj.setAttribute("type"  , "hidden" );
    postInputObj.setAttribute("name"  , "function" );
    postInputObj.setAttribute("value" , strFunctionName);
    vCommonPopupForm.appendChild(postInputObj);

	document.body.appendChild(vCommonPopupForm);

    openWindow = window.open('', title, status);
	vCommonPopupForm.submit();

}

function popupcodePost(type, func) {
    PopupCommonPost("", func, undefined, undefined, undefined, undefined, _POASRM_CONTEXT_NAME+"/common/grid_popup.jsp?type=" + type);
}

function delStr(checkStr)
{
  var str = "";
  checkStr = checkStr.toString();
  for (i = 0;i < checkStr.length;i++)
  {
      ch = checkStr.charAt(i);
      if (ch != "-")
      {
          str = str + ch;
      }
  }
  return str;
}

/**
 * popup, post로 넘기기
 *
 * 기존 popUpOpen 함수의 url을 <?> 기준으로 잘라 잘린 내용을 aparam 변수 담는다.
 * popUpOpen01 을 호출한다.
 * by 오토에버기준
 *
 */
var cpid = 0;
function popUpOpen01(url, title, width, height, aparam) {
	if (title == '') title = 'windowPopup01';
    if (width == '') width = 540;
    if (height == '') height = 500;
	var left = "";
	var top = "";
    //화면 가운데로 배치
    var dim = new Array(2);
	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';

    //get 방식의 param 값을 잘라 post 형식으로 입력한다.

    var arr = aparam.split('&');
  	var pa;
	var obj;
    var elem = document.getElementById('pf');

    if(elem) {
        elem.parentNode.removeChild( elem );
    }

	obj = createForm('pf', 'post', url, '_parent');

	for(var i=0;i<arr.length;i++){
		pa = arr[i].split('=');
		if(pa.length >=1) obj = addHidden(obj, pa[0], pa[1]);
    }
	document.body.insertBefore(obj,null);
	//if(cpid==0) document.forms[0].insertBefore(obj);

	var setValue = 'left='+left+', top='+top+',width='+width+',height='
	+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable;

	cpid++;
    var wintemp = window.open('', title ,setValue);
    obj.target = title;
    obj.method = 'POST';
    obj.action = url;
    obj.submit();
    
    wintemp.focus();
}
//input 생성
function addHidden(form,name,value) {
    var input = document.createElement('input');
    input.type = 'hidden';
    input.name= name;
    input.value= value;
    form.insertBefore(input,null);
    return form;
}
//form 생성
function createForm(name,method,action,target) {
    var form = document.createElement('form');
    form.name= name;
    form.id= name;
    form.method= method;
    form.action= action;
    form.target= target;
    return form;
}



//POST방식으로 팝업창 띄우기(공통)
// url : 호출 URL
// width : 폭
// height : 높이
// target : 팝업 타이틀(빈칸 및 특수문자 사용금지)
function doOpenPopup(url, width, height, target)
{
		if(target == null || target == ""){
			target = "tempWindow";
		}

	  document.forms[0].action = url;
	  document.forms[0].method = "post";

	  // 화면 가운데로 배치
	  var dim = new Array(2);

	  dim = ToCenter(height, width);
	  var top = '50px';//dim[0];
	  var left = '50px';//dim[1] - (new Number(width) / 2);

	  var toolbar = 'no';
	  var menubar = 'no';
	  var status = 'yes';
	  var scrollbars = 'yes';
	  var resizable = 'yes';

	  var setValue = "left=" + left + ", top=" + top + ",width=" + width
	          + ",height=" + height + ", toolbar=" + toolbar + ", menubar="
	          + menubar + ", status=" + status + ", scrollbars=" + scrollbars
	          + ", resizable=" + resizable;
	  var originalUrl1 = url.split("?")[0];
	  var originalUrl2 = originalUrl1.split("/");
	  var originalUrl3 = originalUrl2[originalUrl2.length-1].split(".")[0];
	  var newWin = window.open('', originalUrl3, setValue);
	  document.forms[0].target = originalUrl3;
	  document.forms[0].submit();
	  newWin.focus();
	  return newWin;
}
function SepoaGridGetCellValueIndex(obj, row_idx, column_name)
{
	if(obj.getColType(obj.getColIndexById(column_name)) == "ch") {
 	    if(obj.cells(obj.getRowId(row_idx), obj.getColIndexById(column_name)).getValue() == 0) {
			return 'false';
	    } else {
		   	return 'true';
	    }
   	} else {
   		return obj.cells(GridObj.getRowId(row_idx), obj.getColIndexById(column_name)).getValue();
   	}
}

function SepoaGridSetCellValueIndex(obj, row_idx, column_name, value)
{
	obj.cells(GridObj.getRowId(row_idx), obj.getColIndexById(column_name)).setValue(value);
}

function SepoaGridGetCellValueId(obj, row_id, column_name)
{
	if(obj.getColType(obj.getColIndexById(column_name)) == "ch") {
 	    if(obj.cells(row_id, obj.getColIndexById(column_name)).getValue() == 0) {
			return 'false';
	    } else {
		   	return 'true';
	    }
   	} else {
   		return obj.cells(row_id, obj.getColIndexById(column_name)).getValue();
   	}
}

function SepoaGridSetCellValueId(obj, row_id, column_name, value)
{
	obj.cells(row_id, obj.getColIndexById(column_name)).setValue(value);
}

/* 사용법 */
//        var row_idx = checkedOneRow(INDEX_SEL);
//        if (row_idx == -1) return;

function checkedDataRow(column_name) {
    var grid_array = getGridChangedRows(GridObj, column_name);

    if(grid_array.length > 0)
    {
    	return true;
    }

//   alert("The selected data does not exist.");
   alert("선택된 행이 없습니다.");
   return false;
}

/**
	맨상단의 idx에 해당하는 값을 반환한다.
	idx : t_boolean
	idxvalue : 얻고자 하는 값의 컬럼 인덱스
*/


/**
	체크박스에 대한 Y/N변환
*/
function getCheckBoxValue(obj)
{
	if(obj.checked==true)
	{
		return "Y";
	}
	return "N";
}


//! T&L
    /*왼쪽 0를 잘라준다
        RETURN : var */

    function Zero_LTrim(str)
    {
        if(str.charAt(0) == "0")
            {str=str.substring(1,str.length); return Zero_LTrim(str);}
        else
            return str;
    }
    
    /** 숫자여부를 검사
        RETURN : 숫자이면 true, 아니면or공백 - false */
    function IsNumber1(num)
    {
        var i;
        
        if(num.length <= 0) {
        	return false;
        }

        for(i=0;i<num.length;i++)
        {
            if((num.charAt(i) < '0' || num.charAt(i) > '9') && num.charAt(i) !='.'  ) {
            	return false;
            }
        }

        return true;
    }

    function chkKorea(chkstr)
    {
        var j, lng = 0;

        for (j=0; j<chkstr.length; j++)
        {
            if (chkstr.charCodeAt(j) > 255)
            {
                ++lng;
            }

            ++lng;
        }

        return lng;
    }


    function getLength(chkstr)
    {
        var j, lng = 0;

        for (j=0; j<chkstr.length; j++)
        {
            if (chkstr.charCodeAt(j) > 255)
            {
                ++lng;

                if(encoding_status != null && encoding_status.toUpperCase() == 'UTF-8')
                {
           			++lng
           		}
            }

			++lng;
        }

        return lng;
    }

function getStringLength(chkstr)
{
    var j, lng = 0;

    for (j=0; j<chkstr.length; j++)
    {
        if (chkstr.charCodeAt(j) > 255)
        {
            ++lng;
        }

		++lng;
    }

    return lng;
}

function getSubStrLength(chkstr, max_len)
{
    var j, lng = 0;

    for (j=0; j<chkstr.length; j++)
    {
    	++lng;

        if (chkstr.charCodeAt(j) > 255)
        {
            ++lng;
    		if(encoding_status != null && encoding_status.toUpperCase() == 'UTF-8')
    		{
    			++lng;
			}

            if(max_len < lng){
            	chkstr = chkstr.substring(0, j);
            	return chkstr;
            }
		}else{
		    if(max_len < lng){
            	chkstr = chkstr.substring(0, j);
            	return chkstr;
            }
		}
    }

    return chkstr;
}

	function getLength2Bytes(chkstr)
    {
        var j, lng = 0;

        for (j=0; j<chkstr.length; j++)
        {
            if (chkstr.charCodeAt(j) > 255)
            {
                ++lng;
            }

			++lng;
        }

        return lng;
    }

	function getSubStrLength2Bytes(chkstr, max_len)
	{
	    var j, lng = 0;

	    for (j=0; j<chkstr.length; j++)
	    {
	    	++lng;

	        if (chkstr.charCodeAt(j) > 255)
	        {
	            ++lng;

	            if(max_len < lng){
	            	chkstr = chkstr.substring(0, j);
	            	return chkstr;
	            }
			}else{
			    if(max_len < lng){
	            	chkstr = chkstr.substring(0, j);
	            	return chkstr;
	            }
			}
	    }

   	 return chkstr;
	}

    /** 오른쪽 공백를 잘라준다
        RETURN : var */
    function RTrim(str)
    {
        if(str.charAt(str.length-1) == " ")
            {str=str.substring(0,str.length-1); return RTrim(str);}
        else
            return str;
    }

    /** 왼쪽 공백를 잘라준다
        RETURN : var */
    function LTrim(str)
    {
        if(str.charAt(0) == " ")
            {str=str.substring(1,str.length); return LTrim(str);}
        else
            return str;
    }

    /** 좌우 공백를 잘라준다
        RETURN : var */
    function LRTrim(str)
    {
        return RTrim(LTrim(str));
    }

/** 일자의 입력 Check 달체크는 나중에 한다.
     RETURN : true */
	function checkDD(str)
	{
		dd = parseInt(str);

		if( str.length == 0)
			return true;
		for(j = 0; j<str.length ; j++){
			if((str.charAt(j) < '0' || str.charAt(j) > '9'))
			return false;
		}

		if( dd > 31)
			return false;
		else
			return true;
	}
    /** 윤년 계산 및 입력날짜 Check
        RETURN : true */
    function checkDateMessage(str)
    {
        var yy,mm,dd,ny,nm,nd;
        var arr_d;

        if(str.length != 8)
        {
            return false;
        }

        yy = str.substring(0,4);      // 년, 월, 일을 문자열로 가지고 있는다.
        mm = str.substring(4,6);
        dd = str.substring(6,8);

        if(mm < '10')  // patch 판
        {
            mm = mm.substring(1);  // patch 판
        }

        if(dd < '10')    // patch 판
        {
            dd = dd.substring(1);       // patch 판
        }

        ny = parseInt(yy);       // 년, 월, 일을 정수형으로 가지고 있는다.
        nm = parseInt(mm);
        nd = parseInt(dd);

        if(!(Number(yy)) || (ny < 1000) || (ny>9999))
        {
            alert('Check year.');
            return false;
        }

        if(!(Number(mm)) || (nm < 1) || (nm > 12))
        {
            alert('Check month.');
            return false;
        }

        arr_d = new Array('31','28','31','30','31','30','31','31','30','31','30','31')

        file:    //윤년계산

        if(((ny % 4 == 0)&&(ny % 100 !=0)) || (ny % 400 == 0)) arr_d[1] = 29;
        if(!(Number(dd)) || (nd < 1) || (nd > arr_d[nm-1]))
        {
            alert('Check day.');
            return false;
        }

        return true;
      }

    /** 문자열 delete
        RETURN : var */
    function deleteChar( str, ch )
    {
        var rt = "";

        for( i = 0; i < str.length; i++ )
        {
            if ( str.charAt( i ) == ch ) continue;
            else    rt += str.charAt( i );
        }

        return rt;
    }



//! E&P
/**
* @desc		현재 날짜에서 주어진 term(월) 만큼을 계산한다.
* @param	sys_date - System Date, terms - term을 두고 싶은 달수.
* @return	date - from_date + to_date. ex)2001012020010220
*/
function getDateCommon(sys_date, terms)
{
	var now = sys_date;                               // System Date 입니다!
    	var ny = now.substring(0,4);
        var nm = parseInt(now.substring(4,6));
        var nd = now.substring(6,8);
        var arr_d;
        var nm = nm - terms;                            // 현재날짜에서 한달 전입니다.
        var from_date;
        var to_date = now;
        var date;

        if(nm=="0") {
        	ny = ny-1;
        	nm = "12";
        }

        var mo=(nm<10) ? "0"+nm:nm;

        arr_d = new Array('31','28','31','30','31','30','31','31','30','31','30','31')
        if(((ny % 4 == 0)&&(ny % 100 !=0)) || (ny % 400 == 0))
        arr_d[1] = 29;

        for(var i=0;i<5;i++) {
        	if(nd > arr_d[nm-1]){
        		nd = nd - 1;
        	} else {
        		nd = nd;
        		break;
        	}
        }
        from_date = ny+mo+nd;
        date = from_date + to_date;
        return date;
}

/**
* @desc		현재 날짜에서 주어진 term(일) 만큼을 계산한다.
* @param	sys_date - System Date, terms - term을 두고 싶은 일수.
* @return	date - from_date + to_date. ex)2001012020010125
*/
function getDateCommon2(sys_date, terms)      // Term 을 일자단위로 줌.
{

	var now = sys_date;                             // System Date 입니다!
    	var ny = now.substring(0,4);
        var nm = now.substring(4,6);
        var nd = parseInt(now.substring(6,8));
        var arr_d;
        var nd = nd - terms;                        // 현재날짜에서 하루 전입니다.
        var from_date;
        var to_date = now;
        var date;

        if(nd==0) {
        	nm = nm-1;
        	if(nm == "0") {
        		ny = ny-1;
        		nm = "12";
        		nd = "31";
        	}
        	if(nm == "1") {
        		nm = "01";
        		nd = "31";
        	}
        	if(nm == "2") {
        		nm = "02";
        		nd = "28";
        	}
        	if(nm == "3") {
        		nm = "03";
        		nd = "31";
        	}
        	if(nm == "4") {
        		nm = "04";
        		nd = "30";
        	}
        	if(nm == "5") {
        		nm = "05";
        		nd = "31";
        	}
        	if(nm == "6") {
        		nm = "06";
        		nd = "30";
        	}
        	if(nm == "7") {
        		nm = "07";
        		nd = "31";
        	}
        	if(nm == "8") {
        		nm = "08";
        		nd = "31";
        	}
        	if(nm == "9") {
        		nd = "30";
        	}
        	if(nm == "10") {
        		nd = "31";
        	}
        	if(nm == "11") {
        		nd = "30";
        	}
        }

        var no;

        if(nd<10){
        	no = "0"+nd;
        }else {
        	no = nd;
        }
        var mo = nm;

        arr_d = new Array('31','28','31','30','31','30','31','31','30','31','30','31')
        if(((ny % 4 == 0)&&(ny % 100 !=0)) || (ny % 400 == 0))
        arr_d[1] = 29;

        for(var i=0;i<5;i++) {
        	if(nd > arr_d[nm-1]){
        		no = nd - 1;
        	} else {
        		nd = nd;
        		break;
        	}
        }

        from_date = ny+mo+no;
        date = from_date + to_date;
        return date;
}

/**
* @desc		윤달계산 및 날짜 체크.
* @param	str - 체크하고자 하는 날짜.
* @return	올바른 형식이면 true 리턴.
*/
function checkDateCommon(str)
{
	var yy,mm,dd,ny,nm,nd;
	var arr_d;

        if(str.length != 8)
                return false;

        yy = str.substring(0,4);            // 년, 월, 일을 문자열로 가지고 있는다.
        mm = str.substring(4,6);
        dd = str.substring(6,8);

        if(mm < '10')                             // patch 판
                mm = mm.substring(1);             // patch 판

        if(dd < '10')                             // patch 판
                dd = dd.substring(1);             // patch 판

        ny = parseInt(yy);       // 년, 월, 일을 정수형으로 가지고 있는다.
        nm = parseInt(mm);
        nd = parseInt(dd);

        if(!(Number(yy)) || (ny < 1000) || (ny>9999))
                return false;

        if(!(Number(mm)) || (nm < 1) || (nm > 12))
                return false;

        arr_d = new Array('31','28','31','30','31','30','31','31','30','31','30','31')

        // 윤년계산
        if(((ny % 4 == 0)&&(ny % 100 !=0)) || (ny % 400 == 0))
        arr_d[1] = 29;

        if(!(Number(dd)) || (nd < 1) || (nd > arr_d[nm-1]))
                return false;

        return true;
}

/**
* @desc		입력값의 오른쪽 공백를 잘라준다
* @param	str - 체크하고자 하는 문자열.
* @return	str - 공백을 제거한 후의 문자열 리턴.
*/
function RTrimCommon(str)
{
	if(str.charAt(str.length-1) == " ") {
		str=str.substring(0,str.length-1); return RTrimCommon(str);
	}
	else {
        	return str;
        }
}

/**
* @desc		입력값의 왼쪽 공백를 잘라준다
* @param	str - 체크하고자 하는 문자열.
* @return	str - 공백을 제거한 후의 문자열 리턴.
*/
function LTrimCommon(str)
{
	if(str.charAt(0) == " ") {
		str=str.substring(1,str.length); return LTrimCommon(str);
	}
	else {
		return str;
	}
 }

/**
* @desc		입력값이 숫자인지를 확인한다.
* @param	val - 체크하고자 하는 숫자.
* @return	값이 숫자이면 true 리턴.
*/
function isNumberCommon(val)
{
	if(val.length < 1)
		return false;

	for(i=0;i<val.length;i++) {
    		abit_dat = val.substring(i,i+1);

    		if(i == 0 && abit_dat == '-') continue;

    		if(abit_dat == '.') {

    		}
    		else {
    			abit = parseInt(val.substring(i,i+1));
		    	if(('0' < abit) || ('9' > abit) || ('.' == abit_dat)) {

		    	}
		    	else {
		    		return false;
		    	}
		}
    	}
    	return true;
}

/**
* @desc		입력값에 한글이 있는지를 확인한다.
* @param	str - 체크하고자 하는 문자열.
* @return	check_flag - 한글이 없으면 true 리턴.
*/
function hangulCheckCommon(str)
{
	var check_flag = true;
	var strValue = str;
	var retCode = 0;

	for (i = 0; i <  strValue.length; i++) {

		var retCode = strValue.charCodeAt(i);
		var retChar = strValue.substr(i,1).toUpperCase();
		retCode = parseInt(retCode);

		if ((retChar <  "0" || retChar  > "9") && (retChar <  "a" || retChar  > "z") && (retChar <  "A" || retChar  > "Z")) {

			check_flag = false;
			break;
		}
	}
	return check_flag;
}

/**
* @desc		들어온 데이타의 값에 공백 체크
* @param	date - String value
* @return	공백이 있으면 false 없으면 true
*/
function isEmpty(data){
    for(var i = 0; i < data.length; i++) {
        if(data.substring(i, i+1) != " ") {
            return false;
        }
    }
    return true;
 }

/**
폼의  값이  빈값인지 체크
*/
function checkEmpty(obj, message)
{
	if(isEmpty(obj.value))
	{
		alert(message);
		obj.focus();
		return false;
	}
	return true;
}

/**
	obj 객체가 chknum보다 큰지 체크
*/
function checkKorea(obj, message, chknum)
{
	if(chkKorea(obj.value) > chknum)
	{
		alert(message);
		obj.focus();
		obj.select();
		return false;
	}
	return true;
}

/**
* @desc		들어온 데이타 값이 있는지 체크
* @param	str - String value
* @return	값이 있으면 true  없으면 false
*/

 function isNull(str)
 {
    return ((str == null || str == "" || str == "<undefined>") ? true:false);
 }



/**
* @desc		들어온 날짜를 체크 한다. (윤년 계산 및 입력날짜 Check)
* @param	str - date 값이 들어온다.  ex)20010120
* @return	들어온 값이 날짜면 true, 아니면 false
*/
function checkDate(str)                /* 윤년 계산 및 입력날짜 Check */
{
        var yy,mm,dd,ny,nm,nd;
        var arr_d;

        if(str.length != 8)
                return false;

        yy = str.substring(0,4);           // 년, 월, 일을 문자열로 가지고 있는다.
        mm = str.substring(4,6);
        dd = str.substring(6,8);

        if(mm < '10')                             // patch 판
                mm = mm.substring(1);             // patch 판

        if(dd < '10')                             // patch 판
                dd = dd.substring(1);             // patch 판

        ny = parseInt(yy);        // 년, 월, 일을 정수형으로 가지고 있는다.
        nm = parseInt(mm);
        nd = parseInt(dd);

        if(!(Number(yy)) || (ny < 1000) || (ny>9999)) return false;

        if(!(Number(mm)) || (nm < 1) || (nm > 12))
                return false;

        arr_d = new Array('31','28','31','30','31','30','31','31','30','31','30','31')

        //윤년계산
        if(((ny % 4 == 0)&&(ny % 100 !=0)) || (ny % 400 == 0))
        arr_d[1] = 29;

        if(!(Number(dd)) || (nd < 1) || (nd > arr_d[nm-1]))  return false;

        return true;
}




/**
* @desc		 왼쪽 0를 잘라서 return 값으로 넘긴다.
* @param	 str - String
* @return	 왼쪽 0를 잘라서 값으로 넘긴다.
*/
function Zero_LTrim(str)
{
       if(str.charAt(0) == "0")
        {str=str.substring(1,str.length); return Zero_LTrim(str);}
      else
         return str;
}



/**
* @desc		String 값이 전화번호 입력인지 체크
* @param	num - number
* @return	맞으면 true , 틀리면 false 값을 return 한다.
*/
function IsTel(num) {
     for(i=0;i<num.length;i++)
        {
              if((num.charAt(i) < '0' || num.charAt(i) > '9') && num.charAt(i) !='-')
              {
                  return false;
                }
        }

      return true;
}

/**
* @desc		현재 날짜에서 주어진 term(월) 만큼을 계산한다.
* @param	num - number
* @return	맞으면 true, 틀리면 false return 한다.
*/
function IsNumber(num)
	{
			var i;
			pcnt = 0;

				 for(i=0;i<num.length;i++)
				{
					if (num.charAt(i) == '.')
					{
						pcnt ++;
					}
				      if((num.charAt(i) < '0' || num.charAt(i) > '9') && (num.charAt(i) != '.' ||  pcnt>1))
				      {
					  return false;
				        }
				}

			      return true;
	}




/**
* @desc		오른쪽 공백를 잘라준다
* @param	str - String
* @return	str - 오른쪽 공백을 제거한 String  vlaue return
*/
function RTrim(str)
{

	if(str.charAt(str.length-1) == " ") {
      		str=str.substring(0,str.length-1);
      		return RTrim(str);
      	}else
		return str;
	}


/**
* @desc		왼쪽 공백를 잘라준다.
* @param	str - String
* @return	str - 왼쪽 공백을 제거한 String  vlaue return
*/


function LTrim(str)
{

	if(str.charAt(0) == " "){
		str=str.substring(1,str.length);
		return LTrim(str);
	}else
		return str;
}


/**
* @desc		입력된 값이 Time (hhmmss)맞게 들어왔는지 체크
* @param	str - String
* @return	맞으면 true, 틀리면 false return 한다.
*/
function TimeCheck(str)
{

 var hh,mm,ss;

  if(str.length == 0)
     return true;

  if(IsNumber(str)==false || str.length !=6 )
    return false;

  hh=str.substring(0,2);
  mm=str.substring(2,4);
  ss=str.substring(4,6);

  if(parseInt(hh)<0 || parseInt(hh)>23)
     return false;

  if(parseInt(mm)<0 || parseInt(mm)>59)
     return false;

  if(parseInt(ss)<0 || parseInt(ss)>59)
     return false;

  return true;
}



/**
* @desc		주어진 String안의 특수한 문자를 url encoding한다.  사용 : url string을 만들때 name, value중 value부분
* @param	str - String
* @return	주어진 String안의 특수한 문자를 url encoding한다.
*/
function urlEncode(src){
	return encodeURIComponent(src);
}


	function decodeUrl(src) {
		return decodeURIComponent(src);
	}


/**
스크립트 상에서 금액단위별로 끊어서 보여준다..

*/
    function Comma(srcNumber)
    {
        var txtNumber = '' + srcNumber;

        if (isNaN(txtNumber) || txtNumber == "")
        {
            alert("숫자를 넣어주세요");
        }
        else
        {
            var rxSplit = new RegExp('([0-9])([0-9][0-9][0-9][,.])');
            var arrNumber = txtNumber.split('.');
            arrNumber[0] += '.';

            do
            {
                arrNumber[0] = arrNumber[0].replace(rxSplit, '$1,$2');
            } while (rxSplit.test(arrNumber[0]));

            if (arrNumber.length > 1)
            {
                return arrNumber.join('');
            }
            else
            {
                return arrNumber[0].split('.')[0];
            }
        }
    }


function resetPopup()
{
	//공통페이지에서 호출함. 지우지마삼
}

//일반팝업을 중앙에 위치도록 할때
function popUpOpen(url, title, width, height) {

/*
	if (title == '') title = '';
    if (width == '') width = 540;
    if (height == '') height = 500;
	var left = "";
	var top = "";

    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    code_search.focus();
    return code_search;
	var index = url.indexOf("?");
	var url2 = url.substring(0,index);
	var aparam = url.substring(index+1);
    popUpOpen01(url2, title, width, height, aparam);*/

	//창성
	return doOpenPopup(url, width, height, null);
}


function openMaterialInfo(MATERIAL_NUMBER) {


    width = 750;
    height = 650;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/master/material_detail_mgt.jsp?MATERIAL_NUMBER="+MATERIAL_NUMBER+"&BUY=&popup_flag=true";
	var info = window.open(url, 'MaterialInfo', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

	function chk_Ctrl_Code(own_ctrl_code, cmp_ctrl_code) {

		var ctrl_code = own_ctrl_code.split("&");
		var flag = false;

		for( i=0; i<ctrl_code.length; i++ )
		{
			if (ctrl_code[i] == cmp_ctrl_code){
				flag = true;
				break;
			}
		}

		return flag;
	}

function openSellerInfo(vendor_code) {


    width = 800;
    height = 350;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/master/seller_mgt_detail.jsp?st_vendor_code="+vendor_code + "&popup_flag=true";
	var info = window.open(url, 'sellerInfo', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function openPrInfo(pr_no) {


    var width = 900;
    var height = 650;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/sourcing/pr_req_detail.jsp";

    /*
    var url =  _POASRM_CONTEXT_NAME+"/sourcing/pr_req_detail.jsp?pr_no="+pr_no+"&popup_flag=true";
	var info = window.open(url, 'PRInfo', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    */

	var setValue  = "left="+left+", top="+top+",width="+width+",height="+height+", toolbar="+toolbar+", menubar="+menubar+", status="+status+", scrollbars="+scrollbars+", resizable="+resizable ;
    var info = window.open('','EX', setValue);
  	document.pop_form.PR_NUMBER.value = pr_no;
  	document.pop_form.popup_flag.value = "true";
  	document.pop_form.action = url;
  	document.pop_form.method = "post";
  	document.pop_form.target = "EX";
  	document.pop_form.submit();

    return info;
}
function openPOInfo(po_no, seller_code, attach_no) {
    width = 1000;
    height = 700;
	var left = "";
	var top = "60";

    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/procure/po_detail_display.jsp?po_no=" + po_no + "&seller_code=" + seller_code + "&attach_no=" + attach_no + "&popup_flag=true";
	var info = window.open(url, 'PurchaseOrderInfo', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function openPOInfoSeller(po_no, seller_code) {
    width = 1000;
    height = 700;
	var left = "";
	var top = "60";

    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/procure/po_detail_display_seller.jsp?po_no=" + po_no + "&seller_code=" + seller_code + "&popup_flag=true";
	var info = window.open(url, 'PurchaseOrderInfo', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function openReadMail(doc_no, confirm_date, text1, subject) {
    width = 900;
    height = 550;
	var left = "";
	var top = "";

    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/admin/readmail.jsp?doc_no="+doc_no+"&confirm_date="+confirm_date+"&popup_flag=true";
	/*var info = window.open(url, 'readmail', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;*/
    popUpOpen(url, 'readmail', width, height);
}

function openReadMail_Send(doc_no) {
    width = 900;
    height = 550;
	var left = "";
	var top = "";

    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/admin/readmail_send.jsp?doc_no="+doc_no;
	var info = window.open(url, 'readmail_send', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function openUgDoc(po_no, po_seq) {
    width = 850;
    height = 650;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/procure/ug_view.jsp?po_no=" + po_no + "&po_seq="+ po_seq + "&popup_flag=true";
	var info = window.open(url, 'PurchaseOrderInfo', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function openDoSchedule(po_no, po_seq) {
    width = 800;
    height = 500;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/procure/dely_regist.jsp?po_no=" + po_no + "&po_seq="+ po_seq + "&popup_flag=true";
	var info = window.open(url, 'PurchaseOrderInfo', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function openApInfo(ap_number, ap_year)
{
    width = 900;
    height = 650;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/procure/invoice_detail_in_display.jsp?inv_no=" + ap_number + "&ap_year=" + ap_year + "&popup_flag=true";
	var info = window.open(url, 'ApInfo', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function openPopupWindow(url, window_title, width, height)
{
	if(width == null || width == "")
	{
		width = 800;
	}

	if(height == null || height == "")
	{
		height = 650;
	}

	var left = "";
	var top = "";

    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME + url;
	var info = window.open(url, window_title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function openInvoiceConInfo(doc_no) {
    width = 900;
    height = 650;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/procure/invoice_con_detail_display.jsp?doc_no=" + doc_no + "&popup_flag=true";
	var info = window.open(url, 'InvoiceConInfo', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}


function openQTAInfo(qta_number, rfq_number, rfq_count, seller_code) {
    width = 1050;
    height = 650;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/sourcing/qta_create_seller.jsp?rfq_number=" + rfq_number + "&rfq_count=" + rfq_count + "&qta_number=" + qta_number + "&screen_mode=display&popup_flag=true";

    if(seller_code > ' ')
    {
    	url = url + "&seller_code=" + seller_code;
    }

	var info = window.open(url, 'QuotationInfo', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function openInvoiceInfo(inv_no) {
    width = 900;
    height = 650;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/procure/invoice_detail_display.jsp?inv_no=" + inv_no + "&popup_flag=true";
	var info = window.open(url, 'InvoiceInfo', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}


function openMaterialSearch() {


    width = 1010;
    height = 500;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/sourcing/pr_material_frame.jsp?item_cnt=one&popup_flag=true";
	var info = window.open(url, 'catalog', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function openReturnReasonInfo(value) {


    width = 500;
    height = 250;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/sourcing/pr_req_returninfo.jsp?value="+value;
	var info = window.open(url, 'ReturnReason', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function doReturnPrInput(pMode,email, pr_name) {


    width = 580;
    height = 340;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'no';
    var url =  _POASRM_CONTEXT_NAME+"/sourcing/pr_returnmsg_input.jsp?pMode="+pMode+"&email="+email+"&pr_name="+pr_name;
	var info = window.open(url, 'catalog', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function rfqInsertInfo() {


    width = 1000;
    height = 600;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/sourcing/rfq_req_insert.jsp";
	var info = window.open(url, 'RFQ_INSERT', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function openRFQInfo(rfq_no, rfq_count) {


    width = 930;
    height = 750;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/sourcing/rfq_req_detail.jsp?rfq_number=" + rfq_no + "&rfq_count=" + rfq_count;
	var info = window.open(url, 'RFQ_INFO', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function openExecInfo(exec_no) {


    width = 900;
    height = 800;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/sourcing/app_update.jsp?exec_no=" + exec_no + "&screen_mode=display";
	var info = window.open(url, 'RFQ_INFO', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function openExecMaInfo(exec_no) {


    width = 900;
    height = 800;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/sourcing/app_manual_update.jsp?exec_no=" + exec_no + "&screen_mode=display";
	var info = window.open(url, 'RFQ_INFO', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}

function openNegoInfo(rfq_no, rfq_count, nego_count) {


    width = 1080;
    height = 550;
	var left = "";
	var top = "";


    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var url =  _POASRM_CONTEXT_NAME+"/sourcing/nego_req_detail.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count + "&nego_count=" + nego_count;
	var info = window.open(url, 'RFQ_INFO', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    info.focus();
    return info;
}


//JavaScript로 새창을 띄울때 사용
function winOpen(url, title) {
	if (title == '') title = 'Popup_Open';
    var width = 900;
    var height = 800;
	var left = "";
	var top = "";

    //화면 가운데로 배치
    var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

    var toolbar = 'yes';
    var menubar = 'yes';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var directories = 'yes';
    var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable+', directories='+directories);
    code_search.focus();
    return code_search;
}

function CenterWindow(height,width)
{

			var outx = screen.height;
			var outy = screen.width;
			var x = (outx - height)/2;
			var y = (outy - width)/2;
			dim = new Array(2);
			dim[0] = x;
			dim[1] = y;

			return  dim;
}

///////////소수점 포맷/////////////////////////////////////

//소수점이하는 제외한 정수부분
function fixed_number(aa)
{
    var len = aa.length;
    var tmp = "" ;
    var i = 0 ;
    for(i = 0 ; i < len ; i++)
    {
        if(aa.charAt(i) == ".")
        {
            break ;
        }
        tmp +=  aa.charAt(i) ;
    }
    return tmp ;
}


//정수를 제외한 소수점 이하부분
function decimal_number(bb, point_pos)
{
    var len = bb.length;
    var tmp = "" ;
    var x = 1;

    for(i = 0 ; i < len ; i++)
    {
        if(bb.charAt(i) == ".")
        {
            i = eval(i) + 1 ;
            for(k = i; i <= len; i++)
            {
                tmp +=  bb.charAt(i);
            }
            break;
        }
    }

    var rtn = Round(tmp, point_pos);
    return rtn;
}



//반올림을 한다.
function Round(dd, pnt) {
	var tmp = "";
	if(dd.length == 0) {
		tmp = "0.";
//소수점자리가 없는경우
		for (i = 0; i<eval(pnt); i++) {
			tmp += "0";
		}
	} else if (dd.length < eval(pnt)) {
//소수점 자리가 있으나 소수점이하 자리수가 작을 경우
		tmp = "0."+dd;
		for (i = dd.length; i<eval(pnt); i++) {
			tmp += 0;
		}
	} else if (dd.length == eval(pnt)) {
		//소수점 자리가 있으나 소수점이하 자리수가 같을 경우
		tmp = "0."+dd;

		for (i = dd.length; i<eval(pnt); i++) {
			tmp += 0;
		}
	} else  if (dd.length > eval(pnt)) {
  		//소수점 자리가 있으나 소수점이하 자리수가 클 경우
		tmp = "0."+dd;
		tmp = point(tmp, pnt);
	}
	return tmp;
}




  //소수점자리 Fomatter
function point(data, point_pos) {
	var result;       //결과값 리턴.
	var x = 1;

	for (var i = 0; i<point_pos; i++) {
		x = eval(x)*10;
	}

	var a = eval(data)*eval(x);
	var result = Math.round(a);
	result = result/x;
	return result;
}



  //소수점 찾기
function searchDot(input)
{
    var output = IsTrimStr(input);
    var s = "" ;

    for(i=0; i<output.length;i++)
    {
        if(output.charAt(i)==".")
        {
            s = i ;
            return s;
            break;
        }
    }
    return s ;
}


function add_comma(input, num)
{


    var output = "";
    var output1 = "";
    var output2 = "";
    var temp1 = IsTrimStr(input);
      //var temp1 = input;


    if(temp1 != "") {
        var temp = fixed_number(temp1);

        i = temp.length ;
        var k = i / 3 ;
        var m = i % 3 ;
        var n= 0;
        if(m==0) {
            for(j=0;j<k-1;j++) {
                output1 += temp.substring(n, j*3+3)+",";
                n=j*3+3;
            }
        } else {
            for(j=0;j<k-1;j++)
            {
                output1 += temp.substring(n, j*3+m)+",";
                n=j*3+m;
            }
        }

        output1 += temp.substring(n,temp.length);

        var h = searchDot(temp1);

        if(num != "0") {
            output2 += "." ;
        }


        if(h == "")
        {
            for(p=0; p<num; p++)
            {
                output2 += "0" ;
            }
        } else {

            var temp2 = decimal_number(temp1,num)+"" ;

            temp2 = temp2.substring(1,temp2.length);

            output2 = temp2;


        }
        output = output1 + output2 ;


    } else if(temp1 == "") {
        if(num == "0")
        {
            output += "" ;
        }
        else
        {
            output += "0." ;
        }

        for(p=0; p<num; p++)
        {
            output += "0" ;
        }
    }
    return output;
}


  //콤마(,)  빼기
function del_comma(input)
{
    var s = 0;

   for(i=0; i<input.length;i++)
    {
        if(input.charAt(i)==",")
        {
            s++ ;
        }
    }

    for(i = 0;i < s; i++)
    {
        input = input.replace(",", "");
    }
    return input;
}


  //공백을 제거하는 함수
function IsTrimStr(checkStr)
{
    var str = "";
    checkStr = checkStr.toString();
    for (i = 0;i < checkStr.length;i++)
    {
        ch = checkStr.charAt(i);
        if (ch != " ")
        {
            str = str + ch;
        }
    }
    return str;
}


  //한글 입력 못하게
function chkHangul(val)
{
    var j = 0;

    for (j=0; j<val.length; j++)
    {
        if (val.charCodeAt(j) > 255)
        {
            return false;
            break;
        }
    }
    return true;
}



//소수점 자리 제거
function fomatter(x, point) {
	var y;	  //정수부분
	var z;    //소수부분
	if (chkHangul(x)) {
		x = IsTrimStr(x);
 		//document.forms[0].Y.value = fixed_number(x);

		y = fixed_number(x);	  //정수

		var num= decimal_number(x, point);
	    num = num.toString();

	    var num1 = num.substring(1, num.length);   //소수점 이하
		 var num2 = num.substring(0, 1);	  //소수점 이상의 정수부분

		if (eval(num2) > 0) {
			y = eval(y) + eval(num2);
		}

		var a = y;
		var b = num1;

		if (b.length == 0) {
			b = decimal_number(a, point);
			b = b.substring(1, b.length);     //소수점 이하
		}

		a = IsTrimStr(a);
		var c = add_comma(a, 0)+b;
		return c;
	} else {
		alert("Input number.");
		return;
	}
}


    function encodeUrl(src){
    /*
        src = src + "" ;
        var tgt = "";
        var c = "";

        for (var i = 0 ; i < src.length; i++) {
            c = src.charAt(i);

            if (c == '#')   tgt = tgt.concat("%23");
            else if (c == ' ')  tgt = tgt.concat("+");
            else if (c == '+')  tgt = tgt.concat("%2B");
            else if (c == '=')  tgt = tgt.concat("%3D");
            else if (c == '&')  tgt = tgt.concat("%26");
            else if (c == '%')  tgt = tgt.concat("%25");
            else if (c == '#')  tgt = tgt.concat("%23");
            else if (c == '"')  tgt = tgt.concat("%22");
            else if (c == '\'') tgt = tgt.concat("%27");
            else if (c == ';')  tgt = tgt.concat("%3B");
            else if (c == ':')  tgt = tgt.concat("%3A");
            else    tgt = tgt.concat("" + c);
        }

        return tgt;*/
        return encodeURIComponent(src);
    }

  function encodeUrlOrigin(src){
      	return encodeURIComponent(src);
    }


function popupcode( type, fun )
{
    //var url = "/kr/admin/wisepopup/oep_pp_lis1.jsp?type=" + type + "&function=" + fun;
    //var url = _POASRM_CONTEXT_NAME+"/common/popup_1.jsp?type=" + type + "&function=" + fun;
    var url = _POASRM_CONTEXT_NAME+"/common/grid_popup.jsp?type=" + type + "&function=" + fun;
    var width = 650;
    var height = 500;


    var dim = new Array(2);
    dim = CenterWindow(height,width);
    top = dim[0];
    left = dim[1];
    var left = left;
    var top = top;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'no';
    var scrollbars = 'no';
    var resizable = 'no';
    var ep_code_search = window.open( url, 'ep_code_search', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    ep_code_search.focus();
}
//POST방식으로 전송
//오토에버 소스
function popupcode01( type, fun )
{
    //var url = "/kr/admin/wisepopup/oep_pp_lis1.jsp?type=" + type + "&function=" + fun;
    //var url = _POASRM_CONTEXT_NAME+"/common/popup_1.jsp";
    var url = _POASRM_CONTEXT_NAME+"/common/grid_popup.jsp";
    var param ="type=" + type + "&function=" + fun;
    popUpOpen01(url, 'popupcode', '650', '500', param);
}

//엔터키 입력시 검색함수 호출

	function enableEnterKey() {
		function onkeypress(e) {
			//2011.07.04 시설공사상세내역 입력시 담당자가 enterkey를  쳐 화면이 리플레쉬되기때문에  아래 조건에 추가함. window.event.srcElement.type != "text"
			if(window.event.keyCode == 13 && window.event.srcElement.type != "textarea") { // 13 : Enter
				if(typeof setQuery == "function")
					setQuery();
				else if(typeof search == "function")
					search();
				else if(typeof Search == "function")
					Search();
				else if(typeof Query == "function")
					Query();
				else if(typeof query == "function")
					query();
				else if(typeof getQuery == "function")
					getQuery();
				else if(typeof doQuery == "function")
					doQuery();
				else if(typeof doSelect == "function")
					doSelect();
			}
		}

		document.onkeypress = onkeypress;
	}

	//enableEnterKey();



function FileAttachChange(TYPE,attach_key,isSession)
{

 if(isNull(TYPE)) {
   alert("Input file type.");
   return;
 }
 if(isNull(attach_key)) {
   alert("Input file key value.");
   return;
 }
// var view_type = "VI";
 var view_type = "";
 var protocol = location.protocol;
 var host = location.host;
 var addr = protocol +"//" +host;

     //화면 가운데로 배치
    var w_dim = new Array(2);

	w_dim = ToCenter(400, 640);
	var w_top = w_dim[0];
	var w_left = w_dim[1];

 if(view_type == "VI")
 {
 	//win = window.open(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_2013.jsp?type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession,"fileattach",'left=' + w_left + ',top=' + w_top + ', width=640, height=400,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');
// 	popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_2013.jsp", "fileattach", 640, 400, "type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
 	popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/filelob/file_attach.jsp", "fileattach", 640, 400, "type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
 }else {
	// 다른 경우는 없음
 	//win = window.open(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_2013.jsp?type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession,"fileattach",'left=' + w_left + ',top=' + w_top + ', width=640, height=400,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');
//	popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_2013.jsp", "fileattach", 640, 400, "type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
	popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/filelob/file_attach.jsp", "fileattach", 640, 400, "type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
 }
 return;
}
function isMail(val){
	if ( val.search(/(^\..*)|(.*\.$)/) != -1 || val.search(/\S+@(\S+)\.(\S+)/) == -1) {
			return false;
		}
	return true;
}

/*
 이메일 형식 체크
*/
function checkMail(obj) {
	re=/^[0-9a-z]([-_\.]?[0-9a-z])*@[0-9a-z]([-_\.]?[0-9a-z])*\.[a-z]{2,3}$/i;
    if(!re.test(obj.value)) {
		alert("이메일 형식이 올바르지 않습니다.");
		return;
    }
}

function FileAttach(TYPE,attach_key,view_type,isSession)
{
/*
 type= 파일 첨부 종류

 PR:구매요청
 RFQ : 견적 요청서
 AU:경매
 RA:역경매
 PX:구매 대행
 BY:BUYER_ITEM
 CT: CONTRACT

 attach_key =파일 첨부 Key
 파일 첨부 처음하는 경우도 현재 예제처럼 기술한다.

 wise.properties에 기술한다.

*/
	if(view_type == null || view_type == ''){
		view_type = "IN";
	}

	if(view_type == "IN" && isNull(TYPE)) {
	//view_type이 VI인 경우는 type이 필요없다.어차피 DB에서 가지고 올 것이기 때문에
	//하지만 파일을 첨부할 경우는 필요하다.
   		alert("파일첨부 종류의 값이 없습니다.");
   	return;
 }
 var protocol = location.protocol
 var host = location.host
 var addr = protocol +"//" +host

     //화면 가운데로 배치
    var w_dim = new Array(2);

	w_dim = ToCenter(200, 620);
	var w_top = w_dim[0];
	var w_left = w_dim[1];


 if(view_type == "VI")
 {
	 //win = window.open(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_downloadView_2013.jsp?attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession,"fileattachDownload1",'left=' + w_left + ',top=' + w_top + ', width=640, height=200,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');
	 //BLOB테스트
	 popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/filelob/file_download.jsp", "fileattachDownload1", 640, 200, "type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
//	 popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_downloadView_2013.jsp", "fileattachDownload1", 640, 200, "type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
 }else if(view_type == "DV"){
	 //popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/filelob/file_attach_downloadView.jsp", "fileattachDownload1", 640, 200, "type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
	 popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_downloadView_2013.jsp", "fileattachDownload1", 640, 200, "type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
 }else{
 	//win = window.open(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_2013.jsp?type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession,"fileattach1",'left=' + w_left + ',top=' + w_top + ', width=640, height=400,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');
	 
     //BLOB테스트
	 popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/filelob/file_attach.jsp", "fileattach", 640, 400, "type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
// 	popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_2013.jsp", "fileattach", 640, 400, "type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
 }
 return;
}

function attach_file(attach_no, module, isSession)
{
	var ATTACH_VALUE = LRTrim(attach_no);

	//신규 첨부
	if("" == ATTACH_VALUE) {
		FileAttach(module,'','',isSession);
	} else {
		//추가
		FileAttachChange(module, ATTACH_VALUE, isSession);
	}
}

function attach_file_grid(attach_no, module, isSession)
{
	var ATTACH_VALUE = LRTrim(attach_no);
	if("" == ATTACH_VALUE) {
		FileAttach_Grid(module,'','',isSession);
	} else {
		FileAttachChange_Grid(module, ATTACH_VALUE, isSession);
	}
}


function FileAttach_Grid(TYPE,attach_key,view_type,isSession)
{
/*
 type= 파일 첨부 종류

 PR:구매요청
 RFQ : 견적 요청서
 AU:경매
 RA:역경매
 PX:구매 대행
 BY:BUYER_ITEM
 CT: CONTRACT

 attach_key =파일 첨부 Key
 파일 첨부 처음하는 경우도 현재 예제처럼 기술한다.

 wise.properties에 기술한다.

*/
 if(isNull(TYPE)) {
   alert("파일첨부 종류의 값이 없습니다.");
   return;
 }
 var protocol = location.protocol
 var host = location.host
 var addr = protocol +"//" +host

     //화면 가운데로 배치
    var w_dim = new Array(2);

	w_dim = ToCenter(200, 620);
	var w_top = w_dim[0];
	var w_left = w_dim[1];

 if(view_type == "VI")
 {
	//win = window.open(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_downloadView_2013.jsp?type="+TYPE+"&isGrid=true&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession,"fileattach1",'left=' + w_left + ',top=' + w_top + ', width=640, height=200,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');
//	 popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_downloadView_2013.jsp", "fileattach1", 640, 200, "type="+TYPE+"&isGrid=true&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
	 popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_download.jsp", "fileattach1", 640, 200, "type="+TYPE+"&isGrid=true&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
 }else {
	//win = window.open(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_2013.jsp?type="+TYPE+"&isGrid=true&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession,"fileattach1",'left=' + w_left + ',top=' + w_top + ', width=640, height=400,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');
//	popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_2013.jsp", "fileattach1", 640, 400, "type="+TYPE+"&isGrid=true&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
	popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/filelob/file_attach.jsp", "fileattach1", 640, 400, "type="+TYPE+"&isGrid=true&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
 }
 return;
}

function FileAttachChange_Grid(TYPE,attach_key,isSession)
{

 if(isNull(TYPE)) {
   alert("Input file type.");
   return;
 }
 if(isNull(attach_key)) {
   alert("Input file key value.");
   return;
 }
 var view_type = "VI";
 var protocol = location.protocol
 var host = location.host
 var addr = protocol +"//" +host

     //화면 가운데로 배치
    var w_dim = new Array(2);

	w_dim = ToCenter(400, 640);
	var w_top = w_dim[0];
	var w_left = w_dim[1];

 if(view_type == "VI")
 {
	//win = window.open(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_2013.jsp?type="+TYPE+"&isGrid=true&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession,"fileattach",'left=' + w_left + ',top=' + w_top + ', width=640, height=400,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');

	 //BLOB 테스트 함
//	 popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/filelob/file_attach.jsp", "fileattach1", 640, 400, "type="+TYPE+"&isGrid=true&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
	 popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_2013.jsp", "fileattach1", 640, 400, "type="+TYPE+"&isGrid=true&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
 }else {
 	//win = window.open(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_2013.jsp?type="+TYPE+"&isGrid=true&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession,"fileattach",'left=' + w_left + ',top=' + w_top + ', height=400,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');
 	
	//BLOB 테스트 함 
//	 popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/filelob/file_attach.jsp", "fileattach1", 640, 400, "type="+TYPE+"&isGrid=true&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
	 popUpOpen01(_POASRM_CONTEXT_NAME+"/sepoafw/file/file_attach_2013.jsp", "fileattach1", 640, 400, "type="+TYPE+"&isGrid=true&attach_key="+attach_key+"&view_type="+view_type+"&isSession="+isSession);
 }
 return;
}



function SaveFileCommon(col)
{
  	//var Rtn = GD_ExcelExport(document.WiseGrid,col);
  	var Rtn = SepoaGridExcelExport(document.WiseGrid,col);
	//var Rtn = SepoaGridExcelExport(document.GridObj,col);

	if(Rtn) {
    /*	if(confirm("'" + Rtn + "' 에 저장된 파일 열기")) {
			window.open(Rtn,"xls","width=800,height=550,menubar=YES,resizable=YES,scrollbars=YES,top=60,left=20");
		}
    */
    	alert("Saved Complete!" );
	}
}

/**
	중복검사
*/
function isDuplicate(wise, bidx, cidx, message)
{
	var iRowCount = document.WiseGrid.GetRowCount();

	var init = iRowCount-1;

	for(var i=init;i>0;i--)
	{
		for(var j=i-1;j>=0;j--)
		{
			if(SepoaGridGetCellValueIndex(document.WiseGrid,i,bidx)=="true")
			{
				//키
				var key1 = "";
				var key2 = "";

				for(var k=0;k<cidx.length;k++)
				{
					key1 = key1 + SepoaGridGetCellValueIndex(document.WiseGrid,i,cidx[k]);
					key2 = key2 + SepoaGridGetCellValueIndex(document.WiseGrid,j,cidx[k]);
				}

				if(key1 == key2)
				{
					alert(message + (i+1) + " Row,  " + (j+1) + " Row");
					return true;
				}

			}
		}
	}
	return false;
}

function getCheckedOneValue(wise, idx, need_idx)
{
	for(var i=0;i<document.WiseGrid.GetRowCount();i++)
	{
		if(SepoaGridGetCellValueIndex(document.WiseGrid,i,idx) == "true")
		{
			return SepoaGridGetCellValueIndex(document.WiseGrid,i,need_idx);
		}
	}
}


/**
	와이즈테이블의 체크된 항목을 지운다.
*/
function deleteWiseTable(wise, idx)
{
	for(var i=document.WiseGrid.GetRowCount()-1;i>=0;i--)
	{
		if(SepoaGridGetCellValueIndex(document.WiseGrid,i,idx) == "true")
		{
			document.WiseGrid.DeleteRow(i);
		}
	}
}


/**
	빈값일 경우 0을 리턴한다.
	eval로  계산을 위해 사용한다.
*/
function getCalculEval(value)
{
	if(value == "")
		return 0;
	return eval(value);
}

function commaPrice(obj, type, number)
{
	if(!isNumberCommon(obj.value))
	{
		obj.value = "";
		return;
	}

	if(type == "add")
		obj.value = add_comma(obj.value,number);
	else
		obj.value = del_comma(obj.value);

}

/**
	와이즈 테이블의 체크된 제일 위 항목을 가져온다.
*/
function getCheckedPos(wise, idx)
{
	for(var i=0;i<document.WiseGrid.GetRowCount();i++)
	{
		if(SepoaGridGetCellValueIndex(document.WiseGrid,i,idx) == "true")
		{
			return i;
		}
	}
	return -1;
}

function floor_number(number, point)
{
	cnj_x = number;
	cnj_y = point;
	return Math.floor(cnj_x * Math.pow(100, cnj_y)) / Math.pow(100, cnj_y);
}

function ceil_number(number, point)
{
	cnj_x = number;
	cnj_y = point;
	return Math.ceil(cnj_x * Math.pow(100, cnj_y)) / Math.pow(100, cnj_y);
}

function round_number(number, point)
{
	cnj_x = number;
	cnj_y = point;
	return Math.round(cnj_x * Math.pow(100, cnj_y)) / Math.pow(100, cnj_y);
}

function copyCell(wise, idx, type)
{


	if(document.WiseGrid.GetRowCount() < 2)
		return;

	var value = SepoaGridGetCellValueIndex(document.WiseGrid,0,idx);
	var text = document.WiseGrid.GetCellValue(document.WiseGrid.GetColHDKey(idx),0);

	if(isEmpty(value))
	{
		for(i=1; i<document.WiseGrid.GetRowCount(); i++)
		{
			value = SepoaGridGetCellValueIndex(document.WiseGrid,i,idx);
			text = document.WiseGrid.GetCellValue(document.WiseGrid.GetColHDKey(idx),i);
			if(!isEmpty(value))
			{
				break;
			}
		}
	}


	if(type == "t_imagetext")
	{
		for(i=0; i<document.WiseGrid.GetRowCount(); i++)
		{
			SepoaGridSetCellValueIndex(document.WiseGrid,i, idx, G_IMG_ICON + "&"+text+"&"+value, "&");
		}
	}
	else
	{
		for(i=0; i<document.WiseGrid.GetRowCount(); i++)
		{
			SepoaGridSetCellValueIndex(document.WiseGrid,i, idx, value);
		}
	}
}

/**
	빈값일 경우 0을 리턴한다.
	float 계산을 위해 사용한다.
*/
function getCalculInt(value)
{
	if(value == "")
		return 0;
	return parseInt(value);
}

/**
	빈값일 경우 0을 리턴한다.
	float 계산을 위해 사용한다.
*/
function getCalculFloat(value)
{
	if(value == "")
		return 0;
	return parseFloat(value);
}

/**
	빈값일 경우 0을 리턴한다.
	eval로  계산을 위해 사용한다.
*/
function getCalculEval(value)
{
	if(value == "")
		return 0;
	return eval(value);
}



function sendTransactionGrid_1(GridObj, data_processor, selected, grid_array)
{
	if(grid_array == null)
	{
		alert("grid_array is null.");
		return;
	}

	data_processor.init(GridObj);
	data_processor.enableDataNames(true);
	data_processor.setTransactionMode("POST", true);
	data_processor.defineAction("doSaveEnd", doSaveEnd);
	//data_processor.enableDebug(true);
	data_processor.setUpdateMode("off");
	var row = 0;

	//for(row = dhtmlx_start_row_id; row < dhtmlx_end_row_id; row++)
	for(row = 0; row < grid_array.length; row++)
	{
		//checked = GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById(selected)).getValue();
		checked = GridObj.cells(grid_array[row], GridObj.getColIndexById(selected)).getValue();

		if(checked == "1") {
			//myDataProcessor.setUpdated(GridObj.getRowId(row), true);
			data_processor.setUpdated(grid_array[row], true);
		} else {
			//myDataProcessor.setUpdated(GridObj.getRowId(row), false);
			data_processor.setUpdated(grid_array[row], false);
		}
    }

	data_processor.setUpdateMode("row");
	data_processor.sendData();
	data_processor.setUpdateMode("off");

	//doQueryDuring();
}


function sendTransactionGrid(GridObj, data_processor, selected, grid_array)
{
	if(grid_array == null)
	{
		alert("grid_array is null.");
		return;
	}

	data_processor.init(GridObj);
	data_processor.enableDataNames(true);
	data_processor.setTransactionMode("POST", true);
	data_processor.defineAction("doSaveEnd", doSaveEnd);
	//data_processor.enableDebug(true);
	data_processor.setUpdateMode("off");
	var row = 0;

	//for(row = dhtmlx_start_row_id; row < dhtmlx_end_row_id; row++)
	for(row = 0; row < grid_array.length; row++)
	{
		//checked = GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById(selected)).getValue();
		checked = GridObj.cells(grid_array[row], GridObj.getColIndexById(selected)).getValue();

		if(checked == "1") {
			//myDataProcessor.setUpdated(GridObj.getRowId(row), true);
			myDataProcessor.setUpdated(grid_array[row], true);
		} else {
			//myDataProcessor.setUpdated(GridObj.getRowId(row), false);
			myDataProcessor.setUpdated(grid_array[row], false);
		}
    }

	myDataProcessor.setUpdateMode("row");
	myDataProcessor.sendData();
	myDataProcessor.setUpdateMode("off");

	doQueryDuring();
}

/**
  2013-01-13
     박세준
     송태호과장님이 주신 POST방식 소스로 반영
 */

function sendTransactionGridPost(GridObj, data_processor, selected, grid_array){
	if(grid_array == null){
		alert("grid_array is null.");
		return;
	}

	data_processor.init(GridObj);
	data_processor.enableDataNames(true);
	data_processor.setTransactionMode("POST", true);
	data_processor.defineAction("doSaveEnd", doSaveEnd);
	//data_processor.enableDebug(true);
	data_processor.setUpdateMode("off");
	var row = 0;

	for(row = 0; row < grid_array.length; row++) {
		checked = GridObj.cells(grid_array[row],
		GridObj.getColIndexById(selected)).getValue();

		if(checked == "1") {
			data_processor.setUpdated(grid_array[row], true);
		} else {
			data_processor.setUpdated(grid_array[row], false);
		}
	}

	data_processor.setUpdateMode("row");
	data_processor.sendDataPost();
	data_processor.setUpdateMode("off");

	doQueryDuring();
}

function getGridSelectedRows( gridobj, selected ){
//	var grid_array = getGridChangedRows(GridObj, "SELECTED");
//	
//  	for( var gridIndex = 1 , arrayDataIndex = 0 , arrayInputIndex = grid_array.length , iMax = GridObj.getRowsNum() + 1 ; gridIndex < iMax ; gridIndex++ ){
//		if( gridIndex == grid_array[ arrayDataIndex ] ){
//			arrayDataIndex++;
//		  	continue;
//		  
//	  	}
//	  
//	 	if(SepoaGridGetCellValueId( GridObj , gridIndex, "SELECTED" ) == "true") {
//			grid_array[ arrayInputIndex ] = gridIndex;
//			arrayInputIndex++;
//			
//		}
//	  
//  	}
  	
	var grid_array = Array();

	for( var i = 1 , arrayInputIndex = 0 , iMax = gridobj.getRowsNum() + 1 ; i < iMax ; i++ ){
	 	if(SepoaGridGetCellValueId( gridobj , i, selected ) == "true") {
			grid_array[ arrayInputIndex ] = i;
			arrayInputIndex++;
			
		}
  
	}
	
	return grid_array;
	
}

function getGridChangedRows(gridobj, selected)
{
	var changed_array = new Array();
	var grid_array = new Array();
	var grid_index = 0;
	var changed_row = gridobj.getChangedRows();
	changed_array = changed_row.split(",");

	for(i = 0; i < changed_array.length; i++)
	{
		if(changed_array[i].length > 0)
		{
			if(SepoaGridGetCellValueId(gridobj, changed_array[i], selected) == "true")
			{
				grid_array[grid_index] = changed_array[i];
				grid_index++;
			}
		}
	}

	return grid_array;
}

function getGridChangedRowsByOrder(gridobj, selected) {
	var changed_array = new Array();
	var grid_array = new Array();
	var grid_index = 0;

	var rowID;

	for(var i = 0; i < gridobj.getRowsNum(); i++) {
		rowID=mygrid.getRowId(i);
		if(SepoaGridGetCellValueId(gridobj, rowID, selected) == "true")
		{
			grid_array[grid_index] = changed_array[i];
			grid_index++;
		}
	}

	return grid_array;
}

/**
	idx에 해당하는 체크된 카운트를 반환한다.
	getCheckedCount(document.WiseGrid, bIndex)
*/
function getCheckedCount(GridObj, column_name)
{
	var iCheckedCount = 0;
	var grid_array = getGridChangedRows(GridObj, column_name);
	iCheckedCount = grid_array.length;
	return iCheckedCount;
}

function checkedOneRow(column_name)
{
    var checked_count = 0;
    var checked_row   = -1;

    var grid_array = getGridChangedRows(GridObj, column_name);
    checked_count = grid_array.length;

	if(checked_count == 0)  {
        alert(G_MSS1_SELECT);
        return -1;
    }

    if(checked_count > 1)  {
        alert(G_MSS2_SELECT);
        return -1;
    }

    checked_row = grid_array[0];

    return checked_row;
}

function chkOneRow(column_name)
{
    var checked_count = 0;
    var checked_row   = -1;

    var grid_array = getGridChangedRows(GridObj, column_name);
    checked_count = grid_array.length;

	if(checked_count == 0)  {
        return -1;
    }

    checked_row = grid_array[0];

    return checked_row;
}

function chkLastOneRow(column_name)
{
    var checked_count = 0;
    var checked_row   = -1;

    var grid_array = getGridChangedRows(GridObj, column_name);
    checked_count = grid_array.length;

	if(checked_count == 0)  {
        return -1;
    }

    checked_row = grid_array[grid_array.length - 1];

    return checked_row;
}


/**
* @desc		입력된  from ~ to  크기 비교 (to 가 from 보다 적으면 error)
* @param	from_date - 시작일자.
* @param	to_date - 종료일자.
* @return	올바른 형식이면 true 리턴.
*/

function checkDateBetween(from_date, to_date)
{

	var temp1 = "";
	var temp2 = "";

	if(from_date.length == 10 && to_date.length == 10){
		temp1 = del_Slash(from_date);
	    temp2 = del_Slash(to_date);
	}else{
		temp1 = from_date;
	    temp2 = to_date;
	}

    if(temp1.length != 8 && temp2.length != 8) {
    	return false;
    }

	if(eval(temp1) > eval(temp2)){
	 	return false;
	}

	return true;
}

function checkDateBetween2(from_date, to_date)
{

	var temp1 = "";
	var temp2 = "";

	if(from_date.length == 10 && to_date.length == 10){
		temp1 = del_Dash(from_date);
	    temp2 = del_Dash(to_date);
	}else{
		temp1 = from_date;
	    temp2 = to_date;
	}

    if(temp1.length != 8 && temp2.length != 8) {
    	return false;
    }

	if(eval(temp1) > eval(temp2)){
	 	return false;
	}

	return true;
}
function delInputEmpty(name1, name2)
{
	var input_value = LRTrim(document.getElementsByName(name1)[0].value);

	if(input_value.length <= 0)
	{
		document.getElementsByName(name1)[0].value = "";
		document.getElementsByName(name2)[0].value = "";
	}
}

function del_Slash(input)
{
   var s = 0;

    if(input == null || input == "" || input.length == 8)
    {
    	return input;
    }

    for(i=0; i<input.length;i++)
    {
        if(input.charAt(i)=="/")
        {
            s++ ;
        }
    }

	if(s > 0)
	{
	    for(i = 0;i < s; i++)
	    {
	        input = input.replace("/", "");
	    }
	}


    return input;
}

function del_Dash(input)
{
   var s = 0;

    if(input == null || input == "")
    {
    	return input;
    }

    for(i=0; i<input.length;i++)
    {
        if(input.charAt(i)=="-")
        {
            s++ ;
        }
    }

	if(s > 0)
	{
	    for(i = 0;i < s; i++)
	    {
	        input = input.replace("-", "");
	    }
	}


    return input;
}

function setAmtFromNumberToKorea(input, len)
{
	var s = input;
	var b1 = ' 일이삼사오육칠팔구';
    var b2 = '천백십조천백십억천백십만천백십원';
    var tmp = '';
    var cnt = 0;

    if(s.length > eval(len)){
        alert("숫자가 너무 큽니다");
        return;
    } else if(isNaN(s)){
		alert("숫자가 아닙니다");
        return;
    }

    while(s != ''){
        cnt++;
        tmp1 = b1.substring(s.substring(s.length-1,s.length), Number(s.substring(s.length-1,s.length))+1); // 숫자
        tmp2 = b2.substring(b2.length-1,b2.length); // 단위
        if(tmp1==' '){ // 숫자가 0일때
            if(cnt%4 == 1){ // 4자리로 끊어 조,억,만,원 단위일때만 붙여줌
                tmp = tmp2 + tmp;
            }
        } else{
            if(tmp1 == '일' && cnt%4 != 1){ // 단위가 조,억,만,원일때만 숫자가 일을 붙여주고 나머지는 생략 ex) 삼백일십만=> 삼백십만
                tmp = tmp2 + tmp;
            } else{
                tmp = tmp1 + tmp2 + tmp; // 그외에는 단위와 숫자 모두 붙여줌
            }
        }
        b2 = b2.substring(0, b2.length-1);
        s = s.substring(0, s.length-1);
    }

    tmp = tmp.replace('억만','억').replace('조억','조'); // 조,억,만,원 단위는 모두 붙였기 때문에 필요없는 단위 제거

    return tmp;
}

function add_Slash(input)
{
   var yy = "";
   var mm = "";
   var dd = "";
   var output = "";

   if(input == null || input == "" || input.length != 8)
   {
    	return input;
   }

    yy = input.substring(0,4);
    mm = input.substring(4,6);
    dd = input.substring(6,8);

    output = yy + "/" + mm + "/" + dd;

    return output;
}


function add_Slash2(input)
{
   var yy = "";
   var mm = "";
   var dd = "";
   var output = "";

   if(input == null || input == "")
   {
    	return input;
   }

    yy = input.substring(0,4);
    mm = input.substring(5,7);
    dd = input.substring(8,10);

    output = yy + "/" + mm + "/" + dd;

    return output;
}

	/**
	* 작성자	: 김재욱
	* 작성일	: 2010년 7월 14일
	* 설명		: 거래명세서를 팝업으로 띄우는 메소드
	*/
	function openInvoicePrint(inv_number, inv_seq)
	{
		width = 1200;
	    height = 800;
		var left = "";
		var top = "60";

	    //화면 가운데로 배치
	    var dim = new Array(2);

		dim = ToCenter(height,width);
		top = dim[0];
		left = dim[1];

	    var toolbar = 'no';
	    var menubar = 'no';
	    var status = 'yes';
	    var scrollbars = 'yes';
	    var resizable = 'yes';
	    var url =  _POASRM_CONTEXT_NAME+"/procure/purchase_order.jsp?inv_number=" + inv_number + "&inv_seq=" + inv_seq;
		var info = window.open(url, 'PurchaseOrder', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

function grid_width_resize() {

	var gridbox_value = document.getElementById("gridbox");
	if(gridbox_value != null) {
		document.getElementById("gridbox").style.width = 1+"px";
	}
}

/**
 * JSP 페이지에서 폼데이터를 한꺼번에 가져오기 위한 함수
 * @param   param   : DUMMY / JSP에서 호출시 encoding에 값이 들어오면 안됨
 *                    doServiceAjax 함수에서 AJAX때문에 구분(인코딩문제)을 짓기 위한 DUMMY임
 */
function dataOutput( encoding ){
	var table_data = "";
    var obj1 = document.getElementsByTagName("input");
    var obj2 = document.getElementsByTagName("select");
    var obj3 = document.getElementsByTagName("textarea");
    for (var i = 0; i < obj1.length; i++) {
	    if(obj1[i].id != "") {
	    	if(obj1[i].type == "checkbox" || obj1[i].type == "radio" ){
                table_data = table_data + obj1[i].id + _fieldSeparator + document.getElementById(obj1[i].id).checked + _fieldSeparator;
	    	}else{
	    		table_data = table_data + obj1[i].id + _fieldSeparator + document.getElementById(obj1[i].id).value + _fieldSeparator;
	    	}

	    }
    }
	for (var i = 0; i < obj2.length; i++) {
	    if(obj2[i].id != "") {
	    	table_data = table_data + obj2[i].id + _fieldSeparator + document.getElementById(obj2[i].id).value + _fieldSeparator;
	    }
    }
    for (var i = 0; i < obj3.length; i++) {
 	    if(obj3[i].id != "") {

 	      table_data = table_data + obj3[i].id + _fieldSeparator + document.getElementById(obj3[i].id).value.replaceAll("\r\n","\n") + _fieldSeparator;


 	    }
    }

    if( encoding == undefined || encoding == null ) {
        encoding = true;
    }

    if( encoding ) {
        table_data = encodeUrl(LRTrim(table_data));
    }

    return "&"+_SepoaDataMapper_KEY_PARAMS+"=" + table_data;
}

/**
 * 그리드 없는 데이터를 보내기 위해 AJAX를 이용한 공통 함수
 * sepoa.svl.util.SepoaAjax 가 서블릿 역활을 대신함
 * 서비스 호출시 사용하는 파라미터와 동일함
 * *** 파라미터 설명 ***
 * @param   nickName    : 서비스명(필수값)      ex : AD_102
 * @param   conType     : DB연결방법(필수값)    ex : CONNECTION or TRANSACTION
 * @param   methodName  : 메소드명(필수값)      ex : setDelete
 * @param   params      : 옵션(미필수)          / dataOutPut()에 의해 form의 id를 지정한 input 값을 한번에 가져오게 됨
 * @return  SepoaOut    : Service로부터의 리턴 결과
 *                        status(0:실패, 1:성공)값, message(서비스에서 보내주는 메세지), result(서비스에서 보내주는 결과, Array)
 *
 * 함수 호출과 결과 예시
 * var nickName = "AD_102";
 * var conType = "TRANSACTION";
 * var methodName = "setInsert";
 * var SepoaOut = doServiceAjax( nickName, conType, methodName );
 * if( SepoaOut.status == "1" ) { // 성공했을때 메세지 및 처리
 *     alert( SepoaOut.message );
 *     location.href = "test.jsp";
 * } else { // 실패했을때 메세지 및 처리
 *     alert( SepoaOut.message );
 * }
 */
function doServiceAjax( nickName, conType, methodName, params ) {

     /**
     엔터변환 및 각종 공지사항 작성시 encode=true 필요하여 추가
     2013.04.02 송태호과장님
     */
    var url = "&nickName=" + nickName + "&conType=" + conType + "&methodName=" + methodName + "&_encode=true";
	if( params == undefined || params == null ) {
        params = dataOutput( true );
    }

	url = url + params;
	// 서비스 실행 후 리턴받을 객체
    var SepoaOut = Object();

    sendRequest(function(oj) {
        var xmlDoc = oj.responseXML;
        var status_nodes  = xmlDoc.getElementsByTagName("status");
        var message_nodes = xmlDoc.getElementsByTagName("message");
        var result_nodes  = xmlDoc.getElementsByTagName("result");
        var status  = "";
        if(status_nodes[0].firstChild != null) {
        	status  = status_nodes[0].firstChild.nodeValue;
        }
        var message = "";
        if( message_nodes[0].firstChild != null ) {
        	message = message_nodes[0].firstChild.nodeValue;
        }

        var result  = new Array();
        var result_size = result_nodes.length;
        for(var i = 0; i < result_size; i++) {
            if( result_nodes[i].firstChild != null ) {
                result.push(result_nodes[i].firstChild.nodeValue);
            }
        }

        SepoaOut.status = status;
        SepoaOut.message = message;
        SepoaOut.result = result;
    }, url, 'POST', _POASRM_CONTEXT_NAME+'/servlets/sepoa.svl.util.SepoaAjax', false, true );

    return SepoaOut;

}

/**
 * 그리드의 모든 row id를 배열로 반환
 */
function getGridAllRowsId( gridobj ) {
    var grid_array = new Array();
    var ids = gridobj.getAllRowIds();
    if( ids.length > 0 ) {
        grid_array = ids.split(",");
    }
    return grid_array;
}
/**
 * Document 에 SMS 타입 추가
 */
function createSmsField(typeValue){
	if(typeValue == undefined || typeValue == "undefined" || typeValue == null){
		typeValue = "";
	}
    var smsTypeInput = document.createElement("input");
    smsTypeInput.setAttribute("type","hidden");
    smsTypeInput.setAttribute("name","smsType");
    smsTypeInput.setAttribute("id","smsType");
    smsTypeInput.setAttribute("value",typeValue);
    document.appendChild(smsTypeInput);
}

/**
 * 창성에서 추가되었음 --------------------------------------------------------------
 * */
String.prototype.replaceAll = replaceAll;
function replaceAll(strValue1, strValue2) {
    var strTemp = this;
    strTemp = strTemp.replace(new RegExp(strValue1, "g"), strValue2);
    return strTemp;
}

function refererGo(url) {
	var linkObj = document.createElement("a");
	if (typeof (linkObj.click) == "undefined"
			|| typeof (linkObj.click) == "function") {
		window.location.href = url; // Not IE
	} else {
		linkObj.href = url;
		var body = document.body;
		if(body == null){
			body = document.createElement("body");
		}
		body.appendChild(linkObj);
		linkObj.click(); // Only IE
	}
}




/**
 * 동아에서 추가되었음 --------------------------------------------------------------
 * radio button 의 값 가져오기.
 * */
function getRadioValue( objRadio ) {
	var rtnData = '';
	
    for( var i = 0 , iMax = objRadio.length ; i < iMax ; i++ ){
    	if( objRadio[i].checked ){
    		rtnData = objRadio[i].value;
    		
    		break;
    		
    	} // end if
    	
    } // end for
    
    return rtnData;

} // end of function getRadioValue

/*전자입찰에서 사용 2014.09.22 추가*/
/*입력값의 맥스길이를 byte 단위로 체크한다.
maxByte : 실제 디비컬럼 byte
obj	    : input 객체
name	: 입력초과시 알려줄 항목명
errorMsg: 특정한 에러메세지를 보여줄 경우
예) <input type="text" name="subject" style="width:95%" class="input_re" value="" onKeyUp="return chkMaxByte(500, this, '제목');">

*/
function chkMaxByte(maxByte, obj, name, errorMsg)
{
var j, han = 0 , eng = 0, total = 0;
var i, han_orgin = 0 , eng_orgin = 0, total_orgin = 0, originStr = "";
var chkstr = obj.value;


for (j=0; j<chkstr.length; j++){
    if (chkstr.charCodeAt(j) > 255){
        han = han + 3;
    }else {
    	eng = eng + 1;
    }

}
total = han + eng;
if( total > maxByte ){
    if(errorMsg == '' || errorMsg == null) {
		alert(""+name+"의 입력값이 초과 되었습니다.");
    } else {
		alert(errorMsg);
    }
	for (i=0; i<chkstr.length; i++){
    	if (chkstr.charCodeAt(i) > 255){
        	han_orgin = han_orgin + 3;
    	}else {
    		eng_orgin = eng_orgin + 1;
    	}

    	total_orgin =  han_orgin + eng_orgin;
    	if(total_orgin <= maxByte){
    		originStr += chkstr.charAt(i);
    	}
	}

	obj.value =  originStr;

	return false;
}
return true;
}

/*
<input type="text" name="min_order_qty" size="15" class="inputsubmit_right" value="" maxlength="17" onKeyPress="checkNumberFormat('[0-9.]', this)">
한글 : [^가-?]

*/
function checkNumberFormat(sFilter, obj) {

	var sKey = String.fromCharCode(event.keyCode);
	var re = new RegExp(sFilter);

	if(sKey != "\r" && !re.test(sKey)) {
		event.returnValue = false;
	}
}


/*
val : 대상숫자, pos : 원하는 소수점 이하 자리수
예제)
	RoundEx(10.25, 2)
*/
function RoundEx(val, pos)
{
var rtn;
rtn = Math.round(val * Math.pow(10, Math.abs(pos)-1))
rtn = rtn / Math.pow(10, Math.abs(pos)-1)


return rtn;
}


/*금액 소수점 무조건 버림*/
function setAmt(value) {
	rlt = 0;
	if(value == "" || value == 0) return 0;

	rlt = Math.floor(new Number(value) * 1) / 1;

	return rlt;
}

/*수량 소수점*/
function setQty(value) {
	rlt = 0;
	if(value == "" || value == 0) return 0;

	rlt = Math.round(new Number(value) * 1000000) / 1000000;

	return rlt;
}

/*금액 계산
 * gridObj       : GridObj
 * row           : GridObj.getRowIndex(GridObj.getSelectedId());
 * cnt           : 수량 컬럼 Index
 * unit          : 단위컬럼 Index
 * exchangerate  : 환율값
 * amt           : 합계 컬럼명 
 */
function calculate_grid_amt(gridObj, row, cnt, unit, exchangerate, amt){
	
	var v_cnt                 = GD_GetCellValueIndex(gridObj, row, cnt);
	var v_unit                = GD_GetCellValueIndex(gridObj, row, unit);
	if(exchangerate == null) exchangerate = 1;
	
	gridObj.cells(gridObj.getRowId(row), gridObj.getColIndexById(amt)).setValue(RoundEx(v_cnt * v_unit * exchangerate, 3));	
	
}  



/**
 * @메소드명 : gridSelectAll()
 * @변경이력 :
 * @메소드 설명 : 전체선택 > 전체선택되어 있는 경우 클릭하면 전체선택 해제
 */

function gridSelectAll(){
if(selectAllFlag == 0)
{
	for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
	{
		GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("1"); 
	}
	selectAllFlag = 1;
}
else
{
	for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
	{
		GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("0");
	}
}
}