function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

/*
function btn(a,b,c){
	if(c != null && c != "undefined" && c == "disabled") {
		document.write ("<table cellpadding=0 cellspacing=0 border=0 height=20 style='cursor:pointer;cursor:hand;' disabled><tr><td width=9 class=btn_left>");
	} else {
		document.write ("<table cellpadding=0 cellspacing=0 border=0 height=20 onClick="+a+" style='cursor:pointer;cursor:hand;'><tr><td width=9 class=btn_left>");
	}
	document.write ("<td class=btn_txt valign=center>"+b+"</td><td width=9 class=btn_right></td></tr></table>");
}*/

//작성중
var jQueryButtonId = 1;

//a : 함수이름  예) javascript:doQuery()
//c : 텍스트, 예) 조회
//e : 사용하지 않는 함수인 경우
function btn(a,c,e){
	
	document.write ("<table cellpadding='0' cellspacing='0' border='0' height='22' id='jQueryButton"+jQueryButtonId +"' style='cursor:hand'>");
	document.write (	"<tr>");
	document.write (		"<td width='8' class='btn_left'></td>");
	document.write (		"<td class='btn_txt' valign='bottom'>"+c+"</td>");
	document.write (		"<td width='8' class='btn_right'></td>");
	document.write (	"</tr>");
	document.write ("</table>");
	
	if(e != null && e != "undefined" && e == "disabled") {
		//document.write("<span class='btn_big' href='#' disabled><span>"+c+"</span></span>");
	}
	else{
		document.write("<script type='text/javascript'> $(document).ready(function(){ $('#jQueryButton"+jQueryButtonId+"').click(function(){ ");
		
		document.write("if(btnValidate()){ ");
		document.write(a+";");
		document.write("}");
		
		document.write(" }); }); </script>");
	}
	
	jQueryButtonId++;
}
function btn_id(id, func, txt){
	document.write ("<table cellpadding=0 cellspacing=0 border=0 height=22 id='"+id+"' onClick="+func+" style=cursor:hand><tr><td width=1 class=btn_left>");
	document.write ("<td class=btn_txt valign=bottom>"+txt+"</td><td width=3 class=btn_right></td></tr></table>");
}

function btnValidate(functionA){
	//grid가 존재할 경우
	var existGrid = document.getElementById("gridbox");
	if(existGrid != null){
		//alert("그리드가 있는 화면에서의 동작");
		//그리드가 완전히 그려졌는지 확인한다.
		//그리드가 완전히 그려졌으면, name=setGridDrawEnd : value='true' 이렇게 된다.
		//그리드 관련 validation 
		var temp = document.form_footer.setGridDrawEnd.value;
		if(temp != null){
			if(temp == 'false'){
				alert('화면이 완전히 로드된 후 이용하여 주시기 바랍니다.');
				return false;
			}
		}
	}else{
		//alert("그리드가 없는 화면에서의 동작");
		//일반함수 관련 validation 추가 해서 성립하지 않으면 return false
	}

	//validation에 아무 이상없으면 
	return true;
}

function btn_s(a,b){
	document.write ("<table cellpadding=0 cellspacing=0 border=0 height=21 onClick="+a+" style=cursor:hand><tr><td width=2>");
	document.write ("<img src=../images/btn_s_left.gif></td>");
	document.write ("<td class=btn_s_txt valign=center>"+b+"</td><td width=2><img src=../images/btn_s_right.gif></td></tr></table>");
}
function tab_off(a,b){
	document.write ("<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="+a+" style=cursor:hand><tr><td width=3>");
	document.write ("<img src=../images/tab_left_off.gif></td>");
	document.write ("<td class=tab_txt_off valign=center>"+b+"</td><td width=4><img src=../images/tab_right_off.gif></td></tr></table>");
}
function tab_on(a,b){
	document.write ("<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="+a+" style=cursor:hand><tr><td width=3>");
	document.write ("<img src=../images/tab_left_on.gif></td>");
	document.write ("<td class=tab_txt_on valign=center>"+b+"</td><td width=4><img src=../images/tab_right_on.gif></td></tr></table>");
}
function txt(s) {
	document.write( s );
}
function insert_swf(fname,w,h,hspace){
document.write("<object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000' codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0' name='SUB_MENU' width='"+w+"' height='"+h+"' id='SUB_MENU'>");
document.write("<param name='allowScriptAccess' value='sameDomain' />");
document.write("<param name='movie' value='../images/"+fname+"'>");
document.write("<param name='loop' value='false' />");
document.write("<param name='menu' value='false' />");
document.write("<param name='quality' value='high' />");
document.write("<param name='wmode' value='transparent'/>");
document.write("<embed src='../images/"+fname+"' width='"+w+"' height='"+h+"' quality='high'  hspace='"+hspace+"' pluginspage='http://www.macromedia.com/go/getflashplayer' type='application/x-shockwave-flash' name='SUB_MENU'></embed>");
document.write("</object>");
}