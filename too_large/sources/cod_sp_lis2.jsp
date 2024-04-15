<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_T04_2");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_T04_2";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--  /t_system1/wise/vaatz_package/myserver/V1.0.0/wisedoc/kr/admin/wisepopup/cod_sp_lis2.jsp -->
<!--
 Title:        		cod_pp_lis2.jsp <p>
 Description:  	코드 POPUP<p>
 Copyright:    	Copyright (c) <p>
 Company:     ICOMPIA <p>
 @author       	DEV.Team Hong Sun Hee<p>
 @version      1.0.0<p>
 @Comment    Code Search<p>
!-->
<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID="PR_T04_2";%>

<!-- 개발자 정의 모듈 Import 부분 -->
<%@ page import="java.util.*"%>
<%
	String code     = JSPUtil.nullToEmpty(request.getParameter("code"));	//CODE ID
	String function = JSPUtil.nullToEmpty(request.getParameter("function"));	//CODE ID
	
	if (function == null) function = "";

	//N : Null Return되는 값없이 조회만 할 경우
	//D : 기본적으로 제공하는 Function Name을 이용
	//"function name" : User가 정한 Function Name으로 연결한다.

	String width = JSPUtil.nullToEmpty(request.getParameter("width")); //Table Width
	width = String.valueOf(Integer.parseInt(width)-40);

	//SQL문에 Mapping될 Value
//	String[] values = JSPUtil.koForArray(request.getParameterValues("values"));
	String[] values = request.getParameterValues("values");



//	Logger.debug.println(info.getSession("ID"),this,"code===>"+code);
//	Logger.debug.println(info.getSession("ID"),this,"values.length===>"+values.length);
	
	boolean bFlag = false;
	if (values != null)  {
		for (int i = 0; i < values.length; i++)  {

			Logger.debug.println(info.getSession("ID"),this,"코드 values["+i+"]===>"+values[i]);

			if (values[i] == null)  values[i] = "";
			
			if (values[i].indexOf("'") >= 0 || values[i].indexOf("%") >= 0 || values[i].indexOf("!") >= 0 || values[i].indexOf("-") >= 0 || values[i].indexOf("#") >= 0) {
				bFlag = true;
				break;
			}
		}
	}
	if(bFlag){
%>
<script language="javascript">
<!--
	alert("특수문자 입력불가");
//-->
</script>
<% 
		return;	
	}
	
	
	
	bFlag = false;
	if (function != null)  {
		
		if (function.indexOf("'") >= 0 || function.indexOf("%") >= 0 || function.indexOf("!") >= 0 || function.indexOf("-") >= 0 || function.indexOf("#") >= 0) {
			bFlag = true;
		}

	}

	if(bFlag){
%>
<script language="javascript">
<!--
	alert("특수문자 입력불가");
//-->
</script>
<% 
		return;	
	}
	
	
	
	
	bFlag = false;
	if (code != null)  {
		
		if (code.indexOf("'") >= 0 || code.indexOf("%") >= 0 || code.indexOf("!") >= 0 || code.indexOf("-") >= 0 || code.indexOf("#") >= 0) {
			bFlag = true;
		}

	}

	if(bFlag){
%>
<script language="javascript">
<!--
	alert("특수문자 입력불가");
//-->
</script>
<% 
		return;	
	}
	
	
	
	
	//팝업이 뜨자마자 자동으로 조회 될것인지 말것인지 구분
	//main frame jsp(cod_cm_lis1)에서 불릴때는 DB에서 읽어와서 이 값을 설정한다.
	//top frame jsp(cod_sp_lis3)에서 불릴때는 Y값으로 설정되어 조회가 가능하게 한다.
	String auto_flag = JSPUtil.nullToEmpty(request.getParameter("auto_flag"));


	if (auto_flag == null || "".equals(auto_flag)) auto_flag = "Y";

	Object[] obj = {code, values};
	String nickName = "p6032";
	String conType = "CONNECTION";
	String methodName = "getCodeSearch";

	SepoaRemote w_remote = null;
	SepoaRemote wr_column = null;

	SepoaOut value = null;
	SepoaOut column = null;

	if (auto_flag.equals("Y"))
	{
		try {
			w_remote = new SepoaRemote(nickName, conType,info);
			value = w_remote.lookup(methodName, obj);

			Logger.debug.println(info.getSession("ID"),"code=======>> "+code);
			Logger.debug.println(info.getSession("ID"),"value=======>> "+value);
			/*
			if(value.status == 1) {
				for(int i = 0 ; i < value.result.length ; i++) Logger.debug.println("value=====>"+value.result[i]);
			}
			*/
		}catch(Exception e) {
			Logger.debug.println(info.getSession("ID"),"e = " + e.getMessage());
			Logger.debug.println(info.getSession("ID"),"message = " + value.message);
			Logger.debug.println(info.getSession("ID"),"status = " + value.status);
		} finally {
			w_remote.Release();
		}


		//컬럼Count 정보조회
		methodName = "getCodeColumn";
		Object[] obj_column = {code};
		try {
			wr_column = new SepoaRemote(nickName, conType, info);
			column = wr_column.lookup(methodName, obj_column);
		} catch(Exception e) {
			Logger.debug.println(info.getSession("ID"),"e = " + e.getMessage());
		} finally {
			wr_column.Release();
		}
	}//end if
	%>
<html>
<head>
<title>Code_Search</title>
<script language="javascript">
<!--
<%

