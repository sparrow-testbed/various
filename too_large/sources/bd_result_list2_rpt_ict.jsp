<%@page import="org.apache.commons.collections.MapUtils"%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%!
private String trns(int cnt) throws Exception{
	StringBuilder sbData = new StringBuilder();
	
	for(int i=0; i<cnt; i++) {
		sbData.append(" ");
	}
	return sbData.toString();
}

private String nvl(String str) throws Exception{
	String result = null;
	
	result = this.nvl(str, "");
	
	return result;
}

private String nvl(String str, String defaultValue) throws Exception{
	String result = null;
	
	if(str == null){
		str = "";
	}
	
	if(str.equals("")){
		result = defaultValue;
	}
	else{
		result = str;
	}
	
	return result;
}

private boolean isAdmin(SepoaInfo info){
	String  adminMenuProfileCode = null;
	String  menuProfileCode      = null;
	String  propertiesKey        = null;
	String  houseCode            = info.getSession("HOUSE_CODE");
	boolean result               = false;
	
	try {
		menuProfileCode      = info.getSession("MENU_PROFILE_CODE");
		menuProfileCode      = this.nvl(menuProfileCode);
		propertiesKey        = "wise.all_admin.profile_code." + houseCode;
		adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);
		
   		if (menuProfileCode.equals(adminMenuProfileCode)){
   			result = true;
    	} else {
   			propertiesKey        = "wise.admin.profile_code." + houseCode;
			adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);
		
			if (menuProfileCode.equals(adminMenuProfileCode)){
    			result = true;
	    	} else {
				propertiesKey        = "wise.ict_admin.profile_code." + houseCode;
				adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);

				if (menuProfileCode.equals(adminMenuProfileCode)){
	    			result = true;
			    }
			}
    	}
	} catch (Exception e) {
		result = false;
	}
	
	return result;
}
%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_BD_020");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_BD_020";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	

	Config conf 			= new Configuration();
	
	
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020325/rpt_bd_result_list2_ict"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
    //////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
    
	
    String  to_day      	= SepoaDate.getShortDateString();
    String  from_date   	= SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateDay( to_day, -30 ) );
    String  to_date     	= SepoaString.getDateSlashFormat( to_day );
 				 
	String HOUSE_CODE 		= info.getSession("HOUSE_CODE");
	String COMPANY_CODE 	= info.getSession("COMPANY_CODE");
	String USER_ID 			= info.getSession("ID");

	String current_date 	= SepoaDate.getShortDateString();//현재 시스템 날짜
	String current_time 	= SepoaDate.getShortTimeString();//현재 시스템 시간
	
	boolean isAdmin = this.isAdmin(info);

	String BIZ_NO = JSPUtil.nullToRef(request.getParameter("BIZ_NO"), "");	//사업번호
    
    
    Map map = new HashMap();
	map.put("BIZ_NO"		, BIZ_NO);
	
	Object[] obj = {map};
	SepoaOut value = ServiceConnector.doService(info, "I_BD_027", "CONNECTION","getRptBdResult", obj);
	
	SepoaFormater wf1 = new SepoaFormater(value.result[0]); 
	SepoaFormater wf2 = new SepoaFormater(value.result[1]); 
	SepoaFormater wf3 = new SepoaFormater(value.result[2]); 
	
	//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
	_rptData.append(wf1.getValue("BIZ_NM" , 0));
	_rptData.append(_RF);
	_rptData.append(wf1.getValue("BID_DTTM" , 0));
	_rptData.append(_RD);
	for(int i=0; i<wf2.getRowCount(); i++) {
		_rptData.append(wf2.getValue("ANN_NO",i));
		_rptData.append(_RF);
		_rptData.append(wf2.getValue("CONT_TYPE2",i));
		_rptData.append(_RF);
		_rptData.append(wf2.getValue("MATERIAL_CLASS2_TEXT",i));
		_rptData.append(_RF);
		_rptData.append(wf2.getValue("VENDORS_NAME",i));
		_rptData.append(_RF);
		_rptData.append(wf2.getValue("VENDOR_NAME",i));
		_rptData.append(_RF);
		_rptData.append(wf2.getValue("BZBG_AMT",i));
		_rptData.append(_RF);
		_rptData.append(wf2.getValue("FINAL_ESTM_PRICE",i));
		_rptData.append(_RF);
		_rptData.append(wf2.getValue("SUM_AMT",i));
		_rptData.append(_RL);
	}//for Row갯수만큼...
	_rptData.append(_RD);
	
	int loopCnt1 = 0;
	int loopCnt2 = 0;
	int gpCnt = 0;
	String sANN_NO = "";
	String sCONT_TYPE2 = "";
	String sBDVO_VOTE_COUNT = "";
	int iVENDOR_COUNT = 0;
	
    for(int j=0; j<wf3.getRowCount(); j++) {
		if(!sANN_NO.equals(wf3.getValue("ANN_NO",j))&&!sCONT_TYPE2.equals(wf3.getValue("CONT_TYPE2",j))&&!sBDVO_VOTE_COUNT.equals(wf3.getValue("BDVO_VOTE_COUNT",j))){
			loopCnt1 = 0;
			//gpCnt = Integer.parseInt(wf3.getValue(j,7));
			sANN_NO = wf3.getValue("ANN_NO",j);
			sCONT_TYPE2 = wf3.getValue("CONT_TYPE2",j);
			sBDVO_VOTE_COUNT = wf3.getValue("BDVO_VOTE_COUNT",j);
			iVENDOR_COUNT = Integer.parseInt(wf3.getValue("VENDOR_COUNT",j)); 
			if("TA".equals(sCONT_TYPE2)){
				gpCnt = iVENDOR_COUNT * 3;
				if(gpCnt <= 15){
					loopCnt2 = 15 - gpCnt;
				}else if(gpCnt <= 30){
					loopCnt2 = 30 - gpCnt;
				}else if(gpCnt <= 45){
					loopCnt2 = 45 - gpCnt;
				}else if(gpCnt <= 60){
					loopCnt2 = 60 - gpCnt;
				}else if(gpCnt <= 75){
					loopCnt2 = 75 - gpCnt;
				}else if(gpCnt <= 90){
					loopCnt2 = 90 - gpCnt;
				}
			}else{
				gpCnt = iVENDOR_COUNT;
				if(gpCnt <= 5){
					loopCnt2 = 5 - gpCnt;
				}else if(gpCnt <= 10){
					loopCnt2 = 10 - gpCnt;
				}else if(gpCnt <= 15){
					loopCnt2 = 15 - gpCnt;
				}else if(gpCnt <= 20){
					loopCnt2 = 20 - gpCnt;
				}else if(gpCnt <= 25){
					loopCnt2 = 25 - gpCnt;
				}else if(gpCnt <= 30){
					loopCnt2 = 30 - gpCnt;
				}
			}
		}//end if
		_rptData.append(wf3.getValue("ANN_NO",j));
		_rptData.append(_RF);
		_rptData.append(wf3.getValue("BDVO_VOTE_COUNT",j));
		_rptData.append(_RF);
		_rptData.append(wf3.getValue("GB_AMT",j));
		_rptData.append(_RF);
		_rptData.append(wf3.getValue("VENDOR_NAME",j));
		_rptData.append(_RF);
		if("Y".equals(wf3.getValue("BID_CANCEL_FLAG",j))){
			_rptData.append(wf3.getValue("BID_AMT",j));
			_rptData.append("<BR><C.RED>(입찰취소)</C>");			
		}else{
			_rptData.append(wf3.getValue("BID_AMT",j));			
		}
		_rptData.append(_RF);
		_rptData.append(wf3.getValue("RESULT",j));
		_rptData.append(_RL);	
		
		loopCnt1++;
		
		//Logger.sys.println("############## loopCnt1 = " + loopCnt1);
		//Logger.sys.println("############## gpCnt = " + gpCnt);
		
		if(loopCnt1 == gpCnt){
			if("TA".equals(sCONT_TYPE2)){
				int cnt1 = 0;
				String a = " ";
				for(int k=0; k<loopCnt2; k++) {		
					_rptData.append(sANN_NO);
					_rptData.append(_RF);
					_rptData.append(sBDVO_VOTE_COUNT);
					_rptData.append(_RF);
					if((k+3)%3 == 0){
						_rptData.append("물품금액");						
					}else if((k+3)%3 == 1){
						_rptData.append("유지보수");
					}else if((k+3)%3 == 2){
						_rptData.append("총금액");
					}					
					_rptData.append(_RF);
					//_rptData.append(trns(k+1));
					_rptData.append(a);
					_rptData.append(_RF);
					_rptData.append(a);
					_rptData.append(_RF);
					_rptData.append(a);
					_rptData.append(_RL);
					
					cnt1+=1;
					if(cnt1 == 3){
						a += " ";
						cnt1 = 0;
					}
				}	
			}else{
				for(int k=0; k<loopCnt2; k++) {
					_rptData.append(sANN_NO);
					_rptData.append(_RF);
					_rptData.append(sBDVO_VOTE_COUNT);
					_rptData.append(_RF);
					_rptData.append("총금액");
					_rptData.append(_RF);
					_rptData.append(trns(k+1));
					_rptData.append(_RF);
					_rptData.append(trns(k+1));
					_rptData.append(_RF);
					_rptData.append(trns(k+1));
					_rptData.append(_RL);	
				}	
			}
			
			loopCnt1 = 0;
			loopCnt2 = 0;
			gpCnt = 0;
			sANN_NO = "";
			sCONT_TYPE2 = "";
			sBDVO_VOTE_COUNT = "";
		}
	}
    //////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////
	
	Logger.sys.println("############## _rptData = " + _rptData.toString().replaceAll("\"", "&quot"));							
