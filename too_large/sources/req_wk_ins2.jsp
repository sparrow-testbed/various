<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("t0002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "t0002";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
 <% String WISEHUB_PROCESS_ID="t0002";%>
<% String WISEHUB_LANG_TYPE="KR";%>
<%@ include file="/include/wisehub_session.jsp" %>
<%@ include file="/include/wisehub_auth.jsp" %>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/wisehub_common.jsp"%> 
<%@ include file="/include/wisehub_scripts.jsp"%>
<%@ include file="/include/wisehub_common.jsp" flush="true" %>
<%@ include file="/include/admin_common.jsp" flush="true" %>
<%@ include file="/include/wisetable_scripts.jsp"%>
<%
	String user_id          		= info.getSession("ID");
	String user_name_loc    		= info.getSession("NAME_LOC");
	String user_name_eng    		= info.getSession("NAME_ENG");
	String user_dept        		= info.getSession("DEPARTMENT");
	String company_code     		= info.getSession("COMPANY_CODE");
	String house_code       		= info.getSession("HOUSE_CODE");
	 
	String HOUSE_CODE			= house_code;
	String REQ_ITEM_NO			= JSPUtil.nullToEmpty(request.getParameter("REQ_ITEM_NO")			  );
	String DESCRIPTION_LOC		= JSPUtil.nullToEmpty(request.getParameter("DESCRIPTION_LOC")			  );	
	String SPECIFICATION		= JSPUtil.nullToEmpty(request.getParameter("SPECIFICATION")			  );	
	
	String MAKER_FLAG        	= JSPUtil.nullToEmpty(request.getParameter("MAKER_FLAG")		  );
	String MAKER_CODE   		= JSPUtil.nullToEmpty(request.getParameter("MAKER_CODE")  );
	String MAKER_NAME           = JSPUtil.nullToEmpty(request.getParameter("MAKER_NAME")          ); 
	String ATTACH_COUNT			= JSPUtil.nullToEmpty(request.getParameter("ATTACH_COUNT")               );
	String Z_ITEM_DESC			= JSPUtil.nullToEmpty(request.getParameter("Z_ITEM_DESC")               );
	String REMARK				= JSPUtil.nullToEmpty(request.getParameter("REMARK")               );
	
	String MATERIAL_TYPE		= JSPUtil.nullToEmpty(request.getParameter("MATERIAL_TYPE")           );
	String MATERIAL_CTRL_TYPE	= JSPUtil.nullToEmpty(request.getParameter("MATERIAL_CTRL_TYPE")           );
	String MATERIAL_CLASS1		= JSPUtil.nullToEmpty(request.getParameter("MATERIAL_CLASS1")           );
	String MATERIAL_CLASS2		= JSPUtil.nullToEmpty(request.getParameter("MATERIAL_CLASS2")         ); 
	String ITEM_ABBREVIATION	= JSPUtil.nullToEmpty(request.getParameter("ITEM_ABBREVIATION")            );
	String BASIC_UNIT			= JSPUtil.nullToEmpty(request.getParameter("BASIC_UNIT")               );
	String APP_TAX_CODE			= JSPUtil.nullToEmpty(request.getParameter("APP_TAX_CODE")          );
	String ITEM_BLOCK_FLAG		= JSPUtil.nullToEmpty(request.getParameter("ITEM_BLOCK_FLAG")          );
	String MODEL_FLAG           = JSPUtil.nullToEmpty(request.getParameter("MODEL_FLAG")          );
	String MODEL_NO				= JSPUtil.nullToEmpty(request.getParameter("MODEL_NO")             );
	String REQ_USER_ID			= JSPUtil.nullToEmpty(request.getParameter("REQ_USER_ID")                 );
	String ADD_USER_ID			= JSPUtil.nullToEmpty(request.getParameter("ADD_USER_ID")       );
	String ADD_USER_NAME_LOC	= JSPUtil.nullToEmpty(request.getParameter("ADD_USER_NAME_LOC")       );
	String CHANGE_USER_ID		= JSPUtil.nullToEmpty(request.getParameter("CHANGE_USER_ID")               );
	String CHANGE_USER_NAME_LOC	= JSPUtil.nullToEmpty(request.getParameter("CHANGE_USER_NAME_LOC")             );
	String ATTACH_NO            = JSPUtil.nullToEmpty(request.getParameter("ATTACH_NO")			);
	  
	//if(MAKER_FLAG.equals("Y"))  MAKER_CODE = "380"; 
	                  
        	String HeaderData[][] = new String[1][];
	        String Data[]        ={  DESCRIPTION_LOC       
									 , BASIC_UNIT            
									 , Z_ITEM_DESC
									 , ITEM_ABBREVIATION       
									 , ""
									 , ""
									 , ""
									 , SPECIFICATION
									 , MAKER_CODE
									 , MAKER_NAME 
									 , REMARK
									 , APP_TAX_CODE
									 , ""
									 , ""  
									 , ITEM_BLOCK_FLAG 	
									 , MAKER_FLAG 		    
									 , MODEL_FLAG 		    
									 , MODEL_NO 
									 , ATTACH_NO		    
									 }; 
	        
	    HeaderData[0]   = Data;
	       
		String Z_STR_BIN = "";
		String ITEM_NO = "";
		String MODE = "";
		String DETAIL_FLAG ="Y";
		String SIGN_STATUS ="P";
		 
		Object[] obj =  {REQ_ITEM_NO, HeaderData};

	WiseOut value = ServiceConnector.doService(info, "t0002", "TRANSACTION", "real_upd1_setInsert3", obj);
 %>


<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<meta http-equiv="Content-Type" content="text/html; charset=EUC-kr">
<link rel="stylesheet" href="../../../css/<%=info.getSession("HOUSE_CODE")%>/body_create.css" type="text/css">

<Script language="javascript">

function Init()
{
	parent.doSave("<%=value.message%>", "<%=value.status%>");
}

</Script>


<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onload="Init();">

<s:header>
<!--내용시작-->
</body>
</html>

</s:header>
<s:grid screen_id="t0002" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>