if (auto_flag.equals("Y"))
{
      	if(value.status == 1) { // 성공적으로 조회
			SepoaFormater wf = new SepoaFormater(value.result[0]);
			String script = "";
			if(wf.getRowCount() != 0) {	//조회된 데이타가 없을 경우.
				String[] result = new String[wf.getColumnCount()];

				for(int i=0; i<1; i++) { //조회된 컬럼개수만큼 스트립트 파라미터를 구성한다.
	 				//Script function parameter를 구성
	   				for(int j=0; j<wf.getColumnCount(); j++) {
						result[j] = wf.getValue(i,j);
						script += "v"+j+",";
					}
					
					script = script.substring(0, script.length()-1);//마지막에 있는 ","제거
					
%>
     function select(<%=script%>){
    <%
    	//Default function Name을 설정한다.
    	if(function.equals("D")){
    	%>parent.parent.opener.<%=code%>_getCode(<%=script%>);<%
		}else if(!(function.equals("N")) && !(function.equals("D"))){
		%>parent.parent.opener.<%=function%>(<%=script%>);<%
		}
	%>
        parent.parent.close();
    }
<%
            }//for 조회된 컬럼개수만큼 스크립트 파라미터를 구성한다.
           }//if 조회된 데이타가 없을 경우
         }// if  성공적으로 조회

}//end if
%>
//-->
</script>



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP
<%@ include file="/include/sepoa_grid_common.jsp"%>
--%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
	
    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    
    return false;
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj)
{
    var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode");
    var status   = obj.getAttribute("status");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }

    if(status == "true") {
        alert(messsage);
        doQuery();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    } 

    return false;
}

// 엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
// 복사한 데이터가 그리드에 Load 됩니다.
// !!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function doExcelUpload() {
    var bufferData = window.clipboardData.getData("Text");
    if(bufferData.length > 0) {
        GridObj.clearAll();
        GridObj.setCSVDelimiter("\t");
        GridObj.loadCSVString(bufferData);
    }
    return;
}

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">


<!--내용시작-->

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<form name="form" >
<%
	if (auto_flag.equals("Y")) {
		if(value.status == 1) { // 성공적으로 조회
			SepoaFormater wf = new SepoaFormater(value.result[0]);
			int st_count = 0; //화면에 보여질 Coulumn의 개수.

			if(wf.getRowCount() != 0) {	//조회된 데이타가 없을 경우.
				String[] result = new String[wf.getColumnCount()];

				for(int i=0; i<wf.getRowCount(); i++) {
					if((i % 2) == 0 ) { 
%>
<tr>
<%
					} else {
%>
<tr>
<%
					}
					///////////////////////////////////////////////////////
	   				//Script function parameter를 구성
	   				///////////////////////////////////////////////////////
	      			String script = "";
	     			for(int j=0; j<wf.getColumnCount(); j++) {
						result[j] = wf.getValue(i,j);
						//이부분 처리 이상합니다. 확인要
						if (result[j].equals("null")) result[j] = "";
						
						result[j] = SepoaString.replace(result[j] , "\"", "'");
						script += "'"+SepoaString.replace(result[j] , "'", "\\'")+"',";
					}
					script = script.substring(0, script.length()-1);//마지막에 있는 ","제거

					///////////////////////////////////////////////////////
					//ColumnCount보다 큰 데이타들은 Hidden으로 처리한다.
					///////////////////////////////////////////////////////
		   			SepoaFormater wf_column = new SepoaFormater(column.result[0]);
					String tmp = wf_column.getValue("TEXT3",0);
		 			SepoaStringTokenizer st_column = new SepoaStringTokenizer(tmp,"#");
					st_count = st_column.countTokens();

					///////////////////////////////////////////////////////
					//Column별 Data View
					///////////////////////////////////////////////////////
	      			for(int j=0; j<wf.getColumnCount(); j++) {
						result[j]   = wf.getValue(i,j);
						if (result[j].equals("null")) result[j] = "";

						int td_width = Integer.parseInt(width) / st_count; // td_width 각 칼럼별 Size

						//ColumnCount보다 열이 크면 Hidden으로 처리한다.
						if((st_count-1) >= j ) {
%>
	<td class="c_data_1_p_c" width = "<%=td_width%>">&nbsp;<a href="javascript:select(<%=script%>)"><%=result[j]%></a></td>
<% 	
						} else {
%>
		<input type="hidden" name="values" value="<%=result[j]%>">
<% 	
						} //ColumnCount보다 열이 크면 Hidden으로 처리한다. %>
<%
					}
%>
</tr>
<%
				}// for
            }//if Row의 개수가	"0"일 경우
            else { 
%>
<tr>
	<td class="c_data_1_p_c" cellpadding="<%=st_count%>">
<%
				if ( info.getSession( "LANGUAGE" ).equals( "KO" )) {
%>
		<div align="center">조회한 조건으로 데이타가 없습니다.</div>
<%
				} else {
%>
      	<div align="center">No data found.</div>
<%
				}
%>
	</td>
</tr>
<% 
			}//if%>
<%
		}// if 
%>
<%
	}  else {
%>
<tr>
	<td class="c_data_1_p_c">
<% 
		if ( info.getSession( "LANGUAGE" ).equals( "KO" )) {
%>
      		<div align="center">조회 조건을 넣고 조회하십시요.</div>
<%
		} else {
%>
			<div align="center">Please, enter keyword for query.</div>
<%
		}
%>
	</td>
</tr>
<%
	}
%>
</table>

</form>
<%--
<s:header>
</s:header>
<s:grid screen_id="PR_T04_2" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
 --%>
</body>
</html>