%>
 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%> 
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript" type="text/javascript">
var explanation_modify_flag = "false";
var button_flag 	= false;
var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var current_date = "<%=current_date%>";
var current_time = "<%=current_time%>";

var j=0;

function init() {
	setGridDraw();
}

function setGridDraw(){
    GridObj_setGridDraw();
    GridObj.setSizes();
}
 
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{

}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj)
{
}
 
function doQuery() {
	 
	 
}
function doQueryEnd() {

}

/**
 * 일반경쟁, 지명경쟁에 따른 업체지정
 */
 
function setVisibleVendor() {

}

function delVendorRow(){

}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint() {
	var url = "/ClipReport4/ClipViewer.jsp";
	document.form.method = "POST";
	document.form.action = url;
	document.form.target = "ClipReport4";
	document.form.submit(); 
}
</script>

</head>
<body bgcolor="#FFFFFF" text="#000000" onload="clipPrint();">
<s:header popup="true">
	<!--내용시작-->
<form id="form" name="form" onload="init();">	
	<%--ClipReport4 hidden 태그 시작--%>
	<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
	<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">	
	<%--ClipReport4 hidden 태그 끝--%>	



</form>
<!---- END OF USER SOURCE CODE ---->
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;display:none"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="BD_001" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
<iframe id="Some" src="/sourcing/empty.htm"  width="0%" height="0" border=0 frameborder=0></iframe>
</body>
</html> 